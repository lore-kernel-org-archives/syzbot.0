Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D60A32EBBA8
	for <syzbot@lists.linux.dev>; Thu,  4 Sep 2025 10:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756982472; cv=none; b=oTvW0HBXnlykaPm55tDd9KhIbLtRSsWbwv4QHROTjwUab0iWZYmiOuLDorHUsL9s8YmIXFT43aTQSdH+jv7Y8t9d1DR5bahGUdGJsdut956wpNIt1qAS83EiDQOrilP4G2YGND50VbgGSCkVxdV892W68dAu599zd2NbY1oH9Fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756982472; c=relaxed/simple;
	bh=3+a3IB4oO3ltLzX47NxKmsFlnNC09H4ZX4yWSYaJ4DE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=loCQ+TvK6o9DiFbExUTEPDxdhXwlHRtiSqmwgm7lrDg29fVLcMnUYdu9ehNZUl5XPhxeSUrrKF6VMkfndfhHgXD+7i8vpFI+dK1Y2W3FY7FFnRkxfWpMCtfRlkEP6b86haNL4DwbseuJC7vZSBdFYcvKvBYXbRr8xsQ8k9+pOQg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ed39b8563cso19446515ab.1
        for <syzbot@lists.linux.dev>; Thu, 04 Sep 2025 03:41:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756982470; x=1757587270;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=d5Ydvs3V14HrC72+IwRrxXukL/IqHbo4g5cVXlx9SLA=;
        b=tyWt/ybk+9SImPXu55d97pDpmZsbbzfXlKECopMDxARmkiuy951zGkV3whY9M7CpAR
         1FGY75DkYbdpbocJYGtq8LnfjysDFiIettTFtcPv2UtoTuPS1ZYCfiKxyhIvt4WxxJ1Y
         6G7/GbQh2g0a2Opex2c/4lRmbHcxQZkwav/6z9KsRmTplvDqZtMxf1l4IJe95CAg+Ayb
         zzgWmEYxmYi+PMIgGiJ1p/o9GtNFO4Z3qJlkAWHRjeP6IBT1+FaaC71kMVmpk29ZxlS6
         k6fTlQOboo9by3is4TgE5eI6h8Q/pOcK9b2IcKXfU3dS2V4hUPDcms0ovcgRnnK9iD6Y
         XkrQ==
X-Gm-Message-State: AOJu0YyvwZTjo4ECB+1X8SsWTG+l2EkjgCCyFIrc9iOKmN/svEUlyVJ5
	fwi7LZxuAcYeH4oKONasNtPdSX3dLGPCK4JJyo0ikyE3yy5UMzvSp4+rNx2otEmtuQWT+vFfQCm
	16aixa4kGstrYRkIyKU5+cF/OPqz3nRiitceiMAgD8iC2EHpywQOAemc1dSQ=
X-Google-Smtp-Source: AGHT+IHP5nkhSjEAlq0O+VLctUUxL4WFO4zpj1wiYJsegNjzFAFImJCBqFXsQZnjFjdVl+HZtGvW8cwfMSvoC9cURZVTAax8aBmT
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:ca4f:0:b0:3f6:5f94:2847 with SMTP id
 e9e14a558f8ab-3f65f9429ddmr73785585ab.24.1756982470066; Thu, 04 Sep 2025
 03:41:10 -0700 (PDT)
Date: Thu, 04 Sep 2025 03:41:10 -0700
In-Reply-To: <357638f71edc7f1d9814b1851a64e09a8895bffc.1756968204.git.joeypabalinas@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b96cc6.a00a0220.eb3d.0003.GAE@google.com>
Subject: [syzbot ci] Re: fork: simplify overcomplicated if conditions
From: syzbot ci <syzbot+ci452e2303ac12cc31@syzkaller.appspotmail.com>
To: joeypabalinas@gmail.com, kees@kernel.org, linux-kernel@vger.kernel.org, 
	linux-mm@kvack.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
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
