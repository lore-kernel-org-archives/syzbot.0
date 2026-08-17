Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDC7B439F98
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 13:42:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974127; cv=pass; b=CsTvXx4aGyvla+1ngFY4IUIN1v3szAEAfsAC6hdRHyrzsFIol9ksqqjipHAh4LbZIQlM8LZpErtbqdjH2BTl6/XuXpC3Exn54wrHoAXcfy0LbtmI3iqwobgxvwiNrlLNp/96UqjweAPmAqYkjLy5UZLmJ7wRV2LT8bruFdez5w0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974127; c=relaxed/simple;
	bh=aX6C4I6qSjoQMxeJ+OPzLeCTstwwhUCCr4q0NmAXO+4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:
	 Content-Type; b=MstnJPoFZfwY2kvwT54UUGeV+6IaXaFc5K72HttNNpZ/5ZXMYc5V7Ik4MqkeSz9oaO8KhWGIYrpEILJry5q2oOGqAK+HZDJKVfubeGx1n+moBv9/RQusTRp17SVGpoLqQizlj+iM+epVKamErIEYMF4fuKxhQAn+V2uvmP1GUc8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
Received: by smtp.kernel.org (Postfix)
	id 362DD1F00A3A; Mon, 17 Aug 2026 13:42:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.161.69
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786974125;
	b=tU0AdxQ+prMJenYpNFRnG4VdR00PaX2+fAMfckwXpfXfYFqk8lW8Ap7jbN+HvhFWQi/S
	 nv6XAYUsy2GZ5zzXGHgguWtcOmuMolIOOwBDzNR4bC0123NzuC8A8Q9+R09Zmq0z0Wq8d
	 ZP8uA6t80g/VgMGMmY1f/nAeJ52Jotea9AqTJYW2dwyOMStOPgpw8HdSFT/YN2t09x1fM
	 W6H+ZdUdA06yf3G51QtQhdXl2uzRBLviBOMQlT0h8zwT6yerhRlaSZc26k6RCAHM80awu
	 TsbjlY7/HhJiVjtd4JR0t3M6uxYWnScD+1x+KS+ruzOcigz1pPoTKqhDn5Smo5HPmTg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786974125;
	h=DMARC-Filter:Received:X-Google-DKIM-Signature:X-Forwarded-Encrypted:
	 X-Gm-Message-State:MIME-Version:X-Received:Date:In-Reply-To:
	 X-Google-Appengine-App-Id:X-Google-Appengine-App-Id-Alias:Message-ID:
	 Subject:From:To:Content-Type;
	bh=6OqqhA80wtcU3IsPjUZveXdR6cUhDI1A/Qh9dqHqO8Q=;
	b=WGbfzQVxN5SHcalx6y03aIFvSKI67nOvoaVDIl5LBKlInVBqk2v6wXH3+XhMOR1Jc/u8
	 QLWFBpuf/E9iR+z96LIVMe5kHGWRtHyG041kfUhVZD/YSl3zdtsf4yXt1ky+VZzKfbuRU
	 XmJAQvf8qrZA9tH8/9d8Tz0bC7rYgpLz3z6+qlXUHVjaHLdhZY2mWqCzaBP52DKNem7OM
	 acV/LsFNUYrJkvZp1TS2Hyyvu7gLZRNzdLFo6DQDhzdmQG6XnBtLq3tiUaPKKw9lnqZtV
	 J+TyTIjwc1p+OJy83qnjcL5/nYiV56doYL9ziwT6sfk+RqlKxZEPgjM/prcpJ/WfaPg==
ARC-Authentication-Results: i=1; smtp.kernel.org; dmarc=fail header.from=syzkaller.appspotmail.com;
	spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com;
	arc=none smtp.remote-ip=209.85.161.69
Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 422231F00A3E
	for <syzbot@kernel.org>; Mon, 17 Aug 2026 13:42:04 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 422231F00A3E
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6acac05f082so1288873eaf.3
        for <syzbot@kernel.org>; Mon, 17 Aug 2026 06:42:04 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786974123; x=1787578923;
        h=content-type:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=6OqqhA80wtcU3IsPjUZveXdR6cUhDI1A/Qh9dqHqO8Q=;
        b=Knt2x1ZRQ1eDHlEB/85dqF2DQXE9AuNR1EBZswbwYtWU3bOFhrwpF9mNxcuuCM8qJX
         yOHB0B5Qnzhq6FKmYxvhlEisNW6MXaffHieqGEPlgRbNvNgFB7bYxBQNhtaH63Lrh51B
         smunYG5AcIYnkFGV55AB1IgrMXITrMipXmtOJAXXHc3p5FOJ75JxPJSClgAPkfoQOvA3
         /eepQFsqhgupEwHOFrMS0521Q9SyrdauxbQa62ANzzyxsLkHnJjjw5Yk1ItztAKBHEm8
         hnJ+z3ACXu8X6sEEt7GGHwVk8NWDaxNauR+i2+u8TDsU+1IJDJQ9iO6tf5aHtrwOVRNm
         m7pw==
X-Forwarded-Encrypted: i=1; AHgh+Rp164qRFfnMSp9Q/pWtgC0mxiIvsVvhBlogXgjkm3wGmTipAUqM3t4eirVHQV3k2kvhraduUPI=@kernel.org
X-Gm-Message-State: AOJu0YxTzhDuicR8PXaGZACA6janqhPvlmVDGeRxyP+lH1TnuUt9ruZR
	8O9nenYout89saa1YJK4TuAUJ1OC1Nqg6sQ2kPaGhAbYs0dnrP0205pmAqBHEE297zc7ZWYd2ZB
	ApxMSUYV2FFcIKRUB7Pf9NxrieQzLfibCDZnFJb5dFWXA8eVNMRGNalZ1atg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:f07:b0:6ae:55f6:2cdb with SMTP id
 006d021491bc7-6b0d5fca98bmr22016036eaf.1.1786974123322; Mon, 17 Aug 2026
 06:42:03 -0700 (PDT)
Date: Mon, 17 Aug 2026 06:42:03 -0700
In-Reply-To: <6a6bfa43.1b55b669.19788.0016.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a830fab.dbb3a75c.20434b.005d.GAE@google.com>
Subject: Re: [syzbot] [usb?] KASAN: slab-use-after-free Read in ep_open
From: syzbot <syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com>
To: asml.silence@gmail.com, axboe@kernel.dk, brauner@kernel.org, 
	gregkh@linuxfoundation.org, io-uring@vger.kernel.org, jack@suse.cz, 
	kartikey406@gmail.com, kees@kernel.org, linux-kernel@vger.kernel.org, 
	linux-usb@vger.kernel.org, mjguzik@gmail.com, nogikh@google.com, 
	stern@rowland.harvard.edu, syzbot@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com, 
	syzkaller-upstream-moderation@googlegroups.com, torvalds@ppc970.osdl.org, 
	viro@zeniv.linux.org.uk
Content-Type: text/plain; charset="UTF-8"

syzbot has bisected this issue to:

commit aa00f67adc2c0d6439f81b5a81ff181377c47a7e
Author: Jens Axboe <axboe@kernel.dk>
Date:   Tue Oct 22 19:47:00 2024 +0000

    io_uring: add support for fixed wait regions

bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10e60679580000
start commit:   9a143525f62b Merge tag 'ata-7.2-rc7' of git://git.kernel.o..
git tree:       upstream
final oops:     https://syzkaller.appspot.com/x/report.txt?x=12e60679580000
console output: https://syzkaller.appspot.com/x/log.txt?x=14e60679580000
kernel config:  https://syzkaller.appspot.com/x/.config?x=c44651ea7dd2f307
dashboard link: https://syzkaller.appspot.com/bug?extid=df9e891bf8ea586f846b
syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=120defb9580000
C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16323fb9580000

Reported-by: syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com
Fixes: aa00f67adc2c ("io_uring: add support for fixed wait regions")

For information about bisection process see: https://goo.gl/tpsmEJ#bisection
