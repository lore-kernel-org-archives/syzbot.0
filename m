Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E555317173
	for <syzbot@lists.linux.dev>; Wed,  9 Sep 2026 03:10:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788923413; cv=none; b=hxp+5r2I9vFsyVw+WaUxIm4XHW9Zc5J1zgEXFFcdq6B1Z4SO2ZzNt+iCPhFo+KjnvwyDFbajku2X8nVq5RPLtO+GvD3JobNpwePrm9bwVbKj0oeOD5HhAaQBVna0B0sgz2u5ZsLCGryVac4qFZW2ieXhRaP5MCGyyxGEw/NQeQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788923413; c=relaxed/simple;
	bh=UmMa8xqvpeNo3PJFewMB8VkZiyTKg2Nx1Eo6rDQAjuU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=VPxZwPj/C8tskEixzqkajMVBj409vk2FTl0zo8rsfXC+jxA6TKxZZ2QBNjBEozDY/RfbQ46PMUizbfQqRuX51WFwoUGbwPqNyQhIH9yAMQjAbiiDeEYS3kWgdobj8OXn/6SqJ4Qxx6yUUNrJJ8uAQH7ebv7byMkGxuN7b2JOA/A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7e9dc0f5900so8369237a34.0
        for <syzbot@lists.linux.dev>; Tue, 08 Sep 2026 20:10:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788923408; x=1789528208;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AoPGqeI2bHO9q7+2ErdnI4dvaIkPsO8SDC7h/Q/Bg7g=;
        b=Cl2fchrHyRUeLI4GRJ3TKj0jgFrz+8KEZR5AjRRXz/O6dvVbhD+ytdrbsNKbKkNK9F
         8oew/Ggf/OSfuupOq5Jr+2QBkZ6uChGD1RKS8GXvR8W2fH37WldivrgsmI7rl5Vqqmk/
         T4B1bJ+b99n1PU/DG7k+7uHT8zxsAxmxDH7/VhVlitoy/yqb/Sm5qvKzwPXojai1AFKp
         MMMnmzx6Zxr2T2MEFCsZMsaZotNNM5CWkcP4JoyEdAw1B++RUsZHoGg3+z+n4PJrat9C
         6JLyVospA7oW6siiAOO50Vif3UxN3YQMkUM5v/fUP4kBb21ww8V6H5I5zChrZVLn6eT0
         eVOg==
X-Gm-Message-State: AFuF++lB2SISTNAgEtIdt1vRsn9lG+u2K0diMkKCmK2je6wh0upxt03O
	5K80ZBVYekkY4wnKHCXeCUFWFJ2AaHkX8XNMEh8f6yur7W8N+igyV22tAhOisCchyxuF2rIhOw9
	4nzz2DjLSj1b2xgXVGYnPVRKWZENDO6FlMjYLp5tVaA+lkEr5iiGvKeYNtmA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:e914:0:b0:6b5:ec2f:3565 with SMTP id
 006d021491bc7-6b5ec2f36bfmr14749281eaf.22.1788923407951; Tue, 08 Sep 2026
 20:10:07 -0700 (PDT)
Date: Tue, 08 Sep 2026 20:10:07 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa0ce0f.f81106d8.285f0a.0008.GAE@google.com>
Subject: [moderation/CI] Re: hfsplus: convert regular file I/O to iomap-based operations
From: syzbot ci <syzbot+ci823a0e2cb68b1a0a@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] hfsplus: convert regular file I/O to iomap-based operations
https://lore.kernel.org/all/20260908210448.296772-1-slava@dubeyko.com
* [PATCH v3 1/7] hfs/hfsplus: exchange hardcoded number of extents on named constants
* [PATCH v3 2/7] hfsplus: rework hfsplus_get_block() logic
* [PATCH v3 3/7] hfsplus: take the bitmap page lock for allocate/free
* [PATCH v3 4/7] hfsplus: add iomap operations for regular file data
* [PATCH v3 5/7] hfsplus: move file related operations to file.c
* [PATCH v3 6/7] hfsplus: introduce iomap-based file_operations
* [PATCH v3 7/7] hfsplus: switch address_space_operations on iomap-based support

and found the following issue:
general protection fault in __bh_submit

Full report is available here:
https://ci.syzbot.org/series/38a0586d-f4cb-4955-aebf-8908d87645ed

***

general protection fault in __bh_submit

tree:      vfs
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
base:      21860bb220225edeb87e9c831e6bf25c620e2126
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/fca9c940-9a44-4e03-8515-7d438025f0e2/config
syz repro: https://ci.syzbot.org/findings/e6b3388b-2033-41f8-b2d7-55ceca2562f6/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 1 UID: 0 PID: 5002 Comm: jbd2/sda1-8 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:const_folio_flags include/linux/page-flags.h:345 [inline]
RIP: 0010:folio_test_dropbehind include/linux/page-flags.h:601 [inline]
RIP: 0010:__bh_submit+0x22d/0x8d0 fs/buffer.c:1108
Code: c1 e8 03 48 89 44 24 18 42 80 3c 20 00 74 08 48 89 df e8 86 e1 d7 ff 48 89 5c 24 28 48 8b 1b 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 64 e1 d7 ff 4d 8b 3f 4c 89 fe 48
RSP: 0018:ffffc9000fe07868 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff84b8b669
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff888169ab56a0
RBP: 0000000000009801 R08: ffff888169ab56ff R09: 1ffff1102d356adf
R10: dffffc0000000000 R11: ffffed102d356ae0 R12: dffffc0000000000
R13: ffff888169ab5680 R14: ffff88811d795700 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff8882a8cd5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fb21ba27dac CR3: 000000000eb48000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 jbd2_journal_commit_transaction+0x22a9/0x5cd0 fs/jbd2/commit.c:751
 kjournald2+0x3bc/0x750 fs/jbd2/journal.c:200
 kthread+0x38b/0x480 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:const_folio_flags include/linux/page-flags.h:345 [inline]
RIP: 0010:folio_test_dropbehind include/linux/page-flags.h:601 [inline]
RIP: 0010:__bh_submit+0x22d/0x8d0 fs/buffer.c:1108
Code: c1 e8 03 48 89 44 24 18 42 80 3c 20 00 74 08 48 89 df e8 86 e1 d7 ff 48 89 5c 24 28 48 8b 1b 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00 74 08 4c 89 ff e8 64 e1 d7 ff 4d 8b 3f 4c 89 fe 48
RSP: 0018:ffffc9000fe07868 EFLAGS: 00010202
RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffffffff84b8b669
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffff888169ab56a0
RBP: 0000000000009801 R08: ffff888169ab56ff R09: 1ffff1102d356adf
R10: dffffc0000000000 R11: ffffed102d356ae0 R12: dffffc0000000000
R13: ffff888169ab5680 R14: ffff88811d795700 R15: 0000000000000008
FS:  0000000000000000(0000) GS:ffff8882a8cd5000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000035dc4b324000 CR3: 00000001bb4be000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	c1 e8 03             	shr    $0x3,%eax
   3:	48 89 44 24 18       	mov    %rax,0x18(%rsp)
   8:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1)
   d:	74 08                	je     0x17
   f:	48 89 df             	mov    %rbx,%rdi
  12:	e8 86 e1 d7 ff       	call   0xffd7e19d
  17:	48 89 5c 24 28       	mov    %rbx,0x28(%rsp)
  1c:	48 8b 1b             	mov    (%rbx),%rbx
  1f:	4c 8d 7b 08          	lea    0x8(%rbx),%r15
  23:	4c 89 f8             	mov    %r15,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 20 00       	cmpb   $0x0,(%rax,%r12,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 ff             	mov    %r15,%rdi
  34:	e8 64 e1 d7 ff       	call   0xffd7e19d
  39:	4d 8b 3f             	mov    (%r15),%r15
  3c:	4c 89 fe             	mov    %r15,%rsi
  3f:	48                   	rex.W


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
[brauner@kernel.org djwong@kernel.org frank.li@vivo.com glaubitz@physik.fu-berlin.de hch@lst.de linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org slava@dubeyko.com vdubeyko@coreweave.com willy@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

