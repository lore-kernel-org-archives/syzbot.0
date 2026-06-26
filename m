Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6912C3AEF50
	for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 22:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782512095; cv=none; b=nS3KHwLpldTeAIz6GoufH+r2oZ8Ehf9DvSAOOmtMr1IkGHK63FPYvCudKKPEXdqL4+4VgRBeRZ/4+3iIAss399sa4e+elEn6U6douTvtCylPW0ftVmReJBp1pzhbpxhZWSiTrKFKFooy9Gq4Xb8kmZn1V4TwZ9vjbIl2Ldd2S6k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782512095; c=relaxed/simple;
	bh=m1kS0P3TWEqW6hT99ifeLRnAOsPgwMFzOOi9aq01efM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=jki3jIRHOM+81vwY0Y4hSOf4GUGzZlowzU8iQbpxtAyyVcGUOK1E82aS/lwdCU9Rt8P2+WXdMZZUg9CUYDdJRtEZRW/ohHkcv79Wnn29Vyxxvyq+D9fxbvOnuX+gSdE9sPYMS+dJY/PLusseItIg0BzON+Bou4GP4IqB0njJ6cc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LFZjg7bY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LFZjg7bY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 09C731F000E9;
	Fri, 26 Jun 2026 22:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782512094;
	bh=mkNJkoCY4xrkBGgPIc0y59YvBRXo1dN4qZI0J3U7GHQ=;
	h=From:To:Cc:Subject:Date;
	b=LFZjg7bYs7dJ1jfy3rVAsJp0M+hjGGlgSQKe/T7YXku4bnKCDCClfFJJ9hXp7c1Zo
	 /5/RhZEKewOphnkZDkHOXKDiPDbpwQ8zAe6bZ7MALiRYL1Y0YMrLeELrASxFAu0ERW
	 RBRlPXKOxXaRl/lxgZegNsMzn8tTfEXmcq8m590i34O6I01c85onv6l053k9LBcYch
	 lamBhCO9mJEfjiWQFAejToGaDxEiKmzRFliHD1ZVDOwgowSx+EBHE7RfZYEWDGM1th
	 rJsfZ1Sa2O1RcjB58SAJCT8G4I80hIHKdDW3l857VZz07HYHf8NNgXsgH06jWPw5m6
	 P5b6GvVPyKv+Q==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] jfs: validate BT_ROOT flag in xt_getpage and DT_GETPAGE
Message-ID: <65efb3d8-bbf9-4f4b-800e-b9bc5577b381@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 26 Jun 2026 22:14:53 +0000 (UTC)

A corrupted JFS image can trick the kernel into calling release_metapage()
on a pseudo-metapage embedded within the inode, leading to an out-of-bounds
memory access and a spinlock crash.

When operating on the root page of an xtree or dtree (which is stored
inline within the inode), JFS doesn't use a real struct metapage. Instead,
BT_GETPAGE() sets the metapage pointer to the address of
JFS_IP(ip)->bxflag. Because this is a pseudo-metapage, it does not have a
valid wait_queue_head_t wait field. Accessing mp->wait reads out-of-bounds
memory in struct jfs_inode_info.

In xt_getpage(), the code validates nextindex and maxentry, but it fails to
verify that the BT_ROOT flag is set in p->header.flag for the root page (bn
== 0). If the inline xtree root page has a corrupted header.flag where
BT_ROOT is missing, xtTruncate() will mistakenly treat the root page as a
regular leaf page and call discard_metapage(mp).

Unlike XT_PUTPAGE() which safely checks !BT_IS_ROOT(mp) before releasing,
discard_metapage() calls release_metapage(mp) directly. This assumes mp is
a real metapage and calls unlock_metapage(mp), which executes
wake_up(&mp->wait), accessing garbage memory and resulting in a spinlock
bad magic BUG or UBSAN out-of-bounds array access.

Fix this by enforcing the invariant that the BT_ROOT flag is set if and
only if bn == 0 in both xt_getpage() and DT_GETPAGE().

BUG: spinlock bad magic on CPU#0, syz-executor/6066
 lock: 0xffff888120999b48, .magic: ffffffff, .owner: <...>/-1902340672,
 .owner_cpu: 768
CPU: 0 UID: 0 PID: 6066 Comm: syz-executor Not tainted syzkaller #1
PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 spin_bug kernel/locking/spinlock_debug.c:78 [inline]
 debug_spin_lock_before kernel/locking/spinlock_debug.c:86 [inline]
 do_raw_spin_lock+0x1e5/0x2f0 kernel/locking/spinlock_debug.c:115
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock_irqsave+0x4c/0x60 kernel/locking/spinlock.c:166
 __wake_up_common_lock+0x30/0x1f0 kernel/sched/wait.c:124
 unlock_metapage fs/jfs/jfs_metapage.c:40 [inline]
 release_metapage+0x131/0xa60 fs/jfs/jfs_metapage.c:872
 xtTruncate+0xeaa/0x2eb0 fs/jfs/jfs_xtree.c:-1
 jfs_free_zero_link+0x35b/0x4c0 fs/jfs/namei.c:760
 jfs_evict_inode+0x356/0x430 fs/jfs/inode.c:159
 evict+0x624/0xb50 fs/inode.c:841
 __dentry_kill+0x206/0x700 fs/dcache.c:718
 shrink_kill+0xa9/0x2c0 fs/dcache.c:1195
 shrink_dentry_list+0x2e0/0x5e0 fs/dcache.c:1222
 shrink_dcache_tree+0xe9/0x5d0 fs/dcache.c:-1
 do_one_tree+0x28/0xe0 fs/dcache.c:1721
 shrink_dcache_for_umount+0xa0/0x170 fs/dcache.c:1738
 generic_shutdown_super+0x6f/0x2d0 fs/super.c:624
 kill_block_super+0x44/0x90 fs/super.c:1725
 deactivate_locked_super+0xbc/0x130 fs/super.c:476
 cleanup_mnt+0x3d3/0x460 fs/namespace.c:1312
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xf3/0x4f0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230
 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x33e/0x560 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+e380443eaa59bfb75a84@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e380443eaa59bfb75a84
Link: https://syzkaller.appspot.com/ai_job?id=b075f2b7-e5d3-4157-9efa-ee28c166187b
To: <jfs-discussion@lists.sourceforge.net>
To: "Dave Kleikamp" <shaggy@kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Suchit Karunakaran" <suchitkarunakaran@gmail.com>
Cc: "Yun Zhou" <yun.zhou@windriver.com>
Cc: "Zheng Yu" <zheng.yu@northwestern.edu>

---
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index ac0f79faf..bbb157daf 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -111,19 +111,26 @@ struct dtsplit {
 #define DT_PAGE(IP, MP) BT_PAGE(IP, MP, dtpage_t, i_dtroot)
 
 /* get page buffer for specified block address */
-#define DT_GETPAGE(IP, BN, MP, SIZE, P, RC)				\
-do {									\
-	BT_GETPAGE(IP, BN, MP, dtpage_t, SIZE, P, RC, i_dtroot);	\
-	if (!(RC)) {							\
-		if ((BN) && !check_dtpage(P)) {				\
-			BT_PUTPAGE(MP);					\
-			jfs_error((IP)->i_sb,				\
-				  "DT_GETPAGE: dtree page corrupt\n");	\
-			MP = NULL;					\
-			RC = -EIO;					\
-		}							\
-	}								\
-} while (0)
+#define DT_GETPAGE(IP, BN, MP, SIZE, P, RC)                                       \
+	do {                                                                      \
+		BT_GETPAGE(IP, BN, MP, dtpage_t, SIZE, P, RC, i_dtroot);          \
+		if (!(RC)) {                                                      \
+			if (((BN) == 0) != !!((P)->header.flag & BT_ROOT)) {      \
+				BT_PUTPAGE(MP);                                   \
+				jfs_error(                                        \
+					(IP)->i_sb,                               \
+					"DT_GETPAGE: dtree root page corrupt\n"); \
+				MP = NULL;                                        \
+				RC = -EIO;                                        \
+			} else if ((BN) && !check_dtpage(P)) {                    \
+				BT_PUTPAGE(MP);                                   \
+				jfs_error((IP)->i_sb,                             \
+					  "DT_GETPAGE: dtree page corrupt\n");    \
+				MP = NULL;                                        \
+				RC = -EIO;                                        \
+			}                                                         \
+		}                                                                 \
+	} while (0)
 
 /* for consistency */
 #define DT_PUTPAGE(MP) BT_PUTPAGE(MP)
diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
index 28c3cf960..6d960dd96 100644
--- a/fs/jfs/jfs_xtree.c
+++ b/fs/jfs/jfs_xtree.c
@@ -118,10 +118,11 @@ static inline xtpage_t *xt_getpage(struct inode *ip, s64 bn, struct metapage **m
 	if (rc)
 		return ERR_PTR(rc);
 	if ((le16_to_cpu(p->header.nextindex) < XTENTRYSTART) ||
-		(le16_to_cpu(p->header.nextindex) >
-			le16_to_cpu(p->header.maxentry)) ||
-		(le16_to_cpu(p->header.maxentry) >
-			((bn == 0) ? XTROOTMAXSLOT : PSIZE >> L2XTSLOTSIZE))) {
+	    (le16_to_cpu(p->header.nextindex) >
+	     le16_to_cpu(p->header.maxentry)) ||
+	    (le16_to_cpu(p->header.maxentry) >
+	     ((bn == 0) ? XTROOTMAXSLOT : PSIZE >> L2XTSLOTSIZE)) ||
+	    ((bn == 0) != !!(p->header.flag & BT_ROOT))) {
 		jfs_error(ip->i_sb, "xt_getpage: xtree page corrupt\n");
 		BT_PUTPAGE(*mp);
 		*mp = NULL;


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
