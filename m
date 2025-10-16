Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31E152E2DD8
	for <syzbot@lists.linux.dev>; Thu, 16 Oct 2025 07:25:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760599512; cv=none; b=u0dpNLsgW6PKYkx0mgifMU1w0LXsT6YcUHmutudfRUq9bCA1CO71AkoXS/3zsaUFYlugYJAMWz4oSfpQoIebLxwapwl6R2TKIhVukRjOWF+7d4uvqKxiehcft9s9/8Q9go80u/ccWLjC9K7vhPZp3+9p8BeNKkIHYDWJbnUXE+s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760599512; c=relaxed/simple;
	bh=L4NJQBsUgF0KIddexJUkmQPvUrNX0j5phTknQgvTaGM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=eEjrIxitt3rl9yw6t6FAg4FnXS+jscbUG7yj6L9PVESXuckZbmcC5KRKkiLiFQs8NEPHnE/mHSQMBH0ZBRHYTgipEBXTNph+dYctWVd0uFe4OutXIo/btsNiXbXJm5ZGmdFFu59UGwqEJ3aDb05Fm9aI7QKx/xNtzndykAjsJl4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-430b1473c07so20354935ab.1
        for <syzbot@lists.linux.dev>; Thu, 16 Oct 2025 00:25:09 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760599509; x=1761204309;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=pr4C72Gem7JyjR0sVGMdoZLRgP3aBaX7dpayODFyW3k=;
        b=pBR5A3TYYCUqBSXX00QC3e7y8CIxCsguQYEsmaxNIvwOifmNYrctGVM/M+dRe4ipRz
         P4GiZkZNmytFF3TjATAbPcld0ap6pBzzhS+V8RBaERNNihxY+N61U3nWAe3wo4/lf/e+
         lvHYN/VYjwaqaYWfXrlQDNS52UNiZ8+qfmgaWwtqmDE+dgSrb9CGlinWGx/lAIstDqJP
         rQdcW/yXwOFyndGdMNP9ZJAQWOw3M1N1PhvOg/Gd/rXCsniDAHfzMQQKha8oiqEml0uZ
         AacRZpRFMo6FJONVAJedrEABLdR4AoCP7/gVNiBrar5HuN+PuyXlWh46dpRBP+SpVqFA
         IwYQ==
X-Gm-Message-State: AOJu0YxR6m4Sw5Q9Vt24XuEg3mbvVFriqGlGxxoer5GY2/sGKopDVaNj
	FzCtV5eW7cHe9iV753/62EM2qZAaBC8z940pHP3z6av5uKsaS+bFwpug2e/MO9EoOvtMZmKEeqg
	iqySSmrXE5ewi0SbpvKviIqast9k7jsdGy47JVxLSCpOzubrjuyfVq4N3bnA=
X-Google-Smtp-Source: AGHT+IGBQNux6fAnjcr3BQoh4iFsTP3i++NpID3FhHBJ1CUOgA9WNLizSSV6hATQMlWQ+uDEx3briEzLgoMh9WWaagIEo7tEhGIr
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1709:b0:430:a4f0:899a with SMTP id
 e9e14a558f8ab-430a4f090d5mr109176695ab.31.1760599509301; Thu, 16 Oct 2025
 00:25:09 -0700 (PDT)
Date: Thu, 16 Oct 2025 00:25:09 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f09dd5.050a0220.91a22.03ba.GAE@google.com>
Subject: [moderation/CI] Re: page_pool: check if nmdesc->pp is !NULL to
 confirm its usage as pp for net_iov
From: syzbot ci <syzbot+cieb7e65077a0bd1bf@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] page_pool: check if nmdesc->pp is !NULL to confirm its usage as pp for=
 net_iov
https://lore.kernel.org/all/20251016063657.81064-1-byungchul@sk.com
* [PATCH net-next] page_pool: check if nmdesc->pp is !NULL to confirm its u=
sage as pp for net_iov

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ad6ce078-6497-42e2-a2ef-5749153b9dc6

***

kernel build error

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      18a7e218cfcdca6666e1f7356533e4c988780b57
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/d3d59dee-0e1f-48be-8dc1-5e0f7bed50c=
3/config

net/core/netmem_priv.h:29:12: error: call to undeclared function 'netmem_to=
_nmdesc'; ISO C99 and later do not support implicit function declarations [=
-Wimplicit-function-declaration]
net/core/netmem_priv.h:29:38: error: member reference type 'int' is not a p=
ointer

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[almasrymina@google.com ap420073@gmail.com asml.silence@gmail.com axboe@ker=
nel.dk byungchul@sk.com davem@davemloft.net dtatulea@nvidia.com dw@davidwei=
.uk edumazet@google.com hawk@kernel.org horms@kernel.org ilias.apalodimas@l=
inaro.org io-uring@vger.kernel.org kernel_team@skhynix.com kuba@kernel.org =
linux-kernel@vger.kernel.org max.byungchul.park@gmail.com netdev@vger.kerne=
l.org pabeni@redhat.com sdf@fomichev.me toke@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

