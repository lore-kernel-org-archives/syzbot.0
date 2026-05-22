Received: from mail-oi1-f181.google.com (mail-oi1-f181.google.com [209.85.167.181])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391DE393DEE
	for <syzbot@lists.linux.dev>; Fri, 22 May 2026 13:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.181
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779454907; cv=pass; b=hZWhFOFCwDQE4As6CxwPXp3/psTWc0EwDJdS244gXvQ2HTdRpPBSskNPJCIeFouLrbXIlvyx2e7ljEmox/qTMxqtjT3XO15PXp6810GzA9oMSu6UUfVDStYwBpK7k28Kz/gZOnyaVrOCoZfzGIsKKFVN7xxepm6jCKXvlmk4K0M=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779454907; c=relaxed/simple;
	bh=v9VeygxB8VRkxrsFSyD6qtbhU8qO7ihmxU7W4dMafCY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gI3Cdyh6LWGYDqQtXEsd9x2LkDjXsIZmD+9n4A5XhypfS+ln0z+4bJekRc3uFGTDnKqsxWyK94G+W4W5pVXu99UX+me/fX/HBSk1bwA6aEJN9Bdp0k8NHxolAgi3AJvOO0IDUWduaEBVfYi5GxyK4tmDCxTvUmCRFlXyM01wJ7c=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GuXHGdrX; arc=pass smtp.client-ip=209.85.167.181
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GuXHGdrX"
Received: by mail-oi1-f181.google.com with SMTP id 5614622812f47-479fc1fc048so5837340b6e.1
        for <syzbot@lists.linux.dev>; Fri, 22 May 2026 06:01:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779454905; cv=none;
        d=google.com; s=arc-20240605;
        b=HTLP847HzN6D4WyBBINL1v4KEOzGo2vvT7JDKmHRKrzks/O3LVPLxqhO/HkShAstVd
         0peO2lHzClGtu1WoRZzaZgqSS/y2DEeIb9fit26NdlsQCLLvL81iS6ntRUkZqX7TFHAv
         h0pio1kDfZGPq+KnCBsJWjo/wu0KfIcuxjC4mJD0X158aCUsX5WLbPMaHnkVXQc+gLeW
         pv/1nqbNWwonppWdRVeehu3pDpqUwqMtFpzL3BEjJcNDS2zO9UOhLEGo0t3+8LtmSERT
         HZxyonehkyvL2c5biyYhTW8fL5Ae2H0mYBVr1Wdo8akaFruREmcVI0rPwRvGNCtHNUCh
         8bhw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kwmG2Mfr3nd7uuJaYbkuHCDF16Kj5PNjjXSmMsBOpzE=;
        fh=dI6d4fIqKm5Z4nIhHr87ryNxGlYcowY5D4vZtBjCwyU=;
        b=VEXX52abVfg3YLpAckIZdvkCrInAnP5g1jwe0xKY5nwOZFiAuFN7lkvysOHNojzTKV
         ocmg5CxM1e6cTpkWi6sOcLRFNMliJXoVWo92Jb4bBE7ypIIuBNeaaxmskZ89NpmUrVEP
         c5YhRPyRqF2xZ0eJ0SYJsUbFsRnDMQk0h85//x5VzDncaFKeAK+d5wmUu4oqLaGOi+eX
         7dOuG5bmpOr38mv+ZVy8law7QR4ys05ztFlb7XAILxJxc0mQQ1IXdUJ/x1hURKvjkqPq
         1f/w0e2zWUwnrQd21k553HikQL5uoRduRyfxnpfKEnqri90r31sMsBujm/0UNRxAbwKm
         fIUw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779454905; x=1780059705; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=kwmG2Mfr3nd7uuJaYbkuHCDF16Kj5PNjjXSmMsBOpzE=;
        b=GuXHGdrXtCCR0K107yFgL0B9fghrG4rcZ+BrQxzEAtNq/CEpYQbDfgOAXXTR5Me8+A
         x2xBSR1yZ3cx4T1dZ2AnkHKVWGj7yqMzdRJF7vGzbE14IJumHsfEy5nH+Qn6luPSbyrs
         kwS4FwvAwm99ViXEtTc1Ld4BMcTbo24/Hj4XNn64s0TNfJcdY3wlLKWiLmuWXi7OxPwt
         RlpGtoYQBBMT5yoXWi567ZAZ70y0Cv9BOHbvcXIedsX4lHwtqK+ZmsIh5Xo/PI1f8LaH
         CEO2c8giHtUmqFPTEGVb5p3RyuDoK1rnWa0/NcyKXyW6Ssam72SOaQAfuuRQtYlMzfio
         /i2Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779454905; x=1780059705;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=kwmG2Mfr3nd7uuJaYbkuHCDF16Kj5PNjjXSmMsBOpzE=;
        b=SdjZCPGudFgHJLG1BgD5gBeU52D2WntYPFq2iQAzEeIfjMVNohFZnfNUZ3TF5L3X4F
         jA7Zo2Gl5Jl9Nrx7GBDsPdcmoHqPEhVChKv2+/GyPbLYqSHhd2tB7x93fiY0v9s43OsJ
         hqSajoEKuy2ZV5HJAdUHCZ0bp8pUkDSldHB6QKfuP9/3kIZuvvW0G81i2IeTqamXF2bF
         ccYuBju9sDWxks7ilPNYVqt/hEbagQWKRkxsq3c1kDfJU6RheLX4XvmhooPgTwahtHEV
         jvD6YRr/Ms68hcEvxLHqQ2rSXgZSyrSoS59W2kXSD7dFI7kP0TteUwrC423ddHLb03wk
         FRcw==
X-Forwarded-Encrypted: i=1; AFNElJ//vhXMvm9YZc66fMGzhNmvtjNVZJiuGYGiz5MrtzF4flcnAIL9lo/KvxjLxn4dCUv6Gq+3Wtk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7sY9Zj9fo6ajZmXsy0F3Sho4X47V7WR09cIXoQT4fRtU1IIBk
	K6qmxDLtAlyFPTVVwkBGxxqJiuvy5mdUIn20Z4QfGgyV8mZ/UypAQ6TMhr+u0DOZK96XuYkm62s
	YKcn3Vj+nmar116HBzcSCdgu2A3RGkP/Z17FNB/aN
X-Gm-Gg: Acq92OGLFluYQ76UrScn6QSJfrUV8KirTIz1nY8cXVUlt1VD8mdHz5qfhY6ul/APVE9
	BhtjxhhDRIGh3ZTjVNxCWFc3zIoLre0Aas7uATGZBVza5c05Ntza0Ec3uEe7Cwbw1ygZx7qmiK7
	2UBh+g/9G5JKeGafDlURuxmvw8tV2Gu9NMA5ZLGT/nGXpq4VtIvzpa3L5rQgLnrBUNRsvQcyUwX
	MVdvRErmBtOEMUwclwXvpZww6gpPtX0pPir/6fs1rzNuShNIFXMphj/Cz6YbMzsIqOIEaXJ4QCZ
	caKq4ljsKhshr7PMnB1+ShUrh9mC+gazfUs0/WDx3GUdO+v5aHNSBPMjtFiJvY+VyW8VratUtEk
	jpaYk
X-Received: by 2002:a05:6808:4fe6:b0:485:29d7:70a8 with SMTP id
 5614622812f47-4854a3af9femr1940398b6e.41.1779454902419; Fri, 22 May 2026
 06:01:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <07963d2a-cd0f-4940-a5bc-33dd8f425781@mail.kernel.org>
In-Reply-To: <07963d2a-cd0f-4940-a5bc-33dd8f425781@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 22 May 2026 15:01:30 +0200
X-Gm-Features: AVHnY4K_BWv9TC01G8Ga_GYH8sigCIkX2i9ZXL-UgAs2ugXChlg7oNo8Gx8w4bQ
Message-ID: <CANp29Y6bNWETgXP-Ecj-PEvqVdgjh29RqZ+DbX=RH_Et+Xi=PQ@mail.gmail.com>
Subject: Re: [PATCH RFC] btrfs: fix double free of data space reservation on
 direct IO error
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Please send this patch again without any changes, I want to test this
functionality.

On Fri, May 22, 2026 at 9:30=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> When a Direct I/O write begins, btrfs_dio_iomap_begin() reserves
> data_alloc_len bytes of data space by calling
> btrfs_check_data_free_space(). This increments the bytes_may_use counter
> in the appropriate data space_info. Later,
> btrfs_get_blocks_direct_write() calls btrfs_new_extent_direct() to
> allocate an extent. Inside btrfs_new_extent_direct(),
> btrfs_reserve_extent() is called, which successfully allocates an extent
> of size ins.offset on disk and converts ins.offset bytes from
> bytes_may_use to bytes_reserved (via btrfs_add_reserved_bytes()). Next,
> btrfs_new_extent_direct() calls btrfs_create_dio_extent(). If this fails
> (e.g., due to memory allocation failure), btrfs_new_extent_direct()
> calls btrfs_free_reserved_extent() to free the allocated extent.
> btrfs_free_reserved_extent() decrements bytes_reserved by ins.offset,
> effectively freeing the space. However, it does not restore the
> ins.offset bytes back to bytes_may_use.
>
> The error propagates back to btrfs_dio_iomap_begin(), which jumps to the
> error handling path. Because dio_data->data_space_reserved is still
> true, it calls btrfs_free_reserved_data_space() for the entire
> data_alloc_len. This function blindly decrements bytes_may_use by
> data_alloc_len. Since ins.offset bytes were already converted to
> bytes_reserved and freed, decrementing bytes_may_use by the full
> data_alloc_len causes bytes_may_use to be decremented by ins.offset
> twice. This underflows the counter, triggering a warning in
> btrfs_space_info_update_bytes_may_use().
>
> To fix this, btrfs_new_extent_direct() must restore the ins.offset bytes
> back to bytes_may_use when btrfs_create_dio_extent() fails. This ensures
> that when the error propagates up, btrfs_dio_iomap_begin() can safely
> free the entire data_alloc_len from bytes_may_use. Introduce a new
> helper function, btrfs_add_reserved_data_space_noquota(), which
> correctly uses data_sinfo_for_inode() to select the right space_info
> (handling zoned data relocation roots) and directly updates
> bytes_may_use without triggering unnecessary ticket granting. Call this
> new helper in the error path of btrfs_new_extent_direct().
>
> Fixes: 18513091af94 ("btrfs: update btrfs_space_info's bytes_may_use time=
ly")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview =
syzbot
> Reported-by: syzbot+9064acebb06685edb243@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D9064acebb06685edb243
> Link: https://syzkaller.appspot.com/ai_job?id=3D913538c5-7b36-4127-ab45-6=
efa99a3628e
> To: "Chris Mason" <clm@fb.com>
> To: "David Sterba" <dsterba@suse.com>
> To: <linux-btrfs@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/fs/btrfs/delalloc-space.c b/fs/btrfs/delalloc-space.c
> index 0970799d0..7cfb829a3 100644
> --- a/fs/btrfs/delalloc-space.c
> +++ b/fs/btrfs/delalloc-space.c
> @@ -189,6 +189,24 @@ void btrfs_free_reserved_data_space_noquota(struct b=
trfs_inode *inode, u64 len)
>         btrfs_space_info_free_bytes_may_use(data_sinfo_for_inode(inode), =
len);
>  }
>
> +/*
> + * Restore a data reservation for this inode.
> + * Normally called when a reservation was converted to bytes_reserved bu=
t the
> + * subsequent operation failed, so the bytes need to be restored to byte=
s_may_use
> + * so the caller can free them.
> + */
> +void btrfs_add_reserved_data_space_noquota(struct btrfs_inode *inode, u6=
4 len)
> +{
> +       struct btrfs_fs_info *fs_info =3D inode->root->fs_info;
> +       struct btrfs_space_info *sinfo =3D data_sinfo_for_inode(inode);
> +
> +       ASSERT(IS_ALIGNED(len, fs_info->sectorsize));
> +
> +       spin_lock(&sinfo->lock);
> +       btrfs_space_info_update_bytes_may_use(sinfo, len);
> +       spin_unlock(&sinfo->lock);
> +}
> +
>  /*
>   * Called if we need to clear a data reservation for this inode
>   * Normally in a error case.
> diff --git a/fs/btrfs/delalloc-space.h b/fs/btrfs/delalloc-space.h
> index 6119c0d3f..58ecfad7b 100644
> --- a/fs/btrfs/delalloc-space.h
> +++ b/fs/btrfs/delalloc-space.h
> @@ -19,6 +19,7 @@ void btrfs_delalloc_release_space(struct btrfs_inode *i=
node,
>                                   struct extent_changeset *reserved,
>                                   u64 start, u64 len, bool qgroup_free);
>  void btrfs_free_reserved_data_space_noquota(struct btrfs_inode *inode, u=
64 len);
> +void btrfs_add_reserved_data_space_noquota(struct btrfs_inode *inode, u6=
4 len);
>  void btrfs_delalloc_release_metadata(struct btrfs_inode *inode, u64 num_=
bytes,
>                                      bool qgroup_free);
>  int btrfs_delalloc_reserve_space(struct btrfs_inode *inode,
> diff --git a/fs/btrfs/direct-io.c b/fs/btrfs/direct-io.c
> index 57167d56d..04cdf11d8 100644
> --- a/fs/btrfs/direct-io.c
> +++ b/fs/btrfs/direct-io.c
> @@ -205,8 +205,14 @@ static struct extent_map *btrfs_new_extent_direct(st=
ruct btrfs_inode *inode,
>         em =3D btrfs_create_dio_extent(inode, dio_data, start, &file_exte=
nt,
>                                      BTRFS_ORDERED_REGULAR);
>         btrfs_dec_block_group_reservations(fs_info, ins.objectid);
> -       if (IS_ERR(em))
> +       if (IS_ERR(em)) {
>                 btrfs_free_reserved_extent(fs_info, ins.objectid, ins.off=
set, true);
> +               /*
> +                * btrfs_reserve_extent() converted the bytes from bytes_=
may_use to
> +                * bytes_reserved. We need to restore them so the caller =
can free them.
> +                */
> +               btrfs_add_reserved_data_space_noquota(inode, ins.offset);
> +       }
>
>         return em;
>  }
>
>
> base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>
> See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patche=
s.md for information about AI-generated patches.
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
-upstream-moderation/07963d2a-cd0f-4940-a5bc-33dd8f425781%40mail.kernel.org=
.
