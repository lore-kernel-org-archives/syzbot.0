Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BAE33C8737
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 13:35:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786109761; cv=none; b=TS0493ulKah8l9cgzfB64hiGfNmAeCpzYTWbDSZERSQ5LuSzdtDOyTHA2x5nfFbDwYSWhvJFauEyg3rxb1p0jlQSdZIq84El1E2jQAApPN3e6/sayn3kCjgcuOimElm0QQ//Qnt4JAgLrj9dGrr9kShQ0pcgwNVaxbw2yyfFWEM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786109761; c=relaxed/simple;
	bh=4WVATYChXqpF3oHh++UijOqQCylSh72fbIFdqopUCuA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Knr7tFaH4aEkU4Td5MfGATTmpDbt3DFxZpRDfROLrPR54LsqTdT3bFOC2DH50C8Z8b6edYMoSiw1qQgO3HjaHxl9sohu/Dsh/PSc8NBvhY/xpOp5bATf6TLxYLhWOn3VdMgu4k6x8UHB3iHA0oUyMTVTVQ7To9QRHK8ZdZW19/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Vm2VVo3Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Vm2VVo3Y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 828F31F000E9;
	Fri,  7 Aug 2026 13:35:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786109756;
	bh=1i69QygDSKmidk6uJj8Utv2QUcJ20hjMNQEuXGP6PXs=;
	h=From:To:Cc:Subject:Date;
	b=Vm2VVo3Yeo63U8YynCnyvZwM7H1GUiY2QxK3rOHHRhWZMhiwmZuEDAW0Sx2Wti595
	 M6/vu5aUs/tme61vMxWhF2AoF2gJrmR3SeAbPc6gbOSpdSDE/JBysfshzo9aZg1saH
	 IxKCcp8wHnZiv7OpIzJa4fRmvCCA95U+X/aQgzErOSodJFysqpyQWs/ECtELXo3jf1
	 9ZspFNBoi/rOjcvSLP3RfKZe/e9mRs4xAXIL5zO8VK6S7fz4z7ZlB3yhDDAlLsu8o2
	 Jio8T8+aqE4C2s+LCM266Bg+SImhu/vhtQ77tTXLnM29hC/vjR4MIXVuguJzVIHUkc
	 /sddMmHDJ0OfA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] nfsd: prevent hung task in nfsd_nl_listener_set_doit()
Message-ID: <851cf46d-c7e4-470a-8319-36811d8b1da3@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 13:35:56 +0000 (UTC)

In nfsd_nl_listener_set_doit(), the kernel iterates over all
NFSD_A_SERVER_SOCK_ADDR attributes provided in a netlink message to
configure NFS server listeners. There is currently no limit on the number
of attributes a user can send.

For each attribute, svc_xprt_create_from_sa() is called, which may
synchronously invoke request_module() to load the corresponding transport
module. If a user provides a large number of invalid transport names,
request_module() is called sequentially for each, taking a massive amount
of time. Since this entire process occurs while holding the global
nfsd_mutex, it blocks other tasks attempting to acquire the mutex and
triggers a hung task timeout:

  INFO: task blocked for more than 10 seconds.
  ...
  Call Trace:
   <TASK>
   __schedule+0x17e7/0x5630 kernel/sched/core.c:7234
   schedule+0x164/0x2b0 kernel/sched/core.c:7326
   schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7383
   __mutex_lock_common kernel/locking/mutex.c:726 [inline]
   __mutex_lock+0x7bf/0x1550 kernel/locking/mutex.c:821
   nfsd_nl_version_get_doit+0x17c/0xd20 fs/nfsd/nfsctl.c:1889
   genl_family_rcv_msg_doit+0x233/0x340 net/netlink/genetlink.c:1114
   genl_family_rcv_msg net/netlink/genetlink.c:1194 [inline]
   genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
  ...
  2 locks held by task/5864:
   #0: ffffffff90114168 (cb_lock){++++}-{4:4}, at: genl_rcv+0x19/0x40
   net/netlink/genetlink.c:1217
   #1: ffffffff8eeb1a60 (nfsd_mutex){+.+.}-{4:4}, at:
   nfsd_nl_listener_set_doit+0x135/0x1750 fs/nfsd/nfsctl.c:1964

Furthermore, the function does not break out of the loop if
svc_xprt_create_from_sa() fails, and it suffers from an O(N^2) complexity
issue because svc_find_listener() iterates over the serv->sv_permsocks list
for each attribute.

Address this by introducing a hard limit of 128 NFSD_A_SERVER_SOCK_ADDR
attributes per netlink message. The limit is enforced before acquiring the
nfsd_mutex to prevent lock contention. Additionally, modify the loop to
break immediately if listener creation fails, avoiding needless sequential
request_module() calls for invalid configurations.

Fixes: 16a471177496 ("NFSD: add listener-{set,get} netlink command")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+41bc60511c2884783c27@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=41bc60511c2884783c27
Link: https://syzkaller.appspot.com/ai_job?id=e7446d8c-5a41-495a-8af7-9f0d7feddff1
To: "Chuck Lever" <cel@kernel.org>
To: "Jeff Layton" <jlayton@kernel.org>
To: <linux-nfs@vger.kernel.org>
To: "Lorenzo Bianconi" <lorenzo@kernel.org>
Cc: "Dai Ngo" <Dai.Ngo@oracle.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "NeilBrown" <neil@brown.name>
Cc: "Olga Kornievskaia" <okorniev@redhat.com>
Cc: "Tom Talpey" <tom@talpey.com>

---
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index fa92e31d1..9c1cc02fc 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1960,6 +1960,13 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 	struct nfsd_net *nn;
 	bool delete = false;
 	int err, rem;
+	int count = 0;
+
+	nlmsg_for_each_attr_type(attr, NFSD_A_SERVER_SOCK_ADDR, info->nlhdr,
+				 GENL_HDRLEN, rem) {
+		if (++count > 128)
+			return -EINVAL;
+	}
 
 	mutex_lock(&nfsd_mutex);
 
@@ -2073,8 +2080,10 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 		ret = svc_xprt_create_from_sa(serv, xcl_name, net, sa, 0,
 					      current_cred());
 		/* always save the latest error */
-		if (ret < 0)
+		if (ret < 0) {
 			err = ret;
+			break;
+		}
 	}
 
 	if (!serv->sv_nrthreads && list_empty(&nn->nfsd_serv->sv_permsocks))


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
