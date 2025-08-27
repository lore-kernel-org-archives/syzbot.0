Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 913373218C5
	for <syzbot@lists.linux.dev>; Wed, 27 Aug 2025 08:03:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756281791; cv=none; b=IOrr4zAj1qXY+/kYG60rPdrVMQVBvoxP1XXzuoOHHt4Qvs/zXCZjzTztB8k6ViumYp4rBaV5bY3oDyKxhdsfgQg20LcJ8BOKZoYiJFd6pquAUTYFfV3d7wj3k8JyFPAq5mEQ0rlHavlMYvzHL13A+eTJ+RQiIAdFtmATCOFvapI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756281791; c=relaxed/simple;
	bh=CBvc9p5fgH7OOVzzYoyDrA3DgU+cZ1tk5jhjBwG2V6w=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=c95xDs0dKPLCUV7H0Ec4vIGKp59CtRmRRf3hb5VvUeBNebK2jggxDJp8IL3oWB/YeCyINa4YDg+7QtawKDzDvqfWboWlnAp/iUouBmhGf7JMNuT6//DYf92Q/Z8mLypMySfWSZcaukEHoVElK8lWEcLjFxwEzlwpucxxuRJF3Q8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XyW4vyKx; arc=none smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XyW4vyKx"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-74523a19fb3so2085714a34.0
        for <syzbot@lists.linux.dev>; Wed, 27 Aug 2025 01:03:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756281789; x=1756886589; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DmrjE2OPJvIRXN7eS4xvShskBiqwWSyUJcxvrrN+VSc=;
        b=XyW4vyKx90kiCUx069qulf6vKtPqDQ1sEf+a6r1EpJHozf8fcMVq/sBeM/UFrUtVZo
         AUCXaJ7/eSwmB3nUZtYp9KpSy7iL4RrouiULxdoiEsFVyy9N6RrBz3vejoFZegOK6Gg2
         u058e7yFECpHEY6xL4rur5HoZrY2cE2wE3MpEzdhTyudMqWzxWQJ0Ho9l4UyTtzi5LM8
         BHwiBawexysHk1b6PQpddgup9+/hcu/2I09N0h9BVVmcuMSemwetSdV9UCSWw4xjeez6
         5EkxxxUEZhT6HUM2jwrlYIeIr5j4LwvcVL4eAkSP+FrovS10du3fx9MoKjsg4yJIqkVT
         t3dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756281789; x=1756886589;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DmrjE2OPJvIRXN7eS4xvShskBiqwWSyUJcxvrrN+VSc=;
        b=qyybF3A6mIORnZqomhFmT97sHXttbNCWdcFmiM6PeSKrW+CPGvY1kG95686s85pgTi
         pO6AMYnlqGCsLo74itGcXFwNdNWBr31L9bBItruN+qLR3NjFJUaSCAxVNOJGoWTi7W3A
         yrpGlavroIgUk+z1LHpZ6P2HgBQnO+kqn2xjG1mjGLAL/mm0A4dPsoYll1go8bO5cTwC
         ZFVhjMx95vB7DRMlnZ9LlNPjbJ4twMakKKAQgSOexH3YKNcpWqawIaOYL7novLdjifhy
         hKk8FYZng/sda9Y2m1mSykNyxLtcAzrPtIPr26XavNBVb6gYqkx/4y9kh3ROdTqyfNPw
         HhNw==
X-Forwarded-Encrypted: i=1; AJvYcCUxVGaJYoYoeBZJzzXoIr04StOUjBwkEV20c+JHFMVYwhATfP/CZwM/1OdZejbXqUJkuZdh4Xg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwMaek/X30vgqAnzgvil8hWJ7ef8fIjSaW2ZYErEqftMhzaxtT1
	/dkwSPH03Pcopf7eq8B3YS+yu58lys/xvRlB9WPcnk5UaQ2KWbWRjAvbHfkTfAaruoa0BsYdO/g
	axA1H5G2NgsGimS5iYi+1OUOUAGGxqYk9LPRqdo1uzvXnEJDQHpq8lQrz6nQ=
X-Gm-Gg: ASbGncsISWglbtaQ8i0JUjNdNdg3PjNibAPPCCKJpIxYnaMXhnQ6PrgE9Xu7SCT2chI
	jMHmuDKgXdjj1MC8vcDg25BEhG9jBkKvnCmtBfT1NSbt/AXHb3BH3IKmWLMpubixWNGvv1rM6tl
	RnNU+iiVwCj/55KPiR4CHioX8U9QCdW7LUwayiYe/s3rURQ/DtKZSMUqYlf9i1NYnJuT5BGsT7K
	ZM1s4qtYBlj++U4WNKCDFtdy8YRZHrq0jANvbvSNzXl
X-Google-Smtp-Source: AGHT+IHBOf3gbq3QKaolLV2yN+wX5GW6ZJpwKySETHJZ+2ONKgm7a04IaPDwX0AJvVAekkHdbnRafog/tgNIVC16AhY=
X-Received: by 2002:a05:6830:61cd:b0:72b:9d8d:5881 with SMTP id
 46e09a7af769-74500aa5ef3mr10933033a34.28.1756281788325; Wed, 27 Aug 2025
 01:03:08 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68ae1fb5.a70a0220.3cafd4.0001.GAE@google.com>
In-Reply-To: <68ae1fb5.a70a0220.3cafd4.0001.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 27 Aug 2025 10:02:57 +0200
X-Gm-Features: Ac12FXzwWYKdEk9WyrWDhQTDwPXXzW6Qv-xwx4If34MBA6FimDTE5bXTo8i2KSw
Message-ID: <CANp29Y5XrKCymjjP4WNKbEx9qQN_eEVEQ2h9778q4BHit_ZLkQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: fs: rework inode reference counting
To: syzbot ci <syzbot+ci41c6c35685f6a3d5@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Aug 26, 2025 at 10:57=E2=80=AFPM syzbot ci
<syzbot+ci41c6c35685f6a3d5@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] fs: rework inode reference counting
> https://lore.kernel.org/all/cover.1756222464.git.josef@toxicpanda.com
> * [PATCH v2 01/54] fs: make the i_state flags an enum
> * [PATCH v2 02/54] fs: add an icount_read helper
> * [PATCH v2 03/54] fs: rework iput logic
> * [PATCH v2 04/54] fs: add an i_obj_count refcount to the inode
> * [PATCH v2 05/54] fs: hold an i_obj_count reference in wait_sb_inodes
> * [PATCH v2 06/54] fs: hold an i_obj_count reference for the i_wb_list
> * [PATCH v2 07/54] fs: hold an i_obj_count reference for the i_io_list
> * [PATCH v2 08/54] fs: hold an i_obj_count reference in writeback_sb_inod=
es
> * [PATCH v2 09/54] fs: hold an i_obj_count reference while on the hashtab=
le
> * [PATCH v2 10/54] fs: hold an i_obj_count reference while on the LRU lis=
t
> * [PATCH v2 11/54] fs: hold an i_obj_count reference while on the sb inod=
e list
> * [PATCH v2 12/54] fs: stop accessing ->i_count directly in f2fs and gfs2
> * [PATCH v2 13/54] fs: hold an i_obj_count when we have an i_count refere=
nce
> * [PATCH v2 14/54] fs: add an I_LRU flag to the inode
> * [PATCH v2 15/54] fs: maintain a list of pinned inodes
> * [PATCH v2 16/54] fs: delete the inode from the LRU list on lookup
> * [PATCH v2 17/54] fs: remove the inode from the LRU list on unlink/rmdir
> * [PATCH v2 18/54] fs: change evict_inodes to use iput instead of evict d=
irectly
> * [PATCH v2 19/54] fs: hold a full ref while the inode is on a LRU
> * [PATCH v2 20/54] fs: disallow 0 reference count inodes
> * [PATCH v2 21/54] fs: make evict_inodes add to the dispose list under th=
e i_lock
> * [PATCH v2 22/54] fs: convert i_count to refcount_t
> * [PATCH v2 23/54] fs: use refcount_inc_not_zero in igrab
> * [PATCH v2 24/54] fs: use inode_tryget in find_inode*
> * [PATCH v2 25/54] fs: update find_inode_*rcu to check the i_count count
> * [PATCH v2 26/54] fs: use igrab in insert_inode_locked
> * [PATCH v2 27/54] fs: remove I_WILL_FREE|I_FREEING check from __inode_ad=
d_lru
> * [PATCH v2 28/54] fs: remove I_WILL_FREE|I_FREEING check in inode_pin_lr=
u_isolating
> * [PATCH v2 29/54] fs: use inode_tryget in evict_inodes
> * [PATCH v2 30/54] fs: change evict_dentries_for_decrypted_inodes to use =
refcount
> * [PATCH v2 31/54] block: use igrab in sync_bdevs
> * [PATCH v2 32/54] bcachefs: use the refcount instead of I_WILL_FREE|I_FR=
EEING
> * [PATCH v2 33/54] btrfs: don't check I_WILL_FREE|I_FREEING
> * [PATCH v2 34/54] fs: use igrab in drop_pagecache_sb
> * [PATCH v2 35/54] fs: stop checking I_FREEING in d_find_alias_rcu
> * [PATCH v2 36/54] ext4: stop checking I_WILL_FREE|IFREEING in ext4_check=
_map_extents_env
> * [PATCH v2 37/54] fs: remove I_WILL_FREE|I_FREEING from fs-writeback.c
> * [PATCH v2 38/54] gfs2: remove I_WILL_FREE|I_FREEING usage
> * [PATCH v2 39/54] fs: remove I_WILL_FREE|I_FREEING check from dquot.c
> * [PATCH v2 40/54] notify: remove I_WILL_FREE|I_FREEING checks in fsnotif=
y_unmount_inodes
> * [PATCH v2 41/54] xfs: remove I_FREEING check
> * [PATCH v2 42/54] landlock: remove I_FREEING|I_WILL_FREE check
> * [PATCH v2 43/54] fs: change inode_is_dirtytime_only to use refcount
> * [PATCH v2 44/54] btrfs: remove references to I_FREEING
> * [PATCH v2 45/54] ext4: remove reference to I_FREEING in inode.c
> * [PATCH v2 46/54] ext4: remove reference to I_FREEING in orphan.c
> * [PATCH v2 47/54] pnfs: use i_count refcount to determine if the inode i=
s going away
> * [PATCH v2 48/54] fs: remove some spurious I_FREEING references in inode=
.c
> * [PATCH v2 49/54] xfs: remove reference to I_FREEING|I_WILL_FREE
> * [PATCH v2 50/54] ocfs2: do not set I_WILL_FREE
> * [PATCH v2 51/54] fs: remove I_FREEING|I_WILL_FREE
> * [PATCH v2 52/54] fs: remove I_REFERENCED
> * [PATCH v2 53/54] fs: remove I_LRU_ISOLATING flag
> * [PATCH v2 54/54] fs: add documentation explaining the reference count r=
ules for inodes
>
> and found the following issue:
> kernel build error
>
> Full report is available here:
> https://ci.syzbot.org/series/ccd4eafa-7a13-48d6-93b6-f40c03262bea
>
> ***
>
> kernel build error
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      fab1beda7597fac1cecc01707d55eadb6bbe773c
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/162c03ae-2d30-4085-ab1e-a2dd1c840=
3eb/config
>
> fs/bcachefs/fs.c:350:20: error: incompatible pointer types passing 'struc=
t bch_inode_info *' to parameter of type 'const struct inode *' [-Werror,-W=
incompatible-pointer-types]
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>   Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [amir73il@gmail.com brauner@kernel.org josef@toxicpanda.com kernel-team@f=
b.com linux-btrfs@vger.kernel.org linux-ext4@vger.kernel.org linux-fsdevel@=
vger.kernel.org linux-xfs@vger.kernel.org viro@zeniv.linux.org.uk]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/68ae1fb5.a70a0220.3cafd4.0001.GAE%40google.com.
