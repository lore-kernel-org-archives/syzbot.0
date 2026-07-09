Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6151D449998
	for <syzbot@lists.linux.dev>; Thu,  9 Jul 2026 19:08:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783624137; cv=none; b=W3YSWyVK85twPNjFZ++lLiEYgy9huX+fLE89MNcK6EVnvlNVLS2/ytawabQJI0xU/U79EfiiljWxFbK3DZZs1LVqQkeVrZHy6kq0lV3GEc3tH6qyQVNOz8ohULAGNvPIDttsuXQnKD/Bn7AjOrQD4PBiUUynK60WPkXuOtZ0SVQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783624137; c=relaxed/simple;
	bh=uQTMJHK8bWuXkbcOugidfPCOr8BiEyN6hNDkcTI+Uqc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Tpv53PkMde4fFjY4T+81akIITG5Y7LMj4a5rNWrlUm8WyZg2rtMXkB9fto89q1ivPfzvgUR4Qr/mwzvt2ZtWL72HcUhMpSVOl/ccEfOprZujRA0S2Wg0wZeqyhTqxa9lgCgOgKh9xuRFIvW90qyBi6O+zI7dedzgAKHzlnVMjyY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=YgPHAe0+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="YgPHAe0+"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E6FBA1F000E9;
	Thu,  9 Jul 2026 19:08:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783624136;
	bh=diC6gLygA5xS43bNkTtDwX5lcxyjrrh1y7WU4HRClxU=;
	h=From:To:Cc:Subject:Date;
	b=YgPHAe0+COLFHQI2uBktnYr8tAeNo27arysDowjlYQdgc1kbClrtEa07tisyTTbfx
	 Vt7W4TS1o3of9FvkXSpRstMsNtzfUjyGuzkODB4Uc7lwTjdGmfQw/jCtqYFSTwZd1L
	 rUpjCpLe1U3dALMQMY5rL1MJOEqyYOskkXYc2iy6BXn9hIrmjT0ZCy28Mhe492nOKX
	 y4i89l7RkAklOsS8gfT4auQQ1Crk/UsPd9kRkZ1V4r290vyw/al4XnFQd6JUpgXtkG
	 jemf/FIUlg+9WWS25ffXuOpzhkX2tQacZPTIFJsMRpegOx4bJFQbyxuuUE5OfPQ6+0
	 PpmF7D+R71tgQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] btrfs: abort transaction directly on errors in commit path
Message-ID: <1586eaf3-2208-42eb-8877-7c4f83a6638c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu,  9 Jul 2026 19:08:55 +0000 (UTC)

When a transaction commit fails due to filesystem corruption (-EUCLEAN),
some functions like btrfs_qgroup_account_extents() and btrfs_update_root()
return the error without explicitly calling btrfs_abort_transaction(). This
forces the generic cleanup_transaction() fallback to abort the transaction,
which masks the actual location of the failure in the stack trace.

This results in confusing warnings that do not point to the actual failure:

BTRFS warning (device loop0): Skipping commit of aborted transaction.
[ cut here ]
btrfs_abort_should_print_stack(__error)
WARNING: fs/btrfs/transaction.c:2068 at cleanup_transaction+0x727/0x7c0
...
Call Trace:
 <TASK>
 btrfs_commit_transaction+0x262c/0x30b0
 prepare_to_relocate+0x3dd/0x4e0
 relocate_block_group+0x141/0xe90
 do_nonremap_reloc+0xa7/0x560
 btrfs_relocate_block_group+0x6e2/0xaf0
 btrfs_relocate_chunk+0x114/0x830
 __btrfs_balance+0x1b6e/0x29e0
 btrfs_balance+0xaa6/0x1180
 btrfs_ioctl_balance+0x3dd/0x640

Fix this by calling btrfs_abort_transaction() directly in these functions
when they encounter an error. For btrfs_update_root(), -ENOSPC is a normal
error when updating the log root tree (e.g., during btrfs_sync_log()), so
we only abort if it is not the log root tree or the error is not -ENOSPC.

Additionally, btrfs_abort_transaction() triggers a WARN_ON for -EUCLEAN and
-ENOSPC because they are not in the ignore list of
btrfs_abort_should_print_stack(). WARN_ON must not be used for conditions
that can legitimately happen, such as encountering a corrupted filesystem
image (-EUCLEAN) or running out of space (-ENOSPC). To prevent unnecessary
warnings, add -EUCLEAN and -ENOSPC to the ignore list. To ensure we still
get meaningful stack traces for debugging, add manual dump_stack() calls in
__btrfs_abort_transaction() for these specific errors.

Fixes: 72bd2323ec87 ("Btrfs: do not abort transaction at btrfs_update_root() after failure to COW path")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+021d10c4d4edc87daa03@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=021d10c4d4edc87daa03
Link: https://syzkaller.appspot.com/ai_job?id=36e1fafd-13a6-44c6-a988-98fb6981cb2b
To: "Chris Mason" <clm@fb.com>
To: "David Sterba" <dsterba@suse.com>
To: <linux-btrfs@vger.kernel.org>
To: "Filipe Manana" <fdmanana@suse.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/btrfs/qgroup.c b/fs/btrfs/qgroup.c
index 502fb4a55..1870595f1 100644
--- a/fs/btrfs/qgroup.c
+++ b/fs/btrfs/qgroup.c
@@ -3068,8 +3068,10 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
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
@@ -3082,8 +3084,10 @@ int btrfs_qgroup_account_extents(struct btrfs_trans_handle *trans)
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
diff --git a/fs/btrfs/root-tree.c b/fs/btrfs/root-tree.c
index 90659b287..13695e4f4 100644
--- a/fs/btrfs/root-tree.c
+++ b/fs/btrfs/root-tree.c
@@ -142,8 +142,17 @@ int btrfs_update_root(struct btrfs_trans_handle *trans, struct btrfs_root
 		return -ENOMEM;
 
 	ret = btrfs_search_slot(trans, root, key, path, 0, 1);
-	if (ret < 0)
+	if (ret < 0) {
+		/*
+		 * Abort the transaction if we are not updating the log root tree.
+		 * In btrfs_sync_log, -ENOSPC is a normal error and should not
+		 * abort the transaction.
+		 */
+		if (ret != -ENOSPC ||
+		    root->root_key.objectid != BTRFS_TREE_LOG_OBJECTID)
+			btrfs_abort_transaction(trans, ret);
 		return ret;
+	}
 
 	if (unlikely(ret > 0)) {
 		btrfs_crit(fs_info,
diff --git a/fs/btrfs/transaction.c b/fs/btrfs/transaction.c
index 8f9419728..aa53eb831 100644
--- a/fs/btrfs/transaction.c
+++ b/fs/btrfs/transaction.c
@@ -2751,8 +2751,16 @@ void __cold __btrfs_abort_transaction(struct btrfs_trans_handle *trans,
 	if (first_hit) {
 		btrfs_err(fs_info, "Transaction %llu aborted (error %d)",
 			  trans->transid, error);
-		if (error == -ENOSPC)
+		if (error == -ENOSPC) {
 			btrfs_dump_space_info_for_trans_abort(fs_info);
+			dump_stack();
+		}
+		if (error == -EUCLEAN) {
+			btrfs_err(
+				fs_info,
+				"Aborting transaction due to filesystem corruption");
+			dump_stack();
+		}
 	}
 	/* Wake up anybody who may be waiting on this transaction */
 	wake_up(&fs_info->transaction_wait);
diff --git a/fs/btrfs/transaction.h b/fs/btrfs/transaction.h
index 5e4b1106f..ec66a60cc 100644
--- a/fs/btrfs/transaction.h
+++ b/fs/btrfs/transaction.h
@@ -237,6 +237,8 @@ static inline bool btrfs_abort_should_print_stack(int error)
 	case -EIO:
 	case -EROFS:
 	case -ENOMEM:
+	case -EUCLEAN:
+	case -ENOSPC:
 		return false;
 	}
 	return true;


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
