Received: from mail-il1-f199.google.com (mail-il1-f199.google.com [209.85.166.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F49223AB95
	for <syzbot@lists.linux.dev>; Thu, 27 Nov 2025 02:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764211216; cv=none; b=TWMRxfNhszbrNeL5VD+bWkCbYtWYJcVAGeZ1jQ0SE2MIju8jfGn7goVWZpayijruI+4cksakhWpz1aDjBwTIt42i1jAypl9oGRjrRh1Fc8ZrD66RmUpp87FckvfpO97rRUqtI+lxBfn0xXyyXKOiv6I3NipJVoVN+kHzVjxPRO0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764211216; c=relaxed/simple;
	bh=lC9RQ6irwa54dKb5hEZUwiDQc6qZqThN6SpoIHLcsYM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ppF5GJUml8MWRlFAWOaFa/AGowVTcgyiAZBqBL92XgO+lXk40bTqWw+JIf13nBRceHJi5XS94/nhFL7PuI0AqJeQBznz1kDz78P1fqi9DeNgcwW0Kwr0y9bLhgXmQwlLdbPThyJD5l/5evrPS5IpJsZ9DYRWAR4QyZZzb7a2aCE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f199.google.com with SMTP id e9e14a558f8ab-4330ead8432so3404575ab.0
        for <syzbot@lists.linux.dev>; Wed, 26 Nov 2025 18:40:14 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764211214; x=1764816014;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=G3KrKtu2vt4/kHkQ+6I4eHXzTWgAJ+hjc9+SYbRQY90=;
        b=rWhrtGY/5CQX3wZvZRR2mXOOMjFKI9xdxmbxkpN8Y+xpB6zUoc1TflvviTmYNpqKMw
         SexhttPCqHTXp7MLBw1CEr/Sz7DLEMgyerLdEp0vWw1jPbY7HZRWW3u97yBp65/qMzoS
         MgjqJsfKFWTvzeoLu7+HXQYlbhWORgaE2LD/f/1XwTpEZn3BA2Jr3oAd6xqqynqtROf7
         k5eqQvSCZM/yH4lgp66SpJVzexTUDKYoaDI1flHLVolDcZNWRINUbWkylf7TrIy1sqhc
         2x+XI32XzS3DuoEsxLpDUBuZfX9NVN8Iq++Ypbn6fwMpG7KfU2izLF0y9PIKadrr/PxE
         1OMA==
X-Gm-Message-State: AOJu0Yx/doUWNA53ycR6Ec23IC1D40EyRD9vaa4ehLcalro79qp2aDIH
	b3e8dHayd1cg3eScZi9PtU29AoxcuiCpp+NATJmYfOFP4/rR17UY0eT+wHHJjzcWVQqpGNLVJK3
	gnXtot6uPYGcjBWZ4Dygwcmh3ijnO8+TJqPbYUvYR4m9HmuOC9JGZsSCMckE=
X-Google-Smtp-Source: AGHT+IFapDG+BAY4pOzeGBeAoIZr/bu3Yc03dfm4kyTFrY4UuLekJEeaARuiz+MstKRUJH6mN+83yQY0SOELgJyXpcDg0Pkali13
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a49:b0:434:a78e:f6f0 with SMTP id
 e9e14a558f8ab-435dd07483cmr78841295ab.14.1764211214137; Wed, 26 Nov 2025
 18:40:14 -0800 (PST)
Date: Wed, 26 Nov 2025 18:40:14 -0800
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6927ba0e.a70a0220.d98e3.00ea.GAE@google.com>
Subject: [moderation/CI] Re: blk-mq: use array manage hctx map instead of xarray
From: syzbot ci <syzbot+cibefc566da4f5c17c@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] blk-mq: use array manage hctx map instead of xarray
https://lore.kernel.org/all/20251127013908.66118-1-fengnanchang@gmail.com
* [PATCH v2 1/2] blk-mq: use array manage hctx map instead of xarray
* [PATCH v2 2/2] blk-mq: fix potential uaf for 'queue_hw_ctx'

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d5880bdd-81d6-4fce-8444-e63cc81aab91

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      4941a17751c99e17422be743c02c923ad706f888
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/e158b2bc-0c62-491c-9385-3853a7d6a687/config

drivers/block/rnbd/rnbd-clt.c:1324:2: error: call to undeclared function 'queue_hctx'; ISO C99 and later do not support implicit function declarations [-Wimplicit-function-declaration]
drivers/block/rnbd/rnbd-clt.c:1324:2: error: incompatible integer to pointer conversion assigning to 'struct blk_mq_hw_ctx *' from 'int' [-Wint-conversion]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[axboe@kernel.dk changfengnan@bytedance.com fengnanchang@gmail.com hare@suse.de hch@lst.de linux-block@vger.kernel.org ming.lei@redhat.com yukuai3@huawei.com]

If the report looks fine to you, reply with:
#syz upstream

