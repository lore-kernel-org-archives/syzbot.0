Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com [209.85.210.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5D171C861D
	for <syzbot@lists.linux.dev>; Sat,  6 Jun 2026 00:33:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780705999; cv=none; b=jl9wbCPvbOBOpnepJo6Xx211onXhvKGAUpnJkV2qt/cSDMWjKYsanud6B/+qnYpXpt3M87Rlc4YUDtqLYD0h0JEsioNlsHc0lF46izKXbT1GdFGIK+jSqHvqGoN6vzCFhco2EbKqJGHRbDs3T4l6V0pNp0SSHxCYlm4qbYOuzPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780705999; c=relaxed/simple;
	bh=V/fuj3soBtVNVTVh9fXQHJJiN3YA2A0+1gt5TtseA5Q=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=CTCPxw6VD6F81iksNugKE4jI9QNuE/gn1eVhpdfSqPZqOXdYHSflHlEYNIf/xIqlZ5eyxTYRHV/dLjovahL85RiwicfExuKSP04ih6mPFguCPkzBMmnNMTMtIkWiO2qBiA09MwbqvwLCvUDbSuBnWRqFhZDc2hCZGEYdVCrsp9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.210.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-ot1-f70.google.com with SMTP id 46e09a7af769-7e6dd5840c1so4469035a34.2
        for <syzbot@lists.linux.dev>; Fri, 05 Jun 2026 17:33:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780705996; x=1781310796;
        h=cc:to:from:subject:message-id:date:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=BchW4ih0uZr7N0XYAlEvkbJYdd+KgrOd06EldKXGcGA=;
        b=i868bMzIJDML4AujWnm7rWFnWs+uCTULnOmK4BCEKmUx8JKQIQUof6DA9ECHSEN9GD
         etBSrdXAQLt4CSMHpo5i7x8+RLinOt327aeQZ1VjutPO23z9Fb6LMkSOT7ipGO7+CO+q
         A/vMsGsS4QLf7e6XcjhczjzmYiJhqJEVSxaY5Kvnt9d46uGU7t+2bwBynoRb7bIcMJ8+
         EjY5+4sTLE0LfIS3G8L8L98fhz9xtFkUAyceh0N3Y+qWTCWMYa4VB4MIjXj7+K9taQBS
         glYmWw07BwDGB+7/Qw0g9tHUK+njETFTj828eI/VtALxgQsPk9OoabgYdMEjLls7PHRh
         2z/Q==
X-Gm-Message-State: AOJu0YxyEAK+p+Myxe70o1EFvf39+Q3QDOK1qtW7uo+6q0c////Xgww8
	bPbFTcGi5vXvV3Nv1x6pgPkCXXdVlDm6DNEEBU0FAUJnUGud/V9KSaALQwfquSYW0fZ4kNkcLgf
	/Ir/2UbrbpYmZg4h2/EaCc9XrNIviyvXnaE36EbMc2ysnz4abwUbBfievTFA=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:1907:b0:696:72c4:5da3 with SMTP id
 006d021491bc7-69e68b5e5a8mr3125867eaf.15.1780705996735; Fri, 05 Jun 2026
 17:33:16 -0700 (PDT)
Date: Fri, 05 Jun 2026 17:33:16 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a236acc.c25708ab.1b19ef.0000.GAE@google.com>
Subject: [moderation/CI] Re: vsock/virtio: fix memory leak in virtio_transport_recv_listen
From: syzbot ci <syzbot+cib152ce168686a2bb@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
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

The email will later be sent to:
[divyakm@cs.unc.edu divyakm@unc.edu horms@kernel.org kuba@kernel.org kvm@vger.kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com syzbot@syzkaller.appspotmail.com virtualization@lists.linux.dev]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

