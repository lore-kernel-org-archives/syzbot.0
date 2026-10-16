Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80335471268
	for <syzbot@lists.linux.dev>; Fri, 16 Oct 2026 16:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792168387; cv=pass; b=USq2NDsRQJqGM/bFJikKHntptjzTHmx+NH9boy6HtwnN3Dqe6UOJLMMIgQFiKB75Okt/p6xaNyRsBSQZGyZOSS7Asm+niX6VzFFRBCdjhGM5r1HV6a44L5Rn4NC+Bru93zFH9ucGhxhZLT/mEomMngo+P2l2BPFSrQmmORZ3f3g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792168387; c=relaxed/simple;
	bh=C0PoE+6scu2Kq0dWUh+N8h1zf7XxCaEbBTEZa535W+g=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pnpPAEpuFPMpDj4UsCCsTlU2ygDHzXtvuPfSZr53A3IpLkXbtHxyx4fHPzRY/x2V44Fe8njjFIw0a9nZDiFOFCmg0iHEMijQbpzbwq+IBE3Q5jvMS5vLJAGsJAHRLS4Ocfqn84TtRJ2nkLfDIJVZ64KIXpoZm3Dj+yK0vz9yRpc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XXUZVNQq; arc=pass smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XXUZVNQq"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-5326cdde017so58797b6e.2
        for <syzbot@lists.linux.dev>; Fri, 16 Oct 2026 09:33:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1792168384; cv=none;
        d=google.com; s=arc-20260327;
        b=NuSdhc2W0FVfKmJYNrozJ94UyeJ61JcXfUrW8pu4V1Bd22UNrOZhQsK9f+l6W6i99p
         fdpVpLiPyY9K8N76fb0erm7bhgX8cPrQItBM0gQ2RNtpC+sodP26ovn9Zp2Ly82R3JSU
         k5tnx/fYrDXmsKLUrZdnGmVylWWDCBceupb3rY66wemh+k3GyHx3w2jLxqEJLbN3/F8s
         1nPqQmus1HDwigsFaPP5Z+8uH7u0pFZXNis6TES7o8H3sEfg1famE0acvzsYAAul280p
         /hYuUhSc4slIwqzFP7Gl3sU+XZB0ZJ9aM2sj5Bia94zmmPmR/NUgBPZYT7EU4lnYgDS6
         YC4w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=akkv+quk/uOXGg8LikhDKSwNc3h0Hv4i72QTO7ocSk4=;
        fh=1InfalB+ruLF0Auueyoi+qzXfOJTAFwmwI0n3v/dl0Q=;
        b=S+c0k3Sb+iBYJYIcBZ94n72TcINIz1CW3NeJF84Hn4xUiSvTlbsB0o8ZdWVs5YX0x2
         /wg4a91uHl0/v9ge6i9Zs9UqcXvVQH1Gk4RZLivVoFYs744I29L1UWNKXYsT/mk2BgXp
         pzfc3+OGW18eRT3+hAuVeDIu6lG7ZmdoNxo2U1UddiLowWRLeXlEneqU0/OChU+t9VNa
         tevARIiOkK+b/9lEd0YkYDTZ2MX7T6/kcvruwGAC01dxJ9iisWHGfRcLVJFqNMZRcetT
         gnNw81sQVumtZV5Lmc8hG8eIrc0+Gz+/kGbUnYJTfA8f9m3zW60GMY0mAZdJxlmT8u/X
         yXgg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1792168384; x=1792773184; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=akkv+quk/uOXGg8LikhDKSwNc3h0Hv4i72QTO7ocSk4=;
        b=XXUZVNQq55mv7NGwG7T/yAvR1z5JDOQdD9awBSb7b+ue1jA8amoZ5bDclibkQhOwv0
         yYzKL/pNjOqStz77+Jw32kyD+tcY32n+S58BqFC/ceRArLhMQlkTE09ZUx3bsmDWc6Dm
         phKx5WeNiSzXI5N/DKktg5putt1U4izUmqkQBqZOWwunoaFMUqBBmUYuL3A0M7rGlCXd
         qvn8QX+JRwWAbf4GhgulJZmVAR0/bZTj5s7Tpf9IifOG/N/FeC5shFvNxpdGWbGK9z0r
         rQ6n46493lxAHHZQrHZeyHIiXgXWMZ7cnCqSoUWL8xJe3rGUN5aqpbjEe39i0juR3eIC
         UbcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792168384; x=1792773184;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=akkv+quk/uOXGg8LikhDKSwNc3h0Hv4i72QTO7ocSk4=;
        b=IBpyjC6hpUcPEiAShCLvSvD3osPAQU18dvhwQxQUvNKbsBoxeJs7FznrDaBocLshKk
         bkc9swhCPpOq+SPLG5dW23K9L/sJMZl/nZpyHssvaFUUGOnIq/w+LRGkpbwd9naonz4L
         87f4X34n7L+y3FlainylzQKCLo5kDYrAjwRBLAZfz7NBHgjw0H1l4RkfwDoW2P3kjcm4
         iB39xIhPaQlJCJ7aOikgBt4R5Pv8SlYJr8UGZ102iXvKqOufIxF4x5kgBlChZdZP+Ja1
         my13K1KJAYPrHIJ5b0kCvl/tJTV+cGnt7XKKDZPV/0UVDLkzDaiFvEq4uFfcAP50UrNb
         yfZQ==
X-Forwarded-Encrypted: i=1; AKwUvBw6Xi4CqFrVMeNfg/4gpamW53wqQXEpzjSOZf7XZM/jXxz3MKhrrEcNAjbc9uzE+MPK/DCjZXs=@lists.linux.dev
X-Gm-Message-State: AFq9FYLSwf7ARPZrFGPd9Otu7zGp5pu3a+ogtB779goVip2zyc3w91MX
	bRnadFX2OhZ6Qukk4WtGyW71vZ4p7qRbzO5Vy12t0Uk87oM6TTQjERCOXwdZiXwVxW4EkhqXFGF
	+wUl0mpxiTkiHjysWvHUwtVHOnC7G6df9Db+6TsaY
X-Gm-Gg: AYBFou1JjZWYKPRmV1ADnfrDzslj9xnOf+f5ynLJ5+RcDbT6Qi1+fV4Usgdotj3SGrl
	QhMKU1Sy2qnurnNvFvujYaAON2uU5XSN4KPZQA8URdqqL8ujO5L36TTAXbDp1m0J1wA83ZGx20N
	N1qfd8EenYigLtG38d1LIvlSdl86mARiy3wxQhnMqb8C6ZB9G7yIGtQaz6b1bodKSJoj8aVq3Mf
	32iK9N5xeAdJ5GCYArSwpNR8W2j9YYRr3+ZSVKwaF6zTwB6b8A1HglXZjpMAwMiGP9KMA59/TNZ
	fJxEuhxpBJi7xAO7aGLaX2uf9VvhcLk7ZfyLluQCQmMU2L5EiS1kZkVm1HiHuDy67ALkxB/rKe+
	vchi4jsMsH7Dy8f9yb2+dK0xvNCOUqBK5ykXjp/ue05eZMRlvXw3Bmc0KW1rvrE7FlE6KAM7w8h
	DYjQTszvrnpXU6DI1pX+R0flBDCw==
X-Received: by 2002:a05:6808:3a19:b0:4f4:3088:e536 with SMTP id
 5614622812f47-53ccaf299a6mr136432b6e.16.1792168381826; Fri, 16 Oct 2026
 09:33:01 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ad24ff2.7514cce4.1ece07.0154.GAE@google.com>
In-Reply-To: <6ad24ff2.7514cce4.1ece07.0154.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 16 Oct 2026 18:32:47 +0200
X-Gm-Features: AclHuK-55Qy7ONuyHyONQo9p-RV9D2dIUmUPqf1NlRrgOMaQif-_u4mms-MKmEQ
Message-ID: <CANp29Y4zQ6Rry4N0Y0a6R2RRH2hNHbK34GUoPoEUo8tKbTeLsQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: flowtable: do not hw offload flows
 in teardown state
To: syzbot ci <syzbot+cic50625cf0ba10512@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Oct 16, 2026 at 6:25=E2=80=AFPM syzbot ci
<syzbot+cic50625cf0ba10512@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] netfilter: flowtable: do not hw offload flows in teardown state
> https://lore.kernel.org/all/20261016085202.1670076-1-pablo@netfilter.org
> * [PATCH nf-next] netfilter: flowtable: do not hw offload flows in teardo=
wn state
>
> and found the following issue:
> WARNING in nf_conntrack_cleanup_net_list
>
> Full report is available here:
> https://ci.syzbot.org/series/ea5f346a-b1ba-462a-a812-0b29a292b49e
>
> ***
>
> WARNING in nf_conntrack_cleanup_net_list
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      a5e7d8e446af9803e37a3b6a4d416fb41178348f
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/90f3437c-11cd-439b-8d1a-bb938b62b=
48e/config
> AI triage: https://ci.syzbot.org/findings/e5d88a6f-a29f-44fb-8f86-ce0834d=
5aa76/triage_trajectory
>
> ------------[ cut here ]------------
> conntrack cleanup blocked for 60s
> WARNING: net/netfilter/nf_conntrack_core.c:2504 at nf_conntrack_cleanup_n=
et_list+0x21f/0x360, CPU#0: kworker/u8:0/12
> Modules linked in:
> CPU: 0 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: netns cleanup_net
> RIP: 0010:nf_conntrack_cleanup_net_list+0x21f/0x360
> Code: 4c 89 ef e8 63 bd 37 f8 4d 8b 7d 00 4d 39 ef 74 69 e8 f5 eb c6 f7 4=
5 31 e4 e9 a5 fe ff ff e8 e8 eb c6 f7 48 8d 3d 41 56 88 07 <67> 48 0f b9 3a=
 eb c0 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c da fe ff
> RSP: 0018:ffffc900001178b0 EFLAGS: 00010293
> RAX: ffffffff8a011228 RBX: dffffc0000000000 RCX: ffff888102eb8000
> RDX: 0000000000000000 RSI: ffffffffffffffc9 RDI: ffffffff91896870
> RBP: 0000000000000021 R08: ffff888116ce7c03 R09: 1ffff11022d9cf80
> R10: dffffc0000000000 R11: ffffed1022d9cf81 R12: 000000010002f152
> R13: ffffc90000117a50 R14: ffffc90000117a50 R15: 000000010002f189
> FS:  0000000000000000(0000) GS:ffff88818c4d4000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f6e7bd28ae0 CR3: 00000000132ca000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ops_undo_list+0x4b4/0x8d0
>  cleanup_net+0x572/0x810
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
-upstream-moderation/6ad24ff2.7514cce4.1ece07.0154.GAE%40google.com.
