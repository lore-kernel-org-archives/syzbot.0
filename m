Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B09C3090CD
	for <syzbot@lists.linux.dev>; Wed, 25 Mar 2026 22:31:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774477903; cv=none; b=mOg1kPf4Rube+o3RIK4NhqfoHvwU3PIUn9ZMYh4bO9+knj3FhoX+hvcE7J5Mqxmvmeo4zQFqj5vb/lFtkZU4bkyDe+ilMPgJAuYORFUCFabltkpTzNDMtLb6mUaeXzxJ8TgUA96DYudvFRVOo9yOJ2Q01yQgCIhH1sCdzccLonU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774477903; c=relaxed/simple;
	bh=mINNKYk0EfJWyxSdGZ1FB2rNt9WVPqzXq3B17mqJRks=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=F0DL7IfgpAIO9CDhQrFKKBk9mbl1A9BQjzmRa+SUqnx46FpwrNe2Jpluy8p1/nt5Aj6HyB/JcuIBBAxVGzfos2hU9tW5/g2ICqHVSlESNvcajnycyYhI5XmB+krrGaWKcfxUpNYNc76bQLGouqmAWE/Na5N4r+Kar19pBAvW2h8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-467ec73eec1so623201b6e.1
        for <syzbot@lists.linux.dev>; Wed, 25 Mar 2026 15:31:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774477901; x=1775082701;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=JZ9SXlmKCycnyt8gRpfGejFTYoA5s/x79Ij7AgJMLL4=;
        b=cPLwJutbUEZsGsoDTz58XFw3HXNBy6nZFfgNwrsNZMf01cFijx2HhKJ3GqhbggGFH4
         4B80wj5NfAsBk/6yaEMzowWUisAbKVHdRNh1cdD92bubbB/1Fp8XkuJcID0RiPnA2eGS
         vdLAEpkZEgO/zK3jtf4RJmYJFj/g+j/sYRZ3bBAzLYm9/7NRmutOwKCah04w/r9tk1m7
         vTQI9sWbBcn0SP2F+0mi+Syfr3mcGvzPLnIOA9wvWvqtwGjkjo090Z+yP3tXcGO3rTdW
         xlq9Tr3vf2rhgPxqusUiX6tBUpkapmQrInaW98CfiHxdaYPzqJfDz3COKLhcOTQPFH/Z
         5a7Q==
X-Gm-Message-State: AOJu0YzJl6CfOWfGn7Y1rrnIpuUdqlRffunS719sM2NTkOjsi+5HUiJQ
	B1mvwouNJLrVgY7oeKkxDlUyHL2z9ebrOKF7cVNaolFwMJjWeDrPtCVvY87raRm5c8Q1QD09+Be
	kSUIkDca0z+IOn8uxPzXhKahdXQmW5DlFjD8jfkUGolQeU3M/GztDLYi0Dfc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:174b:b0:67d:f88f:d83d with SMTP id
 006d021491bc7-67dff519dedmr2699742eaf.29.1774477901310; Wed, 25 Mar 2026
 15:31:41 -0700 (PDT)
Date: Wed, 25 Mar 2026 15:31:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c4624d.a70a0220.234938.005b.GAE@google.com>
Subject: [moderation/CI] Re: mm/swap, memcg: Introduce swap tiers for cgroup
 based swap control
From: syzbot ci <syzbot+ci5c12489340ca0fe3@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] mm/swap, memcg: Introduce swap tiers for cgroup based swap control
https://lore.kernel.org/all/20260325175453.2523280-1-youngjun.park@lge.com
* [PATCH v5 1/4] mm: swap: introduce swap tier infrastructure
* [PATCH v5 2/4] mm: swap: associate swap devices with tiers
* [PATCH v5 3/4] mm: memcontrol: add interfaces for swap tier selection
* [PATCH v5 4/4] mm: swap: filter swap allocation by memcg tier mask

and found the following issue:
WARNING in folio_tier_effective_mask

Full report is available here:
https://ci.syzbot.org/series/6ed50ca2-a106-41e9-aa4d-7c46869e0011

***

WARNING in folio_tier_effective_mask

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      6381a729fa7dda43574d93ab9c61cec516dd885b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/e5c66fa8-a7fd-4809-9564-448847b5f23=
0/config
C repro:   https://ci.syzbot.org/findings/d64cc6fa-636a-40a0-b131-d02ce1129=
494/c_repro
syz repro: https://ci.syzbot.org/findings/d64cc6fa-636a-40a0-b131-d02ce1129=
494/syz_repro

------------[ cut here ]------------
debug_locks && !(rcu_read_lock_held() || lock_is_held(&(&cgroup_mutex)->dep=
_map))
WARNING: ./include/linux/memcontrol.h:377 at obj_cgroup_memcg include/linux=
/memcontrol.h:377 [inline], CPU#1: syz.0.17/5955
WARNING: ./include/linux/memcontrol.h:377 at folio_memcg include/linux/memc=
ontrol.h:431 [inline], CPU#1: syz.0.17/5955
WARNING: ./include/linux/memcontrol.h:377 at folio_tier_effective_mask+0x17=
5/0x210 mm/swap_tier.h:63, CPU#1: syz.0.17/5955
Modules linked in:
CPU: 1 UID: 0 PID: 5955 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:obj_cgroup_memcg include/linux/memcontrol.h:377 [inline]
RIP: 0010:folio_memcg include/linux/memcontrol.h:431 [inline]
RIP: 0010:folio_tier_effective_mask+0x175/0x210 mm/swap_tier.h:63
Code: 0f b6 04 20 84 c0 75 6b 8b 03 eb 0a e8 04 b8 9e ff b8 ff ff ff ff 5b =
41 5c 41 5e 41 5f 5d c3 cc cc cc cc cc e8 ec b7 9e ff 90 <0f> 0b 90 eb 9b 4=
4 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c c2 fe ff ff
RSP: 0018:ffffc90004bee6d0 EFLAGS: 00010293
RAX: ffffffff8226dd04 RBX: ffff888113589280 RCX: ffff8881727b8000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffffea0006c62207 R09: 1ffffd4000d8c440
R10: dffffc0000000000 R11: fffff94000d8c441 R12: dffffc0000000000
R13: ffffea0006c62208 R14: ffffea0006c62200 R15: ffffea0006c62230
FS:  00005555771cb500(0000) GS:ffff8882a9462000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2ed63fff CR3: 0000000112d86000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 swap_alloc_fast mm/swapfile.c:1355 [inline]
 folio_alloc_swap+0x392/0x13a0 mm/swapfile.c:1735
 shrink_folio_list+0x26a7/0x5250 mm/vmscan.c:1281
 reclaim_folio_list+0x100/0x460 mm/vmscan.c:2171
 reclaim_pages+0x45b/0x530 mm/vmscan.c:2208
 madvise_cold_or_pageout_pte_range+0x1ef5/0x2220 mm/madvise.c:563
 walk_pmd_range mm/pagewalk.c:142 [inline]
 walk_pud_range mm/pagewalk.c:233 [inline]
 walk_p4d_range mm/pagewalk.c:275 [inline]
 walk_pgd_range+0xfdc/0x1d90 mm/pagewalk.c:316
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:424
 walk_page_range_vma_unsafe+0x309/0x410 mm/pagewalk.c:728
 madvise_pageout_page_range mm/madvise.c:622 [inline]
 madvise_pageout mm/madvise.c:647 [inline]
 madvise_vma_behavior+0x28b9/0x42c0 mm/madvise.c:1358
 madvise_walk_vmas+0x573/0xae0 mm/madvise.c:1713
 madvise_do_behavior+0x386/0x540 mm/madvise.c:1929
 do_madvise+0x1fa/0x2e0 mm/madvise.c:2022
 __do_sys_madvise mm/madvise.c:2031 [inline]
 __se_sys_madvise mm/madvise.c:2029 [inline]
 __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2029
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5e5af9c799
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff0c8e2708 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f5e5b215fa0 RCX: 00007f5e5af9c799
RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007f5e5b032c99 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5e5b215fac R14: 00007f5e5b215fa0 R15: 00007f5e5b215fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org baohua@kernel.org bhe@redhat.com cgroups@vger.ke=
rnel.org chrisl@kernel.org gunho.lee@lge.com hannes@cmpxchg.org hyungjun.ch=
o@lge.com kasong@tencent.com linux-kernel@vger.kernel.org linux-mm@kvack.or=
g mhocko@kernel.org mkoutny@suse.com muchun.song@linux.dev nphamcs@gmail.co=
m roman.gushchin@linux.dev shakeel.butt@linux.dev shikemeng@huaweicloud.com=
 taejoon.song@lge.com youngjun.park@lge.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

