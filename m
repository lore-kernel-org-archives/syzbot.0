Received: from mail-io1-f70.google.com (mail-io1-f70.google.com [209.85.166.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D5E6734D39F
	for <syzbot@lists.linux.dev>; Sun,  2 Nov 2025 08:46:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762073169; cv=none; b=ElnEb/ndS9Ni6fhD8V3UN4lcL7ZW2tTLb3PITNLH9T/0++lIHRLScY5isIlsSsU8eURKQP7p/7KN/T5HT94/szG87ScR5uNYA8B3qOg0epm/4/VQFdxPS+ZsR6N2ZnO4KEazE2tDOq0e1PScmAh1xeQ6secyG78AvRbwU9WtkNk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762073169; c=relaxed/simple;
	bh=L17BrNHyJtG9qyzEc2URgXLuslH3PhA1RLO9nBYEwB4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Uu9kYc450kzfCjpCIRWDUd5Dsn09ttGITzkc2yIqs78UyXDZKUmRQPQsJfgCFsxuJ/rEz4VbVbFs9mUaKoJDO56ABkKd4CUj4LxyqbyModHqvHc+K9eJVXX42LneG1N51ZJECYakPV/Flfn0ydotlOAK50MtU3rCrwOF8i/Ghw8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f70.google.com with SMTP id ca18e2360f4ac-93bc56ebb0aso1093430839f.0
        for <syzbot@lists.linux.dev>; Sun, 02 Nov 2025 01:46:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762073167; x=1762677967;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=I9PYS42ICRCv/bXVVor4VdIe9q3dCieGPNEoj88kuzM=;
        b=NU5rn8yGj4gF8i12b16MZs9pS4T4aFxb1yWIssducEbY9CcuMXrC4b9G3emjFNJNZ6
         T4Mu/ZS4wdbEfQHM7AteTYWwoUa+7rYaoI0SSlBtBOufsAIt1CEF1VT3HS4PdDi7eXOi
         U/xbaCvcw48JUaX9zVYWoYsoPUrH47SEjCm8J3T7rjbxcu7svYO4HR0bBXymA5TA56vV
         TGahnovTiho8djfAP7gHRpIKLZ+sjhiWMTrSkNXK1Kjpdhk4TMzOlefJAAqI5B58Eobo
         Esma4Hf7Mt4ggLlwu/BWO9BRks3U10gmZ7XjtLNZEX8jVkNvPOzkbA/8Whj8CQ8G9yDL
         GkHA==
X-Gm-Message-State: AOJu0Yz/EdIh6aVqqHTkBz7cV/F+8OPxjjZrfypYZ2PkAtcbs1qBPQZ4
	f1aH5ashhFdwugqC9WpQ1mQpwlT+7XCj0LdXCVQhETJdFRIFpbPFnp2rekoH/GFQsi1yn0cd+6S
	zaP5KYsVxHITqpGtKkE1SRhlSLW8HNQnkc+Ph+V4AdtpEnW+3LQB24OSQGjQ=
X-Google-Smtp-Source: AGHT+IG0rasCcvuqPZeMywt+cEbb29nsiwbfQcZfCVcathkg7hF3pOPlJvz/Sh+BR74A0nDqxxcOc8fuQZWNfXrZU3Hiw/quRsyB
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6c0d:b0:943:5917:b6fb with SMTP id
 ca18e2360f4ac-9482274fc8amr1388964039f.0.1762073166998; Sun, 02 Nov 2025
 01:46:06 -0700 (PDT)
Date: Sun, 02 Nov 2025 01:46:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69071a4e.050a0220.29fc44.0019.GAE@google.com>
Subject: [moderation/CI] Re: vfio/pci: Allow MMIO regions to be exported
 through dma-buf
From: syzbot ci <syzbot+cie7d10ec38718cb14@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v6] vfio/pci: Allow MMIO regions to be exported through dma-buf
https://lore.kernel.org/all/20251102-dmabuf-vfio-v6-0-d773cff0db9f@nvidia.c=
om
* [PATCH v6 01/11] PCI/P2PDMA: Separate the mmap() support from the core lo=
gic
* [PATCH v6 02/11] PCI/P2PDMA: Simplify bus address mapping API
* [PATCH v6 03/11] PCI/P2PDMA: Refactor to separate core P2P functionality =
from memory allocation
* [PATCH v6 04/11] PCI/P2PDMA: Provide an access to pci_p2pdma_map_type() f=
unction
* [PATCH v6 05/11] PCI/P2PDMA: Document DMABUF model
* [PATCH v6 06/11] dma-buf: provide phys_vec to scatter-gather mapping rout=
ine
* [PATCH v6 07/11] vfio: Export vfio device get and put registration helper=
s
* [PATCH v6 08/11] vfio/pci: Share the core device pointer while invoking f=
eature functions
* [PATCH v6 09/11] vfio/pci: Enable peer-to-peer DMA transactions by defaul=
t
* [PATCH v6 10/11] vfio/pci: Add dma-buf export support for MMIO regions
* [PATCH v6 11/11] vfio/nvgrace: Support get_dmabuf_phys

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/3957e140-61bf-47f1-a89e-45a4665d3d99

***

kernel build error

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      6b36119b94d0b2bb8cea9d512017efafd461d6ac
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/2b2d6598-2cb2-4c0a-8142-f4918eeda55=
5/config

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
[akpm@linux-foundation.org alex.williamson@redhat.com ankita@nvidia.com axb=
oe@kernel.dk bhelgaas@google.com christian.koenig@amd.com corbet@lwn.net dr=
i-devel@lists.freedesktop.org gustavoars@kernel.org iommu@lists.linux.dev j=
gg@nvidia.com jgg@ziepe.ca joro@8bytes.org kees@kernel.org kevin.tian@intel=
.com kjaju@nvidia.com kvm@vger.kernel.org leon@kernel.org linaro-mm-sig@lis=
ts.linaro.org linux-block@vger.kernel.org linux-doc@vger.kernel.org linux-h=
ardening@vger.kernel.org linux-kernel@vger.kernel.org linux-media@vger.kern=
el.org linux-mm@kvack.org linux-pci@vger.kernel.org logang@deltatee.com m.s=
zyprowski@samsung.com mochs@nvidia.com robin.murphy@arm.com skolothumtho@nv=
idia.com sumit.semwal@linaro.org vivek.kasireddy@intel.com will@kernel.org =
yishaih@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

