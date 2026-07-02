Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDAB93CDBD6
	for <syzbot@lists.linux.dev>; Thu,  2 Jul 2026 22:57:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783033024; cv=none; b=lCN7i3IlJnf5+qqBVKFH4guxiY31aTFHysAWDH6RxGaPo5WNeifGEXGHoOUzvcKwlNhdeYdKM3V/slkM73BGE7+7OkTGOPsRgcrYGspqfaDBgsp++m9GWVk0aHNX/6BSIlYFgWUxa11GV/Mcy9DR1CHsGtD6wHiyTcOUrkOZAy4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783033024; c=relaxed/simple;
	bh=JbREc04h3WlPRWGedBjLlTNzwXCNqmFS1OsIK4EbIVg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=lA1soJjawZ8ot8D5702xCSUm232+VYTj+KkWe4CTZe/saSOm4Gv1eiR0YH4Xsyd/5xmxzqU7qdWaF3+co1Qeu23JbpKgne9IyzS/duqa851crefluI1FsrUqrALPE6MpKHkAKaPq4fIadXpc2vn68kGGohAdWWb27j7v/ridMv4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-48f0e5e664aso3397329b6e.1
        for <syzbot@lists.linux.dev>; Thu, 02 Jul 2026 15:57:02 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783033022; x=1783637822;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=j28VgG8vASX4K9xxxxnxbwBaDXCS94Uwp097TC+/578=;
        b=BN/gsO9aOWetyBIBcU48/+qz5yeuDxyeovX0STlEr6gYUSVzSZIOX5NbZDbwiAiHrH
         Xh5OQquO4ulRX9fOboScqjuztKW48O/ZqGJ5y1kc4mQWUP23pSugO6IWzwdIBLGuqFfP
         vv0XsXhx/SHbHTZWLkfLKH0SQvCFtiEu0lBchFxrOILEOfv5LIsMao+LYsMEzuKuPzwW
         eiMqidpXU3DErXBP7IJ/MWLR4zwbXrue1ZmSyIRcAq3BSBgRZ1daizp1uQ/onkWIbdfk
         Bp0Owv+n3uGlTykZHwNeLIxkWsl+Nkr113YziZz9hW0fULnL0/1EJQGFv99Z56kE21li
         kZ0Q==
X-Gm-Message-State: AOJu0Ywp11mh2c2LC3CtS8PxhQkWhLEXW/Rd/7fwtJICFGw38Lsyy9bh
	n7bRBrLtvyk0woJtWSmXYaZUCN/6UJy7AiKm0W+99Yg46THGaZSyPM0dXWoxKtIIa8NZUS6k2Wh
	DnsVSMWVqf4nYSQ2IzhVeBq2tKWRqUbvtJ/nMPsy/ZBpDyvkJhk/I7NNvv/8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:199d:b0:496:fd2:94ee with SMTP id
 5614622812f47-4962d93e521mr5633343b6e.24.1783033021882; Thu, 02 Jul 2026
 15:57:01 -0700 (PDT)
Date: Thu, 02 Jul 2026 15:57:01 -0700
In-Reply-To: <20260702152225.4071746-1-yun.zhou@windriver.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a46ecbd.52c20a74.1f8b39.000b.GAE@google.com>
Subject: [syzbot ci] Re: ext4: deferred iput framework for EA inodes
From: syzbot ci <syzbot+ciadd810ddf4701c1b@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, brauner@kernel.org, jack@suse.cz, 
	libaokun@linux.alibaba.com, linux-ext4@vger.kernel.org, 
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	ojaswin@linux.ibm.com, ritesh.list@gmail.com, tytso@mit.edu, 
	viro@zeniv.linux.org.uk, yi.zhang@huawei.com, yun.zhou@windriver.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v13] ext4: deferred iput framework for EA inodes
https://lore.kernel.org/all/20260702152225.4071746-1-yun.zhou@windriver.com
* [PATCH v13 1/4] fs: add iput_if_not_last() helper
* [PATCH v13 2/4] ext4: introduce ext4_put_ea_inode() for safe deferred iput
* [PATCH v13 3/4] ext4: convert all EA inode iput() calls to ext4_put_ea_inode()
* [PATCH v13 4/4] ext4: remove ea_inode_array mechanism in favor of ext4_put_ea_inode()

and found the following issue:
WARNING in ext4_journal_check_start

Full report is available here:
https://ci.syzbot.org/series/ce304d7b-7f32-44b5-bf6f-e579abb42a5c

***

WARNING in ext4_journal_check_start

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      4a50a141f05a8d1737661b19ee22ff8455b94409
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/e5413370-cf09-4540-b9d3-7d280f314ae0/config
syz repro: https://ci.syzbot.org/findings/e7cd69b7-8bb9-4554-bd84-b5ebcd7a8089/syz_repro

------------[ cut here ]------------
sb_rdonly(sb)
WARNING: fs/ext4/ext4_jbd2.c:75 at ext4_journal_check_start+0x24f/0x2b0 fs/ext4/ext4_jbd2.c:75, CPU#0: kworker/0:5/5860
Modules linked in:
CPU: 0 UID: 0 PID: 5860 Comm: kworker/0:5 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: events ext4_ea_inode_work
RIP: 0010:ext4_journal_check_start+0x24f/0x2b0 fs/ext4/ext4_jbd2.c:75
Code: 5b 41 5c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 06 75 42 ff 41 bf fb ff ff ff eb e0 e8 f9 74 42 ff eb d3 e8 f2 74 42 ff 90 <0f> 0b 90 eb c8 e8 e7 74 42 ff 90 0f 0b 90 43 80 7c 25 00 00 0f 85
RSP: 0018:ffffc900036bf888 EFLAGS: 00010293
RAX: ffffffff8283ecce RBX: ffff888170078000 RCX: ffff888107390000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 00000000000000ef R08: ffff8881bb53440f R09: 1ffff110376a6881
R10: dffffc0000000000 R11: ffffed10376a6882 R12: dffffc0000000000
R13: 1ffff1102e00f0cd R14: ffff888170078668 R15: 0000000000000001
FS:  0000000000000000(0000) GS:ffff88818dc20000(0000) knlGS:0000000000000000
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
