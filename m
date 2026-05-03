Received: from mail-oa1-f72.google.com (mail-oa1-f72.google.com [209.85.160.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5762F37C0E3
	for <syzbot@lists.linux.dev>; Sun,  3 May 2026 17:25:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777829136; cv=none; b=V/t9eXmzW2m0SumYt4SmjcCwWVk0WN311k1Uumzszo9J+Lnra2zuxaJsrGCD/s0Ad86sBd9179bwIL7v7e876JNuuxrrNTFr5n/1PJRMQkPJr9CgmnWPobKbcRJhos4giYg2LXjWkuz/5pXefdBibnjQJU9GCjy+XUYtjro7Jgc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777829136; c=relaxed/simple;
	bh=3vJk81njhgPHJdVSt8LCp4jbOsXRz74qV6rGcClixMg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=u0qvVUtDseXK/V3IA0+Kb4f8mws6tKhi84Zt8plq5FT3ZOdSoqvF1ulW7BkeI4LdjlR7VDx82AzySsk+7t8tdFrM83HhiK4HqyM8OPFdzd8Kc1TXg/GvgasHNhDkimCmeu78DnB5v2Fg8KemU9jGdpTUB4069cghoCsbiBGju5I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f72.google.com with SMTP id 586e51a60fabf-40f09403c56so9390503fac.1
        for <syzbot@lists.linux.dev>; Sun, 03 May 2026 10:25:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777829134; x=1778433934;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YosYZ8wZ1cGpHhOCQEQZflzrpuYQPPXdDCsffzxrXZ0=;
        b=EGvKTt0yLMAw2T21Zex+6ed++QrAoZQ1a1aguPbUxj9cjLxXs5W5OrBfEYPCNg+jxA
         2O5x+Qz2wdJaLidmrVyA7dmNJTyjg7rAVX3cDhpViaUclXrgx/fZGcTZcI59iGUnQ+ms
         x2Uiaf7iCg5YEvxK+7N//pVQQDuJXMtupQvdxJgkfYy/CTq7fPzF3jbB3WB6BMPZMxNc
         sRV1NrTmqlecsrPsXENbvz/VA0ioA1XpY6VTGgIcAAebMbhXJhD+9O2f0k0s+MX60AQO
         KMOwGeR99mAGELzgNmKV1qt7fV+TDUKPOywuZoTV4Qsfr6CEfs0eXlENU6L0VprOTluW
         57fg==
X-Gm-Message-State: AOJu0YwgtDL9ll8VJ8Odk9ArPQyXZ4Y9NhoZvPi09IuHLQY/xtOBnJhV
	84PsE8hVZ3s1OpocAa2elAI7xBAAMq6MnjEOP0wrDlKyacU+YvW4EEUvokTbg11MSQPOHvqMvy8
	3c4Q5/lviJ/7aOuH5MMplIwYW9l/9x5WeN1irvIr2NV1/kfPF3CsvL2JDzaI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:c014:0:b0:689:30ab:84e5 with SMTP id
 006d021491bc7-6967bdf3884mr4633437eaf.42.1777829134406; Sun, 03 May 2026
 10:25:34 -0700 (PDT)
Date: Sun, 03 May 2026 10:25:34 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f7850e.050a0220.312cd3.0038.GAE@google.com>
Subject: [moderation/CI] Re: seg6: add SRv6 Mobile User Plane (RFC 9433) behaviors
From: syzbot ci <syzbot+ci329c25b6859bd742@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] seg6: add SRv6 Mobile User Plane (RFC 9433) behaviors
https://lore.kernel.org/all/20260504-srv6-mup-v1-v1-0-e0a6791575cb@gmail.co=
m
* [PATCH 1/7] seg6: add End.MAP behavior
* [PATCH 2/7] seg6: add End.M.GTP4.E behavior
* [PATCH 3/7] seg6: add End.M.GTP6.E behavior
* [PATCH 4/7] seg6: add End.M.GTP6.D behavior
* [PATCH 5/7] seg6: add End.M.GTP6.D.Di behavior
* [PATCH 6/7] seg6: add H.M.GTP4.D behavior
* [PATCH 7/7] Documentation: networking: add seg6_mobile guide

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/e1f23d40-167a-4bd9-9884-72c6eb45ee15

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      98878ed91b68a3150126fccef125ee7b1bb86ab2
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/de326ecd-a85e-4de8-a9f7-207d495c9eb=
0/config

net/ipv6/seg6_local.c:2287:15: error: call to undeclared function 'csum_ipv=
6_magic'; ISO C99 and later do not support implicit function declarations [=
-Wimplicit-function-declaration]

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
[andrea.mayer@uniroma2.it corbet@lwn.net davem@davemloft.net edumazet@googl=
e.com horms@kernel.org kuba@kernel.org linux-doc@vger.kernel.org linux-kern=
el@vger.kernel.org linux-kselftest@vger.kernel.org netdev@vger.kernel.org p=
abeni@redhat.com shuah@kernel.org skhan@linuxfoundation.org yuya.kusakabe@g=
mail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

