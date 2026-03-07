Received: from mail-oa1-f54.google.com (mail-oa1-f54.google.com [209.85.160.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D8F3064AE
	for <syzbot@lists.linux.dev>; Sat,  7 Mar 2026 18:57:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.54
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772909870; cv=pass; b=ZzQWCEdqBF3v0DcmXpIuQbICtlKqA98wAJ3e4iItOX3rsyPtmEhxAxnUGdL3GgCeObWJxUfLios+RCzBotptgSXceRuVtJYsboRHArptONy2PRFKVn6vBwZ0FipmiEla/SNpVNVupy1isrA7sRYsJ8Zh8PbnZ6P+9dItMtk/Oj0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772909870; c=relaxed/simple;
	bh=i8Q8uWOTw4Trs+L5hlUOrVJio2S8yYaZphmxBpzprk8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LXFDWV7ehLGsjnxqJ5i+VBKUEcvY7tO38Ah+H7deNbJLSNDDSQJJdOFNIiU9RalSH6qvz33eEfkAlI+bIEYiXNOsxeFYF6i2trisLkbBs6M5ntc0LhEIZOAnEJkEAAgU4HGfiYBnIOzJBexkFPSfiRgGgU8dYH76MnPfMB3aFu8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=fL9DZFlS; arc=pass smtp.client-ip=209.85.160.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="fL9DZFlS"
Received: by mail-oa1-f54.google.com with SMTP id 586e51a60fabf-414ffb4c0a0so4457807fac.2
        for <syzbot@lists.linux.dev>; Sat, 07 Mar 2026 10:57:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772909867; cv=none;
        d=google.com; s=arc-20240605;
        b=ekFVD1OYT+D29Gkgcjm7N3J8I7mgq2TVw1nvVtSta4ecHXyZRYvzgW2HSVKyS7NdbE
         Z5irORtkDzavRqqAVCNHsqJVVyXA5g1r0cN8Iwvs372GOX7+LW5GYUFu18xQ6LzfoVCY
         KNfa9sN4Ntl/vwLK1eUaDCEUh3soCFTp+n4SGyH8c3KB8o5moFzRU6Fmfz4AcuYGn7QR
         6t2wzWulkXs1Gk2aWTncJFEGPooPx0si4shBW5KL5zH6gggfM0fPhSJFUgsV9KZolKUx
         gE4LURFWxePlvshLNTMF4bMXYbQQg5XYOSUKghicTQ3JS+x98dJwj1b/I4vBieYS8dzt
         +oJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J5Ds3kn5QL2dUq6u96FHFbbhK2j5aYqZ7CE41EXMxK4=;
        fh=hbmzCmt3xDhfWpwdUv1CShyfnqIrqOyBT+xhEy4fqCE=;
        b=JdpPdHRmiuuefc5WAa82Atrf7Be1u/9WAw1tUPLk/ArM/kAhfOgmB/ok7AHewjIdUK
         TfkjIPjMVygZ52YQhGBOIi6stseIKs0UzuSHGL2lxT0lMOM2QRWeuLBVW2yvGGilSlyn
         MUG3W8h4c+XV3gAlBp59m1Y6ZDJYNUomLenlhqTbz8kuOLFX+Q65XaaK9HZFopDBCIj3
         o70VapyshdpuqnSeBUaPsBUWF+JbtLU02sgI/nHbNgqZ3toTgIIHqUwsdOk3FxsAtpOQ
         ilPfOBVfgIHOuB87jSt5CzdoIhggVJYTSFD2LiBSq+NRkrGoNTzAYqikhQZucS+TpNw9
         zLvA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772909867; x=1773514667; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5Ds3kn5QL2dUq6u96FHFbbhK2j5aYqZ7CE41EXMxK4=;
        b=fL9DZFlSavhZLsEVSiUiRXO9o+2ZyGlpS9fXEg1eR707bN3w0hPMbc58GwCp63wwBM
         TEuJ90ehYqF/ktNckPESaUKy9ebPjW8lH9jyjj8f27nId3IBmTWbbJp6XHUnL3NZKRqr
         BYvKjx2Cz5a/WeVIChfHgxG2jslGcDHT8vFTqsCoZykgjIYgQUFPz43slrSveDGlKaW8
         6UMqF3QPOtqPzYSFCQtGmq0IREk0IRTapSiOGQs5bTsMlDEkv7GG7e1+bF6IbbwsP+v7
         aKYUa75N/9cbilzG6EM+PzgJxOIKckGxLay65EABLaMBZvIzwEDOmni488Ka5rHp8a+f
         m0Ww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772909867; x=1773514667;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J5Ds3kn5QL2dUq6u96FHFbbhK2j5aYqZ7CE41EXMxK4=;
        b=wlOcTUdUf+FZDhonWQH6q7lVSFiunEmJel2WQq2nzOkKAdPkSBh2U1le9+y6onGHzL
         RceT82yF170YZDncXB6ZwM2F2/6i9ILd7vFFhFvOizjh0MeC+HcQHRB+6J9bKj7e2hsA
         2Oyo8oqgDMN7RRPaJ450/ewttCHpE2jVAKlIqg3Cq+BtaLvH6D74aLVuauReXVcLnggP
         DX/CrtyCTveGGuIfkh/oeFD4BD8FnJEW2uU1QV7NHOQlXraFV1XI/sk2eusyaoJksh2E
         iLZrb6yobQZSBxeiiUD8zXNhk9tPIOlmqlGf3Luwf5JqseBk1iiQA/lNKTK4Wur9jofS
         5fkQ==
X-Forwarded-Encrypted: i=1; AJvYcCVgUhcxKov0LPf71exXYzN66A/+9LfROECaFJ3owNGG/Rjt81QSKsAWYm8w6sjoQOVqzz7TuD8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy+CqfeJg4S9794fexMm7HV2OuGNJw7xPE1B24PxZf/TpChDdBw
	892O/USGKLLCAGlkeNnvOTwMEbnjB2/OMobEvkIoMhDHMN/H0lUbbUZUbe0UnZ4LGyEIYyX4SwD
	VRQ1JMM6Yno6ZVXu2MbMEDxqH/ghuYausS3Cipt/z
X-Gm-Gg: ATEYQzwhZmLtCE69x/ynbqxxWwuRFXQT+XKtc+fCZcBYIWGfCRB0x7xCrkHhWTc00B6
	JNaQnBKV/KlrJ6hyeTwC9pFJ3nK3NCp9zbOa+fIG7hzval0cXZW3tBvqqquBu475pxteC5uU5Ri
	3k50Y2+nhLrmv3c+qKwwxTIrA+w0AqO03jeVUZGiGAl5QONYYIHYIxYCXBDZTK9SqEKtYDjouA+
	PNvXQJbfAvgjrQvfTkms1Kcc/eY3NlumQiafTVMV2gLOQc5Wh6DWvlwmuLs1ByS4mvUuAA8nu/6
	VyIGMmD8hzIrpon5Y1S5fu2jgUugfHR96wk48s2D
X-Received: by 2002:a05:6870:180a:b0:409:9a0b:b733 with SMTP id
 586e51a60fabf-416e3e916d5mr3447021fac.10.1772909867110; Sat, 07 Mar 2026
 10:57:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69ac337b.050a0220.13f275.0057.GAE@google.com>
In-Reply-To: <69ac337b.050a0220.13f275.0057.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 7 Mar 2026 18:57:36 +0000
X-Gm-Features: AaiRm52GQjKfefu889cTAs_d06jiaTWfa0oSelOuWnQWBzBaMVVOUY1y9AwutTg
Message-ID: <CANp29Y4NyzeW5wm8dQ+itJ5M28cbGHdO0tkiN1xyxFBPH-zKOg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: macsec: Add support for VLAN filtering in
 offload mode
To: syzbot ci <syzbot+ci4ef4c4c489b62632@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Mar 7, 2026 at 2:17=E2=80=AFPM syzbot ci
<syzbot+ci4ef4c4c489b62632@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] macsec: Add support for VLAN filtering in offload mode
> https://lore.kernel.org/all/20260306151004.2862198-1-cratiu@nvidia.com
> * [PATCH net v3 1/3] nsim: Add support for VLAN filters
> * [PATCH net v3 2/3] selftests: Add macsec offload VLAN tests
> * [PATCH net v3 3/3] macsec: Support VLAN-filtering lower devices
>
> and found the following issue:
> WARNING in nsim_destroy
>
> Full report is available here:
> https://ci.syzbot.org/series/82631b62-e289-479c-90ac-235c613bbae1
>
> ***
>
> WARNING in nsim_destroy
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      b06ccbabe2506fd70b9167a644978b049150224a
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0beaf859-b4a7-4d7b-b4cf-b7e48e02f=
7a5/config
> C repro:   https://ci.syzbot.org/findings/6f1250ca-99f0-4162-b147-c373abd=
95c96/c_repro
> syz repro: https://ci.syzbot.org/findings/6f1250ca-99f0-4162-b147-c373abd=
95c96/syz_repro
>
> ------------[ cut here ]------------
> 1
> WARNING: drivers/net/netdevsim/netdev.c:1235 at nsim_destroy+0x155/0x780 =
drivers/net/netdevsim/netdev.c:1235, CPU#1: kworker/u8:3/5864
> Modules linked in:
> CPU: 1 UID: 0 PID: 5864 Comm: kworker/u8:3 Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: netns cleanup_net
> RIP: 0010:nsim_destroy+0x155/0x780 drivers/net/netdevsim/netdev.c:1235
> Code: c4 48 89 c6 48 81 e6 00 f0 00 00 31 ff e8 c3 f0 af fa 4c 89 e0 48 2=
5 00 f0 00 00 74 0c e8 d3 eb af fa eb 2e e8 cc eb af fa 90 <0f> 0b 90 41 ff=
 c4 41 0f b7 d4 be 00 10 00 00 4c 89 ff e8 74 6d 8f
> RSP: 0018:ffffc90004857628 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 1ffff110222a31b8 RCX: ffff88816f3fd700
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffffff90109377 R09: 1ffffffff202126e
> R10: dffffc0000000000 R11: fffffbfff202126f R12: 0000000000000000
> R13: ffff888111518dc0 R14: dffffc0000000000 R15: ffff888111519508
> FS:  0000000000000000(0000) GS:ffff8882a94ae000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007feb04e16038 CR3: 000000000e54a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __nsim_dev_port_del+0x14d/0x1b0 drivers/net/netdevsim/dev.c:1528
>  nsim_dev_port_del_all drivers/net/netdevsim/dev.c:1540 [inline]
>  nsim_dev_reload_destroy+0x288/0x490 drivers/net/netdevsim/dev.c:1764
>  nsim_dev_reload_down+0x8a/0xc0 drivers/net/netdevsim/dev.c:1038
>  devlink_reload+0x1d1/0x8d0 net/devlink/dev.c:461
>  devlink_pernet_pre_exit+0x1e6/0x3f0 net/devlink/core.c:507
>  ops_pre_exit_list net/core/net_namespace.c:161 [inline]
>  ops_undo_list+0x187/0x940 net/core/net_namespace.c:234
>  cleanup_net+0x56b/0x800 net/core/net_namespace.c:704
>  process_one_work kernel/workqueue.c:3275 [inline]
>  process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3358
>  worker_thread+0xa50/0xfc0 kernel/workqueue.c:3439
>  kthread+0x388/0x470 kernel/kthread.c:467
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
> [andrew@lunn.ch cratiu@nvidia.com davem@davemloft.net dtatulea@nvidia.com=
 edumazet@google.com kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.c=
om sd@queasysnail.net]
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
-upstream-moderation/69ac337b.050a0220.13f275.0057.GAE%40google.com.
