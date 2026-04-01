Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57D42332906
	for <syzbot@lists.linux.dev>; Wed,  1 Apr 2026 09:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775037512; cv=none; b=TtZ3n4pdYMghW4vpUTo8qWjotuI6Oy7Nx/Ojb1vpdy0bCuun4VkehTzBq2zoFmvIos4EqY+gO/T6wdrMMNcnXZcWba0ZyuBTSDedINyO9SRYIUunY7k3tJicN+1wmLf05XE+Mxizw+PZvVsoEHaWL3eKr2OkcZvhv+I/agEYYHM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775037512; c=relaxed/simple;
	bh=IrobiRxUmq6XunlqiJEJo7DFfavLQBwsu1Cbgin5UT4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=R0i1qtupw03CNoIxYfUy1fj2bT8W3j4yy5z6XbWwiMMBWpt9w4txna4ddXmnA4pwXwcjeVely36UVyCdTC7FTXRzOyR7PMxTekD7ASB1K6pp29xTbTqD3PxQt4Q0Ogz6d3L3D2eixgmTZiMAaA/ujEpjszLR2/mUit/1F0b184Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-467ec73eec1so12859786b6e.1
        for <syzbot@lists.linux.dev>; Wed, 01 Apr 2026 02:58:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775037510; x=1775642310;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+5icPIVYxCPqZtNUvuvgELDV5AE4YzjaA0NUyll3v2k=;
        b=c+2/r4ZWArq6pG3sONQh8EGLDvxgZGk+oxENFi8XEm6AUg/oK91XmjwfS3SOTxR74L
         A2rWe/HvCO3MW53/BZZ0sDFuKDb+SeoFOiH7dATDAu7K9B5KVnV8Yxmzq/gj5iY3xWgw
         79x6hZR3YWZrnpT7rwCfLPi87XqSD4XzzJMpsq/49DXo3mDPZh9BZcScOLYhsw0wcRf2
         Of0oBlnIG+mdXmT/t4ycpJcIpD3NOwrSuACZ1/rT4PVEO31/qiPnpahazoJjGBA47FWp
         XNZlJoKYt4WEuZAUG275Zm6Lr9vvtPVxtk0tFZxv5ZdFOsqkcvmnXh6yP854r4ZmnRt0
         DneA==
X-Gm-Message-State: AOJu0YzVd2La6p2IJG+0MhssyCp98GbDslmUHbwqcRZgVZycwJCWpvy3
	Mi/wjAv6QRSMpfBXbUHXVo45sfy4CGLMRa2zHRs5iRWHIMXq2plVYoD+wZNpRdA11iYAHOH9I66
	G5gJ9CqUlg+mlsjxxz/NVU7GgJse1c0vpX+uAgshQTZwot/sei3Xt4Ho3qG4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:55d5:10b0:680:17e0:4435 with SMTP id
 006d021491bc7-68017e059c1mr159944eaf.31.1775037510415; Wed, 01 Apr 2026
 02:58:30 -0700 (PDT)
Date: Wed, 01 Apr 2026 02:58:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ccec46.050a0220.183828.0042.GAE@google.com>
Subject: [moderation/CI] Re: bpf: Prep patches for static stack liveness.
From: syzbot ci <syzbot+cif3787361381ccb2b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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

The email will later be sent to:
[alexei.starovoitov@gmail.com andrii@kernel.org bpf@vger.kernel.org daniel@iogearbox.net eddyz87@gmail.com martin.lau@kernel.org memxor@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

