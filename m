Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2268D28C84D
	for <syzbot@lists.linux.dev>; Thu,  1 Jan 2026 09:47:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767260840; cv=none; b=cW2cxVztQcKV5Lqt8iEn8ZNRtjxZdwAec4frqDFJ7v2F5nU5hoeoJJw2j0spLZH0mVLU26t155LkSjF+6RIdE/1xCwsq35Ur7J5n5vFU8bzhW63B1ZHwH2VzgCxqr9WpWkQxHgUbMUrQUY7RIIorQzI44uYutk+hK4++0yS75dU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767260840; c=relaxed/simple;
	bh=5OvyIsRW3Ulmc+6vCD1oRjKvrxh+0+meFQjoHPyGchg=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=UrskcqpBeucB6z+CXQ5VwWHuIn8SrkYvA8tAw35obhqgHEM3EOMnz46pTrWXkbT+DMTkRl1yyqKTt/F8+fx3hazYIwuhFs+RWY8g8Th7lvCvu795uhwZ8XsQS0ohv0Ry26iTuMz0LCpGc8yO8lcDnsKJDEYYHBJuiwxLn5xW680=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7cad1393ec8so26161726a34.0
        for <syzbot@lists.linux.dev>; Thu, 01 Jan 2026 01:47:17 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767260836; x=1767865636;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UFeSGReuuC99NPOsoEX2+QXztArIvR8/yIB7wkkMASw=;
        b=Bms28oKf9rEjKI5HrPuqZxlIYduq6eplKhPeq6VIweBFqGHA3knByxwJFZTVH8uWmJ
         UOWFsFBFw9BrznCgy0d9fY0oCHnvSkxfHLCHp+1X4dsAH9FYMnR9sW9akz2Mw6rpe6MT
         qyg7BLg4/d+i+6V6j1HKv9Z3xlhHcA/+F1hOWnDnvXFIz2ggwjAXXzzJlrRgu76KDbSC
         gHfR2BXmAAGmuv5B49qH65QU4w/S19HQSTuItRdj9qwOtxB/banuV6SwdVuobzRSF5zR
         qU1BhQ8RgogroQ5KpymQTSY6PhgWmcDMI/wK7XJ/iQk1AJA3J5T0AEpF2r/AIhRnj80h
         S6HQ==
X-Gm-Message-State: AOJu0YyKwOsYgMwNexg6LKxKHPvKjg3irb3eBbaOdedTcyKcV2m0v/5x
	LVS/yIpHYqA42MmtraKeJmCfmVFDpjFwW0y2myV6DD1j2rPqG/f0qD6QT5AahHRni9LqoWfDsr+
	vJM7TeJy1pIY9YRAr4wMF5BuxDtfoxkipnVoeZl+ptIEKIyzgJY2VevAbCso=
X-Google-Smtp-Source: AGHT+IFefQWbkn3qb+2cAat4fpKXXQ3nGdww6ZW82q0l/Pt47CizRfPSvRgAv25U8wBb7F8XyQbfOrDe8MuHp1/iXNG6/Rcjf+Mu
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1ca7:b0:65d:a5a:848c with SMTP id
 006d021491bc7-65d0eadd986mr18447073eaf.59.1767260836748; Thu, 01 Jan 2026
 01:47:16 -0800 (PST)
Date: Thu, 01 Jan 2026 01:47:16 -0800
In-Reply-To: <4cffd2b8-e7c9-48df-9207-0df6e3d5c6ce@kernel.dk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <695642a4.050a0220.a1b6.0338.GAE@google.com>
Subject: [syzbot ci] Re: io_uring/tctx: add separate lock for list of tctx's
 in ctx
From: syzbot ci <syzbot+cice7613aaad21f97d@syzkaller.appspotmail.com>
To: axboe@kernel.dk, io-uring@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] io_uring/tctx: add separate lock for list of tctx's in ctx
https://lore.kernel.org/all/4cffd2b8-e7c9-48df-9207-0df6e3d5c6ce@kernel.dk
* [PATCH] io_uring/tctx: add separate lock for list of tctx's in ctx

and found the following issue:
WARNING in __io_async_cancel

Full report is available here:
https://ci.syzbot.org/series/98951813-facd-4de5-8d20-609c804dc446

***

WARNING in __io_async_cancel

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~exp1~20251202083504.46), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/9e0d952e-d592-4cca-9208-4b87430b4e6f/config
C repro:   https://ci.syzbot.org/findings/103d3164-79b9-4a03-bdf3-9bb057961994/c_repro
syz repro: https://ci.syzbot.org/findings/103d3164-79b9-4a03-bdf3-9bb057961994/syz_repro

------------[ cut here ]------------
do not call blocking ops when !TASK_RUNNING; state=1 set at [<ffffffff819c3a04>] prepare_to_wait+0x174/0x210 kernel/sched/wait.c:256
WARNING: kernel/sched/core.c:8754 at __might_sleep+0x92/0xf0 kernel/sched/core.c:8750, CPU#1: syz.0.17/5989
Modules linked in:
CPU: 1 UID: 0 PID: 5989 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__might_sleep+0xac/0xf0 kernel/sched/core.c:8750
Code: 00 00 48 89 3c 24 41 89 f5 4c 8d 35 6e 25 32 0e 43 80 3c 3c 00 74 08 48 89 df e8 0f 31 96 00 48 8b 0b 4c 89 f7 89 ee 48 89 ca <67> 48 0f b9 3a 44 89 ee 48 8b 3c 24 eb b5 44 89 f1 80 e1 07 80 c1
RSP: 0018:ffffc90003c57960 EFLAGS: 00010246
RAX: 0000000000000000 RBX: ffff888112e4ef78 RCX: ffffffff819c3a04
RDX: ffffffff819c3a04 RSI: 0000000000000001 RDI: ffffffff8fc561c0
RBP: 0000000000000001 R08: ffffc90003c57ac7 R09: 0000000000000000
R10: ffffc90003c57aa0 R11: fffff5200078af59 R12: 1ffff110225c9def
R13: 000000000000024f R14: ffffffff8fc561c0 R15: dffffc0000000000
FS:  0000555558120500(0000) GS:ffff8882a9a0f000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000001c0 CR3: 00000001165c4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __mutex_lock_common kernel/locking/mutex.c:591 [inline]
 __mutex_lock+0x119/0x1340 kernel/locking/mutex.c:776
 __io_async_cancel+0x183/0x490 io_uring/cancel.c:188
 __io_sync_cancel io_uring/cancel.c:258 [inline]
 io_sync_cancel+0x7d2/0x940 io_uring/cancel.c:322
 __io_uring_register io_uring/register.c:761 [inline]
 __do_sys_io_uring_register io_uring/register.c:921 [inline]
 __se_sys_io_uring_register+0xe1b/0x12a0 io_uring/register.c:898
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc802f9acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe5ca81768 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
RAX: ffffffffffffffda RBX: 00007fc803205fa0 RCX: 00007fc802f9acb9
RDX: 00002000000001c0 RSI: 0000000000000018 RDI: 0000000000000003
RBP: 00007fc803008bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000001 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc803205fac R14: 00007fc803205fa0 R15: 00007fc803205fa0
 </TASK>
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	48 89 3c 24          	mov    %rdi,(%rsp)
   6:	41 89 f5             	mov    %esi,%r13d
   9:	4c 8d 35 6e 25 32 0e 	lea    0xe32256e(%rip),%r14        # 0xe32257e
  10:	43 80 3c 3c 00       	cmpb   $0x0,(%r12,%r15,1)
  15:	74 08                	je     0x1f
  17:	48 89 df             	mov    %rbx,%rdi
  1a:	e8 0f 31 96 00       	call   0x96312e
  1f:	48 8b 0b             	mov    (%rbx),%rcx
  22:	4c 89 f7             	mov    %r14,%rdi
  25:	89 ee                	mov    %ebp,%esi
  27:	48 89 ca             	mov    %rcx,%rdx
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	44 89 ee             	mov    %r13d,%esi
  32:	48 8b 3c 24          	mov    (%rsp),%rdi
  36:	eb b5                	jmp    0xffffffed
  38:	44 89 f1             	mov    %r14d,%ecx
  3b:	80 e1 07             	and    $0x7,%cl
  3e:	80                   	.byte 0x80
  3f:	c1                   	.byte 0xc1


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
