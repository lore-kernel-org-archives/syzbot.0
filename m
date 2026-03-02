Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B4B0D394498
	for <syzbot@lists.linux.dev>; Mon,  2 Mar 2026 10:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772446115; cv=none; b=X2ssPwTz0pyfUfJqUk1DOIiAQZViO1ALfJy1OEXXlxk6Adqu9wO81XS5Tjb8XEA4xxTete+qLeVLdh//Fq1HGZaHzHh9uLGelgE+5ZOfpcEaJeOLti7dTxpZlrMAhKZ8A6ZTu/a1QdG84lyc3ljcvpHCkERufwjqx3gCHvttJnU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772446115; c=relaxed/simple;
	bh=z11m+T4Go0CfM7+eDHqU4dwhn5ocO+dyfUhHqt1y39g=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=rhwasUZxtDVpaBpW3EBM2r92Rq1A9cHWaI4HBp+U5r0an1wpoCyaWLHSVvH1k7UPJrMAY0NYPGYmw8GqQkWFHkvpIFgJL92rXIj6ytAz6fyUTxgGrGI9uEw8rgQcdyiNHcPlefV+5P+4yeJ0MLBsNJV1+0349PlFAC+MK5dGHwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4639e1fedcbso51041434b6e.3
        for <syzbot@lists.linux.dev>; Mon, 02 Mar 2026 02:08:33 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772446113; x=1773050913;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=ZVeo7WDtL/mn/zUYlFfeDxmHGt7ioMx7GyHHlBMi+iw=;
        b=fFYM1VO+HHYTtyucXZbSVdlWZBVzIx2PURnCIDqMzR+qT1X3Lfdi+07/krenJyDdId
         dA7vd2tp0PbCBDBmPiIkNG9JZq4/4bOHYeSCDb6Was9O3ZjriabKY/uQGLwrGHWsCqM4
         lNVj2jjHrTBGBGsqLXvCTVgusHEnk20SbdHFjD1F86BRKXOC/X7bRn62hKvv2e5kM4Rm
         yGwQYt2EZZFwGOnTacM2Xj24H5cXi5Y1hBh4/JWs/4dX7PeHyHDoukcBWw7LtaPfq8xA
         ATOHbw7pwHwnu1sbCiycpEpGsWb4oQAy4bkMs31tPBx/i5GcI84D0j1dIIPvHzANBgGf
         aQpA==
X-Gm-Message-State: AOJu0YwZ2B3eFtoaMC911dxHUml27j3AuezCYOPQklGM+ruM1Vzmq2eA
	F8w69e/OvwDwRCbRy1cCja04KtGABu1k4BydvRR7M6GDPduIKabvcvzvaHBRewJ5c0JyM3ttjNJ
	H4GwnTRMOZfFo49J9Bvg71GgxMLSjK3HPbWTyY/pW164mjiRPV3S7N/BRFPY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1b10:b0:663:b86:493 with SMTP id
 006d021491bc7-679fae78f67mr6891272eaf.33.1772446112744; Mon, 02 Mar 2026
 02:08:32 -0800 (PST)
Date: Mon, 02 Mar 2026 02:08:32 -0800
In-Reply-To: <20260228025650.2664098-1-yebin@huaweicloud.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a561a0.050a0220.3a55be.0073.GAE@google.com>
Subject: [syzbot ci] Re: ext4: test if inode's all dirty pages are submitted
 to disk
From: syzbot ci <syzbot+ci218c29ae48f2e4ea@syzkaller.appspotmail.com>
To: adilger.kernel@dilger.ca, jack@suse.cz, linux-ext4@vger.kernel.org, 
	tytso@mit.edu, yebin@huaweicloud.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] ext4: test if inode's all dirty pages are submitted to disk
https://lore.kernel.org/all/20260228025650.2664098-1-yebin@huaweicloud.com
* [PATCH v2] ext4: test if inode's all dirty pages are submitted to disk

and found the following issue:
WARNING in ext4_evict_inode

Full report is available here:
https://ci.syzbot.org/series/b58ccb85-a946-44ae-9d57-c02bee2a43ba

***

WARNING in ext4_evict_inode

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      4d349ee5c7782f8b27f6cb550f112c5e26fff38d
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/1accd9c8-371e-4c6c-9c4b-b930c65c23be/config
C repro:   https://ci.syzbot.org/findings/ccbdbde1-d214-4e90-aeb7-d4bbda01329c/c_repro
syz repro: https://ci.syzbot.org/findings/ccbdbde1-d214-4e90-aeb7-d4bbda01329c/syz_repro

------------[ cut here ]------------
!ext4_emergency_state(inode->i_sb) && mapping_tagged(&inode->i_data, PAGECACHE_TAG_DIRTY)
WARNING: fs/ext4/inode.c:192 at ext4_evict_inode+0xce7/0x1020 fs/ext4/inode.c:191, CPU#1: syz-executor/5917
Modules linked in:
CPU: 1 UID: 0 PID: 5917 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:ext4_evict_inode+0xce7/0x1020 fs/ext4/inode.c:191
Code: f3 ff ff e8 ab 60 40 ff 49 89 dc 48 8b 5c 24 18 e9 ea f5 ff ff e8 99 60 40 ff 48 8b 5c 24 18 e9 db f5 ff ff e8 8a 60 40 ff 90 <0f> 0b 90 e9 cd f5 ff ff e8 7c 60 40 ff 48 8d 3d 85 e4 92 0d 67 48
RSP: 0018:ffffc900057e79a0 EFLAGS: 00010293
RAX: ffffffff82852b46 RBX: ffff88812000f5b8 RCX: ffff88811128ba00
RDX: 0000000000000000 RSI: 0000000004000000 RDI: 0000000000000000
RBP: ffffc900057e7ab0 R08: ffff8881111b6387 R09: 1ffff11022236c70
R10: dffffc0000000000 R11: ffffed1022236c71 R12: 1ffff92000afcf44
R13: dffffc0000000000 R14: 0000000004000000 R15: ffff8881111b6380
FS:  0000555570b0d500(0000) GS:ffff8882a9464000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff533fce88 CR3: 000000010b644000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 evict+0x61e/0xb10 fs/inode.c:846
 dispose_list fs/inode.c:888 [inline]
 evict_inodes+0x75a/0x7f0 fs/inode.c:942
 generic_shutdown_super+0xaa/0x2d0 fs/super.c:632
 kill_block_super+0x44/0x90 fs/super.c:1725
 ext4_kill_sb+0x68/0xb0 fs/ext4/super.c:7459
 deactivate_locked_super+0xbc/0x130 fs/super.c:476
 cleanup_mnt+0x437/0x4d0 fs/namespace.c:1312
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:325 [inline]
 do_syscall_64+0x32d/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb75539d9d7
Code: a2 c7 05 1c ed 24 00 00 00 00 00 eb 96 e8 e1 12 00 00 90 31 f6 e9 09 00 00 00 66 0f 1f 84 00 00 00 00 00 b8 a6 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007ffe2e6b7108 EFLAGS: 00000246 ORIG_RAX: 00000000000000a6
RAX: 0000000000000000 RBX: 00007fb755431f90 RCX: 00007fb75539d9d7
RDX: 0000000000000000 RSI: 0000000000000009 RDI: 00007ffe2e6b71c0
RBP: 00007ffe2e6b71c0 R08: 00007ffe2e6b81c0 R09: 00000000ffffffff
R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe2e6b8250
R13: 00007fb755431f90 R14: 000000000000f951 R15: 00007ffe2e6b8290
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
