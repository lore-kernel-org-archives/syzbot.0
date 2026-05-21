Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDA612882D6;
	Thu, 21 May 2026 09:05:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779354345; cv=none; b=UkPiaLjSSiraP0utrjOISpSvVGR2nwNFqVIMyNjlZgj5FEKxys35cStHfvWJgpyrqrNt8l2goVjBclNKgxhtCdnmi2vhJNtJ3Cr873WICoxaX78Z0anM2gaaHm2eDzNt9DwZIfj6o6KWYT2XXtCv9eQYQ98WtgXOK8I6RRpaHUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779354345; c=relaxed/simple;
	bh=q1Z8MIztjvNi87BPF/TkqEu9iJscRc+tpTQ5DgDbCjI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=oHUahxT4EOEGYgF7AjqGnMnNFl/492NSAyYNap/R9rtFazYvqHLxN7AIgIn4K/lVb97K8D4ViMnE9FCVH8Ze1Es0JNlfMt2QLNfhoHxqAl2UJWsuM5fBBiegDdH4zQNq1TEbT8tSaXxpSnT0CtMTugHzDgm1ucIY9sJRiZFnqx8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=OHOdmimR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="OHOdmimR"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0760E1F000E9;
	Thu, 21 May 2026 09:05:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779354344;
	bh=XJtcH4WPFBb+FAKPwiSMvQDFhfYu7jEACB7wP1P2HOk=;
	h=From:To:Cc:Subject:Date;
	b=OHOdmimRj1D1NBr5Jtp3g7oHVpkX0bny2ZcQAGjTPAubPBlglRTfwbjU29LLbfSs+
	 T6Q/T93oLR4DXThwDq+s0YVZvuqmpR/zXm18iukdi3EswE/+KHNwF70xDvMZIMUGnI
	 n17zUahaoM+zWu85IlRZNRRpFPU4jh6W1f+94vxvbe1atku3m7x3XJ8/EbC6YkCKHD
	 GpUHGItJ7ZhdSWfSXpsiyiFjMcnZcH16s/twU4K6R4PahRtm+tqvLEX0bpEI2LS1FN
	 kHw3ydSqp+yO3O3ki3PFXUvMQWpaQ+egLSNHRFCwin5ZxDxZkT/Ae2ssEUfwuOpy1x
	 BfmURbuW+IoZw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, <linux-kernel@vger.kernel.org>
Cc: adrianhuang0701@gmail.com, akpm@linux-foundation.org, brauner@kernel.org, kexinsun@smail.nju.edu.cn, oleg@redhat.com, peterz@infradead.org, syzbot@lists.linux.dev, tglx@kernel.org
Subject: [PATCH] signal: clear JOBCTL_PENDING_MASK for caller in zap_other_threads()
Message-ID: <36638f2b-6f91-4e33-b630-fd7045eebc84@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 21 May 2026 09:05:43 +0000 (UTC)

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
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

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
See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
