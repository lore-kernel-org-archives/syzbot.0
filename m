Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D17BD38910F
	for <syzbot@lists.linux.dev>; Tue, 22 Sep 2026 04:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790052206; cv=none; b=NxQUlYYaBGAhqZoBXMz19xX0NKVixvJX6EqGA5C9lugKy/iaw/oGQSnDb81PwKUL/BTMFxQ8VvKs4OLiL5l0Ea1YKl07awgcuq/u7bzSg5turaj8TjeJRjR0Onm/JHLAk7eNEclZR8jgTi+6Tr33NETiCGUVxvDcoNDzNJ3x0ds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790052206; c=relaxed/simple;
	bh=OQYTdW+feEtU0nT1xZhwdc+cpH45B0yaM48jILy8Y7s=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=Y/RMLPEji3+967/uT8n0+IszwedW15w+Aq9t2MzrCWfdhw4WKQFyWcxhdAR4K+WokOvSL3NDLbSG8C5ze9eZiG27JlsN/LQUnOTOwJKY5qUMk0RtY0MkArHMfYf+nDRToBKwVcv/uwRTstGLb/CqELfvisfhITmn9JC/BCb69KE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-811a057156aso2578898a34.0
        for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 21:43:24 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790052203; x=1790657003;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ii6CpxlMOU2YNsdl7Ju/KYaeAqAaiitDP3dlw9IiSoU=;
        b=QbAau3EmH5CXl+RQRMRME3DQRNvYkLYc5r0DiNEh0Ff28GbVoPTsXIPrP969OYarb1
         cdy3AoEQeG4zcsw2iUVm53bfk9eZCxlEgOQNBMYDacg+RYPJgAfCYxg4DAUdPr4g2hMT
         hkqKaoiP1P9xl3EoA5vb7V4kfRbJhed5EjrtrrBAAeaHCsN3NdPvmE/fqnq2s0olMoCL
         h9QOpcXNdBqkjLfOKk6Joo6MDlEyv7r7TvbYfl+ykQ6MSccqv/AVvwRoSTgK8zT0qZg2
         oH5QxRhMeUNWvRjYemTdBwYq2aAb+o+UTVlQYMkO+EP5TSjga3fJozgKjtHKmyUDaXKO
         Abkg==
X-Gm-Message-State: AFuF++nXIhY5ZViP1hOg3f4MvButSmxcPmBlfdH948iV8mmRCTMBQczD
	7JvX0EFpEasIOMsd82jfAybLOoOhI3mpTagQLBeJiXjPZ1KIL+AS0/lCGsRKZrAzUG2mrYEid8D
	WYlbI8Ydd0oq1nvsp07ZzZfxH0+4FzUNCMenDwnficnCmo2zUrpuEZ3W9UZY=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee0b:0:b0:6bd:f79e:501c with SMTP id
 006d021491bc7-6ca9ab437d8mr11629437eaf.16.1790052203652; Mon, 21 Sep 2026
 21:43:23 -0700 (PDT)
Date: Mon, 21 Sep 2026 21:43:23 -0700
In-Reply-To: <20260919221735.3708237-1-benquike@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab2076b.e548f532.1ca396.0017.GAE@google.com>
Subject: [syzbot ci] Re: af_unix: fix u->inq_len accounting in manage_oob()
 and unix_stream_read_skb()
From: syzbot ci <syzbot+ci55fe8f14f29976ef@syzkaller.appspotmail.com>
To: benquike@gmail.com, davem@davemloft.net, edumazet@google.com, 
	horms@kernel.org, kuba@kernel.org, kuniyu@google.com, 
	linux-kernel@vger.kernel.org, netdev@vger.kernel.org, pabeni@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] af_unix: fix u->inq_len accounting in manage_oob() and unix_stream_read_skb()
https://lore.kernel.org/all/20260919221735.3708237-1-benquike@gmail.com
* [PATCH] af_unix: fix u->inq_len accounting in manage_oob() and unix_stream_read_skb()

and found the following issue:
kernel BUG in unix_stream_read_skb

Full report is available here:
https://ci.syzbot.org/series/0ffad94e-8c51-41d9-b85f-9793ff3deaf5

***

kernel BUG in unix_stream_read_skb

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      b5a051f6b840d48f159166ef073d3021989bfb50
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/127895ae-9f2e-46db-a972-bc6f975448e6/config

skb linear:   00000100: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb linear:   00000110: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
skb linear:   00000120: 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
------------[ cut here ]------------
kernel BUG at ./include/linux/skbuff.h:2847!
Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
CPU: 1 UID: 0 PID: 16941 Comm: syz.0.3527 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:skb_pull+0x1c4/0x1d0
Code: b2 8c f8 8b 44 24 04 89 43 70 48 c7 c7 c0 ba 22 8d 89 ee e8 9e 96 7c f7 48 c7 c7 00 bb 22 8d 48 89 de 31 d2 e8 7d 00 ff ff 90 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000629f758 EFLAGS: 00010282
RAX: ffffffff89aa3aaa RBX: ffff888107756780 RCX: 0000000000080000
RDX: ffffc90021fe7000 RSI: 000000000000b6ec RDI: 000000000000b6ed
RBP: 0000000000001000 R08: ffff88823c624713 R09: 1ffff110478c48e2
R10: dffffc0000000000 R11: ffffed10478c48e3 R12: 0000000000008000
R13: dffffc0000000000 R14: 1ffff11020eeacfe R15: 0000000000007ec0
FS:  00007f4d8a7ef6c0(0000) GS:ffff8882a8cce000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00002000000c4000 CR3: 000000002253a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 unix_stream_read_skb+0x34a/0x500
 sk_psock_verdict_data_ready+0x25f/0x690
 unix_stream_sendmsg+0x84e/0xde0
 sock_sendmsg_nosec+0x13a/0x180
 ____sys_sendmsg+0x54e/0x850
 ___sys_sendmsg+0x2a5/0x360
 __x64_sys_sendmsg+0x1b1/0x290
 do_syscall_64+0x166/0x520
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f4d8999e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f4d8a7ef028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
RAX: ffffffffffffffda RBX: 00007f4d89c26180 RCX: 00007f4d8999e159
RDX: 0000000000000000 RSI: 0000200000000500 RDI: 0000000000000005
RBP: 00007f4d89a3506b R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f4d89c26218 R14: 00007f4d89c26180 R15: 00007ffd1de3bf98
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:skb_pull+0x1c4/0x1d0
Code: b2 8c f8 8b 44 24 04 89 43 70 48 c7 c7 c0 ba 22 8d 89 ee e8 9e 96 7c f7 48 c7 c7 00 bb 22 8d 48 89 de 31 d2 e8 7d 00 ff ff 90 <0f> 0b 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffc9000629f758 EFLAGS: 00010282
RAX: ffffffff89aa3aaa RBX: ffff888107756780 RCX: 0000000000080000
RDX: ffffc90021fe7000 RSI: 000000000000b6ec RDI: 000000000000b6ed
RBP: 0000000000001000 R08: ffff88823c624713 R09: 1ffff110478c48e2
R10: dffffc0000000000 R11: ffffed10478c48e3 R12: 0000000000008000
R13: dffffc0000000000 R14: 1ffff11020eeacfe R15: 0000000000007ec0
FS:  00007f4d8a7ef6c0(0000) GS:ffff88818d6ce000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fda6ffeb840 CR3: 000000002253a000 CR4: 00000000000006f0


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
