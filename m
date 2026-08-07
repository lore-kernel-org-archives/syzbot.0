Received: from mail-qk1-f171.google.com (mail-qk1-f171.google.com [209.85.222.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DA243E2777
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 05:25:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.222.171
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786080317; cv=pass; b=pVyKyQH8/5zXLGw8sLhXjkvOZKRPQPZwHH998jGSXY/s4y2hk7mI/OEgKYgOcG+RjMURoabe4E1MZCk7iNjLqFxKqqVkY+0YeD0rKAXzwCVJ6fj8bg1NXlPsJc7qJLhtj6luf8JDE/vTRzseYR1puV2kifPxAunOTbJwk5eZj1c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786080317; c=relaxed/simple;
	bh=SIJGjc/vd0eTIo+PzCbUgej4zsQHGaxB/EEkRnlYHE0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hfXBKCjguCyjZmTNJj+bOL4xoNjnep59CEDwWvX2XXjmPciWaEh7b/Wv89qizramoJ26YX2p4uaJ+hA9SaFWKZdC3P0Wvy/OMUp6WTgqSnveCTkj9yxj26flHFEI9EkdrOay0DVagoHd3GJmNbn6nyecDZmc7ju9a11cn+y2dx0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mAQr9dX1; arc=pass smtp.client-ip=209.85.222.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mAQr9dX1"
Received: by mail-qk1-f171.google.com with SMTP id af79cd13be357-92e67555e24so157436785a.3
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 22:25:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786080312; cv=none;
        d=google.com; s=arc-20260327;
        b=Nac319ZVscv/vpiG6pmsh9r4MOlt6QXC1VBZtdCgWLAUIItVaZ8ERAQ+WSVVjdMmCN
         lQls9LeQFSngLopSIJtNDTLDY2sIB6Ko0LJtAc94hcdFWff81GBiLpBb1d/KrRUF7FWS
         bt7/iju4Ohb55b/29VD4sBQNSnLtuoWXuCBGYqSndkuxGZnRFgghkc7W50RnYAg1nTPV
         Mf2ZYQFr0D9TWjpVIezA/mAKvN4oV/0lp2GVfgrL7k3Dj+DGW2zMNciY3im6cxDtb/jL
         T84DIqndAq1hwE6fYCfQuGISKRVK5UzfkVQqas10+Ryi0duTBcp23aBLNWc26IKMwL2/
         h/bQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=P2iVRzQvU/ARB0Uq6DDAaIY0C0rSBmunUX/1sGUrmfc=;
        fh=G0jEkEWKVFNXYwoBxKgfb+zf98fpgNQRNAjo/WxGbcw=;
        b=F59npgb5DLzW5Yte3nEpbDNmsgQVWeqwK1BNXEsPOfjEo4438WnIhmOIQgE4YN7rKC
         2W/Rp2Mj9bOz6CZnkDZBlsaVwut7MacNSDMG+Y64Dlzx2oRULxjMWgxsOVrUzOXvEyiB
         ezNdiLYPg68B/w1EZSTLTuf0pJedTbjVBSG1tBjSo6L2h63WYVCHs+EwaPEjGVEJnOgN
         kvEyPQ/LpHdM5+wa3yKjGqLjL0AiJTAwKt1XZTAOqy9IWD3IxGiLusupNh2sxeXx2ecq
         EOP6xi7HmIRPaE484lLfDn2mg5zf2Ibd6SM4cQNaCvxgFgCxf/j3fanXEIvZqgD+Bi08
         Eeyw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786080312; x=1786685112; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=P2iVRzQvU/ARB0Uq6DDAaIY0C0rSBmunUX/1sGUrmfc=;
        b=mAQr9dX1KuZ4aPa35gM4kfG1zLjgSBnyGkHz3Iw6hqKeuNshVei2pcnN970ekp7LPo
         r/CuWIeTsVkLpXkyOmKFi5w06D82gFQpv6szxMkMmcE0LO3QDm1r3j71+3UfqTsziAP0
         pqdZnLMk8dpcqs8N1QyPjohOpxtUrMsjG7GMbongWiVwvwyszczILiuRgmjHxhHRwBUi
         yKFV82VnLLFjWN377u83itt81xYyzDsncs4o+wveiQmQmRWqHbHIn7rG6lXfQfkKxSPr
         93roU7yJ6ZunanM5ycOw0GN/1UuOPt1jDwxNsYwkmFgbkqpgpSdmVULpAn4R52WVM/Q0
         OAMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786080312; x=1786685112;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=P2iVRzQvU/ARB0Uq6DDAaIY0C0rSBmunUX/1sGUrmfc=;
        b=Bm9t9BsdBMDl2Sab9GE71dCvvmsAPDcM4Zsz8L2j7LdG40KAzVYZ1mLQUr30MT9X9C
         wo2ZIQP02Fpnx3h7cIFRqDC1eDDSA86Xrdkelqnxkbx7wr9KwV42H2s/aB1pqMiuPb3I
         OVevP4c1ldS0igutEvarcHYhkcjZSxrWP7V2Le0nrvAnKbzdbj75YGl1rSziZoHBvxqW
         1cPOhA+dchtKg7UHNGNLlLX3XtF70PIhuezP7k8qzdaaNN7770L/JXvVWE1licsojRy7
         WUuzqRLZzyRBooxT1cWNgg53Mrj4iY6WTlifqVdWpv94GiTjoSovzqXSGg2GrSzvUYtd
         S1oQ==
X-Forwarded-Encrypted: i=1; AHgh+RpElrasGb1dFTw0esdHRMLMEOt/HIJd4+cChYk6dYoeqAKM9yAjJG3qMuu7/R5aJsksq9LSiKg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2cqLRsniNi+9gnktHySiWDvY9kb98Jn7Ibw2O2y9MzaUMCDk4
	QbsrzFTATzMrc+lU0WSrs5rfw3A1Hc3Hy3epZhoe2R89XkMUx+ILwEa5Wy4eDS46pKNmZXP+FWG
	RrCIoeE4jKBVhk2SHXJHMx9EuOXcP7Vu942b1vhzF
X-Gm-Gg: AR+sD129lMlvA6vKQZoGKB7Xe8Ek1jRj0O/nkEq/EI9Zphhz8D3LuuhOFQ+qjf30Ev5
	KpKpUNPcBgEp+5I1JQQeKsKOxIvGxq2OEke0ieuxz1Zm4bsAlR4ewv+TlUgb54FVEedjON0g4gi
	G2edZN6eTGXtbK98sUSudGUayoDLgNEY5S+qH9NL9SRWoxYDrmTvu3wURrvito+Dpmn4QjPc/6k
	DcUO4xO7/ARl2eRvpaACJ4lEZlCZ1ZGXLXIXJcx21FCzJMHs2eWYK6TrYt/Wz45FGm6gqqGD8db
	wMhTLjPDPG5H9DqVXuKo2ePEpe8nVeQdhR5ZZtafa8HVc34tyCVvHuqWb+wq3DRSoPE//w2Z9LD
	9Dp9fG3OSct7anlPY0+dDTwQsjIT/oxxmMNU=
X-Received: by 2002:a05:620a:2b8b:b0:930:9fdd:f4e0 with SMTP id
 af79cd13be357-936491d4b87mr2032011785a.26.1786080311221; Thu, 06 Aug 2026
 22:25:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a756b44.9c11d2ce.289b96.00a5.GAE@google.com>
In-Reply-To: <6a756b44.9c11d2ce.289b96.00a5.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Fri, 7 Aug 2026 07:25:00 +0200
X-Gm-Features: AUfX_mwqFOdHUPhfXEwGHIHw2F9-xJCxnQKS60q23l8UGedOFfvGCfj7kOyb0J0
Message-ID: <CAJWNTGy4i1qNn2v_7FW4iH6-mJQTUf6TuqvK0Z4oLEvn3d8eug@mail.gmail.com>
Subject: Re: [moderation/CI] Re: pull request: fixes for ovpn 2026-08-07
To: syzbot ci <syzbot+cia3579a1608aada9e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Aug 7, 2026 at 7:21=E2=80=AFAM syzbot ci
<syzbot+cia3579a1608aada9e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] pull request: fixes for ovpn 2026-08-07
> https://lore.kernel.org/all/20260807002250.1817498-1-antonio@openvpn.net
> * [PATCH net 1/4] ovpn: fix NULL dereference when killing missing key
> * [PATCH net 2/4] ovpn: finish crypto callback cleanup before peer releas=
e
> * [PATCH net 3/4] ovpn: run deferred work on a module-owned workqueue
> * [PATCH net 4/4] ovpn: defer key slot crypto freeing to workqueue
>
> and found the following issue:
> WARNING in __alloc_workqueue
>
> Full report is available here:
> https://ci.syzbot.org/series/a46f06c7-f8d8-4053-a746-91498a46c290
>
> ***
>
> WARNING in __alloc_workqueue
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      594d905195024b228c962627ae5ae7c17bd582a4
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/cc426b49-07b7-496e-badf-5b0646780=
dd0/config
>
> usbcore: registered new interface driver udl
> bochs-drm 0000:00:01.0: vgaarb: deactivate vga console
> [drm] Found bochs VGA, ID 0xb0c5.
> [drm] Framebuffer size 16384 kB @ 0xfd000000, mmio @ 0xfebf0000.
> [drm] Initialized bochs-drm 1.0.0 for 0000:00:01.0 on minor 2
> bochs-drm 0000:00:01.0: [drm] fb1: bochs-drmdrmfb frame buffer device
> usbcore: registered new interface driver gm12u320
> usbcore: registered new interface driver gud
> brd: module loaded
> loop: module loaded
> zram: Added device: zram0
> null_blk: disk nullb0 created
> null_blk: module loaded
> Guest personality initialized and is inactive
> VMCI host device registered (name=3Dvmci, major=3D10, minor=3D267)
> Initialized host personality
> usbcore: registered new interface driver rtsx_usb
> lpc_ich 0000:00:1f.0: I/O space for GPIO uninitialized
> usbcore: registered new interface driver viperboard
> usbcore: registered new interface driver dln2
> usbcore: registered new interface driver pn533_usb
> nfcsim 0.2 initialized
> usbcore: registered new interface driver port100
> usbcore: registered new interface driver nfcmrvl
> Loading iSCSI transport class v2.0-870.
> st: Version 20160209, fixed bufsize 32768, s/g segs 256
> ACPI: \_SB_.GSIA: Enabled at IRQ 16
> ahci 0000:00:1f.2: AHCI vers 0001.0000, 32 command slots, 1.5 Gbps, SATA =
mode
> ahci 0000:00:1f.2: 6/6 ports implemented (port mask 0x3f)
> ahci 0000:00:1f.2: flags: 64bit ncq only
> scsi host0: ahci
> scsi host1: ahci
> scsi host2: ahci
> scsi host3: ahci
> scsi host4: ahci
> scsi host5: ahci
> ata1: SATA max UDMA/133 abar m4096@0xfebf2000 port 0xfebf2100 irq 26 lpm-=
pol 1
> ata2: SATA max UDMA/133 abar m4096@0xfebf2000 port 0xfebf2180 irq 26 lpm-=
pol 1
> ata3: SATA max UDMA/133 abar m4096@0xfebf2000 port 0xfebf2200 irq 26 lpm-=
pol 1
> ata4: SATA max UDMA/133 abar m4096@0xfebf2000 port 0xfebf2280 irq 26 lpm-=
pol 1
> ata5: SATA max UDMA/133 abar m4096@0xfebf2000 port 0xfebf2300 irq 26 lpm-=
pol 1
> ata6: SATA max UDMA/133 abar m4096@0xfebf2000 port 0xfebf2380 irq 26 lpm-=
pol 1
> Rounding down aligned max_sectors from 4294967295 to 4294967288
> db_root: cannot open: /etc/target
> slram: not enough parameters.
> ftl_cs: FTL header not found.
> wireguard: WireGuard 1.0.0 loaded. See www.wireguard.com for information.
> wireguard: Copyright (C) 2015-2019 Jason A. Donenfeld <Jason@zx2c4.com>. =
All Rights Reserved.
> ------------[ cut here ]------------
> workqueue: ovpn is using neither WQ_PERCPU or WQ_UNBOUND. Setting WQ_PERC=
PU.
> WARNING: kernel/workqueue.c:5852 at __alloc_workqueue+0x1cf5/0x2060, CPU#=
0: swapper/0/1
> Modules linked in:
> CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__alloc_workqueue+0x1cf8/0x2060
> Code: 38 00 e9 59 f9 ff ff e8 46 96 38 00 e9 26 fb ff ff e8 3c 96 38 00 e=
9 a7 fb ff ff e8 32 96 38 00 48 8d 3d fb a1 cc 0e 4c 89 f6 <67> 48 0f b9 3a=
 81 cd 00 01 00 00 e9 a7 e5 ff ff e8 13 96 38 00 48
> RSP: 0000:ffffc900000677a8 EFLAGS: 00010293
> RAX: ffffffff818e8c5e RBX: 0000000000000000 RCX: ffff888102a95940
> RDX: 0000000000000000 RSI: ffff88810c4cf570 RDI: ffffffff905b2e60
> RBP: 0000000000000000 R08: ffff888102a95940 R09: 0000000000000002
> R10: 0000000000000102 R11: 0000000000000000 R12: ffffc900000678c0
> R13: ffff88810c4cf400 R14: ffff88810c4cf570 R15: 0000000000000000
> FS:  0000000000000000(0000) GS:ffff88818d934000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff88823ffff000 CR3: 000000000e946000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  alloc_workqueue_noprof+0xe3/0x210
>  ovpn_init+0x1b/0xb0
>  do_one_initcall+0x250/0x870
>  do_initcall_level+0x10a/0x1a0
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x29d/0x3e0
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
> [andrew@lunn.ch antonio@openvpn.net davem@davemloft.net edumazet@google.c=
om kuba@kernel.org netdev@vger.kernel.org pabeni@redhat.com ralf@mandelbit.=
com sd@queasysnail.net]
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
-upstream-moderation/6a756b44.9c11d2ce.289b96.00a5.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
