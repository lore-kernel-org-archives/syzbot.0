Received: from mail-wm1-f74.google.com (mail-wm1-f74.google.com [209.85.128.74])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620593B19AF
	for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 08:33:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.74
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776155603; cv=none; b=hOvRLn9lvqnbnqYTGt1Xcv4PQpWxVQIm7zqpHOO+mhszyj2PG6jsAjetIanN/ZSDOXh3Ox+DLwWEXYSoURvVcezRV32gKScwBUmeyUv7MLvaavZGEUCKq55wLYzwWYVLLJ+PxtRL9kQlrajmZbz8B2eAOyiH/X0YJT8cS6SqYVg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776155603; c=relaxed/simple;
	bh=ZhWN6SxhuWfyxgKUhrRsIRlcqgS38A0PyUD34h0n8W8=;
	h=Date:In-Reply-To:Mime-Version:References:Message-ID:Subject:From:
	 To:Cc:Content-Type; b=QM07nHB9uu0GuLPH22OKe19j651U1XejGc0h1v+DS9rsUJzPxw/q1/F+BL7/UvcUlY4iRmVcAceoQKwVSKDHeoURqRlMQ60bYIGx0wquXzRiIpTSyxfI1TT+LEI1zinwWkku5+DpVWoVn7VW1xUwzI3CKDjeTDaZUZI2mF/yOYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MO/jpoF8; arc=none smtp.client-ip=209.85.128.74
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=flex--nogikh.bounces.google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MO/jpoF8"
Received: by mail-wm1-f74.google.com with SMTP id 5b1f17b1804b1-488d2cd2674so38012505e9.0
        for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 01:33:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776155599; x=1776760399; darn=lists.linux.dev;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:from:to:cc:subject:date:message-id:reply-to;
        bh=9yv6nANFBDeTvP7QOj+b+BGfj5pgYEttgQLR0Ky5nKk=;
        b=MO/jpoF8Zv+JNULKPIKXz6wRBcxmwaykMMPLku4inPRhtxTqzogzKkrdwq9KkcNpNN
         T68DDAcc56pd7lRvMXWuRHAc3i5fxqKvvRqfNTKxbYaAE+/xxrAwu3AEuTgYW4OhBc2n
         mhpTL3d/Qr7212v5N+8B2xRo01XuU4u5nXVrpU3G/IWkSVPs98u2nhsnTteIqQaxEspp
         pUL/h5uTjVwSAjsRV4rw5c4nf3QZQeN1fazt906rONseIcUQULbufmiixsNw8bqzGo2b
         +7dj886ep+xdvY5I5fWwxYVB42prHxIxFkx8kNHzuguAF0q0L/K30tXQeq/lW5zr4JIV
         t30g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776155599; x=1776760399;
        h=cc:to:from:subject:message-id:references:mime-version:in-reply-to
         :date:x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=9yv6nANFBDeTvP7QOj+b+BGfj5pgYEttgQLR0Ky5nKk=;
        b=GO3AU1qbjdPxFdOSVDF4zCyFR7Nbn2CXXsnKdN9YPyje3ZI6gow2cX+Wi7rIntga//
         D9fba2C2MCNCsQU8RTnhUKLVYSJ11papWcsUv5vC7BpWWFS8WX9Zt2XCKrAvl3I8/P+M
         xSFu8VUHu1Yc3B/C3dOrdvS5rIpIMhzAZl2wC6hX0Rj4PTGNMKF8t7NcLdgfxH+QW1+x
         TOD9cHN+NvDZA1sI77SUc+6mlKJ2Xy/R70QKfkhBe/9QMkebHjdEkOhLTmr8WenWBCHD
         j/+p5wpZEbU9Aij3C2zyF7jbE6KMtMTH2FUJhJkmALXnm83b+ZJcp6iKbck4rplcPM9N
         VudQ==
X-Forwarded-Encrypted: i=1; AFNElJ8rgfNROGG31fdRGtUW1aNquLF/berFpuw/bKQxUpbCfuTav26H6sn634yhhyz8WHsCwORmdDQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YzYFaGnQgxiYqrm0AVIz04tnJOKEQlRmH50wpFKkoYgyMbZhPgd
	ywijLiQiNuwK9W7/J34gdrCs3SFHJTjp8mSlfRZXbUepmC51jJyzmbHX2UTodA+l7qWpJdCzloz
	k0AqN6w==
X-Received: from wmgg21.prod.google.com ([2002:a05:600d:15:b0:488:7af2:fae7])
 (user=nogikh job=prod-delivery.src-stubby-dispatcher) by 2002:a05:600c:3149:b0:488:ab26:8fe0
 with SMTP id 5b1f17b1804b1-488d68432f2mr230761425e9.15.1776155598632; Tue, 14
 Apr 2026 01:33:18 -0700 (PDT)
Date: Tue, 14 Apr 2026 10:33:16 +0200
In-Reply-To: <69dd48c2.a00a0220.468cb.004e.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
References: <69dd48c2.a00a0220.468cb.004e.GAE@google.com>
X-Mailer: git-send-email 2.54.0.rc0.605.g598a273b03-goog
Message-ID: <20260414083316.19864-1-nogikh@google.com>
Subject: Re: [syzbot ci] Re: veth: add Byte Queue Limits (BQL) support
From: Aleksandr Nogikh <nogikh@google.com>
To: syzbot+cib904ea9ebb647254@syzkaller.appspotmail.com, hawk@kernel.org
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzkaller-bugs@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

(forgotten to Cc the right list)

Hmm, just fixed a problem that may have affected `syz test` processing,
let's try again:


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

