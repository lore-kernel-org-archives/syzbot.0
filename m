Received: from mail-qv1-f53.google.com (mail-qv1-f53.google.com [209.85.219.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3378D3B634E
	for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 23:02:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.53
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783724557; cv=pass; b=Qt7Tg6KA8I0R+KKy1drGneYiZyIoW11rKxZAxoR+5/dkqW/atDb6249lIThZfskYXXoOxvLPZVag2G08H2u+Qk1qTczH2w6cK0x/4KddL0NhaxsWpcZL8Cu5fQ+5p8+Lwape0zrS5QN068l0jTI5ICkBfbZ9THndirOHUW7GSlQ=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783724557; c=relaxed/simple;
	bh=5H2wDYueUW2hyVpBEEtBTKDGVNNr6owKcKsflSNWEWI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EWBUUrglcmT/8xXwQjk3+S4ihAkOpvlw8dmMGlpCubC8wWTx0q7MgImuIBEFl5rIxM5mh1Jm8Z1P2MJgaPTW/RLUaqMWx4GdxmWwQi0lTjH3DZ/FVO80YP4Grbbex5wrU0EIYAAEdMNj6r4ePgAetOA9ZWpF5VPSyDriR5kNKZ0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UDE4TY8B; arc=pass smtp.client-ip=209.85.219.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UDE4TY8B"
Received: by mail-qv1-f53.google.com with SMTP id 6a1803df08f44-8f23e851626so12162386d6.3
        for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 16:02:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783724554; cv=none;
        d=google.com; s=arc-20260327;
        b=Lcif3P6R8qBq87E2yIFk7iepnZLRFT/1CgtAlEq4QYOVPDtbeHDX5ZUVIb+zoBRwOx
         FFvjG5Tja9BhDvCZ+zkzwZfdOaydGTUvU4ZJLi6epIINC1i9xt+auqiMjcdkYuQIkZ5x
         IZd3IRzCgsGYF9feVngs2dk43ijhcNf3hkubuC+SKYK6QgA8mcesMa7Ha9BO7d/hY4EZ
         3VVfvjdndQGf8cmrK+XwRnUHpx7lPEtD4VyPIX8/ihNw60+H7zmutgle1Gu2jG+EY95U
         DMtBx8n8dPNt6ShNyHw3mrNqpDcoLojXscWEf5Zmfi8h633M9E9zRr2GBfsPmnDrmOUE
         BmTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=o6RMwQv8+176r03J9GZVNS+4Rrw0gFkEs7SN+uTTNos=;
        fh=LSZQIAwPFoUeVov7gr6HU24rNrBU7w/RW4sU5J4M21I=;
        b=DEFh4gA0S6mmVKQ+HGBASrCIc5u7TxZ86AItHTbgCKkcK0EgTYOWiqkd48un/pVstj
         JuTcJUVvq/NFrijNC7tLDNg649utvQdi42fEl1pn0G1vAWyJmdAxcnndJvVqqBG+FPty
         ya7xckZlHUOxhVZnRBzyRYjXK94NzyH87E6+1jA5WwPJdorDpkDUo6OhgWmQxnMEJs2Z
         glUmn41vnJRpKfqc4vXaQ4R6/9aPDy2Tq5qInkRNu8qst7//5TTfFZH/Gz2mJN34qdyL
         zdNbbg9G7krec8n4v8pEr8XM17kxm3g+pw1G6uR4bw/3SRvDzfYIAVEFyd3oLwYRNSVM
         FKSQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783724554; x=1784329354; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=o6RMwQv8+176r03J9GZVNS+4Rrw0gFkEs7SN+uTTNos=;
        b=UDE4TY8BhtOUd4Ei2xN/B3w1KVby+oJDv5QgqEZ9IEYQtxf5ngD7MDfmaL0/f4Q6DX
         sCLcR41e0khEYPbdocEkbV25AcJvc0YnXcQs3dAO5RGYaYzP9QRbGH9msc8Eo+fiUEjF
         KKJVPSXMPc1/s0eSMxtPTo1wnmTDomMLpOmlHVFbzHqrJhpmvjoUXL9Bv/o6Ns34FFrY
         r79yjQey7t7bf5rzbIGisQ/J9UIfknXbhch3MSR5HRIaN0hFDg1qAWI/DvnMcAxzNqQz
         43tcnERXROvvHpSGJDdlTVJgbiPG6bz7X/o3VHPWXG4gJQCnaLEzWOP3c+Yjvz6b2kpr
         t62A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783724554; x=1784329354;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=o6RMwQv8+176r03J9GZVNS+4Rrw0gFkEs7SN+uTTNos=;
        b=EI7nK2zmcqiumtWdjZLPZiihce5bMWJVc/wwHqXExyFCokg1FWuxOyiKAFdUHPOjy9
         2MNDcLcyQ2CKoP958t9orgAG621Zo4jz6ocwQ04o+hZqrecs6PvaN0GaLl6B883vzkcS
         rETUPRsq83rdouCUZbIgb6CL0+iOAPyEsVY+U837Hs7sV+qLkaL8A+ILLn8MQft+MHaW
         crhIoboe9rkKCAr1YT/HEE4av64d+ghCu1BV70XrXFvuw3KP7zt5MD/Qx7D30EzLUtKc
         bGBBbZY3YRePZYLwGyMtV/axjA67rOOAkiFCoVdOnE3S23o2AmnCnOw19/zuFRQms5MM
         Tixg==
X-Forwarded-Encrypted: i=1; AHgh+RpLCcCiOthx7mqPLUqHzMy4o3wzcj2rYqdHeLgiUoh44kLaStwywDl+M2vL1JSIjo570T0ThuI=@lists.linux.dev
X-Gm-Message-State: AOJu0YwEgXfujDdX/1j5Cp6r+v+tQilcRUZ8Cqv+hrwd/ct0F5dFEMn6
	e2VgCLH9KjyKjNj0fqf7TmKmMJuFIs2j4rzXyRs64or2UZNtnULjDvShb3WonIvvRj8JtOJ4L4/
	UR4XxdfZ+ji+KYuq2recobDmp1GEZFmqiItkpd+Cz
X-Gm-Gg: AfdE7cnrMrDlPUT9qJXG3zZ6WmnXf4ylB/TcLJRCgxS31jCWjaKv35YgPUpjhTc4q1g
	r/Q6mnut4Vyn690irHM+y+Tg3m1pC9xieAV9C2CHsbihxM2NIqogEuQc0Gw3Ht10tNM5Asv1QyO
	QLb5jQSW/ADxu2s8gvegiLrmyG2UMRdMTn+AW2t0A4R+6TLHV1wGLPMnjjaL9c5zdmTP8QZ/FAR
	HLeHkK0ETkP8lvdRFJaOUtqThcHHWVdbtC83ShF2b8ZWoVpl9QFsZ9VXe8J23J79XqJvV2rxwCt
	49ZETLKxAyHZauIihrDfy8+02v8uYsLMrgw0UtCCS4FbpeynbM58TwiVmQzBNrA=
X-Received: by 2002:a05:6214:5f84:b0:8f2:34b0:c6b2 with SMTP id
 6a1803df08f44-90403f4ccc3mr12754746d6.46.1783724553627; Fri, 10 Jul 2026
 16:02:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a515b94.574492cf.19a3b.0000.GAE@google.com>
In-Reply-To: <6a515b94.574492cf.19a3b.0000.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Sat, 11 Jul 2026 01:02:21 +0200
X-Gm-Features: AUfX_mwgy2zv7j6x1CYc9TwqMVgSGpp5kWuu5P1a4hcdoQ6bji4hKzZ2bL9qvVY
Message-ID: <CAJWNTGx88X2yvTWVZoOJFsZE2ENC1XzahoqMaisaypbioiVQ4A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Use generic_file_read_iter() in hugetlbfs
To: syzbot ci <syzbot+cifae32d7ea2365dc0@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Fri, Jul 10, 2026 at 10:52=E2=80=AFPM syzbot ci
<syzbot+cifae32d7ea2365dc0@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] Use generic_file_read_iter() in hugetlbfs
> https://lore.kernel.org/all/20260709184740.1286561-1-willy@infradead.org
> * [PATCH v2 01/10] mm: Rename folio_contain_hwpoison_page() to folio_has_=
hwpoison_page()
> * [PATCH v2 02/10] hugetlb: Mark some function arguments as const
> * [PATCH v2 03/10] filemap: Remove checks in mapping_set_folio_order_rang=
e()
> * [PATCH v2 04/10] hugetlb: Set mapping folio order
> * [PATCH v2 05/10] memory-failure: Remove raw_hwp_list_head()
> * [PATCH v2 06/10] memory-failure: Prevent UAF in raw_hwp_page list
> * [PATCH v2 07/10] mm: Handle hugetlb correctly in is_page_hwpoison()
> * [PATCH v2 08/10] filemap: Add hwpoison handling to filemap_read()
> * [PATCH v2 09/10] filemap: Add support for authoritative mappings
> * [PATCH v2 10/10] hugetlb: replace hugetlbfs_read_iter() with generic_fi=
le_read_iter()
>
> and found the following issue:
> BUG: unable to handle kernel NULL pointer dereference in filemap_read_fol=
io
>
> Full report is available here:
> https://ci.syzbot.org/series/35ead019-1e81-4d15-8801-8ff11d9c959b
>
> ***
>
> BUG: unable to handle kernel NULL pointer dereference in filemap_read_fol=
io
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      dc59e4fea9d83f03bad6bddf3fa2e52491777482
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/fedb89e4-11ba-4995-927f-a51101829=
a59/config
> syz repro: https://ci.syzbot.org/findings/7a0cb565-4340-4daf-8de2-06f5b1d=
2af93/syz_repro
>
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor instruction fetch in kernel mode
> #PF: error_code(0x0010) - not-present page
> PGD 8000000117bc9067 P4D 8000000117bc9067 PUD 0
> Oops: Oops: 0010 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 5840 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> RSP: 0018:ffffc900035eebf8 EFLAGS: 00010293
> RAX: ffffffff82063559 RBX: 1ffff920006bdd84 RCX: ffff88810ba18000
> RDX: 0000000000000000 RSI: ffffea0000948000 RDI: ffff88810139d200
> RBP: ffffc900035eecb0 R08: ffffea0000948007 R09: 1ffffd4000129000
> R10: dffffc0000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 1ffffd4000129000 R14: ffffea0000948000 R15: 1ffffd4000129001
> FS:  00007f2e39ef46c0(0000) GS:ffff88818dc11000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 000000011578a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  filemap_read_folio+0x12c/0x3a0 mm/filemap.c:2512
>  filemap_create_folio mm/filemap.c:2650 [inline]
>  filemap_get_pages+0xe9a/0x21e0 mm/filemap.c:2714
>  filemap_read+0x428/0x1700 mm/filemap.c:2841
>  __kernel_read+0x4ca/0x960 fs/read_write.c:532
>  integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
>  ima_calc_file_hash_tfm security/integrity/ima/ima_crypto.c:222 [inline]
>  ima_calc_file_hash+0x451/0x890 security/integrity/ima/ima_crypto.c:280
>  ima_collect_measurement+0x51b/0xa00 security/integrity/ima/ima_api.c:300
>  process_measurement+0x1272/0x1c10 security/integrity/ima/ima_main.c:425
>  ima_file_mmap+0x1b0/0x200 security/integrity/ima/ima_main.c:523
>  security_mmap_file+0x773/0xa20 security/security.c:2581
>  vm_mmap_pgoff+0x134/0x4e0 mm/util.c:575
>  ksys_mmap_pgoff+0x57d/0x760 mm/mmap.c:606
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f2e38f9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f2e39ef4028 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
> RAX: ffffffffffffffda RBX: 00007f2e39215fa0 RCX: 00007f2e38f9ce59
> RDX: 0000000000000007 RSI: 0000000000003000 RDI: 0000200000000000
> RBP: 00007f2e39032e6f R08: ffffffffffffffff R09: 0000000000000000
> R10: 0000000000040033 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f2e39216038 R14: 00007f2e39215fa0 R15: 00007ffe3450a298
>  </TASK>
> Modules linked in:
> CR2: 0000000000000000
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> RSP: 0018:ffffc900035eebf8 EFLAGS: 00010293
> RAX: ffffffff82063559 RBX: 1ffff920006bdd84 RCX: ffff88810ba18000
> RDX: 0000000000000000 RSI: ffffea0000948000 RDI: ffff88810139d200
> RBP: ffffc900035eecb0 R08: ffffea0000948007 R09: 1ffffd4000129000
> R10: dffffc0000000000 R11: 0000000000000000 R12: 0000000000000000
> R13: 1ffffd4000129000 R14: ffffea0000948000 R15: 1ffffd4000129001
> FS:  00007f2e39ef46c0(0000) GS:ffff88818dc11000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 000000011578a000 CR4: 00000000000006f0
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
> [akpm@linux-foundation.org christian@brauner.io david@kernel.org jack@sus=
e.cz jane.chu@oracle.com linmiaohe@huawei.com linux-fsdevel@vger.kernel.org=
 linux-mm@kvack.org muchun.song@linux.dev nao.horiguchi@gmail.com osalvador=
@suse.de willy@infradead.org]
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
-upstream-moderation/6a515b94.574492cf.19a3b.0000.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
