Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C44728850B
	for <syzbot@lists.linux.dev>; Thu, 29 Jan 2026 12:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769690133; cv=none; b=VzK8tG1BtYh/BNzXpufPk9ZMsjZKYanej3+mPgYdq97G1CzPzHn3YmONC1HJlLXyoMjtZ7mIMVhtZA5DwGKKncGXJzOXDGmICe0gyzfMo7wxEElUZChWxbLsIkDvD2fgqF39hznV9nKQighS5/cUBEx1CCBLQhwcWN6A6LjuXeU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769690133; c=relaxed/simple;
	bh=xfEmrFz8T6pkRFvgSBZh3SBoVdlcOji5lA5LDzwMmAc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=cvWsxZKDKFA5V53AdNy9l1g6fThHwTtz4AxNoUSsMG27/NzvwvSOrbW/LICTLfM6lGQ3KY8vbGMLWpt1jk+UM2p1h3QL/u9HrckYpR02z7qHtEAdA1tCLdn9AjwYa7zwfobnfPkTCRwJQv/dBwjjLOcU7CMpVMSR+JNRAVa096I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-402d5d2706fso1258013fac.3
        for <syzbot@lists.linux.dev>; Thu, 29 Jan 2026 04:35:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769690131; x=1770294931;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=2eKTjZuHYBH13uKO+TY3Em3zWx1kaW0lRCy50D6Ydoo=;
        b=dRIVrQZ8QyDj29lPPzVD7QPOpSbM42Vyc5wQpP2hR6WSJYF3pwNzyCkjCtOfU0r9lP
         fM7t2uruI1HhIKDm9+OJi8xZuREhrVmizCLNQze286hY5OKpI5QRJEOUB1KKoVxYI2qc
         M/WofuxtVJQoSQ+YwYSMYeukdarlJDb1DbELl3UmFiROD36gIjINugecG09divxV8Dg2
         C1Jss/jQQRazLfAAzhoVGwFe4/mYw1HO30NKhnlA4JuboDY+7bzNXxZObbCzI8+84Isv
         THbsrIHWa5Lh+zJd54qFjiZQgq3IX4V1KMDuhiJMF6L58VBAQ4nXgiwmkMDH8RNLNwvs
         wRGQ==
X-Gm-Message-State: AOJu0Ywa1Doy18BRUbbYmlNoyiZalW+VSkohLN5O0qSOUUgr9x/6jVk+
	/ui2eJSwfmYFyWRddMmbtqQfflpUG/4RKLBFO3pIZaI8TR1Lyul19sCCrVwgRN9ewcY0T78yEe+
	m8E3GqurxsvCNTt5Y4U7caW2QG3PW4zhCKVXiJ2UXWLlWSf4HSe9PhRdt3fA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1609:b0:65c:469d:33d9 with SMTP id
 006d021491bc7-662f20e406amr4966163eaf.69.1769690131070; Thu, 29 Jan 2026
 04:35:31 -0800 (PST)
Date: Thu, 29 Jan 2026 04:35:31 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <697b5413.a00a0220.35f26.0008.GAE@google.com>
Subject: [moderation/CI] Re: virtio-net: add flow filter for receive timestamps
From: syzbot ci <syzbot+ci6ec41e9f54857adc@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] virtio-net: add flow filter for receive timestamps
https://lore.kernel.org/all/20260129-v6-7-topic-virtio-net-ptp-v2-0-30a27dc=
52760@pengutronix.de
* [PATCH RFC v2 1/2] tun: support rx-tstamp
* [PATCH RFC v2 2/2] virtio-net: support receive timestamp

and found the following issue:
WARNING in __copy_overflow

Full report is available here:
https://ci.syzbot.org/series/0b35c8c9-603b-4126-ac04-0095faadb2f5

***

WARNING in __copy_overflow

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      ffeafa65b2b26df2f5b5a6118d3174f17bd12ec5
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/d8316da2-2688-4d74-bbf4-e8412e24d10=
6/config
C repro:   https://ci.syzbot.org/findings/96af937a-787b-4fd5-baef-529fc80e0=
bb7/c_repro
syz repro: https://ci.syzbot.org/findings/96af937a-787b-4fd5-baef-529fc80e0=
bb7/syz_repro

------------[ cut here ]------------
Buffer overflow detected (32 < 1840)!
WARNING: mm/maccess.c:234 at __copy_overflow+0x17/0x30 mm/maccess.c:234, CP=
U#0: syz.0.17/5993
Modules linked in:
CPU: 0 UID: 0 PID: 5993 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__copy_overflow+0x1c/0x30 mm/maccess.c:234
Code: 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 53 48 89 f3 =
89 fd e8 60 b1 c4 ff 48 8d 3d 39 25 d5 0d 89 ee 48 89 da <67> 48 0f b9 3a 5=
b 5d c3 cc cc cc cc cc cc cc cc cc cc cc cc 90 90
RSP: 0018:ffffc90003b97888 EFLAGS: 00010293
RAX: ffffffff81fdcf50 RBX: 0000000000000730 RCX: ffff88810ccd9d40
RDX: 0000000000000730 RSI: 0000000000000020 RDI: ffffffff8fd2f490
RBP: 0000000000000020 R08: ffffffff8fcec777 R09: 1ffffffff1f9d8ee
R10: dffffc0000000000 R11: ffffffff81742230 R12: dffffc0000000000
R13: 0000000000000000 R14: 0000000000000730 R15: 1ffff92000772f30
FS:  00007f08c446a6c0(0000) GS:ffff88818e32d000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f08c4448ff8 CR3: 000000010cec2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 copy_overflow include/linux/ucopysize.h:41 [inline]
 check_copy_size include/linux/ucopysize.h:50 [inline]
 copy_to_iter include/linux/uio.h:219 [inline]
 tun_put_user drivers/net/tun.c:2089 [inline]
 tun_do_read+0x1f44/0x28a0 drivers/net/tun.c:2190
 tun_chr_read_iter+0x13b/0x260 drivers/net/tun.c:2214
 do_iter_readv_writev+0x619/0x8c0 fs/read_write.c:-1
 vfs_readv+0x288/0x840 fs/read_write.c:1018
 do_readv+0x154/0x2e0 fs/read_write.c:1080
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f08c359acb9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f08c446a028 EFLAGS: 00000246 ORIG_RAX: 0000000000000013
RAX: ffffffffffffffda RBX: 00007f08c3815fa0 RCX: 00007f08c359acb9
RDX: 0000000000000002 RSI: 0000200000000080 RDI: 0000000000000003
RBP: 00007f08c3608bf7 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f08c3816038 R14: 00007f08c3815fa0 R15: 00007fff6491da78
 </TASK>
----------------
Code disassembly (best guess):
   0:	90                   	nop
   1:	90                   	nop
   2:	90                   	nop
   3:	90                   	nop
   4:	90                   	nop
   5:	90                   	nop
   6:	90                   	nop
   7:	90                   	nop
   8:	90                   	nop
   9:	90                   	nop
   a:	90                   	nop
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	f3 0f 1e fa          	endbr64
  12:	55                   	push   %rbp
  13:	53                   	push   %rbx
  14:	48 89 f3             	mov    %rsi,%rbx
  17:	89 fd                	mov    %edi,%ebp
  19:	e8 60 b1 c4 ff       	call   0xffc4b17e
  1e:	48 8d 3d 39 25 d5 0d 	lea    0xdd52539(%rip),%rdi        # 0xdd5255e
  25:	89 ee                	mov    %ebp,%esi
  27:	48 89 da             	mov    %rbx,%rdx
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	5b                   	pop    %rbx
  30:	5d                   	pop    %rbp
  31:	c3                   	ret
  32:	cc                   	int3
  33:	cc                   	int3
  34:	cc                   	int3
  35:	cc                   	int3
  36:	cc                   	int3
  37:	cc                   	int3
  38:	cc                   	int3
  39:	cc                   	int3
  3a:	cc                   	int3
  3b:	cc                   	int3
  3c:	cc                   	int3
  3d:	cc                   	int3
  3e:	90                   	nop
  3f:	90                   	nop


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch davem@davemloft.net edumazet@google.com eperezma@redhat.com=
 jasowang@redhat.com kuba@kernel.org linux-kernel@vger.kernel.org mst@redha=
t.com netdev@vger.kernel.org pabeni@redhat.com richardcochran@gmail.com s.t=
rumtrar@pengutronix.de virtualization@lists.linux.dev willemdebruijn.kernel=
@gmail.com xuanzhuo@linux.alibaba.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

