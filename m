Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 274091EA7CE
	for <syzbot@lists.linux.dev>; Wed,  3 Sep 2025 17:44:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756921481; cv=none; b=PqgGygpZ7SG9H9QR0ffPptO1WFc0qfOuP+USUeiS+eDUEpM9tQzg0cQytIMYX3c+k+b95D60JqkBxshxuvb/Tqb3xwyDCsFKbkphaCfJXMozJmjtT4tzYfuVlDVr/yZmUUJa8XgwE8NEaY9gQwNoQArgzh96KO1AeMaMGyILWRw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756921481; c=relaxed/simple;
	bh=ZHgL8abQp8EZ8CmxI0Pp6aojsr85LnhrR+XvlbG8Rwo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IJz1hpTvtWk+zOqopJMqEVUJOeoPmR1neeNUYlTrwt8QET0pr7eplGpEmBgPDufXBjeXqlf1UeTNIx5qVtTTCYUmzHNGljtKOBmmFR1g+cDbglZSU6EuzESueE1Y6dBmWfJXcyf/+YsqJgjPZCKhgtHbyqF57AmgyZEXaFQNfy0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=piU33fmO; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="piU33fmO"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-61e4f5f46cfso60737eaf.0
        for <syzbot@lists.linux.dev>; Wed, 03 Sep 2025 10:44:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756921478; x=1757526278; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=r+Xkjn7EoMjVJ0KrH0+pQsX7ZMdrzCeK0T1CzaZnWPQ=;
        b=piU33fmOUMAygJhL6eyaWHejomvxCSb4d1NqPTiGpKkGAX5KD7me7Fwcbb0RlKcCR9
         BVFDJg0O1KkpaqfdbYzPb7Hiq1dG474sZdM1rK3+Y+mGpnef9sOBHT5iEb/Iu1ot1P1e
         gfC2kTKu0nW3XsV61rFnTFXiN/n563ZO32rwCWn6AvhMxyht9uHMvSguMKbLT3+L2iXA
         pLgHFUg5kuf0lENCte1z0TODr+nUVEASFNpxtSg82mlfLWPnvR2ye/YrMhR7Q/EjOmJL
         qkG3yd10BcCxknxX2V/0JjFabXRAb6sJWR884B3w9K1dsrdXEikmYt485mn8eDeHPCD5
         rZhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756921478; x=1757526278;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=r+Xkjn7EoMjVJ0KrH0+pQsX7ZMdrzCeK0T1CzaZnWPQ=;
        b=rzOqnQ2NaPOEmXfoaL8zF2KMjQTnuKh/5z79lhxqLLIneyS3IwO9dF+jrUaCodaR/s
         mgsWOYRewnd5udPC1EW2OHRKDB5I++d/jMJaW29gpwYCpgNyyz4x9V2RV1GwPSYyhH6/
         uoF0Ut2X4yDBCMndYBV0BJq4HolIwei0wXz79oZNrih1CNqVAj8tw8gSFnsH4PBWIS0e
         EeO2kC4i8yH5ym4IwPpqihSNqrM9JWSyox5qgUJ26N50fe0DrFXsXZZzOEm/JfM5gI1n
         /o8o9vh4Ml0Ajp6BXYwx3Q2vIR4nzw/vl4ajFPYjRU/4IB2E3smXOsDx1CaI4WEMF3M5
         Aelg==
X-Forwarded-Encrypted: i=1; AJvYcCWghEv2q9rEwAE1acsOVOrs2zQPYM9/ISwYVGrGnaKYpKOtnA5ptX/zUyCgDf4r2++Zp4VyR2s=@lists.linux.dev
X-Gm-Message-State: AOJu0YxW24LYPkkzB8hOW1kQUzFu9w44OUNBDlY7QX7GPAPIYNtQgqOl
	dcfbdkSFFQAh5lfcgqlwUNZ7/nbHp3HxBdR/6rmCVZxUhPUpTNlKS2wB7QRUdZseRGOXoRmSHXL
	y8U+CjKC45Ob9lEEkfHVezklcvdDXDxvbHt+ckWs7
X-Gm-Gg: ASbGncshBLfxHHsrI5RDWvF2J7KU555YcGGYNr6NncDh4J5sSvIwmn794oDmqtgggr9
	hHoFqN8mFt1619QxwTW9ojpMl+W1BcyqBe63pWxu0w2zV0SHH0tlWd0ieQC3myehuzDGpF5sZTy
	wITiLwTKQkJw8k2byVIg22qajgcIr66m6HChll4ub0TupZLqlFiC8MJInSImhFU8kSGOBhZfjoG
	gBY03E0xPqTqJroH2pkco2SBU01oC9B5T6Iu31b19VirpxO4XYojd864Q==
X-Google-Smtp-Source: AGHT+IGifRj7Deprh31GNjvz4kEXtiRS/T4eRRhDMF3z2TKHGasmM7dL9LIa+sNx3yL0LdjgxyQXBLi8U2S17SkqZ18=
X-Received: by 2002:a05:6820:4401:b0:61e:701f:153c with SMTP id
 006d021491bc7-61e701f4925mr1885336eaf.7.1756921477944; Wed, 03 Sep 2025
 10:44:37 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68b86df6.050a0220.3db4df.01f9.GAE@google.com>
In-Reply-To: <68b86df6.050a0220.3db4df.01f9.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 3 Sep 2025 19:44:26 +0200
X-Gm-Features: Ac12FXwHY_5NC6tQmobswDRxYkr7Tw_38_fbfe2N9nyFENUTmU2mLTDj_jpAxKQ
Message-ID: <CANp29Y4Q868-rgeMVQxHT8fusV7kppzWy2R=Mx-BkPxMOcjjgg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: nft_ct: reject ambiguous conntrack
 expressions in inet tables
To: syzbot ci <syzbot+ci4b7f803e6db3e0a6@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Sep 3, 2025 at 6:34=E2=80=AFPM syzbot ci
<syzbot+ci4b7f803e6db3e0a6@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] netfilter: nft_ct: reject ambiguous conntrack expressions in inet ta=
bles
> https://lore.kernel.org/all/20250902215433.75568-1-nickgarlis@gmail.com
> * [PATCH v2] netfilter: nft_ct: reject ambiguous conntrack expressions in=
 inet tables
>
> and found the following issue:
> KASAN: slab-out-of-bounds Write in nft_meta_inner_init
>
> Full report is available here:
> https://ci.syzbot.org/series/d9b8905e-8e5d-42de-8b7a-56fc81572df6
>
> ***
>
> KASAN: slab-out-of-bounds Write in nft_meta_inner_init
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      864ecc4a6dade82d3f70eab43dad0e277aa6fc78
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/b1146649-3f67-48cb-975c-62829433c=
8c5/config
> C repro:   https://ci.syzbot.org/findings/d1f93a73-6b38-4a3b-9232-e80dea4=
7a810/c_repro
> syz repro: https://ci.syzbot.org/findings/d1f93a73-6b38-4a3b-9232-e80dea4=
7a810/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in nft_meta_inner_init+0x1a7/0x1d0 net/net=
filter/nft_meta.c:844
> Write of size 1 at addr ffff88810d9f5a40 by task syz.0.17/5997
>
> CPU: 1 UID: 0 PID: 5997 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  nft_meta_inner_init+0x1a7/0x1d0 net/netfilter/nft_meta.c:844
>  nft_inner_init+0x534/0x630 net/netfilter/nft_inner.c:388
>  nf_tables_newexpr net/netfilter/nf_tables_api.c:3513 [inline]
>  nf_tables_newrule+0x17b0/0x28a0 net/netfilter/nf_tables_api.c:4346
>  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:524 [inline]
>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:647 [inline]
>  nfnetlink_rcv+0x1132/0x2520 net/netfilter/nfnetlink.c:665
>  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:729
>  ____sys_sendmsg+0x505/0x830 net/socket.c:2614
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
>  __sys_sendmsg net/socket.c:2700 [inline]
>  __do_sys_sendmsg net/socket.c:2705 [inline]
>  __se_sys_sendmsg net/socket.c:2703 [inline]
>  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2703
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2d6c18ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff1c4d5e58 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f2d6c3c5fa0 RCX: 00007f2d6c18ebe9
> RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000003
> RBP: 00007f2d6c211e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f2d6c3c5fa0 R14: 00007f2d6c3c5fa0 R15: 0000000000000003
>  </TASK>
>
> Allocated by task 5997:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
>  poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:405
>  kasan_kmalloc include/linux/kasan.h:260 [inline]
>  __do_kmalloc_node mm/slub.c:4365 [inline]
>  __kmalloc_noprof+0x27a/0x4f0 mm/slub.c:4377
>  kmalloc_noprof include/linux/slab.h:909 [inline]
>  kzalloc_noprof include/linux/slab.h:1039 [inline]
>  nf_tables_newrule+0x1503/0x28a0 net/netfilter/nf_tables_api.c:4328
>  nfnetlink_rcv_batch net/netfilter/nfnetlink.c:524 [inline]
>  nfnetlink_rcv_skb_batch net/netfilter/nfnetlink.c:647 [inline]
>  nfnetlink_rcv+0x1132/0x2520 net/netfilter/nfnetlink.c:665
>  netlink_unicast_kernel net/netlink/af_netlink.c:1320 [inline]
>  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1346
>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1896
>  sock_sendmsg_nosec net/socket.c:714 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:729
>  ____sys_sendmsg+0x505/0x830 net/socket.c:2614
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
>  __sys_sendmsg net/socket.c:2700 [inline]
>  __do_sys_sendmsg net/socket.c:2705 [inline]
>  __se_sys_sendmsg net/socket.c:2703 [inline]
>  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2703
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88810d9f5a00
>  which belongs to the cache kmalloc-cg-64 of size 64
> The buggy address is located 0 bytes to the right of
>  allocated 64-byte region [ffff88810d9f5a00, ffff88810d9f5a40)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88810d9f=
5880 pfn:0x10d9f5
> memcg:ffff88810dfc9601
> flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000000 ffff88801a449c80 ffffea0000f4b500 0000000000000002
> raw: ffff88810d9f5880 000000008020001e 00000000f5000000 ffff88810dfc9601
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5917, tgid 5917 (syz=
-executor), ts 70404800919, free_ts 68893144552
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
>  prep_new_page mm/page_alloc.c:1859 [inline]
>  get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
>  alloc_slab_page mm/slub.c:2487 [inline]
>  allocate_slab+0x8a/0x370 mm/slub.c:2655
>  new_slab mm/slub.c:2709 [inline]
>  ___slab_alloc+0xbeb/0x1410 mm/slub.c:3891
>  __slab_alloc mm/slub.c:3981 [inline]
>  __slab_alloc_node mm/slub.c:4056 [inline]
>  slab_alloc_node mm/slub.c:4217 [inline]
>  __do_kmalloc_node mm/slub.c:4364 [inline]
>  __kvmalloc_node_noprof+0x429/0x5f0 mm/slub.c:5052
>  alloc_netdev_mqs+0xc7c/0x11b0 net/core/dev.c:11944
>  ip6_tnl_init_net+0x104/0x3b0 net/ipv6/ip6_tunnel.c:2292
>  ops_init+0x35c/0x5c0 net/core/net_namespace.c:136
>  setup_net+0x10c/0x320 net/core/net_namespace.c:438
>  copy_net_ns+0x31b/0x4d0 net/core/net_namespace.c:570
>  create_new_namespaces+0x3f3/0x720 kernel/nsproxy.c:110
>  unshare_nsproxy_namespaces+0x11c/0x170 kernel/nsproxy.c:218
>  ksys_unshare+0x4c8/0x8c0 kernel/fork.c:3127
>  __do_sys_unshare kernel/fork.c:3198 [inline]
>  __se_sys_unshare kernel/fork.c:3196 [inline]
>  __x64_sys_unshare+0x38/0x50 kernel/fork.c:3196
> page last free pid 976 tgid 976 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1395 [inline]
>  __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
>  kasan_depopulate_vmalloc_pte+0x74/0xa0 mm/kasan/shadow.c:472
>  apply_to_pte_range mm/memory.c:3015 [inline]
>  apply_to_pmd_range mm/memory.c:3059 [inline]
>  apply_to_pud_range mm/memory.c:3095 [inline]
>  apply_to_p4d_range mm/memory.c:3131 [inline]
>  __apply_to_page_range+0xb92/0x1380 mm/memory.c:3167
>  kasan_release_vmalloc+0xa2/0xd0 mm/kasan/shadow.c:593
>  kasan_release_vmalloc_node mm/vmalloc.c:2249 [inline]
>  purge_vmap_node+0x214/0x8f0 mm/vmalloc.c:2266
>  __purge_vmap_area_lazy+0x7a4/0xb40 mm/vmalloc.c:2356
>  drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2390
>  process_one_work kernel/workqueue.c:3236 [inline]
>  process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
>  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff88810d9f5900: 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc fc
>  ffff88810d9f5980: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
> >ffff88810d9f5a00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>                                            ^
>  ffff88810d9f5a80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff88810d9f5b00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
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
> The email will later be sent to:
> [fw@strlen.de netfilter-devel@vger.kernel.org nickgarlis@gmail.com pablo@=
netfilter.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/68b86df6.050a0220.3db4df.01f9.GAE%40google.com.
