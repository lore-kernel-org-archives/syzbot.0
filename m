Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0D663FE640
	for <syzbot@lists.linux.dev>; Wed, 30 Sep 2026 10:19:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790763552; cv=none; b=RdvAQYdJNrpnLwNXRlbuNsVxBRsg/exLTWr4YsoMSZrYwHXhZX/FYZu5yhsTVs43gCxnlNuDwg5FvC7Oer82WrBRw2UIz81QN1dcLP9GBcJT/VNuOTsQ+c8cVQd0E+F28xRU4/eS9MR1LNsmM0sucj+/3V5AsZtUDENpE8ZTv98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790763552; c=relaxed/simple;
	bh=MdfItNLeUJuvrklSvhq3c3NdIaAvvnowZfXYgRep4JY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=igxxejsG02iUjaQL5ClZA254cEEvbXaKCyKw51By59aFx6RMsKSAgJzVaz2IXpKW73A6T2Qc6OUlNtTCav7RE+tUfO3DGzex3NboRz50YKIEkzVHQquk33jA0W75znyPKfxv69lDxRKH3lbOdCKLXbpsy1t89yhNS0aLsElmGBs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b28dafb8e1so8885188b6e.2
        for <syzbot@lists.linux.dev>; Wed, 30 Sep 2026 03:19:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790763549; x=1791368349;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=G908gVT1SfqUHfYRUfiSaemvnGzMW+d2sGjC2M9EksY=;
        b=Cac+eoaLFF2IR4kWYXsWaLqNJygR4lOX3nSYLYVgYq1GRTjZTfUoWAZ5P1K19pMGiY
         ktAupyTNBvB8RmaLCI0NH3ZiJwrvs3S+dUzHBtpmxcTOtJBjrk/eCe5T/fomR4bGv28x
         3npEoHVXXqLbv7Dl5AUNsc2HQFUmukNU+Z7vqBTOWPBSxunZi8utNGxLSMkohvxHC5Eh
         JImd/Eyugkwoub6ufhJCcKLpvkZFttq/xs4cy4hn/tkY4h1jFy+o8DnYKEeAnZzFamwH
         p62FRTAz68N6i1V6HoQgOgcBnP2Fo1lo4sqYeBoNHJCk2pR8L2ucUxdtOH3AdOW7MMei
         mRiA==
X-Gm-Message-State: AFuF++nDmwF7PbAYMN4ms+J/7sVj/+EFLFOVatiqepH/zxKKtzLaiDLD
	Aj5/nYEQeLsEXNIgf9Kw53g89kwpj4nBEl3D6arUpcp4V7aIZMfpEUj4P6OD8YCT0G4Owq3o9LO
	TYi1tZDivukLDMbgifTr0pa95kFpzxnqJTrpDOD+Pie20WdpMU4l62tgPaC4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:14d1:b0:4b2:98a3:a567 with SMTP id
 5614622812f47-4f1b0d0ce9emr984072b6e.4.1790763549530; Wed, 30 Sep 2026
 03:19:09 -0700 (PDT)
Date: Wed, 30 Sep 2026 03:19:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6abce21d.80e1c6cc.22483f.0000.GAE@google.com>
Subject: [moderation/CI] Re: multiple-filesystems: prepare for changes to VFS locking
From: syzbot ci <syzbot+cie5f097f0663789ec@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] multiple-filesystems: prepare for changes to VFS locking
https://lore.kernel.org/all/20260929034158.1455429-1-neilb@ownmail.net
* [PATCH 1/7] VFS/xfs/ntfs: drop parent lock across d_alloc_parallel() in d=
_add_ci()
* [PATCH 2/7] shmem: use d_duplicate()
* [PATCH 3/7] coda: don't d_drop() early.
* [PATCH 4/7] configfs: remove d_add() calls before configfs_attach_group()
* [PATCH 5/7] hostfs: don't d_drop() before d_splice_alias() in hostfs_mkdi=
r()
* [PATCH 6/7] procfs: drop parent lock for d_alloc_parallel() in iterate_sh=
ared()
* [PATCH 7/7] ovl: stop using lookup_one() in ovl_iterate().

and found the following issue:
WARNING in __d_instantiate

Full report is available here:
https://ci.syzbot.org/series/b87296ff-c49f-416e-834c-a886ea8bd6c3

***

WARNING in __d_instantiate

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      3879f51857325da9bf3cfb073280257cd16ae067
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/dd8fcfa5-13f0-458f-bd3b-9c06d4d67a7=
8/config
syz repro: https://ci.syzbot.org/findings/fdffe42d-ac1a-40d9-b05c-014808f5b=
0ec/syz_repro

------------[ cut here ]------------
d_in_lookup(dentry)
WARNING: fs/dcache.c:2197 at __d_instantiate+0x3f4/0x700 fs/dcache.c:2197, =
CPU#1: syz.0.17/5823
Modules linked in:
CPU: 1 UID: 0 PID: 5823 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(ful=
l)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
RIP: 0010:__d_instantiate+0x3f4/0x700 fs/dcache.c:2197
Code: 03 41 80 f6 01 41 0f b6 ce c1 e1 0d 09 c1 89 0b 48 83 c4 10 5b 41 5c =
41 5d 41 5e 41 5f 5d e9 03 26 96 09 cc e8 0d 84 75 ff 90 <0f> 0b 90 e9 7f f=
d ff ff e8 ff 83 75 ff 41 81 cc 00 00 01 00 e9 34
RSP: 0018:ffffc900038d73a0 EFLAGS: 00010293
RAX: ffffffff825242a3 RBX: ffff8881b4eef380 RCX: ffff888169801e00
RDX: 0000000000000000 RSI: 0000000001000000 RDI: 0000000000000000
RBP: 0000000001000000 R08: 0000000000000003 R09: 0000000000000004
R10: dffffc0000000000 R11: fffff5200071ae6c R12: 0000000000280000
R13: dffffc0000000000 R14: ffff8881bc29f3e0 R15: ffff8881bc29f3e4
FS:  00007f15d1af96c0(0000) GS:ffff8882a8cc9000(0000) knlGS:000000000000000=
0
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000001000 CR3: 00000001bd5c4000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 d_make_persistent+0x8e/0x180 fs/dcache.c:3139
 shmem_mknod+0x2d4/0x340 mm/shmem.c:3851
 shmem_whiteout mm/shmem.c:3982 [inline]
 shmem_rename2+0x267/0x430 mm/shmem.c:4022
 vfs_rename+0xbd9/0xef0 fs/namei.c:6219
 ovl_do_rename_rd fs/overlayfs/overlayfs.h:371 [inline]
 ovl_check_rename_whiteout fs/overlayfs/super.c:593 [inline]
 ovl_make_workdir fs/overlayfs/super.c:713 [inline]
 ovl_get_workdir+0x93d/0x1980 fs/overlayfs/super.c:836
 ovl_fill_super_creds fs/overlayfs/super.c:1449 [inline]
 ovl_fill_super+0x1702/0x4360 fs/overlayfs/super.c:1561
 vfs_get_super fs/super.c:1405 [inline]
 get_tree_nodev+0xbb/0x150 fs/super.c:1424
 vfs_get_tree+0x92/0x2a0 fs/super.c:1947
 fc_mount fs/namespace.c:1198 [inline]
 do_new_mount_fc fs/namespace.c:3772 [inline]
 do_new_mount+0x319/0xdc0 fs/namespace.c:3848
 do_mount fs/namespace.c:4181 [inline]
 __do_sys_mount fs/namespace.c:4397 [inline]
 __se_sys_mount+0x31d/0x420 fs/namespace.c:4374
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f15d0b9e159
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 =
48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff f=
f 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f15d1af9028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a5
RAX: ffffffffffffffda RBX: 00007f15d0e25fa0 RCX: 00007f15d0b9e159
RDX: 0000200000000440 RSI: 0000200000000100 RDI: 0000000000000000
RBP: 00007f15d0c3506b R08: 0000200000000080 R09: 0000000000000000
R10: 0000000000000008 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f15d0e26038 R14: 00007f15d0e25fa0 R15: 00007ffe9e1b3308
 </TASK>


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
[a.hindborg@kernel.org amir73il@gmail.com anton.ivanov@cambridgegreys.com b=
aolin.wang@linux.alibaba.com brauner@kernel.org cem@kernel.org coda@cs.cmu.=
edu codalist@coda.cs.cmu.edu fuse-devel@lists.linux.dev hughd@google.com hy=
c.lee@gmail.com jack@suse.cz jaharkes@cs.cmu.edu jlayton@kernel.org joel.gr=
anados@kernel.org johannes@sipsolutions.net kees@kernel.org leitao@debian.o=
rg linkinjeon@kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.ke=
rnel.org linux-mm@kvack.org linux-um@lists.infradead.org linux-unionfs@vger=
.kernel.org linux-xfs@vger.kernel.org miklos@szeredi.hu neilb@ownmail.net n=
tfs@lists.linux.dev richard@nod.at viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

