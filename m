Received: from mail-ed2-f39.google.com (mail-ed2-f39.google.com [74.125.228.103])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26F06384CE5
	for <syzbot@lists.linux.dev>; Wed, 30 Sep 2026 10:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.103
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790763811; cv=none; b=d0FtcWtGnpa1dtqrpVxVlQuydGKzrjy66tVfqP2l+kx/8Qak6H78fXNqDEmgpHV2LEVrlFkof+8a5UUjc8adHfIeLvG6vR+Rkow7zyoGkrzozxAkw/VoB+IgbOutzNV3pFLfsN09twMrawoV7i9VZsIizA93IfSW/XJgfRk79QE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790763811; c=relaxed/simple;
	bh=PwJrA4TNZf5ZB7GX5/8J4HUwkZasSRxGiP5Wn5u4u0s=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Z4f+OA2xQgYfBX+JBfPV+uKqtkiIM5GYqliCeVoO48KrYo4/lv5l2ZLmd0C+ULIHTiNeHwH8Mfd1s9NY5lWFbAcx3ksioWBElpxIos3RKJDuDlTN7gtMHMyjSizN5R82332qGq6ReVnnxO56u+CbbqbXitYKGGfwzl6i6IY2nG4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=K52C+qk0; arc=none smtp.client-ip=74.125.228.103
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="K52C+qk0"
Received: by mail-ed2-f39.google.com with SMTP id 4fb4d7f45d1cf-6aa0ee64afdso6236542a12.0
        for <syzbot@lists.linux.dev>; Wed, 30 Sep 2026 03:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790763807; x=1791368607; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gbhyZvahZ1Ao9FzhkqGCyXWKYFYuFxbuMQ59516QXL8=;
        b=K52C+qk0AdnjgxPh5LPBKCEe6y8PGJB5BJEw7LHdXOh0fnpI6hILm5Vqu3qc7heIN+
         3W4jUrXdmk8DBTMoGsBccLVvD7b/8ihO5htq3o6FeoNt1n93d6q6ko9GGNPild1ENxBO
         W/X339LNKO/GqJjhXDUKO48G8n8H6dlzT2fAKYdmRHRZ0iTpcR2JUY+x7o1YOBPii1sH
         i+zSXvjbkwAbwndaDnx42HlCjb5b8rwTkigIu66d8cW0gKguqsnqqA9zAIwDuFe4onFq
         rpq3elVKTMuorvEGdNKqviXatvb5pNSy3zUAeJwNwvoeFkUPKvAt3nlEYhZVjQuhmyXM
         3U8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790763807; x=1791368607;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gbhyZvahZ1Ao9FzhkqGCyXWKYFYuFxbuMQ59516QXL8=;
        b=zjF6Xe0XMter7O3aONREyl8e65NRQSg0tUxKTaw3+dD311c/yujRuEj/sgcQQ20+lw
         u0Orm9MKFNr7MfETJwGrJYuiwv22w2tfWQXqO03TLnFpUfw2O1xHrNpE9qNaSbhzx2MG
         0fuPktWU1AtfqptUT44nJGmnaJL/ANr+Elqnh0Fr/ihXxcpM3fgcDigL9CGxs7+Q7oMg
         jb9tPHErcChQTIO2g1RSibeYTnvvhLOiGPWtnTWCncOa3lj5v3Z8y+TyTSCmYZWA8Kox
         KaTYZJ71EHpLAg9xd+NDM1jgvAtlX35PYn/AgW3Jy78yPgF7fgpb+WTjdPxgbdX/23OW
         SMhg==
X-Forwarded-Encrypted: i=1; AKwUvBxhvKRGWUXqesHfLLbAXxcCx3jOCF19rAOQF6HC5LVL1kKks+lzE+S81amCWnoeeCzkWtxHG8Y=@lists.linux.dev
X-Gm-Message-State: AFq9FYIQGgMJwqtEMM6RMVhcsvWs/ut1DkqgcprLvTmfT1jaj9PumP/K
	vwJ8IL2DcK7diMTo0UmJ4RvqQeZqgKFaz08oPeotjuTbO7fq0B3XML/SH/yVvQ==
X-Gm-Gg: AYBFou1WQQDJzBR1Gq9IxVq+25vCCsRY33xLhb0/hjLP/M11cexmOaV9phcXGv0Ag9M
	YdpK+eMYbSpvkGpXx0lgE6J6lAejIqMD+eRnTKVl2N7+hVsIWNgnxRsp+nQX8+29rXe1OOet0rg
	U39ZKyBSkMLy6Kdo06S6+dc8brN43llYEOI/4ybfYiYbKWwpTvae9vzEJIG+Uzl9GWxhuGSQzBj
	jvCdJJTrmDENZt2mPqNgGIj62zjdRP3IxBglDDTVEmeNwr2nYO9KhxhVKC0ix0BS5GL6ypn2ff9
	H4SjbqMR8vfqqBeuSZZpfYNu/sgi9XQq5yuc8kR+aBB3Mr3U17SF3iu86+mXOlgPKhaXeH55HTF
	W7l7Vev0IW4Pmd7F9zb6MGjZC+Y2qD45FQx5FJHKxshqtWkzHvEicfpLV2exDPKGdKDgorbCuQi
	m9FhhTCLGMcMp8GGsMVaV0TkmpwoSy1ldlpadad0zvhu0rFfmYZdeN/FYpbokTP8ja59+s/iTwa
	tAfPoq1M1tlom1RIVpOXu9D
X-Received: by 2002:a05:6402:46cf:b0:6aa:734b:1a2c with SMTP id 4fb4d7f45d1cf-6ae19980ac7mr617928a12.38.1790763807126;
        Wed, 30 Sep 2026 03:23:27 -0700 (PDT)
Received: from localhost ([37.30.46.119])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ae1539561esm577021a12.13.2026.09.30.03.23.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 30 Sep 2026 03:23:26 -0700 (PDT)
Date: Wed, 30 Sep 2026 12:23:25 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v7] jfs: validate dmap start before block allocation
Message-ID: <bg4ifevb7w655ueedkeml7wlhqxtu26sx5nbctn2nxnnoe3wwx@ycbmne2llpnx>
References: <eca72bbc-04a2-43f9-a17f-2dfc408b009b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eca72bbc-04a2-43f9-a17f-2dfc408b009b@mail.kernel.org>

#syz upstream

On Fri, Sep 25, 2026 at 06:55:35PM +0000, syzbot wrote:
> A corrupted JFS filesystem image can cause a state where the block
> allocation map (bmap) and the dmap pages are out of sync. Specifically,
> dbAllocNear() and dbAllocDmapLev() derive the returned block number from
> on-disk dp->start, which can cause duplicate allocation if dp->start does
> not match the selected dmap boundary. In this scenario, the allocator
> returns a block number that is already in use (e.g., as an inode table
> block or metadata) while marking a completely different block as allocated.
> When a thread later attempts to lock this duplicate block (for example,
> during a directory btree split), txLock() detects a metapage conflict
> because the block is already locked for another purpose, triggering a
> kernel BUG:
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
> Validation of dp->start against the expected dmap boundary in dbAlloc() and
> the single-dmap path of dbAllocCtl() prevents inconsistent allocation.
> Rejecting a mismatched start with -EIO prevents duplicate allocations
> before txLock() is reached. Additionally, preserve the existing independent
> geometry check (dp->tree.budmin < 0) in dbAllocCtl(). Both a mismatched
> start and a negative budmin will now fail with -EIO early, preventing
> corrupted dmap structures from causing duplicate allocations and subsequent
> transaction lock crashes.
> 
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+a843f6ae2130a987d63b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a843f6ae2130a987d63b
> Link: https://syzkaller.appspot.com/ai_job?id=922ceb61-4be2-4af9-b2fe-9977a2549134
> To: <jfs-discussion@lists.sourceforge.net>
> To: "Dave Kleikamp" <shaggy@kernel.org>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Yun Zhou" <yun.zhou@windriver.com>
> 
> ---
> v7:
> - Update commit description to explain that dbAllocNear() and dbAllocDmapLev() derive the returned block number from on-disk dp->start and clarify the validation in dbAlloc() and dbAllocCtl().
> 
> v6:
> - Dropped Linus Torvalds from the To/Cc list.
> https://lore.kernel.org/all/a8ef6423-9a58-4396-a030-92690f02f44c@mail.kernel.org/T/
> 
> v5:
> - Narrowed the validation of `dp->start` to only the primary block allocation paths (`dbAlloc` and `dbAllocCtl`).
> - Removed validation checks from `dbFree`, `dbUpdatePMap`, `dbExtend`, `dbAllocBottomUp`, and secondary loops in `dbAllocCtl`.
> https://lore.kernel.org/all/6673d9d2-210e-4870-b355-7826289ab842@mail.kernel.org/T/
> 
> v4:
> - Renamed dbValidateDmap to db_validate_dmap to follow kernel naming conventions.
> - Preserved the existing dp->tree.budmin < 0 check in dbAllocCtl instead of replacing it.
> https://lore.kernel.org/all/d1405703-afc9-40f9-bc57-ddedf66f35da@mail.kernel.org/T/
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
> index a841cf21d..9bdbc55d8 100644
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
> @@ -886,6 +889,12 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks, s64 * results)
>  
>  		dp = (struct dmap *) mp->data;
>  
> +		if (!db_validate_dmap(ip->i_sb, dp,
> +				      blkno & ~(s64)(BPERDMAP - 1))) {
> +			release_metapage(mp);
> +			goto read_unlock;
> +		}
> +
>  		/* first, try to satisfy the allocation request with the
>  		 * blocks beginning at the hint.
>  		 */
> @@ -1902,7 +1911,9 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb, s64 blkno, s64 * results)
>  			return -EIO;
>  		dp = (struct dmap *) mp->data;
>  
> -		if (dp->tree.budmin < 0) {
> +		if (dp->tree.budmin < 0 ||
> +		    !db_validate_dmap(bmp->db_ipbmap->i_sb, dp,
> +				      blkno & ~(s64)(BPERDMAP - 1))) {
>  			release_metapage(mp);
>  			return -EIO;
>  		}
> @@ -2134,6 +2145,18 @@ static int dbAllocDmap(struct bmap * bmp, struct dmap * dp, s64 blkno,
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
