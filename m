Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BA8C1F91D6
	for <syzbot@lists.linux.dev>; Sun, 28 Sep 2025 17:14:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759079659; cv=none; b=Poa67IDsEuCJl60Unyw+BzgJi/RZhaX2WMOhSS+zbPrjYczf9IbF+sKd0s/PFDQqL8UYnaRuUdGKPD2q1WdIiIRFHBcL6TbWDiDx3AvDMtAmh8yVTDJX7TKMxY1JcE7C2wyHV7gpED9Tv7t8KTcF8zEKb6EtX5+7a2eK/kk+xLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759079659; c=relaxed/simple;
	bh=OGK2NTLqTixeQigVB7uedWjYoyHVcMyBtpir9FcwCwY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=bmJ0qKpKtTCVCbGsD69lShenV/dnC7SisMplfY10Rl5IkCf9Uuzq8ThWNNA983RJMrp7r2U4hDpuTXE720NManCTKZz5Bj1K5/tnm1ltgtWZLzLnFPS2JMgPi9So8peMaGCLVSlHmagX5NvF9rB7RjhTdPLysiU3AXc5oyrKhhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-925332ba890so94620539f.0
        for <syzbot@lists.linux.dev>; Sun, 28 Sep 2025 10:14:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759079657; x=1759684457;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gVLtrsTamd4md26yuU/JeVx7V6dW7ULgMGXm5pul7d4=;
        b=wV99NxZfKmsNOcCJ9IcoFlToO3v9Fv0ET3cxbi78TuGiOmo2iOxS4CwUP+oND3fDww
         aAUDf0yD4Z+m2s5i3DTeEKWYAklbHb3JFBPZMhrnwXrzPTEdmeh8OO4VDSZquCPszwHj
         KDFqu7kJ+Yt3ZtgLKSVzQ0y44+/QsXFzGr2EaVbj7T8VkJOaYelOwxl2VAGiTjaZohyL
         l4IK+xEw4HwirHW34a9ygVLLuzuZrwu7pV7MhsNbzscVR971rXNwhsWqHysh26kLT/Ur
         Gx5bYgLYlYl6+tMWpFmaq8rYUm/eeNtwPVFXUszAn0LlCDohw+l0UR+Qt6TYy33ViuRl
         /wgg==
X-Gm-Message-State: AOJu0Yxg51MkfbA1Wbu1008bxAb3GuWDlQct1ks4Z0u3hwtSq9u2/h+N
	XF+BgmE6ycfj/ztDhMoI2BG83ctIEiylRHtWiqYnm2MRB+bnpzwgXGa9N6HxZiVVRqO3FVJlVgZ
	GWTmFRLEF7T7ZuEVMe8h8QmKRm/3MIcjVKhqhQzxzA/q7VdMh5w+CF2r/vEU=
X-Google-Smtp-Source: AGHT+IEM+/h2vQ6YWOic3CVC9eWexyYWcChymdW9140Te0k17inX85r1BX5qzmfvs5o7GJQQ6gfMhjOhiZbAYQs9dkKJ0OJ9w3BY
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16ca:b0:423:fd07:d3f6 with SMTP id
 e9e14a558f8ab-425956207f2mr202252255ab.15.1759079657315; Sun, 28 Sep 2025
 10:14:17 -0700 (PDT)
Date: Sun, 28 Sep 2025 10:14:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d96ce9.a70a0220.10c4b.0023.GAE@google.com>
Subject: [moderation/CI] Re: loop: improve loop aio perf by IOCB_NOWAIT
From: syzbot ci <syzbot+cia1c4ba95cce7b302@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] loop: improve loop aio perf by IOCB_NOWAIT
https://lore.kernel.org/all/20250928132927.3672537-1-ming.lei@redhat.com
* [PATCH V4 1/6] loop: add helper lo_cmd_nr_bvec()
* [PATCH V4 2/6] loop: add helper lo_rw_aio_prep()
* [PATCH V4 3/6] loop: add lo_submit_rw_aio()
* [PATCH V4 4/6] loop: move command blkcg/memcg initialization into loop_queue_work
* [PATCH V4 5/6] loop: try to handle loop aio command via NOWAIT IO first
* [PATCH V4 6/6] loop: add hint for handling aio via IOCB_NOWAIT

and found the following issue:
WARNING in lo_submit_rw_aio

Full report is available here:
https://ci.syzbot.org/series/0ffdb6b4-a5fe-48da-9473-d2a926e780bd

***

WARNING in lo_submit_rw_aio

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      07e27ad16399afcd693be20211b0dfae63e0615f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/3aba003b-2400-4e88-9a31-c09ab4e41a84/config
C repro:   https://ci.syzbot.org/findings/dc97454c-d87b-41f5-a44a-7182e666cfd5/c_repro
syz repro: https://ci.syzbot.org/findings/dc97454c-d87b-41f5-a44a-7182e666cfd5/syz_repro

------------[ cut here ]------------
WARNING: CPU: 0 PID: 5958 at drivers/block/loop.c:907 loop_inc_blocking_writes drivers/block/loop.c:907 [inline]
WARNING: CPU: 0 PID: 5958 at drivers/block/loop.c:907 loop_queue_work+0xb3b/0xc30 drivers/block/loop.c:1005
Modules linked in:
CPU: 0 UID: 0 PID: 5958 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:loop_inc_blocking_writes drivers/block/loop.c:907 [inline]
RIP: 0010:loop_queue_work+0xb3b/0xc30 drivers/block/loop.c:1005
Code: 33 bf 08 00 00 00 4c 89 ea e8 c1 89 7e fb 4c 89 f7 48 83 c4 30 5b 41 5c 41 5d 41 5e 41 5f 5d e9 cb 87 71 05 e8 26 36 b4 fb 90 <0f> 0b 90 e9 4e fe ff ff e8 18 36 b4 fb 48 83 c5 18 48 89 e8 48 c1
RSP: 0018:ffffc9000340ef38 EFLAGS: 00010093
RAX: ffffffff860b776a RBX: ffff88802187c000 RCX: ffff88810cee3980
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff52000681dc4 R12: ffff88802187c158
R13: ffff88802187c110 R14: ffff888021989460 R15: ffff888021989418
FS:  00007f649c5a4c80(0000) GS:ffff8880b8612000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000056520d53f000 CR3: 0000000109e48000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 lo_submit_rw_aio+0x493/0x620 drivers/block/loop.c:441
 lo_rw_aio_nowait drivers/block/loop.c:508 [inline]
 loop_queue_rq+0x64d/0x840 drivers/block/loop.c:2026
 __blk_mq_issue_directly block/blk-mq.c:2695 [inline]
 blk_mq_request_issue_directly+0x3c1/0x710 block/blk-mq.c:2782
 blk_mq_issue_direct+0x2a0/0x660 block/blk-mq.c:2803
 blk_mq_dispatch_queue_requests+0x621/0x800 block/blk-mq.c:2878
 blk_mq_flush_plug_list+0x432/0x550 block/blk-mq.c:2961
 __blk_flush_plug+0x3d3/0x4b0 block/blk-core.c:1220
 blk_finish_plug+0x5e/0x90 block/blk-core.c:1247
 read_pages+0x3b2/0x580 mm/readahead.c:173
 page_cache_ra_unbounded+0x6b0/0x7b0 mm/readahead.c:297
 do_page_cache_ra mm/readahead.c:327 [inline]
 force_page_cache_ra mm/readahead.c:356 [inline]
 page_cache_sync_ra+0x3b9/0xb10 mm/readahead.c:572
 filemap_get_pages+0x43c/0x1ea0 mm/filemap.c:2603
 filemap_read+0x3f6/0x11a0 mm/filemap.c:2712
 blkdev_read_iter+0x30a/0x440 block/fops.c:852
 new_sync_read fs/read_write.c:491 [inline]
 vfs_read+0x55a/0xa30 fs/read_write.c:572
 ksys_read+0x145/0x250 fs/read_write.c:715
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f649c116b6a
Code: 00 3d 00 00 41 00 75 0d 50 48 8d 3d 2d 08 0a 00 e8 ea 7d 01 00 31 c0 e9 07 ff ff ff 64 8b 04 25 18 00 00 00 85 c0 75 1b 0f 05 <48> 3d 00 f0 ff ff 76 6c 48 8b 15 8f a2 0d 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffd6597a888 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
RAX: ffffffffffffffda RBX: 0000000000040000 RCX: 00007f649c116b6a
RDX: 0000000000040000 RSI: 000056520d500438 RDI: 0000000000000009
RBP: 0000000000040000 R08: 000056520d500410 R09: 0000000000000010
R10: 0000000000004011 R11: 0000000000000246 R12: 000056520d500410
R13: 000056520d500428 R14: 000056520d3cf9c8 R15: 000056520d3cf970
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[axboe@kernel.dk dchinner@redhat.com hch@lst.de linux-block@vger.kernel.org linux-fsdevel@vger.kernel.org ming.lei@redhat.com mpatocka@redhat.com zhaoyang.huang@unisoc.com]

If the report looks fine to you, reply with:
#syz upstream

