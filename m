Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C87B33A257E
	for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 08:23:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776155014; cv=none; b=p5+G02o5f+Sxu6ITwPro13W4O4XRl/bXAvA5ANlEMJPfRbjTUzd6xGSrm8TmYI/eIrli/3tWjAwD96rSKh62ZzzcWnKnbc9Po+jkOi1GnrJamfXqQjRhDhT7xdvAO1B91pUtfZxZFnvrU7hKy1RwyoHiK5xjRT3G3nIDurOKaTQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776155014; c=relaxed/simple;
	bh=Fw+1wPOPV2ITfvOLj7hGAekW4EetWYP+mF6tA3N0TDw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=P9Yz4iGHrlAw5dWCRH6Dm21ntlrp/61FRdUaxgYXVBcOFwnEGt4QisvxD3bJpoT5LI2XosWWhW/JyZXLx6G9XFqD42buoLiG4O/1SLZLKWDRnlqRkcg/+Jjp9CIv2/hHuvbeKGSegRuh9i/3nzbQN1YUoXiGafGEGFtLTLZGamc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7dc3cb93f2eso7068857a34.3
        for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 01:23:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776155012; x=1776759812;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1PMByDDAznehAx4DTq4epwxKUynhUt4hAecE70ebkhA=;
        b=KP8aqgrS5XLwVHqb3tb2xNFMVl4DXcDd3SC9WcuotRgmn0DrQ3f610/9MgwyQQAiBi
         ADifhMQOFK0K2s50UH/Jlm2QW9eBLb2STBCEJ6MpVZIBIVlRaHCTrxYeDV3le5Hj13rO
         KJmLgznKQNiqo3/bNLSoAk8LfBgb0TkeqOwPXY0Am4x+5kztDTJ/nh1a7j//JJRwOVNN
         1yUOZbdZrm+6YSLJSCWUSvsu8TtyG6PvZB+yg9WdolwdZc1rC22I+PFf17xzSEYg8OQ7
         rhV7vklT76rNSZVPAt5OUoOGBkg0R4N0ZpBbEhE5j19N5d+Vg6XgtEYetyoL/r944p+x
         0jfg==
X-Gm-Message-State: AOJu0YxpkhbbJ/65uo4zUVvd4TazQnc/T1a4hEfdMsDsc0T2UQFHt5Bv
	wpFDBRvFGEu994nVwYqblk4G9jhByh0MWEJkn1eJEp6q4nqUXz/ZM5CYQiVl4NZTrf0tJoinTvG
	TeILPChlmk6Jo+jMNA7kfTX81xrPvYt6A18h4S0WEHS/7Zao1IqkYBKcNfQQ=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1f05:b0:685:b738:18bc with SMTP id
 006d021491bc7-68be6912978mr7969313eaf.26.1776155011871; Tue, 14 Apr 2026
 01:23:31 -0700 (PDT)
Date: Tue, 14 Apr 2026 01:23:31 -0700
In-Reply-To: <20260414081746.17392-1-nogikh@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ddf983.a00a0220.475f0.0039.GAE@google.com>
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


