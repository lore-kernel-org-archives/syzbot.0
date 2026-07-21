Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B8095446059
	for <syzbot@lists.linux.dev>; Tue, 21 Jul 2026 09:32:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784626362; cv=none; b=s4ve0S88rVWBNofCvm9FjCOCQyt6zryAVmmlXuq+PH1/1Py2mZj/S9ssS/oBemPi4Xj+kXRVXD8BRAtQ2e1VcyYjLa/h4PYUpx20Rwzgeec5+Cg6VR/fRrzmSSmt5pTwfGDP9LGpR3NHRk1BKoFfj65fcEVuEdqsMOeCmtLrdfU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784626362; c=relaxed/simple;
	bh=vQyTOA475MRFEX6zSX42ioDtGHorSgq865HipdB8+Mc=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=UrNJoMOFaRaF0l4Tt2FTGKLxyurgB7dSKF1lcunWNOWpmmyQ78ePnF7FLuIPhFXStSyvgvPuh4acFF3zen6uUXRyGH69+iZZkh4CUc5FUjcGrMDZPTXEN4x42XpyTSyOAyfr4K/n28eENnpxFG8HN6EpNTU5W4rP+t6l/cfz37w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6a344ad4390so7554886eaf.2
        for <syzbot@lists.linux.dev>; Tue, 21 Jul 2026 02:32:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784626358; x=1785231158;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6Rt/j2m5iB4iOAbkeEaHosgKr0ByKeDsLnufZ+JGsXc=;
        b=DLKklVyhnoam2rLVHn4l9SqKeSLT+AmXKRDmFSv2uN3ytQBYFM5iiSA8ZrRSpbcFOk
         FU7muHXyypjfF09/+zj2NoojeW+QfDIkUgRGXfolfMbdUewGUrN1ud0pmqfKz63taKp9
         W4MbuaP3Z9Gcmrd4O7iAPTHEabIQblAaVC8sstkBD9QupxumKw7suY7FzCt5/epfj2Pv
         LyzJUTzUIt/YpACJBz0GixRCCW8acHCI93+lLndCkVqP72kNHZ4Uoty/oKqFA8KbWTna
         IZKfAhD5RjIIJc5jWf/BX5RrI7QZTKts3bUWGapvOXjV2ui0ghMCpvhW5awfoH/mgqmD
         pODQ==
X-Gm-Message-State: AOJu0YxZl6c5PUVFLFjsC4LXUwe6H6SIsdGWz8a20Y4jbLxy4KdfhWVB
	VoTDNZkOfVr11hFK6szgwZBJFEfZMu7JQlWFfLST2SzAXsfOjYnOFlb/GtPqwjxmqPOUBHgP9Rl
	qb3nnAhIrAXWCpS2RGU8OxOmlwLolVRb/3jFAicwYYBO181JTy2FYdKyMAF8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:c8a:b0:6a3:d77e:725a with SMTP id
 006d021491bc7-6a5366d871dmr9219261eaf.20.1784626358567; Tue, 21 Jul 2026
 02:32:38 -0700 (PDT)
Date: Tue, 21 Jul 2026 02:32:38 -0700
In-Reply-To: <40d9021a-6a93-43a1-97b0-6ec2f9cbabc6@mail.kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5f3cb6.83245ca4.2d5e11.0000.GAE@google.com>
Subject: [syzbot ci] Re: fuse: abort connection on /dev/fuse flush to prevent deadlock
From: syzbot ci <syzbot+ci8d3b6fecae06295c@syzkaller.appspotmail.com>
To: kusaram@devineni.in, syzbot@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] fuse: abort connection on /dev/fuse flush to prevent deadlock
https://lore.kernel.org/all/40d9021a-6a93-43a1-97b0-6ec2f9cbabc6@mail.kernel.org
* [PATCH RFC v3] fuse: abort connection on /dev/fuse flush to prevent deadlock

and found the following issue:
general protection fault in fasync_remove_entry

Full report is available here:
https://ci.syzbot.org/series/a9dcb2cb-0ef5-4576-84ff-c40a48e2a25a

***

general protection fault in fasync_remove_entry

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      8cdeaa50eae8dad34885515f62559ee83e7e8dda
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/be2f3b2c-a8ca-4791-b9dd-8f1f9d24d9e9/config
syz repro: https://ci.syzbot.org/findings/0c2890de-1b7a-4718-a188-a597ff4d74a7/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000026: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000130-0x0000000000000137]
CPU: 0 UID: 0 PID: 5854 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:fasync_remove_entry+0x3e/0x1c0 fs/fcntl.c:1008
Code: 49 bd 00 00 00 00 00 fc ff df e8 fd 44 7a ff 48 89 df e8 05 2e 85 09 48 c7 c7 80 65 cd 8e e8 f9 2d 85 09 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 a3 cf e7 ff 4d 8b 3e 4d 85 ff 74
RSP: 0018:ffffc900035efd38 EFLAGS: 00010202
RAX: 0000000000000026 RBX: ffff888174b8cc00 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc900035efcc0
RBP: dffffc0000000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520006bdf98 R12: ffff88810270ab80
R13: dffffc0000000000 R14: 0000000000000131 R15: ffffffff8c29b708
FS:  0000555569119500(0000) GS:ffff88818d959000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000080 CR3: 0000000102f90000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __fput+0x88d/0xa50 fs/file_table.c:509
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:70 [inline]
 exit_to_user_mode_loop+0x1fa/0x730 kernel/entry/common.c:101
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc7bcb9de99
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe628b3f98 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007ffe628b4080 RCX: 00007fc7bcb9de99
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 000000000001302f R08: 0000000000000001 R09: 0000000000000000
R10: 0000001b32a20000 R11: 0000000000000246 R12: 00007ffe628b40c0
R13: 00007fc7bce25fac R14: 000000000001306b R15: 00007fc7bce25fa0
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:fasync_remove_entry+0x3e/0x1c0 fs/fcntl.c:1008
Code: 49 bd 00 00 00 00 00 fc ff df e8 fd 44 7a ff 48 89 df e8 05 2e 85 09 48 c7 c7 80 65 cd 8e e8 f9 2d 85 09 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 f7 e8 a3 cf e7 ff 4d 8b 3e 4d 85 ff 74
RSP: 0018:ffffc900035efd38 EFLAGS: 00010202
RAX: 0000000000000026 RBX: ffff888174b8cc00 RCX: 0000000000000001
RDX: 0000000000000001 RSI: 0000000000000004 RDI: ffffc900035efcc0
RBP: dffffc0000000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff520006bdf98 R12: ffff88810270ab80
R13: dffffc0000000000 R14: 0000000000000131 R15: ffffffff8c29b708
FS:  0000555569119500(0000) GS:ffff88818d959000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000080 CR3: 0000000102f90000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	49 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%r13
   7:	fc ff df
   a:	e8 fd 44 7a ff       	call   0xff7a450c
   f:	48 89 df             	mov    %rbx,%rdi
  12:	e8 05 2e 85 09       	call   0x9852e1c
  17:	48 c7 c7 80 65 cd 8e 	mov    $0xffffffff8ecd6580,%rdi
  1e:	e8 f9 2d 85 09       	call   0x9852e1c
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	4c 89 f7             	mov    %r14,%rdi
  34:	e8 a3 cf e7 ff       	call   0xffe7cfdc
  39:	4d 8b 3e             	mov    (%r14),%r15
  3c:	4d 85 ff             	test   %r15,%r15
  3f:	74                   	.byte 0x74


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
