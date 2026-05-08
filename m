Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373732F8E8A
	for <syzbot@lists.linux.dev>; Fri,  8 May 2026 22:07:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778278028; cv=none; b=IS64DFHxrfrgBRf56JKxOGZvb3hhYb9hBA767Gu8BxZmaWznGSoSbZsYNys8XMbO+iFgiGa7HuODqvtpXf6lM8U0P1v6ZRHxkOPQWcMBxvj/OKs1Ydk+caNfrSaEIoRbYZgAxVpHqyX9OCCG1mqFVN6CkJd+UrWoYdUOkifgxrM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778278028; c=relaxed/simple;
	bh=zjVcuYiLPRTPLWq+n9RAApTSWqcR30R8ErEHn9Ulrm8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=kNIQQx0PVhOmTBRdSzPLwzjl1O3lNNtcKR8XsZaQT1YsymmiMPbf8RouqBM/rmjn+SEy9iMwlovTOO4RIM83RSahn77t6EgrkI0tFQ4KcEMmfJ+QyS3qxtJsnh1RhvjGoNLCtZf4g/HsiL3jK24GyFGd7/JMAokA963uEwcE1YE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KHvEWwkl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KHvEWwkl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF338C2BCB0;
	Fri,  8 May 2026 22:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778278027;
	bh=zjVcuYiLPRTPLWq+n9RAApTSWqcR30R8ErEHn9Ulrm8=;
	h=From:To:Cc:Subject:Date:From;
	b=KHvEWwklaYZEUajyJG66m8K7FanvYNVlpoGjxOsARo8rs+25xXnVVIQv5/CbHF90f
	 aTnlXzcJhEL6+ymfcMpOrYs0Ksvs63sPiE3BAKTleebY1kXxxHLNBipRZx5J2zi/iC
	 yKP4ztrMPPhgxlJDaNtbpzSbSaw1pbZrrV0HjIQJxSxzvaApbOLzAG2bcxBE0iFaqX
	 UY2xOp+sGlIImgE9ZAxXSuxVKSiAGhEU4UMTGYy5G0dNjVlERtzeGM7A0b5Xcap7MW
	 zEl3fjrMMDmU3xccRO61QiUy6z0aRBsNZZEZQdX2iIjcOoTnTV3GeAFe28lj5uxIqu
	 0JzEFChjXn8pg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] udf: Replace WARN_ON with error handling in __udf_add_aext()
Message-ID: <cc1b2586-5c5b-45f1-ba7e-e6ca8265ab95@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  8 May 2026 22:07:07 +0000 (UTC)

udf: Replace WARN_ON with error handling in __udf_add_aext()

syzbot reported a crash triggered by a WARN_ON() assertion in
__udf_add_aext(). The assertion fails because a maliciously crafted UDF
image can contain a 0-length extent (which acts as an EOF marker) before
the end of the space declared by lengthAllocDescs. When udf_next_aext()
stops at this 0-length extent, epos->offset is left pointing to it,
which is strictly less than the end of lengthAllocDescs, triggering the
WARN_ON().

WARN_ON() must not be used for conditions that can legitimately happen
due to corrupted filesystem images, as it can panic the kernel if
panic_on_warn is set. Instead, log the inconsistency using pr_err() and
fix the corruption by recalculating and setting i_lenAlloc and
lengthAllocDescs to the correct length based on epos->offset. This
effectively truncates any garbage data after the 0-length extent and
restores the filesystem to a consistent state.

Fixing lengthAllocDescs before calling udf_write_aext() is crucial.
udf_write_aext() calls udf_update_tag(), which calculates a CRC over
the length specified by lengthAllocDescs. If we blindly add adsize to a
corrupted (artificially large) length, udf_update_tag() will read out
of bounds, causing a buffer overflow. By fixing the length first, we
ensure the CRC is calculated over the correct bounds.

Finally, replace the WARN_ON(epos->offset + adsize >
inode->i_sb->s_blocksize)
with an error return. If this condition is met, continuing execution
will result in udf_write_aext() writing past the end of the block
buffer. Instead of just warning, log the error and return -EFSCORRUPTED
to safely abort the operation.

Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
To: <jack@suse.com>
To: <linux-kernel@vger.kernel.org>

---
diff --git a/fs/udf/inode.c b/fs/udf/inode.c
index 67bcf8375..f7266551e 100644
--- a/fs/udf/inode.c
+++ b/fs/udf/inode.c
@@ -2078,13 +2078,30 @@ int __udf_add_aext(struct inode *inode, struct extent_position *epos,
 		return -EIO;
 
 	if (!epos->bh) {
-		WARN_ON(iinfo->i_lenAlloc !=
-			epos->offset - udf_file_entry_alloc_offset(inode));
+		if (iinfo->i_lenAlloc !=
+		    epos->offset - udf_file_entry_alloc_offset(inode)) {
+			pr_err("udf: alloc length %u != offset %u\n",
+			       iinfo->i_lenAlloc,
+			       epos->offset -
+				       (uint32_t)udf_file_entry_alloc_offset(
+					       inode));
+			iinfo->i_lenAlloc = epos->offset -
+					    udf_file_entry_alloc_offset(inode);
+		}
 	} else {
 		aed = (struct allocExtDesc *)epos->bh->b_data;
-		WARN_ON(le32_to_cpu(aed->lengthAllocDescs) !=
-			epos->offset - sizeof(struct allocExtDesc));
-		WARN_ON(epos->offset + adsize > inode->i_sb->s_blocksize);
+		if (le32_to_cpu(aed->lengthAllocDescs) !=
+		    epos->offset - sizeof(struct allocExtDesc)) {
+			pr_err("udf: alloc length %u != offset %zu\n",
+			       le32_to_cpu(aed->lengthAllocDescs),
+			       epos->offset - sizeof(struct allocExtDesc));
+			aed->lengthAllocDescs = cpu_to_le32(
+				epos->offset - sizeof(struct allocExtDesc));
+		}
+		if (epos->offset + adsize > inode->i_sb->s_blocksize) {
+			pr_err("udf: no space left in block\n");
+			return -EFSCORRUPTED;
+		}
 	}
 
 	udf_write_aext(inode, epos, eloc, elen, inc);


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
