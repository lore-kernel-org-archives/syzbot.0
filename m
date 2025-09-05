Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E11C1367
	for <syzbot@lists.linux.dev>; Fri,  5 Sep 2025 03:32:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757043139; cv=none; b=EGzDx0WcKVBT14OTBvReUX6wsCQF68IW29D9ojh7y7V1J7hEg3zMXjEnm6bBvAcZ9Phpc/AvBXt895e1mV1+8De4hvHud2KNq8nsB65EDPYfKmgVaobNlsxYuFd6Fgzgq+MUSXeTVyjCnZCd0g2HqzJqeTugki6Yfj4oiaBYzoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757043139; c=relaxed/simple;
	bh=7ifUCiDV4SXifUMzljqhBVdKwiA2SK9D6vC1G2Z1xJA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=F89ECiVbyKh98B4HIi3WIg6v3Hb2WXMMjx6jXISqwKGhL+klo8DMPFgCrN3yjhGWoSaJiFSsdI0HV472a7IRjI1H28gvFZc0VEYj+7+tYn/OuQA0DbTI33foDnPYhGMsKTtD635ZJU8DFQITCCTJBQ907/xSCNO2HxD6aW1cbxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-887303f3030so461486439f.0
        for <syzbot@lists.linux.dev>; Thu, 04 Sep 2025 20:32:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757043136; x=1757647936;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=QLeIcFhIozhqd1UjB9HI03Pr1lK3gDIT43sNUzeijxA=;
        b=RFewj0aywr7GYaNp4TZQHbFs76nqmRqjvT0qdH4ExPX1JZFYkDq/eIMmwwPWQdGU7h
         gnWarTWlvnVO6lSLS5klGNY7A8gfbLHtyYpGAou+rEbrCm2eIo/qbYFJiKaRh5qBlRCv
         AkhHOhMxzDZpwknUp49bvpFk9lldKBO5qggg4oRLcXkbL3obYt0PsP06MUcICNffa52e
         VcRKqYmEq0AveBMt6Dk3iiT94Ii3ovPhcmuFnnbxh9qNaVsXc0jdMSeosVvjO26yv4nf
         og0x6IUrSkA/3xnEqNDM4JHB9Dl04KVf3pgdlm2Z7mTbfz0DaxaKu56/tFWq07LFkaUY
         NVhQ==
X-Gm-Message-State: AOJu0Yz+c5+A+30tbHfu1MIimhW2Rd3Bd8lx6LX8X4uKP5K67TwNTlSD
	s8JJgxytwUa49RnUFXbKfazZ6pyytMOHFI++OyAy4Pizf9QAi6ahetx9eTXGOBmo8N1rURX6rgp
	zg0VzI7P/KVzyw3jMMn0CNxuK34jGBtDgyGhCqPrw2TvrMLw4jvxGJEXtlJ4=
X-Google-Smtp-Source: AGHT+IHBqpv0BObw0zg7S+DtIsbI+aVuAznK6IXi+8yGBB5MJq4sJ7er52/Xqubx6+SQcAUsWiSOvXy261qbfioEsgh/Lbz3671X
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6602:150e:b0:887:48b8:fe74 with SMTP id
 ca18e2360f4ac-88748b903famr1794478439f.17.1757043136647; Thu, 04 Sep 2025
 20:32:16 -0700 (PDT)
Date: Thu, 04 Sep 2025 20:32:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ba59c0.050a0220.192772.014f.GAE@google.com>
Subject: [moderation/CI] Re: nvme-tcp: Support receiving KeyUpdate requests
From: syzbot ci <syzbot+ci672dd867b4c4962f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] nvme-tcp: Support receiving KeyUpdate requests
https://lore.kernel.org/all/20250905024659.811386-1-alistair.francis@wdc.co=
m
* [PATCH v2 1/7] net/handshake: Store the key serial number on completion
* [PATCH v2 2/7] net/handshake: Make handshake_req_cancel public
* [PATCH v2 3/7] net/handshake: Expose handshake_sk_destruct_req publically
* [PATCH v2 4/7] nvmet: Expose nvmet_stop_keep_alive_timer publically
* [PATCH v2 5/7] net/handshake: Support KeyUpdate message types
* [PATCH v2 6/7] nvme-tcp: Support KeyUpdate
* [PATCH v2 7/7] nvmet-tcp: Support KeyUpdate

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/6694796a-7c2c-4ef5-9055-cfff28bfd37b

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      5ef04a7b068cbb828eba226aacb42f880f7924d7
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/bf592b7e-e4da-4707-b710-d85d73fcfce=
e/config

drivers/nvme/target/tcp.c:1479:5: error: call to undeclared function 'updat=
e_tls_keys'; ISO C99 and later do not support implicit function declaration=
s [-Wimplicit-function-declaration]
drivers/nvme/target/tcp.c:1489:5: error: call to undeclared function 'updat=
e_tls_keys'; ISO C99 and later do not support implicit function declaration=
s [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[alistair.francis@wdc.com alistair23@gmail.com axboe@kernel.dk chuck.lever@=
oracle.com hare@kernel.org hch@lst.de kbusch@kernel.org kch@nvidia.com kern=
el-tls-handshake@lists.linux.dev linux-doc@vger.kernel.org linux-kernel@vge=
r.kernel.org linux-nfs@vger.kernel.org linux-nvme@lists.infradead.org netde=
v@vger.kernel.org sagi@grimberg.me]

If the report looks fine to you, reply with:
#syz upstream

