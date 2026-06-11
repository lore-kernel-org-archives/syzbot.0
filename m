Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C4E315D3B
	for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 20:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781209402; cv=pass; b=iO7QCNzgADoMtT3DEjeCPuHC+vouFP/Uji/T/kDA8UlaBywd1eRYwVgRlRyi32Ml0DeeezLiX6PskvhTr2aTiac8JXTIymJURi2pw/BaF4TFlLgQ7dKAeydlwyCYf74h6a1w12vuKwEroRwQhDdb+6N9bkbMOC4QmRu/iMbA4jU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781209402; c=relaxed/simple;
	bh=f7JlaHGc+D0Fx+f1b3ScqL++JVcZHF6V7e9dNn4bMxo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=M0iqM9Q3bejWwcShegog1EEPN+fMMug7LU57J9tbJ0XNib45eQmRpiO9UpAahps8TRD5sAuEYcsw1Wtsmf6rqQ+Fla0vdWSm3aUgxWhmpU7oGPKZd+BxchWTCmAbhWmhKEiEufMJq9DvoE9OHw2Yr7NwyqVHsD475YfowfbiMYg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OZC2/GcB; arc=pass smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OZC2/GcB"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-43bfe209e45so245644fac.0
        for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 13:23:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781209399; cv=none;
        d=google.com; s=arc-20240605;
        b=Ir2TH+v9Lq/SryFJ1moJMeVpuSWVpCUFBUtTEtZtA9kggieJGL4mejQd5uY0qEvLuf
         kWAjLGfCpexpoijngYr3MyNuV2uwsM5IAHMo4oilL5fjYrg9NBhr1WVHROX//kM+J8tD
         l6E7wQnYRJx5vLGfTvi+lQBh3SqD3KsP19V3Gr1krHywCI2FFfwV5WSLNOEg4YrS6vWM
         JoUjb8j11HYwChlHd4vkjRs1LnbhafuG2/oUXI0cKPTSDu2NaR7nPqz3x5AWL7cHND7X
         2sY6YyyDeH3WKr/f5cC2Y3hLbmCd3F+NcNw0WQNubxOpispcd48s2sQN4n89h+/I73PF
         Ql2A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=nUMyFof6iY9knO0XVzuQEipTDoNCrn8GGHCIoeKJrDU=;
        fh=kvi0K//IzcPxx/zeoQEwkYRZi57WWAE56UANe4LjM2E=;
        b=ccWFlBNGyHN2FsW6cpWZU4MhFmHEqUGC+uh9TVB33hHEi0u1zkJZj0zyjNpghwmRUa
         51qA/y5kRoyYbYzqvTmGGnW4a4nisvtxXwyrs40D0enuCG/YW3wm2bnbWkcJnkdfjPcI
         1mhDwf9G+3Xa7f2x4h+CFqnBURrmdgD3bq5Wt0FsqMpi2Tv9JvMGXpz3MeAFynNAtn9n
         QaKrVaBgelnxLF/Uo6jlxM8Cc+gPdpZYsHpHXWQuOMUSZhVJ8f2Wn6rB6ljfGnN5TMlX
         ELFBj0AIlOwbNZ1EnZB4MEsB9bZRpUB8XlAEMCu2rZPcptMKLanJlD8C0r2ekWUS5hGv
         DIsg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781209399; x=1781814199; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=nUMyFof6iY9knO0XVzuQEipTDoNCrn8GGHCIoeKJrDU=;
        b=OZC2/GcBjoGQ/tbvdjSYqoGgwXh3SDL2jJV4FR+u805rG3bCpIB/72XaF5Kuc+Nnv0
         3hSC8GNMyx2z5FlDobaIixEKJqZAOU8oqVxIcI1O/aie9y4VfcRvW3ZrJtO/7gsMZg09
         8BqxILtlbmjKR7x5ml2LyMHDKnS5k+dePWCuefDbBnIJCWLQDwkxaXfoZpwgAHzi7nLT
         c3dOYDJSdSN1LYLfiUfrQLauwOqdMRcXSSKWvBEQYd1/DDzEteQ76fjVN3luqC7axLOu
         RIiPhChJj0UOavAaXHBoG2AzGBvFauBQvmkDE+bWhQ6+tGcTO4ADHo+QzhqZVKttVZNZ
         eNLA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781209399; x=1781814199;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=nUMyFof6iY9knO0XVzuQEipTDoNCrn8GGHCIoeKJrDU=;
        b=FjuMfOzxdu90HHu5126gUDpUJNK/UbCLX1NmdC0CKljbZRwYdEjE7dfbkU6giwsYTS
         +OqFJrlrQCJHw1hAiOlPGGlXNvo4Sn1bBlAY3LuFFFz48DLFlFmO7pxvX1K7KDKhvth2
         WN70pGgn7HbWLa9RZMFWNSPPg6lS1GKfBalRKBAlf56VyKeQ6INQo9HHTTLese314gqK
         bBSP3BesW6RIaeMwhsqnoqge8z2AMLcSu7R/AKO1OLyKQy328KcU/pAuyBAE4xJ4vSy8
         QBMZjCot1o1s45uMhzEiKH9WB3S7vmrV49ybYuE31JLYQodyqV/yrjw/4vb9V2UGpV7b
         qO7g==
X-Forwarded-Encrypted: i=1; AFNElJ/FEb1VqUxD4xocrHvkk4sxY2ilZKQV9zhW66Ic3OZF1Dow2BFXgcYR7CFteV70J3q6cCYeodI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxOwxwMlOZ+H6fhR95ATUkuLMsAjynUPc4ym1SanZXKfHHxXual
	RB/ikpHNJXI7L5gCNtKMHnT3IY4mWb7vTx5QzM+weJl8AJjP1fFVUJhX6Cx9g+vfevK6AszfeGD
	xh7PgbuSdqqbbIFts3zE9ryHhM9TjAa+oqnj3GI9Ji9Ijzp+ys7vx/rEb
X-Gm-Gg: Acq92OGbC4Dvumj6pJVTlopdzdh7bbSqmMQQQ9Quv2jQXGLbcwh/D9jTINSOMNEcjyz
	ptY4wawW0s9k3eMpcq546bwxW/laNW+TzI16VgoXxVVLinFvebZpddh59oIltxvKqN9zEagu6vP
	+Nu2xU+N/DbSPNp70/lU4+r237vHuMyaGAnLhpwBOR9HPPR4sRsQPNZV2r5tA0rDcR/+T//PGcJ
	w/qms8qINqtzx38At/ndMQjUSeO4E2ue0m8rLGmQVI6j/m6BskW9yWlaejtdFMaZkr1Mkaj2C0L
	MDOC28CO+nUeqs8WF3pbelgLXuiEKcg9Xf1m3Xr1ibsHgA0C6JxbLevgoqVlE8KYT/ZVBZqJ
X-Received: by 2002:a05:6871:5812:b0:43c:3ae7:5e83 with SMTP id
 586e51a60fabf-44241f49828mr2921939fac.31.1781209398437; Thu, 11 Jun 2026
 13:23:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a2b1043.db1573ee.1e58f8.0004.GAE@google.com>
In-Reply-To: <6a2b1043.db1573ee.1e58f8.0004.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 11 Jun 2026 22:23:05 +0200
X-Gm-Features: AVVi8Cc-QhcLCT3hEcuwh6mw1co4zWk6_LWJ9gXh0pCe4DyAGz6e3Am8HuOIPRw
Message-ID: <CANp29Y6Em1nc5TouhiMb5ZmfG9J-Ln+LX=QmYciWH5o0cUja1g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: split the file's i_mmap tree for NUMA
To: syzbot ci <syzbot+ci0551de102eee8e8f@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Jun 11, 2026 at 9:45=E2=80=AFPM syzbot ci
<syzbot+ci0551de102eee8e8f@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm: split the file's i_mmap tree for NUMA
> https://lore.kernel.org/all/20260611061915.2354307-1-huangsj@hygon.cn
> * [PATCH v2 1/4] mm: use mapping_mapped to simplify the code
> * [PATCH v2 2/4] mm: use get_i_mmap_root to access the file's i_mmap
> * [PATCH v2 3/4] mm/fs: split the file's i_mmap tree
> * [PATCH v2 4/4] docs/mm: update document for split i_mmap tree
>
> and found the following issue:
> INFO: trying to register non-static key in do_one_initcall
>
> Full report is available here:
> https://ci.syzbot.org/series/a9bada61-06e7-40d5-b423-5f2d69a60209
>
> ***
>
> INFO: trying to register non-static key in do_one_initcall
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      14546c7bef6c1036fc82e36c1a200b0caccd339a
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/2f92f704-660a-4108-9172-7e620e10c=
e46/config
>
> acpi PNP0A08:00: _OSC: platform does not support [PCIeHotplug LTR]
> acpi PNP0A08:00: _OSC: OS now controls [PME AER PCIeCapability]
> PCI host bridge to bus 0000:00
> pci_bus 0000:00: Unknown NUMA node; performance will be reduced
> pci_bus 0000:00: root bus resource [io  0x0000-0x0cf7 window]
> pci_bus 0000:00: root bus resource [io  0x0d00-0xffff window]
> pci_bus 0000:00: root bus resource [mem 0x000a0000-0x000bffff window]
> pci_bus 0000:00: root bus resource [mem 0x80000000-0xafffffff window]
> pci_bus 0000:00: root bus resource [mem 0xc0000000-0xfebfffff window]
> pci_bus 0000:00: root bus resource [mem 0x240000000-0xa3fffffff window]
> pci_bus 0000:00: root bus resource [bus 00-ff]
> pci 0000:00:00.0: [8086:29c0] type 00 class 0x060000 conventional PCI end=
point
> pci 0000:00:01.0: [1234:1111] type 00 class 0x030000 conventional PCI end=
point
> pci 0000:00:01.0: BAR 0 [mem 0xfd000000-0xfdffffff pref]
> pci 0000:00:01.0: BAR 2 [mem 0xfebf0000-0xfebf0fff]
> pci 0000:00:01.0: ROM [mem 0xfebe0000-0xfebeffff pref]
> pci 0000:00:01.0: Video device with shadowed ROM at [mem 0x000c0000-0x000=
dffff]
> pci 0000:00:02.0: [1af4:1005] type 00 class 0x00ff00 conventional PCI end=
point
> pci 0000:00:02.0: BAR 0 [io  0xc080-0xc09f]
> pci 0000:00:02.0: BAR 1 [mem 0xfebf1000-0xfebf1fff]
> pci 0000:00:02.0: BAR 4 [mem 0xfe000000-0xfe003fff 64bit pref]
> pci 0000:00:03.0: [8086:100e] type 00 class 0x020000 conventional PCI end=
point
> pci 0000:00:03.0: BAR 0 [mem 0xfebc0000-0xfebdffff]
> pci 0000:00:03.0: BAR 1 [io  0xc000-0xc03f]
> pci 0000:00:03.0: ROM [mem 0xfeb80000-0xfebbffff pref]
> pci 0000:00:1f.0: [8086:2918] type 00 class 0x060100 conventional PCI end=
point
> pci 0000:00:1f.0: quirk: [io  0x0600-0x067f] claimed by ICH6 ACPI/GPIO/TC=
O
> pci 0000:00:1f.2: [8086:2922] type 00 class 0x010601 conventional PCI end=
point
> pci 0000:00:1f.2: BAR 4 [io  0xc0a0-0xc0bf]
> pci 0000:00:1f.2: BAR 5 [mem 0xfebf2000-0xfebf2fff]
> pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500 conventional PCI end=
point
> pci 0000:00:1f.3: BAR 4 [io  0x0700-0x073f]
> ACPI: PCI: Interrupt link LNKA configured for IRQ 10
> ACPI: PCI: Interrupt link LNKB configured for IRQ 10
> ACPI: PCI: Interrupt link LNKC configured for IRQ 11
> ACPI: PCI: Interrupt link LNKD configured for IRQ 11
> ACPI: PCI: Interrupt link LNKE configured for IRQ 10
> ACPI: PCI: Interrupt link LNKF configured for IRQ 10
> ACPI: PCI: Interrupt link LNKG configured for IRQ 11
> ACPI: PCI: Interrupt link LNKH configured for IRQ 11
> ACPI: PCI: Interrupt link GSIA configured for IRQ 16
> ACPI: PCI: Interrupt link GSIB configured for IRQ 17
> ACPI: PCI: Interrupt link GSIC configured for IRQ 18
> ACPI: PCI: Interrupt link GSID configured for IRQ 19
> ACPI: PCI: Interrupt link GSIE configured for IRQ 20
> ACPI: PCI: Interrupt link GSIF configured for IRQ 21
> ACPI: PCI: Interrupt link GSIG configured for IRQ 22
> ACPI: PCI: Interrupt link GSIH configured for IRQ 23
> iommu: Default domain type: Translated
> iommu: DMA domain TLB invalidation policy: lazy mode
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
> CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  assign_lock_key+0x133/0x150
>  register_lock_class+0xcc/0x2e0
>  __lock_acquire+0xad/0x2cf0
>  lock_acquire+0x106/0x350
>  down_write+0x96/0x200
>  dma_resv_lockdep+0x39c/0x660
>  do_one_initcall+0x250/0x870
>  do_initcall_level+0x104/0x190
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x2a6/0x3e0
>  kernel_init+0x1d/0x1d0
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
> ------------[ cut here ]------------
> DEBUG_RWSEMS_WARN_ON(sem->magic !=3D sem): count =3D 0x1, magic =3D 0x0, =
owner =3D 0xffff888102a95940, curr 0xffff888102a95940, list not empty
> WARNING: kernel/locking/rwsem.c:1405 at up_write+0x1e2/0x410, CPU#0: swap=
per/0/1
> Modules linked in:
> CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:up_write+0x2b1/0x410
> Code: c0 c0 e6 cc 8b 49 c7 c2 a0 e6 cc 8b 4c 0f 44 d0 48 8b 7c 24 10 48 c=
7 c6 40 e8 cc 8b 48 8b 54 24 08 48 8b 0c 24 4d 89 f9 41 52 <67> 48 0f b9 3a=
 48 83 c4 08 e8 21 1f 0d 03 e9 b2 fd ff ff 90 0f 0b
> RSP: 0000:ffffc90000067480 EFLAGS: 00010246
> RAX: ffffffff8bcce6c0 RBX: ffffc900000677d0 RCX: 0000000000000000
> RDX: 0000000000000001 RSI: ffffffff8bcce840 RDI: ffffffff90338290
> RBP: ffffc90000067830 R08: ffff888102a95940 R09: ffff888102a95940
> R10: ffffffff8bcce6c0 R11: fffff5200000cefc R12: ffffc90000067828
> R13: dffffc0000000000 R14: 1ffff9200000cf06 R15: ffff888102a95940
> FS:  0000000000000000(0000) GS:ffff88818dc9e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  dma_resv_lockdep+0x3a4/0x660
>  do_one_initcall+0x250/0x870
>  do_initcall_level+0x104/0x190
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x2a6/0x3e0
>  kernel_init+0x1d/0x1d0
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [acme@kernel.org adrian.hunter@intel.com akpm@linux-foundation.org alexan=
der.shishkin@linux.intel.com baohua@kernel.org baolin.wang@linux.alibaba.co=
m brauner@kernel.org brian.ruley@gehealthcare.com corbet@lwn.net dave.angli=
n@bell.net david@kernel.org deller@gmx.de dev.jain@arm.com dinguyen@kernel.=
org djbw@kernel.org fangbaoshun@hygon.cn harry@kernel.org huangsj@hygon.cn =
irogers@google.com jack@suse.cz james.bottomley@hansenpartnership.com james=
.clark@linaro.org jannh@google.com jolsa@kernel.org lance.yang@linux.dev li=
am@infradead.org linmiaohe@huawei.com linux-arm-kernel@lists.infradead.org =
linux-doc@vger.kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.k=
ernel.org linux-mm@kvack.org linux-parisc@vger.kernel.org linux-perf-users@=
vger.kernel.org linux-trace-kernel@vger.kernel.org linux@armlinux.org.uk lj=
s@kernel.org mark.rutland@arm.com mhiramat@kernel.org mhocko@suse.com mingo=
@redhat.com mjguzik@gmail.com muchun.song@linux.dev namhyung@kernel.org nao=
.horiguchi@gmail.com npache@redhat.com nvdimm@lists.linux.dev oleg@redhat.c=
om osalvador@suse.de peterz@infradead.org]
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
-upstream-moderation/6a2b1043.db1573ee.1e58f8.0004.GAE%40google.com.
