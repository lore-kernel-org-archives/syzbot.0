Received: from mail-qt1-f176.google.com (mail-qt1-f176.google.com [209.85.160.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C5EA27CCF0
	for <syzbot@lists.linux.dev>; Sat, 25 Jul 2026 05:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.176
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784955771; cv=pass; b=DyA90EOaXXAhrjEvMKUWbTAhDFTQu9IzhxvKPtpIBJDJgEDpxv7+g1jYwOu0GUVUGjSRhaAFWb0APDJUZQQeLDolqOKoee7nv25SZ8+cC+k/Xl4O5fomje3OhAuLKaQuaqS5fqHjuJUUsA7C7bbficS/CmVLc7BFKvPs7A3ScPw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784955771; c=relaxed/simple;
	bh=1ZCzvAUyZn/ewMWfW0o6joYbM9UylEAE9unww4nO0NQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jcxCt66nTwiC0b5zp3orzydnWRA3gNXxEXaozJds5idmoIzFjmV4s+kQjB2VK2c4WSb8XxLz/PzWRBXPWGmgqrovRCxqUttOYS5WsHOUFTJedXPn90S97kXSLkA8sYJhAqz6fMVjDboIBJXo1id+KhQXtU4A2lnDoHoroX2ZdsQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=W1YrckkO; arc=pass smtp.client-ip=209.85.160.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="W1YrckkO"
Received: by mail-qt1-f176.google.com with SMTP id d75a77b69052e-51c1372f84dso9671081cf.2
        for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 22:02:49 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784955768; cv=none;
        d=google.com; s=arc-20260327;
        b=ottTLnnQiNPm3DAfsGcbGARqMiJS4DYLe4+iYSvdFfJtCooAArfEO7GP6U6RUNCI2W
         gk0liU/bTSX1Z4mCyzfd97IoR4/CRNGj98h8TIqkb/FDt0slcHWjlYDGg2kvzHoJm/I0
         ogNy+RIM9/+uWiic75eX0NQ9ZAIXvvsgL4qXw4jEzSjue6Pgy9sJ1Ix0ZAJ/avkxwsLp
         OR2KQrtDlKDAUsEPmpI313Ws9a8j3Ie5MtfWDUyVEBwquZWLME/vEGQX4aj9fsOpT55J
         YVK7dAeqgelbvu5+RckXBU92EMQ2IVIzaiAYw9R+cRAzc+n7lVHHhw1OFEdsiwoCxbQO
         8CKQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=lQhGWOYV9jxRWmB8f5hB8n+S6gwXLsnuuqiPTw12DiM=;
        fh=DULh14Oy8qvyRt43OlduOVUwbICB2hkusSIdWZYrpqM=;
        b=a3CLiRYc4dVgPS3L4bjBe55EwhO4Vy/aCWwVZ+b/ejqeLigYzhtEqPSStmVE9kgm/g
         qxJQc9DWpy/a5o9BSTQn6blnB2OQLDe3675vcG+6WOklLTpG048PVVu1WwMIAM8B1Cfm
         VuokIQcyk09l+FFZtVcUEFaGyIJ3wUewNY1m64kiqck37PEkZsIP6bJjoArkQuTp+4DD
         8+sy7GTyTGJCNQOhC2LdkD7Gz0cPLK2eSXi9IQfXGC7g7YC4tTc4Xj1emhwDabunKVge
         aW0hCtafc4ywW0UXacLsgl/zkSgl/IuWw4NHhddlXcl+P70AhTr3o2Bxn3lw7p4CsLe4
         3V9g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784955768; x=1785560568; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=lQhGWOYV9jxRWmB8f5hB8n+S6gwXLsnuuqiPTw12DiM=;
        b=W1YrckkOuD8fH1RxYzET0LHoZA5CI2p8TCvMD1xI3sxGWDoq90vCJtq8J0iwaknA0E
         /3slAUMJWdTbXNrq2xfd+SnuCbctuwRM39zURCg74BY3s2yBcFMc5yterjIqJ2brQxKe
         Px2lfM/lczzR0yRXbP86wl/HLLJ3bQAdzYUJWZTFC4tjjycOdyIf2l3ATKW+54phQRIW
         GYOvHbX5E1eqhbpNDM5TacFbcyQR2ebtGBmKXRjEyaxsi5eSUz7cNGaFJ7Anvv1+skRj
         SS4vtcZjAiGT4O5pm8ktu4wCLFo3J/fpEblfWt28wj2IEE79YV0+nN4Yb4YDeLYd4+im
         ZZ8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784955768; x=1785560568;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=lQhGWOYV9jxRWmB8f5hB8n+S6gwXLsnuuqiPTw12DiM=;
        b=nnZjXqMg7W7VgbGvLiwdRbWsJljlLemkTdC1+x6vFx2YqrPK/6jzl3+ltL33cr/m7p
         8S856E0PQTnZPdtfa8xnwqStJ/KVc49icL9mgje6KDqX4hILS67xjmCn7CIWHzRI1UFj
         hd0qvjQQaQ8AxgBUCO4p5+5ngETyNuW2XefOk9uyvu9C8n82pIyO7wYQt8byNQHjFoR8
         kzU5DO8lZ3gS0NMWjGuL2JefJfTz1e/ANcIFecb0I7edOkoadWeamWT7n/6+Z08gGMrY
         s0njtGCEzUVHr+NJOxlObYPJz727gOXQf2Cb5Qif1UN4sLemqufbeNCnU2lX3vUiS9tf
         75xg==
X-Forwarded-Encrypted: i=1; AHgh+Road1+/ZE91iQN5h1jSop/JXRHuIqd180wO80c6dTmVutUKAtyIl9NOEzrJWroXxSjGyC8GE7c=@lists.linux.dev
X-Gm-Message-State: AOJu0YyGmv3KcWUQutMtsRnGzbio2mixGs0R8l0x3lpq79j5un0R3Cax
	WyUk4DC6AVkgYzAMelUFd+WLgXSlmA0iAiPX7tirjth4DZNqO7Rb9aePiAHDReBPASHpyqqMbXl
	OisREDl3/ajsnZZhed9Piyl/2wo7NHBjFG7STRfXj
X-Gm-Gg: AR+sD13VEoyhEJPYMf5ODiFLs3QUULWBDaytdBCCnIkxilhazKIgrhmrZ2iNX4NZSaC
	hXU6I8GIG63eYjU50bivvhSxun29HzAJ1/8dpiZ+Sje4+2GzKoQxvZeAv86W50gmCZRLP3muGwG
	rJD6fe53K3kFUa2xHeAo6qwMqGBLp/phi1FT2zPLpKvES4cJatqTRMgrJVefhoIeoFcaF054qEJ
	AyaRWw/bNLENyjVT4ag5sikbhIhBd4LMgLLt1k5R/JvsB4YCViItpJha/semxmGpgreVomEn0OU
	Pesxy1fxKwoqKDHbkyb5csnYjZnpUi4log7iEVlAh3Tetnz8ZiHD
X-Received: by 2002:ac8:5e4f:0:b0:51b:efbb:fbf with SMTP id
 d75a77b69052e-529a830f8cfmr11429491cf.18.1784955767605; Fri, 24 Jul 2026
 22:02:47 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a63f6b1.073198cf.94f0f.0009.GAE@google.com>
In-Reply-To: <6a63f6b1.073198cf.94f0f.0009.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Sat, 25 Jul 2026 07:02:36 +0200
X-Gm-Features: AUfX_mzn3bqZshoZw2WLdlcsolqWaa8KVcKeYl9fO3nA1zOEoW_u7FshnHZJh5c
Message-ID: <CAJWNTGyP2dj56Z-rNRJTpA-7ecnnx9OHMw1UeQck_e1g9hbh_w@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Use generic_file_read_iter() in hugetlbfs
To: syzbot ci <syzbot+ci6b41919c52660b48@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sat, Jul 25, 2026 at 1:35=E2=80=AFAM syzbot ci
<syzbot+ci6b41919c52660b48@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] Use generic_file_read_iter() in hugetlbfs
> https://lore.kernel.org/all/20260723143034.175661-1-willy@infradead.org
> * [PATCH v4 01/14] memory-failure: Fix hardware poison check in unpoison_=
memory() again
> * [PATCH v4 02/14] memory-failure: Test the page is hwpoison before takin=
g the mutex
> * [PATCH v4 03/14] mm: Rename folio_contain_hwpoison_page() to folio_has_=
hwpoison_page()
> * [PATCH v4 04/14] hugetlb: Mark some function arguments as const
> * [PATCH v4 05/14] guest_memfd: Use folio_has_hwpoisoned_page()
> * [PATCH v4 06/14] memory-failure: Remove raw_hwp_list_head()
> * [PATCH v4 07/14] hugetlb: Use the has_hwpoisoned flag
> * [PATCH v4 08/14] mm: Remove locking mf_mutex in is_raw_hwpoison_page_in=
_hugepage()
> * [PATCH v4 09/14] mm: Check individual hugetlb pages for poison
> * [PATCH v4 10/14] filemap: Add hwpoison handling to filemap_read()
> * [PATCH v4 11/14] filemap: Remove checks in mapping_set_folio_order_rang=
e()
> * [PATCH v4 12/14] hugetlb: Set mapping folio order
> * [PATCH v4 13/14] filemap: Add support for authoritative mappings
> * [PATCH v4 14/14] hugetlb: replace hugetlbfs_read_iter() with generic_fi=
le_read_iter()
>
> and found the following issues:
> * WARNING in bio_add_page
> * general protection fault in create_empty_buffers
>
> Full report is available here:
> https://ci.syzbot.org/series/4b3a4f52-06f4-4a41-872f-dde0771be8ef
>
> ***
>
> WARNING in bio_add_page
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      1590cf0329716306e948a8fc29f1d3ee87d3989f
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/bb071828-9749-428c-a78c-fc39b0b5c=
af2/config
> syz repro: https://ci.syzbot.org/findings/38d53450-b153-4f47-8474-be25079=
1ea91/syz_repro
>
> ------------[ cut here ]------------
> len =3D=3D 0
> WARNING: block/bio.c:1052 at bio_add_page+0x516/0x700 block/bio.c:1052, C=
PU#0: udevd/5630
> Modules linked in:
> CPU: 0 UID: 0 PID: 5630 Comm: udevd Not tainted syzkaller #0 PREEMPT(full=
)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:bio_add_page+0x516/0x700 block/bio.c:1052
> Code: 31 ed 44 89 e8 48 83 c4 50 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc c=
c cc cc e8 86 5e 17 fd 90 0f 0b 90 eb db e8 7b 5e 17 fd 90 <0f> 0b 90 eb d0=
 e8 70 5e 17 fd 90 0f 0b 90 e9 76 fe ff ff e8 62 5e
> RSP: 0018:ffffc9000487f0f8 EFLAGS: 00010293
> RAX: ffffffff84af2445 RBX: 0000000000000000 RCX: ffff8881108d0000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 1ffff110228761e2 R08: ffff8881143b0f7f R09: 1ffff110228761ef
> R10: dffffc0000000000 R11: ffffed10228761f0 R12: ffff8881143b0f14
> R13: 0000000000000000 R14: dffffc0000000000 R15: 0000000000000000
> FS:  00007faeac7ccc80(0000) GS:ffff88818d945000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000295e815ae000 CR3: 0000000114e0e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  bio_add_folio+0x64/0x90 block/bio.c:1107
>  do_mpage_readpage+0xd8c/0x1b40 fs/mpage.c:294
>  mpage_readahead+0x3e7/0x800 fs/mpage.c:370
>  read_pages+0x193/0x5a0 mm/readahead.c:174
>  page_cache_ra_unbounded+0x679/0x8f0 mm/readahead.c:315
>  do_page_cache_ra mm/readahead.c:348 [inline]
>  force_page_cache_ra+0x26c/0x2e0 mm/readahead.c:378
>  filemap_get_pages+0x4d9/0x1ef0 mm/filemap.c:2708
>  filemap_read+0x422/0x1630 mm/filemap.c:2841
>  blkdev_read_iter+0x2f1/0x420 block/fops.c:830
>  new_sync_read fs/read_write.c:493 [inline]
>  vfs_read+0x595/0xa80 fs/read_write.c:574
>  ksys_read+0x150/0x270 fs/read_write.c:716
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7faeac316b6a
> Code: 00 3d 00 00 41 00 75 0d 50 48 8d 3d 2d 08 0a 00 e8 ea 7d 01 00 31 c=
0 e9 07 ff ff ff 64 8b 04 25 18 00 00 00 85 c0 75 1b 0f 05 <48> 3d 00 f0 ff=
 ff 76 6c 48 8b 15 8f a2 0d 00 f7 d8 64 89 02 48 83
> RSP: 002b:00007ffd8d811da8 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007faeac316b6a
> RDX: 0000000000000400 RSI: 0000557e6b670e18 RDI: 0000000000000009
> RBP: 0000000000000400 R08: 0000557e6b670df0 R09: 0000000000000008
> R10: 0000000000000051 R11: 0000000000000246 R12: 0000557e6b670df0
> R13: 0000557e6b670e08 R14: 0000557e6b66e128 R15: 0000557e6b66e0d0
>  </TASK>
>
>
> ***
>
> general protection fault in create_empty_buffers
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      1590cf0329716306e948a8fc29f1d3ee87d3989f
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/bb071828-9749-428c-a78c-fc39b0b5c=
af2/config
> syz repro: https://ci.syzbot.org/findings/2406d176-ea76-40a8-b6bc-41d3e63=
26388/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 5932 Comm: udevd Not tainted syzkaller #0 PREEMPT(full=
)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:create_empty_buffers+0x48/0x520 fs/buffer.c:1672
> Code: 00 00 00 00 fc ff df e8 96 dc 69 ff 48 89 df 4c 89 e6 ba 40 8c 40 0=
0 e8 e6 bc ff ff 49 89 c4 48 89 04 24 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00=
 74 08 4c 89 e7 e8 09 bc d7 ff 4d 09 3c 24 49 83 c4
> RSP: 0018:ffffc900034bf570 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffea0005ceb100 RCX: 0000000000000046
> RDX: 0000000000000002 RSI: ffffffff8e4b7f70 RDI: ffff888172cdbb80
> RBP: ffffc900034bf6f0 R08: ffffffff825c6656 R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff8eb5a120 R12: 0000000000000000
> R13: 1ffffd4000b9d620 R14: dffffc0000000000 R15: 0000000000000000
> FS:  00007fd3c0fc7c80(0000) GS:ffff8882a8f45000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005567a5ebae48 CR3: 000000017395c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  block_read_full_folio+0x116/0x810 fs/buffer.c:2381
>  filemap_read_folio+0x12c/0x3a0 mm/filemap.c:2512
>  filemap_update_page mm/filemap.c:2599 [inline]
>  filemap_get_pages+0x1742/0x1ef0 mm/filemap.c:2731
>  filemap_read+0x422/0x1630 mm/filemap.c:2841
>  blkdev_read_iter+0x2f1/0x420 block/fops.c:830
>  new_sync_read fs/read_write.c:493 [inline]
>  vfs_read+0x595/0xa80 fs/read_write.c:574
>  ksys_read+0x150/0x270 fs/read_write.c:716
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd3c0b16b6a
> Code: 00 3d 00 00 41 00 75 0d 50 48 8d 3d 2d 08 0a 00 e8 ea 7d 01 00 31 c=
0 e9 07 ff ff ff 64 8b 04 25 18 00 00 00 85 c0 75 1b 0f 05 <48> 3d 00 f0 ff=
 ff 76 6c 48 8b 15 8f a2 0d 00 f7 d8 64 89 02 48 83
> RSP: 002b:00007ffcab174708 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fd3c0b16b6a
> RDX: 0000000000000400 RSI: 000055c883b6c638 RDI: 0000000000000009
> RBP: 0000000000000400 R08: 000055c883b6c610 R09: 0000000000000008
> R10: 0000000000000051 R11: 0000000000000246 R12: 000055c883b6c610
> R13: 000055c883b6c628 R14: 000055c883b60b48 R15: 000055c883b60af0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:create_empty_buffers+0x48/0x520 fs/buffer.c:1672
> Code: 00 00 00 00 fc ff df e8 96 dc 69 ff 48 89 df 4c 89 e6 ba 40 8c 40 0=
0 e8 e6 bc ff ff 49 89 c4 48 89 04 24 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00=
 74 08 4c 89 e7 e8 09 bc d7 ff 4d 09 3c 24 49 83 c4
> RSP: 0018:ffffc900034bf570 EFLAGS: 00010246
>
> RAX: 0000000000000000 RBX: ffffea0005ceb100 RCX: 0000000000000046
> RDX: 0000000000000002 RSI: ffffffff8e4b7f70 RDI: ffff888172cdbb80
> RBP: ffffc900034bf6f0 R08: ffffffff825c6656 R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff8eb5a120 R12: 0000000000000000
> R13: 1ffffd4000b9d620 R14: dffffc0000000000 R15: 0000000000000000
> FS:  00007fd3c0fc7c80(0000) GS:ffff8882a8f45000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30763fff CR3: 000000017395c000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 6 bytes skipped:
>    0:   df e8                   fucomip %st(0),%st
>    2:   96                      xchg   %eax,%esi
>    3:   dc 69 ff                fsubrl -0x1(%rcx)
>    6:   48 89 df                mov    %rbx,%rdi
>    9:   4c 89 e6                mov    %r12,%rsi
>    c:   ba 40 8c 40 00          mov    $0x408c40,%edx
>   11:   e8 e6 bc ff ff          call   0xffffbcfc
>   16:   49 89 c4                mov    %rax,%r12
>   19:   48 89 04 24             mov    %rax,(%rsp)
>   1d:   4c 89 e0                mov    %r12,%rax
>   20:   48 c1 e8 03             shr    $0x3,%rax
> * 24:   42 80 3c 30 00          cmpb   $0x0,(%rax,%r14,1) <-- trapping in=
struction
>   29:   74 08                   je     0x33
>   2b:   4c 89 e7                mov    %r12,%rdi
>   2e:   e8 09 bc d7 ff          call   0xffd7bc3c
>   33:   4d 09 3c 24             or     %r15,(%r12)
>   37:   49                      rex.WB
>   38:   83                      .byte 0x83
>   39:   c4                      .byte 0xc4
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
e.cz jane.chu@oracle.com jiaqiyan@google.com linmiaohe@huawei.com linux-fsd=
evel@vger.kernel.org linux-mm@kvack.org muchun.song@linux.dev nao.horiguchi=
@gmail.com naoya.horiguchi@nec.com osalvador@suse.de stable@vger.kernel.org=
 usama.arif@linux.dev willy@infradead.org]
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
-upstream-moderation/6a63f6b1.073198cf.94f0f.0009.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
