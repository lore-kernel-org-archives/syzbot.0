Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.46
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795701460;
	b=26aoedQJdTqDPK0qOB0hFTg7up1qTjfjdQcMfmbEvMYknRtiIUrbOGnP3oxfAaPw87nZ
	 rEbyubXk6TCFjJ25uKU+Y2hqKTA8n8jWrN1WjEuFb0vvz63Ut1fTzn7+ycW4WRjGEPJR2
	 9JjSijdwTNjgyzLBQGkdVdmTZA17L655ILW/sT+ZGRkzzqAHFI06def/Q/q0vNyYeHndb
	 tz/VYauIYeJjuuz5qwHwD2bPGtwn3cyN3RTA2JZ7SOcv4L5OF0RDS226LrAfBC1cvOET3
	 TbyorwSZoJ0ruW6IGHv+lwKKqYfeINGV8qt5qjPQeKvd+CL6VUwDtOgzq9/a/rjoDoA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795701460;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=1Dfm3S1UBcGSYj7dVkvrTqNBQusoiI5NuYW/KxrmGvE=;
	b=tabdLDi3FGOTvQ6SGzRG9+RGmGJjd1Lh9sLB4BWQXNd2x07S2ZQ3CfoBzg63pD5yRFQf
	 T29tXXqVXciO1GobzWNv2IbkyfHxeB8JcKxvlmjXEeyLdFNd2U9LDjpOJ2WhJ4nBrDn1Q
	 z0lwUxO4ECP34JasECra1QW8QXLIFQIJbVgwDu9ZF9leX/+ERmMAPm4YSc6y8tl1o2y2w
	 1GVJ3gjrATyXj/RoA5N+lM3lRJb/2TwzohQpY5v9u57jLZEg/kpmYq21ek/s7flwjzBGk
	 PBC3n4F8hj39fPRo6+93pVpZ03nG4tYIu6ZceMbgv6Se4SJONYnKbnnwshXrmpSrqxg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r0d1ig+1;
	arc=none smtp.remote-ip=209.85.208.46
Received: from mail-ed1-f46.google.com (mail-ed1-f46.google.com [209.85.208.46])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DE2E606A31E
	for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 13:57:40 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 7DE2E606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=r0d1ig+1
Received: by mail-ed1-f46.google.com with SMTP id 4fb4d7f45d1cf-6b7ddb99db4so9164613a12.0
        for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 05:57:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795701459; x=1796306259; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1Dfm3S1UBcGSYj7dVkvrTqNBQusoiI5NuYW/KxrmGvE=;
        b=r0d1ig+1LWGqgFj8CuLhK7l1L1Ek/kmr6r8lDmiC2D6unWLnWeU8kJ94xpCnlg5NrA
         e1GrjWzelkY6Vv7UcWJjDJe6NAcWDCC4I23YrQmkoZd17L1/yS04FzbbzNvPsnD7VBwx
         e/OgIHyfvoaNbEOxlz9I+5gMc0HNkbiIAE1BHZHX0lhQRuq95PrcX2Yj4fVtM1CeNe9W
         mks3qLundP9EtJjBiceMRuq3on4UYTZG+v+sDqUGX2YpVbRusSMZUF3uVa0XAFNwVw4B
         qlwAvHWI6IKs5SU3nDnSLrT5xkJS5zUkRguo0eLRT/uHYOfsSZDoEZbdVXbcnwJPHrMU
         2wZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795701459; x=1796306259;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=1Dfm3S1UBcGSYj7dVkvrTqNBQusoiI5NuYW/KxrmGvE=;
        b=ugSoVpCq4twZD2h1WulXjVbk2DVBIdQcMAkF5s22NDdKr0vdFDe4zxVpuo5HVYIoGd
         +ag8o8ebwdSqW6FCAWgc0/fnsAfosJPdoOl/qIkKB6+95wQiVq3tNV033G24ck5v1edb
         eZ0FHsRkhHUX/18122ki3t15NAon1Ut0cwr3+Zh4QXLOnU1IoSNacnDY+E+acDZP9kAf
         cRnfizC65jRmtTpOR0CchNd0LOOHuxTmJ1Qk4Vr8kp96BTnU9x7+DixqnXoF+Y6LZ6su
         kLM9roNKLcEYHamTrhPuHG7VZGUuNXT/YJFbgUo6lQhK2QPpcSF5LYP6UkPcegKoibbH
         6x7g==
X-Gm-Message-State: APuU4Z9OYiwYpvm4ldhWLS3rGAB1gcfnrqMIjPKj5OHvYIj5plY2Zi9f
	VQRxXVx9TOEo5jjlk53fcU62iegwt8qe5ju6/EsFDlc4Tuk8fVW/zZIP
X-Gm-Gg: AZFdTZeHFNjRZzTolLOqTlcjkechLWvUm6/StdU4w07VCdeL0sIhibNlL4J49t2snmN
	muhDSDL9xUpFkuiRzZoM/NXHqWOlZSSn9Mm/n3WY25ZOrLxnVXGFfZIQhT3DOmqoymB+UwIPgy8
	gRaXBBLqvrl2XE+GifAs/3SmNNX+NbkTD4fL6X/YQ7nNo/dCozPqqV3Fvq9ed/PX6vUcwH2F4Xi
	ItjeWIl23USMywkCv0mn+CKlzWzfyLJuaRG+l2M8HmAhzAS8AE69H7d+ayQyh7JefiDp6LJXf0O
	9HCv+bITyPKSgiE1j2tEyisI84YUa72CBGUhxRd6ysrjuUlkLvaAcI6RjWvj5uGirMhRHdXaNO8
	bZIja2Frn3CE0L2UW6zppznWUFAnTlm9d3r8PiCsRYi8HVXXDgRbD+KaL90seMNH2VPSJjCsWM3
	MmeA6Oxv06K5EUZq2MnKxlrf/oGBMSDOnOKxI5zRz4M7a7kbsqA+Kx0VHryLSYocHE0onw3x/1X
	xbCV/jej9shfziU3CitgU3AKopEuxcX37WLx4g+GKhQT9HT2eBrUynjfJPFPPMH/tRgJlNmvpub
	xTyIr6pLUWMs7xCL0/Z0VxYAyiANDMH3mWy/xCKeODsUSAl8rOvzMEPo7V4pDkUTQw9Zegiow4k
	ntaX24iqIIVexLp/IgqFEFh6eTylZGFSmgtgpXTfSpUJmfv/K93ZINMaZVeU13l4ZfA+Wxe0+KA
	5QpaQNrUIHw/2QgmQiBB8XHicUt234iV3k8CqPGoOaj+sYWy5zXTb9Ky3wYwtbZ04=
X-Received: by 2002:aa7:ca4b:0:b0:6b5:817e:4bd5 with SMTP id 4fb4d7f45d1cf-6ba37d3de4amr11657915a12.18.1795701458632;
        Thu, 26 Nov 2026 05:57:38 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6ba36e35641sm9711713a12.1.2026.11.26.05.57.38
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 05:57:38 -0800 (PST)
Message-ID: <54d0f310-e7c0-4439-8dd6-1c46d6aa0202@gmail.com>
Date: Thu, 26 Nov 2026 14:57:37 +0100
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
Subject: Re: [PATCH RFC v2] netfilter: nft_synproxy: enforce strict TCP flag
 matching
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <751ce8c9-049b-4177-8873-cea240e356e7@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <751ce8c9-049b-4177-8873-cea240e356e7@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/25/26 17:43, syzbot wrote:
> In `nft_synproxy_eval_v4()` and `nft_synproxy_eval_v6()`, TCP control flags
> are checked only with `if (tcp->syn)` and `else if (tcp->ack)` without
> excluding other flags, unlike the xtables SYNPROXY targets
> (`synproxy_tg4()` and `synproxy_tg6()`). As a result, a SYN+ACK (or SYN+FIN
> / SYN+RST) packet reaching `nft_synproxy` is misidentified as an initial
> client SYN and causes `synproxy_send_client_synack()` or
> `synproxy_send_client_synack_ipv6()` to reply with another SYN+ACK.
> Likewise, FIN+ACK and RST+ACK packets enter the client ACK branch and can
> be dropped with NF_DROP instead of continuing through the ruleset.
> 
> When an nftables rule evaluates `nft_synproxy` (either via the inline
> expression or a stateful `NFT_OBJECT_SYNPROXY` object) on
> `NF_INET_LOCAL_IN`, a local TCP SYN over loopback triggers
> `nft_synproxy_eval_v4()` to send a SYN+ACK with swapped addresses and ports
> and a fresh TTL via `synproxy_send_client_synack()`. When
> `process_backlog()` in `NET_RX_SOFTIRQ` delivers that generated SYN+ACK
> back through the same input rule on `NF_INET_LOCAL_IN`, `if (tcp->syn)`
> matches again and sustains an infinite SYN+ACK feedback loop in softirq
> context, saturating the CPUs, starving tasks holding or waiting on
> `rtnl_mutex`, and triggering hung task warnings.
> 
> Fix this by filtering out invalid TCP flag combinations in
> `nft_synproxy_do_eval()` before dispatching to `nft_synproxy_eval_v4()` or
> `nft_synproxy_eval_v6()`: return early when `tcp->syn == tcp->ack ||
> tcp->fin || tcp->rst`. This rejects packets with FIN or RST set, packets
> with neither SYN nor ACK set, and SYN+ACK packets, ensuring only SYN-only
> or ACK-only control packets (without FIN/RST) reach the v4/v6 evaluation
> helpers while unrelated control packets fall through with
> `regs->verdict.code` left as `NFT_CONTINUE`.
> 
> Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
> Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+55141a0ffa0d17f01c71@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=55141a0ffa0d17f01c71
> Link: https://syzkaller.appspot.com/ai_job?id=01904981-72da-437f-a636-e56909e8bc78
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
> v2:
> - Moved the strict TCP flag check from `nft_synproxy_eval_v4()` and `nft_synproxy_eval_v6()` into `nft_synproxy_do_eval()`
> - Replaced the per-branch flag checks with `if (tcp->syn == tcp->ack || tcp->fin || tcp->rst) return;`
> - Updated the commit message to match the new implementation and removed the quoted hung-task and NMI backtrace excerpt
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
Please rewrite the commit message as plain kernel changelog text and
keep the code change exactly as it is. The single check in
nft_synproxy_do_eval() is correct and needs no further change.

The current description puts Markdown backticks around function names
and code, which kernel changelogs do not use, and its second paragraph
walks through the loop one function and hook at a time. Its last
paragraph also calls SYN-ACK, FIN+ACK and RST+ACK "invalid TCP flag
combinations" and says that the check "rejects" them. These are valid
TCP segments that are only not part of the client handshake, and after
the check they continue through the ruleset with the verdict
unchanged, as the end of the same sentence says. A description along
these lines would be enough:

  netfilter: nft_synproxy: only handle a plain SYN or a plain ACK

  The synproxy expression and object answer every TCP segment with SYN
  set with a SYN-ACK cookie and treat every other segment with ACK set
  as the ACK that completes the handshake. The iptables and ip6tables
  SYNPROXY targets act only on a SYN without ACK, FIN and RST, or an
  ACK without SYN, FIN and RST.

  A SYN-ACK is what synproxy sends itself. When it reaches the same rule
  again, as it does over loopback for a connection to a local address,
  it is answered with another SYN-ACK, and so on forever in softirq
  context. Each retransmitted SYN starts one more such loop. syzbot hit
  this with a synproxy rule on the input hook that matched all TCP
  segments: a CPU kept running the loop in net_rx_action() and tasks
  waiting for the RTNL mutex were reported as hung.

  Return early from nft_synproxy_do_eval(), before the family specific
  code, for a segment that has FIN or RST set or that does not have
  exactly one of SYN and ACK. Such segments continue through the
  ruleset, as with the SYNPROXY targets.

Keep the Fixes tag of this version unchanged.
-- 
Krystian Kaniewski
