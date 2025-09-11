Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFDE413EFE3
	for <syzbot@lists.linux.dev>; Thu, 11 Sep 2025 19:15:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757618138; cv=none; b=PvqnQaNnpB7Xr2xll/MraebBS4s6yAcPMdkk0usPsPo3D/0pndTqK32PRqBwCdAStL0VHisKBN1AMp7Ni+C2rWvw8WKOFYcbt+38d68BW+Tfum9nirjXiuCFHRWUFpfOZ9gHYrp+cHzPvK8q9ZhLBGrLch8k2yOMn8nvh0G1A+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757618138; c=relaxed/simple;
	bh=ETpJmXaE3AgOSIM42Gwgt2wtsJdTVEkLg17OOBhdRu0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=QhpShSm/CBJhr3Y0l+1qgiXbX/+YTwUB+1DOz3hFqdGSLTl7Uy0ydouizIu5JFNvOohTaWdk7beqeXw8mJkgSo+oRikzAXIAn4T3boe9M5s55dc5+8tFTEWII7Vmk3R4IO12p0bMZwY7HeZPHGW7mQkeGGvBK9JUAM9JAesrT0A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-40e59fba17dso17843775ab.1
        for <syzbot@lists.linux.dev>; Thu, 11 Sep 2025 12:15:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757618136; x=1758222936;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hVc6z/DKRUrU+QxklqBfZBWVFMA8MgZ2PA/fWVL0dQg=;
        b=LBB93DPfhEkgRNuWuiQ8yRlG3/OUXpuWA9Wv30QXu+n6LFiDkGqU2Iu0HAVpM2XOTJ
         kiTe6Ql9nxNnCcJ2rjAHt0AZ2fdwC+pVyX203neT66c5R0GS6g32Rt98OgiRXBlkjQ2v
         gOQCeUwb/zlIeLkFoF46r30sf0Ekx2xYkrVmbCGeTZHgyGdihOjiU417YHyAGeUjSP5F
         p0VdGEk3KRUbpmByahm7yvq+Czx7AbdQJR5kE+5e/EpS/e1AN6g7BhdImc6QIkQrRklZ
         NbBwMuCGiSC7RaSl8WDtAPkWtXQfybsZQ4uoP5vkAogmAxbhScpjjou9o4r9ZAIsUKtn
         M8fw==
X-Gm-Message-State: AOJu0YwfreOLJ5WvutFJascSLOelVgSxVl0zMgWHNuTmqDAsHFnWhC1g
	5Q+p+o76CfbElSVdMIvW7Ntp6s5wvwKYL79hj0o61H58tStnzfni6bKv9QLMhudbRSDZhXDpySE
	J4CWjfupw3Rk3HFD5ICKN3Q9SsqW9zQOPyphmzOC0+ZlP0Ap3eP9lUWD0wS8=
X-Google-Smtp-Source: AGHT+IENZmxBllAv//n1VznRgxvFxG7fZIDzLTeY0PFT+U0eldt7hlDUignDSDKjj4FJS/XFAS8Qj862gQY/4DT4tHB7Q6yUeqe7
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17ca:b0:413:d5e2:b751 with SMTP id
 e9e14a558f8ab-4209d5f850emr12037935ab.6.1757618135807; Thu, 11 Sep 2025
 12:15:35 -0700 (PDT)
Date: Thu, 11 Sep 2025 12:15:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c31fd7.050a0220.2ff435.0247.GAE@google.com>
Subject: [moderation/CI] Re: Error recovery for vfio-pci devices on s390x
From: syzbot ci <syzbot+ci0e94c5978a35bbd5@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] Error recovery for vfio-pci devices on s390x
https://lore.kernel.org/all/20250911183307.1910-1-alifm@linux.ibm.com
* [PATCH v3 01/10] PCI: Avoid saving error values for config space
* [PATCH v3 02/10] PCI: Add additional checks for flr reset
* [PATCH v3 03/10] PCI: Allow per function PCI slots
* [PATCH v3 04/10] s390/pci: Add architecture specific resource/bus address translation
* [PATCH v3 05/10] s390/pci: Restore IRQ unconditionally for the zPCI device
* [PATCH v3 06/10] s390/pci: Update the logic for detecting passthrough device
* [PATCH v3 07/10] s390/pci: Store PCI error information for passthrough devices
* [PATCH v3 08/10] vfio-pci/zdev: Add a device feature for error information
* [PATCH v3 09/10] vfio: Add a reset_done callback for vfio-pci driver
* [PATCH v3 10/10] vfio: Remove the pcie check for VFIO_PCI_ERR_IRQ_INDEX

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/3eb74c21-a02b-4403-8f7c-df336466361a

***

kernel build error

tree:      kvm-next
URL:       https://kernel.googlesource.com/pub/scm/virt/kvm/kvm/
base:      a6ad54137af92535cfe32e19e5f3bc1bb7dbd383
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/e8d6c5f8-5227-41fb-a3f8-8058ff9719a5/config

drivers/vfio/pci/vfio_pci_priv.h:108:1: error: expected identifier or '('

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[alex.williamson@redhat.com alifm@linux.ibm.com helgaas@kernel.org kvm@vger.kernel.org linux-kernel@vger.kernel.org linux-pci@vger.kernel.org linux-s390@vger.kernel.org mjrosato@linux.ibm.com schnelle@linux.ibm.com]

If the report looks fine to you, reply with:
#syz upstream

