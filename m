Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FBD62DE70C
	for <syzbot@lists.linux.dev>; Fri, 26 Sep 2025 16:52:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758905548; cv=none; b=BkbCutFk0lNscMEyvZlztJw85NQ9WLb8nk5M55DWduKaeIWLvXiV2nWpcRPjqS9bt4Q969cFJwRHkttLkS7X603dFsRyjaJwG/8+5/kPJ3W7ZceqMTSLA2z+A45/LPMz3NniFyUhgMbe9bbJ2H3S/5BY5QBFCh+k9e1Nvm4pxX8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758905548; c=relaxed/simple;
	bh=Y4DCFB0DEhYy0uV1Z5Ko/SbRADm6TD7un5y7/6WUigo=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=fWsbF11+0VOwCLoURTM5HddkXyhMrg6gFuINlTnofe166QJ/pRLQlt8qVZ/1z46VoFW9CONhf1XrcDo/vMV5dizcx0rV2vlmf7aNssjF74GUR6Vd709oD+H9z/puS/7gonq8GzzkYqJV9nZ3zP6c4WLNKbZZbEGFL7dRh8OfzS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-42486f6da6fso34250245ab.2
        for <syzbot@lists.linux.dev>; Fri, 26 Sep 2025 09:52:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758905545; x=1759510345;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=4lXckM/12GHC6qMIc4AbTjXiBEnwmyDjCVu/mYQztNY=;
        b=ZgfObDjFMyaIxt9hVT/ONKydNkONFzQZh7JJeHcYR12Du3n/jvvu5gioycNmJraajT
         Q6knTmvd+js6jTJ6N3z5ZQQ/CFrwWdqpwKxOscAAYh8aJuQ86RDlCCIodAmaFXKcbvOi
         xJcIolswPkYuVJvR4eTivvgr7LuWxmt7l7zMwrWJ4kWEY74J6cExIPQAovDXdB0wXLJb
         ZgAU7kE8eqEN+xQgDGJi4WxvUa5Z9p2IoEXw17/3GVz/FwtrtSQfA+ZUZAsKDpsbQAU/
         3usrdzxjF01BC6IWEi4l0Zy6oQsqnes/PMbbmGUhHvb7fD6IGKiTi+YDjvJ9aKmdYuK+
         1Pxw==
X-Gm-Message-State: AOJu0YxHWBaG9oPI2n3R6t/73pk8FMZS1MfF93fJ7Cq9rQSEPLAbZHww
	xq+RxZ8mUfEAHYsHcWQHNK2l8o+5YJWvns5TX1W1YdCzeXsQAbuKXkSfRACsRdVKzepfIm7TNFK
	bhaH3BZG/0XS2g9IqCNTlxg1PGJ3Q521vhKfWAT9R9k6YEW+nGkfgQU51QGs=
X-Google-Smtp-Source: AGHT+IFqKu6EqXSBUptpG+r0eOGOQerURqc5naXy71+LlUqhRTWP1eT7vJGe7hE4Llsh5GpajH8NB9IzuHq5E1srYqiO3iJUaS+y
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:2706:b0:425:8d77:547f with SMTP id
 e9e14a558f8ab-425955c4eafmr104112435ab.5.1758905545415; Fri, 26 Sep 2025
 09:52:25 -0700 (PDT)
Date: Fri, 26 Sep 2025 09:52:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d6c4c9.050a0220.3390a8.0017.GAE@google.com>
Subject: [moderation/CI] Re: mm/swapfile.c: select the swap device with
 default priority round robin
From: syzbot ci <syzbot+ci0b96ae7dfe16e38a@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] mm/swapfile.c: select the swap device with default priority round robin
https://lore.kernel.org/all/20250926155504.5122-1-bhe@redhat.com
* [PATCH v2 1/1] mm/swapfile.c: select the swap device with default priority round robin

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/4cc3b2a6-ba4a-41a8-bb50-f8ffc773fb00

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      07e27ad16399afcd693be20211b0dfae63e0615f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/54c56b73-e7be-4d82-9f9c-acce5c5eb5f0/config

mm/swapfile.c:2550:24: error: use of undeclared identifier 'swap_active_head'; did you mean 'swap_avail_head'?
mm/swapfile.c:2655:27: error: use of undeclared identifier 'swap_active_head'; did you mean 'swap_avail_head'?
mm/swapfile.c:2677:23: error: use of undeclared identifier 'swap_active_head'; did you mean 'swap_avail_head'?
mm/swapfile.c:3835:28: error: use of undeclared identifier 'swap_active_head'; did you mean 'swap_avail_head'?

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[aaron.lu@intel.com akpm@linux-foundation.org baohua@kernel.org bhe@redhat.com chrisl@kernel.org kasong@tencent.com linux-mm@kvack.org nphamcs@gmail.com shikemeng@huaweicloud.com youngjun.park@lge.com]

If the report looks fine to you, reply with:
#syz upstream

