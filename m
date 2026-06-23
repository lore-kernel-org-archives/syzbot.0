Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E872E7389
	for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 10:03:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782209020; cv=none; b=f3JriSdgiD7BGWWW2b36JxhmYVREqGzqIqDmLsb73TIj3zIHnD8wWBiUQaKHNnjpEgF/dC2SQfZ5MJ0ycQgaGHksqjglmKs3abRqeVDgAjogZc4AVf58GXGMt9hGsMhyQiXZxpVYMTjyVri/YWei6Vxc5P8eAWDuCvCg6LQK7uU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782209020; c=relaxed/simple;
	bh=Qp5+aLVOH1LS7sd64SkcixlNW48FDDSGA0c0EhDYs1o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=gTKIDYZhgZPc8TrPLTZl7K+Ft9ZJos5TTJSIRMs27hbBFIl9o/SpGvfD2/198J5c/OcmZGT/ANcbxuJysFd+QANN3a5N1XQebFbOqKogmxIDu7g+zMPK6dJkui4e7gFgxX74POf7J/kvRdrrYz7suDOZjky/WcUJ47z8kQvcHdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-48976713b46so5914694b6e.0
        for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 03:03:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782209018; x=1782813818;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=E63T2IFpgoLrNRxGniA5HQRNdKL+0YU9/ZVCQy0UGLQ=;
        b=f2mee3bfIfqsYOANlXIws69i1LKMkQV2TI1I3PXBLc3xSkR2ANI1ofO2LRANZv1itB
         LAWmO5HMC/ifUQgs6OklyimBY6Tt3s4Rcor6o17ETOioDvJCtYfHUwWa3J3v9q9yXxTl
         9aWd4ijT5vmvKI+kmnxHMeiuO/xLJPEh+NqD7ZeKh73881cBsl0ipZTsPfbamHvxNX0s
         k45bP5eSCVZE3DHrKISoFc+nbU9NvPRikkh8+TbPuGClTOMor4tHdI8vpT7WClyuRSdj
         1vCKv7p4pNVfM9NeJRwsUNQjqtWD7JA+m2XjQ2nNrch0tdZtE/TkgqqFgd7+Oo5YCi2c
         bmgw==
X-Gm-Message-State: AOJu0YygXsXyssdywar0ErwXd8qnPaAG2usqR7jqnas6a09EIYzg7mSP
	BWPFTS10a48BBV5Id+oUNANhWZsnnbsS7/ZrlFp06gnwd0UAbE/j2MHMmzFLAf5DTI5bQTjym/i
	8l42jpRPoQajIsSm/RtsoJ+BzuOmbNM7377fx5CJFKm1fjbb43fWzYlU1iI8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6809:20d:20b0:489:9f26:feaa with SMTP id
 5614622812f47-48f62721d9fmr590069b6e.35.1782209018442; Tue, 23 Jun 2026
 03:03:38 -0700 (PDT)
Date: Tue, 23 Jun 2026 03:03:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3a59fa.92e8a34c.2b91f1.0000.GAE@google.com>
Subject: [moderation/CI] Re: vfio/pci: Add PCIe TPH support
From: syzbot ci <syzbot+ci1816d249f4bf1c55@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v18] vfio/pci: Add PCIe TPH support
https://lore.kernel.org/all/20260623085048.51139-1-fengchengwen@huawei.com
* [PATCH RESEND v18 01/12] PCI/TPH: Fix pcie_tph_get_st_table_loc() field extraction
* [PATCH RESEND v18 02/12] PCI/TPH: Fix tph_enabled concurrent update race by bitfield packing
* [PATCH RESEND v18 03/12] PCI/TPH: Cache TPH requester capability at probe time
* [PATCH RESEND v18 04/12] PCI/TPH: Refactor pcie_enable_tph & add explicit requester variant
* [PATCH RESEND v18 05/12] PCI/TPH: Refactor pcie_tph_get_cpu_st & add explicit variant
* [PATCH RESEND v18 06/12] PCI/TPH: Expose the enabled TPH requester type
* [PATCH RESEND v18 07/12] PCI/TPH: Add pcie_tph_supported() helper to check TPH capability attributes
* [PATCH RESEND v18 08/12] PCI/TPH: Add sysfs binary file to export CPU to steering-tag mapping
* [PATCH RESEND v18 09/12] vfio/pci: Hide TPH capability when TPH is unsupported
* [PATCH RESEND v18 10/12] vfio/pci: Add TPH_ENABLE feature skeleton and unsafe module parameter
* [PATCH RESEND v18 11/12] vfio/pci: Add TPH_ST_CONFIG for PCIe TPH ST configuration
* [PATCH RESEND v18 12/12] vfio/pci: Virtualize PCIe TPH capability registers

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/fe257025-9d11-4417-9798-9e23f70bc41f

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      948efecf22e49aa4bf55bb73ec79a0ddcfd38571
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/39491be3-5f60-420a-b50f-6ad3105087ea/config

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

