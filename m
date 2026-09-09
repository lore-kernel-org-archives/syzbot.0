Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86E9E576ECE
	for <syzbot@lists.linux.dev>; Wed,  9 Sep 2026 14:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962833; cv=none; b=ly4NDd7i0aXEu4ohvWSPHrTm5n4owmRst8CeZGZvZyp0tY6C10h11ZtSJl/coml6UnqruBtRO0pKl2zwzOolTwvvDCICsJ5PEbbtt9DWkcrTJFe8UYfsRlvzoFbumFgr9vRzjwNlnqMFo1md4Eq/1ZaL47e+yE8l6WivtC6gmH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962833; c=relaxed/simple;
	bh=1rCDZwjByN771SprJLEBULCkwCaf+RpGL5AaRE6iOyA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=sR5cqFMoJ5wxoA6NWpMb7ZySH9cyuprAaTTD2kKXM7N9IC2pxfU4hbojrZffY60jGcXml3rQTKpCEYz7eZgP7j16tBSF7n73ZLBE5v1Mi4BB98fjyaISen7wXFKDduEj5ZCShmgn0vVxIMHqgFnyhFWG+8eBOXV7gRhUOm9PT64=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=F9RfJkKy; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="F9RfJkKy"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3C7A81F00A3E;
	Wed,  9 Sep 2026 14:07:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788962832;
	bh=HdV7fxoA3C/M0us5cTiiTbFxLEoksZnafsc8zml0mQ8=;
	h=From:To:Cc:Subject:Date;
	b=F9RfJkKy8x78Lii4LsdTiT/f6fekjfx32Y3Y++doJzWYxc9XgT8+V3N2ibbIOYCqe
	 fxamn5IucJlR9sDdZgKWKiwwd4+LZJCs6NusEtStivey6IFcBGEgrL+hnirGz42/pl
	 9+CDF/odEvV74Kcme82iQDci/5QZcyEOdCZ5DsTWqTdKLj50L9v00hJJ4XJxfh6CiU
	 F+oeUU3p5hjwDeAgBi60GuN3rJSIBeWINvOH4wasB2dGo/jq0KeMx/Y6fknePjFFL/
	 CGvfw+sSo1zW4SXt0HOzWfBAAnCyRpb0srn66DcenbMnnYDUcGSpkW+2QuE9o3iMf0
	 MVM2b6EJmASOQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] ring-buffer: Fix false warning in ring_buffer_map_get_reader()
Message-ID: <a7bc965a-10e4-40c3-974d-189a69fbb56f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  9 Sep 2026 14:07:12 +0000 (UTC)

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
To: <linux-trace-kernel@vger.kernel.org>
To: "Masami Hiramatsu" <mhiramat@kernel.org>
To: "Steven Rostedt" <rostedt@goodmis.org>
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>

---
v2:
- Remove the WARN_ON() check entirely instead of conditionally checking writer state.
- Update the commit description to explain why re-checking commit_page is insufficient.

v1:
https://lore.kernel.org/all/97fb4855-693b-429f-9e75-b4c2a0348ef0@mail.kernel.org/T/
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
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
