Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62DB930BB95
	for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 19:01:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762801288; cv=none; b=Y024fmtibRzasak5qNCbr9n5ztd2FBmu3s4erWfb0EnIRv562s4mNgnO2tkzhKIPU0wnKZeLoMNMxdOiHTTQwtQC/NN/scePXaraQkcRYGtnlFv02BnGpaLVIlhVTlc6JMWN60ON753DrxneguUZtb79k33Bo34xjuuHtDIn+VI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762801288; c=relaxed/simple;
	bh=btY8kp8clJxGwg6Uc28qJ564hvgEDPLQ8Cr0keqLuYc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=budcVZW9Wa9um45lImbuqjhrb6cF+kC102AH8PXGIJarSvoWS4d8lt1OVP/p6n/CFEV3h/EP9Vyax8JbhoanApR/dU1UtkOT5UTfGjKc6KdNpOEUrqH9aKKhqPa0k0y6aDz4XzPkZPc0aFZ7comoln1/jU5xsyMYVmfpUS4qNjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-43377f5ae6fso34768625ab.1
        for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 11:01:26 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762801285; x=1763406085;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=s9Iitm6IwWROjHFBsCX/8sq//n49PsCdcFX0/FQ1L+4=;
        b=udq6K4vqS1uKAwiaF7164xyDYgpJq7YVsRHdXRW0Va4ARus4ITX9eq5VmVOn0VIYjx
         +B10JUm3Br07YvrFg5btZARX0d+u0C/m4tvQHkGmR4X2dTMMecGVd1gbm45WSLjOZLTa
         8Xh+2mkPTlG+Kn0BeWCGPr9hWwFvwCmrjbbZ0+HEG0USCG8wtTWyIzXSONv7zb+KW1t/
         Wrj+GZ6dLzuxha3dc3ptz1kVm5uivb/uFYiRWbTSuPOrQQnb3xczPgyeEJxswhD98yXe
         5QNDp9iRCNzaDEC5v0jcLB4aTKfcvNCYf4LNf19aQbvsTX0fNk1qat0MaCgtI7J+nJ9+
         r3Vw==
X-Gm-Message-State: AOJu0YySlX7Pm+cysekoeDRm8IsMB/HfqbYkzWBFBFF8y95zviKzKj5G
	4KMwvPz/xSL4ZNTLdZrmq+qw84GCYKLdFrHLk9gEzI/v6IjrCRCjJrIQyTwuaSFUsg3bn2mNspN
	KD6h/TKarLea+dDU0i+k5qwag6XSKA4Fi4f76hogyrna8hAG4ztm4u++1FVM=
X-Google-Smtp-Source: AGHT+IEpp9IGyrKt+iPk+rfXBya40dC4uHUfhGOP9ay7iTWmvpuW9XvlSzjWbsMgKDXi+BITaVToZwsDdA7nqIzZCpT74OkM4A0D
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1449:b0:433:7db6:6000 with SMTP id
 e9e14a558f8ab-4337db6622fmr64016765ab.21.1762801285506; Mon, 10 Nov 2025
 11:01:25 -0800 (PST)
Date: Mon, 10 Nov 2025 11:01:25 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69123685.a70a0220.22f260.0102.GAE@google.com>
Subject: [moderation/CI] Re: make vmalloc gfp flags usage more apparent
From: syzbot ci <syzbot+ci42f6f492df103093@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] make vmalloc gfp flags usage more apparent
https://lore.kernel.org/all/20251110160457.61791-1-vishal.moola@gmail.com
* [PATCH 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
* [PATCH 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfps
* [PATCH 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
* [PATCH 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()

and found the following issue:
WARNING: kmalloc bug in bpf_prog_alloc_no_stats

Full report is available here:
https://ci.syzbot.org/series/488ab7c0-de91-4749-bbb2-ca76c3fb798b

***

WARNING: kmalloc bug in bpf_prog_alloc_no_stats

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/2334ae39-552d-4ca2-8562-7adc18ce2cb0/config

can: broadcast manager protocol
can: netlink gateway - max_hops=1
can: SAE J1939
can: isotp protocol (max_pdu_size 8300)
Bluetooth: RFCOMM TTY layer initialized
Bluetooth: RFCOMM socket layer initialized
Bluetooth: RFCOMM ver 1.11
Bluetooth: BNEP (Ethernet Emulation) ver 1.3
Bluetooth: BNEP filters: protocol multicast
Bluetooth: BNEP socket layer initialized
Bluetooth: HIDP (Human Interface Emulation) ver 1.2
Bluetooth: HIDP socket layer initialized
NET: Registered PF_RXRPC protocol family
Key type rxrpc registered
Key type rxrpc_s registered
NET: Registered PF_KCM protocol family
lec:lane_module_init: lec.c: initialized
mpoa:atm_mpoa_init: mpc.c: initialized
l2tp_core: L2TP core driver, V2.0
l2tp_ppp: PPPoL2TP kernel driver, V2.0
l2tp_ip: L2TP IP encapsulation support (L2TPv3)
l2tp_netlink: L2TP netlink interface
l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
NET: Registered PF_PHONET protocol family
8021q: 802.1Q VLAN Support v1.8
sctp: Hash tables configured (bind 32/56)
NET: Registered PF_RDS protocol family
Registered RDS/infiniband transport
Registered RDS/tcp transport
tipc: Activated (version 2.0.0)
NET: Registered PF_TIPC protocol family
tipc: Started in single node mode
smc: adding smcd device lo without pnetid
NET: Registered PF_SMC protocol family
9pnet: Installing 9P2000 support
NET: Registered PF_CAIF protocol family
NET: Registered PF_IEEE802154 protocol family
Key type dns_resolver registered
Key type ceph registered
libceph: loaded (mon/osd proto 15/24)
batman_adv: B.A.T.M.A.N. advanced 2025.4 (compatibility version 15) loaded
openvswitch: Open vSwitch switching datapath
NET: Registered PF_VSOCK protocol family
mpls_gso: MPLS GSO support
IPI shorthand broadcast: enabled
sched_clock: Marking stable (21550045890, 115271513)->(21677757748, -12440345)
registered taskstats version 1
------------[ cut here ]------------
Unexpected gfp: 0x100000 (__GFP_HARDWALL). Fixing up to gfp: 0xdc0 (GFP_KERNEL|__GFP_ZERO). Fix your code!
WARNING: CPU: 1 PID: 1 at mm/vmalloc.c:3936 vmalloc_fix_flags+0x9c/0xe0
Modules linked in:
CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
Code: 81 e6 1f 52 fe ff 89 74 24 30 81 e3 e0 ad 01 00 89 5c 24 20 90 48 c7 c7 80 b9 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 85 31 6e ff 90 <0f> 0b 90 90 8b 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
RSP: 0000:ffffc90000066d60 EFLAGS: 00010246
RAX: 50a201fad922ca00 RBX: 0000000000000dc0 RCX: ffff888160a80000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc90000066df8 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffffbfff1bba678 R12: 1ffff9200000cdac
R13: dffffc0000000000 R14: ffffc90000066d80 R15: ffffc90000066d90
FS:  0000000000000000(0000) GS:ffff8882a9f32000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000dd38000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __vmalloc_noprof+0xf2/0x120
 bpf_prog_alloc_no_stats+0x4a/0x4d0
 bpf_prog_alloc+0x3c/0x1a0
 bpf_prog_load+0x735/0x19e0
 __sys_bpf+0x507/0x860
 kern_sys_bpf+0x17d/0x6b0
 load+0x39e/0x940
 do_one_initcall+0x236/0x820
 do_initcall_level+0x104/0x190
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x334/0x4b0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x4bc/0x870
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org hch@infradead.org hch@lst.de linux-kernel@vger.kernel.org linux-mm@kvack.org urezki@gmail.com vishal.moola@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

