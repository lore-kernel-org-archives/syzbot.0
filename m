Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D35342519
	for <syzbot@lists.linux.dev>; Wed,  8 Apr 2026 20:13:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775679208; cv=pass; b=pwwRXSXZZMvi3uOz1h9PCBUXWo6egUlhzFK/FmmK5TI/nJghI4KQ+MigDnzmb4Oi4ZQ1+DFuRTPhmqyBE7LUeQuOsrWfhw8jBk6i6CUP6I1Ng1jAB9xrnuONgPfPoRBQKK7Y96QGWKz9hEPJ6eUYVD3x9fRaQqdM9mh6mMbvShs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775679208; c=relaxed/simple;
	bh=scllXX/kH8TXqyvdDepJsPod8oVjqU3oowRm0CfnD54=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g4oYhtdIW4/IRZT/lp0T+P+IFOEqT4A3yN/xfXmOHgvWS4z5GUfhP/77bOc+KcGIFoUtAQki+lYRj6aktZ89afTT2EJReex7OjEOeBkV0rXrnsXm0nejDuDUEz/rltATAxayrTi7nWo8SuC2Pptyg9pnyjvynrSvpNUfLs/hxXs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=dGbBrZfb; arc=pass smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="dGbBrZfb"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-68a1a4692e8so102548eaf.3
        for <syzbot@lists.linux.dev>; Wed, 08 Apr 2026 13:13:26 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775679206; cv=none;
        d=google.com; s=arc-20240605;
        b=UEzI85cS2UNfeq/knWyQuyZpXevOL6WQK7n5z88QUdnF+t4vlHZKu1e4zrR7YaWS7X
         XqI8fxoz1adJC1k4b/J2h4PtFdO2e7v5P6rHTbvOt8KIRNJovBpUxC2vJ3PcP6Q9UhoG
         1C1lrWtA7MPg6AZnR3ze2BoBIPW9i26+G9w+0MxPJLIopY1e3x6VYIuZqWSjEQLUhDlA
         lXHlB2BKK6dPqTkLZ5uYB/XD64U3x+NDrxJln5KGLeNrBpt8ZlWh00YYNazuuqItccKH
         BztPd6maDhVGhe/r3wSzIwoz7vIsysU4AAqoQ+Cl6pNQoh8qkbTZKcfGsd60AXQ4z3wl
         nmzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dsBVYGA8CS+ZA1ce3F2EDlCexpTPxWPoyvxp03FgbtI=;
        fh=n3mA0vhKnMKm9WfQjQ6EKgPBEb7vhHVzBqSfJKs+dAs=;
        b=dIV9qui1ciAKCanpdtpIaycHAg7B3KYulMyUAG09efKdKCOCrB/mcQqg/11TOpax2H
         nNRLSegrhwJAEn8tlmG8oPp307oX2ASg4T8z7q6agW/ViYUoXwccjj0ASJ55pky9aBrA
         NQOVKjFUtPBWzZoXCFt8aupCMWsRujhdLNvO95TAKwCCToywQpnhmofQsCs3D/o5f7NC
         d2DqOtUg4fSH99gZAnl72vzQ8NmdJMdPfDHWWepveWEozGRSpl0X3MosY1+5/1DprVX2
         5Bdjtn6p6rkp2L0PWiXpOBWFShh0/96xnONXi7ehYo1EK/oI6BcZZXkVMH6yBufda3KU
         jSaQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775679206; x=1776284006; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dsBVYGA8CS+ZA1ce3F2EDlCexpTPxWPoyvxp03FgbtI=;
        b=dGbBrZfb10CHY5NU5wcLNDppnPOLWSJs/MpvUgAwyZxSoyX1Ccv7z3hBBt0pbEuO7H
         YhaQo+qoW8QAqZVz0K9ikhOZWs7FR4tIn8KDhC3TWFnEqx8e8H3vgjYmrcLATvZTJMoN
         o3GUMDnRub1xbQAVg+i9R3JD8bu5zNdWFqMuxfEgWpZgJt4rC1zbGXVyqfrkWTVPlhzs
         4xK+Q1tMHzLw3FCrQ6uXKxZ90axUaoHzCiCJzDRrfLGHkLSItxrLGn4gdlc3FULIG/bS
         4HWxGMLiQ6QGSmvrn2Ja+1uFBr3f86RC47W3manLzOL5p6AwFU6JzpXKRZEjXnk6wqht
         QFwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775679206; x=1776284006;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dsBVYGA8CS+ZA1ce3F2EDlCexpTPxWPoyvxp03FgbtI=;
        b=mxmka9LBJZbJIr4qnCMBzh4WC6/8cfVewQ17Oco25+ujWUvIeRAbZvRN8A8kcdgTDi
         Hhl+sYxV/DIqmBAZNw+v0N85qqVx7LzqenWKKonTIVRWT7CJdjcYcwPMF+KuUIJB605h
         Yb17I5hC0H9Rnx09jOImZ1J156PO74Fx5Garg1yZQC1Ms7ihXkWZVKllyqdltIgzqVUE
         JdknAgE48wPt6qN9BZ396YcMpZX85nj41aIL/los6Jux48eae0SRnQ6DeT8B0ArnIKQZ
         mSR3Lqg1v60yOhWSVrr2IsT2u+CRImjVNVDp01qqshOcJ9P1EEnU1TYzgG/mAQFx8Ytb
         tz8Q==
X-Forwarded-Encrypted: i=1; AJvYcCUwlY9KlQf5VH3pPafpXho/smY2B1tY6TkstopAj/qv8VK9gk9Yeansm/swrZigqyZh1EARiac=@lists.linux.dev
X-Gm-Message-State: AOJu0YwPa8dkvjsLMfWWmBoKRBwywPJdUF9DkP2ZuSrx3LGddJ7QqSZr
	azcgSopMy/DfIorEl318LKZrpF9+tzg+OaM55Ul7xTnhuwbZvg3ZaPSXg+uu8BUePQpkNG8qknk
	ZvsJ3a8F2iYoSgF5jyonKE4uNvQjBeVV655hRqvuwAKpv4UHulke1lvJ2
X-Gm-Gg: AeBDieupnp4S+AJg6ZCBDVcFaGlSvx5dme5pUQIGs2NK84ndmVZGDKCOKyMuiDobw4J
	tO/DHd2L7Upc661K1pHN1hyGym2P01lsEt7ZfcGOirk5XW8iGfAssu61Usrn/ejpa8FT88vWfPS
	R+XerRQ+8l7mjeMcKA4Ng/nMbTdYt89aU3eLVLnENgTrIjaE878462vqELG7TdhMeruOpQX4NrL
	2s/v437wWl8YM0Tkh3hqcG4ouyRTGCC3dHOixJ7BEnBcSAoaCjxxKPdUr4WUTuMftcq7WLMZkC8
	8aciT+ANiGxRk2xVtTYqRS779PjLgYtRF8r/dLZ/oQhrH/CC3G5UxQqvwWGFo81+/nHGkQ==
X-Received: by 2002:a05:6820:4b84:b0:67c:27a7:8c45 with SMTP id
 006d021491bc7-68220f40764mr13471268eaf.57.1775679205141; Wed, 08 Apr 2026
 13:13:25 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69d6b5f9.050a0220.d95e.0002.GAE@google.com>
In-Reply-To: <69d6b5f9.050a0220.d95e.0002.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 8 Apr 2026 22:13:12 +0200
X-Gm-Features: AQROBzBdMR3V-9MgU06Zd0IYQI25kn3boxbE4JOG2rXHbg_KWQ_hANVr48bgXqY
Message-ID: <CANp29Y5gZZVOr9z50SwL9_Q=yjG5WHEBVOUYBbpbeFC88NJJTg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net/sched: no longer acquire RTNL in qdisc dumps
To: syzbot ci <syzbot+cicb5229b7652215a9@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Apr 8, 2026 at 10:09=E2=80=AFPM syzbot ci
<syzbot+cicb5229b7652215a9@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net/sched: no longer acquire RTNL in qdisc dumps
> https://lore.kernel.org/all/20260408125611.3592751-1-edumazet@google.com
> * [PATCH net-next 01/15] net/sched: rename qstats_overlimit_inc() to qsta=
ts_cpu_overlimit_inc()
> * [PATCH net-next 02/15] net/sched: add qstats_cpu_drop_inc() helper
> * [PATCH net-next 03/15] net/sched: add READ_ONCE() in gnet_stats_add_que=
ue[_cpu]
> * [PATCH net-next 04/15] net/sched: add qdisc_qlen_inc() and qdisc_qlen_d=
ec()
> * [PATCH net-next 05/15] net/sched: annotate data-races around sch->qstat=
s.backlog
> * [PATCH net-next 06/15] net/sched: sch_sfb: annotate data-races in sfb_d=
ump_stats()
> * [PATCH net-next 07/15] net/sched: sch_red: annotate data-races in red_d=
ump_stats()
> * [PATCH net-next 08/15] net/sched: sch_fq_codel: remove data-races from =
fq_codel_dump_stats()
> * [PATCH net-next 09/15] net/sched: sch_pie: annotate data-races in pie_d=
ump_stats()
> * [PATCH net-next 10/15] net/sched: sch_fq_pie: annotate data-races in fq=
_pie_dump_stats()
> * [PATCH net-next 11/15] net_sched: sch_hhf: annotate data-races in hhf_d=
ump_stats()
> * [PATCH net-next 12/15] net/sched: sch_choke: annotate data-races in cho=
ke_dump_stats()
> * [PATCH net-next 13/15] net/sched: sch_cake: annotate data-races in cake=
_dump_stats()
> * [PATCH net-next 14/15] net/sched: mq: no longer acquire qdisc spinlocks=
 in dump operations
> * [PATCH net-next 15/15] net/sched: convert tc_dump_qdisc() to RCU
>
> and found the following issues:
> * WARNING: suspicious RCU usage in mq_dump_common
> * WARNING: suspicious RCU usage in mqprio_dump
> * WARNING: suspicious RCU usage in tc_fill_qdisc
>
> Full report is available here:
> https://ci.syzbot.org/series/a6ab0157-80eb-4d29-ab75-31a471a9070e
>
> ***
>
> WARNING: suspicious RCU usage in mq_dump_common
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      b3e69fc3196fc421e26196e7792f17b0463edc6f
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/f4a44029-347c-4dad-b84f-81c322454=
de4/config
> syz repro: https://ci.syzbot.org/findings/d5d8c727-6baf-4738-bc33-e8a42f5=
39e21/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> net/sched/sch_mq.c:158 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 1 lock held by syz.1.18/6007:
>  #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg+0x7=
22/0xbe0 net/core/rtnetlink.c:6986
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 6007 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  mq_dump_common+0x2fa/0x5e0 net/sched/sch_mq.c:158
>  mq_dump+0x7e/0x150 net/sched/sch_mq.c:181
>  tc_fill_qdisc+0x663/0x11c0 net/sched/sch_api.c:937
>  qdisc_notify+0x1cf/0x440 net/sched/sch_api.c:1033
>  notify_and_destroy net/sched/sch_api.c:1058 [inline]
>  qdisc_graft+0x114a/0x15b0 net/sched/sch_api.c:1158
>  __tc_modify_qdisc net/sched/sch_api.c:1760 [inline]
>  tc_modify_qdisc+0x18a4/0x2290 net/sched/sch_api.c:1816
>  rtnetlink_rcv_msg+0x77e/0xbe0 net/core/rtnetlink.c:6989
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1d3839c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f1d392c4028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f1d38615fa0 RCX: 00007f1d3839c819
> RDX: 0000000000044080 RSI: 0000200000000040 RDI: 0000000000000003
> RBP: 00007f1d38432c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f1d38616038 R14: 00007f1d38615fa0 R15: 00007fff29960058
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> net/sched/sch_api.c:943 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 1 lock held by syz.1.18/6007:
>  #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg+0x7=
22/0xbe0 net/core/rtnetlink.c:6986
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 6007 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  tc_fill_qdisc+0xd90/0x11c0 net/sched/sch_api.c:943
>  qdisc_notify+0x1cf/0x440 net/sched/sch_api.c:1033
>  notify_and_destroy net/sched/sch_api.c:1058 [inline]
>  qdisc_graft+0x114a/0x15b0 net/sched/sch_api.c:1158
>  __tc_modify_qdisc net/sched/sch_api.c:1760 [inline]
>  tc_modify_qdisc+0x18a4/0x2290 net/sched/sch_api.c:1816
>  rtnetlink_rcv_msg+0x77e/0xbe0 net/core/rtnetlink.c:6989
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1d3839c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f1d392c4028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f1d38615fa0 RCX: 00007f1d3839c819
> RDX: 0000000000044080 RSI: 0000200000000040 RDI: 0000000000000003
> RBP: 00007f1d38432c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f1d38616038 R14: 00007f1d38615fa0 R15: 00007fff29960058
>  </TASK>
>
>
> ***
>
> WARNING: suspicious RCU usage in mqprio_dump
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      b3e69fc3196fc421e26196e7792f17b0463edc6f
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/f4a44029-347c-4dad-b84f-81c322454=
de4/config
> syz repro: https://ci.syzbot.org/findings/159b3573-da89-4289-89cf-85c39c6=
2db59/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> net/sched/sch_mqprio.c:570 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 1 lock held by syz.1.18/5958:
>  #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg+0x7=
22/0xbe0 net/core/rtnetlink.c:6986
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5958 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  mqprio_dump+0x3db/0x1370 net/sched/sch_mqprio.c:570
>  tc_fill_qdisc+0x663/0x11c0 net/sched/sch_api.c:937
>  qdisc_notify+0x28c/0x440 net/sched/sch_api.c:1038
>  notify_and_destroy net/sched/sch_api.c:1058 [inline]
>  qdisc_graft+0x114a/0x15b0 net/sched/sch_api.c:1158
>  __tc_modify_qdisc net/sched/sch_api.c:1760 [inline]
>  tc_modify_qdisc+0x18a4/0x2290 net/sched/sch_api.c:1816
>  rtnetlink_rcv_msg+0x77e/0xbe0 net/core/rtnetlink.c:6989
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff019b9c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff01ab3e028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007ff019e15fa0 RCX: 00007ff019b9c819
> RDX: 0000000020000000 RSI: 0000200000000200 RDI: 0000000000000005
> RBP: 00007ff019c32c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff019e16038 R14: 00007ff019e15fa0 R15: 00007ffc53020ce8
>  </TASK>
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> net/sched/sch_api.c:943 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 1 lock held by syz.1.18/5958:
>  #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg+0x7=
22/0xbe0 net/core/rtnetlink.c:6986
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5958 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  tc_fill_qdisc+0xd90/0x11c0 net/sched/sch_api.c:943
>  qdisc_notify+0x28c/0x440 net/sched/sch_api.c:1038
>  notify_and_destroy net/sched/sch_api.c:1058 [inline]
>  qdisc_graft+0x114a/0x15b0 net/sched/sch_api.c:1158
>  __tc_modify_qdisc net/sched/sch_api.c:1760 [inline]
>  tc_modify_qdisc+0x18a4/0x2290 net/sched/sch_api.c:1816
>  rtnetlink_rcv_msg+0x77e/0xbe0 net/core/rtnetlink.c:6989
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff019b9c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff01ab3e028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007ff019e15fa0 RCX: 00007ff019b9c819
> RDX: 0000000020000000 RSI: 0000200000000200 RDI: 0000000000000005
> RBP: 00007ff019c32c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff019e16038 R14: 00007ff019e15fa0 R15: 00007ffc53020ce8
>  </TASK>
>
>
> ***
>
> WARNING: suspicious RCU usage in tc_fill_qdisc
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      b3e69fc3196fc421e26196e7792f17b0463edc6f
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/f4a44029-347c-4dad-b84f-81c322454=
de4/config
> syz repro: https://ci.syzbot.org/findings/0dada8ec-a4b6-42a1-8516-d70ce8c=
cccc7/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> net/sched/sch_api.c:943 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 1 lock held by syz.0.17/5963:
>  #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #0: ffffffff8fbca4c8 (rtnl_mutex){+.+.}-{4:4}, at: rtnetlink_rcv_msg+0x7=
22/0xbe0 net/core/rtnetlink.c:6986
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5963 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  tc_fill_qdisc+0xd90/0x11c0 net/sched/sch_api.c:943
>  qdisc_notify+0x1cf/0x440 net/sched/sch_api.c:1033
>  notify_and_destroy net/sched/sch_api.c:1058 [inline]
>  qdisc_graft+0x114a/0x15b0 net/sched/sch_api.c:1158
>  __tc_modify_qdisc net/sched/sch_api.c:1760 [inline]
>  tc_modify_qdisc+0x18a4/0x2290 net/sched/sch_api.c:1816
>  rtnetlink_rcv_msg+0x77e/0xbe0 net/core/rtnetlink.c:6989
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:721 [inline]
>  __sock_sendmsg net/socket.c:736 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2585
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2639
>  __sys_sendmsg net/socket.c:2671 [inline]
>  __do_sys_sendmsg net/socket.c:2676 [inline]
>  __se_sys_sendmsg net/socket.c:2674 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2674
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9e5e39c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f9e5f2d6028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f9e5e615fa0 RCX: 00007f9e5e39c819
> RDX: 0000000000000000 RSI: 00002000000007c0 RDI: 0000000000000003
> RBP: 00007f9e5e432c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f9e5e616038 R14: 00007f9e5e615fa0 R15: 00007ffc6a25e4e8
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
> [davem@davemloft.net edumazet@google.com eric.dumazet@gmail.com horms@ker=
nel.org jhs@mojatatu.com jiri@resnulli.us kuba@kernel.org kuniyu@google.com=
 netdev@vger.kernel.org pabeni@redhat.com sdf@fomichev.me toke@toke.dk]
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
-upstream-moderation/69d6b5f9.050a0220.d95e.0002.GAE%40google.com.
