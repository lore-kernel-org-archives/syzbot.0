Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD77A21772A
	for <syzbot@lists.linux.dev>; Wed, 10 Dec 2025 17:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765388766; cv=none; b=ZUtq3maPKqZL1ZB0oG4iK3xHSfqxXjce1tKykqCJaSfZWeOz73qDSaTSbIQuOquX/0im45TsEfBmW4NyeLjut5qn7xmyRjkwttGDEtKp8xyiZmAIe0jjhYdtSyZOyeMBGFgRBmMQgXNWFkpXrWPM+LUxX8uP6H+fbekw1Ysqhk8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765388766; c=relaxed/simple;
	bh=uCpe9Oux+/Pis4pIM7C/K7Sy9Rj80ryZi0/A/VCxYtU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Es/Cp7bJGgvRH5507niUr5iL+Eou5+3/fjNGetuZUaimkghXlEqXD8DpdriV5Y4yKC+XtW6xOjbdtiPAExvbqI5I2eRLPmZxFLAVHx0Hdu8TqEpSrGL8Q+4OJ+MyUrSXk3rPkzZMHPQjP7TX2NkCD9PvQjtAGjeYDpgpoD6rb2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-65b2fb9d54bso124633eaf.1
        for <syzbot@lists.linux.dev>; Wed, 10 Dec 2025 09:46:03 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765388762; x=1765993562;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hdM/G0thvNtGUYZKCOBid8edqKO5Cvr4HzEIZT7wMcA=;
        b=hhT9/3i/E08mCMU4HEAbIGi/3j5SAbio251/cw/z+Eld3xODUY3UWd+/NyyspLQm3y
         OaRXXWQ92Jye1sAVG58Pxtmx+6UO0+SUIUKNLFl3w/G/oDs4VsxMmyqfm7zGlXlMC8Rr
         vQlLkHpkM8s/oKgzCLIh27lMRHGyDap4Rgev8kErUQeFHoDz5Lir73M/lfVPFo9vmxoT
         gwKq+Wi7V0NSA0tURIiZKc++2i5sN9TLvnlZPqNvyVQNcFweJVIpT4LGWoUoJvchH1bZ
         6IjzLgw8fVjo14og/Q0VU9+d1593YjtBSRpefmB9/tMn0m/mtS74fC7v3W+eOD+UrNXK
         RD/g==
X-Gm-Message-State: AOJu0YxCS5fN69otUqe0ZW9rJOJNTTfGCjF3E6Bi1HDY7yrHLetc7vtE
	npp3U8NW2mYKQOBPaNV11AHI1XxB4xJ9tFHJTjLbp4LjvDIv1wFqv4xf5h/4F7dmKAFUyB1H/Er
	RB/Xine9zHc6bxXjNA4rdEQDkimxgNWHVh3bGw4BF39BCr9Cw6QMtc19/iD8=
X-Google-Smtp-Source: AGHT+IH1nvmVJ5+XbsCzTP235SQvRZb3D6wnQst6GRcXus4VHt1nUppaePNF5CMJmoc+g3HnwovKvWrljqBP9Y5fWWatg+soXrnt
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4007:b0:659:9a49:8e27 with SMTP id
 006d021491bc7-65b3468c7bemr137116eaf.25.1765388762434; Wed, 10 Dec 2025
 09:46:02 -0800 (PST)
Date: Wed, 10 Dec 2025 09:46:02 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6939b1da.a70a0220.33cd7b.0014.GAE@google.com>
Subject: [moderation/CI] Re: fs: warn on dirty inode in writeback paired with I_WILL_FREE
From: syzbot ci <syzbot+ci0a1fc2eeba2ece8e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] fs: warn on dirty inode in writeback paired with I_WILL_FREE
https://lore.kernel.org/all/20251210134303.1310039-1-mjguzik@gmail.com
* [PATCH] fs: warn on dirty inode in writeback paired with I_WILL_FREE

and found the following issues:
* SYZFAIL: failed to recv rpc
* WARNING in writeback_single_inode

Full report is available here:
https://ci.syzbot.org/series/c3a011ac-952a-4fbf-867d-b7f98dcaaf3a

***

SYZFAIL: failed to recv rpc

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      67a454e6b1c604555c04501c77b7fedc5d98a779
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/5b151469-2ba7-47b6-bf4b-00ea2f6df1d8/config
C repro:   https://ci.syzbot.org/findings/9adaaed3-7016-4f9d-9b65-1a4aa9a7a127/c_repro
syz repro: https://ci.syzbot.org/findings/9adaaed3-7016-4f9d-9b65-1a4aa9a7a127/syz_repro

SYZFAIL: failed to recv rpc


***

WARNING in writeback_single_inode

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      67a454e6b1c604555c04501c77b7fedc5d98a779
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/5b151469-2ba7-47b6-bf4b-00ea2f6df1d8/config
C repro:   https://ci.syzbot.org/findings/6a7382a1-4230-4aa8-8594-a23b2365ee14/c_repro
syz repro: https://ci.syzbot.org/findings/6a7382a1-4230-4aa8-8594-a23b2365ee14/syz_repro

EXT4-fs error (device loop0): ext4_clear_blocks:876: inode #13: comm syz.0.17: attempt to clear invalid blocks 2 len 1
EXT4-fs (loop0): Remounting filesystem read-only
------------[ cut here ]------------
WARNING: fs/fs-writeback.c:1870 at writeback_single_inode+0xa39/0xe40 fs/fs-writeback.c:1870, CPU#1: syz.0.17/5986
Modules linked in:
CPU: 1 UID: 0 PID: 5986 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:writeback_single_inode+0xa39/0xe40 fs/fs-writeback.c:1870
Code: 0f 0b 90 e9 25 f7 ff ff e8 64 8d 79 ff 90 0f 0b 90 e9 9c fb ff ff e8 56 8d 79 ff 90 0f 0b 90 e9 c1 fc ff ff e8 48 8d 79 ff 90 <0f> 0b 90 e9 54 fc ff ff e8 3a 8d 79 ff 90 0f 0b 90 e9 47 fd ff ff
RSP: 0018:ffffc900037c7558 EFLAGS: 00010293
RAX: ffffffff824823a8 RBX: dffffc0000000000 RCX: ffff8881113657c0
RDX: 0000000000000000 RSI: 0000000000000040 RDI: 0000000000000000
RBP: ffff888108eb4068 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520006f8e9c R12: ffff8881b1810d08
R13: 0000000000000040 R14: ffff8881b1810c38 R15: 1ffff110363021a1
FS:  00005555567e1500(0000) GS:ffff8882a9e44000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f67c0f73ea0 CR3: 000000017655e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 write_inode_now+0x160/0x1d0 fs/fs-writeback.c:2926
 iput_final fs/inode.c:1941 [inline]
 iput+0xa77/0x1030 fs/inode.c:2003
 ext4_orphan_cleanup+0xc20/0x1460 fs/ext4/orphan.c:472
 __ext4_fill_super fs/ext4/super.c:5658 [inline]
 ext4_fill_super+0x58a1/0x6160 fs/ext4/super.c:5777
 get_tree_bdev_flags+0x40e/0x4d0 fs/super.c:1691
 vfs_get_tree+0x92/0x2a0 fs/super.c:1751
 fc_mount fs/namespace.c:1199 [inline]
 do_new_mount_fc fs/namespace.c:3636 [inline]
 do_new_mount+0x302/0xa10 fs/namespace.c:3712
 do_mount fs/namespace.c:4035 [inline]
 __do_sys_mount fs/namespace.c:4224 [inline]
 __se_sys_mount+0x313/0x410 fs/namespace.c:4201
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f67c0f90f6a
Code: d8 64 89 02 48 c7 c0 ff ff ff ff eb a6 e8 de 1a 00 00 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc812989c8 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007ffc81298a50 RCX: 00007f67c0f90f6a
RDX: 0000200000000440 RSI: 0000200000000040 RDI: 00007ffc81298a10
RBP: 0000200000000440 R08: 00007ffc81298a50 R09: 0000000000000001
R10: 0000000000000001 R11: 0000000000000246 R12: 0000200000000040
R13: 00007ffc81298a10 R14: 0000000000000450 R15: 000000000000002c
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[brauner@kernel.org jack@suse.cz linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org mjguzik@gmail.com viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

