Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB35C2EC542
	for <syzbot@lists.linux.dev>; Tue, 18 Nov 2025 08:43:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763455413; cv=none; b=cZC04IsbUsUc4wARQtWCes7G3eoE6vjs3olDImeW78w5GzGbyp7YCww/DQJJBixsNIrL6HLKXVanhvoOZjbwkK1bM3/AiivANpO+C4XvYXd8qXSaxOtHr+fp/kY4dxUig5G95XrJ75GtK5q7ziNl8o1mHdNMIlZHHc4D2tWS088=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763455413; c=relaxed/simple;
	bh=fR5DVRoQZyLddpZ4ief+nQC46Ijb6R+vydZt5SSn3Bc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TG1baRY7clKIhXOU/oI9qDUraf3vWVHwIrHR9/Eys3IYCtVlZIp/rMLkuw3BD3JSeP7sD0IQ4OJXG6ts2t3EHFFuHs+DM4vXENiS219xUZJyS5/cwA6IZrlI671XRfRJINTjv4KJ3rcheuLmO2vt1ArcONznqvYU3trdC88GI5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CsE+BWQp; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CsE+BWQp"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-44ffaeda17fso1473866b6e.1
        for <syzbot@lists.linux.dev>; Tue, 18 Nov 2025 00:43:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763455411; x=1764060211; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=D+hZgn48+G5ioNZ8K9Q3Xb1KViVgyO1vLSrKltXTMzw=;
        b=CsE+BWQp5Ty32o2OHVnwPEGoMiwTKHO3LVZNE8Zj1pwl2qEh/CUK1aQOaTREE3Mx+M
         XfaSH9m77NIv6wWrW0CZGBbc53HE0uRHnDp+PsQp8cvP1D5bqm+4dcgGEuRqjAZpbuUn
         5UzQh0cY+mPo0XHM8E5vVBThustR9f1wvnIFUChFNZxhjiOHjMbpdGRmWZNbcERt0Lyh
         0zSUVC/7LstKj8HkWOklW0O2jqJXwkKOu7/QQ27mz+UNAces3Qo6ju6+GX+MLQSXshgz
         20TphwD5xVgD9YVfouN8r7NmsiFPIbp5r5Z4HW0ZqiV5G/CdruC5CPVVin1516RbHb+7
         jg6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763455411; x=1764060211;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=D+hZgn48+G5ioNZ8K9Q3Xb1KViVgyO1vLSrKltXTMzw=;
        b=dIBeVHoKY4HLfjcOaXnHw5l8nI3CGEsw4Tj5HjQTGFOVmPsJM2Ss+FacuFUp88GQUl
         J1tJ+e+oe6bP50Dm4is/E3v7Ez4uQ8/N6YRiIFacDWbNNbiBEFYoExclw9xyJ4Jxdijh
         DjLR06g7+Zg/pSPDWTsohpi/c50D5uDCRuyI7MADeA0A1TEb5wH+jcXGx/0nWZVjLBuw
         9Dv1Ehuf3CDyL0N/iDJkx5mD3JUzMf+KRWVpuabMkrGV1VZubD/8wKoYZapseNR0B0wN
         /90uZ/IQNrLZT/9QoJFRmZKdCVUppWXuQNvD04RQeVHzEo+NXpz6vB0cFOEIf6Rewm7U
         5qYg==
X-Forwarded-Encrypted: i=1; AJvYcCWh0D2Yv/oYXEul769m3dI6zCJTViIiO7awa1pY1SRaP9QuVXypOXCM10CTRtihEixEfgd6NLE=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCX0KxM4feh3+R5Af9u6qHrmTLh0jFXu0rS2d45o/yeH1xTmGu
	6IJoec70d8DLE0ZWJaB/lpJradTw1tDJms3POD1xCOuRZl99mO5uyEFy/6h+9giLZCMfgL7SHQe
	XGWpUVJc5JpqmzMlt+bkDNcohlB6xrdsySPlNTBNK
X-Gm-Gg: ASbGncud+X0DZBeT08Q0XWcmz4oC/fO3qJ6XmL221hdgilcR3DL5nIkhi29kSL4suYb
	VwbaPxK75xDK7vfYCsgBvqYI6WDUfQTaK61jXBqU5By9+Fj/lmCv0crRGd881337QfmY1EXdNGF
	NDyNuXxvPAj9pruYFVEPNuWnlq2F7JXt0LYvJl2cZEmM8wFcIp5oTX9RYu5652th638kNM02e/R
	Iyi19j0hQkFHH8SOgQvYIx9yQVFsehR0XFmfihzbJJBflnHiJpnZ1kRFhvDZed9Nc0Ivz0rF2B9
	aHfjGUk/r2ufUNAfaw3rUVSA7oQtpRBc9zZ1RKgUxgrK3cLCBmthr3oq0yfBlgj3rh2E
X-Google-Smtp-Source: AGHT+IG626T/xk6YXKNaKTi9WlgA6NnQYudCIopS7lZdsZJ9tCwqIInkoI9VthYRpH6kzba+D4/zJZoGJt2toSTcsaA=
X-Received: by 2002:a05:6808:1905:b0:44f:e4a7:74b1 with SMTP id
 5614622812f47-450973e9411mr6917369b6e.3.1763455410591; Tue, 18 Nov 2025
 00:43:30 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <691bb73b.a70a0220.3124cb.00ac.GAE@google.com>
In-Reply-To: <691bb73b.a70a0220.3124cb.00ac.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 18 Nov 2025 09:43:19 +0100
X-Gm-Features: AWmQ_bnRdK8vYI8HcZeDcKf_D1oZ5XYGiD3mL07q0iAunb9VmUCX9TD_N7qiCuM
Message-ID: <CANp29Y5PDPFfognuj0S0RDy1+h=1T_vM+dpUdS0F-cMRcX2Yig@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Extend xas_split* to support splitting
 arbitrarily large entries
To: syzbot ci <syzbot+ci16da8bbe26730850@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Nov 18, 2025 at 1:01=E2=80=AFAM syzbot ci
<syzbot+ci16da8bbe26730850@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Extend xas_split* to support splitting arbitrarily large entries
> https://lore.kernel.org/all/20251117224701.1279139-1-ackerleytng@google.c=
om
> * [RFC PATCH 1/4] XArray: Initialize nodes while splitting instead of whi=
le allocating
> * [RFC PATCH 2/4] XArray: Update xas_split_alloc() to allocate enough nod=
es to split large entries
> * [RFC PATCH 3/4] XArray: Support splitting for arbitrarily large entries
> * [RFC PATCH 4/4] XArray: test: Increase split order test range in check_=
split()
>
> and found the following issue:
> WARNING: kmalloc bug in bpf_prog_alloc_no_stats
>
> Full report is available here:
> https://ci.syzbot.org/series/aa74d39d-0773-4398-bb90-0a6d21365c3d
>
> ***
>
> WARNING: kmalloc bug in bpf_prog_alloc_no_stats
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      41218ede767f6b218185af65ce919d0cade75f6b
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/c26972f6-b81e-4d6f-bead-3d77003cf=
075/config
>
> ------------[ cut here ]------------
> Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KE=
RNEL|__GFP_ZERO). Fix your code!
> WARNING: CPU: 0 PID: 6465 at mm/vmalloc.c:3938 vmalloc_fix_flags+0x9c/0xe=
0
> Modules linked in:
> CPU: 0 UID: 0 PID: 6465 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
> Code: 81 e6 1f 52 ee ff 89 74 24 30 81 e3 e0 ad 11 00 89 5c 24 20 90 48 c=
7 c7 c0 b9 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 75 2b 6e ff 90 <0f> 0b 90 90 8b=
 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
> RSP: 0018:ffffc90005d7fb00 EFLAGS: 00010246
> RAX: 6e85c22fb4362300 RBX: 0000000000000dc0 RCX: ffff888176898000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
> RBP: ffffc90005d7fb98 R08: ffff888121224293 R09: 1ffff11024244852
> R10: dffffc0000000000 R11: ffffed1024244853 R12: 1ffff92000baff60
> R13: dffffc0000000000 R14: ffffc90005d7fb20 R15: ffffc90005d7fb30
> FS:  000055555be14500(0000) GS:ffff88818eb36000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f653e85c470 CR3: 00000001139ec000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __vmalloc_noprof+0xf2/0x120
>  bpf_prog_alloc_no_stats+0x4a/0x4d0
>  bpf_prog_alloc+0x3c/0x1a0
>  bpf_prog_create_from_user+0xa7/0x440
>  do_seccomp+0x7b1/0xd90
>  __se_sys_prctl+0xc3c/0x1830
>  do_syscall_64+0xfa/0xfa0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f653e990b0d
> Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 18 00 00 00 48 89 4=
4 24 08 48 8d 44 24 20 48 89 44 24 10 b8 9d 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 1b 48 8b 54 24 18 64 48 2b 14 25 28 00 00 00
> RSP: 002b:00007fffbd3687c0 EFLAGS: 00000246 ORIG_RAX: 000000000000009d
> RAX: ffffffffffffffda RBX: 00007f653ea2cf80 RCX: 00007f653e990b0d
> RDX: 00007fffbd368820 RSI: 0000000000000002 RDI: 0000000000000016
> RBP: 00007fffbd368830 R08: 0000000000000006 R09: 0000000000000071
> R10: 0000000000000071 R11: 0000000000000246 R12: 000000000000006d
> R13: 00007fffbd368c58 R14: 00007fffbd368ed8 R15: 0000000000000000
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
> [ackerleytng@google.com akpm@linux-foundation.org david@redhat.com linux-=
fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org mic=
hael.roth@amd.com vannapurve@google.com willy@infradead.org]
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
-upstream-moderation/691bb73b.a70a0220.3124cb.00ac.GAE%40google.com.
