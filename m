Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7351FB652
	for <syzbot@lists.linux.dev>; Sat, 21 Mar 2026 05:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774070224; cv=none; b=QYztRTmqI8OO26tBp6EJwL2YMPkvUlea9n3ZngWkYIUWwMN92Kplo3EJDzO1kIDISy79nY2FP3mt78IjnDuodhn7Rjg4nTOpw0HCxFnpO56XobLSQptly4j0w9NzkhKxw3zvHj5zwe3D6C4H6wy0nG/3ygoqChcjYKMD59wuGyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774070224; c=relaxed/simple;
	bh=IG1QQJ2BGisEjF2hArN5e/OoOOFTCQonXLAhGrn+Czw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=XnSxM7lujvh2wjyTAgWYbA3n+WEkJAsO2Mg7xadpFezDZuI8DD007EL33Iy0q7lBv9IiVjEjNT5MqDag254kuDHHEwEoeDuPMLsK4aBb4kLhju7w4kXIyKewqznBrQL6ppHSabxv8y9MVG23S9lI6ONeWpM1+kQRd1mZ75CtOhw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-67c30448569so3926101eaf.3
        for <syzbot@lists.linux.dev>; Fri, 20 Mar 2026 22:17:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774070221; x=1774675021;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jBFwhJFOeTULyjdVuOYViX9O1kPcZa6IyKy+/1+a5jU=;
        b=QDmhQvUtL94Uz6WhlU/w+vOs4HdCeV54ox4fVCWAGpcGOlT1jDRsYaXh6Nkghdm4H/
         f2EnXWYkwNNACuXnaeikdwbh8Fr5apbP7qxnD46+y8fQOmeJChsz2K36U4PnQksOAu9c
         s+uzJAhshwTagRsidab6kn0Gd7PSn3dcGugWE5WDv2auuCtfildPVZf92RuQLcxfcgrv
         kRpU/gDYJUajYNBO211qUPTyaRhqCC6YzU/0I1O25Dytlq9eb/wRr9VrKJnygK63Pksd
         EfHUZfPSHbfz7BwsJobkoia+fxXJ8tm8VsooTgRX20zoxV5DLBv+TmzNgO3Z/Cz/NThY
         s0cw==
X-Gm-Message-State: AOJu0Yz/HMzQ+Phs+iJeT3AcWiy/tt6EdP0+x4iXg8Nl2nYolBInLPJq
	iRA+PKwDQVXbD9LhtK/nnjYwm7dOMRd6+QQvKdEY3A0h7zbIzB7Tk/EJIet3hokzOOSrkUm+kjh
	20YRmXtenUN3ioGRTj7ODrNxsvxaVTHaMIy2tEA+QhyY6g+g1jVzumITQjJA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4dfa:b0:67b:e335:a2bd with SMTP id
 006d021491bc7-67c22ffcf84mr3804189eaf.72.1774070221443; Fri, 20 Mar 2026
 22:17:01 -0700 (PDT)
Date: Fri, 20 Mar 2026 22:17:01 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69be29cd.050a0220.3bf4de.003e.GAE@google.com>
Subject: [moderation/CI] Re: net: sleepable ndo_set_rx_mode
From: syzbot ci <syzbot+ci85c6b8c64f6ca6ac@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] net: sleepable ndo_set_rx_mode
https://lore.kernel.org/all/20260320012501.2033548-1-sdf@fomichev.me
* [PATCH net-next v3 01/13] net: add address list snapshot and reconciliati=
on infrastructure
* [PATCH net-next v3 02/13] wifi: cfg80211: use __rtnl_unlock in nl80211_pr=
e_doit
* [PATCH net-next v3 03/13] net: introduce ndo_set_rx_mode_async and dev_rx=
_mode_work
* [PATCH net-next v3 04/13] net: move promiscuity handling into dev_rx_mode=
_work
* [PATCH net-next v3 05/13] fbnic: convert to ndo_set_rx_mode_async
* [PATCH net-next v3 06/13] mlx5: convert to ndo_set_rx_mode_async
* [PATCH net-next v3 07/13] bnxt: convert to ndo_set_rx_mode_async
* [PATCH net-next v3 08/13] bnxt: use snapshot in bnxt_cfg_rx_mode
* [PATCH net-next v3 09/13] iavf: convert to ndo_set_rx_mode_async
* [PATCH net-next v3 10/13] netdevsim: convert to ndo_set_rx_mode_async
* [PATCH net-next v3 11/13] dummy: convert to ndo_set_rx_mode_async
* [PATCH net-next v3 12/13] net: warn ops-locked drivers still using ndo_se=
t_rx_mode
* [PATCH net-next v3 13/13] selftests: net: add team_bridge_macvlan rx_mode=
 test

and found the following issue:
INFO: task hung in cfg80211_wiphy_work

Full report is available here:
https://ci.syzbot.org/series/a66ec069-24ee-4e22-83c2-e59af9285eea

***

INFO: task hung in cfg80211_wiphy_work

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      9ac76f3d0bb2940db3a9684d596b9c8f301ef315
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/db45b25a-4a5f-4c4b-9ff3-133b7bba965=
9/config
syz repro: https://ci.syzbot.org/findings/ab980877-0359-44c9-8b8c-903e6714c=
5b4/syz_repro

INFO: task kworker/u9:0:26 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u9:0    state:D stack:24832 pid:26    tgid:26    ppid:2      t=
ask_flags:0x4208060 flags:0x00080000
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
 cfg80211_wiphy_work+0xb4/0x4a0 net/wireless/core.c:426
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
 worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task kworker/u10:1:36 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u10:1   state:D stack:23800 pid:36    tgid:36    ppid:2      t=
ask_flags:0x4208060 flags:0x00080000
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
 cfg80211_wiphy_work+0xb4/0x4a0 net/wireless/core.c:426
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
 worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task kworker/u10:5:255 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u10:5   state:D stack:22120 pid:255   tgid:255   ppid:2      t=
ask_flags:0x4208060 flags:0x00080000
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
INFO: task dhcpcd:5550 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:dhcpcd          state:D stack:25592 pid:5550  tgid:5550  ppid:1      t=
ask_flags:0x400140 flags:0x00080000
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
 netdev_run_todo+0x2fc/0xe10 net/core/dev.c:11816
 vlan_ioctl_handler+0x590/0x630 net/8021q/vlan.c:680
 sock_ioctl+0x668/0x7f0 net/socket.c:1332
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd6f242fd49
RSP: 002b:00007ffdcd636398 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: ffffffffffffffda RBX: 00005636048f9650 RCX: 00007fd6f242fd49
RDX: 00007ffdcd6363a0 RSI: 0000000000008982 RDI: 0000000000000011
RBP: 0000000000000002 R08: 0000000000000008 R09: 0000000000000000
R10: 00007ffdcd646a20 R11: 0000000000000246 R12: 00007ffdcd6363a0
R13: 00007ffdcd636460 R14: 00005636048f9650 R15: 0000563604954f10
 </TASK>
INFO: task kworker/u8:2:5622 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:2    state:D stack:23976 pid:5622  tgid:5622  ppid:2      t=
ask_flags:0x4208060 flags:0x00080000
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
 free_netdev+0x26c/0x6e0 net/core/dev.c:12314
 netdev_run_todo+0xc88/0xe10 net/core/dev.c:11851
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
INFO: task kworker/u8:3:5881 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:3    state:D stack:25528 pid:5881  tgid:5881  ppid:2      t=
ask_flags:0x4208060 flags:0x00080000
Workqueue: ipv6_addrconf addrconf_dad_work
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
 addrconf_dad_work+0x11e/0x14c0 net/ipv6/addrconf.c:4198
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
 worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task kworker/u8:4:5891 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/u8:4    state:D stack:25208 pid:5891  tgid:5891  ppid:2      t=
ask_flags:0x4208060 flags:0x00080000
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
 dev_rx_mode_work+0x17f/0xe00 net/core/dev.c:9703
 process_one_work kernel/workqueue.c:3275 [inline]
 process_scheduled_works+0xb02/0x1830 kernel/workqueue.c:3358
 worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
INFO: task kworker/1:4:5932 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:kworker/1:4     state:D stack:25152 pid:5932  tgid:5932  ppid:2      t=
ask_flags:0x4208060 flags:0x00080000
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
INFO: task syz-executor:5941 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:23048 pid:5941  tgid:5941  ppid:1      t=
ask_flags:0x480140 flags:0x00080002
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
RIP: 0033:0x7f854675cfce
RSP: 002b:00007ffc0ce0f7e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
RAX: ffffffffffffffda RBX: 00005555709c6500 RCX: 00007f854675cfce
RDX: 0000000000000001 RSI: 00007ffc0ce0f870 RDI: 0000000000000005
RBP: 00007f854683351c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000001
R13: 00007ffc0ce0f870 R14: 00007f8547544620 R15: 0000000000000003
 </TASK>
INFO: task syz.2.119:6269 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.119       state:D stack:26656 pid:6269  tgid:6266  ppid:5940   t=
ask_flags:0x400140 flags:0x00080002
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
 nl80211_set_wiphy+0x261/0x2fa0 net/wireless/nl80211.c:3920
 genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1114
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
RIP: 0033:0x7f578299c799
RSP: 002b:00007f57837e5028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f5782c15fa0 RCX: 00007f578299c799
RDX: 0000000000040044 RSI: 0000200000000040 RDI: 0000000000000003
RBP: 00007f5782a32c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5782c16038 R14: 00007f5782c15fa0 R15: 00007ffdecd52278
 </TASK>
Future hung task reports are suppressed, see sysctl kernel.hung_task_warnin=
gs
INFO: task syz.2.119:6270 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.2.119       state:D stack:26256 pid:6270  tgid:6266  ppid:5940   t=
ask_flags:0x400140 flags:0x00080002
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
 netdev_run_todo+0x2fc/0xe10 net/core/dev.c:11816
 nl80211_set_wiphy+0x2d3/0x2fa0 net/wireless/nl80211.c:3930
 genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1114
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
RIP: 0033:0x7f578299c799
RSP: 002b:00007f57837c4028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f5782c16090 RCX: 00007f578299c799
RDX: 0000000000040044 RSI: 0000200000000040 RDI: 0000000000000003
RBP: 00007f5782a32c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5782c16128 R14: 00007f5782c16090 R15: 00007ffdecd52278
 </TASK>
Future hung task reports are suppressed, see sysctl kernel.hung_task_warnin=
gs
INFO: task syz.0.120:6272 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.120       state:D stack:26224 pid:6272  tgid:6271  ppid:5937   t=
ask_flags:0x400140 flags:0x00080002
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
 netdev_run_todo+0x2fc/0xe10 net/core/dev.c:11816
 nl80211_set_wiphy+0x2d3/0x2fa0 net/wireless/nl80211.c:3930
 genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1114
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
RIP: 0033:0x7f1dc139c799
RSP: 002b:00007f1dc09fe028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f1dc1615fa0 RCX: 00007f1dc139c799
RDX: 0000000000040044 RSI: 0000200000000040 RDI: 0000000000000003
RBP: 00007f1dc1432c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1dc1616038 R14: 00007f1dc1615fa0 R15: 00007ffc4336ffc8
 </TASK>
Future hung task reports are suppressed, see sysctl kernel.hung_task_warnin=
gs
INFO: task syz.0.120:6273 blocked for more than 144 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz.0.120       state:D stack:27328 pid:6273  tgid:6271  ppid:5937   t=
ask_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 context_switch kernel/sched/core.c:5295 [inline]
 __schedule+0x15dd/0x52d0 kernel/sched/core.c:6908
 __schedule_loop kernel/sched/core.c:6990 [inline]
 schedule+0x164/0x360 kernel/sched/core.c:7005
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7062
 __mutex_lock_common kernel/locking/mutex.c:692 [inline]
 __mutex_lock+0x7fe/0x1300 kernel/locking/mutex.c:776
 nl80211_pre_doit+0x5f/0x930 net/wireless/nl80211.c:18128
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
RIP: 0033:0x7f1dc139c799
RSP: 002b:00007f1dc09dd028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f1dc1616090 RCX: 00007f1dc139c799
RDX: 0000000000040044 RSI: 0000200000000040 RDI: 0000000000000003
RBP: 00007f1dc1432c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1dc1616128 R14: 00007f1dc1616090 R15: 00007ffc4336ffc8
 </TASK>
Future hung task reports are suppressed, see sysctl kernel.hung_task_warnin=
gs
INFO: lockdep is turned off.
NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 34 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
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
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full)=
=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:63
Code: 9e 6e 02 c3 cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 =
90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 43 42 1a 00 fb f4 <e9> fc e9 02 00 c=
c cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
RSP: 0018:ffffffff8e407dc0 EFLAGS: 00000246
RAX: ffff88818de64000 RBX: ffffffff819a8c8d RCX: 0000000080000001
RDX: 0000000000000001 RSI: ffffffff8c27b4e0 RDI: ffffffff819a8c8d
RBP: ffffffff8e407eb0 R08: ffff88812103395b R09: 1ffff1102420672b
R10: dffffc0000000000 R11: ffffed102420672c R12: ffffffff901134b0
R13: 1ffffffff1c929d8 R14: 0000000000000000 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff88818de64000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555bc24eac48 CR3: 0000000110a12000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 arch_safe_halt arch/x86/kernel/process.c:766 [inline]
 default_idle+0x9/0x20 arch/x86/kernel/process.c:767
 default_idle_call+0x72/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:191 [inline]
 do_idle+0x1bd/0x500 kernel/sched/idle.c:332
 cpu_startup_entry+0x43/0x60 kernel/sched/idle.c:430
 rest_init+0x2de/0x300 init/main.c:760
 start_kernel+0x385/0x3d0 init/main.c:1210
 x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x147
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aleksandr.loktionov@intel.com alexanderduyck@fb.com andrew@lunn.ch anthony=
.l.nguyen@intel.com bestswngs@gmail.com corbet@lwn.net cratiu@nvidia.com da=
vem@davemloft.net dtatulea@nvidia.com edumazet@google.com horms@kernel.org =
intel-wired-lan@lists.osuosl.org jacob.e.keller@intel.com jianbol@nvidia.co=
m johannes@sipsolutions.net kees@kernel.org kernel-team@meta.com kuba@kerne=
l.org leon@kernel.org linux-doc@vger.kernel.org linux-kernel@vger.kernel.or=
g linux-kselftest@vger.kernel.org linux-rdma@vger.kernel.org linux-wireless=
@vger.kernel.org mbloch@nvidia.com michael.chan@broadcom.com mohsin.bashr@g=
mail.com netdev@vger.kernel.org pabeni@redhat.com pavan.chebbi@broadcom.com=
 przemyslaw.kitszel@intel.com saeedm@nvidia.com sd@queasysnail.net sdf@fomi=
chev.me skhan@linuxfoundation.org skhawaja@google.com tariqt@nvidia.com wil=
lemb@google.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

