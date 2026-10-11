Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2480D21A457
	for <syzbot@lists.linux.dev>; Sun, 11 Oct 2026 17:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791740331; cv=none; b=BP1rfzy9ZfQgw75Azo88MubMHJkQkuvF0IkOfuMKm0c4hnHf1Q/jusqJceSd7+z1E1UzQ7WunrvTKWuZGwZZfAjklK4LrChPIZYKD19A9arLSUiHPOJOnV/DK8J+YpbIU9TuyZMEkD1DL7lEo99rX+I6Bqw6PwEBSv/MCAIJXEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791740331; c=relaxed/simple;
	bh=cl1O3LGajLtCneq2GXMOKSphRoT13r4uqYT6c2NURB8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=LVtt1f4sVZh6IpljkBxcgy0Gq3iB9EADNPgUvdNF3HnLjX10GdTcJkRFbzatcEz4VmgaITq99okkijLieki2arL8eEq04AKUR869zBfyAyWCbCctkgFJ9zUt80D2NyqWku/Ax+rrPe3vC9Tuh9OjHfABJYv4UuX7wR5eVg73S1Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-83043b8a01fso2106084a34.1
        for <syzbot@lists.linux.dev>; Sun, 11 Oct 2026 10:38:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791740328; x=1792345128;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2M14NJeb4uuu7SkPbm1ZTOSPnMIxZhyR3j+31mTfrEU=;
        b=AvE4yydmB9YP1S8S7Yl4NkciZPbYlpyApKgsaAT/yEypxadTD5vuIwLCu5N5cUBe5W
         a7IvxegH4aH4+ibeRAEj9L2OJ6V8tGBuKrYcrSPWBl1nK93cd7HNQ1DIM4wgCitizKqC
         UeGin4SM3/TW4khFlsXNySvvguJecLclQ6b0XLMkGF56vwpUvGFEk6EChReCTcWV49Jj
         Xe4XbcT3+1hPaPU1MGZqAKn6qm75ZIB2+1LZlbk8jkKmQicPev3uS7XIe3xl4V1UOmwS
         7/zAHF+9gBZXvvrSRu/cc8yYlDbTgZdbQtwvBX+jJ5UY7w7v8jrOC3gF7OwgdHxNQFKc
         eSGg==
X-Gm-Message-State: AFq9FYLFV+ASNmq3TC46UWN5PODjSAslSFgNfIgpQOh9cSB3yZtkcu1Z
	xKkRHsBlgKe473hsopU1OJFMVkSnMRVCTnd1ZK06UtaeuiismUQFH0e+gapl8/8JUvEQMQebhVw
	BOAA7AKhog8UxbUuFpfnf6lGN2ZS/KchkwAthErvrFTtBF9rcqxeU3GPQQ4Q=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:518c:b0:4f6:5279:5c83 with SMTP id
 5614622812f47-50c42a24b54mr6571593b6e.8.1791740328138; Sun, 11 Oct 2026
 10:38:48 -0700 (PDT)
Date: Sun, 11 Oct 2026 10:38:48 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6acbc9a8.6d14cce4.2677ed.012d.GAE@google.com>
Subject: [moderation/CI] Re: loop: Detect write requests that failed to wait
 for completion.
From: syzbot ci <syzbot+ciebc1a7ad3d6a80ae@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] loop: Detect write requests that failed to wait for completion.
https://lore.kernel.org/all/cc2910d3-3113-44d4-94ef-0c8d365fac9c@I-love.SAKURA.ne.jp
* [PATCH v3] loop: Detect write requests that failed to wait for completion.

and found the following issues:
* BUG: found I/O issued by syz.NUM.NUM/NUM but loop0 is no longer bound.
* BUG: found I/O issued by syz.NUM.NUM/NUM but loop2 is no longer bound.

Full report is available here:
https://ci.syzbot.org/series/d3a0b036-fd1e-44c6-8869-386ea1642385

***

BUG: found I/O issued by syz.NUM.NUM/NUM but loop0 is no longer bound.

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      4da93acb4f2ed06640255ad98801d0f0c734ff07
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a23afb97-88bb-4fba-8885-d3062b5890e2/config
syz repro: https://ci.syzbot.org/findings/c9ad5ff9-784f-4528-805f-7971e0359600/syz_repro

BUG: found I/O issued by syz.0.760/7647 but loop0 is no longer bound.
Call Trace:
     loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
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
BUG: found I/O issued by syz.0.760/7647 but loop0 is no longer bound.
Call Trace:
     loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
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

BUG: found I/O issued by syz.NUM.NUM/NUM but loop2 is no longer bound.

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      4da93acb4f2ed06640255ad98801d0f0c734ff07
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a23afb97-88bb-4fba-8885-d3062b5890e2/config
syz repro: https://ci.syzbot.org/findings/bad9ae98-7887-4209-8226-7e84bb070faa/syz_repro

BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
Call Trace:
     loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
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
BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
Call Trace:
     loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
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
BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
Call Trace:
     loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
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
BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
Call Trace:
     loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
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
BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
Call Trace:
     loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
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
BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
Call Trace:
     loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
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
BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
Call Trace:
     loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
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
BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
Call Trace:
     loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
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
BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
Call Trace:
     loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
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
BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
Call Trace:
     loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
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
BUG: found I/O issued by syz.2.866/7955 but loop2 is no longer bound.
Call Trace:
     loop_queue_rq+0x232/0xc90 drivers/block/loop.c:1922
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

