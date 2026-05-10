Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80B3926D4F9
	for <syzbot@lists.linux.dev>; Sun, 10 May 2026 11:45:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778413521; cv=none; b=VGN46EAO8AOZi9tC60t5LcCRxYFaqjBY83Zti7Hyi3KXucQ5vWGIGafrfVZzj43Qays4gOS4JGuGivzhFG03CCn2s/IH8k4gp4hXwg/1DCYBNwMnK/WWRLSePCtUfh0tAy7Xz53BdepsJSSRk56+4czezUscv/UPy/Y29tv3F0M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778413521; c=relaxed/simple;
	bh=f7vDKd9emGoBZY0kKk+9Q6i+eApjgd4gnN1hfxTgzLI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=AcqTCrWEReXGfwh4iPqick4cBADk4/Gv35eGarJHRgBUx2xJZ9oTHfx1Ft8OqCf3fnyFABkVvOkVLHja/mdmrhEXb5/VrbkJmApJ6NGBUGDNS5qaNDbmKmL4OwEINOR36q755AjjR6/AIDVgVrMihxykIGMvY4qgUjXTEyYRt0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-69644bda339so7885072eaf.1
        for <syzbot@lists.linux.dev>; Sun, 10 May 2026 04:45:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778413518; x=1779018318;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=u1S0jhFosikT+aSVaZZXhcknVPXPdrZL1cz+mO2KiWI=;
        b=Cny+MOsyECkarRtbiN6p7vZOBMrurYgsQ3CklQpqLFzcUz52DxSpYmKaOUBfdUDLw1
         e4jJrI/94ZOgQVx3mfDVCo9ofdTEx4qknG3ernQja+ZRfkiUYby3QH0YpmX/2w0xnSyo
         lZtDyMpNmbE8Nb87jSD/XjY7Skfekxxocgja7lveaJMxxjqOeQ3mRu5ILaxs/8j/DPcz
         c81LBsx8imyNT8ycbZuX74LJmsSxxkcIP6rDvby5X3ym3+i/ycdyN9nHEaNLuswi9+X2
         yXv76Mzec5ga/u0FUdIs6+eQZQ/wJ9l30Rz+BLLEThVl8VYyga9f2TbTJPn6uQTHAT/n
         ljYA==
X-Gm-Message-State: AOJu0Yy0FvCx9ZuVx42P2HJfirr6TRoXeK6wJW7gWlxuoO4zLthy2qIO
	GQgkPujMOuYvEO7Ow6SQSl3L7ss2D4MNOepnQP51BA+yj8biFyVaVLZX2KvHj08vY/zNm7yl39X
	74aZ1XMId9YxjtX5AC2uKiMia6zIxwqK4tBrSZH4P/EZVZys9nx+WPY6V3Yg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:d84b:0:b0:695:94b4:d4cc with SMTP id
 006d021491bc7-699ab57164amr5015199eaf.1.1778413518490; Sun, 10 May 2026
 04:45:18 -0700 (PDT)
Date: Sun, 10 May 2026 04:45:18 -0700
In-Reply-To: <67e8340baa2c2772def267a801c8d5b201444d49.1778382236.git.caoruide123@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a006fce.a00a0220.1c3806.000f.GAE@google.com>
Subject: [syzbot ci] Re: net: nsh: limit recursive GSO redispatch
From: syzbot ci <syzbot+ci4085cfa6e79bb05c@syzkaller.appspotmail.com>
To: bird@lzu.edu.cn, caoruide123@gmail.com, davem@davemloft.net, 
	jbenc@redhat.com, lkp@intel.com, lx24@stu.ynu.edu.cn, matttbe@kernel.org, 
	n05ec@lzu.edu.cn, netdev@vger.kernel.org, tomapufckgml@gmail.com, 
	yifanwucs@gmail.com, yuantan098@gmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] net: nsh: limit recursive GSO redispatch
https://lore.kernel.org/all/67e8340baa2c2772def267a801c8d5b201444d49.1778382236.git.caoruide123@gmail.com
* [PATCH net v2 1/1] net: nsh: limit recursive GSO redispatch

and found the following issue:
BUG: using __this_cpu_read() in preemptible code in nsh_gso_segment

Full report is available here:
https://ci.syzbot.org/series/cb23e640-2f7a-42e1-8bad-7249684b1cd5

***

BUG: using __this_cpu_read() in preemptible code in nsh_gso_segment

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      496c0c4c53bbe1bad97e82cd12103df61a6e459d
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/a7e3d1e1-97c4-4876-99c8-658c4cef49c5/config
syz repro: https://ci.syzbot.org/findings/62ca20c2-7c78-4820-b695-f63b15eaf738/syz_repro

BUG: using __this_cpu_read() in preemptible [00000000] code: syz.1.18/5860
caller is dev_xmit_recursion include/linux/netdevice.h:3625 [inline]
caller is nsh_gso_segment+0x535/0xed0 net/nsh/nsh.c:110
CPU: 0 UID: 0 PID: 5860 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
 dev_xmit_recursion include/linux/netdevice.h:3625 [inline]
 nsh_gso_segment+0x535/0xed0 net/nsh/nsh.c:110
 skb_mac_gso_segment+0x31c/0x690 net/core/gso.c:53
 __skb_gso_segment+0x376/0x540 net/core/gso.c:124
 skb_gso_segment include/net/gso.h:83 [inline]
 validate_xmit_skb+0xa21/0x14a0 net/core/dev.c:4039
 validate_xmit_skb_list net/core/dev.c:4089 [inline]
 __dev_direct_xmit+0x1b4/0x750 net/core/dev.c:4922
 dev_direct_xmit include/linux/netdevice.h:3431 [inline]
 packet_xmit+0x1b4/0x320 net/packet/af_packet.c:285
 packet_snd net/packet/af_packet.c:3082 [inline]
 packet_sendmsg+0x3c81/0x4fb0 net/packet/af_packet.c:3114
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 __sys_sendto+0x672/0x710 net/socket.c:2265
 __do_sys_sendto net/socket.c:2272 [inline]
 __se_sys_sendto net/socket.c:2268 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2268
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcd6a99cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fcd6b903028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007fcd6ac15fa0 RCX: 00007fcd6a99cdd9
RDX: 00000000000100a6 RSI: 0000200000000180 RDI: 0000000000000005
RBP: 00007fcd6aa32d69 R08: 0000200000000140 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fcd6ac16038 R14: 00007fcd6ac15fa0 R15: 00007fff57a83608
 </TASK>
BUG: using __this_cpu_add() in preemptible [00000000] code: syz.1.18/5860
caller is dev_xmit_recursion_inc include/linux/netdevice.h:3631 [inline]
caller is nsh_gso_segment+0x57d/0xed0 net/nsh/nsh.c:113
CPU: 0 UID: 0 PID: 5860 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
 dev_xmit_recursion_inc include/linux/netdevice.h:3631 [inline]
 nsh_gso_segment+0x57d/0xed0 net/nsh/nsh.c:113
 skb_mac_gso_segment+0x31c/0x690 net/core/gso.c:53
 __skb_gso_segment+0x376/0x540 net/core/gso.c:124
 skb_gso_segment include/net/gso.h:83 [inline]
 validate_xmit_skb+0xa21/0x14a0 net/core/dev.c:4039
 validate_xmit_skb_list net/core/dev.c:4089 [inline]
 __dev_direct_xmit+0x1b4/0x750 net/core/dev.c:4922
 dev_direct_xmit include/linux/netdevice.h:3431 [inline]
 packet_xmit+0x1b4/0x320 net/packet/af_packet.c:285
 packet_snd net/packet/af_packet.c:3082 [inline]
 packet_sendmsg+0x3c81/0x4fb0 net/packet/af_packet.c:3114
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 __sys_sendto+0x672/0x710 net/socket.c:2265
 __do_sys_sendto net/socket.c:2272 [inline]
 __se_sys_sendto net/socket.c:2268 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2268
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcd6a99cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fcd6b903028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007fcd6ac15fa0 RCX: 00007fcd6a99cdd9
RDX: 00000000000100a6 RSI: 0000200000000180 RDI: 0000000000000005
RBP: 00007fcd6aa32d69 R08: 0000200000000140 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fcd6ac16038 R14: 00007fcd6ac15fa0 R15: 00007fff57a83608
 </TASK>
BUG: using __this_cpu_add() in preemptible [00000000] code: syz.1.18/5860
caller is dev_xmit_recursion_dec include/linux/netdevice.h:3636 [inline]
caller is nsh_gso_segment+0x59f/0xed0 net/nsh/nsh.c:115
CPU: 0 UID: 0 PID: 5860 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
 dev_xmit_recursion_dec include/linux/netdevice.h:3636 [inline]
 nsh_gso_segment+0x59f/0xed0 net/nsh/nsh.c:115
 skb_mac_gso_segment+0x31c/0x690 net/core/gso.c:53
 __skb_gso_segment+0x376/0x540 net/core/gso.c:124
 skb_gso_segment include/net/gso.h:83 [inline]
 validate_xmit_skb+0xa21/0x14a0 net/core/dev.c:4039
 validate_xmit_skb_list net/core/dev.c:4089 [inline]
 __dev_direct_xmit+0x1b4/0x750 net/core/dev.c:4922
 dev_direct_xmit include/linux/netdevice.h:3431 [inline]
 packet_xmit+0x1b4/0x320 net/packet/af_packet.c:285
 packet_snd net/packet/af_packet.c:3082 [inline]
 packet_sendmsg+0x3c81/0x4fb0 net/packet/af_packet.c:3114
 sock_sendmsg_nosec net/socket.c:787 [inline]
 __sock_sendmsg net/socket.c:802 [inline]
 __sys_sendto+0x672/0x710 net/socket.c:2265
 __do_sys_sendto net/socket.c:2272 [inline]
 __se_sys_sendto net/socket.c:2268 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2268
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fcd6a99cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fcd6b903028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 00007fcd6ac15fa0 RCX: 00007fcd6a99cdd9
RDX: 00000000000100a6 RSI: 0000200000000180 RDI: 0000000000000005
RBP: 00007fcd6aa32d69 R08: 0000200000000140 R09: 0000000000000014
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fcd6ac16038 R14: 00007fcd6ac15fa0 R15: 00007fff57a83608
 </TASK>


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
