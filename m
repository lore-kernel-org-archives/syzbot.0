Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4BE683A5E64
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 16:27:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787070457; cv=none; b=OTD0FPoBBmHMtIxx6BQlh8XU1iy8Yh0nkJ4CbpTkIL70sGCHKsaOBTVvg8K/Mh7jwDAc6wWdeQeA67tTZc9RPV3p5sNqUhgLYVFX6lR/Eo70V2A+WrGvlbHDLdv9B9PQSDJWUP7thmpN1IHJFAlMfvmAFrQ6ypqzTyv97NlfINY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787070457; c=relaxed/simple;
	bh=ZkcoFqIICNvSNCcbNK41t7IVEVdpJ0/qEBYzuWoCQ0s=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=cmkh1nNCw4A8f97ZbWEp1hKAs8labHj//EKXiWSSTG1qVSnH6PV1SX8x3XcexgY3HgPF0soiyYG/IkoaZxQs6Gr8YlXBsxlnox+ll1S/q9n6OLJSedVx1+mcrAVP7eMWeCU1kwwhoiz3yqrV5qZ8Lf/8bxHd3iIcBx2X4xRHuCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Bu+UYJaA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Bu+UYJaA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D89861F000E9;
	Tue, 18 Aug 2026 16:27:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787070456;
	bh=alQEzlt7Wl16hOdSha/M8FC0uvbF5zGE8sK/vNnLJis=;
	h=From:To:Cc:Subject:Date;
	b=Bu+UYJaAVxxHWXK7mIaGCmXxDR8fcvvuYWKmdSsqNUxAmAU5C//qOxoWTA/D1WNjz
	 lN+GCSjj15ofPj3BPQ88NIIMjiW0mfRFWkeeadlWEmnn4bwJ5Nbmsi54lu0gnU6PjR
	 j47LOJD2K72pOBQke6vzHlw4WxZm+PO14bXkR6utSqGwQm9EwENI1PpCJ7Am5zuc03
	 YSY1ly2QFqdhPC+BPgsmbpOu+TOGYClwNN8mvVlYj6vxM2wXxc1I4yOQp36+w82vx3
	 p7WEXwNkEWfx3gGhTv4PG3UESehNEccwfYqaLq0nFWMmxFmJ1Oa+rn2fI0qlNH+pvb
	 Zkq4OzjzxAO4g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: elver@google.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] rxrpc: Fix use-after-free in rxrpc_destroy_all_peers()
Message-ID: <23b6e672-549a-4fd9-b731-9bfdc16148ea@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 18 Aug 2026 16:27:35 +0000 (UTC)

During network namespace teardown, rxrpc_destroy_all_peers() iterates over
the rxnet->peer_hash table to print leaked peers. However, it does so
without holding rxnet->peer_hash_lock. This allows a race condition with
asynchronous peer destruction, where RCU callbacks concurrently remove
peers from the hash table and free them. When rxrpc_destroy_all_peers()
accesses the freed peer, it results in a KASAN slab-use-after-free.

BUG: KASAN: slab-use-after-free in rxrpc_destroy_all_peers+0xcc/0x150
net/rxrpc/peer_object.c:461
Read of size 8 at addr ffff88811089e420 by task kworker/u8:1/13
Call Trace:
 <TASK>
 rxrpc_destroy_all_peers+0xcc/0x150 net/rxrpc/peer_object.c:461
 rxrpc_exit_net+0x7f/0xc0 net/rxrpc/net_ns.c:114
 ops_exit_list net/core/net_namespace.c:199 [inline]
 ops_undo_list+0x43d/0x8d0 net/core/net_namespace.c:252
 cleanup_net+0x572/0x810 net/core/net_namespace.c:702
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

To fix the slab-use-after-free, acquire rxnet->peer_hash_lock with
spin_lock_bh() while iterating over rxnet->peer_hash in
rxrpc_destroy_all_peers().

Additionally, insert rcu_barrier() in rxrpc_exit_net() prior to destroying
peers and local endpoints. Without rcu_barrier(), rxrpc_destroy_all_peers()
races with pending RCU callbacks that drop peer and local references,
logging spurious leak warnings. Furthermore, this missing synchronization
causes a downstream panic hazard in rxrpc_destroy_all_locals() because
in-flight peer releases leave rxnet->local_endpoints populated. Calling
rcu_barrier() ensures all pending RCU callbacks that drop peer and local
references complete prior to leak checks and local endpoint destruction.

Fixes: 17226f124038 ("rxrpc: Fix leak of rxrpc_peer objects")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c876adfab6362679008c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c876adfab6362679008c
Link: https://syzkaller.appspot.com/ai_job?id=ca098ef4-2067-4197-977f-d5d409f27cb8
To: "David S. Miller" <davem@davemloft.net>
To: "David Howells" <dhowells@redhat.com>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-afs@lists.infradead.org>
To: "Marc Dionne" <marc.dionne@auristor.com>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Added rcu_barrier() in rxrpc_exit_net() before peer and local endpoint teardown.
- Updated commit message to detail how rcu_barrier() prevents spurious leak warnings and downstream panics in rxrpc_destroy_all_locals().

v1:
https://lore.kernel.org/all/efbfa532-8931-4227-9ba4-701ac86a342e@mail.kernel.org/T/
---
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index 9a9834145..6895f51b7 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -111,6 +111,7 @@ static __net_exit void rxrpc_exit_net(struct net *net)
 	timer_delete_sync(&rxnet->peer_keepalive_timer);
 	rxrpc_destroy_all_calls(rxnet);
 	rxrpc_destroy_all_connections(rxnet);
+	rcu_barrier();
 	rxrpc_destroy_all_peers(rxnet);
 	rxrpc_destroy_all_locals(rxnet);
 	proc_remove(rxnet->proc_net);
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index fa9a406e1..d81ed180e 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -454,6 +454,8 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *rxnet)
 	struct rxrpc_peer *peer;
 	int i;
 
+	spin_lock_bh(&rxnet->peer_hash_lock);
+
 	for (i = 0; i < HASH_SIZE(rxnet->peer_hash); i++) {
 		if (hlist_empty(&rxnet->peer_hash[i]))
 			continue;
@@ -465,6 +467,8 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *rxnet)
 			       &peer->srx.transport);
 		}
 	}
+
+	spin_unlock_bh(&rxnet->peer_hash_lock);
 }
 
 /**


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
