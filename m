Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C9C5531AE1
	for <syzbot@lists.linux.dev>; Tue,  8 Sep 2026 11:48:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788868128; cv=none; b=LvPd/clSFeehHH69JkVnJq/YRHHwT5+jO3gO034KsaUxcGCPijcZxbriaXuC7aKiS6M2X42JAUSeuzJ9xjZNk5se/tLEuQNR9h2cKD30PFFjet8YXjmLYgWBfYEVf5smnL0bEHVQfUIcy7/FEm3AsiPMUTA8USTyxF+9whPUjOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788868128; c=relaxed/simple;
	bh=hnH3gMBGnOW7h94oe1zXTVsfPHZyQQNTaBmvbejrytc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Vfxzi6YHo6HvcAvMsc0gy2I1enJGwI6IwUHKiPi6GEYpSMDmHU+UAMMTjQZhLqupSS+OS++UNQ983EYzA6uFswzmrl1eqsuBalaiXmNKCvuDvC0/1BLDypUsV7EpLDnzUwNwVdyWiaYSwmMOIlEtD8pMiA7X+H0d7pGUgPs3MtM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kDWxzC+t; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kDWxzC+t"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0E81F1F00A3A;
	Tue,  8 Sep 2026 11:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788868113;
	bh=Hhk6cdAwfbJvTdC7g0kMCgPSOArKJZCvUTCT+SS2VYw=;
	h=From:To:Cc:Subject:Date;
	b=kDWxzC+tY68D/8/UOWYf/bD0uXCkas3pqrsc2TaHZC3BYI1p/L0vYoQDI9ruWaxL/
	 5e9lvc0PbskHehqmR84Mmti2Q8hkCEhZzVtRNAsZiuJ4cOvafq82AqPr9SFhQLgVyB
	 YJY/q6aDlg78czSYz3oBR3KZaejSiAkZXGjFQHZvo1iVFHZBlbfjGGE+eI36/kn0Zh
	 Oh2YdBpexBzCyPdC9uA2wOCszXe4UfDtOJmVtvlqdQcJoAjvbaw/ueYW0BUMlv8NLM
	 Bw/Wv0rhWEtjjfq07Cx9WDbh7AwpAI4aYg7AEuNUEyOIhHa7fCY6o4CEIn8eKGrscy
	 jjpK6/FXJ2Mzw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ring-buffer: Fix false warning in ring_buffer_map_get_reader()
Message-ID: <97fb4855-693b-429f-9e75-b4c2a0348ef0@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue,  8 Sep 2026 11:48:33 +0000 (UTC)

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

Because WARN_ON must not be used for conditions that can legitimately
happen, ring_buffer_map_get_reader() should not unconditionally warn when
rb_get_reader_page() returns NULL. Fix this by only warning if
rb_get_reader_page() returns NULL while cpu_buffer->reader_page !=
cpu_buffer->commit_page.

Fixes: 117c39200d9d ("ring-buffer: Introducing ring-buffer mapping functions")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+de3d7f9bcc9212f3fae1@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de3d7f9bcc9212f3fae1
Link: https://syzkaller.appspot.com/ai_job?id=f119d7de-b21d-4d27-b61e-5503e31edccd
To: <linux-trace-kernel@vger.kernel.org>
To: "Masami Hiramatsu" <mhiramat@kernel.org>
To: "Steven Rostedt" <rostedt@goodmis.org>
To: "Vincent Donnefort" <vdonnefort@google.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Mathieu Desnoyers" <mathieu.desnoyers@efficios.com>

---
diff --git a/kernel/trace/ring_buffer.c b/kernel/trace/ring_buffer.c
index 9c03a555a..98130182e 100644
--- a/kernel/trace/ring_buffer.c
+++ b/kernel/trace/ring_buffer.c
@@ -7995,8 +7995,10 @@ int ring_buffer_map_get_reader(struct trace_buffer *buffer, int cpu)
 		goto out;
 
 	reader = rb_get_reader_page(cpu_buffer);
-	if (WARN_ON(!reader))
+	if (!reader) {
+		WARN_ON(cpu_buffer->reader_page != cpu_buffer->commit_page);
 		goto out;
+	}
 
 	/* Check if any events were dropped */
 	missed_events = cpu_buffer->lost_events;


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
