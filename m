Received: from mail-oo1-f69.google.com (mail-oo1-f69.google.com [209.85.161.69])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C76903624BA
	for <syzbot@lists.linux.dev>; Fri, 24 Apr 2026 19:37:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.69
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777059436; cv=none; b=bprCBBc11/ioUoXxtiIpzTWorEZi8v8ep1wzHzOwTQSBR8phQeMWHxaMbJwKvnJmZ4CcVSf3Z+dueBnayI4Vs2iCa/rH2DU9Lo859WuIKH9AV2uEgeVi/QH0aS1DbXMSFUc1ZUU03HveeUVFxIt8XziCwQoZXeWclZuzgjXfQdc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777059436; c=relaxed/simple;
	bh=B0l2izE23oyZD3lJRsItwTMgzt+n04eOAL2XYDeW1/o=;
	h=MIME-Version:Date:Message-ID:Subject:From:To:Cc:Content-Type; b=gtOAHDLQdOscxTlFE91ePMukIjuULNJmPjJVf7YH2AQ9FvRZEQS4D9px7qJq3q1ZbkOMiIYBU7SYW1FIIZu3rvwW+27SBto+3WS2NN6hdjWgcgh68e8stIPDNXrx3Ssg5dGZzLNZifXTWF9pgrDqH8V1qNhDqk6+ADJlnfOnDro=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.69
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f69.google.com with SMTP id 006d021491bc7-6853c2438b9so15117062eaf.3
        for <syzbot@lists.linux.dev>; Fri, 24 Apr 2026 12:37:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777059434; x=1777664234;
        h=content-transfer-encoding:cc:to:from:subject:message-id:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=B482FHt6ysUO9cTKs8fmQLjt/bgrK2Afw6Ua1h0xKZQ=;
        b=dYtbTTUmDMzptFBPXeCzH1x5Uh8hiryL5YPD2ig4XRfZP4MRghmCnof8fFINv7qvCv
         ohwb5ObJwSErk6LazjcBgxpZTP7S8vKY47UTdspJNOtzRwH3g7UW4Mlxii01NF5Y8IeR
         uhZtfHdQE7XOEQLn/IOYrkVCRoMfNkx8XMbCZAd2L+e3pVrYu0cFmRzg5Dwlcum+Bu26
         9rvMeN7/s9umE1oOnFH6A6sWgP9WMHtEaFzzF+TbIpFg1oww5jKYAF56BzvlNHmggdYg
         9tdyjhkjOqULI2BH0exWvYkGq6m6ShyGK5MvYRDy+Lj9u7DeDWHKmHHyc19D4s+EezPc
         6QUQ==
X-Gm-Message-State: AOJu0YzEbhtP8tTAI3Ue8uIUPS8s9iz6QcH4Ba2+BXmwLNwnCyfsgAJw
	YIETXFjH9lb1U+EOmadtFKWP4LidioIWANtD//mrmpulVhc11I6QE5c+5SR38vV4tw//s70f8g6
	upkQR7yEECjR/ywIQ/hLHtzzVBCji0OGMuQeIgqzq26oA46RIRf3nCd4Pajg=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:198e:b0:695:a86:91a1 with SMTP id
 006d021491bc7-6950a86f145mr7308303eaf.24.1777059433774; Fri, 24 Apr 2026
 12:37:13 -0700 (PDT)
Date: Fri, 24 Apr 2026 12:37:13 -0700
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <69ebc669.a00a0220.7773.0004.GAE@google.com>
Subject: [moderation/CI] Re: vsock/virtio: fix memory leak in virtio_transport_recv_listen()
From: syzbot ci <syzbot+ci7ecf0777c715b82f@syzkaller.appspotmail.com>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

syzbot ci has tested the following series

[v1] vsock/virtio: fix memory leak in virtio_transport_recv_listen()
https://lore.kernel.org/all/20260424150310.57228-1-kartikey406@gmail.com
* [PATCH] vsock/virtio: fix memory leak in virtio_transport_recv_listen()

and found the following issue:
possible deadlock in virtio_transport_recv_listen

Full report is available here:
https://ci.syzbot.org/series/e5f3f5f1-8e83-492f-833b-dc526b61d0ef

***

possible deadlock in virtio_transport_recv_listen

tree:      net-next
URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/=
net-next.git
base:      e728258debd553c95d2e70f9cd97c9fde27c7130
arch:      amd64
compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp=
1~20251221153213.50), Debian LLD 21.1.8
config:    https://ci.syzbot.org/builds/bcc67f3f-b441-4d11-8573-f26ca268da6=
5/config
syz repro: https://ci.syzbot.org/findings/fce9fa9b-692a-420c-956f-12c7e6d75=
e2e/syz_repro

=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
WARNING: possible recursive locking detected
syzkaller #0 Not tainted
--------------------------------------------
kworker/1:5/6007 is trying to acquire lock:
ffff88817492e2a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: lock_sock include/net/=
sock.h:1713 [inline]
ffff88817492e2a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: virtio_transport_recv_=
listen+0x13a5/0x2230 net/vmw_vsock/virtio_transport_common.c:1593

but task is already holding lock:
ffff88817492e2a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: lock_sock include/net/=
sock.h:1713 [inline]
ffff88817492e2a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: virtio_transport_recv_=
pkt+0xfde/0x2bb0 net/vmw_vsock/virtio_transport_common.c:1671

other info that might help us debug this:
 Possible unsafe locking scenario:

       CPU0
       ----
  lock(sk_lock-AF_VSOCK);
  lock(sk_lock-AF_VSOCK);

 *** DEADLOCK ***

 May be due to missing lock nesting notation

3 locks held by kworker/1:5/6007:
 #0: ffff888112391940 ((wq_completion)vsock-loopback){+.+.}-{0:0}, at: proc=
ess_one_work kernel/workqueue.c:3277 [inline]
 #0: ffff888112391940 ((wq_completion)vsock-loopback){+.+.}-{0:0}, at: proc=
ess_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3385
 #1: ffffc900030dfc40 ((work_completion)(&vsock->pkt_work)){+.+.}-{0:0}, at=
: process_one_work kernel/workqueue.c:3278 [inline]
 #1: ffffc900030dfc40 ((work_completion)(&vsock->pkt_work)){+.+.}-{0:0}, at=
: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3385
 #2: ffff88817492e2a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: lock_sock include=
/net/sock.h:1713 [inline]
 #2: ffff88817492e2a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: virtio_transport_=
recv_pkt+0xfde/0x2bb0 net/vmw_vsock/virtio_transport_common.c:1671

stack backtrace:
CPU: 1 UID: 0 PID: 6007 Comm: kworker/1:5 Not tainted syzkaller #0 PREEMPT(=
full)=20
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16=
.2-1 04/01/2014
Workqueue: vsock-loopback vsock_loopback_work
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
 check_deadlock kernel/locking/lockdep.c:3093 [inline]
 validate_chain kernel/locking/lockdep.c:3895 [inline]
 __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
 lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
 lock_sock_nested+0x41/0x100 net/core/sock.c:3783
 lock_sock include/net/sock.h:1713 [inline]
 virtio_transport_recv_listen+0x13a5/0x2230 net/vmw_vsock/virtio_transport_=
common.c:1593
 virtio_transport_recv_pkt+0x174b/0x2bb0 net/vmw_vsock/virtio_transport_com=
mon.c:1695
 vsock_loopback_work+0x32c/0x3f0 net/vmw_vsock/vsock_loopback.c:142
 process_one_work kernel/workqueue.c:3302 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
 worker_thread+0xa53/0xfc0 kernel/workqueue.c:3466
 kthread+0x388/0x470 kernel/kthread.c:436
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
[davem@davemloft.net edumazet@google.com eperezma@redhat.com horms@kernel.o=
rg jasowang@redhat.com kartikey406@gmail.com kuba@kernel.org kvm@vger.kerne=
l.org linux-kernel@vger.kernel.org mst@redhat.com netdev@vger.kernel.org pa=
beni@redhat.com sgarzare@redhat.com stefanha@redhat.com syzbot@syzkaller.ap=
pspotmail.com virtualization@lists.linux.dev xuanzhuo@linux.alibaba.com]

If the report looks fine to you, reply with:
#syz upstream

If the report is a false positive, reply with
#syz invalid

