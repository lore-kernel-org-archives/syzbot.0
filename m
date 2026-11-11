Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794418035;
	b=LvWX8f5tlS5Rt8+i5kW17dXBWV+yFg7AkKI7Hi3nteM+BuwrHQfi0uZ/RRrLicHM+Giw
	 k8oF9ZH80U+03+RpZD31iB9GcwraR97H7iXRTfR7V11jEGqHl/+p7cI9+viQYN97iLhFT
	 glNyOhpGZ8m5CGR3PSilmYUfMtiNgGe0YlJHOFtlA1yUY1kSW3ykWUqjlxtLCQN5r1aVF
	 Nt3alv9oUqOx77J3XLr7mFSxjWRwbGjf99sCGWZ5G1e5UVyuuAfW/dS9sHNitA1k++AuR
	 OY0SA86JpDa/J07AUJILHuc5l/LTH5VLN7CvdhZT2y2SDddA8dw4ICcZQa7F3bOt3ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794418035;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=JfAezpAquvz/j7OV3MmjT9IcWRiTIkK0rN0vyNrpnEo=;
	b=bt/ilGRlF8ed9oDyTcmvpLFqzvBdzCo4Vh5VXEN7KTi/pjkwulQTJREhNiEObVfAw0Qh
	 xRLGzthGQPX824jaSGi0LnbRp7P3NX4gXy2JGQUL5VnjExFoVYdcDV6kdAOhnF+2dPcZe
	 2cmBdmtsQ41PiFriwwUrBpbean7N1v+SR8ThYP/Iq7UeYsT1+H0+fdQnWNkhVAsS7jxKz
	 97riCQexfcsnzK0CLFxt5QLod1pYNhl+kFLQ9/Ru5tTN1a1xLxmi2EbxKRoQxSR2Hch0a
	 efEmA2CVBxrZOzZFRgwRAj8K+g/wxBq9LFvgjBuDf8e293pwD0h0qQIhCiVKRuIBHOA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 734C0606A31C
	for <syzbot@lists.linux.dev>; Wed, 11 Nov 2026 17:27:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 734C0606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4c55ba309c2so4148595b6e.1
        for <syzbot@lists.linux.dev>; Wed, 11 Nov 2026 09:27:15 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794418034; x=1795022834;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JfAezpAquvz/j7OV3MmjT9IcWRiTIkK0rN0vyNrpnEo=;
        b=jCBW7KxmUYHIP9SVcaU4pBwk7L4PAwrmM9x2BcutTAcCq4B5alA0uNIUkqmITIATIF
         wjdD2yvvrMHY9g/5r5IIYdAY4HoWLvgeRMCyDT0vnNAllMUK+mvkqM+x3qhbVt7Ggm3x
         BXjtyZyMRdCF7QMnAB0K0Xx5Dhuq0u0RJoZkSixzduzno/yps8Q+VcrqRd648ZFv7CzF
         QMFCDNUW6M/86MGHEh9i2BdHiV1aiZRgtYjgfSzWYvYnwnDHTT91NS8soHxI4R3a/ggV
         Z9MGK/GSeAA09OyRY4ZDNrBjpdW8+uQn+KJmk/i21UCg1EqvVNe7FVgQUyCtEFK8rOW/
         ZDhQ==
X-Gm-Message-State: APuU4Z8IeyYmXUbv0bw1SdxVSf/xVqPeJ3awaLGduMJ0LWdOFPmxQs4Z
	2O9s+Za6fbM2eFBc/jA1QL6QBkwBzDbjTJvlhVSKUc/OgZ3jAVtdzrCvQf76/GKHHxOahtZQXj/
	ViI+w5dYZWuMbIhFvaDEwnV7IIQafyDVa0xy3IWcPSotqFGyrwc0O359Olw0=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c1b2:b0:4d6:90f4:48ab with SMTP id
 5614622812f47-56b97c18413mr2732395b6e.45.1794418034511; Wed, 11 Nov 2026
 09:27:14 -0800 (PST)
Date: Wed, 11 Nov 2026 09:27:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6af4a572.ad703688.70d19.1af0.GAE@google.com>
Subject: [moderation/CI] Re: tipc: bound reassembly size in tipc_buf_append()
From: syzbot ci <syzbot+ci466aa6a3db8114ff@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] tipc: bound reassembly size in tipc_buf_append()
https://lore.kernel.org/all/AoU-V5M5ZCKF37bLl8ILhgeNdsnCEaiaQNuWP4K56kRfJsnhkIexZ8tFRLq7uzGiA0qNqK6shXcSZ5E4hyV0-QI0ZWSuKiJzKvMrv3NfqCg=@proton.me
* [PATCH] tipc: bound reassembly size in tipc_buf_append()

and found the following issue:
general protection fault in tipc_buf_append

Full report is available here:
https://ci.syzbot.org/series/3856f5b1-55ca-4bc2-885e-034eb8af1bdf

***

general protection fault in tipc_buf_append

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      c4c470912125ec8a1a427a70f4085d8a731b00e4
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/28264169-6c3f-405e-9f6a-339572b43e52/config
syz repro: https://ci.syzbot.org/findings/e9e2a2a5-41e6-4866-89fc-45c75bfe992b/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 1 UID: 0 PID: 5915 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:tipc_buf_append+0x389/0xa20 net/tipc/msg.c:153
Code: e9 b5 01 00 00 e8 97 ea 29 f6 48 8b 44 24 20 42 80 3c 30 00 48 8b 5c 24 28 74 08 48 89 df e8 8e 74 a1 f6 48 c7 03 00 00 00 00 <41> 0f b6 46 0e 84 c0 0f 85 ea 04 00 00 8b 1c 25 70 00 00 00 4d 8d
RSP: 0018:ffffc900039defa0 EFLAGS: 00010246
RAX: 1ffff9200073be13 RBX: ffffc900039df098 RCX: ffff88810d335a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88816af130c0
RBP: ffffc900039df078 R08: ffff8881ba5f6ee3 R09: 1ffff110374beddc
R10: dffffc0000000000 R11: ffffed10374beddd R12: 1ffff1102d5e2617
R13: 1ffff9200073bdfc R14: dffffc0000000000 R15: ffff88816af12ff0
FS:  00007fbe193e76c0(0000) GS:ffff8882a7809000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbe193e6ff8 CR3: 0000000117562000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 tipc_msg_reassemble+0x230/0x3b0 net/tipc/msg.c:807
 tipc_mcast_xmit+0x254/0x19e0 net/tipc/bcast.c:392
 tipc_sendmcast net/tipc/socket.c:887 [inline]
 __tipc_sendmsg+0x2074/0x2b60 net/tipc/socket.c:1470
 tipc_sendmsg+0x55/0x70 net/tipc/socket.c:1404
 sock_sendmsg_nosec+0x14e/0x190 net/socket.c:800
 __sock_sendmsg net/socket.c:818 [inline]
 ____sys_sendmsg+0x54e/0x850 net/socket.c:2715
 ___sys_sendmsg+0x2a5/0x360 net/socket.c:2769
 __sys_sendmmsg+0x273/0x4e0 net/socket.c:2858
 __do_sys_sendmmsg net/socket.c:2885 [inline]
 __se_sys_sendmmsg net/socket.c:2882 [inline]
 __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2882
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fbe185a8f19
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fbe193e7028 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007fbe18825fa0 RCX: 00007fbe185a8f19
RDX: 0000000000000300 RSI: 0000200000006740 RDI: 0000000000000003
RBP: 00007fbe18637f6d R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fbe18826038 R14: 00007fbe18825fa0 R15: 00007ffeceeefb38
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:tipc_buf_append+0x389/0xa20 net/tipc/msg.c:153
Code: e9 b5 01 00 00 e8 97 ea 29 f6 48 8b 44 24 20 42 80 3c 30 00 48 8b 5c 24 28 74 08 48 89 df e8 8e 74 a1 f6 48 c7 03 00 00 00 00 <41> 0f b6 46 0e 84 c0 0f 85 ea 04 00 00 8b 1c 25 70 00 00 00 4d 8d
RSP: 0018:ffffc900039defa0 EFLAGS: 00010246
RAX: 1ffff9200073be13 RBX: ffffc900039df098 RCX: ffff88810d335a00
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff88816af130c0
RBP: ffffc900039df078 R08: ffff8881ba5f6ee3 R09: 1ffff110374beddc
R10: dffffc0000000000 R11: ffffed10374beddd R12: 1ffff1102d5e2617
R13: 1ffff9200073bdfc R14: dffffc0000000000 R15: ffff88816af12ff0
FS:  00007fbe193e76c0(0000) GS:ffff8882a7809000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbe193e6ff8 CR3: 0000000117562000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	e9 b5 01 00 00       	jmp    0x1ba
   5:	e8 97 ea 29 f6       	call   0xf629eaa1
   a:	48 8b 44 24 20       	mov    0x20(%rsp),%rax
   f:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1)
  14:	48 8b 5c 24 28       	mov    0x28(%rsp),%rbx
  19:	74 08                	je     0x23
  1b:	48 89 df             	mov    %rbx,%rdi
  1e:	e8 8e 74 a1 f6       	call   0xf6a174b1
  23:	48 c7 03 00 00 00 00 	movq   $0x0,(%rbx)
* 2a:	41 0f b6 46 0e       	movzbl 0xe(%r14),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 ea 04 00 00    	jne    0x521
  37:	8b 1c 25 70 00 00 00 	mov    0x70,%ebx
  3e:	4d                   	rex.WRB
  3f:	8d                   	.byte 0x8d


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[davem@davemloft.net edumazet@kernel.org jmaloy@redhat.com kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org noahweinberger2003@proton.me pabeni@redhat.com tung.quang.nguyen@est.tech]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

