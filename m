Received: from mail-ot1-f44.google.com (mail-ot1-f44.google.com [209.85.210.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAB6028DB56
	for <syzbot@lists.linux.dev>; Mon, 15 Sep 2025 06:44:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757918697; cv=none; b=c+ZC3flsOfhdwapvuWK4DGYOVaIf6Hyf0uxvwsjEl4AIvy1QdLC/TP7qPqxqDno5Fg5WAgALdDfiYOyjhaMVVG1EEdj3jKR23xUul5Ud1WZ9cxh0fjRSVDqmBlypYLolxbKzZdB1CE6aR1p+25DCO/LNRoxUi+DIKpOtmFguv5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757918697; c=relaxed/simple;
	bh=zsJ6cjyQCZrcBb+klMiuTZiGArP07uZrCfUIeN8msJc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y55r1rn5A7AJQkBJnkdz+9iypYwz19Tnv9MuIhrPzmY1y7v0rBr4PM3KyqlqviOwnJAVnAUjOe9eMhlYi8AsmxEXqhnJtp3nRAx95o3ySUEnkxuPepyrsz4JlBczScI+UXjmFOyRW++1XEnP1ImPF9BW8BQgV7mL1kBaBSTKiz4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GdJ/3fp8; arc=none smtp.client-ip=209.85.210.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GdJ/3fp8"
Received: by mail-ot1-f44.google.com with SMTP id 46e09a7af769-7459fa1ef2aso3998108a34.1
        for <syzbot@lists.linux.dev>; Sun, 14 Sep 2025 23:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757918695; x=1758523495; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1bBOAuYetFDuXClTlPZ4Yrqa63Mlhgh73iUJ90T+dHI=;
        b=GdJ/3fp8KGi3TTszX5W4KjovA0FeZusbOIFUuruWtQmhOuYtczprnqHoYYMFU69hOA
         PCqAncU5l06ZzPx89GpNLTR26Jrjj4dxVFHk+BKtL/5tRCGnSWcSr+jfIqo+dp3o+Z7A
         ZcnxAY52lA3oKV2fOi/GwhtwF2q9grTA4sK6/8UwB9KymkcC9GRNqt3q3CshG7rkD/F/
         bYPykD9C7IM2jy9tBlumlgLPe55h0WeOwOgwm/PIpv3oUf5YRlA1oDOC3DsNm3tuWrYn
         KPCebOuobl+rCdh6IBPlcMnfoZJWkigC533uDm5Gb17gJgBO3yFeFNP0nqGY25U5YRQv
         KC3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757918695; x=1758523495;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=1bBOAuYetFDuXClTlPZ4Yrqa63Mlhgh73iUJ90T+dHI=;
        b=azmaZ1eVFy3FYE2ni0v3WIVWZLEWRJXffpx1Pw1pK6qP83OMR04hpY9H+M1mTb4CpQ
         Y8x2BzaG68ebVRC4S1GEBi8cMh41cIuzrYCR3oTBPRD9jhnHZQWPefvrYP41T5hsJLIc
         xZ6R5cFYhdNCng8hD6JLVrTlSJeJfFp2koYJjvkaA1jEUgiBxYrmseKJtC/ObiP6SiBZ
         YvopztzxjMICOPz0CRt0Wc+wSs5sSbxOV1ysLk6Q+A8z31cMAmumhIANT/Grm/DB96nn
         liGqGkgHQyHx/FQioN61HqhCGv9AfiujJNr9gr8pKUlilwlwZZswUrgwoQw7fF7Nhe6r
         ZgTQ==
X-Forwarded-Encrypted: i=1; AJvYcCXJHSXGG/5uNcke18KESdwqKiKFd2nZ9hWDYJOVOAe+BXivOiHYw4S1BTN9pVji9mMvtbpflaM=@lists.linux.dev
X-Gm-Message-State: AOJu0YyRtnd4yC9C+WvjiV1VnWDRwvw2bnUjCFGNo2w98JJX12pJ0Xz+
	V0djjGW0a26/5gitmEoorCceTqtt0ypVYxgRHxldTStvgUcLuo/Zlq8bmYfHVXmj2VQyVbmPyIt
	SPNBgTFMv+duPHLuI9jityJXRzNE+H9iIfWsEIpdd
X-Gm-Gg: ASbGncsdiOfgLz7/fKRI9JVgljx0D69cbo0T+1NoXKTjhnQHP/eMg3t5ZJ5SqVJDG8f
	FEiXKhVAje+DSOvYyy32DPspTBqlHC6xizMlK2DQhETXCFS17R+UpyLAUWwswa2hW9v/S6ppvl3
	RDwn5h9I2xwZR2CWSQRiT5xGV+X+hMw65DUWRY/vd77cOW4fP6iQqopugmZKLVqsctczgrsUmEM
	6JWpX39yYwVhZbNhLTbMR9Eo3HmfTtkzi8vnsRyVF/H
X-Google-Smtp-Source: AGHT+IFRjMNjFqHSYEXDsuKsVTodp+IwFPuZYlcdaIQtBP7HsDPTLQd/O8xccrTjLI3p1uhLm7lJR9Zqk9mKUEpZUzU=
X-Received: by 2002:a05:6830:4995:b0:745:a0f0:25cc with SMTP id
 46e09a7af769-75356b62b32mr6120447a34.36.1757918694862; Sun, 14 Sep 2025
 23:44:54 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68c71436.050a0220.50883.0005.GAE@google.com>
In-Reply-To: <68c71436.050a0220.50883.0005.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 15 Sep 2025 08:44:43 +0200
X-Gm-Features: Ac12FXzlxtVWg_KEGLo4cXXtyUyhgRwpsci69sidkQRqlYciBkM8_gUi-WNYDCE
Message-ID: <CANp29Y6UoOKPW4mkF3rds9+6a0U-zLwO0xKA61KxEXRc1e7cig@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Support non-linear skbs for BPF_PROG_TEST_RUN
To: syzbot ci <syzbot+ci8f8a98344de548ae@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Sep 14, 2025 at 9:15=E2=80=AFPM syzbot ci
<syzbot+ci8f8a98344de548ae@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] bpf: Support non-linear skbs for BPF_PROG_TEST_RUN
> https://lore.kernel.org/all/cover.1757862238.git.paul.chaignon@gmail.com
> * [PATCH bpf-next v2 1/4] bpf: Refactor cleanup of bpf_prog_test_run_skb
> * [PATCH bpf-next v2 2/4] bpf: Craft non-linear skbs in BPF_PROG_TEST_RUN
> * [PATCH bpf-next v2 3/4] selftests/bpf: Support non-linear flag in test =
loader
> * [PATCH bpf-next v2 4/4] selftests/bpf: Test direct packet access on non=
-linear skbs
>
> and found the following issue:
> kernel BUG in bpf_test_init
>
> Full report is available here:
> https://ci.syzbot.org/series/23791187-8fc0-4c8a-bebc-3909e311c11e
>
> ***
>
> kernel BUG in bpf_test_init
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      a578b54a8ad282dd739e4d1f4e8352fc8ac1c4a0
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/037e1e74-be70-4216-ad05-430c2deea=
0bb/config
> C repro:   https://ci.syzbot.org/findings/adf84c1c-28ba-48f5-9638-8339635=
cebe5/c_repro
> syz repro: https://ci.syzbot.org/findings/adf84c1c-28ba-48f5-9638-8339635=
cebe5/syz_repro
>
> ------------[ cut here ]------------
> kernel BUG at arch/x86/mm/physaddr.c:28!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 6014 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__phys_addr+0x173/0x180 arch/x86/mm/physaddr.c:28
> Code: e8 02 2a 4b 00 48 c7 c7 50 d1 fa 8d 48 89 de 4c 89 f2 e8 e0 2f 8b 0=
3 e9 4d ff ff ff e8 e6 29 4b 00 90 0f 0b e8 de 29 4b 00 90 <0f> 0b e8 d6 29=
 4b 00 90 0f 0b 0f 1f 00 90 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc900032d7b68 EFLAGS: 00010293
> RAX: ffffffff81749722 RBX: 00006180047f3080 RCX: ffff8881079b9cc0
> RDX: 0000000000000000 RSI: 0000000000000061 RDI: 0000000000000000
> RBP: 00000000000000db R08: ffff88811fcc20da R09: 0000000000000000
> R10: ffff88811fcc2000 R11: ffffed1023f9841c R12: 00000000000000db
> R13: 00000000000000db R14: 0000000000000028 R15: 0000000000000061
> FS:  000055557464c500(0000) GS:ffff8881a3c13000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000001f984000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  virt_to_folio include/linux/mm.h:1180 [inline]
>  kfree+0x77/0x440 mm/slub.c:4886
>  bpf_test_init+0x1ba/0x220 net/bpf/test_run.c:686
>  bpf_prog_test_run_skb+0x2c8/0x1700 net/bpf/test_run.c:1039
>  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4590
>  __sys_bpf+0x581/0x870 kernel/bpf/syscall.c:6047
>  __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f502198eba9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd90d34788 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f5021bd5fa0 RCX: 00007f502198eba9
> RDX: 0000000000000050 RSI: 0000200000000240 RDI: 000000000000000a
> RBP: 00007f5021a11e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5021bd5fa0 R14: 00007f5021bd5fa0 R15: 0000000000000003
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__phys_addr+0x173/0x180 arch/x86/mm/physaddr.c:28
> Code: e8 02 2a 4b 00 48 c7 c7 50 d1 fa 8d 48 89 de 4c 89 f2 e8 e0 2f 8b 0=
3 e9 4d ff ff ff e8 e6 29 4b 00 90 0f 0b e8 de 29 4b 00 90 <0f> 0b e8 d6 29=
 4b 00 90 0f 0b 0f 1f 00 90 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc900032d7b68 EFLAGS: 00010293
> RAX: ffffffff81749722 RBX: 00006180047f3080 RCX: ffff8881079b9cc0
> RDX: 0000000000000000 RSI: 0000000000000061 RDI: 0000000000000000
> RBP: 00000000000000db R08: ffff88811fcc20da R09: 0000000000000000
> R10: ffff88811fcc2000 R11: ffffed1023f9841c R12: 00000000000000db
> R13: 00000000000000db R14: 0000000000000028 R15: 0000000000000061
> FS:  000055557464c500(0000) GS:ffff8881a3c13000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000001f984000 CR4: 00000000000006f0
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
> [ameryhung@gmail.com andrii@kernel.org ast@kernel.org bpf@vger.kernel.org=
 daniel@iogearbox.net eddyz87@gmail.com martin.lau@linux.dev paul.chaignon@=
gmail.com]
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
-upstream-moderation/68c71436.050a0220.50883.0005.GAE%40google.com.
