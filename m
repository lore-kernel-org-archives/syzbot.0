Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D4246D090
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 15:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786116928; cv=none; b=sn1RoU98dowzA4Hd7C6x4+72Qiygo1Wu4HZlZFNHALGGvtK1CA0MNZTpOLcwvKPfeNK0ImsPUsgbGhgsO1WH5dANXMkA+NWshRJwTFvFv0wcNNwdAbtvr40KyBOuLL25cX4SH1zm0YlgtOmp9A4+JqNEbF0qw+zKuisMm2zMhZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786116928; c=relaxed/simple;
	bh=uwFwF6aFOc6YEcGLYwdoxFMY4xg4Q2B6Wpv3dl1mY1M=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=GMqczxeFO8lvvh/CjbqCJU8ETFRYFBC/yX446DI3LP4VYSDVsd83rr8aLIg20+TH9BK/6CZJHDeNK1YK/0PVUSu+O5//shkteE4H9EDEAgd7ofsUH2331rDdt6jYxXLzZOt4rdo+AsmavfMZGdKLmETYxs/Jwh8CWsCOKBvpfgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VoPSkmI4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VoPSkmI4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 725CE1F00A3D;
	Fri,  7 Aug 2026 15:35:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786116926;
	bh=l3SbRsFxz+qjK206Fo0Y23MtE2UOeFHJ2HDReTpD8Jg=;
	h=From:To:Cc:Subject:Date;
	b=VoPSkmI4psGlcldN3PfI4DBCboOafifsWvjVXZCKUMzhAG0xTxqG1H/8suwgvYxwV
	 OOvM0AwdTzGM3kY83kZM3RRzoLIBvR+hq4U25c1C29j1seHOUBJZU++rWeN77qszTH
	 Ciy5PrZMUn3qnc7Z4TtjGTOcI4weXAM7ytosj0ZuEN4nIEL4x4PYHnOV8UeHR79RYS
	 wVggRWcvc4Jjzm/tu+BU7t+5Oz2AHAN8G5N9BxLcGU43yTMzCfUvrmr5OTlLKPTUCI
	 kIfshL3Fmchl9zmD8VOKpRMr6jJbcAAsrb+PMioABwNx5k8EGSanXsFmpH3COjauy4
	 +KMLzAkwEuK4w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] locking/percpu-rwsem: Use TASK_IDLE for freezable waits
Message-ID: <f81953d5-fab0-4dce-b33f-a43d57e7ac8e@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 15:35:26 +0000 (UTC)

When a filesystem is frozen via the FIFREEZE ioctl, the superblock's write
lock is acquired and held until the filesystem is explicitly thawed via
FITHAW. Any task attempting to write to the frozen filesystem (e.g.,
calling open(O_TMPFILE) or unlink) will block in sb_start_write(), waiting
for the superblock's read lock.

Currently, percpu_rwsem_wait() puts these waiting tasks into the
TASK_UNINTERRUPTIBLE state. Since thawing a filesystem relies on an
explicit user-space action, the wait can take an arbitrary amount of time.
If this wait exceeds the hung task timeout, the watchdog fires and can
panic the kernel:

INFO: task crond:5389 blocked for more than 15 seconds.
task:crond           state:D stack:23720 pid:5389  tgid:5389  ppid:1
task_flags:0x400000 flags:0x00080000
Call Trace:
 <TASK>
 __schedule+0x16dc/0x5500 kernel/sched/core.c:7234
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 percpu_rwsem_wait+0x32d/0x4a0 kernel/locking/percpu-rwsem.c:164
 __percpu_down_read+0xf8/0x140 kernel/locking/percpu-rwsem.c:180
 percpu_down_read_freezable include/linux/percpu-rwsem.h:83 [inline]
 __sb_start_write include/linux/fs/super.h:19 [inline]
 sb_start_write+0x18e/0x1c0 include/linux/fs/super.h:125
 mnt_want_write+0x41/0x90 fs/namespace.c:494
 filename_unlinkat+0x148/0x610 fs/namei.c:5562
 __do_sys_unlink fs/namei.c:5620 [inline]
 __se_sys_unlink+0x2e/0x140 fs/namei.c:5617
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

This behavior allows an unprivileged user to intentionally trigger a kernel
panic by freezing a user namespace mount (like tmpfs or fuse) and
attempting to write to it, leading to a local denial of service.

Fix this by using TASK_IDLE (which is TASK_UNINTERRUPTIBLE | TASK_NOLOAD)
instead of TASK_UNINTERRUPTIBLE when freeze is true. This explicitly tells
the hung task watchdog to ignore these tasks, preventing false positive
panics while preserving the freeze/thaw mechanics and system suspend
capabilities (TASK_FREEZABLE). Since freeze is only true when called from
percpu_down_read_freezable() (used exclusively by __sb_start_write()), this
change safely and specifically targets tasks waiting on a frozen
superblock.

Fixes: 559b3bbfa978 ("locking/percpu-rwsem: add freezable alternative to down_read")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+b3fba2e269970207b61d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b3fba2e269970207b61d
Link: https://syzkaller.appspot.com/ai_job?id=1f731a02-676c-4f22-a26c-1ff8c1dd0a49
To: "Boqun Feng" <boqun@kernel.org>
To: <linux-kernel@vger.kernel.org>
To: "Ingo Molnar" <mingo@redhat.com>
To: "Peter Zijlstra" <peterz@infradead.org>
To: "Will Deacon" <will@kernel.org>
To: "James Bottomley" <James.Bottomley@HansenPartnership.com>
Cc: "Waiman Long" <longman@redhat.com>

---
diff --git a/kernel/locking/percpu-rwsem.c b/kernel/locking/percpu-rwsem.c
index f7e152c40..57e24fdc0 100644
--- a/kernel/locking/percpu-rwsem.c
+++ b/kernel/locking/percpu-rwsem.c
@@ -157,8 +157,7 @@ static void percpu_rwsem_wait(struct percpu_rw_semaphore *sem, bool reader,
 	spin_unlock_irq(&sem->waiters.lock);
 
 	while (wait) {
-		set_current_state(TASK_UNINTERRUPTIBLE |
-				  (freeze ? TASK_FREEZABLE : 0));
+		set_current_state(freeze ? (TASK_IDLE | TASK_FREEZABLE) : TASK_UNINTERRUPTIBLE);
 		if (!smp_load_acquire(&wq_entry.private))
 			break;
 		schedule();


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
