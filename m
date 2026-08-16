Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5635B38D018
	for <syzbot@lists.linux.dev>; Sun, 16 Aug 2026 19:48:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786909717; cv=none; b=Z+0Y0lZ17cFxG4FaMEE0vX5eYhumgEGyiAzXeIi18PfR8bKkfN44AMY1mfuIFb3tXYxZh2wwdyE4c8gybK5lz0dXMNe1XLQ4RF2ERJ1ywEKfHuaZjbElRP2QhHwkJhkMCkLff4l+s10A4XGrK21Ru8rWvkeamXoIohRocidKt6g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786909717; c=relaxed/simple;
	bh=aIv5el34buGClDkbYjBq9qb59JKeeiZTVRPWHBj4CXI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=mRbeMUPcsMPyrV78WcGx9UOgwuhDGkLGSrUPegHQkzUvdVr1fki6zuNtyRV83gfsolO16JSIAvLD0v0Pz25QlFWsCRs5HkEI/tUfINTSl9iMAhbV+2NStIj3gj0XRw6Ng1mYIiCOaAqUfJwBPSpVOxQWB4y+AdEegTppDcMsREw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4ad778bacbeso3365569b6e.1
        for <syzbot@lists.linux.dev>; Sun, 16 Aug 2026 12:48:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786909714; x=1787514514;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=bdk88Dzb/R3HSdPbYKs31QbZvcZ52Tyh8/oVkwj3Lbs=;
        b=W4FHivc79bb6haQ40KKpuJhosrKJ5tPCzbQ+FN/EPip3jRcUdlPcWQAcHL4Q417qbT
         S+c1xlY2guUpWV/kJSCuG9NFeTC1InNmzw4JvGhw3qTzWt24KNGDvfEsr42gfxnavp7+
         hYrc5Z6oabQPQuKC2uPxx96c7v4CczF55Xn50UXhu62/d4hjkLUqnZIDy9MwYaIeOGlL
         rF6rLg1cmuT2YUNyrLmfZFOKZ01AjRYDWJ7DDCvPL5OWqZy+xJoM6ZkvdlZst5Xr6+xT
         POeXWdxdJf5P6QuOi4EjllfyDiQ01t6psRqPadrSMMBTlXDH1DqBKbQrt6jbTmhfV4RG
         qzjA==
X-Gm-Message-State: AOJu0YyC9RqOmhRVVC6g4KBk1DtELQbB1LNrWt3k8co/PCcPSaP6GAsD
	QubCa2x/DO705eMmlPlJ77f68kLMpxXCMEWmbJKy9QhJOMo7tU6viUObJDS7qb270m9+TAOuk4v
	dsa1yZYTFGcnXOs8LS9LLRSCBncDdfoTBDVNO3TiaqieKh3dm9LlGi94csCM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:f03:b0:49a:8f0d:cdd2 with SMTP id
 5614622812f47-4b2413e979fmr19356648b6e.5.1786909714291; Sun, 16 Aug 2026
 12:48:34 -0700 (PDT)
Date: Sun, 16 Aug 2026 12:48:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a821412.dbb3a75c.20434b.0039.GAE@google.com>
Subject: [moderation/CI] Re: Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
From: syzbot ci <syzbot+cic1cfa51fa622b17b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir
https://lore.kernel.org/all/tencent_BDF7C28D876E422418FB57474B765F0C1A09@qq.com
* [PATCH v2] Add EXT4_STATE_MAY_INLINE_DATA check in ext4_readdir

and found the following issue:
WARNING in invalidate_bh_lru

Full report is available here:
https://ci.syzbot.org/series/74cf3860-255d-49bb-b3df-51f8ee44a69f

***

WARNING in invalidate_bh_lru

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      1351c159c59b04195647917c5a5f0e5467f44bb0
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/500e2ced-dbe6-480e-affe-813e984ba307/config
syz repro: https://ci.syzbot.org/findings/875c08a7-1950-4014-851b-0d660dfa2413/syz_repro

------------[ cut here ]------------
VFS: brelse: Trying to free free buffer
WARNING: fs/buffer.c:1147 at __brelse fs/buffer.c:1147 [inline], CPU#0: udevd/5048
WARNING: fs/buffer.c:1147 at brelse include/linux/buffer_head.h:326 [inline], CPU#0: udevd/5048
WARNING: fs/buffer.c:1147 at __invalidate_bh_lrus fs/buffer.c:1506 [inline], CPU#0: udevd/5048
WARNING: fs/buffer.c:1147 at invalidate_bh_lru+0xfa/0x1b0 fs/buffer.c:1519, CPU#0: udevd/5048
Modules linked in:
CPU: 0 UID: 0 PID: 5048 Comm: udevd Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__brelse fs/buffer.c:1147 [inline]
RIP: 0010:brelse include/linux/buffer_head.h:326 [inline]
RIP: 0010:__invalidate_bh_lrus fs/buffer.c:1506 [inline]
RIP: 0010:invalidate_bh_lru+0xfa/0x1b0 fs/buffer.c:1519
Code: f7 be 04 00 00 00 e8 85 c0 d8 ff f0 41 ff 0e eb 1e e8 8a 21 6b ff 80 3c 2b 00 75 20 eb 26 e8 7d 21 6b ff 48 8d 3d e6 bf 01 0e <67> 48 0f b9 3a 4c 89 fd 4f 8d 3c 2c 80 3c 2b 00 74 08 4c 89 ff e8
RSP: 0018:ffffc90000007f38 EFLAGS: 00010006
RAX: ffffffff825be013 RBX: 1ffff11024206b2d RCX: ffff888172139dc0
RDX: 0000000000010000 RSI: 0000000000000000 RDI: ffffffff905da000
RBP: 0000000000000000 R08: ffff8881078c875b R09: 1ffff11020f190eb
R10: dffffc0000000000 R11: ffffed1020f190ec R12: ffff888121035960
R13: 0000000000000008 R14: ffff8881078c8758 R15: dffffc0000000000
FS:  00007f6c32242c80(0000) GS:ffff88818d952000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fc1515eb7c0 CR3: 000000016c5ac000 CR4: 00000000000006f0
Call Trace:
 <IRQ>
 csd_do_func kernel/smp.c:136 [inline]
 __flush_smp_call_function_queue+0x32c/0xa20 kernel/smp.c:580
 __sysvec_call_function_single+0x9a/0x3d0 arch/x86/kernel/smp.c:272
 instr_sysvec_call_function_single arch/x86/kernel/smp.c:267 [inline]
 sysvec_call_function_single+0x9e/0xc0 arch/x86/kernel/smp.c:267
 </IRQ>
 <TASK>
 asm_sysvec_call_function_single+0x1a/0x20 arch/x86/include/asm/idtentry.h:681
RIP: 0010:lock_is_held_type+0x106/0x150 kernel/locking/lockdep.c:5945
Code: 1a 00 00 b8 ff ff ff ff 65 0f c1 05 54 4c 9c 07 83 f8 01 75 25 9c 58 a9 00 02 00 00 75 39 41 f7 c4 00 02 00 00 74 01 fb 89 d8 <5b> 41 5c 41 5d 41 5e 41 5f 5d e9 1b 00 03 00 cc 90 0f 0b 90 48 c7
RSP: 0018:ffffc9000624f818 EFLAGS: 00000206
RAX: 0000000000000001 RBX: 0000000000000001 RCX: 0000000000000046
RDX: 0000000000000000 RSI: ffffffff8e4ae37e RDI: ffffffff8c4bbd80
RBP: 00000000ffffffff R08: ffffc9000020daa7 R09: 1ffff92000041b54
R10: dffffc0000000000 R11: fffff52000041b55 R12: 0000000000000246
R13: ffff888172139dc0 R14: ffffffff8eb59c60 R15: 0000000000000000
 __d_lookup+0x170/0x790 fs/dcache.c:2612
 lookup_fast+0x82/0x5d0 fs/namei.c:1878
 walk_component fs/namei.c:2278 [inline]
 link_path_walk+0x71f/0x1910 fs/namei.c:2656
 path_openat+0x236/0x3830 fs/namei.c:4859
 do_file_open+0x23e/0x4a0 fs/namei.c:4892
 do_sys_openat2+0x115/0x200 fs/open.c:1368
 do_sys_open fs/open.c:1374 [inline]
 __do_sys_openat fs/open.c:1390 [inline]
 __se_sys_openat fs/open.c:1385 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1385
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6c3231a477
Code: 10 00 00 00 44 8b 54 24 e0 48 89 44 24 c0 48 8d 44 24 d0 48 89 44 24 c8 44 89 c2 4c 89 ce bf 9c ff ff ff b8 01 01 00 00 0f 05 <48> 3d 00 f0 ff ff 76 10 48 8b 15 82 69 0d 00 f7 d8 64 89 02 48 83
RSP: 002b:00007ffe8da39558 EFLAGS: 00000287 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 000055a56911c8f0 RCX: 00007f6c3231a477
RDX: 0000000000090800 RSI: 000055a569100840 RDI: 00000000ffffff9c
RBP: 000055a569196980 R08: 0000000000090800 R09: 000055a569100840
R10: 0000000000000000 R11: 0000000000000287 R12: 000055a569100840
R13: 00000000000000ff R14: 000055a53ac761c4 R15: 0000000000000000
 </TASK>
----------------
Code disassembly (best guess):
   0:	f7 be 04 00 00 00    	idivl  0x4(%rsi)
   6:	e8 85 c0 d8 ff       	call   0xffd8c090
   b:	f0 41 ff 0e          	lock decl (%r14)
   f:	eb 1e                	jmp    0x2f
  11:	e8 8a 21 6b ff       	call   0xff6b21a0
  16:	80 3c 2b 00          	cmpb   $0x0,(%rbx,%rbp,1)
  1a:	75 20                	jne    0x3c
  1c:	eb 26                	jmp    0x44
  1e:	e8 7d 21 6b ff       	call   0xff6b21a0
  23:	48 8d 3d e6 bf 01 0e 	lea    0xe01bfe6(%rip),%rdi        # 0xe01c010
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	4c 89 fd             	mov    %r15,%rbp
  32:	4f 8d 3c 2c          	lea    (%r12,%r13,1),%r15
  36:	80 3c 2b 00          	cmpb   $0x0,(%rbx,%rbp,1)
  3a:	74 08                	je     0x44
  3c:	4c 89 ff             	mov    %r15,%rdi
  3f:	e8                   	.byte 0xe8


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
[1289151713@qq.com ack@suse.cz adilger.kernel@dilger.ca libaokun@linux.alibaba.com linux-ext4@vger.kernel.org ojaswin@linux.ibm.com tytso@mit.edu yi.zhang@huawei.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

