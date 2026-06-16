Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39DBF27BF93
	for <syzbot@lists.linux.dev>; Tue, 16 Jun 2026 11:53:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781610823; cv=none; b=IBvPuouQSNVWFQmxLlxPGdkafwKeSL+pTR/y254Zrw9UKG34QlOQrUvCaH/MCXip8BvhbWvcJ9jR+Duuh75nFDM1qfuP9UZYnoPCqb4fENcrbJeW8R2isRYJocRaGXal2Fg4WCucmcubkg/22a+qJ5c/SuyzB5bKHyvADPc+oYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781610823; c=relaxed/simple;
	bh=T1xdfyK88eRzHw+caowhjr9Mmey0RrpBgpgXP2VVUN0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=fxiNOeNk8sB4VinfFiyaRkFiEOMrPosRn2YH5aB+oW5FvT9PqJuWtzwj4KZwjJ3uxn78xUCdjojYv848NjVJoxB03qzTjWyPbKC63lgNV3RDQxbbJtbH89NyqCE4R8l9SKePBahpv4lMGgQ4IWa66EFjnkiQA4DiDL0AMChEo7k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7e713779405so8929004a34.3
        for <syzbot@lists.linux.dev>; Tue, 16 Jun 2026 04:53:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781610821; x=1782215621;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=UHzBAtFaF/1CZamwDX3qqYVXAJuQr1iLhxzQAEZ4wK4=;
        b=Fk24sN/1deG4vw+vYin9JbLVAVHmtD3Q2tdvr3l1AAeOpkLkiGR9SUWkeAC5Wa0VpZ
         hs8qwKd6Fg1yTJnZnRRgn5Y1lL3gYHXt5GAv6e/+aXwVdI9OirOEEsP8HpX4geAHMzre
         U9Ahb7zpvoGmsD8H7MtQFtSAkroApW1PZKtq+L8ydPkk8ZPF5WVPkqG11GTh9JiAQX+K
         lhVRyB+IacojnAs1/1YdJPao97YdT1LQjKu64VCxX2dOAxSSIGk3YKer9wkpaZOQOdxc
         AVcff5QX6nNNNKqqzSFASBYbzb9+I2hkaPK4dw0bzoqUg9QS4HHWIlKDK3NLZVPt6Un/
         LV9w==
X-Gm-Message-State: AOJu0YxVjg8Rn1XTwF1JhDnyWQtsxqIzx4Y7S95iFsl8q3+jF/GmcT0f
	afcSEpEuNwdF32jpZ/iYvTFgMrAYHrEduigPQV8ux9OSz73+EB598oshyCYmPLBLBxp7BX95NCM
	b4xKGJ8/rF1VhOMUA8Ow8QigKnmUCBzR8Z6fA3Ld6jF96V6FEaVWdg38fL6A=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6f82:b0:485:4601:9c84 with SMTP id
 5614622812f47-4884c1ff319mr2570439b6e.29.1781610821261; Tue, 16 Jun 2026
 04:53:41 -0700 (PDT)
Date: Tue, 16 Jun 2026 04:53:41 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a313945.ba59a6c9.b6d35.0001.GAE@google.com>
Subject: [moderation/CI] Re: vfio/pci: Add PCIe TPH support
From: syzbot ci <syzbot+ci19edba934fc483be@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v17] vfio/pci: Add PCIe TPH support
https://lore.kernel.org/all/20260616104621.41915-1-fengchengwen@huawei.com
* [PATCH v17 01/12] PCI/TPH: Fix pcie_tph_get_st_table_loc() field extraction
* [PATCH v17 02/12] PCI/TPH: Fix tph_enabled concurrent update race by bitfield packing
* [PATCH v17 03/12] PCI/TPH: Cache TPH requester capability at probe time
* [PATCH v17 04/12] PCI/TPH: Refactor pcie_enable_tph & add explicit requester variant
* [PATCH v17 05/12] PCI/TPH: Refactor pcie_tph_get_cpu_st & add explicit variant
* [PATCH v17 06/12] PCI/TPH: Expose the enabled TPH requester type
* [PATCH v17 07/12] PCI/TPH: Add pcie_tph_supported() helper to check TPH capability attributes
* [PATCH v17 08/12] PCI/TPH: Add sysfs binary file to export CPU to steering-tag mapping
* [PATCH v17 09/12] vfio/pci: Hide TPH capability when TPH is unsupported
* [PATCH v17 10/12] vfio/pci: Add TPH_ENABLE feature skeleton and unsafe module parameter
* [PATCH v17 11/12] vfio/pci: Add TPH_ST_CONFIG for PCIe TPH ST configuration
* [PATCH v17 12/12] vfio/pci: Virtualize PCIe TPH capability registers

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/4edd0905-3fa4-4f51-8143-8ac8eb0bc5c8

***

kernel build error

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      9fb628b4cd3488a36e3fc9b22bb840048aa1a9d2
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/ee500939-0414-42ce-baca-4a9bc547021b/config

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

