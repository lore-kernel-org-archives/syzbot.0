Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5DD314A6A
	for <syzbot@lists.linux.dev>; Thu, 13 Nov 2025 07:40:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763019635; cv=none; b=cy7/GyKfaT4CURvBVM3DcHaAgb8vM2YT0O8+YFrxDlKWvUba7RslEtNHR3JAbbvPOj33rpAVPjLS+S9m7CnX6D6YTN5mimWfDsKpzd1ryBsFIHBR2hGTkFtupAAghtr77zGygCtxVvFKE7ylC+1VbTSjoFf3ma+79kiTpWGfMkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763019635; c=relaxed/simple;
	bh=/lfcxcNkyQRGkxIKg3Fyv3FO9BSx0p9gQ7jCRY+51XE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=S+GgCEHjJMTXjD+r+Gmt4oPzrNL4C83+yofXNCb1GMN/rVSaQG93EGtsdFctaBEkZWDv6fZ2Pl0qUMQ9Eo1YqvrslcNS16uhMsUtSzgFelnT78h1BWQjXvEJyN4jxCs/SNUrc+seSCHN9n4k+xcA9D1zJdMb7yLQ5sNwte1tbVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MyC/MObe; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MyC/MObe"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-3e80c483a13so286390fac.2
        for <syzbot@lists.linux.dev>; Wed, 12 Nov 2025 23:40:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1763019624; x=1763624424; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1RvXfmwIWV+hV94JxbJ+y/fdsTnL0HB/D35W7RfYSs0=;
        b=MyC/MObeQo2RAsDtJJKJMsCoJ5KN+nccqlfvPfbaV83mXgZuNY+/6i/RR+6A1RgAmA
         j/DOGGDjGVWALLLujbBoPW9Ql3HtZ0kXX6yOrYmo824HVrHNhbjjO2PhKN3Dm66QjD2E
         XhXjUcLu8y0SkyDEcDawVJRbZK2p6ZTFqBt6s3yWBgufh5CKxkGo3bnPCy1pvJ1/aJZk
         IKKij2aXl+o2G+/S1qQKPf32cfHGvjFE07fdeN0diQ/QVkt8XWp8iRN5OJJrrU4pPnMp
         Nzz+x68J1Uzhgp6GwvvwO/uHbBazATkSJHePcLzBsOZ6BgMtjrGjvkNMJq5Y0uqkkLIO
         EcJA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763019624; x=1763624424;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1RvXfmwIWV+hV94JxbJ+y/fdsTnL0HB/D35W7RfYSs0=;
        b=lMfyKmJdj8jVWqN4f/1GYc5BDvfUEJnoRScP+rJyGpzuF/7+twUfo0Nbm4dgmnA3AQ
         yHKgGpS9x+oG2vVhgWulIWkgPYJLyU//J8nli2XzjiMOQClCXD0za/DzG9DQpfeC+Auy
         r1M/hWQRf1eg9GSeB1ZbtC0xphGcZlMTJjWCeIcyzZCCgYVpbF/jMVHbkG2yQefvyOBH
         U3kJI0mHjm2rtSvj0IPfmokOJ6xeO8I1FGif6NI9ldhqWayrDQWB19mSmSpYstQMnzxD
         rWaNMHQvCtAYV/qzX25wUWxmm+tJpMVEKbBYBY1hou/CzRjuKGy7cSycpd99fg3G0Cz0
         TGvw==
X-Forwarded-Encrypted: i=1; AJvYcCWQVYkB0ctWqmkgCO2TrjBGkodDcRep+sCzRhAIzuluh2UuhDn5+13yIRy7SUfkNQe3Kzxn52s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzxtn7Jru1yu6gzeUf8oQlqWNiBEtcNkTvvIfe//BlCXRtaZEMF
	lzmHW30F5b04YF+HyQVLmzEDuQDgnCd/ul0Aek5KXs1hyNQ0jEUlaM7kTVsP5+TAK5kvOnXaaLH
	pPwhlANUeO69JaOyGl1vE4KAvJZ20cuEiuTkmpI+Z
X-Gm-Gg: ASbGncuvre7EXvGiQea6vm3lF6pidLjtgDBVvEjsdibC+DP/hQInC0XVlYP3RDFCQBq
	zJj+xmjTDHnb3Hd1YUm1N2/Aj7YiI0jEzZMVupOQ01sKYqupnQJ0od2mBPwh07nwieW06xxSWOw
	y94Z/H3X1ql/Ve77uwiFBal2EC9/1DriD6VXiSmebo0/pTJ1m/Z+6DxGquCxvOXtKIveYZDYYmi
	vHmo2X6y2udmA93PDs/Tiy/A59LU1bxd2Kuve0SdbEfw5x/rSDHv1SCdzuRD40H12qxIYMRoMJc
	nIMDZWKAAPVnxMpu946Nnr8PQfHOxDYN7QgCm5nqM4hNMsb8cM82iw4i460Z
X-Google-Smtp-Source: AGHT+IG8lzx1XgyQlgugPKbrLnvjsiXlfZoly6odlTsDK90+ZtK3uz+HUbMDnz6nMoSZUS7t+CFglywzXDycrA0JuWc=
X-Received: by 2002:a05:6871:2b9c:b0:3c9:89b6:c64f with SMTP id
 586e51a60fabf-3e833c8ef9dmr2815132fac.0.1763019624229; Wed, 12 Nov 2025
 23:40:24 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6914f1dd.a70a0220.3124cb.000e.GAE@google.com>
In-Reply-To: <6914f1dd.a70a0220.3124cb.000e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 13 Nov 2025 08:40:12 +0100
X-Gm-Features: AWmQ_blUuO6X2ucXoNlRqaVzKsDJAIjnoIXwlaw5zrIuhO5kPD1Nl6m010o7P20
Message-ID: <CANp29Y4ccgQ8oOxqHOetjkxQ+_kC4scBeXt3k6jG218M_yEXvw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: make vmalloc gfp flags usage more apparent
To: syzbot ci <syzbot+cid2ec7a2d0105f633@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Wed, Nov 12, 2025 at 9:45=E2=80=AFPM syzbot ci
<syzbot+cid2ec7a2d0105f633@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] make vmalloc gfp flags usage more apparent
> https://lore.kernel.org/all/20251112185834.32487-1-vishal.moola@gmail.com
> * [PATCH v2 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
> * [PATCH v2 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation =
gfps
> * [PATCH v2 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
> * [PATCH v2 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
>
> and found the following issue:
> WARNING: kmalloc bug in bpf_prog_alloc_no_stats
>
> Full report is available here:
> https://ci.syzbot.org/series/46d6cb1a-188d-4ff5-8fab-9c58465d74d3
>
> ***
>
> WARNING: kmalloc bug in bpf_prog_alloc_no_stats
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      b179ce312bafcb8c68dc718e015aee79b7939ff0
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/3449e2a5-35e0-4eac-86c6-97ca0ec74=
1d7/config
>
> ------------[ cut here ]------------
> Unexpected gfp: 0x400000 (__GFP_ACCOUNT). Fixing up to gfp: 0xdc0 (GFP_KE=
RNEL|__GFP_ZERO). Fix your code!
> WARNING: mm/vmalloc.c:3938 at vmalloc_fix_flags+0x9c/0xe0, CPU#1: syz-exe=
cutor/6079
> Modules linked in:
> CPU: 1 UID: 0 PID: 6079 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
> Code: 81 e6 1f 52 ee ff 89 74 24 30 81 e3 e0 ad 11 00 89 5c 24 20 90 48 c=
7 c7 40 c3 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 a5 a1 6c ff 90 <0f> 0b 90 90 8b=
 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
> RSP: 0018:ffffc90005557b00 EFLAGS: 00010246
> RAX: a6bff5ae8e950700 RBX: 0000000000000dc0 RCX: ffff888173b29d40
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
> RBP: ffffc90005557b98 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffffbfff1bba6ec R12: 1ffff92000aaaf60
> R13: dffffc0000000000 R14: ffffc90005557b20 R15: ffffc90005557b30
> FS:  000055557c070500(0000) GS:ffff8882a9ec0000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f86f6df0000 CR3: 0000000113d64000 CR4: 00000000000006f0
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
> RIP: 0033:0x7fcbe2f90b0d
> Code: 00 48 89 44 24 18 31 c0 48 8d 44 24 60 c7 04 24 18 00 00 00 48 89 4=
4 24 08 48 8d 44 24 20 48 89 44 24 10 b8 9d 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 1b 48 8b 54 24 18 64 48 2b 14 25 28 00 00 00
> RSP: 002b:00007ffed4000b80 EFLAGS: 00000246 ORIG_RAX: 000000000000009d
> RAX: ffffffffffffffda RBX: 00007fcbe302cf80 RCX: 00007fcbe2f90b0d
> RDX: 00007ffed4000be0 RSI: 0000000000000002 RDI: 0000000000000016
> RBP: 00007ffed4000bf0 R08: 0000000000000006 R09: 0000000000000071
> R10: 0000000000000071 R11: 0000000000000246 R12: 000000000000006d
> R13: 00007ffed4001018 R14: 00007ffed4001298 R15: 0000000000000000
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
> [akpm@linux-foundation.org bpf@vger.kernel.org hch@infradead.org hch@lst.=
de linux-kernel@vger.kernel.org linux-mm@kvack.org urezki@gmail.com vishal.=
moola@gmail.com]
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
-upstream-moderation/6914f1dd.a70a0220.3124cb.000e.GAE%40google.com.
