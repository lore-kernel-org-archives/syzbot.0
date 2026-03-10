Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2904036C0DD
	for <syzbot@lists.linux.dev>; Tue, 10 Mar 2026 23:14:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773184476; cv=pass; b=FWYV6asYaF/858++XUq5lnWWxoCfbIQQUebWdTegUZIfYaJ3svYkcpexKKWBN8XbULNYBk0OIb3xEglAK6d0hzoko7G7aTlBvUPLZtWe1RDjFhOHKmzbNyvJ5UP+eqVLMGdYt8XX75ew6aodw92KZR/c31wpRYMVayXgy2rlByA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773184476; c=relaxed/simple;
	bh=h1RZUP99zXRISsJGvK11obG1g60q+OvfoLdVJhDaA0Y=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RB7evG2W+N3cJk8Iit3shm2dl8XVXEO8wdMXGbEeG6P0CrfHEZWfcMWXt9K1/1I/crA9fBApldkFzUu+WfkUpcCsHs/zdI27v/KFbL6Qi3o6i9DC1Ltzx91mfIKCYkkSj32ZTPoVN3tjpqCIBOnQfdaTqQHejKYN1ULdtviZPm0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0+0VTtUh; arc=pass smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0+0VTtUh"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-4043b27ddeaso6165493fac.1
        for <syzbot@lists.linux.dev>; Tue, 10 Mar 2026 16:14:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1773184474; cv=none;
        d=google.com; s=arc-20240605;
        b=GJUBVs71tVcZeDMk24ZShg008qXOcim+vVE2Z1JMHRyrH+ezToZ8KO3/DFGVC67Yt+
         W8BiGk4VPQSLwY240VKUBgc8qz58r1S3DbRkOsyxhbRbtbr0eydK1o3JmuMfSBEuSLJh
         LDh8ZdsQ2cRVkCiNY8nuBMuF5memtBf9M0DgJxITrxpxmjMRVkDVuNVT82lmQo577eJo
         qUwphO7USMZknRmuabo012V5nFMjqkFXcYEc203HxxVgAObOmlHpq8l8WGuixeM37Bbv
         IeLbxOvxMoJTjdrSqxSaZxnVvwWiunE+V7gqyRQQBYent2sjn+zevuWzvBXz2GfSBccC
         Z8bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6fvP1o8Xlim05yoPhO7Gt/hH2t4HU95O9nUFpRcgJwc=;
        fh=wSqPxjv0USui0g4Bha1F6WWbniwD8YI0+IpEbv45hvg=;
        b=WX2RcEsob1kJ+iMP7xHhSQr9hZcDztiaLTJo84+nHm75bxOs4ZOP43X5GwL0nUlYS0
         J/KRRH6oDjy2Jg9cnQm5d3C7couk6EFPWMKkdlgfwTw7nsiurhJLJFXRG+/PL1KpiZuc
         SAAL7Vn3zsEDBBauZWq2MOoIvgMBgMWFFp+h6Wd8wPrtCFxdfNY3rEwLB/ewtqiCdI1Z
         hoas7mASPYm8bJmpe4f44KRuKuAWjrkdwDy8JlV6P49MQUo9SlQeDReDa1cIhBQzchst
         s5TcDLnTaRCslA6OUpSFAtI78O5FkxVBPvZbb3iEQPUANSay1hB5YZcGFOTD1QyqtK/b
         XScQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1773184474; x=1773789274; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=6fvP1o8Xlim05yoPhO7Gt/hH2t4HU95O9nUFpRcgJwc=;
        b=0+0VTtUhj6HZbgtlCx6/nSJz8QVAjrP7ZLJB3UzJT7xCHOxDTUFR7gcuHwQKQ7ikfQ
         96G5c7oD+oiq5uXLhz8zZnIZsEpLC47Ot4rh9/fEHoz8Om0UcYjrKz5f/FgIlT04qj/m
         uVcW1ou7UcSHi6b43hBYzmbSddtfMrGjh2mlwVuqCHDjUoEkavRbaNhhEb9FlHRC5bEa
         SfOFLmHm0P6+oR2Rg4duYRrkDR7waZ3snVwnmt/+VHs1iTvUa9t99jAQi50kmDgOutv+
         OxHA9vuxStqA/nBIfuyru9SczO20dEH1auJ9Fmy9ISO4mnDd9E4FYfLW48ybeIio/my+
         JDEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773184474; x=1773789274;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=6fvP1o8Xlim05yoPhO7Gt/hH2t4HU95O9nUFpRcgJwc=;
        b=gjQI59sNIaBTFTnVc8/DCtqg/EYLiwDVAA811RE00Yopg8iCi12LC/O8azi1VMTKnU
         Z7cr/28pz896ZFj8MSAWgiQsBSjAhhwVZcuQ/SGRMFaY16qKOYuDb6hUJ4l45+ahagjw
         2ePhdyrmx/Xx20k+I4bKhcD4YNCkgofNxLOYQtiRLCWRjwVQCGgTzMtPWvToPEvH7sG/
         RwP1ETq1+QSRJHmyvH7q0PzaE5QhNq76hnWDggYf35h0vZ3vsnA5v2xQyHqE7ujgPJpl
         aXRQcEs1s/jzoUphogOpip59lVTxoycn7r1KlwHwR87h0hmqPZ/zjd9Dgwy/Arc+99yK
         cx0g==
X-Forwarded-Encrypted: i=1; AJvYcCVMh3njM2AifxsDsR6H0GB8zO6QPKZFqIO49JoR4oS86cunMRaV+ljT/hyaU7miCak++yjeJes=@lists.linux.dev
X-Gm-Message-State: AOJu0YzjHPsk8fzAoAteqJbaSCV4swlqaHxt16lwPicSBz8PhVhyAveT
	Uwoyr7c1/zJ+ONUPZuWNjQFxrXVRyf/UcGaOiUGHtt/+ir7qSpdoidQqFmUM/QLuV4QWhHuD/tb
	nEUJYHE/VRnmKnUzTuo5NqkWw81sn2slGYb4Mq4RH
X-Gm-Gg: ATEYQzx6X9QHPKFL3wUlwfRke1eI6x8VIq9Xzrr9mbL1PgHKjvNsWVNVjfhvWv6lv5d
	CRIb5ZHtVOtvsEeVBnfCWqBpZxSGy1aaWUY0nf4e2whfRUGzdthjJTON+tJywbTtUROeygikaID
	MkwdBgtyVejGvLeUTGlu2MkSgS9gpPCZ9xGMXvfuSfGCCWEg7yoD4gIRAeagFJpebAlqnKDYLkH
	0gyPuTzOuVZTHMhWADXXiW1ftriJpxsPAl3tASg6kwEds81Trs7hv8r8b3amqE+CYqHVZrH47Xy
	j7csFqNrtWJtwen7LKkdOlZreg5FnG7QCOvwu4LaSXghIlF6nVY=
X-Received: by 2002:a05:6871:2ed3:b0:417:6713:5dae with SMTP id
 586e51a60fabf-4177c82c4f2mr440705fac.24.1773184473521; Tue, 10 Mar 2026
 16:14:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69b0a26a.a70a0220.51e36.0003.GAE@google.com>
In-Reply-To: <69b0a26a.a70a0220.51e36.0003.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 10 Mar 2026 23:14:21 +0000
X-Gm-Features: AaiRm52LjTiHZdqX8V8Y0-htytfIAo-TeTVQghUuFB-DIwTsFwATOKHakCNJsHM
Message-ID: <CANp29Y59EYrrW+Zv-=nhwCoOHTo5txJMk=iEzcmPHBL1Ld=KKg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net/smc: fix NULL dereference and UAF in smc_tcp_syn_recv_sock()
To: syzbot ci <syzbot+ci76bc04d7b7c53a4d@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Mar 10, 2026 at 10:59=E2=80=AFPM syzbot ci
<syzbot+ci76bc04d7b7c53a4d@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] net/smc: fix NULL dereference and UAF in smc_tcp_syn_recv_sock()
> https://lore.kernel.org/all/20260310120053.136594-1-jiayuan.chen@linux.de=
v
> * [PATCH net v3] net/smc: fix NULL dereference and UAF in smc_tcp_syn_rec=
v_sock()
>
> and found the following issues:
> * WARNING: suspicious RCU usage in smc_fback_error_report
> * WARNING: suspicious RCU usage in smc_fback_state_change
> * WARNING: suspicious RCU usage in smc_fback_write_space
>
> Full report is available here:
> https://ci.syzbot.org/series/b6883213-02f6-437e-bb3b-09fc59b0534c
>
> ***
>
> WARNING: suspicious RCU usage in smc_fback_error_report
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      73aefba4e2eb713cf7bc4ad83cfc9b5d4f966f6d
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0ecfc74c-85c7-4a7b-8b09-d322ac9ea=
108/config
> C repro:   https://ci.syzbot.org/findings/f8c698ca-41b9-4ced-953c-f6c3ee4=
05ebc/c_repro
> syz repro: https://ci.syzbot.org/findings/f8c698ca-41b9-4ced-953c-f6c3ee4=
05ebc/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/net/sock.h:682 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 2 locks held by syz.0.17/5970:
>  #0: ffff88811a1d1d60 (k-sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock inc=
lude/net/sock.h:1709 [inline]
>  #0: ffff88811a1d1d60 (k-sk_lock-AF_INET6){+.+.}-{0:0}, at: inet_stream_c=
onnect+0x51/0xa0 net/ipv4/af_inet.c:749
>  #1: ffff88811a1d1f08 (k-clock-AF_INET6){++..}-{3:3}, at: smc_fback_error=
_report+0x2d/0x140 net/smc/af_smc.c:900
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5970 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  __rcu_dereference_sk_user_data_with_flags include/net/sock.h:682 [inline=
]
>  smc_clcsock_user_data net/smc/smc.h:345 [inline]
>  smc_fback_error_report+0x135/0x140 net/smc/af_smc.c:901
>  sk_error_report+0x48/0x2b0 net/core/sock.c:348
>  tcp_disconnect+0x132c/0x1fa0 net/ipv4/tcp.c:3543
>  __inet_stream_connect+0x32b/0xdd0 net/ipv4/af_inet.c:648
>  inet_stream_connect+0x66/0xa0 net/ipv4/af_inet.c:750
>  __sys_connect_file net/socket.c:2089 [inline]
>  __sys_connect+0x312/0x450 net/socket.c:2108
>  __do_sys_connect net/socket.c:2114 [inline]
>  __se_sys_connect net/socket.c:2111 [inline]
>  __x64_sys_connect+0x7a/0x90 net/socket.c:2111
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7effcfd9c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe9219fa18 EFLAGS: 00000246 ORIG_RAX: 000000000000002a
> RAX: ffffffffffffffda RBX: 00007effd0015fa0 RCX: 00007effcfd9c799
> RDX: 000000000000000c RSI: 00002000000001c0 RDI: 0000000000000003
> RBP: 00007effcfe32bd9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007effd0015fac R14: 00007effd0015fa0 R15: 00007effd0015fa0
>  </TASK>
>
>
> ***
>
> WARNING: suspicious RCU usage in smc_fback_state_change
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      73aefba4e2eb713cf7bc4ad83cfc9b5d4f966f6d
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0ecfc74c-85c7-4a7b-8b09-d322ac9ea=
108/config
> C repro:   https://ci.syzbot.org/findings/fb044c1b-44f5-483a-bb87-1aad71a=
75a03/c_repro
> syz repro: https://ci.syzbot.org/findings/fb044c1b-44f5-483a-bb87-1aad71a=
75a03/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/net/sock.h:682 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 3 locks held by syz.0.17/5945:
>  #0: ffff8881be8b0ee0 (sk_lock-AF_SMC){+.+.}-{0:0}, at: lock_sock include=
/net/sock.h:1709 [inline]
>  #0: ffff8881be8b0ee0 (sk_lock-AF_SMC){+.+.}-{0:0}, at: smc_sendmsg+0x52/=
0x4d0 net/smc/af_smc.c:2802
>  #1: ffff8881b9f04360 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock incl=
ude/net/sock.h:1709 [inline]
>  #1: ffff8881b9f04360 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: tcp_sendmsg+0x=
21/0x50 net/ipv4/tcp.c:1464
>  #2: ffff8881b9f04508 (k-clock-AF_INET){++..}-{3:3}, at: smc_fback_state_=
change+0x2d/0x140 net/smc/af_smc.c:864
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5945 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  __rcu_dereference_sk_user_data_with_flags include/net/sock.h:682 [inline=
]
>  smc_clcsock_user_data net/smc/smc.h:345 [inline]
>  smc_fback_state_change+0x135/0x140 net/smc/af_smc.c:865
>  tcp_rcv_synsent_state_process net/ipv4/tcp_input.c:7000 [inline]
>  tcp_rcv_state_process+0x2b23/0x4810 net/ipv4/tcp_input.c:7215
>  tcp_v4_do_rcv+0x6bb/0x1430 net/ipv4/tcp_ipv4.c:1907
>  sk_backlog_rcv include/net/sock.h:1185 [inline]
>  __release_sock+0x265/0x3a0 net/core/sock.c:3213
>  release_sock+0x5f/0x1f0 net/core/sock.c:3795
>  tcp_sendmsg+0x39/0x50 net/ipv4/tcp.c:1466
>  smc_sendmsg+0x250/0x4d0 net/smc/af_smc.c:2823
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
> RIP: 0033:0x7f9b66d9c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe630639c8 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f9b67015fa0 RCX: 00007f9b66d9c799
> RDX: 00000000200048cc RSI: 0000200000000240 RDI: 0000000000000003
> RBP: 00007f9b66e32bd9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f9b67015fac R14: 00007f9b67015fa0 R15: 00007f9b67015fa0
>  </TASK>
>
>
> ***
>
> WARNING: suspicious RCU usage in smc_fback_write_space
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      73aefba4e2eb713cf7bc4ad83cfc9b5d4f966f6d
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0ecfc74c-85c7-4a7b-8b09-d322ac9ea=
108/config
> C repro:   https://ci.syzbot.org/findings/a3f8aa1e-ebea-41f3-b6e4-97d45bc=
19aaf/c_repro
> syz repro: https://ci.syzbot.org/findings/a3f8aa1e-ebea-41f3-b6e4-97d45bc=
19aaf/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/net/sock.h:682 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> 2 locks held by syz.0.17/5953:
>  #0: ffff8881b9ed1c60 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: lock_sock incl=
ude/net/sock.h:1709 [inline]
>  #0: ffff8881b9ed1c60 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: sockopt_lock_s=
ock net/core/sock.c:1152 [inline]
>  #0: ffff8881b9ed1c60 (k-sk_lock-AF_INET){+.+.}-{0:0}, at: sk_setsockopt+=
0xe62/0x2e80 net/core/sock.c:1310
>  #1: ffff8881b9ed1e08 (k-clock-AF_INET){++..}-{3:3}, at: smc_fback_write_=
space+0x2d/0x140 net/smc/af_smc.c:888
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5953 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
>  __rcu_dereference_sk_user_data_with_flags include/net/sock.h:682 [inline=
]
>  smc_clcsock_user_data net/smc/smc.h:345 [inline]
>  smc_fback_write_space+0x135/0x140 net/smc/af_smc.c:889
>  sk_setsockopt+0x221f/0x2e80 net/core/sock.c:1351
>  do_sock_setsockopt+0x11b/0x1b0 net/socket.c:2318
>  __sys_setsockopt net/socket.c:2347 [inline]
>  __do_sys_setsockopt net/socket.c:2353 [inline]
>  __se_sys_setsockopt net/socket.c:2350 [inline]
>  __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2350
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0c5f39c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd35759278 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 00007f0c5f615fa0 RCX: 00007f0c5f39c799
> RDX: 0000000000000020 RSI: 0000000000000001 RDI: 0000000000000003
> RBP: 00007f0c5f432bd9 R08: 0000000000000004 R09: 0000000000000000
> R10: 0000200000000100 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0c5f615fac R14: 00007f0c5f615fa0 R15: 00007f0c5f615fa0
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
> [alibuda@linux.alibaba.com davem@davemloft.net dust.li@linux.alibaba.com =
edumazet@google.com guwen@linux.alibaba.com horms@kernel.org jiayuan.chen@l=
inux.dev jiayuan.chen@shopee.com kuba@kernel.org linux-kernel@vger.kernel.o=
rg linux-rdma@vger.kernel.org linux-s390@vger.kernel.org mjambigi@linux.ibm=
.com netdev@vger.kernel.org pabeni@redhat.com sidraya@linux.ibm.com syzbot@=
syzkaller.appspotmail.com tonylu@linux.alibaba.com wenjia@linux.ibm.com]
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
-upstream-moderation/69b0a26a.a70a0220.51e36.0003.GAE%40google.com.
