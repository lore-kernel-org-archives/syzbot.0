Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20B7530567F
	for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 15:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786374252; cv=none; b=D6RZyUAlXfHFe+V2xwDB+nF+Xh8cDtXszd2xTcLhlYyj4pBMfLB3Kk6Y5GNaG5wYtzm/9iSbuofI9ALMXr4YndEXblQCdOtz2clFQRdYnwSVE4RcIY6NRFIDoIexKPhj4KhDQ4zBOCZH4VRUZ7/IFBZGgNa/hWYkLBfNjy5ZZlw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786374252; c=relaxed/simple;
	bh=up6JpXKpFE5xP+NNuTE+zvD09zRiOGqU5pN8hSA5YXE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=OzXGpULb9xpIBazGN0hTaLc+qp6kpC/wapQFQm7buFHKknoFFu9zvKLv172Wf9TNFsNMviOf97On4Pvp8tUJG5WflBgM5bSi93HTfa0zCoHhkBoCqaBbfRJ1OpvS5N7tfIVqOH1SWzZm1oTasWgZl5H9EU5LJwDxUtb3+vkDaUw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kv/UvOhs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kv/UvOhs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E3F251F000E9;
	Mon, 10 Aug 2026 15:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786374251;
	bh=gHtAsqYyahXv8Gm3tuMk/6T2YO5AopGAbu6oVjhXgvs=;
	h=From:To:Cc:Subject:Date;
	b=kv/UvOhsCPdkHAoALSfhBdtgGfERe4X2L4RqKIrjm3ldZvYyvMvPEbnfjQTVEBYNJ
	 xfHCzTYN/vmqZUfyIPrVvGGDruLOcxP49W+YGak79NCf3YCE/kDL9DlBiTaxhwlBVH
	 h6hLKqcd9zYiXhVXMcoRrl8GvCERSg1a7WrtVAeZcHbJYRnRXvvceKltDckTIIaceW
	 CGw/nlL98l55GF+8vGtZx+rt4Lo0G3GX0h5ZPZdIlLsUpn1UU0D/IkzLbop90HqAVy
	 WuxaFVlFNNarS2/kqhWjmeaWZ59tdAoNSjOWlxz0433p1XCjK95IJNWPbuEuJq6gAX
	 aJ5ch/9dGFYYg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] rxrpc: Fix use-after-free in rxrpc_destroy_all_peers()
Message-ID: <efbfa532-8931-4227-9ba4-701ac86a342e@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 10 Aug 2026 15:04:10 +0000 (UTC)

During network namespace teardown, rxrpc_destroy_all_peers() iterates over
the rxnet->peer_hash table to print leaked peers. However, it does so
without holding the rxnet->peer_hash_lock. This allows a race condition
with asynchronous peer destruction triggered by the AFS subsystem via RCU,
which can concurrently remove a peer from the hash table and free it.

When the RCU grace period expires, afs_free_addrlist() calls
rxrpc_kernel_put_peer(), which eventually invokes __rxrpc_put_peer(). This
function acquires rxnet->peer_hash_lock, removes the peer from the hash
table, and frees it via kfree_rcu(). If rxrpc_destroy_all_peers() is
concurrently iterating over the hash bucket, it may attempt to read the
hash_link.next pointer of a physically freed peer, resulting in a KASAN
slab-use-after-free. The crash log confirms this behavior, as one of the
leaked peers printed right before the crash has a refcount of 0, indicating
it was already put and waiting to be removed and freed.

The crash report illustrates this issue:

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
Freed by task 15:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2677 [inline]
 __rcu_free_sheaf_prepare+0x12d/0x2a0 mm/slub.c:2928
 rcu_free_sheaf+0x31/0x200 mm/slub.c:5978
 rcu_do_batch kernel/rcu/tree.c:2645 [inline]
 rcu_core+0x78b/0x10a0 kernel/rcu/tree.c:2897
 handle_softirqs+0x225/0x840 kernel/softirq.c:622
 run_ksoftirqd+0x36/0x60 kernel/softirq.c:1076
 smpboot_thread_fn+0x57c/0xa80 kernel/smpboot.c:160
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245

To fix this, acquire rxnet->peer_hash_lock using spin_lock_bh() before
iterating over the rxnet->peer_hash table in rxrpc_destroy_all_peers(), and
release it after the iteration is complete. The _bh variant is required
because __rxrpc_put_peer() can be invoked from an RCU callback in softirq
context, and using a plain spin_lock() could lead to a deadlock. This
change ensures that the hash table structure remains stable during
iteration and aligns with the locking patterns used in other teardown
functions within the rxrpc subsystem.

Fixes: 17226f124038 ("rxrpc: Fix leak of rxrpc_peer objects")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c876adfab6362679008c@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c876adfab6362679008c
Link: https://syzkaller.appspot.com/ai_job?id=148b52c4-bf79-4dde-932f-8b4de7e83f41
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
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
