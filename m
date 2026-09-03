Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270B44B149B
	for <syzbot@lists.linux.dev>; Thu,  3 Sep 2026 14:10:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788444624; cv=none; b=ifr/bUXGTov/lRv2kZ92M4E/iAII7485MZbSE4TvwrfxaVQAUwsWKn+KDxeqHhSLWKwyd0urp/6P7EvF5yPO6AMmRZOYXKfC5E4rm5xoc7UV5MZSChue/71irzM1Q6z5LrA/NuHqzOP9s5ntsFGjMwiFIH+xY6/lLr+FwYh6Q+0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788444624; c=relaxed/simple;
	bh=PbpNHHZM/ct4nLMgahUyzXAYjo8m7ViRpYq0u3OD1YQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=LuBqVzXie/RgMCbusb1UwAfmE/yjDmu+qoeD66lNQfs3bhqHXv5rQE+SF83qlILwYZ3nSNPieAJ2YvqCnTKo7/sxJ63E0kp3IU55dBbkev43GDC2sUF08u/BWFrMhNoRzJBYUbLNXM8SIAE/Zf7lCQZ4HMNAZMtd3YtGjPg9cVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4b28db6c77aso2523585b6e.3
        for <syzbot@lists.linux.dev>; Thu, 03 Sep 2026 07:10:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788444608; x=1789049408;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=piPMMlJ6JBQumRt3BaHjNjnvMvhd23TOeF6kxkijsjg=;
        b=h3ug7aEvLdEvITUQLcfiGQ240hvV4I+HHC/5BJV7HG4bs2VPV9oZ6eeN/zTu9BGbkE
         DtH2sDX0gYk0oQU7JTHSU+Z5TXF9C1XVJNMbYos3CX4l4vRUqydbHKjqKAnCtqCZCXOM
         3650ywTah14R+KxkbPfLEEEHyZNiCbqq+X+OpyzM/feSTo/IpEeez1hCMbv75mr/MEuD
         yY4XiOPu+9SxXGPbdJdmBzEJxwYATg1F5duuTv17B8Hdxq8AtetO3jIiCWDLKHgss4P1
         3kfieEEAuRbgTt7i37QIjGql5RH8k0bdb1hyc5PJp/3KDwDLyN/Tt0ltf6a+UmsiSu1j
         H4Tw==
X-Gm-Message-State: AFuF++mpmNTLYsfWi8xkEw6XUvrDRVy1N6aKnDsEfeLeS91x+dqvQRpg
	wyRSWj7ck4SzYJcOpHVCb4u9NOQcI56DXvfrCpA0kVLOGFj7tC+ZafE56go1wqOVgCmN9xbI+2W
	5dlXc/7MUxMaNWEUoP5Dy898DsymsQewNCOjJ2N8rnXGn/VAc0+Cfoo+4yMA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1688:b0:6b2:f445:af1d with SMTP id
 006d021491bc7-6b47c3b4911mr9614854eaf.5.1788444608680; Thu, 03 Sep 2026
 07:10:08 -0700 (PDT)
Date: Thu, 03 Sep 2026 07:10:08 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a997fc0.9266084e.bf0d7.025b.GAE@google.com>
Subject: [moderation/CI] Re: ax88179_178a: Add support for AX88179A-based chips
From: syzbot ci <syzbot+ci5b8d854ef820d7f9@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v9] ax88179_178a: Add support for AX88179A-based chips
https://lore.kernel.org/all/20260902-ax88179a-v9-0-8e6d7710a2ae@birger-kobl=
itz.de
* [PATCH net-next v9 01/15] phylink: Add phylink_mac_interrupt
* [PATCH net-next v9 02/15] phylib: Add support for PHYs with broken forced=
 mode
* [PATCH net-next v9 03/15] ax88179_178a: Fix endianness of pause watermark=
 register
* [PATCH net-next v9 04/15] ax88179_178a: Split driver into library and dev=
ice specific code
* [PATCH net-next v9 05/15] ax88179_178a: Add netdev2data() convenience fun=
ction
* [PATCH net-next v9 06/15] ax88179_178a: Add HW support for AX179A-based c=
hips
* [PATCH net-next v9 07/15] ax88179_178a: Add EEE configuration support for=
 AX88179A MACs
* [PATCH net-next v9 08/15] ax88179_178a: Add EEE configuration support for=
 AX88179A PHYs
* [PATCH net-next v9 09/15] ax88179_178a: Add VLAN offload support for AX88=
179A
* [PATCH net-next v9 10/15] ax88179_178a: Add AX179A/AX279 multicast config=
uration
* [PATCH net-next v9 11/15] ax88179_178a: Add Suspend/resume support for AX=
88179A/772D/279
* [PATCH net-next v9 12/15] ax88179_178a: Add ethtool get_drvinfo
* [PATCH net-next v9 13/15] ax88179_178a: Update driver name and informatio=
n
* [PATCH net-next v9 14/15] ax88179_178a: Add support for AX88179A/772D/279=
 EEPROM access
* [PATCH net-next v9 15/15] ax88796b: Add support for AX88772D, AX88179A an=
d AX88279

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/da1ee2ab-0378-4af7-9df2-20c15b1df325

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      1bb784eb6e38fd73143f021608e4ef3095d0c0d7
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/a18e865e-94ef-47f0-8f08-230ab0bd7bb=
1/config

drivers/net/usb/ax88179a_devices.c:123:24: error: use of undeclared identif=
ier 'data'; did you mean '_data'?
drivers/net/usb/ax88179a_devices.c:123:28: error: member reference base typ=
e 'char' is not a structure or union

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
[andrew@lunn.ch davem@davemloft.net edumazet@google.com hkallweit1@gmail.co=
m kuba@kernel.org linux-kernel@vger.kernel.org linux-usb@vger.kernel.org li=
nux@armlinux.org.uk mail@birger-koblitz.de netdev@vger.kernel.org neuromome=
nts@gmail.com pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

