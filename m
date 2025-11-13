Received: from mail-oo1-f45.google.com (mail-oo1-f45.google.com [209.85.161.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1ABCB22A4D8
	for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 13:48:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763041712; cv=none; b=mczhHYDj0p68FiPkchwLuAd5mkfRLFPsvZ8qfCf7a4R9vo77SrNvzSIuMvmwQrDq87Z1aKrHyeGAXoCyCTr5R2fDpi3n1p8Vj7/TswKvV8AH2KRaJUfawJ1uSj16ADK4nGqDO2bo8PbVE9RzX4LLSPUsa0J+U+5TV878cJnZWzo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763041712; c=relaxed/simple;
	bh=9ACKR+ptqCgGLCHYND9vwlpqREP+D76MU/M39hHqaww=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OBpDcWW+rrtp8b5S2GjpQCIZb9Y99AY6EvPXjwxW4A5VhHw86QLoEpv5OipZM/ADPb7vfZmzkg2jH3AVALS3IxjdOI9zJXSpW+aJ3m88AncTCuvErnqyTXgDOt5uPrHodyDt44+ga1eFlWbzrGD73FY6/tSgf/uI+s7x3PKHVH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=asrvpD5U; arc=none smtp.client-ip=209.85.161.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="asrvpD5U"
Received: by mail-oo1-f45.google.com with SMTP id 006d021491bc7-656cb7b20ccso349330eaf.1
        for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 05:48:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763041707; x=1763646507; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QlVdirkNwzfqeAcEsk4QEeYyK5gs9+kcLZhUMaeJGAk=;
        b=asrvpD5Ujay+oJ2icf4D/KLg/ZuSyqtTXTB+jyrcldlBqzc/LWGhuAKlNe4TEEmZ0V
         O+7RJbGMIc+QwE3PhTqer/JyfxSG3bHbOGnxJZHlfp00n6PTzCh1yCEHYy5stBVzpVpQ
         gsvFAULJ+4iqzTL7JgZl92AVny8rHokia6/E3ujpWYlc10qliNwbbA+jdAbZ+zk5hxk1
         j+nnvIOF6+YdYFeseGi8vR7s1n7qCVQVDpTzedB3awfDA9p3wbnegc8SseBJHiGISDIw
         GEcWHyCTQUETE7DPp5dgIQT+MZQk+ZeBzsV/jwSScoHQdR/aSk3fwRS3+r45xcux4+X+
         1BUg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763041707; x=1763646507;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QlVdirkNwzfqeAcEsk4QEeYyK5gs9+kcLZhUMaeJGAk=;
        b=jL6ZqRCX6s3SB0zlkUYWVe/mxCOOWn2FxkxCEtNTW8mclWb45i/VDzvCsnBwrDGTEV
         iXC1ySoyDuHW1C1QBGOFpzy5NcMa0h67P1HqQJLZtK5UDQ+Jpou18s4hvf+H7ZME3HNQ
         X/V+v4CJvf+ztXtzlCHDbhhUkx873mLZ5xd6hoKe0TeAxf6GqoeqIXyB/2Hg2KMPjrlu
         OeUo13o/NLWFMyMOZiC6PwvtA4WXKXH99GAmupJ9/1LonLEZLJsR/zF2cDpO+QLAyrCj
         ayleOVES/kXoh+iUsPAZFa81dlHeAFlNi7t1JIH+i3j0yQJ77ldEN3h7O4E7ZsOaD9hb
         ppMg==
X-Forwarded-Encrypted: i=1; AJvYcCV2TrHWrtieZo9rd5tCKuG6gNZFRFs3DANHicSXiapbl+AEEcJkQ8zpy2rxNZWgxuKypcm4EjU=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw0toJXyYoBc8K4se5TZERsVktWPD8utFpNchLrBgDWmIigNXH/
	419OA4YL025quLdlpUP76vNVZR+IX8+6En47XPP6/gxDaCxg6hnItF7DkH6w8eVYHb9tT8amyLi
	f8gFCytxmemxsvJCRpc0jebFbDfgByi5V2llvV9ow
X-Gm-Gg: ASbGncsmCrrMseaUIkjhmHDlq1kQjpR9BXfEwYjYkK2VdY8G9B9ap37qeFgmTnAmcHd
	aOqOdRQ+/OqDHMzBSTAKUNp5cGvBugkA2ECit2GmNdeL4Oap9WN3Oy4LLRNDJSbSJx032M9u5G3
	qb4UZ2nRKsb8IXH82HW6tVj8CFQ7Lf6r4iqeiw9ldnqmP7wW/38ICY3ECktg66OPa5Nr8x/o/3r
	MTOdH6arPki93eg+wqdjfSXgDBeB6WyIMBQDLRCgclHu8NNnQWymuqi1qpU7Lr1hyGZPBb+PjMW
	n0lsc/KGJE2Y9Nm3hvWzYBfxFK3V7iT+tHdSJNdrUegQjFm2y3AK6c9V
X-Google-Smtp-Source: AGHT+IERQsEU72+IhhH3tkcdtuf1SdkBzNI0BEr5REB4EsAyagB7D6KCsyiWNjDD/L5pLkAdWCY+nSNpoy82CMkrV4c=
X-Received: by 2002:a05:6820:4d5c:20b0:656:c942:93b2 with SMTP id
 006d021491bc7-657233a5201mr1231314eaf.4.1763041706962; Thu, 13 Nov 2025
 05:48:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6915def0.a70a0220.3124cb.0027.GAE@google.com>
In-Reply-To: <6915def0.a70a0220.3124cb.0027.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 13 Nov 2025 14:48:15 +0100
X-Gm-Features: AWmQ_bnpnuxgSwNR5Zm-NkWJ7O4bUadvbnNrmr6bOaONa6zdR_m7NOjJe7ISlPU
Message-ID: <CANp29Y77JpC9sgtvAOrQHA-GhNSBW+C+nm6wu5sUGgiwT_Kx-A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: nfnetlink_queue: optimize verdict
 lookup with hash table
To: syzbot ci <syzbot+cia78fa5f55802723c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Nov 13, 2025 at 2:36=E2=80=AFPM syzbot ci
<syzbot+cia78fa5f55802723c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] netfilter: nfnetlink_queue: optimize verdict lookup with hash table
> https://lore.kernel.org/all/20251113092606.91406-1-scott_mitchell@apple.c=
om
> * [PATCH v2] netfilter: nfnetlink_queue: optimize verdict lookup with has=
h table
>
> and found the following issue:
> BUG: sleeping function called from invalid context in instance_create
>
> Full report is available here:
> https://ci.syzbot.org/series/001a6a6c-7e1b-46e8-995d-5b6d650af320
>
> ***
>
> BUG: sleeping function called from invalid context in instance_create
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      0d0eb186421d0886ac466008235f6d9eedaf918e
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/69a4254b-f4aa-45a7-a4bd-2d2394088=
7f3/config
> C repro:   https://ci.syzbot.org/findings/8074062c-0aee-4734-a3d1-587b806=
76bf1/c_repro
> syz repro: https://ci.syzbot.org/findings/8074062c-0aee-4734-a3d1-587b806=
76bf1/syz_repro
>
> netlink: 'syz.0.17': attribute type 6 has an invalid length.
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:321
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5968, name: syz.0.=
17
> preempt_count: 1, expected: 0
> RCU nest depth: 1, expected: 0
> 3 locks held by syz.0.17/5968:
>  #0: ffffffff99cc1c30 (nfnl_subsys_queue){+.+.}-{4:4}, at: nfnl_lock net/=
netfilter/nfnetlink.c:98 [inline]
>  #0: ffffffff99cc1c30 (nfnl_subsys_queue){+.+.}-{4:4}, at: nfnetlink_rcv_=
msg+0x9dc/0x1130 net/netfilter/nfnetlink.c:295
>  #1: ffffffff8df3d2e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #1: ffffffff8df3d2e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:867 [inline]
>  #1: ffffffff8df3d2e0 (rcu_read_lock){....}-{1:3}, at: nfqnl_recv_config+=
0x222/0xf90 net/netfilter/nfnetlink_queue.c:1653
>  #2: ffff888112297d18 (&q->instances_lock){+.+.}-{3:3}, at: spin_lock inc=
lude/linux/spinlock.h:351 [inline]
>  #2: ffff888112297d18 (&q->instances_lock){+.+.}-{3:3}, at: instance_crea=
te+0x121/0x740 net/netfilter/nfnetlink_queue.c:206
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 UID: 0 PID: 5968 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  __might_resched+0x495/0x610 kernel/sched/core.c:8927
>  might_alloc include/linux/sched/mm.h:321 [inline]
>  slab_pre_alloc_hook mm/slub.c:4913 [inline]
>  slab_alloc_node mm/slub.c:5248 [inline]
>  __do_kmalloc_node mm/slub.c:5633 [inline]
>  __kvmalloc_node_noprof+0x149/0x910 mm/slub.c:7089
>  kvmalloc_array_node_noprof include/linux/slab.h:1122 [inline]
>  instance_create+0x203/0x740 net/netfilter/nfnetlink_queue.c:218
>  nfqnl_recv_config+0x660/0xf90 net/netfilter/nfnetlink_queue.c:1667
>  nfnetlink_rcv_msg+0xb4d/0x1130 net/netfilter/nfnetlink.c:302
>  netlink_rcv_skb+0x208/0x470 net/netlink/af_netlink.c:2550
>  nfnetlink_rcv+0x282/0x2590 net/netfilter/nfnetlink.c:669
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x82f/0x9e0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x805/0xb30 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:742
>  ____sys_sendmsg+0x505/0x830 net/socket.c:2630
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
>  __sys_sendmsg net/socket.c:2716 [inline]
>  __do_sys_sendmsg net/socket.c:2721 [inline]
>  __se_sys_sendmsg net/socket.c:2719 [inline]
>  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7a65f8f6c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffde4361588 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f7a661e5fa0 RCX: 00007f7a65f8f6c9
> RDX: 0000000000008010 RSI: 00002000000000c0 RDI: 0000000000000003
> RBP: 00007f7a66011f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f7a661e5fa0 R14: 00007f7a661e5fa0 R15: 0000000000000003
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
> The email will later be sent to:
> [coreteam@netfilter.org davem@davemloft.net edumazet@google.com fw@strlen=
.de horms@kernel.org kadlec@netfilter.org kuba@kernel.org linux-kernel@vger=
.kernel.org netdev@vger.kernel.org netfilter-devel@vger.kernel.org pabeni@r=
edhat.com pablo@netfilter.org phil@nwl.cc scott.k.mitch1@gmail.com scott_mi=
tchell@apple.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6915def0.a70a0220.3124cb.0027.GAE%40google.com.
