Received: from mail-io1-f72.google.com (mail-io1-f72.google.com [209.85.166.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BFFD929B776
	for <syzbot@lists.linux.dev>; Fri, 24 Oct 2025 09:45:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761299155; cv=none; b=ktAAMM5YjoukrWMoOcLaZmqaYMHSJq9lIqXMUUOt2Ya9fqlCanaSYOnU4lN0GORrXja0NkYtVcPTPS4KQpPjifKDIk4gfOo+1+x5v5cJJlMI/EUjGL2KRyTlrJmjbyD6PuLC5f9nYAxg2wG+3fiaelF8jWDTVuRwdz3XTt2zSu4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761299155; c=relaxed/simple;
	bh=nLvto0IuAY6/6Oy8zWsaNfFIWblKrV/Tssvjv6H8rDk=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=RoeX3RDUkxIqVYgMoi8g5ll7x9EyAE6+bjTelutE9D1NA8zIc63ftHGXohQfB+Ey2GDmwFah9J+bsC73OQ7RF3/aJVRQH7MkTRjIXgGTDiH9va2kjkllgMgsCbWlZU2OyY3rKXmbIirsWmWY6MXrHdpd3HFs6+qP+osec4BoV5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f72.google.com with SMTP id ca18e2360f4ac-93e7d299abfso184867639f.3
        for <syzbot@lists.linux.dev>; Fri, 24 Oct 2025 02:45:53 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761299153; x=1761903953;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=CvGXASMaT78avqmFTLdrukShg8XgcPCwjan/XsOa2ZM=;
        b=bMPWezmr6lpcbINN33Pg9QfiXBkJNJpuBjsL2Fv66vR5C3biwhPK59DeDl2LNJNxHt
         CEkQQ19BRjSurukyKF/iN3Mzeh9y40ACBlKpaojiPW34KYENhMyLW3FQiBMcmnpJ4II3
         pmy8YGWZlXlKmXMDZfMMkEelQ7py8bGqi86TBi2g30p2GU0RKix1Y//NbleDGbhxByuT
         hXAELxOA1QYnZAQICxh/20EtjzqvNfcidBYCkzink7ZPuta+gCEn3nByK2fJwvjmxdHr
         xPG5PP+mt9LkhH3ukz/0FkhN3bhZoYdmbjcdbsY57tL2yO/hQo52Hk2ju5KHnhi09XdJ
         cajA==
X-Gm-Message-State: AOJu0YypubrmBfU0XT5ozf07UjJC2x7u2BAwF5eehv0ZUKngixj9zBbF
	UTPV/2au4DQAzwuvyEjE6C4cIXndMWrZOnIBxhC7uBa3dvrRZnSj6TrgHoAPSf5PT3YQwt26rL4
	gTHEFHuMfSwame8rWWLtmXir0gENJOFAHWAb6xjB916iEGWvj9TnRernDB1I=
X-Google-Smtp-Source: AGHT+IGfCdmv935m2vfGroWm0X4XItCn8TILY36uJm8H4xUb9+UdMowKGrAdznd6ArXASLLfPyFbXDPZJCdsu1WTNdUUFzux6nra
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:19ce:b0:430:bee3:34a with SMTP id
 e9e14a558f8ab-430c52b5b09mr332238495ab.20.1761299152914; Fri, 24 Oct 2025
 02:45:52 -0700 (PDT)
Date: Fri, 24 Oct 2025 02:45:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68fb4ad0.050a0220.346f24.00b9.GAE@google.com>
Subject: [moderation/CI] Re: BLOG: per-task logging contexts with Ceph consumer
From: syzbot ci <syzbot+ci051443c14da647ae@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] BLOG: per-task logging contexts with Ceph consumer
https://lore.kernel.org/all/20251024084259.2359693-1-amarkuze@redhat.com
* [RFC PATCH 1/5] sched, fork: Wire BLOG contexts into task lifecycle
* [RFC PATCH 2/5] lib: Introduce BLOG (Binary LOGging) subsystem
* [RFC PATCH 3/5] ceph: Add BLOG scaffolding
* [RFC PATCH 4/5] ceph: Add BLOG debugfs support
* [RFC PATCH 5/5] ceph: Activate BLOG logging

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/7234c177-7e5c-4d80-89de-c5fd97973114

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm=
.git
base:      2183c135f1550d85233cee150d7dec363a212740
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/f28d4fa4-f66f-4f42-a1b7-b4cc7c060c7=
1/config

fs/ceph/super.c:280:3: error: call to undeclared function 'bout'; ISO C99 a=
nd later do not support implicit function declarations [-Wimplicit-function=
-declaration]
fs/ceph/super.c:292:2: error: call to undeclared function 'bout'; ISO C99 a=
nd later do not support implicit function declarations [-Wimplicit-function=
-declaration]
fs/ceph/super.c:342:2: error: call to undeclared function 'bout'; ISO C99 a=
nd later do not support implicit function declarations [-Wimplicit-function=
-declaration]
fs/ceph/super.c:414:2: error: call to undeclared function 'bout'; ISO C99 a=
nd later do not support implicit function declarations [-Wimplicit-function=
-declaration]
fs/ceph/super.c:620:2: error: call to undeclared function 'bout'; ISO C99 a=
nd later do not support implicit function declarations [-Wimplicit-function=
-declaration]
fs/ceph/super.c:899:2: error: call to undeclared function 'bout'; ISO C99 a=
nd later do not support implicit function declarations [-Wimplicit-function=
-declaration]
fs/ceph/super.c:1299:2: error: call to undeclared function 'bout'; ISO C99 =
and later do not support implicit function declarations [-Wimplicit-functio=
n-declaration]
fs/ceph/super.c:1649:2: error: call to undeclared function 'bout'; ISO C99 =
and later do not support implicit function declarations [-Wimplicit-functio=
n-declaration]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org amarkuze@redhat.com bsegall@google.com ceph-deve=
l@vger.kernel.org david@redhat.com dietmar.eggemann@arm.com idryomov@gmail.=
com juri.lelli@redhat.com kees@kernel.org liam.howlett@oracle.com linux-ker=
nel@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com mgorman@s=
use.de mhocko@suse.com mingo@redhat.com peterz@infradead.org rostedt@goodmi=
s.org rppt@kernel.org slava.dubeyko@ibm.com surenb@google.com vbabka@suse.c=
z vincent.guittot@linaro.org vschneid@redhat.com xiubli@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

