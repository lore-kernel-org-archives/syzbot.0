Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.52
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795523519;
	b=Is2JrcmZVoU2mRNSX8M9SMjPDC5AhkRI9GB/YdGijjQGdGg+2Pexma6d2SBfo1gkebLw
	 9NmEBGMM4Pa5Sevp5yD44f3tHn38giH3PIGWzh2me78DI1xOj0HNyfFRt9FC1P9D+8NfZ
	 mFme5VLXvWuyIQG8IRSjw+eQ2WCkpzYdMqlGGu3G6VN41uCuRMfiaAwqBssflFic5c+Kk
	 0Os+wyGuW71UC9BVqHymF3vkjdgcYRC6swWA/ymijNBc5HfydY3yu+Ck38ornB8UlE5+U
	 P90mm6tJ5DX83fDZuQpMQzydJKyNmMxsD9GDUM1F9zgnmR8Dp+4COtJ3HoakNM2TBEw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795523519;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=VAGi8ADLbe1nwsDdtMJUG+mqysismIkmi3QPANzknRE=;
	b=DKwOUM0wbTiP1O+pNdtJlyvT4DOO/XbaDQ8a+mVJKB5eP4j06tYF8qBnu/gzxGKGYRna
	 Gt0koAOJsvJbzWyrgh7G4n9GHUw1PoBU85tUNPq+ePUB9+rA3KPlxM3g0vQV10OeC8YwY
	 4JdOwMaFePzgSRdT/gHcR//W/X3H0u2PvnSkWKTiBdv2F9QWeV4Fp7fnipPsjuqvu7Xw0
	 a5Q6eZsL7EU6fTI3+o9JbM0NmSGnL3kFyMnbMZksOdUI3qv4OHGROJFq5hEPFLhl+a6J/
	 nAEp9u9jGHvwaBFJnpV7soJ0qjSA6wN4v9td3wNAfEKFA7B0ROnQ8JmZU2ZwRn65hPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SZAhix5x;
	arc=none smtp.remote-ip=209.85.208.52
Received: from mail-ed1-f52.google.com (mail-ed1-f52.google.com [209.85.208.52])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A818E606A31E
	for <syzbot@lists.linux.dev>; Tue, 24 Nov 2026 12:31:58 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org A818E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SZAhix5x
Received: by mail-ed1-f52.google.com with SMTP id 4fb4d7f45d1cf-6ba38c41804so5071001a12.3
        for <syzbot@lists.linux.dev>; Tue, 24 Nov 2026 04:31:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795523517; x=1796128317; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=VAGi8ADLbe1nwsDdtMJUG+mqysismIkmi3QPANzknRE=;
        b=SZAhix5xMv9QOrx+TMqMJtgBYk6zjWAkSDug5IUnOfOgpI/pmNVEj/QlZvqHbylG2O
         tepe4oCNVrRWyWB7ldRGa3ZgLEHIRFIEntaJ2dgleFUwnLfuObH7D8ZrIWCy2sDLQtWP
         0wCb+yzTWilux72ab5S3LggV9Ldn3i0kb83GBEzw2QfBCyYlN0xfuGxD0/elLGSNgGab
         JmcsoUtIrQ/Mc8HnUgJ6sVN1BOE22jwE+IM4Tex9PhWPG4AiFD974/e/Ng/ACANZJuWi
         X6nAodbDM4A6iQGta/71sZHWFeBGXCYa8Msn6hmkwDZR/CFMDrUWiFhUIgYiJmOw/Esb
         Dptw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795523517; x=1796128317;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=VAGi8ADLbe1nwsDdtMJUG+mqysismIkmi3QPANzknRE=;
        b=ErC5LhwGgpNLYdzBuoMJcomkyjwwvwuQ5dAH5J6jmpOLuaLGqMK4vF0V/CUp09S4JU
         MwZZA3gTt315TZct6DBXEMsqwtLeF8o2UpnQRgWQRSagVNediblSVGAI0LtjP+5qKx3B
         OMXjvY0c+/96C9eWdenwfTXg3sjgl3H52P/TU1DmCIyy3l5Z9UErQn24w10rzh0pcjax
         9O2o+f/r/f8dNwl80vQDP+/bVVHBPC3gATJjSXQGP7/I9m+Kbo4AGnGmgkbM91lxG/Gg
         ZWj1SJiHN8A8NbfbaylJqtOT0ymUgLxgOXrRYiRxeZGqSHAfIAcXoTDKXn9AY7LiL2O5
         QSKg==
X-Forwarded-Encrypted: i=1; AL+hErFvUl8SQDhFBqbpetW9mW7Z8UE77ntm7uBifnO9jnEJrlreimBWpoAsVrP5udUhxkiCQsb+yus=@lists.linux.dev
X-Gm-Message-State: APuU4Z+4z1AWo051NVOkSC6qdbZ6yNBpDBU0rksxOU0aYANLgxgagNgJ
	wvKc9YlqBdh4D46KjBkCfNvYC3r0ATnqOsEPfK23qSwFiZna6d5dVNTc
X-Gm-Gg: AZFdTZcI0KZvWRlnAyjx7z8nLrSSPOqAa8aCBFnBSo/oEWUSMown0CxKgaV6gH0diEM
	ck5DccQLeUhZXXfbV1KyesL7Tb7BtAr0TXMyfZL8JI0UZdy0PaCnNH0RY8gFWzhFEymvwjINA+c
	mUb7HJ2ZHXUSYHS38f6Iwsc+10Js8vzX6AnQ2auHbgBWEiQ9uBBYcCUwuzGpld33oUxOdHt4cjn
	iPv3HZYxFuKhoXt3mL2A9p2uy4AnLEXs9IJsN4vZ7/bmxlWIm51xbewLhHz65F8yTIluVy8XTxT
	qfZudIlRSIFn9H0gWRvhUG18w9hyv0t0+nqM2l+0N91eKqDcjZ9ufgaqfmZ+wG6wXxyXGtllPqE
	n7vyY4unH8s7UQQ+sDED9TX7JHa99z5YC3eW3KAQV1jv14Y778F0ET2P39cDX22aLQfncJZdtrI
	elJv9W6Zsr8DQRII1ZkNRM0NP2EyBNSobnhIyGiU91ZMN6ZYOCFvjyYTL8xWsS3DNKmi2JYRilB
	KtQ1i3AyQ+OVBS6NnNrht3FkA/n8NP+MBl3OCk1SIPRsUPzLgutqSjYCkVtJgKRzk+AbBy/M33m
	6w/Ba/DFslSxT+0XPHadDFxd26OUZLi3ImamS0jgOUkmQ7I3bJgQBpnmrBe6iGI/7+xPAF9v+25
	a0aAjWoPINydlkEsCc4WcJMZS0v8lCp0343UkYpCjcm024dGQJXHYwKzkLZsyG1P++nlHw309RX
	58avEWdH1gr+o1tCs2j2vlcPAIQzwpC4/BzfgpiH06BREsD/eHxEEsYj028H4cq30=
X-Received: by 2002:a05:6402:ea9:b0:6ba:eb4c:487a with SMTP id 4fb4d7f45d1cf-6baeb4c48ccmr1907009a12.22.1795523516710;
        Tue, 24 Nov 2026 04:31:56 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ba854bed08sm4675512a12.30.2026.11.24.04.31.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 24 Nov 2026 04:31:56 -0800 (PST)
Message-ID: <02419845-bab8-4e36-9a98-6830761da1b9@gmail.com>
Date: Tue, 24 Nov 2026 13:31:55 +0100
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] net/x25: fix invalid lock_sock() usage in
 x25_kill_by_neigh()
To: netdev-bot+sashiko@kernel.org, syzbot@kernel.org
Cc: syzkaller-bugs@googlegroups.com, davem@davemloft.net,
 edumazet@kernel.org, kuba@kernel.org, linux-x25@vger.kernel.org,
 ms@dev.tdt.de, netdev@vger.kernel.org, pabeni@redhat.com,
 duoming@zju.edu.cn, horms@kernel.org, linux-kernel@vger.kernel.org,
 syzbot@lists.linux.dev, ngocthang2710.1999@gmail.com
References: <00f667e3-a158-4fb5-84a3-9ecda4718ce8@mail.kernel.org>
 <179551432467.3135.11868205229731190547@kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <179551432467.3135.11868205229731190547@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On Tue, 24 Nov 2026 09:58:44 +0000, netdev-bot+sashiko@kernel.org wrote:
> - [Medium] When the new softirq path finds a socket owned by a task, it
>   only sets a flag and leaves the dead call usable until release_sock().

Agreed. While a task owns the socket, the flagged call keeps its LCI
binding until release_sock(). __x25_find_socket() still returns it, so
frames that arrive after the restart go to its backlog and are processed
in the old state before x25_release_cb() runs. The owner can also still
transmit on the old LCI, and after a LAPB disconnect this brings the
link back up.

This patch follows the same design as Thang's patch from October [1].
In that thread Martin confirmed both effects in a test on 23 November
and announced a v2 which skips flagged sockets in __x25_find_socket()
and returns early from x25_kick() and x25_write_internal() for them.
That covers this finding, so please drop this patch in favour of his
series. I will not send a v2 of it.

> Pre-existing issues:
> - [High] This problem wasn't introduced by this patch, but it is still
>   reachable after it.

Agreed as well. x25_disconnect() clears x25->neighbour since commit
4becb7ee5b3d ("net/x25: Fix x25_neigh refcnt leak when x25
disconnect"), and x25_sendmsg() and x25_output() dereference it after
they take the socket lock again. Martin wrote that he has a separate
fix for this.

x25_recvmsg() has the same kind of window, and the review did not
report it. If x25_disconnect() runs after skb_recv_datagram() has
dequeued a packet and before lock_sock() returns, x25_recvmsg() then
calls x25_check_rbuf() on a socket without a neighbour.
x25_disconnect() does not clear x25->condition, so with
X25_COND_OWN_RX_BUSY still set and sk_rmem_alloc below half of
sk_rcvbuf, x25_check_rbuf() sends an RR through x25_write_internal(),
which dereferences x25->neighbour. I found this by reading the code and
have not reproduced it, but it may be worth covering in the same fix.

Martin, syzbot tracks this report separately from the one in Thang's
patch (extid 9faa82ae2e94c5c7d2ef). Could you also add the Reported-by
and Closes tags for 300375dfd44665f063a6 to the series, so that syzbot
closes this one too?

I am happy to test the series with the syzbot reproducer once it is
posted.

[1] https://lore.kernel.org/all/20261001150118.128470-1-ngocthang2710.1999@gmail.com/

pw-bot: cr

-- 
Krystian Kaniewski
