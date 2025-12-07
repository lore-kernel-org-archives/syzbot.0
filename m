Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AC812AD37
	for <syzbot@lists.linux.dev>; Sun,  7 Dec 2025 23:52:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765151548; cv=none; b=jEBbXdLcOl7U7yUU2LpLemeY+aBBAkGF/iDUi6i+oE41cKeCZpEgIO/kS9W3b4cv5qug5zP8sDQGZ9eXvQE9QFP1YyUMBAglPbuZKW3QHftdB6mNdspGlBbNyfDRGvtLTvuxW6HQVEqvHOThvn0R/96Om8yApKUnRguCPj/QtSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765151548; c=relaxed/simple;
	bh=Sna4oa+TucY8N3M1J1QKIzPupjwqoE5QQcP1tTD/VXo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RRvYPuRofyNL7KsCpUiOimbmLk+vB7s98tbOesW5APTXfZi/1SDrRp/6SrnMebHdZQuxDDFBElCeBs3mzp1ZbQbLh9VyyRaGBaqcoXLBplTRO8yNY7xXxBf2BAkGqtYdBO8KDGU1kF5KM2u+csNiq8gsYzL4JHy5/rFy4el6Cvw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=u1y88cJY; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="u1y88cJY"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-657a6028fbbso1974171eaf.3
        for <syzbot@lists.linux.dev>; Sun, 07 Dec 2025 15:52:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765151545; x=1765756345; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4kRTZqDvPZLebCaum4TP0g7+Ejrx4/798TCDMnpifEs=;
        b=u1y88cJYXuZwofojw3AprsMo8Wn36f+cZjXPo+S6/D1vNgnqHktmf8WWfOPu2oFBvE
         NzWRiHe42UzgKsGkEnFG5kpCt8ZZEYf618jkgt1Sg2UWFEHEFB7wkQlv0mlsfOXle+EB
         OfDLPxJI6lzmWZQJXb0t7J4kdmefpvBB+xOkNkZVwQJltJY5KvKmtzV5u0ShpKTJq3+n
         HyjP4vl+zB5teBTE3J8MD2rtDw6giZr7ZD/MycWZNGhqX5H3fqkIv2IVsUpuVesCfrna
         Kmj//JAfbImT1Ji8/WajQ+lrEWemY+gy95pob1mEqJATkTbyyapJ2GQx5+j66O8bRT2v
         jK4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765151545; x=1765756345;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4kRTZqDvPZLebCaum4TP0g7+Ejrx4/798TCDMnpifEs=;
        b=cy6DGdkPOspJRu/T4grGP9OY2YOLICm/FFFSHXvTn31Nz78oDgeMfxncrLJjNpBfyo
         q4Gt58On1j0BPXPPt5VtUb3b7fdijTQsBsFc6DEzYz5BCk7BHis1Slt9RlwK7mbvdXRH
         BMgOTxOgroP/5UBh17lVZNQMtCor4u6aH19+IpVJnfjyezu2X4CC9kb/u18/r2wqfMbb
         5iAFB0sxaTZ55uzzjYE3CsyqEteyKqUTloapp8aoDu4JbY4hEWqu/tAvMjdQZPgIBftP
         L2uiZGeZZZa/XkXpBSuZFbXHUHl6zwHGcqatzqQDxgGcb/eyyUoP/8B6COwDKhsxu6pj
         aJ+Q==
X-Forwarded-Encrypted: i=1; AJvYcCV3Ql6WgWSArRLlnsXp0YcNxOKJo7eD537rJf/QQmBUIZNHv7Kcz054yiJMIHb0orUjCr0qyg8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxoA5YG26+VfeVQy6tuP3B0jfuZLFX8BRyTFpsyxYvHZbcx/Z46
	qGM5mTsNJjjNeGIeNGPzA58uihb9V67LMam2O9J0YpAIXUHO84s06bTOCfwYOSJNJbTjD/1Q3NG
	cpDypNzYG3Z19yGzekaXlfMddaeQu8AxGWLuiabpr
X-Gm-Gg: ASbGnctgbFGL/fEyeQxdbyc7UGYwu8m2q0+lX3UfhAYGn1626wymFOggLfnvm1Wqn7h
	lJaBNhvR6JrKt5yTM+vLOrq551jP+qV8aGC7yjMcYAA0GlIAtO6wMTu4NVDgxx2u9dMlLxPIyiS
	rfobuDL8Iai1bGWfnsd3LNsOInEpHEGjmnCEIcQSCwUgfOB5tXmo45ox98PLnFqL1g6kXUrLrUd
	TgfXBeGD8r/6NTQmojJfHabUpXXDwbkbN4RXVh3ltRWgDfMRppreigqh7IuapN+9KOyPyDeL/Zv
	XMrxoeQzP2MgkC9L1xqnOK6kfN4=
X-Google-Smtp-Source: AGHT+IHI2vftXNTR04y+DiIzjrYM1vOmB23ze/hCVavJA61UC1X+D28eypTXFhvDX0YKQQdwKmZJ0Gp8Er3Qg8v7dlA=
X-Received: by 2002:a05:6820:a04:b0:659:9a49:8eca with SMTP id
 006d021491bc7-6599a97b1aamr2517078eaf.78.1765151544666; Sun, 07 Dec 2025
 15:52:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6935dee1.a70a0220.38f243.006b.GAE@google.com>
In-Reply-To: <6935dee1.a70a0220.38f243.006b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 8 Dec 2025 08:52:12 +0900
X-Gm-Features: AQt7F2r0s24j7PJSBoOVBt3IQmK0MhsDQpBxLk41129ZlSOFvMztPui8JHrTJag
Message-ID: <CANp29Y7mQdd772f7_5PiernVK0UXTaWS+k7JisQovup_chm8YQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Add IP6IP6 flowtable SW acceleration
To: syzbot ci <syzbot+ciaa0737d403f374b5@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Dec 8, 2025 at 5:09=E2=80=AFAM syzbot ci
<syzbot+ciaa0737d403f374b5@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Add IP6IP6 flowtable SW acceleration
> https://lore.kernel.org/all/20251207-b4-flowtable-offload-ip6ip6-v1-0-18e=
3ab7f748c@kernel.org
> * [PATCH nf-next 1/5] netfilter: Introduce tunnel metadata info in nf_flo=
wtable_ctx struct
> * [PATCH nf-next 2/5] netfilter: Modify nf_flow_skb_encap_protocol() to r=
eturn int intead of bool
> * [PATCH nf-next 3/5] netfilter: flowtable: Add IP6IP6 rx sw acceleration
> * [PATCH nf-next 4/5] netfilter: flowtable: Add IP6IP6 tx sw acceleration
> * [PATCH nf-next 5/5] selftests: netfilter: nft_flowtable.sh: Add IP6IP6 =
flowtable selftest
>
> and found the following issues:
> * KASAN: slab-use-after-free Read in nf_flow_skb_encap_protocol
> * general protection fault in ipv6_frag_rcv
> * general protection fault in nf_flow_offload_ipv6_hook
>
> Full report is available here:
> https://ci.syzbot.org/series/24632ec9-06ab-4e09-8015-19822d83c6a9
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
> config:    https://ci.syzbot.org/builds/833219cc-e7e2-437d-b31c-1eb3666c1=
e93/config
> C repro:   https://ci.syzbot.org/findings/afcab565-801f-4cde-a1c5-b1d3275=
37871/c_repro
> syz repro: https://ci.syzbot.org/findings/afcab565-801f-4cde-a1c5-b1d3275=
37871/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in nf_flow_ip6_tunnel_proto net/netfilter=
/nf_flow_table_ip.c:388 [inline]
> BUG: KASAN: slab-use-after-free in nf_flow_skb_encap_protocol+0x13a2/0x15=
40 net/netfilter/nf_flow_table_ip.c:438
> Read of size 2 at addr ffff888175605eb6 by task syz.1.20/6010
>
> CPU: 1 UID: 0 PID: 6010 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  nf_flow_ip6_tunnel_proto net/netfilter/nf_flow_table_ip.c:388 [inline]
>  nf_flow_skb_encap_protocol+0x13a2/0x1540 net/netfilter/nf_flow_table_ip.=
c:438
>  nf_flow_offload_ipv6_lookup net/netfilter/nf_flow_table_ip.c:1074 [inlin=
e]
>  nf_flow_offload_ipv6_hook+0x13c/0x32a0 net/netfilter/nf_flow_table_ip.c:=
1102
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
> RIP: 0033:0x7f53b9d8f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f53babe6038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007f53b9fe6090 RCX: 00007f53b9d8f7c9
> RDX: 000000000000fdef RSI: 0000200000000340 RDI: 0000000000000003
> RBP: 00007f53b9df297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f53b9fe6128 R14: 00007f53b9fe6090 R15: 00007ffc1b120a08
>  </TASK>
>
> Allocated by task 6010:
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
> Freed by task 6010:
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
>  kfree_skb_reason include/linux/skbuff.h:1322 [inline]
>  kfree_skb include/linux/skbuff.h:1331 [inline]
>  dst_discard_out+0x1c/0x30 net/core/dst.c:32
>  nf_flow_ip6_tunnel_proto net/netfilter/nf_flow_table_ip.c:383 [inline]
>  nf_flow_skb_encap_protocol+0x9c2/0x1540 net/netfilter/nf_flow_table_ip.c=
:438
>  nf_flow_offload_ipv6_lookup net/netfilter/nf_flow_table_ip.c:1074 [inlin=
e]
>  nf_flow_offload_ipv6_hook+0x13c/0x32a0 net/netfilter/nf_flow_table_ip.c:=
1102
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
> The buggy address belongs to the object at ffff888175605e00
>  which belongs to the cache skbuff_head_cache of size 240
> The buggy address is located 182 bytes inside of
>  freed 240-byte region [ffff888175605e00, ffff888175605ef0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1756=
04
> head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x57ff00000000040(head|node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000040 ffff8881036c4a00 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000080150015 00000000f5000000 0000000000000000
> head: 057ff00000000040 ffff8881036c4a00 dead000000000122 0000000000000000
> head: 0000000000000000 0000000080150015 00000000f5000000 0000000000000000
> head: 057ff00000000001 ffffea0005d58101 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 5922, tgid 5922 (syz-executor), ts 68256102142, free_ts 61484167308
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
>  nlmsg_new include/net/netlink.h:1055 [inline]
>  inet_ifmcaddr_notify+0x7e/0x150 net/ipv4/igmp.c:1481
>  ____ip_mc_inc_group+0x9b8/0xde0 net/ipv4/igmp.c:1564
>  __ip_mc_inc_group net/ipv4/igmp.c:1573 [inline]
>  ip_mc_inc_group net/ipv4/igmp.c:1579 [inline]
>  ip_mc_up+0x125/0x300 net/ipv4/igmp.c:1880
>  inetdev_event+0xfb3/0x15b0 net/ipv4/devinet.c:1630
>  notifier_call_chain+0x1b6/0x3e0 kernel/notifier.c:85
>  call_netdevice_notifiers_extack net/core/dev.c:2268 [inline]
>  call_netdevice_notifiers net/core/dev.c:2282 [inline]
>  __dev_notify_flags+0x18d/0x2e0 net/core/dev.c:-1
>  netif_change_flags+0xe8/0x1a0 net/core/dev.c:9802
> page last free pid 5811 tgid 5811 stack trace:
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
>  ptlock_alloc+0x20/0x70 mm/memory.c:7302
>  ptlock_init include/linux/mm.h:3059 [inline]
>  pagetable_pte_ctor include/linux/mm.h:3113 [inline]
>  __pte_alloc_one_noprof include/asm-generic/pgalloc.h:78 [inline]
>  pte_alloc_one+0x7a/0x310 arch/x86/mm/pgtable.c:18
>  __do_fault+0xd1/0x390 mm/memory.c:5276
>  do_shared_fault mm/memory.c:5780 [inline]
>  do_fault mm/memory.c:5854 [inline]
>  do_pte_missing mm/memory.c:4362 [inline]
>  handle_pte_fault mm/memory.c:6195 [inline]
>  __handle_mm_fault+0x1847/0x5400 mm/memory.c:6336
>  handle_mm_fault+0x40a/0x8e0 mm/memory.c:6505
>  do_user_addr_fault+0xa7c/0x1380 arch/x86/mm/fault.c:1336
>  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>  exc_page_fault+0x82/0x100 arch/x86/mm/fault.c:1532
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
>
> Memory state around the buggy address:
>  ffff888175605d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888175605e00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff888175605e80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
>                                      ^
>  ffff888175605f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888175605f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> general protection fault in ipv6_frag_rcv
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      ff736a286116d462a4067ba258fa351bc0b4ed80
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/833219cc-e7e2-437d-b31c-1eb3666c1=
e93/config
> C repro:   https://ci.syzbot.org/findings/bac8a298-33d8-4b3a-9f63-a0a2373=
aaab2/c_repro
> syz repro: https://ci.syzbot.org/findings/bac8a298-33d8-4b3a-9f63-a0a2373=
aaab2/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 5982 Comm: syz.1.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:dst_dev include/net/dst.h:571 [inline]
> RIP: 0010:skb_dst_dev include/net/dst.h:586 [inline]
> RIP: 0010:skb_dst_dev_net include/net/dst.h:596 [inline]
> RIP: 0010:ipv6_frag_rcv+0x19c/0x2a20 net/ipv6/reassembly.c:328
> Code: 5c 24 08 4c 89 74 24 10 48 8b 44 24 60 42 80 3c 28 00 74 08 48 89 d=
f e8 42 15 21 f8 48 8b 03 49 89 c6 49 83 e6 fe 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 f7 e8 25 15 21 f8 bb 08 01 00 00 49 03
> RSP: 0018:ffffc90003776d20 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88816d87a1d8 RCX: ffff88816bf65700
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90003776f08 R08: ffffea0006d29400 R09: 0000000b00007ff5
> R10: ffffea0006d29400 R11: ffffffff8a04b090 R12: 0000000000000040
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffff888173607480
> FS:  00007fa70abdd6c0(0000) GS:ffff8882a9f2e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000010000 CR3: 0000000112fa8000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  nf_flow_ip6_tunnel_proto net/netfilter/nf_flow_table_ip.c:383 [inline]
>  nf_flow_skb_encap_protocol+0x9c2/0x1540 net/netfilter/nf_flow_table_ip.c=
:438
>  nf_flow_offload_ipv6_lookup net/netfilter/nf_flow_table_ip.c:1074 [inlin=
e]
>  nf_flow_offload_ipv6_hook+0x13c/0x32a0 net/netfilter/nf_flow_table_ip.c:=
1102
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
> RIP: 0033:0x7fa70b58f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fa70abdd038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007fa70b7e6090 RCX: 00007fa70b58f7c9
> RDX: 000000000000fdef RSI: 0000200000000340 RDI: 0000000000000003
> RBP: 00007fa70b5f297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fa70b7e6128 R14: 00007fa70b7e6090 R15: 00007ffcd9538b88
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:dst_dev include/net/dst.h:571 [inline]
> RIP: 0010:skb_dst_dev include/net/dst.h:586 [inline]
> RIP: 0010:skb_dst_dev_net include/net/dst.h:596 [inline]
> RIP: 0010:ipv6_frag_rcv+0x19c/0x2a20 net/ipv6/reassembly.c:328
> Code: 5c 24 08 4c 89 74 24 10 48 8b 44 24 60 42 80 3c 28 00 74 08 48 89 d=
f e8 42 15 21 f8 48 8b 03 49 89 c6 49 83 e6 fe 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 f7 e8 25 15 21 f8 bb 08 01 00 00 49 03
> RSP: 0018:ffffc90003776d20 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88816d87a1d8 RCX: ffff88816bf65700
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90003776f08 R08: ffffea0006d29400 R09: 0000000b00007ff5
> R10: ffffea0006d29400 R11: ffffffff8a04b090 R12: 0000000000000040
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffff888173607480
> FS:  00007fa70abdd6c0(0000) GS:ffff8882a9f2e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000010000 CR3: 0000000112fa8000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   5c                      pop    %rsp
>    1:   24 08                   and    $0x8,%al
>    3:   4c 89 74 24 10          mov    %r14,0x10(%rsp)
>    8:   48 8b 44 24 60          mov    0x60(%rsp),%rax
>    d:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1)
>   12:   74 08                   je     0x1c
>   14:   48 89 df                mov    %rbx,%rdi
>   17:   e8 42 15 21 f8          call   0xf821155e
>   1c:   48 8b 03                mov    (%rbx),%rax
>   1f:   49 89 c6                mov    %rax,%r14
>   22:   49 83 e6 fe             and    $0xfffffffffffffffe,%r14
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 f7                mov    %r14,%rdi
>   34:   e8 25 15 21 f8          call   0xf821155e
>   39:   bb 08 01 00 00          mov    $0x108,%ebx
>   3e:   49                      rex.WB
>   3f:   03                      .byte 0x3
>
>
> ***
>
> general protection fault in nf_flow_offload_ipv6_hook
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      ff736a286116d462a4067ba258fa351bc0b4ed80
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/833219cc-e7e2-437d-b31c-1eb3666c1=
e93/config
> C repro:   https://ci.syzbot.org/findings/bee4a66a-8f79-4936-9f6e-7f9e229=
693c9/c_repro
> syz repro: https://ci.syzbot.org/findings/bee4a66a-8f79-4936-9f6e-7f9e229=
693c9/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000000c: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000060-0x0000000000000067]
> CPU: 1 UID: 0 PID: 5978 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:nf_flow_offload_ipv6_forward net/netfilter/nf_flow_table_ip.c:1=
027 [inline]
> RIP: 0010:nf_flow_offload_ipv6_hook+0x2f3/0x32a0 net/netfilter/nf_flow_ta=
ble_ip.c:1106
> Code: 85 c6 03 00 00 e8 6d f0 31 f8 41 bc 14 00 00 00 e9 af 02 00 00 48 8=
d 4b 60 48 89 4c 24 18 48 c1 e9 03 48 89 8c 24 90 00 00 00 <42> 0f b6 04 21=
 84 c0 0f 85 de 23 00 00 44 0f b7 73 60 41 83 e6 03
> RSP: 0018:ffffc900031d6fe0 EFLAGS: 00010206
> RAX: ffffffff898e1101 RBX: 0000000000000002 RCX: 000000000000000c
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
> RBP: ffffc900031d73e0 R08: ffffffff8f7d1e77 R09: 1ffffffff1efa3ce
> R10: dffffc0000000000 R11: fffffbfff1efa3cf R12: dffffc0000000000
> R13: 1ffff9200063ae1c R14: ffff88816cfc5680 R15: ffffc900031d72e0
> FS:  00007fd7653a06c0(0000) GS:ffff8882a9f2e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000010000 CR3: 000000011342a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
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
> RIP: 0033:0x7fd76458f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fd7653a0038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007fd7647e6090 RCX: 00007fd76458f7c9
> RDX: 000000000000fdef RSI: 0000200000000380 RDI: 0000000000000003
> RBP: 00007fd7645f297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd7647e6128 R14: 00007fd7647e6090 R15: 00007ffde1f0b2b8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:nf_flow_offload_ipv6_forward net/netfilter/nf_flow_table_ip.c:1=
027 [inline]
> RIP: 0010:nf_flow_offload_ipv6_hook+0x2f3/0x32a0 net/netfilter/nf_flow_ta=
ble_ip.c:1106
> Code: 85 c6 03 00 00 e8 6d f0 31 f8 41 bc 14 00 00 00 e9 af 02 00 00 48 8=
d 4b 60 48 89 4c 24 18 48 c1 e9 03 48 89 8c 24 90 00 00 00 <42> 0f b6 04 21=
 84 c0 0f 85 de 23 00 00 44 0f b7 73 60 41 83 e6 03
> RSP: 0018:ffffc900031d6fe0 EFLAGS: 00010206
> RAX: ffffffff898e1101 RBX: 0000000000000002 RCX: 000000000000000c
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: 0000000000000000
> RBP: ffffc900031d73e0 R08: ffffffff8f7d1e77 R09: 1ffffffff1efa3ce
> R10: dffffc0000000000 R11: fffffbfff1efa3cf R12: dffffc0000000000
> R13: 1ffff9200063ae1c R14: ffff88816cfc5680 R15: ffffc900031d72e0
> FS:  00007fd7653a06c0(0000) GS:ffff8882a9f2e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000010000 CR3: 000000011342a000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   85 c6                   test   %eax,%esi
>    2:   03 00                   add    (%rax),%eax
>    4:   00 e8                   add    %ch,%al
>    6:   6d                      insl   (%dx),%es:(%rdi)
>    7:   f0 31 f8                lock xor %edi,%eax
>    a:   41 bc 14 00 00 00       mov    $0x14,%r12d
>   10:   e9 af 02 00 00          jmp    0x2c4
>   15:   48 8d 4b 60             lea    0x60(%rbx),%rcx
>   19:   48 89 4c 24 18          mov    %rcx,0x18(%rsp)
>   1e:   48 c1 e9 03             shr    $0x3,%rcx
>   22:   48 89 8c 24 90 00 00    mov    %rcx,0x90(%rsp)
>   29:   00
> * 2a:   42 0f b6 04 21          movzbl (%rcx,%r12,1),%eax <-- trapping in=
struction
>   2f:   84 c0                   test   %al,%al
>   31:   0f 85 de 23 00 00       jne    0x2415
>   37:   44 0f b7 73 60          movzwl 0x60(%rbx),%r14d
>   3c:   41 83 e6 03             and    $0x3,%r14d
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
-upstream-moderation/6935dee1.a70a0220.38f243.006b.GAE%40google.com.
