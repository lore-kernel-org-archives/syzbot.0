Received: from out-172.mta0.migadu.com (out-172.mta0.migadu.com [91.218.175.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EA9C268688
	for <syzbot@lists.linux.dev>; Tue, 30 Sep 2025 11:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759231242; cv=none; b=cX+jOvkpT7LeLMQmhCTPuXAIejX0Sh8T9GvmH82sF+VS7Rij+X9pGOYTy02GkXOusPypucEqjSDYmpW8/35Qa0wLxVKlD30Mbh08vWgATrqvHONsR+IBt1pmAT9SwPkRMgzQ7Y4PQPyKcZJKoIRUQW23kMQk8VIki83cGKWEk7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759231242; c=relaxed/simple;
	bh=4XN0NYoPtAzx19N0avneoLlVcPYM9dOyssM9uDjtj7A=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=UkhFPTSzp3eD7vV56E6kV8mQn8myb1TqxwOE6D6khJIJ5c9362wvT0V+nb9wc0sH0UniWEpPsBA8QjpSFuaWbi6CDK/yEAan8Hx84hf22ZlJd6N/7Y8mfBP8wHYqiAV4+lXCgS07mo1o9YPXLej5kZhbmSFjker2iwB4tthrz50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=NwR4r4Y0; arc=none smtp.client-ip=91.218.175.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="NwR4r4Y0"
Message-ID: <fd30aff2-fbe3-4228-a38f-08b242ef33a2@linux.dev>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
	t=1759231237;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=FwItMkCXdMaYwI2Rw03q5KkFnMdZIJjcXXc+fJQ+dcM=;
	b=NwR4r4Y01p8bjyaYC2Cb+KDyNJfvm65DPlrkQwIIuK4GySHW+teXi5V/VZoIQmwBsOF9QJ
	195hhGBcC5XcbY0uotAldgCMQ6LUsRE4r23TXSNBmr0fD4APWT38tyPtxjFNFlgSMUo8+E
	y+U25NBfb7aXWLuuFxytFy9omxROj9s=
Date: Tue, 30 Sep 2025 19:20:23 +0800
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Subject: Re: [syzbot ci] Re: mm/rmap: fix soft-dirty and uffd-wp bit loss when
 remapping zero-filled mTHP subpage to shared zeropage
Content-Language: en-US
To: syzbot ci <syzbot+ci4a5736baef02a97d@syzkaller.appspotmail.com>
Cc: syzbot@lists.linux.dev, liam.howlett@oracle.com, usamaarif642@gmail.com,
 rakie.kim@sk.com, david@redhat.com, dev.jain@arm.com, ioworker0@gmail.com,
 syzkaller-bugs@googlegroups.com, ziy@nvidia.com, byungchul@sk.com,
 baolin.wang@linux.alibaba.com, akpm@linux-foundation.org,
 apopple@nvidia.com, vbabka@suse.cz, joshua.hahnjy@gmail.com,
 gourry@gourry.net, linux-mm@kvack.org, matthew.brost@intel.com,
 lorenzo.stoakes@oracle.com, ying.huang@linux.alibaba.com,
 linux-kernel@vger.kernel.org, baohua@kernel.org, npache@redhat.com,
 yuzhao@google.com, ryan.roberts@arm.com, riel@surriel.com,
 stable@vger.kernel.org, peterx@redhat.com, jannh@google.com,
 harry.yoo@oracle.com
References: <68dbbc27.a00a0220.102ee.0047.GAE@google.com>
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From: Lance Yang <lance.yang@linux.dev>
In-Reply-To: <68dbbc27.a00a0220.102ee.0047.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Migadu-Flow: FLOW_OUT



On 2025/9/30 19:16, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v4] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
> https://lore.kernel.org/all/20250930071053.36158-1-lance.yang@linux.dev
> * [PATCH v4 1/1] mm/rmap: fix soft-dirty and uffd-wp bit loss when remapping zero-filled mTHP subpage to shared zeropage
> 
> and found the following issue:
> general protection fault in remove_migration_pte
> 
> Full report is available here:
> https://ci.syzbot.org/series/8cc7e52f-a859-4251-bd08-9787cdaf7928
> 
> ***
> 
> general protection fault in remove_migration_pte
> 
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> base:      262858079afde6d367ce3db183c74d8a43a0e83f
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/97ee4826-5d29-472d-a85d-51543b0e45de/config
> C repro:   https://ci.syzbot.org/findings/f4819db2-21f2-4280-8bc4-942445398953/c_repro
> syz repro: https://ci.syzbot.org/findings/f4819db2-21f2-4280-8bc4-942445398953/syz_repro
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

> CPU: 0 UID: 0 PID: 6025 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
> RIP: 0010:remove_migration_pte+0x369/0x2320 mm/migrate.c:352
> Code: 00 48 8d 43 20 48 89 44 24 68 49 8d 47 40 48 89 84 24 e8 00 00 00 4c 89 64 24 48 4c 8b b4 24 50 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 f8 3e ff ff 49 8b 06 48 89 44 24
> RSP: 0018:ffffc90002fb73e0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88802957e300 RCX: 1ffffd40008c9006
> RDX: 0000000000000000 RSI: 0000000000030dff RDI: 0000000000030c00
> RBP: ffffc90002fb75d0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff520005f6e34 R12: ffffea0004648008
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004648000
> FS:  00005555624de500(0000) GS:ffff8880b83fc000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000300 CR3: 000000010d8b8000 CR4: 00000000000006f0
> Call Trace:
>   <TASK>
>   rmap_walk_anon+0x553/0x730 mm/rmap.c:2855
>   remove_migration_ptes mm/migrate.c:469 [inline]
>   migrate_folio_move mm/migrate.c:1381 [inline]
>   migrate_folios_move mm/migrate.c:1711 [inline]
>   migrate_pages_batch+0x202e/0x35e0 mm/migrate.c:1967
>   migrate_pages_sync mm/migrate.c:1997 [inline]
>   migrate_pages+0x1bcc/0x2930 mm/migrate.c:2106
>   migrate_to_node mm/mempolicy.c:1244 [inline]
>   do_migrate_pages+0x5ee/0x800 mm/mempolicy.c:1343
>   kernel_migrate_pages mm/mempolicy.c:1858 [inline]
>   __do_sys_migrate_pages mm/mempolicy.c:1876 [inline]
>   __se_sys_migrate_pages+0x544/0x650 mm/mempolicy.c:1872
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb18e18ec29
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdca5c9838 EFLAGS: 00000246 ORIG_RAX: 0000000000000100
> RAX: ffffffffffffffda RBX: 00007fb18e3d5fa0 RCX: 00007fb18e18ec29
> RDX: 0000200000000300 RSI: 0000000000000003 RDI: 0000000000000000
> RBP: 00007fb18e211e41 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000200000000040 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb18e3d5fa0 R14: 00007fb18e3d5fa0 R15: 0000000000000004
>   </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:ptep_get include/linux/pgtable.h:340 [inline]
> RIP: 0010:remove_migration_pte+0x369/0x2320 mm/migrate.c:352
> Code: 00 48 8d 43 20 48 89 44 24 68 49 8d 47 40 48 89 84 24 e8 00 00 00 4c 89 64 24 48 4c 8b b4 24 50 01 00 00 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 f8 3e ff ff 49 8b 06 48 89 44 24
> RSP: 0018:ffffc90002fb73e0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffff88802957e300 RCX: 1ffffd40008c9006
> RDX: 0000000000000000 RSI: 0000000000030dff RDI: 0000000000030c00
> RBP: ffffc90002fb75d0 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff520005f6e34 R12: ffffea0004648008
> R13: dffffc0000000000 R14: 0000000000000000 R15: ffffea0004648000
> FS:  00005555624de500(0000) GS:ffff8880b83fc000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000300 CR3: 000000010d8b8000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>     0:	00 48 8d             	add    %cl,-0x73(%rax)
>     3:	43 20 48 89          	rex.XB and %cl,-0x77(%r8)
>     7:	44 24 68             	rex.R and $0x68,%al
>     a:	49 8d 47 40          	lea    0x40(%r15),%rax
>     e:	48 89 84 24 e8 00 00 	mov    %rax,0xe8(%rsp)
>    15:	00
>    16:	4c 89 64 24 48       	mov    %r12,0x48(%rsp)
>    1b:	4c 8b b4 24 50 01 00 	mov    0x150(%rsp),%r14
>    22:	00
>    23:	4c 89 f0             	mov    %r14,%rax
>    26:	48 c1 e8 03          	shr    $0x3,%rax
> * 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
>    2f:	74 08                	je     0x39
>    31:	4c 89 f7             	mov    %r14,%rdi
>    34:	e8 f8 3e ff ff       	call   0xffff3f31
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

