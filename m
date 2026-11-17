Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.51
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794913256;
	b=XK9UBWB4VrB7Yj0oXgovWGzx+AZtjLqXONdN8ALUC6QOTxIKttUWxntVZuiL71k51Coi
	 3VtsjmZS1FNcguYoXOqc0QCNHzBaFm5Kz+IZ5a+tzNLg+zV6V8U3IC8zeUFXAJ5yfet3S
	 6UzT97SuxsXB8siFM77vThx8AwfAETlNb/uSmCUN3rL7WaeYaUJqc9T/9n4RMKneQ8sSn
	 +K02CnqpaC7J44Zg9vdoZahdI2OqnIFQZqt0zm7M151N6wPzh4QNInEGLic+n5ub/uTzR
	 3VYCfQVfqlZBdWkgFGPOz1QMcg9YLZ9J5M/C9i27POF39Ril0SXyITd9w7V8K1/ExvA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794913256;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=5EgXDSzTP2vn8ES7tici+mX3N/VrZpLK1Xqz+vaiFuo=;
	b=M2/vsYcJ+aFAbys8LPZ5GWEJYORYWHFmGl7xFkh4Z297kA4BjBZs6C0jOx2Os4fsWrGc
	 JguONzzcebFW/pabgv1As9ja2Ua2HHOKyBqRZ3R6WQwmUrDmUAYREhCk/L8W1PvPMio3F
	 kvG02ljGQFEoUMA6d76QOpKJDVMTjpjUEiRDI6gFFGzhP1XVlY11hyD2rs5yyB/xmkXBK
	 n2ApYFY1lX+dDs0QbInfW4SMcwcF/jC7LsKFIrSR8/AA55s1zDpqQUTNJg0gvBTCFdE1t
	 QQ51D/J+3NFna+dFGPqinE2hW9zbqTP+TEhQXfFejiia4cuhYd93tBs8MBaAXfqk0zA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z8BxTzhC;
	arc=none smtp.remote-ip=209.85.218.51
Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0729606A31C
	for <syzbot@lists.linux.dev>; Tue, 17 Nov 2026 11:00:55 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D0729606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=z8BxTzhC
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c50ac25cdd4so455154966b.1
        for <syzbot@lists.linux.dev>; Tue, 17 Nov 2026 03:00:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794913254; x=1795518054; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5EgXDSzTP2vn8ES7tici+mX3N/VrZpLK1Xqz+vaiFuo=;
        b=z8BxTzhCQ7kz30aWe/jZ0MMGwlie21Q3Np3/H67ykKgd9uBLzdp1/kIiKBnwOscUht
         NL9emsTCUQ0Zp33o02ryaHyatmjKmj945P4xoJoEGUOD6vvAN1OB3sd/2TQDao2Dkn8G
         kHl1e85Jt9UnE/M59Iw5RpsP3c3L36OkUAiV0u9EwpwoYZSZ5lWjqgO18ajuszyXr82I
         TXbJTlxGW/8u3YnQCH9jHWuQ1jo1U1eesydIiVNMZx1isK6iafWGU1zxD5TXx/FXmW4A
         7na936wmd2jaECK1tA7gBHa90v7P5fILkjhrKNdhP0lLG9u8JIXEJ5Py92OruDSjbiL9
         rBIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794913254; x=1795518054;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=5EgXDSzTP2vn8ES7tici+mX3N/VrZpLK1Xqz+vaiFuo=;
        b=xJ2GeXr9dluJ9iWS1FE78UF6ZplE2e5KWZkFjUI4adcW4Ge2X3r7nDVv1apzFqoqFk
         r/QpuQbSs2lOLVOMMVAR5CA15ST6ZUAFSCBJzWm1jRF3wAPMW2VUcssNHYV5XOYkrQyd
         H4uTjbUSq7lfrW8wNjl293MjooTTR/PEwzUFBBbtBgLkbjAR3J4NHsZh6SqkzPK4pYKu
         jsNwt176kBMiDMkhNljlYre7Dz+wdxTmPZuGTw3HL5+4c58H1at9InX1SprAjWJRVxnH
         LCkIccIlbaBCnPbFmCDo2pMcts6aqr0deOiovMwQ1+bZnnhYWepsfaIcwL7dc4WCbi3/
         M7nA==
X-Gm-Message-State: APuU4Z+uHqm4bEQ/tIqt6SWkoSQ0sVny2p2lTH0bFCearoMR0EMC0WOi
	SXidN9UBrggxtaYWbafoQD5HxA4lNQ1leJaknSiVqBMIqqmoI3Ga0Sq0hIukBSj5hsmqfg==
X-Gm-Gg: AYBFou2mVZf+Mu710cLdqjeokGKlWxnIiOmdjWHw3gFkI5iTW7Q6nrvEn4LA+lGySbp
	nb5qs6G0VPbzPpAPxJVereUANKNon2l3tWB1hwklAlLYtDmq5xz7RG4q1xp8kXlr7OJpiUNNmo1
	hoiGoLDcAKsRFRJhdKgpEVhQzXcrrkYS8BTdK2p+KzmUoz52l59cXJUSOTpqm5x4CRflT6ECYOI
	sp/cL5JoVCrn+lXtz01L5RMXgNnj87UREXxnbkldDvNoES+BmS4z307qiq83/K3rh7gMPnTg/ds
	1EF5IpNFQEOgileaVlkiGvKKSbmjvDzOWBrv8T3+IBRS0oPdTao0If55AtN9M/Um1W4+CQsKQRP
	3jSEY9g3esl6ecaAjhfyMuWNe1OWq1t8EQqikR2xu4nrQr96bgYRz6TCklMqjQSge7E2Xpongpr
	qlk0CjsaKMDOltJqn3fzFFAaJAO4gBJv1AhNEOJGChXlz3jok8xBvupZ3ETCvxlDeu7Le2UnzRA
	SZ2fCANByPM3fS2XHp9QnKrhVpEyzgqGuz/hH842LBkFxaCrtG5/AHQr6C4H30vE/1a0gin3vuB
	ztQCkcU5R4xYZCmfVYw9yvu67uCcvWAOxCMgmdoq1T6lsZsTvJUgVQwiJuTV+jOBkSjWxK2aWxx
	KU6C97En9+vxBT2LwGCaQpJRk++rJIczzZwsyN/fxhqAc9FGmrnHMesT5d1r8g42Bl/6mPkDgjW
	EDpW0IqU0CPP++ukvLbqmu7cSM2YcKwLoD8+vxwXCuAU5+rXQkvbhgwtgnjIXpR6WW
X-Received: by 2002:a17:907:8e98:b0:c48:9228:bdcb with SMTP id a640c23a62f3a-c509614e920mr1283335466b.3.1794913253960;
        Tue, 17 Nov 2026 03:00:53 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b58b66sm525371966b.50.2026.11.17.03.00.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 17 Nov 2026 03:00:53 -0800 (PST)
Message-ID: <3455139e-ca1a-4a9c-be76-9b93d17409bd@gmail.com>
Date: Tue, 17 Nov 2026 12:00:52 +0100
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
Subject: Re: [PATCH RFC v3] net/x25: fix invalid lock_sock() usage in
 x25_kill_by_neigh()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <7896865a-72bb-4375-9512-575f36952430@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <7896865a-72bb-4375-9512-575f36952430@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/13/26 16:53, syzbot wrote:
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
> Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by x25_disconnect")
> Assisted-by: Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+300375dfd44665f063a6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=300375dfd44665f063a6
> Link: https://syzkaller.appspot.com/ai_job?id=2e7bbf89-6757-4df2-a7f2-bdd34917d974
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
> v3:
> - Check that x25->neighbour is non-NULL in x25_release_cb() before calling x25_disconnect()
> - Remove duplicate wrapped Fixes tag from the commit description
> 
> v2:
> - Pass a boolean parameter to x25_kill_by_neigh() and x25_link_terminated() to distinguish softirq from process context.
> - Retain lock_sock() in process context to preserve synchronous socket teardown for netdevice notifications.
> - Retain write_lock_bh() on x25_list_lock instead of manually managing local_bh_disable().
> - Shorten the commit description by removing stack traces and per-function details.
> - Fix line wrapping in the Fixes tag.
> https://lore.kernel.org/all/b624bc4d-6240-4c80-82a8-c727545f2a5e@mail.kernel.org/T/
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
> index f45c9ec7d..6b664e04d 100644
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
> @@ -492,10 +492,20 @@ static int x25_listen(struct socket *sock, int backlog)
>  	return rc;
>  }
>  
> +static void x25_release_cb(struct sock *sk)
> +{
> +	struct x25_sock *x25 = x25_sk(sk);
> +
> +	if (test_and_clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags) &&
> +	    x25->neighbour)
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
> @@ -610,6 +620,7 @@ static struct sock *x25_make_new(struct sock *osk)
>  	x25->cudmatchlength = ox25->cudmatchlength;
>  
>  	clear_bit(X25_INTERRUPT_FLAG, &x25->flags);
> +	clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags);
>  	x25_init_timers(sk);
>  out:
>  	return sk;
> @@ -827,6 +838,7 @@ static int x25_connect(struct socket *sock, struct sockaddr_unsized *uaddr,
>  		x25->neighbour = NULL;
>  		read_unlock_bh(&x25_list_lock);
>  		x25->state = X25_STATE_0;
> +		clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags);
>  	}
>  out_put_route:
>  	x25_route_put(rt);
> @@ -1761,7 +1773,7 @@ static struct notifier_block x25_dev_notifier = {
>  	.notifier_call = x25_device_event,
>  };
>  
> -void x25_kill_by_neigh(struct x25_neigh *nb)
> +void x25_kill_by_neigh(struct x25_neigh *nb, bool bh)
>  {
>  	struct sock *s;
>  
> @@ -1769,13 +1781,28 @@ void x25_kill_by_neigh(struct x25_neigh *nb)
>  	write_lock_bh(&x25_list_lock);
>  
>  	sk_for_each(s, &x25_list) {
> -		if (x25_sk(s)->neighbour == nb) {
> +		if (x25_sk(s)->neighbour == nb &&
> +		    (!bh ||
> +		     !test_bit(X25_KILL_BY_NEIGH_FLAG, &x25_sk(s)->flags))) {
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
Please keep the design and the behavior of this version and make a few
small changes to the code and to the commit message.

Give the arguments of the two changed prototypes in include/net/x25.h
names, for example "struct x25_neigh *nb, bool bh" for both
x25_kill_by_neigh() and x25_link_terminated(). checkpatch --strict
warns about unnamed arguments in new prototypes, even though the older
prototypes in that header have none.

Add a short comment above x25_kill_by_neigh() and one above
x25_release_cb(). The first should say that the receive path runs in
softirq and must not wait for a task that owns the socket, and that the
netdevice notifier must wait for every owner, because
x25_link_device_down() drops the device reference of the neighbour on
NETDEV_UNREGISTER. The second should say that release_sock() calls it
with the socket spinlock held while the task still owns the socket, so
x25->neighbour cannot change during the check.

The clear_bit() calls in x25_disconnect() and in the error path of
x25_connect() can go. x25_release_cb() already does nothing when the
socket no longer uses a neighbour, so they do not change behavior, and
without them x25_subr.c stays untouched. Keep the clear_bit() in
x25_make_new().

Please also replace the body of the commit message with a more exact
one and keep the subject line. hdlc_x25 delivers its frames from a
tasklet, so "(NET_RX_SOFTIRQ)" is too narrow. The sockets hold
neighbour references and reach the net_device only through the
neighbour, and "owned by user space" means owned by a task through
lock_sock(). For example:

  x25_kill_by_neigh() clears the calls of all sockets on a neighbour
  whose link went down or was restarted. The netdevice notifier calls
  it in process context, but the receive path calls it in softirq:
  lapbether (NAPI) and hdlc_x25 (tasklet) deliver X25_IFACE_DISCONNECT
  and restart packets to x25_lapb_receive_frame(). The lock_sock()
  taken there since commit 7781607938c8 ("net/x25: Fix null-ptr-deref
  caused by x25_disconnect") may sleep, so lockdep reports an
  inconsistent lock state for sk_lock-AF_X25, and the softirq schedules
  when a task owns the socket.

  Pass the calling context to x25_kill_by_neigh() and
  x25_link_terminated(). The notifier keeps lock_sock() and waits for
  every owner, because x25_link_device_down() drops the device
  reference of the neighbour on NETDEV_UNREGISTER, so no socket may
  still use the neighbour after NETDEV_DOWN. The receive path takes
  bh_lock_sock() and clears the call at once when no task owns the
  socket. Otherwise it sets X25_KILL_BY_NEIGH_FLAG, and
  x25_release_cb() clears the call when the owner releases the socket
  and the socket still uses a neighbour.

Leave the rest of the diff as it is.


-- 
Krystian Kaniewski
