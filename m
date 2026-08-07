Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 194B741D638
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 10:11:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786097488; cv=none; b=CLA/cLkjcosSZmUtIzznI9JVWmPyiROVZnroe1oZquHi5Hk9qolpyAqwmZIb1z3DZ90wKEW4JkzDewLzwRorgFIY7Oh0vy7wpmXBzAysW5MnrOQlFIf6+QHqlYhyB4KdsZKXQ8TVSK27EbIkL7U56D6cdrqVxxoGqd20PteXxDw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786097488; c=relaxed/simple;
	bh=ZybEpOJyujWR+U5WHoryXu4biCKACDCrv5ELyNtHR70=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=aRLYxoeycb17WcAckH/3AiUR/MMDUYefctZbqhkr7xsrjQRS0R0TgXFo9YaakiVSnBFKZLEFACCPKiLLXBUScGFJpoEFWNjMUedK/aH7sjGYZS1s9R+xtx2VO/CSj5PGDrbFDk7NH0U7QScYy+o8h+n4oIw9OU44RefKE9PfQ1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=HGO12lG6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="HGO12lG6"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A895B1F000E9;
	Fri,  7 Aug 2026 10:11:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786097486;
	bh=KNA4DEph2upr8BAsgpBqZHwC75bnMcg6juAcbGMSyJ4=;
	h=From:To:Cc:Subject:Date;
	b=HGO12lG6ieCMmM7lIvyouOBFkFa+Yj4NHUQwQYoB2JgsMtTFQVH93G4w+QRn1AYqL
	 LyQ1xOdnsbs8gjl+wKWSvlwp8vEyEpDpiEx2AYHmT5ZfcYsm6V04TcmIkn3xhvSaqX
	 ZNWREH4mii0JgBfXExi6PaVd/TV4+ty7xrw7c32cDopydZikYM5R4Um/v2SlBWqQRe
	 pIhuQN3huMxJrv0jDiOOkwGBA1fD3dUGPHF+ZTEq5sgmjO12AD0lRiZbhnC/SaLn71
	 y8luzDwm6c4BuaB8LA+iUSAupZts5/nQOQ0SrctbailNCyTQA05xdJjmbcHJewl8Sa
	 VDo2wO75EM+Hg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] power: require CAP_SYS_BOOT and wakeup sources for suspend
Message-ID: <a5677b92-2b2b-418d-bfc6-3a590dc343da@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 10:11:26 +0000 (UTC)

Writing to /sys/power/state can suspend a system indefinitely if there are
no wakeup sources configured (e.g., no RTC alarm or power button). This can
lead to an unrecoverable state where the system remains suspended forever.
Additionally, during suspend, tasks frozen while holding locks can trigger
false positive lockdep warnings, such as:

WARNING: kernel/freezer.c:139 at __set_task_frozen+0x260/0x340
kernel/freezer.c:139
Call Trace:
 <TASK>
 task_call_func+0x1aa/0x260 kernel/sched/core.c:4495
 __freeze_task kernel/freezer.c:150 [inline]
 freeze_task+0x216/0x390 kernel/freezer.c:169
 try_to_freeze_tasks+0x190/0x620 kernel/power/process.c:54
 freeze_processes+0xce/0x1e0 kernel/power/process.c:137
 suspend_freeze_processes kernel/power/power.h:281 [inline]
 suspend_prepare kernel/power/suspend.c:387 [inline]
 enter_state kernel/power/suspend.c:609 [inline]
 pm_suspend+0x2f1/0x760 kernel/power/suspend.c:644
 state_store+0x206/0x290 kernel/power/main.c:819
 kernfs_fop_write_iter+0x3a5/0x540 fs/kernfs/file.c:345
 vfs_write+0x61e/0xbb0 fs/read_write.c:687
 ksys_write+0x156/0x270 fs/read_write.c:739
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 </TASK>

To prevent this, require CAP_SYS_BOOT and check if any wakeup sources are
registered in the system before allowing suspend via state_store() and
autosleep_store(). If the list of wakeup sources is empty, return -EPERM.

Furthermore, fix the false positive lockdep warnings in FUSE and SunRPC by
changing TASK_FREEZABLE to TASK_FREEZABLE_UNSAFE in fuse_get_req() and
__rpc_execute(). This explicitly tells lockdep that sleeping with locks
held in these specific locations is safe and expected during system freeze.

Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+209eccd8f507de9f7f1b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=209eccd8f507de9f7f1b
Link: https://syzkaller.appspot.com/ai_job?id=b9059933-51e0-4b0e-81e5-3baa7c7ce899
To: "Anna Schumaker" <anna@kernel.org>
To: "Chuck Lever" <cel@kernel.org>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: <fuse-devel@lists.linux.dev>
To: "Jeff Layton" <jlayton@kernel.org>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-nfs@vger.kernel.org>
To: <linux-pm@vger.kernel.org>
To: "Miklos Szeredi" <miklos@szeredi.hu>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Rafael J. Wysocki" <rafael@kernel.org>
To: "Trond Myklebust" <trondmy@kernel.org>
Cc: "Dai Ngo" <Dai.Ngo@oracle.com>
Cc: "Simon Horman" <horms@kernel.org>
Cc: "Len Brown" <lenb@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "NeilBrown" <neil@brown.name>
Cc: "Olga Kornievskaia" <okorniev@redhat.com>
Cc: "Pavel Machek" <pavel@kernel.org>
Cc: "Tom Talpey" <tom@talpey.com>

---
diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
index 5763a7cd3..9e8dc96d2 100644
--- a/fs/fuse/dev.c
+++ b/fs/fuse/dev.c
@@ -116,7 +116,7 @@ static struct fuse_req *fuse_get_req(struct fuse_chan *fch, bool for_background)
 		err = -EINTR;
 		if (wait_event_state_exclusive(fch->blocked_waitq,
 				!fuse_block_alloc(fch, for_background),
-				(TASK_KILLABLE | TASK_FREEZABLE)))
+				(TASK_KILLABLE | TASK_FREEZABLE_UNSAFE)))
 			goto out;
 	}
 
diff --git a/kernel/power/main.c b/kernel/power/main.c
index 5429e9f19..780afda11 100644
--- a/kernel/power/main.c
+++ b/kernel/power/main.c
@@ -20,6 +20,7 @@
 #include <linux/pm_runtime.h>
 #include <linux/atomic.h>
 #include <linux/wait.h>
+#include <linux/pm_wakeup.h>
 
 #include "power.h"
 
@@ -802,6 +803,22 @@ static ssize_t state_store(struct kobject *kobj, struct kobj_attribute *attr,
 	suspend_state_t state;
 	int error;
 
+#ifdef CONFIG_PM_SLEEP
+	int idx;
+	struct wakeup_source *ws;
+#endif
+
+	if (!capable(CAP_SYS_BOOT))
+		return -EPERM;
+
+#ifdef CONFIG_PM_SLEEP
+	idx = wakeup_sources_read_lock();
+	ws = wakeup_sources_walk_start();
+	wakeup_sources_read_unlock(idx);
+	if (!ws)
+		return -EPERM;
+#endif
+
 	error = pm_autosleep_lock();
 	if (error)
 		return error;
@@ -929,6 +946,24 @@ static ssize_t autosleep_store(struct kobject *kobj,
 	suspend_state_t state = decode_state(buf, n);
 	int error;
 
+#ifdef CONFIG_PM_SLEEP
+	int idx;
+	struct wakeup_source *ws;
+#endif
+
+	if (!capable(CAP_SYS_BOOT))
+		return -EPERM;
+
+#ifdef CONFIG_PM_SLEEP
+	if (state != PM_SUSPEND_ON) {
+		idx = wakeup_sources_read_lock();
+		ws = wakeup_sources_walk_start();
+		wakeup_sources_read_unlock(idx);
+		if (!ws)
+			return -EPERM;
+	}
+#endif
+
 	if (state == PM_SUSPEND_ON
 	    && strcmp(buf, "off") && strcmp(buf, "off\n"))
 		return -EINVAL;
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


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
