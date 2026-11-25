Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624985;
	b=KRDoW7jZ4T6r7gExrKp2up/K2S3GMXlpzuHgn63tzVllM/zvMB56Q3G4JCjJkh7t1leZ
	 u0WbivJnf0kw/RkUh2BAS3biw4v7XRFtkT90mFTlTwUvurZ7RGxWN5sPOF77KFXWAbAFG
	 uVIRiOqp9hrqhNzNC5XMLwT9eY8C3lVEzWWJ1YNUEoheOLls7DlmKAJiRwmRL7plcozUl
	 k/kiIto/QkjroMPr5enmz7imShQ/rLUFuo8Xj8GTzrDmsPwxRYgTcfYu+IurlNPsvECL+
	 oD19YYLcsCVy4PqPxBwXKRBWLexGzFJ1RP5rxeJBwpmSi7R1o03u1zOmlgG4+BZW/NQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624985;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=X2CW74tDd0SN7AyaRqaLpvAU5298jQFR27LRHz5q3us=;
	b=kHzrL4qyx3BNkh9hUdKgULZFbXzXhFXfrY/sGkZf56jat6tzzKBqaRw35kMp9kVFLXky
	 CP8W6QkEh/8MoidCTBtQHEqTZJovOCJ+oxnO1myZsflPR5AiRkKC64EqthV2afFAzDj/U
	 RC50runuTwjCkechODYifSgEXK5FwIeuiQNein5jvAyRIXs7OXeDNEXvRyRK+5WaiXm0x
	 IdAikifryXcxd1iggYqTYR2l/aMvV+/lqyE9z41aW+DiksVMD6wmrYqzY/tHouOnLTB/k
	 WYHntl5ALZVxsBizPZbVJagzq4YWttum83Sqghz6GU9fDc8aV9ukD8fIllbAc0f8/ug==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NoeDWX3P;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 89D6C606A31E
	for <syzbot@lists.linux.dev>; Wed, 25 Nov 2026 16:43:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=NoeDWX3P
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 397021F000C0;
	Wed, 25 Nov 2026 16:43:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795624985;
	bh=X2CW74tDd0SN7AyaRqaLpvAU5298jQFR27LRHz5q3us=;
	h=From:To:Cc:Subject:Date;
	b=NoeDWX3PgcGJr2/YGa4N4AlaRmNcwyGQwypPba35nZlHggqJxH6fvh3vxBPhYwMzr
	 hhFbWMdkLCnOkDU++diOoTeiJEsy/6iyfzSlr/c0RSHmf/SbRYS+JRkG0+tWeqPssu
	 bhDpGRkDjeX8JASLjL62kh5XbpQAJCcU98hoA6cV2YNoOSTaOSYWc9KaTsEQGlhDCr
	 Q+YymW6WXfyvrzVPdVsb3nRHhIxeb91BzMnhCxVZ6qC4O/X36VHtciqaJp+VotPRQf
	 7cpxOtOQLmjYz02VTSv3aAiqpOK94cPQ/4dv52FX5IR9cz6deTTSiB4H5bv8wjLelh
	 R8M2SdTBtsTaw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] netfilter: nft_synproxy: enforce strict TCP flag matching
Message-ID: <751ce8c9-049b-4177-8873-cea240e356e7@mail.kernel.org>
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
Date: Wed, 25 Nov 2026 16:43:05 +0000 (UTC)

In `nft_synproxy_eval_v4()` and `nft_synproxy_eval_v6()`, TCP control flags
are checked only with `if (tcp->syn)` and `else if (tcp->ack)` without
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
`process_backlog()` in `NET_RX_SOFTIRQ` delivers that generated SYN+ACK
back through the same input rule on `NF_INET_LOCAL_IN`, `if (tcp->syn)`
matches again and sustains an infinite SYN+ACK feedback loop in softirq
context, saturating the CPUs, starving tasks holding or waiting on
`rtnl_mutex`, and triggering hung task warnings.

Fix this by filtering out invalid TCP flag combinations in
`nft_synproxy_do_eval()` before dispatching to `nft_synproxy_eval_v4()` or
`nft_synproxy_eval_v6()`: return early when `tcp->syn == tcp->ack ||
tcp->fin || tcp->rst`. This rejects packets with FIN or RST set, packets
with neither SYN nor ACK set, and SYN+ACK packets, ensuring only SYN-only
or ACK-only control packets (without FIN/RST) reach the v4/v6 evaluation
helpers while unrelated control packets fall through with
`regs->verdict.code` left as `NFT_CONTINUE`.

Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+55141a0ffa0d17f01c71@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=55141a0ffa0d17f01c71
Link: https://syzkaller.appspot.com/ai_job?id=01904981-72da-437f-a636-e56909e8bc78
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
v2:
- Moved the strict TCP flag check from `nft_synproxy_eval_v4()` and `nft_synproxy_eval_v6()` into `nft_synproxy_do_eval()`
- Replaced the per-branch flag checks with `if (tcp->syn == tcp->ack || tcp->fin || tcp->rst) return;`
- Updated the commit message to match the new implementation and removed the quoted hung-task and NMI backtrace excerpt

v1:
https://lore.kernel.org/all/96d0756e-28cd-4b99-b0c7-17698acc8276@mail.kernel.org/T/
---
diff --git a/net/netfilter/nft_synproxy.c b/net/netfilter/nft_synproxy.c
index 554a96a00..aa8dea698 100644
--- a/net/netfilter/nft_synproxy.c
+++ b/net/netfilter/nft_synproxy.c
@@ -137,6 +137,9 @@ static void nft_synproxy_do_eval(const struct nft_synproxy *priv,
 		return;
 	}
 
+	if (tcp->syn == tcp->ack || tcp->fin || tcp->rst)
+		return;
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		nft_synproxy_eval_v4(priv, regs, pkt, tcp, &_tcph, &opts);


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
