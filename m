Received: from mail-vs2-f40.google.com (mail-vs2-f40.google.com [74.125.227.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2355D4A8A39
	for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 13:40:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.227.40
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789998014; cv=pass; b=HrCX7CoK4MSArMSv8z/9HTktrfZ7goFz3x5QCPtSVYjNkYGf/wHWYWKdlbPZlzXVgjc78jpvvpksBCL6wIucGC6YA8VHzVaIew5qxmKthqxpGJGCym0IBllE1y0SY0D0vAxWqwDoXJo/LESDuN/W2sG49dVBriJyHQE+F+wp06c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789998014; c=relaxed/simple;
	bh=SU3B6jdUdZSJ0E0+FjnTGnN587BpVAenvhNibyn0JQ4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=f5Gdloe1POhsLlrn6JxTFvfO2Ip3NXEZD+Epx5TWgKtq8NQ2gPdAlAaC4q45hGhAlVrQbbEV4pB5CN1KB3ikboZC52nQWHgv63rmmdaCtKrIzhTd149IubtXxbTekt7xPmO2qCE0CwIxTCqzYNyiRczu2KmbF2v8wm28vpvH7uE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MKlVBmVr; arc=pass smtp.client-ip=74.125.227.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MKlVBmVr"
Received: by mail-vs2-f40.google.com with SMTP id ada2fe7eead31-78a4c5c582eso927974137.3
        for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 06:40:10 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789998008; cv=none;
        d=google.com; s=arc-20260327;
        b=igV5LFyCVJ1b98l45yYUpfWaeAuSRDvH2qR9m87Fcyc7720O6nxwqN4QlIO1DwYw7H
         cRK4B5C6/bcKuKVz5PN5XYWyP8Z+oskSJ01qmWcGVexT2J7bn65qye3JBVIvw52q/v2v
         ykXgDkFCdLHOdlS24W/dclrTGfgphBdygvnDFI1aIsdLQEn5/DsBOuxNQ4vmoYVINefZ
         otQbs4ZwwMnt96axOaNGTiEjJ1ueeHau8RwZhgsZQuNQP4kdEiqepmXwzSGED4DaKil1
         O5x0vBVkwFfAMMUySUhlXDqnQZLFo8xpt8qqMZVCcS3BF1bvFHmPmqF25zXMWpgE0ZdW
         DSrw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7BEyqoEXgzbClZ6WBL+ZjnQOWvzZSCh4VOzBJoEKfkc=;
        fh=zKR86Kfvzn27LotfflFEAUxwiw09cqRrKz5LyNW4FnQ=;
        b=eIDIa0toTsDQCH/FjMjBGmo9l22RvL9VNdJrK6g1cnPVFTC3N7HkAQb2nHdO3lgc6b
         lGXAGVQBcRBUHKJm+QX8eR+cMlwtz6xH0u1nuWZ742hnR4WA7oanjOFbGUW8rFY1OkqM
         oMTJyHZTVWd+1m0Ta/AEaduOQnMiAMhkqGYoB+WSLCTnSoIIhdQy47sV1l4fgzGZt5fs
         h32rU0FLe5/5C52dhZeOqd1+yqnkHCRxPcLptovcCUB1lgs31/j5hhjCeMFHHq+Sgd0b
         6+5yrFFMDS4RfJL6+EJol6YIz/M3CoE1Jt/LULKdv87Pilbe6GyDXPRyKKZazhFjkXEW
         EMAQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789998008; x=1790602808; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7BEyqoEXgzbClZ6WBL+ZjnQOWvzZSCh4VOzBJoEKfkc=;
        b=MKlVBmVrtShS9nA74dsNZNaqBMZIw3jTaruN/ytHJnI53aalgNHvP8/9GYtsmZgqSu
         pFGNQwg9K7de76kov7Q/jo+mUZI9hqEb9UtxQeKdc+hVY6Wd3nPXneyzQ/XskIF4C6y5
         teXBkRFmoXi7ZjEyvTUeLz0PVKjKcfLhNeflr7/928YeuhJnDXsilVISoDLXOBi8LxpW
         hiuKJ/6jljDSaZmOYlbe7wVTyVa6/Vj6aQ5HOhMF/imMX9rWarmCRljU50GQk0wrYfT4
         7ERNrngIunccGjUU1XUCY/4umELw2Kw8Bn7Rs+l+5C3a3FNc/a0QUBybtnneUTEaYTDY
         jChg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789998008; x=1790602808;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7BEyqoEXgzbClZ6WBL+ZjnQOWvzZSCh4VOzBJoEKfkc=;
        b=mYaE2mFlBWtRpJHfxlP7yxJEjUAsRws7p3lyupb525oXN217EXZTQwGJwzT4qlkBXu
         00dHINTqkFUfuabaGgDUnHUgbULifC10gSeigtvKowgE3IraAejdh06Xky7FibgXtafq
         eaEE/yo4TptnmMlQ667ydnjObGTF73yqh801Tfn4F4mKdyU90h3kWBd5wJdIdr0yAZ3p
         BiQ65FEHIbHdbN6HhaE8ukQO4tOXgUjPvwfG+KMABOQxoEvEhziEIE8M4/GOxvr/qg11
         b0ZE8cHbLA3Y+dU6fx7Cl9reWCu9Cojtr8ZZP2jBNMDT4RVsGx1+S7/jTHyQVw8ob+Zs
         lsbQ==
X-Forwarded-Encrypted: i=1; AKwUvBwHrY28BgGiMzayrnRt2dzRcOZaTuXyD3DjZqhGr7+qW7LxOeSKXAuk+mG/3V2OSbyNyJuMLuc=@lists.linux.dev
X-Gm-Message-State: AFuF++mw5yZFixo7qOMSY7ShvyllMTkNN9Q9j5bq53K0DsGpBPf1ScDE
	1uSuhjrce6kBPfrQZEsChchBJ/J5WKxUB5Q1cXTWniMbNkyuS1pUNpxQ/6dzTDIXXCUE8VxHNUb
	ZFXVtITFoMLm7ioysIoEPspBmdvemKCAZIgh4DXngFhuRK21KRhTuVvBH7to=
X-Gm-Gg: AYBFou2gnsZRSzNbzSzCz7nBRi0zzIitnQnAKHgZKo01aM4k9SIARGlq64s8QbshAgQ
	MGHaC7DRp0S9ueAQlzDFDMAT+xAEmoXt2WtEp1nNJZ+4ZxnSf5jP0MhBYuTKEcgHKEJu2CvmHE3
	FlaHbF3EhNRcfJtuEmu34AaQsDf1VL7CLe1uBi1O1RWfBL7lNP6FfNZN8UiJhDoJoYynybH+VSQ
	/6rIZZDkhP1AGRoDlmz+ehqV5uLC0JIdKhShe61XblkyV1dqQ75mvJxmiH0E0RlBTPWHfarTTV+
	hXXX61lSnOZhQ8FjPkJI6YawLOKlb02iufSU3NjOzuwlTlT4JOh+D2gpPBzZTUnfl2uXDP+miez
	OFIJEaDS+0piI9HIj5WrAoOjLiHIiJsm6W6r8/CFwxg==
X-Received: by 2002:a05:6102:5cc5:b0:79a:21f6:20fc with SMTP id
 ada2fe7eead31-7a55a524c55mr3799756137.10.1789998007542; Mon, 21 Sep 2026
 06:40:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ab0a46c.71f81b7d.15fa6d.0021.GAE@google.com>
In-Reply-To: <6ab0a46c.71f81b7d.15fa6d.0021.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Mon, 21 Sep 2026 09:39:54 -0400
X-Gm-Features: AcwNN1U0IirhJ1BjxAa0V5qTvZAv4Mf_uW3ZzC8Sd34j6G4rNSEMCG9MusyETR8
Message-ID: <CAJWNTGxUv07jW6tJvk_PN5YTFznhtk_wqxDRuuo_KKztnFmZ_Q@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Virtual Swap Space (Swap Table Edition)
To: syzbot ci <syzbot+ci01ec2893db94831b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sun, Sep 20, 2026 at 11:28=E2=80=AFPM syzbot ci
<syzbot+ci01ec2893db94831b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v5] Virtual Swap Space (Swap Table Edition)
> https://lore.kernel.org/all/20260918180241.3424851-1-nphamcs@gmail.com
> * [PATCH v5 01/11] mm, swap: add virtual swap device infrastructure
> * [PATCH v5 02/11] mm, swap: support zswap and zero-filled swap pages as =
vswap backends
> * [PATCH v5 03/11] mm, swap: prepare the swap IO path for vswap
> * [PATCH v5 04/11] mm, swap: support physical swap as a vswap backend
> * [PATCH v5 05/11] mm, swap: enable THP swapin for vswap entries
> * [PATCH v5 06/11] mm, swap: write back vswap zswap entries to physical s=
wap
> * [PATCH v5 07/11] mm, swap: reclaim physical slots backing cache-only vs=
wap entries
> * [PATCH v5 08/11] mm, swap: only charge physical swap entries
> * [PATCH v5 09/11] mm, swap: add debugfs counters for vswap
> * [PATCH v5 10/11] mm, swap: defer memcg_table allocation for physical sw=
ap clusters
> * [RFC PATCH v5 11/11] mm, swap: back vswap clusters with a VM_SPARSE arr=
ay
>
> and found the following issue:
> KASAN: null-ptr-deref Read in swap_entry_backend_has_flag
>
> Full report is available here:
> https://ci.syzbot.org/series/713f2473-328a-4c16-8bce-63005d15a338
>
> ***
>
> KASAN: null-ptr-deref Read in swap_entry_backend_has_flag
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      27e4e1835109ef599d72abe6c09711e0b1916033
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/26b06329-3b1c-4c73-8ee3-64c53b995=
186/config
> syz repro: https://ci.syzbot.org/findings/f743742b-1934-4b4e-a590-9a36592=
da902/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instru=
mented.h:82 [inline]
> BUG: KASAN: null-ptr-deref in atomic_long_read include/linux/atomic/atomi=
c-instrumented.h:3188 [inline]
> BUG: KASAN: null-ptr-deref in __vtable_get mm/vswap.h:163 [inline]
> BUG: KASAN: null-ptr-deref in vswap_to_phys mm/vswap.h:202 [inline]
> BUG: KASAN: null-ptr-deref in swap_entry_backend_has_flag+0xea/0x210 mm/v=
swap.h:409
> Read of size 8 at addr 0000000000000e00 by task syz.1.38/5916
>
> CPU: 1 UID: 0 PID: 5916 Comm: syz.1.38 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  check_region_inline mm/kasan/generic.c:-1 [inline]
>  kasan_check_range+0x264/0x2c0 mm/kasan/generic.c:200
>  instrument_atomic_read include/linux/instrumented.h:82 [inline]
>  atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline=
]
>  __vtable_get mm/vswap.h:163 [inline]
>  vswap_to_phys mm/vswap.h:202 [inline]
>  swap_entry_backend_has_flag+0xea/0x210 mm/vswap.h:409
>  do_swap_page+0x767/0x5a20 mm/memory.c:5042
>  __collapse_huge_page_swapin mm/khugepaged.c:1152 [inline]
>  collapse_huge_page mm/khugepaged.c:1271 [inline]
>  mthp_collapse mm/khugepaged.c:1469 [inline]
>  collapse_run_pmd+0xaf1/0x5d90 mm/khugepaged.c:2811
>  madvise_collapse mm/madvise.c:1026 [inline]
>  madvise_vma_behavior+0x17cf/0x4d80 mm/madvise.c:1548
>  madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1896
>  madvise_do_behavior+0x385/0x540 mm/madvise.c:2091
>  do_madvise+0x26f/0x330 mm/madvise.c:2189
>  __do_sys_madvise mm/madvise.c:2198 [inline]
>  __se_sys_madvise mm/madvise.c:2196 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2196
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7b5939e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f7b5a1ff028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007f7b59625fa0 RCX: 00007f7b5939e159
> RDX: 0000000000000019 RSI: 0000000000c00000 RDI: 0000200000000000
> RBP: 00007f7b5943506b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f7b59626038 R14: 00007f7b59625fa0 R15: 00007ffe5f2d8d38
>  </TASK>
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
> [akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org bao=
lin.wang@linux.alibaba.com baoquan.he@linux.dev cgroups@vger.kernel.org che=
ngming.zhou@linux.dev chrisl@kernel.org corbet@lwn.net david@kernel.org gou=
rry@gourry.net hannes@cmpxchg.org haowenchao22@gmail.com hughd@google.com k=
asong@tencent.com kernel-team@meta.com kunwu.chan@linux.dev liam@infradead.=
org linux-doc@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.o=
rg ljs@kernel.org mhocko@kernel.org mkoutny@suse.com muchun.song@linux.dev =
nphamcs@gmail.com qi.zheng@linux.dev riel@surriel.com roman.gushchin@linux.=
dev rppt@kernel.org shakeel.butt@linux.dev shikemeng@huaweicloud.com skhan@=
linuxfoundation.org surenb@google.com tj@kernel.org vbabka@kernel.org weixu=
gc@google.com yosry@kernel.org youngjun.park@lge.com yuanchu@google.com]
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
-upstream-moderation/6ab0a46c.71f81b7d.15fa6d.0021.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
