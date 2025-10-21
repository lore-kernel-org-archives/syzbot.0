Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12029346E6D
	for <syzbot@lists.linux.dev>; Tue, 21 Oct 2025 16:59:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761065961; cv=none; b=er2S/pknd37M9rWeyPGTgGyp9Fi+mTIPCr3zDYrxvvmkzuVn9H1yo67IErb+yrFT0R7k9OjTY/xYz5la16YycIyetKSDHHDirtzQQxtmONXBsRgY2cA8IwKsioZCBZZ/vPIvw4OvgWJOSNRzGmUMBPaI0oOR1kVR2giWMf6i+IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761065961; c=relaxed/simple;
	bh=SFa1kpBMr2KjUZV5CVY9sHNrn/BRLxcU+LLJEmgLwSs=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=IANxF1FDFqOPPDIFeWGWx4OcRQ0j/pBZuIz3o4PAdeFSGDToWbkZ5nnZhxDfNXg9haOMb2dpQ4zJVDbzpcRnRR2MbAHTkZV8+zS3DUFQt90NuWOjNdmFnM2iKPImAc5RMEoFip+jvfng13CoUcdVL4BmFjCMVPAaq+4fn4tPkc0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-93e8d8d227bso976483139f.2
        for <syzbot@lists.linux.dev>; Tue, 21 Oct 2025 09:59:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761065959; x=1761670759;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=fyQqv1WKhpJPVAQ1JkgCVbVBhC5yGA5II4wF9YDlYoo=;
        b=qvyEPCC5L69mumnQQV8PBBDp6aPgOWJp1SAewMR1L2N+dAv/g3mq+aNkZVWjEwMa6A
         VfxFjpdBFXbYvqaLgMEXrkoBsMMykOvLovjImtD/VE1RoyO+5zZrG9SGCXr6JjED6NhK
         7FE1D47+S+gF8Yn2POaQ0FbYfT9G1dAE4q30LNItM7/3sP/JjyV6ADXggxdiD0xR8SHt
         F7ioHdjnNaKMjw0gRjWmtAsbSmLuxdZUEkuj8HLCynUa02eZJrQq2UOtPxt0HTu2fUOM
         oNdHqXzpdEW91eTnar0I7tEoV/KjD/m93eor2G3rciNzjUaGhXvGV+yyuBEnj9stTtO/
         Tl1w==
X-Gm-Message-State: AOJu0YxCCEs+WptAlCK9G6iHaDCr4nkMSF5Fy6C9YShktk7iyFH0OkDo
	9RKLfbqY/2Ow4ZiqRCHU+cMAJxDV5brhCzrRrDnGgMQV36nf4b+FZatyZeobz8Jt14W6cQVypQz
	s++/E3fRx+3JJEtrih38xWFTaWuGeD0Z0kdGz+MiV3tnB5D1hihlkOGNLwsQ=
X-Google-Smtp-Source: AGHT+IEznN3P+PP7XyuXRhNz8rV6j8pt1AqLysX8UcID3T++V1yn7FI9b5n47qNb4m2bI3uBqAcQiEzTheoCPf/xDkZa1UdBOz35
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:4510:b0:430:c77c:cc35 with SMTP id
 e9e14a558f8ab-430c77ccd47mr247261245ab.29.1761065959101; Tue, 21 Oct 2025
 09:59:19 -0700 (PDT)
Date: Tue, 21 Oct 2025 09:59:19 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f7bbe7.050a0220.346f24.0021.GAE@google.com>
Subject: [moderation/CI] Re: ipvlan: Implement learnable L2-bridge
From: syzbot ci <syzbot+ci313bd4fc097150f3@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] ipvlan: Implement learnable L2-bridge
https://lore.kernel.org/all/20251021144410.257905-1-skorodumov.dmitry@huawei.com
* [PATCH net-next 1/8] ipvlan: Implement learnable L2-bridge
* [PATCH net-next 2/8] ipvlan: Send mcasts out directly in ipvlan_xmit_mode_l2()
* [PATCH net-next 3/8] ipvlan: Handle rx mcast-ip and unicast eth
* [PATCH net-next 4/8] ipvlan: Added some kind of MAC SNAT
* [PATCH net-next 5/8] ipvlan: Forget all IP when device goes down
* [PATCH net-next 6/8] ipvlan: Support GSO for port -> ipvlan
* [PATCH net-next 7/8] ipvlan: Support IPv6 for learnable l2-bridge
* [PATCH net-next 8/8] ipvlan: Don't learn child with host-ip

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/265a4c3c-647e-484b-8d84-63abd7d2b24d

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      88224095b4e512b027289183f432c0e84925d648
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/20f8a7a7-e503-4eb7-b33a-392b17fa6589/config

drivers/net/ipvlan/ipvlan_core.c:864:23: error: call to undeclared function 'csum_ipv6_magic'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch andrey.bokhanko@huawei.com corbet@lwn.net davem@davemloft.net edumazet@google.com horms@kernel.org kuba@kernel.org linux-doc@vger.kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com skorodumov.dmitry@huawei.com]

If the report looks fine to you, reply with:
#syz upstream

