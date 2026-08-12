Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A38F33C182
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 01:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786497626; cv=none; b=VzJeXfKQeAqGbmj7MmnVapo7lVUeyJbGY9c/tNhBUuYP1RlUCMzfW7Gx4ahnlm7c+MElaMfOmL/nFxfPGeplsE8wMQiXzKZil5Hkts+HSM8xYkCeBs7HL/Py65ATX0YabMBpfxtGK+9qFNWzK4gZXKWCk7I4DhNI7zGCb8U/hW4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786497626; c=relaxed/simple;
	bh=mmrMiiOkZR2BK37rEIon8GOEAJQtk5Pcju5DwMk/A2Y=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=EXJZSvRSAg3kvYRDbaOJNlTfxfWNlbWkl/ar/mykxatJ/EoKdBRarrV4FeWYlwixXUpjKTud4KNMFRj7wNPJtd3KHfGQyh8OlDNNoUpwP/1ND1D+kCUAlItbaYRxmy56Kmn9ZjqPSoCwVC7gNNt5liRX0UzOoGJnZhQZkTJI4eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4afa222912eso299497b6e.2
        for <syzbot@lists.linux.dev>; Tue, 11 Aug 2026 18:20:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786497624; x=1787102424;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=4vHwXunPAI8fx6Hi1iPkwn7/F2bzjp1IjfhzkAbrui8=;
        b=OfXls5Rek3XqmoCJp5pDuGLk1sb7nDFbgsF6Aa+59fuZCXLIkJRU+GYdd9m8j5lMfN
         6ZK6rjUI/ludByGrmzefD6MViTr5DATpxPnKel2D9NUnClLspeN8wqF0W6OU+ZMfnnwq
         vYIvv6aiHdJEnf/8ZakcWZxBz0VNqnpbYRYvPz9Io5IBg31w8IxvJohR38m3XX89M9Vg
         Hn8o48WwMMK4IgRNaaWWYLZ4I3W8aNL+nZy20S4fQEYlIe4p2RjRjC9u9l/jx1H69f5A
         j2oWl8BMWqILb+AqG8OGs5XGGeTpXNOmkvVQK5KNVfhUzxXym5xfQrUADqEIYKb3c0wR
         Tn8w==
X-Gm-Message-State: AOJu0YzBUr6dti6pqy0w5id7ftbyLwMhSrSb9LxpvE5zYZEd1wNiOJFc
	WDwwNzNjUUS1uzloZRT7yBbjVA+db2YEvE4kgPBwsBWy9hGdiWRT1CjXSe5CMKGdQBTD38xf66G
	3J3KdStNJ511UiK/iS+vq9FvhwLJDap4ki9ZMHB3VYv4LNxpA4lZM9VyGjZc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6601:b0:496:34a:d7e3 with SMTP id
 5614622812f47-4b210b8e0edmr1371785b6e.17.1786497624033; Tue, 11 Aug 2026
 18:20:24 -0700 (PDT)
Date: Tue, 11 Aug 2026 18:20:24 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7bca58.a2bb2777.31c27d.000c.GAE@google.com>
Subject: [moderation/CI] Re: wifi: mac80211: guard drv_net_setup_tc() against
 unbound AP_VLAN sdata
From: syzbot ci <syzbot+cieb4418b9b188eded@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] wifi: mac80211: guard drv_net_setup_tc() against unbound AP_VLAN sdata
https://lore.kernel.org/all/20260811205927.11228-1-ayushmanrout27@gmail.com
* [PATCH] wifi: mac80211: guard drv_net_setup_tc() against unbound AP_VLAN sdata

and found the following issue:
WARNING in ieee80211_netdev_setup_tc

Full report is available here:
https://ci.syzbot.org/series/3ec3e079-9059-4c39-a313-0258dcc9d685

***

WARNING in ieee80211_netdev_setup_tc

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      31397cf1819210bd63fa3d2c7d8c24f7c8667d99
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/1331e819-db99-424b-bb55-8ffa3576dfd4/config
syz repro: https://ci.syzbot.org/findings/f970b19c-569e-48d1-9391-879b071ef920/syz_repro

------------[ cut here ]------------
wlan1: Failed check-sdata-in-driver check, flags: 0x0
WARNING: net/mac80211/driver-ops.h:1719 at drv_net_setup_tc net/mac80211/driver-ops.h:1719 [inline], CPU#1: kworker/u8:0/12
WARNING: net/mac80211/driver-ops.h:1719 at ieee80211_netdev_setup_tc+0x2f0/0x550 net/mac80211/iface.c:938, CPU#1: kworker/u8:0/12
Modules linked in:
CPU: 1 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: netns cleanup_net
RIP: 0010:drv_net_setup_tc net/mac80211/driver-ops.h:1719 [inline]
RIP: 0010:ieee80211_netdev_setup_tc+0x345/0x550 net/mac80211/iface.c:938
Code: 48 8b 02 48 8d b0 20 01 00 00 48 85 c0 48 0f 44 f1 0f b6 04 2b 84 c0 4d 89 ee 0f 85 ad 00 00 00 49 8d 84 24 68 0a 00 00 8b 10 <67> 48 0f b9 3a e9 16 fe ff ff e8 fc 92 84 f6 90 0f 0b 90 e9 75 fe
RSP: 0000:ffffc90000117158 EFLAGS: 00010246
RAX: ffff88816c7b5928 RBX: 1ffff1102d8f6b25 RCX: ffff88816c7b5938
RDX: 0000000000000000 RSI: ffff88816c7b4120 RDI: ffffffff906931c0
RBP: dffffc0000000000 R08: ffffc90000117237 R09: 0000000000000000
R10: ffffc90000117208 R11: ffffffff8b426c40 R12: ffff88816c7b4ec0
R13: ffffc90000117200 R14: ffffc90000117200 R15: ffff88816c7b4000
FS:  0000000000000000(0000) GS:ffff8882a8f58000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fa250470000 CR3: 000000017949c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 tcf_block_offload_cmd+0x235/0x3b0 net/sched/cls_api.c:853
 tcf_block_offload_unbind net/sched/cls_api.c:917 [inline]
 __tcf_block_put+0x281/0x490 net/sched/cls_api.c:1344
 tcf_block_put+0x6c/0xa0 net/sched/cls_api.c:1587
 cake_destroy+0x4b/0x80 net/sched/sch_cake.c:2811
 __qdisc_destroy+0x153/0x470 net/sched/sch_generic.c:1122
 qdisc_put net/sched/sch_generic.c:1150 [inline]
 dev_shutdown+0x352/0x450 net/sched/sch_generic.c:1515
 unregister_netdevice_many_notify+0x11f4/0x2140 net/core/dev.c:12478
 unregister_netdevice_many net/core/dev.c:12562 [inline]
 unregister_netdevice_queue+0x2f5/0x340 net/core/dev.c:12363
 unregister_netdevice include/linux/netdevice.h:3481 [inline]
 _cfg80211_unregister_wdev+0x156/0x5a0 net/wireless/core.c:1425
 ieee80211_remove_interfaces+0x49c/0x6a0 net/mac80211/iface.c:2492
 ieee80211_unregister_hw+0x5d/0x2c0 net/mac80211/main.c:1717
 mac80211_hwsim_del_radio+0x28a/0x4a0 drivers/net/wireless/virtual/mac80211_hwsim_main.c:6251
 hwsim_exit_net+0xe8e/0xf50 drivers/net/wireless/virtual/mac80211_hwsim_main.c:7260
 ops_exit_list net/core/net_namespace.c:200 [inline]
 ops_undo_list+0x43d/0x8d0 net/core/net_namespace.c:253
 cleanup_net+0x572/0x810 net/core/net_namespace.c:706
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
----------------
Code disassembly (best guess):
   0:	48 8b 02             	mov    (%rdx),%rax
   3:	48 8d b0 20 01 00 00 	lea    0x120(%rax),%rsi
   a:	48 85 c0             	test   %rax,%rax
   d:	48 0f 44 f1          	cmove  %rcx,%rsi
  11:	0f b6 04 2b          	movzbl (%rbx,%rbp,1),%eax
  15:	84 c0                	test   %al,%al
  17:	4d 89 ee             	mov    %r13,%r14
  1a:	0f 85 ad 00 00 00    	jne    0xcd
  20:	49 8d 84 24 68 0a 00 	lea    0xa68(%r12),%rax
  27:	00
  28:	8b 10                	mov    (%rax),%edx
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 16 fe ff ff       	jmp    0xfffffe4a
  34:	e8 fc 92 84 f6       	call   0xf6849335
  39:	90                   	nop
  3a:	0f 0b                	ud2
  3c:	90                   	nop
  3d:	e9                   	.byte 0xe9
  3e:	75 fe                	jne    0x3e


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
[ayushmanrout27@gmail.com johannes@sipsolutions.net linux-kernel@vger.kernel.org linux-wireless@vger.kernel.org netdev@vger.kernel.org syzbot@syzkaller.appspotmail.com syzkaller-bugs@googlegroups.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

