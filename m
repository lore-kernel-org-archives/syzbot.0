Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795617724;
	b=5TR7y2VNMnTxL/Sr+yoKgcWkQpviZzjHYvfNg1YhA8ob69K3xlZmED84451lr7PkGVE3
	 QXnUkWNtz4Ei3qrMJfoUKvHtSsei7skYxRvtZJO3neE6mgjA8abcFC+LQOJc9HIkltgBd
	 bVYtn6gjcg3aVBRDiyS84daHMNpyr6fhajDAU5rLjG3tMdPzuCHz+HJQVj29+pje98Mxy
	 q0thaMU6zMoKcFSY6v+V4NScRUk3I6eDM2MgtPKGgDL9MYf54jq1Geq3TaCp88VSy1PhG
	 50VyAfb2MbUo8F9CkrGG3olU3IpshAWbJr8LU3MlYPOlwTKIL9WLaxTBO+yD41f/fYA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795617724;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=KBGJr4xk5Q2bzVWqvpBexfySHqqo9cMXvhdbMshGOQo=;
	b=dcdSW+3wb9+gy+gg4x3+vlkykHzJIEu3/HpYYimo5W0ogTQl8ms4imFnqfO5ygbLIPTe
	 bJz77f7Pp4MuwAU3DGnWcZqDu7tIHo8hHV40DW0ShGkPKoEOp7qH7AGviJ3QRfz3iBicM
	 oRBkKTwg22yVaHoHf1GrmuF/FLRdOiYCkZ1eFgKHc/m0p6u6RLAB2DKMT7e0McZRuuuul
	 YsZMfaIAxBuu6bs5RPYzjFKnfMwba8GdcS5u+hwcUZNi3carhMMNPnLTdZPzaSq7ennMc
	 F/wE2+DPTgD69unG7peRCSs3LKMTN5Se3UL8e5/kl48hWJypp7jIyHGpn1r6rrVHPlw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MOdon+CP;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C17E3606A323
	for <syzbot@lists.linux.dev>; Wed, 25 Nov 2026 14:42:03 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C17E3606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=MOdon+CP
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c4d28f75d62so969733466b.0
        for <syzbot@lists.linux.dev>; Wed, 25 Nov 2026 06:42:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795617722; x=1796222522; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=KBGJr4xk5Q2bzVWqvpBexfySHqqo9cMXvhdbMshGOQo=;
        b=MOdon+CP57Do8B8X2yyf5Td4mtsMT9Fse50OTvQX/Non3KJxqOeHrA9fag+8cvb//h
         mLSckjXvRXtI8US1W0iWOfdfYdaBNh864CwxglVKkY/sDsaPZsLSwh4JszbAqQvZYGJ5
         msXNAJ9026/+CN2P3RMDodX0MG9NBUyqS7oRHq++UoyjvRmLpdoYIo9W/z63/AA+2sLb
         WxzRUWfE+DB2kW1hABt/pLJF17mAm2I6YZZ7i9eIiVoR0eS5T8z6acf+O2AKPyt5i9hI
         GZwk/pcc5f5e98k3mW1WGvJahLsbsopswtpzRXO/uVSMHpJ1t74noR7MPdN1f84cI921
         4RGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795617722; x=1796222522;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=KBGJr4xk5Q2bzVWqvpBexfySHqqo9cMXvhdbMshGOQo=;
        b=J4Rnys7ckTZFsKtrbFIq/jNvHMcpdqtbfU/5bWdaDTYO1hIUp6kbn/2fN0BGvWx3Vq
         iYmVEkX+KOWfrjQPsZ6Mg22grl3LSkyoTEjQLOnqpOz7fwwFUqGIOCyslvrxi5lb+8UK
         LEgQ9wA385++o94M0sE9Dv27gZKuovSioPQybZQtxT1S9RlyIL95J/nViBC0KnyjfAs/
         iAeOYcI+l8DK1GnixUmx0W9umo7kE/M9/aiFs2uLPRzjxCpEmlvAC723ubDbCjmxebPW
         Irm0+8wEF0tvSO6jVSC38s2vPmE0ktOD9/8VDfjx5C0l6CPaRFY3cmbhtsqv/BEY0kkr
         ieog==
X-Gm-Message-State: APuU4Z/wketXRc1OO/63VZDOWdkWtz3PlF0Bo0RaW+ZBgjMG+GnLHmCH
	bHJHobrSLGtNr9EtwSHigzT5CycjD/x86lp8EhhEEIPgcWW2asnanJZSzYnpYJ9npMg=
X-Gm-Gg: AZFdTZc9Wl6C0KK8btPbh20qZ7Bzk1sA1SGKnU/rC48UEw58Q6c+82wtPX37BtXkCfP
	hzL4cH4K8W1Qxs5uEMSZ0PoRgunqutp5vxPKZAJkTAKipgJcGmFwOwcf9sNe8wI++5f3GVNUg0t
	mPY+4xztRz2tA26jXIGJSF4v1sbm4r0XSxZJFmg+Yp7KysXM+MW05lLTquOTX0ATpBblGG49slB
	7xaUUIB4yzEPbqrwqCH0IEQkgiSo5P7w4K3LCXPO345boh1pz10SiviA/NTb2nTGS36VALbNxgp
	baMBjOKDMWrPsk7FsIPrTI+gJag5QCewUTgzY3PfhEoadQR7FkVo6HI7kAFWuU+CfIKznn0sMJ8
	zDN9nrOvy5XkicRMBuAMW+K7+ZqlehBr7aacOjM8koQjY5P+hX1cytxahLSiLXoziRvWVG3FO+J
	38hZh0RJ/D7AcnUuCrGVkZ/Qqtl09QSPwH3aFo8gpm63iRNCmu6negNvEPL2Jp2Op/RuaNWnSr2
	GCMw6maoH4kWbHU9K5AZYGdr98fUG4zSFe2U3Ckrqu2OkZZYpPzpdvhea9g+JglPoGHOgq+Wkuy
	PrwLPy0DS+N1DQ6zWBCFixeW1NhfZihVKS1KH+7krHCl4cKCsiG+hLqU5o1f3eakoB0kV5PbU6T
	XLFlLlNyr1mq4yYcHg7sM/W+vJLPj3ZHqXExKI24hHTq1x3RMqRR4vY93Wn2RYzKGrA2QOTYkZt
	y1IGsxavQpQt91T8xA9G20L0XtQ+X9CQY7+57W2OfJjcFXfqntYNlbdvfDttvh6gA=
X-Received: by 2002:a17:906:7309:b0:c51:ab50:326a with SMTP id a640c23a62f3a-c51ab503c7emr156658666b.1.1795617721888;
        Wed, 25 Nov 2026 06:42:01 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513aebe94fsm632750566b.49.2026.11.25.06.42.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2026 06:42:01 -0800 (PST)
Message-ID: <c1da196b-c3b0-4701-9cbf-bf357bfebfc8@gmail.com>
Date: Wed, 25 Nov 2026 15:42:00 +0100
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
Subject: Re: [PATCH RFC] netfilter: nft_synproxy: enforce strict TCP flag
 matching
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <96d0756e-28cd-4b99-b0c7-17698acc8276@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <96d0756e-28cd-4b99-b0c7-17698acc8276@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/24/26 18:28, syzbot wrote:
> In nft_synproxy_eval_v4() and nft_synproxy_eval_v6(), TCP control flags are
> checked only with `if (tcp->syn)` and `else if (tcp->ack)` without
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
> `process_backlog()` in `NET_RX_SOFTIRQ` delivers that SYN+ACK back to
> `NF_INET_LOCAL_IN`, `if (tcp->syn)` matches again, creating an infinite
> SYN+ACK loop in softirq context. This saturates the CPUs, starves tasks
> holding or waiting on `rtnl_mutex`, and triggers hung task warnings:
> 
> INFO: task kworker/R-ipv6_:60 blocked for more than 144 seconds.
> Workqueue: ipv6_addrconf addrconf_dad_work
> Call Trace:
>  __mutex_lock+0x7c4/0x15a0 kernel/locking/mutex.c:821
>  rtnl_net_lock include/linux/rtnetlink.h:134 [inline]
>  addrconf_dad_work+0x116/0x15c0 net/ipv6/addrconf.c:4256
> 
> NMI backtrace for cpu 1
>  __kfree_skb+0x5d/0x210 net/core/skbuff.c:1203
>  nft_synproxy_eval_v4+0x36a/0x4e0 net/netfilter/nft_synproxy.c:-1
>  nft_synproxy_do_eval+0x389/0x5d0 net/netfilter/nft_synproxy.c:142
>  expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
>  nft_do_chain+0x48d/0x1b10 net/netfilter/nf_tables_core.c:285
>  nft_do_chain_ipv4+0x195/0x290 net/netfilter/nft_chain_filter.c:24
>  process_backlog+0xa6b/0x18b0 net/core/dev.c:6915
> 
> Fix this by enforcing the same strict TCP flag checks as `ipt_SYNPROXY` and
> `ip6t_SYNPROXY` in both `nft_synproxy_eval_v4()` and
> `nft_synproxy_eval_v6()`: require `tcp->syn && !(tcp->ack || tcp->fin ||
> tcp->rst)` for the initial SYN branch and `tcp->ack && !(tcp->fin ||
> tcp->rst || tcp->syn)` for the client ACK branch. Excluding `tcp->syn` from
> the ACK branch ensures SYN+ACK packets are not passed to
> `synproxy_recv_client_ack()` or `synproxy_recv_client_ack_ipv6()` and
> dropped, while unrelated control packets fall through with
> `regs->verdict.code` left as `NFT_CONTINUE`.
> 
> Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
> Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-4-carbon syzbot
> Reported-by: syzbot+55141a0ffa0d17f01c71@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=55141a0ffa0d17f01c71
> Link: https://syzkaller.appspot.com/ai_job?id=d414ed29-2420-4a5b-b4af-0b7b7dc8df30
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
> diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
> index 554a96a00..ad43faf1d 100644
> --- a/net/netfilter/nft_synproxy.c
> +++ b/net/netfilter/nft_synproxy.c
> @@ -53,13 +53,13 @@ static void nft_synproxy_eval_v4(const struct nft_synproxy *priv,
>  	struct synproxy_net *snet = synproxy_pernet(net);
>  	struct sk_buff *skb = pkt->skb;
>  
> -	if (tcp->syn) {
> +	if (tcp->syn && !(tcp->ack || tcp->fin || tcp->rst)) {
>  		/* Initial SYN from client */
>  		nft_synproxy_tcp_options(opts, tcp, snet, &info);
>  		synproxy_send_client_synack(net, skb, tcp, opts);
>  		consume_skb(skb);
>  		regs->verdict.code = NF_STOLEN;
> -	} else if (tcp->ack) {
> +	} else if (tcp->ack && !(tcp->fin || tcp->rst || tcp->syn)) {
>  		/* ACK from client */
>  		if (synproxy_recv_client_ack(net, skb, tcp, opts,
>  					     ntohl(tcp->seq))) {
> @@ -84,13 +84,13 @@ static void nft_synproxy_eval_v6(const struct nft_synproxy *priv,
>  	struct synproxy_net *snet = synproxy_pernet(net);
>  	struct sk_buff *skb = pkt->skb;
>  
> -	if (tcp->syn) {
> +	if (tcp->syn && !(tcp->ack || tcp->fin || tcp->rst)) {
>  		/* Initial SYN from client */
>  		nft_synproxy_tcp_options(opts, tcp, snet, &info);
>  		synproxy_send_client_synack_ipv6(net, skb, tcp, opts);
>  		consume_skb(skb);
>  		regs->verdict.code = NF_STOLEN;
> -	} else if (tcp->ack) {
> +	} else if (tcp->ack && !(tcp->fin || tcp->rst || tcp->syn)) {
>  		/* ACK from client */
>  		if (synproxy_recv_client_ack_ipv6(net, skb, tcp, opts,
>  						  ntohl(tcp->seq))) {
> 
> 
> base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f

Move TCP flag eligibility into `nft_synproxy_do_eval()` after
`synproxy_parse_options()` and before the IPv4 and IPv6 dispatch. Return
without changing the nftables verdict when SYN and ACK have the same
value, or when FIN or RST is set:

    if (tcp->syn == tcp->ack || tcp->fin || tcp->rst)
            return;

Keep the family evaluators focused on packet construction and cookie
processing so this family-neutral policy is defined only once. Preserve
the existing checksum, header, and option error order, together with the
current clean SYN and clean ACK behavior.

Rewrite the commit message to remove the quoted hung-task and NMI excerpt.
That exact excerpt does not match the retained crash report. Keep the
supported explanation that a generated SYN+ACK can return through the same
input rule and sustain a feedback loop in softirq context. Preserve the
verified `Fixes` tag, syzbot report and job links, and existing Gemini
provenance. Do not change any other behavior.
-- 
Krystian Kaniewski
