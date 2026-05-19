Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 533332D0C63
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 13:36:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779197769; cv=none; b=ZQKxHyBm8Is16R94O6n5rZAXFHQyerhh2jGTuUxTZBO67K3W7vYd/izrBG0gu/uSx2SgMdRWrSz0RwscW/0Bgi/5XHu/6mOHrZ0ulqT/r+BSh/kVr932ZuSdGj+Cc5E1/E+CCBQfr1WjpSL2ntgnvvI7RbNx1QjQO1kXDBoFgC8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779197769; c=relaxed/simple;
	bh=AJpLKLiR2jGtHCVAPNBdOaaUPVpFkFXysbl+gfULPS8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=X4tnFwAHf2Kh2XG5jldepq0iRPBOApqmlX3WnggGXdtiZ4mXW+7G1e4OxEYr3bNryNqQUl1qeWymkdQfpzijdJ/a/2XafNbeyFldN4HiyHdvNCCbuB8Mo5Z46PCH6lPPtNkv5Ep/9vxzOVLYoSdNbJXI0KVSCeMb64s3ONT5j/4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Wr3mCms5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Wr3mCms5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A41C2BCB3;
	Tue, 19 May 2026 13:36:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779197769;
	bh=AJpLKLiR2jGtHCVAPNBdOaaUPVpFkFXysbl+gfULPS8=;
	h=From:To:Cc:Subject:Date:From;
	b=Wr3mCms5kYVWxRn39SJnlfY/wcrLziOLoOcLTXiDjAup5fIJ7tXt7NsGEmGF6KQ7R
	 n9N9MJV6IcNKdek8zVYINbLZb7BhCQ+cGBaSdWY9Jhnlxfd/69HK/xl53DmuAfBFWJ
	 aeG6cPDSrwMdmLf6Ls3QKBQKbt8aO6RCq8CfJLCzsSm82mPR18QV9EjK1NnB1XvFeO
	 /fHi2AeVbgCqGmAlmLOV7a4nZ8gcXDMPQahslZsvLjZy2MyB7MDXAsNZ33XYK1B1W7
	 gj1gUys5gXmxDtRgCUA7fo7ujOMd/sJqtvkTSL07k8FJAV3faxhdlyxDdIpM8bB6a1
	 xDa9UU0LlAeGg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] bpf: Fix uninitialized value in eth_type_trans()
Message-ID: <2cdda92f-08ad-4bc5-a2cb-b2bf9c8d222d@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 19 May 2026 13:36:08 +0000 (UTC)

syzkaller reported a KMSAN uninitialized value crash in
eth_type_trans().

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
Additionally, add a check for skb->len == 0 in __bpf_redirect_neigh() to
align its validation logic with __bpf_redirect_common().

Fixes: 3a0af8fd61f9 ("bpf: BPF for lightweight tunnel infrastructure")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+0901d0cc75c3d716a3a3@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=0901d0cc75c3d716a3a3
Link: https://syzkaller.appspot.com/ai_job?id=4ec1a9c3-4883-4b6b-894d-8937ab4afc45
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
diff --git a/net/core/filter.c b/net/core/filter.c
index 9590877b0..86eb2d5c3 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2190,7 +2190,8 @@ static int __bpf_redirect_common(struct sk_buff *skb, struct net_device *dev,
 				 u32 flags)
 {
 	/* Verify that a link layer header is carried */
-	if (unlikely(skb->mac_header >= skb->network_header || skb->len == 0)) {
+	if (unlikely(skb->mac_header >= skb->network_header || skb->len == 0 ||
+		     skb_mac_offset(skb) != 0)) {
 		kfree_skb(skb);
 		return -ERANGE;
 	}
@@ -2430,7 +2431,8 @@ static int __bpf_redirect_neigh(struct sk_buff *skb, struct net_device *dev,
 {
 	struct ethhdr *ethh = eth_hdr(skb);
 
-	if (unlikely(skb->mac_header >= skb->network_header))
+	if (unlikely(skb->mac_header >= skb->network_header || skb->len == 0 ||
+		     skb_mac_offset(skb) != 0))
 		goto out;
 	bpf_push_mac_rcsum(skb);
 	if (is_multicast_ether_addr(ethh->h_dest))


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
