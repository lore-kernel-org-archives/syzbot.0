Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38F283DB961
	for <syzbot@lists.linux.dev>; Wed, 20 May 2026 12:00:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779278452; cv=none; b=dMrFHqWcrEpqVck1RVzQ1wWrwDPVfrTboMNiCSw7Wwm1215NLq6g0PgMGPWrXj/BmvUrLnbOl6nKLLJitf550hnUx6x4nxBmQ0BVb+m/UPc4YLIagP0ELDtftj2nSsSgNoxhTPKybD8WncBGCF4V3Pd1SECA4Q5mQCMaYZEIe40=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779278452; c=relaxed/simple;
	bh=3Tansk9OP3EqUVxhHnTpSvpDKQwVHqFXePkXlOppfmc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=n5IIcJzIqFXQitgquR7N6XFWWAxuBob/OO3qpaZX7WYMM+ipIjobdR02gihBlePXaNdJX+nACZJuTfsA3RGZGkaL+vFuNHyU4q8Jc1TV60sLKoUuH95ECyRtiZny6tEgqUHlyN+VpDRZLJXiSdmhzZhW31aUKNEtIAe0JtCVSoQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WcyfKEnG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WcyfKEnG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D3F9E1F000E9;
	Wed, 20 May 2026 12:00:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779278450;
	bh=+rT5mbf/WCyb7Mp/wyEJFokOyMQY4Xa0JXVtcqhFAkQ=;
	h=From:To:Cc:Subject:Date;
	b=WcyfKEnGxZSm6XMmtAvvM0KwxjR/euUcKmRnpnOa3vDDqZ+eiNBre6E72BrSJN4FX
	 3UdrohDlv681aF4ngGooKPMFe1svOFbtYjF8xgWfNLZGhmFjwogsA0bpBqSFE8rCuL
	 Pt9QgWW+/KOa2OvTjqrlySLhcn/eLHvhpmzBaGkaSR8TBuAysDCRZLQ/eTjSn+bXjx
	 xnwS4NgEQVuAwbN10op8962Y6jO1SCrmvqUyNPULvfvtNVNUzXSSh8xtVJQWlxZ6dB
	 V3Ntj4Uk28TIAZyik2FJsvB1vodpZQK2Z+VUhHY4j97z6jEkpvkjKJdpyxhZYziAsl
	 hQqXfz+G4/DZw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] net/sched: fix watchdog timer teardown race
Message-ID: <0218bc04-f3e4-492b-a6a8-ae0d487c487b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 20 May 2026 12:00:50 +0000 (UTC)

A race condition exists between network device unregistration and
concurrent link state change events (e.g., usbnet_deferred_kevent).
During device unregistration, __dev_close_many() clears
__LINK_STATE_START and calls netdev_watchdog_down() to delete the
watchdog timer. However, a concurrent link state change can call
netif_carrier_on(), which checks netif_running(dev). If this check
happens before __LINK_STATE_START is cleared, it proceeds to call
netdev_watchdog_up(). If netdev_watchdog_up() is delayed and executes
after netdev_watchdog_down() has deleted the timer, it will re-arm the
timer. This leaves the timer armed during the final teardown phase,
eventually triggering the WARN_ON(timer_pending(&dev->watchdog_timer))
in dev_shutdown().

Attempting to fix this by adding a lock-free double-check in
netdev_watchdog_up() introduces a subtle refcount underflow bug.
Instead, the most robust approach is to ensure the timer is completely
dead during the final teardown phase. Since dev_shutdown() is called
from process context under the rtnl_lock(), it is safe to sleep and
block. We can use timer_delete_sync() in dev_shutdown() to deactivate
the timer and wait for any concurrently running callbacks to finish. If
the timer was left armed, timer_delete_sync() returns 1, allowing us to
safely call netdev_put() to balance the refcount. The WARN_ON is removed
as it must not be used for conditions that can legitimately happen.

Fixes: d7811e623dd4 ("[NET]: Drop tx lock in dev_watchdog_up")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+c9ecf60a8adb7629821e@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=c9ecf60a8adb7629821e
Link: https://syzkaller.appspot.com/ai_job?id=dfe990fd-fc25-4b79-960c-52708991b04c
To: <davem@davemloft.net>
To: <edumazet@google.com>
To: <jhs@mojatatu.com>
To: <jiri@resnulli.us>
To: <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: <pabeni@redhat.com>
Cc: <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Removed WARN_ON() in dev_shutdown() as it is no longer needed after timer_delete_sync().

v1:
https://lore.kernel.org/all/07235ee0-41fb-43e2-8391-d1e398576250@mail.kernel.org/T/
---
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index a93321db8..ad2ba1d89 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1493,7 +1493,8 @@ void dev_shutdown(struct net_device *dev)
 	qdisc_put(rtnl_dereference(dev->qdisc));
 	rcu_assign_pointer(dev->qdisc, &noop_qdisc);
 
-	WARN_ON(timer_pending(&dev->watchdog_timer));
+	if (timer_delete_sync(&dev->watchdog_timer))
+		netdev_put(dev, &dev->watchdog_dev_tracker);
 }
 
 /**


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
