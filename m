Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2A91DDC37
	for <syzbot@lists.linux.dev>; Sat, 18 Jul 2026 03:06:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784343968; cv=none; b=IsbcgOPnEnMOwZ79HtEP9gNyR7T6/jVhr8POEylQq0kUf9LEGdGP5hmDs8KHuwMb1/aHMwPUroUg+u7wCL28pdqdM4d6fN8C0MDJn47005LctIJGWlgRmv73YOwAFn+pBqGSdpn0CxXjMJnToRXR3nWwvQFZTxLs0CyP0zNEM5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784343968; c=relaxed/simple;
	bh=NjLTzugxYDSQkdSZB1Aw2oG/C+NsySCy4Z+RihT1WxM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=SODfZR1nvx4DkIFpmhxIgSvwc1xg75XWRAy8+wzcrHO2gHk1W41sBI4Y0XhWZfLbTqZbNFxLgL0oiXw4cmBcXOnx9i4g8aGTn7KVEd62QxpZNcBQNOtF6bGOQjIrwD3JPmx2dzafOocoKpY9X0GLGHwtirh6ZwcS1ZYLv3h8dWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-49d4cb3ca23so14164955b6e.3
        for <syzbot@lists.linux.dev>; Fri, 17 Jul 2026 20:06:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784343965; x=1784948765;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=mEfwJo1UGgffG3FLAsYT9x3n0RaNqpyXjdEy2DAZK94=;
        b=LXbL0Ux8Cw/xpPzE3Bx1s+rxhp4TSgRP2/i+ttddHatmVWJtFeudeDKAWhw6IFVEX/
         A7RaIJJ1V7PGNwBiwI1jzfvjocHFlu/pAHwSwKCxmrVxnBJuELvbSaemGOWBEy+kXX1j
         BOkP13q7r6P3UKhE/GKgNqEGxlbe3Ne79QNq8z9oBvg8Ud44i2z9kG8p2xHRmHgUBki5
         mC6IX/j0qBJ2OiUvfh+mhe4LupooXkSq0XbyhbQbQP13X98XqDaC6CbIm7i/ZKk6rclM
         hLCnAkcPWbyhH/vkTnITdb1+HrJrzBlY1fURlEzXvPVN7DRNsYnP3xMgZu7akWm5De8s
         lmNA==
X-Gm-Message-State: AOJu0YyDjX89t5EuPwSKh5jRcz+Bh9vIOnWYKJhDuAryDi5PuqI/K/Qt
	U+fX/EkY33yEzrDS/6hS6f0/4V8X149J7MgrV7QpZIfCokbsx5ZtJQ09xCJDoaiakSsFBLVsWDC
	ISQ2znQ05Hqu/0FRNQh7iCsO+3McuUlrRK6W4v/BjuQgyEpclzxgY9fpNmq8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1646:b0:4a4:c7c1:dab2 with SMTP id
 5614622812f47-4a4d04f5bd7mr2723594b6e.31.1784343965365; Fri, 17 Jul 2026
 20:06:05 -0700 (PDT)
Date: Fri, 17 Jul 2026 20:06:05 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5aed9d.f1649fcc.2a4208.0278.GAE@google.com>
Subject: [moderation/CI] Re: mm/rmap: index MAP_PRIVATE file-backed folios by
 virt pgoff
From: syzbot ci <syzbot+ci5e34f4683bcffe49@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] mm/rmap: index MAP_PRIVATE file-backed folios by virt pgoff
https://lore.kernel.org/all/20260717-b4-scalable-cow-virt-pgoff-v1-0-cf2491=
0ef094@kernel.org
* [PATCH 01/15] mm/vma: introduce VMA virtual page offset field and add hel=
pers
* [PATCH 02/15] mm: introduce linear_virt_page_index()
* [PATCH 03/15] mm: abstract vma_address() and introduce vma_anon_address()
* [PATCH 04/15] mm: update print_bad_page_map() to show virtual page index
* [PATCH 05/15] mm: introduce and use vma_filebacked_address()
* [PATCH 06/15] mm: propagate VMA virtual page offset on map, remap, split =
+ merge
* [PATCH 07/15] mm/rmap: track whether the page VMA mapped walk is anonymou=
s
* [PATCH 08/15] mm: introduce and use linear_folio_page_index()
* [PATCH 09/15] mm/rmap: use virt pgoff for MAP_PRIVATE file-backed anon fo=
lios
* [PATCH 10/15] tools/testing/vma: expand VMA merge tests to assert virt pg=
off
* [PATCH 11/15] tools/testing/selftests/mm: test virtual page offset merge =
behaviour
* [PATCH 12/15] mm/vma: only permit MAP_PRIVATE /dev/zero to be mapped anon=
ymous
* [PATCH 13/15] mm/vma: make MAP_PRIVATE-mapped /dev/zero mappings truly an=
onymous
* [PATCH 14/15] tools/testing/vma: add test to assert MAP_PRIVATE-/dev/zero=
 is anon
* [PATCH 15/15] tools/testing/selftests/mm: add MAP_PRIVATE-/dev/zero merge=
 tests

and found the following issue:
general protection fault in mapping_wrprotect_range_one

Full report is available here:
https://ci.syzbot.org/series/b5c827e8-78a4-494c-b925-417c34a60e85

***

general protection fault in mapping_wrprotect_range_one

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      5093dba1014c1d7f7e247fd118f0fa8f22136046
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/0d856612-f1b4-4e6e-86af-4ed3215225a=
a/config
syz repro: https://ci.syzbot.org/findings/3484dc14-c12f-477e-b14a-6b249c47b=
2fd/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000003: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 UID: 0 PID: 32 Comm: kworker/1:1 Not tainted syzkaller #0 PREEMPT(fu=
ll)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Workqueue: events fb_deferred_io_work
RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
RIP: 0010:mapping_wrprotect_range_one+0x147/0x230 mm/rmap.c:1246
Code: 7c 24 40 49 8d 7f 28 ba 18 00 00 00 31 f6 e8 e0 2e 14 00 48 c7 84 24 =
80 00 00 00 01 00 00 00 49 83 c6 18 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00 7=
4 08 4c 89 f7 e8 ea 2b 14 00 4d 8b 36 44 89 f6 83
RSP: 0018:ffffc90000a777c0 EFLAGS: 00010206
RAX: 0000000000000003 RBX: ffffc90000a779e0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000a77840
RBP: ffffc90000a778e0 R08: ffffc90000a7783f R09: 0000000000000000
R10: ffffc90000a77828 R11: fffff5200014ef08 R12: dffffc0000000000
R13: 1ffff9200014eefc R14: 0000000000000018 R15: ffffc90000a77800
FS:  0000000000000000(0000) GS:ffff8882a920c000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f84a91e9c38 CR3: 000000000e746000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __rmap_walk_file+0x4cd/0x6a0 mm/rmap.c:3116
 mapping_wrprotect_range+0x110/0x180 mm/rmap.c:1294
 fb_deferred_io_work+0x15a/0x310 drivers/video/fbdev/core/fb_defio.c:399
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:folio_test_anon include/linux/page-flags.h:718 [inline]
RIP: 0010:mapping_wrprotect_range_one+0x147/0x230 mm/rmap.c:1246
Code: 7c 24 40 49 8d 7f 28 ba 18 00 00 00 31 f6 e8 e0 2e 14 00 48 c7 84 24 =
80 00 00 00 01 00 00 00 49 83 c6 18 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00 7=
4 08 4c 89 f7 e8 ea 2b 14 00 4d 8b 36 44 89 f6 83
RSP: 0018:ffffc90000a777c0 EFLAGS: 00010206
RAX: 0000000000000003 RBX: ffffc90000a779e0 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90000a77840
RBP: ffffc90000a778e0 R08: ffffc90000a7783f R09: 0000000000000000
R10: ffffc90000a77828 R11: fffff5200014ef08 R12: dffffc0000000000
R13: 1ffff9200014eefc R14: 0000000000000018 R15: ffffc90000a77800
FS:  0000000000000000(0000) GS:ffff8882a920c000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000025d35e991000 CR3: 0000000110c34000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	7c 24                	jl     0x26
   2:	40                   	rex
   3:	49 8d 7f 28          	lea    0x28(%r15),%rdi
   7:	ba 18 00 00 00       	mov    $0x18,%edx
   c:	31 f6                	xor    %esi,%esi
   e:	e8 e0 2e 14 00       	call   0x142ef3
  13:	48 c7 84 24 80 00 00 	movq   $0x1,0x80(%rsp)
  1a:	00 01 00 00 00
  1f:	49 83 c6 18          	add    $0x18,%r14
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruct=
ion
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 ea 2b 14 00       	call   0x142c23
  39:	4d 8b 36             	mov    (%r14),%r14
  3c:	44 89 f6             	mov    %r14d,%esi
  3f:	83                   	.byte 0x83


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
[akpm@linux-foundation.org apopple@nvidia.com arnd@arndb.de baohua@kernel.o=
rg baolin.wang@linux.alibaba.com byungchul@sk.com chengming.zhou@linux.dev =
david@kernel.org dev.jain@arm.com gourry@gourry.net gregkh@linuxfoundation.=
org harry@kernel.org jack@suse.cz jannh@google.com joshua.hahnjy@gmail.com =
kees@kernel.org lance.yang@linux.dev liam@infradead.org linmiaohe@huawei.co=
m linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-kselftes=
t@vger.kernel.org linux-mm@kvack.org ljs@kernel.org matthew.brost@intel.com=
 mhocko@suse.com nao.horiguchi@gmail.com npache@redhat.com peterx@redhat.co=
m pfalcato@suse.de rakie.kim@sk.com riel@surriel.com rppt@kernel.org ryan.r=
oberts@arm.com surenb@google.com usama.arif@linux.dev vbabka@kernel.org wil=
ly@infradead.org xu.xin16@zte.com.cn ying.huang@linux.alibaba.com ziy@nvidi=
a.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

