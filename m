Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A39E396565
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 18:38:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787769492; cv=none; b=KwQU1+xuFnqa9EXpHMZduKOjsOPZzJiZ9FTIHGtKIFXi78WnvM1OQZsg+fm663EcaZDfvotUseCCzwWWAuPTOQvTjk+fSe4O4LLip2yi2Sn+6mXYilZKqiV0dulxuEnGxvyPeKFoGSctA3tvnt51KkG7IXVBcAc2MIrt4JqDsWU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787769492; c=relaxed/simple;
	bh=QqawRMZtu4vig3FxTk76oM1ZkULZJYhJJapQuQ2Zu9M=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=V6hAlhtmNjhAS3FI8waWD0w7NdOQPTzgWiV5ppXeZP+wflQZMZCWu+6/UGnjYCmCCxwxuH7YE9fhfhV1Vegjo3DdgkWaCXfP9EErX86gaBflAS622VxO3/yQkmxE/fpjGuTYmNsn0xCJdCkv6fhg9i2Xg7OMh2uTPkcrXgz083Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4ab4ca7ce3fso2214507b6e.0
        for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 11:37:59 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787769477; x=1788374277;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=GRtX+/AMD+nCNRWUGNxDBoP4pd6qD7Uga5Q/GEl0lLA=;
        b=PzAorOo67Afz8go6v3zzFk8z8gYIIbZWOpd/WJkqyBiA+njzfKJ2NpC4DLXT4IdgvK
         h1ERRL7w6BQAYqDBKLbUHYjQSYERDSHZBBAsir74wI42LdP/GLlkILu7e5E72eAbrs0z
         jSYJihnMzAZrXNvB1tJSXp/N8TSkE7k8IujmrCMm2lPDGtYWKnCLT7BaJumLkkytaymz
         ij/KnEY/L9boUDij+G6Aa2xdUvpO85dyixGRX3W94jl7UObmy/uIfbydjpHewWYXr1hw
         nZaRmocYm1NWcTmV/s4ECm+hUVamfML1rkM4nD6jtM9O7HKByUuKIk61gpY6ybjlGxJS
         8zgw==
X-Gm-Message-State: AFuF++mXOE5X08IYcC7zWlheu3sPRzHaYNU5Zk+gkbgIn/xTf+uFEaoN
	pSJPypyo0x9eCjXBy1SE2wTpGg6itccZuK/llQuTlWFr7YCg1BJa/nOkYV30LFimqvpOJC11/sw
	WbbjS1HASnbcL/erom4jMsUTeMaMeH3o0TtplYCOUlbWgB7XIiQASoQ3kFxs=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6809:34c:10b0:4b3:7da2:f393 with SMTP id
 5614622812f47-4b37da2f462mr843923b6e.15.1787769477569; Wed, 26 Aug 2026
 11:37:57 -0700 (PDT)
Date: Wed, 26 Aug 2026 11:37:57 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a8f3285.4d659fcc.734b4.0005.GAE@google.com>
Subject: [moderation/CI] Re: tcp: fix use-after-free in do_tcp_getsockopt()
From: syzbot ci <syzbot+cie3ec19fdda59ffb3@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] tcp: fix use-after-free in do_tcp_getsockopt()
https://lore.kernel.org/all/20260826171344.4133-1-blbllhy@gmail.com
* [PATCH net v2 1/2] tcp: fix use-after-free in do_tcp_getsockopt(TCP_CONGE=
STION)
* [PATCH net v2 2/2] tcp: fix use-after-free in do_tcp_getsockopt(TCP_CC_IN=
FO)

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/2f1649c0-f2ae-4dba-91fe-85e6de6ced71

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      f967455fb2a5a2079b9eb5823e9ccf359174bf9f
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/d1a76ec6-f991-45ea-95a6-725073b26fb=
5/config

net/ipv4/tcp.c:4592:3: error: use of undeclared identifier 'ca_ops'; did yo=
u mean 'pv_ops'?
net/ipv4/tcp.c:4592:10: error: assigning to 'struct paravirt_patch_template=
' from incompatible type 'typeof_unqual (icsk->icsk_ca_ops)' (aka 'const st=
ruct tcp_congestion_ops *')
net/ipv4/tcp.c:4593:19: error: use of undeclared identifier 'ca_ops'; did y=
ou mean 'pv_ops'?
net/ipv4/tcp.c:4593:25: error: member reference type 'struct paravirt_patch=
_template' is not a pointer; did you mean to use '.'?
net/ipv4/tcp.c:4593:27: error: no member named 'name' in 'struct paravirt_p=
atch_template'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[andriin@fb.com ast@kernel.org autonomouscodesecurity@microsoft.com blbllhy=
@gmail.com bpf@vger.kernel.org davem@davemloft.net edumazet@google.com geli=
ang@kernel.org horms@kernel.org kafai@fb.com kuba@kernel.org kuniyu@google.=
com kys@microsoft.com linux-kernel@vger.kernel.org martineau@kernel.org mat=
ttbe@kernel.org mptcp@lists.linux.dev ncardwell@google.com netdev@vger.kern=
el.org pabeni@redhat.com stable@vger.kernel.org tgopinath@linux.microsoft.c=
om xmei5@asu.edu yhs@fb.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

