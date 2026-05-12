Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ABFCE37BE89
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 06:17:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778566691; cv=pass; b=JYlxHmZqIMCiP8DwLjuuOd/cwPQu84h+mH+RNPEdClEFHCqGUBRwBt07pBhj/raCZn0po5MZpxbL98yEo3iWM/3QacjVEcVK4tEYS9u/8lUjTXUxlfMLbKB0WMavmxclKXTdJ/L7K2WjKI5Y827mYAZPF5pjEQsIJ4kzcnYqNr4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778566691; c=relaxed/simple;
	bh=sUbjhU7pZnuqmUx3yt/r/7oTw3ye9Ubcltyxhqy430g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Hda9E9nTLJ/DE+mrcZN3rU70gg3oCh/oLf4C6GkLb38njY34SYEoUb7iLNoaCZtskAJ/463PA67hOgr42zir9W8rBD+ekh1ArT95SRS/JSfajxf4Bxta8KA+syDEgjkLQ6Ki7sHu1hPRkzp+ekKQMcqgaAqDaNK6woJy3LZtky8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=QZnvlldf; arc=pass smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="QZnvlldf"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6966d16b978so1663052eaf.3
        for <syzbot@lists.linux.dev>; Mon, 11 May 2026 23:17:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778566666; cv=none;
        d=google.com; s=arc-20240605;
        b=UP6hhg23C12HFX+ijNraYhZcEYqxuMYk/rXedcR9GDTBlJFocQ3t3rN8ZQePq4A9Dy
         8qWX+KsfrkNjG2Yo1HxNaYNBekYD96TXQCx/yB/HXkXljpRZ5EMZkPawS2yUqKt2Hmmr
         gEIHF+OY58gGfZh8VfWmOmeF64nRcJsCRxA0+UGVQqF0KB3w8biw5f45M6t/BM4U+GRo
         LZdQF8JkpJORwNAqOiZL8+K616ZHmGnsUpVNOjQYdS+23PHtQyeNuLmSKJIiWu8L8gJl
         M2lWctESozTVCkSlKAqdjU29CzjCph5bRSglgGgMq9vfzUzFjLN8/AVUxLP5Ai2fQmlP
         P7sA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=QqikPj0/2hH4PfSa/3/Z2IqwLPqSMe1d2D1R+PQX4dI=;
        fh=JPRpSVcKakwJTI0Lz5BdXu4nZmDgeFC4VRAd2uW++pM=;
        b=C4Zj2Ij84roTHkuhov1OZqsBNLNaldICPogN4AoUKq9FTiqL9lQNAn6FCno6rvH7L7
         cO8e9kY1Gw8Dmg67lRuItTTqShMj0mR+RXWM/y9aCg5Y/i9HTBhTB/KUfM0eKN/SwXa+
         LE0HbyhE4EBB4EagAzAgtLe0j90RhanuH8kaWGzlhdngbmJi6JOZbFYFXJO0xtJch9QK
         f1aiHUo0s2bgsic2lEwP06mLlsj95HqBsKksLS1cxuw5JUaI7GnX7lESehYugfDa1jVe
         zpwdQV23rT0BLXPk+sRp/DY+pDQnblwT+TmzF2wR64CDgNplm+m6Uq3Km2s8adqvD3jW
         QTRA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778566666; x=1779171466; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=QqikPj0/2hH4PfSa/3/Z2IqwLPqSMe1d2D1R+PQX4dI=;
        b=QZnvlldf4pVUbyrwb54y6AY9ImqFiRHFYD+QuUvEI9WlCQpUSUYDbakGyxCjayglEf
         YJdhX33U0tDaA4dX2LvjkR83HqSvdw0vUVZwsoMvK9yqlyKltg0Aowd7aLwe+KsZ4u2v
         TMp3QGNJaA6UpgFpFcQ6XbFatN7cWKdPdYzNYUCvFqL58ul0uzDxnfDu51mISgGdi39A
         qUAKgYX06jogCWsb0nOBhEmhzYH5cBgy72cTUhSA0VCdJmXTkTG8exCk7AWNHWYDrSEE
         cfs8mzIHkAvWt3H0xAO0hP2SCASXsFW2UmMbAWluzD9cDclqHmNzkNKoBieIOPGgVayI
         eopA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778566666; x=1779171466;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=QqikPj0/2hH4PfSa/3/Z2IqwLPqSMe1d2D1R+PQX4dI=;
        b=fW/UvifLDW1DyvNNWn/dR438hUkxkFjUwaC3axk6X5yUZWFvMMuLB+0i8F1c9Sp0om
         N4JUH48Eg5lyPzZfkqB0paeLCdZ7LKKRKU1TnBFVdvJTA7RYmgmcX3ROOZybQ7In4ETO
         bset3k8oiy8PPSlE2uDdXyz6DXeojj9+z2a/Kr8vhYSZ9Gcc784vCFbmLdIDENSW68cr
         GQpRf1v5UoIedq80zEJ2wBjOl0WN1c4zrKsjRMhDi0TrCsCL4ETffgzy9fw8e/Qw5YYx
         IGhG+wAS1bR7Zx8IqD/FkNUSN8OWHNNENd51jo+NUlADepRhCDptHgcXTtEjbBWUCL6K
         fqAg==
X-Forwarded-Encrypted: i=1; AFNElJ+ZAfR4p3ug9d2Ue2s2pAOpHfy7ieisk5LCRteXTYP78JyTwkdG45a/E3bmmaFSUJ+Zf5oHKQ8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxaJe16GrdRIKfncMbIuF0gY2J5Pop9izRHxFYnl87cIGfFt63R
	54fQGqpcexETWnJlKj3s8g8Ko5ewJ5TEV+qhUrFo3XzhPla5xYQwNB9dpX9ajREZNXmpwloWLHl
	ksXFBVAZg0XYxvw8sej5xXGRJKM61VS60acuaATwdIowJR6LqJ9f4ofNc
X-Gm-Gg: Acq92OG2f2FJilIcMTi4uW21rbrpD6DuADrlR2EQO1w4C5XiLNfh0BvYaauq5dHhe8X
	eKrkZ2Bxhh+/p3FGr6QtCbV7yo4wBUqYX4JJaioopKncVAQG0PMNEvtRoTQUUux0dM4uwdkZjE5
	X/dtdTjKSJkr3YCwENQGNjm++1q0ezlArdWXnQmBYDrZH1m8cFlhv1/OEZtXZvXKdc5yhhbQVw4
	zSAyVzCZxlIKxCMMbqCZRlfoFQRiZT+o8L17X3MCxIgF4gYjTMLhlvDRhb2vytW846KOXnPMGqK
	uL16ZyxJM4gK8/CMz/QE090jpAz1rSwX099VrXayYGZ7p7jBOOw87ofimzl0EnC1Qez7C/2XJNx
	99U9Z9rg=
X-Received: by 2002:a05:6820:2206:b0:699:b131:d589 with SMTP id
 006d021491bc7-69b36ad3840mr7078073eaf.3.1778566665972; Mon, 11 May 2026
 23:17:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a0283e1.170a0220.7f9b3.0007.GAE@google.com>
In-Reply-To: <6a0283e1.170a0220.7f9b3.0007.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 12 May 2026 08:17:34 +0200
X-Gm-Features: AVHnY4I-UnjQs0nu6_mtz72Ojw11eEa4csBl2mW_8QIRyEuO7UhsCYzdhyQV8Ss
Message-ID: <CANp29Y59zbvFC+6QZ-8MfntX=ZRR0dzdLg2+Wz_CwjWYzfiQNQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: tcp: fix stale per-CPU tcp_tw_isn leak
 enabling ISN prediction
To: syzbot ci <syzbot+ciee63f726d92f39f7@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, May 12, 2026 at 3:35=E2=80=AFAM syzbot ci
<syzbot+ciee63f726d92f39f7@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] tcp: fix stale per-CPU tcp_tw_isn leak enabling ISN prediction
> https://lore.kernel.org/all/20260511151559.1916614-1-edumazet@google.com
> * [PATCH net] tcp: fix stale per-CPU tcp_tw_isn leak enabling ISN predict=
ion
>
> and found the following issues:
> * BUG: using __this_cpu_write() in preemptible code in tcp_v4_do_rcv
> * BUG: using __this_cpu_write() in preemptible code in tcp_v6_do_rcv
>
> Full report is available here:
> https://ci.syzbot.org/series/45073ca6-4b5b-4cbd-83bf-ae30c470d334
>
> ***
>
> BUG: using __this_cpu_write() in preemptible code in tcp_v4_do_rcv
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      a450063ef86b9967234ca1f896c0d77400c74f11
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/d6bfac50-400c-447d-b4f2-f5caa36c1=
6ac/config
> syz repro: https://ci.syzbot.org/findings/95b64202-6cf3-4356-94bc-753dbd8=
443c4/syz_repro
>
> BUG: using __this_cpu_write() in preemptible [00000000] code: syz.0.17/58=
75
> caller is tcp_v4_do_rcv+0xb4a/0x13e0 net/ipv4/tcp_ipv4.c:1881
> CPU: 0 UID: 0 PID: 5875 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
>  tcp_v4_do_rcv+0xb4a/0x13e0 net/ipv4/tcp_ipv4.c:1881
>  sk_backlog_rcv include/net/sock.h:1190 [inline]
>  __release_sock+0x265/0x3a0 net/core/sock.c:3216
>  release_sock+0x190/0x260 net/core/sock.c:3815
>  mptcp_pm_rm_addr_or_subflow+0x472/0x9d0 net/mptcp/pm.c:789
>  mptcp_nl_remove_id_zero_address net/mptcp/pm_kernel.c:1140 [inline]
>  mptcp_pm_nl_del_addr_doit+0x503/0x1430 net/mptcp/pm_kernel.c:1176
>  genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1114
>  genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
>  genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1209
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f6847f9cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f6848e95028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f6848215fa0 RCX: 00007f6847f9cdd9
> RDX: 0000000024000800 RSI: 0000200000000140 RDI: 0000000000000004
> RBP: 00007f6848032d69 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f6848216038 R14: 00007f6848215fa0 R15: 00007ffe50763178
>  </TASK>
>
>
> ***
>
> BUG: using __this_cpu_write() in preemptible code in tcp_v6_do_rcv
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      a450063ef86b9967234ca1f896c0d77400c74f11
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/d6bfac50-400c-447d-b4f2-f5caa36c1=
6ac/config
> syz repro: https://ci.syzbot.org/findings/f5960777-902c-46ad-b811-9dff0f1=
7d320/syz_repro
>
> BUG: using __this_cpu_write() in preemptible [00000000] code: syz.0.173/6=
173
> caller is tcp_v6_do_rcv+0x10c2/0x1ca0 net/ipv6/tcp_ipv6.c:1644
> CPU: 0 UID: 0 PID: 6173 Comm: syz.0.173 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
>  tcp_v6_do_rcv+0x10c2/0x1ca0 net/ipv6/tcp_ipv6.c:1644
>  sk_backlog_rcv include/net/sock.h:1190 [inline]
>  __release_sock+0x1b8/0x3a0 net/core/sock.c:3216
>  __tcp_close+0x832/0xfe0 net/ipv4/tcp.c:3238
>  __mptcp_close_ssk+0x52d/0x1180 net/mptcp/protocol.c:2604
>  mptcp_destroy_common+0x15c/0x330 net/mptcp/protocol.c:3408
>  mptcp_destroy+0x82/0x120 net/mptcp/protocol.c:3616
>  __mptcp_destroy_sock+0x156/0x370 net/mptcp/protocol.c:3250
>  __mptcp_close+0x8f6/0xd10 net/mptcp/protocol.c:3352
>  mptcp_close+0x28/0x1a0 net/mptcp/protocol.c:3367
>  inet_release+0x143/0x190 net/ipv4/af_inet.c:442
>  __sock_release net/socket.c:722 [inline]
>  sock_close+0xc3/0x240 net/socket.c:1514
>  __fput+0x44f/0xa60 fs/file_table.c:510
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
>  exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f69be79cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc7668ad18 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 00007ffc7668ae00 RCX: 00007f69be79cdd9
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 0000000000012dd1 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000001b32b20000 R11: 0000000000000246 R12: 00007ffc7668ae40
> R13: 00007f69bea15fac R14: 0000000000012e0a R15: 00007f69bea15fa0
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
nel.org kuba@kernel.org kuniyu@google.com ncardwell@google.com netdev@vger.=
kernel.org pabeni@redhat.com]
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
-upstream-moderation/6a0283e1.170a0220.7f9b3.0007.GAE%40google.com.
