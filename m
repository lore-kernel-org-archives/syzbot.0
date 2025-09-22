Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F512DAFDA
	for <syzbot@lists.linux.dev>; Mon, 22 Sep 2025 23:08:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758582518; cv=none; b=NHND8IWPGcbUxYiZqbPTE6H8Ro44tb3c5kCPa3D3BUtxVDC+FcneX2hjnFp2OgYuHnfBzGqv9yQMIK81KwiiejETwJlMrxEqHille67T9K/pTj2lctqCDOPZzZiwzK+ZlqH2BcKvWwacfdzYyAz4EHf1Ci1SYadaNTEB+04yYQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758582518; c=relaxed/simple;
	bh=PSnWE4ufHWduyoheQ6vx6rEvi6NcmW7Je4L/xVqPalc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=A057v5Co3mvuUgsg7AX/Rrd14qoTjsJfbDACy/Sj6iQvAaW41oxPqlvgjQ2cK6d99Fw/FQGgvilY5ZRksRO0Reiy3lShj7zxb7k/nDG8ptqCi6vzHmOHKqYUNiKno9ljaHORXRnoeMk8z963o9FwVIRWfR1ZyDOpTg7Y1xIfIxo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-4247d389921so58318125ab.0
        for <syzbot@lists.linux.dev>; Mon, 22 Sep 2025 16:08:36 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758582515; x=1759187315;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=P/NHLz8Ahg0OP6N3XeQCClzVhobsW7m6s9olUpo01o4=;
        b=rhT6JhbX4t7RcYmnV0O5bhHf9z+tCebcwnuCI+HCt2tn98PhwDVb/tip1yBaPlWJ7o
         XFMCDR7AyaDQ/8Pwwvbht+MPrHWiVdAlaWLdef1cSvsVUcIvOdzw0pIYaOUXe/AK3UWX
         0QB3LaR90wgFfJYMyyAkIxgWEDfQmKYrzEsskYSI2pBrhUwSgbUxdxQV94jn3FeXb2rO
         vcC7Un0o2BZSBsDkRDW6t6UhrOWegMQ4SityOhkVyZQacaebSnevJFa+MJrl2lY8NfN0
         snVPHTamDB+6vXNp33/Ao07sBPnRxUcLza1Z9P53vY0+AgZDtGN0NgqjRj4vs/+E6MpL
         /dTw==
X-Gm-Message-State: AOJu0YzVXYAE84/CseUiBKQ1t00u0c1t0UwDy0nUGs9+hfJ5fRqvWJL9
	j4PIPqYLXqlhtKUot/SPiw5tSKaTDvhmG6ivs3HfPty7QcPri/G510O36mGYx1h/BwmGZcfOpXL
	uCzVtSDZnVmexdrGWyik/wmRM4A+6I5tcyjz1IDS+w8Rxco1rTxZL0IfOiRg=
X-Google-Smtp-Source: AGHT+IHFg8NtPwpAHqc+atCfVc5wo+FrKGdpDZS+wkGKNL8OqHklrV8GOR3e04vvKd1TH9/iFVth1/mwQobwv6gBV2Jb47PeErNK
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1542:b0:424:86d:7bb9 with SMTP id
 e9e14a558f8ab-42582209805mr7803105ab.0.1758582515594; Mon, 22 Sep 2025
 16:08:35 -0700 (PDT)
Date: Mon, 22 Sep 2025 16:08:35 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d1d6f3.a70a0220.1b52b.0006.GAE@google.com>
Subject: [moderation/CI] Re: TUN/TAP & vhost_net: netdev queue flow control to
 avoid ptr_ring tail drop
From: syzbot ci <syzbot+ci70ad5aa902a2d029@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v5] TUN/TAP & vhost_net: netdev queue flow control to avoid ptr_ring tail =
drop
https://lore.kernel.org/all/20250922221553.47802-1-simon.schippers@tu-dortm=
und.de
* [PATCH net-next v5 1/8] __ptr_ring_full_next: Returns if ring will be ful=
l after next insertion
* [PATCH net-next v5 2/8] Move the decision of invalidation out of __ptr_ri=
ng_discard_one
* [PATCH net-next v5 3/8] TUN, TAP & vhost_net: Stop netdev queue before re=
aching a full ptr_ring
* [PATCH net-next v5 4/8] TUN & TAP: Wake netdev queue after consuming an e=
ntry
* [PATCH net-next v5 5/8] TUN & TAP: Provide ptr_ring_consume_batched wrapp=
ers for vhost_net
* [PATCH net-next v5 6/8] TUN & TAP: Provide ptr_ring_unconsume wrappers fo=
r vhost_net
* [PATCH net-next v5 7/8] TUN & TAP: Methods to determine whether file is T=
UN/TAP for vhost_net
* [PATCH net-next v5 8/8] vhost_net: Replace rx_ring with calls of TUN/TAP =
wrappers

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/98c840f1-64e9-4a8b-8295-1b659c3e44b8

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      315f423be0d1ebe720d8fd4fa6bed68586b13d34
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/48a2870a-cee0-4520-88c3-d0c38ba25fb=
e/config

drivers/vhost/net.c:197:3: error: expected expression

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[eperezma@redhat.com jasowang@redhat.com kvm@vger.kernel.org leiyang@redhat=
.com linux-kernel@vger.kernel.org mst@redhat.com netdev@vger.kernel.org sim=
on.schippers@tu-dortmund.de stephen@networkplumber.org tim.gebauer@tu-dortm=
und.de virtualization@lists.linux.dev willemdebruijn.kernel@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

