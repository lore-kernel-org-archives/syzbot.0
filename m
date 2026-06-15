Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0672E3D1A94
	for <syzbot@lists.linux.dev>; Mon, 15 Jun 2026 15:35:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781537707; cv=none; b=Sx55qp8KFHAgNmFjgulCGIBSR5g1yMyNDJPMEXufS1/14Py6aFOAeF5AA3ew6tRg0yGemrLNfD5nR21YKRnupeBXulHZBjKyYRLgspQJhyhbTlDxijwCNnn/rYDr74iBUO9xY4PWul65pA4I+oyvC8EkeWeDO3b7iw0ypYjWSvg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781537707; c=relaxed/simple;
	bh=ZjCMT9DqMhyvS/6r0XCwqQ4jD5y/URxCjdlErwxa+g4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=kSneM40RZ/kAthhNTZXvShPKapIy43hLHdAXgAEVg3wHkmsR2Sv0ChyarA4ciCMqMrP7bzqwMxYG9b0EHZEA45t3pR3CaER7qgtNYVOjWVoezp19pmKjljXBKAHVK0Tyl2M/21oYSeYe0wfhAFrV4TTYggwJLO+8pnjwnEJQUqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-48651d7d505so5334625b6e.0
        for <syzbot@lists.linux.dev>; Mon, 15 Jun 2026 08:35:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781537705; x=1782142505;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=tN2+W4otAgUkIiiyR6dUaHcYvM+2jtxFkXyT3fXNPxQ=;
        b=NVmD0TjAu/wq4VRT27NRLWVNy4Dx8D7W4ClCE+9VTJ0f2pr9irenUxDIYHMDq1HatV
         RywrIAbsFvJTmMIIRnsIC6oFCS/efl2vEMK+8BQzrEBt9UjoggDud3/VyM2LdKVB9aXy
         buY1fK6reQDFKbmciyjcLUexDsCR5OFwrbhvwoMBXjmW1WnUDKyVJo7dcx148BYSUnIL
         YQxbzFeUNQIl9ISVnupWqq5wUpufEzqBODHsTdL3gQ+uQXKsCMXs/q7lhXThSNo+5kkq
         hCSNfwHFnU0S5ST1iyhiHz1NghNSx3sqdFnduRLTAVYky8TguzWT17qSq5Kug3TbaW6l
         rmtg==
X-Gm-Message-State: AOJu0Yxc79pbfmNJEKS3P4UMFkwrmnJrdISz7p6EdCMRsJGVtGJLSsS9
	GhijKGZPSpxbW9LkfozxTEXhiHJ5PRc5iktMyJ7RwIXm/MR3B3A6yKbLahTshF/OBdd9TId9V1b
	m6JWNdOXKiLepcmxD93kRCHvzP0PLDkU19xNXASpy2RDxe1t1yloncnR1KXI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1454:b0:485:5982:4cfc with SMTP id
 5614622812f47-48741be6334mr7635702b6e.33.1781537705017; Mon, 15 Jun 2026
 08:35:05 -0700 (PDT)
Date: Mon, 15 Jun 2026 08:35:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a301ba8.428ffe26.258b27.016d.GAE@google.com>
Subject: [moderation/CI] Re: net: pcs: Introduce support for fwnode PCS
From: syzbot ci <syzbot+ciac9eee7ac2b7e416@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v7] net: pcs: Introduce support for fwnode PCS
https://lore.kernel.org/all/20260615122950.22281-1-ansuelsmth@gmail.com
* [PATCH net-next v7 01/12] net: phylink: keep and use MAC supported_interf=
aces in phylink struct
* [PATCH net-next v7 02/12] net: phylink: introduce internal phylink PCS ha=
ndling
* [PATCH net-next v7 03/12] net: phylink: add phylink_release_pcs() to exte=
rnally release a PCS
* [PATCH net-next v7 04/12] net: pcs: implement Firmware node support for P=
CS driver
* [PATCH net-next v7 05/12] net: phylink: support late PCS provider attach
* [PATCH net-next v7 06/12] net: Document PCS subsystem
* [PATCH net-next v7 07/12] MAINTAINERS: add myself as PCS subsystem mainta=
iner
* [PATCH net-next v7 08/12] of: property: fw_devlink: Add support for "pcs-=
handle"
* [PATCH net-next v7 09/12] net: phylink: add .pcs_link_down PCS OP
* [PATCH net-next v7 10/12] dt-bindings: net: pcs: Document support for Air=
oha Ethernet PCS
* [PATCH net-next v7 11/12] net: pcs: airoha: add PCS driver for Airoha AN7=
581 SoC
* [PATCH net-next v7 12/12] net: airoha: add phylink support

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/8697e3f4-ead4-4d5d-9068-ed8aecbd0b54

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      2319688890d97c63da423a3c57c23b4ab5952dfc
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/519594d7-0c1e-4dad-9a21-226aa905fde=
c/config

drivers/net/phy/phylink.c:2218:3: error: call to undeclared function 'unreg=
ister_fwnode_pcs_notifier'; ISO C99 and later do not support implicit funct=
ion declarations [-Wimplicit-function-declaration]

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
[andrew@lunn.ch ansuelsmth@gmail.com conor@kernel.org corbet@lwn.net daniel=
@makrotopia.org davem@davemloft.net devicetree@vger.kernel.org edumazet@goo=
gle.com hkallweit1@gmail.com horms@kernel.org justinstitt@google.com krzk@k=
ernel.org kuba@kernel.org linux-arm-kernel@lists.infradead.org linux-doc@vg=
er.kernel.org linux-kernel@vger.kernel.org linux-mediatek@lists.infradead.o=
rg linux@armlinux.org.uk llvm@lists.linux.dev lorenzo@kernel.org morbo@goog=
le.com nathan@kernel.org netdev@vger.kernel.org nick.desaulniers@gmail.com =
p.zabel@pengutronix.de pabeni@redhat.com robh@kernel.org saravanak@kernel.o=
rg skhan@linuxfoundation.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

