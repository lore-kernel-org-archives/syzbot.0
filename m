Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FFED332ED3
	for <syzbot@lists.linux.dev>; Thu,  6 Nov 2025 20:37:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762461443; cv=none; b=WwPpvVD/etARgz4cnAN4KALM1knCffKxGxuLD015VCsyOpgOWvvijzGQ494Y3UCKZzwdr0sY0nHWOEgziMXAyEFGMcvMD/x1hqQmiPnIPa2tmAdc0bCEYCz+Y6WoXh0MJ7nW+bq4skD9MVRRFwas6RbTiNT+qFtQS16QPhVBPWw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762461443; c=relaxed/simple;
	bh=hi/LTBgiB/Ti1fjgEW4q4j60TqM2SC5U0NWpIMh6b5A=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=O87i/ndpBpd+4GPAzaM0Q8hTRJudYdz18RCbftG6BqsJHIQvjBKQ73yTMUccBbSxzzewfSj1Pp5UMFHM2F8q+B0SBkg044JJy9WGc1S8l+8AE4X2AjBILnIvpAhoKXDnCpHi/9glGh+2hOLzppEZPp6HLlaZqN98xFlI9d+MfFc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-940e4cf730aso12140539f.1
        for <syzbot@lists.linux.dev>; Thu, 06 Nov 2025 12:37:21 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762461441; x=1763066241;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=eOth0/BdBK/YTWTrtUS5AVlgMZuZ9KcyYTMqeS3lb5M=;
        b=wpltuVnARUtajXPJCqn+ZFANYrUw7mxmgQo86KakTmPZI3sRvs/zM4T8QxUrf8KGqI
         yzjbFdaO+z6E+g/oWWvEyAC2ZVER1yQCqkvB4LM5fYH9PcUPgBnhwdd+qLUfedRn+dH9
         JLlXrrEpR3G892y6vuGn2qeIokwIECE2bxPFBq0GDc8BYS6xzeHXjB6oNGHk0MR0OWVV
         d5LYs3ugvVQv4ZPV3A7KdhRp44Xr5vHIvXmr9jwncwVI5krIuM1+rSMB+OhS4elBkW8t
         +aXtSohPHqKHEO70j6mmLX4cfWf0IhCcZQXLIqVdzKfp9lBi0xAqLCRS6OnBMFdvFVc8
         A9OQ==
X-Gm-Message-State: AOJu0YwrUTDumUEZfV/F07IdLUX6XthI3F5/oifFMS9k7kOYeNytDcDm
	1ceudaofNBMEM8KAg9jjjjbnv1vQOX1tnXx1kVYA8+IEjI9lZOjCruEEgAJRScqh2rqG8eEY4sk
	fHPsVx5YQNJft7v/KgtgqErpoZ4dtkii8JEs9cR7YZ57XVffFEic4jv400qM=
X-Google-Smtp-Source: AGHT+IEaSzaUuilRw0oYM/MP+HEa4oJRR8Ts5GoPNI9RzIOg2MY0jkDaKfw9CHATMwyXFj/AGCCNRFoP5YthlezH7fApyH7CaPT2
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:6c19:b0:943:5917:b6fb with SMTP id
 ca18e2360f4ac-94888bea4ebmr129398239f.0.1762461441349; Thu, 06 Nov 2025
 12:37:21 -0800 (PST)
Date: Thu, 06 Nov 2025 12:37:21 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <690d0701.a70a0220.22f260.0009.GAE@google.com>
Subject: [moderation/CI] Re: net: sched: initialize struct tc_ife to fix kernel-infoleak
From: syzbot ci <syzbot+ci2ff4f7ab3081ef1b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] net: sched: initialize struct tc_ife to fix kernel-infoleak
https://lore.kernel.org/all/20251106195635.2438-1-vnranganath.20@gmail.com
* [PATCH v3 1/2] net: sched: act_connmark: initialize struct tc_ife to fix =
kernel leak
* [PATCH v3 2/2] net: sched: act_ife: initialize struct tc_ife to fix KMSAN=
 kernel-infoleak

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/f3c7f46d-8212-4324-a799-61641305db5c

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      89aec171d9d1ab168e43fcf9754b82e4c0aef9b9
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/975a8113-dd10-45cb-8ada-7546faa4260=
e/config

net/sched/act_connmark.c:203:2: error: call to undeclared library function =
'index' with type 'char *(const char *, int)'; ISO C99 and later do not sup=
port implicit function declarations [-Wimplicit-function-declaration]
net/sched/act_connmark.c:203:10: error: non-object type 'char *(const char =
*, int)' is not assignable
net/sched/act_connmark.c:204:2: error: use of undeclared identifier 'refcnt=
'
net/sched/act_connmark.c:205:2: error: use of undeclared identifier 'bindcn=
t'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[davem@davemloft.net david.hunter.linux@gmail.com edumazet@google.com horms=
@kernel.org jhs@mojatatu.com jiri@resnulli.us khalid@kernel.org kuba@kernel=
.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com =
skhan@linuxfoundation.org syzbot@syzkaller.appspotmail.com vnranganath.20@g=
mail.com xiyou.wangcong@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

