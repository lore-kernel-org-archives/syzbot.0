Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FDD9270542
	for <syzbot@lists.linux.dev>; Fri, 21 Nov 2025 07:00:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763708458; cv=none; b=UkBoD3mAIrp/VadGuduxgmThLw1j4EFgM/hRygtoXcghNkAn8c1Sg1UAS0dKKoMVAHUKv0hxrKeb9iQ+NVUhNDe58Ko63V9b2+AtHLVXuFADxyD3NYx0KYFcpw7/Y2ObIbvGP43KBnR2VR2WY4e8iHDkAm2n+18Afltb6+W+nAc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763708458; c=relaxed/simple;
	bh=z+CtAu/koHcIWT7NXyhnOcmjpjFWvef4IEIQa4E16uc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=AFYQDW05AJdgDCyCoxYx/uY/fGyr7cmJTUUqWFyx743w3iO+hrdcVQiMhiD37SsTk8T8xeUYZZ5F6R4VuPxzcOUbGyI3U3uMmbmXFkB90wM3vsmEBhM7KRgBbf0ibNwrN8AO8FnHYbjHserRGlYQdFihdX54NVWJG0FUkcgRP+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-433770ba913so21246975ab.1
        for <syzbot@lists.linux.dev>; Thu, 20 Nov 2025 23:00:55 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763708454; x=1764313254;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=96Q+UwGkGIC2Gn36b9QbecwEGXK9x7Szz4RtrJUmc0I=;
        b=UxnYxQm6b5dBCRW6cczMi4QdbxWG3m21mQhH/5KmpsRF2mZXMcuJf+apP0hGD1G5E1
         0rqeFyYTH8p39uw4c/wNB65FJHrcVSDFi0ZvYqKwCplbiE68U7lP6r5XxZVTNrvevJZ3
         3SaAPQQdwTYcaZpqCY6LUn7J3ZMyYqUoyuANivosJ/JPuVNVX211rduUZ5Ru/IN8uZXG
         RPXJEad0ojvC3OhY07L2SVC1fs4rGYLQAxioczgdgoC76SAmDb0rHjlxBfC4sxylBin+
         7b9u8lXyVwahOtwNh++BNxirwyqichYlmibSRrbxpDW4k/FFXu6JDHvHtsU0FHHz3TJr
         j0Sg==
X-Gm-Message-State: AOJu0YxOHYPSJXUp+t5LQtBA8doWi8lRQ5ltyE3KSufTKBoYTUpHQNHY
	jb2MW9mAB0YfC5OnAvYouTFTnnSlVIWyPXqgdp3yOenv12mh8nfm6Id+f1vDAFlCU5/9zYtJjEq
	Nlb0bJGPdn6ST7GjzZnUQwLT/OeufCmH796Qhs0cali1up50XAn120VH5z9k=
X-Google-Smtp-Source: AGHT+IE1W8n3r4q5oqA64jBIaki2hr1/mwwZ5+Nc5rCN8sdwFxQeYRiV463AUmzirbouUhRUJDt0VfBI00il6j/BSH03oxcJnfri
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fe1:b0:433:3048:55ec with SMTP id
 e9e14a558f8ab-435b8eb4403mr11438505ab.27.1763708454602; Thu, 20 Nov 2025
 23:00:54 -0800 (PST)
Date: Thu, 20 Nov 2025 23:00:54 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69200e26.a70a0220.2ea503.0044.GAE@google.com>
Subject: [moderation/CI] Re: bpf: Fix FIONREAD and copied_seq issues
From: syzbot ci <syzbot+cie67fd609419afd6f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] bpf: Fix FIONREAD and copied_seq issues
https://lore.kernel.org/all/20251121030013.60133-1-jiayuan.chen@linux.dev
* [PATCH bpf-next v2 1/3] bpf, sockmap: Fix incorrect copied_seq calculatio=
n
* [PATCH bpf-next v2 2/3] bpf, sockmap: Fix FIONREAD for sockmap
* [PATCH bpf-next v2 3/3] bpf, selftest: Add tests for FIONREAD and copied_=
seq

and found the following issues:
* KASAN: slab-out-of-bounds Read in tcp_ioctl
* KASAN: slab-use-after-free Read in tcp_ioctl
* SYZFAIL: failed to recv rpc
* WARNING in sk_psock_destroy

Full report is available here:
https://ci.syzbot.org/series/2dc8b7c6-6074-4e9e-a56e-dc5f34e678db

***

KASAN: slab-out-of-bounds Read in tcp_ioctl

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      4722981cca373a338bbcf3a93ecf7144a892b03b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/ffa9b2b0-ceb4-4d19-bc45-58475d561b3=
b/config
syz repro: https://ci.syzbot.org/findings/5fbc614a-9eb9-426b-96c5-1f69b6874=
e56/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in tcp_ioctl+0x673/0x860 net/ipv4/tcp.c:659
Read of size 2 at addr ffff8881114d5df6 by task syz.2.19/6006

CPU: 0 UID: 0 PID: 6006 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 tcp_ioctl+0x673/0x860 net/ipv4/tcp.c:659
 sock_ioctl_out net/core/sock.c:4392 [inline]
 sk_ioctl+0x3c7/0x600 net/core/sock.c:4420
 inet_ioctl+0x416/0x4c0 net/ipv4/af_inet.c:1007
 sock_do_ioctl+0xdc/0x300 net/socket.c:1254
 sock_ioctl+0x576/0x790 net/socket.c:1375
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f472558f6c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f472647a038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f47257e5fa0 RCX: 00007f472558f6c9
RDX: 0000000000000000 RSI: 0000000000008905 RDI: 0000000000000004
RBP: 00007f4725611f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f47257e6038 R14: 00007f47257e5fa0 R15: 00007ffcbb3f8478
 </TASK>

The buggy address belongs to the object at ffff8881114d5d80
 which belongs to the cache UDP of size 1984
The buggy address is located 118 bytes inside of
 allocated 1984-byte region [ffff8881114d5d80, ffff8881114d6540)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1114d0
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff88811112a501
flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 017ff00000000040 ffff888105697000 dead000000000122 0000000000000000
raw: 0000000000000000 00000000800f000f 00000000f5000000 ffff88811112a501
head: 017ff00000000040 ffff888105697000 dead000000000122 0000000000000000
head: 0000000000000000 00000000800f000f 00000000f5000000 ffff88811112a501
head: 017ff00000000003 ffffea0004453401 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__=
GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pi=
d 5847, tgid 5847 (syz-executor), ts 60144423433, free_ts 60089454561
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1850
 prep_new_page mm/page_alloc.c:1858 [inline]
 get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3884
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5183
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:3059 [inline]
 allocate_slab+0x96/0x350 mm/slub.c:3232
 new_slab mm/slub.c:3286 [inline]
 ___slab_alloc+0xf56/0x1990 mm/slub.c:4655
 __slab_alloc+0x65/0x100 mm/slub.c:4778
 __slab_alloc_node mm/slub.c:4854 [inline]
 slab_alloc_node mm/slub.c:5276 [inline]
 kmem_cache_alloc_noprof+0x3f9/0x6e0 mm/slub.c:5295
 sk_prot_alloc+0x57/0x220 net/core/sock.c:2233
 sk_alloc+0x3a/0x370 net/core/sock.c:2295
 inet_create+0x7a0/0x1000 net/ipv4/af_inet.c:328
 __sock_create+0x4b3/0x9f0 net/socket.c:1605
 udp_sock_create4+0xbe/0x4b0 net/ipv4/udp_tunnel_core.c:19
 udp_sock_create include/net/udp_tunnel.h:59 [inline]
 wg_socket_init+0x4e5/0xa60 drivers/net/wireguard/socket.c:387
 wg_open+0x24f/0x420 drivers/net/wireguard/device.c:51
 __dev_open+0x470/0x880 net/core/dev.c:1682
page last free pid 5847 tgid 5847 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1394 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2906
 discard_slab mm/slub.c:3330 [inline]
 __put_partials+0x146/0x170 mm/slub.c:3876
 put_cpu_partial+0x1f2/0x2e0 mm/slub.c:3951
 __slab_free+0x2b9/0x390 mm/slub.c:5929
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:352
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4978 [inline]
 slab_alloc_node mm/slub.c:5288 [inline]
 __do_kmalloc_node mm/slub.c:5649 [inline]
 __kmalloc_noprof+0x3c3/0x7f0 mm/slub.c:5662
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 fib_create_info+0x172d/0x3210 net/ipv4/fib_semantics.c:1402
 fib_table_insert+0xc6/0x1b50 net/ipv4/fib_trie.c:1212
 fib_magic+0x2c4/0x390 net/ipv4/fib_frontend.c:1134
 fib_add_ifaddr+0x144/0x5f0 net/ipv4/fib_frontend.c:1156
 fib_netdev_event+0x382/0x490 net/ipv4/fib_frontend.c:1516
 notifier_call_chain+0x1b6/0x3e0 kernel/notifier.c:85
 call_netdevice_notifiers_extack net/core/dev.c:2267 [inline]
 call_netdevice_notifiers net/core/dev.c:2281 [inline]
 __dev_notify_flags+0x18d/0x2e0 net/core/dev.c:-1
 netif_change_flags+0xe8/0x1a0 net/core/dev.c:9705

Memory state around the buggy address:
 ffff8881114d5c80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff8881114d5d00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8881114d5d80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                                             ^
 ffff8881114d5e00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8881114d5e80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

KASAN: slab-use-after-free Read in tcp_ioctl

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      4722981cca373a338bbcf3a93ecf7144a892b03b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/ffa9b2b0-ceb4-4d19-bc45-58475d561b3=
b/config
C repro:   https://ci.syzbot.org/findings/956fd3c8-f06a-44eb-b0ff-510a6c8b3=
78d/c_repro
syz repro: https://ci.syzbot.org/findings/956fd3c8-f06a-44eb-b0ff-510a6c8b3=
78d/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-use-after-free in tcp_ioctl+0x673/0x860 net/ipv4/tcp.c:659
Read of size 2 at addr ffff888101fe3bf6 by task syz.0.17/5959

CPU: 1 UID: 0 PID: 5959 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 tcp_ioctl+0x673/0x860 net/ipv4/tcp.c:659
 sock_ioctl_out net/core/sock.c:4392 [inline]
 sk_ioctl+0x3c7/0x600 net/core/sock.c:4420
 inet_ioctl+0x416/0x4c0 net/ipv4/af_inet.c:1007
 sock_do_ioctl+0xdc/0x300 net/socket.c:1254
 sock_ioctl+0x576/0x790 net/socket.c:1375
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a1458f6c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4a1545b038 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f4a147e5fa0 RCX: 00007f4a1458f6c9
RDX: 0000000000000000 RSI: 0000000000008905 RDI: 0000000000000004
RBP: 00007f4a14611f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4a147e6038 R14: 00007f4a147e5fa0 R15: 00007ffef33173a8
 </TASK>

Allocated by task 5926:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 unpoison_slab_object mm/kasan/common.c:342 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:368
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4978 [inline]
 slab_alloc_node mm/slub.c:5288 [inline]
 kmem_cache_alloc_noprof+0x367/0x6e0 mm/slub.c:5295
 sk_prot_alloc+0x57/0x220 net/core/sock.c:2233
 sk_alloc+0x3a/0x370 net/core/sock.c:2295
 inet_create+0x7a0/0x1000 net/ipv4/af_inet.c:328
 __sock_create+0x4b3/0x9f0 net/socket.c:1605
 sock_create net/socket.c:1663 [inline]
 __sys_socket_create net/socket.c:1700 [inline]
 __sys_socket+0xd7/0x1b0 net/socket.c:1747
 __do_sys_socket net/socket.c:1761 [inline]
 __se_sys_socket net/socket.c:1759 [inline]
 __x64_sys_socket+0x7a/0x90 net/socket.c:1759
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5926:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 __kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:587
 kasan_save_free_info mm/kasan/kasan.h:406 [inline]
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:234 [inline]
 slab_free_hook mm/slub.c:2543 [inline]
 slab_free mm/slub.c:6642 [inline]
 kmem_cache_free+0x19b/0x690 mm/slub.c:6752
 sk_prot_free net/core/sock.c:2276 [inline]
 __sk_destruct+0x4d2/0x660 net/core/sock.c:2373
 inet_release+0x144/0x190 net/ipv4/af_inet.c:437
 __sock_release net/socket.c:662 [inline]
 sock_close+0xc3/0x240 net/socket.c:1455
 __fput+0x44c/0xa70 fs/file_table.c:468
 fput_close_sync+0x119/0x200 fs/file_table.c:573
 __do_sys_close fs/open.c:1589 [inline]
 __se_sys_close fs/open.c:1574 [inline]
 __x64_sys_close+0x7f/0x110 fs/open.c:1574
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888101fe3b80
 which belongs to the cache UDP of size 1984
The buggy address is located 118 bytes inside of
 freed 1984-byte region [ffff888101fe3b80, ffff888101fe4340)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x101fe0
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff8881086b4301
anon flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 017ff00000000040 ffff888160ef5b40 0000000000000000 0000000000000001
raw: 0000000000000000 00000000800f000f 00000000f5000000 ffff8881086b4301
head: 017ff00000000040 ffff888160ef5b40 0000000000000000 0000000000000001
head: 0000000000000000 00000000800f000f 00000000f5000000 ffff8881086b4301
head: 017ff00000000003 ffffea000407f801 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__=
GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pi=
d 1, tgid 1 (swapper/0), ts 3581320107, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1850
 prep_new_page mm/page_alloc.c:1858 [inline]
 get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3884
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5183
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:3059 [inline]
 allocate_slab+0x96/0x350 mm/slub.c:3232
 new_slab mm/slub.c:3286 [inline]
 ___slab_alloc+0xf56/0x1990 mm/slub.c:4655
 __slab_alloc+0x65/0x100 mm/slub.c:4778
 __slab_alloc_node mm/slub.c:4854 [inline]
 slab_alloc_node mm/slub.c:5276 [inline]
 kmem_cache_alloc_noprof+0x3f9/0x6e0 mm/slub.c:5295
 sk_prot_alloc+0x57/0x220 net/core/sock.c:2233
 sk_alloc+0x3a/0x370 net/core/sock.c:2295
 inet_create+0x7a0/0x1000 net/ipv4/af_inet.c:328
 __sock_create+0x4b3/0x9f0 net/socket.c:1605
 inet_ctl_sock_create+0x9a/0x220 net/ipv4/af_inet.c:1632
 igmp_net_init+0xb9/0x150 net/ipv4/igmp.c:3125
 ops_init+0x35c/0x5c0 net/core/net_namespace.c:137
 __register_pernet_operations net/core/net_namespace.c:1314 [inline]
 register_pernet_operations+0x336/0x800 net/core/net_namespace.c:1391
page_owner free stack trace missing

Memory state around the buggy address:
 ffff888101fe3a80: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff888101fe3b00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff888101fe3b80: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                                             ^
 ffff888101fe3c00: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
 ffff888101fe3c80: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

SYZFAIL: failed to recv rpc

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      4722981cca373a338bbcf3a93ecf7144a892b03b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/ffa9b2b0-ceb4-4d19-bc45-58475d561b3=
b/config
C repro:   https://ci.syzbot.org/findings/f3ffc26d-6509-4e92-92bd-bfa118ae7=
2e6/c_repro
syz repro: https://ci.syzbot.org/findings/f3ffc26d-6509-4e92-92bd-bfa118ae7=
2e6/syz_repro

SYZFAIL: failed to recv rpc
fd=3D3 want=3D4 recv=3D0 n=3D0 (errno 9: Bad file descriptor)


***

WARNING in sk_psock_destroy

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      4722981cca373a338bbcf3a93ecf7144a892b03b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/ffa9b2b0-ceb4-4d19-bc45-58475d561b3=
b/config
C repro:   https://ci.syzbot.org/findings/a13957c4-d51a-4472-ab31-37d57484d=
32e/c_repro
syz repro: https://ci.syzbot.org/findings/a13957c4-d51a-4472-ab31-37d57484d=
32e/syz_repro

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5871 at net/core/skmsg.c:828 __sk_psock_purge_ingress_=
msg net/core/skmsg.c:828 [inline]
WARNING: CPU: 0 PID: 5871 at net/core/skmsg.c:828 __sk_psock_zap_ingress ne=
t/core/skmsg.c:839 [inline]
WARNING: CPU: 0 PID: 5871 at net/core/skmsg.c:828 sk_psock_destroy+0xa24/0x=
aa0 net/core/skmsg.c:871
Modules linked in:
CPU: 0 UID: 0 PID: 5871 Comm: kworker/0:4 Not tainted syzkaller #0 PREEMPT(=
full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Workqueue: events sk_psock_destroy
RIP: 0010:__sk_psock_purge_ingress_msg net/core/skmsg.c:828 [inline]
RIP: 0010:__sk_psock_zap_ingress net/core/skmsg.c:839 [inline]
RIP: 0010:sk_psock_destroy+0xa24/0xaa0 net/core/skmsg.c:871
Code: e8 51 78 7c f8 85 ed 7e 29 e8 08 74 7c f8 48 89 df 48 83 c4 38 5b 41 =
5c 41 5d 41 5e 41 5f 5d e9 32 e7 d6 f8 e8 ed 73 7c f8 90 <0f> 0b 90 e9 3f f=
b ff ff e8 df 73 7c f8 4c 89 f7 be 03 00 00 00 e8
RSP: 0018:ffffc900044679f0 EFLAGS: 00010293
RAX: ffffffff894392d3 RBX: dffffc0000000000 RCX: ffff88810f218000
RDX: 0000000000000000 RSI: 0000000000022fe0 RDI: 0000000000000000
RBP: ffff88810ba8b000 R08: ffffffff8f7cee77 R09: 1ffffffff1ef9dce
R10: dffffc0000000000 R11: fffffbfff1ef9dcf R12: ffff88810ba890c0
R13: dead000000000100 R14: 0000000000022fe0 R15: ffff88810ba890c0
FS:  0000000000000000(0000) GS:ffff88818eb38000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c0002a58f8 CR3: 000000000dd38000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 process_one_work kernel/workqueue.c:3263 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3346
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3427
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrii@kernel.org ast@kernel.org bpf@vger.kernel.org cong.wang@bytedance.c=
om daniel@iogearbox.net davem@davemloft.net dsahern@kernel.org eddyz87@gmai=
l.com edumazet@google.com haoluo@google.com horms@kernel.org jakub@cloudfla=
re.com jiayuan.chen@linux.dev john.fastabend@gmail.com jolsa@kernel.org kps=
ingh@kernel.org kuba@kernel.org kuniyu@google.com linux-kernel@vger.kernel.=
org linux-kselftest@vger.kernel.org martin.lau@linux.dev mhal@rbox.co ncard=
well@google.com netdev@vger.kernel.org pabeni@redhat.com sdf@fomichev.me sg=
arzare@redhat.com shuah@kernel.org song@kernel.org yonghong.song@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

