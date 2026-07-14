Received: from mail-qt1-f178.google.com (mail-qt1-f178.google.com [209.85.160.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70DC33016F7
	for <syzbot@lists.linux.dev>; Tue, 14 Jul 2026 06:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.178
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784009325; cv=pass; b=FVlRRcqJhwUHJN80NL1+e7FJT6kTnMG8KmLOnVmYaQ8ZjSfiwmyIHL0aRLU1R3G23OG7P38aLU30eoDr3BpETNXJ5jqGHh+GCD7af+mW1iK13hyN7qDhmkBmCEIO2+EDF4pWU93PzIwFnUgCVJ+nNDnQP6vN2zbeTgP/BlIyFgA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784009325; c=relaxed/simple;
	bh=QlnpEY2nLtwYlblmUD8ozC5ibC1oDzanmhMxj0nMOyU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MtRzg7YHoMLlWa3UFhK8MCoDcbXwXoBBA3q/o9LtqhT+8kC5gC5nA8rRSpLqtu6Tzg2/Cwl7VkQOEOfUnAv7+8YlYblXv7Ir2ozcuqYlkr2DNhthDhGesHw0EpbFRXUEppJKfplA7EvbUUoiO8F3Zgk9zAEVw0m861hPi0I26ew=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=NzbpvN/4; arc=pass smtp.client-ip=209.85.160.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="NzbpvN/4"
Received: by mail-qt1-f178.google.com with SMTP id d75a77b69052e-51bfa429aa6so4015401cf.0
        for <syzbot@lists.linux.dev>; Mon, 13 Jul 2026 23:08:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784009322; cv=none;
        d=google.com; s=arc-20260327;
        b=sR0RKMR9xQD5PU0chYwkqSQcwnD7ps2U2gZWsiL12VkILNNFBO1KQuA/3fygrVcGIy
         twOlgACdQVOZA8I8Btk8GrSqHkqs3IsclF+KtgyDd1zFhHEuVrXcbBZYnXrlStXaiqcF
         VSSj/b7hlTjnpTLgZ048BTjdxwjGOV4m92uiOyMQXUUFRyXJFqWwKDBEz0IB7F8G0Jvv
         f0Cmg91PcckTYGZJiBMFqlSAQnCRkL0PC5UQsp8aZJnZsmAQdRbsdDXG6ZoZC5V7M1fV
         slqO956TbJGcCt/PVdDOYBTodSolilQQOKnZjsNJ1hcP3zS5iUDjRfhLMohlmsqGu7gB
         xqJw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=p6HRTzW9BXddcpXvWqWOZi73jnPxt7f0tCr/NJ2UkvE=;
        fh=SFJDp3AKIwl1Fs5bPjrgvmOaFJ+hQtwmfSTxlvKRnXw=;
        b=CJ3Rr+N8F08Cz6MKBV7vnHGYR6NcfwmMuJk96Y9cCxu0/EaXKQIXfpLgNzJCyujvD/
         kxDvbjmUuaG7I6+K2o00ul+UPahWDe+sBHv+mJcFnhH6hBLLbd1AMcxzf/uOtOd0hI5+
         ekZL0JEb+UqLK4kCo07eqYzKf7bWMEIiDQAfagn/FqSJElR+Mj0iE9jPfBYT7vwhnr3E
         69PlUQJqnCa9WJvuRnX3rbl4x1G6nzjjT1/zkayEI3j0wnFbAxwN8jgjHo00cmyRN9xK
         navfxHsSmWU9C0Is6AiaXPJ24I8AAcy7elCUzxU2RDY1XQr/BhP+4hOF1uQoPJLnW06R
         1GVg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784009322; x=1784614122; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=p6HRTzW9BXddcpXvWqWOZi73jnPxt7f0tCr/NJ2UkvE=;
        b=NzbpvN/49HaMbLeL35yPahR1c3HCspDy6gjCEqDGhSFXBz2LgsWgz2PxVFfMVTxAI0
         hauOsKsCiPrs9E3p7rAFxrBp77plurmL3gOWGYQltlLZ4mFAKgul+KZ7OK/WRPcDAdwl
         H8fbCCd33Etz4idYQysR0w/drqsVyov7MtUOtyovsbagXaihmBD2zreFt3g8+xjz5rmw
         DERi9Voty9SufBH4oT/LKsyGI1qGZNK4lPVYEtdpbro0X1DvFo+rbzfSBecpLg/dAM0U
         xcx4XcMSaj2Bv65NMLCJtDS0LwztpAGI6mCv/g9vqpB6K0/nAXjo6MT37y0byNj4Q1Eo
         kFOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784009322; x=1784614122;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=p6HRTzW9BXddcpXvWqWOZi73jnPxt7f0tCr/NJ2UkvE=;
        b=osMHF5ISQEnhRmB6mvC8PKg7SN/c7rK+/JdO7e9mS+zI7g6nksjEFsaSqrACS/NQvh
         44KfbqKJIp8sCBCc9ChZWwSalUCAe5veRRi2x93EyW+pWPZDVraeYBtJ3plDlZfqQAxt
         eNA9ifRL/6frML/gBtUDZ0XxhHp8z0Rf6HZ6gATBGzB5O72H+0o9I9XxesesPF2wtWVn
         fbOWMNZ3Ct0fcgU10bW3blTQMJ21JXIxyOdqUbnx5aby9rUHuIAMBxHvFYkzM5NelIMQ
         3XC/sVgISYd37lUKIWXRqR9UdjA+EydJflgJaVlsrjhkyX2x0vIWzsTzyUYnysjZM8LR
         mK1A==
X-Forwarded-Encrypted: i=1; AHgh+RptAfMKqjllCROMi1LS77ghGKyZVelNTYC8xvg3uiqq8U/whHZFxp7+JuJXS0AMoYdMm+v3irA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxd+L0zaIAvFEjPp+lNXBaMLJC3bYlla8eKOYeJrhM2lIvVb01J
	ZT8OFENFyMKViC8u+6XeLfC+vr0XehbPJ1JHow5sT3dPz2z1dLClr24nPDiRxRwN2rDrJBGYwQO
	4+4zY51dg/yD1so6mmoMhlXXunkSwsivi0+Rzp9o6VJyUg0GnZJr+5pGK
X-Gm-Gg: AfdE7ckPIzFaaxpZjbpRmVHXUR8NiYOTkUaYISvMNoatOYjV4QyT1u3KVsb/mlzgVEO
	GWtALBpTpGXUc2cuJhwWwQVv9vb1O9Ups8vKYkEwwxq5MP3BOq4saA9/52SxCg7DcfJmDx7z1TL
	11xHLCWhJbAU71jszokdJqhPA79dbYOKM0BNDuREVWQAsUbOzqmizmCfTpyzUWNSl0yyBB4D1Gf
	QPjC3xNPpD5w1/MfwKot7xRmbHc5DblF560ZavXyRalh2zXM1GjMNFltWUi81qTySGidfbxqRjW
	RUpx0Mymt06AO20oVQtE7i7Q7wDsIT3g5IDyDNIQqzvGLH2dPlEcATU1aXCS1eg=
X-Received: by 2002:ac8:590b:0:b0:517:146d:2cb5 with SMTP id
 d75a77b69052e-51caa1275b5mr161130051cf.20.1784009321742; Mon, 13 Jul 2026
 23:08:41 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a558493.c90005c7.37d349.0010.GAE@google.com>
In-Reply-To: <6a558493.c90005c7.37d349.0010.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Tue, 14 Jul 2026 08:08:29 +0200
X-Gm-Features: AUfX_mw3b2NhHZdMX98dqkOOqAoDeJvPu78WJ2LS2OM84cK9aIlNJhQJvmx_yqg
Message-ID: <CAJWNTGwyAg8tKyk=LJ2GvdhtcJ1aCRz7oii+FXifptjZMnzhZg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Redesign Verification Errors
To: syzbot ci <syzbot+cice1532664a7f7405@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Jul 14, 2026 at 2:36=E2=80=AFAM syzbot ci
<syzbot+cice1532664a7f7405@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] Redesign Verification Errors
> https://lore.kernel.org/all/20260713153910.2556007-1-memxor@gmail.com
> * [PATCH bpf-next v3 01/17] bpf: Add verifier diagnostics report helpers
> * [PATCH bpf-next v3 02/17] bpf: Add source and instruction diagnostic co=
ntext
> * [PATCH bpf-next v3 03/17] bpf: Add verifier diagnostic event log
> * [PATCH bpf-next v3 04/17] bpf: Prune verifier diagnostics when switchin=
g paths
> * [PATCH bpf-next v3 05/17] bpf: Track verifier register diagnostic event=
s
> * [PATCH bpf-next v3 06/17] bpf: Track verifier reference diagnostic even=
ts
> * [PATCH bpf-next v3 07/17] bpf: Track verifier context diagnostic events
> * [PATCH bpf-next v3 08/17] bpf: Report Register Type Safety errors
> * [PATCH bpf-next v3 09/17] bpf: Report Memory Safety bounds errors
> * [PATCH bpf-next v3 10/17] bpf: Report Resource Lifetime reference leaks
> * [PATCH bpf-next v3 11/17] bpf: Report Call Type Safety argument errors
> * [PATCH bpf-next v3 12/17] bpf: Report Execution Context Safety errors
> * [PATCH bpf-next v3 13/17] bpf: Report Program Structure CFG errors
> * [PATCH bpf-next v3 14/17] bpf: Report Policy helper and kfunc errors
> * [PATCH bpf-next v3 15/17] bpf: Report Verifier Limit errors
> * [PATCH bpf-next v3 16/17] bpf: Report Verifier Internal errors
> * [PATCH bpf-next v3 17/17] bpf: Gate verifier diagnostics on log level
>
> and found the following issue:
> WARNING in bpf_diag_record_mod
>
> Full report is available here:
> https://ci.syzbot.org/series/60c41043-96fb-4c6b-bc8e-3ddab76db3ec
>
> ***
>
> WARNING in bpf_diag_record_mod
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      9a3a07d06e7d74f4aecc51396c771149336ac55d
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/bb13c0f7-c05e-4ad3-b3f3-365157b56=
0a0/config
> syz repro: https://ci.syzbot.org/findings/fa0ac02b-def4-401c-ac09-aea8fa6=
688a1/syz_repro
>
> ------------[ cut here ]------------
> 1
> WARNING: mm/page_alloc.c:5280 at __alloc_frozen_pages_noprof+0x2ce/0x380 =
mm/page_alloc.c:5280, CPU#0: syz.0.17/5810
> Modules linked in:
> CPU: 0 UID: 0 PID: 5810 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__alloc_frozen_pages_noprof+0x2ce/0x380 mm/page_alloc.c:5280
> Code: 74 10 4c 89 e7 89 54 24 0c e8 4e 2c 0e 00 8b 54 24 0c 49 83 3c 24 0=
0 0f 85 ab fe ff ff e9 ac fe ff ff c6 05 74 45 f6 0d 01 90 <0f> 0b 90 e9 17=
 ff ff ff a9 00 00 08 00 48 8b 4c 24 10 4c 8d 44 24
> RSP: 0018:ffffc90003abef40 EFLAGS: 00010246
> RAX: ffffc90003abef00 RBX: 000000000000000b RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90003abefa8
> RBP: ffffc90003abf040 R08: ffffc90003abefa7 R09: 0000000000000000
> R10: ffffc90003abef80 R11: fffff52000757df5 R12: 0000000000000000
> R13: 1ffff92000757dec R14: 0000000000440cc0 R15: dffffc0000000000
> FS:  00007f71b81f66c0(0000) GS:ffff88818dc0e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b33463fff CR3: 000000016f8e4000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  alloc_pages_mpol+0x212/0x380 mm/mempolicy.c:2490
>  ___kmalloc_large_node+0x4c/0x120 mm/slub.c:5302
>  __kmalloc_large_node_noprof+0x18/0x90 mm/slub.c:5333
>  __do_kmalloc_node mm/slub.c:5350 [inline]
>  __kmalloc_node_track_caller_noprof+0x164/0x730 mm/slub.c:5497
>  __do_krealloc mm/slub.c:6865 [inline]
>  krealloc_node_align_noprof+0x19a/0x390 mm/slub.c:6886
>  _krealloc_array_noprof include/linux/slab.h:1213 [inline]
>  diag_append_history kernel/bpf/diagnostics.c:464 [inline]
>  bpf_diag_record_mod+0xcbc/0x1590 kernel/bpf/diagnostics.c:1666
>  check_alu_op kernel/bpf/verifier.c:16428 [inline]
>  do_check_insn+0x1125c/0x1b4a0 kernel/bpf/verifier.c:18578
>  do_check kernel/bpf/verifier.c:18817 [inline]
>  do_check_common+0x416c/0x5930 kernel/bpf/verifier.c:19902
>  do_check_main+0x63/0x1f0 kernel/bpf/verifier.c:19994
>  bpf_check+0x25df/0x2cb0 kernel/bpf/verifier.c:21502
>  bpf_prog_load+0x13ec/0x1ac0 kernel/bpf/syscall.c:3118
>  __sys_bpf+0xd0d/0xd90 kernel/bpf/syscall.c:6339
>  __do_sys_bpf kernel/bpf/syscall.c:6458 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6455 [inline]
>  __x64_sys_bpf+0xba/0xd0 kernel/bpf/syscall.c:6455
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f71b8b9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f71b81f6028 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f71b8e15fa0 RCX: 00007f71b8b9ce59
> RDX: 0000000000000094 RSI: 0000200000000b00 RDI: 0000000000000005
> RBP: 00007f71b8c32e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f71b8e16038 R14: 00007f71b8e15fa0 R15: 00007ffe3ec24ce8
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.ne=
t eddyz87@gmail.com emil@etsalapatis.com kernel-team@meta.com kkd@meta.com =
memxor@gmail.com]
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
-upstream-moderation/6a558493.c90005c7.37d349.0010.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
