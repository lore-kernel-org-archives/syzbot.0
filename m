Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8EE42C187
	for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 14:21:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758637268; cv=none; b=WYCbN2oQUVsLzRSk4oO3lyteKS2ZBxuwVbmahIKinlj5xguv/MZDnX+N0g38JQ4J3GljmRqMwGpgKDYCOzSbwx/FZDhGp8jVnS4kmbuoBQw2wCu+FQn6ES+GO+gM03BvGmc3vBZ/i8axdJJxWFYaMCWzhCRjfXz5VWQ2vR2tMyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758637268; c=relaxed/simple;
	bh=069mc0yzhOmXHhZtUyK/PPfTQPeqdlo1Ls7vG2UqL0U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=vDF7yaZfHUce5cLIk8icByICz3AMw0V9tKeYI1/4KytHs0xt/U8eXpbY98srek4OO2EJPbaYTGw7vzZOQQn2q86zc7Oh53rcEr16NfPlqr5Ks3iEQwiWBdxXPxcUzTwxlWWmX0sBONmv7I3T560U+sFG2qpwAXJRfTu8abn4htM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-424861a90dfso49195545ab.2
        for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 07:21:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758637265; x=1759242065;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=/U4erozg2IFC9FfV1560E4km+O0O8AKFmAIq4+ZDQhk=;
        b=PdsoA5JpmsD/jXXfm6tFvaTOIgyq2+OeVIIXEwYBIJqiRD4H/m+ENb7saDgDp8GhM+
         YP+zklQgBTf97ngAiLgKUbalCePa2+dHVpc3iv5nI84mfULEJ5ZAMVaUUJJb6i/Siypu
         RsrQSpjNRIdMuufJI4Oct16mdwL26FkYxfVj2y8YDob/xdyFQDG0s461L2XfLNv1DBsO
         dKriVIxL9WF2djIjUOHlI38LjUeLrfOJIZT1uzsz6KFrVNjlItNy/hetzO4QpGXfXsjE
         WWjfuqlrRdF9NGboBdQrqGnDahQole85hsG/S1doUM0oA8D7MxVA0P9IFiWFoZxZLOm6
         DuGw==
X-Gm-Message-State: AOJu0YxQkzxktvdBtgUij0+uZZMBgxU0YQUgiLfwBYtWE7HxAT/tgbKe
	XSei4LwgJ2+Czp1fpISgdS15XaqfnHr1XnQEWWXxRusOeDB3cC2CVVQkzHI2j4l+VJEZefdbmF2
	Yt+B7G0FIQwoxRLzZL09YrVUgPVPgSY81B+uaYZu3YCxrFNRi1OsnN6kwfh8=
X-Google-Smtp-Source: AGHT+IGUic3iZqfW553I3gy4FI5WldZe1BJtcCXA/KqnNSt1scqBbSXlFPzFgl4zfMsoq7ltg8CSOIAHJwff3IKlAtSYZiv9JAbl
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:cd84:0:b0:425:79b4:9ef6 with SMTP id
 e9e14a558f8ab-42581e9c0b2mr43380555ab.27.1758637264807; Tue, 23 Sep 2025
 07:21:04 -0700 (PDT)
Date: Tue, 23 Sep 2025 07:21:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d2acd0.a70a0220.1b52b.02ad.GAE@google.com>
Subject: [moderation/CI] Re: rust: zpool: add API for C and Rust
From: syzbot ci <syzbot+ci9faeb636baf972e0@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v6] rust: zpool: add API for C and Rust
https://lore.kernel.org/all/20250923102547.2545992-1-vitaly.wool@konsulko.s=
e
* [PATCH v6 1/2] mm: reinstate zpool as a thin API
* [PATCH v6 2/2] rust: zpool: add abstraction for zpool drivers

and found the following issues:
* BUG: unable to handle kernel NULL pointer dereference in zswap_store
* KASAN: slab-out-of-bounds Read in zpool_get_total_pages
* KASAN: slab-out-of-bounds Read in zswap_store
* KASAN: slab-use-after-free Read in zpool_get_total_pages
* KASAN: use-after-free Read in zpool_get_total_pages

Full report is available here:
https://ci.syzbot.org/series/e8b22352-ae56-4d7c-9113-75573acf2b64

***

BUG: unable to handle kernel NULL pointer dereference in zswap_store

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      8f7f8b1b3f4c613dd886f53f768f82816b41eaa3
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/6739e899-fcf7-4f71-b943-5ad0ca0ef8e=
b/config
syz repro: https://ci.syzbot.org/findings/c2ea1ccf-0bb7-4479-ac6d-d6e8e80ef=
a8b/syz_repro

BUG: kernel NULL pointer dereference, address: 0000000000000034
#PF: supervisor read access in kernel mode
#PF: error_code(0x0000) - not-present page
PGD 800000010f582067 P4D 800000010f582067 PUD 0=20
Oops: Oops: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 6005 Comm: syz.2.21 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:kmem_cache_alloc_noprof+0x2e/0x6e0 mm/slub.c:5252
Code: 55 41 57 41 56 41 55 41 54 53 48 83 ec 38 89 f5 49 89 fe 65 48 8b 05 =
c1 43 ab 10 48 89 44 24 30 48 8b 44 24 68 48 89 44 24 18 <8b> 47 34 48 89 4=
4 24 08 8b 1d 44 78 ab 0d 21 f3 89 df e8 db 9c fd
RSP: 0018:ffffc90002dee640 EFLAGS: 00010282
RAX: ffffffff822e7088 RBX: 0000000000012800 RCX: ffff888105ee3a00
RDX: 0000000000000000 RSI: 0000000000012800 RDI: 0000000000000000
RBP: 0000000000012800 R08: ffff888105ee3a00 R09: 0000000000000002
R10: 00000000fffffff0 R11: 0000000000000000 R12: ffff88801d2b1aa0
R13: 1ffff11003a56454 R14: 0000000000000000 R15: 0000000000000020
FS:  00007f819a1c56c0(0000) GS:ffff8881a39dd000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000034 CR3: 000000010e704000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 cache_alloc_handle mm/zsmalloc.c:410 [inline]
 zs_malloc+0x88/0x720 mm/zsmalloc.c:1281
 zswap_compress mm/zswap.c:910 [inline]
 zswap_store_page mm/zswap.c:1429 [inline]
 zswap_store+0x1062/0x1f40 mm/zswap.c:1540
 swap_writeout+0x710/0xd70 mm/page_io.c:275
 writeout mm/vmscan.c:662 [inline]
 pageout mm/vmscan.c:721 [inline]
 shrink_folio_list+0x3011/0x4c70 mm/vmscan.c:1453
 reclaim_folio_list+0xeb/0x500 mm/vmscan.c:2233
 reclaim_pages+0x454/0x520 mm/vmscan.c:2270
 madvise_cold_or_pageout_pte_range+0x1974/0x1d00 mm/madvise.c:565
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0xfe9/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma+0x393/0x440 mm/pagewalk.c:705
 madvise_pageout_page_range mm/madvise.c:624 [inline]
 madvise_pageout mm/madvise.c:649 [inline]
 madvise_vma_behavior+0x311f/0x3a10 mm/madvise.c:1352
 madvise_walk_vmas+0x51c/0xa30 mm/madvise.c:1669
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1885
 do_madvise+0x1bc/0x270 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:1985
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f819938ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f819a1c5038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f81995d5fa0 RCX: 00007f819938ec29
RDX: 0000000000000015 RSI: 0000000000600003 RDI: 0000200000000000
RBP: 00007f8199411e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f81995d6038 R14: 00007f81995d5fa0 R15: 00007ffe68a453c8
 </TASK>
Modules linked in:
CR2: 0000000000000034
---[ end trace 0000000000000000 ]---
RIP: 0010:kmem_cache_alloc_noprof+0x2e/0x6e0 mm/slub.c:5252
Code: 55 41 57 41 56 41 55 41 54 53 48 83 ec 38 89 f5 49 89 fe 65 48 8b 05 =
c1 43 ab 10 48 89 44 24 30 48 8b 44 24 68 48 89 44 24 18 <8b> 47 34 48 89 4=
4 24 08 8b 1d 44 78 ab 0d 21 f3 89 df e8 db 9c fd
RSP: 0018:ffffc90002dee640 EFLAGS: 00010282
RAX: ffffffff822e7088 RBX: 0000000000012800 RCX: ffff888105ee3a00
RDX: 0000000000000000 RSI: 0000000000012800 RDI: 0000000000000000
RBP: 0000000000012800 R08: ffff888105ee3a00 R09: 0000000000000002
R10: 00000000fffffff0 R11: 0000000000000000 R12: ffff88801d2b1aa0
R13: 1ffff11003a56454 R14: 0000000000000000 R15: 0000000000000020
FS:  00007f819a1c56c0(0000) GS:ffff8881a39dd000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000034 CR3: 000000010e704000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	55                   	push   %rbp
   1:	41 57                	push   %r15
   3:	41 56                	push   %r14
   5:	41 55                	push   %r13
   7:	41 54                	push   %r12
   9:	53                   	push   %rbx
   a:	48 83 ec 38          	sub    $0x38,%rsp
   e:	89 f5                	mov    %esi,%ebp
  10:	49 89 fe             	mov    %rdi,%r14
  13:	65 48 8b 05 c1 43 ab 	mov    %gs:0x10ab43c1(%rip),%rax        # 0x10a=
b43dc
  1a:	10
  1b:	48 89 44 24 30       	mov    %rax,0x30(%rsp)
  20:	48 8b 44 24 68       	mov    0x68(%rsp),%rax
  25:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
* 2a:	8b 47 34             	mov    0x34(%rdi),%eax <-- trapping instruction
  2d:	48 89 44 24 08       	mov    %rax,0x8(%rsp)
  32:	8b 1d 44 78 ab 0d    	mov    0xdab7844(%rip),%ebx        # 0xdab787c
  38:	21 f3                	and    %esi,%ebx
  3a:	89 df                	mov    %ebx,%edi
  3c:	e8                   	.byte 0xe8
  3d:	db                   	.byte 0xdb
  3e:	9c                   	pushf
  3f:	fd                   	std


***

KASAN: slab-out-of-bounds Read in zpool_get_total_pages

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      8f7f8b1b3f4c613dd886f53f768f82816b41eaa3
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/6739e899-fcf7-4f71-b943-5ad0ca0ef8e=
b/config
C repro:   https://ci.syzbot.org/findings/a2aa8de3-367f-4cb7-b39a-e3eb65596=
e6d/c_repro
syz repro: https://ci.syzbot.org/findings/a2aa8de3-367f-4cb7-b39a-e3eb65596=
e6d/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in instrument_atomic_read include/linux/inst=
rumented.h:68 [inline]
BUG: KASAN: slab-out-of-bounds in atomic_long_read include/linux/atomic/ato=
mic-instrumented.h:3188 [inline]
BUG: KASAN: slab-out-of-bounds in zs_get_total_pages mm/zsmalloc.c:1066 [in=
line]
BUG: KASAN: slab-out-of-bounds in zpool_get_total_pages+0x46/0x70 mm/zsmall=
oc.c:436
Read of size 8 at addr ffff88810ccc7b10 by task syz.0.17/5992

CPU: 0 UID: 0 PID: 5992 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
 zs_get_total_pages mm/zsmalloc.c:1066 [inline]
 zpool_get_total_pages+0x46/0x70 mm/zsmalloc.c:436
 zswap_total_pages+0xf6/0x1e0 mm/zswap.c:457
 zswap_check_limits mm/zswap.c:465 [inline]
 zswap_store+0x52f/0x1f40 mm/zswap.c:1521
 swap_writeout+0x710/0xd70 mm/page_io.c:275
 writeout mm/vmscan.c:662 [inline]
 pageout mm/vmscan.c:721 [inline]
 shrink_folio_list+0x3011/0x4c70 mm/vmscan.c:1453
 reclaim_folio_list+0xeb/0x500 mm/vmscan.c:2233
 reclaim_pages+0x454/0x520 mm/vmscan.c:2270
 madvise_cold_or_pageout_pte_range+0x1974/0x1d00 mm/madvise.c:565
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0xfe9/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma+0x393/0x440 mm/pagewalk.c:705
 madvise_pageout_page_range mm/madvise.c:624 [inline]
 madvise_pageout mm/madvise.c:649 [inline]
 madvise_vma_behavior+0x311f/0x3a10 mm/madvise.c:1352
 madvise_walk_vmas+0x51c/0xa30 mm/madvise.c:1669
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1885
 do_madvise+0x1bc/0x270 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:1985
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f526318ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdd0a28298 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f52633d5fa0 RCX: 00007f526318ec29
RDX: 0000000000000015 RSI: 0000000000003000 RDI: 0000200000000000
RBP: 00007f5263211e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f52633d5fa0 R14: 00007f52633d5fa0 R15: 0000000000000003
 </TASK>

Allocated by task 1:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 poison_kmalloc_redzone mm/kasan/common.c:400 [inline]
 __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:417
 kasan_kmalloc include/linux/kasan.h:262 [inline]
 __do_kmalloc_node mm/slub.c:5602 [inline]
 __kmalloc_noprof+0x411/0x7f0 mm/slub.c:5614
 kmalloc_noprof include/linux/slab.h:961 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 shrinker_alloc+0x199/0xa80 mm/shrinker.c:724
 binder_alloc_shrinker_init+0x45/0xe0 drivers/android/binder_alloc.c:1265
 binder_init+0x17/0x260 drivers/android/binder.c:7095
 do_one_initcall+0x236/0x820 init/main.c:1283
 do_initcall_level+0x104/0x190 init/main.c:1345
 do_initcalls+0x59/0xa0 init/main.c:1361
 kernel_init_freeable+0x334/0x4b0 init/main.c:1593
 kernel_init+0x1d/0x1d0 init/main.c:1483
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff88810ccc7b00
 which belongs to the cache kmalloc-8 of size 8
The buggy address is located 8 bytes to the right of
 allocated 8-byte region [ffff88810ccc7b00, ffff88810ccc7b08)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10ccc7
anon flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 057ff00000000000 ffff88801a841500 0000000000000000 dead000000000001
raw: 0000000000000000 0000000000800080 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GF=
P_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 1, tgid 1 (swapper/0),=
 ts 16130935485, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1850
 prep_new_page mm/page_alloc.c:1858 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3869
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5159
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:3023 [inline]
 allocate_slab+0x96/0x3a0 mm/slub.c:3196
 new_slab mm/slub.c:3250 [inline]
 ___slab_alloc+0xe94/0x1920 mm/slub.c:4626
 __slab_alloc+0x65/0x100 mm/slub.c:4745
 __slab_alloc_node mm/slub.c:4821 [inline]
 slab_alloc_node mm/slub.c:5232 [inline]
 __do_kmalloc_node mm/slub.c:5601 [inline]
 __kmalloc_node_track_caller_noprof+0x5c7/0x800 mm/slub.c:5711
 __kmemdup_nul mm/util.c:64 [inline]
 kstrdup+0x42/0x100 mm/util.c:84
 __kernfs_new_node+0x9c/0x7e0 fs/kernfs/dir.c:633
 kernfs_new_node+0x102/0x210 fs/kernfs/dir.c:713
 kernfs_create_link+0xa7/0x200 fs/kernfs/symlink.c:39
 sysfs_do_create_link_sd+0x83/0x110 fs/sysfs/symlink.c:44
 device_create_sys_dev_entry+0x11a/0x180 drivers/base/core.c:3515
 device_add+0x733/0xb50 drivers/base/core.c:3659
 __video_register_device+0x3dc1/0x4ca0 drivers/media/v4l2-core/v4l2-dev.c:1=
076
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88810ccc7a00: 00 fc fc fc 05 fc fc fc 00 fc fc fc 00 fc fc fc
 ffff88810ccc7a80: 00 fc fc fc 05 fc fc fc 06 fc fc fc 06 fc fc fc
>ffff88810ccc7b00: 00 fc fc fc 06 fc fc fc 07 fc fc fc 07 fc fc fc
                         ^
 ffff88810ccc7b80: 04 fc fc fc 06 fc fc fc 00 fc fc fc 00 fc fc fc
 ffff88810ccc7c00: 07 fc fc fc 00 fc fc fc 06 fc fc fc 05 fc fc fc
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

KASAN: slab-out-of-bounds Read in zswap_store

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      8f7f8b1b3f4c613dd886f53f768f82816b41eaa3
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/6739e899-fcf7-4f71-b943-5ad0ca0ef8e=
b/config
syz repro: https://ci.syzbot.org/findings/cba572f0-863b-4f91-9ac0-c6f5a1609=
6af/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-out-of-bounds in cache_alloc_handle mm/zsmalloc.c:410 [inl=
ine]
BUG: KASAN: slab-out-of-bounds in zs_malloc+0x77/0x720 mm/zsmalloc.c:1281
Read of size 8 at addr ffff888100ae7680 by task syz.2.19/6046

CPU: 1 UID: 0 PID: 6046 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 cache_alloc_handle mm/zsmalloc.c:410 [inline]
 zs_malloc+0x77/0x720 mm/zsmalloc.c:1281
 zswap_compress mm/zswap.c:910 [inline]
 zswap_store_page mm/zswap.c:1429 [inline]
 zswap_store+0x1062/0x1f40 mm/zswap.c:1540
 swap_writeout+0x710/0xd70 mm/page_io.c:275
 writeout mm/vmscan.c:662 [inline]
 pageout mm/vmscan.c:721 [inline]
 shrink_folio_list+0x3011/0x4c70 mm/vmscan.c:1453
 reclaim_folio_list+0xeb/0x500 mm/vmscan.c:2233
 reclaim_pages+0x454/0x520 mm/vmscan.c:2270
 madvise_cold_or_pageout_pte_range+0x1974/0x1d00 mm/madvise.c:565
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0xfe9/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma+0x393/0x440 mm/pagewalk.c:705
 madvise_pageout_page_range mm/madvise.c:624 [inline]
 madvise_pageout mm/madvise.c:649 [inline]
 madvise_vma_behavior+0x311f/0x3a10 mm/madvise.c:1352
 madvise_walk_vmas+0x51c/0xa30 mm/madvise.c:1669
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1885
 do_madvise+0x1bc/0x270 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:1985
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa813d8ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa814c4c038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fa813fd5fa0 RCX: 00007fa813d8ec29
RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007fa813e11e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa813fd6038 R14: 00007fa813fd5fa0 R15: 00007ffcee547488
 </TASK>

Allocated by task 1:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 unpoison_slab_object mm/kasan/common.c:342 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:368
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4945 [inline]
 slab_alloc_node mm/slub.c:5244 [inline]
 kmem_cache_alloc_noprof+0x367/0x6e0 mm/slub.c:5251
 __kernfs_new_node+0xd7/0x7e0 fs/kernfs/dir.c:637
 kernfs_new_node+0x102/0x210 fs/kernfs/dir.c:713
 __kernfs_create_file+0x4b/0x2e0 fs/kernfs/file.c:1057
 sysfs_add_file_mode_ns+0x238/0x300 fs/sysfs/file.c:313
 create_files fs/sysfs/group.c:76 [inline]
 internal_create_group+0x66d/0x1110 fs/sysfs/group.c:183
 internal_create_groups fs/sysfs/group.c:223 [inline]
 sysfs_create_groups+0x59/0x120 fs/sysfs/group.c:249
 device_add_groups drivers/base/core.c:2836 [inline]
 device_add_attrs+0x1c4/0x5a0 drivers/base/core.c:2911
 device_add+0x496/0xb50 drivers/base/core.c:3643
 usb_new_device+0xa39/0x16f0 drivers/usb/core/hub.c:2694
 register_root_hub+0x275/0x590 drivers/usb/core/hcd.c:994
 usb_add_hcd+0xba1/0x1050 drivers/usb/core/hcd.c:2993
 vhci_hcd_probe+0x1c1/0x380 drivers/usb/usbip/vhci_hcd.c:1377
 platform_probe+0xf9/0x190 drivers/base/platform.c:1405
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x26d/0x9e0 drivers/base/dd.c:659
 __driver_probe_device+0x18c/0x2f0 drivers/base/dd.c:801
 driver_probe_device+0x4f/0x430 drivers/base/dd.c:831
 __device_attach_driver+0x2ce/0x530 drivers/base/dd.c:959
 bus_for_each_drv+0x251/0x2e0 drivers/base/bus.c:462
 __device_attach+0x2b8/0x400 drivers/base/dd.c:1031
 bus_probe_device+0x185/0x260 drivers/base/bus.c:537
 device_add+0x7b6/0xb50 drivers/base/core.c:3689
 platform_device_add+0x4b4/0x820 drivers/base/platform.c:716
 platform_device_register_full+0x46c/0x570 drivers/base/platform.c:844
 vhci_hcd_init+0x1bc/0x310 drivers/usb/usbip/vhci_hcd.c:1533
 do_one_initcall+0x236/0x820 init/main.c:1283
 do_initcall_level+0x104/0x190 init/main.c:1345
 do_initcalls+0x59/0xa0 init/main.c:1361
 kernel_init_freeable+0x334/0x4b0 init/main.c:1593
 kernel_init+0x1d/0x1d0 init/main.c:1483
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff888100ae75a0
 which belongs to the cache kernfs_node_cache of size 176
The buggy address is located 48 bytes to the right of
 allocated 176-byte region [ffff888100ae75a0, ffff888100ae7650)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x100ae7
flags: 0x57ff00000000000(node=3D1|zone=3D2|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 057ff00000000000 ffff888100015dc0 dead000000000122 0000000000000000
raw: 0000000000000000 0000000000110011 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GF=
P_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 1, tgid 1 (swapper/0),=
 ts 12683536009, free_ts 12683151344
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1850
 prep_new_page mm/page_alloc.c:1858 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3869
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5159
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:3023 [inline]
 allocate_slab+0x96/0x3a0 mm/slub.c:3196
 new_slab mm/slub.c:3250 [inline]
 ___slab_alloc+0xe94/0x1920 mm/slub.c:4626
 __slab_alloc+0x65/0x100 mm/slub.c:4745
 __slab_alloc_node mm/slub.c:4821 [inline]
 slab_alloc_node mm/slub.c:5232 [inline]
 kmem_cache_alloc_noprof+0x3f9/0x6e0 mm/slub.c:5251
 __kernfs_new_node+0xd7/0x7e0 fs/kernfs/dir.c:637
 kernfs_new_node+0x102/0x210 fs/kernfs/dir.c:713
 __kernfs_create_file+0x4b/0x2e0 fs/kernfs/file.c:1057
 sysfs_add_file_mode_ns+0x238/0x300 fs/sysfs/file.c:313
 create_files fs/sysfs/group.c:76 [inline]
 internal_create_group+0x66d/0x1110 fs/sysfs/group.c:183
 internal_create_groups fs/sysfs/group.c:223 [inline]
 sysfs_create_groups+0x59/0x120 fs/sysfs/group.c:249
 device_add_groups drivers/base/core.c:2836 [inline]
 device_add_attrs+0x1c4/0x5a0 drivers/base/core.c:2911
 device_add+0x496/0xb50 drivers/base/core.c:3643
page last free pid 1 tgid 1 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1394 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2906
 __slab_free+0x2e7/0x390 mm/slub.c:5922
 qlink_free mm/kasan/quarantine.c:163 [inline]
 qlist_free_all+0x97/0x140 mm/kasan/quarantine.c:179
 kasan_quarantine_reduce+0x148/0x160 mm/kasan/quarantine.c:286
 __kasan_slab_alloc+0x22/0x80 mm/kasan/common.c:352
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4945 [inline]
 slab_alloc_node mm/slub.c:5244 [inline]
 __kmalloc_cache_noprof+0x36f/0x6f0 mm/slub.c:5718
 kmalloc_noprof include/linux/slab.h:957 [inline]
 kzalloc_noprof include/linux/slab.h:1094 [inline]
 device_private_init drivers/base/core.c:3534 [inline]
 device_add+0xbe/0xb50 drivers/base/core.c:3585
 usb_new_device+0xa39/0x16f0 drivers/usb/core/hub.c:2694
 register_root_hub+0x275/0x590 drivers/usb/core/hcd.c:994
 usb_add_hcd+0xba1/0x1050 drivers/usb/core/hcd.c:2993
 vhci_hcd_probe+0x1c1/0x380 drivers/usb/usbip/vhci_hcd.c:1377
 platform_probe+0xf9/0x190 drivers/base/platform.c:1405
 call_driver_probe drivers/base/dd.c:-1 [inline]
 really_probe+0x26d/0x9e0 drivers/base/dd.c:659
 __driver_probe_device+0x18c/0x2f0 drivers/base/dd.c:801
 driver_probe_device+0x4f/0x430 drivers/base/dd.c:831
 __device_attach_driver+0x2ce/0x530 drivers/base/dd.c:959

Memory state around the buggy address:
 ffff888100ae7580: fc fc fc fc 00 00 00 00 00 00 00 00 00 00 00 00
 ffff888100ae7600: 00 00 00 00 00 00 00 00 00 00 fc fc fc fc fc fc
>ffff888100ae7680: fc fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00
                   ^
 ffff888100ae7700: 00 00 00 00 00 00 00 00 fc fc fc fc fc fc fc fc
 ffff888100ae7780: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

KASAN: slab-use-after-free Read in zpool_get_total_pages

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      8f7f8b1b3f4c613dd886f53f768f82816b41eaa3
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/6739e899-fcf7-4f71-b943-5ad0ca0ef8e=
b/config
syz repro: https://ci.syzbot.org/findings/bbd2b5a8-bad1-404c-8f0d-414451cc7=
31a/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: slab-use-after-free in instrument_atomic_read include/linux/ins=
trumented.h:68 [inline]
BUG: KASAN: slab-use-after-free in atomic_long_read include/linux/atomic/at=
omic-instrumented.h:3188 [inline]
BUG: KASAN: slab-use-after-free in zs_get_total_pages mm/zsmalloc.c:1066 [i=
nline]
BUG: KASAN: slab-use-after-free in zpool_get_total_pages+0x46/0x70 mm/zsmal=
loc.c:436
Read of size 8 at addr ffff88801b3033b0 by task syz.0.17/6006

CPU: 1 UID: 0 PID: 6006 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
 zs_get_total_pages mm/zsmalloc.c:1066 [inline]
 zpool_get_total_pages+0x46/0x70 mm/zsmalloc.c:436
 zswap_total_pages+0xf6/0x1e0 mm/zswap.c:457
 zswap_check_limits mm/zswap.c:465 [inline]
 zswap_store+0x52f/0x1f40 mm/zswap.c:1521
 swap_writeout+0x710/0xd70 mm/page_io.c:275
 writeout mm/vmscan.c:662 [inline]
 pageout mm/vmscan.c:721 [inline]
 shrink_folio_list+0x3011/0x4c70 mm/vmscan.c:1453
 reclaim_folio_list+0xeb/0x500 mm/vmscan.c:2233
 reclaim_pages+0x2f4/0x520 mm/vmscan.c:2266
 madvise_cold_or_pageout_pte_range+0x1974/0x1d00 mm/madvise.c:565
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0xfe9/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma+0x393/0x440 mm/pagewalk.c:705
 madvise_pageout_page_range mm/madvise.c:624 [inline]
 madvise_pageout mm/madvise.c:649 [inline]
 madvise_vma_behavior+0x311f/0x3a10 mm/madvise.c:1352
 madvise_walk_vmas+0x51c/0xa30 mm/madvise.c:1669
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1885
 do_madvise+0x1bc/0x270 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:1985
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4f4118ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4f407fe038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f4f413d5fa0 RCX: 00007f4f4118ec29
RDX: 0000000000000015 RSI: 7fffffffffffffff RDI: 0000200000000000
RBP: 00007f4f41211e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4f413d6038 R14: 00007f4f413d5fa0 R15: 00007ffefd579118
 </TASK>

Allocated by task 1:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 unpoison_slab_object mm/kasan/common.c:342 [inline]
 __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:368
 kasan_slab_alloc include/linux/kasan.h:252 [inline]
 slab_post_alloc_hook mm/slub.c:4945 [inline]
 slab_alloc_node mm/slub.c:5244 [inline]
 kmem_cache_alloc_noprof+0x367/0x6e0 mm/slub.c:5251
 acpi_ut_allocate_object_desc_dbg drivers/acpi/acpica/utobject.c:359 [inlin=
e]
 acpi_ut_create_internal_object_dbg+0xe6/0x470 drivers/acpi/acpica/utobject=
.c:69
 acpi_ds_create_operand+0x2d7/0x890 drivers/acpi/acpica/dsutils.c:617
 acpi_ds_create_operands+0x264/0x3f0 drivers/acpi/acpica/dsutils.c:707
 acpi_ds_exec_end_op+0x26b/0x1120 drivers/acpi/acpica/dswexec.c:385
 acpi_ps_parse_loop+0xc33/0x1ab0 drivers/acpi/acpica/psloop.c:525
 acpi_ps_parse_aml+0x22d/0x9b0 drivers/acpi/acpica/psparse.c:475
 acpi_ps_execute_method+0x58d/0x7c0 drivers/acpi/acpica/psxface.c:190
 acpi_ns_evaluate+0x5a6/0xa20 drivers/acpi/acpica/nseval.c:205
 acpi_evaluate_object+0x53f/0xa10 drivers/acpi/acpica/nsxfeval.c:354
 acpi_evaluate_integer+0xfc/0x270 drivers/acpi/utils.c:260
 acpi_bus_get_status_handle drivers/acpi/bus.c:82 [inline]
 acpi_bus_get_status+0x14a/0x380 drivers/acpi/bus.c:111
 acpi_scan_init_status drivers/acpi/scan.c:1863 [inline]
 acpi_add_single_object+0x391/0x1a20 drivers/acpi/scan.c:1896
 acpi_bus_check_add+0x349/0x820 drivers/acpi/scan.c:2179
 acpi_ns_walk_namespace+0x26b/0x690 drivers/acpi/acpica/nswalk.c:-1
 acpi_walk_namespace+0xe8/0x130 drivers/acpi/acpica/nsxfeval.c:606
 acpi_bus_scan+0xe8/0x4b0 drivers/acpi/scan.c:2593
 acpi_scan_init+0x1b0/0x550 drivers/acpi/scan.c:2746
 acpi_init+0x130/0x1f0 drivers/acpi/bus.c:1469
 do_one_initcall+0x236/0x820 init/main.c:1283
 do_initcall_level+0x104/0x190 init/main.c:1345
 do_initcalls+0x59/0xa0 init/main.c:1361
 kernel_init_freeable+0x334/0x4b0 init/main.c:1593
 kernel_init+0x1d/0x1d0 init/main.c:1483
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

Freed by task 1:
 kasan_save_stack mm/kasan/common.c:56 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:77
 __kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:587
 kasan_save_free_info mm/kasan/kasan.h:406 [inline]
 poison_slab_object mm/kasan/common.c:252 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:284
 kasan_slab_free include/linux/kasan.h:234 [inline]
 slab_free_hook mm/slub.c:2507 [inline]
 slab_free mm/slub.c:6557 [inline]
 kmem_cache_free+0x19b/0x690 mm/slub.c:6668
 acpi_os_release_object+0x1d/0x30 drivers/acpi/osl.c:1644
 acpi_ut_update_object_reference+0x47f/0x710 drivers/acpi/acpica/utdelete.c=
:632
 acpi_ds_clear_operands+0xa9/0x1b0 drivers/acpi/acpica/dsutils.c:396
 acpi_ds_exec_end_op+0xbe9/0x1120 drivers/acpi/acpica/dswexec.c:442
 acpi_ps_parse_loop+0xc33/0x1ab0 drivers/acpi/acpica/psloop.c:525
 acpi_ps_parse_aml+0x22d/0x9b0 drivers/acpi/acpica/psparse.c:475
 acpi_ps_execute_method+0x58d/0x7c0 drivers/acpi/acpica/psxface.c:190
 acpi_ns_evaluate+0x5a6/0xa20 drivers/acpi/acpica/nseval.c:205
 acpi_evaluate_object+0x53f/0xa10 drivers/acpi/acpica/nsxfeval.c:354
 acpi_evaluate_integer+0xfc/0x270 drivers/acpi/utils.c:260
 acpi_bus_get_status_handle drivers/acpi/bus.c:82 [inline]
 acpi_bus_get_status+0x14a/0x380 drivers/acpi/bus.c:111
 acpi_scan_init_status drivers/acpi/scan.c:1863 [inline]
 acpi_add_single_object+0x391/0x1a20 drivers/acpi/scan.c:1896
 acpi_bus_check_add+0x349/0x820 drivers/acpi/scan.c:2179
 acpi_ns_walk_namespace+0x26b/0x690 drivers/acpi/acpica/nswalk.c:-1
 acpi_walk_namespace+0xe8/0x130 drivers/acpi/acpica/nsxfeval.c:606
 acpi_bus_scan+0xe8/0x4b0 drivers/acpi/scan.c:2593
 acpi_scan_init+0x1b0/0x550 drivers/acpi/scan.c:2746
 acpi_init+0x130/0x1f0 drivers/acpi/bus.c:1469
 do_one_initcall+0x236/0x820 init/main.c:1283
 do_initcall_level+0x104/0x190 init/main.c:1345
 do_initcalls+0x59/0xa0 init/main.c:1361
 kernel_init_freeable+0x334/0x4b0 init/main.c:1593
 kernel_init+0x1d/0x1d0 init/main.c:1483
 ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

The buggy address belongs to the object at ffff88801b3033a8
 which belongs to the cache Acpi-Operand of size 72
The buggy address is located 8 bytes inside of
 freed 72-byte region [ffff88801b3033a8, ffff88801b3033f0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88801b3030=
00 pfn:0x1b303
flags: 0xfff00000000200(workingset|node=3D0|zone=3D1|lastcpupid=3D0x7ff)
page_type: f5(slab)
raw: 00fff00000000200 ffff88801a894dc0 ffffea00006be4d0 ffffea00006bffd0
raw: ffff88801b303000 000000000027001c 00000000f5000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(GF=
P_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 1, tgid 1 (swapper/0),=
 ts 2367926237, free_ts 0
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1850
 prep_new_page mm/page_alloc.c:1858 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3869
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5159
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_slab_page mm/slub.c:3023 [inline]
 allocate_slab+0x96/0x3a0 mm/slub.c:3196
 new_slab mm/slub.c:3250 [inline]
 ___slab_alloc+0xe94/0x1920 mm/slub.c:4626
 __slab_alloc+0x65/0x100 mm/slub.c:4745
 __slab_alloc_node mm/slub.c:4821 [inline]
 slab_alloc_node mm/slub.c:5232 [inline]
 kmem_cache_alloc_noprof+0x3f9/0x6e0 mm/slub.c:5251
 acpi_ut_allocate_object_desc_dbg drivers/acpi/acpica/utobject.c:359 [inlin=
e]
 acpi_ut_create_internal_object_dbg+0xe6/0x470 drivers/acpi/acpica/utobject=
.c:69
 acpi_ds_create_operand+0x2d7/0x890 drivers/acpi/acpica/dsutils.c:617
 acpi_ds_create_operands+0x264/0x3f0 drivers/acpi/acpica/dsutils.c:707
 acpi_ds_load2_end_op+0xa51/0xf30 drivers/acpi/acpica/dswload2.c:663
 acpi_ds_exec_end_op+0x67b/0x1120 drivers/acpi/acpica/dswexec.c:638
 acpi_ps_parse_loop+0xc33/0x1ab0 drivers/acpi/acpica/psloop.c:525
 acpi_ps_parse_aml+0x22d/0x9b0 drivers/acpi/acpica/psparse.c:475
 acpi_ps_execute_table+0x335/0x410 drivers/acpi/acpica/psxface.c:295
page_owner free stack trace missing

Memory state around the buggy address:
 ffff88801b303280: fb fb fb fb fb fb fb fc fc fc fc 00 00 00 00 00
 ffff88801b303300: 00 00 00 00 fc fc fc fc 00 00 00 00 00 00 00 00
>ffff88801b303380: 00 fc fc fc fc fa fb fb fb fb fb fb fb fb fc fc
                                     ^
 ffff88801b303400: fc fc 00 00 00 00 00 00 00 00 00 fc fc fc fc 00
 ffff88801b303480: 00 00 00 00 00 00 00 00 fc fc fc fc 00 00 00 00
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

KASAN: use-after-free Read in zpool_get_total_pages

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      8f7f8b1b3f4c613dd886f53f768f82816b41eaa3
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/6739e899-fcf7-4f71-b943-5ad0ca0ef8e=
b/config
syz repro: https://ci.syzbot.org/findings/6687daf2-8ec6-4f60-ab6b-b53425f84=
83b/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
BUG: KASAN: use-after-free in instrument_atomic_read include/linux/instrume=
nted.h:68 [inline]
BUG: KASAN: use-after-free in atomic_long_read include/linux/atomic/atomic-=
instrumented.h:3188 [inline]
BUG: KASAN: use-after-free in zs_get_total_pages mm/zsmalloc.c:1066 [inline=
]
BUG: KASAN: use-after-free in zpool_get_total_pages+0x46/0x70 mm/zsmalloc.c=
:436
Read of size 8 at addr ffff88801af0a0d0 by task syz.1.18/6044

CPU: 0 UID: 0 PID: 6044 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_address_description mm/kasan/report.c:378 [inline]
 print_report+0xca/0x240 mm/kasan/report.c:482
 kasan_report+0x118/0x150 mm/kasan/report.c:595
 check_region_inline mm/kasan/generic.c:-1 [inline]
 kasan_check_range+0x2b0/0x2c0 mm/kasan/generic.c:200
 instrument_atomic_read include/linux/instrumented.h:68 [inline]
 atomic_long_read include/linux/atomic/atomic-instrumented.h:3188 [inline]
 zs_get_total_pages mm/zsmalloc.c:1066 [inline]
 zpool_get_total_pages+0x46/0x70 mm/zsmalloc.c:436
 zswap_total_pages+0xf6/0x1e0 mm/zswap.c:457
 zswap_check_limits mm/zswap.c:465 [inline]
 zswap_store+0x52f/0x1f40 mm/zswap.c:1521
 swap_writeout+0x710/0xd70 mm/page_io.c:275
 writeout mm/vmscan.c:662 [inline]
 pageout mm/vmscan.c:721 [inline]
 shrink_folio_list+0x3011/0x4c70 mm/vmscan.c:1453
 reclaim_folio_list+0xeb/0x500 mm/vmscan.c:2233
 reclaim_pages+0x454/0x520 mm/vmscan.c:2270
 madvise_cold_or_pageout_pte_range+0x1974/0x1d00 mm/madvise.c:565
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0xfe9/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma+0x393/0x440 mm/pagewalk.c:705
 madvise_pageout_page_range mm/madvise.c:624 [inline]
 madvise_pageout mm/madvise.c:649 [inline]
 madvise_vma_behavior+0x311f/0x3a10 mm/madvise.c:1352
 madvise_walk_vmas+0x51c/0xa30 mm/madvise.c:1669
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1885
 do_madvise+0x1bc/0x270 mm/madvise.c:1978
 __do_sys_madvise mm/madvise.c:1987 [inline]
 __se_sys_madvise mm/madvise.c:1985 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:1985
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa5a1f8ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa5a2eb5038 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fa5a21d5fa0 RCX: 00007fa5a1f8ec29
RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007fa5a2011e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa5a21d6038 R14: 00007fa5a21d5fa0 R15: 00007ffc6cec8398
 </TASK>

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88801af0af=
c0 pfn:0x1af0a
flags: 0xfff00000000000(node=3D0|zone=3D1|lastcpupid=3D0x7ff)
page_type: f0(buddy)
raw: 00fff00000000000 ffffea00008c38c8 ffffea0000811c88 0000000000000000
raw: ffff88801af0afc0 0000000000000000 00000000f0000000 0000000000000000
page dumped because: kasan: bad access detected
page_owner tracks the page as freed
page last allocated via order 0, migratetype Unmovable, gfp_mask 0x2dc2(GFP=
_KERNEL|__GFP_HIGHMEM|__GFP_ZERO|__GFP_NOWARN), pid 5864, tgid 5864 (syz-ex=
ecutor), ts 59367185001, free_ts 60188955452
 set_page_owner include/linux/page_owner.h:32 [inline]
 post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1850
 prep_new_page mm/page_alloc.c:1858 [inline]
 get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3869
 __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5159
 alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
 alloc_frozen_pages_noprof mm/mempolicy.c:2487 [inline]
 alloc_pages_noprof+0xa9/0x190 mm/mempolicy.c:2507
 vm_area_alloc_pages mm/vmalloc.c:3642 [inline]
 __vmalloc_area_node mm/vmalloc.c:3720 [inline]
 __vmalloc_node_range_noprof+0x97d/0x12f0 mm/vmalloc.c:3893
 vmalloc_user_noprof+0xad/0xf0 mm/vmalloc.c:4046
 kcov_ioctl+0x55/0x640 kernel/kcov.c:716
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 5884 tgid 5884 stack trace:
 reset_page_owner include/linux/page_owner.h:25 [inline]
 free_pages_prepare mm/page_alloc.c:1394 [inline]
 __free_frozen_pages+0xbc4/0xd30 mm/page_alloc.c:2906
 vfree+0x25a/0x400 mm/vmalloc.c:3434
 kcov_put kernel/kcov.c:439 [inline]
 kcov_close+0x28/0x50 kernel/kcov.c:535
 __fput+0x44c/0xa70 fs/file_table.c:468
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 exit_task_work include/linux/task_work.h:40 [inline]
 do_exit+0x6b5/0x2300 kernel/exit.c:966
 do_group_exit+0x21c/0x2d0 kernel/exit.c:1107
 get_signal+0x1285/0x1340 kernel/signal.c:3034
 arch_do_signal_or_restart+0xa0/0x790 arch/x86/kernel/signal.c:337
 exit_to_user_mode_loop+0x72/0x130 kernel/entry/common.c:40
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0xfa0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Memory state around the buggy address:
 ffff88801af09f80: 05 fc fc fc 06 fc fc fc 06 fc fc fc 05 fc fc fc
 ffff88801af0a000: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
>ffff88801af0a080: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
                                                 ^
 ffff88801af0a100: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
 ffff88801af0a180: ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff ff
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[a.hindborg@kernel.org akpm@linux-foundation.org alex.gaynor@gmail.com alic=
eryhl@google.com bjorn3_gh@protonmail.com boqun.feng@gmail.com chengming.zh=
ou@linux.dev dakr@kernel.org david@redhat.com gary@garyguo.net gregkh@linux=
foundation.org hannes@cmpxchg.org liam.howlett@oracle.com linux-kernel@vger=
.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com lossin@kernel.org=
 mhocko@suse.com minchan@kernel.org nphamcs@gmail.com ojeda@kernel.org rppt=
@kernel.org rust-for-linux@vger.kernel.org senozhatsky@chromium.org surenb@=
google.com tmgross@umich.edu vbabka@suse.cz vitaly.wool@konsulko.se yosry.a=
hmed@linux.dev]

If the report looks fine to you, reply with:
#syz upstream

