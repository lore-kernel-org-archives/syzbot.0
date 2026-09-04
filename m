Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEBA43BB40
	for <syzbot@lists.linux.dev>; Fri,  4 Sep 2026 23:20:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788564038; cv=none; b=eStKCRC8YRVU55S/Ts+NNqlqsyQu1pO2jPEw6yTiv1iWq5VKBB0C8hF+7x9tWVlUZA31yEKn39Oi+wCwtWgFKpVn64TXdS5wNt1yiOqBqrXvP5+kqpVtJc0W374iKW/arBFlu1L8k7MiUUVfQIza/g2BaIRsmf9YsJjA9mey8aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788564038; c=relaxed/simple;
	bh=DRFEoYaPI0Bujo3o5Rdq0L85mjByEaR2cOeXOJVu6m0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=L/EvqkvKgMvbVOZgU4fBBbhafOEyuaaULCTwdyVBzkkU1gOdYM4Izf0IWjqJAhcWcKN9p7993dEgRYb5Ib+JqRrCi+xqjOAmahCRjn3PUzRgdhUiHhBVZ0N02vTzYp/OI8fiYayIK9aYc7dz/1Mhh70JkpHoweqqT8baOBxPTME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6b34c5c6de4so1868329eaf.1
        for <syzbot@lists.linux.dev>; Fri, 04 Sep 2026 16:20:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788564036; x=1789168836;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=b/WxlZqVWyfm4KV+k6KsBRKOEP90t/CoeWuNUOyshWw=;
        b=qQOjmRa3k9MyrQjkycOlJ87hPNQXEeQlsygKwkm9XiGvJkYoA/JDJJJ12qHR5n/glT
         OH+IMGxjwzwvmT2O5ru8xx19PAD03lSBA7t3PlUaN+7eeKK96jkJIEsLDzoQhC98nzVX
         ezZ92VSs2pUAAxbSdSUbkJLlbnzOnyh/fq7+2NU/ztn/QXbTQ01BKNG3/KrRQmuF+Eij
         RmQZ+pkyUQxaJvaVQeNDybdLyeGHok8xhaEwWwIJQyvwTV1qNukf64K0miVjc03/nuTv
         jQlUQ6XwMnT4nr3zNNNSY8vqpIPWcYaXvD2LRlrleLAjqvE17CiwB591FgR8pVmhwwwc
         l1nQ==
X-Gm-Message-State: AFuF++l4+bEbIZsliQMp6FCnBEwpYBGozVmJb7CoLj7exwrzwbKbvx7X
	IPBv2YFXoSariqsApH+WPTo7/yDGwYjpjyI0eiTaxt21tVYfuXF2LtSheKwBF2euGM2pyrHuDYC
	Bl2Oi3jVykGdVkdb+V/Hu9zMyMgHxWFaJG+iN8LRtfBwt/Lt+i0RmZirgQOE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:810a:b0:6ac:8e23:3078 with SMTP id
 006d021491bc7-6b6fa6dd815mr7193952eaf.5.1788564035687; Fri, 04 Sep 2026
 16:20:35 -0700 (PDT)
Date: Fri, 04 Sep 2026 16:20:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a9b5243.b5d4176b.238c3e.0008.GAE@google.com>
Subject: [moderation/CI] Re: f2fs: enable buffered RWF_DONTCACHE
From: syzbot ci <syzbot+cif2741c11656adb66@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] f2fs: enable buffered RWF_DONTCACHE
https://lore.kernel.org/all/cover.1788438786.git.qiwenjie@xiaomi.com
* [PATCH v4 1/2] f2fs: complete dropbehind write bios in task context
* [PATCH v4 2/2] f2fs: enable buffered RWF_DONTCACHE

and found the following issue:
general protection fault in f2fs_write_begin

Full report is available here:
https://ci.syzbot.org/series/cbb9ded8-1388-4a7b-bfa7-44082b04025b

***

general protection fault in f2fs_write_begin

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      e3fc12b08aadde9cec7b3799ac0e0c9a1aa245c4
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/e5903709-6ea2-4b1e-9dfc-f073e36367f=
7/config
syz repro: https://ci.syzbot.org/findings/d05a5d64-e9a3-4714-9b41-43042eaaa=
82c/syz_repro

loop0: detected capacity change from 0 to 40427
F2FS-fs (loop0): invalid crc value
F2FS-fs (loop0): f2fs_recover_fsync_data: recovery fsync data, check_only: =
0
F2FS-fs (loop0): Mounted with checkpoint version =3D 48b305e5
Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000004: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 UID: 0 PID: 5791 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:f2fs_write_begin+0x181/0x28e0 fs/f2fs/data.c:3893
Code: e7 e8 23 21 d4 fd 49 8b 04 24 48 89 44 24 40 41 c6 45 2c 04 c7 84 24 =
a0 02 00 00 00 00 00 00 48 83 c3 20 48 89 d8 48 c1 e8 03 <42> 0f b6 04 30 8=
4 c0 0f 85 e9 23 00 00 41 be 80 00 00 00 44 23 33
RSP: 0018:ffffc900037af7a0 EFLAGS: 00010202
RAX: 0000000000000004 RBX: 0000000000000020 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffff8881b465c918 RDI: 0000000000000000
RBP: ffffc900037afad0 R08: ffffc900037afb80 R09: ffffc900037afba0
R10: dffffc0000000000 R11: ffffffff8463a450 R12: ffff88816b91e678
R13: fffff520006f5f1c R14: dffffc0000000000 R15: ffff8881b465c918
FS:  00007f65b5e096c0(0000) GS:ffff8882a8cd9000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f65b4e70050 CR3: 000000016a860000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 page_symlink+0x27a/0x440 fs/namei.c:6556
 f2fs_symlink+0x5fc/0x970 fs/f2fs/namei.c:714
 vfs_symlink+0x18b/0x330 fs/namei.c:5794
 filename_symlinkat+0x1cd/0x410 fs/namei.c:5819
 __do_sys_symlinkat fs/namei.c:5839 [inline]
 __se_sys_symlinkat+0x4e/0x2b0 fs/namei.c:5834
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f65b4f9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f65b5e09028 EFLAGS: 00000246 ORIG_RAX: 000000000000010a
RAX: ffffffffffffffda RBX: 00007f65b5225fa0 RCX: 00007f65b4f9e159
RDX: 00002000000005c0 RSI: ffffffffffffff9c RDI: 0000200000000700
RBP: 00007f65b5035024 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f65b5226038 R14: 00007f65b5225fa0 R15: 00007fffb6ecc0c8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:f2fs_write_begin+0x181/0x28e0 fs/f2fs/data.c:3893
Code: e7 e8 23 21 d4 fd 49 8b 04 24 48 89 44 24 40 41 c6 45 2c 04 c7 84 24 =
a0 02 00 00 00 00 00 00 48 83 c3 20 48 89 d8 48 c1 e8 03 <42> 0f b6 04 30 8=
4 c0 0f 85 e9 23 00 00 41 be 80 00 00 00 44 23 33
RSP: 0018:ffffc900037af7a0 EFLAGS: 00010202
RAX: 0000000000000004 RBX: 0000000000000020 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: ffff8881b465c918 RDI: 0000000000000000
RBP: ffffc900037afad0 R08: ffffc900037afb80 R09: ffffc900037afba0
R10: dffffc0000000000 R11: ffffffff8463a450 R12: ffff88816b91e678
R13: fffff520006f5f1c R14: dffffc0000000000 R15: ffff8881b465c918
FS:  00007f65b5e096c0(0000) GS:ffff8882a8cd9000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f65b4feb840 CR3: 000000016a860000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	e8 23 21 d4 fd       	call   0xfdd42128
   5:	49 8b 04 24          	mov    (%r12),%rax
   9:	48 89 44 24 40       	mov    %rax,0x40(%rsp)
   e:	41 c6 45 2c 04       	movb   $0x4,0x2c(%r13)
  13:	c7 84 24 a0 02 00 00 	movl   $0x0,0x2a0(%rsp)
  1a:	00 00 00 00
  1e:	48 83 c3 20          	add    $0x20,%rbx
  22:	48 89 d8             	mov    %rbx,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 0f b6 04 30       	movzbl (%rax,%r14,1),%eax <-- trapping instruct=
ion
  2e:	84 c0                	test   %al,%al
  30:	0f 85 e9 23 00 00    	jne    0x241f
  36:	41 be 80 00 00 00    	mov    $0x80,%r14d
  3c:	44 23 33             	and    (%rbx),%r14d


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
[axboe@kernel.dk baohua@kernel.org chao@kernel.org hch@lst.de jack@suse.cz =
jaegeuk@kernel.org linux-block@vger.kernel.org linux-f2fs-devel@lists.sourc=
eforge.net linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux=
-mm@kvack.org qiwenjie@xiaomi.com qwjhust@gmail.com tz2294@columbia.edu]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

