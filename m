Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8F55979CD
	for <syzbot@lists.linux.dev>; Sat,  7 Mar 2026 14:17:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772893053; cv=none; b=chnnkgVxZ/PGROrRLlH+vOy2ma+VaRh6Xk/Yp9Fk10emHaWSYiTROwvI6XimngNe1Y/Rkyfp/foqvHl1QJ/OYGQYaP231ZCoojYDeOxGYKbCSuKZvdDLEO7bsbnxp4vZeQw/y47srN+SaajJ+/EZh5tvfp5GOTablFHplJaoJM8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772893053; c=relaxed/simple;
	bh=5S3Afc3C6uPB5fPw8wH3fKyiZ1Or/QCIoaMVuvF1K5w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=F74SbywonSZNZ0C/AbTKvFZ8eHxBIrMNLR6ftcgK2w+wWH08OVCQcEIcryhFagME7wJ8WwnObUxEDH9BPdGlgv+MhkiN6EkYx746wdJevVsSSFGWqzulnRNYrm8bKbtiJq7EOhQ3qjm1kKp+5gctGhviPcM89JiuJU2IKc7ZOk4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d73e009a3dso1386347a34.1
        for <syzbot@lists.linux.dev>; Sat, 07 Mar 2026 06:17:32 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772893051; x=1773497851;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=sML3Mnba9HheX+r2YTXh5OPgJzgxXS2u5sezKv5fqOI=;
        b=UVYVlQKefV8++9JTQlAFA+Q25R48LuXFI+rmEXbE4hJ/aEAkC4O5ed6oEHx/HXlIpT
         x0gI1AKr3z3eDCxcrnD1KiPbKSQ9d18dTTlfvsjUtypYqBfw/u3eu8rOJ/cHh0r/biGI
         +5+xcC93yRTTVm2gPd1FjhO85LurYvGxtxAjFi7nycLPqkMJESGD3lGu1zCPPaPismhG
         D9af2iiyOt5mBtiVtig/JbII9QksUA2t78nlDsH5OUqx87tDqJIrzKnlVGfq0SeJzLGY
         H6zOpge0YU27EJ9p5VCQwJHKY75hKicutF1nTl4NacHJRQApzNyjfNDjLiyv5jvF2BcH
         FYAg==
X-Gm-Message-State: AOJu0Yxx/aR5UWdyoydyUvc3U/SO8UqTtpWHbClurmbUdA2g/7Vrkiev
	BOtyPeko90+fOb2SlBbm+/LHnE0hAEWElhFCE4JqokGvUqS6UMbc8L0MnTtljlaWmeNl+g3DFYL
	1DH6mQicwZQ5OGHhklU27E0PeVdF+jlkR8LY/3YdOb+ag6qt1r0ptOZmRSHw=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1607:b0:679:de26:7b2b with SMTP id
 006d021491bc7-67b9bca0d16mr3598784eaf.18.1772893051484; Sat, 07 Mar 2026
 06:17:31 -0800 (PST)
Date: Sat, 07 Mar 2026 06:17:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ac337b.050a0220.13f275.0057.GAE@google.com>
Subject: [moderation/CI] Re: macsec: Add support for VLAN filtering in offload mode
From: syzbot ci <syzbot+ci4ef4c4c489b62632@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] macsec: Add support for VLAN filtering in offload mode
https://lore.kernel.org/all/20260306151004.2862198-1-cratiu@nvidia.com
* [PATCH net v3 1/3] nsim: Add support for VLAN filters
* [PATCH net v3 2/3] selftests: Add macsec offload VLAN tests
* [PATCH net v3 3/3] macsec: Support VLAN-filtering lower devices

and found the following issue:
WARNING in nsim_destroy

Full report is available here:
https://ci.syzbot.org/series/82631b62-e289-479c-90ac-235c613bbae1

***

WARNING in nsim_destroy

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      b06ccbabe2506fd70b9167a644978b049150224a
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0beaf859-b4a7-4d7b-b4cf-b7e48e02f7a5/config
C repro:   https://ci.syzbot.org/findings/6f1250ca-99f0-4162-b147-c373abd95c96/c_repro
syz repro: https://ci.syzbot.org/findings/6f1250ca-99f0-4162-b147-c373abd95c96/syz_repro

------------[ cut here ]------------
1
WARNING: drivers/net/netdevsim/netdev.c:1235 at nsim_destroy+0x155/0x780 drivers/net/netdevsim/netdev.c:1235, CPU#1: kworker/u8:3/5864
Modules linked in:
CPU: 1 UID: 0 PID: 5864 Comm: kworker/u8:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: netns cleanup_net
RIP: 0010:nsim_destroy+0x155/0x780 drivers/net/netdevsim/netdev.c:1235
Code: c4 48 89 c6 48 81 e6 00 f0 00 00 31 ff e8 c3 f0 af fa 4c 89 e0 48 25 00 f0 00 00 74 0c e8 d3 eb af fa eb 2e e8 cc eb af fa 90 <0f> 0b 90 41 ff c4 41 0f b7 d4 be 00 10 00 00 4c 89 ff e8 74 6d 8f
RSP: 0018:ffffc90004857628 EFLAGS: 00010246
RAX: 0000000000000000 RBX: 1ffff110222a31b8 RCX: ffff88816f3fd700
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffffff90109377 R09: 1ffffffff202126e
R10: dffffc0000000000 R11: fffffbfff202126f R12: 0000000000000000
R13: ffff888111518dc0 R14: dffffc0000000000 R15: ffff888111519508
FS:  0000000000000000(0000) GS:ffff8882a94ae000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007feb04e16038 CR3: 000000000e54a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __nsim_dev_port_del+0x14d/0x1b0 drivers/net/netdevsim/dev.c:1528
 nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1540 [inline]
 nsim_dev_reload_destroy+0x288/0x490 drivers/net/netdevsim/dev.c:1764
 nsim_dev_reload_down+0x8a/0xc0 drivers/net/netdevsim/dev.c:1038
 devlink_reload+0x1d1/0x8d0 net/devlink/dev.c:461
 devlink_pernet_pre_exit+0x1e6/0x3f0 net/devlink/core.c:507
 ops_pre_exit_list net/core/net_namespace.c:161 [inline]
 ops_undo_list+0x187/0x940 net/core/net_namespace.c:234
 cleanup_net+0x56b/0x800 net/core/net_namespace.c:704
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3358
 worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
 kthread+0x388/0x470 kernel/kthread.c:467
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch cratiu@nvidia.com davem@davemloft.net dtatulea@nvidia.com edumazet@google.com kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com sd@queasysnail.net]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

