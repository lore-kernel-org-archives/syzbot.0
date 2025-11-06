Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C348928C00C
	for <syzbot@lists.linux.dev>; Thu,  6 Nov 2025 15:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762444577; cv=none; b=XXiVt5GKhlJavPXa2zvR1DgHffXRp3vcO3vCh4Tpo+A6NBKyezAlz7VRSjhzMuZvvMrsn2WQWcjTylNE2YNIxzmPVazAi8xsUA27M3tJbXf0vOmuGGxEgF9+XADUJFvyVOJxxV0j6zIkouDxApNf6MlU2sqEnABRjdCKTD/ZFDs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762444577; c=relaxed/simple;
	bh=W+HmrdxFDd93+XP8RZGwJe4IczH2+I53ArTmn/SRFKg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=YwsZnPcIMUGJsOR8pbuYc81rXnPNTJPKorXnaccqkuSQ5lYXK0IiXwcx2BiVCHxZ1jmkbXIFHwM75+JWDsAP2WTZ2aSV51fQM6vPdDZZxEejRMAvHW9HB+NB6IxUzb1GVO+q+pcT/YLf/h8LVKT0V5CSlK6bJ49xDbf1OxgyjGE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-9486e1db3d9so136198739f.2
        for <syzbot@lists.linux.dev>; Thu, 06 Nov 2025 07:56:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762444573; x=1763049373;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=HqBs0OUBy42H5IZ+JzpOXMNrz2ZddrjUVT+m2RGNmXA=;
        b=xI1DcBnAaNYIzyy718hfMc42mjS/emn4DrgUuy6vw2P0tzlWFYtysyVisydDX7PCCa
         zm3kHrLZ5MtE2q6iTtXBJygEcjWVBZUQ0aqKwAVqOhHzU1goETTjjqU/vMhbGRVx37UU
         fE0ceqXD9lBSI8r+BVyYIVyvmVqU2XLmQdZr3ryugiVNjsfDHVSOph8DwehZUEQkdAK1
         LEYsIEax9Jp9GfycMwFd64Kc6KhpQm7WlrJyo3lCpLI7jQgVpEBQoenE0PuXomrKFIZI
         sTXh9vwS8c2HHIyaSRc9yTgBaeCIw/+LoLxpNp2kGIJ11uYeW/8ff8ndIjPXKLYwiFQ9
         fIrA==
X-Gm-Message-State: AOJu0YwbvEuBu2WnWXgn9fJn2/rsVMIS47gkSOvJqNnr2Z1Z027mRwWy
	rdVcDEtGS/EEZwyItQuD7aCY0wucyc7oaiDNJvJ5yQol4S/66LWBGPJTnPVy6S/MSVoGSDpgJs5
	k4GgWFnRU8YxGZqT0nR779cSHopBSaGGG6rQFDirCE17yRsUkkveM7EnytJk=
X-Google-Smtp-Source: AGHT+IG7qt0bmQuAKtWibKbpCYtoOzY10/XZC9Y4LHcqhJ7xeq+iyHOYnMQqOdFflN6TWBRqDw+tQJRkPjPIeJ/KW2EV7r9kiL/F
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:2c92:b0:948:6046:adf0 with SMTP id
 ca18e2360f4ac-94869b4285amr1247491839f.0.1762444572886; Thu, 06 Nov 2025
 07:56:12 -0800 (PST)
Date: Thu, 06 Nov 2025 07:56:12 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690cc51c.a70a0220.22f260.0000.GAE@google.com>
Subject: [moderation/CI] Re: vfio/pci: Allow MMIO regions to be exported
 through dma-buf
From: syzbot ci <syzbot+ci8948b0e8ec79a74d@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v7] vfio/pci: Allow MMIO regions to be exported through dma-buf
https://lore.kernel.org/all/20251106-dmabuf-vfio-v7-0-2503bf390699@nvidia.c=
om
* [PATCH v7 01/11] PCI/P2PDMA: Separate the mmap() support from the core lo=
gic
* [PATCH v7 02/11] PCI/P2PDMA: Simplify bus address mapping API
* [PATCH v7 03/11] PCI/P2PDMA: Refactor to separate core P2P functionality =
from memory allocation
* [PATCH v7 04/11] PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() f=
unction
* [PATCH v7 05/11] PCI/P2PDMA: Document DMABUF model
* [PATCH v7 06/11] dma-buf: provide phys_vec to scatter-gather mapping rout=
ine
* [PATCH v7 07/11] vfio: Export vfio device get and put registration helper=
s
* [PATCH v7 08/11] vfio/pci: Share the core device pointer while invoking f=
eature functions
* [PATCH v7 09/11] vfio/pci: Enable peer-to-peer DMA transactions by defaul=
t
* [PATCH v7 10/11] vfio/pci: Add dma-buf export support for MMIO regions
* [PATCH v7 11/11] vfio/nvgrace: Support get_dmabuf_phys

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/83488872-f468-4aa4-bc80-437e554e8aeb

***

kernel build error

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      6b36119b94d0b2bb8cea9d512017efafd461d6ac
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/481ad68d-be80-4780-b856-58d29aacf33=
c/config

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

