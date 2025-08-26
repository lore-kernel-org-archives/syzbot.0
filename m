Received: from mail-il1-f198.google.com (mail-il1-f198.google.com [209.85.166.198])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7621D285C97
	for <syzbot@lists.linux.dev>; Tue, 26 Aug 2025 20:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.198
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756241848; cv=none; b=hXuY0OJYHkRdi0Od2h3HkMg4TerJ/avsmYdebrCS3rAqu6SoM36BdqNL+ES1mN41OPHkg0N8nqi9VNtf+tFFtq9snns1UyR0Nmu4s70wS8jgK32d7z+iR59HU8iGYbq0DPyR6CAts9+orDieY1NHWai3t0LXwzo621IcKKolRZ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756241848; c=relaxed/simple;
	bh=Bh0R3QcNTj1bhVHgPZ2WgZRHGjzkZYyyfbIwwyiU0ME=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=XXPrdU7sLUd2/bRZ2GdYqD5u+tKkBZdHkawZTtjsfiu6WbPYuHL7GM2pSG+uuhDOL9IDyrifhz0fnVn9V/LtloI7N+DKt6s6DCyiS0IWpP1lFdSrTFaq3dT+AbsrioEdntZNEQVOkN4BsyjXiWZtiscHgYDhYxNXUUrbAMNfDJ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.198
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f198.google.com with SMTP id e9e14a558f8ab-3ee05b9a323so4719935ab.1
        for <syzbot@lists.linux.dev>; Tue, 26 Aug 2025 13:57:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756241845; x=1756846645;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=8kULqBm9sSTOamRVm+BSda48Aunl2KRchE82s9i8d/Q=;
        b=uepjMeWsAZ19QmjQT3lVLkqh0tegxAcmTnlpTXILzQyxBLrNVVUsar2dUjYetPAd14
         6xACTkD7+ZPuTXrKPP0gs9QARPKIlOetFJRBtG/v8yDOTqmVIaXOvOJoRcjh7KGL6H74
         2jcWCuNPS7goBSKxt/Yj0LZgqKVfvDlMhwx8AeBMXwN6K/Eini6g3CInIQmbWKRizaQX
         8tuxIbRCdhTMTBw2+HgH111oFy+rqGbn/AwWuWfR6+ypPOUuOyhRSqi1IKelbbqhyK0y
         GmnUp2kSQuUUs4mGYkX5/ADaNyx5JJvAm6OaoLFNuX3hnPnDzv7SmdYDdv1GmZmhFK9k
         iReg==
X-Gm-Message-State: AOJu0YxYUsLm4yFfllHOfrG1g12mI7i+c9BDXpDD0cyzKx+uU7wl5RWC
	04Mt/1cG6fdsHD+0FGbzk4L2HPefGa7jZ7s0ihcqIggAvfZ1iS+FYqR7Un73/8ssbZc5AeAf+xn
	okYwWjIJ3hKtzd58KJV3RhJYGnxdBrFxi0vo0AqFfkXFADrogCq+sFMPZDLw=
X-Google-Smtp-Source: AGHT+IEJgvsWbDV/34xvUrwWtUlaKgPvzHnb7nJzRO2BykQ4OxcV6bvSPHjznBfb57AIb7itsveI5M4UX5cVfJ9tXeIlhaU1BieC
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:106f:b0:3e6:7d1a:8f22 with SMTP id
 e9e14a558f8ab-3ef0885888dmr33338865ab.6.1756241845495; Tue, 26 Aug 2025
 13:57:25 -0700 (PDT)
Date: Tue, 26 Aug 2025 13:57:25 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68ae1fb5.a70a0220.3cafd4.0001.GAE@google.com>
Subject: [moderation/CI] Re: fs: rework inode reference counting
From: syzbot ci <syzbot+ci41c6c35685f6a3d5@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v2] fs: rework inode reference counting
https://lore.kernel.org/all/cover.1756222464.git.josef@toxicpanda.com
* [PATCH v2 01/54] fs: make the i_state flags an enum
* [PATCH v2 02/54] fs: add an icount_read helper
* [PATCH v2 03/54] fs: rework iput logic
* [PATCH v2 04/54] fs: add an i_obj_count refcount to the inode
* [PATCH v2 05/54] fs: hold an i_obj_count reference in wait_sb_inodes
* [PATCH v2 06/54] fs: hold an i_obj_count reference for the i_wb_list
* [PATCH v2 07/54] fs: hold an i_obj_count reference for the i_io_list
* [PATCH v2 08/54] fs: hold an i_obj_count reference in writeback_sb_inodes
* [PATCH v2 09/54] fs: hold an i_obj_count reference while on the hashtable
* [PATCH v2 10/54] fs: hold an i_obj_count reference while on the LRU list
* [PATCH v2 11/54] fs: hold an i_obj_count reference while on the sb inode list
* [PATCH v2 12/54] fs: stop accessing ->i_count directly in f2fs and gfs2
* [PATCH v2 13/54] fs: hold an i_obj_count when we have an i_count reference
* [PATCH v2 14/54] fs: add an I_LRU flag to the inode
* [PATCH v2 15/54] fs: maintain a list of pinned inodes
* [PATCH v2 16/54] fs: delete the inode from the LRU list on lookup
* [PATCH v2 17/54] fs: remove the inode from the LRU list on unlink/rmdir
* [PATCH v2 18/54] fs: change evict_inodes to use iput instead of evict directly
* [PATCH v2 19/54] fs: hold a full ref while the inode is on a LRU
* [PATCH v2 20/54] fs: disallow 0 reference count inodes
* [PATCH v2 21/54] fs: make evict_inodes add to the dispose list under the i_lock
* [PATCH v2 22/54] fs: convert i_count to refcount_t
* [PATCH v2 23/54] fs: use refcount_inc_not_zero in igrab
* [PATCH v2 24/54] fs: use inode_tryget in find_inode*
* [PATCH v2 25/54] fs: update find_inode_*rcu to check the i_count count
* [PATCH v2 26/54] fs: use igrab in insert_inode_locked
* [PATCH v2 27/54] fs: remove I_WILL_FREE|I_FREEING check from __inode_add_lru
* [PATCH v2 28/54] fs: remove I_WILL_FREE|I_FREEING check in inode_pin_lru_isolating
* [PATCH v2 29/54] fs: use inode_tryget in evict_inodes
* [PATCH v2 30/54] fs: change evict_dentries_for_decrypted_inodes to use refcount
* [PATCH v2 31/54] block: use igrab in sync_bdevs
* [PATCH v2 32/54] bcachefs: use the refcount instead of I_WILL_FREE|I_FREEING
* [PATCH v2 33/54] btrfs: don't check I_WILL_FREE|I_FREEING
* [PATCH v2 34/54] fs: use igrab in drop_pagecache_sb
* [PATCH v2 35/54] fs: stop checking I_FREEING in d_find_alias_rcu
* [PATCH v2 36/54] ext4: stop checking I_WILL_FREE|IFREEING in ext4_check_map_extents_env
* [PATCH v2 37/54] fs: remove I_WILL_FREE|I_FREEING from fs-writeback.c
* [PATCH v2 38/54] gfs2: remove I_WILL_FREE|I_FREEING usage
* [PATCH v2 39/54] fs: remove I_WILL_FREE|I_FREEING check from dquot.c
* [PATCH v2 40/54] notify: remove I_WILL_FREE|I_FREEING checks in fsnotify_unmount_inodes
* [PATCH v2 41/54] xfs: remove I_FREEING check
* [PATCH v2 42/54] landlock: remove I_FREEING|I_WILL_FREE check
* [PATCH v2 43/54] fs: change inode_is_dirtytime_only to use refcount
* [PATCH v2 44/54] btrfs: remove references to I_FREEING
* [PATCH v2 45/54] ext4: remove reference to I_FREEING in inode.c
* [PATCH v2 46/54] ext4: remove reference to I_FREEING in orphan.c
* [PATCH v2 47/54] pnfs: use i_count refcount to determine if the inode is going away
* [PATCH v2 48/54] fs: remove some spurious I_FREEING references in inode.c
* [PATCH v2 49/54] xfs: remove reference to I_FREEING|I_WILL_FREE
* [PATCH v2 50/54] ocfs2: do not set I_WILL_FREE
* [PATCH v2 51/54] fs: remove I_FREEING|I_WILL_FREE
* [PATCH v2 52/54] fs: remove I_REFERENCED
* [PATCH v2 53/54] fs: remove I_LRU_ISOLATING flag
* [PATCH v2 54/54] fs: add documentation explaining the reference count rules for inodes

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/ccd4eafa-7a13-48d6-93b6-f40c03262bea

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      fab1beda7597fac1cecc01707d55eadb6bbe773c
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/162c03ae-2d30-4085-ab1e-a2dd1c8403eb/config

fs/bcachefs/fs.c:350:20: error: incompatible pointer types passing 'struct bch_inode_info *' to parameter of type 'const struct inode *' [-Werror,-Wincompatible-pointer-types]

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[amir73il@gmail.com brauner@kernel.org josef@toxicpanda.com kernel-team@fb.com linux-btrfs@vger.kernel.org linux-ext4@vger.kernel.org linux-fsdevel@vger.kernel.org linux-xfs@vger.kernel.org viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

