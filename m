Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEE36221F15
	for <syzbot@lists.linux.dev>; Thu, 16 Oct 2025 16:23:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760631837; cv=none; b=Nn6ZEvlF1vXCebkswHgdbXi4b77M1sDMD6KbEaFZZXkfX4RwE+cjJZAACPIuWipzIR28xfdrPLf4JSZNlcsg58UZojmM3lvpVeSCNsfU3A0N7g4n62zHZuQHX5Or5W672hYUMMOV+S5g3s5g2dk1XyJmwFkgKivkW5NNl436DXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760631837; c=relaxed/simple;
	bh=HGQwj7krlOPJq3Cw4uxlTKzIBnqQCLlUFHtFmeVzU+c=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=egy8Hze3wMS4MQ670GuYhVcJ29CrAnOEGO7Y6Bl+FA6l6eMIPV+Pf+XrbxRpDRseSAkD73CH45m8ndvEJdgBgwY4w/lncXtVY3GilrMI9X1Dd95+Vzh7bYUznsSLhO6XcjlHbiDmBLgkp2W70+SQygZ9v6VMxFVUYeQjFdend6c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-42f8824b65fso26015355ab.2
        for <syzbot@lists.linux.dev>; Thu, 16 Oct 2025 09:23:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760631835; x=1761236635;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=uH9ncuVNWrmpKccRdCmFgVg8gN7Sa+FrJMkcgErOzbI=;
        b=UzbMz9nhW8guosAZkozY6EBTEUmUFbIWnqMqKQ0lMWF+Nw2QVNuV7YJRN7M8bugGKJ
         arC78CVHMh2O0egSqwszUe3006SbkQjjFKjsVsELFsExHDZcTtg4+MTOm7D5lBcWPBC6
         MDwh0chxujQvdC5/ePqWCNwOwRaxDqf85PR7YzIcmFrup3zDqX2iyvXCc/W/N8HHMzhd
         Q7vBB9WDofZf2d/bxNrR8Q2de0j9b/sgc0SjjN2740rIV6lMZQLuiNAg+HiWHyPXxj6O
         AywWFPgAZFTnVKSPCEkn+6LooNwoMPmOrZ3XJiddz/tPqieGKRyhB8erNzFTSerXqHTU
         68VA==
X-Gm-Message-State: AOJu0YwGywNyEUBION1ncqVHmOsWC2vJjYsLnkoAg9iSuN4wKLhv0CWa
	auM2l3xLvfIscd/CGBQQjYoZHc8xkDCntAVgwFAnGWBfjgHZSHAUCncZky1/W5lEtVpKCUTsCvR
	mX/Wa2Dr3IpN5JvQnI5qhBkhViWdj8B0iKXYvZWwDW3oke4JBpbmB9eTSw38=
X-Google-Smtp-Source: AGHT+IF0mVeBbeh6pgt7i0/MkOWl7EBWMggnxuS/B6V6XUo6s2UTse3jty2HFSlMCH44YjluTZGifEjNeS3+6UR8CA7xp8eCe2kH
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:148d:b0:430:b167:3604 with SMTP id
 e9e14a558f8ab-430c5209bafmr12878615ab.4.1760631834789; Thu, 16 Oct 2025
 09:23:54 -0700 (PDT)
Date: Thu, 16 Oct 2025 09:23:54 -0700
In-Reply-To: <20251016112704.179280-1-yintirui@huawei.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f11c1a.050a0220.91a22.0411.GAE@google.com>
Subject: [syzbot ci] Re: mm: add huge pfnmap support for remap_pfn_range()
From: syzbot ci <syzbot+ci290b7e46a3349a6e@syzkaller.appspotmail.com>
To: abrestic@rivosinc.com, akpm@linux-foundation.org, alex@ghiti.fr, 
	anshuman.khandual@arm.com, aou@eecs.berkeley.edu, apopple@nvidia.com, 
	ardb@kernel.org, baohua@kernel.org, baolin.wang@linux.alibaba.com, 
	catalin.marinas@arm.com, chenjun102@huawei.com, david@redhat.com, 
	dev.jain@arm.com, liam.howlett@oracle.com, 
	linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, linux-riscv@lists.infradead.org, 
	lorenzo.stoakes@oracle.com, luxu.kernel@bytedance.com, mhocko@suse.com, 
	npache@redhat.com, palmer@dabbelt.com, paul.walmsley@sifive.com, 
	rppt@kernel.org, ryan.roberts@arm.com, samuel.holland@sifive.com, 
	surenb@google.com, vbabka@suse.cz, wangkefeng.wang@huawei.com, 
	will@kernel.org, willy@infradead.org, yangyicong@hisilicon.com, 
	yintirui@huawei.com, yongxuan.wang@sifive.com, ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] mm: add huge pfnmap support for remap_pfn_range()
https://lore.kernel.org/all/20251016112704.179280-1-yintirui@huawei.com
* [PATCH RFC 1/2] pgtable: add pte_clrhuge() implementation for arm64 and riscv
* [PATCH RFC 2/2] mm: add PMD-level huge page support for remap_pfn_range()

and found the following issue:
stack segment fault in pgtable_trans_huge_withdraw

Full report is available here:
https://ci.syzbot.org/series/d04c2914-0d99-4132-89d4-899e22abf904

***

stack segment fault in pgtable_trans_huge_withdraw

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      3a8660878839faadb4f1a6dd72c3179c1df56787
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/9d7864e5-ad3a-4c0d-b21d-86cfc476792e/config
C repro:   https://ci.syzbot.org/findings/b9fca361-413d-4db1-b8b2-1849cd2c50dd/c_repro
syz repro: https://ci.syzbot.org/findings/b9fca361-413d-4db1-b8b2-1849cd2c50dd/syz_repro

Oops: stack segment: 0000 [#1] SMP KASAN PTI
CPU: 0 UID: 0 PID: 5968 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:pgtable_trans_huge_withdraw+0x115/0x310 mm/pgtable-generic.c:188
Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 9d e9 13 00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00 00 74 08 4c 89 ff e8 7b e9 13 00 49 8b 07 48 8d 48
RSP: 0018:ffffc90003717300 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffea00044848d0 RCX: ffff88816c890000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff88816db66a23 R09: 1ffff1102db6cd44
R10: dffffc0000000000 R11: ffffed102db6cd45 R12: ffff888112123000
R13: dffffc0000000000 R14: ffff888112123000 R15: 0000000000000008
FS:  000055556cb5f500(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000000
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
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
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
Code: c3 10 48 89 d8 48 c1 e8 03 42 80 3c 28 00 74 08 48 89 df e8 9d e9 13 00 48 8b 03 48 89 04 24 4c 8d 78 08 4c 89 fd 48 c1 ed 03 <42> 80 7c 2d 00 00 74 08 4c 89 ff e8 7b e9 13 00 49 8b 07 48 8d 48
RSP: 0018:ffffc90003717300 EFLAGS: 00010202
RAX: 0000000000000000 RBX: ffffea00044848d0 RCX: ffff88816c890000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffff88816db66a23 R09: 1ffff1102db6cd44
R10: dffffc0000000000 R11: ffffed102db6cd45 R12: ffff888112123000
R13: dffffc0000000000 R14: ffff888112123000 R15: 0000000000000008
FS:  000055556cb5f500(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000000
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
* 2a:	42 80 7c 2d 00 00    	cmpb   $0x0,0x0(%rbp,%r13,1) <-- trapping instruction
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
