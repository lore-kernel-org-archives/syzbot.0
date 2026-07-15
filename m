Received: from mail-oa1-f43.google.com (mail-oa1-f43.google.com [209.85.160.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D14633B4E9F
	for <syzbot@lists.linux.dev>; Wed, 15 Jul 2026 05:53:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.160.43
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784094828; cv=pass; b=a5GVqjig7zMyDUsQv6g/6LrYNRzlzwkcy4xP074Oe/T9rEKfKvSSDLjldBKJie7Ecl05yfd6Vj3pvrwRgkvm0O/pTN6qvjiGy0WQY58fjfSHkBy8DHjFQ2aueUTmVoQV/WP/ZR/MzxiXSdKxXzBT7+4qX1bM1i93lVuQQVP1qZw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784094828; c=relaxed/simple;
	bh=VL0UdGj1vhuW+mvjZ0NNxJ02SuezQ5Lc2rp7CnQkJDw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=SSnB/0d7m9b2BMOpip7aw91wTba8CE/kV919F6M6rL8S/wp86CWBQmcD3rlGE5rJCyivqiyiL8JI+fZb3kbaeWpJRKcIstFsvbIi+cY+k8rjZUXFyFhFlS+Kol5Bny96Nd3Bw67lxLtFpqL+e4c4yyLJYKhxKlpfU6cQdf71fD0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CFACTef+; arc=pass smtp.client-ip=209.85.160.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CFACTef+"
Received: by mail-oa1-f43.google.com with SMTP id 586e51a60fabf-43cce34c881so1014611fac.2
        for <syzbot@lists.linux.dev>; Tue, 14 Jul 2026 22:53:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784094825; cv=none;
        d=google.com; s=arc-20260327;
        b=L31O/S2zOd9D9VbmeBnaHm9TknpTc79m0s7St03jThuFWpylc5xDDn+9glNpoYKmK5
         S+QjdZq1c5+fuq3QWKSDEF0puCak6KwyZY0ACtXGP1keOdQlIQDbDxR3hHoZM50fjEUr
         8o+Y0h3U3nsoH/Hfuqwo0kOtLAJIvFZYW4F9GAoDY3hRNHyDGvf7XcWCaP+1ACyQNfPR
         mqRBmDr0WjRn8QD1gyvPu6pKAvZa5zuCz+jp9sSBuNuDzX+jNKh5IPvbb1RxCd9quRmc
         /ACevFxF4005hDdbtgpJGNMetoCZgD7mnmGtp0BT7t/ZAe1yTJdDw7JiaGBFPd2vfww3
         s+BQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=y1lTec7rDzwAL8goMeC6BOFBuChYEETow4KFCSMbiRE=;
        fh=ezhYg0vM9OB2FuVy3yklRFMe2cYClZ7kecEHGV3zBnM=;
        b=beAhgtA6n28R/cSmnYG7jU5IYAKHEMvpDFw1tMgf1bNlfH3ZPd7CLRJNn7DPWwW2mx
         EMv42b7FjUKwmKoO3ukvFa/+pyTUGQHdZmZ6YkKWJIqoOxanNR/Fv0PQc3Cjv3mVVkT1
         fFazmlK3bvzhENedxE7RqbNuy86p9S8BpvDxYwAkW6YwtRhfbd+HDQG7aIvdZ/bu2jW7
         fNfqThZNgDC/5sHOm1gLK+JtI1kFNnNzsBZIpIlN+iC+4DBMuozq3rdefrNprKnDTjLB
         wpU76uz25h65aWPY9CkK0VMAG1Se0YAP/MAwYzz6zAKtXtMZ50mMsZkId9z9V0pQO19k
         GGoA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784094825; x=1784699625; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=y1lTec7rDzwAL8goMeC6BOFBuChYEETow4KFCSMbiRE=;
        b=CFACTef+Lfd8p9MX+wW9bWODbNMUx6DXjb3uh9C2C/iWAks5Drf2zMB+wxIC9DYVz/
         Quycb1EENu1YDTaePQP2rtReplgz9jc1CmGX5T36qwHygRKROQNcKz1EMJisT7Qd+brA
         hgKIloaJWSoTkP59qSBsYG4CZ/2UOFgQZtdtZiUYsE8yZz3ttjXaDIZJFxxDJc03QwUS
         VoK6pDZXkjd9Zj4yjb7qC0UStcxYtsjl+m2NsNgNgtB8VaAW8pA2T3JY7iS3Hcipmmah
         GpMYl7FE1g/iUm8Zxe67qmjL5ePQGttt5inVTyJPeY/OopqsV7w/itF64tydgQITq40P
         KUvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784094825; x=1784699625;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=y1lTec7rDzwAL8goMeC6BOFBuChYEETow4KFCSMbiRE=;
        b=BQGPLhlcpl62pdW54/hm5e4/ClgUDNi3qtvbL4J4lCzBibCOhQVmvTBG9y5RURDd/K
         wIr4D6Oy8qBb3uYr3US0U/pIVxg6H+89Bv80nyb4CE3RjQ/GXXYotTuIXuevG99heTJx
         +6UmUZG9rXYN6utzVELSRxbvqfaEZSH10tVfohBGrMhBTyPajf8Yv3YCmez1WVp+n1/d
         DVm0fAx8OkyGOdRF0kERf2STv91mfMh4oYs4O22DFF2beKK3PtZY9lUeB9fppK8b/GP7
         P41fXbl5scPq54vJdX64qPmiR2UtHt1tdC1og0wqyYZtnXN2g7sadqbTZRDt73HgylKa
         rKWA==
X-Forwarded-Encrypted: i=1; AHgh+RoZv5PAZPc6XHF26Ii3VEFuHQ4nmPjXwonxAEhV0zDEkVXFRHf5giCXBteidBEe1fP2a5hvzMA=@lists.linux.dev
X-Gm-Message-State: AOJu0YzecXW774oLOAvuKlfo1eWCoMUQHv4yUpZXDPs9xeD5/NN+PTg/
	scL2blWly1EFdacq8At6R0E36ovvDBeBkMqXnGWIt7V3HeGsweTFpQGu1PhGvmQCkLdZKz471WB
	PZb+1lZFvFeUd02nD9byqayZPDd0SO5wyLXty8ek4
X-Gm-Gg: AfdE7ckrJdBD5EijSmPh80aGoXPW1PxA7XtQbYc70nwfOSSS1oIlt19r1g2VRmZI03n
	M4w+rt8mZVENOckh6bPJyLz/gNkBpdw9mnCzo07UmY1GzXGEcLTK+dvmNQmN9Ja5nFkAa40UJ5E
	8tKtbecmcJztGng7nojM1C7mc/O5qRB8UzZOhbOSL01/WnqV/it+tPUpvmId09dfD618s81jDkJ
	R1p2wsvFAAq55l0vjeWRwShRjFMGCzBEp968QseyFFZ6T9/vFJ1RdnmWpFmn+Sru238PGOGDMYn
	Quu81SwdXinm66jQPwFYHPJbQkXp+ulwktTUS5nfS9Xso8XC/UQc2EAFfCYbvqmXraHP0phZ9hd
	ojzjZGdiq3Mn6MlbXZs6/2UwDsN7sDNUTaJnerrZ0V2I=
X-Received: by 2002:a05:6871:d805:10b0:455:ade8:79bf with SMTP id
 586e51a60fabf-455ade87cb3mr5441074fac.5.1784094825038; Tue, 14 Jul 2026
 22:53:45 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a56d274.c90005c7.37d349.003a.GAE@google.com>
In-Reply-To: <6a56d274.c90005c7.37d349.003a.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 15 Jul 2026 07:53:33 +0200
X-Gm-Features: AUfX_mw5wca0IKrpiCIFZRJ2FDCQyfTtM7C5_K8lvo5KYiMHcgfpeDk8ZrnTRlU
Message-ID: <CANp29Y7Tzd9ZtCDN_X7M33f1TL4cQjyKkp6Buqs5Qyd5D8+=tQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm: fix inode UAF when splitting a file folio
 past EOF
To: syzbot ci <syzbot+ciedb7aea4382fad92@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Jul 15, 2026 at 2:21=E2=80=AFAM syzbot ci
<syzbot+ciedb7aea4382fad92@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm: fix inode UAF when splitting a file folio past EOF
> https://lore.kernel.org/all/20260714122344.351895-1-kirill@shutemov.name
> * [PATCH v2 1/5] mm/memory-failure: keep the folio, not the poisoned subp=
age, locked across split
> * [PATCH v2 2/5] mm/huge_memory: refuse to split a file folio when the an=
chor is beyond EOF
> * [PATCH v2 3/5] mm/huge_memory: remove unused split_huge_page_to_order()
> * [PATCH v2 4/5] mm/huge_memory: remove unused can_split_folio()
> * [PATCH v2 5/5] mm/huge_memory: fold split_folio_to_list_to_order() into=
 split_folio_to_order()
>
> and found the following issues:
> * kernel BUG in __page_table_check_zero
> * kernel BUG in folio_isolate_lru
> * kernel BUG in memory_failure
>
> Full report is available here:
> https://ci.syzbot.org/series/6cad3430-1f9b-4a56-b60a-ef3ed2833e15
>
> ***
>
> kernel BUG in __page_table_check_zero
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/8d6a621e-aae6-4f99-8e0e-d0e02ddbe=
d71/config
> syz repro: https://ci.syzbot.org/findings/1619ac56-823a-4cc2-975b-bbb1c17=
42447/syz_repro
>
> Soft offlining pfn 0x120f0e at process virtual address 0x20000010e000
> ------------[ cut here ]------------
> kernel BUG at mm/page_table_check.c:142!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 5870 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__page_table_check_zero+0x416/0x430 mm/page_table_check.c:142
> Code: f3 ff e9 4e fc ff ff e8 78 70 85 ff 89 ea be 01 00 00 00 48 c7 c7 a=
0 c4 ac 8e e8 45 29 b7 02 e9 48 fd ff ff e8 5b 70 85 ff 90 <0f> 0b e8 53 70=
 85 ff 90 0f 0b e8 4b 70 85 ff 90 0f 0b 0f 1f 84 00
> RSP: 0018:ffffc900017e7948 EFLAGS: 00010293
> RAX: ffffffff8240f325 RBX: ffff88810544b4a8 RCX: ffff88810c68bb80
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffff88810544b4ab R09: 1ffff11020a89695
> R10: dffffc0000000000 R11: ffffed1020a89696 R12: 0000000000000001
> R13: ffff88810544b460 R14: 0000000000000000 R15: 0000000000000001
> FS:  00007fb17e6b86c0(0000) GS:ffff88818dc0e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f2353670000 CR3: 0000000109db2000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __folio_put+0x4b3/0x590 mm/swap.c:112
>  folio_put include/linux/mm.h:2124 [inline]
>  put_page include/linux/mm.h:2193 [inline]
>  page_handle_poison+0x35d/0x4a0 mm/memory-failure.c:204
>  soft_offline_in_use_page mm/memory-failure.c:2861 [inline]
>  soft_offline_page+0xd1d/0x1560 mm/memory-failure.c:2952
>  madvise_inject_error mm/madvise.c:1476 [inline]
>  madvise_do_behavior+0x319/0x930 mm/madvise.c:1897
>  do_madvise+0x327/0x3a0 mm/madvise.c:2005
>  __do_sys_madvise mm/madvise.c:2014 [inline]
>  __se_sys_madvise mm/madvise.c:2012 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb17d79ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb17e6b8028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fb17da15fa0 RCX: 00007fb17d79ce59
> RDX: 0000000000000065 RSI: 0000000000002000 RDI: 000020000010e000
> RBP: 00007fb17d832e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb17da16038 R14: 00007fb17da15fa0 R15: 00007ffd7e9be1d8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__page_table_check_zero+0x416/0x430 mm/page_table_check.c:142
> Code: f3 ff e9 4e fc ff ff e8 78 70 85 ff 89 ea be 01 00 00 00 48 c7 c7 a=
0 c4 ac 8e e8 45 29 b7 02 e9 48 fd ff ff e8 5b 70 85 ff 90 <0f> 0b e8 53 70=
 85 ff 90 0f 0b e8 4b 70 85 ff 90 0f 0b 0f 1f 84 00
> RSP: 0018:ffffc900017e7948 EFLAGS: 00010293
> RAX: ffffffff8240f325 RBX: ffff88810544b4a8 RCX: ffff88810c68bb80
> RDX: 0000000000000000 RSI: 0000000000000001 RDI: 0000000000000000
> RBP: 0000000000000001 R08: ffff88810544b4ab R09: 1ffff11020a89695
> R10: dffffc0000000000 R11: ffffed1020a89696 R12: 0000000000000001
> R13: ffff88810544b460 R14: 0000000000000000 R15: 0000000000000001
> FS:  00007fb17e6b86c0(0000) GS:ffff88818dc0e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fb17d7ea540 CR3: 0000000109db2000 CR4: 00000000000006f0
>
>
> ***
>
> kernel BUG in folio_isolate_lru
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/8d6a621e-aae6-4f99-8e0e-d0e02ddbe=
d71/config
> syz repro: https://ci.syzbot.org/findings/7857300c-5c56-4b88-9f60-6f1f360=
3e3f1/syz_repro
>
>  do_madvise+0x327/0x3a0 mm/madvise.c:2005
>  __do_sys_madvise mm/madvise.c:2014 [inline]
>  __se_sys_madvise mm/madvise.c:2012 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> ------------[ cut here ]------------
> kernel BUG at mm/vmscan.c:1803!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 0 UID: 0 PID: 5810 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:folio_isolate_lru+0x8ad/0x990 mm/vmscan.c:1803
> Code: 38 c1 0f 8c 75 fd ff ff 4c 89 f7 e8 ad 0e 28 00 e9 68 fd ff ff e8 d=
3 2b ba ff 4c 89 f7 48 c7 c6 20 5f d8 8b e8 84 d9 1b ff 90 <0f> 0b e8 bc 2b=
 ba ff 4c 89 f7 48 c7 c6 60 8e d8 8b e8 6d d9 1b ff
> RSP: 0018:ffffc90003c678d8 EFLAGS: 00010246
> RAX: 2554150cb728ac00 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000006 RSI: ffffffff8dfe9eba RDI: 00000000ffffffff
> RBP: 1ffffd40000f9d26 R08: ffffffff90334ef7 R09: 1ffffffff20669de
> R10: dffffc0000000000 R11: fffffbfff20669df R12: dffffc0000000000
> R13: 0000000000100010 R14: ffffea00007ce900 R15: ffffea00007ce934
> FS:  00007fa1793946c0(0000) GS:ffff88818dc0e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005640d3daa058 CR3: 00000001696d8000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  delete_from_lru_cache+0x1a/0x1e0 mm/memory-failure.c:900
>  me_pagecache_clean+0x58/0x230 mm/memory-failure.c:1015
>  page_action mm/memory-failure.c:1298 [inline]
>  identify_page_state+0x13c/0x190 mm/memory-failure.c:1649
>  memory_failure+0x2fff/0x3380 mm/memory-failure.c:2548
>  madvise_inject_error mm/madvise.c:1480 [inline]
>  madvise_do_behavior+0x344/0x930 mm/madvise.c:1897
>  do_madvise+0x327/0x3a0 mm/madvise.c:2005
>  __do_sys_madvise mm/madvise.c:2014 [inline]
>  __se_sys_madvise mm/madvise.c:2012 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa17859ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fa179394028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fa178815fa0 RCX: 00007fa17859ce59
> RDX: 0000000000000064 RSI: 0000000000002000 RDI: 00002000005a4000
> RBP: 00007fa178632e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fa178816038 R14: 00007fa178815fa0 R15: 00007fff254e3208
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:folio_isolate_lru+0x8ad/0x990 mm/vmscan.c:1803
> Code: 38 c1 0f 8c 75 fd ff ff 4c 89 f7 e8 ad 0e 28 00 e9 68 fd ff ff e8 d=
3 2b ba ff 4c 89 f7 48 c7 c6 20 5f d8 8b e8 84 d9 1b ff 90 <0f> 0b e8 bc 2b=
 ba ff 4c 89 f7 48 c7 c6 60 8e d8 8b e8 6d d9 1b ff
> RSP: 0018:ffffc90003c678d8 EFLAGS: 00010246
> RAX: 2554150cb728ac00 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000006 RSI: ffffffff8dfe9eba RDI: 00000000ffffffff
> RBP: 1ffffd40000f9d26 R08: ffffffff90334ef7 R09: 1ffffffff20669de
> R10: dffffc0000000000 R11: fffffbfff20669df R12: dffffc0000000000
> R13: 0000000000100010 R14: ffffea00007ce900 R15: ffffea00007ce934
> FS:  00007fa1793946c0(0000) GS:ffff88818dc0e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00005640d3daa058 CR3: 00000001696d8000 CR4: 00000000000006f0
>
>
> ***
>
> kernel BUG in memory_failure
>
> tree:      bpf
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/bpf/b=
pf.git
> base:      0e35b9b6ec0ffcc5e23cbdec09f5c622ad532b53
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/8d6a621e-aae6-4f99-8e0e-d0e02ddbe=
d71/config
> syz repro: https://ci.syzbot.org/findings/6feafe6c-6796-475f-9aca-225a9d3=
5747c/syz_repro
>
>  do_madvise+0x327/0x3a0 mm/madvise.c:2005
>  __do_sys_madvise mm/madvise.c:2014 [inline]
>  __se_sys_madvise mm/madvise.c:2012 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> ------------[ cut here ]------------
> kernel BUG at mm/memory-failure.c:2483!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 5850 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:memory_failure+0x3373/0x3380 mm/memory-failure.c:2483
> Code: cb 87 ff 48 89 df 48 c7 c6 e0 a2 dd 8b e8 45 79 e9 fe 90 0f 0b e8 7=
d cb 87 ff 4c 89 f7 48 c7 c6 40 93 dd 8b e8 2e 79 e9 fe 90 <0f> 0b 66 66 2e=
 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc900036efa00 EFLAGS: 00010246
> RAX: 9a71b80f9d8a2200 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000006 RSI: ffffffff8dfe9eba RDI: 00000000ffffffff
> RBP: ffffc900036efb90 R08: ffffffff90334ef7 R09: 1ffffffff20669de
> R10: dffffc0000000000 R11: fffffbfff20669df R12: ffffea00045f6ac0
> R13: ffffea00045f0008 R14: ffffea00045f6ac0 R15: 1ffff920006ddf54
> FS:  00007fed60fc56c0(0000) GS:ffff8882a920e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f3eee905440 CR3: 0000000165fdc000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  madvise_inject_error mm/madvise.c:1480 [inline]
>  madvise_do_behavior+0x344/0x930 mm/madvise.c:1897
>  do_madvise+0x327/0x3a0 mm/madvise.c:2005
>  __do_sys_madvise mm/madvise.c:2014 [inline]
>  __se_sys_madvise mm/madvise.c:2012 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fed6019ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fed60fc5028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fed60415fa0 RCX: 00007fed6019ce59
> RDX: 0000000000000064 RSI: 0000000000001000 RDI: 0000200000ffe000
> RBP: 00007fed60232e6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fed60416038 R14: 00007fed60415fa0 R15: 00007ffc1c6c3eb8
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:memory_failure+0x3373/0x3380 mm/memory-failure.c:2483
> Code: cb 87 ff 48 89 df 48 c7 c6 e0 a2 dd 8b e8 45 79 e9 fe 90 0f 0b e8 7=
d cb 87 ff 4c 89 f7 48 c7 c6 40 93 dd 8b e8 2e 79 e9 fe 90 <0f> 0b 66 66 2e=
 0f 1f 84 00 00 00 00 00 90 90 90 90 90 90 90 90 90
> RSP: 0018:ffffc900036efa00 EFLAGS: 00010246
> RAX: 9a71b80f9d8a2200 RBX: 0000000000000000 RCX: 0000000000000000
> RDX: 0000000000000006 RSI: ffffffff8dfe9eba RDI: 00000000ffffffff
> RBP: ffffc900036efb90 R08: ffffffff90334ef7 R09: 1ffffffff20669de
> R10: dffffc0000000000 R11: fffffbfff20669df R12: ffffea00045f6ac0
> R13: ffffea00045f0008 R14: ffffea00045f6ac0 R15: 1ffff920006ddf54
> FS:  00007fed60fc56c0(0000) GS:ffff8882a920e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b33863fff CR3: 0000000165fdc000 CR4: 00000000000006f0
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
> [akpm@linux-foundation.org baohua@kernel.org baolin.wang@linux.alibaba.co=
m david@kernel.org dev.jain@arm.com hao_zhang_kdev@163.com kas@kernel.org k=
irill@shutemov.name lance.yang@linux.dev liam@infradead.org linmiaohe@huawe=
i.com linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org nao.ho=
riguchi@gmail.com npache@redhat.com ryan.roberts@arm.com stable@vger.kernel=
.org usama.arif@linux.dev zhanghao1@kylinos.cn ziy@nvidia.com]
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
-upstream-moderation/6a56d274.c90005c7.37d349.003a.GAE%40google.com.
