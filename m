Received: from mail-oi1-f171.google.com (mail-oi1-f171.google.com [209.85.167.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C28E9280A5B
	for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 19:21:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762802503; cv=none; b=E2vRQkvWkmwyvp7rXJY9MqYQx93RrsR7z6PxGExAaT0oFiIrt62x3evAKvFNHTW958DYfQEVTA6Qm9Y4rUK+G14pypy/NT5Q1+kaf2psYpLAa4EKMaqXTXgYLuat14VQuz9VDOcEB2OWmdGVqe/a7s2/7q9m5Lr/6QXgIJzf1a0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762802503; c=relaxed/simple;
	bh=rBOea6ibfsqZfIG+CaLvMbm/tdGhHqXADUgAqb1zXCA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=eJWlL9W4tCRWJKK/QN8VkpEXPsJzAmNGvPe2jBlReHwknkJkzoYQfNdbycn+aeHHZs00AwJPGCZit5QO6ngDZvnh2Yrd0sckSmPQvAURxp8E3pqBs+bYsBCuLIn/XUI7514tCYtih1r095DFGaTuhMYZ503gbc70NLJnXdvXr74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=S/s2d10Q; arc=none smtp.client-ip=209.85.167.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="S/s2d10Q"
Received: by mail-oi1-f171.google.com with SMTP id 5614622812f47-4505b05e7b5so199325b6e.2
        for <syzbot@lists.linux.dev>; Mon, 10 Nov 2025 11:21:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762802501; x=1763407301; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=mULdltQW0HWw1CgKXGaBjp2oNLn40Cw+BKI49RHPGeI=;
        b=S/s2d10Qz1XxyyPAJadki6+jYqABSptwqSgZCm71r3bGpfPpoXVUMLgSkEAKav+aXF
         4syo6wGRDKEp14zkGJLpeJypWU6b1dbcKVxk7pLU74EQcqhxmakEGeK51ztiRPjCjSrr
         XdQ4xjYQACP7Ry7qce25xmBF0JjtiY2RgJ3/gHGgeha1+rj3uwYvO9r6jf6+BwcdaMkP
         drPOTSA5JX6u+uYPioDIDr5jVV5++KGl17xJKmdm0Q04tS5aM91eK4JOJ50ZJ1euEbgL
         KvLNof4aNRtC+XsZRdzRN1msiWidAgpSCkxyq3U3O1HUEzYp0JgxuHfFNOWKNnam2yw6
         7TnQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762802501; x=1763407301;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=mULdltQW0HWw1CgKXGaBjp2oNLn40Cw+BKI49RHPGeI=;
        b=PiqVewdJWvIXps3f5lVLUOHmHNWC+tox96uJFQIJlAMDM7iI1eEMnbRiJgUqsIlJ9M
         yL3rvRbFXKILrCqykwPHKiIfZ2xMYTbiZltL4WNE95GHHhB4Of3uX+q9Lhamg5esfdHf
         TVe6CUeEGT9DRQPbGO+xska7y26+Tj1+LyZMpVL3Jz3SaRwyLI5ExS2TsHx71JKqavkL
         ljkDQ15tfcgwU/zV+LX1UvO91wRsaRN220Gc4QanxadV9t2+9cs8aZPWEs+Cu8xpVFnV
         48lyAXRXHlCrgw/ZTzweyxlYkG1dBnEaY6K0mlCqLzkgOE9/hjaYommTsSHPA2D1GSiE
         MNPw==
X-Forwarded-Encrypted: i=1; AJvYcCVVFxxltYBxkOUp8djgB4EkQblKkHEp8yB5Is8ijafkdAMDZWoePWorfHaJT5JOQAhD9/33ifU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqYnWIQ+xOKEr3GMkmjRdLhBe/wkatoXrAQJJXxtsw7qq6WpsA
	ccxadBs3n9jbkd+XhS0+w5S3O6uGR0q43lXcbmWAx5pikfuTsM4Y6J6Cvh2ugESYvlX04S4+YVi
	9VzZzAp1s4vrTatn52FW04vq11W15dtC6k8xucNaY+1nOHgDPiRJuyKz+
X-Gm-Gg: ASbGncuoJCbDWIOYysDHcV6Xwn8u/bSVeyj6MG4JHqMfkZfzxp9KB2TAwUMDf1bWxoV
	KI5zqUHnnwDE56KjMYwFNr1Kexm9HvwEvHs3GOThNXCp/B2Ymy8bD0RAt4oqL9KzLScskCfPuIA
	sd3XEui9L95SE2o87EIKnOwkm4Fb8qjeIuYnn4fcZGta64/0XwdLkJem04afIRZgjsdxofKzJkE
	zSxYd4RB1zviYmw8+EtOMunTog1z0gYHXh8j28qU05dx0U8aBHmmRKFNnbEdTz23/V5+f0VAYtg
	+b83m1OcGWvqGLTXnHLz+Otfv+2wnjYqgeQwNDkj9Mt+dFti8wbCa2eSi5A=
X-Google-Smtp-Source: AGHT+IEtxTae8+e5U/7cPFZXRqU6MIG1Q2gEwZkyCE9Va9678RBWZEigkf2zkogH3rei0b2RZstsfauJT4PaHDUDwcI=
X-Received: by 2002:a05:6808:4f07:b0:44f:e61d:18a5 with SMTP id
 5614622812f47-4502a3a6836mr4730126b6e.46.1762802500580; Mon, 10 Nov 2025
 11:21:40 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69123685.a70a0220.22f260.0102.GAE@google.com>
In-Reply-To: <69123685.a70a0220.22f260.0102.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 10 Nov 2025 20:21:29 +0100
X-Gm-Features: AWmQ_bkFc1zOD5sAFsaTVKM5cXC1HDe7br0FJ6gBbsmdC7qClSRN901ojfgc_3M
Message-ID: <CANp29Y5Hf+HFXXJ5YDgATd4mM0JnVQCJsdGxd5dSA0WGtQs6tQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: make vmalloc gfp flags usage more apparent
To: syzbot ci <syzbot+ci42f6f492df103093@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Nov 10, 2025 at 8:01=E2=80=AFPM syzbot ci
<syzbot+ci42f6f492df103093@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] make vmalloc gfp flags usage more apparent
> https://lore.kernel.org/all/20251110160457.61791-1-vishal.moola@gmail.com
> * [PATCH 1/4] mm/vmalloc: warn on invalid vmalloc gfp flags
> * [PATCH 2/4] mm/vmalloc: Add a helper to optimize vmalloc allocation gfp=
s
> * [PATCH 3/4] mm/vmalloc: cleanup large_gfp in vm_area_alloc_pages()
> * [PATCH 4/4] mm/vmalloc: cleanup gfp flag use in new_vmap_block()
>
> and found the following issue:
> WARNING: kmalloc bug in bpf_prog_alloc_no_stats
>
> Full report is available here:
> https://ci.syzbot.org/series/488ab7c0-de91-4749-bbb2-ca76c3fb798b
>
> ***
>
> WARNING: kmalloc bug in bpf_prog_alloc_no_stats
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      02dafa01ec9a00c3758c1c6478d82fe601f5f1ba
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/2334ae39-552d-4ca2-8562-7adc18ce2=
cb0/config
>
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
> batman_adv: B.A.T.M.A.N. advanced 2025.4 (compatibility version 15) loade=
d
> openvswitch: Open vSwitch switching datapath
> NET: Registered PF_VSOCK protocol family
> mpls_gso: MPLS GSO support
> IPI shorthand broadcast: enabled
> sched_clock: Marking stable (21550045890, 115271513)->(21677757748, -1244=
0345)
> registered taskstats version 1
> ------------[ cut here ]------------
> Unexpected gfp: 0x100000 (__GFP_HARDWALL). Fixing up to gfp: 0xdc0 (GFP_K=
ERNEL|__GFP_ZERO). Fix your code!
> WARNING: CPU: 1 PID: 1 at mm/vmalloc.c:3936 vmalloc_fix_flags+0x9c/0xe0
> Modules linked in:
> CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:vmalloc_fix_flags+0x9c/0xe0
> Code: 81 e6 1f 52 fe ff 89 74 24 30 81 e3 e0 ad 01 00 89 5c 24 20 90 48 c=
7 c7 80 b9 76 8b 4c 89 fa 89 d9 4d 89 f0 e8 85 31 6e ff 90 <0f> 0b 90 90 8b=
 44 24 20 48 c7 04 24 0e 36 e0 45 4b c7 04 2c 00 00
> RSP: 0000:ffffc90000066d60 EFLAGS: 00010246
> RAX: 50a201fad922ca00 RBX: 0000000000000dc0 RCX: ffff888160a80000
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
> RBP: ffffc90000066df8 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffffbfff1bba678 R12: 1ffff9200000cdac
> R13: dffffc0000000000 R14: ffffc90000066d80 R15: ffffc90000066d90
> FS:  0000000000000000(0000) GS:ffff8882a9f32000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000000dd38000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __vmalloc_noprof+0xf2/0x120
>  bpf_prog_alloc_no_stats+0x4a/0x4d0
>  bpf_prog_alloc+0x3c/0x1a0
>  bpf_prog_load+0x735/0x19e0
>  __sys_bpf+0x507/0x860
>  kern_sys_bpf+0x17d/0x6b0
>  load+0x39e/0x940
>  do_one_initcall+0x236/0x820
>  do_initcall_level+0x104/0x190
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x334/0x4b0
>  kernel_init+0x1d/0x1d0
>  ret_from_fork+0x4bc/0x870
>  ret_from_fork_asm+0x1a/0x30
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
> [akpm@linux-foundation.org hch@infradead.org hch@lst.de linux-kernel@vger=
.kernel.org linux-mm@kvack.org urezki@gmail.com vishal.moola@gmail.com]
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
-upstream-moderation/69123685.a70a0220.22f260.0102.GAE%40google.com.
