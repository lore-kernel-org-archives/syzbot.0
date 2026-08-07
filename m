Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE283451A6
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 18:45:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786128359; cv=none; b=NDmMWcCYFB1wrCL0oPSc3fjLLVmYcVHeds4o4wnt/XcTPRN8XkpCSGsvvkqgRccDb2HEqRx+C9MQRhpQhRpNv5wAqRHA9BQglgDiRZVBD237ENCala+SEmGGUFwFQxhbQeXiar+Ikm6KlwKRqT4It5Lyq9/xl5k/F36gYyBj6Kg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786128359; c=relaxed/simple;
	bh=3nqVnkwFhECIrBoVu/2NX2GXamNzCA8YnXrUljhyREc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=umwk4C0ora5OaCpRlEtSTpJ5cxCeLVe9a/WC/WYKpNG/K+elS91c94X6tnRW4hCCC8P5RoeSmQjpUTgC1EJffWQ70UsiCJ4zQpc7a9ZAj/OOjbjkwJeoydkdrUgCO4qQZnkanQHX8rp5B2mtATF/oyAEsz0/sU81fullvVT4wnY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=oRdtw8Su; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="oRdtw8Su"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 94B131F000E9;
	Fri,  7 Aug 2026 18:45:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786128356;
	bh=x0cxY9bME9XwKX814JyNrGhf0X7R8krbPHm7LTkR4uk=;
	h=From:To:Cc:Subject:Date;
	b=oRdtw8Sul4NOmJ1aB1CdL9CQ4wLCBLd+OwPKiR6HxwnQXlMnN4wPyopZ/8LnTZrET
	 TeWi1M2inwlxp0gypgpnmnHfJnBN0Dw1yRvCs8lrwW8j5BKpKH29QYjtmIbylAb2ze
	 KZDeHjJ/asZjJ6ncw9uJda2TsxDmWCiSSUWPCMILZqCUE9otMshxcH9LVV2VP8wh4P
	 JB+PoT9JO9YckJ+FWpQbco8pvlb8fCb0fKZbKxO7f7hvT4tf8HG5x1XCHJNJaOPg5f
	 KNfGwd/FwfA9KNA/SGGOsFNqQElXVgAbHMXvbZoahGg/cn+g65XBEvrDBjWh4/jY4R
	 1EDLWQ86MTYzQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] SUNRPC: Add a short timeout for local rpcbind calls to prevent DoS
Message-ID: <ffa89735-65ee-4e66-8cd2-18d7f8bbdefc@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 18:45:56 +0000 (UTC)

A local denial-of-service (DoS) vulnerability can be triggered by holding
the global nfsd_mutex while making a synchronous RPC call to the local
rpcbind daemon, which can be maliciously tarpitted.

When nfsd_nl_listener_set_doit() is called to modify listeners, it acquires
nfsd_mutex and destroys existing listeners. For each destroyed listener,
svc_delete_xprt() attempts to unregister the port from the local rpcbind by
calling svc_register(). This function iterates over all registered RPC
programs and versions, making a synchronous rpcb_register_call() for each
combination.

An attacker can run in a new network namespace, mount a tmpfs over /run to
hide the rpcbind UNIX sockets, and bind a fake rpcbind server to
127.0.0.1:111. When the kernel connects and sends the unregister request,
the fake server accepts the connection but intentionally sleeps without
replying. Since the local rpcbind client inherits the default 60-second TCP
RPC timeout, the thread holding nfsd_mutex blocks for a long time. Other
threads attempting to acquire the mutex will block, eventually triggering
the hung task watchdog and crashing the system:

INFO: task blocked for more than 15 seconds.
Call Trace:
 <TASK>
 __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 __mutex_lock+0x7bf/0x1550 kernel/locking/mutex.c:821
 nfsd_nl_threads_get_doit+0x1c0/0x790 fs/nfsd/nfsctl.c:1754
 genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
 genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
 netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
 genl_rcv+0x28/0x40 net/netlink/genetlink.c:1218
 netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
 netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900

To fix this, local IPC should not be allowed to block for long periods.
Introduce a short 100ms timeout for local rpcbind clients. Add the
RPC_TASK_SOFT and RPC_TASK_TIMEOUT flags to rpcb_register_call() to ensure
the RPC call returns -ETIMEDOUT when the timeout expires. Finally,
propagate the -ETIMEDOUT error through svc_generic_rpcbind_set() and abort
the outer loop in svc_register() early, preventing multiple timeouts from
accumulating and exceeding the hung task watchdog limit.

Fixes: 2a76b3bfa229 ("SUNRPC: Use TCP for local rpcbind upcalls")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c0831b61d6ade1e2d098@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c0831b61d6ade1e2d098
Link: https://syzkaller.appspot.com/ai_job?id=baf7f685-d9f6-4911-b692-3b89801723c0
To: "Anna Schumaker" <anna@kernel.org>
To: "Chuck Lever" <cel@kernel.org>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jeff Layton" <jlayton@kernel.org>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <linux-nfs@vger.kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Trond Myklebust" <trondmy@kernel.org>
To: "Chuck Lever" <chuck.lever@oracle.com>
Cc: "Dai Ngo" <Dai.Ngo@oracle.com>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "NeilBrown" <neil@brown.name>
Cc: "Olga Kornievskaia" <okorniev@redhat.com>
Cc: "Tom Talpey" <tom@talpey.com>

---
diff --git a/net/sunrpc/rpcb_clnt.c b/net/sunrpc/rpcb_clnt.c
index 6aa372188..4094f3257 100644
--- a/net/sunrpc/rpcb_clnt.c
+++ b/net/sunrpc/rpcb_clnt.c
@@ -221,6 +221,12 @@ static void rpcb_set_local(struct net *net, struct rpc_clnt *clnt,
 # define SUN_LEN(ptr) (offsetof(struct sockaddr_un, sun_path)		\
 		      + 1 + strlen((ptr)->sun_path + 1))
 
+static const struct rpc_timeout rpcb_local_timeout = {
+	.to_initval = (HZ / 10) ? : 1,
+	.to_maxval = (HZ / 10) ? : 1,
+	.to_retries = 0,
+};
+
 /*
  * Returns zero on success, otherwise a negative errno value
  * is returned.
@@ -238,6 +244,7 @@ static int rpcb_create_af_local(struct net *net,
 		.version	= RPCBVERS_2,
 		.authflavor	= RPC_AUTH_NULL,
 		.cred		= current_cred(),
+		.timeout	= &rpcb_local_timeout,
 		/*
 		 * We turn off the idle timeout to prevent the kernel
 		 * from automatically disconnecting the socket.
@@ -312,6 +319,7 @@ static int rpcb_create_local_net(struct net *net)
 		.version	= RPCBVERS_2,
 		.authflavor	= RPC_AUTH_UNIX,
 		.cred		= current_cred(),
+		.timeout	= &rpcb_local_timeout,
 		.flags		= RPC_CLNT_CREATE_NOPING,
 	};
 	struct rpc_clnt *clnt, *clnt4;
@@ -402,11 +410,11 @@ static struct rpc_clnt *rpcb_create(struct net *net, const char *nodename,
 
 static int rpcb_register_call(struct sunrpc_net *sn, struct rpc_clnt *clnt, struct rpc_message *msg, bool is_set)
 {
-	int flags = RPC_TASK_NOCONNECT;
+	int flags = RPC_TASK_NOCONNECT | RPC_TASK_SOFT | RPC_TASK_TIMEOUT;
 	int error, result = 0;
 
 	if (is_set || !sn->rpcb_is_af_local)
-		flags = RPC_TASK_SOFTCONN;
+		flags |= RPC_TASK_SOFTCONN;
 	msg->rpc_resp = &result;
 
 	error = rpc_call_sync(clnt, msg, flags);
diff --git a/net/sunrpc/svc.c b/net/sunrpc/svc.c
index ae9ec4bf3..539ddd064 100644
--- a/net/sunrpc/svc.c
+++ b/net/sunrpc/svc.c
@@ -1207,6 +1207,9 @@ int svc_generic_rpcbind_set(struct net *net,
 	error = svc_rpcbind_set_version(net, progp, version,
 					family, proto, port);
 
+	if (error == -ETIMEDOUT)
+		return error;
+
 	return (vers->vs_rpcb_optnl) ? 0 : error;
 }
 EXPORT_SYMBOL_GPL(svc_generic_rpcbind_set);
@@ -1243,6 +1246,8 @@ int svc_register(const struct svc_serv *serv, struct net *net,
 				printk(KERN_WARNING "svc: failed to register "
 					"%sv%u RPC service (errno %d).\n",
 					progp->pg_name, i, -error);
+				if (error == -ETIMEDOUT)
+					return error;
 				break;
 			}
 		}


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
