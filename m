Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCE5634CDD
	for <syzbot@lists.linux.dev>; Tue, 23 Dec 2025 16:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766507579; cv=none; b=SdRObmF2UkaNKD4PZLEUxbxXThuwfNAmrxm/x9DnnIIwcKPQECzfiGE+oqjoBZ1rzRJ6N0r/Zco0DngCflTItAjtFmqEh0pwo4ePnrs/akBScCwhFiFffryLZDs1/wkWo9uJPvkAzNgyVr+1kpg0v6+ObXtpkj/a+wn5elytda0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766507579; c=relaxed/simple;
	bh=Wh6YS5fQt1ufrB1zSueH26hRuXfJqRz7gt9jIQOoKo8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=GLYz+JELY8Fls0UrNbr1Ll0u60umv6VzDwoKQG5zrl3FX3muVfeNFmJKeoOVzmeQedFOTbe5KWg4y4HYY21kQ9LSL4/kfyKzMglJVNzh009az7d51pf6afyDWrgYjzs+eBMTuyT3X+30PYQj9+3nWuJePhO35a6StiKP61ZO+nk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-656b7cf5c66so7774713eaf.2
        for <syzbot@lists.linux.dev>; Tue, 23 Dec 2025 08:32:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766507577; x=1767112377;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Y7V1pRzIOfCS6tKRtAwb7N5EKbu3Q3ZA7hR4OE5Lk+w=;
        b=tDguxi4mZQYh7YqZc4E7euPzGmiRro6zSJmDEc1RiFvbPvkufmszfCtNqUN8YNpInP
         bRkdu7lrrmFZSRgOGPjAqRD+/XDrX80ZO7+U+QELDsggb8cPm3jzaX56XCNNqKHiXiL/
         CgQuQdeB1+hGIYVXz2VaoR6BR2GYdA66gSPKaEh6YxcdbO028zTD8TkpAMW9zqpeeoGT
         IkfNu3GWias47yimjEX96USVs/34RbZxyKsrlX+rplO2yt64S/5+BnoG2Th6mS2IjL1Z
         bscLFVMB5fprjj6eDjFeeoi/8576XxQ3pffeU3Fft6u87rh4n5lIGSamVTRY2rRqzpgo
         TfLQ==
X-Gm-Message-State: AOJu0Yy6+Qy00IC6Po+oaDTxaSwfSR/Yf75TFHUKol3jk8bdZVjkv01a
	3OPcd52OF0mQ0nwv9QcS5fwtXQIh2PAmbiDXQ+Zh00uDFPHZL31kzi4KEUdPTc59fwWFYct2VA5
	OgSlqezWLXqtvxKCMKi7YB3jboK95/E1TwcSyFqRw9fxAiXo/USIk+gkXtS0=
X-Google-Smtp-Source: AGHT+IG+3c3qpWFKSk55rh9moskRHilwsOO6gYBQo0XcXcy7VXrYc7wiOTJphrx6iwEL+Ji1DJSbfmOMfWOzFtbf9x2yQ8erfbc4
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:300f:b0:65d:13ce:26d7 with SMTP id
 006d021491bc7-65d13ce2ce5mr3525951eaf.29.1766507576726; Tue, 23 Dec 2025
 08:32:56 -0800 (PST)
Date: Tue, 23 Dec 2025 08:32:56 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <694ac438.050a0220.35954c.0000.GAE@google.com>
Subject: [moderation/CI] Re: mm/huge_memory: consolidate order-related checks
 into folio_check_splittable()
From: syzbot ci <syzbot+cicb26c25da0c5aac9@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] mm/huge_memory: consolidate order-related checks into folio_check_spli=
ttable()
https://lore.kernel.org/all/20251223122539.10726-1-richard.weiyang@gmail.co=
m
* [Patch v2] mm/huge_memory: consolidate order-related checks into folio_ch=
eck_splittable()

and found the following issue:
WARNING in __folio_split

Full report is available here:
https://ci.syzbot.org/series/7e34013d-ed08-40e1-99b7-8fd118dce84f

***

WARNING in __folio_split

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      c642ecda5b136882e518d8303863473c0d21ab2f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/2edb2dc5-42c6-4557-a194-921c57fd9eb=
1/config
C repro:   https://ci.syzbot.org/findings/8349b674-5790-4507-97cd-03697ec93=
cb0/c_repro
syz repro: https://ci.syzbot.org/findings/8349b674-5790-4507-97cd-03697ec93=
cb0/syz_repro

------------[ cut here ]------------
Tried to split an unsplittable folio
WARNING: mm/huge_memory.c:3970 at __folio_split+0xfe7/0x1370 mm/huge_memory=
.c:3970, CPU#1: syz.0.17/5997
Modules linked in:
CPU: 1 UID: 0 PID: 5997 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__folio_split+0xfe7/0x1370 mm/huge_memory.c:3970
Code: fe c6 05 a5 f8 3e 0d 01 90 0f 0b 90 e9 0d f4 ff ff e8 4d 78 94 ff 49 =
ff cd e9 d1 f4 ff ff e8 40 78 94 ff 48 8d 3d 69 47 5a 0d <67> 48 0f b9 3a 4=
1 bd ea ff ff ff e9 7c fe ff ff 44 89 7c 24 34 44
RSP: 0018:ffffc900036d6d60 EFLAGS: 00010293
RAX: ffffffff822d4360 RBX: ffffea0005a4b008 RCX: ffff8881047fd7c0
RDX: 0000000000000000 RSI: ffffffff8e06e540 RDI: ffffffff8f878ad0
RBP: ffffc900036d6ef0 R08: ffff8881047fd7c0 R09: 0000000000000002
R10: 00000000ffffffea R11: 0000000000000000 R12: 0000000000000004
R13: 00000000ffffffea R14: ffffea0005a4b000 R15: 1ffffd4000b49603
FS:  0000555591a60500(0000) GS:ffff8882a9e32000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30d63fff CR3: 0000000100f30000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 madvise_cold_or_pageout_pte_range+0xbf3/0x1ce0 mm/madvise.c:503
 walk_pmd_range mm/pagewalk.c:130 [inline]
 walk_pud_range mm/pagewalk.c:224 [inline]
 walk_p4d_range mm/pagewalk.c:262 [inline]
 walk_pgd_range+0x1037/0x1d30 mm/pagewalk.c:303
 __walk_page_range+0x14c/0x710 mm/pagewalk.c:410
 walk_page_range_vma_unsafe+0x34c/0x400 mm/pagewalk.c:714
 madvise_pageout_page_range mm/madvise.c:622 [inline]
 madvise_pageout mm/madvise.c:647 [inline]
 madvise_vma_behavior+0x30c7/0x4420 mm/madvise.c:1366
 madvise_walk_vmas+0x575/0xaf0 mm/madvise.c:1721
 madvise_do_behavior+0x38e/0x550 mm/madvise.c:1937
 do_madvise+0x1bc/0x270 mm/madvise.c:2030
 __do_sys_madvise mm/madvise.c:2039 [inline]
 __se_sys_madvise mm/madvise.c:2037 [inline]
 __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:2037
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff69838f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fff82001dd8 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007ff6985e5fa0 RCX: 00007ff69838f7c9
RDX: 0000000000000015 RSI: 0000000000600000 RDI: 0000200000000000
RBP: 00007ff6983f297f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff6985e5fa0 R14: 00007ff6985e5fa0 R15: 0000000000000003
 </TASK>
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	c6 05 a5 f8 3e 0d 01 	movb   $0x1,0xd3ef8a5(%rip)        # 0xd3ef8ac
   7:	90                   	nop
   8:	0f 0b                	ud2
   a:	90                   	nop
   b:	e9 0d f4 ff ff       	jmp    0xfffff41d
  10:	e8 4d 78 94 ff       	call   0xff947862
  15:	49 ff cd             	dec    %r13
  18:	e9 d1 f4 ff ff       	jmp    0xfffff4ee
  1d:	e8 40 78 94 ff       	call   0xff947862
  22:	48 8d 3d 69 47 5a 0d 	lea    0xd5a4769(%rip),%rdi        # 0xd5a4792
* 29:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2e:	41 bd ea ff ff ff    	mov    $0xffffffea,%r13d
  34:	e9 7c fe ff ff       	jmp    0xfffffeb5
  39:	44 89 7c 24 34       	mov    %r15d,0x34(%rsp)
  3e:	44                   	rex.R


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org baohua@kernel.org baolin.wang@linux.alibaba.com =
david@kernel.org dev.jain@arm.com lance.yang@linux.dev liam.howlett@oracle.=
com linux-mm@kvack.org lorenzo.stoakes@oracle.com npache@redhat.com richard=
.weiyang@gmail.com ryan.roberts@arm.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

