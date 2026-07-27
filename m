Received: from mail-wm1-f48.google.com (mail-wm1-f48.google.com [209.85.128.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B49FA3B4E95
	for <syzbot@lists.linux.dev>; Mon, 27 Jul 2026 16:56:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785171389; cv=none; b=hGeMrZigB8kg2Dvyt2AIlHorgBOK+vLAKYGZOAMBPPRu90+M4pV2HxxMkkvRYuxRdBrbSIbKy/lRc58LcjRz1HLCBsa0xCvE3IreJUFwiVNEXUZqhcbNkVTCij15RI1ETCnMa5d5cRx848HFKzijMmDEgxWBahcTRoakuRe8Lts=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785171389; c=relaxed/simple;
	bh=lKOaijUxlQfX7/XAqmhaiD+xnfJkE+YW2KBhrdFk9iA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=l8iTtY7eoeywSdaaRlrsAIt4fToNawi1kYHsCQ2AqshgZY+8JtdOwmgDS38G7c5QNQuTeYjzYsdPptjnJe5OlntPhQ62oMm/X1wRZj5omo4cQJsutCh2l+poLfsedKslOYyRRdkiIh86OmUFWWtXOil4cCVGbCnFSASK7BVa524=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=prziaF6I; arc=none smtp.client-ip=209.85.128.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="prziaF6I"
Received: by mail-wm1-f48.google.com with SMTP id 5b1f17b1804b1-49545ba3d4eso17395635e9.3
        for <syzbot@lists.linux.dev>; Mon, 27 Jul 2026 09:56:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785171386; x=1785776186; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ql2jP+0b5ihOx780F/mldKU1sg9/Fd3hVg6l3QL7Auo=;
        b=prziaF6IQdNCTShhPKFZzvSY2ROUtJyyZ/BE9fhzNUq76c9VxpOTO0QrJox3KD0SVG
         J8qCc2qWqeREZIW6mLXqx5GEngX0wFWqLmrbEMv4WkC3yS79rrOMVaN2UA21xPse9rQ9
         Dgcnh+3ZJHlmVq4mVcRdkS4ptpYfQh3xXK+LZZv4REnQZx1hQH5H1yJ+puJUrRdQqZ0b
         mYGKwY0KPRhh4nrZEzKKGc3ciaQUCHudpNc8T1XCi93QgZBoKvs8iHm8IYc7Q3cdTZod
         hIYUPSvKQmu8zWUoMdddjzBXMHxjbFoQdmXLR43AUhXvxBkw9Gi6iq6bqy+d1JC5ilve
         TKxQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785171386; x=1785776186;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ql2jP+0b5ihOx780F/mldKU1sg9/Fd3hVg6l3QL7Auo=;
        b=oSb7Suz6MnQxpTgCZQ1gui1YS2r4L72C23FeuXpTrDgs9lvGWhtuOPmIPhp88LKEkb
         Flyappm7JnqRvQ28Kp60aYfcZ9ynasij27Kdr81sCrUA2zMkpWniJMYuitiKdh/9CNLk
         SrXgTLvXHeu1esVohaacoXVehghBLrx0CyPmC87UbK4CqTItjxBexuWqOXZT6me44V+T
         NUgdujJMPZ1QUwSxw1pkiqksuoSbMyS91MQ2W7NiqOMUlCTf87sembCa9OWfK3cpgiA5
         H/KwuXEtCSLOfzfWdTroCSGiHCy1Tcg7zRhAfvxWWsTyz3IlZGgMVSUVr1pSWc0PLDUl
         vieA==
X-Forwarded-Encrypted: i=1; AHgh+Ro77c1PtF4mz8ImQ6vtV9jkrAgksH6qvFvIsClRp08f0TIoT14pNTCiwzFuMm6NibbyluNxk1E=@lists.linux.dev
X-Gm-Message-State: AOJu0YylPg//XAJjtzda0xr7Na5jX9YxHvzY+bk4BDa+Dk7lWTnMiXs+
	d0mg4JuaRsqegBqUCfJmtKhGGlm+bFDhfPP0MDJM7iMI24kC5SGcOoCH
X-Gm-Gg: AR+sD12bTKLxsdtSKov1flLKcitVDLqaxvrFjThtM48a5UbtSr9NY17bDdgboleX9ST
	wUn2Ouow+NAJjeCNHDIr9Zye15g7W8vB3dPTFttjoeojhUta+zwzxEan6XlBbDv2FXW/s2lpKNF
	Wr8HmUtInkqnniK27ZoJf0wLKkY/JtSyebxDv/7GkwMWgXw7FLgajma7pK8bpK68X4HZuiTGmM0
	eBwz28tXNy00yMNDoCZDk8C9foEu8ZDh/ZMUEFOMUItufaFrJq0bIzi8AuDnOkfbnjcUsTQ15RD
	g0aGURjLA0GR1CEP/jz14HQbBAbsO5lwhNWDJkWBLnervoyxZBmr04m5iAKx7A2LlJUxlONn8+x
	uNtiqKlAc5ucjCNljmd6Nxc2riTYW9QBnFn6xkEcf6c3Mgfb/7C6oPjqPL1MpVgx8Dtrlh12XBq
	koX8TeKIOPq4/lklkmsPc99jLumyZCFv04rSm170Q=
X-Received: by 2002:a05:600c:255:b0:495:3e08:ad24 with SMTP id 5b1f17b1804b1-496c3a62dccmr12367595e9.33.1785171385785;
        Mon, 27 Jul 2026 09:56:25 -0700 (PDT)
Received: from localhost ([37.30.44.117])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-496c45cb67esm6168565e9.8.2026.07.27.09.56.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2026 09:56:25 -0700 (PDT)
Date: Mon, 27 Jul 2026 18:56:24 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v3] jfs: validate dmap start before block map
 operations
Message-ID: <j446ponu3rdh3cc57g3c645jzi6pl2ltishbun4mcqtcmvuuxj@4qrihlhaxm4b>
References: <7c3c4fb4-ccbd-486f-b087-6074364ee206@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <7c3c4fb4-ccbd-486f-b087-6074364ee206@mail.kernel.org>

The v3 expected-start check is at the right boundary and most of the v2
review points are addressed. The exact-base comparison is inconclusive: the
reported crash appeared in none of four unpatched VMs and none of four
patched VMs. The patch is not ready because dbAllocCtl() replaces an
independent negative-budmin rejection with the narrower helper.

In the single-dmap branch, preserve both invariants. Reject the page when
dp->tree.budmin < 0, and also reject it when dbValidateDmap() reports an
unexpected start. A page can have the expected start and still carry invalid
negative tree geometry; v3 lets that page reach dbAllocDmapLev() even though
the base code rejects it.

Keep dbValidateDmap() focused on expected-start equality. The boolean
contract, fail-closed -EIO handling, balanced metapage releases, narrowed
description, omitted initial-import Fixes: tag, and removal of unrelated
source changes are all improvements over v2.

For v4:

- restore the dp->tree.budmin < 0 guard alongside dbValidateDmap();
- mention preservation of that independent geometry check in the description;
- fix the strict checkpatch CamelCase and cast-spacing checks;
- rerun the malformed-image check and show that both a mismatched start and a
  negative budmin fail with -EIO before allocation reaches txLock().

This remains a focused correction to the v3 implementation. Changing txLock()
or replacing the expected-start design is unnecessary.

On Fri, Jul 24, 2026 at 07:19:00PM +0000, syzbot wrote:
> A corrupted JFS filesystem image can cause a state where the block
> allocation map (bmap) and the dmap pages are out of sync. Specifically, if
> a dmap page's `dp->start` is corrupted, it can lead to a mismatch during
> block allocation or update operations. The block allocator calculates the
> returned block number based on `dp->start` (i.e., `dp->start +
> block_index`), while the bitmap update is derived from the block's relative
> position within the dmap. If `dp->start` does not match the expected start
> block number for that dmap's position in the bmap, the allocator may return
> a block number that is already in use (e.g., as an inode table block or
> metadata), while marking a completely different block as allocated. This
> mismatch leads to duplicate allocations. When a thread later attempts to
> lock this duplicate block (for example, during a directory btree split),
> `txLock()` detects a metapage conflict because the block is already locked
> for another purpose, triggering a kernel BUG:
> 
> kernel BUG at fs/jfs/jfs_txnmgr.c:836!
> Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
> RIP: 0010:txLock+0x1cc3/0x1d10 fs/jfs/jfs_txnmgr.c:836
> Call Trace:
>  <TASK>
>  dtSplitRoot+0x38d/0x18a0 fs/jfs/jfs_dtree.c:1924
>  dtSplitUp fs/jfs/jfs_dtree.c:990 [inline]
>  dtInsert+0xeb2/0x5890 fs/jfs/jfs_dtree.c:868
>  jfs_create+0x730/0xae0 fs/jfs/namei.c:138
>  vfs_create+0x2c4/0x450 fs/namei.c:4202
>  filename_mknodat+0x3e8/0x660 fs/namei.c:5181
> ...
> 
> To fix this, validate that the `dp->start` of the dmap page matches the
> expected start block number before performing block map operations.
> Rejecting a mismatched start with `-EIO` prevents duplicate allocations
> before `txLock()` is reached.
> 
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+a843f6ae2130a987d63b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a843f6ae2130a987d63b
> Link: https://syzkaller.appspot.com/ai_job?id=bdbf4b4d-3729-479d-89c3-0cee1fcde974
> To: <jfs-discussion@lists.sourceforge.net>
> To: "Dave Kleikamp" <shaggy@kernel.org>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Yun Zhou" <yun.zhou@windriver.com>
> Cc: "Zheng Yu" <zheng.yu@northwestern.edu>
> 
> ---
> v3:
> - Renamed the patch to "jfs: validate dmap start before block map operations".
> - Simplified dbValidateDmap() to only validate that the dmap dp->start matches the expected start block number, removing unproven integrity checks.
> - Updated the commit description to explain the exact root cause of the selection/update mismatch and how validating dp->start prevents duplicate allocations before txLock() is reached.
> 
> v2:
> - Replaced the approach of propagating errors from txLock() with proactive dmap validation.
> - Introduced dbValidateDmap() to check dmap page integrity (nblocks, nfree, start address, and tree structure).
> - Integrated dmap validation into dbFree(), dbUpdatePMap(), dbAlloc(), dbExtend(), dbAllocCtl(), dbAllocBottomUp(), and dbExtendFS().
> - Reverted return type changes for functions in jfs_dtree.c and jfs_xtree.c from the previous version.
> https://lore.kernel.org/all/ff86d803-d687-48f6-9cc2-f3d35b27a666@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/9d2eba88-93bf-4f3c-a3b2-b554e1fffe80@mail.kernel.org/T/
> ---
> diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
> index a841cf21d..f15954c1f 100644
> --- a/fs/jfs/jfs_dmap.c
> +++ b/fs/jfs/jfs_dmap.c
> @@ -98,6 +98,9 @@ static int blkstol2(s64 nb);
>  static int cntlz(u32 value);
>  static int cnttz(u32 word);
>  
> +static bool dbValidateDmap(struct super_block *sb, const struct dmap *dp,
> +			   s64 expected_start);
> +
>  static int dbAllocDmapBU(struct bmap * bmp, struct dmap * dp, s64 blkno,
>  			 int nblocks);
>  static int dbInitDmap(struct dmap * dp, s64 blkno, int nblocks);
> @@ -476,6 +479,12 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
>  		}
>  		dp = (struct dmap *) mp->data;
>  
> +		if (!dbValidateDmap(ip->i_sb, dp, blkno & ~(s64)(BPERDMAP - 1))) {
> +			release_metapage(mp);
> +			IREAD_UNLOCK(ipbmap);
> +			return -EIO;
> +		}
> +
>  		/* determine the number of blocks to be freed from
>  		 * this dmap.
>  		 */
> @@ -568,6 +577,13 @@ dbUpdatePMap(struct inode *ipbmap,
>  			if (mp == NULL)
>  				return -EIO;
>  			metapage_wait_for_io(mp);
> +
> +			if (!dbValidateDmap(ipbmap->i_sb,
> +					    (struct dmap *) mp->data,
> +					    blkno & ~(s64)(BPERDMAP - 1))) {
> +				release_metapage(mp);
> +				return -EIO;
> +			}
>  		}
>  		dp = (struct dmap *) mp->data;
>  
> @@ -886,6 +902,11 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks, s64 * results)
>  
>  		dp = (struct dmap *) mp->data;
>  
> +		if (!dbValidateDmap(ip->i_sb, dp, blkno & ~(s64)(BPERDMAP - 1))) {
> +			release_metapage(mp);
> +			goto read_unlock;
> +		}
> +
>  		/* first, try to satisfy the allocation request with the
>  		 * blocks beginning at the hint.
>  		 */
> @@ -1118,6 +1139,12 @@ static int dbExtend(struct inode *ip, s64 blkno, s64 nblocks, s64 addnblocks)
>  
>  	dp = (struct dmap *) mp->data;
>  
> +	if (!dbValidateDmap(ip->i_sb, dp, extblkno & ~(s64)(BPERDMAP - 1))) {
> +		release_metapage(mp);
> +		IREAD_UNLOCK(ipbmap);
> +		return -EIO;
> +	}
> +
>  	/* try to allocate the blocks immediately following the
>  	 * current allocation.
>  	 */
> @@ -1902,7 +1929,7 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
>  			return -EIO;
>  		dp = (struct dmap *) mp->data;
>  
> -		if (dp->tree.budmin < 0) {
> +		if (!dbValidateDmap(bmp->db_ipbmap->i_sb, dp, blkno & ~(s64)(BPERDMAP - 1))) {
>  			release_metapage(mp);
>  			return -EIO;
>  		}
> @@ -1936,6 +1963,12 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
>  		}
>  		dp = (struct dmap *) mp->data;
>  
> +		if (!dbValidateDmap(bmp->db_ipbmap->i_sb, dp, b & ~(s64)(BPERDMAP - 1))) {
> +			release_metapage(mp);
> +			rc = -EIO;
> +			goto backout;
> +		}
> +
>  		/* the dmap better be all free.
>  		 */
>  		if (dp->tree.stree[ROOT] != L2BPERDMAP) {
> @@ -1993,6 +2026,11 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
>  		}
>  		dp = (struct dmap *) mp->data;
>  
> +		if (!dbValidateDmap(bmp->db_ipbmap->i_sb, dp, b & ~(s64)(BPERDMAP - 1))) {
> +			release_metapage(mp);
> +			continue;
> +		}
> +
>  		/* free the blocks is this dmap.
>  		 */
>  		if (dbFreeDmap(bmp, dp, b, BPERDMAP)) {
> @@ -2134,6 +2172,18 @@ static int dbAllocDmap(struct bmap * bmp, struct dmap * dp, s64 blkno,
>  	return (rc);
>  }
>  
> +static bool dbValidateDmap(struct super_block *sb, const struct dmap *dp,
> +			   s64 expected_start)
> +{
> +	if (le64_to_cpu(dp->start) != expected_start) {
> +		jfs_error(sb, "corrupt dmap page: start %lld expected %lld\n",
> +			  (long long)le64_to_cpu(dp->start),
> +			  (long long)expected_start);
> +		return false;
> +	}
> +
> +	return true;
> +}
>  
>  /*
>   * NAME:	dbFreeDmap()
> @@ -3308,6 +3358,12 @@ int dbAllocBottomUp(struct inode *ip, s64 blkno, s64 nblocks)
>  		}
>  		dp = (struct dmap *) mp->data;
>  
> +		if (!dbValidateDmap(ip->i_sb, dp, blkno & ~(s64)(BPERDMAP - 1))) {
> +			release_metapage(mp);
> +			IREAD_UNLOCK(ipbmap);
> +			return -EIO;
> +		}
> +
>  		/* determine the number of blocks to be allocated from
>  		 * this dmap.
>  		 */
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
