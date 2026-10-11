Received: from mail-oa1-f69.google.com (mail-oa1-f69.google.com [209.85.160.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70BA223E334
	for <syzbot@lists.linux.dev>; Sun, 11 Oct 2026 16:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791735833; cv=none; b=rxRv8A1/88Iwz5Yl24I6i1HvkwLH57l633OPEOlFkZ0zqTD/gtRWlTYPObFTasEJEs/HuDLnMOSY+kqjcV4+jPzRk/YWgQIgiQRWrlsM3lqGuChqjVAK8Hlmpl1jpneXAcdLS7MyMqg4CYcWnRxGEEknhQdYhEKcY/or//ddJp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791735833; c=relaxed/simple;
	bh=JUwjomTlAKVJV5nYwGFv2nU/PWDojowyesQQwPj5t2Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=A/958G4/C/U1VqnulweujbKv4S1MP0GPNfRiTWze1jXr5p+tIhQnRkObuHrp2tPtzDPn5kRBUVwH3EV8uyXp3d8gBaStjlr9/4UwX0jZKdIamso6Fhzgm5VEkMJY+xbYYSbxbgnqx1S4wLRdO2cqBa91skQr/rv0fzsYAuflFX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f69.google.com with SMTP id 586e51a60fabf-45e6091d8a1so1156687fac.1
        for <syzbot@lists.linux.dev>; Sun, 11 Oct 2026 09:23:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791735824; x=1792340624;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=3YrgsTRGa2qmLgFiS7PKDXFLCFAqgOsjj7OVvrJxYfk=;
        b=b7ctJDw8gFb9AWSnfR/gnPO5rSEn9XleUkefZ1Ns+9BSgCJLRlfskaIQsRjJJsEXkj
         I9DRJdSt99aRrEfnM2vsOGQEc5h66nvTPcrLFp5CNRqpQURCx4exTMIdG+gYrYHrm08n
         6rGDpjI4/f0SeW01CW7KAkgxn69dyF0a41/IbPTo4a66GAB7TSMnEZegorUf7BbUjEyy
         4IuT0PMN2w3Mv3pURUT9dQ9OaGutlDB5pU/qIiG9EaHkxgbGSfE5IkeOGKf1RxOsgnxB
         l153wy7CZowKLGrtQL49Yu8pn2bu17h35ZryBhlEDbdwJDXEEdVHG4Any4dOucawExkK
         LbPQ==
X-Gm-Message-State: AFq9FYKVWjIhtM26/DjszCMEjNjH7Go6VVh+d2AdpGXyCBCGcuyE0nHn
	Tabw+lmK2wp3/5zpQ23EXuVaWJmJfN6vFN/4ZOAalgfkNsYlLRrecIQx+ZpA4FhHcYMj3kfeA0A
	sl6vRw0F/XA6o+s1FQIM7P1CZ1UNEFgM6DZQon1pSjqLsK92XReAJY+ktQmU=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:191e:b0:4f9:6348:cd3b with SMTP id
 5614622812f47-50c55b860a9mr7820798b6e.41.1791735824196; Sun, 11 Oct 2026
 09:23:44 -0700 (PDT)
Date: Sun, 11 Oct 2026 09:23:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6acbb810.bbc4c7f9.15faa7.0086.GAE@google.com>
Subject: [moderation/CI] Re: loop: Detect write requests that failed to wait
 for completion.
From: syzbot ci <syzbot+ci6aeba55b683f90f0@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] loop: Detect write requests that failed to wait for completion.
https://lore.kernel.org/all/696e5e7c-e3f1-4181-be2a-8915fd1753cf@I-love.SAKURA.ne.jp
* [PATCH v2] loop: Detect write requests that failed to wait for completion.

and found the following issues:
* BUG: loop0 has no users, but backend found I/O issued by syz.NUM.NUM/NUM.
* BUG: loop1 has no users, but backend found I/O issued by syz.NUM.NUM/NUM.
* BUG: loop2 has no users, but backend found I/O issued by syz.NUM.NUM/NUM.
* BUG: loop3 has no users, but backend found I/O issued by syz.NUM.NUM/NUM.
* BUG: loop4 has no users, but backend found I/O issued by syz.NUM.NUM/NUM.

Full report is available here:
https://ci.syzbot.org/series/76836433-2e8b-4ec6-910a-ff3ed4a39a9d

***

BUG: loop0 has no users, but backend found I/O issued by syz.NUM.NUM/NUM.

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      4da93acb4f2ed06640255ad98801d0f0c734ff07
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a9ce0306-33bb-438b-b7e8-a71d334ea05a/config
syz repro: https://ci.syzbot.org/findings/697b1531-4355-43f2-abf4-67f34fb95053/syz_repro

BUG: loop0 has no users, but backend found I/O issued by syz.0.19/5781.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.19/5781.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.19/5781.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.47/5809.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f


***

BUG: loop1 has no users, but backend found I/O issued by syz.NUM.NUM/NUM.

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      4da93acb4f2ed06640255ad98801d0f0c734ff07
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a9ce0306-33bb-438b-b7e8-a71d334ea05a/config
syz repro: https://ci.syzbot.org/findings/b07804ae-02b6-47e8-8a4b-462c9ca5d6e3/syz_repro

BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.25/5812.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.27/5816.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.65/5953.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.98/6019.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.98/6019.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.98/6019.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.98/6019.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.98/6019.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop0 has no users, but backend found I/O issued by syz.0.98/6019.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop1 has no users, but backend found I/O issued by syz.1.124/6071.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f


***

BUG: loop2 has no users, but backend found I/O issued by syz.NUM.NUM/NUM.

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      4da93acb4f2ed06640255ad98801d0f0c734ff07
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a9ce0306-33bb-438b-b7e8-a71d334ea05a/config
syz repro: https://ci.syzbot.org/findings/e242f078-0279-4480-a331-d902d1ccb008/syz_repro

BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop2 has no users, but backend found I/O issued by syz.2.35/5886.
Call Trace:
     loop_queue_rq+0x82/0xcb0 drivers/block/loop.c:1890
     __blk_mq_issue_directly block/blk-mq.c:2708 [inline]
     blk_mq_try_issue_directly+0x3f4/0x880 block/blk-mq.c:2768
     blk_mq_submit_bio+0x21de/0x2bb0 block/blk-mq.c:3220
     __submit_bio_noacct_mq block/blk-core.c:756 [inline]
     submit_bio_noacct_nocheck+0x2f4/0xa40 block/blk-core.c:790
     bh_submit fs/buffer.c:1146 [inline]
     __bh_read fs/buffer.c:2943 [inline]
     bh_readahead include/linux/buffer_head.h:437 [inline]
     __breadahead+0x15c/0x1f0 fs/buffer.c:1359
     nilfs_search_super_root+0x2be/0x1530 fs/nilfs2/recovery.c:891
     load_nilfs+0x363/0xfb0 fs/nilfs2/the_nilfs.c:259
     nilfs_fill_super+0x1a0/0x4e0 fs/nilfs2/super.c:1073
     nilfs_get_tree+0x491/0x850 fs/nilfs2/super.c:1226
     vfs_get_tree+0x92/0x2a0 fs/super.c:1932
     fc_mount fs/namespace.c:1198 [inline]
     do_new_mount_fc fs/namespace.c:3772 [inline]
     do_new_mount+0x319/0xdc0 fs/namespace.c:3848
     do_mount fs/namespace.c:4181 [inline]
     __do_sys_mount fs/namespace.c:4397 [inline]
     __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
     do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
     do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
     entry_SYSCALL_64_after_hwframe+0x77/0x7f


***

BUG: loop3 has no users, but backend found I/O issued by syz.NUM.NUM/NUM.

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      4da93acb4f2ed06640255ad98801d0f0c734ff07
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a9ce0306-33bb-438b-b7e8-a71d334ea05a/config
AI triage: https://ci.syzbot.org/findings/abd85940-485e-443b-acb7-5a684fdd8cb9/triage_trajectory

BUG: loop3 has no users, but backend found I/O issued by syz.3.573/12573.
Call Trace:
     loop_queue_rq+0x82/0xcb0
     blk_mq_try_issue_directly+0x3f4/0x880
     blk_mq_submit_bio+0x21de/0x2bb0
     submit_bio_noacct_nocheck+0x2f4/0xa40
     ocfs2_read_blocks+0x85e/0x14d0
     ocfs2_read_virt_blocks+0x3e5/0x9c0
     ocfs2_find_entry+0x3c3/0x2050
     ocfs2_find_files_on_disk+0xe0/0x340
     ocfs2_lookup_ino_from_name+0x52/0x100
     ocfs2_get_system_file_inode+0x32f/0x810
     ocfs2_init_global_system_inodes+0x318/0x6e0
     ocfs2_fill_super+0x456e/0x6840
     get_tree_bdev_flags+0x430/0x4f0
     vfs_get_tree+0x92/0x2a0
     do_new_mount+0x319/0xdc0
     __se_sys_mount+0x31d/0x420
     do_syscall_64+0x166/0x520
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop3 has no users, but backend found I/O issued by syz.3.573/12573.
Call Trace:
     loop_queue_rq+0x82/0xcb0
     blk_mq_try_issue_directly+0x3f4/0x880
     blk_mq_submit_bio+0x21de/0x2bb0
     submit_bio_noacct_nocheck+0x2f4/0xa40
     ocfs2_read_blocks+0x85e/0x14d0
     ocfs2_read_virt_blocks+0x3e5/0x9c0
     ocfs2_find_entry+0x3c3/0x2050
     ocfs2_find_files_on_disk+0xe0/0x340
     ocfs2_lookup_ino_from_name+0x52/0x100
     ocfs2_get_system_file_inode+0x32f/0x810
     ocfs2_init_global_system_inodes+0x318/0x6e0
     ocfs2_fill_super+0x456e/0x6840
     get_tree_bdev_flags+0x430/0x4f0
     vfs_get_tree+0x92/0x2a0
     do_new_mount+0x319/0xdc0
     __se_sys_mount+0x31d/0x420
     do_syscall_64+0x166/0x520
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop3 has no users, but backend found I/O issued by syz.3.573/12573.
Call Trace:
     loop_queue_rq+0x82/0xcb0
     blk_mq_try_issue_directly+0x3f4/0x880
     blk_mq_submit_bio+0x21de/0x2bb0
     submit_bio_noacct_nocheck+0x2f4/0xa40
     ocfs2_read_blocks+0x85e/0x14d0
     ocfs2_read_virt_blocks+0x3e5/0x9c0
     ocfs2_find_entry+0x3c3/0x2050
     ocfs2_find_files_on_disk+0xe0/0x340
     ocfs2_lookup_ino_from_name+0x52/0x100
     ocfs2_get_system_file_inode+0x32f/0x810
     ocfs2_init_global_system_inodes+0x318/0x6e0
     ocfs2_fill_super+0x456e/0x6840
     get_tree_bdev_flags+0x430/0x4f0
     vfs_get_tree+0x92/0x2a0
     do_new_mount+0x319/0xdc0
     __se_sys_mount+0x31d/0x420
     do_syscall_64+0x166/0x520
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop3 has no users, but backend found I/O issued by syz.3.573/12573.
Call Trace:
     loop_queue_rq+0x82/0xcb0
     blk_mq_try_issue_directly+0x3f4/0x880
     blk_mq_submit_bio+0x21de/0x2bb0
     submit_bio_noacct_nocheck+0x2f4/0xa40
     ocfs2_read_blocks+0x85e/0x14d0
     ocfs2_read_virt_blocks+0x3e5/0x9c0
     ocfs2_find_entry+0x3c3/0x2050
     ocfs2_find_files_on_disk+0xe0/0x340
     ocfs2_lookup_ino_from_name+0x52/0x100
     ocfs2_get_system_file_inode+0x32f/0x810
     ocfs2_init_global_system_inodes+0x318/0x6e0
     ocfs2_fill_super+0x456e/0x6840
     get_tree_bdev_flags+0x430/0x4f0
     vfs_get_tree+0x92/0x2a0
     do_new_mount+0x319/0xdc0
     __se_sys_mount+0x31d/0x420
     do_syscall_64+0x166/0x520
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop3 has no users, but backend found I/O issued by syz.3.573/12573.
Call Trace:
     loop_queue_rq+0x82/0xcb0
     blk_mq_try_issue_directly+0x3f4/0x880
     blk_mq_submit_bio+0x21de/0x2bb0
     submit_bio_noacct_nocheck+0x2f4/0xa40
     ocfs2_read_blocks+0x85e/0x14d0
     ocfs2_read_virt_blocks+0x3e5/0x9c0
     ocfs2_find_entry+0x3c3/0x2050
     ocfs2_find_files_on_disk+0xe0/0x340
     ocfs2_lookup_ino_from_name+0x52/0x100
     ocfs2_get_system_file_inode+0x32f/0x810
     ocfs2_init_global_system_inodes+0x318/0x6e0
     ocfs2_fill_super+0x456e/0x6840
     get_tree_bdev_flags+0x430/0x4f0
     vfs_get_tree+0x92/0x2a0
     do_new_mount+0x319/0xdc0
     __se_sys_mount+0x31d/0x420
     do_syscall_64+0x166/0x520
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop3 has no users, but backend found I/O issued by syz.3.573/12573.
Call Trace:
     loop_queue_rq+0x82/0xcb0
     blk_mq_try_issue_directly+0x3f4/0x880
     blk_mq_submit_bio+0x21de/0x2bb0
     submit_bio_noacct_nocheck+0x2f4/0xa40
     ocfs2_read_blocks+0x85e/0x14d0
     ocfs2_read_virt_blocks+0x3e5/0x9c0
     ocfs2_find_entry+0x3c3/0x2050
     ocfs2_find_files_on_disk+0xe0/0x340
     ocfs2_lookup_ino_from_name+0x52/0x100
     ocfs2_get_system_file_inode+0x32f/0x810
     ocfs2_init_global_system_inodes+0x318/0x6e0
     ocfs2_fill_super+0x456e/0x6840
     get_tree_bdev_flags+0x430/0x4f0
     vfs_get_tree+0x92/0x2a0
     do_new_mount+0x319/0xdc0
     __se_sys_mount+0x31d/0x420
     do_syscall_64+0x166/0x520
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop3 has no users, but backend found I/O issued by syz.3.573/12573.
Call Trace:
     loop_queue_rq+0x82/0xcb0
     blk_mq_try_issue_directly+0x3f4/0x880
     blk_mq_submit_bio+0x21de/0x2bb0
     submit_bio_noacct_nocheck+0x2f4/0xa40
     ocfs2_read_blocks+0x85e/0x14d0
     ocfs2_read_virt_blocks+0x3e5/0x9c0
     ocfs2_find_entry+0x3c3/0x2050
     ocfs2_find_files_on_disk+0xe0/0x340
     ocfs2_lookup_ino_from_name+0x52/0x100
     ocfs2_get_system_file_inode+0x32f/0x810
     ocfs2_init_global_system_inodes+0x318/0x6e0
     ocfs2_fill_super+0x456e/0x6840
     get_tree_bdev_flags+0x430/0x4f0
     vfs_get_tree+0x92/0x2a0
     do_new_mount+0x319/0xdc0
     __se_sys_mount+0x31d/0x420
     do_syscall_64+0x166/0x520
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
ntfs3(loop9): ino=5, mi_enum_attr
ntfs3(loop9): ino=5, mi_enum_attr


***

BUG: loop4 has no users, but backend found I/O issued by syz.NUM.NUM/NUM.

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      4da93acb4f2ed06640255ad98801d0f0c734ff07
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a9ce0306-33bb-438b-b7e8-a71d334ea05a/config
AI triage: https://ci.syzbot.org/findings/4b53dd56-32be-4fad-98f2-7631c2f9c672/triage_trajectory

BUG: loop4 has no users, but backend found I/O issued by syz.4.3047/1758.
Call Trace:
     loop_queue_rq+0x82/0xcb0
     blk_mq_try_issue_directly+0x3f4/0x880
     blk_mq_submit_bio+0x21de/0x2bb0
     submit_bio_noacct_nocheck+0x2f4/0xa40
     __breadahead+0x15c/0x1f0
     nilfs_search_super_root+0x2be/0x1530
     load_nilfs+0x363/0xfb0
     nilfs_fill_super+0x1a0/0x4e0
     nilfs_get_tree+0x491/0x850
     vfs_get_tree+0x92/0x2a0
     do_new_mount+0x319/0xdc0
     __se_sys_mount+0x31d/0x420
     do_syscall_64+0x166/0x520
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop4 has no users, but backend found I/O issued by syz.4.3047/1758.
Call Trace:
     loop_queue_rq+0x82/0xcb0
     blk_mq_try_issue_directly+0x3f4/0x880
     blk_mq_submit_bio+0x21de/0x2bb0
     submit_bio_noacct_nocheck+0x2f4/0xa40
     __breadahead+0x15c/0x1f0
     nilfs_search_super_root+0x2be/0x1530
     load_nilfs+0x363/0xfb0
     nilfs_fill_super+0x1a0/0x4e0
     nilfs_get_tree+0x491/0x850
     vfs_get_tree+0x92/0x2a0
     do_new_mount+0x319/0xdc0
     __se_sys_mount+0x31d/0x420
     do_syscall_64+0x166/0x520
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop4 has no users, but backend found I/O issued by syz.4.3047/1758.
Call Trace:
     loop_queue_rq+0x82/0xcb0
     blk_mq_try_issue_directly+0x3f4/0x880
     blk_mq_submit_bio+0x21de/0x2bb0
     submit_bio_noacct_nocheck+0x2f4/0xa40
     __breadahead+0x15c/0x1f0
     nilfs_search_super_root+0x2be/0x1530
     load_nilfs+0x363/0xfb0
     nilfs_fill_super+0x1a0/0x4e0
     nilfs_get_tree+0x491/0x850
     vfs_get_tree+0x92/0x2a0
     do_new_mount+0x319/0xdc0
     __se_sys_mount+0x31d/0x420
     do_syscall_64+0x166/0x520
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop4 has no users, but backend found I/O issued by syz.4.3047/1758.
Call Trace:
     loop_queue_rq+0x82/0xcb0
     blk_mq_try_issue_directly+0x3f4/0x880
     blk_mq_submit_bio+0x21de/0x2bb0
     submit_bio_noacct_nocheck+0x2f4/0xa40
     __breadahead+0x15c/0x1f0
     nilfs_search_super_root+0x2be/0x1530
     load_nilfs+0x363/0xfb0
     nilfs_fill_super+0x1a0/0x4e0
     nilfs_get_tree+0x491/0x850
     vfs_get_tree+0x92/0x2a0
     do_new_mount+0x319/0xdc0
     __se_sys_mount+0x31d/0x420
     do_syscall_64+0x166/0x520
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop4 has no users, but backend found I/O issued by syz.4.3047/1758.
Call Trace:
     loop_queue_rq+0x82/0xcb0
     blk_mq_try_issue_directly+0x3f4/0x880
     blk_mq_submit_bio+0x21de/0x2bb0
     submit_bio_noacct_nocheck+0x2f4/0xa40
     __breadahead+0x15c/0x1f0
     nilfs_search_super_root+0x2be/0x1530
     load_nilfs+0x363/0xfb0
     nilfs_fill_super+0x1a0/0x4e0
     nilfs_get_tree+0x491/0x850
     vfs_get_tree+0x92/0x2a0
     do_new_mount+0x319/0xdc0
     __se_sys_mount+0x31d/0x420
     do_syscall_64+0x166/0x520
     entry_SYSCALL_64_after_hwframe+0x77/0x7f
BUG: loop4 has no users, but backend found I/O issued by syz.4.3047/1758.
Call Trace:
     loop_queue_rq+0x82/0xcb0
     blk_mq_try_issue_directly+0x3f4/0x880
     blk_mq_submit_bio+0x21de/0x2bb0
     submit_bio_noacct_nocheck+0x2f4/0xa40
     __breadahead+0x15c/0x1f0
     nilfs_search_super_root+0x2be/0x1530
     load_nilfs+0x363/0xfb0
     nilfs_fill_super+0x1a0/0x4e0
     nilfs_get_tree+0x491/0x850
     vfs_get_tree+0x92/0x2a0
     do_new_mount+0x319/0xdc0
     __se_sys_mount+0x31d/0x420
     do_syscall_64+0x166/0x520
     entry_SYSCALL_64_after_hwframe+0x77/0x7f


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

The email will later be sent to:
[axboe@kernel.dk bvanassche@acm.org eadavis@qq.com hch@lst.de jfs-discussion@lists.sourceforge.net linux-block@vger.kernel.org nilay@linux.ibm.com penguin-kernel@i-love.sakura.ne.jp shaggy@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

