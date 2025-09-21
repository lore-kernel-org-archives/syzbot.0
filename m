Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0B9611853
	for <syzbot@lists.linux.dev>; Sun, 21 Sep 2025 00:10:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758413430; cv=none; b=OWHw1HhavFvgsVNrkJ5FtguOv9UwzRkCx3osdM3HmczNGlIxW9UZUVeJ2kyPaedp83vsENDq2JgYSjg9C7lYixY1Z9EEFhPnDINt5KU0xSv1j0LmkL1IrdTmrzsSMtXfk47WyfY6WC3gXSVGmYniz2ikYHHLnW/bxMuApbzd+TM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758413430; c=relaxed/simple;
	bh=Xt1ohORpCZxclosfFfylWUtr3fT4Q2SeHeh05nutfBs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=t96H6omR7BYDUYXSnDQ3v0qTQrtOBqfKxVDxOr8w6D2C4pFJ5O+7HbxswFMU4oA6J4FkFmsjWKBUhNxAWm1jSeDk9f9zEEALqkSmFLG8xHKLSM1UhYQTztJ07qnEfCU4A31VE/kTcn1sOyu4Oa/VmhySnDBG688GC1l+i1QhXMA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4241c41110eso74244455ab.1
        for <syzbot@lists.linux.dev>; Sat, 20 Sep 2025 17:10:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758413428; x=1759018228;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=U3yVIev/zKpSNT2GvJAK/+N+dCMMf8duC2ESCKDgNE0=;
        b=l8w1BN+vMhGIi42OJh8tn6XLgTCQUKRN/OC0CUdKg6MDcHzjP9Src2hBOJyzDpZB5P
         PBRHVsJ40Cc+PkmZ29hI86l5qdPPhJ6kENXU8Ko7ECvqhVVwW2YoxL4m4hGslqZRCwZd
         +1N+gIgHZpIV/BZNNZor+srUMNlvcZl3b82QGiOxfYltRawrj2ZCo3Zc3s6kAGht43kV
         pcYcD5Rf3oQgpIh0DmsDsrVRBuaqfoW9Cq9gzOyp/5BczhOIyFhWCirSA9+bYJOKzgU6
         IEdJO0HYI71D0HUquP4mwAhBvcCH5SSf/MSu+6VL7oA+stw6uZM2r2b8rZDoyvmoQfX6
         9pIg==
X-Gm-Message-State: AOJu0Yz1l2nAsJd5KJgw3qQzVV3QgrBfpIzKAnL0R2366fgPu9jKaJNB
	Atfc/ml9JkOsvi+NmGea5HRKvyEUTEA2P4IiYMbw5Rhakakklc5GCoo+RyQDSVKzMl1tykOlrBd
	8XC3dQJyHLze1x6Z9sIYFOQ8Xt3bjfQQGl53qG0xl6oONGuzmmoUZEVvoyQ4=
X-Google-Smtp-Source: AGHT+IHqtSL9TX4THYg9sFHVyTITWzh4ShqZO2TrlV2szE7t9HnzXgbtcQNbGCCAEW/diaTC+60cGnBisRhHuj4r/eOP5FLWAQQY
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:258a:b0:423:fdc4:4e35 with SMTP id
 e9e14a558f8ab-4248197e1b4mr119437575ab.24.1758413428212; Sat, 20 Sep 2025
 17:10:28 -0700 (PDT)
Date: Sat, 20 Sep 2025 17:10:28 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68cf4274.050a0220.13cd81.0025.GAE@google.com>
Subject: [moderation/CI] Re: [PATCH v2] net: skb: guard kmalloc_reserve()
 against oversized allocations
From: syzbot ci <syzbot+ci844553212b72dc63@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] [PATCH v2] net: skb: guard kmalloc_reserve() against oversized allocat=
ions
https://lore.kernel.org/all/20250920201138.402247-1-kriish.sharma2006@gmail=
.com
* [PATCH] [PATCH v2] net: skb: guard kmalloc_reserve() against oversized al=
locations

and found the following issues:
* WARNING in __alloc_skb
* WARNING in pskb_expand_head

Full report is available here:
https://ci.syzbot.org/series/3048e542-7fa8-46b3-8e97-499b35ec361d

***

WARNING in __alloc_skb

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      315f423be0d1ebe720d8fd4fa6bed68586b13d34
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/3d048fda-1178-4af7-acb5-2eb1a391f26=
b/config
C repro:   https://ci.syzbot.org/findings/64757740-d6bb-483c-8261-a190a0511=
89b/c_repro
syz repro: https://ci.syzbot.org/findings/64757740-d6bb-483c-8261-a190a0511=
89b/syz_repro

------------[ cut here ]------------
kmalloc_reserve: request size 2147480000 exceeds KMALLOC_MAX_SIZE (4194304)
WARNING: CPU: 0 PID: 5990 at net/core/skbuff.c:598 kmalloc_reserve+0x2df/0x=
2f0 net/core/skbuff.c:596
Modules linked in:
CPU: 0 UID: 0 PID: 5990 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:kmalloc_reserve+0x2df/0x2f0 net/core/skbuff.c:596
Code: ff e8 d5 4a 64 f8 c6 05 67 27 32 06 01 90 b9 00 00 40 00 48 c7 c7 a0 =
0b 94 8c 48 c7 c6 49 5a 96 8d 4c 89 ea e8 82 e7 27 f8 90 <0f> 0b 90 90 45 3=
1 e4 e9 37 ff ff ff 0f 1f 44 00 00 90 90 90 90 90
RSP: 0018:ffffc90002c3f798 EFLAGS: 00010246
RAX: 6aef4e9a5451c800 RBX: dffffc0000000001 RCX: ffff8881079a5640
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc90002c3f7e4 R08: ffff88804b024253 R09: 1ffff1100960484a
R10: dffffc0000000000 R11: ffffed100960484b R12: 000000007ffff080
R13: 000000007ffff1c0 R14: 0000000000000cc0 R15: 1ffff92000587efc
FS:  00005555874d6500(0000) GS:ffff8880b8613000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000006038 CR3: 000000010b696000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __alloc_skb+0x142/0x2d0 net/core/skbuff.c:677
 alloc_skb include/linux/skbuff.h:1377 [inline]
 sock_wmalloc+0xb2/0x130 net/core/sock.c:2798
 pppol2tp_sendmsg+0x183/0x5f0 net/l2tp/l2tp_ppp.c:275
 sock_sendmsg_nosec net/socket.c:714 [inline]
 __sock_sendmsg+0x21c/0x270 net/socket.c:729
 ____sys_sendmsg+0x52d/0x830 net/socket.c:2614
 ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2668
 __sys_sendmmsg+0x227/0x430 net/socket.c:2757
 __do_sys_sendmmsg net/socket.c:2784 [inline]
 __se_sys_sendmmsg net/socket.c:2781 [inline]
 __x64_sys_sendmmsg+0xa0/0xc0 net/socket.c:2781
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f45f258eba9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffda5a883d8 EFLAGS: 00000246 ORIG_RAX: 0000000000000133
RAX: ffffffffffffffda RBX: 00007f45f27d5fa0 RCX: 00007f45f258eba9
RDX: 04000000000001ce RSI: 0000200000005f80 RDI: 0000000000000004
RBP: 00007f45f2611e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000008040 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f45f27d5fa0 R14: 00007f45f27d5fa0 R15: 0000000000000004
 </TASK>


***

WARNING in pskb_expand_head

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      315f423be0d1ebe720d8fd4fa6bed68586b13d34
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/3d048fda-1178-4af7-acb5-2eb1a391f26=
b/config
C repro:   https://ci.syzbot.org/findings/951f3d6d-b4db-4f6e-b7e5-df8d3799b=
0ab/c_repro
syz repro: https://ci.syzbot.org/findings/951f3d6d-b4db-4f6e-b7e5-df8d3799b=
0ab/syz_repro

------------[ cut here ]------------
kmalloc_reserve: request size 4194368 exceeds KMALLOC_MAX_SIZE (4194304)
WARNING: CPU: 1 PID: 5991 at net/core/skbuff.c:598 kmalloc_reserve+0x2df/0x=
2f0 net/core/skbuff.c:596
Modules linked in:
CPU: 1 UID: 0 PID: 5991 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:kmalloc_reserve+0x2df/0x2f0 net/core/skbuff.c:596
Code: ff e8 d5 4a 64 f8 c6 05 67 27 32 06 01 90 b9 00 00 40 00 48 c7 c7 a0 =
0b 94 8c 48 c7 c6 49 5a 96 8d 4c 89 ea e8 82 e7 27 f8 90 <0f> 0b 90 90 45 3=
1 e4 e9 37 ff ff ff 0f 1f 44 00 00 90 90 90 90 90
RSP: 0018:ffffc90003b9f6d8 EFLAGS: 00010246
RAX: a130a6a821c6fc00 RBX: dffffc0000000001 RCX: ffff88802051b980
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
RBP: ffffc90003b9f794 R08: ffff888136624253 R09: 1ffff11026cc484a
R10: dffffc0000000000 R11: ffffed1026cc484b R12: 00000000003fff00
R13: 0000000000400040 R14: 0000000000000820 R15: 1ffff92000773ef2
FS:  00005555572cd500(0000) GS:ffff8881a3c13000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b30b63fff CR3: 0000000027cee000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 pskb_expand_head+0x18e/0x1150 net/core/skbuff.c:2248
 __skb_cow include/linux/skbuff.h:3847 [inline]
 skb_cow_head include/linux/skbuff.h:3881 [inline]
 __vlan_insert_inner_tag include/linux/if_vlan.h:360 [inline]
 __vlan_insert_tag include/linux/if_vlan.h:406 [inline]
 skb_vlan_push+0x30a/0x8d0 net/core/skbuff.c:6390
 ____bpf_skb_vlan_push net/core/filter.c:3209 [inline]
 bpf_skb_vlan_push+0x217/0x900 net/core/filter.c:3199
 bpf_prog_db72096d6b827dfb+0x4c/0x55
 bpf_dispatcher_nop_func include/linux/bpf.h:1335 [inline]
 __bpf_prog_run include/linux/filter.h:718 [inline]
 bpf_prog_run include/linux/filter.h:725 [inline]
 bpf_test_run+0x318/0x7b0 net/bpf/test_run.c:434
 bpf_prog_test_run_skb+0xb30/0x1560 net/bpf/test_run.c:1099
 bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4590
 __sys_bpf+0x581/0x870 kernel/bpf/syscall.c:6047
 __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
 __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
 __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7efd6458eba9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe070e5238 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
RAX: ffffffffffffffda RBX: 00007efd647d5fa0 RCX: 00007efd6458eba9
RDX: 0000000000000050 RSI: 0000200000000180 RDI: 000000000000000a
RBP: 00007efd64611e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007efd647d5fa0 R14: 00007efd647d5fa0 R15: 0000000000000003
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aleksander.lobakin@intel.com almasrymina@google.com davem@davemloft.net eb=
iggers@google.com edumazet@google.com horms@kernel.org kerneljasonxing@gmai=
l.com kriish.sharma2006@gmail.com kuba@kernel.org linux-kernel@vger.kernel.=
org martin.lau@kernel.org mhal@rbox.co netdev@vger.kernel.org pabeni@redhat=
.com skhan@linuxfoundation.org syzbot@syzkaller.appspotmail.com willemb@goo=
gle.com]

If the report looks fine to you, reply with:
#syz upstream

