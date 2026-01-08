Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40C054366F2
	for <syzbot@lists.linux.dev>; Thu,  8 Jan 2026 09:23:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767864199; cv=none; b=MGK6r1X4MdIGdFszQqY1fOlVM/I17j+rT4rPh2Y5HGXdrF3jn3mXl8wCVEaThnTDyLRCnuTXlw0XtRZHIarDPEdftuBXjvSN4tlf3c+IQP7qOnl53GOabnzl44arAJsYCtuj+MQv3SBZm2adTCD0RWBgY5EWyP0Dkx/7E1teMws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767864199; c=relaxed/simple;
	bh=pfSA6BFLcq+T+Czfs8ZmyisuGlZDzt+vthInVmHVXG0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=HUFOke7XCNYHdFL3NJ3dV7CZp1ow9ZL/FeXeqN5btb2MPTPAvLpQz59alLRZJEbyUW8zNAA05PgALrTgaBDfTAH6lTcnlBFmL9f9+EBer0ui+0obReQ2txwD8L7tt2Q6lWkUUOP1yWP72Vbus6K3dmZnJmHnFy3FqwLTDHfvcak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B6lfS84f; arc=none smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B6lfS84f"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-88a3d2f3299so32750676d6.2
        for <syzbot@lists.linux.dev>; Thu, 08 Jan 2026 01:23:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767864186; x=1768468986; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gioCXq6nTAkg2YLHxtZAgY/YHH9fRIxqTnJ/8upycr8=;
        b=B6lfS84fWUliLGCu40c/2GCk3EzBihsyXSEofveS7gRt0aEbrYVZidEuYB0cQTz7dk
         oXWYzkCv7qoufSMbyyaUlqrhqeuZO0anem4owTzOHRUQ3eAHZNOxRd3IdUKWkh4G7/Xs
         1HPH30W/umxFLME6ykC0W05VnT3CrV9EoE38fWl364V0i5lDU6KjRD08j0IjjucfH60c
         KxPK8p+fm5JLHVJLdThaNBeNNiPDQG7UDVH14nzWa1I1IdM5kAwBS+YioC65D8OF8nwe
         RseuKXjIUW+dsoXbPklEjwQzgRT6MVl5JotzTIKa/TAa9aqoNtsowyHSdceesPbUz8bp
         a55Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767864186; x=1768468986;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gioCXq6nTAkg2YLHxtZAgY/YHH9fRIxqTnJ/8upycr8=;
        b=dCiby8o369SnG3JBOCLQwJoa/k1r7k3F7YuGhUa1KwuQn9HO06m5DO/7PYgS9ugUBr
         6VTWyt7wUWhN8F4bQYyQT/hs8+XnMWiIueR1NTImnptMw1L7Py5RUzKA4iW+/l7EF8sR
         CEzP0mB/+L/+wgU3zjFztpFUCQqPGgyJW2Z+p+FFBuSedhMRMefqCRfCnrOqlMruTN87
         +D9HSMZzDDP48VZyJCXaxhGhESkR/rLGPLB5DBAdZtPIZEukkLSuhbyI4AB8ZDat3RTj
         RqoH50U2RHOY8fJ6v1Y4jLuuR5MLQRsdPN4o8OGyrKgCtt/XLDp4sHmrqvpO0w+oS1C2
         zdTw==
X-Forwarded-Encrypted: i=1; AJvYcCV0KeKlRjl+FbLSgdah3Gj+NyhramK0fLPz/06r3wG5ZPjU3UUw/gYym50wSmWTDSOMzuH2Bjo=@lists.linux.dev
X-Gm-Message-State: AOJu0YyvxzsnHB7y/4wGkj+9uYOHZ/cFTsXZlock3/ukGtAevOPNlHM4
	0PJiHvU6C+D94sljOb+iRGBDW8mYrFsBh+Xvv5WU8rWxDcx801IMTsrXy7O78bobo9cqKDt0JnO
	21s21iEp1EYVonLW1e5K++g1FnTElz0vVcJRytb44
X-Gm-Gg: AY/fxX6QxXNdPwleaN9bWOQuPRR36qgoM1YpmfT3seU+wwokq6mA5iph2pFfRm2H0PK
	IEGJ2sEPGN9dKL+UB21pLAv2/hMako086mos1GO8ZSrC6a7hEDnYvvwZc1c8TNq+6i7BFiunNUS
	Fq3rpYjcPtSVES7tnsBDwRcgX4FfUyAfz2BkJFg6CqLfIhiWf+KG7PAFDSEXop0POddvhkSKQ8O
	KXTObphK98zBdBqNDti4ZIm9zxjZ2R4XTRO0bg3jF5LuClMoUzFmP6YEoS/R+MMgYl11Q==
X-Google-Smtp-Source: AGHT+IGZX/gylyILRvYSQ0dm8ryNutv8QBrmfiAv3BMoc3OEcbsbCfeav9AV9q+DZxg3mXV6vgEHhKixrPWBHdVB6ao=
X-Received: by 2002:ad4:5cab:0:b0:88a:4391:59cc with SMTP id
 6a1803df08f44-890842710a6mr71766116d6.50.1767864186233; Thu, 08 Jan 2026
 01:23:06 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260107125423.4031241-1-edumazet@google.com> <695f50c2.050a0220.1c677c.038a.GAE@google.com>
In-Reply-To: <695f50c2.050a0220.1c677c.038a.GAE@google.com>
From: Eric Dumazet <edumazet@google.com>
Date: Thu, 8 Jan 2026 10:22:55 +0100
X-Gm-Features: AQt7F2oZg3GBnUBPbwDdGZXDIWMS1CdfEALaFbRmvnvamEMsnCsdn0bQH2w6kC8
Message-ID: <CANn89i+Z3ELnxMJdRqsUy-afppMot7Otezu3BiheH+wtOvgscg@mail.gmail.com>
Subject: Re: [syzbot ci] Re: net: update netdev_lock_{type,name}
To: syzbot ci <syzbot+ci131adae482253910@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, eric.dumazet@gmail.com, horms@kernel.org, 
	kuba@kernel.org, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Jan 8, 2026 at 7:37=E2=80=AFAM syzbot ci
<syzbot+ci131adae482253910@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] net: update netdev_lock_{type,name}
> https://lore.kernel.org/all/20260107125423.4031241-1-edumazet@google.com
> * [PATCH v2 net] net: update netdev_lock_{type,name}
>
> and found the following issue:
> WARNING in register_netdevice
>
> Full report is available here:
> https://ci.syzbot.org/series/07a2abd3-8dbc-43d0-a5d9-cdbb1a35d769
>
> ***
>
> WARNING in register_netdevice
>
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net.git
> base:      1806d210e5a8f431ad4711766ae4a333d407d972
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~e=
xp1~20251202083504.46), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/f4fb7576-ea1f-485d-9ef1-c3270f156=
0d9/config
> C repro:   https://ci.syzbot.org/findings/e4767ea9-6be5-4bce-9523-40ab12d=
29b67/c_repro
> syz repro: https://ci.syzbot.org/findings/e4767ea9-6be5-4bce-9523-40ab12d=
29b67/syz_repro
>
> ------------[ cut here ]------------
> netdev_lock_pos() could not find dev_type=3D805

OK, 805 is ARPHRD_IEEE802154_MONITOR, I am adding it to V3
