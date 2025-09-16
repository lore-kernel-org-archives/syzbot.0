Received: from mail-ot1-f43.google.com (mail-ot1-f43.google.com [209.85.210.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38C313A1DB
	for <syzbot@lists.linux.dev>; Tue, 16 Sep 2025 07:34:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758008078; cv=none; b=qgI/4QldaQnoYdvxb1Pm6npZlPx78nPSlCakq0CJMtjaFC72mnN26q8mNvo1bMPoHk9pm4vmtqISTlaC/z432PQ8NF6XP2IzpDM+gMpENRwfbTl5EAGWGGQxGOyJCMYT+96NnvRLyOJi4Qk6Fc/dUH2PKSQOuHG3RgHJMOhgT0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758008078; c=relaxed/simple;
	bh=c0825Mcf9i9ygaT/s7UPD1EQK3PUfMVeN0xSiiyyhbA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=agSlVc3/PQ4EYwholjXEMcJQigz3KHyPaIegdGp5kz/gLTz2YQaAHMreJRwmTd9sdWTRGdikZXldq9XI8HakDdNTEGEMseL5Dns3X5rUlEwWaYSHNyuON61Cxob0VgETEQDvgcf/ZUWwBpibZOYIIBnf+c0KQROZ4icXxJX0UpA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Ykva5e2i; arc=none smtp.client-ip=209.85.210.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Ykva5e2i"
Received: by mail-ot1-f43.google.com with SMTP id 46e09a7af769-74381df387fso2286451a34.0
        for <syzbot@lists.linux.dev>; Tue, 16 Sep 2025 00:34:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758008076; x=1758612876; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=WsOifathWlOlen8Gqj4/+pEDHpybvlcyQ8C1aOWe9ls=;
        b=Ykva5e2iCeDegPNfDlttCkNN+x0YsJeBgf04ZnyD0TywdipthKj5pOkKsW8cfxYAH0
         MxlC42HexFFnCSrZcxNk4jlat+6mddhMQUcaKBvO2Wyf2r9JxJmDNtqxYgIblX4h00aU
         NcFlMVCbmGTNEZXnszsdLKLQ8ZB5Q4kROenFEEqlUDqPNnm4bIUwCyc9HhNdKYNy21iH
         0ufXKNj5eufJjx4aSS0UDSVgzLa698ehZdclO/Zhk0kOVIEWlv+qZioCHdaMbFLspbX9
         IhBXeFlmcRBeMtMY8rqF09m1l4Y8ht/0hQBMUwoGCmF2EGBlgp4l9EUdy2w2jmWZzRGM
         hZow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758008076; x=1758612876;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=WsOifathWlOlen8Gqj4/+pEDHpybvlcyQ8C1aOWe9ls=;
        b=gHmk45C4sXx9mZRTWk7qHBF6xy9jfM7JyBtkGX+4Ptwronw5I4JzV6DAf0LbfpjgSd
         oeVQoxePT+1uB8iuImQ5N3ZUbdUvqSlE9YwZzqVo70Y6pgN9de+MgMlORT7n0/E82xxB
         msCxFUR5b/Z5iWjCP59AWsHBNmAvsooby4igjZNS4zdpSd9Uuk1oYNgz06I1tHMgwceS
         wsxxHcRbE0OIRVxZ/wmWvLIOUypycaIMqEjIgvhxp59KeDitdc7uc7DsRBF2M/LmYecK
         7WckpMGkxpF7fnDYCSyGFx7LKziXYJSm/bt0JRaYimyLji3tOcl4mLhnPeihVlcQAvp8
         32Mw==
X-Forwarded-Encrypted: i=1; AJvYcCWtb9VRICCLs/qeKColAf9DtJ440dhNwpXolw4Myx513YmQB2MRpam2MTgqLwDBDFbeucESeog=@lists.linux.dev
X-Gm-Message-State: AOJu0YwBP/LwtoqYoNR0pQtxxU0YBObI1Qcmljy0/W5WgNhwb1iE6h++
	QVEGO5aVIedrYLIWPeYKG11oOMTol7Eu43OwLtsuCoyyJ4mjM9yqwr0rIyYX1cROzeOhmRkcZap
	9B+JDDa0DlI+H3beZg6Z7sNBZUltPQP4+ENQVfQTJ
X-Gm-Gg: ASbGncvR7L4/n5uZ1YYz/z3vH51ZIMFVGrDf7TT4fpr/9D15Sn+XMnCZix0vUCcnTXZ
	aPobMaMWNBTeg0cImpGRNWLPLWmxusGrvnnJjhTZ6jVlvmXeis7YfSy1LIrIBoXI945+sApmZBN
	F7BbyWuFxDAAvRiXQY8QhjSfDYdT92fZVhknhgBkhciustrk/k3oeZGQs8zXDGN6NKrq621A2kF
	cJLhvkKgEOZYrJrD/sNYJ2brUQJUHoa0707pX9ODcg=
X-Google-Smtp-Source: AGHT+IGreraKdd6pPbuUVQeM08M79ED1OrHsleBrErUfgtMSZXYvzYxHhEpKc59haxOYzXebJRMcq5eRt0Qj3ySgK8Q=
X-Received: by 2002:a05:6830:661c:b0:742:6d79:ed44 with SMTP id
 46e09a7af769-753558c1cd2mr10784364a34.28.1758008075984; Tue, 16 Sep 2025
 00:34:35 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68c8ab3c.050a0220.3c6139.0d24.GAE@google.com>
In-Reply-To: <68c8ab3c.050a0220.3c6139.0d24.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 16 Sep 2025 09:34:24 +0200
X-Gm-Features: AS18NWBvjxw19_18Xh-oUylsxKRrBU4mjodhchA4Myv4dcSd9GCrH9XRYwanixo
Message-ID: <CANp29Y7GtzdUUrFK_D3nH1FwDZtmEg6RhKTbUCMXaKL7nPATzw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Introduce deferred task context execution
To: syzbot ci <syzbot+cia7fb6495877b8686@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Sep 16, 2025 at 2:11=E2=80=AFAM syzbot ci
<syzbot+cia7fb6495877b8686@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] bpf: Introduce deferred task context execution
> https://lore.kernel.org/all/20250915201820.248977-1-mykyta.yatsenko5@gmai=
l.com
> * [PATCH bpf-next v4 1/8] bpf: refactor special field-type detection
> * [PATCH bpf-next v4 2/8] bpf: extract generic helper from process_timer_=
func()
> * [PATCH bpf-next v4 3/8] bpf: htab: extract helper for freeing special s=
tructs
> * [PATCH bpf-next v4 4/8] bpf: verifier: permit non-zero returns from asy=
nc callbacks
> * [PATCH bpf-next v4 5/8] bpf: bpf task work plumbing
> * [PATCH bpf-next v4 6/8] bpf: extract map key pointer calculation
> * [PATCH bpf-next v4 7/8] bpf: task work scheduling kfuncs
> * [PATCH bpf-next v4 8/8] selftests/bpf: BPF task work scheduling tests
>
> and found the following issue:
> general protection fault in process_timer_func
>
> Full report is available here:
> https://ci.syzbot.org/series/e70d729f-f3e4-4237-b9e5-1ca20a4669da
>
> ***
>
> general protection fault in process_timer_func
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      df0cb5cb50bd54d3cd4d0d83417ceec6a66404aa
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/43db8049-6e85-46cb-a784-af031a393=
75f/config
> C repro:   https://ci.syzbot.org/findings/f6e0987d-2e21-4806-85fb-a885db9=
67391/c_repro
> syz repro: https://ci.syzbot.org/findings/f6e0987d-2e21-4806-85fb-a885db9=
67391/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000002: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> CPU: 0 UID: 0 PID: 5988 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:process_timer_func+0xe5/0x290 kernel/bpf/verifier.c:8558
> Code: 1f 4c 8d 63 38 4c 89 e0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 e7 e=
8 8a 38 46 00 4d 8b 24 24 49 83 c4 10 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 28=
 84 c0 0f 85 47 01 00 00 41 8b 0c 24 4c 89 f7 89 ee
> RSP: 0018:ffffc90003b66f80 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: ffff88802701d400 RCX: 0000000000000078
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000008
> RBP: 0000000000000001 R08: ffff888106b53980 R09: 000000000000000e
> R10: 0000000000000017 R11: 0000000000000000 R12: 0000000000000010
> R13: dffffc0000000000 R14: ffff8880247e0000 R15: ffff888027b90080
> FS:  0000555581212500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30e63fff CR3: 000000010664a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  check_func_arg kernel/bpf/verifier.c:9885 [inline]
>  check_helper_call+0x20de/0x6a90 kernel/bpf/verifier.c:11526
>  do_check_insn kernel/bpf/verifier.c:20042 [inline]
>  do_check+0x8b35/0xe520 kernel/bpf/verifier.c:20211
>  do_check_common+0x1949/0x24f0 kernel/bpf/verifier.c:23378
>  do_check_main kernel/bpf/verifier.c:23461 [inline]
>  bpf_check+0x1746a/0x1d2d0 kernel/bpf/verifier.c:24821
>  bpf_prog_load+0x1318/0x1930 kernel/bpf/syscall.c:2993
>  __sys_bpf+0x528/0x870 kernel/bpf/syscall.c:6043
>  __do_sys_bpf kernel/bpf/syscall.c:6153 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6151 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6151
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f00c358eba9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdb3c1bfd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f00c37d5fa0 RCX: 00007f00c358eba9
> RDX: 0000000000000094 RSI: 0000200000000400 RDI: 0000000000000005
> RBP: 00007f00c3611e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f00c37d5fa0 R14: 00007f00c37d5fa0 R15: 0000000000000003
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:process_timer_func+0xe5/0x290 kernel/bpf/verifier.c:8558
> Code: 1f 4c 8d 63 38 4c 89 e0 48 c1 e8 03 42 80 3c 28 00 74 08 4c 89 e7 e=
8 8a 38 46 00 4d 8b 24 24 49 83 c4 10 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 28=
 84 c0 0f 85 47 01 00 00 41 8b 0c 24 4c 89 f7 89 ee
> RSP: 0018:ffffc90003b66f80 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: ffff88802701d400 RCX: 0000000000000078
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000008
> RBP: 0000000000000001 R08: ffff888106b53980 R09: 000000000000000e
> R10: 0000000000000017 R11: 0000000000000000 R12: 0000000000000010
> R13: dffffc0000000000 R14: ffff8880247e0000 R15: ffff888027b90080
> FS:  0000555581212500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30e63fff CR3: 000000010664a000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:   4c 8d 63 38             lea    0x38(%rbx),%r12
>    4:   4c 89 e0                mov    %r12,%rax
>    7:   48 c1 e8 03             shr    $0x3,%rax
>    b:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1)
>   10:   74 08                   je     0x1a
>   12:   4c 89 e7                mov    %r12,%rdi
>   15:   e8 8a 38 46 00          call   0x4638a4
>   1a:   4d 8b 24 24             mov    (%r12),%r12
>   1e:   49 83 c4 10             add    $0x10,%r12
>   22:   4c 89 e0                mov    %r12,%rax
>   25:   48 c1 e8 03             shr    $0x3,%rax
> * 29:   42 0f b6 04 28          movzbl (%rax,%r13,1),%eax <-- trapping in=
struction
>   2e:   84 c0                   test   %al,%al
>   30:   0f 85 47 01 00 00       jne    0x17d
>   36:   41 8b 0c 24             mov    (%r12),%ecx
>   3a:   4c 89 f7                mov    %r14,%rdi
>   3d:   89 ee                   mov    %ebp,%esi
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
> [andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.ne=
t eddyz87@gmail.com kafai@meta.com kernel-team@meta.com memxor@gmail.com my=
kyta.yatsenko5@gmail.com yatsenko@meta.com]
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
-upstream-moderation/68c8ab3c.050a0220.3c6139.0d24.GAE%40google.com.
