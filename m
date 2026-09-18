Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DC043E9D2
	for <syzbot@lists.linux.dev>; Fri, 18 Sep 2026 18:46:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789757173; cv=none; b=Bc+1QnCzooAx4P7eqlgkbof4FOj0qoIXItI5o++LbpMFNOBWcOvDzMiDoisyUkg4EeKcxCqx8OYlzGOEzFB6Ob6VE8ZmNrCj1o228duyvCkY0AnSmD9LhSKJWsy2CKX0C1Qm2/Z60xevcKEBP2sfVLOrGtufJV7Krngw22V5kdY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789757173; c=relaxed/simple;
	bh=OMs9EXNtOOYltCMU+k9e9PkI/tu2TPDUGaPAcp7IvXE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=l1fqJEO5PafvvJsE0/sdy1rBND553Unl5WD+mADt5oxnm+bFldIhWjHb4XSLVhO81ydf7GL0upp9IvZksPbuzIl1BB/T5v1ShpHH/Kc4sFp8YKyLsYdaSzBe+LHAGdbwVUCg9kO/Lk3lniPIaqg5cEDm7OTSBabQdGEf6Ts8dAA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6a17dafd042so1611896eaf.2
        for <syzbot@lists.linux.dev>; Fri, 18 Sep 2026 11:46:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789757160; x=1790361960;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eQzJSsS9Zl+ml99m2w5uw8Luw+5lh7PAJ7SmWqqn2+8=;
        b=GIxaD1lyvOYBoYwC0y5Qnq6ljKL/N83o6Zw9HYBekjWSuf/7yqzsn48BFqnn1c1P/k
         jyd9YtATROWhROb00Car9F/4ps9FQYOy31nt+R04vHjnmGg/oZ1nrQ4xphWbvG5Qf2SK
         RHExEPs7Cwk6xFb4wOYT2pjahme8e4QcHuDss/nF73Q2VnwX7tCixQFOuYbXLfkvGgsI
         9ywUpfcGOb+iPxpY7b1s6GHUxX922zdxGGUBFXnlZv4N7xlcmJQYsBnXN09EZ+u+WQrF
         ExjJHCZTVl5iIjSZKny5wY7ICO3yqN3tqZKDdQXdHBPc/saC6NvRLCu8H19C78PnI5Kl
         LnrA==
X-Gm-Message-State: AFuF++kZJr1uCp9FIcSiixlPiZxPA1cATBZS++YavSiyofm+Jw10WmRB
	+6laMsYaZ4iIaLGKU3RfsKO0/SgcPH1euzpX0hn6wT43ef0eVjtM6rXZm/JGff7zExTQP8sajQw
	sn27XcSH5Kg87XIRsvBSbtMRnkQgjpEPEY/XTsvv7PSF8fdMJjcOZdQfCL04=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4c14:b0:6cd:3fdc:5fff with SMTP id
 006d021491bc7-6cd3fdc6096mr455466eaf.80.1789757160558; Fri, 18 Sep 2026
 11:46:00 -0700 (PDT)
Date: Fri, 18 Sep 2026 11:46:00 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aad86e8.b398a7c9.1f86be.003b.GAE@google.com>
Subject: [moderation/CI] Re: loop: Fix teardown
From: syzbot ci <syzbot+cid93fbb9db8ac4291@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] loop: Fix teardown
https://lore.kernel.org/all/cover.1789587960.git.bvanassche@acm.org
* [PATCH 1/2] block: Add post_release() operation
* [PATCH 2/2] loop: Perform __loop_clr_fd() after disk->open_mutex is dropped

and found the following issue:
general protection fault in lo_post_release

Full report is available here:
https://ci.syzbot.org/series/81bfb244-11b0-4b8a-aa02-a212681ff0af

***

general protection fault in lo_post_release

tree:      axboe
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe/linux.git
base:      2dd9768a37dbb99398c5e332485dbb107ac397c8
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/e21a78bb-e498-4518-8734-d31ae58a2538/config
AI triage: https://ci.syzbot.org/findings/add69d7e-57e2-465d-8c07-9db3934582f9/triage_trajectory

Oops: general protection fault, probably for non-canonical address 0xdffffc000000000a: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
CPU: 0 UID: 0 PID: 26297 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:lo_post_release+0x498/0x7f0
Code: 4c 89 ff e8 7a 73 f9 fb bf e0 01 00 00 49 03 3f be 02 00 00 00 e8 18 05 9e 05 48 8b 44 24 10 4c 8d 60 50 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00 74 08 4c 89 e7 e8 49 73 f9 fb 41 bf e8 00 00 00 4d
RSP: 0018:ffffc90003d6fb60 EFLAGS: 00010206
RAX: 000000000000000a RBX: ffff8881699b3000 RCX: 0000000000000046
RDX: 0000000000000006 RSI: ffffffff8e414976 RDI: ffffffff8c6da780
RBP: ffffc90003d6fd08 R08: ffffffff907a477f R09: 1ffffffff20f48ef
R10: dffffc0000000000 R11: fffffbfff20f48f0 R12: 0000000000000050
R13: 1ffff920007adf74 R14: dffffc0000000000 R15: ffff888169a02080
FS:  00007fa1afb46c80(0000) GS:ffff88818d6ce000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f0d423a8440 CR3: 00000001bee1a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 bdev_release+0x59a/0x6b0
 blkdev_release+0x15/0x20
 __fput+0x418/0xa50
 fput_close_sync+0x11f/0x240
 __x64_sys_close+0x7e/0x110
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa1af7170a8
Code: 48 8b 05 83 9d 0d 00 64 c7 00 16 00 00 00 83 c8 ff 48 83 c4 20 5b c3 64 8b 04 25 18 00 00 00 85 c0 75 20 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff ff 76 5b 48 8b 15 51 9d 0d 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffeef68bbb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
RAX: ffffffffffffffda RBX: 00007fa1afb46ae0 RCX: 00007fa1af7170a8
RDX: 0000559097caaeb5 RSI: 00007ffeef68b3b8 RDI: 0000000000000008
RBP: 00005595ce9a3e90 R08: 0000000000000006 R09: a8cc15e7d6acaf3b
R10: 000000000000010f R11: 0000000000000246 R12: 0000000000000002
R13: 00005595ce999920 R14: 0000000000000008 R15: 00005595ce964910
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:lo_post_release+0x498/0x7f0
Code: 4c 89 ff e8 7a 73 f9 fb bf e0 01 00 00 49 03 3f be 02 00 00 00 e8 18 05 9e 05 48 8b 44 24 10 4c 8d 60 50 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00 74 08 4c 89 e7 e8 49 73 f9 fb 41 bf e8 00 00 00 4d
RSP: 0018:ffffc90003d6fb60 EFLAGS: 00010206
RAX: 000000000000000a RBX: ffff8881699b3000 RCX: 0000000000000046
RDX: 0000000000000006 RSI: ffffffff8e414976 RDI: ffffffff8c6da780
RBP: ffffc90003d6fd08 R08: ffffffff907a477f R09: 1ffffffff20f48ef
R10: dffffc0000000000 R11: fffffbfff20f48f0 R12: 0000000000000050
R13: 1ffff920007adf74 R14: dffffc0000000000 R15: ffff888169a02080
FS:  00007fa1afb46c80(0000) GS:ffff88818d6ce000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000055556cac6a68 CR3: 00000001bee1a000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[a.hindborg@kernel.org axboe@kernel.dk bvanassche@acm.org gary@garyguo.net hch@lst.de linux-block@vger.kernel.org nilay@linux.ibm.com ojeda@kernel.org penguin-kernel@i-love.sakura.ne.jp royenheart@gmail.com sunke@kylinos.cn]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

