Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1795167783;
	b=WOqNJbjwvUdFfIxT+rk5m+W82TElO/y8j6wAwMhfRJ6M44OvZZg+Z/GhoFX8Gy2ED5ga
	 ePf+Ld4W6m5eyhhfELIayW0iNl9IaLh/It1dluHjARMUGJuqTLVCGrwP1XHxgsUsjmrMM
	 cO7vho4iFNbLVTtHbfhtelqXx6iSbxnhWWH7MeLD0gpVU+4jLXZkpotp+eUBkzG83Fbh9
	 C56afJQKjam1hy4Wtp6Up0atLic1bVnQqukt8pt8+tpcAQsPASOWedADruYKsFgqDp4UG
	 q/7M76X+qoKK/TN3UYV9wwW3e+f+1osqYjJhE1fBYH5BEV4MkqJrJgOt7sTY1W4o4sg==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795167783;
	h=Received:Delivered-To:Received:DMARC-Filter:Received:DKIM-Signature:
	 X-Google-DKIM-Signature:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 Received:Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:
	 References:Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=FBXAtOr9z4inWcbvUAvUsG9oRzwpXGWjhgqsmVVDnAM=;
	b=obCvX5h6hEbwe5rRZJTA3q+Q9v+nVpzMhrKzpgNNwEJe+ToQdML06FyGlUGkTYs45Njj
	 /179ybJJz9hDgfLN47r6Af6cAT6Cgb3Fh88BI54LPkQK+cr8CXdp9Kwd2BSd3M+S4MxJC
	 IFHHfP508P24NJnXNoXqGb0NlyW60fKyCz4nWDISMbvrZwmJF0MZYtSpuJ+9+Pht3OMd7
	 RjcD/ZrSGwf5nXFRoMoRxyS79G8I25CaggTTjKDKMH+lrRjXhRhgznVr3WGoAEyGDt5NT
	 31exJqFh/VE9ryltbLHlSxVkCINf0OuLd7Kel7HSykkP9JEquqSMSYcusPOXEv0CM9A==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a6GfGH0g;
	arc=pass header.oldest-pass=0 smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 391A6606A330
	for <syzbot@lists.linux.dev>; Fri, 20 Nov 2026 09:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a6GfGH0g
Received: by smtp.kernel.org (Postfix)
	id 2A5701F000C4; Fri, 20 Nov 2026 09:43:03 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1795167783;
	b=JaTnmAp6OifMoTQTX1frYRlMiowIh6eReGeHppjnKs295o/FoJF+ghbkyf57VDFML9sl
	 LGopPJ21daxi6lRdRhGJiNvs4JEP4IyIh86juvZ7Qz6Bke5IRB4iHxyWnFMtp8TMQfbbM
	 dFCtQo0Ln4GT5mMvDrO34zF57X1PrjpUj8zANcenCKIr1otuYnBjdlnuHbWW3/UTdEUZr
	 sy60zEeFKGECbMIDvClt9tTVLcLGHN5s2BHDc5urtzNVGTVrG5o5wlmL17bZreZcwOxeV
	 s/ZhIjT3H3nNO/3p2zXOiMHyGCtzGeH0BeqViv73iYxulf0SIpyNKZ0Zx1BbpAcfenQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1795167783;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=FBXAtOr9z4inWcbvUAvUsG9oRzwpXGWjhgqsmVVDnAM=;
	b=uPN5pONoabUaRd8g+dVvNSXnhd+ool6bTTZPnPHuh07TbXe3PO/S3TOh4sVGnqE7dTFI
	 GF9Vxv3Aa5orjGSutY4TSh7+HwzRooWH4GRGTFSgp3oMyjH+s0nEyH6pWyhYP/56fYTfk
	 6wqdtf4r7Pnp9Y6xAZzh0dOTnpMzY1M5buZ18qMyyF3rHuqxnd+So447CkrTqZ2EIDV6v
	 nv1KdUQWDETe6lkC461n1HDvSw7qgSxTrvZtNFST8v2mVrq/0RGWxuj0IVWTl4+h9NBqc
	 lvNoIzngghJzJs97ue6IfyG2avsG91c5EiBCKIOhKyBhwXLH7JH3AKxOQeWOQKeWjUA==
ARC-Authentication-Results: i=1; smtp.kernel.org; 
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a6GfGH0g;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 311F51F000CA
	for <syzbot@kernel.org>; Fri, 20 Nov 2026 09:43:01 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=a6GfGH0g
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 311F51F000CA
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4d5b2db4bbso158822566b.0
        for <syzbot@kernel.org>; Fri, 20 Nov 2026 01:43:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795167780; x=1795772580; darn=kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FBXAtOr9z4inWcbvUAvUsG9oRzwpXGWjhgqsmVVDnAM=;
        b=a6GfGH0g/LSM7P6wuClAjpM/Ygmb9efJWLkPbilSSWFYApfs8j3etAeMBuImBCF5s1
         D366ZarE3MHpGXa8r/mltbI7G7GglA1qLfw6j7sPgRPxg0+dl5cAAr2iUZlcta1EHueP
         B81/9zgKwGCu7wp3n6Fz6L0vC4zBHA3r/TUNRPEiZ2mzeQRRZRJUP36/73X4840tljZ/
         /y5mwL0q4L0os+PijX29umedNCHgXAM6dienfFiUbwiupozcNuScARHVXSE79E99+xPW
         pwB3RAuXe4lSzitDBjIBMW1xkvA81bdGKZbCIeEKfNwNE/hTCBdEWrewJnBvSwu6+H2L
         4UTQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795167780; x=1795772580;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=FBXAtOr9z4inWcbvUAvUsG9oRzwpXGWjhgqsmVVDnAM=;
        b=dgVxzP9HbjPFq7ajsVGyzA/ELa8N3GsFlvNHv8UfOG1RpfMqYHqytR3vVBut2PpVZc
         ngjisWoDeInTuV2CNI7ilDVB2U1yJvnXI5RReO5/yTbmiAExvgAW0xFuf8CPrk2mZwO/
         htzUhRHszAN9CRTRNTUBmsreew+szxmHWUOkyXlpiVvdDwpLLuK9aHiFdxROFJUjG/lX
         lcE5Ft3drQZn4Q884RYwhNAD7XKshilcx4wOIsuww+0uNBXNwVEFM9eUq0t9CxBrp5PH
         BwAKiTy5prdtIyq4pEj1lCaZaxhkhOzJnV4mwh7Y7xhjXmIypZR5NPVKB5WbEVFx0mPr
         dL8Q==
X-Gm-Message-State: APuU4Z+rCNa+CJW47g8/N8qu/ssM+HHnOJJ+o0ODwAJsvm1pHr1zzG2E
	eVSazjUMy3OPQuAhwZpdsd065GBbn2FT/z4zBffeSF2mhQT1Ef51v/Zt9Fz0fhr3
X-Gm-Gg: AZFdTZc2B4yJ5XswGBNzVI6yi9dN0S0S2+vfSWuxI72iW67Kj3i0ddaNBC1QpwuzdXi
	EWrzSLfigUHTQQGaGoFzJEOTAjMB3vq88FCjomwKOOQ98jDieZoLKgjWY1cIpT+8SREA5AgN6GJ
	DnYPkmG6zTHDQMz9raNAmfrphEztImZQN5mh2VLghkdGo/tnW6BjLc+mUKupE73K5CR+Pd1lN8X
	3OmFX4fP1E75zlxpe9wb/fHOMF6L/m3kScH2R4sKmP2pf/z7cIG7Bq9fmVPFV+KtCNOSA/Tsq8Z
	slVpdENzJRkZ5wpYZdDLkP1nrG14+YF7wbvyfRY+iTg19Mokafs/k+gHW1hHaog7Xn71wloicBx
	BXWp3nisvu7UWSPAXXKQtYNymP2DTBA1hYT7Bi1W3bNo1nzMhv/lohO1ZKrlhL3IA+AN5oQC8AQ
	u+LVhJrWfGEbQmVShQNj8F6RPCqwi/P4Pii7Cw52rlM8rCDTsEIeR0ha4iiUjHX4RHAt1BTIlXR
	wRx5uJfkSh3d23w8A6nEcg/nNrfkIi31RyuDDkOyJSU8Ar+cVznXvEAqm0RplZfnP/gpbaTiw2O
	pVG/0kWGu2OyLrj4OcKcupkXrcrwe11r8wLtJkcc8bvGuzc9BXdGb1rn81cneEwZlHey9DSgMr7
	x7UDKjYk486bY7WK6bZeBNXH+72/cnu5g/z4SQmCdm1Yl8vVvczXWL0BRF7zNF90VtwKZyO8WHQ
	Jas9TbC1xqLSWTf1vE8f9/+d/lK/t6EOsHjPvuZ9DIPUn2lnOYIYNb3ZfliGRbhIQ=
X-Received: by 2002:a17:907:869f:b0:c4d:31ca:e316 with SMTP id a640c23a62f3a-c51318f0558mr371411866b.20.1795167780299;
        Fri, 20 Nov 2026 01:43:00 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513afeb9bfsm76842866b.74.2026.11.20.01.42.59
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 Nov 2026 01:42:59 -0800 (PST)
Message-ID: <9ffb15a3-9cf7-48c2-8e65-64d9a185a9ab@gmail.com>
Date: Fri, 20 Nov 2026 10:42:59 +0100
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
Subject: Re: [PATCH RFC v4] net/x25: fix invalid lock_sock() usage in
 x25_kill_by_neigh()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <1c2f0665-0964-48f2-89f0-a4cd94a97a42@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <1c2f0665-0964-48f2-89f0-a4cd94a97a42@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/17/26 14:16, syzbot wrote:
> x25_kill_by_neigh() is invoked to tear down X.25 sockets associated with a
> terminating neighbour. This function is called in process context from
> netdevice notifier handlers (such as NETDEV_DOWN in x25_device_event()),
> but it is also called in softirq context when receiving LAPB frames in
> x25_lapb_receive_frame() or link control packets in x25_link_control(), as
> both lapbether (via NAPI) and hdlc_x25 (via tasklet) deliver frames in
> softirq.
> 
> x25_kill_by_neigh() acquires lock_sock() around x25_disconnect(). Because
> lock_sock() is a sleeping lock, calling it from softirq context triggers a
> "BUG: sleeping function called from invalid context" and a lockdep
> inconsistent lock state warning ({SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W}) on
> sk_lock-AF_X25.
> 
> Fix this by passing a boolean parameter to x25_kill_by_neigh() and
> x25_link_terminated() to distinguish between process and softirq contexts.
> Sockets hold neighbour references and reach net_device only through the
> neighbour. In process context (netdevice notifiers), continue using
> lock_sock() to synchronously disconnect sockets and wait for tasks owning
> the socket, because x25_link_device_down() drops the neighbour's netdevice
> reference on NETDEV_UNREGISTER. In softirq context, use bh_lock_sock()
> instead; if the socket is currently owned by a task through lock_sock(),
> defer the disconnect by setting X25_KILL_BY_NEIGH_FLAG and handling it in
> x25_release_cb() when the socket is released.
> 
> Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by x25_disconnect")
> Assisted-by: Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+300375dfd44665f063a6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=300375dfd44665f063a6
> Link: https://syzkaller.appspot.com/ai_job?id=98a38af7-51e0-4126-afa7-b8246507da37
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
> v4:
> - Added comments above x25_release_cb() and x25_kill_by_neigh() explaining locking and device reference handling.
> - Updated commit description to clarify softirq frame delivery, device reference lifetime, and socket ownership by tasks holding lock_sock().
> 
> v3:
> - Check that x25->neighbour is non-NULL in x25_release_cb() before calling x25_disconnect()
> - Remove duplicate wrapped Fixes tag from the commit description
> https://lore.kernel.org/all/7896865a-72bb-4375-9512-575f36952430@mail.kernel.org/T/
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
> index f45c9ec7d..26a8deb82 100644
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
> @@ -492,10 +492,24 @@ static int x25_listen(struct socket *sock, int backlog)
>  	return rc;
>  }
>  
> +/*
> + * release_sock() calls this with the socket spinlock held while the task
> + * still owns the socket, so x25->neighbour cannot change during the check.
> + */
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
> @@ -610,6 +624,7 @@ static struct sock *x25_make_new(struct sock *osk)
>  	x25->cudmatchlength = ox25->cudmatchlength;
>  
>  	clear_bit(X25_INTERRUPT_FLAG, &x25->flags);
> +	clear_bit(X25_KILL_BY_NEIGH_FLAG, &x25->flags);
>  	x25_init_timers(sk);
>  out:
>  	return sk;
> @@ -1761,7 +1776,13 @@ static struct notifier_block x25_dev_notifier = {
>  	.notifier_call = x25_device_event,
>  };
>  
> -void x25_kill_by_neigh(struct x25_neigh *nb)
> +/*
> + * The receive path (bh == true) runs in softirq and must not wait for a task
> + * that owns the socket. The netdevice notifier (bh == false) must wait for
> + * every owner because x25_link_device_down() drops the device reference of the
> + * neighbour on NETDEV_UNREGISTER.
> + */
> +void x25_kill_by_neigh(struct x25_neigh *nb, bool bh)
>  {
>  	struct sock *s;
>  
> @@ -1769,13 +1790,28 @@ void x25_kill_by_neigh(struct x25_neigh *nb)
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
> 
> 
> base-commit: 6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
#syz upstream

-- 
Krystian Kaniewski
