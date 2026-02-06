Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3A8CC2FCBE5
	for <syzbot@lists.linux.dev>; Fri,  6 Feb 2026 14:18:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770387525; cv=pass; b=XhcQIlGxCXZowKAT+6OgWKKLC25jCTq8pRO0lEqIZLJ4tHqiqwjLqArSv9qud4dMqF7gqbndbaE1UR1CIfaKWNdbcOXlqmh6OC6oIHISTkZcpD5YDkI6H8lnfz8JhWGLePrGu7SJADVIJSB3l0xN8Mr5WT4GlnWs7/w+AwCryIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770387525; c=relaxed/simple;
	bh=5YL85kyGhpv0d19pijsu2i+9FkH1f4ws8If4g4lkBHQ=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=LZL2yVZU1nDbN/XbWpSiAGF8+AcpJa4H883/p7bOLvyflb7ZQKLtHr40pPEVcwqygRSY9ZxB3PvMWmPv7TsM3UmfWn1atotHxWwmwbBJ83Gz4l/tE7dziTB0DA6Lz8xMQ5X1n6DZrUaElL++1dLEpE6hDb9Qexi/BqE7XgSrkGs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MyCA5aZu; arc=pass smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MyCA5aZu"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-409470ad5bbso287265fac.0
        for <syzbot@lists.linux.dev>; Fri, 06 Feb 2026 06:18:44 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770387524; cv=none;
        d=google.com; s=arc-20240605;
        b=KGZEHc1iBea2NDsEY/KkwItdBKpCdcyLHxVP5oDVGAVUjUR95kgkSqDmm9wDDVPm7v
         KXTnfj7KIpZTCBGyNy9YPq2Rd4GCTVTrX1GLwdAeBXOfJ6vqFuc7sIFgAqGt8YuYCq12
         pOoLmXYJyrzXXk2N0MnmNgsH66KFE69xETegXuWX9AL8s5EaV9hdAYakjDXvkhb+R8IB
         spqlVLBuXQCRi9F1Ir62ROr5li/2cMfmDXU23/MAQE4k2H7gWp1G0bQepqkpzWAWf/tN
         y3SniqIRfbZ4ptH7QdFUTvbzXu2g+OwV4mgCVUl7pHo9p8kHY/lt2fUT2nW3KHIvmfip
         vPSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=HRQFmkq2JnSBXhuzH9clXg737xbi/bgry82byxk9wEI=;
        fh=lOm4a6TJxlmuzb5MpbVYNLrkfI3H3a6VxwiaQ/1Qth4=;
        b=Xj90Zr/MMaXXakwF7rhJ9JCmOpbS80bv5FxBVfxsd8b0X84gqshYqjnXlmScSepUOM
         IunivIuoLGpyrOLZj4wVKcbvBvo67EIgqkw0ezKSNgrJxy9RsxvZuushv1PFa5TMzTXc
         7IKM3nxO1TitOHk4BM/wGH3QQUyTjEcX93taOoxBnlDOmrq4zOkkAXcXoixBx11hlwmG
         v8C/SdtjX4OSl0bLQW+KHlurJjbQ9lsR6uhofmAkokYcWl7ShRhxO0SC0utjuoosl8yV
         N8F6rPJ9KljXl/zz1YcI3ShhUXU4u4DbnraTJS3XxRshX36rnu4KvlMPs+CTIalW8Tsj
         OcFg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770387524; x=1770992324; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=HRQFmkq2JnSBXhuzH9clXg737xbi/bgry82byxk9wEI=;
        b=MyCA5aZu3KzIeivhR/Ppj0dk+3j2cUovxkm0s/I+ouGqkrCbCSMlVB/sMOqYXQjzPP
         YjixMyiKT6pUkpiB4B1kZGn2sb6iA1FZRXFKm8u9scY+bopDmCRO7iR+Fx7UdsKwowOJ
         OT9QTjkTLiC/wcTrE4NaWIY2I2DF4KYYj825ZzYEchaHCXS0eOjYuktO3HG5ngCET2iH
         BHaq8kVklwZgdH/NiAhuu3h6YJ8EYg4PWNh7VUL79IW1WMTXIgiItpTP8l+zlAinj9jz
         oAx/B29lrZo7i+cfA56PuRZ0ZWU4kE/+tq1PZWIm5UjSfM5qg308Qjd3WdG5jKe3dBwv
         nCQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770387524; x=1770992324;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=HRQFmkq2JnSBXhuzH9clXg737xbi/bgry82byxk9wEI=;
        b=FxA9sQ7CyU2F+0/bEpZnq53TBcp1vtm5oxBcNHyRKF8tGClfo8u/gf+8I6lf//CYn/
         Ic/sCtg2NslDcFJpAxEa0QhUgP1GlqMSt4PTpaZO8JZgvUm/QuSfcZ2QQaE37nkldmLD
         cO1k08aaNrSfPCX7w8Zb7AsBWX8IhReW9uq37TvuKQU8IX4k9rPfqtLU8h+xdQtZPFJY
         QgiAcXZYqX7mA8o702PTttrxjLs+bBMVYuJxyS67SUnqQzAdSLPSuH70zi5aI3wJ6oVB
         4hC7700smR4NqI863tryO8eJ2RN2Yl4FfYzIrwA1ZAfmwB/uFb+442gN7TtpnGTNokVS
         L4Hg==
X-Forwarded-Encrypted: i=1; AJvYcCUu4iRr/yRfFJQNgZCCwu+x/bZ/2ozcORQHbwex4DRwMJBLWP0D/EhVdGHdQEhmQ+gGK8sf1qw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzn6PNs9UJUwyCgEOP1q59fxPpVLBgj9b04JolbwMIU7DNkjlQ8
	4L1XGJGNHCM/DzjONRRKSDdtCvDv/TK550e/rAr7DmwdRmV6/Ums/MgcEiOLjVM3ttcQ3wkWkAL
	/WaUsPlvq+W/RlSbwrmXfYRvdQ/GJvIoQ1nhYf21+
X-Gm-Gg: AZuq6aJKg0CeBIgEwYzv68eZ6S6rk6iowT+01pUbiTe86d3g1YrffG8YvlGk/i9QCLF
	njmulKLkwE69PF9wjctgrp7ZToIKQuGc1f0Drx4aPep5DjuPu5OJsMM8/hpPkzVEfR64oLgkJy9
	OHnpEOt+6uUmx/i0PZ/dUrDEeV/yUJ+qlmpv7eN165bqOrzV/h6ADW5ouWPRzTWV2taSsXxnmtt
	G5svvuDcsVy4KVFlZx9fcCZa64ccHuD1zAfHezBzMwH5zyYmNFwsd4RrhaqFZZl5epmm1wnlH9c
	0D38HW+VqCJMbjz8mtBvJ3kDHHXU+tBSAGSFvZZBGLvuaZXwn00UlFYMzA==
X-Received: by 2002:a05:6820:4def:b0:662:f759:4eac with SMTP id
 006d021491bc7-66d0a667296mr1342473eaf.32.1770387523740; Fri, 06 Feb 2026
 06:18:43 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6985e94f.050a0220.3b3015.003d.GAE@google.com>
In-Reply-To: <6985e94f.050a0220.3b3015.003d.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 6 Feb 2026 15:18:32 +0100
X-Gm-Features: AZwV_Qjh4uzDlFZrNmCdDuXCDahRjyd8opmGQQj7E8TEH-mpXQ0gSOy4hW8cKaM
Message-ID: <CANp29Y7s1LdOo0oRbBZwzYQiKKBML7Q5-eHcGpTbHoFegcSAYw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Add preempt disable for bpf_get_stack
To: syzbot ci <syzbot+ci1ea0462c6f16682e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Fri, Feb 6, 2026 at 2:14=E2=80=AFPM syzbot ci
<syzbot+ci1ea0462c6f16682e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] bpf: Add preempt disable for bpf_get_stack
> https://lore.kernel.org/all/20260206090653.1336687-1-chen.dylane@linux.de=
v
> * [PATCH bpf-next v2 1/2] bpf: Add preempt disable for bpf_get_stack
> * [PATCH bpf-next v2 2/2] bpf: Add preempt disable for bpf_get_stackid
>
> and found the following issue:
> WARNING in preempt_count_sub
>
> Full report is available here:
> https://ci.syzbot.org/series/90d08df2-d19d-404f-b9dd-c201605b83a2
>
> ***
>
> WARNING in preempt_count_sub
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      1ace9bac1ad2bc6a0a70baaa16d22b7e783e88c5
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/64881591-241a-4854-9beb-1f6915668=
35c/config
> C repro:   https://ci.syzbot.org/findings/98f347c8-b879-4c85-829b-a20ef90=
0e645/c_repro
> syz repro: https://ci.syzbot.org/findings/98f347c8-b879-4c85-829b-a20ef90=
0e645/syz_repro
>
> ------------[ cut here ]------------
> DEBUG_LOCKS_WARN_ON(val > preempt_count())
> WARNING: kernel/sched/core.c:5751 at preempt_count_sub+0x9e/0x170 kernel/=
sched/core.c:5751, CPU#0: syz.0.17/5991
> Modules linked in:
> CPU: 0 UID: 0 PID: 5991 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:preempt_count_sub+0xa5/0x170 kernel/sched/core.c:5751
> Code: 05 cf 8f 48 c1 e8 03 0f b6 04 18 84 c0 0f 85 88 00 00 00 83 3d ef 2=
1 3d 0e 00 75 13 48 8d 3d b2 f3 3f 0e 48 c7 c6 a0 fe 8b 8b <67> 48 0f b9 3a=
 90 eb b8 90 e8 5d ab 03 03 85 c0 74 2f 48 c7 c0 a4
> RSP: 0018:ffffc90004437bc8 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: dffffc0000000000 RCX: ffff8881746f8000
> RDX: 0000000000000000 RSI: ffffffff8b8bfea0 RDI: ffffffff8fd1d770
> RBP: ffffc90004437cd0 R08: ffffffff8fcf05a3 R09: 1ffffffff1f9e0b4
> R10: dffffc0000000000 R11: fffffbfff1f9e0b5 R12: dffffc0000000000
> R13: 1ffff92000886f84 R14: 0000000000000000 R15: 0000000000000000
> FS:  000055557d481500(0000) GS:ffff88818e328000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f1f89c706c0 CR3: 00000001742f0000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  bpf_prog_test_run_raw_tp+0x4b9/0x6c0 net/bpf/test_run.c:794
>  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4721
>  __sys_bpf+0x643/0x950 kernel/bpf/syscall.c:6246
>  __do_sys_bpf kernel/bpf/syscall.c:6341 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6339 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6339
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f1f89d9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff9e3fd488 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f1f8a015fa0 RCX: 00007f1f89d9acb9
> RDX: 000000000000000c RSI: 0000200000000500 RDI: 000000000000000a
> RBP: 00007f1f89e08bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f1f8a015fac R14: 00007f1f8a015fa0 R15: 00007f1f8a015fa0
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   05 cf 8f 48 c1          add    $0xc1488fcf,%eax
>    5:   e8 03 0f b6 04          call   0x4b60f0d
>    a:   18 84 c0 0f 85 88 00    sbb    %al,0x88850f(%rax,%rax,8)
>   11:   00 00                   add    %al,(%rax)
>   13:   83 3d ef 21 3d 0e 00    cmpl   $0x0,0xe3d21ef(%rip)        # 0xe3=
d2209
>   1a:   75 13                   jne    0x2f
>   1c:   48 8d 3d b2 f3 3f 0e    lea    0xe3ff3b2(%rip),%rdi        # 0xe3=
ff3d5
>   23:   48 c7 c6 a0 fe 8b 8b    mov    $0xffffffff8b8bfea0,%rsi
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   90                      nop
>   30:   eb b8                   jmp    0xffffffea
>   32:   90                      nop
>   33:   e8 5d ab 03 03          call   0x303ab95
>   38:   85 c0                   test   %eax,%eax
>   3a:   74 2f                   je     0x6b
>   3c:   48                      rex.W
>   3d:   c7                      .byte 0xc7
>   3e:   c0                      .byte 0xc0
>   3f:   a4                      movsb  %ds:(%rsi),%es:(%rdi)
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
> [andrii@kernel.org ast@kernel.org bpf@vger.kernel.org chen.dylane@linux.d=
ev daniel@iogearbox.net eddyz87@gmail.com haoluo@google.com john.fastabend@=
gmail.com jolsa@kernel.org kpsingh@kernel.org linux-kernel@vger.kernel.org =
martin.lau@linux.dev sdf@fomichev.me song@kernel.org yonghong.song@linux.de=
v]
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
-upstream-moderation/6985e94f.050a0220.3b3015.003d.GAE%40google.com.
