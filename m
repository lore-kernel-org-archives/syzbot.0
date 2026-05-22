Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF393939B2
	for <syzbot@lists.linux.dev>; Fri, 22 May 2026 07:30:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779435033; cv=none; b=QilQvNyuPKUuLCxuwdSfMoCdmlPehVV1VFqBPjjpZ0UlZFyg1OObuZWTWpc89jBNllRmCq4ZkuYLOa11cDf258pFaanjn+muIMRPz47qXCmVSCG40j1SUgO9Q6ygLA2zpYx50QfmsCd7SVt/BgzW7Ez7oidZCZqjER+ikhdj0aA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779435033; c=relaxed/simple;
	bh=Zw2LfystQ0ARHIm9mc4QE/GPC21oOXVyrcxKhapeVsY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=t1u6RwgJyWKartE4tPewjbRmmUNAL1NAdrhncDWFOx1z42XaFjVudxm85YOD5XEaCkyGZxqJTcj5/0LaQp86E6ug6Gk61dvHVrdogmZqYilhFZhAMnfRODbZxHhs3QNCgdR5rO3xcCIJZtBXIk+yvhT9YrCgxSi4Og5p3Om8hec=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EuLqAM5B; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EuLqAM5B"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E946D1F000E9;
	Fri, 22 May 2026 07:30:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779435030;
	bh=D5YX9CQiy3TH9orNjP1tiwd4S9MxGjqkN9Ge8OkmFOY=;
	h=From:To:Cc:Subject:Date;
	b=EuLqAM5BhbIH4U2+S3lZOIn+wkqjpvMc5SkACtqM3H80Wcc+P38rMstDs79b9DRIM
	 ADPMX0hK9iRgddaIqPMgrGpNSTXyiRsAu1Yfm5SgaVoA0hqWzEgvTNH86otmRkXKLv
	 iY+6M81hH9K0Q2OHpdjiMgcT09lBRTT1TfIW/Fk/tgpjf0tr/wuGhbvRp3guLMCT26
	 +s/sKyVGwKQBgtNGen1lzy7pc7axt+F8fsv/xBAo7NtvJ9qumLoqtEw0ntKaWCP3ZX
	 g0nfuLd87x9xEixuJwEbEea37ZEwnA/CghQKPR6o70g4V2CHtfZoT4XdvlHcw5709Y
	 0x43HqYreKAxw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] btrfs: fix double free of data space reservation on direct IO error
Message-ID: <07963d2a-cd0f-4940-a5bc-33dd8f425781@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 22 May 2026 07:30:29 +0000 (UTC)

When a Direct I/O write begins, btrfs_dio_iomap_begin() reserves
data_alloc_len bytes of data space by calling
btrfs_check_data_free_space(). This increments the bytes_may_use counter
in the appropriate data space_info. Later,
btrfs_get_blocks_direct_write() calls btrfs_new_extent_direct() to
allocate an extent. Inside btrfs_new_extent_direct(),
btrfs_reserve_extent() is called, which successfully allocates an extent
of size ins.offset on disk and converts ins.offset bytes from
bytes_may_use to bytes_reserved (via btrfs_add_reserved_bytes()). Next,
btrfs_new_extent_direct() calls btrfs_create_dio_extent(). If this fails
(e.g., due to memory allocation failure), btrfs_new_extent_direct()
calls btrfs_free_reserved_extent() to free the allocated extent.
btrfs_free_reserved_extent() decrements bytes_reserved by ins.offset,
effectively freeing the space. However, it does not restore the
ins.offset bytes back to bytes_may_use.

The error propagates back to btrfs_dio_iomap_begin(), which jumps to the
error handling path. Because dio_data->data_space_reserved is still
true, it calls btrfs_free_reserved_data_space() for the entire
data_alloc_len. This function blindly decrements bytes_may_use by
data_alloc_len. Since ins.offset bytes were already converted to
bytes_reserved and freed, decrementing bytes_may_use by the full
data_alloc_len causes bytes_may_use to be decremented by ins.offset
twice. This underflows the counter, triggering a warning in
btrfs_space_info_update_bytes_may_use().

To fix this, btrfs_new_extent_direct() must restore the ins.offset bytes
back to bytes_may_use when btrfs_create_dio_extent() fails. This ensures
that when the error propagates up, btrfs_dio_iomap_begin() can safely
free the entire data_alloc_len from bytes_may_use. Introduce a new
helper function, btrfs_add_reserved_data_space_noquota(), which
correctly uses data_sinfo_for_inode() to select the right space_info
(handling zoned data relocation roots) and directly updates
bytes_may_use without triggering unnecessary ticket granting. Call this
new helper in the error path of btrfs_new_extent_direct().

Fixes: 18513091af94 ("btrfs: update btrfs_space_info's bytes_may_use timely")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
Reported-by: syzbot+9064acebb06685edb243@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9064acebb06685edb243
Link: https://syzkaller.appspot.com/ai_job?id=913538c5-7b36-4127-ab45-6efa99a3628e
To: "Chris Mason" <clm@fb.com>
To: "David Sterba" <dsterba@suse.com>
To: <linux-btrfs@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
index 0970799d0..7cfb829a3 100644
--- a/fs/btrfs/delalloc-space.c
+++ b/fs/btrfs/delalloc-space.c
@@ -189,6 +189,24 @@ void btrfs_free_reserved_data_space_noquota(struct btrfs_inode *inode, u64 len)
 	btrfs_space_info_free_bytes_may_use(data_sinfo_for_inode(inode), len);
 }
 
+/*
+ * Restore a data reservation for this inode.
+ * Normally called when a reservation was converted to bytes_reserved but the
+ * subsequent operation failed, so the bytes need to be restored to bytes_may_use
+ * so the caller can free them.
+ */
+void btrfs_add_reserved_data_space_noquota(struct btrfs_inode *inode, u64 len)
+{
+	struct btrfs_fs_info *fs_info = inode->root->fs_info;
+	struct btrfs_space_info *sinfo = data_sinfo_for_inode(inode);
+
+	ASSERT(IS_ALIGNED(len, fs_info->sectorsize));
+
+	spin_lock(&sinfo->lock);
+	btrfs_space_info_update_bytes_may_use(sinfo, len);
+	spin_unlock(&sinfo->lock);
+}
+
 /*
  * Called if we need to clear a data reservation for this inode
  * Normally in a error case.
diff --git a/fs/btrfs/delalloc-space.h b/fs/btrfs/delalloc-space.h
index 6119c0d3f..58ecfad7b 100644
--- a/fs/btrfs/delalloc-space.h
+++ b/fs/btrfs/delalloc-space.h
@@ -19,6 +19,7 @@ void btrfs_delalloc_release_space(struct btrfs_inode *inode,
 				  struct extent_changeset *reserved,
 				  u64 start, u64 len, bool qgroup_free);
 void btrfs_free_reserved_data_space_noquota(struct btrfs_inode *inode, u64 len);
+void btrfs_add_reserved_data_space_noquota(struct btrfs_inode *inode, u64 len);
 void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_bytes,
 				     bool qgroup_free);
 int btrfs_delalloc_reserve_space(struct btrfs_inode *inode,
diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
index 57167d56d..04cdf11d8 100644
--- a/fs/btrfs/direct-io.c
+++ b/fs/btrfs/direct-io.c
@@ -205,8 +205,14 @@ static struct extent_map *btrfs_new_extent_direct(struct btrfs_inode *inode,
 	em = btrfs_create_dio_extent(inode, dio_data, start, &file_extent,
 				     BTRFS_ORDERED_REGULAR);
 	btrfs_dec_block_group_reservations(fs_info, ins.objectid);
-	if (IS_ERR(em))
+	if (IS_ERR(em)) {
 		btrfs_free_reserved_extent(fs_info, ins.objectid, ins.offset, true);
+		/*
+		 * btrfs_reserve_extent() converted the bytes from bytes_may_use to
+		 * bytes_reserved. We need to restore them so the caller can free them.
+		 */
+		btrfs_add_reserved_data_space_noquota(inode, ins.offset);
+	}
 
 	return em;
 }


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
