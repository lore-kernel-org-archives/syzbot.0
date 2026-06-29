Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7006B35675B
	for <syzbot@lists.linux.dev>; Mon, 29 Jun 2026 14:46:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782744378; cv=none; b=TpvEsHZOUH5RNX2F/hJzCU3qtMPxLgzOzShzVWeFHbG7Fth3Urg3t92u/4N1Vl0mf9uLaAwrcd+6HIlQ3Cd+6cK3UO/F/z+6vR37mj+LfVVMzET56TYcceRgEBNWTq3xe3a1yixE8TCbFOXRcvnh86OZPCeLYfn1eVLqjb6f+Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782744378; c=relaxed/simple;
	bh=qNRh9GfvE5r2ZQs4YBrsYdHDiD7PTckCZGUUxSxjNCQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=gQTyMuoGXaH0kPgCh5XSX3j3oZfnywZAAqM0Zxco9IC+cb+nr1d/GfvA7DKqEplKUYSFaYWK1Qkdm+LQcUSTXcwkpCDKPLlL0XETLllxFgaRcjlBKeAClSDFxycV3sgTISxqqdfG8gfMU5iJXUwnDJHQYEfIwm1tXqbDo7ppQ94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-495e6bbed50so239653b6e.1
        for <syzbot@lists.linux.dev>; Mon, 29 Jun 2026 07:46:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782744375; x=1783349175;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=8wtLI8ZH0Xg+kKw+RlQb22zFGY2TWajXQMfskloSpwg=;
        b=cVl1cjL7t+2tMZNdFh71Q+ldMrL7TPEuUSTodooTn67A6sB4Fvw0jLNpwbnnHUOzPw
         e8sOTcmWkS+wDHWHMPcnEXCJM3qHmO9SgKoIAHvEGmECTmV/R0UvrNuGoEXjfle8fWIh
         4pAZWS3Sn52a5/myNnTXF+wxLgUIW03u1+Gz0EuZ8FsmNVaLEmGP14OHEGCDm59iP+2B
         spziFxjgPjQtMzGNdhP3+5HZsJUFQoLLh03PkWwGWYH4EIYa90TZ6o6EI2Lbib4CPGMk
         M5yl7vyQVU5ETz48NdrUPoC3quV76t2TDZFnc3ED2piGwc/2A+wlB2XfvhCjZQuLE/jm
         6RCA==
X-Gm-Message-State: AOJu0YyggasAwCJnyESXF1b9AQhC3nMfe62sljj92QP3OLnMtBAEXlf2
	0FR6UA9cpYRcUYA7ZTixZspO3Qhlxj5ZoSJ0vILRx9pFvZwr6c6FGBGwwvU3w4XgFRqec1VxzHq
	xj9q9PbeptHv0QE06dPeRmSFpZdSfQlJeFDHFEGgB+o1LR5CMTFwW19Rf2rg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c18d:b0:485:7c72:bd08 with SMTP id
 5614622812f47-48ee577e684mr18683417b6e.33.1782744375517; Mon, 29 Jun 2026
 07:46:15 -0700 (PDT)
Date: Mon, 29 Jun 2026 07:46:15 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a428537.854d4ab9.360e1d.0009.GAE@google.com>
Subject: [moderation/CI] Re: Add support for IPQ5018 Bluetooth
From: syzbot ci <syzbot+ci65ba89adbec7a7b3@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] Add support for IPQ5018 Bluetooth
https://lore.kernel.org/all/20260629-ipq5018-bluetooth-v2-0-02770f03b6bb@ou=
tlook.com
* [PATCH v2 1/6] dt-bindings: net: bluetooth: Document Qualcomm IPQ5018 Blu=
etooth controller
* [PATCH v2 2/6] Bluetooth: btqca: Add IPQ5018 support
* [PATCH v2 3/6] firmware: qcom: scm: Add support for setting Bluetooth pow=
er modes
* [PATCH v2 4/6] Bluetooth: Introduce Qualcomm IPQ5018 IPC based HCI driver
* [PATCH v2 5/6] arm64: dts: qcom: ipq5018: add nodes required for Bluetoot=
h support
* [PATCH v2 6/6] MAINTAINERS: Add entry for Qualcomm IPQ5018 Bluetooth driv=
er

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/11239a4c-1917-4b73-8aa0-02496635d8f0

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      805185b7c7a1069e407b6f7b3bc98e44d415f484
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp=
1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/0806f9ab-e49e-4caa-8ade-1b3c22d09a6=
0/config

drivers/bluetooth/btqcomipc.c:316:9: error: call to undeclared function 'FI=
ELD_PREP'; ISO C99 and later do not support implicit function declarations =
[-Wimplicit-function-declaration]
drivers/bluetooth/btqcomipc.c:516:14: error: call to undeclared function 'F=
IELD_GET'; ISO C99 and later do not support implicit function declarations =
[-Wimplicit-function-declaration]
drivers/bluetooth/btqcomipc.c:681:8: error: call to undeclared function 'qc=
om_mdt_pas_init'; ISO C99 and later do not support implicit function declar=
ations [-Wimplicit-function-declaration]
drivers/bluetooth/btqcomipc.c:812:54: error: too few arguments to function =
call, expected 6, have 5
drivers/bluetooth/btqcomipc.c:821:22: error: use of undeclared identifier '=
HCI_QUIRK_USE_BDADDR_NVMEM'; did you mean 'HCI_QUIRK_USE_BDADDR_PROPERTY'?
drivers/bluetooth/btqcomipc.c:822:22: error: use of undeclared identifier '=
HCI_QUIRK_BDADDR_NVMEM_BE'
drivers/bluetooth/btqcomipc.c:829:12: error: call to undeclared function 'F=
IELD_PREP'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]

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
[andersson@kernel.org andrew@lunn.ch ath10k@lists.infradead.org axboe@kerne=
l.dk brgl@kernel.org conor@kernel.org davem@davemloft.net devicetree@vger.k=
ernel.org devnull@kernel.org edumazet@google.com george.moussalem@outlook.c=
om hkallweit1@gmail.com horms@kernel.org jjohnson@kernel.org johannes@sipso=
lutions.net konradybcio@kernel.org krzk@kernel.org kuba@kernel.org linux-ar=
m-msm@vger.kernel.org linux-block@vger.kernel.org linux-bluetooth@vger.kern=
el.org linux-kernel@vger.kernel.org linux-mmc@vger.kernel.org linux-remotep=
roc@vger.kernel.org linux-wireless@vger.kernel.org linux@armlinux.org.uk lu=
iz.dentz@gmail.com marcel@holtmann.org mathieu.poirier@linaro.org netdev@vg=
er.kernel.org p.zabel@pengutronix.de pabeni@redhat.com quic_bgodavar@quicin=
c.com quic_rjliao@quicinc.com robh@kernel.org saravanak@kernel.org ulfh@ker=
nel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

