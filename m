Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D3013AA2F
	for <syzbot@lists.linux.dev>; Wed,  7 Jan 2026 07:28:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767770901; cv=none; b=N4HEf9NWznBhFu1uj7sNFXSTiqOiHBJg8cts0e72VN0ZweFWMH4PH2ypod+XSUr9hBeCBP1R5VQJWNOnhD6qG1OTWl0mG57IePmMc1bLClfdc1MnPPrxZpK3kGNFKDpQM1iBEbdZSBNYlOmKaiypd5NSlJ9tbCkW8B8VX1GqwMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767770901; c=relaxed/simple;
	bh=CG59224NM17IzSr2XPQmuFiuaxmHBChsks/Q8eRG1SA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kC+w9T+d9EO3YTWe5vIa/AkiaYh4eYwtYlJvX8i7rsKmLlC8c947LR70Y5v6MIo8zs9tGtgdlPdJiVowGMV9u+Y7hGIpXv8JH0NFTUjfz+hp6aZThRhxzfR728IOl53ac2xSKLSYrKufMXCrNM1cWEk/Hieogb3pTJXZ4IiXa4M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=kkGlPegv; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="kkGlPegv"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-3e80c483a13so1197503fac.2
        for <syzbot@lists.linux.dev>; Tue, 06 Jan 2026 23:28:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767770899; x=1768375699; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HigkYAT1Hc3ebmwrsSuJ3N8uKBj5K0ebLKoRZz4/+o0=;
        b=kkGlPegvxpbx7JG1WNWAzG0xZvn6BU8wEQMMdXMCjrdUXjQh6zBbtQagXa3JfHxjxS
         ObvsIXRmBYSe51hlpX629s40MPZUoB3eiMhC/0RjDycUn6dQ5xRsE6DiO1QuDaHqVdNe
         FFHZAL7X0Q6EueOPAJsaBX8XQsYfiVzj65jLrauZAo9YaW5FG7yxZo9xvA1TLxA2dinh
         KAU4USyiTwHOj4A2oG2OTUtxQzpIFxYVPWyDlNMF72KtjxP/v5vCWBojU+r3k6mnXmoc
         0Ng49ctpgraRznQYWNcOB+XzcL6aZK5C8ITkSS4bQ6ulfOOtsmqxvEfvMLIR49jOKCSi
         XOOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767770899; x=1768375699;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HigkYAT1Hc3ebmwrsSuJ3N8uKBj5K0ebLKoRZz4/+o0=;
        b=IhMmSqbrqJ5mGl7Zs0zTkHcO9Doeg3YG215gZekhoPKpiEDNnXR4YuMgQ5a9hoIrjQ
         unloKpGKC7PHoem8y59vMEF0dt+qmF5ao2Pd2/bZ1Gtvk5z72Xg/iOQeiJXBK0hP1EDP
         EC2JmwlgrwKkKUTD47Y5xyhnWBpr+a4mQUCUaQA7HfT+qJ1a098k+n664k5RSqXX1hji
         vAQzvtAV2uPxErKnlyGmqd7oJ2i1mH27f8k6lIIZcxyufpMNtCPtCmUCKgrHu9RciSUo
         UWnH9Jlzb2x6/i6ruWDUR5Vta10vbLV4Vvq0YOy3a3m9Lh2/bK4xCAXWjvw3RRcJsiml
         F50g==
X-Forwarded-Encrypted: i=1; AJvYcCWmxm5Q/av6CtNF9Ld9R1weFmp5j6RQNfLdqqXXQkpviNQbomv++98eKYADq/8ypMSS4DgWD6s=@lists.linux.dev
X-Gm-Message-State: AOJu0YwVB7gIExoBnKpfpNZM7t71pPlabappxUTIQfX7ulPEV27bHpwH
	PAympmHcHhTyoFx54LYG9XpfSPjPUS7jP3Vp27nD9QxGJhRP9qmCGSEbmA/IuznBYVZ3//QQ4Gh
	xSfgJlFD2QcGCA2lIQEkjGU0LO4yCCBbK5qaVtP5B
X-Gm-Gg: AY/fxX6FSqjt0Jznq8qFI+OJdZs7ktjMrlsxQEuL4NaHRFZULDApDywosATS4KwfJIp
	JcyYAVfFYYo45rNxO0SjMevGISWxc3AULOg/8zAz9mnlgP5oXEkIKPIru3YpK6y5mMz2MoShBtJ
	1gj1r6zmHXP8ojlQMhLrDhLuRd3Sqj4d+YFioy1sr1doJjjmbs2dYXZmGfek+64pcwUOsiM70F1
	nlMgqBa4jiaz/+w7ke74Z9TIArI2eHgwalWlvSnfeUp7oYJk+CsVzOkjE0ZuKQxp6xtr9Gs35Nw
	r+uNvBbcVecaa3MOzvsp5tJzYwsdSWq82LUgJchq227nT5r0Bx+vVGoR1A==
X-Google-Smtp-Source: AGHT+IE7U3FZ4TyXD2unMJQCUpK7ClLbUhUrnq8Qp1f2xQdsKH8ryvkrqgKKyk3NRmGdeX7zzlpDQlGAHEYjhOEZTbw=
X-Received: by 2002:a05:6820:510d:b0:65d:757:3a02 with SMTP id
 006d021491bc7-65f54f75216mr475510eaf.60.1767770898609; Tue, 06 Jan 2026
 23:28:18 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <695d7c00.050a0220.1c677c.034f.GAE@google.com>
In-Reply-To: <695d7c00.050a0220.1c677c.034f.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 7 Jan 2026 08:28:07 +0100
X-Gm-Features: AQt7F2o4RYaWSym6cPoQfqHumqDr3b1ileCmycWzpc3oIY3Yo2twdnE8m_k64HY
Message-ID: <CANp29Y7npNfAHi6BmJUaQ_CxW9c+mQ3BDnFa5RCDC-tv7mPp4A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: update netdev_lock_{type,name}
To: syzbot ci <syzbot+cifa565efaba482a20@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Jan 6, 2026 at 10:17=E2=80=AFPM syzbot ci
<syzbot+cifa565efaba482a20@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: update netdev_lock_{type,name}
> https://lore.kernel.org/all/20260106164338.1738035-1-edumazet@google.com
> * [PATCH net] net: update netdev_lock_{type,name}
>
> and found the following issue:
> WARNING in netdev_init_one_queue
>
> Full report is available here:
> https://ci.syzbot.org/series/68d4719e-5ae3-402a-a73d-99450d0774b4
>
> ***
>
> WARNING in netdev_init_one_queue
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      1806d210e5a8f431ad4711766ae4a333d407d972
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~e=
xp1~20251202083504.46), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/1c4d3398-ae52-417f-943e-84be818a0=
7a6/config
>
> ------------[ cut here ]------------
> netdev_lock_pos() could not find dev_type=3D824
> WARNING: net/core/dev.c:527 at netdev_init_one_queue+0x1c5/0x440, CPU#1: =
syz-executor/6079
> Modules linked in:
> CPU: 1 UID: 0 PID: 6079 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:netdev_init_one_queue+0x1c7/0x440
> Code: bf 3f 00 00 00 e8 b9 14 74 f8 66 41 83 ff 3e 0f 87 59 01 00 00 e8 0=
9 11 74 f8 eb 19 e8 02 11 74 f8 48 8d 3d 3b 32 82 06 89 ee <67> 48 0f b9 3a=
 41 bf 3e 00 00 00 4e 8d 24 fd e0 1f 90 8c 4c 89 e0
> RSP: 0018:ffffc90005487020 EFLAGS: 00010293
> RAX: ffffffff894e61fe RBX: ffff88816c381000 RCX: ffff8881047257c0
> RDX: 0000000000000000 RSI: 0000000000000338 RDI: ffffffff8fd09440
> RBP: 0000000000000338 R08: 0000000000000003 R09: 0000000000000000
> R10: 0000000000000010 R11: ffffffff81ae36b0 R12: 000000000000fffe
> R13: dffffc0000000000 R14: 000000000000003e R15: ffffffff8c9022d8
> FS:  0000555586066500(0000) GS:ffff8882a9a0f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555586079888 CR3: 000000011929a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  alloc_netdev_mqs+0x937/0x11b0
>  rtnl_create_link+0x31f/0xd70
>  rtnl_newlink_create+0x277/0xb70
>  rtnl_newlink+0x1666/0x1be0
>  rtnetlink_rcv_msg+0x7d5/0xbe0
>  netlink_rcv_skb+0x232/0x4b0
>  netlink_unicast+0x80f/0x9b0
>  netlink_sendmsg+0x813/0xb40
>  __sock_sendmsg+0x21c/0x270
>  __sys_sendto+0x3c0/0x550
>  __x64_sys_sendto+0xde/0x100
>  do_syscall_64+0xe2/0xf80
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fcc51555ed7
> Code: 48 89 fa 4c 89 df e8 a8 56 00 00 8b 93 08 03 00 00 59 5e 48 83 f8 f=
c 74 1a 5b c3 0f 1f 84 00 00 00 00 00 48 8b 44 24 10 0f 05 <5b> c3 0f 1f 80=
 00 00 00 00 83 e2 39 83 fa 08 75 de e8 23 ff ff ff
> RSP: 002b:00007ffe07b19fa0 EFLAGS: 00000202 ORIG_RAX: 000000000000002c
> RAX: ffffffffffffffda RBX: 0000555586066500 RCX: 00007fcc51555ed7
> RDX: 000000000000004c RSI: 00007fcc52334670 RDI: 0000000000000003
> RBP: 0000000000000001 R08: 00007ffe07b1a004 R09: 000000000000000c
> R10: 0000000000000000 R11: 0000000000000202 R12: 0000000000000003
> R13: 0000000000000000 R14: 00007fcc52334670 R15: 0000000000000000
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
> [davem@davemloft.net edumazet@google.com eric.dumazet@gmail.com horms@ker=
nel.org kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com]
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
-upstream-moderation/695d7c00.050a0220.1c677c.034f.GAE%40google.com.
