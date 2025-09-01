Received: from mail-io1-f69.google.com (mail-io1-f69.google.com [209.85.166.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 179262F0C6A
	for <syzbot@lists.linux.dev>; Mon,  1 Sep 2025 14:01:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756735278; cv=none; b=MhChjJdExxLcGrjftsKUWvKqNmeFXPn9BlxX/5/pN74B/+ldvnCvsgx1zhcWA5yMwbnKvu8w4w8qBGgXUj5e39S9kkv4dWIhAjxqCvE5TpB1cxqKTljtziFETfWua2D+q1iA7Msopi9w0yDTV3SdNDpA1rpPhRj8ZzRdRTMjQjw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756735278; c=relaxed/simple;
	bh=WtW4DiUqAoh07PNpRZeV9dbwavrei06OBNWaKO5Hge4=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=mFpXs5on4GczXKlWBJFEvyktmskCAucizO/ZBTWe/CrmXUrkEa0nKGi0Em+IDiOnt2sM9X08VX6Yp4CCjlyqUCKzSlMZsSxVOH0srTE1/JbVP41IoJ5ONyOMMvq+g8xdx8KICrUOcuJWNr8C+mI1ANUuNYUgkoUT/UfIEDLTpm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f69.google.com with SMTP id ca18e2360f4ac-88714e1fd48so319087139f.0
        for <syzbot@lists.linux.dev>; Mon, 01 Sep 2025 07:01:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756735276; x=1757340076;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=sudifNjulIJsO+KIX/zBBI4Mif3F8uQxWnpSFsOjec4=;
        b=DUOPofHYwVoHQpwy//PWCVq9hG0OPSJa+vXti5BV9sdPqzhoi5oukbeNo53QUnQ81U
         YWq2rPcYQWmWZR2XzreXFnQcXQtfKsGiit7xevGepEyQXc3NuzoFtgg+mFR9k2c738pq
         w/fbqhcoRJO4z/yxBqcr02EmhzFHGLEoRkdszpzRXUPj73NYudAHABOmXzQKViOB0HQh
         Ty21eiEgWfjcjRJeZONeuy/msLNtU1dgXrdKXjpz4jZfPruWipT1LxjfoNOhIbXlz5Zz
         51wMLj05aJpAGk37mFxUVbQC7U8WBpDLXqf5P5O3lW57esspHQipq2w55TaKgO3PnBhP
         RdzA==
X-Gm-Message-State: AOJu0YxRWLJiZMuzmUvYqso4KtFa9z/iB2JB7xeIggbtwC1Jmchkt/O3
	hcQLUHOPR15ufUc5NCWMbnPk8zrv1lxVg2QfrKty3A+D+Gl/b6Tg4kbgkacXvYk7wllBYqe/8fl
	RZtuH9Fvo/tj+YuIIG+6afcdcPye6caWTiELyg3TVgfo2kkN4KTGVYJIC2Fc=
X-Google-Smtp-Source: AGHT+IFrXr9y2aIOfr+pLfiBAyHXruLTf6me3EQODVdEVjXcAGxpitL3M1Ez6shG782U/xsdg6sNuzmPhSJwvClhQKkMmQtPsLGr
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:17c9:b0:3f0:2859:4782 with SMTP id
 e9e14a558f8ab-3f4019f8d2dmr146624065ab.16.1756735259450; Mon, 01 Sep 2025
 07:00:59 -0700 (PDT)
Date: Mon, 01 Sep 2025 07:00:59 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68b5a71b.a00a0220.1337b0.0041.GAE@google.com>
Subject: [moderation/CI] Re: maple_tree: slub sheaves conversion
From: syzbot ci <syzbot+ci4ed910cc548d4591@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] maple_tree: slub sheaves conversion
https://lore.kernel.org/all/20250901-maple-sheaves-v1-0-d6a1166b53f2@suse.c=
z
* [PATCH 01/12] maple_tree: Fix check_bulk_rebalance() test locks
* [PATCH 02/12] tools: Add testing support for changes to slab for sheaves
* [PATCH 03/12] maple_tree: use percpu sheaves for maple_node_cache
* [PATCH 04/12] tools/testing: include maple-shared.h in maple.c
* [PATCH 05/12] tools/testing/vma: Implement vm_refcnt reset
* [PATCH 06/12] testing/radix-tree/maple: Hack around kfree_rcu not existin=
g
* [PATCH 07/12] maple_tree: Use kfree_rcu in ma_free_rcu
* [PATCH 08/12] maple_tree: Replace mt_free_one() with kfree()
* [PATCH 09/12] tools: Add sheaf to slab testing
* [PATCH 10/12] maple_tree: Sheaf conversion and testing
* [PATCH 11/12] maple_tree: Add single node allocation support to maple sta=
te
* [PATCH 12/12] maple_tree: Convert forking to use the sheaf interface

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/2a1e0d7a-ef70-4790-b17b-96cfb28773a8

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvald=
s/linux
base:      fab1beda7597fac1cecc01707d55eadb6bbe773c
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp=
1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/b298f8fc-56f8-4f17-a3c2-cefc933efad=
8/config

lib/maple_tree.c:191:2: error: call to undeclared function 'kmem_cache_retu=
rn_sheaf'; ISO C99 and later do not support implicit function declarations =
[-Wimplicit-function-declaration]
lib/maple_tree.c:196:9: error: call to undeclared function 'kmem_cache_pref=
ill_sheaf'; ISO C99 and later do not support implicit function declarations=
 [-Wimplicit-function-declaration]
lib/maple_tree.c:196:9: error: incompatible integer to pointer conversion r=
eturning 'int' from a function with result type 'struct slab_sheaf *' [-Win=
t-conversion]
lib/maple_tree.c:202:9: error: call to undeclared function 'kmem_cache_refi=
ll_sheaf'; ISO C99 and later do not support implicit function declarations =
[-Wimplicit-function-declaration]
lib/maple_tree.c:1111:8: error: call to undeclared function 'kmem_cache_all=
oc_from_sheaf'; ISO C99 and later do not support implicit function declarat=
ions [-Wimplicit-function-declaration]
lib/maple_tree.c:1111:6: error: incompatible integer to pointer conversion =
assigning to 'struct maple_node *' from 'int' [-Wint-conversion]
lib/maple_tree.c:1153:6: error: call to undeclared function 'kmem_cache_she=
af_size'; ISO C99 and later do not support implicit function declarations [=
-Wimplicit-function-declaration]
lib/maple_tree.c:6133:4: error: field designator 'sheaf_capacity' does not =
refer to any field in type 'struct kmem_cache_args'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[akpm@linux-foundation.org harry.yoo@oracle.com jannh@google.com liam.howle=
tt@oracle.com linux-fsdevel@vger.kernel.org linux-kernel@vger.kernel.org li=
nux-mm@kvack.org lorenzo.stoakes@oracle.com maple-tree@lists.infradead.org =
pfalcato@suse.de surenb@google.com vbabka@suse.cz willy@infradead.org]

If the report looks fine to you, reply with:
#syz upstream

