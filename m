Received: from mail-oo1-f41.google.com (mail-oo1-f41.google.com [209.85.161.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D08FB145A05
	for <syzbot@lists.linux.dev>; Thu, 11 Sep 2025 06:56:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757573792; cv=none; b=rZvFSYtMZVurd4wUoqu1SM32YQcYrbLSy/ky6YZSfezi75y9lMRyOsUV8n3rIPbFId5YmjnhjDjDnYVSOj2mrVgskUixe/f33hlUGB5WRzqFLx9YhUywqC7r4ZhIl0VgGuScxlAejb/EK0OnUOTJ8FQQOC5H1KPHF73q0nG/euU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757573792; c=relaxed/simple;
	bh=8/MJg+Vhw9PTO3njQdGEAuNuv2oNLndEKmJUoba2DWc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=H79Cqiqn3OEe1CpXpyvnsa5GhvEB1omHJGRHw04hgmuRQFeTENmWjBYU0BmldhZ6WnK/rYjzT09gw7gmoC3jOU41HLOfx7kXNEZnJLBm+xWmxnxZJ9A6oQePiPbLbSorj0f1V6mpR/BGpnlkurwsI4Opx4eLeSjRe5NUZ630SiU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=tHCwoPKe; arc=none smtp.client-ip=209.85.161.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="tHCwoPKe"
Received: by mail-oo1-f41.google.com with SMTP id 006d021491bc7-61e74d0539bso66000eaf.3
        for <syzbot@lists.linux.dev>; Wed, 10 Sep 2025 23:56:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1757573790; x=1758178590; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=A59dA2iZgW8AEg1YAtQ0cv/PnrQ5XwHKiQNc5gS/HXM=;
        b=tHCwoPKe+9TlxXwUYF5rJBAOrIi+l3jh9gA9vUAkt0AuUtVlaizsz3fxyKhZDkrz3Z
         78uJaun1dHdo+S1btME/UZxqEqiqn3DqXGxxNLOwA5qehtDx4cnMe4kyHQeL17dx5PwB
         lEVTxtTqGq9FXJCLVUwKVRfh/nwc1WM45cU6DI/QASDZ1gD4x6lsea6yppjnq4PVSec3
         LWC3fxrr7kZej4TkZCjHqtXyNRO3h0zcgb7hqUmEREkRkWHcL1tyU6UpZDUQ+4RyGol/
         Ec/t5Fogz37037HpEZzibZueJNIeIkCzAN/0USQ4ORx0DNpKfNIMH9rKHyKE5PNbmaus
         JNVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757573790; x=1758178590;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=A59dA2iZgW8AEg1YAtQ0cv/PnrQ5XwHKiQNc5gS/HXM=;
        b=DYhf/R8OwAWT+pvXl8ViF05Q26twSBWyp9wPY2Aw4fXJ8bH1TLutk5FR4xhd774B5G
         8x2GuYggWCtEZAewD9JMGn/K9s8ibXPlhoCcP9bAO9T2gLvl3XeNW7lydyfS3K1XrJYG
         iwCXxnWXtajFioJHDSf4lwL5WhI1V79/1ztxmoyZiGLpNLhyOWao/7K2Nn7wQFL8eeo9
         qtui5huhC4TPS7bQopQ5VPN2iRHvqZcOg89dDEH5wKLf503yquuMhsyZeI0Reaa8bnPJ
         MkbXqzpuWeIoJv5l0epJMriWxHsnjm6RB9Z+sjpFZuNeMljP9x4Y64LpptlZC0yasxQ0
         0vog==
X-Forwarded-Encrypted: i=1; AJvYcCVAv1EO7S51sa8oC4pKn4ro2q5Qwci24LIpMkk9EwAi0s2M3iNybiNttbMqlIGZluHEinyBF5U=@lists.linux.dev
X-Gm-Message-State: AOJu0YzJfMJobg4giaeXxtkI6or3YTNEupGMIl+XJ1OKkgpkWirwJnQq
	F3DF/41l0Qq66NffwNUYWZr8xtfYpCgPZnc4v2xYCdBio62G4iPxzzqZ7lXX5Vj7liCEPDtkkqy
	m1OXKfZCOdaC2Y709V2nc3+VoGnbkUKFbXFOHlSIL
X-Gm-Gg: ASbGncsI9mScxSKraY5MvibINqzgCS9f4f9uh1XxIwgZsxiMyrQmkyIQP6yvuxXwfGo
	gcbSFN/ntJHsdeCj/9ykuYDan0xwBb0ylTWJfCHjY/8lVgqF7a6F42PetbiFvYRTgrXylv6v+ep
	S9vo8Fxt1bTSBFDgMhYNOLaOfVxzfr9x/17xPznQ9OQ1fruuVbUKOfvV2Oqn64T7cozbddWPZba
	bhav/tecmvSHTapgw1PkJvq9vfkk+yyIB5wARtOU5Xd1mwplz4X8OY14A==
X-Google-Smtp-Source: AGHT+IGHfxA2UnVWc0uxHynUdZ6XmGfXm7KlxbOyX2PcYVyvnIEidYR+fPmGb4/pWUEVU0FN0hJoSSakB5kSy0bk4YM=
X-Received: by 2002:a05:6820:1687:b0:621:703e:a65f with SMTP id
 006d021491bc7-62178a81363mr7796467eaf.5.1757573789449; Wed, 10 Sep 2025
 23:56:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68c2553d.050a0220.2ff435.0020.GAE@google.com>
In-Reply-To: <68c2553d.050a0220.2ff435.0020.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 11 Sep 2025 08:56:18 +0200
X-Gm-Features: Ac12FXys6Gjk6AYCwrMBbVUz16gLY6MTY5OQZZnxQoYeBSZcW5bMm-xsRp4r5T0
Message-ID: <CANp29Y4PJNZj=NyYm-44K47Tff3o3k8dNAT5mVqre3==7FdrNQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: replace path-sensitive with
 path-insensitive live stack analysis
To: syzbot ci <syzbot+cidc36f88185e99d4b@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Sep 11, 2025 at 6:51=E2=80=AFAM syzbot ci
<syzbot+cidc36f88185e99d4b@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] bpf: replace path-sensitive with path-insensitive live stack analysi=
s
> https://lore.kernel.org/all/20250911010437.2779173-1-eddyz87@gmail.com
> * [PATCH bpf-next v1 01/10] bpf: bpf_verifier_state->cleaned flag instead=
 of REG_LIVE_DONE
> * [PATCH bpf-next v1 02/10] bpf: use compute_live_registers() info in cle=
an_func_state
> * [PATCH bpf-next v1 03/10] bpf: remove redundant REG_LIVE_READ check in =
stacksafe()
> * [PATCH bpf-next v1 04/10] bpf: declare a few utility functions as inter=
nal api
> * [PATCH bpf-next v1 05/10] bpf: compute instructions postorder per subpr=
ogram
> * [PATCH bpf-next v1 06/10] bpf: callchain sensitive stack liveness track=
ing using CFG
> * [PATCH bpf-next v1 07/10] bpf: enable callchain sensitive stack livenes=
s tracking
> * [PATCH bpf-next v1 08/10] bpf: signal error if old liveness is more con=
servative than new
> * [PATCH bpf-next v1 09/10] bpf: disable and remove registers chain based=
 liveness
> * [PATCH bpf-next v1 10/10] bpf: table based bpf_insn_successors()
>
> and found the following issue:
> KASAN: slab-out-of-bounds Write in compute_postorder
>
> Full report is available here:
> https://ci.syzbot.org/series/c42e236b-f40c-4d72-8ae7-da4e21c37e17
>
> ***
>
> KASAN: slab-out-of-bounds Write in compute_postorder
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      e12873ee856ffa6f104869b8ea10c0f741606f13
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/6d2bc952-3d65-4bcd-9a84-1207b810a=
1b5/config
> C repro:   https://ci.syzbot.org/findings/338e6ce4-7207-484f-a508-9b00b31=
21701/c_repro
> syz repro: https://ci.syzbot.org/findings/338e6ce4-7207-484f-a508-9b00b31=
21701/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-out-of-bounds in compute_postorder+0x802/0xcb0 kernel/bp=
f/verifier.c:17840
> Write of size 4 at addr ffff88801f1d4b98 by task syz.0.17/5991
>
> CPU: 0 UID: 0 PID: 5991 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250 lib/dump_stack.c:120
>  print_address_description mm/kasan/report.c:378 [inline]
>  print_report+0xca/0x240 mm/kasan/report.c:482
>  kasan_report+0x118/0x150 mm/kasan/report.c:595
>  compute_postorder+0x802/0xcb0 kernel/bpf/verifier.c:17840
>  bpf_check+0x1f90/0x1d440 kernel/bpf/verifier.c:24437
>  bpf_prog_load+0x1318/0x1930 kernel/bpf/syscall.c:2979
>  __sys_bpf+0x528/0x870 kernel/bpf/syscall.c:6029
>  __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f366058eba9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffef8486b28 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f36607d5fa0 RCX: 00007f366058eba9
> RDX: 0000000000000070 RSI: 0000200000000440 RDI: 0000000000000005
> RBP: 00007f3660611e19 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f36607d5fa0 R14: 00007f36607d5fa0 R15: 0000000000000003
>  </TASK>
>
> Allocated by task 5991:
>  kasan_save_stack mm/kasan/common.c:47 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:68
>  poison_kmalloc_redzone mm/kasan/common.c:388 [inline]
>  __kasan_kmalloc+0x93/0xb0 mm/kasan/common.c:405
>  kasan_kmalloc include/linux/kasan.h:260 [inline]
>  __do_kmalloc_node mm/slub.c:4365 [inline]
>  __kvmalloc_node_noprof+0x30d/0x5f0 mm/slub.c:5052
>  kvmalloc_array_node_noprof include/linux/slab.h:1065 [inline]
>  compute_postorder+0xd6/0xcb0 kernel/bpf/verifier.c:17823
>  bpf_check+0x1f90/0x1d440 kernel/bpf/verifier.c:24437
>  bpf_prog_load+0x1318/0x1930 kernel/bpf/syscall.c:2979
>  __sys_bpf+0x528/0x870 kernel/bpf/syscall.c:6029
>  __do_sys_bpf kernel/bpf/syscall.c:6139 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6137 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6137
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> The buggy address belongs to the object at ffff88801f1d4b80
>  which belongs to the cache kmalloc-cg-32 of size 32
> The buggy address is located 0 bytes to the right of
>  allocated 24-byte region [ffff88801f1d4b80, ffff88801f1d4b98)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff88801f1d=
4e40 pfn:0x1f1d4
> memcg:ffff888026bbb801
> flags: 0xfff00000000000(node=3D0|zone=3D1|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 00fff00000000000 ffff88801a449b40 dead000000000100 dead000000000122
> raw: ffff88801f1d4e40 000000008040003f 00000000f5000000 ffff888026bbb801
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 0, migratetype Unmovable, gfp_mask 0x52cc0(=
GFP_KERNEL|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP), pid 532, tgid 532 (kwork=
er/u10:0), ts 5351847364, free_ts 0
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x240/0x2a0 mm/page_alloc.c:1851
>  prep_new_page mm/page_alloc.c:1859 [inline]
>  get_page_from_freelist+0x21e4/0x22c0 mm/page_alloc.c:3858
>  __alloc_frozen_pages_noprof+0x181/0x370 mm/page_alloc.c:5148
>  alloc_pages_mpol+0x232/0x4a0 mm/mempolicy.c:2416
>  alloc_slab_page mm/slub.c:2487 [inline]
>  allocate_slab+0x8a/0x370 mm/slub.c:2655
>  new_slab mm/slub.c:2709 [inline]
>  ___slab_alloc+0xbeb/0x1410 mm/slub.c:3891
>  __slab_alloc mm/slub.c:3981 [inline]
>  __slab_alloc_node mm/slub.c:4056 [inline]
>  slab_alloc_node mm/slub.c:4217 [inline]
>  __do_kmalloc_node mm/slub.c:4364 [inline]
>  __kmalloc_noprof+0x305/0x4f0 mm/slub.c:4377
>  kmalloc_noprof include/linux/slab.h:909 [inline]
>  kzalloc_noprof include/linux/slab.h:1039 [inline]
>  lsm_blob_alloc security/security.c:684 [inline]
>  lsm_cred_alloc security/security.c:701 [inline]
>  security_prepare_creds+0x52/0x390 security/security.c:3271
>  prepare_kernel_cred+0x2ee/0x500 kernel/cred.c:617
>  call_usermodehelper_exec_async+0xd0/0x360 kernel/umh.c:88
>  ret_from_fork+0x3fc/0x770 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> page_owner free stack trace missing
>
> Memory state around the buggy address:
>  ffff88801f1d4a80: fa fb fb fb fc fc fc fc 00 00 00 fc fc fc fc fc
>  ffff88801f1d4b00: 00 00 00 fc fc fc fc fc fa fb fb fb fc fc fc fc
> >ffff88801f1d4b80: 00 00 00 fc fc fc fc fc fa fb fb fb fc fc fc fc
>                             ^
>  ffff88801f1d4c00: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
>  ffff88801f1d4c80: fa fb fb fb fc fc fc fc fa fb fb fb fc fc fc fc
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
t eddyz87@gmail.com kernel-team@fb.com martin.lau@linux.dev yonghong.song@l=
inux.dev]
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
-upstream-moderation/68c2553d.050a0220.2ff435.0020.GAE%40google.com.
