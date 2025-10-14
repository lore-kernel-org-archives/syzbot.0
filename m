Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5965131577B
	for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 13:09:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760447395; cv=none; b=ORIAOVdfLrNAy0e4yR0/9VLjKhJbnInthu6d4kvtmsxET6X0Go5urhP5rL1GmYltsGnY40wylHMmb8l2K2V7bXvXdUPLOzWC32pDTdhfOpcq2L9igie8lMAeyxkHABVqFsYnHtZSeKfduWEa53ULX0eT4nvZPgHJLxVIu8tiUCg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760447395; c=relaxed/simple;
	bh=5y9NHztWMJElcZ2sVj3gZLRsh/hJZutYRvbQ2XqrDwE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=D6h8t1qjvjJ90mwVYKEiVp5kMKR91+ZccwzV6ZtTRJHWwCZGlUN1yn5UplHK6RPcIZMv6Wo6/VS0I1IW1Fa9kCX+bVhE4IN8Kar2noPLIh8ED8VKwb8DCNK5lm+4URRP12qagEH/0sg80U0O5/910CXvmrEZGFIcUM6bor72RgA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=aV4kmkSA; arc=none smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="aV4kmkSA"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7b00927607eso3788413a34.0
        for <syzbot@lists.linux.dev>; Tue, 14 Oct 2025 06:09:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760447392; x=1761052192; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=2j28iVjFouKOCv23ovUsUwwcDtuDYr6TmfgekmaiYXA=;
        b=aV4kmkSARwOk65eutAX06QUMQvEiiJ9agWGQE7ArV490OUkTR9Klza9KAFgoqPTMqd
         AXY5fEra6MurBaFKmXiPhWkQCR/60nHWB26mxTsmgeexR7ouw/V/LQUT9RTcKq3fJ9GJ
         dHO5KAEGKgkQ8Gf5M27jMLo8vmdGJKmFZSMnIN7WI1cktq3Z+HO3lYfSIvxqFpvveLpW
         iPikJ3pFcjqOeVtCOZRDkyKHeXA+VJE0GoEKI+JPDMG9gJYbK0hKDnmYxV/xQM831oq/
         sgguLjxGcpenWLHalpDUHLNYou4nOIY+eIBjavOVI7rSKZ5wY168Kmk4e0VG9U4S0AZN
         Qt4Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760447392; x=1761052192;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=2j28iVjFouKOCv23ovUsUwwcDtuDYr6TmfgekmaiYXA=;
        b=XUGP4d+P60ls4PcUs+IISve/yniVT+XUiLe3skXi3hrtKXiWwhZRZCG3Z9M011Elwd
         vVO03vSNCbKhUwXfD/OS7l8U0QrIaFSU3rgxsD5X6e4II8P2Td309BS0imAR3WtNNHc0
         WSGFe1cXT4yMozEka35OitM0kDitxCHW4MVWn5W7WQP3QnvH5cxYEOFuqm3qcfdLHVwK
         egMVfJxZVFepIIRBpCNHIMWyN4VJJ8eIEFWOv2nKjyq8ERXgz4yvGiTcNbQvKpp5y3C4
         nR58RNgALsW5FTWt2nPsbjaV+Axhzhu2Aefr7gMB902E9G4gfXKS3l+RUAYOZxSWt2cM
         CMwQ==
X-Forwarded-Encrypted: i=1; AJvYcCUSCo8QYWD5vrm6zQEv9OKIOKYkKDuc4SVbjQtVVzrdXELKAtf+vr/EUuI8r32dmUl7NcdbnQA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw9vF7povfmWGiGHnrcTLNQdi04YyMb0BwWJFlDd+qwo6fAa4g9
	9UpBA/r5bUSQNBDD3u67HzynJ0dCG84de1ruNaSH19LBw31V/12hXPSNrcr6CryBLE7zWJCUxIE
	8Gud5Em8TR0PyTqHH6yxfXBhZh8cJcVeMQiOW5eR9OWY6YxvY5t7A2VBS
X-Gm-Gg: ASbGncsMFk2DCR7GtMvhkbvifA9DuPzsMk6+3+5F1PWejYWx98w/JbLzvnxJ3/pZkwL
	0FkKvu3OwetzG2nMuM2No/7cJbgG7he7fak3mNIUokYJzR1bCkbXgv2GxAqqxBNY2IaASO1yKZf
	28B0OSKrQjnbUBgEIi5aczO0bZTdPeNNVM6I6x+k4VBg43ttLcqQ7FvoJEiafx9M65wCi416iX4
	qLMNBXj+VR5SouFeveCLYPEAUTQ4jU0nWgX+gRXQlDiX4IwUN9soY9Md3i0vWo=
X-Google-Smtp-Source: AGHT+IE157nP42KITF+brZe6D17Q+OSMZaM4Jz9LHDe8u+RVpwCnwxqQzApiHVNEKZmISzny1wxOdVwPqB4jrnOAJHo=
X-Received: by 2002:a05:6808:80cc:b0:43f:7287:a5ac with SMTP id
 5614622812f47-4417b3b6034mr11223213b6e.30.1760447391424; Tue, 14 Oct 2025
 06:09:51 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68ee41cb.050a0220.91a22.020b.GAE@google.com>
In-Reply-To: <68ee41cb.050a0220.91a22.020b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 14 Oct 2025 15:09:40 +0200
X-Gm-Features: AS18NWDQeSvH1BBGOMBDGUy1ru53JiF3CcuQthRNC1ut7uich3sB4Id3cxJbeBA
Message-ID: <CANp29Y6Mjx3cC9fgLtYO=u3DdU4GFtJw3swvbq67WuYvbcx0zA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: slab: Introduce __SECOND_OBJEXT_FLAG for objext_flags
To: syzbot ci <syzbot+cia3f00a4d25e231dd@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Oct 14, 2025 at 2:27=E2=80=AFPM syzbot ci
<syzbot+cia3f00a4d25e231dd@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] slab: Introduce __SECOND_OBJEXT_FLAG for objext_flags
> https://lore.kernel.org/all/20251014093124.300012-1-hao.ge@linux.dev
> * [PATCH] slab: Introduce __SECOND_OBJEXT_FLAG for objext_flags
>
> and found the following issue:
> general protection fault in percpu_ref_get_many
>
> Full report is available here:
> https://ci.syzbot.org/series/6fd66120-211f-479f-b6a1-35f990da2dc2
>
> ***
>
> general protection fault in percpu_ref_get_many
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      0d97f2067c166eb495771fede9f7b73999c67f66
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/74de5bb7-695b-4115-9a4b-ee7d7fd0c=
ca2/config
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc00177780ff: 0000 [#1] SMP KASAN PTI
> KASAN: probably user-memory-access in range [0x00000000bbbc07f8-0x0000000=
0bbbc07ff]
> CPU: 1 UID: 0 PID: 6155 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:percpu_ref_get_many+0x8d/0x140
> Code: 01 48 c7 c7 80 70 78 8b be 65 03 00 00 48 c7 c2 c0 70 78 8b e8 64 2=
b 6f ff 49 bc 00 00 00 00 00 fc ff df 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00=
 74 08 4c 89 ff e8 c4 50 f7 ff 49 8b 07 a8 03 75 62
> RSP: 0018:ffffc90004df7500 EFLAGS: 00010206
> RAX: 00000000177780ff RBX: ffffffff822de139 RCX: 14bab840e71f4400
> RDX: 0000000000000000 RSI: ffffffff8bc074c0 RDI: ffffffff8bc07480
> RBP: 0000000000000088 R08: 0000000000000000 R09: ffffffff822de139
> R10: dffffc0000000000 R11: fffffbfff1f3c1ef R12: dffffc0000000000
> R13: ffff88823c63b5c0 R14: 0000000000000001 R15: 00000000bbbc07f8
> FS:  0000555570ae6500(0000) GS:ffff8882a9d12000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555562d8c5c8 CR3: 0000000113444000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  refill_obj_stock+0x254/0x850
>  __memcg_slab_free_hook+0x123/0x3b0
>  kfree+0x3f7/0x6d0
>  kobject_uevent_env+0x361/0x8c0
>  netdev_queue_update_kobjects+0x346/0x6c0
>  netdev_register_kobject+0x258/0x310
>  register_netdevice+0x126c/0x1ae0
>  __ip_tunnel_create+0x3e7/0x560
>  ip_tunnel_init_net+0x2ba/0x800
>  ops_init+0x35c/0x5c0
>  setup_net+0xfe/0x320
>  copy_net_ns+0x34e/0x4e0
>  create_new_namespaces+0x3f3/0x720
>  unshare_nsproxy_namespaces+0x11c/0x170
>  ksys_unshare+0x4c8/0x8c0
>  __x64_sys_unshare+0x38/0x50
>  do_syscall_64+0xfa/0xfa0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f85c81906c7
> Code: 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0=
f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 10 01 00 00 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe57c0ca58 EFLAGS: 00000246 ORIG_RAX: 0000000000000110
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007f85c81906c7
> RDX: 00007f85c818eec9 RSI: 00007ffe57c0ca20 RDI: 0000000040000000
> RBP: 00007ffe57c0cac0 R08: 00007f85c83a69d0 R09: 00007f85c83a69d0
> R10: 0000000000000000 R11: 0000000000000246 R12: 00007ffe57c0cac0
> R13: 00007ffe57c0cac8 R14: 0000000000000009 R15: 0000000000000000
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:percpu_ref_get_many+0x8d/0x140
> Code: 01 48 c7 c7 80 70 78 8b be 65 03 00 00 48 c7 c2 c0 70 78 8b e8 64 2=
b 6f ff 49 bc 00 00 00 00 00 fc ff df 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00=
 74 08 4c 89 ff e8 c4 50 f7 ff 49 8b 07 a8 03 75 62
> RSP: 0018:ffffc90004df7500 EFLAGS: 00010206
> RAX: 00000000177780ff RBX: ffffffff822de139 RCX: 14bab840e71f4400
> RDX: 0000000000000000 RSI: ffffffff8bc074c0 RDI: ffffffff8bc07480
> RBP: 0000000000000088 R08: 0000000000000000 R09: ffffffff822de139
> R10: dffffc0000000000 R11: fffffbfff1f3c1ef R12: dffffc0000000000
> R13: ffff88823c63b5c0 R14: 0000000000000001 R15: 00000000bbbc07f8
> FS:  0000555570ae6500(0000) GS:ffff8882a9d12000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555562d8c5c8 CR3: 0000000113444000 CR4: 00000000000006f0
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
> [akpm@linux-foundation.org ast@kernel.org cgroups@vger.kernel.org gehao@k=
ylinos.cn hannes@cmpxchg.org hao.ge@linux.dev harry.yoo@oracle.com linux-ke=
rnel@vger.kernel.org linux-mm@kvack.org mhocko@kernel.org muchun.song@linux=
.dev roman.gushchin@linux.dev shakeel.butt@linux.dev surenb@google.com vbab=
ka@suse.cz]
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
-upstream-moderation/68ee41cb.050a0220.91a22.020b.GAE%40google.com.
