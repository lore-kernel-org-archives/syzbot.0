Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.197
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793832859;
	b=Ut5zSkooZEjjdlP40Q7ns3IrQAyZFyCTLerfN4nunk+vs2esBpz9VSMlQUpyjTFIIVbl
	 C0Q5q5m000ShE0SJwv1msZMfHCOVMbeKZrqtfuP/ycZlD+Rn0jkEZbJTHJelx7DRw9/Wl
	 cnYJ8FBBxx6l5A2stYwx6jCYFGp8lAIWMJRjvpOPTFS0KHeXuvYjvtmrfyfYWQXkNET3x
	 kUESaxVNb/S2//wUbUG27clAFzvNYfjU6kvWiRWaaWZyEDyQ/IrnOrQmPaj0yHj7B0Zms
	 /ErtS6c3DLC/TVYrD73IZUOMzwWsa2++jO8yICWacakR4MwnQ3cuCbka8SPqDiEdHOw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793832859;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=JujMJkgeCLWkMFYQ0JNRG6jonNRW1ynfLZMv6gy2jhA=;
	b=HXSkVAsV2CJS0wN+Cu8sEVzlH5hW7ywRnIrzt430hb2dPtsu/pyA+yAPtr0MhHwnAfDM
	 AWzR3FN7gDApwwbSMZ6v2u8T4h37QzNYRv1UR2weQUqspgzA6Db+kozS5GOC12pagio3q
	 Bi18nG7Awgh43UZfNy5ZDJfP65MsuaFtbKYvzHs817mvsat3Ph/VzIbcL0MG3Pv1h56WS
	 I6RaKMQrFBh2zJ6cyC/AqnLPhDIHGmWKwIta7D5aqdEELq7nZMob/tZ4l9s6E1f9NPbqK
	 9SMOp7e8AMGzOuuw2oWiGIn0BDsOtyb2vNv9W0dBU22COHavLY4ZFYBzQH2b8f6Wlcw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.197
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBEB1606A31B
	for <syzbot@lists.linux.dev>; Wed,  4 Nov 2026 22:54:18 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org CBEB1606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-547ae874949so1806689b6e.2
        for <syzbot@lists.linux.dev>; Wed, 04 Nov 2026 14:54:18 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793832858; x=1794437658;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=JujMJkgeCLWkMFYQ0JNRG6jonNRW1ynfLZMv6gy2jhA=;
        b=ShEFNFuzqUhkXTgVcYcRCshH3po8De8Rvfo42icTu9U2RpV+i14PdT3qhBYle7nc+5
         c5rk/mQPUvEwf4RPB743FBzSiRfD6OtYbiTL/9Jv8lYvfSSO9mjzvjddQu3WEJv3nTBx
         KLEWnr2pcGomfEH44e5eGHHL2bzIPGguiFRN7oZ3uWVh5BDjYUNRlpk3SU0mJ3oOwXLf
         wUCiqg7gqtsjT99SpguObS8icJxqDr79JtkcyVBPsGmvpdAHlShJ7QWseyfgStQ0KQ2C
         PENkLP57bIFYGQg3lDNbLNA0lIrvyjXWZaoFHykTA1sH0IwEX/LuXvtLnU/8w39r+ffh
         09GQ==
X-Gm-Message-State: APuU4Z8IDLqVg4GZZhsi0sDJECDEb4xPy2nsRJAsItwe6NT8mHRBp00S
	gVez/tA4ELZbzz3IZQrh2QsPLj3TlBh1dWd5Tp2mnAZqHIizunZYv2f4P2SxnHNjVMk9J9I2pKQ
	1Nn+sTmDvOPi5baOJlC5jy+kVEy58SKZwjuP+paSdBgzEnROlgUn6zNNL3zI=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:181f:b0:54c:7bef:90d6 with SMTP id
 5614622812f47-5640dbd679bmr10814599b6e.4.1793832857869; Wed, 04 Nov 2026
 14:54:17 -0800 (PST)
Date: Wed, 04 Nov 2026 14:54:17 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aebb799.7bd3e221.25cd79.0006.GAE@google.com>
Subject: [moderation/CI] Re: wifi: cfg80211: add APIs for SMD transition
From: syzbot ci <syzbot+ci6b129393e781ecde@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v3] wifi: cfg80211: add APIs for SMD transition
https://lore.kernel.org/all/20261103112102.a1b53635b494.Id451626c78a925e85aaf2598ab471120940a91c7@changeid
* [PATCH v3 wireless-next] wifi: cfg80211: add APIs for SMD transition

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/3bc2c92a-22f2-40f7-b9b3-e3ae7c7ce038

***

kernel build error

tree:      wireless-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wireless/wireless-next.git
base:      991a73f4909f1348ffb4b38765cdb522a775e4c2
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/7e5f9adb-a39a-4479-9604-c2b5893f7afb/config

ld.lld: error: undefined symbol: cfg80211_update_assoc_bss_entry

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
[johannes.berg@intel.com johannes@sipsolutions.net linux-wireless@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

