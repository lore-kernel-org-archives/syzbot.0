Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4435839AD2A
	for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 09:17:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782119873; cv=none; b=Ewk9o2QPWwRtPe88tX80bnf1e18IVDkbcfzR2u5E6Aad8+SkhZQWvSisWI43uDvaa1R0wR6ko9mCGG4ahuE41IVYofRw9HKbDgv0x9guc89PPVBWAmElSLDoLyp6d/WBbIW/MeYrwL0ICjXvljNfEx2MviSfA2waABudNb1rMOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782119873; c=relaxed/simple;
	bh=plUeKXM+5QtYcKyJ7EQaTJ4WcaCSTrBRhVWq0GmupZ0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=PtDmuG/MY2Yzev4ggtqQ/tPbcsJiUNRWVYh2SK5EmeWf1nZaIXVTeL/YmUjHhDfAj7hEZ+pVqu/cpvwA9k3byg6tIM612bkS7hlZxJocTb0Od+/R7/5ewG4TpuwJBm4Q5DNhEJzIcA1/f32+GV51/Ev2Occ1/Scb9mS/AdoHJ94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-485fdae1db3so7245499b6e.1
        for <syzbot@lists.linux.dev>; Mon, 22 Jun 2026 02:17:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782119867; x=1782724667;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=lM8/G1snn59hjqPjWOCcR+zVKPkC1hpxo1fIDUiV09g=;
        b=W89e5zyo7TE+sxjHEJJ0PDpijHdOoZlKLMDvi+Orj98UdzjNszcbRZFAF6hQWU7KzV
         2NX0iO+RcR/nT/tnkIBSe6o/fV0zWGHTdDGw2tiT8bZAn02o0gnM3sTn9+BPDSCRTsxF
         14Yit2bf1XpmqJsH71CUOUcuRmyQQxKVOZqOhF90cO759Aw6mAmqIEKhsV0a30B2X2va
         EHEQSyMCDYd1Hk4u/bNpMFXiOSoVXZSxZHb8idHV/ZLxWTw7TmETcsW6P09RI7AyW6iZ
         Eaae2CvYsDzqX/9kP0iLstGGuems7++1QltTkVuWwsrzN3tU/g/njH6MeiTYxyKn7vY0
         hJBw==
X-Gm-Message-State: AOJu0Yysa7U/j8oZu5JMeUPHl1nwGEbODApSL9NGJQ2sMdfDTqZ5rI76
	igluowngTBFZpxVxDAbd7wvrauYN++nTHhK+/syV0m7vnwk326t5Nr5xCXnSAYI4WOWVuW3+g2P
	u9sOrGekCrszqO+5WbzJZNceoG/qkD5Dn0x+VC3xMP/j7El7ci/twLPZyPkE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1717:b0:485:3a28:a83f with SMTP id
 5614622812f47-48ac0d5c327mr8185514b6e.32.1782119867006; Mon, 22 Jun 2026
 02:17:47 -0700 (PDT)
Date: Mon, 22 Jun 2026 02:17:46 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a38fdba.8c9cf54e.2346b6.0009.GAE@google.com>
Subject: [moderation/CI] Re: vfio/pci: Add PCIe TPH support
From: syzbot ci <syzbot+ci8f392a848dd8fb8c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v18] vfio/pci: Add PCIe TPH support
https://lore.kernel.org/all/20260622074523.38473-1-fengchengwen@huawei.com
* [PATCH v18 01/12] PCI/TPH: Fix pcie_tph_get_st_table_loc() field extraction
* [PATCH v18 02/12] PCI/TPH: Fix tph_enabled concurrent update race by bitfield packing
* [PATCH v18 03/12] PCI/TPH: Cache TPH requester capability at probe time
* [PATCH v18 04/12] PCI/TPH: Refactor pcie_enable_tph & add explicit requester variant
* [PATCH v18 05/12] PCI/TPH: Refactor pcie_tph_get_cpu_st & add explicit variant
* [PATCH v18 06/12] PCI/TPH: Expose the enabled TPH requester type
* [PATCH v18 07/12] PCI/TPH: Add pcie_tph_supported() helper to check TPH capability attributes
* [PATCH v18 08/12] PCI/TPH: Add sysfs binary file to export CPU to steering-tag mapping
* [PATCH v18 09/12] vfio/pci: Hide TPH capability when TPH is unsupported
* [PATCH v18 10/12] vfio/pci: Add TPH_ENABLE feature skeleton and unsafe module parameter
* [PATCH v18 11/12] vfio/pci: Add TPH_ST_CONFIG for PCIe TPH ST configuration
* [PATCH v18 12/12] vfio/pci: Virtualize PCIe TPH capability registers

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/a66c1909-0e1c-439d-92c4-146c8e09daea

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      ef0c9f75a19532d7675384708fc8621e10850104
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/98884372-3620-4a5c-b061-f66d9f711af9/config

drivers/vfio/pci/vfio_pci_config.c:1175:9: error: call to undeclared function 'FIELD_GET'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[alex@shazbot.org fengchengwen@huawei.com helgaas@kernel.org jgg@ziepe.ca kvm@vger.kernel.org linux-pci@vger.kernel.org liuyonglong@huawei.com wangyushan12@huawei.com wangzhou1@hisilicon.com wathsala.vithanage@arm.com wei.huang2@amd.com zhipingz@meta.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

