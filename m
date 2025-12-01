Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBFE83321CE
	for <syzbot@lists.linux.dev>; Mon,  1 Dec 2025 17:52:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764611556; cv=none; b=Xsbv3MSt6czAxp0mCq5z/KlW72lTpC4pFalHzzJHM6Rnl4x1ufM+LKG7JqyGlVk7nuYF17qR47k6XpNS9MXWGexc8YtMIDiErNyioIc54epiaBu9NsNHEfSjtge8ndaUWVtz4urCE3q72tl2PgnjxFvztOr4f2FLns45jXmEcbo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764611556; c=relaxed/simple;
	bh=dU8IxXc8QLiRInXKlllqQgoYsKxgv4kW6j+/dPhHNog=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dZKsVGfjEp/gFxQoBGRVAuCmzToJrCWrPY3Yjmy5xeJEocxmKjZBQfeiaCwmTwgPfW+/G0u1CBDR2JgHsq3qt9+YtXKweFXHJvq6vZjB8hXvoFahcusMGvH4XnCH+tPBiIfypvSlPudXvS+O4oiRtj6TpwEOMAU7epemSGVRms8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pxocJA2d; arc=none smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pxocJA2d"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-657509d761dso2276321eaf.0
        for <syzbot@lists.linux.dev>; Mon, 01 Dec 2025 09:52:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764611554; x=1765216354; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=PgX/rm5bJwsmpZLqyKs1r5SPH8FXv3Am5p1sQwui/Bc=;
        b=pxocJA2d1FLbJNpDV66mLKLZafp2tieAOLIXebsuuiONZkPajxffiN8thc61x9bLfg
         lO3V4s3XsmxTj05qPUjTSEvC0E5E6jl+KCNohWmbIwOAQYM2IE4YrxS/UJcUluwlLq66
         BfK29uX15Y48YvZjWHawz9Ho2iwUYFDlItJMdocThpyBVVVhSLhLjTSOhp7RUL7xE1AC
         gDeJXoz9pRMQ0hJNlOPIJm/YMhPtK3kDYdsxU9WxB6niT64Srdk3KDFwuRn9+iWYgFc4
         h9U+dAI8aUVJDdjVN4v7iOx95ipjJ/s3XkuisL5qrBKe/A4DY3nberlHUWuNt5Qut+N2
         7ucA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764611554; x=1765216354;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=PgX/rm5bJwsmpZLqyKs1r5SPH8FXv3Am5p1sQwui/Bc=;
        b=Prw2USSh3rmpKV4RZWd5JrtmFbOAeFniJgGFmND4YCfocyiUQRtAvJWXJZkBHGOFcK
         Ey6PSd/5tkJzqpZSoiIu22S9u9dAm2QLkZWLwOaRKoPeiCt3a1FfkaD7oFBUclXyBG5U
         w8KQjIQaNsbQvRVzsjaQ0+4yl8AYgE+8UpOSToS0RN8TCRr18hlJV/y5Qm3tMPTtjbx6
         DhjYD6KCSqkBqw37O0ElMjxjOp7BOb9Gg11lqbU51L00CMZZFTsQ9YIA72nKyNggY1+8
         LqyZhOukmzI102VyX50zt+DukpxmZo6s7roRy0n3lP6JiBct9si7RP33YWpaE12eVeFk
         z0VQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+vnoJ00XqPlHbAicJf9+ZZ9JSrRwjmN4/mec5HD+kuoWICG/TF36kW0vlJJL16MxHw4FXjgA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyy+1P2Ug/c212axaSNzAC49ewX4SzVPjaqd2zY4luOJ1KRRPwa
	Cc8eFwwOyiYBO0C0g1SbkA6nP54E6wUkqTVbS/Uzr7dEtdpiK5s9Q1vUbY1H6BPzexb9QTd35jO
	G1HnB6RLm/njnHetqs7Gt2oIE1QrtAMwB73GN2wNOSXkySVwITUU2Ib9R
X-Gm-Gg: ASbGnctLyoBb0nz0OjN+r1475YXwCxEwLWvuAkgQRf4kYviOddKjTjPcf8ACkfSj4Mi
	zobsxnoY+GzLyq6YYE5EkXI+H5W2GnYnN+Y5I8BHN6Rs/ZlCOmaUBLYkbMn98FIE8PYg5KFdvsW
	ziMvQyqGsQGwmCqbhw12wPAfwFpHU37yHL6KxlQx3EKf8PdfhkQwOUpe7YItDYh0samcUv3LtZG
	klIDC2JQJQOmdXPKnH+9PAtvTh1BntshtQkDm1DqQQ9qGeyd53eBDcnSWxjMoLz0RavRTAG8ljX
	QZxCncrSn19k2IEchNIbfvI350H2DwJg/6yOmTH9oJq/fZNUDHIsdFrZCBxx
X-Google-Smtp-Source: AGHT+IFSnblX253PX53Z5rakUdg6XKxtDw+JPhaCZUnBrCqp/n1py/un/J1LhNoqs/qM+2EWJbfL8SkqomHqnbJ7Ceo=
X-Received: by 2002:a05:6820:2d85:20b0:657:5839:fce2 with SMTP id
 006d021491bc7-6579253fd7bmr14047899eaf.6.1764611552926; Mon, 01 Dec 2025
 09:52:32 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <692dd49a.a70a0220.2ea503.00b7.GAE@google.com>
In-Reply-To: <692dd49a.a70a0220.2ea503.00b7.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 1 Dec 2025 18:52:20 +0100
X-Gm-Features: AWmQ_bnbz0CDVbyNllTikAIHH_NqBS0vpfmwotiXNBaClm18Ngtj_17V9A9AP6M
Message-ID: <CANp29Y5xX8okg+RQxM_UjKHbuGugim+AjEP7tE1e0BpqeGJ7Sg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Add IP6IP6 flowtable SW acceleration
To: syzbot ci <syzbot+cibae5ef332236f6f6@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Dec 1, 2025 at 6:47=E2=80=AFPM syzbot ci
<syzbot+cibae5ef332236f6f6@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Add IP6IP6 flowtable SW acceleration
> https://lore.kernel.org/all/20251201-flowtable-offload-ip6ip6-v1-0-1dabf5=
34c074@kernel.org
> * [PATCH RFC nf-next 1/4] netfilter: Introduce tunnel metadata info in nf=
_flowtable_ctx struct
> * [PATCH RFC nf-next 2/4] netfilter: flowtable: Add IP6IP6 rx sw accelera=
tion
> * [PATCH RFC nf-next 3/4] netfilter: flowtable: Add IP6IP6 tx sw accelera=
tion
> * [PATCH RFC nf-next 4/4] selftests: netfilter: nft_flowtable.sh: Add IP6=
IP6 flowtable selftest
>
> and found the following issue:
> KASAN: slab-use-after-free Read in nf_flow_skb_encap_protocol
>
> Full report is available here:
> https://ci.syzbot.org/series/df395c22-6768-4a9f-9a96-56b5307acbc6
>
> ***
>
> KASAN: slab-use-after-free Read in nf_flow_skb_encap_protocol
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      ff736a286116d462a4067ba258fa351bc0b4ed80
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/018f7259-7abc-4b77-b40c-e8e520e1e=
793/config
> C repro:   https://ci.syzbot.org/findings/5cb5bc43-721b-4a9e-a093-4d52aab=
5ba9f/c_repro
> syz repro: https://ci.syzbot.org/findings/5cb5bc43-721b-4a9e-a093-4d52aab=
5ba9f/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in nf_flow_ip6_tunnel_proto net/netfilter=
/nf_flow_table_ip.c:383 [inline]
> BUG: KASAN: slab-use-after-free in nf_flow_skb_encap_protocol+0x1336/0x14=
e0 net/netfilter/nf_flow_table_ip.c:433
> Read of size 2 at addr ffff888115de92b6 by task syz.0.20/5970
>
> CPU: 0 UID: 0 PID: 5970 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  nf_flow_ip6_tunnel_proto net/netfilter/nf_flow_table_ip.c:383 [inline]
>  nf_flow_skb_encap_protocol+0x1336/0x14e0 net/netfilter/nf_flow_table_ip.=
c:433
>  nf_flow_offload_ipv6_lookup net/netfilter/nf_flow_table_ip.c:1065 [inlin=
e]
>  nf_flow_offload_ipv6_hook+0x131/0x3380 net/netfilter/nf_flow_table_ip.c:=
1092
>  nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
>  nf_hook_slow+0xc5/0x220 net/netfilter/core.c:623
>  nf_hook_ingress include/linux/netfilter_netdev.h:34 [inline]
>  nf_ingress net/core/dev.c:5900 [inline]
>  __netif_receive_skb_core+0x241c/0x2f90 net/core/dev.c:5996
>  __netif_receive_skb_one_core net/core/dev.c:6135 [inline]
>  __netif_receive_skb+0x72/0x380 net/core/dev.c:6250
>  netif_receive_skb_internal net/core/dev.c:6336 [inline]
>  netif_receive_skb+0x1cb/0x790 net/core/dev.c:6395
>  tun_rx_batched+0x1b9/0x730 drivers/net/tun.c:1485
>  tun_get_user+0x2b65/0x3e90 drivers/net/tun.c:1953
>  tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1999
>  new_sync_write fs/read_write.c:593 [inline]
>  vfs_write+0x5c9/0xb30 fs/read_write.c:686
>  ksys_write+0x145/0x250 fs/read_write.c:738
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8b24f8f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f8b25e26038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007f8b251e6090 RCX: 00007f8b24f8f7c9
> RDX: 000000000000fdef RSI: 0000200000000440 RDI: 0000000000000003
> RBP: 00007f8b24ff297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f8b251e6128 R14: 00007f8b251e6090 R15: 00007ffe014b8a38
>  </TASK>
>
> Allocated by task 5970:
>  kasan_save_stack mm/kasan/common.c:56 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
>  unpoison_slab_object mm/kasan/common.c:342 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:368
>  kasan_slab_alloc include/linux/kasan.h:252 [inline]
>  slab_post_alloc_hook mm/slub.c:4978 [inline]
>  slab_alloc_node mm/slub.c:5288 [inline]
>  kmem_cache_alloc_node_noprof+0x433/0x710 mm/slub.c:5340
>  __alloc_skb+0x255/0x430 net/core/skbuff.c:679
>  alloc_skb include/linux/skbuff.h:1383 [inline]
>  alloc_skb_with_frags+0xca/0x890 net/core/skbuff.c:6712
>  sock_alloc_send_pskb+0x84d/0x980 net/core/sock.c:2995
>  tun_alloc_skb drivers/net/tun.c:1461 [inline]
>  tun_get_user+0xa43/0x3e90 drivers/net/tun.c:1794
>  tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1999
>  new_sync_write fs/read_write.c:593 [inline]
>  vfs_write+0x5c9/0xb30 fs/read_write.c:686
>  ksys_write+0x145/0x250 fs/read_write.c:738
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 5970:
>  kasan_save_stack mm/kasan/common.c:56 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
>  __kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:587
>  kasan_save_free_info mm/kasan/kasan.h:406 [inline]
>  poison_slab_object mm/kasan/common.c:252 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:284
>  kasan_slab_free include/linux/kasan.h:234 [inline]
>  slab_free_hook mm/slub.c:2543 [inline]
>  slab_free mm/slub.c:6642 [inline]
>  kmem_cache_free+0x19b/0x690 mm/slub.c:6752
>  icmpv6_param_prob include/linux/icmpv6.h:95 [inline]
>  ipv6_rthdr_rcv+0x150e/0x2020 net/ipv6/exthdrs.c:828
>  nf_flow_ip6_tunnel_proto net/netfilter/nf_flow_table_ip.c:381 [inline]
>  nf_flow_skb_encap_protocol+0x9b5/0x14e0 net/netfilter/nf_flow_table_ip.c=
:433
>  nf_flow_offload_ipv6_lookup net/netfilter/nf_flow_table_ip.c:1065 [inlin=
e]
>  nf_flow_offload_ipv6_hook+0x131/0x3380 net/netfilter/nf_flow_table_ip.c:=
1092
>  nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
>  nf_hook_slow+0xc5/0x220 net/netfilter/core.c:623
>  nf_hook_ingress include/linux/netfilter_netdev.h:34 [inline]
>  nf_ingress net/core/dev.c:5900 [inline]
>  __netif_receive_skb_core+0x241c/0x2f90 net/core/dev.c:5996
>  __netif_receive_skb_one_core net/core/dev.c:6135 [inline]
>  __netif_receive_skb+0x72/0x380 net/core/dev.c:6250
>  netif_receive_skb_internal net/core/dev.c:6336 [inline]
>  netif_receive_skb+0x1cb/0x790 net/core/dev.c:6395
>  tun_rx_batched+0x1b9/0x730 drivers/net/tun.c:1485
>  tun_get_user+0x2b65/0x3e90 drivers/net/tun.c:1953
>  tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1999
>  new_sync_write fs/read_write.c:593 [inline]
>  vfs_write+0x5c9/0xb30 fs/read_write.c:686
>  ksys_write+0x145/0x250 fs/read_write.c:738
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888115de9200
>  which belongs to the cache skbuff_head_cache of size 240
> The buggy address is located 182 bytes inside of
>  freed 240-byte region [ffff888115de9200, ffff888115de92f0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x115d=
e8
> head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000040 ffff8881036ba8c0 ffffea0004280a80 dead000000000002
> raw: 0000000000000000 0000000080150015 00000000f5000000 0000000000000000
> head: 017ff00000000040 ffff8881036ba8c0 ffffea0004280a80 dead000000000002
> head: 0000000000000000 0000000080150015 00000000f5000000 0000000000000000
> head: 017ff00000000001 ffffea0004577a01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 5555, tgid 5555 (dhcpcd), ts 36767395595, free_ts 35122573404
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x234/0x290 mm/page_alloc.c:1845
>  prep_new_page mm/page_alloc.c:1853 [inline]
>  get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3879
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5178
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
>  alloc_slab_page mm/slub.c:3059 [inline]
>  allocate_slab+0x96/0x350 mm/slub.c:3232
>  new_slab mm/slub.c:3286 [inline]
>  ___slab_alloc+0xf56/0x1990 mm/slub.c:4655
>  __slab_alloc+0x65/0x100 mm/slub.c:4778
>  __slab_alloc_node mm/slub.c:4854 [inline]
>  slab_alloc_node mm/slub.c:5276 [inline]
>  kmem_cache_alloc_node_noprof+0x4c5/0x710 mm/slub.c:5340
>  __alloc_skb+0x255/0x430 net/core/skbuff.c:679
>  alloc_skb include/linux/skbuff.h:1383 [inline]
>  alloc_skb_with_frags+0xca/0x890 net/core/skbuff.c:6712
>  sock_alloc_send_pskb+0x84d/0x980 net/core/sock.c:2995
>  unix_dgram_sendmsg+0x454/0x1840 net/unix/af_unix.c:2139
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:742
>  sock_write_iter+0x279/0x360 net/socket.c:1195
>  do_iter_readv_writev+0x623/0x8c0 fs/read_write.c:-1
>  vfs_writev+0x31a/0x960 fs/read_write.c:1057
> page last free pid 5262 tgid 5262 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1394 [inline]
>  __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2901
>  __slab_free+0x2e7/0x390 mm/slub.c:5970
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x97/0x140 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:352
>  kasan_slab_alloc include/linux/kasan.h:252 [inline]
>  slab_post_alloc_hook mm/slub.c:4978 [inline]
>  slab_alloc_node mm/slub.c:5288 [inline]
>  kmem_cache_alloc_noprof+0x367/0x6e0 mm/slub.c:5295
>  getname_flags+0xb8/0x540 fs/namei.c:146
>  getname include/linux/fs.h:2924 [inline]
>  do_sys_openat2+0xbc/0x1c0 fs/open.c:1431
>  do_sys_open fs/open.c:1452 [inline]
>  __do_sys_openat fs/open.c:1468 [inline]
>  __se_sys_openat fs/open.c:1463 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1463
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff888115de9180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888115de9200: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff888115de9280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
>                                      ^
>  ffff888115de9300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888115de9380: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
> [coreteam@netfilter.org davem@davemloft.net dsahern@kernel.org edumazet@g=
oogle.com fw@strlen.de horms@kernel.org kadlec@netfilter.org kuba@kernel.or=
g linux-kselftest@vger.kernel.org lorenzo@kernel.org netdev@vger.kernel.org=
 netfilter-devel@vger.kernel.org pabeni@redhat.com pablo@netfilter.org phil=
@nwl.cc shuah@kernel.org]
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
-upstream-moderation/692dd49a.a70a0220.2ea503.00b7.GAE%40google.com.
