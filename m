Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAD0A42EEC4
	for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 07:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790234342; cv=none; b=JbzcUAhxAEjxmZL/o4aUV5/QuyTjKrtwQJshsdZ4Wkz5hyAP1nN+LtG5I7Wyzb4Ma4CNtpam4kxnnmLMK8twgoaXOocl9Nd26HH/Ny8BNNun5trvwSSd0EDZBhfG7L3U70XoJKA+eYHyTxE9Tv491csWgLkqMjhrQYHxEjO5ZjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790234342; c=relaxed/simple;
	bh=GM0ZDPb9BQzRxofJIx3YFOhVBCnyP7MFE2bvxS+0eMQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=rbE9nqmS5GQ9xIlofsDAsBvdrKK/uWmZSF2ANPyRZg5PETrJgaS/5q9HM7Eb09QrBEPQY2Mpvf9Z5wE+Gf0X9ivUmPH3dikLbL41y3vnNsfI4/l9xwnLY1UNrcGqPe3lElmUqoimC7hxYuGyh99S8wuEnQU11vjaG4cssaw+s2Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NQY87VU4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NQY87VU4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A0E141F000FF;
	Thu, 24 Sep 2026 07:18:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790234332;
	bh=WjZT7aMcfxWXxpdb/47mrQR48gi7BM4vCXAizA8Pw+g=;
	h=From:To:Cc:Subject:Date;
	b=NQY87VU4xrZohlY65Xq1RJDfywmjmFSop6wlgqpY8BrwEDKDSJHJBVnJ0w9IJ4ig4
	 DRb5IqzAUC/1flKy3DSGQhlEn/q4SlyE/pwilxD1z1l4GC3xOsfuTr48icNaOAtT9/
	 cHo/T2fiOLgsNYdhCPIkl56sxE2D2k8zHsjLjdY0KGaY97pbhViv3D2ZLTkVnorSFU
	 tMrlGwGzh3x62yKNeAkdlG3lgp5MwPIBcKM32TRafnBJUlunFIDja/SMSTlppAYd0A
	 BONKEN0pJzYvnbpgAH6dLZMsTe5ghHjGWkhyWlTZ31TnUK3N3UdsN6oivwITW8QVG4
	 W26mEoFJeynIA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] SUNRPC: Use TASK_FREEZABLE_UNSAFE in __rpc_execute()
Message-ID: <1a25e233-381b-4a90-9a62-da0a6968b575@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 24 Sep 2026 07:18:52 +0000 (UTC)

When a task executes a synchronous RPC call via __rpc_execute(), it waits
for the queued RPC task to wake up using out_of_line_wait_on_bit(). Callers
in subsystems such as NFS or NFSD (for example, write_ports() acquiring
nfsd_mutex during NFS server initialization and issuing an rpc_ping())
frequently hold locks across these synchronous RPC waits.

Historically, rpc_wait_bit_killable() invoked freezable_schedule_unsafe(),
which explicitly bypassed lockdep checks for held locks during freeze.
However, during the core freezer refactoring in commit f5d39b020809
("freezer,sched: Rewrite core freezer logic"), freezable_schedule_unsafe()
was removed, and callers were updated to pass freezer flags directly into
out_of_line_wait_on_bit(). While rpc_wait_for_completion_task() was
correctly updated to use TASK_KILLABLE | TASK_FREEZABLE_UNSAFE,
__rpc_execute() was mistakenly updated to use TASK_KILLABLE |
TASK_FREEZABLE without the unsafe flag.

As a result, if a system suspend occurs concurrently while a task is
waiting in __rpc_execute() with a lock held, __set_task_frozen() observes
p->lockdep_depth > 0 without __TASK_FREEZABLE_UNSAFE and triggers a lockdep
warning:

WARNING: kernel/freezer.c:139 at __set_task_frozen+0x260/0x340
Call Trace:
 <TASK>
 task_call_func+0x1aa/0x260 kernel/sched/core.c:4518
 __freeze_task kernel/freezer.c:150 [inline]
 freeze_task+0x216/0x390 kernel/freezer.c:169
 try_to_freeze_tasks+0x190/0x620 kernel/power/process.c:54
 freeze_processes+0xd0/0x1f0 kernel/power/process.c:137
 suspend_prepare kernel/power/suspend.c:387 [inline]
 enter_state kernel/power/suspend.c:609 [inline]
 pm_suspend+0x2f1/0x760 kernel/power/suspend.c:644
 state_store+0x206/0x290 kernel/power/main.c:819
 kernfs_fop_write_iter+0x3a5/0x540 fs/kernfs/file.c:345
 vfs_write+0x61e/0xbb0 fs/read_write.c:687
 ksys_write+0x156/0x270 fs/read_write.c:739
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Update __rpc_execute() to pass TASK_KILLABLE | TASK_FREEZABLE_UNSAFE to
out_of_line_wait_on_bit(). This restores the pre-regression behavior and
aligns __rpc_execute() with rpc_wait_for_completion_task(), avoiding the
false-positive lockdep warning when tasks holding locks are frozen during
synchronous RPC execution.

Fixes: f5d39b020809 ("freezer,sched: Rewrite core freezer logic")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+209eccd8f507de9f7f1b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=209eccd8f507de9f7f1b
Link: https://syzkaller.appspot.com/ai_job?id=cb10c20b-f568-4900-8b09-dc937852ee3f
To: "Anna Schumaker" <anna@kernel.org>
To: "Chuck Lever" <cel@kernel.org>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jeff Layton" <jlayton@kernel.org>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-nfs@vger.kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Trond Myklebust" <trondmy@kernel.org>
To: "Peter Zijlstra" <peterz@infradead.org>
Cc: "Dai Ngo" <Dai.Ngo@oracle.com>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "NeilBrown" <neil@brown.name>
Cc: "Olga Kornievskaia" <okorniev@redhat.com>
Cc: "Tom Talpey" <tom@talpey.com>

---
diff --git a/net/sunrpc/sched.c b/net/sunrpc/sched.c
index 016f16ca5..494947d50 100644
--- a/net/sunrpc/sched.c
+++ b/net/sunrpc/sched.c
@@ -984,7 +984,7 @@ static void __rpc_execute(struct rpc_task *task)
 		trace_rpc_task_sync_sleep(task, task->tk_action);
 		status = out_of_line_wait_on_bit(&task->tk_runstate,
 				RPC_TASK_QUEUED, rpc_wait_bit_killable,
-				TASK_KILLABLE|TASK_FREEZABLE);
+				TASK_KILLABLE | TASK_FREEZABLE_UNSAFE);
 		if (status < 0) {
 			/*
 			 * When a sync task receives a signal, it exits with


base-commit: 93f51579e7df248780214094418f205253383cc5
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
