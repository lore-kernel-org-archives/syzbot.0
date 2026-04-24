Received: from mail-oi1-f177.google.com (mail-oi1-f177.google.com [209.85.167.177])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE2C927603C
	for <syzbot@lists.linux.dev>; Fri, 24 Apr 2026 20:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.177
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777061779; cv=pass; b=HsnUyVd2SLRYgw35jsHzUUYr6WYF76LLsfkMUCEOMvK3kvV9fVj8DZ+AP7Nj44IxCVUZb2kKWLFE01zwtCqTZOEi5kysHvaPxAMFzJk93mW4AyWADKWQl02Syo9cVMx5DELmN9azxXLvU1Jb1oNw/r/WNULzHsXt7Ilzs/GT1g4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777061779; c=relaxed/simple;
	bh=JwCax4DGK+/psLBQYNGqfR0nXwSdJMQD0gbwFQxDkg4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=FjRF18fn8+V2RA+87po9gHLs7cw3ZjeTMdOq4XsfU1ggC3t4M2pTMb4V1rtYONxI1ywmKScWHY4yfMXeQU3yDGcRYl7BYqBlRrpQwR/re/nFabssm4cZigQL9iecsLJ3vnjCTy0dpJRd21lJySGj+YJTOZ0VNB4gv+yTXtMe7jI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A523CzNn; arc=pass smtp.client-ip=209.85.167.177
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A523CzNn"
Received: by mail-oi1-f177.google.com with SMTP id 5614622812f47-479932ccab1so4423089b6e.0
        for <syzbot@lists.linux.dev>; Fri, 24 Apr 2026 13:16:17 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777061777; cv=none;
        d=google.com; s=arc-20240605;
        b=ivQC7D8ri+FFN50SAZicwnCXoMt7Y7jC/TTWGmEx3JWufLsxYISNSlfh397hV2vtmT
         Yr3gFeFKpGZDVMtHTMU7C8lpexmbHCrardg54EmeHiVhyQZ5zXEL23Y1Ldhg8WtK7mX3
         I0f5eb2JXINjnEZmL6Y5kQ6w9I9R5VyxkERmB4XYjViBWbSK0anQkvGYHpgqPPQoJCr0
         80mVCRE4PpD+53S3A5BlxY5YXLkXw1R1idS03VVTRLb1dNt2Ee96fAANP0KZk85ty8eE
         YFGhZ7i7TGUnZbnXo9vi0Z5IP5noSUXX2BWOabbByAIiSiwDMbcillqLAIH5XEE2xySf
         weMQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1jEvXvV9Szki+2OB4y8O/lDe1+iUdMslR+EmGGWJ90I=;
        fh=frmA/na8WbJnlpxf12EKUGo3cH8lU8I8uY8SV/3GkMg=;
        b=aC0AVsdUj2KQgv7HvWLKyB3JpYKk5TJgrcUNP/VeRdshIyBjUBMN3fl2kursXbyoyo
         ipm45aNmpBrxj5+dcFnJvFMc8UdH/H4nE59G9tJ2R7sYFE4uEOc9vvLBfk6wgZbgxsBq
         10Go6g4ZHLQRhBKdJ5sJUI7vvezRWBcIH8YV1IZ2W61FmYzFyOOBfWx/OwfJ78/H5FdW
         Qj9JxrJwqi57EAp/pfjLbsAIfkoDJ4FJVpRTVrEdBZqYkc5Wj7lxx5eslmSCuyQgQ2NY
         nuQ6LhqnoVmFea7GGr6lifT812CJbeJ0SOc0MMWBdsyJvJQCAuYuv90BknnQSxKWUOYh
         i9yg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777061777; x=1777666577; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1jEvXvV9Szki+2OB4y8O/lDe1+iUdMslR+EmGGWJ90I=;
        b=A523CzNnsaP+G26lcvSg/7RRfxW9oT75jc12Kz+LKJaP3n3kqcw0iER/tnTSORo1xF
         USEuWa6uUya3HTz3tJv4qLYTJZiXiRQsQBnj4ZuoET8dTf4XvEogprIpG/7tHFxpCa87
         2kddBiEsP0S+HGvrjHT08tkzOJixeUuX4QLHWvWUYzgR5vuFrg0HZqWsrBuIWsctVJl1
         xXmtToxFpyw4AyT9E1OBM+49toxrgY/aa+jpY1ndNDQ901vOR/AOldogtKXojfov6YEb
         SBm5Jzi6rF3CckUSNiKgMu4Auk2JNDYVpXVdcEP1PowuETFt3Wo0b013qDXPu5jZesdq
         uT4w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777061777; x=1777666577;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1jEvXvV9Szki+2OB4y8O/lDe1+iUdMslR+EmGGWJ90I=;
        b=DlNm2zeW+hGPx93oeFyvdzquOpbnEaj0yh3cvaLx00DqAUbXSL4KNJhOjj1UZkpHfR
         qtezxPbCac3PzTPcED4mDZq9yHyylCAOeyQIddmire3LNI46Dhrme6mn3BneYbxc06CS
         amEQ6viU1W/XUGhLpNxlrKKIcf34r8M0iw4zm7DpcCtxYxNu5unWIpbwPknRbwY1Sn+W
         teZfJaIJ06WRPPpWrkYoJARKRGi1MbVoqJRZ8bXYgGOQUQiwT1HXTLvyJNkDDHQ2j32L
         igiD/7q/ppg4e1PnP/jfKmdoYoj7g9GW6ikf/VjfLsndufE3rErIodPfXBui2sbYiP1K
         uHSA==
X-Forwarded-Encrypted: i=1; AFNElJ/jBvkel5cxKNjf/uBPVLhp+rZzNn3U9TSX5xMqmHsUQGjjxiXrXv537bQDzzRJDiHS+Ne4Z6U=@lists.linux.dev
X-Gm-Message-State: AOJu0YygZxHkAZsockR5/kK3ROKTwYdGNemehD2yrnD5yw+p/E8jK7u3
	QIIhCMdxesNgOhT+robZg+zKau/6SZc92q+2psUJTEnuiKYlohph7zgFJ7kwbkDwnJdbenAn1oD
	6nvduv9IALeLQPmm7oouI/SliDcMMo8Nnerl3ixg2wLt9iX9WBJpAF5Z8
X-Gm-Gg: AeBDies9Q3vwFNyk4fReXSs/1R9dVxIh7lpl9sOIMdSNUM8MTpbf8lUvvu1DN4bH7bQ
	9VzDoYgIJ6T5ip1iGPwxJK+4bfeWfl5VjMP+o7OXhIJIh2foqwUAEaz23N2r7/oaAJaNWxVx0e8
	IqaAVOmZZ7m7OubgScHB6HFtrMJuv5Qw8ByiAMEEkB0P6nezFbxoaiLYteXaX8Uxfv2UfON/u+E
	v4j3v+9ZF9MrRIH6FICzCmaqpYTELkGrxTxGNspjbhilA2szjO8MTOqHhG6gTQGY6Y0jv+JwYuD
	FWM8Phq2uGlu2dM/Wcw16QO2e/7rhePdhfQXFT8svrNyOYvQ2qt66jz+IkX4J/VSNmc9JUE9Cd4
	ebXD4kLk4zzZPtv6Uf9dyHEqXptg=
X-Received: by 2002:a05:6808:d51:b0:46a:ccae:5517 with SMTP id
 5614622812f47-4799c9893c8mr18183287b6e.28.1777061776188; Fri, 24 Apr 2026
 13:16:16 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69ebc669.a00a0220.7773.0004.GAE@google.com>
In-Reply-To: <69ebc669.a00a0220.7773.0004.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 24 Apr 2026 22:16:03 +0200
X-Gm-Features: AQROBzCzD8LoCCWgxKSHzlPCbAdzlyL8Cc2ZIOLC04Z5SoppbC7f6L8FBYv1lSI
Message-ID: <CANp29Y7+4yaGxYYV6xV+2U=doSi3WouGT3CPU+C7xL6kmZ26yw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: vsock/virtio: fix memory leak in virtio_transport_recv_listen()
To: syzbot ci <syzbot+ci7ecf0777c715b82f@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Apr 24, 2026 at 9:37=E2=80=AFPM syzbot ci
<syzbot+ci7ecf0777c715b82f@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] vsock/virtio: fix memory leak in virtio_transport_recv_listen()
> https://lore.kernel.org/all/20260424150310.57228-1-kartikey406@gmail.com
> * [PATCH] vsock/virtio: fix memory leak in virtio_transport_recv_listen()
>
> and found the following issue:
> possible deadlock in virtio_transport_recv_listen
>
> Full report is available here:
> https://ci.syzbot.org/series/e5f3f5f1-8e83-492f-833b-dc526b61d0ef
>
> ***
>
> possible deadlock in virtio_transport_recv_listen
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      e728258debd553c95d2e70f9cd97c9fde27c7130
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/bcc67f3f-b441-4d11-8573-f26ca268d=
a65/config
> syz repro: https://ci.syzbot.org/findings/fce9fa9b-692a-420c-956f-12c7e6d=
75e2e/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> kworker/1:5/6007 is trying to acquire lock:
> ffff88817492e2a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: lock_sock include/ne=
t/sock.h:1713 [inline]
> ffff88817492e2a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: virtio_transport_rec=
v_listen+0x13a5/0x2230 net/vmw_vsock/virtio_transport_common.c:1593
>
> but task is already holding lock:
> ffff88817492e2a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: lock_sock include/ne=
t/sock.h:1713 [inline]
> ffff88817492e2a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: virtio_transport_rec=
v_pkt+0xfde/0x2bb0 net/vmw_vsock/virtio_transport_common.c:1671
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
> 3 locks held by kworker/1:5/6007:
>  #0: ffff888112391940 ((wq_completion)vsock-loopback){+.+.}-{0:0}, at: pr=
ocess_one_work kernel/workqueue.c:3277 [inline]
>  #0: ffff888112391940 ((wq_completion)vsock-loopback){+.+.}-{0:0}, at: pr=
ocess_scheduled_works+0xa35/0x1860 kernel/workqueue.c:3385
>  #1: ffffc900030dfc40 ((work_completion)(&vsock->pkt_work)){+.+.}-{0:0}, =
at: process_one_work kernel/workqueue.c:3278 [inline]
>  #1: ffffc900030dfc40 ((work_completion)(&vsock->pkt_work)){+.+.}-{0:0}, =
at: process_scheduled_works+0xa70/0x1860 kernel/workqueue.c:3385
>  #2: ffff88817492e2a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: lock_sock inclu=
de/net/sock.h:1713 [inline]
>  #2: ffff88817492e2a0 (sk_lock-AF_VSOCK){+.+.}-{0:0}, at: virtio_transpor=
t_recv_pkt+0xfde/0x2bb0 net/vmw_vsock/virtio_transport_common.c:1671
>
> stack backtrace:
> CPU: 1 UID: 0 PID: 6007 Comm: kworker/1:5 Not tainted syzkaller #0 PREEMP=
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
>  lock_sock_nested+0x41/0x100 net/core/sock.c:3783
>  lock_sock include/net/sock.h:1713 [inline]
>  virtio_transport_recv_listen+0x13a5/0x2230 net/vmw_vsock/virtio_transpor=
t_common.c:1593
>  virtio_transport_recv_pkt+0x174b/0x2bb0 net/vmw_vsock/virtio_transport_c=
ommon.c:1695
>  vsock_loopback_work+0x32c/0x3f0 net/vmw_vsock/vsock_loopback.c:142
>  process_one_work kernel/workqueue.c:3302 [inline]
>  process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3466
>  kthread+0x388/0x470 kernel/kthread.c:436
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
> [davem@davemloft.net edumazet@google.com eperezma@redhat.com horms@kernel=
.org jasowang@redhat.com kartikey406@gmail.com kuba@kernel.org kvm@vger.ker=
nel.org linux-kernel@vger.kernel.org mst@redhat.com netdev@vger.kernel.org =
pabeni@redhat.com sgarzare@redhat.com stefanha@redhat.com syzbot@syzkaller.=
appspotmail.com virtualization@lists.linux.dev xuanzhuo@linux.alibaba.com]
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
-upstream-moderation/69ebc669.a00a0220.7773.0004.GAE%40google.com.
