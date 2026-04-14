Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244553A545A
	for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 08:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776155021; cv=none; b=obw+Mjk6VEaX5vPxnEbh3y44/opigsLoYS3xWsqS7rIJfDmEG8ytt8n3u4Zrl+hEKPvgUQ+7FVLZD3JLq5nxFTFWpzfaHuVAxau/sh5BXqcQxlVpLajUbcbyfVax14/C3S0fjy051khB+9XOsFvlMl2kAZ80Cs4t91mquqOniVc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776155021; c=relaxed/simple;
	bh=Fw+1wPOPV2ITfvOLj7hGAekW4EetWYP+mF6tA3N0TDw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=u9RZCkHMjprb+e1LtMZoFRAH1VoiT3mL1rIeQRFQFkQT/UUPUjpVZuPUuA5WlR/K902OYlc3zuMqX0rgRtQRqeL2gv8/BZG+F+12KLgQ1yC+y/UyWV9PoWylTolFwW6FLZtU7+y0l56p5f//ZE1dYklJ9B5ZGYdzxFFkwBD8OMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7dbbef3ff5cso6243256a34.0
        for <syzbot@lists.linux.dev>; Tue, 14 Apr 2026 01:23:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776155019; x=1776759819;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=1PMByDDAznehAx4DTq4epwxKUynhUt4hAecE70ebkhA=;
        b=fv6x+jUncCnF9FhaPQJSE6B7eFw4CQpy7fHT15LHlgvYv1dElR0h+WlH1PMnkgemCT
         yoIIigSmdviM9rd8uq2RwfWkHCvkTFXpNBmsbSGqyj6OnM5xkUIEdId3kH+RPl2BfkgX
         a8dSVcQ+iM2EzUdV+y8gglChAWALFX8PrkL2iEpdGAGVxnf07kgi5aPcyiLrePYVKAzt
         I4mGcEYAxcs9vUSPDDBXX5EtFv1q+Air+bPyQm9pVl4GIsKks60zvnLGHWuHtjUq1i18
         f+nut2f8PyqSEgmvds2bbgswzea3NJGErkSP0n42pIII0nqf6gZSIJ+ucjW8MveaiqbE
         r9Ww==
X-Gm-Message-State: AOJu0YyD8hbuWiztoW7mhRVKve0XVuxuCiMdr8/IuH2pv1z/OALaAEqh
	Cf0XPEjcgQBSCuKdJPA9QdGTkU/IvDkrhWcIFKbpneO3ZShXBXHUnnSdFJUVvwUr9rNS3ZeqzeO
	//0DdtaFbvTy6RKqktC8ugTSLRP8Vr07emUDGohfEDNRhcTde0KQIw+0Selg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3092:b0:67e:33d5:76f8 with SMTP id
 006d021491bc7-68be8fce5e9mr8865807eaf.61.1776155019234; Tue, 14 Apr 2026
 01:23:39 -0700 (PDT)
Date: Tue, 14 Apr 2026 01:23:39 -0700
In-Reply-To: <20260414081746.17392-1-nogikh@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ddf98b.a00a0220.475f0.003a.GAE@google.com>
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


