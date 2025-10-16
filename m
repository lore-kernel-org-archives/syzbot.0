Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E4A223EA93
	for <syzbot@lists.linux.dev>; Thu, 16 Oct 2025 16:22:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760631766; cv=none; b=tva1ewnOUtM+X6KdYp3viYlv+yE+xHUqne+TxnUZ1wEg1gdxhrK7jpjG8QsZJCWW6s8gZe8dGnBo09oaoJE44PJKxVy3AR5OEd5iMxM5gDSl/lMNdowUpqRCDQFRRJDiRFQkrUE5uoNCg1yGupUOWa36h7u6Ky7qc7epQFX8GP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760631766; c=relaxed/simple;
	bh=BCcddh45ZTEQk9hYPSM3hGdA2PlFWU0U9ADinjqdfIA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OlGQge2f8r62LQrRqWJzLdBZihRCUhDV7i4iySG1zbI9e7ZFOxoQAn1ROA5f8DJL+FOePwI+XmHJeY0qewGwZyk9IxfEig7hw8Jt/GBYnclSydLO/x/GERhZROkW37LVZ3z5hlhFV6xTdWrtPIHPY/ZtrhQ0PbukOzKVCLKP0JQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Of0aOBcB; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Of0aOBcB"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-44181f9e5b4so600911b6e.0
        for <syzbot@lists.linux.dev>; Thu, 16 Oct 2025 09:22:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760631763; x=1761236563; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Odbuqb/rDbC7q6YSxIFlJ2gyZpb15hwJidj1B775S6o=;
        b=Of0aOBcBquoZNoHKesmPqxk0FThlWpVsT3sfhe7vEItn6FEzRpR3lpX9Oa/NLNFAJx
         harTDS3LlevN0aui/ZGbn18bdCRIPhtROi/aqqFD0p0Zmw7bVwLRW8HZPCefJyUiob5N
         2oe4DIMeL6ZbnX1JZpnv1TqtnnIfZ78R3UvfuUbVErDY7qj3ji4B35FgqRDefpmw9J9W
         +lUCUCDBIdIZlj22zfjpK4UDJawc5aw8KH8w9sLOCkt7fpGt3maiLK8kUaYRKhLRYNR0
         crsqz0k6PNxql0MHl6td/fDbBFKc3xOC/E0Dkm0EBs7et8ex06sRrqkkjTqgkgC+f7Bz
         f7ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760631763; x=1761236563;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Odbuqb/rDbC7q6YSxIFlJ2gyZpb15hwJidj1B775S6o=;
        b=YD3aMCJDEURuOgx5kghXcC85/OnDRn9uIQpT2W0bbOTb+Rf5aashnvAByJ8d3W0812
         FLyZHfnc0iYOt8J33HAEg6sLH+TvLh1uccR0bxMAbDxuHH5nOvINAIL7NbpdC6hyLJZ2
         OJ4CKGdrilAjqczBlxCZksNZWQlaTgo1nfWOUp+wITREaMCNcIUQdRB8M2lphSiLyziT
         3Fd8l1g8s3umUycVEKeCNqVx3d5nDzJVuQQFe+6iT6RcYSh2+klcgzj/jih+bOyFsOTN
         8U7XylXzlWcC6wGEgCyC8U5V8SElw0+bZeGjbzQrN4Lz+gtTFPQP/FRsg8nV/a6e9hjJ
         D1NA==
X-Forwarded-Encrypted: i=1; AJvYcCUS/5I8O50SPoDaEnmwt6PHYWL6vLqccsIioEk0V40VyVY2UZv15NWLWu/evnTUwrN7aL/M0NU=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyOhMyH1sPsL610cQA4+VEYyNjcokCjaMXlVcxQxlfZvZdcEgV
	fM6Eh8ashIEOmkNKJ4Qv1cgSDN5XmLJGexJRvDvjM33C7p9ti8H5pAbbKQUV4LzqBiHY/bHfiHc
	TLS5/UkJeRix3HqekClZxTgGjUcL8UR+OmAQvcJRc
X-Gm-Gg: ASbGncsUyzJRmG91mYJ5/HBo06A4NeQavbByOC5sEn3VY0M+7xfzjVLcI/TNQ2YQMxj
	eEwrI/KZk+C6+plsz1J1Ped9ObEIKAe/lEAOaQF/vrTrkAyE2sCrPkI3O/1esncLNYU1UDXzq5O
	RDC9TUFKhw12P+QA7CfQbz8GmfU6pyNOM2iA3aLYhA8/AbQ7N6pSw28lFNu53KXzNoYVzY53GKE
	9vvyaElylj3RXwk+lhGSAlPEPaLzJt/hxyNmxOM7AbPkPrA2Y8xHPOXxptnGEm0uRTcPTZwCUKL
	VEujv00kPZx9p5asyv/c8fmjsR96XHSUoPUfc5D4zU8EfYA=
X-Google-Smtp-Source: AGHT+IGZ1NgFxT9KW0Wm63UWmSC1mi3DwDFjMA70H8EhhO+Hq9/5vH1U4BWLkhmO4jET/VfNbY9zCaGR1J3Y+aq8Rn4=
X-Received: by 2002:a05:6808:4fc6:b0:43f:9cff:51b0 with SMTP id
 5614622812f47-443a2efb076mr268085b6e.28.1760631763020; Thu, 16 Oct 2025
 09:22:43 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68f116d3.050a0220.91a22.0410.GAE@google.com>
In-Reply-To: <68f116d3.050a0220.91a22.0410.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 16 Oct 2025 18:22:31 +0200
X-Gm-Features: AS18NWBCnbul3_Os9xnqyKtIp2dN_zybgfg9hjumPVtYKkgxIcdMu0sUiIGQDik
Message-ID: <CANp29Y6koHQGKvOkRQcj2qY1MGcPQAhys14mx+55ZabprZ3Mcg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: add huge pfnmap support for remap_pfn_range()
To: syzbot ci <syzbot+ci78f39f7f9c183deb@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Oct 16, 2025 at 6:01=E2=80=AFPM syzbot ci
<syzbot+ci78f39f7f9c183deb@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm: add huge pfnmap support for remap_pfn_range()
> https://lore.kernel.org/all/20251016112704.179280-1-yintirui@huawei.com
> * [PATCH RFC 1/2] pgtable: add pte_clrhuge() implementation for arm64 and=
 riscv
> * [PATCH RFC 2/2] mm: add PMD-level huge page support for remap_pfn_range=
()
>
> and found the following issue:
> stack segment fault in pgtable_trans_huge_withdraw
>
> Full report is available here:
> https://ci.syzbot.org/series/d04c2914-0d99-4132-89d4-899e22abf904
>
> ***
>
> stack segment fault in pgtable_trans_huge_withdraw
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      3a8660878839faadb4f1a6dd72c3179c1df56787
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/9d7864e5-ad3a-4c0d-b21d-86cfc4767=
92e/config
> C repro:   https://ci.syzbot.org/findings/b9fca361-413d-4db1-b8b2-1849cd2=
c50dd/c_repro
> syz repro: https://ci.syzbot.org/findings/b9fca361-413d-4db1-b8b2-1849cd2=
c50dd/syz_repro
>
> Oops: stack segment: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 5968 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:pgtable_trans_huge_withdraw+0x115/0x310 mm/pgtable-generic.c:18=
8
> Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 9d e9 1=
3 00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00=
 00 74 08 4c 89 ff e8 7b e9 13 00 49 8b 07 48 8d 48
> RSP: 0018:ffffc90003717300 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffffea00044848d0 RCX: ffff88816c890000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffff88816db66a23 R09: 1ffff1102db6cd44
> R10: dffffc0000000000 R11: ffffed102db6cd45 R12: ffff888112123000
> R13: dffffc0000000000 R14: ffff888112123000 R15: 0000000000000008
> FS:  000055556cb5f500(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 00000001102a4000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  zap_deposited_table mm/huge_memory.c:2169 [inline]
>  zap_huge_pmd+0xa25/0xf50 mm/huge_memory.c:2197
>  zap_pmd_range mm/memory.c:1926 [inline]
>  zap_pud_range mm/memory.c:1975 [inline]
>  zap_p4d_range mm/memory.c:1996 [inline]
>  unmap_page_range+0x9fe/0x4370 mm/memory.c:2017
>  unmap_single_vma mm/memory.c:2060 [inline]
>  unmap_vmas+0x399/0x580 mm/memory.c:2104
>  exit_mmap+0x240/0xb40 mm/mmap.c:1280
>  __mmput+0x118/0x430 kernel/fork.c:1133
>  copy_process+0x2910/0x3c00 kernel/fork.c:2460
>  kernel_clone+0x21e/0x840 kernel/fork.c:2609
>  __do_sys_clone kernel/fork.c:2750 [inline]
>  __se_sys_clone kernel/fork.c:2734 [inline]
>  __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2734
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f946958eec9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc41c94258 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
> RAX: ffffffffffffffda RBX: 00007f94697e5fa0 RCX: 00007f946958eec9
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000002001000
> RBP: 00007f9469611f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
> R13: 00007f94697e5fa0 R14: 00007f94697e5fa0 R15: 0000000000000006
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:pgtable_trans_huge_withdraw+0x115/0x310 mm/pgtable-generic.c:18=
8
> Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 9d e9 1=
3 00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00=
 00 74 08 4c 89 ff e8 7b e9 13 00 49 8b 07 48 8d 48
> RSP: 0018:ffffc90003717300 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffffea00044848d0 RCX: ffff88816c890000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffff88816db66a23 R09: 1ffff1102db6cd44
> R10: dffffc0000000000 R11: ffffed102db6cd45 R12: ffff888112123000
> R13: dffffc0000000000 R14: ffff888112123000 R15: 0000000000000008
> FS:  000055556cb5f500(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 00000001102a4000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   c3                      ret
>    1:   10 48 89                adc    %cl,-0x77(%rax)
>    4:   d8 48 c1                fmuls  -0x3f(%rax)
>    7:   e8 03 42 80 3c          call   0x3c80420f
>    c:   28 00                   sub    %al,(%rax)
>    e:   74 08                   je     0x18
>   10:   48 89 df                mov    %rbx,%rdi
>   13:   e8 9d e9 13 00          call   0x13e9b5
>   18:   48 8b 03                mov    (%rbx),%rax
>   1b:   48 89 04 24             mov    %rax,(%rsp)
>   1f:   4c 8d 78 08             lea    0x8(%rax),%r15
>   23:   4c 89 fd                mov    %r15,%rbp
>   26:   48 c1 ed 03             shr    $0x3,%rbp
> * 2a:   42 80 7c 2d 00 00       cmpb   $0x0,0x0(%rbp,%r13,1) <-- trapping=
 instruction
>   30:   74 08                   je     0x3a
>   32:   4c 89 ff                mov    %r15,%rdi
>   35:   e8 7b e9 13 00          call   0x13e9b5
>   3a:   49 8b 07                mov    (%r15),%rax
>   3d:   48                      rex.W
>   3e:   8d                      .byte 0x8d
>   3f:   48                      rex.W
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
> [abrestic@rivosinc.com akpm@linux-foundation.org alex@ghiti.fr anshuman.k=
handual@arm.com aou@eecs.berkeley.edu apopple@nvidia.com ardb@kernel.org ba=
ohua@kernel.org baolin.wang@linux.alibaba.com catalin.marinas@arm.com chenj=
un102@huawei.com david@redhat.com dev.jain@arm.com liam.howlett@oracle.com =
linux-arm-kernel@lists.infradead.org linux-kernel@vger.kernel.org linux-mm@=
kvack.org linux-riscv@lists.infradead.org lorenzo.stoakes@oracle.com luxu.k=
ernel@bytedance.com mhocko@suse.com npache@redhat.com palmer@dabbelt.com pa=
ul.walmsley@sifive.com rppt@kernel.org ryan.roberts@arm.com samuel.holland@=
sifive.com surenb@google.com vbabka@suse.cz wangkefeng.wang@huawei.com will=
@kernel.org willy@infradead.org yangyicong@hisilicon.com yintirui@huawei.co=
m yongxuan.wang@sifive.com ziy@nvidia.com]
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
-upstream-moderation/68f116d3.050a0220.91a22.0410.GAE%40google.com.
