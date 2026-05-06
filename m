Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 217D925776
	for <syzbot@lists.linux.dev>; Wed,  6 May 2026 05:20:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778044822; cv=none; b=DFasQlfLKG3JVOmg4MC03jMRxiNFywfm51alaoZ18Ub/3Czcn0TZPjqRZu8XsNHa+/azA71cz8xwSHgyE5Q6aTJq/tvLGKt95gP/yVLbApYJgJEJKcUjSI/dixfk7k5VxYMo9cDYPve7J9WT/PDvHfOCbNiyJBHU0jdHmcyy2rA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778044822; c=relaxed/simple;
	bh=jH7a7iTVnpNE4I58lcySwpPdyELxOSPe/XxUkPn/V7s=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=CAr4We/BUpbBiC81qDa9oEBx5p3VRmuBGOIsqrhI7LxA1qQm+np4+G2IohGVNRt66/QIG0V6drXc3P9tVg+iR6I9RNIxwvkOeg0GmIVuQQMCyq9pnV0VUMnpJN2XLC5mmdHY91dO4Lt3OnzUc70ufBcbbLdAhZBKhc1OtKK4itg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-696266291d6so7172702eaf.1
        for <syzbot@lists.linux.dev>; Tue, 05 May 2026 22:20:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778044820; x=1778649620;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=d7XXIlZe0j2ygLsD62z2z+WrG7nCu4D95HYv8spqVX4=;
        b=rlL6lTKlh/VJeoHsocoaxRyQJ4csNWX46N8MZs+9M7oMDe5CC4nLKtTBw2gu6AcUsf
         r2AQiNr+d9B3s0/yf0RFv2av/b69LiWp6ozoxE1futrYebLFKQHokX+XtZbmzh3BOykK
         9WWvTwnFYAVgzNfd9R0tKHs1nlCAsnNIuX5ruH735KxoToGlhMm6xkkqA7oOEsC/filD
         Lc3LmHXAn7FRoy3uVXn4VicVPZ0lLuJlOEmIBTu3nckJm7A2xpecixO7CN3DxHCS0CH1
         mpcZb2wXLptffTvqCnd/meU3++0VIG+JahRfhBQlOH0skgrc4aVnaNYhlhj7GOsclxLP
         tjgA==
X-Gm-Message-State: AOJu0YxPAHhW6zBiz6R6Q9Jw1mVfV0aRrNouuBdNWlXgbgTe1MIwmcPC
	MyISdeYnOoI20BxgtWl89dTiM151xL+mZXoEIh0Jsnf2K/goV6mo5BP1CNDPv4JEOOTQfjNC+ig
	2l52IcM/r/uAYrhZV9RrQAeItPmdFCHlQVi6ReXPM1y7Z4f1f7ABeIH2Ocm4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee0e:0:b0:696:8098:b0e5 with SMTP id
 006d021491bc7-69998d69ed4mr897049eaf.55.1778044820045; Tue, 05 May 2026
 22:20:20 -0700 (PDT)
Date: Tue, 05 May 2026 22:20:20 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69facf94.170a0220.59368.001e.GAE@google.com>
Subject: [moderation/CI] Re: block/blk-iolatency: Add the processing flow of
 the chained bio in the QoS and define the related types to solve the problem
 of incorrect inflight processing in the QoS. The usage of the done_split_bio
 abstract function in the blk-iolatency project.
From: syzbot ci <syzbot+ci15f3f34c3c0a728c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] block/blk-iolatency: Add the processing flow of the chained bio in the=
 QoS and define the related types to solve the problem of incorrect infligh=
t processing in the QoS. The usage of the done_split_bio abstract function =
in the blk-iolatency project.
https://lore.kernel.org/all/20260506024244.2741-1-likunyu10@163.com
* [PATCH v2] block/blk-iolatency: Add the processing flow of the chained bi=
o in the QoS and define the related types to solve the problem of incorrect=
 inflight processing in the QoS. The usage of the done_split_bio abstract f=
unction in the blk-iolatency project.

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/dd20f82c-9bc0-4af9-9acc-d222d1be5cb1

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      74fe02ce122a6103f207d29fafc8b3a53de6abaf
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/cfc259c8-5ebb-4fa1-b483-33227b86ae5=
e/config

ld.lld: error: undefined symbol: __rq_qos_done_split_bio

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
[axboe@kernel.dk josef@toxicpanda.com likunyu10@163.com linux-block@vger.ke=
rnel.org linux-kernel@vger.kernel.org tj@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

