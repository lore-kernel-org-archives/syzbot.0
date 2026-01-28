Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADA251FDE31
	for <syzbot@lists.linux.dev>; Wed, 28 Jan 2026 23:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769642131; cv=none; b=QakHUOOwu16IfGHLeDNeUuwnRN3/Dir4OixouRZc8270WabVDPBoZZ/QzFR6BpRxpCWHCoZlYSq/I3dCCkw/m3oLJ+Ggu1zIiyL7/vn2U+4ClmCIC1JNSKGsexQ9IFtMwrCiPfrOxLpFQphBeXFSL6x5a130srSXESIj4vHhHN8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769642131; c=relaxed/simple;
	bh=4z1IJJ2zGAug02N3Rr7eK4hON3Y3EMkzx0g6xhvME4s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=j2TXa0ExFu5o6OFfafNjpK2G+eruiJmO8OzHP1vEfwqaaxGtQtaDVxijXcKuOsUcOA4jCvjQRh/Bh5k+Gl5RCvNcdx6ylMY2mB1OTAaXNuspABbc5v0fZ/h0ErqycF2i4gTuk1SrSHO2cifTdMGBRV5YzSIem3l0fU9DbttoTbw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-661066bdfb9so1672626eaf.1
        for <syzbot@lists.linux.dev>; Wed, 28 Jan 2026 15:15:29 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1769642128; x=1770246928;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Ye9tTmt4BYbdCW4PCTZ0aaN/5vr+fZ/bpOsx9H9Z3KY=;
        b=h4e5szB7v1YtVS+UZ7rgT/VZQhtFrryK819WQumDQYJ2Nszdvicrj+g418oLqWll1x
         M7GESmOd8FkWZQT0A8hyD4UlRhUTb1y1rFMaUB/hFcw+f4m2jY9BDiXctMvHUKUX98UR
         AC5NdSYvlG2iw2TAkRu8ytcpNBy3eaGG/3UfSTv6j3haBNSsrg8nrBOfkjd6EBLiXkTe
         GEyXuOvX6ak7NIiC5lFD3O3eQsIf8XDkgBCw2g0HvsJpY3ynRoIMVeysdcOTOBQz41QS
         GJqIos3rQDu/ygXcR0R0nlZ+4fC41HBpoSecFsUV7jBPA9/DCboBKA0wrE4HhNtvBoKm
         nMsQ==
X-Gm-Message-State: AOJu0YxOPoaYY01WbXRH8myBmpYGzY4L2U5Dlu2TO8r/2msShnyeKjpV
	P/GCyqP8Z+v2jDuO5AlBL+rQJPgURjhjeAvzUroKmhsIDK1yC/b9Vi8tvcGcS4APB2MXsJx52ND
	UaUigqARjLMHgc4eyBTZWWUxNuu7zYXM8d9tx6VU7wXKDFhMucFDxt78tX7A=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1747:b0:65d:22b:416f with SMTP id
 006d021491bc7-662f20d3077mr3704912eaf.65.1769642128420; Wed, 28 Jan 2026
 15:15:28 -0800 (PST)
Date: Wed, 28 Jan 2026 15:15:28 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <697a9890.a70a0220.9914.000f.GAE@google.com>
Subject: [moderation/CI] Re: move CAN skb headroom content to skb extensions
From: syzbot ci <syzbot+cibab599e3b3054c99@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] move CAN skb headroom content to skb extensions
https://lore.kernel.org/all/20260128-can_skb_ext-v1-0-71b8bcbfd8cf@hartkopp.net
* [PATCH net-next V3 1/7] can: use skb hash instead of private variable in headroom
* [PATCH net-next V3 2/7] can: use netdev_put() instead of deprecated dev_put()
* [PATCH net-next V3 3/7] can: add CAN skb extension infrastructure
* [PATCH net-next V3 4/7] can: move ifindex to CAN skb extensions
* [PATCH net-next V3 5/7] can: move frame_len to CAN skb extensions
* [PATCH net-next V3 6/7] can: remove private CAN skb headroom infrastructure
* [PATCH net-next V3 7/7] can: gw: use can_gw_hops instead of sk_buff::csum_start

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/1099c163-740d-4ae3-bd5c-8b19e00d45d8

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      239f09e258b906deced5c2a7c1ac8aed301b558b
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/c6dfaf89-a16f-4a4e-bebe-c1edc0f42706/config

net/can/raw.c:524:16: error: too few arguments to function call, expected 2, have 1
net/can/raw.c:1001:16: error: too few arguments to function call, expected 2, have 1
net/can/raw.c:1011:16: error: too few arguments to function call, expected 2, have 1

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[devnull@kernel.org linux-can@vger.kernel.org mkl@pengutronix.de netdev@vger.kernel.org socketcan@hartkopp.net]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

