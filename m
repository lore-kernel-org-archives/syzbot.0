Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com [209.85.210.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CE9B2282F22
	for <syzbot@lists.linux.dev>; Wed,  8 Jul 2026 05:15:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783487748; cv=none; b=ODhwJ/AlAKbw0b6JLwcXOAewUS3vt1qSr8rvWgAz6QoG+08IoofRm0GyZay2DjLNUZReLqwK5PuL0W835s1JMPEdV/BuOtpFxFgnzcQb0GpMImc4ezfiAGifWwi7A8/5LC9YvJ3jOZBUrd90k7lFxfQZYYDdgxqTYqeQ7RZwK98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783487748; c=relaxed/simple;
	bh=TYShccA+atQMIRXFEa7wHlz66yRyJvBMq4eQjdGqzaM=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=Xl3qQbK/ejmZfrs9za2ZeP4YZFpS3rPRjqjkbMWhvvuTXUQlZerbA/XPNtXiyMuDUtCcb1m3eIVIyO8fr1J9l4C7EgpMZJkcCiVp0CxAAdOQl64kupNiGdnZTHCHtgcMOO6jEnWNWvpLFOq/9ArwovZ7FRoUt5NhowoLNeqjNSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f69.google.com with SMTP id 46e09a7af769-7eb64224fd2so589304a34.0
        for <syzbot@lists.linux.dev>; Tue, 07 Jul 2026 22:15:46 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1783487746; x=1784092546;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=6tFZAUEtPbQzMW1w0OE6PtkS+bcaSV4QJPpmtj3DWDY=;
        b=j/RpqS4lO8awOV8RwkfnK4Y+oNk4AkZBS36kldMLMysEASzbEaVrcVz66gbzeTHLUn
         RC7fztWtd3WQq0q4ADPksus8F8uTpwXZvI+wZa8d3qlIj0bp/Nz7Y1HXApjmrq/F4l8I
         AO+GHS3mvTao4NcovNfMhDoGNlvdWBqrb+gPNXCp5o5FeRKkYuVcqtJ7XIfvg9j90ulg
         YZbPuX2O1S8URccvICWeroxl9u0mlcjP5y45c836tZdvXnLCLnEyJLQymPzXRKg1V3jJ
         C43dIlCgcEzOZuvztGApuim1FQ8oFE5TOLgIabTLjLXctBtcqNfGt1HR0xZnrfTs8qo/
         fSiQ==
X-Gm-Message-State: AOJu0YxWnXH83AIg0BqFi6Gsu8wePMGvt34W6ON+hqFIAmco8fUqJnH7
	UZB4Q07ytMhr83qYmi6yIi9l2oiKDEpRxtzkpLGaDO8waRXeLmbIQypEydSFk8L7lruRKSyxblT
	mZXJB3i9zs022xMzUTl4EinhdHLfdNzohqx1YMA+taCp+4t9b0nikdSptX/w=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:3084:b0:6a1:7fa0:114e with SMTP id
 006d021491bc7-6a36dac4d25mr745574eaf.64.1783487745704; Tue, 07 Jul 2026
 22:15:45 -0700 (PDT)
Date: Tue, 07 Jul 2026 22:15:45 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a4ddd01.c76b52dc.34afef.0019.GAE@google.com>
Subject: [moderation/CI] Re: Use generic_file_read_iter() in hugetlbfs
From: syzbot ci <syzbot+ci1e2eddc000ed3010@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Use generic_file_read_iter() in hugetlbfs
https://lore.kernel.org/all/20260707181713.208282-1-willy@infradead.org
* [PATCH 1/4] hugetlbfs: Set mapping folio order
* [PATCH 2/4] mm: Handle hugetlb correctly in is_page_hwpoison()
* [PATCH 3/4] filemap: add hwpoison handling to filemap_read()
* [PATCH 4/4] hugetlbfs: replace hugetlbfs_read_iter() with generic_file_read_iter()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/5869d756-5b77-45e0-b5c2-de0fca422e49

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      dc59e4fea9d83f03bad6bddf3fa2e52491777482
arch:      amd64
compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~exp1~20260514074407.73), Debian LLD 22.1.6
config:    https://ci.syzbot.org/builds/074ace85-e34d-4e22-a00b-a735d5f0684e/config

mm/memory-failure.c:1841:44: error: passing 'const struct folio *' to parameter of type 'struct folio *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]
mm/memory-failure.c:1846:35: error: passing 'const struct folio *' to parameter of type 'struct folio *' discards qualifiers [-Werror,-Wincompatible-pointer-types-discards-qualifiers]

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
[akpm@linux-foundation.org david@kernel.org jack@suse.cz jane.chu@oracle.com linmiaohe@huawei.com linux-mm@kvack.org muchun.song@linux.dev nao.horiguchi@gmail.com osalvador@suse.de willy@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

