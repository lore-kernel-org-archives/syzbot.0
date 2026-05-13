Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 409753559F5
	for <syzbot@lists.linux.dev>; Wed, 13 May 2026 01:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778635703; cv=none; b=g4T0wKUSC7x1DEz6wiaUSd/WpxH5e5rSKWAVOsEWsIBs1BffzqgHj3Z4d9gH3GYofSMmYXCeVHym4Ln4HaNa04amXbbsJsGNuo3NMVQjWhdR8lNtXpuUx7xf7XBBwN5K8FWUZFfx1TAYv2xgOHHSyfRBQqCs3sdX8ihJRmE3gLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778635703; c=relaxed/simple;
	bh=SOmWY7Y+iHHhscOJTyBOTqguB23ShuE2p49nQHicXTY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=kd6I4SDbYDpG7rQ9xfwsjAIkDyeWQUBhhobuco2yyiVI/3mR42IvF9fcN5avminF29CrvWby/xw7HVmMZVdk2jKtiGjQ82b1+Aj+Bc3ltyJnS3duTrhLoMOox22F9AXJO1TumSlnlM0aTAo31F37SO9kwwDoXOh6xliflIqNd+U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-69b4f753046so5437638eaf.2
        for <syzbot@lists.linux.dev>; Tue, 12 May 2026 18:28:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778635694; x=1779240494;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=bATVPOCY53NzWNghvHyEFj4eRhpBcsoCZ3T75G3axQY=;
        b=bJ5xD3dq4bE7educMouGbbfr0IbtQS+sbPt2UV78o9vkmI4ZiU/KECcCmZiLWoHh3a
         ZefiV+DRtzFgiadfb+eehjK2r54hole3wYxd3TPovCOsY1i5LI4589j4PgsAly6YL339
         vl0bNPjOkbJpoOsXB5ZFAHzljDMQjwlg+cFRYBiSI49unoWbacFxmv+XsG3+8w/B3ifn
         eXEh3EkG7p30ooCqsYp43tB+GAigleAuDNHZwRzpnsBrzNApsevPAmNkV4+fHa6IaLg1
         alL4QlvOGGegYOLfAXOJ4nvHXh/YyS6V/JuhSnRNo24MSoPuxwini47Fia/NdpSS0Vxw
         OIZg==
X-Gm-Message-State: AOJu0YwViTRBSHjVQrtoZvFPXXky+yDO+9e17TajmaWca5WASgkX+jh3
	+PeBPPq/fu711cx/Kw5GuOosOqh9hgsnRfBSXl/oMNNaeu+zOGHOuB8O6uyEhlwrFVOmVo6mOAJ
	mu7Jm27l6YOOl5JZsksjcr/K5cImyNoTPQwNeEfihK0pZK0zvzAk5Tp3mRiw=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:e905:0:b0:67b:f12a:dfcb with SMTP id
 006d021491bc7-69b7abbec48mr300830eaf.60.1778635694539; Tue, 12 May 2026
 18:28:14 -0700 (PDT)
Date: Tue, 12 May 2026 18:28:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a03d3ae.050a0220.e7082.0002.GAE@google.com>
Subject: [moderation/CI] Re: PCI: liveupdate: PCI core support for Live Update
From: syzbot ci <syzbot+ci077b8815f0ecdff2@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] PCI: liveupdate: PCI core support for Live Update
https://lore.kernel.org/all/20260512184846.119396-1-dmatlack@google.com
* [PATCH v5 01/11] PCI: liveupdate: Set up FLB handler for the PCI core
* [PATCH v5 02/11] PCI: liveupdate: Track outgoing preserved PCI devices
* [PATCH v5 03/11] PCI: liveupdate: Track incoming preserved PCI devices
* [PATCH v5 04/11] PCI: liveupdate: Document driver binding responsibilitie=
s
* [PATCH v5 05/11] PCI: liveupdate: Keep bus numbers constant during Live U=
pdate
* [PATCH v5 06/11] PCI: liveupdate: Auto-preserve upstream bridges across L=
ive Update
* [PATCH v5 07/11] PCI: liveupdate: Inherit ACS flags in incoming preserved=
 devices
* [PATCH v5 08/11] PCI: liveupdate: Inherit ARI Forwarding Enable on preser=
ved bridges
* [PATCH v5 09/11] PCI: liveupdate: Freeze preservation status during shutd=
own
* [PATCH v5 10/11] PCI: liveupdate: Do not disable bus mastering on preserv=
ed devices during kexec
* [PATCH v5 11/11] Documentation: PCI: Add documentation for Live Update

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/2bd36b56-6749-4b60-8011-0dc81da9bbbe

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      34e8f02817e31826e76bb2ded48bf28fe921f20b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/0fc4ac39-5a07-470f-8057-4c357e16552=
2/config

drivers/pci/liveupdate.h:38:1: error: expected identifier or '('

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
[ajayachandra@nvidia.com alex@shazbot.org bhelgaas@google.com chrisl@kernel=
.org corbet@lwn.net dmatlack@google.com graf@amazon.com jacob.pan@linux.mic=
rosoft.com jgg@nvidia.com jrhilke@google.com kexec@lists.infradead.org leon=
ro@nvidia.com linux-doc@vger.kernel.org linux-kernel@vger.kernel.org linux-=
mm@kvack.org linux-pci@vger.kernel.org lukas@wunner.de parav@nvidia.com pas=
ha.tatashin@soleen.com praan@google.com pratyush@kernel.org rientjes@google=
.com rppt@kernel.org saeedm@nvidia.com skhan@linuxfoundation.org skhawaja@g=
oogle.com vipinsh@google.com witu@nvidia.com yi.l.liu@intel.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

