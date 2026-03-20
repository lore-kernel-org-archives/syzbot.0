Received: from mail-oo1-f71.google.com (mail-oo1-f71.google.com [209.85.161.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 089F531619B
	for <syzbot@lists.linux.dev>; Fri, 20 Mar 2026 05:48:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773985692; cv=none; b=kSdtXUEpWNFd58Y6MlCuRmnVGUCkEzbQO7q+dZCTjGfcVe2ArIHXWLlLWxJoM4kk6NgiOSfDlhgj/uyrWeOlii0o5fxQ/A8DOgnM+/dorYeCrqk1BdrTdc+7RJX7msd63Q+m4ZT2hD7oNX2LN0Y5kDp3YS3FJjtHISQRqILA9K8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773985692; c=relaxed/simple;
	bh=PJ/3gIUBTYe8fGrg0My3I/P2mjJGt61C3hvYC5Bpc/Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=P8LElMxNfPT/4voS9R8XMI6wJXjVeFoNREpXWy25m3WQcbVWqlDsp/5lKVhX284G6GZZEPy+GJ3revDV8MOx6ym4lmt7ck6OotKYnbsBWBQuFpCdTDHu4k+RVFfqnN5HNk+USG3KHAIiD6qE3vqOsXJDFEK5VEnL5KPaNcxid10=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f71.google.com with SMTP id 006d021491bc7-67c2817bfdaso4447615eaf.0
        for <syzbot@lists.linux.dev>; Thu, 19 Mar 2026 22:48:10 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773985690; x=1774590490;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Mh2TUoPvK9N2RoeOxPFUSpDA2pTVhhnzenYzkIs/qvg=;
        b=aZxbkVM1MVXR2WAKYfuSA7DpW9izC/RpvkhxTUfsryFGB7Kp9MlI6B0QzJMYm9wWa4
         x4JDgRnoP2sGi408QMeDDqu2V1PrfQU3RYg0oqh2Xeyj7nJLAgA+Kq4ndxuEIzPQ03Vi
         Uhu1pX1m/04a/2ASjLazKCypVMpiu9zEW/JZeglQtrmnHtfhVzTnIMjgOGSMqmRGOUOO
         08aKqq17HoWFlhjU2h9MGG5sSnF/msTU/vUj/1ykjVXgbdTYxmjrXbNw+hhDWIFL5hsi
         Iz8GODdLae5n4RdU+PmdFfBd3q5X1aATKkxpAuAW7uUVhSX6tp8xfldn86BzbjM5rDSS
         v/jQ==
X-Gm-Message-State: AOJu0YzLsghbfrnaztsUzhJQbkLanbn+e4OuPvPCpVKNgK7+o8f4k5L7
	RMyazj1yoEItGwZhzJswaG+HTfkLkYVflNcG901p9ByYgY1AtNNI1K2H5vN9pzdwGw3iO4lKhyk
	CPlWW7bmLxRUqHYwgeLyvr/LVD8rP/jP7VhBCSUvx63bZ3r6X4Y2Su2P7sbM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:606:b0:679:e7b2:9fc6 with SMTP id
 006d021491bc7-67c22ef425bmr1530877eaf.3.1773985690073; Thu, 19 Mar 2026
 22:48:10 -0700 (PDT)
Date: Thu, 19 Mar 2026 22:48:10 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bcdf9a.050a0220.3bf4de.000c.GAE@google.com>
Subject: [moderation/CI] Re: exfat: add limited FALLOC_FL_ZERO_RANGE support
From: syzbot ci <syzbot+ci46232943661a65b8@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v0] exfat: add limited FALLOC_FL_ZERO_RANGE support
https://lore.kernel.org/all/20260319043553.301185-1-dxdt@dev.snart.me
* [PATCH v0 1/1] exfat: add limited FALLOC_FL_ZERO_RANGE support

and found the following issue:
WARNING: lock held when returning to user space in exfat_fallocate

Full report is available here:
https://ci.syzbot.org/series/a58a79c9-a4e7-40b7-a5d3-8d4da244a00c

***

WARNING: lock held when returning to user space in exfat_fallocate

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
base:      b5d083a3ed1e2798396d5e491432e887da8d4a06
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/6a43cfef-5b9a-4b39-a6b0-7d34bfb0f7b7/config
C repro:   https://ci.syzbot.org/findings/87d27fd2-e5b7-4174-8faf-3b746f7aa18d/c_repro
syz repro: https://ci.syzbot.org/findings/87d27fd2-e5b7-4174-8faf-3b746f7aa18d/syz_repro

exFAT-fs (loop0): failed to load upcase table (idx : 0x0000fd4f, chksum : 0x395e47cf, utbl_chksum : 0xe619d30d)
exFAT-fs (loop0): valid_size(150994954) is greater than size(10)
================================================
WARNING: lock held when returning to user space!
syzkaller #0 Not tainted
------------------------------------------------
syz.0.17/5982 is leaving the kernel with locks still held!
1 lock held by syz.0.17/5982:
 #0: ffff8881bc75c110 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: inode_lock include/linux/fs.h:1028 [inline]
 #0: ffff8881bc75c110 (&sb->s_type->i_mutex_key#24){+.+.}-{4:4}, at: exfat_fallocate+0x163/0x4e0 fs/exfat/file.c:131


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[dxdt@dev.snart.me linkinjeon@kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org sj1557.seo@samsung.com yuezhang.mo@sony.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

