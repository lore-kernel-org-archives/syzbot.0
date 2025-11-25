Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB2AC2E9ECA
	for <syzbot@lists.linux.dev>; Tue, 25 Nov 2025 09:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764064619; cv=none; b=U+fxIUZxAmF+m9rk2oVHij/NlaXCHGTNYWTieXDaSmbT8B3zRf/DY+u+zRmYVHUf8gno0nVsvaBPC3LiX+GW6HFRn7w1kt+NZ4y5HsMJlxaJOuDSDSAY5VZvfJ7AXHNwELZHb20fS8LIB+ysGEzD2q2ZSZGC02Z+rCJ8jodlEF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764064619; c=relaxed/simple;
	bh=afx+sGNe8nwzuS81t9UNvdeILOx7xsSVWMNMYo0JUJ0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=B7auMom8ZM3EGvBc+d4cJ+AkfVgN4xmxJcsLKCxIVj/XCgwlY5Xd20PkxEP765fEZJIGOyCCOuOJkjJN6cHEcNTxIkitm/ItTFjWIVeF+FgNmPmjwb2F8poy0ExVQ9yDe2vy6SEnSOgRCHZzeDwczuOR5PcLTVMgkDm67UM5pEA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-43335646758so44063065ab.3
        for <syzbot@lists.linux.dev>; Tue, 25 Nov 2025 01:56:57 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764064617; x=1764669417;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hkwuWzNjMYRcVKODOock4W4LmlhDftRRIz7tMAejuf8=;
        b=rNNeYd8afWZ2wETfM0XgzWWh62CXbGV/AgIZ1Hp86ZgmZVM1TkRRzTPNQRYtaMhtpu
         mlPXjMFCm29Coiri5RsMA9GMBLFhBPxwYJYVpjZnHb7bmk0/8ZRf2AbdZ8cENfaMPIOz
         ji0jsLGwGBTuD1xFn8+3E5LmsPRWLZdpW0i1yZAzD4/0iW/FVHBkfNy3DwzkfIvpvW0i
         WUkUn0xIMpK7ialputzmCYwhEpTIEKoOboyPIRjOQiFzYVMMuDPwn4cBz2p7pkjFojYR
         ivM+GRaQ9sxmZHqFIXUrFYL5L9p1UJ6YDlqg5MFwf9X/svveo8SX1ZAeMVa7QGYhz4lR
         vwEQ==
X-Gm-Message-State: AOJu0YzVac5a+PoevCCz9Ds/D9QcNtrd4bkI6ILjag8CBptRDd1cNBBU
	zwmqO8w0r10YjPRuvfYHzKK+B2NkUEWCQuhE8Znw9rbEoXlOkqp4c2aSxga11kNioSanT2/yvlF
	qMnNdonTEFxuEBjoJyDRyY31lj+b2DlJcFiVTFOUXSIXFNZF9AZlHO7A3qwI=
X-Google-Smtp-Source: AGHT+IE1SMh8E3fmrZ8EHYnL1IQyEXdJj0p5k57z1GSLa9f8DX8dEsYUtG9MRMvgyparXhoyimoPX1IpH2Xozaf+Ev+clq7u8grL
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:12ce:b0:434:96ea:ff4e with SMTP id
 e9e14a558f8ab-435b8ee7346mr126460385ab.39.1764064617001; Tue, 25 Nov 2025
 01:56:57 -0800 (PST)
Date: Tue, 25 Nov 2025 01:56:56 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69257d68.a70a0220.d98e3.00a4.GAE@google.com>
Subject: [moderation/CI] Re: A series of minor optimizations of the bonding module
From: syzbot ci <syzbot+cid1cf8302c418c0f4@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] A series of minor optimizations of the bonding module
https://lore.kernel.org/all/20251125084451.11632-1-tonghao@bamaicloud.com
* [PATCH net-next v1 1/5] net: bonding: use workqueue to make sure peer notify updated in lacp mode
* [PATCH net-next v1 2/5] net: bonding: move bond_should_notify_peers, e.g. into rtnl lock block
* [PATCH net-next v1 3/5] net: bonding: skip the 2nd trylock when first one fail
* [PATCH net-next v1 4/5] net: bonding: add the READ_ONCE/WRITE_ONCE for outside lock accessing
* [PATCH net-next v1 5/5] net: bonding: combine rtnl lock block for arp monitor in activebackup mode

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/7cb17fee-8e79-4633-a4dc-95fb83f26928

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      e2c20036a8879476c88002730d8a27f4e3c32d4b
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/592413ec-7f74-4f30-96ea-06d1dd8c8e3c/config

drivers/net/bonding/bond_main.c:1207:2: error: unterminated function-like macro invocation
drivers/net/bonding/bond_main.c:6577:37: error: expected '}'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch corbet@lwn.net davem@davemloft.net edumazet@google.com horms@kernel.org jv@jvosburgh.net kuba@kernel.org liuhangbin@gmail.com netdev@vger.kernel.org pabeni@redhat.com razor@blackwall.org tonghao@bamaicloud.com]

If the report looks fine to you, reply with:
#syz upstream

