Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 722373B7A8
	for <syzbot@lists.linux.dev>; Fri,  4 Sep 2026 14:01:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788530470; cv=none; b=e4RQpWr1IZzJSawrxFfeFZ1IHY0JuupGb9Pl4ZCb+V7hubxoe63tGIo/zT0hhzcjH28/oS4Q6Tq+YGmx+Fbsw9Z6vOwe0an2obopmvHuBZAjFEJyFMyEDtKenRx5pwy50CUudm6YXRze1bt94yRN2JmQFpiapwldqsTPZPHks/Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788530470; c=relaxed/simple;
	bh=HPaVBo0byGN1nxXzZioxcjDyGLKDLnUamtvp/c23qXs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=DI1M29Olfdv+Yv29OpshySmCmO3piUnXDedFln67RzCpiWsR13Vsrq4MEwuDfvi137pvt2EEJMVQhPAzkiP/Eg7DBYKx2mAHlqicODoRtJeuMysoMDpuyplVV4ycN+ZOR4I9/Kz+Ww/KNivyUvUWMxIFDzsEjOj6STS11Sb+l4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7f36427abfdso1608697a34.3
        for <syzbot@lists.linux.dev>; Fri, 04 Sep 2026 07:01:08 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788530467; x=1789135267;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tATLbPFIkVKmc4pyDcJlEeLR1Mag26Z9QCAq6qJheFU=;
        b=YitCid1BxDUeXd5GeIeBwpDr/k7BOT0ZZXz8Yvh3uhgHY0Itfsmj3a5IdRQ8NGiLQf
         wmnBD17B2OY/8q0xeDmodcufTwsCatRJMuphVpmuffaKo8X0Dnhzw0zKV0p1RViL3cN+
         wb5X+0BRBnJMm0LtverHMsmPdBsJup+ZHQ+GOSPkwG3l+A3x4dI0vYbJBtQQ88rA4Mfq
         x3cNHwmd8zeHpk2MgVQqK2gNyGazj3VqtOjFJVMlivfMNKHXBNskaJKModV9acb8L5qR
         hD+5N5ODNqvs7aGKJsbZXFyIF5D0gFvqVwaeka37UbunGPa13vOyCTWZQdDTjb66TIhi
         +yNw==
X-Gm-Message-State: AFuF++mFdth5t+5keaUQXsgDxp77oShUPHbCzK+0BW3LJUJaxIIFbyOu
	EksML8Et9WYvGIWUH1EiwTay9D/bqOPKayO1vnjTKyqVy3PX9vF0zm8RaJJ6dG3NxZNbn6pIcGo
	EaUbMRZ1xMFxqNBCvSYNDMwlADVRjFlwCr6uDOFD/ItrM942RHCyuKZ+qqcI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:e845:0:b0:6b7:46fc:1da with SMTP id
 006d021491bc7-6b746fc02b9mr2701175eaf.57.1788530465744; Fri, 04 Sep 2026
 07:01:05 -0700 (PDT)
Date: Fri, 04 Sep 2026 07:01:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9acf21.04649fcc.10325f.0002.GAE@google.com>
Subject: [moderation/CI] Re: bonding: fix slave_cnt leak on XDP error paths
From: syzbot ci <syzbot+ci36ca8a217343eb7d@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] bonding: fix slave_cnt leak on XDP error paths
https://lore.kernel.org/all/20260903-bond_slave_cnt-v2-1-02e27304ca36@kylin=
os.cn
* [PATCH net v2] bonding: fix slave_cnt leak on XDP error paths

and found the following issue:
KASAN: slab-out-of-bounds Write in bond_update_slave_arr

Full report is available here:
https://ci.syzbot.org/series/f9a94005-1c91-4312-a91e-f495ce00314a

***

KASAN: slab-out-of-bounds Write in bond_update_slave_arr

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      70f3995830d3f1e79faa14eb0605914f778feca9
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/767af4fc-83f9-4b54-8f38-27761606a65=
2/config
syz repro: https://ci.syzbot.org/findings/abcea6f7-092c-48e4-8137-756a0ff61=
7ba/syz_repro

8021q: adding VLAN 0 to HW filter on device bond0
bond1: (slave bond0): making interface the new active one
=3D=3D=3D=3D=3D
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in bond_update_slave_arr+0x47c/0xf30 drivers=
/net/bonding/bond_main.c:5198
Write of size 8 at addr ffff888115edcc98 by task syz.1.18/5855

CPU: 1 UID: 0 PID: 5855 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 bond_update_slave_arr+0x47c/0xf30 drivers/net/bonding/bond_main.c:5198
 bond_enslave+0x2c43/0x3b20 drivers/net/bonding/bond_main.c:2337
 do_set_master+0x563/0x720 net/core/rtnetlink.c:3071
 do_setlink+0xe7b/0x4670 net/core/rtnetlink.c:3273
 rtnl_changelink net/core/rtnetlink.c:3905 [inline]
 __rtnl_newlink net/core/rtnetlink.c:4076 [inline]
 rtnl_newlink+0x15a3/0x1c30 net/core/rtnetlink.c:4215
 rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7132
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
 __sys_sendmsg net/socket.c:2799 [inline]
 __do_sys_sendmsg net/socket.c:2804 [inline]
 __se_sys_sendmsg net/socket.c:2802 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5f8df9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5f8ee80028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f5f8e225fa0 RCX: 00007f5f8df9e159
RDX: 0000000000000000 RSI: 0000200000000240 RDI: 0000000000000006
RBP: 00007f5f8e035024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5f8e226038 R14: 00007f5f8e225fa0 R15: 00007ffd4eafc2e8
 </TASK>

Allocated by task 5855:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 poison_kmalloc_redzone mm/kasan/common.c:398 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:415
 kasan_kmalloc include/linux/kasan.h:263 [inline]
 __do_kmalloc_node mm/slub.c:5414 [inline]
 __kmalloc_noprof+0x36b/0x720 mm/slub.c:5439
 _kmalloc_noprof include/linux/slab.h:995 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 bond_update_slave_arr+0x161/0xf30 drivers/net/bonding/bond_main.c:5172
 bond_enslave+0x2c43/0x3b20 drivers/net/bonding/bond_main.c:2337
 do_set_master+0x563/0x720 net/core/rtnetlink.c:3071
 do_setlink+0xe7b/0x4670 net/core/rtnetlink.c:3273
 rtnl_changelink net/core/rtnetlink.c:3905 [inline]
 __rtnl_newlink net/core/rtnetlink.c:4076 [inline]
 rtnl_newlink+0x15a3/0x1c30 net/core/rtnetlink.c:4215
 rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7132
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
 __sock_sendmsg net/socket.c:815 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
 __sys_sendmsg net/socket.c:2799 [inline]
 __do_sys_sendmsg net/socket.c:2804 [inline]
 __se_sys_sendmsg net/socket.c:2802 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888115edcc80
 which belongs to the cache kmalloc-32 of size 32
The buggy address is located 0 bytes to the right of
 allocated 24-byte region [ffff888115edcc80, ffff888115edcc98)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x115edc
flags: 0x17ff00000000000(node=3D0|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 017ff00000000000 ffff888100041780 dead000000000100 dead000000000122
raw: 0000000000000000 0000000000400040 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0xd2cc0(GF=
P_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5643,=
 tgid 5643 (syz-executor), ts 53054509528
 set_page_owner include/linux/page_owner.h:33 [inline]
 post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1871
 prep_new_page mm/page_alloc.c:1879 [inline]
 get_page_from_freelist+0x2209/0x2280 mm/page_alloc.c:3943
 __alloc_frozen_pages_noprof+0x217/0x5a0 mm/page_alloc.c:5436
 alloc_slab_page mm/slub.c:3347 [inline]
 allocate_slab+0x7d/0x620 mm/slub.c:3462
 new_slab mm/slub.c:3513 [inline]
 refill_objects+0x2d5/0x350 mm/slub.c:7410
 refill_sheaf mm/slub.c:2885 [inline]
 __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4774
 alloc_from_pcs mm/slub.c:4850 [inline]
 slab_alloc_node mm/slub.c:4984 [inline]
 __do_kmalloc_node mm/slub.c:5413 [inline]
 __kmalloc_noprof+0x47b/0x720 mm/slub.c:5439
 _kmalloc_noprof include/linux/slab.h:995 [inline]
 _kzalloc_noprof include/linux/slab.h:1312 [inline]
 lsm_blob_alloc security/security.c:218 [inline]
 lsm_sock_alloc security/security.c:4477 [inline]
 security_sk_alloc+0x52/0x360 security/security.c:4493
 sk_prot_alloc+0x101/0x210 net/core/sock.c:2254
 sk_alloc+0x3a/0x390 net/core/sock.c:2307
 inet6_create+0x81a/0x1270 net/ipv6/af_inet6.c:178
 __sock_create+0x4b3/0x9d0 net/socket.c:1676
 inet_ctl_sock_create+0xa2/0x220 net/ipv4/af_inet.c:1639
 ndisc_net_init+0x95/0x260 net/ipv6/ndisc.c:1977
 ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
 setup_net+0x118/0x350 net/core/net_namespace.c:443
page last free pid 15 tgid 15 ts 53012061369 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xc93/0xd90 mm/page_alloc.c:2962
 __tlb_remove_table_free mm/mmu_gather.c:228 [inline]
 tlb_remove_table_rcu+0x85/0x100 mm/mmu_gather.c:291
 rcu_do_batch kernel/rcu/tree.c:2650 [inline]
 rcu_core+0x926/0x1260 kernel/rcu/tree.c:2919
 handle_softirqs+0x226/0x860 kernel/softirq.c:645
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1108
 smpboot_thread_fn+0x565/0xa70 kernel/smpboot.c:160
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Memory state around the buggy address:
 ffff888115edcb80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
 ffff888115edcc00: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
>ffff888115edcc80: 00 00 00 fc fc fc fc fc 00 00 00 fc fc fc fc fc
                            ^
 ffff888115edcd00: 00 00 00 00 fc fc fc fc 00 00 00 fc fc fc fc fc
 ffff888115edcd80: fa fb fb fb fc fc fc fc 00 00 00 fc fc fc fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


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
[andrew@lunn.ch daniel@iogearbox.net davem@davemloft.net edumazet@google.co=
m hangbin.liu@linux.dev joamaki@gmail.com jv@jvosburgh.net kuba@kernel.org =
linux-kernel@vger.kernel.org liuhangbin@kylinos.cn netdev@vger.kernel.org p=
abeni@redhat.com razor@blackwall.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

