Received: from mail-oi1-f199.google.com (mail-oi1-f199.google.com [209.85.167.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 327A73BF694
	for <syzbot@lists.linux.dev>; Tue,  1 Sep 2026 07:05:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788246307; cv=none; b=FQ8nM5QL4TExPN0n6YZyg10OJkbIdYzvqfMagpSvQq3hby9LqfS7GTpJyY9fNr2dhjNeTpmG5ZXefXhye9WI3T2t6vXCgZDj8NcZD0thommfOF60pi6sEGYBk56PM28u2fcHPIi+pdue1lzoWFK5eA/V4ICS/Uu4BT8TGQ6gzZo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788246307; c=relaxed/simple;
	bh=R6455ZC6tYkOrHfHvS4vknpiRZhGU4LJv6LZXPiwamk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=JSchUXty+r58L9QKCwGG9ZK7aI/qjmulYwo9B0uTMHJ89tPGhtyQ2cQtjkGG/Chd/gG04ojEht/GaMhf54Ya3uO47EcsroITMwFNxZ4tDQremBB9+MZLuxSWKB6SQ4sWJ1Ivkrl2+Y7xtSYxaII7Libf/4qp23OTcqfjKWlmk98=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f199.google.com with SMTP id 5614622812f47-4b28d9206f8so2464759b6e.0
        for <syzbot@lists.linux.dev>; Tue, 01 Sep 2026 00:05:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788246305; x=1788851105;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=2OLnM40zxnSUo2xLKTH0RqN2e1rfE1t9CeALc7Ilz4U=;
        b=rQUX0kLoi+pWfkvgA6MoD7nyhI1lqaitoryQRmtYa3GrcU3JwA8zdWC6HHK8Wm5OIA
         B3pxG8z8hYvpKmGKDiWaVgTosjzDSWDay1br986mvFxopoda21/BzJcXkaXA8swNcIoZ
         2IKvsYpsEOI0CG+r1aIS3iSFbabRDPZvyqG8tknrhwHC7lbicWVQCugmwCHC9TDUR4qp
         QhNj55kbkw22dpSGLnDg8Us3CceP5gwjz4ylMeclXw4Dv9LeGjvKcAqrocb6n0AlGPlM
         FLTIZcosCQehgfkoUyq16vWFsKRZw+WEl+9HurbDlawPnVJ/6Vc7aMVsDTh5A3eNjrYn
         ZHBg==
X-Gm-Message-State: AFuF++nUoqi7Y6iKule9HdXZ7PMtojKQWwBFeSwciRyEarP64cTvyHjY
	ctWqDigW8findKm6sWkeidD4H6ufoyuL/oLn8L4BRXa8rN17CclVGOwOnh92QjRNKRqhBiUbf/V
	jxjAbbiNRVqzkFZliwo98RcicuqxNJWCcOUIhpuqY7eTmLcV5w1IELEUqJvA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:228f:b0:4b2:b4d3:f919 with SMTP id
 5614622812f47-4b398294fd8mr34784171b6e.14.1788246304958; Tue, 01 Sep 2026
 00:05:04 -0700 (PDT)
Date: Tue, 01 Sep 2026 00:05:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a967920.99925153.16bd3d.0008.GAE@google.com>
Subject: [moderation/CI] Re: Change skb secmarks to x-array indexes
From: syzbot ci <syzbot+cifd631cebd4b65f57@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] Change skb secmarks to x-array indexes
https://lore.kernel.org/all/20260831223748.4304-1-casey@schaufler-ca.com
* [PATCH 1/7] net, smack: Create a function to set secmarks
* [PATCH 2/7] LSM: Implement x array functions for secmarks
* [PATCH 3/7] LSM: Two hooks for manipulating struct lsm_prop
* [PATCH 4/7] SELinux: hooks for secctx_to_lsmprop and update_lsmprop
* [PATCH 5/7] Smack: hooks for secctx_to_lsmprop and update_lsmprop
* [PATCH 6/7] Apparmor: hooks for secctx_to_lsmprop and update_lsmprop
* [PATCH 7/7] net, lsm: Change skb secmarks to x-array indexes

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/b7e84029-29b2-4b15-ba26-02449fec62f9

***

kernel build error

tree:      nf-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilt=
er/nf-next.git
base:      8d3ae59288f1e7d58d76558a6ee96d533bc5019f
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/5b9eb8c0-a439-498f-9723-e4751cea7a2=
f/config

security/lsm_secxa.c:75:27: error: use of undeclared identifier 'CBS'
security/lsm_secxa.c:89:28: error: use of undeclared identifier 'CBS'

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
[casey@schaufler-ca.com coreteam@netfilter.org fw@strlen.de jmorris@namei.o=
rg john.johansen@canonical.com keescook@chromium.org linux-kernel@vger.kern=
el.org linux-security-module@vger.kernel.org netfilter-devel@vger.kernel.or=
g pablo@netfilter.org paul@paul-moore.com penguin-kernel@i-love.sakura.ne.j=
p phil@nwl.cc selinux@vger.kernel.org serge@hallyn.com stephen.smalley.work=
@gmail.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

