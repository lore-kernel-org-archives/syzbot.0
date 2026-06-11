Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5FF840D570
	for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 10:16:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781173013; cv=pass; b=ULUYP0lTYAgqhZgOCP9cJCUmp9PuaFugTs1SYvuK1Oe/QvTBHBGJVMmNJas4uDXhQ7iuRh4iq4FbtrChW9WfxhddEz4ozpEvuqiG5H3RyATY/GnjW5AJ0QrWuRrNgj9Alrzl8t+/cp3Xy0aDgBzClsEPl20CACX3m/sy0kO2C1U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781173013; c=relaxed/simple;
	bh=F019ol5Ffou9ln3Hz+38qDCSAaAIZNQhPC75Fww9bOc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZI+b5NLwVCW/vII3WNdj5oNnuzaBYNgZTchMv75XrACYo4OZyPHph7mf0CmYURFHvLOLn0u7iOliPk+GzrurleUzDCUVAztKeU6lwoe/NtHufgJNHfCcgO3PXaHvjRp8/yqL2KTYsLp1vRXYOkdIj440i2DD4LegjnIrJ6fExbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NjYgEKj2; arc=pass smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NjYgEKj2"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-43bfe055ffbso5472693fac.1
        for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 03:16:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781173011; cv=none;
        d=google.com; s=arc-20240605;
        b=FItOOc97Gl7b9P24InyG53gfMnskoX2fCI/LyYmHUAepNccTRfIF64DQ9Gls3VAky2
         1hrH7NCCVU+HwYj++6EiVlmrwpVfaSkqYG/XXBILYj8B1uaOEcfBy8IJNyv/aWBjKo1E
         koTdFCD1znjf8h5SqRzsJCGsLLktfg9NPjer5ohdZOlpEP/NpCWucsZi1kjGF/+ObLFU
         GFGxCtudPKXm1KyPl++hUjMn1lq+pQigR/UK+Ojg1HsYM7LClDNIFdet6My/vRI83Ytk
         p+R4mPfor5MGJH2lEktLPw0k+oE2n+UTQqo8J4mlEaQmtT+w2Jsae2hNJFnjLijNKOry
         mJ4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=j32jAfheTer6vyHMxSprTfnUi035niRTMuJnfRWSpNY=;
        fh=xqyfGzgWt9x1YIDs32e8VUYE3VceJffe8IhUjqbWPuw=;
        b=ax73rBPKrM1xSMc8W85LCyBOWaDRqx8qbEV7fT9uXoXLzqMLnnKGlwl7iIsvVr/+5X
         2glRoU4mpVuIilv/OYgxZT0eqbDFqunn8VVRHndXDzJUObWZWWB0tqYiKjIXovE3v5y2
         fDt7gX6uWTbt0RaoVqO7CnCpA5Fc9kmsjlNbU1C5wGhIwyMbDSeBLVyslwFTLtvrhC7g
         I5qlO8OvjBCnl+vukdQRQSomDvOyCVIzD6cqO7fMwlstafdOvhw1Pk7lwKNUvgw79uLb
         Q+YNbo/cIAa3wFry/wpEpvDx+lQ9gj0hjJs+X6D0i5SG8u11XBZbgqgilihEogVEf2nz
         ModQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781173011; x=1781777811; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=j32jAfheTer6vyHMxSprTfnUi035niRTMuJnfRWSpNY=;
        b=NjYgEKj2bYEIfnIHVMzHAgbfOdKL2ey7czOcdy4iZDYfyR3NwBOA6szbdJZJ6XzdNU
         AbRs6fP/F5a7mobirq+STkY8XJS/2Cc0wLwknlJz8e8GfK1t8VWzkS/0w4UF9kjGtD+h
         z72oWWGA+jOGN/pIhAyDDwupKc82GFCO82e7B8l2YJfcxWcqdDK/+sfV6X28v8MR9w3d
         wceSo35Ttz1dOgYj/hTKObEkgD98z4a3cGhw35WFXHs2EtBJvPrrx8buH2H62u7LFsIm
         JT63FH0z0PGLB4LODHlms95ApkKxPTiH0Y7Y5fZgTd1edgvQPtUCLmKjbnkI+0C5C2zx
         QChA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781173011; x=1781777811;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=j32jAfheTer6vyHMxSprTfnUi035niRTMuJnfRWSpNY=;
        b=WykTQH4Ma43MwbLFOPl86OWpWNUyAxFGzyy71JqlDX3jG7yzN6xuqg36DzjR0a68uN
         87EZEwrelbn04cN8bfsEM7Je7PX7l/ZdOB0/jsSp0udfw2qAxTDi9TtyJimqA4kNWuv6
         l2TOpxw29YI0pGwmmTWzOYEDKrBLM0dnqmuJhS6pavNyDB8rOVGXhoJTrtKw31vAZRBb
         vxNJl1LRlvTIM445ZrkdLa7O7lROTl451pJIaYe4MG8shbQl4Gr5G0RS8X0eMsxJwVCd
         eSh3FbXafLaA5vE7GVSUzhj/AipvCe/ButGi9ID1XZ4MQ8wiZKsWYdRSgM1dCHDkxZRt
         e74g==
X-Forwarded-Encrypted: i=1; AFNElJ+yZlXC8buH6oFOoY5dHcu5ExLNym14HqB3bRUKCkuywwfeJgiPkq3m3AX0BtI/Mr9cxxB2Uuw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+Uffknnc554qrxEnvD/3shL4d1SH57PyT/nJtBM1PT4uuEmn1
	AB4TKvaa/OQVpUYuqvDlLS4cTuy6U7GFZ5ngi1ClXhYo2DVEnujcQNyd3N2/R1/78TNo/Daoof+
	W6P8JahFQw5nck93nOFYo9AZdfeR2lb/Ck/MFOPeo
X-Gm-Gg: Acq92OFfj0Bv8U10Wyh6uuAo/aoKIpQrf4ofrIEY7YcdoIES/lPnLuq223yLeyoFh1Z
	mcUsERFqEyo0P/XmpYH89QdmDdYGfM2KfSrj2A5y5gbHjWCRDFnsy3qU42LeUThBLj9Y/xb1NhZ
	hIvLHdke8FZWdeSOxYc6F7KeHleyMUdq4QojEKwpBj7QZ03pkhBOT16T5XVgrXpeLJEsxT5VFYJ
	fqrB20xBLeMtG7rc0ZXoRu9xTBI80/L/uxaxFhRsKWBKabn2p/wMibtzAk2FYP6/JWnNW/w8r6F
	Rmn9FH3XuEUKtHQltuyiQbvzAxqCBvzbaD4TGNCry69q0YP7SubwZFQNhYtzwzerxnf71iC0x3d
	0c0BA
X-Received: by 2002:a05:6870:569f:b0:423:b2de:3b45 with SMTP id
 586e51a60fabf-44241d9ece0mr1328517fac.28.1781173010212; Thu, 11 Jun 2026
 03:16:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <008b2675-2e48-4150-a1ec-e68026253bad@mail.kernel.org>
In-Reply-To: <008b2675-2e48-4150-a1ec-e68026253bad@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 11 Jun 2026 12:16:38 +0200
X-Gm-Features: AVVi8CcHo7mnVT74LZm6qds-ggo5-KWWmG1eyLfwoZGt9xezD3P1BE2FPHnJoeI
Message-ID: <CANp29Y78NZkHVtj3ndD_0c-18_umDsWOWZEThTtMPaNocOCWUQ@mail.gmail.com>
Subject: Re: [PATCH RFC] ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, May 29, 2026 at 7:31=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A circular locking dependency can occur involving three OCFS2 system inod=
e
> locks: INODE_ALLOC_SYSTEM_INODE, EXTENT_ALLOC_SYSTEM_INODE, and
> ORPHAN_DIR_SYSTEM_INODE.
>
> The circular dependency is formed by three separate code paths. First, in
> ocfs2_mknod(), the code reserves an inode by acquiring the
> INODE_ALLOC_SYSTEM_INODE lock, and then reserves metadata blocks by
> acquiring the EXTENT_ALLOC_SYSTEM_INODE lock. Second, in
> ocfs2_dio_end_io_write(), the code allocates metadata blocks for unwritte=
n
> extents, acquiring the EXTENT_ALLOC_SYSTEM_INODE lock. Later in the same
> function, if the inode was orphaned, it calls
> ocfs2_del_inode_from_orphan(), which acquires the ORPHAN_DIR_SYSTEM_INODE
> lock. The allocation context is only freed at the end of the function,
> meaning the EXTENT_ALLOC_SYSTEM_INODE lock is held while
> ORPHAN_DIR_SYSTEM_INODE is acquired. Third, in ocfs2_wipe_inode(), the
> ORPHAN_DIR_SYSTEM_INODE lock is acquired first to prevent races with
> recovery completion, and then it calls ocfs2_remove_inode(), which acquir=
es
> the INODE_ALLOC_SYSTEM_INODE lock to free the inode.
>
> This patch breaks the cycle by addressing the dependency in
> ocfs2_dio_end_io_write(). The data_ac and meta_ac allocation contexts are
> only needed for the transaction that marks the extents as written. Once t=
he
> transaction is committed and the allocation semaphore is released, these
> contexts are no longer needed. We can safely free them, which releases th=
e
> EXTENT_ALLOC_SYSTEM_INODE lock, before calling
> ocfs2_del_inode_from_orphan(). This ensures that the
> EXTENT_ALLOC_SYSTEM_INODE lock is dropped before we attempt to acquire th=
e
> ORPHAN_DIR_SYSTEM_INODE lock, successfully breaking the circular
> dependency.

Let's rework the description a bit.
Include the original bug report (drop the irrelevant parts) listing
the stack traces of the circular lock chain parts. Still keep some
explanations of the existing code, but make it a bit shorter then.

>
> Fixes: d647c5b2fbf8 ("ocfs2: split transactions in dio completion to avoi=
d credit exhaustion")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Db225d4dfce6219600c42
> Link: https://syzkaller.appspot.com/ai_job?id=3Dc86e9953-fff6-40ca-b2f0-e=
ff12366a33a
> To: "Joel Becker" <jlbec@evilplan.org>
> To: "Joseph Qi" <joseph.qi@linux.alibaba.com>
> To: "Mark Fasheh" <mark@fasheh.com>
> To: <ocfs2-devel@lists.linux.dev>
> Cc: <linux-kernel@vger.kernel.org>
>
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
-upstream-moderation/008b2675-2e48-4150-a1ec-e68026253bad%40mail.kernel.org=
.
