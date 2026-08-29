Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF17413959D
	for <syzbot@lists.linux.dev>; Sat, 29 Aug 2026 09:01:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787994095; cv=pass; b=DgUvaVBEivLuq4jPszGKCDxbvyfoLQf+vMpRv6D6CjQijr5rweUhRYvZjScwrk5Dum45WkRZ5FrPiR88ZYoj5yDHgN0xlu13ioZZjkh/iNPgJ/TeM+iTqACqhm7oseKqZMoPciQnIr0jKbBe4Huhm7GMVVcWb7lMEGyDZBwuAbM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787994095; c=relaxed/simple;
	bh=tnoo/VVJP9j0kr9D1QQkfO+hdSneTvN0E9STHNX/m7o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FxMv2NARJk9/8UwzlslZoF/GhnBh62swHgZQfq44j/UNIwFNqG3EcGFrXikq7mNCDN6T2wHK48TLouMlEZ5KSIEv7V119W64HS7myBLuDDhfbwZNUAIjysVaWMr2R9xlmYaEEMsOJfHGIGhOYV57Zvo//z/NaGXZFATz73w9s98=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aSxEQQDq; arc=pass smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aSxEQQDq"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7f64ea07036so529560a34.0
        for <syzbot@lists.linux.dev>; Sat, 29 Aug 2026 02:01:33 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787994093; cv=none;
        d=google.com; s=arc-20260327;
        b=bNyeoTTWZBsTxNncNbevsLBCrRKXgcPZMyfFxw8Tksi6K/rNPA12mBGA7wG/yaEBSi
         oFjltnZBRzo+TOtiRzOj3jA6F5yMg+HPD/AFAAlw4fbc94ZcEO2pi5ISMArvZy5g3OCB
         Vp94Er/lnGt5JowNmUA1A6f5lJ4ZrJZLOuWvYBka0lq2BRg8tPSDaNWzpoD6zZgO4Hk/
         iYme2dAwv0i+YAWiOLs5HMPzeSfp8pnhAJ9FibAQImMquuaf07tmZoxAQolUsiqs7T60
         q7OPwCRkkXAyYdP2wI5/6uLSPDbkbOP7fMutZBw+2A3ScfDp8fa3vPTOYRphDAPEbEo9
         UZ9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+zIqLsQI48vHMIx1Jfzz+TNZlJvw6KaZ2wK5Kvu9Rxo=;
        fh=JByATkcYjV9AguaZDHqPP24FJBp0vAOwy6Wk38t2PmQ=;
        b=bK+0RUJ0E3MydqJYjWbWYydSMRKE0EwfaXWfs76SzRZ2/QUQGLFXUtKQcF4fhAXCEG
         O0AqbmWeCeiUn3JHDxBz7IFaSK53I2P3fRi3tWgoau01E+EMJj6hqtvYvTTcBfooIHtO
         0SSIZcpqf5t/883Ko+hwg8sF7Xcb0+ba8dNPx3doUn15QOQc7SRNJGukAr1Fo1jTIQDg
         vwrRPS+Rfzx05I1phJYPG9GFURBzPLiLMMCeBsCPCATPrYEH/+chkN04j2cGy67uegla
         QieOdcKRwoxbFfVYkYimlqgno+oUNfefb8jUibF6sURpfwvUpeGPrsJ66xN883YihrKN
         HpbQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787994093; x=1788598893; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=+zIqLsQI48vHMIx1Jfzz+TNZlJvw6KaZ2wK5Kvu9Rxo=;
        b=aSxEQQDqz1TpKCMLdCLmUI2S/1WtzpM1c9kbVjaCfEyukDwAmfQ18x9LbRe0sFmu2T
         VrT6JEMZx0KSoteeMoIqGvTP7+agRv+yPk71u+MqEK0a9OYsvltnntL9AHSG70Mnfptc
         /NQUT61m6tbUuxJ4YOCBd7weOjbz6a/aF5eEMLrVpgFECPZnrLR3KOsK0HFpAxQ9ZcFb
         QP3SfBq/qpGOj+8uwyZ5mVkQAmiCTfNLrGq/PK/cLwcE5p7vUW0brF7RHwPXjbNCq6hL
         lspybostzXPgfXlgyR6r16iuvxuJ3e1JzS1LccTyzTUWSsVsq9IXnLbc8ostYkYIQNBP
         yOpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787994093; x=1788598893;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=+zIqLsQI48vHMIx1Jfzz+TNZlJvw6KaZ2wK5Kvu9Rxo=;
        b=quJ8C8lwLP3Z79Ewga2A/tANXIpdlkxKEpxWA+D/559RkG9+pOcqIw8s2FsKIh2qhY
         LVjdQs6CxkjuGO8pjJ+8t4RsbyhyUi3pBDZVFI60aEYOvy3h/lKGxAkQJBwu3f2QhDek
         RTft9zTiq4Z/jqaw3aD3WRuWdzO3Ceb75W/CMv89jO6Jkkp1nhMwN81hM3pcH73yy8yn
         XbR80sA9+slhyFbxGk95MSbLAmgenVx9tRBi9JpkCNqM6X+LU2zrnpTMBznHyMYnCxOh
         7GbkBvgKnl+gQqa6ZGOSn8zUMRMoZyvbEnNSGmi27vFmlhWNUbro8GWZCboeMPBjd6Ag
         xr/A==
X-Forwarded-Encrypted: i=1; AHgh+Rq3NEF1nNYOxSZKXXYTu+kOKpe/bXKlvx6HBmikdWnqqcN4tKKR+qFG3VDX9Y++LBonDXkhH00=@lists.linux.dev
X-Gm-Message-State: AFuF++nhpur+egdh4bU4uazcb3uyRvybfPJSTTW38XGJ1GQo/Mq24lRn
	0zEwUgsP0lJ6JqsnajrUtE0iOrUhu9Kn5DoYxTFvah1nx8iGVtZBd1ZsassOJq3HNLgsf1Ra4b+
	FFE3ZRNzlM7l0W3qHaq1X4GziVKW879bR8vj52zg3
X-Gm-Gg: AR+sD125fvDnFk7sKYpYqu7UgV6uX1pygM34796yxRAN3osrtZQu0mbLbKW0JFYrtKh
	ko0J2jdJOlTOJ9I8TZaTqsQFfcW/QttjRzKjKSPLQUPOiTk4B1eNsSUMW7H5V/Gj0kwOAzIwSTJ
	bmgwTyxeD8U6AIc11Kvr4m5KwMc92bRkdgSukd3ja51vpzWMunHvkG7Enp1CsDaLfkJ3w2f/fal
	Kk2ihYuEkv2wSWjTDoPfDBd5fYnnrfSLF7mH1ZHMvzZuR1xWl7+uVEET7u6lk6tdJNxa4j2ioPD
	uMFDNmU9BT0Txq8bLH6XlyQ2leqch5GaR01jvaXLE6xZZ9kT7iV6x49h+8Bjl8W5DCKDvCbqTAo
	ALvKb7QueNA+U8NciPXceHRYpPgHa+S4X2qiRCZ9zTel5nT8QpmROtbY6s5JMcz5nlIQAkBqszL
	fk8gvGlvMV9rObhg==
X-Received: by 2002:a05:6830:3111:b0:7e6:efb8:fe66 with SMTP id
 46e09a7af769-7f4f25c6791mr16441221a34.12.1787994091882; Sat, 29 Aug 2026
 02:01:31 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a920fc6.1d9ded08.62e62.00f6.GAE@google.com>
In-Reply-To: <6a920fc6.1d9ded08.62e62.00f6.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 29 Aug 2026 11:01:20 +0200
X-Gm-Features: AcwNN1VXmh0d0CvLHzqyGpKT4w-dVu3iA94maMNYJRvMvC7PiLoT26TMoHgzBQ4
Message-ID: <CANp29Y5bT7Lu3b6pJri1ySeDZ5SbX5hV-yzStydfguicsT8XMA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE
 bit on isolated cpus
To: syzbot ci <syzbot+cied200eaa2d6d2b7c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz invalid


On Sat, Aug 29, 2026 at 12:46=E2=80=AFAM syzbot ci
<syzbot+cied200eaa2d6d2b7c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isolated cpus
> https://lore.kernel.org/all/20260828135036.7d44361f@fangorn
> * [PATCH v2] mm/memcontrol: fix stuck FLUSHING_CACHED_CHARGE bit on isola=
ted cpus
>
> and found the following issue:
> possible deadlock in blkg_conf_prep
>
> Full report is available here:
> https://ci.syzbot.org/series/b7c6073d-9eac-41ad-921f-a90980058034
>
> ***
>
> possible deadlock in blkg_conf_prep
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      91011cec827788fde4bddbf45ecc507525c2ae06
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/c13b10a4-7bea-4b4c-a897-542d751e8=
04f/config
> syz repro: https://ci.syzbot.org/findings/539b38db-9b98-4110-88d1-eee5408=
4fc25/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz.0.23/5880 is trying to acquire lock:
> ffffffff8ee8f800 (fs_reclaim){+.+.}-{0:0}, at: might_alloc include/linux/=
sched/mm.h:316 [inline]
> ffffffff8ee8f800 (fs_reclaim){+.+.}-{0:0}, at: slab_pre_alloc_hook mm/slu=
b.c:4636 [inline]
> ffffffff8ee8f800 (fs_reclaim){+.+.}-{0:0}, at: slab_alloc_node mm/slub.c:=
4974 [inline]
> ffffffff8ee8f800 (fs_reclaim){+.+.}-{0:0}, at: kmem_cache_alloc_noprof+0x=
5f/0x600 mm/slub.c:5010
>
> but task is already holding lock:
> ffff88810a0b3bc0 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkg_conf_prep+0xa3/0=
xd80 block/blk-cgroup.c:849
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #2 (&q->blkcg_mutex){+.+.}-{4:4}:
>        __mutex_lock_common kernel/locking/mutex.c:646 [inline]
>        __mutex_lock+0x19d/0x1550 kernel/locking/mutex.c:821
>        blkcg_activate_policy+0x1cb/0x8e0 block/blk-cgroup.c:1608
>        blk_throtl_init+0x2f7/0x420 block/blk-throttle.c:1339
>        tg_set_conf+0x1db/0x4e0 block/blk-throttle.c:1368
>        cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4412
>        kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
>        new_sync_write fs/read_write.c:595 [inline]
>        vfs_write+0x612/0xba0 fs/read_write.c:687
>        ksys_write+0x150/0x270 fs/read_write.c:739
>        do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>        do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #1 (&q->q_usage_counter(io)#17){++++}-{0:0}:
>        blk_alloc_queue+0x544/0x690 block/blk-core.c:504
>        blk_mq_alloc_queue block/blk-mq.c:4420 [inline]
>        __blk_mq_alloc_disk+0x194/0x390 block/blk-mq.c:4467
>        loop_add+0x480/0xb40 drivers/block/loop.c:2071
>        loop_init+0xd7/0x160 drivers/block/loop.c:2310
>        do_one_initcall+0x250/0x870 init/main.c:1357
>        do_initcall_level+0x10a/0x1a0 init/main.c:1419
>        do_initcalls+0x59/0xa0 init/main.c:1435
>        kernel_init_freeable+0x29d/0x3e0 init/main.c:1670
>        kernel_init+0x22/0x1d0 init/main.c:1560
>        ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>
> -> #0 (fs_reclaim){+.+.}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3181 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3300 [inline]
>        validate_chain kernel/locking/lockdep.c:3924 [inline]
>        __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5254
>        lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
>        __fs_reclaim_acquire mm/page_alloc.c:4375 [inline]
>        fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4389
>        might_alloc include/linux/sched/mm.h:316 [inline]
>        slab_pre_alloc_hook mm/slub.c:4636 [inline]
>        slab_alloc_node mm/slub.c:4974 [inline]
>        kmem_cache_alloc_noprof+0x5f/0x600 mm/slub.c:5010
>        __radix_tree_preload+0x2df/0x870 lib/radix-tree.c:338
>        blkg_conf_prep+0x621/0xd80 block/blk-cgroup.c:885
>        tg_set_conf+0x20b/0x4e0 block/blk-throttle.c:1373
>        cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4412
>        kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
>        new_sync_write fs/read_write.c:595 [inline]
>        vfs_write+0x612/0xba0 fs/read_write.c:687
>        ksys_write+0x150/0x270 fs/read_write.c:739
>        do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>        do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> other info that might help us debug this:
>
> Chain exists of:
>   fs_reclaim --> &q->q_usage_counter(io)#17 --> &q->blkcg_mutex
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   lock(&q->blkcg_mutex);
>                                lock(&q->q_usage_counter(io)#17);
>                                lock(&q->blkcg_mutex);
>   lock(fs_reclaim);
>
>  *** DEADLOCK ***
>
> locks held by syz.0.23/5880: 6, last CPU#1:
>  #0: ffff88816db7d8f0 (&f->f_pos_lock){+.+.}-{4:4}, at: fdget_pos+0x246/0=
x320 fs/file.c:1259
>  #1: ffff88816ee86460 (sb_writers#10){.+.+}-{0:0}, at: file_start_write i=
nclude/linux/fs.h:2753 [inline]
>  #1: ffff88816ee86460 (sb_writers#10){.+.+}-{0:0}, at: vfs_write+0x22b/0x=
ba0 fs/read_write.c:683
>  #2: ffff88816db7ac80 (&of->mutex){+.+.}-{4:4}, at: kernfs_fop_write_iter=
+0x1d8/0x540 fs/kernfs/file.c:336
>  #3: ffff88816fe82e18 (kn->active#56){.+.+}-{0:0}, at: kernfs_get_active_=
of fs/kernfs/file.c:73 [inline]
>  #3: ffff88816fe82e18 (kn->active#56){.+.+}-{0:0}, at: kernfs_fop_write_i=
ter+0x22b/0x540 fs/kernfs/file.c:337
>  #4: ffff88810a0b3a40 (&q->rq_qos_mutex){+.+.}-{4:4}, at: blkg_conf_open_=
bdev+0x2a8/0x3c0 block/blk-cgroup.c:806
>  #5: ffff88810a0b3bc0 (&q->blkcg_mutex){+.+.}-{4:4}, at: blkg_conf_prep+0=
xa3/0xd80 block/blk-cgroup.c:849
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 5880 Comm: syz.0.23 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_circular_bug+0x2e2/0x300 kernel/locking/lockdep.c:2059
>  check_noncircular+0x12f/0x150 kernel/locking/lockdep.c:2191
>  check_prev_add kernel/locking/lockdep.c:3181 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3300 [inline]
>  validate_chain kernel/locking/lockdep.c:3924 [inline]
>  __lock_acquire+0x15ff/0x2e50 kernel/locking/lockdep.c:5254
>  lock_acquire+0x115/0x350 kernel/locking/lockdep.c:5908
>  __fs_reclaim_acquire mm/page_alloc.c:4375 [inline]
>  fs_reclaim_acquire+0x71/0x100 mm/page_alloc.c:4389
>  might_alloc include/linux/sched/mm.h:316 [inline]
>  slab_pre_alloc_hook mm/slub.c:4636 [inline]
>  slab_alloc_node mm/slub.c:4974 [inline]
>  kmem_cache_alloc_noprof+0x5f/0x600 mm/slub.c:5010
>  __radix_tree_preload+0x2df/0x870 lib/radix-tree.c:338
>  blkg_conf_prep+0x621/0xd80 block/blk-cgroup.c:885
>  tg_set_conf+0x20b/0x4e0 block/blk-throttle.c:1373
>  cgroup_file_write+0x331/0x8f0 kernel/cgroup/cgroup.c:4412
>  kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
>  new_sync_write fs/read_write.c:595 [inline]
>  vfs_write+0x612/0xba0 fs/read_write.c:687
>  ksys_write+0x150/0x270 fs/read_write.c:739
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8d5f99e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f8d608b0028 EFLAGS: 00000246 ORIG_RAX: 0000000000000001
> RAX: ffffffffffffffda RBX: 00007f8d5fc25fa0 RCX: 00007f8d5f99e159
> RDX: 000000000000006a RSI: 00002000000000c0 RDI: 0000000000000005
> RBP: 00007f8d5fa35024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f8d5fc26038 R14: 00007f8d5fc25fa0 R15: 00007ffd10d387c8
>  </TASK>
>
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [akpm@linux-foundation.org cgroups@vger.kernel.org hannes@cmpxchg.org ker=
nel-team@meta.com linux-kernel@vger.kernel.org linux-mm@kvack.org mhocko@ke=
rnel.org muchun.song@linux.dev riel@surriel.com roman.gushchin@linux.dev sh=
akeel.butt@linux.dev]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/6a920fc6.1d9ded08.62e62.00f6.GAE%40google.com.
