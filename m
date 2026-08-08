Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1433D15A86D
	for <syzbot@lists.linux.dev>; Sat,  8 Aug 2026 04:50:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786164658; cv=none; b=O5fIW+R4vcCNd/501j0k3bWeZgHz2XlIBnO3mFlEqoPkR860/+KDr27SQmOJIW++K9iOfXfCyOn6G7U6yVMrJYS2zSkgVrdJ9EASLRYi+TKgnJFY4BNH971v7+4ULPWJoM39ZCQmm5B0ZcBc/7tWShEPpZ45p6nDRbOPefwer3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786164658; c=relaxed/simple;
	bh=skaUxwzkKE/sKPN+QHjSWT6T24EUsu0Gn7HtuE5KDHs=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=U51YOQtMjyEQ8UjvmMRGD+0QLhIu2sUPL0LtlHgF/EOA2t7ZntNlwUiUn+JbWE8ZUeF2+Ao6qsBAcLlBvQr21pFbRHzZNYhSqUvu8IEofAToPgBPJVG/G23dWKbFPISFwLRpbJ8k73sQj7v2u4rDLFvvyvLNPRPMMKkzOW/kHOg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Awpny1dY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Awpny1dY"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 8333B1F000E9;
	Sat,  8 Aug 2026 04:50:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786164656;
	bh=hIwpmJ6GkxoIqN8hjanzWPZNjliSAJTUIPVuJqxaWNM=;
	h=From:To:Cc:Subject:Date;
	b=Awpny1dYX6qfE6KtLLjqt+n5vlfhg4NMFw2FKF454GmWdTnvxgvozhE39RMc+h77H
	 4VWcv+DD23EMh1q0EMkbmzEGCmxe9JJvPYruiS6lOX7YtxvkElHppbCctL2WdEnuvv
	 bJRSan83Dag6B8GYwh69hlkoaxmPnAH/DVZk4EMBN3nOvG0IRlOP/pyU0f/UGkRc/O
	 MW05cUG93T8gHuPOJsBzq4B7VmIgQOPrzlPSyEZET2oqHK1dlnYh9Kp5xp4Em+x9Xd
	 g6NhCzLyLizKB1pli16D4UQTmOtTJXC1d2YAnwkBzLdAzB+cX+VCt0XKK5J2gXzEW+
	 +nH4zPpplkIIg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] btrfs: check system chunk space before removing device extents
Message-ID: <dc6f919f-966d-41dc-91a1-846dae1b8860@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat,  8 Aug 2026 04:50:56 +0000 (UTC)

During a chunk relocation/balance operation, a transaction abort with
-ENOSPC can occur in btrfs_remove_chunk(). This happens because the
filesystem runs out of system space while trying to remove a chunk item
from the chunk tree, and it cannot allocate a new system chunk.

The crash trace is as follows:

WARNING: fs/btrfs/volumes.c:3526 at btrfs_remove_chunk+0xc9b/0x1070
Call Trace:
 <TASK>
 btrfs_relocate_chunk_finish fs/btrfs/volumes.c:3614 [inline]
 btrfs_relocate_chunk+0x3e5/0x810 fs/btrfs/volumes.c:3668
 __btrfs_balance+0x1b5f/0x29d0 fs/btrfs/volumes.c:4586
 btrfs_balance+0xaa6/0x1180 fs/btrfs/volumes.c:4973
 btrfs_ioctl_balance+0x3da/0x640 fs/btrfs/ioctl.c:3481
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

The sequence of events leading to the abort is as follows. First,
btrfs_remove_chunk() removes the device extents from the device tree by
calling btrfs_remove_dev_extents(). It then calls check_system_chunk() to
reserve system space for removing the chunk item from the chunk tree. If
the system space is full, check_system_chunk() attempts to allocate a new
system chunk. To allocate a new chunk, find_free_dev_extent() is called.
However, find_free_dev_extent() searches the commit root of the device tree
to prevent reusing space freed in the current transaction. Because the
device extents were just freed in the current transaction by
btrfs_remove_dev_extents(), find_free_dev_extent() does not see this freed
space. If the device is otherwise full, it returns -ENOSPC.
check_system_chunk() ignores the failure to allocate a system chunk and
does not reserve any space. Finally, remove_chunk_item() is called, which
fails with -ENOSPC because it needs to COW a node in the chunk tree but no
system space was reserved. Since btrfs_remove_dev_extents() has already
modified the device tree, btrfs_remove_chunk() cannot fail gracefully and
is forced to abort the transaction.

To fix this, we must ensure that we have enough system space before
modifying the device tree. We change check_system_chunk() and
reserve_chunk_space() to return an int error code. In btrfs_remove_chunk(),
we call check_system_chunk() early. If it fails, we can fail gracefully and
return -ENOSPC before any irreversible tree modifications occur. If it
succeeds, we immediately release the reserved metadata space using
btrfs_trans_release_chunk_metadata(). This is necessary because
btrfs_remove_dev_extents() can trigger nested chunk allocations which
unconditionally release all chunk metadata reservations. We then proceed to
call check_system_chunk() a second time later in the function to make the
actual reservation, which is now guaranteed to succeed since we ensured the
system space_info has enough free space.

Fixes: 79bd37120b14 ("btrfs: rework chunk allocation to avoid exhaustion of the system chunk array")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+e8582cc16881ec70a430@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=e8582cc16881ec70a430
Link: https://syzkaller.appspot.com/ai_job?id=399adcc1-1743-4bd3-bec2-62461394dbb5
To: "Chris Mason" <clm@fb.com>
To: "David Sterba" <dsterba@suse.com>
To: <linux-btrfs@vger.kernel.org>
To: "Filipe Manana" <fdmanana@suse.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/btrfs/block-group.c b/fs/btrfs/block-group.c
index 8def7abb7..b99bd7bdf 100644
--- a/fs/btrfs/block-group.c
+++ b/fs/btrfs/block-group.c
@@ -4488,9 +4488,9 @@ static u64 get_profile_num_devs(const struct btrfs_fs_info *fs_info, u64 type)
 	return num_dev;
 }
 
-static void reserve_chunk_space(struct btrfs_trans_handle *trans,
-				u64 bytes,
-				u64 type)
+static int reserve_chunk_space(struct btrfs_trans_handle *trans,
+			       u64 bytes,
+			       u64 type)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	struct btrfs_space_info *info;
@@ -4565,13 +4565,15 @@ static void reserve_chunk_space(struct btrfs_trans_handle *trans,
 		if (!ret)
 			trans->chunk_bytes_reserved += bytes;
 	}
+
+	return ret;
 }
 
 /*
  * Reserve space in the system space for allocating or removing a chunk.
  * The caller must be holding fs_info->chunk_mutex.
  */
-void check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
+int check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
 {
 	struct btrfs_fs_info *fs_info = trans->fs_info;
 	const u64 num_devs = get_profile_num_devs(fs_info, type);
@@ -4581,7 +4583,7 @@ void check_system_chunk(struct btrfs_trans_handle *trans, u64 type)
 	bytes = btrfs_calc_metadata_size(fs_info, num_devs) +
 		btrfs_calc_insert_metadata_size(fs_info, 1);
 
-	reserve_chunk_space(trans, bytes, type);
+	return reserve_chunk_space(trans, bytes, type);
 }
 
 /*
diff --git a/fs/btrfs/block-group.h b/fs/btrfs/block-group.h
index 790c2d467..43800523b 100644
--- a/fs/btrfs/block-group.h
+++ b/fs/btrfs/block-group.h
@@ -378,7 +378,7 @@ int btrfs_chunk_alloc(struct btrfs_trans_handle *trans,
 		      struct btrfs_space_info *space_info, u64 flags,
 		      enum btrfs_chunk_alloc_enum force);
 int btrfs_force_chunk_alloc(struct btrfs_trans_handle *trans, u64 type);
-void check_system_chunk(struct btrfs_trans_handle *trans, const u64 type);
+int check_system_chunk(struct btrfs_trans_handle *trans, const u64 type);
 void btrfs_reserve_chunk_metadata(struct btrfs_trans_handle *trans,
 				  bool is_item_insertion);
 u64 btrfs_get_alloc_profile(struct btrfs_fs_info *fs_info, u64 orig_flags);
diff --git a/fs/btrfs/volumes.c b/fs/btrfs/volumes.c
index 6eab4cc73..e77306e09 100644
--- a/fs/btrfs/volumes.c
+++ b/fs/btrfs/volumes.c
@@ -3463,6 +3463,24 @@ int btrfs_remove_chunk(struct btrfs_trans_handle *trans, u64 chunk_offset)
 		return PTR_ERR(map);
 	}
 
+	/*
+	 * Check if we have enough system space to remove the chunk.
+	 * If we don't, and we can't allocate a new system chunk, we fail gracefully
+	 * before modifying the device tree.
+	 */
+	mutex_lock(&fs_info->chunk_mutex);
+	ret = check_system_chunk(trans, map->type);
+	if (ret) {
+		mutex_unlock(&fs_info->chunk_mutex);
+		goto out;
+	}
+	/*
+	 * Release the block reserve. We just wanted to ensure the system
+	 * space_info has enough free space. We will reserve it again later.
+	 */
+	btrfs_trans_release_chunk_metadata(trans);
+	mutex_unlock(&fs_info->chunk_mutex);
+
 	ret = btrfs_remove_dev_extents(trans, map);
 	if (ret)
 		goto out;


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
