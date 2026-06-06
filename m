Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EABA221FC6
	for <syzbot@lists.linux.dev>; Sat,  6 Jun 2026 14:21:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780755718; cv=pass; b=FbiPGFMioCvcNO2gvIHB2UNJU9rDLJFyBwVrhLp3/LEB/uJF2SaBuceLnqiOBko1qJ2OLudzGJe8y+KAR3L1gxSOL5Z9XZ9GZMW42xAq+sPhh7BHADOPY8uRDC3ufYCCxmm5oynZC2jc/zXpfMpg5B/HODOZhJB7UKm42pn1NVA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780755718; c=relaxed/simple;
	bh=YIjz8YsSGabSmeLy/FyN0CH68ocg7R3G+YAIXXWtINk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=g/jnWHf/tDQrANGN39UuvnLED8X+P4aRSQdzx2NtjU38/tf1ayf0+4VsQOtV3WRJ77cvfi5CMLP32kSYDQDZdyo8HtxQHOKV93uU/kxsotQ3kTDICaSPLzSVqmm7baM2qQfmyp9VCZs1smenxJV8WdsZodtVe/RVYBPxn45EmsY=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=DHxhca2c; arc=pass smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="DHxhca2c"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-490be03d47bso23370305e9.0
        for <syzbot@lists.linux.dev>; Sat, 06 Jun 2026 07:21:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1780755715; cv=none;
        d=google.com; s=arc-20240605;
        b=TUbjjcY3vZB+OSwX7OeaHXth8nRz4TC/NmqYaToD9vzSSEn7k3WPOorOB/NSrj3MF7
         M4CiOJTdQsnEugmSywaEXa2u2GpVrS3g7a3beL9/DVe/1RbaKJ2psf+qkgyb7KcWnsN9
         OljyaRRZbYpMsvmY/CXOZn5dXkKZm3r6qfAHiwqy8KPOQttPxRxVeeLltyIdBloX6HSO
         cVIj5rOODZvx6doZPMkS2Cld14QUHRPoOFg7j5Ujeev7sB8GE63fKmjDfv/PI0jshhF3
         ZXj4ZOceYx/WNO0W6ro+/MkKXgw1MT1jcQr0/aSZYZCBRuxfq/dK0soKt8U7zjj9gygy
         6qdQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=gERcZW+cUor21cNxVdESVWgaSw6jhNywc4cK+obADDU=;
        fh=JKJH1oxxvNPF0+fW9xVZayA5SJRYDPI3v6NJUxu17ik=;
        b=Po9NiuYJ5hkJzCL5IzaDB22myxwA0IFDEsao63AfBerWdaeXzkT76AmhgghHHP1lwH
         xzttulUeG8nLLL89WGUgxkIMabqZzOuzYkHI5dtsJskldngApUfy8ba8bEw+NF9U+h8r
         V/NNM1+2h2/PWlbb2iLStXhPcRuf6mRjXP01ImJ6gaG0rxvBUJQZNypflI3D87MVIbVr
         jeSSoiIU8qhu9Ul2Kiqw5i4eB7IqqrKkavVAvBQPDo68TwaOPpJo2CfLVNFRCV4OspJX
         IKEaFrKrpuZS/tEfIbc+esfYFBSksedrYi7pp88DFfX7diVx6PcwDaU4lrdNRkNqNvun
         l+NQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1780755715; x=1781360515; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gERcZW+cUor21cNxVdESVWgaSw6jhNywc4cK+obADDU=;
        b=DHxhca2c9WDNR0qQ9Zp35ouZtVtkexO1cvOVztk9XsNuLasfJQN+3VWWIy59tKCUiN
         t3ixK9FcckEgkI900MbKp/qkY0ZNI40MTHgPFp1rpQP7ACotglm3UDM2a1vbayA8AcH6
         pIES0J3/Zgc5iRdZFbc7fwPga3iLzmV8O3Qo03oEV5E7HWErrdPn1dTpGiJFOGCKNbE0
         0kmHclMDHvNxuFGKH6noRo/lfPHzalr7JSvV3QIvYyPEMieyO46amTVdVRf2AnuFxlV/
         d3ry7b4RLfwaAQI0Lvpg3swcQZFEtIa7VThypyBB8/rHAoxNe1+OGjUFaWFrBtMH+E1Z
         nQYg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1780755715; x=1781360515;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=gERcZW+cUor21cNxVdESVWgaSw6jhNywc4cK+obADDU=;
        b=TAKlZRq9sKkRKeZJwEEbf0HK6saHxtwgAZPVXUhQMuqDKDXDaIMF0HoTHpiRTkv+zF
         ZTl+atFUYqR62FsS0qUWnsuiMiskA0nHKl2jhrBD2pobUehtu21s/R1S8bDFvZPk5q9f
         6+qjSDHEBcArZ+ZYZc1WL+LyYfVosi1jaz3+hx29ZWvActm5VFSbdtMw6HPPrdFlCjT5
         aPi/BvjLHMnL96mEvOktS4uomi9o14vhUypSl6CHXzZ1aCULKzrjqXi7HJxtf/Jmr5MR
         7+xwTzvQFsq4stNi0NZ7T6WjoZjfNPWjNIpRrqVvzrN1Qg8iuUHyJ1UTOoUU2Jk1Gt/1
         Twog==
X-Forwarded-Encrypted: i=1; AFNElJ+lg5tj2qzA69iR6roHZsUqhWSeqVaDJDsjYg/6grknoj+leDCL8caj8FbVoSZrAMMeROt0J6s=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw2CrSUoM+VcjwAb6nY784/Lk9GZlkQD6KuvdY3gsA12tLXdWkz
	9yFZGJ0qepLE3Bb/YzHh8jmSyc8XYzWA03Jv5L8t7cq6F9fcmJ2va3A4OTp3fSihaL4f/CWGgFd
	n6WwqHnhdf330cGUnE+lzb3hXb8IDR0WbDqtntDjt
X-Gm-Gg: Acq92OGCBVbWoPchlrnQys6VyYBmE/JddffrxIxytZ+eaRZwicNMp7DsDtIuUrqu2OO
	/nKTnbZjJnIDJwcbxs+7ir0qSBqnQKHtEY55n1GnAuPx3B4JeqDVyWmiRIkOXIFn/qUd6SwTMaA
	X84NrgozpHImMrfBeBYKG8PamxAJXf+WJPlG6/fu23ihL/06+dYr54EcC62uGm5DCCIJuTNE5g+
	zooc4hpzpa0ao2EjuP+Xx7CokxAC2xvZu+a8ub741cvB75aRnGydVv/f0ZwqZ4bO/qp+6F0yctA
	2RFPjKCRNcm2iVIhSC/Wqu6fDjuTAFeelBbzCqGvHt2Wyh4JI/U=
X-Received: by 2002:a05:600c:5290:b0:490:bd1d:472a with SMTP id
 5b1f17b1804b1-490c25b129amr127433915e9.15.1780755714618; Sat, 06 Jun 2026
 07:21:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a236acc.c25708ab.1b19ef.0000.GAE@google.com>
In-Reply-To: <6a236acc.c25708ab.1b19ef.0000.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Sat, 6 Jun 2026 17:21:43 +0300
X-Gm-Features: AVVi8Cd4Yz5wFrQlKiIODvtW4aAmGDAoGWPZ4c-Xai_tijfdaX4K76-VFgotMPc
Message-ID: <CAJWNTGyLasZLp5b9LUUWydR5R0jNo20O-uwXwXqNX=F_N=gzYw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: vsock/virtio: fix memory leak in virtio_transport_recv_listen
To: syzbot ci <syzbot+cib152ce168686a2bb@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sat, Jun 6, 2026 at 3:33=E2=80=AFAM syzbot ci
<syzbot+cib152ce168686a2bb@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] vsock/virtio: fix memory leak in virtio_transport_recv_listen
> https://lore.kernel.org/all/20260605191922.12720-1-divyakm@unc.edu
> * [PATCH] vsock/virtio: fix memory leak in virtio_transport_recv_listen
>
> and found the following issue:
> possible deadlock in virtio_transport_recv_listen
>
> Full report is available here:
> https://ci.syzbot.org/series/76f40e62-5a21-46d4-a636-10f0ec9c5040
>
> ***
>
> possible deadlock in virtio_transport_recv_listen
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      bfa3d89cc15c09f7d1581c834a5ed725189ec19f
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/5a94a424-94b1-4b1e-8b06-74d599333=
68f/config
> syz repro: https://ci.syzbot.org/findings/a8224003-11b3-4232-a635-6755ad8=
92149/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> kworker/0:3/5740 is trying to acquire lock:
> ffff88810efb62a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: lock_sock include/ne=
t/sock.h:1713 [inline]
> ffff88810efb62a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: virtio_transport_rec=
v_listen+0x964/0x2120 net/vmw_vsock/virtio_transport_common.c:1577
>
> but task is already holding lock:
> ffff88810efb62a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: lock_sock include/ne=
t/sock.h:1713 [inline]
> ffff88810efb62a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: virtio_transport_rec=
v_pkt+0xa26/0x2800 net/vmw_vsock/virtio_transport_common.c:1668
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(sk_lock-AF_VSOCK);
>   lock(sk_lock-AF_VSOCK);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 4 locks held by kworker/0:3/5740:
>  #0: ffff8881150d3540 ((wq_completion)vsock-loopback){+.+.}-{0:0}, at: pr=
ocess_one_work kernel/workqueue.c:3289 [inline]
>  #0: ffff8881150d3540 ((wq_completion)vsock-loopback){+.+.}-{0:0}, at: pr=
ocess_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3397
>  #1: ffffc90003fafc40 ((work_completion)(&vsock->pkt_work)){+.+.}-{0:0}, =
at: process_one_work kernel/workqueue.c:3290 [inline]
>  #1: ffffc90003fafc40 ((work_completion)(&vsock->pkt_work)){+.+.}-{0:0}, =
at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3397
>  #2: ffff88810efb62a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: lock_sock inclu=
de/net/sock.h:1713 [inline]
>  #2: ffff88810efb62a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: virtio_transpor=
t_recv_pkt+0xa26/0x2800 net/vmw_vsock/virtio_transport_common.c:1668
>  #3: ffff88810efb5120 (sk_lock-AF_VSOCK/1){+.+.}-{0:0}, at: virtio_transp=
ort_recv_listen+0x83f/0x2120 net/vmw_vsock/virtio_transport_common.c:1564
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5740 Comm: kworker/0:3 Not tainted syzkaller #0 PREEMP=
T(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: vsock-loopback vsock_loopback_work
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_deadlock_bug+0x279/0x290 kernel/locking/lockdep.c:3041
>  check_deadlock kernel/locking/lockdep.c:3093 [inline]
>  validate_chain kernel/locking/lockdep.c:3895 [inline]
>  __lock_acquire+0x253f/0x2cf0 kernel/locking/lockdep.c:5237
>  lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>  lock_sock_nested+0x41/0x100 net/core/sock.c:3790
>  lock_sock include/net/sock.h:1713 [inline]
>  virtio_transport_recv_listen+0x964/0x2120 net/vmw_vsock/virtio_transport=
_common.c:1577
>  virtio_transport_recv_pkt+0x1570/0x2800 net/vmw_vsock/virtio_transport_c=
ommon.c:1692
>  vsock_loopback_work+0x32c/0x3f0 net/vmw_vsock/vsock_loopback.c:142
>  process_one_work kernel/workqueue.c:3314 [inline]
>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3397
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3478
>  kthread+0x389/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
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
> [divyakm@cs.unc.edu divyakm@unc.edu horms@kernel.org kuba@kernel.org kvm@=
vger.kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pabeni@=
redhat.com syzbot@syzkaller.appspotmail.com virtualization@lists.linux.dev]
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
-upstream-moderation/6a236acc.c25708ab.1b19ef.0000.GAE%40google.com.
