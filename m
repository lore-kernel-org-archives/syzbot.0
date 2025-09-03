Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A3EFC1EA7CE
	for <syzbot@lists.linux.dev>; Wed,  3 Sep 2025 17:43:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756921421; cv=none; b=kKXFWZvIXZI1lhaAmNcIqBw4Hs+Hr6iTJHwxt8O0UHcCdIbKS+E04g9EfZ8hGCDqOqXgv3yF7mi4Y29lt4clCH616j8SyTWP/NwYqD0m2ZkgFekRXVK44Nr7HMtAoiO6fXtuWcg98EX6VumYaV5KsagHi1epoUWIRry7d+C/Wmk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756921421; c=relaxed/simple;
	bh=c05+fIV2a1v0jlSFhrWJ3VCkt0uqnLWL2byPXTs2/uw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=hLasyvCcy0ppDsp+GTvXKHcjnGrLzNuz2VInfrrhNGoxZxxFPojxbenGtylPbkkt2XhXG+tGwFRd8SMtQxUnAHYHqze+b4hiKEw9OmgBO29baiJ44jAJ5zgb3LAfqtvTpH14R8Si8lfE+6OYceRF/HVLpn80bI3xN4tfHbAxG8E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KxJuY1va; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KxJuY1va"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7456b27fac1so190842a34.2
        for <syzbot@lists.linux.dev>; Wed, 03 Sep 2025 10:43:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756921418; x=1757526218; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkSBG8BvSExi4Ihb1tPNlzzyWU/Xwl/SkxE5N429njs=;
        b=KxJuY1vaIpN4o7rDHxN0SXBPZ4+LT8+wf6B+cFmJvsjqmISdaiSMAacvAz0o68G3Zw
         bjS5ODztwQTEY1Ub7L8ruMbExgZ4KLTsi1d4GuT+M+m/ESjrQMHNIXWYE+8ccvDbq/pL
         nYTkVg0BQpm6jPMRSxfe+4yf0kXkutLhsQFXM6a/QzmylikGNd4Zctb01SkPHGphBcL4
         j6tXOM88F3SDQ5KKkC28lGU4bUBMXWIn7TIjs6APrzSlb9lz92ABli8KXckXMVgPxTl1
         w9LlZNwHqbYLEcSKg/ufWbQP8jNGfhpotZLxt8YJFpi6PzZ5MYjQFafXsczXxg/t4JJX
         RRWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756921418; x=1757526218;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lkSBG8BvSExi4Ihb1tPNlzzyWU/Xwl/SkxE5N429njs=;
        b=FsiSBxYcKEV5OeDawwieA0sl+GwuRYeco0JUisi+zwKIvU/XO7h6RWJWm7yJ/Vlcaj
         sx3qX17ji6P4GwntOsRxc1X6diFv8zp/sWGE/kQ1yW/yW46YztUVnU6KIBpMFS9rlqY/
         k1uQ5pGdtsWesqWYpD3BGvPb8zxYx5gSLdssT4wWkzfTsXXhVVNypqJHX6Y8nMCnfLJE
         f5FvTbNiWXP5SSY/jquhY2OFPsHl2XhHzL9rjHbaKbdaBjgYaWjYJOeIWiMMesj+EQDC
         aWt2VM+OQjFf/iy3iRkmSpBW3DZ+s+vQHBPqsmNFYttOtBtcEsi4XQe9XVjf82zO4HNa
         Y6Zg==
X-Forwarded-Encrypted: i=1; AJvYcCWnXUNW4DmgA65s0cFr/AG3BbDM28f89I3BmZJoaGWAoGGDXfnvXxFWy4qseBmQS16niyCIUaw=@lists.linux.dev
X-Gm-Message-State: AOJu0YxNaq5pmcpimWcYkReV31rG0xwZpBR6s/2F5pIc2TF8Cv1QAJHk
	tYGi4xDRdZLz/BWWDGmt3nwdQbsiqW9SUYI0VDLYkFUnRHD3dPRhFQ1YnDjnFMRtIurloVM3oGJ
	ZvpkQhoBnc//7To1ku7guIBSCKjy1JNZRtMOJsisHR9jMt+QeB3orNDpWchY=
X-Gm-Gg: ASbGnctfSLLFNoDUCONToUrapR32L45jFIWLPxuNH/lmNIlxF+AgECxYTwXEfczTPxb
	SlQi8NLEYkBIQQ9vew1JUXCeZgRre+xEBWH5U4eTE2iXu1DMiAA4s1yF8HIz8gdxYL/heOeziZw
	PWnti986T8bxHyzYI23aLkVj5Wyei734mnJyt0CbKmvQpFVfqsPY3XM0mF334/AKQ2Pa4ZCTer6
	cGleAi3fDFKlnZAlapn6m6lhvJRjk9KzXaJra+EHd/a/uo=
X-Google-Smtp-Source: AGHT+IGZEdOq9spng53+fB/QS8jEWtGVsbTA2w11L9biDYHDz5Vr13HiYceewZRoDlXPpD/WT+OmU+k9JnYdOqMMHrI=
X-Received: by 2002:a05:6830:dcc:b0:745:54e4:6da5 with SMTP id
 46e09a7af769-74569c6972emr10174120a34.0.1756921418293; Wed, 03 Sep 2025
 10:43:38 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68b86981.050a0220.3db4df.01f5.GAE@google.com>
In-Reply-To: <68b86981.050a0220.3db4df.01f5.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 3 Sep 2025 19:43:27 +0200
X-Gm-Features: Ac12FXxtena_4vCMSH7qrlSSUvy3OiENaifBK838HTD_C8W048K7Kry3xJZEN4k
Message-ID: <CANp29Y5w+AZ+P_9jFyLOcb5bWgobB7oB=AqSPCQjN6=MbsTdJQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: devmem: improve cpu cost of RX token management
To: syzbot ci <syzbot+ci21b000914d5f7f34@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Sep 3, 2025 at 6:15=E2=80=AFPM syzbot ci
<syzbot+ci21b000914d5f7f34@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: devmem: improve cpu cost of RX token management
> https://lore.kernel.org/all/20250902-scratch-bobbyeshleman-devmem-tcp-tok=
en-upstream-v1-0-d946169b5550@meta.com
> * [PATCH net-next 1/2] net: devmem: rename tx_vec to vec in dmabuf bindin=
g
> * [PATCH net-next 2/2] net: devmem: use niov array for token management
>
> and found the following issue:
> general protection fault in sock_devmem_dontneed
>
> Full report is available here:
> https://ci.syzbot.org/series/c0dc7223-4222-461c-b04b-b6f0004c7509
>
> ***
>
> general protection fault in sock_devmem_dontneed
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      864ecc4a6dade82d3f70eab43dad0e277aa6fc78
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/6c521908-0a73-48bc-a0fd-2576cf868=
361/config
> C repro:   https://ci.syzbot.org/findings/9374f388-d643-42ea-831b-872eb50=
00b3c/c_repro
> syz repro: https://ci.syzbot.org/findings/9374f388-d643-42ea-831b-872eb50=
00b3c/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 UID: 0 PID: 5993 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:sock_devmem_dontneed+0x3fd/0x960 net/core/sock.c:1112
> Code: 8b 44 24 40 44 8b 28 44 03 6c 24 14 48 8b 44 24 20 42 80 3c 20 00 7=
4 08 4c 89 ff e8 4d eb c9 f8 4d 8b 3f 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00=
 74 08 4c 89 ff e8 34 eb c9 f8 4d 8b 3f 4c 89 f8 48
> RSP: 0018:ffffc90001c4fac0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 1ffff11004ddcfe0
> RDX: ffff88801f6a8000 RSI: 0000000000000400 RDI: 0000000000000000
> RBP: ffffc90001c4fc50 R08: ffffc90001c4fbdf R09: 0000000000000000
> R10: ffffc90001c4fb60 R11: fffff52000389f7c R12: dffffc0000000000
> R13: 00000000ffffffff R14: 0000000000000000 R15: 0000000000000000
> FS:  000055558634d500(0000) GS:ffff8880b8614000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30e63fff CR3: 0000000026b68000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  sk_setsockopt+0x682/0x2dc0 net/core/sock.c:1302
>  do_sock_setsockopt+0x11b/0x1b0 net/socket.c:2340
>  __sys_setsockopt net/socket.c:2369 [inline]
>  __do_sys_setsockopt net/socket.c:2375 [inline]
>  __se_sys_setsockopt net/socket.c:2372 [inline]
>  __x64_sys_setsockopt+0x13f/0x1b0 net/socket.c:2372
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fea2bb8ebe9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc81c63348 EFLAGS: 00000246 ORIG_RAX: 0000000000000036
> RAX: ffffffffffffffda RBX: 00007fea2bdc5fa0 RCX: 00007fea2bb8ebe9
> RDX: 0000000000000050 RSI: 0000000000000001 RDI: 0000000000000003
> RBP: 00007fea2bc11e19 R08: 0000000000000048 R09: 0000000000000000
> R10: 0000200000000100 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fea2bdc5fa0 R14: 00007fea2bdc5fa0 R15: 0000000000000005
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:sock_devmem_dontneed+0x3fd/0x960 net/core/sock.c:1112
> Code: 8b 44 24 40 44 8b 28 44 03 6c 24 14 48 8b 44 24 20 42 80 3c 20 00 7=
4 08 4c 89 ff e8 4d eb c9 f8 4d 8b 3f 4c 89 f8 48 c1 e8 03 <42> 80 3c 20 00=
 74 08 4c 89 ff e8 34 eb c9 f8 4d 8b 3f 4c 89 f8 48
> RSP: 0018:ffffc90001c4fac0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 1ffff11004ddcfe0
> RDX: ffff88801f6a8000 RSI: 0000000000000400 RDI: 0000000000000000
> RBP: ffffc90001c4fc50 R08: ffffc90001c4fbdf R09: 0000000000000000
> R10: ffffc90001c4fb60 R11: fffff52000389f7c R12: dffffc0000000000
> R13: 00000000ffffffff R14: 0000000000000000 R15: 0000000000000000
> FS:  000055558634d500(0000) GS:ffff8880b8614000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30e63fff CR3: 0000000026b68000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   8b 44 24 40             mov    0x40(%rsp),%eax
>    4:   44 8b 28                mov    (%rax),%r13d
>    7:   44 03 6c 24 14          add    0x14(%rsp),%r13d
>    c:   48 8b 44 24 20          mov    0x20(%rsp),%rax
>   11:   42 80 3c 20 00          cmpb   $0x0,(%rax,%r12,1)
>   16:   74 08                   je     0x20
>   18:   4c 89 ff                mov    %r15,%rdi
>   1b:   e8 4d eb c9 f8          call   0xf8c9eb6d
>   20:   4d 8b 3f                mov    (%r15),%r15
>   23:   4c 89 f8                mov    %r15,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 20 00          cmpb   $0x0,(%rax,%r12,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 ff                mov    %r15,%rdi
>   34:   e8 34 eb c9 f8          call   0xf8c9eb6d
>   39:   4d 8b 3f                mov    (%r15),%r15
>   3c:   4c 89 f8                mov    %r15,%rax
>   3f:   48                      rex.W
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
> [almasrymina@google.com bobbyeshleman@gmail.com bobbyeshleman@meta.com da=
vem@davemloft.net dsahern@kernel.org edumazet@google.com horms@kernel.org k=
uba@kernel.org kuniyu@google.com linux-kernel@vger.kernel.org ncardwell@goo=
gle.com netdev@vger.kernel.org pabeni@redhat.com sdf@fomichev.me willemb@go=
ogle.com]
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
-upstream-moderation/68b86981.050a0220.3db4df.01f5.GAE%40google.com.
