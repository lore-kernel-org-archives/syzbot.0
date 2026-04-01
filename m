Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 664B43DE43C
	for <syzbot@lists.linux.dev>; Wed,  1 Apr 2026 10:02:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775037755; cv=none; b=I+ui588YsmU/Hd5+JgJTLYRsBfNsoJK2bTR+cE4HTfpxSFJsFqjZlN+KRaK/MQxgae8S1CfQxMgcKaEjr+3Oc8NPZN0o4u2l3kkfaeC9ttD8WqiPnz0n03R2bmMW1JHTJdNz6fZ1G6LlOCBLzBrAopgwtQYtkWdcz9Qzhbawo+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775037755; c=relaxed/simple;
	bh=kqhomxdwlfA72G52s1CFHtNLGQBOoyy859CEMvQ4kmo=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=nL0R9OWavbidB5cvuu98gJ8Uv3rBVsL/ObxRRMe2BgmsIHSKu9JRT1eSVxOWoSdj/7pxSLeFVzyPHJyQUk6IDXL4Bi7Y9xtURknOwwVegLd9i6RstYk8nC7SZCwI43DtLhqVSWcNWHa2lnAoHxyWyhKklghhUjLLrMYClwSM7tE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-40ea48ccbd2so3013343fac.3
        for <syzbot@lists.linux.dev>; Wed, 01 Apr 2026 03:02:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775037751; x=1775642551;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=WERYNT9aA6wIU9sei+2iFDHLFAktlUqnv9kGI7xSgG4=;
        b=JLHEb87dpJW3JbdOCdbjMDwIPRkH4hE0giYo1aHS/LCI8ks8pJKf7Vx/CI7t+b4mQ1
         UWNWh49uVv5ta5GAi43nedV3ET10dAwuybx43TQDqTVQic4NrGa6R/p+07IZ6uOBAQ/V
         M9tT/hDM46orhcQcelkPcSZuPUIb+6gIdHMfstqP376d8swyMEe4S+km4S3W4CFrmftH
         OdeQSe48W/FHfs18LPLg7GvbJy0qc4YsfMBw8DKNEip9W6530SJ/NZpczlzTrsysWT9r
         Un4nbl3pUZQ10a8Px1iFY5xnZwMryBNbjzfbTUGWQuOkCzFM5TAVIq27hboxHigK4O1C
         RjHQ==
X-Gm-Message-State: AOJu0YwTgL/yC5Y/dSDd8CJ4tmupx7E/xXdg9EtXSBvaU5JTYh0WNNpL
	0TAEA4h6cMv1TdNgDraSFT0scwq/LQo51X1N0wEgy3OiHSRJGAsEtDnYs/MxlvzGEXVBA1r57D2
	msLVP+l1QJ7Mqy+xOjkNHz+E1VPmCqPbt2Ga5t/dAz6Uyj1m7uy4vIs2kidE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c94:b0:67e:36e9:79af with SMTP id
 006d021491bc7-67fabc05dd9mr1445994eaf.17.1775037751034; Wed, 01 Apr 2026
 03:02:31 -0700 (PDT)
Date: Wed, 01 Apr 2026 03:02:31 -0700
In-Reply-To: <20260401021635.34636-1-alexei.starovoitov@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69cced37.050a0220.183828.0043.GAE@google.com>
Subject: [syzbot ci] Re: bpf: Prep patches for static stack liveness.
From: syzbot ci <syzbot+cida569ba7b24f97a1@syzkaller.appspotmail.com>
To: alexei.starovoitov@gmail.com, andrii@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, eddyz87@gmail.com, martin.lau@kernel.org, 
	memxor@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] bpf: Prep patches for static stack liveness.
https://lore.kernel.org/all/20260401021635.34636-1-alexei.starovoitov@gmail.com
* [PATCH bpf-next 1/6] bpf: Do register range validation early
* [PATCH bpf-next 2/6] bpf: Sort subprogs in topological order after check_cfg()
* [PATCH bpf-next 3/6] selftests/bpf: Add tests for subprog topological ordering
* [PATCH bpf-next 4/6] bpf: Add compute_const_regs() and prune_dead_branches() passes
* [PATCH bpf-next 5/6] bpf: Move verifier helpers to header
* [PATCH bpf-next 6/6] bpf: Add helper and kfunc stack access size resolution

and found the following issue:
UBSAN: array-index-out-of-bounds in do_check

Full report is available here:
https://ci.syzbot.org/series/3bdef783-321d-4d8d-9fbb-fd61f6cd92d5

***

UBSAN: array-index-out-of-bounds in do_check

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      0eeb0094ba0321f0927806857b5f01c1577bc245
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/925251e6-c091-44e6-a321-22bd3bffd780/config

can: raw protocol
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
batman_adv: B.A.T.M.A.N. advanced 2025.5 (compatibility version 15) loaded
openvswitch: Open vSwitch switching datapath
NET: Registered PF_VSOCK protocol family
mpls_gso: MPLS GSO support
IPI shorthand broadcast: enabled
sched_clock: Marking stable (25300061146, 122105816)->(25454415888, -32248926)
registered taskstats version 1
------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in kernel/bpf/verifier.c:21704:16
index 10 is out of range for type 'u32[10]' (aka 'unsigned int[10]')
CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 ubsan_epilogue+0xa/0x30
 __ubsan_handle_out_of_bounds+0xe8/0xf0
 do_check+0x77a1/0x11d50
 do_check_common+0x21ea/0x2dc0
 bpf_check+0x242f/0x1cd90
 bpf_prog_load+0x1484/0x1ae0
 __sys_bpf+0x618/0x950
 kern_sys_bpf+0x185/0x700
 load+0x488/0xad0
 do_one_initcall+0x250/0x8d0
 do_initcall_level+0x104/0x190
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x2a6/0x3e0
 kernel_init+0x1d/0x1d0
 ret_from_fork+0x51e/0xb90
 ret_from_fork_asm+0x1a/0x30
 </TASK>
---[ end trace ]---


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
