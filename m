Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 252AF7081A
	for <syzbot@lists.linux.dev>; Sun, 25 Jan 2026 22:11:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769379121; cv=pass; b=Pf+kLR7stXRw/DIvXp2gDte+V69FqdZppijjzgdC4RdcH60cpqiBrOSPOUlj046tU47La0g8HNpMXBAQh1zGjcT2CCUJZHN5aPyMhigEhNu8caSpTZQOEL9ox1Du3X70zu3lTzV7IsHVftydrdwX15w3vuaGN9e45Dpksmb78mg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769379121; c=relaxed/simple;
	bh=ljWH3f5ex9szUll96D5E4JY3/z94vs47kQr6lFepsxo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=obWGoE3t7dJE9mjagANiy1B6lDuPANXmkf0TWAyyRR0BxCVJPCIzd/aAYznTXBCUjaTMg9y4gu/SkYT+Le8flzlTBcwIb3HsDzURiyWKaFAts9bJoVSSPScWssjaBLMydlQrQd8wD1Drgo05DSRZqOaMquiC2XgLesKA2GANadA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=cFh0n8iw; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="cFh0n8iw"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-662b6d1e081so1757300eaf.3
        for <syzbot@lists.linux.dev>; Sun, 25 Jan 2026 14:11:59 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769379119; cv=none;
        d=google.com; s=arc-20240605;
        b=Po0QSv9Al1HLQPvuIxbYEe3GSkJ+RVg4rzfqRMTcPh3oafV9SdY9xPvJwI26ibwjOA
         b6lfYdap3ZHyOjQOVZoZDEy9v33YSziKuPna8ImAQhzywY/NMAsUIpGCF+Sy/cZY9RcH
         GHtwVQFkqPnVLoo3NMNEYcUGbkLmQ6EUeJ38izbKqqyGTIZag265Pl2bn6q9nNCJq7OV
         s8d7JQ45yC1A2v297yFAp1yKb5Gsl9DwJ9IRnsiP0UYjS2+xCVapWkbRdB8qK84LF1+M
         a8mMZt/5zS4uUTTBLITknE/KpyZN3EcYfBuvMl1lz6MIEMq/wFzAWHtxkad7AvSZYqOV
         7oIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=bYZRMnJe7EA6GnkYzkGEJnmO/pYW11dCW+ZjqW46MAU=;
        fh=fhkXlNimCS94Ps7cbutR0JnTl5qEbGiwhNEFAlhMIe4=;
        b=eBtFqGJ9DvrWgbXMpRxWTNFD9f3Y1enfHfePzIaBSnurIuyLN4LQ6WKOzulJFkiFc0
         pIxg1QYBKKBqyDvVn4YTzF/4Pb+J+sU+sEIqO81aIFJZJQRnbVe9kN/d98LzLGs/mL4d
         BoYi9BJnHdsv9WygN4bqB+uy9Bt8dH4ridnRxdso8PN4nbrC0FVi6H97q6sS+TjYIh9z
         Ggr4ztkmTiChYzsKfy+UYyEGphfjtYM2qhIjbpTBx620e8ssm7S9dCQ6PttpAaVln6MG
         wE+auQdDLwAZuoGCsH678QE/Ur1F4fNJ3a4Mltf+E+nNm5/sRBZRU9Yeao5TGFHMackc
         ciTQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769379119; x=1769983919; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=bYZRMnJe7EA6GnkYzkGEJnmO/pYW11dCW+ZjqW46MAU=;
        b=cFh0n8iwKTZXgJJzcxUcODNwyzwDIRpHWwLr+ldMjIB6ZHDa7SIg7/TofFh5X44Jan
         Y8tQHGHxNz5p2fB/WReXxHZDsjdKjvR/IHwfU/R2VTYQWssVfsthFJy2Bkna7T7UOpaZ
         Hm55d+nYef9fpiO7wnX2UPrsykEMCZY1ePppM8zZFEoVfrfLi5CkM7l/oQvsQ3G+HFWF
         dlW3kKD1dskf+FYYAveAb+IkP/xzLzuHMInBZVvpdNlhHV+CeXb/SEa3TWwM3lBFoZ5D
         fq9+Aw2uMWif9PKaawhAPnZmCrLcFt/Yx7fdAWg2Eqs7GLxmG2EZKoEkDd/SROcAF9KX
         iAFQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769379119; x=1769983919;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=bYZRMnJe7EA6GnkYzkGEJnmO/pYW11dCW+ZjqW46MAU=;
        b=fXEfNNIThF/Wu7azxR0l1a9rBb1l6+lrajDot8v/AaeY4FWBU4+eq2DfOAbuai/MVW
         aUWUAS4OwjPyNX+3XOlRsJKFKPtj/5e6v8kXySGFmRq6GUGsoq9TdugAjp+356+sUd4P
         bg05wMS38HRZlKfJHZ+pgld8WkVLBdK7GWpyc5IOOzN5dkOE1mdxJmJ+spB6by2LBW2p
         fdDmVamnA2xp54aq81bd3EzG9LPfAiukjzUKY+poAn21BoLqgh6fQ5pXILsXk2tbQAcq
         l5SlkHPj5Bhp5RKWmTgbnXdJVMgfnodRK2AnFqvmL5wzICwdaoZtvG+h5lOvyu0HTYH5
         Tx8A==
X-Forwarded-Encrypted: i=1; AJvYcCUCNZFavTm8pEzjFOJnLYB9VdH4d32rjRKLgJJRwvW2CgNIfTvsDUCMdJ9xTSq77pwuozzqqeI=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy7uXlFmB6zASqpuqDuvhBpkHGuEq/e3O9VIosk3tkVf8rnzc+X
	5V3OeP9+lK8zha/vNuogCahoLPPF/GRIEYA4EClD5BpV4RjsrRHFUmDfb2MSJ1WvIispoNLTdif
	DdNJ3JdzfCDuP227G0v2XnTgfotvhPXAnsfynq/kdaEoJbvqGZ0PI+72I7W0=
X-Gm-Gg: AZuq6aIeITyXbjzb1AOsJBmfcx6cisPq3TimoKiIONIM3vulv4MPghE09gEz/0ywnFO
	i+XNSoTszOdyWRxTABZZcQ5nXB7kTVzA2Gd84amhwuZV5hOazEJKFLVwhWkVyh5ov4x4pLduYrV
	ObsPHGouwkWhnC7kXqkJ7GzU9R0WTfJun1XcLcHoUZkJtr/qGIKQ74BHJUkY/gHtlu86tkiNUkt
	L2ckyreVogqc3ptU3gMZLib7Ov+Yfl1S7EG/lNyuStUS98r/ds8MOcD0zy/Pncp7P8drBquD5DH
	s3Ehhf3tQ4EogSpF/yujjoaE9+E=
X-Received: by 2002:a4a:ee07:0:b0:65c:fd25:f425 with SMTP id
 006d021491bc7-662e03fcaebmr1398827eaf.34.1769379118803; Sun, 25 Jan 2026
 14:11:58 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6976926a.050a0220.226181.0010.GAE@google.com>
In-Reply-To: <6976926a.050a0220.226181.0010.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 25 Jan 2026 23:11:47 +0100
X-Gm-Features: AZwV_QgXaSm90OsAdVrWrOFwYluy7uxAbQHCK3yc4ffthH9yicPJQRTLfxNs9sk
Message-ID: <CANp29Y6qgH9PZsjgqNc8+y7fp7m2ZJkP89sM+na2ViHtQnucCA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm, swap: swap table phase III: remove swap_map
To: syzbot ci <syzbot+ci5ec449260bbe2ead@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Jan 25, 2026 at 11:00=E2=80=AFPM syzbot ci
<syzbot+ci5ec449260bbe2ead@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm, swap: swap table phase III: remove swap_map
> https://lore.kernel.org/all/20260126-swap-table-p3-v1-0-a74155fab9b0@tenc=
ent.com
> * [PATCH 01/12] mm, swap: protect si->swap_file properly and use as a mou=
nt indicator
> * [PATCH 02/12] mm, swap: clean up swapon process and locking
> * [PATCH 03/12] mm, swap: remove redundant arguments and locking for enab=
ling a device
> * [PATCH 04/12] mm, swap: consolidate bad slots setup and make it more ro=
bust
> * [PATCH 05/12] mm/workingset: leave highest bits empty for anon shadow
> * [PATCH 06/12] mm, swap: implement helpers for reserving data in the swa=
p table
> * [PATCH 07/12] mm, swap: mark bad slots in swap table directly
> * [PATCH 08/12] mm, swap: simplify swap table sanity range check
> * [PATCH 09/12] mm, swap: use the swap table to track the swap count
> * [PATCH 10/12] mm, swap: no need to truncate the scan border
> * [PATCH 11/12] mm, swap: simplify checking if a folio is swapped
> * [PATCH 12/12] mm, swap: no need to clear the shadow explicitly
>
> and found the following issue:
> WARNING in swap_cluster_lock
>
> Full report is available here:
> https://ci.syzbot.org/series/3f6169fc-e24a-4a19-ba56-e5907b448edc
>
> ***
>
> WARNING in swap_cluster_lock
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      5a3704ed2dce0b54a7f038b765bb752b87ee8cc2
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0eabd97a-86d8-4606-9d94-dbe4e7fd7=
c07/config
> C repro:   https://ci.syzbot.org/findings/5b039fd0-70da-4954-817d-8bf8631=
5c684/c_repro
> syz repro: https://ci.syzbot.org/findings/5b039fd0-70da-4954-817d-8bf8631=
5c684/syz_repro
>
> ------------[ cut here ]------------
> offset >=3D si->max
> WARNING: mm/swap.h:88 at __swap_offset_to_cluster mm/swap.h:88 [inline], =
CPU#1: syz.0.548/6508
> WARNING: mm/swap.h:88 at __swap_cluster_lock mm/swap.h:101 [inline], CPU#=
1: syz.0.548/6508
> WARNING: mm/swap.h:88 at swap_cluster_lock+0xef/0x130 mm/swap.h:132, CPU#=
1: syz.0.548/6508
> Modules linked in:
> CPU: 1 UID: 0 PID: 6508 Comm: syz.0.548 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__swap_offset_to_cluster mm/swap.h:88 [inline]
> RIP: 0010:__swap_cluster_lock mm/swap.h:101 [inline]
> RIP: 0010:swap_cluster_lock+0xef/0x130 mm/swap.h:132
> Code: e8 86 3b 5a 09 4c 89 f8 5b 41 5c 41 5e 41 5f 5d e9 86 86 5a 09 cc e=
8 90 ff a0 ff 90 0f 0b 90 e9 3f ff ff ff e8 82 ff a0 ff 90 <0f> 0b 90 e9 6f=
 ff ff ff e8 74 ff a0 ff 90 0f 0b 90 eb a4 e8 69 ff
> RSP: 0018:ffffc90004ae66c0 EFLAGS: 00010293
> RAX: ffffffff82219a6e RBX: 0000000000007a12 RCX: ffff888110363a80
> RDX: 0000000000000000 RSI: 0000000000007a12 RDI: 0000000000007a12
> RBP: 0000000000007a12 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff5200095cccc R12: dffffc0000000000
> R13: ffff888175c2a010 R14: ffff888175c2a000 R15: 0000000000007a12
> FS:  000055556978b500(0000) GS:ffff8882a9923000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fca0a017dac CR3: 0000000112e64000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  cluster_alloc_swap_entry+0x20f/0xa40 mm/swapfile.c:1090
>  swap_alloc_slow mm/swapfile.c:1385 [inline]
>  folio_alloc_swap+0x81f/0x1190 mm/swapfile.c:1717
>  shrink_folio_list+0x2714/0x52b0 mm/vmscan.c:1306
>  reclaim_folio_list+0x100/0x4f0 mm/vmscan.c:2205
>  reclaim_pages+0x45b/0x530 mm/vmscan.c:2242
>  madvise_cold_or_pageout_pte_range+0x19b9/0x1d00 mm/madvise.c:561
>  walk_pmd_range mm/pagewalk.c:130 [inline]
>  walk_pud_range mm/pagewalk.c:224 [inline]
>  walk_p4d_range mm/pagewalk.c:262 [inline]
>  walk_pgd_range+0x1032/0x1d30 mm/pagewalk.c:303
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:411
>  walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:715
>  madvise_pageout_page_range mm/madvise.c:620 [inline]
>  madvise_pageout mm/madvise.c:645 [inline]
>  madvise_vma_behavior+0x382e/0x4240 mm/madvise.c:1364
>  madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1719
>  madvise_do_behavior+0x386/0x540 mm/madvise.c:1935
>  do_madvise+0x1fa/0x2e0 mm/madvise.c:2028
>  __do_sys_madvise mm/madvise.c:2037 [inline]
>  __se_sys_madvise mm/madvise.c:2035 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2035
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fca09d9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe78abed08 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fca0a015fa0 RCX: 00007fca09d9acb9
> RDX: 0000000000000015 RSI: 0000000000600003 RDI: 0000200000000000
> RBP: 00007fca09e08bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca0a015fac R14: 00007fca0a015fa0 R15: 00007fca0a015fa0
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
> [akpm@linux-foundation.org baohua@kernel.org bhe@redhat.com chrisl@kernel=
.org david@kernel.org hannes@cmpxchg.org kasong@tencent.com linux-kernel@vg=
er.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com nphamcs@gmail.c=
om ryncsn@gmail.com shikemeng@huaweicloud.com]
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
-upstream-moderation/6976926a.050a0220.226181.0010.GAE%40google.com.
