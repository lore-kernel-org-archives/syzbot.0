Received: from mail-dl2-f12.google.com (mail-dl2-f12.google.com [74.125.229.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CF813B0AC6
	for <syzbot@lists.linux.dev>; Fri, 25 Sep 2026 09:22:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.229.140
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790328180; cv=pass; b=kjulANKnHscAImEkc/Bp+5/9c5V1rOUGQoAyGt4Vrgjwndza7mb8cFgwYQUn0ZnYBIQ0xtNoJIAnyEhebTQpEB6+c+v1fEyfloqtImHd7itOEFLJJAs0ujfSLjEuBU18+pxy+v2WaRol/AKeGKgTYGMZV2KMlHokeF3YISffpEI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790328180; c=relaxed/simple;
	bh=oIFtNZMUAqnp/7kU5vGkCp30fyS/0VFTIZP6QYkeJVs=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=rSmzkuPr3WMEbnNGJQ2rPvCnXvc6pi00xRGsLzLn/ss5/Y2sUfz/i16rVfRBZPYtMNJk/HKieWP667lIbO1mzK92rZe9AyLTPhJFyq2C1qTQNhOecmQcYTAVMwGGeaid5eDXXMTgFtNO7s26rtV7S7ZabPLhm6xp/C7BiI4mbTw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lrX9sQ2D; arc=pass smtp.client-ip=74.125.229.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lrX9sQ2D"
Received: by mail-dl2-f12.google.com with SMTP id a92af1059eb24-142dd046b87so507747c88.2
        for <syzbot@lists.linux.dev>; Fri, 25 Sep 2026 02:22:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1790328174; cv=none;
        d=google.com; s=arc-20260327;
        b=cCDbbgrt8EC9VEYK6YlNk0oUT7tywV69mGHCDwyJmPI30ffAXS9CmmeiDLjWW6wa00
         5RGWriLlU1QpYP+hd/BGbEVC7lUIduzkU5E3hkMCO+SMds9XVW0UP14NVALq216mqIub
         I6WhD2KhaeGUjDzmVfHwpPNRqftPlQMO9UV5aZHh2GfffcpmhsMCPgfCDEDPmGgyOa9B
         JdWnKByZGv2EMO5eh6866zwKPxKOC3ILR0+gG52t5/uNbF84RjCCKD+JWF4nGOHAgXCn
         0G4E7KN5REbIjMpLbjxUmJupwqEvz72hzqnkpAYTxdN8rzvsGk4PlbXlX2jEau7CwtN+
         zAnQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:dkim-signature;
        bh=FQE7coNnJlJECF4gzKBjMLCjUKke9dqItV9xmEGFRSs=;
        fh=wJW+wjBgeemEVreK/dysTwrTuJmRDHwNn8y+knkgouU=;
        b=oj7Ah9zoszCeTjr2IeJ1bKMywy83p6Eyw4o1ChuB+RQjp87Klk4dMyEHA7kGq+XHbn
         nMEtccAH/CNXQDEf2zR45FINYKBn3fSGZwFi1qdG/hMh2hqZ7uV+E2DU7HHjTu/xsTfx
         MngMgfKWJlsi0U+j0KtMONmn2O32ERwKg3IcKvEQM65hwSaCs0VZrjz/FSTlPRhbpXTN
         seRrAfR32rAzHJEeuzjmb2Bf5bCr/xCprENO91TzX6VsTjc5aAMrVD2TdMDtegdfY5nf
         27L63qqumgd1oJApRi2RDQxujuqCBM6pjl8/Xmm9x/JnqG/+1GlzF1bsvLGaKjUccCt0
         +39w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1790328174; x=1790932974; darn=lists.linux.dev;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=FQE7coNnJlJECF4gzKBjMLCjUKke9dqItV9xmEGFRSs=;
        b=lrX9sQ2DImZXBmbBVUOaI///thE+1ilLTOvRsUr40xUyfM1vxFCYPnEP1weZ4sIGma
         +QTDxYiILjBFxW5fpDvFoLEG/lpX+Ug9MDNyBHAKas7LpntEzRFo+QDfOoT8JzxlyJIY
         WpzAlXe9ygz7MZ5gMq1Vccpf5QI7WyWngniF8uV4xegpBPUt6HgJ8Uo0YUSQYIQMA+WF
         XS7UpxRePmzZU4+nIOLe8g3POBx2eWVpLOuy10n9Yx5x9T2Eqh36gc+SfTzL4Z9HCieC
         qO3rH4zgSzBJBpvsI8w7MlN9H6PBs7979E9DV9RpzWm/ekW8hTdOd7PDHQeAYcH6vOr7
         tNag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790328174; x=1790932974;
        h=content-type:cc:to:subject:message-id:date:from:in-reply-to
         :references:mime-version:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=FQE7coNnJlJECF4gzKBjMLCjUKke9dqItV9xmEGFRSs=;
        b=GJHSmpnOmXCAPukzsFYE7GhwskneAHavd6kHkpjgpsPOONb1BcZJfDsxd1zP2lg1u4
         53vyvPfOuEAk6TOOwWQimw8fXLFC0Bag9Iyn+UV7jwxByNsANbbU9zAXT+o4Of71Je9X
         dBlzr7sbxbFE8/ZOBK1bCiL+FzkOBzzgFA3Wq9sJIi9b3LEvdcsxMOsLs9NcmmQJxROs
         JSltauwMwlPNfkZ8fLMck0BVyFQPpYA6pJhrw5EbLWpiXeaQNY1eH4gzoFSSQWhrbsTM
         MOiT5PU+c2Hp3GKoFf/Ajbnx0oYR1jwTeE86sFIamiJ3OagIk8qk1CbehPR6xIgjY8Us
         4Acg==
X-Forwarded-Encrypted: i=1; AKwUvBzoN8ZqDq6Aam4i8ESTRgnivhPDZjQGgYTqZUgMCtLHRGgQND9xVL22+rri6B0wr12YWM5Wf+A=@lists.linux.dev
X-Gm-Message-State: AFuF++naxSC3+1hyzDbampLhRkDvTOm/3hvC2TqXtkdBZQiFGFH4Rq90
	qe15BnFuxl+Pv/IspBB18b26qrJmz+4Vmf3VMfZAxgpVN+8Tgz5ncnP9FVFkdWfo4nOemW1zh2m
	kme7OMBueJnah+KBT39rGh4eHy99hMstzndm6sFmJ
X-Gm-Gg: AYBFou2/sdQX3lQFol8aOEWcT2YVqgOq+DfTHG71ecSVdVnQZCuRZmlcH2PHJDG31Ol
	8AX+mKXRM+GidaFU1k3GZqPOjQi/Vuhn8KyrWkORNAIW81gWO5L3PyKN1HYwvsX3xSST6oPNq7U
	MkO8o4Ic7imsIlYs6TavR0eNyUoNfdt+0vpriYruGCpBDKDgdmA2eNBILuF0kaZPIw2+54/YyGI
	cOnmVgIwdjt+sLa9js9r/R4V8RyS/Uxep1L4w/GeH8Lk2Sb+yuqOO1altFfbNHfj6akmzhd7TRf
	FUlSJFo55ZAMFPuS5Pt7Os8TzMzCR/f2p7ifOglAtKcOWt3F9SkUfivEK+P/2v3iOodAyczR8BV
	eC3O/6GRGNQ==
X-Received: by 2002:a05:701b:2091:20b0:143:296a:4e58 with SMTP id
 a92af1059eb24-145040941aamr4240762c88.27.1790328171465; Fri, 25 Sep 2026
 02:22:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ab6038d.dc2998a4.2261f5.0040.GAE@google.com>
In-Reply-To: <6ab6038d.dc2998a4.2261f5.0040.GAE@google.com>
From: Marco Elver <elver@google.com>
Date: Fri, 25 Sep 2026 11:22:14 +0200
X-Gm-Features: AclHuK9hKeGd4nD-SnralSROViZ5w94UazqC-iRfr95URhSBP2C_LxD_GX_XOg8
Message-ID: <CANpmjNOswE14F4Xkq=hu_m+bSCgf3_SbnVXvDD+YcPAbgSkV6g@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net/rds: replace tasklets with workqueue
To: syzbot ci <syzbot+ci6b3aed7868f5547c@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"

#syz upstream

On Fri, 25 Sept 2026 at 07:16, syzbot ci
<syzbot+ci6b3aed7868f5547c@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net/rds: replace tasklets with workqueue
> https://lore.kernel.org/all/6b07af04b3ba66a09009e1a0a7b98ec5ec85d3a0.1790109248.git.sunnytiwari@google.com
> * [PATCH net-next] net/rds: replace tasklets with workqueue
>
> and found the following issue:
> WARNING in __alloc_workqueue
>
> Full report is available here:
> https://ci.syzbot.org/series/e7102860-1b25-4e10-b653-afe8e9820ef8
>
> ***
>
> WARNING in __alloc_workqueue
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netdev/net-next.git
> base:      42a9fb3382fc2573e92f41d203b095d9a372cfc9
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~exp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/220e9c3a-eede-449e-8bb1-d34ad95dc867/config
>
> gre: GRE over IPv4 demultiplexer driver
> ip_gre: GRE over IPv4 tunneling driver
> IPv4 over IPsec tunneling driver
> Initializing XFRM netlink socket
> IPsec XFRM device driver
> xfrm_iptfs: IPsec IP-TFS tunnel mode module
> NET: Registered PF_INET6 protocol family
> Segment Routing with IPv6
> RPL Segment Routing with IPv6
> In-situ OAM (IOAM) with IPv6
> mip6: Mobile IPv6
> sit: IPv6, IPv4 and MPLS over IPv4 tunneling driver
> ip6_gre: GRE over IPv6 tunneling driver
> NET: Registered PF_PACKET protocol family
> PFKEY is deprecated and scheduled to be removed in 2027, please contact the netdev mailing list
> NET: Registered PF_KEY protocol family
> Bridge firewalling registered
> NET: Registered PF_X25 protocol family
> X25: Linux Version 0.2
> can: controller area network core
> NET: Registered PF_CAN protocol family
> can: raw protocol
> can: broadcast manager protocol
> can: netlink gateway - max_hops=1
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
> ------------[ cut here ]------------
> workqueue: rds_ib_wq is using neither WQ_PERCPU or WQ_UNBOUND. Setting WQ_PERCPU.
> WARNING: kernel/workqueue.c:5939 at __alloc_workqueue+0x1cd2/0x1fe0, CPU#1: swapper/0/1
> Modules linked in:
> CPU: 1 UID: 0 PID: 1 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:__alloc_workqueue+0x1cd5/0x1fe0
> Code: 0b 90 e9 6d fc ff ff e8 89 02 39 00 e9 7f fb ff ff e8 7f 02 39 00 e9 85 fb ff ff e8 75 02 39 00 48 8d 3d ce 68 ee 0e 4c 89 f6 <67> 48 0f b9 3a 41 81 cf 00 01 00 00 e9 10 e6 ff ff e8 55 02 39 00
> RSP: 0000:ffffc900000676a8 EFLAGS: 00010293
> RAX: ffffffff818ed98b RBX: 0000000000000000 RCX: ffff888102adda00
> RDX: 0000000000000000 RSI: ffff888173f5d170 RDI: ffffffff907d4260
> RBP: ffffffff8d43a5a0 R08: ffff888102adda00 R09: 0000000000000002
> R10: 0000000000000102 R11: 0000000000000000 R12: ffff888173f5d000
> R13: ffff888173f5d000 R14: ffff888173f5d170 R15: 0000000000000018
> FS:  0000000000000000(0000) GS:ffff8882a8cc6000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000000eb48000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  alloc_workqueue_noprof+0xe3/0x210
>  rds_ib_init+0x54/0x190
>  rds_rdma_init+0x74/0x170
>  do_one_initcall+0x250/0x870
>  do_initcall_level+0x10a/0x1a0
>  do_initcalls+0x59/0xa0
>  kernel_init_freeable+0x29d/0x3e0
>  kernel_init+0x22/0x1d0
>  ret_from_fork+0x514/0xb70
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [achender@kernel.org davem@davemloft.net edumazet@google.com horms@kernel.org kuba@kernel.org linux-rdma@vger.kernel.org netdev@vger.kernel.org pabeni@redhat.com rds-devel@oss.oracle.com santosh.shilimkar@oracle.com sunnytiwari@google.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/6ab6038d.dc2998a4.2261f5.0040.GAE%40google.com.
