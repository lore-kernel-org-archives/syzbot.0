Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6145314A62B
	for <syzbot@lists.linux.dev>; Mon, 16 Feb 2026 17:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771263851; cv=none; b=NXH9yKLNsq/QGA0/33y+MEZj5Wzt2qvhZkA9N6CdZwRC8NKNVRowsIUXOiQzyBiyna/55+Gks9Tqs9xCxkk+hY6p50RAunhKkrM72SgpG3tllbIEABlzf8LsoN0OSBlQ4Px1o0MU9j6YXHXPIOnw2kUTMHgEmfrsPeF9qaCB3gg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771263851; c=relaxed/simple;
	bh=FzjUUgCyz0N0tHnAr+18DsX8equIYN7hcN6GoWnHWtw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=CkVMCvWPViotVZKxZ+mFGfMhTtCiV+tZg2EQxgy+6JOC18nDmFrThhEfdXfFJ6KmFUXytt6vjcNoKtagCJp91PKo1GwR5NRijcwZBNwE+n/iQ1j7zcYWCHYYFdXSzkmuUdsfVFjoS/No/GjTX3yOhe7xIh1e02VpMrQfSDS50ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6777b1ac383so37472394eaf.0
        for <syzbot@lists.linux.dev>; Mon, 16 Feb 2026 09:44:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771263849; x=1771868649;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hvvOum1PjFhjj2uKjPjnw611lhjOgdtGTDl6H4kREmA=;
        b=BIYEkeAa/UdCiBPiTRniqNII93IJ5ZuQfhF8Qa/iy3IE4CSSKgyr96NA7rPtyNeFUl
         nuyQj6ksprbzpVxmjNTZVLezVLPVJj3wv6tlXdiy5gFGXcLzudRJAq2pO9zkKvxtNm17
         qgPLbvkd9FGczKVY5/B+lpSZI8o6M3Ug4SGD/rPwvkCDeR2xneV5aths7Y0kKaFbAWV7
         FobkTY1jktdX9goQjHfjIQaRezd9AGT2Zgf30Yvaqbpyv9Qdd/7q4hnDXootVKyy0Lze
         T1EdiyXwYj1lmNoY/is58rkt6ieVRFMnAMMcsbsXw4Sd4B1r95ryTw0F4EiGH8iWWmW3
         NiOw==
X-Gm-Message-State: AOJu0YwVzvYvwj9UVrbIjDmkug/NOy22t7UuFU3iyggHUKyJAUA5kvlX
	Zn6MrxydmLnvyyRmGc7J7LSXoatAoCpAoPCj0EhE2zfKcvPgA5c93EfQueBsYegSdp7BpRRXcAD
	NuhXHh+MXBDIK+dfpxD0ypuuaij7/QqU1Bri683duB78Jh5ipNYkEvbyiTLQ=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1744:b0:661:167b:72db with SMTP id
 006d021491bc7-6785b2b8c25mr4031032eaf.38.1771263849263; Mon, 16 Feb 2026
 09:44:09 -0800 (PST)
Date: Mon, 16 Feb 2026 09:44:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69935769.a70a0220.2c38d7.00f3.GAE@google.com>
Subject: [moderation/CI] Re: pidfs: add inode ownership and permission checks
From: syzbot ci <syzbot+cief838c6543b45863@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] pidfs: add inode ownership and permission checks
https://lore.kernel.org/all/20260216-work-pidfs-inode-owner-v1-1-f8faa6b73983@kernel.org
* [PATCH RFC] pidfs: add inode ownership and permission checks

and found the following issue:
general protection fault in pidfs_fill_owner

Full report is available here:
https://ci.syzbot.org/series/d1c7b2f5-ccdc-4ca8-af27-dd6c97fd9e90

***

general protection fault in pidfs_fill_owner

tree:      bpf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/bpf-next.git
base:      72c395024dac5e215136cbff793455f065603b06
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/a2c9422a-a065-455a-83e1-f304e9567e3e/config
syz repro: https://ci.syzbot.org/findings/b2100115-a69c-42ec-8aa0-29353ad7bd45/syz_repro

Oops: general protection fault, probably for non-canonical address 0xdffffc0000000003: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000018-0x000000000000001f]
CPU: 0 UID: 0 PID: 5803 Comm: syz-execprog Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:pidfs_fill_owner+0x1f5/0x500 fs/pidfs.c:743
Code: ff 49 83 c4 20 4c 89 e0 48 c1 e8 03 42 80 3c 30 00 74 08 4c 89 e7 e8 3a f2 da ff 4d 8b 2c 24 49 83 c5 18 4c 89 e8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 0f 85 7b 02 00 00 41 8b 6d 00 4c 89 f8 48 c1
RSP: 0018:ffffc90004997850 EFLAGS: 00010206
RAX: 0000000000000003 RBX: ffffffff8251bdfe RCX: ffff888175390000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff8251bdfe R09: ffffffff8e558220
R10: dffffc0000000000 R11: fffffbfff1fdf4ef R12: ffff8881078adaa0
R13: 0000000000000018 R14: dffffc0000000000 R15: ffff8881169793f8
FS:  000000c00007a898(0000) GS:ffff88818e0d7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c002961200 CR3: 000000016d248000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 pidfs_update_inode fs/pidfs.c:766 [inline]
 pidfs_stash_dentry+0xf2/0x280 fs/pidfs.c:1073
 path_from_stashed+0x463/0x5c0 fs/libfs.c:2258
 pidfs_alloc_file+0xff/0x290 fs/pidfs.c:1182
 pidfd_prepare+0x14e/0x1b0 kernel/fork.c:1898
 copy_process+0x1f3a/0x3cf0 kernel/fork.c:2259
 kernel_clone+0x248/0x870 kernel/fork.c:2654
 __do_sys_clone kernel/fork.c:2795 [inline]
 __se_sys_clone kernel/fork.c:2779 [inline]
 __x64_sys_clone+0x1b6/0x230 kernel/fork.c:2779
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x4a7d4d
Code: 24 10 48 8b 74 24 18 48 8b 54 24 20 49 c7 c2 00 00 00 00 49 c7 c0 00 00 00 00 49 c7 c1 00 00 00 00 48 8b 44 24 08 41 5c 0f 05 <41> 54 48 3d 01 f0 ff ff 76 12 48 c7 44 24 28 ff ff ff ff 48 f7 d8
RSP: 002b:000000c00001d5b8 EFLAGS: 00000216 ORIG_RAX: 0000000000000038
RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00000000004a7d4d
RDX: 000000c00001d644 RSI: 0000000000000000 RDI: 0000000000005100
RBP: 000000c00001d5f0 R08: 0000000000000000 R09: 0000000000000000
R10: 0000000000000000 R11: 0000000000000216 R12: 000000000049fd97
R13: 0000000000000000 R14: 000000c000002380 R15: 000000c000010020
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:pidfs_fill_owner+0x1f5/0x500 fs/pidfs.c:743
Code: ff 49 83 c4 20 4c 89 e0 48 c1 e8 03 42 80 3c 30 00 74 08 4c 89 e7 e8 3a f2 da ff 4d 8b 2c 24 49 83 c5 18 4c 89 e8 48 c1 e8 03 <42> 0f b6 04 30 84 c0 0f 85 7b 02 00 00 41 8b 6d 00 4c 89 f8 48 c1
RSP: 0018:ffffc90004997850 EFLAGS: 00010206
RAX: 0000000000000003 RBX: ffffffff8251bdfe RCX: ffff888175390000
RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
RBP: 0000000000000001 R08: ffffffff8251bdfe R09: ffffffff8e558220
R10: dffffc0000000000 R11: fffffbfff1fdf4ef R12: ffff8881078adaa0
R13: 0000000000000018 R14: dffffc0000000000 R15: ffff8881169793f8
FS:  000000c00007a898(0000) GS:ffff88818e0d7000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000c002961200 CR3: 000000016d248000 CR4: 00000000000006f0
----------------
Code disassembly (best guess), 1 bytes skipped:
   0:	49 83 c4 20          	add    $0x20,%r12
   4:	4c 89 e0             	mov    %r12,%rax
   7:	48 c1 e8 03          	shr    $0x3,%rax
   b:	42 80 3c 30 00       	cmpb   $0x0,(%rax,%r14,1)
  10:	74 08                	je     0x1a
  12:	4c 89 e7             	mov    %r12,%rdi
  15:	e8 3a f2 da ff       	call   0xffdaf254
  1a:	4d 8b 2c 24          	mov    (%r12),%r13
  1e:	49 83 c5 18          	add    $0x18,%r13
  22:	4c 89 e8             	mov    %r13,%rax
  25:	48 c1 e8 03          	shr    $0x3,%rax
* 29:	42 0f b6 04 30       	movzbl (%rax,%r14,1),%eax <-- trapping instruction
  2e:	84 c0                	test   %al,%al
  30:	0f 85 7b 02 00 00    	jne    0x2b1
  36:	41 8b 6d 00          	mov    0x0(%r13),%ebp
  3a:	4c 89 f8             	mov    %r15,%rax
  3d:	48                   	rex.W
  3e:	c1                   	.byte 0xc1


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[brauner@kernel.org jack@suse.cz jannh@google.com kees@kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org luto@amacapital.net viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

