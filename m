Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DC5513D75A6
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 08:03:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787645033; cv=none; b=rRsjoF4zXw3M8jJGNzncR9fPLz/20+qxDzc4h4NioV8zzWdue9AFCqEVnLz6nnrPMgc612cTk8DAplI3nnMcdoi/5s9/aXP1/8BN0NEokH20aO/7MonSp4RZ+VRYN+SBWVDqvf1gSSDVqHYQ060uCeq8qZs/XfUtvpWY7DcnU8Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787645033; c=relaxed/simple;
	bh=zE/6PpAbFwbSHzEnUEO8gwXvJ5QKAZ5ylc2eCikFt+w=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=SUpr68iAb5X+azwBWi8Vxhi6uWrHE2icT9flQvKla2viy7mS58J8x8YrrI1oKCxv/+BOHjesVgfv1Y0GPdusNpH3xoXeM34QM9Rnk+w97Nwpuk1vzbiN0lLYRtKivgN4Kz6ktO0DpoJNTjtkQt4pcyXjTqvvD82DEbLpEMWh9u8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b28dbf4197so8559111b6e.2
        for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 01:03:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787645030; x=1788249830;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=AtGfEt5fG2go9z5Op71wQEx7a+tRBKr+1KtptibDM+E=;
        b=gWzQ+l+O5IKvaHbvp3GjmBbRb8sk2lWCOt1iYmhS3V3dGgKadjyMaxBHlgQ7TlF4UZ
         Pb/gKkr2tam8kLVaVuOTNpb687ft4RTtX0YV35pVZVZJ7nrelJUd4zFOeIJdkD5aS4Nf
         9qDc3sviOl/zeeS9nycrX+cXdfPmB7AAdSp2yrzCZbT5Vf5xU+HKPxodiHKrSsS0JFkX
         GISIKM5a3BFG96EoWmxfWpsvevJlUzb0qgqGPIEYzqhdTA2Tq5L8NoSI1+AGTELJsWtr
         anRDqgoF7gDpOGtfrCtEQpyuYXY5gu89XXaU9bPLM/7BgjlMqV06E4k4lYASYYncLibL
         1+aQ==
X-Gm-Message-State: AFuF++mmUv9vp1mkFUjPiAkVcrKQ1iUb+hWQUgxmsV55IB9fhkQFyOVW
	ue4v0h3ynrpma8Nny20w/vzplAF/4vIMQROmC1PVPLhsaGl5RBtD9YYF36rN+kPqScYlhvCTROw
	6s28U+bmRWPJ59U2z7j990WgbtC8PrjpivO89Qh/Br+dPnzi2mlchbgV8N4c=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1c09:b0:496:a36:b5e5 with SMTP id
 5614622812f47-4b35089c71bmr4724901b6e.17.1787645029903; Tue, 25 Aug 2026
 01:03:49 -0700 (PDT)
Date: Tue, 25 Aug 2026 01:03:49 -0700
In-Reply-To: <20260824152932.1583506-1-lrizzo@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8d4c65.a5a502ce.31d34.0049.GAE@google.com>
Subject: [syzbot ci] Re: swiotlb: avoid swiotlb copy on network sockets
From: syzbot ci <syzbot+ci194162eefbbbb459@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, davem@davemloft.net, david@kernel.org, 
	driver-core@lists.linux.dev, dtatulea@nvidia.com, edumazet@google.com, 
	gregkh@linuxfoundation.org, iommu@lists.linux.dev, kuba@kernel.org, 
	kuniyu@google.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lrizzo@google.com, m.szyprowski@samsung.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, rafael@kernel.org, rizzo.unipi@gmail.com, 
	robin.murphy@arm.com, willemb@google.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] swiotlb: avoid swiotlb copy on network sockets
https://lore.kernel.org/all/20260824152932.1583506-1-lrizzo@google.com
* [PATCH v2 1/5] swiotlb: enforce pool nareas and nslabs invariants
* [PATCH v2 2/5] swiotlb/mm: Implement SWIOTLB nocopy page allocator
* [PATCH v2 3/5] net/swiotlb: Track bounce device per socket
* [PATCH v2 4/5] net: Divert socket allocations to SWIOTLB for nocopy TX
* [PATCH v2 5/5] swiotlb: Implement RX nocopy with fast recycling eviction

and found the following issue:
general protection fault in page_pool_put_unrefed_netmem

Full report is available here:
https://ci.syzbot.org/series/b17756c4-983f-4d7a-8415-3da06c0dda99

***

general protection fault in page_pool_put_unrefed_netmem

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      0a0d1d55dad570724bf8c7ea83409639cfb4be9b
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/20e51ca2-88da-4674-9797-a62c64743095/config
syz repro: https://ci.syzbot.org/findings/4385dd7f-d1fc-4627-ad19-6862c780a90c/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000082: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000410-0x0000000000000417]
CPU: 0 UID: 0 PID: 5836 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:swiotlb_addr_in_default_pool include/linux/swiotlb.h:177 [inline]
RIP: 0010:swiotlb_is_nocopy_addr include/linux/swiotlb.h:184 [inline]
RIP: 0010:__page_pool_put_page net/core/page_pool.c:851 [inline]
RIP: 0010:page_pool_put_unrefed_netmem+0x22a/0xd20 net/core/page_pool.c:930
Code: 5c 63 00 00 89 c5 31 ff 89 c6 e8 61 17 04 f8 85 ed 0f 84 07 08 00 00 e8 54 12 04 f8 49 81 c4 10 04 00 00 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 37 c7 73 f8 4d 8b 24 24 4d 85 e4
RSP: 0018:ffffc900039df230 EFLAGS: 00010206
RAX: 0000000000000082 RBX: 0000000000000000 RCX: ffff888160efda00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff89c3aca5 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8ed5a4e0 R12: 0000000000000410
R13: dffffc0000000000 R14: ffffea0004450300 R15: 0000000004450300
FS:  00007f08f83e86c0(0000) GS:ffff88818d6fc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd455a8fe8 CR3: 00000001134ac000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 page_pool_put_netmem include/net/page_pool/helpers.h:343 [inline]
 page_pool_put_full_netmem include/net/page_pool/helpers.h:373 [inline]
 napi_pp_put_page+0x133/0x1e0 net/core/skbuff.c:1036
 skb_pp_recycle net/core/skbuff.c:1047 [inline]
 skb_free_head net/core/skbuff.c:1091 [inline]
 skb_release_data+0x8c3/0xab0 net/core/skbuff.c:1122
 skb_release_all net/core/skbuff.c:1197 [inline]
 __kfree_skb+0x5d/0x210 net/core/skbuff.c:1211
 llc_rcv+0x77a/0xcb0 net/llc/llc_input.c:-1
 __netif_receive_skb_list_ptype net/core/dev.c:6312 [inline]
 __netif_receive_skb_list_core+0x784/0x830 net/core/dev.c:6354
 __netif_receive_skb_list net/core/dev.c:6406 [inline]
 netif_receive_skb_list_internal+0x995/0xcf0 net/core/dev.c:6497
 netif_receive_skb_list+0x67/0x480 net/core/dev.c:6549
 xdp_recv_frames net/bpf/test_run.c:268 [inline]
 xdp_test_run_batch net/bpf/test_run.c:349 [inline]
 bpf_test_run_xdp_live+0x1875/0x1c20 net/bpf/test_run.c:378
 bpf_prog_test_run_xdp+0x7d8/0x11d0 net/bpf/test_run.c:1463
 bpf_prog_test_run+0x2c5/0x340 kernel/bpf/syscall.c:4804
 __sys_bpf+0xa22/0xd90 kernel/bpf/syscall.c:6385
 __do_sys_bpf kernel/bpf/syscall.c:6486 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6483 [inline]
 __x64_sys_bpf+0xba/0xd0 kernel/bpf/syscall.c:6483
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f08f759e0d9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f08f83e8028 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007f08f7825fa0 RCX: 00007f08f759e0d9
RDX: 0000000000000048 RSI: 0000200000000600 RDI: 000000000000000a
RBP: 00007f08f7635024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f08f7826038 R14: 00007f08f7825fa0 R15: 00007fffc4c69778
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:swiotlb_addr_in_default_pool include/linux/swiotlb.h:177 [inline]
RIP: 0010:swiotlb_is_nocopy_addr include/linux/swiotlb.h:184 [inline]
RIP: 0010:__page_pool_put_page net/core/page_pool.c:851 [inline]
RIP: 0010:page_pool_put_unrefed_netmem+0x22a/0xd20 net/core/page_pool.c:930
Code: 5c 63 00 00 89 c5 31 ff 89 c6 e8 61 17 04 f8 85 ed 0f 84 07 08 00 00 e8 54 12 04 f8 49 81 c4 10 04 00 00 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 37 c7 73 f8 4d 8b 24 24 4d 85 e4
RSP: 0018:ffffc900039df230 EFLAGS: 00010206
RAX: 0000000000000082 RBX: 0000000000000000 RCX: ffff888160efda00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff89c3aca5 R09: 0000000000000000
R10: 0000000000000000 R11: ffffffff8ed5a4e0 R12: 0000000000000410
R13: dffffc0000000000 R14: ffffea0004450300 R15: 0000000004450300
FS:  00007f08f83e86c0(0000) GS:ffff88818d6fc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd455a8fe8 CR3: 00000001134ac000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	00 00                	add    %al,(%rax)
   2:	89 c5                	mov    %eax,%ebp
   4:	31 ff                	xor    %edi,%edi
   6:	89 c6                	mov    %eax,%esi
   8:	e8 61 17 04 f8       	call   0xf804176e
   d:	85 ed                	test   %ebp,%ebp
   f:	0f 84 07 08 00 00    	je     0x81c
  15:	e8 54 12 04 f8       	call   0xf804126e
  1a:	49 81 c4 10 04 00 00 	add    $0x410,%r12
  21:	4c 89 e0             	mov    %r12,%rax
  24:	48 c1 e8 03          	shr    $0x3,%rax
* 28:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2d:	74 08                	je     0x37
  2f:	4c 89 e7             	mov    %r12,%rdi
  32:	e8 37 c7 73 f8       	call   0xf873c76e
  37:	4d 8b 24 24          	mov    (%r12),%r12
  3b:	4d 85 e4             	test   %r12,%r12


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
