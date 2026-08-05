Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE75E33343C
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 17:07:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785949640; cv=none; b=l0rlIhD9qjYtOTYd0HgcgqrI4hTFI9MZYdHm7ApelE6izUwnDdI/TgGmIGdniv3JCECu8LWSFP9siuNeCNQBNiyLVbokRTcxYblvFM3EqwUXyDU7K6ho/Q9XSM1rzCwnL4V7DZsnit/EUzNvARGgfxu1FOZu/wN5exrFYw1TJvY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785949640; c=relaxed/simple;
	bh=4w7V/VkLfP0xW3XmrE+5xRu2StLiEyFHM4QIGcB5MLE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=H8wIb8GVCPVnBL+xNLm0rjmm7HH681j7gw93GQniLB8I3XcAvXSj2ecsCMuNIGzEpUESfRkM7mRzAeDWs5IAThRqGks0WIP9KI0EDpKnr2tlhKg9t0tRxBq44xdzS0LQDqkJoNYbAFlqOgbxQzpjmkNj7uQyNWttXo9izDZ8wWs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B0MOLB2c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B0MOLB2c"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 626101F000E9;
	Wed,  5 Aug 2026 17:07:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785949638;
	bh=Qrqntb6+cbC7yq2I5Z3SMGAW6SaDoxfILeTo+exDa9s=;
	h=From:To:Cc:Subject:Date;
	b=B0MOLB2cZZr4teWIiIn3ZXD+yDeMyVwkZY4YcUjZGLndQhllCYO7x4vh5s1AD/QUB
	 lQV4zdmR24ARCxNj2bOPXKRsSs6sGf+IAZTvEYylmuoA6R3jPxxay5Pljd29uEuOGL
	 BCMSSB3rtxZgQl/GS1PSWN6hGoXPTj+g2kVsJKHD82UUHjSt3YSgvsiz3eYsrj3TvU
	 ZGZPdlghr8W6LJqGSuKV9POJXXUUGL1XKrnOl3huvyvwvd3WE7ZXCMQ/HfAT7c3jmn
	 +pNki/5O28bTQPwjcs2QOzFHoVeWlxnPE1gr+auqEI7Z+/RHBvKnOlgNDeD1RLDGKY
	 VZEEHbDKcRmJQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] netfilter: ctnetlink: fix deadlock when loading modules
Message-ID: <e264626b-1651-4606-9771-27c1bd7bec89@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  5 Aug 2026 17:07:18 +0000 (UTC)

The hung task detector reports a deadlock caused by holding the
nfnl_lock(NFNL_SUBSYS_CTNETLINK) mutex while synchronously waiting for a
user-mode helper (request_module) to finish.

INFO: task blocked for more than 5 seconds.
Call Trace:
 <TASK>
 context_switch
 __schedule+0x17e7/0x5630
 __schedule_loop
 schedule+0x164/0x2b0
 schedule_preempt_disabled+0x13/0x30
 __mutex_lock_common
 __mutex_lock+0x7bf/0x1550
 nfnl_lock
 nfnetlink_rcv_msg+0xa69/0x12b0
 netlink_rcv_skb+0x226/0x4a0
 nfnetlink_rcv+0x2b9/0x28c0
 netlink_unicast_kernel
 netlink_unicast+0x7bb/0x940
 netlink_sendmsg+0x813/0xb40
 sock_sendmsg_nosec+0x13a/0x180
 __sock_sendmsg
 __sys_sendto+0x408/0x5a0
 __do_sys_sendto
 __se_sys_sendto
 __x64_sys_sendto+0xde/0x100
 do_syscall_x64
 do_syscall_64+0x174/0x580
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

The deadlock occurs when a user-space process sends a netlink message to
create a new conntrack entry and attach a helper to it. nfnetlink_rcv_msg()
acquires the subsystem mutex nfnl_lock(NFNL_SUBSYS_CTNETLINK).
ctnetlink_create_conntrack() then attempts to load the helper module by
calling request_module(). request_module() spawns a user-mode helper
process and synchronously waits for it to finish. If the user-mode helper
process tries to send a netlink message that requires the same
NFNL_SUBSYS_CTNETLINK mutex, it will block indefinitely.

To fix this deadlock, the subsystem mutex nfnl_lock(NFNL_SUBSYS_CTNETLINK)
must be released before calling request_module() and re-acquired
afterwards. If the module is successfully loaded, the function returns
-EAGAIN, causing nfnetlink_rcv_msg() to safely replay the message from the
beginning.

However, dropping the subsystem lock without holding a module reference
introduces a use-after-free vulnerability. A concurrent thread could
acquire the lock, unregister the subsystem, and unload the module while the
lock is dropped. When request_module() finishes, it would return execution
to memory that has already been freed.

To safely drop the subsystem lock, we must pin the module in memory using
try_module_get(THIS_MODULE) before dropping the lock, and release it with
module_put(THIS_MODULE) after re-acquiring the lock.

This patch applies this fix to ctnetlink_create_conntrack() and also fixes
the same vulnerability in ctnetlink_parse_nat_setup() where the lock was
previously dropped without holding a module reference.

Fixes: 226c0c0ef2ab ("netfilter: ctnetlink: helper modules load-on-demand support")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+c4b20b80ee6a7a2f5012@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c4b20b80ee6a7a2f5012
Link: https://syzkaller.appspot.com/ai_job?id=0258c070-bcf1-409f-9ddb-fa3807ea115d
To: <coreteam@netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
To: "Eric Dumazet" <edumazet@google.com>
To: "Florian Westphal" <fw@strlen.de>
To: "Jakub Kicinski" <kuba@kernel.org>
To: <netdev@vger.kernel.org>
To: <netfilter-devel@vger.kernel.org>
To: "Paolo Abeni" <pabeni@redhat.com>
To: "Pablo Neira Ayuso" <pablo@netfilter.org>
Cc: "Simon Horman" <horms@kernel.org>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Phil Sutter" <phil@nwl.cc>

---
diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 31cbb1b55..43f8e64a2 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1859,13 +1859,17 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 	if (!nat_hook) {
 #ifdef CONFIG_MODULES
 		rcu_read_unlock();
+		if (!try_module_get(THIS_MODULE))
+			return -EOPNOTSUPP;
 		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
 		if (request_module("nf-nat") < 0) {
 			nfnl_lock(NFNL_SUBSYS_CTNETLINK);
+			module_put(THIS_MODULE);
 			rcu_read_lock();
 			return -EOPNOTSUPP;
 		}
 		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
+		module_put(THIS_MODULE);
 		rcu_read_lock();
 		nat_hook = rcu_dereference(nf_nat_hook);
 		if (nat_hook)
@@ -1878,13 +1882,17 @@ ctnetlink_parse_nat_setup(struct nf_conn *ct,
 	if (err == -EAGAIN) {
 #ifdef CONFIG_MODULES
 		rcu_read_unlock();
+		if (!try_module_get(THIS_MODULE))
+			return -EOPNOTSUPP;
 		nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
 		if (request_module("nf-nat-%u", nf_ct_l3num(ct)) < 0) {
 			nfnl_lock(NFNL_SUBSYS_CTNETLINK);
+			module_put(THIS_MODULE);
 			rcu_read_lock();
 			return -EOPNOTSUPP;
 		}
 		nfnl_lock(NFNL_SUBSYS_CTNETLINK);
+		module_put(THIS_MODULE);
 		rcu_read_lock();
 #else
 		err = -EOPNOTSUPP;
@@ -2253,10 +2261,19 @@ ctnetlink_create_conntrack(struct net *net,
 		if (helper == NULL) {
 			rcu_read_unlock();
 #ifdef CONFIG_MODULES
+			if (!try_module_get(THIS_MODULE)) {
+				err = -EOPNOTSUPP;
+				goto err1;
+			}
+			nfnl_unlock(NFNL_SUBSYS_CTNETLINK);
 			if (request_module("nfct-helper-%s", helpname) < 0) {
+				nfnl_lock(NFNL_SUBSYS_CTNETLINK);
+				module_put(THIS_MODULE);
 				err = -EOPNOTSUPP;
 				goto err1;
 			}
+			nfnl_lock(NFNL_SUBSYS_CTNETLINK);
+			module_put(THIS_MODULE);
 
 			rcu_read_lock();
 			helper = __nf_conntrack_helper_find(helpname,


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
