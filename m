Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9988133FE10
	for <syzbot@lists.linux.dev>; Tue, 28 Oct 2025 18:03:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761674640; cv=none; b=AvuGN4up1R+BNf3H8C7+Xsmo7TxhrL46Af1KHCDtpukEnuWjw1pZDPp0Z8wTJ36lctYiqEjsd+G4IzCbRyxD/VdOqNXOtOdUUFuHmMoGCTDQSr30G3sduwbIZbukNrIW7obNwIGIdc3fzCBXpyH6iUvszgVDnMDIjbojcW8Owy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761674640; c=relaxed/simple;
	bh=WwCEWHkgD97sldq7RTGg70QScxlKJhlFrqHElre7nm0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Uwom3QLaVvjnicJXGC7hqqYA1IDHZr+rx5v+eSB4gPRkNNtRRwtyHqDwJYvyNz+Y1EIRiFQXnqq1G+RzbYexG3RGbRnGn/7W2eNfEp4C4lFDqqFCIAXPtHTSpcT4emjygzaa5NliZjiAdZywu1WwrFNJ4sJkyf01SLMgQhLMij0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-940f9efd090so2016128939f.3
        for <syzbot@lists.linux.dev>; Tue, 28 Oct 2025 11:03:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761674637; x=1762279437;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=PP/l4YFXGDMErWlo/OKU8YsJxYd+k/sibTgysiLwh9k=;
        b=vfHycKZzrQg5TtXb1B9uBH35VeRcVZjuulUrxsbHPv3s1XJpQ45UyBEasepytl2S9/
         RQHumLoyYElmKCnMeLf6VnpBXNr2k9vp9LsYUE50YGN6vjBEM83lQTAbjm086iqfosaV
         Emz3ZlqGWLgkvjOBzG8EYgNpdu0m2DTarC3mu/3O9N6P/szohIMNteXLHFhFlT+crXNC
         PTqIcg1LKHfxunvrkV6pokVifrxOgEJAw7E/NvnQgcJo03uI//5wgpdkEncWlOAgrMP9
         tzP02iPY8e8CnLn6KFHb+Vpu+qojxYt6FX6hLs5xViggf8+NeaAJv9zcprexxdiDFd0i
         ficw==
X-Gm-Message-State: AOJu0YyGfa5NPfEsLwQJSGw5vE7VLfbJxW8fLAMYmwE/9DN8+ulwrSCm
	04ouYtY0QbiXahBCd8okWBBtO8bOsRQVXZawdmBlgxdiJUWmL8JdSYfoPh+9be6gZq86VsdzMYJ
	wqU2b41cdeJlQpbFU+WPxVYLR0OiBo1EAqUkgRWY3Q7l/0uyP8bQVMQcJ2LI=
X-Google-Smtp-Source: AGHT+IGKmCTUQ8hxt1s6kra0auCRXlpU/nVHVuGg5PaerBESK35lCc3OuaZBFewiRyo2Trmb9zAplo0XQfrKzk/CD3APJFHSCETg
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3397:b0:430:a3b0:8458 with SMTP id
 e9e14a558f8ab-432f8f87239mr1902325ab.3.1761674637550; Tue, 28 Oct 2025
 11:03:57 -0700 (PDT)
Date: Tue, 28 Oct 2025 11:03:57 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6901058d.050a0220.3344a1.03bd.GAE@google.com>
Subject: [moderation/CI] Re: Eliminate Dying Memory Cgroup
From: syzbot ci <syzbot+cia7c4c258eb33cb2e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Eliminate Dying Memory Cgroup
https://lore.kernel.org/all/cover.1761658310.git.zhengqi.arch@bytedance.com
* [PATCH v1 01/26] mm: memcontrol: remove dead code of checking parent memo=
ry cgroup
* [PATCH v1 02/26] mm: workingset: use folio_lruvec() in workingset_refault=
()
* [PATCH v1 03/26] mm: rename unlock_page_lruvec_irq and its variants
* [PATCH v1 04/26] mm: vmscan: refactor move_folios_to_lru()
* [PATCH v1 05/26] mm: memcontrol: allocate object cgroup for non-kmem case
* [PATCH v1 06/26] mm: memcontrol: return root object cgroup for root memor=
y cgroup
* [PATCH v1 07/26] mm: memcontrol: prevent memory cgroup release in get_mem=
_cgroup_from_folio()
* [PATCH v1 08/26] buffer: prevent memory cgroup release in folio_alloc_buf=
fers()
* [PATCH v1 09/26] writeback: prevent memory cgroup release in writeback mo=
dule
* [PATCH v1 10/26] mm: memcontrol: prevent memory cgroup release in count_m=
emcg_folio_events()
* [PATCH v1 11/26] mm: page_io: prevent memory cgroup release in page_io mo=
dule
* [PATCH v1 12/26] mm: migrate: prevent memory cgroup release in folio_migr=
ate_mapping()
* [PATCH v1 13/26] mm: mglru: prevent memory cgroup release in mglru
* [PATCH v1 14/26] mm: memcontrol: prevent memory cgroup release in mem_cgr=
oup_swap_full()
* [PATCH v1 15/26] mm: workingset: prevent memory cgroup release in lru_gen=
_eviction()
* [PATCH v1 16/26] mm: thp: prevent memory cgroup release in folio_split_qu=
eue_lock{_irqsave}()
* [PATCH v1 17/26] mm: workingset: prevent lruvec release in workingset_ref=
ault()
* [PATCH v1 18/26] mm: zswap: prevent lruvec release in zswap_folio_swapin(=
)
* [PATCH v1 19/26] mm: swap: prevent lruvec release in swap module
* [PATCH v1 20/26] mm: workingset: prevent lruvec release in workingset_act=
ivation()
* [PATCH v1 21/26] mm: memcontrol: prepare for reparenting LRU pages for lr=
uvec lock
* [PATCH v1 22/26] mm: vmscan: prepare for reparenting traditional LRU foli=
os
* [PATCH v1 23/26] mm: vmscan: prepare for reparenting MGLRU folios
* [PATCH v1 24/26] mm: memcontrol: refactor memcg_reparent_objcgs()
* [PATCH v1 25/26] mm: memcontrol: eliminate the problem of dying memory cg=
roup for LRU folios
* [PATCH v1 26/26] mm: lru: add VM_WARN_ON_ONCE_FOLIO to lru maintenance he=
lpers

and found the following issue:
WARNING in folio_memcg

Full report is available here:
https://ci.syzbot.org/series/0d48a77a-fb4f-485d-9fd6-086afd6fb650

***

WARNING in folio_memcg

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      b227c04932039bccc21a0a89cd6df50fa57e4716
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/503d7034-ae99-44d1-8fb2-62e7ef5e1c7=
c/config
C repro:   https://ci.syzbot.org/findings/880c374a-1b49-436e-9be2-63d5e2c6b=
6ab/c_repro
syz repro: https://ci.syzbot.org/findings/880c374a-1b49-436e-9be2-63d5e2c6b=
6ab/syz_repro

exFAT-fs (loop0): failed to load upcase table (idx : 0x00010000, chksum : 0=
xe5674ec2, utbl_chksum : 0xe619d30d)
exFAT-fs (loop0): failed to load alloc-bitmap
exFAT-fs (loop0): failed to recognize exfat type
------------[ cut here ]------------
WARNING: CPU: 1 PID: 5965 at ./include/linux/memcontrol.h:380 obj_cgroup_me=
mcg include/linux/memcontrol.h:380 [inline]
WARNING: CPU: 1 PID: 5965 at ./include/linux/memcontrol.h:380 folio_memcg+0=
x148/0x1c0 include/linux/memcontrol.h:434
Modules linked in:
CPU: 1 UID: 0 PID: 5965 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:obj_cgroup_memcg include/linux/memcontrol.h:380 [inline]
RIP: 0010:folio_memcg+0x148/0x1c0 include/linux/memcontrol.h:434
Code: 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 5f c8 06 00 48 8b 03 5b =
41 5c 41 5e 41 5f 5d e9 cf 89 2a 09 cc e8 a9 bb a0 ff 90 <0f> 0b 90 eb ca 4=
4 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c ef fe ff ff
RSP: 0018:ffffc90003ec66b0 EFLAGS: 00010293
RAX: ffffffff821f4b57 RBX: ffff888108b31480 RCX: ffff88816be91d00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff88816be91d00 R09: 0000000000000002
R10: 00000000fffffff0 R11: 0000000000000000 R12: dffffc0000000000
R13: 00000000ffffffe4 R14: ffffea0006d5f840 R15: ffffea0006d5f870
FS:  000055555db87500(0000) GS:ffff8882a9f35000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ee63fff CR3: 000000010c308000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 zswap_compress mm/zswap.c:900 [inline]
 zswap_store_page mm/zswap.c:1430 [inline]
 zswap_store+0xfa2/0x1f80 mm/zswap.c:1541
 swap_writeout+0x6e8/0xf20 mm/page_io.c:275
 writeout mm/vmscan.c:651 [inline]
 pageout mm/vmscan.c:699 [inline]
 shrink_folio_list+0x34ec/0x4c40 mm/vmscan.c:1418
 reclaim_folio_list+0xeb/0x500 mm/vmscan.c:2196
 reclaim_pages+0x454/0x520 mm/vmscan.c:2233
 madvise_cold_or_pageout_pte_range+0x1974/0x1d00 mm/madvise.c:565
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0xfe9/0x1d40 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma+0x393/0x440 mm/pagewalk.c:717
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
RIP: 0033:0x7fccac38efc9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd9cc58708 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fccac5e5fa0 RCX: 00007fccac38efc9
RDX: 0000000000000015 RSI: 7fffffffffffffff RDI: 0000200000000000
RBP: 00007fccac411f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fccac5e5fa0 R14: 00007fccac5e5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org axelrasmussen@google.com cgroups@vger.kernel.org=
 chengming.zhou@linux.dev david@redhat.com hannes@cmpxchg.org harry.yoo@ora=
cle.com hughd@google.com imran.f.khan@oracle.com kamalesh.babulal@oracle.co=
m linux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.co=
m mhocko@suse.com muchun.song@linux.dev nphamcs@gmail.com qi.zheng@linux.de=
v roman.gushchin@linux.dev shakeel.butt@linux.dev songmuchun@bytedance.com =
weixugc@google.com yuanchu@google.com zhengqi.arch@bytedance.com ziy@nvidia=
.com]

If the report looks fine to you, reply with:
#syz upstream

