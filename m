Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E3092D0620
	for <syzbot@lists.linux.dev>; Wed, 25 Feb 2026 10:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772014862; cv=none; b=TPs9+AtwFZg7S2F3wXh8e6CelqraULY9ucgW6BwgcT6BwjuN+Y1fotFtic4kJ670/OEoOtidr+iSjt+8bMYgzYZQQWD7ajtHrE2MsY2e9HlUcTDdeUS78qsVINLAC1VV4ROq3lj37vD0LhAJo9nAxAk6XBYNHJCFjiWEKZw1GN4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772014862; c=relaxed/simple;
	bh=pESNJHiZ2IjR7SFCapfLH8GJQdQjj4MCzVOyAYqQn3E=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=SNQn+OFbogRU+Nbkc1hMoMtHLCr2JRGOh2H18xLadjzL3ab3Xo4/tDpR3tWHsu6x57ZAk/APqiOiERz90x99wfEZVNuiB1athT0cFSWgNMsEWh2nUXr2t2Yf2nzm7ins/aUu77rZAntWuELs/Es8+u1or1quaGDBy9hnGl9aEr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7d18d6e6541so27493666a34.3
        for <syzbot@lists.linux.dev>; Wed, 25 Feb 2026 02:21:01 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772014860; x=1772619660;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=WlbMoSVqNO9k1UA/xJnjitFmBebem3TWIdLPuYqz7/c=;
        b=Xejimpf5sDD3R8NdG1FVSgLx2suCVsUqshLCKIXkeGYzpw4NQheyJnXxBgA2lFqbZA
         pYvqkbHOe6e732t2vQgJs8HJdHMFx8KQQH3H90VgE4eQDzJ0zsZ3t/qhiv45+eCLmbE8
         K8WpBNZZ6hXYPeD36qkihDFfii1xMsOZUvliiw1UL5HUJ2M2M8BvrMwJ6+9ZXApZis0c
         47fF75RWh74p4r+MLQfMOVAYHGjQ7b21uLockbJPUnC5uxmJ01jckm74h3c62KaxcBgH
         3Fk7PYU2HOop4B0kntiYTDS7xos2dcOSrF49uwAXXS2lXN/gZzyCjIXyxEFPwE6Gr3A9
         zI4A==
X-Gm-Message-State: AOJu0YyFlKy/tTK7AgpZO0Dkuh2SLW91oxzigMv0ze2AJ9zAjwEPjq6i
	sShYAk5n+NLEAMcZQ5eqFh5YmgR3pseszjcT9NAsXDJg8SfsZ/YT3WTsNUlYvjDS7e8bTC0UROi
	9QRff4Zi2XQrkTOQCX9ZJQ15H8SrV2oCM52EJmhuOIez6JNO5QSMGmSftKwE=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:201c:b0:66d:fb53:8279 with SMTP id
 006d021491bc7-679c466e470mr8407551eaf.2.1772014860112; Wed, 25 Feb 2026
 02:21:00 -0800 (PST)
Date: Wed, 25 Feb 2026 02:21:00 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <699ecd0c.a00a0220.21906d.0006.GAE@google.com>
Subject: [moderation/CI] Re: PCI/TSM: coco/sev-guest: Implement SEV-TIO PCIe
 TDISP (phase2)
From: syzbot ci <syzbot+ci540f1d67b8cb4cf8@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] PCI/TSM: coco/sev-guest: Implement SEV-TIO PCIe TDISP (phase2)
https://lore.kernel.org/all/20260225053806.3311234-1-aik@amd.com
* [PATCH kernel 1/9] pci/tsm: Add TDISP report blob and helpers to parse it
* [PATCH kernel 2/9] pci/tsm: Add tsm_tdi_status
* [PATCH kernel 3/9] coco/sev-guest: Allow multiple source files in the dri=
ver
* [PATCH kernel 4/9] dma/swiotlb: Stop forcing SWIOTLB for TDISP devices
* [PATCH kernel 5/9] x86/mm: Stop forcing decrypted page state for TDISP de=
vices
* [PATCH kernel 6/9] x86/dma-direct: Stop changing encrypted page state for=
 TDISP devices
* [PATCH kernel 7/9] coco/sev-guest: Implement the guest support for SEV TI=
O (phase2)
* [PATCH kernel 8/9] RFC: PCI: Avoid needless touching of Command register
* [PATCH kernel 9/9] pci: Allow encrypted MMIO mapping via sysfs

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/104c65e3-d8a7-4aa7-b1cb-ecc9f89b9842

***

kernel build error

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      e89f0e9a0a007e8c3afb8ecd739c0b3255422b00
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/4d4a2f11-2662-4b42-8ccb-c1711fdb51c=
5/config

./include/linux/swiotlb.h:182:6: error: call to undeclared function 'device=
_cc_accepted'; ISO C99 and later do not support implicit function declarati=
ons [-Wimplicit-function-declaration]
./arch/x86/include/asm/dma-direct.h:20:6: error: call to undeclared functio=
n 'device_cc_accepted'; ISO C99 and later do not support implicit function =
declarations [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aik@amd.com ak@linux.intel.com akpm@linux-foundation.org alex@shazbot.org =
aneesh.kumar@kernel.org ardb@kernel.org arnd@arndb.de ashish.kalra@amd.com =
augustus92@kaist.ac.kr bhelgaas@google.com bp@alien8.de catalin.marinas@arm=
.com dan.j.williams@intel.com dave.hansen@linux.intel.com dwmw@amazon.co.uk=
 efremov@linux.com geliang@kernel.org gregkh@linuxfoundation.org herbert@go=
ndor.apana.org.au hpa@zytor.com huibo.wang@amd.com iommu@lists.linux.dev ja=
cob.jun.pan@linux.intel.com jbarnes@virtuousgeek.org joerg.roedel@amd.com j=
onathan.cameron@huawei.com kevin.brodsky@arm.com kim.phillips@amd.com konra=
d.wilk@oracle.com kvm@vger.kernel.org linux-coco@lists.linux.dev linux-kern=
el@vger.kernel.org linux-pci@vger.kernel.org luto@kernel.org m.szyprowski@s=
amsung.com michael.roth@amd.com mingo@redhat.com mpe@ellerman.id.au mst@red=
hat.com neeraj.upadhyay@amd.com nikunj@amd.com pbonzini@redhat.com peterz@i=
nfradead.org piotrgregor@rsyncme.org robin.murphy@arm.com rppt@kernel.org s=
athyanarayanan.kuppuswamy@linux.intel.com seanjc@google.com sgarzare@redhat=
.com sstabellini@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

