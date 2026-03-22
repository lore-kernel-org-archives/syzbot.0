Received: from embla.dev.snart.me (embla.dev.snart.me [54.252.183.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2D193803EF
	for <syzbot@lists.linux.dev>; Sun, 22 Mar 2026 12:36:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=54.252.183.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774182967; cv=none; b=ljCyCCMkjDEIpb7cDL/+Q16i7PkrYPHF7kBBeQ4JxU0QNIMwsy5cTDWarhgEXs1iefCo9X2dYBLeWQ/j1EqQi5meF2QL9oRibohlhOy8rVRp9WNETgMDktbLYv5laQEZEz/pZNzNxOwlM0DTb922q3FA/k+ApMOSKQY42yLeQRM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774182967; c=relaxed/simple;
	bh=50RUOlR/ILEghFLBtLJT4k4kel2GkckTFYTeLlteAtM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l5N/0Z9NKEsmQ0b4wPpmNr4nYlsD4ekAs/t3gYv5ojWSjPgKlpmY83TucePs35pSBDde2G727HTRrtGzOX1jZEG0JIz+O+cmgvdHHGKCcI77anbvYi7ZYO5m7DglMUky+OhShZPQosowtdqBZ6BNx588vupKcuCHFnowtE1hR9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.snart.me; spf=pass smtp.mailfrom=dev.snart.me; dkim=pass (1024-bit key) header.d=dev.snart.me header.i=@dev.snart.me header.b=YiK1Ro+G; arc=none smtp.client-ip=54.252.183.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=dev.snart.me
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.snart.me
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=dev.snart.me header.i=@dev.snart.me header.b="YiK1Ro+G"
Received: from embla.dev.snart.me (localhost [IPv6:::1])
	by embla.dev.snart.me (Postfix) with ESMTP id ED7891D490;
	Sun, 22 Mar 2026 12:36:02 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 embla.dev.snart.me ED7891D490
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=dev.snart.me; s=00;
	t=1774182964; bh=50RUOlR/ILEghFLBtLJT4k4kel2GkckTFYTeLlteAtM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YiK1Ro+G2NVFXSbnTMSjm7eKSvP57x/3S8k92UK53dgwyUgDJ7rOCs0dLbU71WR0D
	 JCKMDqntI6yyEDV9GtRm7XstsxbLHH9mKzF0niDiVT+di8CQWzerrOmnw+i2OhAbsK
	 CJquEbZXkrN/EFHqazi2X9qIOWBGjvSdc9QpqxAE=
Received: from maya.d.snart.me ([182.226.25.243])
	by embla.dev.snart.me with ESMTPSA
	id jY/kJTLiv2nLwQgA8KYfjw
	(envelope-from <dxdt@dev.snart.me>); Sun, 22 Mar 2026 12:36:02 +0000
From: David Timber <dxdt@dev.snart.me>
To: syzbot ci <syzbot+ci684179a8afcfdab1@syzkaller.appspotmail.com>,
	linkinjeon@kernel.org,
	linux-fsdevel@vger.kernel.org,
	linux-kernel@vger.kernel.org,
	sj1557.seo@samsung.com,
	yuezhang.mo@sony.com
Cc: syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: RE: [syzbot ci] Re: exfat: add limited FALLOC_FL_ZERO_RANGE support
Date: Sun, 22 Mar 2026 21:35:45 +0900
Message-ID: <20260322123545.39132-1-dxdt@dev.snart.me>
X-Mailer: git-send-email 2.53.0.1.ga224b40d3f.dirty
In-Reply-To: <69bd026e.050a0220.3bf4de.0012.GAE@google.com>
References: <69bd026e.050a0220.3bf4de.0012.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

#syz test

diff --git a/fs/exfat/file.c b/fs/exfat/file.c
index 2daf0dbabb24..dfa5fc89f77d 100644
--- a/fs/exfat/file.c
+++ b/fs/exfat/file.c
@@ -36,7 +36,8 @@ static int exfat_cont_expand(struct inode *inode, loff_t size)
 	num_clusters = EXFAT_B_TO_CLU(exfat_ondisk_size(inode), sbi);
 	new_num_clusters = EXFAT_B_TO_CLU_ROUND_UP(size, sbi);
 
-	if (new_num_clusters == num_clusters)
+	WARN_ON(new_num_clusters < num_clusters);
+	if (new_num_clusters <= num_clusters)
 		goto out;
 
 	if (num_clusters) {
@@ -94,35 +95,87 @@ static int exfat_cont_expand(struct inode *inode, loff_t size)
 /*
  * Preallocate space for a file. This implements exfat's fallocate file
  * operation, which gets called from sys_fallocate system call. User space
- * requests len bytes at offset. In contrary to fat, we only support
- * FALLOC_FL_ALLOCATE_RANGE because by leaving the valid data length(VDL)
- * field, it is unnecessary to zero out the newly allocated clusters.
+ * requests len bytes at offset.
+ *
+ * In contrary to fat, FALLOC_FL_ALLOCATE_RANGE can be done without zeroing out
+ * the newly allocated clusters by leaving the valid data length(VDL) field
+ * unchanged.
+ *
+ * Due to the inherent limitation of the VDL scheme, FALLOC_FL_ZERO_RANGE is
+ * only possible when the requested range covers EOF.
  */
 static long exfat_fallocate(struct file *file, int mode,
 			  loff_t offset, loff_t len)
 {
 	struct inode *inode = file->f_mapping->host;
-	loff_t newsize = offset + len;
+	loff_t newsize, isize;
 	int err = 0;
 
 	/* No support for other modes */
-	if (mode != FALLOC_FL_ALLOCATE_RANGE)
+	switch (mode) {
+	case FALLOC_FL_ALLOCATE_RANGE:
+	case FALLOC_FL_ZERO_RANGE:
+	case FALLOC_FL_ZERO_RANGE|FALLOC_FL_KEEP_SIZE:
+		break;
+	default:
 		return -EOPNOTSUPP;
+	}
 
 	/* No support for dir */
 	if (!S_ISREG(inode->i_mode))
-		return -EOPNOTSUPP;
+		return mode & FALLOC_FL_ZERO_RANGE ? -EINVAL : -EOPNOTSUPP;
 
 	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
 		return -EIO;
 
 	inode_lock(inode);
 
-	if (newsize <= i_size_read(inode))
-		goto error;
+	newsize = offset + len;
+	isize = i_size_read(inode);
+
+	if (mode & FALLOC_FL_ZERO_RANGE) {
+		struct exfat_inode_info *ei = EXFAT_I(inode);
+		loff_t saved_validsize = ei->valid_size;
+
+		/* The requested range must span to or past EOF */
+		if (newsize < isize) {
+			err = -EOPNOTSUPP;
+			goto error;
+		}
+
+		/* valid_size can only be truncated */
+		if (offset < ei->valid_size)
+			ei->valid_size = offset;
+		/* If offset >= ei->valid_size, the range is already zeroed so that'd be no-op */
+
+		if (!(mode & FALLOC_FL_KEEP_SIZE) && isize < newsize)
+			err = exfat_cont_expand(inode, newsize);
+			/* inode invalidated in exfat_cont_expand() */
+		else {
+			/* update inode */
+			inode_set_mtime_to_ts(inode, inode_set_ctime_current(inode));
+			mark_inode_dirty(inode);
+
+			if (IS_SYNC(inode))
+				err = write_inode_now(inode, 1);
+		}
+
+		if (err) {
+			/* inode unchanged - revert valid_size */
+			ei->valid_size = saved_validsize;
+			goto error;
+		}
+
+		/* drop cache after the new valid_size */
+		if (ei->valid_size != saved_validsize)
+			truncate_pagecache(inode, ei->valid_size);
+	} else { /* mode == FALLOC_FL_ALLOCATE_RANGE */
+		if (newsize <= isize)
+			goto error;
 
-	/* This is just an expanding truncate */
-	err = exfat_cont_expand(inode, newsize);
+		/* This is just an expanding truncate */
+		err = exfat_cont_expand(inode, newsize);
+	}
 
 error:
 	inode_unlock(inode);
