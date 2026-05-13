Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42DE65474F
	for <syzbot@lists.linux.dev>; Wed, 13 May 2026 00:03:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778630633; cv=none; b=Dut46Ar8vzFNTzQYaW1Du5rF5gUbAiI7JcVnA+O9eZlWiI8qoyH9ovvMalsadv3AirNMeB9vz4OnXIxtnO+0a/KtgCFPoS3PlEHkXTE+6bt3AHNNOeJLhF7Mnq0DpiYGOaGwfTui9cZM4TpAbr/tQIW3OYwjV0JqZ56EE2fqN/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778630633; c=relaxed/simple;
	bh=VxYqUMpDL0lXRBHmaFrM/MWPoyM8aXmObW+B9KxAjxk=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=smfc8Sd3z4OAxkx8nMnF+4z2f5UO/520l1CuYGJnL1NMBy4XGev3JdQTW8G7pustH+ikJTfx6y2ky0A7VZpnBoJ9MsGVDM5pnhuQFplmBgJplMrlhwIJChAFZNZr9GsfGsk2l+u417I1AC61uc4v/j60K3JXenrhGXmnA0rxWMQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=luzmRhYu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="luzmRhYu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B874EC2BCB0;
	Wed, 13 May 2026 00:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778630632;
	bh=VxYqUMpDL0lXRBHmaFrM/MWPoyM8aXmObW+B9KxAjxk=;
	h=From:To:Cc:Subject:Date:From;
	b=luzmRhYulLmM66ueqv5U8eLXoBFfps1Jn6HydvfeyFEeBregs6GFsgDFvyDWvFtLS
	 9FqIbz7wIIwfmVjffF2IbBE7pW0Oe8DE+KSzs5+th4aQaoH5nYi/QbHp9MeqQLXkiT
	 qxi/D7GbhDrQFLl09N0b167hh+KQX1FhfeSiXLsVyWPVwFVP9oQ2DtgNBe18ol9DNK
	 eFCbrIrdhSKKVXj2AoRnrIzgxSQFZWz22JQz75BMtg4t5CsVTTsTgriW0+dO1+5hpy
	 VaUrQ9qVpsJvOMlPGH2hpFQ4cm/9QzogjmFLfC6cRL26myyXzpna/+FsJVgqrkVD2t
	 hdJSZaNZm/eBA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] btrfs: fix delayed transaction aborts
Message-ID: <54bfa402-a284-4649-94d3-a25a88a6c475@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 13 May 2026 00:03:52 +0000 (UTC)

A transaction abort with error -28 (-ENOSPC) can trigger a WARN_ON in
cleanup_transaction(). The stack trace is somewhat misleading because
the transaction abort is delayed until the cleanup phase of
btrfs_commit_transaction(), hiding the actual function that ran out of
space.

When a highly crafted, extremely small BTRFS image is mounted and a
BTRFS_IOC_BALANCE_V2 ioctl is issued, the balance operation joins a
transaction and immediately commits it. During
btrfs_commit_transaction(), the filesystem needs to update various
trees. To update these trees, BTRFS must COW their root nodes, which
eventually calls btrfs_alloc_tree_block() to allocate a new physical
extent. Because the crafted image is tiny and has no free physical space
left, btrfs_reserve_extent() fails and returns -ENOSPC.

The -ENOSPC error propagates up the call stack to commit_cowonly_roots()
or commit_fs_roots(). Crucially, when these functions receive this
error, they simply return it to btrfs_commit_transaction() without
calling btrfs_abort_transaction() themselves. The error is caught in
btrfs_commit_transaction() and execution jumps to the cleanup labels.
Inside cleanup_transaction(), btrfs_abort_transaction() is finally
called. Because the failing functions neglected to abort the transaction
when the error actually occurred, this call inside cleanup_transaction()
is the first abort, completely hiding the true source of the -ENOSPC.

To fix this and ensure developers get accurate stack traces for
transaction aborts, explicitly call btrfs_abort_transaction() before
returning errors in functions that can fail with fatal errors during the
commit critical section (commit_cowonly_roots(), commit_fs_roots(),
btrfs_qgroup_account_extents(), and create_pending_snapshot()).

Also, add -ENOSPC to btrfs_abort_should_print_stack() to prevent
printing stack traces for legitimate out-of-space conditions.

Fixes: 49b25e0540904be0bf558b84475c69d72e4de66e ("btrfs: enhance transaction abort infrastructure")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+dafbca0e20fbc5946925@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=dafbca0e20fbc5946925
Link: https://syzkaller.appspot.com/ai_job?id=02e7fe36-adb2-44f9-a682-383b083c294b
To: <clm@fb.com>
To: <dsterba@suse.com>
To: <linux-btrfs@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Consolidated btrfs_abort_transaction() calls at the end of functions under cleanup/fail/out labels instead of calling them at each error site.
- Dropped unrelated workqueue and super.c changes addressing lockdep key exhaustion.

v1:
https://lore.kernel.org/all/f77b5e84-af17-41f8-9357-e8f4cd4b8438@mail.kernel.org/T/
---
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cdf736d3a..a645110df 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3076,6 +3076,8 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 							  record->num_bytes,
 							  record->old_roots,
 							  new_roots);
+			if (ret < 0)
+				goto cleanup;
 			record->old_roots = NULL;
 			new_roots = NULL;
 		}
@@ -3093,6 +3095,8 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 
 	}
 	trace_btrfs_qgroup_num_dirty_extents(fs_info, trans->transid, num_dirty_extents);
+	if (ret < 0)
+		btrfs_abort_transaction(trans, ret);
 	return ret;
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 248adb785..18e2d679a 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1372,21 +1372,23 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 	free_extent_buffer(eb);
 
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = btrfs_run_dev_stats(trans);
 	if (ret)
-		return ret;
+		goto out;
+
 	ret = btrfs_run_dev_replace(trans);
 	if (ret)
-		return ret;
+		goto out;
+
 	ret = btrfs_run_qgroups(trans);
 	if (ret)
-		return ret;
+		goto out;
 
 	ret = btrfs_setup_space_cache(trans);
 	if (ret)
-		return ret;
+		goto out;
 
 again:
 	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
@@ -1400,18 +1402,18 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 
 		ret = update_cowonly_root(trans, root);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	/* Now flush any delayed refs generated by updating all of the roots */
 	ret = btrfs_run_delayed_refs(trans, U64_MAX);
 	if (ret)
-		return ret;
+		goto out;
 
 	while (!list_empty(dirty_bgs) || !list_empty(io_bgs)) {
 		ret = btrfs_write_dirty_block_groups(trans);
 		if (ret)
-			return ret;
+			goto out;
 
 		/*
 		 * We're writing the dirty block groups, which could generate
@@ -1421,7 +1423,7 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 		 */
 		ret = btrfs_run_delayed_refs(trans, U64_MAX);
 		if (ret)
-			return ret;
+			goto out;
 	}
 
 	if (!list_empty(&fs_info->dirty_cowonly_roots))
@@ -1431,7 +1433,10 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 	fs_info->dev_replace.committed_cursor_left =
 		fs_info->dev_replace.cursor_left_last_write_of_item;
 
-	return 0;
+out:
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
+	return ret;
 }
 
 /*
@@ -1492,6 +1497,7 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 	struct btrfs_root *gang[8];
 	int i;
 	int ret;
+	int err = 0;
 
 	/*
 	 * At this point no one can be using this transaction to modify any tree
@@ -1510,7 +1516,6 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			break;
 		for (i = 0; i < ret; i++) {
 			struct btrfs_root *root = gang[i];
-			int ret2;
 
 			/*
 			 * At this point we can neither have tasks logging inodes
@@ -1533,9 +1538,9 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			spin_unlock(&fs_info->fs_roots_radix_lock);
 
 			btrfs_free_log(trans, root);
-			ret2 = btrfs_update_reloc_root(trans, root);
-			if (unlikely(ret2))
-				return ret2;
+			err = btrfs_update_reloc_root(trans, root);
+			if (unlikely(err))
+				goto out;
 
 			/* see comments in should_cow_block() */
 			clear_bit(BTRFS_ROOT_FORCE_COW, &root->state);
@@ -1548,16 +1553,19 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 						    root->node);
 			}
 
-			ret2 = btrfs_update_root(trans, fs_info->tree_root,
+			err = btrfs_update_root(trans, fs_info->tree_root,
 						&root->root_key,
 						&root->root_item);
-			if (unlikely(ret2))
-				return ret2;
+			if (unlikely(err))
+				goto out;
 			spin_lock(&fs_info->fs_roots_radix_lock);
 		}
 	}
 	spin_unlock(&fs_info->fs_roots_radix_lock);
-	return 0;
+out:
+	if (err)
+		btrfs_abort_transaction(trans, err);
+	return err;
 }
 
 /*
@@ -1745,10 +1753,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	 * insert the directory item
 	 */
 	ret = btrfs_set_inode_index(parent_inode, &index);
-	if (unlikely(ret)) {
-		btrfs_abort_transaction(trans, ret);
+	if (unlikely(ret))
 		goto fail;
-	}
 
 	/* check if there is a file/dir which has the same name. */
 	dir_item = btrfs_lookup_dir_item(NULL, parent_root, path,
@@ -1759,17 +1765,14 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		goto dir_item_existed;
 	} else if (IS_ERR(dir_item)) {
 		ret = PTR_ERR(dir_item);
-		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
 	btrfs_release_path(path);
 
 	ret = btrfs_create_qgroup(trans, objectid);
 	if (ret && ret != -EEXIST) {
-		if (unlikely(ret != -ENOTCONN || btrfs_qgroup_enabled(fs_info))) {
-			btrfs_abort_transaction(trans, ret);
+		if (unlikely(ret != -ENOTCONN || btrfs_qgroup_enabled(fs_info)))
 			goto fail;
-		}
 	}
 
 	/*
@@ -1779,16 +1782,12 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	 * snapshot
 	 */
 	ret = btrfs_run_delayed_items(trans);
-	if (unlikely(ret)) {
-		btrfs_abort_transaction(trans, ret);
+	if (unlikely(ret))
 		goto fail;
-	}
 
 	ret = record_root_in_trans(trans, root, false);
-	if (unlikely(ret)) {
-		btrfs_abort_transaction(trans, ret);
+	if (unlikely(ret))
 		goto fail;
-	}
 	btrfs_set_root_last_snapshot(&root->root_item, trans->transid);
 	memcpy(new_root_item, &root->root_item, sizeof(*new_root_item));
 	btrfs_check_and_init_root_item(new_root_item);
@@ -1821,10 +1820,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_copy_root(trans, root, root_eb, &tmp, objectid);
 	btrfs_tree_unlock(root_eb);
 	free_extent_buffer(root_eb);
-	if (unlikely(ret)) {
-		btrfs_abort_transaction(trans, ret);
+	if (unlikely(ret))
 		goto fail;
-	}
 	/* see comments in should_cow_block() */
 	set_bit(BTRFS_ROOT_FORCE_COW, &root->state);
 	smp_mb__after_atomic();
@@ -1837,10 +1834,8 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_insert_root(trans, tree_root, &key, new_root_item);
 	btrfs_tree_unlock(tmp);
 	free_extent_buffer(tmp);
-	if (unlikely(ret)) {
-		btrfs_abort_transaction(trans, ret);
+	if (unlikely(ret))
 		goto fail;
-	}
 
 	/*
 	 * insert root back/forward references
@@ -1849,25 +1844,20 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 				 btrfs_root_id(parent_root),
 				 btrfs_ino(parent_inode), index,
 				 &fname.disk_name);
-	if (unlikely(ret)) {
-		btrfs_abort_transaction(trans, ret);
+	if (unlikely(ret))
 		goto fail;
-	}
 
 	key.offset = (u64)-1;
 	pending->snap = btrfs_get_new_fs_root(fs_info, objectid, &pending->anon_dev);
 	if (IS_ERR(pending->snap)) {
 		ret = PTR_ERR(pending->snap);
 		pending->snap = NULL;
-		btrfs_abort_transaction(trans, ret);
 		goto fail;
 	}
 
 	ret = btrfs_reloc_post_snapshot(trans, pending);
-	if (unlikely(ret)) {
-		btrfs_abort_transaction(trans, ret);
+	if (unlikely(ret))
 		goto fail;
-	}
 
 	/*
 	 * Do special qgroup accounting for snapshot, as we do some qgroup
@@ -1887,27 +1877,21 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	ret = btrfs_insert_dir_item(trans, &fname.disk_name,
 				    parent_inode, &key, BTRFS_FT_DIR,
 				    index);
-	if (unlikely(ret)) {
-		btrfs_abort_transaction(trans, ret);
+	if (unlikely(ret))
 		goto fail;
-	}
 
 	btrfs_i_size_write(parent_inode, parent_inode->vfs_inode.i_size +
 						  fname.disk_name.len * 2);
 	inode_set_mtime_to_ts(&parent_inode->vfs_inode,
 			      inode_set_ctime_current(&parent_inode->vfs_inode));
 	ret = btrfs_update_inode_fallback(trans, parent_inode);
-	if (unlikely(ret)) {
-		btrfs_abort_transaction(trans, ret);
+	if (unlikely(ret))
 		goto fail;
-	}
 	ret = btrfs_uuid_tree_add(trans, new_root_item->uuid,
 				  BTRFS_UUID_KEY_SUBVOL,
 				  objectid);
-	if (unlikely(ret)) {
-		btrfs_abort_transaction(trans, ret);
+	if (unlikely(ret))
 		goto fail;
-	}
 	if (!btrfs_is_empty_uuid(new_root_item->received_uuid)) {
 		ret = btrfs_uuid_tree_add(trans, new_root_item->received_uuid,
 					  BTRFS_UUID_KEY_RECEIVED_SUBVOL,
@@ -1928,13 +1912,13 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 		 */
 		if (ret == -EOVERFLOW)
 			ret = 0;
-		if (unlikely(ret)) {
-			btrfs_abort_transaction(trans, ret);
+		if (unlikely(ret))
 			goto fail;
-		}
 	}
 
 fail:
+	if (ret)
+		btrfs_abort_transaction(trans, ret);
 	pending->error = ret;
 dir_item_existed:
 	trans->block_rsv = rsv;
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 7d70fe486..593f398a5 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -237,6 +237,7 @@ static inline bool btrfs_abort_should_print_stack(int error)
 	case -EIO:
 	case -EROFS:
 	case -ENOMEM:
+	case -ENOSPC:
 		return false;
 	}
 	return true;


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
