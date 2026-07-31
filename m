Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21D27426697
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 13:21:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785504108; cv=pass; b=JD8NQIrA+qatznwmxmwHUxms6gtLDoscqxY0fguGGl0ophOFuQ7ezUHrGxaJAvhU4RO4Qi2Qv/BM508w9okdJhAph4rRFUWaugnpksavxIz8YX1gcTdVv6OEV2GyNApzJgCJ8DBACDfr8Ose6rUgdKnT30r3ZHFtzs7ZhecUv4Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785504108; c=relaxed/simple;
	bh=znsO/KsbV1hhPViuaaqH8i6427sqsFcyNQusLCAnyf0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GOmNBXNuaFBZaN9WurVs4m1Zb8eeKTtgD2MW0F+RyruPiu1zbXDNaQwLAOCzkQM2zHnISFDnvVNPjH65cBOuFgZHz7NMFQ70mI/hdx5iaowaBRq/aBp1m43gBNfV4RnujqfVfsXTneZvnVVb+6rYyjvHMQTTepxYBw47EC0ImSM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=FByU7SHZ; arc=pass smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="FByU7SHZ"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-4ab70b882c5so575223b6e.2
        for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 06:21:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785504106; cv=none;
        d=google.com; s=arc-20260327;
        b=fu8UTP1r7ScQIssUndeNGu8zv5DBwZxj1ms69cvXh82aC60bVVwyUQTHWVjsFCWMC8
         Amek0vf/tUQpAt68kj2tQB6cg18/U1EKguKDPOdqpVbUM1QKwGFYl+CtOiU5+ZdckRzc
         lmeXdhgB4ye6WuyErKdF7eZeS69IqrpEaOkHv+a0gevFp3P9xNZAFPDmZlZKUB6OJa7X
         7oBn9/xDIMVqXhh2vBfA56+a1KHsx/nB3OF94+8N7KMYK4eqYqKm9kW1ej63iaUJfyoS
         fMTLHP0ga4BTKeG2eg2Rm8W270kludUH+El1t+2DgUbO9gl3Gr/UyNmg5/9OjHbDWZKw
         l7vw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=vDGfHDNCJCTqFVO/5eB30iFlGXVWXRa7nEl6tG1sFpg=;
        fh=vak7k1kbgJhTTv6UPWsKq4MjRndQFllU41EAK5r24Oc=;
        b=c+kMi02ibSRWmA8UEr31NRYvxorIkxL5REH0JUjgRk/6mXqUWzOVmBAKJO2/Vt6nmS
         1CMOaK/WmtM/uMw1NRq55KmnH3roHxrVSFdVCobpvdOx9u7hsocxMJAyK8hKOiFZkWsV
         WPliiK9LK7W8beOfpuj9zGjnZdSCOVdhh3g4EtwH+T1mN45HBxtNdE21nnmYvaWK00in
         hD057MAaBk3RKkzlVRAdCKA4H1EFlrzVtjJ3pQqsmr/xfAtUQzHSLTWrTjRWRS3WlPC/
         RhteTJUYpM51k++sBeAfzapbliAb6sHSd2UZ7j/AUQRdtxy5g+71wEy7AkR8JJ8Sppyq
         LFKw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785504106; x=1786108906; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vDGfHDNCJCTqFVO/5eB30iFlGXVWXRa7nEl6tG1sFpg=;
        b=FByU7SHZ6JukXW3jWfEF8gK4jI7haJLQsXwuR9OAiH6Bc1dF1LFXEZ7JIAXz1TTfY2
         igxQkti3umEs09aJaD0PYb16Hy+wHvWI9YFlGY6GSpBZeHHE4pZPfta82kaqEcsiJCTC
         M561LoXmmhbXbU1AnB85FJ1OJ/KnytKDz5PJIlzrFM4CmP2udSuvPS/QmX/R6TCpbxST
         eahuAG7qvO6MgMr9GVxufd92qjDA4YPsMI2AfEbZ/sRhu8nvW7ZDkOPtDAyAdJZtgm5A
         ubqWjhiLbFGU5azc04Za/e2wyvkaPPbylzfr+Na2Zwykv7Y0IqAMwgu3U3Su69f7cZaJ
         AImQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785504106; x=1786108906;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vDGfHDNCJCTqFVO/5eB30iFlGXVWXRa7nEl6tG1sFpg=;
        b=dZE02tV/UD+fTPro31Yg+cfCIFn2mOqypnTT3bGPAH0FXQZlFOLYPrFFdAHNDfNgvy
         P62CtWhnXPM29bGNSSxCaNq3w9qPBjHE+/yoknILTiWjN6T+VWW6TCge4DA+jPKw/4xN
         VbuhYnfouONpRaiOEWTK96ZNb8TnE0PAO1dPaNYw+u8s5jERM6QB634KsUei+G1Wjl97
         CxmKSMmhCZ1fjQyFhnItmKgryjpVZsxokSsAXbHURojMtleT5NxPU/ukOhdjKe8r1CPC
         uMYDTV9GaAWiK8ofgjENvBHOCkHpPgeAC6/aKpWBRFUlA2VSg+XeUjd7p8KhPM58Tcu/
         sFQg==
X-Forwarded-Encrypted: i=1; AHgh+RqlIS8i1EZ+MgnlYJZPlKwHqxsFIbYG6fEcvDz1pkd4umryRHf/C1JO/yFKUwcqfy6gJzlsR6g=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfC446KsCcdzXOAvwwBZfHSKcdo6Sw/R1F9bEZpTf7ZUA86kPW
	1tbGJmDqSwDq6UzVHyNezjdhfSZaCOmjnQEe8tnk+6nxIoGGfYlyN37CPyRfjKHdM8bymyYwaTe
	TldKMhpwspcGs4AQTGtY6fLJGgGr+bYhmVMx7IRJQ
X-Gm-Gg: AR+sD13zURhDCTRo0UTyOjw+E6atgV4d4hx3yORjjaZd75nWJP2Ev7WcJMibsL9MfLS
	R4wjBt4sK9T1f8cls/h7cl1y3J3eGHnFL11BEMqpQOfGbljKRZ3Sv8sJJm0bbdU67Qa1hO4Muib
	6XZIXslAocv8vk+aUG8fp1pr4R4m+JXSRwNI6zLUqqbf3p/NUEsVA2bg/8LOKkLXKMslnEZ+U8d
	SQwqbcSK1jQDmZd9VMlNtgbGjna48C0nTsp9M4XtAqD05PWrgyN18wrKV2dCIO4Sgj1zsVxsOvW
	VJi5sBl5UR2kTgTg5AjI2uHSpZb9okXBKFWGZIlQAacO7I9r2WYjnyLyzok/EmGzzA8EYPd/2wy
	ZZN2BUFUq3yMn9gQsp/utafgsynA+ORh0io2bRl4rq28/5YH56pDhAOaXiXqsRmLUQ8z/iapejX
	mCx4RCNtZgWiykb6cZAFf5EhM=
X-Received: by 2002:a05:6808:2389:b0:497:e069:964b with SMTP id
 5614622812f47-4ae5aba8dd6mr2522718b6e.9.1785504105087; Fri, 31 Jul 2026
 06:21:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <a6f4f066-bd64-4a53-b3e0-0d71b34bf773@mail.kernel.org>
In-Reply-To: <a6f4f066-bd64-4a53-b3e0-0d71b34bf773@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 31 Jul 2026 15:21:31 +0200
X-Gm-Features: AUfX_myBSukypFOpJd3zIwFcq9-4lvBGFdvJeJu0Piz5JLX_8VCF6EwDRdthahE
Message-ID: <CANp29Y5woqC4_8Awxuv0FU1sbK97+LFhHyLUn2uHku3nJ93b5g@mail.gmail.com>
Subject: Re: [PATCH RFC] usb: gadgetfs: fix use-after-free in ep_open()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Jul 31, 2026 at 10:13=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> A race condition exists between opening a gadgetfs endpoint file and the
> destruction of the endpoint files, leading to a use-after-free of the
> ep_data object.
>
> When an endpoint file is opened, the VFS looks up the dentry and calls
> ep_open(). ep_open() retrieves the ep_data pointer from inode->i_private
> and attempts to lock its mutex. Concurrently, if the gadget is unbound,
> destroy_ep_files() iterates over the endpoints, unhashes their dentries,
> and immediately calls put_ep(). This drops the initial reference to the
> ep_data object, freeing it. If another thread is already in the process o=
f
> opening the file, it holds a reference to the dentry and the inode. The
> inode remains alive, and its i_private pointer still points to the
> now-freed ep_data. When ep_open() proceeds to lock data->lock, it accesse=
s
> freed memory.
>
> BUG: KASAN: slab-use-after-free in __mutex_lock_common
> kernel/locking/mutex.c:625 [inline]
> BUG: KASAN: slab-use-after-free in __mutex_lock+0x130/0xf14
> kernel/locking/mutex.c:821
> Read of size 8 at addr ffff0000f43acc58 by task syz-executor/5900
>
> Call trace:
>  __mutex_lock_common kernel/locking/mutex.c:625 [inline]
>  __mutex_lock+0x130/0xf14 kernel/locking/mutex.c:821
>  mutex_lock_interruptible_nested+0x24/0x30 kernel/locking/mutex.c:899
>  ep_open+0x58/0x25c drivers/usb/gadget/legacy/inode.c:823
>  do_dentry_open+0x5c4/0xfc0 fs/open.c:947
>  vfs_open+0x44/0x2dc fs/open.c:1052
>
> Freed by task 6138:
>  kfree+0x188/0x690 mm/slub.c:6692
>  put_ep+0xd0/0x144 drivers/usb/gadget/legacy/inode.c:225
>  destroy_ep_files+0x244/0x2dc drivers/usb/gadget/legacy/inode.c:1582
>  gadgetfs_unbind+0x114/0x1f0 drivers/usb/gadget/legacy/inode.c:1655
>  gadget_unbind_driver+0x188/0x790 drivers/usb/gadget/udc/core.c:1724
>
> To fix this, tie the base reference of ep_data to the lifetime of the ino=
de
> rather than manually dropping it in destroy_ep_files(). Add an .evict_ino=
de
> callback to gadget_fs_operations that drops the reference when the inode =
is
> finally destroyed. Remove the premature put_ep() call from
> destroy_ep_files(). Additionally, to prevent a double-free in the error
> path of activate_ep_files(), clear inode->i_private in
> gadgetfs_create_file() before calling iput() if simple_start_creating()
> fails.
>
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Ddf9e891bf8ea586f846b
> Link: https://syzkaller.appspot.com/ai_job?id=3Dae49a838-5eb9-4227-93a3-5=
6ad2313483a
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
> Cc: "Christian Brauner" <brauner@kernel.org>
> Cc: "Jan Kara" <jack@suse.cz>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Mateusz Guzik" <mjguzik@gmail.com>
> Cc: "Al Viro" <viro@zeniv.linux.org.uk>
>
> ---
> diff --git a/drivers/usb/gadget/legacy/inode.c b/drivers/usb/gadget/legac=
y/inode.c
> index d87a8ab51..a03062986 100644
> --- a/drivers/usb/gadget/legacy/inode.c
> +++ b/drivers/usb/gadget/legacy/inode.c
> @@ -1579,8 +1579,6 @@ static void destroy_ep_files (struct dev_data *dev)
>                 /* break link to dcache */
>                 simple_remove_by_name(dev->sb->s_root, ep->name, NULL);
>
> -               put_ep (ep);
> -
>                 spin_lock_irq (&dev->lock);
>         }
>         spin_unlock_irq (&dev->lock);
> @@ -1996,6 +1994,7 @@ static int gadgetfs_create_file (struct super_block=
 *sb, char const *name,
>
>         dentry =3D simple_start_creating(sb->s_root, name);
>         if (IS_ERR(dentry)) {
> +               inode->i_private =3D NULL;
>                 iput(inode);
>                 return PTR_ERR(dentry);
>         }
> @@ -2006,9 +2005,18 @@ static int gadgetfs_create_file (struct super_bloc=
k *sb, char const *name,
>         return 0;
>  }
>
> +static void gadgetfs_evict_inode(struct inode *inode)
> +{
> +       truncate_inode_pages_final(&inode->i_data);
> +       clear_inode(inode);
> +       if (inode->i_private && inode->i_fop =3D=3D &ep_io_operations)
> +               put_ep(inode->i_private);
> +}
> +
>  static const struct super_operations gadget_fs_operations =3D {
>         .statfs =3D       simple_statfs,
>         .drop_inode =3D   inode_just_drop,
> +       .evict_inode =3D  gadgetfs_evict_inode,
>  };
>
>  static int
>
>
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
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
-upstream-moderation/a6f4f066-bd64-4a53-b3e0-0d71b34bf773%40mail.kernel.org=
.
