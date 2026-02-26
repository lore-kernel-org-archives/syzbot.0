Received: from mail-oo1-f54.google.com (mail-oo1-f54.google.com [209.85.161.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB0E5368940
	for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 16:58:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772125109; cv=pass; b=rL4TkV6smRezvfnBacSGehAvk3DbVfRI9MMiyp8PnKstOkns9Ss+IQwhlslqiYcJQ1qpWf4w/EYSh6c9/PCmI2dkJxzG1nrud2bnQC1GSDFPeRnK3/lKActuoaKCWx8Ot40Ka2Nv91klml2Ltjek453aD3rz9YjknG4U+3MU2uc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772125109; c=relaxed/simple;
	bh=IY5LX9lCior0VTWirKk1qhAcvDj09C104O8gyX5OB0c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=cXwc1LeYlELEVGX63CYg3vCWuCdxCQ6N8/8gu/9vixha/pefyTgucObyZW8BtTka1UKcu+xhTECMek6BGtrjnM6MaliDygIA+UV7JQKH3ffBr7r4D+Kxy6c8frdShagIvH0o4jgZ/LEX6DPnrDkuCq4dr2ozjv8DfHZ1MU6zrWw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=czYUhsEH; arc=pass smtp.client-ip=209.85.161.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="czYUhsEH"
Received: by mail-oo1-f54.google.com with SMTP id 006d021491bc7-6799774d0fcso479637eaf.3
        for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 08:58:27 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772125107; cv=none;
        d=google.com; s=arc-20240605;
        b=KsV9fITJg6/r58rBNMqRFHkVAxfmZ2M6fCp43bgO2wc5bMQFF0F7kNUaGbsw5aNEu0
         4nYHdJIiLVxymn7pBawlrtKxgtoPq1Ki014fbe0osStWAiEF+GphSWxEYVOPPYTRyJRb
         Snm22qAb7vaXswnQim0+3lgn3zrHcvalsB0WfkrpSTCGYvAag47u1lHUz6tfyFZaYEia
         DX+prOSbVG/Z910//FSR2nhQcRrsjz02zq5HzMqp+HepvIzmsTtvuGuS8/p7jN7EBuo2
         Aa9ujNiLjfidx0MDSmhQRyGTV3zkbiBDSAOgs8XWf/oOT+WHOXvpYrZboRux/ScmLVsi
         C3Ng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=97ApYlSLvMWnKzyUJIxvcPMMPrsbkC2EXNUmMoS13WY=;
        fh=YmDAKBW8ssjM48rQ+AG3IwSYO8avhn8qparGAReRwOk=;
        b=UMYalx7IBDj+88KjrZIFh/ADEmKON/hu7YLNjO2EKd+sMbFl0MlrRvUaaUzytKFexr
         wl9/g9kRgF7jSVzoIFi2FNl9WzaQPoK6PdzfGhyBdKSLn1c1qu/Q43AeX/gLSD3Hjjjy
         +FhPmQd8B+/gfyqo0yLaCFfVPE23f8ZgDkuZRCPXjovPaDt6JqkvVVGfhHGiOLnoJnzs
         AMtp3Zq1IM1d4ieIl9mycjKtbENzj26fTQIrTX3F0u9d2Z3GCFbLVLbdd8J6m6nK1Fcx
         LfuPlrpqJy4Yox+EA7M8gJlz0rQVRLgUjsoH0zCcu8TMidatHHJI6C/2saRlMkgGho2E
         JtYA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772125107; x=1772729907; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=97ApYlSLvMWnKzyUJIxvcPMMPrsbkC2EXNUmMoS13WY=;
        b=czYUhsEHCbG+Dl0/nQndXq7WH7BTmiTZruGRmr2UdGyVlJYHOhgDXn30/y0im69ITQ
         +OBkITEvrbe50C8M4MHTnaRg+8P4DMfVbwQTXLbxGgDx2BihnZ0rN0gXCzC0nk6saq+E
         kSNbWviEUo5xrtswZ2CgKujtX7AWzWsxODzx9swm4WhrQLzJ3nZ1TJBWLAr4EbNRG615
         VPmh4nQ2fEYbvfcDp94WBQKfZO9cMdOhifNvGhXBzeW6cc+iI35EVTpoe8f78ySnf5K6
         TqkImNTz5BrRdFxt+ID8RMoRtS/TNjCsjsTtoEGhho1C4s0Syfn9keKyYm/dUKUKy7LD
         FLMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772125107; x=1772729907;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=97ApYlSLvMWnKzyUJIxvcPMMPrsbkC2EXNUmMoS13WY=;
        b=sTR3bemSWd+bIgpdKRL9UprYKq2Abs/URN5n3pYliWVw/RSDqHqIWK9eePNMWtmf2C
         JqTTUy2vh3PBTOVLwezJfBILLEflKREp8Jpzk0P66IGrHwKLIn3LOF8mvww7eGG7vvxA
         +drPwJwqOI/mOB+2QyVgUmQSj3RALd/umQLkhVyaNWImxr2RX17/eANSn/kC1Ubf44f3
         PoxqK68pbY/FR4X7hoRKQi9epOnkYbsvNKuUZdSdcJsYqBGqm1WVqdDagsFHfjsqTNov
         BfWHaZUlfTKph9kmQUvrlt7dMnITQPni/O3X6xOThTCeMSaCBPhpgV+uN86WcxSB2uNI
         zX6A==
X-Forwarded-Encrypted: i=1; AJvYcCU0drkr2v1q6kCrXfkopjPsAlvlM5Zos3ijzkvumYrvCAQWC4kPKoQNW8itC+P7TbeUVTi4//Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YxfV2j6RRZgtcT6GergMcrdBDOokbyKfgdcSQ4YNF+wa29PJWT1
	89edi/1XnYi2kiTxs5Aq3GEJXsPc5Skc0qzzGxSA88jDruIBjWKjYR1obw51EOKpkXhklEW54/Z
	JmmR671UFHneQV9qBFRFUp34g4N2d49OnJByLl5zg
X-Gm-Gg: ATEYQzzkRjMw26f1MjvcbDhqrvzGJGYCC3hy0sSF9MNpXov4DB27xDNWbfIpDM5lMIr
	xBbpHLNBUvWztHdi9cZbCuMj5ccEoqpxHx8eA6J0C4ds7eKjexM2BG8I/1qupkHImwtq3ed9Dis
	l7jtJrLlbTGJ+zfeMp5bsCtwzXJPK84nVj0boDgeaoIDHLEqABwEf8aJaMCydbL+RNmLfup7n/V
	UnyAbtd3CQY2rfrP+d+C5YvKKnjIC0wwAs6WBXiaQv3R6doGQ8+8ajW9tm7Tj8VNhKkHBR4VJ1o
	E12aZ4pvs6LK2vzhfMYyhRXE1nmIAkZf7t+zVwC6V6SMC7x3vbjz9Du02wESIKfZqxLkLQ==
X-Received: by 2002:a05:6820:2228:b0:679:8a47:abab with SMTP id
 006d021491bc7-679f3dd7297mr1269927eaf.71.1772125106446; Thu, 26 Feb 2026
 08:58:26 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69a07a76.050a0220.3a55be.0005.GAE@google.com>
In-Reply-To: <69a07a76.050a0220.3a55be.0005.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 26 Feb 2026 17:58:15 +0100
X-Gm-Features: AaiRm52FyNWbB0TQm28kYOqByQuSAFoiSNwIm7gfBYJfrREig1vrCk8KZ6Otx4Q
Message-ID: <CANp29Y5rKrh3SBM8_5DCv3wsnbkBpkhEZ77unGAoDXYkDvuOwg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ipmr: No RTNL for RTNL_FAMILY_IPMR rtnetlink.
To: syzbot ci <syzbot+ci1ead13f60be6c868@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Feb 26, 2026 at 5:53=E2=80=AFPM syzbot ci
<syzbot+ci1ead13f60be6c868@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] ipmr: No RTNL for RTNL_FAMILY_IPMR rtnetlink.
> https://lore.kernel.org/all/20260226023637.1335854-1-kuniyu@google.com
> * [PATCH v1 net-next 01/15] selftest: net: Add basic functionality tests =
for ipmr.
> * [PATCH v1 net-next 02/15] ipmr: Annotate access to mrt->mroute_do_{pim,=
assert,wrvifwhole}.
> * [PATCH v1 net-next 03/15] ipmr: Convert ipmr_rtm_dumplink() to RCU.
> * [PATCH v1 net-next 04/15] ipmr: Use MAXVIFS in mroute_msgsize().
> * [PATCH v1 net-next 05/15] ipmr: Convert ipmr_rtm_getroute() to RCU.
> * [PATCH v1 net-next 06/15] ipmr: Convert ipmr_rtm_dumproute() to RCU.
> * [PATCH v1 net-next 07/15] ipmr: Move unregister_netdevice_many() out of=
 mroute_clean_tables().
> * [PATCH v1 net-next 08/15] ipmr: Move unregister_netdevice_many() out of=
 ipmr_free_table().
> * [PATCH v1 net-next 09/15] ipmr: Convert ipmr_net_exit_batch() to ->exit=
_rtnl().
> * [PATCH v1 net-next 10/15] ipmr: Remove RTNL in ipmr_rules_init() and ip=
mr_net_init().
> * [PATCH v1 net-next 11/15] ipmr: Call fib_rules_unregister() without RTN=
L.
> * [PATCH v1 net-next 12/15] ipmr: Define net->ipv4.{ipmr_notifier_ops,ipm=
r_seq} under CONFIG_IP_MROUTE.
> * [PATCH v1 net-next 13/15] ipmr/ip6mr: Convert net->ipv[46].ipmr_seq to =
atomic_t.
> * [PATCH v1 net-next 14/15] ipmr: Add dedicated mutex for mrt->{mfc_hash,=
mfc_cache_list}.
> * [PATCH v1 net-next 15/15] ipmr: Don't hold RTNL for ipmr_rtm_route().
>
> and found the following issue:
> WARNING in ipmr_free_table
>
> Full report is available here:
> https://ci.syzbot.org/series/d7068eba-72b1-4110-aeb0-d4528e03fd24
>
> ***
>
> WARNING in ipmr_free_table
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      c7f5c6fb0f2b1a44490a36582a251f0a304d6b0c
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0afa280b-14ff-4aec-8a20-7f8507025=
dd8/config
> C repro:   https://ci.syzbot.org/findings/e38687c7-5a8b-4c68-909c-a0ffdd1=
7a674/c_repro
> syz repro: https://ci.syzbot.org/findings/e38687c7-5a8b-4c68-909c-a0ffdd1=
7a674/syz_repro
>
> ------------[ cut here ]------------
> !net_initialized(net) && !list_empty(dev_kill_list)
> WARNING: net/ipv4/ipmr.c:450 at ipmr_free_table+0x150/0x180 net/ipv4/ipmr=
.c:450, CPU#1: syz.1.18/6004
> Modules linked in:
> CPU: 1 UID: 0 PID: 6004 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ipmr_free_table+0x150/0x180 net/ipv4/ipmr.c:450
> Code: 23 e8 f4 5c 95 f7 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e=
8 df 5c 95 f7 90 0f 0b 90 e9 64 ff ff ff e8 d1 5c 95 f7 90 <0f> 0b 90 eb d7=
 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 03 ff ff ff
> RSP: 0018:ffffc900037afa70 EFLAGS: 00010293
> RAX: ffffffff8a302fbf RBX: ffffc900037afb60 RCX: ffff888172a70000
> RDX: 0000000000000000 RSI: ffffffff8def033c RDI: ffffffff8c27a480
> RBP: 0000000000000001 R08: ffffffff901166b7 R09: 1ffffffff2022cd6
> R10: dffffc0000000000 R11: fffffbfff2022cd7 R12: ffff88816a392758
> R13: dffffc0000000000 R14: ffff8881b8960000 R15: ffff88816a392758
> FS:  00007f5a2d24e6c0(0000) GS:ffff8882a9469000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f7b7544e9d3 CR3: 0000000172316000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ipmr_rules_exit_rtnl net/ipv4/ipmr.c:297 [inline]
>  ipmr_net_exit_rtnl+0x156/0x1a0 net/ipv4/ipmr.c:3339
>  ops_exit_rtnl_list net/core/net_namespace.c:181 [inline]
>  ops_undo_list+0x347/0x940 net/core/net_namespace.c:248
>  setup_net+0x2f0/0x340 net/core/net_namespace.c:462
>  copy_net_ns+0x50e/0x730 net/core/net_namespace.c:581
>  create_new_namespaces+0x3e7/0x6a0 kernel/nsproxy.c:130
>  unshare_nsproxy_namespaces+0x11a/0x160 kernel/nsproxy.c:226
>  ksys_unshare+0x4f4/0x900 kernel/fork.c:3174
>  __do_sys_unshare kernel/fork.c:3245 [inline]
>  __se_sys_unshare kernel/fork.c:3243 [inline]
>  __x64_sys_unshare+0x38/0x50 kernel/fork.c:3243
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5a2c39c629
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5a2d24e028 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
> RAX: ffffffffffffffda RBX: 00007f5a2c615fa0 RCX: 00007f5a2c39c629
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 000000006a040000
> RBP: 00007f5a2c432b39 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5a2c616038 R14: 00007f5a2c615fa0 R15: 00007fffb0e41968
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
> The email will later be sent to:
> [davem@davemloft.net dsahern@kernel.org edumazet@google.com horms@kernel.=
org kuba@kernel.org kuni1840@gmail.com kuniyu@google.com netdev@vger.kernel=
.org pabeni@redhat.com]
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
-upstream-moderation/69a07a76.050a0220.3a55be.0005.GAE%40google.com.
