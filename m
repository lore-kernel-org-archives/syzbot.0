Received: from mail-oa1-f44.google.com (mail-oa1-f44.google.com [209.85.160.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04D562472A6
	for <syzbot@lists.linux.dev>; Wed,  8 Apr 2026 12:34:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775651658; cv=pass; b=DNz9zU6Yvgh/EDTYnraYGimAop3AOP/C06PKvf4EjS5AHIFqDg1DZdQhfe7Qi07bwV4kot3pDwTQ77B7+JZ4TI6telybsOv3ckg9SeJHkVeAwGuERKeL7InJ7fy2xoNBQSahwOzCCeHA0BIsNFW8j08NhjMz4S4cXqNctzsHeNE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775651658; c=relaxed/simple;
	bh=IrBcQKqB9usdmG8mYTNKooFHM4bwLUa4t1LlxIw2xXY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EZUKvy7Q2EknAJKhw7WsuNQruW/26B61+YWXhAlXCJN6cD/FbQ4r8Rj+luxV6xR9+gqnTy2g5VAIp83jKWW4HdJQ96n2rySI2SV+b65/nUuUGNp9XtOyNUqatMbzunqh0CGsUp+eYgBxAMOEYUsEn+R4PymW1lGijjR+DRY4kck=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Iidlg6DB; arc=pass smtp.client-ip=209.85.160.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Iidlg6DB"
Received: by mail-oa1-f44.google.com with SMTP id 586e51a60fabf-415e568a7ecso2135796fac.0
        for <syzbot@lists.linux.dev>; Wed, 08 Apr 2026 05:34:15 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775651655; cv=none;
        d=google.com; s=arc-20240605;
        b=NrLd7MD5N99Jeh12UrxIZuiWCkKEkDgf5uaq1HPibeOSN+5G7QoPfbBHDxdV1D1z+j
         SbKmwCKxyqlxZswpCN1KhlyamPqYiBoXn7ZkH1EgsN1tm/Z1J6oieqlfWozhYWICb/9n
         bCZMAzJRDNWYmxreELGcWVqsJvTOUZHkhCQJtZdhG/yI5m25bRxKN11tEskfyYzKX3ae
         I4yylEDkYYCDq3qZUjc6id2KEntzDKWFaYAbCsVO7lL5/qblO4M2BO9TVH94yDxVO2jx
         SYzISXbUEhQ8YI2ePZy9rZH2QfoCIWE5frs/c7EWpwS7eVYGGEGwQbQ3AR4BjWGUJ78K
         UykQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=U2XYjAlmEuUwJepaJ4jcTEgnHsw7F+8mCa7qXbe4CMo=;
        fh=9XWw+5Raq1eBFErbVHTEXfEcdSRlIvwmSE33mbSeZds=;
        b=QsEkh+bmRrO0MICQECNsksSGwDNOIjBfPm5K5OkMVs48zMKPCj0+UwS/d+cO1JIlk+
         DlN/apmcSTsDgtu+Onb73uuDejSKZd6MThSBjDW/HDSg8xwGfvx9SC+K2aigaA1mmwS2
         HbW3U32RLwKdOUuG3p7UbUbdLYCq+WXwQ5G7tAbvTOvJ6oenKMlI2Ckpyn85Yi1uJyWK
         mfPShsd5mW9AOBp4LTsvQkZ+rmWoYFtyOzRJhW5xTqtutR+YM6eVFk92ECA4qFWwq7nN
         yZcrk056B5Rv2rXjmCeg2xQ1AzPYqQ9Xp6UeucMGCldq4klW2sWScMYRfBT+JMdT4fir
         YtbQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775651655; x=1776256455; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=U2XYjAlmEuUwJepaJ4jcTEgnHsw7F+8mCa7qXbe4CMo=;
        b=Iidlg6DBYbLMXHTpzIt8KgLq8r0H1CxEQ7lBfGCjRgkOa0PliagelPioI7mZV3vhNx
         QmQ8Paaegtp9ltvHdtIxrq7a50ewY7QFmRXm3k1BYbYE9K3aPbbyK8pP8+q88jxCPWqC
         Tr/ZBSD8csWTsBrFNN/e+Up5QbHGpPqPMq7VsmuYmQUixeUGWDfdc6awFKoy1oLclLa7
         CEJxYvIusYGW8PLzxQZbUY3K3ak+iYckIBswd4+ObGvycqGOUosexfBnaOPQBC1ixiVJ
         c+qGznFdwjd+g2uRZOnyWOTUVK0yZIDV2VMXp5pdanEtJ+BdLS4nvODgJ3R/GLQ56Bwj
         jA/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775651655; x=1776256455;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=U2XYjAlmEuUwJepaJ4jcTEgnHsw7F+8mCa7qXbe4CMo=;
        b=HTaPwVcH/+YTRzSo7jMcw8McjxlCyLL5EMS16nzioZI3bxff1C3l+5ejzZygcw6RAZ
         428aUWEzcj9lXJBhFkZIj12xG6uhm3iqmMrxhKVnQ7iA9UoJ13T6OimmUcZGuUBjblIo
         tfgv9v/ozP0qAC++LONSyJweOGupSDUM+2C/LaZHu8UatQ+H6C5DO2w1l04hNmcOdMIb
         yA84rF/FR3fooBdptqvwL0/8hv5DyxRvdZgNvQvrFdg2DlvykkdYQUk1iiT5TGBb9QPf
         x6r7Ofsx/rpwlslIlWPKPdWNv6qXThf8Ckh6kQ+FE/BOJGiS36aTp1ff9Id2M5Co2uts
         zesw==
X-Forwarded-Encrypted: i=1; AJvYcCXKaqugENDTySJVHC9UAD6vdIagYTqfit7IweOePTzl09TxTBVv2ocVenQD6AV2CyplRao8xu8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz8etFlge8LBZb+sEqjqTtHQ8xGrotnfDFUKMYf+SJqFHID5hcP
	rvyou8hkZmzY09x9TeMIhuCogs27cdzmIf5lncTXSGLpSYpgWnl2mjGJL39gKemfzWpMp4UfuMD
	QU3bkHxrq8vwa+wiWpOtCcuqCQa8b9ENqHJx7unoYOvBGmwoDTU9nAhg6
X-Gm-Gg: AeBDieucmrm2K5w5yMZ3MzZyGZt68Xo45xOC2CqCpHBKmFf5jFdOWlsDzDJEo7Zna9K
	/Uz2vKT14siKYi5DvccYqgqXPqmWnYnsx6eotn4tJtFPKvJ7Wy91dcBdr/T0agbymgoHLCzvsSE
	OyRyzBg6rX9ZWCdrb+DpIQnqKHYcwmTcb3e21Cv8bIueW8OgDjeg1WD3wpRu9tzloWHHTp+B6FV
	N/rJoSBPhoLZmsEOC+8pTe7RLqXSTfvx0jGpiNHNqIJT29RV9H2KK6hYEkhlX4Gn0bekqxW5jxn
	iLPWAcivq7F4uYmsSdLr7Z8bWLo4sbjHC73KstAUkgPqlqr5EiZ2OEefdy57lDobISjeTg==
X-Received: by 2002:a05:6870:aa05:b0:41c:9c4a:151f with SMTP id
 586e51a60fabf-4230fdb45b9mr12142206fac.14.1775651654060; Wed, 08 Apr 2026
 05:34:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69d641d3.050a0220.3030df.0006.GAE@google.com>
In-Reply-To: <69d641d3.050a0220.3030df.0006.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 8 Apr 2026 14:34:02 +0200
X-Gm-Features: AQROBzByrKdAk0bfZabDKovI8gpZF9cPpctjMUy-m00Sg3bJ_I4qiyyrnsF_Dzo
Message-ID: <CANp29Y7U3AJNU6DtJxavjNz-ZrXx1b+QpxviAoG0t2tm4j8BDg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: ipset: concurrent add and dump fixes
To: syzbot ci <syzbot+ci34ec31e5a0fabe59@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Apr 8, 2026 at 1:53=E2=80=AFPM syzbot ci
<syzbot+ci34ec31e5a0fabe59@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] netfilter: ipset: concurrent add and dump fixes
> https://lore.kernel.org/all/20260408070257.2437291-1-kadlec@netfilter.org
> * [PATCH 1/2] netfilter: ipset: Fix data race between add and list header=
 in all hash types
> * [PATCH 2/2] netfilter: ipset: Fix data race between add and dump in all=
 hash types
>
> and found the following issues:
> * KASAN: slab-out-of-bounds Write in hash_ip4_add
> * KASAN: slab-out-of-bounds Write in hash_ipport4_add
> * KASAN: slab-out-of-bounds Write in hash_ipport6_add
> * KASAN: slab-out-of-bounds Write in hash_ipportnet6_add
> * KASAN: slab-out-of-bounds Write in hash_netnet4_add
>
> Full report is available here:
> https://ci.syzbot.org/series/05533f07-931b-4bbe-886e-737c3dded97b
>
> ***
>
> KASAN: slab-out-of-bounds Write in hash_ip4_add
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      47117877d5707b32773bb3d5fd8f1f9aaf8f1f3b
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/8ee93551-dc97-4078-8c85-f884da5dc=
0bf/config
> syz repro: https://ci.syzbot.org/findings/09c3128d-24de-48b4-9d49-798ba00=
bda6e/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in hash_ip4_add+0x1063/0x1f20 net/netfilte=
r/ipset/ip_set_hash_gen.h:974
> Write of size 4 at addr ffff8881a844a680 by task syz.2.19/5958
>
> CPU: 1 UID: 0 PID: 5958 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
>  __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
>  hash_ip4_add+0x1063/0x1f20 net/netfilter/ipset/ip_set_hash_gen.h:974
>  hash_ip4_uadt+0x664/0x860 net/netfilter/ipset/ip_set_hash_ip.c:160
>  call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
>  nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fc54039c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fc53f9fe028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fc540615fa0 RCX: 00007fc54039c819
> RDX: 0000000004000084 RSI: 0000200000000000 RDI: 0000000000000004
> RBP: 00007fc540432c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fc540616038 R14: 00007fc540615fa0 R15: 00007ffe3b0d6a38
>  </TASK>
>
> Allocated by task 5958:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5260 [inline]
>  __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  hash_ip4_add+0xc85/0x1f20 net/netfilter/ipset/ip_set_hash_gen.h:881
>  hash_ip4_uadt+0x664/0x860 net/netfilter/ipset/ip_set_hash_ip.c:160
>  call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
>  nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff8881a844a600
>  which belongs to the cache kmalloc-128 of size 128
> The buggy address is located 0 bytes to the right of
>  allocated 128-byte region [ffff8881a844a600, ffff8881a844a680)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1a84=
4a
> flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000000 ffff888100041a00 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2820(=
GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 595=
8, tgid 5957 (syz.2.19), ts 61144574473, free_ts 60982422209
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
>  prep_new_page mm/page_alloc.c:1897 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
>  alloc_slab_page mm/slub.c:3292 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3481
>  new_slab mm/slub.c:3539 [inline]
>  refill_objects+0x331/0x3c0 mm/slub.c:7175
>  refill_sheaf mm/slub.c:2812 [inline]
>  __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
>  alloc_from_pcs mm/slub.c:4717 [inline]
>  slab_alloc_node mm/slub.c:4851 [inline]
>  __do_kmalloc_node mm/slub.c:5259 [inline]
>  __kmalloc_noprof+0x474/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  hash_ip4_add+0xc85/0x1f20 net/netfilter/ipset/ip_set_hash_gen.h:881
>  hash_ip4_uadt+0x664/0x860 net/netfilter/ipset/ip_set_hash_ip.c:160
>  call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
>  nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
> page last free pid 23 tgid 23 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1433 [inline]
>  __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
>  __tlb_remove_table_free mm/mmu_gather.c:228 [inline]
>  tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:291
>  rcu_do_batch kernel/rcu/tree.c:2617 [inline]
>  rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
>  handle_softirqs+0x22a/0x870 kernel/softirq.c:622
>  run_ksoftirqd+0x36/0x60 kernel/softirq.c:1063
>  smpboot_thread_fn+0x541/0xa50 kernel/smpboot.c:160
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff8881a844a580: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff8881a844a600: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> >ffff8881a844a680: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                    ^
>  ffff8881a844a700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff8881a844a780: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: slab-out-of-bounds Write in hash_ipport4_add
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      47117877d5707b32773bb3d5fd8f1f9aaf8f1f3b
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/8ee93551-dc97-4078-8c85-f884da5dc=
0bf/config
> syz repro: https://ci.syzbot.org/findings/d9446937-fb89-49b6-8e0d-0765ed1=
dc490/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in hash_ipport4_add+0x1218/0x22a0 net/netf=
ilter/ipset/ip_set_hash_gen.h:974
> Write of size 8 at addr ffff88810c5a8bb0 by task syz.1.18/5959
>
> CPU: 0 UID: 0 PID: 5959 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
>  __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
>  hash_ipport4_add+0x1218/0x22a0 net/netfilter/ipset/ip_set_hash_gen.h:974
>  hash_ipport4_uadt+0xaaf/0xde0 net/netfilter/ipset/ip_set_hash_ipport.c:1=
99
>  call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
>  nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f73b079c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f73b1662028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f73b0a15fa0 RCX: 00007f73b079c819
> RDX: 0000000000000090 RSI: 00002000000002c0 RDI: 0000000000000004
> RBP: 00007f73b0832c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f73b0a16038 R14: 00007f73b0a15fa0 R15: 00007fffcac649b8
>  </TASK>
>
> Allocated by task 5959:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5260 [inline]
>  __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  hash_ipport4_add+0xec2/0x22a0 net/netfilter/ipset/ip_set_hash_gen.h:881
>  hash_ipport4_uadt+0xaaf/0xde0 net/netfilter/ipset/ip_set_hash_ipport.c:1=
99
>  call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
>  nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88810c5a8b80
>  which belongs to the cache kmalloc-64 of size 64
> The buggy address is located 0 bytes to the right of
>  allocated 48-byte region [ffff88810c5a8b80, ffff88810c5a8bb0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10c5=
a8
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 28,=
 tgid 28 (kworker/u9:1), ts 11978057194, free_ts 0
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
>  prep_new_page mm/page_alloc.c:1897 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
>  alloc_slab_page mm/slub.c:3292 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3481
>  new_slab mm/slub.c:3539 [inline]
>  refill_objects+0x331/0x3c0 mm/slub.c:7175
>  refill_sheaf mm/slub.c:2812 [inline]
>  __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
>  alloc_from_pcs mm/slub.c:4717 [inline]
>  slab_alloc_node mm/slub.c:4851 [inline]
>  __do_kmalloc_node mm/slub.c:5259 [inline]
>  __kmalloc_node_noprof+0x577/0x7c0 mm/slub.c:5266
>  kmalloc_node_noprof include/linux/slab.h:1081 [inline]
>  __vmalloc_area_node mm/vmalloc.c:3855 [inline]
>  __vmalloc_node_range_noprof+0x5d5/0x1730 mm/vmalloc.c:4064
>  __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
>  alloc_thread_stack_node kernel/fork.c:355 [inline]
>  dup_task_struct+0x275/0x9a0 kernel/fork.c:924
>  copy_process+0x508/0x3cd0 kernel/fork.c:2050
>  kernel_clone+0x248/0x8e0 kernel/fork.c:2653
>  user_mode_thread+0x110/0x180 kernel/fork.c:2729
>  call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
>  process_one_work kernel/workqueue.c:3276 [inline]
>  process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff88810c5a8a80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
>  ffff88810c5a8b00: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> >ffff88810c5a8b80: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
>                                      ^
>  ffff88810c5a8c00: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
>  ffff88810c5a8c80: fa fb fb fb fb fb fb fb fc fc fc fc fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: slab-out-of-bounds Write in hash_ipport6_add
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      47117877d5707b32773bb3d5fd8f1f9aaf8f1f3b
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/8ee93551-dc97-4078-8c85-f884da5dc=
0bf/config
> syz repro: https://ci.syzbot.org/findings/5fc445de-91e9-4261-89a2-d600486=
1bc11/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in hash_ipport6_add+0x12fd/0x2260 net/netf=
ilter/ipset/ip_set_hash_gen.h:974
> Write of size 20 at addr ffff888110798c48 by task syz.2.19/6005
>
> CPU: 0 UID: 0 PID: 6005 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
>  __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
>  hash_ipport6_add+0x12fd/0x2260 net/netfilter/ipset/ip_set_hash_gen.h:974
>  hash_ipport6_uadt+0x85d/0xb20 net/netfilter/ipset/ip_set_hash_ipport.c:3=
51
>  call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
>  nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1edcf9c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f1eddde0028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f1edd215fa0 RCX: 00007f1edcf9c819
> RDX: 0000000000000090 RSI: 00002000000002c0 RDI: 0000000000000004
> RBP: 00007f1edd032c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f1edd216038 R14: 00007f1edd215fa0 R15: 00007ffd74c43f58
>  </TASK>
>
> Allocated by task 6005:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5260 [inline]
>  __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  hash_ipport6_add+0xfb6/0x2260 net/netfilter/ipset/ip_set_hash_gen.h:881
>  hash_ipport6_uadt+0x85d/0xb20 net/netfilter/ipset/ip_set_hash_ipport.c:3=
51
>  call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
>  nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888110798c00
>  which belongs to the cache kmalloc-96 of size 96
> The buggy address is located 0 bytes to the right of
>  allocated 72-byte region [ffff888110798c00, ffff888110798c48)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1107=
98
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff888100041280 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 109=
4, tgid 1094 (kworker/u9:3), ts 19156789334, free_ts 19155777767
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
>  prep_new_page mm/page_alloc.c:1897 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
>  alloc_slab_page mm/slub.c:3292 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3481
>  new_slab mm/slub.c:3539 [inline]
>  refill_objects+0x331/0x3c0 mm/slub.c:7175
>  refill_sheaf mm/slub.c:2812 [inline]
>  __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
>  alloc_from_pcs mm/slub.c:4717 [inline]
>  slab_alloc_node mm/slub.c:4851 [inline]
>  __kmalloc_cache_node_noprof+0x465/0x6b0 mm/slub.c:5388
>  kmalloc_node_noprof include/linux/slab.h:1077 [inline]
>  __get_vm_area_node+0x13f/0x300 mm/vmalloc.c:3221
>  __vmalloc_node_range_noprof+0x372/0x1730 mm/vmalloc.c:4024
>  __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
>  alloc_thread_stack_node kernel/fork.c:355 [inline]
>  dup_task_struct+0x275/0x9a0 kernel/fork.c:924
>  copy_process+0x508/0x3cd0 kernel/fork.c:2050
>  kernel_clone+0x248/0x8e0 kernel/fork.c:2653
>  user_mode_thread+0x110/0x180 kernel/fork.c:2729
>  call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
>  process_one_work kernel/workqueue.c:3276 [inline]
>  process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
> page last free pid 1094 tgid 1094 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1433 [inline]
>  __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
>  __kasan_populate_vmalloc_do mm/kasan/shadow.c:393 [inline]
>  __kasan_populate_vmalloc+0x1b2/0x1d0 mm/kasan/shadow.c:424
>  kasan_populate_vmalloc include/linux/kasan.h:580 [inline]
>  alloc_vmap_area+0xd73/0x14b0 mm/vmalloc.c:2129
>  __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:3232
>  __vmalloc_node_range_noprof+0x372/0x1730 mm/vmalloc.c:4024
>  __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
>  alloc_thread_stack_node kernel/fork.c:355 [inline]
>  dup_task_struct+0x275/0x9a0 kernel/fork.c:924
>  copy_process+0x508/0x3cd0 kernel/fork.c:2050
>  kernel_clone+0x248/0x8e0 kernel/fork.c:2653
>  user_mode_thread+0x110/0x180 kernel/fork.c:2729
>  call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
>  process_one_work kernel/workqueue.c:3276 [inline]
>  process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff888110798b00: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>  ffff888110798b80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
> >ffff888110798c00: 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc
>                                               ^
>  ffff888110798c80: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
>  ffff888110798d00: 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: slab-out-of-bounds Write in hash_ipportnet6_add
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      47117877d5707b32773bb3d5fd8f1f9aaf8f1f3b
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/8ee93551-dc97-4078-8c85-f884da5dc=
0bf/config
> syz repro: https://ci.syzbot.org/findings/9a835a65-c731-420b-98c9-76cbdfe=
4d5e7/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in hash_ipportnet6_add+0x1eab/0x2ef0 net/n=
etfilter/ipset/ip_set_hash_gen.h:974
> Write of size 36 at addr ffff88812055d068 by task syz.0.17/5970
>
> CPU: 0 UID: 0 PID: 5970 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
>  __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
>  hash_ipportnet6_add+0x1eab/0x2ef0 net/netfilter/ipset/ip_set_hash_gen.h:=
974
>  hash_ipportnet6_uadt+0xa88/0xe00 net/netfilter/ipset/ip_set_hash_ipportn=
et.c:504
>  call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
>  nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fbe1ad9c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fbe1bccc028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fbe1b015fa0 RCX: 00007fbe1ad9c819
> RDX: 0000000000000000 RSI: 00002000000002c0 RDI: 0000000000000004
> RBP: 00007fbe1ae32c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fbe1b016038 R14: 00007fbe1b015fa0 R15: 00007ffe829d96c8
>  </TASK>
>
> Allocated by task 5970:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5260 [inline]
>  __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  hash_ipportnet6_add+0x11fe/0x2ef0 net/netfilter/ipset/ip_set_hash_gen.h:=
881
>  hash_ipportnet6_uadt+0xa88/0xe00 net/netfilter/ipset/ip_set_hash_ipportn=
et.c:504
>  call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
>  nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88812055d000
>  which belongs to the cache kmalloc-128 of size 128
> The buggy address is located 0 bytes to the right of
>  allocated 104-byte region [ffff88812055d000, ffff88812055d068)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1205=
5d
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff888100041a00 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000800100010 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2820(=
GFP_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 597=
0, tgid 5969 (syz.0.17), ts 62254504797, free_ts 59906136451
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
>  prep_new_page mm/page_alloc.c:1897 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
>  alloc_slab_page mm/slub.c:3292 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3481
>  new_slab mm/slub.c:3539 [inline]
>  refill_objects+0x331/0x3c0 mm/slub.c:7175
>  refill_sheaf mm/slub.c:2812 [inline]
>  __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
>  alloc_from_pcs mm/slub.c:4717 [inline]
>  slab_alloc_node mm/slub.c:4851 [inline]
>  __do_kmalloc_node mm/slub.c:5259 [inline]
>  __kmalloc_noprof+0x474/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  hash_ipportnet6_add+0x11fe/0x2ef0 net/netfilter/ipset/ip_set_hash_gen.h:=
881
>  hash_ipportnet6_uadt+0xa88/0xe00 net/netfilter/ipset/ip_set_hash_ipportn=
et.c:504
>  call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
>  nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
> page last free pid 5885 tgid 5885 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1433 [inline]
>  __free_frozen_pages+0xc2b/0xdb0 mm/page_alloc.c:2978
>  vfree+0x25a/0x400 mm/vmalloc.c:3479
>  kcov_put kernel/kcov.c:442 [inline]
>  kcov_close+0x28/0x50 kernel/kcov.c:543
>  __fput+0x44f/0xa70 fs/file_table.c:469
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  exit_task_work include/linux/task_work.h:40 [inline]
>  do_exit+0x70f/0x23c0 kernel/exit.c:976
>  do_group_exit+0x21b/0x2d0 kernel/exit.c:1118
>  get_signal+0x1284/0x1330 kernel/signal.c:3034
>  arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
>  exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
>  do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff88812055cf00: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
>  ffff88812055cf80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff88812055d000: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
>                                                           ^
>  ffff88812055d080: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88812055d100: 00 00 00 00 00 00 00 00 00 00 00 00 00 fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: slab-out-of-bounds Write in hash_netnet4_add
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      47117877d5707b32773bb3d5fd8f1f9aaf8f1f3b
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/8ee93551-dc97-4078-8c85-f884da5dc=
0bf/config
> syz repro: https://ci.syzbot.org/findings/72f192ce-33b7-4dd0-b1e5-1666100=
981b0/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in hash_netnet4_add+0x1852/0x27d0 net/netf=
ilter/ipset/ip_set_hash_gen.h:974
> Write of size 16 at addr ffff8881125a9f40 by task syz.1.18/5970
>
> CPU: 0 UID: 0 PID: 5970 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
>  __asan_memcpy+0x40/0x70 mm/kasan/shadow.c:106
>  hash_netnet4_add+0x1852/0x27d0 net/netfilter/ipset/ip_set_hash_gen.h:974
>  hash_netnet4_uadt+0xc06/0xf20 net/netfilter/ipset/ip_set_hash_netnet.c:2=
69
>  call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
>  nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f23ac39c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f23ad2b1028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f23ac615fa0 RCX: 00007f23ac39c819
> RDX: 0000000000000004 RSI: 00002000000000c0 RDI: 0000000000000003
> RBP: 00007f23ac432c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f23ac616038 R14: 00007f23ac615fa0 R15: 00007fff91226648
>  </TASK>
>
> Allocated by task 5970:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5260 [inline]
>  __kmalloc_noprof+0x35c/0x760 mm/slub.c:5272
>  kmalloc_noprof include/linux/slab.h:954 [inline]
>  kzalloc_noprof include/linux/slab.h:1188 [inline]
>  hash_netnet4_add+0xe44/0x27d0 net/netfilter/ipset/ip_set_hash_gen.h:881
>  hash_netnet4_uadt+0xc06/0xf20 net/netfilter/ipset/ip_set_hash_netnet.c:2=
69
>  call_ad+0x18d/0xb60 net/netfilter/ipset/ip_set_core.c:1751
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1841
>  nfnetlink_rcv_msg+0xc00/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff8881125a9f00
>  which belongs to the cache kmalloc-64 of size 64
> The buggy address is located 0 bytes to the right of
>  allocated 64-byte region [ffff8881125a9f00, ffff8881125a9f40)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1125=
a9
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff8881000418c0 dead000000000100 dead000000000122
> raw: 0000000000000000 0000000800200020 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 55,=
 tgid 55 (kworker/u9:2), ts 19909977372, free_ts 0
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1889
>  prep_new_page mm/page_alloc.c:1897 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3962
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5250
>  alloc_slab_page mm/slub.c:3292 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3481
>  new_slab mm/slub.c:3539 [inline]
>  refill_objects+0x331/0x3c0 mm/slub.c:7175
>  refill_sheaf mm/slub.c:2812 [inline]
>  __pcs_replace_empty_main+0x2e6/0x730 mm/slub.c:4615
>  alloc_from_pcs mm/slub.c:4717 [inline]
>  slab_alloc_node mm/slub.c:4851 [inline]
>  __do_kmalloc_node mm/slub.c:5259 [inline]
>  __kmalloc_node_noprof+0x577/0x7c0 mm/slub.c:5266
>  kmalloc_node_noprof include/linux/slab.h:1081 [inline]
>  __vmalloc_area_node mm/vmalloc.c:3855 [inline]
>  __vmalloc_node_range_noprof+0x5d5/0x1730 mm/vmalloc.c:4064
>  __vmalloc_node_noprof+0xc2/0x100 mm/vmalloc.c:4124
>  alloc_thread_stack_node kernel/fork.c:355 [inline]
>  dup_task_struct+0x275/0x9a0 kernel/fork.c:924
>  copy_process+0x508/0x3cd0 kernel/fork.c:2050
>  kernel_clone+0x248/0x8e0 kernel/fork.c:2653
>  user_mode_thread+0x110/0x180 kernel/fork.c:2729
>  call_usermodehelper_exec_work+0x5c/0x230 kernel/umh.c:171
>  process_one_work kernel/workqueue.c:3276 [inline]
>  process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff8881125a9e00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>  ffff8881125a9e80: 00 00 00 00 00 00 fc fc fc fc fc fc fc fc fc fc
> >ffff8881125a9f00: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>                                            ^
>  ffff8881125a9f80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>  ffff8881125aa000: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [fw@strlen.de kadlec@netfilter.org netfilter-devel@vger.kernel.org pablo@=
netfilter.org]
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
-upstream-moderation/69d641d3.050a0220.3030df.0006.GAE%40google.com.
