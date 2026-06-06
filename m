Received: from mail-oa1-f71.google.com (mail-oa1-f71.google.com [209.85.160.71])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE1C73B2FFF
	for <syzbot@lists.linux.dev>; Sat,  6 Jun 2026 14:24:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.71
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780755874; cv=none; b=hE9v8UHrEIUqLP9iRwRYT9ATwtTOOP9zP/mI0Zk3iNlpoOs4eVDbr6iXm7yB5Nfw+Erjed5wZvPlbGJlb/QJuxUohXlIl3+zahv/dtF5Q1dIoHHgvOgu8CukJPocTJeHsVV6bTdGqhlp5IkIvLnS+RHao5VTnojJOqeKbmS6R0k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780755874; c=relaxed/simple;
	bh=dKhCKOcjhkvzCXvDZwlyGR+b05owkjP821U1vQyfUz8=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=UlpJo+zmPV0Wq8E1lUl1kJ8/Siyb0ouyCYW+AQi2y2gbhdjbeUcosPAB++vFlkQGFmF6J64iD8BrRmSofkeCM+Ck4wVoTvdS437E1TnGT0rGUMounAvqPPCx57oe6y3JOtliUMT1kLtPflivirT92WktrFfD9j69J/FcxSJnAUA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.71
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f71.google.com with SMTP id 586e51a60fabf-43d1e8bbb82so5443078fac.2
        for <syzbot@lists.linux.dev>; Sat, 06 Jun 2026 07:24:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780755872; x=1781360672;
        h=cc:to:from:subject:message-id:in-reply-to:date:mime-version
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bnzhqntLJUbbhUF+5ztd1gvzI3Mxtaqi6t0iP+8wj8I=;
        b=ms8IwCsXL6QJI590SAjnSEr3vrDBdqbmRrLphLwYUNZmSlasfsuacvS0DH7RD9NFEc
         cJijpmUV9ZKiUcO/L9x4Clv/EwY+KzvCs6GjsaY0nRtIs1LA7KGnpHxo5jsyjyXAwIPt
         QFAFpzYx0AwPtm7frCaKL7f9+n5uhsQ0cF/GOUv+fpKK3Yw/RlbOYnT+qVwZJ48Yq/ud
         +iRhuMpiZ1vemP5bem5oYmoaqeAhLUeyzRZD+d0LGASnTrV+0LiyVLbM/P+7WIi6a/jk
         zEL4ElEtsjOzyaNxr4CG3v+0cHcr5GRthgyWkUfYz3h08JXZv4DMGv8CU/8SxOzorN0b
         dfJg==
X-Gm-Message-State: AOJu0YzT72+c7qm0PrH4W8Wpaa6yaPNAW3tt6oqT49QAlO6yzPbUHQ7/
	/Xiuj6llrJrzEYeL5R7pWsTQJjP6/dtvMOEusrXyKWTubT34Hi50vmFJ4FVlvLewx7eIVbxfYVT
	4KPpENsXt6idKdISiwvNkQoLOCuaR354F8DPbpg9g+d9QyudNWnVuWIvAE44=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:4df4:b0:69e:30ea:133e with SMTP id
 006d021491bc7-69e68c05d5cmr4739617eaf.34.1780755871968; Sat, 06 Jun 2026
 07:24:31 -0700 (PDT)
Date: Sat, 06 Jun 2026 07:24:31 -0700
In-Reply-To: <20260605191922.12720-1-divyakm@unc.edu>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a242d9f.e4db5ad2.3b7dfb.0007.GAE@google.com>
Subject: [syzbot ci] Re: vsock/virtio: fix memory leak in virtio_transport_recv_listen
From: syzbot ci <syzbot+cia2083008eb5f51b9@syzkaller.appspotmail.com>
To: divyakm@cs.unc.edu, divyakm@unc.edu, horms@kernel.org, kuba@kernel.org, 
	kvm@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org, 
	pabeni@redhat.com, syzbot@syzkaller.appspotmail.com, 
	virtualization@lists.linux.dev
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"

syzbot ci has tested the following series

[v1] vsock/virtio: fix memory leak in virtio_transport_recv_listen
https://lore.kernel.org/all/20260605191922.12720-1-divyakm@unc.edu
* [PATCH] vsock/virtio: fix memory leak in virtio_transport_recv_listen

and found the following issue:
possible deadlock in virtio_transport_recv_listen

Full report is available here:
https://ci.syzbot.org/series/76f40e62-5a21-46d4-a636-10f0ec9c5040

***

possible deadlock in virtio_transport_recv_listen

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
base:      bfa3d89cc15c09f7d1581c834a5ed725189ec19f
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/5a94a424-94b1-4b1e-8b06-74d59933368f/config
syz repro: https://ci.syzbot.org/findings/a8224003-11b3-4232-a635-6755ad892149/syz_repro

============================================
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
kworker/0:3/5740 is trying to acquire lock:
ffff88810efb62a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1713 [inline]
ffff88810efb62a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: virtio_transport_recv_listen+0x964/0x2120 net/vmw_vsock/virtio_transport_common.c:1577

but task is already holding lock:
ffff88810efb62a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1713 [inline]
ffff88810efb62a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: virtio_transport_recv_pkt+0xa26/0x2800 net/vmw_vsock/virtio_transport_common.c:1668

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sk_lock-AF_VSOCK);
  lock(sk_lock-AF_VSOCK);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

4 locks held by kworker/0:3/5740:
 #0: ffff8881150d3540 ((wq_completion)vsock-loopback){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3289 [inline]
 #0: ffff8881150d3540 ((wq_completion)vsock-loopback){+.+.}-{0:0}, at: process_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
 #1: ffffc90003fafc40 ((work_completion)(&vsock->pkt_work)){+.+.}-{0:0}, at: process_one_work kernel/workqueue.c:3290 [inline]
 #1: ffffc90003fafc40 ((work_completion)(&vsock->pkt_work)){+.+.}-{0:0}, at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
 #2: ffff88810efb62a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: lock_sock include/net/sock.h:1713 [inline]
 #2: ffff88810efb62a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: virtio_transport_recv_pkt+0xa26/0x2800 net/vmw_vsock/virtio_transport_common.c:1668
 #3: ffff88810efb5120 (sk_lock-AF_VSOCK/1){+.+.}-{0:0}, at: virtio_transport_recv_listen+0x83f/0x2120 net/vmw_vsock/virtio_transport_common.c:1564

stack backtrace:
CPU: 0 UID: 0 PID: 5740 Comm: kworker/0:3 Not tainted syzkaller #0 PREEMPT(full) 
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
Workqueue: vsock-loopback vsock_loopback_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain kernel/locking/lockdep.c:3895 [inline]
 __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 lock_sock_nested+0x41/0x100 net/core/sock.c:3790
 lock_sock include/net/sock.h:1713 [inline]
 virtio_transport_recv_listen+0x964/0x2120 net/vmw_vsock/virtio_transport_common.c:1577
 virtio_transport_recv_pkt+0x1570/0x2800 net/vmw_vsock/virtio_transport_common.c:1692
 vsock_loopback_work+0x32c/0x3f0 net/vmw_vsock/vsock_loopback.c:142
 process_one_work kernel/workqueue.c:3314 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
 kthread+0x389/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>


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
