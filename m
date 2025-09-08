Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 61B7A2E22A3
	for <syzbot@lists.linux.dev>; Mon,  8 Sep 2025 06:54:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757314464; cv=none; b=oFV3XFIaFl6EXdWa2Gubu+0pCd7ek5Kz4hoiWtnVLyWZAMMPVE/EKhp7+6WqRtasuJkB4KDtr5TIQrpqJ/zHKav6KRxhT8McvAJgrSRCAgKQ8g4shdIPudx6iX7acmc624YSCGDiC1BAcy/jt//+VpY8Jlaw7mtT0a6qM/qz7Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757314464; c=relaxed/simple;
	bh=/rIr2d8Q/VceCZn2seP8jg9q6IuU4WX3KDColjkoiKg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=WrjWhnRo0csoyi3+kcjswc13rHWULiXYDLof+D+n2Ry9hrGBAZI7ODS02ipUvUrYOj3yrclypG6cgzSW4k7dgA6H+en2l+Fwei41vYO2yVh8Yh+AScJB0kk0Guxl7+o6YfFy3pEYUAKeq1cckzWLi04RxgOJkBTYjR7Cj3yMvJA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3ec4acb4b61so50260965ab.0
        for <syzbot@lists.linux.dev>; Sun, 07 Sep 2025 23:54:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757314460; x=1757919260;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=eeXrRPyIgejXCeJuxm3Ac4RFmbo1rm6MPvzN4tnj+H0=;
        b=QjqbftkXrzB9/9Iu0L3SQ65R0lYXu+IaRgZSaEnIuwAkWSImCWbBEGugnMzzY/xgE8
         /ZCM8TCSGaqGJ4Rsg4/jScAahneSaPNSzDM8tbeG1OiOCXTH0b+MI3nFPYAVpeJS+tGV
         3pUdo7I5qP9r/ubbZOPHLgwC0JYv/0Tscb8u6Zn/y9EZppXcAIUev4NqWxTxXVCprba4
         Ahc/iyZIeJmyAq2kLyIaF/uCvpwthdDB4dzIoO2IPiYRcvM0EPyenHA2HivwwgRYDm+B
         LugLU99mNBczvvcS4oKGsxTNE5hPcgUE2Fy7Yezeg2SyMAK9nUu4mmKHcfume+R3qJPd
         W84w==
X-Gm-Message-State: AOJu0YzfuPy5GHVIJWJK7+LvId50hq2PPtl/+DKU2cS0Vksal99CxxAf
	xHGknGgdQJngUPLeSz3FsZ5B93i/VOpyDV93lC1ggl8Mq1dwE9RJEU2yLQN+0HF0M+YvZ5l1IuL
	PP1FdtbUNtLdAiXW/mB/m9/VTIJcPppiZNjlxCHhM4wjw88O2fYi4HbiQSWA=
X-Google-Smtp-Source: AGHT+IEHzVwxQ+idrbjlPpfSnJ42RVk67+cbnVu56F0ansDNYkV+viWueojAKjIWUsTglqs7rHm0m8C0piTahpr6RzlnJVbfQiVe
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1808:b0:40c:50c:376 with SMTP id
 e9e14a558f8ab-40c050c05a1mr892635ab.26.1757314460533; Sun, 07 Sep 2025
 23:54:20 -0700 (PDT)
Date: Sun, 07 Sep 2025 23:54:20 -0700
In-Reply-To: <20250905132019.18915-1-yajun.deng@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68be7d9c.050a0220.192772.0853.GAE@google.com>
Subject: [syzbot ci] Re: mm/rmap: make num_children and num_active_vmas update
 in internally
From: syzbot ci <syzbot+ci787cecc1f1f83578@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, harry.yoo@oracle.com, 
	liam.howlett@oracle.com, linux-kernel@vger.kernel.org, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, riel@surriel.com, vbabka@suse.cz, 
	yajun.deng@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] mm/rmap: make num_children and num_active_vmas update in internally
https://lore.kernel.org/all/20250905132019.18915-1-yajun.deng@linux.dev
* [PATCH] mm/rmap: make num_children and num_active_vmas update in internally

and found the following issue:
WARNING in unlink_anon_vmas

Full report is available here:
https://ci.syzbot.org/series/8f2c8574-826d-4951-a11c-201f9e6fa666

***

WARNING in unlink_anon_vmas

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      b320789d6883cc00ac78ce83bccbfe7ed58afcf0
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/6702bc54-be0f-4db2-85d2-1488a2ec7040/config

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5260 at mm/rmap.c:444 unlink_anon_vmas+0x63c/0x670
Modules linked in:
CPU: 1 UID: 0 PID: 5260 Comm: mount Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:unlink_anon_vmas+0x63c/0x670
Code: 08 00 48 3b 6c 24 08 74 29 e8 30 7e af ff 49 89 ee e9 d0 fd ff ff e8 23 7e af ff 90 0f 0b 90 e9 4e fe ff ff e8 15 7e af ff 90 <0f> 0b 90 e9 82 fe ff ff e8 07 7e af ff eb 05 e8 00 7e af ff 48 83
RSP: 0018:ffffc90001bef878 EFLAGS: 00010293
RAX: ffffffff82102ffb RBX: ffff888109476118 RCX: ffff8880215d9cc0
RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000000
RBP: ffff88810f31e030 R08: ffff88810947611f R09: 1ffff1102128ec23
R10: dffffc0000000000 R11: ffffed102128ec24 R12: ffffffffffffffff
R13: 1ffff110212a6ce2 R14: ffff888109536710 R15: ffff888109476110
FS:  0000000000000000(0000) GS:ffff8881a3c18000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f8adf7b0440 CR3: 000000000df36000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 free_pgtables+0x72b/0x9c0
 exit_mmap+0x444/0xb50
 __mmput+0x118/0x420
 exit_mm+0x1da/0x2c0
 do_exit+0x648/0x2300
 do_group_exit+0x21c/0x2d0
 __x64_sys_exit_group+0x3f/0x40
 x64_sys_call+0x21f7/0x2200
 do_syscall_64+0xfa/0x3b0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f8adf86ea90
Code: Unable to access opcode bytes at 0x7f8adf86ea66.
RSP: 002b:00007fffb8de8148 EFLAGS: 00000246 ORIG_RAX: 00000000000000e7
RAX: ffffffffffffffda RBX: 00007f8adf95f860 RCX: 00007f8adf86ea90
RDX: 00000000000000e7 RSI: 000000000000003c RDI: 0000000000000000
RBP: 00007f8adf95f860 R08: 00007fffb8de7fc0 R09: 00007fffb8de80a0
R10: 00007fffb8de8000 R11: 0000000000000246 R12: 0000000000000000
R13: 0000000000000000 R14: 00007f8adf963658 R15: 0000000000000001
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
