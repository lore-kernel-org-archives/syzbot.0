Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6654D13D503
	for <syzbot@lists.linux.dev>; Mon, 25 Aug 2025 19:08:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756148889; cv=none; b=PzgPlsPsq7s3CYqlDGmzo4xud0xj1fL2KRm1+LerpaHJrD+LPR1GaMtqiiAAVOxv5NA35uuc5/6VtRwUfKt24gWpgt++HXm+Pvo2PuPAwog6VgEofLq0ujc0vkrKPEe9wBN3nESPb9LLsjID/CI9ljlGGu69MxRK1e9DlD9Cejg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756148889; c=relaxed/simple;
	bh=3Q0NBdDQIDdQi15JkAq5Z8A8ImThh6yHEazwXvkdcfQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=blTjUPHkQVpvlFMPBAuf6QNMod8xQslVsMs98/2HS100gWf2QFEqzbhbcb44Z4ECfra5ereFTJpNrLKrSpUn6azAD+TtrGbAm50O3rKvQ6jBh1rC0qnAPQh6W9flT3BbzenSNQQpv1KHru7ZFrxhOqqAlti5hUPI6DdJKzU4rlw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3e7172deaedso49152425ab.1
        for <syzbot@lists.linux.dev>; Mon, 25 Aug 2025 12:08:07 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756148886; x=1756753686;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=wQjyaTbSg3hmxnPFSHA17Tb4HNV6wPk3dvkvZEfCY18=;
        b=YnxOEQ/rOH5fWTec6TzEgGkk58RSVNI0oPJG9KmjX1+3IPSxnlRmHjycGBU114ndqJ
         q/AUdU9WLUaGVrE0B2MpzwxtefvLHv2mmx2pVn5izdG4BjhENDOQSkFRu9JAHS+h7upZ
         leyf3rLc97T0ZrLw9GrGy5GfMZEd0LWFOwyzQa9M0V+d2v1ZC9xCrw8kMy4G4+JjjwKJ
         2u3LFu5FvObjJWkWvxGe5CtdZn/DPdDMNu9QgxTYkslD/2Ngpx54cgNFROfozgjeUTdX
         m3vFiZnk0/67f6+VIiSYGmTfCFHkcxd6RiqrdBCTlt69WIlzWylEuHy6YPF6niLjA3VL
         v4Tw==
X-Gm-Message-State: AOJu0YyiBjrLc9w5mk2ZaOyc2n3B2qXFYdgF6uwXcQUpanrLCRSgtBpF
	lELL7wI4SUvMJh/WybiFPHNERrwDKEz4bARxtDkGIJ3BS9VKBBvVCSdOR5KtOvhPCNr2DwFNn82
	3D3dRGR8yMGTK1N5zpLGuc4LUG0RGRnIR3XDfrLPUxSq5IlxG3jz52wBMggw=
X-Google-Smtp-Source: AGHT+IEkAzJz8lq5auIvdE9FoDUCrOk/WART/UHpcug8DgfxFB51ss1u48OzaDP2KosNlMuDnDzq0jI9I7D7Ccu5Fo24pEpYZm2V
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2309:b0:3ec:d2db:9381 with SMTP id
 e9e14a558f8ab-3ecd2dbb0e4mr59894085ab.11.1756148886469; Mon, 25 Aug 2025
 12:08:06 -0700 (PDT)
Date: Mon, 25 Aug 2025 12:08:06 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68acb496.a00a0220.33401d.045d.GAE@google.com>
Subject: [moderation/CI] Re: Error recovery for vfio-pci devices on s390x
From: syzbot ci <syzbot+ci787d5046e238b4e5@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] Error recovery for vfio-pci devices on s390x
https://lore.kernel.org/all/20250825171226.1602-1-alifm@linux.ibm.com
* [PATCH v2 1/9] PCI: Avoid restoring error values in config space
* [PATCH v2 2/9] PCI: Add additional checks for flr and pm reset
* [PATCH v2 3/9] PCI: Allow per function PCI slots for hypervisor isolated functions
* [PATCH v2 4/9] s390/pci: Restore airq unconditionally for the zPCI device
* [PATCH v2 5/9] s390/pci: Update the logic for detecting passthrough device
* [PATCH v2 6/9] s390/pci: Store PCI error information for passthrough devices
* [PATCH v2 7/9] vfio-pci/zdev: Add a device feature for error information
* [PATCH v2 8/9] vfio: Add a reset_done callback for vfio-pci driver
* [PATCH v2 9/9] vfio: Remove the pcie check for VFIO_PCI_ERR_IRQ_INDEX

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/8d8daca2-df04-4084-80a1-8dea50b26078

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      068a56e56fa81e42fc5f08dff34fab149bb60a09
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/eadaff37-3f5e-4ae0-972f-5bbff4ce9baf/config

drivers/vfio/pci/vfio_pci_priv.h:108:1: error: expected identifier or '('

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[alex.williamson@redhat.com alifm@linux.ibm.com helgaas@kernel.org kvm@vger.kernel.org linux-kernel@vger.kernel.org linux-s390@vger.kernel.org mjrosato@linux.ibm.com schnelle@linux.ibm.com]

If the report looks fine to you, reply with:
#syz upstream

