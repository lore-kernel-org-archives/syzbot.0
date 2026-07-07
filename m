Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6873AB5C7
	for <syzbot@lists.linux.dev>; Tue,  7 Jul 2026 19:44:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783453464; cv=none; b=Bojr+BhMaIX7woLoZ4MGRqvz6n3OJ4yfr+MN8aGgDZy/yMiFQOdu1iQtPha+NjXlqFxfRIJxsMVqp7+xSOoBvuWCP5yPFQ4meDIArBhpe37LZaZUVp2ZKxW12uLcjqqU0AZYRXwmVMBcgkOVx26beCowCf6VCw87PT3KBvJUHXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783453464; c=relaxed/simple;
	bh=GFjKOCb46iRS1OGbg06m+gGbMWXQJJ9hzssqbaixduY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=RLDqPy/CX9hZL6E/Ua7dC9WYebc8e3v6yuXb/7bPhgUfUGtQTiuuCOPG/+XAB8iuzfZPsrUSxIIYtp6IN0uwFppjI6SeuYTCHUqLd8hBB3fb5UjuUmUT8ZEpQ+If6xwSa7gplBwmFjAvKibwe07dYIeUEGXIN8LI63eVKMtAwoE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6a153a05578so5865946eaf.0
        for <syzbot@lists.linux.dev>; Tue, 07 Jul 2026 12:44:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783453462; x=1784058262;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=vUUV1t3Pt3qDMXnZG/aV39SBzGIAYvCncmjNDu9KpH8=;
        b=Zu/CVR9xHPbNA9rGz4+rS4wvNUahPSSifqn4DZ4mod+OY8F4vrwRpamb1AmqnmG3Pp
         XqYYU8dDEDuLgLdkA1cVbLBWIj7V+JJrRJRN//sxFp4FLTn0byRcS5cO2AUMY36fe4ZS
         K29l0rMtK9lyUeQOQTNTVVdhtaYDmugwO9p8h/n340S7l703lARKz5jeg/tWzksn+r5g
         0zecQzsmfpPt1FUxwk+C/9BaSKJaV5ctXo611Fmg/QCREPPaUqXIkKr9XULVubHIvHLf
         8z86tlhsz0NYFfmpqIWmuTX5GQHwqa6AQf7ecBvXtyG06e6JNI7DhJS5TuvROsNJ6Az7
         X1jQ==
X-Gm-Message-State: AOJu0YwH88ODBRCQV8F8S2QnseakwjzmNkcWucrnim2fMVOCaLcihRyx
	xC28cE5GXvE7Wc5/F0WmFB0+NwzbMyNoi9XZ4ieiiBvO5f0uVQexlofBks621YbPdV3l5zaHfVw
	aM4wYekLOxEYrdnwpENCZcJGuOk+2zmbl481+k15UQTMvsLMLOYmUmET5lC4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1a04:b0:6a1:7e36:e887 with SMTP id
 006d021491bc7-6a3553a1e80mr4596207eaf.29.1783453462028; Tue, 07 Jul 2026
 12:44:22 -0700 (PDT)
Date: Tue, 07 Jul 2026 12:44:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4d5716.a1ad617e.25832.0009.GAE@google.com>
Subject: [moderation/CI] Re: mm: store zswap entries in swap table (Pointer entry)
From: syzbot ci <syzbot+ci3c668b9bdaa73218@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm: store zswap entries in swap table (Pointer entry)
https://lore.kernel.org/all/20260707073215.72183-1-baoquan.he@linux.dev
* [RFC PATCH 1/7] mm/swap_table: add Pointer type support for zswap entry s=
torage
* [RFC PATCH 2/7] mm/zswap: add swp_tb_val to zswap_entry and Pointer acces=
sor helpers
* [RFC PATCH 3/7] mm/swap_state: do zswap conversion in __swap_cache_do_del=
_folio
* [RFC PATCH 4/7] mm/zswap, mm/swap_state: handle Pointer entries in add_fo=
lio path
* [RFC PATCH 5/7] mm/swapfile: handle Pointer entries in count/dup/put path=
s
* [RFC PATCH 6/7] mm/zswap, mm/swap_state: migrate zswap to use swap_table =
for entry indexing
* [RFC PATCH 7/7] mm/zswap, mm/swap_state: replace xarray indexing with swa=
p table lookups

and found the following issue:
WARNING in __swap_cache_do_del_folio

Full report is available here:
https://ci.syzbot.org/series/1a9cfadb-ed85-48c1-b1b3-a3c12ea99471

***

WARNING in __swap_cache_do_del_folio

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      01bc0932614c2d3c35e732f54d249b5897d94307
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/65f10583-d539-4b33-8ba9-494d42eb959=
3/config
syz repro: https://ci.syzbot.org/findings/3673912c-5490-4f26-ba24-276021c43=
d9b/syz_repro

------------[ cut here ]------------
!swp_tb_is_folio(old_tb) || swp_tb_to_folio(old_tb) !=3D folio
WARNING: mm/swap_state.c:327 at __swap_cache_do_del_folio+0x6ef/0xdf0 mm/sw=
ap_state.c:326, CPU#1: syz.2.63/6057
Modules linked in:
CPU: 1 UID: 0 PID: 6057 Comm: syz.2.63 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__swap_cache_do_del_folio+0x6ef/0xdf0 mm/swap_state.c:326
Code: ff c9 48 09 c1 4c 21 f9 48 39 4c 24 08 0f 85 8c 02 00 00 e8 73 9a 9b =
ff 49 bf 00 00 00 00 00 fc ff df eb 3d e8 62 9a 9b ff 90 <0f> 0b 90 41 89 e=
d 41 83 e5 01 31 ff 4c 89 ee e8 2d 9f 9b ff 31 ff
RSP: 0018:ffffc90003ea6690 EFLAGS: 00010093
RAX: ffffffff822acdb9 RBX: 000000000000001f RCX: ffff88816d7d9e00
RDX: 0000000000000000 RSI: 0000000000000002 RDI: ffffea0006be5f08
RBP: 00000000006be5f2 R08: ffff88801c7d20ff R09: 1ffff110038fa41f
R10: dffffc0000000000 R11: ffffed10038fa420 R12: 0000000000000000
R13: 0000000006be5f00 R14: 0000000000000002 R15: dffffc0000000000
FS:  00007fef4622c6c0(0000) GS:ffff8882a921d000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000280 CR3: 0000000176c44000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __swap_cache_del_folio+0xd5/0x170 mm/swap_state.c:377
 __remove_mapping+0xabb/0xe20 mm/vmscan.c:736
 shrink_folio_list+0x2b42/0x5350 mm/vmscan.c:1489
 reclaim_folio_list+0x100/0x430 mm/vmscan.c:2163
 reclaim_pages+0x2f1/0x530 mm/vmscan.c:2196
 madvise_cold_or_pageout_pte_range+0x1c1e/0x22e0 mm/madvise.c:562
 walk_pmd_range mm/pagewalk.c:148 [inline]
 walk_pud_range mm/pagewalk.c:239 [inline]
 walk_p4d_range mm/pagewalk.c:280 [inline]
 walk_pgd_range+0x100f/0x1e40 mm/pagewalk.c:321
 __walk_page_range+0x16d/0x720 mm/pagewalk.c:429
 walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:733
 madvise_pageout_page_range mm/madvise.c:621 [inline]
 madvise_pageout mm/madvise.c:646 [inline]
 madvise_vma_behavior+0x2922/0x4340 mm/madvise.c:1357
 madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1712
 madvise_do_behavior+0x385/0x540 mm/madvise.c:1907
 do_madvise+0x327/0x3a0 mm/madvise.c:2005
 __do_sys_madvise mm/madvise.c:2014 [inline]
 __se_sys_madvise mm/madvise.c:2012 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fef4539ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fef4622c028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fef45616180 RCX: 00007fef4539ce59
RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007fef45432e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fef45616218 R14: 00007fef45616180 R15: 00007ffcd47ce068
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[akpm@linux-foundation.org baohua@kernel.org baoquan.he@linux.dev chengming=
.zhou@linux.dev chrisl@kernel.org hannes@cmpxchg.org kasong@tencent.com lin=
ux-kernel@vger.kernel.org linux-mm@kvack.org nphamcs@gmail.com shikemeng@hu=
aweicloud.com yosry@kernel.org youngjun.park@lge.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

