Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B6A36F401
	for <syzbot@lists.linux.dev>; Fri, 20 Mar 2026 08:16:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773994608; cv=none; b=GEs3zXLSpqGjYhuuMzILXzllfCh/WVTl3eWUg3zT7/Af1FW0JkiqsvumsJiUOg0AI856rToMdLl65Tzp9KYwUJBTZPbxxkSDV2i0MfOk/eKa4A3a6KC+f0My1fS3qflEHh+f6ocZaA0kLBCZMBxpyusNMrCcKVP8SKVu4859PVE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773994608; c=relaxed/simple;
	bh=bjrJ4S/FsINr/81pbIi6jj6PljV4RiGl0H45oSmv7pU=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=FWQTwHSOLfFHn+8FfzxvNtjpKrZ6VzG0PzOHQhr8g+z85CiJN9DwYV/gkUsdp98QlXQCYKx/R/NxxUUg3/S0wO4JAWgVLFq/VKyBKO7CQ5BC+0qmkmFBkSvvvwKyKUa15eSNjW5u09R6EOix5XkmNqlnVjb9ylc5OmL9YxI8jiY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7d7e9eefb7aso4941102a34.1
        for <syzbot@lists.linux.dev>; Fri, 20 Mar 2026 01:16:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773994606; x=1774599406;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=GaqbpFLjq54QozbnajqIPY0nFpUhUrZICyVqRPZuQEY=;
        b=I9LTI/IyJNrxftFgrCV1P4czemkF949jYSoMray1eIKVhYW933q1Tt1djtnCV9RFSL
         1GpH3OSTzZLTpAB2cx//EfvRlX0ep9/Ks647r66ssAxx0YeEAwnJ3vM/jCCz+lSMaj9G
         9MWm7peyeYmZkIlYkZ9D7w9EDCRIjyx/7wu+wcLTV04Z7n1OWIG+oTczxibyk/Gdm41V
         q4V+4rRoO6uYgoLbJuizD3zcnfqVZZ5beWPxMzEGhPDvPc6E4y8rxuW105oAUJ5t6Lul
         ESyKnOv6q6loRfSp1Xhhe3Xp63tA1vop7WkL6urE100JC/Zh95bLDRYm9Q0osiCc1aTx
         +/0g==
X-Gm-Message-State: AOJu0YwWl5CnECJeoHZ3b0mwGKZJAyahPZks2x1v5kNEgvghVEUj/jYA
	TK98+gNyskQ0IUdMu0i6AcrqidbHDsP+Ts14mQFvP6+YOM6b3BEG7s15VPoho0lnbG2zo6P2eBn
	Rb+4hJWQHXvOk1RiKRWkXKwm3+JzgDCoJyKK1f7GqXiLjxkZnzfUh3P14+7Q=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:228f:b0:67b:c536:c629 with SMTP id
 006d021491bc7-67c22bcc8e1mr1309137eaf.8.1773994606490; Fri, 20 Mar 2026
 01:16:46 -0700 (PDT)
Date: Fri, 20 Mar 2026 01:16:46 -0700
In-Reply-To: <20260319043553.301185-1-dxdt@dev.snart.me>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69bd026e.050a0220.3bf4de.0012.GAE@google.com>
Subject: [syzbot ci] Re: exfat: add limited FALLOC_FL_ZERO_RANGE support
From: syzbot ci <syzbot+ci684179a8afcfdab1@syzkaller.appspotmail.com>
To: dxdt@dev.snart.me, linkinjeon@kernel.org, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, sj1557.seo@samsung.com, yuezhang.mo@sony.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
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
