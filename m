Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83F321FA859
	for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 15:20:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781882406; cv=pass; b=ql9LJJ+8Te4k2qb+GXNKEJEYCfgOy0FeNf/08d4oplTkWikMgp0uivbHnjbrL7QRpLc1JQCZ1QokT3dLk6nUwocAf5GB8ALLJbj+65nyJ5ySIW1Zqe+tajN0f6wa3YE8XSwhpD1OEdr6oZVyYkyMakF25UlCPmg7i8fI911F3y8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781882406; c=relaxed/simple;
	bh=k0kUloLglbNVLg+ik3nPC/FMnbYHBLa4d2kAi/T56A0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=m8Tg27aHG30AWfp5LHSNM9kHDHz5lXy2RRCCiUJ1QoVuU+SPpNRoitRdUVid82Ilcvk4z830NvE8AtQli0U2NnXN1w/Vly0c496+qWeLiH8hKXdW0jgVfxbDJvruuWweVIVlHl6v43c1GNlNlo2AOwSOlTTUIoysd3iNmTf02Wc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nGCqTueI; arc=pass smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nGCqTueI"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-7e93a16acc6so317206a34.0
        for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 08:20:04 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781882403; cv=none;
        d=google.com; s=arc-20240605;
        b=LqpO/YIan6oOJDNSqgVQGxLsLftj80hiiO4Q73Hi3LxLju1ARNmWwATM96/EuTPNbm
         cBmiabdaVw4uTkb4oTCEqFyZ31gumsU3pm2gae4GQoB0R0DN0eUv2f8+1dRLsGhSpENQ
         8d4oGJ90PGmrpO9iO5qxfMvXyhPBj/nc41/nr+U6wA1dFht7ifdRDA7axM+d6mFLYjYz
         i1jVUMPCrtG1XJYMBWdIaBrqyeBLf2N+ycWT5KetMbUElTHK3xTqfCOZL5UhEpG28Rwu
         AqrGMD5JeXAJBRcYEaZc55P0guaYwjGd+W8Z7T3GdhjAIVttC819WpBQv7Wb3XYLlm+o
         tlXA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=BEU4aDLbv28Ud5Rf9IpkX7de4JUh2WseAOF2Q6cu4Ws=;
        fh=WNmYDSUpWCVzP9KTx1vPAnOu7fT1o3iwthXqshNAbDY=;
        b=VDJo+ttUEwzpUZZVIzpGlhdoSolnINcwD+358lUSlhnsSPGmIO0XYd32jTeIFqld+G
         51V4KsL2sEXG18j9lSg3ZxqOatlxdvFmLx5zE7CMqh0slvLV7tQQXUdf03EUCh08fEky
         O+kHC5NS3WnLYywT/amFyM3pP0hnqAcGpKEQ0cbf9yxjMXYfmndVpyjYaDQk8uP3sy5u
         HtrLfW3CGigKAKe3meNFcIErsxAHMbcfR1xmGmPfp3nlKMnLRbjESsFx83P7fxVZwyP5
         6MFqbQgLZHFQM0olpexQEV8MF/kmLegHi7N+tR2C1ilDdx1HWuZxqQJiW3gcUG6+Bix1
         Bk8w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781882403; x=1782487203; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BEU4aDLbv28Ud5Rf9IpkX7de4JUh2WseAOF2Q6cu4Ws=;
        b=nGCqTueIyvPL1DqQCo3770gqcW1VcS54O4Gdq3HB8mk2sKFtxmDR0eAZcTKpyouG/O
         VVYguQ7dD+wDz2hTEXXncaRZfd3idFX1rjQ2/VwwKupRGBMhRwszVOPI8w+puix/lv2J
         Nv2AoF/b/qCJ1UJcalcHijo4vaCR1/jP/sSPbJ+M9n0WhSJEXIFBNncSnivxyH+pAYwb
         /fNiZwjVpifYxZ5YltCfcXaj2cY6g1HRsyWVZfTmDtz5E0Ifn/7VEXhRL5nIv1j0JS95
         83zyaHiHLUL1ZpW7FgZw9K2EpLEbOhALOMN5Q5bbVtERE0Xd0o6X0qmYRVdXlpMFft0G
         lA3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781882403; x=1782487203;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=BEU4aDLbv28Ud5Rf9IpkX7de4JUh2WseAOF2Q6cu4Ws=;
        b=NLXfAopeoXIObkMCPHUdjDKZUord5bdA8mvA42ob6KNoSE3q7bP1MV644kGX36dhY3
         nV1E9Wrw37bhPweQf88xeQSuEBDHzUHDdqX/vhDpvOmYrFX7dXaZbJuAF+KeQ8RfwMZV
         CBmfsB1f84pyQNwSjbe0g7GRUcvsC4+kYiUItWNxQtDUScocI0RV5cb3quYQNXHAzrbk
         a9VH3apklDa3h8dsSoNUunBCMU7vjCV2mx6nVD/dSmjUnlrbDhBPBUNW/gqn1Fllso3N
         UDwJ/Lt3SxJpUokSt03ou/tX/UsOnrjSk2MwAAu+eDuJbLw8Dpnc5ayF5AF8h+SHcWUk
         CRYg==
X-Forwarded-Encrypted: i=1; AFNElJ+BYF1wbg8/s7UKkaamJglCCSmqARZ5gpDBQicDMZ719+VHgyCzJYsgnEdB5IuG67nzieSgEgk=@lists.linux.dev
X-Gm-Message-State: AOJu0YxZjvgBbKjTq/eBjCFBssqW9naeMvLtFPuxJ3ZgcCY0beew+gWh
	E0tGaftDKZ8RXaA8TMm8++NKhcyQm7m6A7aCNRSsJxLa7lZNwHb0bRsmHPqMHIeh5Vh1s2nVswa
	uhjaup644keBYf8Cp+YIcwndCJ7cDMJ031wkgpyo7wt9LjqZJd2JZq0cFMrTw6A==
X-Gm-Gg: AfdE7cnFNl6x2V04T4cb96l4kxSQf5rtUoI61x1diqeyy2TbLVXsdveAhOy5cwQflhU
	V1RgG+45WgZYplOTtITmqgtUNaX9vyFAuLOYOEaKdkmshOnQyBkdS+kzdBKeB73+Pw5yz+xMf5n
	51A/p2YyIXM9CBcO4I8V8s8jW/328UgXbS5xwVoQa9QheTt/i2MlwaF357x8sySjUsUkQFJVFLw
	beNP04R0kjrlTGZiLXcdJJY+LcT2AFUagEMUhzw6fwDr/GOLAdyCQgi6XBBDAA+2zzEladgiNC3
	01/aKnnPMsKYk2lflIlOIlN3D2YZclDq9GAFML3QHc7wqYcPdewfLC0ZCSKQSjB7Ny23ul92iqH
	kH+o0OpTzm6NLVzpU3/ge
X-Received: by 2002:a05:6808:3008:b0:479:f370:fac0 with SMTP id
 5614622812f47-4896aa678c6mr3321478b6e.18.1781882402851; Fri, 19 Jun 2026
 08:20:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a51a0826-f36a-4cef-8945-c9968b232f22@mail.kernel.org>
In-Reply-To: <a51a0826-f36a-4cef-8945-c9968b232f22@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 19 Jun 2026 17:19:51 +0200
X-Gm-Features: AVVi8CddH7moo0cSQHe9ivGFfvkBk3_sydrMO6IeghUE58bcwkT7WAK93ufCXpU
Message-ID: <CANp29Y41Hp3hg2X-+C=MFRnR+30LFB-mjv9WzbtKHqcUP0B4TQ@mail.gmail.com>
Subject: Re: [PATCH RFC] nbd: fix resource leak when device is abandoned
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

The reasoning went astray since the reproducer crashed as `BUG:
MAX_LOCKDEP_KEYS too low!`. The agent started fixing a completely
different issue.

#syz reject

On Fri, May 29, 2026 at 10:12=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> When a user-space process configures an NBD device via netlink but exits
> without explicitly disconnecting it or opening the block device, the NBD
> device and its request queue are leaked. The leaked request queues hold
> dynamically registered lock classes. When this happens repeatedly, it
> exhausts the MAX_LOCKDEP_KEYS limit and triggers a lockdep BUG.
>
> The leak occurs because the initial configuration reference (config_refs)
> is set to 1 during configuration. If the process exits, the sockets are
> closed and the recv_work threads exit, but the initial reference is never
> dropped unless the device is explicitly disconnected or the
> NBD_CFLAG_DESTROY_ON_DISCONNECT flag was set. As a result, the device is
> considered in use and skipped during subsequent device allocations, leadi=
ng
> to unbounded creation of new devices and request queues.
>
> Fix this by scheduling disconnect_work to tear down the device when all
> sockets are closed and the disk has no openers, even if
> NBD_DESTROY_ON_DISCONNECT is not set. This ensures the initial
> configuration reference is dropped, allowing the device configuration to =
be
> freed and the device to become eligible for reuse, preventing the resourc=
e
> leak and the lockdep crash.
>
> Fixes: e46c7287b1c2 ("nbd: add a basic netlink interface")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview =
syzbot
> Reported-by: syzbot+6279b273d888c2017726@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D6279b273d888c2017726
> Link: https://syzkaller.appspot.com/ai_job?id=3Df2b193da-12d6-456c-8401-8=
680f8682836
> To: "Jens Axboe" <axboe@kernel.dk>
> To: "Josef Bacik" <josef@toxicpanda.com>
> To: <linux-block@vger.kernel.org>
> To: <nbd@other.debian.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index fe63f3c55..d31c8e5e3 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -124,6 +124,7 @@ struct nbd_device {
>         struct gendisk *disk;
>         struct workqueue_struct *recv_workq;
>         struct work_struct remove_work;
> +       struct work_struct disconnect_work;
>
>         struct list_head list;
>         struct task_struct *task_setup;
> @@ -322,7 +323,15 @@ static void nbd_mark_nsock_dead(struct nbd_device *n=
bd, struct nbd_sock *nsock,
>                                 set_bit(NBD_RT_DISCONNECTED,
>                                         &nbd->config->runtime_flags);
>                                 dev_info(nbd_to_dev(nbd),
> -                                       "Disconnected due to user request=
.\n");
> +                                        "Disconnected due to user reques=
t.\n");
> +                       }
> +                       if (test_bit(NBD_DESTROY_ON_DISCONNECT, &nbd->fla=
gs) ||
> +                           disk_openers(nbd->disk) =3D=3D 0) {
> +                               if (refcount_inc_not_zero(&nbd->refs)) {
> +                                       if (!queue_work(system_wq,
> +                                                       &nbd->disconnect_=
work))
> +                                               nbd_put(nbd);
> +                               }
>                         }
>                 }
>         }
> @@ -1904,6 +1913,8 @@ static const struct blk_mq_ops nbd_mq_ops =3D {
>         .timeout        =3D nbd_xmit_timeout,
>  };
>
> +static void nbd_disconnect_work(struct work_struct *work);
> +
>  static struct nbd_device *nbd_dev_add(int index, unsigned int refs)
>  {
>         struct queue_limits lim =3D {
> @@ -1928,6 +1939,7 @@ static struct nbd_device *nbd_dev_add(int index, un=
signed int refs)
>         nbd->tag_set.flags =3D BLK_MQ_F_BLOCKING;
>         nbd->tag_set.driver_data =3D nbd;
>         INIT_WORK(&nbd->remove_work, nbd_dev_remove_work);
> +       INIT_WORK(&nbd->disconnect_work, nbd_disconnect_work);
>         nbd->backend =3D NULL;
>
>         err =3D blk_mq_alloc_tag_set(&nbd->tag_set);
> @@ -2272,6 +2284,14 @@ static void nbd_disconnect_and_put(struct nbd_devi=
ce *nbd)
>                 nbd_config_put(nbd);
>  }
>
> +static void nbd_disconnect_work(struct work_struct *work)
> +{
> +       struct nbd_device *nbd =3D
> +               container_of(work, struct nbd_device, disconnect_work);
> +       nbd_disconnect_and_put(nbd);
> +       nbd_put(nbd);
> +}
> +
>  static int nbd_genl_disconnect(struct sk_buff *skb, struct genl_info *in=
fo)
>  {
>         struct nbd_device *nbd;
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
-upstream-moderation/a51a0826-f36a-4cef-8945-c9968b232f22%40mail.kernel.org=
.
