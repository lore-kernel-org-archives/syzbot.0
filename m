Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795541325;
	b=D/D7H0HVW/g2NajJxqE9c/Y09wkAdxRP5NOPV5AcCKphWa2X0Q3rEoyJiQ1ZpBdhBehz
	 HSBNhXM3iT55u2MbPIku7hhB8t4s3LFLqx9ZNDtY0hkQtu7N/0ffZSBPCXrjy+TTYXdpK
	 QV08sNB03i7+XiPZkhXrH5Z1ngBhOkWPMogykjPZgwwAhas8S+lHDWxq/WmI94FPLiGjC
	 yyqgn/KOrPI5MaGwtH9zJVgp9fuqjXStDKdV4/EQ/SScTfjTmPttis2TvKxc0WNv7rgqB
	 soUMvMUmTYDo64Jpz3whrFVdLHls3AAolQYJFbEjsFgkX2Ss/qNZUqqL/9wD8FVr+NA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795541325;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=l6e/8JVuQbMx8SX9yD6wyFqc8ayEOc8g3GDuMvApw90=;
	b=FcSlWzO8/7VffhhH+Bj3m5ObbM6RODnvQQEz+oDY70JBao/pJg/fnhkZRDXVtFI6TJD+
	 +BHKUsHe7mu/i1RkS5o8GWkCvPczoCBqNp3IiT63Aq/EMV2tAqFQmeIo8+YC4SG0jynUI
	 fH18V0yiIwdioracv1ccdXVAD3Upa8UKSjH0y3wi0v30u1fmHvirzgNsFg5rnW+kypYFg
	 hR0xRuEHNfX5NeNbyJePiubwqF2VCJi6wi1tH79ATEAZFryOGp7jpTLMSv6zet9WRKf+X
	 8lWmILFwDryMQ5uOVhM8J8GLYa85tdjubW2rxmTcqS4remtKXWOuNX3RXWWeYJRM8zw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fJ23Mvbt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id EF578606A323
	for <syzbot@lists.linux.dev>; Tue, 24 Nov 2026 17:28:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=fJ23Mvbt
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 23CB41F000C0;
	Tue, 24 Nov 2026 17:28:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795541324;
	bh=l6e/8JVuQbMx8SX9yD6wyFqc8ayEOc8g3GDuMvApw90=;
	h=From:To:Cc:Subject:Date;
	b=fJ23MvbthPzC2UQH+/QOrR2au9V4gvt/lbmxt80zbMLHEr9V4aWnEWZC8yLra3N9Y
	 W5GFxmsgBeYzACsBQc26XjObOqlvm5xWBy9ygyCjqxlgwvdytd0oBD1LpJ4wU7OLZR
	 HHWq0YV5H0lCzdgas3xnA0TdxxFBx3brH8eZi+ea8E+UvxSDiQKNvtuaoeXlRNY4cR
	 /XjvOkMNs5yTfGYGF+BtjsIhMaRMnyEzMTSTgIwEjYTNYE8mmsgwy00hrcVr/RAtuv
	 ziDktF2Ud5kM4o7Um2XsKwbP6t94epGSI3ioi/yx93qQdML6c64Q74qUkaj7WlOZf/
	 UDsjua7/INnTw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] netfilter: nft_synproxy: enforce strict TCP flag matching
Message-ID: <96d0756e-28cd-4b99-b0c7-17698acc8276@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 24 Nov 2026 17:28:44 +0000 (UTC)

In nft_synproxy_eval_v4() and nft_synproxy_eval_v6(), TCP control flags are
checked only with `if (tcp->syn)` and `else if (tcp->ack)` without
excluding other flags, unlike the xtables SYNPROXY targets
(`synproxy_tg4()` and `synproxy_tg6()`). As a result, a SYN+ACK (or SYN+FIN
/ SYN+RST) packet reaching `nft_synproxy` is misidentified as an initial
client SYN and causes `synproxy_send_client_synack()` or
`synproxy_send_client_synack_ipv6()` to reply with another SYN+ACK.
Likewise, FIN+ACK and RST+ACK packets enter the client ACK branch and can
be dropped with NF_DROP instead of continuing through the ruleset.

When an nftables rule evaluates `nft_synproxy` (either via the inline
expression or a stateful `NFT_OBJECT_SYNPROXY` object) on
`NF_INET_LOCAL_IN`, a local TCP SYN over loopback triggers
`nft_synproxy_eval_v4()` to send a SYN+ACK with swapped addresses and ports
and a fresh TTL via `synproxy_send_client_synack()`. When
`process_backlog()` in `NET_RX_SOFTIRQ` delivers that SYN+ACK back to
`NF_INET_LOCAL_IN`, `if (tcp->syn)` matches again, creating an infinite
SYN+ACK loop in softirq context. This saturates the CPUs, starves tasks
holding or waiting on `rtnl_mutex`, and triggers hung task warnings:

INFO: task kworker/R-ipv6_:60 blocked for more than 144 seconds.
Workqueue: ipv6_addrconf addrconf_dad_work
Call Trace:
 __mutex_lock+0x7c4/0x15a0 kernel/locking/mutex.c:821
 rtnl_net_lock include/linux/rtnetlink.h:134 [inline]
 addrconf_dad_work+0x116/0x15c0 net/ipv6/addrconf.c:4256

NMI backtrace for cpu 1
 __kfree_skb+0x5d/0x210 net/core/skbuff.c:1203
 nft_synproxy_eval_v4+0x36a/0x4e0 net/netfilter/nft_synproxy.c:-1
 nft_synproxy_do_eval+0x389/0x5d0 net/netfilter/nft_synproxy.c:142
 expr_call_ops_eval net/netfilter/nf_tables_core.c:237 [inline]
 nft_do_chain+0x48d/0x1b10 net/netfilter/nf_tables_core.c:285
 nft_do_chain_ipv4+0x195/0x290 net/netfilter/nft_chain_filter.c:24
 process_backlog+0xa6b/0x18b0 net/core/dev.c:6915

Fix this by enforcing the same strict TCP flag checks as `ipt_SYNPROXY` and
`ip6t_SYNPROXY` in both `nft_synproxy_eval_v4()` and
`nft_synproxy_eval_v6()`: require `tcp->syn && !(tcp->ack || tcp->fin ||
tcp->rst)` for the initial SYN branch and `tcp->ack && !(tcp->fin ||
tcp->rst || tcp->syn)` for the client ACK branch. Excluding `tcp->syn` from
the ACK branch ensures SYN+ACK packets are not passed to
`synproxy_recv_client_ack()` or `synproxy_recv_client_ack_ipv6()` and
dropped, while unrelated control packets fall through with
`regs->verdict.code` left as `NFT_CONTINUE`.

Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-4-carbon syzbot
Reported-by: syzbot+55141a0ffa0d17f01c71@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=55141a0ffa0d17f01c71
Link: https://syzkaller.appspot.com/ai_job?id=d414ed29-2420-4a5b-b4af-0b7b7dc8df30
To: <coreteam@netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@kernel.org>
To: "Florian Westphal" <fw@strlen.de>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: <netfilter-devel@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
To: "Fernando Fernandez Mancera" <ffmancera@riseup.net>
Cc: "Simon Horman" <horms@kernel.org>
Cc: "Phil Sutter" <phil@nwl.cc>

---
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 554a96a00..ad43faf1d 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -53,13 +53,13 @@ static void nft_synproxy_eval_v4(const struct nft_synproxy *priv,
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
 
-	if (tcp->syn) {
+	if (tcp->syn && !(tcp->ack || tcp->fin || tcp->rst)) {
 		/* Initial SYN from client */
 		nft_synproxy_tcp_options(opts, tcp, snet, &info);
 		synproxy_send_client_synack(net, skb, tcp, opts);
 		consume_skb(skb);
 		regs->verdict.code = NF_STOLEN;
-	} else if (tcp->ack) {
+	} else if (tcp->ack && !(tcp->fin || tcp->rst || tcp->syn)) {
 		/* ACK from client */
 		if (synproxy_recv_client_ack(net, skb, tcp, opts,
 					     ntohl(tcp->seq))) {
@@ -84,13 +84,13 @@ static void nft_synproxy_eval_v6(const struct nft_synproxy *priv,
 	struct synproxy_net *snet = synproxy_pernet(net);
 	struct sk_buff *skb = pkt->skb;
 
-	if (tcp->syn) {
+	if (tcp->syn && !(tcp->ack || tcp->fin || tcp->rst)) {
 		/* Initial SYN from client */
 		nft_synproxy_tcp_options(opts, tcp, snet, &info);
 		synproxy_send_client_synack_ipv6(net, skb, tcp, opts);
 		consume_skb(skb);
 		regs->verdict.code = NF_STOLEN;
-	} else if (tcp->ack) {
+	} else if (tcp->ack && !(tcp->fin || tcp->rst || tcp->syn)) {
 		/* ACK from client */
 		if (synproxy_recv_client_ack_ipv6(net, skb, tcp, opts,
 						  ntohl(tcp->seq))) {


base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
