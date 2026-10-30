Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793391241;
	b=S1DXp1ThqY+02B+5lr4LVDRkAxkA2fZn1fNUjc4YbUw9KAi2vblONNCdeKQC/NkQ/9NJ
	 VRZ4ZUmhayEs5dJa3BndBaauGluRMczioaHExHQqQ/xo5uFH/u8x/QW5FEP0CHYBKhldN
	 zWVpG4SIiNRhOVMp+yvmmym6J13CS7jDp3CyrK0BDTJOijfXYTsOtlw2Pn1aiScikNBmX
	 eBmy+6r3ntK6qAmUa0JbN13OFf7YpQOuTxWNE0FCEN/KTq7uOpEqKeXPd4OyBC3vv5gra
	 J8VfJBzYfb/HT48HGw08KErGAF8oufpuWugnHorY8XwOyKm3Xt9HTOKyHsGINGj8XTQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793391241;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=lMB9zcify57gjB/sJxbh4dzp0JfHp2InJCKmZGnUHJo=;
	b=MIsSP481ktiabeNcTOeZyOJHBDXFL6kjwVAGL4UupKGtxeBgkjKI0+Wc6C0UVyPgNHf/
	 p1f789ex5c4aGACTl6McMS+6e1NKVf5zorh/6J6M33txNhJq3qfxEjyqW9cymUevfNN7g
	 E54LVcNwshpawaJ5XIbjkVR0xCR00dH+yLylV4VSoDQT0ktwk0LAKwD/aaOMzs7KVnk9X
	 jhsuWI+niczC16gTCfdbz2wuD2dTOASfpcdGrw3Z9hSaXfypykuLrT8kafPTYVp5P4mnG
	 DEFXTRch863RXoZBZMOSCA0DKlej3s2v3ZkVjgujF6hzyVheqXnscE+eIIBAesycd5Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.70
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3FD7606A31A
	for <syzbot@lists.linux.dev>; Fri, 30 Oct 2026 20:14:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3FD7606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-823d73ffca1so1677382a34.2
        for <syzbot@lists.linux.dev>; Fri, 30 Oct 2026 13:14:00 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793391240; x=1793996040;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lMB9zcify57gjB/sJxbh4dzp0JfHp2InJCKmZGnUHJo=;
        b=09Msw+Z4+VGbe/k6L/2RCQswti1O4DM+EU1oOCv+dTeTV3CX8D0EFTZZZvrBDEYPAJ
         8y/QiWBIlS24prt7l9NSfbxLM0HbStp61L2bCASiIbyKFSGbSBvi8zxnMtqIrmu5v9Nq
         Q/BrA8r1sg5zs90q1Hzb8lyVBIwW0j9eCI9m8e+QnlImN8UcBGFTH05zf6M02uQDDmlt
         dkGWlcrh/KESsIZDnVY9kJ+D9WItnh6p6U2nu2zEtXxk2xWvI5pztxjV3330VnMhXnun
         oNAC15uMUBbwG3uh5t4jtDQfX7Quo3U3BB+jFwUTp3W52iOAlSIQkMrYpFNlprEle+cZ
         HvpQ==
X-Gm-Message-State: AFq9FYLexfJIXX2n//hou6Xu6dQsgShSiaoIC9m9MD4li31cF6TKH7nZ
	65c08V1ilkYMqlXLwsdqVlV3/ETweM4SBiyW4QW6yDXU4w+OB6QgOuCJAoTAdrMfQhNwRgZcZyK
	ynOw0iEHvX/cTOiFqq+d5bz28QFIy4/CamrGUlP3QACOiYaIVAt1eYMFEUu4=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a1f:b0:53a:ad3c:17aa with SMTP id
 5614622812f47-5640de4a41dmr2622049b6e.55.1793391239809; Fri, 30 Oct 2026
 13:13:59 -0700 (PDT)
Date: Fri, 30 Oct 2026 13:13:59 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae4fa87.88e51036.1515fd.0000.GAE@google.com>
Subject: [moderation/CI] Re: kcm: reject attaching sockets with a ULP, and TLS
 on KCM sockets
From: syzbot ci <syzbot+ci429596586d55e106@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v4] kcm: reject attaching sockets with a ULP, and TLS on KCM sockets
https://lore.kernel.org/all/20261029203428.3057054-1-rjethwani@purestorage.com
* [PATCH net v4] kcm: reject attaching sockets with a ULP, and TLS on KCM sockets

and found the following issue:
KASAN: slab-out-of-bounds Write in kcm_ioctl

Full report is available here:
https://ci.syzbot.org/series/8bb553bd-8792-4a67-b142-8c396f2f2594

***

KASAN: slab-out-of-bounds Write in kcm_ioctl

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      5838f10563d58afca6711edb5e4eda968ca181d9
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/371e9558-3281-4ec8-8935-9d7fa1e94ef9/config
syz repro: https://ci.syzbot.org/findings/b6f85fa5-eb30-4533-93b3-5c754fac4e45/syz_repro

==================================================================
BUG: KASAN: slab-out-of-bounds in kcm_attach net/kcm/kcmsock.c:1324 [inline]
BUG: KASAN: slab-out-of-bounds in kcm_attach_ioctl net/kcm/kcmsock.c:1376 [inline]
BUG: KASAN: slab-out-of-bounds in kcm_ioctl+0xced/0x1140 net/kcm/kcmsock.c:1583
Write of size 8 at addr ffff888113f70810 by task syz.1.18/5902

CPU: 0 UID: 0 PID: 5902 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 kcm_attach net/kcm/kcmsock.c:1324 [inline]
 kcm_attach_ioctl net/kcm/kcmsock.c:1376 [inline]
 kcm_ioctl+0xced/0x1140 net/kcm/kcmsock.c:1583
 sock_do_ioctl+0x101/0x320 net/socket.c:1328
 sock_ioctl+0x57a/0x7e0 net/socket.c:1449
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f96df39f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f96e01fe028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00007f96df625fa0 RCX: 00007f96df39f559
RDX: 0000200000003880 RSI: 00000000000089e0 RDI: 0000000000000004
RBP: 00007f96df436b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f96df626038 R14: 00007f96df625fa0 R15: 00007ffc97de2138
 </TASK>

Allocated by task 5902:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 unpoison_slab_object mm/kasan/common.c:351 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:377
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4720 [inline]
 slab_alloc_node mm/slub.c:5033 [inline]
 kmem_cache_alloc_noprof+0x2b4/0x600 mm/slub.c:5047
 sk_prot_alloc+0x57/0x210 net/core/sock.c:2275
 sk_alloc+0x3a/0x390 net/core/sock.c:2337
 inet6_create+0x81a/0x1270 net/ipv6/af_inet6.c:178
 __sock_create+0x4b5/0xac0 net/socket.c:1679
 sock_create net/socket.c:1737 [inline]
 __sys_socket_create net/socket.c:1774 [inline]
 __sys_socket+0xd6/0x1b0 net/socket.c:1821
 __do_sys_socket net/socket.c:1835 [inline]
 __se_sys_socket net/socket.c:1833 [inline]
 __x64_sys_socket+0x7a/0x90 net/socket.c:1833
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888113f70000
 which belongs to the cache RAWv6 of size 1984
The buggy address is located 80 bytes to the right of
 allocated 1984-byte region [ffff888113f70000, ffff888113f707c0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888113f73300 pfn:0x113f70
head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff888113f77f81
flags: 0x17ff00000000240(workingset|head|node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000240 ffff888167e03500 ffffea000442be10 ffff888104ae4948
raw: ffff888113f73300 00000002000f0006 00000000f5000000 ffff888113f77f81
head: 017ff00000000240 ffff888167e03500 ffffea000442be10 ffff888104ae4948
head: ffff888113f73300 00000002000f0006 00000000f5000000 ffff888113f77f81
head: 017ff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5785, tgid 5785 (syz-executor), ts 69263183053
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1856
 prep_new_page mm/page_alloc.c:1864 [inline]
 get_page_from_freelist+0x220f/0x2280 mm/page_alloc.c:3935
 __alloc_frozen_pages_noprof+0x1fe/0x410 mm/page_alloc.c:5444
 alloc_slab_page mm/slub.c:3384 [inline]
 allocate_slab+0x7d/0x5e0 mm/slub.c:3499
 new_slab mm/slub.c:3550 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7539
 refill_sheaf mm/slub.c:2917 [inline]
 __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4811
 alloc_from_pcs mm/slub.c:4887 [inline]
 slab_alloc_node mm/slub.c:5021 [inline]
 kmem_cache_alloc_noprof+0x394/0x600 mm/slub.c:5047
 sk_prot_alloc+0x57/0x210 net/core/sock.c:2275
 sk_alloc+0x3a/0x390 net/core/sock.c:2337
 inet6_create+0x81a/0x1270 net/ipv6/af_inet6.c:178
 __sock_create+0x4b5/0xac0 net/socket.c:1679
 inet_ctl_sock_create+0xa2/0x220 net/ipv4/af_inet.c:1640
 tcpv6_net_init+0x34/0xb0 net/ipv6/tcp_ipv6.c:2348
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:443
 copy_net_ns+0x536/0x770 net/core/net_namespace.c:582
page last free pid 5803 tgid 5803 ts 69160417533 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1403 [inline]
 __free_frozen_pages+0xc97/0xd90 mm/page_alloc.c:2954
 __slab_free+0x269/0x2c0 mm/slub.c:5926
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:361
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4720 [inline]
 slab_alloc_node mm/slub.c:5033 [inline]
 kmem_cache_alloc_noprof+0x2b4/0x600 mm/slub.c:5047
 ptlock_alloc mm/memory.c:7769 [inline]
 ptlock_init include/linux/mm.h:4039 [inline]
 pmd_ptlock_init include/linux/mm.h:4151 [inline]
 pagetable_pmd_ctor include/linux/mm.h:4179 [inline]
 pmd_alloc_one_noprof include/asm-generic/pgalloc.h:146 [inline]
 __pmd_alloc+0xc1/0x5c0 mm/memory.c:7029
 pmd_alloc include/linux/mm.h:3865 [inline]
 __handle_mm_fault mm/memory.c:6725 [inline]
 handle_mm_fault+0xe9d/0x3750 mm/memory.c:6943
 do_user_addr_fault+0x7f6/0x1480 arch/x86/mm/fault.c:1394
 handle_page_fault arch/x86/mm/fault.c:1483 [inline]
 exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
 asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595

Memory state around the buggy address:
 ffff888113f70700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888113f70780: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
>ffff888113f70800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                         ^
 ffff888113f70880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888113f70900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[davem@davemloft.net edumazet@kernel.org hare@suse.de horms@kernel.org jiayuan.chen@linux.dev kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com rjethwani@purestorage.com sagi@grimberg.me stable@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

