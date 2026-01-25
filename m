Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 522562F5A10
	for <syzbot@lists.linux.dev>; Sun, 25 Jan 2026 22:00:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769378413; cv=none; b=WAnOLUSkTCJofzP3rSGbHqsDsF41vxTdRMoapFnVhELULza6JmHMIcvKAclgYYDlyNAQFlv3pzSQYUUAGLXbJvkNJlH790KJmIvIDuAQof39xpmDmPgjPtg2r/bNBqzuLfa2sCbhuVFPIUMlQBWUsP4nYPdp16PiLxKeglUoIFs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769378413; c=relaxed/simple;
	bh=Tlbg8IVB1ExUXXrsNBbv08wYMjVjalDxHPaAtbCJTMY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=PgigzuzdlOLgGr/+m1J2RdE0B4QzSTWEV8l1d621cchCdlFQRht5Lr3YQGaINLytZdH5kOnbv3AAsh292OTFbgfBkOu/yQ+xtr7hutdBmoRf/hWY6apGKAFNLss+IJXBni+JsdKC/yRE6pIBuL56gtxsh3lR6xUttHYyNVGVnNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-662ca3cb667so4728094eaf.2
        for <syzbot@lists.linux.dev>; Sun, 25 Jan 2026 14:00:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769378410; x=1769983210;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c9S53m72aeK7wWFA8nW3hX1G1HDIlPStUh0DaWAejB8=;
        b=qquHfPrws1Qwu/U6NBP8i69nEbYnFsKialgnH4Xdqtu7Sz1VJ1OQlhKZSxlsNT3JH6
         m51DSYrj6EARaRMWW3JTQZe0Wx0xIioYrL6B8O2v4jLApWoQvsI05qA4/wB/AOCF/z88
         8v5eEkZHYtgQ4U9NwVH/5zQ+pff3K0FKIS6v9YlzTb/gAYh61FxXbSpm3+ALdJu1WfsP
         dhDqfIY+TM8f86HGrhk1t9IUI70Vxh/J8un4LlKe5SwHg2JYQIDZM7R8r2Q7vn+4/7jK
         XfM6iYXIiMiHVKz5vif1rClYlRm6w9MafAq2XVVsg6VlMoClRby9LLMxxji6SwkZObEf
         m5Lw==
X-Gm-Message-State: AOJu0YwMGo+rFs79vkS4SMQcv2/VgkiPCq0hoQRd4TrIgYvtKckMvtsW
	lzMJOBYQw++lH5hfAPdtdvXWqJRAf+1AfYztdAnDDKB1hC6mx84hpCaR9rmDh/j4Fj7pSHEtZr4
	3vjaeKDYUje+z4Rfkl9s7yk3qr3kQC8Dc/2EiA1WgLCv+l8YRonvP2UjzzuM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1620:b0:662:c3d7:460d with SMTP id
 006d021491bc7-662e04d00b4mr1224900eaf.81.1769378410251; Sun, 25 Jan 2026
 14:00:10 -0800 (PST)
Date: Sun, 25 Jan 2026 14:00:10 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6976926a.050a0220.226181.0010.GAE@google.com>
Subject: [moderation/CI] Re: mm, swap: swap table phase III: remove swap_map
From: syzbot ci <syzbot+ci5ec449260bbe2ead@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm, swap: swap table phase III: remove swap_map
https://lore.kernel.org/all/20260126-swap-table-p3-v1-0-a74155fab9b0@tencen=
t.com
* [PATCH 01/12] mm, swap: protect si->swap_file properly and use as a mount=
 indicator
* [PATCH 02/12] mm, swap: clean up swapon process and locking
* [PATCH 03/12] mm, swap: remove redundant arguments and locking for enabli=
ng a device
* [PATCH 04/12] mm, swap: consolidate bad slots setup and make it more robu=
st
* [PATCH 05/12] mm/workingset: leave highest bits empty for anon shadow
* [PATCH 06/12] mm, swap: implement helpers for reserving data in the swap =
table
* [PATCH 07/12] mm, swap: mark bad slots in swap table directly
* [PATCH 08/12] mm, swap: simplify swap table sanity range check
* [PATCH 09/12] mm, swap: use the swap table to track the swap count
* [PATCH 10/12] mm, swap: no need to truncate the scan border
* [PATCH 11/12] mm, swap: simplify checking if a folio is swapped
* [PATCH 12/12] mm, swap: no need to clear the shadow explicitly

and found the following issue:
WARNING in swap_cluster_lock

Full report is available here:
https://ci.syzbot.org/series/3f6169fc-e24a-4a19-ba56-e5907b448edc

***

WARNING in swap_cluster_lock

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      5a3704ed2dce0b54a7f038b765bb752b87ee8cc2
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0eabd97a-86d8-4606-9d94-dbe4e7fd7c0=
7/config
C repro:   https://ci.syzbot.org/findings/5b039fd0-70da-4954-817d-8bf86315c=
684/c_repro
syz repro: https://ci.syzbot.org/findings/5b039fd0-70da-4954-817d-8bf86315c=
684/syz_repro

------------[ cut here ]------------
offset >=3D si->max
WARNING: mm/swap.h:88 at __swap_offset_to_cluster mm/swap.h:88 [inline], CP=
U#1: syz.0.548/6508
WARNING: mm/swap.h:88 at __swap_cluster_lock mm/swap.h:101 [inline], CPU#1:=
 syz.0.548/6508
WARNING: mm/swap.h:88 at swap_cluster_lock+0xef/0x130 mm/swap.h:132, CPU#1:=
 syz.0.548/6508
Modules linked in:
CPU: 1 UID: 0 PID: 6508 Comm: syz.0.548 Not tainted syzkaller #0 PREEMPT(fu=
ll)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__swap_offset_to_cluster mm/swap.h:88 [inline]
RIP: 0010:__swap_cluster_lock mm/swap.h:101 [inline]
RIP: 0010:swap_cluster_lock+0xef/0x130 mm/swap.h:132
Code: e8 86 3b 5a 09 4c 89 f8 5b 41 5c 41 5e 41 5f 5d e9 86 86 5a 09 cc e8 =
90 ff a0 ff 90 0f 0b 90 e9 3f ff ff ff e8 82 ff a0 ff 90 <0f> 0b 90 e9 6f f=
f ff ff e8 74 ff a0 ff 90 0f 0b 90 eb a4 e8 69 ff
RSP: 0018:ffffc90004ae66c0 EFLAGS: 00010293
RAX: ffffffff82219a6e RBX: 0000000000007a12 RCX: ffff888110363a80
RDX: 0000000000000000 RSI: 0000000000007a12 RDI: 0000000000007a12
RBP: 0000000000007a12 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff5200095cccc R12: dffffc0000000000
R13: ffff888175c2a010 R14: ffff888175c2a000 R15: 0000000000007a12
FS:  000055556978b500(0000) GS:ffff8882a9923000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fca0a017dac CR3: 0000000112e64000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 cluster_alloc_swap_entry+0x20f/0xa40 mm/swapfile.c:1090
 swap_alloc_slow mm/swapfile.c:1385 [inline]
 folio_alloc_swap+0x81f/0x1190 mm/swapfile.c:1717
 shrink_folio_list+0x2714/0x52b0 mm/vmscan.c:1306
 reclaim_folio_list+0x100/0x4f0 mm/vmscan.c:2205
 reclaim_pages+0x45b/0x530 mm/vmscan.c:2242
 madvise_cold_or_pageout_pte_range+0x19b9/0x1d00 mm/madvise.c:561
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x1032/0x1d30 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:411
 walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:715
 madvise_pageout_page_range mm/madvise.c:620 [inline]
 madvise_pageout mm/madvise.c:645 [inline]
 madvise_vma_behavior+0x382e/0x4240 mm/madvise.c:1364
 madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1719
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1935
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2028
 __do_sys_madvise mm/madvise.c:2037 [inline]
 __se_sys_madvise mm/madvise.c:2035 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2035
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fca09d9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe78abed08 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007fca0a015fa0 RCX: 00007fca09d9acb9
RDX: 0000000000000015 RSI: 0000000000600003 RDI: 0000200000000000
RBP: 00007fca09e08bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fca0a015fac R14: 00007fca0a015fa0 R15: 00007fca0a015fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org baohua@kernel.org bhe@redhat.com chrisl@kernel.o=
rg david@kernel.org hannes@cmpxchg.org kasong@tencent.com linux-kernel@vger=
.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com nphamcs@gmail.com=
 ryncsn@gmail.com shikemeng@huaweicloud.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

