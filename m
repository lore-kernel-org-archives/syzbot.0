Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD68B2F9DAA
	for <syzbot@lists.linux.dev>; Tue, 30 Sep 2025 10:54:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759229684; cv=none; b=NL5GSmQZfyH7NDmrFaAg26vcaFr+2uTkrZh1GSwNvyIxm6DtB1T4JRmVNq4eS44Ij9kxF/NDEZL7algYiny17X/z7kOZTtUGYGaxabkzQlnKz7MT4nLqR8q1QmNkmubqs6mrcgTYA2S/s0umSeM3PzY7oeG3g+/VZk9w/6tyYKQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759229684; c=relaxed/simple;
	bh=Kaot2+aKnNE3IsUOh/WDvFfaD7pm//LHPAwXwnyzS34=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gr9aa5IAzosjPvCnwL61Xub/ZLaOUuh1iisdGqEFbaVGkzrrSbraU3JlK6oT05D9JjhdjMHoiyoxjUOH+/D68Ol86Ps02mGfaVMxdAfihfOm/GXpOOcF/ZXDsQ/p8cC8hGU/F0OtHdYX5kLhCQtPcm+BJmdtYM+I1ZA/Mvs3m6Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=xMUa/pg+; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="xMUa/pg+"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-43f86ddb4b3so678515b6e.3
        for <syzbot@lists.linux.dev>; Tue, 30 Sep 2025 03:54:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759229680; x=1759834480; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2yGMzM0Mr2l9t7+nvwRtsv16cW5efu8ZpZw2DWGXoX4=;
        b=xMUa/pg+dz024Cli5s6NvC2D/doATGGpTv4lDWSKC2WPJjfa7i4xhilpWnC7TenLPe
         +SXu0f6lBxws2ed7dkzyFEtSrxVYG6zd/MSF903Fat5Uu28f5wBOYPB6dMhXjLJxgMbx
         NAgmpxJ/KXKSmntmhqC3IqEPQYNEFzPoMt+Yo6v9TRYCzsLMuvq1UeHezegR6b7Teznc
         IDEKD+zybxgjIMd24zGPbrvAvpiTb81Gbdx2b4bR8O3d2QhMGEWeuFPnDyq8f0zP1GOi
         JNKTyN4sqiK8/KaBVwhwiAxISnRdsyQL/aE2uikDfw+qOgaYHk8WUUVhvjx5TXndLXcy
         PinQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759229680; x=1759834480;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2yGMzM0Mr2l9t7+nvwRtsv16cW5efu8ZpZw2DWGXoX4=;
        b=pmfdpWfzRuI/lQEFjQRydDYenoTCF2d0fg9EPQiKnqBWuonUY6/uVfPYetIR7BKzOg
         PjZKD5Cx0ITJggrUgIoJ2BIFieAeQdztn1vlreeXsR92BUw1ixYD2Q3b7MrVwUdF3nz1
         z48HpsWd5hBX4XZzv6pDVASBZqM7A2KeFX7DL/acHLoU/t67cQhhu3TCU54Z0Y5i5zJH
         TT3NcvDcT5abuq582PGpTFWejBbb3vmYRxGm10Np+LtdBx9bzu66p4fuMk4690uJRthT
         i3KvSM44dVFjtv6BTaeqmsAsnCBH28OqlcvyMd8K5wSerFTyyKnI/Nuh1EFdK5K62f25
         7PKg==
X-Forwarded-Encrypted: i=1; AJvYcCUSFfo7KTEx5Zus5pPGrxszpHrc6q/x0EAOcv8Bl6oZMcg50TNJa3mUQuuJp4xP7DRyYQonM30=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqHHJVzdYimR87QfhMHIwCnkQNP8N1OLn6fvtVcCdVKlyACo4N
	bg8oVnUyt7/Vw8AOKYojCYLN+1UEaaIMF1Ta0NSmPmoj9UBJEMmZspEmNcR0KUgFHQ8rXdPNzKk
	ng9FDFx9a7atovGmMhMrMdsd+ziCbUVD/+byAt+14
X-Gm-Gg: ASbGnctsyEwILgYcTGZkoj1SEuNUWdd4Lf4kKyjT9wzysieQSM4F1vWZqzCrUKlNP8O
	rSTmHuCtz6FEf6kfTlDXx+5nLw1/ponQS2SZhKC1h0mV9Kg0d9elJb4gaePMGXG12amvJM+/hl0
	DHSLVoHtRpCALpCWzGs7abrgtjj/+Z4YAMPWQxivzYMdPq1xG8FHJSsa/9qdJr1Z4QgOZNPyJpM
	CJnnfNmry8lGu+7s68QvV8EyIOTBmvesbasoKLydxegk1GtcY0/nuVsjOXib5E4SqhxaK5fqAUm
	90fxlg==
X-Google-Smtp-Source: AGHT+IET7Plptov3yhFTTkKwhAVrYI9rr9VMDOCXHUpOyjvwKsKKafQLacpATimUCZ1vJKb5gs+8iYkj/Kd2aZFQpJU=
X-Received: by 2002:a05:6808:152b:b0:43f:7dee:46b3 with SMTP id
 5614622812f47-43f7dee4a54mr3451992b6e.18.1759229679571; Tue, 30 Sep 2025
 03:54:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68dbaa36.a00a0220.102ee.0045.GAE@google.com>
In-Reply-To: <68dbaa36.a00a0220.102ee.0045.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 30 Sep 2025 12:54:27 +0200
X-Gm-Features: AS18NWADUHIz7XWD2Ems-U8iyVfdyBH1ZZDjELgJcdXiM8_JB5aSSyk91IvDqUA
Message-ID: <CANp29Y6bx5x3w_Tcyy82RzxJxsNGmRwAAxbr4mJtD207re8S1g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/rmap: fix soft-dirty and uffd-wp bit loss
 when remapping zero-filled mTHP subpage to shared zeropage
To: syzbot ci <syzbot+ci2cfc3cf2a53af813@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Sep 30, 2025 at 12:00=E2=80=AFPM syzbot ci
<syzbot+ci2cfc3cf2a53af813@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-fil=
led mTHP subpage to shared zeropage
> https://lore.kernel.org/all/20250930060557.85133-1-lance.yang@linux.dev
> * [PATCH v3 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapp=
ing zero-filled mTHP subpage to shared zeropage
>
> and found the following issue:
> general protection fault in remove_migration_pte
>
> Full report is available here:
> https://ci.syzbot.org/series/a2021abd-c238-431c-a92e-cc29beb53cbf
>
> ***
>
> general protection fault in remove_migration_pte
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      1896ce8eb6c61824f6c1125d69d8fda1f44a22f8
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/84a2085e-d609-43ea-8b19-f9af8ea3d=
54a/config
> C repro:   https://ci.syzbot.org/findings/3e211477-5a8d-4d4d-935b-1507649=
9b001/c_repro
> syz repro: https://ci.syzbot.org/findings/3e211477-5a8d-4d4d-935b-1507649=
9b001/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 UID: 0 PID: 5985 Comm: syz.0.27 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
> RIP: 0010:remove_migration_pte+0x37f/0x2340 mm/migrate.c:361
> Code: 43 20 48 89 84 24 08 01 00 00 49 8d 47 40 48 89 84 24 00 01 00 00 4=
c 89 64 24 50 4c 8b b4 24 70 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 f7 e8 22 3e ff ff 49 8b 06 48 89 44 24
> RSP: 0018:ffffc90002c2f3c0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff888027799080 RCX: 1ffffd40008d1006
> RDX: 0000000000000000 RSI: 00000000000387ff RDI: 0000000000038600
> RBP: ffffc90002c2f5d0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff52000585e30 R12: ffffea0004688008
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004688000
> FS:  0000555589124500(0000) GS:ffff8880b8d7e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000300 CR3: 0000000026118000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  rmap_walk_anon+0x553/0x730 mm/rmap.c:2842
>  remove_migration_ptes mm/migrate.c:478 [inline]
>  migrate_folio_move mm/migrate.c:1394 [inline]
>  migrate_folios_move mm/migrate.c:1725 [inline]
>  migrate_pages_batch+0x200a/0x35c0 mm/migrate.c:1972
>  migrate_pages_sync mm/migrate.c:2002 [inline]
>  migrate_pages+0x1bcc/0x2930 mm/migrate.c:2111
>  migrate_to_node mm/mempolicy.c:1244 [inline]
>  do_migrate_pages+0x5ee/0x800 mm/mempolicy.c:1343
>  kernel_migrate_pages mm/mempolicy.c:1858 [inline]
>  __do_sys_migrate_pages mm/mempolicy.c:1876 [inline]
>  __se_sys_migrate_pages+0x544/0x650 mm/mempolicy.c:1872
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f922b98ec29
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffccaf966f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000100
> RAX: ffffffffffffffda RBX: 00007f922bbd5fa0 RCX: 00007f922b98ec29
> RDX: 0000200000000300 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 00007f922ba11e41 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000200000000040 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f922bbd5fa0 R14: 00007f922bbd5fa0 R15: 0000000000000004
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
> RIP: 0010:remove_migration_pte+0x37f/0x2340 mm/migrate.c:361
> Code: 43 20 48 89 84 24 08 01 00 00 49 8d 47 40 48 89 84 24 00 01 00 00 4=
c 89 64 24 50 4c 8b b4 24 70 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 f7 e8 22 3e ff ff 49 8b 06 48 89 44 24
> RSP: 0018:ffffc90002c2f3c0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff888027799080 RCX: 1ffffd40008d1006
> RDX: 0000000000000000 RSI: 00000000000387ff RDI: 0000000000038600
> RBP: ffffc90002c2f5d0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff52000585e30 R12: ffffea0004688008
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004688000
> FS:  0000555589124500(0000) GS:ffff8880b8d7e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000300 CR3: 0000000026118000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   43 20 48 89             rex.XB and %cl,-0x77(%r8)
>    4:   84 24 08                test   %ah,(%rax,%rcx,1)
>    7:   01 00                   add    %eax,(%rax)
>    9:   00 49 8d                add    %cl,-0x73(%rcx)
>    c:   47                      rex.RXB
>    d:   40                      rex
>    e:   48 89 84 24 00 01 00    mov    %rax,0x100(%rsp)
>   15:   00
>   16:   4c 89 64 24 50          mov    %r12,0x50(%rsp)
>   1b:   4c 8b b4 24 70 01 00    mov    0x170(%rsp),%r14
>   22:   00
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 f7                mov    %r14,%rdi
>   34:   e8 22 3e ff ff          call   0xffff3e5b
>   39:   49 8b 06                mov    (%r14),%rax
>   3c:   48                      rex.W
>   3d:   89                      .byte 0x89
>   3e:   44                      rex.R
>   3f:   24                      .byte 0x24
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
> [akpm@linux-foundation.org apopple@nvidia.com baohua@kernel.org baolin.wa=
ng@linux.alibaba.com byungchul@sk.com david@redhat.com dev.jain@arm.com gou=
rry@gourry.net harry.yoo@oracle.com ioworker0@gmail.com jannh@google.com jo=
shua.hahnjy@gmail.com lance.yang@linux.dev liam.howlett@oracle.com linux-ke=
rnel@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com matthew.=
brost@intel.com npache@redhat.com peterx@redhat.com rakie.kim@sk.com riel@s=
urriel.com ryan.roberts@arm.com stable@vger.kernel.org usamaarif642@gmail.c=
om vbabka@suse.cz ying.huang@linux.alibaba.com yuzhao@google.com ziy@nvidia=
.com]
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
-upstream-moderation/68dbaa36.a00a0220.102ee.0045.GAE%40google.com.
