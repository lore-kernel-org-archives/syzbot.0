Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.198
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793814151;
	b=4wubiSEXTRBYzWEL4e94BlOc5itcsZhdn30QJi3h590itcPy71bmdwY0EXmHgpdm2AvR
	 c2DrLWA6piXGkjT8hzVF/ZvdWGFvKeB43kICMl7ZIZzMTjFmGg0nd9o2Gk446Slki8+4x
	 SL8qWKsM0N3kpD5alntWJTNHshOChIqIry4F8vjGhz9f5Hh4FP+mPpiX4xQnaaRB06GPp
	 0Vvc7KOh7/gg2G6EIpaD2iU8eQTPlEokfKXrq8ZBIJsak9nSJsjtAqmv81O6CvcAnZo3H
	 WhCFanOw+RUVk4g6QS6NMqIxsKd7gznf430l4B1+tk/3aRj/+5GciuCSTiis81OQjvw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793814151;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=0nqT0h9ATmu7qIzf1sWwJR9Yuukj2vPYtbIIjLBIcc0=;
	b=0i3jxy1xVNSIqvoorMsYk5qylt3/MLC2OC094zeyU1CxaNNDC/kAMmNB9y5/Zqpqcu7A
	 V9dSK8BLDfjM2z39U1adUvmHdeM/+4cxZEnh0OIn/Wlb8cXqmsjg5WAtjz5SWjLfrtwRK
	 n12pvM/UYN9Vo9u1U/j22cyJU6j0Iw3CeJACdnKAdaLgj21ofPDvOSt0jNPnkkVMbq0i8
	 +2lRw4kLEarM5I+T5oAlLqA1A/WO+dVYGVELGkj8y85hJOKJQwA7pRqxUIVpx3hrt5G7H
	 DJymN3vv9Q6X9NJT+Szc5LxNCpAUfpeW7hVjtfjwlvRWyayl1fT1NO81y6Gegm7nQwg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.198
Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70FE0606A32E
	for <syzbot@lists.linux.dev>; Wed,  4 Nov 2026 17:42:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 70FE0606A32E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-4cc89e86e9eso1291209b6e.3
        for <syzbot@lists.linux.dev>; Wed, 04 Nov 2026 09:42:31 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793814150; x=1794418950;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0nqT0h9ATmu7qIzf1sWwJR9Yuukj2vPYtbIIjLBIcc0=;
        b=rE7IZQJk2mtLw4aMHSLWPFEtq8eibyFcdl1wGaWIpXmGdGbjOWTvHKQS77OXZzI+4N
         hIKn/9uALqR1UhluAHNu4hQiKykfSF11G284gvbJqT5euRU3nDMZX7xX6jtitAbqVKU2
         kmpRCNUHAIV39CDPagMoeIQTUWV+hU8dIdn0hdRtJEjmfMSEwJYSRvdSUTQKeDPr5j1e
         uBoQDtl3WoAXbxFMlooO9MWUiQInKI/th2k6HelNPab1cI5kz+lhrZoKdm5n4R+gBtSn
         ABrjxbec0qN2RoZP4vpgWUSVFTG2IpqQcjYXYOk3iEamMzBCu07PGZNOtvsAK0JWvWQ3
         h9aQ==
X-Gm-Message-State: APuU4Z8RGZ3/+NHeu7On+E1DKbH3G3Ty/9C12j21EZBX/8MI6SweYCkB
	3GwVKhuShomgSCGRk2ok/DLDvdnpiSqXVwkuuVCjbqB92ZH+4epyh3NUi+47J7XKVBqn/M35mUL
	qgzrrHsZ6+P84llv8YAGqCcKbYZVhreT3ldCFuO8xx34NzuMyoPhrbMQotgY=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6508:b0:4f3:36ff:e521 with SMTP id
 5614622812f47-5640df1c54bmr11456656b6e.58.1793814150477; Wed, 04 Nov 2026
 09:42:30 -0800 (PST)
Date: Wed, 04 Nov 2026 09:42:30 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aeb6e86.81adde43.1bc964.0026.GAE@google.com>
Subject: [moderation/CI] Re: wifi: cfg80211: add APIs for SMD transition
From: syzbot ci <syzbot+cie6c040d28a884561@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] wifi: cfg80211: add APIs for SMD transition
https://lore.kernel.org/all/20261103102632.00c94211841c.Id451626c78a925e85aaf2598ab471120940a91c7@changeid
* [PATCH wireless-next v2] wifi: cfg80211: add APIs for SMD transition

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/3cf38a93-9021-49ac-ad45-4944b36e7703

***

kernel build error

tree:      wireless-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/wireless/wireless-next.git
base:      991a73f4909f1348ffb4b38765cdb522a775e4c2
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/d095eb37-5fbb-4756-bd65-ab417709fadb/config

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

