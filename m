Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FE53B5310
	for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 11:06:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786359972; cv=none; b=s2F3D7Gn2dYVvIefGQkFRlMGIZKPDaHwqUazab/9ZyWsN6lacMF/d7ow1TrNozCkSb2Rg2hR/q+LJ9mqBXe2wnuVyeoo6Qxvn/YFj/4OAFtJsK1ZZMZBTXEdF0VSZkf/8fiPDy8pJRQ5bx8aYotCZETNlGw7UN+U5SLs67y23iI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786359972; c=relaxed/simple;
	bh=aqHFZznVwQ9cKIskwz96dtIXn9axwRF2pcDFM8F+RXo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=YXQvXtPVDWT5zOZXlmp+6nYRE+wSNDRE9Wdhm4kCnyiGSmnZkmObc2SuLpgUCICCDbATnSXQmL2WoqWKaABA2NhTlQWFuJ5xcpVCovS7K/z77csBMfHVANRvirijTkBPHWcdF4yGKH/wuSTQMapJzoCY6Lr+C+KsCS21X8YMSkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Di53qKnK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Di53qKnK"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id F21EF1F00A3A;
	Mon, 10 Aug 2026 11:06:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786359971;
	bh=svsR/WkWxBSJCl9aGLtCuMATn88PCXxUP33X3V+mDUk=;
	h=From:To:Cc:Subject:Date;
	b=Di53qKnKSY+ZLRBfDCY3VRzqgxNMxRq2Lc4PruScpIpmc/HLAZoCwm2x6H5YdhMq+
	 oD/Btj7dOalWLgq7yN7klpQ7/9DlyAJE/DbqXua8zZnsIJlHkdnXFzustXQ752JmA1
	 WXVkyFfjzY8wPjy9ctoTiIVcC7AezdMezmetqecxHcJWPJT9ZjIEyhH1lmvTD5qbiR
	 4lnCioxNem4gvzAYc9nfyGzhFeIrzlWLK3UX0zfjG9y6FmZ4nE2736hZlL24tk3/ia
	 t61ffuU1XeuUdsOoXotCwTVmlgt8fMyLBgwEl2+WI7WaWN4e42Yuq9creHQlwm3ics
	 tGarLzrjBfjWw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: nogikh@google.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] libceph: replace WARN_ON() with error handling for network input
Message-ID: <0ac41ed1-c41e-4474-b58d-2e13343782cf@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 10 Aug 2026 11:06:10 +0000 (UTC)

The Ceph messenger v1 and v2 protocol implementations currently use
WARN_ON() to assert that the server's response adheres to the protocol.
However, network input from a server can be invalid due to a buggy or
malicious server. WARN_ON() must not be used for conditions that can
legitimately happen, such as receiving invalid network data. While WARNINGs
are not fatal by default, they pollute the kernel log with stack traces and
can lead to kernel panics on systems configured with panic_on_warn.

When the kernel Ceph client connects to a Ceph server, it initiates a
handshake and reads the server's reply directly from the network socket.
The reply is then processed in process_connect() (for v1) or other
processing functions (for v2). If the server sends an unexpected value,
such as an incorrect connect_seq, the client triggers a WARN_ON(),
resulting in the following warning:

------------[ cut here ]------------
con->v1.connect_seq != le32_to_cpu(con->v1.in_reply.connect_seq)
WARNING: net/ceph/messenger_v1.c:902 at process_connect
net/ceph/messenger_v1.c:901 [inline], CPU#1: kworker/1:3/5645
WARNING: net/ceph/messenger_v1.c:902 at ceph_con_v1_try_read+0x3335/0x6eb0
net/ceph/messenger_v1.c:1366, CPU#1: kworker/1:3/5645
RIP: 0010:process_connect net/ceph/messenger_v1.c:901 [inline]
RIP: 0010:ceph_con_v1_try_read+0x3335/0x6eb0 net/ceph/messenger_v1.c:1366
Call Trace:
 <TASK>
 ceph_con_workfn+0x208/0x14a0 net/ceph/messenger.c:1577
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Fix this by replacing WARN_ON() assertions on network input with graceful
error handling. If the server sends unexpected data, log a descriptive
error message using pr_err() instead, set the connection error message, and
return an error code to abort the connection. This ensures that invalid
network input is treated as a protocol violation rather than a kernel bug.
The fix is applied to both messenger v1 (process_connect) and v2
(process_server_ident, process_session_retry, and
process_session_retry_global).

Fixes: 31b8006e1d79 ("ceph: messenger library")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+21f8628595b2061c438d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=21f8628595b2061c438d
Link: https://syzkaller.appspot.com/ai_job?id=e761462d-1213-4e5f-8037-8243a24c7783
To: "Alex Markuze" <amarkuze@redhat.com>
To: <ceph-devel@vger.kernel.org>
To: "Ilya Dryomov" <idryomov@gmail.com>
To: "Viacheslav Dubeyko" <slava@dubeyko.com>
To: "Sage Weil" <sage@newdream.net>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Dropped the changes to process_hello() in messenger v2, keeping its WARN_ON() assertions.

v1:
https://lore.kernel.org/all/9ec9dff3-f779-4ac6-ab8e-fcedd8a467b0@mail.kernel.org/T/
---
diff --git a/net/ceph/messenger_v1.c b/net/ceph/messenger_v1.c
index c9e002d96..df2248b7b 100644
--- a/net/ceph/messenger_v1.c
+++ b/net/ceph/messenger_v1.c
@@ -898,8 +898,15 @@ static int process_connect(struct ceph_connection *con)
 		     con->v1.peer_global_seq,
 		     le32_to_cpu(con->v1.in_reply.connect_seq),
 		     con->v1.connect_seq);
-		WARN_ON(con->v1.connect_seq !=
-			le32_to_cpu(con->v1.in_reply.connect_seq));
+		if (con->v1.connect_seq != le32_to_cpu(con->v1.in_reply.connect_seq)) {
+			pr_err("%s%lld %s connect_seq mismatch, expected %u, got %u\n",
+			       ENTITY_NAME(con->peer_name),
+			       ceph_pr_addr(&con->peer_addr),
+			       con->v1.connect_seq,
+			       le32_to_cpu(con->v1.in_reply.connect_seq));
+			con->error_msg = "connect_seq mismatch";
+			return -1;
+		}
 
 		if (con->v1.in_reply.flags & CEPH_MSG_CONNECT_LOSSY)
 			ceph_con_flag_set(con, CEPH_CON_F_LOSSYTX);
diff --git a/net/ceph/messenger_v2.c b/net/ceph/messenger_v2.c
index 05f6eea29..d706cdbe0 100644
--- a/net/ceph/messenger_v2.c
+++ b/net/ceph/messenger_v2.c
@@ -2529,14 +2529,33 @@ static int process_server_ident(struct ceph_connection *con,
 	con->peer_name.num = cpu_to_le64(global_id);
 	con->v2.peer_global_seq = global_seq;
 	con->peer_features = features;
-	WARN_ON(required_features & ~client->supported_features);
+	if (required_features & ~client->supported_features) {
+		pr_err("%s%lld %s missing required protocol features, my supported 0x%llx, server's required 0x%llx\n",
+		       ENTITY_NAME(con->peer_name),
+		       ceph_pr_addr(&con->peer_addr),
+		       client->supported_features, required_features);
+		con->error_msg = "missing required protocol features";
+		return -EINVAL;
+	}
 	con->v2.server_cookie = cookie;
 
 	if (flags & CEPH_MSG_CONNECT_LOSSY) {
 		ceph_con_flag_set(con, CEPH_CON_F_LOSSYTX);
-		WARN_ON(con->v2.server_cookie);
+		if (con->v2.server_cookie) {
+			pr_err("%s%lld %s server_cookie is set for lossy connection\n",
+			       ENTITY_NAME(con->peer_name),
+			       ceph_pr_addr(&con->peer_addr));
+			con->error_msg = "server_cookie is set for lossy connection";
+			return -EINVAL;
+		}
 	} else {
-		WARN_ON(!con->v2.server_cookie);
+		if (!con->v2.server_cookie) {
+			pr_err("%s%lld %s server_cookie is not set for lossless connection\n",
+			       ENTITY_NAME(con->peer_name),
+			       ceph_pr_addr(&con->peer_addr));
+			con->error_msg = "server_cookie is not set for lossless connection";
+			return -EINVAL;
+		}
 	}
 
 	clear_in_sign_kvecs(con);
@@ -2618,7 +2637,14 @@ static int process_session_retry(struct ceph_connection *con,
 	ceph_decode_64_safe(&p, end, connect_seq, bad);
 
 	dout("%s con %p connect_seq %llu\n", __func__, con, connect_seq);
-	WARN_ON(connect_seq <= con->v2.connect_seq);
+	if (connect_seq <= con->v2.connect_seq) {
+		pr_err("%s%lld %s connect_seq mismatch, expected > %llu, got %llu\n",
+		       ENTITY_NAME(con->peer_name),
+		       ceph_pr_addr(&con->peer_addr),
+		       con->v2.connect_seq, connect_seq);
+		con->error_msg = "connect_seq mismatch";
+		return -EINVAL;
+	}
 	con->v2.connect_seq = connect_seq + 1;
 
 	free_conn_bufs(con);
@@ -2651,7 +2677,14 @@ static int process_session_retry_global(struct ceph_connection *con,
 	ceph_decode_64_safe(&p, end, global_seq, bad);
 
 	dout("%s con %p global_seq %llu\n", __func__, con, global_seq);
-	WARN_ON(global_seq <= con->v2.global_seq);
+	if (global_seq <= con->v2.global_seq) {
+		pr_err("%s%lld %s global_seq mismatch, expected > %llu, got %llu\n",
+		       ENTITY_NAME(con->peer_name),
+		       ceph_pr_addr(&con->peer_addr),
+		       con->v2.global_seq, global_seq);
+		con->error_msg = "global_seq mismatch";
+		return -EINVAL;
+	}
 	con->v2.global_seq = ceph_get_global_seq(con->msgr, global_seq);
 
 	free_conn_bufs(con);


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
