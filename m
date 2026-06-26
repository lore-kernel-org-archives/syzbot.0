Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E16373B42D8
	for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 20:21:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782505300; cv=none; b=DKvP7Pz12Lxdus3vNwdpe/ZVKcTeyB2X7F2Y9JoDe8oUo8REm1eeH309+35GhndTXP6RIA55k3UzAzBsCGxYIPWcTe09TXaSulDsGjYGQaRsjyWiOfSqdMxDg7OXga2RaPDNjafYa2gXi2owRgWsNxKpU7W7KLTwsV3Vf40o+58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782505300; c=relaxed/simple;
	bh=g70fQQ7x6sCqbQCIBY3AVjHD6lS7lDRQuZGS/lmWhsk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=LQufMD4YmHAFIQ2MvFJGonDyLnv/FC5dcrf/KmRQs5tY0BdyeLARg/jyJH35L57hOtij1aqSeiIQgtmJJh1GGzayt8ax1HOZA1TjCa0YYtMeqjxJPJguZQ0LGRgebh+ivC3O7qBLPfFuub+KHlAAeAJs89KNIdmvMEYDztL3m7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6a0ebc78c26so1985602eaf.0
        for <syzbot@lists.linux.dev>; Fri, 26 Jun 2026 13:21:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782505298; x=1783110098;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vFnp6yPbpElupK1Zb77MSKNK5x0yNy0ECJxMHPtpLT4=;
        b=aMt09JJYp5vKSTE/kkDTwZOqMzxoMK7ywTFwLs0c3kpDJaxCISTHdNY9+1ZOpcHzYq
         uPWA6W+PYp07uQFFxp3Kdp0YoWbzZKyBgAJXSTJxeY4WRcqAmshr1jXkthrB5OLiXeZH
         wfiDylKEVHEQVuld0kt2kzFSdMmh0kYesrzXtD09hmPqxOyYJDrnJSwJBq7Urghn30mQ
         U5BZJu9FQVpm/Ow0b5XmTYquDAEDXtU0KZRKGIiD06dMJc3bhBkpLsgVsPSDoqAqmw4e
         +HzxWLM3VAMyWezzqMev2wdWL2Db+UAVkEk8iqH/+gvkgWGs9fyYNZdJPrSnvmKuJkHw
         lYJg==
X-Gm-Message-State: AOJu0Yze/AO68CoILxJMPEnuApthmZPVNesLFmLx9r9h6Bas1Rtjwy0M
	VlE17c5JTxRJWIJmHNPIXpQAwHJxBoFvlrD9X7BxnX7aSaKHVtqMYko74AxZCIsyx4rRf1PpyU8
	qHONkpio1GMXm2qvzBmZOvaDlMTYfHMMc8WUWPr6m5oN2mI5cT4fEF8cWTnY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:16a7:b0:6a1:4fbf:5f46 with SMTP id
 006d021491bc7-6a14fbf61bcmr1273040eaf.10.1782505298004; Fri, 26 Jun 2026
 13:21:38 -0700 (PDT)
Date: Fri, 26 Jun 2026 13:21:37 -0700
In-Reply-To: <20260626202118.2464544-1-jbingham@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3edf51.656f0a6b.201ab1.0001.GAE@google.com>
Subject: Forwarded: [syzbot ci] Re: minix: convert to iomap and add direct I/O
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@lists.linux.dev
Cc: syzbot <syzbot+ci97bc680341b3b928@syzkaller.appspotmail.com>, jbingham@gmail.com
Content-Type: text/plain; charset="UTF-8"

For archival purposes, forwarding an incoming command email to
syzbot@lists.linux.dev.

***

Subject: [syzbot ci] Re: minix: convert to iomap and add direct I/O
Author: jbingham@gmail.com

Apparently I did this wrong the first time. I misunderstood and sent one
patch covering all the changes differing from master, rather than just
patching the changes to fix the errors syzbot found.

#syz test

---
 fs/minix/file.c         |  4 ++--
 fs/minix/inode.c        | 11 ++++++-----
 fs/minix/itree_common.c | 11 ++++++++++-
 fs/minix/minix.h        |  3 +++
 4 files changed, 21 insertions(+), 8 deletions(-)

diff --git a/fs/minix/file.c b/fs/minix/file.c
index 1f4217115401..b07c853fa43a 100644
--- a/fs/minix/file.c
+++ b/fs/minix/file.c
@@ -175,8 +175,8 @@ const struct file_operations minix_file_operations = {
 	.splice_write	= iter_file_splice_write,
 };
 
-static int minix_setattr(struct mnt_idmap *idmap,
-			 struct dentry *dentry, struct iattr *attr)
+int minix_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
+	struct iattr *attr)
 {
 	struct inode *inode = d_inode(dentry);
 	int error;
diff --git a/fs/minix/inode.c b/fs/minix/inode.c
index cd12e59ce9b9..8a79ff82a656 100644
--- a/fs/minix/inode.c
+++ b/fs/minix/inode.c
@@ -444,10 +444,10 @@ static ssize_t minix_writeback_range(struct iomap_writepage_ctx *wpc,
 	if (pos < wpc->iomap.offset ||
 			pos >= wpc->iomap.offset + wpc->iomap.length) {
 		if (INODE_VERSION(wpc->inode) == MINIX_V1)
-			error = V1_minix_iomap_begin(wpc->inode, pos, len, 0,
+			error = V1_minix_iomap_begin(wpc->inode, pos, len, IOMAP_WRITE,
 				&wpc->iomap, NULL);
 		else
-			error = V2_minix_iomap_begin(wpc->inode, pos, len, 0,
+			error = V2_minix_iomap_begin(wpc->inode, pos, len, IOMAP_WRITE,
 				&wpc->iomap, NULL);
 		if (error)
 			return error;
@@ -490,7 +490,7 @@ static int minix_writepages(struct address_space *mapping,
 
 static int minix_read_folio(struct file *file, struct folio *folio)
 {
-	const struct iomap_ops *ops = minix_iomap_ops_ver(file->f_inode);
+	const struct iomap_ops *ops = minix_iomap_ops_ver(folio->mapping->host);
 
 	iomap_bio_read_folio(folio, ops);
 	return 0;
@@ -504,7 +504,7 @@ static int minix_block_read_folio(struct file *file, struct folio *folio)
 
 static void minix_readahead(struct readahead_control *rac)
 {
-	const struct iomap_ops *ops = minix_iomap_ops_ver(rac->file->f_inode);
+	const struct iomap_ops *ops = minix_iomap_ops_ver(rac->mapping->host);
 
 	iomap_bio_readahead(rac, ops);
 }
@@ -545,7 +545,7 @@ static sector_t minix_bmap(struct address_space *mapping, sector_t block)
 	return iomap_bmap(mapping, block, ops);
 }
 
-static const struct address_space_operations minix_aops = {
+const struct address_space_operations minix_aops = {
 	.dirty_folio	= iomap_dirty_folio,
 	.invalidate_folio = iomap_invalidate_folio,
 	.read_folio = minix_read_folio,
@@ -575,6 +575,7 @@ static const struct address_space_operations minix_dir_aops = {
 static const struct inode_operations minix_symlink_inode_operations = {
 	.get_link	= page_get_link,
 	.getattr	= minix_getattr,
+	.setattr	= minix_setattr,
 };
 
 void minix_set_inode(struct inode *inode, dev_t rdev)
diff --git a/fs/minix/itree_common.c b/fs/minix/itree_common.c
index c3cd2c75af9c..5a8b73a7beda 100644
--- a/fs/minix/itree_common.c
+++ b/fs/minix/itree_common.c
@@ -311,7 +311,16 @@ static inline void truncate (struct inode * inode)
 	long iblock;
 
 	iblock = (inode->i_size + sb->s_blocksize -1) >> sb->s_blocksize_bits;
-	block_truncate_page(inode->i_mapping, inode->i_size, get_block);
+
+	/* Depending on what address space operations are being used by the
+	 * inode being truncated, we need to either call iomap_truncate_page or
+	 * block_truncate_page.
+	 */
+	if (inode->i_mapping->a_ops == &minix_aops)
+		iomap_truncate_page(inode, inode->i_size, NULL,
+			minix_iomap_ops_ver(inode), NULL, NULL);
+	else
+		block_truncate_page(inode->i_mapping, inode->i_size, get_block);
 
 	n = block_to_path(inode, iblock, offsets);
 	if (!n)
diff --git a/fs/minix/minix.h b/fs/minix/minix.h
index face74100346..270e4e0620a1 100644
--- a/fs/minix/minix.h
+++ b/fs/minix/minix.h
@@ -58,6 +58,8 @@ void minix_free_block(struct inode *inode, unsigned long block);
 unsigned long minix_count_free_blocks(struct super_block *sb);
 int minix_getattr(struct mnt_idmap *, const struct path *,
 		struct kstat *, u32, unsigned);
+int minix_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
+	struct iattr *attr);
 int minix_prepare_chunk(struct folio *folio, loff_t pos, unsigned len);
 struct mapping_metadata_bhs *minix_get_metadata_bhs(struct inode *inode);
 int minix_fsync(struct file *file, loff_t start, loff_t end, int datasync);
@@ -88,6 +90,7 @@ extern int V2_minix_iomap_begin(struct inode *inode, loff_t offset,
 	loff_t length, unsigned int flags, struct iomap *iomap,
 	struct iomap *srcmap);
 
+extern const struct address_space_operations minix_aops;
 extern const struct inode_operations minix_file_inode_operations;
 extern const struct inode_operations minix_dir_inode_operations;
 extern const struct file_operations minix_file_operations;
-- 
2.47.3


