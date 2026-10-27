Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.210.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793081174;
	b=AqhWrwRz5EytYa9a3jgIH81DLfV2gCTZ8F4xnDg8cKovbY5K1iSh60JU65o3FARxU/ny
	 PBRY/scwcDRPzyTMzPTpHFyxZZ5ArTsZoFy2NrTK+FeYU5ojdxOd0Oizq7fJOXDsm8a6R
	 Oc1aYE3cPx/n+sR0OBLxk46oF0IsaOUpgqvfjqSf3ka3jHR/9UZ7L7OXVWSV74HciQ6yx
	 /WYXor/6hDOIGHsZIr/93WbuteKl+zK38c+sxRUSV9rDbtYXq/GBm35lk5UxFs8esAj15
	 1m0BPnbm3vYUv385EnM5OLeiXiMdW/va2nvC88mOQNiP4BTbWGZ6fYfH7V3KUTsLHVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793081174;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Received:Date:In-Reply-To:
	 Mime-Version:References:Message-ID:Subject:From:To:Cc:Content-Type;
	bh=HugHoNwV0a8ZVG74tvhwsfKr72+xwItQRmOVGQ+j3x0=;
	b=uex3NrmGd8/aCZdNtcSi4FN2dLxRtkrsaNP56jHlriDmnosC/fxl0AJA4yuVHWIM2HB5
	 5EaW+0rgMyIKAuHZz+rlFGCWOVLZytd7JiJUQy3PvSM7vkLJmBohckKVolHhFTju8bCyg
	 w1jP2AAZeXlHv0YPJ3nhmDMasTN2OxFv97Fx9J+j8rnUckAg9iua5S2sTqPWaxtWdufVp
	 3drONXxVdWz3xo4lst6ndaCjTmX9r1jTkWLkFY2i1PY/xg2r9KKVQPJWXSRGcRTqj4wb4
	 cqAlBzmXODKD0cFt9XQSaoYrblDIYx6lU3g0FFJG/UT8i8io3+5ZXTse/cUofJK0LsQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=StLoDiZW;
	arc=none smtp.remote-ip=209.85.210.200
Received: from mail-pf1-f200.google.com (mail-pf1-f200.google.com [209.85.210.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4B744606A31A
	for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 06:06:14 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4B744606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20251104 header.b=StLoDiZW
Received: by mail-pf1-f200.google.com with SMTP id d2e1a72fcca58-8a079256596so3022172b3a.0
        for <syzbot@lists.linux.dev>; Mon, 26 Oct 2026 23:06:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1793081174; x=1793685974; darn=lists.linux.dev;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HugHoNwV0a8ZVG74tvhwsfKr72+xwItQRmOVGQ+j3x0=;
        b=StLoDiZWaDoGpk+OlPOXLG3ts9IMf5FxEZr8TF69Mj8363wsz5Gvdl3QUD3P0CIHcK
         8NsoXQiHC87HD9HD3GHu/q6/vcJFfflMC8UZHRz8tPTftIUWMPraExFL+dbrXzYI8GjG
         rOP75+z5GeMwSDhBZj6yWVicJ3OaNJIxeRJrao/cs9c+JQ+FLivsekf/c9k1eC/w9XiZ
         gJwfeVEFaGe+xQeRkOiT964/BetrQURIS1oYSpKwuNe8yFgzCxLodCK1wDmUcaYmXbfa
         5E8zuqbatH2y9s4dyVJZJs/qL4aVbRGa6L3XSCBXPGElxYtl+GUlP/rUaN//KpQkZtGi
         6rOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793081174; x=1793685974;
        h=content-type:cc:to:from:subject:message-id:references:mime-version
         :in-reply-to:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HugHoNwV0a8ZVG74tvhwsfKr72+xwItQRmOVGQ+j3x0=;
        b=oKnspn9BZoMzofaB4p36as/xBOHOlEtw0bxoMufDFq3Y8QKuFUKkYDCRE5djxdc/d2
         HRVFV+aFSLYLSL5iCh6/BQCiXD9+cAufSOyYXFCzhfxGSeIBsmGY/vsY4vPdB2Gs+MrF
         pwdDR5yAFVVLeOeYSAZpHum9XUxQMRH0DkQnniB1YOUhWJv5TA0ZqHZbinjsS5Uarngm
         NFSYDXarPLp157yoZ7t4PD/anKYSXJSMQxGnj6v6z5KmWl7Aa9Hcm3fMXkujCnCdydAt
         7rFpbCPltKjAss4+esgO7jrxAbo/A0Y7IQWIAmSMMcHgt2CT0nYIYU7Wfi+UvvP5H0Va
         D5pQ==
X-Forwarded-Encrypted: i=1; AKwUvBwsn6G+zBUUaUFISNRDtY2hk8nUaAIzocflI3PS4bd0xG9atW9/WR86cATmXTl40J9k5rrOjtk=@lists.linux.dev
X-Gm-Message-State: AFq9FYIEamvbvkI20yWyUnJxSD4gpHv6uXMBcwcYl9yImkD6hfGAAtiV
	IFnBOIpRCwhIzPepBM+sdbXcwKsu9lsJkLtTBQDwNo3rLX9cxvPVFGLhyPg9h4xUmjhZhPk9++J
	/4GCIUw==
X-Received: from pfwz19.prod.google.com ([2002:a05:6a00:1d93:b0:899:728c:3031])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a05:6a00:a16:b0:869:9298:ba50
 with SMTP id d2e1a72fcca58-8a3630d0a68mr6531030b3a.0.1793081173421; Mon, 26
 Oct 2026 23:06:13 -0700 (PDT)
Date: Tue, 27 Oct 2026 06:06:12 +0000
In-Reply-To: <6adce850.a26421ad.3bb4f4.0011.GAE@google.com>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
Mime-Version: 1.0
References: <20261023191517.607834-1-kuniyu@google.com> <6adce850.a26421ad.3bb4f4.0011.GAE@google.com>
Message-ID: <auA-0DznRAdDQR6D@google.com>
Subject: Re: [syzbot ci] Re: ipv6: Protect multiple routes insertion by table lock.
From: Kuniyuki Iwashima <kuniyu@google.com>
To: syzbot ci <syzbot+ci1c0f05215dd3ab6b@syzkaller.appspotmail.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@kernel.org, 
	horms@kernel.org, idosch@nvidia.com, kuba@kernel.org, kuni1840@gmail.com, 
	netdev@vger.kernel.org, pabeni@redhat.com, syzbot@syzkaller.appspotmail.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="us-ascii"

On Sat, 24 Oct 2026 10:18:08 -0700, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] ipv6: Protect multiple routes insertion by table lock.
> https://lore.kernel.org/all/20261023191517.607834-1-kuniyu@google.com
> * [PATCH v1 net] ipv6: Protect multiple routes insertion by table lock.
> 
> and found the following issue:
> WARNING: suspicious RCU usage in rt6_multipath_rebalance
> 
> Full report is available here:
> https://ci.syzbot.org/series/7d878fa2-f84a-4468-85e2-c2a5e263aeff
> 
> ***
> 
> WARNING: suspicious RCU usage in rt6_multipath_rebalance
> 
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
> base:      7076f684d5132e6a6145e1da2fa74771ecd052e5
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/bbb3053f-f23f-4fe3-a9e9-85396428119d/config
> 
> IPv6: RTM_NEWROUTE with no NLM_F_CREATE or NLM_F_REPLACE
> IPv6: NLM_F_CREATE should be set when creating new route
> =============================
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/net/addrconf.h:351 suspicious rcu_dereference_check() usage!
> 
> other info that might help us debug this:
> 
> 
> rcu_scheduler_active = 2, debug_locks = 1
> locks held by syz.2.3386/18922: 1, last CPU#0:
>  #0: ffff888177df3430 (&tb->tb6_lock){+...}-{3:3}, at: inet6_rtm_newroute+0x3dc/0x1ab0
> 
> stack backtrace:
> CPU: 0 UID: 0 PID: 18922 Comm: syz.2.3386 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  lockdep_rcu_suspicious+0x140/0x1d0
>  rt6_multipath_rebalance+0xf11/0x1080
>  fib6_del+0xada/0x15a0

Similar to 8e5f1bb81274 ("ipv6: Narrow down RCU critical section
in inet6_rtm_newroute()."), I had to wrap rt6_multipath_rebalance()
with RCU.

Will squash this:

---8<---
diff --git a/net/ipv6/ip6_fib.c b/net/ipv6/ip6_fib.c
index 0dc6ebee6e56..f7c69c9df411 100644
--- a/net/ipv6/ip6_fib.c
+++ b/net/ipv6/ip6_fib.c
@@ -1228,9 +1228,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 			fib6_nsiblings++;
 		}
 		BUG_ON(fib6_nsiblings != rt->fib6_nsiblings);
-		rcu_read_lock();
 		rt6_multipath_rebalance(temp_sibling);
-		rcu_read_unlock();
 	}
 
 	/*
@@ -1274,9 +1272,7 @@ static int fib6_add_rt2node(struct fib6_node *fn, struct fib6_info *rt,
 						   sibling->fib6_nsiblings - 1);
 				WRITE_ONCE(rt->fib6_nsiblings, 0);
 				list_del_rcu(&rt->fib6_siblings);
-				rcu_read_lock();
 				rt6_multipath_rebalance(next_sibling);
-				rcu_read_unlock();
 				return err;
 			}
 		}
diff --git a/net/ipv6/route.c b/net/ipv6/route.c
index 5926ddbd4349..9618e7b635e9 100644
--- a/net/ipv6/route.c
+++ b/net/ipv6/route.c
@@ -4875,8 +4875,10 @@ void rt6_multipath_rebalance(struct fib6_info *rt)
 	if (WARN_ON_ONCE(!first))
 		return;
 
+	rcu_read_lock();
 	total = rt6_multipath_total_weight(first);
 	rt6_multipath_upper_bound_set(first, total);
+	rcu_read_unlock();
 }
 
 static int fib6_ifup(struct fib6_info *rt, void *p_arg)
---8<---

Thanks
