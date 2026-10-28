Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214759;
	b=Mb6IqHiH77NT/+s9jRMGv5PyK+qzzzba7qIssC4KiNwDCoYSj4H8zYhm0m6envmIrnFw
	 4N7f/VekNZnzvAQeP7dfTQZ9w3CX9rvOI5QNaZISXJAXx6o5RyEGdS+ioDAz1RNdpPrFy
	 mqMVMCW8kFKz7mJuTjIp3tv53trV3Ui/dXIlc/DiqIGG2QE+paD3aaNLDFI1/pjbP/7FK
	 SR63kWKPf1rpSPb7uhs58M+Nvi94gW4aJYlcwPfyS+K/9HPirMaONhgKPc0yaxT4Pr7NO
	 4hS1jCjMV1EdrcAdABUUAnMLwsGg2RGfhpdN9B0fGVdQ4d5wCfuCMwfiTDuiLPdOh0A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214759;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=OB17v6f8NmYV3cydJcaOO7UmUvYgSX7Y7XUd0aPSlwc=;
	b=Pn2w+SxI4gRzidGY+nHKawXNVKnB3q4pFqIv+Fb2Lu2IU0d/ajaY86Q35ySXQ6YZJElz
	 6yLxxM0jliGZYb79dDrB/MWYDuLKZy6cQ1ASJPRphxIKolmA5WcnH5Tqhm5d1te9301NF
	 4DpEXdxJldZOZWbDVtUCBR1eE8GPq9Xn6O5vXYzr+ykbkk4vhUJxkUUWyzUbNfkHCigYi
	 KoN6N7z++wgiNi58c8DmE/A6Qx2AAuhCybt7hixKTDcgjKSnHCL7L9xRT0a2GMqFqJqXS
	 INdOdr7cb3ApG686gSkF3r9yBCbH0sB6wY2dr0012R8kG1WtYl0KCGMZ5maXKCq1Pxw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 81EB8606B7C7
	for <syzbot@lists.linux.dev>; Wed, 28 Oct 2026 19:12:39 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 81EB8606B7C7
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4a7de733fa9so1881409b6e.3
        for <syzbot@lists.linux.dev>; Wed, 28 Oct 2026 12:12:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793214758; x=1793819558;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=OB17v6f8NmYV3cydJcaOO7UmUvYgSX7Y7XUd0aPSlwc=;
        b=Pa4mA5yPF0+XL3y710HH03dugRxpnE9gcOrcmsP8sqx/GwAfO0TkuDOgXSV2vFYqah
         WgFyGrrqUMeG7GVadWnO8pRxZPpKkC4/kXaDIT4WoNH1Z2hz7C5kyZKDWiVCkP27VT3Z
         Ib/8rtD+t3jfBGloJcwh9WQbXANA6LfxKq17bp/eu2zdiCIq5P1WhwCOL10tJYKUngUU
         X/jGBJYXatNbJqcv0czrIPltJ41X2aK1m3Gdp8gc9Z3cc3ql5JAAh/3fwhl0KnoOE9QR
         W9KKp+hDeF73N64h7uELiitQS7lYjknBkFWYebOWXc8JWXmsHdcsjTmxplZ+u25mHj4o
         36WQ==
X-Gm-Message-State: AFq9FYL4MAuKPye/05EDncok+T1vTlSSlybvcjgDw5J4V2oJZHEOgf0s
	9xLrBw4/8BoQYMCL7BojpoTap+2A5tbDgjEQZ+2q6A3KbHT5lnX2LrrhDvoWOw5LfVgTWW2iSaT
	eIxYzmItnnPGv/SSKBFa2ox48ChXeGQDAT/jvjLZXSju5RyLpMxw09WImx/E=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1b26:b0:4d6:90f3:74a3 with SMTP id
 5614622812f47-5638439be59mr2348813b6e.46.1793214758635; Wed, 28 Oct 2026
 12:12:38 -0700 (PDT)
Date: Wed, 28 Oct 2026 12:12:38 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae24926.563b7334.151a55.006f.GAE@google.com>
Subject: [moderation/CI] Re: vxlan: reject adding a remote to a nexthop fdb entry
From: syzbot ci <syzbot+ci77d1175af83fb6f9@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] vxlan: reject adding a remote to a nexthop fdb entry
https://lore.kernel.org/all/20261028111626.3460759-1-bsdhenrymartin@gmail.c=
om
* [PATCH net v5 1/2] vxlan: reject adding a remote to a nexthop fdb entry
* [PATCH net v5 2/2] vxlan: reject VNI add when the default fdb entry is ne=
xthop-backed

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/f7fd20f7-d301-4fed-9566-697656205c6d

***

kernel build error

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      c03c1a14507dfaf8b856c2608f9ac216021fc222
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/7d3d2084-a9fe-4c35-95b7-30c5a8ad00d=
c/config

drivers/net/vxlan/vxlan_vnifilter.c:746:23: error: use of undeclared identi=
fier 'cfg'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[andrew@lunn.ch atenart@redhat.com bsdhenrymartin@gmail.com davem@davemloft=
.net edumazet@kernel.org ferruh.yigit@amd.com horms@kernel.org i.maximets@o=
vn.org idosch@nvidia.com kuba@kernel.org kuniyu@google.com linux-kernel@vge=
r.kernel.org netdev@vger.kernel.org pabeni@redhat.com petrm@nvidia.com qotm=
ddnjs@gmail.com stable@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

