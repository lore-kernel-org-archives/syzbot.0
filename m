Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 727C61A5B8A
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 00:31:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779323476; cv=none; b=Zzq8YexSXpN58X5nLO9WBKnM7GcRl6c+MHxHLXHf4gPsRwlAjzBU5nV2UESYjaKnNeXFwu9y4C0cDFYQnUxMsVtkQkDjlQFsgcC+3yx7uQayGeot5s9Naf7Bdw5itqcn6Mgeztd435sERkTUOCBCQ4cTNu8OIJB15SSIEeRkGck=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779323476; c=relaxed/simple;
	bh=tI7YKhJFCfowMrgDO0jUbGgjyQMSwY+IWrK3OTtgti0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=PEhWcRGF/XzqhSk2dqzhdYVl9bLJQP7KDb4vsv2fpe2kVfApo7f5N0QNVYtzls029gPA1LX/S3tVQsxVUJ5PGOQyFsbGnuhWi1URsDsxxRoLwNxPYtnxVdWBiOQrXod/V/QKSJok2s+3FTnxUz29sZaQe3wVccnD2AD1kzKljfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nN0ZNVpV; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nN0ZNVpV"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id EC40B1F000E9;
	Thu, 21 May 2026 00:31:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779323474;
	bh=utwDKn/ro5K9WmFJYJS1TAcda25C5NEzSpT0RqiSY3w=;
	h=From:To:Cc:Subject:Date;
	b=nN0ZNVpVleWAyRpEzClFbiVvFVsZjNBM+j7WrIwgXdHq+9urj05Z/Q+05KX9DURrf
	 qT4dPjgbuMT1AZ+YcY9ILzoU1YS9JeYLEEzBekspv5DsktTjF3ZbpJzBoM8Nx5Lwh8
	 m8mAOyBV/1fq9S6AA3SV2/hA+6xRCkdl+R7DP28TKc7tUaFxD11ANsALhJxNFFk2jM
	 1P29ilvOViH5bl51HnRlgcTQOjzkJCNy9YPdTTaottLGG6c8JhSf/pjwuguRkIfTij
	 4BeAvRoSoyynUFGAPWN77xVnnlbzyBrz/AExtE/JbjWcqGySE8vVMSL3bH9Yi44TeS
	 sJFBNBrwPE/JA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
Message-ID: <4c5b9b97-0b9e-4b5f-8bc8-b2a274c1374b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 21 May 2026 00:31:13 +0000 (UTC)

When a multi-threaded process receives a stop signal (e.g., SIGSTOP),
do_signal_stop() sets JOBCTL_STOP_PENDING and JOBCTL_STOP_CONSUME on all
threads and sets signal->group_stop_count to the number of threads. If
one of the threads concurrently calls execve(), de_thread() invokes
zap_other_threads() to kill all other threads. zap_other_threads()
aborts the pending group stop by resetting signal->group_stop_count to 0
and clears the JOBCTL_PENDING_MASK for all other threads. However, it
fails to clear the job control flags for the calling thread.

When execve() completes, the calling thread returns to user mode and
checks for pending signals. Seeing the stale JOBCTL_STOP_PENDING flag,
it calls do_signal_stop(), which invokes task_participate_group_stop().
Since JOBCTL_STOP_CONSUME is still set, it attempts to decrement the
already-zero signal->group_stop_count, triggering a warning:

sig->group_stop_count == 0
WARNING: CPU: 1 PID: 6475 at kernel/signal.c:373
task_participate_group_stop+0x215/0x2d0
Call Trace:
 <TASK>
 do_signal_stop+0x3be/0x5c0 kernel/signal.c:2619
 get_signal+0xa8c/0x1330 kernel/signal.c:2884
 arch_do_signal_or_restart+0xbc/0x840 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x8c/0x4d0 kernel/entry/common.c:98
 do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fix this race condition by clearing the JOBCTL_PENDING_MASK for the
calling thread in zap_other_threads(), ensuring it does not retain any
stale job control state after the thread group is destroyed. This aligns
with other functions that tear down a thread group and abort group
stops, such as zap_process() and complete_signal(), which correctly
clear these flags for all threads including the current one.

Fixes: 39efa3ef3a37 ("signal: Use GROUP_STOP_PENDING to stop once for a single group stop")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+b109633ea805cac54a61@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b109633ea805cac54a61
Link: https://syzkaller.appspot.com/ai_job?id=d70208cc-862b-4fe3-bf02-3031e10cd0b3
To: <linux-kernel@vger.kernel.org>
Cc: "Adrian Huang (Lenovo)" <adrianhuang0701@gmail.com>
Cc: "Andrew Morton" <akpm@linux-foundation.org>
Cc: "Christian Brauner" <brauner@kernel.org>
Cc: "Kexin Sun" <kexinsun@smail.nju.edu.cn>
Cc: "Oleg Nesterov" <oleg@redhat.com>
Cc: "Peter Zijlstra (Intel)" <peterz@infradead.org>
Cc: "Thomas Gleixner" <tglx@kernel.org>

---
v2:
- Included the warning message and stack trace in the commit description.

v1:
https://lore.kernel.org/all/b3adb77f-185b-434f-a19d-0a29728733ba@mail.kernel.org/T/
---
diff --git a/kernel/signal.c b/kernel/signal.c
index 2d102e025..9c2b32c4d 100644
--- a/kernel/signal.c
+++ b/kernel/signal.c
@@ -1338,6 +1338,7 @@ int zap_other_threads(struct task_struct *p)
 	int count = 0;
 
 	p->signal->group_stop_count = 0;
+	task_clear_jobctl_pending(p, JOBCTL_PENDING_MASK);
 
 	for_other_threads(p, t) {
 		task_clear_jobctl_pending(t, JOBCTL_PENDING_MASK);


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
