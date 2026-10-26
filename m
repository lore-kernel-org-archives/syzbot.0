Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793031355;
	b=fNQnhSGJyXHRBw3aKwAkFdeQS5JprWzfEo5JafOcyRTbsVxbJ3qb6DCfFgBn6OAvYtwE
	 rlCi2jbYKo873TF1eovPtGBwRFb8FygMJL7Zqs1BBw+0apmdFssqY8zKtiD4K83tX2N9B
	 7S7iDQZkHEvlTF1kcjje2UteK0lFIhxMk5hNI36TfDq9b+G2D3usFIq014kPGIxxFn00X
	 3XUYLN26n0E6jfkztQmoy7f+j7QO7H2BLaX0zuUtkoSt4HR5KL1LoiBdAvFXWMkxos+xm
	 m+1IkjYh4WiA40LBb42gePO1vQH9I7jlKkdLPn3qf4lMjw9VjpZ8f4Qyf/zjsTq16Lg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793031355;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=iUlRbV2o3Wff2h6BAUNRD/DjTFCxIX4h0ehdTCN+VE4=;
	b=e0sgTYYL821vsDQWCvSZU1ckXRYpSr1SvPXwTzIyRp7ZmOaYs66yisxzOmt7CSRfBJbh
	 WDXRzfc7dpbxXF+PXy/Y0rjbeczL7ut48n8mp8CSC1jaiQgbWznMFPyJEpCzN2pPowOD0
	 9Dz7T1OKHeH9WjclhYSly21+PNwIzUD/ZFzjk2PxR8LcUba+zRySKXtAWG9HVfgCugHdv
	 FMorwqGK9dtDe59J4r1ecvOuY86/ZO+mMLWurytXaSZ+5pC500sEDeOb3cUwjYupY7edY
	 Ht/R1AudvAV2zJCHUcks4sTFhVwVcsfRlXji+fUopWOUbftBTU8OdmFGj87hvqW7SLQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HC4r1rrI;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9799606A31A
	for <syzbot@lists.linux.dev>; Mon, 26 Oct 2026 16:15:54 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D9799606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=HC4r1rrI
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c411e139259so246873866b.2
        for <syzbot@lists.linux.dev>; Mon, 26 Oct 2026 09:15:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1793031353; x=1793636153; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=iUlRbV2o3Wff2h6BAUNRD/DjTFCxIX4h0ehdTCN+VE4=;
        b=HC4r1rrImItO1miQE0quJfrZeYXv5PI/r80zNcXeAP3yJMdvOkJV8uTvuB6FNT/MhN
         dzBAydaZx+UdYCRXn17HbFyv8vkSGB9z6jsPzdZEQLP1cviIjuCbv8y1YrPELo4UTzFR
         dzXvw+0dRdgK90ZN5F7HTZEep9M6D7UL02utt7lY3e4pzuFbfZsdWyebSf9S7VG4MAQk
         VumwjmUsORYKqzkAP8dWrrHb1rpIdiaxXM4eA5BSxCdtUDXxENmug2KcgnyBQc9Agvy8
         CCrCwhbPxr/Z+S5YYMAMIYAWTCXSYfvAFK+4MS+4CbotpmThRg9BQNSWO5yjnW4uhw1N
         6BNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793031353; x=1793636153;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=iUlRbV2o3Wff2h6BAUNRD/DjTFCxIX4h0ehdTCN+VE4=;
        b=ptqHkljE812CVI6x962pqhlnPX74ayzGg1zkE572JzC0/HdcSWudSZoXbwwcGPGgG1
         G/RW8gfo4Q7O1qTb8TZjTn1WLg5p0fXeMCs5M/gtDrnF8/8Hmw9ALWwkasvNpDWwJQvm
         a3hRG3LJk1IhnKeluqEEececYgwymk96SfmWn81hE5BQ8PLZpzjlGXIF4+V1gBBjE/RJ
         2AuKTtUJ9r+trk6yuJXmTCFbvqydNBmz31vZ3lLAj5e5/JPgSKzQrUgY63mzWUAoXfXv
         6Xi7QIgcWwomKzYTCCssEK5NHzHKtdfaGFYJqQaqwzvcIgpsKjAKq9Skusuv+chTs5Kq
         x/Lw==
X-Forwarded-Encrypted: i=1; AKwUvByUBy96PLVRNlvQVIkZhQCQVF2VfXrtMC7nBHQRr4Wv1RCNtjYGs19degex/GsFDSyf3XRoQZw=@lists.linux.dev
X-Gm-Message-State: AFq9FYKBNSFOHt2NeGOPM3SOMu+NJ4M+xNJrpmddJeRJr0WoYeOvW/VC
	/6o2ftHXx2nbN9kH+FttAyxtafAzuWH8RvKWdcLPf0lcwNBmEkQzk4CC
X-Gm-Gg: AYBFou39nRZAYPFYfvh8c+4ByP8KlYPzo1gF6NO8dchYDIBbp2vT6VYllN/NNqpWb9Y
	49nf4GIV6Yrcm7w8LGFboQSoclq+8/CQIaEBhl7Sl1z5YcnTuaANLsS700Iz7A+2pvT36wLNJK3
	DtKcmV25xpXl1V2Z7qrs6eWAn9KKg6i/7tHrDU2p0yisr7DCj2f5YUd514WglLL87BY51U2W4Mr
	zavC/j5Bi56bn0+I6iPDHKbijP8OHRqk6VAc99O2OSzPMeOAxXY/uit6uXHq3Y9C8b6DLK/0ugq
	4lbQlzdHCQ4AHjEVvyXoG9fj5WlH4Hd0rB85x4pAlrNNalBrv1hyllU0vIZWQnNAgebA0ryVvFC
	kRdqDQomZWCcTCJPLqtRKMZ1ajLOfcsTui/l0fc/Ov3fyLbSZDq6QBHvmIZUcAJTHgHSxHzOQZ/
	a3c00x5ThvG+5ViWhnaNLszhlpTTyVq3dtvOCs3e4DbLvMprbeIeo0NtcTZR1MtXe1IPRdgspI1
	m8Rs1LCjtdvoivs2I26654XSC6NS6cUPlS7FgTD9FNIaFSHIy+aFraeSWXg7LE1iC7BYBUIOOo0
	SAlRerZfh3mKFe+ovd7n71r1/g==
X-Received: by 2002:a17:907:960a:b0:c2d:c247:5400 with SMTP id a640c23a62f3a-c46bde4ee68mr825951066b.27.1793031353009;
        Mon, 26 Oct 2026 09:15:53 -0700 (PDT)
Received: from localhost ([37.30.48.34])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd4ea39fsm337365166b.29.2026.10.26.09.15.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Oct 2026 09:15:52 -0700 (PDT)
Date: Mon, 26 Oct 2026 17:15:51 +0100
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, jfs-discussion@lists.sourceforge.net, 
	Dave Kleikamp <shaggy@kernel.org>, kees@kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev, yun.zhou@windriver.com
Subject: Re: [PATCH] jfs: validate dmap start before block allocation
Message-ID: <ye5pikbxc5yhetpoydhwymv7uf6p3ulk474s5cu5vw56vaimh3@ezfc6jlqds7a>
References: <b63dd8ae-464b-40d7-bbb8-031cfdc90909@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <b63dd8ae-464b-40d7-bbb8-031cfdc90909@mail.kernel.org>

Gentle ping on this JFS patch. Is there anything you would like changed
before it can be queued?

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Wed, Sep 30, 2026 at 10:25:08AM +0000, syzbot wrote:
> From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
>=20
> A corrupted JFS filesystem image can cause a state where the block
> allocation map (bmap) and the dmap pages are out of sync. Specifically,
> dbAllocNear() and dbAllocDmapLev() derive the returned block number from
> on-disk dp->start, which can cause duplicate allocation if dp->start does
> not match the selected dmap boundary. In this scenario, the allocator
> returns a block number that is already in use (e.g., as an inode table
> block or metadata) while marking a completely different block as allocate=
d.
> When a thread later attempts to lock this duplicate block (for example,
> during a directory btree split), txLock() detects a metapage conflict
> because the block is already locked for another purpose, triggering a
> kernel BUG:
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
> Validation of dp->start against the expected dmap boundary in dbAlloc() a=
nd
> the single-dmap path of dbAllocCtl() prevents inconsistent allocation.
> Rejecting a mismatched start with -EIO prevents duplicate allocations
> before txLock() is reached. Additionally, preserve the existing independe=
nt
> geometry check (dp->tree.budmin < 0) in dbAllocCtl(). Both a mismatched
> start and a negative budmin will now fail with -EIO early, preventing
> corrupted dmap structures from causing duplicate allocations and subseque=
nt
> transaction lock crashes.
>=20
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+a843f6ae2130a987d63b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Da843f6ae2130a987d63b
> Link: https://syzkaller.appspot.com/ai_job?id=3D922ceb61-4be2-4af9-b2fe-9=
977a2549134
> Signed-off-by: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
>=20
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
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> The person who has signed off on the patch is responsible for
> addressing comments.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
