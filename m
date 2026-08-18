Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DD1F34E766
	for <syzbot@lists.linux.dev>; Tue, 18 Aug 2026 20:52:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787086358; cv=none; b=s6TK9oBGkVCVRdq9e2gEuxBXQwmFzpzj3iXtvRpHK748dUURW5/qotOzyXswTCI3U9FXZgl76PdV7fe/1vlLiTVwx96TCKFwp7TuvSH/eXjhGx9hXKACe8BZXaHfCzh0MHhbGH9OriMaMzDBUaC6+xyUyev1GzbXoz5Za0izFTY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787086358; c=relaxed/simple;
	bh=h054fhNiE8ZvPzcp/aAQVu8MDBInzUVdCiOxGmu7bEI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=bu60bURYd/XslO0cc3tjzs1vlvm44qn4H1Il/mVYuR4MTRJ3e825roYqC4yyZiE00Lny38jRhqLxKJ48kpZewdhI+Ct5o3DG3/anMHVGfQPCIIk7qMZc77QSt2SncylCCx1UTYkYZwE7TfSITbKtAZQpIZCUVyebBgBKPIMFACg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gSgLPypA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gSgLPypA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E938F1F000E9;
	Tue, 18 Aug 2026 20:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787086357;
	bh=BJAl6ikE2oHX/JWsKS1kHnR+CvzfqdxaWvP14AvYsgs=;
	h=From:To:Cc:Subject:Date;
	b=gSgLPypAp/rAIOc5Pyd+QolquUKXrulVLeKC6GryKsHAAx1wNHXAghhNC+fRvkHnz
	 Y8bjg4lMjNd7SFkKxEmGyTyOeaID4XUiHL2FIG59x1HjXoivvXwdC0DN5Z3EumAweO
	 dgjMXq2nSm3JpHIj8hfpdPn92duTppvUK1Li1z1dLt7NtCXzauwC2vCGUq/rhC9qh3
	 XozvakuTnqsf827SmD7jKFtqHxw02DRDHh8DdZmmhByXCjY1yHl21Ay15pquFEUqVt
	 yEXZESnMe7VLMfXNWb9tFKxeimqpQ1yn84RsijXdik6gmfSjgJ9Ug6c0xRPm48pukL
	 3UicgECrnnZEA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: elver@google.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] rxrpc: Fix use-after-free in rxrpc_destroy_all_peers()
Message-ID: <61c18ade-b0ce-426a-9c62-a7a1e550fe46@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 18 Aug 2026 20:52:36 +0000 (UTC)

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
Link: https://syzkaller.appspot.com/ai_job?id=7fecbeb2-cd9b-4ca2-8149-48663e20b153
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
v3:
- Added inline comments explaining the purpose of rcu_barrier() in rxrpc_exit_net() and peer_hash_lock acquisition in rxrpc_destroy_all_peers().

v2:
- Added rcu_barrier() in rxrpc_exit_net() before peer and local endpoint teardown.
- Updated commit message to detail how rcu_barrier() prevents spurious leak warnings and downstream panics in rxrpc_destroy_all_locals().
https://lore.kernel.org/all/23b6e672-549a-4fd9-b731-9bfdc16148ea@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/efbfa532-8931-4227-9ba4-701ac86a342e@mail.kernel.org/T/
---
diff --git a/net/rxrpc/net_ns.c b/net/rxrpc/net_ns.c
index 9a9834145..c00cddfd3 100644
--- a/net/rxrpc/net_ns.c
+++ b/net/rxrpc/net_ns.c
@@ -111,6 +111,11 @@ static __net_exit void rxrpc_exit_net(struct net *net)
 	timer_delete_sync(&rxnet->peer_keepalive_timer);
 	rxrpc_destroy_all_calls(rxnet);
 	rxrpc_destroy_all_connections(rxnet);
+	/*
+	 * Wait for pending RCU callbacks that drop peer and local
+	 * references to avoid spurious leak warnings and panics.
+	 */
+	rcu_barrier();
 	rxrpc_destroy_all_peers(rxnet);
 	rxrpc_destroy_all_locals(rxnet);
 	proc_remove(rxnet->proc_net);
diff --git a/net/rxrpc/peer_object.c b/net/rxrpc/peer_object.c
index fa9a406e1..32da76256 100644
--- a/net/rxrpc/peer_object.c
+++ b/net/rxrpc/peer_object.c
@@ -454,6 +454,12 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *rxnet)
 	struct rxrpc_peer *peer;
 	int i;
 
+	/*
+	 * The lock is needed to prevent use-after-free if a peer is being
+	 * destroyed concurrently by an RCU callback.
+	 */
+	spin_lock_bh(&rxnet->peer_hash_lock);
+
 	for (i = 0; i < HASH_SIZE(rxnet->peer_hash); i++) {
 		if (hlist_empty(&rxnet->peer_hash[i]))
 			continue;
@@ -465,6 +471,8 @@ void rxrpc_destroy_all_peers(struct rxrpc_net *rxnet)
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
