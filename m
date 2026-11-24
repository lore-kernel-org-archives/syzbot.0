Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795514326;
	b=GvXH6T4HhFbyJebkNqtIxVh1vmeiJlCN3Q/8d2sgLEPpvlj689pVNzwp9hgQ8VEXMUMv
	 34gDPPe2euIaI7WN5Y/04R8fUld/kafpTXPyBhYZO0mJ5AlNPJ46p6534QsEIDidgTn8S
	 NI6hq0l3hILaQuhSi7l2EqYBz72GnELPReP1+CBF3ke1KsDeXHymVoIhrNOHZ3wrJyYg/
	 4kWHNX69qZysRAYWSWmVnISCSiQaiIqUPnXDeyJiO9wjyRuQYqFEP1HPaHCsdfLvSrA6s
	 z+IzBtn21LsZgfrDSvtXLPGV5U/Pgkyw/kw+CyV7cWGA2wrTg5LfWHMOaP3OuqmLd6g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795514326;
	h=Received:DKIM-Signature:Subject:From:To:Cc:Date:Message-ID:
	 In-Reply-To:References:X-sashiko-severity:Content-Type:
	 Content-Transfer-Encoding:MIME-Version;
	bh=0F1BSj/xm7NejO8C6gphmJxoGj2OkwZ3aV8GLt6VHvU=;
	b=vy3KFM2xu4Oug5yKQTeTqVFCuZR8cRBf9Zk5WDhEOgDHF2TTlFW3NK96afNYWT8qkBPT
	 UJNri2hqFVlJe2URndZs0H+rG9tVA+MZ4T5RvfdoeLcdZuLKgM+z29IbOl7FDNI7yI+pW
	 CwwcuZZoM/CEDNBv2Ze0G8Y1Ij2X7T7YfZ9+G6e67l2jrcUf6cLAnAQbp/3xvfELrJZ7o
	 w3dweZg/FWzKfsU5WD0iWht1WnWeLUQjzvsa2SfjvFnVYxgfLX80HKUpwpEs2NGdpnww5
	 /PXCnInHhJR5W8SZIPZvsaGtBn3GFyCroEHrD1KVDyUfmmSQmLy9vJnx24fthaiag+Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HJzVJrgL;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9400606A322;
	Tue, 24 Nov 2026 09:58:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=HJzVJrgL
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2211D1F000CA;
	Tue, 24 Nov 2026 09:58:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795514325;
	bh=0F1BSj/xm7NejO8C6gphmJxoGj2OkwZ3aV8GLt6VHvU=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=HJzVJrgLOwXbP5O6mg2yt8VGhjygr4IGZEwaETM60khcxgI1lBtm0N60e/5Z39zz0
	 mteHa7fbR2AGVloRDY349K3pB5VIsPlGhJYFIeqIGPJKsRhJQ4MQu6eFDCxS54k6zb
	 v8yWj3XB69PxHx6eIbcFh7qjnI2inR3sm4L6MqFD1KSGHvQJ9D2h1awPSDh9V4doTo
	 LuqUCifLnRp9DKGBLcJF/RPPS5gSAeNhCvOcz5D5DrQ8QWz2b9JlNthdajxxOoXS5N
	 QuMOpe2siYVb7fxfJq/1ZIWCCEkLv+vjGK34v+ENPCAQrz8WRGFkCk5hyL85oOlX8O
	 OEQbUv/nWTTag==
Subject:
 Re: [PATCH] net/x25: fix invalid lock_sock() usage in x25_kill_by_neigh()
From: netdev-bot+sashiko@kernel.org
To: syzbot@kernel.org
Cc: syzkaller-bugs@googlegroups.com, krystianmkaniewski@gmail.com,
 davem@davemloft.net, edumazet@kernel.org, kuba@kernel.org,
 linux-x25@vger.kernel.org, ms@dev.tdt.de, netdev@vger.kernel.org,
 pabeni@redhat.com, duoming@zju.edu.cn, horms@kernel.org,
 linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Date: Tue, 24 Nov 2026 09:58:44 +0000
Message-ID: <179551432467.3135.11868205229731190547@kernel.org>
In-Reply-To: <00f667e3-a158-4fb5-84a3-9ecda4718ce8@mail.kernel.org>
References: <00f667e3-a158-4fb5-84a3-9ecda4718ce8@mail.kernel.org>
X-sashiko-severity: Medium
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider.

Critical: 0 · High: 0 (1) · Medium: 1 · Low: 0

If you believe none of the issues are legitimate, please reply to each
issue of Medium severity or higher and explain why the AI is wrong.
If any of them are legitimate and you plan to respin, please let patchwork
know by including "pw-bot: cr" as a separate line at the end of your reply
(one such reply per series is enough).

- [Medium] When the new softirq path finds a socket owned by a task, it
  only sets a flag and leaves the dead call usable until release_sock().

Pre-existing issues:
- [High] This problem wasn't introduced by this patch, but it is still
  reachable after it.

--

net/x25: fix invalid lock_sock() usage in x25_kill_by_neigh()

This patch adds a bh parameter to x25_kill_by_neigh() and
x25_link_terminated(), so the softirq receive paths no longer call
lock_sock(). In softirq context, an unowned socket is disconnected under
bh_lock_sock(). If a task owns the socket, X25_KILL_BY_NEIGH_FLAG is set
and the disconnect is deferred to a new x25_release_cb() hook.

Closes: https://syzkaller.appspot.com/bug?extid=300375dfd44665f063a6
Link: https://syzkaller.appspot.com/ai_job?id=98a38af7-51e0-4126-afa7-b8246507da37

> diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
> index f45c9ec7d2c68..26a8deb82452b 100644
> --- a/net/x25/af_x25.c
> +++ b/net/x25/af_x25.c

[ ... ]

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

[Severity: Medium]
When a task owns the socket, this branch only sets the flag. It leaves
x25->lci, x25->neighbour, x25->state and sk_state unchanged. Can the
cleared call still be used until release_sock()?

__x25_find_socket() matches only on lci and neighbour. Frames that arrive
on the old LCI after the restart or link loss still find this socket, and
x25_receive_data() queues them on its backlog:

    queued = !sk_add_backlog(sk, skb, READ_ONCE(sk->sk_rcvbuf));

release_sock() drains the backlog before it calls the new hook:

net/core/sock.c:release_sock() {
    ...
	if (unlikely(sk->sk_backlog.tail))
		__release_sock(sk);

	if (sk->sk_prot->release_cb) {
		if (!tcp_release_cb_cond(sk))
			sk->sk_prot->release_cb(sk);
    ...
}

So those frames go through x25_backlog_rcv()->x25_process_rx_frame() in
the call's old state. Only after that does x25_release_cb() run
x25_disconnect().

For example, a CALL_REQUEST from the peer on a reused LCI right after a
restart would be dropped by the stale socket in state 3. It would not
reach x25_rx_call_request(). DATA or INTERRUPT on that LCI would go to
the dead call, and x25_process_rx_frame() can call x25_kick() and
transmit on the stale LCI.

x25_link_control() also sends the restart confirmation or request right
after x25_kill_by_neigh() returns. At that point the deferred sockets
still hold their LCIs on nb.

The transmit side has a similar gap. x25_link_terminated() purges
nb->queue and resets nb->state to X25_LINK_STATE_0. An owner that is
still in sendmsg can then reach
x25_kick()->x25_send_iframe()->x25_transmit_link():

net/x25/x25_link.c:x25_transmit_link() {
    ...
	case X25_LINK_STATE_0:
		skb_queue_tail(&nb->queue, skb);
		nb->state = X25_LINK_STATE_1;
		x25_establish_link(nb);
    ...
}

Would that re-establish a link that the peer just took down?

The RESTART_CONFIRMATION path in x25_link_control() sets nb->state to
X25_LINK_STATE_2. There, the queued frames would be flushed once state 3
is reached, on an LCI the restart already cleared.

Before 7781607938c8, the socket was disconnected right away (lci = 0,
neighbour = NULL). The unowned branch here does the same. With either,
none of these paths can happen.

> +					else
> +						x25_disconnect(s, ENETUNREACH,
> +							       0, 0);

[Severity: High]
This is a pre-existing issue and this patch did not introduce it, but the
new unowned branch adds another way to reach it. Can x25_sendmsg() and
x25_output() dereference a NULL x25->neighbour?

x25_sendmsg() checks x25->neighbour under the socket lock, then drops the
lock to allocate:

net/x25/af_x25.c:x25_sendmsg() {
    ...
	rc = -ENETUNREACH;
	if (!x25->neighbour)
		goto out;
    ...
	release_sock(sk);
	skb = sock_alloc_send_skb(sk, size, noblock, &rc);
	lock_sock(sk);
    ...
	if (msg->msg_flags & MSG_OOB) {
		if (x25->neighbour->extended) {
    ...
	} else {
		if (x25->neighbour->extended) {
    ...
}

x25_output() follows the same pattern in its fragmentation loop:

net/x25/x25_out.c:x25_output() {
    ...
			release_sock(sk);
			skbn = sock_alloc_send_skb(sk, frontlen + max_len,
						   noblock, &err);
			lock_sock(sk);
    ...
			if (skb->len > 0) {
				if (x25->neighbour->extended)
    ...
}

sock_alloc_send_pskb() checks sock_error() and SEND_SHUTDOWN only before
it allocates. Suppose x25_disconnect() runs after those checks and before
lock_sock() returns. Then x25->neighbour is NULL, and the next
x25->neighbour->extended faults.

Several softirq paths can do this while the socket is unowned:

- a CLEAR_REQUEST from the peer in state 3/4/5, via
  x25_receive_data()->x25_process_rx_frame()->x25_disconnect()
- T23 timer expiry
- with this patch, this branch, reached from x25_lapb_receive_frame() on
  X25_IFACE_DISCONNECT, or from x25_link_control() on a
  RESTART_REQUEST/RESTART_CONFIRMATION in X25_LINK_STATE_3

The window gets wider if another thread holds lock_sock() while sendmsg
waits in lock_sock(). Peer frames are then backlogged and processed by
x25_backlog_rcv() in that thread's release_sock().

7781607938c8, the commit in the Fixes: tag, was meant to close this class
of neighbour NULL dereference in sendmsg/recvmsg. Should x25_sendmsg()
and x25_output() check x25->neighbour (or sk_state) again after they
retake lock_sock()?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/00f667e3-a158-4fb5-84a3-9ecda4718ce8%40mail.kernel.org
