Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B47962DECA1
	for <syzbot@lists.linux.dev>; Tue, 11 Aug 2026 11:29:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786447791; cv=none; b=nWr8HuLyjPe7UfH5xKMJxB/IgFM8zU1vyVg2g5R6+gl4tb+e2ns6R36tKcObogEgIWH9/gbur04vQLohvCnXPi+y849AxC93bAOLML3TYtrhDHEpgKCZ8+9Qcvapap3jXqly+q+f2eXcqiRSWvBrj17QAtys5Byk8GdP47FB5Jg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786447791; c=relaxed/simple;
	bh=WpbvqoEnueClBuM2fs6ZJ6KDnabvzYRJrcwSyCh30u4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=RgCXPGhyKF4j4OO/sxIj/GEmCx22PEvlOqV6/HU7nb+b3UIG9m/Fd3n8r1eO6vzCDk9+UQfKYax1YVidUQj7ECA5cnr0VyTfao3srOqvmSfd1IjDVnUxrBg67Doo33rtPJPJl8C40XjebmyJ64vmPSWzmih+pYwh2IoAWSOh8RY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Xmz3Pozs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Xmz3Pozs"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 487EA1F00A3A;
	Tue, 11 Aug 2026 11:29:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786447789;
	bh=6tGvtxbLh2JTSKo5DXnHerr9GCUoZ4kD27BMHD8bEqw=;
	h=From:To:Cc:Subject:Date;
	b=Xmz3PozszyS/BrvEREYFRH/UhvDsSwVF2PIpmWnubZfAyV/RbqgH87kn12y88wEB9
	 VAqwxN2HlNi5r9Sl7riGXDCxRneLdrCt2mP0rAENz5flE+XPJBT4u1J32cy6PqVWpT
	 EK4QSC6aUnKTaoZklJiMo9cEDWYnXF83Tzp+DlzPEjXyhQoSDsiGD2wXzNo8qqfOgs
	 TQ3BeGrF4SdBYEWMIySbk1rIK+bf3i01SFUGiv6Z4aw0rf3U+bTNC95eVM2PILVEh4
	 56e7/cL+p4SyY/CXqq6m7Ad0rDrwpoNDRkanVoUWkPnNAwown/FSIPzvDgPRnXkHHT
	 UNAXqagIX+Scg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net/x25: fix sleeping function called from invalid context
Message-ID: <ba0266cf-023b-4f6c-b7f8-3004a1b4e0c2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 11 Aug 2026 11:29:49 +0000 (UTC)

Commit 7781607938c8 ("net/x25: Fix null-ptr-deref caused by
x25_disconnect") added a lock_sock() call to x25_kill_by_neigh() to prevent
a race condition where x25_disconnect() clears x25->neighbour concurrently
while x25_sendmsg() or x25_recvmsg() are dereferencing it. However,
x25_kill_by_neigh() is called from softirq context (e.g., via
net_rx_action() -> x25_lapb_receive_frame() -> x25_link_terminated()),
where sleeping is strictly forbidden. Acquiring a sleeping lock in this
context triggers a "sleeping function called from invalid context" BUG and
an inconsistent lock state warning.

BUG: sleeping function called from invalid context at net/core/sock.c:3829
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 24, name:
kworker/1:0
preempt_count: 101, expected: 0
RCU nest depth: 1, expected: 0
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
 lock_sock_nested+0x56/0x100 net/core/sock.c:3829
 lock_sock include/net/sock.h:1713 [inline]
 x25_kill_by_neigh+0x10d/0x250 net/x25/af_x25.c:1778
 x25_lapb_receive_frame+0x1b0/0xfb0 net/x25/x25_dev.c:138
 __netif_receive_skb_one_core net/core/dev.c:6212 [inline]
 netif_receive_skb_core+0x2a6/0x2b0 net/core/dev.c:6237
 lapbeth_napi_poll+0x42/0x90 drivers/net/wan/lapbether.c:100
 __napi_poll+0xaa/0x330 net/core/dev.c:7735
 napi_poll net/core/dev.c:7798 [inline]
 net_rx_action+0x61d/0xf50 net/core/dev.c:7955
 handle_softirqs+0x225/0x840 kernel/softirq.c:622
 do_softirq+0x76/0xd0 kernel/softirq.c:523
 </IRQ>

To fix this, defer the disconnect operation to a process context using a
work_struct. This approach safely synchronizes the disconnect operation
with user-space socket operations without sleeping in softirq, preserving
the original intent of the null-ptr-deref fix. As a bonus, this improves
the performance of x25_kill_by_neigh() from O(N^2) to O(N) by eliminating
the need to drop the list lock and restart the iteration.

Fixes: 7781607938c8 ("net/x25: Fix null-ptr-deref caused by x25_disconnect")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+15cbd86f569e8b084383@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=15cbd86f569e8b084383
Link: https://syzkaller.appspot.com/ai_job?id=52927852-8f6a-44c7-84a5-8eca5340fc99
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-x25@vger.kernel.org>
To: "Martin Schiller" <ms@dev.tdt.de>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Duoming Zhou" <duoming@zju.edu.cn>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/include/net/x25.h b/include/net/x25.h
index 414f3fd99..c83d4e2e6 100644
--- a/include/net/x25.h
+++ b/include/net/x25.h
@@ -167,6 +167,7 @@ struct x25_sock {
 	struct x25_dte_facilities dte_facilities;
 	struct x25_calluserdata	calluserdata;
 	unsigned long 		vc_facil_mask;	/* inc_call facilities mask */
+	struct work_struct	disconnect_work;
 };
 
 struct x25_forward {
diff --git a/net/x25/af_x25.c b/net/x25/af_x25.c
index 033e7d059..7204ad352 100644
--- a/net/x25/af_x25.c
+++ b/net/x25/af_x25.c
@@ -501,6 +501,18 @@ static struct proto x25_proto = {
 	.obj_size = sizeof(struct x25_sock),
 };
 
+static void x25_disconnect_work(struct work_struct *work)
+{
+	struct x25_sock *x25 = container_of(work, struct x25_sock, disconnect_work);
+	struct sock *sk = &x25->sk;
+
+	lock_sock(sk);
+	if (x25->neighbour)
+		x25_disconnect(sk, ENETUNREACH, 0, 0);
+	release_sock(sk);
+	sock_put(sk);
+}
+
 static struct sock *x25_alloc_socket(struct net *net, int kern)
 {
 	struct x25_sock *x25;
@@ -516,6 +528,7 @@ static struct sock *x25_alloc_socket(struct net *net, int kern)
 	skb_queue_head_init(&x25->fragment_queue);
 	skb_queue_head_init(&x25->interrupt_in_queue);
 	skb_queue_head_init(&x25->interrupt_out_queue);
+	INIT_WORK(&x25->disconnect_work, x25_disconnect_work);
 out:
 	return sk;
 }
@@ -1768,19 +1781,13 @@ void x25_kill_by_neigh(struct x25_neigh *nb)
 {
 	struct sock *s;
 
-again:
 	write_lock_bh(&x25_list_lock);
 
 	sk_for_each(s, &x25_list) {
 		if (x25_sk(s)->neighbour == nb) {
 			sock_hold(s);
-			write_unlock_bh(&x25_list_lock);
-			lock_sock(s);
-			if (x25_sk(s)->neighbour == nb)
-				x25_disconnect(s, ENETUNREACH, 0, 0);
-			release_sock(s);
-			sock_put(s);
-			goto again;
+			if (!schedule_work(&x25_sk(s)->disconnect_work))
+				sock_put(s);
 		}
 	}
 	write_unlock_bh(&x25_list_lock);


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
