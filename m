Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2892F322768
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 02:25:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779330319; cv=none; b=Oh+3p68jDbGXBaNf+2bUYynlh7P7fL2RCLBLxl0wVUXCn0A+xcucIMUDGsbjiupv2omA5wIrBbEa8Z7g7Q7P/84KCfDJxf1Td4Cf5/b7UAoNMKeT/C8PkM7ocuADCi1mdAWopGuluwLWrMz1tbrKgvk22KtrKDEoa32moXf26Nc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779330319; c=relaxed/simple;
	bh=jOXRifCGYXobolDaymOJafU3wo+8rmSItA0KdWYu6Tg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=rXcYQ/cbieuQ/uvKu97IIMuF2S3ijitZ8B0Z7HOwGmq23DH77AXv/ZnPQskk0tAny09EKgUYW89rgoevjNNr5yQiAIW0saHeV18A1/8Wwq4qDe/t2VEFnVsiomgQgM9K2q5sv2aP96Z68t9e3B9XRbsqk9WlqSdQZHq7PWA82OE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=C0aYOXO4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="C0aYOXO4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0A0AA1F000E9;
	Thu, 21 May 2026 02:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779330314;
	bh=vh/0XKbhd/WbCLZBH6R+EPyXdcIr+3UztlFVVg5lgXU=;
	h=From:To:Cc:Subject:Date;
	b=C0aYOXO4C2dvuoB4KTskwl3+gXgntfGhLurtsslBGolB91CnD4bDVzXPkQZjclaG1
	 jZCM/Q/K4DrfzwTekScitEXUcVLZdlAZPKUXHdnRvgMB0BzvAbI16UPvk2Yh4CSV2X
	 CtNrJX8JRN+agMefSdhMma8mEsZ1RZhORGJGzIl3K2Gp77dZjIjM0XvgSfzGe0sUB/
	 AeM2Xk08+V7wQgcXYukaYCFQoNp76v4+OilMx51ynFv+j9IAeRvuh582MEEtlE9dom
	 lDzws5PPcAvtqPPVuJV+oC0Mi/psbrXD14vynUsVV9zrsoKI88yfUImm4OaV+H23+0
	 9zUaA1OL1B0FQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v3] net/sched: fix watchdog timer teardown race
Message-ID: <a11b5ba3-c4e6-45fe-b300-68fee86e210b@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 21 May 2026 02:25:14 +0000 (UTC)

A race condition exists between network device unregistration and
concurrent link state change events. During device unregistration,
__dev_close_many() clears __LINK_STATE_START and calls
netdev_watchdog_down() to delete the watchdog timer. However, a
concurrent link state change can call netif_carrier_on(), which checks
netif_running(dev). If this check happens before __LINK_STATE_START is
cleared, it proceeds to call netdev_watchdog_up(). If
netdev_watchdog_up() is delayed and executes after
netdev_watchdog_down() has deleted the timer, it will re-arm the timer.
This leaves the timer armed during the final teardown phase, eventually
triggering the WARN_ON(timer_pending(&dev->watchdog_timer)) in
dev_shutdown().

Attempting to fix this by adding a lock-free double-check in
netdev_watchdog_up() introduces a subtle refcount underflow bug.
Instead, the most robust approach is to ensure the timer is completely
dead during the final teardown phase. Since dev_shutdown() is called
from process context under the rtnl_lock(), it is safe to sleep and
block. We can use timer_delete_sync() in dev_shutdown() to deactivate
the timer and wait for any concurrently running callbacks to finish. If
the timer was left armed, timer_delete_sync() returns 1, allowing us to
safely call netdev_put() to balance the refcount. The WARN_ON is removed
because timer_delete_sync() ensures the timer is deactivated and any
running callbacks have finished, so timer_pending() would always be
false at this point, making the check redundant.

Fixes: d7811e623dd4 ("[NET]: Drop tx lock in dev_watchdog_up")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+c9ecf60a8adb7629821e@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c9ecf60a8adb7629821e
Link: https://syzkaller.appspot.com/ai_job?id=bc2d1423-0c8d-431e-8358-1c7038400024
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Jamal Hadi Salim" <jhs@mojatatu.com>
To: "Jiri Pirko" <jiri@resnulli.us>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Updated the explanation for removing the WARN_ON in the commit description.

v2:
- Removed WARN_ON() in dev_shutdown() as it is no longer needed after timer_delete_sync().
https://lore.kernel.org/all/0218bc04-f3e4-492b-a6a8-ae0d487c487b@mail.kernel.org/T/

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
