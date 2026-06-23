Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E10B637DEB2
	for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 13:52:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782222743; cv=none; b=LaTrkF2qNysVlBiHKVL7KYt/hrm6qVB7bOsgNesbIRVQtJmLB3CLcgUdAJR9WoiZvMRsuPD0xC+Oq4Jhkf5F4XxyRBM/lGEUgNlt7hw/2Iai5EM+Xk1OEZGI5+JV/ZMSCjBGwoch/prjRZEXxyn5slioRBApfNpZq2zxFlvDPtQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782222743; c=relaxed/simple;
	bh=Zh/6qqqBASOYdTlSojJ/5YrG5uGl1IUSkTJW51fSr08=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=RTBdum3l7mNDFRNS5Xq9Ui++6+BpaW+cshwhvdfndFfW1nxv3jIXMtU1ZrLVs3wDjG91Zu1eucxdzsKw1PpaAUVUuX6jirBX3/HkzrHj6TwGyFWG58Ylb7dGvcc6PTkCnSDlTPdGrkRgktB5HZpgNdj9YzAK6qByQdUQfJYPUAU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-486cc29e03bso10445380b6e.3
        for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 06:52:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782222741; x=1782827541;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ox4m0ReLVyz5I7IePrlc3m31kP9IlHioa5OXk2nNpUs=;
        b=P1I2/CpevoViuggL/9ww+RAF5JULE6khVuOVc9kEz6+6Hhd0nPlCAppdCvkVzSBbrH
         Gl/eP8U7la8yE0HU1NvAKII2pFND2gCkQQyBo+wVSadAovV9HPbvQxsUZMvF7JFaaHCr
         Nngf+VRJn4L7eXB7I4XinxK1VaQT+owpVvRtz6rrI655g6Wxdnlr14wuNNqVod0llnbi
         HiYnCC+2XaYhLL57sL+Xo6kq4axjxOSS1jXVZCZAbssEdWhhrSHZ9Qva6EOX2V53Ucr6
         I351nxKjhkzu3OyKs7acRR5elgB7HqX2slj0O4Vnuadb6w/x6ERTti/353+J07XeXc2d
         X22A==
X-Gm-Message-State: AOJu0YxgtX5TngoEARb22O+NWE4fvT47QG7mJ9/rEy5BAOh+ENmqg+l8
	CrLPeqwgid1IFpS3/Vfjwcq4HWDS0rQVnzg0OVWt2Hd76uY0HuI7G8Ojz6Y/HDxW8U4wCALDEuf
	L69rnqNYjz4DlpXpwkFUoc7PHvpjeMCzOwyhomfS/Sx0m6muPFG/QgnNLM/U=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f0d:b0:48a:a85b:ba53 with SMTP id
 5614622812f47-48f62b2ad42mr1560226b6e.35.1782222741007; Tue, 23 Jun 2026
 06:52:21 -0700 (PDT)
Date: Tue, 23 Jun 2026 06:52:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3a8f94.92e8a34c.2b91f1.0001.GAE@google.com>
Subject: [moderation/CI] Re: ext4: deferred iput framework for EA inodes
From: syzbot ci <syzbot+ci2643ef58e01e325c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v9] ext4: deferred iput framework for EA inodes
https://lore.kernel.org/all/20260623085243.2816425-1-yun.zhou@windriver.com
* [PATCH v9 1/4] fs: add iput_if_not_last() helper
* [PATCH v9 2/4] ext4: introduce ext4_put_ea_inode() for safe deferred iput
* [PATCH v9 3/4] ext4: convert all EA inode iput() calls to ext4_put_ea_ino=
de()
* [PATCH v9 4/4] ext4: remove ea_inode_array mechanism in favor of ext4_put=
_ea_inode()

and found the following issue:
WARNING: ODEBUG bug in flush_delayed_work

Full report is available here:
https://ci.syzbot.org/series/cea17a2e-fd8e-4afb-9c24-3a6583692d30

***

WARNING: ODEBUG bug in flush_delayed_work

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      502d801f0ab03e4f32f9a33d203154ce84887921
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/4e0f013f-686c-4e04-bce5-aa62d168ed3=
0/config
syz repro: https://ci.syzbot.org/findings/77e91d73-1ae0-4a86-a273-955496ba2=
0ac/syz_repro

------------[ cut here ]------------
ODEBUG: assert_init not available (active state 0) object: ffff8881bd72a9e0=
 object type: timer_list hint: 0x0
WARNING: lib/debugobjects.c:632 at debug_print_object+0xec/0x230 lib/debugo=
bjects.c:629, CPU#1: syz.0.17/5825
Modules linked in:
CPU: 1 UID: 0 PID: 5825 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:debug_print_object+0x18a/0x230 lib/debugobjects.c:629
Code: f8 48 c1 e8 03 80 3c 18 00 74 08 4c 89 ff e8 5d 04 71 fd 4d 8b 0f 4c =
89 ef 48 8b 74 24 08 48 89 ea 44 89 e1 4d 89 f0 ff 34 24 <67> 48 0f b9 3a 4=
8 83 c4 08 ff 05 a3 23 70 0b 48 83 c4 10 5b 41 5c
RSP: 0018:ffffc90003d6f848 EFLAGS: 00010046
RAX: 1ffffffff179eacc RBX: dffffc0000000000 RCX: 0000000000000000
RDX: ffffffff8c2a9980 RSI: ffffffff8c2a93e0 RDI: ffffffff903ddbf0
RBP: ffffffff8c2a9980 R08: ffff8881bd72a9e0 R09: ffffffff8bcf69c0
R10: dffffc0000000000 R11: ffffffff81b25990 R12: 0000000000000000
R13: ffffffff903ddbf0 R14: ffff8881bd72a9e0 R15: ffffffff8bcf5660
FS:  00007f0ce1a886c0(0000) GS:ffff8882a922d000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000555a696f54b0 CR3: 000000016a278000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 debug_object_assert_init+0x237/0x370 lib/debugobjects.c:1075
 debug_timer_assert_init kernel/time/timer.c:803 [inline]
 debug_assert_init kernel/time/timer.c:848 [inline]
 __try_to_del_timer_sync kernel/time/timer.c:1457 [inline]
 __timer_delete_sync+0x181/0x520 kernel/time/timer.c:1621
 flush_delayed_work+0x48/0x100 kernel/workqueue.c:4414
 ext4_drain_ea_inode_work fs/ext4/xattr.h:196 [inline]
 __ext4_fill_super fs/ext4/super.c:5795 [inline]
 ext4_fill_super+0x54c7/0x66d0 fs/ext4/super.c:5844
 get_tree_bdev_flags+0x430/0x4f0 fs/super.c:1634
 vfs_get_tree+0x92/0x2a0 fs/super.c:1694
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3765 [inline]
 do_new_mount+0x319/0xdc0 fs/namespace.c:3841
 do_mount fs/namespace.c:4174 [inline]
 __do_sys_mount fs/namespace.c:4390 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4367
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0ce0b9e0ca
Code: 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8 ff ff ff ff c3 66 2e 0f 1f 84 =
00 00 00 00 00 0f 1f 40 00 49 89 ca b8 a5 00 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0ce1a87e58 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f0ce1a87ee0 RCX: 00007f0ce0b9e0ca
RDX: 0000200000000400 RSI: 0000200000000340 RDI: 00007f0ce1a87ea0
RBP: 0000200000000400 R08: 00007f0ce1a87ee0 R09: 000000000021c91c
R10: 000000000021c91c R11: 0000000000000246 R12: 0000200000000340
R13: 00007f0ce1a87ea0 R14: 000000000000051a R15: 0000200000000240
 </TASK>
----------------
Code disassembly (best guess):
   0:	f8                   	clc
   1:	48 c1 e8 03          	shr    $0x3,%rax
   5:	80 3c 18 00          	cmpb   $0x0,(%rax,%rbx,1)
   9:	74 08                	je     0x13
   b:	4c 89 ff             	mov    %r15,%rdi
   e:	e8 5d 04 71 fd       	call   0xfd710470
  13:	4d 8b 0f             	mov    (%r15),%r9
  16:	4c 89 ef             	mov    %r13,%rdi
  19:	48 8b 74 24 08       	mov    0x8(%rsp),%rsi
  1e:	48 89 ea             	mov    %rbp,%rdx
  21:	44 89 e1             	mov    %r12d,%ecx
  24:	4d 89 f0             	mov    %r14,%r8
  27:	ff 34 24             	push   (%rsp)
* 2a:	67 48 0f b9 3a       	ud1    (%edx),%rdi <-- trapping instruction
  2f:	48 83 c4 08          	add    $0x8,%rsp
  33:	ff 05 a3 23 70 0b    	incl   0xb7023a3(%rip)        # 0xb7023dc
  39:	48 83 c4 10          	add    $0x10,%rsp
  3d:	5b                   	pop    %rbx
  3e:	41 5c                	pop    %r12


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
[adilger.kernel@dilger.ca brauner@kernel.org jack@suse.cz libaokun@linux.al=
ibaba.com linux-ext4@vger.kernel.org linux-fsdevel@vger.kernel.org linux-ke=
rnel@vger.kernel.org ojaswin@linux.ibm.com ritesh.list@gmail.com tytso@mit.=
edu viro@zeniv.linux.org.uk yi.zhang@huawei.com yun.zhou@windriver.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

