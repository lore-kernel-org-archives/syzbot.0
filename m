Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7073D31E830
	for <syzbot@lists.linux.dev>; Fri, 13 Mar 2026 08:42:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773391366; cv=pass; b=qh5bNYyuSJ6X25O/rATxXRVLSkxE8F6RtsfwnIAOO8y+xMx6NYUYc6ueW9c7/A+1sBln4GbxQTDEPrPyRyKoerz95CdaQEH9EcDYQy2UXRaIM6+JWZ6iIP4BH6BydYL/XFhm8EDKsmHntNBaxRBzgL72wj1PDUs0sNQJKBi/s7o=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773391366; c=relaxed/simple;
	bh=qn7stimUu8P6C/gd2gAi0ZpjubrKsoZPVor4MQkZ2zc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hwceDq10E4xgBBxqapwNulIoVMMDU2GzNi/R604c6K6t1zNeKIecM1xvT3wp1sbZkCNpcA212CElwg+frI7fZhca96AtsdlDUfMcvdFNcpHoXg9Barz8tRpPQM0sGH/cwS5r0p49S3ERuBPtRWp/YtgrhHFBsVinCZF6+tnVnZQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W7jVOjOr; arc=pass smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W7jVOjOr"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7d74dbfe84cso1332251a34.1
        for <syzbot@lists.linux.dev>; Fri, 13 Mar 2026 01:42:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773391364; cv=none;
        d=google.com; s=arc-20240605;
        b=DLyQPJRUvuS/Y+oNocP4qT0jJ//fpLqd+A5+g73aXK/Oz9yeh9+iLxEYG2BCPuA+Wd
         T7Sxm7L2uM8RpEgVt3f7/9yhRcxAsgHjuoH9r57gfyMlB4/tQZE6Budqaq8TcjJkDYyu
         mhG//I7PmGdQpXOaKeEpv//uAIx+mxDTt+YxUUKNHi0j/iaQhQvdDzO1owiyHMVab7nh
         5ag+1jKoIkfMsRYIQBggNY6fnxGyD8hx/jpvW1hhoLGHr0qHvXmzJ3xqJA07aloFVlGq
         U/lmMUpYB/yKzEgudXHBRTvD1fRjEdjUqbQB59rcPWr1rWrV5w++vT89Lopk2faMCIHv
         E2og==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=rvBy+JvHsLMMmlp2uXGZTW+13Ji8m40YPk8v3hvTyrY=;
        fh=BbVjUEae2+lNxTMksAA+zqnsD2904YD/sWtvUat675E=;
        b=DRAwosFrr61UNS0qJDb2jLqGoypPwROVzwB9eeZYC3Ood5j9NSLKnC1iF0cgy4P/H7
         n1sQNzQbWlBuJD5MHYgGkc3RSep4nxp8M9DNZMaXIhElyDki0Tm7bFuwwfhvrPjW5YHI
         n+zswIDMMyWXRYC45dxe2cZ3N/HTLKY0sA+doWwC8yvqNrDQxHCWxQT0q8+hdkFII7w2
         TCkRyZQzCqRj61aoLXmm+w67kJJlB2RQg73j6js8jqvs0y7sYnDtBATt6fCwKonEZs10
         Yp2ke7e9T2dqoQBsqEkXceIXxR12JGDyTKo2LHZ9m06NeMj42X7uui39jr5CsHt/6dyn
         VMEw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1773391364; x=1773996164; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=rvBy+JvHsLMMmlp2uXGZTW+13Ji8m40YPk8v3hvTyrY=;
        b=W7jVOjOrZE8PZyBPE76zi59ypLIoR4s75EtXWYZkOhfjkDiKVKEO1gRe6nahTQ0+jw
         XuMUC8afXakKyHDmU+nOsTTFmMEXj4gwEvElII7dKTOQREUDdooYGOGh8ef22EA5x568
         OiBGnHNI3FOFABMhiu7GgT+X9hvxhwPQSUQn/BJiWXTahCHGYUYnvjkrHAN/Es0leUwQ
         qstBpY8gl9ipUnnlAiCODJOlSOxDiKz6Y6sA+Lx6uE8vHmJta5+5nBv5C/W0yj/9PkA7
         6vycbDG8RsJtgrvE+qLGC3rr5/7I1AlKTgwDQf+p7mFuqDc2bwSeqZOD4TD+xwiqx2qa
         ox/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773391364; x=1773996164;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=rvBy+JvHsLMMmlp2uXGZTW+13Ji8m40YPk8v3hvTyrY=;
        b=UqNwNUyv/d8yumnUoKQ1XV4a+DQyLDOHhZXr85EvDa/NvDhhKpuZz3YMNv4+JMOG+Y
         FuOywrQ9WTi4YX8R5138OsQ0EYs6oqShNQbrDSYqhURNfJS9avPBlUaSmWVRVnkqgRcZ
         fBAF9hcKOfPwH7AWwdxXT+WApujTApy+6XqXa034KTAhG5q5BIZ7fBHuC3liey0TYj8s
         1S7EgKEE1mdvXw2l74/zSjOxqv0U/v4DNwX6fPIWHaW4/a4iir/0YTiqOP0gN02juLWv
         3/GThlRrCgP76WH/f6Fw0uqaa6uSq9F3fRcDKevp4Bb5BzelrOBZRXHc17/7PV7YM4FZ
         F9iw==
X-Forwarded-Encrypted: i=1; AJvYcCUQbtgjh4Vku0NI0Fibzb1c041+g//OR/7cmrY7oioGIsDEPZxBisfzYeboAccy4qppjR+1gQQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxSlC2mykC732wN3N1pOZfVe4FCarzOsxv7Lu6cRQ8vKFlb8tf4
	yter8DDsAc3xfeZldOKIIeiAwdjr182e+lsz9mQzPtgsjn2A59v9dggyQbs7T1gVFAoGJqOyyKR
	RqCq9Ry5S1qo4QOISQetLPl2Wr/9YiuqrLPffG/FG
X-Gm-Gg: ATEYQzwf7YRmPJdYnkSIzKPs+EUMLYL0O29qYUHXldTb4Yr9pnBQalrJM8McmXVP/hq
	hCtwIcqoNf4I48z12lRx13eqFncHOob3vn0kEutPi282X4zsXv44x4+22BAQ8qFHAuCaJllIQuY
	t2G+70YRi86eJzOLsbBmMLOxOad3/Jf1aTgV90oQCXs6kJ3Sj0SJ6tHu2pq9ehUkpz3X6vwtffF
	Fm6X0S0dKlWsQmHwbWBhojz9aHoshagcJY8KgBXlfPbnUlnqKpNQ7FMLayNvPSKANXDBEWbCFmD
	hBq1DFLQgMASeWYmoTuNwJPpc2jbZWapRlmAXjwIl7zSjPqHxF15JewG+kTwZvxovJiIpQ==
X-Received: by 2002:a05:6820:3108:b0:67b:c833:a34b with SMTP id
 006d021491bc7-67bdaa376f0mr1540174eaf.41.1773391363856; Fri, 13 Mar 2026
 01:42:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69b3113e.a00a0220.3b25d1.0001.GAE@google.com>
In-Reply-To: <69b3113e.a00a0220.3b25d1.0001.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 13 Mar 2026 08:42:32 +0000
X-Gm-Features: AaiRm50_Y3UG9GgKZy1Wnw9OGVm8IhWqK0zHdyXlyJKcC5Hl0zyf8SNRZRHA7FY
Message-ID: <CANp29Y6o5di-OFFKNY0noDHGvJOWD5TXKmHHQNOUHrrsu9qaRQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: misc chandef cleanups
To: syzbot ci <syzbot+ci2610d53654eef5fa@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Mar 12, 2026 at 8:17=E2=80=AFPM syzbot ci
<syzbot+ci2610d53654eef5fa@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] misc chandef cleanups
> https://lore.kernel.org/all/20260312045804.362974-1-lachlan.hodges@morsem=
icro.com
> * [PATCH wireless-next v3 1/3] wifi: mac80211: don't use cfg80211_chandef=
_create() for default chandef
> * [PATCH wireless-next v3 2/3] wifi: cfg80211: restrict cfg80211_chandef_=
create() to only HT-based bands
> * [PATCH wireless-next v3 3/3] wifi: cfg80211: check non-S1G width with S=
1G chandef
>
> and found the following issue:
> WARNING in cfg80211_chandef_create
>
> Full report is available here:
> https://ci.syzbot.org/series/ce6fc7d6-d8d4-4d00-a746-db78cba13e47
>
> ***
>
> WARNING in cfg80211_chandef_create
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      80234b5ab240f52fa45d201e899e207b9265ef91
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0a18d006-45de-4bb2-a6e2-2cbb788bd=
2f5/config
> C repro:   https://ci.syzbot.org/findings/c279480a-56a9-4a59-b533-0033d65=
eca62/c_repro
> syz repro: https://ci.syzbot.org/findings/c279480a-56a9-4a59-b533-0033d65=
eca62/syz_repro
>
> netlink: 8 bytes leftover after parsing attributes in process `syz.0.17'.
> ------------[ cut here ]------------
> chan->band =3D=3D NL80211_BAND_60GHZ || chan->band =3D=3D NL80211_BAND_S1=
GHZ
> WARNING: net/wireless/chan.c:35 at cfg80211_chandef_create+0x99/0x3d0 net=
/wireless/chan.c:34, CPU#1: syz.0.17/5951
> Modules linked in:
> CPU: 1 UID: 0 PID: 5951 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:cfg80211_chandef_create+0x99/0x3d0 net/wireless/chan.c:34
> Code: 8b 26 4c 89 e7 48 c7 c6 40 d6 e3 8f e8 a0 7d bd f6 49 83 fc 04 74 0=
d 41 83 fc 02 75 12 e8 0f 78 bd f6 eb 05 e8 08 78 bd f6 90 <0f> 0b 90 eb 05=
 e8 fd 77 bd f6 89 ef 48 c7 c6 60 d6 e3 8f e8 6f 7d
> RSP: 0018:ffffc900054fef78 EFLAGS: 00010293
> RAX: ffffffff8b0825a8 RBX: ffffc900054ff0e0 RCX: ffff888112b5ba80
> RDX: 0000000000000000 RSI: ffffffff8fe3d640 RDI: 0000000000000004
> RBP: 0000000000000002 R08: ffff888112b5ba80 R09: 0000000000000002
> R10: 0000000000000004 R11: 0000000000000000 R12: 0000000000000004
> R13: dffffc0000000000 R14: ffff888111c65998 R15: ffffc900054ff0e8
> FS:  000055558dcaa500(0000) GS:ffff8882a9463000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f14d1588095 CR3: 000000010668a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  _nl80211_parse_chandef+0x438/0x1160 net/wireless/nl80211.c:3616
>  __nl80211_set_channel+0x1fe/0x850 net/wireless/nl80211.c:3736
>  nl80211_set_wiphy+0x116b/0x2fa0 net/wireless/nl80211.c:-1
>  genl_family_rcv_msg_doit+0x22a/0x330 net/netlink/genetlink.c:1114
>  genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
>  genl_rcv_msg+0x61c/0x7a0 net/netlink/genetlink.c:1209
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2550
>  genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
>  netlink_unicast_kernel net/netlink/af_netlink.c:1318 [inline]
>  netlink_unicast+0x80f/0x9b0 net/netlink/af_netlink.c:1344
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1894
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg net/socket.c:742 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2592
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
>  __sys_sendmsg net/socket.c:2678 [inline]
>  __do_sys_sendmsg net/socket.c:2683 [inline]
>  __se_sys_sendmsg net/socket.c:2681 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0ea239c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe7ad20a38 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f0ea2615fa0 RCX: 00007f0ea239c799
> RDX: 0000000000000000 RSI: 0000200000000040 RDI: 0000000000000003
> RBP: 00007f0ea2432bd9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0ea2615fac R14: 00007f0ea2615fa0 R15: 00007f0ea2615fa0
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
> [arien.judge@morsemicro.com johannes@sipsolutions.net lachlan.hodges@mors=
emicro.com linux-wireless@vger.kernel.org]
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
-upstream-moderation/69b3113e.a00a0220.3b25d1.0001.GAE%40google.com.
