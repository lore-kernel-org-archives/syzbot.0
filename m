Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9C35938B13D
	for <syzbot@lists.linux.dev>; Thu, 19 Mar 2026 19:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773949002; cv=none; b=N6lbsmDxePpsbtjeCb3GSrrMYkY4AffpF/W0OdavukVDvXQ7/+WA/JBw5c+o5JWelomoRQECZEu5to96pRrosDGJGiQa/deLU38jFfwoEjFMRelGXy2J8wiCKHnQXdUbhrFMKIBaUpcHrq2VjnZ+dqaAvViCmyJheuQ6gfmfKEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773949002; c=relaxed/simple;
	bh=feX6sgx0xAD9xHn+/2DSdJ4RvHhwt9VlYcFF4LOR8tA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=iHBaaqgzyU9eZWkt4mbUirmsHz+tK0VmiyDDLRnvc4R4l6xbbayI4vSr8v6S+jLFUyby1DunET5HJ0U99BkoFaaFmw2doz1FkLd1RD7rpPHV9qvBRMJs1Rvoj6PESWbMav2jZMxN850b0YfY6hz4q2msnDepv+b751QXX9Qzx58=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-67c0da9bd62so22159849eaf.1
        for <syzbot@lists.linux.dev>; Thu, 19 Mar 2026 12:36:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773948999; x=1774553799;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QQvijpkmYOPooO1Tc52F7bRiX0OFrFVzzFllGfLGhp0=;
        b=WVI568V0pMRK4GBGSFoZJabNPPyVkoJr1QCTO1Qx3JZT1KbIN78ybvZIY/tDSpd9M1
         Eq7e0tn7gaLBUOzxW0A4vy64DpWwl2QQ23BpAwzhF0mhMvEU56x3gE5jBJCs0cTGk62N
         su4TIqi/7GHoiFN7xb4clt4I/PTS3dMhRW+PS5ifRLKjy6srvLCpJPH2knNn0ZQZ4aLn
         mjZtn9gZbQt85CVFjnrASx28taw1lUhUS7H0ljnn4TPjX1lFVpI7NdtQRnReLn7Z6k7N
         kA51G9Gu0JkO1rzgFn6kT/LDksdmCF0za+rs8SfY8zK6tqk4Y8IK9RR/obMwji18nOBg
         g4fA==
X-Gm-Message-State: AOJu0YyuP7f+En7JfiwEirB9bJWJ4yKObH4jg7WMjzKNSmhPUyJqTr1j
	icxHPBCSZ22WUmgPvnhQ2XXJKGKnnRuaeTJW6UX/l9kqvVaKrE6fsHZSHpPG1xua+0zBZ6F1Wbv
	iVcLWsyzQKqZ7zVNbxMOmsWU20P9OVoeuQAazwXkA+1pgVbQpcjvOohC/9e4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:602:b0:67b:dfa3:aef3 with SMTP id
 006d021491bc7-67c22fec5c4mr492038eaf.62.1773948999638; Thu, 19 Mar 2026
 12:36:39 -0700 (PDT)
Date: Thu, 19 Mar 2026 12:36:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bc5047.050a0220.29e68b.000b.GAE@google.com>
Subject: [moderation/CI] Re: Virtual Swap Space
From: syzbot ci <syzbot+ci80b9ac1c24010dcc@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] Virtual Swap Space
https://lore.kernel.org/all/20260318222953.441758-1-nphamcs@gmail.com
* [PATCH v4 01/21] mm/swap: decouple swap cache from physical swap infrastr=
ucture
* [PATCH v4 02/21] swap: rearrange the swap header file
* [PATCH v4 03/21] mm: swap: add an abstract API for locking out swapoff
* [PATCH v4 04/21] zswap: add new helpers for zswap entry operations
* [PATCH v4 05/21] mm/swap: add a new function to check if a swap entry is =
in swap cached.
* [PATCH v4 06/21] mm: swap: add a separate type for physical swap slots
* [PATCH v4 07/21] mm: create scaffolds for the new virtual swap implementa=
tion
* [PATCH v4 08/21] zswap: prepare zswap for swap virtualization
* [PATCH v4 09/21] mm: swap: allocate a virtual swap slot for each swapped =
out page
* [PATCH v4 10/21] swap: move swap cache to virtual swap descriptor
* [PATCH v4 11/21] zswap: move zswap entry management to the virtual swap d=
escriptor
* [PATCH v4 12/21] swap: implement the swap_cgroup API using virtual swap
* [PATCH v4 13/21] swap: manage swap entry lifecycle at the virtual swap la=
yer
* [PATCH v4 14/21] mm: swap: decouple virtual swap slot from backing store
* [PATCH v4 15/21] zswap: do not start zswap shrinker if there is no physic=
al swap slots
* [PATCH v4 16/21] swap: do not unnecesarily pin readahead swap entries
* [PATCH v4 17/21] swapfile: remove zeromap bitmap
* [PATCH v4 18/21] memcg: swap: only charge physical swap slots
* [PATCH v4 19/21] swap: simplify swapoff using virtual swap
* [PATCH v4 20/21] swapfile: replace the swap map with bitmaps
* [PATCH v4 21/21] vswap: batch contiguous vswap free calls

and found the following issue:
possible deadlock in vswap_iter

Full report is available here:
https://ci.syzbot.org/series/f8238a2a-370e-404d-b3f7-5945b574bd63

***

possible deadlock in vswap_iter

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      05f7e89ab9731565d8a62e3b5d1ec206485eeb0b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/cf1517a6-d391-46d8-bfbe-98e6be6b93c=
e/config
syz repro: https://ci.syzbot.org/findings/b4e84ae7-17d4-4bf8-9c3f-4c13b10a1=
e52/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
syz.1.18/6001 is trying to acquire lock:
ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock include/linux/=
spinlock.h:351 [inline]
ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: vswap_iter+0xfa/0x1b0 mm=
/vswap.c:274

but task is already holding lock:
ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq include/li=
nux/spinlock.h:376 [inline]
ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_irq+0xe2=
/0x190 mm/vswap.c:1529

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(&cluster->lock);
  lock(&cluster->lock);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by syz.1.18/6001:
 #0: ffff8881bb523440 (&mm->mmap_lock){++++}-{4:4}, at: mmap_read_lock incl=
ude/linux/mmap_lock.h:391 [inline]
 #0: ffff8881bb523440 (&mm->mmap_lock){++++}-{4:4}, at: madvise_lock+0x152/=
0x2e0 mm/madvise.c:1789
 #1: ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: spin_lock_irq inclu=
de/linux/spinlock.h:376 [inline]
 #1: ffff88811fba0018 (&cluster->lock){+.+.}-{3:3}, at: swap_cache_lock_irq=
+0xe2/0x190 mm/vswap.c:1529
 #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire inc=
lude/linux/rcupdate.h:331 [inline]
 #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock includ=
e/linux/rcupdate.h:867 [inline]
 #2: ffffffff8e55a360 (rcu_read_lock){....}-{1:3}, at: vswap_cgroup_record+=
0x41/0x440 mm/vswap.c:1909

stack backtrace:
CPU: 0 UID: 0 PID: 6001 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain kernel/locking/lockdep.c:3895 [inline]
 __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 vswap_iter+0xfa/0x1b0 mm/vswap.c:274
 vswap_cgroup_record+0xeb/0x440 mm/vswap.c:1910
 swap_cgroup_record+0xc5/0x130 mm/vswap.c:1933
 memcg1_swapout+0x358/0x9e0 mm/memcontrol-v1.c:623
 __remove_mapping+0x7d4/0xa70 mm/vmscan.c:762
 shrink_folio_list+0x287c/0x5160 mm/vmscan.c:1518
 reclaim_folio_list+0x100/0x400 mm/vmscan.c:2198
 reclaim_pages+0x45b/0x530 mm/vmscan.c:2235
 madvise_cold_or_pageout_pte_range+0x1eac/0x2220 mm/madvise.c:444
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x1032/0x1d30 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:714
 madvise_pageout_page_range mm/madvise.c:622 [inline]
 madvise_pageout mm/madvise.c:647 [inline]
 madvise_vma_behavior+0x2951/0x43c0 mm/madvise.c:1366
 madvise_walk_vmas+0x57a/0xaf0 mm/madvise.c:1721
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1937
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2030
 __do_sys_madvise mm/madvise.c:2039 [inline]
 __se_sys_madvise mm/madvise.c:2037 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2037
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2b3459c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f2b35495028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f2b34815fa0 RCX: 00007f2b3459c799
RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007f2b34632c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f2b34816038 R14: 00007f2b34815fa0 R15: 00007ffcfbbae8f8
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org apopple@nvidia.com axelrasmussen@google.com baoh=
ua@kernel.org baolin.wang@linux.alibaba.com bhe@redhat.com byungchul@sk.com=
 cgroups@vger.kernel.org chengming.zhou@linux.dev chrisl@kernel.org corbet@=
lwn.net david@kernel.org dev.jain@arm.com gourry@gourry.net hannes@cmpxchg.=
org hughd@google.com jannh@google.com joshua.hahnjy@gmail.com kasong@tencen=
t.com kernel-team@meta.com lance.yang@linux.dev lenb@kernel.org liam.howlet=
t@oracle.com linux-doc@vger.kernel.org linux-kernel@vger.kernel.org linux-m=
m@kvack.org linux-pm@vger.kernel.org lorenzo.stoakes@oracle.com matthew.bro=
st@intel.com mhocko@suse.com muchun.song@linux.dev npache@redhat.com nphamc=
s@gmail.com pavel@kernel.org peterx@redhat.com peterz@infradead.org pfalcat=
o@suse.de rafael@kernel.org rakie.kim@sk.com riel@surriel.com roman.gushchi=
n@linux.dev rppt@kernel.org ryan.roberts@arm.com shakeel.butt@linux.dev shi=
kemeng@huaweicloud.com surenb@google.com tglx@kernel.org vbabka@suse.cz wei=
xugc@google.com ying.huang@linux.alibaba.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

