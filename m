Received: from mail-qk1-f175.google.com (mail-qk1-f175.google.com [209.85.222.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 433A6449982
	for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 07:45:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.175
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783669530; cv=pass; b=Tc95Ils6+qXEvaG4bTCpgqyL7/cM5MWD5mGDNqlVHqTA1/vNnksUXc28DdjHo8XEGgMy41BRC6/oWojSBMHTDn5QhnE3CueXKCoaDmFGYIXJfFJlpt6iyztz3nQDXW5X2eirkDiCoFw5DSlobBL/epzNggS1Hbe6mzpd5/MPFa0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783669530; c=relaxed/simple;
	bh=b2ZKEY0Bz8QUKFV/jt4HSB3FZg4uznL4p6/RUWJeKuQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dt5I9JJ3FHx5kV55pEZ9c1C1M3KaxQis8do9eY3tsow+rA8nDBMshyubQEQgm1sukFery85qodjYYBddU1WZydLrEjRkVN32fTualD65xjoxgwM2XnlCxAnu6O6mOhxJtG7WWa+KrZqvM8mn8PZYMUvv7tb35t2Mwsi+ua1Xc0o=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pJEfFSpt; arc=pass smtp.client-ip=209.85.222.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pJEfFSpt"
Received: by mail-qk1-f175.google.com with SMTP id af79cd13be357-92e6c4a867cso33187285a.0
        for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 00:45:29 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783669528; cv=none;
        d=google.com; s=arc-20260327;
        b=Gfwx2qQfsb1hQYKyOyAsAw35UF9DUpr+4KFNVXLVUEJXMRaMjqadiMgZIVE6k25uHR
         4SzbDFMB4X6eSNpo5yIEzB5v3r/ONjtL2wA+9n7O1g+yB8crBmiFy+7IPf4TZsyKYP0S
         dzvtF/bDIaShXX14TmEbgMODPIsaZypSIqGBTx8AVm88e5k/Zu8uyfmsmGswdkTGc4+Q
         YZ0HET7wx8m5YT7SxB1jNE5QPznbJ+JEeHCIQnMtgWhHTJB7C5DahPQrHPheQp9KfH+w
         wVxMSXkZjz08wxw/A6aLWj3vJY6tZp+QwQFuswt7YC7ZBM/P5bMcHmXR6jdXi4y2VlUC
         PQjg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gRHJ51E/ADRSUvZts3E19TZjMJ0cUaENYQjNIV0byDs=;
        fh=Otqkw6S+HEooKB0LyHy3bybVLu05WFOMpfYuGaJZeFg=;
        b=MgjPUdWRWVVhsePgL7iq2rLTkU3O/9AS9EfVWf62GpNW+dKfEDDWpeapcG+v3Q4LgH
         k5tuJiWAyAHZL8OHZkSC2bW3qtbbYNJnloXVlPIwV2R9ri6vvBDzN+fhHV0zxR6NMpNA
         ++yzWC3SXHZRMvgE/pJWx40iS98iFh8zax0Yk4l/aLeYVieLPp5YeJpkKJZW1cywer1j
         WxhD/p+lWpItL86fgRvlECQMOoSo78L1so91OtQkRMpfEvV1uvGbbd9d7cBD1Qp6apwl
         tJFCpleCDJuu2KdutUQDu+jgW6fKsfDdESYLCa0bEsE3gbzSfjFRLDqyiv+izSdZocgF
         m5Fg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783669528; x=1784274328; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=gRHJ51E/ADRSUvZts3E19TZjMJ0cUaENYQjNIV0byDs=;
        b=pJEfFSptQDA+oOzVvOWLXza93YJF3Hg+UXzBYlzdQP/D80m735GIbbiW10kq322ra8
         nXUf2B55poTAJ/PClzKD+fXTw4rkGLWgG1ud9nWJqZTj/ROrgdq08nAZ+0Rvng7k/362
         dIrItjo1Zc6lBhSBpn70SZ1qzofKClfDaqkSZL6Ul/CStYNc24Qp01ArmkhAp+RcIbfC
         ScUm9v8ZHuYjgDeiwcvZ6uH4KsWOsHZOE9n21aBTXgMd5PhBx5lwTKGwDKpn25sxHjYr
         SIc11fC2S8E3Gi77Lu8vNxlXSFkX4KZbjBBNjbDbhqfNJ+3FhQykfA9Qo6KXZIPdttuy
         ChUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783669528; x=1784274328;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gRHJ51E/ADRSUvZts3E19TZjMJ0cUaENYQjNIV0byDs=;
        b=jmheY89+LFmcFOtqyZiVUKzo7C1bJC2LGE0VGo26vRphzI8obETH4qsGHJGtc1RiKV
         v1IV6BQkqD7Z/QqNXonVq7PA0VBgX3N1wNRTWjx9dydV416/pq7Dlzv3bFCa91VVHSZY
         wFBn6daqcJ4w7Rtnsk4X29ivd1g2lh9V/nuqP7RtsLH7LNVm4z2je6nHl9dW31l5OjDW
         wNrWGqSBm0/RiZMWBfazkdmq/mh+arXuepgCLabz/83VDznGzQ1pXuCfUmMDxFBEWmUt
         ls/5X5n5hXLoeesInLOMftS3nWEwO4/3Q2HSNRmyg4/sHVXQCx3nNAv5IozFPCwEsS9L
         dIgg==
X-Forwarded-Encrypted: i=1; AHgh+RqgB/92I60GnV6Ys7PR7NgW5qPHXtr/AlcjR/MvQxWIfmcOVHIE9gj1Lz/AL6YlWhh/2bM6j4s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy1G5IZJDsR/HPMMqIVez2g8gvP7+AFgpQLPMWHzl21Xzx3XN86
	JKW52y/e0gkkCFUDj9eFqWot5cV2CF1i99l8NhmNQ8gEaIST4uQiSM327w2m0YsNAi0khX6Oz43
	825AmQW7NkFV88AP39fXvxWzSWIW83Pac8l0lO98F
X-Gm-Gg: AfdE7cno6Ye+/W8D0nM5S36DHU3YzvAP8YoEAW7Szul04DKUqULYhsnWf0JQTiFPR7C
	aTKz9SH+akBfWl/LJ9C3X6deg1ACvrWHMgh/5GJau4oI+xKBlZkKkXBkXDpdzrajpXO9hou80T5
	zNqoK+/j+fp3UgA1PS+ryuinztN1Dfrhi0leFZtvK3xHCr6UIv1nFuaIMVFcbBY6IoSvFVfyTpA
	tbKZwxJBZXB/HArcfDwnj2c0TzTV1ey59ssZKf+RRTrtNizavecCzDBr+Gnj4MODX3X9nAegs2B
	V/5dmss/lH4n8IlGXsLk1cbg/TpWEZpFAcMSncG5APMyrDygXMwa+WDRupdt9hyWFpS0UMFq
X-Received: by 2002:a05:620a:ac1c:b0:92e:e4e9:cc67 with SMTP id
 af79cd13be357-92ee4e9d44emr209763585a.59.1783669527575; Fri, 10 Jul 2026
 00:45:27 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a4ffcb0.c76b52dc.2a15e.0000.GAE@google.com>
In-Reply-To: <6a4ffcb0.c76b52dc.2a15e.0000.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Fri, 10 Jul 2026 09:45:16 +0200
X-Gm-Features: AUfX_mzJtLa8a5C8QRR4ikMMezlF_iHgQWaCTjUoqu0hMu_hiRRGu36mfDWe5wQ
Message-ID: <CAJWNTGx3VAfQ3zG8yybc610hn2C3wQ-wmfLsxAE18g_8wt+Ufw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: flowtable: tear down HW offloaded
 flows on FIB route changes
To: syzbot ci <syzbot+cid7cd031fc49e60cf@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Thu, Jul 9, 2026 at 9:55=E2=80=AFPM syzbot ci
<syzbot+cid7cd031fc49e60cf@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] netfilter: flowtable: tear down HW offloaded flows on FIB route chan=
ges
> https://lore.kernel.org/all/20260708205404.911832-1-anzaki@gmail.com
> * [PATCH nf] netfilter: flowtable: tear down HW offloaded flows on FIB ro=
ute changes
>
> and found the following issue:
> general protection fault in net_generic
>
> Full report is available here:
> https://ci.syzbot.org/series/75cd5a68-8e8e-41ef-9da6-dea3554407a7
>
> ***
>
> general protection fault in net_generic
>
> tree:      nf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf.git
> base:      60444706aa17616efc03190d099ac347e28b3d0a
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/b941607c-6459-4d25-8127-6c11f2a37=
ef0/config
> syz repro: https://ci.syzbot.org/findings/93de0afd-01d4-4d54-9d3f-1309433=
5f314/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc00000002c8: 0000 [#1] SMP KASAN PTI
> KASAN: probably user-memory-access in range [0x0000000000001640-0x0000000=
000001647]
> CPU: 1 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:net_generic+0xd4/0x240 include/net/netns/generic.h:46
> Code: 8c be 4a 03 00 00 48 c7 c2 c0 83 e0 8c e8 14 1b 09 f8 49 bf 00 00 0=
0 00 00 fc ff df 49 81 c6 40 16 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00=
 74 08 4c 89 f7 e8 0d a4 9a f8 4d 8b 26 e8 45 e8 1b
> RSP: 0018:ffffc90003bde998 EFLAGS: 00010202
> RAX: 00000000000002c8 RBX: ffffffff8999417e RCX: ffff8881699c5940
> RDX: 0000000000000000 RSI: ffffffff8c2ab760 RDI: ffffffff8c2ab720
> RBP: 0000000000000005 R08: ffffffff8999417e R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff8e959c20 R12: ffff8881b1679870
> R13: dffffc0000000000 R14: 0000000000001640 R15: dffffc0000000000
> FS:  00007ff6de31c6c0(0000) GS:ffff8882a921d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ff6dd272780 CR3: 000000016bc8e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  fib_seq_sum+0x29/0x280 net/core/fib_notifier.c:43
>  register_fib_notifier+0x49/0x360 net/core/fib_notifier.c:106
>  nf_flow_table_init+0x34a/0x460 net/netfilter/nf_flow_table_core.c:888
>  tcf_ct_flow_table_get+0x13b6/0x1f40 net/sched/act_ct.c:352
>  tcf_ct_init+0x6bd/0xb10 net/sched/act_ct.c:1423
>  tcf_action_init_1+0x4ba/0x740 net/sched/act_api.c:1433
>  tcf_action_init+0x30e/0xb10 net/sched/act_api.c:1508
>  tcf_action_add net/sched/act_api.c:2106 [inline]
>  tc_ctl_action+0x43b/0xc70 net/sched/act_api.c:2163
>  rtnetlink_rcv_msg+0x7b9/0xc00 net/core/rtnetlink.c:7085
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
>  __sock_sendmsg net/socket.c:790 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
>  __sys_sendmsg net/socket.c:2770 [inline]
>  __do_sys_sendmsg net/socket.c:2775 [inline]
>  __se_sys_sendmsg net/socket.c:2773 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff6dd39ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff6de31c028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007ff6dd615fa0 RCX: 00007ff6dd39ce59
> RDX: 0000000000000040 RSI: 0000200000000080 RDI: 0000000000000003
> RBP: 00007ff6dd432e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff6dd616038 R14: 00007ff6dd615fa0 R15: 00007ffd83f8d058
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:net_generic+0xd4/0x240 include/net/netns/generic.h:46
> Code: 8c be 4a 03 00 00 48 c7 c2 c0 83 e0 8c e8 14 1b 09 f8 49 bf 00 00 0=
0 00 00 fc ff df 49 81 c6 40 16 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 38 00=
 74 08 4c 89 f7 e8 0d a4 9a f8 4d 8b 26 e8 45 e8 1b
> RSP: 0018:ffffc90003bde998 EFLAGS: 00010202
> RAX: 00000000000002c8 RBX: ffffffff8999417e RCX: ffff8881699c5940
> RDX: 0000000000000000 RSI: ffffffff8c2ab760 RDI: ffffffff8c2ab720
> RBP: 0000000000000005 R08: ffffffff8999417e R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff8e959c20 R12: ffff8881b1679870
> R13: dffffc0000000000 R14: 0000000000001640 R15: dffffc0000000000
> FS:  00007ff6de31c6c0(0000) GS:ffff8882a921d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ff6dd3ea540 CR3: 000000016bc8e000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   8c be 4a 03 00 00       mov    %?,0x34a(%rsi)
>    6:   48 c7 c2 c0 83 e0 8c    mov    $0xffffffff8ce083c0,%rdx
>    d:   e8 14 1b 09 f8          call   0xf8091b26
>   12:   49 bf 00 00 00 00 00    movabs $0xdffffc0000000000,%r15
>   19:   fc ff df
>   1c:   49 81 c6 40 16 00 00    add    $0x1640,%r14
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 38 00          cmpb   $0x0,(%rax,%r15,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 f7                mov    %r14,%rdi
>   34:   e8 0d a4 9a f8          call   0xf89aa446
>   39:   4d 8b 26                mov    (%r14),%r12
>   3c:   e8                      .byte 0xe8
>   3d:   45                      rex.RB
>   3e:   e8                      .byte 0xe8
>   3f:   1b                      .byte 0x1b
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
> [anzaki@gmail.com davem@davemloft.net edumazet@google.com fw@strlen.de ho=
rms@kernel.org kuba@kernel.org netdev@vger.kernel.org netfilter-devel@vger.=
kernel.org pabeni@redhat.com pablo@netfilter.org]
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
-upstream-moderation/6a4ffcb0.c76b52dc.2a15e.0000.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
