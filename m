Received: from mail-io1-f71.google.com (mail-io1-f71.google.com [209.85.166.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12633393DF9
	for <syzbot@lists.linux.dev>; Thu, 21 Aug 2025 21:08:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810524; cv=none; b=r2mWu+V1/raQulEyldtSwXdmWJk00qGRr3mq2fptaa9ixEQnDZ0Y+902YR4O6n5qnV4VNAOCCxpslhzBcixvokC4fYYXqeJ2nlwgE8IPTeS/c5wSOX1sO32JYIcPZ/LS7WT5UIesAHO76C6uTYXLXiuUEm4fc4V4vynJcB00I10=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810524; c=relaxed/simple;
	bh=zk8csAc8L1o5NyH4LCY8w7m8QI5oHEPLEzMRDMqaZzg=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=B2BkLY29NFgdt68aJd8o2VDfRkqfPvyoJq/kepHjpqi38hmxaE7UzI7uWISw4m8qEROov6Iww0BFA198GcfmrHFCfRrwd6sSGi4hmUFmmuTYUJJbogkwq9RztbCrj0XN7Z0JhpLO115mrW5Sh3IisCo6WnQvisj02+biRegkdF8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-io1-f71.google.com with SMTP id ca18e2360f4ac-88432ccc4f9so294776839f.0
        for <syzbot@lists.linux.dev>; Thu, 21 Aug 2025 14:08:42 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755810522; x=1756415322;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=QnvL0gqtMtu3l99kRZCNvg8+EMSBd0U7TtxyOUGurlY=;
        b=I6gukk1pFlwHWvo+lurGfQ1EAEEhp5Gv4+pc1LZXls/uBHmKOGrhVuKB75guya9lS+
         w6f55RcEgHzx8lYTVV3aVcpuXfF8000ioEuGUn3EqbxAmCG9uu5v4YPE/kWpbP4iuoqI
         ALHKMfPcvN/ZHNbBSUcxz7ijIokZgZlSM24iQ2qWBxuoNgHfiP5hPG+ebeCo8AyltSTK
         GSVzv9xokNSAaUz5q7l/swCrmtae6V//31g0ZIALPhIr+fkaEqX7A5lyIQMpLeWMFhG0
         7w/qkyJf1q94f8Pvbd3Mb0KktRDcf14UD9nz/XqKmBgn9r6OdilOTklbZAPzvsURNoZR
         0gEA==
X-Gm-Message-State: AOJu0YyWfOLYmxXt/jSSjXh9cKNyY1RNDynCBE21hg7qLXio1rNQvzR7
	Q7RdFWVPpJoegX2tpX4uorr9conlkYp2wyKJbapZQmth0y/24zBpBg6+WlgBxW3nTj5y7mfeRWu
	34EVoOXeBBv2vmhMBlVciPAlg/FOISY4QRpuEnKJOFR1jtaomZHSr1iKWQzw=
X-Google-Smtp-Source: AGHT+IEeSoKKjuHtp5PQVQKNd9XvwOOp0DiOmh+VD+D9dTownmwqD8kx2dFUoqw087f6VKOzGwaKYBgk7nn8LykMstaKQ8/W98VB
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:3c03:b0:3e8:78b5:6834 with SMTP id
 e9e14a558f8ab-3e91fc22a64mr16178765ab.2.1755810522143; Thu, 21 Aug 2025
 14:08:42 -0700 (PDT)
Date: Thu, 21 Aug 2025 14:08:42 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68a78ada.050a0220.cb3d1.0001.GAE@google.com>
Subject: [moderation/CI] Re: fs: rework inode reference counting
From: syzbot ci <syzbot+ci12cae37568402b9e@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] fs: rework inode reference counting
https://lore.kernel.org/all/cover.1755806649.git.josef@toxicpanda.com
* [PATCH 01/50] fs: add an i_obj_count refcount to the inode
* [PATCH 02/50] fs: make the i_state flags an enum
* [PATCH 03/50] fs: hold an i_obj_count reference in wait_sb_inodes
* [PATCH 04/50] fs: hold an i_obj_count reference for the i_wb_list
* [PATCH 05/50] fs: hold an i_obj_count reference for the i_io_list
* [PATCH 06/50] fs: hold an i_obj_count reference in writeback_sb_inodes
* [PATCH 07/50] fs: hold an i_obj_count reference while on the hashtable
* [PATCH 08/50] fs: hold an i_obj_count reference while on the LRU list
* [PATCH 09/50] fs: hold an i_obj_count reference while on the sb inode list
* [PATCH 10/50] fs: stop accessing ->i_count directly in f2fs and gfs2
* [PATCH 11/50] fs: hold an i_obj_count when we have an i_count reference
* [PATCH 12/50] fs: rework iput logic
* [PATCH 13/50] fs: add an I_LRU flag to the inode
* [PATCH 14/50] fs: maintain a list of pinned inodes
* [PATCH 15/50] fs: delete the inode from the LRU list on lookup
* [PATCH 16/50] fs: change evict_inodes to use iput instead of evict directly
* [PATCH 17/50] fs: hold a full ref while the inode is on a LRU
* [PATCH 18/50] fs: disallow 0 reference count inodes
* [PATCH 19/50] fs: make evict_inodes add to the dispose list under the i_lock
* [PATCH 20/50] fs: convert i_count to refcount_t
* [PATCH 21/50] fs: use refcount_inc_not_zero in igrab
* [PATCH 22/50] fs: use inode_tryget in find_inode*
* [PATCH 23/50] fs: update find_inode_*rcu to check the i_count count
* [PATCH 24/50] fs: use igrab in insert_inode_locked
* [PATCH 25/50] fs: remove I_WILL_FREE|I_FREEING check from __inode_add_lru
* [PATCH 26/50] fs: remove I_WILL_FREE|I_FREEING check in inode_pin_lru_isolating
* [PATCH 27/50] fs: use inode_tryget in evict_inodes
* [PATCH 28/50] fs: change evict_dentries_for_decrypted_inodes to use refcount
* [PATCH 29/50] block: use igrab in sync_bdevs
* [PATCH 30/50] bcachefs: use the refcount instead of I_WILL_FREE|I_FREEING
* [PATCH 31/50] btrfs: don't check I_WILL_FREE|I_FREEING
* [PATCH 32/50] fs: use igrab in drop_pagecache_sb
* [PATCH 33/50] fs: stop checking I_FREEING in d_find_alias_rcu
* [PATCH 34/50] ext4: stop checking I_WILL_FREE|IFREEING in ext4_check_map_extents_env
* [PATCH 35/50] fs: remove I_WILL_FREE|I_FREEING from fs-writeback.c
* [PATCH 36/50] gfs2: remove I_WILL_FREE|I_FREEING usage
* [PATCH 37/50] fs: remove I_WILL_FREE|I_FREEING check from dquot.c
* [PATCH 38/50] notify: remove I_WILL_FREE|I_FREEING checks in fsnotify_unmount_inodes
* [PATCH 39/50] xfs: remove I_FREEING check
* [PATCH 40/50] landlock: remove I_FREEING|I_WILL_FREE check
* [PATCH 41/50] fs: change inode_is_dirtytime_only to use refcount
* [PATCH 42/50] btrfs: remove references to I_FREEING
* [PATCH 43/50] ext4: remove reference to I_FREEING in inode.c
* [PATCH 44/50] ext4: remove reference to I_FREEING in orphan.c
* [PATCH 45/50] pnfs: use i_count refcount to determine if the inode is going away
* [PATCH 46/50] fs: remove some spurious I_FREEING references in inode.c
* [PATCH 47/50] xfs: remove reference to I_FREEING|I_WILL_FREE
* [PATCH 48/50] ocfs2: do not set I_WILL_FREE
* [PATCH 49/50] fs: remove I_FREEING|I_WILL_FREE
* [PATCH 50/50] fs: add documentation explaining the reference count rules for inodes

and found the following issue:
kernel build error

Full report is available here:
https://ci.syzbot.org/series/743e203c-480a-40b0-a5b2-65be9b42c520

***

kernel build error

tree:      torvalds
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
base:      068a56e56fa81e42fc5f08dff34fab149bb60a09
arch:      amd64
compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~exp1~20250616065826.132), Debian LLD 20.1.7
config:    https://ci.syzbot.org/builds/43927ea0-33b7-4247-9afc-871999c47ee6/config

fs/smb/client/inode.c:2782:37: error: no member named 'counter' in 'struct refcount_struct'

***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[brauner@kernel.org josef@toxicpanda.com kernel-team@fb.com linux-btrfs@vger.kernel.org linux-ext4@vger.kernel.org linux-fsdevel@vger.kernel.org linux-xfs@vger.kernel.org viro@zeniv.linux.org.uk]

If the report looks fine to you, reply with:
#syz upstream

