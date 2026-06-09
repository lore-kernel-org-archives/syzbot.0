Received: from mail-oo1-f50.google.com (mail-oo1-f50.google.com [209.85.161.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 63B6D36897E
	for <syzbot@lists.linux.dev>; Tue,  9 Jun 2026 20:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.50
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781037814; cv=pass; b=hhO7u7zq9tkD2F4u5NgDJDdRgzN6oOzdBCmj1y1akbAmVYimPOaqq4TjcrIUIFA1oAuRxDsl6aeyxgdS3pRCnaRQo3B+FoXGLBcmOJ8H9m1nn4fauxF2kNLUjZsDFScVZBETso22BHQ/LaUneKO7ngYZoi+kfJIYdEV4+JM3Sos=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781037814; c=relaxed/simple;
	bh=+xOE7lOqV+k49sUeEI83GboTk1sd6qz3iAYk69BHXJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=E05LeHSEsrcLLt1odlBzD0Ex13pmsl28lir3p/TPY02DQe5O8l5ZQtkC7tbfP3Up2H29b3eZGLpQdZeNVTICCWP2FmS7hiXnkn9KBaC6I+9KUMzk88P8AZD9OvOxPdyI53kB9HWC5WQBmty9Ub0xG0imo8i8XohnuJDvyeZhc/U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=ZneGsjGf; arc=pass smtp.client-ip=209.85.161.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="ZneGsjGf"
Received: by mail-oo1-f50.google.com with SMTP id 006d021491bc7-69eb8b6bea8so170294eaf.3
        for <syzbot@lists.linux.dev>; Tue, 09 Jun 2026 13:43:32 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781037811; cv=none;
        d=google.com; s=arc-20240605;
        b=lmuxUTNd5CjsdS/Ia3a1w2DpvHv+qIHmSOVtyw9Edf97MAynX6KyTogfB1v5UIqjM1
         9lQ3QMYv7nPWejqhIBEVO4nNn8wd5XkBg1/wTQEMWvYg4+DYmXh8+yY8wS2NsTCwlmft
         /ehceM4LmXezSwAZ8PDrUeqhN4bPsQnUbfS/pHxojHUfKhp55VdJ9n22YBJ+EKUydi7p
         KuiNOxaFK+QDF11mwhRmCS0iT1Wt5opU2/Oey70yIcDuKhAQG0dZYcJ9P8Q9Pi5+WXzT
         6kuPDcRk+extIhPz2LRJnzEfV0eyVn8WmKdPjR2ln2/ke50VRdf4BIgFbU6vKSYX3QeW
         ctgg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=e543C9Ogxc6axLyRWdSLdnhIh5BYAYV5gYEIv/Yisc0=;
        fh=fv2jLlmbmie6UfqIt/BkpUe7Cly99lGysRw1W/t/JGY=;
        b=TcuQf8yPDbMd9wVCqyRICn3LhxPNeiTquI8iWRmZhDyuaJOewkOubA2gofmDuXLNVM
         pliHMCNp4nrmMHfsrlaj+uPoJO+SZS0tkcg+Ig4ObumSK2VwToVWAhbc09vmiYkYN5+1
         kEW/3ZoIkP4NmTMF8EsJauswp3Y+ZUOTP8yUd7IJOM+WjbG05UK7WzVRv3lJU4uV7din
         Uy6Cn+LV+uWlyjSYE/AsLI+JVN1PUSJ5Om/7OXqmgCE4YInZNV3VLgPGgJpNnTc6c/OM
         2tS36GWCl69YsLglOqfv194S7ks7A1c9ngmNJiSkEc1BLaSgjriWWJoKdS2uSKzFNJD0
         d1vg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781037811; x=1781642611; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=e543C9Ogxc6axLyRWdSLdnhIh5BYAYV5gYEIv/Yisc0=;
        b=ZneGsjGfhtHz1PzSuikkd5TvVmNJ+5ZriM1DBHYx4PIm5FZrZb5yv0+em5LCakyTY5
         BJOVneo/ALdvUqTPoC3PORhnuBn1B+ptOUjdZ6L14cM5nKPit12QoulLCVY51dKhUMF0
         8Xzpa/EXxoKfIv5Md2C7pnR7u8EZSpdKTLPs5p5KsV3HZ24flDnYIeQDHcFqkdLTKMNf
         f1HzBPWwjiGHfc9hQrjiov/geuI77uG2e+zefNtdsAlnHX0eV6tGklejK8AWUZUrYOxP
         IkODmV4g4yMVZR7KAWKFLIByXhsj8jdujWSaPes4i/EreBBntncDOSWnDDN7H/UwJKOp
         1XaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781037811; x=1781642611;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=e543C9Ogxc6axLyRWdSLdnhIh5BYAYV5gYEIv/Yisc0=;
        b=kYJHeHYHqJOfr9Fyc6xi21iaG5hfSJEIaBUbbSxmBNfdIottWXJaVTchFFImtmqIMM
         LR+KGrcF6dsD27oG5zFll14Gvi02/gIcNpX9xEA4hKVHIKhvWvOduMIkVMcSxQySU+s0
         qjGhLGcY2grWCIgWSMbF5FJ2+N3FaShmRbIxuxivkSX/rGBIfHbaGbA/2p6eR9An0UDQ
         OKC9yaMv3KCMZc2NAiVGdmrmWxlkGKqEGlalJcN2QLIYZCbAmt6uccPCeOSItPC8G5r/
         9GT5RejSd6EXRpd4eq9JPji+Id7uRe9AcdbqKnuWNesfjDuzTwi45f9ahrmk2KUn0WJz
         5TaQ==
X-Forwarded-Encrypted: i=1; AFNElJ9Q9JU/55Ob6FER1cXN7mnf+wMagqgCZukGPDMpY/zsSJGuf797qtIukBv8e9JASZqceNsi1t0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyYKKmGlvbIN6D2U2Uiwr2buRRWm3gMUERNXgP8C1cia/psOOET
	SxOuRCp3W6dQ+sR76Cv5L4f2kSML3YKyp2h/SkdthTcs8rMU8JoBNOwT9q+AdLVafWrp93mvU/f
	JfEH95LfXM7ZR1wO2BfduhMKGtv84lXIZ64W3KfTw
X-Gm-Gg: Acq92OHnDRL9N2p1rld1dCa2cXN+XwADRG1AMySCePWCRbnyGMvKDDomkkX3H/c2nr1
	VaQeGnsjWHiv7GL0VIaQlfbE+beM/6G8yRi14gpXsd3cTaSb5eJfdLmPnd58IyEE9LlKZtcvS95
	mbruhZ8tUrlmML6qoUlitxU7zzOi7eY12rQ+JB6kEE4tMepMQrQt93XwV7cqU7ZPulpRZpAXqYY
	6pXUcbiAgJE37OcZ4SgS938VhAH9INVZYH2Llg0PtbWNsWsT15q2Bkm5QptqyhHpS+/G4n5w4//
	nrxPT1AMaI7oEDkNP504jgp5LhIgHPFUSyM26hwBitqen81srZqD7XtGO0jKddZYy1Ov8nUWdOe
	A1waFxXaMd6grr0bZ0g==
X-Received: by 2002:a05:6820:3101:b0:69d:f0c2:73f3 with SMTP id
 006d021491bc7-69e68b09eddmr12532229eaf.2.1781037810556; Tue, 09 Jun 2026
 13:43:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a2856e7.39669fcc.33b062.009a.GAE@google.com>
In-Reply-To: <6a2856e7.39669fcc.33b062.009a.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 9 Jun 2026 22:43:18 +0200
X-Gm-Features: AVVi8Ce_T3YZrSIB4aWPETynrCHW8QaA2VvxVC35VprwqXCvSK4DlXrbszw2CtA
Message-ID: <CANp29Y4nsWH-kq4gWWM4Mx_2sYgyDM5ChPdOW5aTj6An1x63Vw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: ipset fixes, second batch
To: syzbot ci <syzbot+cibee19e18b81acfac@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Tue, Jun 9, 2026 at 8:09=E2=80=AFPM syzbot ci
<syzbot+cibee19e18b81acfac@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] netfilter: ipset fixes, second batch
> https://lore.kernel.org/all/20260609072750.318774-1-kadlec@netfilter.org
> * [PATCH v2 1/9] netfilter: ipset: Don't use test_bit() in lockless RCU r=
eaders in hash types
> * [PATCH v2 2/9] netfilter: ipset: Don't use test_bit() in lockless RCU r=
eaders in bitmap types
> * [PATCH v2 3/9] netfilter: ipset: fix order of kfree_rcu() and rcu_assig=
n_pointer()
> * [PATCH v2 4/9] netfilter: ipset: Extend the rcu locked area properly
> * [PATCH v2 5/9] netfilter: ipset: exlude gc when resize is in progress
> * [PATCH v2 6/9] netfilter: ipset: fix potential double free at resize/de=
l
> * [PATCH v2 7/9] netfilter: ipset: make sure gc is properly stopped
> * [PATCH v2 8/9] netfilter: ipset: fix potential torn read in reuse/force=
add cases
> * [PATCH v2 9/9] netfilter: ipset: rework cidr bookkeeping
>
> and found the following issues:
> * BUG: sleeping function called from invalid context in hash_ip4_resize
> * BUG: sleeping function called from invalid context in hash_ipmark4_resi=
ze
> * BUG: sleeping function called from invalid context in hash_ipport4_resi=
ze
> * BUG: sleeping function called from invalid context in hash_ipportnet6_r=
esize
> * BUG: sleeping function called from invalid context in hash_net4_resize
>
> Full report is available here:
> https://ci.syzbot.org/series/60ee40c9-c67a-4d2e-8c5c-7cbc4f2c35e3
>
> ***
>
> BUG: sleeping function called from invalid context in hash_ip4_resize
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      bfa3d89cc15c09f7d1581c834a5ed725189ec19f
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/63302f1b-7561-4e38-b3bc-890b9b65c=
7c1/config
> syz repro: https://ci.syzbot.org/findings/3f7d3e03-c73e-47d2-a969-7c113b0=
94a23/syz_repro
>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:323
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5837, name: syz.0.=
17
> preempt_count: 201, expected: 0
> RCU nest depth: 0, expected: 0
> 2 locks held by syz.0.17/5837:
>  #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/=
netfilter/nfnetlink.c:96 [inline]
>  #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_=
msg+0xa71/0x12c0 net/netfilter/nfnetlink.c:293
>  #1: ffff8881bbd48028 (&t->gc_lock){+...}-{3:3}, at: spin_lock_bh include=
/linux/spinlock.h:348 [inline]
>  #1: ffff8881bbd48028 (&t->gc_lock){+...}-{3:3}, at: hash_ip4_resize+0x14=
9/0x1a80 net/netfilter/ipset/ip_set_hash_gen.h:667
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 0 UID: 0 PID: 5837 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
>  might_alloc include/linux/sched/mm.h:323 [inline]
>  slab_pre_alloc_hook mm/slub.c:4521 [inline]
>  slab_alloc_node mm/slub.c:4876 [inline]
>  __do_kmalloc_node mm/slub.c:5295 [inline]
>  __kvmalloc_node_noprof+0x164/0x8a0 mm/slub.c:6833
>  hash_ip4_resize+0x278/0x1a80 net/netfilter/ipset/ip_set_hash_gen.h:682
>  call_ad+0x562/0xb60 net/netfilter/ipset/ip_set_core.c:1758
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
>  nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb3ded9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb3dfcee028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fb3df015fa0 RCX: 00007fb3ded9ce59
> RDX: 00000000240008c4 RSI: 0000200000000000 RDI: 0000000000000004
> RBP: 00007fb3dee32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb3df016038 R14: 00007fb3df015fa0 R15: 00007ffd0454d2c8
>  </TASK>
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
> CPU: 0 UID: 0 PID: 5837 Comm: syz.0.17 Tainted: G        W           syzk=
aller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
>  register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
>  __lock_acquire+0xad/0x2cf0 kernel/locking/lockdep.c:5112
>  lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:150 [inline]
>  _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:182
>  spin_lock_bh include/linux/spinlock.h:348 [inline]
>  hash_ip4_resize+0x149/0x1a80 net/netfilter/ipset/ip_set_hash_gen.h:667
>  call_ad+0x463/0xb60 net/netfilter/ipset/ip_set_core.c:1758
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
>  nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb3ded9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb3dfcee028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fb3df015fa0 RCX: 00007fb3ded9ce59
> RDX: 00000000240008c4 RSI: 0000200000000000 RDI: 0000000000000004
> RBP: 00007fb3dee32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb3df016038 R14: 00007fb3df015fa0 R15: 00007ffd0454d2c8
>  </TASK>
> Set syz1 is full, maxelem 65536 reached
>
>
> ***
>
> BUG: sleeping function called from invalid context in hash_ipmark4_resize
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      bfa3d89cc15c09f7d1581c834a5ed725189ec19f
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/63302f1b-7561-4e38-b3bc-890b9b65c=
7c1/config
> syz repro: https://ci.syzbot.org/findings/57335612-22e3-4e78-a4ec-3d06321=
de960/syz_repro
>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:323
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5839, name: syz.1.=
18
> preempt_count: 201, expected: 0
> RCU nest depth: 0, expected: 0
> 2 locks held by syz.1.18/5839:
>  #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/=
netfilter/nfnetlink.c:96 [inline]
>  #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_=
msg+0xa71/0x12c0 net/netfilter/nfnetlink.c:293
>  #1: ffff888168150028 (&t->gc_lock){+...}-{3:3}, at: spin_lock_bh include=
/linux/spinlock.h:348 [inline]
>  #1: ffff888168150028 (&t->gc_lock){+...}-{3:3}, at: hash_ipmark4_resize+=
0x13f/0x1ae0 net/netfilter/ipset/ip_set_hash_gen.h:667
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 UID: 0 PID: 5839 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
>  might_alloc include/linux/sched/mm.h:323 [inline]
>  slab_pre_alloc_hook mm/slub.c:4521 [inline]
>  slab_alloc_node mm/slub.c:4876 [inline]
>  __do_kmalloc_node mm/slub.c:5295 [inline]
>  __kvmalloc_node_noprof+0x164/0x8a0 mm/slub.c:6833
>  hash_ipmark4_resize+0x26f/0x1ae0 net/netfilter/ipset/ip_set_hash_gen.h:6=
82
>  call_ad+0x562/0xb60 net/netfilter/ipset/ip_set_core.c:1758
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
>  nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f37dad9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f37dbd30028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f37db015fa0 RCX: 00007f37dad9ce59
> RDX: 00000000040c0080 RSI: 00002000000002c0 RDI: 0000000000000004
> RBP: 00007f37dae32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f37db016038 R14: 00007f37db015fa0 R15: 00007fff6c4f3458
>  </TASK>
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
> CPU: 1 UID: 0 PID: 5839 Comm: syz.1.18 Tainted: G        W           syzk=
aller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
>  register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
>  __lock_acquire+0xad/0x2cf0 kernel/locking/lockdep.c:5112
>  lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:150 [inline]
>  _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:182
>  spin_lock_bh include/linux/spinlock.h:348 [inline]
>  hash_ipmark4_resize+0x13f/0x1ae0 net/netfilter/ipset/ip_set_hash_gen.h:6=
67
>  call_ad+0x463/0xb60 net/netfilter/ipset/ip_set_core.c:1758
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
>  nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f37dad9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f37dbd30028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f37db015fa0 RCX: 00007f37dad9ce59
> RDX: 00000000040c0080 RSI: 00002000000002c0 RDI: 0000000000000004
> RBP: 00007f37dae32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f37db016038 R14: 00007f37db015fa0 R15: 00007fff6c4f3458
>  </TASK>
> Set syz1 is full, maxelem 65536 reached
>
>
> ***
>
> BUG: sleeping function called from invalid context in hash_ipport4_resize
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      bfa3d89cc15c09f7d1581c834a5ed725189ec19f
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/63302f1b-7561-4e38-b3bc-890b9b65c=
7c1/config
> syz repro: https://ci.syzbot.org/findings/79e04816-4100-48fa-8d49-43c546b=
ef2fa/syz_repro
>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:323
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5819, name: syz.2.=
19
> preempt_count: 201, expected: 0
> RCU nest depth: 0, expected: 0
> 2 locks held by syz.2.19/5819:
>  #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/=
netfilter/nfnetlink.c:96 [inline]
>  #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_=
msg+0xa71/0x12c0 net/netfilter/nfnetlink.c:293
>  #1: ffff888116501828 (&t->gc_lock){+...}-{3:3}, at: spin_lock_bh include=
/linux/spinlock.h:348 [inline]
>  #1: ffff888116501828 (&t->gc_lock){+...}-{3:3}, at: hash_ipport4_resize+=
0x13f/0x1ae0 net/netfilter/ipset/ip_set_hash_gen.h:667
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 0 UID: 0 PID: 5819 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
>  might_alloc include/linux/sched/mm.h:323 [inline]
>  slab_pre_alloc_hook mm/slub.c:4521 [inline]
>  slab_alloc_node mm/slub.c:4876 [inline]
>  __do_kmalloc_node mm/slub.c:5295 [inline]
>  __kvmalloc_node_noprof+0x164/0x8a0 mm/slub.c:6833
>  hash_ipport4_resize+0x219/0x1ae0 net/netfilter/ipset/ip_set_hash_gen.h:6=
77
>  call_ad+0x562/0xb60 net/netfilter/ipset/ip_set_core.c:1758
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
>  nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe5c739ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe5c8339028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fe5c7615fa0 RCX: 00007fe5c739ce59
> RDX: 0000000000000090 RSI: 00002000000002c0 RDI: 0000000000000004
> RBP: 00007fe5c7432d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe5c7616038 R14: 00007fe5c7615fa0 R15: 00007ffd329f2868
>  </TASK>
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
> CPU: 1 UID: 0 PID: 5819 Comm: syz.2.19 Tainted: G        W           syzk=
aller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
>  register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
>  __lock_acquire+0xad/0x2cf0 kernel/locking/lockdep.c:5112
>  lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:150 [inline]
>  _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:182
>  spin_lock_bh include/linux/spinlock.h:348 [inline]
>  hash_ipport4_resize+0x13f/0x1ae0 net/netfilter/ipset/ip_set_hash_gen.h:6=
67
>  call_ad+0x463/0xb60 net/netfilter/ipset/ip_set_core.c:1758
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
>  nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe5c739ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe5c8339028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fe5c7615fa0 RCX: 00007fe5c739ce59
> RDX: 0000000000000090 RSI: 00002000000002c0 RDI: 0000000000000004
> RBP: 00007fe5c7432d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe5c7616038 R14: 00007fe5c7615fa0 R15: 00007ffd329f2868
>  </TASK>
>
>
> ***
>
> BUG: sleeping function called from invalid context in hash_ipportnet6_res=
ize
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      bfa3d89cc15c09f7d1581c834a5ed725189ec19f
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/63302f1b-7561-4e38-b3bc-890b9b65c=
7c1/config
> syz repro: https://ci.syzbot.org/findings/8502cd2b-1718-4dd7-8c57-c8f6d49=
4a2b7/syz_repro
>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:323
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5835, name: syz.1.=
18
> preempt_count: 201, expected: 0
> RCU nest depth: 0, expected: 0
> 2 locks held by syz.1.18/5835:
>  #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/=
netfilter/nfnetlink.c:96 [inline]
>  #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_=
msg+0xa71/0x12c0 net/netfilter/nfnetlink.c:293
>  #1: ffff8881114d0028 (&t->gc_lock){+...}-{3:3}, at: spin_lock_bh include=
/linux/spinlock.h:348 [inline]
>  #1: ffff8881114d0028 (&t->gc_lock){+...}-{3:3}, at: hash_ipportnet6_resi=
ze+0x170/0x1eb0 net/netfilter/ipset/ip_set_hash_gen.h:667
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 0 UID: 0 PID: 5835 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
>  might_alloc include/linux/sched/mm.h:323 [inline]
>  slab_pre_alloc_hook mm/slub.c:4521 [inline]
>  slab_alloc_node mm/slub.c:4876 [inline]
>  __do_kmalloc_node mm/slub.c:5295 [inline]
>  __kvmalloc_node_noprof+0x164/0x8a0 mm/slub.c:6833
>  hash_ipportnet6_resize+0x31d/0x1eb0 net/netfilter/ipset/ip_set_hash_gen.=
h:682
>  call_ad+0x562/0xb60 net/netfilter/ipset/ip_set_core.c:1758
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
>  nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f27c6b9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f27c7a44028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f27c6e15fa0 RCX: 00007f27c6b9ce59
> RDX: 0000000000000000 RSI: 00002000000002c0 RDI: 0000000000000004
> RBP: 00007f27c6c32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f27c6e16038 R14: 00007f27c6e15fa0 R15: 00007ffcb0b8a718
>  </TASK>
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
> CPU: 0 UID: 0 PID: 5835 Comm: syz.1.18 Tainted: G        W           syzk=
aller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
>  register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
>  __lock_acquire+0xad/0x2cf0 kernel/locking/lockdep.c:5112
>  lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:150 [inline]
>  _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:182
>  spin_lock_bh include/linux/spinlock.h:348 [inline]
>  hash_ipportnet6_resize+0x170/0x1eb0 net/netfilter/ipset/ip_set_hash_gen.=
h:667
>  call_ad+0x463/0xb60 net/netfilter/ipset/ip_set_core.c:1758
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
>  nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f27c6b9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f27c7a44028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f27c6e15fa0 RCX: 00007f27c6b9ce59
> RDX: 0000000000000000 RSI: 00002000000002c0 RDI: 0000000000000004
> RBP: 00007f27c6c32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f27c6e16038 R14: 00007f27c6e15fa0 R15: 00007ffcb0b8a718
>  </TASK>
>
>
> ***
>
> BUG: sleeping function called from invalid context in hash_net4_resize
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      bfa3d89cc15c09f7d1581c834a5ed725189ec19f
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/63302f1b-7561-4e38-b3bc-890b9b65c=
7c1/config
> syz repro: https://ci.syzbot.org/findings/230cf2b1-2c8b-4558-b095-874702f=
9bc7d/syz_repro
>
> BUG: sleeping function called from invalid context at ./include/linux/sch=
ed/mm.h:323
> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 5814, name: syz.1.=
18
> preempt_count: 201, expected: 0
> RCU nest depth: 0, expected: 0
> 2 locks held by syz.1.18/5814:
>  #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnl_lock net/=
netfilter/nfnetlink.c:96 [inline]
>  #0: ffffffff9a952da0 (nfnl_subsys_ipset){+.+.}-{4:4}, at: nfnetlink_rcv_=
msg+0xa71/0x12c0 net/netfilter/nfnetlink.c:293
>  #1: ffff88816a8df028 (&t->gc_lock){+...}-{3:3}, at: spin_lock_bh include=
/linux/spinlock.h:348 [inline]
>  #1: ffff88816a8df028 (&t->gc_lock){+...}-{3:3}, at: hash_net4_resize+0x1=
68/0x1bb0 net/netfilter/ipset/ip_set_hash_gen.h:667
> Preemption disabled at:
> [<0000000000000000>] 0x0
> CPU: 1 UID: 0 PID: 5814 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  __might_resched+0x378/0x4d0 kernel/sched/core.c:9163
>  might_alloc include/linux/sched/mm.h:323 [inline]
>  slab_pre_alloc_hook mm/slub.c:4521 [inline]
>  slab_alloc_node mm/slub.c:4876 [inline]
>  __do_kmalloc_node mm/slub.c:5295 [inline]
>  __kvmalloc_node_noprof+0x164/0x8a0 mm/slub.c:6833
>  hash_net4_resize+0x26e/0x1bb0 net/netfilter/ipset/ip_set_hash_gen.h:677
>  call_ad+0x562/0xb60 net/netfilter/ipset/ip_set_core.c:1758
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
>  nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe472d9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe473bc7028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fe473015fa0 RCX: 00007fe472d9ce59
> RDX: 0000000004000050 RSI: 0000200000000000 RDI: 0000000000000003
> RBP: 00007fe472e32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe473016038 R14: 00007fe473015fa0 R15: 00007ffcba742758
>  </TASK>
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
> CPU: 1 UID: 0 PID: 5814 Comm: syz.1.18 Tainted: G        W           syzk=
aller #0 PREEMPT(full)
> Tainted: [W]=3DWARN
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  assign_lock_key+0x133/0x150 kernel/locking/lockdep.c:984
>  register_lock_class+0xcc/0x2e0 kernel/locking/lockdep.c:1299
>  __lock_acquire+0xad/0x2cf0 kernel/locking/lockdep.c:5112
>  lock_acquire+0x106/0x350 kernel/locking/lockdep.c:5868
>  __raw_spin_lock_bh include/linux/spinlock_api_smp.h:150 [inline]
>  _raw_spin_lock_bh+0x36/0x50 kernel/locking/spinlock.c:182
>  spin_lock_bh include/linux/spinlock.h:348 [inline]
>  hash_net4_resize+0x168/0x1bb0 net/netfilter/ipset/ip_set_hash_gen.h:667
>  call_ad+0x463/0xb60 net/netfilter/ipset/ip_set_core.c:1758
>  ip_set_ad+0x824/0x9d0 net/netfilter/ipset/ip_set_core.c:1842
>  nfnetlink_rcv_msg+0xc03/0x12c0 net/netfilter/nfnetlink.c:300
>  netlink_rcv_skb+0x232/0x4b0 net/netlink/af_netlink.c:2556
>  nfnetlink_rcv+0x2c0/0x27b0 net/netfilter/nfnetlink.c:667
>  netlink_unicast_kernel net/netlink/af_netlink.c:1319 [inline]
>  netlink_unicast+0x75c/0x8e0 net/netlink/af_netlink.c:1345
>  netlink_sendmsg+0x813/0xb40 net/netlink/af_netlink.c:1900
>  sock_sendmsg_nosec net/socket.c:787 [inline]
>  __sock_sendmsg net/socket.c:802 [inline]
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2698
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2752
>  __sys_sendmsg net/socket.c:2784 [inline]
>  __do_sys_sendmsg net/socket.c:2789 [inline]
>  __se_sys_sendmsg net/socket.c:2787 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2787
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe472d9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe473bc7028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007fe473015fa0 RCX: 00007fe472d9ce59
> RDX: 0000000004000050 RSI: 0000200000000000 RDI: 0000000000000003
> RBP: 00007fe472e32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe473016038 R14: 00007fe473015fa0 R15: 00007ffcba742758
>  </TASK>
> Set syz1 is full, maxelem 65536 reached
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
> [kadlec@netfilter.org netfilter-devel@vger.kernel.org pablo@netfilter.org=
]
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
-upstream-moderation/6a2856e7.39669fcc.33b062.009a.GAE%40google.com.
