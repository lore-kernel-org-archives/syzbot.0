Received: from mail-ot1-f52.google.com (mail-ot1-f52.google.com [209.85.210.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3A3C207DE2
	for <syzbot@lists.linux.dev>; Sat, 20 Dec 2025 15:58:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.52
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1766246316; cv=none; b=gy1m3u7fk99TXy1Z2UnwV8Az+3dXWZ6smBpp8g5hOAblb/u4wJ4cLFMcSPZDmnB7pa3srS9OSP1ZnMsR8UUrChy/ut1W688G83R5Pex8YmFZN98y9mCYZAVRqR6Gxq8xeErANn9veEUcfxUpfBeeVEtl1S8SkcolxALMFvyUX9I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1766246316; c=relaxed/simple;
	bh=j1U+qUzD8qMEeVNe1HucJYiXtEEUq0EqdiXYIGHhPyU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XLFs61h3S5P07Y9IhErvt78wkGITSJvIxA17wryGcGTeVYWwXT+Tx6QCnKYi6eF0rfzgBmVWP4GViD3bAOtFY+a0PbLY7D3FaX6GxZmyuMVQT+ZwoPQ8dZlryUkYYd2TXac39yKNcbeXQIzhHVBTrD1aB5+ArIVYDdIBx1gvzSs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=uN89buft; arc=none smtp.client-ip=209.85.210.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="uN89buft"
Received: by mail-ot1-f52.google.com with SMTP id 46e09a7af769-7c6d13986f8so2332297a34.0
        for <syzbot@lists.linux.dev>; Sat, 20 Dec 2025 07:58:34 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1766246314; x=1766851114; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=otPTTgOTpjoutNdCEhyuiMkLqJxcy6hY1SEYpX2R21Y=;
        b=uN89buftel2cxG0hkFXBucEJee9nTXc3b0tatVAWnGHBwebGzDQnWl3jmUVUqujtz/
         0l8ozc6cbCnwNJBrjnbWAvpGXYH6t7L4QX5R/vjMPlKyk9VY233mdNLzwQ20gDuYCPWT
         0sHKeWQYxdHA6DdJR0X/QkrXtryjnuh53wLJ81SzanS5zcUQJex9gj/kdI1TcoOMk3rY
         YJxN+PStrZgHZqQaYQquRA5Aov8wUdFI6jsu8CjBOHZdWpMwNhVTYpzs60O9WnxwnK6p
         eOUCaDcwvx+FTbtp0Hs2VmBTIzA59FRWyFCRlYG+84cHag8JVCd3t96ETbWox/ep3WwO
         sRBw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1766246314; x=1766851114;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=otPTTgOTpjoutNdCEhyuiMkLqJxcy6hY1SEYpX2R21Y=;
        b=lZnbIN/KquK34RlEJ99zk+8K7+9ZIyzg6AM3+AqOVvYWp91W1NCRqIC20LlqZuUCEp
         Z72FfWdolCWnG6KUYfMVyAyxOO0MeN5DbbZHA7jDHrwZtgbGZzOs28b1bltZB4WQrFQN
         PI+VADpzpqJLhK5S9bGOv+G8M8ww9PadqQOg/7JIGkE0PPoclvsMLIhYJMUYG1oxHHcx
         zghmEhHly+9wxE1IF2cTwTZrNjR0WsQEAoQ1g1yp5KvqM96YnBzEDxe2BjOAdHy9OWZ/
         k5zKDfsO4KRedGKJ7Mfo1dSEZjjjd2uDvpUzAkJLIuCtwZJA8Z9QMvt30tVg2EeOvtAO
         6/+Q==
X-Forwarded-Encrypted: i=1; AJvYcCXQ80LgTaHKfEDC8ketGWtyeQaZ4XeUfQzaVlhgxOSCdwEHCaVzO3dgy6wasVWf87DuAgKwLJA=@lists.linux.dev
X-Gm-Message-State: AOJu0YyseVH5KnwcUBK/bIsi8vyi7+18ZEl6WzWT3KhB6dXdf2a8WVD8
	4SWN+On6DpXsM1cA7sTookA6GO1fGnE5wti57T2tRE0vNUn3ihvqYdJMyD1ddBYecpZo5ViVE/+
	GRhEK51g0Y68yHTXDpRNzbUdI0K/CAdsi12AeCeIhFdtXyDEgFM2l/Lc2
X-Gm-Gg: AY/fxX7ga4cvFXUhp7rGuLeojbe6M9wYy1t/E8WXUDWBWCkecXccoGRmgN12BAQrOzJ
	1qWaJdgC+e35VpmfZvgnACy9jEpI/swjZXKZVFoD6G2Aa2dYBP2yevcx0J9SI71/+/6qm92oSJ+
	+42+DOV5vC5HzydOiuv2D69T60qF1jQsr9b3IhpDrZrIx+rfzPEanKrm6esTmOWIksBfQHYMJdx
	J0Cqm6OgX4471nw/u7X8BGrDlz2Hp7uQ6n+oTv/U1wmwaCqhBOiYqw55smQaiG/vf84ApfMRCnY
	CyMBZpbWwkRQMTZQ8BlTvPOjUQ==
X-Google-Smtp-Source: AGHT+IFre1/50JYWsCjavTT9WJnfKayGo7Gc57x7D05ckzaGCxeaYXVeHH9uTtYs15iVxZEyxghXnA9BYEip6/lkXhI=
X-Received: by 2002:a9d:7f85:0:b0:7c9:5a31:956 with SMTP id
 46e09a7af769-7cc58ac1db8mr3558339a34.1.1766246313541; Sat, 20 Dec 2025
 07:58:33 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6946bc28.a70a0220.207337.0138.GAE@google.com>
In-Reply-To: <6946bc28.a70a0220.207337.0138.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 21 Dec 2025 00:58:22 +0900
X-Gm-Features: AQt7F2raD5d7AoxBWhfpCrdblRKnJZjQIfO5ig_weHezVvYEi2TMUPNzu8ZpaZk
Message-ID: <CANp29Y7u1P0q0AENoCx3Om48V+9OGRCAQyi3R3yuF=usexzPGw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: block/blk-mq: fix RT kernel performance regressions
To: syzbot ci <syzbot+ci98a6170d5e3c72b3@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Dec 21, 2025 at 12:09=E2=80=AFAM syzbot ci
<syzbot+ci98a6170d5e3c72b3@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] block/blk-mq: fix RT kernel performance regressions
> https://lore.kernel.org/all/20251220110241.8435-1-ionut.nechita@windriver=
.com
> * [PATCH 1/2] block/blk-mq: fix RT kernel regression with queue_lock in h=
ot path
> * [PATCH 2/2] block/blk-mq: convert blk_mq_cpuhp_lock to raw_spinlock for=
 RT
>
> and found the following issues:
> * BUG: sleeping function called from invalid context in __cpuhp_state_add=
_instance
> * BUG: sleeping function called from invalid context in __cpuhp_state_rem=
ove_instance
>
> Full report is available here:
> https://ci.syzbot.org/series/632f4721-6256-44fd-83f5-bf439d5f33f9
>
> ***
>
> BUG: sleeping function called from invalid context in __cpuhp_state_add_i=
nstance
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      dd9b004b7ff3289fb7bae35130c0a5c0537266af
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/9ad1c682-13b1-4626-b61a-a21563846=
98d/config
> C repro:   https://ci.syzbot.org/findings/f999a055-07f3-4d7a-acfd-8bc0be6=
1e2ec/c_repro
> syz repro: https://ci.syzbot.org/findings/f999a055-07f3-4d7a-acfd-8bc0be6=
1e2ec/syz_repro
>
> BUG: sleeping function called from invalid context at ./include/linux/per=
cpu-rwsem.h:51
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5982, name: syz.0.=
17
> preempt_count: 1, expected: 0
> RCU nest depth: 0, expected: 0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 UID: 0 PID: 5982 Comm: syz.0.17 Tainted: G        W           syzk=
aller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  __might_resched+0x495/0x610 kernel/sched/core.c:8827
>  percpu_down_read_internal include/linux/percpu-rwsem.h:51 [inline]
>  percpu_down_read include/linux/percpu-rwsem.h:77 [inline]
>  cpus_read_lock+0x1b/0x160 kernel/cpu.c:491
>  __cpuhp_state_add_instance+0x19/0x40 kernel/cpu.c:2454
>  cpuhp_state_add_instance_nocalls include/linux/cpuhotplug.h:401 [inline]
>  __blk_mq_add_cpuhp block/blk-mq.c:3858 [inline]
>  blk_mq_add_hw_queues_cpuhp+0x19a/0x250 block/blk-mq.c:3906
>  blk_mq_realloc_hw_ctxs block/blk-mq.c:4611 [inline]
>  blk_mq_init_allocated_queue+0x366/0x1350 block/blk-mq.c:4635
>  blk_mq_alloc_queue block/blk-mq.c:4416 [inline]
>  __blk_mq_alloc_disk+0x1f0/0x340 block/blk-mq.c:4459
>  loop_add+0x411/0xad0 drivers/block/loop.c:2050
>  loop_control_ioctl+0x128/0x5a0 drivers/block/loop.c:2216
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1dc598f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffff2134d08 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f1dc5be5fa0 RCX: 00007f1dc598f7c9
> RDX: 00000000004080f9 RSI: 0000000000004c80 RDI: 0000000000000003
> RBP: 00007f1dc59f297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f1dc5be5fa0 R14: 00007f1dc5be5fa0 R15: 0000000000000003
>  </TASK>
>
>
> ***
>
> BUG: sleeping function called from invalid context in __cpuhp_state_remov=
e_instance
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      dd9b004b7ff3289fb7bae35130c0a5c0537266af
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/9ad1c682-13b1-4626-b61a-a21563846=
98d/config
> C repro:   https://ci.syzbot.org/findings/f39691bc-570a-4163-9791-31ce10e=
18fb6/c_repro
> syz repro: https://ci.syzbot.org/findings/f39691bc-570a-4163-9791-31ce10e=
18fb6/syz_repro
>
> BUG: sleeping function called from invalid context at ./include/linux/per=
cpu-rwsem.h:51
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5975, name: syz.0.=
17
> preempt_count: 1, expected: 0
> RCU nest depth: 0, expected: 0
> INFO: lockdep is turned off.
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 0 UID: 0 PID: 5975 Comm: syz.0.17 Tainted: G        W           syzk=
aller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  __might_resched+0x495/0x610 kernel/sched/core.c:8827
>  percpu_down_read_internal include/linux/percpu-rwsem.h:51 [inline]
>  percpu_down_read include/linux/percpu-rwsem.h:77 [inline]
>  cpus_read_lock+0x1b/0x160 kernel/cpu.c:491
>  __cpuhp_state_remove_instance+0x77/0x2e0 kernel/cpu.c:2565
>  cpuhp_state_remove_instance_nocalls include/linux/cpuhotplug.h:502 [inli=
ne]
>  __blk_mq_remove_cpuhp+0x140/0x1a0 block/blk-mq.c:3835
>  blk_mq_remove_cpuhp block/blk-mq.c:3844 [inline]
>  blk_mq_exit_hw_queues block/blk-mq.c:3974 [inline]
>  blk_mq_exit_queue+0xe8/0x380 block/blk-mq.c:4670
>  __del_gendisk+0x832/0x9e0 block/genhd.c:774
>  del_gendisk+0xe8/0x160 block/genhd.c:823
>  loop_remove+0x42/0xc0 drivers/block/loop.c:2121
>  loop_control_remove drivers/block/loop.c:2180 [inline]
>  loop_control_ioctl+0x4ac/0x5a0 drivers/block/loop.c:2218
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f911d78f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd4f0e1fb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f911d9e5fa0 RCX: 00007f911d78f7c9
> RDX: 0000000000000006 RSI: 0000000000004c81 RDI: 0000000000000003
> RBP: 00007f911d7f297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f911d9e5fa0 R14: 00007f911d9e5fa0 R15: 0000000000000003
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
> The email will later be sent to:
> [axboe@kernel.dk djiony2011@gmail.com gregkh@linuxfoundation.org ionut.ne=
chita@windriver.com linux-block@vger.kernel.org linux-kernel@vger.kernel.or=
g ming.lei@redhat.com muchun.song@linux.dev sashal@kernel.org stable@vger.k=
ernel.org]
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
-upstream-moderation/6946bc28.a70a0220.207337.0138.GAE%40google.com.
