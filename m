Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7DBE30DD2F
	for <syzbot@lists.linux.dev>; Sun,  1 Mar 2026 02:44:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772333085; cv=none; b=S5A5AyvaJaXH6PU87t1hqqxKWpDuO5IyjKBB5pIOTYuEYJqrOjiNgrg13CHsVVddlvn6PhJSrmdGsix30EowPJi2K9MCbPS/9aIw+8fl5tvWpmAOwrpyxrUTjYj0VDlkUlMkjypSKkSa6djWa4IaAfM8aMHMbuoJvNNW9C1NmCQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772333085; c=relaxed/simple;
	bh=B8urDf2/XhgfUxYffQ/4IH4KtOUv9ys7Swn2M64liv8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=pWr0fZ2EbLqEooJmh1AhkgukPYpARMfy67yjzCGY/RTd9Ct9NcDBH0qI1howh54C0ZxBzLpf6pKWqBhYq91uWTeBECLhD4s4l/RJQGWwB6XVTxJB5nI+xFu41D7D2/LFCkch3SOCy9qzzMrBwwtZ81M85/+fzc+k5VgmXylcxXg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-679c5fde4c7so81744004eaf.0
        for <syzbot@lists.linux.dev>; Sat, 28 Feb 2026 18:44:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772333082; x=1772937882;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UW9NMcRxlGRHElV78e0lTLrYDCRBzGp5FjqbZ8cvEHY=;
        b=dTs+QSIJQtv6eGj9PWtZ/bQmlwrw+sW3lsnF8zbqen0/qNNep7AcsTS/5BT15wh/Tz
         LIXtfeTYmIUS07UtqUawEHVE966QazKiM76TjP8PeXU1VaGd2rVBQnZU1SBAvVXnPETa
         8pmFEZ455dnaTsXTjjeDwF8DyZTLFn/UU5k6YgMPibkZ/qs8a9byYz3c890olWZLpqgM
         1tV9ZAytrz3uqJpj9Rkn1YbHL+3RoLdxIVe6jQ7g017LJ13i88laz7tNJiUCaRyYhD05
         +vbNed6rzOVr8YlAntBz9k3U6YOCLdNLTdAUG2UwqtHX+JsxRTKt26O+fyWKrxUoU7t6
         s8JQ==
X-Gm-Message-State: AOJu0YzW3bkfyjYsZQicd9EO2bBzauMNJreGv15DgYeDwJRs+ohfU5bY
	pOddkLJaf+CDU3IOA+W3MfdKz6/ssLMTh8iifg4VFKdW5AIi2x7ins6k+hSvRgIfd4qwdwLZm2c
	QlZzfpTMWQYVbsa0OiwBhzgzb+UssKt/UYJMdN8oS5ZGAk2JRBPDWPsg0vJI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:e845:0:b0:677:cb1:37fd with SMTP id
 006d021491bc7-679faf86685mr4607834eaf.58.1772333082620; Sat, 28 Feb 2026
 18:44:42 -0800 (PST)
Date: Sat, 28 Feb 2026 18:44:42 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a3a81a.050a0220.8405f.0000.GAE@google.com>
Subject: [moderation/CI] Re: ext4: test if inode's all dirty pages are
 submitted to disk
From: syzbot ci <syzbot+cic23c5bac8a4912b2@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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

The email will later be sent to:
[adilger.kernel@dilger.ca jack@suse.cz linux-ext4@vger.kernel.org tytso@mit.edu yebin@huaweicloud.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

