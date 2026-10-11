Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ADD135E929
	for <syzbot@lists.linux.dev>; Sun, 11 Oct 2026 19:24:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791746667; cv=none; b=AwWMrwyvIHns83h5GXNFBWZ/BCsSP7JKz2qyXb3PgAZpzHovG39jXm5a8Vo7pCJoZxRarmd/pW3qtU3dstMDZV4kxAdbUWqGV8OJ0nsJMoJytsGM9NOdbshMyke1UMvKwIVHLsf0BpwyqeO3SEwpe1S2U1OSB8HOR3Wl7QxMeZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791746667; c=relaxed/simple;
	bh=wpYc3lbbpqid/00g/0ScDAWXCp0HRT4O4CEe5wgLaHc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=NnVZpM+QhS9GffJpL6Ugwnn8XkLxaUiIcu2ZvNlGpnYelRLbtsgdGC6+V560fQXmbnTe4dvgbutmyvbvrNvjRuJErpGkkSFnWweTgu4d/FxtGCd7kLgX/73JGpt+wyfIoeysvigfiBVTQ3Jq+o39x6g7GhW0suzgWJrMIkip98M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-81447a16061so4295031a34.3
        for <syzbot@lists.linux.dev>; Sun, 11 Oct 2026 12:24:25 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791746664; x=1792351464;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=FWl80TccLNk2610N0Xq751vCiHR/5oCRZPlaW3S7xE0=;
        b=J6zvLmvT/A2Mi9Zf3OYxHSlo9MAqaSzIV0zr+JgI+VC8qMA7RVnf8Mxy2JpUDfrz0i
         IZ6nnj05y0XKiXcE9lItwb3dFFhFTTKOP80cT3L+PPcb4KOECE2T9IHvIG+OmZ26n103
         v/JmoTW05qb9lS+Ym+EOCxumnYHsEWJgMIuYwXUnuzLI+i31OwUpXXoGMkTxmKGO1p//
         nuic0Fuw4NvLZdil1bcLBtm9bwiSIa7AjeOWDp5MIXDrE9gxnYcSP/C1zO91nwKSLsEM
         2ouv/Zd04wM9HjeOzTR9v2IdNnfpINrtPG+BTukUFa1qud/fEV5RsCieTqY1SPJVLMHb
         NuFA==
X-Gm-Message-State: AFq9FYIN7EV4rdTr+W2FLDVPi95qSIf/31J3dLpIfAYBUSWddrjgikrh
	SeIheatOrylb2nYCiY2rnadnZ+URsV4JhERRsp/WXBy0SnUlSEDacr5dummXkKNKzDgzq/o++eH
	uLO+6CIlq6dzJ3iDcUHIGqI/zN34d5EETAW2DyV1AM3rvnBh5kxm2lKRqy1c=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:bd3:b0:4d6:93c3:3e90 with SMTP id
 5614622812f47-50c5bf0c2e4mr6824743b6e.67.1791746664193; Sun, 11 Oct 2026
 12:24:24 -0700 (PDT)
Date: Sun, 11 Oct 2026 12:24:24 -0700
In-Reply-To: <cc2910d3-3113-44d4-94ef-0c8d365fac9c@I-love.SAKURA.ne.jp>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6acbe268.8cdf6287.1eb53.00ed.GAE@google.com>
Subject: [syzbot ci] Re: loop: Detect write requests that failed to wait for completion.
From: syzbot ci <syzbot+ci472e62ec00dbd79b@syzkaller.appspotmail.com>
To: axboe@kernel.dk, bvanassche@acm.org, eadavis@qq.com, hch@lst.de, 
	jfs-discussion@lists.sourceforge.net, linux-block@vger.kernel.org, 
	nilay@linux.ibm.com, penguin-kernel@i-love.sakura.ne.jp, shaggy@kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
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
