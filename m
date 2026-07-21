Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C856435538
	for <syzbot@lists.linux.dev>; Tue, 21 Jul 2026 09:34:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784626477; cv=pass; b=nlzDsWxPhB8SrWNwsOUeJpJoQvxTZ+CdJk0fDiA4COO4A6f+Ku53PilRvq94yX8Hg2SB0BNmM8PWTlEjhARh+8WQg8y1Tk44yENKXCesiWNBreUiXrqBkxCYy4A3MFV+Zacr9Ylvl6NmYAuP/bHujExv8pr8bn4zcSVukkrzHV4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784626477; c=relaxed/simple;
	bh=zfKAR6O0szY6xnnFT79Bzc+oMo/e4IXguK8RQm4kLc4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=DbvdeTx5RRSTo1/dRV0zR9HfS8PQP6Zyd/CE4BuCeQlFN20+7lSp9HPW0Y5qF7fmnKVSnaWjohfacWIZFJlPsro+SGWh1PTWZcgtLSQAGdkeYPcfsOII20OE9lGUTldXbwvDyNUTVz5q6AnJTihTSSRO+Hdbfv9lJ1sIxQnYGis=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=KqvFxSCa; arc=pass smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="KqvFxSCa"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7e6b5737bb2so8707423a34.1
        for <syzbot@lists.linux.dev>; Tue, 21 Jul 2026 02:34:35 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784626474; cv=none;
        d=google.com; s=arc-20260327;
        b=YwghtCNz9ZI+SWyJB7126bvHEuUDxVurz+w0HrWmJ4RWIFJqz1iuPGn5xFNH7SzdCm
         YBZ7ifphK1QM+XXB5Y2LvYpVEWBr46Q1n43rsYxOPB/NvZaJv4vzacqbkUx20G0UgIMR
         Sq3YNblPir2zWbv2Sj5u2/QezYpMy+i5cbJin5DlP1qOkERHw0gQF5WlzqiciHm3t8Kh
         0KbJcd+5uNSLqXYWZ8c0ESr2YNsUE7ATaa/NAtO3jWak+Kc3u/1Sk93qh+fw/vCmVr1Y
         E5rGP/lt9g+raauYBgLPyFXaV956M5Ap0HzHpiAMdpKcLJWAW5chqh5wlu30/JxN402J
         Qs9g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Ci0el2Eq3wxLBY/ShOxO3F0jaAu4O/TZE8ZdL5nTHUM=;
        fh=UP94axQeLsIqy8+q15Ie6WXs3S/GgbQo26C2Y7Am3p8=;
        b=sCKnPEEkgZ0gFakP+Mn49E4OT6V7v+TXtAcQKN/8AyGQpU43Mz1bMwr2OjzrDBhWTq
         JPUNFS6Qor7o3kljwgmjYyJi3WjJ0WStlB357jSCkXusyoW+yX8lDxwNkMf3z5tLiPVt
         BxOuQWHdJEwbwvHHO6CGkVrcnmAKs/aII0DHoWdQROD50vnKjY6nt8srqIpuHCrU2h4K
         V48PbifrvMFjgd1a9BiJl4PWNPQhVKF2qwfgW3hyC6Qsaota1VduJK8pjdO+5ReVezP4
         MgU185imLamRHJjFe7t2sXbMs/Rssprf48nTw4vKEv2/9gB9v/kJkGi9P2QkL7vxcO3M
         ShaQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784626474; x=1785231274; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=Ci0el2Eq3wxLBY/ShOxO3F0jaAu4O/TZE8ZdL5nTHUM=;
        b=KqvFxSCatDBBydn+zvAqIoE3kTwbe0WdxOpQiQWIrdVVOWOiFHtvbItcIFmJndgoFT
         GwQbw+RVqQQyzE78XZ2mvVFsLO3UgUKnMEqDcnwOOho8UjCH03m7sGTcVVb1cbbpvLdZ
         e12V+JNF4dwskKm6S6Sd89pDstiYSeiii46UXQVQVNsEG4sLuSg127DL71v46Qlo+Y/3
         5RpxcBTj/C4tSDqHlAmwsTTlLQ2SBhGayJM7szJshxjS+FfYRfhbuAeZqoOf2zT8iBD7
         cEnURUiydKwHacVUZKKspwkKjBJiSPpRlx4bg1yXMIcVnjQwwNA47s+L7heTBzOYVRDl
         MNvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784626474; x=1785231274;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Ci0el2Eq3wxLBY/ShOxO3F0jaAu4O/TZE8ZdL5nTHUM=;
        b=WGoph2YuEn5nLJxNo+69mQDK/qgceu73cmJtmuUjY71WPjU7H4EpnNIlIJzvtCQ4vd
         tBLSf16pzNOTzvr572aWT9E8BfaOoo3BQBdzjGysN4rrS7n04891GG50mHMQ0rWy8pNg
         8DUXARgFTY6qfban+cJ8D0gAIDAukft47Pfk+mV6XPFO//i3+QTWL897d1qtUPWm80Hv
         hIIBsRrGa6ntTS/FxQox0Tw9SzVRrTSN5Nns86jQaYTTHA9M2SGGeN3clkBlV/adBH5d
         1MW60XfEeEiV1Cpw10uueHafNkAn2E7szL31EEAOPdep9zEsNQtug8uxjsXO4RIsAukT
         E9Cw==
X-Forwarded-Encrypted: i=1; AHgh+Rp78P+4zsWnGlIVO6Jmuxyt4eXKHHLsq381XKtgI7d5MveE7hGKW0A+uanpk4/oBP3nhLMVZts=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz1k3YUytN5EUa57Wkml0MHrjHY7kIK2SKeHn0YwIyXZn8sbYAc
	gtQie2uy038D1FR85yrgWTw+6m4M905OAGPZc7YTo1dWjN5m844P5ZSCxWRhiExqZ2Kq45tttrC
	OhU5Yi/fV2xk2MXxr51xid+dYIHqIbwpFDj7qHcCq
X-Gm-Gg: AfdE7cmGC7UiMj6s3h+CFUKVLDLCK/f/hxJvFoIhU2Oy+QvkOy4qr0Sef0R5cu6ili6
	W5LvV2dj89BZxiar73YWtPpNwxEaKai17OTLC1dAjb/UljD1S0R07/qsY+pkd4YIkA3UEsQHgk9
	z+lu0FdAQLhJ+ZBra7wEraiNQzoRYUcqMsDKao1+gunR+Ie2s+xw/Ze3rTat9KWVAD7c87Z1E+T
	LOSIKncAbX8p26Hu3U3wJnax+thouv5ljQLT6Mf2zcvsI4z268U5clTAntvMkFtt4Q/U204P8q1
	gaAATL+e74EmvlW2TskwOcdblZnUffleMAnBggz6EDrMqWXa32n+ed1Of/2Use4zQ6gafoJwx+P
	gx6FoYAuLKAhEB/seaOPWVyXgb0A=
X-Received: by 2002:a05:6830:7105:b0:7e9:b4d0:df72 with SMTP id
 46e09a7af769-7eda1559ccamr10691220a34.26.1784626473794; Tue, 21 Jul 2026
 02:34:33 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a5f3cf3.33ea6125.251e5.0000.GAE@google.com>
In-Reply-To: <6a5f3cf3.33ea6125.251e5.0000.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 21 Jul 2026 11:34:21 +0200
X-Gm-Features: AUfX_mwcg_d14czT_rUaKTWlr_PDCMxJEn6kZeADEufj7JI6uST6Vu96q16HHAg
Message-ID: <CANp29Y6YqGtmrdJUUZMn+2cmE5KU7ohqsK8nwiK8QNOzif+qog@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/khugepaged: collapse_file() cleanups
To: syzbot ci <syzbot+cie7043cc98ea76fa1@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Jul 21, 2026 at 11:33=E2=80=AFAM syzbot ci
<syzbot+cie7043cc98ea76fa1@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm/khugepaged: collapse_file() cleanups
> https://lore.kernel.org/all/20260720142913.846902-1-pfalcato@suse.de
> * [PATCH 1/8] mm/khugepaged: separate out windy folio logic from collapse=
_file
> * [PATCH 2/8] mm/khugepaged: factor out page cache folio reading
> * [PATCH 3/8] mm/khugepaged: factor out and simplify dirty/writeback hand=
ling
> * [PATCH 4/8] mm/khugepaged: simplify prepare folio locking and exit path=
s
> * [PATCH 5/8] mm/khugepaged: add kerneldoc to prepare_collapse_file_folio=
()
> * [PATCH 6/8] mm/khugepaged: hoist isolation into collapse_isolate_folio(=
)
> * [PATCH 7/8] mm/khugepaged: hoist more code into collapse_isolate_folio(=
)
> * [PATCH 8/8] mm/khugepaged: fix and flesh out try_to_unmap_flush() comme=
nt
>
> and found the following issue:
> WARNING: bad unlock balance in collapse_scan_file
>
> Full report is available here:
> https://ci.syzbot.org/series/cc30d9d4-857a-45de-a8e8-b99f9346d0da
>
> ***
>
> WARNING: bad unlock balance in collapse_scan_file
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      c872b70f5d6c742ad34b8e838c92af81c8920b3e
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/e6e237b7-5a64-4732-bb37-4e62c3103=
d4a/config
> syz repro: https://ci.syzbot.org/findings/51ee94c3-7fe6-47f6-81ed-a53cf51=
bb3f9/syz_repro
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> WARNING: bad unlock balance detected!
> syzkaller #0 Not tainted
> -------------------------------------
> syz.0.17/5868 is trying to release lock (&xa->xa_lock) at:
> [<ffffffff823ac70f>] spin_unlock_irq include/linux/spinlock.h:402 [inline=
]
> [<ffffffff823ac70f>] prepare_collapse_file_folio mm/khugepaged.c:2331 [in=
line]
> [<ffffffff823ac70f>] collapse_file mm/khugepaged.c:2539 [inline]
> [<ffffffff823ac70f>] collapse_scan_file+0x2cbf/0x4dc0 mm/khugepaged.c:284=
9
> but there are no more locks to release!
>
> other info that might help us debug this:
> no locks held by syz.0.17/5868.
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5868 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_unlock_imbalance_bug+0xdc/0xf0 kernel/locking/lockdep.c:5299
>  __lock_release kernel/locking/lockdep.c:5528 [inline]
>  lock_release+0x1fb/0x3c0 kernel/locking/lockdep.c:5912
>  __raw_spin_unlock_irq include/linux/spinlock_api_smp.h:185 [inline]
>  _raw_spin_unlock_irq+0x16/0x50 kernel/locking/spinlock.c:206
>  spin_unlock_irq include/linux/spinlock.h:402 [inline]
>  prepare_collapse_file_folio mm/khugepaged.c:2331 [inline]
>  collapse_file mm/khugepaged.c:2539 [inline]
>  collapse_scan_file+0x2cbf/0x4dc0 mm/khugepaged.c:2849
>  collapse_single_pmd+0x2b1/0x3da0 mm/khugepaged.c:2884
>  madvise_collapse+0x2cf/0x790 mm/khugepaged.c:3310
>  madvise_vma_behavior+0x115f/0x4170 mm/madvise.c:1363
>  madvise_walk_vmas+0x576/0xb00 mm/madvise.c:1712
>  madvise_do_behavior+0x385/0x540 mm/madvise.c:1907
>  do_madvise+0x327/0x3a0 mm/madvise.c:2005
>  __do_sys_madvise mm/madvise.c:2014 [inline]
>  __se_sys_madvise mm/madvise.c:2012 [inline]
>  __x64_sys_madvise+0xa6/0xc0 mm/madvise.c:2012
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb60079de99
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb6015c0028 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fb600a25fa0 RCX: 00007fb60079de99
> RDX: 0000000000000019 RSI: 0000000000600003 RDI: 0000200000000000
> RBP: 00007fb600833eaf R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb600a26038 R14: 00007fb600a25fa0 R15: 00007ffc7db2f618
>  </TASK>
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
m david@kernel.org dev.jain@arm.com lance.yang@linux.dev liam@infradead.org=
 linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org npache@redh=
at.com pfalcato@suse.de ryan.roberts@arm.com usama.arif@linux.dev ziy@nvidi=
a.com]
>
> If the report looks fine to you, reply with:
> #syz upstream
>
> If the report is a false positive, reply with
> #syz invalid
>
