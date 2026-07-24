Received: from mail-wr1-f50.google.com (mail-wr1-f50.google.com [209.85.221.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 816303DAAB5
	for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 17:30:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784914234; cv=none; b=Mxenh4SesNrp1j7uR2JLORwZ4KZjnKsdE78bl7Ab523AWTQ8Pdco5Rmz/khw+lnqMPs/7Xt/MS5XXnOF+kC9nJnGSbzQ/CCDQl+u5Fh1/3zapy0GSfLBlM8UmMxs29qnT67OyW/E/blOvyQPHXPmLappgNIGAiYLhbHJfPSuiKg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784914234; c=relaxed/simple;
	bh=8BUsiJ4uh9Qx0LPuXBVgbzQ8KjiIjsv56KSyDtqNNQw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=MLF6RybDK01qbPTlLYEGJgFpyvTzlDdKC4eD1eDAlT/rTuk0difqhvz6Z54OqcsA5toJZM175UKJGb0ZCqoIGkV97nSnPwH3W8H7u04PE31FEGU7eUYJF0X41k5e9pQefuBQY27/IVnIrcHJIAchc7DWNMZqaU9oenYxQNHUhQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=GpdG1H7B; arc=none smtp.client-ip=209.85.221.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="GpdG1H7B"
Received: by mail-wr1-f50.google.com with SMTP id ffacd0b85a97d-472326ca506so554323f8f.2
        for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 10:30:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784914224; x=1785519024; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7Guam7TKBV5fgeurYYbuymip/i4vE8NqeZ+B1MEkxXI=;
        b=GpdG1H7B1XlO5mh/4OnwlRgIUk8u4v/WL4uLfdzuC3wq7H1tQ4oY7mz/S6RuY0/W4D
         itsoCcaVBmIhrPHDvk/kvZdnDyslp7rCXnyQR272xek4Hprk4P2J7CMlvu7S6qsJaIHY
         Rmx/6FgvMETdy0/3KZjNor4j0v41VcPoyRphQXnc+Bc/HTtGSzTJLZVU6IVzlXTaceeY
         mz6hYs4n0i1YEjFsT8ErI3LQbLXPpOYiMsfjmZwlek/jhYHmMaiNs2X1OJ5M0zAay1YP
         6Gwmnp+3tL+Hzn+8GMLuVIW3bqUcYmiHiH60S6mBV/RWxMr1ej5gB5zr1S0ceBq428cf
         Brlw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784914224; x=1785519024;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7Guam7TKBV5fgeurYYbuymip/i4vE8NqeZ+B1MEkxXI=;
        b=hE8uShDxEbK6yT5keO6jAat8I55BxY+XPj1ACZ8vzYYhqhOsqzWwDk+O6ornQQIQ4U
         BUyVtxsAfrq4b9FbBWmxabSa2cqk2s4gqxJC9MU9L/0Xw1Qwk3SXiE4v3QYla0yAWE13
         umqZ+XDOyxY/WeR/+pV9XVWI9qjyQ+RZY4+bgGf/OuqieZfzzIkPVmmD3joinyVtPvLt
         6A2jkTqPduiS6f0QLTXnFVS6PdblnTCvhCM/YRNJw77XnuMwYywH4//Ak2qkyno9wBZG
         SNw2LDO6NUteCNweqC8sQ9iMZyH7SOKZ+z3WlLU7gKEM9ilnLvNSFCt4yLoahteFNzKp
         2e/Q==
X-Forwarded-Encrypted: i=1; AHgh+RrNerEsW+qFfp+JXsQVzgMyTlRGgMVd6PJkF+VzYkDoRmf24gWnqs2LWvd1Xfd7q+hdvxyf4Jw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyLsN9ky+XgIKCtV0GmHe6FdnjshlzfnHfsyzykVeXyFC9aQ/P
	BaHk1h1KMMzUE8g2r1zrTyp5SQaa834Wz4ExMajNTHcSRNTi9y0GQTpm5zb7JE05O/w=
X-Gm-Gg: AR+sD12O8twYuihkSR6iUBiGOUVmCiXP0nPFmBuwnDU2y9m5oJLU4nw/u+oBSCjW5LL
	TSCpjNIsi2Z0R8EHzDIWP9E+pIgGRU8E/eArmhPxYRPIxHhKO0x+jHZvZf637X6Z86csbnOm4Vw
	X6b6yMKI/Hdm3oZ/xQpqcpk9M8NjcpvMKUzcbaOt/l9f6BW3oXaLkXed1/+CUw9r9HZ/pVH+1D0
	vMgUMLirWZipofh51F9LBg5Vvr9YILzM79qYbaBERudr4sAuAroJmQsYlznGJJ0OlhJPlryLaGP
	cxiQ5qDp8+MQzbq2S163uY7xuMU4I29TVud07VEzhAcM7MjZQjFXJ0VeQ5UE74MdDgGBjkN6qlP
	qUxvFk+RXfyfnRy3GUygrbuzaVl7D40OBZ3KUKPw8A6X4o2hsR/sZL0nAZNH2aHWC2hHhtaJQgX
	QzvRJ/dCLLQ7eklY88LPin0gdZE+OEV6bFK/bhBYM=
X-Received: by 2002:a05:6000:26cd:b0:47f:9720:473f with SMTP id ffacd0b85a97d-47f972047a5mr4776092f8f.36.1784914223857;
        Fri, 24 Jul 2026 10:30:23 -0700 (PDT)
Received: from localhost ([37.30.44.117])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85a2573csm25159662f8f.0.2026.07.24.10.30.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 24 Jul 2026 10:30:23 -0700 (PDT)
Date: Fri, 24 Jul 2026 19:30:22 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] jfs: add dmap validation to prevent txLock BUG
Message-ID: <ypwoxwe3m5o7xhz5zb3ulrxjof7gt35dcnfltdy2uepvtppko4@66mehlfyf4tg>
References: <ff86d803-d687-48f6-9cc2-f3d35b27a666@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff86d803-d687-48f6-9cc2-f3d35b27a666@mail.kernel.org>

The v2 direction is close, but the patch still needs changes before it is
ready for upstream review. Please keep the expected-dmap-start check as the
basis of v3; changing txLock() is not the right fix.

Describe the exact root cause.
The selected image has one dmap for a 3788-block map. That dmap must start at
block 0, but dp->start is 1792. dbAllocDmapLev() selects leaf 1, offset 12 and
derives block 1836 from the forged start. dbAllocBits() maps block 1836 using
its dmap-relative low bits and updates word 57 instead of the selected word 1.
Word 1 therefore remains free and block 1836 can be returned again. txLock()
only detects that duplicate allocation later.

The commit message should explain this selection/update mismatch. It should
not describe an unproven race or claim generic dmap integrity checking.

Narrow the helper to the proven invariant.
The expected aligned start comparison is the causal fix and is constant-time.
Please make the helper boolean (and preferably const-correct) unless it will
return distinct errors that callers propagate. For example, its contract can
simply be "does this loaded dmap have the expected start?"

The current nblocks, tree.budmin, and stree[ROOT] checks turn the helper into a
partial generic validator. stree[ROOT] does not validate all leaves, and
requiring tree.budmin == BUDMIN makes the later tree.budmin < 0 branch
unreachable. Either remove those unrelated predicates from this fix or provide
a separately justified, complete validation contract and audit all callers.

Reconsider dbExtendFS().
The new dbExtendFS() call is broader than the allocation bug. If it remains,
validate the old partial-dmap extent before dbInitDmap() adds blocks, including
that the existing nblocks matches blkno - expected_start. Otherwise omit the
dbExtendFS() change from this minimal fix and handle extension hardening
separately.

Preserve fail-closed error handling and clean unwind.
A malformed on-disk dmap should use jfs_error() and return -EIO; a warning
alone is too weak for corrupted filesystem metadata. Replace the generic
"error in block map" text with a dmap-specific message that includes the
observed and expected start.

The new exits that own an IREAD lock and metapage currently release both.
Preserve those balanced paths. Callers that do not own an IREAD lock must not
gain a matching unlock. No allocation, reference-transfer, quota, or
transaction ownership change is needed.

Remove unrelated changes.
Please remove the jfs_dtree.c blank-line deletion, the jfs_xtree.c comment
reindentation, incidental spacing churn, and the now-unreachable budmin branch.
They are unrelated to the defect and make the review harder.

Correct the description and metadata.
A suitable subject would be along the lines of:

jfs: validate dmap start before block map operations

The description should state that the returned block is derived from
dp->start, while the bitmap update is derived from the block's relative
position, and that rejecting a mismatched start with -EIO prevents duplicate
allocation before txLock() is reached.

For the eventual upstream submission, the maintainer-derived recipients are:

To: Dave Kleikamp shaggy@kernel.org
Cc: jfs-discussion@lists.sourceforge.net
Cc: linux-kernel@vger.kernel.org

Please remove torvalds@ppc970.osdl.org and unrelated recipients unless there
is a specific review reason for them.

Please omit:

Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

That initial Git import proves only that the code already existed; it does not
prove that the import introduced this trust defect. Add a Fixes tag only if
the introducing change can be established from history. A human submitter
must add Signed-off-by. Assisted-by is acceptable when it accurately records
the tooling and contribution.

Verification needed for v3.
Please provide:

clean default and strict checkpatch results for the final patch;
a JFS build at the stated base and a current-mainline forward check;
an exact baseline/patched run of the reported C reproducer;
a malformed-image result showing -EIO without the txLock() BUG;
valid JFS allocation/free coverage;
a partial-dmap filesystem-extension regression if dbExtendFS() remains;
confirmation that no full dmap tree/bitmap scan was added to hot paths.
For v2, the applied diff passes default checkpatch and has three strict checks:
one unbalanced-braces advisory and two line-ending-with-'(' advisories. I have
not run build or runtime validation for v2.

With those focused changes, this remains a revision of the v2 approach rather
than a rewrite from scratch

On Thu, Jul 16, 2026 at 03:23:34AM +0000, syzbot wrote:
> A corrupted JFS filesystem image can cause a state where the block
> allocation map (bmap) and the inode map are out of sync. Specifically, a
> block can be incorrectly marked as free in the bmap while it is actually in
> use (e.g., as an inode table block). This inconsistency leads to a BUG() in
> txLock() when a thread attempts to allocate the block for a directory btree
> split while it is already locked by another process for a different
> purpose.
> 
> The crash manifests in txLock() as it detects a metapage conflict, but
> txLock() is merely the sink for the underlying corruption. The root cause
> is the lack of validation when reading dmap pages from the block map.
> 
> ------------[ cut here ]------------
> kernel BUG at fs/jfs/jfs_txnmgr.c:836!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> CPU: 1 UID: 0 PID: 5785 Comm: syz.0.124 Not tainted syzkaller #1
> PREEMPT(full)
> RIP: 0010:txLock+0x1cc3/0x1d10 fs/jfs/jfs_txnmgr.c:836
> Call Trace:
>  <TASK>
>  dtSplitRoot+0x38d/0x18a0 fs/jfs/jfs_dtree.c:1924
>  dtSplitUp fs/jfs/jfs_dtree.c:990 [inline]
>  dtInsert+0xeb2/0x5890 fs/jfs/jfs_dtree.c:868
>  jfs_create+0x730/0xae0 fs/jfs/namei.c:138
>  vfs_create+0x2c4/0x450 fs/namei.c:4202
> ...
> 
> This patch introduces dbValidateDmap() to verify the integrity of dmap
> structures upon access. It checks for valid block counts, free block
> counts, consistent start addresses, and internal tree metadata (height,
> leafs, etc.). If validation fails, the filesystem is marked as corrupted
> with jfs_error() and -EIO is returned to the caller, preventing the
> corruption from reaching the transaction manager.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> Reported-by: syzbot+a843f6ae2130a987d63b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a843f6ae2130a987d63b
> Link: https://syzkaller.appspot.com/ai_job?id=8dc49502-691a-48e9-907b-7e005180b8b2
> To: <jfs-discussion@lists.sourceforge.net>
> To: "Dave Kleikamp" <shaggy@kernel.org>
> To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
> Cc: "Arnd Bergmann" <arnd@arndb.de>
> Cc: "Christian Brauner (Amutable)" <brauner@kernel.org>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Mike Rapoport (Microsoft)" <rppt@kernel.org>
> Cc: "Yun Zhou" <yun.zhou@windriver.com>
> Cc: "Zheng Yu" <zheng.yu@northwestern.edu>
> 
> ---
> v2:
> - Replaced the approach of propagating errors from txLock() with proactive dmap validation.
> - Introduced dbValidateDmap() to check dmap page integrity (nblocks, nfree, start address, and tree structure).
> - Integrated dmap validation into dbFree(), dbUpdatePMap(), dbAlloc(), dbExtend(), dbAllocCtl(), dbAllocBottomUp(), and dbExtendFS().
> - Reverted return type changes for functions in jfs_dtree.c and jfs_xtree.c from the previous version.
> 
> v1:
> https://lore.kernel.org/all/9d2eba88-93bf-4f3c-a3b2-b554e1fffe80@mail.kernel.org/T/
> ---
> diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
> index a841cf21d..66a3d5416 100644
> --- a/fs/jfs/jfs_dmap.c
> +++ b/fs/jfs/jfs_dmap.c
> @@ -98,6 +98,8 @@ static int blkstol2(s64 nb);
>  static int cntlz(u32 value);
>  static int cnttz(u32 word);
>  
> +static int dbValidateDmap(struct dmap *dp, s64 dmap_blkno);
> +
>  static int dbAllocDmapBU(struct bmap * bmp, struct dmap * dp, s64 blkno,
>  			 int nblocks);
>  static int dbInitDmap(struct dmap * dp, s64 blkno, int nblocks);
> @@ -476,6 +478,13 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
>  		}
>  		dp = (struct dmap *) mp->data;
>  
> +		if (dbValidateDmap(dp, blkno & ~(s64)(BPERDMAP - 1))) {
> +			jfs_error(ip->i_sb, "error in block map\n");
> +			release_metapage(mp);
> +			IREAD_UNLOCK(ipbmap);
> +			return -EIO;
> +		}
> +
>  		/* determine the number of blocks to be freed from
>  		 * this dmap.
>  		 */
> @@ -563,13 +572,20 @@ dbUpdatePMap(struct inode *ipbmap,
>  				write_metapage(mp);
>  			}
>  
> -			mp = read_metapage(bmp->db_ipbmap, lblkno, PSIZE,
> -					   0);
> +			mp = read_metapage(bmp->db_ipbmap, lblkno, PSIZE, 0);
>  			if (mp == NULL)
>  				return -EIO;
>  			metapage_wait_for_io(mp);
> -		}
> -		dp = (struct dmap *) mp->data;
> +
> +			dp = (struct dmap *)mp->data;
> +
> +			if (dbValidateDmap(dp, blkno & ~(s64)(BPERDMAP - 1))) {
> +				jfs_error(ipbmap->i_sb, "error in block map\n");
> +				release_metapage(mp);
> +				return -EIO;
> +			}
> +		} else
> +			dp = (struct dmap *)mp->data;
>  
>  		/* determine the bit number and word within the dmap of
>  		 * the starting block.  also determine how many blocks
> @@ -884,7 +900,13 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks, s64 * results)
>  		if (mp == NULL)
>  			goto read_unlock;
>  
> -		dp = (struct dmap *) mp->data;
> +		dp = (struct dmap *)mp->data;
> +
> +		if (dbValidateDmap(dp, blkno & ~(s64)(BPERDMAP - 1))) {
> +			jfs_error(ip->i_sb, "error in block map\n");
> +			release_metapage(mp);
> +			goto read_unlock;
> +		}
>  
>  		/* first, try to satisfy the allocation request with the
>  		 * blocks beginning at the hint.
> @@ -1118,6 +1140,13 @@ static int dbExtend(struct inode *ip, s64 blkno, s64 nblocks, s64 addnblocks)
>  
>  	dp = (struct dmap *) mp->data;
>  
> +	if (dbValidateDmap(dp, extblkno & ~(s64)(BPERDMAP - 1))) {
> +		jfs_error(ip->i_sb, "error in block map\n");
> +		release_metapage(mp);
> +		IREAD_UNLOCK(ipbmap);
> +		return -EIO;
> +	}
> +
>  	/* try to allocate the blocks immediately following the
>  	 * current allocation.
>  	 */
> @@ -1900,7 +1929,13 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
>  		mp = read_metapage(bmp->db_ipbmap, lblkno, PSIZE, 0);
>  		if (mp == NULL)
>  			return -EIO;
> -		dp = (struct dmap *) mp->data;
> +		dp = (struct dmap *)mp->data;
> +
> +		if (dbValidateDmap(dp, blkno & ~(s64)(BPERDMAP - 1))) {
> +			jfs_error(bmp->db_ipbmap->i_sb, "error in block map\n");
> +			release_metapage(mp);
> +			return -EIO;
> +		}
>  
>  		if (dp->tree.budmin < 0) {
>  			release_metapage(mp);
> @@ -1934,7 +1969,14 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
>  			rc = -EIO;
>  			goto backout;
>  		}
> -		dp = (struct dmap *) mp->data;
> +		dp = (struct dmap *)mp->data;
> +
> +		if (dbValidateDmap(dp, b & ~(s64)(BPERDMAP - 1))) {
> +			jfs_error(bmp->db_ipbmap->i_sb, "error in block map\n");
> +			release_metapage(mp);
> +			rc = -EIO;
> +			goto backout;
> +		}
>  
>  		/* the dmap better be all free.
>  		 */
> @@ -1973,12 +2015,11 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
>  	 * we fail in backing out the allocation, we'll mark the file
>  	 * system to indicate that blocks have been leaked.
>  	 */
> -      backout:
> +backout:
>  
>  	/* try to backout the allocations dmap by dmap.
>  	 */
> -	for (n = nblocks - n, b = blkno; n > 0;
> -	     n -= BPERDMAP, b += BPERDMAP) {
> +	for (n = nblocks - n, b = blkno; n > 0; n -= BPERDMAP, b += BPERDMAP) {
>  		/* get the buffer for this dmap.
>  		 */
>  		lblkno = BLKTODMAP(b, bmp->db_l2nbperpage);
> @@ -1991,7 +2032,13 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
>  				  "I/O Error: Block Leakage\n");
>  			continue;
>  		}
> -		dp = (struct dmap *) mp->data;
> +		dp = (struct dmap *)mp->data;
> +
> +		if (dbValidateDmap(dp, b & ~(s64)(BPERDMAP - 1))) {
> +			jfs_error(bmp->db_ipbmap->i_sb, "error in block map\n");
> +			release_metapage(mp);
> +			continue;
> +		}
>  
>  		/* free the blocks is this dmap.
>  		 */
> @@ -2134,6 +2181,34 @@ static int dbAllocDmap(struct bmap * bmp, struct dmap * dp, s64 blkno,
>  	return (rc);
>  }
>  
> +static int dbValidateDmap(struct dmap *dp, s64 dmap_blkno)
> +{
> +	struct dmaptree *tp = &dp->tree;
> +
> +	if (le32_to_cpu(dp->nblocks) == 0 ||
> +	    le32_to_cpu(dp->nblocks) > BPERDMAP)
> +		return -EIO;
> +
> +	if (le32_to_cpu(dp->nfree) > le32_to_cpu(dp->nblocks))
> +		return -EIO;
> +
> +	if (le64_to_cpu(dp->start) != dmap_blkno)
> +		return -EIO;
> +
> +	if (le32_to_cpu(tp->nleafs) != LPERDMAP ||
> +	    le32_to_cpu(tp->l2nleafs) != L2LPERDMAP ||
> +	    le32_to_cpu(tp->leafidx) != LEAFIND ||
> +	    le32_to_cpu(tp->height) != 4 || tp->budmin != BUDMIN)
> +		return -EIO;
> +
> +	if (tp->stree[ROOT] < NOFREE || tp->stree[ROOT] > L2BPERDMAP)
> +		return -EIO;
> +
> +	if (le32_to_cpu(dp->nfree) == 0 && tp->stree[ROOT] != NOFREE)
> +		return -EIO;
> +
> +	return 0;
> +}
>  
>  /*
>   * NAME:	dbFreeDmap()
> @@ -3308,6 +3383,13 @@ int dbAllocBottomUp(struct inode *ip, s64 blkno, s64 nblocks)
>  		}
>  		dp = (struct dmap *) mp->data;
>  
> +		if (dbValidateDmap(dp, blkno & ~(s64)(BPERDMAP - 1))) {
> +			jfs_error(ip->i_sb, "error in block map\n");
> +			release_metapage(mp);
> +			IREAD_UNLOCK(ipbmap);
> +			return -EIO;
> +		}
> +
>  		/* determine the number of blocks to be allocated from
>  		 * this dmap.
>  		 */
> @@ -3643,22 +3725,33 @@ int dbExtendFS(struct inode *ipbmap, s64 blkno,	s64 nblocks)
>  				 */
>  				if ((n = blkno & (BPERDMAP - 1))) {
>  					/* read in dmap page: */
> -					mp = read_metapage(ipbmap, p,
> -							   PSIZE, 0);
> +					mp = read_metapage(ipbmap, p, PSIZE, 0);
>  					if (mp == NULL)
>  						goto errout;
> +
> +					dp = (struct dmap *)mp->data;
> +					if (dbValidateDmap(
> +						    dp,
> +						    blkno & ~(s64)(BPERDMAP -
> +								   1))) {
> +						jfs_error(
> +							ipbmap->i_sb,
> +							"error in block map\n");
> +						release_metapage(mp);
> +						goto errout;
> +					}
> +
>  					n = min(nblocks, (s64)BPERDMAP - n);
>  				} else {
>  					/* assign/init dmap page */
> -					mp = read_metapage(ipbmap, p,
> -							   PSIZE, 0);
> +					mp = read_metapage(ipbmap, p, PSIZE, 0);
>  					if (mp == NULL)
>  						goto errout;
>  
> +					dp = (struct dmap *)mp->data;
>  					n = min_t(s64, nblocks, BPERDMAP);
>  				}
>  
> -				dp = (struct dmap *) mp->data;
>  				*l0leaf = dbInitDmap(dp, blkno, n);
>  
>  				bmp->db_nfree += n;
> diff --git a/fs/jfs/jfs_dtree.c b/fs/jfs/jfs_dtree.c
> index 8ce6e4458..d89bda9ee 100644
> --- a/fs/jfs/jfs_dtree.c
> +++ b/fs/jfs/jfs_dtree.c
> @@ -3773,7 +3773,6 @@ static void dtInsertEntry(dtpage_t * p, int index, struct component_name * key,
>  	++p->header.nextindex;
>  }
>  
> -
>  /*
>   *	dtMoveEntry()
>   *
> diff --git a/fs/jfs/jfs_xtree.c b/fs/jfs/jfs_xtree.c
> index 28c3cf960..859439d57 100644
> --- a/fs/jfs/jfs_xtree.c
> +++ b/fs/jfs/jfs_xtree.c
> @@ -1730,10 +1730,10 @@ int xtUpdate(tid_t tid, struct inode *ip, xad_t * nxad)
>  		if (IS_ERR(p))
>  			return PTR_ERR(p);
>  		/*
> -		 * if leaf root has been split, original root has been
> -		 * copied to new child page, i.e., original entry now
> -		 * resides on the new child page;
> -		 */
> +			 * if leaf root has been split, original root has been
> +			 * copied to new child page, i.e., original entry now
> +			 * resides on the new child page;
> +			 */
>  		if (p->header.flag & BT_INTERNAL) {
>  			ASSERT(p->header.nextindex ==
>  			       cpu_to_le16(XTENTRYSTART + 1));
> @@ -2310,8 +2310,8 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
>  		goto getChild;
>  
>  	/*
> -	 *	leaf page
> -	 */
> +		 *	leaf page
> +		 */
>  	freed = 0;
>  
>  	/* does region covered by leaf page precede Teof ? */
> @@ -2605,8 +2605,8 @@ s64 xtTruncate(tid_t tid, struct inode *ip, s64 newsize, int flag)
>  	}
>  
>  	/*
> -	 * parent page become empty: free the page
> -	 */
> +		 * parent page become empty: free the page
> +		 */
>  	if (index == XTENTRYSTART) {
>  		if (log) {	/* COMMIT_PWMAP */
>  			/* txCommit() with tlckFREE:
> 
> 
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> -- 
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
> 
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
