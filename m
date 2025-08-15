Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709B7184540
	for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 08:24:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755246252; cv=none; b=U5vZl6m+wuBsxacW8GantyPTJzqSCvZRgFLkDKG7M7McVl/gQd7WQpTH0PT+vr9FfaE4Kl19bITwx9GrIiDkzHbqG6m75Ru1ZQLzbFt1mnWWb9fhlvREeIzLEHMyCKX1jY9t3SOLhqBtWBQP2jv4YwSOWprG9Rb34oK4SqgjJYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755246252; c=relaxed/simple;
	bh=/7rsHYSOfy9C/DfQF8ZWc4K0kPVa/lyNGepZFw7N7x0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gbddyKDLVqMVql6pYIT1yUvc4LdqHuOsqZ1qBEGJoW2DFL0tw5zyJNm01e3S7F/qdOs/3uF34TYTUX39TlrxMopqiURzVC2h9WR5tE9dtxVm6jw54/z4UKSEBnaRjYiL4WoZ7XzDAPrD6caxMyTWwKJ0wXJq77epudGs/otizVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CGldbWGY; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CGldbWGY"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24458263458so15656815ad.3
        for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 01:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755246249; x=1755851049; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=/P4CP1cw4+kxaDGbJiMOyLgfkmD5JdchpkFjO/WmRDg=;
        b=CGldbWGYJW2MgtpcKT5Kdb1BnWRC30tzZBMDJrQIEW+o+cL5+CSD102528ASfUWMXn
         9UWid4j7aIMhW3Ghn+AO3lJRi4h3vQMxhGmoSpSziXRFVP3whLdBvVrxjtINVL0YHShp
         mpyQkADXo8nOwwynKzsFdACaYxQhkwYZCDJboRxCJb/6siu9j/1XcOwkSlMiEsUDKDBZ
         Dje+fZdUGMeC9QagjZBjjDyQ9pazLGZAnIdT3d4ddW+fFPgYvwhJxOZGZI+qN9IyK3L5
         R8bwo0QmZ//h59k0wIB06Nw0Ys1KxCmjnc+hBq5tEO5EBafig0U0MbJaR0wc2uikm5s4
         OklQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755246249; x=1755851049;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=/P4CP1cw4+kxaDGbJiMOyLgfkmD5JdchpkFjO/WmRDg=;
        b=NIRRwvrLfH5LsCO7FHs6fj1MhK2AH86/+1ZHwcloZNwzDlYJ6t5Kl9RcmM+IlBQF/U
         aqn4UqFJKaeccqaPyxZTlpBzfl9yld5s3UghT+bzAliG8Wzr2GBdsklR/w+TNI8/bhwP
         OJSSl4YDQSyrpxlqUC+RCQWkSqoGd4epX2+wU3rw39rL40IWVBuB8KY41EhdClnsJuEB
         SUwUv8YqeaoCEThZyTJeBKm8SaXN4FTqnPMN45zYUyxxjjW7Qd2mWCXr2o/RjOTfSmNu
         zQK86d1r03KD2FN9hgCamkO3vLGq4UfRI1LvvU08x2XAWpBjz78gk3dPBQN3iDOAjHOU
         3tYw==
X-Forwarded-Encrypted: i=1; AJvYcCU9FdLcIWSOieNE8AmbePJOO+mSCPY82Q2rNV4EpCtrUzUugR8Y6Xntt71c5//WAX6gRZttmvw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/e7bESV8MITaEM6A1RnxEdtWqYOUApiQP4G61KEzmxxe73m9k
	n5XcKHCH/e1EiPYF9tl4ggeCBRDpH+SnakbQuwfLjqU2yzuGN59YIHXSGtOsY6mVCaARXnc4J9k
	K4Edd1EsAkIn1V9QJ8fZMfD8XBjabj05AYKzrCihn
X-Gm-Gg: ASbGncsh4Bb03VOYoMefiRIdj4CY5HSFWO/5YgjmGDuJsHzhU8FWHATBlknyBoBMsQ1
	adkTjPL2D+bqJCyztHB7RnclkPxHMtszIe+4uifPNJcD033gnqougfBsJYeE7OL2GU/KLtkwaiC
	YhhfvnfF6h2D09416my/Eee+7c3Pj19BthBwiLhwpSvZvBgR1NHSJbnU7fVCQAvPy8IPlMKsHBM
	8q97cbcojaNqKHorpdraVGOmVpmtIAb4Qh2T4xaaSzP97GmNkQtNGMvDg==
X-Google-Smtp-Source: AGHT+IGUukqDG4X6E1laidmh8JzK0nb4rpJsnGdy4mp5mD/zKzrehVMKjioURD/kaTFSRolRgifKmMzD+t+HKdbsF5U=
X-Received: by 2002:a17:902:f54f:b0:23f:cd6e:8d0f with SMTP id
 d9443c01a7336-2446d71ab4bmr17567295ad.13.1755246249130; Fri, 15 Aug 2025
 01:24:09 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <689ed484.050a0220.e29e5.000a.GAE@google.com>
In-Reply-To: <689ed484.050a0220.e29e5.000a.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 15 Aug 2025 10:23:57 +0200
X-Gm-Features: Ac12FXywV4rm7yrhMFN3iMmz-kGdWhH_Qj3MamU9_vq1AGQK6WOX4uQTgn9K_R4
Message-ID: <CANp29Y6+81oWYZPfNts=qLFmfBHv1L33ULfrjU7kzbxOrT+S7A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Signed BPF programs
To: syzbot ci <syzbot+ci4c6e7e1421addc1d@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Aug 15, 2025 at 8:32=E2=80=AFAM syzbot ci
<syzbot+ci4c6e7e1421addc1d@syzkaller.appspotmail.com> wrote:
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
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
> The email will later be sent to:
> [andrii@kernel.org ast@kernel.org bboscaccy@linux.microsoft.com bpf@vger.=
kernel.org daniel@iogearbox.net kpsingh@kernel.org kys@microsoft.com linux-=
security-module@vger.kernel.org paul@paul-moore.com]
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
-upstream-moderation/689ed484.050a0220.e29e5.000a.GAE%40google.com.
