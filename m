Received: from mail-oi1-f200.google.com (mail-oi1-f200.google.com [209.85.167.200])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 50B2E33F595
	for <syzbot@lists.linux.dev>; Wed, 17 Jun 2026 21:39:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.200
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781732346; cv=none; b=fhENlcu0GqqVokCkTJWdoo2/zaAsouN63PwhUrycNcbp9Jkiz4eKx7sveODvcvpxOlPsL1+Y9n30mv8DzR0EApWyAZ59jRfMplPtE5TmlQ5VEXXjKENcBQHUTEgu9TRGVSmWTUYqISTecs+idYq6Fp7LN/6F8jTN7uEoX4cViaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781732346; c=relaxed/simple;
	bh=+uOPT7KnIbvjifmL3K8R7COImYvGoOairnQGgui2V+Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=jDKMfz+lFaJfqOKD50t3mW1yot54yywW2Kf0mI9UjQTeqv1qsAcpzB+LZ50wGWOE28Ivr9raypy56ktbRfinK8kB0XFXiA4V7u9JQgV8hDor3+Xcsu/c6HsnSt5AHowaxfAMBzc0FUjM/D3QfTFj9zsq9aarQ3JcnFKie3MX1Is=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.200
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f200.google.com with SMTP id 5614622812f47-48638b48315so729620b6e.0
        for <syzbot@lists.linux.dev>; Wed, 17 Jun 2026 14:39:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781732344; x=1782337144;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=AEZbGhyF5lvI27rJzh47ORLSiWQq6GMaKdYFlHQNHrA=;
        b=WpwsmPLuoTJokEJdM7YmnvVJe6zRnZMsCTPNITodxa/cWcVZNYnfexBQey+4uFit+Z
         S8Vz3SepBqpxdyn2tJJRpzlE+uIqsTlgw04pGSDzmsZETgmrY50Fft2uhfPRQkdyeJL0
         ZBvrD5lofeS5ZAjcB8PXPq84b1cRZRykXlwAfn9wWccnd1Ze4qM6mCvX5k/MMfAhBJZy
         eXHV8KZu9GLakgY9nG1Hq+6BSBjdZG1CZlXJMcqmUVJFHNW0HpdavQ+Ol0VGQ2o+5WU/
         Oa5dxCzvHBed0l26IrlflVlDzrQc2VY4OoGSsZRyFLAck1J7OvOlK90DAvkUkc8gH2zR
         Jdww==
X-Gm-Message-State: AOJu0YykcAWYxgvZRlAPs7QAUD/C+geQrJmYAU1TjljvxLavI6H8XHEX
	5Hau6w61s9TYTAoqjCOKjg2Gse+DgOgGC3oWaNjATxnu+NWp1BhGKF58Hxs4YQK+9Ic5zbsYhrI
	2aHNeV2TQVUZDPaMULM/A2xQoxb38zCkBpbammrw90R3HkhOuXADT8+1YjU8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:c413:b0:487:55b1:8aaa with SMTP id
 5614622812f47-489560dd446mr1033720b6e.14.1781732344310; Wed, 17 Jun 2026
 14:39:04 -0700 (PDT)
Date: Wed, 17 Jun 2026 14:39:04 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a3313f8.e0e229d8.1d3f3.0006.GAE@google.com>
Subject: [moderation/CI] Re: hugetlb: Use PAGE granularity index in exported
 i/f and adopt the common read_iter
From: syzbot ci <syzbot+ci553b06fbd2706fd7@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v2] hugetlb: Use PAGE granularity index in exported i/f and adopt the comm=
on read_iter
https://lore.kernel.org/all/20260617172534.1740152-1-jane.chu@oracle.com
* [PATCH v2 01/11] mm/memory-failure: make is_raw_hwpoison_page_in_hugepage=
() general purpose
* [PATCH v2 02/11] mm: factor out adjust_range_hwpoison() from hugetlbfs
* [PATCH v2 03/11] mm/filemap: add hwpoison handling to filemap_read()
* [PATCH v2 04/11] hugetlbfs,filemap: replace hugetlbfs_read_iter() with ge=
neric_file_read_iter()
* [PATCH v2 05/11] hugetlb: Convert the vmf->pgoff to PAGE_SIZE granularity
* [PATCH v2 06/11] hugetlb: make hugetlb_fault_mutex_hash() to take PAGE_SI=
ZE index
* [PATCH v2 07/11] hugetlb: replace filemap_lock_hugetlb_folio with filemap=
_lock_folio
* [PATCH v2 08/11] hugetlb: make hugetlb_add_to_page_cache() to take PAGE_S=
IZE granularity index
* [PATCH v2 09/11] hugetlb: remove the hugetlb_linear_page_index() helper
* [PATCH v2 10/11] hugetlb: drop vma_hugecache_offset() in favor of linear_=
page_index()
* [PATCH v2 11/11] hugetlb: make hugetlb_[un]reserve_pages() to take PAGE g=
ranularity index

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/46af513c-ee7e-4b9d-9710-b8534d0c03bc

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      f2737dc40d2ef3e9f3f9395d61f53f6668306a71
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/3c2981fa-3715-41da-8819-23a981a31c0=
d/config

ld.lld: error: undefined symbol: is_raw_hwpoison_page_in_folio

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
[akpm@linux-foundation.org baolin.wang@linux.alibaba.com brauner@kernel.org=
 corbet@lwn.net david@kernel.org hughd@google.com jack@suse.cz jane.chu@ora=
cle.com linmiaohe@huawei.com linux-doc@vger.kernel.org linux-fsdevel@vger.k=
ernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org lorenzo@kernel.or=
g muchun.song@linux.dev nao.horiguchi@gmail.com osalvador@suse.de peterx@re=
dhat.com rppt@kernel.org viro@zeniv.linux.org.uk willy@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

