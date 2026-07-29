Received: from mail-wr1-f46.google.com (mail-wr1-f46.google.com [209.85.221.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0883E3AAF7D
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 15:45:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785339943; cv=none; b=n2lobI9KFFWkxHgFfBMF10UA899oNw5cchgq3vXU0peEjwPIeMLVieq1DEARQ2wHUfnNHMiX0OgAGL9R4TzqsHICTZ6yXR77o8PPK5Z2WWSfN/ayY+G8vQN26IqBmGRPYIWc9oez65H0UBYMtVSTAxZSQuQj44jiXjUyojOl1l4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785339943; c=relaxed/simple;
	bh=DJHojELkSstG2WgbL0sa4LZouaXXQHa1XDq2Dy+l3zU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=TfIR1aWeOh3n1kXKT6HtsadBMJe0weCms9LBVgquFAV4bqfBoq7fqvk9EgjWR8ThkXynYMOE8U6WQJPKbiC366RS0J8ci3EnvF01fdXlBEOg5JHn9eWFdxIQ7cVr537ev0WRcyqhj7nCv1kB0xAyaJDMtWDgWjzznue0Ql5mk6U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=A3Kwf1eN; arc=none smtp.client-ip=209.85.221.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="A3Kwf1eN"
Received: by mail-wr1-f46.google.com with SMTP id ffacd0b85a97d-4728c12ba97so766472f8f.0
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 08:45:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785339939; x=1785944739; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GgdOkkiUd9f8EzYDM3/WWfj1sTSW9ut64k2BUV8l/Ss=;
        b=A3Kwf1eNSHsibFCnxnRjKKJjiM/hssUG9/kpD+vkEd6fuBdEv34ejBv1I9yKG6JKSC
         69kpkVL4ElvcVaqEvgl5JVNRVIbXJPg4t4tRRa8O2T1fLQCc2jBxY1hEpLsNySbANIsf
         MydSl5PqumXtGyrBF5dx40nBa/kFhv0VLOCxYuLWPBaJqEAuxA6Vaumg0JpChgVj2Oin
         jmrT8DIoULprl97ADIcgGL3OwBxoO1ZP2sU+C4QiE7WJZUjghT4v8V5yd4h6984/UXJC
         jea9IiEkC1fJqm4CXi759LSwlePS3EEUHt4wPz1rW1z+gd7Beu9TsL0ElQ2FeLwkGlgo
         fuxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785339939; x=1785944739;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=GgdOkkiUd9f8EzYDM3/WWfj1sTSW9ut64k2BUV8l/Ss=;
        b=pKkxZmb50enwQoBTSYICBTM5yiyEgs8qc0Hr5jWMDqxNspBrjmXQaXwvhj3gmaHFOt
         pla2dz8pjEIoWzKyVDhbPpJVqm0LC2zs4A9BRi+2dy+WqW2K29qgHttDohvXnBGR6rTf
         mfKa9W51ND/fpHW6a9Nqd7psAooe77rsrp4hgHqjKAagV6nlTHa9SavudTnhE3fN5df0
         OnSxSPahbEW3btv5jg2zBJdLPbA/lX7aCrN8y0BOZF5UMXcBBGLRCGLfEYZ7kadiqNpE
         vbctx6UAldb9q1QFZ/D3Ft3osTbDck87QFzN85Dbmk+5hBBUJDDGJpa6oeYqlKd6uMJ3
         t8NQ==
X-Forwarded-Encrypted: i=1; AHgh+RrWqTJOXWcPHPCfvfaNGoVIoOlgM1j96gHZcLEL6H0jEk9eD+eCdUPbjOJWkSULk9wLtMumlCA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyaeV1sF+DjFFLHW7sEO4qPCa7Bnq2q99HAaUWfLt+3CrcjkCmf
	gLLeAvnF+wBRmwVod/OoPja/Di9rU+4+Kb9+5rjHlRL/JZM2kLR0hbyB
X-Gm-Gg: AR+sD108FMDuEBCI1ENUqwcvz6P2NBB54o68Kjd0MFv3z02BNPLcTAKkdBTbj+pZ7o5
	03Akyo0frunupwfWLecxyi4Ddx+r1D+76yhggTyUS+0gDxGUZ0/fuPshWq3EOFMB0CAYAAX61IW
	l9lDEG3E6TmFyk3Q2iJaTH7vimzmCqXuAOpsj9vOlCaONTF/J64StBmg9dwOAaZxr03Pp0IzzvL
	kAQL2yziyf+7YDXP3zvTT5LwdEohWTehn5Lo2cHrKrF1TcQ/PUe1Dmmp9njD5f7qyQT9t9WSna6
	TrSXAE5ISqXQaqsoGgJMs1VwOdjMCuhgFeANTC/9U1R3AQTmVhbmlkOpH0LJzRP5kyK08ii+hTt
	m69H5Ru3O/InHO5/wo+ls/qrt/Y6QTJdocY6w9fSKUgqUqPdD81/KVMsmXWfhzkHnykMdyELE8t
	rFJ47mIv3Dkl4rXHD0BtPTsj/gXOgypflxFWsk29B8K6s33HNSmkPQ5DLY5i7KvjEIn4imdYeGs
	yWVkjyDrJrpDPA=
X-Received: by 2002:a05:6000:2586:b0:47f:95e8:2ebf with SMTP id ffacd0b85a97d-47fb1ecc29emr8603474f8f.12.1785339938855;
        Wed, 29 Jul 2026 08:45:38 -0700 (PDT)
Received: from localhost ([37.30.44.117])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6b0f2ddsm8894873f8f.20.2026.07.29.08.45.38
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:45:38 -0700 (PDT)
Date: Wed, 29 Jul 2026 17:45:37 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v4] jfs: validate dmap start before block map
 operations
Message-ID: <tkqyaulre47jjj3ll3t5pst3xdpjcrvdn3e2jdg4tct7pwdmm7@z75nvc36fe7e>
References: <d1405703-afc9-40f9-bc57-ddedf66f35da@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d1405703-afc9-40f9-bc57-ddedf66f35da@mail.kernel.org>

The v4 expected-start predicate and covered error paths are correct, and this
version restores the independent negative-budmin guard and fixes the helper
naming and checkpatch findings. Comparable four-VM testing reproduced the
target crash in 2/4 baseline VMs and 0/4 patched VMs. The patch is still not
ready because its broad call-site set omits the partial-dmap branch in
dbExtendFS().

In that branch, dbInitDmap() preserves the loaded dp->start while extending an
existing partial dmap, and dbExtendFS() later derives the allocation-group
index from that value. Version 4 validates other dmap consumers but not this
one. The no-crash result proves target suppression for the tested image; it
does not make the broader invariant complete.

For v5:

- Prefer the demonstrated narrow fix: keep expected-start validation in
  dbAlloc() and the single-dmap path in dbAllocCtl(), retain the independent
  dp->tree.budmin < 0 rejection, and remove the unrelated broad call sites.
- If broad coverage is retained, validate the existing partial dmap in
  dbExtendFS() before using its start, and add deterministic tests for both a
  matching-start success path and a mismatched-start -EIO path.
- Match the description to the final scope. Keep Fixes: omitted unless a
  first-bad commit is proven, rerun get_maintainer.pl on the final diff, and
  rerun default and strict checkpatch plus the comparable baseline/patched
  reproducer pair.

Changing txLock() or inventing another allocation algorithm is unnecessary.
Keep the next revision on the expected-start boundary above.

On Mon, Jul 27, 2026 at 06:48:37PM +0000, syzbot wrote:
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
> ...
> 
> To fix this, validate that the `dp->start` of the dmap page matches the
> expected start block number before performing block map operations.
> Rejecting a mismatched start with `-EIO` prevents duplicate allocations
> before `txLock()` is reached. Additionally, preserve the existing
> independent geometry check (`dp->tree.budmin < 0`) in `dbAllocCtl()`. Both
> a mismatched start and a negative `budmin` will now fail with `-EIO` early,
> preventing corrupted dmap structures from causing duplicate allocations and
> subsequent transaction lock crashes.
> 
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+a843f6ae2130a987d63b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a843f6ae2130a987d63b
> Link: https://syzkaller.appspot.com/ai_job?id=30db4661-77f8-49bf-8389-8df570488e85
> To: <jfs-discussion@lists.sourceforge.net>
> To: "Dave Kleikamp" <shaggy@kernel.org>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Yun Zhou" <yun.zhou@windriver.com>
> Cc: "Zheng Yu" <zheng.yu@northwestern.edu>
> 
> ---
> v4:
> - Renamed dbValidateDmap to db_validate_dmap to follow kernel naming conventions.
> - Preserved the existing dp->tree.budmin < 0 check in dbAllocCtl instead of replacing it.
> 
> v3:
> - Renamed the patch to "jfs: validate dmap start before block map operations".
> - Simplified dbValidateDmap() to only validate that the dmap dp->start matches the expected start block number, removing unproven integrity checks.
> - Updated the commit description to explain the exact root cause of the selection/update mismatch and how validating dp->start prevents duplicate allocations before txLock() is reached.
> https://lore.kernel.org/all/7c3c4fb4-ccbd-486f-b087-6074364ee206@mail.kernel.org/T/
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
> index a841cf21d..063572456 100644
> --- a/fs/jfs/jfs_dmap.c
> +++ b/fs/jfs/jfs_dmap.c
> @@ -98,6 +98,9 @@ static int blkstol2(s64 nb);
>  static int cntlz(u32 value);
>  static int cnttz(u32 word);
>  
> +static bool db_validate_dmap(struct super_block *sb, const struct dmap *dp,
> +			     s64 expected_start);
> +
>  static int dbAllocDmapBU(struct bmap * bmp, struct dmap * dp, s64 blkno,
>  			 int nblocks);
>  static int dbInitDmap(struct dmap * dp, s64 blkno, int nblocks);
> @@ -476,6 +479,12 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
>  		}
>  		dp = (struct dmap *) mp->data;
>  
> +		if (!db_validate_dmap(ip->i_sb, dp, blkno & ~(s64)(BPERDMAP - 1))) {
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
> +			if (!db_validate_dmap(ipbmap->i_sb,
> +					      (struct dmap *)mp->data,
> +					      blkno & ~(s64)(BPERDMAP - 1))) {
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
> +		if (!db_validate_dmap(ip->i_sb, dp, blkno & ~(s64)(BPERDMAP - 1))) {
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
> +	if (!db_validate_dmap(ip->i_sb, dp, extblkno & ~(s64)(BPERDMAP - 1))) {
> +		release_metapage(mp);
> +		IREAD_UNLOCK(ipbmap);
> +		return -EIO;
> +	}
> +
>  	/* try to allocate the blocks immediately following the
>  	 * current allocation.
>  	 */
> @@ -1902,7 +1929,8 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
>  			return -EIO;
>  		dp = (struct dmap *) mp->data;
>  
> -		if (dp->tree.budmin < 0) {
> +		if (dp->tree.budmin < 0 ||
> +		    !db_validate_dmap(bmp->db_ipbmap->i_sb, dp, blkno & ~(s64)(BPERDMAP - 1))) {
>  			release_metapage(mp);
>  			return -EIO;
>  		}
> @@ -1936,6 +1964,12 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
>  		}
>  		dp = (struct dmap *) mp->data;
>  
> +		if (!db_validate_dmap(bmp->db_ipbmap->i_sb, dp, b & ~(s64)(BPERDMAP - 1))) {
> +			release_metapage(mp);
> +			rc = -EIO;
> +			goto backout;
> +		}
> +
>  		/* the dmap better be all free.
>  		 */
>  		if (dp->tree.stree[ROOT] != L2BPERDMAP) {
> @@ -1993,6 +2027,11 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
>  		}
>  		dp = (struct dmap *) mp->data;
>  
> +		if (!db_validate_dmap(bmp->db_ipbmap->i_sb, dp, b & ~(s64)(BPERDMAP - 1))) {
> +			release_metapage(mp);
> +			continue;
> +		}
> +
>  		/* free the blocks is this dmap.
>  		 */
>  		if (dbFreeDmap(bmp, dp, b, BPERDMAP)) {
> @@ -2134,6 +2173,18 @@ static int dbAllocDmap(struct bmap * bmp, struct dmap * dp, s64 blkno,
>  	return (rc);
>  }
>  
> +static bool db_validate_dmap(struct super_block *sb, const struct dmap *dp,
> +			     s64 expected_start)
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
> @@ -3308,6 +3359,12 @@ int dbAllocBottomUp(struct inode *ip, s64 blkno, s64 nblocks)
>  		}
>  		dp = (struct dmap *) mp->data;
>  
> +		if (!db_validate_dmap(ip->i_sb, dp, blkno & ~(s64)(BPERDMAP - 1))) {
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
