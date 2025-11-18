Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7972A273D76
	for <syzbot@lists.linux.dev>; Tue, 18 Nov 2025 20:09:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763496579; cv=none; b=PmCnh9zxP2Bv18CwhW/lQGk3zNRb6qK8KaLba3qUAcGFxRTVtHiREqV5TDwzvSEq76L8dxsqfqJ4iQ7rpwrePAq8dXAFOWawCt+AuIme51mz137y10QuPqgZZB5Oquf30M/wwiv2aEiNY111X1TOW8uN5RxyG4Vypd+RdeoiTCE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763496579; c=relaxed/simple;
	bh=BZ7RWxkTeK29l+KUVX+Vy/gWP3D05w/7RzkcrVm7JQ0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=A0GEO3C2DAguvMUFP6Op3YjzMmo/7OkTWuZmIYAa6/EDOxldYkEF+qG0C+vrR3CmJliNrtxKnjhikjCVOHfkVc2sOjfc+uZ9g3coIXMiUOMukD+1rKR/5YiqFwa0c3e5xdyJ38fkrYdDn6HD9dUjOKOEBmGNJcBuUOC56Ui8Q4c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-43377f5ae6fso137434955ab.1
        for <syzbot@lists.linux.dev>; Tue, 18 Nov 2025 12:09:37 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763496576; x=1764101376;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=ZsCG2p1E6pZtPLvoW4tM/cQlE5nY2r+nl7oWSRRtM4I=;
        b=I7aC9xrDDrlZYVXQuToT/sYOvFvdfYCEQ5rfo/WxeQwTHNlNTjKIAlgrUMxhfS7Z/z
         hRC4P1xslqZ//S2Gz0D36eiieZHKIaiVFip0ap+lqddgoXPIujO3slxXkhQ/hMxvpqiC
         oWQGGqTVXjDf9Ax8tnF5uXczOplcw+4qpUiQCWBC0HcYd2LACOwmLuXtsS24cgIWjTuh
         XfZq3LDJ79WKq+e14IUUaD5/csUFevr9pGzqn4qZnfIiJNCv8/XIvivGWC9kORy/9f9F
         zGcCzwlFB5rI54Oidc5LeSwOgXEX4UiWxNPLw6ma9cX0W2+s50GEmIwz+ixddUSLZlgK
         1V4g==
X-Gm-Message-State: AOJu0Yy0ejoiRb9g3riE4tBUMD3z0bHCLJ80noeRUM+Xo/RUGV9Qz4+L
	YLrW/vZt0Hyq2VsQPHOD+YptnnAT0kpL1tCfg9Ws4t0gPo6cJryjWsEUlhlZOIzcK7xe9WNUt5s
	TL2wx/DeNCTBGLSrYD6xWhcGzDGgCSVpfz3U4Mg/zbKpFAAjzVdmVFefGsuU=
X-Google-Smtp-Source: AGHT+IGDVh3aDYc6oEHc6Bp/wTvCvJnWqFPc9xW52sM2+GEVMTiEP3c0EE/s3RfTh9kl95UDeMejqmTwTtZLJNefH1m4e0b2MP5s
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3090:b0:433:74ba:8be9 with SMTP id
 e9e14a558f8ab-4348c851b3dmr201166415ab.5.1763496576681; Tue, 18 Nov 2025
 12:09:36 -0800 (PST)
Date: Tue, 18 Nov 2025 12:09:36 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691cd280.050a0220.2ffa18.0001.GAE@google.com>
Subject: [moderation/CI] Re: kho: free already restored pages when
 kho_restore_vmalloc() fails
From: syzbot ci <syzbot+ci589cafc8d16a454a@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] kho: free already restored pages when kho_restore_vmalloc() fails
https://lore.kernel.org/all/20251118181811.47336-1-pratyush@kernel.org
* [PATCH] kho: free already restored pages when kho_restore_vmalloc() fails

and found the following issue:
KASAN: slab-use-after-free Read in hci_cmd_work

Full report is available here:
https://ci.syzbot.org/series/bd8dd252-3137-403d-b04c-79e86d5ef0ba

***

KASAN: slab-use-after-free Read in hci_cmd_work

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      0c1c7a6a83feaf2cf182c52983ffe330ffb50280
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/d8eb5286-446e-4060-bddb-34587ae22da4/config

Bluetooth: hci0: unexpected cc 0x1001 length: 249 > 9
Bluetooth: hci0: unexpected cc 0x0c23 length: 249 > 4
Bluetooth: hci0: unexpected cc 0x0c38 length: 249 > 2
==================================================================
BUG: KASAN: slab-use-after-free in hci_cmd_work+0x5d0/0x7b0
Read of size 2 at addr ffff88816ca6c338 by task kworker/u11:0/56

CPU: 0 UID: 0 PID: 56 Comm: kworker/u11:0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: hci0 hci_cmd_work
Call Trace:
 <TASK>
 dump_stack_lvl+0x189/0x250
 print_report+0xca/0x240
 kasan_report+0x118/0x150
 hci_cmd_work+0x5d0/0x7b0
 process_one_work+0x93a/0x15e0
 worker_thread+0x9b0/0xee0
 kthread+0x711/0x8a0
 ret_from_fork+0x599/0xb30
 ret_from_fork_asm+0x1a/0x30
 </TASK>

Allocated by task 6001:
 kasan_save_track+0x3e/0x80
 __kasan_slab_alloc+0x6c/0x80
 kmem_cache_alloc_node_noprof+0x43c/0x710
 __alloc_skb+0x112/0x2d0
 hci_cmd_sync_alloc+0x3d/0x3b0
 __hci_cmd_sync_sk+0x1a7/0xc70
 hci_cmd_sync_status+0x4d/0x150
 hci_dev_cmd+0x431/0x7d0
 sock_do_ioctl+0xdc/0x300
 sock_ioctl+0x576/0x790
 __se_sys_ioctl+0xfc/0x170
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Freed by task 6003:
 kasan_save_track+0x3e/0x80
 kasan_save_free_info+0x46/0x50
 __kasan_slab_free+0x5c/0x80
 kmem_cache_free+0x197/0x640
 vhci_read+0x49a/0x5b0
 vfs_read+0x200/0xa30
 ksys_read+0x145/0x250
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

The buggy address belongs to the object at ffff88816ca6c300
 which belongs to the cache skbuff_head_cache of size 240
The buggy address is located 56 bytes inside of
 freed 240-byte region [ffff88816ca6c300, ffff88816ca6c3f0)

The buggy address belongs to the physical page:
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x16ca6c
head: order:1 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
anon flags: 0x57ff00000000040(head|node=1|zone=2|lastcpupid=0x7ff)
page_type: f5(slab)
raw: 057ff00000000040 ffff8881616a78c0 0000000000000000 dead000000000001
raw: 0000000000000000 0000000000150015 00000000f5000000 0000000000000000
head: 057ff00000000040 ffff8881616a78c0 0000000000000000 dead000000000001
head: 0000000000000000 0000000000150015 00000000f5000000 0000000000000000
head: 057ff00000000001 ffffea0005b29b01 00000000ffffffff 00000000ffffffff
head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000002
page dumped because: kasan: bad access detected
page_owner tracks the page as allocated
page last allocated via order 1, migratetype Unmovable, gfp_mask 0xd20c0(__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 5291, tgid 5291 (udevd), ts 33642680595, free_ts 13452841945
 post_alloc_hook+0x240/0x2a0
 get_page_from_freelist+0x2365/0x2440
 __alloc_frozen_pages_noprof+0x181/0x370
 alloc_pages_mpol+0x232/0x4a0
 allocate_slab+0x86/0x3b0
 ___slab_alloc+0xf56/0x1990
 __slab_alloc+0x65/0x100
 kmem_cache_alloc_node_noprof+0x4ce/0x710
 __alloc_skb+0x112/0x2d0
 netlink_sendmsg+0x5c6/0xb30
 __sock_sendmsg+0x21c/0x270
 ____sys_sendmsg+0x505/0x870
 ___sys_sendmsg+0x21f/0x2a0
 __x64_sys_sendmsg+0x19b/0x260
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
page last free pid 9 tgid 9 stack trace:
 __free_frozen_pages+0xbc8/0xd30
 vfree+0x25a/0x400
 delayed_vfree_work+0x55/0x80
 process_one_work+0x93a/0x15e0
 worker_thread+0x9b0/0xee0
 kthread+0x711/0x8a0
 ret_from_fork+0x599/0xb30
 ret_from_fork_asm+0x1a/0x30

Memory state around the buggy address:
 ffff88816ca6c200: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
 ffff88816ca6c280: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
>ffff88816ca6c300: fa fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
                                        ^
 ffff88816ca6c380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fc fc
 ffff88816ca6c400: fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc fc
==================================================================


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org graf@amazon.com kexec@lists.infradead.org linux-kernel@vger.kernel.org linux-mm@kvack.org pasha.tatashin@soleen.com pratyush@kernel.org rppt@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

