Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B500119E968
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 08:11:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785485496; cv=none; b=mFznEdveP0fKuAsFwX75W7BM2FyPz6XEybiUqDCaC6IYjs47kXeeG9ooHYocSWG7bQIL8lJPdV1h+02z4MPWSOk8HzIjfD63np/Fd0ELWQItdGgvUnoBmOj8MnXLUahqmdsBts2B/s5nX+KcPwbp9cjDiGtobTE0y3m5F+FHFhY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785485496; c=relaxed/simple;
	bh=kaB1SnS5NNcEI3oMZvqmD48LGH0YShQmEmyh1BkqvVM=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=d9/heYZubHagahUmcvgh0IDpmTardHD7DFNTLwdhYwryR/VeRtJImNdWiGmqNZ8PZ36UQ5gUS7Ej4CrGd2S7+Mdps/WIUfdz+vwxDeA/r5r2cjg0PHG3EqSuMDaNoLvH/BJOpNqXYam1jdQ7PfkepJ2jMH329gz9nsXV04uUpAg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DtmGBreb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DtmGBreb"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7D7701F000E9;
	Fri, 31 Jul 2026 08:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785485494;
	bh=0PoYc4kQaPHTaOKHXJtvRIMy2klYi1Xj0352RMGjLuw=;
	h=From:To:Cc:Subject:Date;
	b=DtmGBrebiKaltKegSpCu6DDWE79d/x5wuOETSuj+RbaDU9JkshWLgiRiOHn2fqFNc
	 FDfJlz+z0hBH0iPPYQ6H3LWEKHJwnsn1lvL4YYECGa0ASFVuDe3/M0Uap8mbIcNkT8
	 1dAOh7vuXfIjL9C86PI8SjzsfGoFrYrXcg4rr7VGTLQCNCfgkv9ZtbJw5A+57XSfRV
	 Q7vwD50EMHgCcSb2jSl5ZCMDdTtPvdNPZMQh7PdLDrfwkFwsne3+DPWhnZMX80918C
	 8XelMkeUYPDt+9ekSHhIWYI8uZM3PSLMHmQWfue2goxGomgOrhvkhxJ56RJGnNLUB7
	 1oTZnlHWNBxWg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] xfrm: add missing RCU read lock in xfrm_send_migrate_state()
Message-ID: <7c563560-c865-48d0-a1af-7d786d353d3c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 08:11:34 +0000 (UTC)

xfrm_nlmsg_multicast() requires the RCU read lock to be held because it
safely dereferences the net->xfrm.nlsk pointer using rcu_dereference().
When it is called from xfrm_send_migrate_state(), the RCU read lock is not
held, which triggers a suspicious RCU usage warning:

WARNING: suspicious RCU usage
net/xfrm/xfrm_user.c:1630 suspicious rcu_dereference_check() usage!

Call Trace:
 lockdep_rcu_suspicious+0x13f/0x1d0 kernel/locking/lockdep.c:6876
 xfrm_nlmsg_multicast+0x1d8/0x1f0 net/xfrm/xfrm_user.c:1630
 xfrm_send_migrate_state+0x870/0xae0 net/xfrm/xfrm_user.c:3340
 xfrm_do_migrate_state+0x1749/0x1e90 net/xfrm/xfrm_user.c:3507
 xfrm_user_rcv_msg+0x7a8/0xf30 net/xfrm/xfrm_user.c:3907

Fix this by wrapping the xfrm_nlmsg_multicast() call in
xfrm_send_migrate_state() with rcu_read_lock() and rcu_read_unlock().

Fixes: a9d155ea9b44 ("xfrm: add XFRM_MSG_MIGRATE_STATE for single SA migration")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c0e99a1aa85a286d7a3b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c0e99a1aa85a286d7a3b
Link: https://syzkaller.appspot.com/ai_job?id=8977f559-3a7e-4bb5-b4d6-1196956260b6
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Herbert Xu" <herbert@gondor.apana.org.au>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Steffen Klassert" <steffen.klassert@secunet.com>
To: "Antony Antony" <antony.antony@secunet.com>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/xfrm/xfrm_user.c b/net/xfrm/xfrm_user.c
index d6db63304..0ba0614d6 100644
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -3337,7 +3337,11 @@ static int xfrm_send_migrate_state(struct net *net,
 		return err;
 	}
 
-	return xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_MIGRATE);
+	rcu_read_lock();
+	err = xfrm_nlmsg_multicast(net, skb, 0, XFRMNLGRP_MIGRATE);
+	rcu_read_unlock();
+
+	return err;
 }
 
 static int xfrm_do_migrate_state(struct sk_buff *skb, struct nlmsghdr *nlh,


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
