Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 703F92F7F09
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 18:10:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782324616; cv=none; b=jxYjLrb/+iLtJLQfJ9tfpkwFJUJT1FdLAKUePL11iKzY4aIJpPrZFcrjGA7b0Dl3PyPEZ5ZoLcejrgfwCjYkvDA8CZ77ryiu/BDHDbQRm92YAWQ3G6nrAYZ/TSzKPJIKgpK5pIg+46pECCxYzU5bwlQSITHMWePBLVVqbO35CYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782324616; c=relaxed/simple;
	bh=U7F/e/0PSUexGQT3TUe5TCtnD/GVeTFULNf4c0Q/3NY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=tgUw7pbmIYAXnq7VGsecXIbZAbdoK+iRJbbPjk3Kzsi+Ft0lWjxftN5QvO8OrdMt2eL7yEpOJWrc9Jwra0mPMOtCarglqfNLAL0brWQZ9rtmWD3MMnX85FVVAI2A5WJWhC/74zDLQ91rRKu9QSZmYVjg4pTUmaNQ9Urq9DmHhiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=nu7/OlE5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="nu7/OlE5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0FFA31F000E9;
	Wed, 24 Jun 2026 18:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782324615;
	bh=l2XLe9sd86K+DopYwmQ4bu2ToGGAfGfKpP/ROZRBYKU=;
	h=From:To:Cc:Subject:Date;
	b=nu7/OlE5XU++pw4MN+LxFsV5l2u8k0MEvuk1vzEmONIydOolpCuemDOY3MhhA1xR6
	 8eBVRnuepz2X6cg4sn7gmBYkG8pzSYnWM38GKzgo/RbclydqNa/BiXTWD6i7QVAAvH
	 B1/J+iXFL2URUVK7v8BDXbUJ2fy3cP9CnFpf53+u96KCmQz1EUDz8B9zu3UCWcLBoQ
	 eWnoSTB8d5s8peSDvzrdWgFByGoDW2ifC6jyatKJ9mmOgqISGMxfoM6jlS0bA7Kjjp
	 pTnJVnxjifjX8FX5P3FrXPMf6GW/PynQ+Fz2PUpYKFmdUlvHPVc2rxEjZWyrpYb/zU
	 N0ssLaasD5PeA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] ext4: fix warning when starting journal on frozen filesystem
Message-ID: <83efa4e7-b102-4abd-bbfb-142fb7b3254a@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 24 Jun 2026 18:10:15 +0000 (UTC)

A WARNING is triggered in ext4_journal_check_start() when a background
writeback thread attempts to start a journal transaction on a frozen
filesystem:

WARNING: fs/ext4/ext4_jbd2.c:78 at ext4_journal_check_start+0x25a/0x2b0
fs/ext4/ext4_jbd2.c:78
Call Trace:
 <TASK>
 __ext4_journal_start_sb+0x147/0x5d0 fs/ext4/ext4_jbd2.c:107
 __ext4_journal_start fs/ext4/ext4_jbd2.h:242 [inline]
 ext4_do_writepages+0x1018/0x47a0 fs/ext4/inode.c:2930
 ext4_writepages+0x241/0x3b0 fs/ext4/inode.c:3042
 do_writepages+0x338/0x560 mm/page-writeback.c:2571
 __writeback_single_inode+0x12e/0xf90 fs/fs-writeback.c:1764
 writeback_sb_inodes+0x96d/0x18a0 fs/fs-writeback.c:2056
 wb_writeback+0x41c/0xad0 fs/fs-writeback.c:2241
 wb_do_writeback fs/fs-writeback.c:2388 [inline]
 wb_workfn+0x3f8/0xf10 fs/fs-writeback.c:2428
 </TASK>

The issue occurs during the EXT4_IOC_SHUTDOWN ioctl, which initiates a
freeze via ext4_force_shutdown() and bdev_freeze(). If fs_bdev_freeze()
successfully freezes the filesystem but sync_blockdev() fails (e.g., due to
an I/O error or ENOSPC), fs_bdev_freeze() returns an error without thawing
the filesystem. This leaves the filesystem stuck in the SB_FREEZE_COMPLETE
state.

Consequently, ext4_force_shutdown() sees the error and aborts immediately
without setting the EXT4_FLAGS_SHUTDOWN flag. Because sync_blockdev()
failed, dirty pages remain in the page cache. A background writeback thread
eventually retries writing them. Since the shutdown flag was never set,
ext4_do_writepages() assumes the filesystem is healthy and proceeds to
start a journal transaction, hitting the WARN_ON in
ext4_journal_check_start().

A background writeback thread can legitimately attempt to write dirty pages
on a frozen filesystem if ext4_writepages() previously failed (e.g., due to
ENOSPC or EDQUOT) during the sync_filesystem phase of the freeze. In such
cases, sync_filesystem can still return 0, allowing the freeze to complete
but leaving dirty pages behind. Since this sequence can legitimately
happen, WARN_ON must not be used for conditions that can legitimately
happen, and ext4_msg() should be used instead.

To fix this comprehensively, this patch implements a multi-layered
approach. First, it replaces the WARN_ON in ext4_journal_check_start() with
an ext4_msg() error log and an -EROFS return, as it is a recoverable state.
Second, it updates fs_bdev_freeze() to explicitly call thaw_super() to undo
the freeze if sync_blockdev() fails after a successful freeze_super().
Third, it updates ext4_force_shutdown() to set EXT4_FLAGS_SHUTDOWN even if
bdev_freeze() fails, ensuring the filesystem is properly marked as shut
down. Finally, it updates ext4_sync_fs() to return -EROFS if the journal is
aborted, ensuring that freeze_super() fails if the filesystem cannot be
cleanly synced.

Fixes: 49ef8832fb1a ("bdev: implement freeze and thaw holder operations")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+b75d75f957975f3d40e3@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b75d75f957975f3d40e3
Link: https://syzkaller.appspot.com/ai_job?id=a83c4c4e-9d52-4ccc-816d-160565cbc871
To: "Christian Brauner" <brauner@kernel.org>
To: <linux-ext4@vger.kernel.org>
To: <linux-fsdevel@vger.kernel.org>
To: "Theodore Ts'o" <tytso@mit.edu>
To: "Alexander Viro" <viro@zeniv.linux.org.uk>
Cc: "Andreas Dilger" <adilger.kernel@dilger.ca>
Cc: "Jan Kara" <jack@suse.cz>
Cc: "Baokun Li" <libaokun@linux.alibaba.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Ojaswin Mujoo" <ojaswin@linux.ibm.com>
Cc: "Ritesh Harjani (IBM)" <ritesh.list@gmail.com>
Cc: "Zhang Yi" <yi.zhang@huawei.com>

---
diff --git a/fs/ext4/ext4_jbd2.c b/fs/ext4/ext4_jbd2.c
index 9a8c225f2..1756039b1 100644
--- a/fs/ext4/ext4_jbd2.c
+++ b/fs/ext4/ext4_jbd2.c
@@ -75,7 +75,13 @@ static int ext4_journal_check_start(struct super_block *sb)
 	if (WARN_ON_ONCE(sb_rdonly(sb)))
 		return -EROFS;
 
-	WARN_ON(sb->s_writers.frozen == SB_FREEZE_COMPLETE);
+	if (unlikely(sb->s_writers.frozen == SB_FREEZE_COMPLETE)) {
+		ext4_msg(
+			sb, KERN_ERR,
+			"Attempt to start a journal transaction on a frozen filesystem");
+		return -EROFS;
+	}
+
 	journal = EXT4_SB(sb)->s_journal;
 	/*
 	 * Special case here: if the journal has aborted behind our
diff --git a/fs/ext4/ioctl.c b/fs/ext4/ioctl.c
index 1d0c3d4bd..30d92fc09 100644
--- a/fs/ext4/ioctl.c
+++ b/fs/ext4/ioctl.c
@@ -824,8 +824,10 @@ int ext4_force_shutdown(struct super_block *sb, u32 flags)
 	switch (flags) {
 	case EXT4_GOING_FLAGS_DEFAULT:
 		ret = bdev_freeze(sb->s_bdev);
-		if (ret)
+		if (ret) {
+			set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
 			return ret;
+		}
 		set_bit(EXT4_FLAGS_SHUTDOWN, &sbi->s_ext4_flags);
 		bdev_thaw(sb->s_bdev);
 		break;
diff --git a/fs/ext4/super.c b/fs/ext4/super.c
index 6a77db4d3..71735a31f 100644
--- a/fs/ext4/super.c
+++ b/fs/ext4/super.c
@@ -6438,6 +6438,9 @@ static int ext4_sync_fs(struct super_block *sb, int wait)
 	if (unlikely(ret))
 		return ret;
 
+	if (sbi->s_journal && is_journal_aborted(sbi->s_journal))
+		return -EROFS;
+
 	trace_ext4_sync_fs(sb, wait);
 	flush_workqueue(sbi->rsv_conversion_wq);
 	/*
diff --git a/fs/super.c b/fs/super.c
index 378e81efe..1077e3f0d 100644
--- a/fs/super.c
+++ b/fs/super.c
@@ -1541,8 +1541,22 @@ static int fs_bdev_freeze(struct block_device *bdev)
 	else
 		error = freeze_super(sb,
 				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
-	if (!error)
+	if (!error) {
 		error = sync_blockdev(bdev);
+		if (error) {
+			if (sb->s_op->thaw_super)
+				sb->s_op->thaw_super(
+					sb,
+					FREEZE_MAY_NEST |
+						FREEZE_HOLDER_USERSPACE,
+					NULL);
+			else
+				thaw_super(sb,
+					   FREEZE_MAY_NEST |
+						   FREEZE_HOLDER_USERSPACE,
+					   NULL);
+		}
+	}
 	deactivate_super(sb);
 	return error;
 }


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
