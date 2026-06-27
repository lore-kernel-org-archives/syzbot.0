Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 412652EEE7E
	for <syzbot@lists.linux.dev>; Sat, 27 Jun 2026 20:50:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.44
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782593408; cv=pass; b=k6yRMdmOxMDI5zvCsp+TlFYGxwDib3EwzETTGA7bCuwY8a+v+k7reDTJnFgvjp4cTkvzNuXUEJZUq4ZgiEjGH7NcKcnNS5We92lqIqXVmXbwUieRf0Ly2nK8LB6+HtHEdm9NsMbVAS7XG/3VfD8e/UGuLs1qWK0N0Ue01vipejI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782593408; c=relaxed/simple;
	bh=18BQDp7CgQ3zA0Of8yVEz2FxG1K4siiRpmH+28CMQEw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UYHZYoT9Mm9VV3A5+EtnlwOLionOZa6Yaw6iA2Kilqriav6zurr/C7GrSPnZPqyBl63myvnZnLVmKyurHhjNbAD3UrvfToBIezV3QaF/Fo5Mp3yvd0Dose9bM9sOn9mXjqcCjRBEBTB+pmu+ZJAb5Fn72NtdShS6Eq9gDO/TVrU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=N43BFDdl; arc=pass smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="N43BFDdl"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-6a168dc590cso67315eaf.0
        for <syzbot@lists.linux.dev>; Sat, 27 Jun 2026 13:50:07 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1782593406; cv=none;
        d=google.com; s=arc-20260327;
        b=EAGeTJ8bwvoZhqg9u8mTNGybKloxTyAk8XgboLddVk2WO7m+lwiQM8XPHueIfdw3aX
         CaMfZZGYOCa7LTXIXnEDvh5Hl4KvarqHv7k+BrZHXtBLA1RdwTlv1BfNtAj76gTTWlMV
         nIfwsLNqOjLuKeEr7wGpT2wRdSmNyRsd376yXKQX0J5+LN4ncuOPx3fDfr848M9z2gsU
         /+j0lySR2mRAKrxsry6HmqfClXBM/JpsuNzjLNn6cjqjZygVKhN+65nNK4H8yGfn4I/g
         eiu/uMhBzCDZ3F5aKtJwyZ1isxmH7+RU8Fh7hU+PHn1nVsgK0CHlgeglrNJzKY5ekYhM
         trGQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=R5by8eHpqRnUJqpc8qtZVsT97rK/+ksuOhx6z/OcwiU=;
        fh=4E3rWDBgw7+M6sBm3dp++ylWyWRuSzpghER/I5AOISU=;
        b=XDrtnyDk9xFeXOyZ4NnlaePIEs2HvoJ89qEzdYPq/MJQuNCZ7azoX5WcPDmuRRDS3X
         1AzjO30Hw7ftoGkHDQGuGtTGnRmnNjOZB7fo+n2ZZY2KOd9JtmrGQ/PwJqKrDW7SvIaV
         /cj5vXYMxQhTQ2NYV0hqzZH05SxkSpFqYcKS0dF/S5mf/fLNxEY4DmPBbWidHL0tBT/d
         /wbgl+ltoSwVd9IyTYC2c84mzeqP8Ik+ZRPuENodSEpwaTO4DVFm/i68GTnhhXXYK89u
         tGCLSIObyWNxL6FBlH1f9uNh8xX3dNH0aSTxy3VBtwg0+pWIS82rC6I/R5dJ1Rxhz9Ed
         jUiA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1782593406; x=1783198206; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=R5by8eHpqRnUJqpc8qtZVsT97rK/+ksuOhx6z/OcwiU=;
        b=N43BFDdlDKbWhsjt/A5G8N7yZmK/84kqBoidmBbGxF+0yr/fH//v+ljfsfkO6oQpG0
         5JoOCRa0Ep7gODlggz+7klyS/7zbZTwMOZ7LBaLCP+uSprZIDrjfDB5phHTnO+0SJD19
         D6A+Roa9i3FtiWVRFr+BVZwOxZz5M3SAJzOleY4s9QIn6OvJJUel9xjo60O+JuMlTMp/
         V8XQmt2ElvMU9X+UqxnWH8hhZ2hz3i9C86WjNl4LfSNyZeliazAeUOES0+9oamYk8vMs
         N68wJBfWGHsn8cd4w3EVfXLXm6dbIel2L1Z2CBGFGqtjyjoq3W8UJ3tDvriS4dTR97K6
         cHIg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782593406; x=1783198206;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=R5by8eHpqRnUJqpc8qtZVsT97rK/+ksuOhx6z/OcwiU=;
        b=g9NGKpfnt/DK5fzbR41trtcGsJTTZfsZ4jtFz6BpTsdaTM6JSsiJzoS0WsECMUf0u3
         85D3/1+wK6qVBNCA9IC8+/gMLB+Qr5QgL5kS28JlCIbs8sCikKrgtCCjcQZ1rj5FSLDj
         n9fB+whUsIhNlhgOcmLhRmNrk34EbjAUkaDRccp7wKgQZ/T2SLw9tHuwzGJPudQMvjqP
         lnu4cvvTsfY/gayUAVuYaSy1OGsU8WdC7avB74ga3DhhmKT//CUu3d4iqwyMVcLYJcwa
         vg7rDho8Q1MtDUoyMQ3mrhYf0t9YHwQyE+X5ndQWv7+3PsLv7D+IP6aVHPiZyIKEEHMr
         wE9w==
X-Forwarded-Encrypted: i=1; AFNElJ+ZQ/kEDEy0sG5e0SKCv4JVRPaNtA8sTvz1zIZFTqR8vwVoy+N2UovcWEW0WD6yJH1kM5Dtby0=@lists.linux.dev
X-Gm-Message-State: AOJu0YyCQwz3uUHJcPoVHwCI+ehXOE0tSiApvgHkpRnpt9gV8IvSXdE2
	k4vMp9QxhGNZ/tsIa/jUyKnpvnTUs0wOCO1r0wW4D+UG3XVkAquT6NQGkfZWGT0QBuud5CtjNcR
	p76s9vAkCtF8IurzMTfQ296OusDyTy0ZFgwnFqxSW
X-Gm-Gg: AfdE7clxSC4H7ZAXvlVzHbe/gsioiUTP/JBKh+bHlPKg6Zl+upSPpO79rvMBTHvZYdX
	FcGuRWk+8cvKYnU01IdPyiuyS6J5x7i2EEeI6nEV0cyl5qzg3WdwuwPcpECVemF248mnwx0DOdi
	LY+xxuyATVVsxiL+ZXl3/fcUYUdbxsWqksk34v4CWtm+gCb4f33IpFuRavvdiVghqjM76ZTyI0/
	DgsGxddi5FfsrYINKGXNaAv9eSlqpgNMF3IvJ2F0zshjsCpdMNYY7x8YzIGr59WK6M6QC+BnLhU
	pXa5Y6M3C4WpDJ9Qq0GvfbUV6xt5ntTuYrMpshPAp6yOfwyCeRMd/0/6eeb/tzdxS0L9n+AN4Jk
	+BrANyPe1hTk1rHXJp9FfCqJMkg3F47kwt0pzMRbRQSGHw1aGMEt03w==
X-Received: by 2002:a05:6820:3096:b0:69d:f8c2:387 with SMTP id
 006d021491bc7-6a14fd59efcmr4139453eaf.17.1782593405664; Sat, 27 Jun 2026
 13:50:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a401f7d.6124255a.dd83.0000.GAE@google.com>
In-Reply-To: <6a401f7d.6124255a.dd83.0000.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 27 Jun 2026 22:49:54 +0200
X-Gm-Features: AVVi8Cc9_uEVfRY6GnR5-XQefRZwBafa-dIpv-jhUiIlWazeZcdaBNoL6orxxI0
Message-ID: <CANp29Y7+ktE-0VJTd-MCYj6KHTwNvCWEd1-3LG2jBFCkVJ+-cA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Introduce static-defined tracing probe
 for BPF
To: syzbot ci <syzbot+ciee10aa76dc1fd513@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Jun 27, 2026 at 9:07=E2=80=AFPM syzbot ci
<syzbot+ciee10aa76dc1fd513@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] bpf: Introduce static-defined tracing probe for BPF
> https://lore.kernel.org/all/cover.1782571533.git.xukuohai@huawei.com
> * [RFC PATCH bpf-next 01/12] libbpf: Prepare bpf SDT probe section for th=
e linker
> * [RFC PATCH bpf-next 02/12] libbpf: Introduce bpf SDT probe macros
> * [RFC PATCH bpf-next 03/12] libbpf: Add bpf_sdt_notes section parser
> * [RFC PATCH bpf-next 04/12] bpf: Create insn_array map for bpf SDT probe
> * [RFC PATCH bpf-next 05/12] bpf: Collect SDT probe BTF IDs from BTF decl=
 tags
> * [RFC PATCH bpf-next 06/12] bpf: Add type check for SDT probe site
> * [RFC PATCH bpf-next 07/12] bpf: Record probe name in SDT map
> * [RFC PATCH bpf-next 08/12] libbpf: Add libbpf support to load SDT obser=
ver program
> * [RFC PATCH bpf-next 09/12] bpf: Add kernel support to load SDT observer=
 program
> * [RFC PATCH bpf-next 10/12] bpf: Support attach and detach for SDT obser=
ver program
> * [RFC PATCH bpf-next 11/12] bpf, x86: Add JIT support SDT for probe
> * [RFC PATCH bpf-next 12/12] selftests/bpf: Add tests for bpf SDT probe
>
> and found the following issue:
> general protection fault in do_jit
>
> Full report is available here:
> https://ci.syzbot.org/series/86d21ab6-d0e1-4dd3-b7e1-af4571d27460
>
> ***
>
> general protection fault in do_jit
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      53435562a725962e4de0c29653223129ba11643a
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/549153a4-d4b8-46a4-8266-df26ad835=
e2f/config
> syz repro: https://ci.syzbot.org/findings/2efaa7e4-eae0-45d0-b336-f0e311f=
8356e/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000010e: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000870-0x0000000000000877]
> CPU: 1 UID: 0 PID: 5818 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:do_jit+0x7c8c/0x12a90 arch/x86/net/bpf_jit_comp.c:2806
> Code: 49 83 c4 44 4c 89 e0 48 c1 e8 03 0f b6 04 10 84 c0 0f 85 0a 84 00 0=
0 45 03 34 24 48 8b bc 24 a0 01 00 00 48 89 f8 48 c1 e8 03 <80> 3c 10 00 74=
 17 e8 49 30 b0 00 48 8b bc 24 a0 01 00 00 48 ba 00
> RSP: 0018:ffffc900038cf640 EFLAGS: 00010202
> RAX: 000000000000010e RBX: 000000000000001c RCX: 0000000000000000
> RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000870
> RBP: ffffc900038cfa00 R08: ffff88816bb0d940 R09: 0000000000000096
> R10: 00000000000000fb R11: 0000000000000000 R12: ffff8881749b8044
> R13: ffff88816c445450 R14: 0000000000000003 R15: 0000000000000000
> FS:  00007f06814986c0(0000) GS:ffff8882a9224000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f0680472780 CR3: 000000001cfc8000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  bpf_int_jit_compile+0x8af/0x1620 arch/x86/net/bpf_jit_comp.c:3946
>  bpf_prog_jit_compile kernel/bpf/core.c:2571 [inline]
>  __bpf_prog_select_runtime+0x4e2/0xb20 kernel/bpf/core.c:2640
>  bpf_migrate_filter net/core/filter.c:1318 [inline]
>  bpf_prepare_filter+0x10ef/0x1280 net/core/filter.c:1366
>  sk_attach_filter+0x24/0x140 net/core/filter.c:1550
>  tun_attach_filter+0x176/0x280 drivers/net/tun.c:2992
>  __tun_chr_ioctl+0x15f1/0x1e10 drivers/net/tun.c:3344
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f068059ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f0681498028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007f0680815fa0 RCX: 00007f068059ce59
> RDX: 0000200000000300 RSI: 00000000401054d5 RDI: 0000000000000003
> RBP: 00007f0680632e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0680816038 R14: 00007f0680815fa0 R15: 00007fff056e7c98
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:do_jit+0x7c8c/0x12a90 arch/x86/net/bpf_jit_comp.c:2806
> Code: 49 83 c4 44 4c 89 e0 48 c1 e8 03 0f b6 04 10 84 c0 0f 85 0a 84 00 0=
0 45 03 34 24 48 8b bc 24 a0 01 00 00 48 89 f8 48 c1 e8 03 <80> 3c 10 00 74=
 17 e8 49 30 b0 00 48 8b bc 24 a0 01 00 00 48 ba 00
> RSP: 0018:ffffc900038cf640 EFLAGS: 00010202
> RAX: 000000000000010e RBX: 000000000000001c RCX: 0000000000000000
> RDX: dffffc0000000000 RSI: 0000000000000000 RDI: 0000000000000870
> RBP: ffffc900038cfa00 R08: ffff88816bb0d940 R09: 0000000000000096
> R10: 00000000000000fb R11: 0000000000000000 R12: ffff8881749b8044
> R13: ffff88816c445450 R14: 0000000000000003 R15: 0000000000000000
> FS:  00007f06814986c0(0000) GS:ffff8882a9224000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f06805ea540 CR3: 000000001cfc8000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   49 83 c4 44             add    $0x44,%r12
>    4:   4c 89 e0                mov    %r12,%rax
>    7:   48 c1 e8 03             shr    $0x3,%rax
>    b:   0f b6 04 10             movzbl (%rax,%rdx,1),%eax
>    f:   84 c0                   test   %al,%al
>   11:   0f 85 0a 84 00 00       jne    0x8421
>   17:   45 03 34 24             add    (%r12),%r14d
>   1b:   48 8b bc 24 a0 01 00    mov    0x1a0(%rsp),%rdi
>   22:   00
>   23:   48 89 f8                mov    %rdi,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   80 3c 10 00             cmpb   $0x0,(%rax,%rdx,1) <-- trapping in=
struction
>   2e:   74 17                   je     0x47
>   30:   e8 49 30 b0 00          call   0xb0307e
>   35:   48 8b bc 24 a0 01 00    mov    0x1a0(%rsp),%rdi
>   3c:   00
>   3d:   48                      rex.W
>   3e:   ba                      .byte 0xba
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
> [a.s.protopopov@gmail.com ameryhung@gmail.com andrii@kernel.org ast@kerne=
l.org bpf@vger.kernel.org daniel@iogearbox.net eddyz87@gmail.com eyal.birge=
r@gmail.com jolsa@kernel.org kpsingh@kernel.org linux-kernel@vger.kernel.or=
g memxor@gmail.com rongtao@cestc.cn xukuohai@huaweicloud.com yonghong.song@=
linux.dev]
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
-upstream-moderation/6a401f7d.6124255a.dd83.0000.GAE%40google.com.
