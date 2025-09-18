Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEE72DAFCA
	for <syzbot@lists.linux.dev>; Thu, 18 Sep 2025 19:39:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1758224350; cv=none; b=nDa6rq/yqyRSjlsDGhk3XrQyWEr1YbURN5ZCeU75hF7qEiHIKnpIPbCJZAdxzqEQ1Ueclge/+2CwwqCykqdZeYK9lkleyCdsrHtrfhFsReCnQXjPuyYPUPzxt7trVW32p4XaI7xiq69AHvELcaeXW/y5NKLBij+/jTMFUSoyjqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1758224350; c=relaxed/simple;
	bh=TZO3kp1aNkELP5qz0PzpJpDnSlfnM7kqAPr9HBFcXCI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=JeHGIVKtGVrdxBZ5TZc4Nfx/zBKH4j/DewqCLZkELvkb+oxgwf1lbVib8HWXvzuCcnzl6K0nE6/FVQ3tY+vjwtfF8JqlVAJIWrzLLEb4VqTPBMkCc/kb++2I+oiHkLtdIFG7JpI7gL11/jDhicvstPMbwPQerQu5ptriFITklZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=0Pq6QOq4; arc=none smtp.client-ip=209.85.161.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="0Pq6QOq4"
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-61ea79c1e91so837452eaf.3
        for <syzbot@lists.linux.dev>; Thu, 18 Sep 2025 12:39:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1758224348; x=1758829148; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=CD3pmvqCQIya4fC9aJgeZN0OIipUTmrRXUCRKoj1sg0=;
        b=0Pq6QOq4LMcwIjAQBB1bPtG+/fucM8UvDOZYDvt/CfRTySAXTC7ckdEuZS7rGygzu3
         AaxSS4MCMVMo0BGl6n0BbTW0fbmS2fScMKoDpjFhOFD4SIY0aXmCIKhnwXvmPkh9f62g
         GlLssmoH8G4K8Zgw/1Mewa4LLFAgqVMGQJVLexV/GRn3sG9Vy84ane2XVSf9ykxq0KFq
         Go4FGLRLV2p1QjCSTBaxR0YC8RzuCgoG7JfzFRPgpttKzRwXTrka89xyQEBVNSkyDk1p
         hZZJpo9zdWlur3/Jbfy4V0/MAAvse8OZSSqjICJ9SId2uiJYASKr6y802rCFDeDTXEkw
         oDUw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1758224348; x=1758829148;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=CD3pmvqCQIya4fC9aJgeZN0OIipUTmrRXUCRKoj1sg0=;
        b=ujFqfRmaoUZ1GjOlm41VfEWEeTTSYeX6M8gximnux0fP4haP6iNGdMCCj4wvlarlT4
         0GFdXB/ttv4cZ9/+kHXOHlDLuFvj3if20Yo7V6SvOkNwUIezgbRbwa+vGhNiud2+2NIm
         A7I7XTMpiLZfKlbGhVvHjynEa3jm5VLpn9pRVNE3IOEN5ETZAgPv+q3YOgC8qe7Yt15Z
         ec6PBBzhGUPnSVY8U//i78YL16jX+7XqHJP1AXc09U0i000Bp7NWLDFIvpzVJ2X5BDGx
         LFUzMKmmDd1Dciwh2uO5NgHlzw4uoRup2Nho7AsC0CNHHTpVI3bA95D5FLVSpojn5DgL
         z/KQ==
X-Forwarded-Encrypted: i=1; AJvYcCX795px+ssFjwij7Klnipv3JSnsJqJVxQh7tALwg7YrBSyPCXDZwyaeJaBbjo50XsZ0Rh5dMMg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwPuNNCxdVRqd3hedtuCVHSsegKGMCP4nOkswKsQV/z4I/7dlu
	yDpuvCi87WQPArU0MefubtpKJpNGAsqG0qTRP6rOwBpycnP7oY/VmRwK8GSG5mgLrxp5ZfIYKWi
	Upx/tdNGjmYbrWsdx8OQ9sbH9cTioOU3hKEgLE2oM
X-Gm-Gg: ASbGncsnD3duvzT4SDm5yoSyDQ8FKY+htlfo3MdqtkjnNQXXhQp6+BGth/mSY7LJ2Aj
	Q1oW89YA6WXB7CejeimuHJz2iD8OdEsAPX8eeFi+uJFUeTnfnSR97FV5/Fgz5ccV//70OE8JAft
	coHrxL65DnOvuooDmh7J4B26wo+Ir5VuOL22oSdE0QvqqnUPcnWY6Q7sJQYMK6C3+TLnLdMg5RM
	Uy5FTN/WGFCi0UBE3K1Pb2RD+eaF2YwKgjl9LM/999FXangph8MTRlUGvOGo9mMNg==
X-Google-Smtp-Source: AGHT+IEtXdIF7WovpbNRUZzn6X5EsjIsMWn0SqG+A3RSaVBlxNeUun+ovTlejlqlfpA2YtuCCu4N0Kl0bcycdoCWoTo=
X-Received: by 2002:a05:6808:4fd0:b0:438:4356:b533 with SMTP id
 5614622812f47-43d6c252629mr284646b6e.29.1758224347476; Thu, 18 Sep 2025
 12:39:07 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68cc2d82.050a0220.28a605.0008.GAE@google.com>
In-Reply-To: <68cc2d82.050a0220.28a605.0008.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 18 Sep 2025 21:38:55 +0200
X-Gm-Features: AS18NWBdaRqZ-5WOPnl8uFlXrIkK7nS7xadXFThmUC2MOOe7Q9xaLGcp-vuN74A
Message-ID: <CANp29Y4UrEsGCF1uwvqY8-6yA8kNDur2scOAqL87o8F90XRdtg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Compiler-Based Capability- and Locking-Analysis
To: syzbot ci <syzbot+ci21e81c3e9679b2a0@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Sep 18, 2025 at 6:04=E2=80=AFPM syzbot ci
<syzbot+ci21e81c3e9679b2a0@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] Compiler-Based Capability- and Locking-Analysis
> https://lore.kernel.org/all/20250918140451.1289454-1-elver@google.com
> * [PATCH v3 01/35] compiler_types: Move lock checking attributes to compi=
ler-capability-analysis.h
> * [PATCH v3 02/35] compiler-capability-analysis: Add infrastructure for C=
lang's capability analysis
> * [PATCH v3 03/35] compiler-capability-analysis: Add test stub
> * [PATCH v3 04/35] Documentation: Add documentation for Compiler-Based Ca=
pability Analysis
> * [PATCH v3 05/35] checkpatch: Warn about capability_unsafe() without com=
ment
> * [PATCH v3 06/35] cleanup: Basic compatibility with capability analysis
> * [PATCH v3 07/35] lockdep: Annotate lockdep assertions for capability an=
alysis
> * [PATCH v3 08/35] locking/rwlock, spinlock: Support Clang's capability a=
nalysis
> * [PATCH v3 09/35] compiler-capability-analysis: Change __cond_acquires t=
o take return value
> * [PATCH v3 10/35] locking/mutex: Support Clang's capability analysis
> * [PATCH v3 11/35] locking/seqlock: Support Clang's capability analysis
> * [PATCH v3 12/35] bit_spinlock: Include missing <asm/processor.h>
> * [PATCH v3 13/35] bit_spinlock: Support Clang's capability analysis
> * [PATCH v3 14/35] rcu: Support Clang's capability analysis
> * [PATCH v3 15/35] srcu: Support Clang's capability analysis
> * [PATCH v3 16/35] kref: Add capability-analysis annotations
> * [PATCH v3 17/35] locking/rwsem: Support Clang's capability analysis
> * [PATCH v3 18/35] locking/local_lock: Include missing headers
> * [PATCH v3 19/35] locking/local_lock: Support Clang's capability analysi=
s
> * [PATCH v3 20/35] locking/ww_mutex: Support Clang's capability analysis
> * [PATCH v3 21/35] debugfs: Make debugfs_cancellation a capability struct
> * [PATCH v3 22/35] compiler-capability-analysis: Remove Sparse support
> * [PATCH v3 23/35] compiler-capability-analysis: Remove __cond_lock() fun=
ction-like helper
> * [PATCH v3 24/35] compiler-capability-analysis: Introduce header suppres=
sions
> * [PATCH v3 25/35] compiler: Let data_race() imply disabled capability an=
alysis
> * [PATCH v3 26/35] MAINTAINERS: Add entry for Capability Analysis
> * [PATCH v3 27/35] kfence: Enable capability analysis
> * [PATCH v3 28/35] kcov: Enable capability analysis
> * [PATCH v3 29/35] kcsan: Enable capability analysis
> * [PATCH v3 30/35] stackdepot: Enable capability analysis
> * [PATCH v3 31/35] rhashtable: Enable capability analysis
> * [PATCH v3 32/35] printk: Move locking annotation to printk.c
> * [PATCH v3 33/35] security/tomoyo: Enable capability analysis
> * [PATCH v3 34/35] crypto: Enable capability analysis
> * [PATCH v3 35/35] sched: Enable capability analysis for core.c and fair.=
c
>
> and found the following issue:
> general protection fault in validate_page_before_insert
>
> Full report is available here:
> https://ci.syzbot.org/series/81182522-74c0-4494-bcf8-976133df7dc7
>
> ***
>
> general protection fault in validate_page_before_insert
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      f83ec76bf285bea5727f478a68b894f5543ca76e
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/8f7ff868-4cf7-40da-b62b-45ebfec4e=
994/config
>
> cgroup: Unknown subsys name 'net'
> cgroup: Unknown subsys name 'cpuset'
> cgroup: Unknown subsys name 'rlimit'
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000001: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> CPU: 0 UID: 0 PID: 5775 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:validate_page_before_insert+0x2a/0x300
> Code: 55 41 57 41 56 41 55 41 54 53 48 89 f3 49 89 fe 49 bd 00 00 00 00 0=
0 fc ff df e8 f1 3f b3 ff 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 ff e8 17 b3 16 00 4d 8b 3f 4c 89 fe 48
> RSP: 0018:ffffc90002a5f608 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888022891cc0
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888028c71200
> RBP: ffffc90002a5f720 R08: 0000000000000000 R09: 1ffff11021cf81e0
> R10: dffffc0000000000 R11: ffffed1021cf81e1 R12: dffffc0000000000
> R13: dffffc0000000000 R14: ffff888028c71200 R15: 0000000000000008
> FS:  00005555815ad500(0000) GS:ffff8880b8615000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1788fd20b8 CR3: 000000010d8a4000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  insert_page+0x90/0x2c0
>  kcov_mmap+0xc3/0x130
>  mmap_region+0x18ae/0x20c0
>  do_mmap+0xc45/0x10d0
>  vm_mmap_pgoff+0x2a6/0x4d0
>  ksys_mmap_pgoff+0x51f/0x760
>  do_syscall_64+0xfa/0x3b0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1788d8ebe3
> Code: f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 0=
0 41 89 ca 41 f7 c1 ff 0f 00 00 75 14 b8 09 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 25 c3 0f 1f 40 00 48 c7 c0 a8 ff ff ff 64 c7
> RSP: 002b:00007ffc8a37e638 EFLAGS: 00000246 ORIG_RAX: 0000000000000009
> RAX: ffffffffffffffda RBX: 00007ffc8a37e670 RCX: 00007f1788d8ebe3
> RDX: 0000000000000003 RSI: 0000000000400000 RDI: 00007f17867ff000
> RBP: 00007ffc8a37e940 R08: 00000000000000d8 R09: 0000000000000000
> R10: 0000000000000011 R11: 0000000000000246 R12: 0000000000000003
> R13: 0000000000000000 R14: 00007f1788fa11c0 R15: 00007f1788e2e478
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:validate_page_before_insert+0x2a/0x300
> Code: 55 41 57 41 56 41 55 41 54 53 48 89 f3 49 89 fe 49 bd 00 00 00 00 0=
0 fc ff df e8 f1 3f b3 ff 4c 8d 7b 08 4c 89 f8 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 ff e8 17 b3 16 00 4d 8b 3f 4c 89 fe 48
> RSP: 0018:ffffc90002a5f608 EFLAGS: 00010202
> RAX: 0000000000000001 RBX: 0000000000000000 RCX: ffff888022891cc0
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffff888028c71200
> RBP: ffffc90002a5f720 R08: 0000000000000000 R09: 1ffff11021cf81e0
> R10: dffffc0000000000 R11: ffffed1021cf81e1 R12: dffffc0000000000
> R13: dffffc0000000000 R14: ffff888028c71200 R15: 0000000000000008
> FS:  00005555815ad500(0000) GS:ffff8880b8615000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1788fd20b8 CR3: 000000010d8a4000 CR4: 00000000000006f0
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
> [arnd@arndb.de boqun.feng@gmail.com bvanassche@acm.org corbet@lwn.net dav=
em@davemloft.net dvyukov@google.com edumazet@google.com elver@google.com fr=
ederic@kernel.org glider@google.com gregkh@linuxfoundation.org hch@lst.de h=
erbert@gondor.apana.org.au irogers@google.com jannh@google.com joelagnelf@n=
vidia.com josh@joshtriplett.org justinstitt@google.com kasan-dev@googlegrou=
ps.com kees@kernel.org linux-crypto@vger.kernel.org linux-doc@vger.kernel.o=
rg linux-kbuild@vger.kernel.org linux-kernel@vger.kernel.org linux-mm@kvack=
.org linux-security-module@vger.kernel.org linux-sparse@vger.kernel.org llv=
m@lists.linux.dev longman@redhat.com luc.vanoostenryck@gmail.com lukas.bulw=
ahn@gmail.com mark.rutland@arm.com mathieu.desnoyers@efficios.com mingo@ker=
nel.org mingo@redhat.com morbo@google.com nathan@kernel.org neeraj.upadhyay=
@kernel.org nick.desaulniers@gmail.com ojeda@kernel.org paulmck@kernel.org =
penguin-kernel@i-love.sakura.ne.jp peterz@infradead.org rcu@vger.kernel.org=
 rostedt@goodmis.org takedakn@nttdata.co.jp tglx@linutronix.de tgraf@suug.c=
h urezki@gmail.com will@kernel.org]
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
-upstream-moderation/68cc2d82.050a0220.28a605.0008.GAE%40google.com.
