Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A85D33B967
	for <syzbot@lists.linux.dev>; Tue, 16 Dec 2025 11:01:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765882908; cv=none; b=r+TQUt7hi7i3o8/wdiV5tcu++Y7pBSWkaXnvVGJp84yyT4oJPpVIx7O3dWztpe1qtAuFSXGT+lcMXJTDI05ByJbvWJUoOSiSUDOvp4OKzQ0hPQ3XMS+TfHtwoJ1E7Gwg5ZFnvWyEG4B53nXYriLgGXzvvGGy5gYFEwAxnq5DRok=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765882908; c=relaxed/simple;
	bh=cQ55AmZ+N/eK1AKJ8/UbsgUz5X8TOFIjsl1vn27g23w=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=gaa/MfXAa4NRA9p3c8goLxHS5PeAbTHDof6e1IqJWJOich4DjDFqhoRZeO8jzO8T2MyYCh0EXlkPAskyDuWzp+ypjX/ZxInpqPYBnVp7sFCN79MPErweFJY5tQ+sUfDlS9Qf6XojGbKNbpkGwvsv6eb6kXkadaxBMbyCZASZtmc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7c7595cde21so9527827a34.2
        for <syzbot@lists.linux.dev>; Tue, 16 Dec 2025 03:01:46 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765882905; x=1766487705;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WT/DffL+VjHps7sUEBmOm8h39BBVBKiGpmDrr3wy3SM=;
        b=iKymZCqZUGIeKv+4zsgpB4crdKJGg8Ml5LNOJc1qXHRDE8TvXHgVSCGjRcahn2eA9M
         knxAztI1FYfEid9XP2f8Y6TMSd87bFoADYDdpE7Vsz1YYeVEs4Y0DARer+/yzR3dwRj4
         Gqfyowjll+0g3dnYRC+XMizFu5VhzuvkBNX8KJkgM5+IUtDnp0w5TNt79rnPouix9724
         DRGwo00ndmIOXa/w8Ce15zxauYzu1ms0HlpnVMlzBj9lLjOP4Ux6sblxtLbRJTMWc420
         h2+CJr9cWIFpbOt/wScEKTu+nM0QolQ7vFoMrmeq2cHnGacdKYmSu1FqbnSpMJ4ebeAH
         wFXw==
X-Gm-Message-State: AOJu0Yy8CM8C2aGTmSSLLApYYwN7ke9g+JNdtbfTuTFw2taixM4tbK2D
	YgnbX+qZxZyIcYXOAqBwcZsdpCaN6ThhwMsxAEFabndRQc5C7qgzIZSr9c4A78nxUNPFbavn9rR
	TmJHyYjmmIogNpbcier4xS6t/RNwxhCTu2JZ2y80ELGLzOkTBlhcat2QcKhs=
X-Google-Smtp-Source: AGHT+IEYA7GsVZOWv9Z0tn/p48YtndEBfGOVxc9dD1dGOi16YxlV5YmkdHWBmXbd1qd1dNu3AWNlrWCkK6N48xaZtwEbZ6QI5Bko
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b06:b0:659:9a49:900b with SMTP id
 006d021491bc7-65b45286e61mr5809041eaf.56.1765882905378; Tue, 16 Dec 2025
 03:01:45 -0800 (PST)
Date: Tue, 16 Dec 2025 03:01:45 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69413c19.a70a0220.104cf0.034d.GAE@google.com>
Subject: [moderation/CI] Re: xsk: introduce pre-allocated memory per xsk CQ
From: syzbot ci <syzbot+ci2fbf4060a9723f70@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] xsk: introduce pre-allocated memory per xsk CQ
https://lore.kernel.org/all/20251216052623.2697-1-kerneljasonxing@gmail.com
* [PATCH bpf-next v2 1/2] xsk: introduce local_cq for each af_xdp socket
* [PATCH bpf-next v2 2/2] xsk: introduce a dedicated local completion queue=
 for each xsk

and found the following issue:
WARNING in vfree

Full report is available here:
https://ci.syzbot.org/series/6719e0f5-2213-4ff5-83d4-c964705b4b0f

***

WARNING in vfree

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
-next.git
base:      759377dab35e404fc4f013e3f853d6e9450b4633
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/99fbc71e-e7da-4091-b3a0-9180ab35952=
e/config
C repro:   https://ci.syzbot.org/findings/9588a511-f24a-4f1a-a73b-01059171d=
1d7/c_repro
syz repro: https://ci.syzbot.org/findings/9588a511-f24a-4f1a-a73b-01059171d=
1d7/syz_repro

UDPLite6: UDP-Lite is deprecated and scheduled to be removed in 2025, pleas=
e contact the netdev mailing list
------------[ cut here ]------------
Trying to vfree() nonexistent vm area (ffffc900028f6000)
WARNING: mm/vmalloc.c:3423 at 0x0, CPU#1: syz.0.17/5994
Modules linked in:
CPU: 1 UID: 0 PID: 5994 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:vfree+0x393/0x400 mm/vmalloc.c:3422
Code: e8 42 12 ab ff 4c 89 f7 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e9 =
0c fa ff ff e8 27 12 ab ff 48 8d 3d e0 f1 6e 0d 4c 89 f6 <67> 48 0f b9 3a e=
9 fd fd ff ff e8 0e 12 ab ff 4c 89 e7 e8 66 00 00
RSP: 0018:ffffc900043d7c40 EFLAGS: 00010293
RAX: ffffffff82163839 RBX: 0000000000000000 RCX: ffff888112303a80
RDX: 0000000000000000 RSI: ffffc900028f6000 RDI: ffffffff8f852a20
RBP: 1ffff1102e7044bf R08: ffff88810005d863 R09: 1ffff1102000bb0c
R10: dffffc0000000000 R11: ffffed102000bb0d R12: ffff888118dc8018
R13: dffffc0000000000 R14: ffffc900028f6000 R15: ffff888173822608
FS:  0000555558e99500(0000) GS:ffff8882a9eb0000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000180 CR3: 0000000174424000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 xsk_clear_local_cq net/xdp/xsk.c:1194 [inline]
 xsk_release+0x6b3/0x880 net/xdp/xsk.c:1226
 __sock_release net/socket.c:653 [inline]
 sock_close+0xc3/0x240 net/socket.c:1446
 __fput+0x44c/0xa70 fs/file_table.c:468
 task_work_run+0x1d4/0x260 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
 exit_to_user_mode_loop+0xff/0x4f0 kernel/entry/common.c:75
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [in=
line]
 syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
 do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5338b8f7c9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffd8e18db38 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 000000000000f4d1 RCX: 00007f5338b8f7c9
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 0000000000000000 R08: 0000000000000001 R09: 000000088e18de2f
R10: 0000001b2fe20000 R11: 0000000000000246 R12: 00007f5338de5fac
R13: 00007f5338de5fa0 R14: ffffffffffffffff R15: 0000000000000003
 </TASK>
----------------
Code disassembly (best guess):
   0:	e8 42 12 ab ff       	call   0xffab1247
   5:	4c 89 f7             	mov    %r14,%rdi
   8:	48 83 c4 18          	add    $0x18,%rsp
   c:	5b                   	pop    %rbx
   d:	41 5c                	pop    %r12
   f:	41 5d                	pop    %r13
  11:	41 5e                	pop    %r14
  13:	41 5f                	pop    %r15
  15:	5d                   	pop    %rbp
  16:	e9 0c fa ff ff       	jmp    0xfffffa27
  1b:	e8 27 12 ab ff       	call   0xffab1247
  20:	48 8d 3d e0 f1 6e 0d 	lea    0xd6ef1e0(%rip),%rdi        # 0xd6ef207
  27:	4c 89 f6             	mov    %r14,%rsi
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	e9 fd fd ff ff       	jmp    0xfffffe31
  34:	e8 0e 12 ab ff       	call   0xffab1247
  39:	4c 89 e7             	mov    %r12,%rdi
  3c:	e8                   	.byte 0xe8
  3d:	66 00 00             	data16 add %al,(%rax)


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[ast@kernel.org bjorn@kernel.org bpf@vger.kernel.org daniel@iogearbox.net d=
avem@davemloft.net edumazet@google.com hawk@kernel.org john.fastabend@gmail=
.com jonathan.lemon@gmail.com kerneljasonxing@gmail.com kernelxing@tencent.=
com kuba@kernel.org maciej.fijalkowski@intel.com magnus.karlsson@intel.com =
netdev@vger.kernel.org pabeni@redhat.com sdf@fomichev.me]

If the report looks fine to you, reply with:
#syz upstream

