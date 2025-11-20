Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDFBF30148A
	for <syzbot@lists.linux.dev>; Thu, 20 Nov 2025 19:38:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763667516; cv=none; b=K2FWFXhsEJ8HrvfZmpBoc/W4K+QnHIDPlrQ7js22OkXKktcR16syCPra9GDmE0wPwBwrPPzTkDQTXeGzTq3aBy0noQljYEZ/TCQUaPnImV3DhwC/hNTa3f6zdM5qx7CDnpq4t4d85yOTHcSk5wb7rSsGSo2z9WJ7SONJm9C3XuU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763667516; c=relaxed/simple;
	bh=p7PEayGIWiiAHhvvCLVaHHX9BL2YzmPYaH2I/DRIL04=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=O7nSzSetImO/rJ/NjDhEzIR9h8FKFyLvQEyuQrAxXtawp+/M4Hq61uD+3gCy8t3fHJWql9oKeX93nbGrOrURa0WeoUrNf0jr5Ozi8tfhrsD+0xROl3vHBBa968HLtO36lVDaDku/G805+KeEEHlnMNLziDhEEYpsbT6/dkT2XCk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-9489c833d89so97060139f.2
        for <syzbot@lists.linux.dev>; Thu, 20 Nov 2025 11:38:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763667513; x=1764272313;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=7U2EvJY9y3l/34s1a+9srXIK+hmyTA+ESWqYqVXm+YA=;
        b=abYEQTxTBsd1Heonr5JwGZudbsHbfNkKt9+cP8mnOskiaDoZjazJ+sSzEhUFqnStIS
         7UNRoXcxlcCJHqgSrWXXM0J5kUQXiFiK/CLBNiXEh82hjEwvPx+mwL3eD724brZRVlpB
         H+5MvOADYzk7dM/5xLZEdFLP/nHkDuq0Vz0x8e81MkFjbfxzxJfcbj8M+iBPYGGRFUz7
         Mw+INwb+wBI4mPEN4JD4A6OY2iZlgS8y2KCCLJGKf2TYDHq///TkD2/3yMivpqwVFO5u
         IbbNB8GxSOQhj/yJl/LSnYp4ipYiJUBZWnK++3KtGgvmLRt/U+Y5GYMUltYh+nbjFTTf
         SW4w==
X-Gm-Message-State: AOJu0YzurmC0+j0BbPKWV4NiOqubyswT+r5bBxO1viH/+55U+1OYQFLD
	5POEC9NiJGIGNas5uLvJJwMDSeF1vsr5b5zgrtRsrsfP62BUoup2fCcJum/V8uw4OEKxodUfVbc
	DEMs9fn2iA+yNSHgSIZRxaLLS3dHug8fJNtIF7KR/VCoqKhpE8m24lATktf8=
X-Google-Smtp-Source: AGHT+IE9k1YBfQoLhbkh7yZ6PHryohfO+z6U/1U+0LFISFh0FtzY3HBujTiCSFQCYQBsEZsl76axELRDia1OyMjCbBVPR6Tz9xQq
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16ca:b0:434:96ea:ff4f with SMTP id
 e9e14a558f8ab-435b82e9cd4mr4201025ab.40.1763667512724; Thu, 20 Nov 2025
 11:38:32 -0800 (PST)
Date: Thu, 20 Nov 2025 11:38:32 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691f6e38.a70a0220.2ea503.0036.GAE@google.com>
Subject: [moderation/CI] Re: tun/tap & vhost-net: netdev queue flow control to
 avoid ptr_ring tail drop
From: syzbot ci <syzbot+ciba1a7e42af782cc8@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v6] tun/tap & vhost-net: netdev queue flow control to avoid ptr_ring tail =
drop
https://lore.kernel.org/all/20251120152914.1127975-1-simon.schippers@tu-dor=
tmund.de
* [PATCH net-next v6 1/8] ptr_ring: add __ptr_ring_full_next() to predict i=
mminent fullness
* [PATCH net-next v6 2/8] ptr_ring: add helper to check if consume created =
space
* [PATCH net-next v6 3/8] tun/tap: add synchronized ring produce/consume wi=
th queue management
* [PATCH net-next v6 4/8] tun/tap: add batched ring consume function
* [PATCH net-next v6 5/8] tun/tap: add uncomsume function for returning ent=
ries to ring
* [PATCH net-next v6 6/8] tun/tap: add helper functions to check file type
* [PATCH net-next v6 7/8] tun/tap/vhost: use {tun|tap}_ring_{consume|produc=
e} to avoid tail drops
* [PATCH net-next v6 8/8] tun/tap: drop get ring exports

and found the following issue:
general protection fault in tun_net_xmit

Full report is available here:
https://ci.syzbot.org/series/63c35694-3fa6-48b6-ba11-f893f55bcc1a

***

general protection fault in tun_net_xmit

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      45a1cd8346ca245a1ca475b26eb6ceb9d8b7c6f0
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/e1084fb4-2e0a-4c87-8e42-bc8fa70e1c7=
7/config
syz repro: https://ci.syzbot.org/findings/cf1c9121-7e31-4bc8-a254-f9e6c8ee2=
d26/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000002: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 UID: 0 PID: 13 Comm: kworker/u8:1 Not tainted syzkaller #0 PREEMPT(f=
ull)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Workqueue: ipv6_addrconf addrconf_dad_work
RIP: 0010:__ptr_ring_full include/linux/ptr_ring.h:51 [inline]
RIP: 0010:tun_ring_produce drivers/net/tun.c:1023 [inline]
RIP: 0010:tun_net_xmit+0xdf0/0x1840 drivers/net/tun.c:1164
Code: 00 00 00 fc ff df 48 89 44 24 50 0f b6 04 18 84 c0 0f 85 1f 07 00 00 =
4c 89 7c 24 30 4d 63 37 4f 8d 3c f4 4c 89 f8 48 c1 e8 03 <80> 3c 18 00 74 0=
8 4c 89 ff e8 92 ba e3 fb 49 83 3f 00 74 0a e8 17
RSP: 0018:ffffc90000126f80 EFLAGS: 00010202
RAX: 0000000000000002 RBX: dffffc0000000000 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90000126f00
RBP: ffffc900001270b0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000024de0 R12: 0000000000000010
R13: ffff8881730b6a48 R14: 0000000000000000 R15: 0000000000000010
FS:  0000000000000000(0000) GS:ffff8882a9f38000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000002280 CR3: 00000001bb189000 CR4: 0000000000352ef0
Call Trace:
 <TASK>
 __netdev_start_xmit include/linux/netdevice.h:5259 [inline]
 netdev_start_xmit include/linux/netdevice.h:5268 [inline]
 xmit_one net/core/dev.c:3853 [inline]
 dev_hard_start_xmit+0x2d7/0x830 net/core/dev.c:3869
 __dev_queue_xmit+0x172a/0x3740 net/core/dev.c:4811
 neigh_output include/net/neighbour.h:556 [inline]
 ip6_finish_output2+0xfb3/0x1480 net/ipv6/ip6_output.c:136
 NF_HOOK_COND include/linux/netfilter.h:307 [inline]
 ip6_output+0x340/0x550 net/ipv6/ip6_output.c:247
 NF_HOOK include/linux/netfilter.h:318 [inline]
 ndisc_send_skb+0xbce/0x1510 net/ipv6/ndisc.c:512
 addrconf_dad_completed+0x7ae/0xd60 net/ipv6/addrconf.c:4360
 addrconf_dad_work+0xc36/0x14b0 net/ipv6/addrconf.c:-1
 process_one_work kernel/workqueue.c:3263 [inline]
 process_scheduled_works+0xae1/0x17b0 kernel/workqueue.c:3346
 worker_thread+0x8a0/0xda0 kernel/workqueue.c:3427
 kthread+0x711/0x8a0 kernel/kthread.c:463
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__ptr_ring_full include/linux/ptr_ring.h:51 [inline]
RIP: 0010:tun_ring_produce drivers/net/tun.c:1023 [inline]
RIP: 0010:tun_net_xmit+0xdf0/0x1840 drivers/net/tun.c:1164
Code: 00 00 00 fc ff df 48 89 44 24 50 0f b6 04 18 84 c0 0f 85 1f 07 00 00 =
4c 89 7c 24 30 4d 63 37 4f 8d 3c f4 4c 89 f8 48 c1 e8 03 <80> 3c 18 00 74 0=
8 4c 89 ff e8 92 ba e3 fb 49 83 3f 00 74 0a e8 17
RSP: 0018:ffffc90000126f80 EFLAGS: 00010202
RAX: 0000000000000002 RBX: dffffc0000000000 RCX: dffffc0000000000
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc90000126f00
RBP: ffffc900001270b0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000024de0 R12: 0000000000000010
R13: ffff8881730b6a48 R14: 0000000000000000 R15: 0000000000000010
FS:  0000000000000000(0000) GS:ffff8882a9f38000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000002280 CR3: 00000001bb189000 CR4: 0000000000352ef0
----------------
Code disassembly (best guess), 5 bytes skipped:
   0:	df 48 89             	fisttps -0x77(%rax)
   3:	44 24 50             	rex.R and $0x50,%al
   6:	0f b6 04 18          	movzbl (%rax,%rbx,1),%eax
   a:	84 c0                	test   %al,%al
   c:	0f 85 1f 07 00 00    	jne    0x731
  12:	4c 89 7c 24 30       	mov    %r15,0x30(%rsp)
  17:	4d 63 37             	movslq (%r15),%r14
  1a:	4f 8d 3c f4          	lea    (%r12,%r14,8),%r15
  1e:	4c 89 f8             	mov    %r15,%rax
  21:	48 c1 e8 03          	shr    $0x3,%rax
* 25:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1) <-- trapping instruct=
ion
  29:	74 08                	je     0x33
  2b:	4c 89 ff             	mov    %r15,%rdi
  2e:	e8 92 ba e3 fb       	call   0xfbe3bac5
  33:	49 83 3f 00          	cmpq   $0x0,(%r15)
  37:	74 0a                	je     0x43
  39:	e8                   	.byte 0xe8
  3a:	17                   	(bad)


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch davem@davemloft.net edumazet@google.com eperezma@redhat.com=
 jasowang@redhat.com jon@nutanix.com kuba@kernel.org kvm@vger.kernel.org li=
nux-kernel@vger.kernel.org mst@redhat.com netdev@vger.kernel.org pabeni@red=
hat.com simon.schippers@tu-dortmund.de tim.gebauer@tu-dortmund.de virtualiz=
ation@lists.linux.dev willemdebruijn.kernel@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

