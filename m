Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EA83CB565;
	Fri, 31 Jul 2026 10:06:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785492403; cv=none; b=LwoD3wJpHVuA/hjg8V0IRN/7WU+aasc/drQCWoGSlqv58A4LCeSr99TIzBFdLcgiJn/vlijRT1/rFu8OWXarmjgAhrpFqs0QmmbNRqLI1Dfe5sJYnTZbC5GK8aLxEc2Aox8XKiW5TUBPfijWffyGjAJCWLm3UqBTSslE/r63whM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785492403; c=relaxed/simple;
	bh=wx4kngmNrTo/NSw75ebXXyzUURVJejqXFLaIDkBKXqo=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=i7zjbN4PrEI5gb2/uPU9DmfbkxUp6bdi987SemI67TiuoFBRwIS1oH8+lXbrbaro9CuqqHuvojoENBhsJcQnO+veDKESPOEVzt3nZXAvs+mcHFKj8xjuvMhSo/iYJUYdOFXkUhpveOYJcjitNgSqzttQam7khj8+6mVTMnGW9tM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Rou5vz6Q; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Rou5vz6Q"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A05E41F00A3A;
	Fri, 31 Jul 2026 10:06:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785492381;
	bh=1PAjhfiJGNKE7o1Y+80U2ZTuRF/fFH0ZTMJo/XOsbh8=;
	h=From:To:Cc:Subject:Date;
	b=Rou5vz6QmgO1xtAD5B/GAXzPW0AYW7cXXf8RLp7YJhnwmBkEBE1AA/SopkBs2gCEL
	 PPQ2NXzRhrN9VfLOqQONHzQ/+9YDKUlkC69+FZbw4VSekfQFlk5+66meWCR3qeP9i0
	 9OYzLSfiTtn9UTf9DmD0ozYPJe5xmqlKJsy5ygdDZMYt82ElsGzIf4+pjBci6FOZ0I
	 m5jXSbn5bLeQYcaS5sWIQyJZPKwwPQ6t+NqRE92FzmWOctC/8TQOqw12s8D9EdYPig
	 /NEzggSmpW6d+HHZXw9BSHXTZC5qOec8yNRlU8uXN2Or5VpYPfxHPjAGfwzu77hTJ0
	 Yvsn6NFUcRR+Q==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, "David S. Miller" <davem@davemloft.net>, "Eric Dumazet" <edumazet@google.com>, "Herbert Xu" <herbert@gondor.apana.org.au>, "Jakub Kicinski" <kuba@kernel.org>, <netdev@vger.kernel.org>, "Paolo Abeni" <pabeni@redhat.com>, "Steffen Klassert" <steffen.klassert@secunet.com>, "Antony Antony" <antony.antony@secunet.com>
Cc: horms@kernel.org, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] xfrm: add missing RCU read lock in xfrm_send_migrate_state()
Message-ID: <2f866679-25c2-4b17-9fa6-086d4c3b593f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 10:06:20 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

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
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
