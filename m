Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E14591D61A3
	for <syzbot@lists.linux.dev>; Tue, 18 Nov 2025 13:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763472326; cv=none; b=FiJSMgpT0B/ldMNHNEMAXl1lSsQ68Es/uG22Wpqedo48JOlm5XHB39oBaZtKKfyIMMlXLqaz8f3+AZUMbTf2GHSDHpQDRZuQ+e4DnKJx+krT3WZ7s81c5x7RZJ3/GIWGn44LZcUxlvfMvIVm8w2D23aGuIhmMYNxpvETiiQ/H70=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763472326; c=relaxed/simple;
	bh=97anun/PikHevNIR0CNyiFOjzcQSlBNGRejCx2bt9s0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=eoGjgBuKAk97sLrS1I9zIe6Fk/AJ4YTZ7Fv6ZWsY9/iOwmTXWCf6X71FX8vDKF2AkyQ1Ye46houwpZ266mxjn9iPEDYRsMewK+yn4DgmcXRjnT7T5MfzoPUlRkd058vc6f4SskhB/hc9Mbs0G7BNVY5+j4fCZUDoNu8JUYY84Aw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-433154d39abso128524155ab.0
        for <syzbot@lists.linux.dev>; Tue, 18 Nov 2025 05:25:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763472324; x=1764077124;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P+jMW6AOi1L4wmXbCYJB7d3eDc2nBelPWsZ86LyxCWQ=;
        b=mGs5PsS6Xy//HT0vAwuvzjn+NjpanFjnU3gz5bUhh1W0n+H4MGOihqHfKvoHtUGsPm
         59GGudAsntWlvK0twgymuM7+GCYXBHLYK4DoAubH8hNVu4Dmk/rckCqVIH2+CZRvaw7G
         KNYpxZunuzLJ8qcDsm/aPj6YPbRCcfNI3EYGiGZrEWa1O9+N4ytwfgYwMleeusnuaXqc
         MZq0+54DKRYEhD6preh7TxGlcVEpM7qadzzK9n7ARZCo84x0OuXx7VaSBuwil1xl9rr+
         VCQanIOZJWG1TpWr4M2JKjZyM+ZdMlB+2sgurR0H0lnq25pQ2XNYx0lWkhksloW4QTBh
         k5Og==
X-Gm-Message-State: AOJu0Yw+59Q7RNaiRJ9nBZ1rIJUAhQV42HCldHCKD2gOiZPcT+DnurzV
	5RPRqiIvmJzB7MT8yeEWRLbmHlgt7E2AoKauL1YVWhIPHFHvhraZIf84jjAFjVj7xbdbbx7yccq
	nSHLwN/aA8ZZzeOUvitfx3TtWqfgJkGnzXx+X8MqgN6Dfu++scnGSm+ylMUA=
X-Google-Smtp-Source: AGHT+IEInUMNyjKNhe83hHYavnBSTgQEylM7Bjwzy9gsl5JEh7WY9M+SbyQ0Cp590EbBSsdd+JbBBNiNFNwXhTyRtvdYl4ukJ6hD
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2282:b0:434:a88d:f80f with SMTP id
 e9e14a558f8ab-434a88dfaa8mr75229975ab.5.1763472323950; Tue, 18 Nov 2025
 05:25:23 -0800 (PST)
Date: Tue, 18 Nov 2025 05:25:23 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691c73c3.a70a0220.3124cb.00c7.GAE@google.com>
Subject: [moderation/CI] Re: ipvlan: support mac-nat mode
From: syzbot ci <syzbot+cif71652b69cb8251b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] ipvlan: support mac-nat mode
https://lore.kernel.org/all/20251118100046.2944392-1-skorodumov.dmitry@huaw=
ei.com
* [PATCH net-next 01/13] ipvlan: Support MACNAT mode
* [PATCH net-next 02/13] ipvlan: macnat: Handle rx mcast-ip and unicast eth
* [PATCH net-next 03/13] ipvlan: Forget all IP when device goes down
* [PATCH net-next 04/13] ipvlan: Support IPv6 in macnat mode.
* [PATCH net-next 05/13] ipvlan: Fix compilation warning about __be32 -> u3=
2
* [PATCH net-next 06/13] ipvlan: Make the addrs_lock be per port
* [PATCH net-next 07/13] ipvlan: Take addr_lock in ipvlan_open()
* [PATCH net-next 08/13] ipvlan: Don't allow children to use IPs of main
* [PATCH net-next 09/13] ipvlan: const-specifier for functions that use iad=
dr
* [PATCH net-next 10/13] ipvlan: Common code from v6/v4 validator_event
* [PATCH net-next 11/13] ipvlan: common code to handle ipv6/ipv4 address ev=
ents
* [PATCH net-next 12/13] ipvlan: Ignore PACKET_LOOPBACK in handle_mode_l2()
* [PATCH net-next 13/13] selftests: drv-net: selftest for ipvlan-macnat mod=
e

and found the following issue:
WARNING: suspicious RCU usage in ipvlan_addr_event

Full report is available here:
https://ci.syzbot.org/series/e483b93a-1063-4c8a-b0e2-89530e79768b

***

WARNING: suspicious RCU usage in ipvlan_addr_event

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      c99ebb6132595b4b288a413981197eb076547c5a
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/ac5af6f3-6b14-4e35-9d81-ee1522de395=
2/config

8021q: adding VLAN 0 to HW filter on device batadv0
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D
WARNING: suspicious RCU usage
syzkaller #0 Not tainted
-----------------------------
drivers/net/ipvlan/ipvlan.h:128 suspicious rcu_dereference_check() usage!

other info that might help us debug this:


rcu_scheduler_active =3D 2, debug_locks =3D 1
2 locks held by syz-executor/5984:
 #0: ffffffff8f2cc248 (rtnl_mutex){+.+.}-{4:4}, at: inet_rtm_newaddr+0x3b0/=
0x18b0
 #1: ffffffff8f39d9b0 ((inetaddr_chain).rwsem){++++}-{4:4}, at: blocking_no=
tifier_call_chain+0x54/0x90

stack backtrace:
CPU: 1 UID: 0 PID: 5984 Comm: syz-executor Not tainted syzkaller #0 PREEMPT=
(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250
 lockdep_rcu_suspicious+0x140/0x1d0
 ipvlan_addr_event+0x60b/0x950
 notifier_call_chain+0x1b6/0x3e0
 blocking_notifier_call_chain+0x6a/0x90
 __inet_insert_ifa+0xa13/0xbf0
 inet_rtm_newaddr+0xf3a/0x18b0
 rtnetlink_rcv_msg+0x7cf/0xb70
 netlink_rcv_skb+0x208/0x470
 netlink_unicast+0x82f/0x9e0
 netlink_sendmsg+0x805/0xb30
 __sock_sendmsg+0x21c/0x270
 __sys_sendto+0x3bd/0x520
 __x64_sys_sendto+0xde/0x100
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f711f191503
Code: 64 89 02 48 c7 c0 ff ff ff ff eb b7 66 2e 0f 1f 84 00 00 00 00 00 90 =
80 3d 61 70 22 00 00 41 89 ca 74 14 b8 2c 00 00 00 0f 05 <48> 3d 00 f0 ff f=
f 77 75 c3 0f 1f 40 00 55 48 83 ec 30 44 89 4c 24
RSP: 002b:00007ffc44b05f28 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007f711ff14620 RCX: 00007f711f191503
RDX: 0000000000000028 RSI: 00007f711ff14670 RDI: 0000000000000003
RBP: 0000000000000001 R08: 00007ffc44b05f44 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f711ff14670 R15: 0000000000000000
 </TASK>
syz-executor (5984) used greatest stack depth: 19864 bytes left


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch andrey.bokhanko@huawei.com corbet@lwn.net davem@davemloft.n=
et edumazet@google.com horms@kernel.org kuba@kernel.org linux-doc@vger.kern=
el.org linux-kernel@vger.kernel.org linux-kselftest@vger.kernel.org netdev@=
vger.kernel.org pabeni@redhat.com shuah@kernel.org skorodumov.dmitry@huawei=
.com]

If the report looks fine to you, reply with:
#syz upstream

