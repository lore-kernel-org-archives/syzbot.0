Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1F9C3A9627
	for <syzbot@lists.linux.dev>; Fri, 29 May 2026 08:31:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780043515; cv=none; b=aQf7J/pczedfFlaGdDtrbZdTi059OZ+N0XmTqAqI7bOgU+ab5JTEvqOnGj/MgZd56sbIOFxU1qMlLXvUfiYmN02ZCfcPDLlUQQ6+9bAMsBo6C50TfCDibSJBe7A7jqbdZzn3PHJvHRwEf7IqrkqNzZHbMPhaiYxa1KwKbn8VJ5g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780043515; c=relaxed/simple;
	bh=RG8wtfjmJPD0PUVqCc4Q83R6w3JLI1ArQJQG+EZMD/I=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=CFswvUPF9Mbl8JtArpp6UrU9eCamkcrBVOJH5hkeKy60hdlQIpbj/CdEpjiPAyrFaz7bmcOqVEQ0jJDd32U5Nj8agoaDYTPKTNo0AmLSJVO6d+/giaADzlfTapmuLkYwoFaIiJs/USpxCUwb4z5mIlNBH29HL1t5ZWCmLXef/u0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-69e0a282136so45324eaf.0
        for <syzbot@lists.linux.dev>; Fri, 29 May 2026 01:31:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780043512; x=1780648312;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=oZRPlOmkp0kef72DqMMokneLwMEwEIPiQ3CWdRQGoX8=;
        b=PMblxUROO943UInqHMIo/ST30VlHcyWByIXoTVVyul1pzJYL2XIbX0/PtoclVVbkYb
         3rqYoRGPYB078TAF893HPKb9HgC6zxroPtAsxnT3XpVpiKoDdX3baXH4KKzlohM3hLvH
         y0o5HX2bXS9SSAk4pqWwx8v1Ek+WKkRsWi9REzSZr6VeELZui3xcIFMb0pBeWe/3GWio
         aiV56zEeo1POHWjH1UZ3UvDGzAoulV9E138DecEs8WmmBouoiLPGLj3IN4GgWwGWqvAc
         j+cGNxt4MMNhnEUQd/Xq15HnLYBodSVY+j/P3rabWr6P+hqGNMIPMcxYpLLCCHQ5zyXY
         ALKQ==
X-Gm-Message-State: AOJu0YzwhzQSa7clEgqr3h5JBBXR/WV8FKGkojg+ZftxkokVZsQj4v+Q
	kW7btsBK2EwovHf7xzsLb0FSxMgbUBhH1YwISbuoVm7v1U4dgDGFaQ+xzTpwF/QPX9TmAcYmygV
	P5WxwEJ4ckEhv+NYVJqbLJAF5cwUTjGkABYRMB2SuTSOOZUC/kqml5OzIbp4=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:a04:b0:69d:f864:d35b with SMTP id
 006d021491bc7-69e03f2284amr1018950eaf.23.1780043511815; Fri, 29 May 2026
 01:31:51 -0700 (PDT)
Date: Fri, 29 May 2026 01:31:51 -0700
In-Reply-To: <20260529032026.363856-1-jiayuan.chen@linux.dev>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a194ef7.ba3b1513.1890b4.0000.GAE@google.com>
Subject: [syzbot ci] Re: ipv6: anycast: insert aca into global hash under idev->lock
From: syzbot ci <syzbot+cieee6b6974f07e792@syzkaller.appspotmail.com>
To: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com, 
	horms@kernel.org, idosch@nvidia.com, jiayuan.chen@linux.dev, kuba@kernel.org, 
	kuniyu@google.com, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] ipv6: anycast: insert aca into global hash under idev->lock
https://lore.kernel.org/all/20260529032026.363856-1-jiayuan.chen@linux.dev
* [PATCH net] ipv6: anycast: insert aca into global hash under idev->lock

and found the following issues:
* possible deadlock in __ipv6_dev_ac_dec
* possible deadlock in addrconf_rs_timer

Full report is available here:
https://ci.syzbot.org/series/00cb20f0-c599-468e-b3de-b109499c1db5

***

possible deadlock in __ipv6_dev_ac_dec

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      ab4ac5a93b1b76aa6b12cadcba30450868d21a6f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/9ba0a1a3-43c2-4334-8f26-942c72690313/config
syz repro: https://ci.syzbot.org/findings/54a509b9-82dc-4a61-a5c4-701533f277d6/syz_repro

========================================================
WARNING: possible irq lock inversion dependency detected
syzkaller #0 Not tainted
--------------------------------------------------------
syz.2.19/5872 just changed the state of lock:
ffffffff8fef3d98 (acaddr_hash_lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:342 [inline]
ffffffff8fef3d98 (acaddr_hash_lock){+.+.}-{3:3}, at: ipv6_del_acaddr_hash net/ipv6/anycast.c:253 [inline]
ffffffff8fef3d98 (acaddr_hash_lock){+.+.}-{3:3}, at: __ipv6_dev_ac_dec+0x459/0x690 net/ipv6/anycast.c:419
but this lock was taken by another, SOFTIRQ-safe lock in the past:
 (&ndev->lock){++--}-{3:3}


and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(acaddr_hash_lock
);
                               local_irq_disable();
                               lock(&ndev->lock);
                               lock(acaddr_hash_lock);
  <Interrupt>
    lock(&ndev->lock);

 *** DEADLOCK ***

1 lock held by syz.2.19/5872:
 #0: ffff8881b52abe40 (&sb->s_type->i_mutex_key#13){+.+.}-{4:4}
, at: inode_lock include/linux/fs.h:1029 [inline]
, at: __sock_release net/socket.c:721 [inline]
, at: sock_close+0x9b/0x240 net/socket.c:1514

the shortest dependencies between 2nd lock and 1st lock:
 -> (&ndev->lock){++--}-{3:3} {
    HARDIRQ-ON-W at:
                      lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                      __raw_write_lock_bh include/linux/rwlock_api_smp.h:221 [inline]
                      _raw_write_lock_bh+0x36/0x50 kernel/locking/spinlock.c:338
                      addrconf_permanent_addr+0x16a/0xa20 net/ipv6/addrconf.c:3627
                      addrconf_notify+0x864/0x1050 net/ipv6/addrconf.c:3706
                      notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85
                      call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]
                      call_netdevice_notifiers net/core/dev.c:2301 [inline]
                      __dev_notify_flags+0x1a9/0x310 net/core/dev.c:9797
                      netif_change_flags+0xe8/0x1a0 net/core/dev.c:9826
                      dev_change_flags+0x130/0x270 net/core/dev_api.c:68
                      devinet_ioctl+0x9f2/0x1b30 net/ipv4/devinet.c:1199
                      inet_ioctl+0x42a/0x560 net/ipv4/af_inet.c:1011
                      sock_do_ioctl+0x101/0x320 net/socket.c:1313
                      sock_ioctl+0x5c6/0x7f0 net/socket.c:1434
                      vfs_ioctl fs/ioctl.c:51 [inline]
                      __do_sys_ioctl fs/ioctl.c:597 [inline]
                      __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
                      do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
                      do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
                      entry_SYSCALL_64_after_hwframe+0x77/0x7f
    HARDIRQ-ON-R at:
                      lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                      __raw_read_lock_bh include/linux/rwlock_api_smp.h:192 [inline]
                      _raw_read_lock_bh+0x3e/0x50 kernel/locking/spinlock.c:256
                      inet6_fill_ifla6_attrs+0x1117/0x25e0 net/ipv6/addrconf.c:5858
                      inet6_fill_link_af+0x9b/0x120 net/ipv6/addrconf.c:5893
                      rtnl_fill_link_af+0x1c8/0x440 net/core/rtnetlink.c:1919
                      rtnl_fill_ifinfo+0x1e08/0x20f0 net/core/rtnetlink.c:2190
                      rtmsg_ifinfo_build_skb+0x17d/0x260 net/core/rtnetlink.c:4454
                      rtmsg_ifinfo_event net/core/rtnetlink.c:4487 [inline]
                      rtmsg_ifinfo+0x8c/0x1a0 net/core/rtnetlink.c:4496
                      register_netdevice+0x1aca/0x1ec0 net/core/dev.c:11475
                      register_netdev+0x40/0x60 net/core/dev.c:11539
                      vti6_init_net+0x238/0x370 net/ipv6/ip6_vti.c:1167
                      ops_init+0x35c/0x5c0 net/core/net_namespace.c:137
                      __register_pernet_operations net/core/net_namespace.c:1318 [inline]
                      register_pernet_operations+0x343/0x830 net/core/net_namespace.c:1395
                      register_pernet_device+0x2a/0x80 net/core/net_namespace.c:1482
                      vti6_tunnel_init+0x13/0x170 net/ipv6/ip6_vti.c:1251
                      do_one_initcall+0x250/0x870 init/main.c:1392
                      do_initcall_level+0x104/0x190 init/main.c:1454
                      do_initcalls+0x59/0xa0 init/main.c:1470
                      kernel_init_freeable+0x2a6/0x3e0 init/main.c:1703
                      kernel_init+0x1d/0x1d0 init/main.c:1593
                      ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
                      ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
    IN-SOFTIRQ-W at:
                      lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                      __raw_write_lock include/linux/rwlock_api_smp.h:229 [inline]
                      _raw_write_lock+0x2e/0x40 kernel/locking/spinlock.c:304
                      addrconf_rs_timer+0xc8/0x6d0 net/ipv6/addrconf.c:4033
                      call_timer_fn+0x192/0x5e0 kernel/time/timer.c:1748
                      expire_timers kernel/time/timer.c:1799 [inline]
                      __run_timers kernel/time/timer.c:2374 [inline]
                      __run_timer_base+0x652/0x8b0 kernel/time/timer.c:2386
                      run_timer_base kernel/time/timer.c:2395 [inline]
                      run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2405
                      handle_softirqs+0x22a/0x840 kernel/softirq.c:622
                      __do_softirq kernel/softirq.c:656 [inline]
                      invoke_softirq kernel/softirq.c:496 [inline]
                      __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
                      irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
                      instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inline]
                      sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1061
                      asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
                      native_safe_halt arch/x86/include/asm/irqflags.h:48 [inline]
                      pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:62
                      arch_safe_halt arch/x86/kernel/process.c:766 [inline]
                      default_idle+0x9/0x20 arch/x86/kernel/process.c:767
                      default_idle_call+0x72/0xb0 kernel/sched/idle.c:122
                      cpuidle_idle_call kernel/sched/idle.c:199 [inline]
                      do_idle+0x36a/0x5f0 kernel/sched/idle.c:352
                      cpu_startup_entry+0x43/0x60 kernel/sched/idle.c:451
                      start_secondary+0x101/0x110 arch/x86/kernel/smpboot.c:312
                      common_startup_64+0x13e/0x147
    IN-SOFTIRQ-R at:
                      lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                      __raw_read_lock_bh include/linux/rwlock_api_smp.h:192 [inline]
                      _raw_read_lock_bh+0x3e/0x50 kernel/locking/spinlock.c:256
                      ipv6_get_lladdr+0x15d/0x3f0 net/ipv6/addrconf.c:1940
                      addrconf_rs_timer+0x337/0x6d0 net/ipv6/addrconf.c:4048
                      call_timer_fn+0x192/0x5e0 kernel/time/timer.c:1748
                      expire_timers kernel/time/timer.c:1799 [inline]
                      __run_timers kernel/time/timer.c:2374 [inline]
                      __run_timer_base+0x652/0x8b0 kernel/time/timer.c:2386
                      run_timer_base kernel/time/timer.c:2395 [inline]
                      run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2405
                      handle_softirqs+0x22a/0x840 kernel/softirq.c:622
                      __do_softirq kernel/softirq.c:656 [inline]
                      invoke_softirq kernel/softirq.c:496 [inline]
                      __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
                      irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
                      instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inline]
                      sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1061
                      asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
                      native_safe_halt arch/x86/include/asm/irqflags.h:48 [inline]
                      pv_native_safe_halt+0xf/0x20 arch/x86/kernel/paravirt.c:62
                      arch_safe_halt arch/x86/kernel/process.c:766 [inline]
                      default_idle+0x9/0x20 arch/x86/kernel/process.c:767
                      default_idle_call+0x72/0xb0 kernel/sched/idle.c:122
                      cpuidle_idle_call kernel/sched/idle.c:199 [inline]
                      do_idle+0x36a/0x5f0 kernel/sched/idle.c:352
                      cpu_startup_entry+0x43/0x60 kernel/sched/idle.c:451
                      start_secondary+0x101/0x110 arch/x86/kernel/smpboot.c:312
                      common_startup_64+0x13e/0x147
    INITIAL USE at:
                     lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                     __raw_write_lock_bh include/linux/rwlock_api_smp.h:221 [inline]
                     _raw_write_lock_bh+0x36/0x50 kernel/locking/spinlock.c:338
                     addrconf_permanent_addr+0x16a/0xa20 net/ipv6/addrconf.c:3627
                     addrconf_notify+0x864/0x1050 net/ipv6/addrconf.c:3706
                     notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85
                     call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]
                     call_netdevice_notifiers net/core/dev.c:2301 [inline]
                     __dev_notify_flags+0x1a9/0x310 net/core/dev.c:9797
                     netif_change_flags+0xe8/0x1a0 net/core/dev.c:9826
                     dev_change_flags+0x130/0x270 net/core/dev_api.c:68
                     devinet_ioctl+0x9f2/0x1b30 net/ipv4/devinet.c:1199
                     inet_ioctl+0x42a/0x560 net/ipv4/af_inet.c:1011
                     sock_do_ioctl+0x101/0x320 net/socket.c:1313
                     sock_ioctl+0x5c6/0x7f0 net/socket.c:1434
                     vfs_ioctl fs/ioctl.c:51 [inline]
                     __do_sys_ioctl fs/ioctl.c:597 [inline]
                     __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
                     do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
                     do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
                     entry_SYSCALL_64_after_hwframe+0x77/0x7f
    INITIAL READ USE at:
                          lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                          __raw_read_lock_bh include/linux/rwlock_api_smp.h:192 [inline]
                          _raw_read_lock_bh+0x3e/0x50 kernel/locking/spinlock.c:256
                          inet6_fill_ifla6_attrs+0x1117/0x25e0 net/ipv6/addrconf.c:5858
                          inet6_fill_link_af+0x9b/0x120 net/ipv6/addrconf.c:5893
                          rtnl_fill_link_af+0x1c8/0x440 net/core/rtnetlink.c:1919
                          rtnl_fill_ifinfo+0x1e08/0x20f0 net/core/rtnetlink.c:2190
                          rtmsg_ifinfo_build_skb+0x17d/0x260 net/core/rtnetlink.c:4454
                          rtmsg_ifinfo_event net/core/rtnetlink.c:4487 [inline]
                          rtmsg_ifinfo+0x8c/0x1a0 net/core/rtnetlink.c:4496
                          register_netdevice+0x1aca/0x1ec0 net/core/dev.c:11475
                          register_netdev+0x40/0x60 net/core/dev.c:11539
                          vti6_init_net+0x238/0x370 net/ipv6/ip6_vti.c:1167
                          ops_init+0x35c/0x5c0 net/core/net_namespace.c:137
                          __register_pernet_operations net/core/net_namespace.c:1318 [inline]
                          register_pernet_operations+0x343/0x830 net/core/net_namespace.c:1395
                          register_pernet_device+0x2a/0x80 net/core/net_namespace.c:1482
                          vti6_tunnel_init+0x13/0x170 net/ipv6/ip6_vti.c:1251
                          do_one_initcall+0x250/0x870 init/main.c:1392
                          do_initcall_level+0x104/0x190 init/main.c:1454
                          do_initcalls+0x59/0xa0 init/main.c:1470
                          kernel_init_freeable+0x2a6/0x3e0 init/main.c:1703
                          kernel_init+0x1d/0x1d0 init/main.c:1593
                          ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
                          ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
  }
  ... key      at: [<ffffffff9a982fe0>] ipv6_add_dev.__key+0x0/0x20
  ... acquired at:
   __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
   spin_lock include/linux/spinlock.h:342 [inline]
   ipv6_add_acaddr_hash net/ipv6/anycast.c:246 [inline]
   __ipv6_dev_ac_inc+0x6c8/0xb10 net/ipv6/anycast.c:374
   ipv6_sock_ac_join+0x6a8/0x880 net/ipv6/anycast.c:153
   do_ipv6_setsockopt+0x203a/0x3150 net/ipv6/ipv6_sockglue.c:893
   ipv6_setsockopt+0x59/0x170 net/ipv6/ipv6_sockglue.c:965
   do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2381
   __sys_setsockopt net/socket.c:2406 [inline]
   __do_sys_setsockopt net/socket.c:2412 [inline]
   __se_sys_setsockopt net/socket.c:2409 [inline]
   __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2409
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> (acaddr_hash_lock){+.+.}-{3:3} {
   HARDIRQ-ON-W at:
                    lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                    __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
                    _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
                    spin_lock include/linux/spinlock.h:342 [inline]
                    ipv6_add_acaddr_hash net/ipv6/anycast.c:246 [inline]
                    __ipv6_dev_ac_inc+0x6c8/0xb10 net/ipv6/anycast.c:374
                    ipv6_sock_ac_join+0x6a8/0x880 net/ipv6/anycast.c:153
                    do_ipv6_setsockopt+0x203a/0x3150 net/ipv6/ipv6_sockglue.c:893
                    ipv6_setsockopt+0x59/0x170 net/ipv6/ipv6_sockglue.c:965
                    do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2381
                    __sys_setsockopt net/socket.c:2406 [inline]
                    __do_sys_setsockopt net/socket.c:2412 [inline]
                    __se_sys_setsockopt net/socket.c:2409 [inline]
                    __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2409
                    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
                    do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
                    entry_SYSCALL_64_after_hwframe+0x77/0x7f
   SOFTIRQ-ON-W at:
                    lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                    __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
                    _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
                    spin_lock include/linux/spinlock.h:342 [inline]
                    ipv6_del_acaddr_hash net/ipv6/anycast.c:253 [inline]
                    __ipv6_dev_ac_dec+0x459/0x690 net/ipv6/anycast.c:419
                    ipv6_dev_ac_dec net/ipv6/anycast.c:438 [inline]
                    __ipv6_sock_ac_close+0x24e/0x430 net/ipv6/anycast.c:224
                    inet6_release+0x4f/0x70 net/ipv6/af_inet6.c:470
                    __sock_release net/socket.c:722 [inline]
                    sock_close+0xc3/0x240 net/socket.c:1514
                    __fput+0x44f/0xa60 fs/file_table.c:510
                    task_work_run+0x1d9/0x270 kernel/task_work.c:233
                    resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
                    __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
                    exit_to_user_mode_loop+0xf3/0x4d0 kernel/entry/common.c:98
                    __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
                    syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
                    syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
                    do_syscall_64+0x33e/0x560 arch/x86/entry/syscall_64.c:100
                    entry_SYSCALL_64_after_hwframe+0x77/0x7f
   INITIAL USE at:
                   lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                   __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
                   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
                   spin_lock include/linux/spinlock.h:342 [inline]
                   ipv6_add_acaddr_hash net/ipv6/anycast.c:246 [inline]
                   __ipv6_dev_ac_inc+0x6c8/0xb10 net/ipv6/anycast.c:374
                   ipv6_sock_ac_join+0x6a8/0x880 net/ipv6/anycast.c:153
                   do_ipv6_setsockopt+0x203a/0x3150 net/ipv6/ipv6_sockglue.c:893
                   ipv6_setsockopt+0x59/0x170 net/ipv6/ipv6_sockglue.c:965
                   do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2381
                   __sys_setsockopt net/socket.c:2406 [inline]
                   __do_sys_setsockopt net/socket.c:2412 [inline]
                   __se_sys_setsockopt net/socket.c:2409 [inline]
                   __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2409
                   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
                   do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
                   entry_SYSCALL_64_after_hwframe+0x77/0x7f
 }
 ... key      at: [<ffffffff8fef3d98>] acaddr_hash_lock+0x18/0x60 anycast.c:-1
 ... acquired at:
   mark_lock+0x115/0x190 kernel/locking/lockdep.c:4753
   mark_usage kernel/locking/lockdep.c:-1 [inline]
   __lock_acquire+0x9f9/0x2cf0 kernel/locking/lockdep.c:5191
   lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
   __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
   spin_lock include/linux/spinlock.h:342 [inline]
   ipv6_del_acaddr_hash net/ipv6/anycast.c:253 [inline]
   __ipv6_dev_ac_dec+0x459/0x690 net/ipv6/anycast.c:419
   ipv6_dev_ac_dec net/ipv6/anycast.c:438 [inline]
   __ipv6_sock_ac_close+0x24e/0x430 net/ipv6/anycast.c:224
   inet6_release+0x4f/0x70 net/ipv6/af_inet6.c:470
   __sock_release net/socket.c:722 [inline]
   sock_close+0xc3/0x240 net/socket.c:1514
   __fput+0x44f/0xa60 fs/file_table.c:510
   task_work_run+0x1d9/0x270 kernel/task_work.c:233
   resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
   __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
   exit_to_user_mode_loop+0xf3/0x4d0 kernel/entry/common.c:98
   __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
   syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
   syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
   do_syscall_64+0x33e/0x560 arch/x86/entry/syscall_64.c:100
   entry_SYSCALL_64_after_hwframe+0x77/0x7f


stack backtrace:
CPU: 1 UID: 0 PID: 5872 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_irq_inversion_bug+0x1d2/0x1e0 kernel/locking/lockdep.c:4125
 mark_lock_irq+0x3d2/0x420 kernel/locking/lockdep.c:-1
 mark_lock+0x115/0x190 kernel/locking/lockdep.c:4753
 mark_usage kernel/locking/lockdep.c:-1 [inline]
 __lock_acquire+0x9f9/0x2cf0 kernel/locking/lockdep.c:5191
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
 _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
 spin_lock include/linux/spinlock.h:342 [inline]
 ipv6_del_acaddr_hash net/ipv6/anycast.c:253 [inline]
 __ipv6_dev_ac_dec+0x459/0x690 net/ipv6/anycast.c:419
 ipv6_dev_ac_dec net/ipv6/anycast.c:438 [inline]
 __ipv6_sock_ac_close+0x24e/0x430 net/ipv6/anycast.c:224
 inet6_release+0x4f/0x70 net/ipv6/af_inet6.c:470
 __sock_release net/socket.c:722 [inline]
 sock_close+0xc3/0x240 net/socket.c:1514
 __fput+0x44f/0xa60 fs/file_table.c:510
 task_work_run+0x1d9/0x270 kernel/task_work.c:233
 resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
 __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
 exit_to_user_mode_loop+0xf3/0x4d0 kernel/entry/common.c:98
 __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
 syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
 syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
 do_syscall_64+0x33e/0x560 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7f2cd559ce59
Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
RSP: 002b:00007ffe5c3cd978 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
RAX: 0000000000000000 RBX: 00007ffe5c3cda60 RCX: 00007f2cd559ce59
RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
RBP: 000000000000fd56 R08: 0000000000000001 R09: 0000000000000000
R10: 0000001b32c20000 R11: 0000000000000246 R12: 00007ffe5c3cdaa0
R13: 00007f2cd5815fac R14: 000000000000fd8b R15: 00007f2cd5815fa0
 </TASK>


***

possible deadlock in addrconf_rs_timer

tree:      net
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net.git
base:      ab4ac5a93b1b76aa6b12cadcba30450868d21a6f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/9ba0a1a3-43c2-4334-8f26-942c72690313/config
syz repro: https://ci.syzbot.org/findings/e48c441f-1967-4acb-8d02-6ec4625160de/syz_repro

========================================================
WARNING: possible irq lock inversion dependency detected
syzkaller #0 Not tainted
--------------------------------------------------------
syz-executor/5739 just changed the state of lock:
ffff888114e00578 (&ndev->lock){++-.}-{3:3}, at: addrconf_rs_timer+0xc8/0x6d0 net/ipv6/addrconf.c:4033
but this lock took another, SOFTIRQ-unsafe lock in the past:
 (acaddr_hash_lock){+.+.}-{3:3}


and interrupts could create inverse lock ordering between them.


other info that might help us debug this:
 Possible interrupt unsafe locking scenario:

       CPU0                    CPU1
       ----                    ----
  lock(acaddr_hash_lock);
                               local_irq_disable();
                               lock(&ndev->lock);
                               lock(acaddr_hash_lock);
  <Interrupt>
    lock(&ndev->lock);

 *** DEADLOCK ***

2 locks held by syz-executor/5739:
 #0: ffff88816c92cce0 (&xt[i].mutex){+.+.}-{4:4}, at: xt_find_table_lock+0x51/0x3f0 net/netfilter/x_tables.c:1336
 #1: ffffc90000007cc0 ((&ndev->rs_timer)){+.-.}-{0:0}, at: call_timer_fn+0xd4/0x5e0 kernel/time/timer.c:1745

the shortest dependencies between 2nd lock and 1st lock:
 -> (acaddr_hash_lock){+.+.}-{3:3} {
    HARDIRQ-ON-W at:
                      lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                      __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
                      _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
                      spin_lock include/linux/spinlock.h:342 [inline]
                      ipv6_add_acaddr_hash net/ipv6/anycast.c:246 [inline]
                      __ipv6_dev_ac_inc+0x6c8/0xb10 net/ipv6/anycast.c:374
                      ipv6_sock_ac_join+0x6a8/0x880 net/ipv6/anycast.c:153
                      do_ipv6_setsockopt+0x203a/0x3150 net/ipv6/ipv6_sockglue.c:893
                      ipv6_setsockopt+0x59/0x170 net/ipv6/ipv6_sockglue.c:965
                      do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2381
                      __sys_setsockopt net/socket.c:2406 [inline]
                      __do_sys_setsockopt net/socket.c:2412 [inline]
                      __se_sys_setsockopt net/socket.c:2409 [inline]
                      __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2409
                      do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
                      do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
                      entry_SYSCALL_64_after_hwframe+0x77/0x7f
    SOFTIRQ-ON-W at:
                      lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                      __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
                      _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
                      spin_lock include/linux/spinlock.h:342 [inline]
                      ipv6_del_acaddr_hash net/ipv6/anycast.c:253 [inline]
                      __ipv6_dev_ac_dec+0x459/0x690 net/ipv6/anycast.c:419
                      ipv6_dev_ac_dec net/ipv6/anycast.c:438 [inline]
                      __ipv6_sock_ac_close+0x24e/0x430 net/ipv6/anycast.c:224
                      inet6_release+0x4f/0x70 net/ipv6/af_inet6.c:470
                      __sock_release net/socket.c:722 [inline]
                      sock_close+0xc3/0x240 net/socket.c:1514
                      __fput+0x44f/0xa60 fs/file_table.c:510
                      task_work_run+0x1d9/0x270 kernel/task_work.c:233
                      resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
                      __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
                      exit_to_user_mode_loop+0xf3/0x4d0 kernel/entry/common.c:98
                      __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
                      syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [inline]
                      syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
                      do_syscall_64+0x33e/0x560 arch/x86/entry/syscall_64.c:100
                      entry_SYSCALL_64_after_hwframe+0x77/0x7f
    INITIAL USE at:
                     lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                     __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
                     _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
                     spin_lock include/linux/spinlock.h:342 [inline]
                     ipv6_add_acaddr_hash net/ipv6/anycast.c:246 [inline]
                     __ipv6_dev_ac_inc+0x6c8/0xb10 net/ipv6/anycast.c:374
                     ipv6_sock_ac_join+0x6a8/0x880 net/ipv6/anycast.c:153
                     do_ipv6_setsockopt+0x203a/0x3150 net/ipv6/ipv6_sockglue.c:893
                     ipv6_setsockopt+0x59/0x170 net/ipv6/ipv6_sockglue.c:965
                     do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2381
                     __sys_setsockopt net/socket.c:2406 [inline]
                     __do_sys_setsockopt net/socket.c:2412 [inline]
                     __se_sys_setsockopt net/socket.c:2409 [inline]
                     __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2409
                     do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
                     do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
                     entry_SYSCALL_64_after_hwframe+0x77/0x7f
  }
  ... key      at: [<ffffffff8fef3d98>] acaddr_hash_lock+0x18/0x60 anycast.c:-1
  ... acquired at:
   __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
   spin_lock include/linux/spinlock.h:342 [inline]
   ipv6_add_acaddr_hash net/ipv6/anycast.c:246 [inline]
   __ipv6_dev_ac_inc+0x6c8/0xb10 net/ipv6/anycast.c:374
   ipv6_sock_ac_join+0x6a8/0x880 net/ipv6/anycast.c:153
   do_ipv6_setsockopt+0x203a/0x3150 net/ipv6/ipv6_sockglue.c:893
   ipv6_setsockopt+0x59/0x170 net/ipv6/ipv6_sockglue.c:965
   do_sock_setsockopt+0x17c/0x1b0 net/socket.c:2381
   __sys_setsockopt net/socket.c:2406 [inline]
   __do_sys_setsockopt net/socket.c:2412 [inline]
   __se_sys_setsockopt net/socket.c:2409 [inline]
   __x64_sys_setsockopt+0x13d/0x1b0 net/socket.c:2409
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f

-> (&ndev->lock){++-.}-{3:3} {
   HARDIRQ-ON-W at:
                    lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                    __raw_write_lock_bh include/linux/rwlock_api_smp.h:221 [inline]
                    _raw_write_lock_bh+0x36/0x50 kernel/locking/spinlock.c:338
                    addrconf_permanent_addr+0x16a/0xa20 net/ipv6/addrconf.c:3627
                    addrconf_notify+0x864/0x1050 net/ipv6/addrconf.c:3706
                    notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85
                    call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]
                    call_netdevice_notifiers net/core/dev.c:2301 [inline]
                    __dev_notify_flags+0x1a9/0x310 net/core/dev.c:9797
                    netif_change_flags+0xe8/0x1a0 net/core/dev.c:9826
                    dev_change_flags+0x130/0x270 net/core/dev_api.c:68
                    devinet_ioctl+0x9f2/0x1b30 net/ipv4/devinet.c:1199
                    inet_ioctl+0x42a/0x560 net/ipv4/af_inet.c:1011
                    sock_do_ioctl+0x101/0x320 net/socket.c:1313
                    sock_ioctl+0x5c6/0x7f0 net/socket.c:1434
                    vfs_ioctl fs/ioctl.c:51 [inline]
                    __do_sys_ioctl fs/ioctl.c:597 [inline]
                    __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
                    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
                    do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
                    entry_SYSCALL_64_after_hwframe+0x77/0x7f
   HARDIRQ-ON-R at:
                    lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                    __raw_read_lock_bh include/linux/rwlock_api_smp.h:192 [inline]
                    _raw_read_lock_bh+0x3e/0x50 kernel/locking/spinlock.c:256
                    inet6_fill_ifla6_attrs+0x1117/0x25e0 net/ipv6/addrconf.c:5858
                    inet6_fill_link_af+0x9b/0x120 net/ipv6/addrconf.c:5893
                    rtnl_fill_link_af+0x1c8/0x440 net/core/rtnetlink.c:1919
                    rtnl_fill_ifinfo+0x1e08/0x20f0 net/core/rtnetlink.c:2190
                    rtmsg_ifinfo_build_skb+0x17d/0x260 net/core/rtnetlink.c:4454
                    rtmsg_ifinfo_event net/core/rtnetlink.c:4487 [inline]
                    rtmsg_ifinfo+0x8c/0x1a0 net/core/rtnetlink.c:4496
                    register_netdevice+0x1aca/0x1ec0 net/core/dev.c:11475
                    register_netdev+0x40/0x60 net/core/dev.c:11539
                    vti6_init_net+0x238/0x370 net/ipv6/ip6_vti.c:1167
                    ops_init+0x35c/0x5c0 net/core/net_namespace.c:137
                    __register_pernet_operations net/core/net_namespace.c:1318 [inline]
                    register_pernet_operations+0x343/0x830 net/core/net_namespace.c:1395
                    register_pernet_device+0x2a/0x80 net/core/net_namespace.c:1482
                    vti6_tunnel_init+0x13/0x170 net/ipv6/ip6_vti.c:1251
                    do_one_initcall+0x250/0x870 init/main.c:1392
                    do_initcall_level+0x104/0x190 init/main.c:1454
                    do_initcalls+0x59/0xa0 init/main.c:1470
                    kernel_init_freeable+0x2a6/0x3e0 init/main.c:1703
                    kernel_init+0x1d/0x1d0 init/main.c:1593
                    ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
                    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
   IN-SOFTIRQ-W at:
                    lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                    __raw_write_lock include/linux/rwlock_api_smp.h:229 [inline]
                    _raw_write_lock+0x2e/0x40 kernel/locking/spinlock.c:304
                    addrconf_rs_timer+0xc8/0x6d0 net/ipv6/addrconf.c:4033
                    call_timer_fn+0x192/0x5e0 kernel/time/timer.c:1748
                    expire_timers kernel/time/timer.c:1799 [inline]
                    __run_timers kernel/time/timer.c:2374 [inline]
                    __run_timer_base+0x652/0x8b0 kernel/time/timer.c:2386
                    run_timer_base kernel/time/timer.c:2395 [inline]
                    run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2405
                    handle_softirqs+0x22a/0x840 kernel/softirq.c:622
                    __do_softirq kernel/softirq.c:656 [inline]
                    invoke_softirq kernel/softirq.c:496 [inline]
                    __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
                    irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
                    instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inline]
                    sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1061
                    asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
                    zone_watermark_fast+0xf7/0x230 mm/page_alloc.c:3686
                    get_page_from_freelist+0x537/0x2610 mm/page_alloc.c:3885
                    __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
                    __alloc_pages_noprof+0x10/0x100 mm/page_alloc.c:5255
                    alloc_pages_bulk_noprof+0x5ff/0x7c0 mm/page_alloc.c:5175
                    alloc_pages_bulk_mempolicy_noprof+0x34e/0x1680 mm/mempolicy.c:2798
                    vm_area_alloc_pages mm/vmalloc.c:3700 [inline]
                    __vmalloc_area_node mm/vmalloc.c:3878 [inline]
                    __vmalloc_node_range_noprof+0xad1/0x1750 mm/vmalloc.c:4064
                    __vmalloc_node_noprof mm/vmalloc.c:4124 [inline]
                    vzalloc_noprof+0xb2/0xe0 mm/vmalloc.c:4202
                    alloc_counters+0x64/0x5d0 net/ipv4/netfilter/ip_tables.c:799
                    copy_entries_to_user net/ipv6/netfilter/ip6_tables.c:837 [inline]
                    get_entries net/ipv6/netfilter/ip6_tables.c:1039 [inline]
                    do_ip6t_get_ctl+0xabd/0x1230 net/ipv6/netfilter/ip6_tables.c:1677
                    nf_getsockopt+0x26e/0x290 net/netfilter/nf_sockopt.c:116
                    ipv6_getsockopt+0x1fd/0x2b0 net/ipv6/ipv6_sockglue.c:1464
                    do_sock_getsockopt+0x51d/0x7e0 net/socket.c:2487
                    __sys_getsockopt net/socket.c:2518 [inline]
                    __do_sys_getsockopt net/socket.c:2525 [inline]
                    __se_sys_getsockopt net/socket.c:2522 [inline]
                    __x64_sys_getsockopt+0x1a4/0x240 net/socket.c:2522
                    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
                    do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
                    entry_SYSCALL_64_after_hwframe+0x77/0x7f
   INITIAL USE at:
                   lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                   __raw_write_lock_bh include/linux/rwlock_api_smp.h:221 [inline]
                   _raw_write_lock_bh+0x36/0x50 kernel/locking/spinlock.c:338
                   addrconf_permanent_addr+0x16a/0xa20 net/ipv6/addrconf.c:3627
                   addrconf_notify+0x864/0x1050 net/ipv6/addrconf.c:3706
                   notifier_call_chain+0x1ad/0x3d0 kernel/notifier.c:85
                   call_netdevice_notifiers_extack net/core/dev.c:2287 [inline]
                   call_netdevice_notifiers net/core/dev.c:2301 [inline]
                   __dev_notify_flags+0x1a9/0x310 net/core/dev.c:9797
                   netif_change_flags+0xe8/0x1a0 net/core/dev.c:9826
                   dev_change_flags+0x130/0x270 net/core/dev_api.c:68
                   devinet_ioctl+0x9f2/0x1b30 net/ipv4/devinet.c:1199
                   inet_ioctl+0x42a/0x560 net/ipv4/af_inet.c:1011
                   sock_do_ioctl+0x101/0x320 net/socket.c:1313
                   sock_ioctl+0x5c6/0x7f0 net/socket.c:1434
                   vfs_ioctl fs/ioctl.c:51 [inline]
                   __do_sys_ioctl fs/ioctl.c:597 [inline]
                   __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
                   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
                   do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
                   entry_SYSCALL_64_after_hwframe+0x77/0x7f
   INITIAL READ USE at:
                        lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
                        __raw_read_lock_bh include/linux/rwlock_api_smp.h:192 [inline]
                        _raw_read_lock_bh+0x3e/0x50 kernel/locking/spinlock.c:256
                        inet6_fill_ifla6_attrs+0x1117/0x25e0 net/ipv6/addrconf.c:5858
                        inet6_fill_link_af+0x9b/0x120 net/ipv6/addrconf.c:5893
                        rtnl_fill_link_af+0x1c8/0x440 net/core/rtnetlink.c:1919
                        rtnl_fill_ifinfo+0x1e08/0x20f0 net/core/rtnetlink.c:2190
                        rtmsg_ifinfo_build_skb+0x17d/0x260 net/core/rtnetlink.c:4454
                        rtmsg_ifinfo_event net/core/rtnetlink.c:4487 [inline]
                        rtmsg_ifinfo+0x8c/0x1a0 net/core/rtnetlink.c:4496
                        register_netdevice+0x1aca/0x1ec0 net/core/dev.c:11475
                        register_netdev+0x40/0x60 net/core/dev.c:11539
                        vti6_init_net+0x238/0x370 net/ipv6/ip6_vti.c:1167
                        ops_init+0x35c/0x5c0 net/core/net_namespace.c:137
                        __register_pernet_operations net/core/net_namespace.c:1318 [inline]
                        register_pernet_operations+0x343/0x830 net/core/net_namespace.c:1395
                        register_pernet_device+0x2a/0x80 net/core/net_namespace.c:1482
                        vti6_tunnel_init+0x13/0x170 net/ipv6/ip6_vti.c:1251
                        do_one_initcall+0x250/0x870 init/main.c:1392
                        do_initcall_level+0x104/0x190 init/main.c:1454
                        do_initcalls+0x59/0xa0 init/main.c:1470
                        kernel_init_freeable+0x2a6/0x3e0 init/main.c:1703
                        kernel_init+0x1d/0x1d0 init/main.c:1593
                        ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
                        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 }
 ... key      at: [<ffffffff9a982fe0>] ipv6_add_dev.__key+0x0/0x20
 ... acquired at:
   mark_lock+0x115/0x190 kernel/locking/lockdep.c:4753
   mark_usage kernel/locking/lockdep.c:-1 [inline]
   __lock_acquire+0x689/0x2cf0 kernel/locking/lockdep.c:5191
   lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
   __raw_write_lock include/linux/rwlock_api_smp.h:229 [inline]
   _raw_write_lock+0x2e/0x40 kernel/locking/spinlock.c:304
   addrconf_rs_timer+0xc8/0x6d0 net/ipv6/addrconf.c:4033
   call_timer_fn+0x192/0x5e0 kernel/time/timer.c:1748
   expire_timers kernel/time/timer.c:1799 [inline]
   __run_timers kernel/time/timer.c:2374 [inline]
   __run_timer_base+0x652/0x8b0 kernel/time/timer.c:2386
   run_timer_base kernel/time/timer.c:2395 [inline]
   run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2405
   handle_softirqs+0x22a/0x840 kernel/softirq.c:622
   __do_softirq kernel/softirq.c:656 [inline]
   invoke_softirq kernel/softirq.c:496 [inline]
   __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
   irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
   instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inline]
   sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1061
   asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
   zone_watermark_fast+0xf7/0x230 mm/page_alloc.c:3686
   get_page_from_freelist+0x537/0x2610 mm/page_alloc.c:3885
   __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
   __alloc_pages_noprof+0x10/0x100 mm/page_alloc.c:5255
   alloc_pages_bulk_noprof+0x5ff/0x7c0 mm/page_alloc.c:5175
   alloc_pages_bulk_mempolicy_noprof+0x34e/0x1680 mm/mempolicy.c:2798
   vm_area_alloc_pages mm/vmalloc.c:3700 [inline]
   __vmalloc_area_node mm/vmalloc.c:3878 [inline]
   __vmalloc_node_range_noprof+0xad1/0x1750 mm/vmalloc.c:4064
   __vmalloc_node_noprof mm/vmalloc.c:4124 [inline]
   vzalloc_noprof+0xb2/0xe0 mm/vmalloc.c:4202
   alloc_counters+0x64/0x5d0 net/ipv4/netfilter/ip_tables.c:799
   copy_entries_to_user net/ipv6/netfilter/ip6_tables.c:837 [inline]
   get_entries net/ipv6/netfilter/ip6_tables.c:1039 [inline]
   do_ip6t_get_ctl+0xabd/0x1230 net/ipv6/netfilter/ip6_tables.c:1677
   nf_getsockopt+0x26e/0x290 net/netfilter/nf_sockopt.c:116
   ipv6_getsockopt+0x1fd/0x2b0 net/ipv6/ipv6_sockglue.c:1464
   do_sock_getsockopt+0x51d/0x7e0 net/socket.c:2487
   __sys_getsockopt net/socket.c:2518 [inline]
   __do_sys_getsockopt net/socket.c:2525 [inline]
   __se_sys_getsockopt net/socket.c:2522 [inline]
   __x64_sys_getsockopt+0x1a4/0x240 net/socket.c:2522
   do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
   do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
   entry_SYSCALL_64_after_hwframe+0x77/0x7f


stack backtrace:
CPU: 0 UID: 0 PID: 5739 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_irq_inversion_bug+0x1d2/0x1e0 kernel/locking/lockdep.c:4125
 mark_lock_irq+0x3d2/0x420 kernel/locking/lockdep.c:-1
 mark_lock+0x115/0x190 kernel/locking/lockdep.c:4753
 mark_usage kernel/locking/lockdep.c:-1 [inline]
 __lock_acquire+0x689/0x2cf0 kernel/locking/lockdep.c:5191
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 __raw_write_lock include/linux/rwlock_api_smp.h:229 [inline]
 _raw_write_lock+0x2e/0x40 kernel/locking/spinlock.c:304
 addrconf_rs_timer+0xc8/0x6d0 net/ipv6/addrconf.c:4033
 call_timer_fn+0x192/0x5e0 kernel/time/timer.c:1748
 expire_timers kernel/time/timer.c:1799 [inline]
 __run_timers kernel/time/timer.c:2374 [inline]
 __run_timer_base+0x652/0x8b0 kernel/time/timer.c:2386
 run_timer_base kernel/time/timer.c:2395 [inline]
 run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2405
 handle_softirqs+0x22a/0x840 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1061 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1061
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.h:697
RIP: 0010:zone_watermark_fast+0xf7/0x230 mm/page_alloc.c:3687
Code: 00 00 fc ff df 80 3c 08 00 74 08 48 89 ef e8 d0 01 0e 00 48 8b 45 00 31 c9 48 85 c0 48 0f 4f c8 49 01 cd 4c 39 eb 4c 0f 4c eb <49> 8d 46 38 48 63 2c 24 83 fd 05 0f 83 08 01 00 00 49 89 df 4d 29
RSP: 0018:ffffc900045cf018 EFLAGS: 00000202
RAX: 0000000000000000 RBX: 0000000000001a43 RCX: 0000000000000000
RDX: 0000000000000000 RSI: 0000000000000008 RDI: ffff88815fffc810
RBP: ffff88815fffc810 R08: ffff88815fffc817 R09: 1ffff1102bfff902
R10: dffffc0000000000 R11: ffffed102bfff903 R12: 0000000000000000
R13: 0000000000000000 R14: ffff88815fffc100 R15: 0000000000000901
 get_page_from_freelist+0x537/0x2610 mm/page_alloc.c:3885
 __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5221
 __alloc_pages_noprof+0x10/0x100 mm/page_alloc.c:5255
 alloc_pages_bulk_noprof+0x5ff/0x7c0 mm/page_alloc.c:5175
 alloc_pages_bulk_mempolicy_noprof+0x34e/0x1680 mm/mempolicy.c:2798
 vm_area_alloc_pages mm/vmalloc.c:3700 [inline]
 __vmalloc_area_node mm/vmalloc.c:3878 [inline]
 __vmalloc_node_range_noprof+0xad1/0x1750 mm/vmalloc.c:4064
 __vmalloc_node_noprof mm/vmalloc.c:4124 [inline]
 vzalloc_noprof+0xb2/0xe0 mm/vmalloc.c:4202
 alloc_counters+0x64/0x5d0 net/ipv4/netfilter/ip_tables.c:799
 copy_entries_to_user net/ipv6/netfilter/ip6_tables.c:837 [inline]
 get_entries net/ipv6/netfilter/ip6_tables.c:1039 [inline]
 do_ip6t_get_ctl+0xabd/0x1230 net/ipv6/netfilter/ip6_tables.c:1677
 nf_getsockopt+0x26e/0x290 net/netfilter/nf_sockopt.c:116
 ipv6_getsockopt+0x1fd/0x2b0 net/ipv6/ipv6_sockglue.c:1464
 do_sock_getsockopt+0x51d/0x7e0 net/socket.c:2487
 __sys_getsockopt net/socket.c:2518 [inline]
 __do_sys_getsockopt net/socket.c:2525 [inline]
 __se_sys_getsockopt net/socket.c:2522 [inline]
 __x64_sys_getsockopt+0x1a4/0x240 net/socket.c:2522
 do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
 do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
RIP: 0033:0x7fb03e19e62a
Code: 48 83 ec 10 89 d2 48 63 ff 45 31 c9 6a 2a 45 31 c0 31 c9 e8 d8 99 fb ff 48 83 c4 18 c3 0f 1f 00 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 06 c3 0f 1f 44 00 00 48 c7 c2 e8 ff ff ff f7
RSP: 002b:00007ffc25639248 EFLAGS: 00000212 ORIG_RAX: 0000000000000037
RAX: ffffffffffffffda RBX: 00007ffc256392d0 RCX: 00007fb03e19e62a
RDX: 0000000000000041 RSI: 0000000000000029 RDI: 0000000000000003
RBP: 0000000000000003 R08: 00007ffc2563926c R09: ffffffffff000000
R10: 00007ffc256392d0 R11: 0000000000000212 R12: 00007fb03e3ea240
R13: 00007ffc2563926c R14: 0000000000000000 R15: 00007fb03e3eafc0
 </TASK>
----------------
Code disassembly (best guess), 4 bytes skipped:
   0:	df 80 3c 08 00 74    	filds  0x7400083c(%rax)
   6:	08 48 89             	or     %cl,-0x77(%rax)
   9:	ef                   	out    %eax,(%dx)
   a:	e8 d0 01 0e 00       	call   0xe01df
   f:	48 8b 45 00          	mov    0x0(%rbp),%rax
  13:	31 c9                	xor    %ecx,%ecx
  15:	48 85 c0             	test   %rax,%rax
  18:	48 0f 4f c8          	cmovg  %rax,%rcx
  1c:	49 01 cd             	add    %rcx,%r13
  1f:	4c 39 eb             	cmp    %r13,%rbx
  22:	4c 0f 4c eb          	cmovl  %rbx,%r13
* 26:	49 8d 46 38          	lea    0x38(%r14),%rax <-- trapping instruction
  2a:	48 63 2c 24          	movslq (%rsp),%rbp
  2e:	83 fd 05             	cmp    $0x5,%ebp
  31:	0f 83 08 01 00 00    	jae    0x13f
  37:	49 89 df             	mov    %rbx,%r15
  3a:	4d                   	rex.WRB
  3b:	29                   	.byte 0x29


***

If these findings have caused you to resend the series or submit a
separate fix, please add the following tag to your commit message:
  Tested-by: syzbot@syzkaller.appspotmail.com

---
This report is generated by a bot. It may contain errors.
syzbot ci engineers can be reached at syzkaller@googlegroups.com.

To test a patch for this bug, please reply with `#syz test`
(should be on a separate line).

The patch should be attached to the email.
Note: arguments like custom git repos and branches are not supported.
