Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 41E112741A0
	for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 21:06:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758834411; cv=none; b=YaIMyEE7kbL6cp59Iq/nXPCgDjIt2fIHSBFyVM1zUYJHZ2uwE9fYnCLHLrIezo2b+dGETZyKtOh6mZiILWwB2L1QaX6EIhB+ZEaxXunkNqY62nV0Nr/cstR5H+NI7SlWybMUUsadVC6LkxwlwVaE7nbeaXxDDg9uuZPcpyML4Fw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758834411; c=relaxed/simple;
	bh=+w+qdEoWQ1R2rgReQ4IhudroyDq+X+4+Xc4dHpcACzI=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=kr49A1B0eDLojSuRgEYDNl4tLgQ5/23FheXdVqHe9YqEiHzbD5xoMb48wWLLuWclZPiklr2RhGnKmHRSJ+CwjturILOpqWd3XbuMka/i3O51kvb6DvMBMaoWJwtbGzfavQyYewPcQQfv1y4k5CUY0pjem+1A0ttxSHJTlQ3zTKc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-886b489984cso281198439f.0
        for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 14:06:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758834409; x=1759439209;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=Fv79g2E8KXfLwQqD7s385jEpGi1SwHV1FhuuxiinpRM=;
        b=ClpRzevVXa4SUveCpkhECAtyiz3fcMvMp7Kh4OWQC44rZ1TvzYs1kcR+aTG73h3DkP
         3eYS/0ouH1dm3ummTpKIC+NaCWMwEZ33QKpYbsj73HMhTuSUvz2EqJtwzXLHAF4AsEXV
         K12Uq3cr16NtXnmUGMkXfCEEEdv7EVrSLN9JTpiYQXTwoebCWujCHnt3I1u4PqpslFX0
         O1zws+9fvUJ7faVDHRmXeB9kzsKLeWlR8SZDqiAfWDPJH9FYxPDdIbUvVWLf+p69hjFq
         P3n5VdBdekaP7J9He5SkEvjFOyABMudil9rxug+m7r7seooX9ehFwwVWp0jxFY3PzHof
         63jQ==
X-Gm-Message-State: AOJu0Yw1I2FJG8jsBIMO0gc34C3EYLMv0hzTyd8E786ciqMF/V1sZ7iN
	9OJxORXR1b8mO8zYCVya6SQXU58wKjogDF9KFGvOPY66UgLLtL0glRMU4w+Xd2bgeEoiWwULWDP
	70C2LUv4AngOnP/pwkUVKptxJdFybVkT4DsEnu0cuKbGFQaKCekpxexVqFqI=
X-Google-Smtp-Source: AGHT+IGsLaZS8VknIRu4I+IiUzCwFepVIIzy5B7otWpAosET5cs+1XLXxbyE2jMygx6/b0ue2EYBuZxmGwSFoxb+FmYjNP+dFm+b
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:180a:b0:425:7534:ab09 with SMTP id
 e9e14a558f8ab-425955bcf37mr68696405ab.7.1758834409418; Thu, 25 Sep 2025
 14:06:49 -0700 (PDT)
Date: Thu, 25 Sep 2025 14:06:49 -0700
In-Reply-To: <20250925144934.150299-1-kartikey406@gmail.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d5aee9.050a0220.25d7ab.008a.GAE@google.com>
Subject: [syzbot ci] Re: hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
From: syzbot ci <syzbot+ci74a400bb557985f4@syzkaller.appspotmail.com>
To: akpm@linux-foundation.org, david@redhat.com, kartikey406@gmail.com, 
	linux-kernel@vger.kernel.org, linux-mm@kvack.org, muchun.song@linux.dev, 
	osalvador@suse.de, syzbot@syzkaller.appspotmail.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
https://lore.kernel.org/all/20250925144934.150299-1-kartikey406@gmail.com
* [PATCH] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list

and found the following issue:
WARNING: lock held when returning to user space in hugetlb_vmdelete_list

Full report is available here:
https://ci.syzbot.org/series/7d3a090c-ec8f-4d0c-8f7b-8797e63f1fde

***

WARNING: lock held when returning to user space in hugetlb_vmdelete_list

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      07e27ad16399afcd693be20211b0dfae63e0615f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/06671e7c-eebd-4d11-9f0d-d9dae5637c0a/config
C repro:   https://ci.syzbot.org/findings/75fcdb87-67fc-45ee-a70d-3064e8c1126c/c_repro
syz repro: https://ci.syzbot.org/findings/75fcdb87-67fc-45ee-a70d-3064e8c1126c/syz_repro

================================================
WARNING: lock held when returning to user space!
syzkaller #0 Not tainted
------------------------------------------------
syz.0.17/5991 is leaving the kernel with locks still held!
1 lock held by syz.0.17/5991:
 #0: ffff88801f7dcce8 (&resv_map->rw_sema){+.+.}-{4:4}, at: hugetlb_vmdelete_list+0x67/0x230 fs/hugetlbfs/inode.c:490


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.
