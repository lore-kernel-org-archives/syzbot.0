Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D6FF2737F2
	for <syzbot@lists.linux.dev>; Tue, 21 Oct 2025 14:28:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761056896; cv=none; b=QKj/At3PSmkOkRX7WaJmtzVv+k/ZyYJqaKYQ4wkX3HQBtgZ9MdPNwdOESwADHGf5JCeqcq5pTwEzCws81167jpBPwwTT6HL7A7Go1MUpLQtGndtAV5V6yPU3x/tyLeR7jy4RiIQnRWpsD4FTmD9Q/w7REGxbp2M01Q1q2SlNGk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761056896; c=relaxed/simple;
	bh=wyjhotQXDSVBm+EaxDOg9iM35xpi9m+VcJELsAisuKU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=cfQUf3GCinOseFibExchLE2JPMC/4/bEwpoyOe2FrQIkLTaUdLc0z+x2XpCcyoFwJ/+NmAXUa/A3z7+mDWrJTd7VjxQBcz4ysL1KzaWXXl1AvwM/hzP7d+wY3muEX6T2u4kcuzEZcbpx5uiFmyIgpiajN1XAyIY0Qcv1EYDk798=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-430c3232caeso56791465ab.3
        for <syzbot@lists.linux.dev>; Tue, 21 Oct 2025 07:28:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761056893; x=1761661693;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=W0Uy9CgY3S72y4yOYMVdB3L4KBJ8SIIZ8q5a3ac97rE=;
        b=DiGkRxdaBrMLCxFpUqmLuQD07XMRbzV3hxRbMNIysMgFaSXaJRPuoQaRQz1ejScbnr
         nqte+3ivDvKTmLyW20Uun0YsvtJ9O6x6pJmiVlLPzZV8zT5vu8XXvUHOdUi4eG+VMhSM
         jVwlxAYjWF+edKoC665bimejk1/n0HVsuGOMrmCgbpED4ucmXpCO/qTU8m9wkoVtw1tO
         DTfMwjfBQopFmRdt+G8poq2klhqudUaY3XLkOypx3c/uB3skOWT4DbugPdRgWox97TYJ
         fWx6eouKM6hQRBlnT2d2mK+0+zMnFdy+T6Hx6jftJmhIviH9ZxDfvVV12PfIckKfsSzk
         Kq9A==
X-Gm-Message-State: AOJu0YzZX+iFYCowjv06TN/UFlu7ATPNMGjkG1OWhsuhp87wAXdEAhol
	8mNqMUC2X/8HVZHI4rSnAzXULE5lkvlWZrv4jGkxy6Lb56OPEwR/ZOKUfJKgRj294917HEJvCDP
	22fuZKIeRURiwPh6DCCNJOe6Csa5oDp/D2zCzopM57qz2lpcnhkupp+5LkUU=
X-Google-Smtp-Source: AGHT+IGhbpDKnu0wT5uqOicomjvRrwudPKws8/R/y5dlyXVrFHVX7r522k9/+0lPcuYcny64K8eQjsZ0lL05h4RrF9uECyV9Uu/a
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:cd83:0:b0:430:ae8b:d2d8 with SMTP id
 e9e14a558f8ab-430c526926cmr255393685ab.15.1761056893232; Tue, 21 Oct 2025
 07:28:13 -0700 (PDT)
Date: Tue, 21 Oct 2025 07:28:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f7987d.050a0220.346f24.001e.GAE@google.com>
Subject: [moderation/CI] Re: nstree: listns()
From: syzbot ci <syzbot+ci63c7f78281919a7f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] nstree: listns()
https://lore.kernel.org/all/20251021-work-namespace-nstree-listns-v1-0-ad44=
261a8a5b@kernel.org
* [PATCH RFC DRAFT 01/50] libfs: allow to specify s_d_flags
* [PATCH RFC DRAFT 02/50] nsfs: use inode_just_drop()
* [PATCH RFC DRAFT 03/50] nsfs: raise DCACHE_DONTCACHE explicitly
* [PATCH RFC DRAFT 04/50] pidfs: raise DCACHE_DONTCACHE explicitly
* [PATCH RFC DRAFT 05/50] nsfs: raise SB_I_NODEV and SB_I_NOEXEC
* [PATCH RFC DRAFT 06/50] nstree: simplify return
* [PATCH RFC DRAFT 07/50] ns: initialize ns_list_node for initial namespace=
s
* [PATCH RFC DRAFT 08/50] ns: add __ns_ref_read()
* [PATCH RFC DRAFT 09/50] ns: add active reference count
* [PATCH RFC DRAFT 10/50] ns: use anonymous struct to group list member
* [PATCH RFC DRAFT 11/50] nstree: introduce a unified tree
* [PATCH RFC DRAFT 12/50] nstree: allow lookup solely based on inode
* [PATCH RFC DRAFT 13/50] nstree: assign fixed ids to the initial namespace=
s
* [PATCH RFC DRAFT 14/50] ns: maintain list of owned namespaces
* [PATCH RFC DRAFT 15/50] nstree: add listns()
* [PATCH RFC DRAFT 16/50] arch: hookup listns() system call
* [PATCH RFC DRAFT 17/50] nsfs: update tools header
* [PATCH RFC DRAFT 18/50] selftests/filesystems: remove CLONE_NEWPIDNS from=
 setup_userns() helper
* [PATCH RFC DRAFT 19/50] selftests/namespaces: first active reference coun=
t tests
* [PATCH RFC DRAFT 20/50] selftests/namespaces: second active reference cou=
nt tests
* [PATCH RFC DRAFT 21/50] selftests/namespaces: third active reference coun=
t tests
* [PATCH RFC DRAFT 22/50] selftests/namespaces: fourth active reference cou=
nt tests
* [PATCH RFC DRAFT 23/50] selftests/namespaces: fifth active reference coun=
t tests
* [PATCH RFC DRAFT 24/50] selftests/namespaces: sixth active reference coun=
t tests
* [PATCH RFC DRAFT 25/50] selftests/namespaces: seventh active reference co=
unt tests
* [PATCH RFC DRAFT 26/50] selftests/namespaces: eigth active reference coun=
t tests
* [PATCH RFC DRAFT 27/50] selftests/namespaces: ninth active reference coun=
t tests
* [PATCH RFC DRAFT 28/50] selftests/namespaces: tenth active reference coun=
t tests
* [PATCH RFC DRAFT 29/50] selftests/namespaces: eleventh active reference c=
ount tests
* [PATCH RFC DRAFT 30/50] selftests/namespaces: twelth active reference cou=
nt tests
* [PATCH RFC DRAFT 31/50] selftests/namespaces: thirteenth active reference=
 count tests
* [PATCH RFC DRAFT 32/50] selftests/namespaces: fourteenth active reference=
 count tests
* [PATCH RFC DRAFT 33/50] selftests/namespaces: fifteenth active reference =
count tests
* [PATCH RFC DRAFT 34/50] selftests/namespaces: add listns() wrapper
* [PATCH RFC DRAFT 35/50] selftests/namespaces: first listns() test
* [PATCH RFC DRAFT 36/50] selftests/namespaces: second listns() test
* [PATCH RFC DRAFT 37/50] selftests/namespaces: third listns() test
* [PATCH RFC DRAFT 38/50] selftests/namespaces: fourth listns() test
* [PATCH RFC DRAFT 39/50] selftests/namespaces: fifth listns() test
* [PATCH RFC DRAFT 40/50] selftests/namespaces: sixth listns() test
* [PATCH RFC DRAFT 41/50] selftests/namespaces: seventh listns() test
* [PATCH RFC DRAFT 42/50] selftests/namespaces: ninth listns() test
* [PATCH RFC DRAFT 43/50] selftests/namespaces: ninth listns() test
* [PATCH RFC DRAFT 44/50] selftests/namespaces: first listns() permission t=
est
* [PATCH RFC DRAFT 45/50] selftests/namespaces: second listns() permission =
test
* [PATCH RFC DRAFT 46/50] selftests/namespaces: third listns() permission t=
est
* [PATCH RFC DRAFT 47/50] selftests/namespaces: fourth listns() permission =
test
* [PATCH RFC DRAFT 48/50] selftests/namespaces: fifth listns() permission t=
est
* [PATCH RFC DRAFT 49/50] selftests/namespaces: sixth listns() permission t=
est
* [PATCH RFC DRAFT 50/50] selftests/namespaces: seventh listns() permission=
 test

and found the following issue:
WARNING in __ns_tree_add_raw

Full report is available here:
https://ci.syzbot.org/series/03ca38c3-876c-4231-aa06-ddb0bc8a30ad

***

WARNING in __ns_tree_add_raw

tree:      bpf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf=
.git
base:      5fb750e8a9ae123b2034771b864b8a21dbef65cd
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/156cf21b-68f9-423c-807a-3dd094e6aed=
8/config

------------[ cut here ]------------
WARNING: CPU: 1 PID: 5816 at kernel/nstree.c:189 __ns_tree_add_raw+0xa92/0x=
b30
Modules linked in:
CPU: 1 UID: 0 PID: 5816 Comm: syz-executor Not tainted syzkaller #0 PREEMPT=
(full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__ns_tree_add_raw+0xa92/0xb30
Code: 32 00 90 0f 0b 90 42 80 3c 23 00 0f 85 1e fc ff ff e9 21 fc ff ff e8 =
ed 78 32 00 90 0f 0b 90 e9 66 fc ff ff e8 df 78 32 00 90 <0f> 0b 90 e9 53 f=
f ff ff 44 89 f9 80 e1 07 80 c1 03 38 c1 0f 8c ef
RSP: 0018:ffffc90003f27c30 EFLAGS: 00010293
RAX: ffffffff818e0051 RBX: 1ffffffff16db871 RCX: ffff88810ffe0000
RDX: 0000000000000000 RSI: ffff8881bbf5e9a8 RDI: ffff88816d0e6e00
RBP: ffff88816d0e6e00 R08: ffff88816d0e6e3f R09: 0000000000000000
R10: ffff88816d0e6e30 R11: ffffffff81b988c0 R12: dffffc0000000000
R13: ffff88816d0e6e40 R14: ffffffff8b6dc388 R15: ffff8881bbf5e9a8
FS:  000055558630f500(0000) GS:ffff8882a9d04000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f5c3f03529c CR3: 000000010b5bc000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 copy_cgroup_ns+0x373/0x5f0
 create_new_namespaces+0x358/0x720
 unshare_nsproxy_namespaces+0x11c/0x170
 ksys_unshare+0x4c8/0x8c0
 __x64_sys_unshare+0x38/0x50
 do_syscall_64+0xfa/0xfa0
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5c3ef907c7
Code: 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f =
1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffc62c39c88 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
RAX: ffffffffffffffda RBX: 00007ffc62c39c90 RCX: 00007f5c3ef907c7
RDX: 0000000000000000 RSI: 00007f5c3f03529c RDI: 0000000002000000
RBP: 00007ffc62c39d20 R08: 0000000000000000 R09: 00007f5c3fd1d6c0
R10: 0000000000044000 R11: 0000000000000246 R12: 00007ffc62c39d20
R13: 00007ffc62c39d28 R14: 0000000000000009 R15: 0000000000000000
 </TASK>


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[amir73il@gmail.com arnd@arndb.de bpf@vger.kernel.org brauner@kernel.org cg=
roups@vger.kernel.org cyphar@cyphar.com daan.j.demeyer@gmail.com edumazet@g=
oogle.com hannes@cmpxchg.org jack@suse.cz jannh@google.com jlayton@kernel.o=
rg josef@toxicpanda.com kuba@kernel.org linux-fsdevel@vger.kernel.org linux=
-kernel@vger.kernel.org me@yhndnzj.com mzxreary@0pointer.de netdev@vger.ker=
nel.org tglx@linutronix.de tj@kernel.org viro@zeniv.linux.org.uk zbyszek@in=
.waw.pl]

If the report looks fine to you, reply with:
#syz upstream

