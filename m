Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E5F12D0C98
	for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 06:47:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783666035; cv=none; b=sC87cAel94Mn82zUpXuUsxhrruOOA4Kl/Nu6VZ3ghCAZW3stHlN4uo8ee1NunOzmOPpvPSyLmRGrhfFcBT3FKlIJc9/HY/TIeIOuNc2fUQZC5eTrGv0wu5z0muGr5uh04rdHJpV9gH/44Hcm/M+js4C0nxjLg7Y2KJ+Hv/E/5HA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783666035; c=relaxed/simple;
	bh=mFHWPJdLu+eXJtgHjraWkzoEdqc9fw/0eV7sL4b3mf4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=p8fwpIzZDNVAZqpFFuWQP2yyfbLqpVMQBRGYe18jB8cnN0W1ZvYqva/LwDj/qpcpXRuG2A7rH1hCDztLPSbQPC3y75IPcvteoI285zBDfhKi/K7doNQqesZVKTFHUsN6TcFyV11BBGoJ0EuVdwf94N+POWyLmsK5/3wT/IMqH24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-49f3a97f1caso403198b6e.0
        for <syzbot@lists.linux.dev>; Thu, 09 Jul 2026 23:47:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783666032; x=1784270832;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JdshiCfY8gx89x/JFmjAfiCNo6PtASoipEMErBAQN6k=;
        b=Mhzp4tOxx8xYoSIthBEYNvhzX/ttBqxnr50x3xeP7O/hjcIQf7KW1L5DJJxL8Df2i8
         z5FA1s94i9S8oUq4u9m4opckNeYQV/mErel6YAXu+d9vlpy+GL11Ij+BRzrKL1NjRcdZ
         LbHWh0/N/j1RV4psQ+pvuRATHgvRj/P/of5W1xzqwDALvMJ8qMobHsJyNxhhv5EzWT7O
         aFl9EUBU32hoZ4YtGw5RGdXqr3f6cR82Fl/POT+zeai9hOP64CJEGnKr8Ho7ZfuXQE/b
         uGXcb+qgNRGKyC8Lr4K9t4maIrCJoiRDNLqdwwFsZoKRWKfiFr/54jlN5hFmpkmOLVTq
         K3Yg==
X-Gm-Message-State: AOJu0YyHq7R/OeAzADHe3OvTcRaaCpWbsuOsxdKxj8wQ8hoQQFSc9ecV
	oWrp3eZ/PGPzVG7paOvpnu4PBC2NGKesqxC07g+3MfqhaQIrDu29N/Y0VEy4zl8jOWOitBFndpd
	XFWCSmSQ54uLopInIQKOLZDD6592SpWMJJRyiam1BY3s1HXgz7DXIFhGH4KA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3384:b0:495:ebd3:ea52 with SMTP id
 5614622812f47-4a201cf888emr9525700b6e.2.1783666032637; Thu, 09 Jul 2026
 23:47:12 -0700 (PDT)
Date: Thu, 09 Jul 2026 23:47:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a509570.c76b52dc.2a15e.0009.GAE@google.com>
Subject: [moderation/CI] Re: macvlan: allow source mode devices along with passthru
From: syzbot ci <syzbot+cid152941003025f4b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] macvlan: allow source mode devices along with passthru
https://lore.kernel.org/all/20260709091138.170348-1-t.martitz@fritz.com
* [PATCH v2 1/1] macvlan: allow source mode devices along with passthru

and found the following issue:
general protection fault in macvlan_port_release_mac

Full report is available here:
https://ci.syzbot.org/series/72476997-558e-41ae-b146-c05346cdd7f6

***

general protection fault in macvlan_port_release_mac

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      fe3e786ef4eb6e47d2901f568a27bd920477bbe9
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/0c5e2f82-62bd-40bf-a873-66f277607c07/config
syz repro: https://ci.syzbot.org/findings/d5d14725-5a48-484c-876d-026175d0b21a/syz_repro

batman_adv: batadv0: Removing interface: batadv_slave_1
veth1_macvtap: left promiscuous mode
veth0_macvtap: left promiscuous mode
veth1_vlan: left promiscuous mode
veth0_vlan: left promiscuous mode
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000118: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x00000000000008c0-0x00000000000008c7]
CPU: 1 UID: 0 PID: 13 Comm: kworker/u8:1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: netns cleanup_net
RIP: 0010:macvlan_passthru drivers/net/macvlan.c:78 [inline]
RIP: 0010:macvlan_port_release_mac+0x138/0x490 drivers/net/macvlan.c:807
Code: 01 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 b9 30 ae fb 48 8b 1b 4c 8d b3 c0 08 00 00 4c 89 f0 48 c1 e8 03 <42> 0f b6 04 20 84 c0 0f 85 44 02 00 00 45 8b 36 44 89 f6 83 e6 01
RSP: 0018:ffffc90000127500 EFLAGS: 00010206
RAX: 0000000000000118 RBX: 0000000000000000 RCX: ffff888102ec5940
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc90000127630 R08: ffffffff9032faf7 R09: 1ffffffff2065f5e
R10: dffffc0000000000 R11: fffffbfff2065f5f R12: dffffc0000000000
R13: 1ffff92000024ea4 R14: 00000000000008c0 R15: ffff888109b28818
FS:  0000000000000000(0000) GS:ffff8882a9223000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffefe7250d8 CR3: 000000000e746000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 macvlan_port_destroy+0x2eb/0x310 drivers/net/macvlan.c:1343
 unregister_netdevice_many_notify+0x1ad2/0x2150 net/core/dev.c:12464
 unregister_netdevice_many net/core/dev.c:12506 [inline]
 default_device_exit_batch+0x961/0x9e0 net/core/dev.c:13098
 ops_exit_list net/core/net_namespace.c:205 [inline]
 ops_undo_list+0x4b4/0x8d0 net/core/net_namespace.c:252
 cleanup_net+0x572/0x810 net/core/net_namespace.c:702
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:macvlan_passthru drivers/net/macvlan.c:78 [inline]
RIP: 0010:macvlan_port_release_mac+0x138/0x490 drivers/net/macvlan.c:807
Code: 01 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 b9 30 ae fb 48 8b 1b 4c 8d b3 c0 08 00 00 4c 89 f0 48 c1 e8 03 <42> 0f b6 04 20 84 c0 0f 85 44 02 00 00 45 8b 36 44 89 f6 83 e6 01
RSP: 0018:ffffc90000127500 EFLAGS: 00010206
RAX: 0000000000000118 RBX: 0000000000000000 RCX: ffff888102ec5940
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc90000127630 R08: ffffffff9032faf7 R09: 1ffffffff2065f5e
R10: dffffc0000000000 R11: fffffbfff2065f5f R12: dffffc0000000000
R13: 1ffff92000024ea4 R14: 00000000000008c0 R15: ffff888109b28818
FS:  0000000000000000(0000) GS:ffff8882a9223000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffefe7250d8 CR3: 000000000e746000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	01 00                	add    %eax,(%rax)
   2:	00 48 89             	add    %cl,-0x77(%rax)
   5:	d8 48 c1             	fmuls  -0x3f(%rax)
   8:	e8 03 42 80 3c       	call   0x3c804210
   d:	20 00                	and    %al,(%rax)
   f:	74 08                	je     0x19
  11:	48 89 df             	mov    %rbx,%rdi
  14:	e8 b9 30 ae fb       	call   0xfbae30d2
  19:	48 8b 1b             	mov    (%rbx),%rbx
  1c:	4c 8d b3 c0 08 00 00 	lea    0x8c0(%rbx),%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 20       	movzbl (%rax,%r12,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 44 02 00 00    	jne    0x27b
  37:	45 8b 36             	mov    (%r14),%r14d
  3a:	44 89 f6             	mov    %r14d,%esi
  3d:	83 e6 01             	and    $0x1,%esi


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
[andrew@lunn.ch davem@davemloft.net edumazet@google.com horms@kernel.org kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com t.martitz@fritz.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

