Received: from mail-qv1-f42.google.com (mail-qv1-f42.google.com [209.85.219.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84CA37E5D0
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 05:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786080299; cv=pass; b=KdNKbAaLrO0yXFn5/gyh339vH2cu3LrGgGcOhGW3OwoxAk3eTXKBU3eXcrIn7cyahqEOyJgZx5IU0gzILir5oEk7goBE+EYUeDMb7P8XjmyfKj8sPe6OeHmx7S/66hYaJWNae99qI+G7wor8ZKsbzL/hQw6wuu2qbeuqgjPkrLk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786080299; c=relaxed/simple;
	bh=3S/68kvH4dLGhyr+clINbpl1ZgPIfzdO6o1mH1iUJh8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O7w7o7qvoNVuSXAfAXSxAMNWzS+uY8hlqTMqKMK+2CPOmzQsE0DPtrOc7uc5VSZ0NFUozkcYLVGhTs5EeAD2OWrJV8oFHXf29NV6feFsbYrOp/Uh3EcjUOgFlqxiQeCaWIJmFrXbSf2n2JwKfnQETl5IHxe/Ih6RLPaq3WJMQrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=eph0Ju94; arc=pass smtp.client-ip=209.85.219.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="eph0Ju94"
Received: by mail-qv1-f42.google.com with SMTP id 6a1803df08f44-8efec2c28f8so19518086d6.2
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 22:24:54 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786080292; cv=none;
        d=google.com; s=arc-20260327;
        b=qskr+gULVtjy5g599J900IlPBPf4IhABAoqn0pGDOz/UqmRQo/d+14mGrSHcvBIwu7
         nUb3P7UY4JKw1zXo1iyl8f3r3hmu7nL5i5eZIiHqhpxjwVio6AEBY1rdRMtpFngm7v3/
         eragTHt3YaUg+a67pxFeDpsEmOMS9jYvRIl9jwR/28UqCIcB3V0LruovphywLOsq8YB7
         sfHWFmS2sbt5f4z+9UYYBHLhOadqFW2uj1orMEHdPDzFe7jLPgrwa5xrWxm2e4ibTnNb
         VyLMRtz6qRMR4I34DVCzNbKHmCdRGHZcZ6FPdPSHcetLsWA8pCsfTscwZKYUUXmDxKgQ
         qatg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=kHd+5C+HmBr7fm2zJtpFBe9TM4ENGoYBtxSBumNdjd8=;
        fh=OVHQIEIo71c1QqJFByM3wrEGM2OhTLYmRWOSeY2xTso=;
        b=b1z+box/6gGzmHwLIz+Yt3eMHK3cy7ZcHP7/uRlGuEfEakym4kvb0V9YRyLl8Gha4E
         lPNGEBJrJFpFeYNeLddW4lfTBH5Om51jccm5XjKL38Q8EdBaKQ2Qvc3EDB2NGo1UPNj0
         WLR4+aol3KaVKbUEze1GxoAY0nJSphnSRweUFi4N7O97SaY+DVfRuFFoum+Ktsee67IR
         KK4PIs5q9TXobPN/BHG7yGBbv7iMxXDeNnPbRt+lRaP/JX7yOFnSzi6eEUj9XyEyUdKQ
         nVISDRn1u/q+xgiMCkVQHmpBKg5/4+36L9WrSImXmCN8C48nQCjHPkqp6Dv52kh6cO/X
         /eCA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786080292; x=1786685092; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=kHd+5C+HmBr7fm2zJtpFBe9TM4ENGoYBtxSBumNdjd8=;
        b=eph0Ju94lAz/GpRuy2QDDPuCpeA8lSSkgEPEnFzqxKHGHa0lRcWNZFqOmG/Vj06GrA
         9+g/LdgQ+OIfAyfw5dtmI+pr0lrDS8MYdPxGbEzgCNFUip8bMYLRKEinSedCm1913/K0
         DpyoY103pV9VsvgyXCVhe1FyYUFA+0YRtwS/u+bbx1T9C1tvwOux5hy/2sSfcVJRjDnH
         tM7hI9zoWoPst9HaQbpuxHS9m12nzAwtwn9sRy10u5pvNi/SGBuaINN8S4WpgIQg+EJ1
         +SEcmvrpw6+p7/lg0NEtfln6bRmrrspqq/CynfFhsknCJ7/CL3ZQIvYdASZomAv+wTvy
         bysg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786080292; x=1786685092;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=kHd+5C+HmBr7fm2zJtpFBe9TM4ENGoYBtxSBumNdjd8=;
        b=tHO/52jyZnkUXSroKVwETUqp2g55xR73EL2y9LEKPp3GYG9SIzsqcQAfuSqt2HcxBJ
         Mz7NRzzAb1fsWgBns6FVT35VlQZxhkifS8Ka3rlcjNh+UdUbAH2zJQxeQkGHoGTBHKSO
         cDunER1zND15X4euaJQBQOcuRrs/5j+cBO1lEouMDDQqnNKAxMEMKQKq+NwxktVmq45q
         0yYGaZLqul5Y5GgWX953Z+eiDNQqrl6Ya5+bQJ12ayOe8QfIRdEW32ZGpYinmTz6RcC+
         chREHkgsDpM/b+BC8SHwuacUL4RHAX8wB0mYIYeNMgtCw3Ch+TkHYxU3ODCCG5YJkVQP
         IcTA==
X-Forwarded-Encrypted: i=1; AHgh+RrHld5Wd9sz7Eq7CO4EBa/MbNaW3QLOET2Mb6W9uqZth3HxZrCrUciOeb7q6bOwEjEE/TYUnQQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YxlvhKQL6JuiVA9Fih1xCoOUNWbQbPWY66xmqEVKXHmCVigHR8S
	lAojhXV8k3o4RY79DQU7hhjgRBT3Hc915UwyEsdzbmvMc171k7z/ZLtjWHFVPCgiASx8u0gBDLa
	PsK73eW7pjVUFhTMkxez+QA5rvSTjkesvHKmNsakP
X-Gm-Gg: AR+sD13XRH9MO4rejp1uHggW3L5yIHNOVV9dXEZG6WFBwIgp3BREowjCSl061wPJqGJ
	gOca2cCa/TwE1H48dlECZN/NDKYBVIuKVjsPThxgFRHWgMRiVhvi8N/83F6vE701b7gcqbkoWVG
	BIzh+/pavDGaND8dBup3DSuDGYMhUYnDUMIHfnRV3Xe2QGBWw6iTH6hn5+mDdBdq0tMLbO9ja8u
	fK1YlNETvd4zWIltn0ch29kC6K8nHf0RsVreeq59cuDUS60QVRpiRX1xgAF1a1Z7y5Bifahcse+
	kqiLWlstOgtZ26M/PiT1A+/4WiH6J7sskwxn2P4XAzIGe/4Xei0aovFnh4GPKDoTzybNezRfEtF
	1atBcDXALxNa7dnMMiY0vVUjL1x4+rvFrN1TSC4hTJ2VZ/Q==
X-Received: by 2002:ad4:5de7:0:b0:8ee:871e:f2e0 with SMTP id
 6a1803df08f44-908a70f43d7mr9045506d6.27.1786080291878; Thu, 06 Aug 2026
 22:24:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a753eed.01d0871a.3a0d52.0037.GAE@google.com>
In-Reply-To: <6a753eed.01d0871a.3a0d52.0037.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Fri, 7 Aug 2026 07:24:41 +0200
X-Gm-Features: AUfX_mw6elW5yeCcQmaIUtNjo8QSWFrAA6xIDe9E91DzEQnj6zk3PFNy-NKGgPk
Message-ID: <CAJWNTGxhvi75aJ7y79c9rdKum561GVqJJAWE0TLLVub-iqB8vg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Virtual Swap Space (Swap Table Edition)
To: syzbot ci <syzbot+ci0044aa36144eea42@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Fri, Aug 7, 2026 at 4:12=E2=80=AFAM syzbot ci
<syzbot+ci0044aa36144eea42@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] Virtual Swap Space (Swap Table Edition)
> https://lore.kernel.org/all/20260806184254.3790858-1-nphamcs@gmail.com
> * [PATCH v3 01/11] mm, swap: add virtual swap device infrastructure
> * [PATCH v3 02/11] mm, swap: support zswap and zeroswap as vswap backends
> * [PATCH v3 03/11] mm, swap: prepare the swap IO path for vswap
> * [PATCH v3 04/11] mm, swap: support physical swap as a vswap backend
> * [PATCH v3 05/11] mm, swap: enable THP swapin for vswap entries
> * [PATCH v3 06/11] mm, swap: write back vswap zswap entries to physical s=
wap
> * [PATCH v3 07/11] mm, swap: reclaim physical slots backing cache-only vs=
wap entries
> * [PATCH v3 08/11] mm, swap: only charge physical swap entries
> * [PATCH v3 09/11] mm, swap: add debugfs counters for vswap
> * [PATCH v3 10/11] mm, swap: defer memcg_table allocation for physical sw=
ap clusters
> * [PATCH v3 11/11] mm, swap: widen swap_info_struct max/pages to unsigned=
 long
>
> and found the following issue:
> KASAN: null-ptr-deref Read in swap_entry_backend_has_flag
>
> Full report is available here:
> https://ci.syzbot.org/series/e7da1097-3230-4e50-80cb-1dfafeebea40
>
> ***
>
> KASAN: null-ptr-deref Read in swap_entry_backend_has_flag
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      bacc32cc7de65ffff70080a48eb294f89e434d5e
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/4f943657-9481-4637-9b1f-9be1bff18=
f92/config
> syz repro: https://ci.syzbot.org/findings/f6c4f1ab-951c-4759-b397-e22c23c=
3bf32/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: null-ptr-deref in instrument_atomic_read include/linux/instru=
mented.h:82 [inline]
> BUG: KASAN: null-ptr-deref in atomic_long_read include/linux/atomic/atomi=
c-instrumented.h:3188 [inline]
> BUG: KASAN: null-ptr-deref in __vtable_get mm/vswap.h:147 [inline]
> BUG: KASAN: null-ptr-deref in vswap_to_phys mm/vswap.h:197 [inline]
> BUG: KASAN: null-ptr-deref in swap_entry_backend_has_flag+0xfe/0x220 mm/v=
swap.h:441
> Read of size 8 at addr 0000000000000000 by task syz.2.20/5818
>
> CPU: 1 UID: 0 PID: 5818 Comm: syz.2.20 Not tainted syzkaller #0 PREEMPT(f=
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
>  __vtable_get mm/vswap.h:147 [inline]
>  vswap_to_phys mm/vswap.h:197 [inline]
>  swap_entry_backend_has_flag+0xfe/0x220 mm/vswap.h:441
>  do_swap_page+0x3c0/0x5620 mm/memory.c:4975
>  __collapse_huge_page_swapin mm/khugepaged.c:1202 [inline]
>  collapse_huge_page mm/khugepaged.c:1325 [inline]
>  mthp_collapse mm/khugepaged.c:1524 [inline]
>  collapse_scan_pmd mm/khugepaged.c:1786 [inline]
>  collapse_single_pmd+0x24c6/0x3da0 mm/khugepaged.c:2803
>  madvise_collapse+0x2cf/0x790 mm/khugepaged.c:3237
>  madvise_vma_behavior+0x115f/0x4170 mm/madvise.c:1363
>  madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1712
>  madvise_do_behavior+0x385/0x540 mm/madvise.c:1907
>  do_madvise+0x327/0x3a0 mm/madvise.c:2005
>  __do_sys_madvise mm/madvise.c:2014 [inline]
>  __se_sys_madvise mm/madvise.c:2012 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fbcad79e019
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fbcae5c4028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fbcada25fa0 RCX: 00007fbcad79e019
> RDX: 0000000000000019 RSI: 0000000000c00000 RDI: 0000200000000000
> RBP: 00007fbcad83500c R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fbcada26038 R14: 00007fbcada25fa0 R15: 00007fff095fa0b8
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org bao=
quan.he@linux.dev cgroups@vger.kernel.org chengming.zhou@linux.dev chrisl@k=
ernel.org corbet@lwn.net david@kernel.org gourry@gourry.net hannes@cmpxchg.=
org haowenchao22@gmail.com kasong@tencent.com kernel-team@meta.com liam@inf=
radead.org linux-doc@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@=
kvack.org ljs@kernel.org mhocko@kernel.org muchun.song@linux.dev nphamcs@gm=
ail.com qi.zheng@linux.dev riel@surriel.com roman.gushchin@linux.dev rppt@k=
ernel.org shakeel.butt@linux.dev shikemeng@huaweicloud.com surenb@google.co=
m vbabka@kernel.org weixugc@google.com yosry@kernel.org youngjun.park@lge.c=
om yuanchu@google.com]
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
-upstream-moderation/6a753eed.01d0871a.3a0d52.0037.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
