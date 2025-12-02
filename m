Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB84A2367D5
	for <syzbot@lists.linux.dev>; Tue,  2 Dec 2025 16:13:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764692025; cv=none; b=fZ5MNVaO5ImNhHyMtzuN8NStZgxWdS6MVweQxjPiuLbivO/F9q24M8bgqzeu+b/nh5O0rJLd82GOPHv2g+yfw+/ZGtpRH0/+ylEbXa383K+h7kB18X93hGL65PxHWh6UDjdorIvGvtM5TsJOWQIQXflwZJtYNuqPJ1Bj3VrQhIM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764692025; c=relaxed/simple;
	bh=TFSaHEK3uI5AaX+6jyJfjPnOlZRHQNiWRr84V6vLRw0=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Uy4GjjX26yXO972deVPVai+3pzdY0bN3LZ3HIwpuZAKzV3+kWlU5BrzG1L36wWZnFdUdWgoBbG/F+YKCxau0U3cu8/lgfCGfl8ZXJGNf8+65E+7v1bVZEtsh/ZZeiysXAeqrXOTE2x7XKYypiz9sDQxrV0pCgSi08rdHm/Biae4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-450c16f2bc1so5218204b6e.3
        for <syzbot@lists.linux.dev>; Tue, 02 Dec 2025 08:13:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764692023; x=1765296823;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=MRpcKJXgucXsI4QrIGlqGHX5RMCSfVrlV6khHJ0ZnWA=;
        b=lWFsg/ryRTOpBVq993t1o7gUaMGLNKnSkgBvY4+wjhGVULMzt2iszelIjyXpQhboQ+
         01D8YhwR9olbF9EclZGNXTjfGICJzXxqLmKIbdQPZY42/yq0KHiuvk5Dzh5jSLKSZfD0
         EMJBiK7879kV3xgkx/xvBT1PkdfFTxbklgMO0U3OHIp1S3HO4C3dgLo1EFlmtRv/xIL9
         4FuBGDOaAg/ERKDiT4kAX7Px7Vpljti4Zrv8eIadxl373Sroa8q5Q+xI941ntWuH1xDU
         8YxTfDRkH/7zE6MaaG16WMVVIO7nP5iWja7n2i/ITCvDBxL34yttV/bht2vCihENQreE
         F8cA==
X-Gm-Message-State: AOJu0Yx/cvyu/PZmTe0xJwJf08LoCtMUJ61uMpXXT807ge+CHU/JSUj2
	bEa8w843ZP+L0+xhqUbuJZO8VxBJOtbFz8YOlgOMrqxZiBnismcy+rhT33ARKJep/sUHNBW9P13
	fVz5jqsqjh8W54Asl5LMxoLRY90mDlJ+g2W2YhirvdNQvGbe0rUFTc4VJdXc=
X-Google-Smtp-Source: AGHT+IHkIGAovr+pGIZYl2DqpQhgjQlC+apgrb+tn+1z3laj5OHO7W9G6djDUYKM3n+xWjghm7xL2BSPOLftxe3pIbRflPDw/6NF
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:6787:b0:450:cdc3:7a0f with SMTP id
 5614622812f47-45112bde919mr20404228b6e.57.1764692022944; Tue, 02 Dec 2025
 08:13:42 -0800 (PST)
Date: Tue, 02 Dec 2025 08:13:42 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <692f1036.a70a0220.d98e3.019e.GAE@google.com>
Subject: [moderation/CI] Re: configfs: enable kernel-space item registration
From: syzbot ci <syzbot+cibc074c2fc4a0e4e4@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] configfs: enable kernel-space item registration
https://lore.kernel.org/all/20251202-configfs_netcon-v1-0-b4738ead8ee8@debi=
an.org
* [PATCH RFC 1/2] configfs: add kernel-space item registration API
* [PATCH RFC 2/2] netconsole: Plug to dynamic configfs item

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d96d193b-5349-4f30-be4c-b8950ecce808

***

kernel build error

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      779bcdd4b9ae6566f309043c53c946e8ac0015fd
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/bdd14175-68c7-4ea2-8a84-b64131d9050=
b/config

drivers/net/netconsole.c:231:1: error: non-void function does not return a =
value [-Werror,-Wreturn-type]
drivers/net/netconsole.c:1892:10: error: no member named 'group' in 'struct=
 netconsole_target'
drivers/net/netconsole.c:1893:33: error: no member named 'group' in 'struct=
 netconsole_target'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[a.hindborg@kernel.org andrew@lunn.ch asantostc@gmail.com calvin@wbinvd.org=
 davem@davemloft.net edumazet@google.com gustavold@gmail.com hch@infradead.=
org jlbec@evilplan.org kernel-team@meta.com kuba@kernel.org leitao@debian.o=
rg linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org netdev@vger.k=
ernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

