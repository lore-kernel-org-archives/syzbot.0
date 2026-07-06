Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38FBB3EB10B
	for <syzbot@lists.linux.dev>; Mon,  6 Jul 2026 08:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783325962; cv=pass; b=Pbz0WFvTlItbtt14fsQ+QXP2ecGaBv2cJD9Co8BXMYF7NDBaF9jOpOqQ4OwmPEQzbOqPQ0OL2zUVBsOhoNhzGQ/5nYD5jnrEeAAXTMvrSiQVxoLKuqDd1lnYO/KIHbmn3CODO6cSK7AzmfmVFdsHUtOVS8XUMe9LV6NTN0/e2qI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783325962; c=relaxed/simple;
	bh=Zc7Jyo06DlQazanALMpPeJY80TuS2I++RqtBpPsTrgo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rbq57gPL3Ng0G6yW8zTYenHEdHaO+fRWcQNNM8PxsfG8od/4JHmMlX+kwz/FHJ3rbXP1/w6fGGrHuKRVrZqyYBbME2LfOSxYWr+Ef/DcfoR0Q+TxZVNm53BZT0cne8EHKp6GsNXdNDL/kqPnCH2HB0iIe8E/USzRE2x8ZzWEvmo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=anQ1cfKc; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="anQ1cfKc"
Received: by smtp.kernel.org (Postfix)
	id D9E001F00A3A; Mon,  6 Jul 2026 08:19:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.75
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1783325953;
	b=xzfh9xoB4lIYyiNTW1noy1IihN+Nue2Y6XyLBYKj7ASTg/RVMPV+Dsu3MNaC1zGDkRxQ
	 /qrwCHHvK7a/Cp1VFCEvjEt/HivjqTwdybYIkQyawCz1t83ogl+IzPlGVvBqYqJEcjHLF
	 WuZGVdxhP8uRAPV13YDtTqU5uP5HoWosO/ZWnDhf2KEk2IXP1EaJa99P0OOScYZxXAEs9
	 IEk/aKx/9looL1ZOT/qyi2QpDB+O9ZTg8N0peDpILsUiKiPgQZEiZP7X1UQOK0CxAsysA
	 Y9ZabPQqjZG3OQC1o8jTHKYg9o1TeaK4EQYJ0Tvc0wVvHNazHM4PWRlOM9yEue7g9Jw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1783325953;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 X-IPL-Priority-Group:DKIM-Signature;
	bh=JenWvcFsxycqauatH9CObbsDHyaFXlcJSD8FpZGD3+8=;
	b=SAjU24yqMOovL9g60o6LkUe3iHkH0YDd0Fn2YucH3/lZbIJ5hTYncZzW1cktfEsrQJf2
	 9ruU5AiUeR7a873aIoET+r4s9jmDgwd2xkMiKJ9+jD8FUrdO/L2CccZV4MEex5WLfLaqr
	 3fz9WLGQs6iAKOGuEhmws/kL+5tN6GU1T4hagYkhOaaGHy1+S8vE4/knuY27AF4pFPZlE
	 Dy1qg3ZTsdhZczSQU1Ii0lmo1NeiGXBgBfhmhR9NEdhdSW6RS/Jh3OUb3Tp8aGAxKWhaF
	 Q0au6xI1wKgPpElxp13/J9urj/qDFhx9ey1ZhNr3ZhM3ZyZP5NMcCjUeQZxwT0Fnz+w==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=anQ1cfKc;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.75
Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id D15B71F000E9
	for <syzbot@kernel.org>; Mon,  6 Jul 2026 08:19:11 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=anQ1cfKc
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org D15B71F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon,  6 Jul 2026 10:19:02 +0200 (CEST)
Date: Mon, 6 Jul 2026 10:19:00 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] jfs: add dmaptree integrity check to prevent
 array-index-out-of-bounds
Message-ID: <aktk9Fb5l5uBOu9q@nr200>
References: <2cfad14e-3856-4dd8-b464-6b0c1e15b9fb@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2cfad14e-3856-4dd8-b464-6b0c1e15b9fb@mail.kernel.org>
X-IPL-Priority-Group: 0-0
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1783325943; bh=JenWvcFsxycqauatH9CObbsDHyaFXlcJSD8FpZGD3+8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=anQ1cfKc/fFmxRscuyif7nA7VwGfoB6SFJY8MoPcQH6w140Mgz6/STMW8rhd6fqvT
	 7QtB/VrPuZQcvv3xt/+34XuRYFO7GnRV+Te4imoVbI94RbNdp3U/FrbvZya//F2uUd
	 O9R9WEPxaHP2wxy0N5XMK4dWfUCm3eLBI5XS/ghY=

On cze 30, 2026 15:23, syzbot wrote:
> An array-index-out-of-bounds issue occurs in dbJoin() when the JFS
> filesystem attempts to free blocks using a corrupted dmap structure read
> from disk.
> 
> The JFS filesystem uses a binary buddy system to manage free space. The
> state of the buddy system is stored in dmap (for leaf levels) and dmapctl
> (for upper levels) structures on disk. When a dmap is read from disk, its
> dmaptree structure is not fully validated. Specifically, the leafidx field
> (which indicates the index of the first leaf in the stree array) is read
> directly from disk and used to compute pointers to the leaf nodes.
> 
> If leafidx is corrupted (e.g., set to 0xffffffff), the computed pointer
> will point out of bounds of the stree array. When dbFreeDmap() is called to
> free blocks, it calls dbFreeBits(), which in turn calls dbJoin() to update
> the buddy system. dbJoin() uses the corrupted leafidx to access the leaf
> nodes, resulting in an out-of-bounds memory access.
> 
> While a similar integrity check (check_dmapctl()) was recently added for
> dmapctl structures, the dmap structures (dmaptree) were left unchecked.
> 
> Introduce a check_dmaptree() function, similar to the existing
> check_dmapctl() function, to validate the integrity of the dmaptree
> structure when it is used. The function verifies that fields like nleafs,
> l2nleafs, leafidx, height, and budmin are within their expected bounds and
> internally consistent. It also ensures that the leaf nodes fit within the
> stree array and have valid values.
> 
> Call check_dmaptree() at the entry points of functions that operate on the
> dmap structure (dbFreeDmap(), dbAllocNext(), dbAllocNear(),
> dbAllocDmapLev(), dbAllocDmapBU(), and dbAllocDmap()). If the validation
> fails, log an error and return -EIO to prevent further processing of the
> corrupted dmap. This also replaces the existing partial checks for leafidx
> in dbAllocNext() and dbAllocNear().
> 
> UBSAN: array-index-out-of-bounds in fs/jfs/jfs_dmap.c:2867:24
> index 4294967295 is out of range for type 's8[1365]' (aka 'signed
> char[1365]')
> CPU: 0 UID: 0 PID: 123 Comm: jfsCommit Not tainted
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
> 1.16.3-debian-1.16.3-2 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  ubsan_epilogue+0xa/0x30
>  __ubsan_handle_out_of_bounds+0xe8/0xf0
>  dbJoin+0xcc4/0xd60
>  dbFreeBits+0x4a2/0xd70
>  dbFreeDmap
>  dbFree+0x324/0x650
>  txFreeMap+0x9e6/0xde0
>  xtTruncate+0xd16/0x2eb0
>  jfs_free_zero_link+0x35b/0x4c0
>  jfs_evict_inode+0x356/0x430
>  evict+0x624/0xb50
>  txLazyCommit
>  jfs_lazycommit+0x44c/0xac0
>  kthread+0x388/0x470
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.1-pro-preview best-expensive syzbot
> Reported-by: syzbot+667a6d667592227b1452@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=667a6d667592227b1452
> Link: https://syzkaller.appspot.com/ai_job?id=e23ddb38-d666-490d-86a7-4d67edb1eac1
> To: <jfs-discussion@lists.sourceforge.net>
> To: "Dave Kleikamp" <shaggy@kernel.org>
> Cc: "Arnaud Lecomte" <contact@arnaud-lcm.com>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Yun Zhou" <yun.zhou@windriver.com>
> Cc: "Zheng Yu" <zheng.yu@northwestern.edu>
> 
> ---
> diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
> index a841cf21d..4f2e0b78d 100644
> --- a/fs/jfs/jfs_dmap.c
> +++ b/fs/jfs/jfs_dmap.c
> @@ -220,6 +220,85 @@ static bool check_dmapctl(struct dmapctl *dcp)
>  	return true;
>  }
>  
> +/*
> + * check_dmaptree - Validate integrity of a dmaptree structure
> + * @dtp: Pointer to the dmaptree structure to check
> + *
> + * Return: true if valid, false if corrupted
> + */
> +static bool check_dmaptree(struct dmaptree *dtp)
> +{
> +	u32 nleafs, l2nleafs, leafidx, height;
> +	int i;
> +
> +	nleafs = le32_to_cpu(dtp->nleafs);
> +	/* Check basic field ranges */
> +	if (unlikely(nleafs > LPERDMAP)) {
> +		jfs_err("dmaptree: invalid nleafs %u (max %u)", nleafs,
> +			LPERDMAP);
> +		return false;
> +	}
> +
> +	l2nleafs = le32_to_cpu(dtp->l2nleafs);
> +	if (unlikely(l2nleafs > L2LPERDMAP)) {
> +		jfs_err("dmaptree: invalid l2nleafs %u (max %u)", l2nleafs,
> +			L2LPERDMAP);
> +		return false;
> +	}
> +
> +	/* Verify nleafs matches l2nleafs (must be power of two) */
> +	if (unlikely((1U << l2nleafs) != nleafs)) {
> +		jfs_err("dmaptree: nleafs %u != 2^%u", nleafs, l2nleafs);
> +		return false;
> +	}
> +
> +	leafidx = le32_to_cpu(dtp->leafidx);
> +	/* Check leaf index matches expected position */
> +	if (unlikely(leafidx != LEAFIND)) {
> +		jfs_err("dmaptree: invalid leafidx %u (expected %u)", leafidx,
> +			LEAFIND);
> +		return false;
> +	}
> +
> +	height = le32_to_cpu(dtp->height);
> +	/* Check tree height is within valid range */
> +	if (unlikely(height > 4)) {
> +		jfs_err("dmaptree: invalid height %u (max 4)", height);
> +		return false;
> +	}
> +
> +	/* Check budmin is valid */
> +	if (unlikely(dtp->budmin < BUDMIN)) {
> +		jfs_err("dmaptree: invalid budmin %d (min %d)", dtp->budmin,
> +			BUDMIN);
> +		return false;
> +	}
> +
> +	/* Check leaf nodes fit within stree array */
> +	if (unlikely(leafidx + nleafs > TREESIZE)) {
> +		jfs_err("dmaptree: leaf range exceeds stree size (end %u > %u)",
> +			leafidx + nleafs, TREESIZE);
> +		return false;
> +	}
> +
> +	/* Check leaf nodes have valid values */
> +	for (i = leafidx; i < leafidx + nleafs; i++) {
> +		s8 val = dtp->stree[i];
> +
> +		if (unlikely(val < NOFREE)) {
> +			jfs_err("dmaptree: invalid leaf value %d at index %d",
> +				val, i);
> +			return false;
> +		} else if (unlikely(val > 31)) {
> +			jfs_err("dmaptree: leaf value %d too large at index %d",
> +				val, i);
> +			return false;
> +		}
> +	}
> +
> +	return true;
> +}
> +
>  /*
>   * NAME:	dbMount()
>   *
> @@ -1163,7 +1242,7 @@ static int dbAllocNext(struct bmap * bmp, struct dmap * dp, s64 blkno,
>  	s8 *leaf;
>  	u32 mask;
>  
> -	if (dp->tree.leafidx != cpu_to_le32(LEAFIND)) {
> +	if (unlikely(!check_dmaptree(&dp->tree))) {
>  		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
>  		return -EIO;
>  	}
> @@ -1293,7 +1372,7 @@ dbAllocNear(struct bmap * bmp,
>  	int word, lword, rc;
>  	s8 *leaf;
>  
> -	if (dp->tree.leafidx != cpu_to_le32(LEAFIND)) {
> +	if (unlikely(!check_dmaptree(&dp->tree))) {
>  		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
>  		return -EIO;
>  	}
> @@ -2046,6 +2125,11 @@ dbAllocDmapLev(struct bmap * bmp,
>  	s64 blkno;
>  	int leafidx, rc;
>  
> +	if (unlikely(!check_dmaptree(&dp->tree))) {
> +		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
> +		return -EIO;
> +	}
> +
>  	/* can't be more than a dmaps worth of blocks */
>  	assert(l2nb <= L2BPERDMAP);
>  
> @@ -2112,6 +2196,11 @@ static int dbAllocDmap(struct bmap * bmp, struct dmap * dp, s64 blkno,
>  	s8 oldroot;
>  	int rc;
>  
> +	if (unlikely(!check_dmaptree(&dp->tree))) {
> +		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
> +		return -EIO;
> +	}
> +
>  	/* save the current value of the root (i.e. maximum free string)
>  	 * of the dmap tree.
>  	 */
> @@ -2167,6 +2256,11 @@ static int dbFreeDmap(struct bmap * bmp, struct dmap * dp, s64 blkno,
>  	s8 oldroot;
>  	int rc = 0, word;
>  
> +	if (unlikely(!check_dmaptree(&dp->tree))) {
> +		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
> +		return -EIO;
> +	}
> +
>  	/* save the current value of the root (i.e. maximum free string)
>  	 * of the dmap tree.
>  	 */
> @@ -3338,6 +3432,11 @@ static int dbAllocDmapBU(struct bmap * bmp, struct dmap * dp, s64 blkno,
>  	s8 oldroot;
>  	struct dmaptree *tp = (struct dmaptree *) & dp->tree;
>  
> +	if (unlikely(!check_dmaptree(&dp->tree))) {

Pointer to dp->tree is saved to tp on line above. We should use it here.

> +		jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
> +		return -EIO;
> +	}
> +
>  	/* save the current value of the root (i.e. maximum free string)
>  	 * of the dmap tree.
>  	 */
> 
> 
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482

-- 
Slawomir Stepien
