Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 475733A5E90
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 23:42:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778974952; cv=none; b=Xor8J3kyCYgN8bVJnPbDHZ2FqW6ZGgv0j7dlu7ksDfJeAKku/RpcPyhr4+v88EsZjhctBLwAW2Eo8BSBhLCEm0lM8f9hHee95gPYqaZAh9PVPT3vwxgj5xBBSYL1bHp8hzSCsoqHUyQCtgYx6qUUR4KIRyhuNy1XUwli63npNzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778974952; c=relaxed/simple;
	bh=O78m51oh3x6zAllaPJJi+lMaFMD1rzWhjQ3jMs+s3H0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=iBauLsHjbWWkdTOXneI2OgwJYph81UCifL+/kj8qEwRxyMD5SjE1zK5auYrbHZfH0g6CcDGB0yxOt6i0eZ9HCytWjQQjCNt34RyiRvvgZ9d8Co27KlKamh8zlg86LY4GI8gJ01+PVP7rmT73twY7NJe00bVHqLSens1G59Q5TuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XFNdtM7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XFNdtM7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1CF4C19425;
	Sat, 16 May 2026 23:42:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778974951;
	bh=O78m51oh3x6zAllaPJJi+lMaFMD1rzWhjQ3jMs+s3H0=;
	h=From:To:Cc:Subject:Date:From;
	b=XFNdtM7Z81AfpzISctqlqpazZjM+eiAGwaUlFKU4Ci1v0NaXTzHpdduSPc1OPh0px
	 4J2ts8V/s0y6ZALW3gGblgC590fR3VezxmZXrwv4X8t2QDwV+f8bm32nfZOkAdm1q1
	 tGZfFAiXd0r7TgCodf5TSHwkq/0ZZygBVKtM2ZBns0FSPsPg+rrnpnhEHn65HrF25n
	 7bfmyuHpWtBHikUgfFUVoRCT9bRrQjXBMzBCGUJSru4ne63x9JJM1b+BzqeZ2NOKLq
	 HJxS296ziRkCV1krbFH8Zmf7XnJndfaicUxBcnviP805/RWUARjO1ii0nY+YtiI/E8
	 Q926zTn0Yzy4Q==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v3] btrfs: fix delayed transaction aborts
Message-ID: <d56161b7-1f00-4e88-94fe-9e6d4db29ae0@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 16 May 2026 23:42:31 +0000 (UTC)

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
commit critical section (commit_cowonly_roots(), commit_fs_roots(), and
btrfs_qgroup_account_extents()).

Also, replace the WARN() macro in btrfs_abort_transaction() with
dump_stack() to prevent transaction aborts from triggering kernel
warnings, while still printing the stack trace.

Additionally, use lockdep maps for workqueue allocations to address
lockdep key exhaustion.

Fixes: 49b25e0540904be0bf558b84475c69d72e4de66e ("btrfs: enhance transaction abort infrastructure")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+dafbca0e20fbc5946925@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=dafbca0e20fbc5946925
Link: https://syzkaller.appspot.com/ai_job?id=96c50581-2f5c-4140-ad4e-bf2cccae111e
To: <clm@fb.com>
To: <dsterba@suse.com>
To: <linux-btrfs@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Dropped btrfs_abort_transaction() calls in create_pending_snapshot() to reduce patch size.
- Replaced WARN() with dump_stack() in btrfs_abort_transaction() instead of adding -ENOSPC to btrfs_abort_should_print_stack().
- Restored workqueue changes addressing lockdep key exhaustion.
- Moved btrfs_abort_transaction() call in btrfs_qgroup_account_extents() back to the error site.

v2:
- Consolidated btrfs_abort_transaction() calls at the end of functions under cleanup/fail/out labels instead of calling them at each error site.
- Dropped unrelated workqueue and super.c changes addressing lockdep key exhaustion.
https://lore.kernel.org/all/54bfa402-a284-4649-94d3-a25a88a6c475@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/f77b5e84-af17-41f8-9357-e8f4cd4b8438@mail.kernel.org/T/
---
diff --git a/fs/btrfs/async-thread.c b/fs/btrfs/async-thread.c
index e6f33d094..634b7b578 100644
--- a/fs/btrfs/async-thread.c
+++ b/fs/btrfs/async-thread.c
@@ -81,9 +81,10 @@ static void btrfs_init_workqueue(struct btrfs_workqueue *wq,
 	spin_lock_init(&wq->thres_lock);
 }
 
-struct btrfs_workqueue *btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info,
-					      const char *name, unsigned int flags,
-					      int limit_active, int thresh)
+struct btrfs_workqueue *
+__btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info, const char *name,
+			unsigned int flags, int limit_active, int thresh,
+			struct lock_class_key *key, struct lockdep_map *map)
 {
 	struct btrfs_workqueue *ret = kzalloc_obj(*ret);
 
@@ -109,8 +110,14 @@ struct btrfs_workqueue *btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info,
 		ret->thresh = thresh;
 	}
 
+#ifdef CONFIG_LOCKDEP
+	lockdep_init_map(map, name, key, 0);
+	ret->normal_wq = alloc_workqueue_lockdep_map(
+		"btrfs-%s", flags, ret->current_active, map, name);
+#else
 	ret->normal_wq = alloc_workqueue("btrfs-%s", flags, ret->current_active,
 					 name);
+#endif
 	if (!ret->normal_wq) {
 		kfree(ret);
 		return NULL;
@@ -120,9 +127,10 @@ struct btrfs_workqueue *btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info,
 	return ret;
 }
 
-struct btrfs_workqueue *btrfs_alloc_ordered_workqueue(
-				struct btrfs_fs_info *fs_info, const char *name,
-				unsigned int flags)
+struct btrfs_workqueue *
+__btrfs_alloc_ordered_workqueue(struct btrfs_fs_info *fs_info, const char *name,
+				unsigned int flags, struct lock_class_key *key,
+				struct lockdep_map *map)
 {
 	struct btrfs_workqueue *ret;
 
@@ -137,7 +145,13 @@ struct btrfs_workqueue *btrfs_alloc_ordered_workqueue(
 	ret->current_active = 1;
 	ret->thresh = NO_THRESHOLD;
 
+#ifdef CONFIG_LOCKDEP
+	lockdep_init_map(map, name, key, 0);
+	ret->normal_wq = alloc_ordered_workqueue_lockdep_map("btrfs-%s", flags,
+							     map, name);
+#else
 	ret->normal_wq = alloc_ordered_workqueue("btrfs-%s", flags, name);
+#endif
 	if (!ret->normal_wq) {
 		kfree(ret);
 		return NULL;
diff --git a/fs/btrfs/async-thread.h b/fs/btrfs/async-thread.h
index 04c2f3175..f43f5feb9 100644
--- a/fs/btrfs/async-thread.h
+++ b/fs/btrfs/async-thread.h
@@ -29,14 +29,40 @@ struct btrfs_work {
 	unsigned long flags;
 };
 
-struct btrfs_workqueue *btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info,
-					      const char *name,
-					      unsigned int flags,
-					      int limit_active,
-					      int thresh);
-struct btrfs_workqueue *btrfs_alloc_ordered_workqueue(
-				struct btrfs_fs_info *fs_info, const char *name,
-				unsigned int flags);
+struct btrfs_workqueue *
+__btrfs_alloc_workqueue(struct btrfs_fs_info *fs_info, const char *name,
+			unsigned int flags, int limit_active, int thresh,
+			struct lock_class_key *key, struct lockdep_map *map);
+#ifdef CONFIG_LOCKDEP
+#define btrfs_alloc_workqueue(fs_info, name, flags, limit_active, thresh)   \
+	({                                                                  \
+		static struct lock_class_key __key;                         \
+		static struct lockdep_map __map;                            \
+		__btrfs_alloc_workqueue(fs_info, name, flags, limit_active, \
+					thresh, &__key, &__map);            \
+	})
+#else
+#define btrfs_alloc_workqueue(fs_info, name, flags, limit_active, thresh)   \
+	__btrfs_alloc_workqueue(fs_info, name, flags, limit_active, thresh, \
+				NULL, NULL)
+#endif
+
+struct btrfs_workqueue *
+__btrfs_alloc_ordered_workqueue(struct btrfs_fs_info *fs_info, const char *name,
+				unsigned int flags, struct lock_class_key *key,
+				struct lockdep_map *map);
+#ifdef CONFIG_LOCKDEP
+#define btrfs_alloc_ordered_workqueue(fs_info, name, flags)                   \
+	({                                                                    \
+		static struct lock_class_key __key;                           \
+		static struct lockdep_map __map;                              \
+		__btrfs_alloc_ordered_workqueue(fs_info, name, flags, &__key, \
+						&__map);                      \
+	})
+#else
+#define btrfs_alloc_ordered_workqueue(fs_info, name, flags) \
+	__btrfs_alloc_ordered_workqueue(fs_info, name, flags, NULL, NULL)
+#endif
 void btrfs_init_work(struct btrfs_work *work, btrfs_func_t func,
 		     btrfs_ordered_func_t ordered_func);
 void btrfs_queue_work(struct btrfs_workqueue *wq,
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index cdf736d3a..f9acfab14 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3076,6 +3076,10 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
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
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 248adb785..aa0ce0c59 100644
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
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 7d70fe486..f816e62f3 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -246,27 +246,21 @@ static inline bool btrfs_abort_should_print_stack(int error)
  * Call btrfs_abort_transaction as early as possible when an error condition is
  * detected, that way the exact stack trace is reported for some errors.
  */
-#define btrfs_abort_transaction(trans, error)		\
-do {								\
-	bool __first = false;					\
-	/* Report first abort since mount */			\
-	if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,	\
-			&((trans)->fs_info->fs_state))) {	\
-		__first = true;					\
-		if (WARN(btrfs_abort_should_print_stack(error),	\
-			KERN_ERR				\
-			"BTRFS: Transaction aborted (error %d)\n",	\
-			(error))) {					\
-			/* Stack trace printed. */			\
-		} else {						\
-			btrfs_err((trans)->fs_info,			\
-				  "Transaction aborted (error %d)",	\
-				  (error));			\
-		}						\
-	}							\
-	__btrfs_abort_transaction((trans), __func__,		\
-				  __LINE__, (error), __first);	\
-} while (0)
+#define btrfs_abort_transaction(trans, error)                                 \
+	do {                                                                  \
+		bool __first = false;                                         \
+		/* Report first abort since mount */                          \
+		if (!test_and_set_bit(BTRFS_FS_STATE_TRANS_ABORTED,           \
+				      &((trans)->fs_info->fs_state))) {       \
+			__first = true;                                       \
+			btrfs_err((trans)->fs_info,                           \
+				  "Transaction aborted (error %d)", (error)); \
+			if (btrfs_abort_should_print_stack(error))            \
+				dump_stack();                                 \
+		}                                                             \
+		__btrfs_abort_transaction((trans), __func__, __LINE__,        \
+					  (error), __first);                  \
+	} while (0)
 
 int btrfs_end_transaction(struct btrfs_trans_handle *trans);
 struct btrfs_trans_handle *btrfs_start_transaction(struct btrfs_root *root,


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
