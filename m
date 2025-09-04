Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FF2E20296E
	for <syzbot@lists.linux.dev>; Thu,  4 Sep 2025 18:07:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757009234; cv=none; b=XSfzG7DtZ+eQV6W8EC/6GPD1Cw4yju8dXMtDRL30OByJ5+81eafHCCq8xCCXKDLWuz3e7wgDNkgUX4M9bu6FS3HPovAcC/PaxvtQVK04v7R6iIL5FauqWSWlSO1GUAeR64euBgesO5un9trAUtC9gWHnGc/M4Jbcdjtus2KaFr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757009234; c=relaxed/simple;
	bh=Kk1MZuJO0LlaP1FUc4Qxdvpc+/TN53t6fuzXj9FJXIE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=QRnqOiohdE9YGwGR6VH9K8d9XAQgLtjef4v427WILvRBl/5Nk6Ah+cxn0QhH9naxqODQxMAeEdMjoiYh5BEL+tS5cFHBtB5fKjYNYQ5XYc5i5ZlFP2QipOIXYtLkTqTWpFUJpMfAYrdV9Qse989BEYFIU3aYleH2zN/BSVx4jqk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0al5XDLt; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0al5XDLt"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-74557b7703aso453500a34.3
        for <syzbot@lists.linux.dev>; Thu, 04 Sep 2025 11:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757009232; x=1757614032; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=J5j4QHnoiKAn5QPruehC5OPNTQGpVFzEDUFytUNKThw=;
        b=0al5XDLtdEsSq9JhhB/iKLnnFRLilrQBmaFZ37YAX8nV8kgsX9f/xn5hycnfggHtDf
         Oh+eZaFMq27hEjPPLpFzY7zICu3I4i53tm8ANz2nif/hoq2Dal3ub5MobqKGzK222t5J
         LOs1IDUSQq9yhjNjtk3n6SaVECYC+LLVaM7zePo31t25xOyrpgGH4/E+xztqAgD/o3Ea
         voXwbw5gtv6/QQZTOHgPgZh3GZRZE7ZDgF4BNFpIOphF1qt+i5W6WkuUiPULEAnnERVt
         k4ALf+IC/awvMfRpo7L8LkQ7/NsPDyCzUkfidwUYFno221/FJqJWhxd806Uamsjvltt4
         i0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757009232; x=1757614032;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=J5j4QHnoiKAn5QPruehC5OPNTQGpVFzEDUFytUNKThw=;
        b=OzSiZGmCojEOo8XVtWdjVlnJ8tGkuwYBoKSvkNZk/bB0K5Idp1qizTs9Hg0lmx0Y8h
         Qcd0Okvtk0r6P8u201ndqbW621m7tkiN4aSoff1KccXvX3caZgwMd7N7NIIG5J7p9FNP
         VW/bTVo61skJWcrh0ulyE/qWVZObqdtDnOP+XPw1cZWwe+vvSlXHhYK3ewcKL1Z8QkL/
         mvfIBZwZBfy+ncsKtwYtoUxTT2JgIimTe9Z0JS/ByERb53jHkRo8FGFM3lN/YakZ2+PX
         Gq2LeVqwvY8gq46AdMiku2PigMnxb5z0gqKmldoW8r983GNrx1GVUvwIi0KWDSWtlqHb
         /kow==
X-Forwarded-Encrypted: i=1; AJvYcCUiKKdywSi8/OgMvUNpx6KVtuIrdnuJUH7dzl3V2upK79SJVPrJKBpz8MZwZaymLspSb/HtEKs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzG7h1ZDovHsfpMrUtmWRa/Dg1f2Qohj9zQrvxTksb+EaDHgDzJ
	0M+gh0/SyAjvw2XRNqF6hRyd1oqa56OKj6D+CbAyXWOu8NffGE6gSjiB+w2jwGRXedKPm8I82Vl
	a8LtiPNmx6EInT2QcY4D5TuEWlDsY+BIbQu9p4zvO
X-Gm-Gg: ASbGncvuylNY5MfcPrigshNexiEqgWDx9U0unpFb4MmRwjmEkHsmcNpWgqe6m4MyHzp
	EKP+hqpZxcDHjlow7+3Up11ia136REarRh7wnmX+t/KscYdheGPW4jODc3kHVG+rkNl1wTpWCPd
	mcQxoItnZIVSPWjc8ja2ojGOmWJomrEIF3LsKj+mnR8/8Ys48y+l0TYVZxutFeIF/1u+yXiczwj
	Q/xR7izyvAS3JuH1MGkDa3kHiVzbYYobRsRWNGzRvb0qhI=
X-Google-Smtp-Source: AGHT+IE0/TtdzmSywdDAHFdPNzBMJflMSNSpJciysn5ynJnHBeJf7u2S19gcDNX43hqlvRDIzGBSdT3hLqbq+rMKNLA=
X-Received: by 2002:a05:6830:6009:b0:745:9dc8:8dfd with SMTP id
 46e09a7af769-7459dc88f9cmr3622777a34.35.1757009231987; Thu, 04 Sep 2025
 11:07:11 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68b9c5c6.050a0220.192772.000a.GAE@google.com>
In-Reply-To: <68b9c5c6.050a0220.192772.000a.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 4 Sep 2025 20:07:00 +0200
X-Gm-Features: Ac12FXzbTa0jgVA79HU4kGWks3e5GxXFDu5QswILmMPAtZXgp3qDOQkkNpZiHkI
Message-ID: <CANp29Y4KpeaZNon4xTmfFVSOFe3wmsVU36QEFDpYQVbU+FqF6A@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Support non-linear skbs for BPF_PROG_TEST_RUN
To: syzbot ci <syzbot+cif54e06847efbeb9b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Sep 4, 2025 at 7:01=E2=80=AFPM syzbot ci
<syzbot+cif54e06847efbeb9b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] bpf: Support non-linear skbs for BPF_PROG_TEST_RUN
> https://lore.kernel.org/all/cover.1756983951.git.paul.chaignon@gmail.com
> * [PATCH bpf-next 1/4] bpf: Refactor cleanup of bpf_prog_test_run_skb
> * [PATCH bpf-next 2/4] bpf: Craft non-linear skbs in BPF_PROG_TEST_RUN
> * [PATCH bpf-next 3/4] selftests/bpf: Support non-linear flag in test loa=
der
> * [PATCH bpf-next 4/4] selftests/bpf: Test direct packet access on non-li=
near skbs
>
> and found the following issue:
> kernel BUG in bpf_prog_test_run_skb
>
> Full report is available here:
> https://ci.syzbot.org/series/94d30edd-8375-4788-b43c-b4f85290f7e8
>
> ***
>
> kernel BUG in bpf_prog_test_run_skb
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      c9110e6f7237f4a314e2b87b75a8a158b9877a7b
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/f23c9149-2bb8-4751-96fa-a1ef3b28c=
ee2/config
> syz repro: https://ci.syzbot.org/findings/4d88c169-3df8-4aac-b20a-ff80d8b=
2eff5/syz_repro
>
> ------------[ cut here ]------------
> kernel BUG at arch/x86/mm/physaddr.c:23!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 6005 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__phys_addr+0x17b/0x180 arch/x86/mm/physaddr.c:23
> Code: 50 cf fa 8d 48 89 de 4c 89 f2 e8 10 9a 8a 03 e9 4d ff ff ff e8 66 2=
5 4b 00 90 0f 0b e8 5e 25 4b 00 90 0f 0b e8 56 25 4b 00 90 <0f> 0b 0f 1f 00=
 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
> RSP: 0018:ffffc90002c0fba8 EFLAGS: 00010293
> RAX: ffffffff817486fa RBX: 000000007ffffff9 RCX: ffff888107c99cc0
> RDX: 0000000000000000 RSI: 000000007ffffff9 RDI: 000000001fffffff
> RBP: 00000000fffffff9 R08: ffffffff8fa38037 R09: 1ffffffff1f47006
> R10: dffffc0000000000 R11: fffffbfff1f47007 R12: 0000000000000000
> R13: 0000000000000000 R14: 000000007ffffff9 R15: dffffc0000000000
> FS:  00007fae773f76c0(0000) GS:ffff8881a3c1c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b31a63fff CR3: 000000001f48c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  virt_to_folio include/linux/mm.h:1180 [inline]
>  kfree+0x77/0x440 mm/slub.c:4871
>  bpf_prog_test_run_skb+0xceb/0x16e0 net/bpf/test_run.c:1179
>  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4590
>  __sys_bpf+0x581/0x870 kernel/bpf/syscall.c:6047
>  __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fae7658ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fae773f7038 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007fae767c5fa0 RCX: 00007fae7658ebe9
> RDX: 0000000000000050 RSI: 0000200000000080 RDI: 000000000000000a
> RBP: 00007fae76611e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fae767c6038 R14: 00007fae767c5fa0 R15: 00007ffe5431da58
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__phys_addr+0x17b/0x180 arch/x86/mm/physaddr.c:23
> Code: 50 cf fa 8d 48 89 de 4c 89 f2 e8 10 9a 8a 03 e9 4d ff ff ff e8 66 2=
5 4b 00 90 0f 0b e8 5e 25 4b 00 90 0f 0b e8 56 25 4b 00 90 <0f> 0b 0f 1f 00=
 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
> RSP: 0018:ffffc90002c0fba8 EFLAGS: 00010293
> RAX: ffffffff817486fa RBX: 000000007ffffff9 RCX: ffff888107c99cc0
> RDX: 0000000000000000 RSI: 000000007ffffff9 RDI: 000000001fffffff
> RBP: 00000000fffffff9 R08: ffffffff8fa38037 R09: 1ffffffff1f47006
> R10: dffffc0000000000 R11: fffffbfff1f47007 R12: 0000000000000000
> R13: 0000000000000000 R14: 000000007ffffff9 R15: dffffc0000000000
> FS:  00007fae773f76c0(0000) GS:ffff8881a3c1c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b31a63fff CR3: 000000001f48c000 CR4: 00000000000006f0
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
t eddyz87@gmail.com paul.chaignon@gmail.com]
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
-upstream-moderation/68b9c5c6.050a0220.192772.000a.GAE%40google.com.
