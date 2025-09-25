Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9D6D218AB0
	for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 19:03:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758826997; cv=none; b=PBXqe3pdgKXbGQQAn+5J8uwz/+V9h++5DGcv8YKAp6iTsO+6nP9giKyFpEqQwr03T1LKPtc/mZEXGlYWRo0fT/Kg+QBa9tRBv43YtoArS81rG0Fcx3H0/uDuPXZHM1MacH9Kb8kCGi2hauibHgB1o/qIXU4PFGEOhOfIp9Dmzdo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758826997; c=relaxed/simple;
	bh=0/fXpnoa3lzyyIWKQUlpSQ+DHW6mVazBuqwFERZ55oA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=UTmk5PGEl5+1eYVjUn+39OMbdOcRubhOgYXEhiFC8u6ZOc51rF1RA3FH4rm+qT7oKsqqYqTGZc7PZFIS0Zzw+RW2mrdlDEjCHXgN4uFyMLMYm0HlvRc7+5ktPkCnzhsnZ9x6cp7JmAxGBuBEwPvYOe9VGLGKu87+UL81WdFCPno=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-4258a5580edso28154465ab.1
        for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 12:03:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758826995; x=1759431795;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=oEIBBFf/ugJNPgM1o8K8WetvijSmzO2RPXQDd9wLrUA=;
        b=JSEO1DYCfT2pUcHFHxT2XyWi12H/Tge7rwu9VqyP9MSCy72142sVv0DatXIIEFzPgG
         l4ghsgUbcMUySALhxpJ3W4F76wVopw3Mmq1grbHA0cMQ5p/R3HSOZdXNbhRJXzJPVRVL
         RYB86AxFKYC+YixbqqqpucfrX2opy48m7modFM97ZKwr6aoa/b4Ut4J/Xf0y+198Es5C
         PTDomHQClcbmHrfLejoEAkLlL8dUHTQNEJp+VOM+2emx9knCOaQusad3i4QzZc7O4wR/
         YHfQPM1XtHT05mf2IUKH2LLY9zo5uZAKS0/90aOdxcRp71yl/uJ1a2RJ+KGTlBENHvw3
         s2tA==
X-Gm-Message-State: AOJu0Yx41L8xVas/dtPxkaxKlNRXBWWOfo11bsufRxq0KwYaVpGHsygN
	hHuV1F5Jmrs/ntsic0SGfRn3WY4/i7v3ehmAPkK87ZhYkvsrdr4blUsINTKNe5e9t8HttyfKXIa
	x/HOFiNeUX+CWntJGE3YLpLMCsgSzUCKqw/jS5XvFC9ytDVPy08Oaw1KF56g=
X-Google-Smtp-Source: AGHT+IH6l/bbMTgNmNT1x8pixwFb8ncowDJR7OY+5S03vyYcmFbOkoy+IqxqBww21bw7rENSOs9mHDLQB3Aylqnnrm46AOW9CiOI
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:16c5:b0:422:a9aa:7ff4 with SMTP id
 e9e14a558f8ab-425c2a27af1mr48794385ab.11.1758826994939; Thu, 25 Sep 2025
 12:03:14 -0700 (PDT)
Date: Thu, 25 Sep 2025 12:03:14 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d591f2.050a0220.25d7ab.005c.GAE@google.com>
Subject: [moderation/CI] Re: hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
From: syzbot ci <syzbot+ci881631e3b1154987@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
https://lore.kernel.org/all/20250925143312.149623-1-kartikey406@gmail.com
* [PATCH] hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list

and found the following issue:
WARNING: lock held when returning to user space in hugetlb_vmdelete_list

Full report is available here:
https://ci.syzbot.org/series/f0860e54-5be0-4511-bb04-fbd5a7d7a4c7

***

WARNING: lock held when returning to user space in hugetlb_vmdelete_list

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      07e27ad16399afcd693be20211b0dfae63e0615f
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/f58f7b55-7489-4b00-ae8d-a748a39e1223/config
C repro:   https://ci.syzbot.org/findings/7a1b33ec-cf07-4a12-8dd6-bd9edef58501/c_repro
syz repro: https://ci.syzbot.org/findings/7a1b33ec-cf07-4a12-8dd6-bd9edef58501/syz_repro

================================================
WARNING: lock held when returning to user space!
syzkaller #0 Not tainted
------------------------------------------------
syz.0.17/5990 is leaving the kernel with locks still held!
1 lock held by syz.0.17/5990:
 #0: ffff8880218488e8 (&resv_map->rw_sema){+.+.}-{4:4}, at: hugetlb_vmdelete_list+0x67/0x230 fs/hugetlbfs/inode.c:490


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org david@redhat.com kartikey406@gmail.com linux-kernel@vger.kernel.org linux-mm@kvack.org mike.kravetz@oracle.com muchun.song@linux.dev osalvador@suse.de syzbot@syzkaller.appspotmail.com]

If the report looks fine to you, reply with:
#syz upstream

