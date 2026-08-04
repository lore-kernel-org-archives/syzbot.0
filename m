Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBA8845D1A4
	for <syzbot@lists.linux.dev>; Tue,  4 Aug 2026 11:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785842148; cv=none; b=RULNg8L25Zb6N9txVlm3u1IH1CClYzRufiDsF0nhWk0wecIWwqVTX4OoB/mOKeZFuUNPKHd76so24bIfqTuo1z3S42rjB4HKMd3zSrUW1ViSeNRVlhClOEkmwMIsm/IKT8gyANwxhKa5d8Tn4sS1VizI9CkUKTOb6Q5DnP/dKjM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785842148; c=relaxed/simple;
	bh=qnjNZn4xLPfdSHOo8hxRSQHwIRhL4fZKyMgjxnx2+yY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=HdApMii4JVtR3+x2IBo+sxFcnAYgdRuUXXleDfn57kma48Mbfutxruhhztv/OX5tAP6X/rzv4armUZ/EUbzkgLO7eq6AECF0u+2PPbbH9CdTtbMstRPkOGDomnZNd0/t3GRDTkdon2+eidw4Tmp8OpqZ2nKFkAoQN4FNW/XM7gI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=KfqAM8EF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="KfqAM8EF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 55D831F00A3A;
	Tue,  4 Aug 2026 11:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785842146;
	bh=Vb2JByWJdMLjhvuvAenY7NFFIeVqmjp+LnFXXLH3+v4=;
	h=From:To:Cc:Subject:Date;
	b=KfqAM8EFXx94De8iQZXLNRv6EUC7k6AtscicqAT6cZdM2E3rfAsJuLg1mGjpX0yS+
	 YrEZ+sRmwtx7XbArXFpWTYghbxaP3W28Yhq2lgPTT37kWw5S7tdmYbF0o5PgeIDLZ/
	 dwr1RUKoHC/OccaCN/V35tCGQC4Lw+X3Ev6kZ8zAD8jkc8IznKiE3DH+pp0zj7v2Qo
	 SrneepGl0VQPOcVVgRzRnaWUvyyOleJfPNgs3JBjPegCjD+XW6vfFH+J1h0XziviHG
	 lSx4M4Wpg1mLUgdpyUPO9/W34kj0dZ2p+y5npXscWDcZhRLXA2u3g7NvGp1rVhOR2C
	 diZcCP0veP5aQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] vsock: fix memory leak of rejected sockets in vsock_accept()
Message-ID: <d0ddc503-5433-41e2-9bd3-6a31364b320e@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue,  4 Aug 2026 11:15:46 +0000 (UTC)

When a listening socket has an error (e.g. sk_err is set due to a failed
connect() before listen()), vsock_accept() rejects incoming connections.
Previously, vsock_accept() marked the child socket as rejected and relied
on a transport-specific delayed cleanup function to handle the cleanup.

However, virtio_transport (and loopback_transport) do not schedule any
cleanup work for sockets in the accept queue. As a result, the child socket
is completely orphaned and its memory is leaked.

Kmemleak reports the following memory leak:

BUG: memory leak
unreferenced object 0xffff88811c6fad00 (size 1272):
  comm "kworker/0:4", pid 5848, jiffies 4294944188
  backtrace (crc efdf9d94):
    kmem_cache_alloc_noprof+0x1ba/0x3e0 mm/slub.c:4931
    sk_prot_alloc+0x35/0x1b0 net/core/sock.c:2246
    sk_alloc+0x34/0x2d0 net/core/sock.c:2308
    __vsock_create+0x37/0x2e0 net/vmw_vsock/af_vsock.c:919
    virtio_transport_recv_listen+0x284/0x640
    net/vmw_vsock/virtio_transport_common.c:1721
    virtio_transport_recv_pkt+0x812/0x9e0
    net/vmw_vsock/virtio_transport_common.c:1847
    vsock_loopback_work+0xed/0x140 net/vmw_vsock/vsock_loopback.c:142

Do not rely on transport-specific delayed work to clean up rejected
sockets. Instead, explicitly clean up the socket by calling
__vsock_release() directly in vsock_accept() when an error occurs. This
safely cleans up the socket for all transports.

Additionally, since rejected sockets are now cleaned up synchronously, the
rejected flag in struct vsock_sock is obsolete and can be safely removed.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+53515d23498d641e21ea@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=53515d23498d641e21ea
Link: https://syzkaller.appspot.com/ai_job?id=00823f4e-0b0b-4294-a519-38c6921e12fa
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Stefano Garzarella" <sgarzare@redhat.com>
To: <virtualization@lists.linux.dev>
To: "Andy King" <acking@vmware.com>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/include/net/af_vsock.h b/include/net/af_vsock.h
index 30046a3c2..3357ee62d 100644
--- a/include/net/af_vsock.h
+++ b/include/net/af_vsock.h
@@ -52,13 +52,10 @@ struct vsock_sock {
 	 * The listening socket is the head for both lists.  Sockets created
 	 * for connection requests are placed in the pending list until they
 	 * are connected, at which point they are put in the accept queue list
-	 * so they can be accepted in accept().  If accept() cannot accept the
-	 * connection, it is marked as rejected so the cleanup function knows
-	 * to clean up the socket.
+	 * so they can be accepted in accept().
 	 */
 	struct list_head pending_links;
 	struct list_head accept_queue;
-	bool rejected;
 	struct delayed_work connect_work;
 	struct delayed_work pending_work;
 	struct delayed_work close_work;
diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 622dbd046..371038708 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -774,11 +774,10 @@ static void vsock_pending_work(struct work_struct *work)
 
 	if (vsock_is_pending(sk)) {
 		vsock_remove_pending(listener, sk);
-	} else if (!vsk->rejected) {
-		/* We are not on the pending list and accept() did not reject
-		 * us, so we must have been accepted by our user process.  We
-		 * just need to drop our references to the sockets and be on
-		 * our way.
+	} else {
+		/* We are not on the pending list, so we must have been
+		 * accepted by our user process.  We just need to drop our
+		 * references to the sockets and be on our way.
 		 */
 		cleanup = false;
 		goto out;
@@ -942,7 +941,6 @@ static struct sock *__vsock_create(struct net *net,
 	vsk->listener = NULL;
 	INIT_LIST_HEAD(&vsk->pending_links);
 	INIT_LIST_HEAD(&vsk->accept_queue);
-	vsk->rejected = false;
 	vsk->sent_request = false;
 	vsk->ignore_connecting_rst = false;
 	WRITE_ONCE(vsk->peer_shutdown, 0);
@@ -1919,15 +1917,9 @@ static int vsock_accept(struct socket *sock, struct socket *newsock,
 		vconnected = vsock_sk(connected);
 
 		/* If the listener socket has received an error, then we should
-		 * reject this socket and return.  Note that we simply mark the
-		 * socket rejected, drop our reference, and let the cleanup
-		 * function handle the cleanup; the fact that we found it in
-		 * the listener's accept queue guarantees that the cleanup
-		 * function hasn't run yet.
+		 * reject this socket and return.
 		 */
-		if (err) {
-			vconnected->rejected = true;
-		} else {
+		if (!err) {
 			newsock->state = SS_CONNECTED;
 			sock_graft(connected, newsock);
 
@@ -1940,6 +1932,8 @@ static int vsock_accept(struct socket *sock, struct socket *newsock,
 		}
 
 		release_sock(connected);
+		if (err)
+			__vsock_release(connected, SINGLE_DEPTH_NESTING);
 		sock_put(connected);
 	}
 


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
