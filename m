Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C419A3FE34C
	for <syzbot@lists.linux.dev>; Wed, 29 Apr 2026 17:28:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777483700; cv=none; b=cwxAq28z9I1skOEuX4soUaOcbYSr0fV6zUldhhP+SJrqMJAmvFjJw4xdOMIBjRi7iicZS5FWeQoeqywqNDNiWAJdx9nl9QzsXRJla6R1mXOBG3NMfqYsyFqpLWeeeOqdkOKDHVWDmPIIQa2hU/U93vsLW3T8nu5KdESDGyruDaY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777483700; c=relaxed/simple;
	bh=p09ID3gHyK9/giJ3Wb9bzduioGYS1m/zq7eK4f9LEfg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=OikdLV7T7dp01u7/OsHUiJa2ahVP7lBA5+2dduscjZg+xu8bMwQyp4W34Khtsql9OHcZPBGQWGTUrqy0HTywJenzI4VyNW25KKJgRyE4Vp+nmYMRYWW5id2mBw5T6H1IAV+6hj/fYZ8Es1M+uD9P+aGLKYghnIf5xchNfhcHWVs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-69644bda339so1900483eaf.1
        for <syzbot@lists.linux.dev>; Wed, 29 Apr 2026 10:28:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777483698; x=1778088498;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=1jJw9yzX37AnP0hLYTjqanEzQOJ7uU5Rq/+0B90qXY0=;
        b=qRpRl6Jj4RSzdvO/9uvtm4p2r8tZkBOir5Kd8rQGfWNHV+ZN/L/w/CzhOBctTIbRt2
         XLan046IP4lX3mBepHau0Z6jQi+/VrxdyY8NpU4AwcnOwV456Vcef90QuMOUjXIYjVI0
         yBCVFLOkpd5tL0/ozt1o5JaJcQ/bpDnEw2Vs7uLpfKep+8pq7egzJ7L58a30cGSQYxjb
         sw5tggIdZYRdbqS7a8F37N5etWMdJGvtMLq+U+e3bksiPoAD739UgN3sIfgtpYtxDu8s
         r+cFwBzdDgIU+z8KY6tBpiuD6oFu4JIcOaX5a9n81csDw100G4028NG5QXmmZZ0K0gK2
         jFqg==
X-Gm-Message-State: AOJu0YxMhx1aRl/a+U1ctwTRSq3SXLxkuBLfBtbWSrBUmUkup+70f9yU
	RYNiRKeIwIvumI4YaE3uAw27BGk/tpQYxosD+ANgabQWQJj/6twz1kdgs9TMDD+zkU4MmRhbzGR
	PiqUt+n7X8iO++g1Jh1qWMJeT2cKne+CpSBzVRTAJTlAo0XV+qf+cfPrRwiI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1c8d:b0:696:537d:cda0 with SMTP id
 006d021491bc7-6966a49f5b2mr1683825eaf.24.1777483697707; Wed, 29 Apr 2026
 10:28:17 -0700 (PDT)
Date: Wed, 29 Apr 2026 10:28:17 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69f23fb1.170a0220.3c4978.0004.GAE@google.com>
Subject: [moderation/CI] Re: block/blk-iolatency: Add the processing flow of
 the chained bio in the QoS and define the related types to solve the problem
 of incorrect inflight processing in the QoS. The usage of the done_split_bio
 abstract function in the blk-iolatency project.
From: syzbot ci <syzbot+cibbb07ad7a6050819@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] block/blk-iolatency: Add the processing flow of the chained bio in the=
 QoS and define the related types to solve the problem of incorrect infligh=
t processing in the QoS. The usage of the done_split_bio abstract function =
in the blk-iolatency project.
https://lore.kernel.org/all/20260429092920.2124-1-likunyu10@163.com
* [PATCH] block/blk-iolatency: Add the processing flow of the chained bio i=
n the QoS and define the related types to solve the problem of incorrect in=
flight processing in the QoS. The usage of the done_split_bio abstract func=
tion in the blk-iolatency project.

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/474bcd69-fcd8-4d11-8fac-7e4e3f54320d

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      dca922e019dd758b4c1b4bec8f1d509efddeaab4
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/f6f723b5-fdf3-4c98-86fd-8ea7c49b5bb=
c/config

block/blk-merge.c:159:17: error: use of undeclared identifier 'split'
block/blk-merge.c:168:1: error: function definition is not allowed here
block/blk-merge.c:203:1: error: function definition is not allowed here
block/blk-merge.c:216:1: error: function definition is not allowed here
block/blk-merge.c:237:1: error: function definition is not allowed here
block/blk-merge.c:291:1: error: function definition is not allowed here
block/blk-merge.c:316:1: error: function definition is not allowed here
block/blk-merge.c:324:1: error: function definition is not allowed here
block/blk-merge.c:343:1: error: function definition is not allowed here
block/blk-merge.c:429:1: error: function definition is not allowed here
block/blk-merge.c:444:1: error: function definition is not allowed here
block/blk-merge.c:456:1: error: function definition is not allowed here
block/blk-merge.c:486:1: error: function definition is not allowed here
block/blk-merge.c:494:1: error: function definition is not allowed here
block/blk-merge.c:528:1: error: function definition is not allowed here
block/blk-merge.c:550:1: error: function definition is not allowed here
block/blk-merge.c:580:1: error: function definition is not allowed here
block/blk-merge.c:599:1: error: function definition is not allowed here
block/blk-merge.c:618:1: error: function definition is not allowed here

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
[axboe@kernel.dk josef@toxicpanda.com likunyu10@163.com linux-block@vger.ke=
rnel.org linux-kernel@vger.kernel.org tj@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

