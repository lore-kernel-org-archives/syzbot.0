Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE3C27081F
	for <syzbot@lists.linux.dev>; Thu,  4 Sep 2025 09:53:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756979620; cv=none; b=Zvqg6rwxWaVCx7jBQ2TXih3ys/cuXesOLSqPaxHjyeEMRPn/y4BdSELfdg06oKkBNFEbOnynXV7SwJ58EMYZMZ5onqHY26LhUOo8f4wYaWIigzt7G9+2VGw/9dv3UY8qviY1XByMccqL5u9PlM/bJ7nL2qxGwS1RNYsADexfIsQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756979620; c=relaxed/simple;
	bh=pn/V9Bv8YWrXuApTJwDqn1nubnyQMgUa7ZaQjOClLls=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=UUkXdgACPDC4mgDBUhsWoK3jKZdqP6Am9qS49J1z+XL6opmfw/RFiSkjEH5Yt70j97E1vnHN9CmBRplrFpDRlvm96a4dU6yQtEZsBTZNgDCXAibsP2vaucHhOIHTuc5ahAHAP8srWp3cXXM/SVoSemNO23M65Ahgffng6oK377g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-3efa61f3ab5so15592385ab.3
        for <syzbot@lists.linux.dev>; Thu, 04 Sep 2025 02:53:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756979618; x=1757584418;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=yOhkA5kd5m+hKFCEA6ruMFChQoy4OpVl4HBtGwV6rzI=;
        b=FsoPyWe5RexTH0VJlwUuxRPlV8y7IbY+hCptxU8A04bVol7FhCwsY1ozi0wPKCk2It
         QWCRJtFU74NDBWAPM+dES9pi5Uw6KSn4BIkklJo7a0HTjHWHrSJQ7YeJ8iz3D3f1HiUE
         doB6Wnnk586CLbBBp1Ym80Ge+IgTsN5vrjENhZ0Lk22u83G6MKdOCdQnw7XcMdkMnCQE
         3a0Y9JXKjm7KOiKfCoJELaLkeP7iGCcATOnVCbiGCPTiGA6cvSu2ddCqsSxgIdpF+vIE
         MbZzbj4H1k5KV4ZctH6rAr8sWnjl7QyKv/RVcYNMKXF0M5R5Hr14fj/i07f2+33S+KYX
         FHIw==
X-Gm-Message-State: AOJu0YxWMkmwYu0sVw7ew7w9k11LVBT1xHhKRXYvwlsRQrSw/FJH8kns
	7ECArkhxXx8c/3P+BimJ+/F0qWDChXXglTd86pXUSHjcRhlBKg8aYBOq6vjuH5I5sT0EdMe0bjh
	mLeDc5mNRdRhZc4V+/YVZQxGq1aT4b+5sW0S5HjVQXgxGgRymKXaMgvsyJCw=
X-Google-Smtp-Source: AGHT+IHUYa6rDWJNy8i9Hw1flwPjjxkgauQ7zWYBgplqNlZ4WIvoIr30Mlz3wukVOnO+Jt7/k6IszbZSnn3dhes/mwbNaYlHoWBf
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:218d:b0:3f2:6b55:64ba with SMTP id
 e9e14a558f8ab-3f401be67d2mr300117605ab.18.1756979618093; Thu, 04 Sep 2025
 02:53:38 -0700 (PDT)
Date: Thu, 04 Sep 2025 02:53:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b961a2.050a0220.192772.0003.GAE@google.com>
Subject: [moderation/CI] Re: fork: simplify overcomplicated if conditions
From: syzbot ci <syzbot+cic99c5c3d31031c2f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] fork: simplify overcomplicated if conditions
https://lore.kernel.org/all/357638f71edc7f1d9814b1851a64e09a8895bffc.1756968204.git.joeypabalinas@gmail.com
* [PATCH] fork: simplify overcomplicated if conditions

and found the following issue:
general protection fault in rest_init

Full report is available here:
https://ci.syzbot.org/series/e9c440d7-f494-4207-a59d-773bbbf909ff

***

general protection fault in rest_init

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      b320789d6883cc00ac78ce83bccbfe7ed58afcf0
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/58676b34-5a2d-40b9-ab9d-b45b8161dd5c/config

Console: colour VGA+ 80x25
printk: legacy console [ttyS0] enabled
printk: legacy console [ttyS0] enabled
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
ACPI: Core revision 20250404
clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: 19112604467 ns
APIC: Switch to symmetric I/O mode setup
x2apic enabled
APIC: Switched APIC routing to: physical x2apic
..TIMER: vector=0x30 apic1=0 pin1=2 apic2=-1 pin2=-1
clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x285d45cc0d6, max_idle_ns: 440795339158 ns
Calibrating delay loop (skipped) preset value.. 5600.55 BogoMIPS (lpj=28002760)
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
Freeing SMP alternatives memory: 136K
pid_max: default: 32768 minimum: 301
LSM: initializing lsm=lockdown,capability,landlock,yama,safesetid,tomoyo,apparmor,bpf,ima,evm
landlock: Up and running.
Yama: becoming mindful.
TOMOYO Linux initialized
AppArmor: AppArmor initialized
LSM support for eBPF active
Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes, vmalloc hugepage)
Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes, vmalloc hugepage)
Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, vmalloc)
Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, vmalloc)
Running RCU synchronous self tests
Running RCU synchronous self tests
Oops: general protection fault, probably for non-canonical address 0xdffffc0000000005: 0000 [#1] SMP KASAN PTI
KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:rest_init+0xf8/0x300
Code: f6 49 bf 00 00 00 00 00 fc ff df 89 ef 48 c7 c6 40 57 fe 8d e8 e9 47 12 f6 49 89 c6 48 89 c7 48 83 c7 2c 48 89 f8 48 c1 e8 03 <42> 0f b6 04 38 84 c0 0f 85 d9 01 00 00 41 80 4e 2f 04 e8 e1 e3 ff
RSP: 0000:ffffffff8de07ee0 EFLAGS: 00010207
RAX: 0000000000000005 RBX: ffffffff8b79fc61 RCX: ffffffff8de95100
RDX: 0000000000000000 RSI: ffffffffffffffea RDI: 000000000000002c
RBP: 00000000ffffffea R08: 0000000000000000 R09: ffffffff8b79fc61
R10: dffffc0000000000 R11: fffffbfff1f47207 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b8618000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 start_kernel+0x3a9/0x410
 x86_64_start_reservations+0x24/0x30
 x86_64_start_kernel+0x143/0x1c0
 common_startup_64+0x13e/0x147
 </TASK>
Modules linked in:
---[ end trace 0000000000000000 ]---
RIP: 0010:rest_init+0xf8/0x300
Code: f6 49 bf 00 00 00 00 00 fc ff df 89 ef 48 c7 c6 40 57 fe 8d e8 e9 47 12 f6 49 89 c6 48 89 c7 48 83 c7 2c 48 89 f8 48 c1 e8 03 <42> 0f b6 04 38 84 c0 0f 85 d9 01 00 00 41 80 4e 2f 04 e8 e1 e3 ff
RSP: 0000:ffffffff8de07ee0 EFLAGS: 00010207
RAX: 0000000000000005 RBX: ffffffff8b79fc61 RCX: ffffffff8de95100
RDX: 0000000000000000 RSI: ffffffffffffffea RDI: 000000000000002c
RBP: 00000000ffffffea R08: 0000000000000000 R09: ffffffff8b79fc61
R10: dffffc0000000000 R11: fffffbfff1f47207 R12: 0000000000000000
R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff8880b8618000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 00000000000006f0


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[joeypabalinas@gmail.com kees@kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org]

If the report looks fine to you, reply with:
#syz upstream

