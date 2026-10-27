Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793090791;
	b=Nu7F6E9GocCzGS3H0EVEtUvNBCr0ZZ4Fk7iK1i/zc9k0gK4n5leApyiqNhnGTzAcabug
	 6+lU+AynejJsbrPf3+LhXJ03Ss7TsLhBcxqI03TqAFvpOp10mlH4WHgBEs8fbY/1qs6uV
	 WQDGKvmPL3cD+/NzAKBfAOI3keNeUoa19Td9tj+OnStcvxpFT2bax7xxBHDI6zNUiRxrp
	 Syq2wGT8Okw845I9iJ2TVvWKu/e1aRjrUVYnB74LTbJrdLRWgisRZcgfYthPmUn4ibd/K
	 iv6Z6epcteRi32GSwM8vmOTRW/4cj8huZETj0oecAD4YjUjWTVZh9+c73pYWmYdFUEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793090791;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:In-Reply-To:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=tPrgG4LYa4RwzB+7UHvOcyaMahs7B5UXpFYu5OPR8nI=;
	b=5mqeBMNQ6W41BJ++WGe+tw4FwN4zNwO4GNzPMVjAK+ZaS9MuLYAW54M4deyJ+tx4BEbC
	 UzcxAtQiyrSZ+eNFY3a1VJ8lQykhvskblkQgM7LT+/syjzkcR3zBSZzxmcobFYCas7uE7
	 B0iMNs7XbvuM1RQHaNraJ6P1A337qJfuwqI1z2lVL1/RAHa7no625REVbanEEIPKfhWZe
	 pGd7uRl1SCsOfqZ1jw1IatBlaPKFqQbZUQKlebsbDubBteLFWQLFgTfTz3xFA5800bmI7
	 +H1XPof6LbhS8QxcenjiA6eFQyXZB/2MjJe6Kus+muTjQAYfdXV4pylyjRN3DSG1vMQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DB5D560A2619
	for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 08:46:30 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org DB5D560A2619
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4c307941971so5325796b6e.1
        for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 01:46:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793090790; x=1793695590;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=tPrgG4LYa4RwzB+7UHvOcyaMahs7B5UXpFYu5OPR8nI=;
        b=Luli1uSMv8NuFVSYhfjyd4uW0VxPgDSksqVtQWXi9Ow+FiS0iCBqmqJ0jCOCByUZeD
         2HtRM4sCAouvEx1UoTSsOOARzzgrtqm1UWQaU8kqafVCzLUiUyc2aSZS9XP9OT1LwomF
         XKMIrcEI6SGA052VCPOj8XkrxcgHBd1zLtYF5UgtY9m0W73XCJbKa4TPg3KwBN1x67NS
         0mS4MmwNWLBT4VTklL1wfNat4hxLFlvBawLBZ0z+MP+BSdVO1o+085JJhM0ua20Mrtr1
         EgVXIqfr1nrG1RzIBR1RRFAs9K8Qz1iRbEa0DcJ/XM+LHcGo4B6fSZR1n7QMZZ5BCDWP
         8mvg==
X-Gm-Message-State: AFq9FYK3kDczJ6GimxNUTE32Zgpaju2880OxcVH+FHPwAmq+qpPjFUkt
	AluoK+SQAFT5u3B7WWUEJ0BZ9H9FrvwTEard+InM2Oan0h22hOjgHVSL4O4Fq6aT/CGEt7LArUT
	wz3Fud9L+LYN6GCEZqcbdlTrYc6dNJ1vaa9sh5GbnmdsxyCqfIcXDZ9FNx1o=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1984:b0:4c4:a240:9c3a with SMTP id
 5614622812f47-55bfff99492mr7204509b6e.4.1793090789979; Tue, 27 Oct 2026
 01:46:29 -0700 (PDT)
Date: Tue, 27 Oct 2026 01:46:29 -0700
In-Reply-To: <20261026213626.301480-1-aurelien@hackers.camp>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae064e5.768774f5.3237ab.0015.GAE@google.com>
Subject: [syzbot ci] Re: buffer: warn when a buffer is attached to a second mmb
From: syzbot ci <syzbot+ci5d1c09e093f34f60@syzkaller.appspotmail.com>
To: aurelien.desbrieres@gmail.com, aurelien@hackers.camp, brauner@kernel.org, 
	jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org, 
	viro@zeniv.linux.org.uk, willy@infradead.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] buffer: warn when a buffer is attached to a second mmb
https://lore.kernel.org/all/20261026213626.301480-1-aurelien@hackers.camp
* [PATCH] buffer: warn when a buffer is attached to a second mmb

and found the following issues:
* WARNING in __ext4_handle_dirty_metadata
* WARNING in fat_add_entries
* WARNING in fat_alloc_new_dir
* WARNING in fat_remove_entries

Full report is available here:
https://ci.syzbot.org/series/2d872051-106e-44e2-912e-9f5ffc88fe5f

***

WARNING in __ext4_handle_dirty_metadata

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/0103f224-dbc7-46e0-b595-6b58abedf2a1/config
syz repro: https://ci.syzbot.org/findings/e505c7df-1483-4020-9400-461d434eaf84/syz_repro

------------[ cut here ]------------
cur && cur != mmb
WARNING: fs/buffer.c:639 at mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639, CPU#1: syz.2.20/5867
Modules linked in:
CPU: 1 UID: 0 PID: 5867 Comm: syz.2.20 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639
Code: af d7 ff 4d 89 65 00 eb 05 e8 42 c7 66 ff 4c 89 ff 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 0c d6 8a 09 e8 27 c7 66 ff 90 <0f> 0b 90 e9 39 fe ff ff 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
RSP: 0018:ffffc900030bf238 EFLAGS: 00010293
RAX: ffffffff82615d19 RBX: ffff8881bd1af460 RCX: ffff88816f9a9e00
RDX: 0000000000000000 RSI: ffff888165b29280 RDI: ffff8881bd1af460
RBP: dffffc0000000000 R08: ffff8881bd1af467 R09: 1ffff11037a35e8c
R10: dffffc0000000000 R11: ffffed1037a35e8d R12: ffff8881bd1af4b0
R13: ffff8881bd347348 R14: ffff888165b29280 R15: 1ffff11037a35e96
FS:  00007fa2891f26c0(0000) GS:ffff8882a7cbb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2e2cbf40e8 CR3: 000000016e66c000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __ext4_handle_dirty_metadata+0x2f5/0xa00 fs/ext4/ext4_jbd2.c:418
 ext4_xattr_block_set+0x24dd/0x29a0 fs/ext4/xattr.c:2107
 ext4_xattr_set_handle+0xed9/0x15f0 fs/ext4/xattr.c:2461
 ext4_xattr_set+0x257/0x340 fs/ext4/xattr.c:2563
 __vfs_setxattr+0x442/0x480 fs/xattr.c:223
 __vfs_setxattr_noperm+0x12a/0x660 fs/xattr.c:257
 vfs_setxattr+0x163/0x360 fs/xattr.c:344
 ovl_do_setxattr fs/overlayfs/overlayfs.h:328 [inline]
 ovl_setxattr fs/overlayfs/overlayfs.h:340 [inline]
 ovl_check_setxattr+0x15a/0x320 fs/overlayfs/util.c:898
 ovl_set_opaque_xerr fs/overlayfs/dir.c:276 [inline]
 ovl_set_opaque fs/overlayfs/dir.c:290 [inline]
 ovl_create_upper fs/overlayfs/dir.c:383 [inline]
 ovl_create_handle_whiteouts+0xb9c/0x13d0 fs/overlayfs/dir.c:643
 ovl_create_or_link+0x14d/0x270 fs/overlayfs/dir.c:685
 ovl_create_object+0x29d/0x3b0 fs/overlayfs/dir.c:722
 ovl_mkdir+0x34/0x50 fs/overlayfs/dir.c:742
 vfs_mkdir+0x40c/0x620 fs/namei.c:5420
 filename_mkdirat+0x285/0x510 fs/namei.c:5453
 __do_sys_mkdirat fs/namei.c:5474 [inline]
 __se_sys_mkdirat+0x35/0x150 fs/namei.c:5471
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fa28839f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fa2891f2028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007fa288626090 RCX: 00007fa28839f559
RDX: 00000000000001c0 RSI: 0000200000000400 RDI: ffffffffffffff9c
RBP: 00007fa288436b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fa288626128 R14: 00007fa288626090 R15: 00007ffd68374848
 </TASK>


***

WARNING in fat_add_entries

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/0103f224-dbc7-46e0-b595-6b58abedf2a1/config
syz repro: https://ci.syzbot.org/findings/39f0a1b2-b9af-4d73-a1fc-ce1cd04779b5/syz_repro

FAT-fs (loop2): Invalid FSINFO signature: 0x41615252, 0x80417272 (sector = 1)
------------[ cut here ]------------
cur && cur != mmb
WARNING: fs/buffer.c:639 at mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639, CPU#0: syz.2.19/5813
Modules linked in:
CPU: 0 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639
Code: af d7 ff 4d 89 65 00 eb 05 e8 42 c7 66 ff 4c 89 ff 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 0c d6 8a 09 e8 27 c7 66 ff 90 <0f> 0b 90 e9 39 fe ff ff 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
RSP: 0018:ffffc9000404f660 EFLAGS: 00010293
RAX: ffffffff82615d19 RBX: ffff88811c3c0a80 RCX: ffff888113c71e00
RDX: 0000000000000000 RSI: ffff88811bd3b3b8 RDI: ffff88811c3c0a80
RBP: dffffc0000000000 R08: ffffffff0000ffff R09: ffffffffffffffff
R10: 0000fc000f003000 R11: 65006c0069006641 R12: ffff88811c3c0ad0
R13: dffffc0000000000 R14: ffff88811bd3b3b8 R15: 1ffff1102387815a
FS:  00007f0b764146c0(0000) GS:ffff88818c4bb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000010ebc0000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 fat_add_entries+0xc9a/0x2320 fs/fat/dir.c:1410
 vfat_add_entry+0x2dd3/0x3570 fs/fat/namei_vfat.c:675
 vfat_mkdir+0x16c/0x300 fs/fat/namei_vfat.c:866
 vfs_mkdir+0x40c/0x620 fs/namei.c:5420
 filename_mkdirat+0x285/0x510 fs/namei.c:5453
 __do_sys_mkdirat fs/namei.c:5474 [inline]
 __se_sys_mkdirat+0x35/0x150 fs/namei.c:5471
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f0b7559e3c7
Code: 00 66 90 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff e9 db f7 ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 b8 02 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f0b76413e58 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007f0b76413ee0 RCX: 00007f0b7559e3c7
RDX: 00000000000001ff RSI: 00002000000000c0 RDI: 00000000ffffff9c
RBP: 0000000000000000 R08: 0000200000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 00002000000000c0
R13: 00007f0b76413ea0 R14: 0000000000000000 R15: 0000000000000000
 </TASK>


***

WARNING in fat_alloc_new_dir

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/0103f224-dbc7-46e0-b595-6b58abedf2a1/config
syz repro: https://ci.syzbot.org/findings/ac218fc3-8274-46ed-ad15-c9645108042b/syz_repro

FAT-fs (loop2): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
FAT-fs (loop2): Invalid FSINFO signature: 0x41615252, 0x80417272 (sector = 1)
------------[ cut here ]------------
cur && cur != mmb
WARNING: fs/buffer.c:639 at mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639, CPU#0: syz.2.19/5804
Modules linked in:
CPU: 0 UID: 0 PID: 5804 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639
Code: af d7 ff 4d 89 65 00 eb 05 e8 42 c7 66 ff 4c 89 ff 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 0c d6 8a 09 e8 27 c7 66 ff 90 <0f> 0b 90 e9 39 fe ff ff 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
RSP: 0018:ffffc900037bfac0 EFLAGS: 00010293
RAX: ffffffff82615d19 RBX: ffff888022008000 RCX: ffff888113ad3c00
RDX: 0000000000000000 RSI: ffff8880222733b8 RDI: ffff888022008000
RBP: dffffc0000000000 R08: ffff888022008007 R09: 1ffff11004401000
R10: dffffc0000000000 R11: ffffed1004401001 R12: ffff888022008050
R13: f8f8f8f8f1f1f1f1 R14: ffff8880222733b8 R15: 1ffff1100440100a
FS:  00007fde7c2926c0(0000) GS:ffff88818c4bb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 0000000022c3e000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 fat_alloc_new_dir+0x7c5/0xb90 fs/fat/dir.c:1223
 vfat_mkdir+0x13a/0x300 fs/fat/namei_vfat.c:861
 vfs_mkdir+0x40c/0x620 fs/namei.c:5420
 filename_mkdirat+0x285/0x510 fs/namei.c:5453
 __do_sys_mkdirat fs/namei.c:5474 [inline]
 __se_sys_mkdirat+0x35/0x150 fs/namei.c:5471
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fde7b39f559
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fde7c292028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007fde7b625fa0 RCX: 00007fde7b39f559
RDX: 0000000000000040 RSI: 0000200000000100 RDI: ffffffffffffff9c
RBP: 00007fde7b436b20 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fde7b626038 R14: 00007fde7b625fa0 R15: 00007ffee0058de8
 </TASK>


***

WARNING in fat_remove_entries

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/0103f224-dbc7-46e0-b595-6b58abedf2a1/config
syz repro: https://ci.syzbot.org/findings/09b74141-73df-447f-b681-310eb6bbab31/syz_repro

------------[ cut here ]------------
cur && cur != mmb
WARNING: fs/buffer.c:639 at mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639, CPU#0: syz-executor/5735
Modules linked in:
CPU: 0 UID: 0 PID: 5735 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639
Code: af d7 ff 4d 89 65 00 eb 05 e8 42 c7 66 ff 4c 89 ff 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 0c d6 8a 09 e8 27 c7 66 ff 90 <0f> 0b 90 e9 39 fe ff ff 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
RSP: 0018:ffffc9000385fb98 EFLAGS: 00010293
RAX: ffffffff82615d19 RBX: ffff8881130f0ee0 RCX: ffff888177e8bc00
RDX: 0000000000000000 RSI: ffff8881188ead68 RDI: ffff8881130f0ee0
RBP: dffffc0000000000 R08: ffffffff917a837f R09: 1ffffffff22f506f
R10: dffffc0000000000 R11: fffffbfff22f5070 R12: ffff8881130f0f30
R13: ffff8881188ead01 R14: ffff8881188ead68 R15: 1ffff1102261e1e6
FS:  0000555564cc8500(0000) GS:ffff88818c4bb000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fff31a07d40 CR3: 00000001768a8000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 fat_remove_entries+0x196/0x470 fs/fat/dir.c:1090
 vfat_unlink+0x283/0x330 fs/fat/namei_vfat.c:836
 vfs_unlink+0x27b/0x6d0 fs/namei.c:5659
 filename_unlinkat+0x3cd/0x610 fs/namei.c:5729
 __do_sys_unlink fs/namei.c:5764 [inline]
 __se_sys_unlink+0x2e/0x140 fs/namei.c:5761
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb725d9e647
Code: 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 57 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
RSP: 002b:00007fff31a08398 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb725d9e647
RDX: 00007fff31a083c0 RSI: 00007fff31a08450 RDI: 00007fff31a08450
RBP: 00007fff31a08450 R08: 00007fff31a09450 R09: 00000000ffffffff
R10: 0000000000000100 R11: 0000000000000206 R12: 00007fff31a09540
R13: 00007fb725e35f63 R14: 00000000000114de R15: 00007fff31a0b700
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
