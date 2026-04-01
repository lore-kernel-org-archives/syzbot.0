Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5170B36606C
	for <syzbot@lists.linux.dev>; Wed,  1 Apr 2026 10:01:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775037691; cv=pass; b=C49uxDuR3NSSVXZoyGkPtfc1rKSRcaTcdmjnM0k0WJJSlMJAPtyiWNWRsIa+ei13swohenHxTZBDD91IofPA2K5aI9p2Ogb5fdTl8zu90ju776qtf+QuSxhFzC1tKOs5w3v+yPqDsjCzeAxTktJB1BYjMrKmmYkqsFHh/AVHTbs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775037691; c=relaxed/simple;
	bh=dJiqk/GDhNDaBQ1+VY0w1EVj772IGGDy2T+H7R8B/8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=khRYR0hw3p6Nz46lc1tKeMlBrhefMtJv6lSItKwvICtOEVF5xLT7iMKSKqZ2d/xuUEsVWA/FNLZKWu1O0R3Q5JXMYp9P1vSbgsI+nXzq792XEeXHoJS0CQn5mVKTU9i75IJrqOsPTm+5Bd8F6NUzNRUSfK3cLdkBA3stXfvnVgE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=It1VvaLL; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="It1VvaLL"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-679b072ed3aso3619476eaf.1
        for <syzbot@lists.linux.dev>; Wed, 01 Apr 2026 03:01:30 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775037689; cv=none;
        d=google.com; s=arc-20240605;
        b=gbDodTfQOiE5OW2Dpw8pP6mSgu3Nu3GIgYySml9ZF5bPYB3aKi/ZlLiutLMDg7ijTH
         sX2dsesIMNAlwOWCIsoybF3g+srnBhuheUOB99VcIZUA7ZB/H3N2+NnZldEbsyouq7fC
         r5x6vbbZUgX1JZr/ZZUTIUzXXKZ4GLC3GbED1v9KHjkV01EKTlgvkNryKyYaTwJdBfDa
         lloku6hUetzRahaCJJ6OKB4HKRcQj/6dsKz1Za9XBJ5awnOFBBTtURm98gfQhQ1TrbhY
         smDlkkroKLRUom/HxOKsKrN2LzUDSQw06Cyi1XuixJ6iCcOzOupOBiRJPyci+vM/SiDb
         19Ew==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=/uBsLGMoegL15CKkRe3l1OUsqm0S1rJn1jFdWpVL9kg=;
        fh=h3IqdwpGoioOCEWIV+8SwEq7IlnSq02M/oVwm7Jj2IU=;
        b=D4p7JO/pwMdFAkvlcUdmwpG9i+CrL1ITXJEMIG4LMs9VxQuA3aH9OSAI8Kq6HqndVC
         YU2NwL9zSJF9vqcrYP9FCsTzVxq6eBOAIX+VdkxMErVayEJGXTpp7WhsG9XsFPyUfmaL
         sJySE/ykB4WkCZp50s/vCrc6zybXZjQOBoOX4s29U19bpClsa4E5aYCW+MrJJbW+ahRR
         5gcCW+D16F2Pg5OKDFITee2pkOmT13vs0e/ScLMh7gJowG5fDA0u0unN577/bKdyPVQN
         4HVVTkUgRFdG+AJYritmHNS0jj6ePe/w17BAch0RIHVi0xaAEj4wkzqgY+9M5dWwgwy8
         R/FA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775037689; x=1775642489; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/uBsLGMoegL15CKkRe3l1OUsqm0S1rJn1jFdWpVL9kg=;
        b=It1VvaLLXjRXk5T7zTO18O3gz5aku64EBgHb52jnke9ZGq820QQTC8kMwT38MQ4hX9
         dqTVQFvXLmqJOwmOZe0L3yzLVJ3o4mFeatTLnxrsBoeiXn5hUDx5o14KZYAKz9W/KTOB
         bL4CPTx+uuhDq6fZxGH4T2ZnnCEnlKkkf/O50/qqaRTkpHcWADb2W6h6yUCo+wAOE2Y7
         n3h+EXgf+qbuZq/6PkiMa0Y5F5al3fEWt9oiFtAkHFn4DNBJ/X4M2Q6ByTsHS6FwQtV9
         v6XTydWnVkKjqmhDIO92XuJpWIdR2oj7jFHvxiSusxOI95NWkdsurBcv9HNXXJr2yYjb
         qCeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775037689; x=1775642489;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=/uBsLGMoegL15CKkRe3l1OUsqm0S1rJn1jFdWpVL9kg=;
        b=h+1odZcXvrRGnY770oKJOpurxPjjygq02wqdrndn61g91EOrJhAPhg/e2rKB6WKPto
         7MmJapniPAu4J8E/1KzSBG6FCXIawtcYb6OIxCAtroTRxebBofffJEbwvudtdSCbHb93
         Zk6hnf/Ok7IBvRy8VSxAIJsumzemHyk+/5lPiA1BXeOqAdXQzidVxQz96AU6ys/hbtxf
         /Bzh0t0kTeB3Z8OjtvXEN3eDassD+OZQcZDPK7Z4cedaHE01S0RtlJa+PxUNn7FLxg20
         1GBk33q5dROgPU60/nYE/WCuNJwixw0TYgYRmDTT2pRznNVqvQb6IDzU4pn0MWtOUHND
         TENw==
X-Forwarded-Encrypted: i=1; AJvYcCVmMQKCT8/mTDCWoxvJzadwSTSQPDAxgU2d5G2VecXd0n7YJNMg0Xj55gScqSNY6js5mpajVfk=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdHcygVP5wXHAZ77c3TIJwabdmdMhuF6KOyS+k4bNL+X+0lN3H
	PhHlW9lk67WZtS9JuFH+k0Y7FfZbzDrpOXRde1NIEFhJGdwd3R3tzBU628Ya+NLPbXCezzT15m/
	vWgdk/0lYRB4XXl8NX09eSXX1Jln7IRHa1qbVpSmN
X-Gm-Gg: ATEYQzwF51TraDwRvO8wNtNFaQtCPPkBfaOne8iliJqBDml1NyJYj68s7+FgbESszze
	4SDbWk+288s1zykDMnwrm3AA8ByLLdSd3szDCczEVSgeRsuamtMQfNB8Rp+Ok0uo7pPRA+blQkr
	eoeRpFuvVAkMSuk7s/Y7jgRhbVhArIg6kETiElqiOaOHtdgVUoEcWLvhwZRt3kgK5mmFeOOO3j9
	6hHx7Sm7uNht9RbqV2NdcNQoNlxBEZX9T1w2bY5c/0gKdSZn2LFRHFg4qtz7cvnXuRg3Jx40eMU
	jJYlLIn6Mfn+Hb+NMeOLQ+eMeImu4JLiW715+ER+h+Vy9J9dbHo9XMQyKBtgbUtbaCFalrmYZoB
	mLgk=
X-Received: by 2002:a05:6820:2288:b0:67c:2458:2120 with SMTP id
 006d021491bc7-67fabbf398dmr1409360eaf.10.1775037688669; Wed, 01 Apr 2026
 03:01:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69ccec46.050a0220.183828.0042.GAE@google.com>
In-Reply-To: <69ccec46.050a0220.183828.0042.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 1 Apr 2026 12:01:16 +0200
X-Gm-Features: AQROBzDarythiUGa70BN28a1FWpSl_vWVYCXS3f1GVo1QYjXgsYYWjIZPD8ukK8
Message-ID: <CANp29Y78oaWJ=jT1Qoc+PbQua-SgBYM6o-n5FBjcJV69PuEN=A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Prep patches for static stack liveness.
To: syzbot ci <syzbot+cif3787361381ccb2b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Apr 1, 2026 at 11:58=E2=80=AFAM syzbot ci
<syzbot+cif3787361381ccb2b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] bpf: Prep patches for static stack liveness.
> https://lore.kernel.org/all/20260401021635.34636-1-alexei.starovoitov@gma=
il.com
> * [PATCH bpf-next 1/6] bpf: Do register range validation early
> * [PATCH bpf-next 2/6] bpf: Sort subprogs in topological order after chec=
k_cfg()
> * [PATCH bpf-next 3/6] selftests/bpf: Add tests for subprog topological o=
rdering
> * [PATCH bpf-next 4/6] bpf: Add compute_const_regs() and prune_dead_branc=
hes() passes
> * [PATCH bpf-next 5/6] bpf: Move verifier helpers to header
> * [PATCH bpf-next 6/6] bpf: Add helper and kfunc stack access size resolu=
tion
>
> and found the following issue:
> UBSAN: array-index-out-of-bounds in do_check
>
> Full report is available here:
> https://ci.syzbot.org/series/3bdef783-321d-4d8d-9fbb-fd61f6cd92d5
>
> ***
>
> UBSAN: array-index-out-of-bounds in do_check
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      0eeb0094ba0321f0927806857b5f01c1577bc245
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/925251e6-c091-44e6-a321-22bd3bffd=
780/config
>
> can: raw protocol
> can: broadcast manager protocol
> can: netlink gateway - max_hops=3D1
> can: SAE J1939
> can: isotp protocol (max_pdu_size 8300)
> Bluetooth: RFCOMM TTY layer initialized
> Bluetooth: RFCOMM socket layer initialized
> Bluetooth: RFCOMM ver 1.11
> Bluetooth: BNEP (Ethernet Emulation) ver 1.3
> Bluetooth: BNEP filters: protocol multicast
> Bluetooth: BNEP socket layer initialized
> Bluetooth: HIDP (Human Interface Emulation) ver 1.2
> Bluetooth: HIDP socket layer initialized
> NET: Registered PF_RXRPC protocol family
> Key type rxrpc registered
> Key type rxrpc_s registered
> NET: Registered PF_KCM protocol family
> lec:lane_module_init: lec.c: initialized
> mpoa:atm_mpoa_init: mpc.c: initialized
> l2tp_core: L2TP core driver, V2.0
> l2tp_ppp: PPPoL2TP kernel driver, V2.0
> l2tp_ip: L2TP IP encapsulation support (L2TPv3)
> l2tp_netlink: L2TP netlink interface
> l2tp_eth: L2TP ethernet pseudowire support (L2TPv3)
> l2tp_ip6: L2TP IP encapsulation support for IPv6 (L2TPv3)
> NET: Registered PF_PHONET protocol family
> 8021q: 802.1Q VLAN Support v1.8
> sctp: Hash tables configured (bind 32/56)
> NET: Registered PF_RDS protocol family
> Registered RDS/infiniband transport
> Registered RDS/tcp transport
> tipc: Activated (version 2.0.0)
> NET: Registered PF_TIPC protocol family
> tipc: Started in single node mode
> smc: adding smcd device lo without pnetid
> NET: Registered PF_SMC protocol family
> 9pnet: Installing 9P2000 support
> NET: Registered PF_CAIF protocol family
> NET: Registered PF_IEEE802154 protocol family
> Key type dns_resolver registered
> Key type ceph registered
> libceph: loaded (mon/osd proto 15/24)
> batman_adv: B.A.T.M.A.N. advanced 2025.5 (compatibility version 15) loade=
d
> openvswitch: Open vSwitch switching datapath
> NET: Registered PF_VSOCK protocol family
> mpls_gso: MPLS GSO support
> IPI shorthand broadcast: enabled
> sched_clock: Marking stable (25300061146, 122105816)->(25454415888, -3224=
8926)
> registered taskstats version 1
> ------------[ cut here ]------------
> UBSAN: array-index-out-of-bounds in kernel/bpf/verifier.c:21704:16
> index 10 is out of range for type 'u32[10]' (aka 'unsigned int[10]')
> CPU: 0 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  ubsan_epilogue+0xa/0x30
>  __ubsan_handle_out_of_bounds+0xe8/0xf0
>  do_check+0x77a1/0x11d50
>  do_check_common+0x21ea/0x2dc0
>  bpf_check+0x242f/0x1cd90
>  bpf_prog_load+0x1484/0x1ae0
>  __sys_bpf+0x618/0x950
>  kern_sys_bpf+0x185/0x700
>  load+0x488/0xad0
>  do_one_initcall+0x250/0x8d0
>  do_initcall_level+0x104/0x190
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x2a6/0x3e0
>  kernel_init+0x1d/0x1d0
>  ret_from_fork+0x51e/0xb90
>  ret_from_fork_asm+0x1a/0x30
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
> [alexei.starovoitov@gmail.com andrii@kernel.org bpf@vger.kernel.org danie=
l@iogearbox.net eddyz87@gmail.com martin.lau@kernel.org memxor@gmail.com]
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
-upstream-moderation/69ccec46.050a0220.183828.0042.GAE%40google.com.
