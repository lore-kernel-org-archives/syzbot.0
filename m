Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D13A129D27A
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 14:54:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114462; cv=none; b=tgE1ZgimlrbkoFFXAyOlx1EIZ/pheI8cZ6X6VeHDVgK7ynHwhctQSab4WIQl8sHUEY1p/tbO47bASJAUOYkH573MDIXsw1xNXJlCQdxtYDw0TPncWxaBYh+FgKywEjXBHR7w7/Lpyae1ar10a2iHwYosYNtpbUYvqzbFeaB2v34=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114462; c=relaxed/simple;
	bh=q1SB9yEF5Ro4uVGe6rGTPjaBGBFoU5KTN+MaN/7ooss=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=GzIFBXGnWKmexVWMLfM3BuftGRbnDVg8jITbKMkYJLzjNgRed3q9Y/Ic857bkdmKaBz6aO6A+eVQcqnIbDNUFTZ2qF1IqyyJnRGN6tBPKGho3X35IyFULqZVJEvVO5qfPDOowR5DD3RIUeFNbD4Bs8DTL7UK9sJq9zrL4WQ9Jw0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6ae35c7b9a9so1291870eaf.2
        for <syzbot@lists.linux.dev>; Fri, 07 Aug 2026 07:54:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786114459; x=1786719259;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=cQ1NpQcqqkt1wd3q0dELNzGExyGfAydQLlJAMA7nMJM=;
        b=Jr098eSacpnDLBy1TfQ69wEYVtqxkOEZySjkC1tw32Uy2b2s8d6ScORsGpLBADu5zM
         9ljaHLRWqUBSbO06Np9ZDWie3NwEvpMBGU9e9iVW5svNLYV1KG9hu8eELQuKPwDTcF7b
         v96rpzUEoFUbyu5pL4GfAkLyK5AErCd7IESdlcfl4GmkDvY5euijgZSf5WuJBctefPVK
         OHbiwnESxG16RZ7Rc2pVQabSpjAf+QQKJ26JLHgY1WuJ27hcFoRgCKoVZLJIT4WRyFsx
         zF4pxoQASglgzH5eAfTyUUnFmtXUtIC8RHC22kCsjimaafB7H1dZU5e+9mS8xDxR5Pkz
         oyZg==
X-Gm-Message-State: AOJu0Yxqzd6gsT9bHkN4pwfwrHy82BUzpIYOjhDjDBxVqr8tbBPmdmCG
	wxdcBu4rJksDqt5gkYRMTInSTZ5EMHpGcuroRVmuzJ42Iu/sDuIa1YzY+PkllXImmVSWYY+c+ex
	rZabt4jwBzfeP0igBcHduGorMcwRCpiqNscIktmQzUUQNpYMbrAcejzK2YP4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2913:b0:696:836e:ba2b with SMTP id
 006d021491bc7-6b041f7b0a5mr379779eaf.11.1786114459534; Fri, 07 Aug 2026
 07:54:19 -0700 (PDT)
Date: Fri, 07 Aug 2026 07:54:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a75f19b.01d0871a.3a0d52.004c.GAE@google.com>
Subject: [moderation/CI] Re: net/smc: fix clcsock and lgr/lnk races in
 smc_diag dump path
From: syzbot ci <syzbot+ci963edbdba5a028aa@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] net/smc: fix clcsock and lgr/lnk races in smc_diag dump path
https://lore.kernel.org/all/20260807081606.3200128-1-mjambigi@linux.ibm.com
* [PATCH net v3] net/smc: fix clcsock and lgr/lnk races in smc_diag dump pa=
th

and found the following issue:
WARNING in smc_diag_dump_proto

Full report is available here:
https://ci.syzbot.org/series/ab0d12fd-741a-4a0f-9f49-e52b84e94f4a

***

WARNING in smc_diag_dump_proto

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      594d905195024b228c962627ae5ae7c17bd582a4
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/0c4d246f-d098-4afe-b6bc-0f0ad52f55f=
8/config
syz repro: https://ci.syzbot.org/findings/fa5564b8-8db6-4f76-9d75-dbd796435=
d87/syz_repro

------------[ cut here ]------------
DEBUG_LOCKS_WARN_ON(lock->magic !=3D lock)
WARNING: kernel/locking/mutex.c:625 at __mutex_lock_common kernel/locking/m=
utex.c:625 [inline], CPU#0: syz.0.161/6326
WARNING: kernel/locking/mutex.c:625 at __mutex_lock+0x12d8/0x1550 kernel/lo=
cking/mutex.c:821, CPU#0: syz.0.161/6326
Modules linked in:
CPU: 0 UID: 0 PID: 6326 Comm: syz.0.161 Not tainted syzkaller #0 PREEMPT(fu=
ll)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:625 [inline]
RIP: 0010:__mutex_lock+0x12df/0x1550 kernel/locking/mutex.c:821
Code: de 57 90 48 c1 e8 03 0f b6 04 18 84 c0 0f 85 47 02 00 00 83 3d 45 cc =
83 04 00 75 13 48 8d 3d a8 1b 87 04 48 c7 c6 40 f7 ec 8b <67> 48 0f b9 3a 9=
0 e9 75 ee ff ff 90 0f 0b 90 e9 48 f2 ff ff 90 0f
RSP: 0018:ffffc900068c6e40 EFLAGS: 00010246
RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffff888170ffd940
RDX: 0000000000000000 RSI: ffffffff8becf740 RDI: ffffffff905b2db0
RBP: ffffc900068c6fd0 R08: ffffffff9057de43 R09: 1ffffffff20afbc8
R10: dffffc0000000000 R11: fffffbfff20afbc9 R12: ffff8881b1006648
R13: 0000000000000000 R14: 1ffff92000d18ddc R15: 0000000000000000
FS:  00007f4dacd826c0(0000) GS:ffff88818d945000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000020000000e000 CR3: 0000000171350000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 smc_diag_msg_common_fill net/smc/smc_diag.c:50 [inline]
 __smc_diag_dump net/smc/smc_diag.c:101 [inline]
 smc_diag_dump_proto+0x6d2/0x2620 net/smc/smc_diag.c:255
 smc_diag_dump+0x59/0xa0 net/smc/smc_diag.c:278
 netlink_dump+0x711/0xee0 net/netlink/af_netlink.c:2331
 __netlink_dump_start+0x589/0x7b0 net/netlink/af_netlink.c:2446
 netlink_dump_start include/linux/netlink.h:341 [inline]
 smc_diag_handler_dump+0x199/0x240 net/smc/smc_diag.c:293
 sock_diag_rcv_msg+0x4b0/0x5f0 net/core/sock_diag.c:-1
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
 netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
 sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
 __sock_sendmsg net/socket.c:790 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
 __sys_sendmsg net/socket.c:2770 [inline]
 __do_sys_sendmsg net/socket.c:2775 [inline]
 __se_sys_sendmsg net/socket.c:2773 [inline]
 __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4dabf9e019
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4dacd82028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f4dac226090 RCX: 00007f4dabf9e019
RDX: 0000000000000600 RSI: 0000200000000540 RDI: 0000000000000003
RBP: 00007f4dac03500c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4dac226128 R14: 00007f4dac226090 R15: 00007ffe0de8ec98
 </TASK>
----------------
Code disassembly (best guess):
   0:	de 57 90             	ficoms -0x70(%rdi)
   3:	48 c1 e8 03          	shr    $0x3,%rax
   7:	0f b6 04 18          	movzbl (%rax,%rbx,1),%eax
   b:	84 c0                	test   %al,%al
   d:	0f 85 47 02 00 00    	jne    0x25a
  13:	83 3d 45 cc 83 04 00 	cmpl   $0x0,0x483cc45(%rip)        # 0x483cc5f
  1a:	75 13                	jne    0x2f
  1c:	48 8d 3d a8 1b 87 04 	lea    0x4871ba8(%rip),%rdi        # 0x4871bcb
  23:	48 c7 c6 40 f7 ec 8b 	mov    $0xffffffff8becf740,%rsi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	90                   	nop
  30:	e9 75 ee ff ff       	jmp    0xffffeeaa
  35:	90                   	nop
  36:	0f 0b                	ud2
  38:	90                   	nop
  39:	e9 48 f2 ff ff       	jmp    0xfffff286
  3e:	90                   	nop
  3f:	0f                   	.byte 0xf


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
[alibuda@linux.alibaba.com andrew@lunn.ch davem@davemloft.net dust.li@linux=
.alibaba.com edumazet@google.com guwen@linux.alibaba.com horms@kernel.org k=
uba@kernel.org linux-s390@vger.kernel.org mjambigi@linux.ibm.com netdev@vge=
r.kernel.org pabeni@redhat.com pasic@linux.ibm.com sidraya@linux.ibm.com to=
nylu@linux.alibaba.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

