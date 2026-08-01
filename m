Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5F59276028
	for <syzbot@lists.linux.dev>; Sat,  1 Aug 2026 19:46:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785613565; cv=none; b=ZszbgPdpB1dNFUZUN62N9SV1/kjtpuzffRrHcFdaR+IOMJPKRaZgT5jiCctPiI7mjxAbpB5jpcLAbji2+CB7uo+hPsSc74qSGVvMq4cW49PWU+oQUKV3Dbzysm/5Yu771uS86b+Pp+USIpkHezjFgo6Hbc7QgbWzSH29vQs+v4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785613565; c=relaxed/simple;
	bh=WYzci6gI7/NZjGjcg6JQD6hS972vNsfYiszHhjrU5as=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=G9np12A0XaT2dp+uiCz8GYTHNzbojDg5bUgXNZVC+AuSBOsBCAfhzDMSGEHdXmcAe668eYzwwONNAcJ6siTDhnHS8GmtcZO/Xf+KrYJZYGywiGl5TPK4QFIaOz98+Q6Yx3361QEi4rtMVa1wATgY4e/Z3aGvbXrgyuUjj0ilqUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7ee1e335245so1506337a34.1
        for <syzbot@lists.linux.dev>; Sat, 01 Aug 2026 12:46:03 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785613562; x=1786218362;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0UmJwNrHzUjykoX3Z5VpIfsu5BEWZ+maEn9f2FDtrdQ=;
        b=cQP+u/1ZM2pKHCSchAyKONUzsBwmLDkR7PFk4ZASM6d3FVw2Vo5vNUZsKEw5qOZsgN
         FsQNhiDXvFikWsWO8Gc/Rx3EVY1tGZY+EGnu034l4FJCdqexLFyNNQ0LS4nJQ9p82SBS
         MCkdp0xv8uxymz46mwUlXf0Wx9hbp0h8EwD80t2dZYnRsQIWDVcC22sfWOSgHxyAQl6X
         KT7J4/a8dvDdzr/W10VLoziWODxxRJF2MwVLFpHcUng35SVEYDsIHZpGF0CXldA6rudq
         2/DpWwvKuBVA7tyW3qjdYyamBWUl/XjIHkFF9+z/9TqoneGwrTylBWVVkj+7GmDKni/7
         B5zw==
X-Gm-Message-State: AOJu0YzqLF+ceMYuZmZZ2SUSndVCA8uYNB17pLLOO7lzEsR3GrUdTLE/
	PTYImb+vLyeItK43H1vHvIxMayPJp6I6xxBJ/+1TNRrWq+VARFAFELmttuHDlU76Q0DGk5lifaf
	ifgUEpaLeCD0r4QHPw1I6jyXb/4SGQZLL8vxBtENOZSl/u5nAFvRp+zpggBA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:6ad0:b0:6ae:55f6:2cdb with SMTP id
 006d021491bc7-6ae55f6312bmr2486037eaf.1.1785613562477; Sat, 01 Aug 2026
 12:46:02 -0700 (PDT)
Date: Sat, 01 Aug 2026 12:46:02 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6e4cfa.2d659fcc.1d46f5.01c0.GAE@google.com>
Subject: [moderation/CI] Re: iomap: follow the alignment requirement for iomap_dio_hole_iter()
From: syzbot ci <syzbot+cid37113556dd77782@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] iomap: follow the alignment requirement for iomap_dio_hole_iter()
https://lore.kernel.org/all/9209e7204fc6b7b60c28f196750084be8a2faba8.1785489008.git.wqu@suse.com
* [PATCH v2] iomap: follow the alignment requirement for iomap_dio_hole_iter()

and found the following issue:
general protection fault in iomap_dio_hole_iter

Full report is available here:
https://ci.syzbot.org/series/9d98023b-4249-4697-ab21-ea7cf83805c8

***

general protection fault in iomap_dio_hole_iter

tree:      vfs
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
base:      fa20f6cb6063f7f1a6a56693d4a8713f19058d23
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a53b891c-9ac3-484a-a77e-61c04d35157f/config
syz repro: https://ci.syzbot.org/findings/8ed3b1e3-7e4e-4c2c-b0f6-934cfea6e536/syz_repro

syz.0.17: attempt to access beyond end of device
loop0: rw=2049, sector=53248, nr_sectors = 976 limit=40427
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 1 UID: 0 PID: 6257 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:bdev_get_queue include/linux/blkdev.h:1056 [inline]
RIP: 0010:bdev_logical_block_size include/linux/blkdev.h:1401 [inline]
RIP: 0010:iomap_dio_alignment fs/iomap/direct-io.c:412 [inline]
RIP: 0010:iomap_dio_hole_iter+0x1bf/0x390 fs/iomap/direct-io.c:598
Code: fc ff df 80 3c 08 00 74 08 4c 89 ef e8 aa d7 c7 ff 49 8b 6d 00 48 83 c5 18 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 ef e8 83 d7 c7 ff 41 bd 58 01 00 00 4c 03
RSP: 0018:ffffc90003eff500 EFLAGS: 00010206
RAX: 0000000000000003 RBX: ffffc90003eff680 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000018 R08: ffff88816dc38fff R09: 0000000000000000
R10: ffff88816dc38000 R11: ffffed102db87200 R12: 0000000000001000
R13: ffffc90003eff6c8 R14: ffff88816b839c00 R15: 1ffff1102d707388
FS:  00007ffb1678d6c0(0000) GS:ffff8882a8f4b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000563ae8dcd0a8 CR3: 0000000110cf4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 iomap_dio_iter fs/iomap/direct-io.c:-1 [inline]
 __iomap_dio_rw+0xe56/0x1ac0 fs/iomap/direct-io.c:823
 f2fs_dio_read_iter fs/f2fs/file.c:4887 [inline]
 f2fs_file_read_iter+0x60b/0x940 fs/f2fs/file.c:4950
 copy_splice_read+0x5ff/0xaa0 fs/splice.c:362
 do_splice_read fs/splice.c:979 [inline]
 splice_direct_to_actor+0x4b6/0xcb0 fs/splice.c:1084
 do_splice_direct_actor fs/splice.c:1202 [inline]
 do_splice_direct+0x195/0x290 fs/splice.c:1228
 do_sendfile+0x52e/0x7c0 fs/read_write.c:1371
 __do_sys_sendfile64 fs/read_write.c:1432 [inline]
 __se_sys_sendfile64+0x144/0x1a0 fs/read_write.c:1418
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ffb1599e019
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffb1678d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000028
RAX: ffffffffffffffda RBX: 00007ffb15c25fa0 RCX: 00007ffb1599e019
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 0000000000000004
RBP: 00007ffb15a3500c R08: 0000000000000000 R09: 0000000000000000
R10: 0000000800000009 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ffb15c26038 R14: 00007ffb15c25fa0 R15: 00007ffc15b4ab58
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:bdev_get_queue include/linux/blkdev.h:1056 [inline]
RIP: 0010:bdev_logical_block_size include/linux/blkdev.h:1401 [inline]
RIP: 0010:iomap_dio_alignment fs/iomap/direct-io.c:412 [inline]
RIP: 0010:iomap_dio_hole_iter+0x1bf/0x390 fs/iomap/direct-io.c:598
Code: fc ff df 80 3c 08 00 74 08 4c 89 ef e8 aa d7 c7 ff 49 8b 6d 00 48 83 c5 18 48 89 e8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74 08 48 89 ef e8 83 d7 c7 ff 41 bd 58 01 00 00 4c 03
RSP: 0018:ffffc90003eff500 EFLAGS: 00010206
RAX: 0000000000000003 RBX: ffffc90003eff680 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
RBP: 0000000000000018 R08: ffff88816dc38fff R09: 0000000000000000
R10: ffff88816dc38000 R11: ffffed102db87200 R12: 0000000000001000
R13: ffffc90003eff6c8 R14: ffff88816b839c00 R15: 1ffff1102d707388
FS:  00007ffb1678d6c0(0000) GS:ffff8882a8f4b000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000558d8b221b40 CR3: 0000000110cf4000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 2 bytes skipped:
   0:	df 80 3c 08 00 74    	filds  0x7400083c(%rax)
   6:	08 4c 89 ef          	or     %cl,-0x11(%rcx,%rcx,4)
   a:	e8 aa d7 c7 ff       	call   0xffc7d7b9
   f:	49 8b 6d 00          	mov    0x0(%r13),%rbp
  13:	48 83 c5 18          	add    $0x18,%rbp
  17:	48 89 e8             	mov    %rbp,%rax
  1a:	48 c1 e8 03          	shr    $0x3,%rax
  1e:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  25:	fc ff df
* 28:	80 3c 08 00          	cmpb   $0x0,(%rax,%rcx,1) <-- trapping instruction
  2c:	74 08                	je     0x36
  2e:	48 89 ef             	mov    %rbp,%rdi
  31:	e8 83 d7 c7 ff       	call   0xffc7d7b9
  36:	41 bd 58 01 00 00    	mov    $0x158,%r13d
  3c:	4c                   	rex.WR
  3d:	03                   	.byte 0x3


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

The email will later be sent to:
[linux-btrfs@vger.kernel.org linux-fsdevel@vger.kernel.org linux-xfs@vger.kernel.org wqu@suse.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

