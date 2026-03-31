Received: from mail-oa1-f52.google.com (mail-oa1-f52.google.com [209.85.160.52])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 322703C0624
	for <syzbot@lists.linux.dev>; Tue, 31 Mar 2026 07:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.52
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774942757; cv=pass; b=YuYg4HYNOcVz5QcFyVeADo170ZZBsylE15gG+sxmxZvplC5YFFWx5EV7mz3JSTM4sqSI6xzRUUsBqVjBXQ0FbpZUEvrOhxNPsYi+lK1SP+ON+BKf10CVrdo6J5/9gJiO31kR86RPTdwl29EuWlS1u3Y2t9xGfTxEmgyOJ+yBTOM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774942757; c=relaxed/simple;
	bh=mYnegQZzkCTjItvCVevis86rBMuEAT2BhwBvP1L7uQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=s4qkY01w+i9kGnndu2WFqQhkx6wZIc1e4zEVkGn92qJkucBOlZdFD8Gv3rVbjterOSpjfdoQanxh8Xyhd5HqPdT3HP8qsYJ7LuzUISrYn4645AxMtRpFUSMUxwMiklSoVhWHv+Xu+TX8E961CqLnvHvyecLBObIK6vrCgCHX/pg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=UmUD/vta; arc=pass smtp.client-ip=209.85.160.52
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="UmUD/vta"
Received: by mail-oa1-f52.google.com with SMTP id 586e51a60fabf-40f1ffba6a0so2774527fac.0
        for <syzbot@lists.linux.dev>; Tue, 31 Mar 2026 00:39:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774942753; cv=none;
        d=google.com; s=arc-20240605;
        b=cDDoqTciMnjk5KRjye5NmsdM8XJbnuSiilFt/srxZNRzTxWkvaXPotee/OrDGk2zja
         GPdXosUEZhBKreGAQaOSodTPy3nI6lzhJbJLR3zYsWnDrQFUQ5wgzRJCK/Kr80hwlX+o
         dc2RyxcpowoxcNiF8mIljpy6BbT0U3NxH8rSlNVI0oQplcMkM62NwDASi1MBgxNwycGW
         ZZFnebGE8l7vTWyhgxXokPXdOkoiyQqjWRyG+YMY+Zj/133Y+esYa7XVtzmqBpqN2GkE
         Q+lEX3sU8K7hPuGxS+CVVxOg7pbXhADWYb9jbmIezZemMDuDqDqL0pFue+2i2iKrp+S6
         7xWw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=x8ohJ9oLmMXt6lDtq6GlpD6Tinpe3js9L0q6FVD8L50=;
        fh=Sc9cV7MnEolndSSZ+Xrca43tGgoQBulfhXysiXfdtOY=;
        b=MTA2rIoEnVsjMa6iM8pNHMcWidMuu4Mkt1Iv2769kEFDMd3JBPh2osB/H4Iymqhq8f
         lo5JK1fRxeU0Wbv2HEdv9uD33aUrJOYtV/FH1U6WEW4BRLiDRgo8R6JnIDi07k5yWRsy
         IT9UyOzG/q6pVayvfT9N2jugMqkfcCPWbwbjbtcEPLL7ZKtBXMto242twW6mt1/WfaBP
         WuYi1q0XX9y2KDVcYX8g262dOiAZG+EytnXDyWFEIPfd2wWrNq0RURFJDIfFkSMEe5Uj
         vTv8sC3w4ZfVP2FfXcz2fqF+ezIqFPtb/2nVoB5RSX2vbYwk6QX6R7XrsZkBPeeYSsXs
         y5xQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774942753; x=1775547553; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=x8ohJ9oLmMXt6lDtq6GlpD6Tinpe3js9L0q6FVD8L50=;
        b=UmUD/vtaXQXuYJ1aE8GT77mgsYcHz2vZ+UsHc6uVdWDESWlnEVP/dfV4qnQJpFFvU3
         qis6lpHC/Yqnif6sQOPfRQTzL97BMhUnIgscXp0fyKbSnkfiIPNvP8XmldM/LyaMRq8q
         P/hAHzNN4dCdgTT5YBjMjWr3YktCeUAzokpidrrznnkRITRAL2Atxct4N5B/AqIUbp1U
         +8d2d/A1ygB5oHnDMnoJvdiNiV5G4ESNSQbX6MyXKmniOElStr/1MvUWKHPZIjVbbfup
         ycxBSmb8zC4GwdyoW4N+sYSkDtAxnTTE+HG0lHUaAILnPxfgbI62+ibQ+WYrBdSqVr8p
         4DUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774942753; x=1775547553;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=x8ohJ9oLmMXt6lDtq6GlpD6Tinpe3js9L0q6FVD8L50=;
        b=jl97CXq2s3ePYPN+LDHU2WNJSjnx4lKGj6AWG3BhzJnQHXIm7WEw5FDZWLCLDqfieS
         yM548X07C4KPo3l7/V+3XcrtZan7EsykrzKCN4vabUDmiqCJYXvjekVKP8sSH1qRtcwN
         qnE1G9Ty2XUvKVbevPn1M+UzKV63sVgTRtL1HTGknuzTHSSjqjgjmy8GA7BeyPkprsur
         MPli5AkznUzWYURMUkBD7df5zI0s8UIutR6wlVa3Bl1O2SF8OXhiuTCFpURgLhRbQRKi
         AZQiVNP4Idi01B9ev8C6yymiNeAfn8KK9UVCnmnmByZFigM0Tr3zPYDgzvfypa5HZ33T
         IiBQ==
X-Forwarded-Encrypted: i=1; AJvYcCUqE31z+t5dMf9Gh6gMsKvqzv3vz1323hQKlPWZxyl8gPa1zbQjSSGRIe2RJeyOUEE8wG2zSYY=@lists.linux.dev
X-Gm-Message-State: AOJu0YwossLniSk72aL8snrSQaN8rJjoJcdZSVn1bIZadP1Jmjou7WAY
	fsg/ZVD1bQK/owFJ6zb0cdj/JtZ50rZKwohlCGrq7gjvY+jC6E3BcPUIfHMccoIRm2fnPMIyFNq
	QDIG2AwCZyHA9bcGphyYJvmhklSDVtQcYAL9iH31G
X-Gm-Gg: ATEYQzw68Tr0dTLGdW1QtwDCN6IcNlT176ZgAHjo7mDwNUoQZZIGqW7ewDOc46mPkq0
	fzvZYC485i3IIE1R1T56czrGuJNdF5BjHtJNuzjLGGZ9kn8oSmdA+cBw4mbQUEzSUh7n7uIHCxI
	qQFEY8qSYpJqp/aeSpy6IwJ1qEnxy3A8hLw3ngaq1EffDiuB3mEF+GtS3FxCPnjrgwtPD5KgMAf
	RrOLRftljIwpDm0cJfwaZ3oDUxhU05wbpyhKzEolUux4eD1PaE8+Bd7tDwX7Q36d6X9i9dQKqG1
	69RqXXhAK6W/moZaHU/JtEnUuBylZhfH5WUZloMoSqv+Ps+7JHi6eXJuDvEYG/ycT6yt+cD3aV9
	5KFl8
X-Received: by 2002:a05:6870:a44a:b0:41c:9c97:21b3 with SMTP id
 586e51a60fabf-41cec268e95mr8202785fac.16.1774942752341; Tue, 31 Mar 2026
 00:39:12 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69cb0e6d.050a0220.183828.001d.GAE@google.com>
In-Reply-To: <69cb0e6d.050a0220.183828.001d.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 31 Mar 2026 09:39:01 +0200
X-Gm-Features: AQROBzBJl0LsqL9RFFIWkEOgTsVesDAWYHmIQN5OTf-HSYuHM2GXDZ8SxnW-C4w
Message-ID: <CANp29Y66wt4eueBMGEUhq_f3zLHOSGevc-M6u+4QFAX-37t3OA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/vmalloc: Use dedicated unbound workqueue
 for vmap purge/drain
To: syzbot ci <syzbot+cif00a2aa5a854ea21@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Mar 31, 2026 at 1:59=E2=80=AFAM syzbot ci
<syzbot+cif00a2aa5a854ea21@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm/vmalloc: Use dedicated unbound workqueue for vmap purge/drain
> https://lore.kernel.org/all/20260330175824.2777270-1-urezki@gmail.com
> * [PATCH v2] mm/vmalloc: Use dedicated unbound workqueue for vmap purge/d=
rain
>
> and found the following issue:
> possible deadlock in touch_wq_lockdep_map
>
> Full report is available here:
> https://ci.syzbot.org/series/4a8f638e-3a3f-4346-8189-2b5a0eb9ceaf
>
> ***
>
> possible deadlock in touch_wq_lockdep_map
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      af42d6d3650b95295a3f08fc35189998bc26c2e1
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/d94b1f61-6a69-4415-b385-b3c99018e=
8c2/config
> syz repro: https://ci.syzbot.org/findings/01e4d436-e924-4ce6-8902-78c6000=
bf34e/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> kworker/u9:1/33 is trying to acquire lock:
> ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: touch_wq_lo=
ckdep_map+0xb5/0x180 kernel/workqueue.c:3991
>
> but task is already holding lock:
> ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_one=
_work kernel/workqueue.c:3251 [inline]
> ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: process_sch=
eduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock((wq_completion)vmap_drain);
>   lock((wq_completion)vmap_drain);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 4 locks held by kworker/u9:1/33:
>  #0: ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: proces=
s_one_work kernel/workqueue.c:3251 [inline]
>  #0: ffff88810168e948 ((wq_completion)vmap_drain){+.+.}-{0:0}, at: proces=
s_scheduled_works+0xa52/0x18c0 kernel/workqueue.c:3359
>  #1: ffffc90000a97c40 (drain_vmap_work){+.+.}-{0:0}, at: process_one_work=
 kernel/workqueue.c:3252 [inline]
>  #1: ffffc90000a97c40 (drain_vmap_work){+.+.}-{0:0}, at: process_schedule=
d_works+0xa8d/0x18c0 kernel/workqueue.c:3359
>  #2: ffffffff8e87ed68 (vmap_purge_lock){+.+.}-{4:4}, at: drain_vmap_area_=
work+0x17/0x40 mm/vmalloc.c:2443
>  #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:312 [inline]
>  #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:850 [inline]
>  #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: start_flush_work k=
ernel/workqueue.c:4234 [inline]
>  #3: ffffffff8e75e5e0 (rcu_read_lock){....}-{1:3}, at: __flush_work+0x100=
/0xc50 kernel/workqueue.c:4292
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 33 Comm: kworker/u9:1 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: vmap_drain drain_vmap_area_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
>  check_deadlock kernel/locking/lockdep.c:3093 [inline]
>  validate_chain kernel/locking/lockdep.c:3895 [inline]
>  __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
>  lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
>  touch_wq_lockdep_map+0xcb/0x180 kernel/workqueue.c:3991
>  start_flush_work kernel/workqueue.c:4272 [inline]
>  __flush_work+0x87c/0xc50 kernel/workqueue.c:4292
>  __purge_vmap_area_lazy+0x7db/0xab0 mm/vmalloc.c:2419
>  drain_vmap_area_work+0x27/0x40 mm/vmalloc.c:2444
>  process_one_work kernel/workqueue.c:3276 [inline]
>  process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [akpm@linux-foundation.org bhe@redhat.com linux-kernel@vger.kernel.org li=
nux-mm@kvack.org lirongqing@baidu.com urezki@gmail.com]
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
-upstream-moderation/69cb0e6d.050a0220.183828.001d.GAE%40google.com.
