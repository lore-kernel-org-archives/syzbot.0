Received: from mail-oi1-f173.google.com (mail-oi1-f173.google.com [209.85.167.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D5F2C158D
	for <syzbot@lists.linux.dev>; Tue,  9 Dec 2025 14:27:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.173
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765290444; cv=none; b=WTW0zsAo9eGrJIZQTwADT9bHXZM7Q5/cEJFcNtcPn+5bucBDEx0YZrLN6RKf+rR4LbOlmZuFd79NSeuQjsiNwwjtgZ//OfU2Gqwemz8Ox2U+BbjtNIdtLDx8VLW1cf0jFbLQrf39gU+16PSV/cNjK2/18swxUJIA8WUpPYUNSJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765290444; c=relaxed/simple;
	bh=u4sVrRXaGu7LjZNjCRGTJ203iuMvlf2i1caJWevA7w0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=aod9hH/HCbgMV659hxOXxBmOzy0cnWBpwGAxRAjbVR1ZV6tc2+DhIdV7ZlvghuAgsxa16npi+KBMlth5uXdwCkbWUNRaLxbVKYP/kUh0FgNuRXUqYZ4A36uT0o4uTKCujBJXH9q0zSltMGqU7zoecyMl3gBXbO6vi8HJzhP8Z7c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=F3y23jSo; arc=none smtp.client-ip=209.85.167.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="F3y23jSo"
Received: by mail-oi1-f173.google.com with SMTP id 5614622812f47-45391956bfcso3062862b6e.3
        for <syzbot@lists.linux.dev>; Tue, 09 Dec 2025 06:27:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765290441; x=1765895241; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=1iOPEYa8t/Cb5oG+xtZ3PILapul1DnowDIjy0Ofrv9Y=;
        b=F3y23jSoEy/CmFGEpWd3W6Ze+i0C5W8X8V/uU3BakwL9rd2hfuCHZ6cgY2E3blnpsg
         6Xt7bLe6O6r49ZOqwgBnjCsp7kUZ3mYf+Tz9LNFC0uGukGcCEGotREz2Fc2RXEL/60Rj
         48wMtnNqNfgsHgI9AIWXcFeBdf5HN5V4mljjeknnL6ZO9BlJiiv1CNMWLdGZsJg+VtpM
         cxXAG0jVRfpLcq2isoC4LqgY24GLvwzfLJxgcLTnYsZy1D355ZLa5DUNLpZW5MJ4UUdx
         1StZ/L+aSIaaIQPi9LbMIKnwoAH5iz21O9r9Xfbtd9BXe4mhMmkGGRZQBB3sfK+ZSIwh
         Exzg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765290441; x=1765895241;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=1iOPEYa8t/Cb5oG+xtZ3PILapul1DnowDIjy0Ofrv9Y=;
        b=k5IBWK10lAOKA6+D4NYx/GdDGhO3gqRJia+5RY71fAjsz0hQVHMMMXcxK3BM1dKngv
         cDwCmqQCuyqx4bU8pK3OCjzzx74oO/bdM/iqvzEYP+Lm5yM5wlZEfYm6SKHYBf61MKVv
         j099GlPuBbzH2iA+6pienQ43s7qe2VJmfS05Su6vh3TYI2u/E4D7Frytt9g8qLt6NI1A
         vTVxJwJmTM9s+RfrFDuB06N2Ui0+bFrViXz9qce0E8eoFbdS4kFOyetyeU03HEpQV7dR
         QGRs1QXvkJExCjJFvp8DgxSc8AycJjq0vdTMq4gf+qfbnl5C/BvNrWz/MgPkEg8JUndR
         dBvQ==
X-Forwarded-Encrypted: i=1; AJvYcCXR7YKl6lYunKye/8SFqPZvrJqgdq5EBlwkmRzrNadKPpKOajQSdpeR4vMltz0+gho4hz+fWe0=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJRCvy6UdLw9tzg4TDsDuUk0zzXifo5rPLRQrNneY7EQhqoChN
	UijdjgdzZOie3jbEryt1oC4dYWJdX6/g1Hg3RwFsfxe7gpJhBS6oGC8r+rErhljPSeq4MFGp/i2
	K99XOeFc53k7zFGPaX/0oIxrXvqXEhIGm/PwCCnft
X-Gm-Gg: ASbGncvRR9BQOt2FH4SrpgpNgl/D3qFFnQAKs9mDk5oBjM+tw+daqFMFkyqn3+32m9S
	9fCXXxKWtyAj6El4eZ12HttS0F7E6O+Lsv+0rYJ3UXZbMjYZb0JYBzy0o9Eci9I2KtXeBiDRvtK
	in7NxPu0NyzeiMWXugMw5VOmcMI1UvglVtMyRu3Qwb8AHaqK0jYQyRZHk94DEgN1IwsYdYCiL1R
	6VEB+RsSzCQHYHxegTZ8mYQKJt7SUwrDXuSrW5YN0+Ga+7zST6VkukIpxuCfV69mkexMfYONiJW
	LmpBCpbZVgxcOoU3llAfUWXijdA=
X-Google-Smtp-Source: AGHT+IGjHAY9Ocaj0onizlaWlXdfQ3NJv8jFX5YQ+ngCdOhxy6m3r9pNAjMIrBz9oBrHHD/tPTfMHsHeIMk1Q3+bdDE=
X-Received: by 2002:a05:6808:f8d:b0:450:d0d8:aed0 with SMTP id
 5614622812f47-4539e0cc7bemr4450638b6e.40.1765290440998; Tue, 09 Dec 2025
 06:27:20 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69382102.a70a0220.104cf0.0003.GAE@google.com>
In-Reply-To: <69382102.a70a0220.104cf0.0003.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 9 Dec 2025 23:27:08 +0900
X-Gm-Features: AQt7F2rnLmqeoMbhe8mFZd-vO-hw2B6ws7K9ewIj1ryP2Varuebb4q5w8DtUdE0
Message-ID: <CANp29Y6dfuypwfxYmjU8Gd4ub6xHS=P2NQ=xnurkDVEJVmGePQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: xsk: introduce pre-allocated memory per xsk CQ
To: syzbot ci <syzbot+ci21d32389dddeb9e2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Dec 9, 2025 at 10:15=E2=80=AFPM syzbot ci
<syzbot+ci21d32389dddeb9e2@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] xsk: introduce pre-allocated memory per xsk CQ
> https://lore.kernel.org/all/20251209085950.96231-1-kerneljasonxing@gmail.=
com
> * [PATCH bpf-next v1 1/2] xsk: introduce local_cq for each af_xdp socket
> * [PATCH bpf-next v1 2/2] xsk: introduce a dedicated local completion que=
ue for each xsk
>
> and found the following issue:
> WARNING in vfree
>
> Full report is available here:
> https://ci.syzbot.org/series/5df45d2b-41d6-4675-b3ad-4503516a9ae1
>
> ***
>
> WARNING in vfree
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      835a50753579aa8368a08fca307e638723207768
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/726617c2-a613-4879-9987-91e65545d=
ba1/config
> C repro:   https://ci.syzbot.org/findings/0c82a0b1-8cb3-49ae-9fbe-fa3bd02=
c2ba0/c_repro
> syz repro: https://ci.syzbot.org/findings/0c82a0b1-8cb3-49ae-9fbe-fa3bd02=
c2ba0/syz_repro
>
> ------------[ cut here ]------------
> Trying to vfree() nonexistent vm area (ffffc900034e6000)
> WARNING: mm/vmalloc.c:3423 at 0x0, CPU#0: syz.0.19/5983
> Modules linked in:
> CPU: 0 UID: 0 PID: 5983 Comm: syz.0.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:vfree+0x393/0x400 mm/vmalloc.c:3422
> Code: e8 72 1d ab ff 4c 89 f7 48 83 c4 18 5b 41 5c 41 5d 41 5e 41 5f 5d e=
9 0c fa ff ff e8 57 1d ab ff 48 8d 3d 10 fc 6e 0d 4c 89 f6 <67> 48 0f b9 3a=
 e9 fd fd ff ff e8 3e 1d ab ff 4c 89 e7 e8 66 00 00
> RSP: 0018:ffffc90004e37c40 EFLAGS: 00010293
> RAX: ffffffff82162d09 RBX: 0000000000000000 RCX: ffff88816c66d7c0
> RDX: 0000000000000000 RSI: ffffc900034e6000 RDI: ffffffff8f852920
> RBP: 1ffff1102289d8bf R08: ffff88810005f1bb R09: 1ffff1102000be37
> R10: dffffc0000000000 R11: ffffed102000be38 R12: ffff88801eed1818
> R13: dffffc0000000000 R14: ffffc900034e6000 R15: ffff8881144ec608
> FS:  0000555574db2500(0000) GS:ffff88818eab1000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00002000000000c0 CR3: 0000000112a48000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  xsk_clear_local_cq net/xdp/xsk.c:1188 [inline]
>  xsk_release+0x6b3/0x880 net/xdp/xsk.c:1220
>  __sock_release net/socket.c:653 [inline]
>  sock_close+0xc3/0x240 net/socket.c:1446
>  __fput+0x44c/0xa70 fs/file_table.c:468
>  task_work_run+0x1d4/0x260 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
>  exit_to_user_mode_loop+0xff/0x4f0 kernel/entry/common.c:75
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [=
inline]
>  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
>  do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7eff8518f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffd6ca61b78 EFLAGS: 00000246 ORIG_RAX: 00000000000001b4
> RAX: 0000000000000000 RBX: 000000000001253b RCX: 00007eff8518f7c9
> RDX: 0000000000000000 RSI: 000000000000001e RDI: 0000000000000003
> RBP: 0000000000000000 R08: 0000000000000001 R09: 000000086ca61e6f
> R10: 0000001b2f920000 R11: 0000000000000246 R12: 00007eff853e5fac
> R13: 00007eff853e5fa0 R14: ffffffffffffffff R15: 0000000000000003
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   e8 72 1d ab ff          call   0xffab1d77
>    5:   4c 89 f7                mov    %r14,%rdi
>    8:   48 83 c4 18             add    $0x18,%rsp
>    c:   5b                      pop    %rbx
>    d:   41 5c                   pop    %r12
>    f:   41 5d                   pop    %r13
>   11:   41 5e                   pop    %r14
>   13:   41 5f                   pop    %r15
>   15:   5d                      pop    %rbp
>   16:   e9 0c fa ff ff          jmp    0xfffffa27
>   1b:   e8 57 1d ab ff          call   0xffab1d77
>   20:   48 8d 3d 10 fc 6e 0d    lea    0xd6efc10(%rip),%rdi        # 0xd6=
efc37
>   27:   4c 89 f6                mov    %r14,%rsi
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   e9 fd fd ff ff          jmp    0xfffffe31
>   34:   e8 3e 1d ab ff          call   0xffab1d77
>   39:   4c 89 e7                mov    %r12,%rdi
>   3c:   e8                      .byte 0xe8
>   3d:   66 00 00                data16 add %al,(%rax)
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
> [ast@kernel.org bjorn@kernel.org bpf@vger.kernel.org daniel@iogearbox.net=
 davem@davemloft.net edumazet@google.com hawk@kernel.org john.fastabend@gma=
il.com jonathan.lemon@gmail.com kerneljasonxing@gmail.com kernelxing@tencen=
t.com kuba@kernel.org maciej.fijalkowski@intel.com magnus.karlsson@intel.co=
m netdev@vger.kernel.org pabeni@redhat.com sdf@fomichev.me]
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
-upstream-moderation/69382102.a70a0220.104cf0.0003.GAE%40google.com.
