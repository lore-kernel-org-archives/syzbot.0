Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759F515B998
	for <syzbot@lists.linux.dev>; Sat, 18 Jul 2026 06:46:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784357171; cv=pass; b=pS3AaQi/xUdY4Yd7dJyng6OuPpdX6/swZmIc88v1D53i/k0pLtueczBOuaX4Wec/sl0xa3nsCutmgM5Yg8voH47zCnC6f7ML+06qH+YwfARJF5RbRJE7bGI7EwErtfWupSbmQUnvAyBVStUVaXHIcorPPaZouS8Q76yBG2BsKC8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784357171; c=relaxed/simple;
	bh=Vt9B4J8Cyjvt0lARnUI99Hh9Ujn6crKaq8sj8bdi9P8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GjXEqpSp+w6JIvAPr6t2fHCehuw4yvEnoRpv6sQmHrYS04XMB1UdaNVuc3IFM+kIwXz/fJAxlTSzMbZCUV/XGxH4jmJTuTWBJZ+sGDDnpLJzhDXQB6RoOVLkATsafHNREpN3YLDTZme5LvDigK8/ujmjrTPxCB5yevxS6RVpxJg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lYfvHMsE; arc=pass smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lYfvHMsE"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7e9dc546f40so1199615a34.1
        for <syzbot@lists.linux.dev>; Fri, 17 Jul 2026 23:46:09 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784357168; cv=none;
        d=google.com; s=arc-20260327;
        b=BelBuC7qbhC03ObsvhWxfaPFG6WZCCfpohcoCxvfpw/q5yB2hAYiasI7QlmoDUPxMl
         tKLsLhE3p2VJ8lEO+p2jK0AZDdbOlQHGCdtianI9nSa0YlzE95x7kWL+bv+eo/nk9md6
         gc6g1ZtkC3DvyXq/DbDioVx99V3mAr4z8leYnTcbkMonRfqcSQmckFZr8rJ4OFv8lqOh
         aquq6ie0meQhaUr8W86qbcDRef8931eaHXMxp3+NYzuvkZtbSL0hsQ24UNx+JFvQPKiQ
         ArErB0bOYjBXVo8swfcS/GPvNGt2Tem4panO9rtmmUb32sAGrOPuktrX2YWcuMzdIUgY
         lQng==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=tdBzG567VKVvK9EPVQc/jSmNG93WzUQFKw/2vARo2H4=;
        fh=tv4x3lGM+mf1PxCFx3uOdjYRmjM+47CRqU8yMjnXTdc=;
        b=MnbpAIfOktuLY9mrKp0NBypInHZEzlUyRPdLdEurTW+eCkmMVF4iSBbLgICOxYMA58
         k0DlHDZSm2vOxaBNit6M7GifCCyZf+yx0W2P13dCEDU8v8NwM0N4AS9QNmY/cmSJ2e+i
         Z2I+nbz5LYQhI100QcwkkVQsz2GYgdwFAvpTgcYBu7LDVstIHE2LF3burkUm+LcHkR4g
         Uddok49f1bvgQ8NC9z6WlGDLxCRGJ0zNj95aZSgBkbeR5mBtGr954885VBFbd7j6C8Nt
         03Sje5h1T3ajY7fOvUPW+9gi9e80d0LinT92yWnkjyvljR5rgiIwXZOEJV/juECKTlTX
         XBWQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784357168; x=1784961968; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=tdBzG567VKVvK9EPVQc/jSmNG93WzUQFKw/2vARo2H4=;
        b=lYfvHMsE0l/V104lSvgUL5SBLrxuSrT0BfHNeqh/k+g2rvf8HkGJvyeEwNmLSxedHm
         kweMxLEHpNXlIwLPO6uXqa433pyina6ybvmPw9jmA0RzQFVKU5kTs2fCIgsaICubP7x2
         zGVJ6LtFtPWmfeuRvz8AHgmpvRIfFYYeEQj9uAn7Q2aDMxK/FCsFVK9qNlYhCYNCUH5R
         vK8UZ13c0uLnqqKqACIYzfO/+qdYvrhFQc2jJNnHVVldLTzLNxFwx6K/SnD7nyrCZGTt
         aHSHMpqWiPZgDvBa69R6PRyz5QCs+GXRSQQj3K4px9uXOFJ6hi7F38OeBnkSMjThUA9i
         HGwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784357168; x=1784961968;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=tdBzG567VKVvK9EPVQc/jSmNG93WzUQFKw/2vARo2H4=;
        b=B0JUdaX1OKRl4dZFobmOxAqWxSHmioTVM33lTEyTSk3Rjhj1UCoIjifsfY00ZthUJG
         yUiCSEAJQr8/4vmpXuV+nNYugQbmeqPM4fy383CvDmSd0dAXr/hhGREzh/YyPifP0Pf/
         Y+PuDyNi9XgAdnhZcYgn7tb437tKm9CMpQEEYuQq1we7ssJAH/ajipAiN9ecdwfOEHA1
         neyYI1RA5lmPTVSCOrmdmu4daIDmdGJK0tNvQR6/QupfVv6T0/Jd3wq+oVpUhg5N0sqB
         KRNYFOertzSQfDvW5tBdjpDU+vi+U0VjUp8FgQmG6jKEU3o66SKPnijbD7tvoXxVNyCs
         hj1Q==
X-Forwarded-Encrypted: i=1; AHgh+RrWp0ncfsdj44o3kxqdvhuCHOHQyujj6wn/TXoCHkW4hW932PCBFNOnbqc5uvbSSZni+xzlq9c=@lists.linux.dev
X-Gm-Message-State: AOJu0YyQe3+fcIvLf7RJU1+ykAhldPDXLuZxdK38YmJgz/Jh0WIIhnir
	kWaAWEKGgm3GL/NYZF2yXBRwBDra0TR+B0SuV425C7iZU5WsJ0vU834L0/3qJxABSnqmC1BG3I4
	KEcohTP1Us4IyYOEPH07XGIVqtxYKnweNOSMAwdCe
X-Gm-Gg: AfdE7cmKLvSddofz99SJY6aLGZ4ct2KsyO9TZKKVYV+/i7omm7mf+wkeCbOtHikR8hr
	N87UwBlEkEp2w4vFR6cuiC1d4EpdKVlpAUXZdDqoaO6qvEhVqiQltoemqMjTFMh7upYhdUCRU4d
	3rtTgsCwXj4GOrhZIVElC8lJtkNI8DE8sDBRSesa3Oiswe9rxNAv15XHk04jT/1OphBTiCbzBmI
	hvj5YY8E8yQIP2WCGKHeJvxxj9Za0MO4Fpne+LYhQAVnSztTkCatSZOsPSt/oKWyNVpKFjOBjM0
	MJuLnYYhyFetpTTd2ca3wGFoyNEXR5gehVyhAox3eYgsVq4kS9kUszXMBmQ+V6h/I32ZTKyfxOV
	7O3Yd+Ks0f8pyrUcqAWc9nPsqtCTp0PTtylBqDqRHjg==
X-Received: by 2002:a05:6830:4c18:b0:7e9:b673:cbfd with SMTP id
 46e09a7af769-7eda6fa97c8mr2474175a34.7.1784357167735; Fri, 17 Jul 2026
 23:46:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a5aed9d.f1649fcc.2a4208.0278.GAE@google.com>
In-Reply-To: <6a5aed9d.f1649fcc.2a4208.0278.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 18 Jul 2026 08:45:56 +0200
X-Gm-Features: AUfX_mzqeP4gyyDNxCTVQcgDG9pTl8x-hb8ftYSNIfOQFefbooXPFICStJV2mfU
Message-ID: <CANp29Y45RmKcBWnDQpC4n-9LO3z734W_C2Ost7T8PGxd0jbuBg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/rmap: index MAP_PRIVATE file-backed folios
 by virt pgoff
To: syzbot ci <syzbot+ci5e34f4683bcffe49@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Jul 18, 2026 at 5:06=E2=80=AFAM syzbot ci
<syzbot+ci5e34f4683bcffe49@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm/rmap: index MAP_PRIVATE file-backed folios by virt pgoff
> https://lore.kernel.org/all/20260717-b4-scalable-cow-virt-pgoff-v1-0-cf24=
910ef094@kernel.org
> * [PATCH 01/15] mm/vma: introduce VMA virtual page offset field and add h=
elpers
> * [PATCH 02/15] mm: introduce linear_virt_page_index()
> * [PATCH 03/15] mm: abstract vma_address() and introduce vma_anon_address=
()
> * [PATCH 04/15] mm: update print_bad_page_map() to show virtual page inde=
x
> * [PATCH 05/15] mm: introduce and use vma_filebacked_address()
> * [PATCH 06/15] mm: propagate VMA virtual page offset on map, remap, spli=
t + merge
> * [PATCH 07/15] mm/rmap: track whether the page VMA mapped walk is anonym=
ous
> * [PATCH 08/15] mm: introduce and use linear_folio_page_index()
> * [PATCH 09/15] mm/rmap: use virt pgoff for MAP_PRIVATE file-backed anon =
folios
> * [PATCH 10/15] tools/testing/vma: expand VMA merge tests to assert virt =
pgoff
> * [PATCH 11/15] tools/testing/selftests/mm: test virtual page offset merg=
e behaviour
> * [PATCH 12/15] mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped an=
onymous
> * [PATCH 13/15] mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly =
anonymous
> * [PATCH 14/15] tools/testing/vma: add test to assert MAP_PRIVATE-/dev/ze=
ro is anon
> * [PATCH 15/15] tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero mer=
ge tests
>
> and found the following issue:
> general protection fault in mapping_wrprotect_range_one
>
> Full report is available here:
> https://ci.syzbot.org/series/b5c827e8-78a4-494c-b925-417c34a60e85
>
> ***
>
> general protection fault in mapping_wrprotect_range_one
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      5093dba1014c1d7f7e247fd118f0fa8f22136046
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/0d856612-f1b4-4e6e-86af-4ed321522=
5aa/config
> syz repro: https://ci.syzbot.org/findings/3484dc14-c12f-477e-b14a-6b249c4=
7b2fd/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000003: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
> CPU: 1 UID: 0 PID: 32 Comm: kworker/1:1 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: events fb_deferred_io_work
> RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
> RIP: 0010:mapping_wrprotect_range_one+0x147/0x230 mm/rmap.c:1246
> Code: 7c 24 40 49 8d 7f 28 ba 18 00 00 00 31 f6 e8 e0 2e 14 00 48 c7 84 2=
4 80 00 00 00 01 00 00 00 49 83 c6 18 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00=
 74 08 4c 89 f7 e8 ea 2b 14 00 4d 8b 36 44 89 f6 83
> RSP: 0018:ffffc90000a777c0 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: ffffc90000a779e0 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000a77840
> RBP: ffffc90000a778e0 R08: ffffc90000a7783f R09: 0000000000000000
> R10: ffffc90000a77828 R11: fffff5200014ef08 R12: dffffc0000000000
> R13: 1ffff9200014eefc R14: 0000000000000018 R15: ffffc90000a77800
> FS:  0000000000000000(0000) GS:ffff8882a920c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f84a91e9c38 CR3: 000000000e746000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __rmap_walk_file+0x4cd/0x6a0 mm/rmap.c:3116
>  mapping_wrprotect_range+0x110/0x180 mm/rmap.c:1294
>  fb_deferred_io_work+0x15a/0x310 drivers/video/fbdev/core/fb_defio.c:399
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
> RIP: 0010:mapping_wrprotect_range_one+0x147/0x230 mm/rmap.c:1246
> Code: 7c 24 40 49 8d 7f 28 ba 18 00 00 00 31 f6 e8 e0 2e 14 00 48 c7 84 2=
4 80 00 00 00 01 00 00 00 49 83 c6 18 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00=
 74 08 4c 89 f7 e8 ea 2b 14 00 4d 8b 36 44 89 f6 83
> RSP: 0018:ffffc90000a777c0 EFLAGS: 00010206
> RAX: 0000000000000003 RBX: ffffc90000a779e0 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000a77840
> RBP: ffffc90000a778e0 R08: ffffc90000a7783f R09: 0000000000000000
> R10: ffffc90000a77828 R11: fffff5200014ef08 R12: dffffc0000000000
> R13: 1ffff9200014eefc R14: 0000000000000018 R15: ffffc90000a77800
> FS:  0000000000000000(0000) GS:ffff8882a920c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000025d35e991000 CR3: 0000000110c34000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   7c 24                   jl     0x26
>    2:   40                      rex
>    3:   49 8d 7f 28             lea    0x28(%r15),%rdi
>    7:   ba 18 00 00 00          mov    $0x18,%edx
>    c:   31 f6                   xor    %esi,%esi
>    e:   e8 e0 2e 14 00          call   0x142ef3
>   13:   48 c7 84 24 80 00 00    movq   $0x1,0x80(%rsp)
>   1a:   00 01 00 00 00
>   1f:   49 83 c6 18             add    $0x18,%r14
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 20 00          cmpb   $0x0,(%rax,%r12,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 f7                mov    %r14,%rdi
>   34:   e8 ea 2b 14 00          call   0x142c23
>   39:   4d 8b 36                mov    (%r14),%r14
>   3c:   44 89 f6                mov    %r14d,%esi
>   3f:   83                      .byte 0x83
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
> [akpm@linux-foundation.org apopple@nvidia.com arnd@arndb.de baohua@kernel=
.org baolin.wang@linux.alibaba.com byungchul@sk.com chengming.zhou@linux.de=
v david@kernel.org dev.jain@arm.com gourry@gourry.net gregkh@linuxfoundatio=
n.org harry@kernel.org jack@suse.cz jannh@google.com joshua.hahnjy@gmail.co=
m kees@kernel.org lance.yang@linux.dev liam@infradead.org linmiaohe@huawei.=
com linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-kselft=
est@vger.kernel.org linux-mm@kvack.org ljs@kernel.org matthew.brost@intel.c=
om mhocko@suse.com nao.horiguchi@gmail.com npache@redhat.com peterx@redhat.=
com pfalcato@suse.de rakie.kim@sk.com riel@surriel.com rppt@kernel.org ryan=
.roberts@arm.com surenb@google.com usama.arif@linux.dev vbabka@kernel.org w=
illy@infradead.org xu.xin16@zte.com.cn ying.huang@linux.alibaba.com ziy@nvi=
dia.com]
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
-upstream-moderation/6a5aed9d.f1649fcc.2a4208.0278.GAE%40google.com.
