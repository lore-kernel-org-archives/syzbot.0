Received: from mail-qk1-f174.google.com (mail-qk1-f174.google.com [209.85.222.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E09A63F1AAD
	for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 09:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.174
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783677301; cv=pass; b=RkBYQilJzCDCOUk5QAup85+aiPCbtKrWEiC3v3Y9Wp75xVix+ay8Ab62h7GGEnrzePpzsJvDfm+wzZcqDjvKA6axl2k9x/F5jod9H1s6P3gxnRUAptqEYV5NPdBdxPRIOY0cXK2PZEX31MjFHwWWJ4Ozl5kRK45ZrUE8T9GJegY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783677301; c=relaxed/simple;
	bh=uLPArJFdDLyzk4lcBeSGIAz+uk4fGo5irMEN3gjErHk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=lHzxMOUCb+X6XL9gWdF7ZyrlvjL45+P59oscE6fN2Bb5AqiJ18KRXx6LZMnpS6TzVLkMk0zx3Igt7xVVFHz84Sfq03IG10ou8fMnTXm0pT119BuUUZ9hC0KfrlPSmfJDIrXyU0nf97sJrRRIzf6dONCNDMBVIo5xkE8IkYdLpBk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IFQUtsMx; arc=pass smtp.client-ip=209.85.222.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IFQUtsMx"
Received: by mail-qk1-f174.google.com with SMTP id af79cd13be357-92e533aacf2so33886285a.2
        for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 02:54:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783677299; cv=none;
        d=google.com; s=arc-20260327;
        b=JEbI1v5HlfhYxvgS31wI9hFkfdNJMm+eGHVvATNy6mnYvQNctXSnDYCnbMM/KWB8Qq
         y1GMeqnGi/s3DIOZd81Xo0vA/892zSJ9I16mP0Lv3jevdosbHZFa9lpaBdSJt3iZHMOP
         1T+VMBAuvxJFCT++kaU/efzTtFnTQfi588Ol7axzHhy4g8wAgP5S83XQDOq4FJaGrmle
         m5Iwn75WFTs5MJ0O5Ooa+XmZMYRb00LIi5fgkkTa7KhHmZbba1T4bqe7dUfZ41Zr69am
         JwsK4nZZ/U/bLxlSMGrFap0kXsLD83fxtbwr2i6iPG5FsnJnOX31s78uxpmhQGSEohTc
         +Jfw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7sf0zTVWicEpcZXDYNWHK9VGKc7SLTht0hvkGrVdLQs=;
        fh=oeYJROs+TO3yMgxYnZZuAjCixUJSxJ9+oe/89KYJ1kg=;
        b=VxJqSyJj5Pb96GnZoawUMDfWjbwTxtXKFrc6BDKtjZ29YE6SowWWHH8hKqBJK7dVJE
         +qz1t0brySehx4rVU8cZLsAantQixUJ3Ayzp42UPamsXmYWsQR1muhY3EKvUoWJvOF+T
         u/5E0VDj34l/bCwvLp2ZF3ioV3zLjhnWBncfhp/3L82ROQ7wBNhkzsvOCpDXtAP58FMZ
         n7R6cA7ENTB/rNz2fiKTzJfpE6zuWs4VTE2IcvT+waqhsQoCZ9zbS0Vsf+2XZTew2HJr
         cuTLUDe/1PAHHa/40Tscfi/q8VzX0yrcopOZTNBq+BsU+QzvlIPyr1BvrCIswX/XW/mp
         ZnMA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783677299; x=1784282099; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7sf0zTVWicEpcZXDYNWHK9VGKc7SLTht0hvkGrVdLQs=;
        b=IFQUtsMxHH9mZ6m6yLyujRm3V+Yw0soA3eZDQZnOTtVXIyGcBG+LwFZXQxxS9T6bPW
         cZ9h7bajfcCB079mm5jOw2FzAALmMvzGkTp+rjrxbCXTIBV7IthA6dYizrthXaHoJtTs
         TgokAF5WuLXVhM+BI5fuRBriszj3oDn1MrFGRPj141O55RqvPWAsKHH01+GfxKw4C5Iv
         ihyf01nhBrRDNhVVMik9aYb7TO/uMCcxBrx/mQqMz15ISC+ePZHnizOLhkm5dSrxhyBJ
         mNjoh99rnck170qUtXQcD2WXMj1SKPydan3qg6JzJsiQkDqRmCg84uMaGzyastr9O9LW
         aGFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783677299; x=1784282099;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7sf0zTVWicEpcZXDYNWHK9VGKc7SLTht0hvkGrVdLQs=;
        b=Hh37gkupYDhWGTk05vf6p0v5evrL3mq1dxZWTKRYmpUpu9qGdqPehQQOAvM2JdRoap
         /DEBd3oKdmMxqY8vBOA8SPCh4+eLauQNPOmbLqWZxenrM+8nACPV5LjT97VsYZsc4hu8
         cpm6U1ZfQDo2KE5JSwFeVxkD4Z8hgndGWXowqgrnNGBtu5MC4TSQ1aAgtF2q6xInFr2w
         Nzocvb+zGUF8pDBwKDIf2buKbW1K1bMX3+u7hErMOL49kt1dLo0rQI45DMNmv6PDPJ/f
         YT5L9QmLb/V1SJMbbY49gm+ofAbPVkialzm7e2B7kdGMqUOrQeDCmnw+1H/pvv37MpI1
         BLuA==
X-Forwarded-Encrypted: i=1; AHgh+RpuRs6ABHci6g8Di4Gq3qsEvEO06MDorTNZpcSZSdLDMzzbVJrBu5uVdSsj4+1YF5Y7CUjWqMQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwpWW275DtcYYnD289/Gth98jxh8PxdC0u1E5Is410rwUx8P9Zu
	pwgZKbtHycot/NnV8mbm7G9lgF8rCfkWj1h0v8HuqZXAQnGepI5Kq3zVgHU0UFa0rnmyxTclkPY
	vZISeQdnsUx2o2kusDPCp/eHXosZaFdVWISN3KjPY
X-Gm-Gg: AfdE7clAZquxYzPOgE7NfC1fsSJZvdAXgYnd/wW+w2VdrrQSOpN5Vtm2I9sgfmQvjFb
	nEJ3hMEN0tV0oA5MYNpiMb1uq4V+xRfg82izOXbKWJlrd6892ICuL67zOm90VJci2vUDoyzgbLI
	7/HYP+hvdsYC/IkjsuG+fc4PJnEzjEROI8vdoZN3M3bz2TUXC6804PPpZMj00dVXjnizgKDkNLB
	Eju3XVhmFdvbRql6HoxaZM0JSNGDinKsK/EkMXtFGBNw8n8BPqOrQvwFBHZHllHK09O7mVpgiz6
	V46WA5pPREnzxxEtSMyRoPtmVhU+otn9JS5KJLBYc41MDkZu2074cafr9VI=
X-Received: by 2002:a05:620a:6884:b0:92e:6338:cedb with SMTP id
 af79cd13be357-92ecf8d47e1mr1024157985a.73.1783677298129; Fri, 10 Jul 2026
 02:54:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a50bb37.57639fcc.86d58.0025.GAE@google.com>
In-Reply-To: <6a50bb37.57639fcc.86d58.0025.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Fri, 10 Jul 2026 11:54:47 +0200
X-Gm-Features: AUfX_mzRC2N-afdKrs3EV43Ea7UfBcuOOOUS1EOfjRjjSFVRHfUed5-uaQ3gU5Q
Message-ID: <CAJWNTGzEh2MU1oJUL1Jg1soLheNwvbpm=FRCuDOU1ZsTBiPxtw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: macvlan: allow source mode devices along with passthru
To: syzbot ci <syzbot+ci8d333e09229b69c8@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Fri, Jul 10, 2026 at 11:28=E2=80=AFAM syzbot ci
<syzbot+ci8d333e09229b69c8@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] macvlan: allow source mode devices along with passthru
> https://lore.kernel.org/all/20260709100512.1383421-1-t.martitz@fritz.com
> * [PATCH v2 1/1] macvlan: allow source mode devices along with passthru
>
> and found the following issue:
> general protection fault in macvlan_port_release_mac
>
> Full report is available here:
> https://ci.syzbot.org/series/2632619d-fb66-47ac-85a1-a781bbb0d57d
>
> ***
>
> general protection fault in macvlan_port_release_mac
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      fe3e786ef4eb6e47d2901f568a27bd920477bbe9
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/90f86060-ab12-43d6-a718-5d0f5eb5d=
f09/config
> syz repro: https://ci.syzbot.org/findings/d1f12788-51d7-4251-8fc9-6bfda6a=
1e20a/syz_repro
>
> batman_adv: batadv0: Removing interface: batadv_slave_1
> veth1_macvtap: left promiscuous mode
> veth0_macvtap: left promiscuous mode
> veth1_vlan: left promiscuous mode
> veth0_vlan: left promiscuous mode
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000118: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x00000000000008c0-0x00000000000008c7]
> CPU: 0 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: netns cleanup_net
> RIP: 0010:macvlan_passthru drivers/net/macvlan.c:78 [inline]
> RIP: 0010:macvlan_port_release_mac+0x138/0x490 drivers/net/macvlan.c:807
> Code: 01 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 b9 3=
0 ae fb 48 8b 1b 4c 8d b3 c0 08 00 00 4c 89 f0 48 c1 e8 03 <42> 0f b6 04 20=
 84 c0 0f 85 44 02 00 00 45 8b 36 44 89 f6 83 e6 01
> RSP: 0018:ffffc90000117500 EFLAGS: 00010206
> RAX: 0000000000000118 RBX: 0000000000000000 RCX: ffff888102e98000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffffc90000117630 R08: ffffffff9032faf7 R09: 1ffffffff2065f5e
> R10: dffffc0000000000 R11: fffffbfff2065f5f R12: dffffc0000000000
> R13: 1ffff92000022ea4 R14: 00000000000008c0 R15: ffff88816b068818
> FS:  0000000000000000(0000) GS:ffff88818dc23000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb0fefe8158 CR3: 0000000113c9a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  macvlan_port_destroy+0x2eb/0x310 drivers/net/macvlan.c:1343
>  unregister_netdevice_many_notify+0x1ad2/0x2150 net/core/dev.c:12464
>  unregister_netdevice_many net/core/dev.c:12506 [inline]
>  default_device_exit_batch+0x961/0x9e0 net/core/dev.c:13098
>  ops_exit_list net/core/net_namespace.c:205 [inline]
>  ops_undo_list+0x4b4/0x8d0 net/core/net_namespace.c:252
>  cleanup_net+0x572/0x810 net/core/net_namespace.c:702
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:macvlan_passthru drivers/net/macvlan.c:78 [inline]
> RIP: 0010:macvlan_port_release_mac+0x138/0x490 drivers/net/macvlan.c:807
> Code: 01 00 00 48 89 d8 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 b9 3=
0 ae fb 48 8b 1b 4c 8d b3 c0 08 00 00 4c 89 f0 48 c1 e8 03 <42> 0f b6 04 20=
 84 c0 0f 85 44 02 00 00 45 8b 36 44 89 f6 83 e6 01
> RSP: 0018:ffffc90000117500 EFLAGS: 00010206
> RAX: 0000000000000118 RBX: 0000000000000000 RCX: ffff888102e98000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffffc90000117630 R08: ffffffff9032faf7 R09: 1ffffffff2065f5e
> R10: dffffc0000000000 R11: fffffbfff2065f5f R12: dffffc0000000000
> R13: 1ffff92000022ea4 R14: 00000000000008c0 R15: ffff88816b068818
> FS:  0000000000000000(0000) GS:ffff88818dc23000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b33163fff CR3: 0000000175a06000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   01 00                   add    %eax,(%rax)
>    2:   00 48 89                add    %cl,-0x77(%rax)
>    5:   d8 48 c1                fmuls  -0x3f(%rax)
>    8:   e8 03 42 80 3c          call   0x3c804210
>    d:   20 00                   and    %al,(%rax)
>    f:   74 08                   je     0x19
>   11:   48 89 df                mov    %rbx,%rdi
>   14:   e8 b9 30 ae fb          call   0xfbae30d2
>   19:   48 8b 1b                mov    (%rbx),%rbx
>   1c:   4c 8d b3 c0 08 00 00    lea    0x8c0(%rbx),%r14
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 0f b6 04 20          movzbl (%rax,%r12,1),%eax <-- trapping in=
struction
>   2f:   84 c0                   test   %al,%al
>   31:   0f 85 44 02 00 00       jne    0x27b
>   37:   45 8b 36                mov    (%r14),%r14d
>   3a:   44 89 f6                mov    %r14d,%esi
>   3d:   83 e6 01                and    $0x1,%esi
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
> [andrew@lunn.ch davem@davemloft.net edumazet@google.com horms@kernel.org =
kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@=
redhat.com t.martitz@fritz.com]
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
-upstream-moderation/6a50bb37.57639fcc.86d58.0025.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
