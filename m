Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.167.200
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793869610;
	b=XVG5O2g2ZUBnGlbAwc94JPCazpxbNp2N+aN+4Kp4xgh/HU6h3eKqfNxI8fNtWqLCha/n
	 FXFC0mOntmKPHah4X4GDbGcDdO0RqXHF9uPfATZGhEzzFqKfiHG4I3LJti8L73PTHHqAb
	 uQBMkpCi++j8IeWWbl0QZZskW79BeZpanR9DNlXTo3p4uxlgCIQulJ0Rx0v6qaf4/Ie23
	 OUZpgTAUMeDJsAHoHXU2a16Cvk1X3wcK41Q1/MzXk1SIiDER1pX2Ji00EPfyLvtwO//A5
	 E2Q5oBo1ysNLZgOvdl8tV2yhtJ0wiCu+3z0XTYPUloM6HCx0YSJWxzLD8pcwWFMwGbQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793869610;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Gm-Message-State:
	 MIME-Version:X-Received:Date:X-Google-Appengine-App-Id:
	 X-Google-Appengine-App-Id-Alias:Message-ID:Subject:From:To:Cc:
	 Content-Type;
	bh=+4xdRKBHO/p22CfflZIYK8oaR6syDI49Dlz7f80jKNw=;
	b=CS6ssAMuuX865JqlxpsMvx1zH4y6D5ZSiEuABOute/g1Jnl574AkeBekH1ycsPhn9T0b
	 YWCxGbyaLEJaqphABn3dxOe4XWfiqd2uUi2Ajyc8gaH/m5KPxt/Yea6cefxgz4Z2HlNcp
	 pdZkCbFNJHdOwiF/0w+mmn9xfgR2wHo4aXot/u3OCrjlN7sqVRalQ2IC6ETUY+O4yYzDp
	 qb9QHtFaJsVrwuGLUacp0+2u+hwZsuOYKycYZqPhAB5HWTWuK13K0lNm0quDOZRPMQ3lS
	 +RPof2yNDn5feG334LQ96eSmp4oCkKlQ5uIr+C7i4e+U7OT1ERymrcyNxxzCkt14QLg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.167.200
Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 789F1606A329
	for <syzbot@lists.linux.dev>; Thu,  5 Nov 2026 09:06:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 789F1606A329
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b597558c4cso2203519b6e.1
        for <syzbot@lists.linux.dev>; Thu, 05 Nov 2026 01:06:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793869609; x=1794474409;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+4xdRKBHO/p22CfflZIYK8oaR6syDI49Dlz7f80jKNw=;
        b=ix6uLkyOF6MbJ8/6wABxXX5ODx6R+iQY6qYHQhmT9cBjbU8Nyn+6yTdQ3T7UZvTaJB
         +I6WittCeXBPmyKBVoHHRY0qOxRoZVvnlbURIlmVh4HjnlCNORdQqtJMmg61Am6V29AV
         66X5SpqqMeo03wQiJN7mnyRpGmd+1dENbXAh562qatVdNzIJUhvVNt22JQUvSZnKIUkU
         7cvc2I1WtB394/BBlXW5lZjWSjODwoPQ4JQSweS7WUa9GybalNAJTdT5HimHIa8RYhpt
         RXKHWwZCGbd/Adv0D+eFsmtXar+bt8ahykOE55a4duG7DP0AqeAaHGNwGviNU7TYyeFC
         fu3Q==
X-Gm-Message-State: APuU4Z9ojkvTQNMKufGl1Ts7nlEX2ulQq82bltsZk6gdj1CBmFcGvAJp
	hPrYqsqTPyKLzDbe9CjABusGgDHYUKzDzUnyWCykZHy1xv0EMzPcu8uxy656PkbdAAD0yUQgGtT
	bVOiqJMRBLQgKRT5o9rNpVWiPRYAKTPu0GeJe8JkW72WE0nZGz1Qj+ssx1BE=
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
X-Received: by 2002:a05:6808:191f:b0:4f4:3790:6615 with SMTP id
 5614622812f47-5640deea416mr14865255b6e.11.1793869609468; Thu, 05 Nov 2026
 01:06:49 -0800 (PST)
Date: Thu, 05 Nov 2026 01:06:49 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6aec4729.21d05368.325ed5.0009.GAE@google.com>
Subject: [moderation/CI] Re: netfilter: synproxy: prevent unbounded recursion
 in transmit path
From: syzbot ci <syzbot+ci9aadfe254095687a@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: synproxy: prevent unbounded recursion in transmit path
https://lore.kernel.org/all/20261103125638.4667-1-fmancera@suse.de
* [PATCH nf] netfilter: synproxy: prevent unbounded recursion in transmit path

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/515cfb4b-53a7-4985-8bec-de87c9528e86

***

kernel build error

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      734bef548a96e8774d6eef5dfa2026c6edc4e80b
arch:      amd64
compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/ec556599-ee99-4b34-b885-68ba4ae8fe72/config

net/netfilter/nf_synproxy_core.c:24:10: fatal error: 'net/netfilter/nf_recursion.h' file not found

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
[coreteam@netfilter.org fmancera@suse.de fw@strlen.de netfilter-devel@vger.kernel.org pablo@netfilter.org phil@nwl.cc]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

