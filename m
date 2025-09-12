Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E675241680
	for <syzbot@lists.linux.dev>; Fri, 12 Sep 2025 22:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757716147; cv=none; b=bXzZlBLCCDNOmXdHzhTdSw3wZli5S2Obg9w2mKO5y8UqrQc9N5V1RdxQMwCJyUEfSIQX4KS1jZK/511pNf96nEGXkOl0Rpg2OwIsEQ9sAs6mIQF6sOOFxcZa97WtLoIUjsIxudtHxqjT30GEbmvc1Km1AqXm4KMODLj1PTDedZQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757716147; c=relaxed/simple;
	bh=5qc69/Di18NCapXBFuAPxOelwmT46G+iXd0AwmaqkgI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=fhMCFYeG70DauA+Ys43paF2ptig65po+5avuyiMz/CgzkfeE7XdHKcbzMvHxwOTEfEfHe+WwMtfPgYHYdZvDxC3NRBimBuGt89wFZakSHihIEd0dsY81wfCXA7dPZJvTa4mikIRLVzz042bam8H8Z0JQ/m2FIsWjK8zR7iAC/Hs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VKe+JCc3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VKe+JCc3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA17BC4CEF1
	for <syzbot@lists.linux.dev>; Fri, 12 Sep 2025 22:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1757716146;
	bh=5qc69/Di18NCapXBFuAPxOelwmT46G+iXd0AwmaqkgI=;
	h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
	b=VKe+JCc3O5on4PgwTM0YYivvRmH1CIbDNyfKABcAAp6c87zp+BABevCrHbTGBFkUB
	 TE5aFi3eYzOYaP6/0CFQneM8+Rny32Wj2yxiVdRHY4I0IlSgqZb7EISkSSX99yI00N
	 QmHl+M8B9QGnTl7PTRiKwAT8+AwJeA+qVFALyh3ykG7D+uP8HfQA8WIeRYARXuyiqa
	 zUvfjqOSuTorO8YaW8eGNULrVEouwVvzHK5M96Gq3JMZSqXjhPBhRZF0MSaPMZopLs
	 4eHFMuM4wteSipOQhK0RKFex8xOVt2HtdSx55GdVnuh687fG+N8Ghej/yrAar4G9Au
	 6e/lurvc7Oo5w==
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-3e34dbc38easo1382273f8f.1
        for <syzbot@lists.linux.dev>; Fri, 12 Sep 2025 15:29:06 -0700 (PDT)
X-Forwarded-Encrypted: i=1; AJvYcCXBLls0G+2+xgtzSHyNA3YdNfXW/Y06Oe6bGf4QsUfLMhVxvPlfTHqCKdspIrWGfxG43hq41JQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YyUXyMoXdJMBwNqRpyNa661oRkzmWNcfJmgyRiF0lgnEEAoOwYR
	cnyY0FULM5PHVJA1bxcLLpuggRcEIhY8CTORdbtcRVPCyEMHi1bLBi2Wb/oHABouCrTZmomtPaW
	Kh8llgocY+wQn1daJwn+/6oYNLbpryimLWqgLB8ms
X-Google-Smtp-Source: AGHT+IFHVzz8UZN4jz5Xg0s+AyXjp00JIcZymdoa+3YOgbZlf46gyFqcn3aWBFiPO2IBHuT0zODyLpHkotScSHJ2AF4=
X-Received: by 2002:a05:6000:2891:b0:3ce:db36:607f with SMTP id
 ffacd0b85a97d-3e765a04be2mr3619221f8f.37.1757716145394; Fri, 12 Sep 2025
 15:29:05 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20250813205526.2992911-1-kpsingh@kernel.org> <689eef40.050a0220.e29e5.0010.GAE@google.com>
In-Reply-To: <689eef40.050a0220.e29e5.0010.GAE@google.com>
From: KP Singh <kpsingh@kernel.org>
Date: Sat, 13 Sep 2025 00:28:54 +0200
X-Gmail-Original-Message-ID: <CACYkzJ4ObNwj6GpZ70Yri1OBmc2cQpZ2B2szURAJKP3q4S5xEQ@mail.gmail.com>
X-Gm-Features: AS18NWCwPCezEK9cZ8eTHQ7VX79yav-Z1PyPoWyyaVpnt7JFGsdansoz2D25AxY
Message-ID: <CACYkzJ4ObNwj6GpZ70Yri1OBmc2cQpZ2B2szURAJKP3q4S5xEQ@mail.gmail.com>
Subject: Re: [syzbot ci] Re: Signed BPF programs
To: syzbot ci <syzbot+cic1938c6466797c55@syzkaller.appspotmail.com>
Cc: andrii@kernel.org, ast@kernel.org, bboscaccy@linux.microsoft.com, 
	bpf@vger.kernel.org, daniel@iogearbox.net, kys@microsoft.com, 
	linux-security-module@vger.kernel.org, paul@paul-moore.com, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Fri, Aug 15, 2025 at 10:26=E2=80=AFAM syzbot ci
<syzbot+cic1938c6466797c55@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] Signed BPF programs
> https://lore.kernel.org/all/20250813205526.2992911-1-kpsingh@kernel.org
> * [PATCH v3 01/12] bpf: Update the bpf_prog_calc_tag to use SHA256
> * [PATCH v3 02/12] bpf: Implement exclusive map creation
> * [PATCH v3 03/12] libbpf: Implement SHA256 internal helper
> * [PATCH v3 04/12] libbpf: Support exclusive map creation
> * [PATCH v3 05/12] selftests/bpf: Add tests for exclusive maps
> * [PATCH v3 06/12] bpf: Return hashes of maps in BPF_OBJ_GET_INFO_BY_FD
> * [PATCH v3 07/12] bpf: Move the signature kfuncs to helpers.c
> * [PATCH v3 08/12] bpf: Implement signature verification for BPF programs
> * [PATCH v3 09/12] libbpf: Update light skeleton for signing
> * [PATCH v3 10/12] libbpf: Embed and verify the metadata hash in the load=
er
> * [PATCH v3 11/12] bpftool: Add support for signing BPF programs
> * [PATCH v3 12/12] selftests/bpf: Enable signature verification for some =
lskel tests
>
> and found the following issue:
> general protection fault in bpf_verify_pkcs7_signature
>
> Full report is available here:
> https://ci.syzbot.org/series/67d9a289-da5c-4051-8c3c-cc32b6ccd77d
>
> ***
>
> general protection fault in bpf_verify_pkcs7_signature
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      07866544e410e4c895a729971e4164861b41fad5
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/1e87aafb-11dc-48f1-a980-c91551ba5=
2de/config
> C repro:   https://ci.syzbot.org/findings/0c329233-09a8-4e8b-9e6e-72f234d=
d85ab/c_repro
> syz repro: https://ci.syzbot.org/findings/0c329233-09a8-4e8b-9e6e-72f234d=
d85ab/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000001: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 1 UID: 0 PID: 6001 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-0=
0022-g07866544e410-dirty #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:bpf_verify_pkcs7_signature+0x31/0x190 kernel/bpf/helpers.c:3835
> Code: 41 56 41 55 41 54 53 48 89 d3 49 89 f6 49 89 ff 48 bd 00 00 00 00 0=
0 fc ff df e8 aa b0 e0 ff 4c 8d 63 08 4c 89 e0 48 c1 e8 03 <0f> b6 04 28 84=
 c0 0f 85 01 01 00 00 41 80 3c 24 00 74 3d 48 89 d8
> RSP: 0018:ffffc90002f7fa08 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888020c51cc0
> RDX: 0000000000000000 RSI: ffffc90002f7faa0 RDI: ffffc90002f7fac0
> RBP: dffffc0000000000 R08: 0000000000000018 R09: ffffffff820b8a70
> R10: ffffc90002f7fac0 R11: fffff520005eff5a R12: 0000000000000008
> R13: 0000000000000010 R14: ffffc90002f7faa0 R15: ffffc90002f7fac0
> FS:  00005555895fe500(0000) GS:ffff8881a3c1c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30b63fff CR3: 0000000028898000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  bpf_prog_verify_signature+0x2da/0x3b0 kernel/bpf/syscall.c:2815
>  bpf_prog_load+0xcc4/0x19e0 kernel/bpf/syscall.c:2989
>  __sys_bpf+0x507/0x860 kernel/bpf/syscall.c:6116
>  __do_sys_bpf kernel/bpf/syscall.c:6226 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6224 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6224
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0a4558ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff940250b8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f0a457b5fa0 RCX: 00007f0a4558ebe9
> RDX: 00000000000000a8 RSI: 0000200000000140 RDI: 0000000000000005
> RBP: 00007f0a45611e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f0a457b5fa0 R14: 00007f0a457b5fa0 R15: 0000000000000003
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bpf_verify_pkcs7_signature+0x31/0x190 kernel/bpf/helpers.c:3835
> Code: 41 56 41 55 41 54 53 48 89 d3 49 89 f6 49 89 ff 48 bd 00 00 00 00 0=
0 fc ff df e8 aa b0 e0 ff 4c 8d 63 08 4c 89 e0 48 c1 e8 03 <0f> b6 04 28 84=
 c0 0f 85 01 01 00 00 41 80 3c 24 00 74 3d 48 89 d8
> RSP: 0018:ffffc90002f7fa08 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888020c51cc0
> RDX: 0000000000000000 RSI: ffffc90002f7faa0 RDI: ffffc90002f7fac0
> RBP: dffffc0000000000 R08: 0000000000000018 R09: ffffffff820b8a70
> R10: ffffc90002f7fac0 R11: fffff520005eff5a R12: 0000000000000008
> R13: 0000000000000010 R14: ffffc90002f7faa0 R15: ffffc90002f7fac0
> FS:  00005555895fe500(0000) GS:ffff8881a3c1c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30b63fff CR3: 0000000028898000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   41 56                   push   %r14
>    2:   41 55                   push   %r13
>    4:   41 54                   push   %r12
>    6:   53                      push   %rbx
>    7:   48 89 d3                mov    %rdx,%rbx
>    a:   49 89 f6                mov    %rsi,%r14
>    d:   49 89 ff                mov    %rdi,%r15
>   10:   48 bd 00 00 00 00 00    movabs $0xdffffc0000000000,%rbp
>   17:   fc ff df
>   1a:   e8 aa b0 e0 ff          call   0xffe0b0c9
>   1f:   4c 8d 63 08             lea    0x8(%rbx),%r12
>   23:   4c 89 e0                mov    %r12,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   0f b6 04 28             movzbl (%rax,%rbp,1),%eax <-- trapping in=
struction
>   2e:   84 c0                   test   %al,%al
>   30:   0f 85 01 01 00 00       jne    0x137
>   36:   41 80 3c 24 00          cmpb   $0x0,(%r12)
>   3b:   74 3d                   je     0x7a
>   3d:   48 89 d8                mov    %rbx,%rax
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
> Tested-by: syzbot@syzkaller.appspotmail.com
>

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 596c0fa7fc90..d0d437f38a70 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -2801,6 +2801,9 @@ static int bpf_prog_verify_signature(struct
bpf_prog *prog, union bpf_attr *attr
        else
                key =3D bpf_lookup_user_key(attr->keyring_id, 0);

+       if (!key)
+               return -EINVAL;
+
        sig =3D kvmemdup_bpfptr(usig, attr->signature_size);
        if (IS_ERR(sig)) {
                bpf_key_put(key);

Thanks syzbot!

- KP

> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
