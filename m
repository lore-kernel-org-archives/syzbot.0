Received: from mail-oi2-f33.google.com (mail-oi2-f33.google.com [74.125.231.225])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57C9938910F
	for <syzbot@lists.linux.dev>; Tue, 22 Sep 2026 04:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.225
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790052127; cv=pass; b=Va+nnCymICqc7UZWqhkPyAEjC2D+p3Kt9Y7mqa+d+vaz8NwPEJEp8QwRQAuOu9GUqqFcNFB/SixjNUwoK5Awh8AUuoQTjrtH99WK/fhaHeScTHsdazcqQEZf9ASPJTzu/poMOmnZDdOkTIz/PLV1g5Qnz2dud3G3v2cmNTamAF4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790052127; c=relaxed/simple;
	bh=r5yRIqRXBDQghQ1Jwn7+po9n5pnmq+pCTQxDMDnD4ys=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=km9NXNL5ykos32JefaYSVs3yFkkxFsq8Fb9x01l0CRPBHpM7D7K0ci6NHC3mHRpq1rZGHxzn8ttOO2EX/iBK6bh63NcWqAUj28UstwYYDpaoQpxbNf0lbtUcdGRK00Ix0X330iTUWVRjZy54I/N7KA2Nm/r8ipaelb7VMl+EZbI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UIsXtG0J; arc=pass smtp.client-ip=74.125.231.225
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UIsXtG0J"
Received: by mail-oi2-f33.google.com with SMTP id 46e09a7af769-7f4f0dd5507so1555201a34.3
        for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 21:42:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790052124; cv=none;
        d=google.com; s=arc-20260327;
        b=npp2E1u4J44qFCmiA5y/bC4GLkGjlwoParyR35z8Lv/zfG7UtIDGJsWQr0clNSllyJ
         MRo9nVwrsbwPwQ5a+pUboSXZxvFjlRl1d83TBbBKkC6BtZrhoSzK1QmAJElKugxGrnfu
         HOkhTL7A2Qjf0RxinYlcK+b7luFev3xr9Qmg07Ej5kKP0QZ0twkSiHFIQ6Upyeo6MflY
         nAO+mB4saddcBRrQlcgT8dOcPSMqYazxhmOLhGWu7nqZxCwGlbP7MRUurjeYfLN0ZaHH
         2GMBiODM1o7WN9BNiJpkyVXyPyEH9W5i4Rj2tzgzYpf8euyOmobJhKFtj27f6G+MGLnh
         8RdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ge3skCigHLIv7DD3pXec0U9VYmw7gXQhZtAqB9mUVBk=;
        fh=38XdOyDw/kOOY6KBOKvd+mriWevsMIh8cU+457G5oxw=;
        b=gdEr2lgXsV/K6vPDMW3GgQIfD0D/bR6vJfES2Q2RqgaXaILLl6FA2Hd+7erTJWHhMT
         qxsNRRLqv7FzNEIaCK9WXplQyQPfJM2H1BJnD0QvApypcmxuN/xJIlJ57vPqIQxCRiNY
         UxomQzdt6LwWoDyk856HlEygZBhuZvEKiIQoEB60CeV6BENdFY6Pwl2h2XM8/qIbZZ+v
         Yx83x7O7hNJ42+qXPmj5GfpHaQcgMtwsSdCmqhua6NH6uz0yIggqaQZWtvle+iSGEGpQ
         GcGUMVblW0gnyDFU7t3HhUvEATuDAxONi7avNJ+IHFeno4tfdueHb09kb4jncUq5oleY
         noTA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790052124; x=1790656924; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ge3skCigHLIv7DD3pXec0U9VYmw7gXQhZtAqB9mUVBk=;
        b=UIsXtG0JJwWGnMm8C3Kj1m73gezoGVYdhH/6vgD49Exs9PVB63noTwMk3yt61HRpcS
         e66E0TI+JhD5qEIfJTQdSc8Wpc1qeI7agkrGPLmYt/sO1Ynku2fS+yxHfxjhgir9HmC0
         ogEbxCK9nV4xwo/8+bKymP8/ihlwnPUiq0aHVefQNPlgYd6w/PnGAZqoSIoix2lzmZMa
         LklzrQBjNbdHOJ+FvyMLfsSGNR2Lqx+D7pQ8vxl9J29nUOi3HgOvJhAjsWF0pht67Hzg
         kKF4sw6LNDhopTOV76JJN3E5XaNtil5mx2YRdJm2aMw4oTGUB3CKR9mZk4CimUsVN1Wb
         Qfqw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790052124; x=1790656924;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ge3skCigHLIv7DD3pXec0U9VYmw7gXQhZtAqB9mUVBk=;
        b=lKLGtBQca9e5Wd7NrTBQXAINm29DYOkD+MsBlvtzmQmsWdRp/Z6jwKIff68ZH8X397
         eqqeMDeeqNCUM5bHUeteTJlHWFxncHPXpqOxu/vwh4mVTVCo85rbtmoFsIG70hMYpUgc
         cIpN42v/nB/eHyE3TJuAp/lsYOyKAVph26waWF2mwR9dJiQtA/3dlgVQtqtx9XU2Zfg1
         hdRppxTRC2RCDmoxVal2K6ULOIT1Pbjp1s83755Tk6DbBCSCSkYNZ9Qpqp++8gJK5XIG
         vFH0R/WoEueXs4ndwB58Zk9q63sfCw7uaT6vuV6K0PZvnYNA+X8oTKkDIEWCHvsz25U9
         8cMQ==
X-Forwarded-Encrypted: i=1; AKwUvBxCx4vI1iEf6uk8iIJ2N1mNw2C+BY/lBlQkQtyhjAipqr+tJCF9nnDSb5onA0f1aruZBO4POYg=@lists.linux.dev
X-Gm-Message-State: AFuF++lWt5Fc9SBQCW5gaXgsgkrnOdyXhj/EwHkMuybMN+QfFkKM7CCa
	hqrnPyDEtJ48AITaY++Idi/IE/XHtSEeKb3LZdHT/VHMCTfSnsr9zuZUByy1f3cH2ERVArk84Qc
	TZij7owrJpe1eiAC2NnUPdMcdNCsD6y2tCmFpU71g
X-Gm-Gg: AYBFou2MgMAfB+Nbr+HgIReKHCyEiU3o54PL+1bx3PUj72PhleSzbPy+oF1vaPFzV4Y
	1dt+nc6taX39LktSDzfAA4k6nj5dljdv2Bq/z36Q9g4MYGerv2WTQsDTVscdH7OuJV8+R6MroTR
	C97EFloZznk+FrRTC+kTvabCIipz/3iVTWVtbzswEUjje+mzdpR0i3XVRR4PADeMKjuPRuAj0RQ
	mTw721GJOIrEBhp6VEDYnHk+7GwDd+KdLsxeILGiPlxFwL2sbVoJzWmGYOmXAgPRbXHQ1XqPnYg
	BDgOf40n6/TZmCaZ7iQ30xLYFGeC9/t41di9HVTPVEAwrJ66aAUdE3UklpoGoqfO9tXVp4MJPUc
	6j8ZrrfhoORnkfbLqj5ekaDT1hM5FCbhkW7fcsTch4Ei90BAlTrNhCPGmlsgicZPaHRrTZw==
X-Received: by 2002:a05:6830:7007:b0:7fd:9161:fc14 with SMTP id
 46e09a7af769-80de4601893mr14868260a34.31.1790052123581; Mon, 21 Sep 2026
 21:42:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ab20620.a6af0033.177e91.001c.GAE@google.com>
In-Reply-To: <6ab20620.a6af0033.177e91.001c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 22 Sep 2026 00:41:52 -0400
X-Gm-Features: AcwNN1WWRj1vEAzJCoj0XTBRpBoZGm-2iQwAACNjZ4fa_wbNepnWnw8eq-Jazcc
Message-ID: <CANp29Y53OjjBxaCspn5DsgcmgJnmyec759f7VouNz0n7zDhxHA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: af_unix: fix u->inq_len accounting in
 manage_oob() and unix_stream_read_skb()
To: syzbot ci <syzbot+ci721d07d59efe205c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Sep 22, 2026 at 12:37=E2=80=AFAM syzbot ci
<syzbot+ci721d07d59efe205c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] af_unix: fix u->inq_len accounting in manage_oob() and unix_stream_r=
ead_skb()
> https://lore.kernel.org/all/20260919221735.3708237-1-benquike@gmail.com
> * [PATCH] af_unix: fix u->inq_len accounting in manage_oob() and unix_str=
eam_read_skb()
>
> and found the following issue:
> kernel BUG in unix_stream_read_skb
>
> Full report is available here:
> https://ci.syzbot.org/series/0ffad94e-8c51-41d9-b85f-9793ff3deaf5
>
> ***
>
> kernel BUG in unix_stream_read_skb
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      b5a051f6b840d48f159166ef073d3021989bfb50
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/127895ae-9f2e-46db-a972-bc6f97544=
8e6/config
> AI triage: https://ci.syzbot.org/findings/bd2d2895-8350-4dbd-8d54-8a669da=
ddc1b/triage_trajectory
>
> skb linear:   00000100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> skb linear:   00000110: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> skb linear:   00000120: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> ------------[ cut here ]------------
> kernel BUG at ./include/linux/skbuff.h:2847!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 16941 Comm: syz.0.3527 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:skb_pull+0x1c4/0x1d0
> Code: b2 8c f8 8b 44 24 04 89 43 70 48 c7 c7 c0 ba 22 8d 89 ee e8 9e 96 7=
c f7 48 c7 c7 00 bb 22 8d 48 89 de 31 d2 e8 7d 00 ff ff 90 <0f> 0b 66 2e 0f=
 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc9000629f758 EFLAGS: 00010282
> RAX: ffffffff89aa3aaa RBX: ffff888107756780 RCX: 0000000000080000
> RDX: ffffc90021fe7000 RSI: 000000000000b6ec RDI: 000000000000b6ed
> RBP: 0000000000001000 R08: ffff88823c624713 R09: 1ffff110478c48e2
> R10: dffffc0000000000 R11: ffffed10478c48e3 R12: 0000000000008000
> R13: dffffc0000000000 R14: 1ffff11020eeacfe R15: 0000000000007ec0
> FS:  00007f4d8a7ef6c0(0000) GS:ffff8882a8cce000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000c4000 CR3: 000000002253a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  unix_stream_read_skb+0x34a/0x500
>  sk_psock_verdict_data_ready+0x25f/0x690
>  unix_stream_sendmsg+0x84e/0xde0
>  sock_sendmsg_nosec+0x13a/0x180
>  ____sys_sendmsg+0x54e/0x850
>  ___sys_sendmsg+0x2a5/0x360
>  __x64_sys_sendmsg+0x1b1/0x290
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4d8999e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f4d8a7ef028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f4d89c26180 RCX: 00007f4d8999e159
> RDX: 0000000000000000 RSI: 0000200000000500 RDI: 0000000000000005
> RBP: 00007f4d89a3506b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4d89c26218 R14: 00007f4d89c26180 R15: 00007ffd1de3bf98
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:skb_pull+0x1c4/0x1d0
> Code: b2 8c f8 8b 44 24 04 89 43 70 48 c7 c7 c0 ba 22 8d 89 ee e8 9e 96 7=
c f7 48 c7 c7 00 bb 22 8d 48 89 de 31 d2 e8 7d 00 ff ff 90 <0f> 0b 66 2e 0f=
 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc9000629f758 EFLAGS: 00010282
> RAX: ffffffff89aa3aaa RBX: ffff888107756780 RCX: 0000000000080000
> RDX: ffffc90021fe7000 RSI: 000000000000b6ec RDI: 000000000000b6ed
> RBP: 0000000000001000 R08: ffff88823c624713 R09: 1ffff110478c48e2
> R10: dffffc0000000000 R11: ffffed10478c48e3 R12: 0000000000008000
> R13: dffffc0000000000 R14: 1ffff11020eeacfe R15: 0000000000007ec0
> FS:  00007f4d8a7ef6c0(0000) GS:ffff88818d6ce000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fda6ffeb840 CR3: 000000002253a000 CR4: 00000000000006f0
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
> [benquike@gmail.com davem@davemloft.net edumazet@google.com horms@kernel.=
org kuba@kernel.org kuniyu@google.com linux-kernel@vger.kernel.org netdev@v=
ger.kernel.org pabeni@redhat.com]
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
-upstream-moderation/6ab20620.a6af0033.177e91.001c.GAE%40google.com.
