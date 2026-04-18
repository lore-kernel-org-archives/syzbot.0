Received: from mail-ot1-f72.google.com (mail-ot1-f72.google.com [209.85.210.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17231175A77
	for <syzbot@lists.linux.dev>; Sat, 18 Apr 2026 02:35:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776479757; cv=none; b=muET1bi8hpoGF4y2UnNBWI9DM6qLWVwk/TlCHLZEMY9SQ9uzeXGPO6LRFJmqxjUqwRZrx/Fj6LjQq+VSgff/C3hLFLDU1oXwi/g+IG1gXru27Z1zeyFJHI8E2Tf0Y+ukXOrjvXbNjLuxQhaEhgrN1luhBuF0WeFSGHKch5rJ7Y0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776479757; c=relaxed/simple;
	bh=neMe07VtvzU5oKOw1VhU75Ez3wpv64hxtU9zxWqLgEY=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=jr+MQHEnxw+1ZYbcn87KejiH5x/90JUcFiTtW+S3WwFZl2zohKaLsYYoV8MJDcFwQms6Db4tWB6uJuqm/9+jG8JjMaSCYRcKpOROoortHE/suyjQwcZQNbg92bqeyCBIFXqsRzWcy8E84MaceGe5x5geoQYZCgbRJ22kfJrWPZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f72.google.com with SMTP id 46e09a7af769-7dca6ecdd85so52127a34.1
        for <syzbot@lists.linux.dev>; Fri, 17 Apr 2026 19:35:55 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776479755; x=1777084555;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=E9+pp0XaQSxmdvqExTGxIPz1dniMFJr/l2P6cs8cIto=;
        b=Ggf3nrJXstEWsXLfZFbsHYTTj7A7kkW7mVbE2y4Xh+nIQWFmCpSKmwriC/gyHEcCEC
         Qy6v2quPA5LTHuiMHjEcOpzOs6+4nzu8siqwO6aSBwA7vOL3xcKdVy58btsX861Z1F5t
         jl2pZEBpkFWuuM/Z2UGiw7ab7N1kHdFp/a/hWkeIUg9kujFxxIclVBPVbCwV9rh/47yu
         0tLhnd6f4fQspGG173qfOqOS2shzOnG/RHShdbBqzEjMmDX6nt0bF5eRvmYlvF+VD401
         KDDr8EjmgCOjLk//DFUt297XN0hEhHc92x+lBonGTcw6ji/1ac6ySR59t6kx27JX5bMz
         2Ipw==
X-Gm-Message-State: AOJu0YxIaGZy1reATCDRq5wmXpLtDIFFhDyOYI5SI6n4uLYwhGMGIPOH
	SkbH+mFwVNHqYo4GNlQIo220NYqxss8CvS6sTSaiHX0atzlNZUmEwjbLqtOhc/3IleY/l+ScncX
	oo69J4FZiN+z1uUPuHAKMwqKVM41WIIIUzmw9wkPISQspT1qnT1xHbmSF5LU=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1b18:b0:67d:ec7b:cc9b with SMTP id
 006d021491bc7-69462e54ef1mr3090164eaf.16.1776479754941; Fri, 17 Apr 2026
 19:35:54 -0700 (PDT)
Date: Fri, 17 Apr 2026 19:35:54 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69e2ee0a.a00a0220.1bd0ca.0035.GAE@google.com>
Subject: [moderation/CI] Re: rhashtable: Restore insecure_elasticity toggle
From: syzbot ci <syzbot+ci3f3836f6436f8ff4@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] rhashtable: Restore insecure_elasticity toggle
https://lore.kernel.org/all/aeLgjAeJuidWNy3N@gondor.apana.org.au
* [PATCH] rhashtable: Restore insecure_elasticity toggle

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/43c0803b-4513-4474-86b2-94c9aade1dbf

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      eb0d6d97c27c29cd7392c8fd74f46edf7dff7ec2
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/ae1f60dc-d352-41b5-a103-69104326b61=
9/config

./include/linux/rhashtable.h:824:32: error: member reference type 'struct r=
hashtable_params' is not a pointer; did you mean to use '.'?
.+./include/linux/rhashtable.h:832:13: error: member reference type 'struct=
 rhashtable_params' is not a pointer; did you mean to use '.'?
./include/linux/rhashtable.h:832:13: error: member reference type 'struct r=
hashtable_params' is not a pointer; did you mean to use '.'?
lib/rhashtable.c:541:31: error: member reference type 'struct rhashtable_pa=
rams' is not a pointer; did you mean to use '.'?
lib/rhashtable.c:572:12: error: member reference type 'struct rhashtable_pa=
rams' is not a pointer; did you mean to use '.'?

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
[arighi@nvidia.com changwoo@igalia.com emil@etsalapatis.com fw@strlen.de he=
rbert@gondor.apana.org.au linux-crypto@vger.kernel.org linux-kernel@vger.ke=
rnel.org neil@brown.name netdev@vger.kernel.org sched-ext@lists.linux.dev t=
graf@suug.ch tj@kernel.org void@manifault.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

