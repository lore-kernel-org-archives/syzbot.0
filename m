Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DC4B14A4F9
	for <syzbot@lists.linux.dev>; Sun,  5 Oct 2025 13:25:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759670725; cv=none; b=E+QVMpQYvlZSypkSGgERGWEIXlS0vaQYt9E7wZBI4hv5Rrmh/JKsztpW0pYAL8V4JagwAAEyn4+C+Ufj1nNs4jT/VAD9JYK9PVXBimlmfjQnJpcmyQPlDO1cs/7uKi3V25P98fcfAVRjIZ+UZsiyfd7TY69EltcRO7mV+icJTco=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759670725; c=relaxed/simple;
	bh=+BKUoKxrsZ+ua6eEdPd84Tbe9K1A+thD16iOEQqcffg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=WTvxQgtLlJswlQJ95Pj/v98xMb7heYMa0fquHove/Ulq1SV8LrNy1j80xu1vYUDxRjAtPEqpvFN627pYVO2e49uI4rMZRF2ocXVnfkoFLcAdshwhZ8BNgtuyIVBm6sZnRS/eK0Xd9TZ39VufVnBCiQo+dGFeLsM2WRjjtpF53ME=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-42f6c3feed8so6431355ab.0
        for <syzbot@lists.linux.dev>; Sun, 05 Oct 2025 06:25:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759670723; x=1760275523;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QrP8PqZ1xN5sTFGkL8OxArbCXNxOuLjuXVblJvqSKrE=;
        b=Yej9P7b5c0DD1pmF2icv7KqMkFt1HJeMUptfbbnLZdfgTPqCCmY6FW+tVOpr/hXHcG
         z0wO6vyRhm/kv9KRigpl07h/N6IuPBna6gI7eB1EcJRk3a2teM4XIWSaVJKFgtXFyq/X
         u2NMTviYle1SQIDwt6PNsct4QfdjF7zBP0F15vLe76WE1U6z5wGIkigyEeShMvi6xR6o
         hcmGjRXeJ4dNa/KFPtOQZnbm2ZjukPvIkWcW6TeFrNQnY50QgG85auG+VxBWRCVCfhQ4
         WxaQE8EQna2gGRQCJQtUM+3JRcobDZM3Vgk8XJ0d6RScmrwyNXE7niODtJYKb/kvFR7c
         o/jw==
X-Gm-Message-State: AOJu0YxfSZiH7MqDnG5E0Ea7xj58VYiYxXevHJFAWjbmxWmfpyUn1tZF
	GHvDtTFuQVsE+Dce8XS7p+2Y/QSw5hpRahzijjbnzUWS87aq3SwsRAxkIJs9FyjRbTZAXUegVXv
	10xt7QUVtzZWZePkosCPHjlWNP2rk9FqHDn3RYCosw2jNr37fVu2LLO7OLAU=
X-Google-Smtp-Source: AGHT+IHYifQlmLCTc5x23t/VgiPuA1wieXWwGLetkobB3vuvqfXg8e4T9EN6q1H//y3Qhq2vvo1jdl6q74rLZRdiPAZoRTFSWN9E
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16c9:b0:424:b860:7d84 with SMTP id
 e9e14a558f8ab-42e7adaa636mr118810465ab.27.1759670723288; Sun, 05 Oct 2025
 06:25:23 -0700 (PDT)
Date: Sun, 05 Oct 2025 06:25:23 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68e271c3.a00a0220.2ba410.0012.GAE@google.com>
Subject: [moderation/CI] Re: wireguard: allowedips: Use kfree_rcu() instead of call_rcu()
From: syzbot ci <syzbot+cicf3db1f6ebc973af@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] wireguard: allowedips: Use kfree_rcu() instead of call_rcu()
https://lore.kernel.org/all/20251005122626.26988-1-wangfushuai@baidu.com
* [PATCH] wireguard: allowedips: Use kfree_rcu() instead of call_rcu()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/cb617eae-c567-4d00-80c6-1a03a38ebfd7

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      f1455695d2d99894b65db233877acac9a0e120b9
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/a1ef39a1-d868-4c46-a47c-895eda046f0f/config

drivers/net/wireguard/allowedips.c:269:2: error: offsetof requires struct, union, or class type, 'typeof (*(&node))' (aka 'struct allowedips_node *') invalid
drivers/net/wireguard/allowedips.c:269:2: error: member reference base type 'struct allowedips_node *' is not a structure or union
drivers/net/wireguard/allowedips.c:275:2: error: offsetof requires struct, union, or class type, 'typeof (*(&parent))' (aka 'struct allowedips_node *') invalid
drivers/net/wireguard/allowedips.c:275:2: error: member reference base type 'struct allowedips_node *' is not a structure or union

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[andrew@lunn.ch davem@davemloft.net edumazet@google.com jason@zx2c4.com kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com wangfushuai@baidu.com wireguard@lists.zx2c4.com]

If the report looks fine to you, reply with:
#syz upstream

