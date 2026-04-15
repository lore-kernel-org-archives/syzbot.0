Received: from mail-wm1-f73.google.com (mail-wm1-f73.google.com [209.85.128.73])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15FD238BF70
	for <syzbot@lists.linux.dev>; Wed, 15 Apr 2026 13:05:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.73
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776258339; cv=none; b=Qvg3Qc41ArsRB1wdboNDdOBg7f0BVeRHDfcA3Ngcy2PbQwRm07AlJQ9nAODB217hrhlOKOAbuXgRJ99vfcpngEDA6DwCXrBqkMFLamoxYlOgjKuSek+wXQc6QKDAnEtEcKsL6xi43lUa4taWa2vUuKmJvhZwqqmlBU+nfENnl9E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776258339; c=relaxed/simple;
	bh=2Hs9DNOzuNNqlTQoBag0X062U/H9SGvW0rnDyXV4rTQ=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=o9Mxz8joZiG1ryy4/FrfpcfXmTccHk0OnW0FkbEfmvP+svVgdQVB0YKIgdH6cbBRDNOI6Dk88H4KoRHO306NMemPO35B7jN++/JeRnf+wiksJ4v5318OiTfmMK1ABEMFoObqOmT7CDXOTJVNqK/iBjrAlt9qX8baHD9np50JiOE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=n3DVLmKT; arc=none smtp.client-ip=209.85.128.73
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="n3DVLmKT"
Received: by mail-wm1-f73.google.com with SMTP id 5b1f17b1804b1-488ba2919b9so46230875e9.1
        for <syzbot@lists.linux.dev>; Wed, 15 Apr 2026 06:05:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776258336; x=1776863136; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=hdle0JKZzTwFQP890ZPhVWQx6m7HCYXGW3VKR/X9KOM=;
        b=n3DVLmKT/G/V4kClLissOPRkMPe7WtiXnO7PiYU4afy5G1dWwj28PegFc0mkxWzZcI
         eCZ06MPFlYpmpbOn27m/q6gfRaN34IjW0PCeqSDZjugrDhd/ggTGFBoBfYX3A0PLeH5e
         YQI8oSDp018AQlcBICv/kCyWR/uRfl+g2kb1ub5q63RJi+Zl0rojY9qy0g5lmp8USce8
         m6BONRZ37SPMIvva3wt+gZUqCVxdtL32atD/WsgI+sv9c19Y1XbImPm/jxh0EcqZLyfZ
         7+SDxglgAOVuIKBTri/3vDqR171n6v88fjexDnWrytNu9MX2v8njz0D3jb1my+it4FEp
         x5zQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776258336; x=1776863136;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=hdle0JKZzTwFQP890ZPhVWQx6m7HCYXGW3VKR/X9KOM=;
        b=sgHN2OdHoGvEXCqaIK7Cywqe9NQbnyFmWa9oi5Wcg73hEwZa34UrWTTDQlu7DZnFRG
         fqQ2JNEtv+x+t6ntSEiO0mIeUvjJKzpWtc95jBWCE0z2KbOAj6otIWkV20TxQEsgI9TQ
         Ygl0oXkLaS2xn9/rFYB/7oC7IQBwa6lbQMqzEJOcsAGd223aRgSilu27Mndh3fAYQzrE
         3rLH4NB7daxcrcKlP2LiVUN/xswHMI3WRBOIDMnSaS27nvGCyNgBk0LLB9ENZdFFbkx9
         mThZi2hqz9fCS03WNX6zS4DYSermFDI4ib0jWflH5rlsivT+jyM6Vu/V8xErVVNWzSSs
         e3Aw==
X-Forwarded-Encrypted: i=1; AFNElJ/iiiv1ofFMJf1QfKVmbOO521J6SAiy1hokrKpkxlyI/3YzpOdU7h3MxC/00D9BS4v7kl+9m5g=@lists.linux.dev
X-Gm-Message-State: AOJu0Yx7981+Z+UiE8lHPiufaiL4xw6taI63R0rT0q82EiA9CjpZcyKa
	dWiThoHBbkE2zyGSNHLkKrpyffOBVitp6zOG5h+YWfIrAgwxi/En+OYLtirAKz9/srJdyPvxpmP
	mamA6HQ==
X-Received: from wmbjp7.prod.google.com ([2002:a05:600c:5587:b0:483:509d:729b])
 (user=nogikh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:a408:b0:488:9324:3ab8
 with SMTP id 5b1f17b1804b1-488d6839838mr233186635e9.18.1776258336271; Wed, 15
 Apr 2026 06:05:36 -0700 (PDT)
Date: Wed, 15 Apr 2026 15:05:33 +0200
In-Reply-To: <69dd48c2.a00a0220.468cb.004e.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <69dd48c2.a00a0220.468cb.004e.GAE@google.com>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
Message-ID: <20260415130533.849053-1-nogikh@google.com>
Subject: Re: [syzbot ci] Re: veth: add Byte Queue Limits (BQL) support
From: Aleksandr Nogikh <nogikh@google.com>
To: syzbot+cib904ea9ebb647254@syzkaller.appspotmail.com, hawk@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

... okay, one more fixed bug, one more try.


#syz test

---
  drivers/net/veth.c | 4 +++-
  1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/veth.c b/drivers/net/veth.c
index 911e7e36e166..9d7b085c9548 100644
--- a/drivers/net/veth.c
+++ b/drivers/net/veth.c
@@ -1138,7 +1138,9 @@ static void veth_napi_del_range(struct net_device
*dev, int start, int end)
         */
        peer = rtnl_dereference(priv->peer);
        if (peer) {
-               for (i = start; i < end; i++)
+               int peer_end = min(end, (int)peer->real_num_tx_queues);
+
+               for (i = start; i < peer_end; i++)
                        netdev_tx_reset_queue(netdev_get_tx_queue(peer, i));
        }

