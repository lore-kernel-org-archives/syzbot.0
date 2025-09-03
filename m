Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A78D02DAFDD
	for <syzbot@lists.linux.dev>; Wed,  3 Sep 2025 20:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756930271; cv=none; b=GkfEVKK7V6ZjPSRNFbTHwzklq0xUaEJQbi3EuMzbbSybrSTU0AR369mdBSlWQiOBijhxfA1VQibH1+EfuUb2FxkSWNYEnHBig9lzgbeqLvfehApLtkMrTQX/cA2BNYvpM3DcmMWiDYO/nVJA6UEynob9PtlGhrruFyqIL+2DQzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756930271; c=relaxed/simple;
	bh=FyiYLxw8EISIWQjSkTUi7BKwx+dZfFj0aWYccPeSHqE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=VZXmN7VwAO96kxX1N7HhOI/IcFet5LMnQT7zXbXC2GsBRa7S42jWCyH1GEp7D9vYrAUVz4xsrLf/e/jEMfhaqNEzQYZAeAc4WB3koLP6EKF2JKf661va4JyeVv367Rc3iyxbuXal0wg0eaLnAKQnmgIsbY1vBnzI81E37nydyaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3efa61f3ab5so4604925ab.3
        for <syzbot@lists.linux.dev>; Wed, 03 Sep 2025 13:11:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756930268; x=1757535068;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=t6ZEPsBtvG5VRuSFaVP407N7F8hekjlaOhHpTG/fLIM=;
        b=Vce12qlYVv7NHYD6oz557FGZn3of6hYcIi/gaSw1s0OLGMaTO0KMjtYhmoxypaA7+i
         Kt/p8tJaV48vNOkDje2Yg5evU6/64Z80RbrA97OrrDisp+LhgkaL1I6nWLVF9CLLyPWJ
         2wyreZZk2RwMC2EcCGrGMvpmxM93lCIXVw6WZf6cHmRUyA926qvhU1lPiBTEL1nhSGds
         IkHRDut8eDVSFBsYZn/8kHoU+FzviYE8yVdl8vBbV5UQLAulb6oRD/JhUJCGRecDqFbv
         TXFPneNFA8XpFDUjLluRrpMNpBwGaaxS04RqyPFDLrmLMxvnb+tS3t5vhv0cOGrGG8cQ
         6SxA==
X-Gm-Message-State: AOJu0Yyh61Tok3c3sZyH+TLStFexbevHeRywpLjZefxzGIshjfukOvfO
	w6wN+QKzJbHNQoVLprdv0f2FyJcqNqIBLLAnparxx2D30TJJmTGvE2+Tn8ntDAmq6RnliVQzSjJ
	ukMgy47kk+IJTk3bYQCG3Jrqi2CMfgzHumQ1w/oXob4VBBrUsKcLoZaXb8zk=
X-Google-Smtp-Source: AGHT+IFATA2RfB9uZIsWrgwBUHSkZzBg/NLURLkUUUCOW3IlhG/Xe317su/zGwGfK16iLa85V35WkgKNIjRF44zcC1VkJHxVIIOH
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a6a:b0:3f2:1ba1:1caf with SMTP id
 e9e14a558f8ab-3f4006758e8mr290216815ab.14.1756930268633; Wed, 03 Sep 2025
 13:11:08 -0700 (PDT)
Date: Wed, 03 Sep 2025 13:11:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b8a0dc.050a0220.3db4df.01ff.GAE@google.com>
Subject: [moderation/CI] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
From: syzbot ci <syzbot+ci46ad6c40cc3229d9@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
https://lore.kernel.org/all/20250903032656.2012337-1-csander@purestorage.com
* [PATCH 1/4] io_uring: don't include filetable.h in io_uring.h
* [PATCH 2/4] io_uring/rsrc: respect submitter_task in io_register_clone_buffers()
* [PATCH 3/4] io_uring: factor out uring_lock helpers
* [PATCH 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER

and found the following issue:
WARNING in io_handle_tw_list

Full report is available here:
https://ci.syzbot.org/series/54ae0eae-5e47-4cfe-9ae7-9eaaf959b5ae

***

WARNING in io_handle_tw_list

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      5d50cf9f7cf20a17ac469c20a2e07c29c1f6aab7
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/1de646dd-4ee2-418d-9c62-617d88ed4fd2/config
syz repro: https://ci.syzbot.org/findings/e229a878-375f-4286-89fe-b6724c23addd/syz_repro

------------[ cut here ]------------
WARNING: io_uring/io_uring.h:127 at io_ring_ctx_lock io_uring/io_uring.h:127 [inline], CPU#1: iou-sqp-6294/6297
WARNING: io_uring/io_uring.h:127 at io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155, CPU#1: iou-sqp-6294/6297
Modules linked in:
CPU: 1 UID: 0 PID: 6297 Comm: iou-sqp-6294 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:127 [inline]
RIP: 0010:io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155
Code: 00 00 48 c7 c7 e0 90 02 8c be 8e 04 00 00 31 d2 e8 01 e5 d2 fc 2e 2e 2e 31 c0 45 31 e4 4d 85 ff 75 89 eb 7c e8 ad fb 00 fd 90 <0f> 0b 90 e9 cf fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 22 ff
RSP: 0018:ffffc900032cf938 EFLAGS: 00010293
RAX: ffffffff84bfcba3 RBX: dffffc0000000000 RCX: ffff888107f61cc0
RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
RBP: ffff8881119a8008 R08: ffff888110bb69c7 R09: 1ffff11022176d38
R10: dffffc0000000000 R11: ffffed1022176d39 R12: ffff8881119a8000
R13: ffff888108441e90 R14: ffff888107f61cc0 R15: 0000000000000000
FS:  00007f81f25716c0(0000) GS:ffff8881a39f5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b31b63fff CR3: 000000010f24c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 tctx_task_work_run+0x99/0x370 io_uring/io_uring.c:1223
 io_sq_tw io_uring/sqpoll.c:244 [inline]
 io_sq_thread+0xed1/0x1e50 io_uring/sqpoll.c:327
 ret_from_fork+0x47f/0x820 arch/x86/kernel/process.c:148
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[axboe@kernel.dk csander@purestorage.com io-uring@vger.kernel.org linux-kernel@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

