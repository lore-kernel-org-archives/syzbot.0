Received: from mail-wr1-f49.google.com (mail-wr1-f49.google.com [209.85.221.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97DDF472535
	for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 13:30:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786714224; cv=none; b=BpRpfwfgujZ6J+P6HRtYEGYbgs8XwBBgbk5A4d91YWxds03WvgwPy/mMU1MYvy27CI2zH5d+ZXEK0n4tR7SKsAM9XvIsFqJDN3OxlSBCcZ9O1imuInZuNsH41TcZDaBZqabXYNCkFHe32NzYjIy+F34dtFAhW9tfHDAPt6Dio1w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786714224; c=relaxed/simple;
	bh=Uh2GB1/qrA73GWb7hvofXqCjGqlqeTl6zZuVZvbQuC4=;
	h=Date:Message-ID:From:To:Cc:Subject:In-Reply-To:References:
	 Content-Type:MIME-Version; b=plMa9ztsNPu4rh9iukAPiqgCxkbzbXsizUlBQPRS+YvXYtReUSpVtwzSl9X3eP0P5Lh1BZs8rFhuo5d6bcLzSuGrEH+bU4vReROVC9X2lV2wjxBGUtuHYXQRAeNGS1rj8tF1IOIiS74wQZtAmqaxKzRoUpbAsU1B4k6oeUPGHLk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qZop4vvh; arc=none smtp.client-ip=209.85.221.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qZop4vvh"
Received: by mail-wr1-f49.google.com with SMTP id ffacd0b85a97d-47362928f65so960834f8f.2
        for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 06:30:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786714221; x=1787319021; darn=lists.linux.dev;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:cc:to:from:message-id:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=QltvzOeHMR23w+hq5zaVdr4TzSIx2nreQRoyPMgK+L8=;
        b=qZop4vvhJFN9tDDxCRR8aTSKnT76Rrnwo8r5tmoTxt1Nh86XRLcfL0bbSS4YSPcZlA
         THrbYeFMM2hSqQN1vrK0MtCZYFT8jvzMJyh5s2+Sw0pn0MZoEZVr09fqFSqEN6eygXTW
         2I7W6Qzczr3gvAK/+yIOY6sg017kEBeY7IiNJTIhDH7VBEQA7CBOoFE5CBiSnvKd1dib
         NIqn3DKV2d8f83E0cv89h7ahngr8uP15APRh+3rr36YiXnyMFNnQSJKwp5hghlgxQQ3q
         PDbf761FRbSX0r/ZHQOCXX4wxhqCQUfIQISvqb7eR7BVZW+1KqiVUCG0PJYIMBWfuq0m
         oZJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786714221; x=1787319021;
        h=mime-version:content-transfer-encoding:content-type:references
         :in-reply-to:subject:cc:to:from:message-id:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QltvzOeHMR23w+hq5zaVdr4TzSIx2nreQRoyPMgK+L8=;
        b=b554gk5N+S+j+3aeQJmqk8el1j/g5k3p1csBgdnLY2yqw8w2tQHxE9fS2rm8CejsJN
         oRa/bccyY3DO1GmGQm9s9JNgjKmank6tm31O+TErHyEWuytWvlbAQnUsnvyi+QE1fp9i
         403HoE5ruv32El0hLOf1Tu2i2Ug2gZ0qFaqHmV2UocuE3t/WXzeVN8LhwlQ0I5XgM3bc
         lRgWKWX7xKS8s3IlX/d4Slx9YtmYbaRH1FcB9Vs5swzITdCjGtK05qOD7tJn1KvV/UuP
         bjTX1/EoXC9YF8MR1woOgoi5iLShmmPrLNBl+hs+zyJGrsAe/99r8ru4KWwjvHAZdEfb
         fraw==
X-Forwarded-Encrypted: i=1; AHgh+Rp8jNcQzzBnqieqFPqReXHqMC/6NYFctpqpiTRILJUJcXhmtcrH/oLTOlHQJ8NSjzT1JmVsyXI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzajSUBU2j1fxg2uqZymM/HZD9kmHrQJQtiMn2Bbwet9nXSCIBo
	rcBQqV85pD2VV/s8CJMx/NmzwlhxGqnKV5Qgi+KFY7ygJbuAhY/jQK/u
X-Gm-Gg: AR+sD13cmhECb1vjbD0npVH4abV7rgcKQjuHJzDUB2eHXDSosKuqzHHJIO8oC+B8KFl
	GLMFeSa1Lf8tDAIYmplmxUQSoR+RmDEsbTlKF9xUqkK36iVn/++N5api+CHe2KLqGosODfDSxDp
	vaxHRMwbv5AyCHY350ARG2B8vQGUgFV9QXUSNOubRv0VJJ0ZV/UxK0RvDwiHIj7jTdkLIuoWr5J
	kPHE0zgGpYGqLG947pc6vAjuAHMQZ5DiKiCjipV1ojNj8ojDM22gqrFVNeb6M1blKjn1P7T+kR/
	VShNrptQLI8wKTPkIZv0pb0Viyu5rDlTHlnb4Q/ulwgotTIdznBjsHiZBGnSzLinGuAilZfBpGW
	GHgYVS2tMwHOyQpnMlVlLbVO+19c2yDl6/XVwuLhHUfs2HTJFhDFFNsuB3g7iVagDeJeLJ/PGPl
	Z5egvBonihWtwkZteg3r57T+gmP1penRHX2M5zxD5/pj7hMs//HU5Y2k5xAXKjeVvkBoMo/6V+m
	RfLQMe3rYspvvg=
X-Received: by 2002:a05:600c:198d:b0:499:7aa7:eaa7 with SMTP id 5b1f17b1804b1-499879a213dmr70583895e9.15.1786714220681;
        Fri, 14 Aug 2026 06:30:20 -0700 (PDT)
Received: from localhost ([37.30.50.141])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49989ae1ef2sm26281515e9.9.2026.08.14.06.30.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Aug 2026 06:30:19 -0700 (PDT)
Date: Fri, 14 Aug 2026 13:29:59 +0000
Message-ID: <178671419949.2648204.15668657474779239190@gmail.com>
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot+10a41dc44eef71aa9450@syzkaller.appspotmail.com>
Cc: Tung Quang Nguyen <tung.quang.nguyen@est.tech>, horms@kernel.org,
 linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
 Eric Dumazet <edumazet@google.com>, Jon Maloy <jmaloy@redhat.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 Paolo Abeni <pabeni@redhat.com>, tipc-discussion@lists.sourceforge.net,
 syzkaller-bugs@googlegroups.com, syzbot <syzbot@kernel.org>,
 David S. Miller <davem@davemloft.net>
Subject: Re: [PATCH] tipc: defer local Nagle backlog xmit from receive path
In-Reply-To: =?utf-8?q?=3CGV1P189MB1988F6301FA670CA9818F7FCC6DB2=40GV1P189MB?=
 =?utf-8?q?1988=2EEURP189=2EPROD=2EOUTLOOK=2ECOM=3E?=
References: <631b75b4-d1e3-40ea-a129-5ed090f914bf@mail.kernel.org> 
 =?utf-8?q?=3CGV1P189MB1988F6301FA670CA9818F7FCC6DB2=40GV1P189MB1988=2EEURP1?=
 =?utf-8?q?89=2EPROD=2EOUTLOOK=2ECOM=3E?=
X-Kernel-Ph2-Extid: 10a41dc44eef71aa9450
X-Kernel-Ph2-Human-Revision: 2
X-Kernel-Ph2-Patch-SHA256:
 c82ee5c8d899d19d7675bbc18b1270d670d74fdfb455a3b39c182d07fbeb4958
X-Kernel-Ph2-Fingerprint:
 f2657cd81fedfff2f7fc01adc5a1ff647de95ce6d4031968585e19411fffcc1c
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

#syz test: https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 1590cf0329716306e948a8fc29f1d3ee87d3989f

diff --git a/net/tipc/socket.c b/net/tipc/socket.c
index e564341e0216d35ae4fe539576b6e0be89b84ddb..0bf259672827db095046cda5646df047002dd663 100644
--- a/net/tipc/socket.c
+++ b/net/tipc/socket.c
@@ -94,6 +94,7 @@ struct sockaddr_pair {
  * @peer: 'connected' peer for dgram/rdm
  * @node: hash table node
  * @mc_method: cookie for use between socket and broadcast layer
+ * @backlog_work: processes receive backlog under socket ownership
  * @rcu: rcu struct for tipc_sock
  * @group: TIPC communications group
  * @oneway: message count in one direction (FIXME)
@@ -128,6 +129,7 @@ struct tipc_sock {
 	struct sockaddr_tipc peer;
 	struct rhash_head node;
 	struct tipc_mc_method mc_method;
+	struct work_struct backlog_work;
 	struct rcu_head rcu;
 	struct tipc_group *group;
 	u32 oneway;
@@ -143,6 +145,7 @@ struct tipc_sock {
 };
 
 static int tipc_sk_backlog_rcv(struct sock *sk, struct sk_buff *skb);
+static void tipc_sk_backlog_work(struct work_struct *work);
 static void tipc_data_ready(struct sock *sk);
 static void tipc_write_space(struct sock *sk);
 static void tipc_sock_destruct(struct sock *sk);
@@ -520,6 +523,7 @@ static int tipc_sk_create(struct net *net, struct socket *sock,
 	sk->sk_data_ready = tipc_data_ready;
 	sk->sk_write_space = tipc_write_space;
 	sk->sk_destruct = tipc_sock_destruct;
+	INIT_WORK(&tsk->backlog_work, tipc_sk_backlog_work);
 	tsk->conn_timeout = CONN_TIMEOUT_DEFAULT;
 	tsk->group_is_open = true;
 	atomic_set(&tsk->dupl_rcvcnt, 0);
@@ -2417,6 +2421,17 @@ static int tipc_sk_backlog_rcv(struct sock *sk, struct sk_buff *skb)
 	return 0;
 }
 
+static void tipc_sk_backlog_work(struct work_struct *work)
+{
+	struct tipc_sock *tsk = container_of(work, struct tipc_sock,
+					     backlog_work);
+	struct sock *sk = &tsk->sk;
+
+	lock_sock(sk);
+	release_sock(sk);
+	sock_put(sk);
+}
+
 /**
  * tipc_sk_enqueue - extract all buffers with destination 'dport' from
  *                   inputq and try adding them to socket or backlog queue
@@ -2434,18 +2449,30 @@ static void tipc_sk_enqueue(struct sk_buff_head *inputq, struct sock *sk,
 	struct sk_buff *skb;
 	unsigned int lim;
 	atomic_t *dcnt;
+	bool deferred = false;
+	bool owned;
+	bool local_backlog;
 	u32 onode;
 
 	while (skb_queue_len(inputq)) {
 		if (unlikely(time_after_eq(jiffies, time_limit)))
-			return;
+			break;
 
 		skb = tipc_skb_dequeue(inputq, dport);
 		if (unlikely(!skb))
-			return;
+			break;
 
-		/* Add message directly to receive queue if possible */
-		if (!sock_owned_by_user(sk)) {
+		/*
+		 * A local Nagle backlog may loop back into this socket while its
+		 * spinlock is held.  Queue the triggering input for processing under
+		 * socket ownership, which keeps a concurrent sender from overtaking
+		 * the already queued output.
+		 */
+		owned = sock_owned_by_user(sk);
+		local_backlog = !skb_queue_empty(&sk->sk_write_queue) &&
+				in_own_node(sock_net(sk),
+					    tsk_peer_node(tipc_sk(sk)));
+		if (!owned && !local_backlog) {
 			tipc_sk_filter_rcv(sk, skb, xmitq);
 			continue;
 		}
@@ -2456,6 +2483,7 @@ static void tipc_sk_enqueue(struct sk_buff_head *inputq, struct sock *sk,
 			atomic_set(dcnt, 0);
 		lim = rcvbuf_limit(sk, skb) + atomic_read(dcnt);
 		if (likely(!sk_add_backlog(sk, skb, lim))) {
+			deferred |= !owned;
 			trace_tipc_sk_overlimit1(sk, skb, TIPC_DUMP_SK_BKLGQ,
 						 "bklg & rcvq >90% allocated!");
 			continue;
@@ -2472,6 +2500,12 @@ static void tipc_sk_enqueue(struct sk_buff_head *inputq, struct sock *sk,
 		}
 		break;
 	}
+
+	if (deferred) {
+		sock_hold(sk);
+		if (!schedule_work(&tipc_sk(sk)->backlog_work))
+			sock_put(sk);
+	}
 }
 
 /**
