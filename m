Received: from mail-pg1-f179.google.com (mail-pg1-f179.google.com [209.85.215.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CB0CDF71
	for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 08:23:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.179
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755246210; cv=none; b=O2aFTdJ/+o8moilQmFficfj6jrpDsEJ8x3zI8cZn6DOCJHyj4sYdE9my+CS2rH0mP/U/74yeskfMuAVeG34QMI/WKum0t44uGljk2KQ7nP5iB0/tLr3nVhgqGrxBaQmdGwcs1QfF1YdX8kR88Hy8i1hMfnFP+hCEqvcGn28kPu8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755246210; c=relaxed/simple;
	bh=+5P2Wf27dWhQ2s2H9EFcw+oBJt9fykpJNeXflXRoogc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=tC2XXkXh5fOg5bIub4lcC2y1pXq+DR2i4g/99Bmt5tXhUpaig1f3fvjlxnM3+vrRHT80VBMdWU1yILvzQl+vZ5LMCXjQUCIqeJoE1gMvV05sdzFUc+8ltn+Xbco+EUCqCbGN/u3bbHBdNgecb6k4Cputxo1mqayRoB4tYWY8jvg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MrTPdsIz; arc=none smtp.client-ip=209.85.215.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MrTPdsIz"
Received: by mail-pg1-f179.google.com with SMTP id 41be03b00d2f7-b4717554c29so1137304a12.3
        for <syzbot@lists.linux.dev>; Fri, 15 Aug 2025 01:23:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755246208; x=1755851008; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hk+JB767xxDs+iripajyx3BNtWtu5tiFtNJhn5Zx+N4=;
        b=MrTPdsIzpI401SQxkpRTpvcw72d/BAJkpfGFw91vL4qrloEmJlcyC02nTz+ri6CV2o
         Exkq3ddawhgT0MVZxAA8oup0P+r+HTCFS1Wu1tKGl02kf5+XnrrGvD1R27T6RM9w58VC
         hxwlB0tK4Z8u+AktW08yFRO8vRBXD4AIIsazHUBJCJCGLKTDHyxSXFA/dFG44csz1Hmt
         ZTsomYaENkiMLMs0rRLqzYRC9RbwZrFttq7sWiKOvehaRCImMNUHyc5Ocz/IWUySwxhO
         oXuwC44jUnHb9ZAVHfsKdHE9W6rgdFihBe+4HU244bVOgpItHNBuEcOgT410jl+vJ00Q
         qoTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755246208; x=1755851008;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=hk+JB767xxDs+iripajyx3BNtWtu5tiFtNJhn5Zx+N4=;
        b=d+cel+DXNhZ7VDcLyy0N4Ph6AMZ+ToI4GV3jnEyYhOaefuyq7VTBwOu/xkLzsn5COM
         xW1wciwzK0jH0Ce628z3V3dLK74XRSDiZIkQaoZfxFpDy9dWvLwIaF5ww24XvCBznDnt
         B9PBCorehf7A7KMmk3hrQ+1Fx/S04DrrPGs416zAAXO5zNPuOgcq8jkqaolgg1vm8Jzh
         RUK5UIJyzmzKDhZpHiNIgbkmgX5wTuncShixwvMnw6HfQZZ3bZ5UCvxQkQ1Fr+MTpane
         DuTNliWpqp0AZxE6DKgqJ1vnbuSGGEtuHjVzr+kYv+C7egT6a6iPUjPXBfe2ZLtXX46q
         Yf0w==
X-Forwarded-Encrypted: i=1; AJvYcCVZakAUEHl4X7WoQf/154D/cFHfCBhwbNeRErfAPxdFvxbcAK3sJPeeEqDp28ZSKZSwSuNGDO8=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyy2tB/+HtxgCxHXD8pOLjpwMChnCKUa5GEmZnCNbyww0+YiTUJ
	D9b2JbO+TIjm/qYYfrbgkWOqNp9AUqRmOlhqhcAkpNBZZacDRczDNHaafhtvqnjyYT/miF7JPvI
	bwT0+6DQ8SSaxi6Yj7Cbgw5UQWcnSqrRtdPCqORXE53dE+Hu0Ydw2PRCOD5g=
X-Gm-Gg: ASbGncuyBJBc68oQmozHgdQRe/Iu2Vq75VREA26vCTd1ZEwLIiuB04TszcX5yfxf8to
	ZfHBfQyLIDuO9DzxDoe8bRoE+3NMJXVmxM1MlmOTGGZpUdPXVjc0LpxC/X8KeJRPC/QEkJlWZxX
	hkhuDT7jxGy/S5wFpSF0yJ//ERfM47L0ueRU3mM12F0dN1dvNQTUgFbpKfXe5Skgzay03svZvGX
	POzEL4XKqNe0aFZqwKaaX8NWw0nBg/AB43y6JkkYNHMCYs=
X-Google-Smtp-Source: AGHT+IGUYSLOXseHP9i/8bsacveB6QJicUPugu7JA0AsMmqj8wNP7A7YhUPwuoiLStO7C6WsTVPjAvEBLDO07iKfBnM=
X-Received: by 2002:a17:903:388c:b0:240:c9b6:f8ee with SMTP id
 d9443c01a7336-2446d980bacmr15231365ad.50.1755246208045; Fri, 15 Aug 2025
 01:23:28 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <689e839d.050a0220.1b2f6c.0001.GAE@google.com>
In-Reply-To: <689e839d.050a0220.1b2f6c.0001.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 15 Aug 2025 10:23:16 +0200
X-Gm-Features: Ac12FXyrzT-crdbIUn4PVzwivLrNgVjbas6vJ1SghmP_PxOrNzPEMEMBSb8z9nQ
Message-ID: <CANp29Y40XgjQRkxhix1wUaeA9WTvQrJRoQ0Tpc-03PH29oEkKw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Use tnums for JEQ/JNE is_branch_taken logic
To: syzbot ci <syzbot+ci2ba5e1eb47e138d7@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Aug 15, 2025 at 2:47=E2=80=AFAM syzbot ci
<syzbot+ci2ba5e1eb47e138d7@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] bpf: Use tnums for JEQ/JNE is_branch_taken logic
> https://lore.kernel.org/all/ba9baf9f73d51d9bce9ef13778bd39408d67db79.1755=
098817.git.paul.chaignon@gmail.com
> * [PATCH bpf-next 1/2] bpf: Use tnums for JEQ/JNE is_branch_taken logic
> * [PATCH bpf-next 2/2] selftests/bpf: Tests for is_scalar_branch_taken tn=
um logic
>
> and found the following issue:
> WARNING in reg_bounds_sanity_check
>
> Full report is available here:
> https://ci.syzbot.org/series/fd950b40-1da8-44b1-bd12-4366e4a354b1
>
> ***
>
> WARNING in reg_bounds_sanity_check
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      07866544e410e4c895a729971e4164861b41fad5
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/c4af872a-9b42-4821-a832-941921acc=
063/config
> C repro:   https://ci.syzbot.org/findings/8dfae15e-cda5-4fa6-8f95-aab106e=
bd860/c_repro
> syz repro: https://ci.syzbot.org/findings/8dfae15e-cda5-4fa6-8f95-aab106e=
bd860/syz_repro
>
> verifier bug: REG INVARIANTS VIOLATION (true_reg1): range bounds violatio=
n u64=3D[0xffffdfcd, 0xffffffffffffdfcc] s64=3D[0x80000000ffffdfcd, 0x7ffff=
fffffffdfcc] u32=3D[0xffffdfcd, 0xffffdfcc] s32=3D[0xffffdfcd, 0xffffdfcc] =
var_off=3D(0xffffdfcc, 0xffffffff00000000)
> WARNING: CPU: 0 PID: 6007 at kernel/bpf/verifier.c:2728 reg_bounds_sanity=
_check+0x6e6/0xc20 kernel/bpf/verifier.c:2722
> Modules linked in:
> CPU: 0 UID: 0 PID: 6007 Comm: syz.0.17 Not tainted 6.17.0-rc1-syzkaller-0=
0022-g07866544e410-dirty #0 PREEMPT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:reg_bounds_sanity_check+0x6e6/0xc20 kernel/bpf/verifier.c:2722
> Code: 24 20 4c 8b 44 24 60 4c 8b 4c 24 58 41 ff 75 00 53 41 57 55 ff 74 2=
4 38 ff 74 24 70 ff 74 24 40 e8 1f 30 aa ff 48 83 c4 38 90 <0f> 0b 90 90 48=
 bb 00 00 00 00 00 fc ff df 4d 89 f7 4c 8b 74 24 08
> RSP: 0018:ffffc9000294ef08 EFLAGS: 00010282
> RAX: 98d8a1179b385100 RBX: 00000000ffffdfcc RCX: ffff888020fb5640
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000002
> RBP: 00000000ffffdfcd R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffffbfff1bfa1ec R12: ffff88803dbe4258
> R13: ffff88803dbe4278 R14: ffff88803dbe4290 R15: 00000000ffffdfcc
> FS:  000055557043b500(0000) GS:ffff8880b861c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f985e5b7dac CR3: 000000010f3be000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  reg_set_min_max+0x214/0x300 kernel/bpf/verifier.c:16338
>  check_cond_jmp_op+0x1625/0x2910 kernel/bpf/verifier.c:16772
>  do_check_insn kernel/bpf/verifier.c:19960 [inline]
>  do_check+0x6751/0xe520 kernel/bpf/verifier.c:20097
>  do_check_common+0x1949/0x24f0 kernel/bpf/verifier.c:23265
>  do_check_main kernel/bpf/verifier.c:23348 [inline]
>  bpf_check+0x1746a/0x1d2e0 kernel/bpf/verifier.c:24708
>  bpf_prog_load+0x1318/0x1930 kernel/bpf/syscall.c:2979
>  __sys_bpf+0x528/0x870 kernel/bpf/syscall.c:6029
>  __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f985e38ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd45036968 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f985e5b5fa0 RCX: 00007f985e38ebe9
> RDX: 0000000000000048 RSI: 00002000000054c0 RDI: 0000000000000005
> RBP: 00007f985e411e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f985e5b5fa0 R14: 00007f985e5b5fa0 R15: 0000000000000003
>  </TASK>
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
> [andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.ne=
t eddyz87@gmail.com paul.chaignon@gmail.com shung-hsi.yu@suse.com yonghong.=
song@linux.dev]
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
-upstream-moderation/689e839d.050a0220.1b2f6c.0001.GAE%40google.com.
