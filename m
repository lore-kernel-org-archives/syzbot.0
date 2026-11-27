Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.54
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795776269;
	b=WRZBF0Y9FZgMAw/hJgHdQ8Jy0ZLssJj6R4munpRPqoI3vAFZ832q1GeLkVUmMPR8sva3
	 i7+Kf0yin8b6YSDhtDxT4qrHtSn3J1WFSA2dpFd4t19/9i7nyjii3JyYUWfZnIKlJSZ6Q
	 IxQjgAf2Uuyjkhfv5jBL4UbsJGFwO5+SgNW4jA5iiUt4r7pTLazcHkdnw+Zz4nDGZCnay
	 YB64wW9Y7P/tvhX4oYrfkNwJaaBryWDkKXQZRvClET/EGREL+NW/dHNc4GJpZHSR7hCMH
	 zSL2ILdigBIeutdNriQSicGlhcpDrepfzEt47WTUVvB7rUv7T8WoPgRsR1W4M3GhLyQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795776269;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=CLDeRKDXxQKFajbWU6UwFED1lEQmChZz42q33T7411c=;
	b=E1LxhbIInGMDpfdvFKCNQwdxtgNyeK6ZU/uBTM7VxsgoRu1+Q3uAFiHRRPidiP3HpmXQ
	 LV8lKvQe2MX9emQlHVg9Nu1MYwnt4O4zXKwKhvbMxrbnabgS5fJE2PvGmMntr/J8AZNhO
	 dx1BEoLb3GaPxFWwc+iEpaNP/4gUuX0E1WnDWl1SyNgXm0hSqD619gUJ9zztW2jj1eSbj
	 yVncPiNKKFBrqZYOoSPfZBGY6S0sxRSC1eyHyvjeJYFoDpDGHqvNUG/7VILOcF8TwD5Oz
	 8P67H/9RYZowrhvlOJGDqO93aVG7W4nG7ItZipEm95/HsFwWYmv7MfD2c75EWGkFDgA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GHez8j1B;
	arc=none smtp.remote-ip=209.85.208.54
Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB3EE606A31E
	for <syzbot@lists.linux.dev>; Fri, 27 Nov 2026 10:44:28 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org EB3EE606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GHez8j1B
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6b587538a37so11981479a12.2
        for <syzbot@lists.linux.dev>; Fri, 27 Nov 2026 02:44:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795776267; x=1796381067; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CLDeRKDXxQKFajbWU6UwFED1lEQmChZz42q33T7411c=;
        b=GHez8j1BX2ByrxKK2DwcPzR0CTU9igsDG2m2wohgqBTS6iCmW6RFo3Ae9ZC1/aYGPZ
         V0cdP9HUD/12UM7Yxh5NxIgfjQ7htB0OONW8ITYjibCAVxQwg3nlWYRwosRwOdByC74w
         fCy7VoWGLSntPS5bCFJEbPE776h9/aCibGUtbtg7DOfqlobm6MY0mVRc6plxdJFJ9S5S
         o2eDkOAUg7JMYJIUoBWyzed33yFAe3mV7l6eE9tNmV7r0yRh0B/xBUJN7mlHJjnElsbH
         LaKP1Rg1rPf8IvSaj9nRDb0xSPJZTOgZzkzTY+7ql7/rHjlexTFCr294oYtllTmOecN9
         L+0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795776267; x=1796381067;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CLDeRKDXxQKFajbWU6UwFED1lEQmChZz42q33T7411c=;
        b=t589pCB7kxflAg5XDoV6m+5moxIFsmcX/4pzIA4dnTWK4jATtGlln4RAGEyiCt1sKS
         zZFejZGz3G6ifhdAbeT5liuuognbU5BdafRHuKxXff/Arggx2oYcNVjnDuxt01utew41
         AS3MyTPHDDFIzs971Nz/Q0IoaP6/tF8kYKrfjmoOsfUr0/aogevLL4bVbLQzGmXDmWzj
         WCtMvjaCUWwSK7EpWkIdeZSLX7I5HyGYCTMEe0cBLtqAHjXKhWuDIYIePYGL9cm7PJkM
         cYs9rN9RpVd0QoexrPPV35MYHfW7Q9FwqKG6xpdvHFzW28foB9fv5deFalPoHpWV68Su
         9vjQ==
X-Gm-Message-State: APuU4Z/bxuTvefUUMYaCIhuJECO7OkxWzRJaCq42fcb16UWHV+GElAto
	JsqpyFZVxPNuOTAeW5GmpTKWAV1h/7vjktRNeYNLuyumpqQLfptZgfMq
X-Gm-Gg: AZFdTZclX8o8VKFnKASqASdqxg7J6+M/7q4Okjj+kYp7PXhraFav6jWk7v9LZFr0pYq
	vqi669Vc4Fy0rGvHQKsSFZ45pOSfcTkrO8fktrPOU4OfvpQTB6PRT7pWcW0zQ4ies/P7hcxQ8kr
	u+FAOOG2uCx/FNhdJdu9gFBp5eY9cZsh4q/pVmSf0oQcb9zH7DCVQF2TtP1Qs90oiAWtSOpcN8d
	miK8V+LHUDNIut3QuiIEh/IDRj1iBzKYupRXXd/U8xq179RHZ/asVYy7TAhMjHJgdGT5YdYdIlo
	t1IxTyx0j3pymUhHmJw2VKtCvvS/48CF/dnfyHLL0qYLcs6Byrj6LbcftHrHEohcXi/lTycNocP
	flgHmn9pb/3OpzMvXNkMWilzga6AtrGjeOBidnHH+JvQKJV1v+naNY8se8mHtEdegBEgGU1RkWy
	L0Sa1rFTDdrGtde+LqIaTgMM6j4iM6BEs6GU0Eqnna8JVgg+rIU3UAQ1QCqLKtTLOfX/cbput+v
	Dymw4zCNsA36YgFlwhQr1rLttE9gF9JBc66Qmn3w5pRTUgk/DJhxDOEMf+Q7EVja/Co7qXDQCO6
	KUahDGJWmhu7hv1S/rWt2q8ajBnTU1BsEzRO44PXjVLVL9Q+cys730sh8phLHaLXdKzFFH4fHax
	gf8Wj/mK/Szbp7ZNbihwzH4eWJ352WBJcIpZB1+mBoggU1te0v2GFtHqS3iAxn2zlrL5Q9wQO1w
	pYoM/22yDhG/lbXn5v7Q8XQCYpl1zY1CRQKCKxTLUwGqLhFqaixUZo6E7udJWVVR4RnphP54ZhU
	FtgGJ392oWd
X-Received: by 2002:aa7:d0d0:0:b0:6ba:56e9:2980 with SMTP id 4fb4d7f45d1cf-6ba56e92a4amr11503002a12.23.1795776267028;
        Fri, 27 Nov 2026 02:44:27 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6bb34386705sm3001000a12.35.2026.11.27.02.44.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 Nov 2026 02:44:26 -0800 (PST)
Message-ID: <aa3281fc-7d06-4ac4-8bbf-1ed1a2066f81@gmail.com>
Date: Fri, 27 Nov 2026 11:44:26 +0100
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
Subject: Re: [PATCH RFC v3] netfilter: nft_synproxy: only handle a plain SYN
 or a plain ACK
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <2afd11cc-186e-49de-8c72-d9f529532f9d@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <2afd11cc-186e-49de-8c72-d9f529532f9d@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

On 11/26/26 15:46, syzbot wrote:
> nft_synproxy_eval_v4() and nft_synproxy_eval_v6() check tcp->syn and
> tcp->ack without excluding other TCP control flags, unlike the xtables
> SYNPROXY targets. As a result, a SYN+ACK (or SYN+FIN / SYN+RST) packet
> reaching nft_synproxy is misidentified as an initial client SYN and
> triggers another SYN+ACK reply, while FIN+ACK and RST+ACK packets enter the
> client ACK branch and can be dropped with NF_DROP instead of continuing
> through the ruleset.
> 
> On loopback, when an nftables input rule evaluates nft_synproxy, a local
> SYN causes it to send a SYN+ACK back over loopback, which hits the same
> rule again and matches tcp->syn. This creates an infinite SYN+ACK feedback
> loop in softirq context that saturates the CPUs, starves tasks holding or
> waiting on rtnl_mutex, and triggers hung task warnings (such as "INFO: task
> kworker/R-ipv6_:60 blocked for more than 143 seconds" in
> addrconf_dad_work).
> 
> Fix this in nft_synproxy_do_eval() by returning early when tcp->syn ==
> tcp->ack || tcp->fin || tcp->rst before dispatching to
> nft_synproxy_eval_v4() or nft_synproxy_eval_v6(). This ensures nft_synproxy
> only handles a plain SYN or a plain ACK (without FIN or RST), while valid
> TCP segments outside the client handshake such as SYN+ACK, FIN+ACK, and
> RST+ACK—as well as other segments with FIN, RST, or neither SYN nor ACK
> set—continue through the ruleset unchanged with regs->verdict.code left as
> NFT_CONTINUE.
> 
> Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
> Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+55141a0ffa0d17f01c71@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=55141a0ffa0d17f01c71
> Link: https://syzkaller.appspot.com/ai_job?id=19d80d6e-8025-483e-ac1b-da92f0b2dde3
> To: <coreteam@netfilter.org>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@kernel.org>
> To: "Florian Westphal" <fw@strlen.de>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: <netfilter-devel@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> To: "Pablo Neira Ayuso" <pablo@netfilter.org>
> To: "Fernando Fernandez Mancera" <ffmancera@riseup.net>
> Cc: "Simon Horman" <horms@kernel.org>
> Cc: "Phil Sutter" <phil@nwl.cc>
> 
> ---
> v3:
> - Updated the commit title and description to plain text without Markdown backticks.
> - Simplified the description of the loopback SYN-ACK feedback loop.
> - Clarified that valid TCP segments outside the client handshake (such as SYN+ACK, FIN+ACK, and RST+ACK) continue through the ruleset unchanged.
> 
> v2:
> - Moved the strict TCP flag check from `nft_synproxy_eval_v4()` and `nft_synproxy_eval_v6()` into `nft_synproxy_do_eval()`
> - Replaced the per-branch flag checks with `if (tcp->syn == tcp->ack || tcp->fin || tcp->rst) return;`
> - Updated the commit message to match the new implementation and removed the quoted hung-task and NMI backtrace excerpt
> https://lore.kernel.org/all/751ce8c9-049b-4177-8873-cea240e356e7@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/96d0756e-28cd-4b99-b0c7-17698acc8276@mail.kernel.org/T/
> ---
> diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
> index 554a96a00..aa8dea698 100644
> --- a/net/netfilter/nft_synproxy.c
> +++ b/net/netfilter/nft_synproxy.c
> @@ -137,6 +137,9 @@ static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
>  		return;
>  	}
>  
> +	if (tcp->syn == tcp->ack || tcp->fin || tcp->rst)
> +		return;
> +
>  	switch (skb->protocol) {
>  	case htons(ETH_P_IP):
>  		nft_synproxy_eval_v4(priv, regs, pkt, tcp, &_tcph, &opts);
> 
> 
> base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
#syz upstream

-- 
Krystian Kaniewski
