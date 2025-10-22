Received: from mail-oi1-f174.google.com (mail-oi1-f174.google.com [209.85.167.174])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E9F7B2D0601
	for <syzbot@lists.linux.dev>; Wed, 22 Oct 2025 21:38:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.174
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761169123; cv=none; b=c5uOsJt6PMxrwp6+nkF1ll8KrMVErOyrkKGpQ85t3hk6BobaJNTwWOoSn1iavtKcSQbXcVGkp21qh65K1DCFGEb4GHZ0kDeAActSx9RBxpGrk/ncFWQe+TJ7ptDSzt+9uMwpl7AeYds/YR1eQP0gjeo+hMv7t3pcIG34w2IwPdE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761169123; c=relaxed/simple;
	bh=5MGodAabuBr7xCVTjrVWvvY/zOJJC7fDW7Zdj/UKl4M=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=iRzJcT6RQuuRS3Vi1DkCEq602KBdSIich0NIwhly6wzIkqjh1CpX9DhRMAWaIMxn+wGjID53PixdK+wo5NOgkN+Dj7mAdujlWRSrpLhHsfm/XwAWKQoeSRjBEoCr27+EC/jea+EoVOvn+YplyZen85v6IHctD9Kc1L0yLocUC78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mnxpsY5s; arc=none smtp.client-ip=209.85.167.174
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mnxpsY5s"
Received: by mail-oi1-f174.google.com with SMTP id 5614622812f47-43f9cc65f66so15939b6e.2
        for <syzbot@lists.linux.dev>; Wed, 22 Oct 2025 14:38:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1761169121; x=1761773921; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ff4UXa7vix3FN+XtPH4FaSSLih0PuNWk6lGhGAA9YxE=;
        b=mnxpsY5sfQTEacREW9PkaNkXqMIK3Xx/yGOdX2VzoS1BzTKlezF0FK1tgcY808xZzG
         C015FAWgUUot5ltxtI5Ie8Tiq1nU3Pe9s5Z6v5a/0dpbF7mRoc1QGXLsjXMXudciqpaH
         9U9JS1erBtzzvVzUN0SbW6oAKxBX3Ct+wTLKK0nab2UgPnEqdkSotBnpYhnhp46bbOz9
         FoYLDlmngs/V5Osr4rQccoPykVN7/ZA4e2lfBvBNJIVv3w9C7mEE64pCM+rsK0QOjwOP
         Jga3V0FTVOx25WCjRrTwX8e1pZAvcRfqfH1hfGSFkdKyVNYcvZkdXegxTxAFDcJlh8yP
         wH/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761169121; x=1761773921;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=ff4UXa7vix3FN+XtPH4FaSSLih0PuNWk6lGhGAA9YxE=;
        b=w5Df7yQGHPIxCjZQWn1ZPDuZXSya2y5hyblcvjXZQBzYdLMlI/vdHU59x62QtsHVVC
         GT+ot0WoKt+k5PwgBi0KNtskCvQflk1vA0e5cVuzfu838Gaqafc5A0uwZh5uDPzODo5r
         I2GLuQ66TZwPqM0HdU2lHVPaQhPTjV4ku5w6fCItGs/+CrIuF0JMlCucMMsweQp3NgfF
         lL58wbTB2T5elLBn7yhyMNBAQA3CYGJ9yjvg556xHQCzohKF8p0kQzwOAC/YrwwF8e07
         LJbOBbljPtObqM3ea1DoXN8DC/OtlXOqp7g+3acjRLnGT4JBaZG4AYQR5GUb6aiit5KD
         mHaw==
X-Forwarded-Encrypted: i=1; AJvYcCWqcDjjE8ONp37YbRrirO1p0K9+dHdKDOsu+dK88Wk4eZLA5OMIr+o/8GT5lPlALn/MfZsculM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyrgWnS4ToWr2xNMECEQZpj1NdNmKBX4QwSleoZU0VvWuijm4iS
	VH+dvZeyLjHXkE/ZDQ5CT6AfW1TwEw9SSOWMeJ9ybkzlMcGYLP6gx4npvTNyJZoKyTFxc9COy0s
	1tH4i2wQuZJ41ftU1LLyaeFmEu/0gR4CM6BFu/Srk
X-Gm-Gg: ASbGnctUo9F6TfZ77LDTIPEdy8nUFEMSr10zIqpFYhIf67hG1zY5jn1jA3E159RVfXb
	G2VG3Z/RMuk8m1UPdAQPXVjvue+nF0P9UggxBSuX0+jwWabp1c6NyDESUyQhT3JlHiaovTc17aW
	ylhpzr2sTzrPQ+5rGfueT7CHv5aGBtL+NvVsFyLGPqmP9tJjxFhTZ4bjlItffllzGSqlaUGHkm4
	i5my7qEkDoNL43CYdCxFltZevQEa5ZL3Y+abCcacmsKH+k6Le44cryRoxprn5cvjXRarWRZfFTe
	ZPIZnbQYXRoZ6cnjSJu+9+qJltlvarS5bJ70QMwtlOVFCMiI+kN/6PxNQdzCcP9eu4+rtQ==
X-Google-Smtp-Source: AGHT+IGj/IA0+cxgwJ0QbAmmmITWgcQOMTHX3lzQ7d9LJkNQs0Bg4+2fCEmqIj03/TN9g6guFcWR2R9lamFo0lFHfnY=
X-Received: by 2002:a05:6808:1383:b0:441:8f74:f1f with SMTP id
 5614622812f47-443a31aca9dmr9706512b6e.57.1761169120707; Wed, 22 Oct 2025
 14:38:40 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68f94c94.050a0220.346f24.0063.GAE@google.com>
In-Reply-To: <68f94c94.050a0220.346f24.0063.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 22 Oct 2025 23:38:29 +0200
X-Gm-Features: AS18NWBLRauKYQcKBn-A2oFvpqo9kAyjqIOrOVF6dcQrAVPzLDnxPxTsIyRrRT8
Message-ID: <CANp29Y4k5KPeFXe7jC0td_UZAXWmj8yG8uO0Xsoqdp+dStCjTg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Signed-off-by: Biancaa Ramesh <biancaa2210329@ssn.edu.in>
To: syzbot ci <syzbot+ci40ca3557c6a4469b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Oct 22, 2025 at 11:28=E2=80=AFPM syzbot ci
<syzbot+ci40ca3557c6a4469b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Signed-off-by: Biancaa Ramesh <biancaa2210329@ssn.edu.in>
> https://lore.kernel.org/all/20251022172045.57132-1-biancaa2210329@ssn.edu=
.in
> * [PATCH] Signed-off-by: Biancaa Ramesh <biancaa2210329@ssn.edu.in>
>
> and found the following issue:
> inconsistent lock state in valid_state
>
> Full report is available here:
> https://ci.syzbot.org/series/633a22d7-da77-4e0d-b8b2-b83308d1ada4
>
> ***
>
> inconsistent lock state in valid_state
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      3ff9bcecce83f12169ab3e42671bd76554ca521a
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/fdd7ef69-8bca-4916-9206-338917b91=
147/config
> C repro:   https://ci.syzbot.org/findings/5f542249-1f70-4702-b6c1-a89d708=
7a30c/c_repro
> syz repro: https://ci.syzbot.org/findings/5f542249-1f70-4702-b6c1-a89d708=
7a30c/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: inconsistent lock state
> syzkaller #0 Not tainted
> --------------------------------
> inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
> swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
> ffff888114c211e0 (slock-AF_LLC){+.?.}-{3:3}, at: spin_lock include/linux/=
spinlock.h:351 [inline]
> ffff888114c211e0 (slock-AF_LLC){+.?.}-{3:3}, at: llc_conn_tmr_common_cb+0=
x3d/0x830 net/llc/llc_c_ac.c:1325
> {SOFTIRQ-ON-W} state was registered at:
>   lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>   __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>   spin_lock include/linux/spinlock.h:351 [inline]
>   llc_conn_state_process+0xb1/0x1390 net/llc/llc_conn.c:72
>   llc_establish_connection+0x334/0x4d0 net/llc/llc_if.c:113
>   llc_ui_connect+0x3a0/0xd30 net/llc/af_llc.c:511
>   __sys_connect_file net/socket.c:2102 [inline]
>   __sys_connect+0x316/0x440 net/socket.c:2121
>   __do_sys_connect net/socket.c:2127 [inline]
>   __se_sys_connect net/socket.c:2124 [inline]
>   __x64_sys_connect+0x7a/0x90 net/socket.c:2124
>   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>   do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> irq event stamp: 874834
> hardirqs last  enabled at (874834): [<ffffffff8b480725>] __raw_spin_unloc=
k_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
> hardirqs last  enabled at (874834): [<ffffffff8b480725>] _raw_spin_unlock=
_irqrestore+0x85/0x110 kernel/locking/spinlock.c:194
> hardirqs last disabled at (874833): [<ffffffff8b480462>] __raw_spin_lock_=
irqsave include/linux/spinlock_api_smp.h:108 [inline]
> hardirqs last disabled at (874833): [<ffffffff8b480462>] _raw_spin_lock_i=
rqsave+0x82/0xf0 kernel/locking/spinlock.c:162
> softirqs last  enabled at (874680): [<ffffffff8184ccfa>] __do_softirq ker=
nel/softirq.c:656 [inline]
> softirqs last  enabled at (874680): [<ffffffff8184ccfa>] invoke_softirq k=
ernel/softirq.c:496 [inline]
> softirqs last  enabled at (874680): [<ffffffff8184ccfa>] __irq_exit_rcu+0=
xca/0x1f0 kernel/softirq.c:723
> softirqs last disabled at (874827): [<ffffffff8184ccfa>] __do_softirq ker=
nel/softirq.c:656 [inline]
> softirqs last disabled at (874827): [<ffffffff8184ccfa>] invoke_softirq k=
ernel/softirq.c:496 [inline]
> softirqs last disabled at (874827): [<ffffffff8184ccfa>] __irq_exit_rcu+0=
xca/0x1f0 kernel/softirq.c:723
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(slock-AF_LLC);
>   <Interrupt>
>     lock(slock-AF_LLC);
>
>  *** DEADLOCK ***
>
> 1 lock held by swapper/0/0:
>  #0: ffffc90000007be0 ((&llc->ack_timer.timer)){+.-.}-{0:0}, at: call_tim=
er_fn+0xbe/0x5f0 kernel/time/timer.c:1744
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <IRQ>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_usage_bug+0x297/0x2e0 kernel/locking/lockdep.c:4042
>  valid_state+0xc3/0xf0 kernel/locking/lockdep.c:4056
>  mark_lock_irq+0x36/0x390 kernel/locking/lockdep.c:4267
>  mark_lock+0x11b/0x190 kernel/locking/lockdep.c:4753
>  mark_usage kernel/locking/lockdep.c:-1 [inline]
>  __lock_acquire+0x680/0xd20 kernel/locking/lockdep.c:5191
>  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>  __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
>  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>  spin_lock include/linux/spinlock.h:351 [inline]
>  llc_conn_tmr_common_cb+0x3d/0x830 net/llc/llc_c_ac.c:1325
>  call_timer_fn+0x17e/0x5f0 kernel/time/timer.c:1747
>  expire_timers kernel/time/timer.c:1798 [inline]
>  __run_timers kernel/time/timer.c:2372 [inline]
>  __run_timer_base+0x61a/0x860 kernel/time/timer.c:2384
>  run_timer_base kernel/time/timer.c:2393 [inline]
>  run_timer_softirq+0xb7/0x180 kernel/time/timer.c:2403
>  handle_softirqs+0x286/0x870 kernel/softirq.c:622
>  __do_softirq kernel/softirq.c:656 [inline]
>  invoke_softirq kernel/softirq.c:496 [inline]
>  __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inli=
ne]
>  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1052
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:697
> RIP: 0010:pv_native_safe_halt+0x13/0x20 arch/x86/kernel/paravirt.c:82
> Code: cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 9=
0 f3 0f 1e fa eb 07 0f 00 2d 33 c1 22 00 f3 0f 1e fa fb f4 <e9> c8 e6 02 00=
 cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90
> RSP: 0018:ffffffff8dc07d80 EFLAGS: 00000286
> RAX: cf42be3493bb8800 RBX: ffffffff81967c07 RCX: cf42be3493bb8800
> RDX: 0000000000000001 RSI: ffffffff8d70c034 RDI: ffffffff8bbf0860
> RBP: ffffffff8dc07ea8 R08: ffff888121232fdb R09: 1ffff110242465fb
> R10: dffffc0000000000 R11: ffffed10242465fc R12: ffffffff8f7ce370
> R13: 0000000000000000 R14: 0000000000000000 R15: 1ffffffff1b92a40
>  arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
>  default_idle+0x13/0x20 arch/x86/kernel/process.c:767
>  default_idle_call+0x73/0xb0 kernel/sched/idle.c:122
>  cpuidle_idle_call kernel/sched/idle.c:190 [inline]
>  do_idle+0x1e7/0x510 kernel/sched/idle.c:330
>  cpu_startup_entry+0x44/0x60 kernel/sched/idle.c:428
>  rest_init+0x2de/0x300 init/main.c:757
>  start_kernel+0x3ae/0x410 init/main.c:1111
>  x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
>  x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
>  common_startup_64+0x13e/0x147
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   cc                      int3
>    1:   cc                      int3
>    2:   cc                      int3
>    3:   cc                      int3
>    4:   cc                      int3
>    5:   cc                      int3
>    6:   cc                      int3
>    7:   90                      nop
>    8:   90                      nop
>    9:   90                      nop
>    a:   90                      nop
>    b:   90                      nop
>    c:   90                      nop
>    d:   90                      nop
>    e:   90                      nop
>    f:   90                      nop
>   10:   90                      nop
>   11:   90                      nop
>   12:   90                      nop
>   13:   90                      nop
>   14:   90                      nop
>   15:   90                      nop
>   16:   90                      nop
>   17:   f3 0f 1e fa             endbr64
>   1b:   eb 07                   jmp    0x24
>   1d:   0f 00 2d 33 c1 22 00    verw   0x22c133(%rip)        # 0x22c157
>   24:   f3 0f 1e fa             endbr64
>   28:   fb                      sti
>   29:   f4                      hlt
> * 2a:   e9 c8 e6 02 00          jmp    0x2e6f7 <-- trapping instruction
>   2f:   cc                      int3
>   30:   cc                      int3
>   31:   cc                      int3
>   32:   cc                      int3
>   33:   cc                      int3
>   34:   cc                      int3
>   35:   cc                      int3
>   36:   cc                      int3
>   37:   90                      nop
>   38:   90                      nop
>   39:   90                      nop
>   3a:   90                      nop
>   3b:   90                      nop
>   3c:   90                      nop
>   3d:   90                      nop
>   3e:   90                      nop
>   3f:   90                      nop
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
> [biancaa2210329@ssn.edu.in davem@davemloft.net edumazet@google.com kuba@k=
ernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat=
.com]
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
-upstream-moderation/68f94c94.050a0220.346f24.0063.GAE%40google.com.
