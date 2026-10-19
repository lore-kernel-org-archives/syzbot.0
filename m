Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792449306;
	b=hMEEIsfQPIMaJWO2IQ6eaBY7WffZz1CnNOGzkoNBezZ8Mmj2LgzfniS0s0spWdmkxS8N
	 NfJrY3Skn6yDiVhebzuTVzel8JLio5eIU2oZL1bJqhcnMUszzhzuaHbNCdNCT0xUrIplr
	 vPnwaHuzQhY07yzSrI01bNPP37ZOfJtPWmaZXBBEQPBTW79CGmehl7txnuj5E7cvsTj72
	 R++S/vt1/LxfUjIToAf0o5vz5MC9iao6wYm0hDXD5YlYAG5xxMCQXIluQyn1YMxNE6JNn
	 bZS4/w2g4HUKolLdgj9SGjIjwWppvtCleIlDeNQfyvgP4gCaFhUqPnUZg9Podh5bv+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792449306;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=bV7ncw+4WqMo9CXqWyt2ug/kBIjh/3sreUW9dgWUPpc=;
	b=zq3l776QpzvKzNy76pd+NBfFi2tCJzwxbpFYZD8XJQDgaLHvIt8qfbURVjXP8Fck9Ml3
	 J0yRqoe9VJsuabUhrxgqf6t3Otg53/xEtcdqU9R1hHQFUCeysQ1Hy0W4tbni1Y3uZQTe4
	 i15FFCyupWH89Aj5HVYHHz7YHEE+v4sKRdy90uwL5CEXbLjktbR6b2A79ExQVRdjw9qtz
	 f7V4p9xvOfkimbQ4/BLN1vf8c/y+fp9E5V1wqsrBEgwbsSmnD7ouvxHrp0tiASUD59QyU
	 4sHPZmBAYn1h8cErNkacdgSVlTZEOW08peue3a86pt6aoj+vNGbz9yZz9Q0pMy/+s8A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W60dh9ZZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 86266606A319
	for <syzbot@lists.linux.dev>; Mon, 19 Oct 2026 22:35:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=W60dh9ZZ
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D648D1F000C4;
	Mon, 19 Oct 2026 22:35:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792449306;
	bh=bV7ncw+4WqMo9CXqWyt2ug/kBIjh/3sreUW9dgWUPpc=;
	h=From:To:Cc:Subject:Date;
	b=W60dh9ZZzUT5mTdz1KQqKK8SPj0jfk455qU33VCBY7N3qZD/hFLNlGi7WGKuJfDkG
	 2RAsfD4RRZubx64aX02hnb2kDErrV8CFCnrXi+1C7JFMoaPTQgKsHP5ew8JvyoAFfW
	 f5UnsGudl5Kt999zaFaAhrEfqw/4L/hrul2riuKFFLIhG0xhsS+rtv6c9iX55u66so
	 +aV+z9+BiAQ98O983aNRhWZoTK2s/qc63kX713n0RZ4PY6n7jqsYbRW33LAwyClIjv
	 xHGdeXCmJr8/fTslyNXuJPP5Jc5D2Xyw9JDZ5oFUsb7sC8m0X2oGJg+MpSdgX7oMok
	 kDTQFkhRypHxA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] xdp: recycle page_pool pages correctly in __xdp_return()
Message-ID: <54cfad65-b3d6-42b9-86e2-e084c31dae23@mail.kernel.org>
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
Date: Mon, 19 Oct 2026 22:35:05 +0000 (UTC)

In generic XDP with multi-buffer support (BPF_F_XDP_HAS_FRAGS), incoming
non-linear skbs have their fragments copied into page_pool-backed pages
allocated from the per-CPU system_page_pool via skb_cow_data_for_xdp() ->
skb_pp_cow_data(). However, bpf_prog_run_generic_xdp() initializes the
xdp_buff using &rxqueue->xdp_rxq, which has no registered memory model and
defaults to rxq->mem.type == MEM_TYPE_PAGE_SHARED (0). When the XDP program
shrinks the packet and completely consumes one or more fragments (such as
via bpf_xdp_adjust_tail() with a negative offset or bpf_xdp_pull_data()),
bpf_xdp_shrink_data() passes xdp->rxq->mem.type (MEM_TYPE_PAGE_SHARED) to
__xdp_return(). Instead of returning the page to its page_pool via
page_pool_put_full_netmem(), __xdp_return() invokes page_frag_free(), which
decrements the refcount to zero and frees the page directly to the buddy
allocator. Because the page was allocated from a page_pool, page->pp_magic
still contains PP_SIGNATURE, causing free_page_is_bad() to detect a
"page_pool leak" and trigger a bad_page() BUG:

BUG: Bad page state in process ...  pfn:31a2c
page: refcount:0 mapcount:0 mapping:0000000000000000
index:0xffff888031a2cd20 pfn:0x31a2c
flags: 0xfff00000000000(node=0|zone=1|lastcpupid=0x7ff)
page dumped because: page_pool leak
Call Trace:
 <TASK>
 bad_page+0x17f/0x1c0 mm/page_alloc.c:647
 free_page_is_bad mm/page_alloc.c:1082 [inline]
 __free_pages_prepare mm/page_alloc.c:1409 [inline]
 __free_frozen_pages+0xcd7/0xd30 mm/page_alloc.c:2962
 bpf_xdp_shrink_data net/core/filter.c:4383 [inline]
 bpf_xdp_frags_shrink_tail+0x4ed/0x800 net/core/filter.c:4407
 ____bpf_xdp_adjust_tail net/core/filter.c:4429 [inline]
 bpf_xdp_adjust_tail+0x1ce/0x210 net/core/filter.c:4422
 bpf_prog_run_generic_xdp+0x612/0x1560 net/core/dev.c:5579
 netif_receive_generic_xdp net/core/dev.c:5699 [inline]
 do_xdp_generic+0xae1/0x12f0 net/core/dev.c:5761
 __netif_receive_skb_core+0x10e3/0x30c0 net/core/dev.c:6107
 ...
 </TASK>

A similar mismatch occurs in veth and devmap. In veth_xdp_rcv_one(),
xdp->rxq->mem.type was only assigned to frame->mem_type after executing the
XDP program on XDP_TX and XDP_REDIRECT, leaving xdp->rxq->mem.type
uninitialized during program execution. In addition,
veth_convert_skb_to_xdp_buff() did not reset rq->xdp_rxq.mem to rq->xdp_mem
prior to running the program, allowing modifications from previous frames
to leak. In devmap, dev_map_bpf_prog_run() constructed a local struct
xdp_rxq_info on the stack without setting rxq.mem.type to xdpf->mem_type,
leaving it as MEM_TYPE_PAGE_SHARED (0) while running the egress program.

Fix this by checking netmem_is_pp() under MEM_TYPE_PAGE_SHARED in
__xdp_return(). If the netmem belongs to a page_pool, fall through to
MEM_TYPE_PAGE_POOL and return it via page_pool_put_full_netmem();
otherwise, release it with page_frag_free(). Placing MEM_TYPE_PAGE_SHARED
immediately before MEM_TYPE_PAGE_POOL keeps the native MEM_TYPE_PAGE_POOL
fast path branch-free. In addition, set xdp->rxq->mem.type =
frame->mem_type in veth_xdp_rcv_one() before calling bpf_prog_run_xdp(),
restore rq->xdp_rxq.mem prior to program execution in
veth_convert_skb_to_xdp_buff(), and initialize rxq.mem.type =
xdpf->mem_type in dev_map_bpf_prog_run().

Fixes: e6d5dbdd20aa ("xdp: add multi-buff support for xdp running in generic mode")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+ff145014d6b0ce64a173@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=ff145014d6b0ce64a173
Link: https://syzkaller.appspot.com/ai_job?id=10925bb2-1509-4501-b65c-50070666ed06
To: "Andrew Lunn" <andrew+netdev@lunn.ch>
To: "Andrii Nakryiko" <andrii@kernel.org>
To: "Alexei Starovoitov" <ast@kernel.org>
To: <bpf@vger.kernel.org>
To: "Daniel Borkmann" <daniel@iogearbox.net>
To: "David S. Miller" <davem@davemloft.net>
To: "Eduard Zingerman" <eddyz87@gmail.com>
To: "Eric Dumazet" <edumazet@kernel.org>
To: "Jesper Dangaard Brouer" <hawk@kernel.org>
To: "John Fastabend" <john.fastabend@gmail.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: "Kumar Kartikeya Dwivedi" <memxor@gmail.com>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Lorenzo Bianconi" <lorenzo@kernel.org>
Cc: "Emil Tsalapatis" <emil@etsalapatis.com>
Cc: "Simon Horman" <horms@kernel.org>
Cc: "Ihor Solodrai" <ihor.solodrai@linux.dev>
Cc: "Jiri Olsa" <jolsa@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Martin KaFai Lau" <martin.lau@linux.dev>
Cc: "Stanislav Fomichev" <sdf@fomichev.me>
Cc: "Song Liu" <song@kernel.org>
Cc: "Yonghong Song" <yonghong.song@linux.dev>

---
diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 643b97dc5..745edf2c7 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -653,6 +653,7 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
 
 		xdp_convert_frame_to_buff(frame, xdp);
 		xdp->rxq = &rq->xdp_rxq;
+		xdp->rxq->mem.type = frame->mem_type;
 		vxbuf.skb = NULL;
 
 		act = bpf_prog_run_xdp(xdp_prog, xdp);
@@ -664,7 +665,6 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
 			break;
 		case XDP_TX:
 			orig_frame = *frame;
-			xdp->rxq->mem.type = frame->mem_type;
 			if (unlikely(veth_xdp_tx(rq, xdp, bq) < 0)) {
 				trace_xdp_exception(rq->dev, xdp_prog, act);
 				frame = &orig_frame;
@@ -676,7 +676,6 @@ static struct xdp_frame *veth_xdp_rcv_one(struct veth_rq *rq,
 			goto xdp_xmit;
 		case XDP_REDIRECT:
 			orig_frame = *frame;
-			xdp->rxq->mem.type = frame->mem_type;
 			if (xdp_do_redirect(rq->dev, xdp, xdp_prog)) {
 				frame = &orig_frame;
 				stats->rx_drops++;
@@ -768,6 +767,7 @@ static int veth_convert_skb_to_xdp_buff(struct veth_rq *rq,
 	/* SKB "head" area always have tailroom for skb_shared_info */
 	frame_sz = skb_end_pointer(skb) - skb->head;
 	frame_sz += SKB_DATA_ALIGN(sizeof(struct skb_shared_info));
+	rq->xdp_rxq.mem = rq->xdp_mem;
 	xdp_init_buff(xdp, frame_sz, &rq->xdp_rxq);
 	xdp_prepare_buff(xdp, skb->head, skb_headroom(skb),
 			 skb_headlen(skb), true);
@@ -825,7 +825,6 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	case XDP_TX:
 		veth_xdp_get(xdp);
 		consume_skb(skb);
-		xdp->rxq->mem = rq->xdp_mem;
 		if (unlikely(veth_xdp_tx(rq, xdp, bq) < 0)) {
 			trace_xdp_exception(rq->dev, xdp_prog, act);
 			stats->rx_drops++;
@@ -837,7 +836,6 @@ static struct sk_buff *veth_xdp_rcv_skb(struct veth_rq *rq,
 	case XDP_REDIRECT:
 		veth_xdp_get(xdp);
 		consume_skb(skb);
-		xdp->rxq->mem = rq->xdp_mem;
 		if (xdp_do_redirect(rq->dev, xdp, xdp_prog)) {
 			stats->rx_drops++;
 			goto err_xdp;
diff --git a/kernel/bpf/devmap.c b/kernel/bpf/devmap.c
index dc7b859e8..a138b9e8f 100644
--- a/kernel/bpf/devmap.c
+++ b/kernel/bpf/devmap.c
@@ -348,6 +348,7 @@ static int dev_map_bpf_prog_run(struct bpf_prog *xdp_prog,
 		u32 act;
 		int err;
 
+		rxq.mem.type = xdpf->mem_type;
 		xdp_convert_frame_to_buff(xdpf, &xdp);
 		xdp.txq = &txq;
 		xdp.rxq = &rxq;
diff --git a/net/core/xdp.c b/net/core/xdp.c
index 1d679e8fd..40360ff95 100644
--- a/net/core/xdp.c
+++ b/net/core/xdp.c
@@ -23,6 +23,8 @@
 #include <trace/events/xdp.h>
 #include <net/xdp_sock_drv.h>
 
+#include "netmem_priv.h"
+
 #define REG_STATE_NEW		0x0
 #define REG_STATE_REGISTERED	0x1
 #define REG_STATE_UNREGISTERED	0x2
@@ -434,6 +436,12 @@ void __xdp_return(netmem_ref netmem, enum xdp_mem_type mem_type,
 		  bool napi_direct, struct xdp_buff *xdp)
 {
 	switch (mem_type) {
+	case MEM_TYPE_PAGE_SHARED:
+		if (!netmem_is_pp(netmem_compound_head(netmem))) {
+			page_frag_free(__netmem_address(netmem));
+			break;
+		}
+		fallthrough;
 	case MEM_TYPE_PAGE_POOL:
 		netmem = netmem_compound_head(netmem);
 		if (napi_direct && xdp_return_frame_no_direct())
@@ -444,9 +452,6 @@ void __xdp_return(netmem_ref netmem, enum xdp_mem_type mem_type,
 		page_pool_put_full_netmem(netmem_get_pp(netmem), netmem,
 					  napi_direct);
 		break;
-	case MEM_TYPE_PAGE_SHARED:
-		page_frag_free(__netmem_address(netmem));
-		break;
 	case MEM_TYPE_PAGE_ORDER0:
 		put_page(__netmem_to_page(netmem));
 		break;


base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
