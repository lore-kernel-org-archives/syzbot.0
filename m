Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8AFF3AA50B
	for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 09:14:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773306861; cv=none; b=ZiWgmqpXCbO4KQ1bhPS3FdEtsYHsxBvs+SH5liyeQ9Pd+ltfgbqYtbycGjTxpxkKfFNeYRYxQclwb7Jppx73PgDfUzJL5BpE+p884um8wHq1+0BSe8zFr6jdEh3NtrW1nYyJJLbDXIqvIt0SOxnC87sKUvh2u7YVGgIgmbwo6J4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773306861; c=relaxed/simple;
	bh=Yn3UYhMFAVSQ0SIdLyotmlM5aS8au9UbjVwBSwAuA44=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=NUz3tbXXoCa8xj+KH6X+XK9NlWS8EYkNBrkjq/HZqT6PZJZDnkWL70eBsu9cwQSIS6Kp8PBxg8dyZFxOP4+9o8mZ04y6S2zjIuHbRVStMjNIyIqkxgjBUdfBBqzdhlysSJ2Fi47rgg+wbFqBdk/L/ns3CoGEIZRPxtIyN/5Nnno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-67bb5810407so13358179eaf.3
        for <syzbot@lists.linux.dev>; Thu, 12 Mar 2026 02:14:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1773306859; x=1773911659;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=PXzO07whrtPhoQq8HgioNxbytU69pEY6YZdifs1dY58=;
        b=tFCaapbvsLuRHc25MWgQMxyGerHIE/ETDaM5TvN/6tvByaF2FhYmllZdTsBkWI027M
         RbBBFdIaeyBjDLA0ETEPCKlSVZhZXL1LEa0wVe+Y6zod6Q+gt4TAWyaQPukxJs05HP6d
         YNyHJ2IqB337CTuz5sgiVyNUFZ5AmHMJdBe7jDc9bkrtg/P03/rcMWz/FTwl35+pXXn3
         N5mSePsUJrwUK2+VW5nqD9vtXQqipYc4FXSfmm2gZIim8PreIRJ8OD+t/1CrBAbqDp4p
         CknXJBZTdrjXapJjXaT2v24QUfFDEJ1XfYGxqeKhJxj1FmPZklFNEvc6NShwKS2q86I8
         SmWw==
X-Gm-Message-State: AOJu0YyPHnL+P2Ya9B71dxDx82biu3WocqRL0nqfv0ZtELvZgD6tf1ML
	v/MZob8esdc40DbQquR9PrS6mUEOXJRps3lMRG4ybXM1HRwW/yee5S/CYgamrv8My1Pzoi7b4kt
	CdL7TfvJ1Ke9VrKqK2xp9zLwcD54fbFMrJAnuJMhPnsiIOiwq3+J9YuQvPEY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:16a3:b0:67b:c7a0:e4ec with SMTP id
 006d021491bc7-67bc88aa4c1mr3506972eaf.22.1773306858736; Thu, 12 Mar 2026
 02:14:18 -0700 (PDT)
Date: Thu, 12 Mar 2026 02:14:18 -0700
In-Reply-To: <20260311154358.150977-1-hannes@cmpxchg.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b283ea.a00a0220.707e5.0011.GAE@google.com>
Subject: [syzbot ci] Re: mm: switch deferred split shrinker to list_lru
From: syzbot ci <syzbot+cif35a646f5f2a4a9b@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@fromorbit.com, david@redhat.com, 
	hannes@cmpxchg.org, kas@kernel.org, liam.howlett@oracle.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, roman.gushchin@linux.dev, 
	usama.arif@linux.dev, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm: switch deferred split shrinker to list_lru
https://lore.kernel.org/all/20260311154358.150977-1-hannes@cmpxchg.org
* [PATCH] mm: switch deferred split shrinker to list_lru

and found the following issue:
WARNING in folio_memcg

Full report is available here:
https://ci.syzbot.org/series/3cf5ecdb-21ef-4894-a22d-6eb1eb437395

***

WARNING in folio_memcg

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      f543926f9d0c3f6dfb354adfe7fbaeedd1277c6b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/6c96ae71-4f8b-4153-8306-440a79f2b2e8/config
C repro:   https://ci.syzbot.org/findings/25285d24-81d9-42b6-b715-1749d43db688/c_repro
syz repro: https://ci.syzbot.org/findings/25285d24-81d9-42b6-b715-1749d43db688/syz_repro

------------[ cut here ]------------
debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->dep_map))
WARNING: ./include/linux/memcontrol.h:376 at obj_cgroup_memcg include/linux/memcontrol.h:376 [inline], CPU#1: syz.0.17/5956
WARNING: ./include/linux/memcontrol.h:376 at folio_memcg+0x148/0x1c0 include/linux/memcontrol.h:430, CPU#1: syz.0.17/5956
Modules linked in:
CPU: 1 UID: 0 PID: 5956 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:obj_cgroup_memcg include/linux/memcontrol.h:376 [inline]
RIP: 0010:folio_memcg+0x148/0x1c0 include/linux/memcontrol.h:430
Code: 48 c1 e8 03 42 80 3c 20 00 74 08 48 89 df e8 8f 59 fb ff 48 8b 03 5b 41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc e8 b9 39 92 ff 90 <0f> 0b 90 eb ca 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c ef fe ff ff
RSP: 0018:ffffc90005d86b98 EFLAGS: 00010093
RAX: ffffffff823359c7 RBX: ffff8881749d1080 RCX: ffff88817250d7c0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffea00068f8007 R09: 1ffffd4000d1f000
R10: dffffc0000000000 R11: fffff94000d1f001 R12: dffffc0000000000
R13: dffffc0000000000 R14: ffffea00068f8000 R15: ffffea00068f8030
FS:  0000555584c04500(0000) GS:ffff8882a9466000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2e563fff CR3: 0000000175ed0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __folio_freeze_and_split_unmapped+0x1db/0x31f0 mm/huge_memory.c:3766
 __folio_split+0xa99/0x1570 mm/huge_memory.c:4029
 madvise_cold_or_pageout_pte_range+0xe3b/0x2220 mm/madvise.c:501
 walk_pmd_range mm/pagewalk.c:129 [inline]
 walk_pud_range mm/pagewalk.c:223 [inline]
 walk_p4d_range mm/pagewalk.c:261 [inline]
 walk_pgd_range+0x1032/0x1d30 mm/pagewalk.c:302
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:714
 madvise_pageout_page_range mm/madvise.c:620 [inline]
 madvise_pageout mm/madvise.c:645 [inline]
 madvise_vma_behavior+0x2883/0x44d0 mm/madvise.c:1356
 madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1711
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1927
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2020
 __do_sys_madvise mm/madvise.c:2029 [inline]
 __se_sys_madvise mm/madvise.c:2027 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2027
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb99159c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc93688748 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fb991815fa0 RCX: 00007fb99159c799
RDX: 0000000000000015 RSI: 0000000000002000 RDI: 0000200000f0f000
RBP: 00007fb991632bd9 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb991815fac R14: 00007fb991815fa0 R15: 00007fb991815fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
