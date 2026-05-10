Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0050E2D949B
	for <syzbot@lists.linux.dev>; Sun, 10 May 2026 22:27:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778452059; cv=none; b=dJnXTIV7jMTq2bQ5usoji+2njPIex0oATbtNvWpvCih+2s3jag53BECTwRS1IIQzQ2dSKhlamN5p5yUHBMZI1AqCWoyRFq6h5yODRbg6/HOuiYDvTauaJv8QCirz9C9EqYiccOMiRKonXeko4hkh6V/rmJ2spxRdv1hX3e7z1fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778452059; c=relaxed/simple;
	bh=dB84M++NAg44SzGiaZKGI7hascrjGg/0HkifcQg/TS8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=t4hofuOf6DefrrZCGzld6GEYhoBG0068pCMsAvm4+yZC3nFJ5IIv1Zm9uAojqWDWWR8JPI2G9EK6XVMNhAio3q8G/B589vBou3VlQlGgz1MAWF2a6qc6ytun8A30NXRaEDyl8y7z5o1BYQhQR94sJh//CU/DrzMUvemheMrgB+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=h9BDNuPD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="h9BDNuPD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D2DBC2BCB8;
	Sun, 10 May 2026 22:27:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778452058;
	bh=dB84M++NAg44SzGiaZKGI7hascrjGg/0HkifcQg/TS8=;
	h=From:To:Cc:Subject:Date:From;
	b=h9BDNuPD4RZR/7uE2GjZNA5ShSJ+L68HeChjBujLAykHJm4CuASbAGLpEiFBy15p3
	 54KOG0eYStZ54Fx5Tqi/3AclnulxH1L6l69pXkTlmwym3GSBxPRSIuJSKSq0F4wnTe
	 YUlbDzIJB2K4Sc5duBOnfHazwnI00/iX91lumQeR4n4Ll486tcxsI7V//E5DknzVFO
	 w0g4qbwA7N6jL6mG5lcHEtEpNRxNC1+4WtK54FPwWcwKEbTsN4PaYiOjowrJts10xD
	 4RJown0aVmqirJo+wzwRNHr34OB7yoURynqL9y+dLu3bRk7jfrNNOr/NQ9UFbgyKxq
	 jaR3oR9jfG/Uw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] btrfs: fix delayed transaction aborts and lockdep key exhaustion
Message-ID: <f77b5e84-af17-41f8-9357-e8f4cd4b8438@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 10 May 2026 22:27:38 +0000 (UTC)

btrfs: fix delayed transaction aborts and lockdep key exhaustion

A transaction abort with error -28 (-ENOSPC) can trigger a WARN_ON in
cleanup_transaction(). The stack trace is somewhat misleading because
the
transaction abort is delayed until the cleanup phase of
btrfs_commit_transaction(), hiding the actual function that ran out of
space.

When a highly crafted, extremely small BTRFS image is mounted and a
BTRFS_IOC_BALANCE_V2 ioctl is issued, the balance operation joins a
transaction and immediately commits it. During
btrfs_commit_transaction(),
the filesystem needs to update various trees. To update these trees,
BTRFS
must COW their root nodes, which eventually calls
btrfs_alloc_tree_block()
to allocate a new physical extent. Because the crafted image is tiny and
has no free physical space left, btrfs_reserve_extent() fails and
returns
-ENOSPC.

The -ENOSPC error propagates up the call stack to commit_cowonly_roots()
or commit_fs_roots(). Crucially, when these functions receive this
error,
they simply return it to btrfs_commit_transaction() without calling
btrfs_abort_transaction() themselves. The error is caught in
btrfs_commit_transaction() and execution jumps to the cleanup labels.
Inside cleanup_transaction(), btrfs_abort_transaction() is finally
called.
Because the failing functions neglected to abort the transaction when
the
error actually occurred, this call inside cleanup_transaction() is the
first abort, completely hiding the true source of the -ENOSPC.

To fix this and ensure developers get accurate stack traces for
transaction
aborts, explicitly call btrfs_abort_transaction() before returning
errors
in functions that can fail with fatal errors during the commit critical
section (commit_cowonly_roots(), commit_fs_roots(),
btrfs_qgroup_account_extents(), and create_pending_snapshot()).

Also, add -ENOSPC to btrfs_abort_should_print_stack() to prevent
printing
stack traces for legitimate out-of-space conditions.

Additionally, this patch addresses a lockdep key exhaustion issue caused
by
rapid mount/unmount loops. The exhaustion is caused by the asynchronous
unregistration of lockdep keys in the workqueue subsystem. To fix this,
wq_unregister_lockdep() is moved from the asynchronous
pwq_release_workfn()
to be synchronous in destroy_workqueue(), before the rcu_read_lock()
block
where the base references to the pwqs are put. At this point, the
workqueue
is fully drained and detached, and we are not inside an RCU read-side
critical section, avoiding KASAN use-after-free and deadlocks.

Finally, an rcu_barrier() is added in btrfs_kill_super() to wait for all
RCU callbacks to finish. This is necessary because
lockdep_unregister_key()
queues an RCU callback to actually free the lock classes, and without
the
barrier, rapid mount/unmount loops could still exhaust MAX_LOCKDEP_KEYS
before the RCU callbacks have a chance to run.

Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
To: <clm@fb.com>
To: <dsterba@suse.com>
To: <linux-btrfs@vger.kernel.org>
To: <tj@kernel.org>
Cc: <jiangshanlai@gmail.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cdf736d3a..fd322e87f 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3050,8 +3050,10 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 			if (!record->old_roots) {
 				/* Search commit root to find old_roots */
 				ret = btrfs_find_all_roots(&ctx, false);
-				if (ret < 0)
+				if (ret < 0) {
+					btrfs_abort_transaction(trans, ret);
 					goto cleanup;
+				}
 				record->old_roots = ctx.roots;
 				ctx.roots = NULL;
 			}
@@ -3064,8 +3066,10 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 			ctx.trans = trans;
 			ctx.time_seq = BTRFS_SEQ_LAST;
 			ret = btrfs_find_all_roots(&ctx, false);
-			if (ret < 0)
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, ret);
 				goto cleanup;
+			}
 			new_roots = ctx.roots;
 			if (qgroup_to_skip) {
 				ulist_del(new_roots, qgroup_to_skip, 0);
@@ -3076,6 +3080,10 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
 							  record->num_bytes,
 							  record->old_roots,
 							  new_roots);
+			if (ret < 0) {
+				btrfs_abort_transaction(trans, ret);
+				goto cleanup;
+			}
 			record->old_roots = NULL;
 			new_roots = NULL;
 		}
diff --git a/fs/btrfs/super.c b/fs/btrfs/super.c
index b26aa9169..25c31eba4 100644
--- a/fs/btrfs/super.c
+++ b/fs/btrfs/super.c
@@ -2125,6 +2125,11 @@ static void btrfs_kill_super(struct super_block *sb)
 {
 	struct btrfs_fs_info *fs_info = btrfs_sb(sb);
 	kill_anon_super(sb);
+	/*
+	 * Wait for all RCU callbacks to finish. This prevents lockdep key
+	 * exhaustion when syzkaller mounts and unmounts rapidly.
+	 */
+	rcu_barrier();
 	btrfs_free_fs_info(fs_info);
 }
 
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 248adb785..c4c3ae9ac 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -1371,22 +1371,32 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 	btrfs_tree_unlock(eb);
 	free_extent_buffer(eb);
 
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		return ret;
+	}
 
 	ret = btrfs_run_dev_stats(trans);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		return ret;
+	}
 	ret = btrfs_run_dev_replace(trans);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		return ret;
+	}
 	ret = btrfs_run_qgroups(trans);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		return ret;
+	}
 
 	ret = btrfs_setup_space_cache(trans);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		return ret;
+	}
 
 again:
 	while (!list_empty(&fs_info->dirty_cowonly_roots)) {
@@ -1399,19 +1409,25 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 			       &trans->transaction->switch_commits);
 
 		ret = update_cowonly_root(trans, root);
-		if (ret)
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
 			return ret;
+		}
 	}
 
 	/* Now flush any delayed refs generated by updating all of the roots */
 	ret = btrfs_run_delayed_refs(trans, U64_MAX);
-	if (ret)
+	if (ret) {
+		btrfs_abort_transaction(trans, ret);
 		return ret;
+	}
 
 	while (!list_empty(dirty_bgs) || !list_empty(io_bgs)) {
 		ret = btrfs_write_dirty_block_groups(trans);
-		if (ret)
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
 			return ret;
+		}
 
 		/*
 		 * We're writing the dirty block groups, which could generate
@@ -1420,8 +1436,10 @@ static noinline int commit_cowonly_roots(struct btrfs_trans_handle *trans)
 		 * everything gets run.
 		 */
 		ret = btrfs_run_delayed_refs(trans, U64_MAX);
-		if (ret)
+		if (ret) {
+			btrfs_abort_transaction(trans, ret);
 			return ret;
+		}
 	}
 
 	if (!list_empty(&fs_info->dirty_cowonly_roots))
@@ -1534,8 +1552,10 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 
 			btrfs_free_log(trans, root);
 			ret2 = btrfs_update_reloc_root(trans, root);
-			if (unlikely(ret2))
+			if (unlikely(ret2)) {
+				btrfs_abort_transaction(trans, ret2);
 				return ret2;
+			}
 
 			/* see comments in should_cow_block() */
 			clear_bit(BTRFS_ROOT_FORCE_COW, &root->state);
@@ -1551,8 +1571,10 @@ static noinline int commit_fs_roots(struct btrfs_trans_handle *trans)
 			ret2 = btrfs_update_root(trans, fs_info->tree_root,
 						&root->root_key,
 						&root->root_item);
-			if (unlikely(ret2))
+			if (unlikely(ret2)) {
+				btrfs_abort_transaction(trans, ret2);
 				return ret2;
+			}
 			spin_lock(&fs_info->fs_roots_radix_lock);
 		}
 	}
@@ -1737,8 +1759,10 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 				      trans->bytes_reserved, 1);
 	parent_root = parent_inode->root;
 	ret = record_root_in_trans(trans, parent_root, false);
-	if (unlikely(ret))
+	if (unlikely(ret)) {
+		btrfs_abort_transaction(trans, ret);
 		goto fail;
+	}
 	cur_time = current_time(&parent_inode->vfs_inode);
 
 	/*
@@ -1881,8 +1905,10 @@ static noinline int create_pending_snapshot(struct btrfs_trans_handle *trans,
 	else if (btrfs_qgroup_mode(fs_info) == BTRFS_QGROUP_MODE_SIMPLE)
 		ret = btrfs_qgroup_inherit(trans, btrfs_root_id(root), objectid,
 					   btrfs_root_id(parent_root), pending->inherit);
-	if (unlikely(ret < 0))
+	if (unlikely(ret < 0)) {
+		btrfs_abort_transaction(trans, ret);
 		goto fail;
+	}
 
 	ret = btrfs_insert_dir_item(trans, &fname.disk_name,
 				    parent_inode, &key, BTRFS_FT_DIR,
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
diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 5f747f241..5989f1c18 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -5222,7 +5222,6 @@ static void pwq_release_workfn(struct kthread_work *work)
 	 * is gonna access it anymore.  Schedule RCU free.
 	 */
 	if (is_last) {
-		wq_unregister_lockdep(wq);
 		call_rcu(&wq->rcu, rcu_free_wq);
 	}
 }
@@ -6064,6 +6063,8 @@ void destroy_workqueue(struct workqueue_struct *wq)
 	list_del_rcu(&wq->list);
 	mutex_unlock(&wq_pool_mutex);
 
+	wq_unregister_lockdep(wq);
+
 	/*
 	 * We're the sole accessor of @wq. Directly access cpu_pwq and dfl_pwq
 	 * to put the base refs. @wq will be auto-destroyed from the last


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
