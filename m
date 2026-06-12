Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3811B3E92AC
	for <syzbot@lists.linux.dev>; Fri, 12 Jun 2026 11:47:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781264856; cv=pass; b=toUthkef8jEV4TTTl3rlX88YWrsnV6ZFqYcymEVO3QgDcmRzY0eElyxVKUh+jhDK3DKxbg5KCjcULrwIrM4L0U1CLIQJWttX64kSmMX75Dgojfctg1IH3gql9qraoi4Fkg0hEZCd9hHFKF2a8CKMUmMmUDjlO+1z9x4vJfWgFFE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781264856; c=relaxed/simple;
	bh=6W4Gxcv9qZjzai78ZPMe0AwBGVZUriCRONvat+LqLcg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T/rfwRYeRvbfiImsK0QAwgfM7OccHQqD+ayinFLkUnS8grssPYiQ6GyiRkAqrw4DL99JYlK0WHdtWugK+Kaviiofo5gpaX8TD0Um2HFwaoKw3u7RQLayIHSR3qeoCpiAfhA3CoNFZ+UbOZoRRzc01hgLrj3kCK6G1ufW6YBAV6s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wROPy/aI; arc=pass smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wROPy/aI"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-69e46524711so586025eaf.0
        for <syzbot@lists.linux.dev>; Fri, 12 Jun 2026 04:47:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781264854; cv=none;
        d=google.com; s=arc-20240605;
        b=Bm3p0eL5JHA3mYWEoYnDTYuUUxKeaYksAKaSf1nQtxEVA2CjkZqHCBsWX4mI0HtLdh
         sNdY7qec+pymcQXIwYDK62g7WRC13za5OGG7b0ouPHNqoFXZYuuj+UtpFdJoo97tm89K
         4bpitxNQw9MXSpoCW+Y6I3BVBqy+kRb2LHqftYndH0+aq0EB3gvDJ7tMR86ODWlLb4lW
         Lw5rh9OJgceJxcoTNuZXvLhT61Uh5+uuBqK+/d5PDXL8YD/yj69EJJPEraikIq/uVGDR
         GIn6sdhhiniHnVwxjZjagOL4Z6G4h4Iz1xa71NanK4QbxJqX801f2J/VyE6A7v9kueqD
         stCQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=WJfQL6gb+dRepo1p/rEbTI+u25dPKIX9SSRxsaJEK9E=;
        fh=VREZqlSl+Z1t2XFw4ktz9/VdwgZOlx7ZdZm+axH0KbM=;
        b=VsodyJhhZS6IqFHEQ978wY0h5vRmMTAPK29wbncf12dWdav3KuHBLbwyGBmaB+i0Uw
         ADLIYDGgLg1QKeyJ0O+b8QH1BRpC5/30VpHV87bGiMaWI3Ap1zugZxi/U0GS+SDSnJGY
         vgdixVkk9FaeC+V2zPVEaP337m69NCQ65TaIHjGI5c4R8NtAq4pcCsDzivosp06vv2v9
         yitBK1N+wo2NcTfJKnWAzainOi+/DsOm05skmIVFN7HvJ4Y8TWO9LJsyBZ0jQ5XBQOJS
         k59qpIGxQkOKT4XxS8W54DugtGhra5dvDf0fBFmaMR8yZpA+J+ahAkr5YBh2cKBeIS0t
         rgPw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781264854; x=1781869654; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WJfQL6gb+dRepo1p/rEbTI+u25dPKIX9SSRxsaJEK9E=;
        b=wROPy/aIUvTk2k3GM6tUrUNcQeSWpay8skYw+9kHYS/6jCc/c2SXKkLoLQzZ7f/p/8
         osGAFutRalF1JEmMJG4nRJ1+AKN2mvI8jo7f3BS1jUn/PYTiQjoq19hGsh6pXhmfg0py
         glwhFwFnM5uyyHtufR3P0G4RX1NScvlbwIOKavWEq/BoxleMJx83P//8WnYn+hDOY32H
         VZa7B+dgKiUPvVncnuVXS74jwlvMWBIowtbeF8bDrbRuznnFeBAGLxa8lk5zFS3BNfI4
         icwG9ny0uaNhJfzrWjufKh47Ne4r2OFSU2p0ACuOlrPPE5gmyIAojplRwTr+oCHmSdSp
         C4zA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781264854; x=1781869654;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=WJfQL6gb+dRepo1p/rEbTI+u25dPKIX9SSRxsaJEK9E=;
        b=GCm3AmjcSgJB602bCf1VN6z25rxoNrAvnzXw/eM1XwwdoOSkvWHULYjJShcYILGIiW
         Dvh1W5krRe1pj6iTONWJz2KsaBzbJXo5Iq0blvD5TQ0VE9vw0joZvPuY8h1iAB4Qvalo
         vT38TZeVoGw7KbAObVdBmemgTJjgTcmdGDW0/bmYvY2xVkaORyMcvaaMyhRNa5/jp4FJ
         8h0jXPk9/iNVrBZQjd2dpCjNWniyd0onmmdQi3s3baUt0B0mMO5kXAP8Oe1YsakQtJJ2
         o2OvJfeiEaozNTwXdkfxng0x5mBjJCL2Q2gO9GPVC8Trjcpu4yIFsumuy2ASUXIMWfuf
         GhVQ==
X-Forwarded-Encrypted: i=1; AFNElJ/+R2TJcYcXewFg+b4ts05st5nOTuRaAB/Ij2C6C98v3vf0h+8noRtp/6boDfdezx/ohTzD0WU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxiChJK2Ojq6oVwpSg9Akq4OZe4Y8/r6K3QdiyvDcjTmp30dlOm
	KkTphXkQShIgpsafMRN/fX6DCB29IzZ1Hvxjr8GvSJ5Z+aTbiy1nZjq9vx3F+lNRibGmNjURF+d
	A0ey6WlBCbMZZweBo1Kp52Xy6JR5Ts3BUXs8FDXDf
X-Gm-Gg: Acq92OHYdj/bMgTydmw+tYskKr+qP25pPvUeauSbziU3bc995jwF3WaC/Ny/qjT7ruC
	i8FjQ7lqd6QQA/UX5OT0fQGlqwq5csObrQ5O3ssUl1EFP4rwNOEERgDHIuNVwXGapCzK27BHDyV
	5v6A0CKo+xla9DMvOgv93aIF3VGsZG9cQ8o6JgH5cItFkhCUpa5mo21Th/5xWaPQ2duj7HQAzjY
	qTYHZXuhEdj9/CGa+nGcvSBvePMRNTTNeYEsfLnxjhDjcsHJ3hmjlUOnE+kdCp+0TchKKTHnOSk
	K3apFksWF5k1kFtrDpw3Tlq2K0q374Og69Db2DR99QEJASbWz3Ze672LpLqUk3DLJl+w
X-Received: by 2002:a05:6820:4cc8:b0:694:96b2:9943 with SMTP id
 006d021491bc7-69edc758669mr1576323eaf.37.1781264853649; Fri, 12 Jun 2026
 04:47:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <f225bc9b-5627-4e50-8c55-d81f26e581f8@mail.kernel.org>
In-Reply-To: <f225bc9b-5627-4e50-8c55-d81f26e581f8@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 12 Jun 2026 13:47:22 +0200
X-Gm-Features: AVVi8CcCaVPFFSNy-JH4LfrbpDEcB8nTR3E2-nmQZ07pRZmy7b8LbM470Ph3o0I
Message-ID: <CANp29Y4yv=xb08xxm14+MW1HYuubz3PMDNPw7N4+-eN59nN0eg@mail.gmail.com>
Subject: Re: [PATCH RFC v2] ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Jun 12, 2026 at 1:40=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A circular locking dependency involves INODE_ALLOC_SYSTEM_INODE,
> EXTENT_ALLOC_SYSTEM_INODE, and ORPHAN_DIR_SYSTEM_INODE.
>
> 1. ocfs2_mknod() acquires INODE_ALLOC then EXTENT_ALLOC.
> 2. ocfs2_dio_end_io_write() acquires EXTENT_ALLOC for unwritten extents,
> then ORPHAN_DIR via ocfs2_del_inode_from_orphan() while still holding
> EXTENT_ALLOC.
> 3. ocfs2_wipe_inode() acquires ORPHAN_DIR then INODE_ALLOC via
> ocfs2_remove_inode.
>
> Break the cycle in ocfs2_dio_end_io_write() by freeing the allocation
> contexts (releasing EXTENT_ALLOC) before acquiring ORPHAN_DIR.
>
> WARNING: possible circular locking dependency detected
> ------------------------------------------------------
> is trying to acquire lock:
> ffff8881e78b33a0
> (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}, at:
> ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299
>
> but task is already holding lock:
> ffff8881e78b4fa0
> (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}, at:
> ocfs2_evict_inode+0xe97/0x43b0 fs/ocfs2/inode.c:1299
>
> the existing dependency chain (in reverse order) is:
>
> -> #2 (&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]){+.+.}-{4:4}:
>        inode_lock include/linux/fs.h:1029 [inline]
>        ocfs2_del_inode_from_orphan+0x12e/0x7a0 fs/ocfs2/namei.c:2728
>        ocfs2_dio_end_io+0xf9c/0x1370 fs/ocfs2/aops.c:2418
>        dio_complete+0x25b/0x790 fs/direct-io.c:281
>
> -> #1 (&ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
>        inode_lock include/linux/fs.h:1029 [inline]
>        ocfs2_reserve_suballoc_bits+0x16d/0x4840 fs/ocfs2/suballoc.c:882
>        ocfs2_reserve_new_metadata_blocks+0x415/0x9a0
>        fs/ocfs2/suballoc.c:1078
>        ocfs2_mknod+0x10f3/0x2260 fs/ocfs2/namei.c:351
>
> -> #0 (&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]){+.+.}-{4:4}:
>        __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
>        lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>        down_write+0x96/0x200 kernel/locking/rwsem.c:1625
>        inode_lock include/linux/fs.h:1029 [inline]
>        ocfs2_remove_inode fs/ocfs2/inode.c:733 [inline]
>        ocfs2_wipe_inode fs/ocfs2/inode.c:896 [inline]
>        ocfs2_delete_inode fs/ocfs2/inode.c:1157 [inline]
>        ocfs2_evict_inode+0x1539/0x43b0 fs/ocfs2/inode.c:1299
>
> Chain exists of:
>   &ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE] -->
>   &ocfs2_sysfile_lock_key[EXTENT_ALLOC_SYSTEM_INODE] -->
>   &ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SYSTEM_INODE]);
>                                lock(&ocfs2_sysfile_lock_key[EXTENT_ALLOC_=
SYSTEM_INODE]);
>                                lock(&ocfs2_sysfile_lock_key[ORPHAN_DIR_SY=
STEM_INODE]);
>   lock(&ocfs2_sysfile_lock_key[INODE_ALLOC_SYSTEM_INODE]);
>
>  *** DEADLOCK ***
>
> Fixes: d647c5b2fbf8 ("ocfs2: split transactions in dio completion to avoi=
d credit exhaustion")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview =
syzbot
> Reported-by: syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Db225d4dfce6219600c42
> Link: https://syzkaller.appspot.com/ai_job?id=3D0b53ce1e-2972-4192-aa85-8=
097a702762c
> To: "Joel Becker" <jlbec@evilplan.org>
> To: "Joseph Qi" <joseph.qi@linux.alibaba.com>
> To: "Mark Fasheh" <mark@fasheh.com>
> To: <ocfs2-devel@lists.linux.dev>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Included the lockdep report in the commit description.
> - Shortened the explanation of the locking cycle.
>
> v1:
> https://lore.kernel.org/all/008b2675-2e48-4150-a1ec-e68026253bad@mail.ker=
nel.org/T/
> ---
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 6ec198bda..4acdbb708 100644
> --- a/fs/ocfs2/aops.c
> +++ b/fs/ocfs2/aops.c
> @@ -2372,6 +2372,15 @@ static int ocfs2_dio_end_io_write(struct inode *in=
ode,
>  unlock:
>         up_write(&oi->ip_alloc_sem);
>
> +       if (data_ac) {
> +               ocfs2_free_alloc_context(data_ac);
> +               data_ac =3D NULL;
> +       }
> +       if (meta_ac) {
> +               ocfs2_free_alloc_context(meta_ac);
> +               meta_ac =3D NULL;
> +       }
> +
>         /* everything looks good, let's start the cleanup */
>         if (!ret && dwc->dw_orphaned) {
>                 BUG_ON(dwc->dw_writer_pid !=3D task_pid_nr(current));
> @@ -2383,10 +2392,6 @@ static int ocfs2_dio_end_io_write(struct inode *in=
ode,
>         ocfs2_inode_unlock(inode, 1);
>         brelse(di_bh);
>  out:
> -       if (data_ac)
> -               ocfs2_free_alloc_context(data_ac);
> -       if (meta_ac)
> -               ocfs2_free_alloc_context(meta_ac);
>         ocfs2_run_deallocs(osb, &dealloc);
>         ocfs2_dio_free_write_ctx(inode, dwc);
>
>
>
> base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
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
-upstream-moderation/f225bc9b-5627-4e50-8c55-d81f26e581f8%40mail.kernel.org=
.
