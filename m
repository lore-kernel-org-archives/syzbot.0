Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 135732C0F81
	for <syzbot@lists.linux.dev>; Fri, 19 Sep 2025 09:21:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758273721; cv=none; b=ouPda3o2OAHiL0oGYz7aLSlZkHrmp+V/olYppLIkLtg9Dro9tHCq1BvA3E1XHZNfJaW7rYsLWXuK94lJZdjezdGT04dmzqrOV0d3iMfdW+ojzvGrfZ6ZLiQHaAv/g9K2sFSJvTOg/ZHMEJq/N2hlf5mdU9pEJZTzJPZb8ftJ+Iw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758273721; c=relaxed/simple;
	bh=qb4ze/aofVEsM++c4W5E8+qNY6C9HhNc85GzOpXWSO8=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MG9Mo9LHa2do6sF1ErbxIVekqPngkMSj2xs4gg2rE4pPhEHxJ38Ex2uh+gTuYCRUf1lh/BhfHhUFd5Axf06mwXgB8Ga4A65b74l5XmPxsM3K1Mhc+efZvArLaixXIflK1buqE7shMMktHkJLLVxbBHJ0h0mskT9qn9Nz+QySA54=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0vwdEAnv; arc=none smtp.client-ip=209.85.216.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0vwdEAnv"
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-32e372c413aso1956292a91.0
        for <syzbot@lists.linux.dev>; Fri, 19 Sep 2025 02:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758273718; x=1758878518; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Z9cINSDTWBM2Tv4jYPTBmDGlfEkWYS+6S8PkKVT8EaM=;
        b=0vwdEAnv4u+r+XnizoVY2OHWXudR/7pcKyf7PRASMUGKyMvodU1wjVHfzCq2msXoKY
         A71z04gv53ZP6LA2fFVN5KenCuZAkJujWn6+pzA/suF+2iS5g1rk825gCgzfMetrtJfh
         Cs4Q8ju8vFsGQY8C1g6Y0kX82tKIHhCMYIKmUbrYG475iIx1UKjw0dNKzD6C6kUppkve
         wz30HhunGZ1I70Ld1L1/9mo7oPGLpLwgNDKI2YBcUrHpnSmNjPhanA3z0xlQVZtWA6Nt
         Dxber7qLlpi+a8W3yR8pE9+9jAVKabxKrlBja4ZsgqIh4Dyt7MKG+Fzp9JZIKcIAGs39
         Iuag==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758273718; x=1758878518;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=Z9cINSDTWBM2Tv4jYPTBmDGlfEkWYS+6S8PkKVT8EaM=;
        b=S/fOO37MNB5XfPh9Q+0iaePmhXBrxK5zbBUBB70dGbdrR5499n2Uf0+hE+wAGOQgnX
         Uk8oGLMReCoy2KJtVVXNUasp5ZyTCPNOI/4prkSsbVrqIsQ2lZLVEq99+IW9gxa7SDLP
         JHKqbBmqo7ofBwMO+xSxxtLFIf9rne6bZ52M5VM+BmMHUdiY1o7EKf1NidPjI0oGyhK4
         Bleq1hgotHjXMjybXQBKD5//Dfg4d592krntjGuTjQVRq6iI2b7G1d665wKW1oESgPZw
         XN+O1QRbI9T63JN2Cv02Df3COqFfQKsG/P7Kdb4/70J5erX/PNvfYZoP6u6z823NAOYj
         GKAg==
X-Forwarded-Encrypted: i=1; AJvYcCV/7Rr/4w+kfxELXhsiSyKSDunBaD/VuaNeZZMpzVvJgxviLO2A/CK/6i6pALUR7l9CTT5DPI8=@lists.linux.dev
X-Gm-Message-State: AOJu0YziTfHZU/LdcmXmeyz1GNyaYUgva4eefJnxW6ztMRbjho65/qLq
	4azb7BKyJb1OZTx0kJfVzohzOAoYwgSGH/CIIF5RFf4hfyxQGycgtJDdZcyVXQy4tcrCCI+ID24
	mmyjNUK4jZEi7PZ0lWJGzB4CtM0oIFst1hIPQySum
X-Gm-Gg: ASbGncvnEUuackHIEykmKOrg9W7hp8m1LUVgxMZmzdJhSRgxYZjd2lUS2uvPirOl+5y
	HstioHtd40xzVwFMb9qIunvxUKwc0XKRgVDhF6DLIAh+r1DJVna5C3OlJtY0CqV/liTlPhmQrXw
	EvJrmJzaCF3wvUG2/FeumzqvAMXa27/XH5UYVLWJsUSSAJqy2oUXFdmsJFnG2qsikwhJtJiDiqV
	79aP4goCfWEKMnG+ckOYDY84sMS3yf1sLRc
X-Google-Smtp-Source: AGHT+IGUt4b/j2jlHWVrlmY8MEdFNDGFD5FnO5buzO8V1MvpMOvmB39V+k5uGjtDXXX+5I8IyPhoY1WN/qTaje/GFu4=
X-Received: by 2002:a17:90b:48:b0:330:65b8:1bdf with SMTP id
 98e67ed59e1d1-3309836e62amr3318348a91.32.1758273718035; Fri, 19 Sep 2025
 02:21:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68cc2d82.050a0220.28a605.0008.GAE@google.com> <CANp29Y4UrEsGCF1uwvqY8-6yA8kNDur2scOAqL87o8F90XRdtg@mail.gmail.com>
In-Reply-To: <CANp29Y4UrEsGCF1uwvqY8-6yA8kNDur2scOAqL87o8F90XRdtg@mail.gmail.com>
From: Marco Elver <elver@google.com>
Date: Fri, 19 Sep 2025 11:21:21 +0200
X-Gm-Features: AS18NWDDiiaVtsQn0CnBqAOOjpKlG9NZ3i2Y91SOXYcQEOgrAlw7g7a3Fh0kfaM
Message-ID: <CANpmjNMEpGUzJNvMNT-5GG9mKkBo6B3AmO_CE-Gsw-RO=xXvtQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Compiler-Based Capability- and Locking-Analysis
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot ci <syzbot+ci21e81c3e9679b2a0@syzkaller.appspotmail.com>, 
	syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

Glad to have syzbot ci here! Wouldn't have caught otherwise.

On Thu, 18 Sept 2025 at 21:39, 'Aleksandr Nogikh' via
syzkaller-upstream-moderation
<syzkaller-upstream-moderation@googlegroups.com> wrote:
>
> #syz upstream
>
> On Thu, Sep 18, 2025 at 6:04=E2=80=AFPM syzbot ci
> <syzbot+ci21e81c3e9679b2a0@syzkaller.appspotmail.com> wrote:
> >
> > syzbot ci has tested the following series
> >
> > [v3] Compiler-Based Capability- and Locking-Analysis
> > https://lore.kernel.org/all/20250918140451.1289454-1-elver@google.com
> > * [PATCH v3 01/35] compiler_types: Move lock checking attributes to com=
piler-capability-analysis.h
> > * [PATCH v3 02/35] compiler-capability-analysis: Add infrastructure for=
 Clang's capability analysis
> > * [PATCH v3 03/35] compiler-capability-analysis: Add test stub
> > * [PATCH v3 04/35] Documentation: Add documentation for Compiler-Based =
Capability Analysis
> > * [PATCH v3 05/35] checkpatch: Warn about capability_unsafe() without c=
omment
> > * [PATCH v3 06/35] cleanup: Basic compatibility with capability analysi=
s
> > * [PATCH v3 07/35] lockdep: Annotate lockdep assertions for capability =
analysis
> > * [PATCH v3 08/35] locking/rwlock, spinlock: Support Clang's capability=
 analysis
> > * [PATCH v3 09/35] compiler-capability-analysis: Change __cond_acquires=
 to take return value
> > * [PATCH v3 10/35] locking/mutex: Support Clang's capability analysis
> > * [PATCH v3 11/35] locking/seqlock: Support Clang's capability analysis
> > * [PATCH v3 12/35] bit_spinlock: Include missing <asm/processor.h>
> > * [PATCH v3 13/35] bit_spinlock: Support Clang's capability analysis
> > * [PATCH v3 14/35] rcu: Support Clang's capability analysis
> > * [PATCH v3 15/35] srcu: Support Clang's capability analysis
> > * [PATCH v3 16/35] kref: Add capability-analysis annotations
> > * [PATCH v3 17/35] locking/rwsem: Support Clang's capability analysis
> > * [PATCH v3 18/35] locking/local_lock: Include missing headers
> > * [PATCH v3 19/35] locking/local_lock: Support Clang's capability analy=
sis
> > * [PATCH v3 20/35] locking/ww_mutex: Support Clang's capability analysi=
s
> > * [PATCH v3 21/35] debugfs: Make debugfs_cancellation a capability stru=
ct
> > * [PATCH v3 22/35] compiler-capability-analysis: Remove Sparse support
> > * [PATCH v3 23/35] compiler-capability-analysis: Remove __cond_lock() f=
unction-like helper
> > * [PATCH v3 24/35] compiler-capability-analysis: Introduce header suppr=
essions
> > * [PATCH v3 25/35] compiler: Let data_race() imply disabled capability =
analysis
> > * [PATCH v3 26/35] MAINTAINERS: Add entry for Capability Analysis
> > * [PATCH v3 27/35] kfence: Enable capability analysis
> > * [PATCH v3 28/35] kcov: Enable capability analysis
> > * [PATCH v3 29/35] kcsan: Enable capability analysis
> > * [PATCH v3 30/35] stackdepot: Enable capability analysis
> > * [PATCH v3 31/35] rhashtable: Enable capability analysis
> > * [PATCH v3 32/35] printk: Move locking annotation to printk.c
> > * [PATCH v3 33/35] security/tomoyo: Enable capability analysis
> > * [PATCH v3 34/35] crypto: Enable capability analysis
> > * [PATCH v3 35/35] sched: Enable capability analysis for core.c and fai=
r.c
> >
> > and found the following issue:
> > general protection fault in validate_page_before_insert
> >
> > Full report is available here:
> > https://ci.syzbot.org/series/81182522-74c0-4494-bcf8-976133df7dc7
> >
> > ***
> >
> > general protection fault in validate_page_before_insert
> >
> > tree:      torvalds
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/tor=
valds/linux
> > base:      f83ec76bf285bea5727f478a68b894f5543ca76e
> > arch:      amd64
> > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1=
~exp1~20250708183702.136), Debian LLD 20.1.8
> > config:    https://ci.syzbot.org/builds/8f7ff868-4cf7-40da-b62b-45ebfec=
4e994/config
> >
> > cgroup: Unknown subsys name 'net'
> > cgroup: Unknown subsys name 'cpuset'
> > cgroup: Unknown subsys name 'rlimit'
> > Oops: general protection fault, probably for non-canonical address 0xdf=
fffc0000000001: 0000 [#1] SMP KASAN PTI
> > KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> > CPU: 0 UID: 0 PID: 5775 Comm: syz-executor Not tainted syzkaller #0 PRE=
EMPT(full)
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-=
1.16.2-1 04/01/2014
> > RIP: 0010:validate_page_before_insert+0x2a/0x300
> > Code: 55 41 57 41 56 41 55 41 54 53 48 89 f3 49 89 fe 49 bd 00 00 00 00=
 00 fc ff df e8 f1 3f b3 ff 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 28 =
00 74 08 4c 89 ff e8 17 b3 16 00 4d 8b 3f 4c 89 fe 48
> > RSP: 0018:ffffc90002a5f608 EFLAGS: 00010202
> > RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888022891cc0
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888028c71200
> > RBP: ffffc90002a5f720 R08: 0000000000000000 R09: 1ffff11021cf81e0
> > R10: dffffc0000000000 R11: ffffed1021cf81e1 R12: dffffc0000000000
> > R13: dffffc0000000000 R14: ffff888028c71200 R15: 0000000000000008
> > FS:  00005555815ad500(0000) GS:ffff8880b8615000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f1788fd20b8 CR3: 000000010d8a4000 CR4: 00000000000006f0
> > Call Trace:
> >  <TASK>
> >  insert_page+0x90/0x2c0
> >  kcov_mmap+0xc3/0x130
> >  mmap_region+0x18ae/0x20c0
> >  do_mmap+0xc45/0x10d0
> >  vm_mmap_pgoff+0x2a6/0x4d0
> >  ksys_mmap_pgoff+0x51f/0x760
> >  do_syscall_64+0xfa/0x3b0
> >  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> > RIP: 0033:0x7f1788d8ebe3
> > Code: f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f=
 00 41 89 ca 41 f7 c1 ff 0f 00 00 75 14 b8 09 00 00 00 0f 05 <48> 3d 00 f0 =
ff ff 77 25 c3 0f 1f 40 00 48 c7 c0 a8 ff ff ff 64 c7
> > RSP: 002b:00007ffc8a37e638 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
> > RAX: ffffffffffffffda RBX: 00007ffc8a37e670 RCX: 00007f1788d8ebe3
> > RDX: 0000000000000003 RSI: 0000000000400000 RDI: 00007f17867ff000
> > RBP: 00007ffc8a37e940 R08: 00000000000000d8 R09: 0000000000000000
> > R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000003
> > R13: 0000000000000000 R14: 00007f1788fa11c0 R15: 00007f1788e2e478
> >  </TASK>
> > Modules linked in:
> > ---[ end trace 0000000000000000 ]---
> > RIP: 0010:validate_page_before_insert+0x2a/0x300
> > Code: 55 41 57 41 56 41 55 41 54 53 48 89 f3 49 89 fe 49 bd 00 00 00 00=
 00 fc ff df e8 f1 3f b3 ff 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 28 =
00 74 08 4c 89 ff e8 17 b3 16 00 4d 8b 3f 4c 89 fe 48
> > RSP: 0018:ffffc90002a5f608 EFLAGS: 00010202
> > RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888022891cc0
> > RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888028c71200
> > RBP: ffffc90002a5f720 R08: 0000000000000000 R09: 1ffff11021cf81e0
> > R10: dffffc0000000000 R11: ffffed1021cf81e1 R12: dffffc0000000000
> > R13: dffffc0000000000 R14: ffff888028c71200 R15: 0000000000000008
> > FS:  00005555815ad500(0000) GS:ffff8880b8615000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 00007f1788fd20b8 CR3: 000000010d8a4000 CR4: 00000000000006f0
> >
> >
> > ***
> >
> > If these findings have caused you to resend the series or submit a
> > separate fix, please add the following tag to your commit message:
> >   Tested-by: syzbot@syzkaller.appspotmail.com
> >
> > ---
> > This report is generated by a bot. It may contain errors.
> > syzbot ci engineers can be reached at syzkaller@googlegroups.com.
> >
> > The email will later be sent to:
> > [arnd@arndb.de boqun.feng@gmail.com bvanassche@acm.org corbet@lwn.net d=
avem@davemloft.net dvyukov@google.com edumazet@google.com elver@google.com =
frederic@kernel.org glider@google.com gregkh@linuxfoundation.org hch@lst.de=
 herbert@gondor.apana.org.au irogers@google.com jannh@google.com joelagnelf=
@nvidia.com josh@joshtriplett.org justinstitt@google.com kasan-dev@googlegr=
oups.com kees@kernel.org linux-crypto@vger.kernel.org linux-doc@vger.kernel=
.org linux-kbuild@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kva=
ck.org linux-security-module@vger.kernel.org linux-sparse@vger.kernel.org l=
lvm@lists.linux.dev longman@redhat.com luc.vanoostenryck@gmail.com lukas.bu=
lwahn@gmail.com mark.rutland@arm.com mathieu.desnoyers@efficios.com mingo@k=
ernel.org mingo@redhat.com morbo@google.com nathan@kernel.org neeraj.upadhy=
ay@kernel.org nick.desaulniers@gmail.com ojeda@kernel.org paulmck@kernel.or=
g penguin-kernel@i-love.sakura.ne.jp peterz@infradead.org rcu@vger.kernel.o=
rg rostedt@goodmis.org takedakn@nttdata.co.jp tglx@linutronix.de tgraf@suug=
.ch urezki@gmail.com will@kernel.org]
> >
> > If the report looks fine to you, reply with:
> > #syz upstream
> >
> > --
> > You received this message because you are subscribed to the Google Grou=
ps "syzkaller-upstream-moderation" group.
> > To unsubscribe from this group and stop receiving emails from it, send =
an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> > To view this discussion visit https://groups.google.com/d/msgid/syzkall=
er-upstream-moderation/68cc2d82.050a0220.28a605.0008.GAE%40google.com.
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/CANp29Y4UrEsGCF1uwvqY8-6yA8kNDur2scOAqL87o8F90XRdtg%40=
mail.gmail.com.
