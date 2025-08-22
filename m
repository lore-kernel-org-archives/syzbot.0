Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66F931A9F82
	for <syzbot@lists.linux.dev>; Fri, 22 Aug 2025 09:06:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755853602; cv=none; b=fJwVDDW9Py6xBENqrssI2ls8eQPSnSFtkfYsSLzsuNsZU5p3hVUxQLG87hoMZDsLdVwFnyUNzsF0/E9QqitKz2PGijPUkwCEPls/IDO86raoib06b9v/2Qgmhuk1i7KygWVxixDlmlPmCzIad8Q8pXxedQg6JYWJTChWqGmCB1U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755853602; c=relaxed/simple;
	bh=C5oCm0uBsEaMtMzaZGDrkb+Jt9lWCS3zbDIlMNHNLlQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ZT3/EsZ0Zd+D+AuCEJz7VXyt8wTSsTOQnSSHR2kscNT6oVlu1KcXSDDy1tJfHj8yXttXtUQ4VAIYLofYDMEE/eDqwxNStAjPCEzPboJLFgN8zEtM1EsYj+SEHU9KRcvE0gBW3mDUYVF8T7+NyDJOv1C8ZXiecD/IRDSMf7UNELo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=yjeuSngq; arc=none smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="yjeuSngq"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-30cce50b75aso1171381fac.0
        for <syzbot@lists.linux.dev>; Fri, 22 Aug 2025 02:06:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1755853599; x=1756458399; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=m1QxoQ1ijdvXg7CKrg7DPJjC3XjMAqDAvpaFYWPsqBc=;
        b=yjeuSngqdBEGOeEEVA84Vn7hh89fXBwzkw7YyUjTQWgcNyWRDLBeTZKi+aqvt8gupG
         uBgswuULVbMfq8VwJ/GotKiIANKOi1XlC1bwqKA5UUYvDxGcyfDOcf6vHHfWJIpCO4u5
         uRmxEIUlMZi+8hEJFfdmUBDcaoiu61EP1EsxKIXRFmh71lxvJKBax+IfgPk+6RG0kAjp
         gA6A5qm381jpoDZKEzB5AWutC4XlO3MNBKKb0HUMIr8uBNkuw9F2ehu1kYPF2mmPh65b
         BGJeHKM3R4xOWI9XGLu+vWmGUDtcP1f4WKUSZnFMUimqP7KpbA7Ig9eUJZMtcre+N6h8
         /oPQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1755853599; x=1756458399;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=m1QxoQ1ijdvXg7CKrg7DPJjC3XjMAqDAvpaFYWPsqBc=;
        b=YxNyM5Io0/bd5171haHbOF1DPDsnPrSrXBqykeAQbp3iFwwj7ggRdtiB7UqnRrBMAr
         1zCq2nUk1Ps13Zjew9VQwjsx79XdU1aCW8cVizUOxUqHKDRsjo18IokcLLZp6SyD1udL
         GR4Bm/mLA2F3+k+Ekg9osbtKC1Tw+RUgq3krPIa8dvDEeq37b0HhUJNi9c7P5RADsI1d
         xfClQWlE/jSBEBoa2Wu0Yn9W91qm6q/7JEF8mnnTST45QSsMtnUtRHA8io3LBlHhBpTs
         /RvmS77slKKp+O8ieOMjvNB5QVYbLwDGEFPm3SJPW04b3z+A1y1nO6wmeUcuP4ZebNP2
         n4Iw==
X-Forwarded-Encrypted: i=1; AJvYcCVHp5/G/zXgWlOb8c/e2C6uPMQ9WlrDok8NdJg6MsTG7/IEUDOoYjWe3btdCghlKkMv6T/Prhw=@lists.linux.dev
X-Gm-Message-State: AOJu0YydlRRCaEfJpcYFws0HW3g0t1oPCk1cHGip9PrwB+GC4sbvzXSK
	KwYPV4hJVf5hO8KwL9aEKaQVg/n+qJjgYX7FInZ34qj9jAvv+oImuVUeye79tiBcbguPebbQoUS
	4aRQFgxyCOa5+j1iSkAQybcrth/ojDoFr8EpJz6NB
X-Gm-Gg: ASbGncuozKXxW7IhujxmrHsGdVxzec5xioogtqrVt1Ft58Y/wu6wRiWeR7ugb0U2z+P
	Nw2hGRshKA3T2T46Q5MnqivuylNMJh5qa6NRFV41JuWtsbpHVU8SR4KS7g3WjK8SBe+4t8rncxv
	bcCfouUiL+SGEGHkYRsUuxEtoI3YYeYHkgIgQcp9s0ON78uSXs8mwQBrZo5j0tvIpi0ZA2nj/vm
	V9Ls+7+e6C5Ik3N3PAGrgCGs72HKDJzQ8qNN6qhRSYTELvuml8sP3s=
X-Google-Smtp-Source: AGHT+IHLP+7AIkU6AcH/IkPrGd1dQAtujqAaBYkPCad9hKyAfX+yTPX6Hl5OMug9TTBzfm4yYTlkZXAVnHNc1vs7P94=
X-Received: by 2002:a05:6870:3d93:b0:314:b6a6:688b with SMTP id
 586e51a60fabf-314dced147dmr1049484fac.43.1755853599216; Fri, 22 Aug 2025
 02:06:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68a8302c.a00a0220.33401d.0253.GAE@google.com>
In-Reply-To: <68a8302c.a00a0220.33401d.0253.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 22 Aug 2025 11:06:26 +0200
X-Gm-Features: Ac12FXwjH21ecKfL7_boa8ccsAVpmjxMrrgXgotQJDCIdiahsqWoIKuhkV30r9g
Message-ID: <CANp29Y6jx7pP-H-i8J_JLUsHUVLiQUUe7kbuH9278_tMs5ADDg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: tcp: Destroy TCP-AO, TCP-MD5 keys in .sk_destruct()
To: syzbot ci <syzbot+ci8912e284da8aa743@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Aug 22, 2025 at 10:54=E2=80=AFAM syzbot ci
<syzbot+ci8912e284da8aa743@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] tcp: Destroy TCP-AO, TCP-MD5 keys in .sk_destruct()
> https://lore.kernel.org/all/20250822-b4-tcp-ao-md5-rst-finwait2-v1-0-2582=
5d085dcb@arista.com
> * [PATCH net-next 1/2] tcp: Destroy TCP-AO, TCP-MD5 keys in .sk_destruct(=
)
> * [PATCH net-next 2/2] tcp: Free TCP-AO/TCP-MD5 info/keys without RCU
>
> and found the following issue:
> WARNING in inet_sock_destruct
>
> Full report is available here:
> https://ci.syzbot.org/series/4e53fc18-79b4-47d6-87c4-89e499e12879
>
> ***
>
> WARNING in inet_sock_destruct
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      a9af709fda7edafa17e072bffe610d9e7ed7a5df
> arch:      amd64
> compiler:  Debian clang version 20.1.7 (++20250616065708+6146a88f6049-1~e=
xp1~20250616065826.132), Debian LLD 20.1.7
> config:    https://ci.syzbot.org/builds/d6e1c7cd-df1b-4192-bc2d-a2db69987=
793/config
> C repro:   https://ci.syzbot.org/findings/62fd81c8-8c8c-49fe-aa87-8e1418b=
cc053/c_repro
> syz repro: https://ci.syzbot.org/findings/62fd81c8-8c8c-49fe-aa87-8e1418b=
cc053/syz_repro
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 6012 at net/ipv4/af_inet.c:153 inet_sock_destruct+0x=
5f9/0x730 net/ipv4/af_inet.c:153
> Modules linked in:
> CPU: 0 UID: 0 PID: 6012 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:inet_sock_destruct+0x5f9/0x730 net/ipv4/af_inet.c:153
> Code: 00 41 0f b6 74 24 12 48 c7 c7 20 91 9e 8c 4c 89 e2 48 83 c4 20 5b 4=
1 5c 41 5d 41 5e 41 5f 5d e9 dd 38 24 f7 e8 68 44 bc f7 90 <0f> 0b 90 e9 62=
 fe ff ff e8 5a 44 bc f7 90 0f 0b 90 e9 95 fe ff ff
> RSP: 0018:ffffc90003a0fc58 EFLAGS: 00010293
> RAX: ffffffff8a0366c8 RBX: dffffc0000000000 RCX: ffff888106891cc0
> RDX: 0000000000000000 RSI: 00000000000003c0 RDI: 0000000000000000
> RBP: 00000000000003c0 R08: ffff88803bb429c3 R09: 1ffff11007768538
> R10: dffffc0000000000 R11: ffffed1007768539 R12: ffff88803bb42880
> R13: dffffc0000000000 R14: ffff88803bb429c0 R15: 1ffff11007768512
> FS:  00005555690ff500(0000) GS:ffff8880b861a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000f65000 CR3: 0000000106d3a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __sk_destruct+0x89/0x660 net/core/sock.c:2339
>  inet_release+0x144/0x190 net/ipv4/af_inet.c:435
>  __sock_release net/socket.c:649 [inline]
>  sock_close+0xc3/0x240 net/socket.c:1439
>  __fput+0x44c/0xa70 fs/file_table.c:468
>  task_work_run+0x1d4/0x260 kernel/task_work.c:227
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  exit_to_user_mode_loop+0xec/0x110 kernel/entry/common.c:43
>  exit_to_user_mode_prepare include/linux/irq-entry-common.h:225 [inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:175 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:210 [inline]
>  do_syscall_64+0x2bd/0x3b0 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa54ab8ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc0978c268 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 000000000000ce2e RCX: 00007fa54ab8ebe9
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000001 R09: 000000040978c55f
> R10: 0000001b30220000 R11: 0000000000000246 R12: 00007fa54adb5fac
> R13: 00007fa54adb5fa0 R14: ffffffffffffffff R15: 0000000000000006
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
> [0x7f454c46@gmail.com davem@davemloft.net devnull@kernel.org dima@arista.=
com dsahern@kernel.org edumazet@google.com gilligan@arista.com horms@kernel=
.org kuba@kernel.org kuniyu@google.com linux-kernel@vger.kernel.org ncardwe=
ll@google.com netdev@vger.kernel.org noureddine@arista.com pabeni@redhat.co=
m]
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
-upstream-moderation/68a8302c.a00a0220.33401d.0253.GAE%40google.com.
