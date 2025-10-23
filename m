Received: from mail-il1-f200.google.com (mail-il1-f200.google.com [209.85.166.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74B5D221542
	for <syzbot@lists.linux.dev>; Thu, 23 Oct 2025 12:44:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761223459; cv=none; b=SpznzqdvG5deAtLEmOjjEHP04kNJTYEAFCsgjA/BQJlw7KXeFJEJEzqnU+cDLrteYwcEGhBK5w4XaIH/fbzSIJrItElSP7UAI7gJFNx/D3DPfl+5QolwgFd2FUkAe2pGWkMCOd0YuZDHB+fsAjRh5SH3z9XoiMWrX/xAVe2N3sU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761223459; c=relaxed/simple;
	bh=wBsst0MgfQo1rE7n/hidRk8CaqEFZzZ6k/lNSVY5mzw=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=euWgpx9XYjuE6nCuHP4omCdtyTyqGMgXT1pCk2Z1wqA4Kueb2TdjTGJ4V/Sv4T/pSvNXiWFI3eTSZyX30xTcrG/HNbBrR6MbFRAoj4OwNsGQxe5iMfqfub0altG2JYzvRp3/G8BZTeGMMX88lcMRegGsY/6JNRPWM6V4UBEvdjo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f200.google.com with SMTP id e9e14a558f8ab-430c684035eso22326605ab.1
        for <syzbot@lists.linux.dev>; Thu, 23 Oct 2025 05:44:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761223456; x=1761828256;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=YF8pVn2hHR48/7gAjByM7aSzKfB0BwtUM7q3NO4DSB8=;
        b=xE35ZMmZyAxMIUxDrmacIDQ2cX5HdUrXTjd/wOls98G9m8pz0uc2qxziqxfCWBVKCg
         8vyVQCu47qr7GFDLu5lHprlSYfoENkrKjBgZ2iYNoH5lb9k7jlEy7HX+n3QBPqauUDZJ
         ikFjKJcUGxLX9ykb5+EL766VZAyGvzh2VsPYPwC/xroODRR6+oRaVPt2yNVxBdeMpEZo
         LbqVXVFyiuNDFW+mNBQMoK+hL27yKgPitq7NlfqMviv2/kqpemn99TtPNUm19CXcde96
         124rc78/Wuc3/6svBBxayGdU+0wvrqZ+ip2KDogjMVoYB8lVYsxADDEEYA6x288T/1j2
         k/SA==
X-Gm-Message-State: AOJu0Yxlw2mjFJExTOYrEwfCjMZpbh4XDfOMVrvEBsHPz1vR/HjWnRyq
	+2zfKB8y4pygKCtNVFt5cLuIJQ1pr3N0zWdCBepwZ4/Cfd0vlIYF91dX2CctUoZg5jf6KpWO2qz
	AZLG0ZmD62b/AeXC/GxZWLMmzu2QVaDUzNpGx1sGaes/ex/1h6kvpV5ZHeYE=
X-Google-Smtp-Source: AGHT+IHGS+2AuT3/PyGCBcP4igk4areNsEYe99trkyqTHYkMoNuVfpliUY6fQ3YulmLK3RJpt/+42YEBdi5+Bf8alsI+dP6J8Ank
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1aac:b0:430:b467:1af8 with SMTP id
 e9e14a558f8ab-431d31906d9mr88405215ab.2.1761223456641; Thu, 23 Oct 2025
 05:44:16 -0700 (PDT)
Date: Thu, 23 Oct 2025 05:44:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fa2320.050a0220.346f24.007b.GAE@google.com>
Subject: [moderation/CI] Re: mm: hugetlb: allocate frozen gigantic folio
From: syzbot ci <syzbot+ci8c0cc11b8e6f2f36@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v4] mm: hugetlb: allocate frozen gigantic folio
https://lore.kernel.org/all/20251023115940.3573158-1-wangkefeng.wang@huawei=
.com
* [PATCH v4 1/6] mm: debug_vm_pgtable: add debug_vm_pgtable_free_huge_page(=
)
* [PATCH v4 2/6] mm: page_alloc: add __split_page()
* [PATCH v4 3/6] mm: cma: add __cma_release()
* [PATCH v4 4/6] mm: page_alloc: add alloc_contig_frozen_{range,pages}()
* [PATCH v4 5/6] mm: cma: add cma_alloc_frozen{_compound}()
* [PATCH v4 6/6] mm: hugetlb: allocate frozen pages in alloc_gigantic_folio=
()

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/d017473a-4638-4309-a2d3-1e4132e2337a

***

kernel build error

tree:      linux-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/li=
nux-next
base:      aaa9c3550b60d6259d6ea8b1175ade8d1242444e
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/3ee1dee8-f51e-496f-b7d2-8bf3eb865fe=
e/config

mm/internal.h:518:21: error: use of undeclared identifier 'pfn'
mm/internal.h:519:35: error: use of undeclared identifier 'pfn'
mm/damon/../internal.h:518:21: error: use of undeclared identifier 'pfn'
mm/damon/../internal.h:519:35: error: use of undeclared identifier 'pfn'
kernel/../mm/internal.h:518:21: error: use of undeclared identifier 'pfn'
kernel/../mm/internal.h:519:35: error: use of undeclared identifier 'pfn'
lib/../mm/internal.h:518:21: error: use of undeclared identifier 'pfn'
lib/../mm/internal.h:519:35: error: use of undeclared identifier 'pfn'
fs/../mm/internal.h:518:21: error: use of undeclared identifier 'pfn'
fs/../mm/internal.h:519:35: error: use of undeclared identifier 'pfn'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org david@redhat.com hannes@cmpxchg.org jackmanb@goo=
gle.com jane.chu@oracle.com linux-mm@kvack.org muchun.song@linux.dev osalva=
dor@suse.de sidhartha.kumar@oracle.com vbabka@suse.cz wangkefeng.wang@huawe=
i.com willy@infradead.org ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

