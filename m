Received: from mail-oa1-f45.google.com (mail-oa1-f45.google.com [209.85.160.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59B7C3BD654
	for <syzbot@lists.linux.dev>; Thu,  7 May 2026 20:24:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.45
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778185492; cv=pass; b=X0I5hw0zO/StMv7vBRK79gqxMXYVGDN0i5BSLSX3GIdzixXQzGdRd7U7Uucx2CildUdRW7ZwdqDfYpLOF+fY4gdprF5MeEzAj+aemGlHxopp4XS75nGfPso/GKx8VxhHu8qOVidHL/EJLD1f1L5wUl84Mhxrk2b96/iIFwy/8RY=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778185492; c=relaxed/simple;
	bh=xt6F0jtchSVrGMt4rSCEgWye1GEy+Xg11d6FJqhOy7U=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=qfm/2+3l7jyeGK/k3+5WeKYYB1MoAxhD3Oe/V+VnkSXPGbwm81wyY36n12tEVkrgKh+MGfLkUn1sni66ozdd/8xehTsf+PukDNyAgQiFKf8Cqrf4v0X3wTqCZ3i8gUuxTWbhlbxnJBJeaSwnuaxW7WVwSD7vcwbTEvXlolRYEHI=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=b3Psa/B5; arc=pass smtp.client-ip=209.85.160.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="b3Psa/B5"
Received: by mail-oa1-f45.google.com with SMTP id 586e51a60fabf-40ea611d1a4so558693fac.2
        for <syzbot@lists.linux.dev>; Thu, 07 May 2026 13:24:50 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1778185489; cv=none;
        d=google.com; s=arc-20240605;
        b=JG/JZ1bvQH1jFIyU1Zv7cPHOMuDcHORwrU13AI2A0StMqAl1AcR9Bp094jIHSjytkj
         UKajxE0dfHE0dANt2xXcmtqU/VavWisFqgmtbLjwjaVVEkdCPBDqEUt9I+OAoprBhQd4
         hRiXGrHFvGC1FRkM58XEbl0beA00BzSafQCvTc640sQBRCBP9548aOxWcjLna1qefgXo
         F3e5gBzNqLAGab4SFvMZm0FqnKfA7bbnQGSv+Un9s8OWNovJA6+9yLLxNgRf9JOKflTt
         3sT/8BOQzu0tMNtF+ps/hm1G+lp1JAS9CmWR26MzKOQJEhYTjJMBCoEnGCs0OyMDfiy5
         1Cqg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=J38pEhV1CcMk7qDu9fqMl20lwE5JnCjXtdOs4nLf5n4=;
        fh=ewTSLA9ymKeIcCELj/oloA98dPh7nrAJ3kmO22q/Iu8=;
        b=XpaaMLMxDcU2OCMM9CP7PS9CVxDDTZahucnJlJ8WA0ct58hzvhYTVDRM+oITzfqJCQ
         t0PNT98L5sDmVm5SM8k6ZtzjN0rtanlpDS32mOhWQLMrYQqXzdZSMxuJoGi21dOcjlvU
         OgbNyIIHQ89TzHvf6PESBhmIfojEMvNPS/1dLDIUhUTrXlqN0bs7M+Nk746NJ0Uacpik
         4wl+xX4ZQbtwJw6gG2fyW5Q6H6N9ZYWJnSZ2ZQg3ow7zshvUYpTtsG5t/LjxVu4XDXCx
         qeglq+t640j+qfKhV2qXOeMgKvCkocoxmuwqj8litQeP3c+Ar/PlY5Nwz79w+vt+nkbF
         g7ew==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1778185489; x=1778790289; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J38pEhV1CcMk7qDu9fqMl20lwE5JnCjXtdOs4nLf5n4=;
        b=b3Psa/B5YYo6eyayubRmF6VxB81ZcM6YFosxdfg8DpdZ2y/USww1MVUlrOt4VMbYNM
         AaMs3Ei91+ktsvr7R5YkHSssa4vTfXSPHW2aKb8UlaB72Vvq/3E4cjnX+ud1WT5WDw18
         psBxYi9QCYbCay/XR4TNkmGKGirxkBXHfoETykoNATNQs0hi164Ve0ahdRmapqoJCrXb
         Ei3DpO+NcbkcQnUkWgckEv9v5CVmHaCKD5maoXNlOHdke+Aqe320f/XLfTFDQ+GCJayT
         lclw0pRY+XECEQx3/U5S0FzdDee9ITTmUPcwYqAP1i6gSTEn6UyLCMGcC2oJxYfkqi7E
         DDag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1778185489; x=1778790289;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=J38pEhV1CcMk7qDu9fqMl20lwE5JnCjXtdOs4nLf5n4=;
        b=KRcQl4zwbxUl7wBSqh4ea5VCvlhMUpd3F/POntCF38loshlHg1Qbsa1/QEekN9RWYT
         o7DN9NK/rn+itsf4+0Xub7TqduBnqBzIWH6YFIHh7OIFHXfdH+9ngPMxXvmFqNVjFS8L
         s93EllRCuqr1haYceJpNTAqC6BFqrdEfXGI4H8w0HPFxIHhRgkjaQ4xJnbdBsBJtUg91
         DVU5MFzzGkYYbtMFBYEbnEeo+qqo/t+c23NhCzuzlQB9pgT6DikkZ8MFVu3ZZMAY/ktj
         cOx0PipglmaN3Blkxd2/e++cgacElf+HopYfP7rlMEhKvOTE2ny8q3hAdrnj9zAU5xRd
         uZMA==
X-Forwarded-Encrypted: i=1; AFNElJ/5TnJNTDD9+Palqf1yW8px5buqEnS524hz7Mo32Enr2y51uOdpNHwyJa/PgTsEJXQPhKoV5f4=@lists.linux.dev
X-Gm-Message-State: AOJu0YwDPa358X2O1ycG1T9n7Mm8CS1HzBAzdBQl2Ma3Ql/ioKaQO8j1
	2/kaETlpy9ARsUXo/9+m8DR9pgoEcz1pHpPqrH4WKyvUlBNCGkOQGsggglbNZPADGaKQ6eT/xin
	+Td8u0nOTTJK4cb/pRGCMy9GXQIlcQwPaxKfLoH3T
X-Gm-Gg: AeBDiesPs8h4WipTnOYug4ZanlKpbT8nzsFfCXoPMgh+VqTGf3h17yUSm8PfuzznpW2
	czNkbua5dZ9XKV2AGSQwViyb/+xM3bRZfl+8s70wNeiQbpUNzoS3JrrU8HR3X5y4uUEEDtXaJIm
	UDZSkeQy6aWbC3Wy5BiTr4jUyYLaTt2Yl6adTZg75DaQxjjYEPdTe6qkTK1P/4cX6qxnCYL0GQC
	p48+whOhJvCYd5XTR3CswxV+WWfbo1z+brs8tGa52VBDj920W281h4mrPLPEsbQxrvFFLlj6ck8
	qVUEV6ARZdjFuNicxyFRSk76nLkscrUKw6r6ljTiUuQ6xcHW8nctAbb4v+xf5tAYJI03LXFvD/x
	zrcCgyWk=
X-Received: by 2002:a05:6871:a60b:b0:417:6224:5855 with SMTP id
 586e51a60fabf-434f4e8e8b9mr6000792fac.0.1778185488646; Thu, 07 May 2026
 13:24:48 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69fccc48.050a0220.3cf765.035b.GAE@google.com>
In-Reply-To: <69fccc48.050a0220.3cf765.035b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 7 May 2026 22:24:37 +0200
X-Gm-Features: AVHnY4JasLvsuM4Drjj4W1FAUuO3DFGSEvRrR2FXOv5FqlroGMW-N96S2HgV3e8
Message-ID: <CANp29Y6BJwQvujT+tbaEMABr=c-rTG_n6HcU8ogHZqmr7dnAYw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/vmalloc: free unused pages when shrinking
 vrealloc() allocation
To: syzbot ci <syzbot+ci1936964899135e53@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, May 7, 2026 at 7:30=E2=80=AFPM syzbot ci
<syzbot+ci1936964899135e53@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm/vmalloc: free unused pages when shrinking vrealloc() allocation
> https://lore.kernel.org/all/20260507114854.41117-1-jillravaliya@gmail.com
> * [PATCH 1/2] mm/vmalloc: free unused pages when shrinking vrealloc() all=
ocation
> * [PATCH 2/2] selftests/mm: add test for vrealloc() shrink page freeing
>
> and found the following issue:
> kernel BUG in __vunmap_range_noflush
>
> Full report is available here:
> https://ci.syzbot.org/series/13b0874e-a9f8-4992-be93-e93cc88e5e44
>
> ***
>
> kernel BUG in __vunmap_range_noflush
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      2c340aab5485ebe9e33c01437dd4815ef33c8df5
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/625f7138-9b20-4205-b0e7-02ed1219b=
d31/config
> syz repro: https://ci.syzbot.org/findings/13e8dc07-d697-4345-a27f-319e9c1=
fe3d6/syz_repro
>
> ------------[ cut here ]------------
> kernel BUG at mm/vmalloc.c:488!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 5824 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__vunmap_range_noflush+0xb4d/0xb70 mm/vmalloc.c:488
> Code: 00 e9 64 f5 ff ff e8 12 8d a6 ff 48 c7 c7 a0 0e a8 8e 48 8b 74 24 4=
8 48 89 da e8 0e c5 cf 02 e9 67 f5 ff ff e8 f4 8c a6 ff 90 <0f> 0b e8 ec 8c=
 a6 ff e9 53 ff ff ff e8 e2 8c a6 ff bb 02 00 00 00
> RSP: 0018:ffffc90003b575e0 EFLAGS: 00010293
> RAX: ffffffff821f16bc RBX: ffffc900036fa000 RCX: ffff8881072a1d80
> RDX: 0000000000000000 RSI: ffffc900036fa000 RDI: ffffc900036fa000
> RBP: ffff88816ebb3980 R08: ffff88810007f1bb R09: 0000000000000000
> R10: ffffc900036f9bb0 R11: ffffed102000fe38 R12: 0000000000000001
> R13: ffffc900036fa000 R14: ffffc900036fa000 R15: dffffc0000000000
> FS:  00007f4d6b8c46c0(0000) GS:ffff8882a9293000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055924f0dd8c0 CR3: 00000001057f2000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  vunmap_range_noflush mm/vmalloc.c:506 [inline]
>  vunmap_range mm/vmalloc.c:521 [inline]
>  vrealloc_node_align_noprof+0x4fc/0x880 mm/vmalloc.c:4346
>  bpf_patch_insn_data+0xeb/0x10a0 kernel/bpf/fixups.c:254
>  bpf_convert_ctx_accesses+0x213f/0x2d70 kernel/bpf/fixups.c:974
>  bpf_check+0x2b8e/0x49f0 kernel/bpf/verifier.c:20094
>  bpf_prog_load+0x1406/0x1a10 kernel/bpf/syscall.c:3082
>  __sys_bpf+0x618/0x950 kernel/bpf/syscall.c:6248
>  __do_sys_bpf kernel/bpf/syscall.c:6361 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6359 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6359
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4d6a99cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f4d6b8c4028 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f4d6ac15fa0 RCX: 00007f4d6a99cdd9
> RDX: 0000000000000048 RSI: 00002000000054c0 RDI: 0000000000000005
> RBP: 00007f4d6aa32d69 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4d6ac16038 R14: 00007f4d6ac15fa0 R15: 00007ffff714fc08
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__vunmap_range_noflush+0xb4d/0xb70 mm/vmalloc.c:488
> Code: 00 e9 64 f5 ff ff e8 12 8d a6 ff 48 c7 c7 a0 0e a8 8e 48 8b 74 24 4=
8 48 89 da e8 0e c5 cf 02 e9 67 f5 ff ff e8 f4 8c a6 ff 90 <0f> 0b e8 ec 8c=
 a6 ff e9 53 ff ff ff e8 e2 8c a6 ff bb 02 00 00 00
> RSP: 0018:ffffc90003b575e0 EFLAGS: 00010293
> RAX: ffffffff821f16bc RBX: ffffc900036fa000 RCX: ffff8881072a1d80
> RDX: 0000000000000000 RSI: ffffc900036fa000 RDI: ffffc900036fa000
> RBP: ffff88816ebb3980 R08: ffff88810007f1bb R09: 0000000000000000
> R10: ffffc900036f9bb0 R11: ffffed102000fe38 R12: 0000000000000001
> R13: ffffc900036fa000 R14: ffffc900036fa000 R15: dffffc0000000000
> FS:  00007f4d6b8c46c0(0000) GS:ffff8882a9293000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffdaf55afd8 CR3: 00000001057f2000 CR4: 00000000000006f0
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
> [akpm@linux-foundation.org jillravaliya@gmail.com linux-kernel@vger.kerne=
l.org linux-mm@kvack.org urezki@gmail.com]
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
-upstream-moderation/69fccc48.050a0220.3cf765.035b.GAE%40google.com.
