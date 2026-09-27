Received: from mail-oi2-f12.google.com (mail-oi2-f12.google.com [74.125.231.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFA8A3A9631
	for <syzbot@lists.linux.dev>; Sun, 27 Sep 2026 22:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.204
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790548179; cv=pass; b=M3fmPYwXOxTVw4N7bskeGCAhoc92b/jRWXMm2yFxxfUzSedAbPU0XVBw98HICrj/ZQdE1Eua1avzrz74QTVTQ23+7aeqEKSOmqFZyRvxWjlPTTvWlB6mssiWrklA5RLJ0DVkyOByAJekbJGAVVmHEXgx9HYnRne6fa8lWLYhKIw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790548179; c=relaxed/simple;
	bh=d23l17CvkK81KX7b98MGm2JDa523U4rhoEx7CM8c6r4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=A2fLY2m/T8MAneZeNFn7K1dK+76UzTDoPnDzLpQwUAVvF6kq1hBvC4ORf3w8X8qWW3L5qoWtqUYRQlCpTK0tosFyo2xSz+o1C4sXbVAhtbNtG5u4Tqc58sHTXDKj+A9wvqZMKYpYdpT0IJiopcBT8mpzEaweKiMW0JWIMMY51ds=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=WrjFK012; arc=pass smtp.client-ip=74.125.231.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="WrjFK012"
Received: by mail-oi2-f12.google.com with SMTP id 5614622812f47-4b37a29bf27so1102676b6e.2
        for <syzbot@lists.linux.dev>; Sun, 27 Sep 2026 15:29:36 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790548175; cv=none;
        d=google.com; s=arc-20260327;
        b=cNrqayN3jeki64nGm6DOovveyRM2cHr0oDWBAz2/Y+MwEm7eOs2Il9MjkpiAhNGVc4
         3HAEipOA7pC3RD0VmEsgCROyujEBNp3O4lSb4mooMiALG72pRX7Vp+B8+rgF7NSOt6Bi
         q52XV0wCrbrTg6aZD7u1HCfHi9tYvLEF0EeLBAybQ+9lea7INXXjcjnilGwrkhIa3Trs
         9/Z+dHiuhRMVY7/ZAfryF8Miv1O2sJvp0vpdAnp+atMgqzR+OU0dyarxJv4rtcidJsNs
         jIYDKDFwQ3diiGb2QneVf41vlx9yJOStigBYFnJNS4ZTnLPLKaAtpmcshtEWmt6tsWaM
         dgGg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bnrcxjL3ClG0W8AkNt5z0+o9Mfhg/RJsvz6OjDaDOY4=;
        fh=DM3jZvNnvCXkVOt+9djRJ1CFCuRk1I1r8mLSvWgoO3w=;
        b=cwHz3bf+GFochIDuBN4XRzbmyPvnGy/Q31F9KiX3DDhWEpOYLJOHMQJrgPm10q69X0
         9wSwQsWVupmKuxQrccmwPWbzeuhAfmCM6MTvD++/SkxNIs7d+jRY1qw1pQSz3EI6vaiI
         /IQtBtxhh5LtPE5+GxvrFwZWzpYPdzviWLKr6hNfj2Jh1oILpIUEp4jhpNhMkqmeY95e
         JbeMOCiM53aKJF7cvTx+8AZKKEkevETJm5iY37cRLt62ufPSWO1gRTwGF7IXI2Jc68Jm
         DUuiHpu4U3VrmUwmTxmbVaYhLaPr7tRswuUUMQI6SwtoX/Z6ayDWAV+teaCM6w1VJyCs
         Eupw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790548175; x=1791152975; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=bnrcxjL3ClG0W8AkNt5z0+o9Mfhg/RJsvz6OjDaDOY4=;
        b=WrjFK012PeCVSiappn0imrJEFYv8JDBPXNKKIUDgJtoCflgXwf25g/tmA1m91lAMlO
         ZJLY3ajAeolN9XtWqV0ZufjIalIocge60m5bsfKYYed+09r1P86rGPThF1C0Y7kPghPr
         asYWVPpLbJYF6sZAqSsHvsVg268rJl2W3Vfdzq4SpdU95j6RBBkvT/6UWk8HzCqRJrDk
         4oU/q2CYE5mJaqwSe7ChFnb/iUcbYgkKUFLKf4gz+RiVP6uNaEkbP0ibc7vaUAjOO47V
         82nhqdvWCqDuzu87FZ8jyaRxdsLSJeCEoxnpTPx3l3WuiwFnA22Ca+9FnN7YmNhXJ4d8
         Pbaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790548175; x=1791152975;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bnrcxjL3ClG0W8AkNt5z0+o9Mfhg/RJsvz6OjDaDOY4=;
        b=gRd4eSxjbZfjN9DM/67TmgAjZ1Y/K/7hQISa6QfdLQCX1DPXlu1CFl1dKX8M2P9YAs
         t7QDObZ/oZpXwVo3xkD5PYt/OfJAnG4+4pPOR8i0TRivzP2tMT4vbvhzcMiJ4ou1fCbl
         IVCw9mI63WfuR+1yZynkJRzUkg7WphLBHnKV6/x3lGrUZA7QnTs+rX0OhTq6KEWIIZbd
         lHopeYaUJPq/npJMjmjP4Ck5jJWBXVRC5A7fkj84rk+xGgUxsaWc+ZhBTnE7mMsGxm2E
         iKprLSKKmwQ2HBuIQY4qKXdp7Z4eD180Rl7joUbfvchtmErWpn63YGyWXjN2VJZZvLHE
         cdOw==
X-Forwarded-Encrypted: i=1; AKwUvByP4gTap/ObV/EzSvGMNg6YEnCqOS3MXSvT0KUH2pyHon7knP4zOOw2kynY4EsDT9nTDV7Goi4=@lists.linux.dev
X-Gm-Message-State: AFuF++mFa19VG2xV8DY9W0zC9q8ALJz7tm3Ck95Sta8fFneAjdPu1zSY
	a/dvZKVGaNVRl2ksc0fgfFidn3rcXIebZ8+7X99F+OWM25scZU1Flzf50jwAxjkWLYMBb7cQVFT
	lCvQiJoNc19p4dkr3LZhEnrqEK2hvi0G7cSWwIo5mobOt78TicEV+w5uB
X-Gm-Gg: AYBFou0wFYicjRM3H8ffWKlJZUh9dF0FmosNa2ss2gIAYuVbPPHhKP7b98I0CNv3xUe
	SDjrwnAVymKCgvGY+Y5ttNhCI+CkFd5TfWTGH5yj3vF6fUpP8Nx4qY5LeL8S77ZRkg64XrH8vQf
	b5PrCNEplWiQaBrtTDcNOVfOlWmGaXfqsgwoSr84CNUyI7jr4X7KhYc+S1Sbl1CuGUmH3baPhrF
	loLe5QNuo3wKhhRSgnMopVbUNLQjOaPCN02PYRwov1o4Xp9RbBb0tSCnDt7xs/WwEsOX5ilfOhQ
	iZAnYoitjibIFpJGpUdmS2AXdfKgrf9ndw+fCVEuBSli74k12D8VPHyAhqnZBnB5qxVDZuwpK8G
	GFklhlnVYD08eSSMOU7j4B3rX/b2HcTybxR7Rba75p0QuOUqiVeF56qdXc/A3FgASQluCx8sH86
	jVshht
X-Received: by 2002:a05:6808:3c46:b0:4e9:3412:14a5 with SMTP id
 5614622812f47-4e9341247demr2520161b6e.28.1790548174794; Sun, 27 Sep 2026
 15:29:34 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ab95c36.80e1c6cc.1e8e5f.0063.GAE@google.com>
In-Reply-To: <6ab95c36.80e1c6cc.1e8e5f.0063.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 27 Sep 2026 18:29:23 -0400
X-Gm-Features: AclHuK96lgWg2nTQF0AzlwBp9lal3o90YcVdlk9GlW3zq7oH_3BsSO3WAVEJ-Z0
Message-ID: <CANp29Y4oGWq4KMrXh21ap-2s3vH0ovWqTXEiLdRX7m-OoCEe0A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: nfc: llcp: prevent resource leak on repeated
 connect after DM
To: syzbot ci <syzbot+ci6725795c7a91aa7a@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Sep 27, 2026 at 2:11=E2=80=AFPM syzbot ci
<syzbot+ci6725795c7a91aa7a@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] nfc: llcp: prevent resource leak on repeated connect after DM
> https://lore.kernel.org/all/20260925184857.357926-1-qwe.aldo@gmail.com
> * [PATCH net v2] nfc: llcp: prevent resource leak on repeated connect aft=
er DM
>
> and found the following issues:
> * KASAN: slab-use-after-free Read in llcp_sock_connect
> * KASAN: slab-use-after-free Read in nfc_remove_device
>
> Full report is available here:
> https://ci.syzbot.org/series/5e0cb36e-53b9-46fb-95cf-63d7aa556657
>
> ***
>
> KASAN: slab-use-after-free Read in llcp_sock_connect
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      415f2044228cc8b948dc04e079aaa86a4d1aa1d3
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/b9c88e36-7160-4be9-b8c4-0246fd730=
eef/config
> syz repro: https://ci.syzbot.org/findings/64002827-5231-4183-bfca-0d91bde=
d8543/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in kobject_put+0x2a2/0x550 lib/kobject.c:=
733
> Read of size 1 at addr ffff8881ae430054 by task syz.2.20/5885
>
> CPU: 0 UID: 0 PID: 5885 Comm: syz.2.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  kobject_put+0x2a2/0x550 lib/kobject.c:733
>  nfc_put_device net/nfc/nfc.h:103 [inline]
>  llcp_sock_connect+0x2f5/0xc50 net/nfc/llcp_sock.c:701
>  connect_socket net/socket.c:2141 [inline]
>  __sys_connect_file net/socket.c:2166 [inline]
>  __sys_connect+0x316/0x450 net/socket.c:2183
>  __do_sys_connect net/socket.c:2189 [inline]
>  __se_sys_connect net/socket.c:2186 [inline]
>  __x64_sys_connect+0x7a/0x90 net/socket.c:2186
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f012ed9e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f012fb8e028 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> RAX: ffffffffffffffda RBX: 00007f012f025fa0 RCX: 00007f012ed9e159
> RDX: 0000000000000060 RSI: 0000200000000380 RDI: 0000000000000004
> RBP: 00007f012ee3506b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f012f026038 R14: 00007f012f025fa0 R15: 00007fff3cb60738
>  </TASK>
>
> Allocated by task 5885:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
>  _kmalloc_noprof include/linux/slab.h:991 [inline]
>  _kzalloc_noprof include/linux/slab.h:1312 [inline]
>  nfc_allocate_device+0x129/0x560 net/nfc/core.c:1065
>  nci_allocate_device+0x1da/0x380 net/nfc/nci/core.c:1206
>  virtual_ncidev_open+0x75/0x1a0 drivers/nfc/virtual_ncidev.c:141
>  misc_open+0x2d5/0x350 drivers/char/misc.c:163
>  chrdev_open+0x4d9/0x600 fs/char_dev.c:411
>  do_dentry_open+0x816/0x1380 fs/open.c:996
>  vfs_open+0x3b/0x340 fs/open.c:1101
>  do_open fs/namei.c:4837 [inline]
>  path_openat+0x1443/0x1d60 fs/namei.c:5000
>  do_file_open+0x23e/0x4a0 fs/namei.c:5029
>  do_sys_openat2+0x115/0x200 fs/open.c:1417
>  do_sys_open fs/open.c:1423 [inline]
>  __do_sys_openat fs/open.c:1439 [inline]
>  __se_sys_openat fs/open.c:1434 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1434
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 5885:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2748 [inline]
>  slab_free mm/slub.c:6508 [inline]
>  kfree+0x1c5/0x650 mm/slub.c:6801
>  device_release+0xc4/0x1f0 drivers/base/core.c:-1
>  kobject_cleanup lib/kobject.c:689 [inline]
>  kobject_release lib/kobject.c:720 [inline]
>  kref_put include/linux/kref.h:65 [inline]
>  kobject_put+0x222/0x550 lib/kobject.c:737
>  nfc_put_device net/nfc/nfc.h:103 [inline]
>  nfc_llcp_local_put+0xb7/0xe0 net/nfc/llcp_core.c:196
>  llcp_sock_connect+0x2bb/0xc50 net/nfc/llcp_sock.c:698
>  connect_socket net/socket.c:2141 [inline]
>  __sys_connect_file net/socket.c:2166 [inline]
>  __sys_connect+0x316/0x450 net/socket.c:2183
>  __do_sys_connect net/socket.c:2189 [inline]
>  __se_sys_connect net/socket.c:2186 [inline]
>  __x64_sys_connect+0x7a/0x90 net/socket.c:2186
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff8881ae430000
>  which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 84 bytes inside of
>  freed 2048-byte region [ffff8881ae430000, ffff8881ae430800)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1ae4=
30
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000040 ffff888100042000 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000000080008 00000000f5000000 0000000000000000
> head: 057ff00000000040 ffff888100042000 dead000000000100 dead000000000122
> head: 0000000000000000 0000000000080008 00000000f5000000 0000000000000000
> head: 057ff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 5818, tgid 5818 (kworker/1:6), ts 69407176292
>  set_page_owner include/linux/page_owner.h:33 [inline]
>  post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
>  prep_new_page mm/page_alloc.c:1879 [inline]
>  get_page_from_freelist+0x2209/0x2280 mm/page_alloc.c:3943
>  __alloc_frozen_pages_noprof+0x217/0x5a0 mm/page_alloc.c:5436
>  alloc_slab_page mm/slub.c:3347 [inline]
>  allocate_slab+0x7d/0x620 mm/slub.c:3462
>  new_slab mm/slub.c:3513 [inline]
>  refill_objects+0x2d5/0x350 mm/slub.c:7417
>  refill_sheaf mm/slub.c:2885 [inline]
>  __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4774
>  alloc_from_pcs mm/slub.c:4850 [inline]
>  slab_alloc_node mm/slub.c:4984 [inline]
>  __do_kmalloc_node mm/slub.c:5413 [inline]
>  __kmalloc_node_track_caller_noprof+0x548/0x720 mm/slub.c:5545
>  kmalloc_reserve net/core/skbuff.c:637 [inline]
>  __alloc_skb+0x2c1/0x7a0 net/core/skbuff.c:715
>  alloc_skb include/linux/skbuff.h:1384 [inline]
>  mld_newpack+0x165/0xcb0 net/ipv6/mcast.c:1810
>  add_grhead net/ipv6/mcast.c:1921 [inline]
>  add_grec+0x119f/0x19d0 net/ipv6/mcast.c:2060
>  mld_send_cr net/ipv6/mcast.c:2185 [inline]
>  mld_ifc_work+0x6f1/0xd60 net/ipv6/mcast.c:2739
>  process_one_work kernel/workqueue.c:3396 [inline]
>  process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3479
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3560
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> page last free pid 5677 tgid 5677 ts 63170557312 stack trace:
>  reset_page_owner include/linux/page_owner.h:26 [inline]
>  __free_pages_prepare mm/page_alloc.c:1418 [inline]
>  free_pages_prepare+0x9eb/0xaf0 mm/page_alloc.c:1463
>  __free_contig_range_common+0x174/0x340 mm/page_alloc.c:7072
>  __free_contig_range mm/page_alloc.c:7117 [inline]
>  free_pages_bulk+0x48/0x120 mm/page_alloc.c:5322
>  vm_area_free_pages mm/vmalloc.c:3461 [inline]
>  vfree+0x231/0x490 mm/vmalloc.c:3510
>  kcov_put kernel/kcov.c:451 [inline]
>  kcov_close+0x28/0x50 kernel/kcov.c:556
>  __fput+0x418/0xa50 fs/file_table.c:512
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  exit_task_work include/linux/task_work.h:40 [inline]
>  do_exit+0x73a/0x2360 kernel/exit.c:1012
>  do_group_exit+0x22d/0x2f0 kernel/exit.c:1155
>  get_signal+0x121b/0x12c0 kernel/signal.c:3112
>  arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
>  exit_to_user_mode_loop+0x10e/0x770 kernel/entry/common.c:101
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:343 [inline]
>  do_syscall_64+0x328/0x520 arch/x86/entry/syscall_64.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff8881ae42ff00: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
>  ffff8881ae42ff80: fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe fe
> >ffff8881ae430000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                                  ^
>  ffff8881ae430080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff8881ae430100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: slab-use-after-free Read in nfc_remove_device
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      415f2044228cc8b948dc04e079aaa86a4d1aa1d3
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/b9c88e36-7160-4be9-b8c4-0246fd730=
eef/config
> AI triage: https://ci.syzbot.org/findings/5bf0d4c2-4b58-4382-be36-3546f60=
1db70/triage_trajectory
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in sysfs_remove_file_ns+0x3d/0x70
> Read of size 8 at addr ffff888177b8a048 by task syz.1.3888/17756
>
> CPU: 0 UID: 0 PID: 17756 Comm: syz.1.3888 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  print_address_description+0x55/0x1e0
>  print_report+0x58/0x70
>  kasan_report+0x117/0x150
>  sysfs_remove_file_ns+0x3d/0x70
>  device_del+0x503/0x8f0
>  nfc_remove_device+0xa7/0xc0
>  virtual_ncidev_close+0x56/0x90
>  __fput+0x418/0xa50
>  fput_close_sync+0x11f/0x240
>  __x64_sys_close+0x7e/0x110
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb42af9e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb42bdab028 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: ffffffffffffffda RBX: 00007fb42b226090 RCX: 00007fb42af9e159
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 00007fb42b03506b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb42b226128 R14: 00007fb42b226090 R15: 00007fff6f3d29a8
>  </TASK>
>
> Allocated by task 17749:
>  kasan_save_track+0x3e/0x80
>  __kasan_kmalloc+0x93/0xb0
>  __kmalloc_cache_noprof+0x321/0x600
>  nfc_allocate_device+0x129/0x560
>  nci_allocate_device+0x1da/0x380
>  virtual_ncidev_open+0x75/0x1a0
>  misc_open+0x2d5/0x350
>  chrdev_open+0x4d9/0x600
>  do_dentry_open+0x816/0x1380
>  vfs_open+0x3b/0x340
>  path_openat+0x1443/0x1d60
>  do_file_open+0x23e/0x4a0
>  do_sys_openat2+0x115/0x200
>  __x64_sys_openat+0x138/0x170
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 17756:
>  kasan_save_track+0x3e/0x80
>  kasan_save_free_info+0x40/0x50
>  __kasan_slab_free+0x5c/0x80
>  kfree+0x1c5/0x650
>  device_release+0xc4/0x1f0
>  kobject_put+0x222/0x550
>  device_del+0x4cb/0x8f0
>  nfc_remove_device+0xa7/0xc0
>  virtual_ncidev_close+0x56/0x90
>  __fput+0x418/0xa50
>  fput_close_sync+0x11f/0x240
>  __x64_sys_close+0x7e/0x110
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888177b8a000
>  which belongs to the cache kmalloc-2k of size 2048
> The buggy address is located 72 bytes inside of
>  freed 2048-byte region [ffff888177b8a000, ffff888177b8a800)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x177b=
88
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000040 ffff888100042000 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000000080008 00000000f5000000 0000000000000000
> head: 057ff00000000040 ffff888100042000 dead000000000100 dead000000000122
> head: 0000000000000000 0000000000080008 00000000f5000000 0000000000000000
> head: 057ff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd28c0(=
GFP_NOWAIT|__GFP_IO|__GFP_FS|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pi=
d 5596, tgid 5596 (syz-executor), ts 59551528746
>  post_alloc_hook+0x1f9/0x250
>  get_page_from_freelist+0x2209/0x2280
>  __alloc_frozen_pages_noprof+0x217/0x5a0
>  allocate_slab+0x7d/0x620
>  refill_objects+0x2d5/0x350
>  __pcs_replace_empty_main+0x2c8/0x6c0
>  __kmalloc_node_track_caller_noprof+0x548/0x720
>  pskb_expand_head+0x22c/0x13a0
>  netlink_trim+0x1b3/0x2c0
>  netlink_broadcast_filtered+0x6d/0xea0
>  nlmsg_notify+0xe3/0x1a0
>  rtnetlink_event+0x224/0x270
>  notifier_call_chain+0x1a5/0x3d0
>  netif_set_mac_address+0x393/0x4d0
>  do_setlink+0x9ad/0x4670
>  rtnl_newlink+0x15a3/0x1c30
> page last free pid 15 tgid 15 ts 54085035095 stack trace:
>  __free_frozen_pages+0xc93/0xd90
>  __folio_put+0x4b3/0x590
>  skb_release_data+0x573/0xab0
>  __kfree_skb+0x5d/0x210
>  e1000_clean+0x4ae/0x2bf0
>  __napi_poll+0xaa/0x330
>  net_rx_action+0x61d/0xf50
>  handle_softirqs+0x226/0x860
>  run_ksoftirqd+0x36/0x60
>  smpboot_thread_fn+0x565/0xa70
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>
> Memory state around the buggy address:
>  ffff888177b89f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888177b89f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff888177b8a000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                                               ^
>  ffff888177b8a080: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888177b8a100: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
> [davem@davemloft.net david@ixit.cz edumazet@google.com horms@kernel.org k=
uba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org oe-linux=
-nfc@lists.linux.dev pabeni@redhat.com qwe.aldo@gmail.com sashiko-bot@kerne=
l.org stable@vger.kernel.org]
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
-upstream-moderation/6ab95c36.80e1c6cc.1e8e5f.0063.GAE%40google.com.
