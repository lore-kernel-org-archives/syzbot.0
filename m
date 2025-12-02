Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99D482F260C
	for <syzbot@lists.linux.dev>; Tue,  2 Dec 2025 21:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764709435; cv=none; b=gx3LoN8wiqEqiwTTmbXYz4jI96no4M0qk0/nbADpOfsbRDHIkNVhnpzz9YoQ1+q+7FxUYuovGAggYY1AwdTAiXXWxolrE2wF1yXINqSCFuIFJ3LLSWUwpm4NNhQpng+uoUkIG/YnIQRasMsNZ1cWlLgKDqRBLyPO4D88kiv5Ks0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764709435; c=relaxed/simple;
	bh=bXpj5JHzNRVvFPLMVd3dYEzfrUSjtm6ZJn/oSdEBYKg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ipZDl0DTdzYFHoZ90KvsXNpVqMNBENHoBibssyDjgEp2p4wir5cfRIcL2YpB+sjltVWDfwmfpX9FQ0zvkSBG/SS67x6gXzy/9Hcn8HF01PEiBYtr8D7fT2XYi2PrCjtMI9Xtxc2RdmAmk24d6dXdr1apvsCpk9a6Ku4jV2xLk9I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4510650aea0so7213159b6e.3
        for <syzbot@lists.linux.dev>; Tue, 02 Dec 2025 13:03:53 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764709433; x=1765314233;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=OUAuETrPK6nKohwXS5x3bSeh3bj5aFs+/sH+rOl3XlA=;
        b=eogluwFnjXQhQlH0Frrp8Yz/aQLsrGQcD2otHsMPP9gooLzOMyo9CYy/v3IlA0YBBC
         PpncYptiLbyy4NfFetp3qD469o67hNzTuyEZzuTSS+9MJaUdMZm3kmGzMIY53J9Yw/R0
         qY3oiZYY0PblvjibVOy5R/iJuyuETcKLLTF+xP/9OXzNKDRUph/b2R/UgBSzt07Et0KH
         gBunapSX535N1W3VDtnx8dSegAxC/fArT0yljczMz2l7A4hKhtDWcgHb9B20kz31sHI7
         9Y0sDD7E3zBrD2qr3p0i1QSm64uH/7NOFtUdQMc+/C7Sr6IHGUb+/AasLlzxwOADnrHC
         DgRg==
X-Gm-Message-State: AOJu0YxBhn9fWj+cSBxxsWB+rJ02pUmTUpT6SUe7pkQhxmQTwLkQ4Isc
	PjwjkVYLkXMVMG7ySQdbU0GILSSL/oJHlFh8MLnLBUX08TMHNlRvQI3disFfgFItxz01YUQqTDO
	JfHanpga+fQ7tVdqYL4FqA1zK50XvwpoyyqaxUYcy4vB3izHoDvPU4lN22rw=
X-Google-Smtp-Source: AGHT+IE+Phjco3wA7lAv5Lgo70X+rJLDCGpLQLZ8HamjRdiIYMQQp/m+4zuOsXo6j/UCC/sXSziHQPP/kLO8P3EzvnaRfZDtRZI0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1312:b0:450:c423:205d with SMTP id
 5614622812f47-4536a2cd0e7mr538214b6e.46.1764709432741; Tue, 02 Dec 2025
 13:03:52 -0800 (PST)
Date: Tue, 02 Dec 2025 13:03:52 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692f5438.a70a0220.d98e3.01a6.GAE@google.com>
Subject: [moderation/CI] Re: ptp: vmclock: Add VM generation counter and ACPI notification
From: syzbot ci <syzbot+cia17a287c9c7b25e7@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] ptp: vmclock: Add VM generation counter and ACPI notification
https://lore.kernel.org/all/20251202201118.20209-1-bchalios@amazon.es
* [PATCH v2 1/4] ptp: vmclock: add vm generation counter
* [PATCH v2 2/4] ptp: vmclock: support device notifications
* [PATCH v2 3/4] dt-bindings: clock: Add device tree bindings for vmclock
* [PATCH v2 4/4] ptp: ptp_vmclock: Add device tree support

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d29f967e-9917-4e96-9188-cd7119984862

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      0177f0f07886e54e12c6f18fa58f63e63ddd3c58
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/034ae7ca-2752-41c2-8ab3-5c728dfa4ac=
c/config

:587:8: error: unknown type name 'irqreturn_t'
drivers/ptp/ptp_vmclock.c:593:9: error: use of undeclared identifier 'IRQ_H=
ANDLED'
drivers/ptp/ptp_vmclock.c:620:9: error: call to undeclared function 'devm_r=
equest_irq'; ISO C99 and later do not support implicit function declaration=
s [-Wimplicit-function-declaration]
drivers/ptp/ptp_vmclock.c:620:60: error: use of undeclared identifier 'IRQF=
_SHARED'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch bchalios@amazon.es davem@davemloft.net dwmw2@infradead.org =
dwmw@amazon.co.uk edumazet@google.com graf@amazon.de kuba@kernel.org linux-=
kernel@vger.kernel.org mzxreary@0pointer.de netdev@vger.kernel.org pabeni@r=
edhat.com richardcochran@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

