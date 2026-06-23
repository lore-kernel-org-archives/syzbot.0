Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D95A02D1F40
	for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 13:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782220040; cv=none; b=Pcgx+laewC+UEZ4gYZvsQjopBQYrdW2u2hLLN/SHWzudUV1s/aO0sOZ8Jl+6Ag7cSzMbRFXxVcfizP8e+uVEd3PCsOFJyNNY4Ikyeg/0tBiKGSPpxYeQQi7L6hYahyHl61vKGdwtFl8lmMkF7XucE29KGIq6NimE+vRSg7Z2lD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782220040; c=relaxed/simple;
	bh=xmJgMJ9gqp3jn6ISpWdCQJitCzvBj9nlmQU3GGcNu0E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=hk4EV263O+c1KhTNBu8+B9jFcTP+Ow9G/EL0F1OVQF1XS9oZskZ2+1uHxg28gRpgQLCJm1O+PmsNKMGSkFoK55ACC/OFyw3dTQA8lTf53dFDHCS/WiXD9WHyioPGElheT81CycnxGXIHgZOuS0rfjKR2rBUxzqojPhiDk4ckT/8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-486e64c8edeso7300347b6e.2
        for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 06:07:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782220038; x=1782824838;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Dujm46FtRCrDXA2pYLvEnj2Wk1ykOcLsrNEEue3QPVY=;
        b=d5clN3tGOUC/gEjXwzrzMGb7BEt5mpbOeXyiJYq4ydfpe8rzlKXJj2PG5YrPTfHFjk
         lTZdK+ZG8PSUjHnvLUj3amJM6xwQ3xk4G80E7xA6VdKSnrQWoC1BrRsm7TkoXrZ3ZdeT
         rGqHXJW4aJJnRvUwyYd1vFh1+XN0lVEr6hT9RTbX1hFJ5jpLcc7Eqwsuv1F3JfFazgOY
         QftS+HMDhXR3xpIyfrbSCcG6mNt/2Jsizpm6TKECfTzMLBtSsr7Gv6EsE+wnkZKcZ8wb
         +wcUdcardzOTB0eSjepIRn9Zksfvw+4M4sDJ7TF5AkW4p6LYX8OWQuzBqyj7IS3wvdnN
         FgWw==
X-Gm-Message-State: AOJu0YzL+vNBpfenZIe27Plr051/MBrb1D1Fr6bzQHucZH5iEwkvpkrw
	CjApl5I2TRJ3kZqygEyInHdZwOUbiT4HoCAHGMhfujXtSuwbQYi04AtVbgQu2d2lPH1V77g5W1q
	DiQau5uAtRVkqv3qG6lGQFdZ8v3tIIaLHCp37V3LZZ+/BjoLvIiDAib2LdJI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f21:b0:489:6ad8:404d with SMTP id
 5614622812f47-48f2a7c4049mr1768847b6e.41.1782220037917; Tue, 23 Jun 2026
 06:07:17 -0700 (PDT)
Date: Tue, 23 Jun 2026 06:07:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3a8505.52ae72c2.136ac7.0007.GAE@google.com>
Subject: [moderation/CI] Re: ext4: deferred iput framework for EA inodes
From: syzbot ci <syzbot+ci292489c3bc18db75@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v9] ext4: deferred iput framework for EA inodes
https://lore.kernel.org/all/20260623083540.2744885-1-yun.zhou@windriver.com
* [PATCH v9 1/4] fs: add iput_if_not_last() helper
* [PATCH v9 2/4] ext4: introduce ext4_put_ea_inode() for safe deferred iput
* [PATCH v9 3/4] ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
* [PATCH v9 4/4] ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()

and found the following issue:
WARNING: ODEBUG bug in flush_delayed_work

Full report is available here:
https://ci.syzbot.org/series/acc1a7bd-816f-451e-86ee-a62f88ad8fcc

***

WARNING: ODEBUG bug in flush_delayed_work

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      502d801f0ab03e4f32f9a33d203154ce84887921
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/79d2cdf0-fde6-4e70-a88c-04d44c9d3e44/config
syz repro: https://ci.syzbot.org/findings/9b2e3f5d-279a-469f-9f2a-05f96ea11587/syz_repro

EXT4-fs warning (device loop2): ext4_multi_mount_protect:287: Invalid MMP block in superblock
------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object: ffff8881bf08c9e0 object type: timer_list hint: 0x0
WARNING: lib/debugobjects.c:632 at debug_print_object+0xec/0x230 lib/debugobjects.c:629, CPU#1: syz.2.19/5833
Modules linked in:
CPU: 1 UID: 0 PID: 5833 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:debug_print_object+0x18a/0x230 lib/debugobjects.c:629
Code: f8 48 c1 e8 03 80 3c 18 00 74 08 4c 89 ff e8 5d 04 71 fd 4d 8b 0f 4c 89 ef 48 8b 74 24 08 48 89 ea 44 89 e1 4d 89 f0 ff 34 24 <67> 48 0f b9 3a 48 83 c4 08 ff 05 a3 23 70 0b 48 83 c4 10 5b 41 5c
RSP: 0018:ffffc9000179f848 EFLAGS: 00010046

RAX: 1ffffffff179eacc RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffffffff8c2a9980 RSI: ffffffff8c2a93e0 RDI: ffffffff903ddbf0
RBP: ffffffff8c2a9980 R08: ffff8881bf08c9e0 R09: ffffffff8bcf69c0
R10: dffffc0000000000 R11: ffffffff81b25990 R12: 0000000000000000
R13: ffffffff903ddbf0 R14: ffff8881bf08c9e0 R15: ffffffff8bcf5660
FS:  00007fd11e12e6c0(0000) GS:ffff8882a922d000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffe46d80f88 CR3: 00000001bf40e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 debug_object_assert_init+0x237/0x370 lib/debugobjects.c:1075
 debug_timer_assert_init kernel/time/timer.c:803 [inline]
 debug_assert_init kernel/time/timer.c:848 [inline]
 __try_to_del_timer_sync kernel/time/timer.c:1457 [inline]
 __timer_delete_sync+0x181/0x520 kernel/time/timer.c:1621
 flush_delayed_work+0x48/0x100 kernel/workqueue.c:4414
 ext4_drain_ea_inode_work fs/ext4/xattr.h:196 [inline]
 __ext4_fill_super fs/ext4/super.c:5795 [inline]
 ext4_fill_super+0x54c7/0x66d0 fs/ext4/super.c:5844
 get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1634
 vfs_get_tree+0x92/0x2a0 fs/super.c:1694
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3765 [inline]
 do_new_mount+0x319/0xdc0 fs/namespace.c:3841
 do_mount fs/namespace.c:4174 [inline]
 __do_sys_mount fs/namespace.c:4390 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4367
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fd11d19e0ca
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fd11e12de58 EFLAGS: 00000246
 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007fd11e12dee0 RCX: 00007fd11d19e0ca
RDX: 0000200000000400 RSI: 0000200000000340 RDI: 00007fd11e12dea0
RBP: 0000200000000400 R08: 00007fd11e12dee0 R09: 000000000021c91c
R10: 000000000021c91c R11: 0000000000000246 R12: 0000200000000340
R13: 00007fd11e12dea0 R14: 000000000000051a R15: 0000200000000240
 </TASK>
----------------
Code disassembly (best guess):
   0:	f8                   	clc
   1:	48 c1 e8 03          	shr    $0x3,%rax
   5:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1)
   9:	74 08                	je     0x13
   b:	4c 89 ff             	mov    %r15,%rdi
   e:	e8 5d 04 71 fd       	call   0xfd710470
  13:	4d 8b 0f             	mov    (%r15),%r9
  16:	4c 89 ef             	mov    %r13,%rdi
  19:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  1e:	48 89 ea             	mov    %rbp,%rdx
  21:	44 89 e1             	mov    %r12d,%ecx
  24:	4d 89 f0             	mov    %r14,%r8
  27:	ff 34 24             	push   (%rsp)
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	48 83 c4 08          	add    $0x8,%rsp
  33:	ff 05 a3 23 70 0b    	incl   0xb7023a3(%rip)        # 0xb7023dc
  39:	48 83 c4 10          	add    $0x10,%rsp
  3d:	5b                   	pop    %rbx
  3e:	41 5c                	pop    %r12


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
[adilger.kernel@dilger.ca jack@suse.cz libaokun@linux.alibaba.com linux-ext4@vger.kernel.org linux-kernel@vger.kernel.org ojaswin@linux.ibm.com ritesh.list@gmail.com tytso@mit.edu yi.zhang@huawei.com yun.zhou@windriver.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

