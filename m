Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379191E5702
	for <syzbot@lists.linux.dev>; Sun, 10 May 2026 07:02:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=10.30.226.201
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778396578; cv=pass; b=kjPNeJjZRacS16imbNZdMi6PwHsTO8eDoUtvo2l9gPoaC5DFwQQV1S56W9FhSGb9/f+3U7FzSWNViFMKd8KispCM4B2aJFIAlxY2Si/2aw7P0se3kQe5fKGZxurLP0RI3spHFqSOJO+Qm0WY6BmmYV1SEdwYIE4tXjxVmM27+ks=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778396578; c=relaxed/simple;
	bh=B8bxjfwhyT9wuO8Zjt29zpVT3CH3/ldIAkPhLQOTPjM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VabWaAa1/buLpi1HP/dTXcI121q05NvUoU8JTUQ/rIzWpJL7IUl2pDa04kq9MTTKTIWWHyORZdNo2cNWQDzSve8ldS9kB8oPkz4l4tbXJsYusXlR6pAbb8jJ/yPwsAuNU++mEEPzmz/vr4zFGEZ2dxSbLsQi2Pmv15LQfV/PunM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Sng8WE3k; arc=pass smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Sng8WE3k"
Received: by smtp.kernel.org (Postfix)
	id E0F43C2BCF7; Sun, 10 May 2026 07:02:57 +0000 (UTC)
Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id EDB28C2BCB8
	for <syzbot@kernel.org>; Sun, 10 May 2026 07:02:56 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org EDB28C2BCB8
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-463f00cda04so1817975b6e.2
        for <syzbot@kernel.org>; Sun, 10 May 2026 00:02:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778396576; cv=none;
        d=google.com; s=arc-20240605;
        b=MGbo27/2TlYB7puu6rdxhozrCz8JOxv8I2S2qz4IQz+5jkgQXD82bwrUfK9/MCuGP7
         9pWxuHQuHqmfoqq68eUpy93dPJMqpb9xXXU/te8fUixPPODd9okhH9LVQmK2w0xs23Xf
         dUx7GUixnBe4JOn83ERgoy2BPgIt48RDIvh06P3wcnqlhnVEn5DKt03VVg1yxui+GoMl
         UphfYvbZsiMikVMpo2DZyErkdUGzrlU9Lq1Rr3dN3NYSO7dw0d7oslYHcT2lhHO9Ukx0
         gJYOGsJu+QZdkEeHRnRy61eh8wwCMBMm65DyO1rYxC7RgqpZ3Q8gVZEWlwCcfmDHOR7d
         tAtA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1oeS3OgYc2teKSYgpoVrfEAHSNhP/3JjevrqVXCzcdQ=;
        fh=wDINbZTynOzHKZZdfYzTv1C5XrcPd39poBV3E5XRpBc=;
        b=XsVqXnNRuINyb/7VULckJBI4KXp7xmH/l/s4qRSdGiEpzND37+3ZxSipsVRmji/iWx
         7jupCgFT4+xQJQx6uh28g1EzO/rnfc+uyFV7hpL/JVWy/8qmAhLz5jD50SGBwsqojqzq
         Yohcr9TDxoAwSMWei44noWfUjH9fz37DlClhlRxufH+r/73a50IXp7sfb1/YosJnwmbd
         32HoDP4owNp7FEXoXzvSAYNSog/SkaFiKtqisIiCMy+YTMtzV9DXXd/dxwBhF6HgMaY+
         MTKkiaDQUOfLBgni97gNXK/WDAIy4zxo0RB0Zg8kO3GIQJZtxqCWjm24tcRPuskTVk5S
         BmaQ==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778396576; x=1779001376; darn=kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1oeS3OgYc2teKSYgpoVrfEAHSNhP/3JjevrqVXCzcdQ=;
        b=Sng8WE3kVof5eGwrbId8K9veOvsHn1LrGzbAzsA1ml4yaQmy4J8t0ez1izygvZDj2L
         lDUV58ConHtPz4j+GZ8sbZOXHQshLXHQI9XOy4bctJ9CsQ3Fi2d0FwSwa6SaM4728FHl
         IMrS7R4ImeBGs4TXGT6EZ0Xg9YvlAJLSxE26lfD2Y3oJbjQLAgmoxpwUbW1ysZyK3ij/
         WFuT0C/GTaKEDzVvUhBl0zUbrnjZ92fhxUr4Vi7BwoonoWWjnCyINtAbkiHzEIdmtEpn
         IOXSZXS/4YqBakWgSh1fwKk2LDElX7wQov+rHpPz/HcDx+rh9rpy4nUGOCvrEhFBf0C/
         mykg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778396576; x=1779001376;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1oeS3OgYc2teKSYgpoVrfEAHSNhP/3JjevrqVXCzcdQ=;
        b=Y2kdLPKXGpCwnkwJMZxDICIFirNYZKFbQW6tVo3XG7VSTM+yvj67vloa34AMmd/jjt
         o1b5ZFMVbT/SqUWALJovhvZSczQ7tv7/ymkuy5VIG0OfxfCuAnhJaUs/MSWcvbxL8nto
         Wmtke5nhc+H6IAHCNE2hou2leWKiYCs615PppJBqo9szlLWjkA3EtBMETq1ldvQzVU+E
         KA0Lq87TIvuHZEVGU1kC/f+3ljWyMqIvityeFsiKBSNIJGSgMUbSFpIbcyhMsh5sf3Sp
         vCXxKdznWDfhiM+OdDBT2w9IlGhW7l2rMUTCJZlWaM6q4lmJPSIppXsn8MKTzfJnjjit
         j1gg==
X-Gm-Message-State: AOJu0YzNts1DvHfmXUIIWStMElco2IrCaZppZAn20IpaMkEin8qRLeqo
	3/dgEosZjQo3bA4JFtzNLgVXoTJ0HY3Eg8uZu/a+HMNl2UkHg8Vt8fgzkxkGbwjJOybS3yWu/yT
	fDd/u7171Sw6PoXcU3AkMphBkkyHI6MTQ7i9F7CvB
X-Gm-Gg: Acq92OEhX+51hvUuFXj7ERjhl3OviGm8jinukwM9w3+qazD09Dq58jGMrwUEQmCRKy5
	Myw5821GgSjmbpcT+y0KrQGSRVozKVuBXd967QhSCtL+jFNCEi/YnYcQYGy2EYQmnsGHCTSUzpA
	tl428V+TSYVvz0yssKs3FrUGFcea2QLUk4cS0qRechzTTd6vOx4K6fxSE0OD8cR/TkxRR5cQrgD
	L/uTH7zvdk7bWdYBSr+/1De1yVJ0nS18NoVCU4FeN6VaDH5u1aJAeCJcWlmctQYEtHYGAG1cxEI
	ddDL97p8XkyI47EIw8uMqKMf0u1n3Rc/oxCljoQgfGtSxKs2HSulnwMHWko3JKMyI2jJZ6GtSBW
	rbA7Z3P7iJGq1Wnqc5Q==
X-Received: by 2002:a05:6808:1688:b0:46e:df55:2403 with SMTP id
 5614622812f47-480421e6728mr11897610b6e.18.1778396575315; Sun, 10 May 2026
 00:02:55 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <784d7c31-66f4-4f22-8115-2888a33b5260@mail.kernel.org> <CACT4Y+bwhBQ7iFEJaV4Q-V=6CGrfNArrkqf+Gb7E36XDHkrT1Q@mail.gmail.com>
In-Reply-To: <CACT4Y+bwhBQ7iFEJaV4Q-V=6CGrfNArrkqf+Gb7E36XDHkrT1Q@mail.gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 10 May 2026 09:02:44 +0200
X-Gm-Features: AVHnY4K7-g0diFVWc6EKyqRtwjXctKbK8DgW1Su2_r0IlkYiqknIrKMbQducrGY
Message-ID: <CANp29Y7u3VJ_70+Y_v_WWXnxD3JCDA_vSt=AxJn11VUwYRHnMw@mail.gmail.com>
Subject: Re: [PATCH RFC] jbd2: fix null-ptr-deref in jbd2_journal_dirty_metadata()
To: Dmitry Vyukov <dvyukov@google.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com, 
	syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sat, May 9, 2026 at 9:24=E2=80=AFAM 'Dmitry Vyukov' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> On Fri, 8 May 2026 at 21:16, 'syzbot' via
> syzkaller-upstream-moderation
> <syzkaller-upstream-moderation@googlegroups.com> wrote:
> >
> > jbd2: fix null-ptr-deref in jbd2_journal_dirty_metadata()
> >
> > The syzkaller reproducer triggers a null-pointer dereference in
> > jbd2_journal_dirty_metadata().
> >
> > The root cause is that jbd2_journal_dirty_metadata() unconditionally
> > dereferences handle->h_transaction->t_journal at the very beginning of
> > the function. If handle->h_transaction is NULL, this causes a kernel
> > panic.
> >
> > This can happen when a journal is aborted. For example, ocfs2_xa_set()
> > calls ocfs2_xa_prepare_entry(), which attempts to allocate clusters for
> > a large xattr and calls ocfs2_extend_trans() to extend the transaction.
> > ocfs2_extend_trans() calls jbd2_journal_restart() to restart the
> > transaction. In jbd2_journal_restart(), the handle is first detached
> > from the current transaction (handle->h_transaction =3D NULL), and then
> > start_this_handle() is called to start a new transaction. Because the
> > journal is aborted, start_this_handle() fails and returns -EROFS.
> > jbd2_journal_restart() returns this error, leaving handle->h_transactio=
n
> > as NULL.
> >
> > The -EROFS error propagates back up to ocfs2_xa_set(). ocfs2_xa_set()
> > catches the error and jumps to the out_dirty label. By design, it tries
> > to dirty the buffer to leave the xattr header in a sane state despite
> > the error, so it calls ocfs2_xa_journal_dirty().
> > ocfs2_xa_journal_dirty() calls jbd2_journal_dirty_metadata() with the
> > detached handle.
> >
> > In jbd2_journal_dirty_metadata(), the local variable journal is
> > initialized with transaction->t_journal at the declaration block. Since
> > transaction (handle->h_transaction) is NULL, dereferencing it causes th=
e
> > KASAN null-ptr-deref crash.
> >
> > This bug was made more prominent by commit 4a734f0869f9 ("jbd2: fix
> > assertion 'jh->b_frozen_data =3D=3D NULL' failure when journal aborted"=
),
> > which removed the early is_handle_aborted(handle) check in
> > jbd2_journal_dirty_metadata(). However, even before that commit, the
> > variable journal was initialized at declaration, so the NULL pointer
> > dereference technically existed but was less obvious.
> >
> > To fix this, add an early check for is_handle_aborted(handle) (which
> > safely handles !handle->h_transaction by short-circuiting) before
> > dereferencing transaction->t_journal. The existing
> > is_handle_aborted(handle) check inside the jh->b_state_lock is kept to
> > prevent the race condition that commit 4a734f0869f9 originally fixed.
> >
> > Assisted-by: Gemini:gemini-3.1-pro-preview
> > To: <linux-kernel@vger.kernel.org>
> > Cc: <jack@suse.com>
> > Cc: <linux-ext4@vger.kernel.org>
> > Cc: <tytso@mit.edu>
>
> Add Fixes tag:
>
> Fixes: 4a734f0869f9 ("jbd2: fix assertion 'jh->b_frozen_data =3D=3D NULL'
> failure when journal aborted")

FYI it won't work yet - the patch-iteration workflow doesn't have any
way to modifiy the tags at the moment.

>
>
> > ---
> > diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> > index 4885903bb..183688035 100644
> > --- a/fs/jbd2/transaction.c
> > +++ b/fs/jbd2/transaction.c
> > @@ -1517,10 +1517,15 @@ void jbd2_buffer_abort_trigger(struct journal_h=
ead *jh,
> >  int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *=
bh)
> >  {
> >         transaction_t *transaction =3D handle->h_transaction;
> > -       journal_t *journal =3D transaction->t_journal;
> > +       journal_t *journal;
> >         struct journal_head *jh;
> >         int ret =3D 0;
> >
> > +       if (is_handle_aborted(handle))
> > +               return -EROFS;
> > +
> > +       journal =3D transaction->t_journal;
> > +
> >         if (!buffer_jbd(bh))
> >                 return -EUCLEAN;
> >
> >
> >
> > base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> > --
> > This is an AI-generated patch subject to moderation.
> > Reply with '#syz upstream' to send it to the mailing list.
> > Reply with '#syz reject' to reject it.
> >
> > See  for more information.
> >
> > --
> > You received this message because you are subscribed to the Google Grou=
ps "syzkaller-upstream-moderation" group.
> > To unsubscribe from this group and stop receiving emails from it, send =
an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/syzkall=
er-upstream-moderation/784d7c31-66f4-4f22-8115-2888a33b5260%40mail.kernel.o=
rg.
>
