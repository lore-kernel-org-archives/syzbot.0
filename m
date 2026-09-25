Received: from mail-oi1-f198.google.com (mail-oi1-f198.google.com [209.85.167.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20ECF3CB564
	for <syzbot@lists.linux.dev>; Fri, 25 Sep 2026 23:58:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790380739; cv=none; b=F6irWG9XRD+i192YC13fw/ZRaMA5+9pxAOiOZGzCDU9y1p4sNVJr9YsRmdF3JVaEFK8sGRpHi3QbmYKfn03LdVIjtHnAvMk6iSlccqzb3q0SSXhcqA2r/YfELQDk+ivgACVUdqoMbKqIRaEcBjBhrPbj6fFGGr3oAIIVeHaRsKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790380739; c=relaxed/simple;
	bh=0sY0W1kQJrtrg7LIE1KdZ6AEuDJXvD0WiGH+yDGCDGI=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=hR/qovDA1bNJVS9FWCpFh8Wk+8Cpyb4vChQZZl2mtEajE2UTuvT/8rRdMZPUkgkGhrA/PSSUNB8clH9AFp4jAy49K8KwRbL1Vf8ykA6q6Wj20+lbGepr5S4CttAvY/B+hoxKc+p8lsZ/i8BUh/UQcWexWnQEu1xFOuDLldh5t3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.167.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oi1-f198.google.com with SMTP id 5614622812f47-48e5de5a23cso2535949b6e.0
        for <syzbot@lists.linux.dev>; Fri, 25 Sep 2026 16:58:57 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790380737; x=1790985537;
        h=content-type:cc:to:from:subject:message-id:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=g0Ym3VJzdgOALmuQPesixfwkYZPyP7ZuCjNoZBrCvNY=;
        b=ZFidwEzRWOi9sfmJOUX1fF3ZoArwDQxerS5vMkbpspLY18I71r4c0WOZeaU7/gqQzK
         0+JkVuQGREaQJXOIxFf4ZAc7xayUIb+jMMgtJ68/4hni+ODGY5a3dz7D2LWmXcT+0a/2
         vl60wtWyFwdLkfFukDx6UKun+AXnaeXEhJD8vC0dHoIBOeks4ZwpPlgPjApUjEET/Whb
         ELxBa6sOb32khOWf7rdiaa5+awRSGVYZWqqzpf8WsQ7dAlKtfgFEni9e9iAaQBZrRtSf
         hEnm8zQvAvZlXoPdJ5laqW031glswJQvIucRQ5qn/WYkMPZJImsUoFSBK7hyAYNO32Jo
         E52Q==
X-Gm-Message-State: AFuF++mDIRAwkdDgRr83f5CLJ9T5Hnr3dhBBHOjA3mxMNOS3j8YsdjwQ
	2679vcOGTigS4Y9NZNEELc4y8JpQyf6R62U3w90m7uJp3MUv5Fq4cdbTNnZ5qNRzGZUHbCn8Bk4
	m0Q7pR+hyDJTbnyxHy1PiVFODc8c5j+0Ni66ZsevaO96ECHiAKDw1zZn88Qg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6808:3199:b0:4d6:90f4:48bc with SMTP id
 5614622812f47-4d72b24b95amr9659794b6e.46.1790380737064; Fri, 25 Sep 2026
 16:58:57 -0700 (PDT)
Date: Fri, 25 Sep 2026 16:58:57 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6ab70ac1.80e1c6cc.1e8e5f.003c.GAE@google.com>
Subject: [moderation/CI] Re: replace CONFIG_SLUB_TINY with a slab_tiny boot parameter
From: syzbot ci <syzbot+ci40908ab0a091769f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] replace CONFIG_SLUB_TINY with a slab_tiny boot parameter
https://lore.kernel.org/all/20260923-slub_tiny_rework-v1-0-a0e66d536eb5@kernel.org
* [PATCH RFC 1/8] mm, slab: refactor slab_min/max_order handling
* [PATCH RFC 2/8] mm, slab: introduce slab_debug=N
* [PATCH RFC 3/8] mm, slab: rework KMALLOC_RECLAIM handling of SLUB_TINY
* [PATCH RFC 4/8] mm, slab: make SLUB_TINY handling dynamic for sizing decisions
* [PATCH RFC 5/8] mm, slab: convert CONFIG_SLUB_TINY checks to kmem_cache_debug()
* [PATCH RFC 6/8] mm, slab: remove remaining compile-time checks for CONFIG_SLUB_TINY
* [PATCH RFC 7/8] mm, slab: add slab_tiny boot param
* [PATCH RFC 8/8] mm, slab: deprecate CONFIG_SLUB_TINY and reduce its Kconfig effects

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/5d4e0140-9eec-4e00-adb5-cf9c2ad766bb

***

kernel build error

tree:      mm-new
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
base:      2589c5593c200e5146db848730baa1d7dd0c9f4e
arch:      amd64
compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
config:    https://ci.syzbot.org/builds/d19a2813-b0ba-44a4-b622-a5ead49b44c5/config

mm/slub.c:8695:26: error: use of undeclared identifier 'slub_tiny_enabled'; did you mean 'slab_tiny_enabled'?

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a fix for this bug, please reply with `#syz test`
(on a separate line) and attach the patch to the email.

Notes:
- The patch will be applied on top of the tested series (as an
  incremental fix).
- To test a new version of the whole series, please send it directly
  to syzbot@lists.linux.dev.
- Arguments like custom git repos and branches are not supported.

The email will later be sent to:
[cl@gentwo.org conor@kernel.org damien.lemoal@opensource.wdc.com geert@linux-m68k.org hao.li@linux.dev harry@kernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org rientjes@google.com roman.gushchin@linux.dev vbabka@kernel.org]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

