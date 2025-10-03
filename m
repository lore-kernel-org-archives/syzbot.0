Received: from mail-ot1-f50.google.com (mail-ot1-f50.google.com [209.85.210.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DC8818A6A5
	for <syzbot@lists.linux.dev>; Fri,  3 Oct 2025 06:37:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759473430; cv=none; b=E2UGqk0HT6OFd42wJ+JqbNyTaTdiZIfkJyHeiua4DA9k7LXaOnkKwas3K7D8qXfqMgEpQjuRFNq8eVeE/MQtUlItqEQLH4Kc2G+j8wC5MIWODikvtqmPbHkCXFIbqchAm2ttKhk2RqCd3JGitS9+U1Tl98DPk8BncoIpc3ylnrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759473430; c=relaxed/simple;
	bh=LC0nFUbrNE/M5yA0uYOYJ2S3cx8ayc4WFcTOIo84DmA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=jOaQBL3ezhxs7i/YJHUqNBI6twuApb20VTLhyg/DDDcurEjPyBOqBcyMzhRNswTa5dsfWGP+DE095DhozK6fvClbtuxYFjiwIVMmaFw0EgjB6pe/zFCMEiA1s27/bT2McOg5ifkFTd6flkXfzPI3W3Ap8frD/2I8k4WatjhNe1c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=BrdA396d; arc=none smtp.client-ip=209.85.210.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="BrdA396d"
Received: by mail-ot1-f50.google.com with SMTP id 46e09a7af769-7abbdf3c476so1514590a34.1
        for <syzbot@lists.linux.dev>; Thu, 02 Oct 2025 23:37:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759473427; x=1760078227; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DiYqyyDXHmkF4IfUHZXZvHRjHvrtkwussY/qUlbom/8=;
        b=BrdA396dIyG+M7Sv0K4v7S+Fzct/tBZ5Mo7Wv8qD+VRGA5hhqwJEJNOxeFFeC0srA/
         hQK5VHSYyrGeT2mGIdXD5PHADfG7fQYep+TbheUqAYjsI56GCxXCAaKAA4CmIwvjYu5Z
         +Cht/+meCCDLKW03sDrh7MwlNGkVqMh9sATGbnvzC4+/bLq/j+bZjt1eWaGQ/qUa5YTl
         RuHYOurIDvbxyJSJ1dnZRUugr7aAgYFIjlVAtYWZbbDpDHX1D5fCGJ/AYTxQYfW9TQFA
         WlYa9TCKcgoWBrL70sD7OcSqY5/jt52xr5eNfD60RsMlm+VgYX9hYZVEPedns56cDsw2
         S+ow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759473427; x=1760078227;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=DiYqyyDXHmkF4IfUHZXZvHRjHvrtkwussY/qUlbom/8=;
        b=nzk8oFDGyYaVvTstnr5bu9YFBkII1EvnCmfSEsQ8SmlY4jAkpUDnfguoQTfaSbbTkv
         Edj35VnFVNRnN33+RLgMK5FTouFzJkOLYMaRDZMRdckNoon6zf2dy8pgx9sgKcQmf1Xm
         M8t3wn49AgK4sD7b92Fd4gm4iwaq/f3AyV4xlZ0/+naOY2n/CbubyldONpVfuvNlIgwg
         nq287dg2v1k+LouZghGMd6aRIDeenOkbSjgFUpotgJUnILhOyWMBGS5V/nYe9CxOUN1J
         DKfP99qVxQkouyUt+gK58ZAeelQk8DxxH7HDaYIaPbbBzNN32UqADxY1/HttwM2tOWRP
         zumQ==
X-Forwarded-Encrypted: i=1; AJvYcCWC5a9eCRaPqw94NrfNRSXWQyQv6Na2KR7Xz6b7uguPUksTMm1ggk5ngDHRNG4ycviKg6nMvvY=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz+V0s+BkofI6LxXJZj1TRgTCgPnPnXiDWPac7m1glaj/L1lGSS
	aOEG9T6MeOKXRA7xZeBCeETxlSlJoK0jVfcVlhAC83eAT1VqqgluHTlyH20UldeuuJcsLuuTiIi
	TdmwnybBQ4fW5gK0YSM/ESgs96VpujPFCt+S0fLfz
X-Gm-Gg: ASbGnctzbKIVpn+IMpzb/+zYNgI1g6l8Rvk9H5c83cQ3dlzl/M0IalNzc8AR5yFZed/
	eJ4fC4eVRu83m5MpcPwjFPdv2HZFBVruzdPKBummMLxiDBAAx5Q4r3n1LghVi6w6GTiv/qbeZIN
	7NDj5/H4bKjF4Rph3uOW4nd5T8GPdKh1ySBKCRXuAnU0reWyeLs+qJ0ldJF0H+MkdlEpgr2Ef+3
	QyTf5oDNkKx21y6g8bn0DzMiLYXVZgSRMFryvtig7kSAGWBndt/p4KvRarDzQpggp9vYFw=
X-Google-Smtp-Source: AGHT+IFq+WPKQc2F0N+OG9aWXYaFqvCz+BfjITTYGXXRbLXU/cMXQDqkmR6ylhv7+MTrul0iGJTsBdX2b9M7HqX/syw=
X-Received: by 2002:a05:6808:690a:b0:43f:63cc:aefa with SMTP id
 5614622812f47-43fc18baa28mr961923b6e.48.1759473427186; Thu, 02 Oct 2025
 23:37:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68ded7e6.050a0220.1696c6.0037.GAE@google.com>
In-Reply-To: <68ded7e6.050a0220.1696c6.0037.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 3 Oct 2025 08:36:55 +0200
X-Gm-Features: AS18NWAklQ42NKAcXw-zcz4joezXUmhqMH-bdlhrua3L0Bky4kE3Jn3qpUIVuZU
Message-ID: <CANp29Y5=gjyda4tSajRK0966m+PmqnAJzT+8UA-uW9vs-_TXPA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Extend bpf syscall with common
 attributes support
To: syzbot ci <syzbot+ci5a894edd21f5be73@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Oct 2, 2025 at 9:52=E2=80=AFPM syzbot ci
<syzbot+ci5a894edd21f5be73@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] bpf: Extend bpf syscall with common attributes support
> https://lore.kernel.org/all/20251002154841.99348-1-leon.hwang@linux.dev
> * [RFC PATCH bpf-next v3 01/10] bpf: Extend bpf syscall with common attri=
butes support
> * [RFC PATCH bpf-next v3 02/10] libbpf: Add support for extended bpf sysc=
all
> * [RFC PATCH bpf-next v3 03/10] bpf: Refactor reporting log_true_size for=
 prog_load
> * [RFC PATCH bpf-next v3 04/10] bpf: Add common attr support for prog_loa=
d
> * [RFC PATCH bpf-next v3 05/10] bpf: Refactor reporting btf_log_true_size=
 for btf_load
> * [RFC PATCH bpf-next v3 06/10] bpf: Add common attr support for btf_load
> * [RFC PATCH bpf-next v3 07/10] bpf: Add warnings for internal bugs in ma=
p_create
> * [RFC PATCH bpf-next v3 08/10] bpf: Add common attr support for map_crea=
te
> * [RFC PATCH bpf-next v3 09/10] libbpf: Add common attr support for map_c=
reate
> * [RFC PATCH bpf-next v3 10/10] selftests/bpf: Add cases to test map crea=
te failure log
>
> and found the following issue:
> WARNING in map_create
>
> Full report is available here:
> https://ci.syzbot.org/series/71cc3485-c0bb-4e81-ab58-5a3a9b5a785c
>
> ***
>
> WARNING in map_create
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      4ef77dd584cfd915526328f516fec59e3a54d66e
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/f37ac003-a816-47bc-ba46-fe604a617=
a93/config
> C repro:   https://ci.syzbot.org/findings/bbf6cd34-205b-4dba-a0c6-10559ca=
a70de/c_repro
> syz repro: https://ci.syzbot.org/findings/bbf6cd34-205b-4dba-a0c6-10559ca=
a70de/syz_repro
>
> ------------[ cut here ]------------
> WARNING: CPU: 1 PID: 5987 at kernel/bpf/syscall.c:1470 map_create+0x12b3/=
0x17a0 kernel/bpf/syscall.c:1470
> Modules linked in:
> CPU: 1 UID: 0 PID: 5987 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:map_create+0x12b3/0x17a0 kernel/bpf/syscall.c:1470
> Code: e8 82 26 ef ff 85 ed 74 29 e8 39 22 ef ff 48 8b 1c 24 48 89 df e8 5=
d c7 ab 02 4c 8b 64 24 08 e9 7b ff ff ff e8 1e 22 ef ff 90 <0f> 0b 90 e9 d4=
 f3 ff ff 48 8b 1c 24 48 89 df e8 d9 db 00 00 48 8b
> RSP: 0018:ffffc90002d2fc20 EFLAGS: 00010293
> RAX: ffffffff81d0a382 RBX: 0000000000000001 RCX: ffff888020e55640
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: dffffc0000000000 R08: ffff888020e55640 R09: 0000000000000002
> R10: 0000000000000021 R11: 0000000000000000 R12: 0000000000000000
> R13: ffffc90002d2fd00 R14: 0000000000000000 R15: ffffc90002d2fd40
> FS:  0000555569a59500(0000) GS:ffff8881a3c0f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f8bbc12acf0 CR3: 000000010cfb0000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __sys_bpf+0x966/0xe00 kernel/bpf/syscall.c:6305
>  __do_sys_bpf kernel/bpf/syscall.c:6450 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6447 [inline]
>  __x64_sys_bpf+0xba/0xd0 kernel/bpf/syscall.c:6447
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f8bbc18eec9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe6b9b55a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f8bbc3e5fa0 RCX: 00007f8bbc18eec9
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 00007f8bbc211f91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f8bbc3e5fa0 R14: 00007f8bbc3e5fa0 R15: 0000000000000003
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
> The email will later be sent to:
> [andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.ne=
t leon.hwang@linux.dev]
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
-upstream-moderation/68ded7e6.050a0220.1696c6.0037.GAE%40google.com.
