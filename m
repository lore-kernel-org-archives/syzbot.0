Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3ACA3A5E75
	for <syzbot@lists.linux.dev>; Fri, 22 May 2026 05:54:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779429287; cv=none; b=fz1+hsxkUwTeao6osIRcyTc6PkKyGxYCtojI3WkOcuYDbUF6tMyXgzKEdneP2eXYWQWsLD/VaOfgcQJWgjz7cOlUDXNjgx5OfaqMFpmN306TFGiwjt2uBMIPE1L2YcZm3qa5LE3R6xDYato0Z6mj25EA1zDhyJFEbNQ034P/PXM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779429287; c=relaxed/simple;
	bh=J5C3MckAuOrIQlL9VxyScTqSAdO4m0jepCApHJsmqPU=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=fmtufpXuAOs8qNNY3/skdD6Dq0ay/tm8ayC7X3CRu10XO8MLdFSczNYi5rDGaZXGGumr+0WwASauk7ZoJgZYDx4DANmV6FWnr/U1TyoSI+XVnj6zqU0VEWyO9ZEmVpc98ERl0p+ik29U2f52h1kYLUTzCu7MxIIKIAISwbn0yD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-69d874805edso183510eaf.0
        for <syzbot@lists.linux.dev>; Thu, 21 May 2026 22:54:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779429285; x=1780034085;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8pMtKxZ/J59Du1NZKBmcRrYVYpeQFwP4pRJEdGQyfmo=;
        b=LwPYR+G02xsTLNyyduGEGX4ui3fQ4abyRI7khmn972EFfKWdyMKU/w636NQDa+qi3U
         yUgAle6AQZOaI+wWfqc5WBahQQ1/XAUKSwk8Lx0pzys65lfLkX0muYL12OKfTf3kJVHv
         v/t12DN8MIHfu3ElrFyjSrpdnpFprIyWWJqP+q+8K2skgrEN2nvMPpa6aRorWoEY7l7w
         HsKPv1GF3wFiFckXcf+mKP5os7U1G96Few0/EkHWrocTiNQAO6kE4EVY6vG0CmEVTYZE
         FTUCPNOhFfiQNNOiI8Y7gRaVtw1euqfGUtqfdoo3SLYnpAlynNrMYMMOW+zxjCOpCGjX
         YNcg==
X-Gm-Message-State: AOJu0Yy0AtsIMz0YO4FNyf8nMaFARaS0wPAeNJA7VY8z+IX++vD6r/oU
	9svkzPNGGXp7TY/2lyaRk0zjMyeIZ+f1dsSJMuCO6hjLFZBd5jPJp3jhKoNeG+4S+Z0pN+lo3/x
	Xm5Bd8vN+KP01NtsR199EdM6IFm6Kv2ZQYOQLHJEduDYEvzedSfbfbBFZnOA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:151b:b0:69d:513e:1a6c with SMTP id
 006d021491bc7-69d7ec9a333mr1265520eaf.50.1779429284826; Thu, 21 May 2026
 22:54:44 -0700 (PDT)
Date: Thu, 21 May 2026 22:54:44 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a0fefa4.170a0220.2e5ec6.0004.GAE@google.com>
Subject: [moderation/CI] Re: netfilter: conntrack: remove some code
From: syzbot ci <syzbot+ci6b62cc4ae8b262c5@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] netfilter: conntrack: remove some code
https://lore.kernel.org/all/20260522050140.4838-1-fw@strlen.de
* [PATCH nf-next 1/5] netfilter: nf_conntrack_helper: do not hash by tuple
* [PATCH nf-next 2/5] netfilter: conntrack: get rid of tuple in helper definitions
* [PATCH nf-next 3/5] netfilter: nf_conntrack: switch to static registration
* [PATCH nf-next 4/5] netfilter: remove obsolete nf_ct_helper_init api
* [PATCH nf-next 5/5] netfilter: conntrack: add deprecation warnings for irc and pptp trackers

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/6b7dd605-be91-42de-a939-b82234442904

***

kernel build error

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      ab1513597c6cf17cd1ad2a21e3b045421b48e022
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/52edd1a1-56d7-4133-811a-d2be41816921/config

net/netfilter/nf_conntrack_ovs.c:31:14: error: no member named 'tuple' in 'struct nf_conntrack_helper'
net/netfilter/nf_conntrack_ovs.c:32:14: error: no member named 'tuple' in 'struct nf_conntrack_helper'
net/netfilter/nf_conntrack_ovs.c:60:14: error: no member named 'tuple' in 'struct nf_conntrack_helper'
net/sched/act_ct.c:1527:52: error: no member named 'tuple' in 'struct nf_conntrack_helper'
net/sched/act_ct.c:1528:51: error: no member named 'tuple' in 'struct nf_conntrack_helper'

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
[fw@strlen.de netfilter-devel@vger.kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

