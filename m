Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D022D0292
	for <syzbot@lists.linux.dev>; Thu,  4 Jun 2026 14:47:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780584456; cv=none; b=kzx0YEdqGh49kVRwHUI5kb6p02XKFkyXeQ1DAZ3eVhSSFhtImAk8ckv4NOP82j/6WHaVW50h0aZAaHr5o/EwH5yupqf0FUOWYgNWUzCxMMhRFK/7/BTFBp0qe2y8AbTr+4Fv+8HlHw8zXANTD5jw3WiQAdLQgDConSZsW4Sa5tc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780584456; c=relaxed/simple;
	bh=yTVX2luUKVk3QCjTYbP8QZye2C/wzy+muNkXMKzrn0s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=jCsvJpacHkReqR+kgE3ZN+kndDS1BSS7mk7TT4fzM6rivW6/QdSa9yplXILVSX8YR6rp+UsqasLIDm3pf7kNC6sFZy7zIdivEZ9+zujYgexQcI68409bPU3i8MQhx6GOqLKZmeaBCxinbcN3O28GGGxzDL3D+pl9XoK9Z7FNejs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-69da2d033c9so746325eaf.0
        for <syzbot@lists.linux.dev>; Thu, 04 Jun 2026 07:47:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780584454; x=1781189254;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SZ291ZH+CdnN9Ile3He+/ZlxCyx9mD2ClYy9RGdt0iM=;
        b=s5/KIvnfgDUGLlM57psOS2EwtqjDMpWoGvQupEtpCQzekrYjld+XGr++3mThZs0c/X
         r6RMgpgM1VEJeQot04s5wc22/1imAzrmWWj6ukBF9dE9ABa8dJ5iak5yyIDnjTiXLD1J
         DROSzr1xgXBM6KwIbW/e9SkIvyDUBqen/vLOrV9j8FdB4MujI+Caqf76KZtVcWf+NCph
         UKM1grdIetm97HYtsOapCcPvt2nULlxtU1X1Fz8ieo7QAQkNOrAri+RUovHTn95zmAwq
         J2PnpfkXlAnYRt2xR/Tx2R/GExy2cPQhc6erXfQmAbVznf+3LudbekLQsPXdvnZE8wfK
         xUKA==
X-Gm-Message-State: AOJu0YyQtDgtmsvGrYSLR9xMomd3wYgESATe0q5P2cFhRoIyQHvEPBph
	WxoiRDSxhyuaSOztVmLyh/yIuRSapwDPfYAeJqlVBYLBQ8FOXTQ77EujsYMkNwwRsIUQHtIXsxH
	Asej0XIq5d4ukLN/sz2Xn/kzBpOye7GfbCKmHFxojaCLsbPipwtsLcE/nAdE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1f83:b0:69d:a1d0:26d7 with SMTP id
 006d021491bc7-69e480a7836mr3209370eaf.47.1780584453841; Thu, 04 Jun 2026
 07:47:33 -0700 (PDT)
Date: Thu, 04 Jun 2026 07:47:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a219005.e4db5ad2.5fee4.0060.GAE@google.com>
Subject: [moderation/CI] Re: vfio/pci: Add PCIe TPH support
From: syzbot ci <syzbot+ci36a206614ae21ca5@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v16] vfio/pci: Add PCIe TPH support
https://lore.kernel.org/all/20260604132804.28678-1-fengchengwen@huawei.com
* [PATCH v16 01/12] PCI/TPH: Fix pcie_tph_get_st_table_loc() field extraction
* [PATCH v16 02/12] PCI/TPH: Fix tph_enabled concurrent update race by bitfield packing
* [PATCH v16 03/12] PCI/TPH: Cache TPH requester capability at probe time
* [PATCH v16 04/12] PCI/TPH: Refactor pcie_enable_tph & add explicit requester variant
* [PATCH v16 05/12] PCI/TPH: Refactor pcie_tph_get_cpu_st & add explicit variant
* [PATCH v16 06/12] PCI/TPH: expose the enabled TPH requester type
* [PATCH v16 07/12] PCI/TPH: Add pcie_tph_supported() helper to check TPH capability attributes
* [PATCH v16 08/12] vfio/pci: Hide TPH capability when TPH is unsupported
* [PATCH v16 09/12] vfio/pci: Add TPH_ENABLE feature skeleton and unsafe module parameter
* [PATCH v16 10/12] vfio/pci: Add TPH_CPU_ST to query CPU's TPH steering tag
* [PATCH v16 11/12] vfio/pci: Add TPH_ST_CONFIG for PCIe TPH ST configuration
* [PATCH v16 12/12] vfio/pci: Virtualize PCIe TPH capability registers

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/9b7b69b8-bfdc-4bd3-b1b3-f39969de466d

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      ba3e43a9e601636f5edb54e259a74f96ca3b8fd8
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/ebe0427d-6ae9-43ad-8794-5f7369454756/config

drivers/vfio/pci/vfio_pci_config.c:1166:9: error: call to undeclared function 'FIELD_GET'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

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

