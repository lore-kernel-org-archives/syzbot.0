Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FBA43B4C83
	for <syzbot@lists.linux.dev>; Thu, 22 Jan 2026 21:03:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769115836; cv=pass; b=u1Q4gRCzR4H5DmDeM4UPyqd/xAQxI/7ghrqk5oVgA4tElKmZH5V4kdtYA/UtD7bpc3yIYqUVgeWAcYsG66KpviB8Es96XuF/PupS7EDeM16bf6NyGXIQPya1SjOfrK5cD3RG9eybHP39RDPqFhLE9MRB+4LGGcNFPCSMPnajzY0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769115836; c=relaxed/simple;
	bh=+Qbvd4e3f8e+7xv0RdpYcEqjsB32FrCbR3YbC6lHnMg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TCKXRpn5AJ5OeKxn7RIlPGDsKdA3/iSycc/9s/XkGoX2SN0WF3do8Mgmvvod5HfNL08WyyH823yFWbkt7542vHgUJEPFJ1AWpvZ/WOcLKEqRSJTsGxCAvmxNgR8BOM4HpJ1IqmW44FVBX5dWrefR0y2a4AQpDu4MT0HR5YQgV4A=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d+w5d1uA; arc=pass smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d+w5d1uA"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7cfd57f0bf7so853154a34.3
        for <syzbot@lists.linux.dev>; Thu, 22 Jan 2026 13:03:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769115826; cv=none;
        d=google.com; s=arc-20240605;
        b=k8QeJcEAZA1E2M9gZHEg7ImfFu1yZ8vBH2EgbANdAusAjoHek2It/gGUNN96dVBNkH
         6Dwkb82QLqW9cIU0kSonBOIp3/fSuAYCOxXQBdjaEsDY6OkeXdSB47zYwe/QHiIph8AJ
         ExRXNHoXWeu/SAuONOMZgV9V8iGQdTHOuYPYw1VsCAgwKsNi5ijVtBWM6xXZJKgsTN06
         14MotQ+eMrCZraaenH0t0m/M7L05QNZXgVWd3r1TVH741C5+gByWA9IIEoMPTeKNJxGs
         Pb48GMZNmZHoPDV2JcmAxm8IeIdpxIZRcmC0KX5yOsv10NNlhFYuKlwiAr82ohU3ofJ5
         BM0Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SVyQaJErkiOuPaEr9M7nM5PMfTQpzzxbyfjhn1/HTRw=;
        fh=HEBYPuLhMfzJK+oipSfcs2Qvdvv1eL17oySPBOcdnFw=;
        b=SNhmQYegBTiWgprob5G/197pUUVeYOm4gvyGZM0VvqBzB5ZgW+3JGj57BA6Hem/Z1S
         tfbRD/RfSEVhCQiOgCCyb8xgvP++8CqqoSpB0JVUOAt/Z/EKUSO9Ms4aIKSaiFcseCaS
         MpwIDnCNsuZhoCjboiOmPsv+Bum4/mWDsZFjLOGR5prRNLuSswM3MV3HURRd2z4+gssX
         3EV32p1vzChDjyJMcyRbZ4qQL9ZbXEYmxy3Q64JOjchVc7fiTLWvZQkRco41PQTFAReY
         pCEDHE3uUNPfdjyYqMrXcbbL2q0xGo26vZB0kiVS+LDg33TtqD8ndUR4/g2I6Z3JdJSR
         2PRw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769115826; x=1769720626; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SVyQaJErkiOuPaEr9M7nM5PMfTQpzzxbyfjhn1/HTRw=;
        b=d+w5d1uAPink9G2c1uNrqZ8rReAoxF2HLpz+lpMMlctDVEkSiiHxfazaNw1OJ6wAmz
         RI7n0qhrrkWJ8dYAk5KNBUU087e02TM8vqlsSeLW65+0TqDTpi24ht9Qw4BP3gtMD4ql
         6peJ4Ue0S4gn5W+vMZb1IZF19tJ3jtErEIsHIlhAKTrA3czvR4PvPlyFy2kE1Jx1v7NW
         TekuciQ1Jx99Z+hj17Z/6H+v/IP6bhUf7LW58B8C+uuUutRmhqse5dPLGqkk6oM+xWwS
         1jTFnh40lBQoDRT4UQCxViHM0juYFTaoveAoqbhAHkwB6A52SpCoc9t2G+eDnb/6yIXZ
         t76g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769115826; x=1769720626;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SVyQaJErkiOuPaEr9M7nM5PMfTQpzzxbyfjhn1/HTRw=;
        b=FGEEM0fKNab4gs16LuSyZzwGrMLF0+mshBplul3jQKGh5jDNvFyefTRSeCck3anIw8
         snaxeWz8jG5s8pfIyoTp/CbQF2AZv8ZqG4oSzQb/yhb/SNUMWUid6gRbkUdJHVzkXqPK
         TGxIjb20nRKPlM5KWwsBryRaXlf5FkKX9VAWu2y9xdguKLEn4sBJdlHmaRt/+oFEphCv
         csHxTqL/q9lyXtie6Lluci0Gz4bSaLVgUtDNo8DZTO5YpVQBd28qOWumemFV4cYELzgA
         7XMewWZAbcMk9tNFj5QbwFlq8ncqizvK3nCW+x529hyW0xrn3L4ch5zYy/VD2jDDFdPG
         5SNw==
X-Forwarded-Encrypted: i=1; AJvYcCWlHf3h9HA+BD6v2BUW2RZ+P/zlnwt0m+bJMy5moTzwUgn5h7qWysxLdCYiTdDYfzqkGSg4rKc=@lists.linux.dev
X-Gm-Message-State: AOJu0YycTzuvMchF7z7Zs20uMMs0TZ/nCoa4tBy69k9Sn4uG8UoyvqUX
	7kzMSAk8ZkN8sII0A5cXISnU+93zC6L47pXDAvID0JHoqffQZxXZ7jSZdSdP5U5CXxbaDxeCXYX
	EzXfh/YawPYwcNJ4GwOpROOQaTLyrZSevP+qEhKkx
X-Gm-Gg: AZuq6aJybvJ2jvcOmfsWStcSLOzibS3IpuuXh8AWw91rJ1JpBHOMGHAe2Bnsjec/oDS
	lOu4P1XlVO6FHddXZiG6EWonpJ1mjoP0jBXywMMqtphhoyl1JHk3UAdCleCoCesSrhasdq+BLQB
	/i4d3Us7wox5D7Foz+BmvZu9TuqapbaGS+FCHx+FWF2JunY0z+kn7CEnESFHSGuGscc3DN//5ww
	Wxg3LoHDJbyEVDItI+zUXppZljFk4SwOdwbMpVP/4eRWDJYlIWXOAX+ggeBA1FcccpbGwdFVeXd
	1ZesNT85EnxgG3LVDWTWSyj3qjHPNVSWUDxiaod7vdWsbK2Vv36peQJAzdgg
X-Received: by 2002:a05:6830:4190:b0:7c7:4f2:e15d with SMTP id
 46e09a7af769-7d15a5d41fcmr607640a34.16.1769115825760; Thu, 22 Jan 2026
 13:03:45 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <697274ed.050a0220.706b.0028.GAE@google.com>
In-Reply-To: <697274ed.050a0220.706b.0028.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 22 Jan 2026 22:03:34 +0100
X-Gm-Features: AZwV_QhlWz6XStSIwNZwynRVf92B1am4-1-BXWwnypjWYlh8HMVgIKmFyV7IWEc
Message-ID: <CANp29Y5omOJwnBVqG7ud7UmfLXCrpsZEsS1fccMsm5pq-rUFLg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mptcp: fix race in mptcp_pm_nl_flush_addrs_doit()
To: syzbot ci <syzbot+ci4b2ae12163243e7f@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Jan 22, 2026 at 8:05=E2=80=AFPM syzbot ci
<syzbot+ci4b2ae12163243e7f@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mptcp: fix race in mptcp_pm_nl_flush_addrs_doit()
> https://lore.kernel.org/all/20260122131306.2119853-1-edumazet@google.com
> * [PATCH net] mptcp: fix race in mptcp_pm_nl_flush_addrs_doit()
>
> and found the following issue:
> KASAN: invalid-free in mptcp_pm_nl_flush_addrs_doit
>
> Full report is available here:
> https://ci.syzbot.org/series/84b72a22-ce5b-495e-b999-5f5024f30853
>
> ***
>
> KASAN: invalid-free in mptcp_pm_nl_flush_addrs_doit
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      19e4175e997a5b85eab97d522f00cc99abd1873c
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/62c1e47f-65ca-493d-85bc-91dc46138=
b40/config
> C repro:   https://ci.syzbot.org/findings/7c0d11b6-76a9-444f-a5ae-08095bf=
44247/c_repro
> syz repro: https://ci.syzbot.org/findings/7c0d11b6-76a9-444f-a5ae-08095bf=
44247/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: invalid-free in __mptcp_pm_release_addr_entry net/mptcp/pm_ke=
rnel.c:709 [inline]
> BUG: KASAN: invalid-free in __flush_addrs net/mptcp/pm_kernel.c:1282 [inl=
ine]
> BUG: KASAN: invalid-free in mptcp_pm_nl_flush_addrs_doit+0x9a8/0xaa0 net/=
mptcp/pm_kernel.c:1315
> Free of addr ffff88810b305b40 by task syz.0.17/5989
>
> CPU: 0 UID: 0 PID: 5989 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xba/0x230 mm/kasan/report.c:482
>  kasan_report_invalid_free+0xea/0x110 mm/kasan/report.c:557
>  check_slab_allocation+0xd5/0xf0 mm/kasan/common.c:-1
>  kasan_slab_pre_free include/linux/kasan.h:199 [inline]
>  slab_free_hook mm/slub.c:2485 [inline]
>  slab_free mm/slub.c:6670 [inline]
>  kfree+0x16c/0x650 mm/slub.c:6878
>  __mptcp_pm_release_addr_entry net/mptcp/pm_kernel.c:709 [inline]
>  __flush_addrs net/mptcp/pm_kernel.c:1282 [inline]
>  mptcp_pm_nl_flush_addrs_doit+0x9a8/0xaa0 net/mptcp/pm_kernel.c:1315
>  genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1115
>  genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
>  genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1210
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:742
>  ____sys_sendmsg+0x4d7/0x810 net/socket.c:2592
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
>  __sys_sendmsg net/socket.c:2678 [inline]
>  __do_sys_sendmsg net/socket.c:2683 [inline]
>  __se_sys_sendmsg net/socket.c:2681 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2488d9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc593deda8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f2489015fa0 RCX: 00007f2488d9acb9
> RDX: 0000000000000800 RSI: 0000200000000200 RDI: 0000000000000003
> RBP: 00007f2488e08bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f2489015fac R14: 00007f2489015fa0 R15: 00007f2489015fa0
>  </TASK>
>
> Allocated by task 5944:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
>  kasan_kmalloc include/linux/kasan.h:263 [inline]
>  __do_kmalloc_node mm/slub.c:5657 [inline]
>  __kmalloc_noprof+0x40c/0x7e0 mm/slub.c:5669
>  kmalloc_noprof include/linux/slab.h:961 [inline]
>  kzalloc_noprof include/linux/slab.h:1094 [inline]
>  ops_init+0x7b/0x5c0 net/core/net_namespace.c:127
>  setup_net+0x118/0x340 net/core/net_namespace.c:446
>  copy_net_ns+0x3e2/0x570 net/core/net_namespace.c:581
>  create_new_namespaces+0x3e7/0x6a0 kernel/nsproxy.c:130
>  unshare_nsproxy_namespaces+0x11a/0x160 kernel/nsproxy.c:226
>  ksys_unshare+0x4f4/0x900 kernel/fork.c:3171
>  __do_sys_unshare kernel/fork.c:3242 [inline]
>  __se_sys_unshare kernel/fork.c:3240 [inline]
>  __x64_sys_unshare+0x38/0x50 kernel/fork.c:3240
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88810b305b00
>  which belongs to the cache kmalloc-128 of size 128
> The buggy address is located 64 bytes inside of
>  120-byte region [ffff88810b305b00, ffff88810b305b78)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10b3=
05
> anon flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000000 ffff888100041a00 ffffea00044a5a80 0000000000000005
> raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5279, tgid 5279 (ude=
vd), ts 37034162370, free_ts 37027298103
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x228/0x280 mm/page_alloc.c:1857
>  prep_new_page mm/page_alloc.c:1865 [inline]
>  get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3915
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5210
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
>  alloc_slab_page mm/slub.c:3075 [inline]
>  allocate_slab+0x86/0x3a0 mm/slub.c:3248
>  new_slab mm/slub.c:3302 [inline]
>  ___slab_alloc+0xd82/0x1760 mm/slub.c:4656
>  __slab_alloc+0x65/0x100 mm/slub.c:4779
>  __slab_alloc_node mm/slub.c:4855 [inline]
>  slab_alloc_node mm/slub.c:5251 [inline]
>  __kmalloc_cache_noprof+0x40d/0x6e0 mm/slub.c:5771
>  kmalloc_noprof include/linux/slab.h:957 [inline]
>  kzalloc_noprof include/linux/slab.h:1094 [inline]
>  kernfs_get_open_node fs/kernfs/file.c:543 [inline]
>  kernfs_fop_open+0x7b5/0xca0 fs/kernfs/file.c:718
>  do_dentry_open+0x7ce/0x1420 fs/open.c:962
>  vfs_open+0x3b/0x340 fs/open.c:1094
>  do_open fs/namei.c:4637 [inline]
>  path_openat+0x3486/0x3e20 fs/namei.c:4796
>  do_filp_open+0x22d/0x490 fs/namei.c:4823
>  do_sys_openat2+0x12f/0x220 fs/open.c:1430
>  do_sys_open fs/open.c:1436 [inline]
>  __do_sys_openat fs/open.c:1452 [inline]
>  __se_sys_openat fs/open.c:1447 [inline]
>  __x64_sys_openat+0x138/0x170 fs/open.c:1447
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
> page last free pid 5285 tgid 5285 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1406 [inline]
>  __free_frozen_pages+0xbb0/0xd10 mm/page_alloc.c:2943
>  __slab_free+0x2ce/0x320 mm/slub.c:6004
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4953 [inline]
>  slab_alloc_node mm/slub.c:5263 [inline]
>  kmem_cache_alloc_noprof+0x370/0x6e0 mm/slub.c:5270
>  getname_flags+0xb7/0x540 fs/namei.c:146
>  getname include/linux/fs.h:2498 [inline]
>  __do_sys_unlink fs/namei.c:5483 [inline]
>  __se_sys_unlink fs/namei.c:5481 [inline]
>  __x64_sys_unlink+0x3a/0x50 fs/namei.c:5481
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Memory state around the buggy address:
>  ffff88810b305a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88810b305a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff88810b305b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fc
>                                            ^
>  ffff88810b305b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88810b305c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
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
> [davem@davemloft.net edumazet@google.com eric.dumazet@gmail.com eulgyukim=
@snu.ac.kr fw@strlen.de geliang.tang@linux.dev geliang@kernel.org kuba@kern=
el.org martineau@kernel.org matttbe@kernel.org netdev@vger.kernel.org paben=
i@redhat.com syzbot@syzkaller.appspotmail.com]
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
-upstream-moderation/697274ed.050a0220.706b.0028.GAE%40google.com.
