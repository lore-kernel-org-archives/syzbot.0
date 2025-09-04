Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8742F90E2
	for <syzbot@lists.linux.dev>; Thu,  4 Sep 2025 10:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756982374; cv=none; b=RfsEn1fr9mppTwjUhv7CHP0mobLy0vDlGKrWhHmqMA0CUT34KRsMG1Cbh2R5kqd00QZ2jEdJMafHY/tfwvE+P8gj6kokO920NvfxYLjTYHgX3106JXprweqTzDpNPjepsdIIH8rj7sMU0l6DeOxViQJDlPcTxV1DpS4isKM/8pM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756982374; c=relaxed/simple;
	bh=ZKqiR5DXW31YJGe0zumXmQxotKPKA9B1TITgHUwViIM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=St4g1Z4ipgFKnhkwzG9b8Efh9SQwwQGXUsVwUXb1kJ8X5pzhsriewkut5FUEPN/AfElGmsA/2CaHEigWSo5De6ab62gRwfZ2oanBTc1XneaSwVnqBLfk/nEZcXlZu9EfPi6GRpdZS0ibJ0u1+EY3ZrjJYQdj+Guv9ccVcj80J90=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ns84T1iK; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ns84T1iK"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-61e47ee70d3so514448eaf.2
        for <syzbot@lists.linux.dev>; Thu, 04 Sep 2025 03:39:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756982371; x=1757587171; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sOZ/+YCf3wGnH7u6+FcFNeBqc5ov8jaLFf6pCo5pEFA=;
        b=Ns84T1iKG9jHNEdjM5ju5Ki9Nq3jABjspDtAS6jM0eCV7hjrR6vyYUyLs2J6q3LmeY
         KSMuy7nZ3em3NMrKvOsjFneELSTIraOBxNLnfO0Ihf2oXX2q1QaOWItVv9HLlFWcTos0
         6G7BkUs6QsOHdLoVfO7mLiW1NG6POedzc4Ty7Zo8Xe6SdWA2/++qYYrRkVmr3uKi14GY
         rzQZWgr+spKCpBFw2oVg+2dPSXexHFwlEUPD4YcaeWMXDJ9YZRuJvkFR54BxNP9zfaR8
         6HwR4jDZ8s6oAzpy+GKEcb4XMVJkmQLqpuW2n257kRkjs6KofEJZ6NoEKiJtDzUDxQNM
         n0sQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756982371; x=1757587171;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=sOZ/+YCf3wGnH7u6+FcFNeBqc5ov8jaLFf6pCo5pEFA=;
        b=QIK2w4PwpWgH5fo7XVnSB6Id7fAwYzt6DQiJ2EFRZ+f7ToK8X1b5FdaZw6XrB1Ttlc
         EV1bFgCQU1CUXXbvKVQNicJnyyH5w7V+IDFa+a+VrpZ9k6ehqFTcZlU6x15xhTRFpe8H
         xQ0z+SJ/5uLj8vyGbEp8aYRk8BrBCitlf2uOMEg2w/eYEW6+JGR+tLs7AzbWVZQ8LYIv
         2LDZMtfZmn55BnKucNYpFOP+tL9y3R7JPXZnK9V/nNa9DpEPBMewDlRZkboJCpUe1xhT
         x6XmdwIDOfsesgOsEEWEZLKJ22CtGx5SBOfTUfHpbz0z+NH653vpQkr7RfpEGIoMoEPi
         0bQA==
X-Forwarded-Encrypted: i=1; AJvYcCVdwI1KG6Fu9lAusGQuDKLDgS1Ve3thvqMMFmWWrg7K4DWECUeRayUkLUAVsvfzxJWjg5KEPHY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyoyoemu0fEYVuHyJ/qqKdAjuAvNz3vtSF2hK7aXoehPFluuGSR
	n4SkNH0ydlSNX6hzhWlnNzTILDb2uqGtBw6X2rr6kV9EIUEfHxhSAmvEUesLb36cMf9bHI5g/Ek
	Qbzru+StWD2g/ZS9TatnqpC2WhsGSk6FO++yRzuqX
X-Gm-Gg: ASbGncvdVNk/cmqu2v92VbafkOktwNJF584Z2n0LMFXJlA0L7n4BdA7Us5QNhD5ymMX
	sRF+0a0u9ZuAlcovTM/WUtx1Aw1bvj+VxgQF7ggH1y3w2oI/ILqUk5trX/bOnyQ6SfSV4M2VUR0
	4lUhrKWmm7UXGSYjdbLG4EurTHfAoZKEWSa3WIQ04dek0pduSJgm+aVAGVerx7ZfG7B0ikU/uAj
	XdoaEHl5z7OfcumktjAzcvBOhar2c+b39OQkp3StNT3
X-Google-Smtp-Source: AGHT+IF8MGnfdiFW87wS93wdAFlJ2buE8jJAQFKASOjILihyTHioLYaQXLF4bT4vrpXkaVRWfM3+6HSTOKQQ4e7ThDQ=
X-Received: by 2002:a05:6820:1c83:b0:61e:1d9d:fd87 with SMTP id
 006d021491bc7-61e337c35dbmr9379690eaf.6.1756982371045; Thu, 04 Sep 2025
 03:39:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68b961a2.050a0220.192772.0003.GAE@google.com>
In-Reply-To: <68b961a2.050a0220.192772.0003.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 4 Sep 2025 12:39:19 +0200
X-Gm-Features: Ac12FXyQB5aBU215Hn80GyVg0cfOF7Hji-dW1TDdrZXkgRWQB9Sqp25W4Gc19aI
Message-ID: <CANp29Y6kU9YyEvBintNWxCx3Oo4zVuvN-v0sZhKg=pDC6n=xxg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fork: simplify overcomplicated if conditions
To: syzbot ci <syzbot+cic99c5c3d31031c2f@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Sep 4, 2025 at 11:53=E2=80=AFAM syzbot ci
<syzbot+cic99c5c3d31031c2f@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] fork: simplify overcomplicated if conditions
> https://lore.kernel.org/all/357638f71edc7f1d9814b1851a64e09a8895bffc.1756=
968204.git.joeypabalinas@gmail.com
> * [PATCH] fork: simplify overcomplicated if conditions
>
> and found the following issue:
> general protection fault in rest_init
>
> Full report is available here:
> https://ci.syzbot.org/series/e9c440d7-f494-4207-a59d-773bbbf909ff
>
> ***
>
> general protection fault in rest_init
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      b320789d6883cc00ac78ce83bccbfe7ed58afcf0
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/58676b34-5a2d-40b9-ab9d-b45b8161d=
d5c/config
>
> Console: colour VGA+ 80x25
> printk: legacy console [ttyS0] enabled
> printk: legacy console [ttyS0] enabled
> printk: legacy bootconsole [earlyser0] disabled
> printk: legacy bootconsole [earlyser0] disabled
> Lock dependency validator: Copyright (c) 2006 Red Hat, Inc., Ingo Molnar
> ... MAX_LOCKDEP_SUBCLASSES:  8
> ... MAX_LOCK_DEPTH:          48
> ... MAX_LOCKDEP_KEYS:        8192
> ... CLASSHASH_SIZE:          4096
> ... MAX_LOCKDEP_ENTRIES:     1048576
> ... MAX_LOCKDEP_CHAINS:      1048576
> ... CHAINHASH_SIZE:          524288
>  memory used by lock dependency info: 106625 kB
>  memory used for stack traces: 8320 kB
>  per task-struct memory footprint: 1920 bytes
> mempolicy: Enabling automatic NUMA balancing. Configure with numa_balanci=
ng=3D or the kernel.numa_balancing sysctl
> ACPI: Core revision 20250404
> clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: =
19112604467 ns
> APIC: Switch to symmetric I/O mode setup
> x2apic enabled
> APIC: Switched APIC routing to: physical x2apic
> ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
> clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x285d45cc0d=
6, max_idle_ns: 440795339158 ns
> Calibrating delay loop (skipped) preset value.. 5600.55 BogoMIPS (lpj=3D2=
8002760)
> Last level iTLB entries: 4KB 0, 2MB 0, 4MB 0
> Last level dTLB entries: 4KB 0, 2MB 0, 4MB 0, 1GB 0
> mitigations: Enabled attack vectors: user_kernel, user_user, guest_host, =
guest_guest, SMT mitigations: auto
> Speculative Store Bypass: Vulnerable
> Spectre V2 : Mitigation: Retpolines
> ITS: Mitigation: Aligned branch/return thunks
> MDS: Vulnerable: Clear CPU buffers attempted, no microcode
> Spectre V1 : Mitigation: usercopy/swapgs barriers and __user pointer sani=
tization
> Spectre V2 : Spectre v2 / SpectreRSB: Filling RSB on context switch and V=
MEXIT
> active return thunk: its_return_thunk
> x86/fpu: x87 FPU will use FXSAVE
> Freeing SMP alternatives memory: 136K
> pid_max: default: 32768 minimum: 301
> LSM: initializing lsm=3Dlockdown,capability,landlock,yama,safesetid,tomoy=
o,apparmor,bpf,ima,evm
> landlock: Up and running.
> Yama: becoming mindful.
> TOMOYO Linux initialized
> AppArmor: AppArmor initialized
> LSM support for eBPF active
> Dentry cache hash table entries: 524288 (order: 10, 4194304 bytes, vmallo=
c hugepage)
> Inode-cache hash table entries: 262144 (order: 9, 2097152 bytes, vmalloc =
hugepage)
> Mount-cache hash table entries: 8192 (order: 4, 65536 bytes, vmalloc)
> Mountpoint-cache hash table entries: 8192 (order: 4, 65536 bytes, vmalloc=
)
> Running RCU synchronous self tests
> Running RCU synchronous self tests
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000005: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000028-0x000000000000002f]
> CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:rest_init+0xf8/0x300
> Code: f6 49 bf 00 00 00 00 00 fc ff df 89 ef 48 c7 c6 40 57 fe 8d e8 e9 4=
7 12 f6 49 89 c6 48 89 c7 48 83 c7 2c 48 89 f8 48 c1 e8 03 <42> 0f b6 04 38=
 84 c0 0f 85 d9 01 00 00 41 80 4e 2f 04 e8 e1 e3 ff
> RSP: 0000:ffffffff8de07ee0 EFLAGS: 00010207
> RAX: 0000000000000005 RBX: ffffffff8b79fc61 RCX: ffffffff8de95100
> RDX: 0000000000000000 RSI: ffffffffffffffea RDI: 000000000000002c
> RBP: 00000000ffffffea R08: 0000000000000000 R09: ffffffff8b79fc61
> R10: dffffc0000000000 R11: fffffbfff1f47207 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff8880b8618000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  start_kernel+0x3a9/0x410
>  x86_64_start_reservations+0x24/0x30
>  x86_64_start_kernel+0x143/0x1c0
>  common_startup_64+0x13e/0x147
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:rest_init+0xf8/0x300
> Code: f6 49 bf 00 00 00 00 00 fc ff df 89 ef 48 c7 c6 40 57 fe 8d e8 e9 4=
7 12 f6 49 89 c6 48 89 c7 48 83 c7 2c 48 89 f8 48 c1 e8 03 <42> 0f b6 04 38=
 84 c0 0f 85 d9 01 00 00 41 80 4e 2f 04 e8 e1 e3 ff
> RSP: 0000:ffffffff8de07ee0 EFLAGS: 00010207
> RAX: 0000000000000005 RBX: ffffffff8b79fc61 RCX: ffffffff8de95100
> RDX: 0000000000000000 RSI: ffffffffffffffea RDI: 000000000000002c
> RBP: 00000000ffffffea R08: 0000000000000000 R09: ffffffff8b79fc61
> R10: dffffc0000000000 R11: fffffbfff1f47207 R12: 0000000000000000
> R13: 0000000000000000 R14: 0000000000000000 R15: dffffc0000000000
> FS:  0000000000000000(0000) GS:ffff8880b8618000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88813ffff000 CR3: 000000000df36000 CR4: 00000000000006f0
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [joeypabalinas@gmail.com kees@kernel.org linux-kernel@vger.kernel.org lin=
ux-mm@kvack.org]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/68b961a2.050a0220.192772.0003.GAE%40google.com.
