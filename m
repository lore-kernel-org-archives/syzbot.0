Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 297D71F9F7A
	for <syzbot@lists.linux.dev>; Tue, 30 Sep 2025 10:00:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759226427; cv=none; b=mY2GX/L9Tpu8awsZTdSXdwI/+Jaq2ph6egXC7XFDl2EJiULKgfUjSRW953h5HP8Gy/paVexyEUxbXuQa2Y6guVRpXzrT8utzFAI+MAISigkjSRDXRbIyvIRDerfV441oevZEbyi/oDYU7O6Ql35n2g1aFbUmPKOX3k2z31KEgGI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759226427; c=relaxed/simple;
	bh=0Hzsq5P+AXSFcuRRR2ee/1V3kBvJUn+IPGT2oG3VuHg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=omlGH+NsFnpUbIMxq6Em/d39xy2CDbUE4KkXceHIt7wlweVou6vsQbpwRccWJY6dJGVLs6W3yQ8wFi3a8zvkQRsZwHV19zGU/8gsvbMuWz/pYMNGMeeaMiW5V1FNhzZCzpskmj9T0uvsHLX0vC9P9CtD4pl7zDSg0jja0bKOG30=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-9048fe74483so671025539f.2
        for <syzbot@lists.linux.dev>; Tue, 30 Sep 2025 03:00:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759226423; x=1759831223;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SMO9ts/+UpniIIsn0ABDTCPCcxhcDDI+WMLNNdhwpM4=;
        b=bPXfyF4kBbiZ6J9sAzeRsXUHtD/8NqizqO3voHZNxDRp9JP+NoCXcH2pbd+7EDgmI8
         9fylA14dwz72gT+RMIsFUo7xfNBW6BwXeThFH3BmBu8R0XviSZAqAm+WMxaN3eU7zTvV
         w/EepgbR6O+39bcreXcQ9Q9wCniVStMIWAEe9MeFYMaQVXY6YKPbmzOsRN+Dih0S5vrF
         geBG+WpyrmBCEP4SbOVgmj2SeUdsfamECWV8Et867eVQ3L4VqTJPiqsH40FDLAkWKqP6
         tPALi6YDhAI3Nmahc7oSbZs6GlnY+eUCWeYMXGZFcDl6QT7L6Z/sBcEIRka25U7VccB2
         kFOA==
X-Gm-Message-State: AOJu0YwlvMWvFkI5D/PdCRjFVefZrXQxgBZe5Phh7exa6Z/Gk0yt3A8z
	k2erGZU6qDVX3p+271cphghSMHbyllyZbxbaVaunEVU19HteVnlenO9qy+VnBP+tBvi50hz4ezP
	sFisEsqMUQdCW9snZ9re6K9VUO10ytSx4KB2J+EHDKHo6JbfMxu41iyaP5jY=
X-Google-Smtp-Source: AGHT+IGc1tF7E1d0l841A9ayYOOGGlchlpfPGJya4KJMG0ELXUHzVep0MKuTYN+cUkqDNIS9d1TeENRzW2RyzELJ/+uNN+BwWQsF
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6b0b:b0:91c:fcd:88fd with SMTP id
 ca18e2360f4ac-91c0fcd8c40mr1548982839f.7.1759226422783; Tue, 30 Sep 2025
 03:00:22 -0700 (PDT)
Date: Tue, 30 Sep 2025 03:00:22 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68dbaa36.a00a0220.102ee.0045.GAE@google.com>
Subject: [moderation/CI] Re: mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
From: syzbot ci <syzbot+ci2cfc3cf2a53af813@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-fille=
d mTHP subpage to shared zeropage
https://lore.kernel.org/all/20250930060557.85133-1-lance.yang@linux.dev
* [PATCH v3 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when remappin=
g zero-filled mTHP subpage to shared zeropage

and found the following issue:
general protection fault in remove_migration_pte

Full report is available here:
https://ci.syzbot.org/series/a2021abd-c238-431c-a92e-cc29beb53cbf

***

general protection fault in remove_migration_pte

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      1896ce8eb6c61824f6c1125d69d8fda1f44a22f8
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/84a2085e-d609-43ea-8b19-f9af8ea3d54=
a/config
C repro:   https://ci.syzbot.org/findings/3e211477-5a8d-4d4d-935b-15076499b=
001/c_repro
syz repro: https://ci.syzbot.org/findings/3e211477-5a8d-4d4d-935b-15076499b=
001/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 5985 Comm: syz.0.27 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
RIP: 0010:remove_migration_pte+0x37f/0x2340 mm/migrate.c:361
Code: 43 20 48 89 84 24 08 01 00 00 49 8d 47 40 48 89 84 24 00 01 00 00 4c =
89 64 24 50 4c 8b b4 24 70 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 7=
4 08 4c 89 f7 e8 22 3e ff ff 49 8b 06 48 89 44 24
RSP: 0018:ffffc90002c2f3c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888027799080 RCX: 1ffffd40008d1006
RDX: 0000000000000000 RSI: 00000000000387ff RDI: 0000000000038600
RBP: ffffc90002c2f5d0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000585e30 R12: ffffea0004688008
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004688000
FS:  0000555589124500(0000) GS:ffff8880b8d7e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000300 CR3: 0000000026118000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 rmap_walk_anon+0x553/0x730 mm/rmap.c:2842
 remove_migration_ptes mm/migrate.c:478 [inline]
 migrate_folio_move mm/migrate.c:1394 [inline]
 migrate_folios_move mm/migrate.c:1725 [inline]
 migrate_pages_batch+0x200a/0x35c0 mm/migrate.c:1972
 migrate_pages_sync mm/migrate.c:2002 [inline]
 migrate_pages+0x1bcc/0x2930 mm/migrate.c:2111
 migrate_to_node mm/mempolicy.c:1244 [inline]
 do_migrate_pages+0x5ee/0x800 mm/mempolicy.c:1343
 kernel_migrate_pages mm/mempolicy.c:1858 [inline]
 __do_sys_migrate_pages mm/mempolicy.c:1876 [inline]
 __se_sys_migrate_pages+0x544/0x650 mm/mempolicy.c:1872
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f922b98ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffccaf966f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000100
RAX: ffffffffffffffda RBX: 00007f922bbd5fa0 RCX: 00007f922b98ec29
RDX: 0000200000000300 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 00007f922ba11e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000200000000040 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f922bbd5fa0 R14: 00007f922bbd5fa0 R15: 0000000000000004
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
RIP: 0010:remove_migration_pte+0x37f/0x2340 mm/migrate.c:361
Code: 43 20 48 89 84 24 08 01 00 00 49 8d 47 40 48 89 84 24 00 01 00 00 4c =
89 64 24 50 4c 8b b4 24 70 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 7=
4 08 4c 89 f7 e8 22 3e ff ff 49 8b 06 48 89 44 24
RSP: 0018:ffffc90002c2f3c0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888027799080 RCX: 1ffffd40008d1006
RDX: 0000000000000000 RSI: 00000000000387ff RDI: 0000000000038600
RBP: ffffc90002c2f5d0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000585e30 R12: ffffea0004688008
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004688000
FS:  0000555589124500(0000) GS:ffff8880b8d7e000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000300 CR3: 0000000026118000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	43 20 48 89          	rex.XB and %cl,-0x77(%r8)
   4:	84 24 08             	test   %ah,(%rax,%rcx,1)
   7:	01 00                	add    %eax,(%rax)
   9:	00 49 8d             	add    %cl,-0x73(%rcx)
   c:	47                   	rex.RXB
   d:	40                   	rex
   e:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
  15:	00
  16:	4c 89 64 24 50       	mov    %r12,0x50(%rsp)
  1b:	4c 8b b4 24 70 01 00 	mov    0x170(%rsp),%r14
  22:	00
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruct=
ion
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 22 3e ff ff       	call   0xffff3e5b
  39:	49 8b 06             	mov    (%r14),%rax
  3c:	48                   	rex.W
  3d:	89                   	.byte 0x89
  3e:	44                   	rex.R
  3f:	24                   	.byte 0x24


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org apopple@nvidia.com baohua@kernel.org baolin.wang=
@linux.alibaba.com byungchul@sk.com david@redhat.com dev.jain@arm.com gourr=
y@gourry.net harry.yoo@oracle.com ioworker0@gmail.com jannh@google.com josh=
ua.hahnjy@gmail.com lance.yang@linux.dev liam.howlett@oracle.com linux-kern=
el@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com matthew.br=
ost@intel.com npache@redhat.com peterx@redhat.com rakie.kim@sk.com riel@sur=
riel.com ryan.roberts@arm.com stable@vger.kernel.org usamaarif642@gmail.com=
 vbabka@suse.cz ying.huang@linux.alibaba.com yuzhao@google.com ziy@nvidia.c=
om]

If the report looks fine to you, reply with:
#syz upstream

