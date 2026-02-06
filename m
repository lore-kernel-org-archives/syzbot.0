Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDE9030AABC
	for <syzbot@lists.linux.dev>; Fri,  6 Feb 2026 19:25:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.172
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770405949; cv=pass; b=j8JxcI9pEKUAly4iTo4FFD4+PdXDGPOscmlfKkUL6KYuQWhoPtyMLqyyJkGXQS4iEtGY/ktM4yRIvc8zk0t+pRIeE0IUtGCNcL8q6LaH0ND4PqMVwvQ2oAzVuaUWWdDUM5NAitN4uymURfThEeeYlSKfmQGrjA+xoUdthAFLr7k=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770405949; c=relaxed/simple;
	bh=mCXsjvVXW4xgZ7oqmZOlr3ZKX+tUWH0GkDgfVdEBvPU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=OlDCH5IOWUmFrsF6IpBdP1gfvKxTam8/S5g+GMWHIwWDz7XQwnsuV+cLxhi0LMC4F7CBagoOdyjjBmHxBUuvbl/n5Gk85q1toC8HGI3ZyJePLSSXKs2Q59JurYKPbWCQmjob2scLxNqm4aimWDmRnx+oPhZNlZ/aywOM8NScAlA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=nTyzbXpZ; arc=pass smtp.client-ip=209.85.167.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="nTyzbXpZ"
Received: by mail-oi1-f172.google.com with SMTP id 5614622812f47-45c7c841904so718148b6e.3
        for <syzbot@lists.linux.dev>; Fri, 06 Feb 2026 11:25:48 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770405948; cv=none;
        d=google.com; s=arc-20240605;
        b=kERpENrEeiMRAv/y4iBEvD3FG29d3QjrmIft+UPvXXrheImNwHByDYWUNQCdJJTcJU
         FrCh0QwuB4Z8YEJtzdfdf8r9/zp8RT/kG07Mbqgm/euNMDIlNJGqAyBH/IPehttk7rPx
         QiB/5O17XxPM4528FimeRE12HdgwuX/ax3wQCdmXsvP9jC98rsVTX3aCeihYCiFs++MB
         MB4U1FZhj3WQ376xEbLGB55dHY5If+oiw6gtlDcdFr+5jUpgrPAvIjQxtjAXYL5mVhN7
         c5wxWw/nQOWkCZ3gCzXTxrQFsrRJrZceVEJER2Redv9IYRfWBpXOQHQVtsjAkuYdy8PR
         3Hbw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=dwwIbn6zQ1QnWn/hlvxA4oqBV0H67K/oAY8ZqTP/MS8=;
        fh=9VyVJUCzvvTRqJfR09YgVeFW6GJf0fTIvUyQ+HfwANM=;
        b=E5hDe02+ozuzvpb0Bmamzx3S22TRr24pZFIVR5XfsYUbs4GEtLMK24nGh2wanI5UIm
         5innTGvtJ8Dru4NKVOz1JlAChy1yF0PyfwWmPy+vLB1MTnmo8b8etluE4yCgZa4zsBn4
         K6huGCpmT8aYX8Y4/X7N9qTGaTtfCebHsqToq8zeT7bpFBA1oNpb/x2KJUYLF3G2LS6C
         EnPcmbLbYEyZ4tTuCxjAKdYIMPqL89t+p3bzRZ1PeeLqEtCDsvwxdv9dlgq+ZJxjdY1o
         zQY90e0CLp7fS8Xew2o9I+CBHxuVRHWarE0oyZaiObGccSDWlx+jQxLo1SLQWcrhjpgO
         +ExQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770405948; x=1771010748; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=dwwIbn6zQ1QnWn/hlvxA4oqBV0H67K/oAY8ZqTP/MS8=;
        b=nTyzbXpZ9YHKyel5t+9K9P4MFlP7E+FbFEUHOXjre+UMoDwdQ6IymioC686UIxTHFg
         kbRSLbgrsTc7JI6in/PaR/3KkfqW7+o8BX3gfkeeVbK61ve+qpEjPvfBNjCBoo53Cdq2
         D1YjnMbtfH9q7oz+RGiAVKRuMcD6Z3ni3Jb75VrwDkJoRHtvi8ANWcJFUyREB+1HE091
         PWrW6IbT06Hh/IPOZCgpo1ZTinPtYNl29RU/6uzy1MkP1C/h2qqvG+Mzdcxjlz1PpzHU
         jiL2TadweRGs2cfROM4EmNnTlx7PYjqUCCNafUuMYjntgKMzuRJB+1H9EDtU+99cBqBg
         GOhw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770405948; x=1771010748;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=dwwIbn6zQ1QnWn/hlvxA4oqBV0H67K/oAY8ZqTP/MS8=;
        b=CSYig+p20uZ3L4CGdRZwbGSMriiB7tCR+t+MANNXQohUvU0EwUAVgRbYtTNI7I7+h7
         1iiqYzngGZ0zC+iplg/elsta9PQ5SSDRZZjUcgejQafyHJYIsULXX5d3l/bULruCB8XR
         4oEU9HcchkY9k5B3Fquc9nmYzuNl8RzF7Y4MxL+DJ/pG1BKpnXIKyt4xENGuo42sC7aB
         Zzq6fyd836Sib7EbtqsdjVjtZ0lLqW+/Qq9gJt8UjT8Hz0E4CJq9Yw0WQyeLXJMrkHCj
         MPC887KSccukXHnVlsfyfyjyWkGJSHeVWLqX1mtJEy8zkU9V5iK+GyOIw5ug5a4tIU0n
         wqQg==
X-Forwarded-Encrypted: i=1; AJvYcCUuVTCI2OEo5hniaa9jAdquF/4hYgDag+5xpQda2fPLU72o/+SmJujuvkSW55P/bLc28bxF9Tw=@lists.linux.dev
X-Gm-Message-State: AOJu0Yzbq+5AXFFiTLTjJglFoxNFBQK7JQC7hyvB1xjvnoe1vJuP9o/z
	KijlNCYi62lBC7EkToQyTpEiStztZEmArSHOcoeCzla4HTI20VaBenu0iqDc8BfmTqWMJVmBxuw
	WfFr7V0TAolTxG1ewPkwqdPfj8ThhpJHJVdKnJXaYJi7MQucPQcFNd8vU
X-Gm-Gg: AZuq6aIPtN0467ryDRtKVlzuYYMhQ/a8d7jZiTtU4+6ntJiuZ6mXMInAor8NaliKAPD
	SWth9Zh3mDol61uPhV4N6Kj7V3fZ65xZyeIbi0wP95d50uzwKaWDh9Uyt30TRuOA6ATIOX9nWLH
	5mbunOHcT2lj7xmHxA1uHBSeVxZF9uUVkteB+9cB3H/pVl2xoLFiQeSSgMC1yqngMfG4ABeFU9X
	6fDByMl5z49Nr1HbMqptVsxzOLSXZ0q2sLdJ1NXnrjuY2ezCd06kcyckTSL7CU1VqHLC+72rbyh
	QsezDzcF7FiUtbdg5amyKoQ6+Rxt+PQqR6bkjF3sXZrCdzIW3kdDXE8onaE=
X-Received: by 2002:a05:6808:1805:b0:462:d0cc:33b0 with SMTP id
 5614622812f47-462fcb5eeadmr2091759b6e.40.1770405947560; Fri, 06 Feb 2026
 11:25:47 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69862d8f.050a0220.3b3015.0043.GAE@google.com>
In-Reply-To: <69862d8f.050a0220.3b3015.0043.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 6 Feb 2026 20:25:36 +0100
X-Gm-Features: AZwV_Qg26ZlN7_jGn1TLZlYjBqo4m93A9-YbDGAMG6m0C9JbPBjPsYs7GFbb0dM
Message-ID: <CANp29Y6+FqXtOdnoeRbExvb0Yfh24bcSbayn3ZnLeWHG6A5vQw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: map maximum pages possible in finish_fault
To: syzbot ci <syzbot+ci1beb1ef26018f006@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Feb 6, 2026 at 7:06=E2=80=AFPM syzbot ci
<syzbot+ci1beb1ef26018f006@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm: map maximum pages possible in finish_fault
> https://lore.kernel.org/all/20260206135648.38164-1-dev.jain@arm.com
> * [PATCH] mm: map maximum pages possible in finish_fault
>
> and found the following issue:
> WARNING in folio_add_file_rmap_ptes
>
> Full report is available here:
> https://ci.syzbot.org/series/72be5e3b-2ee7-4758-9574-5c09e110d6d0
>
> ***
>
> WARNING in folio_add_file_rmap_ptes
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      7235a985b8126d891dbd4e7f20546ff3002b6363
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/7bf34a11-2b89-440d-9047-d9a8b7d52=
cbc/config
> C repro:   https://ci.syzbot.org/findings/b307b537-ffd9-403f-b188-852c8f3=
9be62/c_repro
> syz repro: https://ci.syzbot.org/findings/b307b537-ffd9-403f-b188-852c8f3=
9be62/syz_repro
>
> ------------[ cut here ]------------
> nr_pages <=3D 0
> WARNING: ./include/linux/rmap.h:349 at __folio_rmap_sanity_checks include=
/linux/rmap.h:349 [inline], CPU#0: syz.0.17/5977
> WARNING: ./include/linux/rmap.h:349 at __folio_add_rmap mm/rmap.c:1350 [i=
nline], CPU#0: syz.0.17/5977
> WARNING: ./include/linux/rmap.h:349 at __folio_add_file_rmap mm/rmap.c:16=
96 [inline], CPU#0: syz.0.17/5977
> WARNING: ./include/linux/rmap.h:349 at folio_add_file_rmap_ptes+0x98a/0xe=
60 mm/rmap.c:1722, CPU#0: syz.0.17/5977
> Modules linked in:
> CPU: 0 UID: 0 PID: 5977 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__folio_rmap_sanity_checks include/linux/rmap.h:349 [inline]
> RIP: 0010:__folio_add_rmap mm/rmap.c:1350 [inline]
> RIP: 0010:__folio_add_file_rmap mm/rmap.c:1696 [inline]
> RIP: 0010:folio_add_file_rmap_ptes+0x98a/0xe60 mm/rmap.c:1722
> Code: 0b 90 e9 4c f7 ff ff e8 84 d1 ab ff 48 89 df 48 c7 c6 e0 44 9a 8b e=
8 d5 3e 11 ff 90 0f 0b 90 e9 9d f7 ff ff e8 67 d1 ab ff 90 <0f> 0b 90 e9 b2=
 f7 ff ff e8 59 d1 ab ff 49 ff cf e9 ea f7 ff ff e8
> RSP: 0018:ffffc90003f675f0 EFLAGS: 00010293
> RAX: ffffffff8216c889 RBX: ffffea000412fa00 RCX: ffff8881170c3a80
> RDX: 0000000000000000 RSI: 00000000fb412000 RDI: 0000000000000001
> RBP: 00000000fb412000 R08: f888304bee000000 R09: 1ffffd4000825f46
> R10: dffffc0000000000 R11: fffff94000825f47 R12: dffffc0000000000
> R13: ffffea000412fa30 R14: ffffea000412fa00 R15: 0000000000104be8
> FS:  0000555589649500(0000) GS:ffff88818e324000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000000040 CR3: 0000000114846000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  set_pte_range+0x538/0x8a0 mm/memory.c:5526
>  finish_fault+0xec7/0x1290 mm/memory.c:5668
>  do_read_fault mm/memory.c:5808 [inline]
>  do_fault mm/memory.c:5938 [inline]
>  do_pte_missing+0x216f/0x3210 mm/memory.c:4479
>  handle_pte_fault mm/memory.c:6322 [inline]
>  __handle_mm_fault mm/memory.c:6460 [inline]
>  handle_mm_fault+0x1b8c/0x32b0 mm/memory.c:6629
>  do_user_addr_fault+0x75b/0x1340 arch/x86/mm/fault.c:1387
>  handle_page_fault arch/x86/mm/fault.c:1476 [inline]
>  exc_page_fault+0x6a/0xc0 arch/x86/mm/fault.c:1532
>  asm_exc_page_fault+0x26/0x30 arch/x86/include/asm/idtentry.h:618
> RIP: 0010:rep_movs_alternative+0x51/0x90 arch/x86/lib/copy_user_64.S:81
> Code: 84 00 00 00 00 00 0f 1f 00 48 8b 06 48 89 07 48 83 c6 08 48 83 c7 0=
8 83 e9 08 74 db 83 f9 08 73 e8 eb c5 eb 05 c3 cc cc cc cc <48> 8b 06 48 89=
 07 48 8d 47 08 48 83 e0 f8 48 29 f8 48 01 c7 48 01
> RSP: 0018:ffffc90003f67cf8 EFLAGS: 00010202
> RAX: 00007ffffffff001 RBX: 0000000000000050 RCX: 0000000000000050
> RDX: 0000000000000001 RSI: 0000200000000040 RDI: ffffc90003f67d60
> RBP: ffffc90003f67eb8 R08: ffffc90003f67daf R09: 1ffff920007ecfb5
> R10: dffffc0000000000 R11: fffff520007ecfb6 R12: dffffc0000000000
> R13: 0000000000000050 R14: ffffc90003f67d60 R15: 0000200000000040
>  copy_user_generic arch/x86/include/asm/uaccess_64.h:126 [inline]
>  raw_copy_from_user arch/x86/include/asm/uaccess_64.h:141 [inline]
>  _inline_copy_from_user include/linux/uaccess.h:185 [inline]
>  _copy_from_user+0x7a/0xb0 lib/usercopy.c:18
>  copy_from_user include/linux/uaccess.h:223 [inline]
>  copy_from_bpfptr_offset include/linux/bpfptr.h:53 [inline]
>  copy_from_bpfptr include/linux/bpfptr.h:59 [inline]
>  __sys_bpf+0x229/0x920 kernel/bpf/syscall.c:6137
>  __do_sys_bpf kernel/bpf/syscall.c:6274 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6272 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6272
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f4fb5d9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe24ca9848 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f4fb6015fa0 RCX: 00007f4fb5d9acb9
> RDX: 0000000000000050 RSI: 0000200000000040 RDI: 0000000000000000
> RBP: 00007f4fb5e08bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f4fb6015fac R14: 00007f4fb6015fa0 R15: 00007f4fb6015fa0
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   84 00                   test   %al,(%rax)
>    2:   00 00                   add    %al,(%rax)
>    4:   00 00                   add    %al,(%rax)
>    6:   0f 1f 00                nopl   (%rax)
>    9:   48 8b 06                mov    (%rsi),%rax
>    c:   48 89 07                mov    %rax,(%rdi)
>    f:   48 83 c6 08             add    $0x8,%rsi
>   13:   48 83 c7 08             add    $0x8,%rdi
>   17:   83 e9 08                sub    $0x8,%ecx
>   1a:   74 db                   je     0xfffffff7
>   1c:   83 f9 08                cmp    $0x8,%ecx
>   1f:   73 e8                   jae    0x9
>   21:   eb c5                   jmp    0xffffffe8
>   23:   eb 05                   jmp    0x2a
>   25:   c3                      ret
>   26:   cc                      int3
>   27:   cc                      int3
>   28:   cc                      int3
>   29:   cc                      int3
> * 2a:   48 8b 06                mov    (%rsi),%rax <-- trapping instructi=
on
>   2d:   48 89 07                mov    %rax,(%rdi)
>   30:   48 8d 47 08             lea    0x8(%rdi),%rax
>   34:   48 83 e0 f8             and    $0xfffffffffffffff8,%rax
>   38:   48 29 f8                sub    %rdi,%rax
>   3b:   48 01 c7                add    %rax,%rdi
>   3e:   48                      rex.W
>   3f:   01                      .byte 0x1
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
> [akpm@linux-foundation.org anshuman.khandual@arm.com david@kernel.org dev=
.jain@arm.com kirill@shutemov.name liam.howlett@oracle.com linux-kernel@vge=
r.kernel.org linux-mm@kvack.org lorenzo.stoakes@oracle.com mhocko@suse.com =
rppt@kernel.org ryan.roberts@arm.com surenb@google.com vbabka@suse.cz willy=
@infradead.org]
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
-upstream-moderation/69862d8f.050a0220.3b3015.0043.GAE%40google.com.
