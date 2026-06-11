Received: from mail-oa1-f49.google.com (mail-oa1-f49.google.com [209.85.160.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 348C83A16AA
	for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 20:22:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781209363; cv=pass; b=MVgfk3K4Amt/rwnDNoyQ6Q/h/zIP4LPXXGJut7qC00rOGxHY5P9Eu99jXGryy0oeM82EPg/QW/+VWHlk5l+uYbhaJMOS5E3CQlt6VMxhU1rDOXTAtnhAax4x8dyVmXPpJPX55G9LPwZGtg7GaOdRQuabUxCYn1/Tv+ya4WmvFjw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781209363; c=relaxed/simple;
	bh=iG9UyKhZeUIHO3wERialNh4tnBoAsDFWmT/kWnFjKUI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MGzprJ9Okf+YYzvBUzsrHQiN/cMmE8SHN59LpnD8lBw7GjvhFcvS5qtXT/Uv6Z/wq4SOiO57bt9fbx3Wc5h1EpX/98L0asTPVBylzrWjqQvS9aZV2m0thdNFl9Lb49iBBFYeCHLkIF4Vp0gxjPMNxGW590B1JYKtaLmHUKXAdwE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Cow0y3x3; arc=pass smtp.client-ip=209.85.160.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Cow0y3x3"
Received: by mail-oa1-f49.google.com with SMTP id 586e51a60fabf-43d26679a6aso204598fac.2
        for <syzbot@lists.linux.dev>; Thu, 11 Jun 2026 13:22:41 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781209360; cv=none;
        d=google.com; s=arc-20240605;
        b=ibaa5zY/q558eEoahCWjxQTnEUp31nQOvaaaqL0bFmuXf9H42EkN8brQW6x231zyku
         I89wvCaxrPkVLpDZk6nyxTdQl1jyf/3bQ6SLKLrKv8KEo7/JeleHILaMmHL4bowibr0Z
         pQoFYtppi0tZZm4VIb/51hzdy343aNNJRRjTmk4liL17Kb5zdSr7Ev3kVJcoj9mADDIZ
         QX/sEganWc/es7LNPOl05S1CfVUw3aRPo+Z3oyrZtzlYr3hb+y8Z3rDD4kcz3IXI6xJP
         cOlinL1bJIGXiJ45n+nmBaaASK5mOb2/t/L7E7RlkMfYyigLoDFT/mbL7BK5AXNB+8Pc
         tasQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=+0gilFnIlXbOQr9zEWfLSyaFuB51TeQxwku2NlDSwQk=;
        fh=+bjCbBOboXJ77ZTnqNDEnbD4oEdC7N9JuUcfofZQVIU=;
        b=Yp0jDcGmZmuUevU4JDhodzuAGDTFqW93TrXLR9qOwXAUIIOr7eLhM0kJxJKhZoAV7O
         fmVwOAl2QVyrM7IXRO1UZ7SGpP3t4DBzFPZ4HLrOFIgDfUgDm/PKKlc6SWWMRWvU3rCT
         NlzlzP2gBYPuW4u4oFc+BtcGMQze9cy2YMFA9Pq7paVJ9F4MyG8+q5SXpREwATglIk5l
         lBPkAdRq0NGqzTxzfzKC0plNaijTkEHbiliAEBEsCLbhxpKNvmyY+K4ym5zFOIXEeviT
         adifnTBFvGBU/b5MeLejFAV7jYWMPd03gkSzlHxq+msVE9GSGXOWB48k+yCUU1Sbv7Yh
         qABQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781209360; x=1781814160; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=+0gilFnIlXbOQr9zEWfLSyaFuB51TeQxwku2NlDSwQk=;
        b=Cow0y3x3Qy1FTfApBajy1VCY3jx6qgYhVOGnkMLYwyjdJBdixgxTwfwC0L2ZL9M04h
         IV5wJaXKDxhVy1urL5tfiq+nL116ntMSF+sAihF7uy5dey/pzTrY0lwcHQaqfevwpyN/
         cD+DS8w467vc7xdTKi13DZBBdqv2ynaSU/4GO60gVtKHw4wPjivTgBz5IpYAX5O0esi0
         oDlv+bvmDfXWNUN8UL0OVDH2dGzGeFEAZcLkeDXm8UTxDD5P7HT/rDJkpI50O4Yyrmts
         cc/qCuMAY9LQAXiEVBbAVevAr8z3P+BsfBIIktogvrtRtXtm4CoH+Tjt7WLFpFamxNV6
         l7Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781209360; x=1781814160;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=+0gilFnIlXbOQr9zEWfLSyaFuB51TeQxwku2NlDSwQk=;
        b=JaINetZzmcLBxmx/bzk9KmtiEg9uORv04Z5wbRiPbYRvgrRZ3bYNfsMay22K4hs0s/
         h7CRZVbqVa5xskGX968fHf225k/EVkSctfMeN9hy8VcVkHlaqH1PfyJwlbYtQQ92rjVQ
         MvOuJTVCSfA7aPMkS+NpBfzbUu4sygB0ZgqVt89lgB+Vu4pHVYD3srU5yR2CpEhADLTJ
         gmENGqPdBVhZu7YITpDyGTFKLs8kRkNLL9cbvDi2Vtl/7v1BeKxZU7DiJrRGpCjSJkRx
         KH9J00GGo/s7HFDVQnd9NHnp6dqP7Y6hRTWxkOY0eBuaWHMO8I0uVo+KNIupWlvxLgoB
         FqaQ==
X-Forwarded-Encrypted: i=1; AFNElJ/LgayuM4+y1eJqxAzoCherh2AiURPymyBzmQqyWt3VIpsYqW2Q95HM8+kpJ16LZC87FIJqVhI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzA2IBlACxi696izRumwgrKYMlnbpRdiTIMooGaVWHKqbgpmnIm
	NhrKwmakSG0dmDtdPWa+nEvbVVgYl7qWNoa+Jr0RX0Fvha6NZDXepxq+OjgNmMoR8drIBtBFoLl
	zjLtku3Q9PSQ19hQj27hd2a/fKEXBEFeIislMlEGa
X-Gm-Gg: Acq92OE6CdWfMfVRRPWAUrj7R50WRbuay6rcgO9fpHnYPmRDLos2AKGMy988TEt9eC4
	GE6PQGSp35SIEoTme1TqTiGZ2bJy7+IGYplnolkAHS1UkLvU/fVxvov8JKSaPcFckI14Kl+0r5s
	TEexie74vOD7QYwGp2eKkxX8N+psAJVQf1YHIx+hlDfzfyQ01ExDd6YNQkNPr9SG+qPMqkFID3f
	6fbbEOnXsSR81ZCdl5JuZtSDJag4mY5SApfltI1vAbSPI+mmqyB30qiWIGwyS+TTaF7sa8PegiU
	ahe9Sw8qh1ti2amA5vcDf7vPN5xd0pt14yDLMZ/kGcEKAIaDIhpojr55g672W070EMZ4+ppG
X-Received: by 2002:a05:6820:220f:b0:69e:c0fc:aba1 with SMTP id
 006d021491bc7-69ecaed493cmr3385253eaf.28.1781209359510; Thu, 11 Jun 2026
 13:22:39 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a2af01f.44b6b70d.20d0cb.0006.GAE@google.com>
In-Reply-To: <6a2af01f.44b6b70d.20d0cb.0006.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 11 Jun 2026 22:22:28 +0200
X-Gm-Features: AVVi8CflC2zxnNKsszKPZszCj7zD4qTcOoTuQxZPYzsTtYKvCR7e6l3ta3k-WPs
Message-ID: <CANp29Y7L+G=+CeN=1OcVQf4HgipJjs9rNe2PUykbBJKgdNbtdQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: Unconditional per-VMA locks and cleanups
To: syzbot ci <syzbot+ci8568a23606d3eb4a@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Jun 11, 2026 at 7:28=E2=80=AFPM syzbot ci
<syzbot+ci8568a23606d3eb4a@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm: Unconditional per-VMA locks and cleanups
> https://lore.kernel.org/all/20260610230409.A44D29FA@davehans-spike.ostc.i=
ntel.com
> * [PATCH v2 1/5] mm: Make per-VMA locks available universally
> * [PATCH v2 2/5] binder: Make shrinker rely solely on per-VMA lock
> * [PATCH v2 3/5] mm: Add RCU-based VMA lookup helper that waits for write=
rs
> * [PATCH v2 4/5] binder: Remove mmap_lock fallback
> * [PATCH v2 5/5] tcp: Remove mmap_lock fallback path
>
> and found the following issue:
> general protection fault in tcp_zerocopy_receive
>
> Full report is available here:
> https://ci.syzbot.org/series/3e6d125a-b2ae-49a4-b833-babfb8bc9150
>
> ***
>
> general protection fault in tcp_zerocopy_receive
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      c8459ee2fef502d6ef6c063751c33d9ac7943eab
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/e7d66981-7900-4c3d-b992-664ccd13a=
57e/config
> syz repro: https://ci.syzbot.org/findings/59d09544-f280-48fe-8ca9-a2fd822=
5e9df/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000002: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> CPU: 0 UID: 0 PID: 5876 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:vma_start_read_locked_nested include/linux/mmap_lock.h:240 [inl=
ine]
> RIP: 0010:vma_start_read_locked+0xa0/0x300 include/linux/mmap_lock.h:257
> Code: 28 84 c0 0f 85 2b 02 00 00 44 8b 35 ba 0d 1b 0e 31 ff 44 89 f6 e8 c=
0 e2 af ff 45 85 f6 74 48 4c 8d 73 10 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 f7 e8 b1 37 1b 00 bf 38 03 00 00 49 03
> RSP: 0018:ffffc9000399f4a0 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88816d558000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffffc9000399f538 R08: ffff8881076c64df R09: 1ffff11020ed8c9b
> R10: dffffc0000000000 R11: ffffed1020ed8c9c R12: 1ffff92000733e94
> R13: dffffc0000000000 R14: 0000000000000010 R15: 0000000000011000
> FS:  00007f4866b966c0(0000) GS:ffff88818dc86000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000011000 CR3: 0000000117c8a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  vma_start_read_unlocked+0x3f/0x70 mm/mmap_lock.c:362
>  find_tcp_vma net/ipv4/tcp.c:2173 [inline]
>  tcp_zerocopy_receive+0x762/0x2200 net/ipv4/tcp.c:2227
>  do_tcp_getsockopt+0x2079/0x2940 net/ipv4/tcp.c:4758
>  tcp_getsockopt+0x83/0x130 net/ipv4/tcp.c:4856
>  do_sock_getsockopt+0x51d/0x7e0 net/socket.c:2487
>  __sys_getsockopt net/socket.c:2518 [inline]
>  __do_sys_getsockopt net/socket.c:2525 [inline]
>  __se_sys_getsockopt net/socket.c:2522 [inline]
>  __x64_sys_getsockopt+0x1a4/0x240 net/socket.c:2522
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4865d9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f4866b96028 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
> RAX: ffffffffffffffda RBX: 00007f4866015fa0 RCX: 00007f4865d9ce59
> RDX: 0000000000000023 RSI: 0000000000000006 RDI: 0000000000000003
> RBP: 00007f4865e32d6f R08: 0000200000000380 R09: 0000000000000000
> R10: 0000200000000340 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4866016038 R14: 00007f4866015fa0 R15: 00007ffc748de268
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:vma_start_read_locked_nested include/linux/mmap_lock.h:240 [inl=
ine]
> RIP: 0010:vma_start_read_locked+0xa0/0x300 include/linux/mmap_lock.h:257
> Code: 28 84 c0 0f 85 2b 02 00 00 44 8b 35 ba 0d 1b 0e 31 ff 44 89 f6 e8 c=
0 e2 af ff 45 85 f6 74 48 4c 8d 73 10 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 f7 e8 b1 37 1b 00 bf 38 03 00 00 49 03
> RSP: 0018:ffffc9000399f4a0 EFLAGS: 00010202
> RAX: 0000000000000002 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: ffff88816d558000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: ffffc9000399f538 R08: ffff8881076c64df R09: 1ffff11020ed8c9b
> R10: dffffc0000000000 R11: ffffed1020ed8c9c R12: 1ffff92000733e94
> R13: dffffc0000000000 R14: 0000000000000010 R15: 0000000000011000
> FS:  00007f4866b966c0(0000) GS:ffff88818dc86000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f4865dea540 CR3: 0000000117c8a000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   28 84 c0 0f 85 2b 02    sub    %al,0x22b850f(%rax,%rax,8)
>    7:   00 00                   add    %al,(%rax)
>    9:   44 8b 35 ba 0d 1b 0e    mov    0xe1b0dba(%rip),%r14d        # 0xe=
1b0dca
>   10:   31 ff                   xor    %edi,%edi
>   12:   44 89 f6                mov    %r14d,%esi
>   15:   e8 c0 e2 af ff          call   0xffafe2da
>   1a:   45 85 f6                test   %r14d,%r14d
>   1d:   74 48                   je     0x67
>   1f:   4c 8d 73 10             lea    0x10(%rbx),%r14
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 f7                mov    %r14,%rdi
>   34:   e8 b1 37 1b 00          call   0x1b37ea
>   39:   bf 38 03 00 00          mov    $0x338,%edi
>   3e:   49                      rex.WB
>   3f:   03                      .byte 0x3
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [akpm@linux-foundation.org aliceryhl@google.com arve@android.com christia=
n@brauner.io cmllamas@google.com dave.hansen@linux.intel.com davem@davemlof=
t.net dsahern@kernel.org gregkh@linuxfoundation.org liam.howlett@oracle.com=
 linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org netdev@vger=
.kernel.org shakeel.butt@linux.dev surenb@google.com tkjos@android.com vbab=
ka@kernel.org]
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
-upstream-moderation/6a2af01f.44b6b70d.20d0cb.0006.GAE%40google.com.
