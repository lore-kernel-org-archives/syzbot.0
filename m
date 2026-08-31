Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1AB6F41D65D
	for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 13:22:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788182574; cv=none; b=WVx69ny9+BKTsKdml2ebHiLpOcwl+OAWg6DLOQAQtDbidLvl3254KYw4MMAQRe4C+7ynPrNEMGoSmScCIQr8bHO+kNF1VpMaq9j75a8rSEESYTb+4lbWqT5sHZAuEzbs0d54IinnETdkYa6uEzUpW5Tc3wO4Bat7qpNFnNlM0fQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788182574; c=relaxed/simple;
	bh=vdBQr759cVWxWlZ8WIenKf/0JfdYQTs43utq9eqB9Ys=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=gZ08T0K/ii94Oh9bannRnBcswUr6Q2R971zCBxhaMcH3RVQnzP9G1flVI3yJAjIFYiKAB7sFcIQu3Gzhy0toIr6BalmADhenKbHjPMpODjdqz63243YpeqXaJVGopeutZFf6rw7H5yLmmnjRj2+sgL6jf1x791lWYfLVjZ0R8eI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-4b37620eb73so7446601b6e.1
        for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 06:22:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788182572; x=1788787372;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:date:mime-version:x-gm-message-state:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=pd1FCV9He4t/+7A7bTKjg5mxIMYhWAqVFX9XMRkgDK0=;
        b=nkatouMZ9quDhQ1TpGnM02CACgo5geKYr3XOgvg8kJfS7eW2yIqFtGYYF7fYKlEL1e
         BncSwu4Kjo/0WQxj8nuOlkJ9tcxbP5nXiVl8rLPOyqo/arzDWpmpLBpgg4fBgaQBHqjj
         lEmLRb1vR8dgYr0CWbNVoERcvkO1iJi1VDQIDDWqxLBXw4p+XcmbYU5/aWiAHmfaU31f
         HkwaKNxh4cH9fY9zDfthTRDo0APFluclacCn3xHsBCEzzYEcnlrZuh1vbF/ycAhdP0/V
         qpIbvzzh4munUp2C0x5bpzpk86Na7IT98B9ETjrPB7h28Y3xurS0t4PL7Y6uy6iqyC02
         Xdvw==
X-Gm-Message-State: AFuF++lrq2zddNUkTk10ahpWTCLHqh6T6S7kR89W4le/MT4XU0cxd16g
	tmPThJ0HHNYgk9/QuxOVWHQmdTPf55wQJeuL0D/ElyoPy688hhhUV8d6ICTuuaIb+yziyxBvKL4
	cb7VBufKCnfRLsCcoDeXA+AhLA3Ntfnd8oeYwvX2SIK5XIhC9N2lZ9LG/hPw=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:1a11:b0:4b2:8d9e:de11 with SMTP id
 5614622812f47-4b5b837c725mr883242b6e.19.1788182572000; Mon, 31 Aug 2026
 06:22:52 -0700 (PDT)
Date: Mon, 31 Aug 2026 06:22:51 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a95802b.a8e469d2.cbf3.561c.GAE@google.com>
Subject: [moderation/CI] Re: net: support thread-specific pidfds for send and connect
From: syzbot ci <syzbot+ci0b5ad5c5b8f14a59@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] net: support thread-specific pidfds for send and connect
https://lore.kernel.org/all/20260831-work-unix-passpidfd-v1-0-70cbfda0c7ba@=
kernel.org
* [PATCH 01/10] pid: add helpers to operate on a struct pid array
* [PATCH 02/10] af_unix: record the pid of the sending thread
* [PATCH 03/10] net: add SO_PASSPIDFD_THREAD to get a thread-specific SCM_P=
IDFD
* [PATCH 04/10] selftests/net: SO_PASSPIDFD_THREAD
* [PATCH 05/10] net: turn sk_peer_pid into an array indexed by pid type
* [PATCH 06/10] af_unix: record the pid of the connecting thread
* [PATCH 07/10] net: add SO_PEERPIDFD_THREAD to get a thread-specific pidfd
* [PATCH 08/10] selftests/net: SO_PEERPIDFD_THREAD
* [PATCH 09/10] pidfs: record the coredump on the dumping thread's pid too
* [PATCH 10/10] selftests/coredump: check the dumping thread's pidfd

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/524fcdbe-c7b4-4e1d-b6d3-52ea41fd5526

***

kernel build error

tree:      drm-next
URL:       https://gitlab.freedesktop.org/drm/kernel.git
base:      cee9395acd8043be0644b25c34bfa86623f2b935
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp=
1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/f7d70247-4c01-4de9-bc8c-1c0ada6de44=
8/config

./include/trace/events/landlock.h:946:13: error: incompatible pointer types=
 assigning to 'struct pid *' from 'struct pid *const volatile *' [-Wincompa=
tible-pointer-types]

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
[alexander@mihalicyn.com brauner@kernel.org davem@davemloft.net edumazet@go=
ogle.com horms@kernel.org jack@suse.cz kuba@kernel.org kuniyu@google.com li=
nux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel=
.org oleg@redhat.com pabeni@redhat.com viro@zeniv.linux.org.uk willemb@goog=
le.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

