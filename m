Received: from mail-lj1-f169.google.com (mail-lj1-f169.google.com [209.85.208.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AFB9289340
	for <syzbot@lists.linux.dev>; Sat,  9 May 2026 07:24:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778311485; cv=pass; b=JuwLC+mw4oFNX/TvmU4yKpRm0d7nCE1ajDvIvuYaiRTw7ONj1GRDjsHrcZnGZNxo3zHTxIQDfOqjJ8OATPS3KjBZaLb5R4fO6ega22I+/JKV+APJ/3sKtplbh+hOHDL+E/2c9Zs7bkdubGCBDaR4gJunYa6C8eZhviXCQ9CWSxQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778311485; c=relaxed/simple;
	bh=zEE8PIfcdjiZuxXZ+EPpLJcBqUe3vqOism2tuu2ErFU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EiSe8q5fyhu6qcPmJ4G1P+BL6ITOXTc2SNnU8PfVJJ1mCmfpjJBOscYoH9Dn+jW0AsQhTBAbbQhicuQ8hjdGNwztGmuaItZOkEpevDxMuRCfuxY3DFMzgjgzFAk7P0P/9b3paW8OMEVG6N8330uGi4Ogl6iEtAgGJ0IyOM6jpFM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=vcICPLHp; arc=pass smtp.client-ip=209.85.208.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="vcICPLHp"
Received: by mail-lj1-f169.google.com with SMTP id 38308e7fff4ca-39380e79936so36404101fa.2
        for <syzbot@lists.linux.dev>; Sat, 09 May 2026 00:24:44 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778311483; cv=none;
        d=google.com; s=arc-20240605;
        b=c4kgRK+nTH4l3KdbF/D8jc54rRapqfOc3eLUL456XArlP/pZVfP52T3s1E8UvaTXNC
         Dnhbu3kM0/ikvj6vWiKFANmkU8LpyBmvhFD7iWzNWsDZdgPIMfiCfdqIlnNrgDCBSjc4
         MZnpYF6fQct+izZnq3lBcBFKxRxjScJNLOzdtB7m6cl6ahBKS/9C9sk89xCDU5PhQz2G
         HEzLK6wWFhZnBqPyZtCDHvrw/qIgGC3d2dPWFcllOj8IeGhKCCGY2zzD5/x3Wk2HYN/5
         f0FqO8IzrGQquc64nFLRc07y955GZ9eByxL9oA5Q2DxD7/HLHO7Z3Zqi4N3OcBWiXQI4
         MNFg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=vVHj/W6PxMObGvDrjtcWkxi+fV3eDyfWtbO12y7L2Rg=;
        fh=eJC4AREiFUxA73jviH6XWCmnRPzsboe8jsU8xnnr5q0=;
        b=iLu0kTu1w6gC1VDzmvn3T1xbpdPiwsDHp3gXOxkTtMDxPPNDM7sjtJKtk1tnA/tNXZ
         QWsPR01Uf7b8wr+XmD376XA2dtcH2SNRXkmZYrJm+PgSikcCFOKM4UJu5pf0d/TNcGyT
         3CU51IzpQTSM2XjXA5rQ4mLmnawqfTkpNKIlS6sCFswJW0lbDiS/4iDusiuEzCCwvc3q
         S0iEE3OQznpKuhfCyAKgrmBKsz+eZZLVdmUu+oEY+azDTFpt0AUYqObRsk3nRPEOOqQO
         wh+/ousbfkGL7hhtSjm6puP9MhxYcAy/EsCe6IPkPY4vKD0lCxdTIWt+PE2hercKMV5W
         6hCw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778311483; x=1778916283; darn=lists.linux.dev;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=vVHj/W6PxMObGvDrjtcWkxi+fV3eDyfWtbO12y7L2Rg=;
        b=vcICPLHpl24rBkGXo1M/MgRB0DBJNxB6/VMYCOP6HTfF79etuKZeNjE4PjoAChy5AU
         +cM4ADSBfwwyNMuxGv8w+xEUvCF8TLUfvP74NTJvowxDUPIEfv91gzu7GyLkz1re2Cv3
         J9K3+3br8RTGBbjkuO7oHVRuUt/esf9fdGgFiw/jKrT/mqPPF8ffCp67bspoGAaoqTdU
         bN0GKNN2EjdawvMJonfI087wJWkAq9WmRA5FOpaOxIdbdu/4wSKm6D8QM/A038LXirZ1
         Q3CimmXLDYLZf4csP/hfT3g9XzX4+pWvwqZctGts1xe8pcs7UEl9wcUZHvS6O4Sqc/on
         oG5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778311483; x=1778916283;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=vVHj/W6PxMObGvDrjtcWkxi+fV3eDyfWtbO12y7L2Rg=;
        b=mTl1qkJTPGOBquyxrvHelMDnKMCWhuO0zc5qgSwcPx9jPArUtAAWO/CjVf7eftSzGU
         ftnZvZg7XPXbMQDOJHkNJgM9jsYx87y0ZD4cdDovC5+6PSZWRZediM+yIp5pJc9x1xZr
         M8udd9OAjPOY+D/V2BtUvkB7txJM1FxgsIYQlM/ON5NFtdKTdpj86czV+g0BK6h/WGiv
         lySPyb5AbqnEFK3yu6CX9NFVVeUA9grhO672mf3ovyQs4ilgRr8WMXQqI/pCs0s6y/Vx
         rLf9bRpw+JB564KOYJkXejg/LdDM5PG3EKgc+o8W+Z2xbCt1Pe92SGje2VVUch+ruh4f
         7v6g==
X-Forwarded-Encrypted: i=1; AFNElJ/+jhx9klWkg4rCl3fR1DqylS1MbI3XOH4CZxWjQz+vLud81hR0KRfJAlzF1i6sKOcRm1FuQeI=@lists.linux.dev
X-Gm-Message-State: AOJu0YweZNCt/vM3rlaf0xl1asYg99jn3Ry1EX5ybfUfOt9eujx7KhlD
	X2wpAGJTPi/uIb7H2yMr10aiU3MhMCA7ieQjBtqIxxB4gycXzBHv1qPmp+zAaI7UsLytf+5Lz3+
	vGQk+/dA3sLBsj4YIglZnj3nrk9LXcoUaIU+ZDRDmQUrXxlHwjP6LPp8wlBE=
X-Gm-Gg: Acq92OEwavuaqHmaDtH6iRIhyn9PyDaqr9GDuAvYMIr4i94k1IIVkJVGMjd9dP8EXEO
	4Lry73++phnpMhneUJeNlCUSgSe1JZh35prTXm7SxOPaHfWZlvUBDXLn0nYy9/GtbBZYxOdZR4q
	R1k4U7u2hb4WUGWH8pY+RopESJY6QpX/VSQhlqkhlV4odQhyOAikJYCVlw7IKfyeQyQcyBBy5D4
	h0SW/NAdpAJzGyyeVdltajQtTCEFtxnQWwrCCcWz17DPn6A4wJEGCiy/tx0qlgf3JgPlYL34qc+
	bKsMxKjrV4S6DQ53enYO2uhH4AoBvAOxKA5zYawqwCdD1snhb2XMhFcLh46EcsnN7XMbtxGrgIF
	P0jmLk1nPaTTzuuo=
X-Received: by 2002:a2e:bcc3:0:b0:393:fe12:579c with SMTP id
 38308e7fff4ca-393fe1257f0mr16441251fa.7.1778311482079; Sat, 09 May 2026
 00:24:42 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <784d7c31-66f4-4f22-8115-2888a33b5260@mail.kernel.org>
In-Reply-To: <784d7c31-66f4-4f22-8115-2888a33b5260@mail.kernel.org>
From: Dmitry Vyukov <dvyukov@google.com>
Date: Sat, 9 May 2026 09:24:30 +0200
X-Gm-Features: AVHnY4LHbxN3oM1H6kz5BHYTCq3EK29-0pBrrnf1LzYNu2e0FL96WJFw3N8GwfQ
Message-ID: <CACT4Y+bwhBQ7iFEJaV4Q-V=6CGrfNArrkqf+Gb7E36XDHkrT1Q@mail.gmail.com>
Subject: Re: [PATCH RFC] jbd2: fix null-ptr-deref in jbd2_journal_dirty_metadata()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

On Fri, 8 May 2026 at 21:16, 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> jbd2: fix null-ptr-deref in jbd2_journal_dirty_metadata()
>
> The syzkaller reproducer triggers a null-pointer dereference in
> jbd2_journal_dirty_metadata().
>
> The root cause is that jbd2_journal_dirty_metadata() unconditionally
> dereferences handle->h_transaction->t_journal at the very beginning of
> the function. If handle->h_transaction is NULL, this causes a kernel
> panic.
>
> This can happen when a journal is aborted. For example, ocfs2_xa_set()
> calls ocfs2_xa_prepare_entry(), which attempts to allocate clusters for
> a large xattr and calls ocfs2_extend_trans() to extend the transaction.
> ocfs2_extend_trans() calls jbd2_journal_restart() to restart the
> transaction. In jbd2_journal_restart(), the handle is first detached
> from the current transaction (handle->h_transaction = NULL), and then
> start_this_handle() is called to start a new transaction. Because the
> journal is aborted, start_this_handle() fails and returns -EROFS.
> jbd2_journal_restart() returns this error, leaving handle->h_transaction
> as NULL.
>
> The -EROFS error propagates back up to ocfs2_xa_set(). ocfs2_xa_set()
> catches the error and jumps to the out_dirty label. By design, it tries
> to dirty the buffer to leave the xattr header in a sane state despite
> the error, so it calls ocfs2_xa_journal_dirty().
> ocfs2_xa_journal_dirty() calls jbd2_journal_dirty_metadata() with the
> detached handle.
>
> In jbd2_journal_dirty_metadata(), the local variable journal is
> initialized with transaction->t_journal at the declaration block. Since
> transaction (handle->h_transaction) is NULL, dereferencing it causes the
> KASAN null-ptr-deref crash.
>
> This bug was made more prominent by commit 4a734f0869f9 ("jbd2: fix
> assertion 'jh->b_frozen_data == NULL' failure when journal aborted"),
> which removed the early is_handle_aborted(handle) check in
> jbd2_journal_dirty_metadata(). However, even before that commit, the
> variable journal was initialized at declaration, so the NULL pointer
> dereference technically existed but was less obvious.
>
> To fix this, add an early check for is_handle_aborted(handle) (which
> safely handles !handle->h_transaction by short-circuiting) before
> dereferencing transaction->t_journal. The existing
> is_handle_aborted(handle) check inside the jh->b_state_lock is kept to
> prevent the race condition that commit 4a734f0869f9 originally fixed.
>
> Assisted-by: Gemini:gemini-3.1-pro-preview
> To: <linux-kernel@vger.kernel.org>
> Cc: <jack@suse.com>
> Cc: <linux-ext4@vger.kernel.org>
> Cc: <tytso@mit.edu>

Add Fixes tag:

Fixes: 4a734f0869f9 ("jbd2: fix assertion 'jh->b_frozen_data == NULL'
failure when journal aborted")


> ---
> diff --git a/fs/jbd2/transaction.c b/fs/jbd2/transaction.c
> index 4885903bb..183688035 100644
> --- a/fs/jbd2/transaction.c
> +++ b/fs/jbd2/transaction.c
> @@ -1517,10 +1517,15 @@ void jbd2_buffer_abort_trigger(struct journal_head *jh,
>  int jbd2_journal_dirty_metadata(handle_t *handle, struct buffer_head *bh)
>  {
>         transaction_t *transaction = handle->h_transaction;
> -       journal_t *journal = transaction->t_journal;
> +       journal_t *journal;
>         struct journal_head *jh;
>         int ret = 0;
>
> +       if (is_handle_aborted(handle))
> +               return -EROFS;
> +
> +       journal = transaction->t_journal;
> +
>         if (!buffer_jbd(bh))
>                 return -EUCLEAN;
>
>
>
> base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See  for more information.
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/784d7c31-66f4-4f22-8115-2888a33b5260%40mail.kernel.org.
