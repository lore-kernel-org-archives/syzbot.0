Received: from mail-pl1-f202.google.com (mail-pl1-f202.google.com [209.85.214.202])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8C0E331A73
	for <syzbot@lists.linux.dev>; Thu,  6 Nov 2025 17:59:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.202
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762451970; cv=none; b=KE7cW42b21fQIHxelTKajEabLJ55GB8+O/FBlyvq7OjEFUlH7ySzmgn9Smc1VA7PaSuELuMlRYsaxDBOrDTUhhcMLhF89FGaADVK7jLOHynlRBtkTrZsFRsDh/9Nhw45BwamwnPYid8nNknUHGbyNuGpiG27uYxpxF32kHVRP58=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762451970; c=relaxed/simple;
	bh=xSVGRPx3y1VkSRnywmF7Wg5iYBXo/Kvvd1CAtmdbmVU=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=cZFqBCIzTjvUEFCGei44bCF0cuYXvon5wL2lyjMccV/zzoQR3PkFMVyMHZaBAMpL2cklqN3UY+y4oekCrQ0IefHHeA3fMlPn9dk0IPsVb3ZmAuofP8gUb59Tcp2luN0EfScZDHz+u4OdElOaOKf5zBKMSOKdnYO730LiUdF2dzU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EPqiiLq5; arc=none smtp.client-ip=209.85.214.202
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--kuniyu.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EPqiiLq5"
Received: by mail-pl1-f202.google.com with SMTP id d9443c01a7336-2958a134514so17501355ad.2
        for <syzbot@lists.linux.dev>; Thu, 06 Nov 2025 09:59:28 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762451968; x=1763056768; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=vlK4zA0L4la+hUwKhdxukg4u3+leU5PJEuHeams2xYc=;
        b=EPqiiLq5w+yGESQ783nv6uIQf6s8QMXSmNXjsSZc+DRfMwU3FYQJKblwPXK/jFVZpV
         VmoVtCqvcwI9ru1sZerDpavXTSkol6giU+nUDFb+emRmOLDqO3cznEe/VVd2iZ//YQ2/
         aNIY+HSLR7BlJKds0C7ZKDpeXYKYdcq26MBmMnR1e/O4w4hyyzNafzSUDJtRV1cZoFxl
         UeckHCx3AnYjHj0F1YAOSVchY0A5Laxr8YmFTrrLrlut+xGxYt11z6IjEv5A8bLNVAxj
         4HQ4oRtI0GAkNZoYUAvrNXNhUq5rUe0x+YqF6/qH11Pi9lxU+njvyIxqP0ax5Vf124t/
         x7tQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762451968; x=1763056768;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=vlK4zA0L4la+hUwKhdxukg4u3+leU5PJEuHeams2xYc=;
        b=ALcL7PrcIZaWCS8qst8sBhgLnUSG9Fb/bf1gl40CpvS8kPuulNmtOluO5Rx2WPbti3
         ybwjUWFRlC8jiH797lXr6ajY/nSK6NTMi1H/p9RyuW9UzQ87znDVkcaVKYr2ZMQquouP
         Q7R6DgvkoHu3f45ThRz6OvxtN3wVMAqyn1arZo1rVRaKcRgo8uhgvdedUcwfXRx6+uGU
         ROl/RTiyPrngR1bb4DvFHmRV5sMe5rbGaXw8+BVM6kPcaabnqpbPHRRc2TeU9SuTCHpG
         j2hvPNEIhBF/Wf2ef43y6YqhMbhKolUZg8fcEMfh0+GUrLQGX5mh6/W60KNh67lpB829
         xgFQ==
X-Forwarded-Encrypted: i=1; AJvYcCWln4Sqcy3YnfuAdiIn/BFnIEvjm9MB++wvInk3N3FqMWbLLOVMYdO6SP8oonPtyYRxgsO9yNM=@lists.linux.dev
X-Gm-Message-State: AOJu0YzQmdl2iMxhXb2WIxC7Tm/YpRK6PwF1WH7B9fkjrc5EbFzuKhZC
	ws7GUcpuS6/YolRRCZ5ZEF5oLzAGB55mmufArqDqTyv+ynCeNprRfrFEF7Ll+dvrOoojZUx0UKp
	Mm++QXw==
X-Google-Smtp-Source: AGHT+IHYgX3mamcW6m7/cjCmJ0bMP247Tz2g55dHDPwjBo8YXouwntVi6jG9ucj4Q3XXuB7YD3dZNuqmZSU=
X-Received: from plqt4.prod.google.com ([2002:a17:902:a5c4:b0:290:28e2:ce54])
 (user=kuniyu job=prod-delivery.src-stubby-dispatcher) by 2002:a17:902:e84f:b0:295:64f8:d9cd
 with SMTP id d9443c01a7336-297c03ea736mr4913255ad.15.1762451967878; Thu, 06
 Nov 2025 09:59:27 -0800 (PST)
Date: Thu,  6 Nov 2025 17:59:17 +0000
In-Reply-To: <690c6ca9.050a0220.1e8caa.00d2.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <690c6ca9.050a0220.1e8caa.00d2.GAE@google.com>
X-Mailer: git-send-email 2.51.2.1041.gc1ab5b90ca-goog
Message-ID: <20251106175926.686885-1-kuniyu@google.com>
Subject: [syzbot ci] Re: tipc: Fix use-after-free in tipc_mon_reinit_self().
From: Kuniyuki Iwashima <kuniyu@google.com>
To: syzbot+cif2d6d318f7e85f0b@syzkaller.appspotmail.com
Cc: davem@davemloft.net, edumazet@google.com, hoang.h.le@dektech.com.au, 
	horms@kernel.org, jmaloy@redhat.com, kuba@kernel.org, kuni1840@gmail.com, 
	kuniyu@google.com, netdev@vger.kernel.org, pabeni@redhat.com, 
	syzbot@lists.linux.dev, syzbot@syzkaller.appspotmail.com, 
	syzkaller-bugs@googlegroups.com, tipc-discussion@lists.sourceforge.net
Content-Type: text/plain; charset="UTF-8"

From: syzbot ci <syzbot+cif2d6d318f7e85f0b@syzkaller.appspotmail.com>
Date: Thu, 06 Nov 2025 01:38:49 -0800
> syzbot ci has tested the following series
> 
> [v1] tipc: Fix use-after-free in tipc_mon_reinit_self().
> https://lore.kernel.org/all/20251106053309.401275-1-kuniyu@google.com
> * [PATCH v1 net] tipc: Fix use-after-free in tipc_mon_reinit_self().
> 
> and found the following issue:
> possible deadlock in tipc_mon_reinit_self
> 
> Full report is available here:
> https://ci.syzbot.org/series/bfabf013-65e3-4ca9-8f54-0c7eef8be01a
> 
> ***
> 
> possible deadlock in tipc_mon_reinit_self
> 
> tree:      net
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
> base:      3d18a84eddde169d6dbf3c72cc5358b988c347d0
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/b2774856-e331-420e-a340-5107ec4b06f9/config
> C repro:   https://ci.syzbot.org/findings/1f0a4298-b797-4217-8d6d-15f98c0ffd38/c_repro
> syz repro: https://ci.syzbot.org/findings/1f0a4298-b797-4217-8d6d-15f98c0ffd38/syz_repro
> 
> tipc: Started in network mode
> tipc: Node identity 4, cluster identity 4711
> tipc: Node number set to 4
> ============================================
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> syz.0.17/5963 is trying to acquire lock:
> ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: tipc_mon_reinit_self+0x25/0x360 net/tipc/monitor.c:714
> 
> but task is already holding lock:
> ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: __tipc_nl_compat_doit net/tipc/netlink_compat.c:358 [inline]
> ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: tipc_nl_compat_doit+0x1fd/0x5f0 net/tipc/netlink_compat.c:393
> 
> other info that might help us debug this:
>  Possible unsafe locking scenario:
> 
>        CPU0
>        ----
>   lock(rtnl_mutex);
>   lock(rtnl_mutex);
> 
>  *** DEADLOCK ***
> 
>  May be due to missing lock nesting notation
> 
> 3 locks held by syz.0.17/5963:
>  #0: ffffffff8f331050 (cb_lock){++++}-{4:4}, at: genl_rcv+0x19/0x40 net/netlink/genetlink.c:1218
>  #1: ffffffff8f330e68 (genl_mutex){+.+.}-{4:4}, at: genl_lock net/netlink/genetlink.c:35 [inline]
>  #1: ffffffff8f330e68 (genl_mutex){+.+.}-{4:4}, at: genl_op_lock net/netlink/genetlink.c:60 [inline]
>  #1: ffffffff8f330e68 (genl_mutex){+.+.}-{4:4}, at: genl_rcv_msg+0x10d/0x790 net/netlink/genetlink.c:1209
>  #2: ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: __tipc_nl_compat_doit net/tipc/netlink_compat.c:358 [inline]
>  #2: ffffffff8f2cb1c8 (rtnl_mutex){+.+.}-{4:4}, at: tipc_nl_compat_doit+0x1fd/0x5f0 net/tipc/netlink_compat.c:393
> 
> stack backtrace:
> CPU: 1 UID: 0 PID: 5963 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_deadlock_bug+0x28b/0x2a0 kernel/locking/lockdep.c:3041
>  check_deadlock kernel/locking/lockdep.c:3093 [inline]
>  validate_chain+0x1a3f/0x2140 kernel/locking/lockdep.c:3895
>  __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
>  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>  __mutex_lock_common kernel/locking/mutex.c:598 [inline]
>  __mutex_lock+0x187/0x1350 kernel/locking/mutex.c:760
>  tipc_mon_reinit_self+0x25/0x360 net/tipc/monitor.c:714
>  tipc_net_finalize+0x115/0x190 net/tipc/net.c:140
>  tipc_net_init+0x104/0x190 net/tipc/net.c:122
>  __tipc_nl_net_set+0x3b9/0x5a0 net/tipc/net.c:263

I missed another path calling tipc_net_finalize under RTNL.

I'll change v2 this way.

---8<---
diff --git a/net/tipc/monitor.c b/net/tipc/monitor.c
index 46c8814c3ee6..be1e51efc445 100644
--- a/net/tipc/monitor.c
+++ b/net/tipc/monitor.c
@@ -706,12 +706,13 @@ void tipc_mon_delete(struct net *net, int bearer_id)
 	kfree(mon);
 }
 
-void tipc_mon_reinit_self(struct net *net)
+void tipc_mon_reinit_self(struct net *net, bool rtnl_held)
 {
 	struct tipc_monitor *mon;
 	int bearer_id;
 
-	rtnl_lock();
+	if (!rtnl_held)
+		rtnl_lock();
 
 	for (bearer_id = 0; bearer_id < MAX_BEARERS; bearer_id++) {
 		mon = tipc_monitor(net, bearer_id);
@@ -723,7 +724,8 @@ void tipc_mon_reinit_self(struct net *net)
 		write_unlock_bh(&mon->lock);
 	}
 
-	rtnl_unlock();
+	if (!rtnl_held)
+		rtnl_unlock();
 }
 
 int tipc_nl_monitor_set_threshold(struct net *net, u32 cluster_size)
diff --git a/net/tipc/net.c b/net/tipc/net.c
index 0e95572e56b4..56527f6f548c 100644
--- a/net/tipc/net.c
+++ b/net/tipc/net.c
@@ -119,11 +119,11 @@ int tipc_net_init(struct net *net, u8 *node_id, u32 addr)
 	if (node_id)
 		tipc_set_node_id(net, node_id);
 	if (addr)
-		tipc_net_finalize(net, addr);
+		tipc_net_finalize(net, addr, true);
 	return 0;
 }
 
-static void tipc_net_finalize(struct net *net, u32 addr)
+static void tipc_net_finalize(struct net *net, u32 addr, bool rtnl_held)
 {
 	struct tipc_net *tn = tipc_net(net);
 	struct tipc_socket_addr sk = {0, addr};
@@ -137,7 +137,7 @@ static void tipc_net_finalize(struct net *net, u32 addr)
 	tipc_set_node_addr(net, addr);
 	tipc_named_reinit(net);
 	tipc_sk_reinit(net);
-	tipc_mon_reinit_self(net);
+	tipc_mon_reinit_self(net, rtnl_held);
 	tipc_nametbl_publish(net, &ua, &sk, addr);
 }
 
@@ -145,7 +145,7 @@ void tipc_net_finalize_work(struct work_struct *work)
 {
 	struct tipc_net *tn = container_of(work, struct tipc_net, work);
 
-	tipc_net_finalize(tipc_link_net(tn->bcl), tn->trial_addr);
+	tipc_net_finalize(tipc_link_net(tn->bcl), tn->trial_addr, false);
 }
 
 void tipc_net_stop(struct net *net)
---8<---
