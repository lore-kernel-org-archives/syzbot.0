Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B981D43C07F
	for <syzbot@lists.linux.dev>; Tue,  5 May 2026 13:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777986513; cv=none; b=IkA2tsasvsdyEJSJclmVNlVkO1BsVNHOUaF426PI+YX9cJa1Iq2OX3f5/OmHoAq9uP3CQ25Hxgqw6ezwh27XpI9XaeEnjBmd2MHmMcSx1kwWK4yJAt1xVpuO8BcclwdGnW28WeLrUtcyahNYkpR1fZoYoXnNMGqt8jG33BsPOLg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777986513; c=relaxed/simple;
	bh=sFevfuThPnK9sIPvedInedMJ5eGsSSn0G/pa7IgRNzY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Jnm0oBqXWO46zLbtLVgxEjdZ8l3NiHyojx0XVnKRIBjID3A4RI8Jad/ydxQBhgGQdRLUdhs6wnMotd86hCLNkKmmbZ/wv20rMoS/iNU9fNyKy3q78bjCK0HippUpA1saQYNS9upypjj3FHcBRkKotH7JvgE52somMUe6Vdb12RU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6966f1f4490so10730447eaf.1
        for <syzbot@lists.linux.dev>; Tue, 05 May 2026 06:08:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777986511; x=1778591311;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=LTYFpGF2sAJ08QtA3xEO+n4nsS4Uz+UMNVOp/UWwx7k=;
        b=iTkQQr0og0aUAgho6mvI4bdmWwRXd6gZDimdliwODmHHfXxK4/1E2jhz64LSAFv0at
         b3xX/rrY2+3+1MWEquOjZiC5JY8NZAyQesUx1goK4QawttG8dECXlXAZhVJnqvfhH3Xn
         Murkcix655xxRRG4PT4/yxjdr9qbMe6oW+SfMkSu2xJgJR8fwZ5Le30FRVww7RTIg5vw
         cPOt0vpYyAKs/a1vhHcMnk6tTKFsDb+MTLxg3Jwy2tPUiF13ieYkSd0BTJDO7vgeQN+6
         usAnrzghQMh2K8e//FksbDd6qhNAq5sM2r/ympar4MvdZUKMG9yRwVX/z2bWN39T1EHp
         kPDw==
X-Gm-Message-State: AOJu0YzJ0eLx0mPXXsrCPY2tFi2xDTY4baKiIsA2c922zn/6fdZLJBiC
	pT6K0L2J+8KMBfcCqu90bV4ChfIsXg7E0zd4bbiPF62tYeGgIzhi/JP7Tqa4qwqOxxuF3h0aHLT
	1AYgnHw8FEFX59/E/Ci75AP/CCfUQWMmwKw42DHscJGW62XaSsE1m00h8qgM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:e16:b0:694:857a:5a78 with SMTP id
 006d021491bc7-698876f07f9mr1294157eaf.8.1777986510804; Tue, 05 May 2026
 06:08:30 -0700 (PDT)
Date: Tue, 05 May 2026 06:08:30 -0700
In-Reply-To: <6de5d329-9162-4992-85cb-f946f2d5c0b1@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f9ebce.170a0220.59368.0011.GAE@google.com>
Subject: [syzbot ci] Re: io_uring/rsrc: remove registered buffer 1GB limit
From: syzbot ci <syzbot+ci5f475aa1640b4177@syzkaller.appspotmail.com>
To: andres@anarazel.de, axboe@kernel.dk, io-uring@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] io_uring/rsrc: remove registered buffer 1GB limit
https://lore.kernel.org/all/6de5d329-9162-4992-85cb-f946f2d5c0b1@kernel.dk
* [PATCH] io_uring/rsrc: remove registered buffer 1GB limit

and found the following issue:
WARNING in io_pin_pages

Full report is available here:
https://ci.syzbot.org/series/576c7f20-d7fb-471a-a534-f8f67489e049

***

WARNING in io_pin_pages

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      c7e4e4d5f7dc2daa439303d1b5bf6bdfaa249f49
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/287c9ce7-c085-4a41-9f94-756762f8dacf/config
syz repro: https://ci.syzbot.org/findings/63ff94b0-aced-41c6-83fc-a917c57ad624/syz_repro

------------[ cut here ]------------
!(flags & __GFP_NOWARN)
WARNING: mm/slub.c:6840 at __kvmalloc_node_noprof+0x7be/0x8a0 mm/slub.c:6840, CPU#1: syz.1.18/5830
Modules linked in:
CPU: 1 UID: 0 PID: 5830 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__kvmalloc_node_noprof+0x7be/0x8a0 mm/slub.c:6840
Code: ff 48 c7 c7 d0 bd a8 8e 48 89 de e8 dc 48 c9 02 e9 49 fc ff ff 48 c7 c7 10 be a8 8e 48 89 de e8 c8 48 c9 02 e9 7e fc ff ff 90 <0f> 0b 90 45 31 e4 e9 f8 fd ff ff 90 0f 0b 90 e9 52 ff ff ff 49 83
RSP: 0018:ffffc90003a37928 EFLAGS: 00010246
RAX: 0000000000000004 RBX: 0000000201000008 RCX: 0000000080000001
RDX: 0000000201000008 RSI: ffffffff8c28ac40 RDI: ffffffff8c28ac00
RBP: ffffc90003a37b70 R08: 00000000004028c0 R09: 00000000ffffffff
R10: 0000000000000006 R11: 0000000000000000 R12: 0000000000000000
R13: 00000000004028c0 R14: 0000000000000016 R15: 00000000ffffffff
FS:  00007fb3823ec6c0(0000) GS:ffff8882a9290000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffcca0efe68 CR3: 000000017064e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 io_pin_pages+0xac/0x1a0 io_uring/memmap.c:59
 io_sqe_buffer_register+0x228/0x1860 io_uring/rsrc.c:801
 io_sqe_buffers_register+0x2f9/0x7e0 io_uring/rsrc.c:913
 io_register_rsrc+0x24d/0x280 io_uring/rsrc.c:414
 __io_uring_register io_uring/register.c:843 [inline]
 __do_sys_io_uring_register io_uring/register.c:1029 [inline]
 __se_sys_io_uring_register+0xc5d/0x1ac0 io_uring/register.c:1006
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb38159cdd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fb3823ec028 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007fb381815fa0 RCX: 00007fb38159cdd9
RDX: 0000200000002700 RSI: 000000000000000f RDI: 0000000000000003
RBP: 00007fb381632d69 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000020 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fb381816038 R14: 00007fb381815fa0 R15: 00007fffdb4e7d78
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
