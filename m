Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFAA442AFBE
	for <syzbot@lists.linux.dev>; Thu, 23 Jul 2026 16:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784823433; cv=none; b=ccaalFCZguB/9PDaZ0eRVVdk/6oh/m+y+3mAdZ9yk7aOS+QEP0e7G3Cvvq2NUvVpowDXOeExnnynfx0LUazOh31i5x9a/mByQGjLGVCLCp8QjxxIF2oFaLdJNidCgH4oL/f6MBaEbN+2nxo4JdZkgbVgsCbVavLxS+rvwTkCNH4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784823433; c=relaxed/simple;
	bh=sxD6Fcs1CTWVTAHw3EKxNw13zgzT5xxn7Cljoo2UedM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=RteZ8k3kJ+RR6Is6mlfZzXzEEpk0V1WnwxNcBMFCnz31IeZJ2JQkI+wvTJdGVCkrC64/6KOOa95VtyQRelAHpm4p/mFiBKsAJIqTHT2/9Sjd8QMgPmtFwyuT3mcrMOntHmBhmVQSUbLzhDE68GRAsKgOoioHr635imCSe6yM0KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id B4F1E1F000E9;
	Thu, 23 Jul 2026 16:17:10 +0000 (UTC)
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] btrfs: commit current transaction in btrfs_relocate_block_group
Message-ID: <38fe7b3f-75f7-47c9-9554-db7628338b20@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 23 Jul 2026 16:17:10 +0000 (UTC)

During block group relocation, btrfs_relocate_block_group() is called to
relocate a block group. It first makes the block group read-only by calling
btrfs_inc_block_group_ro(). If there are pending space reservations or
pinned extents in the current transaction, making the block group read-only
or subsequent relocation steps can fail, leading to a transaction abort and
a warning in cleanup_transaction() during the transaction commit in
prepare_to_relocate().

To fix this, commit the current transaction before calling
btrfs_inc_block_group_ro() in btrfs_relocate_block_group(). This ensures
that all pending extents are unpinned and space reservations are committed,
providing a clean state for marking the block group read-only.

WARNING: fs/btrfs/transaction.c:2068 at cleanup_transaction+0x727/0x7c0
Call Trace:
 <TASK>
 btrfs_commit_transaction+0x262c/0x30b0 fs/btrfs/transaction.c:2664
 prepare_to_relocate+0x3dd/0x4e0 fs/btrfs/relocation.c:3541
 relocate_block_group+0x141/0xe90 fs/btrfs/relocation.c:3566
 do_nonremap_reloc+0xa7/0x560 fs/btrfs/relocation.c:5323
 btrfs_relocate_block_group+0x6e2/0xaf0 fs/btrfs/relocation.c:5490
 btrfs_relocate_chunk+0x114/0x830 fs/btrfs/volumes.c:3647
 __btrfs_balance+0x1b6e/0x29e0 fs/btrfs/volumes.c:4586
 btrfs_balance+0xaa6/0x1180 fs/btrfs/volumes.c:4973
 btrfs_ioctl_balance+0x3dd/0x640 fs/btrfs/ioctl.c:3474
 </TASK>

Fixes: 72bd2323ec87 ("Btrfs: do not abort transaction at btrfs_update_root() after failure to COW path")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+021d10c4d4edc87daa03@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=021d10c4d4edc87daa03
Link: https://syzkaller.appspot.com/ai_job?id=1627ee87-ad22-4097-8936-8e307d6ddb4b
To: "Chris Mason" <clm@fb.com>
To: "David Sterba" <dsterba@suse.com>
To: <linux-btrfs@vger.kernel.org>
To: "Filipe Manana" <fdmanana@suse.com>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Replaced the transaction abort changes in the commit path with committing the current transaction before making the block group read-only during relocation.
- Removed changes to fs/btrfs/qgroup.c, fs/btrfs/root-tree.c, fs/btrfs/transaction.c, and fs/btrfs/transaction.h.
- Added a call to btrfs_commit_current_transaction() in btrfs_relocate_block_group() before calling btrfs_inc_block_group_ro().

v1:
https://lore.kernel.org/all/1586eaf3-2208-42eb-8877-7c4f83a6638c@mail.kernel.org/T/
---
diff --git a/fs/btrfs/relocation.c b/fs/btrfs/relocation.c
index fb85bc8b3..05f5110c2 100644
--- a/fs/btrfs/relocation.c
+++ b/fs/btrfs/relocation.c
@@ -5430,6 +5430,10 @@ int btrfs_relocate_block_group(struct btrfs_fs_info *fs_info, u64 group_start,
 	if (ret < 0)
 		goto out_put_rc;
 
+	ret = btrfs_commit_current_transaction(extent_root);
+	if (ret)
+		goto out;
+
 	ret = btrfs_inc_block_group_ro(rc->block_group, true);
 	if (ret)
 		goto out;


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
