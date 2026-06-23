Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD5035AC33
	for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 14:34:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782225266; cv=none; b=XX0L5zcS5ASsbgOuJUtgmXs0GQ8TZzOGwNw/Okim/NVlPp/aiM6y9p+jY7H0eZiDvx6PxzhtbMqUof+ABNwhFwLoTug0gc5uGqrFkBhjk3bCwOClbK1tUBlMPQDC2Z+FDO2W3XRpmxZfQCqBW3TYnIsbe492g/pgmbGoAv/vU+g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782225266; c=relaxed/simple;
	bh=om1G7QSd/8NHeDkiRZ8w+B7m9xoGD3cuzHQ1mEF7qdY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=i/R/lnVbU+hWnRewTfzDuK0st9xypALUY8jjW7EKh8dKiOb/9XuDT7umYF/wh3K57aUP2cFHlBrOkLCJFNXZf5U2t6mXmvsUoZJE1X/uVhFVzi8cdRiE91Pghz23YmD3f6hkvnvDrZ7grxQ0Jzqf8HuUhJUYe9Ern1ynzcR2CtA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-486d0cff483so11047967b6e.2
        for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 07:34:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782225264; x=1782830064;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6FYseiaFKV8qz74dJrBrFN47qSjOXkLsW7IavZocLpY=;
        b=PaytqIGcXQxztwAy4DsrxZLLpKH4ntwQkVJNv2W4L8Noex4/oEIJp5jTHwaHyfqv3s
         QOIgzU4kMADXoKASdYIfvRt30mlh+nBS444lxt+u8zRKqbaUDtafgH4h7gu8geP7Q/zR
         zkcLD1Se0VZHzj6K3/Bv7iTwNpxsJFX1CJ5TZ7cikxKPXC6GP5TY5ahLd8Z4dVQIwBHp
         1iEgXhx08LO0x64DL/zHX/ZN8mhMD1D6LB5FXlf0BTorySeJdbCw3r6R+yFP/J++btUC
         JbmxgFDthZzGSqlYtXpvdlf2UhA8+X81ueICKki7oeWD7OolSDmXw+KDFrMrALYuOPYA
         Us/w==
X-Gm-Message-State: AOJu0Yz6yqlBZCvUwzKPfU47hP6S04PkZjARy0vSdpos3VdZ1q3WEoT0
	59SWtSxVRc+45eS6+9gHbCHjiMLuyXoFWUmIgoxEGB9bOjIANA+M8GjdflMyHGXibRBnA9uaV+/
	jQl1f+SstImEgBJKUcYYlK0xZaY2QMOMcCoVR+q20IGD+yLz5Z1mNV4JmM/Y=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:2219:b0:487:28a2:9b8e with SMTP id
 5614622812f47-48f27a2bfacmr2089284b6e.13.1782225263788; Tue, 23 Jun 2026
 07:34:23 -0700 (PDT)
Date: Tue, 23 Jun 2026 07:34:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3a996f.52ae72c2.136ac7.0008.GAE@google.com>
Subject: [moderation/CI] Re: namespace-aware configfs
From: syzbot ci <syzbot+ci6bfcafa8d238824b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] namespace-aware configfs
https://lore.kernel.org/all/20260623-configfs-ns-v3-0-841c100fd5dd@kernel.org
* [PATCH RFC v3 01/12] fs/configfs: rework configfs_is_root()
* [PATCH RFC v3 02/12] fs/configfs: dynamically allocate super_info
* [PATCH RFC v3 03/12] fs/configfs: separate out configfs_{link,unlink}_root()
* [PATCH RFC v3 04/12] fs/configfs: add superblock as attribute to configfs_pin_fs()
* [PATCH RFC v3 05/12] fs/configfs: add 'fill_subsystem' and 'clear_subsystem' callbacks
* [PATCH RFC v3 06/12] fs/namespace: implement mnt_clone_direct()
* [PATCH RFC v3 07/12] fs/configfs: switch to get_tree_keyed()
* [PATCH RFC v3 08/12] fs/configfs: open-code simple_pin_fs()
* [PATCH RFC v3 09/12] nvmet: make discovery subsystem dynamic
* [PATCH RFC v3 10/12] nvmet: per net-namespace port list
* [PATCH RFC v3 11/12] nvmet: make configfs setup namespace aware
* [PATCH RFC v3 12/12] nvmet: enable transports for net namespaces

and found the following issue:
BUG: sleeping function called from invalid context in configfs_get_super_info

Full report is available here:
https://ci.syzbot.org/series/f460be5a-d520-4bc1-9cfb-6492f841629b

***

BUG: sleeping function called from invalid context in configfs_get_super_info

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      66affa37cfac0aec061cc4bcf4a065b0c52f7e19
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/73803fa0-5ba4-4d03-976f-f9962ee982c8/config
syz repro: https://ci.syzbot.org/findings/4102267c-e678-4ffc-9ac0-4fb2dcbe5c0d/syz_repro

BUG: sleeping function called from invalid context at ./include/linux/sched/mm.h:323
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5856, name: syz.0.17
preempt_count: 1, expected: 0
RCU nest depth: 0, expected: 0
INFO: lockdep is turned off.
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 0 UID: 0 PID: 5856 Comm: syz.0.17 Tainted: G        W           syzkaller #0 PREEMPT(full) 
Tainted: [W]=WARN
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9193
 might_alloc include/linux/sched/mm.h:323 [inline]
 slab_pre_alloc_hook mm/slub.c:4559 [inline]
 slab_alloc_node mm/slub.c:4916 [inline]
 __kmalloc_cache_noprof+0x74/0x660 mm/slub.c:5446
 _kmalloc_noprof include/linux/slab.h:969 [inline]
 _kzalloc_noprof include/linux/slab.h:1286 [inline]
 configfs_get_super_info+0x218/0x5e0 fs/configfs/mount.c:91
 configfs_get_tree+0x41/0xd0 fs/configfs/mount.c:170
 vfs_get_tree+0x92/0x2a0 fs/super.c:1694
 vfs_cmd_create+0xa2/0x200 fs/fsopen.c:231
 __do_sys_fsconfig fs/fsopen.c:463 [inline]
 __se_sys_fsconfig+0x6b9/0x810 fs/fsopen.c:350
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5c9db9ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5c9ea71028 EFLAGS: 00000246 ORIG_RAX: 00000000000001af
RAX: ffffffffffffffda RBX: 00007f5c9de15fa0 RCX: 00007f5c9db9ce59
RDX: 0000000000000000 RSI: 0000000000000006 RDI: 0000000000000003
RBP: 00007f5c9dc32e6f R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f5c9de16038 R14: 00007f5c9de15fa0 R15: 00007ffe63465d98
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
[a.hindborg@kernel.org brauner@kernel.org hare@kernel.org hch@lst.de jack@suse.cz kch@nvidia.com leitao@debian.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-nvme@lists.infradead.org sagi@grimberg.me viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

