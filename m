Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F4232C8B
	for <syzbot@lists.linux.dev>; Wed, 14 Oct 2026 09:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791968793; cv=pass; b=LUZtLKKX0/a4J64aanRXPLMZc+WLniLoOq9UPPPHj+NKey7qCxAjL2hh4hR2A6EM5wSSwPq6pys/RyX9+YURCkRK3OfKmzBCfulJlIJ7zo0GAt9jb7SPdpF8m71LYmFYtlHpra8XBQ/YWEBMK7YYP7WX16BTwD7Y4t+jJa6UYuQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791968793; c=relaxed/simple;
	bh=B1PD//++f9vE9JL/fzReHom4I85H8CAj3DF43SEGk/A=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cc2TcJu+iTbMoBgKd/20awbZFYRuQUnPOw0Ugzai0N0v/OY/MH5RRFIwDT+p54kPMQC3ZHett8DStPQtz9ID8CwNN8040fq7hFXqxXraVYtHPFiWKlAT/HQmwt/LMmmxyEjYZjeHGeGLC7ug4U4mDFR+p5+a9Dq+pgy4QYXT3Ys=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nePLvEec; arc=pass smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nePLvEec"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-93e7ad9f78dso468659585a.1
        for <syzbot@lists.linux.dev>; Wed, 14 Oct 2026 02:06:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791968790; cv=none;
        d=google.com; s=arc-20260327;
        b=oZtAoQPqcLeKU1TRzvUpJ0cY38CaZylfeVXQkBQB2Kkoxq1qNiEBVam9pjKthqmlzg
         9QSONswcXoMEoTkjp2S+GgayuBoAVgQRm0e9L2V5Zz/qMKyg2J4qdA8KdpGjNl7nGPJF
         YVS8oa9Dot/ZH5ZoWR+0VT9FT757dLOBaNhqVLKeogbrGOUTYjZWLi5lJyah+8INJcUd
         pe0A7jMm6uZCgFgUNLxjbl7H7jt2HSpmjahIPHR03yHbzyw8e3x9ftmJeJ6rCMn1aThs
         LXtDIcGAYT1YTldqCQWW0Qj0Zzcle5HJirh2uq6foDV2GqMY/K6aezi2jQo9hSMs3HWj
         Y5rg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=qlmqAiKsLPHKpBUfpucJYqNKmO/CBMHSzFxrVoBQ1tM=;
        fh=3NNLnV103dIieo1tKmaoHkd9cpvMhONR7VT1dcxHwIg=;
        b=DvOr7seSfFIHSO7J8n2C6kfPmJbqXh3eGOKS9GBsy1GVLlt4upBsNVG0mn0cUrOP15
         E+GTWt4xPTl6JTAH+p+fAgu0ypobY9UGCKw9Z8eBIKLlfbaJtFT3h201aJLrxLtsfRJI
         PlnIeVmHqOSAjtXWNg2bRHHjs6dJdbsywcTEzRF733f+QUjycbsIgCuZZwe63HNd8Y0U
         KMW9LGZinIqv1WDuFKbJv1akUFXA0ZZxCvtEQ+WwUvWRb1HLykuw7x1gt2KzzfrzMi09
         GzZDqzUhC7khdAeh8Ewxr2o/SxYmIhj9a8BWqcX0Yyzbe+MHQySlmtOGys+hz1AUMC4f
         MbNA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791968790; x=1792573590; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=qlmqAiKsLPHKpBUfpucJYqNKmO/CBMHSzFxrVoBQ1tM=;
        b=nePLvEec3xILKHtMoURizvBcD70haytc+ZabTtSO+TQIDBd8dmZG0T0VUfdwT8Z3/y
         Xp/4xuBPT2ri9TZcnbJvIpIzL7anZl+aRM+KM40K2IEjZrUBODRhWnb4aQ0UOrn778Qp
         U46IdbFkjz8HvE48IcfdqN54oegf1zvl9h6Ud5BCwPDy5QS+jKcnunPgM/A3y/S1OZzw
         a/Q4RjZa0iVSDP4gOE+Pz3njd3CA3Q8tSRNpAO4mQbHG3sDeUryaCrDrbBj1xnk+dQNV
         mC8V4yBt+bCjlyX8vhCJTzewNyMiGqBljbnEodoXWos6TIBF6vGs2CmAAX4LlPkUxsNB
         x7+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791968790; x=1792573590;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qlmqAiKsLPHKpBUfpucJYqNKmO/CBMHSzFxrVoBQ1tM=;
        b=qsZO30JjH8MvEv4eveAUBSDZpwhdGRcr0mgDYg7FFWJ0nvXrWfBjEdlpGPQ29OOJSD
         U1A1t6J51Bewh/9uCkoxIYisJ6saR+xzDp8xWTNIwhpJoq+JHGZzUlwvKXnugV7qdWON
         D1ul/UEmvY44NmszenTuulPSQXplEVmTHJhZOPEFjUYZrGzfu36tPYi7aaloJ++1thX1
         SPnC0GyubYrea9dTHgc/pReO+0PbNHGdXQpS+1WQNKbiQcCo3jnllM7ZVG0B7Jj8e4tV
         6ZJHcwsRGPoqdNah9mxwoCz/w/+MaP5s9skT5LXrz3gMEdqthypfaLCF14AfsUmHqcDO
         PKCQ==
X-Forwarded-Encrypted: i=1; AKwUvBw9lIcUxADOOXSYwp+6laJ7fqmp2RiGu1P3IiuRubuiYAcOSGSzSioTD3Y5x9kk7RkbscOlczc=@lists.linux.dev
X-Gm-Message-State: AFq9FYJzjG89jIugCidr1VFz8Pgx15AMttteU3HqvzJFnKhhA6lyG6DY
	2liGJI9XC4iorjPsRzAKRgER3SxRtEebEcqZD5od7X8nBjO/J5HqNisRI2+Zhk8XR5a8cX1FzTy
	7p3nj1UCBjjwwhQZABOkZjBqAvulVdviXSOL1r1P1
X-Gm-Gg: AYBFou05Pp36Zt/KY0AxzTwnnyViFKqueUS3pT46NSNRa+3g+ledhf0M3+xAaFDZlHd
	IOiPVhXXhkbnH16S7KOOIS3w4Q6SM62H44KdXzpJ2PplttZTlj5tw5OpwCDkOzqEkbVUowoRp0h
	sLo79ydIKB3FwrAH1KQnBBtf/Ydxy8mPcYQkfqr30z88TQb8LEroR3bNd3itg5cjPwZK05p3fjr
	Gqaw3g6rRZoYO3wfLAH09tTFvxgFGsUDjtsSRPprRf40ebM9oUoH7KM744c9c6uQYYzBu8dEMoo
	lqesVaVE31mXHdUaz2t1KJNxil8CH9zbHxni4viMLOvFCQu4cAaP64gk1QtiA2J3qzaYMraCCKd
	KFaNBeSjl2tjwNUb6O26irdONlWQ0jDHUKl6w+xaT0A==
X-Received: by 2002:a05:620a:27cb:b0:93e:dcb4:c73e with SMTP id
 af79cd13be357-93edcb4cd6emr1524081685a.5.1791968788817; Wed, 14 Oct 2026
 02:06:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6acf4495.38256f13.2006af.00f2.GAE@google.com>
In-Reply-To: <6acf4495.38256f13.2006af.00f2.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Wed, 14 Oct 2026 11:06:17 +0200
X-Gm-Features: AclHuK8ROykRkDSmx-oNkY4QZpoyV3izFSSimzbNoQCpxrw1OM924MlLIb8Fsd8
Message-ID: <CAJWNTGwhr43xjR5y_NWtmV3Tt_tU8aVrmVoEP4j1ryB8pPPssg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: pin file with get_file_rcu()
 before reading f_cred
To: syzbot ci <syzbot+ci8b9a443f75341413@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Wed, Oct 14, 2026 at 11:00=E2=80=AFAM syzbot ci
<syzbot+ci8b9a443f75341413@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] netfilter: pin file with get_file_rcu() before reading f_cred
> https://lore.kernel.org/all/20261013234329.2797868-1-tristmd@gmail.com
> * [PATCH nf 1/5] netfilter: xt_owner: pin file with get_file_rcu() before=
 reading f_cred
> * [PATCH nf 2/5] netfilter: nft_meta: pin file with get_file_rcu() before=
 reading f_cred
> * [PATCH nf 3/5] netfilter: nfnetlink_log: pin file with get_file_rcu() b=
efore reading f_cred
> * [PATCH nf 4/5] netfilter: nfnetlink_queue: pin file with get_file_rcu()=
 before reading f_cred
> * [PATCH nf 5/5] netfilter: nf_log_syslog: pin file with get_file_rcu() b=
efore reading f_cred
>
> and found the following issues:
> * BUG: soft lockup in inet_release
> * BUG: soft lockup in tcp_write_timer
> * INFO: rcu detected stall in __sock_release
> * INFO: rcu detected stall in do_idle
> * INFO: rcu detected stall in inet_release
>
> Full report is available here:
> https://ci.syzbot.org/series/12bffa5e-1b93-48be-972a-d42a2d609c08
>
> ***
>
> BUG: soft lockup in inet_release
>
> tree:      nf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf.git
> base:      ab699d296e066eb64f51d2a8a1d42237a3b186c8
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/2622922d-df96-41f8-b0fb-efd53f4ef=
bef/config
> AI triage: https://ci.syzbot.org/findings/59e26111-6a1e-48ea-b7e6-a588d2e=
f12fe/triage_trajectory
>
> watchdog: BUG: soft lockup - CPU#0 stuck for 143s! [syz.1.665:7928]
> Modules linked in:
> irq event stamp: 53103
> hardirqs last  enabled at (53102): [<ffffffff8be80f08>] irqentry_exit+0x2=
18/0x910
> hardirqs last disabled at (53103): [<ffffffff8be7fc2e>] sysvec_apic_timer=
_interrupt+0xe/0xc0
> softirqs last  enabled at (2568): [<ffffffff8a73a559>] ipt_do_table+0x2b9=
/0x15d0
> softirqs last disabled at (2574): [<ffffffff8a01a607>] nfulnl_log_packet+=
0x267/0x2a50
> CPU: 0 UID: 0 PID: 7928 Comm: syz.1.665 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__sanitizer_cov_trace_pc+0x75/0x80
> Code: 18 17 00 00 83 fa 02 75 21 48 8b 91 20 17 00 00 48 8b 32 48 8d 7e 0=
1 8b 89 1c 17 00 00 48 39 cf 73 08 48 89 3a 48 89 44 f2 08 <e9> 96 1b 23 0a=
 cc 0f 1f 44 00 00 90 90 90 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc90004a2eec0 EFLAGS: 00000293
> RAX: ffffffff8255c089 RBX: ffff8880254a0050 RCX: ffff88810c5c5a00
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
> RBP: ffffc90004a2f100 R08: ffff8881b97d955f R09: 1ffff110372fb2ab
> R10: dffffc0000000000 R11: ffffed10372fb2ac R12: dffffc0000000000
> R13: 1ffff11004a9400a R14: ffff8881b97d9400 R15: fffffffffffffff5
> FS:  000055559266b500(0000) GS:ffff88818c4c3000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000d8e000 CR3: 0000000115740000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  get_file_rcu+0xd9/0x100
>  nfulnl_log_packet+0x1b02/0x2a50
>  nf_log_packet+0x49a/0x650
>  nft_log_eval+0x2c4/0x3b0
>  nft_do_chain+0x48d/0x1b10
>  nft_do_chain_ipv4+0x195/0x290
>  nf_hook_slow+0xc5/0x220
>  nf_hook+0x22a/0x3a0
>  __ip_local_out+0x558/0x6a0
>  ip_local_out+0x2a/0x190
>  __ip_queue_xmit+0x10df/0x1b10
>  __tcp_transmit_skb+0x2d18/0x47c0
>  tcp_send_active_reset+0x2a8/0x5a0
>  __tcp_close+0x43d/0xe70
>  tcp_close+0x28/0x110
>  inet_release+0x143/0x190
>  __sock_release+0xa0/0x1f0
>  sock_close+0x1c/0x30
>  __fput+0x418/0xa50
>  task_work_run+0x1d9/0x270
>  exit_to_user_mode_loop+0x204/0x770
>  do_syscall_64+0x328/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9944b9e1d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdbcd33af8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 00007f9944e27da0 RCX: 00007f9944b9e1d9
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 00007f9944e27da0 R08: 00007f9944e26038 R09: 0000000000000000
> R10: 00000000003ffc6c R11: 0000000000000246 R12: 00000000000187bd
> R13: 00007f9944e2609c R14: 00000000000184ed R15: 00007ffdbcd33c00
>  </TASK>
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: bond1 bond_alb_monitor
> RIP: 0010:kasan_check_range+0x7/0x2c0
> Code: 48 c7 c6 bc 1f 6f 8e e8 47 7c ef fe 90 0f 0b cc cc cc cc 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 55 41 57 <41> 56 41 55 41=
 54 53 b0 01 48 85 f6 0f 84 ae 01 00 00 4c 8d 04 37
> RSP: 0018:ffffc90000116548 EFLAGS: 00000246
> RAX: 0000000000000001 RBX: ffff8881b9073810 RCX: ffffffff8beacbc2
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff8881b9073810
> RBP: ffffc90000116650 R08: ffff8881b9073813 R09: 1ffff1103720e702
> R10: dffffc0000000000 R11: ffffed103720e703 R12: 1ffff92000022cb4
> R13: 0000000000000001 R14: ffffc900001165c0 R15: 1ffff1103720e702
> FS:  0000000000000000(0000) GS:ffff8882a7cc3000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200001000000 CR3: 00000001af03e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  native_queued_spin_lock_slowpath+0xc2/0x960
>  do_raw_spin_lock+0x26c/0x2f0
>  nfulnl_log_packet+0x267/0x2a50
>  nf_log_packet+0x49a/0x650
>  nft_log_eval+0x2c4/0x3b0
>  nft_do_chain+0x48d/0x1b10
>  nft_do_chain_ipv4+0x195/0x290
>  nf_hook_slow+0xc5/0x220
>  nf_hook+0x22a/0x3a0
>  __ip_local_out+0x558/0x6a0
>  ip_local_out+0x2a/0x190
>  iptunnel_xmit+0x626/0xd10
>  udp_tunnel_xmit_skb+0x29b/0x3e0
>  geneve_xmit+0x24f4/0x3350
>  dev_hard_start_xmit+0x2cd/0x830
>  __dev_queue_xmit+0x14d1/0x3920
>  alb_send_lp_vid+0x348/0x550
>  alb_send_learning_packets+0x12c/0x300
>  bond_alb_monitor+0x3d0/0x1820
>  process_scheduled_works+0xc3d/0x1630
>  worker_thread+0xa47/0xfb0
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
>
>
> ***
>
> BUG: soft lockup in tcp_write_timer
>
> tree:      nf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf.git
> base:      ab699d296e066eb64f51d2a8a1d42237a3b186c8
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/2622922d-df96-41f8-b0fb-efd53f4ef=
bef/config
> AI triage: https://ci.syzbot.org/findings/a1db8c69-1d04-4e7c-9c73-c0a772d=
9d5b8/triage_trajectory
>
> watchdog: BUG: soft lockup - CPU#0 stuck for 123s! [swapper/0:0]
> Modules linked in:
> irq event stamp: 1709023
> hardirqs last  enabled at (1709022): [<ffffffff810014ca>] asm_sysvec_apic=
_timer_interrupt+0x1a/0x20
> hardirqs last disabled at (1709023): [<ffffffff8be7fc2e>] sysvec_apic_tim=
er_interrupt+0xe/0xc0
> softirqs last  enabled at (1685548): [<ffffffff8188fd3b>] __irq_exit_rcu+=
0xcb/0x220
> softirqs last disabled at (1685579): [<ffffffff8188fd3b>] __irq_exit_rcu+=
0xcb/0x220
> CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:get_file_rcu+0xbe/0x100
> Code: 72 ff 4c 89 f7 e8 22 b1 f6 ff 49 c7 c7 f5 ff ff ff 49 81 ff 00 f0 f=
f ff 77 10 eb 35 e8 ab 2d 72 ff 49 81 ff 00 f0 ff ff 76 27 <e8> 9d 2d 72 ff=
 43 80 7c 25 00 00 0f 85 60 ff ff ff e9 63 ff ff ff
> RSP: 0018:ffffc90000006fd0 EFLAGS: 00000206
> RAX: ffffffff8255c089 RBX: ffff88811b418c50 RCX: ffffffff8fa8f000
> RDX: 0000000000000100 RSI: 0000000000000100 RDI: 0000000000000002
> RBP: 0000000000000000 R08: 0000000000000100 R09: 1ffff11022ee972b
> R10: dffffc0000000000 R11: ffffed1022ee972c R12: dffffc0000000000
> R13: 1ffff1102368318a R14: ffff88811774b800 R15: fffffffffffffff5
> FS:  0000000000000000(0000) GS:ffff88818c4c3000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f679c7eb8c0 CR3: 000000000fb48000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  owner_mt+0x28a/0x970
>  nft_match_eval+0x1ad/0x2b0
>  nft_do_chain+0x48d/0x1b10
>  nft_do_chain_ipv4+0x195/0x290
>  nf_hook_slow+0xc5/0x220
>  nf_hook+0x22a/0x3a0
>  __ip_local_out+0x558/0x6a0
>  ip_local_out+0x2a/0x190
>  __ip_queue_xmit+0x10df/0x1b10
>  __tcp_transmit_skb+0x2d18/0x47c0
>  __tcp_retransmit_skb+0xb15/0x16a0
>  tcp_retransmit_skb+0x33/0x440
>  tcp_retransmit_timer+0x1d5f/0x3830
>  tcp_write_timer+0x15c/0x2d0
>  call_timer_fn+0x18d/0x5f0
>  __run_timer_base+0x652/0x8b0
>  run_timer_softirq+0xb7/0x170
>  handle_softirqs+0x226/0x860
>  __irq_exit_rcu+0xcb/0x220
>  irq_exit_rcu+0x9/0x30
>  sysvec_apic_timer_interrupt+0xa6/0xc0
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> RIP: 0010:pv_native_safe_halt+0xf/0x20
> Code: ab 8b 02 c3 cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 9=
0 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d d3 85 21 00 fb f4 <e9> 8c 08 03 00=
 cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
> RSP: 0018:ffffffff8fa07ca0 EFLAGS: 00000202
> RAX: 000000000019b849 RBX: ffffffff819bcc20 RCX: 8000000000000001
> RDX: 0000000000000001 RSI: ffffffff8e46796e RDI: ffffffff8c6dd780
> RBP: ffffffff8fa07d78 R08: ffff888120e33a1b R09: 1ffff110241c6743
> R10: dffffc0000000000 R11: ffffed10241c6744 R12: 0000000000000000
> R13: 1ffffffff1f51e00 R14: 1ffffffff1f40f9c R15: dffffc0000000000
>  default_idle+0x9/0x20
>  default_idle_call+0x72/0xb0
>  do_idle+0x2e0/0x540
>  cpu_startup_entry+0x43/0x60
>  rest_init+0x378/0x3a0
>  start_kernel+0x392/0x3e0
>  x86_64_start_reservations+0x24/0x30
>  x86_64_start_kernel+0x137/0x1b0
>  common_startup_64+0x13e/0x157
>  </TASK>
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 UID: 0 PID: 24 Comm: ksoftirqd/1 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:native_apic_msr_write+0x39/0x50
> Code: 74 2a 83 ff 30 74 25 eb 10 81 ff d0 00 00 00 74 1b 81 ff e0 00 00 0=
0 74 13 c1 ef 04 81 c7 00 08 00 00 89 f9 89 f0 31 d2 0f 30 <66> 90 c3 cc cc=
 cc cc cc 89 f6 31 d2 e9 a6 07 a8 03 66 0f 1f 44 00
> RSP: 0018:ffffc900001e7ab0 EFLAGS: 00000046
> RAX: 000000000003088e RBX: ffff88823c623c80 RCX: 0000000000000838
> RDX: 0000000000000000 RSI: 000000000003088e RDI: 0000000000000838
> RBP: ffffc900001e7b70 R08: 0000000000000100 R09: 0000000000000001
> R10: 0000000000000003 R11: ffffffff81754510 R12: 000000000003088e
> R13: dffffc0000000000 R14: 0000000010007570 R15: 0000000000000020
> FS:  0000000000000000(0000) GS:ffff8882a7cc3000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f272104ea09 CR3: 00000001be49e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  lapic_next_event+0x11/0x20
>  clockevents_program_event+0x385/0x630
>  __hrtimer_rearm_deferred+0x36c/0x4b0
>  irqentry_exit+0x8d3/0x910
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> RIP: 0010:_raw_spin_unlock_irqrestore+0x47/0x80
> Code: f7 e8 cd 2f b9 f5 f7 c3 00 02 00 00 74 05 e8 50 7d e5 f5 9c 58 a9 0=
0 02 00 00 75 29 f7 c3 00 02 00 00 74 01 fb bf 01 00 00 00 <e8> 04 2d aa f5=
 65 48 8b 05 4c 10 ab 08 48 85 c0 74 18 5b 41 5e e9
> RSP: 0018:ffffc900001e7cc8 EFLAGS: 00000206
> RAX: 0000000000000006 RBX: 0000000000000283 RCX: 8000000000000101
> RDX: 0000000000000000 RSI: ffffffff8e46796e RDI: 0000000000000001
> RBP: 0000000000000003 R08: ffffffff917a6d7f R09: 1ffffffff22f4daf
> R10: dffffc0000000000 R11: fffffbfff22f4db0 R12: 0000000000000009
> R13: 0000000000000008 R14: ffff88823c628280 R15: 0000000000000100
>  handle_softirqs+0x226/0x860
>  run_ksoftirqd+0x36/0x60
>  smpboot_thread_fn+0x565/0xa70
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
>
>
> ***
>
> INFO: rcu detected stall in __sock_release
>
> tree:      nf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf.git
> base:      ab699d296e066eb64f51d2a8a1d42237a3b186c8
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/2622922d-df96-41f8-b0fb-efd53f4ef=
bef/config
> AI triage: https://ci.syzbot.org/findings/04844d1b-14a6-4ba3-836e-490ed67=
242c5/triage_trajectory
>
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu:    (detected by 1, t=3D10502 jiffies, g=3D21357, q=3D124 ncpus=3D2)
> rcu: All QSes seen, last rcu_preempt kthread activity 10502 (4294959758-4=
294949256), jiffies_till_next_fqs=3D1, root ->qsmask 0x0
> rcu: rcu_preempt kthread starved for 10502 jiffies! g21357 f0x2 RCU_GP_WA=
IT_FQS(5) ->state=3DR ->cpu=3D1
> rcu:    Unless rcu_preempt kthread gets sufficient CPU time, OOM is now e=
xpected behavior.
> rcu: RCU grace-period kthread stack dump:
> task:rcu_preempt     state:R  running task     stack:27496 pid:17    tgid=
:17    ppid:2      task_flags:0x208040 flags:0x00080000
> Call Trace:
>  <TASK>
>  __schedule+0x17db/0x58f0
>  schedule+0x164/0x2b0
>  schedule_timeout+0x152/0x2c0
>  rcu_gp_fqs_loop+0x30c/0x11f0
>  rcu_gp_kthread+0x9e/0x2b0
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> rcu: Stack dump where RCU GP kthread last ran:
> CPU: 1 UID: 0 PID: 8420 Comm: syz.2.714 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:its_return_thunk+0x0/0x10
> Code: cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc c=
c cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc cc <c3> cc 90 90 90=
 90 90 90 90 90 90 90 90 90 90 90 e9 3b 05 48 f5 cc
> RSP: 0018:ffffc90000a17ce0 EFLAGS: 00000246
> RAX: ffffffff8255c073 RBX: ffff8881bab1c250 RCX: ffff88810e591e00
> RDX: 0000000000000300 RSI: 0000000000000100 RDI: 0000000000000002
> RBP: ffffc90000a17f00 R08: 0000000000000100 R09: 1ffff1102da8a8ab
> R10: dffffc0000000000 R11: ffffed102da8a8ac R12: dffffc0000000000
> R13: 1ffff1103756384a R14: ffff88816d454400 R15: fffffffffffffff5
> FS:  0000555583040500(0000) GS:ffff8882a7cc3000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000000110c35ea7b CR3: 00000001bd488000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  get_file_rcu+0xc3/0x100
>  nfulnl_log_packet+0x1b02/0x2a50
>  nf_log_packet+0x49a/0x650
>  nft_log_eval+0x2c4/0x3b0
>  nft_do_chain+0x48d/0x1b10
>  nft_do_chain_ipv4+0x195/0x290
>  nf_hook_slow+0xc5/0x220
>  nf_hook+0x22a/0x3a0
>  __ip_local_out+0x558/0x6a0
>  ip_local_out+0x2a/0x190
>  __ip_queue_xmit+0x10df/0x1b10
>  __tcp_transmit_skb+0x2d18/0x47c0
>  tcp_write_xmit+0x1bfa/0x6400
>  tcp_send_loss_probe+0x20b/0x920
>  tcp_write_timer+0x15c/0x2d0
>  call_timer_fn+0x18d/0x5f0
>  __run_timer_base+0x652/0x8b0
>  run_timer_softirq+0xb7/0x170
>  handle_softirqs+0x226/0x860
>  __irq_exit_rcu+0xcb/0x220
>  irq_exit_rcu+0x9/0x30
>  sysvec_apic_timer_interrupt+0xa6/0xc0
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> RIP: 0010:lock_acquire+0x232/0x350
> Code: ff ff ff e8 b0 bd 44 0a f7 44 24 10 00 02 00 00 0f 84 38 ff ff ff 6=
5 48 8b 05 42 88 f2 12 48 3b 44 24 50 75 33 fb 48 83 c4 58 <5b> 41 5c 41 5d=
 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8d 3d 87 5f da
> RSP: 0018:ffffc900063cfc40 EFLAGS: 00000292
> RAX: be519d89c48d4400 RBX: 0000000000000001 RCX: 0000000000000046
> RDX: 000000000185c73d RSI: ffffffff8e6f0840 RDI: ffffffff8c6dd780
> RBP: ffff88810e591e00 R08: ffffffff89a7dfaa R09: 0000000000000000
> R10: dffffc0000000000 R11: ffffffff89a90a00 R12: ffff8880134a6240
> R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000246
>  down_write+0x96/0x200
>  __sock_release+0x7a/0x1f0
>  sock_close+0x1c/0x30
>  __fput+0x418/0xa50
>  task_work_run+0x1d9/0x270
>  exit_to_user_mode_loop+0x204/0x770
>  do_syscall_64+0x328/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2ced79e1d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffd96153a8 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 00007fffd9615490 RCX: 00007f2ced79e1d9
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 000000000001da87 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000001b31520000 R11: 0000000000000246 R12: 00007fffd96154d0
> R13: 00007f2ceda25fac R14: 000000000001dad7 R15: 00007f2ceda25fa0
>  </TASK>
>
>
> ***
>
> INFO: rcu detected stall in do_idle
>
> tree:      nf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf.git
> base:      ab699d296e066eb64f51d2a8a1d42237a3b186c8
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/2622922d-df96-41f8-b0fb-efd53f4ef=
bef/config
> AI triage: https://ci.syzbot.org/findings/96ab4606-bde9-46d9-9093-4130f1f=
54479/triage_trajectory
>
> rcu: INFO: rcu_preempt self-detected stall on CPU
> rcu:    0-...!: (1 GPs behind) idle=3D96fc/1/0x4000000000000000 softirq=
=3D149048/149048 fqs=3D48
> rcu:    (t=3D10500 jiffies g=3D207709 q=3D131 ncpus=3D2)
> rcu: rcu_preempt kthread timer wakeup didn't happen for 10402 jiffies! g2=
07709 f0x0 RCU_GP_WAIT_FQS(5) ->state=3DI
> rcu:    Possible timer handling issue on cpu=3D1 timer-softirq=3D87930
> rcu: rcu_preempt kthread starved for 10403 jiffies! g207709 f0x0 RCU_GP_W=
AIT_FQS(5) ->state=3DI ->cpu=3D1
> rcu:    Unless rcu_preempt kthread gets sufficient CPU time, OOM is now e=
xpected behavior.
> rcu: RCU grace-period kthread stack dump:
> task:rcu_preempt     state:I stack:28104 pid:17    tgid:17    ppid:2     =
 task_flags:0x208040 flags:0x00080000
> Call Trace:
>  <TASK>
>  __schedule+0x17db/0x58f0
>  schedule+0x164/0x2b0
>  schedule_timeout+0x152/0x2c0
>  rcu_gp_fqs_loop+0x30c/0x11f0
>  rcu_gp_kthread+0x9e/0x2b0
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> rcu: Stack dump where RCU GP kthread last ran:
> Sending NMI from CPU 0 to CPUs 1:
> NMI backtrace for cpu 1
> CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:kasan_check_range+0x1d/0x2c0
> Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 0f 1f 40 d6 55 41 57 41 56 4=
1 55 41 54 53 b0 01 48 85 f6 0f 84 ae 01 00 00 4c 8d 04 37 <49> 39 f8 0f 82=
 36 02 00 00 49 b9 00 00 00 00 00 80 ff ff eb 0d cc
> RSP: 0018:ffffc90000a18a48 EFLAGS: 00000202
> RAX: 0000000000000001 RBX: ffff888115985810 RCX: ffffffff8beacbc2
> RDX: 0000000000000000 RSI: 0000000000000004 RDI: ffff888115985810
> RBP: ffffc90000a18b70 R08: ffff888115985814 R09: 1ffff11022b30b02
> R10: dffffc0000000000 R11: ffffed1022b30b03 R12: 1ffff92000143158
> R13: 0000000000000001 R14: ffffc90000a18ae0 R15: 1ffff11022b30b02
> FS:  0000000000000000(0000) GS:ffff8882a7cc3000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4106beb8c0 CR3: 00000001a7d98000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  native_queued_spin_lock_slowpath+0xc2/0x960
>  do_raw_spin_lock+0x26c/0x2f0
>  nfulnl_timer+0x20/0x110
>  call_timer_fn+0x18d/0x5f0
>  __run_timer_base+0x652/0x8b0
>  run_timer_softirq+0xb7/0x170
>  handle_softirqs+0x226/0x860
>  __irq_exit_rcu+0xcb/0x220
>  irq_exit_rcu+0x9/0x30
>  sysvec_apic_timer_interrupt+0xa6/0xc0
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> RIP: 0010:pv_native_safe_halt+0xf/0x20
> Code: ab 8b 02 c3 cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 9=
0 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d d3 85 21 00 fb f4 <e9> 8c 08 03 00=
 cc cc cc cc cc cc cc cc cc cc cc cc 90 90 90 90 90
> RSP: 0018:ffffc900001a7e40 EFLAGS: 00000206
> RAX: 00000000005c2139 RBX: ffffffff819bcc20 RCX: 8000000000000001
> RDX: 0000000000000001 RSI: ffffffff8e46796e RDI: ffffffff8c6dd780
> RBP: ffffc900001a7f10 R08: ffff88823c633a1b R09: 1ffff110478c6743
> R10: dffffc0000000000 R11: ffffed10478c6744 R12: 0000000000000000
> R13: 1ffff1102c09d000 R14: 1ffff92000034fd0 R15: dffffc0000000000
>  default_idle+0x9/0x20
>  default_idle_call+0x72/0xb0
>  do_idle+0x2e0/0x540
>  cpu_startup_entry+0x43/0x60
>  start_secondary+0x101/0x110
>  common_startup_64+0x13e/0x157
>  </TASK>
> CPU: 0 UID: 0 PID: 31900 Comm: syz.3.6377 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:get_file_rcu+0x5f/0x100
> Code: e2 ff 4c 8b 33 4d 85 f6 0f 84 98 00 00 00 49 8d be 58 01 00 00 be 0=
8 00 00 00 e8 0c 02 e3 ff 31 f6 f0 49 83 86 58 01 00 00 01 <40> 0f 99 c5 40=
 0f 98 c6 bf 02 00 00 00 e8 6f 31 72 ff 40 84 ed 74
> RSP: 0018:ffffc9000694eec8 EFLAGS: 00000286
> RAX: ffffffff8255c001 RBX: ffff8881aa509250 RCX: ffffffff8255c004
> RDX: 0000000000000001 RSI: 0000000000000000 RDI: ffff88811134b958
> RBP: ffffc9000694f100 R08: ffff88811134b95f R09: 1ffff1102226972b
> R10: dffffc0000000000 R11: ffffed102226972c R12: dffffc0000000000
> R13: 1ffff110354a124a R14: ffff88811134b800 R15: fffffffffffffff5
> FS:  000055556a26b500(0000) GS:ffff88818c4c3000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f41079d6ff8 CR3: 00000001a589a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  nfulnl_log_packet+0x1b02/0x2a50
>  nf_log_packet+0x49a/0x650
>  nft_log_eval+0x2c4/0x3b0
>  nft_do_chain+0x48d/0x1b10
>  nft_do_chain_ipv4+0x195/0x290
>  nf_hook_slow+0xc5/0x220
>  nf_hook+0x22a/0x3a0
>  __ip_local_out+0x558/0x6a0
>  ip_local_out+0x2a/0x190
>  __ip_queue_xmit+0x10df/0x1b10
>  __tcp_transmit_skb+0x2d18/0x47c0
>  tcp_send_active_reset+0x2a8/0x5a0
>  __tcp_close+0x43d/0xe70
>  tcp_close+0x28/0x110
>  inet_release+0x143/0x190
>  __sock_release+0xa0/0x1f0
>  sock_close+0x1c/0x30
>  __fput+0x418/0xa50
>  task_work_run+0x1d9/0x270
>  exit_to_user_mode_loop+0x204/0x770
>  do_syscall_64+0x328/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f584b99e1d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdb6062668 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 00007f584bc27da0 RCX: 00007f584b99e1d9
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 00007f584bc27da0 R08: 00007f584bc26218 R09: 0000000000000000
> R10: 000000000003fd20 R11: 0000000000000246 R12: 000000000013db89
> R13: 00007f584bc2636c R14: 000000000013d8a7 R15: 00007ffdb6062770
>  </TASK>
>
>
> ***
>
> INFO: rcu detected stall in inet_release
>
> tree:      nf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf.git
> base:      ab699d296e066eb64f51d2a8a1d42237a3b186c8
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/2622922d-df96-41f8-b0fb-efd53f4ef=
bef/config
> AI triage: https://ci.syzbot.org/findings/9d8b6960-1b28-4725-973e-e39b3e1=
c78f1/triage_trajectory
>
> rcu: INFO: rcu_preempt detected stalls on CPUs/tasks:
> rcu:    Tasks blocked on level-0 rcu_node (CPUs 0-1): P7332
> rcu:    (detected by 0, t=3D10502 jiffies, g=3D20017, q=3D4308 ncpus=3D2)
> task:syz.1.387       state:R  running task     stack:25040 pid:7332  tgid=
:7330  ppid:5598   task_flags:0x400140 flags:0x00080003
> Call Trace:
>  <IRQ>
>  sched_show_task+0x4aa/0x5f0
>  print_other_cpu_stall+0xfc1/0x1350
>  rcu_sched_clock_irq+0x9fe/0x10e0
>  update_process_times+0x23b/0x2f0
>  tick_nohz_handler+0x38f/0x6b0
>  __hrtimer_run_queues+0x371/0xa10
>  hrtimer_interrupt+0x4cd/0xaa0
>  __sysvec_apic_timer_interrupt+0x102/0x430
>  sysvec_apic_timer_interrupt+0xa1/0xc0
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20
> RIP: 0010:__sanitizer_cov_trace_const_cmp1+0x8/0xb0
> Code: 0a 10 48 89 74 0a 18 48 89 44 0a 20 c3 cc cc cc cc cc 90 90 90 90 9=
0 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 48 8b 04 24 <65> 48 8b 0d 68=
 de cd 12 65 48 8b 15 68 de cd 12 f7 c2 00 01 00 ff
> RSP: 0018:ffffc90007257228 EFLAGS: 00000286
> RAX: ffffffff8255c021 RBX: ffff888023d91850 RCX: ffffffff8255c004
> RDX: 0000000000000001 RSI: 0000000000000001 RDI: 0000000000000002
> RBP: 0000000000000000 R08: ffff888025fab95f R09: 1ffff11004bf572b
> R10: dffffc0000000000 R11: ffffed1004bf572c R12: dffffc0000000000
> R13: 1ffff110047b230a R14: ffff888025fab800 R15: fffffffffffffff5
>  get_file_rcu+0x71/0x100
>  owner_mt+0x28a/0x970
>  nft_match_eval+0x1ad/0x2b0
>  nft_do_chain+0x48d/0x1b10
>  nft_do_chain_ipv4+0x195/0x290
>  nf_hook_slow+0xc5/0x220
>  nf_hook+0x22a/0x3a0
>  __ip_local_out+0x558/0x6a0
>  ip_local_out+0x2a/0x190
>  __ip_queue_xmit+0x10df/0x1b10
>  __tcp_transmit_skb+0x2d18/0x47c0
>  tcp_send_active_reset+0x2a8/0x5a0
>  mptcp_do_fastclose+0x2d8/0x4a0
>  __mptcp_close+0x21c/0xd10
>  mptcp_close+0x28/0x1a0
>  inet_release+0x143/0x190
>  __sock_release+0xa0/0x1f0
>  sock_close+0x1c/0x30
>  __fput+0x418/0xa50
>  fput_close_sync+0x11f/0x240
>  __x64_sys_close+0x7e/0x110
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2ae4d9e1d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f2ae5c36028 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: ffffffffffffffda RBX: 00007f2ae5026090 RCX: 00007f2ae4d9e1d9
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000006
> RBP: 00007f2ae4e35888 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f2ae5026128 R14: 00007f2ae5026090 R15: 00007ffd59d7a8d8
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
> [brauner@kernel.org coreteam@netfilter.org davem@davemloft.net edumazet@k=
ernel.org fw@strlen.de horms@kernel.org kuba@kernel.org netdev@vger.kernel.=
org netfilter-devel@vger.kernel.org pabeni@redhat.com pablo@netfilter.org p=
hil@nwl.cc stable@vger.kernel.org tristan@talencesecurity.com tristmd@gmail=
.com]
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
-upstream-moderation/6acf4495.38256f13.2006af.00f2.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
