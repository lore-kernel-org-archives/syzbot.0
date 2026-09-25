Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F316018E025
	for <syzbot@lists.linux.dev>; Fri, 25 Sep 2026 18:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790359710; cv=pass; b=m+ltHq9uAXAuV9iPxXAdd9PYDxwi0Nsgzf9pJyDpWA79rdvnJ8dff1YrKpayV6Hqc1R0miL+/VTnXMN9C2KS8QufWmx3AB1ilQeH6iuPPUtJ49/yn2mp3+6wtJKOvLUpedxpj8ZG0V+S7o/NB0Hh/ZH77digZsNlfJDQaNts2Cw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790359710; c=relaxed/simple;
	bh=jUFwsM/Z5ns6wqNyUwLCb47y1s3k18QCQb6aJZMIHfw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=s09VFZ1GOASvmslH51FzNn+CRbVFJWge8qAgZML14yNkwsmA6uXIjFJe8DTcEinWaEGRSVpRUppcduX7Q6oGZpq4gtcu1Ox59Ylr326TWjCDp6irtff/42mVhTGRWzZ1ZPlH6XxYXHZJhPLHoMvY0sGLmJxxzOZDAyOTVOMmvj8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=cmbWxnpP; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="cmbWxnpP"
Received: by smtp.kernel.org (Postfix)
	id B17CA1F00893; Fri, 25 Sep 2026 18:08:28 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=74.125.228.140
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1790359708;
	b=ebvfLeQsYrpE15xKsN0He5j6Sf8fxca+5L0vPcjjxjRVlpUu6zuWG6+iOFV33ZiKpsC4
	 Gsq/+JKOO87JLImvkL21cRapxFCr/zBXQUbHfLwREhtobAZa/LJakW+5n782E1xHDNAAU
	 ud8CIAWdjveBG6aj+aAsZ6KOMZx8rCU4+w2MMbERQOxS5O0xV7qUWBfggFiv901NLQpdM
	 tolk7FVYPWV/CpwrBBP2wsVwZ1IqaD38sx23N/H2H3pfb/vQvgSPA9RZVOP0lfVA3R5F3
	 bxJDBokj6F2zmfwMc5dOqlvvh+pKNRJSB3WB1M+PsQ1IJw03NjrlnzChNCPakval6lw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1790359708;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:Content-Transfer-Encoding:In-Reply-To;
	bh=54gfOBoFxSINlWbl0SAAxB7AvYhjLSTqbK0ZLiU9qY8=;
	b=G4UlH9UtYc9U0x/FHfXiglGcRFi4XsLmdPGz9LDra527ArN47raqJPracl+V4KUPmmXk
	 WMdLV1WTxfskV5uvjc7/QE1efnW0+n6kwSjiYe7gQCa8yRrXpEtUykZm1nldSYJdvHOWM
	 1QbFKQjQ2Dxd4qtk+Vg5zuap3KHL7RexSJ4BqU9NkGK+F/CZd19xGtL4TZzjZp8R/rk9i
	 MHG45kz006UnJAY+IG5wNdVAzmlZAPoydzwGy3iadtjz/WPd+653eKzi3Gaoy0CZgsc0l
	 HhlP1Ob+bHiVAToTPi0mXmduLqswBTa+4NeYr2ehNt533CjwF/c39HGf2jYLGPxu5tw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cmbWxnpP;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=74.125.228.140
Received: from mail-ej2-f12.google.com (mail-ej2-f12.google.com [74.125.228.140])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id CBADB1F000FF
	for <syzbot@kernel.org>; Fri, 25 Sep 2026 18:08:27 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=cmbWxnpP
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org CBADB1F000FF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej2-f12.google.com with SMTP id a640c23a62f3a-c254f9f7dbfso137507366b.2
        for <syzbot@kernel.org>; Fri, 25 Sep 2026 11:08:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790359706; x=1790964506; darn=kernel.org;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=54gfOBoFxSINlWbl0SAAxB7AvYhjLSTqbK0ZLiU9qY8=;
        b=cmbWxnpP/luTA2wTmjiKEk314+tnzoaX82IJnoYRno/wzkXALl1sAhWU4crUQQwm6Y
         EBuzvaidjBWOo3+gvC61Xf+4NYieqMKSvMEcH+zOT9KekM4yhjr8CfSD8aEXDMlLnof2
         Sh0oVNrhu6z6fJcyUIxT69cpDKRVQ99shRCQwL22xVufRSE0VSdXqVnfwwia6eb935pC
         Vfw88BJ2nTnZSzCfKlHnRBNhxSOzKSdSDik3znlBJGRkDyUG5tkLqnJSU+CKoSv3npDf
         qh8N5tASPD6k41sUo6swRjL0Hhy37eka8W3VTr+DCzFSXdxX3fO8dExa/x+ShvF48Gmm
         nfrw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790359706; x=1790964506;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=54gfOBoFxSINlWbl0SAAxB7AvYhjLSTqbK0ZLiU9qY8=;
        b=ozbjvXyAS8c7WkCU/N2//FbAdgDCsYD63swX5kYDrX3wGdz8lfUxdP0272nEjfD+99
         IpThCADwEqGOJQwSTWSR4sxAOfuyobSUOEJQeF7A9iF8zHTme7mPB/V8f09f/uWEG/ah
         Xdooigl908RSuUYugvxXOvdn52U2qvxzTKN4D7p6tX+Wx+w6AWUHih/kHfWMNrsetbbN
         zzftfi+Zp8Tce7TBvUv88mHGHuTBjZrv+bhFWsr3Y7MRYI40FXARXE6IJ4Te7ghb0yU9
         +5jxYkZHj0p7SiHy0ziRmoTr8AdUxFmBV1QrGi/s5EyTOSzy9TA/U2AQwyRguidgA7uY
         M7Cw==
X-Gm-Message-State: AFuF++nAUZgxFYnY2Sh7ub3db3HR9Li6c8CUNwH4lqrSwXM8qAlTWs2h
	vBKwJpdvweCmXKTxqxnh/KWiTdwe2NFZqZ+yyDOROV8449IFJw3bn2ghijBivg==
X-Gm-Gg: AYBFou31yD8qRdQSGwwikMSNjDOWh9aJvHcMWiOjdmWKrZVjR0iS7P9S8ZdEK6UsNQE
	yCfSUOv1dp3Qef7V2Nsv+D2WwZLze0S6PgTHC8J/QFYC+QZbt6ooFmWws8X7xtMeaCbhG66zOe9
	xDJz4tOV+/Mt/hzmcfYf+OqzCYAqVvJ9tjRdFwzD51GbRg4I51h7foxSuT/ZSlEUO1jsU75W9h4
	2704pjMHULlArtJwAZfJ2Nz3DBXeez2y9Pq7GslEL5SHsOp0JX6CzAkt9nTVgRoKXuq5MP9K0w5
	jk2mJKSoxwuEwhZ3hBwrvkQz9RIdA0n9pq3mN50FobnFDQWwb2Puu2ABmY+EW8QLnhGz+1RKXsg
	etoyPAKFfPZl++/lc8Wl+0YbgLvWG6OBzYe2eYSChH+etqenHfv6EAwO3Qzp4VIZz91i4aREdCS
	ve4tP7MfYycPUjYGL7Fq9IRBKAwoULFY6/OLa2Xr1Na7NPF23dQe86fANbIBK8NfVB63KItDqDM
	cDOSYcwNmgiZXf9gSOa04cB
X-Received: by 2002:a17:907:6d13:b0:c26:2fc8:4e91 with SMTP id a640c23a62f3a-c2ac259b230mr599240266b.29.1790359705991;
        Fri, 25 Sep 2026 11:08:25 -0700 (PDT)
Received: from localhost ([37.30.46.119])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2ae7806ca4sm154563466b.52.2026.09.25.11.08.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Sep 2026 11:08:25 -0700 (PDT)
Date: Fri, 25 Sep 2026 20:08:24 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com
Subject: Re: [PATCH RFC v6] jfs: validate dmap start before block allocation
Message-ID: <j2uog7tms4sckyzt7g2pijbadqcfd4zl4k7i62jhk2qpekhxkk@dwnwnqna4i4q>
References: <a8ef6423-9a58-4396-a030-92690f02f44c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <a8ef6423-9a58-4396-a030-92690f02f44c@mail.kernel.org>

Use more accurate commit description as in proposition below:

jfs: validate dmap start before block allocation

A corrupted JFS allocation map can cause blocks that are already in use
to be allocated again. A subsequent directory split can then hit the BUG
in txLock().

dbAllocNear() and dbAllocDmapLev() derive the returned block number from
the on-disk dmap start field. The dmap page is selected using the
allocation hint or the control map, while bitmap updates use an offset
within that page. If dp->start does not match the start of the selected
dmap, the allocator can update the bitmap for one block and return an
address belonging to another block. Checking only that the returned
address lies within the filesystem does not establish this consistency
and is triggering a kernel BUG:

kernel BUG at fs/jfs/jfs_txnmgr.c:836!
Oops: invalid opcode: 0000 [#1] SMP KASAN NOPTI
RIP: 0010:txLock+0x1cc3/0x1d10 fs/jfs/jfs_txnmgr.c:836
Call Trace:
 <TASK>
 dtSplitRoot+0x38d/0x18a0 fs/jfs/jfs_dtree.c:1924
 dtSplitUp fs/jfs/jfs_dtree.c:990 [inline]
 dtInsert+0xeb2/0x5890 fs/jfs/jfs_dtree.c:868
 jfs_create+0x730/0xae0 fs/jfs/namei.c:138
=2E..

To fix this, Validate dp->start against the expected dmap boundary in dbAll=
oc() and
the single-dmap path of dbAllocCtl(), before either allocation helper
can consume it. Report inconsistent metadata through jfs_error() and
return -EIO before allocation. Preserve the independent budmin check
in dbAllocCtl().

Kind Regards=C2=A0/=C2=A0Mit freundlichen Gr=C3=BC=C3=9Fen =20
BART CHRONOWSKI

On Wed, Aug 26, 2026 at 11:05:24AM +0000, 'syzbot' via syzkaller-upstream-m=
oderation wrote:
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
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+a843f6ae2130a987d63b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Da843f6ae2130a987d63b
> Link: https://syzkaller.appspot.com/ai_job?id=3D58bf2b5e-d2b3-40a0-89e7-5=
bf303a55f7b
> To: <jfs-discussion@lists.sourceforge.net>
> To: "Dave Kleikamp" <shaggy@kernel.org>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Yun Zhou" <yun.zhou@windriver.com>
>=20
> ---
> v6:
> - Dropped Linus Torvalds from the To/Cc list.
>=20
> v5:
> - Narrowed the validation of `dp->start` to only the primary block alloca=
tion paths (`dbAlloc` and `dbAllocCtl`).
> - Removed validation checks from `dbFree`, `dbUpdatePMap`, `dbExtend`, `d=
bAllocBottomUp`, and secondary loops in `dbAllocCtl`.
> https://lore.kernel.org/all/6673d9d2-210e-4870-b355-7826289ab842@mail.ker=
nel.org/T/
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
>=20
> --=20
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/a8ef6423-9a58-4396-a030-92690f02f44c%40mail.kernel.org.
