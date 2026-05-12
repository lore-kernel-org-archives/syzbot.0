Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4E183839B9
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 10:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778582069; cv=none; b=DfPHCX/LVEZBa39Y19aWqhAJyb4fhZxScjN3yrXziAvSxvcYUhV9hJDbADXqTV55NN1m+JkLprJY4a6+2u8zRyzab1hhC7ZPekneFxl2rSo7lUG/paXpCRN0lwMxBp5Ms7IMB8667w91aMp/7E7r2UWSxqOKsm0D3S+IGJdPu/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778582069; c=relaxed/simple;
	bh=4HB1q8kq1izWyumokhLTOTLBdNThpJdXvhJJVNO7N5E=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=B6gf/CAldf996nJe+BP+3mbNMo2AyjKgIOHw2ode3NU+4lMDfD3ZBit1JbVLZiYZkRCRGvFDS7rzDmWq82ssSg2dqxlO21EbzC2e6k7xjRbtsr0qLud4pMrzwlRpq+AvaePzvxZzLAQi0t2v5LmUT1gSkn09CdPpzwm8r0C87yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sAp6LsTh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sAp6LsTh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 111D9C2BCF6;
	Tue, 12 May 2026 10:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778582068;
	bh=4HB1q8kq1izWyumokhLTOTLBdNThpJdXvhJJVNO7N5E=;
	h=From:To:Cc:Subject:Date:From;
	b=sAp6LsThEl6QzAuL92drHE89xXiRiV0DKeDWw9TujKAKxZ9+e8Vg9GKJ1WYbxp7nF
	 Ohg9NDstFBWL4heX7erXvjkuBPboq5ObyZuYyqhEDz13eyl+XGR9bMgHotHFWvpVuM
	 y+Sbpn2dqcW+RK3mq31mGUa/992jXCrTN8pG/fNgLiCnSrIhjhO9i+/Mul9cYfN5dI
	 IyC1TDyIs/G6gaq9Okcf2z6bd+ZZ5/YDuoBw8Ylyg+d8I1NWhaWjPgXm98qZptX/Fl
	 4qIeXoCQwRJk09zt3yA3t+pvPZqWVira+kWjw/T/iTEFFMrX+KjizltdW6WGY6hhTM
	 2wof0iBy/wmcw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] misc/vmw_vmci: fix recursive locking deadlock in queue pair broker
Message-ID: <5749a52e-a4b2-4c05-8877-ba1aa2b5f5d0@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 12 May 2026 10:34:28 +0000 (UTC)

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

Fixes: 06164d2b72aa752ce4633184b3e0d97601017135 ("VMCI: queue pairs implementation.")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+44e40ac2cfe68e8ce207@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=44e40ac2cfe68e8ce207
Link: https://syzkaller.appspot.com/ai_job?id=e9b15cfb-e71a-4f95-a66b-628f0a2deaac
To: <arnd@arndb.de>
To: <bryan-bt.tan@broadcom.com>
To: <gregkh@linuxfoundation.org>
To: <linux-kernel@vger.kernel.org>
To: <vishnu.dasa@broadcom.com>
Cc: <bcm-kernel-feedback-list@broadcom.com>

---
v2:
- Moved the host queue pair support check and `vmci_ctx_put()` call from `qp_broker_attach()` to `qp_broker_alloc()`.
- Avoided modifying the signature of `qp_broker_attach()` to return notification parameters, handling them in the caller instead.
- Reduced the overall diff size as requested by reviewers.

v1:
https://lore.kernel.org/all/aec7cb16-64c4-4e01-a974-a6c1a51a046e@mail.kernel.org/T/
---
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index b777bc3fd..7552a5ae4 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -1044,7 +1044,7 @@ static int qp_detatch_guest_work(struct vmci_handle handle)
 			 * because we can't allocate.  We still want
 			 * to release the entry if that happens, so
 			 * don't bail out yet.
-			 */
+		 */
 		}
 	} else {
 		result = qp_detatch_hypercall(handle);
@@ -1575,20 +1575,11 @@ static int qp_broker_attach(struct qp_broker_entry *entry,
 			return VMCI_ERROR_INVALID_RESOURCE;
 
 	} else if (context_id == VMCI_HOST_CONTEXT_ID) {
-		struct vmci_ctx *create_context;
-		bool supports_host_qp;
-
 		/*
 		 * Do not attach a host to a user created queue pair if that
 		 * user doesn't support host queue pair end points.
+		 * This check is performed in the caller.
 		 */
-
-		create_context = vmci_ctx_get(entry->create_id);
-		supports_host_qp = vmci_ctx_supports_host_qp(create_context);
-		vmci_ctx_put(create_context);
-
-		if (!supports_host_qp)
-			return VMCI_ERROR_INVALID_RESOURCE;
 	}
 
 	if ((entry->qp.flags & ~VMCI_QP_ASYMM) != (flags & ~VMCI_QP_ASYMM_PEER))
@@ -1659,15 +1650,6 @@ static int qp_broker_attach(struct qp_broker_entry *entry,
 		entry->state = VMCIQPB_ATTACHED_MEM;
 	}
 
-	if (entry->state == VMCIQPB_ATTACHED_MEM) {
-		result =
-		    qp_notify_peer(true, entry->qp.handle, context_id,
-				   entry->create_id);
-		if (result < VMCI_SUCCESS)
-			pr_warn("Failed to notify peer (ID=0x%x) of attach to queue pair (handle=0x%x:0x%x)\n",
-				entry->create_id, entry->qp.handle.context,
-				entry->qp.handle.resource);
-	}
 
 	entry->attach_id = context_id;
 	entry->qp.ref_count++;
@@ -1711,6 +1693,9 @@ static int qp_broker_alloc(struct vmci_handle handle,
 	struct qp_broker_entry *entry = NULL;
 	bool is_local = flags & VMCI_QPFLAG_LOCAL;
 	int result;
+	bool do_notify = false;
+	u32 notify_peer_id = VMCI_INVALID_ID;
+	struct vmci_ctx *out_ctx = NULL;
 
 	if (vmci_handle_is_invalid(handle) ||
 	    (flags & ~VMCI_QP_ALL_FLAGS) || is_local ||
@@ -1748,14 +1733,44 @@ static int qp_broker_alloc(struct vmci_handle handle,
 				     context, wakeup_cb, client_data, ent);
 	} else {
 		create = false;
+
+		if (context_id == VMCI_HOST_CONTEXT_ID) {
+			out_ctx = vmci_ctx_get(entry->create_id);
+			if (!vmci_ctx_supports_host_qp(out_ctx)) {
+				result = VMCI_ERROR_INVALID_RESOURCE;
+				goto out;
+			}
+		}
+
 		result =
 		    qp_broker_attach(entry, peer, flags, priv_flags,
 				     produce_size, consume_size, page_store,
 				     context, wakeup_cb, client_data, ent);
+
+		if (result == VMCI_SUCCESS &&
+		    entry->state == VMCIQPB_ATTACHED_MEM) {
+			do_notify = true;
+			notify_peer_id = entry->create_id;
+		}
 	}
 
+out:
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
@@ -1968,6 +1983,8 @@ int vmci_qp_broker_set_page_store(struct vmci_handle handle,
 	struct qp_broker_entry *entry;
 	int result;
 	const u32 context_id = vmci_ctx_get_id(context);
+	bool do_notify = false;
+	u32 notify_peer_id;
 
 	if (vmci_handle_is_invalid(handle) || !context ||
 	    context_id == VMCI_INVALID_ID)
@@ -2035,18 +2052,26 @@ int vmci_qp_broker_set_page_store(struct vmci_handle handle,
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
 
@@ -2086,6 +2111,7 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
 	u32 peer_id;
 	bool is_local = false;
 	int result;
+	bool do_notify = false;
 
 	if (vmci_handle_is_invalid(handle) || !context ||
 	    context_id == VMCI_INVALID_ID) {
@@ -2185,7 +2211,7 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
 
 		vmci_ctx_qp_destroy(context, handle);
 	} else {
-		qp_notify_peer(false, handle, context_id, peer_id);
+		do_notify = true;
 		if (context_id == VMCI_HOST_CONTEXT_ID &&
 		    QPBROKERSTATE_HAS_MEM(entry)) {
 			entry->state = VMCIQPB_SHUTDOWN_MEM;
@@ -2200,6 +2226,10 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
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
