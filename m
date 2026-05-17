Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95537280318
	for <syzbot@lists.linux.dev>; Sun, 17 May 2026 09:32:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779010321; cv=none; b=aHYMWpTycpooX151BXgoqZc/Z7psuHdr+yMGSgHP+4dVw/SbcqZljajum9U9+JHlHRt7dkV75yot/DZwn30Qx8WFLximwB5wJVCz3LqPV+1yq0PNiGCNVRTihDUjc+O0F1Z/MVWnC8IxEcaYxzspy5/hxwujo1WI893QvCU/25o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779010321; c=relaxed/simple;
	bh=g0Z+xGRE0u/2qGIbFhmuURoQ9OJuoeNtO9P0vF7nZSY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=nN22knIpe3dUIW7dNLkuQqqEc9LVL6bSDo9tSCNvrL72mPxlu4737bk3TevNtToj/6+rKbUH71BlF2Ne6O3e+r2jV9/RHXUmAqQ2HcJO8ntWvsitKn6rUs27c1tAi8Y0yBffHcW2c8gnlb5dhIcQwzyvqHoxkK8TylxLPCaVUWE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=e4I+zQ49; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="e4I+zQ49"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BFE1C2BCB0;
	Sun, 17 May 2026 09:32:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779010321;
	bh=g0Z+xGRE0u/2qGIbFhmuURoQ9OJuoeNtO9P0vF7nZSY=;
	h=From:To:Cc:Subject:Date:From;
	b=e4I+zQ49BKU7cz8eCsy1SAD+LY93pEkol4gpcN0d8Cy7sLU0q2w+ajUQjKUgG9KyJ
	 xzPgI7oVN1TbiQQqrKtUtPlHs9iox/9ChHFvECNb6zctlHYRoRQ8pXx0ynHiB7vthK
	 gJIYI+s2ES1JVv9mIgnzdimH8vfsA0RmZYjKFfGV/R7vZOBT+4N4A5jQO0sn1aE+Dc
	 jm44Sz/0ielbQJ+K37hXShsDWyFpwXsUsK/qogyZz6NAKER1Ya1AUxcSfuZ7AOKFPK
	 eBYh3ZA5C9d0XIwzgeslske5/t42XJrr+UVoADlDc4F1bWgrTTKHixeENub2k99A6p
	 PWY2rUo/Aq9JA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v3] misc/vmw_vmci: fix recursive locking deadlock in queue pair broker
Message-ID: <0c7c74c5-0445-48a4-8bf2-b5a5beb46f47@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 17 May 2026 09:32:01 +0000 (UTC)

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
Link: https://syzkaller.appspot.com/ai_job?id=59455e18-3bd0-4f40-9e0f-35dc95523adf
To: <arnd@arndb.de>
To: <bryan-bt.tan@broadcom.com>
To: <gregkh@linuxfoundation.org>
To: <linux-kernel@vger.kernel.org>
To: <vishnu.dasa@broadcom.com>
Cc: <bcm-kernel-feedback-list@broadcom.com>

---
v3:
- Added `lockdep_assert_not_held(&qp_broker_list.mutex)` in `qp_notify_peer()` to prevent future regressions.
- Reverted the move of the host queue pair support check to `qp_broker_alloc()`.
- Modified `qp_broker_attach()` signature to return `do_notify` and `out_ctx` via pointer arguments to handle them outside the lock.

v2:
- Moved the host queue pair support check and `vmci_ctx_put()` call from `qp_broker_attach()` to `qp_broker_alloc()`.
- Avoided modifying the signature of `qp_broker_attach()` to return notification parameters, handling them in the caller instead.
- Reduced the overall diff size as requested by reviewers.
https://lore.kernel.org/all/5749a52e-a4b2-4c05-8877-ba1aa2b5f5d0@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/aec7cb16-64c4-4e01-a974-a6c1a51a046e@mail.kernel.org/T/
---
diff --git a/drivers/misc/vmw_vmci/vmci_queue_pair.c b/drivers/misc/vmw_vmci/vmci_queue_pair.c
index b777bc3fd..79fb82e1f 100644
--- a/drivers/misc/vmw_vmci/vmci_queue_pair.c
+++ b/drivers/misc/vmw_vmci/vmci_queue_pair.c
@@ -11,6 +11,7 @@
 #include <linux/kernel.h>
 #include <linux/mm.h>
 #include <linux/module.h>
+#include <linux/lockdep.h>
 #include <linux/mutex.h>
 #include <linux/pagemap.h>
 #include <linux/pci.h>
@@ -1044,7 +1045,7 @@ static int qp_detatch_guest_work(struct vmci_handle handle)
 			 * because we can't allocate.  We still want
 			 * to release the entry if that happens, so
 			 * don't bail out yet.
-			 */
+		 */
 		}
 	} else {
 		result = qp_detatch_hypercall(handle);
@@ -1456,6 +1457,8 @@ static int qp_notify_peer(bool attach,
 	int rv;
 	struct vmci_event_qp ev;
 
+	lockdep_assert_not_held(&qp_broker_list.mutex);
+
 	if (vmci_handle_is_invalid(handle) || my_id == VMCI_INVALID_ID ||
 	    peer_id == VMCI_INVALID_ID)
 		return VMCI_ERROR_INVALID_ARGS;
@@ -1508,22 +1511,24 @@ static int qp_notify_peer(bool attach,
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
+			    struct vmci_ctx **out_ctx)
 {
 	const u32 context_id = vmci_ctx_get_id(context);
 	bool is_local = flags & VMCI_QPFLAG_LOCAL;
 	int result;
 
+	if (out_ctx)
+		*out_ctx = NULL;
+
+	if (do_notify)
+		*do_notify = false;
+
 	if (entry->state != VMCIQPB_CREATED_NO_MEM &&
 	    entry->state != VMCIQPB_CREATED_MEM)
 		return VMCI_ERROR_UNAVAILABLE;
@@ -1585,7 +1590,11 @@ static int qp_broker_attach(struct qp_broker_entry *entry,
 
 		create_context = vmci_ctx_get(entry->create_id);
 		supports_host_qp = vmci_ctx_supports_host_qp(create_context);
-		vmci_ctx_put(create_context);
+
+		if (out_ctx)
+			*out_ctx = create_context;
+		else
+			vmci_ctx_put(create_context);
 
 		if (!supports_host_qp)
 			return VMCI_ERROR_INVALID_RESOURCE;
@@ -1659,15 +1668,8 @@ static int qp_broker_attach(struct qp_broker_entry *entry,
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
+	if (entry->state == VMCIQPB_ATTACHED_MEM && do_notify)
+		*do_notify = true;
 
 	entry->attach_id = context_id;
 	entry->qp.ref_count++;
@@ -1711,6 +1713,9 @@ static int qp_broker_alloc(struct vmci_handle handle,
 	struct qp_broker_entry *entry = NULL;
 	bool is_local = flags & VMCI_QPFLAG_LOCAL;
 	int result;
+	bool do_notify = false;
+	u32 notify_peer_id = VMCI_INVALID_ID;
+	struct vmci_ctx *out_ctx = NULL;
 
 	if (vmci_handle_is_invalid(handle) ||
 	    (flags & ~VMCI_QP_ALL_FLAGS) || is_local ||
@@ -1748,14 +1753,33 @@ static int qp_broker_alloc(struct vmci_handle handle,
 				     context, wakeup_cb, client_data, ent);
 	} else {
 		create = false;
-		result =
-		    qp_broker_attach(entry, peer, flags, priv_flags,
-				     produce_size, consume_size, page_store,
-				     context, wakeup_cb, client_data, ent);
+
+		result = qp_broker_attach(entry, peer, flags, priv_flags,
+					  produce_size, consume_size,
+					  page_store, context, wakeup_cb,
+					  client_data, ent, &do_notify,
+					  &out_ctx);
+
+		if (result == VMCI_SUCCESS && do_notify)
+			notify_peer_id = entry->create_id;
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
@@ -1968,6 +1992,8 @@ int vmci_qp_broker_set_page_store(struct vmci_handle handle,
 	struct qp_broker_entry *entry;
 	int result;
 	const u32 context_id = vmci_ctx_get_id(context);
+	bool do_notify = false;
+	u32 notify_peer_id;
 
 	if (vmci_handle_is_invalid(handle) || !context ||
 	    context_id == VMCI_INVALID_ID)
@@ -2035,18 +2061,26 @@ int vmci_qp_broker_set_page_store(struct vmci_handle handle,
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
 
@@ -2086,6 +2120,7 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
 	u32 peer_id;
 	bool is_local = false;
 	int result;
+	bool do_notify = false;
 
 	if (vmci_handle_is_invalid(handle) || !context ||
 	    context_id == VMCI_INVALID_ID) {
@@ -2185,7 +2220,7 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
 
 		vmci_ctx_qp_destroy(context, handle);
 	} else {
-		qp_notify_peer(false, handle, context_id, peer_id);
+		do_notify = true;
 		if (context_id == VMCI_HOST_CONTEXT_ID &&
 		    QPBROKERSTATE_HAS_MEM(entry)) {
 			entry->state = VMCIQPB_SHUTDOWN_MEM;
@@ -2200,6 +2235,10 @@ int vmci_qp_broker_detach(struct vmci_handle handle, struct vmci_ctx *context)
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
