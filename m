Received: from mail-wm1-f52.google.com (mail-wm1-f52.google.com [209.85.128.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17C3C279DCC
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 09:29:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786094979; cv=none; b=kACigCfnrqJdOSkv6XmEg+wZYUEp2degWB0tZPXZKOH/8Z4MLhcBnHrsAobiZw5jnTNUSg/2CDKN5ip0TgKrLdcAFsd10isq03Z19qJSAPGbaF6yjdWCkJTzTCj87vaC8oI9wuBu4wQFSFFIuhxGsDo3bFMEJFcwZgUTwuEyd3Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786094979; c=relaxed/simple;
	bh=uLB9odZ5vYWjVPco0vlFD+Z+a2Q23g+lj6jGWnLx6lE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=e2Pk6vTn7u7b17YgG6H7YGKFKI8Zn/okvJXebUWOSOl8YrtIF2A/0Uw8L3uurDie6sImzHWEd8zTmajw6JxbhS85mVfPngXrzXoNWAeP5Lbm3OG1WFKabGLepaARZRjR1e6RwA78VaZw5xM/l4XQy8ZCEgJVzWy1a9AoQwT/b5o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=ZH/fgawz; arc=none smtp.client-ip=209.85.128.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="ZH/fgawz"
Received: by mail-wm1-f52.google.com with SMTP id 5b1f17b1804b1-49800c6a846so25798605e9.3
        for <syzbot@lists.linux.dev>; Fri, 07 Aug 2026 02:29:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786094975; x=1786699775; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=0L5rzWzM+H9F1WgGZerpkUzi6krWq0j5fGcESj7XgkY=;
        b=ZH/fgawzvl+DM4iEKU9ppCJnexFCPcdRgaCmyn5lZtEfHmp2y/pqfLFOj30QwdAL6H
         hhbVrQfyyoi22ElDDtrSJ8XG3kNZkUn1SffdV974cZOKqwRNsi9OExGzqqSOrq2B6MmL
         T9yim3rWiuKOb7ii5TUuxZ2YL03HSYaWw7/gfTyDgUxP3cNRbXZjWjpTTgwO8iRuoYGU
         SITNza+w08m8jgaS2qAjaqUS6OgEvzaBBIsw6vKMFyUZ3Dk8Ygam1LBxGSv1Z5erv6c5
         pGiw6JjxP15RadT8MHCeXpBdpQPiY7syA0qNVE157i+Of0lLTMYDnkg2mxQLpKlFYgHf
         fU6Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786094975; x=1786699775;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0L5rzWzM+H9F1WgGZerpkUzi6krWq0j5fGcESj7XgkY=;
        b=p5NQ+5dfuLYXkC/LdGHTjnw/gQdze86Wpy4/UGZiwcpIF6oTmg1sLdj60AmCZIZRzP
         6ZiSQ/VdI8cnAU9+Tht32hNRd7yQhe2n8VqHvgEGLWzjkE1eUwBIBgoARJA4cDo15Amy
         /ZroLVzwo/AoAOE5kT23ELHVSr6oTvX7KB03LPZCDs37YzGv36LfDt/CwGd7WNoN6Qyd
         XtuRr+8ZDHzETCS7RJ0DAos1GjzAwVgAeg0PfiSks+vwPxPpCFGxF5ouY7OQK+PR3IRv
         CNlNcVhe9yDYHydAsjLiqxIcnNwyLDwYjvrISYRqYPlenzZ4I1fIrL2Drs2HZsglSf+g
         NgRw==
X-Forwarded-Encrypted: i=1; AHgh+RpjJybCwVVmV1TUV66I3CRkjCARQCH3X0qdsknleHt+NFMxQfqUw7ohIW/El3bRQuyLR2rRd1s=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYnl+u+qVLQs1d5TChHex4aM8hFj/A6F6FUvL6HFTVl4F6p+nj
	O5PO5bO2iGGfsIwAovLUaCA+2e1uUnk5fqNtrRW/b2a71CeO8uMjgN1g
X-Gm-Gg: AR+sD118h09sT8IGoLDZKyN6kZKcmGt1znGLlP0cNs7fpKxdpQV78WTv4I/QWOi4RY9
	zstXmX6VjXlf549HxXZeoL+BDN18tOfBn69QW5tJ0ji4bgobUonO2z5VY5rPfnUwuEBlBQLGxdA
	sDH1BVHjqF4/vfRN69aLuwub8/P71HxWOMKNa7oL84g2wI1yaAesJd9soIqViWIpSJXSYDzVKGi
	4dCl74h931Y3CMliVjKDvpRpUE35JmkdsZgYr+K9rIS9OUP+Q98g+wiWIOpryjLnaNghX9tswD9
	uZ+Glw9+6TlvsBQ6ew43wEa3np16c2Vvpwbx1QpDa5kPDeaMgMU6BnNlX7zSoQBUarGbtlwkRxV
	MsnfcPtWSrAwh6Rm+LLQkI4EFMKsFvkjqBXrz653O6D2L977WoSiBfMDk6pU1VfcLj12SPn6tlX
	KtGwASD2UGUI+5VsvYP1JtCPZ+DDbpDcyc63ynGM+vzOvQYy6oK859HCpR8J7z8zHdxY7XCfsL3
	/L+2WkGZb7m4w==
X-Received: by 2002:a05:600c:1992:b0:499:593c:3384 with SMTP id 5b1f17b1804b1-49959e08773mr99044685e9.6.1786094975227;
        Fri, 07 Aug 2026 02:29:35 -0700 (PDT)
Received: from localhost ([37.30.44.17])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4995e9e7164sm28303125e9.2.2026.08.07.02.29.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 07 Aug 2026 02:29:34 -0700 (PDT)
Date: Fri, 7 Aug 2026 11:29:33 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] tipc: fix spinlock recursion in tipc_sk_rcv()
Message-ID: <fk7nnkqcwgsn4bdhijwk7ixebyolgi74kl7vwq7yfbwlk7beko@eh32rztjq7zi>
References: <368f7232-39e9-424c-9683-0c28db1151af@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <368f7232-39e9-424c-9683-0c28db1151af@mail.kernel.org>

The v2 code change is correct. Own-node smart-Nagle backlog transmission is
deferred until after the socket lock is released, while remote transmission,
-ELINKCONG handling, and the NULL shutdown path remain unchanged. The tested
scenario reproduced the target soft lockup in all four unpatched guests and
in none of four patched guests. No code rewrite is needed.

Keep the code unchanged and revise only the subject and changelog. The full
call trace and the eleven-step execution narrative are not needed in the
permanent changelog - use the human easy readable summary for that. 
The Closes and Link tags preserve the raw report and
supporting details. A concise problem, cause, and fix description is enough
here.

A suitable replacement commit message is:

tipc: defer local Nagle backlog xmit from receive path

A local TIPC stream socket workload can trap a CPU in an endless receive
loop. The resulting soft lockup can make the system unavailable.

tipc_sk_push_backlog() can transmit delayed stream data while
tipc_sk_rcv() holds a destination socket's sk_lock.slock. Own-node
transmission enters tipc_sk_rcv() synchronously. A reply that reaches
the ancestor socket cannot acquire the still-held lock, and
tipc_sk_rcv() retries without consuming its input queue.

Pass the receive output queue to tipc_sk_push_backlog() from
receive-side callers. Queue own-node output there so the enclosing
receive path sends it after releasing the socket lock. Keep shutdown and
remote-node transmission on the existing direct path, preserving remote
link congestion handling.

No code changes are requested.

On Wed, Jul 29, 2026 at 04:54:27PM +0000, syzbot wrote:
> An RCU stall (infinite loop / livelock) can occur due to a spinlock
> recursion bug in the TIPC subsystem. Specifically, tipc_sk_rcv() can be
> called recursively on the same CPU and try to acquire a socket spinlock
> that is already held higher up in the call stack. Because it uses
> spin_trylock_bh(), it fails to acquire the lock and enters an infinite
> loop.
> 
> The issue is triggered by the concurrent execution of sendmsg() and
> setsockopt() on a connected TIPC socket pair (fd0 and fd1), which reside on
> the same node (loopback).
> 
> The sequence of events leading to the livelock is:
> 1. setsockopt locks fd0 (acquires the socket mutex sk->sk_lock.owned).
> While fd0 is locked, sendmsg on fd1 sends messages to fd0. Since fd0 is
> owned by the user, tipc_sk_enqueue() adds these messages to fd0's backlog
> queue.
> 2. setsockopt processes SO_RCVBUFFORCE and reduces fd0's sk_rcvbuf to the
> minimum value (SOCK_MIN_RCVBUF, 2048).
> 3. setsockopt finishes and calls release_sock(fd0). Seeing a non-empty
> backlog, it calls __release_sock(fd0).
> 4. __release_sock(fd0) drops fd0's spinlock (sk->sk_lock.slock) and calls
> sk_backlog_rcv() -> tipc_sk_backlog_rcv() -> tipc_sk_filter_rcv() to
> process the backlog.
> 5. Because sk_rcvbuf was drastically reduced, the receive queue limit is
> exceeded. tipc_sk_filter_rcv(fd0) rejects the message (TIPC_ERR_OVERLOAD)
> and queues a reject message to xmitq.
> 6. tipc_sk_backlog_rcv(fd0) calls tipc_node_distr_xmit(&xmitq) to send the
> reject message back to fd1. Since fd1 is on the same node, tipc_node_xmit()
> synchronously calls tipc_sk_rcv(fd1).
> 7. tipc_sk_rcv(fd1) successfully locks fd1's spinlock and calls
> tipc_sk_enqueue(fd1) -> tipc_sk_filter_rcv(fd1) ->
> tipc_sk_filter_connect(fd1).
> 8. tipc_sk_filter_connect(fd1) sees that fd1's sk_write_queue is not empty.
> It calls tipc_sk_push_backlog(fd1).
> 9. tipc_sk_push_backlog(fd1) calls tipc_node_xmit() to send the queued
> messages to fd0. This synchronously calls tipc_sk_rcv(fd0).
> 10. tipc_sk_rcv(fd0) successfully locks fd0's spinlock (as __release_sock
> dropped it) and calls tipc_sk_enqueue(fd0). Since fd0 is still owned by the
> user, it tries to add the message to the backlog. The backlog is full, so
> it rejects the message again, sending a new reject message back to fd1.
> 11. The new reject message is sent to fd1 via tipc_node_xmit() ->
> tipc_sk_rcv(fd1). tipc_sk_rcv(fd1) tries to lock fd1's spinlock. However,
> fd1's spinlock is already held by the outer tipc_sk_rcv(fd1) at step 7.
> 
> In tipc_sk_rcv(), if spin_trylock_bh() fails, it assumes another CPU holds
> the lock, so it just continues the loop without dequeuing the message from
> inputq. Because the lock is held by the current CPU, it will never be
> released, and the while loop spins infinitely, causing the RCU stall:
> 
> rcu: INFO: rcu_preempt self-detected stall on CPU
> ...
> Call Trace:
>  <TASK>
>  __raw_spin_trylock_bh include/linux/spinlock_api_smp.h:207 [inline]
>  _raw_spin_trylock_bh+0x60/0x70 kernel/locking/spinlock.c:150
>  spin_trylock_bh include/linux/spinlock.h:414 [inline]
>  tipc_sk_rcv+0x420/0x2b50 net/tipc/socket.c:2500
>  tipc_node_xmit+0x205/0xf10 net/tipc/node.c:1701
>  tipc_node_xmit_skb net/tipc/node.c:1766 [inline]
>  tipc_node_distr_xmit+0x2cd/0x400 net/tipc/node.c:1781
>  tipc_sk_rcv+0x2539/0x2b50 net/tipc/socket.c:2505
>  tipc_node_xmit+0x205/0xf10 net/tipc/node.c:1701
>  tipc_sk_push_backlog net/tipc/socket.c:1313 [inline]
>  tipc_sk_filter_connect net/tipc/socket.c:2259 [inline]
>  tipc_sk_filter_rcv+0x17f3/0x3210 net/tipc/socket.c:2368
>  tipc_sk_enqueue net/tipc/socket.c:2449 [inline]
>  tipc_sk_rcv+0x877/0x2b50 net/tipc/socket.c:2501
>  tipc_node_xmit+0x205/0xf10 net/tipc/node.c:1701
>  tipc_node_xmit_skb net/tipc/node.c:1766 [inline]
>  tipc_node_distr_xmit+0x2cd/0x400 net/tipc/node.c:1781
>  tipc_sk_backlog_rcv+0x1ad/0x270 net/tipc/socket.c:2416
>  sk_backlog_rcv include/net/sock.h:1190 [inline]
>  __release_sock+0x28b/0x390 net/core/sock.c:3261
>  release_sock+0x190/0x260 net/core/sock.c:3860
>  sockopt_release_sock net/core/sock.c:1163 [inline]
>  sk_setsockopt+0x2822/0x2e80 net/core/sock.c:1681
>  do_sock_setsockopt+0x11b/0x1b0 net/socket.c:2364
>  __sys_setsockopt net/socket.c:2393 [inline]
>  __do_sys_setsockopt net/socket.c:2399 [inline]
>  __se_sys_setsockopt net/socket.c:2396 [inline]
>  __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2396
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> To fix this, tipc_sk_push_backlog() should not call tipc_node_xmit()
> directly for own-node destinations while holding the socket spinlock.
> Instead, modify tipc_sk_push_backlog() to take an xmitq parameter. If xmitq
> is provided and the destination is on the own node, it splices the write
> queue into xmitq, deferring the transmission until after the spinlock is
> released. For calls like __tipc_shutdown() that execute under the socket
> mutex rather than the spinlock, passing NULL for xmitq allows direct
> transmission to continue safely. For off-node destinations, direct
> transmission remains safe as it does not lead to synchronous loopback
> recursion.
> 
> Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+10a41dc44eef71aa9450@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=10a41dc44eef71aa9450
> Link: https://syzkaller.appspot.com/ai_job?id=e6db6744-c061-4f81-bde8-25993166f061
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
> v2:
> - Only defer transmission in tipc_sk_push_backlog() if the destination is on the own node.
> - Update the commit description to clarify that deferral is only needed for own-node destinations.
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
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
