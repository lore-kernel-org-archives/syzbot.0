Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793690444;
	b=vpkufBuQhgtxIyvYtd47DV0HDCMf819xWsUMZRTwZQr/1l+7oMDzLJLLASqaPW4v0m8l
	 /UuBr1Ns/F4jaDXPIQyMid/u7B5/gp/Nj2n6Vsa3Nx/IJajQ5lHxGEDWugrLlaEmYPbpg
	 GBQpGkPrsafIKAuv8dUQDUWGkNPM2re7iD+hobmt7/8G6UzjDO6LCTiaM9j3nkFWf01gE
	 B2/DEr8pbo5rDmopzJxL7S1DzDPY/uBDq88XFdbzF+ZUeLE4pXMT8nud13JF2mN8axqwx
	 YxjdfdG9ZT0xIOTFaO9+W/wEzhLG1TZcK6cDm1aJ1Qxkm1Tle4IYw1+lwG4riws73Hw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793690444;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=EN+mgN/AsyKjA1JRkEvWhL7V5KzJJeBtqFfYI0oWP1M=;
	b=p77DKW/cC8+Grcfp8D+hW11cX9wl+YYPL2T5IzhjYcqSvucR+dsBFg6PF34V4Y3+cpVY
	 I7E1ZS+YZYXtnczInToWCooy2FjZrBLtz8rMnbUSnmxXKWxTdD8nig/3yIv/Ud5iWt335
	 vZKVz1z+SdMJ11YXgmi/w5Mla68Ed860vQ3jXvt1+7lWEC7ZIsFQYS4knBjXV6FDu4GFC
	 z9du8tg6FTLnU6EXuyY7fpQsNznp9h05NjK9h4MJxdY7ywODGENe0+xSE7YmNaSBCru8j
	 J0ImBnhyxLVeRmLN1BVxdKEc4EAduYmQMGpnh2Qzexvnfne9Mk6cR0pSE0e7s9nXwXg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1C503606A32C
	for <syzbot@lists.linux.dev>; Tue,  3 Nov 2026 07:20:43 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 1C503606A32C
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-4a45b3f0bdfso6273358b6e.1
        for <syzbot@lists.linux.dev>; Mon, 02 Nov 2026 23:20:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793690443; x=1794295243;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=EN+mgN/AsyKjA1JRkEvWhL7V5KzJJeBtqFfYI0oWP1M=;
        b=HuZTnI+lf6ZvAmQtdm24C296ELFRhS+cWX+3kS7ZZ7C1VCq6SEKuJbXCapXWV17Ilc
         tTa7xZCD4UhIPUw4GnSJUUmMoMxoTK57sOOIoLrUMzuFCELGnK7uD1iH9UlN5Hzj10Wx
         4Rs/9hbFDIXNuiAq9cyrXvoFFLj2k0aT28BEqNaGO28VQYxPzPwd7pJoSeGOwnUGGk4w
         HhuU5ek78Lwhg3gy84SDTTA1s2Ndxiu65pvcpGRYX92FS+KxwpLh/e+LyIB4fzueALWH
         s/Z6964nXJKmAxDwsna9ZMH6kY+MXvuG3clgThmnkaBub8Bvq9UcwaUos6I75S8Ia/SV
         Wn+A==
X-Gm-Message-State: AFq9FYKdsM/5AZ8TQeek7hOxWPW7WgYAQHtGkgHLL0Rvglat819YH61i
	hb80Gx/xt4lUnyN/z2oLcGuq0bSORj3vmFyZ6LGyx2GgsX63YVOA/p6T32va+nZZ8FdkLqShn5y
	0k+Z5CDB/2Vq9Xd86oDDxeC4GnD61NghnC1CkAwY6f8h/IrMNQFp/rpdAEkQ=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3098:b0:4f6:a430:1822 with SMTP id
 5614622812f47-5640d91b3e5mr8522158b6e.7.1793690443072; Mon, 02 Nov 2026
 23:20:43 -0800 (PST)
Date: Mon, 02 Nov 2026 23:20:43 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ae98b4b.80718103.e2fb0.08c2.GAE@google.com>
Subject: [moderation/CI] Re: speakup: Serialize synth clearing against locked readers
From: syzbot ci <syzbot+ci858fd911e60e50b6@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] speakup: Serialize synth clearing against locked readers
https://lore.kernel.org/all/179363263139.43100.8043437977710970575@kylinos.cn
* [PATCH v2] speakup: Serialize synth clearing against locked readers

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/dacbf728-8a46-46a5-92e9-5978e917ae77

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      6628e7d4c6b25c8d18f1345e3a20d21829aae7e4
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/d2e1902d-8835-4425-9c79-e8fd59c6a01f/config

drivers/accessibility/speakup/synth.c:485:45: error: use of undeclared identifier 'flags'
drivers/accessibility/speakup/synth.c:487:50: error: use of undeclared identifier 'flags'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[chris@the-brannons.com gregkh@linuxfoundation.org kirk@reisers.ca linux-kernel@vger.kernel.org samuel.thibault@ens-lyon.org speakup@linux-speakup.org stable@vger.kernel.org w.d.hubbs@gmail.com xiehongyu1@kylinos.cn]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

