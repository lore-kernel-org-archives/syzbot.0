Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DA052E2840
	for <syzbot@lists.linux.dev>; Sun, 11 Oct 2026 15:15:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791731744; cv=none; b=IclH7ExLbZ9PcgDqFhPkV5S6ACt7d04TnppTN9BIbk1OKf1MvS0vpUtSt7BlNMMo5shYDgogCc5aUye0HPegV5Jag4hK/zVePrjA6rEpVHTO/bXmafgsr3/gQkFG0LiYMe0mIQo9aYl/59HA/7v96sZZY8sBKWfjAwsT5+ofiDQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791731744; c=relaxed/simple;
	bh=ANNVqgJdmrNQ9AL58yAXj/cF93/gby6n1PzlmscFVZE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=eDa7KsWvXPTF04/VRE02F+Aasxp/QcUucGnJTmpL5BLWaQAyLbz0nsefF5svJuyzo+9WQFuwp8yLI59lDnAuJJkJb5gehn6izTaXQWEVecNLeTUjdatALAOeNFWgTck3kOdnRvFcyD0+Wwgg98mkkPH4QVk2FPa61VqDw0LxmCo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-82169fb66c3so2768150a34.2
        for <syzbot@lists.linux.dev>; Sun, 11 Oct 2026 08:15:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791731739; x=1792336539;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2MbI4o+5vFdZBDMSio/+lzxhqzX/QtnY+dv5QrE3jJE=;
        b=JhcBil2rTmUyPGxKsqUs3h7a56Oh2poRtjZHPd/vSDqI7BIO0uHJhmue/xaqXGL+Xm
         dE7eC8BSWffI0M08DZcYcAZshyQFQmzbROm1TNtmI9c591vx//z6KVNcJBxCbp++cAsW
         6fMvTnsKZtg39T8No3YlDSv2q4ek2fFrJ34V+gl/DYMhQq6/Q1m1LEK9xfnF1wIFLL4Y
         ebnmjxytkB9aDW7dyQIHf9TgMIa/qQWbeoeYsPYIGjsxtpbov3qqKOTi0BPS1sdy8MlZ
         9Z7kVRvPmOdjnGDaTtc9apOcgfW9Pu/DK2e3K8xidjfzUAqcj2aqlsvzGnAXBfdg7Xng
         9ShQ==
X-Gm-Message-State: AFq9FYKljAPPhU6144SVGk8Y0xPjpmM9YIyjgTpwhlkmYMtWicO7rpMr
	G2wJAzfkAgOrzzfCDOsFrGImSaaMCf+kt3lpnBFOKeJXF8Frv72t9hdm1c7JYnVGgWcPqTgAMfH
	TSBdWFHxBFT28buq+lHXUB/OZzOYoNcRbLocnZ/cuR1zwknLhVvw9U8RgsF4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:190b:b0:4f8:4ec9:b170 with SMTP id
 5614622812f47-50c415de52amr8200094b6e.2.1791731739767; Sun, 11 Oct 2026
 08:15:39 -0700 (PDT)
Date: Sun, 11 Oct 2026 08:15:39 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6acba81b.bbc4c7f9.15faa7.0084.GAE@google.com>
Subject: [moderation/CI] Re: loop: Detect write requests that failed to wait
 for completion.
From: syzbot ci <syzbot+ci4ca8d8a464928116@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] loop: Detect write requests that failed to wait for completion.
https://lore.kernel.org/all/380f04ef-902d-4664-9ae3-228692d2efb9@I-love.SAKURA.ne.jp
* [PATCH] loop: Detect write requests that failed to wait for completion.

and found the following issues:
* BUG: syz.NUM.NUM/NUM is doing I/O request on loop1 in Lo_rundown state.
* BUG: syz.NUM.NUM/NUM is doing I/O request on loop4 in Lo_rundown state.

Full report is available here:
https://ci.syzbot.org/series/1d6e1ed8-5255-4499-b944-1491f0fc2111

***

BUG: syz.NUM.NUM/NUM is doing I/O request on loop1 in Lo_rundown state.

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      4da93acb4f2ed06640255ad98801d0f0c734ff07
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9ff9d467-08f4-48f3-814f-1605ea27467a/config
syz repro: https://ci.syzbot.org/findings/2daf7154-e0e1-4e75-863e-48d5787f46d1/syz_repro

BUG: syz.1.1804/9447 is doing I/O request on loop1 in Lo_rundown state.
Call Trace:
     loop_queue_rq+0x8b/0xed0 drivers/block/loop.c:1902
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
BUG: syz.1.1804/9447 is doing I/O request on loop1 in Lo_rundown state.
Call Trace:
     loop_queue_rq+0x8b/0xed0 drivers/block/loop.c:1902
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
BUG: syz.1.1804/9447 is doing I/O request on loop1 in Lo_rundown state.
Call Trace:
     loop_queue_rq+0x8b/0xed0 drivers/block/loop.c:1902
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
BUG: syz.1.1804/9447 is doing I/O request on loop1 in Lo_rundown state.
Call Trace:
     loop_queue_rq+0x8b/0xed0 drivers/block/loop.c:1902
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
BUG: syz.1.1804/9447 is doing I/O request on loop1 in Lo_rundown state.
Call Trace:
     loop_queue_rq+0x8b/0xed0 drivers/block/loop.c:1902
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
bridge0: port 1(bridge_slave_0) entered blocking state
bridge0: port 1(bridge_slave_0) entered forwarding state


***

BUG: syz.NUM.NUM/NUM is doing I/O request on loop4 in Lo_rundown state.

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      4da93acb4f2ed06640255ad98801d0f0c734ff07
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9ff9d467-08f4-48f3-814f-1605ea27467a/config
AI triage: https://ci.syzbot.org/findings/99783fd2-a03a-4f81-a151-fc2aaea45886/triage_trajectory

BUG: syz.4.84/6446 is doing I/O request on loop4 in Lo_rundown state.
Call Trace:
     loop_queue_rq+0x8b/0xed0
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
BUG: syz.4.84/6446 is doing I/O request on loop4 in Lo_rundown state.
Call Trace:
     loop_queue_rq+0x8b/0xed0
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
BUG: syz.4.84/6446 is doing I/O request on loop4 in Lo_rundown state.
Call Trace:
     loop_queue_rq+0x8b/0xed0
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
BUG: syz.4.84/6446 is doing I/O request on loop4 in Lo_rundown state.
Call Trace:
     loop_queue_rq+0x8b/0xed0
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
BUG: syz.4.84/6446 is doing I/O request on loop4 in Lo_rundown state.
Call Trace:
     loop_queue_rq+0x8b/0xed0
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
BUG: syz.4.84/6446 is doing I/O request on loop4 in Lo_rundown state.
Call Trace:
     loop_queue_rq+0x8b/0xed0
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
BUG: syz.4.84/6446 is doing I/O request on loop4 in Lo_rundown state.
Call Trace:
     loop_queue_rq+0x8b/0xed0
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
BUG: syz.4.84/6446 is doing I/O request on loop4 in Lo_rundown state.
Call Trace:
     loop_queue_rq+0x8b/0xed0
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

