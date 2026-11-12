Authentication-Results: smtp.subspace.kernel.org; arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.169
ARC-Seal: i=2; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=pass;
	t=1794468282;
	b=Ol2EG/CDYRh5pQj9M300/G40koVp6wG0LwC97vO4aGvx8tTb1OTRwLiaACSCbnfvYSA7
	 IQvKy3U9/d7TT+eTEuQcQo/ntnXeAoTYhB2+d+zTPsN1X6dpUFYWITdUc8sBiOr94VYQw
	 bhpTprZ/Oc08dqZW8pUxbBxaiYhOqzsbjbPm02XeR3j5PJXn9l8QN2Q4eAkZLfTDXJBOe
	 x9GScSPTltG9yN7lpCCgOWsxizlVf+LJlN7okRuyYyQa8qyB+jDvdczhGnCRJA90PLiDB
	 53RlL9P1nYnyj9EQRIgPXtD4Heeg4iF65S5/5jd9wCC9+dcPugdvWy4PQG8Q7jFnbbw==
ARC-Message-Signature: i=2; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794468282;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:
	 MIME-Version:References:In-Reply-To:From:Date:X-Gm-Features:
	 Message-ID:Subject:To:Cc:Content-Type:Content-Transfer-Encoding;
	bh=5pr1GrcDfX54W7S3eg954+tdID5F2MNLILr5jU3JX9U=;
	b=qGLJ675vb67r4iKocKcPd2hVba/PItOeqJYtW2C5bjc4QF8dRtkAEUuLgQeydQ3+3VwU
	 Urui5qF9g0zeYYknr7CGma0HWc4qrr4h9j+47+zMAmue/ybK0zsb59UHgvRWTOn4AyMg7
	 arbqVLmjto/Rjm+9fzRlhySAIm+DRJ+3GA9pjxgyqlnq8r0r2bZHDVLGgf4af/s/ALmcg
	 1WUpUAfTddlP89tQUtgYnCKFvs4TFvVkvd6flthISbxIpA8FWGts4L826YlALstECbjHf
	 uOaaHghsCQQNg1HtUqtT1X4HhS+zranGECtLFqja8+r4O45w/IlBW5i9cVhN1iyNkRg==
ARC-Authentication-Results: i=2; smtp.subspace.kernel.org; 
	dmarc=pass header.from=google.com;
	spf=pass smtp.mailfrom=google.com;
	dkim=pass header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hBHhpAPx;
	arc=pass header.oldest-pass=0 smtp.remote-ip=209.85.167.169
Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39BCD606A31C
	for <syzbot@lists.linux.dev>; Thu, 12 Nov 2026 07:24:42 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 39BCD606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=google.com header.i=@google.com header.a=rsa-sha256 header.s=20260707 header.b=hBHhpAPx
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-4f14642adb4so2156620b6e.1
        for <syzbot@lists.linux.dev>; Wed, 11 Nov 2026 23:24:41 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1794468281; cv=none;
        d=google.com; s=arc-20260327;
        b=cS19O9umVjxTa3x7EPW3GKsEi3vmp5VZOnr+piqXnQ14SfwGGzM+fZWraOZfnzqpy8
         E73vxLZ2q72dWoE6UL8CuNjYyhOC4rXLcF9qDpndfahWble8c69Ay0IkkJ4VdkHuBWYG
         7PbXXQJuyA6/ebC8lkx8aP1ZhW2LOLPT61v+Ror1bqHKJatycLKqRDuwv65P3rQWDSdD
         me7EBXFGYuySgjNei3pmpjWIXzc9I3mxl+ATSGRpzeFsdN7TdJQLv94fFefHBQl377Ef
         OlxXdpI0ikz9ymSPKgCulRXNHZxoa8yi/ep7bnztn4nR6c3l9tcBiqIyZLIIt43PUL98
         cCyQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=5pr1GrcDfX54W7S3eg954+tdID5F2MNLILr5jU3JX9U=;
        fh=8DJfbfadmkylvqEuieT9inUQ2nGYOo2acCHB6HwYxUI=;
        b=LdiNblv7O9wZL+CcCMp1t5+IfgBrfgvUFLZsAIaDWx5bG5pGpgwe79mmVXBD1BZRLq
         PEomcg/RxU+MrkRjq6Emp0nvqeRId6ZEAoFjl80jHxm8kSB9yGIZzonwTkB07EFwEdax
         xk5eyYnjNybChXrqL7k9EC/Tfe2gXB+yioO5U301oH7onTDvPkRma3iN0oy9G8DFrARI
         am+1vlZElVU/xx4k+APx9S0PPCCOaxuESWb9Z62wYK++mHBBcwhyezIglrRru0mgDbdD
         POpvi9hacUIDxc1vSWz6/fKLbevJgX5UZTn9WyNl93SE7BWtN17Em33MpIN1BNehV6tk
         nt6w==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20260707; t=1794468281; x=1795073081; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5pr1GrcDfX54W7S3eg954+tdID5F2MNLILr5jU3JX9U=;
        b=hBHhpAPxFl0LFrXmeYtHnrkBe6OT4Wv+xA4vtkaM9GUKgQ8Dtxqb8A5Ad+ARXl9kUK
         +7RP8XufIvr+B/JYUYJjLXfsXefBp7Kn9hVFMbz9sixGghNLhRzq1aiux6k02VzgcwXC
         xMTo7MuLpu2VfgFdbKd8YTHSQ6IGxM96aEea4kKbWmyENDNpAfW7Yobx+DkD61qofnEl
         pUlKTtK9mIMt0Fws5fvy4gf345kWpfEbQCXhfk0ojnhzr8zSCny+CVcEMdVrzVjR7Gsv
         2JTFkMFnfZR4Vt9M+UluIwiqbMe2PEXI+Z10WgqU1VCu4xpqWZw9uXH3nqlwKtAH52xh
         6ONg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794468281; x=1795073081;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5pr1GrcDfX54W7S3eg954+tdID5F2MNLILr5jU3JX9U=;
        b=ZnJm/BoTm4PWHW9bKLOkHbleJJBnxEV7aa9DARAwKX7O8ZWMGZmkvuADGzvPeA4BBW
         dmSuVK6H1m/5Yl9UNwZTQ8HarRfMnP/+2YhMN8w8ysbqZ2HRyAyHLfC3bv5fWSMMlvMv
         2jhmYl9rs9XAOtgMWgISiDm51RvXZP+Z30q5FRHM7aYbHDkU3fyU9btrkrxu0lDHBLN7
         IdwcunXVZIXPbJ0llW38bwm+5hc/pGUdJgttKtGYk5KTOP4b6wHEPbFCMifRttiJTKlB
         cOzw379jdymwy5N1bn0BMcM/N07Z0u1cc4TzTCluO7HqlACS1DrQO95z5wBCZo6RkL88
         r/wA==
X-Forwarded-Encrypted: i=1; AL+hErF/NDD8D5UGn6WWkMj/gz3t4p+YN+IY7L+4y47l8uYAIO7nZpp5zaq30AiAUpS0gArnIlfGzTc=@lists.linux.dev
X-Gm-Message-State: APuU4Z9J+m6fyt0I32HFwAama9z3WIu1Bjd9g+Cnohi9opTlX7brIc7l
	vIrNlEW3OYGASkpkE+S3ddqwmJDyrYNLKqeuvBgW9coWuc4euppRMO0R8hRY6kAkU7lMAEEV5LJ
	l+h6fu3M06Y63AJaSwBHIUr6mYiZ25zlKQTkp3S6G
X-Gm-Gg: AYBFou2m0TH04IQJFezW862zA0oiajDy81tqsVwuzkRH1idJJnuNYEyyB1RWFKTIuME
	I89oFm52uKyiFztltaus6cHIRcwEKjiT0eHE0vtFUbC7iChYhbSPFPZ9U1id2VJANAVx7ZrrvXC
	7NnADrykwIYQD3nTHcOTMIZ9wCdj/uLutK6W1r1hy61xsJd2eYkDwZlVkM4GOTrUg+QYRMiPeFs
	ElbeFghNeRbcFyg3XCphSSt508OXvIVdbEjoCHhORSo2KknEaeBhQsWQAHobUH4hFbubQKTJofS
	hhh2T8M5jB98xXA8+UxrydeF6is+/gCeF+045IGZuqf0QC5AoycGiduZzF9g37NgGJKFRGShsV5
	kq4oWRxWv9wi8t29hETdb3yEDERc0QP61/7DP4B8mWPcmvUtmKkaEbAZwb0hcHTLBX3xsGWJV2z
	MlXsputUe9GSo+dkL6E5Fq7aO8rS+qAN7NO6Q5OmT6XUS0lfZWgU6RtV5IJCQSmgGQoIY82ZyCD
	1xXHCsu
X-Received: by 2002:a05:6808:1910:b0:4dc:1374:99ae with SMTP id
 5614622812f47-56b97100c3emr4676958b6e.56.1794468280410; Wed, 11 Nov 2026
 23:24:40 -0800 (PST)
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
References: <6af520ef.4fb38a5b.96541.0002.GAE@google.com>
In-Reply-To: <6af520ef.4fb38a5b.96541.0002.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 12 Nov 2026 08:24:28 +0100
X-Gm-Features: AclHuK9fPuP8GDUE3_7uZzyeMrY66KNxkHCtlazeQOIMgSOHDQ2oO0FYkvuL1uk
Message-ID: <CANp29Y4GK=82yXZ8fWDmdeoX_Ss_kGUuc37jcUJoktF30KuHww@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm, swap: extendable swap devices (xswap
 phase I)
To: syzbot ci <syzbot+ci959f1a5b24994e7e@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Thu, Nov 12, 2026 at 3:14=E2=80=AFAM syzbot ci
<syzbot+ci959f1a5b24994e7e@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v5] mm, swap: extendable swap devices (xswap phase I)
> https://lore.kernel.org/all/20261109055455.536925-1-baoquan.he@linux.dev
> * [PATCH v5 01/19] mm: xswap support for zswap
> * [PATCH v5 02/19] mm, swap: refactor free_swap_cluster_info to take swap=
_info_struct
> * [PATCH v5 03/19] mm, swap: add VM_SPARSE cluster-array helpers for xswa=
p
> * [PATCH v5 04/19] mm, swap: use a VM_SPARSE cluster array for xswap devi=
ces
> * [PATCH v5 05/19] mm, swap: widen swap_info_struct max/pages to unsigned=
 long
> * [PATCH v5 06/19] mm, swap: add a sysfs interface to create xswap device=
s
> * [PATCH v5 07/19] mm, swap: refactor swapoff and add xswap_destroy
> * [PATCH v5 08/19] mm, swap: require zswap for xswap devices
> * [PATCH v5 09/19] mm, swap: use a stable id for xswap devices
> * [PATCH v5 10/19] mm, swap: let the command line set the xswap device si=
ze
> * [PATCH v5 11/19] mm, swap: add CONFIG_XSWAP_DEFAULT_MAX
> * [PATCH v5 12/19] mm, swap: let swapoff destroy xswap devices by name
> * [PATCH v5 13/19] mm, swap: add xswap grow trigger on cluster allocation
> * [PATCH v5 14/19] mm, swap: add debugfs counters for xswap
> * [PATCH v5 15/19] mm, swap: make xswap cluster_info accesses RCU-safe
> * [PATCH v5 16/19] mm, swap: prepare xswap_unmap_clusters for range shrin=
king
> * [PATCH v5 17/19] mm, swap: add xswap shrink trigger and defer it to a w=
orkqueue
> * [PATCH v5 18/19] mm, swap: do not give an xswap slot to a cgroup that c=
annot zswap
> * [PATCH v5 19/19] mm, swap: skip the overcommit probe when removing xswa=
p
>
> and found the following issue:
> BUG: unable to handle kernel paging request in swapoff
>
> Full report is available here:
> https://ci.syzbot.org/series/88bad2a7-a1dc-4686-80c1-647e34e90e37
>
> ***
>
> BUG: unable to handle kernel paging request in swapoff
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      2dc0136b1fdac153434ab02778fcdb32db5d0dae
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/5c923c30-8b6d-49b4-8bbb-014cb8573=
7f7/config
> syz repro: https://ci.syzbot.org/findings/f14c26d8-d891-4444-9227-d55cbaf=
2adb7/syz_repro
>
> BUG: unable to handle page fault for address: fffffffffffffffe
> #PF: supervisor read access in kernel mode
> #PF: error_code(0x0000) - not-present page
> PGD ff4b067 P4D ff4b067 PUD ff4d067 PMD 0
> Oops: Oops: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 5894 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__do_sys_swapoff mm/swapfile.c:3743 [inline]
> RIP: 0010:__se_sys_swapoff+0x233/0x610 mm/swapfile.c:3719
> Code: 99 90 ff e9 42 ff ff ff e8 2a 99 90 ff eb 6f 4c 89 e0 48 c1 e8 03 4=
2 80 3c 28 00 74 08 4c 89 e7 e8 72 c7 08 00 4c 89 64 24 10 <4d> 8b 24 24 66=
 43 c7 44 2f 04 00 00 43 c6 44 2f 06 00 4c 89 3c 24
> RSP: 0018:ffffc90003d1fde0 EFLAGS: 00010246
> RAX: 1fffffffffffffff RBX: 0000200000000000 RCX: c8af1e162af39c00
> RDX: 0000000000000000 RSI: fffffffffffffffe RDI: 00000000ffffff9c
> RBP: ffffc90003d1fee0 R08: 0000000000000003 R09: 0000000000000000
> R10: ffffc90003d1fd40 R11: fffff520007a3faa R12: fffffffffffffffe
> R13: dffffc0000000000 R14: fffffffffffffffe R15: 1ffff920007a3fc0
> FS:  00007f5ca62c96c0(0000) GS:ffff8882a7806000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffffffffffffffe CR3: 00000001023f4000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f5ca53a8f19
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f5ca62c9028 EFLAGS: 00000246 ORIG_RAX: 00000000000000a8
> RAX: ffffffffffffffda RBX: 00007f5ca5625fa0 RCX: 00007f5ca53a8f19
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000200000000000
> RBP: 00007f5ca5437f6d R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f5ca5626038 R14: 00007f5ca5625fa0 R15: 00007ffce4301208
>  </TASK>
> Modules linked in:
> CR2: fffffffffffffffe
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__do_sys_swapoff mm/swapfile.c:3743 [inline]
> RIP: 0010:__se_sys_swapoff+0x233/0x610 mm/swapfile.c:3719
> Code: 99 90 ff e9 42 ff ff ff e8 2a 99 90 ff eb 6f 4c 89 e0 48 c1 e8 03 4=
2 80 3c 28 00 74 08 4c 89 e7 e8 72 c7 08 00 4c 89 64 24 10 <4d> 8b 24 24 66=
 43 c7 44 2f 04 00 00 43 c6 44 2f 06 00 4c 89 3c 24
> RSP: 0018:ffffc90003d1fde0 EFLAGS: 00010246
> RAX: 1fffffffffffffff RBX: 0000200000000000 RCX: c8af1e162af39c00
> RDX: 0000000000000000 RSI: fffffffffffffffe RDI: 00000000ffffff9c
> RBP: ffffc90003d1fee0 R08: 0000000000000003 R09: 0000000000000000
> R10: ffffc90003d1fd40 R11: fffff520007a3faa R12: fffffffffffffffe
> R13: dffffc0000000000 R14: fffffffffffffffe R15: 1ffff920007a3fc0
> FS:  00007f5ca62c96c0(0000) GS:ffff8882a7806000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: fffffffffffffffe CR3: 00000001023f4000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess), 3 bytes skipped:
>    0:   e9 42 ff ff ff          jmp    0xffffff47
>    5:   e8 2a 99 90 ff          call   0xff909934
>    a:   eb 6f                   jmp    0x7b
>    c:   4c 89 e0                mov    %r12,%rax
>    f:   48 c1 e8 03             shr    $0x3,%rax
>   13:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1)
>   18:   74 08                   je     0x22
>   1a:   4c 89 e7                mov    %r12,%rdi
>   1d:   e8 72 c7 08 00          call   0x8c794
>   22:   4c 89 64 24 10          mov    %r12,0x10(%rsp)
> * 27:   4d 8b 24 24             mov    (%r12),%r12 <-- trapping instructi=
on
>   2b:   66 43 c7 44 2f 04 00    movw   $0x0,0x4(%r15,%r13,1)
>   32:   00
>   33:   43 c6 44 2f 06 00       movb   $0x0,0x6(%r15,%r13,1)
>   39:   4c 89 3c 24             mov    %r15,(%rsp)
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
> [akpm@linux-foundation.org baohua@kernel.org baoquan.he@linux.dev chengmi=
ng.zhou@linux.dev chentao@kylinos.cn chrisl@kernel.org corbet@lwn.net david=
@kernel.org hannes@cmpxchg.org hebaoquan@kylinos.cn kasong@tencent.com klar=
asmodin@gmail.com kunwu.chan@gmail.com linux-kernel@vger.kernel.org linux-m=
m@kvack.org nphamcs@gmail.com youngjun.park@lge.com]
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
-upstream-moderation/6af520ef.4fb38a5b.96541.0002.GAE%40google.com.
