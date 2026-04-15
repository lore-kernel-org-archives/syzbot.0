Received: from mail-wm1-f43.google.com (mail-wm1-f43.google.com [209.85.128.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ECE5253359
	for <syzbot@lists.linux.dev>; Wed, 15 Apr 2026 12:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776256741; cv=pass; b=JrhhFQKmWV0vM0ai10jOjJs6x8NwyKik96Dni94vOAwLd8e8x2h6Og8tCCbyKBMfmTXTu0q+GL9nVLyu8iLUSRoSPWTDgbCdr4MUnHNiYivmV1h/FmigSv4tQnUGGg+RVD6igY+pOolNu6qFmc8GOcd5e02p7uf0R6AE6elTLgw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776256741; c=relaxed/simple;
	bh=n27bQpC4S/uL8se386oJg6YdDUFeLm85RH8FeVVugE8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Vh7tDjsZunKX1lu1vMlBv10uIFjOtK1O9rZvmTcFBeh02iPL1d45etKHAt36SPUIG2Yd8V36kNHlpdm9nfmjdDHDddhgzE4qR8ToS+O3J4ZsvHtZu6UxStLrtRmFy86XTv/Hi+18jbfC7n5k/VQI+XiLxO+RoyEya9v0tLsksGU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=hvxZq9Ew; arc=pass smtp.client-ip=209.85.128.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="hvxZq9Ew"
Received: by mail-wm1-f43.google.com with SMTP id 5b1f17b1804b1-488b150559bso52902515e9.1
        for <syzbot@lists.linux.dev>; Wed, 15 Apr 2026 05:38:59 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776256738; cv=none;
        d=google.com; s=arc-20240605;
        b=lmlD5osOldQBM8Ja7Aks5jsaCnXL+0FhHzyQYbHE8pdlFMkHiWNAOi6vBSvawDlkTW
         A4Exn7BMsv9Zwp3EaSWJMiD5qslpInyW9ZqW36UX1wEVrwiMznpfO4e8vLtu9S25Lw+C
         8DfdaJWfZFOmsDw1P5oyhuZ0Vg5DaWebBk7ra1/m3Ce4sbaCPMOJ8RJO0OD2sVgwOqHU
         2BCJjxdbTHSGTTjgPWp1PYQmhaIpMnx0ifW7WloQwScEp+KIWYQx6Qk0HgR7/tcbazDt
         Q8xXbHkBABvCC+vJViEUc0DZY6NIS7MWCL8fbS1bMxCFugNQURKtz51tZYK8j/517qDn
         ir5g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fO8HeLwKdfDsyz0XfcAlD8VK23s2RVgowBvgRfAapIw=;
        fh=dhjA98BV++aW40MRRuhbPhnyrOBW/rRLoggvaV9R5Kg=;
        b=H9nHXu8umhBXfD+259Pep6C3lhN/SEEBS2aD/9vtNlF+YRa1jxNj/5Rg/KeogsGm1E
         cdmpqA68rKTuwCfNcjavuLmRE0pEMNQV1SFXAFPjRI/csu94rWjqllhry3GhUiBgSzJ3
         8T8u5QW2wub/iVMM1nnYRVWp4zfbaejXfnI/N7h6WhTNY9ixjsvBnUzOw3GqFh33nS1n
         OgzGba1WJ6TaCsGHESQDlWM+Akpyd55xsvtXUwGyjpFuNwOy7djyczz7YG2SneFzKRXH
         79UmEK0hWisf2Nydj+O4YU+ZSLrnvpRidHMRDyWjRjvcybRGmWoVQOkDrvkjkS12W+Fp
         6hZQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776256738; x=1776861538; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=fO8HeLwKdfDsyz0XfcAlD8VK23s2RVgowBvgRfAapIw=;
        b=hvxZq9EwBkM1ZUrDSoTXLKfAtU2hUQ19YNPWu8itHfHX2gTOaAp3PlOAzDcsLSS6tM
         COU0RYoBqingx9XNI5ZXfpUKWr7AkuwgwVSnvfeTcLrJFD1wiDf1ZQAPGqtGhGQA6vZL
         nuV4ShWVB1e9BpM7mNEJwO5n9Ba9W5nevqLnsILYgxy3qY+d/2l5wq+MmuoxXU/7xOaE
         G9QhuCm4ISeBC4BYQEq9lSNSbdDxJxV0SIUbQHtlhqOJgxpUa81w2vw2Emgf0y423TXf
         +HRqpYPZuJKZ6d9i8wLl1mkFmIwp3mMqoedozxGZnnpagMhwesGW8EdhlTEwkbhAXNZO
         7Rmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776256738; x=1776861538;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=fO8HeLwKdfDsyz0XfcAlD8VK23s2RVgowBvgRfAapIw=;
        b=XZjgyE8hn99wEXBzPd8m5Cf+u8yP+RSTbijzwUCzJi43y7bhVg7fs3rwzOBJUyv+i/
         pznM4mJ6PO+aj/nJyKvJ2ZO59fw97dWWxxGjtRit9CM2LqNun6w/VIU26/J4iUN4uK5+
         A5h6p62izsrCMjDQdu2EDbhao2feXFrkN6kD7e2V1oHcNCnuhRSdnccDy6Q/wrQngkrE
         Z78RKzzgUnzjoX+zsRd1SxqITO1zLg83gDDpBAc48qzco65srucXAhSf1SzlTedFxY5t
         l+3T7B7teoH5jRtWpSUiYFkl8kYldVbI9TD/3hqEbKasxsKsN+A5wt/A2oBPH5lkbFBB
         /2+w==
X-Forwarded-Encrypted: i=1; AFNElJ/1zxqgwL19XLUvj6qthM5OVjzgQJ2xjYEAUCeSUXGK/+WHLWJMRMOAaE+fJkSYc/9ErZ+FgWg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwRgHmgjbBJIeoOpyJSmtLxNn3IF1kfbm9GfdnI1d1hUOvc97j4
	9nOkngfX/f4FFyyS5LCpyAwgLLQ06iW/7FT3EMlBERRwMxbct/xq459Dnb6AtoRDjFIQP4W4uFy
	HL9kHlweF+jF23wdwskCN3/yrMYWvhC1Zv1akvStX
X-Gm-Gg: AeBDievaFh5k8pW5HPy4rtnENUmS5z3uUD9VFqG1siXqAVGfg/n3t4nhop3f9x6dTyf
	YdpDNUj/sLz5t2BunFZ+7wk0Csmx+bmKo0DCO87PScHoi23SZ/H8UeG9THL9reAThoRjFT3gqrR
	Ud9DRt1t5Z/TtX/wGg8n6G2pVfZBVc8ZeFkbiJZj4V8o+REgqoEdoE8udJBeBFGq90lWzsDQYG5
	trAkNyQgzJ7S8mrajTQvHabOAj98JFWZ/Lp2VTPYYnswojsKnK81ivcySaMbEqER1ZB6JWyBYfL
	WMxPSgXGnZmm2zvYM4D4S5VT46dPXGf0nvgOUzxN+th8WM+IdwB+w8iX9DO4qwPFeBXX1PANFOj
	JLivMaJUzhNN+Sw==
X-Received: by 2002:a05:600c:8904:b0:488:c257:a73b with SMTP id
 5b1f17b1804b1-488d67effd0mr201198115e9.9.1776256737222; Wed, 15 Apr 2026
 05:38:57 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69df8564.a70a0220.259bc5.000a.GAE@google.com>
In-Reply-To: <69df8564.a70a0220.259bc5.000a.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Wed, 15 Apr 2026 14:38:46 +0200
X-Gm-Features: AQROBzCaHJjvsanQF4EM4ND6TGebDeC8qStMFBD2PX-84XlB6F5SES1ZCiY5y6A
Message-ID: <CAJWNTGxs3BQzdsgk95gyv5BVHqAmT+puRYQjyMQDHgdL_2QP3A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: [PATCH net] tipc: fix UAF race in
 tipc_mon_peer_up/down/remove_peer vs bearer teardown
To: syzbot ci <syzbot+ci779e8ed86620f383@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Apr 15, 2026 at 2:32=E2=80=AFPM syzbot ci
<syzbot+ci779e8ed86620f383@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] [PATCH net] tipc: fix UAF race in tipc_mon_peer_up/down/remove_peer =
vs bearer teardown
> https://lore.kernel.org/all/20260415061211.45530-1-95986478+SnailSploit@u=
sers.noreply.github.com
> * [PATCH] [PATCH net] tipc: fix UAF race in tipc_mon_peer_up/down/remove_=
peer vs bearer teardown
>
> and found the following issue:
> WARNING: suspicious RCU usage in tipc_mon_delete
>
> Full report is available here:
> https://ci.syzbot.org/series/6267bc07-4172-4821-b3e5-dac381479d9d
>
> ***
>
> WARNING: suspicious RCU usage in tipc_mon_delete
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      35c2c39832e569449b9192fa1afbbc4c66227af7
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/a29dabe7-96d8-4072-bc2c-d798a3493=
01e/config
> syz repro: https://ci.syzbot.org/findings/f144d75a-7c29-41a1-988e-09892a8=
9baa1/syz_repro
>
> tipc: Disabling bearer <eth:syzkaller0>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> net/tipc/monitor.c:108 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 1 lock held by syz.2.19/5962:
>  #0: ffffffff8fbcba48 (rtnl_mutex){+.+.}-{4:4}, at: tun_detach drivers/ne=
t/tun.c:634 [inline]
>  #0: ffffffff8fbcba48 (rtnl_mutex){+.+.}-{4:4}, at: tun_chr_close+0x3e/0x=
1c0 drivers/net/tun.c:3438
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5962 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  tipc_monitor_rcu_bh+0xf5/0x110 net/tipc/monitor.c:108
>  get_self net/tipc/monitor.c:209 [inline]
>  tipc_mon_delete+0x10b/0x4d0 net/tipc/monitor.c:704
>  tipc_l2_device_event+0x370/0x680 net/tipc/bearer.c:-1
>  notifier_call_chain+0x1be/0x400 kernel/notifier.c:85
>  call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]
>  call_netdevice_notifiers net/core/dev.c:2301 [inline]
>  unregister_netdevice_many_notify+0x17a5/0x22c0 net/core/dev.c:12464
>  unregister_netdevice_many net/core/dev.c:12527 [inline]
>  unregister_netdevice_queue+0x31f/0x360 net/core/dev.c:12337
>  unregister_netdevice include/linux/netdevice.h:3427 [inline]
>  __tun_detach+0x6d9/0x15d0 drivers/net/tun.c:621
>  tun_detach drivers/net/tun.c:637 [inline]
>  tun_chr_close+0x10a/0x1c0 drivers/net/tun.c:3438
>  __fput+0x44f/0xa70 fs/file_table.c:469
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
>  exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
>  do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7b26d9c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffec30cee78 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 00007ffec30cef60 RCX: 00007f7b26d9c819
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 0000000000011900 R08: 0000000000000001 R09: 0000000000000000
> R10: 0000001b2e520000 R11: 0000000000000246 R12: 00007ffec30cefa0
> R13: 00007f7b27015fac R14: 000000000001193b R15: 00007f7b27015fa0
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
> [jmaloy@redhat.com kai.aizen.dev@gmail.com kuba@kernel.org netdev@vger.ke=
rnel.org pabeni@redhat.com stable@vger.kernel.org tipc-discussion@lists.sou=
rceforge.net ying.xue@windriver.com]
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
-upstream-moderation/69df8564.a70a0220.259bc5.000a.GAE%40google.com.
