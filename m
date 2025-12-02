Received: from mail-wm1-f50.google.com (mail-wm1-f50.google.com [209.85.128.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 52D242E6CB2
	for <syzbot@lists.linux.dev>; Tue,  2 Dec 2025 20:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764708175; cv=none; b=MDlAZGLaAyMYwGsEdHj8GRviSu+UcmTP2UKjusvOyDHJvVrvDTmXB3H8nzK1utgFHWurRgAbFTGS4k86jMkJABeMmE6/ph0DAH2OSvCSTJzKr5PG58cBl9U0fLmAi6S5NWHds1hoUm5OeOfmZMcKGVaZfTAMdH57klyEMGeNZBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764708175; c=relaxed/simple;
	bh=iMRBXF3Ei6rI7qHCRe0N4dsdXsHFEBRxnKfSB/hlY2c=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=BUCS/754l+sAyiFxp5KmPfnRP5h8zJj10UYcRPaGGp6k53+lcMiVD5SwoaiMKQK8g6ktFbkyH8Frys3C45aMQn2INmmNsmmFDOF+m3oNHYgxgMNrvill0iwWZ3SHwy/EGooGwb3vC4OKx4RSq5OKYRfrp3c5785cKzo8wW+4WLY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=GZt1No1c; arc=none smtp.client-ip=209.85.128.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="GZt1No1c"
Received: by mail-wm1-f50.google.com with SMTP id 5b1f17b1804b1-477a219dbcaso54521275e9.3
        for <syzbot@lists.linux.dev>; Tue, 02 Dec 2025 12:42:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1764708171; x=1765312971; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=8qu5JcGT86qXBNaZMXXpFykxmFIDQtmm4qHbns+O3cI=;
        b=GZt1No1ceSeiJPYHb7iJDGf0r6j6YsMvA2h6J+fxQ1oRLj0T9XUXNmT4NvF18yup8p
         dTYOdPiBPzc4wypARICkHwwVjLztjajdmnhxAGRP4xWlVhgBq9Yq4QcBGijf7pC4okTv
         35mM0+rvuxmhugRUdEKhRr0jlqBlBduOLpVo+EsfrRC1fx6xtQnKDYepiwVLsFpg43dT
         na0EYDRy1da5riQFlF9ISm0aQDuMtVtt7pN1euJXwOvXSh2qNQm43BFBoTXF3a4qSrRu
         fy85wO20JiPjCy5ZXcGtSw5dsFcKFkYUMoIZZHJdjMnLuaRinjK7cDv8/9KEavtNM42d
         BwEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1764708171; x=1765312971;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=8qu5JcGT86qXBNaZMXXpFykxmFIDQtmm4qHbns+O3cI=;
        b=M6Mq8qR1f4blwvxjfv/coSzJa+/iCtTrzskh4m0+8jIZQklej+5dhbDkRyHpXIV4id
         Yo9MgEU3BYOG77oaULfri3dyBhI62IS4VLnuBc9bvyObZTgHO7xeqWIU0eT4ZEhoil+f
         GR9E0VhmKAu22kbJifQoHuQunJ4J00Hd97YaUAIFJOs8vduGkuVYr8kRwhEO8Mfu22jm
         G+AW3fI8NsHVSK9G1CQ/2iiBoc8EMylEXo1A+B/gYXrnPaybImagxUt4Xs3HUeiApUjM
         Oumv14q1/bbjsgKCJVLXQQZOdNIHRxjigXB2/0MPCmadfdyga5jt0I68HO+jS0I1ZjcY
         rcDw==
X-Forwarded-Encrypted: i=1; AJvYcCV4Ayu+sIkUbD/oV37C4paxrDEHM7RJthJaQICSYEqYKUKxr5ioftsRh7j0oQBWqeuSP6Q/CPY=@lists.linux.dev
X-Gm-Message-State: AOJu0YzTcj4qwyZT80Iv8vRILsuQuw27Jc5l2nQ+pSiNtc2nj8H8dThj
	hUD/MOm5M/2spDEWgChtcYBsEY7HrLBWQWYb0KWK96DqQYWFWxblj8kQOkKBTVr8JI0L6IyIu6B
	j21hbG5X0/GSujoX5z28YWaJ/AGz16gZNhTta5Agj
X-Gm-Gg: ASbGncsLjf/ibM5J1QyHIoMXs20piXxdK7he90eUy5UJxLc70+jXFEIZqcowmnhWAMh
	/Wcb4NzrC1E1b1OiXpr1oB86j+Ilgp2Ivu0Vvixe5p+adFcAJG7trbm9PaF40+o7MJX3EL/x5nL
	imtujK0d6EKdksiune3vwpo1Z0u43/ybdZr7e+6FV1tIT9WlTAGEnl+5yNPSYfF8VT6r/jSX8QU
	UYERR3iIyzzfBOVrIdh7lOJ9OUh7ehDOYw5q2b4Cr7YJLNSUelR9tSlpaZzzeo7//ptwnzm6zJ6
	L5B7eOxXZ2Wba9R/6JlDDGHTf3QFScjX4Nd/iGrr2v1fVkIF6JdF5UZJv1PwwBkS7zMKdYA=
X-Google-Smtp-Source: AGHT+IHCw+kMHV3H2RDjALp3Y7fqMI03hwKXb8W6urvDpcpCCw1yqqOYlC7pP7e/eA7/81Z4buaIgCTe2VYVSVHJbZw=
X-Received: by 2002:a05:600c:45c9:b0:477:af07:dd1c with SMTP id
 5b1f17b1804b1-477c0212123mr446372245e9.35.1764708171325; Tue, 02 Dec 2025
 12:42:51 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <692f40c1.a70a0220.d98e3.01a2.GAE@google.com>
In-Reply-To: <692f40c1.a70a0220.d98e3.01a2.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 2 Dec 2025 21:42:36 +0100
X-Gm-Features: AWmQ_bnfWs9ZJpebnN0sqpRlsuLLBC1zv7heczE42sXyig__Rd2pUVXN2zEygDI
Message-ID: <CANp29Y5Dq7NMZ0DiDwVvwmKYvao0P0KF7MTaeuKRFhFJwJ=1vg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Fix unintended eviction when updating
 lru hash maps
To: syzbot ci <syzbot+ci0f9355f4155e7a2e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Dec 2, 2025 at 8:40=E2=80=AFPM syzbot ci
<syzbot+ci0f9355f4155e7a2e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] bpf: Fix unintended eviction when updating lru hash maps
> https://lore.kernel.org/all/20251202153032.10118-1-leon.hwang@linux.dev
> * [PATCH bpf-next 1/3] bpf: Avoid unintended eviction when updating lru_h=
ash maps
> * [PATCH bpf-next 2/3] bpf: Avoid unintended eviction when updating lru_p=
ercpu_hash maps
> * [PATCH bpf-next 3/3] selftests/bpf: Add tests to verify no unintended e=
viction when updating lru hash maps
>
> and found the following issue:
> general protection fault in bpf_lru_push_free
>
> Full report is available here:
> https://ci.syzbot.org/series/64db9547-852d-4c56-a3a1-3d18f254330c
>
> ***
>
> general protection fault in bpf_lru_push_free
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      5262cb23393f7e86a64d1a45eeaa8a6f99f03d10
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/702a7a8c-4385-4089-a777-8b47155f8=
794/config
> C repro:   https://ci.syzbot.org/findings/0cffd810-925f-42f4-88d2-8d21195=
f341e/c_repro
> syz repro: https://ci.syzbot.org/findings/0cffd810-925f-42f4-88d2-8d21195=
f341e/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000004: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000020-0x0000000000000027]
> CPU: 0 UID: 0 PID: 5953 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:bpf_percpu_lru_push_free kernel/bpf/bpf_lru_list.c:539 [inline]
> RIP: 0010:bpf_lru_push_free+0x6e/0xbb0 kernel/bpf/bpf_lru_list.c:551
> Code: 01 0f 85 e4 00 00 00 4c 89 f0 48 c1 e8 03 80 3c 28 00 74 08 4c 89 f=
7 e8 c0 82 42 00 4d 8b 3e 4c 8d 73 10 4c 89 f0 48 c1 e8 03 <0f> b6 04 28 84=
 c0 0f 85 5b 09 00 00 45 0f b7 36 bf 08 00 00 00 44
> RSP: 0018:ffffc900046d7b48 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: 0000000000000010 RCX: ffff888112941d00
> RDX: 0000000000000000 RSI: 0000000000000010 RDI: ffff888117c02300
> RBP: dffffc0000000000 R08: ffffffff8f7cee77 R09: 1ffffffff1ef9dce
> R10: dffffc0000000000 R11: fffffbfff1ef9dcf R12: 0000000000000002
> R13: 00000000fffffffe R14: 0000000000000020 R15: 0000607d55cf6a80
> FS:  000055555edc7500(0000) GS:ffff88818eb38000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2ed63fff CR3: 000000010bca0000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  htab_lru_push_free kernel/bpf/hashtab.c:1183 [inline]
>  htab_lru_map_update_elem+0x33e/0xa90 kernel/bpf/hashtab.c:1266
>  bpf_map_update_value+0x751/0x920 kernel/bpf/syscall.c:294
>  map_update_elem+0x355/0x4b0 kernel/bpf/syscall.c:1817
>  __sys_bpf+0x619/0x860 kernel/bpf/syscall.c:6150
>  __do_sys_bpf kernel/bpf/syscall.c:6272 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6270 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6270
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe41118f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffcd4179988 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007fe4113e5fa0 RCX: 00007fe41118f7c9
> RDX: 0000000000000020 RSI: 0000200000000800 RDI: 0000000000000002
> RBP: 00007fe4111f297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe4113e5fa0 R14: 00007fe4113e5fa0 R15: 0000000000000003
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:bpf_percpu_lru_push_free kernel/bpf/bpf_lru_list.c:539 [inline]
> RIP: 0010:bpf_lru_push_free+0x6e/0xbb0 kernel/bpf/bpf_lru_list.c:551
> Code: 01 0f 85 e4 00 00 00 4c 89 f0 48 c1 e8 03 80 3c 28 00 74 08 4c 89 f=
7 e8 c0 82 42 00 4d 8b 3e 4c 8d 73 10 4c 89 f0 48 c1 e8 03 <0f> b6 04 28 84=
 c0 0f 85 5b 09 00 00 45 0f b7 36 bf 08 00 00 00 44
> RSP: 0018:ffffc900046d7b48 EFLAGS: 00010202
> RAX: 0000000000000004 RBX: 0000000000000010 RCX: ffff888112941d00
> RDX: 0000000000000000 RSI: 0000000000000010 RDI: ffff888117c02300
> RBP: dffffc0000000000 R08: ffffffff8f7cee77 R09: 1ffffffff1ef9dce
> R10: dffffc0000000000 R11: fffffbfff1ef9dcf R12: 0000000000000002
> R13: 00000000fffffffe R14: 0000000000000020 R15: 0000607d55cf6a80
> FS:  000055555edc7500(0000) GS:ffff88818eb38000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2ed63fff CR3: 000000010bca0000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   01 0f                   add    %ecx,(%rdi)
>    2:   85 e4                   test   %esp,%esp
>    4:   00 00                   add    %al,(%rax)
>    6:   00 4c 89 f0             add    %cl,-0x10(%rcx,%rcx,4)
>    a:   48 c1 e8 03             shr    $0x3,%rax
>    e:   80 3c 28 00             cmpb   $0x0,(%rax,%rbp,1)
>   12:   74 08                   je     0x1c
>   14:   4c 89 f7                mov    %r14,%rdi
>   17:   e8 c0 82 42 00          call   0x4282dc
>   1c:   4d 8b 3e                mov    (%r14),%r15
>   1f:   4c 8d 73 10             lea    0x10(%rbx),%r14
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   0f b6 04 28             movzbl (%rax,%rbp,1),%eax <-- trapping in=
struction
>   2e:   84 c0                   test   %al,%al
>   30:   0f 85 5b 09 00 00       jne    0x991
>   36:   45 0f b7 36             movzwl (%r14),%r14d
>   3a:   bf 08 00 00 00          mov    $0x8,%edi
>   3f:   44                      rex.R
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
t davem@davemloft.net eddyz87@gmail.com haoluo@google.com john.fastabend@gm=
ail.com jolsa@kernel.org kernel-patches-bot@fb.com kpsingh@kernel.org leon.=
hwang@linux.dev linux-kernel@vger.kernel.org linux-kselftest@vger.kernel.or=
g martin.lau@linux.dev sdf@fomichev.me shuah@kernel.org skb99@linux.ibm.com=
 song@kernel.org yonghong.song@linux.dev]
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
-upstream-moderation/692f40c1.a70a0220.d98e3.01a2.GAE%40google.com.
