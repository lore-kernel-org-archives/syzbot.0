Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E81E9347516
	for <syzbot@lists.linux.dev>; Thu, 26 Mar 2026 15:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774538610; cv=none; b=a72FNi/wacJCXAe31K1ZMdQLoTAwcOmRY9LcFQGXQ/uokdaa+VSrguPTV5MwFw+Sd3/GiyaTHD3Qwqg/g/aYEWJ5+eVIQqgFULfWc/+QDmd0VnFJ3oaCxTdkdtCWNL7kU5RTn4qfHGES61ox9xd9nV0LhAmNqvX62miY+vxtzsk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774538610; c=relaxed/simple;
	bh=sDDfySfLcHe2nLaoIFcdW4HtLYNKc5HimJiR7ovAM+U=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=GKFzg3AIz+vD7cUpAV6gg48GzmONwWayBxJGX3s6qq8ZxSflTe0kdxSUvvEjU5HPJj3cNqi2neAQdDpGqRPnNuTIeJyqh69dY07a+44+NbfQPMUiPGATQVw4jDx5x/Qzueqn+O81yAdpPtfU7xl9wKLzhUzxVEAnZN7JBRd6kRw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-67de71f3e6cso1458407eaf.3
        for <syzbot@lists.linux.dev>; Thu, 26 Mar 2026 08:23:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774538608; x=1775143408;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=53IfQtEpVkpTUwHImzhZGyxhROt3Hf1C3WSLREzFHoE=;
        b=LoTfvoFowjHpXryObkNfJUG0lEhMyui/UUqaZIHaZ2Le+/GX1nNfDCUrulaQURydZy
         K+OmTu21Ttlr/M+E9jCUhiIoylwrxcVWfkkTI3SZSgZy0nVQXrf3quQaLV2urOMFwWCS
         LGOg3TL4dkON+CFvFdJRCtRQkopueLXAou5Z+o8Xkm7ISWyDIG7gRq4fqLDDtVQE1cWV
         3130evOmbn4GfG14sJAui6u2+7eZwr8yvoUbqJE07bAyFitTxmHC3a9ghngJFqA629ps
         VZTMGe1z2bfYiPTQgKHYj0LawTPTxWSMn6t72+eSVuyD0SD+afYByOCCa3y5KyiKNrsV
         dd1w==
X-Gm-Message-State: AOJu0YwJ6jVqSqzNpeJo63J5asY0Rp0VyJ5nqhv/uCWosGYOiiWdP6zV
	WJqoNLD32KfDauYuCNUJQHFIqKGmtYW59qacG+1UGZXeaH7Q1z6Jae0mrzJ2sSuIKuXjNHxmS9m
	MoYGzV1RwrGNbLpbMdAnBtpZoB09pKh8InEDoF8W/YI1n+FyE6HKLkUOXPNI=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1746:b0:67c:9f59:23ee with SMTP id
 006d021491bc7-67dff3d0cddmr4018234eaf.14.1774538607889; Thu, 26 Mar 2026
 08:23:27 -0700 (PDT)
Date: Thu, 26 Mar 2026 08:23:27 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c54f6f.050a0220.330c49.0005.GAE@google.com>
Subject: [moderation/CI] Re: rxrpc: Miscellaneous fixes
From: syzbot ci <syzbot+cic2af1ade41d8728d@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v3] rxrpc: Miscellaneous fixes
https://lore.kernel.org/all/20260326131838.634095-1-dhowells@redhat.com
* [PATCH net v3 01/11] rxrpc: Fix key quota calculation for multitoken keys
* [PATCH net v3 02/11] rxrpc: Fix key parsing memleak
* [PATCH net v3 03/11] rxrpc: Fix anonymous key handling
* [PATCH net v3 04/11] list: Move on_list_rcu() to list.h and add on_list()=
 also
* [PATCH net v3 05/11] rxrpc: Fix call removal to use RCU safe deletion
* [PATCH net v3 06/11] rxrpc: Fix RxGK token loading to check bounds
* [PATCH net v3 07/11] rxrpc: Fix use of wrong skb when comparing queued RE=
SP challenge serial
* [PATCH net v3 08/11] rxrpc: Fix rack timer warning to report unexpected m=
ode
* [PATCH net v3 09/11] rxrpc: Fix keyring reference count leak in rxrpc_set=
sockopt()
* [PATCH net v3 10/11] rxrpc: Fix key reference count leak from call->key
* [PATCH net v3 11/11] rxrpc: Fix to request an ack if window is limited

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d0886195-b303-4030-a0d4-bfb5b219c6a2

***

kernel build error

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      c4ea7d8907cf72b259bf70bd8c2e791e1c4ff70f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/ae589f6b-a0f1-44d0-ab85-ab14cf20847=
2/config

fs/jffs2/nodemgmt.c:572:19: error: conflicting types for 'on_list'
fs/jffs2/nodemgmt.c:660:28: error: too many arguments to function call, exp=
ected single argument 'entry', have 2 arguments

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[alok.a.tiwari@oracle.com anderson@allelesecurity.com apparmor@lists.ubuntu=
.com davem@davemloft.net dhowells@redhat.com edumazet@google.com hminas@syn=
opsys.com horms@kernel.org jaltman@auristor.com john.johansen@canonical.com=
 kuba@kernel.org linux-afs@lists.infradead.org linux-kernel@vger.kernel.org=
 linux-usb@vger.kernel.org marc.c.dionne@gmail.com marc.dionne@auristor.com=
 mathieu.desnoyers@efficios.com netdev@vger.kernel.org pabeni@redhat.com se=
curity@1seal.org stable@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

