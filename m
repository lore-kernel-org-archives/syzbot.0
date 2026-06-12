Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7748362152
	for <syzbot@lists.linux.dev>; Fri, 12 Jun 2026 09:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781257559; cv=pass; b=Lln/U4AwYV3gBZTdFbWl32rnHiL504gEeOIRam5wEhF+s7bfrhqb7QjwWVd4j6Gdf/oUdx86zUVfIgHSt9+ifGYWQIZaps9filsbKP6VrFqmnXrztgc2auH3rV+X3Z8w9ik9wMohw4xz3UH1yR3P0UmBScA/hR1ghwSi6sV5j0o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781257559; c=relaxed/simple;
	bh=LqrbKRl5tzzgX4v3/cZcAdBaM7lucmByH6TQ1YUylHU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZkdKNYXeQncfWx9WiLygHp4x3IITW6am3vq0+nW9iZLa1lF/vEJK43OMdfAlL9tfnXbRyIWbI+tQBrQffXXVRYNWDrnNUmEbNovbwTDAb5ox1mrMFDlsBqk6kRXerLsBUqHVua9jw3/HtkkP7jQM3Q0L93v5Qyd7iAK6YAR9q/0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=JCxNbqNc; arc=pass smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="JCxNbqNc"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-69e8d815c3dso374350eaf.1
        for <syzbot@lists.linux.dev>; Fri, 12 Jun 2026 02:45:57 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781257557; cv=none;
        d=google.com; s=arc-20240605;
        b=OVT7/aF9Iguh4Q51BRn6nYPvh7lbhqubkmxayJTJ1t+JbWSRL2B96ztrqyYHB3CYsi
         4ebzdRcD/BW1UuFk4/S9cpqLtWLYVel5dXsbCI38FBJ6IoRtVWBFLG4NjqtiqiOMvMGG
         7GYGx1iqZDBtlu0qJO/ggzJxgxmKAjF4D6BVpuqo1J0X1r7kvG6IKVxeGjW0Zxhzg2sM
         EAx606IrRIoq6MbkejmBKQgs7M+60plpE7DYM/PRmJI3ZQLdOCitrAWenlLy02rYZXyW
         rYRE4b8nd2DsxS5xbr8TGO8X4M6y2HbbyD8GL84s7L1RySzWmmh+/pIML6uzAMd3tMGa
         d1ig==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QK3MWKdO66xa+KYJVEwgibkKCQYUGo49Z+TFe2RXCxk=;
        fh=gZnazPvVnZMy7FKQs52CFVHDWtTRnuS56XEWs3wrbuo=;
        b=d7mldcg26ztRGjOfDiBboV6IXFb0aZBsGjRpIKRmyQeysEZWgFCF4reJVlHnLpQaXx
         FiEP0bq2bx0NorafD4DWKlf06GUs1OmabVvno5Fkp0WRozJStV51HD8fjbaRp7yiif/e
         pDgrGOioyKEgvRYatsCPfNOew14OCAEM6LuWTLzl7wArnnzW+vXL6fwrKwOtvjGKaa7I
         TzatvJL85nldswoZvU3ahsmxyIeGWsCSZVmyerXLU/JmYEyMEIk8M0O8o7pTLtMkEjlB
         aFvTzFwgyiy5LkSHT/Mj4gg1gyAWFd9PFsP2507+Dht3i/3AAfRyqkcvGUangQ2Ccd6R
         8fOw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781257557; x=1781862357; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QK3MWKdO66xa+KYJVEwgibkKCQYUGo49Z+TFe2RXCxk=;
        b=JCxNbqNcIcQafnumqRmMGx0sgx1w8R+5vqagT5j5V1ctdmRhNWqc3T71+qyCIEQBzd
         yYoAUv9g73W9DYYX8VhePQmN1jYvnJSlfTnY+QN9UGQ2ElTPO8zpV3e7dPfqlNULuF07
         rrTw/z0hTVRZcu/GIasmctgl9m68/y8sQylp8bmQzMHVt2N+AcpSac9aRSTP7be9C2Ai
         JrfwDbezE6wi/CM26ugX6f/dmL0tPmalhsJUoaOeaN4tINcToKcskd39+tie5b8dQz7G
         JbOvukPeCtJ7JVBxyOmLLpHRTSOCjbh1L6AjnAAmjrdIlPw+O5M0xfBG3sJXUiVrAuK5
         zOuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781257557; x=1781862357;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QK3MWKdO66xa+KYJVEwgibkKCQYUGo49Z+TFe2RXCxk=;
        b=ae0D3KfY03eEcN2Fx2tjmFr1GJpjny/OJEfptBwpsYcJWqGM/GY01yYCPgaxow5QmS
         i/iU9PQuLNN9DpqFpsNrZ6S/azSwXd5KINiNOCAsRrRzOGBsmG70a5WmhqNorzbJmrrx
         N1iEkIEjcdieBP4DyhogDfI3N2e74e/cNwFw3tHVLQK57cdasY2yNQf4vrnDaiF33TIu
         +LwZ2rVdABd8y0gK3yaP3zhj7Tde9ngFvCLJtcvQvr7mdN7oSenpoShN3q0uW9sKTtWM
         G79/C2SjfQbrp2lZjHC8crYM+ULrBLZY6++HFe8KkQHB1QcuGXphzdJa2NdByJxHvQ39
         96pA==
X-Forwarded-Encrypted: i=1; AFNElJ8tG+OK3rSwyWMX/kn/qZPpCUXcnm81gPqAAj2QT3LibfIEe/BuZ20XO/MVuLHg/aiQbh4Foi8=@lists.linux.dev
X-Gm-Message-State: AOJu0YyBBVnnlY6QbEStKeQD9gJW0t78wfa/3q7aXt7u8+Y6lPhrT6w8
	rQJFYvNHHlq1M2s1HxRUNGKSYokQO7kfe6Urn0BpW4vzL1rpHhQBvNVq1MWszfOd+jQ6tEqcMTl
	8J2TAzEFON9cTWpZ4WCgx2DFlTLPpFwQn8pq0o0Ox
X-Gm-Gg: Acq92OHohDwIEFOIZ8/p8X2iGm+vHu5pPqfZRxdmCJSCGiZRFnyfzmXL6ZbFSeHoXpv
	JQ3vKFiS/cm1B4vIup4h6BbitlpfwPifNRwjoa7pKREnHQtxdqFwmhTYssNnEZsxdft/6AaCiL5
	2a8SLEtSuo2tnNQEpDuvDq3y2Z2ZyOKsg2klTIEvcnqCXfvh6lTXtg0hp5g41BzI0euZIhNMkIN
	zG3MMpaA5eXKqCt4JLzJ2foa1FcyWq7lLGY+eBGGPfnIKVsqoYdVBtbK995qwWwpDw0S4QxKwbM
	1MvFmJo6jEBNfT4v/6sGP5kG3iin7/IIT6TVZXYwf1iKQd1Ix8K80/dtuGOgzpg41wJeNybv2Ig
	4EKY=
X-Received: by 2002:a05:6820:f0c:b0:69e:461a:d845 with SMTP id
 006d021491bc7-69edc639c8dmr1187155eaf.21.1781257556291; Fri, 12 Jun 2026
 02:45:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <008b2675-2e48-4150-a1ec-e68026253bad@mail.kernel.org> <CANp29Y78NZkHVtj3ndD_0c-18_umDsWOWZEThTtMPaNocOCWUQ@mail.gmail.com>
In-Reply-To: <CANp29Y78NZkHVtj3ndD_0c-18_umDsWOWZEThTtMPaNocOCWUQ@mail.gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 12 Jun 2026 11:45:44 +0200
X-Gm-Features: AVVi8CfS-2AFjTxQyHcCJ7cqK4ieK4RhoMI6Ei_kq-ZVJLLdX4NygZPqb2Z9XrU
Message-ID: <CANp29Y4cm-SfXgrijaR81sE9UGbEbVPUPALC2y0arWnvGbX71w@mail.gmail.com>
Subject: Re: [PATCH RFC] ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

* A comment to just ping the comment processing code *

On Thu, Jun 11, 2026 at 12:16=E2=80=AFPM Aleksandr Nogikh <nogikh@google.co=
m> wrote:
>
> On Fri, May 29, 2026 at 7:31=E2=80=AFPM 'syzbot' via
> syzkaller-upstream-moderation
> <syzkaller-upstream-moderation@googlegroups.com> wrote:
> >
> > A circular locking dependency can occur involving three OCFS2 system in=
ode
> > locks: INODE_ALLOC_SYSTEM_INODE, EXTENT_ALLOC_SYSTEM_INODE, and
> > ORPHAN_DIR_SYSTEM_INODE.
> >
> > The circular dependency is formed by three separate code paths. First, =
in
> > ocfs2_mknod(), the code reserves an inode by acquiring the
> > INODE_ALLOC_SYSTEM_INODE lock, and then reserves metadata blocks by
> > acquiring the EXTENT_ALLOC_SYSTEM_INODE lock. Second, in
> > ocfs2_dio_end_io_write(), the code allocates metadata blocks for unwrit=
ten
> > extents, acquiring the EXTENT_ALLOC_SYSTEM_INODE lock. Later in the sam=
e
> > function, if the inode was orphaned, it calls
> > ocfs2_del_inode_from_orphan(), which acquires the ORPHAN_DIR_SYSTEM_INO=
DE
> > lock. The allocation context is only freed at the end of the function,
> > meaning the EXTENT_ALLOC_SYSTEM_INODE lock is held while
> > ORPHAN_DIR_SYSTEM_INODE is acquired. Third, in ocfs2_wipe_inode(), the
> > ORPHAN_DIR_SYSTEM_INODE lock is acquired first to prevent races with
> > recovery completion, and then it calls ocfs2_remove_inode(), which acqu=
ires
> > the INODE_ALLOC_SYSTEM_INODE lock to free the inode.
> >
> > This patch breaks the cycle by addressing the dependency in
> > ocfs2_dio_end_io_write(). The data_ac and meta_ac allocation contexts a=
re
> > only needed for the transaction that marks the extents as written. Once=
 the
> > transaction is committed and the allocation semaphore is released, thes=
e
> > contexts are no longer needed. We can safely free them, which releases =
the
> > EXTENT_ALLOC_SYSTEM_INODE lock, before calling
> > ocfs2_del_inode_from_orphan(). This ensures that the
> > EXTENT_ALLOC_SYSTEM_INODE lock is dropped before we attempt to acquire =
the
> > ORPHAN_DIR_SYSTEM_INODE lock, successfully breaking the circular
> > dependency.
>
> Let's rework the description a bit.
> Include the original bug report (drop the irrelevant parts) listing
> the stack traces of the circular lock chain parts. Still keep some
> explanations of the existing code, but make it a bit shorter then.
>
> >
> > Fixes: d647c5b2fbf8 ("ocfs2: split transactions in dio completion to av=
oid credit exhaustion")
> > Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> > Reported-by: syzbot+b225d4dfce6219600c42@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3Db225d4dfce6219600c42
> > Link: https://syzkaller.appspot.com/ai_job?id=3Dc86e9953-fff6-40ca-b2f0=
-eff12366a33a
> > To: "Joel Becker" <jlbec@evilplan.org>
> > To: "Joseph Qi" <joseph.qi@linux.alibaba.com>
> > To: "Mark Fasheh" <mark@fasheh.com>
> > To: <ocfs2-devel@lists.linux.dev>
> > Cc: <linux-kernel@vger.kernel.org>
> >
> > ---
> > diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> > index 6ec198bda..4acdbb708 100644
> > --- a/fs/ocfs2/aops.c
> > +++ b/fs/ocfs2/aops.c
> > @@ -2372,6 +2372,15 @@ static int ocfs2_dio_end_io_write(struct inode *=
inode,
> >  unlock:
> >         up_write(&oi->ip_alloc_sem);
> >
> > +       if (data_ac) {
> > +               ocfs2_free_alloc_context(data_ac);
> > +               data_ac =3D NULL;
> > +       }
> > +       if (meta_ac) {
> > +               ocfs2_free_alloc_context(meta_ac);
> > +               meta_ac =3D NULL;
> > +       }
> > +
> >         /* everything looks good, let's start the cleanup */
> >         if (!ret && dwc->dw_orphaned) {
> >                 BUG_ON(dwc->dw_writer_pid !=3D task_pid_nr(current));
> > @@ -2383,10 +2392,6 @@ static int ocfs2_dio_end_io_write(struct inode *=
inode,
> >         ocfs2_inode_unlock(inode, 1);
> >         brelse(di_bh);
> >  out:
> > -       if (data_ac)
> > -               ocfs2_free_alloc_context(data_ac);
> > -       if (meta_ac)
> > -               ocfs2_free_alloc_context(meta_ac);
> >         ocfs2_run_deallocs(osb, &dealloc);
> >         ocfs2_dio_free_write_ctx(inode, dwc);
> >
> >
> >
> > base-commit: e7ae89a0c97ce2b68b0983cd01eda67cf373517d
> > --
> > This is an AI-generated patch subject to moderation.
> > Reply with '#syz upstream' to Sign-off the patch as a human author
> > and send it to the upstream kernel mailing lists.
> > Reply with '#syz reject' to reject it ('#syz unreject' to undo).
> >
> > See https://goo.gle/syzbot-ai-patches for information about AI-generate=
d patches.
> > You can comment on the patch as usual, syzbot will try to address
> > the comments and send a new version of the patch if necessary.
> > syzbot engineers can be reached at syzkaller@googlegroups.com.
> >
> > --
> > You received this message because you are subscribed to the Google Grou=
ps "syzkaller-upstream-moderation" group.
> > To unsubscribe from this group and stop receiving emails from it, send =
an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/syzkall=
er-upstream-moderation/008b2675-2e48-4150-a1ec-e68026253bad%40mail.kernel.o=
rg.
