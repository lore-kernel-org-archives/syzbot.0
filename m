Received: from mail-wr1-f44.google.com (mail-wr1-f44.google.com [209.85.221.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F0A8411A1E
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 15:34:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785339266; cv=none; b=koZYTlrpMsnzHFAuig7tt7ru6a/AHm0ycRIG9Ez4dfzPqgh9CxdQjyllP2LXQahiiheVZ9XCgTkEzYAikQARkQ43MoNimIaZrOWJ0OxNIcDRrwzS7DxsWBGsJ5Wag0pZa2Qfwhle/3IytWBmOxOlB9rp4vHdf8xepk46D6KGzOI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785339266; c=relaxed/simple;
	bh=/8E/mzpV8NvxuL7qhatlYh5ujbLF/B6CEStB/a62ENE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=CuQVIR++LrJru2TJR4Vo9URXx7tXHyDbYH7Ut9KGuD7V+vOg/JI9LKr05g/60NNkRehwtFTGXA9HoiAgTu9c267fwI/lCnXOFTEfNAb6nt/YYFbFjOedQexNiYtLKAkYrCuLInXXLbiCi3erOhqC9JY7C/w4bYacnLwan6tUAdg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=D/aLs0Tm; arc=none smtp.client-ip=209.85.221.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D/aLs0Tm"
Received: by mail-wr1-f44.google.com with SMTP id ffacd0b85a97d-47f6609c657so592180f8f.2
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 08:34:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785339261; x=1785944061; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=1EBA1WeYKawLQghfRidv/cNBg2UmglALNRNll5TJn7k=;
        b=D/aLs0TmsOpj5lwIMzFONAaW+XXfxaYFW7Arp8iQK4mHYhFfAA9bPN/SXyUc2K7SZn
         moD6HFDadLHx0oj8xKD1dg4aPR+hAcvMs3DVW8bLh0luCrHQS0FYSiHt8zQVWKEEdLZC
         C9RTCCGW6Q6FKA9qxWJMnO9lkSnes4qUbLojndBws9NvPqA1CjVbV8BeNokOkwpdtRyI
         uW7N2DNZ2ouYmP/NFwcT0Xz/fjGpuWCe0C4jhMhGE6bKir0/LehXFNRqHcP0qJXorFdL
         +AiaBoFqZwj3GrU68ia+wQNpXDkGtm3T2l/HS64yh0qdMhWwdj1x24TSiFFcRQBZ0Yai
         HxGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785339261; x=1785944061;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=1EBA1WeYKawLQghfRidv/cNBg2UmglALNRNll5TJn7k=;
        b=lFSj92BHKy22UNbNpjm48POo2WhWj265U0+K1r5PMqIM99d461pENgWEO8YF0boz83
         Lf1ts2DcuvU+rxDhzeSsc4RO+vfrUvAvDtK+98dF7VjevT1ZfTSLknR/CprkLxzWWcJV
         s/B86h9hg7Y/xYx+jZ2vfeMxvnmo+7r2hwui7HuiGyjMfZnTe2tC8YBFM4AvLB1vtwc/
         o1awzCMvcxEciE/e+Yg0xy0vjHW9TXe3AS43EUKnZlbecM7Gt8fslwlG3MDulxgvYKby
         MskqQkL6IYItUBLz008L3yT3K9kfQBCtXIpplZXZvkVM+Nj5TE5g3+3Xi7h0t1kprRSl
         yzTA==
X-Forwarded-Encrypted: i=1; AHgh+RpBinotr0M3d95VCJFrXk1Slvkxft6eZwKza7NJ7PBuacKEIys58Ky7pPb0w/Eyx+LcCCtm48Y=@lists.linux.dev
X-Gm-Message-State: AOJu0YzP9Fj9SVorzkw2pdhb/H+9JX9OtEzmYiVPENNO8oYwWyMcQP6u
	59R/ihZiHXRwXLCxGyMqNU02iAxrf930u3HNUtktbC4aBjAZ3ybXGjb4
X-Gm-Gg: AR+sD13JYci1xfctK6vAaN3ZjdJY0uPfZjma9xwlVrvjv2jG65C0UHl1FoiDcpIExPN
	sOuyO0bmHC1aYdI2r7dIJLoijdfsE7H/HOQpsjJ9aekByS50vTbILzuKBtBNY1fNAQiojrxmQ9v
	AQ+chfmpa68zRR/wT4BmxFpZ2EfWEoXB4lrKDKgDQteHy6eXGm4+X64OlSGRdn0cXrIkTiR9FKR
	kMKX1W5/7kGYfynHDMwCVgITDQqcUNxD0R+CDwRVRlGlPa+SRnCg0o/Hp/kt0sWxJdRJ80HrPdJ
	+93+dtl0KorvNEnhR5XcXOaupWgJ2y6k0KWOTz1zBG/DIRUNzFaZMgDB5AsbLVT6UQVxbGcXtuG
	nyvjdqzlQ+M4YGslQj/EHz4aiw4ap80MtlpYB3NHZGzb/HW55xjnI/lXjkb0Ut7M5fzwP8GSL99
	bv5KiBTXaZZSKBmKsVHh9WZroOeZGnzcnZ5HDdk24z+kt2a8p5ISI8a/sdBEk/vYpvedVLxy53i
	2rg6q64DyQL6d8=
X-Received: by 2002:a05:6000:2908:b0:47f:52e9:3716 with SMTP id ffacd0b85a97d-47fb1eb7108mr8857878f8f.44.1785339260635;
        Wed, 29 Jul 2026 08:34:20 -0700 (PDT)
Received: from localhost ([37.30.44.117])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47fb6b2768fsm8857481f8f.37.2026.07.29.08.34.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 08:34:20 -0700 (PDT)
Date: Wed, 29 Jul 2026 17:34:19 +0200
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] tipc: fix spinlock recursion in tipc_sk_rcv()
Message-ID: <itkgtjwcza6bl3zirj6ahx3v6dzp2krksh3gate62fylv2vo37@ndcnjfhv3ohy>
References: <01641937-e30d-43dd-ba9c-95b3d2ae5691@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <01641937-e30d-43dd-ba9c-95b3d2ae5691@mail.kernel.org>

This patch fixes the tested own-node lock recursion by deferring queued data
until the receive-side socket lock has been released. Comparable four-VM
testing reproduced the target TIPC stall in 4/4 baseline VMs and 0/4 patched
VMs. The patch is not ready because the unconditional if (xmitq) branch also
defers remote-node backlogs and bypasses the existing whole-queue transmit and
congestion-result handling.

tipc_sk_push_backlog() currently uses xmitq as both a lock-context signal and a
destination test. Those are not equivalent. For a remote dnode, the existing
tipc_node_xmit() call must remain responsible for sending the complete queue
and restoring cong_link_cnt when it returns -ELINKCONG. Sending those buffers
later through tipc_node_distr_xmit() changes that contract.

For the next revision:

- Restrict the splice-to-xmitq branch to own-node delivery, equivalent to
  xmitq && in_own_node(net, dnode).
- Preserve direct tipc_node_xmit() and -ELINKCONG handling for remote nodes,
  and keep the NULL shutdown path unchanged.
- Update the commit message to describe the own-node boundary instead of
  implying that every receive-side backlog can be deferred.
- Run focused local, remote, shutdown, and connection-flow checks in addition
  to the comparable baseline/patched reproducer pair.

A broader TIPC transmit redesign is unnecessary. Keep the next revision on
the existing smart-Nagle helper and narrow its deferral predicate.

On Wed, Jul 22, 2026 at 06:39:37PM +0000, 'syzbot' via syzkaller-upstream-moderation wrote:
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
> directly while holding the socket spinlock. Instead, modify
> tipc_sk_push_backlog() to take an xmitq parameter. If xmitq is provided, it
> splices the write queue into xmitq, deferring the transmission until after
> the spinlock is released. For calls like __tipc_shutdown() that execute
> under the socket mutex rather than the spinlock, passing NULL for xmitq
> allows direct transmission to continue safely.
> 
> Fixes: c0bceb97db9e ("tipc: add smart nagle feature")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+10a41dc44eef71aa9450@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=10a41dc44eef71aa9450
> Link: https://syzkaller.appspot.com/ai_job?id=109dc7c6-7562-4bd4-9094-58dfff0a3623
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
> diff --git a/net/tipc/socket.c b/net/tipc/socket.c
> index e564341e0..4b3d8193d 100644
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
> +	if (xmitq) {
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
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/01641937-e30d-43dd-ba9c-95b3d2ae5691%40mail.kernel.org.
