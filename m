Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9990536728D
	for <syzbot@lists.linux.dev>; Fri, 22 May 2026 18:53:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779476013; cv=none; b=RtCbmQK7QIvFN5YUpaBfTG5ASam/+QQrE6/PV5D9JU+tZG8QeqPC4L+qIMlClDAMmZn80HmBjqfgSpStbvnY2uWIKGUONP0FPrCbqi3Kgw0yiJjI0GRYi5ezApIb/LC4xUatHbsRGpQ4GX53o/Ndf/syd9yY+IN6O33MdSXNe2Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779476013; c=relaxed/simple;
	bh=LempnC5ZFpZNSCocMBaBBMaWQ/Q+Zmb2bLrMU5BwLGQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=mJ62Ps36EKEABzRgUJoPXdnppKWv92XilWlQqjiutXERvyTs4liz6zqnhmBdmZg4ZQ+YqyZKdSpFFzTg4lVctstN4NXQq/YYBgs1f6awODRu9g1V2FVPv+3eoWkzlJCyUu0bEAArkwF7misgFawTD1E1EuTC4+YpZR2AucRFRl0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mT21ir4n; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mT21ir4n"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 3EA5F1F000E9;
	Fri, 22 May 2026 18:53:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779476012;
	bh=E+VL3dh8KKNSggNCQgvdOUAtLiC+RzSzTenLoGO4atI=;
	h=From:To:Cc:Subject:Date;
	b=mT21ir4nezH7gvtmro4Mi9iObyksr4LJUsSLP9YtGzHdR4sjfIKNO/FzdgXYdVGSg
	 JxvNr7NQ7moP9KNw76yco3Aki+tVI9wD2uimp5+k3v9swudRP+DYwXL1d3m4e4D/wx
	 1HQaFdVu/2+X+6yH8PTUt6enwWV+0Nt5y2GKCM4tdzDrkWv6JYKDPWIHI+QvHiJcZO
	 F/tQDig4MmSt+17gNYt2JdleayxArWYmXjBy2vpH2D4ekh7Zy8HYpRKMR/QmpoMZrW
	 S4EeUNTKJskUX9vv7OSGDPXsKcoH6Vg0ITlfKb7V/GblRR9sQNnv32+Nm1h73Azljg
	 87PXmnNA5FxKA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] btrfs: fix double free of data space reservation on direct IO error
Message-ID: <966ef17f-f80c-468a-b763-53470ff4cf1c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 22 May 2026 18:53:32 +0000 (UTC)

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
Link: https://syzkaller.appspot.com/ai_job?id=343be34d-df17-4e23-82ac-9918e4cd4783
To: "Chris Mason" <clm@fb.com>
To: "David Sterba" <dsterba@suse.com>
To: <linux-btrfs@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Resending the patch as requested by the reviewer to test functionality.

v1:
https://lore.kernel.org/all/07963d2a-cd0f-4940-a5bc-33dd8f425781@mail.kernel.org/T/
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
