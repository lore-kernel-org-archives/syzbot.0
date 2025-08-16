Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D819F3596E
	for <syzbot@lists.linux.dev>; Sat, 16 Aug 2025 22:06:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755382018; cv=none; b=iaqjnxtzFsUN+lJhjSUZneQTSJ5B1d9wSox9biXiffcsI9MqABC3uhVdY79QdwTak/VReKmIwVa4u259G957cvLvsrggyhwGQXrQ7NGW7oypa8AHpAKY4y4GaKc+OksYS3I4PuAB/BXltI+FFsQVadpI9vj/8KSkdqBU6sgB0yg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755382018; c=relaxed/simple;
	bh=ibJoGEl10IYw86YQjgCRTzgiUsK6ZOC00G3CE71/VDI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=onvpv7sId/erLI/paE7C7AsIeczUrcUmJZNxAtTklANFPa8IUIuxIM+8DFArfMkS3MnNWJe5Faw2Y2B8Iv4wqgxUKLatJStFCKyBeoZLJS6xlJKBkKIPaOe7R3pbk7xnYBC/pKmMtWe+a6AD7cXctPyGIr3fz5geymwR3JtiFLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3e665379e84so3176525ab.1
        for <syzbot@lists.linux.dev>; Sat, 16 Aug 2025 15:06:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755382016; x=1755986816;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=+7V3IbKbizt3GAVhA6m5zIpOvmN0V9TVwBdEVulY4s0=;
        b=wkYNiADYaEqP4pmraBhZIg8GLgRMBpXvrs2lQhRjlHa0BLJR9XRr0OY5LsmxScFFHA
         ESaKZ32FcFtpJxrvJ66SpgyJaMSbIFHvUT6dwIf3Y3y0trE64ZwSzMRCRfREwHL06x0l
         4f/swUsDWJOTSogVxdOXc57l9bWkdIuUXhypcel495/2U+CvPJIdCbwRKvPv7mLTDAwU
         HyxZDB+ioYgCVm7Blie5BFnmr4ltgDwHAU64VoDcoa6vzTFFJfHq9Il+/Kclhlz88EWQ
         kaZu4geDGjKhcTwJBuSKG2RDo0xV5Jva7ArqzYxN2mRy3Py1nmvd0uzYlUng34Pec9xa
         1TsA==
X-Gm-Message-State: AOJu0Yw1eBOs6hzcL3yjrkK8OT77R2B3QpOivvXKmUnbx/4gtihU8ui8
	kvnxkdfvI4E+ZUeyE7hqiFs32V1Mq+1cdN2085wvySFbbi+x98tW5DbGgQ9be5ypSkRiesDx8Zm
	JgqUmXfGMlwJMoUn7qWxXWepc17PUzkhY5Rzga7WP0Tx3imjuj3YBGwOaOxk=
X-Google-Smtp-Source: AGHT+IGC08axl3SxMKgu4gCnxyx1qis/hunK1EHRHN5L1CZneJrdDSesA3C5A4nIFLXQ3Q5AwK9oLVquF83DZuSITCzfmLg4AzLu
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c265:0:b0:3e2:9f5c:520f with SMTP id
 e9e14a558f8ab-3e57da24190mr129043715ab.3.1755382016045; Sat, 16 Aug 2025
 15:06:56 -0700 (PDT)
Date: Sat, 16 Aug 2025 15:06:56 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a10100.050a0220.e29e5.004f.GAE@google.com>
Subject: [moderation/CI] Re: introduce uncharged file mapped folios
From: syzbot ci <syzbot+cib318a83238f8e465@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] introduce uncharged file mapped folios
https://lore.kernel.org/all/cover.1755300815.git.boris@bur.io
* [PATCH v2 1/3] mm/filemap: add AS_UNCHARGED
* [PATCH v2 2/3] mm: add vmstat for cgroup uncharged pages
* [PATCH v2 3/3] btrfs: set AS_UNCHARGED on the btree_inode

and found the following issue:
WARNING in folio_lruvec_lock_irqsave

Full report is available here:
https://ci.syzbot.org/series/15fd2538-1138-43c0-b4d6-6d7f53b0be69

***

WARNING in folio_lruvec_lock_irqsave

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/5b3f7bc8-d0c2-4985-8ae6-d51ea4e2baed/config
C repro:   https://ci.syzbot.org/findings/f02552bd-e7e6-4c3f-8cc3-04a5a946771d/c_repro
syz repro: https://ci.syzbot.org/findings/f02552bd-e7e6-4c3f-8cc3-04a5a946771d/syz_repro

 do_new_mount+0x2a2/0x9e0 fs/namespace.c:3805
 do_mount fs/namespace.c:4133 [inline]
 __do_sys_mount fs/namespace.c:4344 [inline]
 __se_sys_mount+0x317/0x410 fs/namespace.c:4321
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
------------[ cut here ]------------
WARNING: CPU: 0 PID: 5951 at ./include/linux/memcontrol.h:734 folio_lruvec include/linux/memcontrol.h:734 [inline]
WARNING: CPU: 0 PID: 5951 at ./include/linux/memcontrol.h:734 folio_lruvec_lock_irqsave+0x184/0x1d0 mm/memcontrol.c:1252
Modules linked in:
CPU: 0 UID: 0 PID: 5951 Comm: syz-executor Not tainted 6.17.0-rc1-syzkaller-00036-gdfc0f6373094-dirty #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:folio_lruvec include/linux/memcontrol.h:734 [inline]
RIP: 0010:folio_lruvec_lock_irqsave+0x184/0x1d0 mm/memcontrol.c:1252
Code: 74 0c 4c 89 f7 e8 cc 53 f8 ff 48 8b 04 24 49 89 06 eb a0 48 89 df 48 c7 c6 60 4e 98 8b e8 a4 36 fd fe c6 05 52 a1 62 0d 01 90 <0f> 0b 90 e9 a5 fe ff ff 44 89 e1 80 e1 07 80 c1 03 38 c1 0f 8c 22
RSP: 0018:ffffc9000359f540 EFLAGS: 00010246
RAX: f0f9782cf8520600 RBX: ffffea0000807140 RCX: f0f9782cf8520600
RDX: 0000000000000002 RSI: ffffffff8dba6067 RDI: ffff888020a73980
RBP: ffffc9000359f5e0 R08: ffff88804b024253 R09: 1ffff1100960484a
R10: dffffc0000000000 R11: ffffed100960484b R12: ffff88804b032fe8
R13: ffff88801ba80918 R14: ffff888106950000 R15: 0000000000000000
FS:  0000555587fa3500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c00003e720 CR3: 0000000029a9c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 folio_lruvec_relock_irqsave include/linux/memcontrol.h:1544 [inline]
 folio_batch_move_lru+0x20a/0x3a0 mm/swap.c:167
 lru_add_drain_cpu+0x119/0x880 mm/swap.c:647
 lru_add_drain+0x122/0x3e0 mm/swap.c:735
 __folio_batch_release+0x48/0x90 mm/swap.c:1054
 folio_batch_release include/linux/pagevec.h:101 [inline]
 invalidate_inode_pages2_range+0x889/0xa80 mm/truncate.c:707
 close_ctree+0x6ff/0x1380 fs/btrfs/disk-io.c:4408
 generic_shutdown_super+0x135/0x2c0 fs/super.c:643
 kill_anon_super+0x3b/0x70 fs/super.c:1282
 btrfs_kill_super+0x41/0x50 fs/btrfs/super.c:2114
 deactivate_locked_super+0xbc/0x130 fs/super.c:474
 cleanup_mnt+0x425/0x4c0 fs/namespace.c:1378
 task_work_run+0x1d4/0x260 kernel/task_work.c:227
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
 exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
 do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4a78b8ff17
Code: a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 0f 1f 44 00 00 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffe33fe80a8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007f4a78c11c05 RCX: 00007f4a78b8ff17
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffe33fe8160
RBP: 00007ffe33fe8160 R08: 0000000000000000 R09: 0000000000000000
R10: 00000000ffffffff R11: 0000000000000246 R12: 00007ffe33fe91f0
R13: 00007f4a78c11c05 R14: 000000000000f471 R15: 00007ffe33fe9230
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[boris@bur.io kernel-team@fb.com linux-btrfs@vger.kernel.org linux-fsdevel@vger.kernel.org linux-mm@kvack.org shakeel.butt@linux.dev willy@infradead.org wqu@suse.com]

If the report looks fine to you, reply with:
#syz upstream

