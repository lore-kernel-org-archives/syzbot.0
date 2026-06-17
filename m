Received: from mail-wm1-f42.google.com (mail-wm1-f42.google.com [209.85.128.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C75243BCD31
	for <syzbot@lists.linux.dev>; Wed, 17 Jun 2026 13:25:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.42
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781702721; cv=pass; b=cge4yFUYyexACYlcvODlxFdMP9TLE7KbR0PgJFAu0qAgdw6rYhdf0eiSwI3idLrvDa+W3UVTiN/ExxPMh1+DcMF6mHAKJYX50pF3x+PuRjbAFh3sPADQPbhbtDcJrygbnT0N+J3Kz029N+wOrSH8FFx01LseemxMHdYuGfhvqdo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781702721; c=relaxed/simple;
	bh=ba68HI929og3vB2RyE6GG+/PhSJYdOQPEfNZjSxZ7F0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=mhWJ9tNSqVjPHHTYiJVqH+oJCy4lQO6vqPPbbRmQJdJ9ciME323K8Wj7niHEVhahvNG9S0T9SLlMBYeeViKphwskKt03O8OlkuWBwahBWAJeBOvxkPdQIgh0VesFY6HbbXwthnUgMWRfP4rBO0DmjH31eGgD6L0A4tg+aG/sUDE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=EWLdWjTa; arc=pass smtp.client-ip=209.85.128.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="EWLdWjTa"
Received: by mail-wm1-f42.google.com with SMTP id 5b1f17b1804b1-490b8ac62baso9496005e9.0
        for <syzbot@lists.linux.dev>; Wed, 17 Jun 2026 06:25:19 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781702718; cv=none;
        d=google.com; s=arc-20240605;
        b=YDP7v+MiUhZ+7LoPazMLm4b08nhrmYuqo6TyruEuWv3+Zsgy8SktjgXnueZS7vl9Bl
         TdzV9bqEvbc0I26g9cyH5jlh682EJkpGMjhYP9vFlB/K3DsMctyAJfr8BB4yI1REmFCQ
         tNhiG1kIuFaux4PhH5UATR+Cn00galqF7eGfqdBVV4NqiE9uXWSRlt17Nr3mTDSM3EaL
         Q1UkxWOLQQ+gsjhXMDLQ43mKTh5+ObtrwyuB97EC74aq+XzJP03QvNbJenAey1+O1ODo
         2cH7vAomt/76TN/PpYKWUxvKbRPRu68vNvrASXf8I6ujdsQnEokwJ1EHxqlJi7XAsrkP
         RPMg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=JWaCotzZqsz9RBLQnz8UHJh6qUkQG2Yp+l2kLNVu+ok=;
        fh=zkuiN/6+SAaJrAdxSrtwQPWKPP/QLWwTxw1GbT6A/5k=;
        b=DPBdYzcbSfbdqE+W1M+TJgg4RpBrF8gywo9I/KWovGd4flzzlFUxgQ4CfFXbNZk2Lh
         GA5SJ24bspK7YBfHtgL2epIvAO+dxD0UuIlz8shHiSK3mTHu4MPUPij3aQYLHnuISd3E
         Y2MXaDT1PAJNpnxxXWvvt5raIuiBAHPNSaoGOdPz9Wcsqz0isonJM7DcyHfQKOatBuFL
         eLYkHvfjmLCoUXKuL4BqHGUuac1sEym03a3brKD3mNaOsG59u6PiU5hkZN9TGFcJ5a+G
         ijgWrJIpR8xR0a5YUhUzt+ZrPoYvyT22F4+8m+ZMktMt3OjXe1xKLZbsXlwAbzrlmCYz
         8UCQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781702718; x=1782307518; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=JWaCotzZqsz9RBLQnz8UHJh6qUkQG2Yp+l2kLNVu+ok=;
        b=EWLdWjTaYrhlLVLbo+Kl2DjZy5sHQjnvjVmHl2EZrCqUau1T6BXRsKVBxYgidIJtUu
         5DsiUJAAxGmOmF5lq4QPUV+MKLbyW/rF+RAJnG6TI7bYt1vaKwaayFp18uaOqCJr62zS
         JaV/IBE6TRu367FxcbAi80Rs1jSzuYwYwPjMyzFYovzHCU2bknR3pnrhzhI0n92FGBvx
         ujzfZ9/DuKkHV0U17HC5ZdwawNc5rZllW+QFJKAkQw9TZMjAFeBtav7EUJ+JL8mxyFaD
         npwFxamd+n5/T2eXekqnmL9smMnBvNWoPbMVQyI2O2VZPhQkHBb0d9MQJn/ZIUwnHuz5
         xyLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781702718; x=1782307518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=JWaCotzZqsz9RBLQnz8UHJh6qUkQG2Yp+l2kLNVu+ok=;
        b=OQ/bGCg8cd4igrhbIr693Wj0QacpR/pk3tZcrigxeXrfKPJVU4oLdPzjqaSb/yUkuk
         aS6sxwNx3GOgsj4/3BAmnuZgPQt3CIHAS10cOS3YUCj94NsXmdtXKiEMuFD9wEyZylzI
         bDn8780QCcmFzSkGaYce3X4Eox5wNjGMJEZeOab4KHDnMMi1cw+l1AfWuNwBZRdzyYTH
         pUCFM1c8urA/yyzPRbbVZwiyYmxonKHsipNQ0extaFlAHaMIUCnIDrn2l8TeHTyOiyjL
         beqmHpQYjd/iiFkgTPvnxzNxvwBlWuBDLn/1ryY6CDDnuPMrnWrTDPJ5UQUoYVF8SuEL
         3nbA==
X-Forwarded-Encrypted: i=1; AFNElJ/MaxZ3zKNds/UaBZlNjMawmrfktFYbPyuZZGdWb8pVqT9mDEDNvcHOIDAhE7o97atW7uApJlk=@lists.linux.dev
X-Gm-Message-State: AOJu0Ywr/5fy6mKsOpiWo8YbVwa4w7pN47vHKicRs4EROZ5O04Z3pikD
	O2GzH9K8SU5YOtZ0ZyKdFyyTtLQbh2dIvL6r0rNoVC0lOM2UEdCzHTmI7TkB+isdlBjYQSgTHhL
	3ov6ioJX1Ox3HMvyQiz96pNagKDys34qz6DxAXaK2SZjZxEn/n136WBdh
X-Gm-Gg: Acq92OEXZR5mysv30heebm9Q9i0oaOtrMMpry9mzQitusWrJl6A9TmoQZTZ6XTKt5iw
	orNnmefjWZJqidxvpHqCIxr/W9QufL7HeefyRWabGheJQiNdq0/ERDW1qNY2nDWxJ6m25BtTWm0
	pv+wEl5iowgQwwVFCg9AfjamjlvLxCGHOnxsfRHQC9bDW/3jN333AU1/JUw5xoS1b2c6nNbQVin
	TRgSXGFSQo1JQHVq5/GUiWBAAchXciApZ3Ubck59fd+ZR55xWX7CmLcu4sh7m+Cm6WamDxrqqKN
	ekXMuDZ2wZWKxlmPwc9PTF3WUXCSYqme3moGPqoRQ43yE9l+WTcC7H4o6EY=
X-Received: by 2002:a05:600c:5020:b0:490:7df7:9190 with SMTP id
 5b1f17b1804b1-492340cb7ebmr46019495e9.8.1781702717151; Wed, 17 Jun 2026
 06:25:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a329fae.8c9cf54e.2a1067.0019.GAE@google.com>
In-Reply-To: <6a329fae.8c9cf54e.2a1067.0019.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Wed, 17 Jun 2026 15:25:05 +0200
X-Gm-Features: AVVi8Cecr8OcJwqxp7fvr68Rsy0e-wWg2l_o1PqpVZMjWtrkx5mzzwkjcVeJKgI
Message-ID: <CAJWNTGxEA+qKRENVr6bwkT+umoqLJCe3wJkWJ_MFcs0u-zLLUA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: netfilter: ipset fixes, second batch
To: syzbot ci <syzbot+ci5897b296438f5356@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Wed, Jun 17, 2026 at 3:22=E2=80=AFPM syzbot ci
<syzbot+ci5897b296438f5356@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] netfilter: ipset fixes, second batch
> https://lore.kernel.org/all/20260617084128.6603-1-kadlec@netfilter.org
> * [PATCH v3 1/7] netfilter: ipset: Don't use test_bit() in lockless RCU r=
eaders in hash types
> * [PATCH v3 2/7] netfilter: ipset: Don't use test_bit() in lockless RCU r=
eaders in bitmap types
> * [PATCH v3 3/7] netfilter: ipset: fix order of kfree_rcu() and rcu_assig=
n_pointer()
> * [PATCH v3 4/7] netfilter: ipset: exlude gc when resize is in progress
> * [PATCH v3 5/7] netfilter: ipset: make sure gc is properly stopped
> * [PATCH v3 6/7] netfilter: ipset: cleanup the add/del backlog when resiz=
e failed
> * [PATCH v3 7/7] netfilter: ipset: rework cidr bookkeeping
>
> and found the following issues:
> * INFO: trying to register non-static key in hash_ipportip6_resize
> * INFO: trying to register non-static key in hash_netport6_resize
> * INFO: trying to register non-static key in hash_netportnet6_resize
>
> Full report is available here:
> https://ci.syzbot.org/series/7264660b-3f58-4809-9af0-c77ead1aac16
>
> ***
>
> INFO: trying to register non-static key in hash_ipportip6_resize
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      3b165c2a29cfb6453f26e1ac833ca6afd28d28cf
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/44611eeb-52b4-4b97-8744-2265cbb06=
3fa/config
> syz repro: https://ci.syzbot.org/findings/c1aaddfd-5ff4-410d-85fa-3c21255=
2d465/syz_repro
>
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
> CPU: 0 UID: 0 PID: 5810 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
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
>  hash_ipportip6_resize+0x4d4/0x1dd0 net/netfilter/ipset/ip_set_hash_gen.h=
:699
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
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2699
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2753
>  __sys_sendmsg net/socket.c:2785 [inline]
>  __do_sys_sendmsg net/socket.c:2790 [inline]
>  __se_sys_sendmsg net/socket.c:2788 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2788
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4ef2b9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f4ef3b42028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f4ef2e15fa0 RCX: 00007f4ef2b9ce59
> RDX: 0000000000000000 RSI: 00002000000002c0 RDI: 0000000000000004
> RBP: 00007f4ef2c32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4ef2e16038 R14: 00007f4ef2e15fa0 R15: 00007ffd926dea58
>  </TASK>
>
>
> ***
>
> INFO: trying to register non-static key in hash_netport6_resize
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      3b165c2a29cfb6453f26e1ac833ca6afd28d28cf
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/44611eeb-52b4-4b97-8744-2265cbb06=
3fa/config
> syz repro: https://ci.syzbot.org/findings/60d79dbd-6e73-4ee8-be39-8bea69c=
b5f52/syz_repro
>
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
> CPU: 0 UID: 0 PID: 5834 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
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
>  hash_netport6_resize+0x548/0x1d30 net/netfilter/ipset/ip_set_hash_gen.h:=
699
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
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2699
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2753
>  __sys_sendmsg net/socket.c:2785 [inline]
>  __do_sys_sendmsg net/socket.c:2790 [inline]
>  __se_sys_sendmsg net/socket.c:2788 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2788
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5c11d9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5c113dd028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f5c12016090 RCX: 00007f5c11d9ce59
> RDX: 0000000000000090 RSI: 00002000000002c0 RDI: 0000000000000004
> RBP: 00007f5c11e32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5c12016128 R14: 00007f5c12016090 R15: 00007ffd4124a0a8
>  </TASK>
>
>
> ***
>
> INFO: trying to register non-static key in hash_netportnet6_resize
>
> tree:      nf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netfi=
lter/nf-next.git
> base:      3b165c2a29cfb6453f26e1ac833ca6afd28d28cf
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/44611eeb-52b4-4b97-8744-2265cbb06=
3fa/config
> syz repro: https://ci.syzbot.org/findings/a0e027e2-8833-4fe6-8f75-2f38868=
2c035/syz_repro
>
> INFO: trying to register non-static key.
> The code is fine but needs lockdep annotation, or maybe
> you didn't initialize this object before use?
> turning off the locking correctness validator.
> CPU: 0 UID: 0 PID: 5880 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
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
>  hash_netportnet6_resize+0x5aa/0x2040 net/netfilter/ipset/ip_set_hash_gen=
.h:699
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
>  ____sys_sendmsg+0x972/0x9f0 net/socket.c:2699
>  ___sys_sendmsg+0x2a5/0x360 net/socket.c:2753
>  __sys_sendmsg net/socket.c:2785 [inline]
>  __do_sys_sendmsg net/socket.c:2790 [inline]
>  __se_sys_sendmsg net/socket.c:2788 [inline]
>  __x64_sys_sendmsg+0x1bd/0x2a0 net/socket.c:2788
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f9c00b9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f9c01a82028 EFLAGS: 00000246 ORIG_RAX: 000000000000002e
> RAX: ffffffffffffffda RBX: 00007f9c00e15fa0 RCX: 00007f9c00b9ce59
> RDX: 0000000000000000 RSI: 00002000000002c0 RDI: 0000000000000004
> RBP: 00007f9c00c32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f9c00e16038 R14: 00007f9c00e15fa0 R15: 00007ffe8ca45b58
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
-upstream-moderation/6a329fae.8c9cf54e.2a1067.0019.GAE%40google.com.



--=20
Pimyn Girgis - =E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=
=B2=84=E2=B2=89=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
