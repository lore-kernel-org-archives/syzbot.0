Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96D5A3264C7
	for <syzbot@lists.linux.dev>; Thu,  2 Jul 2026 22:20:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783030832; cv=none; b=gqdNjBx4RFKyeic0/kpxp4nziU268GUTJJbsSNr3Me3rlYuXhMLBjt07SG32HiMH/tyKqkoW6zfXvU4dB5yMUyvzi5o7UKnF53hmPWRJd2n279hohCb+Yfi678eX4eutzCrqx8ytDSNUJLst1mf+xSeaFddEL6YMAX4EjMdaMUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783030832; c=relaxed/simple;
	bh=XhOxa63+TplY/ESrBafcz+Lbc18T4TB+Z+gJf0OUNsM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=sDZGl9ileQi9Q5RJrFv2wN1DyQN+h+oqhL3z1pILaThSj5Uh+iFzHTJyX06YmarUdOj5K4/JqHRYA9rOn6ut3Qx+GyRVu0G1tEUyqeUb/uNZGlre1og7+ChnOwCWo3F1Ck8wb+IHhMiDQPgJ2WvpVh3C2RoUQiHQOaNYy+SCwPA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e9f565a6e7so3167513a34.2
        for <syzbot@lists.linux.dev>; Thu, 02 Jul 2026 15:20:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783030829; x=1783635629;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=CwZfDkmHGndhTrgd2wOy/BUq2VvLQZ1UqqRpUnc491o=;
        b=RZRCz34XQhOu53o1LROCe2ffqyjkO4t4TKlQpIXE1s/vSIq8fyia/ix0xEpMdYKg75
         sOyNwwVPvph7FZPL69JjOjJMltPWZC38Umqd5SUaHdKFmGEFhQnh/rpghxakZ/4vGIHr
         QctchtQvcXnY59Pst4WhOl1cjG3RweEMvJBZZhe24UhPePccR8CjFI75UxqQfWcBH+0A
         f5EwoaZY0l6mhx//l8rbaYubycH0VmYkIyMFfJdo9wxsNJmRyLBkND0pRnOtyjmA5YWt
         cqMvselT0e9cxIDTMydElo5FZZqI2/4swS3hqDD2lk9kklvYJROZeiUuY//4/T92XZrA
         3N4A==
X-Gm-Message-State: AOJu0YyX9bLr79MttrJ4Lljuv9iFuKrnwZr+bNUj7VjONMYgoUFeyqCS
	woOIA5UMkAUV/9f5rC5DEeCzCWHkykdL8UzbbzUu8Zz7tXDVAIC856S312QAMs65IdFb42sbZOI
	E4KUMhL0Xo4SXq+4cB+v6EtCoZSGc8UUECQ6bEkov0BT4m1dgjcZJEpePLMM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:220e:b0:495:ecd3:ba29 with SMTP id
 5614622812f47-4962d86d277mr5651174b6e.35.1783030829527; Thu, 02 Jul 2026
 15:20:29 -0700 (PDT)
Date: Thu, 02 Jul 2026 15:20:29 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a46e42d.52c20a74.1f8b39.000a.GAE@google.com>
Subject: [moderation/CI] Re: ext4: deferred iput framework for EA inodes
From: syzbot ci <syzbot+ci39094543e0c4127c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v13] ext4: deferred iput framework for EA inodes
https://lore.kernel.org/all/20260702152225.4071746-1-yun.zhou@windriver.com
* [PATCH v13 1/4] fs: add iput_if_not_last() helper
* [PATCH v13 2/4] ext4: introduce ext4_put_ea_inode() for safe deferred ipu=
t
* [PATCH v13 3/4] ext4: convert all EA inode iput() calls to ext4_put_ea_in=
ode()
* [PATCH v13 4/4] ext4: remove ea_inode_array mechanism in favor of ext4_pu=
t_ea_inode()

and found the following issue:
WARNING in ext4_journal_check_start

Full report is available here:
https://ci.syzbot.org/series/ce304d7b-7f32-44b5-bf6f-e579abb42a5c

***

WARNING in ext4_journal_check_start

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      4a50a141f05a8d1737661b19ee22ff8455b94409
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/e5413370-cf09-4540-b9d3-7d280f314ae=
0/config
syz repro: https://ci.syzbot.org/findings/e7cd69b7-8bb9-4554-bd84-b5ebcd7a8=
089/syz_repro

------------[ cut here ]------------
sb_rdonly(sb)
WARNING: fs/ext4/ext4_jbd2.c:75 at ext4_journal_check_start+0x24f/0x2b0 fs/=
ext4/ext4_jbd2.c:75, CPU#0: kworker/0:5/5860
Modules linked in:
CPU: 0 UID: 0 PID: 5860 Comm: kworker/0:5 Not tainted syzkaller #0 PREEMPT(=
full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Workqueue: events ext4_ea_inode_work
RIP: 0010:ext4_journal_check_start+0x24f/0x2b0 fs/ext4/ext4_jbd2.c:75
Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 06 75 42 ff 41 bf =
fb ff ff ff eb e0 e8 f9 74 42 ff eb d3 e8 f2 74 42 ff 90 <0f> 0b 90 eb c8 e=
8 e7 74 42 ff 90 0f 0b 90 43 80 7c 25 00 00 0f 85
RSP: 0018:ffffc900036bf888 EFLAGS: 00010293
RAX: ffffffff8283ecce RBX: ffff888170078000 RCX: ffff888107390000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 00000000000000ef R08: ffff8881bb53440f R09: 1ffff110376a6881
R10: dffffc0000000000 R11: ffffed10376a6882 R12: dffffc0000000000
R13: 1ffff1102e00f0cd R14: ffff888170078668 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88818dc20000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055557b325a28 CR3: 0000000114bfe000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __ext4_journal_start_sb+0x147/0x5d0 fs/ext4/ext4_jbd2.c:107
 __ext4_journal_start fs/ext4/ext4_jbd2.h:242 [inline]
 ext4_evict_inode+0x7cb/0xf70 fs/ext4/inode.c:238
 evict+0x624/0xb50 fs/inode.c:825
 ext4_ea_inode_work+0x5c/0x90 fs/ext4/xattr.c:2974
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
[adilger.kernel@dilger.ca brauner@kernel.org jack@suse.cz libaokun@linux.al=
ibaba.com linux-ext4@vger.kernel.org linux-fsdevel@vger.kernel.org linux-ke=
rnel@vger.kernel.org ojaswin@linux.ibm.com ritesh.list@gmail.com tytso@mit.=
edu viro@zeniv.linux.org.uk yi.zhang@huawei.com yun.zhou@windriver.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

