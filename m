Received: from mail-ot1-f71.google.com (mail-ot1-f71.google.com [209.85.210.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1EFAE39281F
	for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 08:17:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776154672; cv=none; b=J48LtxR1V/j4CVdlehOt3y1Yd6tp95V8LaIQ+L7TDjzKOzLRr1KMzlU/d9fKZKbMZ4VY+vI2/h1lVjT0kndhsMb74vM38gyDueQsLsj+LRwc8YEcliZoU8WR9yh0Syg+wxgOZ3MReHbP9ETZOHcv4hSEoEdNC8jcg2V0qUwvBHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776154672; c=relaxed/simple;
	bh=Fw+1wPOPV2ITfvOLj7hGAekW4EetWYP+mF6tA3N0TDw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=ApUQGGeP2yegl4ykCF7Ak3gqjprQwSmsOSd1LNcP0k9Zvz5RmSeoLn0l2Ysg9KrjyJmwmXXIrRNTP2qEK1RO8HPvDy64OX/ZZuXHKVsh5ZD0qSFAHShyZpJcW2E6RUxEQcsU+6ZI+JvigFVW8GW5aElD7Yj22NWI7L1ivUEj+fQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f71.google.com with SMTP id 46e09a7af769-7d7f7164b12so7864038a34.1
        for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 01:17:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776154670; x=1776759470;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1PMByDDAznehAx4DTq4epwxKUynhUt4hAecE70ebkhA=;
        b=j5Eiw5QGNH4BLIrQxxySRWtymSJEgKxqf9CUU2Nn/HGW/TXqqtABPI62fNwZzh1/ko
         nFYa1kpal3ioLWHeAlH/vJP6CWD2wV5rdiU5Gv+7ztHjSfFqudIpehoCwdHeXoJqAHfv
         bUvy2ACWlQfUAWZMvUy3tDTIKWhKcHmGBTInopAOScygr0N9EZYjNseLCgBftRAIovOu
         ecw4AG9eqBQsY9BWLmYUrxjj4aFRbWed4pDeKngTjH4jPA+z3YU83U/iCDUVM1bJnnkp
         xDySp0XAVu8jKvg90oipBKxYhr2TeF+MnHEAjBT4eNyY+Upm2eSKmCr4yf9NRk2fZckg
         oi7Q==
X-Gm-Message-State: AOJu0YxOxmpSY6es5xBfyh3QcwiXvJXskdZ6Zu1AmCMahmrVk1tMhcrN
	vb/c05TJ+KnpVq/08CfuE9z4bjVI47xyUh7b2yw0ffhML5grnIDH7/AnOh2At/+3JEJCjGzF7zA
	0HFwcyHRE6fc7nJuOFFNiSNo6Y2xVkQRQTe6TeG9+2Dzm6cG+f9wHxaLhlQk=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1ca7:b0:67d:e85d:b5dc with SMTP id
 006d021491bc7-69212787b70mr240329eaf.56.1776154670154; Tue, 14 Apr 2026
 01:17:50 -0700 (PDT)
Date: Tue, 14 Apr 2026 01:17:50 -0700
In-Reply-To: <20260414081746.17392-1-nogikh@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ddf82e.a00a0220.475f0.0038.GAE@google.com>
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

