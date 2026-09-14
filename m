Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 402C137F316
	for <syzbot@lists.linux.dev>; Mon, 14 Sep 2026 05:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789365156; cv=none; b=Czmkg1nV9Rw5hMs5gv08URc1um5ITC1thLkSCBbt7aZVBI+ax16BI6VfM7EV293JgsjVowXkIZgXdqf4DB9EjPejg/RKFPDNjIiYv7LlkACMxEZXHw5w14q7WJlCLYDY0IkpOAwV32W8ozSRWOkHm5nOkT5wOQRY+YBHL/xFGKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789365156; c=relaxed/simple;
	bh=49McLGmdh4gqjpazamNTyQ4kwv21m+4IzBeGeF8mZr0=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=dYsvPcWwnbqRg5IUfm+7gNL8sl7/RrGxcjJDq4Q4yINYctCmid2Bm7JURtojSHw+WRoXcR9IO0mA5S4ahi6enQL1x15heR0j8YdduW2wrMG5b9vcN4Pr5QJABUAhldREdqWmBs+QeCHxWFBJtetitOcZFpP+ge9XkZ304wgwhTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-805fa97ca69so2144152a34.1
        for <syzbot@lists.linux.dev>; Sun, 13 Sep 2026 22:52:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789365150; x=1789969950;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=uedeTyIom8DRVbm/g6emmP0/amhpXNmPjke2UAbReNo=;
        b=tJpeb0kSyhV4GOj9Ji8zZgB9LYcogeU7jKVHxzy4IS/QLYN8oNHXW8jGRuwx1V/ilk
         2IGefaEIZ/5DSOhAPILGMUD9wH6zs61t14nCFnC6L7X5iZ7YpGTmYnlYGf4AdwUslzax
         3667EzhG+Mjo3+FNmHRi7FqLWdpYI1HKn/NeoyczXBmldEw4aigq1kSmk2Mu6fYERfR5
         n0mUYvZgyAaDgkzq9q1pDf92TZyj08VYCGzGhxDi3doJ0N2TyXJUdJcP7JhrbhU4UdUH
         Yw49UcXqu5Ewh2DaPj9gNzUoGrc2xo6/VSuBSc7DKNMUH93DkkREWDWggH9KgxH4Bi7q
         Qy1w==
X-Gm-Message-State: AFuF++mR27LlFz+Ho1SFiEdDDEaO1PaUS8Mi0iwAhDbhdDt2NMe3xQ9I
	gcHEY3HhmAngWuBed5ZEr8gVM5BkS5iwfIkLIxIZPCpypNYIWzETqlsde0bK7sLe6UFMJpSl4sS
	i6nKrBwPHW1i3wS5ST7NadMZXdB8dLQqRr05fLYAVDzhRmcBx0vdE6lwi+Bk=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:2685:b0:6c3:ad5f:abe1 with SMTP id
 006d021491bc7-6c53fc70fd1mr460777eaf.21.1789365149842; Sun, 13 Sep 2026
 22:52:29 -0700 (PDT)
Date: Sun, 13 Sep 2026 22:52:29 -0700
In-Reply-To: <20260913152802.13413-1-drifabdelmalekmohamedsaid@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aa78b9d.f81106d8.2ab401.0040.GAE@google.com>
Subject: [syzbot ci] Re: dcache: fully initialize the inline name in __d_alloc()
From: syzbot ci <syzbot+cif320737e2d884f65@syzkaller.appspotmail.com>
To: brauner@kernel.org, drifabdelmalekmohamedsaid@gmail.com, 
	dvyukov@google.com, glider@google.com, jack@suse.cz, 
	kmsan-dev@googlegroups.com, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, syzbot@syzkaller.appspotmail.com, 
	viro@zeniv.linux.org.uk
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] dcache: fully initialize the inline name in __d_alloc()
https://lore.kernel.org/all/20260913152802.13413-1-drifabdelmalekmohamedsaid@gmail.com
* [PATCH] dcache: fully initialize the inline name in __d_alloc()

and found the following issue:
KASAN: null-ptr-deref Read in __d_alloc

Full report is available here:
https://ci.syzbot.org/series/5b221ae6-70dc-4b99-963a-3d9e7db97db0

***

KASAN: null-ptr-deref Read in __d_alloc

tree:      vfs
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/vfs.git
base:      f5d607b8091438d8416d0e3ae02532a18539b48b
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/9b8e9369-7fc0-4fbd-a090-6f785f103d1b/config

kfence: initialized - using 2097152 bytes for 255 objects at 0xffff88823c400000-0xffff88823c600000
Console: colour VGA+ 80x25
printk: console [ttyS0] enabled
printk: console [ttyS0] enabled
printk: legacy bootconsole [earlyser0] disabled
printk: legacy bootconsole [earlyser0] disabled
Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
... MAX_LOCKDEP_SUBCLASSES:  8
... MAX_LOCK_DEPTH:          48
... MAX_LOCKDEP_KEYS:        8192
... CLASSHASH_SIZE:          4096
... MAX_LOCKDEP_ENTRIES:     1048576
... MAX_LOCKDEP_CHAINS:      1048576
... CHAINHASH_SIZE:          524288
 memory used by lock dependency info: 106625 kB
 memory used for stack traces: 8320 kB
 per task-struct memory footprint: 1920 bytes
mempolicy: Enabling automatic NUMA balancing. Configure with numa_balancing= or the kernel.numa_balancing sysctl
ACPI: Core revision 20260408
clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604467 ns
APIC: Switch to symmetric I/O mode setup
x2apic enabled
APIC: Switched APIC routing to: physical x2apic
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x285c3ee517e, max_idle_ns: 440795257231 ns
Calibrating delay loop (skipped) preset value.. 5599.99 BogoMIPS (lpj=27999980)
Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
mitigations: Enabled attack vectors: user_kernel, user_user, guest_host, guest_guest, SMT mitigations: auto
Speculative Store Bypass: Vulnerable
Spectre V2 : Mitigation: Retpolines
ITS: Mitigation: Aligned branch/return thunks
MDS: Vulnerable: Clear CPU buffers attempted, no microcode
Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sanitization
Spectre V2 : Spectre v2 / SpectreRSB: Filling RSB on context switch and VMEXIT
active return thunk: its_return_thunk
x86/fpu: x87 FPU will use FXSAVE
pid_max: default: 32768 minimum: 301
landlock: Up and running.
Yama: becoming mindful.
TOMOYO Linux initialized
AppArmor: AppArmor initialized
LSM support for eBPF active
debugfs: Unable to create file 'net_refcnt@ffffffff9aedda40', debugfs is not initialized yet
debugfs: Unable to create file 'net_notrefcnt@ffffffff9aeddab8', debugfs is not initialized yet
Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes, vmalloc hugepage)
Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes, vmalloc hugepage)
Mount-cache hash table entries: 16384 (order: 5, 131072 bytes, vmalloc)
Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes, vmalloc)
==================================================================
BUG: KASAN: null-ptr-deref in __d_alloc+0x65/0x7b0
Read of size 40 at addr 0000000000000000 by task swapper/0/0

CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150
 kasan_report+0x117/0x150
 kasan_check_range+0x264/0x2c0
 __asan_memcpy+0x29/0x70
 __d_alloc+0x65/0x7b0
 d_make_root+0x41/0x80
 shmem_fill_super+0xc07/0x1090
 get_tree_nodev+0xbb/0x150
 vfs_get_tree+0x92/0x2a0
 vfs_kern_mount+0x15b/0x220
 kern_mount+0x43/0x90
 shmem_init+0x37/0x170
 mnt_init+0x19b/0x1f0
 vfs_caches_init+0x22/0x30
 start_kernel+0x34c/0x3e0
 x86_64_start_reservations+0x24/0x30
 x86_64_start_kernel+0x137/0x1b0
 common_startup_64+0x13e/0x157
 </TASK>
==================================================================


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
