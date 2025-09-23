Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0E1A25DB0A
	for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 22:51:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758667876; cv=none; b=oEwskjC0Q+f9iSSQJoOk8PeczqBX4cE+OUmCnizW8eWNPB8Kciw2BV/Vxx7bBaJiuRnMO5mycJlrBegCsc4cQSXWsPwCmPq8LKx9lKzp6GlcU3MTtFj9yWW5goEdqh4etONpcXx4kTvTQGC/9BCe3dn+tYOHiQ3XMtUpAdkFnuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758667876; c=relaxed/simple;
	bh=KsXa3Rd7j3bF/iWPzEEuFA9vN1Dn490tZIw0HCcuLmY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=u4bMZK81guUaYeilpIe7cnTseOa6YNjnpU38jj4/H5RRIfwnFDJDkv4iAwouSmuvW/Yw4RvJEO0dMCQM2kJbtdkgIEhvuQk8Bb33DXFobfaq2+XemBpEet1bf79fJTlrWCfkjwYSdovixBiFTDmR6sK+ls0vzjnoJQ2EHWMYXNA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TU7mdGuJ; arc=none smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TU7mdGuJ"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-62189987b47so3304076eaf.1
        for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 15:51:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758667874; x=1759272674; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=BK0uobXvGXB707yekJghCpXzKpYFyDRqxfo+kBRMhL8=;
        b=TU7mdGuJGbrpgO82UOlei99tpyBMNL3FDHID1y8v9a67g/29No/LBTJEN/M1k+BCwE
         wIg81NirI/EZ0OVZSTH5I3ldNjQ6Z8EPVurqxmiKk9w/Z5OS0JpJ2dvzP/LEzMtSrCm0
         9ffL3E/Zczi/FAtB2MpmVrV8Yyu7MTlnbFrqUSo237rr13Av6wfGs98ONRSClfFSjOoz
         v3CFyVMHHj5R1OILrcsXav2k7KeuRGeSvqv4wN8hS7FYGtzRP8Y0AfiLmOY981Qq/O7y
         axvjN6EguoWtX5zLxr8sA6CCdC/j+QOzkdjnNhgMMYrtgBbM+SRbN2UgWm8JftcxDd7Z
         o1zw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758667874; x=1759272674;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=BK0uobXvGXB707yekJghCpXzKpYFyDRqxfo+kBRMhL8=;
        b=dRRLKtuR08+RhbXSdtyPXCICl9bxBEn71on1mnMeMWVS/jTnKooYNb0Z71depvAvkz
         Q1YGFir6//1Ci/NdQvRNiMqaiynWNn/GG6spJ/txIFUl8rWXt9bm4RqcK8sNy/duRIc/
         8BNyXjk/Hl7C+MzeljHb3xR1F83F1ZuLQ+WqamSL1uCmhjnqVbddM7QVPo5F/dpJachf
         1NBiEuwkBfE4dla1B9sD4lT7MQcbDj+3ZhsAsdHdRiGn2uYPFDDLnrARNmAK+eNasNd3
         bMITphuGBNBNyLBvzgLcBLLx9NOs8Y6rQWpMFZmF+WA7qV2tn+a08i/T5TjCDUHRjE44
         He3A==
X-Forwarded-Encrypted: i=1; AJvYcCV20+xtpahcgwMsdmD+uaC6nFiE8NKpoqKlhLtv1pVUmNlG6YomwMKCD9a5wgM6ipAVVnbuXnw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzzwPJlsmmpKFwr9iZF2qSSgn8QuyZatecU0ZrBlFPS9ZA12vBK
	X6W1IA2UbCDTyMMKzrqbT0sEaFKb6iXLDC77dnlu0yqJS9K/h03azWjegBliHaQl93DQ9qNmIG4
	38eiVvY9oERcXpygiBRPd6DW7L/9fzf6xIQLkqLw8
X-Gm-Gg: ASbGnctaZLr6GC6yq7CQ/cfFGDDIMCkvBXX4prdWon21CjnWhnlZRKOybCYHqVR0coy
	A7VN64i+OdyOvzlDHAgy78dW/EIQkl3ADVNFXR/QPA3BHHXVtNWKw+m8M4Bf6jtDij8ajxUrIJK
	2QHeWeaaKFooT/mTfynzXw150hOy8VsBAcElQci8npMbxeOnLE8ND0SI8hdhyWlq5EI442Ob4l6
	X6wKsuZ9nq7F6lEJN4GcRzi
X-Google-Smtp-Source: AGHT+IExOuyIw0GNL+btwOqPpVQVCKr50bMH+m3O1UG0bf+d0horR/hSb3xxQj01uFZTZtQwEORZMW106Eo87lgEFQc=
X-Received: by 2002:a05:6820:1614:b0:621:ce3b:b648 with SMTP id
 006d021491bc7-6330dd33cc4mr2449023eaf.4.1758667873658; Tue, 23 Sep 2025
 15:51:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68d2db40.050a0220.139b6.0028.GAE@google.com>
In-Reply-To: <68d2db40.050a0220.139b6.0028.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 24 Sep 2025 00:51:01 +0200
X-Gm-Features: AS18NWAwBxx-yFV1lOLR1fHQCDp7wJaMwbkLWPSG0pC6nFE9pMRDwNpl4ILRexs
Message-ID: <CANp29Y5bnVF0obQt=5ibSLA4nsDo8tYOwcG2Ng--Pd=_SXypmw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: add huge pfnmap support for remap_pfn_range()
To: syzbot ci <syzbot+cia40ee1d2dcc6b717@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Sep 23, 2025 at 7:39=E2=80=AFPM syzbot ci
<syzbot+cia40ee1d2dcc6b717@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm: add huge pfnmap support for remap_pfn_range()
> https://lore.kernel.org/all/20250923133104.926672-1-yintirui@huawei.com
> * [PATCH RFC 1/2] pgtable: add pte_clrhuge() implementation for arm64 and=
 riscv
> * [PATCH RFC 2/2] mm: add PMD-level huge page support for remap_pfn_range=
()
>
> and found the following issues:
> * BUG: non-zero pgtables_bytes on freeing mm: NUM
> * stack segment fault in pgtable_trans_huge_withdraw
>
> Full report is available here:
> https://ci.syzbot.org/series/633cbff7-ef54-4f3a-9133-71cc271396ee
>
> ***
>
> BUG: non-zero pgtables_bytes on freeing mm: NUM
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      07e27ad16399afcd693be20211b0dfae63e0615f
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/72b4b6cf-5400-40d6-94b6-1cfc0e850=
50d/config
> C repro:   https://ci.syzbot.org/findings/3450ef75-3540-4c00-8b33-5625d4a=
a40ef/c_repro
> syz repro: https://ci.syzbot.org/findings/3450ef75-3540-4c00-8b33-5625d4a=
a40ef/syz_repro
>
> BUG: non-zero pgtables_bytes on freeing mm: 4096
>
>
> ***
>
> stack segment fault in pgtable_trans_huge_withdraw
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      07e27ad16399afcd693be20211b0dfae63e0615f
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/72b4b6cf-5400-40d6-94b6-1cfc0e850=
50d/config
> C repro:   https://ci.syzbot.org/findings/dcfb72b5-c263-48da-830a-7f51aaa=
927db/c_repro
> syz repro: https://ci.syzbot.org/findings/dcfb72b5-c263-48da-830a-7f51aaa=
927db/syz_repro
>
> Oops: stack segment: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 6000 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:pgtable_trans_huge_withdraw+0x115/0x310 mm/pgtable-generic.c:18=
8
> Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 5d 38 1=
3 00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00=
 00 74 08 4c 89 ff e8 3b 38 13 00 49 8b 07 48 8d 48
> RSP: 0018:ffffc90002d5f300 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffffea0000fb3dd0 RCX: ffff888107769cc0
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffff888022b90843 R09: 1ffff11004572108
> R10: dffffc0000000000 R11: ffffed1004572109 R12: ffff88803ecf7000
> R13: dffffc0000000000 R14: ffff88803ecf7000 R15: 0000000000000008
> FS:  0000555576e7a500(0000) GS:ffff8880b8612000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000107d74000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  zap_deposited_table mm/huge_memory.c:2177 [inline]
>  zap_huge_pmd+0xa25/0xf50 mm/huge_memory.c:2205
>  zap_pmd_range mm/memory.c:1798 [inline]
>  zap_pud_range mm/memory.c:1847 [inline]
>  zap_p4d_range mm/memory.c:1868 [inline]
>  unmap_page_range+0x9fe/0x4370 mm/memory.c:1889
>  unmap_single_vma mm/memory.c:1932 [inline]
>  unmap_vmas+0x399/0x580 mm/memory.c:1976
>  exit_mmap+0x248/0xb50 mm/mmap.c:1280
>  __mmput+0x118/0x430 kernel/fork.c:1129
>  copy_process+0x2910/0x3c00 kernel/fork.c:2454
>  kernel_clone+0x21e/0x840 kernel/fork.c:2605
>  __do_sys_clone kernel/fork.c:2748 [inline]
>  __se_sys_clone kernel/fork.c:2732 [inline]
>  __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2732
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f96b638ec29
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc07e618c8 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
> RAX: ffffffffffffffda RBX: 00007f96b65d5fa0 RCX: 00007f96b638ec29
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000002001000
> RBP: 00007f96b6411e41 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
> R13: 00007f96b65d5fa0 R14: 00007f96b65d5fa0 R15: 0000000000000006
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:pgtable_trans_huge_withdraw+0x115/0x310 mm/pgtable-generic.c:18=
8
> Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 5d 38 1=
3 00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00=
 00 74 08 4c 89 ff e8 3b 38 13 00 49 8b 07 48 8d 48
> RSP: 0018:ffffc90002d5f300 EFLAGS: 00010202
> RAX: 0000000000000000 RBX: ffffea0000fb3dd0 RCX: ffff888107769cc0
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffff888022b90843 R09: 1ffff11004572108
> R10: dffffc0000000000 R11: ffffed1004572109 R12: ffff88803ecf7000
> R13: dffffc0000000000 R14: ffff88803ecf7000 R15: 0000000000000008
> FS:  0000555576e7a500(0000) GS:ffff8880b8612000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000107d74000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   c3                      ret
>    1:   10 48 89                adc    %cl,-0x77(%rax)
>    4:   d8 48 c1                fmuls  -0x3f(%rax)
>    7:   e8 03 42 80 3c          call   0x3c80420f
>    c:   28 00                   sub    %al,(%rax)
>    e:   74 08                   je     0x18
>   10:   48 89 df                mov    %rbx,%rdi
>   13:   e8 5d 38 13 00          call   0x133875
>   18:   48 8b 03                mov    (%rbx),%rax
>   1b:   48 89 04 24             mov    %rax,(%rsp)
>   1f:   4c 8d 78 08             lea    0x8(%rax),%r15
>   23:   4c 89 fd                mov    %r15,%rbp
>   26:   48 c1 ed 03             shr    $0x3,%rbp
> * 2a:   42 80 7c 2d 00 00       cmpb   $0x0,0x0(%rbp,%r13,1) <-- trapping=
 instruction
>   30:   74 08                   je     0x3a
>   32:   4c 89 ff                mov    %r15,%rdi
>   35:   e8 3b 38 13 00          call   0x133875
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
-upstream-moderation/68d2db40.050a0220.139b6.0028.GAE%40google.com.
