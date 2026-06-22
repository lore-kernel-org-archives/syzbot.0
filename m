Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84741A6825
	for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 16:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782145420; cv=none; b=DvzIMlC7NXcwYWNdO6rwiAt+rCJ9N0lLoplgkH9VzfGsqqRlFrwtJNMIp4VAqKYTqDxH5cfy1k2VqxQTLbccePqDiMUszmgYHjZA6OjEcASdiD91NblWa3nHBpl6C4CMBr22vpFWoEMra4FKfbEtG39KzWeHheD0LETqDAABZ/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782145420; c=relaxed/simple;
	bh=fFRF6IXuEx4QbE2GhGFdQJI00qSxgZ+mgziE+GxV4O0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=mdW6t4W/aSSouz2diKz6/x7cUZq/3fUaLTIImnHCZL9z9XZ3EXBSczyM1eeEHuU4mJp7AALDVzwOliCpmkQiITOEBG0heTCEC606nNGyTQcFkrE/KXFwHE10fdTBHUsuNJZ4ksLJrZvUP5GYMJnEQmp25mysJccGZOgvdW4xBss=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e93d89a044so45658a34.1
        for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 09:23:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782145418; x=1782750218;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=VxOh5RUQNgFr8BF2Cr4X3ateApcSdnsMaYcE+Fn2aR8=;
        b=nGO+37LlwLkFQhZ3SqaG6NFIgih3jkAWqDaWsSpZ7aL+6b/DaHHtl6dsDM9wtetVyY
         A0Aiu7mBs22Hnw7ky/T+oCLgwjI94SIE6EWkNIuG7HGUUAMgy0mka9jeEB+PqcaGvo27
         9nk7fZU0a3P5bD/RqxH6A51jXQDMQWhv2OwYfVbsDRZ4HqOUBZ2VdNrRmYW0MEpVICzS
         Le0SZWU6M2i9UnFUMiLSQbyfe/hSUlYN3AO15HVW1PpQ3Ij2C3YUfFJYrrheDn93bROA
         lcOwSaW/BXGfUbs/Y3qwLd1ocjtGcblsq7QEoOAIKA/b0NqL4vfQ3MPyKqQS8ha9NRq5
         uvHA==
X-Gm-Message-State: AOJu0Yz0H43JLcH8LgLR40WhBOxERCbzEsBv5JcIb0azQuGQmgqR8Qrm
	F8QNJmspSn1IZ4WV4M9O3Ak8xREINrxg/L3J2KIhEwMKqH2vJnBbFDsFBIkmqbvOdGx4o+u7THf
	JZeX6fYn+Ysz5UM4sM7vk8lqZn/GA7qHRE2oCBQFIbTna95DrrQS+7qm7f3U=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c8a:b0:69d:8cf6:2e5a with SMTP id
 006d021491bc7-6a112787e04mr115581eaf.23.1782145417730; Mon, 22 Jun 2026
 09:23:37 -0700 (PDT)
Date: Mon, 22 Jun 2026 09:23:37 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a396189.af26c8ab.2133ed.0002.GAE@google.com>
Subject: [moderation/CI] Re: mm: page_ext: add count limit to
 page_ext_iter_next to prevent invalid PFN access
From: syzbot ci <syzbot+ci9034b419fa5cb4c6@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] mm: page_ext: add count limit to page_ext_iter_next to prevent invalid=
 PFN access
https://lore.kernel.org/all/20260622-page_ext-v2-1-135d4cfbc42f@oss.qualcom=
m.com
* [PATCH v2] mm: page_ext: add count limit to page_ext_iter_next to prevent=
 invalid PFN access

and found the following issue:
WARNING in depot_fetch_stack

Full report is available here:
https://ci.syzbot.org/series/092dd7dc-cb78-46b6-8703-6044fff2631d

***

WARNING in depot_fetch_stack

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      e1201ff76176ef666b13d1a4ec6b6190ddc6abc8
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/18f461a2-7098-44bc-9d42-634b56ba48d=
9/config

------------[ cut here ]------------
!refcount_read(&stack->count)
WARNING: lib/stackdepot.c:517 at depot_fetch_stack+0x91/0xa0, CPU#0: kworke=
r/u9:4/1114
Modules linked in:
CPU: 0 UID: 0 PID: 1114 Comm: kworker/u9:4 Not tainted syzkaller #0 PREEMPT=
(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Workqueue: events_unbound call_usermodehelper_exec_work
RIP: 0010:depot_fetch_stack+0x91/0xa0
Code: 39 f5 72 d0 48 8d 3d 7e 1b 4d 0b 89 ee 44 89 f2 89 d9 67 48 0f b9 3a =
31 c0 5b 41 5e 5d e9 87 67 b8 06 cc 90 0f 0b 90 eb ee 90 <0f> 0b 90 eb e8 6=
6 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90
RSP: 0000:ffffc900079a6ce0 EFLAGS: 00010246
RAX: ffff888168b94000 RBX: 0000000000000ce0 RCX: 0000000000000067
RDX: 0000000000000000 RSI: ffffffff8e215937 RDI: ffffffff8c28ab20
RBP: 0000000000000067 R08: ffff88810495a407 R09: 1ffff1102092b480
R10: dffffc0000000000 R11: ffffed102092b481 R12: 00000000019c0068
R13: 0000000000000001 R14: 000000000000010f R15: ffff88810afb1dc0
FS:  0000000000000000(0000) GS:ffff88818dcb5000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __set_page_owner+0x140/0x4c0
 post_alloc_hook+0x1f9/0x250
 get_page_from_freelist+0x21fa/0x2270
 __alloc_frozen_pages_noprof+0x18d/0x380
 alloc_pages_mpol+0x212/0x380
 alloc_pages_noprof+0xac/0x2a0
 get_free_pages_noprof+0xf/0x80
 __kasan_populate_vmalloc+0x38/0x1c0
 alloc_vmap_area+0xd1a/0x1420
 __get_vm_area_node+0x1f2/0x300
 __vmalloc_node_range_noprof+0x358/0x1730
 __vmalloc_node_noprof+0xc2/0x100
 dup_task_struct+0x28e/0x830
 copy_process+0x79d/0x4380
 kernel_clone+0x2d7/0x940
 user_mode_thread+0x110/0x180
 call_usermodehelper_exec_work+0x5c/0x230
 process_scheduled_works+0xa8e/0x14e0
 worker_thread+0xa47/0xfb0
 kthread+0x389/0x470
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[akpm@linux-foundation.org david@kernel.org hannes@cmpxchg.org jackmanb@goo=
gle.com kernel@oss.qualcomm.com ketan.kishore@oss.qualcomm.com liam@infrade=
ad.org linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org luizc=
ap@redhat.com mhocko@suse.com rppt@kernel.org stable@vger.kernel.org surenb=
@google.com vbabka@kernel.org willy@infradead.org ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

