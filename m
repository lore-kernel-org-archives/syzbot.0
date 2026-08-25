Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C0A93CB8FC
	for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 20:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787688394; cv=pass; b=Bm1xWI3F0JXiFUY8h3V01VuURefqdV0QMcDelxo6ODP9PNRapJm+lmYl3m9lcf3QMXf61n6cLj1keikZApG5sOihfVbng8H4+JiKgk0PHThVS5yiD1CiRdd/SwDMCWmmxy38XIcQa9O3eVu5RDeSC0HtaJxrHQd1Xv5Y+kIQlRE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787688394; c=relaxed/simple;
	bh=goEsYHXU9OL4pvLJ9tQB3aXRG3oUR92qCmIuRaO4ryw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Qe3UUBV+naha/h1QkGc+l/JYRBUNeNju34Wyj/hnPtipby031eg18QETEN1qsXyEgxSwMUNFbMkvQkTrR5qWteZ5fU0VPyHUJQA9jDPIitnEwXescXy3UiZn0tt8pw3m4WtLsOwuforz3GMdQXpAMev4RhGDgA2HSnO54FKVXWg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Mfc9wkET; arc=pass smtp.client-ip=209.85.210.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Mfc9wkET"
Received: by mail-ot1-f53.google.com with SMTP id 46e09a7af769-7e9ecb1e13cso325201a34.3
        for <syzbot@lists.linux.dev>; Tue, 25 Aug 2026 13:06:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787688390; cv=none;
        d=google.com; s=arc-20260327;
        b=r85S/CoCd5BRKiRekcL+AuOzIUavrP19GwjEdLqAJ5luk8D2cPx+cuRcobNDPEDPns
         OSsqPlEn64vm8R9vn8rwfwTsfMBVLB2DPBERHcfIYLXLl0skL7EhuENgH/XmHSQwYlSg
         pTk+b1CuymiepzfQKA2ONoQ3aqMuX10SIZfnxYQfXQGtVukMwegpkJDL2Qo3pVC3hE5/
         Cx6R88mFr41ssPvHndQcP4JY4HSi6CLB4OaOf7pJoz0zuxzzQj241NQjvmYDjqAF8omj
         dWSq0iUqO9N6RcR1oszqrLO9q1034xXKVELMLd/lccr79vPE9YuKzLNeiVjFeVNXcQmE
         wmnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=IdjkGraNRbWn0BjK9G79xoRpq4078V7Qzj/O15lxyBU=;
        fh=vFvmyFfEW9mGGF+iqxHkRHJyx8bt2NCyAdXWZYofbmw=;
        b=dYB3iAoOGjfMoOMzFXSmCNgr8NNQiuSsm3uODrooDKd8mWpgB0enYMxHLbUlel7eAw
         EHW+bqRZWcMN6Q9rtWNaxwXjC2Rk/C+cMjy/N/40RRMyauwb79VZxe8iA6P4x2QWgc5m
         DxA49cNoqofaVGu3Gb5iMpKw+EuPMUXuFgjdKhGWF7P2RP3ojqJKSzgjvU5m6lqRrOUm
         rJrPUItmGeCXLqshKvtc0lxNrJ2vXTwqXZSQlQiQ+I4CCyLCZnlhU+8DSMAI5326PyqJ
         JSVihxpSBzR3fhgVLO6a7DR+dknskOUBvEBK/kTVZgQcpVezxLGlWzoTfI85gW5jvSOS
         lfNg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787688390; x=1788293190; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=IdjkGraNRbWn0BjK9G79xoRpq4078V7Qzj/O15lxyBU=;
        b=Mfc9wkETVOtLPqHTyoKOEegAnCk28Juv0kdmql1BFz9wujoYAiG6rOlOZJ1W/inmgi
         8yeHG/gX25HGDjrStwHQfOBVbZepbw8VIe7nMLETf9amqn6hOZ4Mz9u6nutTSFSQUyOd
         TJmgSNGRvZyy3vDsSPfnje9GIC+V4r7B5myy11+NG62SiDkZTnOMAFH8ENZnQ8pAhXhs
         go/XQdVGMQNAxkj3hA68Dafh1n4+UuhXfX1NocaeP09mOuUaCAxDhXfj+lafoFodkK6d
         txTZow3LXv9BhC2retrxIBIP4lQC0Y2wZhhucsclWhaL3EcqAylOX2y+GyIMm49lYxjQ
         N5DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787688390; x=1788293190;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=IdjkGraNRbWn0BjK9G79xoRpq4078V7Qzj/O15lxyBU=;
        b=eCQTs/9WcYj2kFWID1p6lIdBGZRV53cAjnIEnD8Dnp9QAH38w9kedljbQSreToIJXf
         LG5nMxYKoq3iOVW+mJIbfcRttV9ERp4LbOfPwCFb+tmxVHQrY50MGsXPQGfv+OXpPyuL
         5xV9tLYHhqqJYLlqTk2uOMvX2vzkQwSQsE1nI9Tc0NvZem69svCxWEbGjZ39vZjMLULq
         leW1rgJv7154+kBfr0vFUwhBTrYbx0AZjtE/fNVopqidBoYx1APaQzgwc2Zm9nbFNOK+
         4NbS1CPzlESwgAaizL2bH81OGDR22b3VfnsCecIiO4t50zPMtSUoAL06UTTYL4dW3HsC
         MRVQ==
X-Forwarded-Encrypted: i=1; AHgh+Rp753Iqw+oRDgVnXU3BanvOoToLNQoqEiBkl5n71DmNQhgnSyhnl8SnbpHmdofEEbutVQs8nHE=@lists.linux.dev
X-Gm-Message-State: AFuF++l5txOpZwskWjlTdPFVMM0HUGVIyKz1zlMuWSY4A8uBjU3atvP4
	kBxC/4UZZwvAPNgWmv5pjhvEloFXDlaFmCWbPxl9Xphx/mAmVoAVm4s2BpEPtrqHgWxq3NoM7Gi
	279WtYqkhyGBDMAaL8570JkY+Fq1pLaF7Y/7u2lUB
X-Gm-Gg: AR+sD11YV2rAwyH9ilTcMLY+5xJjPgGUGCCmUqDmxwzWipeXvwg6ceyxQjUqrYp0bms
	3OMhULRkuoiYQ/szsGWNfKudU8YtFMcJ2pK3AMCZ8O6oyzaIK8olQG6b7FEhJ2QKMRrIBLzbuSj
	l2295bs3IKrb992Oq8T8tzXfUFc75CPdywi+6LWNot2TsdDA035oKiUWtZJ9yuhIo5G3V9sxtpY
	iMO6ahZuV0YLzss1Lhz7Vyj18p7i732T1RoVjvlrbeyLjZYRnO7IDVQGDDN1SdWhozNpMcOJo4x
	+h/TwhCBH7hL9fE+xLyZzzgOeCuvLpt60WL9WmZwZ3MBGBj98TfyvKNppClsNVPiwpjWLAuksDJ
	mL+Dpany/alSZRRMAakPrEGPPUVREk/Lx+GfsBn1hjE6gYW7RISP5ELRgJManheaQSDOyZLvHQ0
	lqWG29auVsz+JO+Lw=
X-Received: by 2002:a05:6830:4885:b0:7dc:c4ae:a679 with SMTP id
 46e09a7af769-7f4c4f65926mr1479389a34.9.1787688389568; Tue, 25 Aug 2026
 13:06:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a8dee2b.dbb3a75c.7844.002b.GAE@google.com>
In-Reply-To: <6a8dee2b.dbb3a75c.7844.002b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 25 Aug 2026 22:06:18 +0200
X-Gm-Features: AcwNN1UHm2QpW0tFY4TMPqcETG4HwnfOThvEM8AFy0bZ5vZkVnd6WytCqVWtxnE
Message-ID: <CANp29Y5JyvS2L5uN7h6PQ1QjE9kq1u0EQ1RMEGPRnkfzSc6Gag@mail.gmail.com>
Subject: Re: [moderation/CI] Re: xsk: Fix circular locking dependency in xsk_bind
To: syzbot ci <syzbot+ci3e599a23fb294b09@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Aug 25, 2026 at 9:34=E2=80=AFPM syzbot ci
<syzbot+ci3e599a23fb294b09@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] xsk: Fix circular locking dependency in xsk_bind
> https://lore.kernel.org/all/20260825152152.86092-1-ahemadkhawar123@gmail.=
com
> * [PATCH bpf-next] xsk: Fix circular locking dependency in xsk_bind
>
> and found the following issue:
> possible deadlock in xp_clear_dev
>
> Full report is available here:
> https://ci.syzbot.org/series/6f095c15-0f05-4d2e-a9eb-8d4d85f669a6
>
> ***
>
> possible deadlock in xp_clear_dev
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      5e289c5a4a526e870efac0ca658635c47138593a
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/cde9ebbb-b104-4fe4-8779-17786d4f4=
336/config
> syz repro: https://ci.syzbot.org/findings/bb56c4f2-d20c-4177-a137-5836241=
05374/syz_repro
>
> netlink: 14 bytes leftover after parsing attributes in process `syz.0.17'=
.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz.0.17/5789 is trying to acquire lock:
> ffff88816f80ee70 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock =
include/linux/netdevice.h:2861 [inline]
> ffff88816f80ee70 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: netdev_lock_=
ops include/net/netdev_lock.h:42 [inline]
> ffff88816f80ee70 (&dev_instance_lock_key#3){+.+.}-{4:4}, at: xp_clear_dev=
+0x13b/0x340 net/xdp/xsk_buff_pool.c:297
>
> but task is already holding lock:
> ffff8881741d06b8 (&xs->mutex){+.+.}-{4:4}, at: xsk_notifier+0xcd/0x230 ne=
t/xdp/xsk.c:2109
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #1 (&xs->mutex){+.+.}-{4:4}:
>        __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>        __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
>        xsk_bind+0x2c0/0x1370 net/xdp/xsk.c:1622
>        __sys_bind_socket net/socket.c:1945 [inline]
>        __sys_bind+0x2e3/0x410 net/socket.c:1976
>        __do_sys_bind net/socket.c:1981 [inline]
>        __se_sys_bind net/socket.c:1979 [inline]
>        __x64_sys_bind+0x7a/0x90 net/socket.c:1979
>        do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>        do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #0 (&dev_instance_lock_key#3){+.+.}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3181 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3300 [inline]
>        validate_chain kernel/locking/lockdep.c:3924 [inline]
>        __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5253
>        lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5886
>        __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>        __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
>        netdev_lock include/linux/netdevice.h:2861 [inline]
>        netdev_lock_ops include/net/netdev_lock.h:42 [inline]
>        xp_clear_dev+0x13b/0x340 net/xdp/xsk_buff_pool.c:297
>        xsk_notifier+0x1a1/0x230 net/xdp/xsk.c:2118
>        notifier_call_chain+0x1a5/0x3d0 kernel/notifier.c:85
>        call_netdevice_notifiers_extack net/core/dev.c:2313 [inline]
>        call_netdevice_notifiers net/core/dev.c:2327 [inline]
>        unregister_netdevice_many_notify+0x17f9/0x2140 net/core/dev.c:1251=
8
>        rtnl_delete_link net/core/rtnetlink.c:3652 [inline]
>        rtnl_dellink+0x5be/0x810 net/core/rtnetlink.c:3694
>        rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7132
>        netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>        netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>        netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
>        netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>        sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
>        __sock_sendmsg net/socket.c:815 [inline]
>        ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
>        ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
>        __sys_sendmsg net/socket.c:2799 [inline]
>        __do_sys_sendmsg net/socket.c:2804 [inline]
>        __se_sys_sendmsg net/socket.c:2802 [inline]
>        __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
>        do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>        do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> other info that might help us debug this:
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&xs->mutex);
>                                lock(&dev_instance_lock_key#3);
>                                lock(&xs->mutex);
>   lock(&dev_instance_lock_key#3);
>
>  *** DEADLOCK ***
>
> locks held by syz.0.17/5789: 3, last CPU#1:
>  #0: ffffffff90036040 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_lock net/core/rt=
netlink.c:80 [inline]
>  #0: ffffffff90036040 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_net_lock include=
/linux/rtnetlink.h:134 [inline]
>  #0: ffffffff90036040 (rtnl_mutex){+.+.}-{4:4}, at: rtnl_dellink+0x41b/0x=
810 net/core/rtnetlink.c:3686
>  #1: ffff88801d81eed0 (&net->xdp.lock){+.+.}-{4:4}, at: xsk_notifier+0x89=
/0x230 net/xdp/xsk.c:2105
>  #2: ffff8881741d06b8 (&xs->mutex){+.+.}-{4:4}, at: xsk_notifier+0xcd/0x2=
30 net/xdp/xsk.c:2109
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5789 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2059
>  check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2191
>  check_prev_add kernel/locking/lockdep.c:3181 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3300 [inline]
>  validate_chain kernel/locking/lockdep.c:3924 [inline]
>  __lock_acquire+0x1520/0x2cf0 kernel/locking/lockdep.c:5253
>  lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5886
>  __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>  __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
>  netdev_lock include/linux/netdevice.h:2861 [inline]
>  netdev_lock_ops include/net/netdev_lock.h:42 [inline]
>  xp_clear_dev+0x13b/0x340 net/xdp/xsk_buff_pool.c:297
>  xsk_notifier+0x1a1/0x230 net/xdp/xsk.c:2118
>  notifier_call_chain+0x1a5/0x3d0 kernel/notifier.c:85
>  call_netdevice_notifiers_extack net/core/dev.c:2313 [inline]
>  call_netdevice_notifiers net/core/dev.c:2327 [inline]
>  unregister_netdevice_many_notify+0x17f9/0x2140 net/core/dev.c:12518
>  rtnl_delete_link net/core/rtnetlink.c:3652 [inline]
>  rtnl_dellink+0x5be/0x810 net/core/rtnetlink.c:3694
>  rtnetlink_rcv_msg+0x802/0xc00 net/core/rtnetlink.c:7132
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:800
>  __sock_sendmsg net/socket.c:815 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2713
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2767
>  __sys_sendmsg net/socket.c:2799 [inline]
>  __do_sys_sendmsg net/socket.c:2804 [inline]
>  __se_sys_sendmsg net/socket.c:2802 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2802
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2ec039e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f2ec1214028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f2ec0625fa0 RCX: 00007f2ec039e0d9
> RDX: 0000000004048004 RSI: 00002000000001c0 RDI: 0000000000000005
> RBP: 00007f2ec0435024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f2ec0626038 R14: 00007f2ec0625fa0 R15: 00007ffca00aa538
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
> [ahemadkhawar123@gmail.com ast@kernel.org bpf@vger.kernel.org daniel@ioge=
arbox.net kuba@kernel.org linux-kernel@vger.kernel.org maciej.fijalkowski@i=
ntel.com magnus.karlsson@intel.com netdev@vger.kernel.org pabeni@redhat.com=
 sdf@fomichev.me syzbot@syzkaller.appspotmail.com]
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
-upstream-moderation/6a8dee2b.dbb3a75c.7844.002b.GAE%40google.com.
