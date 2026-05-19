Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C087723393E
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 20:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779223269; cv=none; b=DkWFr3moTl4uVXSI6xORnjcA2NovFHYVixs40QL2uXUdZaSOLRVrUW8IqmJBiJwuIXD7LLBbum+GeWBuxE1maJv9W7nekPu/LV4eO1mQcQTT0lGKSiYYx5zGS9VdUU06e2gT5N+TyI20vgkAr3+jZnSHHiZvYp4/+BlVpKd7/pQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779223269; c=relaxed/simple;
	bh=iKt/yfZYMQyDLNMxgm2GdT23H2CzmsUYFzbSJs1S+E8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=QDWx6g/3U6wah9sCVPJCMH5mUvnDyyBe3acyEMcD59osicMraA6hGmc4gMfSFgatXA7qHbTGCJ7RTkmu2Wn4aXgH76jH6VhMopEHRZN9Lo62Z1m76pOG7xJ4UcTA8/sJAJD0+Q9OHIxluCY8zafA3Eq/1n95v2fWQbfeeMoovgU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=NnIbUqOt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="NnIbUqOt"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 4EE1E1F000E9;
	Tue, 19 May 2026 20:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779223268;
	bh=HW1mnqsSnWAhtfs2j3EBZ0erYdoTG5B0Z3+gtM1tn+Y=;
	h=From:To:Cc:Subject:Date;
	b=NnIbUqOtpAi/oZad152DG28XwqX4fOX8wFsuvLB1SDtgskq4pPr0WJ0Y4SI1KuN9a
	 bSYtnuY1H6BHhy1QRgJUHHH2TczNA/6oPmykc/nHET8nNTMtO9Glc1zz8o522177Ic
	 RFAkrMohSlXYA9oJeGESvBx3Qxa2EovfvK+HfReeBIeIwhbV6obAM437bOqkmdOqsT
	 TYopgOeb+p649bRiAEInWJW770crEdUmtmrWQFca/KNGw2abVBpDv6HIhJzOkmd98s
	 4OVV79s7MVbNJlZ1OVJ0klhHBrSAhE9L+5kcwCzJm75vWsMhO3uzU04P1WnFxlWZpH
	 SbnZGJjhUGKaA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] bpf: Prevent uninitialized value access in eth_type_trans()
Message-ID: <b64a1d16-5cb4-42cb-aef6-381d61279b83@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 19 May 2026 20:41:08 +0000 (UTC)

syzkaller reported a KMSAN uninitialized value crash in
eth_type_trans():

BUG: KMSAN: uninit-value in eth_type_trans+0x68f/0xae0
net/ethernet/eth.c:176
 eth_type_trans+0x68f/0xae0 net/ethernet/eth.c:176
 __dev_forward_skb2+0x4b1/0x940 net/core/dev.c:2443
 dev_forward_skb_nomtu+0x3b/0xe0 net/core/dev.c:2482
 __bpf_rx_skb net/core/filter.c:2125 [inline]
 __bpf_redirect_common net/core/filter.c:2200 [inline]
 __bpf_redirect+0x14d7/0x1760 net/core/filter.c:2207

The root cause is a missing check in __bpf_redirect_common() and
__bpf_redirect_neigh() when an L3 BPF program redirects a packet to an
L2 device. For example, when bpf_prog_test_run_skb() runs an L3 BPF
program, it pulls the MAC header. If the BPF program then redirects the
packet to an L2 device without pushing the MAC header back (e.g.,
leaving skb->data pointing to the network header), the redirected packet
will have an invalid MAC header offset.

When the packet reaches eth_type_trans(), it assumes skb->data points to
a valid MAC header and attempts to read the protocol type. Since
skb->data actually points to the network header, this results in an
out-of-bounds read. If the skb head was previously reallocated (e.g.,
via pskb_expand_head() during bpf_clone_redirect()), this out-of-bounds
read accesses uninitialized memory, triggering the KMSAN bug.

Fix this by adding a check for skb_mac_offset(skb) != 0 in
__bpf_redirect_common() and __bpf_redirect_neigh(). This ensures that
skb->data points to the MAC header before forwarding the packet to an L2
device, dropping malformed packets early in the forwarding path.
Additionally, ensure skb->len is large enough to cover the MAC header in
__bpf_redirect_common() and __bpf_redirect_neigh().

Fixes: 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+0901d0cc75c3d716a3a3@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=0901d0cc75c3d716a3a3
Link: https://syzkaller.appspot.com/ai_job?id=cddb4a7a-03e0-44a9-96e0-ebd8e8866f34
To: <davem@davemloft.net>
To: <edumazet@google.com>
To: <kuba@kernel.org>
To: <linux-kernel@vger.kernel.org>
To: <pabeni@redhat.com>
Cc: <andrii@kernel.org>
Cc: <ast@kernel.org>
Cc: <bpf@vger.kernel.org>
Cc: <daniel@iogearbox.net>
Cc: <eddyz87@gmail.com>
Cc: <horms@kernel.org>
Cc: <john.fastabend@gmail.com>
Cc: <jolsa@kernel.org>
Cc: <martin.lau@linux.dev>
Cc: <memxor@gmail.com>
Cc: <netdev@vger.kernel.org>
Cc: <sdf@fomichev.me>
Cc: <song@kernel.org>
Cc: <yonghong.song@linux.dev>

---
v2:
- Changed patch title to indicate prevention of uninitialized value access.
- Included a portion of the KMSAN crash stack trace in the commit description.
- Updated __bpf_redirect_common() to check skb->len < skb->network_header - skb->mac_header instead of skb->len == 0.
- Updated __bpf_redirect_neigh() to check skb->len < sizeof(*ethh) instead of skb->len == 0.

v1:
https://lore.kernel.org/all/2cdda92f-08ad-4bc5-a2cb-b2bf9c8d222d@mail.kernel.org/T/
---
diff --git a/net/core/filter.c b/net/core/filter.c
index 9590877b0..dfa97d9a5 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2190,7 +2190,9 @@ static int __bpf_redirect_common(struct sk_buff *skb, struct net_device *dev,
 				 u32 flags)
 {
 	/* Verify that a link layer header is carried */
-	if (unlikely(skb->mac_header >= skb->network_header || skb->len == 0)) {
+	if (unlikely(skb->mac_header >= skb->network_header ||
+		     skb->len < skb->network_header - skb->mac_header ||
+		     skb_mac_offset(skb) != 0)) {
 		kfree_skb(skb);
 		return -ERANGE;
 	}
@@ -2430,7 +2432,8 @@ static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev,
 {
 	struct ethhdr *ethh = eth_hdr(skb);
 
-	if (unlikely(skb->mac_header >= skb->network_header))
+	if (unlikely(skb->mac_header >= skb->network_header ||
+		     skb->len < sizeof(*ethh) || skb_mac_offset(skb) != 0))
 		goto out;
 	bpf_push_mac_rcsum(skb);
 	if (is_multicast_ether_addr(ethh->h_dest))


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
