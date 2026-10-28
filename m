Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.71
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793196861;
	b=I96L+ZereZTlwLEua2/imZCmhYEGayI2POZOHiUfKl70+a9JP5YRH+t6YjfXW54ILuko
	 4yqgFwSvjZwDh1i2yauCeIOZdEcKYfRhPqcEFxD8j3Eu7QhyvTpmFdaZfIQCahxEdn7sR
	 OFu00c9qUu4P4kWNfcxGmZ2biWUwkfx29F89yYGW5m6OcpARmT0D6OZWweQTmEFJbClCC
	 MouDCJ+CDscJuFexXacJ1KzQGOc01jUBjtHWqRBbKcsyOPckKhujkgvdcryOI6KwlLLEt
	 0pRHwC+P0GuxTjI+HWj/jGsj/NyPNTO6WL/0Qucc6AQ2Mitr+PMvQ5mZCvJVYg+0E+g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793196861;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:In-Reply-To:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=4Q52fWlYWREVmSOBokAnR5tOe0/mQLTOrcLglNmV8PM=;
	b=S/qp0lOfBk8sfE4ObOhI1vShIBJ9TUXu9rY6Crgo8cc+J5MQRAR5m8Ka6+Mxs00tjwrH
	 0KBdtal7gwrLBXfzRRCRynQ70mRhAf4aaYpsj4lQh33fnc6s7LDSkX6G0graoEjLqsv3x
	 l0zmu6rqWfSi7hTbnqEwthAZAdrHXJ+aWDmj09Y8ELKW4WRwWV9C3LufFXQJVMH66sxjG
	 183432HxUqC/rFBN7tb8C3a0fboG6Q6LQrFseyu2JgvjO7QSobGcC2auIIjb22eZW4iQb
	 hyYgaNU01QBa1j6CGwIUqzednIOC4GbV9l/FKaqgHwjqKriG+K2faTRSN0VJQJPyvwA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.160.71
Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E04B606A320
	for <syzbot@lists.linux.dev>; Wed, 28 Oct 2026 14:14:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 0E04B606A320
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-4a7235ca3a6so633294fac.3
        for <syzbot@lists.linux.dev>; Wed, 28 Oct 2026 07:14:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793196860; x=1793801660;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=4Q52fWlYWREVmSOBokAnR5tOe0/mQLTOrcLglNmV8PM=;
        b=MyLu6vTIrMGgn71B1+R5VNaxNX4spBsSil4alww1ojiHwHPfsQiOQWFl11XhQELWuR
         WUlQLgM7TmZ3aWbquUFTcsdWL4iQ0BKRvIttx4+N3EjS1CJeHPldAwkWnax9pq1dd/Wu
         lTna6vWJkf4R9U8QtGADDfXoJjwD1BjHq+1pygd/OQXM2OST2CzFxiUWlLSkzMifPUoi
         o8n3wwj9dW0pCvHYU7gZYNbpD8bJ+NKCf6W+VauhgtP79dNPOrpMNYyFPB5eiV0w4B1m
         kEzSgwfB5ZQWbDPxW98IDixc71CD4HxhTAHiNMSbkYRLCdI0OBr0nAn6oaeJIiWdrd62
         Z5Cw==
X-Gm-Message-State: AFq9FYIAx1sKhnLQ7ZqPIujJFLMw4zp3NjwWf+Jn8NJR7PntmAlETB/2
	4z4eI75HbTCaHlCZouRecHqBlK85gwnunXD8DWHQsGvsqs3cEXQyH7OG0wq75dmqs2D6zsWGIbs
	3YaTnqpAUCo83RVwZXKF9+9pZPXccMiNtHnq0sMPVPOr3qwmhnMXirhBoE2U=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3198:b0:4f4:b5ba:a241 with SMTP id
 5614622812f47-56383c8c833mr1760704b6e.39.1793196860050; Wed, 28 Oct 2026
 07:14:20 -0700 (PDT)
Date: Wed, 28 Oct 2026 07:14:20 -0700
In-Reply-To: <20261028041528.269829-1-eadavis@sina.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae2033c.b269e7d3.3ea0f.0032.GAE@google.com>
Subject: [syzbot ci] Re: hugetlb: supports unmapping private mappings
From: syzbot ci <syzbot+cid535899c573f38fa@syzkaller.appspotmail.com>
To: eadavis@sina.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	mike.kravetz@oracle.com, muchun.song@linux.dev, osalvador@suse.de, 
	syzbot@syzkaller.appspotmail.com, syzkaller-bugs@googlegroups.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] hugetlb: supports unmapping private mappings
https://lore.kernel.org/all/20261028041528.269829-1-eadavis@sina.com
* [PATCH] hugetlb: supports unmapping private mappings

and found the following issue:
WARNING: bad unlock balance in remove_inode_hugepages

Full report is available here:
https://ci.syzbot.org/series/bf349aec-df0c-48a8-ab82-9f71361a3830

***

WARNING: bad unlock balance in remove_inode_hugepages

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      7d1f84f1b94e79cb95d974ab3ec54cb3a4d64f5b
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/7d19c5c0-63db-4726-978e-d863eedfb488/config

=====================================
WARNING: bad unlock balance detected!
syzkaller #0 Not tainted
-------------------------------------
syz.4.862/12304 is trying to release lock (&vma_lock->rw_sema) at:
[<ffffffff82b5a0e7>] remove_inode_hugepages+0xc57/0x1220
but there are no more locks to release!

other info that might help us debug this:
locks held by syz.4.862/12304: 4, last CPU#1:
 #0: ffff88810729e460 (sb_writers#12){.+.+}-{0:0}, at: vfs_fallocate+0x5e0/0x7e0
 #1: ffff8881aa537b00 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: hugetlbfs_fallocate+0x3f7/0x11c0
 #2: ffff8881683dc638 (&hugetlb_fault_mutex_table[i]){+.+.}-{4:4}, at: remove_inode_hugepages+0x370/0x1220
 #3: ffff8881aa537da8 (&hugetlbfs_i_mmap_rwsem_key){+.+.}-{4:4}, at: remove_inode_hugepages+0xa44/0x1220

stack backtrace:
CPU: 1 UID: 0 PID: 12304 Comm: syz.4.862 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 print_unlock_imbalance_bug+0xdc/0xf0
 lock_release+0x252/0x3c0
 up_write+0x2d/0x4a0
 remove_inode_hugepages+0xc57/0x1220
 hugetlbfs_fallocate+0xc51/0x11c0
 vfs_fallocate+0x65a/0x7e0
 madvise_vma_behavior+0x2cf5/0x43b0
 madvise_walk_vmas+0x576/0xb00
 madvise_do_behavior+0x385/0x540
 do_madvise+0x327/0x3a0
 __x64_sys_madvise+0xa6/0xc0
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0c8dd9f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0c8bff6028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f0c8e026450 RCX: 00007f0c8dd9f559
RDX: 0000000000000009 RSI: 0000000000c00000 RDI: 0000200000400000
RBP: 00007f0c8de36b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0c8e0264e8 R14: 00007f0c8e026450 R15: 00007ffc9fc94698
 </TASK>
------------[ cut here ]------------
DEBUG_RWSEMS_WARN_ON((rwsem_owner(sem) != current) && !rwsem_test_oflags(sem, RWSEM_NONSPINNABLE)): count = 0x0, magic = 0xffff88810b4c2608, owner = 0x0, curr 0xffff88816ff4bc00, list not empty
WARNING: kernel/locking/rwsem.c:1413 at up_write+0x35c/0x4a0, CPU#1: syz.4.862/12304
Modules linked in:
CPU: 1 UID: 0 PID: 12304 Comm: syz.4.862 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:up_write+0x40f/0x4a0
Code: 0d 8c 49 c7 c2 80 33 0d 8c 4c 0f 44 d0 48 8b 7c 24 10 48 c7 c6 20 36 0d 8c 48 8b 14 24 48 8b 4c 24 08 4d 89 e0 4d 89 f9 41 52 <67> 48 0f b9 3a 48 83 c4 08 e8 f3 6f 45 03 e9 d6 fc ff ff 48 c7 c1
RSP: 0018:ffffc900040cede0 EFLAGS: 00010246
RAX: ffffffff8c0d33a0 RBX: ffff88810b4c2608 RCX: ffff88810b4c2608
RDX: 0000000000000000 RSI: ffffffff8c0d3620 RDI: ffffffff917dda70
RBP: dffffc0000000000 R08: 0000000000000000 R09: ffff88816ff4bc00
R10: ffffffff8c0d33a0 R11: ffffed10216984c3 R12: 0000000000000000
R13: ffff88810b4c2610 R14: ffff88810b4c2660 R15: ffff88816ff4bc00
FS:  00007f0c8bff66c0(0000) GS:ffff8882a7c83000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8981484378 CR3: 00000001ad2de000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 remove_inode_hugepages+0xc57/0x1220
 hugetlbfs_fallocate+0xc51/0x11c0
 vfs_fallocate+0x65a/0x7e0
 madvise_vma_behavior+0x2cf5/0x43b0
 madvise_walk_vmas+0x576/0xb00
 madvise_do_behavior+0x385/0x540
 do_madvise+0x327/0x3a0
 __x64_sys_madvise+0xa6/0xc0
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0c8dd9f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0c8bff6028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
RAX: ffffffffffffffda RBX: 00007f0c8e026450 RCX: 00007f0c8dd9f559
RDX: 0000000000000009 RSI: 0000000000c00000 RDI: 0000200000400000
RBP: 00007f0c8de36b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f0c8e0264e8 R14: 00007f0c8e026450 R15: 00007ffc9fc94698
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.
