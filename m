Received: from mail-wm1-f44.google.com (mail-wm1-f44.google.com [209.85.128.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67EF036680F
	for <syzbot@lists.linux.dev>; Fri, 20 Feb 2026 18:41:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771612893; cv=pass; b=fQWq+BHcZjfaz/pwaJGYi+N7/ls57wWmiDAYEgN8raWP+pMEJFFPpFGSiSH1+wbDkGbDLir/cJi70m0eeBla4YoWGsucpNjCuH4/RD8rIpZhaVqN89ZVD4YrcCUhsXW1biGzgFnqYa6mvfMzWZ5yHjWI9z1wdezw8ni5bBM1ZsY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771612893; c=relaxed/simple;
	bh=jGWN+2KRz9O+H0665WvpQ52Kq/1J8TPaBwHG/SF4ULQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eQaWAcf4e56ueRf0FAwKMoTFi2hocESn0H/DEZsWtRgw4y6oTFH84qqLOLnpNZWL4+X4rQ5UaprKAKuyVm6bC0FA0lYpXzwyJziwFiyjIVQdHqR8SLbwbQXet6IlNk8QwOJMrgAKljg0FL1Rg4uEE9u2rdRG4MCCciq2KbiFpbY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=4qnEK51Y; arc=pass smtp.client-ip=209.85.128.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="4qnEK51Y"
Received: by mail-wm1-f44.google.com with SMTP id 5b1f17b1804b1-48373ad38d2so7685e9.0
        for <syzbot@lists.linux.dev>; Fri, 20 Feb 2026 10:41:29 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771612888; cv=none;
        d=google.com; s=arc-20240605;
        b=ONcUffqwEpGkkc0Rh3WatO2x4Wq1tlrUHTY7y9XQASXAX80D2AmJkbBjKo2CBAa8js
         ifkyWhLV7WppI5Xc+4BKBaJkamDayEs9By9de//jjwoEHwQKDCHTnLQikWEDlJnzHGpm
         2mqVLgjob0rOwOUeUBzFxnv6rocLEO78TrFk7mNo1sqzrgmu1caVdcomYkXbRuzIaqOn
         o2H4PDBsXfjKZorqiYyelxlEhRR+qsF8rZlO/b3GCKJawVNJxP3hDLw1rEEeWY7xcdOp
         gtrGVONLCAJICEvsL7sDHh6qCGbckyRSgm2qrpvVxeMXo+zInUa1XlqtaxxlNDepXqhE
         HH8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=9zD91sZr4vtMf1I/t0ZYhRV7PHrn122EkGjmR8qVtO4=;
        fh=56JHY4B2aUk2B3tt4sakC7Sy583EkXbY8HvwkwJxA6w=;
        b=WA/udUI4UKOYewOS/1Pz5/3We6DOhGi4H1pvTfDWKaI4KKjgnkqMGhMncR1//71EhM
         fPbOJf4cxU/am0ANp5iaNJiJXOZpDFfpbVZ1a5G9Nsx5oRp4WCTPs5P0L5DfYOpHTcgm
         8kM6oP72nXzbFblR8kh3T0ze9+hMsW4EZT8GOPpnWKYvLycUB2Rc3REHuN3+w5N29Fw+
         GyO02Sl91OaTfyWR5sDUCGDmqUM6Jb8k+CtggV0g+LlgPm4qxvl0rJFuocNMKnUKasH1
         OiYbwqnQL7fXQz/AMJzxM09sKp7oWdwLbvBMeww1sB7HChIEXWM8P+rZr/ZTvDGMLvO9
         HpMQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771612888; x=1772217688; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=9zD91sZr4vtMf1I/t0ZYhRV7PHrn122EkGjmR8qVtO4=;
        b=4qnEK51YcimGKiix25kJv8wxenyAVWCo+CkaBk/CZ7qfJ6zj38DuBFhEH4QJKhsX6h
         aJ9NcN5QaIJunGmYULHTCaZ5yMiPryyAE+5MMCzNRz502IxpPogfx4E6A2m3wRx71+36
         DL7ouGYqZemDQdPLV7R2XqwZDvNlP52puYkY0zPUmD0rwpDLhZ1iQCzXyEv03yzubISz
         CH8SObIUX+Dmu6mnxpUJUxmcF8SYMO2F9TDBjr+ytFOAAEOCLnSdGTfbYfJ2MirXRfNb
         6Dfx0KhRkNWdO4ryjNyliJxvQgsbmRNTork7MTyafBpXeqOtx2fSxulW5CC1euD2Ur6y
         oSVw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771612888; x=1772217688;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=9zD91sZr4vtMf1I/t0ZYhRV7PHrn122EkGjmR8qVtO4=;
        b=U1orcOd9UNJ1biXFlv7Z4E2KuZ/qr6RDiavfzoOS5ue7pxm7tUaRzhkEUCrA8IYVIh
         0fUkdSf11SYROGidGJh269Ok9HUfMwHhlAui11Xh/eIyP5sjc/5mfvghM8TAxw4bGu9x
         NeYz4mspUifGT6DX6pC2miHcpMGJjpXtG6Xjqmc3mL0n+1Z3pENA4aod4Evc9Fz88Okf
         CM7Kw0mvE+jkYIKfwhTT36ja8XLVmLThssS0iAGAlOM5HsCRLZYYotKdrfmNhdRK3zN3
         q+6TC9xfsYyM1XQrm6h4PRCB6MjoVrawWu5dOaQSRtw6W7UXWh8/xFe5EDgypYENEVpZ
         mTvA==
X-Forwarded-Encrypted: i=1; AJvYcCWb+Zg5BlgHPzAnEMZBLw5A5d3Cbq0KnAUNYS90JaRDjYDuy202veHBbPWARTLHZvr8BvWlEyk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzmuN/5+/B7KdyjbwJOgiXxCSnl6q6tr5NfUQPZFxXHoIIWvCuE
	YJbTRsWNgcA0sjkwEQFdlcHyzmO3DQ0pu9qNv3NforlyePo6A1BL5dr0wsF9nllo+BYk0oV4TvU
	xHtEZew7zVR3OmR3VbtWm+PjBNQLmRLG56HzpU7am
X-Gm-Gg: AZuq6aJDUgVXsg+uvR+Mm5nkDBEM9BZcL/n0I6FBN1jwT9of6x2JuMT1nFh/tRUkG9Q
	fKNJ4FCtPhDk/8DqgGw0NlmKKcPZKb/RcHA7UrOG2x7gfYk7pOXPbG/9QfUierTOFT3LiUITtUM
	bR1rmMbySrKp4gdtazU9U+s1VmZ8cInUU4NrDz//Lf1LdXLAQCJxZTDpCG/j/sl4p6oOdSMQMy/
	tZEzH5Fop+6FoD8AHeLvsN5irfEZ/8XxRKqk+GpokCMZZ7CvMMwH6zcWAK0db0gG9S/p5cGWMU4
	nALxlrVfN+as3kNIoRfCG6K6pR4qI93VxuyfpA==
X-Received: by 2002:a7b:ce83:0:b0:47b:e29f:c63f with SMTP id
 5b1f17b1804b1-483a9c94b7amr15895e9.11.1771612887389; Fri, 20 Feb 2026
 10:41:27 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20260220055449.3073-1-tjmercier@google.com> <699833fc.050a0220.b01bb.0039.GAE@google.com>
In-Reply-To: <699833fc.050a0220.b01bb.0039.GAE@google.com>
From: "T.J. Mercier" <tjmercier@google.com>
Date: Fri, 20 Feb 2026 10:41:15 -0800
X-Gm-Features: AaiRm52d4kAFkoYx2iC9CeE49X0_4sKfZ3IqpWEI6kL-ps7PY6q2ag5O0FgCNOg
Message-ID: <CABdmKX3jMS5ha2s5FMpnAMW0c9+Wmpmyc+8=D-24KyhVjBJvYg@mail.gmail.com>
Subject: Re: [syzbot ci] Re: kernfs: Add inotify IN_DELETE_SELF, IN_IGNORED support
To: syzbot ci <syzbot+cif2121bcf05a8d84e@syzkaller.appspotmail.com>
Cc: amir73il@gmail.com, cgroups@vger.kernel.org, driver-core@lists.linux.dev, 
	gregkh@linuxfoundation.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org, 
	shuah@kernel.org, tj@kernel.org, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Feb 20, 2026 at 2:14=E2=80=AFAM syzbot ci
<syzbot+cif2121bcf05a8d84e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] kernfs: Add inotify IN_DELETE_SELF, IN_IGNORED support
> https://lore.kernel.org/all/20260220055449.3073-1-tjmercier@google.com
> * [PATCH v4 1/3] kernfs: Don't set_nlink for directories being removed
> * [PATCH v4 2/3] kernfs: Send IN_DELETE_SELF and IN_IGNORED
> * [PATCH v4 3/3] selftests: memcg: Add tests for IN_DELETE_SELF and IN_IG=
NORED
>
> and found the following issue:
> possible deadlock in __kernfs_remove
>
> Full report is available here:
> https://ci.syzbot.org/series/4b44d5c2-c2eb-4425-a19a-f9963b64f74f
>
> ***
>
> possible deadlock in __kernfs_remove
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      ba268514ea14b44570030e8ed2aef92a38679e85
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/45ab774f-e8d7-4def-8279-888a5cb2d=
01e/config
> syz repro: https://ci.syzbot.org/findings/b74cbc6a-1cef-4ae9-be46-dd9e8b2=
9b648/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> kworker/u8:1/13 is trying to acquire lock:
> ffff88816ef2b878 (kn->active#5){++++}-{0:0}, at: __kernfs_remove+0x47e/0x=
8c0 fs/kernfs/dir.c:1533
>
> but task is already holding lock:
> ffff8881012e8ab8 (&root->kernfs_supers_rwsem){++++}-{4:4}, at: kernfs_rem=
ove_by_name_ns+0x3f/0x140 fs/kernfs/dir.c:1745
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #2 (&root->kernfs_supers_rwsem){++++}-{4:4}:
>        down_read+0x47/0x2e0 kernel/locking/rwsem.c:1537
>        kernfs_remove_by_name_ns+0x3f/0x140 fs/kernfs/dir.c:1745
>        acpi_unbind_one+0x2d8/0x3b0 drivers/acpi/glue.c:337
>        device_platform_notify_remove drivers/base/core.c:2386 [inline]
>        device_del+0x547/0x8f0 drivers/base/core.c:3881
>        serdev_controller_add+0x46f/0x640 drivers/tty/serdev/core.c:785
>        serdev_tty_port_register+0x159/0x260 drivers/tty/serdev/serdev-tty=
port.c:291
>        tty_port_register_device_attr_serdev+0xe7/0x170 drivers/tty/tty_po=
rt.c:187
>        serial_core_add_one_port drivers/tty/serial/serial_core.c:3107 [in=
line]
>        serial_core_register_port+0x103a/0x28b0 drivers/tty/serial/serial_=
core.c:3305
>        serial8250_register_8250_port+0x1658/0x1fd0 drivers/tty/serial/825=
0/8250_core.c:822
>        serial_pnp_probe+0x568/0x7f0 drivers/tty/serial/8250/8250_pnp.c:48=
0
>        pnp_device_probe+0x30b/0x4c0 drivers/pnp/driver.c:111
>        call_driver_probe drivers/base/dd.c:-1 [inline]
>        really_probe+0x267/0xaf0 drivers/base/dd.c:661
>        __driver_probe_device+0x18c/0x320 drivers/base/dd.c:803
>        driver_probe_device+0x4f/0x240 drivers/base/dd.c:833
>        __driver_attach+0x3e7/0x710 drivers/base/dd.c:1227
>        bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
>        bus_add_driver+0x345/0x670 drivers/base/bus.c:715
>        driver_register+0x23a/0x320 drivers/base/driver.c:249
>        serial8250_init+0x8f/0x160 drivers/tty/serial/8250/8250_platform.c=
:317
>        do_one_initcall+0x250/0x840 init/main.c:1378
>        do_initcall_level+0x104/0x190 init/main.c:1440
>        do_initcalls+0x59/0xa0 init/main.c:1456
>        kernel_init_freeable+0x2a6/0x3d0 init/main.c:1688
>        kernel_init+0x1d/0x1d0 init/main.c:1578
>        ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>
> -> #1 (&device->physical_node_lock){+.+.}-{4:4}:
>        __mutex_lock_common kernel/locking/mutex.c:614 [inline]
>        __mutex_lock+0x19f/0x1300 kernel/locking/mutex.c:776
>        acpi_get_first_physical_node drivers/acpi/bus.c:691 [inline]
>        acpi_primary_dev_companion drivers/acpi/bus.c:710 [inline]
>        acpi_companion_match+0x8a/0x120 drivers/acpi/bus.c:764
>        acpi_device_uevent_modalias+0x1a/0x30 drivers/acpi/device_sysfs.c:=
280
>        platform_uevent+0x3c/0xb0 drivers/base/platform.c:1411
>        dev_uevent+0x446/0x8a0 drivers/base/core.c:2692
>        kobject_uevent_env+0x477/0x9e0 lib/kobject_uevent.c:573
>        kobject_synth_uevent+0x585/0xbd0 lib/kobject_uevent.c:207
>        uevent_store+0x26/0x70 drivers/base/core.c:2773
>        kernfs_fop_write_iter+0x3af/0x540 fs/kernfs/file.c:352
>        new_sync_write fs/read_write.c:593 [inline]
>        vfs_write+0x61d/0xb90 fs/read_write.c:686
>        ksys_write+0x150/0x270 fs/read_write.c:738
>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>        do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> -> #0 (kn->active#5){++++}-{0:0}:
>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>        __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
>        lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
>        kernfs_drain+0x27c/0x5f0 fs/kernfs/dir.c:511
>        __kernfs_remove+0x47e/0x8c0 fs/kernfs/dir.c:1533
>        kernfs_remove_by_name_ns+0xc0/0x140 fs/kernfs/dir.c:1751
>        sysfs_remove_file include/linux/sysfs.h:780 [inline]
>        device_remove_file drivers/base/core.c:3071 [inline]
>        device_del+0x506/0x8f0 drivers/base/core.c:3876
>        device_unregister+0x21/0xf0 drivers/base/core.c:3919
>        mac80211_hwsim_del_radio+0x2dc/0x490 drivers/net/wireless/virtual/=
mac80211_hwsim.c:5918
>        hwsim_exit_net+0xede/0xfa0 drivers/net/wireless/virtual/mac80211_h=
wsim.c:6807
>        ops_exit_list net/core/net_namespace.c:199 [inline]
>        ops_undo_list+0x49f/0x940 net/core/net_namespace.c:252
>        cleanup_net+0x4df/0x7b0 net/core/net_namespace.c:696
>        process_one_work kernel/workqueue.c:3257 [inline]
>        process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
>        worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
>        kthread+0x726/0x8b0 kernel/kthread.c:463
>        ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>
> other info that might help us debug this:
>
> Chain exists of:
>   kn->active#5 --> &device->physical_node_lock --> &root->kernfs_supers_r=
wsem
>
>  Possible unsafe locking scenario:
>
>        CPU0                    CPU1
>        ----                    ----
>   rlock(&root->kernfs_supers_rwsem);
>                                lock(&device->physical_node_lock);
>                                lock(&root->kernfs_supers_rwsem);
>   lock(kn->active#5);
>
>  *** DEADLOCK ***
>
> 4 locks held by kworker/u8:1/13:
>  #0: ffff888100ef7948 ((wq_completion)netns){+.+.}-{0:0}, at: process_one=
_work kernel/workqueue.c:3232 [inline]
>  #0: ffff888100ef7948 ((wq_completion)netns){+.+.}-{0:0}, at: process_sch=
eduled_works+0x9d4/0x17a0 kernel/workqueue.c:3340
>  #1: ffffc90000127bc0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_wor=
k kernel/workqueue.c:3233 [inline]
>  #1: ffffc90000127bc0 (net_cleanup_work){+.+.}-{0:0}, at: process_schedul=
ed_works+0xa0f/0x17a0 kernel/workqueue.c:3340
>  #2: ffffffff8f99d2d0 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0xf=
e/0x7b0 net/core/net_namespace.c:670
>  #3: ffff8881012e8ab8 (&root->kernfs_supers_rwsem){++++}-{4:4}, at: kernf=
s_remove_by_name_ns+0x3f/0x140 fs/kernfs/dir.c:1745
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 13 Comm: kworker/u8:1 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: netns cleanup_net
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
>  check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>  validate_chain kernel/locking/lockdep.c:3908 [inline]
>  __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
>  lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
>  kernfs_drain+0x27c/0x5f0 fs/kernfs/dir.c:511
>  __kernfs_remove+0x47e/0x8c0 fs/kernfs/dir.c:1533
>  kernfs_remove_by_name_ns+0xc0/0x140 fs/kernfs/dir.c:1751
>  sysfs_remove_file include/linux/sysfs.h:780 [inline]
>  device_remove_file drivers/base/core.c:3071 [inline]
>  device_del+0x506/0x8f0 drivers/base/core.c:3876
>  device_unregister+0x21/0xf0 drivers/base/core.c:3919
>  mac80211_hwsim_del_radio+0x2dc/0x490 drivers/net/wireless/virtual/mac802=
11_hwsim.c:5918
>  hwsim_exit_net+0xede/0xfa0 drivers/net/wireless/virtual/mac80211_hwsim.c=
:6807
>  ops_exit_list net/core/net_namespace.c:199 [inline]
>  ops_undo_list+0x49f/0x940 net/core/net_namespace.c:252
>  cleanup_net+0x4df/0x7b0 net/core/net_namespace.c:696
>  process_one_work kernel/workqueue.c:3257 [inline]
>  process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
>  worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
>  kthread+0x726/0x8b0 kernel/kthread.c:463
>  ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>  </TASK>
> hsr_slave_0: left promiscuous mode
> hsr_slave_1: left promiscuous mode
> batman_adv: batadv0: Interface deactivated: batadv_slave_0
> batman_adv: batadv0: Removing interface: batadv_slave_0
> batman_adv: batadv0: Interface deactivated: batadv_slave_1
> batman_adv: batadv0: Removing interface: batadv_slave_1
> veth1_macvtap: left promiscuous mode
> veth0_macvtap: left promiscuous mode
> veth1_vlan: left promiscuous mode
> veth0_vlan: left promiscuous mode
> team0 (unregistering): Port device team_slave_1 removed
> team0 (unregistering): Port device team_slave_0 removed
> netdevsim netdevsim2 netdevsim0: set [1, 0] type 2 family 0 port 6081 - 0
> netdevsim netdevsim2 netdevsim1: set [1, 0] type 2 family 0 port 6081 - 0
> netdevsim netdevsim2 netdevsim2: set [1, 0] type 2 family 0 port 6081 - 0
> netdevsim netdevsim2 netdevsim3: set [1, 0] type 2 family 0 port 6081 - 0
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

Hm, I can see two ways to fix this.

The first is to drop the acpi_dev->physical_node_lock mutex in
acpi_unbind_one before calling sysfs_remove_link. This keeps the node
ID reserved while the sysfs files are still being removed, so that we
don't get any sysfs filename collisions (which are based on the node
ID). This seems like a good optimization to do anyway:

+++ b/drivers/acpi/glue.c
@@ -329,18 +329,22 @@ int acpi_unbind_one(struct device *dev)
        list_for_each_entry(entry, &acpi_dev->physical_node_list, node)
                if (entry->dev =3D=3D dev) {
                        char physnode_name[PHYSICAL_NODE_NAME_SIZE];

-                       list_del(&entry->node);
-                       acpi_dev->physical_node_count--;
+                       entry->dev =3D NULL;
+                       mutex_unlock(&acpi_dev->physical_node_lock);

                        acpi_physnode_link_name(physnode_name, entry->node_=
id);
                        sysfs_remove_link(&acpi_dev->dev.kobj, physnode_nam=
e);
                        sysfs_remove_link(&dev->kobj, "firmware_node");
                        ACPI_COMPANION_SET(dev, NULL);
                        /* Drop references taken by acpi_bind_one(). */
                        put_device(dev);
                        acpi_dev_put(acpi_dev);
+
+                       mutex_lock(&acpi_dev->physical_node_lock);
+                       list_del(&entry->node);
+                       acpi_dev->physical_node_count--;
                        kfree(entry);
                        break;
                }


The second is to drop the kernfs_supers_rwsem for the kernfs_drain,
similar to how the kernfs_rwsem is dropped there. I don't think
kernfs_supers_rwsem is usually heavily contended, but it's probably a
good idea to avoid holding it while potentially sleeping in
kernfs_drain. Since the kernfs_supers_rwsem is only held for
kernfs_drain in __kernfs_remove (but not kernfs_show) that means:

+++ b/fs/kernfs/dir.c
@@ -486,7 +486,7 @@ void kernfs_put_active(struct kernfs_node *kn)
  * removers may invoke this function concurrently on @kn and all will
  * return after draining is complete.
  */
-static void kernfs_drain(struct kernfs_node *kn)
+static void kernfs_drain(struct kernfs_node *kn, bool drop_supers)
        __releases(&kernfs_root(kn)->kernfs_rwsem)
        __acquires(&kernfs_root(kn)->kernfs_rwsem)
 {
@@ -506,6 +506,8 @@ static void kernfs_drain(struct kernfs_node *kn)
                return;

        up_write(&root->kernfs_rwsem);
+       if (drop_supers)
+               up_read(&root->kernfs_supers_rwsem);

        if (kernfs_lockdep(kn)) {
                rwsem_acquire(&kn->dep_map, 0, 0, _RET_IP_);
@@ -524,6 +526,8 @@ static void kernfs_drain(struct kernfs_node *kn)
        if (kernfs_should_drain_open_files(kn))
                kernfs_drain_open_files(kn);

+       if (drop_supers)
+               down_read(&root->kernfs_supers_rwsem);
        down_write(&root->kernfs_rwsem);
 }

@@ -1465,7 +1469,7 @@ void kernfs_show(struct kernfs_node *kn, bool show)
                kn->flags |=3D KERNFS_HIDDEN;
                if (kernfs_active(kn))
                        atomic_add(KN_DEACTIVATED_BIAS, &kn->active);
-               kernfs_drain(kn);
+               kernfs_drain(kn, false);
        }

        up_write(&root->kernfs_rwsem);
@@ -1530,7 +1534,7 @@ static void __kernfs_remove(struct kernfs_node *kn)
                 */
                kernfs_get(pos);

-               kernfs_drain(pos);
+               kernfs_drain(pos, true);
                parent =3D kernfs_parent(pos);
                /*
                 * kernfs_unlink_sibling() succeeds once per node.  Use it
