Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1277739732C
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 10:45:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785321961; cv=none; b=EXt/woqLuWP3PUxUceAKDS4Fk4ns7N+FFXF7Dn0Zrk79YopFDPvuaSYivcFE7hALTTnbcNvZwmEY7kuxcAV5Hdp5ieHWh9vhtQTjBMwRCSLFYrauMHn/av4/M6V8WedNglzl6+bYUMSyfoGaaUuAMQOmlNFRCY/7U7ykYybDlcA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785321961; c=relaxed/simple;
	bh=FTsEXVUuvqbeaANqV3ZF/m/TylBRv/93ExUiQIZTehQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=DWBsTs9i1HzBPU2Wqbg18fzn54B0jM0GUpmHQtzdQzsCrtU6xPlHnEV0DDcUtLoNPVUROmdYFfsQcC3UlMXoul5tAZQJjaOvPf+IKSxPFvCwJCxDsnNRYP+67AmIqAXUJkKDr1IELtUFpYv+RKVrn+kFGAK2fnR0YeJZEy6AtOA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=c0fqRDAa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="c0fqRDAa"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 809731F000E9;
	Wed, 29 Jul 2026 10:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785321957;
	bh=QB8pDhM834hwn8HaYwHEpIyeGfojuV9Rb9M8NfqeKW4=;
	h=From:To:Cc:Subject:Date;
	b=c0fqRDAawKiqbpcYbbLjVdLf7WnFUMggpjtYDsUveXuVJ5X0s+DKc6uiMZ6snUYgv
	 09+Py+nqvQdoAahyF55+Pd5MGTy9nLWuYeYG/GdojFL82/p1dj+G69m48TKnSC3ChX
	 WPIvORqvEiO0PR7O5P7tVaCOakSxkGJZJehvbGUKA6wvB22aCB0TzFVNY/dA5D76SC
	 AmdnVyRdydKrxR/RlU3gHy2GWZeJWK/tgkzyriBhXm1G9yir/5CPJyZVFSKSeebBPa
	 4ojRDPZ1QAMdkkEab266GGLXCLWiqXK6uG4pCPkhtx26y3tJbsh6Xk5FGStkdrVZpT
	 d6yTV26o+jrEw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: kusaram@devineni.in, syzbot@lists.linux.dev
Subject: [PATCH RFC v4] jfs: validate BT_ROOT flag in xt_getpage and DT_GETPAGE
Message-ID: <e6d4dd6f-c7c4-4c4e-92dd-8338fa4c1404@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 29 Jul 2026 10:45:57 +0000 (UTC)

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

BUG: spinlock bad magic on CPU#1, comm/6074
 lock: 0xffff8881f71d1b48, .magic: ffffffff, .owner: /-1902340672,
 .owner_cpu: 768
CPU: 1 UID: 0 PID: 6074 Comm: comm Not tainted #1 PREEMPT(full)
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
 ...
 </TASK>

UBSAN: array-index-out-of-bounds in kernel/locking/qspinlock.h:68:9
index 8945 is out of range for type 'unsigned long[8]'
CPU: 1 UID: 0 PID: 6074 Comm: comm Not tainted #1 PREEMPT(full)
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
 decode_tail kernel/locking/qspinlock.h:68 [inline]
 __pv_queued_spin_lock_slowpath+0xaf3/0xbc0 kernel/locking/qspinlock.c:285
 pv_queued_spin_lock_slowpath arch/x86/include/asm/paravirt-spinlock.h:35
 [inline]
 queued_spin_lock_slowpath arch/x86/include/asm/paravirt-spinlock.h:66
 [inline]
 queued_spin_lock include/asm-generic/qspinlock.h:114 [inline]
 do_raw_spin_lock+0x26c/0x2f0 kernel/locking/spinlock_debug.c:116
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock_irqsave+0x4c/0x60 kernel/locking/spinlock.c:166
 __wake_up_common_lock+0x30/0x1f0 kernel/sched/wait.c:124
 unlock_metapage fs/jfs/jfs_metapage.c:40 [inline]
 release_metapage+0x131/0xa60 fs/jfs/jfs_metapage.c:872
 xtTruncate+0xeaa/0x2eb0 fs/jfs/jfs_xtree.c:-1
 ...
 </TASK>

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+e380443eaa59bfb75a84@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e380443eaa59bfb75a84
Link: https://syzkaller.appspot.com/ai_job?id=a0b45181-6c6e-42a4-85c9-89f4273612e3
To: <jfs-discussion@lists.sourceforge.net>
To: "Dave Kleikamp" <shaggy@kernel.org>
Cc: "Arnd Bergmann" <arnd@arndb.de>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Yun Zhou" <yun.zhou@windriver.com>
Cc: "Zheng Yu" <zheng.yu@northwestern.edu>

---
v4:
- Avoided unnecessary whitespace and formatting changes in DT_GETPAGE and xt_getpage.
- Kept the existing DT_GETPAGE error message for both corruption checks.

v3:
- Validated root/non-root invariant failures and non-root dtpage integrity failures.
- Removed '------------[ cut here ]------------' from the commit message.
https://lore.kernel.org/all/31d895c9-6ed8-4661-ab39-2e3709540323@mail.kernel.org/T/

v2:
- Combined the BT_ROOT flag validation with the existing page integrity check in DT_GETPAGE.
- Unified the error message in DT_GETPAGE for both root and leaf page corruption.
https://lore.kernel.org/all/b94e1523-acdb-4470-904e-373249bbf83d@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/65efb3d8-bbf9-4f4b-800e-b9bc5577b381@mail.kernel.org/T/
---
diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
index ac0f79faf..0d372a237 100644
--- a/fs/jfs/jfs_dtree.c
+++ b/fs/jfs/jfs_dtree.c
@@ -115,7 +115,8 @@ struct dtsplit {
 do {									\
 	BT_GETPAGE(IP, BN, MP, dtpage_t, SIZE, P, RC, i_dtroot);	\
 	if (!(RC)) {							\
-		if ((BN) && !check_dtpage(P)) {				\
+		if ((((BN) == 0) != !!((P)->header.flag & BT_ROOT)) ||	\
+		    ((BN) && !check_dtpage(P))) {			\
 			BT_PUTPAGE(MP);					\
 			jfs_error((IP)->i_sb,				\
 				  "DT_GETPAGE: dtree page corrupt\n");	\
diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
index 28c3cf960..3a5f9d035 100644
--- a/fs/jfs/jfs_xtree.c
+++ b/fs/jfs/jfs_xtree.c
@@ -121,7 +121,8 @@ static inline xtpage_t *xt_getpage(struct inode *ip, s64 bn, struct metapage **m
 		(le16_to_cpu(p->header.nextindex) >
 			le16_to_cpu(p->header.maxentry)) ||
 		(le16_to_cpu(p->header.maxentry) >
-			((bn == 0) ? XTROOTMAXSLOT : PSIZE >> L2XTSLOTSIZE))) {
+			((bn == 0) ? XTROOTMAXSLOT : PSIZE >> L2XTSLOTSIZE)) ||
+		((bn == 0) != !!(p->header.flag & BT_ROOT))) {
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
