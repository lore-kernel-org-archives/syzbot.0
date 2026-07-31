Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30300489865
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 09:38:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785490686; cv=none; b=irumbi8Tmc+dxI/RIzgckQf2DgpPah+nAas76d/Ss0H2dxBLCu/idArpdkMK+byWH2iIo9Q1c5YC28h58nr5wsV48yDX0szCHl98jK0ZYjtsvr2A+D27kXPOOSYfJ1rDKrwIlruDTUI1uVPbBKmrpMHq1wuCMyYrPJ8kC0ir1oQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785490686; c=relaxed/simple;
	bh=U/7vgkDVn5JycvsNiTi5sIP/QucdsSue4yXens45su4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=heSA3/15fp/1+G1wJ+h7TjiJPzc03HtFpdl6rMWjA8PV/eSlwYdJeui4L3C+MTRXsC073hAZjAP7KnlAvXnGU2koWSRaMoych2VaJ0MKQQxHxFqwXOtCQVoV9ex4/Jh35T5LBajwJ1oT3PBGpi1+tlTKMuJ3h/ZSGfTfCi/l4R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=kTW8MDO0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="kTW8MDO0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 636441F000E9;
	Fri, 31 Jul 2026 09:38:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785490684;
	bh=FJy2PulH+WdhpXHHGVzmhPc/XOdP3cShyA8oJahHodY=;
	h=From:To:Cc:Subject:Date;
	b=kTW8MDO0+MwQ+8Dcm4rulGC+hpbEbJV3z00yf/ifEzfO7zphW29x9HpQBqvLKPRso
	 glrwFKzBpF+pfjGPjc066V+R6ISGrgOgCDWOa9XCcHDTClNiR14B89xaZ0YSd7Zsdl
	 nDLgyY4oGFqvyAgKOG60A493yh6V3cdohPyIM3t1v8ELocfFv8f66qHWQyVNpETClx
	 w1pzgRMdINMobCeytlXiLe8bGBfBRp9lssjBaZN3fswvtRa4mo0JRn/3sYOogseMv/
	 4sP6BziuGK9oZy4j0WXq9p0gil/KRMoKDId6eKivLlRYuNxK1411VpcmbmeQYQZPxk
	 /w3l7BgfsjDyg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] xfrm: add missing RCU read lock in xfrm_send_migrate_state()
Message-ID: <d9a2552d-df0d-4144-a5ad-1db7aabb3dee@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 31 Jul 2026 09:38:04 +0000 (UTC)

The xfrm_nlmsg_multicast() function requires the caller to hold the RCU
read lock because it uses rcu_dereference() to safely access
net->xfrm.nlsk.

When xfrm_send_migrate_state() is called directly from the netlink message
handler xfrm_do_migrate_state(), it bypasses the xfrm_mgr callbacks which
typically acquire the RCU read lock centrally. The netlink handler only
holds the xfrm_cfg_mutex and does not hold the RCU read lock, leading to a
suspicious RCU usage warning:

WARNING: suspicious RCU usage
net/xfrm/xfrm_user.c:1630 suspicious rcu_dereference_check() usage!

Call trace:
 lockdep_rcu_suspicious+0x168/0x26c kernel/locking/lockdep.c:6876
 xfrm_nlmsg_multicast net/xfrm/xfrm_user.c:1630 [inline]
 xfrm_send_migrate_state+0x6b0/0x958 net/xfrm/xfrm_user.c:3340
 xfrm_do_migrate_state+0x1114/0x1728 net/xfrm/xfrm_user.c:3507
 xfrm_user_rcv_msg+0x4e0/0x950 net/xfrm/xfrm_user.c:3907
 netlink_rcv_skb+0x238/0x414 net/netlink/af_netlink.c:2556
 xfrm_netlink_rcv+0x80/0x9c net/xfrm/xfrm_user.c:3929

Fix this by explicitly acquiring and releasing the RCU read lock around the
xfrm_nlmsg_multicast() call in xfrm_send_migrate_state(), similar to what
is done in other direct netlink handlers like xfrm_notify_userpolicy().

Fixes: a9d155ea9b44 ("xfrm: add XFRM_MSG_MIGRATE_STATE for single SA
migration")

Fixes: a9d155ea9b44 ("xfrm: add XFRM_MSG_MIGRATE_STATE for single SA migration")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+b9e97485773456b16a4a@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b9e97485773456b16a4a
Link: https://syzkaller.appspot.com/ai_job?id=d3018c43-91ed-4b51-be71-8469c523a748
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
