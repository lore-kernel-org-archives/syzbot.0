Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E1A938F239
	for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 06:58:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781161106; cv=none; b=j69X3KLXGnBD+NYtweiKqsZWLVEzlu9Ets4iINWtkZVsDjJjQTV5R2qTTKql7x2hG6r6LEW8yC1xUmp00IunDCMP+LjgrBX1/jxyWF35EmSLuYXr2IcDdpqU4LO4zVVV1wNjl02Re0P75+Wh+tbMgJ/52x2CfMh2OvQx+JV/i5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781161106; c=relaxed/simple;
	bh=pM3/9NwioGdEQYEgSJ2++Lyktq14V0iYDWCnmjw27x8=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=l36O2yeEcugqvlY2uCsaD0qoAdzOm44AliWIVOxYtHqfAGDoLuSybyvSP/jSDR395vOfznszXvGiD4zlimL/+4ErVv/1Wv7g0ZFvLHLH9PfAAkLNRxp2rw9Vj/GSkh86KiaRKhqSlXs9AF2viEyOVGAA8sKVGzflNZzBmWEi340=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-69e37d24cb1so1095285eaf.1
        for <syzbot@lists.linux.dev>; Wed, 10 Jun 2026 23:58:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781161101; x=1781765901;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=shWhDC3lJYIopJa+6QMSiIUGzpD/ql7j76k7EG0VqgI=;
        b=qAwdC6WRCXcNbCq3Cvntv9qpqhATMKpLlgmHA/QnjDd9laJBzX1u7Sl8paxEcOoe6i
         X/Rq9Cq/Udnr4Kqr4mUNWPK6OyuChHoF1PqDEULLl8xJ9uLArXvZSXsM/YOTJFDDuTzF
         70OLB3l3Kp3kaMnbETdzdBfFuTuZPvVFViku0B6cMx0Gzt69jipHhepX6RJmT4+hemRd
         HDJeaIg6x93AKhTtXiv4qzsjgNpE+gaLFN+V6sFxTP5HGjMvlLTNmLL9z4PLIxqvqhHQ
         +DdnvqEl9okbBrnChEpdLAA16zAcqqqqsLjiWdhb5BpjnP/tGOUEc41vDNd8x/3bQEOW
         psBQ==
X-Gm-Message-State: AOJu0Yxq21nFWUTvnSv4us661YYljyFm3fCEIa1dTbH85QdgPxQMfljf
	So6sLLLT5U7VtHaR9cdoTMF6wIMB3C5qxUrOOQwAKM1bb/TYYSt/h4WGE9GAUhazp3dd32WTYLH
	DmIUX2ilQbsJub7SagXoiG7TyttmcQEtpzl3l5m3kL7h3KfjrL2H6qBvgqno=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:609:b0:69d:5a5f:a94 with SMTP id
 006d021491bc7-69ecae7e86amr915613eaf.15.1781161101130; Wed, 10 Jun 2026
 23:58:21 -0700 (PDT)
Date: Wed, 10 Jun 2026 23:58:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a2a5c8d.3b0a2d4e.8c8d1.0009.GAE@google.com>
Subject: [moderation/CI] Re: vfio/pci: Support ZONE_DEVICE-backed P2P Registration
From: syzbot ci <syzbot+ci9cc0b10ebae46e88@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] vfio/pci: Support ZONE_DEVICE-backed P2P Registration
https://lore.kernel.org/all/20260610151853.3608948-1-praan@google.com
* [RFC PATCH 1/5] vfio: Add UAPI for ZONE_DEVICE-backed P2P registration
* [RFC PATCH 2/5] vfio/pci: Implement ZONE_DEVICE-backed P2P registration
* [RFC PATCH 3/5] vfio/pci: Block mmap & dmabuf export for ZONE_DEVICE-regi=
stered BARs
* [RFC PATCH 4/5] vfio/pci: Block ZONE_DEVICE registration for BARs with ac=
tive DMABUFs
* [RFC PATCH 5/5] PCI/P2PDMA: Introduce a helper to release P2P resources

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/1de9f593-0233-404a-961d-39efb4662ff8

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      abe651837cb394f76d738a7a747322fca3bf17ba
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/78f945da-79a3-47fe-802a-04960bafe8b=
6/config

drivers/vfio/pci/vfio_pci_core.c:1709:3: error: call to undeclared function=
 'pci_p2pdma_remove_resource'; ISO C99 and later do not support implicit fu=
nction declarations [-Wimplicit-function-declaration]

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
[alex@shazbot.org ankita@nvidia.com bhelgaas@google.com jgg@ziepe.ca kevin.=
tian@intel.com kvm@vger.kernel.org leon@kernel.org linux-kernel@vger.kernel=
.org linux-pci@vger.kernel.org logang@deltatee.com mattev@meta.com praan@go=
ogle.com shivajikant@google.com skhawaja@google.com vivek.kasireddy@intel.c=
om]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

