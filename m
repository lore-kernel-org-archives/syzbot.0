Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB59333BBAF
	for <syzbot@lists.linux.dev>; Thu, 22 Jan 2026 21:06:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769115992; cv=none; b=h4Vz4DDofM75p6mUpwaQ+1NbBHN/SnXXNo2CtZRQAAGDXqXeRB7VRuXySUMRLloeMYgL8nllc6752ahp6dCsV8o+i3Gtg7jpwvAAi7MxGpvSMXJTfDY6w9f348eC1On/IGt6k7ywG3YC/yx4/CcVTtT/wqrMUREoGMOOhUU6m+4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769115992; c=relaxed/simple;
	bh=HewVh9nDzlVwdzDWT1LB7g+PocL+5P2l4gNYX0wlrfg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=KHDzUKM8uZz1MnOrbUDpNmbc8vWmOTveBhxpivEnW9Ob3teQf6G5lKa+oZq/rFrL47dQs8eQSTYXQglDNTL0BII6YfndL+EPoe5j+sprOSwqbKFDOCQHw1MF+2ZwsGx1oaQNLWb9SHcvzhwtCb3pNoqeYPPNtMbYJ/lF6JbWLwU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-4040acebf22so2579504fac.1
        for <syzbot@lists.linux.dev>; Thu, 22 Jan 2026 13:06:25 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769115984; x=1769720784;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=+hx114IVwfEgyupPkXEvSfCzVl0aN0o8ijJIeODlRwU=;
        b=mcAzuf0wlwrQCLo12viJElHDz3PXY1Opvlpttij8JuCWw1eNP5ypE4rnLoTV2ddu1P
         VS0Jto4SmPjR6AfRIHsHt7IpJmSm7mwvKNBK2R/g5Nuh3zoJe/DVNxoc0LMDJML6MdtN
         K97KtAjCk2oXzOjPbPcrfRUpOQxhf0bDEoUuHdtSUOnl0vW9Y0JlWi5bm30GpKfjflVM
         ZamZ2Wq1iylsyycW9bi8iN6K1y/Q9rmwhGLrN/dEWWcRKr0Uh73TqjrEfV/hzkFEzFVh
         +gGT7Vunp+Z4SoG2S3JmwktaE+qkzf1RLyJJoufrq1qhjoHHTUuVy6MKVFdwmyaXJGgN
         SJ7Q==
X-Gm-Message-State: AOJu0YzgPx+6PLVjNIMiNHK4dIbaxptK/XKaofpO2tJNoVFCk9KX84hq
	ioeIbkgc95lSRoZ2mu+VDIooo/YL4C1hJKlDtUWYwrKjJlmK424XpVxfkF9Hq1WZmWzKRNjlWIF
	yTDZq7IhsPnD1J1pRVNwsS+oSfljOEBVhdeZNf+4Qh4cNVDo5GSmWK1vrjMs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c94:b0:662:c0e7:571d with SMTP id
 006d021491bc7-662cabb86abmr493076eaf.77.1769115984195; Thu, 22 Jan 2026
 13:06:24 -0800 (PST)
Date: Thu, 22 Jan 2026 13:06:24 -0800
In-Reply-To: <20260122131306.2119853-1-edumazet@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69729150.a70a0220.35de72.0000.GAE@google.com>
Subject: [syzbot ci] Re: mptcp: fix race in mptcp_pm_nl_flush_addrs_doit()
From: syzbot ci <syzbot+ciafd8d4e02fd53547@syzkaller.appspotmail.com>
To: davem@davemloft.net, edumazet@google.com, eric.dumazet@gmail.com, 
	eulgyukim@snu.ac.kr, fw@strlen.de, geliang.tang@linux.dev, geliang@kernel.org, 
	kuba@kernel.org, martineau@kernel.org, matttbe@kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzbot@syzkaller.appspotmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mptcp: fix race in mptcp_pm_nl_flush_addrs_doit()
https://lore.kernel.org/all/20260122131306.2119853-1-edumazet@google.com
* [PATCH net] mptcp: fix race in mptcp_pm_nl_flush_addrs_doit()

and found the following issue:
KASAN: invalid-free in mptcp_pm_nl_flush_addrs_doit

Full report is available here:
https://ci.syzbot.org/series/84b72a22-ce5b-495e-b999-5f5024f30853

***

KASAN: invalid-free in mptcp_pm_nl_flush_addrs_doit

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      19e4175e997a5b85eab97d522f00cc99abd1873c
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/62c1e47f-65ca-493d-85bc-91dc46138b40/config
C repro:   https://ci.syzbot.org/findings/7c0d11b6-76a9-444f-a5ae-08095bf44247/c_repro
syz repro: https://ci.syzbot.org/findings/7c0d11b6-76a9-444f-a5ae-08095bf44247/syz_repro

==================================================================
BUG: KASAN: invalid-free in __mptcp_pm_release_addr_entry net/mptcp/pm_kernel.c:709 [inline]
BUG: KASAN: invalid-free in __flush_addrs net/mptcp/pm_kernel.c:1282 [inline]
BUG: KASAN: invalid-free in mptcp_pm_nl_flush_addrs_doit+0x9a8/0xaa0 net/mptcp/pm_kernel.c:1315
Free of addr ffff88810b305b40 by task syz.0.17/5989

CPU: 0 UID: 0 PID: 5989 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xba/0x230 mm/kasan/report.c:482
 kasan_report_invalid_free+0xea/0x110 mm/kasan/report.c:557
 check_slab_allocation+0xd5/0xf0 mm/kasan/common.c:-1
 kasan_slab_pre_free include/linux/kasan.h:199 [inline]
 slab_free_hook mm/slub.c:2485 [inline]
 slab_free mm/slub.c:6670 [inline]
 kfree+0x16c/0x650 mm/slub.c:6878
 __mptcp_pm_release_addr_entry net/mptcp/pm_kernel.c:709 [inline]
 __flush_addrs net/mptcp/pm_kernel.c:1282 [inline]
 mptcp_pm_nl_flush_addrs_doit+0x9a8/0xaa0 net/mptcp/pm_kernel.c:1315
 genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1115
 genl_family_rcv_msg net/netlink/genetlink.c:1195 [inline]
 genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1210
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1219
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x4d7/0x810 net/socket.c:2592
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
 __sys_sendmsg net/socket.c:2678 [inline]
 __do_sys_sendmsg net/socket.c:2683 [inline]
 __se_sys_sendmsg net/socket.c:2681 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2488d9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc593deda8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f2489015fa0 RCX: 00007f2488d9acb9
RDX: 0000000000000800 RSI: 0000200000000200 RDI: 0000000000000003
RBP: 00007f2488e08bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2489015fac R14: 00007f2489015fa0 R15: 00007f2489015fa0
 </TASK>

Allocated by task 5944:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5657 [inline]
 __kmalloc_noprof+0x40c/0x7e0 mm/slub.c:5669
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 ops_init+0x7b/0x5c0 net/core/net_namespace.c:127
 setup_net+0x118/0x340 net/core/net_namespace.c:446
 copy_net_ns+0x3e2/0x570 net/core/net_namespace.c:581
 create_new_namespaces+0x3e7/0x6a0 kernel/nsproxy.c:130
 unshare_nsproxy_namespaces+0x11a/0x160 kernel/nsproxy.c:226
 ksys_unshare+0x4f4/0x900 kernel/fork.c:3171
 __do_sys_unshare kernel/fork.c:3242 [inline]
 __se_sys_unshare kernel/fork.c:3240 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3240
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88810b305b00
 which belongs to the cache kmalloc-128 of size 128
The buggy address is located 64 bytes inside of
 120-byte region [ffff88810b305b00, ffff88810b305b78)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10b305
anon flags: 0x17ff00000000000(node=0|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff888100041a00 ffffea00044a5a80 0000000000000005
raw: 0000000000000000 0000000000100010 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 5279, tgid 5279 (udevd), ts 37034162370, free_ts 37027298103
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x228/0x280 mm/page_alloc.c:1857
 prep_new_page mm/page_alloc.c:1865 [inline]
 get_page_from_freelist+0x24dc/0x2580 mm/page_alloc.c:3915
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5210
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2486
 alloc_slab_page mm/slub.c:3075 [inline]
 allocate_slab+0x86/0x3a0 mm/slub.c:3248
 new_slab mm/slub.c:3302 [inline]
 ___slab_alloc+0xd82/0x1760 mm/slub.c:4656
 __slab_alloc+0x65/0x100 mm/slub.c:4779
 __slab_alloc_node mm/slub.c:4855 [inline]
 slab_alloc_node mm/slub.c:5251 [inline]
 __kmalloc_cache_noprof+0x40d/0x6e0 mm/slub.c:5771
 kmalloc_noprof include/linux/slab.h:957 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 kernfs_get_open_node fs/kernfs/file.c:543 [inline]
 kernfs_fop_open+0x7b5/0xca0 fs/kernfs/file.c:718
 do_dentry_open+0x7ce/0x1420 fs/open.c:962
 vfs_open+0x3b/0x340 fs/open.c:1094
 do_open fs/namei.c:4637 [inline]
 path_openat+0x3486/0x3e20 fs/namei.c:4796
 do_filp_open+0x22d/0x490 fs/namei.c:4823
 do_sys_openat2+0x12f/0x220 fs/open.c:1430
 do_sys_open fs/open.c:1436 [inline]
 __do_sys_openat fs/open.c:1452 [inline]
 __se_sys_openat fs/open.c:1447 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1447
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
page last free pid 5285 tgid 5285 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1406 [inline]
 __free_frozen_pages+0xbb0/0xd10 mm/page_alloc.c:2943
 __slab_free+0x2ce/0x320 mm/slub.c:6004
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4953 [inline]
 slab_alloc_node mm/slub.c:5263 [inline]
 kmem_cache_alloc_noprof+0x370/0x6e0 mm/slub.c:5270
 getname_flags+0xb7/0x540 fs/namei.c:146
 getname include/linux/fs.h:2498 [inline]
 __do_sys_unlink fs/namei.c:5483 [inline]
 __se_sys_unlink fs/namei.c:5481 [inline]
 __x64_sys_unlink+0x3a/0x50 fs/namei.c:5481
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88810b305a00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
 ffff88810b305a80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88810b305b00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fc
                                           ^
 ffff88810b305b80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff88810b305c00: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
