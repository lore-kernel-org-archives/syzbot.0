Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5BFBA453A3B
	for <syzbot@lists.linux.dev>; Sat, 26 Sep 2026 13:58:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790431124; cv=none; b=oLkBKh/0dlCiIBxA2JXdYzBiPvlWixBz85cKy1x207SMss9AQsGp3W1MORh9Pq59EIxrJn/4Qcbpc1bTCrT83F0vKtb6XwzwVoXr739E8S5i/7cZ9qaXAQ5RyPQ1+4MsMeejgsnyeMMO/aQeBAmWLY7jl67IAF0R2BKlHjmfJac=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790431124; c=relaxed/simple;
	bh=WK0eXAvQEZt2PiLlz+Om1Kz8UzQ0rsnW6ZsYT7fUKtA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=DzP/NGKq+9fLkp6dBDqIzc5Tw0aHH9t85pdR/41dgT+3er+EO1d7qVDlknQYKD2PU46T+B1P8bCuU1inH3NclMTX4K2cxwvnND8/1CvXvBRAgnnAGDsV30drhRiRtd6qCsbh0SRBv3x2hdmsqH1XbQ0SjAwCpSvpeP+TUCu1K+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4c734afb8deso3172356b6e.1
        for <syzbot@lists.linux.dev>; Sat, 26 Sep 2026 06:58:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790431119; x=1791035919;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CBshb8ITim8v4AzGTR0urvZV6eEECq3UzVNS6eE6a3U=;
        b=wk85zj3KXY2N5a583Vk4NLdTcSgmzLSE+8HgqN5OnlbcLsPoOGkAlPQZv+/bW6ZF4z
         hZERGvXOoUfFp5evRfuT106vSC6U+Uom25UHWIdVn8ZcgyESi+qRm2lgC0aFStMioxOO
         gBs98g0WwvyzlkBtA+qZDoJEAm5tjntEYMMMlDdPjMuhriBRAvPdBG9kCsqWbnAT2F5Y
         gtFHRb0mHppI3MFg2xBETMmeOxGcYwDUEQo5an+gszXAIaiKYSmDTkvXSQeUECCi1tqf
         oljvQxAe9y0EbKZ0ruZUBPH7ZoELYmB4TpOyGCRnHIfym6FPmTUg+irv/SRE5EEe6qRA
         Aumg==
X-Gm-Message-State: AFuF++mFRoy8AYKWucMOTVt4j5lqWlv6qJhI+PB3PC8D+6o7nExSnb4x
	YMYe5zHZEnGtWqieOD8FrU4Eng8UqzJZlBkjyuOkx3NylR/WaPAybtulehX2h+xEsqz4Gv4eSOi
	vKADGJDNgrr73DCkaN7NAhA2SGJ4vg+ssimVQX1OU3xJh++BJBEObrSEq10Q=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:124a:b0:4c3:afa3:e417 with SMTP id
 5614622812f47-4d72c633914mr7859117b6e.10.1790431119343; Sat, 26 Sep 2026
 06:58:39 -0700 (PDT)
Date: Sat, 26 Sep 2026 06:58:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab7cf8f.80e1c6cc.1e8e5f.0045.GAE@google.com>
Subject: [moderation/CI] Re: ipvs: fix infinite loop with ipvlan L3 from
 unconditional ipvs_property clear
From: syzbot ci <syzbot+ci001f11078a9928f9@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] ipvs: fix infinite loop with ipvlan L3 from unconditional ipvs_propert=
y clear
https://lore.kernel.org/all/20260924063312.1194019-1-chenguang.zhao@linux.d=
ev
* [PATCH net] ipvs: fix infinite loop with ipvlan L3 from unconditional ipv=
s_property clear

and found the following issue:
INFO: task hung in netdev_run_todo

Full report is available here:
https://ci.syzbot.org/series/b6478e5d-791e-4d72-8b8d-0fa748c90168

***

INFO: task hung in netdev_run_todo

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      e7e0a54300a896e731dffd3e2e8dae5631d6243d
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9865431b-add2-4883-97e2-de4ec60d969=
e/config
AI triage: https://ci.syzbot.org/findings/27d3caa2-dab2-445f-8ff6-e3beef36b=
414/triage_trajectory

INFO: task syz-executor:31961 blocked for more than 144 seconds.
      Not tainted syzkaller #0
      Blocked by coredump.
"echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
task:syz-executor    state:D stack:26120 pid:31961 tgid:31961 ppid:1      t=
ask_flags:0x40054c flags:0x00080003
Call Trace:
 <TASK>
 __schedule+0x17db/0x58f0
 schedule+0x164/0x2b0
 schedule_preempt_disabled+0x13/0x30
 __mutex_lock+0x7c1/0x1550
 rcu_barrier+0x4c/0x530
 netdev_run_todo+0x2fc/0x1060
 tun_chr_close+0x13c/0x1c0
 __fput+0x418/0xa50
 task_work_run+0x1d9/0x270
 do_exit+0x73a/0x2360
 do_group_exit+0x22d/0x2f0
 get_signal+0x121b/0x12c0
 arch_do_signal_or_restart+0xbb/0x860
 exit_to_user_mode_loop+0x10e/0x770
 do_syscall_64+0x328/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4b2cf9ddeb
RSP: 002b:00007ffedfbd6b60 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
RAX: 0000000000000000 RBX: 00007ffedfbd6c10 RCX: 00007f4b2cf9ddeb
RDX: 00007ffedfbd6be0 RSI: 00000000400454ca RDI: 00000000000000c8
RBP: 00007f4b2d0359ad R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000008
R13: 0000000000000003 R14: 00007ffedfbd6f08 R15: 0000000000000000
 </TASK>

Showing all locks held in the system:
locks held by kworker/u8:1/13: 3, on CPU#1:
 #0: ffff88817721b940 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: proce=
ss_scheduled_works+0x97a/0x1630
 #1: ffffc90000127c40 ((work_completion)(&(&net->ipv6.addr_chk_work)->work)=
){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: addrconf_verify_work+0x=
19/0x30
locks held by khungtaskd/35: 1, last CPU#1:
 #0: ffffffff8ed5c8a0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_locks=
+0x2e/0x180
locks held by getty/5419: 2, on CPU#1:
 #0: ffff88817a7b30a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wait=
+0x25/0x70
 #1: ffffc900027682e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_rea=
d+0x45a/0x1360
locks held by kworker/u8:4/9945: 2, last CPU#1:
 #0: ffff888177d09940 ((wq_completion)bat_events){+.+.}-{0:0}, at: process_=
scheduled_works+0x97a/0x1630
 #1: ffffc90006db7c40 ((work_completion)(&(&bat_priv->tt.work)->work)){+.+.=
}-{0:0}, at: process_scheduled_works+0x97a/0x1630
locks held by kworker/u8:5/19085: 4, last CPU#1:
 #0: ffff88817741f940 ((wq_completion)krds_cp_wq#12/0){+.+.}-{0:0}, at: pro=
cess_scheduled_works+0x97a/0x1630
 #1: ffffc90003a0fc40 ((work_completion)(&(&cp->cp_conn_w)->work)){+.+.}-{0=
:0}, at: process_scheduled_works+0x97a/0x1630
 #2: ffff888169e6a180 (&tc->t_conn_path_lock){+.+.}-{4:4}, at: rds_tcp_conn=
_path_connect+0x1cc/0x920
 #3: ffff888192303660 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: rds_tcp_tune+0x2=
20/0x920
locks held by kworker/u10:0/25329: 3, on CPU#1:
 #0: ffff8881000ac140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: proc=
ess_scheduled_works+0x97a/0x1630
 #1: ffffc9000418fc40 ((linkwatch_work).work){+.+.}-{0:0}, at: process_sche=
duled_works+0x97a/0x1630
 #2: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: linkwatch_event+0xe/0x6=
0
locks held by kworker/0:1/27790: 7, last CPU#0:
 #0: ffff88810006a940 ((wq_completion)events_long){+.+.}-{0:0}, at: process=
_scheduled_works+0x97a/0x1630
 #1: ffffc9000141fc40 ((work_completion)(&(&br->gc_work)->work)){+.+.}-{0:0=
}, at: process_scheduled_works+0x97a/0x1630
 #2: ffffffff8ed5c8a0 (rcu_read_lock){....}-{1:3}, at: process_backlog+0x3d=
e/0x18b0
 #3: ffffffff8ed5c8a0 (rcu_read_lock){....}-{1:3}, at: NF_HOOK+0x9e/0x3c0
 #4: ffffffff8ed5c8a0 (rcu_read_lock){....}-{1:3}, at: ip_route_output_key_=
hash+0xd8/0x2a0
 #5: ffff888121028298 (hrtimer_bases.lock){-.-.}-{2:2}, at: __hrtimer_rearm=
_deferred+0x99/0x4b0
 #6: ffffffff9aa29748 (&____s->seqcount#2){----}-{0:0}, at: __ip_vs_conn_in=
_get+0x2db/0x10f0
locks held by syz.0.7664/31917: 1, on CPU#1:
 #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: tun_chr_close+0x3e/0x1c=
0
locks held by syz.3.7666/31925: 1, on CPU#1:
 #0: ffffffff8ed62b38 (rcu_state.barrier_mutex){+.+.}-{4:4}, at: rcu_barrie=
r+0x4c/0x530
locks held by syz.2.7668/31938: 1, on CPU#1:
 #0: ffffffff8ed62b38 (rcu_state.barrier_mutex){+.+.}-{4:4}, at: rcu_barrie=
r+0x4c/0x530
locks held by syz-executor/31955: 1, on CPU#1:
 #0: ffffffff8ed62b38 (rcu_state.barrier_mutex){+.+.}-{4:4}, at: rcu_barrie=
r+0x4c/0x530
locks held by syz-executor/31961: 1, on CPU#1:
 #0: ffffffff8ed62b38 (rcu_state.barrier_mutex){+.+.}-{4:4}, at: rcu_barrie=
r+0x4c/0x530
locks held by kworker/u8:7/31997: 4, on CPU#1:
 #0: ffff8881012d5940 ((wq_completion)netns){+.+.}-{0:0}, at: process_sched=
uled_works+0x97a/0x1630
 #1: ffffc900079cfc40 (net_cleanup_work){+.+.}-{0:0}, at: process_scheduled=
_works+0x97a/0x1630
 #2: ffffffff90244da8 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xf5/=
0x810
 #3: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: ops_undo_list+0x28e/0x8=
d0
locks held by syz-executor/31998: 1, on CPU#1:
 #0: ffffffff8ed62b38 (rcu_state.barrier_mutex){+.+.}-{4:4}, at: rcu_barrie=
r+0x4c/0x530
locks held by syz-executor/32005: 1, on CPU#1:
 #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: tun_chr_close+0x3e/0x1c=
0
locks held by syz-executor/32009: 1, last CPU#1:
 #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: tun_chr_close+0x3e/0x1c=
0
locks held by syz-executor/32074: 1, on CPU#1:
 #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0xc10/0x1c=
30
locks held by syz-executor/32077: 1, on CPU#1:
 #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0xc10/0x1c=
30
locks held by syz-executor/32095: 2, last CPU#1:
 #0: ffff88816f5b1d38 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x1a4/0x9=
f0
 #1: ffffffff8ed5c8a0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2=
9/0x240
locks held by syz-executor/32096: 1, on CPU#1:
 #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: inet_rtm_newaddr+0x470/=
0x19f0
locks held by syz-executor/32103: 1, on CPU#1:
 #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: inet_rtm_newaddr+0x470/=
0x19f0
locks held by syz-executor/32108: 1, on CPU#1:
 #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: inet_rtm_newaddr+0x470/=
0x19f0
locks held by syz-executor/32116: 2, last CPU#1:
 #0: ffff88817a26d038 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x1dd=
/0x4e0
 #1: ffffffff8ed5c8a0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0x2=
9/0x240

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D

NMI backtrace for cpu 1
CPU: 1 UID: 0 PID: 35 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 nmi_cpu_backtrace+0x274/0x2d0
 nmi_trigger_cpumask_backtrace+0x17d/0x390
 sys_info+0x135/0x170
 watchdog+0xfd7/0x1030
 kthread+0x38b/0x480
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>
Sending NMI from CPU 1 to CPUs 0:
NMI backtrace for cpu 0
CPU: 0 UID: 0 PID: 27790 Comm: kworker/0:1 Not tainted syzkaller #0 PREEMPT=
(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Workqueue: events_long br_fdb_cleanup
RIP: 0010:lock_acquire+0x232/0x350
Code: ff ff ff e8 50 28 42 0a f7 44 24 10 00 02 00 00 0f 84 38 ff ff ff 65 =
48 8b 05 a2 e3 f1 11 48 3b 44 24 50 75 33 fb 48 83 c4 58 <5b> 41 5c 41 5d 4=
1 5e 41 5f 5d e9 bf 2c 45 0a cc 48 8d 3d 67 4e da
RSP: 0018:ffffc90000006dc0 EFLAGS: 00000296
RAX: 32f582729c8e9900 RBX: 0000000000000000 RCX: 8000000000000100
RDX: 00000000071bee9f RSI: ffffffff8e69ca38 RDI: ffffffff8c6da580
RBP: ffff888112a39e00 R08: ffffffff8177f1df R09: 0000000000000000
R10: ffffc90000006ef8 R11: ffffffff81b28790 R12: ffffffff8ed5c8a0
R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000246
FS:  0000000000000000(0000) GS:ffff88818d6cf000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000040 CR3: 000000000eb48000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 unwind_next_frame+0xac/0x2550
 arch_stack_walk+0x11b/0x150
 stack_trace_save+0xa9/0x100
 kasan_save_track+0x3e/0x80
 __kasan_slab_alloc+0x6c/0x80
 kmem_cache_alloc_node_noprof+0x354/0x610
 __alloc_skb+0x1db/0x7a0
 synproxy_send_client_synack+0x175/0xde0
 nft_synproxy_eval_v4+0x362/0x4e0
 nft_synproxy_do_eval+0x335/0x550
 nft_do_chain+0x132b/0x1b10
 nft_do_chain_ipv4+0x195/0x290
 nf_hook_slow+0xc5/0x220
 NF_HOOK+0x21f/0x3c0
 NF_HOOK+0x336/0x3c0
 process_backlog+0xa6b/0x18b0
 __napi_poll+0xaa/0x330
 net_rx_action+0x61d/0xf50
 handle_softirqs+0x226/0x860
 __irq_exit_rcu+0xcb/0x220
 irq_exit_rcu+0x9/0x30
 sysvec_apic_timer_interrupt+0xa6/0xc0
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20
RIP: 0010:lock_acquire+0x232/0x350
Code: ff ff ff e8 50 28 42 0a f7 44 24 10 00 02 00 00 0f 84 38 ff ff ff 65 =
48 8b 05 a2 e3 f1 11 48 3b 44 24 50 75 33 fb 48 83 c4 58 <5b> 41 5c 41 5d 4=
1 5e 41 5f 5d e9 bf 2c 45 0a cc 48 8d 3d 67 4e da
RSP: 0018:ffffc9000141faa0 EFLAGS: 00000296
RAX: 32f582729c8e9900 RBX: 0000000000000001 RCX: 0000000000000046
RDX: 000000004abe915d RSI: ffffffff8e69ca38 RDI: ffffffff8c6da580
RBP: ffff888112a39e00 R08: ffffffff818f9aba R09: 0000000000000000
R10: dffffc0000000000 R11: fffffbfff20f4830 R12: ffffc9000141fc40
R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000246
 process_scheduled_works+0xc03/0x1630
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
[chenguang.zhao@linux.dev davem@davemloft.net dsahern@kernel.org edumazet@g=
oogle.com horms@kernel.org idosch@nvidia.com kerneljasonxing@gmail.com kuba=
@kernel.org netdev@vger.kernel.org pabeni@redhat.com syzbot@syzkaller.appsp=
otmail.com zhaochenguang@kylinos.cn]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

