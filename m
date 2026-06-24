Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 05E6033F361
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 09:56:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782295001; cv=pass; b=eKSmXxLXaDwKSJLYIsv8rkJVA8mJg29o/dyEf0ur+wb5P9pZsV0rnwcCf/GvqJVhsRCMRE3pCA3ialID/zQbKZPJdxLIC0STZrqFuVULAzq/LbrbfsUkFWqkrtt3SgiWL90tijDQoy8QqA+3Ia/tHYbPTDLOdFPFwDLGt4nJ1YA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782295001; c=relaxed/simple;
	bh=hJMqy5COJpPBxleTt+qAb3aZGR2zue65/gyLblhbexA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=AsbumXY17gkJ1xbl117SZprLXWul2TNxSwy5qvQx8FwfCTRxuJCvDyMxGS4jgla2wjzM1elrtrR9bPfShMuKk2IllSF1Fw1NQwgCSQPDRiX/Yk6JOWKFuB+a6vMwFb3LjQX6o8SIxSumzIAth0p0ZpHqntt/G/YaHm/Ozy4xfYk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SKpHoPNz; arc=pass smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SKpHoPNz"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-6a0c7c4f55fso665271eaf.2
        for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 02:56:39 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782294999; cv=none;
        d=google.com; s=arc-20240605;
        b=B8VGD/B55fJWdx88pLaA0eajx64+Fwf5j4UtxPvDsT5OEdpxxaj7Em0Li8VZ2DoJTu
         VKd5FJK6DZj3g5O5d3Zq222YhCtpV5ojpIJsUuMpUAA22aB/KNZ75QDYHuTUxI7Qx5MJ
         rZ7WZg1CHgbtZ8nKt00/NWQhCW2bLaLpwqPubqYh3vFAYlMowIdylNu1M0034rhu8R0q
         Vq2EUf0TM4ZOe7VlXMPza0bUAEdjzCrt709yUG7MY26Lpw+DgUtE2NRplU/D3ZzXK55a
         xvidAP9DwEe9rkNJ/tTceahsqh7H85c7HHJlP1sHiF4T3xXodPdT2OB0yyimVLvOT83h
         QTLA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7PqrOAX+cQ/I64vxKTFtVwaUVQfII10eVu9HkGPNU10=;
        fh=M78QWHPb98pZeS8lKwTKAGjgagv6QmaZGvHgVdOIbtI=;
        b=Z7GrIC3ODUM3Wf47PczK5K3udnrJCn7C4Ugo/G0FOLOWVe0nKGH6GlyLPz+nTeZ74B
         2LLcM680hT1PUI3f57FUaTTiiD8OFIsoN7WNDErE8c4lIgK3t/Fk0oThPyXDax8ZW9B4
         EbwUeRZTjiNypa8AzNVlztaTGUuBFeGXk91IEutLR9dnverBGb1U8w9PQB+sPDzFCElx
         XbbY9Xa3vMbQH7e25NjfCZh+qG6PACBdn3wlo7wqJAl6K8X6Ja5broTMiABKh96dqwnl
         0weFudcJpdS1eMC+as4HSoHOrABC82oqbKKGpf8S8y3DrFszYyw6A7MGMgqcdWi85uEn
         fl5w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782294999; x=1782899799; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=7PqrOAX+cQ/I64vxKTFtVwaUVQfII10eVu9HkGPNU10=;
        b=SKpHoPNzxl2kM+PYOHs3GABlNggAtza8ImNCDjkUCkL6/xkQCP7+/qf+Amw1MTjNsq
         oNxKxM3+DQoW0kJrl3D4kYEfwRyKalJWc53eEcdbSFSiHRa2J2U0L3p1Wugiin4t9m0G
         HdHHjBzKQFnHbjCC/Jcq+Zoy+LS02/peagZAt02pKdoKEaR3nf5VJ2CSQAqb61IRkrHW
         8dYYO9wm2dkBOHh/BMpl7WUoCH/ciW5rkdf5u2LCY4T6quSUpZIcoQrCfHAzuxwT64Lw
         Yw7Qrc1KJQL8sAouxnSOFNLJIcPE6sWAv+JVg32sdlxUb8mQb7LDUDhx/3iF0qZ5920q
         PidA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782294999; x=1782899799;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=7PqrOAX+cQ/I64vxKTFtVwaUVQfII10eVu9HkGPNU10=;
        b=TReF2kqxb7/ff+6Nf4R0fqSaInSH/BJFAtrDYMBuzB7iRHeCwcLN9tnNYSESgNxTN2
         hAJX83LmfwF2mdodIW+hw8MdkgoXGmsLEoyzGr+ljZ1pkE+x1Aq031mUia6GTnERgZ8R
         rUTuaRV4m7fT2BqwQwQytr186kpLazN9mlnq94AWJiw6SH7izQuKAt0gXmfTEPPAOYD/
         KT9suUjhBgoKc2ge5t9Jxks0p7x5Qt3mAlRvqxfYLvSFDgUNRFXnd42gf+T6IdZDpUT6
         Mv2M+Sm81n2i3mSbUxJZ2MXpCc/JcivSMe2ITkz1OPmvXSc3bQL1coInD3fx/x0oyFEQ
         bs/Q==
X-Forwarded-Encrypted: i=1; AFNElJ+H/karptcpKjhxNoDgtXz/6xsf5LeW39hNMoWZeeuoun7pawSCVGcYLEuuvKNUtch4OrRvWYw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzsDe97UiEY7hZ6r1mZZvTpFHB+zAMCK8CdtsGM/xzoEqC1Vfrf
	YCHRs8RQIAD2QJ4bjwTZB4bi7NO4kPkEYvdCZ+WTe0P+2vAZ5qhqbZCEABw3Jq9h/IJULTEPTFI
	HhjiSWTtad73P4DrgvfZelgAcpkgNnZDTlxQqGmMi
X-Gm-Gg: AfdE7cmSG+TLiIMK5MB8NOzQrw6muALLwAZRs7ngHprIM1EnOJmBhgiZ2kjMUsBlPb2
	gx966keAZM434UP8qzDh0yTv0/QhxQXiViKBOHkxOqxEvHWDK5HkogYKTzOT+nwPVjYR0l3d0oD
	020Nj1oXdCjPnFWw+zSpqeZSFnbuY9Rnfg/FofViHe0NhWF1ABJKJ7wnkz8Ort+wydVv6116kHS
	ZAs/p/rW6QyDNHA9xTPDZzl0wpORpdlxNV6VJ1JmVZiK0zFSCCp9uWcUuFRl1Frtpa9H5qZXuU9
	o3LX2GIf2Xr4za1rtWYZ0YFHb3KA4dH1Nt0G3uYa2HjRVpZneO77PSq3ywuWFM1GQ5H93QcKVcO
	eQFTjigNRYVr2vDqU52E3DkUSpvZDOtobtEu4JawO
X-Received: by 2002:a05:6820:99c:b0:6a1:1fa7:eb35 with SMTP id
 006d021491bc7-6a122ec0e64mr1707015eaf.12.1782294998341; Wed, 24 Jun 2026
 02:56:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <d0941a03-e111-4b0d-b50d-19352a8ef7e2@mail.kernel.org>
In-Reply-To: <d0941a03-e111-4b0d-b50d-19352a8ef7e2@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 24 Jun 2026 11:56:26 +0200
X-Gm-Features: AVVi8CfDNjQRjt9JPb69F35XqMNNvHGxX9jMkQQDPb4XO6DE1ZLCtplVaJamP5U
Message-ID: <CANp29Y6o2PzZVMeS5w=MAz22kKE5sRBPZ5_9xrpmZ6zeU5T03A@mail.gmail.com>
Subject: Re: [PATCH RFC] netdevsim: remove debugfs files before freeing net_device
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Tue, Jun 23, 2026 at 4:31=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A KASAN slab-use-after-free was detected in debugfs_u32_get() when readin=
g
> a debugfs file associated with a netdevsim port.
>
> BUG: KASAN: slab-use-after-free in debugfs_u32_get+0x6c/0x70
> Read of size 4 at addr ffff88810cd6db00
>
> Call Trace:
>  debugfs_u32_get+0x6c/0x70
>  simple_attr_read+0x227/0x490
>  debugfs_attr_read+0x76/0x130
>  vfs_read+0x213/0xa80
>
> The root cause is that the net_device (and its embedded netdevsim private
> data) is freed before its associated debugfs files are removed. When a us=
er
> reads a debugfs file like rx_max_pending, debugfs_u32_get() dereferences =
a
> pointer to the freed memory. This happens because nsim_destroy() calls
> free_netdev() but does not remove the debugfs files created by
> nsim_ethtool_init() or nsim_bpf_init(). These files are only removed late=
r
> when nsim_dev_port_debugfs_exit() is called. A similar issue exists in th=
e
> error path of nsim_create().
>
> To fix this, swap the teardown order in __nsim_dev_port_del() and the
> __nsim_dev_port_add() error path so that nsim_dev_port_debugfs_exit() is
> called before nsim_destroy(). This ensures the debugfs directory is
> recursively removed before the net_device is freed. Additionally, remove
> explicit debugfs_remove() calls from various subsystem teardown functions
> (like nsim_psp_uninit, nsim_ipsec_teardown, etc.) since the parent
> directory is now removed earlier, which would otherwise lead to a
> use-after-free of the dentry itself. Finally, ensure the debugfs director=
y
> is removed before free_netdev() is called in the nsim_create() error path=
.
>
> Fixes: e05b2d141fef ("netdevsim: move netdev creation/destruction to dev =
probe")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview =
syzbot
> Reported-by: syzbot+6c25f4750230faf70be9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D6c25f4750230faf70be9
> Link: https://syzkaller.appspot.com/ai_job?id=3D84a7c962-d10e-424d-a37a-b=
f27d4830a40
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
> index f00fc2f9e..beecc0c6e 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -1524,7 +1524,9 @@ static int __nsim_dev_port_add(struct nsim_dev *nsi=
m_dev, enum nsim_dev_port_typ
>         return 0;
>
>  err_nsim_destroy:
> +       nsim_dev_port_debugfs_exit(nsim_dev_port);
>         nsim_destroy(nsim_dev_port->ns);
> +       goto err_port_resource_unregister;

goto to goto looks very weird..
Maybe we can simplify it with an `if (nsim_dev_port->ns !=3D NULL)`
check? Then `err_nsim_destroy` could be dropped.

>  err_port_debugfs_exit:
>         nsim_dev_port_debugfs_exit(nsim_dev_port);
>  err_port_resource_unregister:
> @@ -1544,8 +1546,8 @@ static void __nsim_dev_port_del(struct nsim_dev_por=
t *nsim_dev_port)
>         list_del(&nsim_dev_port->list);
>         if (nsim_dev_port_is_vf(nsim_dev_port))
>                 devl_rate_leaf_destroy(&nsim_dev_port->devlink_port);
> -       nsim_destroy(nsim_dev_port->ns);
>         nsim_dev_port_debugfs_exit(nsim_dev_port);
> +       nsim_destroy(nsim_dev_port->ns);
>         if (nsim_dev_port_is_pf(nsim_dev_port))
>                 devl_port_resources_unregister(devlink_port);
>         devl_port_unregister(devlink_port);
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
> index a75076891..6918679ca 100644
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
> @@ -1174,10 +1176,6 @@ void nsim_destroy(struct netdevsim *ns)
>         struct netdevsim *peer;
>         u16 vid;
>
> -       debugfs_remove(ns->vlan_dfs);
> -       debugfs_remove(ns->qr_dfs);
> -       debugfs_remove(ns->pp_dfs);

Now that vlan_dfs, qr_dfs, pp_dfs are not used for debugfs_remove, do
we actually still need those fields?

> -
>         if (ns->nb.notifier_call)
>                 unregister_netdevice_notifier_dev_net(ns->netdev, &ns->nb=
,
>                                                       &ns->nn);
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
> index 89fff76e5..a69b15f12 100644
> --- a/drivers/net/netdevsim/udp_tunnels.c
> +++ b/drivers/net/netdevsim/udp_tunnels.c
> @@ -188,9 +188,6 @@ int nsim_udp_tunnels_info_create(struct nsim_dev *nsi=
m_dev,
>
>  void nsim_udp_tunnels_info_destroy(struct net_device *dev)
>  {
> -       struct netdevsim *ns =3D netdev_priv(dev);
> -
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
