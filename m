Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6E0E3A5E9F
	for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 09:28:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783675706; cv=none; b=qJDx6x+DMuC7mFby5XnoMyWZvlamYz3ubOBuGg9y7HLfnx0mbzCTK9IwBaixU5vgDYwdhhnd8GeMmnXiXIDfdH9aBsuEdaw0XYi7oFpym/8KWDJeL5PKa8QnyD8EKCmakzIA3ZJrcuTKqG/P9YOsmMOkuRjLo+4h1kXHB+avHuk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783675706; c=relaxed/simple;
	bh=ruwVzrYHNVrptQAThIk+YQ576LXPdRHugkzLJ5GHDxU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=LWzqk5iogIiU5QebHOYJCdu3kvYx/FilHH1SO3LPb36yUSjJS7iBFgpV7zdBiUIreWnWBaDUP/YXq1qBLZmlOZzdwiocRIYAFUNEGHamgpZ82JKZWjrMLhFekv7wvA5OMbvqeR+4cjcbFp5DDVWA1o9iuefKzaDCXnh+lkrFQG8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6a372a5be46so930858eaf.1
        for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 02:28:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783675704; x=1784280504;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8hSHv4pZ33elnT09v5TifbhIyO4TpL84NV7BXOH7c6U=;
        b=r6h8EyFCtBBQnw/b49O9FmVCEZXyHvY+ZVybVtMa7Q2AAJopRDiLiEnDPtrrIiUnVA
         ZnIVs6WCZIVgtuMbUis/4+H1KuZgWMkX05SgwAhSWI6ch0IswQP0gN2BLdfrYI1ETdPz
         ZAZ8XZuCmLW73mXaocryT9+8jgILg5VFwd+4O0AN5lo/aMPrt2l+Gqfa06Jd7OFpxQwb
         FBaysKAS2wSyaPFkoyUiBx9SMqvh0A58DLwBs8puId0OPIxP7eNo2JIPa5R2Wn1NWa2d
         WuYEp0mIbakligSGXFigWOLc6Wd1xN0BREEBhJhCEM4Gpa1F/+j9wV+qLCXC9oaupTSy
         6m3A==
X-Gm-Message-State: AOJu0YzuCEoUGLHbeuBNEseMeH+W3M+DBcHtfM2d+cOCc8JNDlXd3f/5
	DTcVUFhj6/2hZLbiLh7wVeGx2EEI9zbd7Cb+ntl7qQPVtGsy6awvKb9vbJPFJm08uN0nZLgnf18
	TDCfcsfsUuIKA+yNLfLiaflCTxFBBXh8smYiWuA/zp32o9M3LkcaA5OTcxgY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2106:b0:6a1:4592:eded with SMTP id
 006d021491bc7-6a36d77a341mr7744504eaf.0.1783675703894; Fri, 10 Jul 2026
 02:28:23 -0700 (PDT)
Date: Fri, 10 Jul 2026 02:28:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a50bb37.57639fcc.86d58.0025.GAE@google.com>
Subject: [moderation/CI] Re: macvlan: allow source mode devices along with passthru
From: syzbot ci <syzbot+ci8d333e09229b69c8@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] macvlan: allow source mode devices along with passthru
https://lore.kernel.org/all/20260709100512.1383421-1-t.martitz@fritz.com
* [PATCH v2 1/1] macvlan: allow source mode devices along with passthru

and found the following issue:
general protection fault in macvlan_port_release_mac

Full report is available here:
https://ci.syzbot.org/series/2632619d-fb66-47ac-85a1-a781bbb0d57d

***

general protection fault in macvlan_port_release_mac

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      fe3e786ef4eb6e47d2901f568a27bd920477bbe9
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/90f86060-ab12-43d6-a718-5d0f5eb5df09/config
syz repro: https://ci.syzbot.org/findings/d1f12788-51d7-4251-8fc9-6bfda6a1e20a/syz_repro

batman_adv: batadv0: Removing interface: batadv_slave_1
veth1_macvtap: left promiscuous mode
veth0_macvtap: left promiscuous mode
veth1_vlan: left promiscuous mode
veth0_vlan: left promiscuous mode
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000118: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x00000000000008c0-0x00000000000008c7]
CPU: 0 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: netns cleanup_net
RIP: 0010:macvlan_passthru drivers/net/macvlan.c:78 [inline]
RIP: 0010:macvlan_port_release_mac+0x138/0x490 drivers/net/macvlan.c:807
Code: 01 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 b9 30 ae fb 48 8b 1b 4c 8d b3 c0 08 00 00 4c 89 f0 48 c1 e8 03 <42> 0f b6 04 20 84 c0 0f 85 44 02 00 00 45 8b 36 44 89 f6 83 e6 01
RSP: 0018:ffffc90000117500 EFLAGS: 00010206
RAX: 0000000000000118 RBX: 0000000000000000 RCX: ffff888102e98000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc90000117630 R08: ffffffff9032faf7 R09: 1ffffffff2065f5e
R10: dffffc0000000000 R11: fffffbfff2065f5f R12: dffffc0000000000
R13: 1ffff92000022ea4 R14: 00000000000008c0 R15: ffff88816b068818
FS:  0000000000000000(0000) GS:ffff88818dc23000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb0fefe8158 CR3: 0000000113c9a000 CR4: 00000000000006f0
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
RSP: 0018:ffffc90000117500 EFLAGS: 00010206
RAX: 0000000000000118 RBX: 0000000000000000 RCX: ffff888102e98000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: ffffc90000117630 R08: ffffffff9032faf7 R09: 1ffffffff2065f5e
R10: dffffc0000000000 R11: fffffbfff2065f5f R12: dffffc0000000000
R13: 1ffff92000022ea4 R14: 00000000000008c0 R15: ffff88816b068818
FS:  0000000000000000(0000) GS:ffff88818dc23000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b33163fff CR3: 0000000175a06000 CR4: 00000000000006f0
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

