Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3D8523B605
	for <syzbot@lists.linux.dev>; Sat, 27 Sep 2025 05:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758951967; cv=none; b=WgnTbzdjPeILK13rMn8NOaViBPKLEYuaDws0dCtT6/B4Qp81twpYJe2ZdZExRGZP6g8niACI6jFI9bFMeEs/JpOnZI2Set3sM4pELaYAZL6+ZeYrWQFO5no7ZpyVCG/7WxmY4PBk5N+Jc1nBDgKkY8ICeCqyGRY9OSyzcrwgqH8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758951967; c=relaxed/simple;
	bh=1US0SmjTZIKli4WlkTfbGA5AoQTVpX2XtVg2nFJHMqE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=kXau0TNyLh3Ta81slOkFvDn0U+61J4ePOk2GIuQFLLYvcLrP7a5Q6iHZa+JjFd/waXde4OtKCYdDkj1h/4oJYyW592gZsSdXloyp/rJ1UKaZTcIFHzDf6fUxvXa1uMPmmTnAslcsku4Ikf8YVZYMuzmONZwDS+HzFz6S3cZ3G0I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=k1jVMnUj; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="k1jVMnUj"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-74542b1b2bcso2570978a34.3
        for <syzbot@lists.linux.dev>; Fri, 26 Sep 2025 22:46:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758951964; x=1759556764; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=EzJCtg53bbg8v6LrQ8D4zMZ/CpPGUdzMhUnz4HxJBQY=;
        b=k1jVMnUjHauiUtu1DjqXhyRBCjg4wZM4001z038LlK2PZlXbbDGu0Nl5E+RI3hS8sQ
         FE48iJ87vJwUdUnb0UXaqFGAcvAGuUZ4MUlbTem02dQBFifcYyVM8PUZ4kSP+qSQJIkd
         hTYLfMVqyYbwBmyrOB8ASPL9GXaYpbzvEa9Fct3ODtoKjbuVdjTfuxZJF+gaSmJgL+wM
         nxT/VuwjJFXRQNzSxeWGSk3IwFzs53BUN47ip1qVenaYBhLftBk3X73xwGc7b3fUnNf4
         Lv1U92RkyCChgcJqm1N6+qQ4vKEr5vXPKewk3H+zNQ6BI1OoLh3PjPcSj/+sYFGQvylo
         ylGA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758951964; x=1759556764;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=EzJCtg53bbg8v6LrQ8D4zMZ/CpPGUdzMhUnz4HxJBQY=;
        b=fjLjeHq/9eQR2FzKZQhVMIdEdb6j0xY06e7aO7i/NQRM8bXxdlAvpJSJW6ViIyrwGG
         wjt9Y1QCmUzEDNdRHinOdZQtW8UaaZYAfxVVqip2R7JBBHZOaiXun4zNDlNEBGZsP0XI
         PDf712oXZX3ZaU3WaDA9ZpaZNExn4vt+kUVK9U0O9yS61NuzKQADpuLkxDz/J6rEEmyj
         oipYK1tqI6/8CUJvqrn0i1dr4g3fnxI/Gc0gGrMeOjOgl2iw/PsMlCYp/bPwsZoBem4h
         789vDjEMUXM+XobL2vezWAWr7vaZV9+9SbX6myGKf21n4NBIu6gJZHaoJwxH+ui/CkB2
         20CQ==
X-Forwarded-Encrypted: i=1; AJvYcCVg0h0N3Wey95Y/1C2vI9O9JfS7QnpNW4avPigGxGEw1nQChVi8I6O3T1FWS00rGQt2X2Z9J7k=@lists.linux.dev
X-Gm-Message-State: AOJu0YzV8gWWUzJY/TDtGDbzIqNnzFdl8dKUO4bgsrfu9dXKEO+wiB78
	2hU7TprISp0S76Q3G2d/pVarR3DYYILV0Dda99reU2YdAM63jNsJRzxA8bIhudwynimTjVjvR5S
	O/6l+TuJGcUAqkvup6uZItNCtMt8GN5MxoplDwjBK
X-Gm-Gg: ASbGnctIijx9lsZiv8O76p1DtbgC/Afc1T+dyG6+4gvTpZstJ8wCKKe1dZkiZ3Chck4
	SKFh5R5MjE9dNAg+eF4KZjCvFnC9VssuoQsKQtJXE47GmViVV262Kxs99L9Wf2+9tqeZqtbXcRR
	gNb+YyDf+tVz06sajOmGTA/IWRUKzJ+UoSkBkTWIO1ZwGJcqi0bXy1FJbX0PpKoZddvlLZygxz5
	B0658shccMCpw==
X-Google-Smtp-Source: AGHT+IFGeTD1rkRlkwtNJxPpUDaQrIXuBmf7e8fCKzngnx9yOE44rfELSglvcFIT2qGnc1aaU02OyuHW2zzsWJFfldk=
X-Received: by 2002:a05:6830:6082:b0:745:5320:c4bd with SMTP id
 46e09a7af769-7a0487336f1mr6998036a34.28.1758951963664; Fri, 26 Sep 2025
 22:46:03 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68d72f7c.a70a0220.10c4b.0004.GAE@google.com>
In-Reply-To: <68d72f7c.a70a0220.10c4b.0004.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 27 Sep 2025 07:45:51 +0200
X-Gm-Features: AS18NWCccKM7DbCCKaopzmGt4OKGozFjhbevyqazsLc1UoGwswEweUCRXAO_hwA
Message-ID: <CANp29Y6d_KSaameNyG9V00++dr3CFT_dX1Z=apT0q7dK=sSkMw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: BPF signature hash chains
To: syzbot ci <syzbot+cice8998b6b30a0022@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sat, Sep 27, 2025 at 2:27=E2=80=AFAM syzbot ci
<syzbot+cice8998b6b30a0022@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] BPF signature hash chains
> https://lore.kernel.org/all/20250926203111.1305999-1-bboscaccy@linux.micr=
osoft.com
> * [PATCH bpf-next 1/2] bpf: Add hash chain signature support for arbitrar=
y maps
> * [PATCH bpf-next 2/2] selftests/bpf: Enable map verification for some ls=
kel tests
>
> and found the following issue:
> general protection fault in bpf_prog_verify_signature
>
> Full report is available here:
> https://ci.syzbot.org/series/9d93d1cd-d2bd-4967-a631-f3e84ee6fb41
>
> ***
>
> general protection fault in bpf_prog_verify_signature
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      d43029ff7d1b7183dc0cf11b6cc2c12a0b810ad8
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/a6b64e3c-6f08-4a6d-b484-ece99910a=
3f0/config
> C repro:   https://ci.syzbot.org/findings/a6c59e03-c4f7-4752-8d4f-526ccf9=
45b7c/c_repro
> syz repro: https://ci.syzbot.org/findings/a6c59e03-c4f7-4752-8d4f-526ccf9=
45b7c/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc00020244a9: 0000 [#1] SMP KASAN PTI
> KASAN: probably user-memory-access in range [0x0000000010122548-0x0000000=
01012254f]
> CPU: 1 UID: 0 PID: 6002 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:bpf_prog_verify_signature+0x610/0xc40 kernel/bpf/syscall.c:2873
> Code: f7 e8 04 73 52 00 4d 8b 2e 89 d8 25 ff ff ff 7f 48 8b 4c 24 10 4c 8=
d 34 81 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84=
 c0 0f 85 c9 03 00 00 49 63 06 4c 8d 34 85 00 00 00
> RSP: 0018:ffffc90002bff920 EFLAGS: 00010206
> RAX: 00000000020244a9 RBX: 0000000004048956 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90002bffb30 R08: ffffffff8fa3b537 R09: 1ffffffff1f476a6
> R10: dffffc0000000000 R11: fffffbfff1f476a7 R12: 1ffff9200057ff34
> R13: 0000000000000000 R14: 000000001012254a R15: 0000000080000000
> FS:  0000555591f35500(0000) GS:ffff8881a3c11000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000011081a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  bpf_prog_load+0xcc7/0x19e0 kernel/bpf/syscall.c:3072
>  __sys_bpf+0x4ff/0x850 kernel/bpf/syscall.c:6199
>  __do_sys_bpf kernel/bpf/syscall.c:6309 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6307 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6307
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7feeb318ec29
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffd613f7e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007feeb33d5fa0 RCX: 00007feeb318ec29
> RDX: 00000000000000b9 RSI: 0000200000000100 RDI: 0000000000000005
> RBP: 00007feeb3211e41 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007feeb33d5fa0 R14: 00007feeb33d5fa0 R15: 0000000000000003
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bpf_prog_verify_signature+0x610/0xc40 kernel/bpf/syscall.c:2873
> Code: f7 e8 04 73 52 00 4d 8b 2e 89 d8 25 ff ff ff 7f 48 8b 4c 24 10 4c 8=
d 34 81 4c 89 f0 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <0f> b6 04 08 84=
 c0 0f 85 c9 03 00 00 49 63 06 4c 8d 34 85 00 00 00
> RSP: 0018:ffffc90002bff920 EFLAGS: 00010206
> RAX: 00000000020244a9 RBX: 0000000004048956 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90002bffb30 R08: ffffffff8fa3b537 R09: 1ffffffff1f476a6
> R10: dffffc0000000000 R11: fffffbfff1f476a7 R12: 1ffff9200057ff34
> R13: 0000000000000000 R14: 000000001012254a R15: 0000000080000000
> FS:  0000555591f35500(0000) GS:ffff8881a3c11000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000011081a000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   f7 e8                   imul   %eax
>    2:   04 73                   add    $0x73,%al
>    4:   52                      push   %rdx
>    5:   00 4d 8b                add    %cl,-0x75(%rbp)
>    8:   2e 89 d8                cs mov %ebx,%eax
>    b:   25 ff ff ff 7f          and    $0x7fffffff,%eax
>   10:   48 8b 4c 24 10          mov    0x10(%rsp),%rcx
>   15:   4c 8d 34 81             lea    (%rcx,%rax,4),%r14
>   19:   4c 89 f0                mov    %r14,%rax
>   1c:   48 c1 e8 03             shr    $0x3,%rax
>   20:   48 b9 00 00 00 00 00    movabs $0xdffffc0000000000,%rcx
>   27:   fc ff df
> * 2a:   0f b6 04 08             movzbl (%rax,%rcx,1),%eax <-- trapping in=
struction
>   2e:   84 c0                   test   %al,%al
>   30:   0f 85 c9 03 00 00       jne    0x3ff
>   36:   49 63 06                movslq (%r14),%rax
>   39:   4c                      rex.WR
>   3a:   8d                      .byte 0x8d
>   3b:   34 85                   xor    $0x85,%al
>   3d:   00 00                   add    %al,(%rax)
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
> [andrii@kernel.org ast@kernel.org bboscaccy@linux.microsoft.com bpf@vger.=
kernel.org daniel@iogearbox.net james.bottomley@hansenpartnership.com kpsin=
gh@kernel.org kys@microsoft.com linux-security-module@vger.kernel.org paul@=
paul-moore.com wufan@linux.microsoft.com]
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
-upstream-moderation/68d72f7c.a70a0220.10c4b.0004.GAE%40google.com.
