Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64BCD30FF28
	for <syzbot@lists.linux.dev>; Mon,  5 Jan 2026 08:06:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767600392; cv=none; b=JOUB3KbpQDRyXxE5mP5S50x65WfRB0e4MDY5jd/ZekInpMNDof8HM2+9ttUxoxvCuE0JFNrQjkk253NUW5BcAJOBVzqtAaBGvFc4kDbpfxS/zT5f2X5gmxXxCx+C5oMbeOVKslmYT32GbNfgRqZ9iEZmPbiIwbp1z6B58dPKjGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767600392; c=relaxed/simple;
	bh=Wb79Eonu6gPmevn/PcgJo3ExfTqhjZisTqWZ/bIper0=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OZuOS7UkLLxmDuIoi6n7mpz5C7Hj9RypXvkKDP6nBe7EdrJNWCgksLIpBAE8WdJUzeTrEjqtz2gLA5VksWbA/Kxzl2lAuaK6SeTLtRIw7iC22HSWnNucHi9fZVq7AItiJ8h3UZIb8iPJKTrUr1hmaYnwTnpSeS4vjqBj+v83yyM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tXPe+UL4; arc=none smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tXPe+UL4"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7c71cca8fc2so8773110a34.1
        for <syzbot@lists.linux.dev>; Mon, 05 Jan 2026 00:06:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767600389; x=1768205189; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=hjRSDzbaZeDhya94VYUMyiHzRfeoySDv+FpH6IlacuA=;
        b=tXPe+UL46zHxMzTbkO3QAzEvpGIPntKpbxOx1vbmnsyMh3kYI67SZLJEN0pBkNV1JE
         SAevLp2I6Jtv6KJH509aZ18vZbaoCSeg8Og6AkncRRFQAJhW8kbBO7rDlT/0Vbujdfmj
         A6fzRzm/xYYcFLYg66c/cXIctLKxwTr3YpSB1NbWge1j7ufMfvk4KNgVwLNvDFOwtx/2
         1aWxO/CvUvy7Vp2+/0DQ30GKppIabAJam2ZGIdUxsZRM5DKwtrCQvVLq238PsQ/FhsTJ
         En4cAfn2UjKl9d9vL84WjMB77PuZluvEre6Ac0h5wOPj8WJM3i8hqoagxZnxgCrGScoJ
         YivA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767600389; x=1768205189;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=hjRSDzbaZeDhya94VYUMyiHzRfeoySDv+FpH6IlacuA=;
        b=pZsj2MvOYFJ5bsjyCE9BghJNgugpDxQs3MKTxiiGJR3DEqLpEgQG3Lh5cQGnGwaZsg
         nie3TCVdK+jGC/PCHffrLnz5siuVSBh212CkD85oblMwqcURaJPCdEbTNYxBw+wOVlrK
         N8Tkz01FdJv6uVf9Hlvsfe7/dCyAfrDF2/RddvWl3yzSYDnSwzb6mAq5ShgQHAR1h/lk
         yoh2uKMXHkREngji2eFFKaDSSmx4gy12j8S4GcBi2V5Qht0WPS6sMrAVHMQgZ5QiQLfE
         noQ+ScQJaPX/DPjEE1RSdJ13RrTEFG/UwLBl80No6D/MsEPZG+GQtn1rI0ECWqO+zmpB
         Vlpg==
X-Forwarded-Encrypted: i=1; AJvYcCVmQpXj7KMx03S4JqjaevY6rbOxfvHC5Z9q3tbjYJcTbzModbITYyT5zRzlQwE58U+2AnJaZUk=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy5WrOAskffChJI25WF4Yt9uhV2ZymbtBtTJ4qFj/oL+X2m+V6c
	E+mn/K9ZmHd+RrU7ioVjbQxexMl9irk/3qSCkFbCGDwvCDYPpagcCXdg5Ilou05uC541av+J59j
	JYdo0eKluseqMp54Pli3HCGrIrVS0lIkcmGtJIqjj
X-Gm-Gg: AY/fxX5CFq7p+9C8V8oD6Eq4n1qjryUPBPcLniz9jUgd+/ttMmFrFX1fDcxr5puq4O8
	kLG7IAmryt9nmlIu/dpLS9zwKEzzc2KUYEobE/n2zafBcWE7ujMLFauFH4BzsTWjxV+JbnxhKAV
	bewQzlNc58iAqc0b9cfa4UHtPYX4G+gtQhSrsax0QGlFVf6/2Zb7R2RS8uGDqNFb9c2w6Hw30lP
	81LnW9I1pVFWIlyoDTjYxLqEVxVkIkTuH9h7Txy6Ysr1bPXHLat/Z4aoQyhlx+kWxuNLQa0dI7d
	WT1u6PvnWjogRqFdctNkIq49KWe91e/BPkdhHlMuW6KApBGLEB7zEBGGrg==
X-Google-Smtp-Source: AGHT+IF171S9Q7k9gb2C/TEMr+NMf//b+9NgkqmXmOaNKiRTHfikq05x4CI5QwKTPeh8xvfaDInmrjLJYCoxBTfcQ8g=
X-Received: by 2002:a05:6820:c317:b0:65b:3457:aa8c with SMTP id
 006d021491bc7-65d0e934187mr13853649eaf.2.1767600388992; Mon, 05 Jan 2026
 00:06:28 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <695acdc6.050a0220.a5285.000b.GAE@google.com>
In-Reply-To: <695acdc6.050a0220.a5285.000b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 5 Jan 2026 09:06:16 +0100
X-Gm-Features: AQt7F2pWvEqlNTnAYBfY8eQEAWS54OQ6Zl_6Qz5wig06_pslbNMZgDgbVf4TyUI
Message-ID: <CANp29Y7dKV3FGG0woYkZzkjMUs+xNiiRLgMuXo=jsHUCY3A=+Q@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf, test_run: Fix user-memory-access
 vulnerability for LIVE_FRAMES
To: syzbot ci <syzbot+ci86521d821d6029aa@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Jan 4, 2026 at 9:30=E2=80=AFPM syzbot ci
<syzbot+ci86521d821d6029aa@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] bpf, test_run: Fix user-memory-access vulnerability for LIVE_FRAMES
> https://lore.kernel.org/all/20260104162350.347403-1-kafai.wan@linux.dev
> * [PATCH bpf-next 1/2] bpf, test_run: Fix user-memory-access vulnerabilit=
y for LIVE_FRAMES
> * [PATCH bpf-next 2/2] selftests/bpf: Add test for xdp_md context with LI=
VE_FRAMES in BPF_PROG_TEST_RUN
>
> and found the following issue:
> BUG: missing reserved tailroom
>
> Full report is available here:
> https://ci.syzbot.org/series/688d9198-9fed-495e-9113-3d4187428ee3
>
> ***
>
> BUG: missing reserved tailroom
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      a069190b590e108223cd841a1c2d0bfb92230ecc
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~e=
xp1~20251202083504.46), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/3375fbfc-d3f8-45a8-8db2-62ac76ebb=
7b4/config
> C repro:   https://ci.syzbot.org/findings/37614d32-0f44-4a1c-9822-586c95c=
feb11/c_repro
> syz repro: https://ci.syzbot.org/findings/37614d32-0f44-4a1c-9822-586c95c=
feb11/syz_repro
>
> ------------[ cut here ]------------
> XDP_WARN: xdp_update_frame_from_buff(line:414): Driver BUG: missing reser=
ved tailroom
> WARNING: net/core/xdp.c:618 at xdp_warn+0x1d/0x40 net/core/xdp.c:618, CPU=
#1: syz.0.17/5990
> Modules linked in:
> CPU: 1 UID: 0 PID: 5990 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:xdp_warn+0x25/0x40 net/core/xdp.c:618
> Code: 90 90 90 90 90 f3 0f 1e fa 41 57 41 56 53 89 d3 49 89 f6 49 89 ff e=
8 da 83 63 f8 48 8d 3d e3 de 70 06 4c 89 f6 89 da 4c 89 f9 <67> 48 0f b9 3a=
 5b 41 5e 41 5f c3 cc cc cc cc cc 66 66 2e 0f 1f 84
> RSP: 0018:ffffc90004427580 EFLAGS: 00010293
> RAX: ffffffff895fc996 RBX: 000000000000019e RCX: ffffffff8c94c7e0
> RDX: 000000000000019e RSI: ffffffff8da38c06 RDI: ffffffff8fd0a880
> RBP: 0000000000000f68 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000000 R12: ffff8881b4ae3ec0
> R13: ffff8881b4ae3198 R14: ffffffff8da38c06 R15: ffffffff8c94c7e0
> FS:  000055555699b500(0000) GS:ffff8882a9a1f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30463fff CR3: 0000000175022000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  xdp_update_frame_from_buff include/net/xdp.h:414 [inline]
>  xdp_test_run_init_page+0x482/0x590 net/bpf/test_run.c:143
>  page_pool_set_pp_info net/core/page_pool.c:716 [inline]
>  __page_pool_alloc_netmems_slow+0x33c/0x710 net/core/page_pool.c:631
>  page_pool_alloc_netmems net/core/page_pool.c:667 [inline]
>  page_pool_alloc_pages+0xe6/0x1f0 net/core/page_pool.c:675
>  page_pool_dev_alloc_pages include/net/page_pool/helpers.h:96 [inline]
>  xdp_test_run_batch net/bpf/test_run.c:294 [inline]
>  bpf_test_run_xdp_live+0x714/0x1cf0 net/bpf/test_run.c:378
>  bpf_prog_test_run_xdp+0x7d2/0x1120 net/bpf/test_run.c:1387
>  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4698
>  __sys_bpf+0x643/0x950 kernel/bpf/syscall.c:6220
>  __do_sys_bpf kernel/bpf/syscall.c:6315 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6313 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6313
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xf0/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f389319acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc43c08dd8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f3893405fa0 RCX: 00007f389319acb9
> RDX: 0000000000000048 RSI: 0000200000000600 RDI: 000000000000000a
> RBP: 00007f3893208bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3893405fac R14: 00007f3893405fa0 R15: 00007f3893405fa0
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   90                      nop
>    1:   90                      nop
>    2:   90                      nop
>    3:   90                      nop
>    4:   90                      nop
>    5:   f3 0f 1e fa             endbr64
>    9:   41 57                   push   %r15
>    b:   41 56                   push   %r14
>    d:   53                      push   %rbx
>    e:   89 d3                   mov    %edx,%ebx
>   10:   49 89 f6                mov    %rsi,%r14
>   13:   49 89 ff                mov    %rdi,%r15
>   16:   e8 da 83 63 f8          call   0xf86383f5
>   1b:   48 8d 3d e3 de 70 06    lea    0x670dee3(%rip),%rdi        # 0x67=
0df05
>   22:   4c 89 f6                mov    %r14,%rsi
>   25:   89 da                   mov    %ebx,%edx
>   27:   4c 89 f9                mov    %r15,%rcx
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   5b                      pop    %rbx
>   30:   41 5e                   pop    %r14
>   32:   41 5f                   pop    %r15
>   34:   c3                      ret
>   35:   cc                      int3
>   36:   cc                      int3
>   37:   cc                      int3
>   38:   cc                      int3
>   39:   cc                      int3
>   3a:   66                      data16
>   3b:   66                      data16
>   3c:   2e                      cs
>   3d:   0f                      .byte 0xf
>   3e:   1f                      (bad)
>   3f:   84                      .byte 0x84
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
> [aleksander.lobakin@intel.com andrii@kernel.org ast@kernel.org bpf@vger.k=
ernel.org daniel@iogearbox.net davem@davemloft.net dddddd@hust.edu.cn dzm91=
@hust.edu.cn eddyz87@gmail.com edumazet@google.com haoluo@google.com hawk@k=
ernel.org horms@kernel.org john.fastabend@gmail.com jolsa@kernel.org kafai.=
wan@linux.dev kpsingh@kernel.org kuba@kernel.org linux-kernel@vger.kernel.o=
rg linux-kselftest@vger.kernel.org m202472210@hust.edu.cn martin.lau@linux.=
dev netdev@vger.kernel.org pabeni@redhat.com sdf@fomichev.me shuah@kernel.o=
rg song@kernel.org toke@redhat.com yonghong.song@linux.dev]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
> --
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/695acdc6.050a0220.a5285.000b.GAE%40google.com.
