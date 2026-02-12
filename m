Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93EADE571
	for <syzbot@lists.linux.dev>; Thu, 12 Feb 2026 23:15:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770938146; cv=none; b=q1eyKWHpCUaBtYyQHKDEBki7UB6/swJrGuKVs1aHmG67H9BapOyEb2SnuTc4nJYdjaMMsavXnRyCmxzSP/z4DwurBvMwS3SQ2xo7bRTMsvOQwHtYjwcY/devMBzV2xGdU4nqQQBk3xojCvkG+bBZ3xlzAfqCUXWAw/Y0S+llJuY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770938146; c=relaxed/simple;
	bh=xBzQzJmq14YXIxHtefoP8HVoVs+qDCcNJL8CgWa2Vlk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=arCeP8HidmOiZAgmAAGHkTeuQKcgXrzLzL9U4V5xiKJ9zEcb7cv3DxqH0Dormi7N/Wp/krwCnyQP3bNSHh/lAmnURnwmT6wrYZSi8BdpXpeOxqlvwjUwMijXcRhz6+pcI7C/ISZn2E4tuEQ7ffGoeqKdms5VKU6bQMwHF+jCoKQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-40450320b4fso2032164fac.0
        for <syzbot@lists.linux.dev>; Thu, 12 Feb 2026 15:15:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770938144; x=1771542944;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=O0lu37aLRPPLTFeHLhq/Qr8lpi3+g+Cq8dO+U82KwgA=;
        b=Cay6OICIFjQQvDS/SIByNBysQbJvyFiMLz0r+AUdAaBms2BST+PqGfZ4eiti9ndJJI
         V5hc8hBolL4C5CFATeFnlDGQbeq6gi70mLUeE6338DHZZvMcFV9VYpgnqj2YhhKnfagE
         HCuN616PPyK6uBKQvOeWyBkYgEbHTDBFx+gVgApbQVT7AM2z4tclmdiV1IGgIQuO3iyz
         6ju+/WgdSXlOJ43ucB+Z2MdJqBrKJZe3zRH9t0AQQaQip6l7iHaGpkXXQ6C1wAZ0Fe9E
         eMKzoieKxEh4hUdhaV8xU5RsK5GvjygjA85yS13zNC6NZeY4//4UaeCYIAbmMYvL+iiH
         gFPQ==
X-Gm-Message-State: AOJu0YzbRO6Rf/2Xv6He8lhLSj2y3hP0710OlbG+ViNOGXtNDAGwHs2/
	m7N3pjNpK7ocFz1xHKOKYue+X+/HJr1BUbtyXflMHonGKWc6sRAAzNY+Hfknf1w9nLXd/t7NDr1
	WbVtjSBjDvkBAieLAn5hUy2Iu5hhDgCq1v+Sm6I4HEqCvupgFQ1UCpCuKshA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:160c:b0:674:a4e1:18e6 with SMTP id
 006d021491bc7-677216fc46bmr262479eaf.24.1770938144573; Thu, 12 Feb 2026
 15:15:44 -0800 (PST)
Date: Thu, 12 Feb 2026 15:15:44 -0800
In-Reply-To: <20260212170849.12455-1-almaz.alexandrovich@paragon-software.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <698e5f20.a70a0220.2c38d7.00a5.GAE@google.com>
Subject: [syzbot ci] Re: fs/ntfs3: add delayed-allocation (delalloc) support
From: syzbot ci <syzbot+cife27aa3114ea3df8@syzkaller.appspotmail.com>
To: almaz.alexandrovich@paragon-software.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, ntfs3@lists.linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] fs/ntfs3: add delayed-allocation (delalloc) support
https://lore.kernel.org/all/20260212170849.12455-1-almaz.alexandrovich@paragon-software.com
* [PATCH] fs/ntfs3: add delayed-allocation (delalloc) support

and found the following issue:
WARNING in ntfs_extend_initialized_size

Full report is available here:
https://ci.syzbot.org/series/13e78e99-d298-48f9-b81b-be0931799244

***

WARNING in ntfs_extend_initialized_size

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      9152bc8cebcb14dc16b03ec81f2377ee8ce12268
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/b551b487-d04a-4a8a-89aa-575a75c69c23/config
C repro:   https://ci.syzbot.org/findings/c8966f1e-fd77-42d2-8f24-1e7b54ac54dd/c_repro
syz repro: https://ci.syzbot.org/findings/c8966f1e-fd77-42d2-8f24-1e7b54ac54dd/syz_repro

loop0: detected capacity change from 0 to 4096
------------[ cut here ]------------
is_compressed(ni)
WARNING: fs/ntfs3/file.c:236 at ntfs_extend_initialized_size+0x1dc/0x210 fs/ntfs3/file.c:236, CPU#1: syz.0.17/5975
Modules linked in:
CPU: 1 UID: 0 PID: 5975 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:ntfs_extend_initialized_size+0x1dc/0x210 fs/ntfs3/file.c:236
Code: 0d ff 4c 89 33 31 ed eb 05 e8 70 8b a3 fe 89 e8 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 9b a6 8e 08 cc e8 55 8b a3 fe 90 <0f> 0b 90 e9 31 ff ff ff 89 d1 80 e1 07 80 c1 03 38 c1 0f 8c e1 fe
RSP: 0018:ffffc90004547c30 EFLAGS: 00010293
RAX: ffffffff8322128b RBX: ffff8881a8229670 RCX: ffff88810ba49d00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000800 R08: ffff8881a8229737 R09: 1ffff110350452e6
R10: dffffc0000000000 R11: ffffed10350452e7 R12: 0000000000000110
R13: 0000000000000ef0 R14: 1ffff110350452ce R15: 0000000000000000
FS:  000055555ee59500(0000) GS:ffff8882a9460000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f811e871980 CR3: 000000010f87c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 ntfs_fallocate+0xf21/0x1220 fs/ntfs3/file.c:670
 vfs_fallocate+0x669/0x7e0 fs/open.c:340
 ksys_fallocate fs/open.c:364 [inline]
 __do_sys_fallocate fs/open.c:369 [inline]
 __se_sys_fallocate fs/open.c:367 [inline]
 __x64_sys_fallocate+0xc0/0x110 fs/open.c:367
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f811e99bf79
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffecc78b558 EFLAGS: 00000246 ORIG_RAX: 000000000000011d
RAX: ffffffffffffffda RBX: 00007f811ec15fa0 RCX: 00007f811e99bf79
RDX: 0000000000000003 RSI: 0000000000000000 RDI: 0000000000000005
RBP: 00007f811ea327e0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000006 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f811ec15fac R14: 00007f811ec15fa0 R15: 00007f811ec15fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
