Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A818C7262F
	for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 08:17:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776154676; cv=none; b=qCbgyTMxDNY5W9djnpRY4BGFjN+jy4HUDTm0yhUS36ypQ3DlIfCoMEVx4yJfzjkNX0CfKEnjmyGR6468yWT+epc6dLZNKinQa4ppo1VqB5rtqI84K4HLN8354D6kcqq5RczrHKz34Fh5mToOjgxHJEim3gNs3wIV9szlHMcXcZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776154676; c=relaxed/simple;
	bh=K8CklOZxxPysfeZiAq7QnvAzatKgIZV39AD9RAAJWPE=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=XWSIriD+jhpjigklsBMIrJgm2FURGiKGPvyAqXZlkQWvSZrMHjquN6+Iah6vkF7dcR7OHXbDmZxlZpaEgC8moXTiMfu0o4/puJa5EPvcqcKvVM+fbb/l1MB1pI+P+9HjBTXj3WHz8ORfh/PrPqhDOf4TthadtAVmUzexeYNatlY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-68e396825a6so4289534eaf.2
        for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 01:17:54 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776154673; x=1776759473;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=UIfKdQvB9xtZekzL9O+6yjLSsq4hBfD/lpEiCZCZTs8=;
        b=MQrCTAZ9VIUmrRDFdhFLj73kdvi8AD0JW6bsxwLR4jUZqXfnjmWu5791dex9dpvta3
         bRUNraol0q1cpA0B8xTAYg3MLvupX8kUK1hSrbA963/bKKr0CmvCczhA80O4fFK8j8z6
         cgrLE46DJKvOeVFvaUTT8dCcLDPbofjO3aMChoFbM4wCa0YvuY4Gp/8vQEEVa7rR0o6u
         B+qq+Dly149YyAblR1WN3uG6UitMrMa/8SXw1B8x6ITn2xq3V8oCSyC7nrFJf5njM77Z
         vjNkkHIEHPu2j735M2eagiJy49M7XY0BUCCOP7c0sLAPwKqwZdgjHJx1KeHXkghirF6z
         Z1vA==
X-Gm-Message-State: AOJu0YyVoJOKO9bMLLiMkvyTcCrtKXpEXYX3TnaNd12aNfF9CvkYR0Ke
	4s6XbZ3iW7CiCZZocwbPINjKqJvRIHLuR91almA6aH/+g8EyEJ8upzEjXibdSQIEEsxCzmZzKVD
	ebSgYDYye027MHbhzbfhA6bfrrAnD/TNOcnpQTcCKP5mNH2VcMgdoFT+Wj7Q=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b91:b0:68a:f494:e8fc with SMTP id
 006d021491bc7-68be7ae79c2mr7762284eaf.33.1776154673648; Tue, 14 Apr 2026
 01:17:53 -0700 (PDT)
Date: Tue, 14 Apr 2026 01:17:53 -0700
In-Reply-To: <20260414081746.17392-1-nogikh@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ddf831.050a0220.3030df.004e.GAE@google.com>
Subject: Forwarded: Re: [syzbot ci] Re: veth: add Byte Queue Limits (BQL) support
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@lists.linux.dev
Cc: syzbot <syzbot+cib904ea9ebb647254@syzkaller.appspotmail.com>, nogikh@google.com
Content-Type: text/plain; charset="UTF-8"

For archival purposes, forwarding an incoming command email to
syzbot@lists.linux.dev.

***

Subject: Re: [syzbot ci] Re: veth: add Byte Queue Limits (BQL) support
Author: nogikh@google.com


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

-- 
You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
To view this discussion visit https://groups.google.com/d/msgid/syzkaller-bugs/20260414081746.17392-1-nogikh%40google.com.
