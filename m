Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E5E3347FFE
	for <syzbot@lists.linux.dev>; Sat, 14 Mar 2026 18:48:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773514090; cv=none; b=TBwNJLr0hCCPvLdwYWuFWih3Te4NL93nJE1FRs1MewW5xnJNHXnXWoWoxXxb/ATdjnMnFg89mDboa6cUyqpb7MCaDI8WFam3Sh/T6ocoxDGPBWiLqcOJUybyGzToaR9GEoUeI/oh7J4y9cATBUbX9fM3Ss8mH2eHkcrTzziT4PM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773514090; c=relaxed/simple;
	bh=R/Mfop7sjfoefXQAVZB5uJMWr3yYgHfUjvr8uJA1Ni0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=EbvANVJUolFO3vHnzqvCdj5Wyr/F+1mdlKTNSYPxMi6D0nlzJtoJ8gj92kEYHzBkQLPVccT7TieLDbFH6TyAJT5N0KVryrc0UpNtiqjLFH6eKdjN2+qp2WjwqSw30HVLlz2UxzhisRc6H7iDag20dHeuLakqdnxlIlI/KoChhLQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-67bb77eb9f8so54968831eaf.1
        for <syzbot@lists.linux.dev>; Sat, 14 Mar 2026 11:48:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773514087; x=1774118887;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=0VkiCMlLFUDulOyqDlWv758SSBlPP9RVKJQW2mnOIFE=;
        b=aPfxXynAxuTIOe4sglFCnqZKBg19e6iJNLzDRyZQdyFpbqY0boD0sdx6BN6ZXhrmrR
         NFAZQvGhCXtQ6nLX14gNIZrfovmp+7Twi6pPhW6Af8jFuMLdfpef9LDIwTplZY31KBK6
         M2lVGSwn7fuCGLfr3XnN/WnUpOg7bMOgS4ONmiabw1qD2Nbh2zT9CsjnwNlhYVjy9HB3
         sgSmCsw2mGU9DjChFDkMNuz/dkD3tdLu72u8uLG7wWJVvtByqoKrc/uYnsQX1H2Yeh0p
         uad6Y1xVlnqZaUpThsFDUi/4yn1zTtZ/qthPQgSMKZ6kS8vMc/z54MELuxASX+1jXsBS
         DwLw==
X-Gm-Message-State: AOJu0YycgUhQ69t954oxYapcUNI0skDCQ+zgUBWzlx5ZyqMir8tJhvqO
	6MIAEswhYNLheJZHrYpjXT4AVL0Uf2ml1NDrYCW9hmiBtqN8WiZjWowAs95D3bJ4gFR9qVbsWwi
	ZFLkb0uIKSCkXtlxecVO0CHw3FE6JURUbOmhfOUpEquq1SDbZwL9TmlOl4bA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:e909:0:b0:67b:da6d:1672 with SMTP id
 006d021491bc7-67bdaa671cfmr5358647eaf.63.1773514087069; Sat, 14 Mar 2026
 11:48:07 -0700 (PDT)
Date: Sat, 14 Mar 2026 11:48:07 -0700
In-Reply-To: <20260313145113.1424442-1-sdf@fomichev.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b5ad67.a00a0220.3b25d1.001a.GAE@google.com>
Subject: [syzbot ci] Re: net: sleepable ndo_set_rx_mode
From: syzbot ci <syzbot+ci3f1dcbb3ce0bb6d0@syzkaller.appspotmail.com>
To: alexanderduyck@fb.com, anthony.l.nguyen@intel.com, cratiu@nvidia.com, 
	davem@davemloft.net, edumazet@google.com, kernel-team@meta.com, 
	kuba@kernel.org, michael.chan@broadcom.com, netdev@vger.kernel.org, 
	pabeni@redhat.com, pavan.chebbi@broadcom.com, przemyslaw.kitszel@intel.com, 
	saeedm@nvidia.com, sdf@fomichev.me, tariqt@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net: sleepable ndo_set_rx_mode
https://lore.kernel.org/all/20260313145113.1424442-1-sdf@fomichev.me
* [PATCH net-next 01/11] net: add address list snapshot and reconciliation infrastructure
* [PATCH net-next 02/11] net: introduce ndo_set_rx_mode_async and dev_rx_mode_work
* [PATCH net-next 03/11] net: move promiscuity handling into dev_rx_mode_work
* [PATCH net-next 04/11] fbnic: convert to ndo_set_rx_mode_async
* [PATCH net-next 05/11] mlx5: convert to ndo_set_rx_mode_async
* [PATCH net-next 06/11] bnxt: convert to ndo_set_rx_mode_async
* [PATCH net-next 07/11] iavf: convert to ndo_set_rx_mode_async
* [PATCH net-next 08/11] netdevsim: convert to ndo_set_rx_mode_async
* [PATCH net-next 09/11] dummy: convert to ndo_set_rx_mode_async
* [PATCH net-next 10/11] net: warn ops-locked drivers still using ndo_set_rx_mode
* [PATCH net-next 11/11] selftests: net: add team_bridge_macvlan rx_mode test

and found the following issue:
INFO: task hung in cfg80211_wiphy_work

Full report is available here:
https://ci.syzbot.org/series/2082d932-a52b-452f-8578-cff71ac48dba

***

INFO: task hung in cfg80211_wiphy_work

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      8f921f61005450589c0bc1a941a5ddde21d9aed9
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/2b308211-99ab-473d-bc06-5fbd9675960b/config
syz repro: https://ci.syzbot.org/findings/2364ee6f-c520-43b4-a8cf-9e3bb0e1ee31/syz_repro

INFO: task kworker/u10:0:27 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u10:0   state:D stack:25256 pid:27    tgid:27    ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: events_unbound cfg80211_wiphy_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7062
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7fe/0x1300 kernel/locking/mutex.c:776
 class_wiphy_constructor include/net/cfg80211.h:6443 [inline]
 cfg80211_wiphy_work+0xb4/0x4a0 net/wireless/core.c:425
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
 worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task kworker/1:2:868 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:2     state:D stack:25504 pid:868   tgid:868   ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: events request_firmware_work_func
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7062
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7fe/0x1300 kernel/locking/mutex.c:776
 regdb_fw_cb+0x7d/0x1c0 net/wireless/reg.c:1016
 request_firmware_work_func+0x105/0x1c0 drivers/base/firmware_loader/main.c:1152
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
 worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task kworker/u9:5:1092 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u9:5    state:D stack:24320 pid:1092  tgid:1092  ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: events_unbound linkwatch_event
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7062
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7fe/0x1300 kernel/locking/mutex.c:776
 linkwatch_event+0xe/0x60 net/core/link_watch.c:313
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
 worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task dhcpcd:5549 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:dhcpcd          state:D stack:25720 pid:5549  tgid:5549  ppid:1      task_flags:0x400140 flags:0x00080000
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7062
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7fe/0x1300 kernel/locking/mutex.c:776
 vlan_ioctl_handler+0xf0/0x630 net/8021q/vlan.c:579
 sock_ioctl+0x668/0x7f0 net/socket.c:1332
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4686473d49
RSP: 002b:00007fff8730a6f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 0000557cb913f4d0 RCX: 00007f4686473d49
RDX: 00007fff8730a700 RSI: 0000000000008982 RDI: 0000000000000011
RBP: 0000000000000002 R08: 0000000000000008 R09: 0000000000000000
R10: 00007fff8731ad80 R11: 0000000000000246 R12: 00007fff8730a700
R13: 00007fff8730a7c0 R14: 0000557cb913f4d0 R15: 0000557cb91a6f10
 </TASK>
INFO: task kworker/u8:2:5621 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:2    state:D stack:25176 pid:5621  tgid:5621  ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: netns cleanup_net
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_timeout+0xc3/0x2c0 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:100 [inline]
 __wait_for_common kernel/sched/completion.c:121 [inline]
 wait_for_common kernel/sched/completion.c:132 [inline]
 wait_for_completion+0x2cc/0x5e0 kernel/sched/completion.c:153
 __flush_work+0xa17/0xc50 kernel/workqueue.c:4327
 __cancel_work_sync+0xbe/0x110 kernel/workqueue.c:4447
 free_netdev+0x26c/0x6e0 net/core/dev.c:12310
 netdev_run_todo+0xc88/0xe10 net/core/dev.c:11847
 ops_exit_rtnl_list net/core/net_namespace.c:189 [inline]
 ops_undo_list+0x3d8/0x940 net/core/net_namespace.c:248
 cleanup_net+0x56b/0x800 net/core/net_namespace.c:704
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
 worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task kworker/u8:3:5896 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:3    state:D stack:23624 pid:5896  tgid:5896  ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: rx_mode_wq dev_rx_mode_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7062
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7fe/0x1300 kernel/locking/mutex.c:776
 dev_rx_mode_work+0x170/0xc90 net/core/dev.c:9700
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
 worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task kworker/1:4:5906 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:4     state:D stack:23752 pid:5906  tgid:5906  ppid:2      task_flags:0x4208060 flags:0x00080000
Workqueue: events switchdev_deferred_process_work
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7062
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7fe/0x1300 kernel/locking/mutex.c:776
 switchdev_deferred_process_work+0xe/0x20 net/switchdev/switchdev.c:104
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
 worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task syz-executor:10842 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:22520 pid:10842 tgid:10842 ppid:1      task_flags:0x480140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7062
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7fe/0x1300 kernel/locking/mutex.c:776
 rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 rtnl_net_dev_lock+0x257/0x2f0 net/core/dev.c:2163
 unregister_netdevice_notifier_dev_net+0x96/0x440 net/core/dev.c:2208
 nsim_destroy+0xd9/0x680 drivers/net/netdevsim/netdev.c:1174
 __nsim_dev_port_del+0x14d/0x1b0 drivers/net/netdevsim/dev.c:1528
 nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1540 [inline]
 nsim_dev_reload_destroy+0x288/0x490 drivers/net/netdevsim/dev.c:1764
 nsim_drv_remove+0x58/0x170 drivers/net/netdevsim/dev.c:1779
 device_remove drivers/base/dd.c:571 [inline]
 __device_release_driver drivers/base/dd.c:1284 [inline]
 device_release_driver_internal+0x46f/0x860 drivers/base/dd.c:1307
 bus_remove_device+0x34d/0x440 drivers/base/bus.c:616
 device_del+0x527/0x8f0 drivers/base/core.c:3878
 device_unregister+0x21/0xf0 drivers/base/core.c:3919
 nsim_bus_dev_del drivers/net/netdevsim/bus.c:491 [inline]
 del_device_store+0x2b0/0x370 drivers/net/netdevsim/bus.c:244
 kernfs_fop_write_iter+0x3af/0x540 fs/kernfs/file.c:352
 new_sync_write fs/read_write.c:595 [inline]
 vfs_write+0x61d/0xb90 fs/read_write.c:688
 ksys_write+0x150/0x270 fs/read_write.c:740
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f458055cfce
RSP: 002b:00007fff68821b08 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 0000555580081500 RCX: 00007f458055cfce
RDX: 0000000000000001 RSI: 00007fff68821b90 RDI: 0000000000000005
RBP: 00007f458063351c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007fff68821b90 R14: 00007f4581344620 R15: 0000000000000003
 </TASK>
INFO: task syz.0.1807:10948 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.1807      state:D stack:26656 pid:10948 tgid:10947 ppid:5918   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7062
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7fe/0x1300 kernel/locking/mutex.c:776
 nl80211_pre_doit+0x5f/0x930 net/wireless/nl80211.c:18117
 genl_family_rcv_msg_doit+0x1d7/0x330 net/netlink/genetlink.c:1109
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc97739c799
RSP: 002b:00007fc97825a028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fc977615fa0 RCX: 00007fc97739c799
RDX: 0000000000000000 RSI: 0000200000000180 RDI: 0000000000000003
RBP: 00007fc977432c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc977616038 R14: 00007fc977615fa0 R15: 00007ffd2003aab8
 </TASK>
INFO: task syz.0.1807:10952 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.1807      state:D stack:26536 pid:10952 tgid:10947 ppid:5918   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7062
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7fe/0x1300 kernel/locking/mutex.c:776
 nl80211_pre_doit+0x5f/0x930 net/wireless/nl80211.c:18117
 genl_family_rcv_msg_doit+0x1d7/0x330 net/netlink/genetlink.c:1109
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc97739c799
RSP: 002b:00007fc978239028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007fc977616090 RCX: 00007fc97739c799
RDX: 0000000000000000 RSI: 0000200000000180 RDI: 0000000000000003
RBP: 00007fc977432c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc977616128 R14: 00007fc977616090 R15: 00007ffd2003aab8
 </TASK>
Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
INFO: task syz.2.1808:10950 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.1808      state:D stack:26520 pid:10950 tgid:10949 ppid:5922   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_timeout+0xc3/0x2c0 kernel/time/sleep_timeout.c:75
 do_wait_for_common kernel/sched/completion.c:100 [inline]
 __wait_for_common kernel/sched/completion.c:121 [inline]
 wait_for_common kernel/sched/completion.c:132 [inline]
 wait_for_completion+0x2cc/0x5e0 kernel/sched/completion.c:153
 __flush_workqueue+0x6f6/0x14f0 kernel/workqueue.c:4083
 netdev_run_todo+0x2fc/0xe10 net/core/dev.c:11812
 nl80211_pre_doit+0x4f1/0x930 net/wireless/nl80211.c:-1
 genl_family_rcv_msg_doit+0x1d7/0x330 net/netlink/genetlink.c:1109
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f634299c799
RSP: 002b:00007f6343865028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f6342c15fa0 RCX: 00007f634299c799
RDX: 0000000000000000 RSI: 0000200000000180 RDI: 0000000000000003
RBP: 00007f6342a32c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6342c16038 R14: 00007f6342c15fa0 R15: 00007ffcaed4e308
 </TASK>
Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
INFO: task syz.2.1808:10951 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.1808      state:D stack:26088 pid:10951 tgid:10949 ppid:5922   task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7062
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7fe/0x1300 kernel/locking/mutex.c:776
 wiphy_lock include/net/cfg80211.h:6428 [inline]
 nl80211_pre_doit+0x281/0x930 net/wireless/nl80211.c:18190
 genl_family_rcv_msg_doit+0x1d7/0x330 net/netlink/genetlink.c:1109
 genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
 genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
 __sys_sendmsg net/socket.c:2671 [inline]
 __do_sys_sendmsg net/socket.c:2676 [inline]
 __se_sys_sendmsg net/socket.c:2674 [inline]
 __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f634299c799
RSP: 002b:00007f6343844028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f6342c16090 RCX: 00007f634299c799
RDX: 0000000000000000 RSI: 0000200000000180 RDI: 0000000000000003
RBP: 00007f6342a32c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6342c16128 R14: 00007f6342c16090 R15: 00007ffcaed4e308
 </TASK>
Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
INFO: task syz-executor:10957 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:25464 pid:10957 tgid:10957 ppid:1      task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7062
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7fe/0x1300 kernel/locking/mutex.c:776
 rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 inet_rtm_newaddr+0x404/0x1ad0 net/ipv4/devinet.c:978
 rtnetlink_rcv_msg+0x7d5/0xbe0 net/core/rtnetlink.c:6958
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 __sys_sendto+0x672/0x710 net/socket.c:2199
 __do_sys_sendto net/socket.c:2206 [inline]
 __se_sys_sendto net/socket.c:2202 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2202
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbe5e55cfce
RSP: 002b:00007ffc1795c728 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000555555a84500 RCX: 00007fbe5e55cfce
RDX: 0000000000000028 RSI: 00007fbe5f344670 RDI: 0000000000000003
RBP: 0000000000000001 R08: 00007ffc1795c7a4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000000 R14: 00007fbe5f344670 R15: 0000000000000000
 </TASK>
Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
INFO: task syz-executor:10958 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:25112 pid:10958 tgid:10958 ppid:1      task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7062
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7fe/0x1300 kernel/locking/mutex.c:776
 rtnl_net_lock include/linux/rtnetlink.h:130 [inline]
 inet_rtm_newaddr+0x404/0x1ad0 net/ipv4/devinet.c:978
 rtnetlink_rcv_msg+0x7d5/0xbe0 net/core/rtnetlink.c:6958
 netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
 netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
 netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
 sock_sendmsg_nosec net/socket.c:721 [inline]
 __sock_sendmsg net/socket.c:736 [inline]
 __sys_sendto+0x672/0x710 net/socket.c:2199
 __do_sys_sendto net/socket.c:2206 [inline]
 __se_sys_sendto net/socket.c:2202 [inline]
 __x64_sys_sendto+0xde/0x100 net/socket.c:2202
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2853d5cfce
RSP: 002b:00007ffdddce0d58 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
RAX: ffffffffffffffda RBX: 0000555567dbb500 RCX: 00007f2853d5cfce
RDX: 0000000000000028 RSI: 00007f2854b44670 RDI: 0000000000000003
RBP: 0000000000000001 R08: 00007ffdddce0dd4 R09: 000000000000000c
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
R13: 0000000000000000 R14: 00007f2854b44670 R15: 0000000000000000
 </TASK>
Future hung task reports are suppressed, see sysctl kernel.hung_task_warnings
INFO: lockdep is turned off.
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 34 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 nmi_cpu_backtrace+0x274/0x2d0 lib/nmi_backtrace.c:113
 nmi_trigger_cpumask_backtrace+0x17a/0x300 lib/nmi_backtrace.c:62
 trigger_all_cpu_backtrace include/linux/nmi.h:161 [inline]
 __sys_info lib/sys_info.c:157 [inline]
 sys_info+0x135/0x170 lib/sys_info.c:165
 check_hung_uninterruptible_tasks kernel/hung_task.c:346 [inline]
 watchdog+0xfd9/0x1030 kernel/hung_task.c:515
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Sending NMI from CPU 0 to CPUs 1:
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:63
Code: 1e 6c 02 c3 cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 43 42 1a 00 fb f4 <e9> fc e9 02 00 cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
RSP: 0018:ffffc90000197e20 EFLAGS: 00000246
RAX: ffff8882a9464000 RBX: ffffffff819a8c8d RCX: 0000000080000001
RDX: 0000000000000001 RSI: ffffffff8c27b4e0 RDI: ffffffff819a8c8d
RBP: ffffc90000197f10 R08: ffff88823c63395b R09: 1ffff110478c672b
R10: dffffc0000000000 R11: ffffed10478c672c R12: ffffffff901140b0
R13: 1ffff1102c095000 R14: 0000000000000001 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff8882a9464000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd37a2e068 CR3: 00000001156b2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/kernel/process.c:766 [inline]
 default_idle+0x9/0x20 arch/x86/kernel/process.c:767
 default_idle_call+0x72/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:191 [inline]
 do_idle+0x1bd/0x500 kernel/sched/idle.c:332
 cpu_startup_entry+0x43/0x60 kernel/sched/idle.c:430
 start_secondary+0x101/0x110 arch/x86/kernel/smpboot.c:312
 common_startup_64+0x13e/0x147
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
