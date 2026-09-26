Received: from mail-oa2-f35.google.com (mail-oa2-f35.google.com [74.125.231.99])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2509256C87
	for <syzbot@lists.linux.dev>; Sat, 26 Sep 2026 20:10:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.99
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790453440; cv=pass; b=LwJJ82/7EAJSglwiqTrnypNFH+1DTIExqnuRr4bGjnxYCEAoKFquSU323DuCRjJAItYnw318SZH8FOxOXuzcSH1ElUBUBVMoytCqX1MNHVFU0WYcSBenJZhctlXeNCBQd1PUZxxr1HWW7u+6576Kpe91fTZAMN3S2d+CTGumwig=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790453440; c=relaxed/simple;
	bh=J/ctRWHfwat626bU/DAChlUYTECFcFyl7tLizV6xPrw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Dbt37U9A/m+bXvj8NEf5qtUtpoapQBkCTDiXnPrMaYwweLpk7/AnnPeFEs7V4bowokYKXh6/2pCc7o0WYVPQx/AjqIESKxq78v3cEoLbWv5lthfk7Rj4SKfZIAqOpum+PqdpDzxNUnjQVMacip8mMg7+A+6BQdzjvQgekebse2M=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Pzi54dCR; arc=pass smtp.client-ip=74.125.231.99
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Pzi54dCR"
Received: by mail-oa2-f35.google.com with SMTP id 586e51a60fabf-49386210e98so1077631fac.3
        for <syzbot@lists.linux.dev>; Sat, 26 Sep 2026 13:10:38 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790453437; cv=none;
        d=google.com; s=arc-20260327;
        b=jbNR5v7oeMxA8KVkMspIHI+sBB+VqwuBlU4yPel03xYusZovQLYW5MYJ3tcqRkExKw
         bG0s93DJ7QnpqUbPNzYM6gU/jmvwnUA+2dcPZ2aJGBa5Is2iyULcTFuIkrju6n1aXCFj
         H6VwXzJt4ckmwa5vHVfwdGCl/E+tkzUUFRfW1xTKzuI51E4E1Rdq3qakB1cKDBcJD1BX
         JC71lyHkC5aDle5FpP2+20draos58HIe7+WNsky6PWq4kyZbFyPf3dx3e24TdELBZicK
         EXuO1rv/QB8+JsHWptsbTWbaOiSIJPBUG6FzCDPv49PVPATI+kC1Jehd9eTLu9TBeW9P
         jPNQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=uJ7+SEk5WIUYoZdEQpiAaQDTauoJ0iAQLSEqR5KW8gE=;
        fh=E1iJS2yD3MHz5ITdQH4z8yQjIZj8Cwh6aN1Yba2alL4=;
        b=UjXlLl/9nUEBPM6UhzXhyfbpQfUnWcXHBuyblRL4DM1vckvLjnCmlWjFrd6EoTogz1
         EuJxxWNhQ/aC9nT6MMq//ZrqznIw2cXj2FJnAfzh4Qymh7XltYbo9L/FkJOVSyb47YO0
         UfQDXrfdbaVrizz1qOKALJH+w0ka3+mf5WMA5y4U5kv/SfaVIwNz1R6tHcUEErLh1+fk
         QNLc/28nXXfjj9tsfSGypbiqAntGgdj8A6j4xTxxTWITNbuulwHRVVFOKzwSXs6iol9c
         OLkwmajbqyMIKZpMAkUdj9hKP4GIWvJwDR22WOCmpoPA/BM31oAL1LziyKEs3FUoSZu1
         XELw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790453437; x=1791058237; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=uJ7+SEk5WIUYoZdEQpiAaQDTauoJ0iAQLSEqR5KW8gE=;
        b=Pzi54dCRy4vNDZYOnDU0vpq0yJoHzLCjRQtDyTFswv4w745RR3ImGflmpW4iyrjm+Z
         VB3PRJnCHQNdQTc4at7l3BXWNa4JDvq+8KCP/YxgdBZbbBQRbocfNnSJg18C3jSQIa4p
         XX+r/zdYtO+f0338VHpdRH15OcmT22Wa8S47WylXmwOeuw6loEL2TJ31bo0Z6GCf4NTd
         RHCbfBLEbafVmlQ8nIyr1YuB9o1QjlDRkGbNKbxEgHxLRWvw9vuNvMCZXrYNTMPBhJCF
         3KKLsokA27nKfZqIsuzfwDXf+KP7LXnxG7vsUAVrx30GrI67NyKkqWGehqt/3YeHvJAe
         I5uA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790453437; x=1791058237;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uJ7+SEk5WIUYoZdEQpiAaQDTauoJ0iAQLSEqR5KW8gE=;
        b=tY98lriB1RpU5S0Mwddb9jLaj1SNVSY1owkxg1rNZWcjQH5jwTBLxHN/HV84aFn4Mk
         mJz0QIKf/4sL8VeWGvveZI5T68fc2gQhK42Y+ieNB28u2cgGTujrakXiONPuAswiuN1Z
         fMA7Kz5MeXq6an7nOtdS3phR6tsnB5O//OcjchqnKFt/46rN2MhjSgLJzzgsYutyDgcE
         EfkXRAfmxbCPxo/czVTOYz0KnVM9r4ETVJ8Ix5I8oKofgwSFVEEGILDSoHAsL/QR9F4q
         puww1rEDW3ONWDhFwtDnpH6c7HSwUGH/Pztj5dNSPP2ZXh2bbQMhL9YJ+VpHW7qxjbli
         kaJQ==
X-Forwarded-Encrypted: i=1; AKwUvBygeMR5T2MERggC3sKHtHgLwaxUcNToLtwyVdBEziKHSl1AROYkLhwyidR4Ehlcm+tmxpVnMN0=@lists.linux.dev
X-Gm-Message-State: AFq9FYLT2CRsCQPJkCzfEXzn6MRrAJvX60c/0nwvWiwVee562Uv8arLB
	YrXW6tvFHRsHj80rr5U7SnUqiaasKR8us5jgkiORpaSGUs/NlS3BpYFbXY2eq1YpmXanuenTLK2
	RLKqA0FXLphL/2FUEqPinfA5M1/X+/N0AWFOZUmFb
X-Gm-Gg: AYBFou3BmZOQRwmg4JNzu76k2uI8pUMYlbSWLoTu48lvyXDYO/7fiSc//bkdIMiu89k
	HEocOb0VX49symyhnwtrwu4Fkg3lHwAVFhPLVVNjpY4inEIOp58EnKIF+Hr0HKmmhJh/JYxiRsV
	JWnTecguaofXwSxOHchnquoDMLyWaw6POOLRPziwYDWpX9aMtsEu6n0z4S93EB9lwWmQJw/j8+K
	r5Oe5Z8Ycoys2AbWIboTYDwrJorBsFSihSIN3CsCS+9lBGKTa0r56wSuy2QBEnK03sfE/EiGUI5
	tx7CY5zXsB/27nPkUJKyzTpJL9261MczGNF2BMNh81RajhUSbeXwzL9SR6/E7PRRvPu66fKcvCM
	S55L/srQAoUW+kdqzWCuX32EfRmGmeiNPSuDrWS+QbXTHE7ctDb9+tdQTignimiTe01Mp+U3wxY
	l2Rw8s
X-Received: by 2002:a05:6870:a0ad:b0:494:7af4:9549 with SMTP id
 586e51a60fabf-4947af4bfd3mr1941453fac.12.1790453436861; Sat, 26 Sep 2026
 13:10:36 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ab7cf8f.80e1c6cc.1e8e5f.0045.GAE@google.com>
In-Reply-To: <6ab7cf8f.80e1c6cc.1e8e5f.0045.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 26 Sep 2026 16:10:25 -0400
X-Gm-Features: AclHuK8N4V1Ku5vIRJDzVi2NEj984DP2TdyAeyjt7DlLsWMKzLrIcNrpsD2jk40
Message-ID: <CANp29Y6k9mAtOTwRQZXMC2QB0HHdJRiX+j+CVsay=_PoRPpuMQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ipvs: fix infinite loop with ipvlan L3 from
 unconditional ipvs_property clear
To: syzbot ci <syzbot+ci001f11078a9928f9@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Sep 26, 2026 at 9:58=E2=80=AFAM syzbot ci
<syzbot+ci001f11078a9928f9@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] ipvs: fix infinite loop with ipvlan L3 from unconditional ipvs_prope=
rty clear
> https://lore.kernel.org/all/20260924063312.1194019-1-chenguang.zhao@linux=
.dev
> * [PATCH net] ipvs: fix infinite loop with ipvlan L3 from unconditional i=
pvs_property clear
>
> and found the following issue:
> INFO: task hung in netdev_run_todo
>
> Full report is available here:
> https://ci.syzbot.org/series/b6478e5d-791e-4d72-8b8d-0fa748c90168
>
> ***
>
> INFO: task hung in netdev_run_todo
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      e7e0a54300a896e731dffd3e2e8dae5631d6243d
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/9865431b-add2-4883-97e2-de4ec60d9=
69e/config
> AI triage: https://ci.syzbot.org/findings/27d3caa2-dab2-445f-8ff6-e3beef3=
6b414/triage_trajectory
>
> INFO: task syz-executor:31961 blocked for more than 144 seconds.
>       Not tainted syzkaller #0
>       Blocked by coredump.
> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
> task:syz-executor    state:D stack:26120 pid:31961 tgid:31961 ppid:1     =
 task_flags:0x40054c flags:0x00080003
> Call Trace:
>  <TASK>
>  __schedule+0x17db/0x58f0
>  schedule+0x164/0x2b0
>  schedule_preempt_disabled+0x13/0x30
>  __mutex_lock+0x7c1/0x1550
>  rcu_barrier+0x4c/0x530
>  netdev_run_todo+0x2fc/0x1060
>  tun_chr_close+0x13c/0x1c0
>  __fput+0x418/0xa50
>  task_work_run+0x1d9/0x270
>  do_exit+0x73a/0x2360
>  do_group_exit+0x22d/0x2f0
>  get_signal+0x121b/0x12c0
>  arch_do_signal_or_restart+0xbb/0x860
>  exit_to_user_mode_loop+0x10e/0x770
>  do_syscall_64+0x328/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4b2cf9ddeb
> RSP: 002b:00007ffedfbd6b60 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: 0000000000000000 RBX: 00007ffedfbd6c10 RCX: 00007f4b2cf9ddeb
> RDX: 00007ffedfbd6be0 RSI: 00000000400454ca RDI: 00000000000000c8
> RBP: 00007f4b2d0359ad R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000008
> R13: 0000000000000003 R14: 00007ffedfbd6f08 R15: 0000000000000000
>  </TASK>
>
> Showing all locks held in the system:
> locks held by kworker/u8:1/13: 3, on CPU#1:
>  #0: ffff88817721b940 ((wq_completion)ipv6_addrconf){+.+.}-{0:0}, at: pro=
cess_scheduled_works+0x97a/0x1630
>  #1: ffffc90000127c40 ((work_completion)(&(&net->ipv6.addr_chk_work)->wor=
k)){+.+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
>  #2: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: addrconf_verify_work+=
0x19/0x30
> locks held by khungtaskd/35: 1, last CPU#1:
>  #0: ffffffff8ed5c8a0 (rcu_read_lock){....}-{1:3}, at: debug_show_all_loc=
ks+0x2e/0x180
> locks held by getty/5419: 2, on CPU#1:
>  #0: ffff88817a7b30a0 (&tty->ldisc_sem){++++}-{0:0}, at: tty_ldisc_ref_wa=
it+0x25/0x70
>  #1: ffffc900027682e8 (&ldata->atomic_read_lock){+.+.}-{4:4}, at: n_tty_r=
ead+0x45a/0x1360
> locks held by kworker/u8:4/9945: 2, last CPU#1:
>  #0: ffff888177d09940 ((wq_completion)bat_events){+.+.}-{0:0}, at: proces=
s_scheduled_works+0x97a/0x1630
>  #1: ffffc90006db7c40 ((work_completion)(&(&bat_priv->tt.work)->work)){+.=
+.}-{0:0}, at: process_scheduled_works+0x97a/0x1630
> locks held by kworker/u8:5/19085: 4, last CPU#1:
>  #0: ffff88817741f940 ((wq_completion)krds_cp_wq#12/0){+.+.}-{0:0}, at: p=
rocess_scheduled_works+0x97a/0x1630
>  #1: ffffc90003a0fc40 ((work_completion)(&(&cp->cp_conn_w)->work)){+.+.}-=
{0:0}, at: process_scheduled_works+0x97a/0x1630
>  #2: ffff888169e6a180 (&tc->t_conn_path_lock){+.+.}-{4:4}, at: rds_tcp_co=
nn_path_connect+0x1cc/0x920
>  #3: ffff888192303660 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: rds_tcp_tune+0=
x220/0x920
> locks held by kworker/u10:0/25329: 3, on CPU#1:
>  #0: ffff8881000ac140 ((wq_completion)events_unbound){+.+.}-{0:0}, at: pr=
ocess_scheduled_works+0x97a/0x1630
>  #1: ffffc9000418fc40 ((linkwatch_work).work){+.+.}-{0:0}, at: process_sc=
heduled_works+0x97a/0x1630
>  #2: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: linkwatch_event+0xe/0=
x60
> locks held by kworker/0:1/27790: 7, last CPU#0:
>  #0: ffff88810006a940 ((wq_completion)events_long){+.+.}-{0:0}, at: proce=
ss_scheduled_works+0x97a/0x1630
>  #1: ffffc9000141fc40 ((work_completion)(&(&br->gc_work)->work)){+.+.}-{0=
:0}, at: process_scheduled_works+0x97a/0x1630
>  #2: ffffffff8ed5c8a0 (rcu_read_lock){....}-{1:3}, at: process_backlog+0x=
3de/0x18b0
>  #3: ffffffff8ed5c8a0 (rcu_read_lock){....}-{1:3}, at: NF_HOOK+0x9e/0x3c0
>  #4: ffffffff8ed5c8a0 (rcu_read_lock){....}-{1:3}, at: ip_route_output_ke=
y_hash+0xd8/0x2a0
>  #5: ffff888121028298 (hrtimer_bases.lock){-.-.}-{2:2}, at: __hrtimer_rea=
rm_deferred+0x99/0x4b0
>  #6: ffffffff9aa29748 (&____s->seqcount#2){----}-{0:0}, at: __ip_vs_conn_=
in_get+0x2db/0x10f0
> locks held by syz.0.7664/31917: 1, on CPU#1:
>  #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: tun_chr_close+0x3e/0x=
1c0
> locks held by syz.3.7666/31925: 1, on CPU#1:
>  #0: ffffffff8ed62b38 (rcu_state.barrier_mutex){+.+.}-{4:4}, at: rcu_barr=
ier+0x4c/0x530
> locks held by syz.2.7668/31938: 1, on CPU#1:
>  #0: ffffffff8ed62b38 (rcu_state.barrier_mutex){+.+.}-{4:4}, at: rcu_barr=
ier+0x4c/0x530
> locks held by syz-executor/31955: 1, on CPU#1:
>  #0: ffffffff8ed62b38 (rcu_state.barrier_mutex){+.+.}-{4:4}, at: rcu_barr=
ier+0x4c/0x530
> locks held by syz-executor/31961: 1, on CPU#1:
>  #0: ffffffff8ed62b38 (rcu_state.barrier_mutex){+.+.}-{4:4}, at: rcu_barr=
ier+0x4c/0x530
> locks held by kworker/u8:7/31997: 4, on CPU#1:
>  #0: ffff8881012d5940 ((wq_completion)netns){+.+.}-{0:0}, at: process_sch=
eduled_works+0x97a/0x1630
>  #1: ffffc900079cfc40 (net_cleanup_work){+.+.}-{0:0}, at: process_schedul=
ed_works+0x97a/0x1630
>  #2: ffffffff90244da8 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xf=
5/0x810
>  #3: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: ops_undo_list+0x28e/0=
x8d0
> locks held by syz-executor/31998: 1, on CPU#1:
>  #0: ffffffff8ed62b38 (rcu_state.barrier_mutex){+.+.}-{4:4}, at: rcu_barr=
ier+0x4c/0x530
> locks held by syz-executor/32005: 1, on CPU#1:
>  #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: tun_chr_close+0x3e/0x=
1c0
> locks held by syz-executor/32009: 1, last CPU#1:
>  #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: tun_chr_close+0x3e/0x=
1c0
> locks held by syz-executor/32074: 1, on CPU#1:
>  #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0xc10/0x=
1c30
> locks held by syz-executor/32077: 1, on CPU#1:
>  #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_newlink+0xc10/0x=
1c30
> locks held by syz-executor/32095: 2, last CPU#1:
>  #0: ffff88816f5b1d38 (&mm->mmap_lock){++++}-{4:4}, at: exit_mmap+0x1a4/0=
x9f0
>  #1: ffffffff8ed5c8a0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0=
x29/0x240
> locks held by syz-executor/32096: 1, on CPU#1:
>  #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: inet_rtm_newaddr+0x47=
0/0x19f0
> locks held by syz-executor/32103: 1, on CPU#1:
>  #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: inet_rtm_newaddr+0x47=
0/0x19f0
> locks held by syz-executor/32108: 1, on CPU#1:
>  #0: ffffffff90253600 (rtnl_mutex){+.+.}-{4:4}, at: inet_rtm_newaddr+0x47=
0/0x19f0
> locks held by syz-executor/32116: 2, last CPU#1:
>  #0: ffff88817a26d038 (&mm->mmap_lock){++++}-{4:4}, at: vm_mmap_pgoff+0x1=
dd/0x4e0
>  #1: ffffffff8ed5c8a0 (rcu_read_lock){....}-{1:3}, at: __pte_offset_map+0=
x29/0x240
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>
> NMI backtrace for cpu 1
> CPU: 1 UID: 0 PID: 35 Comm: khungtaskd Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  nmi_cpu_backtrace+0x274/0x2d0
>  nmi_trigger_cpumask_backtrace+0x17d/0x390
>  sys_info+0x135/0x170
>  watchdog+0xfd7/0x1030
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> Sending NMI from CPU 1 to CPUs 0:
> NMI backtrace for cpu 0
> CPU: 0 UID: 0 PID: 27790 Comm: kworker/0:1 Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: events_long br_fdb_cleanup
> RIP: 0010:lock_acquire+0x232/0x350
> Code: ff ff ff e8 50 28 42 0a f7 44 24 10 00 02 00 00 0f 84 38 ff ff ff 6=
5 48 8b 05 a2 e3 f1 11 48 3b 44 24 50 75 33 fb 48 83 c4 58 <5b> 41 5c 41 5d=
 41 5e 41 5f 5d e9 bf 2c 45 0a cc 48 8d 3d 67 4e da
> RSP: 0018:ffffc90000006dc0 EFLAGS: 00000296
> RAX: 32f582729c8e9900 RBX: 0000000000000000 RCX: 8000000000000100
> RDX: 00000000071bee9f RSI: ffffffff8e69ca38 RDI: ffffffff8c6da580
> RBP: ffff888112a39e00 R08: ffffffff8177f1df R09: 0000000000000000
> R10: ffffc90000006ef8 R11: ffffffff81b28790 R12: ffffffff8ed5c8a0
> R13: 0000000000000002 R14: 0000000000000000 R15: 0000000000000246
> FS:  0000000000000000(0000) GS:ffff88818d6cf000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000040 CR3: 000000000eb48000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  unwind_next_frame+0xac/0x2550
>  arch_stack_walk+0x11b/0x150
>  stack_trace_save+0xa9/0x100
>  kasan_save_track+0x3e/0x80
>  __kasan_slab_alloc+0x6c/0x80
>  kmem_cache_alloc_node_noprof+0x354/0x610
>  __alloc_skb+0x1db/0x7a0
>  synproxy_send_client_synack+0x175/0xde0
>  nft_synproxy_eval_v4+0x362/0x4e0
>  nft_synproxy_do_eval+0x335/0x550
>  nft_do_chain+0x132b/0x1b10
>  nft_do_chain_ipv4+0x195/0x290
>  nf_hook_slow+0xc5/0x220
>  NF_HOOK+0x21f/0x3c0
>  NF_HOOK+0x336/0x3c0
>  process_backlog+0xa6b/0x18b0
>  __napi_poll+0xaa/0x330
>  net_rx_action+0x61d/0xf50
>  handle_softirqs+0x226/0x860
>  __irq_exit_rcu+0xcb/0x220
>  irq_exit_rcu+0x9/0x30
>  sysvec_apic_timer_interrupt+0xa6/0xc0
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> RIP: 0010:lock_acquire+0x232/0x350
> Code: ff ff ff e8 50 28 42 0a f7 44 24 10 00 02 00 00 0f 84 38 ff ff ff 6=
5 48 8b 05 a2 e3 f1 11 48 3b 44 24 50 75 33 fb 48 83 c4 58 <5b> 41 5c 41 5d=
 41 5e 41 5f 5d e9 bf 2c 45 0a cc 48 8d 3d 67 4e da
> RSP: 0018:ffffc9000141faa0 EFLAGS: 00000296
> RAX: 32f582729c8e9900 RBX: 0000000000000001 RCX: 0000000000000046
> RDX: 000000004abe915d RSI: ffffffff8e69ca38 RDI: ffffffff8c6da580
> RBP: ffff888112a39e00 R08: ffffffff818f9aba R09: 0000000000000000
> R10: dffffc0000000000 R11: fffffbfff20f4830 R12: ffffc9000141fc40
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000246
>  process_scheduled_works+0xc03/0x1630
>  worker_thread+0xa47/0xfb0
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [chenguang.zhao@linux.dev davem@davemloft.net dsahern@kernel.org edumazet=
@google.com horms@kernel.org idosch@nvidia.com kerneljasonxing@gmail.com ku=
ba@kernel.org netdev@vger.kernel.org pabeni@redhat.com syzbot@syzkaller.app=
spotmail.com zhaochenguang@kylinos.cn]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6ab7cf8f.80e1c6cc.1e8e5f.0045.GAE%40google.com.
