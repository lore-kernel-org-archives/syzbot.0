Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1245237B030
	for <syzbot@lists.linux.dev>; Tue, 22 Sep 2026 04:37:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790051875; cv=none; b=s6XyhaF8htjjGrzjA5MvlkaV8h43rQ9loqGp8g0IZmAGEEAjilAgkn4meb+il8cgfKZ9nhUZ7EKgW7yMSmKVtUIS4crDHl9dhLhivLlksrSLg9m8LXFzfBl0jrndSpzbfj/0jLlSQbKd4sQBrncVmynTSDXJTPd68CQhmYp1QkE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790051875; c=relaxed/simple;
	bh=/7xDKDDcahBTbeiilF/ydkbtH8NRN4QP6hofQxdokVQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=sJHgoSVpndYyqpWyg1rNftUNmPPBhq3+SDxFxFoyU0VwPkiuZDrzMDxpQpkf/R9/sz6tSCeE1dgXe0oIjzECsgv6gT4gopL6CsJynkzhxiokrAkfz6zhZgHN2+N3QS9KAPhb14fLWvAlr6apy2JuTcL6R72UdaQ5VOgYbGcJW0E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6d018fb0e4eso977851eaf.0
        for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 21:37:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790051873; x=1790656673;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=uTChKGnrATE+yXF2saMPRMfnsvTcu1ru4ClDuCuipbA=;
        b=RirIbaGGRJRYqE3gnJC6r8cjee40NmlEez7a/2QI/dSlZBoEVZVG27vzT7ppW2Wfrt
         enpdPlVe7pdL2ANJMsW72nDPouEanOhX4aOLIvutR4EKOH+5x7XeQfzhrPfkg98bYH0r
         PCX1Es/gQKC1vzQtzpkNMY6JGTj3wtjSTPIW1cwNpVgopdfvbgrNa3saaZWXfUXpK68o
         ekEIrkuCp1faLVv89iHKRJfav7cR1zkjb1nGKsMwWz5YSXEbu37+n8e520hHQh9YMNND
         G+U9/4MVlHi3PVhQLuHEm6MvNAYd3tF71D2sIlZ6SPAfutVfbnVzIOTxOp/PEzOnED7c
         N6tg==
X-Gm-Message-State: AFuF++naswzTqy6GfPW3huA91lVe0Sf8+1s3y08fwCkNts2oAk2gFBno
	FfIAWfFWq+e/NmI4+nnfTHsaS5wXDMppxniAfLvxkK0c73pwWrX/5sHVXWi1HICO8sdak2RXzJR
	YmOeH2xr8m4UyNRFSsVFlnUn7pB+BEkVWzu1Ptqipv05dIlH1NhM3oyBNO+E=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2912:b0:6cd:3ffc:64cd with SMTP id
 006d021491bc7-6cd3ffc6fbemr9033104eaf.72.1790051872888; Mon, 21 Sep 2026
 21:37:52 -0700 (PDT)
Date: Mon, 21 Sep 2026 21:37:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab20620.a6af0033.177e91.001c.GAE@google.com>
Subject: [moderation/CI] Re: af_unix: fix u->inq_len accounting in
 manage_oob() and unix_stream_read_skb()
From: syzbot ci <syzbot+ci721d07d59efe205c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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
AI triage: https://ci.syzbot.org/findings/bd2d2895-8350-4dbd-8d54-8a669daddc1b/triage_trajectory

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

The email will later be sent to:
[benquike@gmail.com davem@davemloft.net edumazet@google.com horms@kernel.org kuba@kernel.org kuniyu@google.com linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

