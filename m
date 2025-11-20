Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B68307AC0
	for <syzbot@lists.linux.dev>; Thu, 20 Nov 2025 10:18:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763633898; cv=none; b=XI3mVDme4tL82bH3CXafEtpzXzVoq+9LHWLRTtDxX8MqCLgcbBJP21WQ5egiZIMaG/g6eS0CfzOlnsOWTaXAi3GZIggqnQF2T6GpD4AWcrEuznXTFCXj8SUu4mr/JPvyg82cptIWbOOJHEUbE6Rx/DCPQTRDqBlgrBBF1QzZP/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763633898; c=relaxed/simple;
	bh=EnLJOpFQYtEgu8W1zeSFUayRTHH0NDN7cK97v18xwOE=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=XXmeGayGY3+hwvVq4cP9JNpJXXlt5g1weIqBwQuY/NaALrT6Jb4mFJI7QgL6zK3hsy1gusll7SQRGfLyj2XhMRD8+NUHoiJ1IgtSwAsdb/RgArEQwGG2wCO1gGVegQv8jyXpVz+Tr06Cd7nSO/v+opiMAP4K6VneXGDEGMIY4tw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-433154d39abso8746895ab.0
        for <syzbot@lists.linux.dev>; Thu, 20 Nov 2025 02:18:16 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1763633895; x=1764238695;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4Ny7U1J4K2G955GwpNv9iashSMAeNxFouLUNeB8H5BE=;
        b=dxTkG86jRkjUh5tPGBvuKNxgv5oqaSiBdqGMbzk0N5+kI9esoZo/eDVWktF9PrhDNF
         fvHJdoDaqcK3YZRv1e+UcFZCaTGuyxgcb7kXOkYt9lRfQgo02981h4SAb5m4Ns2FbzRB
         CGlfs7c5gf39MRkOPupiFox94f3Y+fQztGhiaPMVPbfVT9TuEjKTlMlZhMkrPHLrmBaF
         uD75dVFmr0Go1dWuPvAJa6SBHd1DGqhypmVjdY+hQWQKEggEiidQaOiGNfuuUYefKU0I
         K/iPls+rXte0tSIVnp9nk3NeymXeErdy5V8EjnkGSIXcmsWBt57ERrNMvOZHgQMYdLQn
         OHrw==
X-Gm-Message-State: AOJu0Yz73utAeqhEsTjGuD4OkqR54RJxfvhBXAtjpI85/q5VMhlGHULD
	mNVGU6lKM4ibnCH+JwrNmauimFq+reBbpJ/7nax9zyEblMWSqvjjQ0teBk6OZ069uuQy/pcdL8I
	RP/DypCC58lqwPH7sT+92aYCheOab/RPRheBb/IxSnzS0Lu3gLVe7t8BidK4=
X-Google-Smtp-Source: AGHT+IHOaBZGRrKeAc80PxynhpQofRug9uf7wnFMoL+fsCbB3AZRhyN3A8i0T4/sHRxZfZf6YffZrhRaa/I28cNVF13MBnH3nTMs
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:370b:b0:433:74ec:e77b with SMTP id
 e9e14a558f8ab-435a9d9067fmr17117615ab.4.1763633895446; Thu, 20 Nov 2025
 02:18:15 -0800 (PST)
Date: Thu, 20 Nov 2025 02:18:15 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <691eeae7.a70a0220.2ea503.002b.GAE@google.com>
Subject: [moderation/CI] Re: vfio/pci: Allow MMIO regions to be exported
 through dma-buf
From: syzbot ci <syzbot+ciba5cc03b2f508f96@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v9] vfio/pci: Allow MMIO regions to be exported through dma-buf
https://lore.kernel.org/all/20251120-dmabuf-vfio-v9-0-d7f71607f371@nvidia.c=
om
* [PATCH v9 01/11] PCI/P2PDMA: Separate the mmap() support from the core lo=
gic
* [PATCH v9 02/11] PCI/P2PDMA: Simplify bus address mapping API
* [PATCH v9 03/11] PCI/P2PDMA: Refactor to separate core P2P functionality =
from memory allocation
* [PATCH v9 04/11] PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() f=
unction
* [PATCH v9 05/11] PCI/P2PDMA: Document DMABUF model
* [PATCH v9 06/11] dma-buf: provide phys_vec to scatter-gather mapping rout=
ine
* [PATCH v9 07/11] vfio: Export vfio device get and put registration helper=
s
* [PATCH v9 08/11] vfio/pci: Share the core device pointer while invoking f=
eature functions
* [PATCH v9 09/11] vfio/pci: Enable peer-to-peer DMA transactions by defaul=
t
* [PATCH v9 10/11] vfio/pci: Add dma-buf export support for MMIO regions
* [PATCH v9 11/11] vfio/nvgrace: Support get_dmabuf_phys

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/1b6bcea6-55a2-4bf7-b93b-af482815e27c

***

kernel build error

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      6b36119b94d0b2bb8cea9d512017efafd461d6ac
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/7cbb4e39-549a-467b-b6de-b320718d285=
8/config

drivers/dma-buf/dma-buf-mapping.c:150:10: error: use of undeclared identifi=
er 'DMA_ATTR_MMIO'
drivers/dma-buf/dma-buf-mapping.c:156:11: error: call to undeclared functio=
n 'dma_map_phys'; ISO C99 and later do not support implicit function declar=
ations [-Wimplicit-function-declaration]
drivers/dma-buf/dma-buf-mapping.c:158:10: error: use of undeclared identifi=
er 'DMA_ATTR_MMIO'
drivers/dma-buf/dma-buf-mapping.c:198:6: error: use of undeclared identifie=
r 'DMA_ATTR_MMIO'
drivers/dma-buf/dma-buf-mapping.c:201:4: error: call to undeclared function=
 'dma_unmap_phys'; ISO C99 and later do not support implicit function decla=
rations [-Wimplicit-function-declaration]
drivers/dma-buf/dma-buf-mapping.c:202:34: error: use of undeclared identifi=
er 'DMA_ATTR_MMIO'
drivers/dma-buf/dma-buf-mapping.c:234:6: error: use of undeclared identifie=
r 'DMA_ATTR_MMIO'
drivers/dma-buf/dma-buf-mapping.c:239:4: error: call to undeclared function=
 'dma_unmap_phys'; ISO C99 and later do not support implicit function decla=
rations [-Wimplicit-function-declaration]
drivers/dma-buf/dma-buf-mapping.c:240:34: error: use of undeclared identifi=
er 'DMA_ATTR_MMIO'

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

