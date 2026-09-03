Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 704804BC020
	for <syzbot@lists.linux.dev>; Thu,  3 Sep 2026 14:45:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=3; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788446761; cv=pass; b=iCXOR+IaxD5x1Vn9ARisuWRv8yGWQEeqhmYsVYj7Q5SgOXMNWVgJMa4gCyOYofhu+pGeKGy7Ciq52I46LDnT1EwL5OZMfkYJyl8br5+IhT8rlN52XEvZlAVJOCcotxD4RLTGEVMocgLGF77DTc2aodJgf7ekc9bdq8qz84IyXrE=
ARC-Message-Signature:i=3; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788446761; c=relaxed/simple;
	bh=PMkwZy6XTmJwKyGQ/uFobYxiRlLnydrk6tQrD5kxEzE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=VwXovOi998QvG8PNE/4tiBA+6x7jsL5P4M8KT/TDsVkcuv3GuPyROAqUxejSlOEzkAjvMHsnDOY54MFKWmOrwPVdxC67TM4vbgmKDRiwDJSHOJ8Zx3mujQawRg8BupOHHhlC+X8QkUgiJXfZkLB3nKHDJrp+NJQ8vr1Wor2aRf0=
ARC-Authentication-Results:i=3; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=C56I+4ff; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="C56I+4ff"
Received: by smtp.kernel.org (Postfix)
	id 4EFB91F00A3F; Thu,  3 Sep 2026 14:45:59 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.54
ARC-Seal: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=pass;
	t=1788446759;
	b=yd+o47185hBTJxGBkTOINxWXqqWx/4UHZJn5P0pOUg4yxKlGa6/G5wwoq+3LSOO4c2SS
	 i/7NlNG1EXmotVK13t/rjDY2Opn/xyTzaeyYfGT7spp3L+JjXZAr0szW9gP2qxqzlUv46
	 cEYDGycDvjrF/0SIv9iv/uFBBCwX/xOnk/zSMW4RBW8Cayd8cF9e0wUhEgCfdVp/Jc8RA
	 RgsmQxZdwVF42LDdWwiDsG8F9+MeQuTrBKMqP02n0dOexqwv46VsN3ziDYVNnFOpIFXJp
	 POjUbsC5C6KlM4W4lxIDrFbiBGxQzjykZlYwbqZoVcdUx7E2sZQJ4dWxTXRMAyXvzRA==
ARC-Message-Signature: i=2; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1788446759;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:MIME-Version:References:
	 In-Reply-To:From:Date:X-Gm-Features:Message-ID:Subject:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=EaCpQ5H3P8vMJ7zgwbdPTqEshOgg9GMFKo0+i7pSdic=;
	b=SZOnSf35FiXy7DtjODSeDAySJ1J3gsx2NrE8uC7dxeo9kZLp9GNipINzOSzJJyUxLVkG
	 yu8dsDXts97unVaBohNTZzVqBN3FUYa/PaW3zeCjHrcSECLkr1BKi1TFTzRhFWCZSRpv5
	 A7mKM2XIisdv141xn5di+mlr/SECR/gqU7LMi5qSbcZibbPTcjrSXhP3etRXvpaXsoLUS
	 r+OYKWd5VV+P/AnFuCgFjZ/htFsv2I2SxXjTrWDD655XCtKzQiK1iYoOCq/MfXUu8dGHZ
	 sd6935+/zXj0x6PHAC16UVpd2dJuXoPFeoDmaEi5Bl/mWpIohfpVa6DnPfAscGSJ4Ng==
ARC-Authentication-Results: i=2; smtp.kernel.org; dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=C56I+4ff;
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.210.54
Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6B17B1F000E9
	for <syzbot@kernel.org>; Thu,  3 Sep 2026 14:45:58 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=C56I+4ff
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 6B17B1F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=google.com
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7eb5bdb50fcso1806019a34.1
        for <syzbot@kernel.org>; Thu, 03 Sep 2026 07:45:58 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788446757; cv=none;
        d=google.com; s=arc-20260327;
        b=WbEffqYM83ti71eJnng6C7aUn7Zbw/KxYQ1uRHRuA+FeU1v1nltEtzWD5SIXKlD/JF
         9l782hfzZDgLSHG763rr6WXs+YGI5Tbge4PJedvEYTpPjGIL1aYu2kk9cl5ppH5X0GnE
         fAZTUv4WPC0KV+jaE+wdr/Apbo43THZfd36RymU0LHk5AUN8SIxYPWpbGyEfuvpph57K
         hJLjdrxiuXuDglf7HpGnAFfWYi3Z3MQXBRgCNNo2z5DtLvrcOfBfYro5xjkNH96IJ2oT
         4uZtpj8tK8LR8VUEWrMhcxyrmmoSZSeDvV7EyaWMS5ob2Bjq8p4NzX2hBtOdgAtUIdAE
         JmCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=EaCpQ5H3P8vMJ7zgwbdPTqEshOgg9GMFKo0+i7pSdic=;
        fh=2Ld/g5BVZzBadtquf8mrXl84q+iOtbUed/2ECOFnmmI=;
        b=j48IMOVtYDh0po2ryzzAD8mLtXEBx8bwGImF2rUcdh1H9BVMR7FEHBz/mCgkQo6N2C
         SkL4G0fKxk6mDj5EAlTeWmpdB2MQbnv6Xl10bMCk8SkCA6KRBVA5F9mPX/AJVaZPnMZC
         H/8o0VO/rp5pdq2lU0+oLEysx5nxov4b2mGB2p1NARXnOoeZ6SMQ1roQQSaNNrBgcrrW
         IaYcRgX/G0adKhEEpuWgEywncf6K/UOLneSPbsCAhE1h/5/mz4n9Hj/S8YTNXEWuMqHz
         CVKHByX4gfuv6AbMAPrUiuaG4ShDcnZYieNmRMVkqtjisyIs9NvH30HVoh6Dz0d8zMA4
         t+ZA==;
        darn=kernel.org
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788446757; x=1789051557; darn=kernel.org;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=EaCpQ5H3P8vMJ7zgwbdPTqEshOgg9GMFKo0+i7pSdic=;
        b=C56I+4ff+l4TlVCC0jx+IeGczludAk4RDSxbrX/VH7M4VXD/Hl9YeDplVOkYoiFAz/
         cLS3OpM2poy1NZoZwIZNL62WT4GjHnrBr0il73A+mvGe06nlzFpCPWuz7l1fJkCMEep4
         JuIO495LXtnJ/TIru+mL1dneIHyJdB9blRpMpTH2PKD/y5A2CfeFzTkJnzjNRiuGlI5s
         aSWnt8hVNv2wxHVyyfDqxUmLz38bg94LyLC9TOkCWmJN7zlKDCewVjGRaJSFevLWw90a
         aOG7nQYnYWaMrnp/a1V30A3Emqlz5loWpbchGoo+5SR6cUGuGwRi06i+B3hE9TTj4KCS
         +aWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788446757; x=1789051557;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EaCpQ5H3P8vMJ7zgwbdPTqEshOgg9GMFKo0+i7pSdic=;
        b=qQkvbQgBPhN33SVZFdBp4aASd7Sa23A5wUx4gqMfXbusor47+/nKHsjL37jDwTSMy3
         hhtey+e9/DxAkSM6y6i3NCLOMWNmG3wzTMZyD+V8lrxrFNhkY2CAG3PftvUQiwvpRCXr
         XhQH30zFKlSqgXPksMTnbTUqMdUB8dKYyN9jykLfWkX/tbhT6TS+OnseUgaEUMLm9DLq
         Skq0mEM/SsN1uAh8qW7DfpxlcIDngq72FQlWl3PS3qRFEWoDFRBz/uaYrI7whiDXuYZ5
         GASn1Vme3hvnF2Qg4dRskQ6RENQ7fo/k3donyAoofK7BbhiSgASRi766/q3F+QC2E/1x
         uI+g==
X-Gm-Message-State: AFuF++nqqVbaCQH5XVgemBBasRyEBNCLqwAqx712cX8JuR8jfRZiQJd4
	dkod2XuYL33YdewW60HATonN5+5J0uH7EZ1ObwhTx7FKHb9CTgzBAiZvV5ySQhOM2yoXaEMXRk4
	ngCsxbJ86kohVvuf+4u9TgwE3/eQGrA3mm/lwvRU5JGC4joH4MTCBwU/LmaM=
X-Gm-Gg: AYBFou3ZqIDuYxPhC/vpMEk7YwspeICaL32MWsozm4OY5YaYhXV1mFZ9cws+CHep++K
	IK4f4W4zCmmZJAhk5S7hjDa+k68VykFJxd85PxBEv1Gx6kTBFE/083DE6jJdUnackEnRTs7sKx2
	q2tOJlFHbBEgeP1p9vIrNCj4K0n1qRazf/rYxoDdq6K+COriL9cK24xbfUMvlxv1Fu3jGyShB/u
	AP8eV9GfuG94VcU0MR6NPAG8vdPW7elW7rIyPuPt3XqvAcLpM+NvBJesyRsr5qTtWeQ3sCuNJTS
	GrzIm0a9dSnvZXAqupP6Jy9v7fdNF3LpEDVGs0AGdTpZh2PHX5oOU1bMKz+EG+PjBYMJNso8g3v
	adb6iYWeR7Aa1Q6HiteQgAjwYTOXchURtnwOtbWc6wiB1mXEcW626rUelVu7z0MgZ5nSE7fiBH3
	qF6toZlv2dNHkC
X-Received: by 2002:a05:6830:638a:b0:7e9:cd7a:7c34 with SMTP id
 46e09a7af769-7f9e84b6b14mr459149a34.10.1788446756511; Thu, 03 Sep 2026
 07:45:56 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <ccce0ada-669c-4d3b-929a-5e95de4e54dd@mail.kernel.org>
In-Reply-To: <ccce0ada-669c-4d3b-929a-5e95de4e54dd@mail.kernel.org>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 3 Sep 2026 16:45:45 +0200
X-Gm-Features: AcwNN1Umq5Ll229aWd_jHFX9_v54Elt20-6R8ciwHkDQMhndQLAY42KiaPsrL8E
Message-ID: <CANp29Y6-9bX80=yQf1Mi7fGh9hbtGES-K6cay3+yK-NgukByhA@mail.gmail.com>
Subject: Re: [PATCH RFC] configfs: fix use-after-free in configfs_symlink()
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

    1. Check ordering & error code: If the directory was removed while unlo=
cked,
       vfs_rmdir()'s shrink_dcache_parent() can unhash dentry. Because
       `d_unhashed(dentry)` is checked before `frag_dead`, configfs_symlink=
()
       erroneously returns -EEXIST instead of -ENOENT. The deletion check
       belongs immediately after re-acquiring inode_lock(dir), before touch=
ing
       dentry or calling inode_permission().
    2. Incomplete deletion check: Beyond frag_dead, please also check stand=
ard
       VFS deletion indicators: `IS_DEADDIR(dir) ||
d_unhashed(dentry->d_parent)`.
    3. Unchecked root_item: If dentry->d_parent is a default group and
       configfs_get_root_item() returns NULL, the code drops inode_lock wit=
hout
       pinning anything, leaving the UAF open. It must bail out with -ENOEN=
T.
    4. Redundant refcount on regular groups: configfs_get_root_item() takes=
 an
       unnecessary second ref on non-default groups (which already pin
themselves).
       Only call it when `sd->s_type & CONFIGFS_USET_DEFAULT`.
    5. Root loop: In configfs_get_root_item(), `dentry->d_parent` at
filesystem root
       points to itself (never NULL); use `!IS_ROOT(root_dentry)` for trave=
rsal.

On Thu, Sep 3, 2026 at 12:23=E2=80=AFAM 'syzbot' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
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
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+b0996ac2197dd7420c3e@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Db0996ac2197dd7420c3e
> Link: https://syzkaller.appspot.com/ai_job?id=3De3aa1920-4324-4492-b79e-d=
ffb87dfa600
> To: "Breno Leitao" <leitao@debian.org>
> To: <linux-kernel@vger.kernel.org>
> To: "Al Viro" <viro@zeniv.linux.org.uk>
> Cc: "Andreas Hindborg" <a.hindborg@kernel.org>
>
> ---
> diff --git a/fs/configfs/symlink.c b/fs/configfs/symlink.c
> index 31eb28b27..5fe3722bd 100644
> --- a/fs/configfs/symlink.c
> +++ b/fs/configfs/symlink.c
> @@ -131,6 +131,19 @@ static int get_target(const char *symname, struct co=
nfig_item **target,
>         return 0;
>  }
>
> +static struct config_item *configfs_get_root_item(struct dentry *dentry)
> +{
> +       struct dentry *root_dentry =3D dentry;
> +       struct configfs_dirent *sd;
> +
> +       while (root_dentry) {
> +               sd =3D root_dentry->d_fsdata;
> +               if (!sd || !(sd->s_type & CONFIGFS_USET_DEFAULT))
> +                       break;
> +               root_dentry =3D root_dentry->d_parent;
> +       }
> +       return root_dentry ? configfs_get_config_item(root_dentry) : NULL=
;
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
> @@ -157,6 +171,12 @@ int configfs_symlink(struct mnt_idmap *idmap, struct=
 inode *dir,
>             !type->ct_item_ops->allow_link)
>                 goto out_put;
>
> +       /*
> +        * Pin the root object so that the parent_item (which may be an
> +        * embedded default group) is not freed while we drop the lock.
> +        */
> +       root_item =3D configfs_get_root_item(dentry->d_parent);
> +
>         /*
>          * This is really sick.  What they wanted was a hybrid of
>          * link(2) and symlink(2) - they wanted the target resolved
> @@ -192,8 +212,12 @@ int configfs_symlink(struct mnt_idmap *idmap, struct=
 inode *dir,
>         else
>                 ret =3D inode_permission(&nop_mnt_idmap, dir,
>                                        MAY_WRITE | MAY_EXEC);
> -       if (!ret)
> -               ret =3D type->ct_item_ops->allow_link(parent_item, target=
_item);
> +       if (!ret) {
> +               if (sd->s_frag->frag_dead)
> +                       ret =3D -ENOENT;
> +               else
> +                       ret =3D type->ct_item_ops->allow_link(parent_item=
, target_item);
> +       }
>         if (!ret) {
>                 mutex_lock(&configfs_symlink_mutex);
>                 ret =3D create_link(parent_item, target_item, dentry);
> @@ -207,6 +231,7 @@ int configfs_symlink(struct mnt_idmap *idmap, struct =
inode *dir,
>
>  out_put:
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
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/ccce0ada-669c-4d3b-929a-5e95de4e54dd%40mail.kernel.org=
.
