Received: from mail-oo1-f47.google.com (mail-oo1-f47.google.com [209.85.161.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79A42B665
	for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 18:45:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760553922; cv=none; b=qHitzfr2mdy5nyfyG77Bm7jow3wyHjogva2pvYiz3o+6l/kycLOVb7FFyhJcruvnYLGl7sxUiR1cGuX0ogP3TRv8pHipzxPPufpimqQN5JLA5oB9gAj+4ZmKxrwqrZuMMDbiCXxDP3HqYRxTol4tc6G+UiEgFQyIasUMjXNTxaM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760553922; c=relaxed/simple;
	bh=XUKk5ynFvTH09+KYDWBc3a8IBO+b7Gve5zdm6qd1vSQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MjyQ5q1iUUPfb8hJzC8t6OHnEomjzvyp8dB59eFCJB0IyfPJ+l36Nou+PQwoCKAqbirYaQhrjlAoKusYB3jChSS6v8xw+7H4aIvPslyWfwqiqwtnQ9uf0CojtDuNibiFlSeOqhSqn5EusoobBZeagLqs0eTrltBwGG0613atxz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nvZxO70Z; arc=none smtp.client-ip=209.85.161.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nvZxO70Z"
Received: by mail-oo1-f47.google.com with SMTP id 006d021491bc7-65033a46f05so1454667eaf.0
        for <syzbot@lists.linux.dev>; Wed, 15 Oct 2025 11:45:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1760553919; x=1761158719; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=zyMdkV5dDJ9gmppMl3WY19o6nRXVJ54V6Mxh7GLw7uo=;
        b=nvZxO70Z+zC5adGrI0ElvC6UGtMaU/ID28PaEUtHPPTgkyRTG24jxCr4QcVwTeWyLN
         qfmJFjU19gsiwm1TxxIzyzfY4TF3jXeAQU2RaJEuAmmjHbDDoiToN326CT7ZpaJ6sJiE
         Gylb10KVdFqZQlvwn+4SeGnwQlSJBjhHsWeCqR3//68uRHFGPXZ55jNVG1YdbtsFlGOT
         Di+DorJPSgaWYb1gimlMKSRJym+Hc71n4Rhvn3fblpSlhwfpZ50acVGJKN4YiAU8otsi
         ShsfV+ZFfyoZ1o4PLQfrGEg8MUjfEah1H/OemTkC5Gr3HhzZKHSXc68cNy5thSSc6vah
         MKeQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1760553919; x=1761158719;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=zyMdkV5dDJ9gmppMl3WY19o6nRXVJ54V6Mxh7GLw7uo=;
        b=G2yDY54kuTech1X+wwdfDSV96U7kgjxzl1v0gWKZETzOXaTOTCHlwxLxCPYVmtdIsS
         b2HlOLpqhJ6ZsSBDhzA4HmFV0OoqUin3X0XRZ5CeCiTOzdl9zk1zD+8SXbW/hmoiMdjO
         cIjY3IX/5TUMsgvnDZrN/TY9ITnh+7gHGvUSe8mm2rwlD1/kzPNaCnssXtxVZ9N1apui
         GYS20KWYdgxBAclShqyfYYZPXkP03pEKkQFClPZByYtiCiS8VmiuKhbjAiF0QThInbCz
         1AsU1kTTPhBlHRIwQ1QecSg4avJIGNbBlYCvXkT/ywMGKPRHPu9YtmdePnM+JS9GKpDg
         R5NA==
X-Forwarded-Encrypted: i=1; AJvYcCVN9dHo2eFnRG6RQrPseB+Q3aM0Y4m2hSeBdWyicWHLOc8Bc9wjJsiCsusWWYroICpCK3Wn5M0=@lists.linux.dev
X-Gm-Message-State: AOJu0YwTfyTtmFW5gnZPnoedgT6VbUS4jI2rbZQXIUppRIWg+nkwgkVR
	I5Hl0576VmJKmZHFz9tkNxYQYXPdscedOTHUf6QmBUJSC6bbpeiqO1kiw6RQGXux6G0pmVH5a0K
	0zflk+DtdS0cH0jiDcDYhHYNuwUPTdFjsiejbK8Do
X-Gm-Gg: ASbGnculE43SY9Or1F1oJnntoFvgPR27xDG4UOJ0Kd3MqWpPh4w26qPQVjnYoz2DXWw
	PmFw1zaK9Twyi4SNj8xTv34XM70Vk43nO1zGLr+1OdKK+2llnSMJeTeWJhpQmBJ81EoXjdv/Puu
	6j+RD9AbGvg4rpyRiDZFtMa8LCdSoUqO5Cq0ZAVGY76OSCEUysNqr0Jcw88qsYrw3bRXpzLqxE5
	V6oULXK5qrwX+TcH9XfYSpjAmbNgVu1rrjJfwziwrV3pMoeT+J/jWxOl2+a9l37uFFjoaRqM/t9
	CWpbsA9OXZ93f1sm6ktBA4hvzSn1xTV1V+a07MT8Iyc=
X-Google-Smtp-Source: AGHT+IF1VQ1sjwnZqADTQ66ko0IJ6737/69MQHUUxEpojkxJCbCZlqG+gQkol7rBShCWPdwC/jKjPe+lGljrTtVygvY=
X-Received: by 2002:a05:6808:2889:b0:441:8f74:fc1 with SMTP id
 5614622812f47-441994a8821mr8185471b6e.62.1760553919190; Wed, 15 Oct 2025
 11:45:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68efde7c.050a0220.91a22.02bb.GAE@google.com>
In-Reply-To: <68efde7c.050a0220.91a22.02bb.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 15 Oct 2025 20:45:07 +0200
X-Gm-Features: AS18NWBsK7H50YYAbHxeBQ9Reou90UOBtP_JyvTzKp5hfTdD7AVYWMl0QxfpN90
Message-ID: <CANp29Y7YAo+0NfZVMnSAQ-2c3H8_2Baj5zyx1Cj9MpWO9jx2SQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab
To: syzbot ci <syzbot+ci589653ca55210abe@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Oct 15, 2025 at 7:48=E2=80=AFPM syzbot ci
<syzbot+ci589653ca55210abe@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab
> https://lore.kernel.org/all/20251015125945.481950-1-hao.ge@linux.dev
> * [PATCH v4] slab: clear OBJEXTS_ALLOC_FAIL when freeing a slab
>
> and found the following issue:
> kernel BUG in __free_slab
>
> Full report is available here:
> https://ci.syzbot.org/series/61ff4fe1-2e84-410d-ad85-42ead772d9c8
>
> ***
>
> kernel BUG in __free_slab
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      3a8660878839faadb4f1a6dd72c3179c1df56787
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/e5875084-ea86-418c-979d-5b00cded8=
6ca/config
> syz repro: https://ci.syzbot.org/findings/1f8913d8-6d9a-448a-9419-90b758c=
82c3b/syz_repro
>
>  ___sys_sendmsg+0x21f/0x2a0 net/socket.c:2684
>  __sys_sendmsg net/socket.c:2716 [inline]
>  __do_sys_sendmsg net/socket.c:2721 [inline]
>  __se_sys_sendmsg net/socket.c:2719 [inline]
>  __x64_sys_sendmsg+0x19b/0x260 net/socket.c:2719
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> ------------[ cut here ]------------
> kernel BUG at mm/slab.h:544!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 15 Comm: ksoftirqd/0 Not tainted syzkaller #0 PREEMPT(=
full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:slab_obj_exts mm/slab.h:543 [inline]
> RIP: 0010:free_slab_obj_exts mm/slub.c:2178 [inline]
> RIP: 0010:unaccount_slab mm/slub.c:3186 [inline]
> RIP: 0010:__free_slab+0x1b8/0x1e0 mm/slub.c:3286
> Code: e8 2d 8a 0c ff 90 0f 0b 48 89 df 48 c7 c6 18 ad 91 8d e8 1b 8a 0c f=
f 90 0f 0b 48 89 df 48 c7 c6 9d 66 95 8d e8 09 8a 0c ff 90 <0f> 0b 48 89 df=
 48 c7 c6 18 ad 91 8d e8 f7 89 0c ff 90 0f 0b 48 89
> RSP: 0000:ffffc900001478b0 EFLAGS: 00010246
> RAX: 680205e52e87ff00 RBX: ffffea00044c3c80 RCX: 680205e52e87ff00
> RDX: 0000000000000000 RSI: ffffffff8d7e835a RDI: ffffffff8bc076e0
> RBP: 0000000000000001 R08: ffffffff8f9e1177 R09: 1ffffffff1f3c22e
> R10: dffffc0000000000 R11: fffffbfff1f3c22f R12: ffffffff821b61b0
> R13: ffffffff81a82877 R14: ffff888160415a00 R15: ffffea00044c3c98
> FS:  0000000000000000(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fef42bb12f8 CR3: 000000000df38000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  rcu_do_batch kernel/rcu/tree.c:2605 [inline]
>  rcu_core+0xcab/0x1770 kernel/rcu/tree.c:2861
>  handle_softirqs+0x286/0x870 kernel/softirq.c:622
>  run_ksoftirqd+0x9b/0x100 kernel/softirq.c:1063
>  smpboot_thread_fn+0x542/0xa60 kernel/smpboot.c:160
>  kthread+0x711/0x8a0 kernel/kthread.c:463
>  ret_from_fork+0x4bc/0x870 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:slab_obj_exts mm/slab.h:543 [inline]
> RIP: 0010:free_slab_obj_exts mm/slub.c:2178 [inline]
> RIP: 0010:unaccount_slab mm/slub.c:3186 [inline]
> RIP: 0010:__free_slab+0x1b8/0x1e0 mm/slub.c:3286
> Code: e8 2d 8a 0c ff 90 0f 0b 48 89 df 48 c7 c6 18 ad 91 8d e8 1b 8a 0c f=
f 90 0f 0b 48 89 df 48 c7 c6 9d 66 95 8d e8 09 8a 0c ff 90 <0f> 0b 48 89 df=
 48 c7 c6 18 ad 91 8d e8 f7 89 0c ff 90 0f 0b 48 89
> RSP: 0000:ffffc900001478b0 EFLAGS: 00010246
> RAX: 680205e52e87ff00 RBX: ffffea00044c3c80 RCX: 680205e52e87ff00
> RDX: 0000000000000000 RSI: ffffffff8d7e835a RDI: ffffffff8bc076e0
> RBP: 0000000000000001 R08: ffffffff8f9e1177 R09: 1ffffffff1f3c22e
> R10: dffffc0000000000 R11: fffffbfff1f3c22f R12: ffffffff821b61b0
> R13: ffffffff81a82877 R14: ffff888160415a00 R15: ffffea00044c3c98
> FS:  0000000000000000(0000) GS:ffff88818e70c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fef42bb12f8 CR3: 000000000df38000 CR4: 00000000000006f0
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
> [akpm@linux-foundation.org ast@kernel.org cl@gentwo.org gehao@kylinos.cn =
hao.ge@linux.dev harry.yoo@oracle.com linux-kernel@vger.kernel.org linux-mm=
@kvack.org rientjes@google.com roman.gushchin@linux.dev shakeel.butt@linux.=
dev surenb@google.com vbabka@suse.cz]
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
-upstream-moderation/68efde7c.050a0220.91a22.02bb.GAE%40google.com.
