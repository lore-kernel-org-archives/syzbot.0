Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 928A93ACEF6
	for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 05:44:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784526263; cv=none; b=kLLznGKTWU4Bfdp/dTIPiWLFcA2c5gS+pN50LTmkfzWLyC/hBSwv8jZRSuDcLYZeo5v332uPIJFnIPM385SDCEdR0DGR0WXccfODVnvDttnamYFrNKSvLYTlcYkGQSrnzXuqRRNb7kv9rH+qjin87npGmWzxjpQjLzLW+Rg4Wos=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784526263; c=relaxed/simple;
	bh=hMJYk63jYTKYl2K0epFx99MYj2Ieyi9aeQfRdRN04oY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=BtB816lvHupy5TWTQMqq/0ZnVntlKfnHeRHrvksnIDo1IjqcOgh8T9xRZviNJs2VMSvZDFApUBMqCeF3LjjF2rAJ5rexQ8qJuwol/Iw21+IeOdQxN/3QdGDfooHXoDQ08n7oosGBqPfRRNmGPejGsOPKZZIESlrP2PGfjIbsynw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-495f637105eso16101590b6e.2
        for <syzbot@lists.linux.dev>; Sun, 19 Jul 2026 22:44:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784526259; x=1785131059;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2QT3amnQuOcBZg4d5t9FX/DT2Foz3U803AO99pto81Y=;
        b=h9t4+8gntOFaOAPAkOuYe40gYJ5g7BQn4AA/CAg2EOrXug2qkjT4q1u5JtITDTlcwZ
         /+qvdMtL0/R46cywQ/N7knrcYkIuJZ/vTdcSg8HQBDIlBXUvveL51BlR105wW6dgsweV
         24nL65soxfKtP+NIyEJh0TIabQWA7TPAuXbbOWx3nisWAG1IHOy7qbrSW7eKb+WqOZcY
         GpQ+VuD5+kKaJBna4k5HTr0A7TLT4so0tTZAZU9gso0W9g5MeKExQrGMr59NbhThkos1
         yZygJcz24oZ1p+H4Vd7vPo4J8cciKdhhg8DEqV+byDEVJ1GgIGVMTszwog+8MQwGWNWG
         tzaA==
X-Gm-Message-State: AOJu0YxsNQyI2umgKNKwX67ONalZuB8CQ+3PPeYio2hNH+NtApSXtPWa
	a07JQJNQJ0siBVH3KnCROVLJ/FR4n3FQLF/fjHFScZQk9xrsChiskRQiAXAhzG7xqiESBTZcTLl
	WCDD89gO0nKilp0pEAlW4dKw4ORQCFo60TsCVPgkcA8d11fGteIBf4fzrmgg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:190f:b0:496:dfe1:6d91 with SMTP id
 5614622812f47-4a4d056a3c9mr6819881b6e.42.1784526259157; Sun, 19 Jul 2026
 22:44:19 -0700 (PDT)
Date: Sun, 19 Jul 2026 22:44:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5db5b3.5028b7d0.1f0bb.02ba.GAE@google.com>
Subject: [moderation/CI] Re: ext4: convert pa_count from atomic_t to refcount_t
From: syzbot ci <syzbot+ci90c3f9db18465f21@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] ext4: convert pa_count from atomic_t to refcount_t
https://lore.kernel.org/all/20260720034441.3900050-1-rafad900@gmail.com
* [PATCH] ext4: convert pa_count from atomic_t to refcount_t

and found the following issue:
WARNING: refcount bug in ext4_mb_use_preallocated

Full report is available here:
https://ci.syzbot.org/series/34fda797-e979-409c-bc2d-7af3e163df14

***

WARNING: refcount bug in ext4_mb_use_preallocated

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      1590cf0329716306e948a8fc29f1d3ee87d3989f
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/05fa6c1d-a594-4691-ace3-ded3fc2ca4dc/config

------------[ cut here ]------------
refcount_t: addition on 0; use-after-free.
WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x9f/0x110, CPU#0: kworker/u9:2/51
Modules linked in:
CPU: 0 UID: 0 PID: 51 Comm: kworker/u9:2 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: writeback wb_workfn (flush-8:0)
RIP: 0010:refcount_warn_saturate+0x9f/0x110
Code: eb 66 85 db 74 3e 83 fb 01 75 4c e8 8b 73 0c fd 48 8d 3d 34 58 84 0b 67 48 0f b9 3a eb 4a e8 78 73 0c fd 48 8d 3d 31 58 84 0b <67> 48 0f b9 3a eb 37 e8 65 73 0c fd 48 8d 3d 2e 58 84 0b 67 48 0f
RSP: 0018:ffffc90000bb6590 EFLAGS: 00010293
RAX: ffffffff84b9ee08 RBX: 0000000000000002 RCX: ffff8881072a8000
RDX: 0000000000000000 RSI: ffffffff8f126800 RDI: ffffffff903e4640
RBP: ffff888112257dd0 R08: ffff8881072a8000 R09: 0000000000000005
R10: 0000000000000004 R11: 0000000000000000 R12: dffffc0000000000
R13: ffff888112257d98 R14: ffff888112257e10 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff88818dc15000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc831b2c080 CR3: 0000000112724000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ext4_mb_use_preallocated+0xaa0/0x14e0
 ext4_mb_new_blocks+0x5a0/0x4560
 ext4_ext_map_blocks+0x1534/0x5850
 ext4_map_create_blocks+0x116/0x530
 ext4_map_blocks+0x7e4/0x1240
 ext4_do_writepages+0x23d3/0x47a0
 ext4_writepages+0x241/0x3b0
 do_writepages+0x338/0x560
 __writeback_single_inode+0x12e/0xf90
 writeback_sb_inodes+0x9de/0x1b00
 __writeback_inodes_wb+0x114/0x240
 wb_writeback+0x42f/0xad0
 wb_workfn+0x980/0x10f0
 process_scheduled_works+0xa8e/0x14e0
 worker_thread+0xa47/0xfb0
 kthread+0x388/0x470
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
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
[adilger.kernel@dilger.ca jack@suse.cz libaokun@linux.alibaba.com linux-ext4@vger.kernel.org linux-kernel@vger.kernel.org rafad900@gmail.com tytso@mit.edu]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

