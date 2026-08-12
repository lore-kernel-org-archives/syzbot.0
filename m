Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D95543E06F
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 12:57:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786539441; cv=pass; b=UzGhQT2nw6H1olzCqAjw+V8tPPaG0yXzZTCfrBAtfncrE3kKICoiBcAqWvpeBrmRlAwQx5J5lg3GlLq64qNTJcIJ8HZULbC72lV0pmLFlv1bbc4iuxlM/yMet4dGVEIxdEgIWeQ8ZU65hrUmk09YFNtGKeJ9CYny7qFk5KZlIkM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786539441; c=relaxed/simple;
	bh=w2o6HAU4IabSmwbYcrqi6iKY8+yvSiUpfiKdXsUfSDQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Zhuj0aAEtKyiYvYQbVepv4CSBcqUx29m3auQt5ktoO7brrsvdAYvOzqYV4VKgSlyazf4onoJE97wd0ydPLcezyRkJte0cbj5haTI733aYuUwMSHaqVptwibSBD25DU8mFEkAPalQVvAQ/E2Svc+//2gYcHny4v61qtzvcKYCHIs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CV6P62gt; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CV6P62gt"
Received: by smtp.kernel.org (Postfix)
	id A82C41F00A3F; Wed, 12 Aug 2026 12:57:13 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.128.50
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786539433;
	b=OkWMBKIQjqsjnfwYNb3UAsCksQL6ZB+gVFs4qQIbQ/N9ogQGedCDOuVFpP0h4Qm41GB9
	 U/P/VGNFG1R5GxBWfA6rKcYiulp2s0FMxnRtFV01946kPQCfV5eHMTUIfscAqRssQigQn
	 D5rpJ5vV6wwCBUw61Hz6yxZv1KlLRCNiro+vIk15F0vA3TVerqixVI/12i1UgzE7X091k
	 eFy3GLXOjdPD9NqsFuwv0Pt9RKUbvG5W2bwm1WJLIRVDbMZdJ2RAUb43uEwON8pVf4PtQ
	 hpOKgto879NWy+sfh1w/MhS5mjaW+mmVhk4RgqVJcT9MyeUTahgLCqONCiy02264PgQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786539433;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=0Xdcq6MVgyxoeA2pFYQFhfUc4iKzuSxTQMIh1GnLgUc=;
	b=pdpOzf+NqXdN0Frzn1uG9jZXud0KYhxErh6DR/wAuB8dLJ/4XzncQ7g5t9diap8Gt9FF
	 EkGoQhgfI8hCZI+M4jrto0dHaTEKKgq+YRFkfADv0nGUf4bbzLy4q4g8Cyx8tBUDsF5kO
	 WpG8f89UVFdIQMA5L6sHyW5NYb0huJyCYle/5RJBwqRWCxQ94AJapvKu/s4IJQ8E2kQlL
	 nW3Rr37mHE2WEeSyIl5tXcYs2CL/M+2AHQzMq6V9MNPwpoY4LiZUlkBJOqLwbgoM3gRaM
	 Q3q9DBZHp/Mx+3Pd29hVSCysAFp35PYZ1XpVlVF9HDEj66RPPCDBGe2cxIe2OriGHMg==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CV6P62gt;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.128.50
Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 021651F00A3D
	for <syzbot@kernel.org>; Wed, 12 Aug 2026 12:57:12 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=CV6P62gt
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 021651F00A3D
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-495590dde14so11388995e9.0
        for <syzbot@kernel.org>; Wed, 12 Aug 2026 05:57:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786539431; x=1787144231; darn=kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0Xdcq6MVgyxoeA2pFYQFhfUc4iKzuSxTQMIh1GnLgUc=;
        b=CV6P62gtkMJDmn5q+mixnOlCMXkIkY5eO7xhxtgGLOS8aFgvyi1uBQV3EjVTrQgOQe
         xmtzVgo2BmEKoT+CnR8I2sUppJT5IKmePIyLIcKZwZbvHZJ0gY4YHxOoFj4txcjq6LIa
         +pPXSFp1lHGg8gWIZUm32LCcLP7eLyqjABxTmoZOiinW2nWu3wRU0fZMAJCWiFUMAdoi
         3Kt4cFikCGquiOhYCbOFEC/Sujup0mmObxy2NWsdB7aMrznmO0u680+WXHywr0Cha8x1
         4toKJvn8cYxskvXt9doa8RVD2MvvsclMhhPOaiexGyTUiLYRxrjbcTiIR5HqgoYrt8Uw
         cbmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786539431; x=1787144231;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0Xdcq6MVgyxoeA2pFYQFhfUc4iKzuSxTQMIh1GnLgUc=;
        b=UPFX0IEkOHTrs4RDAXdxG6qqVVD+zT1k3ZnNv9/LYp/w7emwijkptl81dNE/WeOuJM
         vnXnv5AzHJPIXThoAGPS185Tm6b7uFxVqQ1od3L8++Za+qg3ZxMSxcHvYQDAkw5tY7gY
         QM+lafISbI2FIOPq03SgEywnVqjhKE3Js2Ni5Ql6k8/l1tdyEPEtFzgQqfBCrdabcok7
         2b/hiW8T2jTVlDo9JSw8oqmjoRxLdeDDfJRJo4E9uWkBZxHC9V2nagy3KetL0d9pgYwK
         f7NR3KRiA9q6LjBkZ1f/5B1+VMesFkq8tXX5FBTrMm4ZWqiC/hJ/Oj0ZMbkcBj931iF7
         iKeg==
X-Gm-Message-State: AOJu0YyiACMMq88gOYYvmh8S/Evd48nU+pWIAczIoKeRpulsFePSACSi
	43UjhJWmrSo5CdI9exwS9OOm3xMNfmVZCRYbCqU0i/5T453LTWnOQj4l0BJLoF3jUJ4=
X-Gm-Gg: AR+sD11+P0X20VoI6HCN/zNn6rSXVEfW2F135jkU9kMPsnm/IxndED0iAGTUV1DlwRp
	xHTQiEo5qWN64khkYIbuUpj2ClENf38u2B4RlY5sRGY1y9oqV5d8NndJqzDyhzXkipIu40bfWbn
	j8dyK6lM5XlGThvZU9VvDBW5iWvB/MGO3guFGHDEC96LRAUrNrQG6CoZNkcLh1emSHYIaQOzIef
	/Z908/Qdz0ZwZRf3uTE1Q7cbiIZyCNAojhPq2cEjASPSo7qFk2Jynqfo1iUzmJuwIHNeIrQ6cGQ
	Iq/DBmPqQkzmfPYIYfd9qPPiZKkQTBMDCvtUrrI/1tv2ptsYg/Gnd9ZNMijqtA2B06+TN2WanaD
	O84UqmorPAEf7L8CCOdsxFTRPkPmmTwYqybTyEklj5TQVrxPeH6Mr0p6bZ4zuvnGuIvV5mOo5Ln
	N0+o3huAGnJm/niU26sxCqH5c73+43nRua1cnZaz24mIQn9/gAXwaENZlkmryPypFgUzCVU6Ue9
	d+bqk6Hkc1i/2c=
X-Received: by 2002:a05:600c:3b19:b0:493:e983:806e with SMTP id 5b1f17b1804b1-4997c0f7575mr63956085e9.3.1786539431263;
        Wed, 12 Aug 2026 05:57:11 -0700 (PDT)
Received: from localhost ([37.30.50.141])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4997c939750sm47222165e9.3.2026.08.12.05.57.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 12 Aug 2026 05:57:10 -0700 (PDT)
Date: Wed, 12 Aug 2026 14:57:10 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v4] tipc: defer local Nagle backlog xmit from receive
 path
Message-ID: <7vvzkty5ambykmo3ywwp5uz5rf5tfj6bnrz37u7y34o2xj52uq@dnbeuprc77d2>
References: <ff6d3f6a-6d4e-4927-83f7-a718982a55ab@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ff6d3f6a-6d4e-4927-83f7-a718982a55ab@mail.kernel.org>

#syz upstream

On Fri, Aug 07, 2026 at 04:36:56PM +0000, syzbot wrote:
> A local TIPC stream socket workload can trap a CPU in an endless receive
> loop. The resulting soft lockup can make the system unavailable.
> 
> tipc_sk_push_backlog() can transmit delayed stream data while tipc_sk_rcv()
> holds a destination socket's sk_lock.slock. Own-node transmission enters
> tipc_sk_rcv() synchronously. A reply that reaches the ancestor socket
> cannot acquire the still-held lock, and tipc_sk_rcv() retries without
> consuming its input queue.
> 
> Pass the receive output queue to tipc_sk_push_backlog() from receive-side
> callers. Queue own-node output there so the enclosing receive path sends it
> after releasing the socket lock. Keep shutdown and remote-node transmission
> on the existing direct path, preserving remote link congestion handling.
> 
> Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+10a41dc44eef71aa9450@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=10a41dc44eef71aa9450
> Link: https://syzkaller.appspot.com/ai_job?id=aa2dc129-33d3-42e7-bd0b-bf2198c9c9c2
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Jon Maloy" <jmaloy@redhat.com>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> To: <tipc-discussion@lists.sourceforge.net>
> To: "Jon Maloy" <jon.maloy@ericsson.com>
> Cc: "Simon Horman" <horms@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v4:
> - Added kernel-doc documentation for the new xmitq parameter of tipc_sk_push_backlog()
> 
> v3:
> - Updated the commit subject to 'tipc: defer local Nagle backlog xmit from receive path'
> - Simplified the commit description by removing the detailed eleven-step execution narrative and the full call trace.
> https://lore.kernel.org/all/e5b4f184-4cf0-4891-9623-526d3dbf5a12@mail.kernel.org/T/
> 
> v2:
> - Only defer transmission in tipc_sk_push_backlog() if the destination is on the own node.
> - Update the commit description to clarify that deferral is only needed for own-node destinations.
> https://lore.kernel.org/all/368f7232-39e9-424c-9683-0c28db1151af@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/01641937-e30d-43dd-ba9c-95b3d2ae5691@mail.kernel.org/T/
> ---
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index e564341e0..33d744dc5 100644
> --- a/net/tipc/socket.c
> +++ b/net/tipc/socket.c
> @@ -156,7 +156,8 @@ static int tipc_sk_insert(struct tipc_sock *tsk);
>  static void tipc_sk_remove(struct tipc_sock *tsk);
>  static int __tipc_sendstream(struct socket *sock, struct msghdr *m, size_t dsz);
>  static int __tipc_sendmsg(struct socket *sock, struct msghdr *m, size_t dsz);
> -static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack);
> +static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack,
> +				 struct sk_buff_head *xmitq);
>  static int tipc_wait_for_connect(struct socket *sock, long *timeo_p);
>  
>  static const struct proto_ops packet_ops;
> @@ -560,7 +561,7 @@ static void __tipc_shutdown(struct socket *sock, int error)
>  					    !tsk_conn_cong(tsk)));
>  
>  	/* Push out delayed messages if in Nagle mode */
> -	tipc_sk_push_backlog(tsk, false);
> +	tipc_sk_push_backlog(tsk, false, NULL);
>  	/* Remove pending SYN */
>  	__skb_queue_purge(&sk->sk_write_queue);
>  
> @@ -1267,8 +1268,10 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
>  
>  /* tipc_sk_push_backlog(): send accumulated buffers in socket write queue
>   *                         when socket is in Nagle mode
> + * @xmitq: receive output queue, or NULL outside receive context
>   */
> -static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack)
> +static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack,
> +				 struct sk_buff_head *xmitq)
>  {
>  	struct sk_buff_head *txq = &tsk->sk.sk_write_queue;
>  	struct sk_buff *skb = skb_peek_tail(txq);
> @@ -1310,6 +1313,12 @@ static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack)
>  		tsk->pkt_cnt += skb_queue_len(txq);
>  	tsk->snt_unacked += tsk->snd_backlog;
>  	tsk->snd_backlog = 0;
> +
> +	if (xmitq && in_own_node(net, dnode)) {
> +		skb_queue_splice_tail_init(txq, xmitq);
> +		return;
> +	}
> +
>  	rc = tipc_node_xmit(net, txq, dnode, tsk->portid);
>  	if (rc == -ELINKCONG)
>  		tsk->cong_link_cnt = 1;
> @@ -1367,7 +1376,7 @@ static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
>  			goto exit;
>  
>  		was_cong = tsk_conn_cong(tsk);
> -		tipc_sk_push_backlog(tsk, msg_nagle_ack(hdr));
> +		tipc_sk_push_backlog(tsk, msg_nagle_ack(hdr), xmitq);
>  		tsk->snt_unacked -= msg_conn_ack(hdr);
>  		if (tsk->peer_caps & TIPC_BLOCK_FLOWCTL)
>  			tsk->snd_win = msg_adv_win(hdr);
> @@ -2165,7 +2174,7 @@ static void tipc_sk_proto_rcv(struct sock *sk,
>  		smp_wmb();
>  		tsk->cong_link_cnt--;
>  		wakeup = true;
> -		tipc_sk_push_backlog(tsk, false);
> +		tipc_sk_push_backlog(tsk, false, xmitq);
>  		break;
>  	case GROUP_PROTOCOL:
>  		tipc_group_proto_rcv(grp, &wakeup, hdr, inputq, xmitq);
> @@ -2256,7 +2265,7 @@ static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb,
>  		return false;
>  	case TIPC_ESTABLISHED:
>  		if (!skb_queue_empty(&sk->sk_write_queue))
> -			tipc_sk_push_backlog(tsk, false);
> +			tipc_sk_push_backlog(tsk, false, xmitq);
>  		/* Accept only connection-based messages sent by peer */
>  		if (likely(con_msg && !err && pport == oport &&
>  			   pnode == onode)) {
> 
> 
> base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
> -- 
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
> 
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> The person who has signed off on the patch is responsible for
> addressing comments.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
