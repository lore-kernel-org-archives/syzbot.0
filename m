Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.160.70
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795740541;
	b=hAYkubTyfxyUZosNHnRB5XegUSsgUjiimKRJvg2b3TTIeo6tcNb0q923DjMhy27bT+US
	 mBqoEUJkv+aGvWkKT1oLM2oRPq9Nwud5fIob3Li21M3FxWB//X7cpMhI0wlIxwtsf477h
	 QydTENepSgA4cBEHJO3NkDI8LCAehWGMIvJP3ZuGSHJ62AdDz6QUdVY4xm1NZ2OYmuhwW
	 Py26YxEYzKTkw2LtiKoyAkzfuJSYqqngOC48ox4sRmoe8y0r7hOW7yjcmLXCJWIEDCEmF
	 q0ym2HkgaHNZSlUpxRfNSZZmpm1sIwwdIjl78STuiDqF8l9Wcp75ubhgDSpDZkm/Dkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795740541;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type:Content-Transfer-Encoding;
	bh=xiQZljlHwZtvNF0t1X24YoQisqiYfoEyxk9+971YFYc=;
	b=gR0vH5BfsBQmBV1WhJWNIIepJZK3fhJ3g5nKIafHQU13bR41dQsWo7co/fnjSVcUZrqt
	 SE70w2x1gT2wkh9i+LbXeouyTCDPR6l88VjHuomugk5ClzOo8MQI6/IbsxNa6nJCcoFcF
	 bXeRB13E9cJ4UYqYU6sgWbHRr2d4h0qsOVNSJ7rwiNTWB7HW8Cos4vD2UT2ID2ZM+7PxB
	 DF0ltyloyp29wHwibP4cIn0zlEaeUssZ76S1QCwp6KBc1VblkUFX/keIjni/rb0YvEYkP
	 xi8cew7Di72JLz8+tDpqrVguPwKg07oHiygdptBAyKMk1nVUcdj/mA1jFZGSmyaZgbA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.160.70
Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92699606A31E
	for <syzbot@lists.linux.dev>; Fri, 27 Nov 2026 00:49:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92699606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-4943ed99826so5210491fac.3
        for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 16:49:00 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795740539; x=1796345339;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=xiQZljlHwZtvNF0t1X24YoQisqiYfoEyxk9+971YFYc=;
        b=tdX1ULwHOvl9M4H8i0nXQNfoutOBKoG7+6P+QVOti7V2Cs5aY3NbOAYrKk3v7ns9nc
         XMTh1cpnfDESlKMorfFY8/n1KiQSwpbo7CPYfOCi0Sisr+GVSz2O8KhF7ZACw7s/iM/e
         xRgPtHYXScuiTbTk9IBCK1/Yl0wI7ty7GaA0Y7wEc8CgRGIjw7KKz4AgKtyKc4K1bsWJ
         3H4SYjvgFt37gR0BqspsCc6uEnnjtuxoZka/JCnhXs+lZxCoGEmIKk0zzywZE/EALVYJ
         fg2zdcw/31fifQh7xRoVvoOm4xjO799xeV9A+k53vQxDC49es3f2uxcRI61aXenid9kU
         WWpg==
X-Gm-Message-State: APuU4Z8t3qoa/JHtc7qN4lz99tHYgOud3klGAhnt8wItAtGTGDn60d0r
	pvHCmX9k3p9ON5vKpRT6SfXge6zCLdquSyeBOY0Yts2+4ae0Pj5H1EvmWuNv9U1nAyVDK/YvSoz
	yROqVOlC27K02FVB6SRW/NvDkvdZaFWablpGtqOakgQoPrqVGlcGUBsRMwCA=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4f46:b0:55c:6ea:3e3f with SMTP id
 5614622812f47-57a0b449e33mr24457013b6e.28.1795740539609; Thu, 26 Nov 2026
 16:48:59 -0800 (PST)
Date: Thu, 26 Nov 2026 16:48:59 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6b08d37b.904258e1.78503.0027.GAE@google.com>
Subject: [moderation/CI] Re: smb: client: convert DFS target node name from
 cache charset on mount
From: syzbot ci <syzbot+ci5745b6f180771df7@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] smb: client: convert DFS target node name from cache charset on mount
https://lore.kernel.org/all/20261122045841.99012-1-fredric.cover.lkernel@gm=
ail.com
* [PATCH] smb: client: convert DFS target node name from cache charset on m=
ount

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/fb1aab4f-752b-40d9-8b79-5da469f0f2a4

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      25faec9ce61c01fb45abf812a222c5b43c3cd5c5
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/cc82e701-1589-423f-83ed-3d69d495c7e=
7/config

fs/smb/client/dfs.c:44:14: error: call to undeclared function 'dfs_cache_lo=
cal_path'; ISO C99 and later do not support implicit function declarations =
[-Wimplicit-function-declaration]
fs/smb/client/dfs.c:44:12: error: incompatible integer to pointer conversio=
n assigning to 'char *' from 'int' [-Wint-conversion]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[bharathsm@microsoft.com chenxiaosong@chenxiaosong.com fredric.cover.lkerne=
l@gmail.com linkinjeon@kernel.org linux-cifs@vger.kernel.org linux-kernel@v=
ger.kernel.org pc@manguebit.org ronniesahlberg@gmail.com sprasad@microsoft.=
com stable@vger.kernel.org tom@talpey.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

