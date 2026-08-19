Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6D7C367B8B
	for <syzbot@lists.linux.dev>; Wed, 19 Aug 2026 08:30:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787128237; cv=none; b=R/UkHa8G4TaqOqBSXTYrCtEPgMp2l/M5snB6dwM91Yac3v6ypXoZen7ru2x1ibYFYIXjfcC+yuywX/2wrKfVbP9QbmD1EjVB84iWcFIYdI6mhMNKRiWVejJT6rvgyx1pnimRYSK7U2hiz7JWIf29o66hUh//AZd0t8hdRiX53Qw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787128237; c=relaxed/simple;
	bh=ECOLIaVhGG6m4edP7ZpkGnDuJe3ytAk4TAYzKNouFmc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=qvKchVRrq5UIW/mAQZxzMG61xtYoKnTmrdLW+1UF2mzXAK37OdjjHaDIEAB3qHW8Thhp3L1Ai+afhNfzeXzkWboyclJXtdRnh/Iq1Hwnqkjwfa8+pt1GYi/f8m150paSUrSQNt69gdyh4wGhlI31zsOzj8QwvbvoHjc6BNGG+24=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=P44r07M5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="P44r07M5"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 612A81F00A3A;
	Wed, 19 Aug 2026 08:30:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787128235;
	bh=aFsJuc8oHNkPqUGs6Ab+rLzNDcb8A1GPLDDonk8ALr0=;
	h=From:To:Cc:Subject:Date;
	b=P44r07M5aQXQSWia33blEAS6WGFRbHtdy/+Yt9kGhoW4a0CNH7tEZ2gSiE2u7Dm0d
	 DtWUNjCW3WTN+4MUMGwPTopwOnypmUNPffeYQPYZkc/mEM3SazCq5+xl0w2x/nmLWx
	 SkGadTM72Z/QYWCx9v2QQm6LWK5wOghGhpiGwKcQ8vfGCrDlX6s5hvFcp4YFLgnaa3
	 f9NGZIyJiNMb/nzorwpOOSikk/OacTGEoeXl7NPGUghXXod48Te0s/EUuOF74+GJ5g
	 IELnhwR6ydEhhLQqfAFnBytsGAxuWOB6TPdQafv9rmNHBrZTvnSFCyz/hDjHXtq4C4
	 1jvG3oFm/15lQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] nfsd: prevent hung task in nfsd_nl_listener_set_doit()
Message-ID: <4c63b53f-3063-484b-b5e6-6b024c2322af@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 19 Aug 2026 08:30:35 +0000 (UTC)

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
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+41bc60511c2884783c27@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=41bc60511c2884783c27
Link: https://syzkaller.appspot.com/ai_job?id=30871f87-7a83-46b8-ab83-919894b0787b
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
v2:
- Defined NFSD_MAX_LISTENERS macro instead of using a hardcoded constant.
- Changed type of count variable to unsigned int.

v1:
https://lore.kernel.org/all/851cf46d-c7e4-470a-8319-36811d8b1da3@mail.kernel.org/T/
---
diff --git a/fs/nfsd/nfsctl.c b/fs/nfsd/nfsctl.c
index fa92e31d1..516c04c14 100644
--- a/fs/nfsd/nfsctl.c
+++ b/fs/nfsd/nfsctl.c
@@ -1943,6 +1943,8 @@ int nfsd_nl_version_get_doit(struct sk_buff *skb, struct genl_info *info)
 	return err;
 }
 
+#define NFSD_MAX_LISTENERS 128
+
 /**
  * nfsd_nl_listener_set_doit - set the nfs running sockets
  * @skb: reply buffer
@@ -1955,12 +1957,19 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
 	struct net *net = genl_info_net(info);
 	struct svc_xprt *xprt, *tmp;
 	const struct nlattr *attr;
+	unsigned int count = 0;
 	struct svc_serv *serv;
 	LIST_HEAD(permsocks);
 	struct nfsd_net *nn;
 	bool delete = false;
 	int err, rem;
 
+	nlmsg_for_each_attr_type(attr, NFSD_A_SERVER_SOCK_ADDR, info->nlhdr,
+				 GENL_HDRLEN, rem) {
+		if (++count > NFSD_MAX_LISTENERS)
+			return -EINVAL;
+	}
+
 	mutex_lock(&nfsd_mutex);
 
 	err = nfsd_create_serv(net);
@@ -2073,8 +2082,10 @@ int nfsd_nl_listener_set_doit(struct sk_buff *skb, struct genl_info *info)
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
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
