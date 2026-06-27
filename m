Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263DE3590C3
	for <syzbot@lists.linux.dev>; Sat, 27 Jun 2026 11:14:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782558865; cv=pass; b=WtbEkZZhkeWOuEXS6rddLt+pBwFtbP1eCjmEN1KWD/idDYKjztZjnFvir+IzwNFACT3xr4d6um0Rdxm2iCHv1pnB/yQJ2/AoqVJX4NJynpnd6Pr9hoViNDbUiMGU87vJob8lOOWGdmDeDmUuUudFB782NzoQZ8ALJzM0ANpIgwA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782558865; c=relaxed/simple;
	bh=F1+40k0oqw1ve+CNClWhzn6IHm89SCRYFeEGKvoSrpQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JrzUhhmrIRBA8WMtSrwmA9dbL7ABiZ7zGYD1ZH5tgHOcO3K3MGINlV9wUxTUAGc3pmPRyCsVw7BZSYVoYWfCRFSvJX3e28MuczFPsaFPbS/epSM6Ower7kjBKc+FFEgKwWrlMIj69z8Z7TNeSIsFq7vi5Ds6VUplSLJVQRIeTW0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EMUSUUKT; arc=pass smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EMUSUUKT"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-44841e9f651so956773fac.0
        for <syzbot@lists.linux.dev>; Sat, 27 Jun 2026 04:14:23 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782558863; cv=none;
        d=google.com; s=arc-20260327;
        b=kkvleM2uHMb5UayhwfJKyuYbPhNiXrogGLQ2EjYw2lMBZR9xSCWVeSR9L65PZPFII+
         /75CF0Xnlb2PvkqVKpdh/6Nwf4xdYtlqDouQYPysVoejelQFVYh8kCQiEXJaz3i95EFE
         ZPTtfBPLGsNLmLQYTnECYWmLb6meYHIdE1yLxuGz4K3bR+P2u78rH24i9+UzY+HACcHl
         OYYKxllfDfr4602XT3FA3+eZa6biDf4eXYWP9QWwnNIK6UHfJqdmNuA2lxEwDJrHh06r
         0+/63WHTN6oeNMShygBtrUHqw1+HOx5taYBa4nkAToE90Ti/oP4xOPgeFPCK+iJarYWV
         3FDA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ykA7a89cpZ4aU0uR0DuSBgd1UGDWOcwE1NSS6CAhYiY=;
        fh=dOC3jv2LwJHjeOdtLPxeDO8NHa/fRbYckUkchB3b5zo=;
        b=afBF0X2y0w9mgWKVQYE2a6HWsQLLQ/yeHStP574GPOnOjPbIDyFXlnoSIkE1kCmP6/
         tqM2lYnf/XPKa5QNRFj/VYubkyy2d2bFFRl1u3l64wBo6ofP7kwtfItkX9ioGLt173JQ
         n6Q+w5FM8iINVsyyCWwhK+/PDYHR6lj/kEZrq9Ta0LCX35LgVZtQwHmoGu5kAh+xJZBW
         +E7fP0VWInmiDTSq6+1H9FKJASBo1iNj3CP0YEkFuqLt0T1mS5QARaIqVN4y6tQHRoik
         JYb+5DTr8SoXMaMb93p1cEkQZdU0SZONAwpZMsYZ26G8OXEbqP+JnOMh7YN82DwPFbE4
         E37A==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782558863; x=1783163663; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ykA7a89cpZ4aU0uR0DuSBgd1UGDWOcwE1NSS6CAhYiY=;
        b=EMUSUUKTy30evw4jTsW+r1XPHamM3oWHNUWu6U9xam88Fk7hAT12ZxUW9ZGHhzCdhr
         RgzW7aHhRw4Cj1WKmW4e3pGgvugb2rJQcN79EumYBdu6NaYK3B9bTh13HMbbB3vWxbNt
         XHb3nOTqdE8S7ZSetefvKAQQXEGB10EwewHBiqKkyKDwK2owZcyhSEAeRC1dPTxyEzcU
         OmbZIvnXqYWB7vyp/0cTsb76JQNjIjxzLdVrI26OTGno4km4f//7jIywOBaZR4oQ373j
         dHiS+4HyVFNM0/MKchXDhw8Y+sLSTQbQ0LJwz775TnvfYpY1DH2puKeCn8i17dew4zy8
         3NbA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782558863; x=1783163663;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ykA7a89cpZ4aU0uR0DuSBgd1UGDWOcwE1NSS6CAhYiY=;
        b=r+sumIoMjBJQ4yaJfHw2mXTKNY45ulNUY7us6fcFv+Jqc4+CXzvZOD65D/3DHa7FO0
         TwCzd4z3T3yEtbF7fRAm1KsL+ZCUbdD4vnkddYjb21J5ny5cV/+6UxHIgFMDk35cFHp8
         T3ab4RHeVhEX0WqlilWLkisZFpGDHTBPFrpd3lCHxxqm2Vw9nDFu6hz9INAP6Tnw8EHE
         blFYy+RllfTzzQBEaCDbGZkhaPN48jIvyIu7NPkFGzudrWmBuJcQO2KtJOvGQJW7h7w+
         MvCOwOa/2yo8phlc48tzUIP9kTne255Hb3SvYnqDgeoJLUokGmIzOkv/Vq60/zTRoKrq
         XQMA==
X-Forwarded-Encrypted: i=1; AFNElJ/q11Uc2ydkDrTwgnK4+4MULSryu+MO/s7on3dnw+ko5+wkE3pzdEESWYv7NGj1+AtOzwC21uk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx0madmetWlbIZ7y3JOjGMfMuYbLOo4nGvXoINAASK7N3nDJ1sn
	Z/DeZyBby0/xVcCqdd/KNb06fQyz/OMDLWyD+LBaAweyn9kZ2svTmli3lM64zBLs+uRM4wjcXsd
	e/vWjiH55Q5lbvD3E+tI2HlyFgK55lZTtsL7iKPM+
X-Gm-Gg: AfdE7cnGL9ylOXGrGuJfiELlaozsMdB+4kpwgiuSqXc2w2x93BF83NtH0UMxfOWmMbn
	Oa5L84Afm5GM8UejYEggzc8fuuzwB7lKkl7dkIJ1qJrZX4UqUHLTdJ8o9r0HeMrOQ49TR67w/0w
	vPRIShnE3Sx9OwU7ElgxbUpVQT7G2HIQzE8hhD/NmpgwS81iRgZnUYR/JFtXVpHOjWv0ysvFB4w
	emNyoIEiKJU/R1KrjQQ38Ai1JEKGrNO3M6x4ZGVhInkTBSGmldS9kkwXrmCHZcayQFt6/AF4lQw
	cnyWsfp9zuLWJ0F64eESKmWJRkNfbMDAVAYNwuruPKK0CSaJCQaVRSCHA4rkvICuggN4mzKwYyA
	Px7Aw0wJIf1GpD7b5R1YHDIy9a5+u/zdoxisxpzkV
X-Received: by 2002:a05:6820:4b08:b0:6a0:f44b:1265 with SMTP id
 006d021491bc7-6a134fefc81mr7902822eaf.4.1782558862350; Sat, 27 Jun 2026
 04:14:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <eda8ccdd-476a-4387-95bf-aeedb3545c69@mail.kernel.org>
In-Reply-To: <eda8ccdd-476a-4387-95bf-aeedb3545c69@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 27 Jun 2026 13:14:10 +0200
X-Gm-Features: AVVi8CfUtBZP4GWvRZovdcR2sUrXpkFEFf0m7v1hTY7tm1uBg5Z3IhYuyBo5m0M
Message-ID: <CANp29Y6gq+X76VDzG9vePaX4+R1i=aFCRR6JLK6F3LTvP0L9EQ@mail.gmail.com>
Subject: Re: [PATCH RFC v2] netdevsim: remove debugfs files before freeing net_device
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jun 24, 2026 at 3:04=E2=80=AFPM 'syzbot' via
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
> Link: https://syzkaller.appspot.com/ai_job?id=3Df0f1a72a-a527-478e-a31c-7=
b83cdfee8d1
> To: "Andrew Lunn" <andrew+netdev@lunn.ch>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Removed unused dentry pointers (pp_dfs, qr_dfs, vlan_dfs) from struct n=
etdevsim.
> - Updated nsim_create() to create debugfs files without storing their den=
tries.
> - Added IS_ERR_OR_NULL check for ns in __nsim_dev_port_add() error path.
>
> v1:
> https://lore.kernel.org/all/d0941a03-e111-4b0d-b50d-19352a8ef7e2@mail.ker=
nel.org/T/
> ---
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index f00fc2f9e..4c2c9aa1e 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -1516,17 +1516,17 @@ static int __nsim_dev_port_add(struct nsim_dev *n=
sim_dev, enum nsim_dev_port_typ
>                 err =3D devl_rate_leaf_create(&nsim_dev_port->devlink_por=
t,
>                                             nsim_dev_port, NULL);
>                 if (err)
> -                       goto err_nsim_destroy;
> +                       goto err_port_debugfs_exit;
>         }
>
>         list_add(&nsim_dev_port->list, &nsim_dev->port_list);
>
>         return 0;
>
> -err_nsim_destroy:
> -       nsim_destroy(nsim_dev_port->ns);
>  err_port_debugfs_exit:
>         nsim_dev_port_debugfs_exit(nsim_dev_port);
> +       if (!IS_ERR_OR_NULL(nsim_dev_port->ns))
> +               nsim_destroy(nsim_dev_port->ns);
>  err_port_resource_unregister:
>         if (nsim_dev_port_is_pf(nsim_dev_port))
>                 devl_port_resources_unregister(devlink_port);
> @@ -1544,8 +1544,8 @@ static void __nsim_dev_port_del(struct nsim_dev_por=
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
> index a75076891..240107369 100644
> --- a/drivers/net/netdevsim/netdev.c
> +++ b/drivers/net/netdevsim/netdev.c
> @@ -1154,16 +1154,17 @@ struct netdevsim *nsim_create(struct nsim_dev *ns=
im_dev,
>         if (err)
>                 goto err_free_netdev;
>
> -       ns->pp_dfs =3D debugfs_create_file("pp_hold", 0600, nsim_dev_port=
->ddir,
> -                                        ns, &nsim_pp_hold_fops);
> -       ns->qr_dfs =3D debugfs_create_file("queue_reset", 0200,
> -                                        nsim_dev_port->ddir, ns,
> -                                        &nsim_qreset_fops);
> -       ns->vlan_dfs =3D debugfs_create_file("vlan", 0400, nsim_dev_port-=
>ddir,
> -                                          ns, &nsim_vlan_fops);
> +       debugfs_create_file("pp_hold", 0600, nsim_dev_port->ddir, ns,
> +                           &nsim_pp_hold_fops);
> +       debugfs_create_file("queue_reset", 0200, nsim_dev_port->ddir, ns,
> +                           &nsim_qreset_fops);
> +       debugfs_create_file("vlan", 0400, nsim_dev_port->ddir, ns,
> +                           &nsim_vlan_fops);
>         return ns;
>
>  err_free_netdev:
> +       debugfs_remove_recursive(nsim_dev_port->ddir);
> +       nsim_dev_port->ddir =3D NULL;
>         free_netdev(dev);
>         return ERR_PTR(err);
>  }
> @@ -1174,10 +1175,6 @@ void nsim_destroy(struct netdevsim *ns)
>         struct netdevsim *peer;
>         u16 vid;
>
> -       debugfs_remove(ns->vlan_dfs);
> -       debugfs_remove(ns->qr_dfs);
> -       debugfs_remove(ns->pp_dfs);
> -
>         if (ns->nb.notifier_call)
>                 unregister_netdevice_notifier_dev_net(ns->netdev, &ns->nb=
,
>                                                       &ns->nn);
> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/ne=
tdevsim.h
> index d909c4160..29cbf004a 100644
> --- a/drivers/net/netdevsim/netdevsim.h
> +++ b/drivers/net/netdevsim/netdevsim.h
> @@ -153,9 +153,6 @@ struct netdevsim {
>         } udp_ports;
>
>         struct page *page;
> -       struct dentry *pp_dfs;
> -       struct dentry *qr_dfs;
> -       struct dentry *vlan_dfs;
>
>         struct nsim_ethtool ethtool;
>         struct netdevsim __rcu *peer;
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
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/eda8ccdd-476a-4387-95bf-aeedb3545c69%40mail.kernel.org=
.
