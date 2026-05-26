Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 21FBA38E5C5
	for <syzbot@lists.linux.dev>; Tue, 26 May 2026 05:47:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779774425; cv=pass; b=OnUcoH74ex2itF1m+fJmClu6QiWrFerFBz7nTYcCWvlFk2MMUWrvzpViJOh3BdRBLi6lxtJNVRPFQCgSu/X8oDZzMPF77zO/8xGD4rvTEkJzK12tuvx1hI3EIe6rlWmNk8MiUExfu4jzAPE3XGiXdj8mQwI9bOs7wXFK2H8Y1Do=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779774425; c=relaxed/simple;
	bh=7VL9R38MeONh5/eKfcqeqF69+KCOv1RJT/POJUev0kg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TLnm6MUZCAY3JTF/dNLm+cDc487SPHIoaquBkC1tBaRMHKFa6vyObhjl7s8w/3WaFq9uK6KZ/TOEBmwN3vI6jiQaHm5l3o3DDSz0/VCzIA/W9AQ/ybL2Wv0tZdGe687TxMHtaHu6TBYspx6spyzNy0oZtBNNarYgvwbDkrVbvi0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=d1lyiF58; arc=pass smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="d1lyiF58"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-484d3c0855aso3808695b6e.3
        for <syzbot@lists.linux.dev>; Mon, 25 May 2026 22:47:03 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1779774423; cv=none;
        d=google.com; s=arc-20240605;
        b=ELUIqhJCT9Jlr8Q3iQccIXxvlCuXRYEJBSx7WEmF4BqrSHY9zb8dcUohBGWAHWItzo
         v6jewGrtWKPo1YvPYLD6rEFy7kzCh0fP9r+jai6l8CRHnx9SsCKh5yh0SzF8pjWHQZ3H
         d5+n/+5zOnuyP+i1AJtQKVtoY7HLMeNwzsE15qaCexDb5Cb5HaNlQSP/I5pvbo+WDgiK
         1H98iOHLazaHdWMeFhDc5/o566tSgMgoLjyLsfv00smmVlCShWwqyQWRLWZoIoC6z9gG
         sV6XBTN0R5CtkC/8bJPX1rBhZZle/DmdySFhpEp0/zyJ5Dyj66y5jNL3wXL+tHJX5P46
         jDDQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=4B+S1IHQG+G9M+THWOZ/ZE7rwFGC1F3dqUECjQgOvgQ=;
        fh=IEMEbViXgEzW8oMJWd8+5TQQI3N63r1nNKKEpmDuwwA=;
        b=WJ3cw4xedg8XacwOI7jDHf+SCJzLK4gMhUrsRtYzBV0XhOrPC1CfV7aPvyI75Bbxbh
         1Wj9RlmaRopPZJyBbkuUeXZVno+tBe7dMK1406J74WQlIhkQnB/HfxZT8Rig4b74xZSf
         KVlBv8L0HP/sWLcTvMUJWH8fYqL5BkmgTjiMN5xe/d36TYGazjBLY+YhOonk0WL1SE31
         PZRSt6jCgvyhLGKCpa08QNdKI15NU8YQJ4k1drRnmY9kozWnXOEZxs5jJjpHz1PC7rIC
         A+/uLJJUsQSG5XOp82v3MsrHON39GnYwR36/sJYonDczpjoElGuB6SG3v2W0P1Jk+a0r
         2eBA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1779774423; x=1780379223; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4B+S1IHQG+G9M+THWOZ/ZE7rwFGC1F3dqUECjQgOvgQ=;
        b=d1lyiF586hf0GDOhvmsS2K3mKPlgqMeAz9UvkvUtYviPAwuJ2i2vB1K1HNCyj/51sw
         /4xj4mVkUEirLezFYOoxTtN+5K178RYAK7rtR/9gNMNbYXxmfWQPbQDjYegmuhicXOP1
         9LpmkZCFJ1z3ndazuyHUyrGMUoSsZzOYYOvwY0oBhV2bGKSlNjjUjMs50HIoFuq2spTH
         l99wwCxVGKl0Rkuz4hnvM/LnoJvoCk9K6jsGtMs5yzg6lYD+YkrFQrClHnZSQR919PI0
         Y1vgH7mlYR4n/YMYJp7+pGDiDmSCUhlOuiRcZZTvLeFdERxDYAn7DfgMaJeBwY3GlQvq
         inAw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1779774423; x=1780379223;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=4B+S1IHQG+G9M+THWOZ/ZE7rwFGC1F3dqUECjQgOvgQ=;
        b=PrYIP6EnhKlPZuja7BGJnb0zakb50/+anU1VnPIcJYV+FcagQ+Ki3q9F++x3T57k/F
         DWiVUXqJuHcRVkvm19DE3ycmZG1Y9bMQyFIFls/fUl7IKzTS3iyt+H13bxXeags8XMG2
         +F9dQvLnuguk+1yE+167NNpadZZn5QwW+0UbVZK2TTtqg31ostnf7FrpOIN+bx+DyGMe
         mZ3wbdMPsY9rvE5AysEVuCL1ZaXqRFl7/zuwCW8D2VLIuukI3M3u3lpGlaRm7O3jtkVJ
         X6Um24cUGNGLKdW05qhs782V0omeLcVK76w7P1IRZgolmflUouQuBi5mKH8DAHcZNhWP
         LNlg==
X-Forwarded-Encrypted: i=1; AFNElJ8fS6n7C4E01DIBj2BsLKWs7ZWGpGWYzeXicgLaUR0n2hZDc063S2bF1bWLNAp2I8MmUl5jQYg=@lists.linux.dev
X-Gm-Message-State: AOJu0YyN3SifxxbZtznODpgUSgCduCZUeC3dD3Za+pLppuBGKcWT0hDL
	yoeIFGflsR6xBvt9vDHO2ZeKSJ7IJyZwtnY/Y7q4uqvGw0djr++3QrHMGmSRW9xNm/3OSnnz1ES
	/rcX0+Zge4YObvEGisLM5TIQ+gGWBydzMoFMQAqfN
X-Gm-Gg: Acq92OFbN2pMSsn8EPMt0RWzglhC2iKzYKOe78Z2J8LJSMAJrtHY3eNErucBHTFXaff
	RhLW34sQRWku/tOtO6aYEvkailK0yTzqv/3dFjBnh1a6wVTVAFbrkb+zIqLjM+UFiUy5CnaPO+q
	i6v5x/KP3P5OPZPd1X3BQGRo6zBY44MtmK4rvBTYPqN3j75s6Onnufl+Gb0LuZWTHoF5f+PTNul
	/aAYSX8p5OPxj3hdtHzdTUMn1KDs1SSxcFfXgDp7OdglRkskWcx9IbLbkG03uehVjzNCslydz3g
	0emm1KAhL0Pp21Epgs5+J0s5q0Lzim2oI2jnfMJdQXonSCxemGo/nwzxid4UY7vZpDwwhvi3HWD
	6unVJPsA=
X-Received: by 2002:a05:6808:6715:b0:480:6596:4c8a with SMTP id
 5614622812f47-4854a3d6778mr9931639b6e.38.1779774422437; Mon, 25 May 2026
 22:47:02 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a14bf49.050a0220.2385e8.001b.GAE@google.com>
In-Reply-To: <6a14bf49.050a0220.2385e8.001b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 26 May 2026 07:46:51 +0200
X-Gm-Features: AVHnY4I1eHIvsImub-goBotlo3tM3LvtQ0lmBf8rOnUrAwRP3Yzo1HRhSlqCy64
Message-ID: <CANp29Y6RkO0DQgPM3p79M+DHpsJJsPt2wCUYGK0Akj3Zi4=Zxg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Implement a new generic pagewalk API
To: syzbot ci <syzbot+cib37dbe4691931542@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, May 25, 2026 at 11:29=E2=80=AFPM syzbot ci
<syzbot+cib37dbe4691931542@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v3] Implement a new generic pagewalk API
> https://lore.kernel.org/all/20260525165528.184397-1-osalvador@suse.de
> * [RFC PATCH v3 1/8] mm: Add softleaf_from_pud
> * [RFC PATCH v3 2/8] mm: Add {pmd,pud}_huge_lock helper
> * [RFC PATCH v3 3/8] mm: Implement folio_pmd_batch
> * [RFC PATCH v3 4/8] mm: Implement pt_range_walk
> * [RFC PATCH v3 5/8] mm: Make /proc/pid/smaps use the new generic pagewal=
k API
> * [RFC PATCH v3 6/8] mm: Make /proc/pid/numa_maps use the new generic pag=
ewalk API
> * [RFC PATCH v3 7/8] mm: Make /proc/pid/pagemap use the new generic pagew=
alk API
> * [RFC PATCH v3 8/8] mm: Make /proc/pid/clear_refs use the new generic pa=
gewalk API
>
> and found the following issue:
> general protection fault in clear_refs_write
>
> Full report is available here:
> https://ci.syzbot.org/series/0beab2d0-9d88-4288-ac81-b294e51c057d
>
> ***
>
> general protection fault in clear_refs_write
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      5200f5f493f79f14bbdc349e402a40dfb32f23c8
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/8f20e88b-808c-4c60-9b8e-0af4c9fce=
5ff/config
> syz repro: https://ci.syzbot.org/findings/634b1f0a-cf64-4607-928a-ef3ad40=
f765c/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 1 UID: 0 PID: 5863 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:clear_soft_dirty_pmd fs/proc/task_mmu.c:1545 [inline]
> RIP: 0010:clear_refs_pmd_range fs/proc/task_mmu.c:1581 [inline]
> RIP: 0010:clear_refs_write+0xaa7/0x1590 fs/proc/task_mmu.c:1721
> Code: 44 24 10 4c 8b bc 24 20 02 00 00 83 7c 24 28 04 0f 85 aa 05 00 00 4=
8 8b 9c 24 08 02 00 00 48 89 d8 48 c1 e8 03 48 89 44 24 58 <42> 80 3c 20 00=
 74 08 48 89 df e8 fa 2c c6 ff 4c 8b 23 4c 89 e6 48
> RSP: 0018:ffffc900037bf960 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000005
> RDX: ffffffff826b21ce RSI: ffffffff8eb17b50 RDI: 0000000000000001
> RBP: ffffc900037bfc10 R08: ffff8881047c0000 R09: 0000000000000002
> R10: 0000000000000002 R11: 0000000000000000 R12: dffffc0000000000
> R13: fffff520006f7f40 R14: ffff8881141c8308 R15: ffff8881141c8300
> FS:  00007ff8ffc1d6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b33e63fff CR3: 000000010476e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  do_loop_readv_writev fs/read_write.c:852 [inline]
>  vfs_writev+0x4bd/0x990 fs/read_write.c:1061
>  do_writev+0x154/0x2e0 fs/read_write.c:1105
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7ff8fed9ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ff8ffc1d028 EFLAGS: 00000246 ORIG_RAX: 0000000000000014
> RAX: ffffffffffffffda RBX: 00007ff8ff015fa0 RCX: 00007ff8fed9ce59
> RDX: 0000000000000001 RSI: 00002000000000c0 RDI: 0000000000000003
> RBP: 00007ff8fee32d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007ff8ff016038 R14: 00007ff8ff015fa0 R15: 00007fffd02796e8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:clear_soft_dirty_pmd fs/proc/task_mmu.c:1545 [inline]
> RIP: 0010:clear_refs_pmd_range fs/proc/task_mmu.c:1581 [inline]
> RIP: 0010:clear_refs_write+0xaa7/0x1590 fs/proc/task_mmu.c:1721
> Code: 44 24 10 4c 8b bc 24 20 02 00 00 83 7c 24 28 04 0f 85 aa 05 00 00 4=
8 8b 9c 24 08 02 00 00 48 89 d8 48 c1 e8 03 48 89 44 24 58 <42> 80 3c 20 00=
 74 08 48 89 df e8 fa 2c c6 ff 4c 8b 23 4c 89 e6 48
> RSP: 0018:ffffc900037bf960 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: 0000000000000000 RCX: 0000000000000005
> RDX: ffffffff826b21ce RSI: ffffffff8eb17b50 RDI: 0000000000000001
> RBP: ffffc900037bfc10 R08: ffff8881047c0000 R09: 0000000000000002
> R10: 0000000000000002 R11: 0000000000000000 R12: dffffc0000000000
> R13: fffff520006f7f40 R14: ffff8881141c8308 R15: ffff8881141c8300
> FS:  00007ff8ffc1d6c0(0000) GS:ffff8882a928a000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b34063fff CR3: 000000010476e000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   44 24 10                rex.R and $0x10,%al
>    3:   4c 8b bc 24 20 02 00    mov    0x220(%rsp),%r15
>    a:   00
>    b:   83 7c 24 28 04          cmpl   $0x4,0x28(%rsp)
>   10:   0f 85 aa 05 00 00       jne    0x5c0
>   16:   48 8b 9c 24 08 02 00    mov    0x208(%rsp),%rbx
>   1d:   00
>   1e:   48 89 d8                mov    %rbx,%rax
>   21:   48 c1 e8 03             shr    $0x3,%rax
>   25:   48 89 44 24 58          mov    %rax,0x58(%rsp)
> * 2a:   42 80 3c 20 00          cmpb   $0x0,(%rax,%r12,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   48 89 df                mov    %rbx,%rdi
>   34:   e8 fa 2c c6 ff          call   0xffc62d33
>   39:   4c 8b 23                mov    (%rbx),%r12
>   3c:   4c 89 e6                mov    %r12,%rsi
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
> To test a patch for this bug, please reply with `#syz test`
> (should be on a separate line).
>
> The patch should be attached to the email.
> Note: arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [akpm@linux-foundation.org david@kernel.org david@redhat.com linux-kernel=
@vger.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse.=
com muchun.song@linux.dev osalvador@suse.de vbabka@kernel.org]
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
-upstream-moderation/6a14bf49.050a0220.2385e8.001b.GAE%40google.com.
