Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE17363C75
	for <syzbot@lists.linux.dev>; Sat, 10 Oct 2026 09:40:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791625261; cv=pass; b=NxjVx9GgBZYp8RLQXoCifbwyr2GfaM7781Nq0noxJUSoSOXHB9B07FKoKU2mp0b5SOb34rHLfqUWWSeki64AthCewQmVhenbY67NaZGb6GNpR6hxDiIqnAfTz/JxlyqJmT5my8kE0G0lERxGhFs7rcCPvLw4JFmi794cTkuGmzg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791625261; c=relaxed/simple;
	bh=rrXAGHC9PY2dFcO8qQD9q7r+fOBnbQaTmegfEdqAhcE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sbnX4LEML3lFqoCNUgfsQn3svf1HF9YTyCSAevPZ3G86/2Up+i9Hx3GET+7DUSn0Ymion9MXtHfElhtXlwQCvvKvUbSeWWT5yn0J1xw+AuhWpGIaAjiHPDMgMutOhmr1XFGqVAbPBSMa0YHSWC7rm+rZWKlMWdcDirgl6cMmeps=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=bWs/B2bs; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="bWs/B2bs"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-824329dc1ecso437870a34.1
        for <syzbot@lists.linux.dev>; Sat, 10 Oct 2026 02:40:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791625258; cv=none;
        d=google.com; s=arc-20260327;
        b=bnUmFAlP4OuZpYBER5mbacUq/+iCbkSU8VNqpETWfkKiR9xbMGNYl493H7v2oBnNT4
         QoRULtAoTw8M44IrRPlC2zdoOK0fD1rMKWNjCSM3OrrCAuTTjF5Ul3xV/CEybPfNa+m0
         VMogWzFPiauu3KNotZqCKgFiJvHsn6sxErNddCYz1W2SDAEQRQT3NdfId5jOZhXnadjB
         kU9BCBECkZ6OX5WzickVxD++Erqqwtkrn14ZCxPeyMBXv0IxsauJ1ZdaxuvfnzDjNdb5
         OZDe+L5Db5RcWeQOe5cQ0wbKfplE6w7r/FSFaRx5Bf2+XGws8rnGjIC4t5tP9421Rska
         uAAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZLdpOrQJ5ZA3nyKoM0O9aB2N+VOdkwli2CPMs3f57OI=;
        fh=g0rDdSKd0andfzd/T8y1pD6pcWlPRrObIzgGslmpnds=;
        b=Wf8xQMvBznF4lKjXWeY/uzaR+19Dl9JYYWBWWnlWaj8ky73sCMFQnQZnTEy8zQg5d5
         bDrTAU+lxGbaACDrd6S+GAsAu86rAZ9X4qQMckZwEsYHGXxxWexk6QQkJFXlwDXNPHcr
         sQ/n6oKo5mIWlbX1CNzGGZKoY/Jh3kUM+y+3MNAHIYYq+98KpEwHrMyinKqiqyINHazE
         aYt/jIQLpG7Yu8ZLWlSyWdBFRDXL9dHflWxg0tm2TO4HnlZOmBHSjHHKojQjVa1Kl7Fw
         uo8mnRWfeqy85ohBejw4/ZWICZpcRiUQJhYbxEaNyVWJtSujkf+IJ0zVTFBSGf197Ac8
         hUBw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791625258; x=1792230058; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZLdpOrQJ5ZA3nyKoM0O9aB2N+VOdkwli2CPMs3f57OI=;
        b=bWs/B2bsuFZoEZ+JDdfUK0cGhs8aarwImD8j75iGSGtH5KrAZk0NVVU+8pTJDZ9o/R
         B/6UJxtfIHm3w3szcRQKKOv7P0c+PIYVEPlqjRqMebCFqH3jizrTieqYlY4ejUxGIu/j
         XQE0Is6yh9/iuBv6v5n9/lamcS7IoZxSVjoIULsp6pgoFPIKwERMM3K+jhmyKITYHuuq
         3LYvT2t9oEcp6yPHelPtU64I6zIE1E6ez696nMtgkaHdTu8LOk5sREIa0Dp9yCeoikZ4
         9c7lCdBgS1Jas9ztODa15YzJsiRIDinpeG3uZ1/eE50nYLDF2paI+Iqr+PyCIXuWnGL1
         xfLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791625258; x=1792230058;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZLdpOrQJ5ZA3nyKoM0O9aB2N+VOdkwli2CPMs3f57OI=;
        b=VOlYnDLGFU/DBl+FksBMaTR1+nICf5daWHhHR/rL9DOvq7bIAeyG/TJqtMHQ6TVyFL
         d0l/xjfutw1iGMrxxMV4cENt6v2V2eQoAUeO9IAWRDhyitZi0OSs2eSOEcNVl6Vy7ZQx
         JCbPPGhdNOFCcmu1/ffMxfTESJ7R+8KQw+4z5Os3kCgMhxtpr0R/v65FaZPcI0+VC8eY
         /HNsXeM+8cvTAwoBJZaoTxMktoH6ZYJ6RY8CpY7w3tiWVDrZnLn4HfKUSj6XB0ucDFV5
         NxOGksMZCsUT0IHzl/mwLDcSqIdIQe7/kGMLiiVFPLgasCF88OTacZRA6FP8Z0g87eMY
         tXnQ==
X-Forwarded-Encrypted: i=1; AKwUvBx9gH1ivN2vABWXNi4mJBIgtvFMHYZfQfmkO9YlzT9a6KPJLgDkDTOaVCWduVZLyJwUGvPc89M=@lists.linux.dev
X-Gm-Message-State: AFq9FYLasPgiN6n7F4VhRJq/ddkJmqHv9dbmIonIXJuRtWTo3nd7s6cL
	DGFWapKG2DBuCaP0ExqsXFfp+uKxtOW6qShy7ANRQCuQyJAHTDHRRedXA7vkuJdjxtU8BNctfOE
	EXPdYZ15DCzRJE5cfRgs5QjrZCpYHUnabHLL/4ea9
X-Gm-Gg: AYBFou1a85LLHNYhHFTdKDmPWR0tvSTqoXknJVNRYLSmNqT6DMCKWwJBECpxjxor66d
	W5nEZtt4EaLPj8h3KyiJeaRjey55hetuLf0Wh56mWpyyEdOQq2S0PS/VTxePXCLqKryHQ0Hw5iI
	pYH9EYEihyWLjo0GcbgTSrKpgo115Mh9s3ENNbmTTTomXrHWAQ5IprDGj8fF8MUwzuIe4x1IPuN
	2V32IN2JRfnDiQpcP4LzWEvMKwRJ2LHTFyqDcG58n2itbZ/ODXsBFsafbZGRVdDwHuYkuyd/9w3
	N2nSUG02ocxsXdsVOsYTgpoCH071vC9ZMIiSOmycjOOAoBg1q/3oJtGnkhuuyPJUa8ZV/mw+ORc
	DO9zPtAXckrw80NU1iBC9C6EBJMARKG1pYA9IdZUg07gLfajWECI2rSrbuuY7MmWM/opgSvltfq
	ezq88W+qDb9KXgho4BxUBQRa+jIA==
X-Received: by 2002:a05:6830:3809:b0:816:fb18:148f with SMTP id
 46e09a7af769-8309815db46mr4266522a34.31.1791625257759; Sat, 10 Oct 2026
 02:40:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ac98dc2.70ed5d86.2ac85.008c.GAE@google.com>
In-Reply-To: <6ac98dc2.70ed5d86.2ac85.008c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 10 Oct 2026 11:40:46 +0200
X-Gm-Features: AclHuK_RS2bPAJgBy1xvJBWvYL6xJ2ZkH_Mvsh_WHBh5kiyHYDOJaj3LxjbiEUI
Message-ID: <CANp29Y5Nw1jOnohRRvcto4CJJeMAdcQxQsXqgyd3ocfrq8nFaA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Extend drm_ras for qaic telemetry
To: syzbot ci <syzbot+ci75bba038493d80b5@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Oct 10, 2026 at 2:58=E2=80=AFAM syzbot ci
<syzbot+ci75bba038493d80b5@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Extend drm_ras for qaic telemetry
> https://lore.kernel.org/all/20261009173152.2436195-1-zachary.mckevitt@oss=
.qualcomm.com
> * [PATCH 1/3] drm/drm_ras: Remove admin-perm flag from list-nodes operati=
on
> * [PATCH 2/3] drm/drm_ras: Extend DRM RAS interface to include telemetry =
nodes
> * [PATCH 3/3] accel/qaic: Add callbacks for DRM RAS netlink telemetry
>
> and found the following issue:
> general protection fault in drm_ras_nl_pre_telemetry
>
> Full report is available here:
> https://ci.syzbot.org/series/6915fb7c-08cd-48b4-b8a4-3834f3e60de5
>
> ***
>
> general protection fault in drm_ras_nl_pre_telemetry
>
> tree:      drm-next
> URL:       https://gitlab.freedesktop.org/drm/kernel.git
> base:      f2bf20011b95401f63e573d54134544c452c4117
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/d48f7944-a0fb-4983-a3c6-c037c81dd=
832/config
> syz repro: https://ci.syzbot.org/findings/c2ca90ba-3f79-4e56-94d4-b1ddc64=
056e5/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 5808 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:nla_get_u32 include/net/netlink.h:1734 [inline]
> RIP: 0010:drm_ras_nl_pre_telemetry+0x60/0xe0 drivers/gpu/drm/drm_ras.c:65=
6
> Code: 8b 1b 48 83 c3 08 48 89 d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 d=
f e8 3e 3c 9a fc 48 8b 1b 48 83 c3 04 48 89 d8 48 c1 e8 03 <42> 0f b6 04 38=
 84 c0 75 5b 8b 33 48 c7 c7 80 d3 6f 90 e8 c9 8c 49
> RSP: 0018:ffffc9000379f420 EFLAGS: 00010247
> RAX: 0000000000000000 RBX: 0000000000000004 RCX: ffff8881bf17bc00
> RDX: 0000000000000000 RSI: ffff8881bf38d380 RDI: ffffc9000379f600
> RBP: ffffc9000379f588 R08: ffffc9000379f4ff R09: 0000000000000000
> R10: ffffc9000379f4d0 R11: ffffffff859eb380 R12: ffffc9000379f600
> R13: dffffc0000000000 R14: ffff8881bf38d380 R15: dffffc0000000000
> FS:  00007f2c256e36c0(0000) GS:ffff8882a7cb6000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000100 CR3: 000000016e7ee000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  genl_family_rcv_msg_doit+0x1db/0x340 net/netlink/genetlink.c:1109
>  genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
>  genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2575
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
>  netlink_unicast_kernel net/netlink/af_netlink.c:1338 [inline]
>  netlink_unicast+0x7bd/0x940 net/netlink/af_netlink.c:1364
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1919
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
> RIP: 0033:0x7f2c2479e1d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f2c256e3028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f2c24a25fa0 RCX: 00007f2c2479e1d9
> RDX: 0000000000000000 RSI: 0000200000000100 RDI: 0000000000000004
> RBP: 00007f2c24835888 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f2c24a26038 R14: 00007f2c24a25fa0 R15: 00007ffc88247b58
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:nla_get_u32 include/net/netlink.h:1734 [inline]
> RIP: 0010:drm_ras_nl_pre_telemetry+0x60/0xe0 drivers/gpu/drm/drm_ras.c:65=
6
> Code: 8b 1b 48 83 c3 08 48 89 d8 48 c1 e8 03 42 80 3c 38 00 74 08 48 89 d=
f e8 3e 3c 9a fc 48 8b 1b 48 83 c3 04 48 89 d8 48 c1 e8 03 <42> 0f b6 04 38=
 84 c0 75 5b 8b 33 48 c7 c7 80 d3 6f 90 e8 c9 8c 49
> RSP: 0018:ffffc9000379f420 EFLAGS: 00010247
> RAX: 0000000000000000 RBX: 0000000000000004 RCX: ffff8881bf17bc00
> RDX: 0000000000000000 RSI: ffff8881bf38d380 RDI: ffffc9000379f600
> RBP: ffffc9000379f588 R08: ffffc9000379f4ff R09: 0000000000000000
> R10: ffffc9000379f4d0 R11: ffffffff859eb380 R12: ffffc9000379f600
> R13: dffffc0000000000 R14: ffff8881bf38d380 R15: dffffc0000000000
> FS:  00007f2c256e36c0(0000) GS:ffff8882a7cb6000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f2c247eb8c0 CR3: 000000016e7ee000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   8b 1b                   mov    (%rbx),%ebx
>    2:   48 83 c3 08             add    $0x8,%rbx
>    6:   48 89 d8                mov    %rbx,%rax
>    9:   48 c1 e8 03             shr    $0x3,%rax
>    d:   42 80 3c 38 00          cmpb   $0x0,(%rax,%r15,1)
>   12:   74 08                   je     0x1c
>   14:   48 89 df                mov    %rbx,%rdi
>   17:   e8 3e 3c 9a fc          call   0xfc9a3c5a
>   1c:   48 8b 1b                mov    (%rbx),%rbx
>   1f:   48 83 c3 04             add    $0x4,%rbx
>   23:   48 89 d8                mov    %rbx,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 0f b6 04 38          movzbl (%rax,%r15,1),%eax <-- trapping in=
struction
>   2f:   84 c0                   test   %al,%al
>   31:   75 5b                   jne    0x8e
>   33:   8b 33                   mov    (%rbx),%esi
>   35:   48 c7 c7 80 d3 6f 90    mov    $0xffffffff906fd380,%rdi
>   3c:   e8                      .byte 0xe8
>   3d:   c9                      leave
>   3e:   8c                      .byte 0x8c
>   3f:   49                      rex.WB
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
> [airlied@gmail.com aravind.iddamsetty@linux.intel.com carl.vanderlip@oss.=
qualcomm.com dri-devel@lists.freedesktop.org jeff.hugo@oss.qualcomm.com kar=
ol.wachowski@linux.intel.com kuba@kernel.org lizhi.hou@amd.com netdev@vger.=
kernel.org ogabbay@kernel.org raag.jadav@intel.com riana.tauro@intel.com ro=
drigo.vivi@intel.com simona.vetter@ffwll.ch troy.hanson@oss.qualcomm.com yo=
ussef.abdulrahman@oss.qualcomm.com zachary.mckevitt@oss.qualcomm.com]
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
-upstream-moderation/6ac98dc2.70ed5d86.2ac85.008c.GAE%40google.com.
