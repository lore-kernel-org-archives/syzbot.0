Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65DD716A395
	for <syzbot@lists.linux.dev>; Wed, 13 May 2026 21:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778706970; cv=none; b=OLdg2t/KlyUBHXDpTXSc5e8e5985L4IHEHMKRD5Q4DMktHzRJLknDDnhNqUjeCE5gkX703qDZpJNVFmj73VMIKmM8GF8Dcz06SFyWKq/cSAFEfXocT3tSO4lbOn3qcsjOyyxSVGk+mNNXgCI0ZKnQ3dh3jF7cHEyvw+3budj+So=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778706970; c=relaxed/simple;
	bh=2tUGaPRX7o/OMLeGefJD9NWjH+USpyaYSdGeHZP/1Eo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=uaUy1MNOje007iz+HisoTTzgxTWVGjdQzbwzK+CGOfgH0WZofmYRtHbYdAj+FUAqTAD17d4vAPtRyNxMdmed6hI4qyuEon60xGvsP+yhhPGX9uJMn7TW2N4IHS8OlFOut/SwZiaXZTpwAvyLKrclzxWtwVk4PLjWbpuDjY23VJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JQnxqvZJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JQnxqvZJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5CDCC19425;
	Wed, 13 May 2026 21:16:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778706970;
	bh=2tUGaPRX7o/OMLeGefJD9NWjH+USpyaYSdGeHZP/1Eo=;
	h=From:To:Cc:Subject:Date:From;
	b=JQnxqvZJrFWX/I5zVGV7RiLZ5ggnz3txTuzrimgVA5iREy4Yt92/eXlvY16JpU9W5
	 8+kMhGw1BWF5we/7uXWG51cXTRffMho9A7dZaGI1b4JEpa2Yh+tOrnN6vu9BB04Kt1
	 RLJneWiObdJQLDald795z5xOWVuSQhjPjzTlOXo3XcrEq1ky5ZR6ah/yuGJeFih7nK
	 w7XEXnpkF1asGX3cttI2DaVgl2CPEPMYXjRYZKN9vTPJsfX5NuMY6eXVh+O/XCuGur
	 mVJe2rsa9hnUuZjHE08VKJ7FOqPYfkL20l7YC6Wswh0QTD0GOU3Wq3FOnsv0SVyTc4
	 M3URYdHwBPUQA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] net/sched: fix watchdog timer teardown race
Message-ID: <07235ee0-41fb-43e2-8391-d1e398576250@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 13 May 2026 21:16:09 +0000 (UTC)

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
safely call netdev_put() to balance the refcount. This guarantees that
the timer is definitively dead before the WARN_ON check.

Fixes: d7811e623dd4be3e3bdba2d6330f7f15541ee45f ("[NET]: Drop tx lock in dev_watchdog_up")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+c9ecf60a8adb7629821e@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=c9ecf60a8adb7629821e
Link: https://syzkaller.appspot.com/ai_job?id=2f0da36f-92ca-4f82-a3f9-92648d57a2ae
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
diff --git a/net/sched/sch_generic.c b/net/sched/sch_generic.c
index a93321db8..e4e72077b 100644
--- a/net/sched/sch_generic.c
+++ b/net/sched/sch_generic.c
@@ -1493,6 +1493,8 @@ void dev_shutdown(struct net_device *dev)
 	qdisc_put(rtnl_dereference(dev->qdisc));
 	rcu_assign_pointer(dev->qdisc, &noop_qdisc);
 
+	if (timer_delete_sync(&dev->watchdog_timer))
+		netdev_put(dev, &dev->watchdog_dev_tracker);
 	WARN_ON(timer_pending(&dev->watchdog_timer));
 }
 


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
