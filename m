Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69E7143B4B7
	for <syzbot@lists.linux.dev>; Fri,  4 Sep 2026 09:22:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788513756; cv=pass; b=j5D3a7f/CHmMJnVSgibQzHtGSXP2HU4j4RPkdKGi6xBvX7/IuqZCQ27pJsiQsPQmGdpUfc5sA8bWeyXXHlHzV9Pr9ilssKjXDitJPQOpRjoPFWEO+s+RgwOEHxeQ9BC4TeiDZbdQGywWslk2GdpEFXiEDjM0D78wfvT8iXHWsRI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788513756; c=relaxed/simple;
	bh=/Rt+KJZCdC53AKdaA2tvvcGi0D1mvgq8wGupIwl15HE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Od5UjuLjGJm4mQoDvoNEDE+asfrOh4NrLtuAnbDHLfNR5eqTeLgbooENGyp8+ZW/3hKXxyXgThv2+LoQPlg670DCRBb1IPaKdIwDu5eH0wBeEJy6QAkMWq7b1yn2D5fqaA8EJaGFSYM1+6xPeMhpFSVAq3dNbzUgIz6cC0VsGcY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A/TZchVm; arc=pass smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A/TZchVm"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-4b21f09ec76so592676b6e.0
        for <syzbot@lists.linux.dev>; Fri, 04 Sep 2026 02:22:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788513739; cv=none;
        d=google.com; s=arc-20260327;
        b=SLHtRmHJi7/+SOhbRn/U9aqD0LVawXBM1qjWGIpNZye33Jqll3mrghiF0jiLrre6gb
         N6Ylbt7ISeEATT/LtMcnTxO+1z2I4rbdt/MTPGbI4Otvb+B3qmFLXtJm1/Qs4OLnCVnP
         qFBA22lO00nm3GFeQ/4/wpUCnLC4dBIqxHwXsz+AvUZIRNW6+qJuDWKBP4UZVZO+G/XZ
         eV65UFSnRfOCW+VkCU8wF4/9I29NUXs4Ulguu55/YzTf/3bDhqFZpFkfx8vCPQTQE30x
         Tm3myx/aZEKsVdDgg8TfIx4hNTaGRiufr1OH6ai9q3EcycKfoukg4nUsFHKiJs4tqgvv
         KYzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7am6NmRCjgvluVllUlFOxAwX0jPNHpd7gpvx/F1oVw4=;
        fh=EbJxFx6Pac+PUFO3Y+qpJpXbgwn30XomejGsKUfUmcc=;
        b=B9PRsnfWKYF0HMoTy3tP32e+jOO/MdgJKKeewgrEdzyhfMfMB120nNCHUgRwpXYPcE
         +9pDEieN7KrYn7Jfvqf5773NB6sYBviB1EISdiPuT7fJq5RRLFAgMX2BIp/K3LBEmTEP
         yWLdCvs4qEcEwrUqkpF6qJenKWAsqdmTpuY1ra/L6jn1YWlir6XBkqXQqlo0C2rg0HFZ
         iHoTE0tRrsEbCO68TFIOGdWRc2Jw4zto2P9f3Le93BH9aQZv7jCzTvLapFPcwFVh8JHu
         5OTCuBZFpwuk4weDjGjGwKlNTKer4sf9YvhUAhMzepls9QqSRhVM4bU1FbdDWXH6VA9X
         cRzw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788513739; x=1789118539; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7am6NmRCjgvluVllUlFOxAwX0jPNHpd7gpvx/F1oVw4=;
        b=A/TZchVmZZcSO2ERGrF4X+FfzFaCXzADu7L+ii7Gy6ZNqtQTjbtNjHq2xfvoTvlVte
         Ux/udsbP2yJ8HdOqEeiW3mA21tWEJxZwxqdUcPP9JVR2t0yMmANnfPpU6gDNh3vBZgeN
         ntjxrqjM/D5xS4GLIOG//4sKmA188inSJSBtSrtaANxgIQ2loaJifMwcYg8E4If11mBB
         hIVkOKADB5/E1Oea73FYemYhNZhm6SdPb1eZiP5/PU6y0C/UY5AWRrPGRvSYPTruwTU/
         D4Tf3CK+7ASSdol7qBAkB+UywkqwiOSgsNSdrDQmuLyfTgXHSpkmz4SLkBo2rgp09z9P
         eqNQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788513739; x=1789118539;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7am6NmRCjgvluVllUlFOxAwX0jPNHpd7gpvx/F1oVw4=;
        b=qs/xqSX2VdcEp3uajwVAk328D0PrC9K5J3efqorHYBcA+/1TW8Ggou/K5vMbSDesV3
         E9HTdrruyF5Iwr8hmW3y4/V92Unt3hVN7g6c6E21w9q+OGCAvm8EOKrJ/j+F/RUECplk
         hmPIFUfqbhd6t+8lkT7B6ha0SFJI2CGFCfdgXr7pCMisN8w7JRUgN942w2xOHoFSfYik
         Q3OWpfLx9Dp3tXqLh4PYnVgu1m37KQfVpfGMyMWba3s48Ldoi8XpHLP0rms7lnW7qzLS
         VQQCUKLBSJEqBqha/oDwG+VSj0xrxKxud+6aaCCEY7TJA19pobQiNYRla2ZpINkcLivg
         Sogg==
X-Forwarded-Encrypted: i=1; AKwUvBzA0wFesyrNoFrXaMD+ZPkh+P7zndfEMa2Xu4wAhwAvsXAV0HIMhaBWzoEDxbOP+/Du6UAk/yE=@lists.linux.dev
X-Gm-Message-State: AFuF++ns4dexd2olnU+Tnu0t6XsPTWq7f/ALrK8NqNmvUe5qpihr/asr
	3Jq20Z1c4hryWyfDHHcyLvIVKMSCck/S9+TwVlbGpc9NU4FPlrg6qv+QtMZXKL5Aw0G//LXO0aB
	E0+LyhG0yXWFw+l8d/l3ZMfwZMdSurhC4EK/R7DzQ
X-Gm-Gg: AYBFou0swsG25AYapIhiRgUNvhyrcI2H1e6X3OIaT2LJ/OeLx/IjjzIclDgyRZW7b3G
	zewdzWNujdf9Yk4MCNgCPxilLKu+KJ+/tLtytkngcDKLlr03rf2PF1AxYpvZ8F3z0oTi08EN69i
	AM8Jq4Fq1nKuSNl5m3V48TScCC6kgFPkzrjHAj5spo1dXB9quUk1Pva6S2/kgmwvRFtXR9HeANA
	JV2nh6FKF67lm+v+FoOPmNhRH54qRt6aAtI0fZnUAxSxRgBla44poWAyKfTNWLeJH6p5kZBDOiJ
	XPHuzEx1SlaMNO1QX8ZviIbm+cbi9uksu6xSGSvg8LupVyIIZ7MfFQV894LDkyaoSfeM+EjJWU7
	rFZjhtFAg2T1jIQB7zAFvYew1i6pSeJoBMA1rKDQkvxEmtqRFMcsw/4VkZYOx26orvB1ylL9iBf
	t//seDlk2qFmv335eD5O1JkD0=
X-Received: by 2002:a05:6808:1209:b0:4a0:cf55:3cf0 with SMTP id
 5614622812f47-4b9613fc552mr3425955b6e.9.1788513738611; Fri, 04 Sep 2026
 02:22:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <bf0e79de-e726-45bd-97e5-ebe98869d416@mail.kernel.org>
In-Reply-To: <bf0e79de-e726-45bd-97e5-ebe98869d416@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 4 Sep 2026 11:22:05 +0200
X-Gm-Features: AcwNN1UVn3wQ28xmsMCSM7qfQucSyL3RJGPQnTTWe-e2Xc3DDCVI1spiSQI4Eg8
Message-ID: <CANp29Y5_8=N_4kAK9zQSGPGFof7Xk9OuNvp6iGQiBPS=zSjm3Q@mail.gmail.com>
Subject: Re: [PATCH RFC v2] configfs: fix use-after-free in configfs_symlink()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 3, 2026 at 5:39=E2=80=AFPM syzbot <syzbot@kernel.org> wrote:
>
> In configfs_symlink(), inode_unlock(dir) is called before resolving the
> symlink target via get_target() to avoid deadlocks during pathname lookup=
.
> When configfs_symlink() operates within a default group (such as
> ports/1/subsystems/ in NVMe-oF target), parent_item is an embedded defaul=
t
> group inside the dynamically allocated parent object (struct nvmet_port).
> Because default groups are embedded within their containing structure,
> holding a reference to parent_item alone does not prevent the containing
> parent structure from being freed when a concurrent configfs_rmdir()
> removes the root directory.
>
> When configfs_rmdir() runs concurrently while inode_lock(dir) is dropped =
in
> configfs_symlink(), it detaches all default groups, unlinks the root grou=
p,
> sets frag_dead to true, and drops the subsystem's reference to the root
> group. Once the root object's refcount drops to zero, the entire containi=
ng
> structure is freed via kfree(). When configfs_symlink() re-acquires
> inode_lock(dir), accessing parent_item in allow_link() accesses freed
> memory, causing a slab-use-after-free:
>
> BUG: KASAN: slab-use-after-free in nvmet_port_subsys_allow_link+0x41/0x2e=
0
> drivers/nvme/target/configfs.c:1059
> Read of size 8 at addr ffff88811c6d44c8
>
> Call Trace:
>  <TASK>
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  nvmet_port_subsys_allow_link+0x41/0x2e0
>  drivers/nvme/target/configfs.c:1059
>  configfs_symlink+0x59a/0x1030 fs/configfs/symlink.c:196
>  vfs_symlink+0x18b/0x330 fs/namei.c:5794
>  filename_symlinkat+0x1cd/0x410 fs/namei.c:5819
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
>
> Allocated by task 5847:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
>  nvmet_ports_make+0xe6/0xf00 drivers/nvme/target/configfs.c:2051
>  configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1360
>  vfs_mkdir+0x40c/0x620 fs/namei.c:5410
>  filename_mkdirat+0x285/0x510 fs/namei.c:5443
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 5847:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kfree+0x1c5/0x650 mm/slub.c:6792
>  config_item_release+0x13a/0x2d0 fs/configfs/item.c:137
>  configfs_rmdir+0x885/0x950 fs/configfs/dir.c:1571
>  vfs_rmdir+0x3e6/0x6a0 fs/namei.c:5515
>  filename_rmdir+0x292/0x520 fs/namei.c:5572
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Fix this by:
> 1. Adding configfs_get_root_item() to walk up the dentry tree past any
> default groups (CONFIGFS_USET_DEFAULT) while holding inode_lock(dir) to
> acquire a reference to the root object (root_item), preventing the
> containing structure from being freed while inode_lock(dir) is dropped.
> 2. Checking sd->s_frag->frag_dead after re-acquiring inode_lock(dir) to
> detect if the directory was removed during the unlocked window, returning
> -ENOENT instead of calling allow_link().
> 3. Releasing parent_item before root_item in the out_put cleanup path so
> that the embedded item reference is dropped while the memory of the
> containing root object remains pinned.
>
> Fixes: 351e5d869e5a ("configfs: fix a deadlock in configfs_symlink()")
> Assisted-by: Gemini:gemini-3.7-flash syzbot
> Reported-by: syzbot+b0996ac2197dd7420c3e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Db0996ac2197dd7420c3e
> Link: https://syzkaller.appspot.com/ai_job?id=3D235023c6-930a-499e-adf7-3=
e465635dbd3
> To: "Breno Leitao" <leitao@debian.org>
> To: <linux-kernel@vger.kernel.org>
> To: "Al Viro" <viro@zeniv.linux.org.uk>
> Cc: "Andreas Hindborg" <a.hindborg@kernel.org>
>
> ---
> v2:
> - Use !IS_ROOT(root_dentry) to terminate the dentry traversal in configfs=
_get_root_item()
> - Only call configfs_get_root_item() when parent is a default group (CONF=
IGFS_USET_DEFAULT) and handle errors
> - Check IS_DEADDIR(dir) and d_unhashed(dentry->d_parent) alongside frag_d=
ead after re-locking dir
> - Move config_item_put(target_item) into the out_put error path
>
> v1:
> https://lore.kernel.org/all/ccce0ada-669c-4d3b-929a-5e95de4e54dd@mail.ker=
nel.org/T/
> ---
> diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
> index 31eb28b27..a00f27c89 100644
> --- a/fs/configfs/symlink.c
> +++ b/fs/configfs/symlink.c
> @@ -131,6 +131,19 @@ static int get_target(const char *symname, struct co=
nfig_item **target,
>         return 0;
>  }
>
> +static struct config_item *configfs_get_root_item(struct dentry *dentry)

here and in other parts of the patch: is it really a root item? or
rather containing item?

> +{
> +       struct dentry *root_dentry =3D dentry;
> +       struct configfs_dirent *sd;
> +
> +       while (!IS_ROOT(root_dentry)) {
> +               sd =3D root_dentry->d_fsdata;
> +               if (!sd || !(sd->s_type & CONFIGFS_USET_DEFAULT))
> +                       break;
> +               root_dentry =3D root_dentry->d_parent;
> +       }
> +       return configfs_get_config_item(root_dentry);
> +}
>
>  int configfs_symlink(struct mnt_idmap *idmap, struct inode *dir,
>                      struct dentry *dentry, const char *symname)
> @@ -139,6 +152,7 @@ int configfs_symlink(struct mnt_idmap *idmap, struct =
inode *dir,
>         struct configfs_dirent *sd;
>         struct config_item *parent_item;
>         struct config_item *target_item =3D NULL;
> +       struct config_item *root_item =3D NULL;
>         const struct config_item_type *type;
>
>         sd =3D dentry->d_parent->d_fsdata;
> @@ -157,6 +171,18 @@ int configfs_symlink(struct mnt_idmap *idmap, struct=
 inode *dir,
>             !type->ct_item_ops->allow_link)
>                 goto out_put;
>
> +       /*
> +        * Pin the root object so that the parent_item (which may be an
> +        * embedded default group) is not freed while we drop the lock.
> +        */
> +       if (sd->s_type & CONFIGFS_USET_DEFAULT) {
> +               root_item =3D configfs_get_root_item(dentry->d_parent);
> +               if (!root_item) {
> +                       ret =3D -ENOENT;
> +                       goto out_put;
> +               }
> +       }
> +
>         /*
>          * This is really sick.  What they wanted was a hybrid of
>          * link(2) and symlink(2) - they wanted the target resolved
> @@ -187,6 +213,12 @@ int configfs_symlink(struct mnt_idmap *idmap, struct=
 inode *dir,
>         if (ret)
>                 goto out_put;
>
> +       if (sd->s_frag->frag_dead || IS_DEADDIR(dir) ||

Can't one concurrently write to frag_dead? Will it not trigger a KCSAN
bug (and other problems)?

> +           d_unhashed(dentry->d_parent)) {
> +               ret =3D -ENOENT;
> +               goto out_put;
> +       }
> +
>         if (dentry->d_inode || d_unhashed(dentry))
>                 ret =3D -EEXIST;
>         else
> @@ -203,10 +235,10 @@ int configfs_symlink(struct mnt_idmap *idmap, struc=
t inode *dir,
>                                                      target_item);
>         }
>
> -       config_item_put(target_item);
> -
>  out_put:
> +       config_item_put(target_item);
>         config_item_put(parent_item);
> +       config_item_put(root_item);
>         return ret;
>  }
>
>
>
> base-commit: cee9395acd8043be0644b25c34bfa86623f2b935
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
