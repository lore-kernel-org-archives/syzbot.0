Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23DD832B98A
	for <syzbot@lists.linux.dev>; Fri, 28 Nov 2025 13:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764335033; cv=none; b=JwHh06zsfxwXKNvW0Vbq2wbvkNZt0ZNHF1Kv8ghVu1yQCYnFOIpMR0qwv2FLMm+OQ8+WMtdYkhmwgZnwiB/sAZ4BJPogMRVzoXuCSABZB0WUVKIQsMSqxSOEpf9Kuc1YinoKbHIwc1egby2t4SklVC5Y7qm4h+9B7e8E7bSlF1g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764335033; c=relaxed/simple;
	bh=vHL5m3NzYxF8qFH3uDGxCfdV2zfVN++sEEYojAWHBR4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JQkvbfFnWSjjyj6J6AV71jiccZMxxgUKZr21CgyQx5pDxV3QCFm0sHefYaqxPeSnzq5lySY7oHmkdnvTQ5mCXNbgZJKL36Y6d8ICW89kCimfDnlwJBrVHLfK1kikWqJdwke+u/HwF/aTpqQ2enXttbH1fz/rOaV++tmcg1GTjfo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MWwUtX7d; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MWwUtX7d"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-42b2e9ac45aso1189837f8f.0
        for <syzbot@lists.linux.dev>; Fri, 28 Nov 2025 05:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764335029; x=1764939829; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QUarC0aUlavkOqN2/EUI8nDK5W/4vHaXabg20SjmoKY=;
        b=MWwUtX7dg3MD26Qtc84hts75Lm/n+bBbvGYmJC2WUFn17Ewm/ldYY5kVElh1DJ7/91
         GnvCkVA2UukCDYPxKYlalwXxtwOJasXAsesVLndHUZ26ZkOlwCwU22jWuKq+8uMv7tyq
         X1lqX4uSJ5EZsSrgO/Cv2v6xdShmlkHovOtAJFAfg9GghxEQxSZRarcS5azRRJ8PkOYs
         rai0D21q2pjYtX5Urd9HB0Oduu9mj0t8/QB9nmh/b8JL0GjFvwd7TdM91TozxYXhYCH6
         1tYpy2X+/hdeGFs3t7LqLG3prTjJdNYTD9T+++jrKbP23JGuV4WZPXysWgmDoLQB2o6I
         WcCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764335029; x=1764939829;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QUarC0aUlavkOqN2/EUI8nDK5W/4vHaXabg20SjmoKY=;
        b=fSh4JxslNfU6dEgSr9Cfq9D/nqPVv4VR0IFBF/JFfh+OM7MvviHO6K+7d217jlIEqN
         cqB1hWDiLKFnGqGcbLNHfoUDwvwlCKQpYJ79x/6ZdQJYh/Hl3W+ggLG7Ra/lTLRrTPYF
         u5rE5H3iSt5WROFygHGsGn72cI6g3kWB/IyAvQI9nBT6UV4Me35oT+ig8zfnLAOKqTOt
         ZlRIarW0fCHIdkuSANxPA1pwSUPZgdXf+Dc8BLo47T66no4534Z+sI5K/hSU9NnIPiv3
         97SYU7cs0vo3nDppEKGBrhqGO4sgp5nG9vKHcuF3WsBoaXwbcTC2cCHO+wnY+3ZvL2S9
         5FOw==
X-Forwarded-Encrypted: i=1; AJvYcCWkQ4KH8NEoN7jQlKMU2ibRyy5ORCoBH3bu/J4zHPgO2GlEIW2rSSVQ4KieMlbLDE4hIGASw8M=@lists.linux.dev
X-Gm-Message-State: AOJu0YxluN70oSqG7cb/BK/yin1W/kes4zuKuH3SrZEUKiepkRC+IstW
	0UIORbjQm1xI7VPGXJncQducNGelGqRTtpc0/BWPzqILOQS5dp1AqaDRg6eRal1mLeEE7qvgVzs
	lgUxOFLCoC/qeajwYktPQNLHugmKOvyllDkqSHFWe
X-Gm-Gg: ASbGncub30RacAGqrdJTe0Wg+Yq/WtY/pOdFB//mBPzXdy1vEA7B14T/3HpCLnjr6QC
	NPkzJz0/+MpjUzvw35NhCSFKDJThMSz+dEZni1R/aWYdRIYA6+4WurafbyRt5D8oWZmWKtadjUP
	fbRXNHxTj05NdbsedsvJSLDj1JNcptmX4OPDMmeLUgRvldlUS8tBdjc8cEyoBXLzh/A1RiJgo30
	fRTAhbSQbFOq8BJmyO5Yg4fHv0gXOrByNAP+HS8fhyKvc1AZUdnJZUaPBPJxlKgRKM/2jPU06Zm
	qBez6XDc3HNYckHTUdWnhOy9psjYgsFCfhqChL3VVSvKIPE9FSlZhKH99A==
X-Google-Smtp-Source: AGHT+IEZRZkrujDDvhVR8VKVqOPpVCJr7ccKg9ZXW5xGyQAyogzfTKQd3DezimepQygdzyV/zev/rXLmBvaJvUgm7lc=
X-Received: by 2002:a5d:5d81:0:b0:427:167:c2c3 with SMTP id
 ffacd0b85a97d-42e0f35034amr16517714f8f.48.1764335029006; Fri, 28 Nov 2025
 05:03:49 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69299d70.a70a0220.d98e3.013d.GAE@google.com>
In-Reply-To: <69299d70.a70a0220.d98e3.013d.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 28 Nov 2025 14:03:35 +0100
X-Gm-Features: AWmQ_bmdsoDmyUk8tRYGmUakRQUwk3aHs6FDyiN2Z6cjD7qt9kOgaxX3br1Mn54
Message-ID: <CANp29Y6h2hEbgqA6kFKvnTUv_wSEu3+e1=k61sTcY6rtQ4Hmhw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: restore the iterator to its original
 state when an error occurs
To: syzbot ci <syzbot+ci524820923ecef9fd@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Nov 28, 2025 at 2:02=E2=80=AFPM syzbot ci
<syzbot+ci524820923ecef9fd@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: restore the iterator to its original state when an error occurs
> https://lore.kernel.org/all/tencent_387517772566B03DBD365896C036264AA809@=
qq.com
> * [PATCH Next] net: restore the iterator to its original state when an er=
ror occurs
>
> and found the following issues:
> * KASAN: slab-out-of-bounds Read in iov_iter_revert
> * KASAN: stack-out-of-bounds Read in iov_iter_revert
>
> Full report is available here:
> https://ci.syzbot.org/series/b5c506f4-f657-428b-bd21-8d50aedef42c
>
> ***
>
> KASAN: slab-out-of-bounds Read in iov_iter_revert
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      db4029859d6fd03f0622d394f4cdb1be86d7ec62
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/253e310d-d693-4611-8760-36e2b39c0=
752/config
> syz repro: https://ci.syzbot.org/findings/1bbe297c-62ec-4071-9df3-d1c80a2=
bb758/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in iov_iter_revert+0x4d5/0x5f0 lib/iov_ite=
r.c:645
> Read of size 8 at addr ffff888112061ff8 by task syz.1.18/5997
>
> CPU: 0 UID: 0 PID: 5997 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  iov_iter_revert+0x4d5/0x5f0 lib/iov_iter.c:645
>  skb_zerocopy_iter_stream+0x27d/0x660 net/core/skbuff.c:1911
>  tcp_sendmsg_locked+0x1815/0x5540 net/ipv4/tcp.c:1300
>  tcp_sendmsg+0x2f/0x50 net/ipv4/tcp.c:1412
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x19c/0x270 net/socket.c:742
>  ____sys_sendmsg+0x52d/0x830 net/socket.c:2630
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
>  __sys_sendmmsg+0x227/0x430 net/socket.c:2773
>  __do_sys_sendmmsg net/socket.c:2800 [inline]
>  __se_sys_sendmmsg net/socket.c:2797 [inline]
>  __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2797
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f6942f8f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f6943d8a038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00007f69431e5fa0 RCX: 00007f6942f8f749
> RDX: 0000000000000004 RSI: 0000200000000d00 RDI: 0000000000000003
> RBP: 00007f6943013f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000004000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f69431e6038 R14: 00007f69431e5fa0 R15: 00007fff3f790f38
>  </TASK>
>
> Allocated by task 5913:
>  kasan_save_stack mm/kasan/common.c:56 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
>  poison_kmalloc_redzone mm/kasan/common.c:400 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:417
>  kasan_kmalloc include/linux/kasan.h:262 [inline]
>  __do_kmalloc_node mm/slub.c:5650 [inline]
>  __kmalloc_noprof+0x411/0x7f0 mm/slub.c:5662
>  kmalloc_noprof include/linux/slab.h:961 [inline]
>  kzalloc_noprof include/linux/slab.h:1094 [inline]
>  ip6t_alloc_initial_table+0x6b/0x6d0 net/ipv6/netfilter/ip6_tables.c:40
>  ip6table_security_table_init+0x1b/0x70 net/ipv6/netfilter/ip6table_secur=
ity.c:42
>  xt_find_table_lock+0x30c/0x3e0 net/netfilter/x_tables.c:1260
>  xt_request_find_table_lock+0x26/0x100 net/netfilter/x_tables.c:1285
>  get_info net/ipv6/netfilter/ip6_tables.c:979 [inline]
>  do_ip6t_get_ctl+0x730/0x1180 net/ipv6/netfilter/ip6_tables.c:1668
>  nf_getsockopt+0x26e/0x290 net/netfilter/nf_sockopt.c:116
>  ipv6_getsockopt+0x1ed/0x290 net/ipv6/ipv6_sockglue.c:1473
>  do_sock_getsockopt+0x372/0x450 net/socket.c:2421
>  __sys_getsockopt net/socket.c:2450 [inline]
>  __do_sys_getsockopt net/socket.c:2457 [inline]
>  __se_sys_getsockopt net/socket.c:2454 [inline]
>  __x64_sys_getsockopt+0x1a5/0x250 net/socket.c:2454
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 5913:
>  kasan_save_stack mm/kasan/common.c:56 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
>  __kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:587
>  kasan_save_free_info mm/kasan/kasan.h:406 [inline]
>  poison_slab_object mm/kasan/common.c:252 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:284
>  kasan_slab_free include/linux/kasan.h:234 [inline]
>  slab_free_hook mm/slub.c:2543 [inline]
>  slab_free mm/slub.c:6642 [inline]
>  kfree+0x19a/0x6d0 mm/slub.c:6849
>  ip6table_security_table_init+0x4b/0x70 net/ipv6/netfilter/ip6table_secur=
ity.c:46
>  xt_find_table_lock+0x30c/0x3e0 net/netfilter/x_tables.c:1260
>  xt_request_find_table_lock+0x26/0x100 net/netfilter/x_tables.c:1285
>  get_info net/ipv6/netfilter/ip6_tables.c:979 [inline]
>  do_ip6t_get_ctl+0x730/0x1180 net/ipv6/netfilter/ip6_tables.c:1668
>  nf_getsockopt+0x26e/0x290 net/netfilter/nf_sockopt.c:116
>  ipv6_getsockopt+0x1ed/0x290 net/ipv6/ipv6_sockglue.c:1473
>  do_sock_getsockopt+0x372/0x450 net/socket.c:2421
>  __sys_getsockopt net/socket.c:2450 [inline]
>  __do_sys_getsockopt net/socket.c:2457 [inline]
>  __se_sys_getsockopt net/socket.c:2454 [inline]
>  __x64_sys_getsockopt+0x1a5/0x250 net/socket.c:2454
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888112061800
>  which belongs to the cache kmalloc-1k of size 1024
> The buggy address is located 1016 bytes to the right of
>  allocated 1024-byte region [ffff888112061800, ffff888112061c00)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1120=
60
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000040 ffff888100041dc0 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
> head: 017ff00000000040 ffff888100041dc0 dead000000000122 0000000000000000
> head: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
> head: 017ff00000000003 ffffea0004481801 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 5913, tgid 5913 (syz-executor), ts 67648433769, free_ts 67644331621
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
>  __do_kmalloc_node mm/slub.c:5649 [inline]
>  __kmalloc_noprof+0x471/0x7f0 mm/slub.c:5662
>  kmalloc_noprof include/linux/slab.h:961 [inline]
>  kzalloc_noprof include/linux/slab.h:1094 [inline]
>  ipt_alloc_initial_table+0x6b/0x6a0 net/ipv4/netfilter/ip_tables.c:36
>  iptable_security_table_init+0x1b/0x70 net/ipv4/netfilter/iptable_securit=
y.c:43
>  xt_find_table_lock+0x30c/0x3e0 net/netfilter/x_tables.c:1260
>  xt_request_find_table_lock+0x26/0x100 net/netfilter/x_tables.c:1285
>  get_info net/ipv4/netfilter/ip_tables.c:963 [inline]
>  do_ipt_get_ctl+0x730/0x1180 net/ipv4/netfilter/ip_tables.c:1659
>  nf_getsockopt+0x26e/0x290 net/netfilter/nf_sockopt.c:116
>  ip_getsockopt+0x1c4/0x220 net/ipv4/ip_sockglue.c:1777
>  do_sock_getsockopt+0x372/0x450 net/socket.c:2421
> page last free pid 5913 tgid 5913 stack trace:
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
>  ffff888112061e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff888112061f00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff888112061f80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                                                                 ^
>  ffff888112062000: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff888112062080: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
>
> ***
>
> KASAN: stack-out-of-bounds Read in iov_iter_revert
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      db4029859d6fd03f0622d394f4cdb1be86d7ec62
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/253e310d-d693-4611-8760-36e2b39c0=
752/config
> C repro:   https://ci.syzbot.org/findings/be09fb4c-b087-441e-a7d7-eb8da4f=
7a000/c_repro
> syz repro: https://ci.syzbot.org/findings/be09fb4c-b087-441e-a7d7-eb8da4f=
7a000/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: stack-out-of-bounds in iov_iter_revert+0x4d5/0x5f0 lib/iov_it=
er.c:645
> Read of size 8 at addr ffffc90003847b58 by task syz.0.17/5946
>
> CPU: 0 UID: 0 PID: 5946 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  iov_iter_revert+0x4d5/0x5f0 lib/iov_iter.c:645
>  skb_zerocopy_iter_stream+0x27d/0x660 net/core/skbuff.c:1911
>  tcp_sendmsg_locked+0x1815/0x5540 net/ipv4/tcp.c:1300
>  tcp_sendmsg+0x2f/0x50 net/ipv4/tcp.c:1412
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x19c/0x270 net/socket.c:742
>  ____sys_sendmsg+0x52d/0x830 net/socket.c:2630
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
>  __sys_sendmmsg+0x227/0x430 net/socket.c:2773
>  __do_sys_sendmmsg net/socket.c:2800 [inline]
>  __se_sys_sendmmsg net/socket.c:2797 [inline]
>  __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2797
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe7c078f749
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe7c1647038 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00007fe7c09e5fa0 RCX: 00007fe7c078f749
> RDX: 0000000000000004 RSI: 0000200000000d00 RDI: 0000000000000003
> RBP: 00007fe7c0813f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000004000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe7c09e6038 R14: 00007fe7c09e5fa0 R15: 00007ffd19e95ea8
>  </TASK>
>
> The buggy address belongs to stack of task syz.0.17/5946
>  and is located at offset 280 in frame:
>  ___sys_sendmsg+0x0/0x2a0 net/socket.c:2713
>
> This frame has 4 objects:
>  [32, 88) 'msg.i.i'
>  [128, 256) 'address'
>  [288, 416) 'iovstack'
>  [448, 456) 'iov'
>
> The buggy address belongs to a 8-page vmalloc region starting at 0xffffc9=
0003840000 allocated at copy_process+0x54b/0x3c00 kernel/fork.c:2012
> The buggy address belongs to the physical page:
> page: refcount:1 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1135=
fc
> memcg:ffff88810c5ca102
> flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> raw: 017ff00000000000 0000000000000000 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000000000000 00000001ffffffff ffff88810c5ca102
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2dc2(G=
FP_KERNEL|__GFP_HIGHMEM|__GFP_ZERO|__GFP_NOWARN), pid 5869, tgid 5869 (syz-=
executor), ts 56973482428, free_ts 56803199363
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x234/0x290 mm/page_alloc.c:1845
>  prep_new_page mm/page_alloc.c:1853 [inline]
>  get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3879
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5178
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
>  alloc_frozen_pages_noprof mm/mempolicy.c:2487 [inline]
>  alloc_pages_noprof+0xa9/0x190 mm/mempolicy.c:2507
>  vm_area_alloc_pages mm/vmalloc.c:3647 [inline]
>  __vmalloc_area_node mm/vmalloc.c:3724 [inline]
>  __vmalloc_node_range_noprof+0x96c/0x12d0 mm/vmalloc.c:3897
>  __vmalloc_node_noprof+0xc2/0x110 mm/vmalloc.c:3960
>  alloc_thread_stack_node kernel/fork.c:311 [inline]
>  dup_task_struct+0x3d4/0x830 kernel/fork.c:881
>  copy_process+0x54b/0x3c00 kernel/fork.c:2012
>  kernel_clone+0x21e/0x840 kernel/fork.c:2609
>  __do_sys_clone kernel/fork.c:2750 [inline]
>  __se_sys_clone kernel/fork.c:2734 [inline]
>  __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2734
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page last free pid 5845 tgid 5845 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1394 [inline]
>  __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2901
>  kasan_depopulate_vmalloc_pte+0x6d/0x90 mm/kasan/shadow.c:495
>  apply_to_pte_range mm/memory.c:3143 [inline]
>  apply_to_pmd_range mm/memory.c:3187 [inline]
>  apply_to_pud_range mm/memory.c:3223 [inline]
>  apply_to_p4d_range mm/memory.c:3259 [inline]
>  __apply_to_page_range+0xb66/0x13d0 mm/memory.c:3295
>  kasan_release_vmalloc+0xa2/0xd0 mm/kasan/shadow.c:616
>  kasan_release_vmalloc_node mm/vmalloc.c:2255 [inline]
>  purge_vmap_node+0x214/0x8f0 mm/vmalloc.c:2272
>  __purge_vmap_area_lazy+0x7a4/0xb40 mm/vmalloc.c:2362
>  drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2396
>  process_one_work kernel/workqueue.c:3263 [inline]
>  process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3346
>  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3427
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffffc90003847a00: 00 00 00 00 00 00 00 00 f1 f1 f1 f1 00 00 00 00
>  ffffc90003847a80: 00 00 00 f2 f2 f2 f2 f2 00 00 00 00 00 00 00 00
> >ffffc90003847b00: 00 00 00 00 00 00 00 00 f2 f2 f2 f2 00 00 00 00
>                                                     ^
>  ffffc90003847b80: 00 00 00 00 00 00 00 00 00 00 00 00 f2 f2 f2 f2
>  ffffc90003847c00: 00 f3 f3 f3 00 00 00 00 00 00 00 00 00 00 00 00
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
> [davem@davemloft.net eadavis@qq.com edumazet@google.com eperezma@redhat.c=
om horms@kernel.org jasowang@redhat.com kuba@kernel.org kvm@vger.kernel.org=
 linux-kernel@vger.kernel.org mst@redhat.com netdev@vger.kernel.org pabeni@=
redhat.com sgarzare@redhat.com stefanha@redhat.com syzbot@syzkaller.appspot=
mail.com syzkaller-bugs@googlegroups.com virtualization@lists.linux.dev xua=
nzhuo@linux.alibaba.com]
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
-upstream-moderation/69299d70.a70a0220.d98e3.013d.GAE%40google.com.
