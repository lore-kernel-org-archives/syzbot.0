Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8E081A295
	for <syzbot@lists.linux.dev>; Tue, 25 Nov 2025 02:47:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764038837; cv=none; b=Q+DfBL7l/0JRE01IMU6aibDvFDAOtZvH9LuJeVismXtsZKTBp/0706emvpEB9qwx94F952OyCWIRxQUoCVJhaxdT1Zc2tP7U5tb7NNR1XggDLS3vVto/gc8FpCRDg1i9KfT0nRDBJRERAVMDbWIucdWA/8dHQw0S/aenBLtVOT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764038837; c=relaxed/simple;
	bh=RfxoxSwi7GdpRtGeXE+ofZHnDLGgrSg08CFYNnDNu5c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=kyuLNAJLR0+Z1jp3eueN4htxx/IDE9FqNsYx+Tt7iok5m3YfaiKKrs/cvJ0YZQOmbduOedg0S0ibDoJrOyLweWLZHUhvjiThpOZk0wNYeZpGRpvTr2/VDuloYoFgcNpNSaSN4R5QlQ7SKZd/jFBMzCGaso8F0sfDujpUBNRhByQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-43323ffc26bso34568325ab.0
        for <syzbot@lists.linux.dev>; Mon, 24 Nov 2025 18:47:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764038835; x=1764643635;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=M1FGp+9laYzxxV4Y7EXOJ6JahK10FT1ESMIUTt0OWD4=;
        b=bkbaUVnvt0+QUwnNhieflG3JGSMlR62bLY0hEkncj5ogc9CFb+S2eDedmnW4S1SjyY
         NAKDxaUuTkXMuDWCa2rRCFeoMcNN3A1F9fID1gorAJ6+aUB7nvySe57IUMuutvKa/cgr
         QFmthznAis587YTMQRtFVdYe3TDkXSt8OwH+GCn8d6usH218tECtUY+VFmKiJs1iGejK
         uEFSaq4azGp/TCEWoYrBQ722eINnqg68L4tRJ9CPDc5yYALW0hpWMCDUxW6zYAN2dslk
         TdFa8howt8SdRc5Yu3/TZTsmhLrTw1AE4eeByfhONphoNGs1zE6jqliRW6+oeP8HCqEC
         UOHw==
X-Gm-Message-State: AOJu0YyI5U58ciS20WDvdIA336Fy7Rebk9CabaZtz9gBhh1cjU0Urof4
	lImmLx4Zm7Rl6ZXs7jhFIQ05BRGHVwcQhs6Ci3hGt40eyOzisYlsyGx3D5LmM+Ml33r2ASzsP7d
	ZaFLhhMIXNeodwntK5yupHkBOgtn3yAVk2XoRLotRVHZZFA+SFSQpMUTs/dc=
X-Google-Smtp-Source: AGHT+IEhsBygHoUc1m8L05Mo/pNyEFuoLzD2tZmaFmxxBdCl6+4bH0SkR7GwxfxShJEglWRQC7oYRB5ALwj6u9KgYSkb2dW/PNvR
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fe8:b0:432:10f9:5e0a with SMTP id
 e9e14a558f8ab-435b98c55e7mr91812785ab.19.1764038834988; Mon, 24 Nov 2025
 18:47:14 -0800 (PST)
Date: Mon, 24 Nov 2025 18:47:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692518b2.a70a0220.d98e3.009a.GAE@google.com>
Subject: [moderation/CI] Re: net/sched: Introduce qdisc quirk_chk op
From: syzbot ci <syzbot+ci798f5b5691de2127@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net/sched: Introduce qdisc quirk_chk op
https://lore.kernel.org/all/20251124223749.503979-1-victor@mojatatu.com
* [RFC PATCH net-next] net/sched: Introduce qdisc quirk_chk op

and found the following issue:
general protection fault in netem_quirk_chk

Full report is available here:
https://ci.syzbot.org/series/0ba1b5b2-32e5-45b5-9ede-1290a7852d5e

***

general protection fault in netem_quirk_chk

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      e2c20036a8879476c88002730d8a27f4e3c32d4b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/0064d8bc-3c48-4267-9b5e-0f43a8514002/config
C repro:   https://ci.syzbot.org/findings/17d4a158-13d5-439e-8a4d-10e6e40a2ab1/c_repro
syz repro: https://ci.syzbot.org/findings/17d4a158-13d5-439e-8a4d-10e6e40a2ab1/syz_repro

netlink: 28 bytes leftover after parsing attributes in process `syz.0.17'.
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
CPU: 1 UID: 0 PID: 5959 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:netem_quirk_chk+0x37/0x660 net/sched/sch_netem.c:999
Code: 53 48 83 ec 30 48 89 54 24 08 49 89 f7 48 89 fd 49 be 00 00 00 00 00 fc ff df e8 e4 68 67 f8 49 83 c7 14 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 0f 85 a0 05 00 00 41 8b 37 31 ff 89 74 24 04
RSP: 0018:ffffc90003737260 EFLAGS: 00010203
RAX: 0000000000000002 RBX: dffffc0000000000 RCX: ffff888113168000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881139f3000
RBP: ffff8881139f3000 R08: ffff888113168000 R09: 0000000000000002
R10: 00000000fffffff1 R11: ffffffff89589ab0 R12: ffff8881166a0000
R13: ffffffff89589ab0 R14: dffffc0000000000 R15: 0000000000000014
FS:  0000555559c83500(0000) GS:ffff8882a9f35000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000100 CR3: 000000010a1b0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 qdisc_create+0x73f/0xf10 net/sched/sch_api.c:1319
 __tc_modify_qdisc net/sched/sch_api.c:1765 [inline]
 tc_modify_qdisc+0x1582/0x2140 net/sched/sch_api.c:1829
 rtnetlink_rcv_msg+0x77c/0xb70 net/core/rtnetlink.c:6967
 netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2550
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:727 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:742
 ____sys_sendmsg+0x505/0x830 net/socket.c:2630
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
 __sys_sendmsg net/socket.c:2716 [inline]
 __do_sys_sendmsg net/socket.c:2721 [inline]
 __se_sys_sendmsg net/socket.c:2719 [inline]
 __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe6bff8f749
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff10f91288 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fe6c01e5fa0 RCX: 00007fe6bff8f749
RDX: 0000000000000000 RSI: 0000200000000000 RDI: 0000000000000003
RBP: 00007fe6c0013f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe6c01e5fa0 R14: 00007fe6c01e5fa0 R15: 0000000000000003
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:netem_quirk_chk+0x37/0x660 net/sched/sch_netem.c:999
Code: 53 48 83 ec 30 48 89 54 24 08 49 89 f7 48 89 fd 49 be 00 00 00 00 00 fc ff df e8 e4 68 67 f8 49 83 c7 14 4c 89 f8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 0f 85 a0 05 00 00 41 8b 37 31 ff 89 74 24 04
RSP: 0018:ffffc90003737260 EFLAGS: 00010203
RAX: 0000000000000002 RBX: dffffc0000000000 RCX: ffff888113168000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff8881139f3000
RBP: ffff8881139f3000 R08: ffff888113168000 R09: 0000000000000002
R10: 00000000fffffff1 R11: ffffffff89589ab0 R12: ffff8881166a0000
R13: ffffffff89589ab0 R14: dffffc0000000000 R15: 0000000000000014
FS:  0000555559c83500(0000) GS:ffff8882a9f35000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000100 CR3: 000000010a1b0000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	53                   	push   %rbx
   1:	48 83 ec 30          	sub    $0x30,%rsp
   5:	48 89 54 24 08       	mov    %rdx,0x8(%rsp)
   a:	49 89 f7             	mov    %rsi,%r15
   d:	48 89 fd             	mov    %rdi,%rbp
  10:	49 be 00 00 00 00 00 	movabs $0xdffffc0000000000,%r14
  17:	fc ff df
  1a:	e8 e4 68 67 f8       	call   0xf8676903
  1f:	49 83 c7 14          	add    $0x14,%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 30       	movzbl (%rax,%r14,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 a0 05 00 00    	jne    0x5d7
  37:	41 8b 37             	mov    (%r15),%esi
  3a:	31 ff                	xor    %edi,%edi
  3c:	89 74 24 04          	mov    %esi,0x4(%rsp)


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[davem@davemloft.net edumazet@google.com jhs@mojatatu.com jiri@resnulli.us kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com victor@mojatatu.com xiyou.wangcong@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

