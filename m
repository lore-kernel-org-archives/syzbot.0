Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.48
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1793142493;
	b=zuRK5LlC2pOTqkzSmoeuwI9CL+eGSA8ss/XR9/kx2M1KbI2uHe8ZnLtnfLh8FZZOBXze
	 pZg2t6VM38SbhqwGjMtVxPDCi5Mfz5y2G/AMBeS8xhu02GwnPna72cuKBgBgxjtRTaltP
	 ewwT7jcopqmsGBrqEFN9hJFiANsXIFDQNX8JezUbKAHIweW2ePZyFlmFsaCwZkbVQZ8rG
	 bXAU2lannnz+RYgvMY4yKL+yewRIunQd9cf8tsl9sE5D7AWNTgQH2x2/yrZ7fcDXTGq1j
	 biNQ5QoUITacq2rUYgd4HibdV3REoyNO6c4+qp9r//ygeCZMCdxLR/ssKsS5fhbNXvg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793142493;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=UQu+77+Ip0Kp6e6a1oqWj/9NZI2ZizK3K3ZIzdzcbHo=;
	b=kHC1VmdvBG4nO9W3VQRABH3lsQFP3WNtTFTGconZskUxG96NRJ9t0CCfHMTyko0gAze5
	 EetxDnp63OnKgThqH8Fz+LvhX/NGZThN07Gzdi9oi7hDAvNP4L0X1A5+dmkmzbaX1vH/d
	 1ikL1ABguOipusG/pLn6fiUf5rQJThG1/XwMGluiXwqfEwnwRjw0hW6A3l/QZ5iFPZvUY
	 OLNmJDe9Ds4ynWonNl7Skuso0rOUBgqlKnTvo3PgFAdYCXqXcuB4S7+Bzk9qZ9h5LUbUe
	 wnCHnsGtDpqftGchUS7vObERCJS4i/WAyEdxAQUorPpSO/jhHu4Xt6UsiiS2OxefvpA==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XMx4Jcb6;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.161.48
Received: from mail-oo1-f48.google.com (mail-oo1-f48.google.com [209.85.161.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D7F1606A31A
	for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 23:08:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3D7F1606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=XMx4Jcb6
Received: by mail-oo1-f48.google.com with SMTP id 006d021491bc7-6d68de53053so261191eaf.0
        for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 16:08:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1793142492; cv=none;
        d=google.com; s=arc-20260327;
        b=UgY0YXpplvs9aShQQeXO+IPWwft1bHj6dTZJ6QuImDqMPIseaeI9u3SWBY4BdQXi13
         q81bMebRQ4md/I66UL7xVLXJtAav30mvmQUjwfAA0si832akJqFNxYuFSFlJ7AQFoQ8J
         Ej/0QC+hL/da+RfzHWFaVdc2FcBGdT5MBltjP8B2jMaTirV5lJ9iTNg7p1HLb95bxD2P
         0f3JsmehNZQega5vuKuHh8FV34q02VijxarvmG5QtX+ss9ySUTqyYJQjG6Xs/Csxs7N0
         K63LRSOWYznUm+hInT6EVaUtxxLOh80WQLBPqoSqr/r3fXSxpDS7F/GtHyONlA2LQAjc
         UAyw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UQu+77+Ip0Kp6e6a1oqWj/9NZI2ZizK3K3ZIzdzcbHo=;
        fh=X1gXuDP45AMsA+FwmQiPLUDDoKWtZbvSK/fKpdQx7So=;
        b=rXHDPjYfWPjxJVoe14DCKBmWNU7Sc5z+NKduErY2/XSAilUZVAboEtotYzkFKV0QiD
         163NZpf7Hfr7qNqysSkChHZRETydpdbjSYDpk5wOz2cF7nAnwaLqxAQFMT2Rkhonl7+g
         wCDhwkISInxWUq3Abnce7OLnzDryCic5By0dNNwKAiyjLQm/45ggHvtGDgEDKrYDmD/N
         ScWbSKFZDDLmf2BpbV6XxyacHb7DWglYwav2qQDgtwjpttzPHFCjHxXHXQzghDuK1v9x
         maIXAkiQnpkpuArirL3T+AuMwOn+MRuHPqAHBtqEt1zmKgICIQSNyHuUv+iW9HoiihjG
         POmQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1793142492; x=1793747292; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=UQu+77+Ip0Kp6e6a1oqWj/9NZI2ZizK3K3ZIzdzcbHo=;
        b=XMx4Jcb6RHFmxIwNCcYQz8qv5r0JG6ZGmko2vJRTVWyYBiXsugnv5mk8DJb9fD+WuX
         6qP0JP6Y5pvZCJJaoQ4qK8sB9kjWcsJ5UrsY57ato15pp0cqvzGqa7JewXCy2NopR+1J
         sLIKgsgPLgoFsf6eGi+l1m2vshceh37JoJX96l0TWcVkN5qPeSrDeR46hRf19yeZTHda
         RbrJdx1EBRnZgBVI5tF/EiaCyh/Xm7Yj5C04k73bsmQmupE+WO4fVYKxpJ8iSSzCoJXA
         ZNDi84wvPl8fGIq5mxyXaBx2nAIN2VPKW9ASMLaPNIIxEvC+epST/iGrP4JvelKshru5
         sTpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793142492; x=1793747292;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UQu+77+Ip0Kp6e6a1oqWj/9NZI2ZizK3K3ZIzdzcbHo=;
        b=Dyaq8SfbTTW5AMJTj3/iQFPIVVWBWyD90NuWEXbLWuwaMTabLK6LxxMbI2IeH8ae2L
         FRyLlJukrWKGlyu3/O+vnLvZfDi8ChSTLpsfvIEyz/BcYkEXqEWT9jyXs/4gQvw/UUZ/
         Ukg4Y8aYqR7Ua5rR35aNhXaQuHYTFUldr622S+U02QWZhCTnLiZrmGJWiiWlamz4qMrF
         W9E2pDX1t6iv6fWYxBr4yElHr1+CHX6jevLVYiahNxnuYRxNwwWbD1Y7OqvGCb7ikTYn
         DUogUsAYXntY3ZWd4aoV8aiHGKr3shNQ3Zi99b3d+VyHf4WJdYy3xzKkEOQ3mr18pe0M
         nULw==
X-Forwarded-Encrypted: i=1; AKwUvBzzze38bE8RHv7r3dNZcvpQPlRQ5XVD8FYH40a2tb/FGfdOrozYz1hBPpTKxJhpAVXgeklG4ec=@lists.linux.dev
X-Gm-Message-State: AFq9FYKDHwRroyo8CfXpEX4HC2NhCE46+z61THEHnt8hod8OPFhcQMqs
	m0YmyMooGmrIvaKlCCMtTVfph7CkXycYb5tIddp1/8GuNuXO7EoqPe5I4RUouBTXuSRehYduceH
	hgER9U2B42XKPN8XayDqoLe1/ZjYk3Eeuj3vH72YN4n+dt32S1ssj5mka
X-Gm-Gg: AYBFou0so2w4CYgnKohKf9ijZxblbTKZU8HP0RBQR3BRlsTrZnOuuNHIZiVW5wD5mt6
	JdWJE9c/gpsakHbosZjPvDTbAMLOE7ZEdHmxYpMJvhgVn1cEI/Q+yqhiL1eWSuzUXwTbtwlKN4Q
	MYc+C56FRbeQQbFyuo50dFjE9wYcMS8cD2q5L4HBq8aNz3q6FZAQQ2wN75Rs7ESGGG9VkxuYYfU
	vV+GR/n9MiMp4oOTT0xNzOI0gIpX+WrKJIKD47E09ZnNliytM41UQsGd6JQbz3KZcYUZfkOPgO4
	Og/wPTzWOLKIMT0Vq09f6gDqJhJtn1jK5J/ack/LPtHgdl9SpVpTDRFaaOV7+6owWY4ZjSTnbaN
	wcVf/pu1lJpv9QWh300phV+5ymjVHbLW1bxTih0UwMNWfRuLJ8meu2soabgUM30cUnEijJ0RYxw
	D0Mg6GXf1s+9qEo82d/XXwKE2OcPg7QzrYFmbufI32KEUDDkf78AlILzjqvp6o0AFKubwbHK+2I
	m6Ef3B3fQ==
X-Received: by 2002:a05:6820:f002:b0:704:b7df:f29c with SMTP id
 006d021491bc7-713ec51212emr381507eaf.10.1793142491512; Tue, 27 Oct 2026
 16:08:11 -0700 (PDT)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6ae12943.47d0a7c9.33355c.007e.GAE@google.com>
In-Reply-To: <6ae12943.47d0a7c9.33355c.007e.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 28 Oct 2026 00:08:00 +0100
X-Gm-Features: AclHuK_wJdigAP3fnGjxMHpQIRg1fM5fR-mDGKall_fdBUSXJzIKOy3n_YYKDfc
Message-ID: <CANp29Y78hZ=BNrjyupUixi6CehF4vV92S0AbE6JPeLobi3YzDw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: clear pmd in pmdp_invalidate()
To: syzbot ci <syzbot+ci0915606b3d8f5335@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Oct 27, 2026 at 11:44=E2=80=AFPM syzbot ci
<syzbot+ci0915606b3d8f5335@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm: clear pmd in pmdp_invalidate()
> https://lore.kernel.org/all/20261027113813.1332096-1-trintaeoitogc@gmail.=
com
> * [PATCH] mm: clear pmd in pmdp_invalidate()
>
> and found the following issue:
> kernel BUG in page_table_check_clear
>
> Full report is available here:
> https://ci.syzbot.org/series/ea6c690b-0dbf-4e3e-8367-2b5092d2878d
>
> ***
>
> kernel BUG in page_table_check_clear
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      01146870c415f6ff70a469fb7ceb962a3f2c8c52
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/b4be77d2-e026-48a2-b906-ba8967ba2=
d37/config
> syz repro: https://ci.syzbot.org/findings/8fa94c36-acda-4fe5-a760-1dea609=
77f77/syz_repro
>
> ------------[ cut here ]------------
> kernel BUG at mm/page_table_check.c:83!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 5817 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:page_table_check_clear+0x4ec/0x500 mm/page_table_check.c:83
> Code: 89 e7 e8 f7 1a f4 ff e9 bd fb ff ff e8 4d 37 83 ff 90 0f 0b e8 45 3=
7 83 ff 90 0f 0b e8 3d 37 83 ff 90 0f 0b e8 35 37 83 ff 90 <0f> 0b e8 2d 37=
 83 ff 90 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 90 90
> RSP: 0018:ffffc900035eed50 EFLAGS: 00010293
> RAX: ffffffff8244dd9b RBX: 0000000000000200 RCX: ffff88810d88bc00
> RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
> RBP: ffff888104dea000 R08: ffff888104dea04b R09: 1ffff110209bd409
> R10: dffffc0000000000 R11: ffffed10209bd40a R12: 00000000ffffffff
> R13: 0000000000000001 R14: ffff888104dea048 R15: 0000000000116200
> FS:  00007f8b11ee36c0(0000) GS:ffff88818c4c0000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000140 CR3: 0000000112c36000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  page_table_check_pmd_clear include/linux/page_table_check.h:64 [inline]
>  pmdp_invalidate+0x2fc/0x310 mm/pgtable-generic.c:206
>  __split_huge_pmd_locked mm/huge_memory.c:3323 [inline]
>  split_huge_pmd_locked+0x100a/0x2e50 mm/huge_memory.c:3476
>  __split_huge_pmd+0x202/0x2e0 mm/huge_memory.c:3490
>  zap_pmd_range mm/memory.c:2136 [inline]
>  zap_pud_range mm/memory.c:2179 [inline]
>  zap_p4d_range mm/memory.c:2200 [inline]
>  __zap_vma_range+0xb85/0x4f80 mm/memory.c:2240
>  zap_vma_range_batched+0x3e0/0x5b0 mm/memory.c:2351
>  madvise_dontneed_single_vma mm/madvise.c:868 [inline]
>  madvise_dontneed_free mm/madvise.c:959 [inline]
>  madvise_vma_behavior+0x252b/0x41d0 mm/madvise.c:1370
>  madvise_walk_vmas+0x924/0xb00 mm/madvise.c:1687
>  madvise_do_behavior+0x385/0x540 mm/madvise.c:1916
>  do_madvise+0x327/0x3a0 mm/madvise.c:2014
>  __do_sys_madvise mm/madvise.c:2023 [inline]
>  __se_sys_madvise mm/madvise.c:2021 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2021
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8b10f9f559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f8b11ee3028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007f8b11225fa0 RCX: 00007f8b10f9f559
> RDX: 0000000000000004 RSI: 0000000000003000 RDI: 000020000015e000
> RBP: 00007f8b11036b20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f8b11226038 R14: 00007f8b11225fa0 R15: 00007fff02a6aba8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:page_table_check_clear+0x4ec/0x500 mm/page_table_check.c:83
> Code: 89 e7 e8 f7 1a f4 ff e9 bd fb ff ff e8 4d 37 83 ff 90 0f 0b e8 45 3=
7 83 ff 90 0f 0b e8 3d 37 83 ff 90 0f 0b e8 35 37 83 ff 90 <0f> 0b e8 2d 37=
 83 ff 90 0f 0b 66 2e 0f 1f 84 00 00 00 00 00 90 90
> RSP: 0018:ffffc900035eed50 EFLAGS: 00010293
> RAX: ffffffff8244dd9b RBX: 0000000000000200 RCX: ffff88810d88bc00
> RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
> RBP: ffff888104dea000 R08: ffff888104dea04b R09: 1ffff110209bd409
> R10: dffffc0000000000 R11: ffffed10209bd40a R12: 00000000ffffffff
> R13: 0000000000000001 R14: ffff888104dea048 R15: 0000000000116200
> FS:  00007f8b11ee36c0(0000) GS:ffff88818c4c0000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000140 CR3: 0000000112c36000 CR4: 00000000000006f0
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
> [akpm@linux-foundation.org david@kernel.org liam@infradead.org linux-kern=
el@vger.kernel.org linux-mm@kvack.org ljs@kernel.org mhocko@suse.com rppt@k=
ernel.org surenb@google.com trintaeoitogc@gmail.com vbabka@kernel.org]
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
-upstream-moderation/6ae12943.47d0a7c9.33355c.007e.GAE%40google.com.
