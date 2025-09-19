Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FB56253351
	for <syzbot@lists.linux.dev>; Fri, 19 Sep 2025 10:08:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758276496; cv=none; b=XZq51fsSoDDydcgrCTZE7iDuLhb3GPaeaUAJBy0XBw19EqUHiyYUS5gxHxuQmnc9n1WiS+BST8bpYy/RoAQYmF+KEeTgMElGRzu5ex9njEI56eVgzzDe+uw4sMMGPc3mSOfDF8yaSuGMjy+sgWGf32IVvHQE3FO9zVibLdon4Co=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758276496; c=relaxed/simple;
	bh=dFd7y3VySgz804qsDPN9znRKVnWGavTMSyNy4jDR6/k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=owgl8AkkZuQbXWrdSFuAvThxl9tSWiHBfLufDMZphLy+f2w44nGbf5d3x0nqVM0jO0VH+LTa4hbgTLLpqjvQ+XS1EpIkknjlwI4/qkm7zChYbCIeyplyxjyMNoSXvwDS5YziTHVv29yPuQTQhRC7u7bl3VCr0uDNyQrdsDqLwiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Yv0pbB7c; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Yv0pbB7c"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-621b965a114so989112eaf.1
        for <syzbot@lists.linux.dev>; Fri, 19 Sep 2025 03:08:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758276493; x=1758881293; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9Xsd0WGnjpmUvtcvmairXIx5/RXbnvvbDZV+hIADI3Y=;
        b=Yv0pbB7c4wL7Ux711nShVZYST5Xf4e8u75Lgz69wsofuR8oYHZFkCKIk2JjsfYvkDO
         9b3FCxm/HRigPoouzBcSF1VoQKY+Js8fojp+i52egS1FxGSpksdjmqxxi9wX611wdn6L
         Xja/lFC9RZQhswPqIebHo6Zu7Xh066OpuG3UX0HbYwJikx6xjupkNTwGq4enHTo4HzUR
         izg3VqTk4niIwlbNjT0xn6O1wE0CWKeUzQDDK8PtrKmFeo9r6UNVmIsNhzQZb74hQuWw
         dLpVMUOAwC1TYvDO9iVsCSRxEVzIJEMN12Ojan1rjizKWcwR+8TuJ1b+jLWPH9GgolNw
         5Azw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758276493; x=1758881293;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=9Xsd0WGnjpmUvtcvmairXIx5/RXbnvvbDZV+hIADI3Y=;
        b=vPo5Gbb1xy00yvEEK1W4VVQtLHeqwEKTk1uprfy3nCjj+lKEfpqsb04H/1l7jrDJJg
         foMkYToO1pY3v9FMdL8awoDTGUGh94P1YBNzYPeHSSkccThkyKTCQj/5r0Y7xjfz7lQD
         mB7/V+vHBb9vnv5E/RWs28i+izc3/c4oa6VACZ59y03Or1kIVzyqtPJUNx/854hexZdD
         X165yI5+UsdyO5eLz3EqvwhTmvgQGuZuf1kwLAYg16dHFgrB3uBfHM6Sn30u8+V0o3m6
         ntOwXLJ+EvBImi2hOL5aF3m7ntTtWbqFxPt/4hEDEOx9c3wmLBxpr8hpJ144XdCB3j6+
         Ou8A==
X-Forwarded-Encrypted: i=1; AJvYcCUrtKdgMJMTm2KUMw/FqSfZYjXsTobJzw2tz5ZiaHUkgpzQjnxLrtbdgQwg0UrJjjXm9ngmUFw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxyPN1sVCIGrouBaUf4Illh8XsYWkDm7EC+dkaNFw14xwTCFkcM
	aBMnWpfGcM+6GqOO8egyRl3BFkJtRGQQEe+uxPfJvlaZW3rqGEVGag2JOY3Ydo7zY7DTrAk3edj
	HnBpStD1tB4pGaEpP/3tGtIrTA9GgHA3nYxWGNiqt
X-Gm-Gg: ASbGncuFdgET5oNuDVKNt656JmOeC25l+5+T1vUti6idPiqIjRWGlGdRb86AssUlmDx
	Q8OpQuC8ycEV8jPqI/GOdqvG2zSseLB13E9R5QOjvM9p81LClNj/sPJ2edpNfhJX2cyL3HCxFTf
	xBSDZaTADk87osy64Ly82H5t4yxI/9L4YzNNMxapQRLUzvSKvhakiLX42LMokdgn1mgGd9hYSys
	otyWjEyxKrqZcy24NHAWjYCPNOpR9P3LLQv3w==
X-Google-Smtp-Source: AGHT+IFOJo+7ic7SFXfMp/KKwQfgHhaskLWop9zYYy6MHjxupm5ggzqE1qCpfdQMuGwqH/nWxBtuPVaBv8u4yHe2Tvs=
X-Received: by 2002:a05:6820:160c:b0:623:42cb:243 with SMTP id
 006d021491bc7-6272a608737mr1159275eaf.4.1758276493268; Fri, 19 Sep 2025
 03:08:13 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68cc97f9.050a0220.139b6.000b.GAE@google.com>
In-Reply-To: <68cc97f9.050a0220.139b6.000b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 19 Sep 2025 12:08:01 +0200
X-Gm-Features: AS18NWBCYJ4BK4-jUFO-8E2ZOFtvXsYgTtPn11Uj5HWlTqMIojjh839wnZK2lb0
Message-ID: <CANp29Y6AOo1qOGHMT9SVJ5SME07uj7gmUAYkZHPt8gPTAfjEXQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: kernel: Introduce multikernel architecture support
To: syzbot ci <syzbot+cid1ab3854931cd1b5@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Sep 19, 2025 at 1:38=E2=80=AFAM syzbot ci
<syzbot+cid1ab3854931cd1b5@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] kernel: Introduce multikernel architecture support
> https://lore.kernel.org/all/20250918222607.186488-1-xiyou.wangcong@gmail.=
com
> * [RFC Patch 1/7] kexec: Introduce multikernel support via kexec
> * [RFC Patch 2/7] x86: Introduce SMP INIT trampoline for multikernel CPU =
bootstrap
> * [RFC Patch 3/7] x86: Introduce MULTIKERNEL_VECTOR for inter-kernel comm=
unication
> * [RFC Patch 4/7] kernel: Introduce generic multikernel IPI communication=
 framework
> * [RFC Patch 5/7] x86: Introduce arch_cpu_physical_id() to obtain physica=
l CPU ID
> * [RFC Patch 6/7] kexec: Implement dynamic kimage tracking
> * [RFC Patch 7/7] kexec: Add /proc/multikernel interface for kimage track=
ing
>
> and found the following issue:
> WARNING in note_page
>
> Full report is available here:
> https://ci.syzbot.org/series/9ca759c7-776a-4d45-a2f9-5e6ca245e989
>
> ***
>
> WARNING in note_page
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      f83ec76bf285bea5727f478a68b894f5543ca76e
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/645f543b-aa06-4977-81f2-45a0b44a2=
133/config
>
> Key type fscrypt-provisioning registered
> kAFS: Red Hat AFS client v0.1 registering.
> Btrfs loaded, assert=3Don, ref-verify=3Don, zoned=3Dyes, fsverity=3Dyes
> Key type big_key registered
> Key type encrypted registered
> AppArmor: AppArmor sha256 policy hashing enabled
> ima: No TPM chip found, activating TPM-bypass!
> Loading compiled-in module X.509 certificates
> Loaded X.509 cert 'Build time autogenerated kernel key: 75e3f237904f24df4=
a2b6e4eae1a8f34effb6643'
> ima: Allocated hash algorithm: sha256
> ima: No architecture policies found
> evm: Initialising EVM extended attributes:
> evm: security.selinux (disabled)
> evm: security.SMACK64 (disabled)
> evm: security.SMACK64EXEC (disabled)
> evm: security.SMACK64TRANSMUTE (disabled)
> evm: security.SMACK64MMAP (disabled)
> evm: security.apparmor
> evm: security.ima
> evm: security.capability
> evm: HMAC attrs: 0x1
> PM:   Magic number: 9:738:504
> usb usb41-port1: hash matches
> usb usb40-port2: hash matches
> netconsole: network logging started
> gtp: GTP module loaded (pdp ctx size 128 bytes)
> rdma_rxe: loaded
> cfg80211: Loading compiled-in X.509 certificates for regulatory database
> Loaded X.509 cert 'sforshee: 00b28ddf47aef9cea7'
> Loaded X.509 cert 'wens: 61c038651aabdcf94bd0ac7ff06c7248db18c600'
> clk: Disabling unused clocks
> ALSA device list:
>   #0: Dummy 1
>   #1: Loopback 1
>   #2: Virtual MIDI Card 1
> check access for rdinit=3D/init failed: -2, ignoring
> md: Waiting for all devices to be available before autodetect
> md: If you don't use raid, use raid=3Dnoautodetect
> md: Autodetecting RAID arrays.
> md: autorun ...
> md: ... autorun DONE.
> EXT4-fs (sda1): mounted filesystem b4773fba-1738-4da0-8a90-0fe043d0a496 r=
o with ordered data mode. Quota mode: none.
> VFS: Mounted root (ext4 filesystem) readonly on device 8:1.
> devtmpfs: mounted
> Freeing unused kernel image (initmem) memory: 26168K
> Write protecting the kernel read-only data: 210944k
> Freeing unused kernel image (text/rodata gap) memory: 104K
> Freeing unused kernel image (rodata/data gap) memory: 300K
> ------------[ cut here ]------------
> x86/mm: Found insecure W+X mapping at address 0xffff888000096000
> WARNING: CPU: 1 PID: 1 at arch/x86/mm/dump_pagetables.c:248 note_page+0x1=
2a5/0x14a0
> Modules linked in:
> CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:note_page+0x12a5/0x14a0
> Code: d5 49 00 c6 05 bd 7d 17 0e 01 90 43 80 3c 2e 00 74 08 4c 89 ff e8 9=
b 47 ad 00 49 8b 37 48 c7 c7 40 98 88 8b e8 1c 53 0d 00 90 <0f> 0b 90 90 49=
 bd 00 00 00 00 00 fc ff df e9 5a f1 ff ff 44 89 f9
> RSP: 0000:ffffc90000047678 EFLAGS: 00010246
> RAX: 0829288c8ce4fa00 RBX: ffffc90000047cf0 RCX: ffff88801c2d0000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000002
> RBP: 0000000000000001 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffffbfff1bfa274 R12: ffffffffffffffff
> R13: dffffc0000000000 R14: 1ffff92000008fb2 R15: ffffc90000047d90
> FS:  0000000000000000(0000) GS:ffff8881a3c09000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000000df36000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ptdump_pte_entry+0xc6/0xe0
>  walk_pte_range_inner+0x1ba/0x380
>  walk_pgd_range+0x1467/0x1d40
>  walk_page_range_debug+0x312/0x3d0
>  ptdump_walk_pgd+0x126/0x320
>  ptdump_walk_pgd_level_core+0x260/0x3e0
>  kernel_init+0x53/0x1d0
>  ret_from_fork+0x439/0x7d0
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
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
> [akpm@linux-foundation.org bhe@redhat.com changyuanl@google.com cwang@mul=
tikernel.io graf@amazon.com kexec@lists.infradead.org linux-kernel@vger.ker=
nel.org linux-mm@kvack.org pasha.tatashin@soleen.com rppt@kernel.org xiyou.=
wangcong@gmail.com]
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
-upstream-moderation/68cc97f9.050a0220.139b6.000b.GAE%40google.com.
