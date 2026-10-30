Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.51
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793381523;
	b=s6o69HqcWiKTAtIvyd0EUj+BgV1dPcg1W78T937ykA8eOgqrr9yE98+KxireCRYz2NKv
	 KFDQC47Y2Adw2JYB3Ba21ZlxvmMkRWO0tmbdmfXDMkcM1QwuSg2JyQ2sXA6pdS3FpNZeQ
	 ItGOWDdy7Q2Nmd/uHQboCsWooxUG6R92W1mAAI5E8RPC7WfjfCqJPQfMcmf5MIXUzNKN9
	 QCIdj3CkyeNxnrF8nTCpmB1px1btxaUf0ovvRmu7aMRTEzUczuDEo9NIws7iBWeGyw/ZR
	 M/pP7bvSkPdpaV/j9sPeHS6NF5wVOs6q2DYXQLnm2sZwmH3x8LU6NIlh6mWzHpA620w==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793381523;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=n6x9GhQBnFy4l6FY0+LJjKiBM/SMrziPHgtVXVf9dLM=;
	b=rMvZkBs3KT57PdWoPmD7HCRVxAguqIxFo2xrmDzyT2BfD9emOHFiZJLr/rh39aZoTb5U
	 TWKuIeEi40o9lSStZiqEt+kgxmmGd1qxDmBUPpJKWa0Jukx+m7z0cwvMKgE0Fcza1/wuS
	 c2otW9Y9fAsAVST6wYmLcsLZruRHAjJ0THk7hDLk18UBhji3hTLB31RNIXR2i3ybMCvf1
	 AqGHzsopkFeaou3d/jmRE9zLw4ejG3qJ0GeTYilSr2coCHzGRd3MtTOVgkEYgHcZT7/9L
	 +3SHscaoHC7FnTZN/2zur1UVhzCIA8Yr6vJEoj28e3c1sy9IVtSsHIEPjT1xXzJkTkw==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZWTMT5SE;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.51
Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 98FB4606A31A
	for <syzbot@lists.linux.dev>; Fri, 30 Oct 2026 17:32:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 98FB4606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=ZWTMT5SE
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-6d68de53053so474884eaf.0
        for <syzbot@lists.linux.dev>; Fri, 30 Oct 2026 10:32:02 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793381521; cv=none;
        d=google.com; s=arc-20260327;
        b=MNYXQPRMjWpx8tSL8ztwaG23lbPFGPnVxZ3bFAjUn6uhat4nFVZBznKH+mR6/x1Ooz
         F9W09KBvQ+WBu26wOwMwnyQsjEw6nTlert50n5U4KGzSsxlivc49fhYe7D/raWLmVvUm
         zC1kGUSKeEyDL4V3LiRUiQY52hoKH3R7+ofhoC0ZvGV6qSxMhMyUVTA/PTUYZ3VwLBlW
         JVXz09xLnLhqUiKXPmG6JJ5uxdpDslZwCQXfN+yAgRt6Q1pHFUkNYpc10BrlLa9ua4gp
         FtZiK7Q2+yhUZ0tIUtxFuo5O73vM0aNQxsidm7He1aaqSTbMQyukvX7Kxcc9SJXXMIKf
         5Q/A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n6x9GhQBnFy4l6FY0+LJjKiBM/SMrziPHgtVXVf9dLM=;
        fh=iEhZfzF1YALzeyBOkafz8ohmiXzS/7rVfE7Q2GjWiew=;
        b=r9/IRD6+uMuCzaVdH6QhMBb5rxXqkaTp70jBL0056TGnDT8FrslIS0pcdk28VOsnqW
         5CZ4nkAmwVCFWQpCKMvBp0suZXM/zIqSODT3+X7LASPICt9aXsIm7LVpUYzYFkkOO87h
         BHV7msAanl0vsUL9XbJJcEqJJ/cyiob68PXvdRbgFFa8DvnRIYFb8jVjtKAhBK5vvuae
         GxlW8lr3/+PqAqWSEzo3Pk56jL/tcxS6lJUPuUEC6nXGM81NJ8FCm+O2NuS47He/zgWx
         41NetUDKO3cnl/Ddawi8NWhRQOmR3Qao6qsajsPbUrQi8RzkqY1vSQwQ16ZuQ9+Lgz/G
         B9EA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793381521; x=1793986321; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n6x9GhQBnFy4l6FY0+LJjKiBM/SMrziPHgtVXVf9dLM=;
        b=ZWTMT5SEHhmJtQ2BR0I8STq+jBBJiVIENBAvRlKc6ij5+PfpvXXyBKEpKzCfp3v12H
         eMP34cgjNOTd7s+zLqTOo7SLCWae7vRo1Edxvx1EoBW79nWBZRAjUX5JXYEny9fkxLBS
         kz/FN20GWu3mzLji1xDfjo7qlBtZelznU69PhYjNyR/8SprK14u7Fuz/1GddKhYaX7Hh
         h9c/KIM+zjLeSRHxRoIR9cXTQU7yVk15sxDmS7nwEP3iVobFQqVX/im9X+H3ZvqPGpRR
         xEE9dOgi1ZA5hGhWb/tymQ/9pPMxEkjLmfXyQih3F0jg4ZAPvrKoRvtYi5l9o6jkEwRR
         fnXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793381521; x=1793986321;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n6x9GhQBnFy4l6FY0+LJjKiBM/SMrziPHgtVXVf9dLM=;
        b=g53HcqFYoY+2z0/AOksn9UdA0XAQjXODhJcuGTvvQ027/5oNhRyVihB42nGnEIPyH5
         j4WR7N+ynanVKAERMqh9CDtWsXK3rh6+g5S9tCcvP2mp/nYA11Syr9IaB83nyPEmVPa7
         2ZOOonUodDrSPr+TtfZEYqlm6SX0ExUuAxHMpZAylib8bXTZFhmAM//n73Bftqahi4rG
         eeLLj9meXUEb2AvWlWrMlxD18vs4lw1s7RvhPX7Wlqh0ilcACoWSe0RRN5DkqufTnrR7
         +UOyrRVVolzWQVJQW6rfXLCIxjHW0Dpj/09CCekU3ykGnDHWtltnPi0O+hHuvSqxNRNu
         v6dA==
X-Forwarded-Encrypted: i=1; AKwUvBwul84vg1P9LfordKhNiioy8WEBNvZl/8Kz0FK4DnNb2Unk0ZYWC6c5Fde5jP8iT5mDMOCWoxk=@lists.linux.dev
X-Gm-Message-State: AFq9FYLM/jITb1BKgRic7PlvXHSCv9Xg5XcQXknnfoeZFAB7HR4fjt/5
	/M5yzbpTrAV368YhL5aCZ+jRNbYaFEBPcCCfHepT9UsK3Z3fsypN3ZeX6MXq60YWoyJ0Zrosxwk
	wezt64699igt8OjNdqxp148f3LEzPmXuHJUu/TFJh
X-Gm-Gg: AYBFou1n0OxnmWvZkcDPcWKNPwJq3Kq2RbfTCyRxgWAmWALJVqAiCyFu3SqI45ruAS/
	XoAbHO6PKk7jsb4A8mTVXyA9rKGyC/DrmDgK7XxP2jiIJleCCjECFumYgGA/fw0eTsgYAQ3DwlY
	Xor9+Jv+y2UBxIW9InmzRxhS2N5KC2W0he/ADWi1cA4ejSuPx7j5qNzqQdZVAF3f8e3WcMd7Rk0
	/40OYvrJ6mWO+6TKLet5EIElPYTZPbeoyfyvYvntmzXrDI4DTSXbc+iS6NUurlPcBMG7W7UbIVm
	6rTbX270Xjf22GoPX5LI6RND0ABi+tOyCFnPp2YDeKs+dx6td5TTlhVgeNt4OyZjRXL+jF2iGFr
	Wxhg2ako37CGUtPV3KWmDnrBOa/mgIa7g4cJ3p+p3jBo99Lv6/8m8SCf8loYcnL72hisIK+7avN
	Vf4nmoVAZuTlrEV8k2I9PKYDh0dPalubiwjoge8PBHJMRJvO0ZPv4=
X-Received: by 2002:a05:6820:8906:10b0:713:da3b:9052 with SMTP id
 006d021491bc7-714f28da31bmr1291424eaf.31.1793381520866; Fri, 30 Oct 2026
 10:32:00 -0700 (PDT)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6ae4b6f4.f57e0135.1770dd.007a.GAE@google.com>
In-Reply-To: <6ae4b6f4.f57e0135.1770dd.007a.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 30 Oct 2026 18:31:49 +0100
X-Gm-Features: AclHuK8nFhty72WtSP3DG3bV3AgsDJjN-OA8kHV0sNwQXvt_nt3AMLlowTzO8Ws
Message-ID: <CANp29Y5DjrY4ZRPfy_+=y0rUjLeGLLV0JDE=tOZ+HxuD4uQGMA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: flowtable: purge entries
 immediately when destroying the flowtable
To: syzbot ci <syzbot+ci30e56c2ea4509e19@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Oct 30, 2026 at 4:25=E2=80=AFPM syzbot ci
<syzbot+ci30e56c2ea4509e19@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] netfilter: flowtable: purge entries immediately when destroying the =
flowtable
> https://lore.kernel.org/all/20261029171950.222776-1-pablo@netfilter.org
> * [PATCH nf] netfilter: flowtable: purge entries immediately when destroy=
ing the flowtable
>
> and found the following issues:
> * BUG: sleeping function called from invalid context in flow_offload_work=
_del
> * WARNING: locking bug in flow_offload_work_del
>
> Full report is available here:
> https://ci.syzbot.org/series/5482d6d8-0683-4f36-bb55-ffcf94a9edcc
>
> ***
>
> BUG: sleeping function called from invalid context in flow_offload_work_d=
el
>
> tree:      nf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf.git
> base:      734bef548a96e8774d6eef5dfa2026c6edc4e80b
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/94e4012e-ffd8-430a-9ba4-d5a167bf8=
988/config
> syz repro: https://ci.syzbot.org/findings/6c0e698b-3bb6-4d1f-94cb-9ebf1c0=
a71db/syz_repro
>
> BUG: sleeping function called from invalid context at kernel/locking/rwse=
m.c:1573
> in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5686, name: kworke=
r/u8:3
> preempt_count: 0, expected: 0
> RCU nest depth: 1, expected: 0
> locks held by kworker/u8:3/5686: 3, last CPU#0:
>  #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: =
rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
>  #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: =
rcu_read_lock include/linux/rcupdate.h:849 [inline]
>  #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: =
process_one_work kernel/workqueue.c:3460 [inline]
>  #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: =
process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
>  #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{=
0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
>  #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{=
0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
>  #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{=
0:0}, at: process_one_work kernel/workqueue.c:3460 [inline]
>  #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{=
0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
>  #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:309 [inline]
>  #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:849 [inline]
>  #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rhashtable_walk_st=
art_check+0x64/0xcf0 lib/rhashtable.c:872
> CPU: 0 UID: 0 PID: 5686 Comm: kworker/u8:3 Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x36a/0x4c0 kernel/sched/core.c:9195
>  down_read+0x26/0x320 kernel/locking/rwsem.c:1573
>  nf_flow_offload_tuple net/netfilter/nf_flow_table_offload.c:920 [inline]
>  flow_offload_tuple_del net/netfilter/nf_flow_table_offload.c:951 [inline=
]
>  flow_offload_work_del+0x240/0x5e0 net/netfilter/nf_flow_table_offload.c:=
995
>  nf_flow_table_offload_purge+0x51/0x80 net/netfilter/nf_flow_table_offloa=
d.c:1184
>  nf_flow_table_do_purge net/netfilter/nf_flow_table_core.c:776 [inline]
>  nf_flow_table_iterate net/netfilter/nf_flow_table_core.c:459 [inline]
>  nf_flow_table_free+0x29b/0x3b0 net/netfilter/nf_flow_table_core.c:789
>  tcf_ct_flow_table_cleanup_work+0x1a/0x90 net/sched/act_ct.c:386
>  process_one_work kernel/workqueue.c:3495 [inline]
>  process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> [ BUG: Invalid wait context ]
> syzkaller #0 Tainted: G        W
> -----------------------------
> kworker/u8:3/5686 is trying to lock:
> ffff88817589eb28 (&flowtable->flow_block_lock){.+.+}-{4:4}, at: nf_flow_o=
ffload_tuple net/netfilter/nf_flow_table_offload.c:920 [inline]
> ffff88817589eb28 (&flowtable->flow_block_lock){.+.+}-{4:4}, at: flow_offl=
oad_tuple_del net/netfilter/nf_flow_table_offload.c:951 [inline]
> ffff88817589eb28 (&flowtable->flow_block_lock){.+.+}-{4:4}, at: flow_offl=
oad_work_del+0x240/0x5e0 net/netfilter/nf_flow_table_offload.c:995
> other info that might help us debug this:
> context-{5:5}
> locks held by kworker/u8:3/5686: 3, last CPU#0:
>  #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: =
rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
>  #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: =
rcu_read_lock include/linux/rcupdate.h:849 [inline]
>  #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: =
process_one_work kernel/workqueue.c:3460 [inline]
>  #0: ffff8881108f3948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: =
process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
>  #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{=
0:0}, at: rcu_lock_acquire include/linux/rcupdate.h:309 [inline]
>  #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{=
0:0}, at: rcu_read_lock include/linux/rcupdate.h:849 [inline]
>  #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{=
0:0}, at: process_one_work kernel/workqueue.c:3460 [inline]
>  #1: ffffc90004e67c40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{=
0:0}, at: process_scheduled_works+0x97a/0x1630 kernel/workqueue.c:3578
>  #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:309 [inline]
>  #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:849 [inline]
>  #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rhashtable_walk_st=
art_check+0x64/0xcf0 lib/rhashtable.c:872
> stack backtrace:
> CPU: 0 UID: 0 PID: 5686 Comm: kworker/u8:3 Tainted: G        W           =
 syzkaller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_lock_invalid_wait_context kernel/locking/lockdep.c:4874 [inline]
>  check_wait_context kernel/locking/lockdep.c:4946 [inline]
>  __lock_acquire+0xf5b/0x2de0 kernel/locking/lockdep.c:5238
>  lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
>  down_read+0x45/0x320 kernel/locking/rwsem.c:1574
>  nf_flow_offload_tuple net/netfilter/nf_flow_table_offload.c:920 [inline]
>  flow_offload_tuple_del net/netfilter/nf_flow_table_offload.c:951 [inline=
]
>  flow_offload_work_del+0x240/0x5e0 net/netfilter/nf_flow_table_offload.c:=
995
>  nf_flow_table_offload_purge+0x51/0x80 net/netfilter/nf_flow_table_offloa=
d.c:1184
>  nf_flow_table_do_purge net/netfilter/nf_flow_table_core.c:776 [inline]
>  nf_flow_table_iterate net/netfilter/nf_flow_table_core.c:459 [inline]
>  nf_flow_table_free+0x29b/0x3b0 net/netfilter/nf_flow_table_core.c:789
>  tcf_ct_flow_table_cleanup_work+0x1a/0x90 net/sched/act_ct.c:386
>  process_one_work kernel/workqueue.c:3495 [inline]
>  process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3578
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3659
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
>
>
> ***
>
> WARNING: locking bug in flow_offload_work_del
>
> tree:      nf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf.git
> base:      734bef548a96e8774d6eef5dfa2026c6edc4e80b
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/94e4012e-ffd8-430a-9ba4-d5a167bf8=
988/config
> AI triage: https://ci.syzbot.org/findings/8d3389f2-6e3f-4f98-bc3b-bba3404=
1a26f/triage_trajectory
>
> BUG: sleeping function called from invalid context at kernel/locking/rwse=
m.c:1573
> in_atomic(): 0, irqs_disabled(): 0, non_block: 0, pid: 5634, name: kworke=
r/u8:2
> preempt_count: 0, expected: 0
> RCU nest depth: 1, expected: 0
> locks held by kworker/u8:2/5634: 3, last CPU#1:
>  #0: ffff888115805948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: =
process_scheduled_works+0x97a/0x1630
>  #1: ffffc9000473fc40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{=
0:0}, at: process_scheduled_works+0x97a/0x1630
>  #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rhashtable_walk_st=
art_check+0x64/0xcf0
> CPU: 1 UID: 0 PID: 5634 Comm: kworker/u8:2 Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  __might_resched+0x36a/0x4c0
>  down_read+0x26/0x320
>  flow_offload_work_del+0x240/0x5e0
>  nf_flow_table_offload_purge+0x51/0x80
>  nf_flow_table_free+0x29b/0x3b0
>  tcf_ct_flow_table_cleanup_work+0x1a/0x90
>  process_scheduled_works+0xc3d/0x1630
>  worker_thread+0xa47/0xfb0
>  kthread+0x38b/0x480
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> [ BUG: Invalid wait context ]
> syzkaller #0 Tainted: G        W
> -----------------------------
> kworker/u8:2/5634 is trying to lock:
> ffff8881b9d94b28 (&flowtable->flow_block_lock){++++}-{4:4}, at: flow_offl=
oad_work_del+0x240/0x5e0
> other info that might help us debug this:
> context-{5:5}
> locks held by kworker/u8:2/5634: 3, last CPU#0:
>  #0: ffff888115805948 ((wq_completion)act_ct_workqueue){+.+.}-{0:0}, at: =
process_scheduled_works+0x97a/0x1630
>  #1: ffffc9000473fc40 ((work_completion)(&(&ct_ft->rwork)->work)){+.+.}-{=
0:0}, at: process_scheduled_works+0x97a/0x1630
>  #2: ffffffff8fd59ca0 (rcu_read_lock){....}-{1:3}, at: rhashtable_walk_st=
art_check+0x64/0xcf0
> stack backtrace:
> CPU: 0 UID: 0 PID: 5634 Comm: kworker/u8:2 Tainted: G        W           =
 syzkaller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: act_ct_workqueue tcf_ct_flow_table_cleanup_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  __lock_acquire+0xf5b/0x2de0
>  lock_acquire+0x115/0x350
>  down_read+0x45/0x320
>  flow_offload_work_del+0x240/0x5e0
>  nf_flow_table_offload_purge+0x51/0x80
>  nf_flow_table_free+0x29b/0x3b0
>  tcf_ct_flow_table_cleanup_work+0x1a/0x90
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
> [netfilter-devel@vger.kernel.org pablo@netfilter.org]
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
-upstream-moderation/6ae4b6f4.f57e0135.1770dd.007a.GAE%40google.com.
