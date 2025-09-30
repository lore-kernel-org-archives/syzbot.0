Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C3ED1E3DDE
	for <syzbot@lists.linux.dev>; Tue, 30 Sep 2025 11:16:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759231018; cv=none; b=rJ5aKpXnwNkBITuk4uKVRX/ugKzSJxTZgOK0OBSOvgSdB5tcdZJn/+2zC/PRwlH0w4xVacZUSSaegRTx4NR742plcB7PFW9t9cwTS202iRY3tgKcydcr1db6Vepr1kjvSr0EyAc4e1Pr/sPTpn7eDUwJCS3CpzYubPeGtdqUAt0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759231018; c=relaxed/simple;
	bh=f9EKTG1fBHJM9pJS43Vttf02/bEAMGN9OK8xOaEKgcE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=KXEjFjwYMY7/kSF+UWqgyqgVZX8Ab9ZeRWQOxdGxkv39GIpAGLS/ewM3vSHOWRMKKGWSTLIogiKSM1F97wzDaB2elggUU4vOt/F/k6iubcyr9BE1nT8FRXH6IIhwC9JSbo8d1DXy+IWp06/N5n6XT/nYRWw/8vmN+RPg6yLYhB8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-9228ed70eb7so549813639f.2
        for <syzbot@lists.linux.dev>; Tue, 30 Sep 2025 04:16:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759231016; x=1759835816;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=I6Ebb4Qk4BsBLP48AswBIKoGzuUaeFoYM+Jv9/UfVxo=;
        b=F7eVttGV+J9G2yWP+32QHHH0yTT9PuBF9z6ybcbDLOKmIIV2/u6pSkwCO9YeO6Wb/2
         d2LEk1zG5j7+QRYUWLDjfuDl+U3tWPfARwVpNJESCrHdaR+cZAyarwmwUOOx0NBwjoMF
         PS+bh4fIhUDrV7MVdWvtsELaJolVfWXQwkcrvePEMXIFC75thWi5D5luDla+Om/l+5LY
         whTafLJJS1fEhxTH30K3xFOQKseTm3beA2K6yyw7OmjO1UAqckf1rDK6eulyV+XRaXjV
         7TYfPdkTUi/r5J7yZKj4aCGIKyg9AaF00QBVn/N8lDQk8Xk8CdyrddD+OoYeaGL7GNcI
         Y6/A==
X-Gm-Message-State: AOJu0YxIsr9UD55puI+ykRazokjZesZXkztf7dSt207QH/AHtJEfiQ1P
	p8Kx82guLnaA67QKOLw3sLtCYYrNRgDQPDarBTebQTsfIi4Osw2B9g2dBVCqe1r8FbZh7DJL6/M
	AjD4T3qP/FL6MTWYHqkgAEQKTQ+bLH1cMFHJgigTC/VFEL1+RDYNW2GSUQE8=
X-Google-Smtp-Source: AGHT+IH6sz85o5A0V5B/nIDbgv3reoyO8a3pMB6N8HqKdtSaLpO1RbI7l6kogHuwio8JrbQz4X9/y9Q57th5jPMY07XpKFq20Iye
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:b49:b0:425:7524:8b38 with SMTP id
 e9e14a558f8ab-4259562c487mr100691175ab.22.1759231015795; Tue, 30 Sep 2025
 04:16:55 -0700 (PDT)
Date: Tue, 30 Sep 2025 04:16:55 -0700
In-Reply-To: <20250930071053.36158-1-lance.yang@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68dbbc27.a00a0220.102ee.0047.GAE@google.com>
Subject: [syzbot ci] Re: mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
From: syzbot ci <syzbot+ci4a5736baef02a97d@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, apopple@nvidia.com, baohua@kernel.org, 
	baolin.wang@linux.alibaba.com, byungchul@sk.com, david@redhat.com, 
	dev.jain@arm.com, gourry@gourry.net, harry.yoo@oracle.com, 
	ioworker0@gmail.com, jannh@google.com, joshua.hahnjy@gmail.com, 
	lance.yang@linux.dev, liam.howlett@oracle.com, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org, lorenzo.stoakes@oracle.com, matthew.brost@intel.com, 
	npache@redhat.com, peterx@redhat.com, rakie.kim@sk.com, riel@surriel.com, 
	ryan.roberts@arm.com, stable@vger.kernel.org, usamaarif642@gmail.com, 
	vbabka@suse.cz, ying.huang@linux.alibaba.com, yuzhao@google.com, 
	ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v4] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
https://lore.kernel.org/all/20250930071053.36158-1-lance.yang@linux.dev
* [PATCH v4 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage

and found the following issue:
general protection fault in remove_migration_pte

Full report is available here:
https://ci.syzbot.org/series/8cc7e52f-a859-4251-bd08-9787cdaf7928

***

general protection fault in remove_migration_pte

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      262858079afde6d367ce3db183c74d8a43a0e83f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/97ee4826-5d29-472d-a85d-51543b0e45de/config
C repro:   https://ci.syzbot.org/findings/f4819db2-21f2-4280-8bc4-942445398953/c_repro
syz repro: https://ci.syzbot.org/findings/f4819db2-21f2-4280-8bc4-942445398953/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 0 UID: 0 PID: 6025 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
RIP: 0010:remove_migration_pte+0x369/0x2320 mm/migrate.c:352
Code: 00 48 8d 43 20 48 89 44 24 68 49 8d 47 40 48 89 84 24 e8 00 00 00 4c 89 64 24 48 4c 8b b4 24 50 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 f8 3e ff ff 49 8b 06 48 89 44 24
RSP: 0018:ffffc90002fb73e0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88802957e300 RCX: 1ffffd40008c9006
RDX: 0000000000000000 RSI: 0000000000030dff RDI: 0000000000030c00
RBP: ffffc90002fb75d0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520005f6e34 R12: ffffea0004648008
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004648000
FS:  00005555624de500(0000) GS:ffff8880b83fc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000300 CR3: 000000010d8b8000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 rmap_walk_anon+0x553/0x730 mm/rmap.c:2855
 remove_migration_ptes mm/migrate.c:469 [inline]
 migrate_folio_move mm/migrate.c:1381 [inline]
 migrate_folios_move mm/migrate.c:1711 [inline]
 migrate_pages_batch+0x202e/0x35e0 mm/migrate.c:1967
 migrate_pages_sync mm/migrate.c:1997 [inline]
 migrate_pages+0x1bcc/0x2930 mm/migrate.c:2106
 migrate_to_node mm/mempolicy.c:1244 [inline]
 do_migrate_pages+0x5ee/0x800 mm/mempolicy.c:1343
 kernel_migrate_pages mm/mempolicy.c:1858 [inline]
 __do_sys_migrate_pages mm/mempolicy.c:1876 [inline]
 __se_sys_migrate_pages+0x544/0x650 mm/mempolicy.c:1872
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb18e18ec29
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffdca5c9838 EFLAGS: 00000246 ORIG_RAX: 0000000000000100
RAX: ffffffffffffffda RBX: 00007fb18e3d5fa0 RCX: 00007fb18e18ec29
RDX: 0000200000000300 RSI: 0000000000000003 RDI: 0000000000000000
RBP: 00007fb18e211e41 R08: 0000000000000000 R09: 0000000000000000
R10: 0000200000000040 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb18e3d5fa0 R14: 00007fb18e3d5fa0 R15: 0000000000000004
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
RIP: 0010:remove_migration_pte+0x369/0x2320 mm/migrate.c:352
Code: 00 48 8d 43 20 48 89 44 24 68 49 8d 47 40 48 89 84 24 e8 00 00 00 4c 89 64 24 48 4c 8b b4 24 50 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 f8 3e ff ff 49 8b 06 48 89 44 24
RSP: 0018:ffffc90002fb73e0 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff88802957e300 RCX: 1ffffd40008c9006
RDX: 0000000000000000 RSI: 0000000000030dff RDI: 0000000000030c00
RBP: ffffc90002fb75d0 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520005f6e34 R12: ffffea0004648008
R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004648000
FS:  00005555624de500(0000) GS:ffff8880b83fc000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000300 CR3: 000000010d8b8000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	00 48 8d             	add    %cl,-0x73(%rax)
   3:	43 20 48 89          	rex.XB and %cl,-0x77(%r8)
   7:	44 24 68             	rex.R and $0x68,%al
   a:	49 8d 47 40          	lea    0x40(%r15),%rax
   e:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
  15:	00
  16:	4c 89 64 24 48       	mov    %r12,0x48(%rsp)
  1b:	4c 8b b4 24 50 01 00 	mov    0x150(%rsp),%r14
  22:	00
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 f8 3e ff ff       	call   0xffff3f31
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
