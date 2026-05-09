Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4822936E460
	for <syzbot@lists.linux.dev>; Sat,  9 May 2026 22:59:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778367578; cv=none; b=aaXXqovcw13I1xbZ9lQxVJbQOXpDBprPwOatX3ueMIyrFxFPuYtGRWkGesrYY6NgLOBZi64+lqnit0KwBM1Iev19JGXc6/7o56dnVuDDJSxtkPYbDJMfomHeH76lu7zQYXwndMRKX5Dfn4GNTONhxqE8NgeeJ8zbtkzd/B87PF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778367578; c=relaxed/simple;
	bh=s60MKX14dhDHuuuoL8ILo8ieVRCjDeA9SY5I6rzjcNY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=lHLcXx4D5QSIC+yZs4lXyjU6PxohGfgT6CUU5R0LxxUKNIM6nSgZyQFtV4DZonWR01EfRekJdBvDRweTqo9WSIxglPnEj6orOAbDub17IqszlSGtAFacfip6y1SiGoDKThSO8JvoB5VLBR8zmNyXEUumm+GYJZ0xI4B6Bg/xM7M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=aBN7aAug; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="aBN7aAug"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CF265C2BCB2;
	Sat,  9 May 2026 22:59:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778367577;
	bh=s60MKX14dhDHuuuoL8ILo8ieVRCjDeA9SY5I6rzjcNY=;
	h=From:To:Cc:Subject:Date:From;
	b=aBN7aAugtnXUa1mGsky1X1qFzdAqlEoJRvYrvYEqWXJPm1L5FFVYvJbl/3mklBMQv
	 kh8Tl7f5C9YvdqOr5cPW1R8eYYTWyKpm1ufDXx+GMWQk9WtbetTDAbcqCf16HE4o7B
	 HhQVglRLPR/QK0Mix+X9WYl9wnkzWQXY9bYJwPz6igs+r8A9NT90Rlzy0PDfp5/jhe
	 TdgvgdjwC7L1k/JUJPpZYvMDZgdYo4Dkz3VK1mGIncEwORpfcemmid5OjdLOOSIu4j
	 FXwEwMkAY98IoVY6LZfVgtiv1W/sxNb69jzdFT1JwY32JkKVQWxeZNLmxDAWt/t2Wn
	 vldKLos1ugPgA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] misc/vmw_vmci: fix recursive locking deadlock in queue pair broker
Message-ID: <aec7cb16-64c4-4e01-a974-a6c1a51a046e@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat,  9 May 2026 22:59:37 +0000 (UTC)

misc/vmw_vmci: fix recursive locking deadlock in queue pair broker

A recursive locking deadlock can occur involving `qp_broker_list.mutex`
in the VMCI queue pair broker.

When a queue pair is detached, `vmci_qp_broker_detach()` acquires
`qp_broker_list.mutex` and, if there are still other endpoints attached,
it calls `qp_notify_peer()` to send a notification datagram to the peer
context.

The deadlock occurs because `qp_notify_peer()` indirectly calls
`vmci_ctx_put()` on the peer's context, which can drop the reference
count to 0 if the peer context is concurrently being destroyed. When the
reference count reaches 0, `vmci_ctx_put()` synchronously calls
`ctx_free_ctx()`. This cleanup function iterates over all queue pairs
attached to the dying context and calls `vmci_qp_broker_detach()` for
each of them, which attempts to acquire `qp_broker_list.mutex` again,
resulting in a deadlock.

This issue is not isolated to `vmci_qp_broker_detach()`. There are other
places in `drivers/misc/vmw_vmci/vmci_queue_pair.c` where
`qp_notify_peer()` or `vmci_ctx_put()` are called while holding
`qp_broker_list.mutex`, such as `qp_broker_attach()` and
`vmci_qp_broker_set_page_store()`.

To fix this, defer the calls to `qp_notify_peer()` and `vmci_ctx_put()`
until after `qp_broker_list.mutex` is safely released. This ensures that
the mutex is never held when these functions are executed, completely
eliminating the recursive locking deadlock while preserving the correct
logic and behavior of the VMCI queue pair broker.

Assisted-by: Gemini:gemini-3.1-pro-preview
To: <arnd@arndb.de>
To: <bryan-bt.tan@broadcom.com>
To: <gregkh@linuxfoundation.org>
To: <linux-kernel@vger.kernel.org>
To: <vishnu.dasa@broadcom.com>
Cc: <bcm-kernel-feedback-list@broadcom.com>

---
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index b777bc3fd..3d61d5bf2 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -1508,17 +1508,13 @@ static int qp_notify_peer(bool attach,
  * VMCIQPB_ATTACHED_MEM state, and for older VMX callers, it will be
  * moved to the VMCOQPB_ATTACHED_NO_MEM state.
  */
-static int qp_broker_attach(struct qp_broker_entry *entry,
-			    u32 peer,
-			    u32 flags,
-			    u32 priv_flags,
-			    u64 produce_size,
-			    u64 consume_size,
+static int qp_broker_attach(struct qp_broker_entry *entry, u32 peer, u32 flags,
+			    u32 priv_flags, u64 produce_size, u64 consume_size,
 			    struct vmci_qp_page_store *page_store,
 			    struct vmci_ctx *context,
-			    vmci_event_release_cb wakeup_cb,
-			    void *client_data,
-			    struct qp_broker_entry **ent)
+			    vmci_event_release_cb wakeup_cb, void *client_data,
+			    struct qp_broker_entry **ent, bool *do_notify,
+			    u32 *notify_peer_id, struct vmci_ctx **out_ctx)
 {
 	const u32 context_id = vmci_ctx_get_id(context);
 	bool is_local = flags & VMCI_QPFLAG_LOCAL;
@@ -1585,7 +1581,7 @@ static int qp_broker_attach(struct qp_broker_entry *entry,
 
 		create_context = vmci_ctx_get(entry->create_id);
 		supports_host_qp = vmci_ctx_supports_host_qp(create_context);
-		vmci_ctx_put(create_context);
+		*out_ctx = create_context;
 
 		if (!supports_host_qp)
 			return VMCI_ERROR_INVALID_RESOURCE;
@@ -1660,13 +1656,8 @@ static int qp_broker_attach(struct qp_broker_entry *entry,
 	}
 
 	if (entry->state == VMCIQPB_ATTACHED_MEM) {
-		result =
-		    qp_notify_peer(true, entry->qp.handle, context_id,
-				   entry->create_id);
-		if (result < VMCI_SUCCESS)
-			pr_warn("Failed to notify peer (ID=0x%x) of attach to queue pair (handle=0x%x:0x%x)\n",
-				entry->create_id, entry->qp.handle.context,
-				entry->qp.handle.resource);
+		*do_notify = true;
+		*notify_peer_id = entry->create_id;
 	}
 
 	entry->attach_id = context_id;
@@ -1711,6 +1702,9 @@ static int qp_broker_alloc(struct vmci_handle handle,
 	struct qp_broker_entry *entry = NULL;
 	bool is_local = flags & VMCI_QPFLAG_LOCAL;
 	int result;
+	bool do_notify = false;
+	u32 notify_peer_id = VMCI_INVALID_ID;
+	struct vmci_ctx *out_ctx = NULL;
 
 	if (vmci_handle_is_invalid(handle) ||
 	    (flags & ~VMCI_QP_ALL_FLAGS) || is_local ||
@@ -1748,14 +1742,29 @@ static int qp_broker_alloc(struct vmci_handle handle,
 				     context, wakeup_cb, client_data, ent);
 	} else {
 		create = false;
-		result =
-		    qp_broker_attach(entry, peer, flags, priv_flags,
-				     produce_size, consume_size, page_store,
-				     context, wakeup_cb, client_data, ent);
+		result = qp_broker_attach(entry, peer, flags, priv_flags,
+					  produce_size, consume_size,
+					  page_store, context, wakeup_cb,
+					  client_data, ent, &do_notify,
+					  &notify_peer_id, &out_ctx);
 	}
 
 	mutex_unlock(&qp_broker_list.mutex);
 
+	if (out_ctx)
+		vmci_ctx_put(out_ctx);
+
+	if (do_notify) {
+		int notify_result;
+
+		notify_result = qp_notify_peer(true, handle, context_id,
+					       notify_peer_id);
+		if (notify_result < VMCI_SUCCESS)
+			pr_warn("Failed to notify peer (ID=0x%x) of attach to queue pair (handle=0x%x:0x%x)\n",
+				notify_peer_id, handle.context,
+				handle.resource);
+	}
+
 	if (swap)
 		*swap = (context_id == VMCI_HOST_CONTEXT_ID) &&
 		    !(create && is_local);
@@ -1968,6 +1977,8 @@ int vmci_qp_broker_set_page_store(struct vmci_handle handle,
 	struct qp_broker_entry *entry;
 	int result;
 	const u32 context_id = vmci_ctx_get_id(context);
+	bool do_notify = false;
+	u32 notify_peer_id;
 
 	if (vmci_handle_is_invalid(handle) || !context ||
 	    context_id == VMCI_INVALID_ID)
@@ -2035,18 +2046,26 @@ int vmci_qp_broker_set_page_store(struct vmci_handle handle,
 	entry->vmci_page_files = true;
 
 	if (entry->state == VMCIQPB_ATTACHED_MEM) {
-		result =
-		    qp_notify_peer(true, handle, context_id, entry->create_id);
-		if (result < VMCI_SUCCESS) {
-			pr_warn("Failed to notify peer (ID=0x%x) of attach to queue pair (handle=0x%x:0x%x)\n",
-				entry->create_id, entry->qp.handle.context,
-				entry->qp.handle.resource);
-		}
+		do_notify = true;
+		notify_peer_id = entry->create_id;
 	}
 
 	result = VMCI_SUCCESS;
  out:
 	mutex_unlock(&qp_broker_list.mutex);
+
+	if (do_notify) {
+		int notify_result;
+
+		notify_result = qp_notify_peer(true, handle, context_id,
+					       notify_peer_id);
+		if (notify_result < VMCI_SUCCESS) {
+			pr_warn("Failed to notify peer (ID=0x%x) of attach to queue pair (handle=0x%x:0x%x)\n",
+				notify_peer_id, handle.context,
+				handle.resource);
+		}
+	}
+
 	return result;
 }
 
@@ -2086,6 +2105,7 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
 	u32 peer_id;
 	bool is_local = false;
 	int result;
+	bool do_notify = false;
 
 	if (vmci_handle_is_invalid(handle) || !context ||
 	    context_id == VMCI_INVALID_ID) {
@@ -2185,7 +2205,7 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
 
 		vmci_ctx_qp_destroy(context, handle);
 	} else {
-		qp_notify_peer(false, handle, context_id, peer_id);
+		do_notify = true;
 		if (context_id == VMCI_HOST_CONTEXT_ID &&
 		    QPBROKERSTATE_HAS_MEM(entry)) {
 			entry->state = VMCIQPB_SHUTDOWN_MEM;
@@ -2200,6 +2220,10 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
 	result = VMCI_SUCCESS;
  out:
 	mutex_unlock(&qp_broker_list.mutex);
+
+	if (do_notify)
+		qp_notify_peer(false, handle, context_id, peer_id);
+
 	return result;
 }
 


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
