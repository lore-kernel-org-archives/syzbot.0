Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E423321440
	for <syzbot@lists.linux.dev>; Wed, 27 Aug 2025 08:04:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756281861; cv=none; b=UuuCSZYDwUfF63OR5650dbs2/QWoUIsmxg1P7ezRUyoacoetoRGVl19oSfaM/CyxqNreHndYyKN/y+c4VdSdd6XJxse71yskvkUh7CbdpdO0kOh1oSrNpn0EniTDENC4OhgYFPRm/phNVekKx/bixqVgP9Yxkk7YZIvMbGdxUyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756281861; c=relaxed/simple;
	bh=7xLrcBkBTmA2lIZhiUlvappcsDiDALUHmU9Y/Wsd6XY=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=TK5HQQAd3HPiBqBqMWlQzfG2nDZnnSnnaPSSj45DpoltGwfAHqftyebZ6cz6kOH48Mf8rc6tGwHHZWqMmsGi5PquersG05drVvPiZ/0nGk0lNufQGQUeijQE2zTKHlgkOEMWEwA6SIKmamWSw4MKxdG1PUferD2v2axUyFV49xI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-886ca8326a0so324179239f.0
        for <syzbot@lists.linux.dev>; Wed, 27 Aug 2025 01:04:19 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756281859; x=1756886659;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=sxHVcr4q8V65jOks9gvpvjpFTK6bX/1oFkHWPN7MfB4=;
        b=S3/Sx8m8kmCTOAPwBNUMfQv3ZkSXwIgY9BNxXtX1jbGK6qkUPMeNQRR9Q0MhX02JhT
         vGSPeHhzuOm3dXqvcjsImBnU3Cw96+LrQs/cwxsrDIUS72bgxBsOlTMcwfwhYsbOi5PW
         p5Eauimwan91uu+WpdKFrpx/RPkkIbbz41aNVnV6I/jWXI5WluU7QdYAjlp+KQKUjuBZ
         +oIxMqpJMtEky5x9M2WC1V5qScMsQuUfyEF+12EtipJEJbqwHJlmuz8zU0qL/lmRzS0c
         +lxbldME6muEmGi5yT6oigqx0xWzGc+W2W7bpfU3V44KZ/KliyFXympzlmrgYEcbANCZ
         Qc3A==
X-Gm-Message-State: AOJu0Yyg6RBKe9ypUyKOV5MOfoLotKizZLEpVFq7CRk26LZD82nYcbD1
	dLtoxHt051nZJuYn70KAeOkAWUHYBx1GI4OqA8kwBRUsj2MOrzjJIgPs9BhvtZmy0ZLdUhKECH0
	lurHI27LHsZNc0JracU2cbsHgAX7jHva0rs5voOBPyG0Ibxq9QjSD5ONWfHY=
X-Google-Smtp-Source: AGHT+IHhTwG0d4J0fjUNtwRBOjl7Sf7ZYgYFu75g0ggmHbkHH+IjWI0x0MYkDpsUbdwmXSGTZ8usiwut0uIHikTdLAQYfm8aZPmW
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:144b:b0:3ef:d9e7:70e3 with SMTP id
 e9e14a558f8ab-3efd9e77277mr25670685ab.29.1756281859240; Wed, 27 Aug 2025
 01:04:19 -0700 (PDT)
Date: Wed, 27 Aug 2025 01:04:19 -0700
In-Reply-To: <20250827021121.13645-1-richard.weiyang@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68aebc03.a70a0220.3cafd4.0012.GAE@google.com>
Subject: [syzbot ci] Re: mm/pageblock: improve readability of some pageblock handling
From: syzbot ci <syzbot+ci5d256d8b5e60a751@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, linux-mm@kvack.org, 
	lorenzo.stoakes@oracle.com, richard.weiyang@gmail.com, vbabka@suse.cz, 
	ziy@nvidia.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] mm/pageblock: improve readability of some pageblock handling
https://lore.kernel.org/all/20250827021121.13645-1-richard.weiyang@gmail.com
* [Patch v2 1/2] mm/page_alloc: use xxx_pageblock_isolate() for better reading
* [Patch v2 2/2] mm/pageblock-flags: remove PB_migratetype_bits/PB_migrate_end

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/51db4b94-ae73-4ea0-8cf3-4ea5b7715cf1

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      fab1beda7597fac1cecc01707d55eadb6bbe773c
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/49ee15fe-3add-4064-a3a9-1461fbba8c85/config

mm/page_alloc.c:373:2: error: call to '__compiletime_assert_1636' declared with 'error' attribute: BUILD_BUG_ON failed: __MIGRATE_TYPE_END > MIGRATETYPE_MASK

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
