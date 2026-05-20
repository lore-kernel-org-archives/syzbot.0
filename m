Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E758733B6D9
	for <syzbot@lists.linux.dev>; Wed, 20 May 2026 06:21:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779258121; cv=pass; b=n3+7+kNgIJpLzUiL5lWcrwckzhiYQ2haEK+ce8f8a5h4U11SsjCWBeAVx2gNEcd8k+brbfZ0ZNl5bZqgv4G3U6wzsoNsh2Ckil7gTBF9Nu4pIsVuq+F3w3DFAvhQtemmFr0pe3c6YnFrMAQxyVFW6pjGizpTks8FvA9E+Zqh/vU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779258121; c=relaxed/simple;
	bh=aPDY2TMzuPZgxJgS8q6czqJ5EhVnWW0RVB/Jg/i9noQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Q6vU26eGktbf9oobvIHzFN+fSg+65jqxEc5BI81njqdu+tlTRvPo2uiIvPAFgmqw34SCHDC2BDQjfv47dWza0ATxUHdpI/tjvgBgEG8nEDnFxtQeAkPExjpTDotNMWKEZuJzFieV7HkwuEwDTKdcICru5QSi+CXv2/JjwpOplRg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kS0iKSok; arc=pass smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kS0iKSok"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7dca4debedaso4721415a34.2
        for <syzbot@lists.linux.dev>; Tue, 19 May 2026 23:21:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779258119; cv=none;
        d=google.com; s=arc-20240605;
        b=RFA9ifIQRU9rCWHv4h+QftV8PlqKmg4QJexX/cQwEh+XhJGc7nzcdt8Qasyo6oTmVp
         4XUhEyf1XB2axP0ZJ9c/MBmrcAu89aQunr3YufcuxKDgGV5oiUGulCtNt2YPBowqoe0m
         nhUAjLwW4BfDDRZpTtUSG3HV89gdtaRjBzminWg5MQfSUVkQIxcBxtyv+x1Dm9Ps+t8G
         1iB2f4yTT476G2zoWjilDqV7QRvdN0Z4mv6taP6Eo2fARxlMbw41Rxz0TJ/ufhRiNHEN
         uaeBKBkjy1Oe2v3An9ZVUI27+n2lJgMOCvZl2mpZh4Mywz6iWJuwiQP8wfkASmuwOz7+
         PzzQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cx11HQ+pQt3Qta7p+kr5Fbmc+x3d/I7yqUIVpLrIZOo=;
        fh=fEE0H95Xly/0924U/Ap1SRQY8wp1OfZCt6ykiudypeE=;
        b=iw9eA7slQ9ZDEKdSaCoF7KHU4bJlaF0DlcnbVw9of77TEcv9pAMlG7muPN7BV+uGKr
         7L4FCVb0rmiX3xCiUxaqKsvk1PRkJDZwD2obBpk/kmXlvfp3xjXP83K1zK4E8gNPKCla
         zz83qRhpJxqtGU5TV6izjri4Sy2lEpynmb5/RqujUZPxQXMPehzvWJoM385fTpvJ1CMo
         mo/7G6jsY4E3I3lq9Gfwv7nJ0MFVVmOzkoAScGzbEqky/tL/hOY7sNL5BJBtkWk/IApi
         X5BSKjD8W2+Np1+kNFtXxP6sovmRBrsCUwja0rjz3NmbUHDvZL/8yQvzLXQtDCgKYG9r
         TJwg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779258119; x=1779862919; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cx11HQ+pQt3Qta7p+kr5Fbmc+x3d/I7yqUIVpLrIZOo=;
        b=kS0iKSok/x5K7yzjoHTAT+5im/btTQG/ma3CPEJyDTwune5KDYbLuzmvWVMN9wgX1y
         YWQSI5jtmjnDwyBSDPgLlrQAC9/VeLEie01dFp28rIS2xbeO3QoKKsxzBLdsc3TFTI51
         Fg+G7xV0dbP9GpdwGeykgSLgZfKcqLEDRkRPIXY71bEgv7tgBc6oZSTJsH4ZAqg0cVCg
         N5E8QZRT1x5lDJwyWby6oY2ywrhqWiPCIGWppbRPRdR2NRNx7dH1Aon0dA+5/20Cef57
         42xgXlMsWKnXWRuVCTjkbUlJBsdjAoSBhneR+1UmGvBw5Bvpwv9TJOScGC3MU/acDH6j
         x4Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779258119; x=1779862919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cx11HQ+pQt3Qta7p+kr5Fbmc+x3d/I7yqUIVpLrIZOo=;
        b=Sw9ZQ6dA3gVWcPY2PH0iwQnBFeoXOgAAt7+KaIN1oMOmO1m6f6ik2Jk/UZDggI2BCB
         gd1CU0cdJYACdHi1d1ZWS8tkpIG3I+VmWUqwJkKSthJflGKUrZlNrvL6w4zU6h2fEXVA
         oZJ4pc5mRINrosD1Rc/uHg2w3yrlKiWLA11Ec5PizK9zPKRZx3WX+StcXV53MKC4G6aG
         QgI413PFQkn2GkIeKcKPabLgwUe6axIXppmBY4X6QK1CXiAQBWnqL+kU7ccuO8LfATP8
         DyMnD6asur2h2/EPGNAchzss1CiVGcIFkcqFlrn0MUAMzEoOLlX1kj1d75Go1j+SJudq
         Wlwg==
X-Forwarded-Encrypted: i=1; AFNElJ+jnS4IYO0gt5WuV8cPj6HeEU/ftetoztvBs+PIwFf5OBW2f1/bmM/s03H4ioaSlDv1Z9jF0jo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyqNulveVemfFtOgRCXGVWijI2XyWOibr8tf2oxXal+tX6oq0BD
	vjkT/fJyyvUdR1Mcvc0ZwtSM9z/1MXWowC0UL60wut6gt9ttbsndizXeg/vLPG4Nnmk6ww8DN33
	dP+nbbiDmmd4govmdJcf4B426Ogfhnc3Lc8NPlHwF
X-Gm-Gg: Acq92OFfGCXOZJ4tWVVIzqLULoG3jUUYlbi0CSdDkXORo2Ts0zENwPe0ZFkEIpnCvBT
	piJJhq2i6XrVqzWHJrInLSlTfoQce2GHKtcqMzhJt8rJWLNOUXy0Ccnh/46EPFfK6xM+AxekezI
	jqsP1ha4zr4/VFsC/kAuMBmZYZv1E3Xcb5GVmYgGMTGyDMiG145lBtM6wAoBvsUv/rm3rwIBGXw
	NsokswhAskWWgHo/aBaAqb3WR8DOESfLr5SdalzwqliNz3e6pDeNtXKBEAqPn3AtQq4c/jPILtA
	d4Yw9bGbbHbsuPeDM/rTN9m/+Lj7wbQAoduFp5JF6nLSaXgqy365yfOxOXr2fRlZ8ar9AR0GBqm
	uiTZgSjg=
X-Received: by 2002:a05:6820:221e:b0:69b:8c27:8a2 with SMTP id
 006d021491bc7-69c93fa617dmr13279660eaf.0.1779258118240; Tue, 19 May 2026
 23:21:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a0d22ee.170a0220.39a13.0008.GAE@google.com>
In-Reply-To: <6a0d22ee.170a0220.39a13.0008.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 20 May 2026 08:21:45 +0200
X-Gm-Features: AVHnY4Lf4RJTm5F0B828Y9NvuPEcGC4MbVQy9NFVwIu9zNl5wUAIqPZRxcFSBCU
Message-ID: <CANp29Y4BwGh08X80XphPdwAjT=jw0eZSUFV1EmywjTJLipe4xg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: nfnetlink_cthelper: use
 {READ,WRITE}_ONCE for accessing helper flags
To: syzbot ci <syzbot+cidb58587e522e2f70@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, May 20, 2026 at 4:56=E2=80=AFAM syzbot ci
<syzbot+cidb58587e522e2f70@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for accessing h=
elper flags
> https://lore.kernel.org/all/20260519213826.1181661-1-pablo@netfilter.org
> * [PATCH nf 1/7] netfilter: nfnetlink_cthelper: use {READ,WRITE}_ONCE for=
 accessing helper flags
> * [PATCH nf 2/7] netfilter: conntrack: add dead flag to helpers
> * [PATCH nf 3/7] netfilter: nf_conntrack_helper: add null check in nfct_h=
elp_data() calls
> * [PATCH nf 4/7] netfilter: conntrack: add null check in nfct_help() call=
s
> * [PATCH nf 5/7] netfilter: conntrack: add nf_ct_iterate_destroy_net()
> * [PATCH nf 6/7] netfilter: nf_conntrack_timeout: use nf_ct_iterate_destr=
oy() to cleanup timeout going away
> * [PATCH nf 7/7] netfilter: xt_CT: fix race with rule removal and nfnetli=
nk_queue
>
> and found the following issue:
> WARNING in xt_ct_tg_check
>
> Full report is available here:
> https://ci.syzbot.org/series/c356956d-b1f6-4d7e-be26-6cf68d49814e
>
> ***
>
> WARNING in xt_ct_tg_check
>
> tree:      nf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf.git
> base:      2beba18b0160446463bf1dbd749324846db98493
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/45c49e4e-439a-4d11-bc9a-3c3a5077f=
679/config
> syz repro: https://ci.syzbot.org/findings/9cfb9381-576b-4a17-a156-6864141=
0fec2/syz_repro
>
> No such timeout policy "syz1"
> ------------[ cut here ]------------
> help
> WARNING: net/netfilter/xt_CT.c:226 at xt_ct_tg_check+0x814/0xa90 net/netf=
ilter/xt_CT.c:226, CPU#1: syz.0.17/5870
> Modules linked in:
> CPU: 1 UID: 0 PID: 5870 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:xt_ct_tg_check+0x814/0xa90 net/netfilter/xt_CT.c:226
> Code: c7 c7 c0 a7 e6 8c e8 eb 33 3e f7 e9 12 ff ff ff e8 01 4b dc f7 48 c=
7 c7 40 a8 e6 8c 4c 89 ee e8 d2 33 3e f7 e9 f9 fe ff ff 90 <0f> 0b 90 4c 89=
 e0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 e7 e8 73
> RSP: 0018:ffffc900036ef6e0 EFLAGS: 00010282
> RAX: ffff88812063bd10 RBX: 1ffff920006ddee4 RCX: 0000000000000010
> RDX: ffff88812063bd00 RSI: 0000000000000002 RDI: 0000000000000002
> RBP: ffffc900036ef7b0 R08: ffffffff90316c23 R09: 1ffffffff2062d84
> R10: dffffc0000000000 R11: fffffbfff2062d85 R12: ffff88812063bd10
> R13: 00000000fffffffe R14: ffff888113ee1800 R15: dffffc0000000000
> FS:  00007fd41ea436c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd41da72780 CR3: 0000000175cc8000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  xt_checkentry_target net/netfilter/x_tables.c:1115 [inline]
>  xt_check_target+0x61a/0xca0 net/netfilter/x_tables.c:1138
>  check_target net/ipv4/netfilter/ip_tables.c:510 [inline]
>  find_check_entry net/ipv4/netfilter/ip_tables.c:552 [inline]
>  translate_table+0x1881/0x2110 net/ipv4/netfilter/ip_tables.c:716
>  do_replace net/ipv4/netfilter/ip_tables.c:1137 [inline]
>  do_ipt_set_ctl+0x9f5/0xe00 net/ipv4/netfilter/ip_tables.c:1635
>  nf_setsockopt+0x26f/0x290 net/netfilter/nf_sockopt.c:101
>  do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2381
>  __sys_setsockopt net/socket.c:2406 [inline]
>  __do_sys_setsockopt net/socket.c:2412 [inline]
>  __se_sys_setsockopt net/socket.c:2409 [inline]
>  __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2409
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd41db9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fd41ea43028 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 00007fd41de15fa0 RCX: 00007fd41db9ce59
> RDX: 0000000000000040 RSI: 8001000000000000 RDI: 0000000000000003
> RBP: 00007fd41dc32d6f R08: 00000000000002a8 R09: 0000000000000000
> R10: 0000200000001500 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd41de16038 R14: 00007fd41de15fa0 R15: 00007ffdb7f510f8
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
-upstream-moderation/6a0d22ee.170a0220.39a13.0008.GAE%40google.com.
