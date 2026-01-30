Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0CDA32B9A5
	for <syzbot@lists.linux.dev>; Fri, 30 Jan 2026 08:12:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769760774; cv=pass; b=FJt+DoBVAwK9NLdWQdMAspxJyPHUpnhKE7DsYkEsjABahoWP6TSpLPXi3qZ042PWSODtXiL8qMqPgp+N+HybI1vkFlNzd2hb/SvUdgl5tGzAYa3lnxegh4d/tbOo6rgYQkM70Mt40HyWXrtxfHgRqF2/lSghxir323c3rNcs9/k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769760774; c=relaxed/simple;
	bh=NrLGRrRKcWqKvMhh9eqF/GxSKf5H577nPd2vYLGo4ro=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uCQEVzEeVJJHqQK2QO1KHsk//DBu7MC7b9TVjVwEePVpskSVaKoAbWTfp8SRq72q4Oz2wUoGRoAKkutwr9+pTjE2RyizdOqFU5+oYhnHkEMOFbaMaosAHeIM20tl8DuXkXZS4MRi5LC2u07gTMi6u389crQVpvdtHX2S19ALWcg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Az2RNSPn; arc=pass smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Az2RNSPn"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-4094b31a037so769678fac.1
        for <syzbot@lists.linux.dev>; Fri, 30 Jan 2026 00:12:52 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1769760772; cv=none;
        d=google.com; s=arc-20240605;
        b=NUra2IxtdGukKrdzTqEwxjUuTjotiBjZeewBdGbyAn1cAbdk/EMKAWndh56+UcpmdI
         dl36DT9IgxrSg2YJHYsPkapq+hzgI1hwDjhlk7XDOn1qGzArOfhLUI/xUFJ7WJL05+35
         F8x2hY+AdCRA5BoMsnPvBfxBBxOtyWRS3QrHyRAKXE6d+UWbhXwjlOVT3TyHy5aQUYyx
         cc2mEH0E1WFxbXKnJZvQbB9wSlSlZ1BeZwdFrqNk2TRp2CMXiUqaAiSVUEybIJf9KFAF
         u0Fj3xif8PNLmj++YKOM7NI4ByeZVSoBJuZS7eJJ1s+i1vMUpXOmUe9yshnSxwCyTr5o
         /Ubw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hBuxtOO0P0xwEpPEqVzpuohIEOGWnSBcsEL8Gcs7ADI=;
        fh=WAI+0dlk1klzTKPKcMtEpuytDClZYh0hddpMR5N5OGs=;
        b=itTsYTsPBG4iT2P8SHWY+65OVFr222raTpd54ruui/4KzA6WG/M4xwQZUSMvXsxO9R
         axnG/YKorwzsOpclD8jtyYQXjH1sg3HQGQPP6vsYJIL4xGckaDiwmUSPMJ+mpfQlaHHo
         clYMCjhBmEwzaqj4/IqKZvjyAifAQPJfC0KlOkxQLIWfTr5HAIG0WFfWoBvLiNtcNPzO
         GY+7sL8PZ0/t13nMc0X9gESIuLdUvKBKJrxxfAjLgGwdz1UOT4QRr2Vl1WDEm9jIz2pv
         pUoY7J62bQpreu6O+CzDlJWO9BU8DeurSnvJxC5BG1rR9rrEo29fb2tf47bdy4yaBqhE
         n46w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1769760772; x=1770365572; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hBuxtOO0P0xwEpPEqVzpuohIEOGWnSBcsEL8Gcs7ADI=;
        b=Az2RNSPnbrd1jbc4nZQfoPgOSncr/DPx9dvAWHg1v0l9EMGRy2hZO3aje20uOOv+QY
         Q79qL5CXzlpTZ02IHNW8O/5ZVQoVHCRZbvUy3scSg1toFjxhw/kWr2LtC0IHK7t/oka4
         UqCYDYdlc8F70rFVo2VS2h1obkvmULUAq/NO7djSbN35Qrvv3/qyEuxEV7Z9iE5PLxzz
         QQ7rUteWEpcG4xkV9j6t0spzys9ESa0v0dyXCrvYNM44A/0R7fDqyDTlpBslBRqLDEnk
         IweS3J5YJVpAQIz5ywD5zm1RKgaS9w4UvD1diMdbPtlsvffr78iaCDs+bhtEnVlf4Ik7
         ovGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769760772; x=1770365572;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hBuxtOO0P0xwEpPEqVzpuohIEOGWnSBcsEL8Gcs7ADI=;
        b=NJtjo5LP1nHwMdZZun+FC3/ahjj3J2CrLlP6E4Axjua9tesT/GONiFZgKVgE45CBFq
         ropsiO8aSfxhN5EGbrLEJ+UixP9aseeJ/8VKjzYDYJRGhYMSVU7mhx0S+4McMTFrxeML
         dFeIkp3mxXW01WqOMEUZByewoc4mWD+BF9vDOEFpHoBBb3l/ejkWURdLuXyXPnoZ5REA
         mJQ+8IPFGZ6rpwLR6sklM0UgvA9aSMwjD9Ix/yIG1k2vO62Jg8voA/xsYVgjI7XX1oZ/
         MtQSli9C3Tp/RFaJBDI0zkBjplt4EQRrcNck2jEVyh2LXriIbag9prOQJMiR1/KBqr2K
         gt6A==
X-Forwarded-Encrypted: i=1; AJvYcCUKN6EzTHAXJ/PIUO0MfbsFOru/CiPbqJBorGOQKbKdk5ULMEsDrIL7qFmLbh9rxCUFZjK0XVo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyE2bI/yFSlQEqu41GDiF4K3k5rmRIUJ7LWjxApyI6s2RlMhHRi
	OfdcI5tNqXm8N4n/ddA/DmEuFh60gj+eG6BsVcUK80JWUupAzZnqg2Rbna56BZ22d2xNERrhAPy
	ND9HeagAvg4ShS0jwNHP1AzbVtBmVc+IMb6uvmyZDiQVm+MoqysW7cUIi
X-Gm-Gg: AZuq6aKD0TqOZXlKbhsQAZ6Q/usrwWBXKS6lfiP3miwbfvnzLnZ1VnGZQzbqAOV1Ctn
	jSBCtp/rnunc/za6ulXPt3LctQUo83va8eYnT59rIipdGCljmfHMtmrsTZROhkzW/+npoAshmd1
	jlfZYPm/XzA4b+EQCn4PfQ8vZlhwfdkgSp84XCTZLhKs8gbDGupUKUKrrhMxYCBmLF3ISzOipM8
	9xT+m0FbF9ZhTFPyHrjORYR9FHHgQ9SoRnTRp2ei+W68upTROPVolSLWzSv7oLXCdSTnG/n7NTm
	kB74Lgy2QanlxkIdObzl0ZwXWG67JWCeZRFy472uvOWatPZGJwceIvwnjw==
X-Received: by 2002:a05:6820:134f:b0:663:7ad:6ae5 with SMTP id
 006d021491bc7-6630f04f977mr890616eaf.20.1769760771471; Fri, 30 Jan 2026
 00:12:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <697c672c.a70a0220.9914.002d.GAE@google.com>
In-Reply-To: <697c672c.a70a0220.9914.002d.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 30 Jan 2026 09:12:39 +0100
X-Gm-Features: AZwV_Qiutla3MOObpXE5OUGSYnE_O2QjuSfU_gTbM9OeNcuNYi0AkK4uEvkJDpA
Message-ID: <CANp29Y4kOV96AbXb-w+tCuMfs_xbOnLSLyV_ZhtDqKeHZnvjVg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Separate compound page from folio
To: syzbot ci <syzbot+ci9837ad5f77b5a250@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Jan 30, 2026 at 9:09=E2=80=AFAM syzbot ci
<syzbot+ci9837ad5f77b5a250@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Separate compound page from folio
> https://lore.kernel.org/all/20260130034818.472804-1-ziy@nvidia.com
> * [RFC PATCH 1/5] io_uring: allocate folio in io_mem_alloc_compound() and=
 function rename
> * [RFC PATCH 2/5] mm/huge_memory: use page_rmappable_folio() to convert a=
fter-split folios
> * [RFC PATCH 3/5] mm/hugetlb: set large_rmappable on hugetlb and avoid de=
ferred_list handling
> * [RFC PATCH 4/5] mm: only use struct page in compound_nr() and compound_=
order()
> * [RFC PATCH 5/5] mm: code separation for compound page and folio
>
> and found the following issue:
> WARNING in __folio_large_mapcount_sanity_checks
>
> Full report is available here:
> https://ci.syzbot.org/series/f64f0297-d388-4cfa-b3be-f05819d0ce34
>
> ***
>
> WARNING in __folio_large_mapcount_sanity_checks
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      0241748f8b68fc2bf637f4901b9d7ca660d177ca
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/76dc5ea6-0ff5-410b-8b1f-72e5607a7=
04e/config
> C repro:   https://ci.syzbot.org/findings/a308f1d6-69e2-4ebc-80a9-b51d9dc=
02851/c_repro
> syz repro: https://ci.syzbot.org/findings/a308f1d6-69e2-4ebc-80a9-b51d9dc=
02851/syz_repro
>
> ------------[ cut here ]------------
> diff > folio_large_nr_pages(folio)
> WARNING: ./include/linux/rmap.h:148 at __folio_large_mapcount_sanity_chec=
ks+0x499/0x6b0 include/linux/rmap.h:148, CPU#1: syz.0.17/5988
> Modules linked in:
> CPU: 1 UID: 0 PID: 5988 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__folio_large_mapcount_sanity_checks+0x499/0x6b0 include/linux/=
rmap.h:148
> Code: 5f 5d e9 4a 4e 64 09 cc e8 84 d8 aa ff 90 0f 0b 90 e9 82 fc ff ff e=
8 76 d8 aa ff 90 0f 0b 90 e9 8f fc ff ff e8 68 d8 aa ff 90 <0f> 0b 90 e9 b8=
 fc ff ff e8 5a d8 aa ff 90 0f 0b 90 e9 f2 fc ff ff
> RSP: 0018:ffffc900040e72f8 EFLAGS: 00010293
> RAX: ffffffff8217c0f8 RBX: ffffea0006ef5c00 RCX: ffff888105fdba80
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffffea0006ef5c07 R09: 1ffffd4000ddeb80
> R10: dffffc0000000000 R11: fffff94000ddeb81 R12: 0000000000000001
> R13: 0000000000000000 R14: 1ffffd4000ddeb8f R15: ffffea0006ef5c78
> FS:  00005555867b3500(0000) GS:ffff8882a9923000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000000c0 CR3: 0000000103ab0000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  folio_add_return_large_mapcount include/linux/rmap.h:184 [inline]
>  __folio_add_rmap mm/rmap.c:1377 [inline]
>  __folio_add_file_rmap mm/rmap.c:1696 [inline]
>  folio_add_file_rmap_ptes+0x4c2/0xe60 mm/rmap.c:1722
>  insert_page_into_pte_locked+0x5ab/0x910 mm/memory.c:2378
>  insert_page+0x186/0x2d0 mm/memory.c:2398
>  packet_mmap+0x360/0x530 net/packet/af_packet.c:4622
>  vfs_mmap include/linux/fs.h:2053 [inline]
>  mmap_file mm/internal.h:167 [inline]
>  __mmap_new_file_vma mm/vma.c:2468 [inline]
>  __mmap_new_vma mm/vma.c:2532 [inline]
>  __mmap_region mm/vma.c:2759 [inline]
>  mmap_region+0x18fe/0x2240 mm/vma.c:2837
>  do_mmap+0xc39/0x10c0 mm/mmap.c:559
>  vm_mmap_pgoff+0x2c9/0x4f0 mm/util.c:581
>  ksys_mmap_pgoff+0x51e/0x760 mm/mmap.c:605
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5d7399acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe9f3eea78 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
> RAX: ffffffffffffffda RBX: 00007f5d73c15fa0 RCX: 00007f5d7399acb9
> RDX: 0000000000000002 RSI: 0000000000030000 RDI: 0000200000000000
> RBP: 00007f5d73a08bf7 R08: 0000000000000003 R09: 0000000000000000
> R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5d73c15fac R14: 00007f5d73c15fa0 R15: 00007f5d73c15fa0
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
> [akpm@linux-foundation.org apopple@nvidia.com axboe@kernel.dk balbirs@nvi=
dia.com baohua@kernel.org baolin.wang@linux.alibaba.com david@kernel.org de=
v.jain@arm.com hannes@cmpxchg.org io-uring@vger.kernel.org jackmanb@google.=
com jgg@nvidia.com lance.yang@linux.dev liam.howlett@oracle.com linux-kerne=
l@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse=
.com muchun.song@linux.dev npache@redhat.com osalvador@suse.de rppt@kernel.=
org ryan.roberts@arm.com surenb@google.com vbabka@suse.cz willy@infradead.o=
rg ziy@nvidia.com]
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
-upstream-moderation/697c672c.a70a0220.9914.002d.GAE%40google.com.
