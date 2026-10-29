Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.69
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793247188;
	b=vmHPSToJjkvzYbFVFkB+VpsgbWLOVWSK8qBavztPCFsyKLb57zpZ/B/0+0VDZhbVFSmL
	 20k8ddMBdCY3TOBSZdQkgT0kSBwMotwUzKUvS2W9QV4oBAKkTXMsRXBmu55fEe8DR53b6
	 +EM66kqeNA49RsXY50NgQu5Xlw/+UE0TtL3H2hz5sZIQozelcM2U+ZOy3ZUVRUuTuXnAI
	 oqKye9/Lnb+6Kk232Ksy9a0SLwZ8l+1n3huu1aetpzNPK3NNajJ3MtgjzqSQqooQt0R6i
	 KnMDcemIf50kXd0lvwQUPbnpOmd4bAOf1WrvZroQkCQg1h3NN1D6SfQBWdej93J75nw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793247188;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=WTXt7/PBeg5MSSDcZXwr5aSNMNJLUg9JZONEIlCD87A=;
	b=mCKvjiH6Yt+hzpGDGByzvEvdwlvWT3/gByXoQYpgU4c8spdEaj+GHibBXxYgrCFM/3xF
	 ZdBnYeyrFX8bxlzhuyZxIr0PkL4Xixl7lePZeoTsC2p0+du6HlDCeSxKUoyVQZLkr4Vyp
	 jKHRCrQuS1XBhNBN2iWjJg+p6SxIqmlecqKjIqrz6pJBiJ8JwUOp9UJSjaEzWNbTt2dIp
	 IiWUDHCZmfEeNgE61x9rHlwBVDIjdpvzprxZxyQT/aA1scNvAukMrkIHkrlUO2XHBi+hf
	 asXhx/bSShqGels4QQ+jo8GCGZbvPBltsRrBTvOZ5Jz1tfwMt6QtCvf7taAyD25PDVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.69
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCF57606A31A
	for <syzbot@lists.linux.dev>; Thu, 29 Oct 2026 04:13:07 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DCF57606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-84c4dce8182so2461410a34.2
        for <syzbot@lists.linux.dev>; Wed, 28 Oct 2026 21:13:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793247187; x=1793851987;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WTXt7/PBeg5MSSDcZXwr5aSNMNJLUg9JZONEIlCD87A=;
        b=KIuKD3SVIQOTsU3Plu6S4pfz/PVei47LWK1LrHySmgMj7g49duNV5go7S+CcP/Osh4
         z16BqP6vo3c6kOIKuAjxW0uxvReEWQMVP4XYcsFnpbaQfGur4ubhQrCKGsY9DTlmWbfi
         uh+mN3qv1Vusgn0Iz8hAsbMrNmBr028/tCNL3cD9nzkj2ZDSNcxZcuqyK3qvY5UAuKdb
         bSVkbp9VNDrS8w2F5SEo4DaNIxtN/apn52E0ckMubfF3WxQ+rBySJjU7R4FmAGIIR2WF
         ea30nIfiBV0EsjfBF3pN5wx8/Fto3L42tHs02+qRxlTH3rZvpNGKomVn2hJn3Ag5/+Wc
         Ab9Q==
X-Gm-Message-State: AFq9FYKkQxPqkSLNbEMxze1eHiGPCY7pQx+zr5jUD8nC/Uo/6BeVNecs
	SUJ4vFuZZB7MkukNe2cQH2X9uq9HQ52LgjtH0L16P/2LqorI895e84CgSINgm2+bMm7uej8wJYL
	AeZKXRAqt8kihCP5GNaTWXYWjoP9zPpmwBl74uzxEXZGDy9HSha0fe+HZL48=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3509:b0:4f4:dd0d:207a with SMTP id
 5614622812f47-5637f3f7f8fmr2944459b6e.4.1793247186853; Wed, 28 Oct 2026
 21:13:06 -0700 (PDT)
Date: Wed, 28 Oct 2026 21:13:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae2c7d2.84012103.26b497.0737.GAE@google.com>
Subject: [moderation/CI] Re: wifi: mac80211_hwsim: fix netlink release and
 radio removal races
From: syzbot ci <syzbot+ci2858acb32e2d0908@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] wifi: mac80211_hwsim: fix netlink release and radio removal races
https://lore.kernel.org/all/20261028141751.6728-1-enderaoelyther@gmail.com
* [PATCH 1/2] wifi: mac80211_hwsim: ignore non-generic netlink releases
* [PATCH 2/2] wifi: mac80211_hwsim: serialize radio removal with frame commands

and found the following issue:
INFO: task hung in mac80211_hwsim_netlink_notify

Full report is available here:
https://ci.syzbot.org/series/fe9cfff2-ef52-45eb-993c-ea84c287686d

***

INFO: task hung in mac80211_hwsim_netlink_notify

tree:      wireless-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wireless/wireless-next.git
base:      864c07de0c7dcbca58b61625dfa2e461ae63b242
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/ffa94119-c540-48f2-b244-f5fa2d9531b2/config
AI triage: https://ci.syzbot.org/findings/1d1df02a-8709-4cb9-9450-7f2ae94c0965/triage_trajectory

INFO: task syz-executor:21314 blocked for more than 143 seconds.
      Not tainted syzkaller #0
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:22184 pid:21314 tgid:21314 ppid:1      task_flags:0x400140 flags:0x00080002
Call Trace:
 <TASK>
 __schedule+0x17dd/0x5820
 schedule+0x164/0x2b0
 schedule_preempt_disabled+0x13/0x30
 __mutex_lock+0x7c4/0x15a0
 mac80211_hwsim_netlink_notify+0x193/0x1140
 notifier_call_chain+0x1a5/0x3d0
 blocking_notifier_call_chain+0x6a/0x90
 netlink_release+0x1211/0x1a90
 __sock_release+0xa0/0x1f0
 sock_close+0x1c/0x30
 __fput+0x408/0xa40
 fput_close_sync+0x11f/0x240
 __se_sys_close+0xa2/0x160
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fed3715fd8e
RSP: 002b:00007fffadf594c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 000055557b013500 RCX: 00007fed3715fd8e
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 0000000000000005 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00007fed37f54670
R13: 0000000000000014 R14: 00007fed37f54864 R15: 00000000000001f4
 </TASK>

Showing all locks held in the system:
locks held by kworker/u8:1/13: 3, on CPU#0:
 #0: ffff888111e50148 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc90000127c40 ((work_completion)(&(&ifa->dad_work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffffffff9125a680 (rtnl_mutex){+.+.}-{4:4}, at: addrconf_dad_work+0x116/0x15c0
locks held by khungtaskd/35: 1, last CPU#1:
 #0: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks+0x2e/0x180
locks held by getty/5413: 2, on CPU#1:
 #0: ffff88811659a0a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait+0x25/0x70
 #1: ffffc9000348b2e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_read+0x45a/0x1360
locks held by kworker/u8:2/5484: 3, last CPU#0:
 #0: ffff88810b983148 ((wq_completion)krds_cp_wq#3/0){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc90004407c40 ((work_completion)(&(&cp->cp_conn_w)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffff88811a039280 (&tc->t_conn_path_lock){+.+.}-{4:4}, at: rds_tcp_conn_path_connect+0x1cc/0x920
locks held by kworker/u9:17/30931: 3, last CPU#1:
 #0: ffff8881000ac148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc90006befc40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffff888054278258 (&devlink->lock_key#13){+.+.}-{4:4}, at: nsim_dev_trap_report_work+0x57/0xb30
locks held by kworker/u9:38/30947: 3, last CPU#1:
 #0: ffff8881000ac148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc9000765fc40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffff888075278258 (&devlink->lock_key#12){+.+.}-{4:4}, at: nsim_dev_trap_report_work+0x57/0xb30
locks held by kworker/u9:39/30948: 3, last CPU#1:
 #0: ffff8881000ac148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc9000768fc40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffff88806cffd258 (&devlink->lock_key#5){+.+.}-{4:4}, at: nsim_dev_trap_report_work+0x57/0xb30
locks held by kworker/u8:7/20795: 7, on CPU#0:
 #0: ffff8881012dd948 ((wq_completion)netns){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc9000791fc40 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffffffff9124be48 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xf5/0x810
 #3: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: hwsim_exit_net+0xc9/0xf70
 #4: ffffffff9125a680 (rtnl_mutex){+.+.}-{4:4}, at: wiphy_unregister+0x26f/0xb20
 #5: ffff888068390800 (&rdev->wiphy.mtx){+.+.}-{4:4}, at: wiphy_unregister+0x279/0xb20
 #6: ffffffff8fd60328 (rcu_state.exp_mutex){+.+.}-{4:4}, at: synchronize_rcu_expedited+0x2cb/0x760
locks held by kworker/u8:8/20796: 2, last CPU#0:
 #0: ffff888113926148 ((wq_completion)bat_events){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc9000793fc40 ((work_completion)(&(&bat_priv->dat.work)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
locks held by syz-executor/21314: 3, on CPU#0:
 #0: ffff8881bfaa2640 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __sock_release+0x7a/0x1f0
 #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x54/0x90
 #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim_netlink_notify+0x193/0x1140
locks held by kworker/0:5/21344: 3, on CPU#0:
 #0: ffff88810006ad48 ((wq_completion)events){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc90003ed7c40 (netdev_work){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffffffff9125a680 (rtnl_mutex){+.+.}-{4:4}, at: netdev_work_proc+0x6f/0x770
locks held by syz-executor/21396: 3, on CPU#0:
 #0: ffff888112f5c440 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __sock_release+0x7a/0x1f0
 #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x54/0x90
 #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim_netlink_notify+0x193/0x1140
locks held by syz-executor/21403: 3, on CPU#1:
 #0: ffff888013e16240 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __sock_release+0x7a/0x1f0
 #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x54/0x90
 #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim_netlink_notify+0x193/0x1140
locks held by syz-executor/21473: 3, on CPU#0:
 #0: ffff8881a662e240 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __sock_release+0x7a/0x1f0
 #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x54/0x90
 #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim_netlink_notify+0x193/0x1140
locks held by syz-executor/21500: 3, on CPU#0:
 #0: ffff88816a9b4440 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __sock_release+0x7a/0x1f0
 #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x54/0x90
 #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim_netlink_notify+0x193/0x1140
locks held by syz-executor/21503: 3, on CPU#1:
 #0: ffff8881a652ee40 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __sock_release+0x7a/0x1f0
 #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x54/0x90
 #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim_netlink_notify+0x193/0x1140
locks held by syz-executor/21537: 3, on CPU#1:
 #0: ffff8881bfaa5040 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __sock_release+0x7a/0x1f0
 #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x54/0x90
 #2: ffffffff90a92d40 (hwsim_radio_mutex){+.+.}-{4:4}, at: mac80211_hwsim_netlink_notify+0x193/0x1140
locks held by syz-executor/21559: 7, on CPU#0:
 #0: ffff888117068460 (sb_writers#7){.+.+}-{0:0}, at: vfs_write+0x22b/0xba0
 #1: ffff888120412c80 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter+0x1d8/0x540
 #2: ffff88816bbcf4b8 (kn->active#49){.+.+}-{0:0}, at: kernfs_fop_write_iter+0x22b/0x540
 #3: ffffffff90ad1400 (nsim_bus_dev_list_lock){+.+.}-{4:4}, at: new_device_store+0x13c/0x6d0
 #4: ffff8881c71ac128 (&dev->mutex){....}-{4:4}, at: __device_attach+0x88/0x450
 #5: ffff8881c71a9258 (&devlink->lock_key#14){+.+.}-{4:4}, at: nsim_drv_probe+0xfb/0xbb0
 #6: ffffffff9125a680 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_dev_lock+0x257/0x2f0
locks held by syz-executor/21566: 3, last CPU#1:
 #0: ffff88819720ac40 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}, at: __sock_release+0x7a/0x1f0
 #1: ffffffff912c9268 ((netlink_chain).rwsem){++++}-{4:4}, at: blocking_notifier_call_chain+0x54/0x90
 #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: nl80211_netlink_notify+0x75/0x860
locks held by kworker/u9:0/21570: 3, last CPU#1:
 #0: ffff8881000ac148 ((wq_completion)events_unbound){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #1: ffffc90003e87c40 ((work_completion)(&(&nsim_dev->trap_data->trap_report_dw)->work)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffff8881bbf09258 (&devlink->lock_key){+.+.}-{4:4}, at: nsim_dev_trap_report_work+0x57/0xb30
locks held by syz-executor/21598: 2, on CPU#0:
 #0: ffffffff909c0ba8 (&ops->srcu#2){.+.+}-{0:0}, at: rtnl_link_ops_get+0x23/0x250
 #1: ffffffff9125a680 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0xc10/0x1c30

=============================================

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 35 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 nmi_cpu_backtrace+0x274/0x2d0
 nmi_trigger_cpumask_backtrace+0x17d/0x390
 sys_info+0x135/0x170
 watchdog+0xfd2/0x1030
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 20796 Comm: kworker/u8:8 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: bat_events batadv_dat_purge
RIP: 0010:native_apic_msr_write+0x39/0x50
Code: 74 2a 83 ff 30 74 25 eb 10 81 ff d0 00 00 00 74 1b 81 ff e0 00 00 00 74 13 c1 ef 04 81 c7 00 08 00 00 89 f9 89 f0 31 d2 0f 30 <66> 90 c3 cc cc cc cc cc 89 f6 31 d2 e9 e6 17 aa 03 66 0f 1f 44 00
RSP: 0018:ffffc90000007e50 EFLAGS: 00000046
RAX: 000000000000000f RBX: ffff888120e23f40 RCX: 0000000000000838
RDX: 0000000000000000 RSI: 000000000000000f RDI: 0000000000000838
RBP: ffffc90000007f10 R08: 0000000000000100 R09: 0000000000000001
R10: 0000000000000003 R11: ffffffff81758510 R12: ffffffff81758510
R13: 1ffff110241c47f1 R14: 0000000000000000 R15: ffff888120e23f8c
FS:  0000000000000000(0000) GS:ffff88818c4a4000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f85c76b3866 CR3: 0000000169088000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 lapic_next_event+0x11/0x20
 clockevents_program_event+0x44e/0x630
 hrtimer_run_softirq+0x255/0x2e0
 handle_softirqs+0x265/0x8d0
 do_softirq+0x77/0xd0
 </IRQ>
 <TASK>
 __local_bh_enable_ip+0x100/0x140
 batadv_dat_purge+0x2d7/0x3c0
 process_scheduled_works+0xc3d/0x1630
 worker_thread+0xa47/0xfb0
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[enderaoelyther@gmail.com jlopex@gmail.com johannes@sipsolutions.net jukka.rissanen@linux.intel.com linux-kernel@vger.kernel.org linux-wireless@vger.kernel.org linville@tuxdriver.com stable@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

