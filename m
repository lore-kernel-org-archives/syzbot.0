Received: from mail-qv1-f51.google.com (mail-qv1-f51.google.com [209.85.219.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FD26363C4C
	for <syzbot@lists.linux.dev>; Sat, 18 Jul 2026 19:02:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.219.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784401384; cv=pass; b=UqZYsAG/kHjFQPbovJAugPhMqsPACahJr9ohfJr8b0Jk8dfQrPaMRV3fUL+werDWw00CmT1ESUoYEz1KmOE5bz7I2Anwe3S6jqfUNbmGdLQVWrgdqmS7WVoMkUmArWCVPuSt33Yu0YOvObh7fQ0xc4AquPJf7pFajWHmlWL0H6Q=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784401384; c=relaxed/simple;
	bh=HLpYs5EwoZttNKXFrmoTlv9uCzYt/8ohSrpfBpCNyzg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=p33TsVsbLLJtuJjVxw14NRqDew1D8C4JPF5hXqHNEUl59PQJ5gIAvOjWmIeLQdqV5kRS8+UOxd/xR/vuNQD09mAKuWANylkWWt139rGisWslhMY6k2vtvdpYiK3eZ5/w7hKjMpW5yZT1wnFfW6+HWJ5IBJgcF7ceaTV+gM9i+OM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=M+Dr+dvC; arc=pass smtp.client-ip=209.85.219.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="M+Dr+dvC"
Received: by mail-qv1-f51.google.com with SMTP id 6a1803df08f44-8f1e274ccb9so42739016d6.2
        for <syzbot@lists.linux.dev>; Sat, 18 Jul 2026 12:02:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784401374; cv=none;
        d=google.com; s=arc-20260327;
        b=QnmYFTCvKzDZkpVJ9H+G0Jxwv2gOEsrnYTo/eoCpRtlfgeZjcoWvWYb1p/TObipHKr
         iYepdENav/5yrz3d3t+hnrL/04tb+tQLTIr46+13JNtWeNlmq78YwtKnuF85TdX7jhFm
         ptoZokbstz5284kv3JrJbVfbexPFDTBoJNC1nixIfZLngKZYAQqEQjQIbZT5ZftDAvT2
         dmSJzmCen2DH24346hMYmbDnxSRMv2sjrJrs0DZhQDA4tajohfKB3D0jHJXYqI5bwo3B
         aSCmmld7MTeRoCnYjqmqdsH0+ri8wcwUNCQLFRfGzOCF8PFriHf7Fn/ESRmUOfuPaLhO
         FywA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=H/rR8ijmHkypsRWFUMKgnF1yKUVSAgmvqcYZk4hIqQE=;
        fh=nV76/oucyaT3i63J4rZKlA4m95rhrtSC6uYBvMVySzk=;
        b=h5U9F9pYx1mC6a4tCKmXlQWF4i/yrUC+Dmo63fbpuG3Lv9bfhlnjVtyEufhn6zv9JF
         mwEJSQqM9HEX2DhfB4Xm+Apy5oXqu8aaFko4n1Rpv56qwhAiSY4MFwGof8iESzXtIA8M
         waA+5+ZSmxsY4/KfAKICp4lehe1Ph2Bc8NNvsXkqzU1v79uXduK7ZCkabkYNN9K0Mhhq
         V+eP2h4qfdSobvBEmbLYdhF6kPpXUewc3uW62BVmRbpuj3mNcG/rW9S6fGieKquvgmOP
         KxP6dpN+JtQHej0NlhO8xS9x5hgB9hLJWe6VAexzIP09AoSoVaSTvRmd4uNuSP45LeBM
         JIzw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784401374; x=1785006174; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=H/rR8ijmHkypsRWFUMKgnF1yKUVSAgmvqcYZk4hIqQE=;
        b=M+Dr+dvCvjjrbD+UxAmSZE+m+vNX4RbLc3MobS50x5Tot/HQJuBFfSuhjoC+cJ7v/G
         3EFl2Jw0AIm/2cDwQInrogbhryHPh/TWlSgSKXyYW7JLtQaKRGT7/n3PFnl35kNCEnK3
         H+E/oZ5OikhwFhX9rVoCe5XiKZQCLgrK/lcn5RdBtshRAEU2mx5B779D9/0JM4ytJQp3
         ibSybUmIAAlQW0lgcQ0sXFV4yaYPjwvvn6rdNgVNq/4SHki2vv/EN8wf7vU6/8i9L6dL
         OQ+OhsRYaR+pxp7zO+nITrziO3ct6Dg/LmNGYRkkXNtbJ5NWR96K/mOyDXHvz2L39AwV
         QA7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784401374; x=1785006174;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=H/rR8ijmHkypsRWFUMKgnF1yKUVSAgmvqcYZk4hIqQE=;
        b=mLDuP5xQ7Eq3SSEcTAyqF6jhuoelKFj5j1QxPXQgJUZTSmVCaT0U+F8IMiNCnCCNdU
         1nHNLIKEBwBvkzn4dQTLPs/dVjWO48h5N0eamgWYCzfTI62lt0hF1AtWYQ0ZWArk5D/f
         XAj57nMYD6rBViMoMhqONqpu1PAMMGcc/+pZwdSPtf/Rn1MLIGISX/ozbc28gt7Hfv9r
         gK3lEtrVTDNbb0Ug56Lqx41qTBHIyh6Jp+hyJ0JRP7uViFCaZtTkj+bynz0iBOCYX7H4
         Y9EqKWEdtxjsBLxzkY2UiQubQ4jAESwCpAtBwH5YOrRFQaStncv6TYcsZZYCx7ytVSIf
         rGww==
X-Forwarded-Encrypted: i=1; AHgh+RoUaNKDWsX6i+9JHYWHb23MWasK1rf1FYj+tuvRUh/lK5UMeo/o+ksG0O3mwlXVYFVI8ZQhlSI=@lists.linux.dev
X-Gm-Message-State: AOJu0YxQ7XQIACPcZVkiAAImoyQ63tvJhIpxSB3AsWOjiTY+kSGzCBHv
	cmQ6VI6/wjSvNloj9wkofUB/kAraEx5eZyZ8Ves18Z21aAOQegUpwUbTaAeD3r2GS7/0mVAPBIa
	6cQ3fjLAy1XJLqSyoixifxjXzfVUI2iAxLcsANikA
X-Gm-Gg: AfdE7clXK5RP/rFSnGofZK3t01fk3AMaV+85dhJIzqFb/rUccvClxCNYfqshnvSC5g1
	AEipaVqTwF2qz27TvGb3bj8Tw/lkAKNbtY3N/1tPToEIcVgYjZOiInDOddelzW0H0krq09F+AxQ
	e+e5SUnN1E6ul6SJxvJmU2nZaqklLVaLdAmXyOqoat/Vq06c2dceQH1EyxCDd0sD8QlQKVyGFtf
	BHeFXEpt9Ax/vXghG+kxiVzsFCbga8AKD1Jlq0/dy5hGZjDG8FSHwlXRxVVUJlH4SXC2p7/wYYu
	1c/OfB/ENLUwIHg3AKYAiT6IjnPv0WHBP6xrSxNTsZyeyqWbXFU4
X-Received: by 2002:a05:6214:54c8:b0:8e9:f62b:8f93 with SMTP id
 6a1803df08f44-9077853b82amr88006966d6.57.1784401373486; Sat, 18 Jul 2026
 12:02:53 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a5bbbd1.42649fcc.6186.006b.GAE@google.com>
In-Reply-To: <6a5bbbd1.42649fcc.6186.006b.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Sat, 18 Jul 2026 21:02:42 +0200
X-Gm-Features: AUfX_myZgUfIeplLm2BMo_lu_RzICrVWs1_b80m45IGL9QDNug7JclFLifsKEIo
Message-ID: <CAJWNTGzjBtnyWckugma3ohJSzOac1rXHqig7WfNPcJfmUe82mA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Fix an imbalanced file ref count in the mmap syscall
To: syzbot ci <syzbot+ci238e01f3c60e6304@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Sat, Jul 18, 2026 at 7:45=E2=80=AFPM syzbot ci
<syzbot+ci238e01f3c60e6304@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] Fix an imbalanced file ref count in the mmap syscall
> https://lore.kernel.org/all/20260718123417.16339-1-liavalb@gmail.com
> * [PATCH] mm/vma: fix imbalanced file reference count, properly abort mma=
p_prepare
>
> and found the following issue:
> WARNING in tear_down_vmas
>
> Full report is available here:
> https://ci.syzbot.org/series/63d42f9f-f249-4678-8916-5464a15accd6
>
> ***
>
> WARNING in tear_down_vmas
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      3827fe994db98623a5a619a72f15f57bf8274deb
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/f57e989a-6273-4413-b35d-20dab5a41=
e92/config
> syz repro: https://ci.syzbot.org/findings/8f36751f-0976-460a-b5ab-de97c90=
74c0a/syz_repro
>
> ------------[ cut here ]------------
> !vma_is_attached(vma)
> WARNING: ./include/linux/mmap_lock.h:435 at vma_assert_attached include/l=
inux/mmap_lock.h:435 [inline], CPU#0: syz.2.19/5813
> WARNING: ./include/linux/mmap_lock.h:435 at vma_mark_detached include/lin=
ux/mmap_lock.h:455 [inline], CPU#0: syz.2.19/5813
> WARNING: ./include/linux/mmap_lock.h:435 at tear_down_vmas+0x381/0x520 mm=
/mmap.c:1261, CPU#0: syz.2.19/5813
> Modules linked in:
> CPU: 0 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:vma_assert_attached include/linux/mmap_lock.h:435 [inline]
> RIP: 0010:vma_mark_detached include/linux/mmap_lock.h:455 [inline]
> RIP: 0010:tear_down_vmas+0x381/0x520 mm/mmap.c:1261
> Code: 48 89 df e8 01 46 16 00 48 8b 44 24 18 48 39 03 0f 87 e0 00 00 00 e=
8 ce a8 a8 ff ff 44 24 04 e9 9a fd ff ff e8 c0 a8 a8 ff 90 <0f> 0b 90 e9 2c=
 ff ff ff e8 b2 a8 a8 ff 90 0f 0b 90 e9 94 fe ff ff
> RSP: 0018:ffffc90003cdf7e0 EFLAGS: 00010293
> RAX: ffffffff821dbb90 RBX: ffff888115e14b40 RCX: ffff888171f9bb80
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90003cdf920 R08: ffff888115e14b43 R09: 1ffff11022bc2968
> R10: dffffc0000000000 R11: ffffed1022bc2969 R12: ffff888115e14a80
> R13: 0000000000000001 R14: 0000000000000000 R15: dffffc0000000000
> FS:  00007f15b88e36c0(0000) GS:ffff88818dc1c000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9033eab095 CR3: 0000000173ace000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  exit_mmap+0x4ca/0x9f0 mm/mmap.c:1320
>  __mmput+0x118/0x420 kernel/fork.c:1187
>  exit_mm+0x221/0x2d0 kernel/exit.c:610
>  do_exit+0x6cd/0x2360 kernel/exit.c:992
>  do_group_exit+0x22d/0x2f0 kernel/exit.c:1147
>  get_signal+0x121b/0x12c0 kernel/signal.c:3038
>  arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
>  exit_to_user_mode_loop+0x104/0x730 kernel/entry/common.c:101
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline=
]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:230 [=
inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>  do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f15b799ce59
> Code: Unable to access opcode bytes at 0x7f15b799ce2f.
> RSP: 002b:00007f15b88e30e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 00007f15b7c15fa8 RCX: 00007f15b799ce59
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007f15b7c15fa8
> RBP: 00007f15b7c15fa0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f15b7c16038 R14: 00007ffe1b61d9f0 R15: 00007ffe1b61dad8
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
> [akpm@linux-foundation.org david@kernel.org jannh@google.com liam@infrade=
ad.org liavalb@gmail.com linux-kernel@vger.kernel.org linux-mm@kvack.org lj=
s@kernel.org mhocko@suse.com pfalcato@suse.de rppt@kernel.org surenb@google=
.com vbabka@kernel.org]
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
-upstream-moderation/6a5bbbd1.42649fcc.6186.006b.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
