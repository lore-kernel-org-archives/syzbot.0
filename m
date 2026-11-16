Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794814081;
	b=DPVSUNrTbToGM8su5V2ApwwCv6pVtPU8jNaQdSKoTdHDzBPFOZlX3kD7QbSqlx3jVYvC
	 B7n2ss5D8wDmoptwYXamNEYA9ZZXw56+ND217ZtnfluPTab0GAWKB+h3Wj+I5shOGVvq5
	 X/B5nRxxTT5KuOzcZ4As/UM9bNUFnN1TxD9rSc17slmcKFRCNbShZNqvZoyFNXAeTIHPe
	 7e61nhIu1o7XaGn3G9owe4FNw7p/bbx+mQdA1G2+K/qXYtSUx52CJBQVXprJFP3UNN5M6
	 3ZE/dB+5bWuONdQvbjA8Pqhu1A0KwmMUE1rhQGV7sqJ0b3ZMJfzlYoTxK252Ymby35w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794814081;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-Id:
	 In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:
	 Content-Transfer-Encoding;
	bh=99kz+PX37eJGQSDvwzUedrt772Wv4TF9acUD636bN6E=;
	b=lUpexHrU9D+b0k/Nl7opPGiw75zl3D5YkMfqdk5QdLAHeWAXz9qILPtf98Xn+oDLMKY+
	 8qXn1qXnggT/4gVSlgDB1J6LzqtseS0KjAyO1DzjwC5SQlYWQaWihKDcfS2CzJNtsXuKQ
	 lzPbzv+yNrDUS75A0G2XTpwvMtw8KGFuNMsYC6pFoUgVAakFTKn3g7bfFZWsyLG8vvfyJ
	 He7oyI+D1+4gLqoccdszEYMAVbAm7u+xCKWgi1JBFMtlatvvQ+eZylgR2ysTOwduxuXsV
	 X8vBAzrIWkiwR/aeEYYiDhEN/EvRb3m3xZmXIwMzahXokNgbjg96ZUxEKBlDe6dgg6A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=v7OfpD+H;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC7D606A323;
	Mon, 16 Nov 2026 07:28:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux-foundation.org header.i=@linux-foundation.org header.a=rsa-sha256 header.s=korg header.b=v7OfpD+H
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E11C1F000C4;
	Mon, 16 Nov 2026 07:28:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
	d=linux-foundation.org; s=korg; t=1794814081;
	bh=99kz+PX37eJGQSDvwzUedrt772Wv4TF9acUD636bN6E=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References;
	b=v7OfpD+HpSC9EYi6CzoynYi2P67jL2umTKfu20zN26GKRxFh8QhJFFATY1M41TN1d
	 tlikG+j1mtV1vy5VNfQwhkfxFzKeug5eS7glhLfrdOtiHAN0BlfDIBPSbmsuV1tol/
	 e3i/e3uiwm+Nh1vvaEZZNSUjGH0KkUNLeuUuVEuU=
Date: Sun, 15 Nov 2026 23:28:01 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
 phillip@squashfs.org.uk, syzbot@lists.linux.dev,
 syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: Squashfs: fix a lot of AI issues and AI style
 issues
Message-Id: <20261115232801.b4e3971be104f9cfade6ed01@linux-foundation.org>
In-Reply-To: <6afaa788.3f8ef711.2cc87e.0002.GAE@google.com>
References: <20261111234402.252354-1-phillip@squashfs.org.uk>
	<6afaa788.3f8ef711.2cc87e.0002.GAE@google.com>
X-Mailer: Sylpheed 3.8.0beta1 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Sun, 15 Nov 2026 22:49:44 -0800 syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com> wrote:

> syzbot ci has tested the following series
> 
> [v2] Squashfs: fix a lot of AI issues and AI style issues
> https://lore.kernel.org/all/20261111234402.252354-1-phillip@squashfs.org.uk
> * [PATCH v2 01/22] Squashfs: convert SQUASHFS_COMPRESSED_* to inline functions
> * [PATCH v2 02/22] Squashfs: convert SQUASHFS_INODE_* and SQUASHFS_MKINODE to inline functions
> * [PATCH v2 03/22] Squashfs: convert SQUASHFS_FRAGMENT_* to inline functions
> * [PATCH v2 04/22] Squashfs: convert SQUASHFS_LOOKUP_* to inline functions
> * [PATCH v2 05/22] Squashfs: convert SQUASHFS_ID_* to inline functions
> * [PATCH v2 06/22] Squashfs: convert SQUASHFS_XATTR_* to inline functions
> * [PATCH v2 07/22] Squashfs: fix offset in squashfs_read_inode() TRACE statements
> * [PATCH v2 08/22] Squashfs: fix fragment bytes overflow on 32-bit architectures
> * [PATCH v2 09/22] Squashfs: fix fragment index table length too large exploit
> * [PATCH v2 10/22] Squashfs: sanity check inode metadata block location
> * [PATCH v2 11/22] Squashfs: sanity check directory metadata block location
> * [PATCH v2 12/22] Squashfs: widen xattr count variables and add sanity check
> * [PATCH v2 13/22] Squashfs: very large files can exceed an int block count
> * [PATCH v2 14/22] Squashfs: add more sanity checking to squashfs_block_size()
> * [PATCH v2 15/22] Squashfs: sanity check fragment block location and range
> * [PATCH v2 16/22] Squashfs: sanity check block list sizes and range
> * [PATCH v2 17/22] Squashfs: don't store large export table indexes in memory
> * [PATCH v2 18/22] Squashfs: don't store large fragment table indexes in memory
> * [PATCH v2 19/22] Squashfs: don't store large xattr id table indexes in memory
> * [PATCH v2 20/22] Squashfs: fix variables in directory code and add more sanity checks
> * [PATCH v2 21/22] Squashfs: fix regression in squashfs_copy_cache()
> * [PATCH v2 22/22] Squashfs: check index isn't greater than S64_MAX in squashfs_read_data()
> 
> and found the following issues:
> * general protection fault in __d_obtain_alias
> * general protection fault in lookup_one_qstr_excl
> * general protection fault in lookup_open
> * general protection fault in security_d_instantiate
> * general protection fault in step_into_slowpath
> 
> Full report is available here:
> https://ci.syzbot.org/series/dc24cdf0-7531-440e-8970-9c83c975cd2f

OK, thanks.

I think I just fixed this thanks to a smatch report from Dan.  Below.


<llm>
Separately, "[PATCH v2 11/22] Squashfs: sanity check directory metadata
block location" stores squashfs_dir_start() in a u64 in
squashfs_lookup(), then checks block < 0.  That check cannot detect its
negative error returns; block needs a signed type.
</llm>

OK.  I'll put a s64 cast in there for now.  So hopefully we're all good.
Phillip, please check.



From: Andrew Morton <akpm@linux-foundation.org>
Subject: squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix
Date: Sun Nov 15 09:54:43 PM PST 2026

fix smatch warnings

Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <error27@gmail.com>
Closes: https://lore.kernel.org/r/202611131955.0Gd7ipSP-lkp@intel.com/
Cc: Phillip Lougher <phillip.lougher@gmail.com>
Cc: Phillip Lougher <phillip@squashfs.org.uk>

 fs/squashfs/namei.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/fs/squashfs/namei.c~squashfs-fix-variables-in-directory-code-and-add-more-sanity-checks-fix
+++ a/fs/squashfs/namei.c
@@ -221,8 +221,10 @@ static struct dentry *squashfs_lookup(st
 			/*
 			 * Read directory entry.
 			 */
-			if (!squashfs_dir_space(dir, length, sizeof(*dire)))
+			if (!squashfs_dir_space(dir, length, sizeof(*dire))) {
+				err = -ENOSPC;
 				goto read_failure;
+			}
 
 			err = squashfs_read_metadata(dir->i_sb, dire, &block,
 					&offset, sizeof(*dire));
@@ -236,8 +238,10 @@ static struct dentry *squashfs_lookup(st
 			if (size > SQUASHFS_NAME_LEN)
 				goto data_error;
 
-			if (!squashfs_dir_space(dir, length, size))
+			if (!squashfs_dir_space(dir, length, size)) {
+				err = -ENOSPC;
 				goto read_failure;
+			}
 
 			err = squashfs_read_metadata(dir->i_sb, dire->name,
 					&block, &offset, size);
_

