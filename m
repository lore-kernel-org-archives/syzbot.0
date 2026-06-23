Received: from mail-oa1-f41.google.com (mail-oa1-f41.google.com [209.85.160.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D59773546CB
	for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 12:38:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782218338; cv=pass; b=drV9OdcZqAK2m2eaiHOdRCyuTAW3gRvXfGUKtHU4f1M/FuQcdzeKGovmcrxg7z4/ZPdw5oAN+w/urB4qR3Cf7ShBTVK8xzi2XKzb09iGbzTFwhfVzZ9pQsJNXtPcL/iAgGTaT5HQU0k+pzjdWfFI/2WpIujLI1Ay0hLpXFEMXOI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782218338; c=relaxed/simple;
	bh=6GlD0OB0eWR5GBMkMCDtPcLR4ZBKHGM6GZiXb6riuxY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u0A3oac1a2fBqDHfr8ogFaH1cqcwTqlec4Z0uYa2fjF3bXbDn9bDwgN6QGk7gh3LQhS1dTQQiWl8YnKMm5A7GxJAwWp1GJ1C51DENoXGbl9E6vf82+QOhNE5rUT2juydzQB7kFBoaW2zfSH5kCICLveobrFDJmB6IyxYY3uu1b0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=oxLJwBtn; arc=pass smtp.client-ip=209.85.160.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="oxLJwBtn"
Received: by mail-oa1-f41.google.com with SMTP id 586e51a60fabf-44748131f58so550789fac.1
        for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 05:38:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782218336; cv=none;
        d=google.com; s=arc-20240605;
        b=OPO9iDjn5jwVrloRJYDtfW18D6A0qs6DgUfeMkE5GbG0mwFO+IAcLr/EM/2D+JMr5o
         uA4vsoIGy8f+tMdDATlPcVq5qdELmeDV6hgLP0TqBQnzoKkX6Zq0CQW2DOVWW2QZfBKu
         Pr+TO82EblVqt69eRMcro1ybWD69w3EKuP6UigI+s/NdfA1SDzKliv4id0HgHBqS81s1
         WqQK+0yCx71I4hp4BNgYZIjwUa47Ou7GmAqQSROpo+/9ccpZmpNO8IVbjq9Mb+2tuCPY
         A5+/0CYqhiqJQc/XUqo1TWsinK7MVhB3cb3ia/nOOyBFbGgcc3IiYqorn22gHanLrXz3
         BmYw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=2cOblU2GV0DvMumMsBr50A6OTtMBaR46y4zHsI1XqMQ=;
        fh=tREsphDO9my1KUzhpdQQbovfTR7Zy9odfMbof2xnANA=;
        b=KxhQaJifpY0X8jPb1F+Teom9aZeqoX69oOBPkXJ8f2PZaU45OY3W7mhWYV07y1HxD7
         Iwb5fRomvcMr2imN6hq6a2nNKN943uemDFZGjOkI/dBABF6GKrrT4iyWigumKD4DwWLI
         U+qBTsnFdtK8v7zotFHyTaWG5DYyFNB96uJTNYat3NLVTyjHRXaGZLovMRqcI/HkCkVx
         0YFnBkArDnXOHNuG+RIftpAhuOGxuPok3It9iZl8Edi1KP9YddWvLfFJRMP6dfOyh3T9
         drfTMkuTdkh1hkJ1arhaY7DpdPEWAn78Lr1+StJHEcKBfMSn64TQPK5hqr0lcWE1vcgH
         05Ww==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782218336; x=1782823136; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2cOblU2GV0DvMumMsBr50A6OTtMBaR46y4zHsI1XqMQ=;
        b=oxLJwBtnue0n9c3FJs0zKkRfcSyuRbocZPni5UftQjKzQw8AGGs7Vy4ZbpV3du5US3
         VOXgT6zypZ4ZUDpyqzhR3R6mUqCj5nOb4kZUkuMWnh9oFuSwO+6mZ02DDILX2AGRX2bx
         V7jMWRKtKAqXcY1p6rg28CDXa6v0rMysv/uDGYxyH/sCDw8CGrs7//ghs68ORIsFNUXg
         91bS3AOQufgjzd5Y/y28wf5wZMNYR5+brB6gP8je8s2QW50QJInEBWflFmv95qWnB8bM
         7AO9Y0f93nL1caSDT+kqwwdbaEna+4Tp5aZczM4JXO6noXF1I/fWl4AGXJSUE/B2o3ei
         Fb6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782218336; x=1782823136;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=2cOblU2GV0DvMumMsBr50A6OTtMBaR46y4zHsI1XqMQ=;
        b=cGtdPR7qUJ/tXUQSjgiP5quDEd/Opoad3hv6HsgUmwhsksaIJ3So49FUe9f5iZpOiA
         WhKNYswflKq7zhXcVLkCXJwiOm2p0ANbkef8ZUmS4M0Ku5DYrL54SC0iIZlpriYGfwZG
         K3HykBUzYMYV5YAfFVnWxWQkT/W5Rp8IRmnPH475Ca/MdNM7gb9VnvKHN4PBi0YNv5oj
         vNQARwWNnOihgPYlDF3p23lwMnV8b8rDsXGjOF8o2Wpn0DlXeyjFEdMhplNHaepTgAYx
         PX4G4UCj8ksQeH2crrr21V9bEjkB747d4fRKhCxtidFOowb+6+fcM2nGPfyueE4txUN/
         Xy/Q==
X-Forwarded-Encrypted: i=1; AFNElJ+PMrWruuHEE+peUaTLTIE9WJ+qVZEkmUlU3gOkGn4oaEbl+f6e47+eGvPH1CBFVwjTcK8/o8U=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz3hA1vnhrcLEcvxTCErHTYD0NsVuZWZ1N7Z7tYxC6DH3wx/m1P
	SJKFohx0QHnJ/kdA0dZczSVMA9x2bB5GlNhujv5P7KqGahrBaFlzvlbrbUInHhEZ8SQ1jAwAvXS
	FzMyyRHOGXhWAupedeV4tOexVRYwwO6CaFzd/KzYH
X-Gm-Gg: AfdE7clv56pUpKU3y+FjFtQtNntuxvuFUMACESaGx8qPQD1VRII+VzDhMyKmCtPR8bJ
	UE8IJyPP7Lk3Noi12gWKE+vT1nV+3FwpE/QmL4PTddP8mHX3Bi12cq+29rmyvAPM2z/cOrilJ12
	eri6uOR+P62F6YN/Oyt+NofDzMMqj6ej25o5/TZo41FjvHckK7nr14l58YZaO44OGP0NXDfBXLw
	+I1K7DhsGls51a3n40wsTb9XmsSe87AdrbUOK/VtU3+O0nSDhdnAO1SgyHrmkwnxT8pouCtSINM
	bA4lru5XOAnM2vgCQi/PJgykZgwIzugL/3npg56VR4lL02Bb3LAr4dvfm3C19T1GYyz/1phkFQV
	mMzHILV4IieX5QcAW7wldixnioql3Mb6I9Gu6QUlu
X-Received: by 2002:a05:6820:c447:20b0:6a1:1978:59f9 with SMTP id
 006d021491bc7-6a119785bffmr436163eaf.3.1782218335106; Tue, 23 Jun 2026
 05:38:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <bc5e7712-9f0e-4db9-bd6a-47d69eecb17b@mail.kernel.org>
In-Reply-To: <bc5e7712-9f0e-4db9-bd6a-47d69eecb17b@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 23 Jun 2026 14:38:43 +0200
X-Gm-Features: AVVi8Ccgz251xOWp2DJ9H-bkk4vg-KKaruE8SgMKAhf08lUjH6s1lFZdrirbcaI
Message-ID: <CANp29Y7c-b7CEyVzOgt1+=pC4ULvnn+cXxMKzm6MZ7r0EJOf_A@mail.gmail.com>
Subject: Re: [PATCH RFC] jfs: add dmap integrity check to prevent array-index-out-of-bounds
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz reject

Let's try again.

On Mon, Jun 22, 2026 at 6:25=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> The JFS file system does not consistently validate the integrity of dmap
> (disk allocation map) structures read from disk. The dmap structure
> contains a binary buddy summary tree used to manage free blocks. If a
> corrupted file system image has an invalid leafidx (the index of the firs=
t
> leaf in the tree array), operations that traverse or update the tree will
> use this corrupted index. This can lead to out-of-bounds array accesses.
> For example, in dbAdjTree(), the array index lp is calculated using
> tp->dmt_leafidx. A corrupted leafidx causes lp to become out-of-bounds,
> triggering a warning.
>
> The issue manifests as the following warning:
>
> lp >=3D size || lp < 0
> WARNING: fs/jfs/jfs_dmap.c:2962 at dbAdjTree fs/jfs/jfs_dmap.c:2962
> [inline], CPU#1: jfsCommit/126
> WARNING: fs/jfs/jfs_dmap.c:2962 at dbJoin+0xc33/0xd60
> fs/jfs/jfs_dmap.c:2930, CPU#1: jfsCommit/126
> RIP: 0010:dbAdjTree fs/jfs/jfs_dmap.c:2962 [inline]
> RIP: 0010:dbJoin+0xc33/0xd60 fs/jfs/jfs_dmap.c:2930
> Call Trace:
>  <TASK>
>  dbFreeBits+0x4a2/0xd70 fs/jfs/jfs_dmap.c:2427
>  dbFreeDmap fs/jfs/jfs_dmap.c:2176 [inline]
>  dbFree+0x324/0x650 fs/jfs/jfs_dmap.c:485
>  txFreeMap+0x9e6/0xde0 fs/jfs/jfs_txnmgr.c:2517
>  xtTruncate+0xd16/0x2eb0 fs/jfs/jfs_xtree.c:2481
>  jfs_free_zero_link+0x35b/0x4c0 fs/jfs/namei.c:760
>  jfs_evict_inode+0x356/0x430 fs/jfs/inode.c:159
>  evict+0x624/0xb50 fs/inode.c:841
>  txLazyCommit fs/jfs/jfs_txnmgr.c:2666 [inline]
>  jfs_lazycommit+0x44c/0xac0 fs/jfs/jfs_txnmgr.c:2735
>  kthread+0x389/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> To fix this issue, introduce a check_dmap() function to validate the
> integrity of dmap structures immediately after they are read from disk.
> This function checks the expected values of fields such as nleafs,
> l2nleafs, leafidx, height, and budmin, and ensures that the leaf nodes in
> the tree array have valid values. Calls to check_dmap() are inserted at a=
ll
> locations where a dmap page is read, such as in dbFree(), dbUpdatePMap(),
> dbAlloc(), dbExtend(), dbAllocCtl(), and dbAllocBottomUp(). If the
> validation fails, an error is logged, the metapage is released, and an
> error code is returned. Additionally, redundant ad-hoc checks for leafidx
> and budmin are removed since the new function comprehensively validates t=
he
> structure.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+a67911c5a11315aa55a8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Da67911c5a11315aa55a8
> Link: https://syzkaller.appspot.com/ai_job?id=3Def51a3e1-e77a-4195-beaf-0=
7c88534adc0
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
> index a841cf21d..db5d52b56 100644
> --- a/fs/jfs/jfs_dmap.c
> +++ b/fs/jfs/jfs_dmap.c
> @@ -220,6 +220,69 @@ static bool check_dmapctl(struct dmapctl *dcp)
>         return true;
>  }
>
> +/*
> + * check_dmap - Validate integrity of a dmap structure
> + * @dp: Pointer to the dmap structure to check
> + *
> + * Return: true if valid, false if corrupted
> + */
> +static bool check_dmap(struct dmap *dp)
> +{
> +       struct dmaptree *tp =3D &dp->tree;
> +       u32 nleafs, l2nleafs, leafidx, height;
> +       int i;
> +
> +       nleafs =3D le32_to_cpu(tp->nleafs);
> +       if (unlikely(nleafs !=3D LPERDMAP)) {
> +               jfs_err("dmap: invalid nleafs %u (expected %u)", nleafs,
> +                       LPERDMAP);
> +               return false;
> +       }
> +
> +       l2nleafs =3D le32_to_cpu(tp->l2nleafs);
> +       if (unlikely(l2nleafs !=3D L2LPERDMAP)) {
> +               jfs_err("dmap: invalid l2nleafs %u (expected %u)", l2nlea=
fs,
> +                       L2LPERDMAP);
> +               return false;
> +       }
> +
> +       leafidx =3D le32_to_cpu(tp->leafidx);
> +       if (unlikely(leafidx !=3D LEAFIND)) {
> +               jfs_err("dmap: invalid leafidx %u (expected %u)", leafidx=
,
> +                       LEAFIND);
> +               return false;
> +       }
> +
> +       height =3D le32_to_cpu(tp->height);
> +       if (unlikely(height !=3D 4)) {
> +               jfs_err("dmap: invalid height %u (expected 4)", height);
> +               return false;
> +       }
> +
> +       if (unlikely(tp->budmin !=3D BUDMIN)) {
> +               jfs_err("dmap: invalid budmin %d (expected %d)", tp->budm=
in,
> +                       BUDMIN);
> +               return false;
> +       }
> +
> +       /* Check nodes have valid values */
> +       for (i =3D 0; i < leafidx + nleafs; i++) {
> +               s8 val =3D tp->stree[i];
> +
> +               if (unlikely(val < NOFREE)) {
> +                       jfs_err("dmap: invalid node value %d at index %d"=
, val,
> +                               i);
> +                       return false;
> +               } else if (unlikely(val > L2BPERDMAP)) {
> +                       jfs_err("dmap: node value %d too large at index %=
d",
> +                               val, i);
> +                       return false;
> +               }
> +       }
> +
> +       return true;
> +}
> +
>  /*
>   * NAME:       dbMount()
>   *
> @@ -476,6 +539,13 @@ int dbFree(struct inode *ip, s64 blkno, s64 nblocks)
>                 }
>                 dp =3D (struct dmap *) mp->data;
>
> +               if (unlikely(!check_dmap(dp))) {
> +                       jfs_error(ip->i_sb, "Corrupt dmap page\n");
> +                       release_metapage(mp);
> +                       IREAD_UNLOCK(ipbmap);
> +                       return -EIO;
> +               }
> +
>                 /* determine the number of blocks to be freed from
>                  * this dmap.
>                  */
> @@ -568,8 +638,17 @@ dbUpdatePMap(struct inode *ipbmap,
>                         if (mp =3D=3D NULL)
>                                 return -EIO;
>                         metapage_wait_for_io(mp);
> +
> +                       dp =3D (struct dmap *)mp->data;
> +
> +                       if (unlikely(!check_dmap(dp))) {
> +                               jfs_error(ipbmap->i_sb, "Corrupt dmap pag=
e\n");
> +                               release_metapage(mp);
> +                               return -EIO;
> +                       }
> +               } else {
> +                       dp =3D (struct dmap *)mp->data;
>                 }
> -               dp =3D (struct dmap *) mp->data;
>
>                 /* determine the bit number and word within the dmap of
>                  * the starting block.  also determine how many blocks
> @@ -886,6 +965,13 @@ int dbAlloc(struct inode *ip, s64 hint, s64 nblocks,=
 s64 * results)
>
>                 dp =3D (struct dmap *) mp->data;
>
> +               if (unlikely(!check_dmap(dp))) {
> +                       jfs_error(ip->i_sb, "Corrupt dmap page\n");
> +                       release_metapage(mp);
> +                       rc =3D -EIO;
> +                       goto read_unlock;
> +               }
> +
>                 /* first, try to satisfy the allocation request with the
>                  * blocks beginning at the hint.
>                  */
> @@ -1118,6 +1204,13 @@ static int dbExtend(struct inode *ip, s64 blkno, s=
64 nblocks, s64 addnblocks)
>
>         dp =3D (struct dmap *) mp->data;
>
> +       if (unlikely(!check_dmap(dp))) {
> +               jfs_error(ip->i_sb, "Corrupt dmap page\n");
> +               release_metapage(mp);
> +               IREAD_UNLOCK(ipbmap);
> +               return -EIO;
> +       }
> +
>         /* try to allocate the blocks immediately following the
>          * current allocation.
>          */
> @@ -1163,11 +1256,6 @@ static int dbAllocNext(struct bmap * bmp, struct d=
map * dp, s64 blkno,
>         s8 *leaf;
>         u32 mask;
>
> -       if (dp->tree.leafidx !=3D cpu_to_le32(LEAFIND)) {
> -               jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
> -               return -EIO;
> -       }
> -
>         /* pick up a pointer to the leaves of the dmap tree.
>          */
>         leaf =3D dp->tree.stree + le32_to_cpu(dp->tree.leafidx);
> @@ -1293,11 +1381,6 @@ dbAllocNear(struct bmap * bmp,
>         int word, lword, rc;
>         s8 *leaf;
>
> -       if (dp->tree.leafidx !=3D cpu_to_le32(LEAFIND)) {
> -               jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap page\n");
> -               return -EIO;
> -       }
> -
>         leaf =3D dp->tree.stree + le32_to_cpu(dp->tree.leafidx);
>
>         /* determine the word within the dmap that holds the hint
> @@ -1902,7 +1985,8 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2nb=
, s64 blkno, s64 * results)
>                         return -EIO;
>                 dp =3D (struct dmap *) mp->data;
>
> -               if (dp->tree.budmin < 0) {
> +               if (unlikely(!check_dmap(dp))) {
> +                       jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap pag=
e\n");
>                         release_metapage(mp);
>                         return -EIO;
>                 }
> @@ -1936,6 +2020,13 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2n=
b, s64 blkno, s64 * results)
>                 }
>                 dp =3D (struct dmap *) mp->data;
>
> +               if (unlikely(!check_dmap(dp))) {
> +                       jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap pag=
e\n");
> +                       release_metapage(mp);
> +                       rc =3D -EIO;
> +                       goto backout;
> +               }
> +
>                 /* the dmap better be all free.
>                  */
>                 if (dp->tree.stree[ROOT] !=3D L2BPERDMAP) {
> @@ -1993,6 +2084,12 @@ dbAllocCtl(struct bmap * bmp, s64 nblocks, int l2n=
b, s64 blkno, s64 * results)
>                 }
>                 dp =3D (struct dmap *) mp->data;
>
> +               if (unlikely(!check_dmap(dp))) {
> +                       jfs_error(bmp->db_ipbmap->i_sb, "Corrupt dmap pag=
e\n");
> +                       release_metapage(mp);
> +                       continue;
> +               }
> +
>                 /* free the blocks is this dmap.
>                  */
>                 if (dbFreeDmap(bmp, dp, b, BPERDMAP)) {
> @@ -3308,6 +3405,13 @@ int dbAllocBottomUp(struct inode *ip, s64 blkno, s=
64 nblocks)
>                 }
>                 dp =3D (struct dmap *) mp->data;
>
> +               if (unlikely(!check_dmap(dp))) {
> +                       jfs_error(ip->i_sb, "Corrupt dmap page\n");
> +                       release_metapage(mp);
> +                       IREAD_UNLOCK(ipbmap);
> +                       return -EIO;
> +               }
> +
>                 /* determine the number of blocks to be allocated from
>                  * this dmap.
>                  */
>
>
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/bc5e7712-9f0e-4db9-bd6a-47d69eecb17b%40mail.kernel.org=
.
