Received: from mail-ot1-f47.google.com (mail-ot1-f47.google.com [209.85.210.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7DB2834041B
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 16:11:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787760686; cv=pass; b=jNFBW07PNWMY6veNRntGZmLvKyYsC8Hu3Mhv6LRIopEfAX/lOe07sxS7VEi9yuVe9cFerlWKGIQWLHKITSN6XTjtzpTmWlkJUHFIQSn9nlrM73bOuOCnL6UOqn56o2IIdCEBQq7rcKSYWShuyfQfmuaMpRkBxN4k4QMbMK0hH3E=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787760686; c=relaxed/simple;
	bh=LX1/MHjmObdsdhKg8FPXFBfo8/+xaKCMr7gMDGV1FRA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=GZBWBlzpO39Vt9yjobhu/RgRiqKW7hnMeBpGo09tz5Xs7MiURBEmHJelUkwpBOsjCVs93YYBSupLcEQXjmPWfQCq7fxnh4q7SaNdmsXm5XMsFGgpxJH+B9m7pMV8+WyyjVF3femYsqZdjBpjCFvPhogZq+DKrqbh+RZl/tqdXJs=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=rB297FAJ; arc=pass smtp.client-ip=209.85.210.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="rB297FAJ"
Received: by mail-ot1-f47.google.com with SMTP id 46e09a7af769-7f434cc1c5eso1240759a34.0
        for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 09:11:24 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1787760683; cv=none;
        d=google.com; s=arc-20260327;
        b=HdFxUpfyuooduG86wiZOLdmighRezINukZA76pU8QUjJr4+N1iH6zXffDLrc/I0cgz
         FNJZXT489O0p47xicizdp6Zgc6YtoeRWjT0xUpdpkdRF5jb3kMRkugEnACB5tknvZxqC
         luvJI9Yc6E8aifyWcNBfxAeFiAsYFqd/R19VUek/ov7rSis3knPZ3uYdWBFtDBk/qL6D
         YS83R0jiiR8Z0t7LgDf/tjQeIOf/+j+LzgYq5jHbVPxRZEJo3zhbxDMrONHgx001v5cH
         BNks+yEoUOwowawwiiT7BoWb58T6AIXz3+x2Rza035MmbSBp9ChWrRI3OW/zOmBv6S8/
         8dHg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=NHiP4h16cEEPLmA8CP3D8jwd0F03zlHPDlKFdZ0cRtk=;
        fh=i6a0DC+AgNknl7tX6wcFa6yjlGo47gnJv74Ao04RZw0=;
        b=B1e6ERdylXYqCE8qMCdEW8BiAVTu/aQpmgh96r9R0NeH++Pq13saNJA2NO7sZPkixp
         EAesIqQCaUfEHV6ZCbZTf+V0CmbL0lghKB3QNhiOuwI/uVxVnEET9zRAxHT7ZWfPw2lU
         drOxS6j/3xD4MKK9h1RXqqMwv9ZZ35vXJK5oxyd5E3IZ2sIVdfTnCa26K5tejpBtWhkp
         GDqdhOEzcTxmAgA2LbCShA5HGUeCbH1LrTIUvHdCwSHN+SSTJ9DVTJ49V4GC2cUSx16h
         JlOc/Ny7v7I7y249/BD8T1lT+sEO3j/xxRshUQhPmfuteKZJ0xeeeSbcWbjMZtTxz/hv
         WumQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1787760683; x=1788365483; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=NHiP4h16cEEPLmA8CP3D8jwd0F03zlHPDlKFdZ0cRtk=;
        b=rB297FAJ5RSNI8NmEFol/7D9ev04HkXJ5AXvSh9TW1F29XVeBa7O3keC7uFS55BWCH
         omk4fGL9kxEspQ8ixaYIMK9Zn/q6pAdll5i869FztndXUPvMBcIBxHZO+BSmpwKpcydi
         VDggICoC6ceH2uZRTZT4jtVywg2Xk4YftMpJsoC5cVuP709oHyG90A8kMCipqaoDgUST
         r9QaGDoPUhFczyE4QsfNci676Wy6ha6hZ5ib3UP5h8qpH1W18AB1K1C9QINQQRq3zrkV
         cea1LNNRVEvx9jPY8cdy2uUakxlFVOXKNyedhCRQG/3QT6gLwpbAQ/yv7o2FjyWE4nUj
         V+Fg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1787760683; x=1788365483;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=NHiP4h16cEEPLmA8CP3D8jwd0F03zlHPDlKFdZ0cRtk=;
        b=rcl0gcDfWYIPKb/XA054cOjAaB3QujOC7uFieUrOMfo2B98FMbuxnXG48+gnILzBer
         GFSfpMZA0D8GHF+ybIMrZzxro9OvIfewXyFI8Z+PQMHCaf+tORvqPUPck2AuzNwtdjwD
         wPvfKSmRPkH7znJfnE74IUdHQde2K3QK+DPGCQaMV8cG+Pro5oXOD+T1oErH+25O1B0k
         pTsh9vrRYP3mOWVd3pfk59DpdlFMX5El0ZBD+soViTB3uA7mvYjntOwMgMmhZfj1mQlN
         Su8ZApj6U9ibI2/b8TF7qkJcoojVTR0BCeiozSnYh7LR88KlHuQ4AChLQJeXxVd2GzQI
         HAAQ==
X-Forwarded-Encrypted: i=1; AHgh+RouFKpQs1NWHrzlfkxvmVqo6XN6YC9Gw+/QQXgzBg+WyFWtMuRx3lYH/5teS4ErDSv+F3kqFgA=@lists.linux.dev
X-Gm-Message-State: AFuF++nSBJTl8q7fMLL+CQPiL+Sond/SJzZYKTlzRTrwKOMWx/r4b7bx
	4McOS8GLrTxMSujTcLGb1KDXw7RQ0XMxdo/0BAAAbwd8j+gPXSRsJcAcdOxxWvVrqTweFZfRajH
	XG0KIeMjTiSN1X1YQpuRrMVrfg3Qwe4+NiCKJ6mWXUnw6WjJ94YFaD+4jaHY=
X-Gm-Gg: AR+sD115qkC9d6CmWQvq1ype3T7WN15u94Tx2HF+ZeVhC2DIbQG9C7JuEjYEea7KrNd
	f5+Cz1LPBtgwUMtEThXxdc6x9IOioF5u6PS+wp5TX4ypw4QN7K9gdsQytU9bIBlGQ+ceGZdQt5M
	0tIQbreWHqW+GjIkZN4YWNP9O7VFrLnYqW2Pn7c5Fvja719plsmf+tNP0MIT7fqPeXW+4IKMjTP
	6avH/6UzDwUJzUckIjhlLkemN4U4qvdxptnrF894NNvV1kKrmNB84Oc0Tsvvcvu6Aob9RUjpPHR
	qVTwk2l+xNxevt+tTKG//Q9x7LvgUW1SnHWSncZBhQT5StrJwxrDiUylwcFGpxMkbpe1oQ69qL+
	ReSSSdexdeKfAzYB5NCE57H6bCogR+aMOY8flPHaXH4iA17E0udErHqVMwrc78Y76DkHlAHXEcB
	zFTwvWDum49U28auQ=
X-Received: by 2002:a05:6830:3c89:b0:7e6:c9eb:535a with SMTP id
 46e09a7af769-7f4c4ec9535mr8137885a34.6.1787760682411; Wed, 26 Aug 2026
 09:11:22 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a8f080c.1d9ded08.62e62.00b4.GAE@google.com>
In-Reply-To: <6a8f080c.1d9ded08.62e62.00b4.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 26 Aug 2026 18:11:11 +0200
X-Gm-Features: AcwNN1XmBOuTwO6gRMLUf-3xvKKVS7tqx_DgswO6xWFEM6lFZkBi8i-ms8HV9gM
Message-ID: <CANp29Y4OnTH9YHxgQTQtN+mX1-Py3NCCB77-0QfGb_QvhnQRpQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: Fix UAF due to concurrent consumption of waiting_for_gp_ttrace
To: syzbot ci <syzbot+ci684786ceae4680c8@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Aug 26, 2026 at 5:36=E2=80=AFPM syzbot ci
<syzbot+ci684786ceae4680c8@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] bpf: Fix UAF due to concurrent consumption of waiting_for_gp_ttrace
> https://lore.kernel.org/all/20260826103615.932094-1-pulehui@huaweicloud.c=
om
> * [PATCH bpf] bpf: Fix UAF due to concurrent consumption of waiting_for_g=
p_ttrace
>
> and found the following issues:
> * BUG: unable to handle kernel NULL pointer dereference in rcu_core
> * BUG: unable to handle kernel paging request in corrupted
> * WARNING in mntput_no_expire_slowpath
> * kernel BUG in free_percpu
>
> Full report is available here:
> https://ci.syzbot.org/series/cfb01d47-3cc7-43a6-99e6-c4a0c6e6ce89
>
> ***
>
> BUG: unable to handle kernel NULL pointer dereference in rcu_core
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      75b0a6db4300e4c2c9e97a0848deaa7acfb42fb7
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/187f4142-010e-469f-b2d4-8ce60c1dd=
2c5/config
> syz repro: https://ci.syzbot.org/findings/5ac25989-0260-4506-a08a-25fa6e4=
957e7/syz_repro
>
> BUG: kernel NULL pointer dereference, address: 0000000000000000
> #PF: supervisor instruction fetch in kernel mode
> #PF: error_code(0x0010) - not-present page
> PGD 800000016a651067 P4D 800000016a651067 PUD 0
> Oops: Oops: 0010 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 5776 Comm: syz.0.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> RSP: 0018:ffffc90000a08db8 EFLAGS: 00010246
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000028
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffe8ffffc2c5d0
> RBP: ffffc90000a08f20 R08: ffffffff81ad5526 R09: 0000000000000000
> R10: ffffc90000a08c70 R11: 0000000000000000 R12: ffffe8ffffc2c5d0
> R13: dffffc0000000000 R14: ffffffff81ad5526 R15: ffffe8ffffc2c5d8
> FS:  00005555813d0500(0000) GS:ffff8882a8f2d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 0000000105338000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  rcu_do_batch kernel/rcu/tree.c:2645 [inline]
>  rcu_core+0x794/0x10b0 kernel/rcu/tree.c:2897
>  handle_softirqs+0x226/0x860 kernel/softirq.c:645
>  __do_softirq kernel/softirq.c:679 [inline]
>  invoke_softirq kernel/softirq.c:519 [inline]
>  __irq_exit_rcu+0xcb/0x220 kernel/softirq.c:767
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:784
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inli=
ne]
>  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1062
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:674
> RIP: 0010:lock_release+0x2d7/0x3c0 kernel/locking/lockdep.c:5911
> Code: a2 cc 11 00 00 00 00 eb b5 e8 55 12 34 0a f7 c3 00 02 00 00 74 b9 6=
5 48 8b 05 ad 5d cc 11 48 3b 44 24 28 75 44 fb 48 83 c4 30 <5b> 41 5c 41 5d=
 41 5e 41 5f 5d e9 8a 17 37 0a cc 48 8d 3d b2 b3 b8
> RSP: 0018:ffffc900039dfa68 EFLAGS: 00000282
> RAX: 4b32b4bcbbad6400 RBX: 0000000000000287 RCX: 0000000000000046
> RDX: 0000000000000000 RSI: ffffffff8e4d8901 RDI: ffffffff8c4cd780
> RBP: ffff88810b5d29a8 R08: ffffffff821d972f R09: 0000000000000000
> R10: 0000000000000000 R11: ffff8881162fe9b8 R12: 0000000000000000
> R13: 0000000000000000 R14: ffff8881162fe9b8 R15: ffff88810b5d1e00
>  _inline_copy_from_user include/linux/uaccess.h:169 [inline]
>  _copy_from_user+0x28/0xb0 lib/usercopy.c:18
>  copy_from_user include/linux/uaccess.h:222 [inline]
>  generic_map_update_batch+0x668/0xae0 kernel/bpf/syscall.c:2101
>  bpf_map_do_batch+0x391/0x630 kernel/bpf/syscall.c:5781
>  __sys_bpf+0xbe5/0xd90 kernel/bpf/syscall.c:-1
>  __do_sys_bpf kernel/bpf/syscall.c:6486 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6483 [inline]
>  __x64_sys_bpf+0xba/0xd0 kernel/bpf/syscall.c:6483
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7febdab9e0d9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc5722f5a8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007febdae25fa0 RCX: 00007febdab9e0d9
> RDX: 0000000000000038 RSI: 00002000000003c0 RDI: 000000000000001a
> RBP: 00007febdac35024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007febdae25fac R14: 00007febdae25fa0 R15: 00007febdae25fa0
>  </TASK>
> Modules linked in:
> CR2: 0000000000000000
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:0x0
> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> RSP: 0018:ffffc90000a08db8 EFLAGS: 00010246
>
> RAX: dffffc0000000000 RBX: 0000000000000000 RCX: 0000000000000028
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffe8ffffc2c5d0
> RBP: ffffc90000a08f20 R08: ffffffff81ad5526 R09: 0000000000000000
> R10: ffffc90000a08c70 R11: 0000000000000000 R12: ffffe8ffffc2c5d0
> R13: dffffc0000000000 R14: ffffffff81ad5526 R15: ffffe8ffffc2c5d8
> FS:  00005555813d0500(0000) GS:ffff8882a8f2d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffffffffffffffd6 CR3: 0000000105338000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   a2 cc 11 00 00 00 00    movabs %al,0xb5eb0000000011cc
>    7:   eb b5
>    9:   e8 55 12 34 0a          call   0xa341263
>    e:   f7 c3 00 02 00 00       test   $0x200,%ebx
>   14:   74 b9                   je     0xffffffcf
>   16:   65 48 8b 05 ad 5d cc    mov    %gs:0x11cc5dad(%rip),%rax        #=
 0x11cc5dcb
>   1d:   11
>   1e:   48 3b 44 24 28          cmp    0x28(%rsp),%rax
>   23:   75 44                   jne    0x69
>   25:   fb                      sti
>   26:   48 83 c4 30             add    $0x30,%rsp
> * 2a:   5b                      pop    %rbx <-- trapping instruction
>   2b:   41 5c                   pop    %r12
>   2d:   41 5d                   pop    %r13
>   2f:   41 5e                   pop    %r14
>   31:   41 5f                   pop    %r15
>   33:   5d                      pop    %rbp
>   34:   e9 8a 17 37 0a          jmp    0xa3717c3
>   39:   cc                      int3
>   3a:   48                      rex.W
>   3b:   8d                      .byte 0x8d
>   3c:   3d                      .byte 0x3d
>   3d:   b2 b3                   mov    $0xb3,%dl
>   3f:   b8                      .byte 0xb8
>
>
> ***
>
> BUG: unable to handle kernel paging request in corrupted
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      75b0a6db4300e4c2c9e97a0848deaa7acfb42fb7
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/187f4142-010e-469f-b2d4-8ce60c1dd=
2c5/config
> syz repro: https://ci.syzbot.org/findings/d4bc6f3a-dacb-412b-ac9d-51a5c1d=
bc4a4/syz_repro
>
> kernel tried to execute NX-protected page - exploit attempt? (uid: 0)
> BUG: unable to handle page fault for address: ffff888173315c00
> #PF: supervisor instruction fetch in kernel mode
> #PF: error_code(0x0011) - permissions violation
> PGD 1acd0067 P4D 1acd0067 PUD 1acd5067 PMD 80000001732000e3
> Oops: Oops: 0011 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:0xffff888173315c00
> Code: ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <80> 5b 31 73 81=
 88 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> RSP: 0018:ffffc90000007d60 EFLAGS: 00010246
> RAX: 1ffffd1ffff8f783 RBX: ffffe8ffffc7bc18 RCX: ffffffff8e88ef80
> RDX: 0000000000000100 RSI: ffff888174548380 RDI: ffffffff81f86ab8
> RBP: ffffe8ffffc7bc10 R08: 0000000000000100 R09: 0000000000000000
> R10: 0000000000000000 R11: ffff888173315c00 R12: e5894855fa1e0ff3
> R13: ffff888173315c00 R14: ffffffff81f86ab0 R15: ffffe8ffffc7bc18
> FS:  0000000000000000(0000) GS:ffff88818d92d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff888173315c00 CR3: 000000010b9a2000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  </IRQ>
>  <TASK>
>  </TASK>
> Modules linked in:
> CR2: ffff888173315c00
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:0xffff888173315c00
> Code: ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 <80> 5b 31 73 81=
 88 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00
> RSP: 0018:ffffc90000007d60 EFLAGS: 00010246
> RAX: 1ffffd1ffff8f783 RBX: ffffe8ffffc7bc18 RCX: ffffffff8e88ef80
> RDX: 0000000000000100 RSI: ffff888174548380 RDI: ffffffff81f86ab8
> RBP: ffffe8ffffc7bc10 R08: 0000000000000100 R09: 0000000000000000
> R10: 0000000000000000 R11: ffff888173315c00 R12: e5894855fa1e0ff3
> R13: ffff888173315c00 R14: ffffffff81f86ab0 R15: ffffe8ffffc7bc18
> FS:  0000000000000000(0000) GS:ffff88818d92d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: ffff888173315c00 CR3: 000000010b9a2000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 2 bytes skipped:
> * 28:   80 5b 31 73             sbbb   $0x73,0x31(%rbx) <-- trapping inst=
ruction
>   2c:   81 88 ff ff 00 00 00    orl    $0x0,0xffff(%rax)
>   33:   00 00 00
>
>
> ***
>
> WARNING in mntput_no_expire_slowpath
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      75b0a6db4300e4c2c9e97a0848deaa7acfb42fb7
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/187f4142-010e-469f-b2d4-8ce60c1dd=
2c5/config
> syz repro: https://ci.syzbot.org/findings/f322b4d1-7f66-454a-80ff-6ed13eb=
274aa/syz_repro
>
> ------------[ cut here ]------------
> count < 0
> WARNING: fs/namespace.c:1353 at mntput_no_expire_slowpath+0x845/0xbf0 fs/=
namespace.c:1353, CPU#1: syz.0.20/5861
> Modules linked in:
> CPU: 1 UID: 0 PID: 5861 Comm: syz.0.20 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:mntput_no_expire_slowpath+0x845/0xbf0 fs/namespace.c:1353
> Code: 01 00 00 00 bf 08 00 00 00 48 c7 c2 c0 48 ce 8e e8 a0 18 39 ff e9 4=
7 fc ff ff e8 36 4e 72 ff e9 4a fa ff ff e8 2c 4e 72 ff 90 <0f> 0b 90 e9 68=
 fa ff ff e8 1e 4e 72 ff e8 69 83 fe ff e8 64 f7 ff
> RSP: 0018:ffffc90003cdfba0 EFLAGS: 00010293
> RAX: ffffffff8254bf34 RBX: dffffc0000000000 RCX: ffff888113571e00
> RDX: 0000000000000000 RSI: 00000000ffffffff RDI: 0000000000000000
> RBP: ffffc90003cdfc88 R08: ffffffff8254cacc R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff8e814988 R12: ffff8881016c3600
> R13: 0000000000000003 R14: 00000000ffffffff R15: 0000000000000002
> FS:  00007fa12e5946c0(0000) GS:ffff8882a8f2d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000555579145a28 CR3: 0000000176282000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  mntput fs/namespace.c:1421 [inline]
>  cleanup_mnt+0x30c/0x460 fs/namespace.c:1313
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  exit_task_work include/linux/task_work.h:40 [inline]
>  do_exit+0x73a/0x2360 kernel/exit.c:1009
>  __do_sys_exit kernel/exit.c:1119 [inline]
>  __se_sys_exit kernel/exit.c:1117 [inline]
>  __x64_sys_exit+0x40/0x40 kernel/exit.c:1117
>  x64_sys_call+0x18b4/0x18d0 arch/x86/include/generated/asm/syscalls_64.h:=
61
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa12d79e0d9
> Code: Unable to access opcode bytes at 0x7fa12d79e0af.
> RSP: 002b:00007fa12e593fd8 EFLAGS: 00000246 ORIG_RAX: 000000000000003c
> RAX: ffffffffffffffda RBX: 00007fa12da25fa0 RCX: 00007fa12d79e0d9
> RDX: 00007fa12e5949c8 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 00007fa12d835024 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fa12da26038 R14: 00007fa12da25fa0 R15: 00007ffe0f572ca8
>  </TASK>
>
>
> ***
>
> kernel BUG in free_percpu
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      75b0a6db4300e4c2c9e97a0848deaa7acfb42fb7
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/187f4142-010e-469f-b2d4-8ce60c1dd=
2c5/config
> syz repro: https://ci.syzbot.org/findings/40ff44c7-989e-4e59-a57c-7d669c0=
abd76/syz_repro
>
> ------------[ cut here ]------------
> kernel BUG at mm/vmalloc.c:835!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 3326 Comm: kworker/u9:4 Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: events_unbound bpf_map_free_deferred
> RIP: 0010:vmalloc_to_page+0x67c/0x6b0 mm/vmalloc.c:835
> Code: 51 fb ff ff e8 b5 a8 a2 ff 42 80 7c 2d 00 00 0f 85 5c fb ff ff e9 5=
f fb ff ff e8 9f a8 a2 ff e9 ae fb ff ff e8 95 a8 a2 ff 90 <0f> 0b e8 8d a8=
 a2 ff e9 64 fa ff ff e8 83 a8 a2 ff 48 b8 00 00 00
> RSP: 0018:ffffc90000007cc0 EFLAGS: 00010246
> RAX: ffffffff822464cb RBX: 5440ddc2e3d42741 RCX: ffff888110ad5a00
> RDX: 0000000000000100 RSI: 0000000000000100 RDI: ffffc90000000000
> RBP: ffffe8fee467b538 R08: 0000000000000100 R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff81f86890 R12: 0000000000a881bb
> R13: dffffc0000000000 R14: ffffc90000000000 R15: ffffffff8e946000
> FS:  0000000000000000(0000) GS:ffff88818d92d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000100000000 CR3: 000000001c4e4000 CR4: 00000000000006f0
> Call Trace:
>  <IRQ>
>  pcpu_addr_to_page mm/percpu-vm.c:373 [inline]
>  pcpu_chunk_addr_search mm/percpu.c:1612 [inline]
>  free_percpu+0x1fa/0xfe0 mm/percpu.c:2246
>  free_one kernel/bpf/memalloc.c:262 [inline]
>  free_all kernel/bpf/memalloc.c:275 [inline]
>  __free_final_rcu+0x151/0x210 kernel/bpf/memalloc.c:287
>  rcu_do_batch kernel/rcu/tree.c:2645 [inline]
>  rcu_core+0x794/0x10b0 kernel/rcu/tree.c:2897
>  handle_softirqs+0x226/0x860 kernel/softirq.c:645
>  __do_softirq kernel/softirq.c:679 [inline]
>  invoke_softirq kernel/softirq.c:519 [inline]
>  __irq_exit_rcu+0xcb/0x220 kernel/softirq.c:767
>  irq_exit_rcu+0x9/0x30 kernel/softirq.c:784
>  instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062 [inli=
ne]
>  sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1062
>  </IRQ>
>  <TASK>
>  asm_sysvec_apic_timer_interrupt+0x1a/0x20 arch/x86/include/asm/idtentry.=
h:674
> RIP: 0010:lock_acquire+0x222/0x350 kernel/locking/lockdep.c:5890
> Code: ff ff ff e8 f0 43 34 0a f7 44 24 08 00 02 00 00 0f 84 39 ff ff ff 6=
5 48 8b 05 42 8f cc 11 48 3b 44 24 58 75 33 fb 48 83 c4 60 <5b> 41 5c 41 5d=
 41 5e 41 5f 5d c3 cc cc cc cc cc 48 8d 3d d7 e1 b8
> RSP: 0018:ffffc90006dc77e8 EFLAGS: 00000286
> RAX: b973d41dfa964800 RBX: 0000000000000000 RCX: 8000000000000001
> RDX: 00000000fa315d19 RSI: ffffffff8e4d8901 RDI: ffffffff8c4cd780
> RBP: ffffffff823e19a8 R08: ffffffff823e19a8 R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff8eb5a1e0 R12: 0000000000000002
> R13: ffffffff8eb5a1e0 R14: 0000000000000000 R15: 0000000000000246
>  rcu_lock_acquire include/linux/rcupdate.h:300 [inline]
>  rcu_read_lock include/linux/rcupdate.h:840 [inline]
>  get_non_dying_memcg_start mm/memcontrol.c:817 [inline]
>  mod_memcg_state+0x64/0x190 mm/memcontrol.c:879
>  account_kmem_nmi_safe mm/memcontrol.c:3057 [inline]
>  obj_cgroup_uncharge_pages mm/memcontrol.c:3073 [inline]
>  __refill_obj_stock+0x559/0x6c0 mm/memcontrol.c:3459
>  __memcg_slab_free_hook+0x2bc/0x470 mm/memcontrol.c:3649
>  memcg_slab_free_hook mm/slub.c:2475 [inline]
>  slab_free mm/slub.c:6374 [inline]
>  kfree+0x3d6/0x640 mm/slub.c:6692
>  free_one kernel/bpf/memalloc.c:264 [inline]
>  free_all kernel/bpf/memalloc.c:275 [inline]
>  drain_mem_cache+0x643/0x8e0 kernel/bpf/memalloc.c:653
>  bpf_mem_alloc_destroy+0x142/0x550 kernel/bpf/memalloc.c:766
>  trie_free+0x134/0x160 kernel/bpf/lpm_trie.c:652
>  bpf_map_free+0x19d/0x3f0 kernel/bpf/syscall.c:896
>  process_one_work kernel/workqueue.c:3322 [inline]
>  process_scheduled_works+0xa88/0x14c0 kernel/workqueue.c:3405
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:vmalloc_to_page+0x67c/0x6b0 mm/vmalloc.c:835
> Code: 51 fb ff ff e8 b5 a8 a2 ff 42 80 7c 2d 00 00 0f 85 5c fb ff ff e9 5=
f fb ff ff e8 9f a8 a2 ff e9 ae fb ff ff e8 95 a8 a2 ff 90 <0f> 0b e8 8d a8=
 a2 ff e9 64 fa ff ff e8 83 a8 a2 ff 48 b8 00 00 00
> RSP: 0018:ffffc90000007cc0 EFLAGS: 00010246
> RAX: ffffffff822464cb RBX: 5440ddc2e3d42741 RCX: ffff888110ad5a00
> RDX: 0000000000000100 RSI: 0000000000000100 RDI: ffffc90000000000
> RBP: ffffe8fee467b538 R08: 0000000000000100 R09: 0000000000000000
> R10: 0000000000000000 R11: ffffffff81f86890 R12: 0000000000a881bb
> R13: dffffc0000000000 R14: ffffc90000000000 R15: ffffffff8e946000
> FS:  0000000000000000(0000) GS:ffff88818d92d000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000100000000 CR3: 000000000e946000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 3 bytes skipped:
>    0:   e8 f0 43 34 0a          call   0xa3443f5
>    5:   f7 44 24 08 00 02 00    testl  $0x200,0x8(%rsp)
>    c:   00
>    d:   0f 84 39 ff ff ff       je     0xffffff4c
>   13:   65 48 8b 05 42 8f cc    mov    %gs:0x11cc8f42(%rip),%rax        #=
 0x11cc8f5d
>   1a:   11
>   1b:   48 3b 44 24 58          cmp    0x58(%rsp),%rax
>   20:   75 33                   jne    0x55
>   22:   fb                      sti
>   23:   48 83 c4 60             add    $0x60,%rsp
> * 27:   5b                      pop    %rbx <-- trapping instruction
>   28:   41 5c                   pop    %r12
>   2a:   41 5d                   pop    %r13
>   2c:   41 5e                   pop    %r14
>   2e:   41 5f                   pop    %r15
>   30:   5d                      pop    %rbp
>   31:   c3                      ret
>   32:   cc                      int3
>   33:   cc                      int3
>   34:   cc                      int3
>   35:   cc                      int3
>   36:   cc                      int3
>   37:   48                      rex.W
>   38:   8d                      .byte 0x8d
>   39:   3d                      .byte 0x3d
>   3a:   d7                      xlat   %ds:(%rbx)
>   3b:   e1 b8                   loope  0xfffffff5
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [andrii@kernel.org ast@kernel.org bpf@vger.kernel.org daniel@iogearbox.ne=
t eddyz87@gmail.com emil@etsalapatis.com ihor.solodrai@linux.dev jolsa@kern=
el.org linux-kernel@vger.kernel.org martin.lau@linux.dev memxor@gmail.com p=
ulehui@huawei.com pulehui@huaweicloud.com song@kernel.org yonghong.song@lin=
ux.dev]
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
-upstream-moderation/6a8f080c.1d9ded08.62e62.00b4.GAE%40google.com.
