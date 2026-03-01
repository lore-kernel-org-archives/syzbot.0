Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FC2613AD1C
	for <syzbot@lists.linux.dev>; Sun,  1 Mar 2026 08:28:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772353691; cv=none; b=HNpcWugCHPes1UvO0lueQY38TFOoGS8j0ieTH23k2tcJTgjnVSBnOjNDlSua2ac2nuUfh9NP+u/FioYGXHkzUdE5EUr3IxZyj8cW9Teya1drpzEtTqadP8XCjBYrpuaDE1S6rGsClTRA1UifO+8p5dalkgvC09caES5jK3KKfJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772353691; c=relaxed/simple;
	bh=GIg8R5VbuNcP8gbMPK6FLRWtcdIlTOYhkwBFjaWaGWI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=UiLufTNajBqH8399m1gQDolT04C196dy02hTHpHzN804nz/eCszPRfgsAnHFM4k6NXIB8rEPSPd0ZecHzGZ9O7URxWpz/wiDkqRYYnJklGNgobsqlWUBuSTizdrNyzZCahHtsr83GOK8qPDwVYq4sxzQ6rgFqZAOI/fds8+OWzw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6799654a158so29308288eaf.0
        for <syzbot@lists.linux.dev>; Sun, 01 Mar 2026 00:28:10 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772353689; x=1772958489;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=TfYR/jkORT/gWeooOAiIOIjgScKJFuUJYzeMmT/ycLo=;
        b=CW090GjJfPsJSaT3Zbc278nsXlJrv5nBmI3HamPVALGZQZpDKyBwGoA28U8EAPqf74
         Q9H0CNr5MAOn+KazDJun7wQ7UdpnycnQ066RTxV+92PUg8z4hBEFRQU0UJ58NqZ295kx
         N5w/RF/M5iCaW0l5DW/oFGn7RlYR3OcfvlOSwyOavYSnbCXnRLTlp7KOphPw874B0Gto
         CKTmsAUvfk9nJ2eQI6uyq+oU5nsY8BAUJIMvZvPHPVKM3IPNBhqoR0KE+fZT+pAZv5mU
         gRJHBQ6JR4t98El91WyP9Wehb2ImDvwhrrH73hbpGa31v+u8/NILE9g6En7bRuwIDkcZ
         Wp3w==
X-Gm-Message-State: AOJu0Yz+2GEljWna92y7c+Lb9gOUF415toegQHRk/O+Dpx0oJIwJ5/bZ
	QGMzGMkZzVQdCvc+LJjc/BIO141X+XyMRCAB7BzHyjeZhilsaWImLoSpi1AQ58uIYhQg1MpHYCJ
	J6XKFL44sNXAyRfW5AKZnt7z7IixKsutPZncL3muDUC6KXy3xVSf42gG4rik=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:208d:b0:679:e750:6bfa with SMTP id
 006d021491bc7-679fadb7d7amr5171463eaf.10.1772353689413; Sun, 01 Mar 2026
 00:28:09 -0800 (PST)
Date: Sun, 01 Mar 2026 00:28:09 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69a3f899.050a0220.3a55be.0057.GAE@google.com>
Subject: [moderation/CI] Re: Fix compiler warnings/errors in SUNRPC and MACB
From: syzbot ci <syzbot+ci27ba738c600c5361@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] Fix compiler warnings/errors in SUNRPC and MACB
https://lore.kernel.org/all/20260228180821.811683-1-seanwascoding@gmail.com
* [PATCH v5 1/2] sunrpc: simplify dfprintk macros and fix nfsd build error
* [PATCH v5 2/2] net: macb: use ethtool_sprintf to fill ethtool stats strin=
gs

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ee10067d-14fa-4f9d-aa7f-ca98a26ea2c5

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      b9c8fc2caea6ff7e45c6942de8fee53515c66b34
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/397e3343-b3f6-4bae-9d7e-d08cb1e0efa=
e/config

fs/lockd/svclock.c:163:5: error: call to undeclared function 'nlmdbg_cookie=
2a'; ISO C99 and later do not support implicit function declarations [-Wimp=
licit-function-declaration]
fs/lockd/svclock.c:202:47: error: call to undeclared function 'nlmdbg_cooki=
e2a'; ISO C99 and later do not support implicit function declarations [-Wim=
plicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch anna@kernel.org chuck.lever@oracle.com claudiu.beznea@tuxon=
.dev david.laight.linux@gmail.com linux-kernel@vger.kernel.org linux-nfs@vg=
er.kernel.org netdev@vger.kernel.org nicolas.ferre@microchip.com seanwascod=
ing@gmail.com trond.myklebust@hammerspace.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

