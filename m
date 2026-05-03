Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AD4AC299929
	for <syzbot@lists.linux.dev>; Sun,  3 May 2026 07:02:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777791734; cv=pass; b=TWTzSgtlmU8dcF0lv1sWAHA+RAP+1kW1G6aIDwwgdbcPe0+HHQuh3kfknc+ouKaeIefNXBWAIpoIxRdT+lmBMnXo+87QRGRBo87mkrhekUa2pIAj3RUFHAEm3qF5ho5SoiR12ssQNhvf1i04kS4hjxbSSLmbD4j5oic4lutSUrI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777791734; c=relaxed/simple;
	bh=eRdmcfinAXrdkrgMkHySV28d8UfSocpc+W3uSM6wAuk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Ad9WMirSFMhoic7VusMOpFvwmGYHiOAyrhUITZLELxLgV5jl4rSfQgETeUTh9oO+BIeoxgzmigspWOqUD1kDtbP7Gf5DCsEktHg9fFPkXrxk/ZNOsNKbrmyvJKGuS28nilPn5Rwwph+NsH/sSUp6t1xAeF2Nrii/eqQoiZr0XDI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BQyw1XDS; arc=pass smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BQyw1XDS"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-48a7fe4f40bso31626095e9.0
        for <syzbot@lists.linux.dev>; Sun, 03 May 2026 00:02:12 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777791731; cv=none;
        d=google.com; s=arc-20240605;
        b=Z+6hbzLZCEWOfTzuAYkycPDn5HyVkpeW0jaYFAck97SPcxEYGmJhRmS/mEEMe0ItKb
         qtVNGNo2NhglZqswmZ7TRIQKSB/g2JQ/b08bj1hG5LFzB2+bN/9LLYcToBrPpJ1czaNd
         kHppeYUSgRdg0rvRtQLQSUx3PO4fEpnkkMtD/0m1DsPxp8wh4bxlbV5nNx2FXlmthbE3
         J7/bOpajh0mVce/Qn/28QI0yzitn8Wd/XWafKagRJyyjcB+UMwXWiwMXI6IgDGjsgGHr
         aM6g+6Vl8Xcsy9ajAvQvVqpQj9LB3wZSaV0hTR3wcwXMARFQbPKvLq4PJqNWh6U8tC/b
         1HhQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hrOVtqIOxuv07z0dMZVzySEMmOK1HYopZAsCHwMUMYA=;
        fh=Jj1QOQjgSBvFKoKQHiaVSQ/w+2OUjBPWKZZT5ewS/sM=;
        b=XJDIZR1yzImJZnrCC2nR+oT8OuYM5WZ6c6ig503cTV5w41HF5i7NvgmgHfjIaMAPXn
         SbnFl3j98I+VT/yarwZWhRmRPGX83eLAKSP+bF3GT8QI5C3OAHz1QfQWxiqml0vOnU2m
         At3fxXdO12bEUcBrmrSJ1/a4vqa3yX1fXPbhES+Jr0SdAY1ijHkatUlEnh+Tn0R29dxv
         UTRy+av5MgMhDK/TYxVSxIgfYsW6ZGHBCKU0yPA/r0A20e8qG419GrVCH1f6xYONln7V
         B20Lwa6e3pBgbNN6dxejvdPZxwSLT/oXGkLDjtRSHgoZ9rS2AQbzOAR13ETScCtyqRrM
         fOzQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777791731; x=1778396531; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hrOVtqIOxuv07z0dMZVzySEMmOK1HYopZAsCHwMUMYA=;
        b=BQyw1XDSvF40SEZclsZUI2gpNT0kV6/apGo6lYcy2yeWbfPaMOIi6O0KDZPilEa6sZ
         tXHqEt2sTBdonk6CJoDL2v9ZaIR5N6B1l7D31YMa9ZnvY0elbba/si1HU+SxyGb6co2l
         fT1fwMsUKaSaJYIUiAoU4A33Jec7Doq9OsE6MWPufoURZzVN5plnHgfdFbpS/mbtVRj5
         Jdd8pyr1yJ+JI2+AAilSbQbXmvJDB+EyZwqjSKoRPO2uMVceysy86k+5qnqYfoMFgg+I
         L74r8+a5eHqnsGHZYitt/WBpMnIba1NqBVrMbvFE7/KPgxm55FAlRn4aqKqfiLTB9XGf
         Nuvw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777791731; x=1778396531;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hrOVtqIOxuv07z0dMZVzySEMmOK1HYopZAsCHwMUMYA=;
        b=fxrjNDVMSoOvkXue0wubAnmW3OIVjCxMjv10SYchhrLV1SGWDrzqspBVIjPB1VfTov
         5OFuTiYi4FPI9cLP4NCuNJXmoFEwg8ltW54izsnD6Eqm7M7oItPqD8AdTWtwrAs+a69M
         FlRE6/bDlIY5q/YzZgZ+I4IgqvVkXOiINAeQbUExonmIOsK/tDGaA+dU+M3apSosYulk
         XWmQJ8JFJc27o9ShhTzC67/RPPn/V14ZO+SBNveSbVYF/kFx/2rp1lzys3KJt6HD53+1
         jitwKHsBI4VVogMqetamUg7L5AUq167hvJy2DJxwKcPRlpq8AzBgOjLw0nDP5jzcI4vA
         /8cw==
X-Forwarded-Encrypted: i=1; AFNElJ9UHCZq7PTMJKpby3kWLMzUqemjXJR2vVa18KjmPHwYUZ7ql1luPsKgl1Qb7E83vxK+IqmAMa0=@lists.linux.dev
X-Gm-Message-State: AOJu0YxORhf2sUi4LI/a01Tx8vTlMf27OHQY5vow3ozqFrmuTAFMn6zt
	OMXjSKLWAEjOmhXLhj1kGbxmjC0/w6UvgXP5HE78Fsqn88TNVSwX7flehqycRaDNnWNM8EWXw/p
	EbP8G42bC/jxxd3GyqSlkeCE0EBZtrVlue1UEDtda
X-Gm-Gg: AeBDiesBLE/lDuZUZwjpjUCebbm5Nb1kyr3yEJ/IYwlvYJxgx1Uyp+4CImW27WjnYWv
	y9Rb6WcXvN/SaMAt2a+sebjPvspz0iZ2+SQI4CTYLt6RMJ7Omz4+dswqFj/rRxPKMcACmHfEvE0
	kjJv7WYVNrT/iGMOamW382bkaJ7u5GkdgsDS2YGs0Q3367/uUnc0Z0aakxNJWlVgw2WVO8pEyu9
	ALRdfuFAeo8pSEnrk59sY7m+A+117rz37Zrswh0A7U5jDliDAzVTbH9vNoLrYflspAv0tJslwcO
	xpG9+yjDFcsLiJS/nWSRY4ogkcxujIIszq8Wzkqd3qOzdgVQG8n98hTVXBtaO3JN74r+t9uTRQC
	PC+ZgkQzXscGikEtB6/s=
X-Received: by 2002:a05:600c:a10c:b0:48a:56de:d62a with SMTP id
 5b1f17b1804b1-48a9863a03dmr62686185e9.11.1777791730634; Sun, 03 May 2026
 00:02:10 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69f49178.050a0220.3cbe47.000b.GAE@google.com>
In-Reply-To: <69f49178.050a0220.3cbe47.000b.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Sun, 3 May 2026 09:01:59 +0200
X-Gm-Features: AVHnY4LWAYRc5tPDjrSDpFyUKrbu03Z86RioLbVlrbS9-Bl9bO_KmG3UgWtqLDo
Message-ID: <CAJWNTGy7XvXiO5CZa3ix+FW-y7s-OH3HwU1jzu2FQrQ-Zixu9A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: Support selecting doing direct COW for
 anonymous pmd entry
To: syzbot ci <syzbot+ci7e654742b9b7a582@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, May 1, 2026 at 1:41=E2=80=AFPM syzbot ci
<syzbot+ci7e654742b9b7a582@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm: Support selecting doing direct COW for anonymous pmd entry
> https://lore.kernel.org/all/20260501-thp_cow-v1-0-005377483738@tencent.co=
m
> * [PATCH 1/5] mm: add basic madvise helpers and branch for THP setup
> * [PATCH 2/5] mm: add pmd level THP COW parameter in sysfs
> * [PATCH 3/5] mm: add pmd level THP COW judgement helpers
> * [PATCH 4/5] mm: enable map_anon_folio_pmd_nopf to handle unshare
> * [PATCH 5/5] mm: support choosing to do THP COW for anonymous pmd entry.
>
> and found the following issue:
> general protection fault in __page_table_check_pmds_set
>
> Full report is available here:
> https://ci.syzbot.org/series/37e78e03-c08b-4de1-9b07-a21c64f4f462
>
> ***
>
> general protection fault in __page_table_check_pmds_set
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      41cd9e3d23b8fd9e6c3c0311e9cb0304442c6141
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/fcdd679f-29e8-43db-8792-d4fd97c62=
d91/config
> syz repro: https://ci.syzbot.org/findings/87820d58-5d91-4c2e-b80b-5a75006=
e230d/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 UID: 0 PID: 5807 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__page_table_check_pmds_set+0x1d4/0x340 mm/page_table_check.c:2=
40
> Code: 00 00 4c 89 6c 24 08 4c 89 3c 24 4a 8d 2c fd f8 ff ff ff 31 db 49 b=
f 00 00 00 00 00 fc ff df 49 8d 3c 1e 48 89 f8 48 c1 e8 03 <42> 80 3c 38 00=
 74 05 e8 00 29 f4 ff 4d 8b 24 1e 45 89 e5 41 81 e5
> RSP: 0018:ffffc90003c46ee0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff8881102a1d80 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000001 R09: 1ffff110242081d8
> R10: dffffc0000000000 R11: ffffed10242081d9 R12: dffffc0000000000
> R13: 0000000025c008e7 R14: 0000000000000000 R15: dffffc0000000000
> FS:  00007fbef78216c0(0000) GS:ffff88818dc91000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b32f63fff CR3: 000000002350a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  page_table_check_pmds_set include/linux/page_table_check.h:92 [inline]
>  set_pmd_at arch/x86/include/asm/pgtable.h:1209 [inline]
>  map_anon_folio_pmd_nopf+0x452/0x480 mm/huge_memory.c:1449
>  collapse_huge_page mm/khugepaged.c:1411 [inline]
>  mthp_collapse mm/khugepaged.c:1530 [inline]
>  collapse_scan_pmd mm/khugepaged.c:1773 [inline]
>  collapse_single_pmd+0x4691/0x5540 mm/khugepaged.c:2786
>  madvise_collapse+0x300/0x7a0 mm/khugepaged.c:3218
>  madvise_vma_behavior+0x11b0/0x4210 mm/madvise.c:1383
>  madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1738
>  madvise_do_behavior+0x386/0x540 mm/madvise.c:1954
>  do_madvise+0x1fa/0x2e0 mm/madvise.c:2047
>  __do_sys_madvise mm/madvise.c:2056 [inline]
>  __se_sys_madvise mm/madvise.c:2054 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2054
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fbef699cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fbef7821028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fbef6c15fa0 RCX: 00007fbef699cdd9
> RDX: 0000000000000019 RSI: 0000000000400000 RDI: 0000200000000000
> RBP: 00007fbef6a32d69 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fbef6c16038 R14: 00007fbef6c15fa0 R15: 00007ffdddd640f8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__page_table_check_pmds_set+0x1d4/0x340 mm/page_table_check.c:2=
40
> Code: 00 00 4c 89 6c 24 08 4c 89 3c 24 4a 8d 2c fd f8 ff ff ff 31 db 49 b=
f 00 00 00 00 00 fc ff df 49 8d 3c 1e 48 89 f8 48 c1 e8 03 <42> 80 3c 38 00=
 74 05 e8 00 29 f4 ff 4d 8b 24 1e 45 89 e5 41 81 e5
> RSP: 0018:ffffc90003c46ee0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff8881102a1d80 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000001 R09: 1ffff110242081d8
> R10: dffffc0000000000 R11: ffffed10242081d9 R12: dffffc0000000000
> R13: 0000000025c008e7 R14: 0000000000000000 R15: dffffc0000000000
> FS:  00007fbef78216c0(0000) GS:ffff88818dc91000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b32f63fff CR3: 000000002350a000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   00 00                   add    %al,(%rax)
>    2:   4c 89 6c 24 08          mov    %r13,0x8(%rsp)
>    7:   4c 89 3c 24             mov    %r15,(%rsp)
>    b:   4a 8d 2c fd f8 ff ff    lea    -0x8(,%r15,8),%rbp
>   12:   ff
>   13:   31 db                   xor    %ebx,%ebx
>   15:   49 bf 00 00 00 00 00    movabs $0xdffffc0000000000,%r15
>   1c:   fc ff df
>   1f:   49 8d 3c 1e             lea    (%r14,%rbx,1),%rdi
>   23:   48 89 f8                mov    %rdi,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 38 00          cmpb   $0x0,(%rax,%r15,1) <-- trapping in=
struction
>   2f:   74 05                   je     0x36
>   31:   e8 00 29 f4 ff          call   0xfff42936
>   36:   4d 8b 24 1e             mov    (%r14,%rbx,1),%r12
>   3a:   45 89 e5                mov    %r12d,%r13d
>   3d:   41                      rex.B
>   3e:   81                      .byte 0x81
>   3f:   e5                      .byte 0xe5
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
> [akpm@linux-foundation.org arnd@arndb.de baohua@kernel.org baolin.wang@li=
nux.alibaba.com corbet@lwn.net david@kernel.org dev.jain@arm.com jannh@goog=
le.com kasong@tencent.com lance.yang@linux.dev liam@infradead.org linux-arc=
h@vger.kernel.org linux-doc@vger.kernel.org linux-kernel@vger.kernel.org li=
nux-mm@kvack.org ljs@kernel.org lukabai@tencent.com lukafocus@icloud.com mh=
ocko@suse.com npache@redhat.com rppt@kernel.org ryan.roberts@arm.com skhan@=
linuxfoundation.org surenb@google.com vbabka@kernel.org ziy@nvidia.com]
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
-upstream-moderation/69f49178.050a0220.3cbe47.000b.GAE%40google.com.
