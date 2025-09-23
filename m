Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6EF01D90C8
	for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 17:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758649155; cv=none; b=ikT1T+n/i+A/t+pWrWYfL/iVwYFpRZP55GHb2/2SevPcq7Kj4w7hKsLSMpmacSYLs/lrWSdRrvmCkoo4R0mZNOfluAP6Wd4LRuXSmHdGKNaqD3W5NdJXgjpn4b6kVdbV5U/iruav2RPMijSp5lJIWNC+BY+xMIFBn8OnIuNc2SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758649155; c=relaxed/simple;
	bh=BCaPhLrcXSi9jiSRUjhjK0ovPKCKJLb68N0QflTHE00=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=LmTh8QYbsYry3Y/YjXHt7NZb/+kwQqdv+9qFJBlWR7ZG3gyrtnkTD6Ayvfo70Z2s8C2gD0zlYMnSUyCkV6f113o6Y0AAUuEGG+QXdUCSm7X/IRd1fO66xbxbiSqwHJ55qBADznPia7jK27aVIKoaFkkV+To7PzZsclKIR6/sqdo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-4248d44a345so49136675ab.1
        for <syzbot@lists.linux.dev>; Tue, 23 Sep 2025 10:39:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758649153; x=1759253953;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OvqTgf66zVuTXrcxI5E6vLm4XZvir8W/kqzO3cj5rik=;
        b=V2tbxUGTfFpBMIIjOW9Cc8PnYIGj4Iin40t6GPHoaim1NmKPnG63YlxXajKvY5FUIq
         N4W/4NroVgEP0FBp8XCCrozrM1aTZUVBmIjRWJnWgzhzwwkSlWa+rTme7lvFgHJT2Idr
         Snp9mAheLQdlTfPCmK+2jNXaxwLHIy+R0oF38D4f01lsZXpqBCVJ/AI+BAuXbjEgrCzf
         xjnfHeo2axZYwEQ+GBm957QPLW3wRDQWiIDeqhkZRerbBp6hiLEByqkrCVTl3mKkXALV
         dkiYE0uX5qqpRpVW4EB+Ttgz8u90pecBoi6/vE83WUlxXLfBSMFl12aI8920cUzHsv49
         gUYA==
X-Gm-Message-State: AOJu0YwZoyCxTclE0RiRXkFWg40aXuVXxC6Cnxc2D0ApkWbhzW88Tv0P
	GdRG7fN+lDfC1dS0+YEhKcshHbsb7bUka+ilIKFjodD9+y6ZCnWsBfguaumbcsMjAv1A8qWbHOt
	j/+IcHShikBvC2cA0xAQgYbwT67bkKlHmzsS+vcfQcm8QldpeNnsc2gbW/30=
X-Google-Smtp-Source: AGHT+IGYTggVkcrp7olN64qjw+TfrGJW0HPsyo7Rw2upgsqGyl2QPN7lggOM2BxL+MPwiHfDmJJFqFBO6x2nWCeAaO0f47O0iHY2
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4819:b0:425:8442:5c28 with SMTP id
 e9e14a558f8ab-42584425ee1mr37111845ab.11.1758649152948; Tue, 23 Sep 2025
 10:39:12 -0700 (PDT)
Date: Tue, 23 Sep 2025 10:39:12 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d2db40.050a0220.139b6.0028.GAE@google.com>
Subject: [moderation/CI] Re: mm: add huge pfnmap support for remap_pfn_range()
From: syzbot ci <syzbot+cia40ee1d2dcc6b717@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm: add huge pfnmap support for remap_pfn_range()
https://lore.kernel.org/all/20250923133104.926672-1-yintirui@huawei.com
* [PATCH RFC 1/2] pgtable: add pte_clrhuge() implementation for arm64 and r=
iscv
* [PATCH RFC 2/2] mm: add PMD-level huge page support for remap_pfn_range()

and found the following issues:
* BUG: non-zero pgtables_bytes on freeing mm: NUM
* stack segment fault in pgtable_trans_huge_withdraw

Full report is available here:
https://ci.syzbot.org/series/633cbff7-ef54-4f3a-9133-71cc271396ee

***

BUG: non-zero pgtables_bytes on freeing mm: NUM

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      07e27ad16399afcd693be20211b0dfae63e0615f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/72b4b6cf-5400-40d6-94b6-1cfc0e85050=
d/config
C repro:   https://ci.syzbot.org/findings/3450ef75-3540-4c00-8b33-5625d4aa4=
0ef/c_repro
syz repro: https://ci.syzbot.org/findings/3450ef75-3540-4c00-8b33-5625d4aa4=
0ef/syz_repro

BUG: non-zero pgtables_bytes on freeing mm: 4096


***

stack segment fault in pgtable_trans_huge_withdraw

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      07e27ad16399afcd693be20211b0dfae63e0615f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/72b4b6cf-5400-40d6-94b6-1cfc0e85050=
d/config
C repro:   https://ci.syzbot.org/findings/dcfb72b5-c263-48da-830a-7f51aaa92=
7db/c_repro
syz repro: https://ci.syzbot.org/findings/dcfb72b5-c263-48da-830a-7f51aaa92=
7db/syz_repro

Oops: stack segment: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 6000 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:pgtable_trans_huge_withdraw+0x115/0x310 mm/pgtable-generic.c:188
Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 5d 38 13 =
00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00 0=
0 74 08 4c 89 ff e8 3b 38 13 00 49 8b 07 48 8d 48
RSP: 0018:ffffc90002d5f300 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffea0000fb3dd0 RCX: ffff888107769cc0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff888022b90843 R09: 1ffff11004572108
R10: dffffc0000000000 R11: ffffed1004572109 R12: ffff88803ecf7000
R13: dffffc0000000000 R14: ffff88803ecf7000 R15: 0000000000000008
FS:  0000555576e7a500(0000) GS:ffff8880b8612000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000107d74000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 zap_deposited_table mm/huge_memory.c:2177 [inline]
 zap_huge_pmd+0xa25/0xf50 mm/huge_memory.c:2205
 zap_pmd_range mm/memory.c:1798 [inline]
 zap_pud_range mm/memory.c:1847 [inline]
 zap_p4d_range mm/memory.c:1868 [inline]
 unmap_page_range+0x9fe/0x4370 mm/memory.c:1889
 unmap_single_vma mm/memory.c:1932 [inline]
 unmap_vmas+0x399/0x580 mm/memory.c:1976
 exit_mmap+0x248/0xb50 mm/mmap.c:1280
 __mmput+0x118/0x430 kernel/fork.c:1129
 copy_process+0x2910/0x3c00 kernel/fork.c:2454
 kernel_clone+0x21e/0x840 kernel/fork.c:2605
 __do_sys_clone kernel/fork.c:2748 [inline]
 __se_sys_clone kernel/fork.c:2732 [inline]
 __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2732
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f96b638ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc07e618c8 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007f96b65d5fa0 RCX: 00007f96b638ec29
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000002001000
RBP: 00007f96b6411e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 00007f96b65d5fa0 R14: 00007f96b65d5fa0 R15: 0000000000000006
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:pgtable_trans_huge_withdraw+0x115/0x310 mm/pgtable-generic.c:188
Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 5d 38 13 =
00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00 0=
0 74 08 4c 89 ff e8 3b 38 13 00 49 8b 07 48 8d 48
RSP: 0018:ffffc90002d5f300 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffea0000fb3dd0 RCX: ffff888107769cc0
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff888022b90843 R09: 1ffff11004572108
R10: dffffc0000000000 R11: ffffed1004572109 R12: ffff88803ecf7000
R13: dffffc0000000000 R14: ffff88803ecf7000 R15: 0000000000000008
FS:  0000555576e7a500(0000) GS:ffff8880b8612000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000107d74000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	c3                   	ret
   1:	10 48 89             	adc    %cl,-0x77(%rax)
   4:	d8 48 c1             	fmuls  -0x3f(%rax)
   7:	e8 03 42 80 3c       	call   0x3c80420f
   c:	28 00                	sub    %al,(%rax)
   e:	74 08                	je     0x18
  10:	48 89 df             	mov    %rbx,%rdi
  13:	e8 5d 38 13 00       	call   0x133875
  18:	48 8b 03             	mov    (%rbx),%rax
  1b:	48 89 04 24          	mov    %rax,(%rsp)
  1f:	4c 8d 78 08          	lea    0x8(%rax),%r15
  23:	4c 89 fd             	mov    %r15,%rbp
  26:	48 c1 ed 03          	shr    $0x3,%rbp
* 2a:	42 80 7c 2d 00 00    	cmpb   $0x0,0x0(%rbp,%r13,1) <-- trapping instr=
uction
  30:	74 08                	je     0x3a
  32:	4c 89 ff             	mov    %r15,%rdi
  35:	e8 3b 38 13 00       	call   0x133875
  3a:	49 8b 07             	mov    (%r15),%rax
  3d:	48                   	rex.W
  3e:	8d                   	.byte 0x8d
  3f:	48                   	rex.W


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[abrestic@rivosinc.com akpm@linux-foundation.org alex@ghiti.fr anshuman.kha=
ndual@arm.com aou@eecs.berkeley.edu apopple@nvidia.com ardb@kernel.org baoh=
ua@kernel.org baolin.wang@linux.alibaba.com catalin.marinas@arm.com chenjun=
102@huawei.com david@redhat.com dev.jain@arm.com liam.howlett@oracle.com li=
nux-arm-kernel@lists.infradead.org linux-kernel@vger.kernel.org linux-mm@kv=
ack.org linux-riscv@lists.infradead.org lorenzo.stoakes@oracle.com luxu.ker=
nel@bytedance.com mhocko@suse.com npache@redhat.com palmer@dabbelt.com paul=
.walmsley@sifive.com rppt@kernel.org ryan.roberts@arm.com samuel.holland@si=
five.com surenb@google.com vbabka@suse.cz wangkefeng.wang@huawei.com will@k=
ernel.org willy@infradead.org yangyicong@hisilicon.com yintirui@huawei.com =
yongxuan.wang@sifive.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

