Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.42
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793398591;
	b=gQ76B9Vf8iHDweL71glrugQbp7YPh8bWZBVKYcX2/0/gjkgFBDSwz8/VCyw4SrCt3Hkr
	 zl8qhVDrpbItlKmE8GtJmuYSUklEG0fuiCi90fw8wLxO1E2JFhOfslfoCAOoA/ZuOfWzh
	 j1VvLErwXSHa6wBRv89AjfZRCt/h0zPlaO40mzJcTwn1JKW6JTMD9EJVAjBB1hVWRBhW/
	 jmygGqPf/XZRK78pn2aHZBLoeW342x7cdE7PIAlmBk91BS6VXZUZ7T9juPcnQFoKAv9am
	 +4QE3Hxc7xWeAFfDe5H6gZJ4nNFYQQ3PYMR5FRvVgtQxrExI/UaiU8zMH3fKXf3RccQ==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793398591;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=RzhbEHC0O6OPSjPneTb6TKjwXaOPyoq4gwYV5p1xSUo=;
	b=gQnC79KedLwligklFpZVMw1yQUrt9dhtsHPuV9lG7YFZNsMR3h9QRtBIxjM7mUAoKBd0
	 FqZ+huALzc/L8lwgJuuO7yRGCHS5LM9QbzAPTqMhjyC2NUgeOWxUwyNjyPJrp6omL+PuH
	 88tLUFA0wRNwRkVM53VKAUZeeLHEoDZBNhG5FQTn/ecCL6E6ezwz0J0OKWJycI9s3fqIC
	 +j5xMcKphZZLZB/d2qjT9bwSdzAZLBCLwlCIXapDBgZsTafNqGnsSSu1SfIKqlCKmhS+Q
	 yp20ougp5DQ81S3Sm0RY9Fwhvc+dQ503Y3UjaGWTN8bsIUpIwdzIKM0HhOpycA5ZHfA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DRLo5UgY;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.42
Received: from mail-oo1-f42.google.com (mail-oo1-f42.google.com [209.85.161.42])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7CFF606A31A
	for <syzbot@lists.linux.dev>; Fri, 30 Oct 2026 22:16:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org B7CFF606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=DRLo5UgY
Received: by mail-oo1-f42.google.com with SMTP id 006d021491bc7-714d57774d8so847739eaf.1
        for <syzbot@lists.linux.dev>; Fri, 30 Oct 2026 15:16:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793398589; cv=none;
        d=google.com; s=arc-20260327;
        b=nXtxvKRAR8J3wTfrsV26qLJdDeAUNhc9fN+j7isgjo3CVFKk+eJfzpBSKMmeUxk5cZ
         QxXfOm06XjjEuKJWYnOnpY7yWC207KE7hFMWLDB2EGv+E1jA5p5mKjFfOJ0A0ADxFBDP
         l0Jo7DSXMVL536MyJ7C+6ml5c1Zwbe9Rm9TiYDKRq+Dpk0pPYfqNFrETAfLhAYJeKYOk
         i1/xsOkOSDSi1V4u/1yxsa1uWThES/Isby0/vX8T2xu1lUMZmdanV4dSgCJXoy3xIDXw
         fx2zGT/Wx8yC/A0wIXIByHbGUo5GdHxv5AsIp1GhbmoJxkv6ARoavFepP6CepyZitM6w
         hSZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=RzhbEHC0O6OPSjPneTb6TKjwXaOPyoq4gwYV5p1xSUo=;
        fh=U+6wJOi4/fuXiE/uOYn71ZEmjzsEutDota2bRf7RgM4=;
        b=ZdieGmRd5G+FyrFjoJRioJqlBRjn2Ynkm4OzYCRjbz7Qm7S4W307kFjQQ5peF15V1w
         i9YXXefSen8laf7lXMxAGmDk2q6Lo0i/Uq1NLtLcYVO7tfYLMIwo/QhupUHJ1GAfaqZu
         UGqcq8Si+hITmNnckVAkz627YMU3N2JgbsFlUUg1fwxTbNpN2avqbAQtmyhtt40uPvwS
         7CK4wCM6oc+95WhZXl+Ou9hBUsHPYUjIO41NE/GyC0UC2hG8oVD69mzv0yTzjrKSAGSS
         hp1dT/QfVcOPLrucfl9kmRNodzFkYZ5sN7Y3sUhorizdgCljOs635rGZjwKv1h2dyvsU
         jq+Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793398589; x=1794003389; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=RzhbEHC0O6OPSjPneTb6TKjwXaOPyoq4gwYV5p1xSUo=;
        b=DRLo5UgYFiHpRHcv02iv3M9tJgkzyOr2SN1k1VBQB3V4iehhYaGi9BqWDnaOZObPLs
         FR994u2DQyeXgcNPW7jqJRuWRITNDYAQwS/zGr0enbBF6WDuS+jJHA5d8Jrc/Shqfp/F
         CNpsmQ/MSRaAfRPtT2V+m56OQcCIQwQHjb+EQVksdRl9XJ0tbF7JXQ8GkiabEtOLIJwW
         WUyCvu0n3bpDXhCZyUdbYVreilXRNwpD1OV0EgEIWQsv4PTVCdX6fXh84e2EJ5EsphkE
         yIzzrbFZDFa2+fXxTK0K8aul8QdAejewkKFCTXJvhPuSMUG/i2LClZ5ef9KzIkwVhqmf
         Tc3g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793398589; x=1794003389;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RzhbEHC0O6OPSjPneTb6TKjwXaOPyoq4gwYV5p1xSUo=;
        b=IswsXArwurkydajUcjsI6XGd7rV71PqF+SNT+7mBsis4qsoxjkp5bncuWY6fH/t9aB
         ob0N7s8QOBH1MPLmL7he1yujdjDIHD7auWuS7J1wWCxksGWrCHACXtYqNAgopl9nU43r
         D7PVyImc/IS5N117aesTm4SFES/u+F7UKWOgW/HsoNl8LvGc5eGEkptQgScNoEe4ABbK
         4DhQ0ByNM5p6SSKGqFGVzFk4+yaoNdd77v9nTV61b91e811h50qbQtqAfFFBB1rHEjRR
         d+GXohq5Kofe8JcTb6dB6yi0TFSenXaXYEn7pMVZIikr2/WIPYPnThnnnpGwbdgPxNWZ
         d3zg==
X-Forwarded-Encrypted: i=1; AKwUvBzjGYq5MdOhdtnb/zKEOm9AUWZg61ZJmR5u6yH3+NaE2XCqDS309KIgCbLe3MYKvWqvA7dhTGk=@lists.linux.dev
X-Gm-Message-State: AFq9FYLGizdz6GPqUT6KPTQN90pV2dJtwRdBin0tJED4FMuo8TI7h7vy
	ALAlF5kcnnTJpg7V0uwDXIgpaoX8iIGv42RUcGbMq7ubOi51AiCr6qoQS8JkXJj7Wn7KKbE0Zj/
	72yFr39ODQJdb9O1fKNXY47I8dxHWqQ8jfxBMsc6M
X-Gm-Gg: AYBFou3HsgqIXy9z8+z2AyvuS1GnaEZQN5/S9pEv/PKo9i4YGfTfUKtzDvmjkuYH4FZ
	4lOdaZ6WMYTaPMY32wnHNX9GkEHO5uqb4WEyjiLi+MwEolsfAXeB3NGlua/IBDj9LP8SAzT/PIF
	VUcmw2uMgJdejKCelPHuZQYYp4XK/PHCA2837XSoIrxxQF1Wiu7GO40Pn/l96btr3bHtyAINQZY
	s18sN4tJ3S9IGehA31u13aaB+2SAvQV4KjEdkrjR0tSKMlvw1w2JcwJPfSgJnaqfDmTMaAqDz0v
	JR1kLKfUjrEbURnlnUSppa9OaW8GiXpNSSuc3xeBymTLxTtcvsoWwMqsI5De9XaBx7+hs8p9LDF
	hJSsY74nTv76GsESa81CSO9OE3sPDltJoaiy5K2/IGRvN/cagyt8g8LDZzETEseX2yLhA8UXhrt
	UU/l0a0Y2elP2xZ1QOnmqPn9dPWHz/zgFrUNWGURAQJnH5j+LGJzb1Co6HlfrpUoEHkPckEs2Pp
	0V2ih63Kg==
X-Received: by 2002:a05:6820:618:b0:6b6:c3d2:702e with SMTP id
 006d021491bc7-714f1fd9f41mr2325600eaf.9.1793398588946; Fri, 30 Oct 2026
 15:16:28 -0700 (PDT)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6ae4fa87.88e51036.1515fd.0000.GAE@google.com>
In-Reply-To: <6ae4fa87.88e51036.1515fd.0000.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 30 Oct 2026 23:16:17 +0100
X-Gm-Features: AclHuK-lEsO_oiDw3iN99Ihk5ZQ9BFw3m7AJ9TciXK8CpKyaGy-XE2biE0BiGXQ
Message-ID: <CANp29Y5Qa1BcivNSff5gHuVnMuoX9uA4BjnBg3FSgAFyLfOPvw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: kcm: reject attaching sockets with a ULP, and
 TLS on KCM sockets
To: syzbot ci <syzbot+ci429596586d55e106@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Oct 30, 2026 at 9:14=E2=80=AFPM syzbot ci
<syzbot+ci429596586d55e106@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] kcm: reject attaching sockets with a ULP, and TLS on KCM sockets
> https://lore.kernel.org/all/20261029203428.3057054-1-rjethwani@purestorag=
e.com
> * [PATCH net v4] kcm: reject attaching sockets with a ULP, and TLS on KCM=
 sockets
>
> and found the following issue:
> KASAN: slab-out-of-bounds Write in kcm_ioctl
>
> Full report is available here:
> https://ci.syzbot.org/series/8bb553bd-8792-4a67-b142-8c396f2f2594
>
> ***
>
> KASAN: slab-out-of-bounds Write in kcm_ioctl
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      5838f10563d58afca6711edb5e4eda968ca181d9
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/371e9558-3281-4ec8-8935-9d7fa1e94=
ef9/config
> syz repro: https://ci.syzbot.org/findings/b6f85fa5-eb30-4533-93b3-5c754fa=
c4e45/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in kcm_attach net/kcm/kcmsock.c:1324 [inli=
ne]
> BUG: KASAN: slab-out-of-bounds in kcm_attach_ioctl net/kcm/kcmsock.c:1376=
 [inline]
> BUG: KASAN: slab-out-of-bounds in kcm_ioctl+0xced/0x1140 net/kcm/kcmsock.=
c:1583
> Write of size 8 at addr ffff888113f70810 by task syz.1.18/5902
>
> CPU: 0 UID: 0 PID: 5902 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  kcm_attach net/kcm/kcmsock.c:1324 [inline]
>  kcm_attach_ioctl net/kcm/kcmsock.c:1376 [inline]
>  kcm_ioctl+0xced/0x1140 net/kcm/kcmsock.c:1583
>  sock_do_ioctl+0x101/0x320 net/socket.c:1328
>  sock_ioctl+0x57a/0x7e0 net/socket.c:1449
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f96df39f559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f96e01fe028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f96df625fa0 RCX: 00007f96df39f559
> RDX: 0000200000003880 RSI: 00000000000089e0 RDI: 0000000000000004
> RBP: 00007f96df436b20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f96df626038 R14: 00007f96df625fa0 R15: 00007ffc97de2138
>  </TASK>
>
> Allocated by task 5902:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  unpoison_slab_object mm/kasan/common.c:351 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:377
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4720 [inline]
>  slab_alloc_node mm/slub.c:5033 [inline]
>  kmem_cache_alloc_noprof+0x2b4/0x600 mm/slub.c:5047
>  sk_prot_alloc+0x57/0x210 net/core/sock.c:2275
>  sk_alloc+0x3a/0x390 net/core/sock.c:2337
>  inet6_create+0x81a/0x1270 net/ipv6/af_inet6.c:178
>  __sock_create+0x4b5/0xac0 net/socket.c:1679
>  sock_create net/socket.c:1737 [inline]
>  __sys_socket_create net/socket.c:1774 [inline]
>  __sys_socket+0xd6/0x1b0 net/socket.c:1821
>  __do_sys_socket net/socket.c:1835 [inline]
>  __se_sys_socket net/socket.c:1833 [inline]
>  __x64_sys_socket+0x7a/0x90 net/socket.c:1833
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff888113f70000
>  which belongs to the cache RAWv6 of size 1984
> The buggy address is located 80 bytes to the right of
>  allocated 1984-byte region [ffff888113f70000, ffff888113f707c0)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888113f7=
3300 pfn:0x113f70
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> memcg:ffff888113f77f81
> flags: 0x17ff00000000240(workingset|head|node=3D0|zone=3D2|lastcpupid=3D0=
x7ff)
> page_type: f5(slab)
> raw: 017ff00000000240 ffff888167e03500 ffffea000442be10 ffff888104ae4948
> raw: ffff888113f73300 00000002000f0006 00000000f5000000 ffff888113f77f81
> head: 017ff00000000240 ffff888167e03500 ffffea000442be10 ffff888104ae4948
> head: ffff888113f73300 00000002000f0006 00000000f5000000 ffff888113f77f81
> head: 017ff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 5785, tgid 5785 (syz-executor), ts 69263183053
>  set_page_owner include/linux/page_owner.h:33 [inline]
>  post_alloc_hook+0x1f9/0x250 mm/page_alloc.c:1856
>  prep_new_page mm/page_alloc.c:1864 [inline]
>  get_page_from_freelist+0x220f/0x2280 mm/page_alloc.c:3935
>  __alloc_frozen_pages_noprof+0x1fe/0x410 mm/page_alloc.c:5444
>  alloc_slab_page mm/slub.c:3384 [inline]
>  allocate_slab+0x7d/0x5e0 mm/slub.c:3499
>  new_slab mm/slub.c:3550 [inline]
>  refill_objects+0x2d5/0x350 mm/slub.c:7539
>  refill_sheaf mm/slub.c:2917 [inline]
>  __pcs_replace_empty_main+0x2c8/0x6c0 mm/slub.c:4811
>  alloc_from_pcs mm/slub.c:4887 [inline]
>  slab_alloc_node mm/slub.c:5021 [inline]
>  kmem_cache_alloc_noprof+0x394/0x600 mm/slub.c:5047
>  sk_prot_alloc+0x57/0x210 net/core/sock.c:2275
>  sk_alloc+0x3a/0x390 net/core/sock.c:2337
>  inet6_create+0x81a/0x1270 net/ipv6/af_inet6.c:178
>  __sock_create+0x4b5/0xac0 net/socket.c:1679
>  inet_ctl_sock_create+0xa2/0x220 net/ipv4/af_inet.c:1640
>  tcpv6_net_init+0x34/0xb0 net/ipv6/tcp_ipv6.c:2348
>  ops_init+0x35d/0x5d0 net/core/net_namespace.c:137
>  setup_net+0x118/0x350 net/core/net_namespace.c:443
>  copy_net_ns+0x536/0x770 net/core/net_namespace.c:582
> page last free pid 5803 tgid 5803 ts 69160417533 stack trace:
>  reset_page_owner include/linux/page_owner.h:26 [inline]
>  __free_pages_prepare mm/page_alloc.c:1403 [inline]
>  __free_frozen_pages+0xc97/0xd90 mm/page_alloc.c:2954
>  __slab_free+0x269/0x2c0 mm/slub.c:5926
>  qlink_free mm/kasan/quarantine.c:163 [inline]
>  qlist_free_all+0x99/0x100 mm/kasan/quarantine.c:179
>  kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
>  __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:361
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4720 [inline]
>  slab_alloc_node mm/slub.c:5033 [inline]
>  kmem_cache_alloc_noprof+0x2b4/0x600 mm/slub.c:5047
>  ptlock_alloc mm/memory.c:7769 [inline]
>  ptlock_init include/linux/mm.h:4039 [inline]
>  pmd_ptlock_init include/linux/mm.h:4151 [inline]
>  pagetable_pmd_ctor include/linux/mm.h:4179 [inline]
>  pmd_alloc_one_noprof include/asm-generic/pgalloc.h:146 [inline]
>  __pmd_alloc+0xc1/0x5c0 mm/memory.c:7029
>  pmd_alloc include/linux/mm.h:3865 [inline]
>  __handle_mm_fault mm/memory.c:6725 [inline]
>  handle_mm_fault+0xe9d/0x3750 mm/memory.c:6943
>  do_user_addr_fault+0x7f6/0x1480 arch/x86/mm/fault.c:1394
>  handle_page_fault arch/x86/mm/fault.c:1483 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1536
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:595
>
> Memory state around the buggy address:
>  ffff888113f70700: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff888113f70780: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
> >ffff888113f70800: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>                          ^
>  ffff888113f70880: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
>  ffff888113f70900: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
> [davem@davemloft.net edumazet@kernel.org hare@suse.de horms@kernel.org ji=
ayuan.chen@linux.dev kuba@kernel.org linux-kernel@vger.kernel.org netdev@vg=
er.kernel.org pabeni@redhat.com rjethwani@purestorage.com sagi@grimberg.me =
stable@vger.kernel.org]
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
-upstream-moderation/6ae4fa87.88e51036.1515fd.0000.GAE%40google.com.
