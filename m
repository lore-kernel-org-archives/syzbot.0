Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0F0D26F2A0
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 09:56:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787738198; cv=none; b=Ms51eYoNABlZkik2Yjc5N5s5Md4wIBMHogYOr3PlgoQd6v+5OJLEq4/oYyfc3NGC1dILr3iBYwKvDMsZAsZLcJ4rYxeC0SYS2JF25XYxZPktxZ+xjHqJXC64bsvenBFYgpRXQEQYerYK7DmVPO/SpWY7fxQcxqN+O7eB5GueXZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787738198; c=relaxed/simple;
	bh=9JItL9gMeiUFhWbRs9TDQWQMmSmuuQdxeQdHSKdHpE0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DBJSA+Jp/zHdai1v71PmN7Rsn8nzqeLPZj0e7vLQUdPChFAKyPQTHT09qe7xFxrGQnxzPIQlOJNBNXgtVGy2AgJj/mVV7un3ml5P9rrt1htZ9a+JKfA9/kCMQc6e+W2mM/Yqfv7+UuPVIOPGh/rqp0pzlXB72Rpx4JvWf+riPBM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=tAhcy5Mp; arc=none smtp.client-ip=209.85.218.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="tAhcy5Mp"
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c15d3cd51b2so104448066b.3
        for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 02:56:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1787738195; x=1788342995; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=QcnVsCK3Ft6cqx9+tBHC/eXmpHO6DXnp1CDwVmNfwAQ=;
        b=tAhcy5MpftPwdWKTSpJRGZc4t1SCwRmgkB3wafxjqj/R8Y30JXijAwiL+ks3nNBQT3
         uSJYGy1LT73lhI3cl4wZ7r7pfeTsMB8Qd/vNcOVvtJZ1s5QILxfC4Co8u8YAHsdHPMYK
         grxBTS39/5A6LxPGviZ5qairBr8aN5VBK7bl/VVBG+acAeLHyfzoaCKe/Q/WIuCsoeqp
         YP2kR43N3gB3Qewu8dLgYJoFlFmgak6QV+SZmdqngh8KlYqQUv7CwBSO/ZbjvYB7EZUz
         fRl8TE1FPrfbGOFP1THKzyYZhTer3mJ8SNNnfhfh8Mi1CyK5se2oT2CVP7H/IxuU03Ym
         9YMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787738195; x=1788342995;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=QcnVsCK3Ft6cqx9+tBHC/eXmpHO6DXnp1CDwVmNfwAQ=;
        b=MVz8ssWvkcDhjrz+dEtBNY++jt8LTANVXRR6rCqMpL7FGOvNrw/NUaFaBChI67R+Ee
         hDVwdllBNqQaoyPUHLmKRjDZvUpcEH7XNo909J4xKV1AZll4qa5kwG0qYRuKKCYmRSk+
         lrBH5F5EnrjSm/+dRdjHFfgJaGnCZ01DERLCkkjjrXe6O4RWRFcOlxMkSx56Fb0+iGU7
         INyu17jKW1M6M5Ep+Uj2cI+rtJWFQsPiECrRMUUOChMQz7K2UBoEEh686VJ9Q1RGLzXP
         Z9LHLNFckgtojDjWqyWIQd36kU0Y0p3dTVNkHgr1EdHYayUNveMomTEf0gituoyxqEYV
         mGhQ==
X-Forwarded-Encrypted: i=1; AHgh+RotA0frkHNSHQB6gWBqkCFThY4Q3xkyM5m2sjS2v07BvihGj8EXPkJR3i9pbpWoaT+ZdER08SE=@lists.linux.dev
X-Gm-Message-State: AFuF++kcWoESdZf38cMAc4zeSglVnh0n1gONBQNnUmWk0AanILG5EvSH
	MFYtDxR+06N31WDTuAlK6gufHmbwCYsFo2plv+Ml3m4kWiGxKDUy4P1F
X-Gm-Gg: AR+sD10ThUovzDb/nH5wL7drqVjxYWTcDEk2N8/6fx1JnOMew44wntOVd41S7/emc/i
	wkBXQOSOaLT2zJOpnw4Dj2E6C4nduWvm6vQGat+rlVkpSyx1TCYu6r8Tp98rww2zaSa50AX7Fal
	PJbWyEFvkfDHbUa9ji9dxeJQxpys218x9eYKNVEEnctRhy0dsPWsN/YyRqXug6JDqRC9qBCpa/7
	dX0FVH1dtDe84CXuhEnvKSmiWKRewoe7mWdTpGukF49Apb7OQSsimk8pT3kp98SdZBexHyNdRVx
	j1slExFUWyjQ3yg9e3dcPB9DGm8TxAqyv4OA140BI7ZmORDjY+lv9+K3/8uIZW87UhpNm8kvuOS
	BKmdZcDThfa/nakBSRpQHmzHkgUppTV7dthoy4xOk1YsRTQl5tXTkt9s7Bu3vq2dYAudvjvTyQg
	vUtoNwXN0O9hHoDLoFchP7HNcrCtRf2FhXVAhU6SVzLqq+pQ0vDRw60mQ0I7xZR4zYE4y2bTK/H
	zgoVWyPbH2g6fe3
X-Received: by 2002:a17:906:c143:b0:c16:2dc0:e1ef with SMTP id a640c23a62f3a-c250c331e63mr562136566b.14.1787738194576;
        Wed, 26 Aug 2026 02:56:34 -0700 (PDT)
Received: from localhost ([37.30.36.217])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c25271e4cbcsm198282966b.18.2026.08.26.02.56.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 26 Aug 2026 02:56:34 -0700 (PDT)
Date: Wed, 26 Aug 2026 11:56:33 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v5] jfs: validate dmap start before block allocation
Message-ID: <476hryxicz5ig4we4txstyj5gyuau6da5bptx57hvgqeowplfh@uwrinfuddqll>
References: <6673d9d2-210e-4870-b355-7826289ab842@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <6673d9d2-210e-4870-b355-7826289ab842@mail.kernel.org>

The v5 code change is correct and appropriately narrow. The new checks reje=
ct
a dmap whose dp->start does not identify the range used to locate it before
dbAlloc() or the single-dmap path in dbAllocCtl() can derive an allocation
result. The metapage unwind and -EIO paths are correct. Static review, the =
JFS
target build, and both default and strict checkpatch pass. The runtime resu=
lt
is favorable, but it is not an exact baseline/patched comparison because the
baseline did not record the syz-crush binary hash. The patch is not ready f=
or
upstream submission because its Fixes tag and generated recipient metadata
still need correction.

The combined condition in dbAllocCtl() is safe. A negative tree.budmin takes
the pre-existing -EIO path before allocation, while a valid tree.budmin wit=
h a
mismatched start calls jfs_error() and returns -EIO. Short-circuiting when
both fields are corrupt does not allow an allocation to escape. The helper
name and the location of the alignment calculation differ from another
possible implementation, but those differences do not weaken the invariant.
No code rewrite is needed.

Two submission changes remain:

- Drop Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2"). This is the repository-root
  import, not a proven first-bad commit, and the causal allocation arithmet=
ic
  predates attributable mainline Git history. Do not add another Fixes tag
  unless the introducing change can be identified.
- Correct the generated recipient set. torvalds@ppc970.osdl.org is the
  historical address recorded on the 2005 repository-root commit; the exact
  current get_maintainer.pl invocation for this diff does not select Linus.
  Keep Dave Kleikamp, Yun Zhou, Kees Cook, the JFS discussion list, and
  linux-kernel, and omit the historical Linus recipient from the upstream
  submission. This is a maintainer-selection/formatter correction, not a
  source-code or changelog change.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Wed, Jul 29, 2026 at 05:15:27PM +0000, syzbot wrote:
> A corrupted JFS filesystem image can cause a state where the block
> allocation map (bmap) and the dmap pages are out of sync. Specifically, if
> a dmap page's `dp->start` is corrupted, it can lead to a mismatch during
> block allocation. The block allocator calculates the returned block number
> based on `dp->start` (i.e., `dp->start + block_index`), while the bitmap
> update is derived from the block's relative position within the dmap. If
> `dp->start` does not match the expected start block number for that dmap's
> position in the bmap, the allocator may return a block number that is
> already in use (e.g., as an inode table block or metadata), while marking=
 a
> completely different block as allocated. This mismatch leads to duplicate
> allocations. When a thread later attempts to lock this duplicate block (f=
or
> example, during a directory btree split), `txLock()` detects a metapage
> conflict because the block is already locked for another purpose,
> triggering a kernel BUG:
>=20
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
>=20
> To fix this, validate that the `dp->start` of the dmap page matches the
> expected start block number during block allocation operations (`dbAlloc`
> and `dbAllocCtl`). Rejecting a mismatched start with `-EIO` prevents
> duplicate allocations before `txLock()` is reached. Additionally, preserve
> the existing independent geometry check (`dp->tree.budmin < 0`) in
> `dbAllocCtl()`. Both a mismatched start and a negative `budmin` will now
> fail with `-EIO` early, preventing corrupted dmap structures from causing
> duplicate allocations and subsequent transaction lock crashes.
>=20
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+a843f6ae2130a987d63b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Da843f6ae2130a987d63b
> Link: https://syzkaller.appspot.com/ai_job?id=3D601b1802-e8c6-4427-af36-c=
1b279764dc7
> To: <jfs-discussion@lists.sourceforge.net>
> To: "Dave Kleikamp" <shaggy@kernel.org>
> To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Yun Zhou" <yun.zhou@windriver.com>
>=20
> ---
> v5:
> - Narrowed the validation of `dp->start` to only the primary block alloca=
tion paths (`dbAlloc` and `dbAllocCtl`).
> - Removed validation checks from `dbFree`, `dbUpdatePMap`, `dbExtend`, `d=
bAllocBottomUp`, and secondary loops in `dbAllocCtl`.
>=20
> v4:
> - Renamed dbValidateDmap to db_validate_dmap to follow kernel naming conv=
entions.
> - Preserved the existing dp->tree.budmin < 0 check in dbAllocCtl instead =
of replacing it.
> https://lore.kernel.org/all/d1405703-afc9-40f9-bc57-ddedf66f35da@mail.ker=
nel.org/T/
>=20
> v3:
> - Renamed the patch to "jfs: validate dmap start before block map operati=
ons".
> - Simplified dbValidateDmap() to only validate that the dmap dp->start ma=
tches the expected start block number, removing unproven integrity checks.
> - Updated the commit description to explain the exact root cause of the s=
election/update mismatch and how validating dp->start prevents duplicate al=
locations before txLock() is reached.
> https://lore.kernel.org/all/7c3c4fb4-ccbd-486f-b087-6074364ee206@mail.ker=
nel.org/T/
>=20
> v2:
> - Replaced the approach of propagating errors from txLock() with proactiv=
e dmap validation.
> - Introduced dbValidateDmap() to check dmap page integrity (nblocks, nfre=
e, start address, and tree structure).
> - Integrated dmap validation into dbFree(), dbUpdatePMap(), dbAlloc(), db=
Extend(), dbAllocCtl(), dbAllocBottomUp(), and dbExtendFS().
> - Reverted return type changes for functions in jfs_dtree.c and jfs_xtree=
=2Ec from the previous version.
> https://lore.kernel.org/all/ff86d803-d687-48f6-9cc2-f3d35b27a666@mail.ker=
nel.org/T/
>=20
> v1:
> https://lore.kernel.org/all/9d2eba88-93bf-4f3c-a3b2-b554e1fffe80@mail.ker=
nel.org/T/
> ---
> diff --git a/fs/jfs/jfs_dmap.c b/fs/jfs/jfs_dmap.c
> index a841cf21d..9bdbc55d8 100644
> --- a/fs/jfs/jfs_dmap.c
> +++ b/fs/jfs/jfs_dmap.c
> @@ -98,6 +98,9 @@ static int blkstol2(s64 nb);
>  static int cntlz(u32 value);
>  static int cnttz(u32 word);
> =20
> +static bool db_validate_dmap(struct super_block *sb, const struct dmap *=
dp,
> +			     s64 expected_start);
> +
>  static int dbAllocDmapBU(struct bmap * bmp, struct dmap * dp, s64 blkno,
>  			 int nblocks);
>  static int dbInitDmap(struct dmap * dp, s64 blkno, int nblocks);
> @@ -886,6 +889,12 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks,=
 s64 * results)
> =20
>  		dp =3D (struct dmap *) mp->data;
> =20
> +		if (!db_validate_dmap(ip->i_sb, dp,
> +				      blkno & ~(s64)(BPERDMAP - 1))) {
> +			release_metapage(mp);
> +			goto read_unlock;
> +		}
> +
>  		/* first, try to satisfy the allocation request with the
>  		 * blocks beginning at the hint.
>  		 */
> @@ -1902,7 +1911,9 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb=
, s64 blkno, s64 * results)
>  			return -EIO;
>  		dp =3D (struct dmap *) mp->data;
> =20
> -		if (dp->tree.budmin < 0) {
> +		if (dp->tree.budmin < 0 ||
> +		    !db_validate_dmap(bmp->db_ipbmap->i_sb, dp,
> +				      blkno & ~(s64)(BPERDMAP - 1))) {
>  			release_metapage(mp);
>  			return -EIO;
>  		}
> @@ -2134,6 +2145,18 @@ static int dbAllocDmap(struct bmap * bmp, struct d=
map * dp, s64 blkno,
>  	return (rc);
>  }
> =20
> +static bool db_validate_dmap(struct super_block *sb, const struct dmap *=
dp,
> +			     s64 expected_start)
> +{
> +	if (le64_to_cpu(dp->start) !=3D expected_start) {
> +		jfs_error(sb, "corrupt dmap page: start %lld expected %lld\n",
> +			  (long long)le64_to_cpu(dp->start),
> +			  (long long)expected_start);
> +		return false;
> +	}
> +
> +	return true;
> +}
> =20
>  /*
>   * NAME:	dbFreeDmap()
>=20
>=20
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482
> --=20
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>=20
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
