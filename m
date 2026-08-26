Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AA0B211466
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 18:30:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787769034; cv=none; b=QUryKg92kjbiuOJBdz/zo9VHc9iLshnRyThdHRK4TfCfABRB9au4vGMhMF3qNGPLg2ldfaFwN3cAMA7dru1wM9nYVCuPmOFsgpv5TQwsK0qBQBHSYAaJ9OjK28GJuOrm/JBKpwjKeGoxNcnK6NNWfuTNHtnHZlVjdg1+QMtq64c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787769034; c=relaxed/simple;
	bh=KEZQBO1hK1RFQK0AsQL5uJa04wzJCelhZMKGQsTAbZc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=dUjBqHAcmTzkAfragMRpnk5qDx9YV1eEj1UV/nF867jf7/k6Gkf4COmChfeNxSaML+Ht3Z3r3ctgO44kDVi9otvL8YnLHK4OikIc8gmFBHZrVrulXiojDMRe/HUlFzMmL0VDavWPdgwKRXztlXmKIfFTZahI/RzYHJJc1cDEA0U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JJkgBFMC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JJkgBFMC"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D9631F000E9;
	Wed, 26 Aug 2026 18:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787769022;
	bh=cbs+9kaL+tWsxhgX7aA5B3/IKT81BQjKw0pYVQGF4fA=;
	h=From:To:Cc:Subject:Date;
	b=JJkgBFMCyac0hVBFq+mVywBtjFN1JIiFNSrx+lFErI/XikkT/VvsQG/poRIy0IoNG
	 Fkt1gHSH41SxIvDwghR/sxpZnVXpdvWcC9OBNeY+P4HeONefKfdsnflEzdnc/0n7Qi
	 bNrJFehU+NUXNcXbZ4t647pP000XQb/YmdjUOQKAXqFlSB0HCAdmpkq/HJx1lQg3hk
	 tp+XS3oMwyzGetRh3UR1b0Zr/iSw5JFnRC/ujr1+eNBiSqUA8GyaDfHj5nldW8ATzU
	 +rLSSvsnczod9ZncIfhpoHwuaKrRkUAC7aDUqnqidNJ6kSDcC2IZiUcDRHEJgM/Rc5
	 yGqwCDIAyOoSw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] befs: validate block_shift and ag_shift in superblock
Message-ID: <eb374777-9264-40ee-9352-fb38991496d0@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 26 Aug 2026 18:30:22 +0000 (UTC)

When mounting a BeFS filesystem, befs_fill_super() calls befs_check_sb() to
validate filesystem parameters loaded from the superblock. During
consistency checks, befs_check_sb() evaluates expressions (1 <<
befs_sb->block_shift) and (1 << befs_sb->ag_shift). Because block_shift and
ag_shift are 32-bit values read directly from the disk image without prior
bounds checking, a corrupted or crafted filesystem image with shift
exponents >= 32 triggers undefined behavior and causes UBSAN
shift-out-of-bounds warnings:

UBSAN: shift-out-of-bounds in fs/befs/super.c:96:9
shift exponent 2066842816 is too large for 32-bit type 'int'
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
 befs_check_sb+0x434/0x4e0 fs/befs/super.c:96
 befs_fill_super+0x496/0xa90 fs/befs/linuxvfs.c:843
 get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1640
 vfs_get_tree+0x92/0x2a0 fs/super.c:1700
 do_new_mount+0x319/0xdc0 fs/namespace.c:3841
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4367
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Additionally, if an invalid ag_shift >= 32 is allowed to pass superblock
validation, it causes further shift-out-of-bounds issues during subsequent
address calculations in iaddr2blockno() and blockno2iaddr(). Furthermore,
in those translation helpers, iaddr->allocation_group is a 32-bit integer,
and shifting it left by ag_shift before promotion causes 32-bit integer
truncation for large allocation groups.

Fix these issues by:
- Checking that block_shift < 32 and ag_shift < 32 before shifting, and
using unsigned integer literals (1U) in befs_check_sb().
- Treating ag_shift >= 32 as a fatal error in befs_check_sb().
- Casting allocation_group to befs_blocknr_t prior to left-shifting in
iaddr2blockno() and blockno2iaddr().

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+fc26c366038b54261e53@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=fc26c366038b54261e53
Link: https://syzkaller.appspot.com/ai_job?id=73a3bc3d-6bc4-471d-b4e5-6f4cd5b0908e
To: <linux-kernel@vger.kernel.org>
To: "Luis de Bethencourt" <luisbg@kernel.org>
To: "Salah Triki" <salah.triki@gmail.com>
To: "Linus Torvalds" <torvalds@ppc970.osdl.org>

---
diff --git a/fs/befs/befs.h b/fs/befs/befs.h
index 7cd472456..b8c7b7f81 100644
--- a/fs/befs/befs.h
+++ b/fs/befs/befs.h
@@ -122,7 +122,7 @@ BEFS_I(const struct inode *inode)
 static inline befs_blocknr_t
 iaddr2blockno(struct super_block *sb, const befs_inode_addr *iaddr)
 {
-	return ((iaddr->allocation_group << BEFS_SB(sb)->ag_shift) +
+	return (((befs_blocknr_t)iaddr->allocation_group << BEFS_SB(sb)->ag_shift) +
 		iaddr->start);
 }
 
@@ -133,7 +133,7 @@ blockno2iaddr(struct super_block *sb, befs_blocknr_t blockno)
 
 	iaddr.allocation_group = blockno >> BEFS_SB(sb)->ag_shift;
 	iaddr.start =
-	    blockno - (iaddr.allocation_group << BEFS_SB(sb)->ag_shift);
+	    blockno - ((befs_blocknr_t)iaddr.allocation_group << BEFS_SB(sb)->ag_shift);
 	iaddr.len = 1;
 
 	return iaddr;
diff --git a/fs/befs/super.c b/fs/befs/super.c
index 7c50025c9..9f21f732d 100644
--- a/fs/befs/super.c
+++ b/fs/befs/super.c
@@ -93,17 +93,22 @@ befs_check_sb(struct super_block *sb)
 	 * in different ways as a consistency check.
 	 */
 
-	if ((1 << befs_sb->block_shift) != befs_sb->block_size) {
+	if (befs_sb->block_shift >= 32 ||
+	    (1U << befs_sb->block_shift) != befs_sb->block_size) {
 		befs_error(sb, "block_shift disagrees with block_size. "
 			   "Corruption likely.");
 		return BEFS_ERR;
 	}
 
-
 	/* ag_shift also encodes the same information as blocks_per_ag in a
 	 * different way, non-fatal consistency check
 	 */
-	if ((1 << befs_sb->ag_shift) != befs_sb->blocks_per_ag)
+	if (befs_sb->ag_shift >= 32) {
+		befs_error(sb, "ag_shift >= 32. Corruption likely.");
+		return BEFS_ERR;
+	}
+
+	if ((1U << befs_sb->ag_shift) != befs_sb->blocks_per_ag)
 		befs_error(sb, "ag_shift disagrees with blocks_per_ag.");
 
 	if (befs_sb->log_start != befs_sb->log_end ||


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
