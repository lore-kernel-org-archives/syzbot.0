Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.72
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794811786;
	b=sW2CBKIZpUBWDr3blpnKqqoZO3JBUAKEU6/ClcfK4XAYyGmBv7igZQsLSYzWdOApVeZE
	 LHccnz8XC00RhN/cHdpwWS7VZZx5RtHNwgxHg9x2zDpBnX5yj8HyYmwYUXXPQD22WdX2T
	 IPYhFrdYqJtG2kSihFijxvW36IWwnacpLLF6Q9FuAqeGFf8j7Pcxc5EgtOJfjITbrVeQW
	 FX7aeQ7cNu0xs3nPWXM7rilDv6fds+4SgAY8pqQY49WpCFWAmHSB69am3Aju0vx/A5Urp
	 nd7iEo7dRQ8jbk+rS0nRVwOHR5qFpaphFjZUytXQutw+IkMzSUSVtp8KbF22I7tgPYg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794811786;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:In-Reply-To:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=DKeyQlsH0JJCilfVyiVLa5ToDVjcul+cjWTRDWPVVhA=;
	b=1yAuk/ZvBRdrhTzAw0K47ZsBQmnfy8JXNnfp90u3Nk5BkoiNkIccJLTCueY0IttPdPdS
	 S50bRVy8kevJBuvibrH8q21AJj7/exNrIc2mf9q+xy7yOiiZjef05RfyMaWQi99vA22Qz
	 wSVws4qxy7UU4zmuIWYvAB7KS5Suqf0pxTMZAJPJa/6YClJR6Lpp6K+pRBm9xwSmJg+h6
	 b8EwS9Afi1Aa8IH780dbP0tnQcEYgeoetpv/MFFXC9j8+cetFOX0lBFS81Wo5KHo+iVk7
	 2A1/QQvOFUhd5N5TfeWj07py9xT5ohy7eHLdouMPKAz7d/gqShdgpQ7GoLvef37HJbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.210.72
Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63531606A329
	for <syzbot@lists.linux.dev>; Mon, 16 Nov 2026 06:49:45 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 63531606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-862ab20625eso606387a34.2
        for <syzbot@lists.linux.dev>; Sun, 15 Nov 2026 22:49:45 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794811784; x=1795416584;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=DKeyQlsH0JJCilfVyiVLa5ToDVjcul+cjWTRDWPVVhA=;
        b=1NCaZ+UB/V97hoHUgQOk8oqiZ6BUU7VbujkI5bzrdU7dnwfHkwKsqqs2A0WXWs70C4
         ABIAJOsR1EotdzSK3tHd/mYB2hfwQJ/sbE35BtC4cLBJkHclKEaLXEynQQXAsdrOhDV1
         jS7er7LiBJJtdquAOoa8vvGNjwch1HL7rtRt6BmL0dREC1hEoLY1cOtzBWAmNdbbxCUj
         ygygZHB3HWU5ygXkbJLTZ700vmPx65LNW2lIzllYUzSyep3WLrfNAB+Mr/JhbKpuSWeh
         dNchWDakYo/1zKQYnDmzNAmAtWPerO2Qwio618wojYeizQSI35NWeeUtZaX0vM/l1sOY
         +rmA==
X-Gm-Message-State: APuU4Z8QSSAe4jK1/6xNOu6K23cQJnv8xlgLnmCeWUhAaUhrJSy+IuhO
	o3uDs/RMG7w4hzuARJgpo0b3gbLPu8u51geC7zMjWE3jKTSM3iwvsAp6QGO75IHkh5Qljsj3lZn
	w4QVAvRx8FY8IJhLdYZK5iRIL1gKzIguWBkVMondr+Wxn4z0rnMiVHGEPjU0=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f69:b0:574:9463:5511 with SMTP id
 5614622812f47-57494639970mr1417372b6e.48.1794811784314; Sun, 15 Nov 2026
 22:49:44 -0800 (PST)
Date: Sun, 15 Nov 2026 22:49:44 -0800
In-Reply-To: <20261111234402.252354-1-phillip@squashfs.org.uk>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6afaa788.3f8ef711.2cc87e.0002.GAE@google.com>
Subject: [syzbot ci] Re: Squashfs: fix a lot of AI issues and AI style issues
From: syzbot ci <syzbot+ci04e7314748e3f6be@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, phillip@squashfs.org.uk
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] Squashfs: fix a lot of AI issues and AI style issues
https://lore.kernel.org/all/20261111234402.252354-1-phillip@squashfs.org.uk
* [PATCH v2 01/22] Squashfs: convert SQUASHFS_COMPRESSED_* to inline functions
* [PATCH v2 02/22] Squashfs: convert SQUASHFS_INODE_* and SQUASHFS_MKINODE to inline functions
* [PATCH v2 03/22] Squashfs: convert SQUASHFS_FRAGMENT_* to inline functions
* [PATCH v2 04/22] Squashfs: convert SQUASHFS_LOOKUP_* to inline functions
* [PATCH v2 05/22] Squashfs: convert SQUASHFS_ID_* to inline functions
* [PATCH v2 06/22] Squashfs: convert SQUASHFS_XATTR_* to inline functions
* [PATCH v2 07/22] Squashfs: fix offset in squashfs_read_inode() TRACE statements
* [PATCH v2 08/22] Squashfs: fix fragment bytes overflow on 32-bit architectures
* [PATCH v2 09/22] Squashfs: fix fragment index table length too large exploit
* [PATCH v2 10/22] Squashfs: sanity check inode metadata block location
* [PATCH v2 11/22] Squashfs: sanity check directory metadata block location
* [PATCH v2 12/22] Squashfs: widen xattr count variables and add sanity check
* [PATCH v2 13/22] Squashfs: very large files can exceed an int block count
* [PATCH v2 14/22] Squashfs: add more sanity checking to squashfs_block_size()
* [PATCH v2 15/22] Squashfs: sanity check fragment block location and range
* [PATCH v2 16/22] Squashfs: sanity check block list sizes and range
* [PATCH v2 17/22] Squashfs: don't store large export table indexes in memory
* [PATCH v2 18/22] Squashfs: don't store large fragment table indexes in memory
* [PATCH v2 19/22] Squashfs: don't store large xattr id table indexes in memory
* [PATCH v2 20/22] Squashfs: fix variables in directory code and add more sanity checks
* [PATCH v2 21/22] Squashfs: fix regression in squashfs_copy_cache()
* [PATCH v2 22/22] Squashfs: check index isn't greater than S64_MAX in squashfs_read_data()

and found the following issues:
* general protection fault in __d_obtain_alias
* general protection fault in lookup_one_qstr_excl
* general protection fault in lookup_open
* general protection fault in security_d_instantiate
* general protection fault in step_into_slowpath

Full report is available here:
https://ci.syzbot.org/series/dc24cdf0-7531-440e-8970-9c83c975cd2f

***

general protection fault in __d_obtain_alias

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      23c62304dde29abe92013d85910d03a77dada35d
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/5a6f70fa-f5d2-4503-b4cf-fb256a97e555/config
syz repro: https://ci.syzbot.org/findings/c832ec54-5339-4b53-8b65-3e2346402152/syz_repro

loop0: detected capacity change from 0 to 8
SQUASHFS error: Unable to read inode 0x87
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000009: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
CPU: 1 UID: 0 PID: 5911 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__d_obtain_alias+0x50/0x880 fs/dcache.c:2357
Code: e8 c5 72 6d ff eb 53 e8 be 72 6d ff 49 c7 c5 8c ff ff ff eb 45 49 bf 00 00 00 00 00 fc ff df 49 8d 7d 28 48 89 f8 48 c1 e8 03 <42> 80 3c 38 00 74 05 e8 44 0c e5 ff 4d 8b 75 28 4c 89 ef e8 98 a8
RSP: 0018:ffffc9000360f9d0 EFLAGS: 00010206
RAX: 0000000000000009 RBX: 0000000000000002 RCX: ffff8881ba5fbc00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000048
RBP: 0000000000000001 R08: ffffffff91be0bbf R09: 1ffffffff237c177
R10: dffffc0000000000 R11: fffffbfff237c178 R12: ffff888118c9e000
R13: 0000000000000020 R14: 1ffff920006c1f4c R15: dffffc0000000000
FS:  00007f1ed223d6c0(0000) GS:ffff8882a7803000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2d963fff CR3: 000000010c68a000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 squashfs_export_iget+0x1d8/0x370 fs/squashfs/export.c:117
 exportfs_decode_fh_raw+0x1c8/0x770 fs/exportfs/expfs.c:460
 do_handle_to_path+0xa4/0x1a0 fs/fhandle.c:274
 handle_to_path fs/fhandle.c:423 [inline]
 do_handle_open+0x6dd/0xb10 fs/fhandle.c:447
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f1ed13a8fd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f1ed223d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000130
RAX: ffffffffffffffda RBX: 00007f1ed1625fa0 RCX: 00007f1ed13a8fd9
RDX: 0000000000000000 RSI: 00002000000006c0 RDI: 0000000000000004
RBP: 00007f1ed1437fed R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007f1ed1626038 R14: 00007f1ed1625fa0 R15: 00007ffeeb039848
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__d_obtain_alias+0x50/0x880 fs/dcache.c:2357
Code: e8 c5 72 6d ff eb 53 e8 be 72 6d ff 49 c7 c5 8c ff ff ff eb 45 49 bf 00 00 00 00 00 fc ff df 49 8d 7d 28 48 89 f8 48 c1 e8 03 <42> 80 3c 38 00 74 05 e8 44 0c e5 ff 4d 8b 75 28 4c 89 ef e8 98 a8
RSP: 0018:ffffc9000360f9d0 EFLAGS: 00010206
RAX: 0000000000000009 RBX: 0000000000000002 RCX: ffff8881ba5fbc00
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000048
RBP: 0000000000000001 R08: ffffffff91be0bbf R09: 1ffffffff237c177
R10: dffffc0000000000 R11: fffffbfff237c178 R12: ffff888118c9e000
R13: 0000000000000020 R14: 1ffff920006c1f4c R15: dffffc0000000000
FS:  00007f1ed223d6c0(0000) GS:ffff8882a7803000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f1ed13f07a0 CR3: 000000010c68a000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	e8 c5 72 6d ff       	call   0xff6d72ca
   5:	eb 53                	jmp    0x5a
   7:	e8 be 72 6d ff       	call   0xff6d72ca
   c:	49 c7 c5 8c ff ff ff 	mov    $0xffffffffffffff8c,%r13
  13:	eb 45                	jmp    0x5a
  15:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
  1c:	fc ff df
  1f:	49 8d 7d 28          	lea    0x28(%r13),%rdi
  23:	48 89 f8             	mov    %rdi,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
  2f:	74 05                	je     0x36
  31:	e8 44 0c e5 ff       	call   0xffe50c7a
  36:	4d 8b 75 28          	mov    0x28(%r13),%r14
  3a:	4c 89 ef             	mov    %r13,%rdi
  3d:	e8                   	.byte 0xe8
  3e:	98                   	cwtl
  3f:	a8                   	.byte 0xa8


***

general protection fault in lookup_one_qstr_excl

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      23c62304dde29abe92013d85910d03a77dada35d
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/5a6f70fa-f5d2-4503-b4cf-fb256a97e555/config
syz repro: https://ci.syzbot.org/findings/03a8b71f-8e8b-4f9a-b937-26503c6e8d54/syz_repro

         and is ignored by this kernel. Remove the mand
         option from the mount to silence this warning.
=======================================================
SQUASHFS error: Unable to read directory block [0:26]
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000000: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
CPU: 1 UID: 0 PID: 5849 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__d_entry_type include/linux/dcache.h:452 [inline]
RIP: 0010:d_is_miss include/linux/dcache.h:457 [inline]
RIP: 0010:d_is_negative include/linux/dcache.h:503 [inline]
RIP: 0010:lookup_one_qstr_excl+0x155/0x360 fs/namei.c:1824
Code: b0 09 48 85 c0 0f 85 8f 01 00 00 e8 55 34 6f ff 49 81 fe 01 f0 ff ff 72 0a e8 47 34 6f ff e9 86 00 00 00 4c 89 f0 48 c1 e8 03 <0f> b6 04 28 84 c0 0f 85 b6 01 00 00 bd 00 00 38 00 41 23 2e 41 89
RSP: 0018:ffffc900037bfcb0 EFLAGS: 00010247
RAX: 0000000000000000 RBX: 0000000000060000 RCX: ffff888102733c00
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000ffffffff
RBP: dffffc0000000000 R08: ffff8881b3d5c3fb R09: 1ffff110367ab87f
R10: dffffc0000000000 R11: ffffed10367ab880 R12: ffff8881b3d5c340
R13: ffff8881b3ee3240 R14: 0000000000000006 R15: 0000000000000006
FS:  00007f5d957c56c0(0000) GS:ffff8882a7803000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd7cd75ff8 CR3: 000000016afe8000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 __start_dirop fs/namei.c:2926 [inline]
 start_dirop fs/namei.c:2948 [inline]
 filename_create+0x20e/0x370 fs/namei.c:5108
 filename_mkdirat+0xd2/0x550 fs/namei.c:5454
 __do_sys_mkdirat fs/namei.c:5482 [inline]
 __se_sys_mkdirat+0x35/0x150 fs/namei.c:5479
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f5d949a7e47
Code: 00 66 90 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff e9 db f7 ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 b8 02 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007f5d957c4e58 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
RAX: ffffffffffffffda RBX: 00007f5d957c4ee0 RCX: 00007f5d949a7e47
RDX: 00000000000001ff RSI: 0000200000000d40 RDI: 00000000ffffff9c
RBP: 0000200000000d00 R08: 0000000000000040 R09: 0000200000000e40
R10: 0000200000000d00 R11: 0000000000000246 R12: 0000200000000d40
R13: 00007f5d957c4ea0 R14: 0000000000000000 R15: 0000000000000000
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:__d_entry_type include/linux/dcache.h:452 [inline]
RIP: 0010:d_is_miss include/linux/dcache.h:457 [inline]
RIP: 0010:d_is_negative include/linux/dcache.h:503 [inline]
RIP: 0010:lookup_one_qstr_excl+0x155/0x360 fs/namei.c:1824
Code: b0 09 48 85 c0 0f 85 8f 01 00 00 e8 55 34 6f ff 49 81 fe 01 f0 ff ff 72 0a e8 47 34 6f ff e9 86 00 00 00 4c 89 f0 48 c1 e8 03 <0f> b6 04 28 84 c0 0f 85 b6 01 00 00 bd 00 00 38 00 41 23 2e 41 89
RSP: 0018:ffffc900037bfcb0 EFLAGS: 00010247
RAX: 0000000000000000 RBX: 0000000000060000 RCX: ffff888102733c00
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000ffffffff
RBP: dffffc0000000000 R08: ffff8881b3d5c3fb R09: 1ffff110367ab87f
R10: dffffc0000000000 R11: ffffed10367ab880 R12: ffff8881b3d5c340
R13: ffff8881b3ee3240 R14: 0000000000000006 R15: 0000000000000006
FS:  00007f5d957c56c0(0000) GS:ffff8882a7803000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd7cd75ff8 CR3: 000000016afe8000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	b0 09                	mov    $0x9,%al
   2:	48 85 c0             	test   %rax,%rax
   5:	0f 85 8f 01 00 00    	jne    0x19a
   b:	e8 55 34 6f ff       	call   0xff6f3465
  10:	49 81 fe 01 f0 ff ff 	cmp    $0xfffffffffffff001,%r14
  17:	72 0a                	jb     0x23
  19:	e8 47 34 6f ff       	call   0xff6f3465
  1e:	e9 86 00 00 00       	jmp    0xa9
  23:	4c 89 f0             	mov    %r14,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	0f b6 04 28          	movzbl (%rax,%rbp,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 b6 01 00 00    	jne    0x1ec
  36:	bd 00 00 38 00       	mov    $0x380000,%ebp
  3b:	41 23 2e             	and    (%r14),%ebp
  3e:	41                   	rex.B
  3f:	89                   	.byte 0x89


***

general protection fault in lookup_open

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      23c62304dde29abe92013d85910d03a77dada35d
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/5a6f70fa-f5d2-4503-b4cf-fb256a97e555/config
syz repro: https://ci.syzbot.org/findings/725fff20-2541-433d-a11c-5306ff0c8a65/syz_repro

loop0: detected capacity change from 0 to 8
SQUASHFS error: Unable to read directory block [0:26]
Oops: general protection fault, probably for non-canonical address 0xdffffc000000000e: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000070-0x0000000000000077]
CPU: 0 UID: 0 PID: 5897 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:lookup_open+0xaae/0x1ae0 fs/namei.c:4548
Code: 00 00 e8 b5 ed 70 ff 4d 85 ff 0f 85 89 09 00 00 e8 a7 ed 70 ff 49 bf 00 00 00 00 00 fc ff df 48 8d 5d 68 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 33 87 e8 ff 48 83 3b 00 74 07 e8
RSP: 0018:ffffc9000239f9b8 EFLAGS: 00010202
RAX: 000000000000000e RBX: 0000000000000070 RCX: ffff88810c955a00
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000ffffffff
RBP: 0000000000000008 R08: ffff888118d1e3fb R09: 1ffff110231a3c7f
R10: dffffc0000000000 R11: ffffed10231a3c80 R12: 1ffff11004521e4c
R13: 00000000ffffffe2 R14: ffffc9000239fc20 R15: dffffc0000000000
FS:  00007ff1a82e46c0(0000) GS:ffff88818be03000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000200000009080 CR3: 0000000114c04000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 open_last_lookups fs/namei.c:4774 [inline]
 path_openat+0x70c/0x20f0 fs/namei.c:5013
 do_file_open+0x23e/0x4a0 fs/namei.c:5045
 do_sys_openat2+0x115/0x200 fs/open.c:1443
 do_sys_open fs/open.c:1449 [inline]
 __do_sys_openat fs/open.c:1465 [inline]
 __se_sys_openat fs/open.c:1460 [inline]
 __x64_sys_openat+0x138/0x170 fs/open.c:1460
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7ff1a73a8fd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ff1a82e4028 EFLAGS: 00000246 ORIG_RAX: 0000000000000101
RAX: ffffffffffffffda RBX: 00007ff1a7625fa0 RCX: 00007ff1a73a8fd9
RDX: 0000000000143042 RSI: 0000200000009080 RDI: ffffffffffffff9c
RBP: 00007ff1a7437fed R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000051 R11: 0000000000000246 R12: 0000000000000000
R13: 00007ff1a7626038 R14: 00007ff1a7625fa0 R15: 00007fff51056ec8
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:lookup_open+0xaae/0x1ae0 fs/namei.c:4548
Code: 00 00 e8 b5 ed 70 ff 4d 85 ff 0f 85 89 09 00 00 e8 a7 ed 70 ff 49 bf 00 00 00 00 00 fc ff df 48 8d 5d 68 48 89 d8 48 c1 e8 03 <42> 80 3c 38 00 74 08 48 89 df e8 33 87 e8 ff 48 83 3b 00 74 07 e8
RSP: 0018:ffffc9000239f9b8 EFLAGS: 00010202
RAX: 000000000000000e RBX: 0000000000000070 RCX: ffff88810c955a00
RDX: 0000000000000000 RSI: 0000000000000004 RDI: 00000000ffffffff
RBP: 0000000000000008 R08: ffff888118d1e3fb R09: 1ffff110231a3c7f
R10: dffffc0000000000 R11: ffffed10231a3c80 R12: 1ffff11004521e4c
R13: 00000000ffffffe2 R14: ffffc9000239fc20 R15: dffffc0000000000
FS:  00007ff1a82e46c0(0000) GS:ffff88818be03000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ff1a73f07a0 CR3: 0000000114c04000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	00 00                	add    %al,(%rax)
   2:	e8 b5 ed 70 ff       	call   0xff70edbc
   7:	4d 85 ff             	test   %r15,%r15
   a:	0f 85 89 09 00 00    	jne    0x999
  10:	e8 a7 ed 70 ff       	call   0xff70edbc
  15:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
  1c:	fc ff df
  1f:	48 8d 5d 68          	lea    0x68(%rbp),%rbx
  23:	48 89 d8             	mov    %rbx,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 80 3c 38 00       	cmpb   $0x0,(%rax,%r15,1) <-- trapping instruction
  2f:	74 08                	je     0x39
  31:	48 89 df             	mov    %rbx,%rdi
  34:	e8 33 87 e8 ff       	call   0xffe8876c
  39:	48 83 3b 00          	cmpq   $0x0,(%rbx)
  3d:	74 07                	je     0x46
  3f:	e8                   	.byte 0xe8


***

general protection fault in security_d_instantiate

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      23c62304dde29abe92013d85910d03a77dada35d
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/5a6f70fa-f5d2-4503-b4cf-fb256a97e555/config
syz repro: https://ci.syzbot.org/findings/fbe3856a-ab34-428b-987c-0e66e555d126/syz_repro

loop1: detected capacity change from 0 to 8
SQUASHFS error: Unable to read inode 0x87
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000004: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
CPU: 1 UID: 0 PID: 5872 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:security_d_instantiate+0x2f/0x1d0 security/security.c:3781
Code: 41 57 41 56 53 48 89 f3 49 89 fe e8 0b c7 29 fd 48 85 db 74 42 4c 8d 7b 04 4c 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c0 0f 85 9d 00 00 00 41 8b 2f 89 ee 81 e6 00 02 00
RSP: 0018:ffffc900039df898 EFLAGS: 00010203
RAX: 0000000000000004 RBX: 0000000000000020 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000020 RDI: ffff8881bbefe000
RBP: ffffc900039dfb00 R08: ffffffff91be0bbf R09: 1ffffffff237c177
R10: dffffc0000000000 R11: fffffbfff237c178 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8881bbefe000 R15: 0000000000000024
FS:  00007fc89f6776c0(0000) GS:ffff8882a7803000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000001b2d963fff CR3: 0000000176d60000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 d_splice_alias_ops+0x72/0x440 fs/dcache.c:3449
 squashfs_lookup+0xc5e/0x14e0 fs/squashfs/namei.c:273
 __lookup_slow+0x1fb/0x2f0 fs/namei.c:1925
 lookup_slow+0x59/0x80 fs/namei.c:1942
 walk_component fs/namei.c:2288 [inline]
 lookup_last fs/namei.c:2795 [inline]
 path_lookupat+0x3f5/0x8c0 fs/namei.c:2819
 filename_lookup+0x265/0x5d0 fs/namei.c:2848
 __do_sys_chroot fs/open.c:598 [inline]
 __se_sys_chroot+0xa8/0x3f0 fs/open.c:591
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fc89e7a8fd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fc89f677028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a1
RAX: ffffffffffffffda RBX: 00007fc89ea25fa0 RCX: 00007fc89e7a8fd9
RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000000980
RBP: 00007fc89e837fed R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fc89ea26038 R14: 00007fc89ea25fa0 R15: 00007ffc3017d408
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:security_d_instantiate+0x2f/0x1d0 security/security.c:3781
Code: 41 57 41 56 53 48 89 f3 49 89 fe e8 0b c7 29 fd 48 85 db 74 42 4c 8d 7b 04 4c 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84 c0 0f 85 9d 00 00 00 41 8b 2f 89 ee 81 e6 00 02 00
RSP: 0018:ffffc900039df898 EFLAGS: 00010203
RAX: 0000000000000004 RBX: 0000000000000020 RCX: dffffc0000000000
RDX: 0000000000000000 RSI: 0000000000000020 RDI: ffff8881bbefe000
RBP: ffffc900039dfb00 R08: ffffffff91be0bbf R09: 1ffffffff237c177
R10: dffffc0000000000 R11: fffffbfff237c178 R12: 0000000000000000
R13: dffffc0000000000 R14: ffff8881bbefe000 R15: 0000000000000024
FS:  00007fc89f6776c0(0000) GS:ffff8882a7803000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000561fc662c278 CR3: 0000000176d60000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	41 57                	push   %r15
   2:	41 56                	push   %r14
   4:	53                   	push   %rbx
   5:	48 89 f3             	mov    %rsi,%rbx
   8:	49 89 fe             	mov    %rdi,%r14
   b:	e8 0b c7 29 fd       	call   0xfd29c71b
  10:	48 85 db             	test   %rbx,%rbx
  13:	74 42                	je     0x57
  15:	4c 8d 7b 04          	lea    0x4(%rbx),%r15
  19:	4c 89 f8             	mov    %r15,%rax
  1c:	48 c1 e8 03          	shr    $0x3,%rax
  20:	48 b9 00 00 00 00 00 	movabs $0xdffffc0000000000,%rcx
  27:	fc ff df
* 2a:	0f b6 04 08          	movzbl (%rax,%rcx,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 9d 00 00 00    	jne    0xd3
  36:	41 8b 2f             	mov    (%r15),%ebp
  39:	89 ee                	mov    %ebp,%esi
  3b:	81                   	.byte 0x81
  3c:	e6 00                	out    %al,$0x0
  3e:	02 00                	add    (%rax),%al


***

general protection fault in step_into_slowpath

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      23c62304dde29abe92013d85910d03a77dada35d
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/5a6f70fa-f5d2-4503-b4cf-fb256a97e555/config
syz repro: https://ci.syzbot.org/findings/436bb7e5-3170-4e77-af09-16cc5bfab1a0/syz_repro

loop0: detected capacity change from 0 to 8
SQUASHFS error: Unable to read directory block [0:26]
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000001: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
CPU: 0 UID: 0 PID: 5902 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:traverse_mounts fs/namei.c:1644 [inline]
RIP: 0010:handle_mounts fs/namei.c:1755 [inline]
RIP: 0010:step_into_slowpath+0x118/0x820 fs/namei.c:2110
Code: 49 bf 00 00 00 00 00 fc ff df 43 0f b6 04 3c 84 c0 48 8d 53 38 0f 85 7b 05 00 00 44 8b 32 4c 8b 6c 24 48 4c 89 e8 48 c1 e8 03 <42> 0f b6 04 38 84 c0 0f 85 81 05 00 00 45 8b 6d 00 44 89 ee 81 e6
RSP: 0018:ffffc9000356f700 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffffc9000356f9c0 RCX: ffff888115065a00
RDX: ffffc9000356f9f8 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000356f7b0 R08: ffff88811998f31f R09: 1ffff11023331e63
R10: dffffc0000000000 R11: ffffed1023331e64 R12: 1ffff920006adf3f
R13: 0000000000000008 R14: 0000000000000401 R15: dffffc0000000000
FS:  00007fe4700f56c0(0000) GS:ffff88818be03000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe46f071a20 CR3: 0000000111cdc000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 step_into fs/namei.c:2158 [inline]
 walk_component fs/namei.c:2294 [inline]
 link_path_walk+0xdb1/0x19a0 fs/namei.c:2662
 path_lookupat+0xe4/0x8c0 fs/namei.c:2818
 filename_lookup+0x265/0x5d0 fs/namei.c:2848
 vfs_statx+0xfc/0x200 fs/stat.c:357
 vfs_fstatat+0x11b/0x170 fs/stat.c:377
 __do_sys_newfstatat fs/stat.c:542 [inline]
 __se_sys_newfstatat+0x118/0x3a0 fs/stat.c:536
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x16a/0x530 arch/x86/entry/syscall_64.c:89
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fe46f1a8fd9
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007fe4700f5028 EFLAGS: 00000246 ORIG_RAX: 0000000000000106
RAX: ffffffffffffffda RBX: 00007fe46f425fa0 RCX: 00007fe46f1a8fd9
RDX: 0000200000000380 RSI: 0000200000000340 RDI: ffffffffffffff9c
RBP: 00007fe46f237fed R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
R13: 00007fe46f426038 R14: 00007fe46f425fa0 R15: 00007ffd6a7e0378
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:traverse_mounts fs/namei.c:1644 [inline]
RIP: 0010:handle_mounts fs/namei.c:1755 [inline]
RIP: 0010:step_into_slowpath+0x118/0x820 fs/namei.c:2110
Code: 49 bf 00 00 00 00 00 fc ff df 43 0f b6 04 3c 84 c0 48 8d 53 38 0f 85 7b 05 00 00 44 8b 32 4c 8b 6c 24 48 4c 89 e8 48 c1 e8 03 <42> 0f b6 04 38 84 c0 0f 85 81 05 00 00 45 8b 6d 00 44 89 ee 81 e6
RSP: 0018:ffffc9000356f700 EFLAGS: 00010202
RAX: 0000000000000001 RBX: ffffc9000356f9c0 RCX: ffff888115065a00
RDX: ffffc9000356f9f8 RSI: 0000000000000000 RDI: 0000000000000000
RBP: ffffc9000356f7b0 R08: ffff88811998f31f R09: 1ffff11023331e63
R10: dffffc0000000000 R11: ffffed1023331e64 R12: 1ffff920006adf3f
R13: 0000000000000008 R14: 0000000000000401 R15: dffffc0000000000
FS:  00007fe4700f56c0(0000) GS:ffff88818be03000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fe46f1f07a0 CR3: 0000000111cdc000 CR4: 00000000000006f0
----------------
Code disassembly (best guess):
   0:	49 bf 00 00 00 00 00 	movabs $0xdffffc0000000000,%r15
   7:	fc ff df
   a:	43 0f b6 04 3c       	movzbl (%r12,%r15,1),%eax
   f:	84 c0                	test   %al,%al
  11:	48 8d 53 38          	lea    0x38(%rbx),%rdx
  15:	0f 85 7b 05 00 00    	jne    0x596
  1b:	44 8b 32             	mov    (%rdx),%r14d
  1e:	4c 8b 6c 24 48       	mov    0x48(%rsp),%r13
  23:	4c 89 e8             	mov    %r13,%rax
  26:	48 c1 e8 03          	shr    $0x3,%rax
* 2a:	42 0f b6 04 38       	movzbl (%rax,%r15,1),%eax <-- trapping instruction
  2f:	84 c0                	test   %al,%al
  31:	0f 85 81 05 00 00    	jne    0x5b8
  37:	45 8b 6d 00          	mov    0x0(%r13),%r13d
  3b:	44 89 ee             	mov    %r13d,%esi
  3e:	81                   	.byte 0x81
  3f:	e6                   	.byte 0xe6


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
