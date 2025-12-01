Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94CE930BF4E
	for <syzbot@lists.linux.dev>; Mon,  1 Dec 2025 17:47:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764611230; cv=none; b=BxwwDGTxsDjzyRAfYIk+abSgv6xKJWHTecrrUxaBoPS/z59xRHiXS9D85aPbSUhkuWcNpEX8O2I++R/5NHCJ4EMSUXuf4NsMWK2J2W46xV7c3UdXXaQCNwxNQ/ReLsV7UiWIiHnyjpyHyXtoL8yc6A3EIPWGMWLt5LmTqFVOPOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764611230; c=relaxed/simple;
	bh=80bIHbjuqRsJXGKXF3MYc6xvGa2VBZRa4NR3H5GWW+4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=spp8oxAhYZptQ77Z0c02CImilyvycT69j3R7zxtlS/PeIJDdqu1ZNP56A+0jdu3CnmPx0tmTP//lyOsfUnTm5hjmTouJrLBzzz08o6W9ozxiLLN6eEVKCASFg2QNCU0vtIhZp7rcE5jKV6MgX7z4cki84aQ7aBDYG8xJxnOWEA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4512e9f2f82so3352310b6e.3
        for <syzbot@lists.linux.dev>; Mon, 01 Dec 2025 09:47:07 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764611226; x=1765216026;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ibROamDp77c7lxwG6xHhHUa4tUderUCpXIfec1wq+eo=;
        b=HciCnR4BrH0hYwT2ZB2T29rrmWmmpa+WlZ2iFzITuoeRpsPXzj1Pu65Txe4XKWBFun
         WQ0ivVkoQySYNuRwYrzPMilW3wLgaym8XUoT8FdokeSZi+p6jljlzKEt50pCEvrVgTHR
         cATWRUK2R8tnsCvUuVSJnyymI5v692pK8Ildf1BDFoyl59JL5Y1Xd+UnsShdqFNccaW7
         IJMWiwHI1cvZSbQ/1TeZMhFdNjBnigtHNVcSUOmB78ZvCIJ+u7GGoP7RksMLaWHY1VPx
         JRUuVwYjqkTxi3GXXEOtJok/MaMhfMgB5+YqogasGtDlko/gDYBjcR8VLjY6TJ413m69
         Rm/w==
X-Gm-Message-State: AOJu0Yz7gjZm8fLA0T9kZ7hljy3eaosiQ2NrS98BWPW45oC3PTeyibAA
	1yJjr/S1sWMSQJ7yORJwvlbzthIYi6Nt8D3IYMrPnbPoQZ7VAOoObT9xmsjrsK0EogMpCLpMwv7
	egL3HuBDR5Q96EOMlbw8XBZxL5/cbIOE4qSoH9EIz2L1FhXcrYsGypuSLD5E=
X-Google-Smtp-Source: AGHT+IG+B6RGxYXkwQhCZYSEB28n7vtsZP919I4b8Bzoefp3Dm7/0ObxrpcnaFdy0naPbT3vysu3in2Z+TnAQdDgL6UwRKyg1XgE
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6783:b0:450:c0ef:8075 with SMTP id
 5614622812f47-4511290cee7mr16395169b6e.8.1764611226400; Mon, 01 Dec 2025
 09:47:06 -0800 (PST)
Date: Mon, 01 Dec 2025 09:47:06 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692dd49a.a70a0220.2ea503.00b7.GAE@google.com>
Subject: [moderation/CI] Re: Add IP6IP6 flowtable SW acceleration
From: syzbot ci <syzbot+cibae5ef332236f6f6@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Add IP6IP6 flowtable SW acceleration
https://lore.kernel.org/all/20251201-flowtable-offload-ip6ip6-v1-0-1dabf534=
c074@kernel.org
* [PATCH RFC nf-next 1/4] netfilter: Introduce tunnel metadata info in nf_f=
lowtable_ctx struct
* [PATCH RFC nf-next 2/4] netfilter: flowtable: Add IP6IP6 rx sw accelerati=
on
* [PATCH RFC nf-next 3/4] netfilter: flowtable: Add IP6IP6 tx sw accelerati=
on
* [PATCH RFC nf-next 4/4] selftests: netfilter: nft_flowtable.sh: Add IP6IP=
6 flowtable selftest

and found the following issue:
KASAN: slab-use-after-free Read in nf_flow_skb_encap_protocol

Full report is available here:
https://ci.syzbot.org/series/df395c22-6768-4a9f-9a96-56b5307acbc6

***

KASAN: slab-use-after-free Read in nf_flow_skb_encap_protocol

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilt=
er/nf-next.git
base:      ff736a286116d462a4067ba258fa351bc0b4ed80
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/018f7259-7abc-4b77-b40c-e8e520e1e79=
3/config
C repro:   https://ci.syzbot.org/findings/5cb5bc43-721b-4a9e-a093-4d52aab5b=
a9f/c_repro
syz repro: https://ci.syzbot.org/findings/5cb5bc43-721b-4a9e-a093-4d52aab5b=
a9f/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-use-after-free in nf_flow_ip6_tunnel_proto net/netfilter/n=
f_flow_table_ip.c:383 [inline]
BUG: KASAN: slab-use-after-free in nf_flow_skb_encap_protocol+0x1336/0x14e0=
 net/netfilter/nf_flow_table_ip.c:433
Read of size 2 at addr ffff888115de92b6 by task syz.0.20/5970

CPU: 0 UID: 0 PID: 5970 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 nf_flow_ip6_tunnel_proto net/netfilter/nf_flow_table_ip.c:383 [inline]
 nf_flow_skb_encap_protocol+0x1336/0x14e0 net/netfilter/nf_flow_table_ip.c:=
433
 nf_flow_offload_ipv6_lookup net/netfilter/nf_flow_table_ip.c:1065 [inline]
 nf_flow_offload_ipv6_hook+0x131/0x3380 net/netfilter/nf_flow_table_ip.c:10=
92
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:623
 nf_hook_ingress include/linux/netfilter_netdev.h:34 [inline]
 nf_ingress net/core/dev.c:5900 [inline]
 __netif_receive_skb_core+0x241c/0x2f90 net/core/dev.c:5996
 __netif_receive_skb_one_core net/core/dev.c:6135 [inline]
 __netif_receive_skb+0x72/0x380 net/core/dev.c:6250
 netif_receive_skb_internal net/core/dev.c:6336 [inline]
 netif_receive_skb+0x1cb/0x790 net/core/dev.c:6395
 tun_rx_batched+0x1b9/0x730 drivers/net/tun.c:1485
 tun_get_user+0x2b65/0x3e90 drivers/net/tun.c:1953
 tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1999
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x5c9/0xb30 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8b24f8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f8b25e26038 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00007f8b251e6090 RCX: 00007f8b24f8f7c9
RDX: 000000000000fdef RSI: 0000200000000440 RDI: 0000000000000003
RBP: 00007f8b24ff297f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f8b251e6128 R14: 00007f8b251e6090 R15: 00007ffe014b8a38
 </TASK>

Allocated by task 5970:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 unpoison_slab_object mm/kasan/common.c:342 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:368
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4978 [inline]
 slab_alloc_node mm/slub.c:5288 [inline]
 kmem_cache_alloc_node_noprof+0x433/0x710 mm/slub.c:5340
 __alloc_skb+0x255/0x430 net/core/skbuff.c:679
 alloc_skb include/linux/skbuff.h:1383 [inline]
 alloc_skb_with_frags+0xca/0x890 net/core/skbuff.c:6712
 sock_alloc_send_pskb+0x84d/0x980 net/core/sock.c:2995
 tun_alloc_skb drivers/net/tun.c:1461 [inline]
 tun_get_user+0xa43/0x3e90 drivers/net/tun.c:1794
 tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1999
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x5c9/0xb30 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 5970:
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
 icmpv6_param_prob include/linux/icmpv6.h:95 [inline]
 ipv6_rthdr_rcv+0x150e/0x2020 net/ipv6/exthdrs.c:828
 nf_flow_ip6_tunnel_proto net/netfilter/nf_flow_table_ip.c:381 [inline]
 nf_flow_skb_encap_protocol+0x9b5/0x14e0 net/netfilter/nf_flow_table_ip.c:4=
33
 nf_flow_offload_ipv6_lookup net/netfilter/nf_flow_table_ip.c:1065 [inline]
 nf_flow_offload_ipv6_hook+0x131/0x3380 net/netfilter/nf_flow_table_ip.c:10=
92
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:623
 nf_hook_ingress include/linux/netfilter_netdev.h:34 [inline]
 nf_ingress net/core/dev.c:5900 [inline]
 __netif_receive_skb_core+0x241c/0x2f90 net/core/dev.c:5996
 __netif_receive_skb_one_core net/core/dev.c:6135 [inline]
 __netif_receive_skb+0x72/0x380 net/core/dev.c:6250
 netif_receive_skb_internal net/core/dev.c:6336 [inline]
 netif_receive_skb+0x1cb/0x790 net/core/dev.c:6395
 tun_rx_batched+0x1b9/0x730 drivers/net/tun.c:1485
 tun_get_user+0x2b65/0x3e90 drivers/net/tun.c:1953
 tun_chr_write_iter+0x113/0x200 drivers/net/tun.c:1999
 new_sync_write fs/read_write.c:593 [inline]
 vfs_write+0x5c9/0xb30 fs/read_write.c:686
 ksys_write+0x145/0x250 fs/read_write.c:738
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff888115de9200
 which belongs to the cache skbuff_head_cache of size 240
The buggy address is located 182 bytes inside of
 freed 240-byte region [ffff888115de9200, ffff888115de92f0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x115de8
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 017ff00000000040 ffff8881036ba8c0 ffffea0004280a80 dead000000000002
raw: 0000000000000000 0000000080150015 00000000f5000000 0000000000000000
head: 017ff00000000040 ffff8881036ba8c0 ffffea0004280a80 dead000000000002
head: 0000000000000000 0000000080150015 00000000f5000000 0000000000000000
head: 017ff00000000001 ffffea0004577a01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__=
GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pi=
d 5555, tgid 5555 (dhcpcd), ts 36767395595, free_ts 35122573404
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x234/0x290 mm/page_alloc.c:1845
 prep_new_page mm/page_alloc.c:1853 [inline]
 get_page_from_freelist+0x2365/0x2440 mm/page_alloc.c:3879
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5178
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:3059 [inline]
 allocate_slab+0x96/0x350 mm/slub.c:3232
 new_slab mm/slub.c:3286 [inline]
 ___slab_alloc+0xf56/0x1990 mm/slub.c:4655
 __slab_alloc+0x65/0x100 mm/slub.c:4778
 __slab_alloc_node mm/slub.c:4854 [inline]
 slab_alloc_node mm/slub.c:5276 [inline]
 kmem_cache_alloc_node_noprof+0x4c5/0x710 mm/slub.c:5340
 __alloc_skb+0x255/0x430 net/core/skbuff.c:679
 alloc_skb include/linux/skbuff.h:1383 [inline]
 alloc_skb_with_frags+0xca/0x890 net/core/skbuff.c:6712
 sock_alloc_send_pskb+0x84d/0x980 net/core/sock.c:2995
 unix_dgram_sendmsg+0x454/0x1840 net/unix/af_unix.c:2139
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 sock_write_iter+0x279/0x360 net/socket.c:1195
 do_iter_readv_writev+0x623/0x8c0 fs/read_write.c:-1
 vfs_writev+0x31a/0x960 fs/read_write.c:1057
page last free pid 5262 tgid 5262 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1394 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2901
 __slab_free+0x2e7/0x390 mm/slub.c:5970
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:352
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4978 [inline]
 slab_alloc_node mm/slub.c:5288 [inline]
 kmem_cache_alloc_noprof+0x367/0x6e0 mm/slub.c:5295
 getname_flags+0xb8/0x540 fs/namei.c:146
 getname include/linux/fs.h:2924 [inline]
 do_sys_openat2+0xbc/0x1c0 fs/open.c:1431
 do_sys_open fs/open.c:1452 [inline]
 __do_sys_openat fs/open.c:1468 [inline]
 __se_sys_openat fs/open.c:1463 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1463
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff888115de9180: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888115de9200: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>ffff888115de9280: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
                                     ^
 ffff888115de9300: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
 ffff888115de9380: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
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

The email will later be sent to:
[coreteam@netfilter.org davem@davemloft.net dsahern@kernel.org edumazet@goo=
gle.com fw@strlen.de horms@kernel.org kadlec@netfilter.org kuba@kernel.org =
linux-kselftest@vger.kernel.org lorenzo@kernel.org netdev@vger.kernel.org n=
etfilter-devel@vger.kernel.org pabeni@redhat.com pablo@netfilter.org phil@n=
wl.cc shuah@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

