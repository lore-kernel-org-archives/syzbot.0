Received: from mail-il1-f197.google.com (mail-il1-f197.google.com [209.85.166.197])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1818B3019C1
	for <syzbot@lists.linux.dev>; Wed, 22 Oct 2025 21:28:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.166.197
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1761168535; cv=none; b=aTFiGDc5Hb48Pz3vwd4tyrqbJv4fGKMu+o7m0c6VR1rKQX/E+LsUi7P8JVwZDexGAjUMteV67w3LjEtryI5pgP3rIIxxqZtyd9eWr/linq9/2BZWBInefjIJTYEn2dsjH4bhOZ1CGy+TdWcfqzOXCKI5fYJhC784QEGoJjpwu7M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1761168535; c=relaxed/simple;
	bh=NB423K3EMnDUsZ1/qkZluxQEasUcIEtlxdTjNy4Qg1g=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=j4/SsnT2z2RPA7n57QzvcOjCPvRdieT1nCB+xn0kvrpADYoB2jV9egxjTvgjyD21IOfvA2zigQcSK9wxdIpvTJf+EE9Z9eOxxaSW9JBhZX3FkBXpBqUFPLPltUxcq67fknhwA6379jbcA0LqOXIc/FzYjFpHd5V7HR/fUlDbXmM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.166.197
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-il1-f197.google.com with SMTP id e9e14a558f8ab-430ce62d138so2080075ab.3
        for <syzbot@lists.linux.dev>; Wed, 22 Oct 2025 14:28:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1761168532; x=1761773332;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=S2T3MZwGk6sk3k6lLnLg2Sbv0foE5GYjnQ6WSss72bg=;
        b=DuV/QPs0sGbgGBvqvVRGslUh9qInS3up4H874plip9q3BCEoW+j+wf6N6YkoY0VIaG
         ibQZVoSGW6y3EQzQ9zfKO8SwND3XITE8tDw0zVO4xc0ig9wCrKGitnKPYMEzg35mml0J
         AwR+6Lp/yr2n2QSgFXtQ+pTvQfCikxLz4jUTS6fWHYHP5XX4VF2haho/KPp1CoSsGAQj
         UUJy1srw+TXvPjfhxErU6nZIeoFsNDU70MjWo6LCHjCuB3KD4hX9FPP71w9QYymW9tUs
         CNq16AVXujBwQa2pBNVxgwYh3hPW3g/DoChj0mZszwV3xtkFs3Gb8Z/gYTc+ffBW/3ic
         /XeQ==
X-Gm-Message-State: AOJu0YwadCutJG9AO7zusl2zQaBD9bEj94jSXsuL3lz5VlgPC9JTy9oD
	9wqaTpRg4X93xdwRvaLOT+DC1Y1YRTHgG5qnvGraqN0DyfGIF4YlQR0fs/lSmcSVuMKGWmStppd
	RDE1DQzFBwtVVgoMK0ko148UAAslHOU+Hw39en7xqQCmQDcmG6x7Xkz4yI7Q=
X-Google-Smtp-Source: AGHT+IGJgzJSWK3T8UQJYDNAdSqguqDA5ztJu77HsqL5HIxMw5UITqXO3fyd/g4rhAl6YiSCDIKbpRlCMaN7dkdctuWKyijz78pL
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6e02:1a66:b0:42f:9399:ce93 with SMTP id
 e9e14a558f8ab-430c527dc16mr292658355ab.20.1761168532263; Wed, 22 Oct 2025
 14:28:52 -0700 (PDT)
Date: Wed, 22 Oct 2025 14:28:52 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <68f94c94.050a0220.346f24.0063.GAE@google.com>
Subject: [moderation/CI] Re: Signed-off-by: Biancaa Ramesh <biancaa2210329@ssn.edu.in>
From: syzbot ci <syzbot+ci40ca3557c6a4469b@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] Signed-off-by: Biancaa Ramesh <biancaa2210329@ssn.edu.in>
https://lore.kernel.org/all/20251022172045.57132-1-biancaa2210329@ssn.edu.in
* [PATCH] Signed-off-by: Biancaa Ramesh <biancaa2210329@ssn.edu.in>

and found the following issue:
inconsistent lock state in valid_state

Full report is available here:
https://ci.syzbot.org/series/633a22d7-da77-4e0d-b8b2-b83308d1ada4

***

inconsistent lock state in valid_state

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      3ff9bcecce83f12169ab3e42671bd76554ca521a
arch:      amd64
compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
config:    https://ci.syzbot.org/builds/fdd7ef69-8bca-4916-9206-338917b91147/config
C repro:   https://ci.syzbot.org/findings/5f542249-1f70-4702-b6c1-a89d7087a30c/c_repro
syz repro: https://ci.syzbot.org/findings/5f542249-1f70-4702-b6c1-a89d7087a30c/syz_repro

================================
WARNING: inconsistent lock state
syzkaller #0 Not tainted
--------------------------------
inconsistent {SOFTIRQ-ON-W} -> {IN-SOFTIRQ-W} usage.
swapper/0/0 [HC0[0]:SC1[1]:HE1:SE0] takes:
ffff888114c211e0 (slock-AF_LLC){+.?.}-{3:3}, at: spin_lock include/linux/spinlock.h:351 [inline]
ffff888114c211e0 (slock-AF_LLC){+.?.}-{3:3}, at: llc_conn_tmr_common_cb+0x3d/0x830 net/llc/llc_c_ac.c:1325
{SOFTIRQ-ON-W} state was registered at:
  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
  __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
  spin_lock include/linux/spinlock.h:351 [inline]
  llc_conn_state_process+0xb1/0x1390 net/llc/llc_conn.c:72
  llc_establish_connection+0x334/0x4d0 net/llc/llc_if.c:113
  llc_ui_connect+0x3a0/0xd30 net/llc/af_llc.c:511
  __sys_connect_file net/socket.c:2102 [inline]
  __sys_connect+0x316/0x440 net/socket.c:2121
  __do_sys_connect net/socket.c:2127 [inline]
  __se_sys_connect net/socket.c:2124 [inline]
  __x64_sys_connect+0x7a/0x90 net/socket.c:2124
  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
  entry_SYSCALL_64_after_hwframe+0x77/0x7f
irq event stamp: 874834
hardirqs last  enabled at (874834): [<ffffffff8b480725>] __raw_spin_unlock_irqrestore include/linux/spinlock_api_smp.h:151 [inline]
hardirqs last  enabled at (874834): [<ffffffff8b480725>] _raw_spin_unlock_irqrestore+0x85/0x110 kernel/locking/spinlock.c:194
hardirqs last disabled at (874833): [<ffffffff8b480462>] __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:108 [inline]
hardirqs last disabled at (874833): [<ffffffff8b480462>] _raw_spin_lock_irqsave+0x82/0xf0 kernel/locking/spinlock.c:162
softirqs last  enabled at (874680): [<ffffffff8184ccfa>] __do_softirq kernel/softirq.c:656 [inline]
softirqs last  enabled at (874680): [<ffffffff8184ccfa>] invoke_softirq kernel/softirq.c:496 [inline]
softirqs last  enabled at (874680): [<ffffffff8184ccfa>] __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723
softirqs last disabled at (874827): [<ffffffff8184ccfa>] __do_softirq kernel/softirq.c:656 [inline]
softirqs last disabled at (874827): [<ffffffff8184ccfa>] invoke_softirq kernel/softirq.c:496 [inline]
softirqs last disabled at (874827): [<ffffffff8184ccfa>] __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(slock-AF_LLC);
  <Interrupt>
    lock(slock-AF_LLC);

 *** DEADLOCK ***

1 lock held by swapper/0/0:
 #0: ffffc90000007be0 ((&llc->ack_timer.timer)){+.-.}-{0:0}, at: call_timer_fn+0xbe/0x5f0 kernel/time/timer.c:1744

stack backtrace:
CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
 print_usage_bug+0x297/0x2e0 kernel/locking/lockdep.c:4042
 valid_state+0xc3/0xf0 kernel/locking/lockdep.c:4056
 mark_lock_irq+0x36/0x390 kernel/locking/lockdep.c:4267
 mark_lock+0x11b/0x190 kernel/locking/lockdep.c:4753
 mark_usage kernel/locking/lockdep.c:-1 [inline]
 __lock_acquire+0x680/0xd20 kernel/locking/lockdep.c:5191
 lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
 __raw_spin_lock include/linux/spinlock_api_smp.h:133 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
 spin_lock include/linux/spinlock.h:351 [inline]
 llc_conn_tmr_common_cb+0x3d/0x830 net/llc/llc_c_ac.c:1325
 call_timer_fn+0x17e/0x5f0 kernel/time/timer.c:1747
 expire_timers kernel/time/timer.c:1798 [inline]
 __run_timers kernel/time/timer.c:2372 [inline]
 __run_timer_base+0x61a/0x860 kernel/time/timer.c:2384
 run_timer_base kernel/time/timer.c:2393 [inline]
 run_timer_softirq+0xb7/0x180 kernel/time/timer.c:2403
 handle_softirqs+0x286/0x870 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x1f0 kernel/softirq.c:723
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:739
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1052 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1052
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:pv_native_safe_halt+0x13/0x20 arch/x86/kernel/paravirt.c:82
Code: cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa eb 07 0f 00 2d 33 c1 22 00 f3 0f 1e fa fb f4 <e9> c8 e6 02 00 cc cc cc cc cc cc cc cc 90 90 90 90 90 90 90 90 90
RSP: 0018:ffffffff8dc07d80 EFLAGS: 00000286
RAX: cf42be3493bb8800 RBX: ffffffff81967c07 RCX: cf42be3493bb8800
RDX: 0000000000000001 RSI: ffffffff8d70c034 RDI: ffffffff8bbf0860
RBP: ffffffff8dc07ea8 R08: ffff888121232fdb R09: 1ffff110242465fb
R10: dffffc0000000000 R11: ffffed10242465fc R12: ffffffff8f7ce370
R13: 0000000000000000 R14: 0000000000000000 R15: 1ffffffff1b92a40
 arch_safe_halt arch/x86/include/asm/paravirt.h:107 [inline]
 default_idle+0x13/0x20 arch/x86/kernel/process.c:767
 default_idle_call+0x73/0xb0 kernel/sched/idle.c:122
 cpuidle_idle_call kernel/sched/idle.c:190 [inline]
 do_idle+0x1e7/0x510 kernel/sched/idle.c:330
 cpu_startup_entry+0x44/0x60 kernel/sched/idle.c:428
 rest_init+0x2de/0x300 init/main.c:757
 start_kernel+0x3ae/0x410 init/main.c:1111
 x86_64_start_reservations+0x24/0x30 arch/x86/kernel/head64.c:310
 x86_64_start_kernel+0x143/0x1c0 arch/x86/kernel/head64.c:291
 common_startup_64+0x13e/0x147
 </TASK>
----------------
Code disassembly (best guess):
   0:	cc                   	int3
   1:	cc                   	int3
   2:	cc                   	int3
   3:	cc                   	int3
   4:	cc                   	int3
   5:	cc                   	int3
   6:	cc                   	int3
   7:	90                   	nop
   8:	90                   	nop
   9:	90                   	nop
   a:	90                   	nop
   b:	90                   	nop
   c:	90                   	nop
   d:	90                   	nop
   e:	90                   	nop
   f:	90                   	nop
  10:	90                   	nop
  11:	90                   	nop
  12:	90                   	nop
  13:	90                   	nop
  14:	90                   	nop
  15:	90                   	nop
  16:	90                   	nop
  17:	f3 0f 1e fa          	endbr64
  1b:	eb 07                	jmp    0x24
  1d:	0f 00 2d 33 c1 22 00 	verw   0x22c133(%rip)        # 0x22c157
  24:	f3 0f 1e fa          	endbr64
  28:	fb                   	sti
  29:	f4                   	hlt
* 2a:	e9 c8 e6 02 00       	jmp    0x2e6f7 <-- trapping instruction
  2f:	cc                   	int3
  30:	cc                   	int3
  31:	cc                   	int3
  32:	cc                   	int3
  33:	cc                   	int3
  34:	cc                   	int3
  35:	cc                   	int3
  36:	cc                   	int3
  37:	90                   	nop
  38:	90                   	nop
  39:	90                   	nop
  3a:	90                   	nop
  3b:	90                   	nop
  3c:	90                   	nop
  3d:	90                   	nop
  3e:	90                   	nop
  3f:	90                   	nop


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

The email will later be sent to:
[biancaa2210329@ssn.edu.in davem@davemloft.net edumazet@google.com kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com]

If the report looks fine to you, reply with:
#syz upstream

