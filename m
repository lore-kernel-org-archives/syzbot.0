Received: from mail-oa1-f48.google.com (mail-oa1-f48.google.com [209.85.160.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0C4832B9A7
	for <syzbot@lists.linux.dev>; Fri,  6 Feb 2026 08:31:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770366696; cv=pass; b=gPSnBT1XjI23+dMu9yrnrlY66kzRbl9C6DehzJWrjmi+c8GzrDR5uyAXdI6nCYEAu583VBv+BfBlqkWWO9lKxthhO+W5AauGAfi42ELJIlcaxg2a88foWsVDuw+0dddapAPRkpW9bL4717tVhy09SQP2W/l4WILQjspFt5Ns7SU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770366696; c=relaxed/simple;
	bh=XtUrEK+RV9kBF66C/H0PsVlKrB3sRZQSfX36/1wX9MY=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QmREx1x75McVAZukZI7wEItvlt9kyAviCaVMy6euO0apl7DzZsGRFggE8C9/ikA/JLgp8yEjkr1qOB8YTGbJ1ipayaPf60LJN94SjhCeheU+m7RkjSJaf+w8r/85QW+/aglarn26dG81ZeoRAegPT06FLa5tGEEQb3kaSdf2A0U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=r7VO1QDQ; arc=pass smtp.client-ip=209.85.160.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="r7VO1QDQ"
Received: by mail-oa1-f48.google.com with SMTP id 586e51a60fabf-408199852c5so1663501fac.0
        for <syzbot@lists.linux.dev>; Fri, 06 Feb 2026 00:31:35 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770366694; cv=none;
        d=google.com; s=arc-20240605;
        b=AS6aJH/LdZzNd7T1malwliUrV/D2kO8Qf19imTNBfYN91R5Zr9wKMmJidgnVaiyb/W
         nLWmB0RKtCH4C7gCwq7SXJozjGG+8F/tDJI9t9pwt7VSo7F4PoXV2rZTZfBfcnqBrJTT
         mfLwL3PyDrADWctL6uQ2x3dw6kIU0EaY8Wlt9DEESI8Ebif6l2XwkVJI7MkIx9hArumI
         Hdp1ZQ06WQ8TCoFE4c1S6q5TVrKYbedJfAIByXgb+WXcMwD8q6FIuzey7W51rv0Cmthg
         2fUCiL6kvTq608ElE+b4ak6d6X3d+cWsaYXPPEHMukb/cOy7QIi2GEPs1DMvPD8nVA5T
         7fCA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=wU7Yl+LFJU/dONCXMf16o9+BqIwjmefFjBNitHUzPe4=;
        fh=DaFxQ01NtRxf5F86L+r0Xsbm/aCRo44HRXqZ3HnwsRc=;
        b=eQN9ZGROwivoceM4xHGTXEAQFPz5P3mVrFJwqLQ91tnFUqQ0/auYoW1iBsSYZxb8HG
         SUSZ33MATMgfGklsap739lHPfW8gak0Y76vzm0KWfuz4C3aZhN0pB8YGDGjVpRrMm3I2
         NNEm9AWPzvBTcvRwlOnpFOZFjUdso1JM7vNtd2a5uyA8iWgf26gsBkVBi4aEiTmF/iZB
         mbCbvr6xcrezOgfbgcHw7EOUeG6+pCWxGhumGOH53qsCYzdwxkqYOHrVC3LQy18j5lpC
         w5hsKoY+CQfZjm1vUT0nusasNKCN9JOadpUwx3gRS5VLf2sG4kCtKmhYHRPTIUteBcOz
         Zu0g==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770366694; x=1770971494; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=wU7Yl+LFJU/dONCXMf16o9+BqIwjmefFjBNitHUzPe4=;
        b=r7VO1QDQIKLsx0ATYHqquWwyHojEgI5eGozkQUctKcIdpZ8+VHaHiJ7j+wA0l2NjLu
         mrF7pAPwUiE34BBfADpt/TWTHRW4gkk8quKQXd1j6rffCuzTFI+z0+6aSNvvG72mhHZz
         HJ1ZFUGqDSncMESd1PdSoSYTrro+Lsd0/y+tkMlHN18L9MTveMDLiNLlpe5lbQpZmlg6
         oxvlgGhS+abh7Ertoun03GJJtwa7b7mOCq2tNUIiyty0NX5PlTSJDzsAvxbHQT5djG8g
         m5LHXWTfWc8S/Dlf5mCm6JfT1HOTHafyk/8tdajyy/AooAM2dSqh7twwetSSSsBLsJOS
         eT0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770366694; x=1770971494;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=wU7Yl+LFJU/dONCXMf16o9+BqIwjmefFjBNitHUzPe4=;
        b=TrRifh/8ztl5C/qLd6Myk4Km70a7bIcJt73ALUii6bvb/ujqqa02ZQmEWL0cY44jF1
         39t90hhYFHT2YjcRq0SdYoqSqx1n+vYHUGfo8QHttzzBVrsfQZHUs0exk82Bs++DmLBf
         /6GLKl8r6aD5rXgc8JUeV0ooyjTbLI/JP4Kh3k7DryErn2qX0DBFJHjyKxF5oJElQiQc
         cBOHcPbOjetVr7BUJnF2RoH+3Z77WKwWIMXT/BClHbnZmgZuS2UTLhbJNNVw8QtpkNQE
         cpP+ckMtPC/0Ni7NLUjw4ICUyXJfuV3uF6ccsm5TdC1wKfZuy8ikXEs5F8MkmgR+JLE4
         xtWA==
X-Forwarded-Encrypted: i=1; AJvYcCXPuga+0BEfwVsw7/5P1Xw1H2lLmO5Zzb7gOd+cNsTjuahCxpXKkXrmX0ZtryPdxacM1zg7xTU=@lists.linux.dev
X-Gm-Message-State: AOJu0YyLwrUOiTOdMI7q77oZN+wWht84sI/UYgXvQ6vV5FYO/ekOsEhd
	GSWGstzLBq5/E6VvCR6LxUvzHinsCI8YzhJxY2ZGomoqnANTws4MIuxvstk90CLYUMNUMnh0wr1
	K1kZ7cM6N22ysDb3hGhsjefSbA7Zdk/FOvk3G1Unk
X-Gm-Gg: AZuq6aIZ0cs7fO4IjlsThRH/ltQrruk7xDXo/Y7bLLjFJQJRL3BSl53k8YXadokWp5w
	tuHZVFph7o0h9ed5tT2RqHqNwM1Mt+/OE51UJp3L/vrdhRH8yJ5xyCk19Dw6BZqajwVtBr79YQp
	5bej8u8xofHbGjjF31us3f+bOx4p5v+2nrjKltuzzm1Rg/ZTh42udHK5gaw422yqN8fNcmOJfvu
	JX/RZizcEPSOwRDVkk+NxZ80KEhzmmW59/hzPIJQ0HscCk603NF6541MQw7FrrKlHi94tQY8r8K
	1gZwzejjde/rn4w+/hOs7JsVbMtbs8M8U3L5qilFOG73/TIFCPA6NvfxnQ==
X-Received: by 2002:a05:6870:1772:b0:3d4:6fba:31ff with SMTP id
 586e51a60fabf-40a96c41ff3mr1091504fac.1.1770366694346; Fri, 06 Feb 2026
 00:31:34 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <698588ea.a00a0220.37c87e.0033.GAE@google.com>
In-Reply-To: <698588ea.a00a0220.37c87e.0033.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 6 Feb 2026 09:31:23 +0100
X-Gm-Features: AZwV_QjyukjZahHUFA-KySyOYK0X40oKJaR0QN1zjazurPzHRfPu2ltPNBlO0i4
Message-ID: <CANp29Y49bO+76wouRqa8CBzdvaVbAzEk8pZ+95pteas=bALqVg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net/rds: RDS-TCP reconnect and fanout improvements
To: syzbot ci <syzbot+ci4b2f1eb20eeb4a02@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Feb 6, 2026 at 7:23=E2=80=AFAM syzbot ci
<syzbot+ci4b2f1eb20eeb4a02@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net/rds: RDS-TCP reconnect and fanout improvements
> https://lore.kernel.org/all/20260206022419.1357513-1-achender@kernel.org
> * [PATCH net-next v1 1/3] net/rds: Delegate fan-out to a background worke=
r
> * [PATCH net-next v1 2/3] net/rds: Use proper peer port number even when =
not connected
> * [PATCH net-next v1 3/3] net/rds: rds_sendmsg should not discard payload=
_len
>
> and found the following issue:
> BUG: sleeping function called from invalid context in rds_tcp_conn_free
>
> Full report is available here:
> https://ci.syzbot.org/series/1a5ef180-c02c-401d-9df7-670b18570a55
>
> ***
>
> BUG: sleeping function called from invalid context in rds_tcp_conn_free
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      7a4cd71fa4514cd85df39b3cf99da8142660cdcd
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/77f47047-43cb-4c25-b0b6-73b8746ce=
a2a/config
> syz repro: https://ci.syzbot.org/findings/49698f1e-4f36-4446-9dd1-c409366=
e6296/syz_repro
>
> BUG: sleeping function called from invalid context at kernel/workqueue.c:=
4390
> in_atomic(): 1, irqs_disabled(): 1, non_block: 0, pid: 6005, name: syz.2.=
19
> preempt_count: 1, expected: 0
> RCU nest depth: 1, expected: 0
> 2 locks held by syz.2.19/6005:
>  #0: ffffffff8e35a360 (rcu_read_lock){....}-{1:3}, at: rcu_lock_acquire i=
nclude/linux/rcupdate.h:331 [inline]
>  #0: ffffffff8e35a360 (rcu_read_lock){....}-{1:3}, at: rcu_read_lock incl=
ude/linux/rcupdate.h:867 [inline]
>  #0: ffffffff8e35a360 (rcu_read_lock){....}-{1:3}, at: __rds_conn_create+=
0x2e4/0x22d0 net/rds/connection.c:177
>  #1: ffffffff8fa00a98 (rds_conn_lock){....}-{3:3}, at: __rds_conn_create+=
0x18e2/0x22d0 net/rds/connection.c:304
> irq event stamp: 752
> hardirqs last  enabled at (751): [<ffffffff8b7cc843>] __raw_spin_unlock_i=
rq include/linux/spinlock_api_smp.h:159 [inline]
> hardirqs last  enabled at (751): [<ffffffff8b7cc843>] _raw_spin_unlock_ir=
q+0x23/0x50 kernel/locking/spinlock.c:202
> hardirqs last disabled at (752): [<ffffffff8b7cc61a>] __raw_spin_lock_irq=
save include/linux/spinlock_api_smp.h:108 [inline]
> hardirqs last disabled at (752): [<ffffffff8b7cc61a>] _raw_spin_lock_irqs=
ave+0x1a/0x60 kernel/locking/spinlock.c:162
> softirqs last  enabled at (32): [<ffffffff8ac0cd59>] rds_sendmsg+0x7b9/0x=
2150 net/rds/send.c:1266
> softirqs last disabled at (30): [<ffffffff89463a1f>] spin_lock_bh include=
/linux/spinlock.h:356 [inline]
> softirqs last disabled at (30): [<ffffffff89463a1f>] release_sock+0x2f/0x=
1f0 net/core/sock.c:3793
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 0 UID: 0 PID: 6005 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:8829
>  __cancel_work_sync+0x6d/0x110 kernel/workqueue.c:4390
>  rds_tcp_conn_free+0x2c/0x170 net/rds/tcp.c:361
>  __rds_conn_create+0x1bfb/0x22d0 net/rds/connection.c:334
>  rds_conn_create_outgoing+0x43/0x60 net/rds/connection.c:377
>  rds_sendmsg+0xff5/0x2150 net/rds/send.c:1321
>  sock_sendmsg_nosec net/socket.c:727 [inline]
>  __sock_sendmsg+0x21c/0x270 net/socket.c:742
>  ____sys_sendmsg+0x4d7/0x810 net/socket.c:2592
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2646
>  __sys_sendmsg net/socket.c:2678 [inline]
>  __do_sys_sendmsg net/socket.c:2683 [inline]
>  __se_sys_sendmsg net/socket.c:2681 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2681
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5b6bf9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5b6cd8b028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f5b6c216090 RCX: 00007f5b6bf9acb9
> RDX: 0000000000000000 RSI: 0000200000000480 RDI: 0000000000000004
> RBP: 00007f5b6c008bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5b6c216128 R14: 00007f5b6c216090 R15: 00007ffc17760058
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
> [achender@kernel.org allison.henderson@oracle.com edumazet@google.com hor=
ms@kernel.org kuba@kernel.org linux-kselftest@vger.kernel.org linux-rdma@vg=
er.kernel.org netdev@vger.kernel.org pabeni@redhat.com rds-devel@oss.oracle=
.com]
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
-upstream-moderation/698588ea.a00a0220.37c87e.0033.GAE%40google.com.
