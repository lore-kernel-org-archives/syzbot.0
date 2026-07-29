Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E6D872E7377
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 22:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785365184; cv=none; b=WyI0X3ojLiI5K5seiUUD496kq4J57xdQHjfjU6kP2HS5Adsif3e/awh57FywSYRTC5GBDeAnxxlQsOMcHanwH0bjsDbeR/T0a3LQudwafFFo4R5loZO43HXXuEL35gDilQRx7z6mifYNM9woWLNNUV3AqJ9nUkmTOVVH+j06VKI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785365184; c=relaxed/simple;
	bh=xlFvntlkA5s7RKBnvdLS8AefpWcBBBZaoDqzo/OLkhw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Py9uP7eDxV9r3N/a4gfMgEvGAXQ7y74n0jXROgimg8hZFKz0hh2+AjNa71WTh2Kf4sVcD7usFEh6+LOFQ6zRt1277nPqvNhrrl/hfJtA5wqFNFHHHz1uCaweM2M42QqMA97/+96Uax2JZLlsj0K2V9P76Mhb/oQag8G6Mvyfx8Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-6a1240143d0so1944579eaf.0
        for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 15:46:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785365182; x=1785969982;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=rhdvEheb2Y7kv1CxtRNMBBsk+lvd+DMNxdhoi0e3GZY=;
        b=F7L+/2vC6ptbWkSUDWiDPS8oJ5tSm+oFKt92Q3x89jaBt+iUBLYAjssGiYcTNsuviY
         sePvAmFVXbp1LuGzELh2TlzEqdYmqzHx2sZ30ynbcZP66pRV/7+AEGrRGEAXHI2i1K3C
         bBZm7RUUlJV6YuCa24BGwjsSr0sSd1+qONCaaRM0oDD1/ctfvDm4vTq/wJCZaA0tgq99
         RfkziQ7oYDt7gAhgSX7jr2EHeO/VhRfJKURTJrDqOhGhiDxgbFsCkKlE0T+Ntw3rYuqV
         tidldngLsVgw0LsenFSfj8DUD2L83a2ZDL2kyx4yZ5oAU5q1/mip4CrwGh4Z4xR0Ge/j
         /Z6g==
X-Gm-Message-State: AOJu0YwG78Lg4RfZy5+NUO4kZc4xa/U2G2FPsWEUyakCHMfOxJAT5CVP
	7nDFBgknlMF7060mIiK1+PcdhFc+43xLXUxRHI8Ge8aJEFc/0Ot8A674K/YCMfKc+er+mk716yq
	b7rXqLqIlFT4XgKEct+KtiEwc+qazhuJdWvITYOTEr6ZtEY4qaJsN/w3eHx0=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:151b:b0:6a3:87fd:2130 with SMTP id
 006d021491bc7-6acbc161aa7mr155577eaf.67.1785365181915; Wed, 29 Jul 2026
 15:46:21 -0700 (PDT)
Date: Wed, 29 Jul 2026 15:46:21 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a6a82bd.57649fcc.360844.0008.GAE@google.com>
Subject: [moderation/CI] Re: team: reject CAN and IEEE 802.15.4 devices in team_port_add
From: syzbot ci <syzbot+ci75222525e6acd9da@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] team: reject CAN and IEEE 802.15.4 devices in team_port_add
https://lore.kernel.org/all/20260728151240.89434-1-yaojiale02@163.com
* [PATCH v2] team: reject CAN and IEEE 802.15.4 devices in team_port_add

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/e0faf45d-b7b0-483e-96d3-a27fcc248199

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      2bb54b49e9d522f54dc9c0fe10ba40fbc56041c8
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/08aac67c-0bc8-4532-a3e2-acb78eba26e8/config

drivers/net/team/team_core.c:1236:2: error: non-void function does not return a value in all control paths [-Werror,-Wreturn-type]
drivers/net/team/team_core.c:1238:2: error: expected identifier or '('
drivers/net/team/team_core.c:1245:2: error: expected identifier or '('
drivers/net/team/team_core.c:1251:2: error: expected identifier or '('
drivers/net/team/team_core.c:1258:2: error: expected identifier or '('
drivers/net/team/team_core.c:1265:2: error: expected identifier or '('
drivers/net/team/team_core.c:1273:2: error: expected identifier or '('
drivers/net/team/team_core.c:1280:2: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
drivers/net/team/team_core.c:1280:9: error: statement expression not allowed at file scope
drivers/net/team/team_core.c:1282:2: error: expected identifier or '('
drivers/net/team/team_core.c:1285:2: error: unknown type name 'port'
drivers/net/team/team_core.c:1285:6: error: expected identifier or '('
drivers/net/team/team_core.c:1286:2: error: unknown type name 'port'
drivers/net/team/team_core.c:1286:6: error: expected identifier or '('
drivers/net/team/team_core.c:1287:17: error: expected parameter declarator
drivers/net/team/team_core.c:1287:17: error: expected ')'
drivers/net/team/team_core.c:1287:2: error: type specifier missing, defaults to 'int'; ISO C99 and later do not support implicit int [-Wimplicit-int]
drivers/net/team/team_core.c:1287:16: error: a function declaration without a prototype is deprecated in all versions of C [-Werror,-Wstrict-prototypes]
drivers/net/team/team_core.c:1287:2: error: a function declaration without a prototype is deprecated in all versions of C and is treated as a zero-parameter prototype in C23, conflicting with a previous declaration [-Werror,-Wdeprecated-non-prototype]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.

The email will later be sent to:
[andrew@lunn.ch davem@davemloft.net edumazet@google.com jiri@resnulli.us kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com yaojiale02@163.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

