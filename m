Received: from mail-oa1-f47.google.com (mail-oa1-f47.google.com [209.85.160.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4742B3AA512
	for <syzbot@lists.linux.dev>; Thu,  2 Apr 2026 12:52:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1775134339; cv=pass; b=Gv4b1CxOk8Iv3Tw3mK/N4H7atprzzjkbPdNZWRf7tUMDsb7QjEp/KNvo9nbq/bIRqr8y0Y8d7253LiNGVs1h+m6y1qiM9HM1Ml0z+yVa0Gv1/nPIaiu9A2JyL2+qYprtmbhO8ARHwazhCbyDFPVxUYuBZMu1G6xxmrm+uUulffY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1775134339; c=relaxed/simple;
	bh=1a1RGIbIRB1/ZbEzHirdhTLl3zUbeOy5zB88vVTYDsQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=sGBCo3YE/GyIAXi+/ZANcPkM+/1sBy9LzxLxjfBHKNYqZ/ZQAHl6sexqUzARYsB3jLRS0ZE/SwFRzhx5aQjwbbMIM99VXoaPLDmKsJzS8PnyuKpJELpb9mWa49g/wgjWtAvqAqiFtwJfXGdRS3AtDPmB2Le+f3fsQQwebt0KF+I=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=TvUEAsxW; arc=pass smtp.client-ip=209.85.160.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="TvUEAsxW"
Received: by mail-oa1-f47.google.com with SMTP id 586e51a60fabf-417c34b0509so675572fac.1
        for <syzbot@lists.linux.dev>; Thu, 02 Apr 2026 05:52:13 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1775134332; cv=none;
        d=google.com; s=arc-20240605;
        b=O1mDbVqS+6MCBs4A6t1FzTgcIJWoc+vSrQ/VYxuA+3xN+CseNpVKiuJL20ZIZ7n+rs
         fs+n+8DAKRaI2yLMoghFU+HcVT/RpCHOqNfdOxMgfzkDh24lXMCdLeOrfu0pR2tTPtBg
         Vv0LBVSiL86LhfMy6WnrRjaXZup4MOBUBftdTFuohuXHJldrkHPGOJhDSFCMlr2mtar9
         K8/4GMz1sRCvHH+JQjZBdM/X3KqPO6HlukJUK/d6zbX8LWbtkM7R6tmRquvbl1fGju5y
         XHOFAzvYkL11/zz2HEFOpwwebjw7X2PsAXC5xwew8JZKf+ygPjDJ5C3InGcWSzWkFbgC
         JZ/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=1GXSGYxxUB0T4FcUUz507dQvKBBaCo/2FmSqCKXm8Bw=;
        fh=Y4moI2uzjMlAoEVLWaYOemoe7EdrB6HqZ//xJ6LVeSc=;
        b=Trhg6DAIXiJOWbGrl8G1kAFydzJUfBzycxCIhgssl0ZxnTrJxRUnXaFFQ5ukUMcIBG
         jfnSVZlVH6Ytue7Q08dl5lBDCYJD5rxuLECcvrmYn+0eeZ5DCJcwXN18Wg4NSiq8Yknf
         +KqdS3Kb+R5wHFgf9QNA/FTIqEh7N0TbOw1WejMFNfFwfL7V42jLPaVdjqxREht3aoZW
         qnF7l6zPwt2FBJgS/sxPxb75eJkIT6pxRq0CDIUHnELJbxQWeEGr1xVG2ojCQ4VU0z5D
         DeizsR1TUMZJUMWJfwGi4zcjlyQ3rGNotU3meTWa/GByKiFcgt9b+OfXACc89wBElOVJ
         EVMg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1775134332; x=1775739132; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1GXSGYxxUB0T4FcUUz507dQvKBBaCo/2FmSqCKXm8Bw=;
        b=TvUEAsxWQflgFrg80lNbZ8nDiDnVpo3rKIJ0pBw9Xv03YIXbpR5lL3oAurf2t/vm+X
         ccMfUV0deHNjOB7yXfAUABbujm6a+Jx9DXXoVuk7kUteSStmwqH4784FzCGiPrpr2l13
         9h/B1C+VH0eYJo0TalcaaEGY9+u2SI7Py/k5typdzedOfiIfls+pp0J7+Bxw7cvAgKJK
         9WVNDwnjbMiyCMl5DtwqJf21k8C1V1ZQP3JhTez9hXNU0qmNx/MAaWF/589onLKEiBpS
         rxmKux7US0x2hR0OqAvvVB4M4oTblPCgmeQyZBRd27kQmtVbGX82o2qgmO2lUgkRdLC1
         3q8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1775134332; x=1775739132;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1GXSGYxxUB0T4FcUUz507dQvKBBaCo/2FmSqCKXm8Bw=;
        b=HzGFCp+gM8pOUv3LkOeWV60WnNSAvqx3o2VLshUB7Jr6r+42MkVd9R1OurB8iwG302
         7VO/rKOjjzQW6siYNk3VMs3Z55e6YcJU3pNKgPoM92UimDoW4QQiHkiqxkpmG9+3YMiB
         4h3CTFSJhy9ZF9tEC8EXfNcVML/dYWpX3ayxGisFvMeILQZa7rhE97rQrCuw/ESUsrod
         5fFkYGv+dPEp30VYkPwJsbjMbENM//mjUteq8LhWA6OBg+b0ibdeARVJ1uBIptvxdmmM
         ukBHPJvDyPjfEGYSPHbT6Ax5agoa+MHaz4PG0p3s2YatpUe4Kcv1Ka1Xmn1kEChPLJnE
         hYmQ==
X-Forwarded-Encrypted: i=1; AJvYcCWSZFCew0Q+IHuhIt0HborNIJRWWXR+G30jac+4+spTzUkENAayiOCdYE4oB0ZXMHj5X5vLZzA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxbd/HDMuvbvooB9wcoLevNaQbD/HeNDEXksQ86RCefp765NiUS
	q21YN1ZSy/gF6Ro+7EQwBLcrDLg52Rr5QVp/Qe3gLyTPd1pVDGmnWfhDENRqH9/knSplKYkxlBu
	Qvjyrt53PB1LWsPL/AGxNjpyQ7EnMgob5PFE8WWJxQzF26KaAIc+k2NTp
X-Gm-Gg: ATEYQzyg55wUFspk3SFpvzA4SKxQMd1t066U3PKNxI4k+wm1byKy65YkGR/WfnXIsnT
	NZfUHsrl58k2kZ9E2YA+1LMrA6meiIRVqFbTJ2UoNM1NbcvlWcA/rtdtuwc2Uu/Ig0klyl7JrcH
	WPuIlXfr5jtpzPC70GWs2VL266p7cfHvi+VsiWwu81RqXoY3Z7PwdNARFxAfyKUjrDJizd+VEro
	5xNQQkMhHaqRJFZ66X3WFXlQso+rxstdZY6vfwMZTvAEEJ+3ZaZlmSpVUAZrAbuLDHcaEXUvQhG
	yPR7/icMUPpr9RKGvMZhU5FQ449BcEr0djmKvgJOxs0zixVfHWiDVicGn1ZA23wUlPtkCw==
X-Received: by 2002:a05:6871:2982:b0:40e:dfe2:4256 with SMTP id
 586e51a60fabf-422ec67d366mr1864601fac.14.1775134331991; Thu, 02 Apr 2026
 05:52:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69ce6355.050a0220.182279.0004.GAE@google.com>
In-Reply-To: <69ce6355.050a0220.182279.0004.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 2 Apr 2026 14:52:00 +0200
X-Gm-Features: AQROBzAr-T_V3JimWiyv7t5fwPm3a2_mVa8e7tRYDtrUV2V0qZ3gO1iHSVSH1jE
Message-ID: <CANp29Y7YkLUdU0fCc2fkh95=kD8w66wiu4y5sMn-+SG8Xg308g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Prep patches for static stack liveness.
To: syzbot ci <syzbot+cic39b201f25563d8b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Thu, Apr 2, 2026 at 2:38=E2=80=AFPM syzbot ci
<syzbot+cic39b201f25563d8b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] bpf: Prep patches for static stack liveness.
> https://lore.kernel.org/all/20260402061744.10885-1-alexei.starovoitov@gma=
il.com
> * [PATCH v2 bpf-next 1/6] bpf: Do register range validation early
> * [PATCH v2 bpf-next 2/6] bpf: Sort subprogs in topological order after c=
heck_cfg()
> * [PATCH v2 bpf-next 3/6] selftests/bpf: Add tests for subprog topologica=
l ordering
> * [PATCH v2 bpf-next 4/6] bpf: Add bpf_compute_const_regs() and bpf_prune=
_dead_branches() passes
> * [PATCH v2 bpf-next 5/6] bpf: Move verifier helpers to header
> * [PATCH v2 bpf-next 6/6] bpf: Add helper and kfunc stack access size res=
olution
>
> and found the following issue:
> UBSAN: array-index-out-of-bounds in do_check
>
> Full report is available here:
> https://ci.syzbot.org/series/472db170-a3e5-4e2f-992a-f066f3ec68a0
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
> config:    https://ci.syzbot.org/builds/35679c0d-9085-497b-89c5-d447be366=
fc7/config
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
> sched_clock: Marking stable (24350040289, 119535998)->(24496627492, -2705=
1205)
> registered taskstats version 1
> ------------[ cut here ]------------
> UBSAN: array-index-out-of-bounds in kernel/bpf/verifier.c:21711:16
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
-upstream-moderation/69ce6355.050a0220.182279.0004.GAE%40google.com.
