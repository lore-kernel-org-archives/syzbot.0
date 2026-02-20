Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B6253126D0
	for <syzbot@lists.linux.dev>; Fri, 20 Feb 2026 10:12:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771582324; cv=pass; b=fLNELZS/0BdtZvtj9uASX5wgoPEXBhLAwWC7SkwPLUcYlHSvgba4E1/VHkDKO0gpNriYQwgFQVPX0MWae4kyUiCXm6xV2rA2bYg71jE11yHfxSdfDH2PkqKioeI/GIHrWxLE99JnWo5QDYVFr8O5Cwzn6/WE233+Vq0wL56MsCM=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771582324; c=relaxed/simple;
	bh=9BW1TkjoijWeSS+8HiDMGEmmnmXJSNzCMQuxPJX+R4o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=KRNExV/KulhxAKRACXfEu0Il/e74EwEOPal1938QKfgMLrpVaw0WXA1Zt0IV33/I/LoHyGELxWubULsi6SjrX3t5mj+10hbFPp2oSLlCezGMCnDvaDDCqMnUnEUa0FyF9N1Ygd97Xcr0WPCGzJGLXkiKjDiIvKT+y3u3nHxHQUk=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=2xrzka0G; arc=pass smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="2xrzka0G"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7d4bc6a8021so1454061a34.3
        for <syzbot@lists.linux.dev>; Fri, 20 Feb 2026 02:12:02 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1771582322; cv=none;
        d=google.com; s=arc-20240605;
        b=b4vGC5kYpP6t5FnOreywyrGy9zIWtQU0vCs1ALRv05QpFYlqASPkqGce5dlSw/SqC2
         ET1sYIQGLwtVvvzLYLgGNx/YyRS7JXiUAtxmvg5TLWyv/g1othrAOS7YmrI/itNHdWFE
         0T+MP+uonAtuLoFmuhs9fjK7Ja6maGXmbFC4U1CKjNCyVhVgymNCSjASESMChfsgex7y
         qekh49FxZyeW/3YyYylMPNusX0iNw1mOvQwDu3wFNVHHmJTI8TBUedM0J2pKNEi1Xk2N
         382UFbX6/4E5kF3R/6g+fDfHp1HYQcA2kB4PmPVp+C5uNoClQ8s9PT1JXxmEkAZudGYv
         IuTg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=iQkj2Ihp2M78tUiWSDrv5O3m6VAssU192L0azdIFv3Y=;
        fh=EI8y1qSwCdDnO/lrxktBC4Y1dyrlLT1L6BTYDzyTfqM=;
        b=RMlbQ9/FvRhEyuLODHTsE52har2cls6Q9/1g1MOQYWx4p4KDfhU5W2s+RY+XTRpsat
         h7hpcX8msu6rnCPQkndqKIo0HGC4yBlht6IvbErIoypJ6MNEOZIXbBcRPrNYyG0qLh3y
         E3/w6rTZ+eZPpaivA9tQ6zIWQUKYdwYVI2e4xhFYAfJ8XDUc4o1Ga2GZwdHrGcXK1shS
         Ia+pVRStzwGtC6yR0v4jShEtJN++dhRmDaH3h4wcGMAQOCkX4/SyyjqV71MP5lt+aNJ4
         hCV3a05MIZxSvhBjSm/ogrXrpsmRbwtX+FYqD37+2R6Cyr1fmTpqzVJNhr52eHiU5cYb
         ALWg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1771582322; x=1772187122; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=iQkj2Ihp2M78tUiWSDrv5O3m6VAssU192L0azdIFv3Y=;
        b=2xrzka0GJHVKs3sB/4QuU4zeLsvWrDLJ4DLTOzppG5L3NahV831XR1DbXKLdfuoB2c
         duWKfNmhXeNKUdIZAqsHHnXOexkgmdDABxYq01Zog37/xJdael2hp7VT5PfuEtQ6jZoD
         MjTurHziYdE1CDJ85wEZA29IfaVo5fOxpcQHLGjtob+GwK35NP7uk8zZ6KA8Wgs8F0HE
         7keZUJU2Fag1DnIvC5q3UqRGzrdCpOBkpHsk8AS2TpM2SVxbp5nCp4LaNbJrMsHu8CEF
         l/M9iRVLeDJaUYwwS/7NXV1Mt9EwjrXW6FDIzJKsqT4oKa+KailViCP79njzsYAR56l7
         S5bA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1771582322; x=1772187122;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=iQkj2Ihp2M78tUiWSDrv5O3m6VAssU192L0azdIFv3Y=;
        b=weZgY0yOEr8yp2K47dX2C440d6pESUTfJMYhwH/ukduPpEXwiaslNX6T5ZJdHOzIEM
         pR/0coCXrQT9d4VUByIEmytjyh4732GCmSRRp/O5aIHNoBdpRKhjOGxkFZmpQYl7ngiL
         ptNXFjIS0uGnFUo4UWm095AXrfO3tvCRH9XS2t72cEwQU9neY21oyG2/mmcVbaopLBq/
         wOIbAuXGn3eDF1s4JODbQFvQj/Mob/24RulAy+J4OHe9i/X+5zNTU6RQLvACKb+eSpGp
         eDGgcfqFZ3JdCV1RndN4ADkrwuIe5nDQIw7b+bL/PfL8akZUxFcObgcsxtZWIpsKfNRK
         bcDQ==
X-Forwarded-Encrypted: i=1; AJvYcCUAjltC6YIY5fWBCUWIMwgfe0mM9zXx3+36efS4X2Rq6NJpUjgnbn3oczT/t1wF5hJv7S7zWdM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwM9iQRMmwvwSAIAym+rz32AAt8Uatq180chfL0yv0UQYy38Uiz
	xrq4p0Mx5A25YGs8HynspB4eKIWgAnLo8Wz6k8un7M1nl2l41rGBkh7KeGh/I5hQ3wqGezoBvSK
	hnV6ni0mhLc/hRZi76IUdJpVKySTMJdkFs/h2R0nT
X-Gm-Gg: AZuq6aLDvJbI9kcZxH+BeGWQV8qYIy85Pz1pHJqHqccTwttU36vAWD2h1Ns+tY7U5KG
	IzuVMozc9uvuYrR1mbz94XOd3um5T4olQXqj0jmZBnaVMzPWt1y3G4AlKQdY+BxBsoUrYjQO1y/
	62pTC6IPUYVBkQp3+9ExE5mSnVBumPC8sKEJFBjuX+ZpqsBplbApqZlkOmDTtEBvNmF7b2nB5Kj
	xDYW19beqYGAuZWuqPIR9c6J0Ks2lk9dBxIGAOkUxoU5rudeP4Zz5+w4cs9tzA4e6n0nK9cbVor
	e7BqWNgTS0oVhkckx3t+8Ul7jWF6eoib7CfnuTbn/QPG679KWU15I6Wzmuqp5aa2PttvqQ==
X-Received: by 2002:a05:6830:2e07:b0:7c7:5d72:566c with SMTP id
 46e09a7af769-7d4d0bdb57amr13582932a34.24.1771582321595; Fri, 20 Feb 2026
 02:12:01 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <699831fe.a70a0220.2c38d7.013c.GAE@google.com> <CANp29Y6Ghsie7WM5NpQESq6Fg6D5QNnLmVV31pSU0fwYbBjibg@mail.gmail.com>
In-Reply-To: <CANp29Y6Ghsie7WM5NpQESq6Fg6D5QNnLmVV31pSU0fwYbBjibg@mail.gmail.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 20 Feb 2026 11:11:50 +0100
X-Gm-Features: AaiRm53hmUEdoOaZP5LlWz8y300ctJ6iwIAk5C9aeitOwsVgAmM4pIRy29Vafug
Message-ID: <CANp29Y4RB+yt_QgVZWO+fHA2Gn3FJ1PO_PvqnfySrK3_O6_B+A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: kernfs: Add inotify IN_DELETE_SELF,
 IN_IGNORED support
To: syzbot ci <syzbot+cid929a1b2d88b7512@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Fri, Feb 20, 2026 at 11:11=E2=80=AFAM Aleksandr Nogikh <nogikh@google.co=
m> wrote:
>
> #syz upstream
>
> On Fri, Feb 20, 2026 at 11:05=E2=80=AFAM syzbot ci <syzbot+cid929a1b2d88b=
7512@syzkaller.appspotmail.com> wrote:
>>
>> syzbot ci has tested the following series
>>
>> [v4] kernfs: Add inotify IN_DELETE_SELF, IN_IGNORED support
>> https://lore.kernel.org/all/20260220055449.3073-1-tjmercier@google.com
>> * [PATCH v4 1/3] kernfs: Don't set_nlink for directories being removed
>> * [PATCH v4 2/3] kernfs: Send IN_DELETE_SELF and IN_IGNORED
>> * [PATCH v4 3/3] selftests: memcg: Add tests for IN_DELETE_SELF and IN_I=
GNORED
>>
>> and found the following issue:
>> possible deadlock in __kernfs_remove
>>
>> Full report is available here:
>> https://ci.syzbot.org/series/4b44d5c2-c2eb-4425-a19a-f9963b64f74f
>>
>> ***
>>
>> possible deadlock in __kernfs_remove
>>
>> tree:      bpf-next
>> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/=
bpf-next.git
>> base:      ba268514ea14b44570030e8ed2aef92a38679e85
>> arch:      amd64
>> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~=
exp1~20251221153213.50), Debian LLD 21.1.8
>> config:    https://ci.syzbot.org/builds/45ab774f-e8d7-4def-8279-888a5cb2=
d01e/config
>> syz repro: https://ci.syzbot.org/findings/b74cbc6a-1cef-4ae9-be46-dd9e8b=
29b648/syz_repro
>>
>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
>> WARNING: possible circular locking dependency detected
>> syzkaller #0 Not tainted
>> ------------------------------------------------------
>> kworker/u8:1/13 is trying to acquire lock:
>> ffff88816ef2b878 (kn->active#5){++++}-{0:0}, at: __kernfs_remove+0x47e/0=
x8c0 fs/kernfs/dir.c:1533
>>
>> but task is already holding lock:
>> ffff8881012e8ab8 (&root->kernfs_supers_rwsem){++++}-{4:4}, at: kernfs_re=
move_by_name_ns+0x3f/0x140 fs/kernfs/dir.c:1745
>>
>> which lock already depends on the new lock.
>>
>>
>> the existing dependency chain (in reverse order) is:
>>
>> -> #2 (&root->kernfs_supers_rwsem){++++}-{4:4}:
>>        down_read+0x47/0x2e0 kernel/locking/rwsem.c:1537
>>        kernfs_remove_by_name_ns+0x3f/0x140 fs/kernfs/dir.c:1745
>>        acpi_unbind_one+0x2d8/0x3b0 drivers/acpi/glue.c:337
>>        device_platform_notify_remove drivers/base/core.c:2386 [inline]
>>        device_del+0x547/0x8f0 drivers/base/core.c:3881
>>        serdev_controller_add+0x46f/0x640 drivers/tty/serdev/core.c:785
>>        serdev_tty_port_register+0x159/0x260 drivers/tty/serdev/serdev-tt=
yport.c:291
>>        tty_port_register_device_attr_serdev+0xe7/0x170 drivers/tty/tty_p=
ort.c:187
>>        serial_core_add_one_port drivers/tty/serial/serial_core.c:3107 [i=
nline]
>>        serial_core_register_port+0x103a/0x28b0 drivers/tty/serial/serial=
_core.c:3305
>>        serial8250_register_8250_port+0x1658/0x1fd0 drivers/tty/serial/82=
50/8250_core.c:822
>>        serial_pnp_probe+0x568/0x7f0 drivers/tty/serial/8250/8250_pnp.c:4=
80
>>        pnp_device_probe+0x30b/0x4c0 drivers/pnp/driver.c:111
>>        call_driver_probe drivers/base/dd.c:-1 [inline]
>>        really_probe+0x267/0xaf0 drivers/base/dd.c:661
>>        __driver_probe_device+0x18c/0x320 drivers/base/dd.c:803
>>        driver_probe_device+0x4f/0x240 drivers/base/dd.c:833
>>        __driver_attach+0x3e7/0x710 drivers/base/dd.c:1227
>>        bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
>>        bus_add_driver+0x345/0x670 drivers/base/bus.c:715
>>        driver_register+0x23a/0x320 drivers/base/driver.c:249
>>        serial8250_init+0x8f/0x160 drivers/tty/serial/8250/8250_platform.=
c:317
>>        do_one_initcall+0x250/0x840 init/main.c:1378
>>        do_initcall_level+0x104/0x190 init/main.c:1440
>>        do_initcalls+0x59/0xa0 init/main.c:1456
>>        kernel_init_freeable+0x2a6/0x3d0 init/main.c:1688
>>        kernel_init+0x1d/0x1d0 init/main.c:1578
>>        ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>>
>> -> #1 (&device->physical_node_lock){+.+.}-{4:4}:
>>        __mutex_lock_common kernel/locking/mutex.c:614 [inline]
>>        __mutex_lock+0x19f/0x1300 kernel/locking/mutex.c:776
>>        acpi_get_first_physical_node drivers/acpi/bus.c:691 [inline]
>>        acpi_primary_dev_companion drivers/acpi/bus.c:710 [inline]
>>        acpi_companion_match+0x8a/0x120 drivers/acpi/bus.c:764
>>        acpi_device_uevent_modalias+0x1a/0x30 drivers/acpi/device_sysfs.c=
:280
>>        platform_uevent+0x3c/0xb0 drivers/base/platform.c:1411
>>        dev_uevent+0x446/0x8a0 drivers/base/core.c:2692
>>        kobject_uevent_env+0x477/0x9e0 lib/kobject_uevent.c:573
>>        kobject_synth_uevent+0x585/0xbd0 lib/kobject_uevent.c:207
>>        uevent_store+0x26/0x70 drivers/base/core.c:2773
>>        kernfs_fop_write_iter+0x3af/0x540 fs/kernfs/file.c:352
>>        new_sync_write fs/read_write.c:593 [inline]
>>        vfs_write+0x61d/0xb90 fs/read_write.c:686
>>        ksys_write+0x150/0x270 fs/read_write.c:738
>>        do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>>        do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>>        entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>
>> -> #0 (kn->active#5){++++}-{0:0}:
>>        check_prev_add kernel/locking/lockdep.c:3165 [inline]
>>        check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>>        validate_chain kernel/locking/lockdep.c:3908 [inline]
>>        __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
>>        lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
>>        kernfs_drain+0x27c/0x5f0 fs/kernfs/dir.c:511
>>        __kernfs_remove+0x47e/0x8c0 fs/kernfs/dir.c:1533
>>        kernfs_remove_by_name_ns+0xc0/0x140 fs/kernfs/dir.c:1751
>>        sysfs_remove_file include/linux/sysfs.h:780 [inline]
>>        device_remove_file drivers/base/core.c:3071 [inline]
>>        device_del+0x506/0x8f0 drivers/base/core.c:3876
>>        device_unregister+0x21/0xf0 drivers/base/core.c:3919
>>        mac80211_hwsim_del_radio+0x2dc/0x490 drivers/net/wireless/virtual=
/mac80211_hwsim.c:5918
>>        hwsim_exit_net+0xede/0xfa0 drivers/net/wireless/virtual/mac80211_=
hwsim.c:6807
>>        ops_exit_list net/core/net_namespace.c:199 [inline]
>>        ops_undo_list+0x49f/0x940 net/core/net_namespace.c:252
>>        cleanup_net+0x4df/0x7b0 net/core/net_namespace.c:696
>>        process_one_work kernel/workqueue.c:3257 [inline]
>>        process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
>>        worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
>>        kthread+0x726/0x8b0 kernel/kthread.c:463
>>        ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>>        ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>>
>> other info that might help us debug this:
>>
>> Chain exists of:
>>   kn->active#5 --> &device->physical_node_lock --> &root->kernfs_supers_=
rwsem
>>
>>  Possible unsafe locking scenario:
>>
>>        CPU0                    CPU1
>>        ----                    ----
>>   rlock(&root->kernfs_supers_rwsem);
>>                                lock(&device->physical_node_lock);
>>                                lock(&root->kernfs_supers_rwsem);
>>   lock(kn->active#5);
>>
>>  *** DEADLOCK ***
>>
>> 4 locks held by kworker/u8:1/13:
>>  #0: ffff888100ef7948 ((wq_completion)netns){+.+.}-{0:0}, at: process_on=
e_work kernel/workqueue.c:3232 [inline]
>>  #0: ffff888100ef7948 ((wq_completion)netns){+.+.}-{0:0}, at: process_sc=
heduled_works+0x9d4/0x17a0 kernel/workqueue.c:3340
>>  #1: ffffc90000127bc0 (net_cleanup_work){+.+.}-{0:0}, at: process_one_wo=
rk kernel/workqueue.c:3233 [inline]
>>  #1: ffffc90000127bc0 (net_cleanup_work){+.+.}-{0:0}, at: process_schedu=
led_works+0xa0f/0x17a0 kernel/workqueue.c:3340
>>  #2: ffffffff8f99d2d0 (pernet_ops_rwsem){++++}-{4:4}, at: cleanup_net+0x=
fe/0x7b0 net/core/net_namespace.c:670
>>  #3: ffff8881012e8ab8 (&root->kernfs_supers_rwsem){++++}-{4:4}, at: kern=
fs_remove_by_name_ns+0x3f/0x140 fs/kernfs/dir.c:1745
>>
>> stack backtrace:
>> CPU: 0 UID: 0 PID: 13 Comm: kworker/u8:1 Not tainted syzkaller #0 PREEMP=
T(full)
>> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1=
.16.2-1 04/01/2014
>> Workqueue: netns cleanup_net
>> Call Trace:
>>  <TASK>
>>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>>  print_circular_bug+0x2e1/0x300 kernel/locking/lockdep.c:2043
>>  check_noncircular+0x12e/0x150 kernel/locking/lockdep.c:2175
>>  check_prev_add kernel/locking/lockdep.c:3165 [inline]
>>  check_prevs_add kernel/locking/lockdep.c:3284 [inline]
>>  validate_chain kernel/locking/lockdep.c:3908 [inline]
>>  __lock_acquire+0x15a5/0x2cf0 kernel/locking/lockdep.c:5237
>>  lock_acquire+0x106/0x330 kernel/locking/lockdep.c:5868
>>  kernfs_drain+0x27c/0x5f0 fs/kernfs/dir.c:511
>>  __kernfs_remove+0x47e/0x8c0 fs/kernfs/dir.c:1533
>>  kernfs_remove_by_name_ns+0xc0/0x140 fs/kernfs/dir.c:1751
>>  sysfs_remove_file include/linux/sysfs.h:780 [inline]
>>  device_remove_file drivers/base/core.c:3071 [inline]
>>  device_del+0x506/0x8f0 drivers/base/core.c:3876
>>  device_unregister+0x21/0xf0 drivers/base/core.c:3919
>>  mac80211_hwsim_del_radio+0x2dc/0x490 drivers/net/wireless/virtual/mac80=
211_hwsim.c:5918
>>  hwsim_exit_net+0xede/0xfa0 drivers/net/wireless/virtual/mac80211_hwsim.=
c:6807
>>  ops_exit_list net/core/net_namespace.c:199 [inline]
>>  ops_undo_list+0x49f/0x940 net/core/net_namespace.c:252
>>  cleanup_net+0x4df/0x7b0 net/core/net_namespace.c:696
>>  process_one_work kernel/workqueue.c:3257 [inline]
>>  process_scheduled_works+0xaec/0x17a0 kernel/workqueue.c:3340
>>  worker_thread+0xda6/0x1360 kernel/workqueue.c:3421
>>  kthread+0x726/0x8b0 kernel/kthread.c:463
>>  ret_from_fork+0x51b/0xa40 arch/x86/kernel/process.c:158
>>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
>>  </TASK>
>> hsr_slave_0: left promiscuous mode
>> hsr_slave_1: left promiscuous mode
>> batman_adv: batadv0: Interface deactivated: batadv_slave_0
>> batman_adv: batadv0: Removing interface: batadv_slave_0
>> batman_adv: batadv0: Interface deactivated: batadv_slave_1
>> batman_adv: batadv0: Removing interface: batadv_slave_1
>> veth1_macvtap: left promiscuous mode
>> veth0_macvtap: left promiscuous mode
>> veth1_vlan: left promiscuous mode
>> veth0_vlan: left promiscuous mode
>> team0 (unregistering): Port device team_slave_1 removed
>> team0 (unregistering): Port device team_slave_0 removed
>> netdevsim netdevsim2 netdevsim0: set [1, 0] type 2 family 0 port 6081 - =
0
>> netdevsim netdevsim2 netdevsim1: set [1, 0] type 2 family 0 port 6081 - =
0
>> netdevsim netdevsim2 netdevsim2: set [1, 0] type 2 family 0 port 6081 - =
0
>> netdevsim netdevsim2 netdevsim3: set [1, 0] type 2 family 0 port 6081 - =
0
>>
>>
>> ***
>>
>> If these findings have caused you to resend the series or submit a
>> separate fix, please add the following tag to your commit message:
>>   Tested-by: syzbot@syzkaller.appspotmail.com
>>
>> ---
>> This report is generated by a bot. It may contain errors.
>> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>>
>> The email will later be sent to:
>> [amir73il@gmail.com cgroups@vger.kernel.org driver-core@lists.linux.dev =
gregkh@linuxfoundation.org jack@suse.cz linux-fsdevel@vger.kernel.org linux=
-kernel@vger.kernel.org linux-kselftest@vger.kernel.org shuah@kernel.org tj=
@kernel.org tjmercier@google.com]
>>
>> If the report looks fine to you, reply with:
>> #syz upstream
>>
>> If the report is a false positive, reply with
>> #syz invalid
>>
>> --
>> You received this message because you are subscribed to the Google Group=
s "syzkaller-upstream-moderation" group.
>> To unsubscribe from this group and stop receiving emails from it, send a=
n email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
>> To view this discussion visit https://groups.google.com/d/msgid/syzkalle=
r-upstream-moderation/699831fe.a70a0220.2c38d7.013c.GAE%40google.com.
