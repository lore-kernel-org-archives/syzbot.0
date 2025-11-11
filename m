Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E911434F465
	for <syzbot@lists.linux.dev>; Tue, 11 Nov 2025 11:07:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762859246; cv=none; b=sXU+T3E3jZOdeyPqoAuEqAQ/8soislVZXcqWORyK2EFrpuahhPSfGaybp91t7mkvwQY2/ox+YXc5dUZlitEEjeij3QFuBpvXW4d5DBO37LKEVrEzdZ+WdAV6uz1pD8nO+0kE202RRtt2bZ7wS0yVh9hDaW1QKMMEM2tfRMwc9XQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762859246; c=relaxed/simple;
	bh=57J3UojNzyDbNggpJC8RzOifjfGTP4E+9oSM5g8JJNo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=CPF9cFBd+lv6CZX5/k0fte8xGaaSbW2LDwtFkbv5DlBd6hnYxR1EXRTX7ZCgyVfuhbD/c3yXQ6GZC89AcMpILROxuB1g75ihDQUYx8cGoEte3HtbzcmkOXZcu30ebmS1rxGtTg0lfi1p32lchR0V1oHOTZz8Qilfx5aCYTOJsfw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-9486f0954daso564315039f.0
        for <syzbot@lists.linux.dev>; Tue, 11 Nov 2025 03:07:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762859244; x=1763464044;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=ycyv/DWmCOmMaglejVyCoUigqrgIZyyfjnJz442/EHc=;
        b=sqrJmmnztswFNQA4yMvAcWAsMIx7A9qOipsenfX1FBP1S47Kqfev1YXXaQGzlzpy3h
         6LRQzkKVNpwVCa7M4mX0SpUSQGXKwfGrXUoF8FFbLcmsZZnBY8YGGBKvlhzJWVqqJvor
         6TwHf5/cvx3mEN8AJiP93tpgBWNWstJtqac8bbZCVNUAPIBtNo216jX/rqCsz1YgxES+
         Cqj4Z+Ua3AI4Iiw+dtpf+AlLiLOJgbBjLoQaNL7P0VpnkiLSyW+vS2TdCKbgQLcE3DvE
         nVICDyRDXH0qBlL+b8IIn4IPAX2qLhgaPwL1ot5bqjQeS6ZL1mUXh+Ea0970fUgJmZZb
         CKRw==
X-Gm-Message-State: AOJu0YxZeQcZxUrr4gEIcbneYwpvyvswChNnNXPlC7DKGIJXW93mIMNi
	lsIhCZVmrb03S+P6P3An3P3yeb8LQFyLgfMgreZ75R0WZLfnHJO/ZzFI1jc0eC+gaPLFqlQ8ynD
	/u6N701BqWUVlLuyevP1gvNeDLEqtLcnMyi52MXf4aWTFOStlgAoAZ9DzVvI=
X-Google-Smtp-Source: AGHT+IFT+7nRnPIvP4DCD6JLiZSDHI6PUROEUCPH7owIkXKvDH1233I6CjWkc4dBw66iAeTK+5j3xmuiN084gVeHgkw2/kQPVDtx
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1845:b0:433:7a94:6fcc with SMTP id
 e9e14a558f8ab-4337a94723bmr120766535ab.2.1762859244091; Tue, 11 Nov 2025
 03:07:24 -0800 (PST)
Date: Tue, 11 Nov 2025 03:07:24 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691318ec.a70a0220.22f260.0136.GAE@google.com>
Subject: [moderation/CI] Re: vfio/pci: Allow MMIO regions to be exported
 through dma-buf
From: syzbot ci <syzbot+cib465c1c7faa13a41@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v8] vfio/pci: Allow MMIO regions to be exported through dma-buf
https://lore.kernel.org/all/20251111-dmabuf-vfio-v8-0-fd9aa5df478f@nvidia.c=
om
* [PATCH v8 01/11] PCI/P2PDMA: Separate the mmap() support from the core lo=
gic
* [PATCH v8 02/11] PCI/P2PDMA: Simplify bus address mapping API
* [PATCH v8 03/11] PCI/P2PDMA: Refactor to separate core P2P functionality =
from memory allocation
* [PATCH v8 04/11] PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() f=
unction
* [PATCH v8 05/11] PCI/P2PDMA: Document DMABUF model
* [PATCH v8 06/11] dma-buf: provide phys_vec to scatter-gather mapping rout=
ine
* [PATCH v8 07/11] vfio: Export vfio device get and put registration helper=
s
* [PATCH v8 08/11] vfio/pci: Share the core device pointer while invoking f=
eature functions
* [PATCH v8 09/11] vfio/pci: Enable peer-to-peer DMA transactions by defaul=
t
* [PATCH v8 10/11] vfio/pci: Add dma-buf export support for MMIO regions
* [PATCH v8 11/11] vfio/nvgrace: Support get_dmabuf_phys

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/85689e16-0e61-409d-8a1d-8d2fd515e42f

***

kernel build error

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      6b36119b94d0b2bb8cea9d512017efafd461d6ac
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/8d1707f9-4b1b-42ae-a8eb-b3d6f05aa9b=
4/config

drivers/dma-buf/dma-buf.c:1393:10: error: use of undeclared identifier 'DMA=
_ATTR_MMIO'
drivers/dma-buf/dma-buf.c:1399:11: error: call to undeclared function 'dma_=
map_phys'; ISO C99 and later do not support implicit function declarations =
[-Wimplicit-function-declaration]
drivers/dma-buf/dma-buf.c:1401:10: error: use of undeclared identifier 'DMA=
_ATTR_MMIO'
drivers/dma-buf/dma-buf.c:1441:6: error: use of undeclared identifier 'DMA_=
ATTR_MMIO'
drivers/dma-buf/dma-buf.c:1444:4: error: call to undeclared function 'dma_u=
nmap_phys'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
drivers/dma-buf/dma-buf.c:1445:34: error: use of undeclared identifier 'DMA=
_ATTR_MMIO'
drivers/dma-buf/dma-buf.c:1476:6: error: use of undeclared identifier 'DMA_=
ATTR_MMIO'
drivers/dma-buf/dma-buf.c:1481:4: error: call to undeclared function 'dma_u=
nmap_phys'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
drivers/dma-buf/dma-buf.c:1482:34: error: use of undeclared identifier 'DMA=
_ATTR_MMIO'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org alex@shazbot.org amastro@fb.com ankita@nvidia.co=
m axboe@kernel.dk bhelgaas@google.com christian.koenig@amd.com corbet@lwn.n=
et dri-devel@lists.freedesktop.org gustavoars@kernel.org iommu@lists.linux.=
dev jgg@nvidia.com jgg@ziepe.ca joro@8bytes.org kees@kernel.org kevin.tian@=
intel.com kjaju@nvidia.com kvm@vger.kernel.org leon@kernel.org linaro-mm-si=
g@lists.linaro.org linux-block@vger.kernel.org linux-doc@vger.kernel.org li=
nux-hardening@vger.kernel.org linux-kernel@vger.kernel.org linux-media@vger=
.kernel.org linux-mm@kvack.org linux-pci@vger.kernel.org logang@deltatee.co=
m m.szyprowski@samsung.com mochs@nvidia.com nicolinc@nvidia.com robin.murph=
y@arm.com skolothumtho@nvidia.com sumit.semwal@linaro.org vivek.kasireddy@i=
ntel.com will@kernel.org yishaih@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

