Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 534153033FB
	for <syzbot@lists.linux.dev>; Tue, 14 Jul 2026 17:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784050368; cv=none; b=VkUa8ooyFtYvWy89FBMzKBs+ESKjd0Ht4Lg9NHgeSFFm8hEHhlZQVbir9oc2q4/i8E5bgT7l2vu9pZjr0vag7/mqtOkUppEHXgpG34ISvVRBExGWY6daVMNr+Mv/0/qX8Qh/QM8z0FHAny9gN/TidiHBKP3aXUqKr/Yy2ZwCZsc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784050368; c=relaxed/simple;
	bh=++24DdGoWoG9HZOzleGus09KP5JkIZxYf9ra162KdyQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=evJWKCLVoUUzQMqAOSJh7wHkqt+3bij3fE2WPrQwymCfJPSwyJeoY+KBu0zLPAXEVqj8UoD9s+U0r71mpJeHKGayD3TN30wgYnl0CmXv0t1KmwFpAzenhtyKHZR0d0eKOVmCc9CI4aG0Qw3B2FXF5sWGDGa2YhKlue5w33PtpvE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4a416619e8dso2646713b6e.1
        for <syzbot@lists.linux.dev>; Tue, 14 Jul 2026 10:32:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784050366; x=1784655166;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=K4Ib08UYzoUMTUTu1CF3hl8XXmrqln+t943YJhk1mJc=;
        b=n2gFGuwUGgEqfM1JnggOjTvVhApzRhUMVO1C9PyqlVou5DntCNgNB4N7TtQL3dCIMz
         x9dPNBSf50ZUhxiYpxjeu+1z43n9JhNw7Q/jmT0ckmtyQyMGbK1wLhOPXD4KCArJLUqR
         tI+w94Rm7PRAWqMEEWv+gbWjU9ruFXG/JFuOFS69VrHZlw2YJaHZIiZNmzDsEDiThYYa
         WBh3fs4P8xLsOt1Iz4on4Db5YrYPl0bEm3c3Py2/qGhZgZgXbmjSuA0FvwcmfFTbKJ1V
         fGp5ghvCu2zQtpfIwTk7QgFIVgFejnsGyrNKCN1SoiL+QZ59HAvYwXuDuhStrQHS0AGy
         HPUA==
X-Gm-Message-State: AOJu0YyLSIFhzEYMfMvUQAnBnYNu9Hd+rWyoJ7bv60D5zJp/nLj1+zER
	/9W6N+PQOnP1dzhPPHJwnfgESMAgYmk7X55otuqWhC0X0oM++aFpBcw9HYKPdqEN3zphKhtf2FS
	HbUgqIxVNNA75P62Zk0aASFbVAcSeDANfsncOQZpVO2YcGgVwDmGvvZbXvTo=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:178b:b0:486:caa4:ea44 with SMTP id
 5614622812f47-4a40ecbff1fmr11616332b6e.6.1784050366286; Tue, 14 Jul 2026
 10:32:46 -0700 (PDT)
Date: Tue, 14 Jul 2026 10:32:46 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a5672be.c90005c7.37d349.002d.GAE@google.com>
Subject: [moderation/CI] Re: vfio/pci: Add PCIe TPH support
From: syzbot ci <syzbot+cid05bf17f34461400@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v20] vfio/pci: Add PCIe TPH support
https://lore.kernel.org/all/20260714104325.54444-1-fengchengwen@huawei.com
* [PATCH v20 01/16] PCI/TPH: Add requester/completer type helpers
* [PATCH v20 02/16] dma-buf: add optional get_pci_tph() callback
* [PATCH v20 03/16] vfio/pci: implement get_pci_tph and DMA_BUF_TPH feature
* [PATCH v20 04/16] PCI/TPH: Fix pcie_tph_get_st_table_loc() field extraction
* [PATCH v20 05/16] PCI/TPH: Fix tph_enabled concurrent update race by bitfield packing
* [PATCH v20 06/16] PCI/TPH: Cache negotiated max requester type at probe time
* [PATCH v20 07/16] PCI/TPH: Refactor pcie_enable_tph and add requester variant
* [PATCH v20 08/16] PCI/TPH: Refactor pcie_tph_get_cpu_st & add requester variant
* [PATCH v20 09/16] PCI/TPH: Add macros to check standard and extended TPH support
* [PATCH v20 10/16] PCI/TPH: Add pcie_tph_set_st_entries() batch ST entry programming helper
* [PATCH v20 11/16] PCI/TPH: Add pci_tph_dsm_supported() helper to detect device TPH ST _DSM
* [PATCH v20 12/16] vfio/pci: Add basic NO-ST TPH VFIO device feature support
* [PATCH v20 13/16] vfio/pci: Add IV-ST TPH policy and VFIO TPH_ST batch programming support
* [PATCH v20 14/16] vfio/pci: Add DS-ST TPH policy and extend TPH_RESOLVE capabilities
* [PATCH v20 15/16] vfio/pci: Sync core PCI TPH software state across device lifecycle and resets
* [PATCH v20 16/16] vfio/pci: Expose per-device TPH state via debugfs

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/111f70c0-3cc4-4dd6-8e1e-4e1bd05c02f5

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      3b029c035b34bbc693405ddf759f0e9b920c27f1
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/528f90fe-1e76-4f13-85af-dd4514b529b0/config

drivers/vfio/pci/vfio_pci_config.c:1202:9: error: call to undeclared function 'FIELD_GET'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

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

