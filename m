Received: from mail-ot1-f48.google.com (mail-ot1-f48.google.com [209.85.210.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E2C492264A9
	for <syzbot@lists.linux.dev>; Mon, 29 Dec 2025 10:20:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767003614; cv=none; b=NwNkc/iXLDGjeuruJI+sg+lFmHPepQFXm1ePDJOiiVKrjkmXu66xj2F8nosKZXqJAOuvxbvFRJMP0S0aM8AbBF0TGzFGq/8DpNc4MYC91sxjxTRxp7Smb8CfVfwLZeC5tQFH2wJH1mG0A7cSGC3GFQ6q/YWx8JEl8oGlFC5JXcM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767003614; c=relaxed/simple;
	bh=OsIPGx8Kd+wk3Xb2RG9KcFjbEXLTRkbbPcONSOCesjw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=EHPwiN/EqYUj297SNaUQFy4MnnmpR6dbdjpnEbGj/0vyguLXZ3vBT2D7okeJ8uxE3Vd1d3MQfGhrgTgZjpdnXdN5tkf0IzFI/LznuG+YxPpqi3bNuZhd7ycXxfyUZmI09GERoItwi7xKPMz2LSK04DS0pLj/Om1C+o/OJWYIWC4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=sKEl/Cs8; arc=none smtp.client-ip=209.85.210.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="sKEl/Cs8"
Received: by mail-ot1-f48.google.com with SMTP id 46e09a7af769-7cac9225485so7146863a34.3
        for <syzbot@lists.linux.dev>; Mon, 29 Dec 2025 02:20:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767003612; x=1767608412; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=cpmtt9Zl5OShrDLJzRKAeQnIvsmuj7dGzo8Bk4tpXxY=;
        b=sKEl/Cs8G+ngLlDv0aGYw4NFWwRQLSYaukNcT+r05tIYt8pCeKWyURPBTOxNwXisTj
         r44Eia5LyGg2tcxHpCdnQ2RM+H7HmeTOmbFC1ybDofxiPJs/W77eYwLURTuFA7MsAQpK
         ybbe8HjEmor3Jc31K9IdNcmValdj9YHC54FKRpoVlzG0rlvCNz1ytZCJzXCLeD7z0vkN
         8sor3uQ67saifqQJ8Orm54RVY+ErwENh0H587yJBp4zySQBgqAsihYIbDLIHW/RuN2fV
         SsjmsFTThajUshDG7gQo002hO0K/GEqrNkHvvVr0Uh89tAyuLx2jGWmp1gzwCgj/EmS0
         56gg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767003612; x=1767608412;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=cpmtt9Zl5OShrDLJzRKAeQnIvsmuj7dGzo8Bk4tpXxY=;
        b=Kyr3ZHOqge5/ysb8ecL8NJDMbosRaLAxCFgo/FwiIgnleEHXAVns6zMROyMuCnmy8G
         Es3iT9gYlVfXg/1XecETyNK01VKfrImozNl+jZ/Vly3YcA6SyDCQ+UAjLv2DiM9g5Rrj
         Ce+QdHQY89505RYGw16yPhsgh6oq9ydFSWp9X+U3SvJLTekYOQsqFMWrOBktlwbItgm4
         Ih9voOwCU/qwx/CwI3VcRw1XeLou+1DXNoKRKvI9XqkYZW7R3+80y4jngN4cz6zPXOGI
         ETmKpCLnxscq6Al9a492TimKUBOrEEzz+KfgGCBj/AI2tCB5zdciY7C7YbQLhSDK1n47
         sE9w==
X-Forwarded-Encrypted: i=1; AJvYcCV7eDh7UYa6D3vm7kQObJ5XIEI1zRauXX15HDk+EtuQOaGkKaWp4iNYnsU1xnDawmZmFQ7vGTg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyn75/H9iClTGv3RMkRddUe4FCE6ptmPdtvr5246RQt/MZSC3pL
	bnkM21wLMuJ8THSClkrsJ7DI1GS6hYXEIuboYerL0iK71OWCRR0V5StntIGvtDlAhVOnQpBJnZA
	+OtFOaWheA1jRBA7dmD420/udgMhhUXSGohmzeQ/UIOQX5mF5miQqODud
X-Gm-Gg: AY/fxX74mPmyBjgKuLvUdeFx4z5GIrV5C6FqSro2WAi8z/fba2B5gAUUO0Rytf31IPI
	6mzzlpDGFydcvpCNwba36fTJG6D1tdxpxa47fHZY3f+XdogBUepmEFYvQx4XfJkmM7eTPVtPXGE
	g3hzx6QAG1VnG/P4m99iPJU/NYQEvgN4V2iCyNVdOakbJCtWMiJrQoZDhUm5VvLC9jDHtYLQfru
	hYTT9zd4laXb6gYrEnqegO8fOtyT38vhT4b83zXNMLPXiMBltuKl9ob/3JfQO9U4ANtoqR0FLwv
	mJYdP5N15ISZBtk4IlSw0j40r5k6NHiummX/Dnu5aPg+texjxq3SA8bF
X-Google-Smtp-Source: AGHT+IHVzWzsPHZ2Q2UKc2T5fQaRFLBHLMWIqpEidBuwl05+z8vUxPh4PZx0OmKSM3xnAe4vSgtC0JiafmumuerRumk=
X-Received: by 2002:a05:6820:827:b0:659:9a49:8f3b with SMTP id
 006d021491bc7-65d0eb2ef22mr12484129eaf.76.1767003611467; Mon, 29 Dec 2025
 02:20:11 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69524fff.a70a0220.90d62.0038.GAE@google.com>
In-Reply-To: <69524fff.a70a0220.90d62.0038.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 29 Dec 2025 11:20:00 +0100
X-Gm-Features: AQt7F2qvgTooRobjLiG-vczZbb-PPc6VS1HA3ozGBoUloBElfyde4DVQTDN-xVg
Message-ID: <CANp29Y4tzd8b80iqLCFfSbxACo6F3mAPQBQK1Na9dN-rdpfULA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: Improve khugepaged scan logic
To: syzbot ci <syzbot+ci5a1dd5603fd894f8@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Dec 29, 2025 at 10:55=E2=80=AFAM syzbot ci
<syzbot+ci5a1dd5603fd894f8@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] Improve khugepaged scan logic
> https://lore.kernel.org/all/20251229055151.54887-1-yanglincheng@kylinos.c=
n
> * [PATCH v2 1/4] mm: khugepaged: add trace_mm_khugepaged_scan event
> * [PATCH v2 2/4] mm: khugepaged: just skip when the memory has been colla=
psed
> * [PATCH v2 3/4] mm: khugepaged: set VM_NOHUGEPAGE flag when MADV_COLD/MA=
DV_FREE
> * [PATCH v2 4/4] mm: khugepaged: set to next mm direct when mm has MMF_DI=
SABLE_THP_COMPLETELY
>
> and found the following issue:
> WARNING in madvise_dontneed_free
>
> Full report is available here:
> https://ci.syzbot.org/series/f936dff1-2423-4f46-a59a-ea041c1d741a
>
> ***
>
> WARNING in madvise_dontneed_free
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      33b485bade996a9d0154cf0888b7a5c23723121e
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/81f62216-5094-4281-a942-238b7448a=
3be/config
> C repro:   https://ci.syzbot.org/findings/e308c3a0-c806-45c4-bc1c-24536a3=
c3ca3/c_repro
> syz repro: https://ci.syzbot.org/findings/e308c3a0-c806-45c4-bc1c-24536a3=
c3ca3/syz_repro
>
> ------------[ cut here ]------------
> WARNING: mm/madvise.c:795 at get_walk_lock mm/madvise.c:795 [inline], CPU=
#0: syz.0.17/5977
> WARNING: mm/madvise.c:795 at madvise_free_single_vma mm/madvise.c:830 [in=
line], CPU#0: syz.0.17/5977
> WARNING: mm/madvise.c:795 at madvise_dontneed_free+0xb52/0xe10 mm/madvise=
.c:960, CPU#0: syz.0.17/5977
> Modules linked in:
> CPU: 0 UID: 0 PID: 5977 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:get_walk_lock mm/madvise.c:795 [inline]
> RIP: 0010:madvise_free_single_vma mm/madvise.c:830 [inline]
> RIP: 0010:madvise_dontneed_free+0xb52/0xe10 mm/madvise.c:960
> Code: c7 c6 b0 6e 25 8e e8 7d 4c a3 ff 48 83 fb 01 74 0c 83 fb 03 75 0e e=
8 ed 46 a3 ff eb 12 e8 e6 46 a3 ff eb 09 e8 df 46 a3 ff 90 <0f> 0b 90 31 db=
 89 9c 24 08 01 00 00 48 8b 74 24 68 48 8b 54 24 70
> RSP: 0018:ffffc90004a17400 EFLAGS: 00010293
> RAX: ffffffff821e7411 RBX: 0000000000000002 RCX: ffff888169b7d7c0
> RDX: 0000000000000000 RSI: ffffffff8e256eb0 RDI: 0000000000000002
> RBP: ffffc90004a175b0 R08: ffff888169b7d7c0 R09: 0000000000000002
> R10: 0000000000000003 R11: 0000000000000000 R12: 0000000000000000
> R13: dffffc0000000000 R14: 0000000000000100 R15: 1ffff92000942e88
> FS:  0000555555761500(0000) GS:ffff88818e62f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe49d72b600 CR3: 00000001b85b6000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  madvise_vma_behavior+0xd57/0x3680 mm/madvise.c:1385
>  madvise_walk_vmas+0x575/0xaf0 mm/madvise.c:1730
>  madvise_do_behavior+0x38e/0x550 mm/madvise.c:1944
>  do_madvise+0x1bc/0x270 mm/madvise.c:2037
>  __do_sys_madvise mm/madvise.c:2046 [inline]
>  __se_sys_madvise mm/madvise.c:2044 [inline]
>  __x64_sys_madvise+0xa7/0xc0 mm/madvise.c:2044
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe49d78f7c9
> Code: ff ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 40 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 a8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fff39cea178 EFLAGS: 00000246 ORIG_RAX: 000000000000001c
> RAX: ffffffffffffffda RBX: 00007fe49d9e5fa0 RCX: 00007fe49d78f7c9
> RDX: 0000000000000008 RSI: 0000000000600002 RDI: 0000200000000000
> RBP: 00007fe49d7f297f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe49d9e5fa0 R14: 00007fe49d9e5fa0 R15: 0000000000000003
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
> The email will later be sent to:
> [akpm@linux-foundation.org baohua@kernel.org david@kernel.org dev.jain@ar=
m.com lance.yang@linux.dev linux-kernel@vger.kernel.org linux-mm@kvack.org =
lorenzo.stoakes@oracle.com richard.weiyang@gmail.com vernon2gm@gmail.com ya=
nglincheng@kylinos.cn ziy@nvidia.com]
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
-upstream-moderation/69524fff.a70a0220.90d62.0038.GAE%40google.com.
