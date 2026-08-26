Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 48EBF280A56
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 10:11:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787739117; cv=none; b=iqMrLJ42BZ7gJ87m7oyMBkSLhpG6qIuWigTg3kT0s61jsE1pSfffF0PRCaLqx/6oMXni6gBMdVBbDxjovq0Ny5WEfY4c+gNNTSZZM5j85OdQ6wxrDSnNqPku4DHILwuA/bzqAE0IRybt9naHehLaVIcbHJ/gtNkBIvKQE/LMi+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787739117; c=relaxed/simple;
	bh=oPmmiOIz17kMUSkXuHD6ICEr1VdG2WgD4ERH23dDkzk=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=TGRrIISSahvuyQ9goEJ96XIAWk9qLh7qdMWQyZnoKVvkj91Jxw9akQlTIFLCo/Cpb4rxMNVjR60tD+mdSaK23EXmkvTPtMeZwan0UA7F1Zxz8NlaOB4uwftwmkGe2fDRk8TobmaI9A+YeL0LxAzSdGOghkrcoL2Jf5b0TdbCU8w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b28d7ffab1so1762124b6e.1
        for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 03:11:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787739114; x=1788343914;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=Bc+hFQHEJTLq8xd3e/5RzI08QtJyD4Yew8VDbBzp9uo=;
        b=G4s+4FuozSTcUxXgqsD8jBhme1gIwh4uyqL5mdD0mdMdEqYKTTQhTW1C+cac/DBhDj
         BojFQt6oGRKC7nKWcLjC+vKgtGaRKMbMZ155S1LGyKXMSmKFGXA6RlAhf72dS6ZkDvYi
         JbOumcgPLirszRTgFVjpRdge6U9ImljmXMUsXdj/EWy7szIntL/33Ct64ubNYqW1U2VO
         gwAFRs/SITEAlmVZzf8AakPyWsPFik6qKVoi0LuD1Y5sEnVcQCU4NomA8y2jWOYBWXSk
         SaPmlmDxl7u4hQt/wyqdRK+vQfswv3FKDpXjaSQCmhB9u+Ziene93IGt/IjrSz79+WWS
         nyiw==
X-Gm-Message-State: AFuF++kJVRiXBFGqiwS8qGtu/sb6SwpaUzZiK4PU8/LRNWJRUgn+GuC1
	OUoF9JqKCfX2UjptYUwrK1eMY3XXw4I92FJcdoiqARzVb26MVPAqaHMX7MJpXvIaCuMbqiaSQhq
	snHFcDSZwbHyBSWq2dJknOQLLL2p1KicctXgjApO5T2c4q6cPb19KrDAzBDM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3192:b0:4a4:989:bb1f with SMTP id
 5614622812f47-4b350425f51mr10120061b6e.9.1787739114303; Wed, 26 Aug 2026
 03:11:54 -0700 (PDT)
Date: Wed, 26 Aug 2026 03:11:54 -0700
In-Reply-To: <20260826075703.2400467-1-lee@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8ebbea.1d9ded08.62e62.00a2.GAE@google.com>
Subject: [syzbot ci] Re: nfc: llcp: Fix race condition in accept_queue lifecycle
From: syzbot ci <syzbot+cie83be755322835fa@syzkaller.appspotmail.com>
To: davem@davemloft.net, david@ixit.cz, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, lee@kernel.org, linux-kernel@vger.kernel.org, 
	netdev@vger.kernel.org, oe-linux-nfc@lists.linux.dev, pabeni@redhat.com, 
	sameo@linux.intel.com, szymon.janc@tieto.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] nfc: llcp: Fix race condition in accept_queue lifecycle
https://lore.kernel.org/all/20260826075703.2400467-1-lee@kernel.org
* [PATCH v2 1/1] nfc: llcp: Fix race condition in accept_queue lifecycle

and found the following issue:
WARNING in __alloc_workqueue

Full report is available here:
https://ci.syzbot.org/series/6f4e9aed-2eea-44c2-8ef0-04ce578d399f

***

WARNING in __alloc_workqueue

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      a8406e6c0b793ce0788019683837c40855b55995
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/3abfab5f-31c6-4773-9338-bbe1caeca14d/config

pci 0000:00:1f.2: [8086:2922] type 00 class 0x010601 conventional PCI endpoint
pci 0000:00:1f.2: BAR 4 [io  0xc0a0-0xc0bf]
pci 0000:00:1f.2: BAR 5 [mem 0xfebf2000-0xfebf2fff]
pci 0000:00:1f.3: [8086:2930] type 00 class 0x0c0500 conventional PCI endpoint
pci 0000:00:1f.3: BAR 4 [io  0x0700-0x073f]
ACPI: PCI: Interrupt link LNKA configured for IRQ 10
ACPI: PCI: Interrupt link LNKB configured for IRQ 10
ACPI: PCI: Interrupt link LNKC configured for IRQ 11
ACPI: PCI: Interrupt link LNKD configured for IRQ 11
ACPI: PCI: Interrupt link LNKE configured for IRQ 10
ACPI: PCI: Interrupt link LNKF configured for IRQ 10
ACPI: PCI: Interrupt link LNKG configured for IRQ 11
ACPI: PCI: Interrupt link LNKH configured for IRQ 11
ACPI: PCI: Interrupt link GSIA configured for IRQ 16
ACPI: PCI: Interrupt link GSIB configured for IRQ 17
ACPI: PCI: Interrupt link GSIC configured for IRQ 18
ACPI: PCI: Interrupt link GSID configured for IRQ 19
ACPI: PCI: Interrupt link GSIE configured for IRQ 20
ACPI: PCI: Interrupt link GSIF configured for IRQ 21
ACPI: PCI: Interrupt link GSIG configured for IRQ 22
ACPI: PCI: Interrupt link GSIH configured for IRQ 23
iommu: Default domain type: Translated
iommu: DMA domain TLB invalidation policy: lazy mode
SCSI subsystem initialized
ACPI: bus type USB registered
usbcore: registered new interface driver usbfs
usbcore: registered new interface driver hub
usbcore: registered new device driver usb
mc: Linux media interface: v0.10
videodev: Linux video capture interface: v2.00
pps_core: LinuxPPS API ver. 1 registered
pps_core: Software ver. 5.3.6 - Copyright 2005-2007 Rodolfo Giometti <giometti@linux.it>
PTP clock support registered
EDAC MC: Ver: 3.0.0
Advanced Linux Sound Architecture Driver Initialized.
Bluetooth: Core ver 2.22
Bluetooth: Core ver 2.22
NET: Registered PF_BLUETOOTH protocol family
Bluetooth: HCI device and connection manager initialized
Bluetooth: HCI socket layer initialized
Bluetooth: L2CAP socket layer initialized
Bluetooth: SCO socket layer initialized
NET: Registered PF_ATMPVC protocol family
NetLabel: Initializing
NetLabel:  domain hash size = 128
NetLabel:  protocols = UNLABELED CIPSOv4 CALIPSO
NetLabel:  unlabeled traffic allowed by default
nfc: nfc_init: NFC Core ver 0.1
------------[ cut here ]------------
workqueue: nfc_llcp_wq is using neither WQ_PERCPU or WQ_UNBOUND. Setting WQ_PERCPU.
WARNING: kernel/workqueue.c:5939 at __alloc_workqueue+0x1cd2/0x1fe0, CPU#1: swapper/0/1
Modules linked in:
CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
RIP: 0010:__alloc_workqueue+0x1cd5/0x1fe0
Code: 0b 90 e9 6d fc ff ff e8 f9 f0 38 00 e9 7f fb ff ff e8 ef f0 38 00 e9 85 fb ff ff e8 e5 f0 38 00 48 8d 3d 3e 1a ee 0e 4c 89 f6 <67> 48 0f b9 3a 41 81 cf 00 01 00 00 e9 10 e6 ff ff e8 c5 f0 38 00
RSP: 0000:ffffc90000067788 EFLAGS: 00010293
RAX: ffffffff818ecbbb RBX: 0000000000000000 RCX: ffff888102adda00
RDX: 0000000000000000 RSI: ffff8881680b0d70 RDI: ffffffff907ce600
RBP: ffffffff8d4e3fa0 R08: ffff888102adda00 R09: 0000000000000002
R10: 0000000000000102 R11: 0000000000000000 R12: ffff8881680b0c00
R13: ffff8881680b0c00 R14: ffff8881680b0d70 R15: 0000000000000000
FS:  0000000000000000(0000) GS:ffff8882a8ce0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 0000000000000000 CR3: 000000000eb48000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 alloc_workqueue_noprof+0xe3/0x210
 nfc_llcp_init+0x15/0x50
 nfc_init+0x74/0xa0
 do_one_initcall+0x250/0x870
 do_initcall_level+0x10a/0x1a0
 do_initcalls+0x59/0xa0
 kernel_init_freeable+0x29d/0x3e0
 kernel_init+0x22/0x1d0
 ret_from_fork+0x514/0xb70
 ret_from_fork_asm+0x1a/0x30
 </TASK>


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
