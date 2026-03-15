Received: from mail-oo1-f70.google.com (mail-oo1-f70.google.com [209.85.161.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEA4B301486
	for <syzbot@lists.linux.dev>; Sun, 15 Mar 2026 11:56:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773575777; cv=none; b=b4Aex6UX4inxzN1Eyhf7LN/aZ9rUefax33NLq5bSBr+9x3Bb0tz802X138rVOCAFj2yw/zwWCqJBgs/bV3SPgObbhhYSPE7xFdOqNpSw9DDyTwlXIr+M47+L/eoDnk0pKNfbmEJ1i3Sup9oQa9zAqKHFYXeLL8yVwyhBI+jqMFg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773575777; c=relaxed/simple;
	bh=GDx0ZiJB2n2LoNNv8l4fq8GpK/w3fGpovnPZQD9xtj4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=b3r4l086GyanrQeI1XZXEWdu5jvt8CtiF6KxZmu/doV1r4Gw54TvB+n30ivDjyIFOu9xyEuK7yXMU69NhcWbXz9pDgxyDPITy1Qz/YDTUyo7oJfoORq1SWGPvsqdROaeFwDLhghvATYpX2XHqoFuDemWuABDmFAsdvLZvyAMW/I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f70.google.com with SMTP id 006d021491bc7-67bf2b7267cso16572217eaf.0
        for <syzbot@lists.linux.dev>; Sun, 15 Mar 2026 04:56:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773575775; x=1774180575;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=6q5MOwfxK+9oQUDNClOqqLxHNMS21gAMY/eb1iaCezY=;
        b=oQv+wBjZugipUd6w3pGBYeI5821UetAhjgCWc5vG8qFHX3yLtVvuBggY47o9JzxS+O
         UVC/Go4XqQBC9C28SuGsZOkbqENBtVc0vVidQmynGCmCS0tzqkvQWSJuxGNNsAkZT2k9
         xFhN6Ejg/+smiRTVtpDMmpbo819dxMgCNKUWteMr7HTG5UjCQFgBe6hLfxpwT/S1ou8i
         9LYBeM623wrmsf3tuRbduNMCEDW2dYFz/s1nD2BJ+VBTRzKKN7optj+g1KEFVgHy5o3e
         AX0EobwdndAFkvUrWlZmTvFLZ7kj9ar3+oHjs1iNpYlIygcQWX18Z88B5cNxW1PeyB/J
         V5CQ==
X-Gm-Message-State: AOJu0YyA/8AUrBJyNNgvmTkCO+UZ3LTGrzw3NPzdHlk+EZ9aILL/7NFu
	TmI5wzvFDciG6Jn0E9RHJzO1mRnrMm/YGncXRh4kbVWBBRh1x8O9GYk2jAV8lh01B23XAjqTiXI
	sEyBw3RKJ7HU7+10WT1ui0Yl8qs4Tcp5+lTpRwPNX71Ks6lRyz+qG4/dAZ+E=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4b15:b0:67a:4fe9:a4ba with SMTP id
 006d021491bc7-67bdaa6adafmr5885530eaf.63.1773575774909; Sun, 15 Mar 2026
 04:56:14 -0700 (PDT)
Date: Sun, 15 Mar 2026 04:56:14 -0700
In-Reply-To: <20260314210810.67348-1-ebiggers@kernel.org>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69b69e5e.050a0220.248e02.00f9.GAE@google.com>
Subject: [syzbot ci] Re: bpf: Remove inclusions of crypto/sha1.h
From: syzbot ci <syzbot+ci46064f472908848f@syzkaller.appspotmail.com>
To: andrii@kernel.org, ast@kernel.org, bpf@vger.kernel.org, 
	daniel@iogearbox.net, ebiggers@kernel.org, eddyz87@gmail.com, 
	haoluo@google.com, john.fastabend@gmail.com, jolsa@kernel.org, 
	kpsingh@kernel.org, linux-kernel@vger.kernel.org, martin.lau@linux.dev, 
	sdf@fomichev.me, song@kernel.org, yonghong.song@linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] bpf: Remove inclusions of crypto/sha1.h
https://lore.kernel.org/all/20260314210810.67348-1-ebiggers@kernel.org
* [PATCH bpf-next v2] bpf: Remove inclusions of crypto/sha1.h

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/38f41420-5e88-492b-9239-7c260178aa25

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      1c9982b4961334c1edb0745a04cabd34bc2de675
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/b5327796-0a46-46fc-a192-f0dbd20d9047/config

net/ipv6/addrconf.c:3341:25: error: variable has incomplete type 'struct sha1_ctx'
net/ipv6/addrconf.c:3344:13: error: use of undeclared identifier 'SHA1_BLOCK_SIZE'
net/ipv6/addrconf.c:3369:2: error: call to undeclared function 'sha1_init'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
net/ipv6/addrconf.c:3378:2: error: call to undeclared function 'sha1_update'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
