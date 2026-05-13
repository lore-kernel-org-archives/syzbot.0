Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35B232D7DEA
	for <syzbot@lists.linux.dev>; Wed, 13 May 2026 20:10:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778703031; cv=pass; b=rc1GxPKddIpa4VSrkbFk+vSUIbSl/tOriOkfTrm4O+OlcL2KPrSy79//LLs0DMilpzlTNwtN5DdcNfBVgA44HYnRBe7E3HCKB8dLl21zX1CicQQztPscw64STQjLhbchhSkIzpZBXFq2HMB7lXwoPQkmSzyRxJNWrr5zl6yuCpY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778703031; c=relaxed/simple;
	bh=Lc/lPe2mD9GOPpL0oqV3kvkcEMmXVaC4YFW59bJp52Q=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lrrnQCkrnYkWd9PljJKtAsf2jowirfkDM/VIxwe6d3I9zxxJf7kx0itw+nVdaXPUT21VDRgaa0sJ6Tw6t2CbSK3V+Vpoj50RXYNXtulsEyTf1UtC7LUzC4yqEkt2kjqloTHmKFIqccIyhQUzMvh3inEJzsNDJDoJ7836j9Ic62s=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=o0mAkBSr; arc=pass smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="o0mAkBSr"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-47cbd444fd0so4611820b6e.2
        for <syzbot@lists.linux.dev>; Wed, 13 May 2026 13:10:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778703029; cv=none;
        d=google.com; s=arc-20240605;
        b=UWaDzRA56m73gFUtTwInT4z0CLcJpI+3r/kGauqKfgdNRdGPe1Q8gccYrbsu/EF/28
         yuq9ofSTWsf7WrZ5qaEMUv2Llo75xHPH7GlAHzl1f29AslOi76e7xNZXloLs0HOjaICq
         IIh735E/lfgHrQNtDcn7FQCbrk5O1rm1qw9mDTLrJgkvaiYRWF4fAIa9IQy4gcEuPbb9
         yuLb8iw/N1VnPEXBt9MuHrlQ7Nsjx1Aub8gFRLXvwbinNYeD+BHlRLrddkbrdWmXoEh5
         xavq4oGi9X7Ftgb0kShTkPZncQ+HEJmNUPRxcaqL3lpaoHw1viwwR+I93XT9n0aFfuP+
         76bw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=L1frj75fxHl6xHoOCETLJbwzBjaxlsgKh3PJVftjKbo=;
        fh=F9g0Jt+DUS7dS0xjqEOgiX3OvxwpEojx3jfdrclZmlk=;
        b=RI2b8Mac2JIVpR8lmWtAsOT+Cegu185d3Mai0ahnAnoK7bb4kVmXgW2jmqVp1WaNdH
         TkEpSdGCrYi/8O4VsFNtxwOxd1RmSm5RtoMVziyVYP2aWErrnK4AZ2iKOiCfpPgaoEDT
         RaxdXS7s8Lau1rIi4m/4Hujs35zbbSxWpsDjxp7kfUIgv3xhLLfCbqFhbq5Ufkip6AIo
         gvy4NvXK3haDLEK0fzawdlwLcs6APqJweHGeMPRZSA38NiuIwCtkBkU5mLRSPbGh8pMn
         pcvqG+GSGjk42DKHYt8rQpMW4icnBl5GhRxpioOc0Qiw/w0mAGZ0EdXBjQjmprKn1qjK
         877Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778703029; x=1779307829; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=L1frj75fxHl6xHoOCETLJbwzBjaxlsgKh3PJVftjKbo=;
        b=o0mAkBSraAybNyRACtu2it/ZDefqZHz3/jtxsNnUHqi3UWbaEeevwzReK3qAi2sxd+
         ZQ0yMqi8HkSoU+lu7MiF6Imk+2XPuSDDYmuq5XKlLkv8R7xtqrLEbrz0jk2vwTYr8SLJ
         fiw0eXKrJ68FmndM+IX2RVHydXy9p0syoNP9+zfGGheK1DEtT6yCfoFk9DczMS86VlSM
         k6yNKz7r2eHujP50ULIRu3t5kpz6fdnNNB3Z7jJJtIVBPW5q06aMteCFEbc80BklkMna
         /lnH+KXFQP0N/iOrMFrqce/9A5Ml3xDqgGPuCMVqjk+EMuWNXj3D+RMmkSIIG4myGpDn
         YnGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778703029; x=1779307829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=L1frj75fxHl6xHoOCETLJbwzBjaxlsgKh3PJVftjKbo=;
        b=lv3cU/nA5hPy/hXvv7hn2nBEG7UXt3XoheBi2xFt0A8qtpSMPqoP1Cj1deZpTUj6Vd
         nwOS++PND3wGYNNZx0AjvdoYPHzlIUR0+XoH4SSZSXxj3QDjEN8Jwje2ISH00+unvFXA
         iEBJLtG1LMj+WQOPMh7tc4PkL6g0E+DT8+GQQ1nwxBfHOfo+R5sbQwDue+c+MKHqidO3
         sUww/Oga7wugfc4uHRi3N2FLItBvweTCRUzlAkzwN3S07mncgNoka3R6zI4styDSrR7R
         yCkElbJSH9mbgAhiKGhvsQtFmOpe6feLAUknTjUkfEUKNc1GWYN+b93Ym/E81dbC+eh3
         nWbw==
X-Forwarded-Encrypted: i=1; AFNElJ8QqVmtEtCGIEN7DWW2nUuZnTyALbvjffihHRvA12XffsdRQo+tv5GDR036fSHblA2lPbAzFbU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy/DbGAGU71sLi+YSotcWU7cen29FWt7KAuaGn6nE083JtpFlwK
	V+fGNcWwps3knIAA5Q9VwxEmoNRKYMhs5Wnpvye4y+ak5E/BalAODOIr0BDxLSIl/45y3B0aRT+
	ZEF1oPgCJ5i6NU30cTdWfvyNhq/ZLMis8osXXvNE4
X-Gm-Gg: Acq92OF160RA1NKtN7AgBzNHdr9G1SkQyWxC9WQTdhZmsgpYI0K1AZlbRKZ9PQSQq/q
	krmduGh5/gQ14uiAg348S9Z/kxxIvKecnANFJC2Fv74gdkVC52SgYHCSlpgebIaQqokg9Pes0X6
	N6ElkJIvkTUlN3Na94ym0RTJ8Ehc2/CNSsUCgUK8J6ybTjh0mCl60viXklX3pO8fPZarpg69M9G
	HAIxdpNt/XfOj1hcJmc2Bxnfwr014iKFGHAxuYYiXEuoXQ6UykTn1+PAORGvc2J1azuLPfu2Y0P
	CQcAzSf+RTfufTNWwdxjxMgfUdKA70giT/55e65D4hAOPPU3HSQvp9huU8G/tfOQKr5pRBcDMWg
	GqeeLc7o=
X-Received: by 2002:a05:6870:96a6:b0:439:bd77:bc43 with SMTP id
 586e51a60fabf-439d30179c2mr2584729fac.33.1778703028635; Wed, 13 May 2026
 13:10:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <1500143f-7374-4e4a-9260-3961428b155d@mail.kernel.org>
In-Reply-To: <1500143f-7374-4e4a-9260-3961428b155d@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 13 May 2026 22:10:17 +0200
X-Gm-Features: AVHnY4JbJ8utsjHExLpYm11jXaRiopuLDyWNfmZxlahJgyzcXydq9L6sSdI7keg
Message-ID: <CANp29Y6Y5e0oYJJ9C6kXvGxfsiA84qehTRdXwK1sfL=wPMxHqQ@mail.gmail.com>
Subject: Re: [PATCH RFC] ocfs2: fix circular locking dependency in ocfs2_dio_end_io_write
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

What is the difference between meta_ac and data_ac?

On Tue, May 12, 2026 at 11:34=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A circular locking dependency (AB-BA deadlock) was detected between the
> ORPHAN_DIR_SYSTEM_INODE and EXTENT_ALLOC_SYSTEM_INODE locks in OCFS2.
>
> The first path, ocfs2_wipe_inode(), acquires the lock for
> ORPHAN_DIR_SYSTEM_INODE to prevent concurrent recovery from truncating
> the same file. While holding this lock, it calls ocfs2_xattr_remove() to
> free extended attributes, which in turn calls ocfs2_xattr_free_block().
> To free the extent, ocfs2_xattr_free_block() acquires the lock for
> EXTENT_ALLOC_SYSTEM_INODE. This establishes the lock order:
> ORPHAN_DIR_SYSTEM_INODE -> EXTENT_ALLOC_SYSTEM_INODE.
>
> The second path, ocfs2_dio_end_io_write(), is called when a direct IO
> write finishes to mark unwritten extents as written and update the inode
> size. It calls ocfs2_lock_allocators(), which acquires the lock for
> EXTENT_ALLOC_SYSTEM_INODE and stores it in meta_ac. After performing the
> necessary transactions and committing them, if the file was orphaned, it
> calls ocfs2_del_inode_from_orphan() to remove the file from the orphan
> directory. This function acquires the lock for ORPHAN_DIR_SYSTEM_INODE.
> However, meta_ac (and thus the EXTENT_ALLOC_SYSTEM_INODE lock) is not
> freed until the very end of ocfs2_dio_end_io_write(), after
> ocfs2_del_inode_from_orphan() returns. This establishes the reverse lock
> order: EXTENT_ALLOC_SYSTEM_INODE -> ORPHAN_DIR_SYSTEM_INODE, leading to
> a potential deadlock.
>
> To fix this, release the allocator locks (data_ac and meta_ac) before
> calling ocfs2_del_inode_from_orphan() in ocfs2_dio_end_io_write(). The
> allocator locks are only needed for the transaction that marks extents
> as written and updates the inode size. Once the transaction is
> committed, data_ac and meta_ac are no longer needed. By calling
> ocfs2_free_alloc_context() on data_ac and meta_ac right after the
> transaction is committed and before ocfs2_del_inode_from_orphan(), we
> release EXTENT_ALLOC_SYSTEM_INODE before acquiring
> ORPHAN_DIR_SYSTEM_INODE, breaking the circular dependency and preventing
> the deadlock.
>
> Fixes: d647c5b2fbf81560818dacade360abc8c00a9665 ("ocfs2: split transactio=
ns in dio completion to avoid credit exhaustion")
> Assisted-by: Gemini:gemini-3.1-pro-preview
> Reported-by: syzbot+7df4afa14aeda476a7a1@syzkaller.appspotmail.com
> Link: https://syzkaller.appspot.com/bug?extid=3D7df4afa14aeda476a7a1
> Link: https://syzkaller.appspot.com/ai_job?id=3D4acc303c-bf15-4295-b70b-d=
13d7ef6a323
> To: <linux-kernel@vger.kernel.org>
> Cc: <jlbec@evilplan.org>
> Cc: <joseph.qi@linux.alibaba.com>
> Cc: <mark@fasheh.com>
> Cc: <ocfs2-devel@lists.linux.dev>
>
> ---
> diff --git a/fs/ocfs2/aops.c b/fs/ocfs2/aops.c
> index 6ec198bda..74b41709b 100644
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
>
>
> base-commit: 5d6919055dec134de3c40167a490f33c74c12581
> --
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to send it to the mailing list.
> Reply with '#syz reject' to reject it.
>
> See  for more information.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/1500143f-7374-4e4a-9260-3961428b155d%40mail.kernel.org=
.
