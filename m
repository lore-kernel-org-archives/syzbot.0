Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED5844CF34
	for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 19:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772133322; cv=none; b=Lh42RO18jbJh3nw+qf+YxiOuvh5xOXJ2A2keSWdCO7YqgW72qeEat+PKSZixwN86nWlHnsXcdLrftFOC6lEKqPtk35glyA00Ag6h4sgiA9FCUsCxfak6BHbHcGJVU8ZSZQXvIFR42X+FsbVX+hgoUu42nibTONLHIP53OANDfwY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772133322; c=relaxed/simple;
	bh=0WaVqEgcJlDY02tN0zXYGgU0sjaZ14hTVaCR4FdDCXE=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=dwN7BBEhXVAhxXWrMifAK87o3p9F3cUVAl3FgHTuPG+2tCPXBMEqRkHxPYfZXnP2lHmZT+KfMuh4+8XBxGRPlqWvwOM37vtzFz5VQ4e8ErwyDDpo0Ki+j58urQ7Rt8O72w82ezS9dhqLYacXTfwMA2jo9TxupoG3WpMHVg90iKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sWD7BXik; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sWD7BXik"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2aad6045810so11295295ad.3
        for <syzbot@lists.linux.dev>; Thu, 26 Feb 2026 11:15:18 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1772133317; x=1772738117; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=5kvTHTqe9ndDnP2daAlPvuqmWQOnnNZG2WdCPppQRAU=;
        b=sWD7BXikstpedfAj/OAnXYHUqCYptGndwRMZiCwtEb9YpK199zwGKHLILsBWC0ENeP
         +KABK+800WhjxdCzGzhrJ35j5+7ZQmU7miFC65eBtO7tC/e1uEmdH5JQm04PDlOLAioP
         tdtD+kfnHfGsb3kTE8iiMM4+7N0dPDURCwfFkbfddTX+/tIk45TnjnaoxWA5mZnLumXZ
         GFEhZ+kDxpdFEQicFxlhWtiWpKqiuZvHerqLZzudiqPjioYiAIHB7EdJqItMBXxiGXFl
         FlbJRkk71d+HMiwop8VkDI0RzvwMzHDqzQiHfM95kwx8uk0iiK4FOST9eb1G/rG+wLWT
         tuLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1772133317; x=1772738117;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=5kvTHTqe9ndDnP2daAlPvuqmWQOnnNZG2WdCPppQRAU=;
        b=vjVp8YsKM5xSSJJYhJdctyGbhYFEkjB/I5u7djd+Bg5KvGP8GgB6nsjVXqR22Y+v24
         019VMNYXSiQhSI5a79SYJCWUVE2czRlf0yPl+aNpOS7HhcX+PxqA1Hsl43QwzGvMMAqZ
         PFEomEakAUWjaW0IOAoUxkMbKube9SM+09AT6AJHjFEHeqOgCEiu/UsxG8dPbzP4l8Kl
         TLl1IaW+NtXKBGeb7J0J6F6FWjupfehJkZFAhcN77K6njoRXSrWKzOIzQAoNKufmaV1P
         wJFXxlFi7F+eQv/RT+Pj9vj68ynMimzfexjZnOd6sWMyX8puH8S+EfFvESkP1EOs/UCX
         UlFw==
X-Forwarded-Encrypted: i=1; AJvYcCW2w4sdWAAbxRfaEaAo1DGgf7597H7afQYxSB/3M5n8D0pXshda19YxpxF0TDuWhAKi0xHuq2k=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw3KAnEgUdA/chAHM7KJ7Fv0ZHuMzRObsB97fyrIhw5+e2Bud9e
	ezpbyMD/AwE2vZPbBJsEO5oatlE82KydvMBjoRAsPTWyRSF5QDacgvkZNid9syz39NcEacY5yez
	Rt4sqPA==
X-Received: from plgz12.prod.google.com ([2002:a17:903:18c:b0:298:465f:129])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:2283:b0:2aa:f07f:a776
 with SMTP id d9443c01a7336-2ae2e4b5727mr86095ad.43.1772133317292; Thu, 26 Feb
 2026 11:15:17 -0800 (PST)
Date: Thu, 26 Feb 2026 19:14:14 +0000
In-Reply-To: <69a07c1b.050a0220.16c224.0006.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <69a07c1b.050a0220.16c224.0006.GAE@google.com>
X-Mailer: git-send-email 2.53.0.473.g4a7958ca14-goog
Message-ID: <20260226191515.2953716-1-kuniyu@google.com>
Subject: Re: [syzbot ci] Re: ipmr: No RTNL for RTNL_FAMILY_IPMR rtnetlink.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: syzbot+ci7bfbcdccdcddd61f@syzkaller.appspotmail.com
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
	horms@kernel.org, kuba@kernel.org, kuni1840@gmail.com, kuniyu@google.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

From: syzbot ci <syzbot+ci7bfbcdccdcddd61f@syzkaller.appspotmail.com>
Date: Thu, 26 Feb 2026 09:00:11 -0800
> syzbot ci has tested the following series
> 
> [v1] ipmr: No RTNL for RTNL_FAMILY_IPMR rtnetlink.
> https://lore.kernel.org/all/20260226023637.1335854-1-kuniyu@google.com
> * [PATCH v1 net-next 01/15] selftest: net: Add basic functionality tests for ipmr.
> * [PATCH v1 net-next 02/15] ipmr: Annotate access to mrt->mroute_do_{pim,assert,wrvifwhole}.
> * [PATCH v1 net-next 03/15] ipmr: Convert ipmr_rtm_dumplink() to RCU.
> * [PATCH v1 net-next 04/15] ipmr: Use MAXVIFS in mroute_msgsize().
> * [PATCH v1 net-next 05/15] ipmr: Convert ipmr_rtm_getroute() to RCU.
> * [PATCH v1 net-next 06/15] ipmr: Convert ipmr_rtm_dumproute() to RCU.
> * [PATCH v1 net-next 07/15] ipmr: Move unregister_netdevice_many() out of mroute_clean_tables().
> * [PATCH v1 net-next 08/15] ipmr: Move unregister_netdevice_many() out of ipmr_free_table().
> * [PATCH v1 net-next 09/15] ipmr: Convert ipmr_net_exit_batch() to ->exit_rtnl().
> * [PATCH v1 net-next 10/15] ipmr: Remove RTNL in ipmr_rules_init() and ipmr_net_init().
> * [PATCH v1 net-next 11/15] ipmr: Call fib_rules_unregister() without RTNL.
> * [PATCH v1 net-next 12/15] ipmr: Define net->ipv4.{ipmr_notifier_ops,ipmr_seq} under CONFIG_IP_MROUTE.
> * [PATCH v1 net-next 13/15] ipmr/ip6mr: Convert net->ipv[46].ipmr_seq to atomic_t.
> * [PATCH v1 net-next 14/15] ipmr: Add dedicated mutex for mrt->{mfc_hash,mfc_cache_list}.
> * [PATCH v1 net-next 15/15] ipmr: Don't hold RTNL for ipmr_rtm_route().
> 
> and found the following issue:
> WARNING in ipmr_free_table
> 
> Full report is available here:
> https://ci.syzbot.org/series/d7068eba-72b1-4110-aeb0-d4528e03fd24
> 
> ***
> 
> WARNING in ipmr_free_table
> 
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
> base:      c7f5c6fb0f2b1a44490a36582a251f0a304d6b0c
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/0afa280b-14ff-4aec-8a20-7f8507025dd8/config
> C repro:   https://ci.syzbot.org/findings/e38687c7-5a8b-4c68-909c-a0ffdd17a674/c_repro
> syz repro: https://ci.syzbot.org/findings/e38687c7-5a8b-4c68-909c-a0ffdd17a674/syz_repro
> 
> ------------[ cut here ]------------
> !net_initialized(net) && !list_empty(dev_kill_list)
> WARNING: net/ipv4/ipmr.c:450 at ipmr_free_table+0x150/0x180 net/ipv4/ipmr.c:450, CPU#1: syz.1.18/6004

I forgot dev_kill_list could have some devices collected
from _other_ ->rtnl_exit() _after_ successful ipmr init.

My assumption in patch 10 is still correct, and I'll squash
this in v2.

diff --git a/net/ipv4/ipmr.c b/net/ipv4/ipmr.c
index 4e645a87dc6c..89e151121cea 100644
--- a/net/ipv4/ipmr.c
+++ b/net/ipv4/ipmr.c
@@ -437,17 +437,19 @@ static struct mr_table *ipmr_new_table(struct net *net, u32 id)
 static void ipmr_free_table(struct mr_table *mrt, struct list_head *dev_kill_list)
 {
 	struct net *net = read_pnet(&mrt->net);
+	LIST_HEAD(ipmr_dev_kill_list);
 
 	WARN_ON_ONCE(!mr_can_free_table(net));
 
 	timer_shutdown_sync(&mrt->ipmr_expire_timer);
 	mroute_clean_tables(mrt, MRT_FLUSH_VIFS | MRT_FLUSH_VIFS_STATIC |
 			    MRT_FLUSH_MFC | MRT_FLUSH_MFC_STATIC,
-			    dev_kill_list);
+			    &ipmr_dev_kill_list);
 	rhltable_destroy(&mrt->mfc_hash);
 	kfree(mrt);
 
-	WARN_ON_ONCE(!net_initialized(net) && !list_empty(dev_kill_list));
+	WARN_ON_ONCE(!net_initialized(net) && !list_empty(&ipmr_dev_kill_list));
+	list_splice(&ipmr_dev_kill_list, dev_kill_list);
 }
 
 /* Service routines creating virtual interfaces: DVMRP tunnels and PIMREG */
