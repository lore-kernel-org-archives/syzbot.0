Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D7AF280A56
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 10:10:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787739055; cv=pass; b=lbMObOjUF5cDZhDmFUcIrFsBzsOTKJVfeju8yB0ctN9+IcEP6HNx1OxXOypttJYXgGRIbTqosrQPuSnpyfsfTkQsZ0p9r3hCjOeAmdxJRlSE7lOVQCnyod5QN1M1b6Kb4vKj/JflS6hpnTbzgaQZqoVwut3GKyj5fJRjFCMej7U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787739055; c=relaxed/simple;
	bh=NoI8W5lcWiGFro1QH7QZDgBl5DM/+SJ31u0O5f5xwiU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SWRDoaldMDYFk1enlHb3r+NXxnWzvboSxN4XBsjtYSmxemCYp2yUQ7SB/U56l60o6JurWaQUMAWaQ1xcoBKNnhu9K5ryKpajDHRzYv6dlbqrVH969TqsggLnyTTOixI20Q6w09IaT0ZcItoshTtQKkhESkomh8NGglTjLJj/XSI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Qf6Tm4hI; arc=pass smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Qf6Tm4hI"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-4b21f71613fso731144b6e.2
        for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 03:10:53 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787739052; cv=none;
        d=google.com; s=arc-20260327;
        b=bP7ZqiIpGuRYsy5LkQL4I1obdqOVupn323u0BtnV+s0AUlU5zum6ApiVORvF659Nho
         UX3hx2aRriI4KyCGLUB46E7cYzgOLrrWdKRGeBu2Uy99+11ZrWDbLu1S3unlwESt/7nk
         5P7rLy8iOsjrITHXEOBqVi9jadPEQLzCo7RnWtIhqbxQJpO4w+wZPkCw6lFbU/Ujp2Q9
         hNtKCHUQd/DHjFTb23v1t9NuzIsCo6cSGcGkpLWmLbQSzksOv0GZwPO/a6ZlOS2+7sz/
         SsoCHv+AmsBgMyR6L3eOp1JVTcVeHX1eCL7g0Ur4GFzyywQZodXFyfvjIE50yUlpGJdV
         uvUw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=are7GAOJpeI9vU8HbwMtmKFVabdeUAk5UckVzmVMBl0=;
        fh=0iwG3elTSo45dD9YkUcYE6KLvRaT/+QzcjBWAhL4VEI=;
        b=EabyhUNMR+VsBopYYJeu8Vg68ZWi1vLtaT8yWcCaWaQIX0930wh5hwjG48QYJC+OOV
         1VSeDyXoRtnV3wUkirhqt0F2P5CryuHaLG/YdlMckurWWddo3r0wqcLxQEAxbokuIGpo
         s+2cA2Rx8y0o4UbuepA75IbDGhaOnoiJ09h3r42BoXkvGnYPeMrwLMLFdxuIk8VurWkB
         9egM5k7Kwlq9h4IbxgpPECulW7MtsbPA0X6Tp+TVN5fQtbBqR3R65SpqqIkofUnAgVWI
         zAqsCI0DSuLzJGY0PcUPU4gIFjoDE4s98KORYQkwJD5L9uqUha6ATASVKm/a1E6ZJKoG
         NVpg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787739052; x=1788343852; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=are7GAOJpeI9vU8HbwMtmKFVabdeUAk5UckVzmVMBl0=;
        b=Qf6Tm4hInZ2S563ON7DTtYr82UxI7ENZyj1yYI+mg1O7ONniP9UbuuYS2enEoSNYql
         TFSAMsN5xwt4OG+l9QN9hcjud/mepPTehKzLLqPAyVR1KlXbmYuASFrTeQCAcaoxzf/v
         jHnIPDhEwaqA7DIo2vH1EGU0c+1LX4+CjfWBX0K5WCfV4QQR9Db4R606M7ryJ4Oil3YW
         vNG5qhsovsj6orfJtQ6asxWDRK1e3We0B/7smR/cbJCYr8arnyILWWCtRtkRH3+BDC2Q
         1sV2vHxsV+/lSwI0Ae4XuDx7fZHA68+bwcA4+GVgjLoAHPD7asu39bZRnHmJLYzSKlDP
         q8/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787739052; x=1788343852;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=are7GAOJpeI9vU8HbwMtmKFVabdeUAk5UckVzmVMBl0=;
        b=S+SkjkjYIiYBJfunzQpQBaC/0YDeoBDNOrZJSnC7Qm/nX261y0MbwLiFjGQgJBsEma
         oCYtMCAzmeEeW8M/jHWI6Indw2g40X29gsRvRhanijF6keNMQ6BN/yDyDzcLA+obXvza
         Ui6GtHzygOjNmDb5f11KgqkKuaEa0boW4643qvBMG4WuD0tnc9chJCyVvSj5igMdzZ9N
         XJRlpMfm40CWK9K/MWbBW6ZRz+88+edp/Kh49SBMfikfihxnUJknkfCjCMWkX/j05cGD
         Pu1gd7QAUlUTA6wthDRhLwm6TBvroSSiG4d9T/9tz9trbxXHv9gSDOK/ivDuhJs8Ro+9
         xTqg==
X-Forwarded-Encrypted: i=1; AHgh+RqgK/8vbxGVGhNPgmamUI+lX19eywB+fen8983J9ztTIn/kJtud1sYq0DCH5r9OoAdRRkKEhhM=@lists.linux.dev
X-Gm-Message-State: AFuF++lSuYmUptCzlCuFKyZRT5llOzTgJI7ZpKlteISKDobr0S9kNsWw
	/TSKRTlZIMzuohJtHMI68wFkZtK62R3L8zcPEp6m8WLaILUGGnrYnF9/EpaoCh9huCCE/dZ+kFj
	JnoU6RWbRY6oVV1RWljw3z7ErEAnQ2d6Aqjsk/0Gl
X-Gm-Gg: AR+sD11fx4h2eDC/oqwlKI+O54mg0/PABKngOBocjK/Pg6oAkuUdrJbot2p0lRcxzDR
	L+ihMFPIZ+6Bi8RIIQYGch1fMXBjBHI3uif+boN5+D3ReY6x2adOduILKPB/DenYmGHl85Y5yGF
	X2BJKIitSjvCeh3p/wilonIKzyFboSAm2f9zjh+aZAFFl8hwHf0Y/Q66nJBCW9TYtJgkoiap9/o
	Z4yYIb+v4Qvxevq6lu+bLHCy1ITmwS8iHOyT6SzDAeixjvad28QA7Zb98YEIzQoqXp9y7ML4p1D
	NS85u8Hm/beMp/94i4QmRvYCBvU4O1MBMOONbz6apJ0hn9IMQLD+izueqvhf/Gv3UaTBjpr+b/N
	81zfRK3q2IB4ypDaZ/1HprzU5yyBgsCXyMcK+0p+szcmRksDAOfoE+WLHg4/2/XUKcwJBKzRrLW
	j7wXX/hbfINMqK
X-Received: by 2002:a05:6820:81ca:b0:6a0:ff94:df7b with SMTP id
 006d021491bc7-6b1a05dc85fmr5228301eaf.35.1787739051678; Wed, 26 Aug 2026
 03:10:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a8eb9af.1d9ded08.62e62.009f.GAE@google.com>
In-Reply-To: <6a8eb9af.1d9ded08.62e62.009f.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 26 Aug 2026 12:10:40 +0200
X-Gm-Features: AcwNN1WKb66BRi9Mguzb820mfUIZ54R_tatx2qSofRDOICmiRsczK_5mp5nZ0SU
Message-ID: <CANp29Y54_toFJQcJ_wGFZyTpA5JjL4S3Jtiip_YSAy8w7TTLaA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: nfc: llcp: Fix race condition in accept_queue lifecycle
To: syzbot ci <syzbot+ci0ac53bc2df24efd0@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Aug 26, 2026 at 12:02=E2=80=AFPM syzbot ci
<syzbot+ci0ac53bc2df24efd0@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] nfc: llcp: Fix race condition in accept_queue lifecycle
> https://lore.kernel.org/all/20260826075703.2400467-1-lee@kernel.org
> * [PATCH v2 1/1] nfc: llcp: Fix race condition in accept_queue lifecycle
>
> and found the following issue:
> WARNING in __alloc_workqueue
>
> Full report is available here:
> https://ci.syzbot.org/series/6f4e9aed-2eea-44c2-8ef0-04ce578d399f
>
> ***
>
> WARNING in __alloc_workqueue
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      a8406e6c0b793ce0788019683837c40855b55995
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/3abfab5f-31c6-4773-9338-bbe1caeca=
14d/config
>
> pci 0000:00:1f.2: [8086:2922] type 00 class 0x010601 conventional PCI end=
point
> pci 0000:00:1f.2: BAR 4 [io  0xc0a0-0xc0bf]
> pci 0000:00:1f.2: BAR 5 [mem 0xfebf2000-0xfebf2fff]
> pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500 conventional PCI end=
point
> pci 0000:00:1f.3: BAR 4 [io  0x0700-0x073f]
> ACPI: PCI: Interrupt link LNKA configured for IRQ 10
> ACPI: PCI: Interrupt link LNKB configured for IRQ 10
> ACPI: PCI: Interrupt link LNKC configured for IRQ 11
> ACPI: PCI: Interrupt link LNKD configured for IRQ 11
> ACPI: PCI: Interrupt link LNKE configured for IRQ 10
> ACPI: PCI: Interrupt link LNKF configured for IRQ 10
> ACPI: PCI: Interrupt link LNKG configured for IRQ 11
> ACPI: PCI: Interrupt link LNKH configured for IRQ 11
> ACPI: PCI: Interrupt link GSIA configured for IRQ 16
> ACPI: PCI: Interrupt link GSIB configured for IRQ 17
> ACPI: PCI: Interrupt link GSIC configured for IRQ 18
> ACPI: PCI: Interrupt link GSID configured for IRQ 19
> ACPI: PCI: Interrupt link GSIE configured for IRQ 20
> ACPI: PCI: Interrupt link GSIF configured for IRQ 21
> ACPI: PCI: Interrupt link GSIG configured for IRQ 22
> ACPI: PCI: Interrupt link GSIH configured for IRQ 23
> iommu: Default domain type: Translated
> iommu: DMA domain TLB invalidation policy: lazy mode
> SCSI subsystem initialized
> ACPI: bus type USB registered
> usbcore: registered new interface driver usbfs
> usbcore: registered new interface driver hub
> usbcore: registered new device driver usb
> mc: Linux media interface: v0.10
> videodev: Linux video capture interface: v2.00
> pps_core: LinuxPPS API ver. 1 registered
> pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <gio=
metti@linux.it>
> PTP clock support registered
> EDAC MC: Ver: 3.0.0
> Advanced Linux Sound Architecture Driver Initialized.
> Bluetooth: Core ver 2.22
> Bluetooth: Core ver 2.22
> NET: Registered PF_BLUETOOTH protocol family
> Bluetooth: HCI device and connection manager initialized
> Bluetooth: HCI socket layer initialized
> Bluetooth: L2CAP socket layer initialized
> Bluetooth: SCO socket layer initialized
> NET: Registered PF_ATMPVC protocol family
> NetLabel: Initializing
> NetLabel:  domain hash size =3D 128
> NetLabel:  protocols =3D UNLABELED CIPSOv4 CALIPSO
> NetLabel:  unlabeled traffic allowed by default
> nfc: nfc_init: NFC Core ver 0.1
> ------------[ cut here ]------------
> workqueue: nfc_llcp_wq is using neither WQ_PERCPU or WQ_UNBOUND. Setting =
WQ_PERCPU.
> WARNING: kernel/workqueue.c:5939 at __alloc_workqueue+0x1cd2/0x1fe0, CPU#=
1: swapper/0/1
> Modules linked in:
> CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__alloc_workqueue+0x1cd5/0x1fe0
> Code: 0b 90 e9 6d fc ff ff e8 f9 f0 38 00 e9 7f fb ff ff e8 ef f0 38 00 e=
9 85 fb ff ff e8 e5 f0 38 00 48 8d 3d 3e 1a ee 0e 4c 89 f6 <67> 48 0f b9 3a=
 41 81 cf 00 01 00 00 e9 10 e6 ff ff e8 c5 f0 38 00
> RSP: 0000:ffffc90000067788 EFLAGS: 00010293
> RAX: ffffffff818ecbbb RBX: 0000000000000000 RCX: ffff888102adda00
> RDX: 0000000000000000 RSI: ffff8881680b0d70 RDI: ffffffff907ce600
> RBP: ffffffff8d4e3fa0 R08: ffff888102adda00 R09: 0000000000000002
> R10: 0000000000000102 R11: 0000000000000000 R12: ffff8881680b0c00
> R13: ffff8881680b0c00 R14: ffff8881680b0d70 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff8882a8ce0000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000000eb48000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  alloc_workqueue_noprof+0xe3/0x210
>  nfc_llcp_init+0x15/0x50
>  nfc_init+0x74/0xa0
>  do_one_initcall+0x250/0x870
>  do_initcall_level+0x10a/0x1a0
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x29d/0x3e0
>  kernel_init+0x22/0x1d0
>  ret_from_fork+0x514/0xb70
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
> [davem@davemloft.net david@ixit.cz edumazet@google.com horms@kernel.org k=
uba@kernel.org lee@kernel.org linux-kernel@vger.kernel.org netdev@vger.kern=
el.org oe-linux-nfc@lists.linux.dev pabeni@redhat.com sameo@linux.intel.com=
 szymon.janc@tieto.com]
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
-upstream-moderation/6a8eb9af.1d9ded08.62e62.009f.GAE%40google.com.
