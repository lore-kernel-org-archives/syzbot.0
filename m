Received: from mail-qv1-f46.google.com (mail-qv1-f46.google.com [209.85.219.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3E9937F324
	for <syzbot@lists.linux.dev>; Mon, 14 Sep 2026 05:50:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789365026; cv=pass; b=OcAQ/gXaJC1gBm9oRKlG4QFwfIUDKHGGqcyZxIn4DgeqBZkJKCbYCHBT3jeTW+KnpC7ilZH/NLZfk1g5c7OPFrPDaUDJ/fK9UI0o9aO9/9f4zUH75bZZb2+cVpZsZT9WBfbGGG7q6e5gwS4m1MFMxgCAC/Br4q4E098DSW24I5k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789365026; c=relaxed/simple;
	bh=0NpjVL785y1kpAbtmGUGVpQnJuI0PAGfbCdCy/rApK4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KG38hFBL2CNxF5BydQulrMavS3CzdlzgPRsgrlP1nci19PQeWyG93HWhUmw+1PJPd6yU2NrdZsof70IL0G0l/LUeCfol/FBldLG1AJqkqaxt/gwDlUf5CHjtSg/mi0t8A6M/nbK7shMNiUbGrR8ZLIidBMRKDAI1+3RXDSx7acw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vl65BNZO; arc=pass smtp.client-ip=209.85.219.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vl65BNZO"
Received: by mail-qv1-f46.google.com with SMTP id 6a1803df08f44-90e7c71f86eso23089276d6.1
        for <syzbot@lists.linux.dev>; Sun, 13 Sep 2026 22:50:21 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789365019; cv=none;
        d=google.com; s=arc-20260327;
        b=sxTjbe7ML6meGeSeq8m94oxqwdLDscPObXy69E2b2F/RvGt6KXYj6LAWqhMzs3hQUz
         L24F5vExR9Nr1pm8LgKj1XIX4JOuczLtVKMLdYfutPIrUfdNtBbRnvI8ugMb0acwMcUQ
         1LTSUUShRsuBlysed3cLG2AbXaBsp3ApnbaXEGrBbjPZSXPSXGQItl5t5INJrF+Z6dVf
         iORk2ij7vi2zHya6WjP9qxmxQ871OJVPJe8Eaw+eYdAPlJCs3Od4LB/kHS4NQyKf1myO
         suf5WMbU20uarPoi+Fm/inKCVN8+BU6sndvttRymS/jK+ZWoUqLFXE7BOlcT1XmE/eJX
         34wQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=hmwSmw/D/sWH+RFCFEc45AbNKO3eiOsUPGtKSci9Csw=;
        fh=IHxRwEaTszAOClII4f9YivfSs3wB4CMhdYOVXFWAFbk=;
        b=gdNNb2K9GTXjPE2649hPvy060d0r9YFmuZh0fTZWqexy0zjNA5g3YWbWpfd/aaDqgw
         3Ck4/AAgLztMO+EvsHywMsocoa7hWbidojFkaQtGu0wsyIgq8JHMOn0RyVBa+/Jndr/r
         HBXE1Wut094y9qq6im6qiLEtJZoOuqT5YT5IA4AGuFm8F1jwlfRkzV/Arfrekd4Smgis
         Jbj/Ak6ztSFlGH/q6dJbSzzITzFg3JgR2K8IMPuvOqTLwNfKq/Ex18cvKwEOsHegxIar
         lOdp5Qte7TMDK8ydNIu47/1Mq20XcVJZi+CjQprG0TpO54a+8ldwSiyKQxw+kktYjqeV
         5w3Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789365019; x=1789969819; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=hmwSmw/D/sWH+RFCFEc45AbNKO3eiOsUPGtKSci9Csw=;
        b=Vl65BNZOFka3jcOcT+dbMEo+2DYZd3Lif6CHplkTupBXG5PkxlBYEH2tjQSqw2ENMl
         XVaNxgGS/CqbNcjAZ0h5tRpBwx/dGd1wIw13qqfQ1+1mUNfEZf5E7EARbVYhHGMbbUL6
         Pm3NwyNFpQbi3SsTRONEAFfKRSKTqigWl0hJwWk8D2EbeCbExO4Ybr82UGhpUddjzXLw
         DQJeZS56msgsLeAF4F4XY6hwCUxKcAVqJDGPdS3+1faiW6bppNAmQlaZkZbMqzlFlCmt
         v/ik5DwxiAdoo0wl7PG4M0bjeqBDgl0ErJCyo4ZBwYj24qzXcxSgcXmTCZ7v4b9oAq7a
         PBng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789365019; x=1789969819;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=hmwSmw/D/sWH+RFCFEc45AbNKO3eiOsUPGtKSci9Csw=;
        b=BG8Vj4li9ZqcXAum0sBzzKYAQJ65C6EUg3Dq+KJq/WvvIh/5u6ON2P2Oh2x04G6J6X
         aRfb/68hP2/oBTyVW+Pqk+l+v4WKTBQhO3oejdMMLn1RXl2mspTEeOuGdXZU8BnDke/V
         csykoljxx9duUIoktDtyqsb/khPCRCsCl2y1tzGWz4DrWUpPOTllGMcdOwqTNJvOboZz
         3ObPweHKtr4Xkbeuhjxpiu6YmZ9lWCeY+KlTjDppxkWPBnjTJBOnzwd0TIYKqXGglkOK
         MXEZfDVcU8y+bimfwvU8N98aeBAXlTZijlQvYLwvJuqg6EqN8n8V4CF6ju1bC21TbUhZ
         dWgA==
X-Forwarded-Encrypted: i=1; AKwUvBxEYscuEscVbYew/lYSTzYukYp3gcBsTypHeWKMXsgoRAOcoIoyy2RYC0lYrud4n+QHxJVcoSo=@lists.linux.dev
X-Gm-Message-State: AFuF++mYGBIl6NzgK6qpRuMjypwCBDYO7U5ohS6MIdjhqZ5r8IlsAgYi
	+TbrWc2No93f/kmSioKaHiIY8GZ0o04eaSyI4h+zitbQh5mFcIur/6Uh8VO/ZJxlgEdk1YkCP8i
	XkhsCz1Ev5qVDvlT71VkVRBWl8XF0a+VlTFQfq5hC
X-Gm-Gg: AYBFou26Tfcf0nPkbP3rF3ilnnPCp+KR8ekQKiM8UO44NYAFOocG8v/gtnFdn0LxHzA
	2yj+NpJPKLDKTeosvkhM2lrp7wIPUaNmchjh0gYE1gVcMIsF4iXPM/jZy8Lb7zBfMcyTKhHERAg
	DSg8DSc3tedTWwxCPaH40W6smig7W8y2X84rjdDyARLLmbN5FWsgeM1BIN4U3VAoJM9Ykif03t4
	nJ938zm1p34cMSVTMRNVnCbkzJWmLsLTKmDAghfdXIn8gis/qOjKEuSNEP4cf1CS+Xv3Jc8Xo35
	ceUrn+tX5yAcSM2++Mf1M+6QjN1dRPpxFqC7Sf7Ag9HOVhVW9cEFDAPMc5uMCh30hRSqyJPVX4X
	cltkiByea7j+jJbNIeVUkHRNAL+mWuhx9nA4xM1+DG7Yj/Q==
X-Received: by 2002:ac8:5981:0:b0:531:475:4cf0 with SMTP id
 d75a77b69052e-5310cfefac9mr16272931cf.29.1789365018673; Sun, 13 Sep 2026
 22:50:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6aa6d7cd.016ef6ab.da411.0001.GAE@google.com>
In-Reply-To: <6aa6d7cd.016ef6ab.da411.0001.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Mon, 14 Sep 2026 07:50:07 +0200
X-Gm-Features: AcwNN1XeeEdoh5zRrn829xuzcFSHQjOFtiS0u1AARgqTc3KvzFvDwTdgFf0R0wc
Message-ID: <CAJWNTGwBq4=ii2j0gtmO59d1Vy7Jws7Wrujp1uekVKUKEWEa+g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: dcache: fully initialize the inline name in __d_alloc()
To: syzbot ci <syzbot+cif2be4177c5e76dc5@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sun, Sep 13, 2026 at 7:05=E2=80=AFPM syzbot ci
<syzbot+cif2be4177c5e76dc5@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] dcache: fully initialize the inline name in __d_alloc()
> https://lore.kernel.org/all/20260913152802.13413-1-drifabdelmalekmohameds=
aid@gmail.com
> * [PATCH] dcache: fully initialize the inline name in __d_alloc()
>
> and found the following issue:
> KASAN: null-ptr-deref Read in __d_alloc
>
> Full report is available here:
> https://ci.syzbot.org/series/5b221ae6-70dc-4b99-963a-3d9e7db97db0
>
> ***
>
> KASAN: null-ptr-deref Read in __d_alloc
>
> tree:      vfs
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/vfs/v=
fs.git
> base:      f5d607b8091438d8416d0e3ae02532a18539b48b
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/9b8e9369-7fc0-4fbd-a090-6f785f103=
d1b/config
>
> kfence: initialized - using 2097152 bytes for 255 objects at 0xffff88823c=
400000-0xffff88823c600000
> Console: colour VGA+ 80x25
> printk: console [ttyS0] enabled
> printk: console [ttyS0] enabled
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
> ACPI: Core revision 20260408
> clocksource: hpet: mask: 0xffffffff max_cycles: 0xffffffff, max_idle_ns: =
19112604467 ns
> APIC: Switch to symmetric I/O mode setup
> x2apic enabled
> APIC: Switched APIC routing to: physical x2apic
> ..TIMER: vector=3D0x30 apic1=3D0 pin1=3D2 apic2=3D-1 pin2=3D-1
> clocksource: tsc-early: mask: 0xffffffffffffffff max_cycles: 0x285c3ee517=
e, max_idle_ns: 440795257231 ns
> Calibrating delay loop (skipped) preset value.. 5599.99 BogoMIPS (lpj=3D2=
7999980)
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
> pid_max: default: 32768 minimum: 301
> landlock: Up and running.
> Yama: becoming mindful.
> TOMOYO Linux initialized
> AppArmor: AppArmor initialized
> LSM support for eBPF active
> debugfs: Unable to create file 'net_refcnt@ffffffff9aedda40', debugfs is =
not initialized yet
> debugfs: Unable to create file 'net_notrefcnt@ffffffff9aeddab8', debugfs =
is not initialized yet
> Dentry cache hash table entries: 1048576 (order: 11, 8388608 bytes, vmall=
oc hugepage)
> Inode-cache hash table entries: 524288 (order: 10, 4194304 bytes, vmalloc=
 hugepage)
> Mount-cache hash table entries: 16384 (order: 5, 131072 bytes, vmalloc)
> Mountpoint-cache hash table entries: 16384 (order: 5, 131072 bytes, vmall=
oc)
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: null-ptr-deref in __d_alloc+0x65/0x7b0
> Read of size 40 at addr 0000000000000000 by task swapper/0/0
>
> CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  kasan_report+0x117/0x150
>  kasan_check_range+0x264/0x2c0
>  __asan_memcpy+0x29/0x70
>  __d_alloc+0x65/0x7b0
>  d_make_root+0x41/0x80
>  shmem_fill_super+0xc07/0x1090
>  get_tree_nodev+0xbb/0x150
>  vfs_get_tree+0x92/0x2a0
>  vfs_kern_mount+0x15b/0x220
>  kern_mount+0x43/0x90
>  shmem_init+0x37/0x170
>  mnt_init+0x19b/0x1f0
>  vfs_caches_init+0x22/0x30
>  start_kernel+0x34c/0x3e0
>  x86_64_start_reservations+0x24/0x30
>  x86_64_start_kernel+0x137/0x1b0
>  common_startup_64+0x13e/0x157
>  </TASK>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [brauner@kernel.org drifabdelmalekmohamedsaid@gmail.com dvyukov@google.co=
m glider@google.com jack@suse.cz kmsan-dev@googlegroups.com linux-fsdevel@v=
ger.kernel.org linux-kernel@vger.kernel.org syzbot@syzkaller.appspotmail.co=
m viro@zeniv.linux.org.uk]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6aa6d7cd.016ef6ab.da411.0001.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
