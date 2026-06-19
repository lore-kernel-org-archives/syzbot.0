Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80D2B1DD525
	for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 13:45:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781876747; cv=pass; b=JLL6/HvHWlgPqKd1pvyxMDbrK23QGQ4YX42KdhGjiUO2WKEm2qSD7UZyC0xyOa88UREkhGoWQtapAJyeFg4JjIugz0jv1psdzapbC4Ar4xRFzFDGPBRJH0elRU9zoSBV1o9lrwd95R2UvQy0xE1Tf88ppG7P3DzbBnoS8UWWBmQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781876747; c=relaxed/simple;
	bh=2Qbcs0BUd5swZAa/GRc6gX4/+o8pwjO9isuLH9eLhEU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iSOOWyJjdyGnrSzTDAz++di/O3zIJcVyQ16cdqsrKCse3zRVCwD9NMRQZL4+cKgQpzoInUC7dsYVG4sWN+s8R+K5WBX0BMek3AdK3uuVG6sag+uBJYnqX7GGNkENoWuv6Y6mOVt576tpZz4/h5PXmXVGoGfcTINEGyWTBZT26u8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LAOtmItZ; arc=pass smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LAOtmItZ"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7e6cdd78fe6so1178472a34.2
        for <syzbot@lists.linux.dev>; Fri, 19 Jun 2026 06:45:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781876744; cv=none;
        d=google.com; s=arc-20240605;
        b=iE2y7FIgiAqqLcb3b9tRFaZ/mfulpwVL05PnPWeBNuJawWf1v8Q4rTZXG1F98+3TWZ
         FNbgPX8oEkur/Saloez1S8utvw6+5Q8moSgf57Dk89ShRLLHtj0MEC37LgKrtmCgzdZg
         1ITsJM/gS1oTCFY0DXm0kjZxH+8cPZ8jww6G2WBVa2eQXC3LufQ70keRiVRF/Fi49V9R
         QD/rETRgtEEIgcPdHcabpJ526u/0mk6gPKe6f6tOOzSX+EghfDhX2Kcl1vJPifgRF+aH
         42YX2XCfdUWN5Ko61IldR/yXfv66LUIuLlhdZ/7nmXvjwrpjv1rewmSA/X0YK6CJLNTi
         Y9pQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=XjF3rdqPeA9oIjal71zEkuPZP7X+EJGqjxbQvCR084E=;
        fh=K9CqCRqzPc0ekI+czsdEHAJdsSpuPvd2akd3/omRmA4=;
        b=ErRkjXtbCI3T29aUWSFQ/dvSbZUEblNM9MRlMiFr57fv5fgU6k8E4Pm2o3LxZEQNxs
         ZnLbGu+6YzapkCMHX6pcS9Ixgfvc6M1smeotTTiUmPlMnuxInZbtO5IhWOC8sX+Ksxvp
         7KrMq+VVgwx+KoSPhEaGoRBBPQ9xqT/OSGo6gI9cz9O3E9UDRQ5/uwVqB+Nm5piPdneD
         rzrg/VXGCYf+I2kYu6JnRCd894Kv4QwabqoofDlC4dWLK7xeKXsy6F+9BRBb+HaRtGWv
         RxKrTO9pNN0sjz6lBRwwDl4eT7+7mOAfYSpqevMLLZAfNNLYpFWtdU4ya/cfbeTaqhvo
         Ic9Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781876744; x=1782481544; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XjF3rdqPeA9oIjal71zEkuPZP7X+EJGqjxbQvCR084E=;
        b=LAOtmItZ6pJ69sfT0it/lptbf2EP+aFKxUmW8dL6IOl+MRceuciWTAvWcVWs/e/G3b
         +Ktpl0y/YSW4fYcoste/YkbQySWDpFFMBa2RVV0NmV95MEa18fccWslJBPMVrTN7y2Ie
         IyEZWceX9SMaGPdAow+Qp7vr4CQRqDF4o5pS70ymzq/V0OrzleuYNDloI9Mp+cEooteJ
         BdfknIbRdG8GO6scgC+l7xdIiOn7VXWxuQABWhGFBnJvqa5HQiP51TqNSss3fgT+K5qq
         y7B4VFubdQTOO62P8YH6twuEr95P0vC5VQVnW41AZx9KsGO4EXkYp/5Yyt8WeBC/Ubnf
         s4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781876744; x=1782481544;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=XjF3rdqPeA9oIjal71zEkuPZP7X+EJGqjxbQvCR084E=;
        b=QQa535XHZVV4DbkUMJnSofzc9fUAVZLe/c1v90x6KIhJyr/9UG0vvt7DKd7NfeR67a
         xmcQ/mYeypBYDl77SCRm/SNC48D72t49vwY6kgUXXF1KHRf19DxepPu4TL+mq6uNKUZd
         OrTNP6OyqU3JZIAjI5R5EyWypfTHOm7ljTu+atEPnynCIew0WmjCYdbDvX5VyQf7ogVX
         tEH19Bm/hne7JMwNewSCpkfhl6ItpUm4eFlYc24PYyn00y9BtF6rjJHHYgBCbrGD7Qr2
         3+kx7iMmhAvNWjKaUmGCX14FidGadfrpYM+oE6X57L7j9nQ556mwoi77VL0wv6feqa21
         q4rw==
X-Forwarded-Encrypted: i=1; AFNElJ8TeiXaonNNlh4EqdZxTIrGykTsA8YvsfUn0xM9TUddM1vQJIkmLHixunOxEXvw2f0olVM9skk=@lists.linux.dev
X-Gm-Message-State: AOJu0YwSHFI7brVu9cfVSwK6TlLdfJv5IoIEyQxpBfbClSAxoVkGM60Y
	AYk3uf9JOx644EEVrjxHBWRbzwbPJZbxLOszBx6cf1UmkOz06y8uBNqkKdvFytSzC/mOz6b7QXh
	ybUf8EELbPWV3gz+4zYSoWh8GUy/zY7z7Qfy+qh6tQogfrm1AgK48EcsepSDm1g==
X-Gm-Gg: AfdE7ckKsCz7Xl/yKaojsJikI8+d5EDKQKqV5r0JNHjT49//Yy8mCqo5wLdyojK9H5u
	o+VKm+RJoMFDH8dn8SUnQqlgt6aaMOQcMEaa4PEU2+3PiU6bQQYzd0QtwOE86WmKkzgm5Gkh2xd
	lDiZ0lQby83NCGzucN/TaTt9BZ57de83qxgY7DPbQ5DwKVBapUdYlXE5JvIpc30VjHPPENj16nf
	tRJUPGbon/+IOYcRHB//xM1XtnpwbIZt3aF/BkFGifI4aKIy4H990ZaT2yWAj8juPs1YyWg3iAG
	CtZXv+M2bqFTT0QTWqZeIVftDqW0nI8Y1vRmZVTR29J/JL0D3VerjNI3ed9hC0x82MzqJccFYkh
	mM+trCTkCuuDRKrtp2y1+
X-Received: by 2002:a05:6808:2e48:b0:48a:71e0:5835 with SMTP id
 5614622812f47-48a71e05f90mr421758b6e.35.1781876743779; Fri, 19 Jun 2026
 06:45:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ae062345-5029-4e41-9f06-20d8face5948@mail.kernel.org>
In-Reply-To: <ae062345-5029-4e41-9f06-20d8face5948@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 19 Jun 2026 15:45:32 +0200
X-Gm-Features: AVVi8CfVTPS_7vWNrwgPVQFDfoLNkiIFyJKmiWps8i5yljRRCsKgvWxVMFiZ-a8
Message-ID: <CANp29Y4dHrcS6TCKSJbDJDLHbXippnwxXSWEUX2bvs=mpd0zYw@mail.gmail.com>
Subject: Re: [PATCH RFC v2] netdevsim: fix UAF by explicitly cleaning up
 debugfs files
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Jun 19, 2026 at 2:49=E2=80=AFPM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A KASAN slab-use-after-free bug was detected in debugfs_u32_get(). The ro=
ot
> cause is a race condition between the destruction of a netdevsim device a=
nd
> the access to its associated debugfs files.
>
> When a netdevsim device is destroyed, the teardown happens in
> __nsim_dev_port_del(), which calls nsim_destroy() and then
> nsim_dev_port_debugfs_exit(). nsim_destroy() calls free_netdev(), which
> frees the struct netdevsim memory. However, some debugfs files pointing t=
o
> fields inside this struct are only removed later in
> nsim_dev_port_debugfs_exit(). This creates a use-after-free window where =
a
> user space program can access the freed memory by reading from the debugf=
s
> files. The same issue exists in the error path of nsim_create().
>
> To fix this, explicitly remove the debugfs files and directories created
> for the netdevsim instance during its teardown. This is done by adding or
> updating teardown functions like nsim_ethtool_teardown() and
> nsim_bpf_uninit() to remove their respective debugfs entries before the
> underlying memory is freed. This approach ensures that the cleanup is
> symmetrical and specifically targets the files associated with the
> netdevsim instance being destroyed, without breaking the symmetry of
> nsim_dev_port->ddir.
>
> BUG: KASAN: slab-use-after-free in debugfs_u32_get+0x6c/0x70
> fs/debugfs/file.c:657
> Read of size 4 at addr ffff888196b7db00 by task syz.2.2765/11946
>
> Call Trace:
>  <TASK>
>  debugfs_u32_get+0x6c/0x70 fs/debugfs/file.c:657
>  simple_attr_read+0x227/0x490 fs/libfs.c:1368
>  debugfs_attr_read+0x76/0x130 fs/debugfs/file.c:523
>  vfs_read+0x213/0xa80 fs/read_write.c:572
>  ksys_read+0x150/0x270 fs/read_write.c:717
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
>
> Freed by task 11226:
>  kfree+0x1c5/0x640 mm/slub.c:6566
>  device_release+0xc4/0x1f0 drivers/base/core.c:-1
>  kobject_put+0x222/0x550 lib/kobject.c:737
>  __nsim_dev_port_del+0x14e/0x200 drivers/net/netdevsim/dev.c:1547
>  nsim_dev_reload_destroy+0x288/0x490 drivers/net/netdevsim/dev.c:1785
>
> Fixes: e05b2d141fef ("netdevsim: move netdev creation/destruction to dev =
probe")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview =
syzbot
> Reported-by: syzbot+6c25f4750230faf70be9@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D6c25f4750230faf70be9
> Link: https://syzkaller.appspot.com/ai_job?id=3Dd4f60d9d-c966-4936-8994-4=
459d20c9153
> To: "Andrew Lunn" <andrew+netdev@lunn.ch>
> To: <bpf@vger.kernel.org>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Switched to a symmetrical cleanup approach by explicitly removing debug=
fs entries in teardown functions instead of recursive removal of the port d=
irectory.
> - Added nsim_ethtool_teardown() to remove the ethtool debugfs directory.
> - Updated nsim_bpf_uninit() to remove BPF-related debugfs files using deb=
ugfs_lookup_and_remove().
> - Called nsim_ethtool_teardown() in nsim_destroy() and the error path of =
nsim_create().
>
> v1:
> https://lore.kernel.org/all/b2de6fa2-bc67-45a6-abb0-35868b40b0da@mail.ker=
nel.org/T/
> ---
> diff --git a/drivers/net/netdevsim/bpf.c b/drivers/net/netdevsim/bpf.c
> index 8eebcc933..5b9b1da46 100644
> --- a/drivers/net/netdevsim/bpf.c
> +++ b/drivers/net/netdevsim/bpf.c
> @@ -653,6 +653,15 @@ int nsim_bpf_init(struct netdevsim *ns)
>
>  void nsim_bpf_uninit(struct netdevsim *ns)
>  {
> +       struct dentry *ddir =3D ns->nsim_dev_port->ddir;
> +
> +       debugfs_lookup_and_remove("bpf_map_accept", ddir);
> +       debugfs_lookup_and_remove("bpf_xdpoffload_accept", ddir);
> +       debugfs_lookup_and_remove("bpf_xdpdrv_accept", ddir);
> +       debugfs_lookup_and_remove("bpf_tc_non_bound_accept", ddir);
> +       debugfs_lookup_and_remove("bpf_tc_accept", ddir);
> +       debugfs_lookup_and_remove("bpf_offloaded_id", ddir);

Why `debugfs_lookup_and_remove("ethtool", ns->nsim_dev_port->ddir);`
was not enough?

> +
>         WARN_ON(ns->xdp.prog);
>         WARN_ON(ns->xdp_hw.prog);
>         WARN_ON(ns->bpf_offloaded);
> diff --git a/drivers/net/netdevsim/ethtool.c b/drivers/net/netdevsim/etht=
ool.c
> index 36a201533..3a369040c 100644
> --- a/drivers/net/netdevsim/ethtool.c
> +++ b/drivers/net/netdevsim/ethtool.c
> @@ -271,3 +271,8 @@ void nsim_ethtool_init(struct netdevsim *ns)
>         debugfs_create_u32("tx_max_pending", 0600, dir,
>                            &ns->ethtool.ring.tx_max_pending);
>  }
> +
> +void nsim_ethtool_teardown(struct netdevsim *ns)
> +{
> +       debugfs_lookup_and_remove("ethtool", ns->nsim_dev_port->ddir);
> +}
> diff --git a/drivers/net/netdevsim/netdev.c b/drivers/net/netdevsim/netde=
v.c
> index a75076891..9a7db40c9 100644
> --- a/drivers/net/netdevsim/netdev.c
> +++ b/drivers/net/netdevsim/netdev.c
> @@ -1164,6 +1164,7 @@ struct netdevsim *nsim_create(struct nsim_dev *nsim=
_dev,
>         return ns;
>
>  err_free_netdev:
> +       nsim_ethtool_teardown(ns);
>         free_netdev(dev);
>         return ERR_PTR(err);
>  }
> @@ -1177,6 +1178,7 @@ void nsim_destroy(struct netdevsim *ns)
>         debugfs_remove(ns->vlan_dfs);
>         debugfs_remove(ns->qr_dfs);
>         debugfs_remove(ns->pp_dfs);
> +       nsim_ethtool_teardown(ns);
>
>         if (ns->nb.notifier_call)
>                 unregister_netdevice_notifier_dev_net(ns->netdev, &ns->nb=
,
> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/ne=
tdevsim.h
> index d909c4160..75b724e18 100644
> --- a/drivers/net/netdevsim/netdevsim.h
> +++ b/drivers/net/netdevsim/netdevsim.h
> @@ -171,6 +171,7 @@ void nsim_destroy(struct netdevsim *ns);
>  bool netdev_is_nsim(struct net_device *dev);
>
>  void nsim_ethtool_init(struct netdevsim *ns);
> +void nsim_ethtool_teardown(struct netdevsim *ns);
>
>  void nsim_udp_tunnels_debugfs_create(struct nsim_dev *nsim_dev);
>  int nsim_udp_tunnels_info_create(struct nsim_dev *nsim_dev,
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
-upstream-moderation/ae062345-5029-4e41-9f06-20d8face5948%40mail.kernel.org=
.
