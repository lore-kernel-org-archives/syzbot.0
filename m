Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794318377;
	b=wc3rD/fyQa9Ho18MV3R4vHUItiX0zlxb1SSdgwoMHKUhhs9/EySegIkBxOAl4dZ33qFo
	 +XZpgNFTJ0d88dG7eM001pIoXsMVHBG4BHTuw73KdPEySyk4FIV0IKByPzpGvlT0cJSPH
	 8Jzm3OroVuTQX8Afwmd2J8YZt62Axe4uJFW//rEQ+CNz7xiHOg3kxE+uP/zRGGG+9EvfP
	 8QDPSZ/iqzZATcehAcyK4kTUpbzoTwq6kv+J2imhdMdEOfRf+ANGBw437dZaJpodMgA2h
	 R1TzqQ5n/BVIOnknSKklr90OJs8cFo7F0eaJb6Zkm3dgXM+TORkQojgOJMkFGz8RpOg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794318377;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=XAVTld7XE5S57jbVu1jynVx7dQJ/Wa2rI0Zm7KV6eDM=;
	b=fHZYKNAHJWVF4bpuJzpUWbafzClFw4kqQ7XpP6NPS30mKWE7LNoo+YHOXjcYuzofWfbt
	 HbEUDqr3YA09rs8y370BTAq8EpEvgz1tmOMawHMDj6NYKKj2VgxWNkDlGIOtKHKhYUzjR
	 cuLeR0D0YC2DXcSv4uOaZkPkhDEQ3kNxPm+pAuGZpXHajYszjeQoBGlF5l0uv6iq40UDc
	 3KyK/TNWHIFN0FDy4q3N/Bj3x5+NPSX2tmE2Mtpkb++KfUAXY0u7bjpzEx3c/6AFqjZZ/
	 XA/k2pfO8O71gNE5w8ObzgtgIKrYD7xA99ZFAlpvrQ14Yn24hsB5EekuZSyJq1AqBkA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q95XS12I;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E04F606A325
	for <syzbot@lists.linux.dev>; Tue, 10 Nov 2026 13:46:16 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 8E04F606A325
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=q95XS12I
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c3f04e0e65fso295322666b.2
        for <syzbot@lists.linux.dev>; Tue, 10 Nov 2026 05:46:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794318375; x=1794923175; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=XAVTld7XE5S57jbVu1jynVx7dQJ/Wa2rI0Zm7KV6eDM=;
        b=q95XS12I1f7iltTlhmGP0pyNKJ2p2fKZ3T4A/mc/Ed/+y9B+jdKCNXCozty3j9CAfl
         putiXNX8JmXdctdXN2ThowaIJ/D3BjykFK0R03z9bWEMaBl0lqSlahJhpCiJE5k/+mrO
         s23dYe4xaf5FxT/FR1EUTsR3zcrayjJtWecdFrlyYi3FpKh1P/XkM0kA2xnTdfxoDi1l
         MLUWZPPm/iS7hVGAHKydMRCrmURF27bBtEM+BuK1ubSar4ZCFFTb7csVTiJrVO4Ssbyz
         yukU78y857to4h0OZplAZYByiJ82lrqtAy7xmgEj7vWhuP46QnQYdHnhS7jB9XWcKzEK
         emZg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794318375; x=1794923175;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=XAVTld7XE5S57jbVu1jynVx7dQJ/Wa2rI0Zm7KV6eDM=;
        b=rx+dyByqdkLDcQI29snaV9MlcqrARSKbJSMpfhOTB5ko82W/pGUHj3c1o8xsZzwElM
         JMJpvxDdO1n2SR/HLaAtypq3bjMsntjMxqi7zOrR6wA0/v4US55tdAMnX0YsBKAawR+g
         V1nAJQ8ZqC5oJLlfF1+1C0If53XSuxgCs4HZdzMgYrKvh65sd7EIrk0mUMC+CEyV6p49
         Lnwz+9b+nOKydTImPgeEbRQfSPejSsGcyb8FfB7o4cYlm8Tges+NMGOunzTQFXrznZ2E
         DWxl0aL+TuNrjsb3/DsmknINx7IHV+V7aSBt7pBpjvd99shEELhRqvPtb7THXe6bbRy7
         F44w==
X-Gm-Message-State: APuU4Z9c94+QFearntHZ4HnYrnDzRiLDgyq2gizV7C5fM+fOUvoHEgzK
	uaFEmGyasdAPvhoZt58ylljg2xJB4zbk75a33VJVFBTicvkHWnAYrVIE
X-Gm-Gg: AYBFou2mCYO57Ez7ZyytpxqyBisYkJfhhspvhi2mKrt/oyQq+w8sU9Fiwb3vJpxD7AO
	9kljxEP4lzI7l1ayseSrHiswJQG5nZbz+PRL8rkvJRZLmzYVlm+4I1vcs4tiSDK5Ea0aOmxeF5I
	lfGAIcn5LxPGxC8ePIH4BxHbvye+u6DUkehJtZxSYn5+aRFxMtRzvETragWsbwqiJXkYRQBowEJ
	zhyu73yAtOYj4RcXOJdmxVE+7Dln0blY3MWd/24vM21GumCpyeWCQF2h2ZkAyz5SLwKu9m3q2t+
	hKixF+iZeLbA+MXb1v8nk6kQjiM6z/MuznqukZQ8ju4YnR25+XKdwEnpNCsy2smaZBK0Ncx+dFP
	SsKuKIZIXBr2Xw0iZ3zd5TfZL6Zpmew6ctexirynFs4wAdBcHFbB8H9bssUKbvTm0VdquEtm4su
	R9fWDIZcNy2PNY1HZU+jbgkpw1RUzV6WdnV5+UZzUqKTTiOoXcZiS00i4v0E9eJcHemwXYe01HT
	WWfgynCVwFWRPE2uoAjeBbJSZfUX7WsQxr/L8TIlzA5Kxl7rnKPTM8ioUIk1UiAmQMFiXMOKDWb
	paLnFQwHeHMlei/SqBJbPxa9HBvERwkyZvb88evjaBfQXZZEpYgsX0lFg/yxEHlgOMMkbV9Y3xz
	hFvuoXzOq9/0wz3CjCA5s6rAmS2pPh/qBa3ADW537c6pSJakFlXVcRnc3YpAvjo7P9eGFFqyYd9
	+v2FFc0heM3rGpxafljYK58Gr0UCqdbXDhDzbUSiUtya8KiCj9Zg+LgOtuQDcLzZ4u
X-Received: by 2002:a17:906:1412:b0:c26:19de:9126 with SMTP id a640c23a62f3a-c504955510cmr163117466b.25.1794318374678;
        Tue, 10 Nov 2026 05:46:14 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c504a6799c7sm108199166b.75.2026.11.10.05.46.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 10 Nov 2026 05:46:14 -0800 (PST)
Message-ID: <4f54c20c-e7d7-4ef6-be26-f38b4fb7e609@gmail.com>
Date: Tue, 10 Nov 2026 14:46:12 +0100
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
Subject: Re: [PATCH RFC] net/x25: fix invalid lock_sock() usage in
 x25_kill_by_neigh()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <f1cbebc5-aab9-44ac-8425-1bc9fdbbf5b7@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <f1cbebc5-aab9-44ac-8425-1bc9fdbbf5b7@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/5/26 00:27, syzbot wrote:
> x25_kill_by_neigh() is invoked to tear down X.25 sockets associated with a
> terminating neighbour. This function is called in process context from
> netdevice notifier handlers (such as NETDEV_DOWN in x25_device_event()),
> but it is also called in softirq context (NET_RX_SOFTIRQ) under
> rcu_read_lock() when receiving LAPB frames in x25_lapb_receive_frame() (for
> instance upon receiving an X25_IFACE_DISCONNECT frame or restart
> request/confirm packets via lapbeth_napi_poll() ->
> netif_receive_skb_core()).
> 
> x25_kill_by_neigh() acquires lock_sock(s) around x25_disconnect(). Because
> lock_sock() is a sleeping lock that can block in process context and calls
> might_sleep(), calling it from softirq context triggers a "BUG: sleeping
> function called from invalid context". Furthermore, lockdep reports an
> inconsistent lock state warning ({SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W}) on
> sk_lock-AF_X25 because the socket lock is normally acquired with softirqs
> enabled in process context (e.g. in x25_bind()), creating a deadlock hazard
> if a softirq interrupts a task holding lock_sock().
> 
> WARNING: inconsistent lock state
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
> ffff888030a28260 (sk_lock-AF_X25){+.?.}-{0:0}, at:
> x25_kill_by_neigh+0x10d/0x250 net/x25/af_x25.c:1775
> {SOFTIRQ-ON-W} state was registered at:
>   lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
>   lock_sock_nested+0x41/0x100 net/core/sock.c:3908
>   x25_bind+0x209/0x450 net/x25/af_x25.c:691
> ...
> Call Trace:
>  <IRQ>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_usage_bug+0x28c/0x2e0 kernel/locking/lockdep.c:4086
>  mark_lock_irq+0x36/0x380 kernel/locking/lockdep.c:4311
>  __lock_acquire+0x71e/0x2de0 kernel/locking/lockdep.c:5242
>  lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5942
>  lock_sock_nested+0x41/0x100 net/core/sock.c:3908
>  x25_kill_by_neigh+0x10d/0x250 net/x25/af_x25.c:1775
>  x25_lapb_receive_frame+0x1b0/0xf90 net/x25/x25_dev.c:138
>  netif_receive_skb_core+0x2a6/0x2b0 net/core/dev.c:6458
>  lapbeth_napi_poll+0x42/0x90 drivers/net/wan/lapbether.c:100
> ...
>  </IRQ>
> 
> BUG: sleeping function called from invalid context at net/core/sock.c:3910
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/0
> preempt_count: 101, expected: 0
> RCU nest depth: 1, expected: 0
> Call Trace:
>  <IRQ>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x36a/0x4c0 kernel/sched/core.c:9195
>  lock_sock_nested+0x56/0x100 net/core/sock.c:3910
>  x25_kill_by_neigh+0x10d/0x250 net/x25/af_x25.c:1775
>  x25_lapb_receive_frame+0x1b0/0xf90 net/x25/x25_dev.c:138
>  netif_receive_skb_core+0x2a6/0x2b0 net/core/dev.c:6458
>  lapbeth_napi_poll+0x42/0x90 drivers/net/wan/lapbether.c:100
> ...
>  </IRQ>
> 
> Fix the issue by replacing lock_sock() / release_sock() in
> x25_kill_by_neigh() with bh_lock_sock() / bh_unlock_sock(). Disable bottom
> halves around the list traversal with local_bh_disable() /
> local_bh_enable() and use write_lock() / write_unlock() on x25_list_lock so
> that bottom halves remain disabled across bh_lock_sock() even when called
> from process context, preventing lockdep warnings on slock-AF_X25. Release
> x25_list_lock before acquiring bh_lock_sock() to respect existing lock
> ordering.
> 
> If the socket is owned by a user process (sock_owned_by_user(s)),
> disconnect cannot proceed immediately under bh_lock_sock(). Set a new
> X25_KILL_BY_NEIGH_FLAG flag on the socket and implement x25_release_cb() in
> x25_proto so that the disconnect is deferred until release_sock() is called
> by the user process. Skip sockets with X25_KILL_BY_NEIGH_FLAG set in
> x25_kill_by_neigh() to prevent spinning on user-owned sockets when
> restarting the list walk. Finally, clear X25_KILL_BY_NEIGH_FLAG in
> x25_disconnect(), x25_make_new(), and the error path of x25_connect().
> 
> Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by
> x25_disconnect")
> 
> Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by x25_disconnect")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+300375dfd44665f063a6@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=300375dfd44665f063a6
> Link: https://syzkaller.appspot.com/ai_job?id=3a4b062a-3ad2-4806-a87d-55983041acda
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
> diff --git a/include/net/x25.h b/include/net/x25.h
> index 414f3fd99..c271fc2a7 100644
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
> diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
> index f45c9ec7d..e24900a75 100644
> --- a/net/x25/af_x25.c
> +++ b/net/x25/af_x25.c
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
> -	.name	  = "X25",
> -	.owner	  = THIS_MODULE,
> -	.obj_size = sizeof(struct x25_sock),
> +	.name	    = "X25",
> +	.owner	    = THIS_MODULE,
> +	.obj_size   = sizeof(struct x25_sock),
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
> @@ -1765,22 +1774,30 @@ void x25_kill_by_neigh(struct x25_neigh *nb)
>  {
>  	struct sock *s;
>  
> +	local_bh_disable();
>  again:
> -	write_lock_bh(&x25_list_lock);
> +	write_lock(&x25_list_lock);
>  
>  	sk_for_each(s, &x25_list) {
> -		if (x25_sk(s)->neighbour == nb) {
> +		if (x25_sk(s)->neighbour == nb &&
> +		    !test_bit(X25_KILL_BY_NEIGH_FLAG, &x25_sk(s)->flags)) {
>  			sock_hold(s);
> -			write_unlock_bh(&x25_list_lock);
> -			lock_sock(s);
> -			if (x25_sk(s)->neighbour == nb)
> -				x25_disconnect(s, ENETUNREACH, 0, 0);
> -			release_sock(s);
> +			write_unlock(&x25_list_lock);
> +			bh_lock_sock(s);
> +			if (x25_sk(s)->neighbour == nb) {
> +				if (sock_owned_by_user(s))
> +					set_bit(X25_KILL_BY_NEIGH_FLAG,
> +						&x25_sk(s)->flags);
> +				else
> +					x25_disconnect(s, ENETUNREACH, 0, 0);
> +			}
> +			bh_unlock_sock(s);
>  			sock_put(s);
>  			goto again;
>  		}
>  	}
> -	write_unlock_bh(&x25_list_lock);
> +	write_unlock(&x25_list_lock);
> +	local_bh_enable();
>  
>  	/* Remove any related forwards */
>  	x25_clear_forward_by_dev(nb->dev);
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
Please keep the netdevice notifier path on the blocking socket-lock walk and
use the bottom-half-safe walk with deferred disconnect only for the packet
receive paths. This version sends `NETDEV_DOWN` and `NETDEV_CHANGE` without
carrier through the non-waiting form too. When a task owns an X.25 socket,
the notifier sets the pending flag and returns while the socket still points
to its neighbour.

The notifier has to wait for every owner. At `NETDEV_UNREGISTER`,
`x25_link_device_down()` removes the neighbour from its list and drops the
device reference even if sockets still hold neighbour references. The posted
patch can therefore leave `x25->neighbour->dev` reachable after the
`net_device` is freed. A read of `/proc/net/x25/socket` then uses the freed
device in `x25_seq_socket_show()`, and a later transmit can use it through
`x25_establish_link()` or `x25_send_frame()`.

Pass the calling context to `x25_kill_by_neigh()` and
`x25_link_terminated()`. Keep `lock_sock()`, the neighbour recheck and the
synchronous disconnect for `x25_device_event()`. Use `bh_lock_sock()`, the
pending flag and `x25_release_cb()` only from `x25_lapb_receive_frame()` and
the restart cases in `x25_link_control()`. Do not skip a pending socket in
the notifier walk, so an earlier softirq event cannot weaken its wait.

While revising the patch, shorten the commit message. Remove the copied stack
traces, the duplicate or wrapped `Fixes` text and the per-function change
list. Keep the explanation of both calling contexts, deferred disconnect and
the notifier lifetime guarantee. Avoid re-indenting existing `x25_proto`
initializer lines that do not otherwise change.

-- 
Krystian Kaniewski
