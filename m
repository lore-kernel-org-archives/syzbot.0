Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C832264B6
	for <syzbot@lists.linux.dev>; Sat, 16 Aug 2025 07:28:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755329290; cv=none; b=KBAMqE9cy5UlXt4dC+YFGkgyaNGbgOPHx2QAmWb9ANtQ+wapbpqfPgOHDpxx4nTxeV9FYLa/XSeReZqX7Gv9T5gtuvcrbp9iRk3ShbJw4s2xoISBPEUNKAyQfMZmRr0fXSBxDej9prynAdyeCfVNYgsz6VYhdqtu6H2zwZ7OfN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755329290; c=relaxed/simple;
	bh=rN2Uln8kNvXlA0hmFagZ+EAtKzdX+lX56hHZmQLSNvc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=T3K7h4lly49+4UhI2cgWgIISpchdx7IJ4OnETb/QX3lOWRa8OkPY1YybFRj7VwHWarqlS4twh6lyMONhhWqvvRxytyT8sGHz0Pl2lSKrGcc4BRGduOjoGuZVW9EIBxFpGtaB6P/IJL5xP7oAxfjJyKhiFs09iKZmuvvrQoZt5mM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yzoDw3ND; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yzoDw3ND"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-b47174c3817so1949767a12.2
        for <syzbot@lists.linux.dev>; Sat, 16 Aug 2025 00:28:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755329288; x=1755934088; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=LWdi5oYLEGiohe6APfj7NlwYaSq7imtzVkj8N0dKbJQ=;
        b=yzoDw3NDrGlXCVR1U8HVum5n553Wy/lxsBV8eNbpdOVMWpjfylK+c9mgXFsXTMntlQ
         xGeM0cr9tLI3Njd0J2dfS1A7zIKgKfb0v6n5GIp929P/khyEMSfXUHq7Xk0demIjr5QT
         nsxf+ZbZp3taDtj1tVRgN+iDIF5kMeBfMh7Y4OchFPQe+4yYnDBf6W71vP/CHTrjsZTD
         YQDcSHUNtmLzCYngqbLavNP+B8asBfwBDf2eLfQU2rtDQyjpFH2E4fjPkf4cjJ5xQ9aK
         mYSc/ZPMntlujDuhcM2jp4YvGKOhJNf6L9Eje8QqAwTdXK+TCMM7DW82Yxn+m+A8TJzB
         2EXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755329288; x=1755934088;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=LWdi5oYLEGiohe6APfj7NlwYaSq7imtzVkj8N0dKbJQ=;
        b=lxDHwM2Uf3R0vy70xzCTk1tz5Pz3U1wgu2f7CANovQSOlag+h2df/jTYi/5XOBdisN
         CzHWEW1XCQfVuSBnrSG6DQZfq1EujKMP7Z/32jne2ThtcgAom1+doRR4LQJcZO9PmRv2
         /xDBX/WI73/5kkY4YNsKP4RKWuy43oNQL0OBUK4jh+j1uY+z39gWcCImDX83N9SUozg/
         xLY3/xS0qSfoTlBo0nHpfE7yFueYMidac/zq0Y6I4IBCuIDwTGt8/tytyv6KnEsFykZT
         Cz+dq4LPk5QheHBx5cXIJ7xJQYe4OiyNiiqthuclHf7dyIQr8lb26RfGJlygweTkGCMg
         64+Q==
X-Forwarded-Encrypted: i=1; AJvYcCVdLABudo0kEuZ/32ypmVfZ5DGRJnXPqn+akwBTnpsA/J8WtjFzs+sYJXW676cglv9FDWlQdMs=@lists.linux.dev
X-Gm-Message-State: AOJu0Yywri/PvBwq5hwstBbimnNeDED1w8/For8rzERrxVcM50veCoi3
	DxyB1vPtelDIOqIn95kpOjzgOkefyabE4J1gyGwKoPn4YeK/hj7fS+/C+WoVljHqa932t9/Dn6Y
	TRquhhFIRAXGb2BpniTWP6JgU6xeXrd2oImSdISpL
X-Gm-Gg: ASbGncstxd+GEEU6R7yJuOQVbyybAWRnTHcLUuHL1CZvXSCgBDTM82Gud/u31j9WHLj
	F3p/PwANtp4WYDU5yoUvxQ5mjRJiTIifIEE9KNRYMpKYbTRSKSGFY/QiVeTO9JgNeRj/logD6Ha
	0WVFvpxtc+oUrs9CIWxzt4j58ekmBf+bOajaOYx2ElZPHuFk715ziN+4l4WfDWIlyBpigyOS8EL
	oMFNAtQNZpIxfNOwWiaFVZIVJ1UHp72zmTecHmBJqoMJ9xbd7geiqRlQrmGMVRXnkbJ
X-Google-Smtp-Source: AGHT+IG0SybAdymbU9z9lQwxie9ji8trsdaCmGqyYW0edxzuO6NHQl36QOUOOAq6XGikr8ZKenaDyPvt3yzVOVkvCio=
X-Received: by 2002:a17:903:37c3:b0:240:58a7:8938 with SMTP id
 d9443c01a7336-2446d6d6fbamr73674445ad.7.1755329287456; Sat, 16 Aug 2025
 00:28:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <689fad34.050a0220.e29e5.0027.GAE@google.com>
In-Reply-To: <689fad34.050a0220.e29e5.0027.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 16 Aug 2025 09:27:55 +0200
X-Gm-Features: Ac12FXy7f0YnRCy7SEync96HwbqYFk3xAjuVE18Ha8WCcKVO8f4l978OQY8_B4s
Message-ID: <CANp29Y51chJ-yNRdcBnxh74XKQz4H5NZ-07zmT+kq=Yz1YJxPg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: io_uring: add request poisoning
To: syzbot ci <syzbot+cib9fb5660ad53498e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Aug 15, 2025 at 11:57=E2=80=AFPM syzbot ci
<syzbot+cib9fb5660ad53498e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] io_uring: add request poisoning
> https://lore.kernel.org/all/b98edbb8ec4495b053dfb11cb3588f17f5253b6e.1755=
182071.git.asml.silence@gmail.com
> * [PATCH 1/1] io_uring: add request poisoning
>
> and found the following issue:
> general protection fault in __io_queue_proc
>
> Full report is available here:
> https://ci.syzbot.org/series/f67750f7-0bd0-41d6-a3eb-d1b77b2c9728
>
> ***
>
> general protection fault in __io_queue_proc
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/e0a322a6-324d-4dcd-a2dc-b6ec3bfb0=
f54/config
> C repro:   https://ci.syzbot.org/findings/c93b97f2-efb3-45d6-a6ca-0afeb73=
11b74/c_repro
> syz repro: https://ci.syzbot.org/findings/c93b97f2-efb3-45d6-a6ca-0afeb73=
11b74/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xfbd5=
9c0000000213: 0000 [#1] SMP KASAN PTI
> KASAN: maybe wild-memory-access in range [0xdead000000001098-0xdead000000=
00109f]
> CPU: 0 UID: 0 PID: 5985 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-0=
0036-gdfc0f6373094-dirty #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__io_queue_proc+0x1b8/0x4d0 io_uring/poll.c:475
> Code: c1 e8 03 48 89 44 24 20 80 3c 18 00 74 08 4c 89 ef e8 8c 27 63 fd 4=
d 8b 6d 00 4d 85 ed 74 5a 49 83 c5 08 4c 89 e8 48 c1 e8 03 <80> 3c 18 00 74=
 08 4c 89 ef e8 6a 27 63 fd 48 8b 44 24 18 49 39 45
> RSP: 0018:ffffc9000295f760 EFLAGS: 00010a02
> RAX: 1bd5a00000000213 RBX: dffffc0000000000 RCX: 0000000000000000
> RDX: ffff888020cd9cc0 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffffc9000295f900 R08: ffffffff8fa37e37 R09: 1ffffffff1f46fc6
> R10: dffffc0000000000 R11: ffffffff84bfdf40 R12: ffff888028da6000
> R13: dead000000001099 R14: ffffc9000295f918 R15: 1ffff9200052bf23
> FS:  000055558fd42500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30d63fff CR3: 000000010e6dc000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  poll_wait include/linux/poll.h:45 [inline]
>  n_tty_poll+0x9d/0x740 drivers/tty/n_tty.c:2451
>  tty_poll+0xbe/0x160 drivers/tty/tty_io.c:2199
>  vfs_poll include/linux/poll.h:82 [inline]
>  __io_arm_poll_handler+0x372/0xbb0 io_uring/poll.c:581
>  io_poll_add+0xcd/0x1f0 io_uring/poll.c:901
>  __io_issue_sqe+0x181/0x4b0 io_uring/io_uring.c:1795
>  io_issue_sqe+0x165/0xfd0 io_uring/io_uring.c:1818
>  io_queue_sqe io_uring/io_uring.c:2047 [inline]
>  io_submit_sqe io_uring/io_uring.c:2306 [inline]
>  io_submit_sqes+0xa32/0x1e60 io_uring/io_uring.c:2419
>  __do_sys_io_uring_enter io_uring/io_uring.c:3487 [inline]
>  __se_sys_io_uring_enter+0x2df/0x2b20 io_uring/io_uring.c:3421
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f750a18ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc8b53b938 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 00007f750a3b5fa0 RCX: 00007f750a18ebe9
> RDX: 0000000000000000 RSI: 0000000000000a3d RDI: 0000000000000004
> RBP: 00007f750a211e19 R08: 0000000000000000 R09: 000000000000ff39
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f750a3b5fa0 R14: 00007f750a3b5fa0 R15: 0000000000000006
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__io_queue_proc+0x1b8/0x4d0 io_uring/poll.c:475
> Code: c1 e8 03 48 89 44 24 20 80 3c 18 00 74 08 4c 89 ef e8 8c 27 63 fd 4=
d 8b 6d 00 4d 85 ed 74 5a 49 83 c5 08 4c 89 e8 48 c1 e8 03 <80> 3c 18 00 74=
 08 4c 89 ef e8 6a 27 63 fd 48 8b 44 24 18 49 39 45
> RSP: 0018:ffffc9000295f760 EFLAGS: 00010a02
> RAX: 1bd5a00000000213 RBX: dffffc0000000000 RCX: 0000000000000000
> RDX: ffff888020cd9cc0 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffffc9000295f900 R08: ffffffff8fa37e37 R09: 1ffffffff1f46fc6
> R10: dffffc0000000000 R11: ffffffff84bfdf40 R12: ffff888028da6000
> R13: dead000000001099 R14: ffffc9000295f918 R15: 1ffff9200052bf23
> FS:  000055558fd42500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30d63fff CR3: 000000010e6dc000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   c1 e8 03                shr    $0x3,%eax
>    3:   48 89 44 24 20          mov    %rax,0x20(%rsp)
>    8:   80 3c 18 00             cmpb   $0x0,(%rax,%rbx,1)
>    c:   74 08                   je     0x16
>    e:   4c 89 ef                mov    %r13,%rdi
>   11:   e8 8c 27 63 fd          call   0xfd6327a2
>   16:   4d 8b 6d 00             mov    0x0(%r13),%r13
>   1a:   4d 85 ed                test   %r13,%r13
>   1d:   74 5a                   je     0x79
>   1f:   49 83 c5 08             add    $0x8,%r13
>   23:   4c 89 e8                mov    %r13,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   80 3c 18 00             cmpb   $0x0,(%rax,%rbx,1) <-- trapping in=
struction
>   2e:   74 08                   je     0x38
>   30:   4c 89 ef                mov    %r13,%rdi
>   33:   e8 6a 27 63 fd          call   0xfd6327a2
>   38:   48 8b 44 24 18          mov    0x18(%rsp),%rax
>   3d:   49                      rex.WB
>   3e:   39                      .byte 0x39
>   3f:   45                      rex.RB
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
> Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [asml.silence@gmail.com io-uring@vger.kernel.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/689fad34.050a0220.e29e5.0027.GAE%40google.com.
