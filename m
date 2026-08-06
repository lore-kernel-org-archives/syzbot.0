Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE95D3F824B
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 15:21:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786029693; cv=pass; b=Mc+6Y1aRYXL1fD8ljV6EDh7GLUPDoIgR3DPHoTp6H3XEGV3sCnrrIXNa9m26nUb508E/w1LT1kgMxToeM7SfA0OdsFCHzSsDv53eTo6CtnFlsME2rSvSNubB1XHYSQY7B2A1/Z7KEtdFpsq3cLpAjY9s1g0bzWKEkiq3NPXxv7c=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786029693; c=relaxed/simple;
	bh=g/FdFiEUIcri45Cs/TMFo2IThGI+SwQNIg3tx1vaIoU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ohZPlr4KGtmd79YkbX8+z4Ze53kPG0+e6E0rUfmodGy+B2AZLHKbvZe5JDWy2qi9fIN5rXgTmVkGvj8vWrHvsxyYKBYAyuJPv8o9NUwtH/nlhVrmSgg3QhXGcdeKXSnH7pt17pKr49ANTe18bUBxO7FJYNf2qXggX53N6ZVx7S8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=LDc3hmhD; arc=pass smtp.client-ip=209.85.210.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="LDc3hmhD"
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7ec3b429a3aso1722543a34.1
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 08:21:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786029690; cv=none;
        d=google.com; s=arc-20260327;
        b=oK3IX5+enK0dY6jDZXNHxPctBjE+L0Re1uUdHMUuzZ8tUgkjtxr8zAk/XW6o2E1x/2
         4AG97NaEpGSzsv9zoOQki9KPNUKPyLpaO6Bc+OB7ce/mED3od8zf7oEdig1zDrJc/i8J
         OaPMmFeT8ETmkAOyjOroYfTPsOq+DE9EgmDXT3k86VZZXV7itN0pfAKQJ1CwQobx4TBK
         MpnC6WNeW4njKMfy0C8xulkhTlvEof5u/HMpD3gYYZpq8CBDgcXwpx/Is3rAmZ0hONlM
         PtiTJnjc7LSjsd5pIQWJAbztIh7l4nMCpgMl36LvMu3XfnjJqgfEJ9+nlkOjDqlXU3xY
         ysPg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=6/e6MDFzYQ9h/a8E4TOInku0vhFQvsqSLdeauCepjjM=;
        fh=FooDoVNXSnO6+cypw93T8QG0bWtPktpzz54YhKZeOqI=;
        b=pxcUcL4ceJll8FuWIXmpvPRlHhchI3TnBXQhUeVEBX/iEil+SQzAMOEaRwYSFQj+Dj
         6uF1hDZ4Czlc9MSJu8zA7NsL6pGXhARtCPLzr+m7loOqk/3Vq+0kt3tcLOtZzg9J5Z9+
         dq2w0eAMIyrADXt86oJdLfH9wjyRawMKOP7KXbgfzLtYomYnAwRtz1FwwMTK1J4wrwUI
         /8Ix0mEZoezA4jACnLPIZDy2RGcdWpTZ+kvYIQuN85KYQpfx8jvgJjJAOihSN63Z8VOx
         Lj8Zv8E8Gxst5gaJ1/Dci3UfV26Rj4X+HOl0gj0O61RStLglyzi5CIrLHTvL2nUx5YxY
         tskg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786029690; x=1786634490; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=6/e6MDFzYQ9h/a8E4TOInku0vhFQvsqSLdeauCepjjM=;
        b=LDc3hmhDmUwZnsDi7ht50GprQ2xyll5Y0Yi4cBclXkBrEzsgOARXmJ7OsJXqOpxWNd
         kNSQoIh57BkAfC1NjgYdgzcMrDfHLBEMz7JSvGHY/D/9yDSFSIiE6mM8TsLt6vMFVByu
         BqmFh4Cvz7hcBJ9l0KGlSOP3EnhsvjW0XK7go1mf3IEKAQYSkVux45LgahrqnPhU5reF
         nC9m0iMIyFgU/dS1L5RVDfuoZ1rNPtYFn3XO0n9I0O6qq9fHzSotlnu0n1unPviWnQAp
         G/NdkCr8DvAMYzo+wVV66s0BBcZU16MvX7hoosiMdesoTZc1XdTDmLVZ11tNoD/IC8vu
         sMuQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786029690; x=1786634490;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6/e6MDFzYQ9h/a8E4TOInku0vhFQvsqSLdeauCepjjM=;
        b=bSlF5fsd4WxmOruILt1vxhPqlQPjNbjkDTkWqOWYU3FX7F+cDtZQaCleySJ5oFFOa3
         siUDgM+GqP4Vq6E5ZgT9tAAxAerSgX9GZGqf2BBDFxCvwhpTFxtgA3/pZm2XCOHRqmH5
         1D/TY6FZd27+vQ2HeY9ZLov4oy1gcO9xGB0ghjHZ5Vwejrdbt3UmdGedjZKzHq2CD4FO
         rjuvhFGSHzhoX+nj/PVkOTYRKZkbRS4e3VntZmP7X9lwTSTa7DmQvQvIAs+WcqYyLRsR
         24qih/BM6cSmmxUlllPa1zTxxySqQCHaARzQVYU+pFfTjQcf9gi+EBci9DPeEETom2TD
         Czlw==
X-Forwarded-Encrypted: i=1; AHgh+RrQCQAPwCOTGbbNezASbN1uKGQOk5TUnDqvj9decNRogf2B0noP39IO2FEC4Jj0wiH6LSz76HY=@lists.linux.dev
X-Gm-Message-State: AOJu0YybIJHuiSOD+/ySEljFovAmVlxYccVH8ND90FrcrNeh54wq1Pul
	QHvwYdRqcv3vk0Hjm3dcytzm3hT9uhcgysa2n7vT3+l7tvS40Om04iuC/UD7a/o8XY6+06OlNJO
	nVnaDIRWBf6edAD74sYiRm/r3LBxvsWaTgz8NezN0
X-Gm-Gg: AR+sD11DpWEsQiIeWwJiXrRn0nN6aUg5VPySnK1apmiahafbZ1opglPxp9GFwlUOPtq
	XJ1FOhwf1EGLp6uK3G1OgCfT08sOrcuXw0DGYYWaoEwbdnUHqLn95hdd4SGEBrcw6OhXodoW+2E
	OfRJwt69BsQ6aFnrtGxLsj92wHE3vJZeml3ShlMuWFDDAHMJQPpQLa9hPGt85GktxI/KtkxHuTJ
	Eky0fZMptzCM4wgdTI2RkE8/ppdmly72MDOqOnTztKPKuqRCqrfikNKU69krHCQZnKoV5B9P4jR
	dIg8ys7HdJOp0ykIv0DaMNPSODy/LFyvvMU9yozRcQ0ZWED4RTjOP0mLpwSTNXO4J276tIpjI6g
	910WgdlyrHPBhlNKuG+1IhGPYbZ19TBTodRGKNbfwRPB1nnL4n2HdKb5Y4oyqp+Xa/U4IWdzCZR
	+hFH+0LL5Yun0c
X-Received: by 2002:a05:6820:2d0a:b0:6aa:f585:aabe with SMTP id
 006d021491bc7-6ae96d16ee6mr7799632eaf.15.1786029689768; Thu, 06 Aug 2026
 08:21:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a749d86.01d0871a.3a0d52.001d.GAE@google.com>
In-Reply-To: <6a749d86.01d0871a.3a0d52.001d.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 6 Aug 2026 17:21:18 +0200
X-Gm-Features: AUfX_mzOfVGj5c6L5gETJpxWBjNrXERSzkDeUXhGiHKjYmyKkvi1P5Wo3Ixv_JE
Message-ID: <CANp29Y6q_buFNw1EU8hz7DYQ3x8WpbStX_oSb2CTDCTbX3-94g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: switch ipset to rhashtable
To: syzbot ci <syzbot+ci5efd086adca92588@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Aug 6, 2026 at 4:43=E2=80=AFPM syzbot ci
<syzbot+ci5efd086adca92588@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] netfilter: switch ipset to rhashtable
> https://lore.kernel.org/all/20260806101947.2802-1-fw@strlen.de
> * [PATCH nf 1/7] netfilter: ipset: remove need to allocate memory on dele=
te operations
> * [PATCH nf 2/7] netfilter: ipset: let destroy callbacks adjust ext mem s=
ize
> * [PATCH nf 3/7] netfilter: ipset: add rhashtable boilerplate stubs
> * [PATCH nf 4/7] netfilter: ipset: add rhltable boilerplate stubs
> * [PATCH nf 5/7] netfilter: ipset: replace internal hash table with rhash=
table
> * [PATCH nf 6/7] netfilter: ipset: re-add forceadd support for rhashtable
> * [PATCH nf 7/7] netfilter: ipset: also report mem size for cidr storage =
to userspace
>
> and found the following issues:
> * UBSAN: shift-out-of-bounds in hash_netiface6_head
> * UBSAN: shift-out-of-bounds in hash_netportnet6_head
>
> Full report is available here:
> https://ci.syzbot.org/series/e7969a90-d2b3-4da4-8795-4c3794dae0f0
>
> ***
>
> UBSAN: shift-out-of-bounds in hash_netiface6_head
>
> tree:      nf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf.git
> base:      44871eadd07a7f004aa00cb87399461eea08c630
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/81d26051-7806-406c-9355-fbf52dca8=
f68/config
> syz repro: https://ci.syzbot.org/findings/cb9f585e-5753-41c6-b732-20d1d77=
f5564/syz_repro
>
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in net/netfilter/ipset/ip_set_hash_gen.h:1120:=
46
> shift exponent 32 is too large for 32-bit type 'u32' (aka 'unsigned int')
> CPU: 1 UID: 0 PID: 5865 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>  __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
>  hash_netiface6_head+0x89e/0x970 net/netfilter/ipset/ip_set_hash_gen.h:11=
20
>  ip_set_dump_do+0x1476/0x1920 net/netfilter/ipset/ip_set_core.c:1664
>  netlink_dump+0x711/0xee0 net/netlink/af_netlink.c:2331
>  __netlink_dump_start+0x589/0x7b0 net/netlink/af_netlink.c:2446
>  netlink_dump_start include/linux/netlink.h:341 [inline]
>  ip_set_dump+0x15b/0x1f0 net/netfilter/ipset/ip_set_core.c:1730
>  nfnetlink_rcv_msg+0xcc2/0x12b0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  nfnetlink_rcv+0x2b9/0x28c0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
>  __sock_sendmsg net/socket.c:790 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
>  __sys_sendmsg net/socket.c:2770 [inline]
>  __do_sys_sendmsg net/socket.c:2775 [inline]
>  __se_sys_sendmsg net/socket.c:2773 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f7b3159e019
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f7b323e2028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f7b31825fa0 RCX: 00007f7b3159e019
> RDX: 0000000000008080 RSI: 0000200000000180 RDI: 0000000000000004
> RBP: 00007f7b3163500c R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f7b31826038 R14: 00007f7b31825fa0 R15: 00007ffdc35054d8
>  </TASK>
> ---[ end trace ]---
>
>
> ***
>
> UBSAN: shift-out-of-bounds in hash_netportnet6_head
>
> tree:      nf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf.git
> base:      44871eadd07a7f004aa00cb87399461eea08c630
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/81d26051-7806-406c-9355-fbf52dca8=
f68/config
> syz repro: https://ci.syzbot.org/findings/0f098de1-ac6a-4b30-8a0d-ea1586a=
67851/syz_repro
>
> ------------[ cut here ]------------
> UBSAN: shift-out-of-bounds in net/netfilter/ipset/ip_set_hash_gen.h:1120:=
46
> shift exponent 32 is too large for 32-bit type 'u32' (aka 'unsigned int')
> CPU: 1 UID: 0 PID: 5838 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>  __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
>  hash_netportnet6_head+0x97a/0xa40 net/netfilter/ipset/ip_set_hash_gen.h:=
1120
>  ip_set_dump_do+0x1476/0x1920 net/netfilter/ipset/ip_set_core.c:1664
>  netlink_dump+0x711/0xee0 net/netlink/af_netlink.c:2331
>  __netlink_dump_start+0x589/0x7b0 net/netlink/af_netlink.c:2446
>  netlink_dump_start include/linux/netlink.h:341 [inline]
>  ip_set_dump+0x15b/0x1f0 net/netfilter/ipset/ip_set_core.c:1730
>  nfnetlink_rcv_msg+0xcc2/0x12b0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x226/0x4a0 net/netlink/af_netlink.c:2556
>  nfnetlink_rcv+0x2b9/0x28c0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x7bb/0x940 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec+0x13a/0x180 net/socket.c:775
>  __sock_sendmsg net/socket.c:790 [inline]
>  ____sys_sendmsg+0x54e/0x850 net/socket.c:2684
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2738
>  __sys_sendmsg net/socket.c:2770 [inline]
>  __do_sys_sendmsg net/socket.c:2775 [inline]
>  __se_sys_sendmsg net/socket.c:2773 [inline]
>  __x64_sys_sendmsg+0x1b1/0x290 net/socket.c:2773
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f44dc59e019
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f44dd41d028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f44dc825fa0 RCX: 00007f44dc59e019
> RDX: 0000000000000000 RSI: 0000200000000200 RDI: 0000000000000004
> RBP: 00007f44dc63500c R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f44dc826038 R14: 00007f44dc825fa0 R15: 00007ffdbc9c05c8
>  </TASK>
> ---[ end trace ]---
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
> [fw@strlen.de kadlec@netfilter.org netfilter-devel@vger.kernel.org]
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
-upstream-moderation/6a749d86.01d0871a.3a0d52.001d.GAE%40google.com.
