Received: from mail-oo1-f49.google.com (mail-oo1-f49.google.com [209.85.161.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C6FD364E88
	for <syzbot@lists.linux.dev>; Wed,  8 Apr 2026 06:43:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775630623; cv=pass; b=PtPa8WY8cMw74l0XpYOqTKmpTiW4dFn2WNh+yQzY8QtUsxK6TlS0yVrWOK9kzZglo0F21E7uqpx9YvpJcvOCjrQMV4lSq59Rks51us8YbYjMEjYB167kzw78g/6GRPmO4X2ISCz4dw8XEoSJwmu7IuJP+HowInitqtnn9/tOojg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775630623; c=relaxed/simple;
	bh=aQ7EvNXE8+U0ctPtsLfv35HtYDL29IMaMMSeFOVVK7w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=nVn0XvhIuhY3n73NQEkxEzsnHbAfHMaBbcIz2/oUFV8Xru5BdxJRZ65CWxRR3YdNNjFBIsRM1HT10OVPeLZD/+sL3sV+ylLYQxXjZyz1sQ0NQDgF4kBlFZDm3FERuuBorfb4MGbD3Jp7kq6Pd9khdeJmPNPqzGUmZSnkbcB0zXk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EppRIkl1; arc=pass smtp.client-ip=209.85.161.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EppRIkl1"
Received: by mail-oo1-f49.google.com with SMTP id 006d021491bc7-67c22b05346so3278346eaf.2
        for <syzbot@lists.linux.dev>; Tue, 07 Apr 2026 23:43:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775630620; cv=none;
        d=google.com; s=arc-20240605;
        b=bgNWC2RWy3aFz6ZQ2mo3Mj/R1uEawRE2iLbhGsCUnFxATOnjBxo4iHeXZsS845zx7G
         SxzHR/NuA8Qhp+ggLoWT++9WnN0miIw0GYHiAhqlgurdYKO2cLF2reexxJD8Nja0Hlke
         N15IGHg3+enOEOSniqyRK72aVo0bd9ASi7wT23kLOld+pJItsqCN1ZVDbH0xbClA56ri
         Q1Zb5ljQsKhRtMi0k3PwAEQT24vQi/hV/NL5akUkNb/9XZmQpjpVS+ElKGVWOaIIWJiD
         gUMq+7N6zQHNNuaUsrqUXPhz0KmC/b4bUImINcHDX9RUHiGk8AxCjiSIqhKP9f8o7CSP
         5gSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wKtRXTDHjRc7G9wj1KmyTLAAFPsf4AoNdFu9MUJt2zo=;
        fh=pQa532odCwv4CFohLKbkXubyQSZPkd4w27xHyO/tVF8=;
        b=ZzutZAe9OmqKj54UPfhs1fCJO2ZsvAcAbcrmV4tPTeX1/WxxCPtktleRti4Zh5+1bN
         czBXK+XWJ9iUDi+wPQqbKblE6BKLpAgnzNBimBs/WAtEcjOTMxOEQg896CYXIuwTNsbe
         hrnM5ed5BVWRckiOf2whlZhM31FShi7w2y6xEKsN0Rbhr6T7X6rmFs8Zw4zh9GJYAk1E
         hTOMXmxKQ26apH2kVdqeDDBix/7svy6k41YX/c68b/3YeubH2LpmAEpaXeUre5lnFYi+
         aeEXpoiyJ6B8uMAK+/UDFsryZ5vXbAiqhB4IaEuWn03gSt0Omm2+uGGZV6sYiz2SBiiG
         Ri6g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775630620; x=1776235420; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wKtRXTDHjRc7G9wj1KmyTLAAFPsf4AoNdFu9MUJt2zo=;
        b=EppRIkl1jCniB1f5NVvOwyJcFKMwS+UielSGSPiGWNgl34Gr/qJnoe6lAYgI44Y5ed
         eqCeMFbrqKDuvuhEf2hy1ST4aifLxOEJDzTNYdaUIkFBJKaG0ZrPh7YTFfwFqjvyjCY3
         +ZMFTNySbCmJZa2fhNM9Maw2SAGocQPhkXDwoMHgq0VDMrU1vfKMRT1tGod2s3PIiYlZ
         2UsgvY3poQmsfSr6pnp/J9xgjn8keeIAancyyfQKMG7g2Gc40VFcuGq+0cz5ZHE1yfk0
         702r7egokYBqXfaJGXFOUDZIKN9xWQVHeRBDcnxrjvwnFqKRJFoS/QoWInvM0TCA5ij7
         w4pA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775630620; x=1776235420;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wKtRXTDHjRc7G9wj1KmyTLAAFPsf4AoNdFu9MUJt2zo=;
        b=AapQ+BRe4JhEHt0tm8npfapMRrh41G/box5YPj3/WmjJq8ZelqC2BGpG5puFClzUxb
         9SCJLP1Fg6Q68VYoY2VSzpIL9LcqttflUkVHw+DVKgItaxMu2+L7WHkMqwff7ZVwXnRj
         LUgDwL58eojOnxHeu4WQJhFKObZqFgC4i3zSWaeKeDSJMgFZHk4OhPNllfNR+FBzN90e
         4hCOsUIdweqabtg8x7C9iEHBCfqMXGhjN6WmKQA1uKSJsQn0uqMzkXPEy7G74NdZIBBj
         lzKzupNmxQXBryPqtDBb6QvwAkxK3GSy1tAPxlJZ51tkAIy0RQIEm9mLe8G7L3Hq41DS
         P6Ag==
X-Forwarded-Encrypted: i=1; AJvYcCUjj/ZGMEDVOC08ZcpqTRIUGS7fMsl9Fkvrxrrd8fDdMcXUdVIPvfdK7hU4FG7WLIHaw+FGpOA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz7lcq8F5PLcGyCzzLrfhjDGKPuutR2kwEclxobftT9tm60rO80
	RU8HyKUEHPlHqOIX8RHhBMcbcTLBRi2cRH2XGEe73Z8wiew/+C4/ylvJHok918sy4kD4JFupdo4
	k+JM97n9Lt0oo7nYnIeROMh4j5dmouwnzO4+CqYba
X-Gm-Gg: AeBDieux2PKZvIYpjbk2pJE6TYvkYRZ6gy4lQR+vBn9z3g8DUbp8tXPH923EAXh2+jI
	/7fd+fqGKo4e5RaI4I2zwpOtKWsDEJaLMUegR2z/lcl1QJYmfaowKVZ74fPv620CJ4hwqq0Y1Cx
	5jeHzWr+S6DkNz+BwdODnVrQ39sqvFzjGl42xLRN8MV3x/ywQwVIPF2zh1AzMGhalgmxIvtzDuD
	4ussYkxxVSLvwS/fspSqip+M7A4Dv9wOfBoB3wc+mUYdpInVd6KxrSsvnk6K4ROFTx98dmf3jpA
	piol+LYg51aTfssYxHoro7gJ6wFZo+R2GMfPcTrDdibVYwALICc4GX51xnta7RwiRZ1QWrgf
X-Received: by 2002:a05:6820:818d:b0:67b:cc71:c4fc with SMTP id
 006d021491bc7-6821db6ae82mr9914231eaf.23.1775630619964; Tue, 07 Apr 2026
 23:43:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69d598b2.050a0220.28fc4.0004.GAE@google.com>
In-Reply-To: <69d598b2.050a0220.28fc4.0004.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 8 Apr 2026 08:43:28 +0200
X-Gm-Features: AQROBzD7H6LzZMX-scupxnbnyjBdqMs5uYoi0WfMZHqtiZOF9FiLjkh-IkIVHa8
Message-ID: <CANp29Y612afmCUurtUhPQuo_vRmt4PTF+G4EJ5MnhSomw6vRkQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net_sched: fix skb memory leak in deferred
 qdisc drops
To: syzbot ci <syzbot+ci3caf9151c5a4e024@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Apr 8, 2026 at 1:52=E2=80=AFAM syzbot ci
<syzbot+ci3caf9151c5a4e024@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net_sched: fix skb memory leak in deferred qdisc drops
> https://lore.kernel.org/all/20260407170214.4157-2-fmancera@suse.de
> * [PATCH net] net_sched: fix skb memory leak in deferred qdisc drops
>
> and found the following issue:
> WARNING: suspicious RCU usage in cake_dequeue
>
> Full report is available here:
> https://ci.syzbot.org/series/90acbb62-3e93-4bb7-af7a-51d555f5956b
>
> ***
>
> WARNING: suspicious RCU usage in cake_dequeue
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      a9b8b18364fffce4c451e6f6fd218fa4ab646705
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/a5e0fad0-c9c8-4102-b2af-b4d1c7947=
ee3/config
> syz repro: https://ci.syzbot.org/findings/b1dd239a-f59f-414f-8bde-5782588=
99e94/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/net/sch_generic.h:581 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 2 locks held by syz.0.51/6016:
>  #0: ffffffff8e75e640 (rcu_read_lock_bh){....}-{1:3}, at: local_bh_disabl=
e include/linux/bottom_half.h:20 [inline]
>  #0: ffffffff8e75e640 (rcu_read_lock_bh){....}-{1:3}, at: rcu_read_lock_b=
h include/linux/rcupdate.h:903 [inline]
>  #0: ffffffff8e75e640 (rcu_read_lock_bh){....}-{1:3}, at: __dev_queue_xmi=
t+0x277/0x3890 net/core/dev.c:4778
>  #1: ffff8881ad9e8170 (&sch->root_lock_key#31){+...}-{3:3}, at: spin_lock=
 include/linux/spinlock.h:341 [inline]
>  #1: ffff8881ad9e8170 (&sch->root_lock_key#31){+...}-{3:3}, at: __dev_xmi=
t_skb net/core/dev.c:4241 [inline]
>  #1: ffff8881ad9e8170 (&sch->root_lock_key#31){+...}-{3:3}, at: __dev_que=
ue_xmit+0xbf2/0x3890 net/core/dev.c:4819
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 6016 Comm: syz.0.51 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  qdisc_root_sleeping include/net/sch_generic.h:581 [inline]
>  qdisc_dequeue_drop include/net/sch_generic.h:1173 [inline]
>  cake_dequeue+0x23a7/0x4e50 net/sched/sch_cake.c:2240
>  dequeue_skb net/sched/sch_generic.c:297 [inline]
>  qdisc_restart net/sched/sch_generic.c:402 [inline]
>  __qdisc_run+0x26c/0x15d0 net/sched/sch_generic.c:420
>  qdisc_run include/net/pkt_sched.h:120 [inline]
>  __dev_xmit_skb net/core/dev.c:4286 [inline]
>  __dev_queue_xmit+0x1bad/0x3890 net/core/dev.c:4819
>  packet_snd net/packet/af_packet.c:3076 [inline]
>  packet_sendmsg+0x3eb6/0x50f0 net/packet/af_packet.c:3108
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg net/socket.c:742 [inline]
>  __sys_sendto+0x672/0x710 net/socket.c:2206
>  __do_sys_sendto net/socket.c:2213 [inline]
>  __se_sys_sendto net/socket.c:2209 [inline]
>  __x64_sys_sendto+0xde/0x100 net/socket.c:2209
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f077b39c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f077c28c028 EFLAGS: 00000246 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 00007f077b615fa0 RCX: 00007f077b39c819
> RDX: 000000000000fc13 RSI: 0000200000000800 RDI: 0000000000000003
> RBP: 00007f077b432c91 R08: 0000000000000000 R09: fffffffffffffef0
> R10: 0000000000000880 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f077b616038 R14: 00007f077b615fa0 R15: 00007fffceb20038
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [damilola@aterlo.com davem@davemloft.net edumazet@google.com fmancera@sus=
e.de horms@kernel.org kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.=
com]
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
-upstream-moderation/69d598b2.050a0220.28fc4.0004.GAE%40google.com.
