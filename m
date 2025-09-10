Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF4E12D130C
	for <syzbot@lists.linux.dev>; Wed, 10 Sep 2025 18:54:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757530494; cv=none; b=qjM94nAiE4sUfuEqO0PkpWsDQFYobSNLpAHhbUWmYVUmGYk5EX1BRBhrVfwJOTDG7lDxcpmdoR2aw9OeZcHgwS8uECU7ihMWO8dIYXvnRjtitTcXtLObZt8paBNxfCx9U7/m25E2norZEeBhOC/omyGStXlk/D/C/ecXudIgg1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757530494; c=relaxed/simple;
	bh=vRXB5tpEDMsg5ceUTz5mX2U3C58DRcdgBBUjk1m/NlY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Ua8zYuGxqTiaTPbdfuPNeQ8SDw9JixYeB7LzWLctmW5PkGlb5eyDmI76lJO3eD/L1RsZnMaaFnL03mFSraU7xyDrcl6mcPcfrOm163JJB+H4uGkOG/jgNAR0UzrrEr9ZKatJdL3LTsgxXTKANxUgmg6I8GOKlcVF3aq+mgF4RfM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-8875e3b715bso1640581039f.3
        for <syzbot@lists.linux.dev>; Wed, 10 Sep 2025 11:54:51 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757530491; x=1758135291;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=5ccAROfdedFCSLEy1hOCU1qYvuGq/52JXXwhv9vM/5M=;
        b=lh9aTC6cEC4COFCtPe7hxF7UWLa2y/Yw2Fpr9BurBrNuCyRU3JBieHX3lE+vxuEalP
         pTE3mojt4xMuaG9m/0rVG4c02I2aRLpRwi8r9zeEm4DmOyHSAcmqK1hKOSL3K/c1Gvzh
         yLPzEY4NJiKrN4QIYfK1pe42lVXnhdBTew2ekDq7YNrXbnGgaTKbdbCHtvshlM74KYRj
         r2Vk08rPVtk97TFSyG4b5XIuoyMD/Jul0VWRIT6pvQMlRmIAHtRa1Jz6Y5uQd1Iml0kT
         4hMdMoBEtnAfBLEw0rQbzhJvwea3j1atm0CluXv9o4EBthmJEVJ+WJnP3qNzVd1u6y3+
         oC/w==
X-Gm-Message-State: AOJu0YzBesn9WKgXA6aaGlKXoGdrfVyDO0rO/4RohC/nZb1lx3vdbbyc
	OicPQQ9//C5XC/meXTiNEgQOtJFbxzYQQkoTiIryU0txOuBKfrlGFFbeEFmSopR+4/7VhujjrTu
	Wc/CE1Zm8Zit9rpHeacVInQ/zGClIZLGUo4E4ZOJ5Xxly/2r2ooQelOrzZJ0=
X-Google-Smtp-Source: AGHT+IFDVpjSZjaLUGtPptdu4cJk38hJeSSKWSmaWSKLcBA7fpw1JoEvDBcnjGObWakRAfDgOid0+NGcY8Ok0a6A22QE1ZbpIMin
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12ca:b0:405:431e:508e with SMTP id
 e9e14a558f8ab-405431e514fmr201947545ab.31.1757530491010; Wed, 10 Sep 2025
 11:54:51 -0700 (PDT)
Date: Wed, 10 Sep 2025 11:54:50 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c1c97a.050a0220.3c6139.0028.GAE@google.com>
Subject: [moderation/CI] Re: ns: support file handles
From: syzbot ci <syzbot+cif2f740615df66e76@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] ns: support file handles
https://lore.kernel.org/all/20250910-work-namespace-v1-0-4dd56e7359d8@kerne=
l.org
* [PATCH 01/32] pidfs: validate extensible ioctls
* [PATCH 02/32] nsfs: validate extensible ioctls
* [PATCH 03/32] block: use extensible_ioctl_valid()
* [PATCH 04/32] ns: move to_ns_common() to ns_common.h
* [PATCH 05/32] nsfs: add nsfs.h header
* [PATCH 06/32] ns: uniformly initialize ns_common
* [PATCH 07/32] mnt: use ns_common_init()
* [PATCH 08/32] ipc: use ns_common_init()
* [PATCH 09/32] cgroup: use ns_common_init()
* [PATCH 10/32] pid: use ns_common_init()
* [PATCH 11/32] time: use ns_common_init()
* [PATCH 12/32] uts: use ns_common_init()
* [PATCH 13/32] user: use ns_common_init()
* [PATCH 14/32] net: use ns_common_init()
* [PATCH 15/32] ns: remove ns_alloc_inum()
* [PATCH 16/32] nstree: make iterator generic
* [PATCH 17/32] mnt: support iterator
* [PATCH 18/32] cgroup: support iterator
* [PATCH 19/32] ipc: support iterator
* [PATCH 20/32] net: support iterator
* [PATCH 21/32] pid: support iterator
* [PATCH 22/32] time: support iterator
* [PATCH 23/32] userns: support iterator
* [PATCH 24/32] uts: support iterator
* [PATCH 25/32] ns: add to_<type>_ns() to respective headers
* [PATCH 26/32] nsfs: add current_in_namespace()
* [PATCH 27/32] nsfs: support file handles
* [PATCH 28/32] nsfs: support exhaustive file handles
* [PATCH 29/32] nsfs: add missing id retrieval support
* [PATCH 30/32] tools: update nsfs.h uapi header
* [PATCH 31/32] selftests/namespaces: add identifier selftests
* [PATCH 32/32] selftests/namespaces: add file handle selftests

and found the following issue:
WARNING in copy_net_ns

Full report is available here:
https://ci.syzbot.org/series/bc3dfd83-98cc-488c-b046-f849c79a6a41

***

WARNING in copy_net_ns

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      deb105f49879dd50d595f7f55207d6e74dec34e6
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/a560fd28-b788-4442-a7c8-10c6240b4db=
f/config
syz repro: https://ci.syzbot.org/findings/18e91b10-567e-4cae-a279-8a5f2f2cd=
e80/syz_repro

------------[ cut here ]------------
ida_free called for id=3D1326 which is not allocated.
WARNING: CPU: 0 PID: 6146 at lib/idr.c:592 ida_free+0x280/0x310 lib/idr.c:5=
92
Modules linked in:
CPU: 0 UID: 0 PID: 6146 Comm: syz.1.60 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:ida_free+0x280/0x310 lib/idr.c:592
Code: 00 00 00 00 fc ff df 48 8b 5c 24 10 48 8b 7c 24 40 48 89 de e8 d1 8a =
0c 00 90 48 c7 c7 80 ee ba 8c 44 89 fe e8 11 87 12 f6 90 <0f> 0b 90 90 eb 3=
4 e8 95 02 4f f6 49 bd 00 00 00 00 00 fc ff df eb
RSP: 0018:ffffc9000302fba0 EFLAGS: 00010246
RAX: c838d58ce4bb0000 RBX: 0000000000000a06 RCX: ffff88801eac0000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
RBP: ffffc9000302fca0 R08: ffff88804b024293 R09: 1ffff11009604852
R10: dffffc0000000000 R11: ffffed1009604853 R12: 1ffff92000605f78
R13: dffffc0000000000 R14: ffff888026c1fd00 R15: 000000000000052e
FS:  00007f6d7aab16c0(0000) GS:ffff8880b8613000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000004000 CR3: 000000002726e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 copy_net_ns+0x37a/0x510 net/core/net_namespace.c:593
 create_new_namespaces+0x3f3/0x720 kernel/nsproxy.c:110
 unshare_nsproxy_namespaces+0x11c/0x170 kernel/nsproxy.c:218
 ksys_unshare+0x4c8/0x8c0 kernel/fork.c:3127
 __do_sys_unshare kernel/fork.c:3198 [inline]
 __se_sys_unshare kernel/fork.c:3196 [inline]
 __x64_sys_unshare+0x38/0x50 kernel/fork.c:3196
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f6d79b8eba9
Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f6d7aab1038 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 00007f6d79dd5fa0 RCX: 00007f6d79b8eba9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000062040200
RBP: 00007f6d79c11e19 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f6d79dd6038 R14: 00007f6d79dd5fa0 R15: 00007ffd5ab830f8
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[amir73il@gmail.com axboe@kernel.dk brauner@kernel.org cgroups@vger.kernel.=
org chuck.lever@oracle.com cyphar@cyphar.com daan.j.demeyer@gmail.com eduma=
zet@google.com hannes@cmpxchg.org horms@kernel.org jack@suse.cz jlayton@ker=
nel.org josef@toxicpanda.com kuba@kernel.org linux-block@vger.kernel.org li=
nux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org linux-kselftest@vg=
er.kernel.org linux-nfs@vger.kernel.org me@yhndnzj.com mkoutny@suse.com mzx=
reary@0pointer.de netdev@vger.kernel.org pabeni@redhat.com tj@kernel.org vi=
ro@zeniv.linux.org.uk zbyszek@in.waw.pl]

If the report looks fine to you, reply with:
#syz upstream

