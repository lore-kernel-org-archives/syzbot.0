Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6E0272236FC
	for <syzbot@lists.linux.dev>; Tue, 30 Dec 2025 00:20:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767054050; cv=none; b=rsdaidTGrcs9p7OUXHF2RuDpHYoUXpTgnZBQVLxEaOXKs2dqN9jn1tm2gObErTxjepAoCAcj6kv+4UtAvN9S6Ex8dTmhHX8DkFUGUvDHbQ1QhGdgaxmvb3mDy19tmVhe1Y75JQb0WJAdmcCuRyKSXGnaHj+8Xu27MCzm5VLQyQc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767054050; c=relaxed/simple;
	bh=EDYiaKSznEiGC5hfoIyS/7nwxm/6MvdCmeSkco0ItYg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=RQyKcVXF1nkgRL2K5wXVwmoPpNQTgfRPhaREpiiMAYlVEo8I/VQCHCkv2FAhPU47urC7Zo2IMHWjgIyHcL8cUBJOyQEx7rUm5KjycjOlDzKGWpvAxz5XgFyyuz12elgD6DyT7vyszIDNikmoTrr56DXAkF31G1t8gJgc7EOBMVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-6574d564a9eso17552497eaf.2
        for <syzbot@lists.linux.dev>; Mon, 29 Dec 2025 16:20:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767054043; x=1767658843;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=TnMoiyCysSf+ilPph9x4D491BO2SpNdwPyFbvvErqqg=;
        b=WkIaJfLgJ4DtGlF9yc5DuAReal4JsJxtUJ5KmDE8z9NWXXWU7+z0vEkZ2yAoNBE0mr
         WyauG2GoyxEbXHOARQ8nylYTUmhe9VV6+rU/S3EpnsM/tP1Z/kDH4+hVODfKG23Bo0sM
         dMykjyElJsamfvAMl4jr/9DEv1auZqX/7J8uJoWcamp4nOIxbu5VNrROEWrScfCVCraR
         YNTbwhmKJ6oo+xSbNobc9syKmgqklvXn68G0X/w6iN4C/WtYBGMnT0NZDQNegHeJq2hR
         /7QGZgHwjfCi28kjsO0byW3DJ5ewo+nxupfL+Ua+tpsaTHyEPbPKG1IoDZ/KL1I6k5Ot
         eLXQ==
X-Gm-Message-State: AOJu0YwPIxZcrFCgUtJBZvdUNER97zLgwctoK3UC4Fkz3byig5hnKy+w
	Dqpv8ouOuLZXyc2BTnJtPBaaKEIN1JOlxQRQTKtpCXLYFzEXONf+WG7e4AeGLFunJssuLoLCBgV
	uPbkqPhiOAi16EdaH7d2Z3dIsIn3YGbD5Z8OQjImiNFPTYnSCLkKVs4HctyI=
X-Google-Smtp-Source: AGHT+IGKQ5OyHiJNqvyhAlAhn+2Z8hPqW8hC4pScFjV1+NMuzdEhy8vR5Xaaps8jAVOLRHXGz57tW4yfr7OKjaIq64/iADWuvbdO
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:168c:b0:65d:b36:bddb with SMTP id
 006d021491bc7-65d0ead9c3fmr13709575eaf.62.1767054043734; Mon, 29 Dec 2025
 16:20:43 -0800 (PST)
Date: Mon, 29 Dec 2025 16:20:43 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69531adb.050a0220.329c0f.0425.GAE@google.com>
Subject: [moderation/CI] Re: io_uring: make overflowing cqe subject to OOM
From: syzbot ci <syzbot+ci169c5783fd9cb9a6@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] io_uring: make overflowing cqe subject to OOM
https://lore.kernel.org/all/20251229201933.515797-1-alexandre@negrel.dev
* [PATCH] io_uring: make overflowing cqe subject to OOM

and found the following issue:
WARNING in io_get_cqe_overflow

Full report is available here:
https://ci.syzbot.org/series/d71ff874-04e1-4cc7-b7c0-e48eb77bc984

***

WARNING in io_get_cqe_overflow

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/c13ff885-4e87-4df2-9d49-a52f3d040dd6/config
C repro:   https://ci.syzbot.org/findings/e3c6e33b-4e4e-45de-b5b7-4ff5fc363989/c_repro
syz repro: https://ci.syzbot.org/findings/e3c6e33b-4e4e-45de-b5b7-4ff5fc363989/syz_repro

------------[ cut here ]------------
WARNING: io_uring/io_uring.h:211 at io_lockdep_assert_cq_locked io_uring/io_uring.h:211 [inline], CPU#0: syz.0.17/5984
WARNING: io_uring/io_uring.h:211 at io_get_cqe_overflow+0x599/0x730 io_uring/io_uring.h:249, CPU#0: syz.0.17/5984
Modules linked in:
CPU: 0 UID: 0 PID: 5984 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:io_lockdep_assert_cq_locked io_uring/io_uring.h:211 [inline]
RIP: 0010:io_get_cqe_overflow+0x599/0x730 io_uring/io_uring.h:249
Code: 0f 0b 90 e9 0e fb ff ff e8 c4 29 35 fd 90 0f 0b 90 e9 91 fb ff ff e8 b6 29 35 fd 90 0f 0b 90 e9 6a fd ff ff e8 a8 29 35 fd 90 <0f> 0b 90 e9 5c fd ff ff e8 9a 29 35 fd 90 0f 0b 90 e9 4a fd ff ff
RSP: 0018:ffffc90003cf7958 EFLAGS: 00010293
RAX: ffffffff848d4748 RBX: 0000000000000000 RCX: ffff888110c8ba80
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000000 R08: ffff888110c8ba80 R09: 0000000000000002
R10: 00000000fffffdef R11: 0000000000000000 R12: 0000000000000000
R13: 1ffff11022544c00 R14: ffff888112a26000 R15: dffffc0000000000
FS:  00005555940b9500(0000) GS:ffff88818e40f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30563fff CR3: 00000001731de000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 io_get_cqe io_uring/io_uring.h:271 [inline]
 io_fill_cqe_req io_uring/io_uring.h:293 [inline]
 __io_submit_flush_completions+0x11c/0xe50 io_uring/io_uring.c:1507
 io_submit_flush_completions io_uring/io_uring.h:239 [inline]
 io_submit_state_end io_uring/io_uring.c:2318 [inline]
 io_submit_sqes+0x1c26/0x2130 io_uring/io_uring.c:2433
 __do_sys_io_uring_enter io_uring/io_uring.c:3264 [inline]
 __se_sys_io_uring_enter+0x2f7/0x2c30 io_uring/io_uring.c:3203
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f00d579acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc380f6178 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
RAX: ffffffffffffffda RBX: 00007f00d5a05fa0 RCX: 00007f00d579acb9
RDX: 0000000000000002 RSI: 0000000000004d10 RDI: 0000000000000003
RBP: 00007f00d5808bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f00d5a05fac R14: 00007f00d5a05fa0 R15: 00007f00d5a05fa0
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[alexandre@negrel.dev axboe@kernel.dk io-uring@vger.kernel.org linux-kernel@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

