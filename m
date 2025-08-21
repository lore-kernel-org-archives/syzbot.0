Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38D172E266E
	for <syzbot@lists.linux.dev>; Thu, 21 Aug 2025 06:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755759182; cv=none; b=mYW0ASTUVXA1/wwewFrec+ZKEiNnmIKdLgyXN4o2INcDFBJRiHlP/hOhwMw7yjMt1TT/1XcvYX29OdGRYl3gqQFDAJ/6M441hLBGpDielZVksCnb83HVfKi12SF8z+QxRxXlILn7ZzHvy4z+QNlCrNs1l4bOGB90SEf2xpf/eys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755759182; c=relaxed/simple;
	bh=WEWy/JKl1BQFcNjVJoxFUD+a7IPsTVJtzaJTnPOIKZk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=uk+htUDHcWqfa4AJTMOrWQyj1nAEACyYPRpFDH6hlZbdV/iWJq7AM92WTeJHHJt0SQyjAcjDF3fM9eJwQ3lMB7KESHLMuNhHlSKVZ3Qx94clf5VG71WcfmjmxXLxmr/Gxi+3NpwmXDRY+QA3SYNzNuxARtHu3AXuZESwJRsg7Yo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Vkca3Jom; arc=none smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Vkca3Jom"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-30ccec59b4bso622511fac.3
        for <syzbot@lists.linux.dev>; Wed, 20 Aug 2025 23:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755759180; x=1756363980; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YBblbBG751YXCw5h6Kh8TsC2Ic59gBunqpkCi4RaAag=;
        b=Vkca3Jom02SYpEPaYSZOGxHC/npiJ3FMAwvPAA/auJXqS8U1L7J3+G9tbbFl7JvDSq
         jHSZgSt7BRHnt0a+jkuQsNs7YwAXm4D/OoHZldhbOb108dsA6jIov8ZCHcUhHwuE4bxG
         yvky7MXmVrb27L3clSBBJJqVFq6wreg+9rWum8+CPZzvoM4OOsDrPd+mjkYU6cQdm/L1
         ojKKKkImLvqNBnpvkEz0VpEh+QhAOiprGj7EjMNZA2a1MlZ2eZQ5kGlBVnppUVY37uFQ
         o/TXK8b9ofwtSymJQ/8JJ/hb7DQrInVloOsuz/HovazRUjfPosrESRw6Otl5CQw6MuGE
         VhFw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755759180; x=1756363980;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YBblbBG751YXCw5h6Kh8TsC2Ic59gBunqpkCi4RaAag=;
        b=B5t++RfqOJgHJPNy4fDbAb7auFvQsd7kHT4ZYjI8nGRcnD8eHtoHZpmJCYUWjV2Xqh
         ndAcEu0mxLqTxgx2+uqYBkJxcee+zG8TSpFNACRoab4cExd57K/Gkn9gGnvlQeGfi/cm
         usFxbrdWW98iAuRBoR5puR76GM1NFm5MGQTEO8IY/TRjU+1giPPm8YsyVcr2kAyh4DTI
         XHnHUh3Kr3IHLXMER1MKQizSWqTnuZoIh6SK4SzWoFoqBdFvTLEa6KFnnw5EVqfGLN4G
         hgqqMcF/98RwU+ljxQRSkdIKQDraqwLEKu6B3UXiBL9PZ48oRp//hLXHCFdIlBDUrtLM
         TJEw==
X-Forwarded-Encrypted: i=1; AJvYcCXCokzJOyt8clr9n1a7dyjcR8ATnp6593RG7/fyRShsyTZUVqdkEOStnTiKBmf8de5s5EPaxwc=@lists.linux.dev
X-Gm-Message-State: AOJu0YxtK0pu4Nl7jlwb6weB7u+DRJiESCLKfgfS0xSPCJ7q+QjjAY8G
	rgicFJeWOwmGSE0Ts/xznC3LO+Ty5wD7fVWvvLWXqVs+C0i/kGMAH6EUOHmdCjudSljBqDsaFD4
	ejJ72R9wDneLSfGz1y/lASEG/e4YH2P1xx9pS6gnK
X-Gm-Gg: ASbGncsGzMqoTeSI4vlQ2pMEQxnq3uz7D2AObUE+hNBWHQU4aF1d53a2cVkM6wNQ7j9
	gLCD/rLxiIJid8DIULfL39EPnQGcgv5Hvdt3B4AZRSQAZd6DZsiJUmVCY+AfucQuePFU7FcK4gR
	fv9eRxzOSfgqKgLuOosEuRtneytUOD1dQOH2rBdt3+nCRZT1lc8LHGcmX9LWgZ9hrMxO9fLdmFE
	LifAehYcsBMOtEjjMMWwfKHcFzn9pNzZns7Vlps9jiwGEz+SECNHRe3
X-Google-Smtp-Source: AGHT+IHWd4Fs/CDpQGxqYLIXyc3EBIHiMvELFrmoLMNKP7MvqZzLXYxCQriBd/y3mEDnAMmd3G4W78A5AOYel3xrdTA=
X-Received: by 2002:a05:6871:5313:b0:2d4:ce45:6988 with SMTP id
 586e51a60fabf-314c631185dmr634925fac.6.1755759180089; Wed, 20 Aug 2025
 23:53:00 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68a68c6f.050a0220.3d78fd.0013.GAE@google.com>
In-Reply-To: <68a68c6f.050a0220.3d78fd.0013.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 21 Aug 2025 08:52:49 +0200
X-Gm-Features: Ac12FXxRFQRDngK20jul-oL-zrjZo8Ci9Kv9gdDosqV8QJfrjCkkHTlVAv0Ejf4
Message-ID: <CANp29Y5wzfkNuz3BmWwBMHRmN=RcHS8WQb0VQmo=usvqFaxkVQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: io_uring/kbuf: ensure ring ctx is held locked
 over io_put_kbuf()
To: syzbot ci <syzbot+ci0a9892aadf35c415@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Aug 21, 2025 at 5:03=E2=80=AFAM syzbot ci
<syzbot+ci0a9892aadf35c415@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] io_uring/kbuf: ensure ring ctx is held locked over io_put_kbuf()
> https://lore.kernel.org/all/e2f14b20-2ad4-4e59-9966-26dd6aa70f31@kernel.d=
k
> * [PATCH] io_uring/kbuf: ensure ring ctx is held locked over io_put_kbuf(=
)
>
> and found the following issue:
> possible deadlock in io_req_defer_failed
>
> Full report is available here:
> https://ci.syzbot.org/series/fd113bf0-fc76-46b7-8c0b-08fa3c8bda14
>
> ***
>
> possible deadlock in io_req_defer_failed
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      dfc0f6373094dd88e1eaf76c44f2ff01b65db851
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/e832762c-b6ee-4bb3-b01f-da0e8f70d=
1d0/config
> C repro:   https://ci.syzbot.org/findings/57691bf2-072c-42f3-8742-8041442=
6104c/c_repro
> syz repro: https://ci.syzbot.org/findings/57691bf2-072c-42f3-8742-8041442=
6104c/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: possible recursive locking detected
> syzkaller #0 Not tainted
> --------------------------------------------
> syz.0.17/6012 is trying to acquire lock:
> ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_ring_submit_lock =
io_uring/io_uring.h:287 [inline]
> ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_put_kbuf io_uring=
/kbuf.h:132 [inline]
> ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: io_req_defer_failed+=
0x166/0x550 io_uring/io_uring.c:988
>
> but task is already holding lock:
> ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: __do_sys_io_uring_en=
ter io_uring/io_uring.c:3463 [inline]
> ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: __se_sys_io_uring_en=
ter+0x2d4/0x2b20 io_uring/io_uring.c:3398
>
> other info that might help us debug this:
>  Possible unsafe locking scenario:
>
>        CPU0
>        ----
>   lock(&ctx->uring_lock);
>   lock(&ctx->uring_lock);
>
>  *** DEADLOCK ***
>
>  May be due to missing lock nesting notation
>
> 1 lock held by syz.0.17/6012:
>  #0: ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: __do_sys_io_uri=
ng_enter io_uring/io_uring.c:3463 [inline]
>  #0: ffff88802aa620a8 (&ctx->uring_lock){+.+.}-{4:4}, at: __se_sys_io_uri=
ng_enter+0x2d4/0x2b20 io_uring/io_uring.c:3398
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 6012 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_deadlock_bug+0x28b/0x2a0 kernel/locking/lockdep.c:3041
>  check_deadlock kernel/locking/lockdep.c:3093 [inline]
>  validate_chain+0x1a3f/0x2140 kernel/locking/lockdep.c:3895
>  __lock_acquire+0xab9/0xd20 kernel/locking/lockdep.c:5237
>  lock_acquire+0x120/0x360 kernel/locking/lockdep.c:5868
>  __mutex_lock_common kernel/locking/mutex.c:598 [inline]
>  __mutex_lock+0x187/0x1360 kernel/locking/mutex.c:760
>  io_ring_submit_lock io_uring/io_uring.h:287 [inline]
>  io_put_kbuf io_uring/kbuf.h:132 [inline]
>  io_req_defer_failed+0x166/0x550 io_uring/io_uring.c:988
>  io_queue_sqe io_uring/io_uring.c:2032 [inline]
>  io_submit_sqe io_uring/io_uring.c:2284 [inline]
>  io_submit_sqes+0xe28/0x1d10 io_uring/io_uring.c:2397
>  __do_sys_io_uring_enter io_uring/io_uring.c:3464 [inline]
>  __se_sys_io_uring_enter+0x2df/0x2b20 io_uring/io_uring.c:3398
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f36d418ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc1d32a978 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 00007f36d43b5fa0 RCX: 00007f36d418ebe9
> RDX: 0000000000000000 RSI: 0000000000003516 RDI: 0000000000000003
> RBP: 00007f36d4211e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f36d43b5fa0 R14: 00007f36d43b5fa0 R15: 0000000000000006
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
> The email will later be sent to:
> [asml.silence@gmail.com axboe@kernel.dk io-uring@vger.kernel.org]
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
-upstream-moderation/68a68c6f.050a0220.3d78fd.0013.GAE%40google.com.
