Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 308EB36B92A
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 14:21:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786112512; cv=pass; b=GP3QUfybP7WUX72zfJ4gmbLmzm1HxkA2fJXdaMwkFB8SeTv0+Paq/qllb0yUBUbzr4UaFZuvF1RbKdfg/Fp+CT8iC1wrkEA9+jjMsldi8Yb4m63+wMXFQTDjEYZwk2EB3jP/NN7k2UX0qg5JhLf3hTKif9pDz28/y2Iqm6TXcJI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786112512; c=relaxed/simple;
	bh=7YxyMSIqm+/6jVD18aa4MHq0Ge2KvAI5GmH2tsWKqCs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sqHibxDw7AoZnb4oOwYUDvNFq+wHygw+ZKIII8llSj2BE0qkOMIbgRC3gv+z+G/mc87aCdMq+5kyqdgfZlAGvLOZ6Axu2JYjdYdXb1E2y17hfb0jhERIsEsg5y36OTqVYZ8U61LoJt3RdqRYTJ/hsDHPmOFeaSfM/jcbvlu2OfQ=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=rOq4yU26; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="rOq4yU26"
Received: by smtp.kernel.org (Postfix)
	id 2C67A1F00A3D; Fri,  7 Aug 2026 14:21:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.128.41
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786112511;
	b=YTYj0bybq1M4g5XMsKS8usqRcYs2hPrZxna0x1SJb7qh8CvhhaFlshzDU4aB6YJgUX7x
	 7OluDkUg1Ub9D9JozIf44PfBrqAsOCxY32xtAEx4CEqwWd+MqZLW17RJAQyGxcXPok3aR
	 JD2jV6srCFdCVJGBN7sm5/bBAffBNs/LgvNrBhcVL1XAzujhjpc6FVIpoY90SHtJJQyTX
	 5J1pza0xRvjEX8GKsyo02HFarjnw7DuD0hzx0Y9jXEK6VUsTZBTu0T67+ehPzhfQ102Vr
	 h4SQdKxIcCACoNPB4Iha6oZCrdZQsNCfMEU59uP+7rmjv9G/o+KnXuh/B6YsYR11L9A==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786112511;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=R9EGHhCc3EI7UX2fl6ncKJ3an14BK1DUSmfvcqCoLts=;
	b=vWTUfwuVeEPBX5DC1Wc8AcQ4aOfl11i9ew28kh5ukBo0ZL7RS/KSIZEwE6XsrMsjmoWE
	 7mbejiI/nnoklYsRLG857AWgl5CK5+PenfkQdt2SPyKXT8qRlD6tCAsPc9Srn1Heb6bVM
	 4xpMkVxm9dCwB3mbhT8tzk5AD+dTMWKlD+IMs4KeZT5tAK7CFhqxFK/Mo2GTYC4oan99F
	 gk/3thJC46ZtZhtDfHLDvhligSupRaf+wHoIt49yHCxqD5d1cb8d/C7SNbpv85o2STq/q
	 9CvfnFkRdh5ssu9j74NwyynOyeVAbG9NDtExa5eRwnN/0HpV8dL6czIg3siW25aVe5A==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rOq4yU26;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.128.41
Received: from mail-wm1-f41.google.com (mail-wm1-f41.google.com [209.85.128.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 6D3681F00A3A
	for <syzbot@kernel.org>; Fri,  7 Aug 2026 14:21:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=rOq4yU26
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 6D3681F00A3A
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-wm1-f41.google.com with SMTP id 5b1f17b1804b1-498028b3d5eso34363515e9.1
        for <syzbot@kernel.org>; Fri, 07 Aug 2026 07:21:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786112509; x=1786717309; darn=kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=R9EGHhCc3EI7UX2fl6ncKJ3an14BK1DUSmfvcqCoLts=;
        b=rOq4yU26rUYlvy8lQc9ddVQXVYu1J64moAFmoFQ5mPaT3flT7Mbls8mfgIl2F8pOdj
         uk5Xi9c7Dwojwah7CmgDay0nR1YQfLU0wxKh6J0s2201DuW0QvPV9Hh+t1dJK3HJz/if
         bLAgzHcZo9/Koj4m6ufWlqj2BV2svDz7npHkiHZzZeH28odrF5t8nyK6xuPaV1hnsKHP
         xJne105gkDyaxsf6b91jRfZZHEhbnuk6c+U7fD3fhrxR90zeQ2uvEePkimqZvNo0YOlS
         PCZInwKg1UHxpz34S/VhyETu7Zc1fS7NBsVGwESlnlDtYFU3cfTH0NZxst8GpPc7otwz
         QTZw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786112509; x=1786717309;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=R9EGHhCc3EI7UX2fl6ncKJ3an14BK1DUSmfvcqCoLts=;
        b=SoPKlKCjhNL8AlaM+9WVC+wzKjIni2y8rr2ZqPjmE0jdiFu2ft+yIn0AiLCqXXy3pS
         Or1qMqcq/Rn3u3RMhnWh5qoEZtt2FZqK23xGF8UOcu/SOgUztbL0pKBORTCW4jzO42fr
         TTZqsgweszLrcOzOJZFQf4pp/Sm6f/YfXCk9XxK4m4y34Rni3ra7FpTSwWGtWXdYKi2a
         ePsT8z1hFL1CPAE5hqe+3EYq50Npi7WthxhgpobPUkEWAvmj8ADiM7OoLxfgjnnk0eZa
         tCYDiIEgWlKMHY2Ql63hWdrcUT4HUvnR1njb0wDZ0fSWLCPKd0X7iXXAvbF/NXlrfJs5
         zyhA==
X-Gm-Message-State: AOJu0YwYa/iiK0UiffbmHi/YFsf+PYQA3RKW0ytv+jUmhpSfLk8ckGI9
	frpfTWDEFmJuTdmZsC/jMH2LWkLkN3YNOYJGsDbvouyGtUUCtlf2G27aKd9c58Sm
X-Gm-Gg: AR+sD11qZRmWDDM+2SKEwc7FKgNLGSFerOrKROoJ1Zkxp4Eo2KrbvcQGxQldp9ivmqg
	OtvD9XLY9CMBLSGu80ROtNUobQ6kYyvYUTEOohi53DXuSR8+0x4lwwkQnMDlCBKpWQ4P+i2Cdre
	up4N6m0QIsKEO3n2cA59pbIfnq0FgIPcXNa4HXGomaQ7pkqyHn+Es7Crh5vAvuloIZvfwvqP/R2
	esf2B2qFRdvDMp2q1L8g8Xw/9BODk1wPwsQQdVT8fJTVCNgyYWy5/azGGu25sYv41M8yv/19Yab
	EeResUZRlPhnSghcYQqPqHjo4JJ5btkKL42Cle9dE+D0vll014Bxo6W+Lbd0c/nBXtRh5CxAVeo
	mWtvpIIbTCUje0i3nEi+IGxzw48k2lwy8n7AJ6EDLbn3yikJ9fTFl2dicXmCxvQo1kY/PHnhomJ
	7YhLSmWcgy5x5H1Ygv6XLAmwM5wM+DMWW1NQTKt1SHSkCVw5CKTSTQcv/iNwewR2bngkHBE1+mA
	kVUQhbrx4N2Pfl4sPiv8+AA
X-Received: by 2002:a05:600c:314f:b0:497:fe58:d714 with SMTP id 5b1f17b1804b1-4994e7baa31mr241603175e9.9.1786112508518;
        Fri, 07 Aug 2026 07:21:48 -0700 (PDT)
Received: from localhost ([37.30.44.40])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995d85254asm26145865e9.1.2026.08.07.07.21.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 07:21:48 -0700 (PDT)
Date: Fri, 7 Aug 2026 16:21:47 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v3] tipc: defer local Nagle backlog xmit from receive
 path
Message-ID: <jszykgtbwif7vfvkpbgdqh6pkpre4pyeprwbdvf5uarq5p6sbj@zvmz53yfajd3>
References: <e5b4f184-4cf0-4891-9623-526d3dbf5a12@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e5b4f184-4cf0-4891-9623-526d3dbf5a12@mail.kernel.org>

The v3 code change remains correct. Own-node smart-Nagle backlog
transmission is deferred until after the socket lock is released, while
remote transmission, -ELINKCONG handling, and the NULL shutdown path remain
unchanged. The tested scenario reproduced the target soft lockup in all four
unpatched guests and in none of four patched guests. The patch is not ready
yet because the new parameter remains undocumented and the requested exact
changelog text has not been used. No behavioral rewrite is needed.

Version 3 corrected the subject and removed the detailed execution narrative
and call trace. Two editorial changes remain. First, document the new xmitq
parameter by extending the existing function comment as follows:

/* tipc_sk_push_backlog(): send accumulated buffers in socket write queue
 *                         when socket is in Nagle mode
 * @xmitq: receive output queue, or NULL outside receive context
 */

Second, use the following subject and changelog text exactly, including all
text between the double quotation marks:

"tipc: defer local Nagle backlog xmit from receive path

A local TIPC stream socket workload can trap a CPU in an endless receive
loop. The resulting soft lockup can make the system unavailable.

tipc_sk_push_backlog() can transmit delayed stream data while
tipc_sk_rcv() holds a destination socket's sk_lock.slock. Own-node
transmission enters tipc_sk_rcv() synchronously. A reply that reaches the
ancestor socket cannot acquire the still-held lock, and tipc_sk_rcv()
retries without consuming its input queue.

Pass the receive output queue to tipc_sk_push_backlog() from receive-side
callers. Queue own-node output there so the enclosing receive path sends it
after releasing the socket lock. Keep shutdown and remote-node transmission
on the existing direct path, preserving remote link congestion handling."

On Fri, Aug 07, 2026 at 10:10:56AM +0000, syzbot wrote:
> An RCU stall can occur due to a spinlock recursion bug in the TIPC
> subsystem. When tipc_sk_rcv() is called recursively on the same CPU, it
> tries to acquire a socket spinlock that is already held higher up in the
> call stack. Because it uses spin_trylock_bh(), it fails to acquire the lock
> and enters an infinite loop.
> 
> To fix this, modify tipc_sk_push_backlog() to take an xmitq parameter. If
> xmitq is provided and the destination is on the own node, splice the write
> queue into xmitq, deferring the transmission until after the spinlock is
> released. For calls like __tipc_shutdown() that execute under the socket
> mutex rather than the spinlock, passing NULL for xmitq allows direct
> transmission to continue safely.
> 
> Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+10a41dc44eef71aa9450@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=10a41dc44eef71aa9450
> Link: https://syzkaller.appspot.com/ai_job?id=3b51a2d9-6039-4d50-b8fe-9bd92fe8a3f1
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
> v3:
> - Updated the commit subject to 'tipc: defer local Nagle backlog xmit from receive path'
> - Simplified the commit description by removing the detailed eleven-step execution narrative and the full call trace.
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
> index e564341e0..16d844fc8 100644
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
> @@ -1268,7 +1269,8 @@ void tipc_sk_mcast_rcv(struct net *net, struct sk_buff_head *arrvq,
>  /* tipc_sk_push_backlog(): send accumulated buffers in socket write queue
>   *                         when socket is in Nagle mode
>   */
> -static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack)
> +static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack,
> +				 struct sk_buff_head *xmitq)
>  {
>  	struct sk_buff_head *txq = &tsk->sk.sk_write_queue;
>  	struct sk_buff *skb = skb_peek_tail(txq);
> @@ -1310,6 +1312,12 @@ static void tipc_sk_push_backlog(struct tipc_sock *tsk, bool nagle_ack)
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
> @@ -1367,7 +1375,7 @@ static void tipc_sk_conn_proto_rcv(struct tipc_sock *tsk, struct sk_buff *skb,
>  			goto exit;
>  
>  		was_cong = tsk_conn_cong(tsk);
> -		tipc_sk_push_backlog(tsk, msg_nagle_ack(hdr));
> +		tipc_sk_push_backlog(tsk, msg_nagle_ack(hdr), xmitq);
>  		tsk->snt_unacked -= msg_conn_ack(hdr);
>  		if (tsk->peer_caps & TIPC_BLOCK_FLOWCTL)
>  			tsk->snd_win = msg_adv_win(hdr);
> @@ -2165,7 +2173,7 @@ static void tipc_sk_proto_rcv(struct sock *sk,
>  		smp_wmb();
>  		tsk->cong_link_cnt--;
>  		wakeup = true;
> -		tipc_sk_push_backlog(tsk, false);
> +		tipc_sk_push_backlog(tsk, false, xmitq);
>  		break;
>  	case GROUP_PROTOCOL:
>  		tipc_group_proto_rcv(grp, &wakeup, hdr, inputq, xmitq);
> @@ -2256,7 +2264,7 @@ static bool tipc_sk_filter_connect(struct tipc_sock *tsk, struct sk_buff *skb,
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
