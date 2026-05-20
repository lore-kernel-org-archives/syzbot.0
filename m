Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C810D3043B2
	for <syzbot@lists.linux.dev>; Wed, 20 May 2026 23:14:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779318892; cv=none; b=jW6dYy25NAFAUXUIa/XkIoQ4TfwdcyNfFuwbQFIicAietxzgRbAzyLYP52kMv+Z4ldH3i3qoX+9zn76r+qYW9PjLVo8iL3TmFp1p8a0IM6IUKfzI3IgSfGtW6kaPIl0g3RDgiV47mwko9G7bz3LIL9izWyNiiTqYHicJEj0LPd4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779318892; c=relaxed/simple;
	bh=JUoVx4kKbB87PndvMsfZkdPnaD5R+W16wZa8rAJpbJs=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=puuELKLnNO+DrcHliDLGQZ10TG1wadTDctpwM9A/S3HHatyagUIrlpmCmk+8U8fsTgwcLMhif1j5udeGWKqXPQalk0dFXANedsHqi4bxm+/8jwUzlzAtVbDQGY2c7ooCcx1xJqb63tDyNtDiHnWNbzoyWm0YkejdfYc822GPA0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N9ak90pk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N9ak90pk"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 95FF81F000E9;
	Wed, 20 May 2026 23:14:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779318890;
	bh=XycwTtvipppjmzLRlx3/xwBCRF0UZCzKNqH14Hljy30=;
	h=From:To:Cc:Subject:Date;
	b=N9ak90pk21bvYyrMGoIMHucAW43BIHMxciPNWiTCzepm+1b4Yi0gmAM13xCC9f1aW
	 lqez71p+7m878wP2G00eTjI617Pyv95X5TfI0/t2JIvOhWJemFxMemsdWin0RyjhB9
	 euMPO0sLDkBfuEyZrIxteKOQUc0cvetfZq2MIsFgXbOebqXcc8Uiw1hRDqno1WdIrX
	 3fnAEA5nqHa0G8W18qRcdjnYtq4bYdtZLdQDM3yIH55XWBjGCcBXGJAyKLTVbhuRRp
	 oFNTrV8xwIfbo/KaXK0TVsktf6si6OWoQbHZ7RWz20ZCRkuq+msnbGhpwpfZL3XJtK
	 pESfk9xEXMoyQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] netfilter: bridge: fix VLAN protocol mismatch in nf_ct_bridge_refrag
Message-ID: <00558653-6963-4e86-b4b4-3c0d4ee1977f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 20 May 2026 23:14:50 +0000 (UTC)

The root cause of this bug is that nf_ct_bridge_refrag() expects
skb->protocol to be ETH_P_IP or ETH_P_IPV6, and skb->data to point to
the network header. However, if a VLAN tag was pushed into the payload
during bridge forwarding (e.g., due to a VLAN protocol mismatch in
br_allowed_ingress() or tc rules), skb->protocol becomes ETH_P_8021Q (or
ETH_P_8021AD), and skb->data points to the VLAN tag instead of the
network header. This causes nf_ct_bridge_refrag() to hit the default
case in the switch statement and trigger a WARN_ON_ONCE(1). Furthermore,
even if the switch statement was bypassed, nf_br_ip_fragment() would
read the VLAN tag as the IP header, leading to corruption or crashes.
Additionally, nf_ct_bridge_frag_save() and nf_ct_bridge_frag_restore()
assume the MAC header is exactly ETH_HLEN (14 bytes) long, failing to
save and restore the VLAN tag in the payload, which causes the fragments
to lose the VLAN tag.

To fix this, we need to properly handle packets with VLAN tags in the
payload during refragmentation. We expand struct nf_bridge_frag_data to
store up to 32 bytes of the MAC header, along with the actual mac_len
and the original skb->protocol. In nf_ct_bridge_frag_save(), we save the
entire MAC header (including any VLAN tags) and the original protocol.
In nf_ct_bridge_refrag(), if the MAC header is larger than ETH_HLEN
(indicating a VLAN tag in the payload), we temporarily push skb->data to
the MAC header to use vlan_get_protocol() to find the inner protocol
(e.g., ETH_P_IP), and then pull skb->data to the network header. This
ensures nf_br_ip_fragment() sees the correct protocol and IP header.
Finally, in nf_ct_bridge_frag_restore(), we restore the entire saved MAC
header and the original protocol, carefully adjusting skb->data and
skb->mac_header so that br_dev_queue_push_xmit() works correctly.

Fixes: 3c171f496ef5 ("netfilter: bridge: add connection tracking system")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+a8ba738fe2db6b4bb27f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a8ba738fe2db6b4bb27f
Link: https://syzkaller.appspot.com/ai_job?id=d2874cff-e6fe-4bb5-807f-dd0552282866
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
index 743475ca7..7919223ba 100644
--- a/include/linux/netfilter_bridge.h
+++ b/include/linux/netfilter_bridge.h
@@ -6,10 +6,12 @@
 #include <linux/skbuff.h>
 
 struct nf_bridge_frag_data {
-	char    mac[ETH_HLEN];
+	char mac[32];
 	bool    vlan_present;
 	u16     vlan_tci;
 	__be16  vlan_proto;
+	u16 mac_len;
+	__be16 orig_proto;
 };
 
 #if IS_ENABLED(CONFIG_BRIDGE_NETFILTER)
diff --git a/net/bridge/netfilter/nf_conntrack_bridge.c b/net/bridge/netfilter/nf_conntrack_bridge.c
index 58a33d038..a2d85e799 100644
--- a/net/bridge/netfilter/nf_conntrack_bridge.c
+++ b/net/bridge/netfilter/nf_conntrack_bridge.c
@@ -6,6 +6,7 @@
 #include <linux/netfilter_bridge.h>
 #include <linux/module.h>
 #include <linux/skbuff.h>
+#include <linux/if_vlan.h>
 #include <linux/icmp.h>
 #include <linux/sysctl.h>
 #include <net/route.h>
@@ -320,8 +321,8 @@ static unsigned int nf_ct_bridge_in(void *priv, struct sk_buff *skb,
 	return NF_ACCEPT;
 }
 
-static void nf_ct_bridge_frag_save(struct sk_buff *skb,
-				   struct nf_bridge_frag_data *data)
+static int nf_ct_bridge_frag_save(struct sk_buff *skb,
+				  struct nf_bridge_frag_data *data)
 {
 	if (skb_vlan_tag_present(skb)) {
 		data->vlan_present = true;
@@ -330,7 +331,12 @@ static void nf_ct_bridge_frag_save(struct sk_buff *skb,
 	} else {
 		data->vlan_present = false;
 	}
-	skb_copy_from_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_HLEN);
+	data->mac_len = skb->network_header - skb->mac_header;
+	if (data->mac_len > sizeof(data->mac))
+		return -E2BIG;
+	memcpy(data->mac, skb_mac_header(skb), data->mac_len);
+	data->orig_proto = skb->protocol;
+	return 0;
 }
 
 static unsigned int
@@ -340,11 +346,23 @@ nf_ct_bridge_refrag(struct sk_buff *skb, const struct nf_hook_state *state,
 				  struct sk_buff *))
 {
 	struct nf_bridge_frag_data data;
+	int err;
 
 	if (!BR_INPUT_SKB_CB(skb)->frag_max_size)
 		return NF_ACCEPT;
 
-	nf_ct_bridge_frag_save(skb, &data);
+	err = nf_ct_bridge_frag_save(skb, &data);
+	if (err)
+		return NF_DROP;
+
+	if (data.mac_len > ETH_HLEN) {
+		unsigned int mac_offset = skb->data - skb_mac_header(skb);
+
+		skb_push(skb, mac_offset);
+		skb->protocol = vlan_get_protocol(skb);
+		skb_pull(skb, data.mac_len);
+	}
+
 	switch (skb->protocol) {
 	case htons(ETH_P_IP):
 		nf_br_ip_fragment(state->net, state->sk, skb, &data, output);
@@ -366,7 +384,7 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
 {
 	int err;
 
-	err = skb_cow_head(skb, ETH_HLEN);
+	err = skb_cow_head(skb, data->mac_len);
 	if (err) {
 		kfree_skb(skb);
 		return -ENOMEM;
@@ -376,8 +394,12 @@ static int nf_ct_bridge_frag_restore(struct sk_buff *skb,
 	else if (skb_vlan_tag_present(skb))
 		__vlan_hwaccel_clear_tag(skb);
 
-	skb_copy_to_linear_data_offset(skb, -ETH_HLEN, data->mac, ETH_HLEN);
+	skb_copy_to_linear_data_offset(skb, -data->mac_len, data->mac,
+				       data->mac_len);
+	skb_push(skb, data->mac_len - ETH_HLEN);
 	skb_reset_mac_header(skb);
+	skb->mac_header -= ETH_HLEN;
+	skb->protocol = data->orig_proto;
 
 	return 0;
 }


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
