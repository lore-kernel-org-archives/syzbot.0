Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704374;
	b=5F+7I5jQUUwXHfCtNJlGmL712YiZxbtEzuD6xLeIKVagCwhQlqDZ+4K8CMvTJuDJjWbu
	 DSla81Abqu5j+54wq3FNaJfaxtzEhiSrHXUruyxQccdo4sdSkpdDDSo7yL7qHDAL7FtIe
	 5yUSCE/7mjUfhuwrnRSJPjOd/IQ++nEKuy7hYD/fZuXuG+1vNReKZYsbJFfHTYy2u0k4z
	 9v77ElAhSQZjtm20B2y/Y5cXDg/zxKM8ZToKBpgcLQj672bDc7lSkYmE7TBMwcVyAKmII
	 do5XQxjG997Sbq+FqKmbN5qjMLGZ86PTMdGWHvkpph9QqLfcbPQSUTj8MmPaSHEMmYQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=rn2z+MITaiyawKHvxSD2mOGFXJ1P6KSzr30+RyW3zQg=;
	b=Fw4drOS1BK4G8leoZQEIRH77odFyJalnDaqOEyZe24X+3awQ5lStVbNYCl9DZQEdiEDT
	 PB7Url+mRtGzMaxjt9fh8IpZpu+E4LlIOTCR3ZbNTCB8pphQwdTsysUnRd2TsiiVaHDl9
	 lIC0eeRhnXGuXwQh5K4jculSvVjLQyQu/zleU7abq1UHkKBaiGH3QPMv3lJguNS514pvN
	 3LRWe3+UcNLNQKKYQ+dkANH3J/x114EJgYIH2Qfi7hDnr6j+JSUEa/0Qk5STQe7nz1zOx
	 bZN6YgcAQiO9fN4yz7XlP0fWdoclwXLxAJxgg7WJzoItEkAgZ0aE7nT37IVqJ6HtrbQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cmB6Xzhk;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 177A8606A31E
	for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 14:46:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=cmB6Xzhk
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id AEBA51F000E6;
	Thu, 26 Nov 2026 14:46:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795704373;
	bh=rn2z+MITaiyawKHvxSD2mOGFXJ1P6KSzr30+RyW3zQg=;
	h=From:To:Cc:Subject:Date;
	b=cmB6XzhklUtmmG/EQUzEUfMZg6NOyvsi2u++u3VNYdVvi6tCvBaFcxECWUrN2PLrT
	 Zqcm/m+9U0R0T5/+vTMHZLYhVIg0Kq2ir8RV/4BOY1W7CrB+KtSojo5MwYcPw8xCKG
	 0Bd3MBnhDn+FFdU+JLAbn0BB0iL20QBIm+A5iqgcw55wa7BQXPhG6Hy6cg9c/MVfTk
	 fqW9+xaWrbb1noPXlEP817HtiuBRRNJ3fpD96tsGktMT8E7I9X1WffuzWaMUwLEu65
	 X7ig0x1ygeTGvomItyHu2rUDTUgn+urM6y8conKPcP31/EiGvmEVmB0qMSlJB5LM2G
	 11pY5RP6miPbA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: krystianmkaniewski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] netfilter: nft_synproxy: only handle a plain SYN or a plain ACK
Message-ID: <2afd11cc-186e-49de-8c72-d9f529532f9d@mail.kernel.org>
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
Date: Thu, 26 Nov 2026 14:46:13 +0000 (UTC)

nft_synproxy_eval_v4() and nft_synproxy_eval_v6() check tcp->syn and
tcp->ack without excluding other TCP control flags, unlike the xtables
SYNPROXY targets. As a result, a SYN+ACK (or SYN+FIN / SYN+RST) packet
reaching nft_synproxy is misidentified as an initial client SYN and
triggers another SYN+ACK reply, while FIN+ACK and RST+ACK packets enter the
client ACK branch and can be dropped with NF_DROP instead of continuing
through the ruleset.

On loopback, when an nftables input rule evaluates nft_synproxy, a local
SYN causes it to send a SYN+ACK back over loopback, which hits the same
rule again and matches tcp->syn. This creates an infinite SYN+ACK feedback
loop in softirq context that saturates the CPUs, starves tasks holding or
waiting on rtnl_mutex, and triggers hung task warnings (such as "INFO: task
kworker/R-ipv6_:60 blocked for more than 143 seconds" in
addrconf_dad_work).

Fix this in nft_synproxy_do_eval() by returning early when tcp->syn ==
tcp->ack || tcp->fin || tcp->rst before dispatching to
nft_synproxy_eval_v4() or nft_synproxy_eval_v6(). This ensures nft_synproxy
only handles a plain SYN or a plain ACK (without FIN or RST), while valid
TCP segments outside the client handshake such as SYN+ACK, FIN+ACK, and
RST+ACK—as well as other segments with FIN, RST, or neither SYN nor ACK
set—continue through the ruleset unchanged with regs->verdict.code left as
NFT_CONTINUE.

Fixes: ad49d86e07a4 ("netfilter: nf_tables: Add synproxy support")
Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+55141a0ffa0d17f01c71@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=55141a0ffa0d17f01c71
Link: https://syzkaller.appspot.com/ai_job?id=19d80d6e-8025-483e-ac1b-da92f0b2dde3
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
v3:
- Updated the commit title and description to plain text without Markdown backticks.
- Simplified the description of the loopback SYN-ACK feedback loop.
- Clarified that valid TCP segments outside the client handshake (such as SYN+ACK, FIN+ACK, and RST+ACK) continue through the ruleset unchanged.

v2:
- Moved the strict TCP flag check from `nft_synproxy_eval_v4()` and `nft_synproxy_eval_v6()` into `nft_synproxy_do_eval()`
- Replaced the per-branch flag checks with `if (tcp->syn == tcp->ack || tcp->fin || tcp->rst) return;`
- Updated the commit message to match the new implementation and removed the quoted hung-task and NMI backtrace excerpt
https://lore.kernel.org/all/751ce8c9-049b-4177-8873-cea240e356e7@mail.kernel.org/T/

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
