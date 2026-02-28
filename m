Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6408D33BBA7
	for <syzbot@lists.linux.dev>; Sat, 28 Feb 2026 11:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772277537; cv=pass; b=h0Lm4GfCTqGAd/ZLmV0H0bqhOc2PSiljPPvBQiBMoVz6vOyiM3LB8pgVJwnmOLhGk0mmVjHibmPDCjyQzuDBVLb+wRnPwjhztmT4+MBLQMjiaxrIiXCHXeJUxfPqo9v30NN9Z5xWaOVMoUuVh0RBm+6lZdBNwrEOV4MNkukdAX8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772277537; c=relaxed/simple;
	bh=K47sEdgu79MJLNHzrHwkSECXNl5N/joJR2prLaLjD/U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dzCVMB72Eh/DNaI0ZOzwOcf27YhH2/PFS7bxgWdckBWFRkAjViprDAbMSj5FZzsGhuujQpJ9ni6JCyxgN6tZS6ubEmmOidkwEu/LjhI3Tw4f0F0LEMOMmhpJrO0WVmS8V9D6681Kmo1qY3wXCpmQfuWrIkDifrRkFUdKwSMZqdc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n3lBAaK3; arc=pass smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n3lBAaK3"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-65c5a778923so4674527a12.2
        for <syzbot@lists.linux.dev>; Sat, 28 Feb 2026 03:18:55 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1772277534; cv=none;
        d=google.com; s=arc-20240605;
        b=Mi2ZpHYgFHMISgCTydphM5Y7lgybJC3/8UJsKb7wGZ2I/lfRsPlS17WXG3zizG8NvK
         j8aOwTAE7sym3Pin7Ig0gDQf4gZF6c/oymO++bXR2eMC0lXDRzJEVfVuIJ3XR+Z1A5Vm
         BeQ1IXa401TF/JHd3dJndznHPbb2P9C/ppsaHVaJ/nlxm6w0V2FMSKQAHaGgn6tjtN09
         3j7NyL+4O/1vB8xBjS+K+Q7DKj3bK4XRHfD1dcODmXl6EkzZbhvf6DVqDB/1PwyWUKCc
         yZClK977kE1QM8v6jG9LzXGSDrH0xH/tuSLRcYHPb40WR7Jyfiyq5zDz4wX10cXjogUQ
         LH3A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Q7B5gWlBU4fhTmPaG9OOssdXbm1ec/Fb01Efwx6XTv0=;
        fh=82jcp7m7hEZqEJqJTWpSlvcHVk6yKGiaDh76tddb1yM=;
        b=jyf4LuVRjPAzrWIw/4ZRCuuzv/cK81icWiV2zYf3PrfkFYrpJDzFS699PK73ihDRdl
         u1c89L+YtAZazJPInPPAhW0+NRWe15j47/opdsxit9W9jRtfIv9+NWY9hihRQ/OsLnJc
         tIYw9I4xrfVteDXGcJu1crmjI3BnYjNrxaHYspEb9QbSWRz680qZdXAjNXoQJxVyh9fl
         pPMP1RU1i74m7uiWz7/hUasoEsunA4LDfCAOXPn+c6kHbHN9GUDM9Vl/AtgHPZjC44KZ
         w1a/7ipO1A4XQHxYricNKxqn12Az57xgfpSBKSSqJ9pT2dF/aME3MyqDwP1ElSGGpD85
         j15w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772277534; x=1772882334; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q7B5gWlBU4fhTmPaG9OOssdXbm1ec/Fb01Efwx6XTv0=;
        b=n3lBAaK3sE7Fg2nuPIZQrkU3RNpJuLg1TAcIbymAOiBLUBl7T94mxu52sJLnNwkfnw
         UMS/K1mbxe54rJ5YjNscd78IOA5NJ9XOqFKMpnszQYYRAsO2GCtp1v0SJFNz8TvHIaDT
         ObgHcE3HOOqtZGllvDEnVCQx3cL/9ywbDLuw78gl40KFXMzS2NmqTxIVlgUVCmdxnUNT
         oHWQQCGpoY8LI+OGmQDFVocpTofK9tJMH90n1HuYZHV/JhBMDrcSYlK9131buZC07OqI
         0LjTB1yEaa+QO3FzoRJOYUY0BJRr4+ePHRkSD5XNHbIpifC8UPMs7RHATa1yFarF2yFS
         kC5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772277534; x=1772882334;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Q7B5gWlBU4fhTmPaG9OOssdXbm1ec/Fb01Efwx6XTv0=;
        b=hxLOnQ9byTQwUoV25MYAfVjXjDWkqdeSn79HBc7KqDvkmLJTVhdZ9+Mhwzlko+IaPX
         cNxZoyee6eB4NecwCy3sLJFhRx6p+U12pwZpOxrYSMzihYQ3LTo3o0lgsd6FiPqmcKlF
         hOq0F+xiEoIhxwzebx2p6MKuFtI7qeyEfnyxG5qsQVJx+A3mJAZ2AJEVN7Gida5h/p4p
         o/8dZYJ0j+2Nbmzv/fUfUisGgt9YaEfBHf2IPqXl4m/fZEQoLQ8HSzPpbRYcKQSucKsE
         Xzoa9lY/EwDN5edvFDGvta3ZMtbZxfDCz4sBWua3D1W0hgy4xJ4oeSRCy5MPOrEc4Xal
         pa4Q==
X-Forwarded-Encrypted: i=1; AJvYcCUsagPh1xrseZzs8G+Wro83HpzmoxJgsIn9Hr0zVMa6f6PJbqW9JU9l4eb8Lw1m3SXh335qj8o=@lists.linux.dev
X-Gm-Message-State: AOJu0YzcfXbkrUnVAPjq44Tu2cbxaApPjF3/O87f0bFD0waD+uBzjVX9
	rVfdxcttTblRikQ1S4+v5ibPJM7gfEcs48xAi8+O98eEWgQJLGBj3D8VLdaJ2OVawMsYKApBAbZ
	2dzLfwF2wenNprBQsJ+lU/pHbeXWaZFd42X0Vsiyw
X-Gm-Gg: ATEYQzyxfFun+16ufp6W5j9RTvjo9tQGP0yk6gfe6bCQ3pj8AjYY4HVJe1+1ONzUCNg
	ZfR4R3Xo/Ol52iSSkn3vPY+GjCdilPja2gPfyEffcCL3DtWTyS5A3BZGhlsRhAt0H+9JL6GwOHC
	lRkiaIcce3z8lJ6kdew8/Solpk+EMednO9fIwMA/duPsbR+ZRglb4FWxx5/KtRliLK81lTIgsLn
	RqsMv5O9m+GKDLpFctuOrmCMmKFp4ygNQqmI0sQa/qjBsCnDQ/FNXd4xb+TV8h95kMMQyEql7Pa
	+tCR1sBRYgVya5TeXY9KUBX84Ksr2Fr6esEYzlOSWcEmd2mr+ep5DyOqma1Ix75ZDa3RvQtF
X-Received: by 2002:a05:6402:1e8e:b0:658:d18e:e8 with SMTP id
 4fb4d7f45d1cf-65fde4c92e6mr3648660a12.27.1772277533183; Sat, 28 Feb 2026
 03:18:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69a289fd.050a0220.3a55be.0030.GAE@google.com>
In-Reply-To: <69a289fd.050a0220.3a55be.0030.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 28 Feb 2026 12:18:42 +0100
X-Gm-Features: AaiRm53XEeSVRkHM3U6lIl8kD56G2iBEYMsKoq04stdaTc1JXvPsNjRax8CekkU
Message-ID: <CANp29Y6WYZH2-ZOczR+J6QhSbAhJCQDhA9zLXFAxwM8z5gJbPA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: bail out when the PMD has been set in
 bloom filter
To: syzbot ci <syzbot+ci44b390629650bdfd@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sat, Feb 28, 2026 at 7:24=E2=80=AFAM syzbot ci
<syzbot+ci44b390629650bdfd@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm: bail out when the PMD has been set in bloom filter
> https://lore.kernel.org/all/20260227075250.1128175-1-zhaoyang.huang@uniso=
c.com
> * [PATCH] mm: bail out when the PMD has been set in bloom filter
>
> and found the following issue:
> general protection fault in lru_gen_look_around
>
> Full report is available here:
> https://ci.syzbot.org/series/78ce04ff-c36e-4bcc-a097-f457e3ed9e5e
>
> ***
>
> general protection fault in lru_gen_look_around
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      8982358e1c87e3e1dc0aad37f4f93efe9c1cfe03
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/e976d408-587c-416f-85ab-a60940674=
f35/config
> C repro:   https://ci.syzbot.org/findings/ea92e1a7-69bd-4608-bc2c-2ff4ca1=
18f9c/c_repro
> syz repro: https://ci.syzbot.org/findings/ea92e1a7-69bd-4608-bc2c-2ff4ca1=
18f9c/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000003: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> CPU: 1 UID: 0 PID: 5967 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:test_bloom_filter mm/vmscan.c:2785 [inline]
> RIP: 0010:lru_gen_look_around+0x45c/0xd20 mm/vmscan.c:4206
> Code: 22 be ff 48 c7 44 24 48 00 00 00 00 48 83 c3 28 48 89 dd 48 c1 ed 0=
3 42 80 7c 25 00 00 74 08 48 89 df e8 97 b5 28 00 4c 8b 3b <41> 80 7c 24 03=
 00 74 0a bf 18 00 00 00 e8 82 b5 28 00 4c 8b 24 25
> RSP: 0018:ffffc900046e5c90 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffc900046e5e68 RCX: ffff8881100b1d00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 1ffff920008dcbcd R08: ffff88811008fcc3 R09: 1ffff11022011f98
> R10: dffffc0000000000 R11: ffffed1022011f99 R12: dffffc0000000000
> R13: 0000555585af4000 R14: ffffea0006a69fc0 R15: ffff888114457168
> FS:  0000555585ad9500(0000) GS:ffff8882a9461000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4753817dac CR3: 00000001b9a5e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  folio_referenced_one+0x724/0x1360 mm/rmap.c:962
>  rmap_walk_anon+0x5cb/0x7c0 mm/rmap.c:2973
>  rmap_walk mm/rmap.c:3078 [inline]
>  folio_referenced+0x3c0/0x5f0 mm/rmap.c:1081
>  folio_check_references mm/vmscan.c:870 [inline]
>  shrink_folio_list+0x1008/0x5240 mm/vmscan.c:1237
>  evict_folios+0x3f82/0x5090 mm/vmscan.c:4853
>  try_to_shrink_lruvec+0xb62/0xfa0 mm/vmscan.c:5008
>  lru_gen_shrink_lruvec mm/vmscan.c:5157 [inline]
>  shrink_lruvec+0x54e/0x2b30 mm/vmscan.c:5911
>  shrink_node_memcgs mm/vmscan.c:6147 [inline]
>  shrink_node+0xa41/0x3a90 mm/vmscan.c:6188
>  shrink_zones mm/vmscan.c:6427 [inline]
>  do_try_to_free_pages+0x6a2/0x1980 mm/vmscan.c:6489
>  try_to_free_mem_cgroup_pages+0x2ff/0x870 mm/vmscan.c:6811
>  try_charge_memcg+0x827/0x1560 mm/memcontrol.c:2642
>  obj_cgroup_charge_pages mm/memcontrol.c:3084 [inline]
>  __memcg_kmem_charge_page+0x32a/0x530 mm/memcontrol.c:3128
>  __alloc_frozen_pages_noprof+0x1c1/0x380 mm/page_alloc.c:5271
>  __alloc_pages_noprof mm/page_alloc.c:5288 [inline]
>  alloc_pages_bulk_noprof+0x569/0x710 mm/page_alloc.c:5208
>  alloc_pages_bulk_mempolicy_noprof+0x34e/0x1680 mm/mempolicy.c:2792
>  vm_area_alloc_pages mm/vmalloc.c:3700 [inline]
>  __vmalloc_area_node mm/vmalloc.c:3875 [inline]
>  __vmalloc_node_range_noprof+0xbd9/0x1a80 mm/vmalloc.c:4058
>  __bpf_map_area_alloc kernel/bpf/syscall.c:404 [inline]
>  bpf_map_area_alloc+0x12d/0x170 kernel/bpf/syscall.c:411
>  bloom_map_alloc+0x22f/0x470 kernel/bpf/bloom_filter.c:146
>  map_create+0xafd/0x16a0 kernel/bpf/syscall.c:1507
>  __sys_bpf+0x6e1/0x950 kernel/bpf/syscall.c:6210
>  __do_sys_bpf kernel/bpf/syscall.c:6341 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6339 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6339
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f475359c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff2e480d98 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f4753815fa0 RCX: 00007f475359c799
> RDX: 0000000000000050 RSI: 0000200000000dc0 RDI: 0000000000000000
> RBP: 00007f4753632bd9 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4753815fac R14: 00007f4753815fa0 R15: 00007f4753815fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:test_bloom_filter mm/vmscan.c:2785 [inline]
> RIP: 0010:lru_gen_look_around+0x45c/0xd20 mm/vmscan.c:4206
> Code: 22 be ff 48 c7 44 24 48 00 00 00 00 48 83 c3 28 48 89 dd 48 c1 ed 0=
3 42 80 7c 25 00 00 74 08 48 89 df e8 97 b5 28 00 4c 8b 3b <41> 80 7c 24 03=
 00 74 0a bf 18 00 00 00 e8 82 b5 28 00 4c 8b 24 25
> RSP: 0018:ffffc900046e5c90 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffc900046e5e68 RCX: ffff8881100b1d00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 1ffff920008dcbcd R08: ffff88811008fcc3 R09: 1ffff11022011f98
> R10: dffffc0000000000 R11: ffffed1022011f99 R12: dffffc0000000000
> R13: 0000555585af4000 R14: ffffea0006a69fc0 R15: ffff888114457168
> FS:  0000555585ad9500(0000) GS:ffff8882a9461000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4753817dac CR3: 00000001b9a5e000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   22 be ff 48 c7 44       and    0x44c748ff(%rsi),%bh
>    6:   24 48                   and    $0x48,%al
>    8:   00 00                   add    %al,(%rax)
>    a:   00 00                   add    %al,(%rax)
>    c:   48 83 c3 28             add    $0x28,%rbx
>   10:   48 89 dd                mov    %rbx,%rbp
>   13:   48 c1 ed 03             shr    $0x3,%rbp
>   17:   42 80 7c 25 00 00       cmpb   $0x0,0x0(%rbp,%r12,1)
>   1d:   74 08                   je     0x27
>   1f:   48 89 df                mov    %rbx,%rdi
>   22:   e8 97 b5 28 00          call   0x28b5be
>   27:   4c 8b 3b                mov    (%rbx),%r15
> * 2a:   41 80 7c 24 03 00       cmpb   $0x0,0x3(%r12) <-- trapping instru=
ction
>   30:   74 0a                   je     0x3c
>   32:   bf 18 00 00 00          mov    $0x18,%edi
>   37:   e8 82 b5 28 00          call   0x28b5be
>   3c:   4c                      rex.WR
>   3d:   8b                      .byte 0x8b
>   3e:   24 25                   and    $0x25,%al
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
> [akpm@linux-foundation.org huangzhaoyang@gmail.com linux-kernel@vger.kern=
el.org linux-mm@kvack.org steve.kang@unisoc.com yuzhao@google.com zhaoyang.=
huang@unisoc.com]
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
-upstream-moderation/69a289fd.050a0220.3a55be.0030.GAE%40google.com.
