Received: from mail-ot1-f45.google.com (mail-ot1-f45.google.com [209.85.210.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F25F91DF27F
	for <syzbot@lists.linux.dev>; Sat, 20 Sep 2025 18:33:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758393194; cv=none; b=ohef+8eLv+Icv6J8sYpVH3Ld4NEZXlX+xxWZeXQiggMPYZrcTHjsIPuVZHr3OFGhr8Q7SEFyu26BB49OWIkmhZ18S6NPmGeccfrFQZYZjML0393mADJBPMMuexAa/BEB3MhfWxIT3Y9CA8Ky0OkPN5uQ0gFivGETnCV2YTQtCGg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758393194; c=relaxed/simple;
	bh=FHtZEJaAU7BPV6afWs5uoqFAJi3ga1MOcbCYirNaOCs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lXKcVCkLGU5xsbJaWKLED/JQju5oV0tdzDYDxwY7fiP1qjFVNrRh4c7UmbEGf01o/9Wn2mjhSC1UqqZWuhL/CVcUBRcDcbnqlk/GhWpIbnYhsqe8O9bKXdNTcL+PppZx9V+sFhK+xIdSXj2Ai0DJbAuSqeh7RYBtbpYSeSZj9DE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2eQ6mfGU; arc=none smtp.client-ip=209.85.210.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2eQ6mfGU"
Received: by mail-ot1-f45.google.com with SMTP id 46e09a7af769-74ed00220f6so1327891a34.2
        for <syzbot@lists.linux.dev>; Sat, 20 Sep 2025 11:33:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758393192; x=1758997992; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cSZioW1E9RYFwjVWiINhTYDgVvYw5MAqlKxr/pcirm8=;
        b=2eQ6mfGUbKcxE+M7+CWvAByHf+ncEbJwIDEGIgydiqRinN+6AKkmfoz8SH1bBuhdBp
         peckVf8Bmlpy/fH5JafM2BxxsepfwOKh4MpxUA1YfqvZ+U7JqOmjryLQxI8uPNaYUtOG
         7SJhbgnyuxBMKt+XgTcELUxospFyVe6jJEh/zwP/TfbOhDKH0O9c+S6W+71gc18uu3H5
         1iaRz1J3gMNLa6NQHzAN73fjI4WitWhlpE5iFkst4G4GczBeSAeMl3hYTvuo/1Mr6KjR
         RP0eZFNj5D/RSMTHYsq/BicG3wQ1bdwdVnVAw25VVrrTDRDIK5Ir3PZjebpJLfdbqkHq
         WkYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758393192; x=1758997992;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=cSZioW1E9RYFwjVWiINhTYDgVvYw5MAqlKxr/pcirm8=;
        b=dU0rn0ql8sqtIVHbO13H7jVjfrd5vvPcV4iZTuI4vmran27LG1xm8d4ShEh4XwUMN/
         kmrOOiRvsA7YuSsJkN+XZxz/PwIIq1Eyhk+a+QRp0TO8aWwBofYlRBr/njfImWSqWeIM
         AJhOv9AT7iqU53MvTj4XZlxnBKY/IUlzdhnwHSoYoj2bBxHBNyCQqNnPYxWOGH4Ebb2M
         vq/3cYiFjOk3VGjfn6S0PdCmay/Vf+H9zq2TQGTnyiIVrHO+J6TIY3mPuw4Bd2V2Pcso
         Ea6ov359oh2ciW/gTkAkqam/lLgeDPWBp4/4kPl4Bt5+0GPnG3Kri/z8wr5apYkPgEDL
         nSZA==
X-Forwarded-Encrypted: i=1; AJvYcCWjQ+/dVFDediE0J+K6wffgXPb70LCY+c6CWu0wuNDweBUx/LtQq861e06fdbs4HWG8+ORT/hs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzOCXgqktz8WZqmX8ixw8LM1LurG6kFXN32xuvlO+PfgE/bbiYc
	LX5tN/o8VFygI7N3w7UCi515eUNAu5r1qZEgEOBnbBjBEy4GUNNLbvk31/QEsbUJskcZae0sht+
	KGGp0jQy9yIYH3drn5NrgUVLis+OvTqH8J2m6LT0f
X-Gm-Gg: ASbGncuB7fON/hq2xyjHc9oYWILSB3Nn9pBli0WornV16QjfZk++4ZoajZG9lyyy7zp
	E5Uu75ufQ1bN0giQSVSeikVRBfM6bILC6cNFpD6spWCR6empzcbfNMTKuN7nwzmixj4m4Q3UxLX
	IwqialYF294e4nXgL2bZelsCKUoIMyNYntMzCNZWpmaNx0Z4TkzAaGKjoLEarHW/ucz5j80gI00
	x3MME3hK9341Ihlxg==
X-Google-Smtp-Source: AGHT+IGe+XZEQD7zHAcfIrXOEoTdU6HDOxTDiQFqGddgfwUAHLPEyg5oGAB8sK0R0Ek7F0i3mSm2zDkoEW71/XJECqg=
X-Received: by 2002:a05:6808:4f1f:b0:433:fe9c:686d with SMTP id
 5614622812f47-43d6c18eb0fmr3431328b6e.21.1758393191558; Sat, 20 Sep 2025
 11:33:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68ce9584.050a0220.13cd81.0018.GAE@google.com>
In-Reply-To: <68ce9584.050a0220.13cd81.0018.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 20 Sep 2025 20:33:00 +0200
X-Gm-Features: AS18NWD7wHup7hZ-lKxzZsOnxv02PunjI9YPMhaedRRLDlHh7j8KaFaAvVhgKmY
Message-ID: <CANp29Y5XHhLOdSm=WW=sWUJ3C+t9igQs4oYjZ_YvY_ZenB03YA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: udp: remove busylock and add per NUMA queues
To: syzbot ci <syzbot+ci0a64dcc5738264fe@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Sep 20, 2025 at 1:52=E2=80=AFPM syzbot ci
<syzbot+ci0a64dcc5738264fe@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] udp: remove busylock and add per NUMA queues
> https://lore.kernel.org/all/20250920080227.3674860-1-edumazet@google.com
> * [PATCH v2 net-next] udp: remove busylock and add per NUMA queues
>
> and found the following issue:
> KASAN: slab-use-after-free Read in __udp_enqueue_schedule_skb
>
> Full report is available here:
> https://ci.syzbot.org/series/9921e6c6-67ac-435d-a76a-a9cfb67b2f12
>
> ***
>
> KASAN: slab-use-after-free Read in __udp_enqueue_schedule_skb
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      315f423be0d1ebe720d8fd4fa6bed68586b13d34
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/987bf81f-fa72-4f8b-a27a-db2b99aed=
02b/config
> syz repro: https://ci.syzbot.org/findings/d36fc1b8-fea8-4e40-af0d-515be97=
3a67a/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in instrument_atomic_read include/linux/i=
nstrumented.h:68 [inline]
> BUG: KASAN: slab-use-after-free in atomic_read include/linux/atomic/atomi=
c-instrumented.h:32 [inline]
> BUG: KASAN: slab-use-after-free in __udp_enqueue_schedule_skb+0x15c/0xfe0=
 net/ipv4/udp.c:1717
> Read of size 4 at addr ffff88810d802d08 by task syz.0.120/6361
>
> CPU: 0 UID: 0 PID: 6361 Comm: syz.0.120 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:189
>  instrument_atomic_read include/linux/instrumented.h:68 [inline]
>  atomic_read include/linux/atomic/atomic-instrumented.h:32 [inline]
>  __udp_enqueue_schedule_skb+0x15c/0xfe0 net/ipv4/udp.c:1717
>  __udp_queue_rcv_skb net/ipv4/udp.c:2326 [inline]
>  udp_queue_rcv_one_skb+0xab9/0x19e0 net/ipv4/udp.c:2455
>  __udp4_lib_mcast_deliver+0xc06/0xcf0 net/ipv4/udp.c:2565
>  __udp4_lib_rcv+0x10e2/0x2600 net/ipv4/udp.c:2704
>  ip_protocol_deliver_rcu+0x282/0x440 net/ipv4/ip_input.c:205
>  ip_local_deliver_finish+0x3bb/0x6f0 net/ipv4/ip_input.c:239
>  NF_HOOK+0x30c/0x3a0 include/linux/netfilter.h:318
>  dst_input include/net/dst.h:474 [inline]
>  ip_sublist_rcv_finish+0x221/0x2a0 net/ipv4/ip_input.c:585
>  ip_list_rcv_finish net/ipv4/ip_input.c:629 [inline]
>  ip_sublist_rcv+0x5b1/0xa10 net/ipv4/ip_input.c:645
>  ip_list_rcv+0x3e2/0x430 net/ipv4/ip_input.c:679
>  __netif_receive_skb_list_ptype net/core/dev.c:6115 [inline]
>  __netif_receive_skb_list_core+0x7d2/0x800 net/core/dev.c:6162
>  __netif_receive_skb_list net/core/dev.c:6214 [inline]
>  netif_receive_skb_list_internal+0x96f/0xcb0 net/core/dev.c:6305
>  netif_receive_skb_list+0x54/0x450 net/core/dev.c:6357
>  xdp_recv_frames net/bpf/test_run.c:280 [inline]
>  xdp_test_run_batch net/bpf/test_run.c:361 [inline]
>  bpf_test_run_xdp_live+0x1786/0x1b10 net/bpf/test_run.c:390
>  bpf_prog_test_run_xdp+0x713/0x1000 net/bpf/test_run.c:1322
>  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4590
>  __sys_bpf+0x581/0x870 kernel/bpf/syscall.c:6047
>  __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f10d458eba9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f10d54e4038 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f10d47d5fa0 RCX: 00007f10d458eba9
> RDX: 0000000000000048 RSI: 0000200000000600 RDI: 000000000000000a
> RBP: 00007f10d4611e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f10d47d6038 R14: 00007f10d47d5fa0 R15: 00007ffd5c7da268
>  </TASK>
>
> Allocated by task 6361:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
>  poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:405
>  kasan_kmalloc include/linux/kasan.h:260 [inline]
>  __do_kmalloc_node mm/slub.c:4376 [inline]
>  __kmalloc_noprof+0x27a/0x4f0 mm/slub.c:4388
>  kmalloc_noprof include/linux/slab.h:909 [inline]
>  kmalloc_array_noprof include/linux/slab.h:948 [inline]
>  udp_lib_init_sock include/net/udp.h:297 [inline]
>  udpv6_init_sock+0x198/0x3b0 net/ipv6/udp.c:70
>  inet6_create+0xef4/0x1260 net/ipv6/af_inet6.c:259
>  __sock_create+0x4b3/0x9f0 net/socket.c:1589
>  sock_create net/socket.c:1647 [inline]
>  __sys_socket_create net/socket.c:1684 [inline]
>  __sys_socket+0xd7/0x1b0 net/socket.c:1731
>  __do_sys_socket net/socket.c:1745 [inline]
>  __se_sys_socket net/socket.c:1743 [inline]
>  __x64_sys_socket+0x7a/0x90 net/socket.c:1743
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 6358:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:576
>  poison_slab_object mm/kasan/common.c:243 [inline]
>  __kasan_slab_free+0x5b/0x80 mm/kasan/common.c:275
>  kasan_slab_free include/linux/kasan.h:233 [inline]
>  slab_free_hook mm/slub.c:2422 [inline]
>  slab_free mm/slub.c:4695 [inline]
>  kfree+0x18e/0x440 mm/slub.c:4894
>  sk_common_release+0x75/0x310 net/core/sock.c:3919
>  inet_release+0x144/0x190 net/ipv4/af_inet.c:437
>  __sock_release net/socket.c:649 [inline]
>  sock_close+0xc3/0x240 net/socket.c:1439
>  __fput+0x44c/0xa70 fs/file_table.c:468
>  task_work_run+0x1d4/0x260 kernel/task_work.c:227
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
>  exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
>  do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88810d802d00
>  which belongs to the cache kmalloc-128 of size 128
> The buggy address is located 8 bytes inside of
>  freed 128-byte region [ffff88810d802d00, ffff88810d802d80)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10d8=
02
> anon flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 057ff00000000000 ffff88801a441a00 ffffea0004451300 0000000000000005
> raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x252800=
(GFP_NOWAIT|__GFP_NORETRY|__GFP_COMP|__GFP_THISNODE), pid 5962, tgid 5962 (=
syz-executor), ts 86250634562, free_ts 86224202724
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
>  prep_new_page mm/page_alloc.c:1859 [inline]
>  get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
>  alloc_slab_page mm/slub.c:2494 [inline]
>  allocate_slab+0x65/0x370 mm/slub.c:2660
>  new_slab mm/slub.c:2714 [inline]
>  ___slab_alloc+0xbeb/0x1420 mm/slub.c:3901
>  __slab_alloc mm/slub.c:3992 [inline]
>  __slab_alloc_node mm/slub.c:4067 [inline]
>  slab_alloc_node mm/slub.c:4228 [inline]
>  __do_kmalloc_node mm/slub.c:4375 [inline]
>  __kmalloc_node_noprof+0x2fd/0x4e0 mm/slub.c:4382
>  kmalloc_array_node_noprof include/linux/slab.h:1020 [inline]
>  alloc_slab_obj_exts+0x39/0xa0 mm/slub.c:2033
>  __memcg_slab_post_alloc_hook+0x31e/0x7f0 mm/memcontrol.c:3174
>  memcg_slab_post_alloc_hook mm/slub.c:2221 [inline]
>  slab_post_alloc_hook mm/slub.c:4201 [inline]
>  slab_alloc_node mm/slub.c:4240 [inline]
>  kmem_cache_alloc_noprof+0x2bf/0x3c0 mm/slub.c:4247
>  alloc_empty_file+0x55/0x1d0 fs/file_table.c:237
>  alloc_file fs/file_table.c:354 [inline]
>  alloc_file_pseudo+0x13d/0x210 fs/file_table.c:383
>  sock_alloc_file+0xb8/0x2e0 net/socket.c:470
>  sock_map_fd net/socket.c:500 [inline]
>  __sys_socket+0x13d/0x1b0 net/socket.c:1740
>  __do_sys_socket net/socket.c:1745 [inline]
>  __se_sys_socket net/socket.c:1743 [inline]
>  __x64_sys_socket+0x7a/0x90 net/socket.c:1743
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> page last free pid 27 tgid 27 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  free_pages_prepare mm/page_alloc.c:1395 [inline]
>  __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2895
>  pagetable_free include/linux/mm.h:2898 [inline]
>  pagetable_dtor_free include/linux/mm.h:2996 [inline]
>  __tlb_remove_table+0x2d2/0x3b0 include/asm-generic/tlb.h:220
>  __tlb_remove_table_free mm/mmu_gather.c:227 [inline]
>  tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:290
>  rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>  rcu_core+0xcab/0x1770 kernel/rcu/tree.c:2861
>  handle_softirqs+0x286/0x870 kernel/softirq.c:579
>  do_softirq+0xec/0x180 kernel/softirq.c:480
>  __local_bh_enable_ip+0x17d/0x1c0 kernel/softirq.c:407
>  spin_unlock_bh include/linux/spinlock.h:396 [inline]
>  nsim_dev_trap_report drivers/net/netdevsim/dev.c:835 [inline]
>  nsim_dev_trap_report_work+0x7c7/0xb80 drivers/net/netdevsim/dev.c:866
>  process_one_work kernel/workqueue.c:3236 [inline]
>  process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3319
>  worker_thread+0x8a0/0xda0 kernel/workqueue.c:3400
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x439/0x7d0 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> Memory state around the buggy address:
>  ffff88810d802c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff88810d802c80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
> >ffff88810d802d00: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                       ^
>  ffff88810d802d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>  ffff88810d802e00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
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
> [davem@davemloft.net edumazet@google.com eric.dumazet@gmail.com horms@ker=
nel.org kuba@kernel.org kuniyu@google.com netdev@vger.kernel.org pabeni@red=
hat.com willemb@google.com]
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
-upstream-moderation/68ce9584.050a0220.13cd81.0018.GAE%40google.com.
