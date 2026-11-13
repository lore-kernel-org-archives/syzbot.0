Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794575687;
	b=ET/cJqs9pSVOEO0YfGGiXysWDts5ZsHL7uvUnMv5yBAFpYz8EaOLYR2T83aotkTunV6Q
	 efJl2oog7wz3GRlp/Jgg+PStZ0f3iY2ftLFDVNe4rug0o6w4rLFVq7o0MnkB2XQBELjLh
	 uLKA0OXHX3IkmH9kndbWC9GNFPDfhVbJ7SudV64DDpNxBoEjO1DTqxLZETOGmRmF9LapA
	 fcSKw5X8yfCu766nOC/uj0eZ0u+yccdx3U5IcapAD7CEmaWLgzZFwgfqhm23xb/krNpT1
	 L87kwsIiMu2evhk3VqPr/lls6W2Tkf9WCirbdR9Ha1J8bYU0eiQQkZaAwgjA3+v8tUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794575687;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=onbKA3BGt4l9GHRNtxkYjz7KVB7ZtHTNU01AjMrxcFw=;
	b=V5WBe2OKRvKg+Rm2Xu1+sE0JnyYaFdnaMHl+baAu3o7tdVlkYippsp++XMHWC/aRreKy
	 aV09XktmOocG1xBiwRj7NE5uCj6kclVBI53wXBIV6htrX+Y60bS++bgdp/hoqJXcuWH9J
	 /42LilAUfujHLDgiiEazSaJOSGkRQ/C9xMU7uV4pRD+mmfuWv4X+YAiUom6Pvf61vnUpH
	 JRteEFebi9b9UpfQlZ7mrLptARkzHg0c9Cby8RYWILprLyfT5Q1TEXhgYWCmkOhW6lfW3
	 fN5av/hM/fVAMgTJHpznpAv/z/10iim8u8Bne5PdV/yKsIBVP0emQjOW2VN2YFV0LkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lJis+eQZ;
	arc=none smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AAB8606A323
	for <syzbot@lists.linux.dev>; Fri, 13 Nov 2026 13:14:46 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8AAB8606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=lJis+eQZ
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c40f29667e6so220404766b.0
        for <syzbot@lists.linux.dev>; Fri, 13 Nov 2026 05:14:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794575685; x=1795180485; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=onbKA3BGt4l9GHRNtxkYjz7KVB7ZtHTNU01AjMrxcFw=;
        b=lJis+eQZQhDmrRNQwf74mReekyo6wRXyN4++Yd9kEERlvrWZOqIR5Hs71O9ChjcNa/
         pZ5KA6cA6f0G7rKsrXHX8zC7TVe/6FxLAckt25+Iz6ArjjS4s/pTUNMv7Em/Tk915+6Q
         W6zI0cURAoKxnu+XrFlFKjpj4q9G1D4IgnK6zhMai1iWsj3F7hAy7P79jgVBmwZoWIHM
         ElUB2KJxYKDDG9gz7Pq//iFahi/tUaovK0MEK6TCN8NcLJ/1obIB9yfW1Xpm+3IcqY36
         TNDEP7uUUl+fvXuVGdOHG/cAX6m6+XfT+s+fqv3Lwlm16evN3XwrdG1p6rbSq3W/lnFb
         7PIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794575685; x=1795180485;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=onbKA3BGt4l9GHRNtxkYjz7KVB7ZtHTNU01AjMrxcFw=;
        b=G5HR3Wqhc+NG8CjfKtr9bg/MjYUU9fZ2HDdMtwv51nomKYSJCjfc412aWRcGUeVSBL
         lrqIM6skTTucGNb5Jbnq43C20u9hZzw7nxFgdGAQjnABRZW9g2t5Hxs0HQBjl9Tx1q8K
         RM4bUzpgIYb+mg54e5v9wXdStpjZO7Y4gfxX+9TaDQyHkBWohlcvXcBKhzlluK00IB/3
         LvL0G0UHa6tZeU8bA+NaFgLRz7plPtHKusCQjtgL9jQaDNcsCcp+ENyLOGMNuv0KIpUK
         jKV6FPCkxwrl3mDMO4qKMTi0tpOw8il5a9sicKylU7v8LBhgLoWa8zHqhciwvv7gd9Yf
         GUUQ==
X-Gm-Message-State: APuU4Z+XesGfDDwO98rWoRdPQUQ8u2v/IA+6rvvgLs7D/8DAdJT0X1yr
	XknOpZz+dUkdOTysHaaN1oYAyh1iv0/X0LBEl7n0HIGRtLh+PxLI4eV3vAMF+ZR4G9L6ow==
X-Gm-Gg: AYBFou3Fy28/u44tgzGOnpIICPx65Co6giudt9XB5sNMXh8ClozOkKZLSy4pEllKtX5
	g5kXthvx8gMO0oXYXyyiR0Pu0xBpMFKygOWqWoNKLZa04rSYz0L3fNOkrBhGprmQq5TJ2KNEDb9
	H6GZpR0ARzI1cjm6qPLIcaN1TawT9oFQ/tuU29rvza/t5eidcaxCUvXofIaNEXYqGf1YY7awIaW
	EpvaB8tLig8gbuYEgZ5eqlla7WfFEI7yj1NjAjl8dA5Pk9ckDumgjIsOjXxE0G/rLjp8V3U53+C
	kapinS6Rbq45UGGQ/yWU3gO9/YQuLe02d4sJwQN+W4JJ7Tqx1MRoe76L+ltNQL+kaT5mOsdvXO8
	HwhFwNjLDZomn2ZrgZa+56CXFFGwtIqNCEDT36oh7SOMbEv9oGAMnLk66rvz8bosiDxPglueMlB
	EDHBKxXgQNJbOh3yrQPwKXIMlqKvLJtgL3EZa9ohKGbwUfqWwISn0d8zY0tsAFJEajKos3tORHV
	uHNEzhx3recH2tP1jsplnYFNVrwFVjDBrfhFWFU1orqVahwJ2mrZ9IY4rpTPQ17dlnepZ7UB2QI
	NRxyafHhJLTjCCJCSowkhwFXyPW5HsZh6G1behNh5f7+MceXfhGjW+3P7Z47Oq85UyDiCOib6LY
	/evt3O25nd4yQnkUuIEpYXGBCsiBAyBWu5b4LC677gRh6oUGYm4lTyNvuuVxMSltmJzKG9UkLRN
	s+w8QFNLsiwdIFb8qY5adyhRiJkQ6qnTcDbcspIjm0nwsiUUv61j64a9tidttGxaTRfJsBJS+As
	JAnz6ib4LjiFg==
X-Received: by 2002:a17:906:5146:10b0:c46:645f:cedf with SMTP id a640c23a62f3a-c5096398ad5mr169397966b.15.1794575684727;
        Fri, 13 Nov 2026 05:14:44 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b44739sm89903466b.40.2026.11.13.05.14.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 13 Nov 2026 05:14:44 -0800 (PST)
Message-ID: <354842e3-bcc3-487f-afde-49d5ead285c1@gmail.com>
Date: Fri, 13 Nov 2026 14:14:43 +0100
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
Subject: Re: [PATCH RFC v2] net/x25: fix invalid lock_sock() usage in
 x25_kill_by_neigh()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <b624bc4d-6240-4c80-82a8-c727545f2a5e@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <b624bc4d-6240-4c80-82a8-c727545f2a5e@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/10/26 18:16, syzbot wrote:
> x25_kill_by_neigh() is invoked to tear down X.25 sockets associated with a
> terminating neighbour. This function is called in process context from
> netdevice notifier handlers (such as NETDEV_DOWN in x25_device_event()),
> but it is also called in softirq context (NET_RX_SOFTIRQ) under
> rcu_read_lock() when receiving LAPB frames in x25_lapb_receive_frame() or
> link control packets in x25_link_control().
> 
> x25_kill_by_neigh() acquires lock_sock() around x25_disconnect(). Because
> lock_sock() is a sleeping lock, calling it from softirq context triggers a
> "BUG: sleeping function called from invalid context" and a lockdep
> inconsistent lock state warning ({SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W}) on
> sk_lock-AF_X25.
> 
> Fix this by passing a boolean parameter to x25_kill_by_neigh() and
> x25_link_terminated() to distinguish between process and softirq contexts.
> In process context (netdevice notifiers), continue using lock_sock() to
> synchronously disconnect sockets, ensuring that neighbour and netdevice
> references are cleared before the notifier returns to preserve the
> netdevice notifier lifetime guarantee. In softirq context, use
> bh_lock_sock() instead; if the socket is currently owned by user space,
> defer the disconnect by setting X25_KILL_BY_NEIGH_FLAG and handling it in
> x25_release_cb() when the socket is released.
> 
> Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by
> x25_disconnect")
> 
> Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by x25_disconnect")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+300375dfd44665f063a6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=300375dfd44665f063a6
> Link: https://syzkaller.appspot.com/ai_job?id=7eb00706-eb85-4671-b0e7-6b722aa4e884
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@kernel.org>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <linux-x25@vger.kernel.org>
> To: "Martin Schiller" <ms@dev.tdt.de>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> To: "Duoming Zhou" <duoming@zju.edu.cn>
> Cc: "Simon Horman" <horms@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v2:
> - Pass a boolean parameter to x25_kill_by_neigh() and x25_link_terminated() to distinguish softirq from process context.
> - Retain lock_sock() in process context to preserve synchronous socket teardown for netdevice notifications.
> - Retain write_lock_bh() on x25_list_lock instead of manually managing local_bh_disable().
> - Shorten the commit description by removing stack traces and per-function details.
> - Fix line wrapping in the Fixes tag.
> 
> v1:
> https://lore.kernel.org/all/f1cbebc5-aab9-44ac-8425-1bc9fdbbf5b7@mail.kernel.org/T/
> ---
> diff --git a/include/net/x25.h b/include/net/x25.h
> index 414f3fd99..ec4c9ced1 100644
> --- a/include/net/x25.h
> +++ b/include/net/x25.h
> @@ -118,6 +118,7 @@ enum {
>  #define X25_Q_BIT_FLAG		0
>  #define X25_INTERRUPT_FLAG	1
>  #define X25_ACCPT_APPRV_FLAG	2
> +#define X25_KILL_BY_NEIGH_FLAG	3
>  
>  /**
>   *	struct x25_route - x25 routing entry
> @@ -196,7 +197,7 @@ int x25_addr_aton(unsigned char *, struct x25_address *, struct x25_address *);
>  struct sock *x25_find_socket(unsigned int, struct x25_neigh *);
>  void x25_destroy_socket_from_timer(struct sock *);
>  int x25_rx_call_request(struct sk_buff *, struct x25_neigh *, unsigned int);
> -void x25_kill_by_neigh(struct x25_neigh *);
> +void x25_kill_by_neigh(struct x25_neigh *, bool);
>  
>  /* x25_dev.c */
>  void x25_send_frame(struct sk_buff *, struct x25_neigh *);
> @@ -230,7 +231,7 @@ void x25_link_control(struct sk_buff *, struct x25_neigh *, unsigned short);
>  void x25_link_device_up(struct net_device *);
>  void x25_link_device_down(struct net_device *);
>  void x25_link_established(struct x25_neigh *);
> -void x25_link_terminated(struct x25_neigh *);
> +void x25_link_terminated(struct x25_neigh *, bool);
>  void x25_transmit_clear_request(struct x25_neigh *, unsigned int,
>  				unsigned char);
>  void x25_transmit_link(struct sk_buff *, struct x25_neigh *);
> diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
> index f45c9ec7d..3fe3ba594 100644
> --- a/net/x25/af_x25.c
> +++ b/net/x25/af_x25.c
> @@ -221,7 +221,7 @@ static int x25_device_event(struct notifier_block *this, unsigned long event,
>  		case NETDEV_DOWN:
>  			nb = x25_get_neigh(dev);
>  			if (nb) {
> -				x25_link_terminated(nb);
> +				x25_link_terminated(nb, false);
>  				x25_neigh_put(nb);
>  			}
>  			x25_route_device_down(dev);
> @@ -234,7 +234,7 @@ static int x25_device_event(struct notifier_block *this, unsigned long event,
>  			if (!netif_carrier_ok(dev)) {
>  				nb = x25_get_neigh(dev);
>  				if (nb) {
> -					x25_link_terminated(nb);
> +					x25_link_terminated(nb, false);
>  					x25_neigh_put(nb);
>  				}
>  			}
> @@ -492,10 +492,17 @@ static int x25_listen(struct socket *sock, int backlog)
>  	return rc;
>  }
>  
> +static void x25_release_cb(struct sock *sk)
> +{
> +	if (test_and_clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25_sk(sk)->flags))
> +		x25_disconnect(sk, ENETUNREACH, 0, 0);
> +}
> +
>  static struct proto x25_proto = {
>  	.name	  = "X25",
>  	.owner	  = THIS_MODULE,
>  	.obj_size = sizeof(struct x25_sock),
> +	.release_cb = x25_release_cb,
>  };
>  
>  static struct sock *x25_alloc_socket(struct net *net, int kern)
> @@ -610,6 +617,7 @@ static struct sock *x25_make_new(struct sock *osk)
>  	x25->cudmatchlength = ox25->cudmatchlength;
>  
>  	clear_bit(X25_INTERRUPT_FLAG, &x25->flags);
> +	clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags);
>  	x25_init_timers(sk);
>  out:
>  	return sk;
> @@ -827,6 +835,7 @@ static int x25_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
>  		x25->neighbour = NULL;
>  		read_unlock_bh(&x25_list_lock);
>  		x25->state = X25_STATE_0;
> +		clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags);
>  	}
>  out_put_route:
>  	x25_route_put(rt);
> @@ -1761,7 +1770,7 @@ static struct notifier_block x25_dev_notifier = {
>  	.notifier_call = x25_device_event,
>  };
>  
> -void x25_kill_by_neigh(struct x25_neigh *nb)
> +void x25_kill_by_neigh(struct x25_neigh *nb, bool bh)
>  {
>  	struct sock *s;
>  
> @@ -1769,13 +1778,27 @@ void x25_kill_by_neigh(struct x25_neigh *nb)
>  	write_lock_bh(&x25_list_lock);
>  
>  	sk_for_each(s, &x25_list) {
> -		if (x25_sk(s)->neighbour == nb) {
> +		if (x25_sk(s)->neighbour == nb &&
> +		    (!bh || !test_bit(X25_KILL_BY_NEIGH_FLAG, &x25_sk(s)->flags))) {
>  			sock_hold(s);
>  			write_unlock_bh(&x25_list_lock);
> -			lock_sock(s);
> -			if (x25_sk(s)->neighbour == nb)
> -				x25_disconnect(s, ENETUNREACH, 0, 0);
> -			release_sock(s);
> +			if (bh) {
> +				bh_lock_sock(s);
> +				if (x25_sk(s)->neighbour == nb) {
> +					if (sock_owned_by_user(s))
> +						set_bit(X25_KILL_BY_NEIGH_FLAG,
> +							&x25_sk(s)->flags);
> +					else
> +						x25_disconnect(s, ENETUNREACH,
> +							       0, 0);
> +				}
> +				bh_unlock_sock(s);
> +			} else {
> +				lock_sock(s);
> +				if (x25_sk(s)->neighbour == nb)
> +					x25_disconnect(s, ENETUNREACH, 0, 0);
> +				release_sock(s);
> +			}
>  			sock_put(s);
>  			goto again;
>  		}
> diff --git a/net/x25/x25_dev.c b/net/x25/x25_dev.c
> index fb8ac1aa5..be5eb01de 100644
> --- a/net/x25/x25_dev.c
> +++ b/net/x25/x25_dev.c
> @@ -135,7 +135,7 @@ int x25_lapb_receive_frame(struct sk_buff *skb, struct net_device *dev,
>  		break;
>  
>  	case X25_IFACE_DISCONNECT:
> -		x25_link_terminated(nb);
> +		x25_link_terminated(nb, true);
>  		break;
>  	}
>  	x25_neigh_put(nb);
> diff --git a/net/x25/x25_link.c b/net/x25/x25_link.c
> index d1e8cd81c..d3e90b402 100644
> --- a/net/x25/x25_link.c
> +++ b/net/x25/x25_link.c
> @@ -82,7 +82,7 @@ void x25_link_control(struct sk_buff *skb, struct x25_neigh *nb,
>  			break;
>  		case X25_LINK_STATE_3:
>  			/* clear existing virtual calls */
> -			x25_kill_by_neigh(nb);
> +			x25_kill_by_neigh(nb, true);
>  
>  			x25_transmit_restart_confirmation(nb);
>  			break;
> @@ -97,7 +97,7 @@ void x25_link_control(struct sk_buff *skb, struct x25_neigh *nb,
>  			break;
>  		case X25_LINK_STATE_3:
>  			/* clear existing virtual calls */
> -			x25_kill_by_neigh(nb);
> +			x25_kill_by_neigh(nb, true);
>  
>  			x25_transmit_restart_request(nb);
>  			nb->state = X25_LINK_STATE_2;
> @@ -247,14 +247,14 @@ void x25_link_established(struct x25_neigh *nb)
>   *	request has failed.
>   */
>  
> -void x25_link_terminated(struct x25_neigh *nb)
> +void x25_link_terminated(struct x25_neigh *nb, bool bh)
>  {
>  	nb->state = X25_LINK_STATE_0;
>  	skb_queue_purge(&nb->queue);
>  	x25_stop_t20timer(nb);
>  
>  	/* Out of order: clear existing virtual calls (X.25 03/93 4.6.3) */
> -	x25_kill_by_neigh(nb);
> +	x25_kill_by_neigh(nb, bh);
>  }
>  
>  /*
> diff --git a/net/x25/x25_subr.c b/net/x25/x25_subr.c
> index 159708d9a..344818f88 100644
> --- a/net/x25/x25_subr.c
> +++ b/net/x25/x25_subr.c
> @@ -341,6 +341,8 @@ void x25_disconnect(struct sock *sk, int reason, unsigned char cause,
>  {
>  	struct x25_sock *x25 = x25_sk(sk);
>  
> +	clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags);
> +
>  	x25_clear_queues(sk);
>  	x25_stop_timer(sk);
>  
> 
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4

Please let x25_release_cb() clear the call only while the socket still
uses a neighbour, by testing x25->neighbour together with
X25_KILL_BY_NEIGH_FLAG before it calls x25_disconnect(). The receive
path sets the flag under bh_lock_sock(), but a task that owns the
socket runs x25_disconnect() without that spinlock, for example for a
Clear Request that release_sock() processes from the socket backlog.
x25_disconnect() clears the flag at its start and stores NULL in
x25->neighbour only at its end, so a softirq walk that rechecks the
neighbour in between still finds it and sets the flag after the clear.
x25_release_cb() then calls x25_disconnect(sk, ENETUNREACH, 0, 0) a
second time and overwrites sk_err and the clearing cause and
diagnostic of a call that was already cleared. The x25_connect() error
path has the same kind of window around its NULL store and its
clear_bit(). x25_release_cb() runs from release_sock() with the socket
spinlock held while the task still owns the socket, so neither the
owner nor the receive path can change x25->neighbour at that point,
and the check closes both windows without new locking.

Please also remove the wrapped Fixes text from the end of the patch
description. The description still ends with the Fixes tag for
7781607938c8 split over two lines, and the same tag is added again
below the description from the Fixes metadata. The posted mail
therefore carries the tag twice, once in a broken form that tools
cannot parse. Keep the Fixes metadata itself, since it points to the
right commit. Only the copy inside the description text has to go.

In x25_kill_by_neigh(), keep the added lines within 80 columns. The
new condition that tests the neighbour and X25_KILL_BY_NEIGH_FLAG is
84 columns wide, and netdev checks patches with an 80 column limit.
Reflow it without changing the logic, for example with a local struct
x25_sock pointer or with an early continue for a socket on another
neighbour.

Keep the rest of the design. The callers should keep passing the
calling context, because each of them knows it, and deciding it inside
x25_kill_by_neigh() would need in_softirq() style checks that new code
should not use. The netdevice notifier path keeps lock_sock(), the
neighbour recheck and the synchronous disconnect, and does not skip a
socket that already carries the flag. The receive path,
x25_lapb_receive_frame() and the restart cases in x25_link_control(),
takes bh_lock_sock(), disconnects at once when no task owns the socket
and otherwise sets the flag for x25_release_cb(). Keep the sock_hold(),
recheck and restart structure of the walk, and keep clearing the flag
in x25_make_new(), because a new socket copies the flags of its
listener.

-- 
Krystian Kaniewski
