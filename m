Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EEF23B47D2
	for <syzbot@lists.linux.dev>; Thu,  2 Jul 2026 21:59:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783029575; cv=none; b=ZY+NdEmndiR2Z8pnuF3gnSAOU+A9bCq4BeBrNp0I4XgeqzkkeYFfBbciHFrMQDfBdk8AoK4GF3iInJaJyNcFv18AWCzYVK7Lmvqd43+IIxzUaNpma4D8pn+6WSZv0dgYGDbiJWuY98zE0XNAKw7R7jcTXybbbQQNg4QD6fMutEI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783029575; c=relaxed/simple;
	bh=/V1rwNDFD9xRESqnFxeRFnzSWjZJMsSsU9RN0HJ2nfc=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=kOaiaQ6kbFsrqxncqsyaZPLAm4vdIa0DE8dnNKN7SG19UH5lijNT/ykgE+UE5azwopKTtwTC/NKqTdFVmdukmVI1SkHDyuAlDs9h8SgHsM3OV9sWYzBehi7lJ1qCBL3yNxU/hB7dgXDls2zKhCiTsLtcUQhZ4kfoYCha5EtsiXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uCi1m7Ff; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uCi1m7Ff"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2c81c7421abso53228915ad.0
        for <syzbot@lists.linux.dev>; Thu, 02 Jul 2026 14:59:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1783029573; x=1783634373; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Dj8SH38Ve++9Zk/H/OUEK4h6BqvUJVzU5G2pZidlHcg=;
        b=uCi1m7FfwPd+ZGrdYo9HpoVWot+87Y9cC0AODgLoWmeO13O6mVzF061ZjxbnQjhLgl
         ssfM2MFfNze+JyLXt+bkmxhLXT0fi08WYSFwIidTME6PWTQ/C879qKB/QUiKiSt4MuOD
         lQyUo8l6wkm/t/InOUXSq44HTNIH4KHeDI3/v3zZhFU7uEk2XlEMZDRRgyFrdtc6ZuUB
         sE9yityH1zYdfj9zc/KXFgUaI532hS+tyMk6IzT4UshnLE9sBJEnAQObh5QNWHNyKSnZ
         6bbTlbvseIqVaR5I//qndE9aCkF906tiwWZsnnpK62juddvZJjCbUPdx84FpHV1dZC34
         FkSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783029573; x=1783634373;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Dj8SH38Ve++9Zk/H/OUEK4h6BqvUJVzU5G2pZidlHcg=;
        b=UgiGz2wiUZqWaRkUAz592taLOZsD0F3mMx9i/KGK0SMxju3xAvtZ8J2XJWy1zT31Rr
         gC4a5Wg590I3M1nLKITteXnfKqPohr3nUAOKrREYUqeTT1jt2+hOo8eEM2k4Sp+IT2zG
         aYODuZvr7RrmrWXRmeXE7/+kcjX+i1/AIBLbIxYhDH3CtDmCmxVXDHfEmzYyNRgKIc/Y
         AwfygTmUNHr+KGpJSjOYZk+akT9Ujq9S+OdnvmIiLHCQSRJTuXpPyJ4/rRWwwDUoIh9P
         5+acpsyp7dhX/Bbd/UqaMsHPm/neElfpqYpasQZBkmA9qdi34ip9HFJvXgEMaJXI8/i6
         R8nA==
X-Forwarded-Encrypted: i=1; AHgh+RrSa0t2epOvVXs0t2qjsYrSEaixxyn9qWuS1ACZgK/gMNqX7xh7JA3CNyWk40LB5wBGteriDOw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxoUyWUSXzXZmtOXj0Tfwg4zoBiIEgNA+FT5MKvevrjbSRbftKP
	QZ5mgVVkZQ8Pk23w9/hHwwm4a/vooA6pwH7QqwgXkMhyCGjQq2nt7/4CMfo/zOGNYvTros1iNCH
	Y+hTx8Q==
X-Received: from plge11.prod.google.com ([2002:a17:902:cf4b:b0:2b6:417:db8d])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:903:230b:b0:2c9:98e2:76aa
 with SMTP id d9443c01a7336-2ca9121f078mr74456995ad.38.1783029572961; Thu, 02
 Jul 2026 14:59:32 -0700 (PDT)
Date: Thu,  2 Jul 2026 21:59:26 +0000
In-Reply-To: <6a461706.52c20a74.1f8b39.0008.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <6a461706.52c20a74.1f8b39.0008.GAE@google.com>
X-Mailer: git-send-email 2.55.0.rc0.799.gd6f94ed593-goog
Message-ID: <20260702215932.1418087-1-kuniyu@google.com>
Subject: Re: [syzbot ci] Re: net: Support per-netns device unregistration
From: Kuniyuki Iwashima <kuniyu@google.com>
To: syzbot+ci052b96c9bf56ca1d@syzkaller.appspotmail.com
Cc: andrew@lunn.ch, davem@davemloft.net, edumazet@google.com, horms@kernel.org, 
	kuba@kernel.org, kuni1840@gmail.com, kuniyu@google.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

From: syzbot ci <syzbot+ci052b96c9bf56ca1d@syzkaller.appspotmail.com>
Date: Thu, 02 Jul 2026 00:45:10 -0700
> syzbot ci has tested the following series
> 
> [v1] net: Support per-netns device unregistration
> https://lore.kernel.org/all/20260701214334.266991-1-kuniyu@google.com
> * [PATCH v1 net-next 01/14] rtnetlink: Lock sock_net(skb->sk) in rtnl_newlink().
> * [PATCH v1 net-next 02/14] rtnetlink: Call unregister_netdevice_many() only once in rtnl_link_unregister().
> * [PATCH v1 net-next 03/14] rtnetlink: Add per-netns rtnl_work.
> * [PATCH v1 net-next 04/14] net: Wrap default_device_exit_net() with __rtnl_net_lock().
> * [PATCH v1 net-next 05/14] net: Hold __rtnl_net_lock() in netdev_wait_allrefs_any().
> * [PATCH v1 net-next 06/14] net: Add per-netns netdev unregistration infra.
> * [PATCH v1 net-next 07/14] net: Call unregister_netdevice_many() per netns.
> * [PATCH v1 net-next 08/14] veth: Support per-netns device unregistration.
> * [PATCH v1 net-next 09/14] bareudp: Protect bareudp_list with mutex.
> * [PATCH v1 net-next 10/14] bareudp: Support per-netns netdev unregistration.
> * [PATCH v1 net-next 11/14] ipvlan: Convert ipvl_port.count to refcount_t.
> * [PATCH v1 net-next 12/14] ipvlan: Synchronise ipvlan_init() and ipvlan_uninit() for the same lower dev.
> * [PATCH v1 net-next 13/14] ipvlan: Protect ipvl_port.ipvlans with mutex.
> * [PATCH v1 net-next 14/14] ipvlan: Support per-netns netdev unregistration.
> 
> and found the following issue:
> possible deadlock in __dev_change_net_namespace
> 
> Full report is available here:
> https://ci.syzbot.org/series/a744b257-d741-4780-8a53-f156b2a7afc9
> 
> ***
> 
> possible deadlock in __dev_change_net_namespace
> 
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
> base:      d6e81529749190123aa0040626c7e5dbc20fdc9a
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/243cd0ec-28f9-4d21-8f16-3d2fbad8388d/config
> syz repro: https://ci.syzbot.org/findings/a8a0740d-fdec-4a20-9aa5-7cb955707913/syz_repro
> 
> veth0_macvtap: left promiscuous mode
> ============================================
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> syz.1.18/5814 is trying to acquire lock:
> ffffffff9a9b0418 (&net->dev_unreg_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
> ffffffff9a9b0418 (&net->dev_unreg_lock){+.+.}-{3:3}, at: unregister_netdevice_move_net net/core/dev.c:-1 [inline]
> ffffffff9a9b0418 (&net->dev_unreg_lock){+.+.}-{3:3}, at: __dev_change_net_namespace+0x1479/0x2200 net/core/dev.c:12768
> 
> but task is already holding lock:
> ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
> ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: unregister_netdevice_move_net net/core/dev.c:-1 [inline]
> ffff88810b6cf8d8 (&net->dev_unreg_lock){+.+.}-{3:3}, at: __dev_change_net_namespace+0x146a/0x2200 net/core/dev.c:12768
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(&net->dev_unreg_lock);
>   lock(&net->dev_unreg_lock);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation

Oh right, I'll squash this to patch 6.

---8<---
diff --git a/net/core/dev.c b/net/core/dev.c
index 57fb4741d0ac..fcd58c2aa030 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -12574,10 +12574,10 @@ static void unregister_netdevice_move_net(struct net *net_old,
 {
 	if (net_old > net) {
 		spin_lock(&net->dev_unreg_lock);
-		spin_lock(&net_old->dev_unreg_lock);
+		spin_lock_nested(&net_old->dev_unreg_lock, SINGLE_DEPTH_NESTING);
 	} else {
 		spin_lock(&net_old->dev_unreg_lock);
-		spin_lock(&net->dev_unreg_lock);
+		spin_lock_nested(&net->dev_unreg_lock, SINGLE_DEPTH_NESTING);
 	}
 
 	if (!list_empty(&dev->unreg_list_net)) {
---8<---
