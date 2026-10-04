Received: from mail-oa2-f12.google.com (mail-oa2-f12.google.com [74.125.231.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A2C73F660F
	for <syzbot@lists.linux.dev>; Sun,  4 Oct 2026 20:02:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.76
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791144154; cv=pass; b=VYyRP1Sniw9O/fyvz1ypVcxY2NFOPNFuCphqLw1JpTIx7y6c4ZeHg0MGKUHyWDK+Wu98oupN4aunemvPrGuKeIAOIwklkO2XbrcWDil1+s8KoGGNYUXDAaK7V73EtLoVdgZEmTXIA0ufh+Ve8456BUPY5B45xpUp8Dlvf7Jsyvs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791144154; c=relaxed/simple;
	bh=JIM4qcgxCjAtIhutKUtP8hnfV6kRVsAhiLQy+m6/Vlk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=epnWaQNk6FqBX9vMeCzNDz4MK8/7+xezbpSMtcGtL3L9AKuDcU0dT3Fe8vGwbgEaZCsMnC40mZ5LWF3vWXTWUzC4KGagOQ+bb9gexPpOGjJRZPevp5x5Wxz4kLBebtmYh+hcp6hJwqZjN8M01cPRi87CCRSLGbkXZrx6bKu8kPE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=mBABIeky; arc=pass smtp.client-ip=74.125.231.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="mBABIeky"
Received: by mail-oa2-f12.google.com with SMTP id 586e51a60fabf-47c57070c52so222890fac.0
        for <syzbot@lists.linux.dev>; Sun, 04 Oct 2026 13:02:31 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1791144151; cv=none;
        d=google.com; s=arc-20260327;
        b=mSdGQ/CHCDu+tx7kr0cUrE4JpPD0+UE/MPKhExwap+3q8ut1pwyPu+zfL+wEnxlW/w
         RYt81ZyIr9aF8YTUOZWmp6f/4UV1mKVqvHzvmQ2Y9TwEDS1xm29LmrJ9TSfzDUqaV1FD
         fgl0942yyx9DSfChsZPlVq2/HN+18MfmOWLppAoSxiD6Nk6DLK5O7szTZ36X1WdJ0Gcz
         oJl9GN13FO5LOaOR7knsipubivesDFAIJhDcVaBvJ0WeH72WOISTA5H3DMN6MxmPaS2E
         1pR+jTJu4SeD5bf9h/2DCOvrG5RXQal3kz1VeEUaP9vVpkwp+0ewS0z/jhapMw6ng8uQ
         npUg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZPkBEUjztm5pP9+v2qENJD2LnGWE/Y0mVx3FL1DCtT0=;
        fh=MfKKWakUXnnBTl8EUcYyLc9oF5W2RftrauWWMXmcosM=;
        b=ehYL35m8gnqisQz/YdKG8vh7yKHrWQrK/al9vE7rwlTR0NciSyuIqCL/80Kl0oRz55
         oJSxJJZWuq5Ql494A4YTCMR9eYm19Js/LZL/adqVHl2M02MAwQRiGWsYZLtgQ93ig+As
         AO3c7+624mtVZS+vXKvJMMKvs3QZii5Qf8fzjGwPwnN8vHP5XVTHZr4GssgD5xzu5w6X
         uQE8nFfYLiDFAp6c8NGjRdloPKgOFwtXMiMLcffLkqCNl4aYaAQ7gSdp52DWg7Z3ZEk/
         /BA0aWfD3DEONJ+9he0hmhQTgS/E97mhj98SSBIVuPYKvwEvmxUIq5ealMNHzCwEWS3Z
         1f6Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1791144151; x=1791748951; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=ZPkBEUjztm5pP9+v2qENJD2LnGWE/Y0mVx3FL1DCtT0=;
        b=mBABIekyF+jONuXlCowRIwPLCIK7v2ISWRb5mCglmmrezp5XzF2WTstpA3BWj9w2DW
         ljkEeX7ei0R6H/pg++KfXbkMeU+kJLxrgDIkvL+X1sDDiti8GZLGZCJ65gaKEWFDQpiM
         j5eeFu3jnJ/Y3S8pGXQ67bXSJbXJ/wLpYt1ME3PHIAOJQ1gb+p7UGFawF/FpzM8reTBx
         jYeM67taj6HCUasChjTw5TAaeD7kAjOrx44wANK3cl010MasPPgIpaitC2MXJnz61VKo
         pw+MAS9A0fNdv0Bu9w7SWhOsClGI2aoN+2Fzb0+oX59ggoGetURpws33omkhSze/frIw
         01dw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791144151; x=1791748951;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZPkBEUjztm5pP9+v2qENJD2LnGWE/Y0mVx3FL1DCtT0=;
        b=CsuSsWzl7pC1qOABKZOTlq9fN8Dwlxp+65sqgPZs2Aatv85LVbBMoc1oU95CcIpXy4
         zVVxDe8Ybro8m2ct8YUQYPKGD2G0WHjuH9zh4mfgze0TVLXvrWf2NW0+Bwp80ZTnrAz1
         slUeavbkWZRc5DtQB+X3voB/fGyNhPqLZtHL9Ufjg7HsUkH8EwoexAok99GwfVpM1zjF
         fb1NVHGo483QuCkSLCEHGGYJOxrscE45klbSxazV9hyrVdYcJeeAzjUVgzuc9W00xz9s
         317LIXwfLdC12XlsbtP8LDY6BTS00IrhEUttHyUM1WdTegetdrnD3O8Cm/XYLJyS4t+E
         JjtA==
X-Forwarded-Encrypted: i=1; AKwUvByqowlvK7gl/KJpeYrxPESor/qzo+Zmc4Sx+AWsuhD8MEO8+bxL7Kl90xPyHEF6CpBMs0gfjkA=@lists.linux.dev
X-Gm-Message-State: AFuF++lEQb6AxWeG8hNIJE5ZnPD9wKu6Z9Tgsu8nuQvhbKJfo58m17vC
	M0s4whY0puxZXfEz/upWuuMAmmNSVBpBLK//VOmolj83WudVnw53Qi3aqHUhRoa0WeHOvKGA2Lc
	rqdZtjYzD47koF3Dy6qLjwM1SkiArtsqSNVBNx2vy
X-Gm-Gg: AYBFou3ZNdAsH3qGXgMmHpbE2aKAQUZXtzcV9Tk1oVtKJesdxabtxjSfaZbMmPFQTFP
	b7dacmKKtV4Kj+ZiE3M5YY9cbsMvLGGmDM+werS3HwdFgRY90Jg0Y6zc3VCY6K4iAajHzYr94oj
	CiEkLfe5CBL1Qh9zobnK3GGIebNHWfDPv0dA1Z5p9neo64nwRTbCdxI/shnJ7bqu9mH+cwtt16u
	PFk74G47Pn7u4pEV5Gr++8M8rsdVfTqgnI/GEOg1QSU8+dchO6WF1+NzDx8N5fcJWyS32/lRmnz
	4VMt7bFx1PWXZF9FLB1Fjzwx4LPZaZTfQPfQyG8BwD+ud9Yk+P0bo5dQ+2uw9y0e/GH6C5zEBLT
	IoC6YnYg1bAXTKafyxNPnjsldyozjccaMN4jLnR9O+QxRsUS4tis3IiJNR/7ZkX8oUUXg
X-Received: by 2002:a05:6820:7089:10b0:6b4:117e:545 with SMTP id
 006d021491bc7-6df32aa8240mr3868544eaf.13.1791144150165; Sun, 04 Oct 2026
 13:02:30 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6ac28fc6.a58718c8.226e00.0002.GAE@google.com>
In-Reply-To: <6ac28fc6.a58718c8.226e00.0002.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 4 Oct 2026 22:02:19 +0200
X-Gm-Features: AclHuK_wIERKf0DnyaZnsTZf1Lwnlhlhwbb-nm6aileAstmILb_SQwE4dT4iqvI
Message-ID: <CANp29Y6ozw2QYxG5+WD4e2wFPpKpg0VCyiWohGvoh0wbvwt2LQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: use scalar evolution to widen bounded loops
To: syzbot ci <syzbot+ci94ba2fc855ffd21e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Oct 4, 2026 at 7:41=E2=80=AFPM syzbot ci
<syzbot+ci94ba2fc855ffd21e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] bpf: use scalar evolution to widen bounded loops
> https://lore.kernel.org/all/20261004-scev-minimal-rebase-v2-0-f6254e29fdf=
2@gmail.com
> * [PATCH bpf-next v2 01/43] bpf: represent stack access effects with arg_=
access_info
> * [PATCH bpf-next v2 02/43] bpf: describe helper stack accesses with arg_=
access_info
> * [PATCH bpf-next v2 03/43] bpf: describe kfunc stack accesses with arg_a=
ccess_info
> * [PATCH bpf-next v2 04/43] bpf: track may_write flags in liveness
> * [PATCH bpf-next v2 05/43] bpf: summarize may write stack slots in insn_=
aux_data
> * [PATCH bpf-next v2 06/43] bpf: summarize live stack slots in insn_aux_d=
ata
> * [PATCH bpf-next v2 07/43] bpf: summarize regs that may hold a frame poi=
nter in insn_aux_data
> * [PATCH bpf-next v2 08/43] bpf: record write effects for atomic operatio=
ns in liveness.c
> * [PATCH bpf-next v2 09/43] bpf: add tnum_alignment()
> * [PATCH bpf-next v2 10/43] bpf: add cnum{32,64}_union()
> * [PATCH bpf-next v2 11/43] bpf: add cnum64_intersect_linear()
> * [PATCH bpf-next v2 12/43] bpf: expose comparison opcode transformations
> * [PATCH bpf-next v2 13/43] bpf: allow subrange relations for PTR_TO_STAC=
K in regsafe()
> * [PATCH bpf-next v2 14/43] bpf: representation for intervals with steps
> * [PATCH bpf-next v2 15/43] bpf: varying offset access support for PTR_TO=
_BTF_ID pointers
> * [PATCH bpf-next v2 16/43] bpf: save DFS postorder numbers for program i=
nstructions
> * [PATCH bpf-next v2 17/43] bpf: move the live-register and SCC printout =
to a standalone function
> * [PATCH bpf-next v2 18/43] bpf: compute immediate dominators
> * [PATCH bpf-next v2 19/43] bpf: compute loop hierarchy
> * [PATCH bpf-next v2 20/43] bpf: add bpf_set_reg_range()
> * [PATCH bpf-next v2 21/43] bpf: add bpf_mark_reg_known_scalar()
> * [PATCH bpf-next v2 22/43] bpf: add bpf_reg_union()
> * [PATCH bpf-next v2 23/43] bpf: add a min-heap for ordered analysis work=
lists
> * [PATCH bpf-next v2 24/43] bpf: record basic-block ends in insn_aux_data
> * [PATCH bpf-next v2 25/43] bpf: add bpf_split_cur_state()
> * [PATCH bpf-next v2 26/43] bpf: add bpf_same_memory_origin()
> * [PATCH bpf-next v2 27/43] bpf: allow precision backtracking between ove=
rlapping checkpoints
> * [PATCH bpf-next v2 28/43] bpf: compute scalar evolution expressions for=
 loops
> * [PATCH bpf-next v2 29/43] bpf: use SCEV to widen bounded loops
> * [PATCH bpf-next v2 30/43] bpf: avoid widening registers that hinder exa=
ct stack-slot tracking
> * [PATCH bpf-next v2 31/43] bpf: bpf_func_state size optimization
> * [PATCH bpf-next v2 32/43] selftests/bpf: __msg_next tag for matching me=
ssages on consecutive lines
> * [PATCH bpf-next v2 33/43] selftests/bpf: bound UNIX socket path loops b=
y sun_path size
> * [PATCH bpf-next v2 34/43] selftests/bpf: test for stack-pointer subrang=
e pruning
> * [PATCH bpf-next v2 35/43] selftests/bpf: tests for may_write stack-live=
ness tracking
> * [PATCH bpf-next v2 36/43] selftests/bpf: tests for may_def marks of ato=
mic RMW operations
> * [PATCH bpf-next v2 37/43] selftests/bpf: tests for map special cases in=
 bpf_helper_stack_access_bytes()
> * [PATCH bpf-next v2 38/43] selftests/bpf: tests for register base/step a=
rithmetic
> * [PATCH bpf-next v2 39/43] selftests/bpf: tests for register base/step s=
tate pruning
> * [PATCH bpf-next v2 40/43] selftests/bpf: tests for varying offset acces=
s to PTR_TO_BTF_ID
> * [PATCH bpf-next v2 41/43] selftests/bpf: tests for loop hierarchy compu=
tation
> * [PATCH bpf-next v2 42/43] selftests/bpf: tests for immediate dominator =
computation
> * [PATCH bpf-next v2 43/43] selftests/bpf: tests for SCEV analysis and lo=
op widening
>
> and found the following issue:
> general protection fault in bpf_compute_scev
>
> Full report is available here:
> https://ci.syzbot.org/series/ff81cb40-7952-4f8a-b785-1f9e875f9b1f
>
> ***
>
> general protection fault in bpf_compute_scev
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      99dc1ba542420db6b8df209744f55cc52466ad91
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/a6050598-290a-4e4f-bba8-55721490a=
3a8/config
> syz repro: https://ci.syzbot.org/findings/63885d0d-bef7-464a-9e39-0d57d15=
cba85/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 UID: 0 PID: 5853 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:compute_insn_scevs kernel/bpf/scev.c:1489 [inline]
> RIP: 0010:bpf_compute_scev+0x5482/0x6050 kernel/bpf/scev.c:1569
> Code: 24 08 30 04 00 00 49 81 c7 30 04 00 00 45 31 ed 48 8b 44 24 10 4e 8=
d 34 a8 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84=
 c0 0f 85 af 00 00 00 41 8b 16 48 89 df 31 f6 48 8b
> RSP: 0018:ffffc9000372f6e0 EFLAGS: 00010247
> RAX: 0000000000000000 RBX: ffff8881144bad00 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000011 RDI: 0000000000000011
> RBP: ffffc9000372f910 R08: ffff888101bd0000 R09: 0000000000000004
> R10: 000000000000010f R11: 0000000000000000 R12: 0000000000000011
> R13: 0000000000000000 R14: 0000000000000004 R15: 0000000000000430
> FS:  00007fd0dc1f56c0(0000) GS:ffff88818d6b6000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd0db270050 CR3: 00000001bf29a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  bpf_check+0x2fbe/0x3550 kernel/bpf/verifier.c:23332
>  bpf_prog_load+0x1594/0x1d60 kernel/bpf/syscall.c:3177
>  __sys_bpf+0xd86/0xe00 kernel/bpf/syscall.c:6437
>  __do_sys_bpf kernel/bpf/syscall.c:6559 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6556 [inline]
>  __x64_sys_bpf+0xba/0xd0 kernel/bpf/syscall.c:6556
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fd0db39e159
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fd0dc1f5028 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007fd0db625fa0 RCX: 00007fd0db39e159
> RDX: 0000000000000094 RSI: 0000200000000040 RDI: 0000000000000005
> RBP: 00007fd0db43506b R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fd0db626038 R14: 00007fd0db625fa0 R15: 00007fff2dcab378
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:compute_insn_scevs kernel/bpf/scev.c:1489 [inline]
> RIP: 0010:bpf_compute_scev+0x5482/0x6050 kernel/bpf/scev.c:1569
> Code: 24 08 30 04 00 00 49 81 c7 30 04 00 00 45 31 ed 48 8b 44 24 10 4e 8=
d 34 a8 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84=
 c0 0f 85 af 00 00 00 41 8b 16 48 89 df 31 f6 48 8b
> RSP: 0018:ffffc9000372f6e0 EFLAGS: 00010247
> RAX: 0000000000000000 RBX: ffff8881144bad00 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000011 RDI: 0000000000000011
> RBP: ffffc9000372f910 R08: ffff888101bd0000 R09: 0000000000000004
> R10: 000000000000010f R11: 0000000000000000 R12: 0000000000000011
> R13: 0000000000000000 R14: 0000000000000004 R15: 0000000000000430
> FS:  00007fd0dc1f56c0(0000) GS:ffff88818d6b6000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fd0db270050 CR3: 00000001bf29a000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 4 bytes skipped:
>    0:   00 00                   add    %al,(%rax)
>    2:   49 81 c7 30 04 00 00    add    $0x430,%r15
>    9:   45 31 ed                xor    %r13d,%r13d
>    c:   48 8b 44 24 10          mov    0x10(%rsp),%rax
>   11:   4e 8d 34 a8             lea    (%rax,%r13,4),%r14
>   15:   4c 89 f0                mov    %r14,%rax
>   18:   48 c1 e8 03             shr    $0x3,%rax
>   1c:   48 b9 00 00 00 00 00    movabs $0xdffffc0000000000,%rcx
>   23:   fc ff df
> * 26:   0f b6 04 08             movzbl (%rax,%rcx,1),%eax <-- trapping in=
struction
>   2a:   84 c0                   test   %al,%al
>   2c:   0f 85 af 00 00 00       jne    0xe1
>   32:   41 8b 16                mov    (%r14),%edx
>   35:   48 89 df                mov    %rbx,%rdi
>   38:   31 f6                   xor    %esi,%esi
>   3a:   48                      rex.W
>   3b:   8b                      .byte 0x8b
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
> [andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.ne=
t eddyz87@gmail.com emil@etsalapatis.com ezingerman@fb.com kernel-team@fb.c=
om yonghong.song@linux.dev]
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
-upstream-moderation/6ac28fc6.a58718c8.226e00.0002.GAE%40google.com.
