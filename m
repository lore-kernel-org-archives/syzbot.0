Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D101FC0EA
	for <syzbot@lists.linux.dev>; Thu,  7 May 2026 10:30:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778149862; cv=none; b=Yr5DM/Tyy4dko7Zmtv1+cJQJIFdvfu7hvw+zGoryrIMQ7GQmY9cey5+lswiRr/RS8b2RJEOi/v2Ba0zbamLhY8RPT76jVlT2k33U7+8daA9P6lWaf+Izc5JYk7yjSlV60HDE5VAFT7ZHvMucMBu4U1TKRuUpEW1lUn//MI8XTnk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778149862; c=relaxed/simple;
	bh=Zm7pA92IgDYbcA+yVW90kGlb+NJk0W4uODXthvd7b0c=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=C1TOBgdZ9FJm0f7voRrG30S9lm8A/AClCTmZXZYaGZ120u2kv0bLVpzpzrhd0ovgPM3Eue2HCinHssW4KyFNHmby92kitiKDwvAnSImj533crKbXEIHU4K+Y6GBItvMmJai0kPoPPuD5YQWp21pgWnu8cYWRLfRhw6TAXiUCTpk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-69677d248a4so1041524eaf.1
        for <syzbot@lists.linux.dev>; Thu, 07 May 2026 03:30:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778149858; x=1778754658;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=SsF1b5thg0wm+yw10Bdq+gPvmwehGnARs5pdV/Wkz1k=;
        b=cO6IESuitjjQEI8On8KbSBAqSJUt+DFWvpeH+0vSD9gxFxWXxRKrZNRHL/tQLillYk
         qy06VjfhMEfbMqFsHvSYTDgMx0eoqyZHcTrnksFNoidM6rHSSJcjvJ9HJEx41sR+UV1z
         nZxUo3iwfrVwr4uGMxwQe6kHZMIdZdfl9dj8cPt/fQhox9z2CZ/wbutTULrwZDWoKEgt
         Hkg8/Z9TaSZdWDlLpJm5G/mD9XiquBtw5gzPeqSFzNc5GNHkta+7oo6mPLig6UxZ3GAO
         bx0D9tmZ2v2zKBwFubmp124mHwbBwNzgLbBusqn3DEHHNfLj337Gfbdo3WRHov7uKQMK
         rRiw==
X-Gm-Message-State: AOJu0YzIXB/tu2diESFk5/h680GN3dBvYM+1hhebyHbT2Jd5sz06/p6K
	F8x5bJ5zzxQ2Rx6WDMTPV1qBhaalZHN4y6XLZlPC72mymxe6AJ0k9HkEXY/q7n1pPW7y+OISJvp
	nSzaeOrLgjn2BAXVwcOsBSJ8xoafOLXZ2vC90iyRZnUwDwGZDgHJnGxwjZpc=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:81c8:b0:696:6f52:95f8 with SMTP id
 006d021491bc7-69998c8fb8fmr4048939eaf.3.1778149858067; Thu, 07 May 2026
 03:30:58 -0700 (PDT)
Date: Thu, 07 May 2026 03:30:58 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69fc69e2.a00a0220.387fc1.0008.GAE@google.com>
Subject: [moderation/CI] Re: net: use IP_OUTNOROUTES drop reason
From: syzbot ci <syzbot+ci63ece7baead3f3ed@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] net: use IP_OUTNOROUTES drop reason
https://lore.kernel.org/all/20260507084305.2506115-1-edumazet@google.com
* [PATCH net-next 1/3] net: constify sk_skb_reason_drop() sock parameter
* [PATCH net-next 2/3] tcp: use SKB_DROP_REASON_IP_OUTNOROUTES in tcp_v6_se=
nd_response()
* [PATCH net-next 3/3] ipv6: use SKB_DROP_REASON_IP_OUTNOROUTES in inet6_cs=
k_xmit()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/09300ca9-b086-414e-ae6b-3da15492289e

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      dacf281771a9aed1a723b196120a0de8637910b9
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/61c49dd2-9ca0-4f21-b8c8-33ff9349a8d=
c/config

net/core/drop_monitor.c:1164:32: error: incompatible function pointer types=
 passing 'void (*const)(void *, struct sk_buff *, void *, enum skb_drop_rea=
son, struct sock *)' to parameter of type 'void (*)(void *, struct sk_buff =
*, void *, enum skb_drop_reason, const struct sock *)' [-Wincompatible-func=
tion-pointer-types]
net/core/drop_monitor.c:1179:29: error: incompatible function pointer types=
 passing 'void (*const)(void *, struct sk_buff *, void *, enum skb_drop_rea=
son, struct sock *)' to parameter of type 'void (*)(void *, struct sk_buff =
*, void *, enum skb_drop_reason, const struct sock *)' [-Wincompatible-func=
tion-pointer-types]
net/core/drop_monitor.c:1202:29: error: incompatible function pointer types=
 passing 'void (*const)(void *, struct sk_buff *, void *, enum skb_drop_rea=
son, struct sock *)' to parameter of type 'void (*)(void *, struct sk_buff =
*, void *, enum skb_drop_reason, const struct sock *)' [-Wincompatible-func=
tion-pointer-types]

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
[davem@davemloft.net dsahern@kernel.org edumazet@google.com eric.dumazet@gm=
ail.com horms@kernel.org idosch@nvidia.com kuba@kernel.org kuniyu@google.co=
m ncardwell@google.com netdev@vger.kernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

