Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B69A2D481D
	for <syzbot@lists.linux.dev>; Wed, 10 Sep 2025 08:45:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757493932; cv=none; b=JMlr7nCNN3FKTuGSBd/R35OCrmNJ5h2KADfWFwi6Hdj4YMvUdWd4RtMLilrYBmbnou4IRW5QA939JzHOWkQ89mXSDdM0HXNo49lEwZd2D2YSSbxouQ6pAuRQl2P7DZwT7UYKywLRiJSxAE6xTo8z6TtEG58uupz6ENijlFlIHAI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757493932; c=relaxed/simple;
	bh=vqyleLqxuxlJojetjwWRh5bzvR6c7EnawTX7IAfzlfA=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=h62iLD1BtLeRCkS+/JVEb+tMNywlwUZ+tCgQx8pZSGYue8J7gpCjAHDh/6dx1oMaYv50zZuwjN74bkw9RyE0XEWSFIg0Mv3yYK+Whd0kU4Tfj3KAuA2hgbp5Fcwi6To1W8mwxlTBlF3fm+jtG9MC+ulz3B7vpsnjH00ScxhsXyc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-3f6665a4754so175327715ab.2
        for <syzbot@lists.linux.dev>; Wed, 10 Sep 2025 01:45:30 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757493930; x=1758098730;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=Rm5hlHz2EsBDmsaeqV6FGtKHUJwLXiCizRpCNla/6uk=;
        b=tYce+dn/HpUafDrviTEDwDLfJSiBXV28GTas2GcV9yphRO8WnObgkyrBQRmTN5xN3S
         LVb+NmdcRhXUsxSvr6JSA3W0q1nZsboTUtRptjLFFnjOWr5ZueylqDd66yZQziC5O/+V
         AsSKYGBFaWKlgwKxhpUY7gfaA1rpjULy1l9OIFwmxHmtXj0x0Z99AnmGzmLj5xcrBNZQ
         IheJWO2bTGCbhe3yyO1JuWtvnVF/nzOlwZucd0OdnMKnUm4DMFLN1wQ4H7n4P0JRPS7C
         k2WS2u67DjJmHkZaZoqjM/ARLZTWyvjBMbk4hhxWkd6AO2FgOvpeIAcYlc6zdDqIfupF
         mEpA==
X-Gm-Message-State: AOJu0YyOx41EsWBHSEVUbX9tVvQbqgmWllz/yte539ORaVTeTs4VyJKd
	p3KIdEPDbvJEeaDMTsT3XgolQ+uxwnVLz1JAFQinEhdClDFMTEFIHVrFdojnKPKruyDx9+e+nrF
	Y1azQzveFiESmlxZdHTIGMKN9uwGuqQb+1i50EirgXMUi07+u3b6cTwjPG78=
X-Google-Smtp-Source: AGHT+IFz5EJxzqHFCh+ipXCSfCgHs7bEuUXANo/wfl9ALiGX3GKpHgfs8LjcodaiWoztj7axy5q+KDs4rmuBgc+WMK5HwIOAYGLb
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1487:b0:3f6:609d:1855 with SMTP id
 e9e14a558f8ab-3fd8925cb22mr206333235ab.31.1757493930152; Wed, 10 Sep 2025
 01:45:30 -0700 (PDT)
Date: Wed, 10 Sep 2025 01:45:30 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68c13aaa.050a0220.3c6139.001e.GAE@google.com>
Subject: [moderation/CI] Re: SLUB percpu sheaves
From: syzbot ci <syzbot+cibb1607bc10c21ade@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v8] SLUB percpu sheaves
https://lore.kernel.org/all/20250910-slub-percpu-caches-v8-0-ca3099d8352c@s=
use.cz
* [PATCH v8 01/23] locking/local_lock: Expose dep_map in local_trylock_t.
* [PATCH v8 02/23] slab: simplify init_kmem_cache_nodes() error handling
* [PATCH v8 03/23] slab: add opt-in caching layer of percpu sheaves
* [PATCH v8 04/23] slab: add sheaf support for batching kfree_rcu() operati=
ons
* [PATCH v8 05/23] slab: sheaf prefilling for guaranteed allocations
* [PATCH v8 06/23] slab: determine barn status racily outside of lock
* [PATCH v8 07/23] slab: skip percpu sheaves for remote object freeing
* [PATCH v8 08/23] slab: allow NUMA restricted allocations to use percpu sh=
eaves
* [PATCH v8 09/23] maple_tree: remove redundant __GFP_NOWARN
* [PATCH v8 10/23] tools/testing/vma: clean up stubs in vma_internal.h
* [PATCH v8 11/23] maple_tree: Drop bulk insert support
* [PATCH v8 12/23] tools/testing/vma: Implement vm_refcnt reset
* [PATCH v8 13/23] tools/testing: Add support for changes to slab for sheav=
es
* [PATCH v8 14/23] mm, vma: use percpu sheaves for vm_area_struct cache
* [PATCH v8 15/23] maple_tree: use percpu sheaves for maple_node_cache
* [PATCH v8 16/23] tools/testing: include maple-shim.c in maple.c
* [PATCH v8 17/23] testing/radix-tree/maple: Hack around kfree_rcu not exis=
ting
* [PATCH v8 18/23] maple_tree: Use kfree_rcu in ma_free_rcu
* [PATCH v8 19/23] maple_tree: Replace mt_free_one() with kfree()
* [PATCH v8 20/23] tools/testing: Add support for prefilled slab sheafs
* [PATCH v8 21/23] maple_tree: Prefilled sheaf conversion and testing
* [PATCH v8 22/23] maple_tree: Add single node allocation support to maple =
state
* [PATCH v8 23/23] maple_tree: Convert forking to use the sheaf interface

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/8c256672-a55f-41c5-8c7c-2494c944ec5e

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      f777d1112ee597d7f7dd3ca232220873a34ad0c8
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b3a4cb94-5d68-40bf-ac78-aa22ebc2ceb=
4/config

mm/slub.c:3972:27: error: a function declaration without a prototype is dep=
recated in all versions of C [-Werror,-Wstrict-prototypes]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org ast@kernel.org bigeasy@linutronix.de cl@gentwo.o=
rg harry.yoo@oracle.com jannh@google.com liam.howlett@oracle.com linux-kern=
el@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com maple-tree=
@lists.infradead.org pfalcato@suse.de rcu@vger.kernel.org richard.weiyang@g=
mail.com rientjes@google.com roman.gushchin@linux.dev rongqianfeng@vivo.com=
 sidhartha.kumar@oracle.com surenb@google.com urezki@gmail.com vbabka@suse.=
cz venkat88@linux.ibm.com wangyuli@uniontech.com willy@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

