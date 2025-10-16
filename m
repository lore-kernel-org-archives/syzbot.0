Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B651E32D0CA
	for <syzbot@lists.linux.dev>; Thu, 16 Oct 2025 16:01:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760630487; cv=none; b=e9p3VaQnKdR0IXXt4xcjDbGz8GR1Js93IG0Q5qvcm4P7GDoKh9egKJbd3SsRWFpi04KO8peiENwDkEfnkSXBqPBjmIxjPmxXHAQmG06p+0OpFAPaTP9GuSE6Izv8h9zC7uSMrv9BW07cIs/kLSjAIwXuX571eJyp66lXgekcpew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760630487; c=relaxed/simple;
	bh=KPgnmmj/gDY2XLNJiQbcwcH/4J8hegf+mBh0P/reWpU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Ch5vyemLzJod8p99W4DjvvW9gu+kxM0hY1JQtDmWHTA+WMITwRyv753ejVDJtj+3N6mygCdpQWTG7mreuuGSPKTgwoi0ofss15skwBs/oYzGGGATCefCq1UGtpVM06VLOjJvn3xQ7+mcpf0+wG+pLjQymkWeIhInaS5OGse3LkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-42a076e4f9eso10906385ab.1
        for <syzbot@lists.linux.dev>; Thu, 16 Oct 2025 09:01:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760630484; x=1761235284;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=c1aVEPAkZrjRwXzC5FnilETPujGZYn/5PH3BO/J2wfc=;
        b=dRs6RK5LM1kSrNJefZ6N9piLGncRxY/Ak4zEd4rIUSBf1nuUPm5fIJEUlGZj2wao/H
         Iegej9OWMjqTkSD2bDbPcpll85YVTlU2gxowLDNS1wDRWCe1ZiPQrQlvLiWosJ6ykVpF
         ++mo0TfPPaac/LyLtuJSy8bNoqNTK1xuAWkPTms2umaU+4XL8MVQWN04IbcwJa0rOxbh
         8+jPRmoH+M43KfP9cKnHgvzGNR9PZe87KaWzzYsSzDLWc5gzBUBvhJVYA081QQTJVNKz
         KaTiAAP6EjfLmiT+y3DfBaW2dqMhI0zNrdNHpmeUQVe5gfnFXF6gCfixhG2vXgV/Jy5/
         nRVg==
X-Gm-Message-State: AOJu0YyPr7OcRkOlnduhGbtqijDqnYl34gxBUF5Pf+uPwj+c227jjpFu
	EJUxRYtFll52vquA1atTolWWa4Dgrf2gKgMCIuW7v9H6kixSZT66S8ULoqclaumQOTlZ/iC+DOQ
	jSdAkBvDiHKHLmtmDjZ3Qk32ykx47anAql10dqjL6Qhq9P72eYYmB0XlQlQY=
X-Google-Smtp-Source: AGHT+IG0Dm9q/EvBx7+51RjmfbguQkQXOuA7Q1vshDsBUNvhtosyo0Qnc038UdDRVQjOfbnf+5/rNbMtPooBAiAglIXM04jiIaGR
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:156c:b0:430:ad98:981f with SMTP id
 e9e14a558f8ab-430c524b96bmr10717395ab.4.1760630483802; Thu, 16 Oct 2025
 09:01:23 -0700 (PDT)
Date: Thu, 16 Oct 2025 09:01:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f116d3.050a0220.91a22.0410.GAE@google.com>
Subject: [moderation/CI] Re: mm: add huge pfnmap support for remap_pfn_range()
From: syzbot ci <syzbot+ci78f39f7f9c183deb@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] mm: add huge pfnmap support for remap_pfn_range()
https://lore.kernel.org/all/20251016112704.179280-1-yintirui@huawei.com
* [PATCH RFC 1/2] pgtable: add pte_clrhuge() implementation for arm64 and r=
iscv
* [PATCH RFC 2/2] mm: add PMD-level huge page support for remap_pfn_range()

and found the following issue:
stack segment fault in pgtable_trans_huge_withdraw

Full report is available here:
https://ci.syzbot.org/series/d04c2914-0d99-4132-89d4-899e22abf904

***

stack segment fault in pgtable_trans_huge_withdraw

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      3a8660878839faadb4f1a6dd72c3179c1df56787
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/9d7864e5-ad3a-4c0d-b21d-86cfc476792=
e/config
C repro:   https://ci.syzbot.org/findings/b9fca361-413d-4db1-b8b2-1849cd2c5=
0dd/c_repro
syz repro: https://ci.syzbot.org/findings/b9fca361-413d-4db1-b8b2-1849cd2c5=
0dd/syz_repro

Oops: stack segment: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5968 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:pgtable_trans_huge_withdraw+0x115/0x310 mm/pgtable-generic.c:188
Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 9d e9 13 =
00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00 0=
0 74 08 4c 89 ff e8 7b e9 13 00 49 8b 07 48 8d 48
RSP: 0018:ffffc90003717300 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffea00044848d0 RCX: ffff88816c890000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff88816db66a23 R09: 1ffff1102db6cd44
R10: dffffc0000000000 R11: ffffed102db6cd45 R12: ffff888112123000
R13: dffffc0000000000 R14: ffff888112123000 R15: 0000000000000008
FS:  000055556cb5f500(0000) GS:ffff88818e70c000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001102a4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 zap_deposited_table mm/huge_memory.c:2169 [inline]
 zap_huge_pmd+0xa25/0xf50 mm/huge_memory.c:2197
 zap_pmd_range mm/memory.c:1926 [inline]
 zap_pud_range mm/memory.c:1975 [inline]
 zap_p4d_range mm/memory.c:1996 [inline]
 unmap_page_range+0x9fe/0x4370 mm/memory.c:2017
 unmap_single_vma mm/memory.c:2060 [inline]
 unmap_vmas+0x399/0x580 mm/memory.c:2104
 exit_mmap+0x240/0xb40 mm/mmap.c:1280
 __mmput+0x118/0x430 kernel/fork.c:1133
 copy_process+0x2910/0x3c00 kernel/fork.c:2460
 kernel_clone+0x21e/0x840 kernel/fork.c:2609
 __do_sys_clone kernel/fork.c:2750 [inline]
 __se_sys_clone kernel/fork.c:2734 [inline]
 __x64_sys_clone+0x18b/0x1e0 kernel/fork.c:2734
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f946958eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc41c94258 EFLAGS: 00000206 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 00007f94697e5fa0 RCX: 00007f946958eec9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000002001000
RBP: 00007f9469611f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000206 R12: 0000000000000000
R13: 00007f94697e5fa0 R14: 00007f94697e5fa0 R15: 0000000000000006
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:pgtable_trans_huge_withdraw+0x115/0x310 mm/pgtable-generic.c:188
Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 9d e9 13 =
00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00 0=
0 74 08 4c 89 ff e8 7b e9 13 00 49 8b 07 48 8d 48
RSP: 0018:ffffc90003717300 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffea00044848d0 RCX: ffff88816c890000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff88816db66a23 R09: 1ffff1102db6cd44
R10: dffffc0000000000 R11: ffffed102db6cd45 R12: ffff888112123000
R13: dffffc0000000000 R14: ffff888112123000 R15: 0000000000000008
FS:  000055556cb5f500(0000) GS:ffff88818e70c000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 00000001102a4000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	c3                   	ret
   1:	10 48 89             	adc    %cl,-0x77(%rax)
   4:	d8 48 c1             	fmuls  -0x3f(%rax)
   7:	e8 03 42 80 3c       	call   0x3c80420f
   c:	28 00                	sub    %al,(%rax)
   e:	74 08                	je     0x18
  10:	48 89 df             	mov    %rbx,%rdi
  13:	e8 9d e9 13 00       	call   0x13e9b5
  18:	48 8b 03             	mov    (%rbx),%rax
  1b:	48 89 04 24          	mov    %rax,(%rsp)
  1f:	4c 8d 78 08          	lea    0x8(%rax),%r15
  23:	4c 89 fd             	mov    %r15,%rbp
  26:	48 c1 ed 03          	shr    $0x3,%rbp
* 2a:	42 80 7c 2d 00 00    	cmpb   $0x0,0x0(%rbp,%r13,1) <-- trapping instr=
uction
  30:	74 08                	je     0x3a
  32:	4c 89 ff             	mov    %r15,%rdi
  35:	e8 7b e9 13 00       	call   0x13e9b5
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

