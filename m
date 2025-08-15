Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA6113090CC
	for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 16:28:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755275340; cv=none; b=HvANTq9eU5UgXNxl885pU6UkmvjSlluvw0wae17pqP8XdMEQ5/ic6esnHs+lod9nX866jLM1SzZpKQ+RUdqOK3OBLE4IdKhq4EcMkh0yg1Yra324muqz2JU1XIi1T1dClp/FlqmrL4Z09dpSMISo+dJRTS8MotO34cUGGog3HyQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755275340; c=relaxed/simple;
	bh=GNzJxNHiJoGzTT1wNtY5RJXOoMeU3J9dCqhket4/eMc=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=P6lrXebiKrw6AgtaNHLgM2R0RijFBMMugLJ1//dglr87pJVzReK5pCBBLaH6LUfUs+NcouXCy7MfwhG2BJUHBGkklcL8ZnlPtP4On/bflwfiMhfUDlpm6oJZh8aNY0xJyOAJtIuyM7ah6x4YFcrmk2xeTxlIGGgZCwjcWNhvcQo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3e5664b4536so39587595ab.1
        for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 09:28:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755275338; x=1755880138;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=wcbqHqgbEAW5ZRX8QK49FFwJV1Xd/vB5wVdgvKnCkvk=;
        b=QHiMk/LnjbBrLYQ4uOCM0LyNgFuMFdzsm0/vb8Y64Gj4YlzX2cNJKYc4IiO8bORtx/
         SeMvrbl9dmw+Q4e161N9FisZl2kqEiDiFe2zdNyc6g8dh8NXnnNy1kzFa5P6DJVR2vlh
         jAWrLatAdc00cWDdkI6OAUvWhlXkK6fz5OAKyBHPLK8BViwzwa4fyQWCI8ZlH+dJ4ERw
         nhWnLIVfM208UfkeAlCEkv2cnNsep6LDP3fV9o1eWgxUlV9HcOoUgpzLn7y9r105HBz8
         mw6PmwWiCWkE0l6VI5XBVVTisgyc7x0ie7y4W/Zn2A6AASzVzeLY6VWLnWpEpKvjDZ1g
         rQmw==
X-Gm-Message-State: AOJu0YwrfjzFdBSvS1m6610ffK4KJkLADKTzhmJS6VYu6lmTfSp2osDs
	IG7826aXemKevea3OPfrByHcEIkDgCsZG2XKPoaA6AIeH4mHMnlYNxQi11r1udgfI6mRa+c9kwz
	e0miUASW+HoA42a9sG8kzEcDaE24ZzXRI9GDlxxKFnUOOwUVPpYahnaw601E=
X-Google-Smtp-Source: AGHT+IGUhZciCVf/FM8fLvGdhvlQnZbuEPut79gZGDIWiANYYeeyYHrZzQiQunmkybwzYs1Y6bZ669FdgiPVRCaUnd+izNwJ+s2h
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a92:c265:0:b0:3e2:9f5c:520f with SMTP id
 e9e14a558f8ab-3e57da24190mr48999295ab.3.1755275338056; Fri, 15 Aug 2025
 09:28:58 -0700 (PDT)
Date: Fri, 15 Aug 2025 09:28:58 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <689f604a.050a0220.e29e5.001d.GAE@google.com>
Subject: [moderation/CI] Re: A subsystem for hot page detection and promotion
From: syzbot ci <syzbot+cia45a30af98595083@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] A subsystem for hot page detection and promotion
https://lore.kernel.org/all/20250814134826.154003-1-bharata@amd.com
* [RFC PATCH v1 1/7] mm: migrate: Allow misplaced migration without VMA too
* [RFC PATCH v1 2/7] migrate: implement migrate_misplaced_folios_batch
* [RFC PATCH v1 3/7] mm: Hot page tracking and promotion
* [RFC PATCH v1 4/7] x86: ibs: In-kernel IBS driver for memory access profi=
ling
* [RFC PATCH v1 5/7] x86: ibs: Enable IBS profiling for memory accesses
* [RFC PATCH v1 6/7] mm: mglru: generalize page table walk
* [RFC PATCH v1 7/7] mm: klruscand: use mglru scanning for page promotion

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/28a4d048-e6a3-4f88-9af0-a125dc83ce59

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp=
1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/e83820a3-9192-43d7-875e-200f41909c3=
c/config

make[3]: *** No rule to make target 'mm/kpromoted.o', needed by 'mm/built-i=
n.a'.  Stop.

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org balbirs@nvidia.com bharata@amd.com byungchul@sk.=
com dave.hansen@intel.com dave@stgolabs.net david@redhat.com gourry@gourry.=
net hannes@cmpxchg.org jonathan.cameron@huawei.com joshua.hahnjy@gmail.com =
kinseyho@google.com linux-kernel@vger.kernel.org linux-mm@kvack.org mgorman=
@techsingularity.net mingo@redhat.com nifan.cxl@gmail.com peterz@infradead.=
org raghavendra.kt@amd.com riel@surriel.com rientjes@google.com sj@kernel.o=
rg weixugc@google.com willy@infradead.org xuezhengchu@huawei.com yiannis@zp=
tcorp.com ying.huang@linux.alibaba.com yuanchu@google.com ziy@nvidia.com]

If the report looks fine to you, reply with:
#syz upstream

