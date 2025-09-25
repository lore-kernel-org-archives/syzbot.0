Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0156A25A352
	for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 19:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758828199; cv=none; b=pThhQ/NqHw8xuOYOx7vLVFAdcY1euzGVPW2jH6RfYge9KX9pI+kRqkA3DZJKXcWkZnTtmSN+lgj9Tlhr9KGgW3qFxxlqqKskPqQ4D3cs8WwOnV+MRI0A2EWZzboq4Habw9h5T8RgFSpHvFQzlBBUVZA5HGUdB/nQhCl5t2Yj5sw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758828199; c=relaxed/simple;
	bh=qIfb8UcmcshVhKKMrMgaBhBIdpUq1ZhBzc1uepQxlOQ=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=ikrUC1Kw4JfAg77WPnO6+ksOlcRmT8J4XDs+UOnu/GyuGDeCt9cyqGM6aUkkM/UNaW1XOnqxCB3tNm0xtClMNxGbm4bPWCs7lqJ1sQFvBTTDXJOn+sg2Nlglf4itt8NM7K6yT0X9OPzBUpebUno+xh4NeVf89Lo0Yn2TL9AgeYU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-42594db9398so37828645ab.2
        for <syzbot@lists.linux.dev>; Thu, 25 Sep 2025 12:23:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758828196; x=1759432996;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=Q3pkOYHd1otlPt7qC7h7mWwUNPlFdx/KSoQbIWssxH4=;
        b=UmNvc2iHH25c+Rpu/eNYnUgXgzBw96xJgdGDIIAQzXt4Q307JcFOpZlIR+Cp7AMbBF
         OKZRibROpNJiYXciUk0K1Np9ZQBTPLJkvvXGhA6hm7cwAu67aVAFXBnrM/8Dslv8hzCU
         o/+lAKPw988ogYvCYO77aVvl6D54RXbRtFcj1o3ccCbIGVgkmCNTxfDH9FoA0MbvZkVk
         Gn2A41tFaNNHLffE/AObpjfXEWDanYHkRn/BB/KtpWUjOa9mUxgAqd5Kz5qS2UWGy40E
         xihma+SGKml1VfE0IVxUuadaA3MX4r8GxL6eXSj1uleHpqz9qqKkMP+2D3jfeMuA/UNk
         iWjw==
X-Gm-Message-State: AOJu0Yw8zyIRlhFIAc7c7x+mRnIkJzkDnC63SU/asnnrl0Nej3MCBVP/
	P0ddzY58qbkoS1LiCudfFj42edUZazMTTa29ORDrEUVyhIKPjBd0GvEt/WtDcIew4wxAEt90kxH
	DKYOXhAKI4+6lX/Li7Tjdkc1gqmEIwy8MESlKwo/Xa92b9MXoXcIWcdUZ2wE=
X-Google-Smtp-Source: AGHT+IFAMTi/cX2u+Y32oxFXpgpNG6DlbN0gpZYEMgKfRaJQeUjzgM8++Gz1LH1laEmtO9mJoWRadRWSRDt1vWmfAiXHBSW3oOU3
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:511:b0:425:8109:2d0e with SMTP id
 e9e14a558f8ab-4259565431amr53393025ab.22.1758828196172; Thu, 25 Sep 2025
 12:23:16 -0700 (PDT)
Date: Thu, 25 Sep 2025 12:23:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68d596a4.050a0220.25d7ab.0061.GAE@google.com>
Subject: [moderation/CI] Re: hugetlbfs: skip VMAs without shareable locks in hugetlb_vmdelete_list
From: syzbot ci <syzbot+cibb3944405c273c2d@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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

The email will later be sent to:
[akpm@linux-foundation.org david@redhat.com kartikey406@gmail.com linux-kernel@vger.kernel.org linux-mm@kvack.org muchun.song@linux.dev osalvador@suse.de syzbot@syzkaller.appspotmail.com]

If the report looks fine to you, reply with:
#syz upstream

