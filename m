Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78FF036E484
	for <syzbot@lists.linux.dev>; Sat,  7 Mar 2026 18:59:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772909954; cv=none; b=rQPD1Rv4gpx69qpXsdICbyQOnnLnvli/x6o21SJYF+Lp+I3JlF/MG2dYqIMFpxL9NmuPge7JgrUbzrxdFi6pbWZ4DsL2RNHogG7DkTXyN48qmic52dHQum0FU45m18b/VfRy533xLwP48x1NgdboZevKu/PvvPK6AvHkRC1gQTg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772909954; c=relaxed/simple;
	bh=jX8NAMOR09nbOLzKWjEZcUG1VV2UvY8H7HJymT87Y3c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=nf/g9tTVZ+j8AFkPMiUZiwfAebUmZ8eLG7s9hkdn690z/ZRJ6fx7hNgJat1E69Fd9pJ/miAxaFUoznZgae8c6EUg49EK3asbvqFXzYgSv5WTKLGBk9xRGV0paxUVnAi2gLFG4Rtt4a4ZVNAQkXavs993UvvWSbxueG11xhBMCxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-67ba64650d9so8025230eaf.3
        for <syzbot@lists.linux.dev>; Sat, 07 Mar 2026 10:59:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772909952; x=1773514752;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=tn+vjnaDd6gGH7eKCTvef3Dp8iK5tE4ck3W7mKf8vyE=;
        b=q13LGdZ7/SX63ZOyu8kAVwRmSaHRZhIfwUDg/gUC44hzfXutBf4lSUga429u/mMIc7
         rvplyMuQCZ6xCg+Llw6xj7GGlf5uY40VGRnMiKvKYAb+IrgrZTFCq4KnXiXa+TnA2dsp
         o4Tq0+mNia16IQdRzSMcfhAoA1L/2uwQFMkE1U75ebQefHfwSRTxQerfjgIAlUM6ucKM
         XJ91iRm2Zqpoo1lL5zvXgjl6Rd+FikqkjZMSwHP95lREPRBRjA2CNfX3/++4WDMe6ByI
         6TNj+muRhOMZIWCEZZa6PEsyMZbdJQIMRinZFf2wKwaB8H7HjePIzck4hkHesYV+LAvq
         tdvQ==
X-Gm-Message-State: AOJu0YwOsWQy2YdmfWwz5Hx3SFHW0HSJ+8rpv1kdIJR7Y8rKZE33B4IE
	nGMG6AMUMLJn8DIGcNfzIbDFI7uEyCrRmrjacOQ36y0qUBMcpEVLXqc30DXGBUV8TcFEA8T4ECI
	J733rBjsME64iBdo7CI2kg4DoF4hKkZp6QeTqmNu2+nnOwEKgkBS8oRXGVvs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:983:b0:679:f226:30eb with SMTP id
 006d021491bc7-67b9bd31610mr3562334eaf.35.1772909952527; Sat, 07 Mar 2026
 10:59:12 -0800 (PST)
Date: Sat, 07 Mar 2026 10:59:12 -0800
In-Reply-To: <20260306151004.2862198-1-cratiu@nvidia.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ac7580.050a0220.13f275.005b.GAE@google.com>
Subject: [syzbot ci] Re: macsec: Add support for VLAN filtering in offload mode
From: syzbot ci <syzbot+cia87acdce0d629471@syzkaller.appspotmail.com>
To: andrew@lunn.ch, cratiu@nvidia.com, davem@davemloft.net, 
	dtatulea@nvidia.com, edumazet@google.com, kuba@kernel.org, 
	netdev@vger.kernel.org, pabeni@redhat.com, sd@queasysnail.net
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
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
