Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 777E83368BF
	for <syzbot@lists.linux.dev>; Wed,  2 Sep 2026 04:07:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788322039; cv=none; b=WkfkK6mJAqfHbxwp36uRV1g4lo6PMhuzCEj12U4pdB7usSJf2qEnjpiabQm4LnvePJlDQ98CbgY93zsW/gYK3tcbLZzli1SJP8iQEDaOGhegsUdbd4fdI4DSt13cIwFPFfyigRhsLGVkZQlnLYIF8xl/+8Fy2WtdBRRSQzfzotg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788322039; c=relaxed/simple;
	bh=/7r4LjEGqPdT81wx0ooTQn6LmC4/aT6hRjmiCTg8hVU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=CY56yaKr7bEoElcW5rbtJKM7AMlI6ywwOD9OpUpWHSrPjyY3oa9LYPfV4asuL5oG2dDsj7WhMBGal6iI1s1YdtLpuBxJ9RYJ9v27DXe6eEarH+5WGRl04oz/4aq5O+S/CwfRW+Hb/7DHtdM1WRyyFmCoXJjCU4k2ORuVmxt6E5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7ee1e335245so532974a34.1
        for <syzbot@lists.linux.dev>; Tue, 01 Sep 2026 21:07:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788322036; x=1788926836;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=BNFb2AIiPx6eGurYL+8pet+1ehI2tk/LZ3qXxEpMfGo=;
        b=qLOj9c4RzUFe0HKzv0SWC/EVc3zufz3VBih4GgAzq2Q9WyGHSJoaO9+4CUppnRpv9H
         UYMrgCDc+6lusIz4wJEFWhpaIdBJ6MoVYe2N5605YN3ENxIJ5Ae38DkJBe0GTnB+JK/0
         fY7EBNjtbtAEKFUKYorxAuad4e8whWDpECuwoPevCb+/cTjhCb4jrOY+zupkj72uol5V
         NuHcoL1IqjWwVHBLzoqaT5QxTCrP/yuIaZcD5jg4cbJa8ILRtF2sfNXn+V+lbOp0TWmm
         Wf6lbJU4ZqwZkaB0lxR2iUxPRDEXjUV43M5MtbQOxpCFPcySqF4DakGhN7W+ZNeqfz89
         9kRg==
X-Gm-Message-State: AFuF++nNvPb9GZrEwl603Tjh1U1JQJy97JMiWXW55Muh9a1229FjiMwp
	yqvQMbWvrQODQo1YxE3iCWN2ker+SUyk/hBbkffNdXMrPdzvVaH13OndQpbNRZa4XEnBkbVYgYK
	R01Od3fcWHxoF7met/ymsfdxPowrnWYGqM/zBzHIlp7U5R58nFe9xlo8RWC4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1527:b0:6b0:19bc:fd14 with SMTP id
 006d021491bc7-6b482020f0fmr1564331eaf.32.1788322036222; Tue, 01 Sep 2026
 21:07:16 -0700 (PDT)
Date: Tue, 01 Sep 2026 21:07:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a97a0f4.9266084e.bf0d7.0004.GAE@google.com>
Subject: [moderation/CI] Re: net/ipv6: don't route packets with unknown source address
From: syzbot ci <syzbot+ci0becfe11fd5e01f8@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] net/ipv6: don't route packets with unknown source address
https://lore.kernel.org/all/20260901115021.50057-1-ihuguet@riseup.net
* [PATCH net] net/ipv6: don't route packets with unknown source address

and found the following issues:
* KASAN: slab-out-of-bounds Read in tcp_v6_send_response
* KASAN: use-after-free Read in tcp_v6_send_response

Full report is available here:
https://ci.syzbot.org/series/bf5b7c3c-6165-4e2e-b403-34a698f5ee76

***

KASAN: slab-out-of-bounds Read in tcp_v6_send_response

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      1d2929d0850fff683b8aff051275945e65f082c8
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/19ac2ebf-5913-40a0-982b-44641518038=
2/config
syz repro: https://ci.syzbot.org/findings/103185a7-eed2-413d-9bb8-0cfd4d802=
dbb/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in instrument_atomic_read include/linux/inst=
rumented.h:82 [inline]
BUG: KASAN: slab-out-of-bounds in _test_bit include/asm-generic/bitops/inst=
rumented-non-atomic.h:141 [inline]
BUG: KASAN: slab-out-of-bounds in inet_sk_flowi_flags include/net/inet_sock=
.h:411 [inline]
BUG: KASAN: slab-out-of-bounds in tcp_v6_send_response+0x116c/0x1e30 net/ip=
v6/tcp_ipv6.c:983
Read of size 8 at addr ffff8881bc3cecb8 by task kworker/u8:3/5678

CPU: 1 UID: 0 PID: 5678 Comm: kworker/u8:3 Not tainted syzkaller #0 PREEMPT=
(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Workqueue: krdsd rds_tcp_accept_worker
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:82 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline=
]
 inet_sk_flowi_flags include/net/inet_sock.h:411 [inline]
 tcp_v6_send_response+0x116c/0x1e30 net/ipv6/tcp_ipv6.c:983
 tcp_v6_send_ack net/ipv6/tcp_ipv6.c:1149 [inline]
 tcp_v6_timewait_ack+0x2c6/0x4c0 net/ipv6/tcp_ipv6.c:1201
 tcp_v6_rcv+0x1f09/0x2d90 net/ipv6/tcp_ipv6.c:1993
 ip6_protocol_deliver_rcu+0xab9/0x1680 net/ipv6/ip6_input.c:479
 ip6_input_finish+0x191/0x370 net/ipv6/ip6_input.c:534
 NF_HOOK+0x336/0x3c0 include/linux/netfilter.h:325
 ip6_input+0x16a/0x270 net/ipv6/ip6_input.c:545
 NF_HOOK+0x336/0x3c0 include/linux/netfilter.h:325
 __netif_receive_skb_one_core net/core/dev.c:6264 [inline]
 __netif_receive_skb net/core/dev.c:6377 [inline]
 process_backlog+0x795/0x18b0 net/core/dev.c:6728
 __napi_poll+0xaa/0x330 net/core/dev.c:7787
 napi_poll net/core/dev.c:7850 [inline]
 net_rx_action+0x61d/0xf50 net/core/dev.c:8007
 handle_softirqs+0x226/0x860 kernel/softirq.c:645
 do_softirq+0x77/0xd0 kernel/softirq.c:546
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x100/0x140 kernel/softirq.c:473
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:923 [inline]
 __dev_queue_xmit+0x1edc/0x3820 net/core/dev.c:4961
 NF_HOOK_COND include/linux/netfilter.h:314 [inline]
 ip6_output+0x337/0x540 net/ipv6/ip6_output.c:248
 dst_output include/net/dst.h:471 [inline]
 NF_HOOK include/linux/netfilter.h:325 [inline]
 ip6_xmit+0x117f/0x1a60 net/ipv6/ip6_output.c:381
 inet6_csk_xmit+0x397/0x660 net/ipv6/inet6_connection_sock.c:123
 __tcp_transmit_skb+0x2640/0x47c0 net/ipv4/tcp_output.c:1717
 tcp_transmit_skb net/ipv4/tcp_output.c:1734 [inline]
 tcp_write_xmit+0x1bfa/0x6400 net/ipv4/tcp_output.c:3062
 __tcp_push_pending_frames+0x96/0x380 net/ipv4/tcp_output.c:3245
 __tcp_close+0x56e/0xe70 net/ipv4/tcp.c:3220
 tcp_close+0x28/0x110 net/ipv4/tcp.c:3311
 inet_release+0x143/0x190 net/ipv4/af_inet.c:442
 __sock_release net/socket.c:735 [inline]
 sock_release+0x85/0x150 net/socket.c:763
 rds_tcp_accept_one+0x62c/0xd40 net/rds/tcp_listen.c:341
 rds_tcp_accept_worker+0x1d/0x70 net/rds/tcp.c:556
 process_one_work kernel/workqueue.c:3387 [inline]
 process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3470
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3551
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

The buggy address belongs to the object at ffff8881bc3ceb80
 which belongs to the cache tw_sock_TCPv6 of size 304
The buggy address is located 8 bytes to the right of
 allocated 304-byte region [ffff8881bc3ceb80, ffff8881bc3cecb0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff8881bc3ce8=
a0 pfn:0x1bc3ce
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
memcg:ffff8881bb1a4301
flags: 0x57ff00000000240(workingset|head|node=3D1|zone=3D2|lastcpupid=3D0x7=
ff)
page_type: f5(slab)
raw: 057ff00000000240 ffff8881042e0640 ffff88816fedf1c8 ffff88816fedf1c8
raw: ffff8881bc3ce8a0 0000000200160006 00000000f5000000 ffff8881bb1a4301
head: 057ff00000000240 ffff8881042e0640 ffff88816fedf1c8 ffff88816fedf1c8
head: ffff8881bc3ce8a0 0000000200160006 00000000f5000000 ffff8881bb1a4301
head: 057ff00000000001 ffffffffffffff81 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd2820(GF=
P_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5678,=
 tgid 5678 (kworker/u8:3), ts 57920184007
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
 kmem_cache_alloc_noprof+0x399/0x600 mm/slub.c:5010
 inet_twsk_alloc+0xe3/0x8d0 net/ipv4/inet_timewait_sock.c:178
 tcp_time_wait+0x5d/0xee0 net/ipv4/tcp_minisocks.c:333
 tcp_rcv_state_process+0xba1/0x4980 net/ipv4/tcp_input.c:-1
 tcp_v6_do_rcv+0xf3d/0x1c70 net/ipv6/tcp_ipv6.c:1653
 tcp_v6_rcv+0x2496/0x2d90 net/ipv6/tcp_ipv6.c:1906
 ip6_protocol_deliver_rcu+0xab9/0x1680 net/ipv6/ip6_input.c:479
 ip6_input_finish+0x191/0x370 net/ipv6/ip6_input.c:534
 NF_HOOK+0x336/0x3c0 include/linux/netfilter.h:325
 ip6_input+0x16a/0x270 net/ipv6/ip6_input.c:545
page last free pid 24 tgid 24 ts 57909757259 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xc93/0xd90 mm/page_alloc.c:2962
 rcu_do_batch kernel/rcu/tree.c:2650 [inline]
 rcu_core+0x926/0x1260 kernel/rcu/tree.c:2919
 handle_softirqs+0x226/0x860 kernel/softirq.c:645
 __do_softirq kernel/softirq.c:679 [inline]
 invoke_softirq kernel/softirq.c:519 [inline]
 __irq_exit_rcu+0xcb/0x220 kernel/softirq.c:767
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:784
 instr_sysvec_call_function_single arch/x86/kernel/smp.c:267 [inline]
 sysvec_call_function_single+0xa3/0xc0 arch/x86/kernel/smp.c:267
 asm_sysvec_call_function_single+0x1a/0x20 arch/x86/include/asm/idtentry.h:=
681

Memory state around the buggy address:
 ffff8881bc3ceb80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8881bc3cec00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff8881bc3cec80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
                                        ^
 ffff8881bc3ced00: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff8881bc3ced80: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

KASAN: use-after-free Read in tcp_v6_send_response

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      1d2929d0850fff683b8aff051275945e65f082c8
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/19ac2ebf-5913-40a0-982b-44641518038=
2/config
syz repro: https://ci.syzbot.org/findings/e7a2188a-bd9d-4259-856a-ad2e7415f=
5e1/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrume=
nted.h:82 [inline]
BUG: KASAN: use-after-free in _test_bit include/asm-generic/bitops/instrume=
nted-non-atomic.h:141 [inline]
BUG: KASAN: use-after-free in inet_sk_flowi_flags include/net/inet_sock.h:4=
11 [inline]
BUG: KASAN: use-after-free in tcp_v6_send_response+0x116c/0x1e30 net/ipv6/t=
cp_ipv6.c:983
Read of size 8 at addr ffff888169a4a248 by task syz.0.28/5835

CPU: 1 UID: 0 PID: 5835 Comm: syz.0.28 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:82 [inline]
 _test_bit include/asm-generic/bitops/instrumented-non-atomic.h:141 [inline=
]
 inet_sk_flowi_flags include/net/inet_sock.h:411 [inline]
 tcp_v6_send_response+0x116c/0x1e30 net/ipv6/tcp_ipv6.c:983
 tcp_v6_send_ack net/ipv6/tcp_ipv6.c:1149 [inline]
 tcp_v6_timewait_ack+0x2c6/0x4c0 net/ipv6/tcp_ipv6.c:1201
 tcp_v6_rcv+0x1f09/0x2d90 net/ipv6/tcp_ipv6.c:1993
 ip6_protocol_deliver_rcu+0xab9/0x1680 net/ipv6/ip6_input.c:479
 ip6_input_finish+0x191/0x370 net/ipv6/ip6_input.c:534
 NF_HOOK+0x336/0x3c0 include/linux/netfilter.h:325
 ip6_input+0x16a/0x270 net/ipv6/ip6_input.c:545
 NF_HOOK+0x336/0x3c0 include/linux/netfilter.h:325
 __netif_receive_skb_one_core net/core/dev.c:6264 [inline]
 __netif_receive_skb net/core/dev.c:6377 [inline]
 process_backlog+0x795/0x18b0 net/core/dev.c:6728
 __napi_poll+0xaa/0x330 net/core/dev.c:7787
 napi_poll net/core/dev.c:7850 [inline]
 net_rx_action+0x61d/0xf50 net/core/dev.c:8007
 handle_softirqs+0x226/0x860 kernel/softirq.c:645
 do_softirq+0x77/0xd0 kernel/softirq.c:546
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x100/0x140 kernel/softirq.c:473
 local_bh_enable include/linux/bottom_half.h:33 [inline]
 rcu_read_unlock_bh include/linux/rcupdate.h:923 [inline]
 __dev_queue_xmit+0x1edc/0x3820 net/core/dev.c:4961
 NF_HOOK_COND include/linux/netfilter.h:314 [inline]
 ip6_output+0x337/0x540 net/ipv6/ip6_output.c:248
 dst_output include/net/dst.h:471 [inline]
 NF_HOOK include/linux/netfilter.h:325 [inline]
 ip6_xmit+0x117f/0x1a60 net/ipv6/ip6_output.c:381
 inet6_csk_xmit+0x397/0x660 net/ipv6/inet6_connection_sock.c:123
 __tcp_transmit_skb+0x2640/0x47c0 net/ipv4/tcp_output.c:1717
 tcp_transmit_skb net/ipv4/tcp_output.c:1734 [inline]
 tcp_write_xmit+0x1bfa/0x6400 net/ipv4/tcp_output.c:3062
 __tcp_push_pending_frames+0x96/0x380 net/ipv4/tcp_output.c:3245
 __tcp_close+0x56e/0xe70 net/ipv4/tcp.c:3220
 tcp_close+0x28/0x110 net/ipv4/tcp.c:3311
 inet_release+0x143/0x190 net/ipv4/af_inet.c:442
 __sock_release+0xa0/0x1f0 net/socket.c:735
 sock_close+0x1c/0x30 net/socket.c:1526
 __fput+0x418/0xa50 fs/file_table.c:512
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
 exit_to_user_mode_loop+0x204/0x770 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [in=
line]
 syscall_exit_to_user_mode include/linux/entry-common.h:336 [inline]
 do_syscall_64+0x328/0x520 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb1d8b9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffef2a01168 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007ffef2a01250 RCX: 00007fb1d8b9e159
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 000000000000d50a R08: 0000000000000001 R09: 0000000000000000
R10: 0000001b31820000 R11: 0000000000000246 R12: 00007ffef2a01290
R13: 00007fb1d8e25fac R14: 000000000000d53d R15: 00007fb1d8e25fa0
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888169a4bc=
80 pfn:0x169a4a
flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
raw: 057ff00000000000 ffffea0005c32488 ffffea0005c32508 0000000000000000
raw: ffff888169a4bc80 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd2820(GF=
P_ATOMIC|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5565,=
 tgid 5565 (sshd), ts 40657811568
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
 kmem_cache_alloc_noprof+0x399/0x600 mm/slub.c:5010
 skb_clone+0x212/0x3a0 net/core/skbuff.c:2119
 dev_queue_xmit_nit+0x28d/0xac0 net/core/dev.c:2600
 xmit_one net/core/dev.c:3933 [inline]
 dev_hard_start_xmit+0x1c1/0x830 net/core/dev.c:3953
 sch_direct_xmit+0x257/0x4c0 net/sched/sch_generic.c:372
 __dev_xmit_skb net/core/dev.c:4262 [inline]
 __dev_queue_xmit+0x177f/0x3820 net/core/dev.c:4884
 dev_queue_xmit include/linux/netdevice.h:3461 [inline]
 neigh_hh_output include/net/neighbour.h:544 [inline]
 neigh_output include/net/neighbour.h:558 [inline]
 ip_finish_output2+0xbda/0x10b0 net/ipv4/ip_output.c:236
 NF_HOOK_COND include/linux/netfilter.h:314 [inline]
 ip_output+0x29f/0x450 net/ipv4/ip_output.c:437
 __ip_queue_xmit+0x10df/0x1b10 net/ipv4/ip_output.c:533
 __tcp_transmit_skb+0x2d18/0x47c0 net/ipv4/tcp_output.c:1717
page last free pid 5040 tgid 5040 ts 54399149504 stack trace:
 reset_page_owner include/linux/page_owner.h:26 [inline]
 __free_pages_prepare mm/page_alloc.c:1418 [inline]
 __free_frozen_pages+0xc93/0xd90 mm/page_alloc.c:2962
 __slab_free+0x274/0x2c0 mm/slub.c:5815
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:350
 kasan_slab_alloc include/linux/kasan.h:253 [inline]
 slab_post_alloc_hook mm/slub.c:4683 [inline]
 slab_alloc_node mm/slub.c:4996 [inline]
 __do_kmalloc_node mm/slub.c:5413 [inline]
 __kvmalloc_node_noprof+0x49f/0x820 mm/slub.c:7005
 seq_buf_alloc fs/seq_file.c:39 [inline]
 seq_read_iter+0x1ea/0xca0 fs/seq_file.c:211
 new_sync_read fs/read_write.c:493 [inline]
 vfs_read+0x595/0xa80 fs/read_write.c:574
 ksys_read+0x150/0x270 fs/read_write.c:716
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888169a4a100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888169a4a180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff888169a4a200: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                              ^
 ffff888169a4a280: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff888169a4a300: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
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
[andrew@lunn.ch ast@kernel.org bpf@vger.kernel.org coreteam@netfilter.org d=
aniel@iogearbox.net davem@davemloft.net dsahern@kernel.org edumazet@google.=
com fmancera@suse.de fw@strlen.de horms@kernel.org idosch@nvidia.com ihugue=
t@riseup.net jlayton@kernel.org joe@dama.to kees@kernel.org kuba@kernel.org=
 kuniyu@google.com leitao@debian.org leon.hwang@linux.dev linux-kernel@vger=
.kernel.org lirongqing@baidu.com luoxuanqiang@kylinos.cn ncardwell@google.c=
om netdev@vger.kernel.org netfilter-devel@vger.kernel.org pabeni@redhat.com=
 pablo@netfilter.org phil@nwl.cc tpluszz77@gmail.com willemb@google.com wil=
lemdebruijn.kernel@gmail.com zirajs7@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

