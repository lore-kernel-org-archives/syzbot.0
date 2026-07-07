Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5B6921ABBD
	for <syzbot@lists.linux.dev>; Tue,  7 Jul 2026 21:30:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783459836; cv=pass; b=BU/BHAMPmZr1BBVHaolI4XwxvtiO0qLje04vO86jV1RJ2rRxR0WQxOXtZrx5AvF6dgpoXj5Puvek8VgGkmoBgLr35jDXpJos+jPVoy1zw72CoezI3yfTS4ypdzvkWjWn3xDUpJscSFXC00KA56Tj6vuKPh2djSeTpZsjkHZtudE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783459836; c=relaxed/simple;
	bh=EJM3s/x7iNsVsNm8LW2t2klylQ6MvyfY0qtbAMn1Jgs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QWUO0GySQeZm1FlzK0/X+wG9/sT6LTXDtAtbSJqzzaABpAeYdJN3kkIzSyMQ1OjhCvoY9NallohvAga/xr6d9++sP/FO4YDqLs8zTPxXoINWsEEoXXd16jM1E1WaNAZpVkjBmPeYLeUJFaaI5F36W1tLXqM6+GZQuKeHOYYryo0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IJTDZpiD; arc=pass smtp.client-ip=209.85.161.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IJTDZpiD"
Received: by mail-oo1-f43.google.com with SMTP id 006d021491bc7-6a18e363d52so21258eaf.0
        for <syzbot@lists.linux.dev>; Tue, 07 Jul 2026 14:30:34 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1783459834; cv=none;
        d=google.com; s=arc-20260327;
        b=XaKMqcC/tp2LjM0AmlwJVjTfRz8yJAWhj117bHEonlz+OSrXzp7Sstwym6vMonFORz
         nJly7zGlFVB/lRU4nFpLVz6SRju1cGr1mnUdO8bXc7djCLGi2cPrdJ4/Xp7e3oRV8vmm
         e9Q24J+zf64Jg3nDdjG6vZzHbyeufqX1I+o4TnF/y2dLGu3pQcyzkVxWBpQtbzeb63Sh
         KYNfB9gJn+PDTebk+Tj6JaU75JUVeHXdUj5QOrm3vmDv+zA3TOOlc5AaADoxtD3gIZTc
         MwpSyKoIet11Uf/jh+///+j3UWRJbTFFzcRilLysJPfTEhJs3O/J804Wq1ZZfQMfImaQ
         U9dQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tYC4EBdj8JPQ+vxbluSZijUQ1CMYxcqSfWb96fkVbQM=;
        fh=9XBoO+xNrgm2UTeZC7PzjAJbWI3B1y/ybXJ5Y6djnR0=;
        b=nPjK/2wrAHAOlaJoKld/9iaqkXkH3ICgKfGBxEyIYYDPy0tTRRg+lSP62C1XZC1vwc
         MHqBlkibjhI8NWdI+Mvmac8T0a6TFghgnMCxvP57zKcT9pfZt7Cv6fGeOXCWr4X1vixL
         AdMSrOChW9MaPC0k6d4Bx7FwxKzu6an36CkZKUE2SUgWhLhMBrEo6W9GnF1Qd9sCYb3f
         sCi3yUhAY2MQ79ih5SvIr6UyC1er3sdE4JXOaVh4J8yqEHHFliZRDqp5AB1+Cks2NwQv
         BgdqjiySMCjnjz6YILnpE8ZYMX0dXlA7Oy1172AtN0NrpXml8IO4XlGRHrEtcCh0zvpv
         xzBw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783459834; x=1784064634; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=tYC4EBdj8JPQ+vxbluSZijUQ1CMYxcqSfWb96fkVbQM=;
        b=IJTDZpiDUdaAHLn0kK2FTXSt8l7RkgzCEKHos7SwhLwS64n+1M/gzYvWSx18zihE/F
         XzdPzU6LbWj9Goh+/xjconqfF34mMuJPlwM2t3cHUFXcJY/rjtHmFsI0w8dL7tLol8sZ
         weEg6DBm/gjEzRJRmC3ITPS3dZjCI+kJuM+Xj5v7Dp6yhQ/88owPVvT0mkP53vobUxEe
         YdqMbidiFCe/5lxBrUbKEF1PkpvQTvZXsgb7h3yqy101q40HLs4rAbsUUxzuydfqrLaw
         b5CMzYEaF2ArB3uOGp6UNChd0m0FBJSsTntuu6vAL1CH4Q/NBQnpZ/MI0CzDwtT+R151
         zSdw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783459834; x=1784064634;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=tYC4EBdj8JPQ+vxbluSZijUQ1CMYxcqSfWb96fkVbQM=;
        b=Zinx9RjQhDM1oMJyASe0kmh1Sziw0nKOest1aHGo2TYUYlT0CmySdR+8JSB8SHymgc
         ngDEf5CuNkJfutp/dB4XTatsggQisU7iwN9y1x7P2haW20WHj1xFuCL2PZxNxzIuKUD2
         ZU9nySGgRGloYbx0c9vx+g+HnIS/RFf0pAR647HGKWe2XKg+hFcOC7FzN6EVUnyqYSS2
         Nh28eQgJmALHrtzjTVxM5SSt0XCu3Rtk2zMhjTvAip9b1xB4397/ly8lhBhQoDH0MsJR
         S0kL2PpLJNX9w+GuYU3pROMMaGF44YHMTJaxjV7/t5OfXETMdq2HQI/c3IPMls97YE4a
         qGLQ==
X-Forwarded-Encrypted: i=1; AFNElJ+hnS8Lr0HnQ1CDUJxEXUqyd8c/b/ajXjSlHosqWd6r/zA/LPMqjS4hFmB4oCZUxc/DC5T/FE4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6eELgWfw4fBDomAEKq+H2Epna6m/BsnjfiFHtV+u/N0Lou5sp
	W+HfsLHMWSxD0X7F0B5HD+LY979SwmWYkB4d/ixXYg22GkhS2Nw9XpeEGW6rpf4Vn8+zMLdnZKp
	FbQmfFxOqaHKJsWBbplRDuYoLGTwMdOcL/Vx23V8E
X-Gm-Gg: AfdE7cnxPsxBH6PxWxgWvi5KOblC4YRLg8g3zY02UCzrFcB3inbXzHgsb+Oxv8PK8No
	QyJdY+lGci1t4PX34pj400ZkOd15Dj5wQxt0ciRfTiQZTZ6iC9S/S4/UOZW0eQYTQV5WhJ5kNbH
	qgZ0nYSp8xIKOINB9QH62HXPom5/BReQxU8WjkxkO4JotwNsNCrSb/GohbA9ud4RrOScwL3/DwB
	4S58CeC1VWCoaiiA9ljgpXZCE0XtAfmmbEBIIiHIuBqHB2ynY5jAaeLtxsrx2Cg4LNmrj8/8Jve
	x9Kj/uQwxF9duyKVHhV3VM4c2wELDLd/XdaoY2b3P9CS7SP715WTxLYKh8qX+CJDM6sciyWReO1
	bhL309sXi5lF58vWem1xKeuGTXjvLt0PxVtOLHSVGvA==
X-Received: by 2002:a4a:edcb:0:b0:6a1:87a3:af3c with SMTP id
 006d021491bc7-6a35c30b9e3mr2713938eaf.14.1783459833188; Tue, 07 Jul 2026
 14:30:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a4d5716.a1ad617e.25832.0009.GAE@google.com>
In-Reply-To: <6a4d5716.a1ad617e.25832.0009.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 7 Jul 2026 23:30:22 +0200
X-Gm-Features: AVVi8Cd08iOV4wJq5_EM6mEoBdHBofgp5Uy47PIGWdDPYlpT9qUxw0Sfb1us20M
Message-ID: <CANp29Y7k-H5ocTinTPkmAZEeYMW0eQ-nPZhrm9SAM+=xH6sqMg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: store zswap entries in swap table
 (Pointer entry)
To: syzbot ci <syzbot+ci3c668b9bdaa73218@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Jul 7, 2026 at 9:44=E2=80=AFPM syzbot ci
<syzbot+ci3c668b9bdaa73218@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm: store zswap entries in swap table (Pointer entry)
> https://lore.kernel.org/all/20260707073215.72183-1-baoquan.he@linux.dev
> * [RFC PATCH 1/7] mm/swap_table: add Pointer type support for zswap entry=
 storage
> * [RFC PATCH 2/7] mm/zswap: add swp_tb_val to zswap_entry and Pointer acc=
essor helpers
> * [RFC PATCH 3/7] mm/swap_state: do zswap conversion in __swap_cache_do_d=
el_folio
> * [RFC PATCH 4/7] mm/zswap, mm/swap_state: handle Pointer entries in add_=
folio path
> * [RFC PATCH 5/7] mm/swapfile: handle Pointer entries in count/dup/put pa=
ths
> * [RFC PATCH 6/7] mm/zswap, mm/swap_state: migrate zswap to use swap_tabl=
e for entry indexing
> * [RFC PATCH 7/7] mm/zswap, mm/swap_state: replace xarray indexing with s=
wap table lookups
>
> and found the following issue:
> WARNING in __swap_cache_do_del_folio
>
> Full report is available here:
> https://ci.syzbot.org/series/1a9cfadb-ed85-48c1-b1b3-a3c12ea99471
>
> ***
>
> WARNING in __swap_cache_do_del_folio
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      01bc0932614c2d3c35e732f54d249b5897d94307
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/65f10583-d539-4b33-8ba9-494d42eb9=
593/config
> syz repro: https://ci.syzbot.org/findings/3673912c-5490-4f26-ba24-276021c=
43d9b/syz_repro
>
> ------------[ cut here ]------------
> !swp_tb_is_folio(old_tb) || swp_tb_to_folio(old_tb) !=3D folio
> WARNING: mm/swap_state.c:327 at __swap_cache_do_del_folio+0x6ef/0xdf0 mm/=
swap_state.c:326, CPU#1: syz.2.63/6057
> Modules linked in:
> CPU: 1 UID: 0 PID: 6057 Comm: syz.2.63 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__swap_cache_do_del_folio+0x6ef/0xdf0 mm/swap_state.c:326
> Code: ff c9 48 09 c1 4c 21 f9 48 39 4c 24 08 0f 85 8c 02 00 00 e8 73 9a 9=
b ff 49 bf 00 00 00 00 00 fc ff df eb 3d e8 62 9a 9b ff 90 <0f> 0b 90 41 89=
 ed 41 83 e5 01 31 ff 4c 89 ee e8 2d 9f 9b ff 31 ff
> RSP: 0018:ffffc90003ea6690 EFLAGS: 00010093
> RAX: ffffffff822acdb9 RBX: 000000000000001f RCX: ffff88816d7d9e00
> RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffffea0006be5f08
> RBP: 00000000006be5f2 R08: ffff88801c7d20ff R09: 1ffff110038fa41f
> R10: dffffc0000000000 R11: ffffed10038fa420 R12: 0000000000000000
> R13: 0000000006be5f00 R14: 0000000000000002 R15: dffffc0000000000
> FS:  00007fef4622c6c0(0000) GS:ffff8882a921d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000280 CR3: 0000000176c44000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __swap_cache_del_folio+0xd5/0x170 mm/swap_state.c:377
>  __remove_mapping+0xabb/0xe20 mm/vmscan.c:736
>  shrink_folio_list+0x2b42/0x5350 mm/vmscan.c:1489
>  reclaim_folio_list+0x100/0x430 mm/vmscan.c:2163
>  reclaim_pages+0x2f1/0x530 mm/vmscan.c:2196
>  madvise_cold_or_pageout_pte_range+0x1c1e/0x22e0 mm/madvise.c:562
>  walk_pmd_range mm/pagewalk.c:148 [inline]
>  walk_pud_range mm/pagewalk.c:239 [inline]
>  walk_p4d_range mm/pagewalk.c:280 [inline]
>  walk_pgd_range+0x100f/0x1e40 mm/pagewalk.c:321
>  __walk_page_range+0x16d/0x720 mm/pagewalk.c:429
>  walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:733
>  madvise_pageout_page_range mm/madvise.c:621 [inline]
>  madvise_pageout mm/madvise.c:646 [inline]
>  madvise_vma_behavior+0x2922/0x4340 mm/madvise.c:1357
>  madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1712
>  madvise_do_behavior+0x385/0x540 mm/madvise.c:1907
>  do_madvise+0x327/0x3a0 mm/madvise.c:2005
>  __do_sys_madvise mm/madvise.c:2014 [inline]
>  __se_sys_madvise mm/madvise.c:2012 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fef4539ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fef4622c028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fef45616180 RCX: 00007fef4539ce59
> RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
> RBP: 00007fef45432e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fef45616218 R14: 00007fef45616180 R15: 00007ffcd47ce068
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
> [akpm@linux-foundation.org baohua@kernel.org baoquan.he@linux.dev chengmi=
ng.zhou@linux.dev chrisl@kernel.org hannes@cmpxchg.org kasong@tencent.com l=
inux-kernel@vger.kernel.org linux-mm@kvack.org nphamcs@gmail.com shikemeng@=
huaweicloud.com yosry@kernel.org youngjun.park@lge.com]
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
-upstream-moderation/6a4d5716.a1ad617e.25832.0009.GAE%40google.com.
