Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8405227874F
	for <syzbot@lists.linux.dev>; Mon, 23 Mar 2026 18:08:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774289316; cv=none; b=dWCXyxFx/m3J2H+urdhpk6T7PQVdRKYFM6HRVXv2h6ynUWhQP7GxMjcbhfngoYvxpNzewMDogXLhW6mv/ysqStgC/h7PentXZ8foOco8eKXQ3z8TKy2R942x9XOjTxKGTV0BVxhR6EMvKm7LYJUkDim5CijFHqyPI2IM0MNGt/A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774289316; c=relaxed/simple;
	bh=+QEo/McDBrFhWB0Jk9+xaNtCFdg6ycD/3hHTsK8r3GU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=hAiNZUhfF7+DnPiBFTWZ6cVRdpPYRYsUmk7ambpJvg29KmwKSosQ07XtP0tTyboWRFzl+ehoHGEfULUThrTzSPYp2zZSP3SmeISl19suElAzB5uvg0Xe+WfbfURHedBWQs6n8hAEubyOhK8EyZODDbGui/N+YXkHhTtZIBaK8OA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-67c21b7d5f8so23572031eaf.1
        for <syzbot@lists.linux.dev>; Mon, 23 Mar 2026 11:08:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774289313; x=1774894113;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CORqwilWCnkfSGfsK37CKMmgdLptDivudP2hp6zC+pQ=;
        b=OkJkGuuHB7Au7a8rk+G8/RmM4wptiDLPLwodq4GZRHAwJ2eciUaNtjQZ+aLNisES+V
         LOUfxxPs+rFEQ+zr8Zlr6UIKLwWMJV6egGGhQTJWx7dDIOg8ssMkCiPnC4h02N4xn3Xt
         PQ5B9FOZd/xVFsWgcYm7zMIGRXK+s/homNFLIKBVYmI5UlhZ2Up54o4zK36VWKG34iEo
         BIqZT4MfuZf487TsairK18FperdPh7mGjAK07rqhX0Ax/7iS5+SUsAw/NrhkiQtuNjg4
         kjAZLKQ6fMIDol+KS+9/lmUO7QI/3rvU/9ojiZ1XyGjxBrLpXSkbdGWScgH3ADBCeOUv
         TitQ==
X-Gm-Message-State: AOJu0Ywmt3JbotATSo8qmAeTfLXFFbLIsTEXlPwCaQEmiZmhm8ZBsymI
	j4fT5BoyRFXxDb1B93Jrex92QLeueIe8zWA+PMvDYyKA2U2gsXnYqF15rfaSmqSQwEJ3p6xc5Pb
	TwU8KJW9hxxtJJFjzma0wzScasJaLbPERNLp7gKMLkTnn8L4gbupOfn1wsEM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1691:b0:67d:e140:3451 with SMTP id
 006d021491bc7-67de140377amr5567193eaf.11.1774289313523; Mon, 23 Mar 2026
 11:08:33 -0700 (PDT)
Date: Mon, 23 Mar 2026 11:08:33 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69c181a1.050a0220.3bf4de.00a5.GAE@google.com>
Subject: [moderation/CI] Re: rxrpc: Miscellaneous fixes
From: syzbot ci <syzbot+cif840d2fcd060ac40@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] rxrpc: Miscellaneous fixes
https://lore.kernel.org/all/20260323150505.3513839-1-dhowells@redhat.com
* [PATCH net v2 01/10] rxrpc: Fix key quota calculation for multitoken keys
* [PATCH net v2 02/10] rxrpc: Fix key parsing memleak
* [PATCH net v2 03/10] rxrpc: Fix anonymous key handling
* [PATCH net v2 04/10] list: Move on_list_rcu() to list.h and add on_list()=
 also
* [PATCH net v2 05/10] rxrpc: Fix call removal to use RCU safe deletion
* [PATCH net v2 06/10] rxrpc: Fix RxGK token loading to check bounds
* [PATCH net v2 07/10] rxrpc: Fix use of wrong skb when comparing queued RE=
SP challenge serial
* [PATCH net v2 08/10] rxrpc: Fix rack timer warning to report unexpected m=
ode
* [PATCH net v2 09/10] rxrpc: Fix keyring reference count leak in rxrpc_set=
sockopt()
* [PATCH net v2 10/10] rxrpc: Fix key reference count leak from call->key

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ef91e45d-b5ac-4a0a-b180-1f857d7ece93

***

kernel build error

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net.git
base:      bc0151c59e639c1311ee573434af74b4e2c81de4
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/b2c276be-a7c1-44a8-9c23-40e21255de6=
9/config

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
.com davem@davemloft.net dhowells@redhat.com edumazet@google.com horms@kern=
el.org jaltman@auristor.com john.johansen@canonical.com kuba@kernel.org lin=
ux-afs@lists.infradead.org linux-kernel@vger.kernel.org marc.dionne@auristo=
r.com mathieu.desnoyers@efficios.com netdev@vger.kernel.org pabeni@redhat.c=
om security@1seal.org stable@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

