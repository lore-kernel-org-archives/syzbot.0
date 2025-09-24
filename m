Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5A7D327A1A
	for <syzbot@lists.linux.dev>; Wed, 24 Sep 2025 20:30:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758745835; cv=none; b=lL1CdpbLxtNslDXE8s4pI0/+oy4i9aod/ePSHwCFqIqg5yOKbEt52SljGcBaKvM5WeZgUscwijiYQ1jGDpXC0oqMSRpJrXOmTkyV7pMz1lotB2qsXE2mSHhNpmRjmmvoBUT+uQRJHx0PXBTRE1woN6/eqOPcsArtDGqG3jHldrI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758745835; c=relaxed/simple;
	bh=Ehc2kXcfuau9ZZ9+W2ImwMvhUTf0eWezs7HPVTQ16UY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=dnYkNkHMPrpv3em/yDAW/njv2jV/Ot48JLdp6gmWk6d/UUelmtxgWOWr9BvkBPc0UMHS0TR1jjuTD9gn0wPMxAWhrKUxj639Yo6sfkQuIl2bPnDna6F0q0vw6/maCcIBe9qFaH9YMFxXhkv8BAgC/8Oqw7wdYJojx4+iu9hbAz0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-4247661a0c9so3622725ab.3
        for <syzbot@lists.linux.dev>; Wed, 24 Sep 2025 13:30:33 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758745833; x=1759350633;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=4+Q/u1pQKFYvCChU5EzVkga00fGgoZbGkNgMlp9XHs8=;
        b=MUWOyRSiF/b8SaAv/Dokfy8jOlmMD4ThkLxEzJ/OKiKcAJHvnUry4OMXd/D54iGfkw
         ftVKf6/gD9SQl26iCq3zxlin8vgUxIGFlI1i9lvqcdR3jHU2IBZBUt5z0QMrwkSbl91Z
         K+cDlkhSYgc/pEniNq+xX7TjAYk8Iw+z2tnZIYhjajOiEL0svpxHi5qvYc4GMTp5zReR
         rQh6l71AEPm2VeFvYbzWZ/tcdsBdfwOK5XAkYrsYU8ZHx5N5ZkdkVE6xMxE4UubuTLAx
         iMJB7zb5dO6v7H6gxeIcgqAJJyu+zVy6QTcHvR08wfqEPyq+YVnlUDbNFOyMoRl7gAzD
         6FEw==
X-Gm-Message-State: AOJu0YwprNHI1kDJcWGqes6AbK0oa6sYp8Tjk8bGMh7IIwDk/i3UyliX
	Zp1RU7s2HgJlLf/1ohMOcWiP4FTSVQcqFoMRUlsZJySoAp5mSCx772bL3jC0aWTQCEgnqChspOp
	1tsOhPEy2/xKc7Ysa5XqyI5arvQHWuZ3VBmdLrTI21jPbvTppgEDdoTC491Q=
X-Google-Smtp-Source: AGHT+IFfUc7hzDtIB/o3D6u3Tx0vVYk5LFnySdp6/YxgEwjhrAyuu6LUtIBxiriCFAm3cSkkVEox9MNLpgA00GzhYUXLmQ8H/aM0
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:471c:b0:425:70b9:243c with SMTP id
 e9e14a558f8ab-425955e5344mr14674805ab.14.1758745832848; Wed, 24 Sep 2025
 13:30:32 -0700 (PDT)
Date: Wed, 24 Sep 2025 13:30:32 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d454e8.a70a0220.4f78.002d.GAE@google.com>
Subject: [moderation/CI] Re: psp: add a kselftest suite and netdevsim implementation.
From: syzbot ci <syzbot+ci5d0a47e9e4d83263@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] psp: add a kselftest suite and netdevsim implementation.
https://lore.kernel.org/all/20250924194959.2845473-1-daniel.zahka@gmail.com
* [PATCH net-next 1/9] netdevsim: a basic test PSP implementation
* [PATCH net-next 2/9] selftests: net: add skip all feature to ksft_run()
* [PATCH net-next 3/9] selftests: drv-net: base device access API test
* [PATCH net-next 4/9] selftests: drv-net: add PSP responder
* [PATCH net-next 5/9] selftests: drv-net: psp: add basic data transfer and=
 key rotation tests
* [PATCH net-next 6/9] selftests: drv-net: psp: add association tests
* [PATCH net-next 7/9] selftests: drv-net: psp: add connection breaking tes=
ts
* [PATCH net-next 8/9] selftests: drv-net: psp: add test for auto-adjusting=
 TCP MSS
* [PATCH net-next 9/9] selftests: drv-net: psp: add tests for destroying de=
vices

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/46a0e02b-c024-4e50-b9fc-1c9cc812acbb

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      dc1dea796b197aba2c3cae25bfef45f4b3ad46fe
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/c5fd66ce-3fe0-4b57-be0d-9bec7f6091c=
6/config

drivers/net/netdevsim/netdev.c:116:22: error: use of undeclared identifier =
'SKB_EXT_PSP'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch cjubran@nvidia.com daniel.zahka@gmail.com davem@davemloft.n=
et donald.hunter@gmail.com edumazet@google.com horms@kernel.org kuba@kernel=
.org leitao@debian.org netdev@vger.kernel.org pabeni@redhat.com petrm@nvidi=
a.com shaw.leon@gmail.com shuah@kernel.org willemb@google.com yuyanghuang@g=
oogle.com]

If the report looks fine to you, reply with:
#syz upstream

