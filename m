Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com [209.85.167.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C9CE2E63C
	for <syzbot@lists.linux.dev>; Sat, 21 Mar 2026 12:00:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774094458; cv=none; b=t0sqCJo9ybSSlGRfkCXQZ8v9K8iTqNaXeQXqMrqoYqLnpiZO9TR9Ojh4fz2EmtpTOrI8vsAxgGiGvTkaolRBQ4rTYqsSQfOAKYUqs1rNhk4sZqA6CCu00haK+Usf0Hx/TB0bhUrcrqZggct5bXUMDdNHlJhoJPRx0bd6scWt/7Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774094458; c=relaxed/simple;
	bh=9J8GC753IRSimoTGHE0+uU8ZoyNW+zB5Uk60VjuS/Gk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=LnP0yh2QG4GiCb7Rs5JZVGvA3dxsCPKkzScC0B68uQjHsDlrn+CCW2EDYt+0bfKTcf5oDnvHlrHdPYoZyNkzXIIR/M2PZDMfCOxdBpCvJJqoV9rcj+y06WzZW5eiI3tgGIm0Xd8Pz61sl5sEZ1UXFFjg8h5Nx5ayjtuCRwSGVXI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-467ec73eec1so6395578b6e.1
        for <syzbot@lists.linux.dev>; Sat, 21 Mar 2026 05:00:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774094456; x=1774699256;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=SWOTtmCAVun6398SJBhz8zgu0mE1xl3iF38sR0+LqRM=;
        b=XrMQO33XY40LUiRIihz/Y6zmU6fIhzlcUpazuSO5yYAO696fvOg0QS65ti7MpEUNEi
         n/VWC61+Qrf8X8MNrAfuI2cgTvpZxyuB+V7WZI9fIga7K39oaofHDJZUwCnum2wco7SI
         uIXtH/eyljz1aVR1YSDk4PJngsM8oJgxfSYVfN/tolCedCjNvgSqItMEQmxe9Z+Sk6mY
         n1JnOEwPn6XQvX91pV01FnWq7f6AvJMFRT9yCERXrii5J+aXsewp+T0FL50MSFpECmEH
         YPw/UaELHv8dxp31EGbu3KYwrHr8+iPbdMqerGaK0v+siKC8GaE4Zcn8uY05kWrEc/0z
         gIEQ==
X-Gm-Message-State: AOJu0Ywmd2ZPaA1HH08yoWacCfy8oboAxns7Jij67uBoZn6Z2tah23J2
	t0O4ssCjctFCk5tV0dPxDuIB1yGhCBBzDaojpW8lbs3JBeNVQBCK34LQDOAByTVLnhuaC/ygKVA
	hrpN6EssUHgKIAoZ2zlEO6kLSM9tiodF2FJYELgstca/DCIKphlny5qgdqMM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:4cf:b0:467:3f4:907b with SMTP id
 5614622812f47-467e5d427aamr2841913b6e.7.1774094456212; Sat, 21 Mar 2026
 05:00:56 -0700 (PDT)
Date: Sat, 21 Mar 2026 05:00:56 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69be8878.050a0220.3bf4de.004f.GAE@google.com>
Subject: [moderation/CI] Re: conntrack expectation fixes
From: syzbot ci <syzbot+ciee69b98a22fc6f04@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] conntrack expectation fixes
https://lore.kernel.org/all/20260320125947.305117-1-pablo@netfilter.org
* [PATCH nf 1/5] netfilter: nf_conntrack_expect: honor expectation helper field
* [PATCH nf 2/5] netfilter: nf_conntrack_expect: use expect->helper
* [PATCH nf 3/5] netfilter: ctnetlink: ensure safe access to master conntrack
* [PATCH nf 4/5] netfilter: nf_conntrack_expect: store netns and zone in expectation
* [PATCH nf 5/5] netfilter: nf_conntrack_expect: skip expectations in other netns via proc

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d856b4aa-722b-4363-9a8e-90b54d9245a4

***

kernel build error

tree:      nf
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfilter/nf.git
base:      e7577a06ae28287ca415aec5c12277e3a80ee372
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/9222913b-669f-4a16-b489-589958297c6e/config

net/core/flow_dissector.c:36:2: error: embedding a #include directive within macro arguments is not supported
net/core/flow_dissector.c:38:2: error: embedding a #include directive within macro arguments is not supported
./include/net/netfilter/nf_conntrack_core.h:90:3: error: unterminated function-like macro invocation
net/core/flow_dissector.c:2101:45: error: expected expression
net/core/flow_dissector.c:2101:45: error: expected '}'
net/netfilter/nf_conntrack_core.c:42:2: error: embedding a #include directive within macro arguments is not supported
net/netfilter/nf_conntrack_core.c:43:2: error: embedding a #include directive within macro arguments is not supported
net/netfilter/nf_conntrack_core.c:44:2: error: embedding a #include directive within macro arguments is not supported
net/netfilter/nf_conntrack_core.c:45:2: error: embedding a #include directive within macro arguments is not supported
net/netfilter/nf_conntrack_core.c:46:2: error: embedding a #include directive within macro arguments is not supported
net/netfilter/nf_conntrack_core.c:47:2: error: embedding a #include directive within macro arguments is not supported
net/netfilter/nf_conntrack_core.c:48:2: error: embedding a #include directive within macro arguments is not supported
net/netfilter/nf_conntrack_core.c:49:2: error: embedding a #include directive within macro arguments is not supported
net/netfilter/nf_conntrack_core.c:50:2: error: embedding a #include directive within macro arguments is not supported
net/netfilter/nf_conntrack_core.c:51:2: error: embedding a #include directive within macro arguments is not supported
net/netfilter/nf_conntrack_core.c:52:2: error: embedding a #include directive within macro arguments is not supported
net/netfilter/nf_conntrack_core.c:53:2: error: embedding a #include directive within macro arguments is not supported
net/netfilter/nf_conntrack_core.c:55:2: error: embedding a #include directive within macro arguments is not supported
net/netfilter/nf_conntrack_core.c:2827:47: error: expected expression
net/netfilter/nf_conntrack_core.c:2827:47: error: expected '}'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[fw@strlen.de netfilter-devel@vger.kernel.org pablo@netfilter.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

