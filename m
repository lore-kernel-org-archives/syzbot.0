Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC88318DB37
	for <syzbot@lists.linux.dev>; Tue, 23 Jun 2026 15:32:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782228774; cv=none; b=DRKCjN4KNQgs7dg6HI1EjrOoQe4CtDi4BPbIMbrlVYPfUnxEFpTxBmo8MTTYd91mssJZ9XwV8UEPxD5nJfXqGW4hF4hX9Aw+BV9BUWGTRQvKtGDVrHporLKxxuIz8RZbP0Sfflh9UK3mBaWgRwsXjPRusOjEV6830vvsjnsdDc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782228774; c=relaxed/simple;
	bh=U871hlwsmP+7R6y4WrNTj8pdKR3i6EOE0OCBfn3DmOA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=davFNEOXqAL2yZ/G0uRq5YwebpQrfkboi/jxWbkJLOxN2JcO2VIuCkybVbTHYGgaGx40mvRdSzS3qiMuScncytnngLrH/zmiJr5G0FN218DFYkWA9gRMin0ty0oGG7kt5f4fm0hOmVrby9yjGzT9w4H3IU+wnW5xJjeoE8ejtdw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H51qLuWk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H51qLuWk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6FAB01F00A3A;
	Tue, 23 Jun 2026 15:32:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782228772;
	bh=nbI7Yq5g6vpSv0Hi1swdOnTuHJsvPSGncjZMqNZy0NA=;
	h=From:To:Cc:Subject:Date;
	b=H51qLuWkW25Vg8A6TK5DxqBKA/wteVISXo0HEszZZGMoFWoOCNkZDTQgbwplSwFz8
	 MNPt/F/in55Pj+8quKgRdqwIzk2C0xvPrHiujKp9xRoz2WCRLdIkz2df3mD7uhf2fb
	 ASxszu3nciRuRkXm6GhlTmwrnY1JGimTxdawS01Colwqmgf7Vlnc2i96/FhgPseqMG
	 gsphI9MDgEgLm0eKuHOr+sX6ySIPy+CsQbnZi/wi4vIZ84Iq54U4tj/YNWGswgxYKN
	 UAVYWA4G2Row4cxuR5SVErfCJMUZRw/O0I9ypFd5G8ponVxGlUaHGkmQ/eueRaVfiT
	 8Y40VPZF5/yJA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] netfilter: nf_conntrack_bridge: handle vlan-tagged packets in refrag
Message-ID: <87b2c45b-2000-485b-8d36-979202a7c365@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 23 Jun 2026 15:32:52 +0000 (UTC)

When a fragmented packet arrives at a bridge port with a hardware VLAN tag,
the bridge's RX VLAN offload populates skb->vlan_tci and sets skb->protocol
to the inner payload protocol (e.g., ETH_P_IP). If the packet is
defragmented in the NF_BR_PRE_ROUTING hook, the maximum fragment size is
recorded in the bridge control block.

Later, if the bridge's VLAN filtering logic detects a protocol mismatch
(e.g., skb->vlan_proto differs from br->vlan_proto), it pushes the VLAN tag
back into the packet payload using vlan_insert_tag_set_proto(). This
changes skb->protocol to the VLAN protocol (e.g., ETH_P_8021AD).

When the packet reaches the NF_BR_POST_ROUTING hook, nf_ct_bridge_post()
determines that the packet needs to be refragmented and calls
nf_ct_bridge_refrag(). However, nf_ct_bridge_refrag() expects skb->protocol
to be IPv4 or IPv6. Since it is now a VLAN protocol, the switch statement
hits the default case, triggering a WARN_ON_ONCE and dropping the packet:

WARNING: net/bridge/netfilter/nf_conntrack_bridge.c:356 at
nf_ct_bridge_refrag
...
Call Trace:
 <TASK>
 nf_hook_entry_hookfn include/linux/netfilter.h:158 [inline]
 nf_hook_slow+0xc5/0x220 net/netfilter/core.c:619
 nf_hook include/linux/netfilter.h:273 [inline]
 NF_HOOK+0x23e/0x3f0 include/linux/netfilter.h:316
 br_forward_finish+0xd3/0x130 net/bridge/br_forward.c:66
 NF_HOOK+0x360/0x3f0 include/linux/netfilter.h:318
 __br_forward+0x397/0x540 net/bridge/br_forward.c:115
 deliver_clone net/bridge/br_forward.c:131 [inline]
 maybe_deliver+0xb5/0x160 net/bridge/br_forward.c:191
 br_flood+0x316/0x690 net/bridge/br_forward.c:238
 br_handle_frame_finish+0x10f8/0x1930 net/bridge/br_input.c:229

To fix this, update nf_ct_bridge_refrag() to handle packets where the VLAN
tag has been pushed into the payload. If the protocol is a VLAN protocol,
use vlan_get_protocol_offset_inline() to extract the inner protocol and
pull the VLAN tags so skb->data points directly to the IP header, as
expected by the fragmentation routines.

Additionally, because the MAC header is no longer exactly ETH_HLEN bytes
when VLAN tags are pushed into the payload, expand the mac array in struct
nf_bridge_frag_data to 32 bytes and add a mac_len field to dynamically
track the actual length. Update nf_ct_bridge_frag_save() and
nf_ct_bridge_frag_restore() to save and restore the correct number of
bytes, pushing any extra bytes beyond ETH_HLEN to ensure skb->data
correctly points to the start of the MAC header before transmission.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Assisted-by: Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+a8ba738fe2db6b4bb27f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a8ba738fe2db6b4bb27f
Link: https://syzkaller.appspot.com/ai_job?id=4867c9de-cc2a-406b-a01c-4321a64f38ec
To: <bridge@lists.linux.dev>
To: <coreteam@netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Florian Westphal" <fw@strlen.de>
To: "Ido Schimmel" <idosch@nvidia.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: <netfilter-devel@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
To: "Nikolay Aleksandrov" <razor@blackwall.org>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Phil Sutter" <phil@nwl.cc>

---
diff --git a/include/linux/netfilter_bridge.h b/include/linux/netfilter_bridge.h
index 743475ca7..4ff36e0f3 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -6,7 +6,8 @@
 #include <linux/skbuff.h>
 
 struct nf_bridge_frag_data {
-	char    mac[ETH_HLEN];
+	char mac[32];
+	u8 mac_len;
 	bool    vlan_present;
 	u16     vlan_tci;
 	__be16  vlan_proto;
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 58a33d038..a2a4b821a 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -330,7 +330,13 @@ static void nf_ct_bridge_frag_save(struct sk_buff *skb,
 	} else {
 		data->vlan_present = false;
 	}
-	skb_copy_from_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_HLEN);
+	data->mac_len = skb->mac_len;
+	if (WARN_ON_ONCE(data->mac_len < ETH_HLEN))
+		data->mac_len = ETH_HLEN;
+	if (WARN_ON_ONCE(data->mac_len > sizeof(data->mac)))
+		data->mac_len = sizeof(data->mac);
+	skb_copy_from_linear_data_offset(skb, -data->mac_len, data->mac,
+					 data->mac_len);
 }
 
 static unsigned int
@@ -340,10 +346,30 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 				  struct sk_buff *))
 {
 	struct nf_bridge_frag_data data;
+	__be16 inner_proto = skb->protocol;
+	int depth;
 
 	if (!BR_INPUT_SKB_CB(skb)->frag_max_size)
 		return NF_ACCEPT;
 
+	if (eth_type_vlan(inner_proto)) {
+		int pull_len;
+
+		inner_proto = vlan_get_protocol_offset_inline(
+			skb, inner_proto, skb_mac_offset(skb), &depth);
+		if (!inner_proto)
+			return NF_DROP;
+
+		pull_len = depth + skb_mac_offset(skb);
+		if (pull_len > 0) {
+			if (!pskb_may_pull(skb, pull_len))
+				return NF_DROP;
+
+			skb_pull(skb, pull_len);
+		}
+		skb->protocol = inner_proto;
+	}
+
 	nf_ct_bridge_frag_save(skb, &data);
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
@@ -366,7 +392,7 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
 {
 	int err;
 
-	err = skb_cow_head(skb, ETH_HLEN);
+	err = skb_cow_head(skb, data->mac_len);
 	if (err) {
 		kfree_skb(skb);
 		return -ENOMEM;
@@ -376,8 +402,11 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
 	else if (skb_vlan_tag_present(skb))
 		__vlan_hwaccel_clear_tag(skb);
 
-	skb_copy_to_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_HLEN);
+	skb_copy_to_linear_data_offset(skb, -data->mac_len, data->mac,
+				       data->mac_len);
+	__skb_push(skb, data->mac_len - ETH_HLEN);
 	skb_reset_mac_header(skb);
+	skb->mac_header -= ETH_HLEN;
 
 	return 0;
 }


base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
