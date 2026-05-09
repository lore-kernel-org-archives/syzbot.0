Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3AA0129CB57
	for <syzbot@lists.linux.dev>; Sat,  9 May 2026 07:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778312018; cv=none; b=hMDKEl4E8N/krgwE/MOqw6qpphGcRnma18faPH/QPyqaG8qm/ezOhGhpH/YbTPcNec9sQTr7J6SscNgpyNmg/09H9jQhjXBlRyWV1b3RexZg6QnUSeRTGcMOF6n8km8mPnkBIU6NXLaCE1XVfV3LKNZ5MrXhyxsdsGolz4cr22k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778312018; c=relaxed/simple;
	bh=+FBZH0jhbKXJBnWnNNf+2COvvpXWKcE1gBvjEYn8LoI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=fEj+MpI+ErLXA0Z5VSg0slGuY8rG/xEMySJarXXjfGCuijXlUR5PpfSGwfqB3OF43pJaxaw+P++vsWbgU3cyGLI2BDvMIY75YCpy66871qVKUB0YS5RfB3/0xOFryIHhaYVFJMmiR/C4YtBubd0zc3UD67WnbRw2b+CDvg/2yPU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=MdcmuyNQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="MdcmuyNQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E0F9EC2BCB2;
	Sat,  9 May 2026 07:33:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778312018;
	bh=+FBZH0jhbKXJBnWnNNf+2COvvpXWKcE1gBvjEYn8LoI=;
	h=From:To:Cc:Subject:Date:From;
	b=MdcmuyNQmZQ3SCIIDArKDaWmWJxA9pCaQd64JpCzk2hheGmbBY13tQ2/ZM//zWmJC
	 j+CgxILd4q90/fql9NQO8w1zNr7wDvIBlzxzQ7t6noNKNyorTQ/guDhvPnJpCvRdN6
	 r/nX+gUnEsptDktV+zzVkl7VUUm/SgLSQU0FGzCVZ4SIU5aSfMsCRFpguiWSoczx7X
	 +cSHRp+x1SBGor0AdbK1C8ARczXmRKthdr9wHbJrepMPQaB/wQX00IiLmXZefWusFo
	 ivX4MtpjdtuCJulf3tuC4GZiEgN1m3or4Ry74EleDQxEl5vY9eiIe7zyoQBKUqL5Xi
	 EQuF2imUPoBDw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation+final@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH] udf: Replace WARN_ON with error handling in __udf_add_aext()
Message-ID: <daff2ef6-01f6-4112-8f2d-8bc3d507d979@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat,  9 May 2026 07:33:37 +0000 (UTC)

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
See  for more information.
