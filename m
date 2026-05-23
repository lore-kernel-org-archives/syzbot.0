Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B9D1145FE0
	for <syzbot@lists.linux.dev>; Sat, 23 May 2026 06:59:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779519558; cv=pass; b=qYToc1m1SJHlL4ho40Sh1Sq1NirYmmmQhh+ZjAo8IKg2qlg8ldAeSjGnuLOkKzXoSTbply+ZZzQjcR+QFBHvIpBUFPcWBOHeatHROHI8D3Lj4Z0eQI5QbvFesfinehn22GNmiM8uBVlrIKv/KsZ6fYZXDPaQ3rDLFeSkE/kNYNw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779519558; c=relaxed/simple;
	bh=CZyCnq6uH68fysbnMsdDju8pA5Nf1lqfUUyotXBF9Pc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=go3+wM6H1x6wljKdkvEdXoV/Ob7SXcOL/32yjjCHVYbkrHbGBfjs3TNTm5Q4TvfD0aHRqw4v7UoPwqLEttP+Uss/RIbfDeuLtOyRKvyP9+lDKxVr1DC9aAJdRA/6ec4ps7SNVuQ+rczvp5ds/s/8ko0oXpb+WR6n6NXck27nkbc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EUHfsc8w; arc=pass smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EUHfsc8w"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-4855003f70bso1010608b6e.1
        for <syzbot@lists.linux.dev>; Fri, 22 May 2026 23:59:16 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779519555; cv=none;
        d=google.com; s=arc-20240605;
        b=ekujMn/JbwrYTo68nE0FSoawZ88BcOlNNfGYjIowOCQB2S3L1j8MVpDRxubciKbjcX
         SthCa93UzhBF9HD69nRncKzSbaKyfVy4rAw1mLlRdanZKavAX6nbqm1/ZVDkUYgnEsZ3
         uwibSP081TXYnf9Ow0iWkHODb079f4bhLK+NW7Sp4zOSdYtp900weNn1ZxfiDrr/FFa5
         yrmPPc0tyI9zYfQVhr6X7aZsTJ33QwUuwYkB1f3JeQ7UDp7/tCg67RZoF1+6+LhBa4Fr
         vRb9F/NCvKT9wX6zhN0eQ+/Ojti84oc4Va7oX2niaiHOua8Fp1AxEUP6IaBcji27DBgn
         ok0A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=cTIRRfftwFmXggzbr1/c/Svqt6llbWQOsqQmW4iHCPE=;
        fh=4c/gX0pggrBxZhNaUhhNanmLuyyNe1cWLSxER8/LR0g=;
        b=EzRNK0XJUVJeCh7Jl4ehClkAypg91PGFnAXvw6Davkn2eN5sDFGKJM1gx5xVQVHwBW
         KBeA+IC3rgzP3q6NcExYo9alDD3DOPNt6JYwkdi8aUzH5MyaaazlrOYqC1fTLMJFhTtY
         MRPqnIoJVgzgdFJkHWx3U9w8aNhVlYbjbnIzF/g+g9aP/pcenmhw58TyMj9cuQznEASX
         GHfFbv3suAWgfcxVAw1UU5sP8DrMGySZ8vGA255JtoFkwdpYny/OITn+Ge4iZdeG7bhB
         8XJptvNpPLTX9WHVCytMjtnwh5sXp/oZWWC9cRGdomHPGknIpJq1pW+0qffiMMKoAgtj
         Wrew==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779519555; x=1780124355; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cTIRRfftwFmXggzbr1/c/Svqt6llbWQOsqQmW4iHCPE=;
        b=EUHfsc8wYbEx+Jjdki57q3y66s7UxRU1An7WVjDzyMVm3xXj/6VvJqv4TsNQ+NBd/V
         xIzF4aLu8be+LL5AppZs1r11LfCL8UWtqv8JGYLTKLOkmhhqvHOgApfyVK8AYopa18F4
         QWvgdXmmjE9BQ6xEYKgu+dZR4VBB6WUfbF/f8KTdB9cNXERmTiCoRVedFjWJ/A74PZo5
         EG+Pa/vbq4MZDC4NYDeLDwV0QhfpcQvCVaxy0T/02vmGbsoQ4hcmRf4bqQM+ljX2jTte
         6tJ2YqLfcZjWAsUvInNeycfnchVZYG+EEmWNSPrG7IRfwoa6Jk8isS3pavmuUwvCkt0v
         hGPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779519555; x=1780124355;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cTIRRfftwFmXggzbr1/c/Svqt6llbWQOsqQmW4iHCPE=;
        b=qO9A0qS2Rd/9zAH3I5bAhBI4H/z07P/G+gfuAMZNwXLwGE8evhd0a2hssPHm5/lzJa
         aoq1v3s3pPSDdXxjurI38IOPLpFEVLxFpnIBDB69m4gCwxY/29eyRhHSqWIZIE56zzNe
         a2w3jBarIL9gJwMt0FxDImGgVt05KBAC0cmO3cw5oI6/k3iW+UIFSVx0+rZiN0wyIIJo
         H51A8PCl1HE4Bx4AXGkgc7AgvOM3hnTq1ak7p0DZY+p7we8a7FEA7teBvRog6v7gYCIJ
         21ioOw11vZMgVSTT/YAoHdBmL17VH/zu00105CcT39+jEPACIFgvpPIHAhdfwgkEFcaG
         TcEQ==
X-Forwarded-Encrypted: i=1; AFNElJ+v6grmlJ8F4Nkh2VWYfuQkZTZqJLGVbvmzjZB3RYwFiTdReSz84iJg9y4qRUDU+eNMmXylETs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfhywyYEStkxKpaukW1JPxSaZr8g4XlEYmC2gFfZFEt5CDdjBA
	+XCsVKNaxcgQ5/Z6LrEzXbzuDM65msguepAtCMml40B1Wz9oHrbz/4vEfknaPXEU1Icq+uj1utX
	nIj9xb5Vo06FKT8aWbQutfkx30C9iITfmLt2T37M/
X-Gm-Gg: Acq92OFYE63f+eLYOwMc1d5PFXBT0IuL53qXP8p6XX/6Z1O0Y+8toEkwO7sFC/nHCz9
	pB7oXYAnXSEQ7rHgzQGBBudMLccQf9lrjvpMfM0kque1Vcn20IGlrf9lBiCn8V5+pK/70X37+1+
	HggChK6pmALU24/DVBHz1Bl8heIrMgULONhhZXnHYnWiRUeofxoys5bd9OJ/pPQJJ7WRTaj5vUV
	WDF40rCR8VHCnO/RgVsqNQ/QJfpQRXqfadLuboCyIBj1lAGJ6Gbxcawwvnb0jhmDF86VEghXPpG
	02VPzoBna3USSTdXxwteN/pO30DdkY5RqxWZGcFi/OOyM2QovU1MvzpDMlXpDk/rXUR/P3zQ3gs
	uhPMR/+zoF9ZGL0RD2Q==
X-Received: by 2002:a05:6808:23c9:b0:485:507:ee5d with SMTP id
 5614622812f47-48549ecf8c8mr4685018b6e.10.1779519554516; Fri, 22 May 2026
 23:59:14 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a10da6d.050a0220.3c3a9.0003.GAE@google.com>
In-Reply-To: <6a10da6d.050a0220.3c3a9.0003.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 23 May 2026 08:59:03 +0200
X-Gm-Features: AVHnY4IQ8dHOCPP0JT2MfFvtPdm48RCgxvKiFs7gHdwqHDoUPkSLM-bquF6Bxm0
Message-ID: <CANp29Y7huka2Lk7TyCx-UMSnCdduxnihnovKfTNVKJxLnEyRwg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: rtnetlink: RTNL avoidance in rtnl_getlink()
 and rtnl_dump_ifinfo()
To: syzbot ci <syzbot+cia53038b9c9ac18e9@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, May 23, 2026 at 12:36=E2=80=AFAM syzbot ci
<syzbot+cia53038b9c9ac18e9@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] rtnetlink: RTNL avoidance in rtnl_getlink() and rtnl_dump_ifinfo()
> https://lore.kernel.org/all/20260522173002.2181677-1-edumazet@google.com
> * [PATCH v4 net-next 1/5] rtnetlink: use nla_nest_end_safe() in rtnl_fill=
_prop_list()
> * [PATCH v4 net-next 2/5] net: defer netdev_name_node_alt_flush() call to=
 netdev_run_todo()
> * [PATCH v4 net-next 3/5] rtnetlink: do not acquire RTNL in rtnl_getlink(=
) with RTEXT_FILTER_NAME_ONLY
> * [PATCH v4 net-next 4/5] rtnetlink: do not assume RTNL is held in link_m=
aster_filtered()
> * [PATCH v4 net-next 5/5] rtnetlink: add RTEXT_FILTER_NAME_ONLY support t=
o rtnl_dump_ifinfo()
>
> and found the following issue:
> WARNING in rtmsg_ifinfo_build_skb
>
> Full report is available here:
> https://ci.syzbot.org/series/583940d4-d5e9-48ca-a2e6-544edbb1d63c
>
> ***
>
> WARNING in rtmsg_ifinfo_build_skb
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      1a1f055318d82e64485a6ff8420e5f70b4267998
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/513a249e-70b7-4622-8d72-6f6284095=
5c7/config
>
> pci 0000:00:01.0: BAR 2 [mem 0xfebf0000-0xfebf0fff]
> pci 0000:00:01.0: ROM [mem 0xfebe0000-0xfebeffff pref]
> pci 0000:00:01.0: Video device with shadowed ROM at [mem 0x000c0000-0x000=
dffff]
> pci 0000:00:02.0: [1af4:1005] type 00 class 0x00ff00 conventional PCI end=
point
> pci 0000:00:02.0: BAR 0 [io  0xc080-0xc09f]
> pci 0000:00:02.0: BAR 1 [mem 0xfebf1000-0xfebf1fff]
> pci 0000:00:02.0: BAR 4 [mem 0xfe000000-0xfe003fff 64bit pref]
> pci 0000:00:03.0: [8086:100e] type 00 class 0x020000 conventional PCI end=
point
> pci 0000:00:03.0: BAR 0 [mem 0xfebc0000-0xfebdffff]
> pci 0000:00:03.0: BAR 1 [io  0xc000-0xc03f]
> pci 0000:00:03.0: ROM [mem 0xfeb80000-0xfebbffff pref]
> pci 0000:00:1f.0: [8086:2918] type 00 class 0x060100 conventional PCI end=
point
> pci 0000:00:1f.0: quirk: [io  0x0600-0x067f] claimed by ICH6 ACPI/GPIO/TC=
O
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
> ------------[ cut here ]------------
> err =3D=3D -EMSGSIZE
> WARNING: net/core/rtnetlink.c:4524 at rtmsg_ifinfo_build_skb+0x218/0x260,=
 CPU#0: swapper/0/1
> Modules linked in:
> CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:rtmsg_ifinfo_build_skb+0x218/0x260
> Code: f6 ba 01 00 00 00 89 e9 e8 45 ac 3a 00 4c 89 f0 48 83 c4 30 5b 41 5=
c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 39 dc 40 f8 90 <0f> 0b 90 eb 90=
 89 d9 80 e1 07 fe c1 38 c1 0f 8c 95 fe ff ff 48 89
> RSP: 0000:ffffc90000067438 EFLAGS: 00010293
> RAX: ffffffff8984e887 RBX: 0000000000000000 RCX: ffff8881026f5880
> RDX: 0000000000000000 RSI: 00000000ffffffa6 RDI: 00000000ffffffa6
> RBP: 00000000ffffffa6 R08: ffffffff8984f746 R09: 0000000000000000
> R10: fffff5200000ce30 R11: ffffed1020c50405 R12: 1ffff11020c51c21
> R13: 0000000000000000 R14: ffff888103a82480 R15: ffff88810628e000
> FS:  0000000000000000(0000) GS:ffff88818dc76000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e74a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  rtmsg_ifinfo+0x8c/0x1a0
>  register_netdevice+0x1aca/0x1ec0
>  register_netdev+0x40/0x60
>  loopback_net_init+0x75/0x150
>  ops_init+0x35c/0x5c0
>  register_pernet_operations+0x343/0x830
>  register_pernet_device+0x2a/0x80
>  net_dev_init+0x973/0xa90
>  do_one_initcall+0x250/0x870
>  do_initcall_level+0x104/0x190
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x2a6/0x3e0
>  kernel_init+0x1d/0x1d0
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [davem@davemloft.net edumazet@google.com eric.dumazet@gmail.com horms@ker=
nel.org kuba@kernel.org kuniyu@google.com netdev@vger.kernel.org pabeni@red=
hat.com]
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
-upstream-moderation/6a10da6d.050a0220.3c3a9.0003.GAE%40google.com.
