Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA0C233933
	for <syzbot@lists.linux.dev>; Thu,  9 Jul 2026 13:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783603947; cv=none; b=B/ekN/XzF4pwTS0nb1PJhORu5NoDdfnWo65E/+F1ue+JuRpkSAT8NspRAjdXCLWO9CUxDGaCTof/aZChAo/CVphXElhHDKSgWm06t7AB+0cxetLF+XIJi9ald6TX0mJUVy0ArFTcB39JzIPIetzy/Rs/gn8z0aUDh8bSbtzUWjI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783603947; c=relaxed/simple;
	bh=oLJkX98KDZ+ydOlC+s77lXnA8jJ6F+vP9GYEjjajW8Q=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=X+7tB9gXB3+aIHPiXoOsYG4qBJWmO6eSBANpeg0JFWnhiCJjXqAu94BC29FaX7fF3byNa8rwWS+mKkCncTA/BYdL7pwESEcQh6Posn88xIFXZoae81G1Y2m5SM6eJZ0ex7jDnjLJ0k2DIx6LRFRdQRqrEuzJKTIMVMFxOAwqmm0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Ff7XrD9p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Ff7XrD9p"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 595EB1F00A3A;
	Thu,  9 Jul 2026 13:32:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783603945;
	bh=3eOA+uebrzc4PC2dYA/xtsDjoMp86SzrpnWms4KahAQ=;
	h=From:To:Cc:Subject:Date;
	b=Ff7XrD9p/N/xcp2+EZk7kvsMDQQAEmHqnW3+2owLg5llGQ6mI2j84/kAgksqhuvkh
	 e2pjMSd1Uh5AoDyjAaSYnZlnMXuKcne3WKqzoeChQybx9Q22ERzkB865hnrgzUrZ+F
	 Qb3X2ta/rK3DWnbguuRHVxMK8wR2HL5M72WGP+I96lQhaKmTTWvJg79wBmhKP+sVB7
	 blKt82ysSkRYUd/DRBO7NEzefYPjghvPFmKuwwDKHKUcp1WxBPGHaMShUAmCvNLJa5
	 389Gdt84RDBEVb9yo5IbbaWB6ncR+1WTfFEfJkCnvKMAcBdjl+4JRMCLTF/jwH+P4d
	 N2h2f0FsHGEiQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] fuse: allow fatal signals to interrupt forced requests
Message-ID: <5172c535-3f9d-4ed1-8855-414eee9a6010@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  9 Jul 2026 13:32:25 +0000 (UTC)

A single-threaded FUSE server can deadlock itself and cause a hung task
panic if it calls close_range(). This syscall closes all open file
descriptors, including the FUSE file descriptor. Closing the FUSE file
triggers a FUSE_FLUSH request. Because the process is single-threaded and
blocked in the kernel waiting for the flush reply, it cannot read the
request from /dev/fuse and reply to it.

FUSE_FLUSH requests are sent with the FR_FORCE flag. In
request_wait_answer(), forced requests skip the wait_event_killable() block
and wait uninterruptibly (wait_event()). This makes the task completely
unkillable (D state) and triggers the hung task watchdog:

INFO: task blocked for more than 143 seconds.
Call Trace:
 <TASK>
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 request_wait_answer fs/fuse/dev.c:743 [inline]
 __fuse_request_send fs/fuse/dev.c:757 [inline]
 fuse_chan_send+0x1065/0x1ac0 fs/fuse/dev.c:833
 fuse_flush+0x66e/0x8b0 fs/fuse/file.c:504
 filp_flush+0xbd/0x190 fs/open.c:1471
 filp_close+0x1d/0x40 fs/open.c:1484
 __range_close fs/file.c:793 [inline]
 __do_sys_close_range fs/file.c:854 [inline]
 __se_sys_close_range+0x3d3/0x900 fs/file.c:818
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Historically, FR_FORCE was introduced to prevent FUSE_FLUSH from being
interrupted by normal signals (like SIGINT), as cancelling it could lead to
leaked POSIX locks on the server. However, making it completely
uninterruptible even by fatal signals (SIGKILL) causes this unrecoverable
deadlock.

If a process is killed by a fatal signal, it is acceptable to cancel the
FUSE_FLUSH request. The process is exiting, and all its file descriptors
will be closed, which will eventually trigger a FUSE_RELEASE request. Since
FUSE protocol 7.8, FUSE_RELEASE contains the lock_owner, allowing a
well-written server to clean up any remaining POSIX locks. Even if a poorly
written server leaks locks, a resource leak in a userspace server is vastly
preferable to a kernel panic.

By removing the !test_bit(FR_FORCE, &req->flags) condition around the
wait_event_killable() block in request_wait_answer(), we allow forced
requests to be interrupted by fatal signals. This places the task in the
TASK_KILLABLE state, which the hung task watchdog ignores, preventing the
panic. It also allows the task to be killed by SIGKILL, breaking the
deadlock and allowing the task to exit gracefully.

Fixes: 7142125937e1 ("[PATCH] fuse: add POSIX file locking support")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+a531d1b1fb0fa2a75a73@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a531d1b1fb0fa2a75a73
Link: https://syzkaller.appspot.com/ai_job?id=864cba22-20c3-4bfa-b461-b7208b3fac7d
To: <fuse-devel@lists.linux.dev>
To: "Miklos Szeredi" <miklos@szeredi.hu>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5763a7cd3..75943da8c 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -714,10 +714,17 @@ static void request_wait_answer(struct fuse_req *req)
 			queue_interrupt(req);
 	}
 
-	if (!test_bit(FR_FORCE, &req->flags)) {
+	{
 		bool removed;
 
-		/* Only fatal signals may interrupt this */
+		/*
+		 * Only fatal signals may interrupt this.
+		 * Forced requests (like FUSE_FLUSH) used to be completely
+		 * uninterruptible, but it can cause self-deadlocks.
+		 * If killed, we cancel the request. POSIX locks might be
+		 * leaked on the server, but the process is dying anyway,
+		 * and FUSE_RELEASE will be sent.
+		 */
 		err = wait_event_killable(req->waitq,
 					test_bit(FR_FINISHED, &req->flags));
 		if (!err)
@@ -737,8 +744,7 @@ static void request_wait_answer(struct fuse_req *req)
 	}
 
 	/*
-	 * Either request is already in userspace, or it was forced.
-	 * Wait it out.
+	 * Request is already in userspace, wait it out.
 	 */
 	wait_event(req->waitq, test_bit(FR_FINISHED, &req->flags));
 }


base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
