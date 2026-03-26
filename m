Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 625E23932D4
	for <syzbot@lists.linux.dev>; Thu, 26 Mar 2026 07:39:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774510775; cv=pass; b=nl/WLkI9aWfxZuK7Hfzzlet+SQpUQz9wkkL+n25sMcY0PaX2B4Tm47TT7iWls6SnGvfgZsLI/dpQwO/J6y3lnIhvm5ekjB33nnVC/cGlzP1TMZh7N+OWdd1NLPyJEnbu+ibdF5tdiaGi9cJ/bKaBtaHiGOZTlhkPai7dgyJUR5Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774510775; c=relaxed/simple;
	bh=rzPKx/dNZH4h/f3TnIWK50lnDJjWlAasMP65BRriaEQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=YyGQgVj6bAvLMQdVbaNntGnz67jdAGXWhe2xWjkdBQpeDgXBypCmfV1nU0Vx1lKioN1Q5Sz125LgXn6//6BXQhcbYNNMHiVae3pl3zvBe3C6AQ8AMmDopQm5aeoH27/vTB47uxtXFey3ys6Ig7U3T/GpsLE4r+Z2Omc5f2PYjFA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L7MSNfbD; arc=pass smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L7MSNfbD"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-40f1ffba6a0so445768fac.0
        for <syzbot@lists.linux.dev>; Thu, 26 Mar 2026 00:39:27 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774510766; cv=none;
        d=google.com; s=arc-20240605;
        b=Y8tLnlZVWUMzyelloGLiyI1lQpPuafuINfUTrxnNEanuVNy3LPsvgWmgS9zp/OJWvx
         GVrIyZBzHtuiMtiRt2UnAmGIC+psygbRj7Z5aWYzoc15kYJcHFan8V2P5t0FlqE7bV+f
         abXnHlS6dnKvYbwybR1kG+u6cTxdNcLV0sVDt7Y9BeudWF8LuXc67O1i9aL1EEdQ6dsl
         zfLcgmtMIhmgbcf7zKq1N5tWdtEASTp8Nxlpr32GpmLhcdWRSZ+bYmQnEZy3c9UzfLt1
         Ypll9U0Zk/F9IpceUWf6qoZUrmGzAcW0B/wjC3w6qZDln8Dri9jBfDlPC14rKvioBCKW
         BEtQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=UKiUDomFetKG010pfDnpE1e1S0ifXrxUaihXHSEKmoE=;
        fh=5wCCTuFzebrX6UciwIYrgQVT6Bmfl8iYKLm/H0F7TxI=;
        b=A/PhBRbjkEMnnjdHCPqsrTt0H4sFUNxNhN/uUAOjeX70W90SUa+0+Abdmd7glscemP
         fhQA4Fnc40OY+uF7Ftle8TnBigvyk3MiJyOiTiyxwMZCLZpVBTDe6JqIQJxnew2VMIk7
         y0N/2u7TMH8LIBeKQxsjh/ru21TAqqDUVB9G1koDb/Hozr6YoXjE8qRw1QU3y1thiI33
         22+RDfLjjW3JrIGSTd1eQUaDK3fn0poUjo6txg8VNhcnHVWpOaEHqGYt5caIlQSRtax1
         gYu6Umr6H3hJe9qQnPGpcWzbIFhHztCjM2wyORpjKBuRGEI1fQRWvydDoF2qAE/YozCH
         tLYA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774510766; x=1775115566; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=UKiUDomFetKG010pfDnpE1e1S0ifXrxUaihXHSEKmoE=;
        b=L7MSNfbDLCSWRSuv+RHFeZ2bBiQdwcq5lzx0Di7VpziCxcUE2RkCqdn0Eb9Ch3JuiT
         Uh2FJe2oA43ZcMj4qYFDQwUZHcPDop3dwK0zseqq2d2Mxoxo0q/GnMGSR1D/SXVQJCBA
         LvKEcdbhjjdrsjGU/dv9DYOdYJ4wh9+2bCqDum/v0d1pcIB+vHj1t1wQZTZ9mBQ+7Nml
         1G8P/HP6K8TURMTgb9a6dPlNkz9xYWHSKtBfb+xlH6uUzci0bpv1Egh/jTdKQP7SuUKx
         PmQOLmd31xftoYGt2P16G4CXa3AjabSVStQt+wL4xXwE6VJOyHnaVgrwpcmXgymKEDcJ
         Hldg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774510766; x=1775115566;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=UKiUDomFetKG010pfDnpE1e1S0ifXrxUaihXHSEKmoE=;
        b=I401bUDfDJtCnpENFcJIMmfu1ALk/f7hmrhDUx8itVJzntJvHWNlrlSoLKbzCtg26t
         6pGx0c6j9MlKUHPsR19REDQEusRHbBzrhk/O+V0bLhpsRenQUmo+WxRUFdkMR642yaUA
         veJQslui7MbVNc8cN1PLJjuYX6zAQBMd+6TM2nLJl2cE7DBh93VTVawreB77c1q0ZY9H
         4GLQM3e0ZQlm24NC6SMGvW5NkAmMEEit3UkafYnrWTCU083jxB+Qp2sgh9haykCDbgep
         0njo3daZbarV8pSE2cAuqWDU2bqIKvzvJbp1s0LZPoNzGevjsb48p18fTbbsd+fzGd++
         Y1gg==
X-Forwarded-Encrypted: i=1; AJvYcCX/rLXjz9GeyHsuo8uMTh/SO4PnXiTz0pb0NRr51esX2RbBxC1X4KevRNS2hdzBZexIopPC0Sw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxsiPMatNXSJmdlFluDt6hjaaMf/wU6aW2jWBqVpv43StP/ElI0
	4twYjgn6eYbacowzRG86O4HAEyydDaPA8/6LGm6vQeeyB7qTp1ofm1CXypsBDA/Vl8SBECK4z3l
	JojWaq4qWd65zqH/OViOpKOX20qD4aYSPx/wQEPRw8XcNF67HH5sudsKZ
X-Gm-Gg: ATEYQzzZE47zZaxoJT4otTuu9FTd0XqMMreH7fdOJkylkVqla1/SpuA8TGU6erXR4Tq
	noxeDL+6y6xQTf8XB9Pqh7T+DbTfVN8Vt+P6SbVvJICguMh3NgYd/uYJbhOt1r0j0Swe2jexLIK
	9q0oEYYsTP2oytlMWjvDDm/Z4fw+TzjkhFTIxYa13h5Aqft2Xq5ymhfI35nb0+YMLU8lTNRVxyN
	bcGveqBZukxhbA/iEh8NioZFwZU7vsYpADN5UoyJG2Mlqq2rw9VaOYyg/pMqyZ+2LZwS9GAIoNh
	brrMr8cUR+yLU8l2heBujx2LR4ihEkRsoo6RpN2dlW2oNg74lgc2Xw3L9E/4TQFrOMwg2jA=
X-Received: by 2002:a05:6871:400e:b0:40a:5f51:c9e5 with SMTP id
 586e51a60fabf-41ca70b29b8mr3574925fac.42.1774510766102; Thu, 26 Mar 2026
 00:39:26 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69c4624d.a70a0220.234938.005b.GAE@google.com>
In-Reply-To: <69c4624d.a70a0220.234938.005b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 26 Mar 2026 08:39:14 +0100
X-Gm-Features: AQROBzDvsHuqZiuSi20KORtYaEedUEmP2A3M8909G-8qdz9tSczNZerhBBbfD54
Message-ID: <CANp29Y5GyrHsfnw-gJLg_8CP56KFXgnp5VJiw74U3MHjniV_Mg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/swap, memcg: Introduce swap tiers for
 cgroup based swap control
To: syzbot ci <syzbot+ci5c12489340ca0fe3@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Mar 25, 2026 at 11:31=E2=80=AFPM syzbot ci
<syzbot+ci5c12489340ca0fe3@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v5] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
> https://lore.kernel.org/all/20260325175453.2523280-1-youngjun.park@lge.co=
m
> * [PATCH v5 1/4] mm: swap: introduce swap tier infrastructure
> * [PATCH v5 2/4] mm: swap: associate swap devices with tiers
> * [PATCH v5 3/4] mm: memcontrol: add interfaces for swap tier selection
> * [PATCH v5 4/4] mm: swap: filter swap allocation by memcg tier mask
>
> and found the following issue:
> WARNING in folio_tier_effective_mask
>
> Full report is available here:
> https://ci.syzbot.org/series/6ed50ca2-a106-41e9-aa4d-7c46869e0011
>
> ***
>
> WARNING in folio_tier_effective_mask
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      6381a729fa7dda43574d93ab9c61cec516dd885b
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/e5c66fa8-a7fd-4809-9564-448847b5f=
230/config
> C repro:   https://ci.syzbot.org/findings/d64cc6fa-636a-40a0-b131-d02ce11=
29494/c_repro
> syz repro: https://ci.syzbot.org/findings/d64cc6fa-636a-40a0-b131-d02ce11=
29494/syz_repro
>
> ------------[ cut here ]------------
> debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->d=
ep_map))
> WARNING: ./include/linux/memcontrol.h:377 at obj_cgroup_memcg include/lin=
ux/memcontrol.h:377 [inline], CPU#1: syz.0.17/5955
> WARNING: ./include/linux/memcontrol.h:377 at folio_memcg include/linux/me=
mcontrol.h:431 [inline], CPU#1: syz.0.17/5955
> WARNING: ./include/linux/memcontrol.h:377 at folio_tier_effective_mask+0x=
175/0x210 mm/swap_tier.h:63, CPU#1: syz.0.17/5955
> Modules linked in:
> CPU: 1 UID: 0 PID: 5955 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:obj_cgroup_memcg include/linux/memcontrol.h:377 [inline]
> RIP: 0010:folio_memcg include/linux/memcontrol.h:431 [inline]
> RIP: 0010:folio_tier_effective_mask+0x175/0x210 mm/swap_tier.h:63
> Code: 0f b6 04 20 84 c0 75 6b 8b 03 eb 0a e8 04 b8 9e ff b8 ff ff ff ff 5=
b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc e8 ec b7 9e ff 90 <0f> 0b 90 eb 9b=
 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c c2 fe ff ff
> RSP: 0018:ffffc90004bee6d0 EFLAGS: 00010293
> RAX: ffffffff8226dd04 RBX: ffff888113589280 RCX: ffff8881727b8000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffffea0006c62207 R09: 1ffffd4000d8c440
> R10: dffffc0000000000 R11: fffff94000d8c441 R12: dffffc0000000000
> R13: ffffea0006c62208 R14: ffffea0006c62200 R15: ffffea0006c62230
> FS:  00005555771cb500(0000) GS:ffff8882a9462000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2ed63fff CR3: 0000000112d86000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  swap_alloc_fast mm/swapfile.c:1355 [inline]
>  folio_alloc_swap+0x392/0x13a0 mm/swapfile.c:1735
>  shrink_folio_list+0x26a7/0x5250 mm/vmscan.c:1281
>  reclaim_folio_list+0x100/0x460 mm/vmscan.c:2171
>  reclaim_pages+0x45b/0x530 mm/vmscan.c:2208
>  madvise_cold_or_pageout_pte_range+0x1ef5/0x2220 mm/madvise.c:563
>  walk_pmd_range mm/pagewalk.c:142 [inline]
>  walk_pud_range mm/pagewalk.c:233 [inline]
>  walk_p4d_range mm/pagewalk.c:275 [inline]
>  walk_pgd_range+0xfdc/0x1d90 mm/pagewalk.c:316
>  __walk_page_range+0x14c/0x710 mm/pagewalk.c:424
>  walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:728
>  madvise_pageout_page_range mm/madvise.c:622 [inline]
>  madvise_pageout mm/madvise.c:647 [inline]
>  madvise_vma_behavior+0x28b9/0x42c0 mm/madvise.c:1358
>  madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1713
>  madvise_do_behavior+0x386/0x540 mm/madvise.c:1929
>  do_madvise+0x1fa/0x2e0 mm/madvise.c:2022
>  __do_sys_madvise mm/madvise.c:2031 [inline]
>  __se_sys_madvise mm/madvise.c:2029 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2029
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5e5af9c799
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff0c8e2708 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007f5e5b215fa0 RCX: 00007f5e5af9c799
> RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
> RBP: 00007f5e5b032c99 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5e5b215fac R14: 00007f5e5b215fa0 R15: 00007f5e5b215fa0
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
> [akpm@linux-foundation.org baohua@kernel.org bhe@redhat.com cgroups@vger.=
kernel.org chrisl@kernel.org gunho.lee@lge.com hannes@cmpxchg.org hyungjun.=
cho@lge.com kasong@tencent.com linux-kernel@vger.kernel.org linux-mm@kvack.=
org mhocko@kernel.org mkoutny@suse.com muchun.song@linux.dev nphamcs@gmail.=
com roman.gushchin@linux.dev shakeel.butt@linux.dev shikemeng@huaweicloud.c=
om taejoon.song@lge.com youngjun.park@lge.com]
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
-upstream-moderation/69c4624d.a70a0220.234938.005b.GAE%40google.com.
