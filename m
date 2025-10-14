Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24C7F16F265
	for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 09:10:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760433021; cv=none; b=VdEILC8INcMyz5vxVwughlubFSx3r5676nQrGlEp1+tREALemCt1qG6HRO/kqF1feKYFJ5E+ahUhUSqPZT+w9ed7PzIA12hUS/GHqf/gC4Zl+F88D1lUhZpT+zENlQ2wtfTIDEXGPMJDWFIsmorfenMWJWtOm02dBghqOXNVTsM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760433021; c=relaxed/simple;
	bh=v2R1yCJ/bHbyUIngERGEF22+BO7zlVUYRmLNbKpfxlg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=dT2a5dVIXeBeEPcZqdU2EYpNqXRuT6/sgssQqOV6YLe7ak3eJZP6ysgB+uTeMaGECiIlxR+QC7TFwkzfGMxBM3q9qrL9wOZuUcYl3OE7PpFFK8zqiEWp71nhSGMoLpHGLQY+jBVxP43UfXEASfZj1WviLuA0kjLyd9e1GIWi6EU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-42f6639fb22so153566685ab.0
        for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 02:10:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760433018; x=1761037818;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AEKg+GQli6vomCmfpEoGzv10+EYzyEvISu4AthJO1dY=;
        b=GxuOsnhe/uhUcyVAxIhHCuW2/QiLYfCZHnZYaXcpCetVtgymuzMWWc3OCwlZhzT6dX
         oDRYvrHWUHf9MjvRQk+wZBlDj6x1HwjVBXBtERqrz2L7jnFGSkjZvmoDEfoEn9M8uALK
         3KnnZUeJfogIBx/TM5vmWYRhOcd+WJyRPS0qHhUMgQ+QNiVIU+clQN3aa9m/YduwMxsd
         gpf1RHzmO8UXoFyQGaXsMev3JwMk6qz5TtkkLDeJZhWbMwOddyaearEXDd8dbVLZafsd
         /ZOfjoJY9eKQNrriJMxRG2bzJmneU+rgIYnyoqYKFWU0P9Fs0h0DB/0kb3If7fcgo+dA
         DD4w==
X-Gm-Message-State: AOJu0Yz6Ox8jkJ6QFFZdyMyhXw52bAy6Xcrhb1GpB3l18JI5AosrawHr
	NfL4lM6QGi0sztKwNBOEixFq8dOqePivo4ywuNAuJdVzIeAGhfrgLAEH/q4y8/k3XYmayBEVi+r
	/lbXoCwVUhqHb27Vk9FjJLrw8pCzLIdfV4JpIcYLvVqLxA9VziVsakxfZas0=
X-Google-Smtp-Source: AGHT+IG3TEDnbfyNFhBwtdvx9xpv6RG1wYvoLXHGw3ptWBPUeY5axpKZJlWMFIwzBBQcQRK/3pv67pvjNaf2w9q4Q1UU7n7ZnKZS
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3082:b0:430:a0f7:a5b1 with SMTP id
 e9e14a558f8ab-430a0f7b7b0mr24483835ab.24.1760433018236; Tue, 14 Oct 2025
 02:10:18 -0700 (PDT)
Date: Tue, 14 Oct 2025 02:10:18 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ee137a.050a0220.91a22.0202.GAE@google.com>
Subject: [moderation/CI] Re: net/tls: support setting the maximum payload size
From: syzbot ci <syzbot+cie109a12f1eafee2c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] net/tls: support setting the maximum payload size
https://lore.kernel.org/all/20251014051825.1084403-2-wilfred.opensource@gma=
il.com
* [PATCH net-next v5 1/2] net/tls: support setting the maximum payload size
* [PATCH net-next v5 2/2] selftests: tls: add tls record_size_limit test

and found the following issue:
general protection fault in tls_setsockopt

Full report is available here:
https://ci.syzbot.org/series/210c88bf-945a-460c-9fe3-c55bd1958b5d

***

general protection fault in tls_setsockopt

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      18a7e218cfcdca6666e1f7356533e4c988780b57
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/ae03b3d4-e809-4b0e-bd4a-76b4ae8e9d7=
4/config
C repro:   https://ci.syzbot.org/findings/d0b97737-6ea7-4c05-b10b-71dc834c9=
393/c_repro
syz repro: https://ci.syzbot.org/findings/d0b97737-6ea7-4c05-b10b-71dc834c9=
393/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc=
0000000023: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000118-0x000000000000011f]
CPU: 1 UID: 0 PID: 5970 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:do_tls_setsockopt_tx_payload_len net/tls/tls_main.c:847 [inline]
RIP: 0010:do_tls_setsockopt net/tls/tls_main.c:887 [inline]
RIP: 0010:tls_setsockopt+0x189/0x1590 net/tls/tls_main.c:906
Code: ff df 80 3c 08 00 74 08 4c 89 ff e8 51 67 3c f8 41 bc 18 01 00 00 4d =
03 27 4c 89 e0 48 c1 e8 03 49 bf 00 00 00 00 00 fc ff df <42> 80 3c 38 00 7=
4 08 4c 89 e7 e8 28 67 3c f8 49 83 3c 24 00 0f 84
RSP: 0018:ffffc90003e57cc0 EFLAGS: 00010202
RAX: 0000000000000023 RBX: ffff88816adfcc00 RCX: dffffc0000000000
RDX: 0000000000000006 RSI: ffffffff8d7e872a RDI: ffffffff8bc074e0
RBP: ffffc90003e57e38 R08: ffffffff8f9e0f77 R09: 1ffffffff1f3c1ee
R10: dffffc0000000000 R11: fffffbfff1f3c1ef R12: 0000000000000118
R13: 1ffff920007cafa4 R14: ffff88816b33bde8 R15: dffffc0000000000
FS:  00005555585b2500(0000) GS:ffff8882a9d0f000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000180 CR3: 000000010739e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2360
 __sys_setsockopt net/socket.c:2385 [inline]
 __do_sys_setsockopt net/socket.c:2391 [inline]
 __se_sys_setsockopt net/socket.c:2388 [inline]
 __x64_sys_setsockopt+0x13f/0x1b0 net/socket.c:2388
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f499fb8eec9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffecf309e88 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
RAX: ffffffffffffffda RBX: 00007f499fde5fa0 RCX: 00007f499fb8eec9
RDX: 0000000000000005 RSI: 000000000000011a RDI: 0000000000000003
RBP: 00007f499fc11f91 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f499fde5fa0 R14: 00007f499fde5fa0 R15: 0000000000000005
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:do_tls_setsockopt_tx_payload_len net/tls/tls_main.c:847 [inline]
RIP: 0010:do_tls_setsockopt net/tls/tls_main.c:887 [inline]
RIP: 0010:tls_setsockopt+0x189/0x1590 net/tls/tls_main.c:906
Code: ff df 80 3c 08 00 74 08 4c 89 ff e8 51 67 3c f8 41 bc 18 01 00 00 4d =
03 27 4c 89 e0 48 c1 e8 03 49 bf 00 00 00 00 00 fc ff df <42> 80 3c 38 00 7=
4 08 4c 89 e7 e8 28 67 3c f8 49 83 3c 24 00 0f 84
RSP: 0018:ffffc90003e57cc0 EFLAGS: 00010202
RAX: 0000000000000023 RBX: ffff88816adfcc00 RCX: dffffc0000000000
RDX: 0000000000000006 RSI: ffffffff8d7e872a RDI: ffffffff8bc074e0
RBP: ffffc90003e57e38 R08: ffffffff8f9e0f77 R09: 1ffffffff1f3c1ee
R10: dffffc0000000000 R11: fffffbfff1f3c1ef R12: 0000000000000118
R13: 1ffff920007cafa4 R14: ffff88816b33bde8 R15: dffffc0000000000
FS:  00005555585b2500(0000) GS:ffff8882a9d0f000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000000180 CR3: 000000010739e000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	df 80 3c 08 00 74    	filds  0x7400083c(%rax)
   6:	08 4c 89 ff          	or     %cl,-0x1(%rcx,%rcx,4)
   a:	e8 51 67 3c f8       	call   0xf83c6760
   f:	41 bc 18 01 00 00    	mov    $0x118,%r12d
  15:	4d 03 27             	add    (%r15),%r12
  18:	4c 89 e0             	mov    %r12,%rax
  1b:	48 c1 e8 03          	shr    $0x3,%rax
  1f:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
  26:	fc ff df
* 29:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruct=
ion
  2e:	74 08                	je     0x38
  30:	4c 89 e7             	mov    %r12,%rdi
  33:	e8 28 67 3c f8       	call   0xf83c6760
  38:	49 83 3c 24 00       	cmpq   $0x0,(%r12)
  3d:	0f                   	.byte 0xf
  3e:	84                   	.byte 0x84


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[corbet@lwn.net davem@davemloft.net edumazet@google.com horms@kernel.org jo=
hn.fastabend@gmail.com kuba@kernel.org linux-doc@vger.kernel.org linux-kern=
el@vger.kernel.org linux-kselftest@vger.kernel.org netdev@vger.kernel.org p=
abeni@redhat.com sd@queasysnail.net shuah@kernel.org wilfred.mallawa@wdc.co=
m wilfred.opensource@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

