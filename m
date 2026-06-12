Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D91CA267B89
	for <syzbot@lists.linux.dev>; Fri, 12 Jun 2026 22:09:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781302151; cv=pass; b=Jy3QK5quZLSRpXEUAoHOJQHTF4SrT2h+Sb2St9nOH1ubhOkfOu/aqXE9z8TYTRDtI+d8bJV4raR71tuRH+xvNJReJs8WAmF4Co+g7mewsTztRwfKGD+t95kQfHe+PyCsgyGOdpPgbv1+PVgLuwx5wjSNqru0XZKYIKU0/NmB/yc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781302151; c=relaxed/simple;
	bh=zxts3Jh/JHMOhn1e8TR4zVLAdp/JEc3vxHmmV8/KXaM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H3j4NSg0xXTMkpWVoOKFEWhI6rsLilPgSMP7ODW8ioMJlaRYWIUggEG/R1/PPwkYXyDGcfzWNQFiREVqPPzAwIjLPvno/nIq9ogGOqSLjxTgc/z25BxyTiBr8uSVNATPpVTKfAgjL8TkNQ00rkpsGSDwEICJkBTNdl/w/Yj3glQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=I5fg1D9D; arc=pass smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="I5fg1D9D"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-43d23173511so901733fac.0
        for <syzbot@lists.linux.dev>; Fri, 12 Jun 2026 15:09:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781302149; cv=none;
        d=google.com; s=arc-20240605;
        b=bGyLo7qeLe0rn2r2WFkfvyeanZmQQnszVbbIfiSs9N8KnF2zw29psSnXY3HLKYj3cU
         k49HA5Psk8fmdBpXCJRGfkE9u1KNXJWlL8bVej2na9RDPSUYf+Bi/RMOQ4T/vNB06mCk
         F/vR8ET3E3TnMdMa2b9BgwscmG+2X0lj+BpUyL2A5P3lGVeqr2wQvXX6y+SM10KCfvJL
         DJtDNWirxNKCkgjVoNHXjNaJ+JGmb+YkRBsG6Csq0oDtRzu+JftQCp8H5deMd2JohQkX
         9LJdnuKRz+oUtmn0Xb9Sv7M+K4T6n/xGm+vAIFBqjLIpa73ExMrkUjhTc4WDH8n+L5Yg
         L4RA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R1qirr7wOUTcy9Aa5sG7OmwNnblku0Mg9MTS2hxBFzU=;
        fh=WRtdcyQUMJdeNBmTYdi6ZE1D7RlcJTVZaI7ITaz1WIs=;
        b=gFVdZsQrxQgNv6BuWSyc0uh7dyeAdj1Gwpb8Z9hVDxX5jfQ6EnId4MW/eI8u8+4l2I
         C1FwITBZCApWpTwf70k/MlWO7kvXquZhgaojpJS2+onqC/2jd4gcuuz6NpxpF1Ia+UYn
         AxE01kDNVF7ZVeWE9jFr+LpIcXt1aKRMwuLkCDFXfxXQSSxw/XnjXhn/cFNUGtHwxOCt
         4iDLRiEBUUhd15P7rRKmex/G+GuUT0W5YZe+BzvPuLFPWsm2OhkgItfMt3DyjWEFx8oZ
         gnTnKPYhv9KHa8kVEFxoIkWTWTl/0KN4dnfA5WHeusKhnfh9p639fdZB6jLC1UERBrSa
         QjOA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781302149; x=1781906949; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R1qirr7wOUTcy9Aa5sG7OmwNnblku0Mg9MTS2hxBFzU=;
        b=I5fg1D9D65xET/yyYO06nCCviBgcXM5tVgIlshXFQbLEClXHjq2kSjRVUvlPyHb0LQ
         yjRTX/j7/VSZJWUNZEfZg0BSA+NPCL6WYn8eu/kTmqaGZhueLgdXKCDcQq/FuiCtkUMi
         0c8PU+T5InX8u1Mj6MyHqWN+Ypm6ZaYUmDAc7/4VXpjeOpng/I30+BVMOmBsttzbBmC8
         jJkvriZ1kYcFliH/C0qvb2dsydjHoVmVuL64u5hKTQoWOUw2D69mdVsvEaVP3ptf3FOx
         Y8jqkG3NB6Ue2v6t3YVT9iPZ8YdzxcmeNNrLLZV7gbReuQGBfKpvBc+TfyylBj1PEbTD
         GZMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781302149; x=1781906949;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R1qirr7wOUTcy9Aa5sG7OmwNnblku0Mg9MTS2hxBFzU=;
        b=UJSd4QJ7DGGPq8qHkTtd13jqulMy3FQMJ3/W8vlOzZgS3xXMTIhVUSxPMAP7nD/uul
         2omJc12VP3wu0t9IN4veztFbmCyqe5e1j0DH7XTeAU4iHFo2/q7/KQQDXUkmeuuV+Gln
         xQDR4VwsZn7SuuaITzOIM2uJRW/hJf52qCRARVOdXXWLh0YdxNFC+3BuR55sY7q3wQ8H
         khH9Uwlzl3jYzp35L4gBwwDelL2Qtm/58RRMjzLT35z6v6LwZMFLr42r/G5olp81EMU7
         Gi3YCY+hvGPWJcnndQY02AwcCzkso05G60xtoHkcxDqeaSsWK0sTNfCFYPmD2WBRaZEu
         5b1w==
X-Forwarded-Encrypted: i=1; AFNElJ8hz1UlXxmT2jthn82FzoWYCXB29Wr8w79d5b8rEzCMFDFbu9C6nYXJ/oA28bvJxis4td/21CA=@lists.linux.dev
X-Gm-Message-State: AOJu0YytRZAzGlDnLcwxd3NpBeF+ZPiUmNgdJCBpe4aEPqi0SFER01FS
	ff4gtWApSUw0iHoyypVIt1MYJDOsOQ2XtJG6CbdlggcWRkrCXEDrUoeTpFI8RTonDrkdhkZe9GK
	YxHpjc2KgaQCdKktO7gK1OrrpxuXBpH5KaIeGJ8Lu
X-Gm-Gg: Acq92OHlFEYFasScgbf7M6Otju0qF6BaPlYMzkAeiYqadPfKq80lxmd+Lsr+3wR1onY
	t0NtepruYWsS7FHL5Ef/Ee7CHPp7Kzto/ea1RtnHNVRYDobYJ8mNBwJS+h1mcJUCpBYZj53qtUC
	wwkzWjzLinWFNpcuJ3ibpcEEZEcPxOaPktnA3ytZBItfXuewh62RGteMh9D61StLimLrkzlziBw
	H/N4A3iy1FUbs0/JQgE/UX55nPX30mvFg5L5ZqxbFZCX+Rrg6xpdYMSU9Hl6HQIGbk0xYAWEN3h
	1OAs+78PvCEwCLEHczP4WVl6BONswlIqIVMhxWScxy/5v7+GCgUsiKQLzbYWvlufTFwqksZ+
X-Received: by 2002:a05:6870:6c14:b0:441:419:1fea with SMTP id
 586e51a60fabf-4426dd5ac1amr2984992fac.11.1781302148109; Fri, 12 Jun 2026
 15:09:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a2c6b22.be3f099c.2836ae.0003.GAE@google.com>
In-Reply-To: <6a2c6b22.be3f099c.2836ae.0003.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 13 Jun 2026 00:08:55 +0200
X-Gm-Features: AVVi8CdBWRLbhNkFBDVJVUZgR6h_kKSd1ifx__wOsHjSBRuPYT9ZKgnkAncZlR4
Message-ID: <CANp29Y7uCCdbnqUn8VF2Uopg9S=TjCwrhuc3qoh31GKYeMWm3g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: tcp: opportunistic loopback splice for
 BPF-paired sockets
To: syzbot ci <syzbot+ci8502ead12f7ad416@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Jun 12, 2026 at 10:25=E2=80=AFPM syzbot ci
<syzbot+ci8502ead12f7ad416@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] tcp: opportunistic loopback splice for BPF-paired sockets
> https://lore.kernel.org/all/20260612011452.134466-1-xiyou.wangcong@gmail.=
com
> * [RFC PATCH bpf-next 1/5] tcp_bpf: add bpf_sock_splice_pair kfunc for op=
portunistic loopback splice
> * [RFC PATCH bpf-next 2/5] tcp_bpf: busy-poll the splice ring before park=
ing the receiver
> * [RFC PATCH bpf-next 3/5] selftests/bpf: add tcp_splice basic round-trip=
 test
> * [RFC PATCH bpf-next 4/5] bpf: allow SO_BUSY_POLL in bpf_setsockopt()
> * [RFC PATCH bpf-next 5/5] selftests/bpf: set SO_BUSY_POLL from the tcp_s=
plice sockops prog
>
> and found the following issues:
> * WARNING: suspicious RCU usage in tcp_bpf_recvmsg
> * WARNING: suspicious RCU usage in tcp_bpf_splice_sendmsg
>
> Full report is available here:
> https://ci.syzbot.org/series/7c43d5ae-cb19-4b2b-96ad-f7f0806ac63c
>
> ***
>
> WARNING: suspicious RCU usage in tcp_bpf_recvmsg
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      30dee2c176e7954f63d1fa3e52d172f30beb9bfb
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/09e43fc4-ebab-492e-b1de-15bb86aa4=
588/config
> syz repro: https://ci.syzbot.org/findings/79db1500-f71c-4550-8525-89bf060=
44d60/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> net/ipv4/tcp_bpf.c:883 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> no locks held by syz.0.17/5822.
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5822 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  sk_psock_is_spliced net/ipv4/tcp_bpf.c:883 [inline]
>  tcp_bpf_recvmsg+0x1780/0x1980 net/ipv4/tcp_bpf.c:405
>  sock_recvmsg_nosec+0xee/0x140 net/socket.c:1137
>  ____sys_recvmsg+0x3e3/0x4a0 net/socket.c:2916
>  ___sys_recvmsg+0x215/0x590 net/socket.c:2960
>  do_recvmmsg+0x334/0x800 net/socket.c:3055
>  __sys_recvmmsg net/socket.c:3129 [inline]
>  __do_sys_recvmmsg net/socket.c:3152 [inline]
>  __se_sys_recvmmsg net/socket.c:3145 [inline]
>  __x64_sys_recvmmsg+0x198/0x250 net/socket.c:3145
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1af799ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f1af87bc028 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
> RAX: ffffffffffffffda RBX: 00007f1af7c15fa0 RCX: 00007f1af799ce59
> RDX: 0000000000000002 RSI: 0000200000000400 RDI: 0000000000000003
> RBP: 00007f1af7a32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000010051 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f1af7c16038 R14: 00007f1af7c15fa0 R15: 00007ffdef205588
>  </TASK>
>
>
> ***
>
> WARNING: suspicious RCU usage in tcp_bpf_splice_sendmsg
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      30dee2c176e7954f63d1fa3e52d172f30beb9bfb
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/09e43fc4-ebab-492e-b1de-15bb86aa4=
588/config
> syz repro: https://ci.syzbot.org/findings/8144de7d-1a2e-454e-ab17-08d1c65=
86df2/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> net/ipv4/tcp_bpf.c:883 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> no locks held by syz.2.19/5817.
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5817 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  sk_psock_is_spliced net/ipv4/tcp_bpf.c:883 [inline]
>  tcp_bpf_splice_sendmsg+0x1165/0x1490 net/ipv4/tcp_bpf.c:897
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x80a/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmmsg+0x27c/0x4e0 net/socket.c:2841
>  __do_sys_sendmmsg net/socket.c:2868 [inline]
>  __se_sys_sendmmsg net/socket.c:2865 [inline]
>  __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2865
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd1c339ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fd1c42e3028 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
> RAX: ffffffffffffffda RBX: 00007fd1c3615fa0 RCX: 00007fd1c339ce59
> RDX: 0000000000000001 RSI: 0000200000001000 RDI: 0000000000000003
> RBP: 00007fd1c3432d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000004008005 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd1c3616038 R14: 00007fd1c3615fa0 R15: 00007ffdcdbac378
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
> [bpf@vger.kernel.org cwang@multikernel.io hemanthmalla@gmail.com jakub@cl=
oudflare.com jiayuan.chen@linux.dev john.fastabend@gmail.com netdev@vger.ke=
rnel.org xiyou.wangcong@gmail.com zijianzhang@bytedance.com]
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
-upstream-moderation/6a2c6b22.be3f099c.2836ae.0003.GAE%40google.com.
