Received: from mail-oi1-f179.google.com (mail-oi1-f179.google.com [209.85.167.179])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B8EB221540
	for <syzbot@lists.linux.dev>; Thu,  5 Feb 2026 15:42:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.179
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770306131; cv=pass; b=rTRf1oe5KZ+ldl05AAufFufIurdo2H4kgUweIqa3lWpngr3/MW36m7C/omLgUE+zygUStZHSbjCFUwhdqbkEwHXoxESLrQ15lxurg07FiAejMnNMJHJyg0gwlqioi26u0kkVmvPgkRgxOlgqG5m8VY1TsHwWN4PGZRnyTAEpao8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770306131; c=relaxed/simple;
	bh=2klTbe8WOLyPcsVgj2wk9z34cVIYzX1JVEqJ60K8ELA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=k8GPpJptWEOiBy+kI1qUImpMGYCTvxD72oAlGFyHorNd2mDIEGSXzMlR6j8ojekx01hMDgWYAjNBLU2OW8j08GSC8B3xRZdmVmMSRDGAouoY7Lt6VAtAkj2KSP1Tg+v1poXpoxXphl84fMVSavm5mN9VGPuDK3bjE3RYFfXzTJw=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=pBmDTjbn; arc=pass smtp.client-ip=209.85.167.179
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="pBmDTjbn"
Received: by mail-oi1-f179.google.com with SMTP id 5614622812f47-45eabce608dso745262b6e.2
        for <syzbot@lists.linux.dev>; Thu, 05 Feb 2026 07:42:11 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1770306130; cv=none;
        d=google.com; s=arc-20240605;
        b=EbjchZfLgIAlAgbyk60Te+lqJy6nFNST0I7mAlUARTW7ULk3DnigDKCZ+jtHbnHuxJ
         PogDQmSdvGGdBCQ7lXgUlYot4BtfIlbinV+qBf0OLn+benbHIP4ot5i7xHNyKYYjE44d
         HNQc7bNjDlZneZH6EvhZy8LI6SKiKSA/u9DZ+uUiU0w/ARD7fWXBgkfY97H/6fkEs3XO
         SZ/2SJsLCj0VPos14vZxGyBc3GsiHqbYH15BR6dT3DRikABh/vleSWhyta5gunR5tpkF
         a8YbeVTvAKzWt8WNlpNN70v0CVVa8UrbJpDz9ufvKNKkhlOSaqYZzcU7dhaGhRtefYwI
         7Jxg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Jmx5rwMREwxoApYdgIMD65n15ZyUm4OSCG/+s+D4frg=;
        fh=bZ2gTfKr5jRCt7pLd7fGHL7Wlq52PNJC5WldjnVHIXk=;
        b=ZDBxmaYmLJCv8mU/v6oWBq9xtt1vrgFOXQ7LgH6u+oJdQZcxjKoXTrhFFFQ4+9Co01
         KyRtCunOxH8US0I9mUIeBpZrFzCcxzVIkjRtvkyMuNuLHcnlEuuK9rJB4WWEPObAabgP
         hEuqcHkPgQhh0iIc2YEvLbl97Rx4v87f72loC5Ezh98MISnwxWiuMXPiz1F6la5mwLmO
         FVfqn5irVGh5nx9TkWfkqUd6iv4jg3WbiaEDwKY849OGDl7JE51KxAbU0rJJSky4uasd
         2epdiAVRKXqIFoAjv1kaf79nR9MbIeZ8FJRFgqtBXtciHtnzD/JPv2st79h8uTcVbRjk
         PjyA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1770306130; x=1770910930; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Jmx5rwMREwxoApYdgIMD65n15ZyUm4OSCG/+s+D4frg=;
        b=pBmDTjbnCjQQAoiIuKktum72PBZDFbnoAOu/j0mIbbglC5g5MYVCynn9WRRQOPRsgs
         64YFxbriNw4G0okvFqtLCwSqD7m+AJxuLs516QIJY+zlpvbNNKiRwRgjW+rgnFm6IXr2
         c0LmwcBYUCwXY/bVVExFaR3wyhQzEf0aRJrkzJv4eJ/BffnFLGzSZoFIWMRY5OBacqUf
         pq45fEmOyDoZYAiInokcO4oOEAL1jMzeO0+aF7a3QAUYUj9OQ1E75iHFpG3QEGz+jym4
         OhfSTon6AAPPmq7ddyBHlnbbno4+tokJ2aAx/8E0AwzO7Vxu76PSkvOIrg3zOKVIRYlG
         LG2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1770306130; x=1770910930;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Jmx5rwMREwxoApYdgIMD65n15ZyUm4OSCG/+s+D4frg=;
        b=ZdswtZ9j3NQzt5/OR09NAMr1MLlPnSvJuERzu1JWxBzlzJFXGSQZzTxVcS7wpyDwsr
         KQlPycd+/xy8FSakLgxFJrlVxjutP1FQxlPtOOvARBQuEp6Ol1t0zcy/k9YQUJk06USD
         Pc9mXgwDkmFaeQtGEJwGeWyke2EEvT5qwAR8A8N69ZxfabdZ+vZlzi2mm7kqlNtGibOC
         Ye3T4Rls5HBEdqXq4xwaa9s1zQ4f8bIRiZGo4sRgs7IulZN5AjNTaly5Ihfmh2i98zKL
         iu0aEfhwTbqVCmAx0FDRiQLje3+hnbVC3KSd71jjleXQwvBZoKQ04AdzrAPXXS/r+Spe
         aidA==
X-Forwarded-Encrypted: i=1; AJvYcCV/bBizpL0UPrCWaw06JOEVIjUHksZ0EnYhOUbQvGHOee5XqE1IxnKjEU+40cIGDiB1G2x3wAI=@lists.linux.dev
X-Gm-Message-State: AOJu0YzKLmBWGIU3U/1axWX0oIrfQCT2Ct7+4tpc27h72vuJvrfNX/k+
	9KYLdtsxX2m7CXiYH+Vh1JVAb4fG3Gwc6N4ZfezAGwlvSy6MPso2OE445PH+G1IXmH+pw2zNPew
	V64EVnDlxqcd5C0uqqW626RIC8eN06R7Wo1+cPKL9
X-Gm-Gg: AZuq6aJQ+MVP83Q87iOx3l5rroh9wKwxmxiy6kZJNPZYFn3Z1pJ95aHc8ItJhW8hECz
	cjv+yJ5H9nuTg+Cle7FBziTY9oJkqr26eje+2zpx4164qzJGb8Ocr1Pj6fbNm20MIRWuVBasIwx
	yXVAmKcBWZWuRLFM/3APVV+4rdb543/Rm1BSyRC20VmC7Z/B6sApvKMH3eSzmQbbq8EWf/2rekp
	vzM+0PPhvDcsPau59GngNMeEnmEBZkob6ODzOXQULLjrRE/7OQG7Zkyuruj5dxZHNdRW87G7E+e
	o7hdupnpubzFfa8StHz+eoThM7x03gA5BNVEd8aOZbj7sGv2ybuLjtkGhA==
X-Received: by 2002:a05:6808:130d:b0:45e:9dc3:11ea with SMTP id
 5614622812f47-462d59c36d8mr3909588b6e.40.1770306129843; Thu, 05 Feb 2026
 07:42:09 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6984b3f7.050a0220.3b3015.0027.GAE@google.com>
In-Reply-To: <6984b3f7.050a0220.3b3015.0027.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 5 Feb 2026 16:41:58 +0100
X-Gm-Features: AZwV_QigBYFcsBaQKPRkfTcN7RNUK77SflLPQuFvcfr2KWxSbC9p-4D9wNYJ9iA
Message-ID: <CANp29Y4W8U6FvV5r9tC5ew_+1-=hymA9+zVKw8qL_QPLhsBLxQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: bpf: test_run: Fix the null pointer
 dereference issue in bpf_lwt_xmit_push_encap
To: syzbot ci <syzbot+ci9c843a30aacff4d1@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Feb 5, 2026 at 4:15=E2=80=AFPM syzbot ci
<syzbot+ci9c843a30aacff4d1@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] bpf: test_run: Fix the null pointer dereference issue in bpf_lwt_xmi=
t_push_encap
> https://lore.kernel.org/all/20260205092227.126665-1-yangfeng59949@163.com
> * [PATCH v2] bpf: test_run: Fix the null pointer dereference issue in bpf=
_lwt_xmit_push_encap
>
> and found the following issues:
> * WARNING in skb_dst_set
> * general protection fault in percpu_counter_add_batch
> * general protection fault in tnl_update_pmtu
> * general protection fault in xfrm_lookup_with_ifid
>
> Full report is available here:
> https://ci.syzbot.org/series/c278e614-0520-4be1-8e1b-b6ed06beb3cd
>
> ***
>
> WARNING in skb_dst_set
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      75cd3beb64d0977009e3d1a2d0c03715d3e5e156
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/8d5f34b6-d9df-4c4a-9d51-7f4f910f3=
79a/config
> C repro:   https://ci.syzbot.org/findings/9f4f73a7-44d6-4d8b-8fed-818bb8c=
a054d/c_repro
> syz repro: https://ci.syzbot.org/findings/9f4f73a7-44d6-4d8b-8fed-818bb8c=
a054d/syz_repro
>
> ------------[ cut here ]------------
> (skb->_skb_refdst & ~(1UL)) && !(skb->_skb_refdst & 1UL)
> WARNING: ./include/linux/skbuff.h:1171 at skb_dst_check_unset include/lin=
ux/skbuff.h:1170 [inline], CPU#1: syz.0.17/5978
> WARNING: ./include/linux/skbuff.h:1171 at skb_dst_set+0xfd/0x140 include/=
linux/skbuff.h:1217, CPU#1: syz.0.17/5978
> Modules linked in:
> CPU: 1 UID: 0 PID: 5978 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:skb_dst_check_unset include/linux/skbuff.h:1170 [inline]
> RIP: 0010:skb_dst_set+0xfd/0x140 include/linux/skbuff.h:1217
> Code: 2d 00 00 74 08 4c 89 f7 e8 80 13 98 f8 49 89 1e 48 83 c4 08 5b 41 5=
c 41 5d 41 5e 41 5f 5d c3 cc cc cc cc cc e8 64 5c 30 f8 90 <0f> 0b 90 e9 6d=
 ff ff ff 44 89 e1 80 e1 07 38 c1 7c 8f be 04 00 00
> RSP: 0018:ffffc90005367b58 EFLAGS: 00010293
> RAX: ffffffff89923bbc RBX: dffffc0000000001 RCX: ffff8881037d8000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 1ffff1102edaad5b R08: ffffffff8fced777 R09: 1ffffffff1f9daee
> R10: dffffc0000000000 R11: ffffffff817422b0 R12: 0000000000000000
> R13: ffff888176d56b01 R14: ffff888176d56ad8 R15: ffff888176d56a80
> FS:  0000555564e8a500(0000) GS:ffff8882a9928000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b2fe63fff CR3: 000000016852c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  bpf_prog_test_run_skb+0xe46/0x1ea0 net/bpf/test_run.c:1166
>  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4714
>  __sys_bpf+0x643/0x950 kernel/bpf/syscall.c:6236
>  __do_sys_bpf kernel/bpf/syscall.c:6331 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6329 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6329
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f51a119acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff3a40e428 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f51a1415fa0 RCX: 00007f51a119acb9
> RDX: 0000000000000050 RSI: 00002000000003c0 RDI: 000000000000000a
> RBP: 00007f51a1208bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f51a1415fac R14: 00007f51a1415fa0 R15: 00007f51a1415fa0
>  </TASK>
>
>
> ***
>
> general protection fault in percpu_counter_add_batch
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      75cd3beb64d0977009e3d1a2d0c03715d3e5e156
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/8d5f34b6-d9df-4c4a-9d51-7f4f910f3=
79a/config
> C repro:   https://ci.syzbot.org/findings/f58ed194-db04-464a-95de-a6d6cc4=
5527a/c_repro
> syz repro: https://ci.syzbot.org/findings/f58ed194-db04-464a-95de-a6d6cc4=
5527a/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000001b: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x00000000000000d8-0x00000000000000df]
> CPU: 1 UID: 0 PID: 5976 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:percpu_counter_add_batch+0x3e/0x1d0 lib/percpu_counter.c:98
> Code: d4 49 89 f5 48 89 fb 49 bf 00 00 00 00 00 fc ff df e8 e6 76 f2 fc 4=
8 89 5c 24 10 4c 8d 73 58 4c 89 f0 48 c1 e8 03 48 89 04 24 <42> 80 3c 38 00=
 74 08 4c 89 f7 e8 d3 2c 5a fd 49 8b 06 65 8b 28 41
> RSP: 0018:ffffc90003b37778 EFLAGS: 00010206
> RAX: 000000000000001b RBX: 0000000000000080 RCX: ffff888115b8ba80
> RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000080
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff52000766ee4 R12: 0000000000000020
> R13: ffffffffffffffff R14: 00000000000000d8 R15: dffffc0000000000
> FS:  000055555baf2500(0000) GS:ffff8882a9928000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffc74af2e38 CR3: 0000000115cec000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  dst_entries_add include/net/dst_ops.h:59 [inline]
>  dst_count_dec net/core/dst.c:162 [inline]
>  dst_release+0x126/0x1b0 net/core/dst.c:176
>  refdst_drop include/net/dst.h:266 [inline]
>  skb_dst_drop include/net/dst.h:278 [inline]
>  ____bpf_skb_set_tunnel_key net/core/filter.c:4867 [inline]
>  bpf_skb_set_tunnel_key+0x239/0xa30 net/core/filter.c:4835
>  bpf_prog_adb554717e5d6596+0x4f/0x5c
>  bpf_dispatcher_nop_func include/linux/bpf.h:1402 [inline]
>  __bpf_prog_run include/linux/filter.h:723 [inline]
>  bpf_prog_run include/linux/filter.h:730 [inline]
>  bpf_test_run+0x354/0x830 net/bpf/test_run.c:423
>  bpf_prog_test_run_skb+0xe02/0x1ea0 net/bpf/test_run.c:1164
>  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4714
>  __sys_bpf+0x643/0x950 kernel/bpf/syscall.c:6236
>  __do_sys_bpf kernel/bpf/syscall.c:6331 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6329 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6329
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fca1679acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffdef1739c8 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007fca16a15fa0 RCX: 00007fca1679acb9
> RDX: 0000000000000050 RSI: 0000200000000d80 RDI: 000000000000000a
> RBP: 00007fca16808bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fca16a15fac R14: 00007fca16a15fa0 R15: 00007fca16a15fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:percpu_counter_add_batch+0x3e/0x1d0 lib/percpu_counter.c:98
> Code: d4 49 89 f5 48 89 fb 49 bf 00 00 00 00 00 fc ff df e8 e6 76 f2 fc 4=
8 89 5c 24 10 4c 8d 73 58 4c 89 f0 48 c1 e8 03 48 89 04 24 <42> 80 3c 38 00=
 74 08 4c 89 f7 e8 d3 2c 5a fd 49 8b 06 65 8b 28 41
> RSP: 0018:ffffc90003b37778 EFLAGS: 00010206
> RAX: 000000000000001b RBX: 0000000000000080 RCX: ffff888115b8ba80
> RDX: 0000000000000000 RSI: ffffffffffffffff RDI: 0000000000000080
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff52000766ee4 R12: 0000000000000020
> R13: ffffffffffffffff R14: 00000000000000d8 R15: dffffc0000000000
> FS:  000055555baf2500(0000) GS:ffff8882a9928000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffc74af2e38 CR3: 0000000115cec000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 1 bytes skipped:
>    0:   49 89 f5                mov    %rsi,%r13
>    3:   48 89 fb                mov    %rdi,%rbx
>    6:   49 bf 00 00 00 00 00    movabs $0xdffffc0000000000,%r15
>    d:   fc ff df
>   10:   e8 e6 76 f2 fc          call   0xfcf276fb
>   15:   48 89 5c 24 10          mov    %rbx,0x10(%rsp)
>   1a:   4c 8d 73 58             lea    0x58(%rbx),%r14
>   1e:   4c 89 f0                mov    %r14,%rax
>   21:   48 c1 e8 03             shr    $0x3,%rax
>   25:   48 89 04 24             mov    %rax,(%rsp)
> * 29:   42 80 3c 38 00          cmpb   $0x0,(%rax,%r15,1) <-- trapping in=
struction
>   2e:   74 08                   je     0x38
>   30:   4c 89 f7                mov    %r14,%rdi
>   33:   e8 d3 2c 5a fd          call   0xfd5a2d0b
>   38:   49 8b 06                mov    (%r14),%rax
>   3b:   65 8b 28                mov    %gs:(%rax),%ebp
>   3e:   41                      rex.B
>
>
> ***
>
> general protection fault in tnl_update_pmtu
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      75cd3beb64d0977009e3d1a2d0c03715d3e5e156
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/8d5f34b6-d9df-4c4a-9d51-7f4f910f3=
79a/config
> C repro:   https://ci.syzbot.org/findings/2b87e46f-6cd5-4189-a1f4-896ea63=
e96a0/c_repro
> syz repro: https://ci.syzbot.org/findings/2b87e46f-6cd5-4189-a1f4-896ea63=
e96a0/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000000a: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
> CPU: 0 UID: 0 PID: 5994 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:skb_dst_update_pmtu_no_confirm include/net/dst.h:565 [inline]
> RIP: 0010:tnl_update_pmtu+0x52b/0x1190 net/ipv4/ip_tunnel.c:533
> Code: c1 e8 03 42 80 3c 38 00 74 08 48 89 df e8 0d 3a 2a f8 4c 8b 3b 49 8=
3 c7 50 4c 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74=
 08 4c 89 ff e8 e7 39 2a f8 4d 8b 3f 4d 85 ff 8b 5c
> RSP: 0018:ffffc90004ef6f68 EFLAGS: 00010206
> RAX: 000000000000000a RBX: ffffffff9a2dcec8 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: ffffffff9a2dcec0 RDI: 0000000000000000
> RBP: ffffffff9a2dcec0 R08: ffffffff89db11f3 R09: ffffffff8e35a3a0
> R10: ffffc90004ef6f20 R11: fffff520009dede6 R12: ffff888112583800
> R13: ffff888112583858 R14: 1ffff110224b070b R15: 0000000000000050
> FS:  000055557643a500(0000) GS:ffff88818e328000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30363fff CR3: 00000001744e0000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ip_tunnel_xmit+0xd36/0x2430 net/ipv4/ip_tunnel.c:805
>  __gre_xmit net/ipv4/ip_gre.c:490 [inline]
>  ipgre_xmit+0x8e6/0xc60 net/ipv4/ip_gre.c:694
>  __netdev_start_xmit include/linux/netdevice.h:5273 [inline]
>  netdev_start_xmit include/linux/netdevice.h:5282 [inline]
>  xmit_one net/core/dev.c:3853 [inline]
>  dev_hard_start_xmit+0x2cd/0x7f0 net/core/dev.c:3869
>  __dev_queue_xmit+0x14dd/0x32a0 net/core/dev.c:4819
>  dev_queue_xmit include/linux/netdevice.h:3381 [inline]
>  __bpf_tx_skb+0x18e/0x260 net/core/filter.c:2153
>  ____bpf_clone_redirect net/core/filter.c:2487 [inline]
>  bpf_clone_redirect+0x313/0x4b0 net/core/filter.c:2450
>  bpf_prog_885767c90d177146+0x62/0x6b
>  bpf_dispatcher_nop_func include/linux/bpf.h:1402 [inline]
>  __bpf_prog_run include/linux/filter.h:723 [inline]
>  bpf_prog_run include/linux/filter.h:730 [inline]
>  bpf_test_run+0x354/0x830 net/bpf/test_run.c:423
>  bpf_prog_test_run_skb+0xe02/0x1ea0 net/bpf/test_run.c:1164
>  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4714
>  __sys_bpf+0x643/0x950 kernel/bpf/syscall.c:6236
>  __do_sys_bpf kernel/bpf/syscall.c:6331 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6329 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6329
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fad0c59acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffe97cab158 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007fad0c815fa0 RCX: 00007fad0c59acb9
> RDX: 0000000000000028 RSI: 0000200000000080 RDI: 000000000000000a
> RBP: 00007fad0c608bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fad0c815fac R14: 00007fad0c815fa0 R15: 00007fad0c815fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:skb_dst_update_pmtu_no_confirm include/net/dst.h:565 [inline]
> RIP: 0010:tnl_update_pmtu+0x52b/0x1190 net/ipv4/ip_tunnel.c:533
> Code: c1 e8 03 42 80 3c 38 00 74 08 48 89 df e8 0d 3a 2a f8 4c 8b 3b 49 8=
3 c7 50 4c 89 f8 48 c1 e8 03 48 b9 00 00 00 00 00 fc ff df <80> 3c 08 00 74=
 08 4c 89 ff e8 e7 39 2a f8 4d 8b 3f 4d 85 ff 8b 5c
> RSP: 0018:ffffc90004ef6f68 EFLAGS: 00010206
> RAX: 000000000000000a RBX: ffffffff9a2dcec8 RCX: dffffc0000000000
> RDX: 0000000000000000 RSI: ffffffff9a2dcec0 RDI: 0000000000000000
> RBP: ffffffff9a2dcec0 R08: ffffffff89db11f3 R09: ffffffff8e35a3a0
> R10: ffffc90004ef6f20 R11: fffff520009dede6 R12: ffff888112583800
> R13: ffff888112583858 R14: 1ffff110224b070b R15: 0000000000000050
> FS:  000055557643a500(0000) GS:ffff88818e328000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30363fff CR3: 00000001744e0000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   c1 e8 03                shr    $0x3,%eax
>    3:   42 80 3c 38 00          cmpb   $0x0,(%rax,%r15,1)
>    8:   74 08                   je     0x12
>    a:   48 89 df                mov    %rbx,%rdi
>    d:   e8 0d 3a 2a f8          call   0xf82a3a1f
>   12:   4c 8b 3b                mov    (%rbx),%r15
>   15:   49 83 c7 50             add    $0x50,%r15
>   19:   4c 89 f8                mov    %r15,%rax
>   1c:   48 c1 e8 03             shr    $0x3,%rax
>   20:   48 b9 00 00 00 00 00    movabs $0xdffffc0000000000,%rcx
>   27:   fc ff df
> * 2a:   80 3c 08 00             cmpb   $0x0,(%rax,%rcx,1) <-- trapping in=
struction
>   2e:   74 08                   je     0x38
>   30:   4c 89 ff                mov    %r15,%rdi
>   33:   e8 e7 39 2a f8          call   0xf82a3a1f
>   38:   4d 8b 3f                mov    (%r15),%r15
>   3b:   4d 85 ff                test   %r15,%r15
>   3e:   8b                      .byte 0x8b
>   3f:   5c                      pop    %rsp
>
>
> ***
>
> general protection fault in xfrm_lookup_with_ifid
>
> tree:      bpf-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf-next.git
> base:      75cd3beb64d0977009e3d1a2d0c03715d3e5e156
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/8d5f34b6-d9df-4c4a-9d51-7f4f910f3=
79a/config
> C repro:   https://ci.syzbot.org/findings/5c4a2d70-b003-439e-8039-496b900=
9f1e9/c_repro
> syz repro: https://ci.syzbot.org/findings/5c4a2d70-b003-439e-8039-496b900=
9f1e9/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000000: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> CPU: 0 UID: 0 PID: 5985 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:xfrm_lookup_with_ifid+0xe1/0x1af0 net/xfrm/xfrm_policy.c:3181
> Code: 24 20 4d 8d 66 08 4c 89 e0 48 c1 e8 03 4d 89 ee 42 80 3c 28 00 74 0=
8 4c 89 e7 e8 ba 20 17 f8 4d 8b 24 24 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 30=
 84 c0 0f 85 94 17 00 00 41 0f b7 04 24 89 44 24 28
> RSP: 0018:ffffc90003e96fe0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffc90003e97080 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90003e97090
> RBP: ffffc90003e970f8 R08: ffffc90003e9708f R09: 0000000000000000
> R10: ffffc90003e97080 R11: fffff520007d2e12 R12: 0000000000000000
> R13: dffffc0000000000 R14: dffffc0000000000 R15: 0000000000000000
> FS:  000055558c0ab500(0000) GS:ffff88818e328000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30363fff CR3: 00000001b9fc8000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  xfrm_lookup net/xfrm/xfrm_policy.c:3336 [inline]
>  xfrm_lookup_route+0x3c/0x1c0 net/xfrm/xfrm_policy.c:3347
>  vti_xmit net/ipv4/ip_vti.c:217 [inline]
>  vti_tunnel_xmit+0x48e/0x18f0 net/ipv4/ip_vti.c:307
>  __netdev_start_xmit include/linux/netdevice.h:5273 [inline]
>  netdev_start_xmit include/linux/netdevice.h:5282 [inline]
>  xmit_one net/core/dev.c:3853 [inline]
>  dev_hard_start_xmit+0x2cd/0x7f0 net/core/dev.c:3869
>  __dev_queue_xmit+0x14dd/0x32a0 net/core/dev.c:4819
>  dev_queue_xmit include/linux/netdevice.h:3381 [inline]
>  __bpf_tx_skb+0x18e/0x260 net/core/filter.c:2153
>  ____bpf_clone_redirect net/core/filter.c:2487 [inline]
>  bpf_clone_redirect+0x313/0x4b0 net/core/filter.c:2450
>  bpf_prog_e16758452f539c38+0x5f/0x68
>  bpf_dispatcher_nop_func include/linux/bpf.h:1402 [inline]
>  __bpf_prog_run include/linux/filter.h:723 [inline]
>  bpf_prog_run include/linux/filter.h:730 [inline]
>  bpf_test_run+0x354/0x830 net/bpf/test_run.c:423
>  bpf_prog_test_run_skb+0xe02/0x1ea0 net/bpf/test_run.c:1164
>  bpf_prog_test_run+0x2c7/0x340 kernel/bpf/syscall.c:4714
>  __sys_bpf+0x643/0x950 kernel/bpf/syscall.c:6236
>  __do_sys_bpf kernel/bpf/syscall.c:6331 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6329 [inline]
>  __x64_sys_bpf+0x7c/0x90 kernel/bpf/syscall.c:6329
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe30af9acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fffa3d1a918 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007fe30b215fa0 RCX: 00007fe30af9acb9
> RDX: 000000000000002c RSI: 0000200000000080 RDI: 000000000000000a
> RBP: 00007fe30b008bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe30b215fac R14: 00007fe30b215fa0 R15: 00007fe30b215fa0
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:xfrm_lookup_with_ifid+0xe1/0x1af0 net/xfrm/xfrm_policy.c:3181
> Code: 24 20 4d 8d 66 08 4c 89 e0 48 c1 e8 03 4d 89 ee 42 80 3c 28 00 74 0=
8 4c 89 e7 e8 ba 20 17 f8 4d 8b 24 24 4c 89 e0 48 c1 e8 03 <42> 0f b6 04 30=
 84 c0 0f 85 94 17 00 00 41 0f b7 04 24 89 44 24 28
> RSP: 0018:ffffc90003e96fe0 EFLAGS: 00010246
> RAX: 0000000000000000 RBX: ffffc90003e97080 RCX: 0000000000000000
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffc90003e97090
> RBP: ffffc90003e970f8 R08: ffffc90003e9708f R09: 0000000000000000
> R10: ffffc90003e97080 R11: fffff520007d2e12 R12: 0000000000000000
> R13: dffffc0000000000 R14: dffffc0000000000 R15: 0000000000000000
> FS:  000055558c0ab500(0000) GS:ffff88818e328000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30363fff CR3: 00000001b9fc8000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   24 20                   and    $0x20,%al
>    2:   4d 8d 66 08             lea    0x8(%r14),%r12
>    6:   4c 89 e0                mov    %r12,%rax
>    9:   48 c1 e8 03             shr    $0x3,%rax
>    d:   4d 89 ee                mov    %r13,%r14
>   10:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1)
>   15:   74 08                   je     0x1f
>   17:   4c 89 e7                mov    %r12,%rdi
>   1a:   e8 ba 20 17 f8          call   0xf81720d9
>   1f:   4d 8b 24 24             mov    (%r12),%r12
>   23:   4c 89 e0                mov    %r12,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 0f b6 04 30          movzbl (%rax,%r14,1),%eax <-- trapping in=
struction
>   2f:   84 c0                   test   %al,%al
>   31:   0f 85 94 17 00 00       jne    0x17cb
>   37:   41 0f b7 04 24          movzwl (%r12),%eax
>   3c:   89 44 24 28             mov    %eax,0x28(%rsp)
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
> [bpf@vger.kernel.org davem@davemloft.net edumazet@google.com horms@kernel=
.org kuba@kernel.org linux-kernel@vger.kernel.org netdev@vger.kernel.org pa=
beni@redhat.com yangfeng59949@163.com]
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
-upstream-moderation/6984b3f7.050a0220.3b3015.0027.GAE%40google.com.
