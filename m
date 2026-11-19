Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.49
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795071497;
	b=QeTesADSTL9TqIsrWh7nAcYYmdBO6E+g+ReG/FM3oLYEnu6tADrMl6f5k3YgM6Ilitd+
	 m02z8D8ooeKXVRbp6b45vMDA6+SjItkaSht59nkMOpSd+dcDJjEIRq4NNLPOzQEy0ij/Z
	 8MVQ/tNSzgirD59ScTIQ8gdXnJ5sZBT28ZHnR/z2f21WREpe/f3CdVAkwDqsuU7N+VE6C
	 Y10LdOopsxejU2uJwQdjGFexmrmvHSK4hNTMUt5Z39RsvPyxmzrG0CmhKDutkFFXSoJpY
	 f6x/SSoOeLHH7yPbiT+ky1g3esTJMyPozpvgrlMBrOJA10tbAcgzbTKifrx1f/hTZEw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795071497;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=fEGUG4fxtuQw+wFAPvkID37fAdVBw0hne281NySWHRU=;
	b=rTLc56DllehTElFyikfmkeL9KWbxu0b+eK6lsj0uL34o1IxSuvaUhRB5nFEOQUcqKF0O
	 68pEebFcDtfxpL48kG4WcfUbQuQZ6D3zkSYh8YgeZui3L4FaI5InHU9yip46CnFB1lWFp
	 eMKYXVYwaRYgbLhOXGBhc41QKZnpAa/BG9xS3Eb7CurtbEvya4ej/ORlcZhdBhTbwlt15
	 rGJxXYatD3h7a05GXexDycLNWgapBaskATjDmiG58dcQ3LNxXxpuEtVY+Cm/wmjPTaALa
	 sEm8dRRFQle+NaDVsuuCTUxHiUeq2Ng7ItaX41gGOYdtVOVb5/ozOY2XsW8aTcAWvpg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Y0HtsZdF;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.160.49
Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3BF1606A320
	for <syzbot@lists.linux.dev>; Thu, 19 Nov 2026 06:58:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C3BF1606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=Y0HtsZdF
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-46556b9e02cso523692fac.1
        for <syzbot@lists.linux.dev>; Wed, 18 Nov 2026 22:58:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1795071495; cv=none;
        d=google.com; s=arc-20260327;
        b=XVSTDUedz3MsoO0O3GbOwdvr+mhKsF9Ee5s0YtnWmHs0d4OQHsIhesa5eZA3Z69xJl
         xc5eeMv4vLUCss8Bx8qgaL2FI38zEmVgqcAcZo+oHFgYMWOwVFQow0NBByMc8E5unSLd
         P40duJKFHdx/1dM+kOOO3R9ldOgCAKhSz/i55nzpU5q1Vs49di1q4J17WeUBjmL9VzS9
         2RO3nasdxma1MZ3gt7GFZ6WaW0xYbiZLtRDWjz0h0+f67SPM8lWKgNno0ijE1+lJj5+e
         KXqK9zQ4xZs2RBb0TqwFsIdi6HWjooW3IMT+TU6D1fQHLCk0rcTcjia1fp2rgA9qUORc
         PJdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=fEGUG4fxtuQw+wFAPvkID37fAdVBw0hne281NySWHRU=;
        fh=KR4ffw4tAI+absUj/vHDbkpJyvm7uiamCMAEpGxSJjY=;
        b=LORbQ9cSeSMuS5oYl9qUO/dzyPWSK1SnkWmSuDBy6TUyF1UjZoqsL4LN0IDQFtsoDd
         yfRpUGWyYPM32DovcbEvb6anCguxqxwo3G3ZzyGUbO27WX7b7jlC8oAolqP5l/fMJxEA
         UUumRpJDkZZ4PzuzCBV7z9bcL9tPR/3UaubJfU+xQx5bWVW7FmIlR2RlvbRkGc/K3I5+
         u+RfVUL4wF6iIOEWS9r5NHCYnP+AZfUrkVmaRQh7azzlP+Hy3l+kxeoYVK3TI3FQlEl2
         dAg1ls40jfSaKGjpbFCv+9T4Okss7vuCVtQPU/Ulwlq87dyuelGPdi09lSd/DtHVuqq8
         TtLA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1795071495; x=1795676295; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=fEGUG4fxtuQw+wFAPvkID37fAdVBw0hne281NySWHRU=;
        b=Y0HtsZdFU6U8AAu6AUnWaciIdRSK9nWYFbShrk0t2eIeJkVrkvRFrfVQnD30apIWVH
         BNvbqAa3Ohm7qjpJf8xQuWQfsNh30MHgg4hnwcnA7YrWSn8M4KOcBDBX8X+TWqWAnwHW
         R+IbFO7QD0409xb73Q9DE5W0QaMAUAbTSkK0kMMZRoksfcYqzVrlK+cjejzxP8UcbAqg
         u6szwphUCnoUcGpROlMjqrZu+NZd9rdDHq1+Gm5ioM7gykVbWjqHqsBnns8/MhePmj08
         0LIZ7lCfkAC3qs+V78ErJ5lSlGW74Kh1ZSkPCH5FZPbVd0kUL7dc4tiIs4czlvbZSRQa
         Yrng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795071495; x=1795676295;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=fEGUG4fxtuQw+wFAPvkID37fAdVBw0hne281NySWHRU=;
        b=2B0iYwmy7pmjqgred5EiFe1M+Gosx0BpdOiy6l9d4ecHQeFMS1tA/7S7pd9tLlA/oR
         G8ljYrj924YrR/UkzTjGod3uwjqu6jvS/b7Ehq+KTNLDrBr5QcCads2fgyPXLoVLXz9a
         Rl5jzGevK98dFY8JIBHS57G3jyoGxaPqT0wE2Ip7p5kCfScW/QMah06Ecsvlc1RTXIf6
         qok3Gn99c1gPgULP+G3pfsNmkUCLzpE7ocDqm2zWbE4W7aNBE3PnEbNHn9ipldt3MPNO
         vH7jn04hjxCM2depyn3fAbMgJnp6QJRUSa4ilfoU36GOeXSnPloD8GzJH6eq3GbRjnKJ
         jvig==
X-Forwarded-Encrypted: i=1; AL+hErG2DsulW4JxoVYma476l6OdD3gd9a/ORJjT/raUXfKjBB3RBUbGsgAm6F53S1RryF3X/n48xj8=@lists.linux.dev
X-Gm-Message-State: APuU4Z9Uh2KQplsOWHP2Cy1cajnDcBwoMC+SDyycfYsMgELLFSielCzZ
	S/hUBQXdGm9cMe5KiT91lwxwu1abkT/gVLUHooOxB4V1YTk5dyEHjpVV5Tau9yxbWxy/nBn73AY
	D3mmM4DzLD3VR6TCQHUCaufkaXlvT+LxPRL1amtHh
X-Gm-Gg: AYBFou0G8/am/Ll1vvAn+SBhCvdpr0UJ+yFnMusb3hF9JmdIH29bm3+xgabX/tB2BLI
	ODRlPWjDkmiQxplPPlnAX0iae1MQjE72BpmAsB/woXhFKzyQVVA3Igrtbq5oXKRy64FxYA/ZlsN
	cUoNP/nJDmYnO0Q+c+mLnwHRLcmoKVlm9NMoW7lFxOUvue8pLprSG18Qz7zdLZddzl6ViXkiRvA
	NE3vZ4a+LN56aZDEZGWyI/bTI2PGRiEko/VjG6+NroSjDuhb+IcM75dHZ/Rw4TjfkPXwAc83I3t
	BRPWBIw+FiMqTtP7Z1x5kl5J6P7Ji2RG9lHmCjnCEw2OE7IhhgwvUlp/g/xleLZwcLSr5B5DPIr
	IUuUWVQ2NM6si/LKGDytKo151plOBEfXlm8mgaqzEit25cF6rMBhRLy4qAmHgdalm4A4Alq1HqR
	WGTM8D3Y70kz0rCCUBsAODFr8crLbk2TCrazeAfqigiIhK3cIDiY6C7TYXOkhJQdNE4dcWfiGHd
	+2YHnk=
X-Received: by 2002:a05:6870:d625:b0:490:d828:a7e5 with SMTP id
 586e51a60fabf-4bb3adc419dmr104527fac.30.1795071494880; Wed, 18 Nov 2026
 22:58:14 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6afe9ce8.92f98041.20636d.0001.GAE@google.com>
In-Reply-To: <6afe9ce8.92f98041.20636d.0001.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 19 Nov 2026 07:58:03 +0100
X-Gm-Features: AclHuK_ZlPQ4601aSsYGVJMrBaALT0jAcvFcXLhpcVR0uO05xqag-n1CqZIcTIU
Message-ID: <CANp29Y5fnFgdUH4CFL0hh-k8ORS=bpzZE7tg4fj2tSK3_SontQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: keys: serialise instantiation against keyctl_chown_key
To: syzbot ci <syzbot+ci6f245d1507e04332@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Nov 19, 2026 at 7:53=E2=80=AFAM syzbot ci
<syzbot+ci6f245d1507e04332@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] keys: serialise instantiation against keyctl_chown_key
> https://lore.kernel.org/all/20261115121722.206-1-enscrpt@pm.me
> * [PATCH] keys: serialise instantiation against keyctl_chown_key
>
> and found the following issue:
> possible deadlock in key_move
>
> Full report is available here:
> https://ci.syzbot.org/series/51455b74-3344-42d0-9ba7-b64be2ff0b40
>
> ***
>
> possible deadlock in key_move
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      4405c18c95d2d0f99f6c581ef0ee8591a1aa6ccd
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/309e9321-2f31-411e-ac93-724f183b5=
510/config
> syz repro: https://ci.syzbot.org/findings/89658ad2-f692-4500-bd4e-ef9d90d=
c18e5/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz.0.17/5852 is trying to acquire lock:
> ffffffff908c1a40 (keyring_serialise_link_lock){+.+.}-{4:4}, at: __key_mov=
e_lock security/keys/keyring.c:1305 [inline]
> ffffffff908c1a40 (keyring_serialise_link_lock){+.+.}-{4:4}, at: key_move+=
0x1d3/0x7b0 security/keys/keyring.c:1634
>
> but task is already holding lock:
> ffff888104aa1290 (&type->lock_class/1){+.+.}-{4:4}, at: __key_move_lock s=
ecurity/keys/keyring.c:-1 [inline]
> ffff888104aa1290 (&type->lock_class/1){+.+.}-{4:4}, at: key_move+0x16a/0x=
7b0 security/keys/keyring.c:1634
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #2 (&type->lock_class/1){+.+.}-{4:4}:
>        down_write_nested+0x98/0x200 kernel/locking/rwsem.c:1757
>        __key_instantiate_and_link+0x9d/0x4d0 security/keys/key.c:451
>        key_instantiate_and_link+0x331/0x4b0 security/keys/key.c:549
>        keyring_alloc+0x6f/0xb0 security/keys/keyring.c:541
>        system_trusted_keyring_init+0x67/0x120 certs/system_keyring.c:231
>        do_one_initcall+0x250/0x870 init/main.c:1419
>        do_initcall_level+0x10a/0x1a0 init/main.c:1481
>        do_initcalls+0x59/0xa0 init/main.c:1497
>        kernel_init_freeable+0x29d/0x3e0 init/main.c:1732
>        kernel_init+0x22/0x1d0 init/main.c:1622
>        ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> -> #1 (key_construction_mutex){+.+.}-{4:4}:
>        __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>        __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
>        __key_instantiate_and_link+0x8f/0x4d0 security/keys/key.c:443
>        key_instantiate_and_link+0x466/0x4b0 security/keys/key.c:549
>        keyring_alloc+0x6f/0xb0 security/keys/keyring.c:541
>        look_up_user_keyrings+0x376/0x670 security/keys/process_keys.c:116
>        do_one_initcall+0x250/0x870 init/main.c:1419
>        do_initcall_level+0x10a/0x1a0 init/main.c:1481
>        do_initcalls+0x59/0xa0 init/main.c:1497
>        kernel_init_freeable+0x29d/0x3e0 init/main.c:1732
>        kernel_init+0x22/0x1d0 init/main.c:1622
>        ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> -> #0 (keyring_serialise_link_lock){+.+.}-{4:4}:
>        check_prev_add kernel/locking/lockdep.c:3209 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3328 [inline]
>        validate_chain kernel/locking/lockdep.c:3952 [inline]
>        __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
>        lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
>        __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>        __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
>        __key_move_lock security/keys/keyring.c:1305 [inline]
>        key_move+0x1d3/0x7b0 security/keys/keyring.c:1634
>        keyctl_keyring_move+0xd6/0x110 security/keys/keyctl.c:618
>        __do_sys_keyctl security/keys/keyctl.c:2023 [inline]
>        __se_sys_keyctl+0x85a/0xbc0 security/keys/keyctl.c:1885
>        do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>        do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> other info that might help us debug this:
>
> Chain exists of:
>   keyring_serialise_link_lock --> key_construction_mutex --> &type->lock_=
class/1
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&type->lock_class/1);
>                                lock(key_construction_mutex);
>                                lock(&type->lock_class/1);
>   lock(keyring_serialise_link_lock);
>
>  *** DEADLOCK ***
>
> locks held by syz.0.17/5852: 2, on CPU#0:
>  #0: ffff888104aa1090 (&type->lock_class#2){+.+.}-{4:4}, at: __key_move_l=
ock security/keys/keyring.c:-1 [inline]
>  #0: ffff888104aa1090 (&type->lock_class#2){+.+.}-{4:4}, at: key_move+0x1=
59/0x7b0 security/keys/keyring.c:1634
>  #1: ffff888104aa1290 (&type->lock_class/1){+.+.}-{4:4}, at: __key_move_l=
ock security/keys/keyring.c:-1 [inline]
>  #1: ffff888104aa1290 (&type->lock_class/1){+.+.}-{4:4}, at: key_move+0x1=
6a/0x7b0 security/keys/keyring.c:1634
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5852 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2087
>  check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2219
>  check_prev_add kernel/locking/lockdep.c:3209 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3328 [inline]
>  validate_chain kernel/locking/lockdep.c:3952 [inline]
>  __lock_acquire+0x164c/0x2de0 kernel/locking/lockdep.c:5288
>  lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
>  __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>  __mutex_lock+0x197/0x15a0 kernel/locking/mutex.c:821
>  __key_move_lock security/keys/keyring.c:1305 [inline]
>  key_move+0x1d3/0x7b0 security/keys/keyring.c:1634
>  keyctl_keyring_move+0xd6/0x110 security/keys/keyctl.c:618
>  __do_sys_keyctl security/keys/keyctl.c:2023 [inline]
>  __se_sys_keyctl+0x85a/0xbc0 security/keys/keyctl.c:1885
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x171/0x540 arch/x86/entry/syscall_64.c:89
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f417a9a8fd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f417b7c9028 EFLAGS: 00000246 ORIG_RAX: 00000000000000fa
> RAX: ffffffffffffffda RBX: 00007f417ac25fa0 RCX: 00007f417a9a8fd9
> RDX: fffffffffffffffe RSI: 00000000326b97d4 RDI: 000000000000001e
> RBP: 00007f417aa37fed R08: 0000000000000000 R09: 0000000000000000
> R10: 00000000326b97d4 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f417ac26038 R14: 00007f417ac25fa0 R15: 00007ffc44b5b118
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
> [dhowells@redhat.com enscrpt@pm.me jarkko@kernel.org jmorris@namei.org ke=
yrings@vger.kernel.org linux-kernel@vger.kernel.org linux-security-module@v=
ger.kernel.org paul@paul-moore.com serge@hallyn.com stable@vger.kernel.org]
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
-upstream-moderation/6afe9ce8.92f98041.20636d.0001.GAE%40google.com.
