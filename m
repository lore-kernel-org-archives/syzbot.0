Received: from mail-pl1-f180.google.com (mail-pl1-f180.google.com [209.85.214.180])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C2872236F4
	for <syzbot@lists.linux.dev>; Thu,  7 Aug 2025 08:04:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.180
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1754553881; cv=none; b=VxFJwKtsUYkXj5YB3bkMEeWpNF/vFKEF6WJYcBcDKtfpk8qmdbY9QZ9eumfNdaaAA8AfXnxWIEtugTmR5BauEss35JNMgSRpBkmITA569n6O0shQrEbTt2ArJ3hy+zOtbKJLlFZPy0DObzHStUqHqGwkxaPE1EvBlYHzU3ut7/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1754553881; c=relaxed/simple;
	bh=jAWuhfXzGwnNaaWUTbZOKd2YIpRvdXQ2+ZZc2YmTuZQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=IQg6CpH164BcmPa9LXXUKHpP6f67bzb2CP2f5hcYeslRjAyCA1vqq3twK7u8nuc4diYbnOwFQrH7aOd1srfpczzH4TEti2WOA7+kX9ns+Q2x7c+Az1sTKpAAqCOTHDciKipHrRaSg1MJOeTJaXox9rZX5K+ioaBUSCBt5FnAXuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=wXhz8hVm; arc=none smtp.client-ip=209.85.214.180
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="wXhz8hVm"
Received: by mail-pl1-f180.google.com with SMTP id d9443c01a7336-23c8f179e1bso9184075ad.1
        for <syzbot@lists.linux.dev>; Thu, 07 Aug 2025 01:04:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1754553879; x=1755158679; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=aZBB631BgHfyuyTVJXHQEyqQlLQuxuGlyb3GovkW0Gc=;
        b=wXhz8hVmgjcg/w+1nHxMaQb9lE6/B9OYRE0V/s93wXpDkH4WcSJzvASyRuBdGjFLzV
         blpaHQa9cn6ZTbNJBJ6BrFHVdUSQ02z7hwxIP8l4J4LgVEX909YcZZxMG9qWB+kA++TO
         CsBJS1ysEV/gyVQIQ2thPNLrbIwUqUmq0ck8NS9XZahh8Agp4Q1Ebv6wGDPWd2oXTmc4
         iXPd1J019pGNwlW0NoqqgTC7ONHcCjZTYGYkJTeWWw/UqZmPyvni+ra/6aFAoQv8F6D9
         ZrywjMhE5H+aluBayYEEX1yOPriTQI1Ii99Zfd5iOQewCiz7++EVGbj9Kn1ydaV5nA1E
         18jw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1754553879; x=1755158679;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=aZBB631BgHfyuyTVJXHQEyqQlLQuxuGlyb3GovkW0Gc=;
        b=epgEIs2XxIoMDZJ/ebEQmjcd5HvkvxDqfoMNRUnjh3ocdv7YhVMwcUCmQD58oK8fsd
         33aEqjbRSWtCS7nc70WNU6CbqbN67iobIxlpddU3TTe1IbE2rA0144Pk7h14+oO31D0i
         VF1KOuzZZGw8xAWarbU0hKiFFhXT4ypus3vrhx0ntEXqsUz2DDDuV3DJoqxC9wW9GlIL
         OINyqDVtp2Q5lY+uamzT1r1LQ4sJQ0OQFGH1KTTMYDO3Ci5hqoas9q0aPRf7EarCT+d+
         aivKIK8Q+ikrguMjwaOkx52seZO8BROmafkjq6TmML6LIDlJGoJLETLO5VFxin7f6qKZ
         BW3Q==
X-Forwarded-Encrypted: i=1; AJvYcCViCJdYdhcmrY8NioslCFY6uoHLp6w1I1Wg2YtHw/lliuCs6zuGj9GItivyttbTtnRxknNlrJA=@lists.linux.dev
X-Gm-Message-State: AOJu0YwswlCs+xJ0+j0qz3gufZuI5GFo9MzvcpIhKB3Ml9f/AYe1urVx
	93Gu8WoJMmA+nYjzg4Af1qZuXhuXppH774dJSvjLLFoIzP3b6xLrkyYrZ7TqxRr8np67aqQMtVQ
	doVr2hz3nNtKP0GunQVyEvjRnrGWCfsyhb/ak2crn
X-Gm-Gg: ASbGnctWIke4Hn6sJ5h3YbiZqoP+zdGByhSLqER7Sp0hy7XEFoXF0E1AxH812w6DHPk
	XdAPmT9FZ2VALTqgYWi9rm/Tlk265q6DK6xn2dh3Io6HGoQ4IczTIWoUhrcc7rXfeDQeCs+JIOU
	yM3Gsy+x8Q6+yYKVJNgUcjgjXNZLSTU23eP+JWxYKsQbQ2MvEDX4dlE8UwMqP98H03MZNLoF/Pw
	j5rDC2Vbb7E2VHJaWRarrze0jFNFdJgUw0WZQ==
X-Google-Smtp-Source: AGHT+IEUYo7Jivmj4073Wqy8d0Yrhvxau0d8P4QSSizbrXGBCjIlANeI7Fn2e0R7w8TM6uARRHsQXy9Up44Eb4/ItiA=
X-Received: by 2002:a17:902:f687:b0:240:79d5:8dc7 with SMTP id
 d9443c01a7336-242a0b8e1e3mr92791055ad.46.1754553878942; Thu, 07 Aug 2025
 01:04:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6893bab6.a70a0220.7865.0007.GAE@google.com>
In-Reply-To: <6893bab6.a70a0220.7865.0007.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 7 Aug 2025 10:04:26 +0200
X-Gm-Features: Ac12FXxI1L1yjhjDripnrfq_0b9g89A66mbRZZe1cOlenyeGf-fcojaYsAS5csg
Message-ID: <CANp29Y5xQNcvp-rg2t2kZAMMWac6dAODEi2k3shkNUxFS1Wn6g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: xsk: fix immature cq descriptor production
To: syzbot ci <syzbot+ci6e2923a937c1ed25@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Aug 6, 2025 at 10:27=E2=80=AFPM syzbot ci
<syzbot+ci6e2923a937c1ed25@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] xsk: fix immature cq descriptor production
> https://lore.kernel.org/all/20250806154127.2161434-1-maciej.fijalkowski@i=
ntel.com
> * [PATCH v3 bpf] xsk: fix immature cq descriptor production
>
> and found the following issue:
> WARNING in xsk_create
>
> Full report is available here:
> https://ci.syzbot.org/series/ed9b41fb-c772-4c8d-ab6b-07919dac7f3f
>
> ***
>
> WARNING in xsk_create
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      e8d780dcd957d80725ad5dd00bab53b856429bc0
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/ac640846-151f-4c3e-8a63-10a1d5688=
1e1/config
> syz repro: https://ci.syzbot.org/findings/34ebabe4-f302-4e4b-9951-0a44d70=
4970a/syz_repro
>
> ------------[ cut here ]------------
> kmem_cache of name 'xsk_generic_xmit_cache' already exists
> WARNING: CPU: 1 PID: 6031 at mm/slab_common.c:110 kmem_cache_sanity_check=
 mm/slab_common.c:109 [inline]
> WARNING: CPU: 1 PID: 6031 at mm/slab_common.c:110 __kmem_cache_create_arg=
s+0xa3/0x320 mm/slab_common.c:307
> Modules linked in:
> CPU: 1 UID: 0 PID: 6031 Comm: syz.2.21 Not tainted 6.16.0-syzkaller-06699=
-ge8d780dcd957-dirty #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:kmem_cache_sanity_check mm/slab_common.c:109 [inline]
> RIP: 0010:__kmem_cache_create_args+0xa3/0x320 mm/slab_common.c:307
> Code: 81 fc 58 a5 22 8e 74 26 49 8b 7c 24 f8 48 89 de e8 32 81 67 09 85 c=
0 75 e2 90 48 c7 c7 f2 e1 98 8d 48 89 de e8 5e 00 7f ff 90 <0f> 0b 90 90 48=
 89 df be 20 00 00 00 e8 cc 82 67 09 48 85 c0 0f 85
> RSP: 0018:ffffc90002dffcc8 EFLAGS: 00010246
> RAX: 2d59588130194a00 RBX: ffffffff8cb69260 RCX: ffff888105d20000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
> RBP: 0000000000000010 R08: ffffc90002dff9e7 R09: 1ffff920005bff3c
> R10: dffffc0000000000 R11: fffff520005bff3d R12: ffff88801fde6928
> R13: 0000607e5bfbe4c0 R14: ffffc90002dffd60 R15: 0000000000000098
> FS:  00007f455d4c26c0(0000) GS:ffff8881a3c7e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f455c7b7dac CR3: 0000000106b38000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __kmem_cache_create include/linux/slab.h:353 [inline]
>  xsk_create+0x67e/0x8d0 net/xdp/xsk.c:1817
>  __sock_create+0x4b3/0x9f0 net/socket.c:1589
>  sock_create net/socket.c:1647 [inline]
>  __sys_socket_create net/socket.c:1684 [inline]
>  __sys_socket+0xd7/0x1b0 net/socket.c:1731
>  __do_sys_socket net/socket.c:1745 [inline]
>  __se_sys_socket net/socket.c:1743 [inline]
>  __x64_sys_socket+0x7a/0x90 net/socket.c:1743
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f455c58ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f455d4c2038 EFLAGS: 00000246 ORIG_RAX: 0000000000000029
> RAX: ffffffffffffffda RBX: 00007f455c7b5fa0 RCX: 00007f455c58ebe9
> RDX: 0000000000000000 RSI: 0000000000000003 RDI: 000000000000002c
> RBP: 00007f455c611e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f455c7b6038 R14: 00007f455c7b5fa0 R15: 00007ffd678e28c8
>  </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
> Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [aleksander.lobakin@intel.com andrii@kernel.org ast@kernel.org bpf@vger.k=
ernel.org daniel@iogearbox.net e.kubanski@partner.samsung.com maciej.fijalk=
owski@intel.com magnus.karlsson@intel.com netdev@vger.kernel.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6893bab6.a70a0220.7865.0007.GAE%40google.com.
