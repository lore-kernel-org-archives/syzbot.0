Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7EF13ACA41;
	Fri, 18 Sep 2026 14:34:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789742068; cv=none; b=jY+zFhC/hDse2hXhjGAcP7LYTRKgJck7YtSbr2Un/YzjA7Fhx1rb6xT6g4kMiKqcyRjfzx7XjgQBwc1GZ7vTMk7KyGR6hgwfKa4xZxj3RIOFC7Uv3JNbkAVoGX+2gOQtuFJGsqQlx8zKOntHYAruED/WYnFhdCzHiRV6tuN/0QU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789742068; c=relaxed/simple;
	bh=JwnxHTha4dp87MjmNtDQGDajXNNFtNTVpecKNz9mZL8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=k3b1/xtV8kUQWXPPV5l/Sf9LozUrjeABcvvUe7UWkDv2OWGoNcvi0rqG1COBe/lgYfxM8qFQu77FO3v4rH54DbQyCKIZ4ffGelfIneLjOFBM8ZGSbhmJUjVZiVjFATL5HEzHxNpi/edUfFOsRUqkt0Mvt0rc7KwzbBh11m6IvII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Dfp3jZXJ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Dfp3jZXJ"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E45DA1F000FF;
	Fri, 18 Sep 2026 14:34:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1789742066;
	bh=kaJ2ZAGN9DkRNA1nJeSM2iOiiBiOrcQ6PhfG5PhPlI0=;
	h=From:To:Cc:Subject:Date;
	b=Dfp3jZXJycPA+z3dY4/mwv1ehyjLM5ooUQCiB8zwn+BEOYqNVA2OvHqQIV02pRI/z
	 5Y908AwgMPaf/3FpQGjCLGknJzOLwWSCO1XtNcu8E0aP8cArVJ+jfRAKYMDwema/Ky
	 Ob8f7CNfxLthbjUMPkpFvM7VifrZMB8UN5Ri/DBscTnVeue+va24SEO0YbCMSp+af4
	 ceWfdaYgbsipEzj50j+cHvfcMCCdMnNAfrz0OHwKQrRJxSgmqAmkrwNuXIoB9jvsTX
	 04g+Ty11ufS2H1xI/9bhQ2GkRXG8LX8pYYL87d8mzhvpbGNrVR0kBEoI8fwNYOar9Y
	 Yk+CcNrO2KMQg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Krystian Kaniewski <krystianmkaniewski@gmail.com>, <linux-trace-kernel@vger.kernel.org>, "Masami Hiramatsu" <mhiramat@kernel.org>, "Steven Rostedt" <rostedt@goodmis.org>, "Vincent Donnefort" <vdonnefort@google.com>
Cc: linux-kernel@vger.kernel.org, mathieu.desnoyers@efficios.com, syzbot@lists.linux.dev
Subject: [PATCH] ring-buffer: Fix false warning in ring_buffer_map_get_reader()
Message-ID: <15bc282f-669e-4a94-911d-bb435513461f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 18 Sep 2026 14:34:25 +0000 (UTC)

From: Krystian Kaniewski <krystianmkaniewski@gmail.com>

In ring_buffer_map_get_reader(), an unconditional WARN_ON(!reader) is
triggered when rb_get_reader_page() returns NULL:

WARNING: CPU: 1 PID: 5906 at kernel/trace/ring_buffer.c:7998
ring_buffer_map_get_reader+0x940/0x9d0
CPU: 1 UID: 0 PID: 5906 Comm: task Not tainted
RIP: 0010:ring_buffer_map_get_reader+0x940/0x9d0
kernel/trace/ring_buffer.c:7998
Call Trace:
 <TASK>
 tracing_buffers_ioctl+0x258/0x300 kernel/trace/trace.c:7381
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

This warning is triggered due to a race between a writer committing events
and a reader mapping the ring buffer via TRACE_MMAP_IOCTL_GET_READER. When
a writer commits an event in rb_set_commit_to_write(), it advances
cpu_buffer->commit_page to cpu_buffer->tail_page in its first loop before
updating the commit counter (commit_page->page->commit) in the second loop.
If a reader invokes ring_buffer_map_get_reader() at this moment, the
initial check cpu_buffer->reader_page == cpu_buffer->commit_page is false,
and it calls rb_get_reader_page(). Inside __rb_get_reader_page(), the
reader swaps reader_page with the head page (which is the new commit_page).
Because the writer has not yet updated the commit count on the new page,
rb_page_size() is zero and reader_page->read < rb_page_size() evaluates to
false. __rb_get_reader_page() then checks if cpu_buffer->commit_page ==
cpu_buffer->reader_page. Since both now point to the swapped page, the
condition evaluates to true and rb_get_reader_page() legitimately returns
NULL to indicate the reader caught up to the writer.

Furthermore, rb_get_reader_page() can legitimately return NULL when there
is no data to read. Re-checking mutable writer state such as
cpu_buffer->reader_page != cpu_buffer->commit_page is insufficient because
a writer on another CPU can advance commit_page before the check is
evaluated without being stopped by reader_lock.

Because WARN_ON must not be used for conditions that can legitimately
happen, and pr_err should be used instead if necessary, remove the
WARN_ON() entirely since returning NULL here is an expected condition.

Fixes: 117c39200d9d ("ring-buffer: Introducing ring-buffer mapping functions")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de3d7f9bcc9212f3fae1
Link: https://syzkaller.appspot.com/ai_job?id=488adc18-a10e-42d2-a205-25327c38837f
Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>

---
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9c03a555a..1a4da3d47 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7995,7 +7995,7 @@ int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu)
 		goto out;
 
 	reader = rb_get_reader_page(cpu_buffer);
-	if (WARN_ON(!reader))
+	if (!reader)
 		goto out;
 
 	/* Check if any events were dropped */


base-commit: df2908090cda368b01ff43709f51890076c56157
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
