Received: from mail-oa2-f34.google.com (mail-oa2-f34.google.com [74.125.231.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC738411693
	for <syzbot@lists.linux.dev>; Wed, 30 Sep 2026 10:21:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.98
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790763692; cv=pass; b=SlGBoiPqzL77Lm1+5wY4BwAVngydj3K6XP9srn92/zpjlieOSsSequC6B6fOJllZW1BV0oz6wdHOzyf+x2puGkbZCLi3na/InkEupdtJxtDaN40B4T+ug4qI1p+wZqraXiHR4cTIua10vrxVkplzVutP/1iTsTJGNRWbjd2swn8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790763692; c=relaxed/simple;
	bh=kC9+ZIDJuczxC6wSmKfTCYunIqhqxMtJgMVRm8Mhadw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mvY4ka3TALZHDxFmKrRPlmd+yXA7NLvM2K3o+l7hhiXTEYQjLjPuT4/QW9tWg61K4GAv0ZOwYzzcFcSSg13fKKafPhEfyKJJCoyAklD3uCpfdA6aYXWMpkCfiD7N7n0stfd/H/xIGYCZ+DJFR8XWLDX1MnjcieSwyqkOxQloVM4=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uf5flEWG; arc=pass smtp.client-ip=74.125.231.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uf5flEWG"
Received: by mail-oa2-f34.google.com with SMTP id 586e51a60fabf-494ab4d6128so3271062fac.0
        for <syzbot@lists.linux.dev>; Wed, 30 Sep 2026 03:21:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790763682; cv=none;
        d=google.com; s=arc-20260327;
        b=jn7ln7nN/pvepEzNCQBjTmKUQ5vmjWNfBC9p8VX0wR1bnF26BTONYyZGRBwsZ4yAnn
         GEDj5dVay7MvWg7bMaclAWL/i6R3IciclgWIsfSVLlCZx5enMXuqwI8ae9ucMG7goKKK
         aaGY21S9BzZG/Mo2EMeyMcuC90JP4QxwlhZ/CJGg6SQTDXuK/89D0O1OkX+7tHjTobrD
         TUQT4vijd2WbPbMpDMEuAoJxU8C2GDNcooRWcnTKThLu2HNk1fUFaGhxzEBunNwWYPvi
         9hagusg6Nz3qQVTKJjeQB512K8L3+zXmIpsH7Vj5wQBJI1bXWvFMCHAa8lUqLJ8Bwswa
         nh4Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QTq82uvBqEpOL1c8wcLjAHHXwvsPyol4gbepgGMdOg8=;
        fh=JzW1dZ7E6CaG7DdOn+d10HEOYz9r5si4/3wOu66s/1I=;
        b=hpbC15BnxbiKJaWCFJ5FhlBgEwcunrw0HsLI1gwaSSWWqn6PH5Rep2tu9bqpDIqMuL
         CFIFcTvrg8ZBi044w4bLWUMDmvJRBdH3fwybMg2GZEDHrytgciHG46cGsXOuU6LvDKOH
         HwI0tZhW9b2B9mwkMt9z89IuL+ZKACC2ehumCGdjXfmIwdwB07s4kEPDClYSMnednk5C
         ZKmxSq+jEbjHe4PzDVTOVmn/5c2YYFWJy793/bKS228JMd4BHO4H5hpk2IqW201yE8d6
         eqQ7jNzoQ7QYjy6xYDlR53FavPrUmykYYjBUEkfGR7rpdV144Nex4OXyZNsf8+qL0eDM
         eW4w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790763682; x=1791368482; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QTq82uvBqEpOL1c8wcLjAHHXwvsPyol4gbepgGMdOg8=;
        b=uf5flEWGJxMmJ3gul678599yAGeCRQdg+6r4MazTdK7rNQztOVXtoK9K1xA9adyTbP
         NvYtljtHGu9AKmXzzKy3grNrFFzxC1l/h2x8KZ7BffxBAN6/5FpT/n4WOggnY9TukWqY
         rdv3Mz32zBCnGqac2ckQzP3NFRTfRrynnzSvpB721EibpzRX8tW3pNft6GmmaU/RXzyF
         EWBhy4wj7OPBrB7vSRZX4KaZIEW07p3SKO8gXkIMLsJJoGru08RIqOpWAbEwxIFNRhsV
         rLsnELsIvrgw/poQgjKkwepzccnqcOVNXMaL4V6G1w6bKFkRcpmaqqHHm1iwW72B0Uz7
         SpOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790763682; x=1791368482;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QTq82uvBqEpOL1c8wcLjAHHXwvsPyol4gbepgGMdOg8=;
        b=VrjxDV+NDExgVAhCC/uHsDa6RRRYH1AgE3+x19VekxWrbw5bWpJFRF3ynjr7V/o5we
         M03ZkSVb1znBmms0trJNeKMthmgqbfZ5cm0HaP/D2q2XJw/gEqyU6cI8IQuzsM+sKCKN
         gyPAdHlLmyx1AputU4VjE3xIy/K7Kz9wE4cIEngWtc4AGlfutDWo5K6xSA7QciGrX9FQ
         qaEVYx8tktEiVhN3i/gud2dBUECui2oKJVo9k7vCS9qW5Da3icWTpnl7WvGiluI3fySh
         +e5ypL+vGmqkEsRZa/XE0gN4kLC7/CxIOYXzdZh3eoH35HhsYqnQFHtRZrbzpWRs0PVH
         sgCQ==
X-Forwarded-Encrypted: i=1; AKwUvBwdoH2kTPVc4qyK8i6RWvF7dsASk8rMszqOCabHAfbpzWuvy8K+2zCNkjrBVw+2kKBiTXRnWc0=@lists.linux.dev
X-Gm-Message-State: AFuF++khNKmOQf4AGonjCjeXQLSNaBJbEZbP1z1YHEF/nu/JVr4U36Sz
	YeLo58lriKQPQWiAHwoZN+ufMkHMjAbfVvMMOvNx70Rmgkpee02URjK1Igua2OZ/yeH1x/mObyg
	YS0KnyAW338t5o8Rv2K7vUE9cketpWfBg0rLQ/3Kk
X-Gm-Gg: AYBFou02bMRSWQVZSgHhNq6+8twPVlj6jLLYRT1eIwjTzhf9AA73izpR/JRRBz0SYRf
	tFBV1wWmesUoTFRsYsLniULhukQXanW+0XcD+3zNw/8VaOqMCgl+XZheH6lRAz+OvIEDJ6c2Bhc
	BJ0az3dKMuCS3WiA6HeWOVzajTePQ2KJP5VLTBnyyKgSCk+8LjkXY263RBMJAZzRbCcGzmEBlym
	MINmKcLjHtVL/dlgE8rvQTWHT/6HuE9AL+iLgDjjI41kDmugF8dDQanhAlQqtZb1jly1HboTg1b
	0e640zqbjcBrHCARC9Go0AdXqrPY4HKQ7r5SmqsUIyi0XmKRitvG6cXzTaBUomHw6OQ/HjlR72X
	kztCtM5ULbBBDcD/slLo1TmGwtgt9kIZuNijw5+kHzffZX+leO2PDvmzy3L26OGCH0PE/oJBaVy
	IH2dlx5b4Qos88S2oaYBUUFNU=
X-Received: by 2002:a05:6808:4488:b0:4c2:2fb4:3676 with SMTP id
 5614622812f47-4f1b4c6c610mr883422b6e.16.1790763681336; Wed, 30 Sep 2026
 03:21:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6abce21d.80e1c6cc.22483f.0000.GAE@google.com>
In-Reply-To: <6abce21d.80e1c6cc.22483f.0000.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 30 Sep 2026 12:21:08 +0200
X-Gm-Features: AclHuK-2I3CaBoolWSNE9bqDQWnbexzsWOgWqdq8i2jnNlDcOhRw5k114meyJgE
Message-ID: <CANp29Y7jda5iZXYu-0K+HCd0bLxmF-rKdeEnUF1eCOb0bhXrcQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: multiple-filesystems: prepare for changes to
 VFS locking
To: syzbot ci <syzbot+cie5f097f0663789ec@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Sep 30, 2026 at 12:19=E2=80=AFPM syzbot ci
<syzbot+cie5f097f0663789ec@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] multiple-filesystems: prepare for changes to VFS locking
> https://lore.kernel.org/all/20260929034158.1455429-1-neilb@ownmail.net
> * [PATCH 1/7] VFS/xfs/ntfs: drop parent lock across d_alloc_parallel() in=
 d_add_ci()
> * [PATCH 2/7] shmem: use d_duplicate()
> * [PATCH 3/7] coda: don't d_drop() early.
> * [PATCH 4/7] configfs: remove d_add() calls before configfs_attach_group=
()
> * [PATCH 5/7] hostfs: don't d_drop() before d_splice_alias() in hostfs_mk=
dir()
> * [PATCH 6/7] procfs: drop parent lock for d_alloc_parallel() in iterate_=
shared()
> * [PATCH 7/7] ovl: stop using lookup_one() in ovl_iterate().
>
> and found the following issue:
> WARNING in __d_instantiate
>
> Full report is available here:
> https://ci.syzbot.org/series/b87296ff-c49f-416e-834c-a886ea8bd6c3
>
> ***
>
> WARNING in __d_instantiate
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      3879f51857325da9bf3cfb073280257cd16ae067
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/dd8fcfa5-13f0-458f-bd3b-9c06d4d67=
a78/config
> syz repro: https://ci.syzbot.org/findings/fdffe42d-ac1a-40d9-b05c-014808f=
5b0ec/syz_repro
>
> ------------[ cut here ]------------
> d_in_lookup(dentry)
> WARNING: fs/dcache.c:2197 at __d_instantiate+0x3f4/0x700 fs/dcache.c:2197=
, CPU#1: syz.0.17/5823
> Modules linked in:
> CPU: 1 UID: 0 PID: 5823 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__d_instantiate+0x3f4/0x700 fs/dcache.c:2197
> Code: 03 41 80 f6 01 41 0f b6 ce c1 e1 0d 09 c1 89 0b 48 83 c4 10 5b 41 5=
c 41 5d 41 5e 41 5f 5d e9 03 26 96 09 cc e8 0d 84 75 ff 90 <0f> 0b 90 e9 7f=
 fd ff ff e8 ff 83 75 ff 41 81 cc 00 00 01 00 e9 34
> RSP: 0018:ffffc900038d73a0 EFLAGS: 00010293
> RAX: ffffffff825242a3 RBX: ffff8881b4eef380 RCX: ffff888169801e00
> RDX: 0000000000000000 RSI: 0000000001000000 RDI: 0000000000000000
> RBP: 0000000001000000 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff5200071ae6c R12: 0000000000280000
> R13: dffffc0000000000 R14: ffff8881bc29f3e0 R15: ffff8881bc29f3e4
> FS:  00007f15d1af96c0(0000) GS:ffff8882a8cc9000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000001000 CR3: 00000001bd5c4000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  d_make_persistent+0x8e/0x180 fs/dcache.c:3139
>  shmem_mknod+0x2d4/0x340 mm/shmem.c:3851
>  shmem_whiteout mm/shmem.c:3982 [inline]
>  shmem_rename2+0x267/0x430 mm/shmem.c:4022
>  vfs_rename+0xbd9/0xef0 fs/namei.c:6219
>  ovl_do_rename_rd fs/overlayfs/overlayfs.h:371 [inline]
>  ovl_check_rename_whiteout fs/overlayfs/super.c:593 [inline]
>  ovl_make_workdir fs/overlayfs/super.c:713 [inline]
>  ovl_get_workdir+0x93d/0x1980 fs/overlayfs/super.c:836
>  ovl_fill_super_creds fs/overlayfs/super.c:1449 [inline]
>  ovl_fill_super+0x1702/0x4360 fs/overlayfs/super.c:1561
>  vfs_get_super fs/super.c:1405 [inline]
>  get_tree_nodev+0xbb/0x150 fs/super.c:1424
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1947
>  fc_mount fs/namespace.c:1198 [inline]
>  do_new_mount_fc fs/namespace.c:3772 [inline]
>  do_new_mount+0x319/0xdc0 fs/namespace.c:3848
>  do_mount fs/namespace.c:4181 [inline]
>  __do_sys_mount fs/namespace.c:4397 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f15d0b9e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f15d1af9028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
> RAX: ffffffffffffffda RBX: 00007f15d0e25fa0 RCX: 00007f15d0b9e159
> RDX: 0000200000000440 RSI: 0000200000000100 RDI: 0000000000000000
> RBP: 00007f15d0c3506b R08: 0000200000000080 R09: 0000000000000000
> R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f15d0e26038 R14: 00007f15d0e25fa0 R15: 00007ffe9e1b3308
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [a.hindborg@kernel.org amir73il@gmail.com anton.ivanov@cambridgegreys.com=
 baolin.wang@linux.alibaba.com brauner@kernel.org cem@kernel.org coda@cs.cm=
u.edu codalist@coda.cs.cmu.edu fuse-devel@lists.linux.dev hughd@google.com =
hyc.lee@gmail.com jack@suse.cz jaharkes@cs.cmu.edu jlayton@kernel.org joel.=
granados@kernel.org johannes@sipsolutions.net kees@kernel.org leitao@debian=
.org linkinjeon@kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.=
kernel.org linux-mm@kvack.org linux-um@lists.infradead.org linux-unionfs@vg=
er.kernel.org linux-xfs@vger.kernel.org miklos@szeredi.hu neilb@ownmail.net=
 ntfs@lists.linux.dev richard@nod.at viro@zeniv.linux.org.uk]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6abce21d.80e1c6cc.22483f.0000.GAE%40google.com.
