Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10E8B306B00
	for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 12:07:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762776433; cv=none; b=rUphX6Ti+IfpYb/DKsWvbcBhIGibZy96Ms1ZHT4G+hgFh+XsOMRwKC+h27HNRwwUSJaZXGYAmbgMRbFePPuy1EZBCfLniWa+BLc3RTheMnTLD/3fmpMWLoYLD9XE/OOYFY6+9dc6DZO0NoWvIgQh/wiVSr3oS9dQ7oQG7hMDhEo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762776433; c=relaxed/simple;
	bh=f1isJjbdOi7UBhv5oPxY52aVC6ShwFF480v44hmBNkA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ZxU8YbpItqboCB88veOcW6eW7wGfeLeKEIpKL23XMij1x3NjqEEdQWkHeNeoaWxFMdcs5ytmgN5skBhy5HpKRsDnjAo6lgj9NeiwgA2/S9KQur2lJKcoV3+Z42EbqBTc7R+1IN4fOgG/XawPpZKyGMg1Mu0y+XnY6+7XxrQTls0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-9488163e81cso214280639f.1
        for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 04:07:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762776431; x=1763381231;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=5wo650Z7zDyGAFym5Tu3imY4NIyPbaeMzjwUHxQxWOA=;
        b=S9SH1rVqquW8xvrS8Tl2+632CYg1o+bboXe/jDccb530zruUcmHOSBLdsDe9Q8b8/J
         qCXacW6SSDwG41kBFKv8JLtpYhToFo6rcbQKMt/Lq8NcZbX4EoPqT1CAmNXw1sSHdbzf
         Fqqrkr/VT65+XBKwXmHXUcmNoh5uURTdQ/U30YBtTfmFGzisMlyP/0JXBP8Ap//f7vLQ
         Ik/Pr/z/Yf5dKDYDfN0EwPzBnRpkI4fjbcTxtu7M4cQOoEJ7sP4wK8TnGGoxFbLBoVza
         d9j0oCMA3Rbl1H358+tVXj01Is6FdLIllzWI55Ygw76dn+VXtw/OxkF4QJwjll8ZRYce
         URhw==
X-Gm-Message-State: AOJu0YwmD0SDRoyuBFd3hXG8sZPQyRzRDfQvNBN/4sUi5IOPGAEq0DSq
	8rM6DATiyU8T4lqKNPsFMc/5I/5FKBZDUzUdXLafp8cEqPqxI7DpxQ6OQEuK3UthFMyxG9CN1EI
	G/l0AeyVvfe3R3dRfOK8GQkZLQPhNWbk6jolSFhfLht2k/FjXJKm2F9jLfYg=
X-Google-Smtp-Source: AGHT+IHqV+GXu6Zh1JBjB+/6DztBh+PCCO9gGo07NqjK98A6VPC9VRYAA/6bC7tq47ZFE9layG/rxz6g+X7wo/jTlkL+i/bGUqmD
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1fc2:b0:433:810c:db1 with SMTP id
 e9e14a558f8ab-433810c0f06mr34580945ab.20.1762776431073; Mon, 10 Nov 2025
 04:07:11 -0800 (PST)
Date: Mon, 10 Nov 2025 04:07:11 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6911d56f.a70a0220.22f260.00e9.GAE@google.com>
Subject: [moderation/CI] Re: net_sched: speedup qdisc dequeue
From: syzbot ci <syzbot+ci59afec552e230f04@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] net_sched: speedup qdisc dequeue
https://lore.kernel.org/all/20251110094505.3335073-1-edumazet@google.com
* [PATCH net-next 01/10] net_sched: make room for (struct qdisc_skb_cb)->pkt_segs
* [PATCH net-next 02/10] net: init shinfo->gso_segs from qdisc_pkt_len_init()
* [PATCH net-next 03/10] net_sched: initialize qdisc_skb_cb(skb)->pkt_segs in qdisc_pkt_len_init()
* [PATCH net-next 04/10] net_sched: use qdisc_skb_cb(skb)->pkt_segs in bstats_update()
* [PATCH net-next 05/10] net_sched: cake: use qdisc_pkt_segs()
* [PATCH net-next 06/10] net_sched: add Qdisc_read_mostly and Qdisc_write groups
* [PATCH net-next 07/10] net_sched: sch_fq: move qdisc_bstats_update() to fq_dequeue_skb()
* [PATCH net-next 08/10] net_sched: sch_fq: prefetch one skb ahead in dequeue()
* [PATCH net-next 09/10] net: prefech skb->priority in __dev_xmit_skb()
* [PATCH net-next 10/10] net: annotate a data-race in __dev_xmit_skb()

and found the following issue:
SYZFATAL: image testing failed w/o kernel bug

Full report is available here:
https://ci.syzbot.org/series/9f1aa15c-e105-4bd7-9d5d-01e285bfc604

***

SYZFATAL: image testing failed w/o kernel bug

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      6fc33710cd6c55397e606eeb544bdf56ee87aae5
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/7291378b-49fb-4682-a92a-e8558110d42b/config



***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[davem@davemloft.net edumazet@google.com eric.dumazet@gmail.com horms@kernel.org jhs@mojatatu.com jiri@resnulli.us kuba@kernel.org kuniyu@google.com netdev@vger.kernel.org pabeni@redhat.com toke@redhat.com willemb@google.com xiyou.wangcong@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

