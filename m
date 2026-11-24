Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=194.37.255.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795524962;
	b=rqw9umw+ATqoD//EZyidhWqiF9OX+pe+X8cNBT0XOPXYO/z04z/L1UU+Oo0UQPnJyNAx
	 yHWoL7Dh85yWF8vCbOAYJPmY8IORWeHkwM1y1uZRM7J4scQ1WSSukTulBLwjnFWfjyfph
	 QrTI5uEGWou8k0b2jQyrZa5f/VVZrHY2oCmaeNtjeRSA/7GWm7NmsykibWSLuMxd7naN8
	 kucTR/IyUD14hxw66oFHjToApUIZAozp36rSS61X6LCtpvSLrp7cpbeL/NNxOFeCEpeUG
	 uFQiD+3uv0+gqOidD9EKmVUNYCc6n9pWpM5ldTMfS06MVnxaq8Xk+RP71f71bmMwsrQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795524962;
	h=DMARC-Filter:Received:Received:DKIM-Signature:Received:Received:
	 Received:MIME-Version:Content-Type:Content-Transfer-Encoding:Date:
	 From:To:Cc:Subject:Organization:In-Reply-To:References:Message-ID:
	 X-Sender:User-Agent:X-Spam-Status:X-Spam-Checker-Version:X-purgate:
	 X-purgate-type:X-purgate-ID;
	bh=slugAct+d9okK4SVhnpunN3npmVqm8AIPnUV1JVa6F8=;
	b=KmNYPkWF0DYJeqphWONdnNx+4FUrGlWqQu/c8OaLsrv5S4BxlhvCVsNVKHYUuCBo2e3L
	 INFlXb7pwLPAwyDsu1IqwzEl9yp+WYsGlW3b+KsCwIrFU8vbBMdgbMv3mo+wri49+a0xI
	 uxuJR2Es5F34hzid3XDIcN03E4A1hyj6rhHhximuMgthW89FQprv2nrxgoyLJ7HtxnKIs
	 VKaAzsMR+94zRRqui4YP+NKoYXbw5eC2XzLjL5u0dzW6K0heu1jxbvSH8zGe+vsfCmX+1
	 hwOFy1L9sG9zPZAfosUpydCt50Hxo/vipstU45y4L1DQ5Er9pqi36SCbVZKDyUR0aRA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=dev.tdt.de;
	spf=pass smtp.mailfrom=dev.tdt.de;
	dkim=temperror header.d=dev.tdt.de header.i=@dev.tdt.de header.a=rsa-sha256 header.s=z1-selector1 header.b="n50UEsy/";
	arc=none smtp.remote-ip=194.37.255.70
Received: from mxout70.expurgate.net (mxout70.expurgate.net [194.37.255.70])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A3E8606A322
	for <syzbot@lists.linux.dev>; Tue, 24 Nov 2026 12:56:01 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1A3E8606A322
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=dev.tdt.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=dev.tdt.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=temperror header.d=dev.tdt.de header.i=@dev.tdt.de header.a=rsa-sha256 header.s=z1-selector1 header.b=n50UEsy/
Received: from [194.37.255.9] (helo=mxout.expurgate.net)
	by relay.expurgate.net with smtp (Exim 4.92)
	(envelope-from <prvs=6802181f00=ms@dev.tdt.de>)
	id 1xVq3w-00FLUI-Pf; Tue, 24 Nov 2026 13:55:56 +0100
Received: from [195.243.126.94] (helo=securemail.tdt.de)
	by relay.expurgate.net with esmtps (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
	(Exim 4.92)
	(envelope-from <ms@dev.tdt.de>)
	id 1xVq3v-00FLTO-Aq; Tue, 24 Nov 2026 13:55:55 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=dev.tdt.de;
	s=z1-selector1; t=1795524954;
	bh=slugAct+d9okK4SVhnpunN3npmVqm8AIPnUV1JVa6F8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=n50UEsy/cNEQKeTXohBifcZ5TKBQf0pmbS9nl/L6lNLgy2Gfh2R56qGiEHk84nb8t
	 X+gWk9dnMkscHXSDw8YnNRCaz5ulFdE5CwuB9Svpwbw8advP4Sbfw9FF2Vo07sbnhj
	 vsq/znndinH6KDI3AJz+X+mhVEb/uglIcHjAobiIIAQ7L286QcpVL2HnIgxWEHztYy
	 CtO0E3EGIg0/XbLFCD6vzenhASpCoLF/5wmqmGV5TTLa0qfnuABIm3wRNBWudYQ4Iz
	 t5hTvPjwE+HpRUBjToNFa0xlic7lNSrB0z/S8X1W7N4hFKUCkbgRMb0T5NLhJA8n3M
	 OHB2QGcw6O9+Q==
Received: from securemail.tdt.de (localhost [127.0.0.1])
	by securemail.tdt.de (Postfix) with ESMTP id A6FFA240040;
	Tue, 24 Nov 2026 13:55:54 +0100 (CET)
Received: from mail.dev.tdt.de (unknown [10.2.4.42])
	by securemail.tdt.de (Postfix) with ESMTP id 9C3CE240036;
	Tue, 24 Nov 2026 13:55:54 +0100 (CET)
Received: from mail.dev.tdt.de (localhost [IPv6:::1])
	by mail.dev.tdt.de (Postfix) with ESMTP id 72C1429D09;
	Tue, 24 Nov 2026 13:55:54 +0100 (CET)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Date: Tue, 24 Nov 2026 13:55:54 +0100 (CET)
From: Martin Schiller <ms@dev.tdt.de>
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: netdev-bot+sashiko@kernel.org, syzbot@kernel.org,
	syzkaller-bugs@googlegroups.com, davem@davemloft.net,
	edumazet@kernel.org, kuba@kernel.org, linux-x25@vger.kernel.org,
	netdev@vger.kernel.org, pabeni@redhat.com, duoming@zju.edu.cn,
	horms@kernel.org, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev, ngocthang2710.1999@gmail.com
Subject: Re: [PATCH] net/x25: fix invalid lock_sock() usage in
 x25_kill_by_neigh()
Organization: TDT AG
In-Reply-To: <02419845-bab8-4e36-9a98-6830761da1b9@gmail.com>
References: <00f667e3-a158-4fb5-84a3-9ecda4718ce8@mail.kernel.org>
 <179551432467.3135.11868205229731190547@kernel.org>
 <02419845-bab8-4e36-9a98-6830761da1b9@gmail.com>
Message-ID: <14b34e044b3de00d871d49226ab0e00b@dev.tdt.de>
X-Sender: ms@dev.tdt.de
User-Agent: Roundcube Webmail/1.3.17
X-purgate: clean
X-purgate-type: clean
X-purgate-ID: 151534::1795524956-7855AB36-32B64448/0/0

Hi Krystian,

On Tue, 24 Nov 2026 13:31:55 +0100, Krystian Kaniewski wrote:
> x25_recvmsg() has the same kind of window, and the review did not
> report it.

Good catch, the code agrees: x25_disconnect() leaves x25->condition
alone, so x25_check_rbuf() can still send an RR through
x25_write_internal(). I'll cover x25_recvmsg() in the separate fix for
x25_sendmsg() and x25_output(), with your Reported-by.

> Could you also add the Reported-by and Closes tags for
> 300375dfd44665f063a6 to the series, so that syzbot closes this one too?

Yes, the v2 will carry the tags for both reports.

> I am happy to test the series with the syzbot reproducer once it is
> posted.

Thanks, that would be great. Thang can still send the v2 himself this
week; otherwise I'll post it. Either way, you'll be on Cc.

