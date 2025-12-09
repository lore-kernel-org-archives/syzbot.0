Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83CE3221F24
	for <syzbot@lists.linux.dev>; Tue,  9 Dec 2025 07:50:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765266627; cv=none; b=ape1JSOy6wJVtUeJ0CAEwUjcjH3a44Ki2XMX89Tzz7s7Pc2dO7tfhFiFkMVfwgZ6pnUQERoaYzp9ZU8ms/yIpHgTR/7gs2Zlxt/tC67zK9aQZJ1KG2DHWWkwoESMai8s4iNs5uNmJlQz9uyzdImCdNynB/rUwKNUuj7l4YFnMyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765266627; c=relaxed/simple;
	bh=HDUMdpy54DzyVlMlVTzR0IWGQ/d1z5oO33eRwmz8ats=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=dtKdSNQ5gVb+C05MngQL3grGueF2Larvw5j/IR+Br/OhSYA0Ki9c6JqZzW6kcdmKM/xQe2Ru6XN6ukflZNGzmPfKAl6Ri/venFJbelTr2VNE6MZdq8GDrHXuES3vC2xo6KxJ/pAnSE8rCX5kuZkj4J4+NV2AnoJlNKld2cSlmH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=SXZKbbY+; arc=none smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="SXZKbbY+"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-4505b05e7b5so1594794b6e.2
        for <syzbot@lists.linux.dev>; Mon, 08 Dec 2025 23:50:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1765266623; x=1765871423; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=erYHP3TCTDCmZdRIGULb/KLTR+WIL55kGAxxY6GuS2M=;
        b=SXZKbbY+Q06fQGNSu26VaDpH2xyK8lmg7WiFd8yQ+7u3Of4dEDyd4T7NgMELIe75Oh
         eCqV/T6E5v0ANtUM7Ky7+V7cjOvZjQQZfVZ782arlBHLjiQt14k5Ld84IXookF9M3at6
         9sHjadk8R54aXMK3rZHgvBoVwr3irMrPAML1ch+f8I6XSWFbXDm+P33uPT3wrx/0RgOk
         Vjy89VA6lXNYHZcz21Etv8WDaxW6peKhjorJ2+22RQCWHekarR3oitVtDO19kn9Vpzmz
         pViHm4oqQkuZZW+a/nUfp3u705BckxXBlg1b2VGfU0nlCIvZ2uVLOCCbSNIMFSwnNd5m
         egXw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1765266623; x=1765871423;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=erYHP3TCTDCmZdRIGULb/KLTR+WIL55kGAxxY6GuS2M=;
        b=hlsKOM2rZGcFBOR38Y9uTYrCiXTVgu0lsKkaozlbVJbNUaC1tWbTLp5FEBuAIcvUB+
         5fVR/c5E2j5gRvFNey/zaEiZUyfpB+8ouOomuAkyE48fdcKUU6FfWiEynNNpkR7P+fFT
         UdKc8PcbD2HbSW4gfuoCZ2byNNS+bpNjjmPwAJAImbG2zlXTNcoGVxCS+Zd0J1SFL29E
         f7BmDYVwUhRRG3wVYqIK793vFL4mzrh0uo876OiK9dWLZZR4UVbVRavhAiSVLY/umNAy
         u/fVu0Ej2gu17wnVCM3OIIukRXOjLTQJNO/tYvfNuM7EMEsOEomAc2kBstCVg35r030g
         qctQ==
X-Forwarded-Encrypted: i=1; AJvYcCVivJK5hBoHsTdBloWc3mue9HzbMv2+FUlAubIsv8B6qxENh2YKouCcrPmBzqSlxzfGIZTMkS4=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw/8ROK7Jl9DFrdfwgzxZBm7vxkFKpCfNrmOKo/RjQGoFqhXeOO
	/Jpc79a92iqzGYYVm/aCrvqGl0VgmnePFFzpmGTDj6Ej7NhlmC5HfT2Js2wd0kqmO2SdWcNGYgF
	JDNJwFCJpuYIQJUUwEWkv/aF6M5qldQFYGMn7Qtgh
X-Gm-Gg: ASbGncveX9amNUTIFMgJBur+O1ZQvwUSFDrVfFfdYBWjMRTC2VkuPbe4WkIlil1ooAF
	cz+ba4u674Sr+l0ZIGkUNfze5V7r0sCvy3ivn9oYLfN9ueaos5NRCR1e++OHEglLu9sb/PBhLtd
	+l77e8FrNHAOzLhzBelS945LKlwA2qDPRySFhDE7owaFB/11fNAm8U111F1drWSYADiPcu1h4+g
	rDG5EtB9F4C9FZI+hG1tDYpMfvJ3tL6Aw582cA3F80m7m9BtZ4+GoN1k0Q63ZhYX8cllWmxPup0
	KqB/8lzXDHFYINEkAYKUUIjMELus1oNXl3D8l6R6+nocGzQZiBGGLs1WzA==
X-Google-Smtp-Source: AGHT+IFgQwIMS3/ZiwEl8MpQ/MSzWg5AT4eRzAPij6OyGJFsBZ0ddpdKluXln3Vs6Ueh/u9gkMYM8a2aiqbRo2N7rRw=
X-Received: by 2002:a05:6808:6c93:b0:450:cd83:80be with SMTP id
 5614622812f47-4539e0987c6mr3892846b6e.50.1765266623096; Mon, 08 Dec 2025
 23:50:23 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6937cdff.a70a0220.38f243.00c7.GAE@google.com>
In-Reply-To: <6937cdff.a70a0220.38f243.00c7.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 9 Dec 2025 16:50:11 +0900
X-Gm-Features: AQt7F2r3Tstcb-w8ya9RkgcouC0fG3zvjZlfJu3mMuIfzKIMVJbCU33COyLoBbI
Message-ID: <CANp29Y4FCvmT3f4PxHB=2oktY42oCdLU1JkfqwFpA_aufZh9Pg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: xsk: move cq_cached_prod_lock to avoid
 touching a cacheline in sending path
To: syzbot ci <syzbot+ci71a98442f168165b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Dec 9, 2025 at 4:21=E2=80=AFPM syzbot ci
<syzbot+ci71a98442f168165b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v4] xsk: move cq_cached_prod_lock to avoid touching a cacheline in sendi=
ng path
> https://lore.kernel.org/all/20251209031628.28429-1-kerneljasonxing@gmail.=
com
> * [PATCH RFC net-next v4] xsk: move cq_cached_prod_lock to avoid touching=
 a cacheline in sending path
>
> and found the following issue:
> BUG: unable to handle kernel NULL pointer dereference in xp_create_and_as=
sign_umem
>
> Full report is available here:
> https://ci.syzbot.org/series/d7e166a7-a880-4ea1-9707-8889afd4ebe8
>
> ***
>
> BUG: unable to handle kernel NULL pointer dereference in xp_create_and_as=
sign_umem
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      0177f0f07886e54e12c6f18fa58f63e63ddd3c58
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/d327cc4b-7471-413b-b244-519c6d16d=
43b/config
> C repro:   https://ci.syzbot.org/findings/c8f7aeaf-0e2e-43dd-ae9c-ea2dd8d=
b8d34/c_repro
> syz repro: https://ci.syzbot.org/findings/c8f7aeaf-0e2e-43dd-ae9c-ea2dd8d=
b8d34/syz_repro
>
> UDPLite6: UDP-Lite is deprecated and scheduled to be removed in 2025, ple=
ase contact the netdev mailing list
> BUG: kernel NULL pointer dereference, address: 0000000000000058
> #PF: supervisor write access in kernel mode
> #PF: error_code(0x0002) - not-present page
> PGD 80000001b2496067 P4D 80000001b2496067 PUD 0
> Oops: Oops: 0002 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 5973 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:lockdep_init_map_type+0x1e/0x380 kernel/locking/lockdep.c:4944
> Code: 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 41 56 53 48 83 e=
c 10 89 cd 48 89 fb 65 48 8b 05 67 af d1 10 48 89 44 24 08 <48> c7 47 10 00=
 00 00 00 48 c7 47 08 00 00 00 00 8b 05 8c f2 dc 17
> RSP: 0018:ffffc90003c07bb8 EFLAGS: 00010286
> RAX: ec490cf5c114aa00 RBX: 0000000000000048 RCX: 0000000000000000
> RDX: ffffffff99d16120 RSI: ffffffff8c92a180 RDI: 0000000000000048
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000000
> R10: ffffed102e5d7800 R11: fffffbfff1efa3cf R12: dffffc0000000000
> R13: ffff8881bdeb3000 R14: ffffffff99d16120 R15: ffffffff8c92a180
> FS:  00005555729bd500(0000) GS:ffff8882a9f31000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000058 CR3: 0000000172faa000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  lockdep_init_map_waits include/linux/lockdep.h:135 [inline]
>  lockdep_init_map_wait include/linux/lockdep.h:142 [inline]
>  __raw_spin_lock_init+0x45/0x100 kernel/locking/spinlock_debug.c:25
>  xp_create_and_assign_umem+0x648/0xd40 net/xdp/xsk_buff_pool.c:94
>  xsk_bind+0x95a/0xf90 net/xdp/xsk.c:1355
>  __sys_bind_socket net/socket.c:1874 [inline]
>  __sys_bind+0x2c6/0x3e0 net/socket.c:1905
>  __do_sys_bind net/socket.c:1910 [inline]
>  __se_sys_bind net/socket.c:1908 [inline]
>  __x64_sys_bind+0x7a/0x90 net/socket.c:1908
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xfa0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f591eb8f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffce6fcef48 EFLAGS: 00000246 ORIG_RAX: 0000000000000031
> RAX: ffffffffffffffda RBX: 00007f591ede5fa0 RCX: 00007f591eb8f7c9
> RDX: 0000000000000010 RSI: 0000200000000240 RDI: 0000000000000003
> RBP: 00007f591ebf297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f591ede5fa0 R14: 00007f591ede5fa0 R15: 0000000000000003
>  </TASK>
> Modules linked in:
> CR2: 0000000000000058
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:lockdep_init_map_type+0x1e/0x380 kernel/locking/lockdep.c:4944
> Code: 90 90 90 90 90 90 90 90 90 90 90 90 f3 0f 1e fa 55 41 56 53 48 83 e=
c 10 89 cd 48 89 fb 65 48 8b 05 67 af d1 10 48 89 44 24 08 <48> c7 47 10 00=
 00 00 00 48 c7 47 08 00 00 00 00 8b 05 8c f2 dc 17
> RSP: 0018:ffffc90003c07bb8 EFLAGS: 00010286
> RAX: ec490cf5c114aa00 RBX: 0000000000000048 RCX: 0000000000000000
> RDX: ffffffff99d16120 RSI: ffffffff8c92a180 RDI: 0000000000000048
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000000
> R10: ffffed102e5d7800 R11: fffffbfff1efa3cf R12: dffffc0000000000
> R13: ffff8881bdeb3000 R14: ffffffff99d16120 R15: ffffffff8c92a180
> FS:  00005555729bd500(0000) GS:ffff8882a9f31000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000058 CR3: 0000000172faa000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   90                      nop
>    1:   90                      nop
>    2:   90                      nop
>    3:   90                      nop
>    4:   90                      nop
>    5:   90                      nop
>    6:   90                      nop
>    7:   90                      nop
>    8:   90                      nop
>    9:   90                      nop
>    a:   90                      nop
>    b:   90                      nop
>    c:   f3 0f 1e fa             endbr64
>   10:   55                      push   %rbp
>   11:   41 56                   push   %r14
>   13:   53                      push   %rbx
>   14:   48 83 ec 10             sub    $0x10,%rsp
>   18:   89 cd                   mov    %ecx,%ebp
>   1a:   48 89 fb                mov    %rdi,%rbx
>   1d:   65 48 8b 05 67 af d1    mov    %gs:0x10d1af67(%rip),%rax        #=
 0x10d1af8c
>   24:   10
>   25:   48 89 44 24 08          mov    %rax,0x8(%rsp)
> * 2a:   48 c7 47 10 00 00 00    movq   $0x0,0x10(%rdi) <-- trapping instr=
uction
>   31:   00
>   32:   48 c7 47 08 00 00 00    movq   $0x0,0x8(%rdi)
>   39:   00
>   3a:   8b 05 8c f2 dc 17       mov    0x17dcf28c(%rip),%eax        # 0x1=
7dcf2cc
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
-upstream-moderation/6937cdff.a70a0220.38f243.00c7.GAE%40google.com.
