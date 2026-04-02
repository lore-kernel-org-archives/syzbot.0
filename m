Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D450D32E141
	for <syzbot@lists.linux.dev>; Thu,  2 Apr 2026 12:53:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775134432; cv=none; b=uL4FkmNVkTC9bg9FQsGXDSn0+mWYZxqoC5QpHjA7g0weKI/q+TvIc/YmZj2p1Vu6nMRV2XOoZ1KtlL+u6MmlLvEZMMA+m9ABPSySEvXd326YkDwHmA7P7575UK82PZLTtEl+K4oJAV4QDdi4U2G0V3rABk+bzNFE3g/Ilwz8EVo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775134432; c=relaxed/simple;
	bh=ciCWzp4i7M0EEgSvwJCN8MhlVMDFmp8QKXPKVV7o0eA=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=cBrslOwSOLaIFJst+VAYjfZ3kc2ObL6dneQvRkX6NMkZYD7bXGUY8++IOGw+byFzrFccPS0+uSBveYg+tXYk54G07F8LcFD9cHdu9N8ohkQjgFcJtWh9p7Cgc8ZBPsVuAe1yOoRPxZHB1Kkm3mxyvNleaUbvTYWZGxLBHLXhuKM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-41702ea8343so1233463fac.0
        for <syzbot@lists.linux.dev>; Thu, 02 Apr 2026 05:53:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775134426; x=1775739226;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=QBgPDXy0CDc09Df8kPHI5V1lc4XrhEWV+2zpnUUOEFk=;
        b=l1RUer6KfDJpF/FoRYr925zXCN/D1iHFcT+OsU2em0dQx/i8PDpXHaGu/bQpk6o7ma
         z3bVQjO6EsKF/lrIAhP1cYDuxCx/7vB3hM5QzX6HPJEgo2Bj/N7suPPw0Rc3rWFoGPid
         4w8i3WgzkOg78nf8+c85z8XzuJfbKHsACoSWgMA4x/YVv4FM/oRhtuCIXxo/iq5mlwzk
         s7OmJH0NoazFVztbIfIDfbFclwWLdUjRsvKm7TeQlGop44KF5qozBFhzHxiYxgbFQv1E
         DzcUmofSq1l7JmCW6dL/CW7CstZAn/WBZDclBou+gG8lq9vlbpvfZHqUly195muaRcNj
         nJgg==
X-Gm-Message-State: AOJu0YxTT3EVbYHegU5Ms28Bhxdty1iPxPm1C+Ht1li/jtcuYdnOAKfo
	zKeFzd7K1dOyKn8jcLRtyrsAEcvfa4R8S3hoIfy/uiVT6nBEbgoG5fqj/hAiwu4U9rOB92xzjxc
	hO15lP9qipeV+8xxildt99SDikLDJox/WXrjDBWV3bqUoepEUoUesK5AxYLg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1809:b0:67e:3e13:3315 with SMTP id
 006d021491bc7-67fabca40d9mr3488597eaf.34.1775134426172; Thu, 02 Apr 2026
 05:53:46 -0700 (PDT)
Date: Thu, 02 Apr 2026 05:53:46 -0700
In-Reply-To: <20260402061744.10885-1-alexei.starovoitov@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ce66da.050a0220.2dbe29.0005.GAE@google.com>
Subject: [syzbot ci] Re: bpf: Prep patches for static stack liveness.
From: syzbot ci <syzbot+ci5d1af9c009034c4e@syzkaller.appspotmail.com>
To: alexei.starovoitov@gmail.com, andrii@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, eddyz87@gmail.com, martin.lau@kernel.org, 
	memxor@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] bpf: Prep patches for static stack liveness.
https://lore.kernel.org/all/20260402061744.10885-1-alexei.starovoitov@gmail.com
* [PATCH v2 bpf-next 1/6] bpf: Do register range validation early
* [PATCH v2 bpf-next 2/6] bpf: Sort subprogs in topological order after check_cfg()
* [PATCH v2 bpf-next 3/6] selftests/bpf: Add tests for subprog topological ordering
* [PATCH v2 bpf-next 4/6] bpf: Add bpf_compute_const_regs() and bpf_prune_dead_branches() passes
* [PATCH v2 bpf-next 5/6] bpf: Move verifier helpers to header
* [PATCH v2 bpf-next 6/6] bpf: Add helper and kfunc stack access size resolution

and found the following issue:
UBSAN: array-index-out-of-bounds in do_check

Full report is available here:
https://ci.syzbot.org/series/472db170-a3e5-4e2f-992a-f066f3ec68a0

***

UBSAN: array-index-out-of-bounds in do_check

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      0eeb0094ba0321f0927806857b5f01c1577bc245
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/35679c0d-9085-497b-89c5-d447be366fc7/config

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
sched_clock: Marking stable (24350040289, 119535998)->(24496627492, -27051205)
registered taskstats version 1
------------[ cut here ]------------
UBSAN: array-index-out-of-bounds in kernel/bpf/verifier.c:21711:16
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
