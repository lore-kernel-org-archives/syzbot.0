Received: from out-171.mta1.migadu.com (out-171.mta1.migadu.com [95.215.58.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF364220687
	for <syzbot@lists.linux.dev>; Tue, 30 Sep 2025 11:18:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=95.215.58.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759231113; cv=none; b=lkXZgCRrHUxvMWcTn2HbqWpsLQzjkcpmApnuBS4JEsA4NQQ6EwejYSxNG6x/j0Yko211vkoolKRUZCxtqYsjyzyXH29PmJ9LBu1BVsNrPbRIptG+0e/RJLH/pZwMU+uDHOC+bucSwpkIHHl9pphK9fCIQ9v92ywE1eOCYQI9K00=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759231113; c=relaxed/simple;
	bh=KHYjEziThSNzmIoVCf/6e1q/MRVcwMoJ0+0lY732+2I=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=CQerE7N4o8t2riF5vP8q25jEFBpc+ridU9jQEN80s/oP/8Cq5aDUskz7drZKihlwzhsC7J17gCbgHkhDWlYN+j8oY3gpIAZ+Kv3SgDMF3f1ieyHoSh22fy2JLbEQU4W5KU0F2rPeAnkpzxM7NSt3anGfneZW6x10AC694hggjYA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=r9+wM6V9; arc=none smtp.client-ip=95.215.58.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="r9+wM6V9"
Message-ID: <f6697acb-c7a7-4126-b0d0-e5add35bafc7@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759231107;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=l7QkDw6M9kLZsTy94rmn7kwvsgn47NvjPv3RI5XS+d4=;
	b=r9+wM6V9DqOKpNvYOmTqpnIt5sLS/pvCN6UDhVikZjU9LEDSt6qoCNQoJxUofnr+miBsaI
	TMTSEl5uTXVlU94FHq/ui5lrzpmPd1XIC1lPNFbnO7uwezwGNusE3IDWPDO1HiMsA4Gs/U
	Yo0VtshnNl2k1eA9n5C4cf1wuYwiP08=
Date: Tue, 30 Sep 2025 19:17:58 +0800
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [syzbot ci] Re: mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
Content-Language: en-US
To: syzbot ci <syzbot+ci80449aea3ab57787@syzkaller.appspotmail.com>
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com,
 yuzhao@google.com, ziy@nvidia.com, ying.huang@linux.alibaba.com,
 jannh@google.com, vbabka@suse.cz, riel@surriel.com, usamaarif642@gmail.com,
 david@redhat.com, dev.jain@arm.com, akpm@linux-foundation.org,
 ryan.roberts@arm.com, stable@vger.kernel.org, apopple@nvidia.com,
 rakie.kim@sk.com, gourry@gourry.net, matthew.brost@intel.com,
 lorenzo.stoakes@oracle.com, baohua@kernel.org, liam.howlett@oracle.com,
 ioworker0@gmail.com, harry.yoo@oracle.com, peterx@redhat.com,
 npache@redhat.com, baolin.wang@linux.alibaba.com, linux-mm@kvack.org,
 joshua.hahnjy@gmail.com, linux-kernel@vger.kernel.org, byungchul@sk.com
References: <68dbb776.a00a0220.102ee.0046.GAE@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <68dbb776.a00a0220.102ee.0046.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT

Thanks for the report!

On 2025/9/30 18:56, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v3] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
> https://lore.kernel.org/all/20250930060557.85133-1-lance.yang@linux.dev
> * [PATCH v3 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
> 
> and found the following issue:
> general protection fault in remove_migration_pte
> 
> Full report is available here:
> https://ci.syzbot.org/series/a2021abd-c238-431c-a92e-cc29beb53cbf
> 
> ***
> 
> general protection fault in remove_migration_pte
> 
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
> base:      1896ce8eb6c61824f6c1125d69d8fda1f44a22f8
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/84a2085e-d609-43ea-8b19-f9af8ea3d54a/config
> C repro:   https://ci.syzbot.org/findings/3e211477-5a8d-4d4d-935b-15076499b001/c_repro
> syz repro: https://ci.syzbot.org/findings/3e211477-5a8d-4d4d-935b-15076499b001/syz_repro
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]

This is a known issue that I introduced in the v3 patch. I spotted
this exact NULL pointer dereference bug[1] myself and have already
sent out a v5 version[2] with the fix.

The root cause is that ptep_get() is called before the !pwmw.pte
check, which handles PMD-mapped THP migration entries.

[1] 
https://lore.kernel.org/linux-mm/2d21c9bc-e299-4ca6-85ba-b01a1f346d9d@linux.dev
[2] 
https://lore.kernel.org/linux-mm/20250930081040.80926-1-lance.yang@linux.dev

Thanks,
Lance

> CPU: 0 UID: 0 PID: 5985 Comm: syz.0.27 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
> RIP: 0010:remove_migration_pte+0x37f/0x2340 mm/migrate.c:361
> Code: 43 20 48 89 84 24 08 01 00 00 49 8d 47 40 48 89 84 24 00 01 00 00 4c 89 64 24 50 4c 8b b4 24 70 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 22 3e ff ff 49 8b 06 48 89 44 24
> RSP: 0018:ffffc90002c2f3c0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff888027799080 RCX: 1ffffd40008d1006
> RDX: 0000000000000000 RSI: 00000000000387ff RDI: 0000000000038600
> RBP: ffffc90002c2f5d0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff52000585e30 R12: ffffea0004688008
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004688000
> FS:  0000555589124500(0000) GS:ffff8880b8d7e000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000300 CR3: 0000000026118000 CR4: 00000000000006f0
> Call Trace:
>   <TASK>
>   rmap_walk_anon+0x553/0x730 mm/rmap.c:2842
>   remove_migration_ptes mm/migrate.c:478 [inline]
>   migrate_folio_move mm/migrate.c:1394 [inline]
>   migrate_folios_move mm/migrate.c:1725 [inline]
>   migrate_pages_batch+0x200a/0x35c0 mm/migrate.c:1972
>   migrate_pages_sync mm/migrate.c:2002 [inline]
>   migrate_pages+0x1bcc/0x2930 mm/migrate.c:2111
>   migrate_to_node mm/mempolicy.c:1244 [inline]
>   do_migrate_pages+0x5ee/0x800 mm/mempolicy.c:1343
>   kernel_migrate_pages mm/mempolicy.c:1858 [inline]
>   __do_sys_migrate_pages mm/mempolicy.c:1876 [inline]
>   __se_sys_migrate_pages+0x544/0x650 mm/mempolicy.c:1872
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f922b98ec29
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffccaf966f8 EFLAGS: 00000246 ORIG_RAX: 0000000000000100
> RAX: ffffffffffffffda RBX: 00007f922bbd5fa0 RCX: 00007f922b98ec29
> RDX: 0000200000000300 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 00007f922ba11e41 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000200000000040 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f922bbd5fa0 R14: 00007f922bbd5fa0 R15: 0000000000000004
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
> RIP: 0010:remove_migration_pte+0x37f/0x2340 mm/migrate.c:361
> Code: 43 20 48 89 84 24 08 01 00 00 49 8d 47 40 48 89 84 24 00 01 00 00 4c 89 64 24 50 4c 8b b4 24 70 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 22 3e ff ff 49 8b 06 48 89 44 24
> RSP: 0018:ffffc90002c2f3c0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff888027799080 RCX: 1ffffd40008d1006
> RDX: 0000000000000000 RSI: 00000000000387ff RDI: 0000000000038600
> RBP: ffffc90002c2f5d0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff52000585e30 R12: ffffea0004688008
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004688000
> FS:  0000555589124500(0000) GS:ffff8880b8d7e000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000300 CR3: 0000000026118000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>     0:	43 20 48 89          	rex.XB and %cl,-0x77(%r8)
>     4:	84 24 08             	test   %ah,(%rax,%rcx,1)
>     7:	01 00                	add    %eax,(%rax)
>     9:	00 49 8d             	add    %cl,-0x73(%rcx)
>     c:	47                   	rex.RXB
>     d:	40                   	rex
>     e:	48 89 84 24 00 01 00 	mov    %rax,0x100(%rsp)
>    15:	00
>    16:	4c 89 64 24 50       	mov    %r12,0x50(%rsp)
>    1b:	4c 8b b4 24 70 01 00 	mov    0x170(%rsp),%r14
>    22:	00
>    23:	4c 89 f0             	mov    %r14,%rax
>    26:	48 c1 e8 03          	shr    $0x3,%rax
> * 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
>    2f:	74 08                	je     0x39
>    31:	4c 89 f7             	mov    %r14,%rdi
>    34:	e8 22 3e ff ff       	call   0xffff3e5b
>    39:	49 8b 06             	mov    (%r14),%rax
>    3c:	48                   	rex.W
>    3d:	89                   	.byte 0x89
>    3e:	44                   	rex.R
>    3f:	24                   	.byte 0x24
> 
> 
> ***
> 
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>    Tested-by: syzbot@syzkaller.appspotmail.com
> 
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.

