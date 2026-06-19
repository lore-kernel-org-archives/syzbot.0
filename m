Received: from mail-oo1-f46.google.com (mail-oo1-f46.google.com [209.85.161.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBF0E368953
	for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 11:05:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781867137; cv=pass; b=GiynHvvrv09bi7PKhqx+HSVeOlQ7d+aTsnVTAkY57cK4rY2aVNRHaBFZihvqkIgVKZmFNUCqCNOGfBa543OO5NEXSfJKRF1jS55QnlDjqfyx/kY6QH5d/LEpWeAHyCogMjfp4WsOKjzsM7noLY9bYZgvGmnFwcjyVwUYEx7RZR0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781867137; c=relaxed/simple;
	bh=C1GJhgQEOcOhEoZZeB1RrjstEqLs8/7KuR7N3LAngW0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RXQMiYsYaph7/aK26ypwokCKdIXF4fcKE+l02e57Cyd6rP1STG05OuHXotRqHPdKLk3McDOnKmo6qbWNFAKaeofuIFWJ9Aav6kqTzTKTLCI+CbHjZRRUl6N7El/ThruKr05yo/jWw2WlHhJ9DLxzp+VUROVvry2ISdSuxY4g318=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TroLzmez; arc=pass smtp.client-ip=209.85.161.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TroLzmez"
Received: by mail-oo1-f46.google.com with SMTP id 006d021491bc7-69e1f777bcaso1831712eaf.1
        for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 04:05:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781867135; cv=none;
        d=google.com; s=arc-20240605;
        b=aSYXmw5k4LBxC0HmBt1auB8sJe8UgenJKZGPmI3MYqEg9TCoWURy7RhkcSFA7EWFkC
         v8cyHcntKCEoQ6IMsbZyVLYKnHFJ7XrIByfwKYN88/4xRQoXfe6073SD22zGJdPCViEu
         4AAwn9JWALe1d/S0L6g7cBH8ZFTUHMLX4pWr/8LQnd++0Okzb0kgj97JwfIQapENeBzi
         /W6T0tsOF+4c2dPk/UO/ZZuCWM3nWT7J2Em9w8qMuN4gYn9SIyweOEZ0dMit5EYt0km6
         9eWNfJac/row/f1z0cE/GQg3B3VwR5uWbOUYlCbJnXcKpldPdrmdgDpaGUqdvsh9klkq
         DXSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wdz1hsqkFsX3ZECvYdhE+QaGcqZQpJc9ibX25ThJPTg=;
        fh=r6EonbNVz4ko4xboHnuJcvdblJojQAO8BzxCDfzgMik=;
        b=fFRVbzgSsWH+Qzy/Bb6i6wR9AMIXwB4UlGBIrR1HNzD1DEqxFcE9h6U4ISra2dPXL/
         GtCfzhhe0UCiYaR2zNtHHU7fYno0U4nfccua+S7VzfL3ZdmP7S9g8VsIJMgF0wRWr6/R
         KxFPpWb4cZYLOMK98TqQRgQbqFjrolcwwHulBS3o1sGmMoe6qRsjB7b09DVsJcSHr0Rz
         DK7+qbCK166vNhI0p9i+T+1Ctgfu155vZyuA+yvzHIkLvvB2SlfpNB4VUXnOhiLRAlrN
         xooTigATF6gnXgKH8ha/xbE+NYzRzI/JsEZAWYtcay3PMjF+LV+H3l3f+6+Q2AUnvoeK
         5czg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781867135; x=1782471935; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wdz1hsqkFsX3ZECvYdhE+QaGcqZQpJc9ibX25ThJPTg=;
        b=TroLzmezmtlyD6H/qzA/K4FNTCRCiwkeOntG5RRXfOnWV6xMGNZfJx2JqJ3LqnrHSf
         JuVegXDmHAUMUUKtER/NXZls/4fHWjLZ0rBYt1Ism8A/FnnWenutHQGPHfFr4UPKxsZ3
         QtPFHEr9uBdborx5eeEZ+9UVeQb2+kToeesN9EtyiSBd7I0zlDTPBL9nBc9LNVwb2+ir
         13YeMttnz0NoJxKzclqzORYTPPB9p/EoOl0679FFCsPmpRjioLs49vEPUk1+2gaoBmBh
         UMLGXHk+q8cm/yze4dVhS06heBdvwWov9WRjbH+gUkBOdX4iY6PL/h1xGM37W2COc8Oq
         Gceg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781867135; x=1782471935;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wdz1hsqkFsX3ZECvYdhE+QaGcqZQpJc9ibX25ThJPTg=;
        b=KNQcWA3W9mV0dkcFUhfqnNfkhcvDOqo/4cCTaW4zWyZrA/ay6zULJx7o9tFwgrKLdy
         VIBpBenED3ZOfxEnCmMzyFevjrWT6rgQad1cySupmX9grexaxdQsLKMz/zEEFMn6L8n1
         2yu6gcK1GqE8WssUqyeftpjHLZbJwIaYqmvYZsDBM0ES7xXyGOH9p3EJ7cpbXFHgDY4l
         F4i0rCRJAXRoVZWS2HU6YV3VgcmhUON37IaWWTk1zvDkZGHha+PROwAN/3+r4Fjh3lLR
         DKTMUjU+0TPfb9C140TyRe+jimdiPN3wad+5Rl86M2GCvHH2t/7UnIdDmDaghatb2qVY
         /e1A==
X-Forwarded-Encrypted: i=1; AFNElJ/vRcDtqKN6qQQVbAK9vKUzMW8gLyRXrje19gY/wDoEW9jlKGQALdaG/rnhtJbaUOuhk6nOwjY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzAg/90WqocPfSOG2e/xbYZjg4MKf1aWRnEMWn57WacH8/MMvXc
	Suu3v5uvuiagWcJevzYrI+T/pQb5hcV1LAebPTXxW3gYN/M/Jo4PFukIoosRuwLItchtAC0bhLS
	HFwIZQBQ9kfK73WrWAjCwRekk7s5Uk8U2Va3R7p6u
X-Gm-Gg: AfdE7cmoGHXbaUV4LWJFEhkHhTEzj8tE1PZnEfiMz3rzidgzn+CLFFHxKxbIn3PXwcB
	IfQkXXsUIZVo1e0dkePL6g9S0sAm3pXH5Iavj4dsosI4kZnXhlghcd0o4YfxGWUqfjHnp6GORuf
	sc4I6f/WGMF9JDg6jWVm0SP9GSkLGDDMmNzUv9JGnrSNh5rWQ7QRTDiFd+C2Ki7mOr0n+mJCs/i
	AjLLm/Jwmvw1Ij+7J/dN2v4wKcmnCk+0F9cDi4H2pcMEAMDlJzICOPqAR2Fm+W1BDE+2h8xo3sy
	ww5QFhlcEcS7Us+UeBxXRBui1s4N3G7RV8hplbtKsQViV7qLS/ljQ3oX65DmHDY2CSN/M+sCr+m
	FlkWy1gdPHNRiP7V9c9nX
X-Received: by 2002:a05:6820:1624:b0:6a0:c431:4166 with SMTP id
 006d021491bc7-6a0d9c2d577mr1660684eaf.0.1781867134092; Fri, 19 Jun 2026
 04:05:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <b2de6fa2-bc67-45a6-abb0-35868b40b0da@mail.kernel.org>
In-Reply-To: <b2de6fa2-bc67-45a6-abb0-35868b40b0da@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 19 Jun 2026 13:05:22 +0200
X-Gm-Features: AVVi8CeXCT9xsyN2_YuxE-6UReZycBISmlvoX7ldAVG2VGGycZhImuc5mfhQybM
Message-ID: <CANp29Y4KzjjKukZeXfhm8AD+Pv7tkT=u3JqnLr93XyW1wc5+TA@mail.gmail.com>
Subject: Re: [PATCH RFC] netdevsim: remove debugfs files before freeing netdev
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Should we explicitly save the debugfs folder pointer and call
debugfs_remove_recursive on nsim_destroy?
Cleanup should be symmetrical to resource creation.

On Fri, Jun 19, 2026 at 11:16=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A KASAN slab-use-after-free bug was detected in debugfs_u32_get(). The ro=
ot
> cause is a race condition between the destruction of a netdevsim port and
> the cleanup of its associated debugfs files.
>
> When a netdevsim port is destroyed, the teardown happens in
> __nsim_dev_port_del(), which first calls nsim_destroy() and then
> nsim_dev_port_debugfs_exit(). nsim_destroy() eventually calls
> free_netdev(), which frees the struct netdevsim memory. However, the
> debugfs files pointing to fields inside this struct are only removed late=
r
> in nsim_dev_port_debugfs_exit(). This creates a use-after-free window whe=
re
> a user space program can access the freed memory by reading from the
> debugfs files. The same issue exists in the error path of nsim_create().
>
> To fix this, ensure that the debugfs directory nsim_dev_port->ddir is
> recursively removed before the struct netdevsim memory is freed. Move the
> debugfs_remove_recursive() call to the beginning of nsim_destroy() and th=
e
> error path of nsim_create(). Set nsim_dev_port->ddir to NULL to make the
> subsequent call to nsim_dev_port_debugfs_exit() a safe no-op. Finally,
> remove redundant debugfs_remove() calls for individual files and
> subdirectories, as they are now handled by the recursive removal.
>
> BUG: KASAN: slab-use-after-free in debugfs_u32_get+0x6c/0x70
> fs/debugfs/file.c:657
> Read of size 4 at addr ffff88810cd6db00 by task syz.3.8220/23584
>
> Call Trace:
>  debugfs_u32_get+0x6c/0x70 fs/debugfs/file.c:657
>  simple_attr_read+0x227/0x490 fs/libfs.c:1368
>  debugfs_attr_read+0x76/0x130 fs/debugfs/file.c:523
>  vfs_read+0x213/0xa80 fs/read_write.c:572
>  ksys_read+0x150/0x270 fs/read_write.c:717
>
> Freed by task 22896:
>  kfree+0x1c5/0x640 mm/slub.c:6566
>  device_release+0xc4/0x1f0 drivers/base/core.c:-1
>  kobject_cleanup lib/kobject.c:689 [inline]
>  kobject_release lib/kobject.c:720 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  kobject_put+0x222/0x550 lib/kobject.c:737
>  __nsim_dev_port_del+0x14e/0x200 drivers/net/netdevsim/dev.c:1547
>  nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1561 [inline]
>  nsim_dev_reload_destroy+0x288/0x490 drivers/net/netdevsim/dev.c:1785
>
> Fixes: e05b2d141fef ("netdevsim: move netdev creation/destruction to dev =
probe")
> Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+6c25f4750230faf70be9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D6c25f4750230faf70be9
> Link: https://syzkaller.appspot.com/ai_job?id=3Db0e49fe8-9a07-4af6-b52c-1=
2fa3167dd55
> To: "Andrew Lunn" <andrew+netdev@lunn.ch>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index f00fc2f9e..3a79cef66 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -442,6 +442,7 @@ static int nsim_dev_port_debugfs_init(struct nsim_dev=
 *nsim_dev,
>  static void nsim_dev_port_debugfs_exit(struct nsim_dev_port *nsim_dev_po=
rt)
>  {
>         debugfs_remove_recursive(nsim_dev_port->ddir);
> +       nsim_dev_port->ddir =3D NULL;
>  }
>
>  static int nsim_dev_resources_register(struct devlink *devlink)
> diff --git a/drivers/net/netdevsim/ipsec.c b/drivers/net/netdevsim/ipsec.=
c
> index 36a1be492..0bc9f42a5 100644
> --- a/drivers/net/netdevsim/ipsec.c
> +++ b/drivers/net/netdevsim/ipsec.c
> @@ -292,5 +292,4 @@ void nsim_ipsec_teardown(struct netdevsim *ns)
>         if (ipsec->count)
>                 netdev_err(ns->netdev, "tearing down IPsec offload with %=
d SAs left\n",
>                            ipsec->count);
> -       debugfs_remove_recursive(ipsec->pfile);
>  }
> diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netde=
v.c
> index a75076891..91e92456f 100644
> --- a/drivers/net/netdevsim/netdev.c
> +++ b/drivers/net/netdevsim/netdev.c
> @@ -1164,6 +1164,8 @@ struct netdevsim *nsim_create(struct nsim_dev *nsim=
_dev,
>         return ns;
>
>  err_free_netdev:
> +       debugfs_remove_recursive(nsim_dev_port->ddir);
> +       nsim_dev_port->ddir =3D NULL;
>         free_netdev(dev);
>         return ERR_PTR(err);
>  }
> @@ -1174,9 +1176,8 @@ void nsim_destroy(struct netdevsim *ns)
>         struct netdevsim *peer;
>         u16 vid;
>
> -       debugfs_remove(ns->vlan_dfs);
> -       debugfs_remove(ns->qr_dfs);
> -       debugfs_remove(ns->pp_dfs);
> +       debugfs_remove_recursive(ns->nsim_dev_port->ddir);
> +       ns->nsim_dev_port->ddir =3D NULL;
>
>         if (ns->nb.notifier_call)
>                 unregister_netdevice_notifier_dev_net(ns->netdev, &ns->nb=
,
> diff --git a/drivers/net/netdevsim/psp.c b/drivers/net/netdevsim/psp.c
> index 6936ecb81..2f27a2114 100644
> --- a/drivers/net/netdevsim/psp.c
> +++ b/drivers/net/netdevsim/psp.c
> @@ -227,7 +227,6 @@ static void __nsim_psp_uninit(struct netdevsim *ns, b=
ool teardown)
>
>  void nsim_psp_uninit(struct netdevsim *ns)
>  {
> -       debugfs_remove(ns->psp.rereg);
>         mutex_destroy(&ns->psp.rereg_lock);
>         __nsim_psp_uninit(ns, true);
>  }
> diff --git a/drivers/net/netdevsim/udp_tunnels.c b/drivers/net/netdevsim/=
udp_tunnels.c
> index 89fff76e5..e9cdfe817 100644
> --- a/drivers/net/netdevsim/udp_tunnels.c
> +++ b/drivers/net/netdevsim/udp_tunnels.c
> @@ -190,7 +190,6 @@ void nsim_udp_tunnels_info_destroy(struct net_device =
*dev)
>  {
>         struct netdevsim *ns =3D netdev_priv(dev);
>
> -       debugfs_remove_recursive(ns->udp_ports.ddir);
>         kfree(dev->udp_tunnel_nic_info);
>         dev->udp_tunnel_nic_info =3D NULL;
>  }
>
>
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
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
-upstream-moderation/b2de6fa2-bc67-45a6-abb0-35868b40b0da%40mail.kernel.org=
.
