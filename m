Received: from mail-oo1-f72.google.com (mail-oo1-f72.google.com [209.85.161.72])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3145332ED6
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 17:04:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.72
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786640679; cv=none; b=NKnNdacT5ayEywvZAva6Xj+NXS2nCq8oWl4BRtjGKXmzqHMSwcjnOtFi8O1dMjt9YeaxZUI4oQtNLoJ4Ry91Ka7PO32+ObAKWJGA8Csue3FVM6VuHFMqIkROfnkEec1L8aqtmkWy2nlAtAKZ/K0KJHiBdJBCP4BCTOgxjH1GOc8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786640679; c=relaxed/simple;
	bh=50DugiIQWi8Z4qly/beyRYxklJeoRMHE1rJX26+uWqw=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=U07xdOXddLrU3q97fCz25KdkyIanOu2/SQ6eSMehu/hKL6noqFZJY8/uV+Go/YVmT+CazivBn6o8ldHwR+Wh4OUBqsWu3FB9xmYYUnUDSmAFr9NibldMpjlSu8s43iUmh9IHGAtxtCSwWN4GxR8I3X1STAl+evoBqpWI3uakIVo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.161.72
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oo1-f72.google.com with SMTP id 006d021491bc7-6aaefd6909fso78817eaf.2
        for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 10:04:37 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786640677; x=1787245477;
        h=content-transfer-encoding:content-type:cc:to:from:subject
         :message-id:in-reply-to:date:mime-version:x-gm-message-state:from:to
         :cc:subject:date:message-id:reply-to:content-type;
        bh=aLcVNY60z5MQnOaSKzB2VQrnJbn3k9ZgMZajiq6fCck=;
        b=pFpCa11PXWxQkm4kZp0iAL48oAQsER+NR0XWSDtbXsCn4H8r8zfnDtgRylOAu6nOAN
         ccpT+3wU6XLavVI2IrYx9RC9wMv3efu8IkZc7qh18StElM553VxEYfCdbYT0aA4WuDoO
         nD/8MvQf2InHi4cKIUbaCGEygY+sw1pjTFq8wHCgvaTgCQJU+TQolrgMZ5FISt/Mm0aY
         5JlljYVD1BkU7isNxhM2tYFK8zclTeZkuubXtuFQVGWn5HNWGH/mccVlBG5dB9h/ZG6t
         YvRY4pRBnlz/EeoI8pJ9SruSECnhkM1hjlkEyCfMV2HhXGcpkGX34hauWfccsBtqvBAt
         zeUg==
X-Forwarded-Encrypted: i=1; AHgh+Rq7432LW+HFy09WnlQLtzv5rhna6r+MQBLLzr9P5ypca+WNoAtyvuKNDymoR9V9MSsfSyu20q8=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqI245+/cQ83eArRuVQm7/C20NB/ajk0KscpfD9/wl2YpM/cyL
	SHcKcAuKb8sE/J2ZaMoe6QfARayEiz2Hl3KF1rfu0sjMZrv5PnS3aCIwLWq2jQaEFq3YBuKAXix
	aUrocS8QnshmZE2HSC4YjcWR2iOXXw08maoLISorzVGfvWpyLsbroNs0nuyM=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a4a:ee19:0:b0:69e:3e6b:c07 with SMTP id
 006d021491bc7-6b0c41be2e9mr6225322eaf.5.1786640676831; Thu, 13 Aug 2026
 10:04:36 -0700 (PDT)
Date: Thu, 13 Aug 2026 10:04:36 -0700
In-Reply-To: <6a7df8b5.0d56fcf3.329e18.0242.GAE@google.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7df924.ec5dc6cc.21cb3f.00b9.GAE@google.com>
Subject: Re: Forwarded: Re: [Internet][syzbot ci] Re: memcg: fix dying memcg
 pinned by swapped out shmem pages
From: syzbot ci <syzbot@syzkaller.appspotmail.com>
To: syzbot@syzkaller.appspotmail.com
Cc: bingfangguo@tencent.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

> For archival purposes, forwarding an incoming command email to
> syzbot@lists.linux.dev.
>
> ***
>
> Subject: Re: [Internet][syzbot ci] Re: memcg: fix dying memcg pinned by s=
wapped out shmem pages
> Author: bingfangguo@tencent.com
>
> #syz test

Please attach the patch to act upon.

>
>
>
>                     syzbot ci<syzbot+ci49bb3ed471ef5f9f@syzkaller.appspot=
mail.com&gt;&nbsp;=E5=9C=A8 2026=E5=B9=B48=E6=9C=8813=E6=97=A5 =E5=91=A8=E5=
=9B=9B 21:26 =E5=86=99=E9=81=93=EF=BC=9A
>
> syzbot ci has tested the following series
>
> [v1] memcg: fix dying memcg pinned by swapped out shmem pages
> https://lore.kernel.org/all/20260813-memcgid-objcg-v1-0-83d21c685b77@tenc=
ent.com
> * [PATCH RFC 1/5] memcg: move memcg private ID refcount to objcg
> * [PATCH RFC 2/5] memcg: get stable memcg first before getting memcgid re=
ference
> * [PATCH RFC 3/5] memcg: remove retry logic in mem_cgroup_private_id_get_=
online
> * [PATCH RFC 4/5] memcg: add a helper to get online memcg from memcgid
> * [PATCH RFC 5/5] memcg: filter out reparented memcgs got using memcgid
>
> and found the following issue:
> WARNING: refcount bug in __mem_cgroup_uncharge_swap
>
> Full report is available here:
> https://ci.syzbot.org/series/3a8a2a5f-8b6d-4abf-954e-a1a18ee62748
>
> ***
>
> WARNING: refcount bug in __mem_cgroup_uncharge_swap
>
> tree:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; linux-next
> URL:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; https://kernel.googlesource.com/=
pub/scm/linux/kernel/git/next/linux-next
> base:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 288058d8db5d35623228d84f48d9bea3707d5=
c85
> arch:&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; amd64
> compiler:&nbsp; Debian clang version 22.1.8 (++20260613092233+e80beda6e25=
5-1~exp1~20260613092250.77), Debian LLD 22.1.8
> config:&nbsp;&nbsp;&nbsp; https://ci.syzbot.org/builds/35dac6f6-b44a-4ea8=
-9adf-2cdda5584e45/config
> syz repro: https://ci.syzbot.org/findings/6e117c0b-d6e2-44a6-8e35-161cb33=
f2aff/syz_repro
>
> ------------[ cut here ]------------
> refcount_t: underflow; use-after-free.
> WARNING: lib/refcount.c:28 at refcount_warn_saturate+0xb2/0x110 lib/refco=
unt.c:28, CPU#0: syz.2.19/5863
> Modules linked in:
> CPU: 0 UID: 0 PID: 5863 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)=20
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:refcount_warn_saturate+0xb2/0x110 lib/refcount.c:28
> Code: 64 84 8e 0b 67 48 0f b9 3a eb 4a e8 58 fa f2 fc 48 8d 3d 61 84 8e 0=
b 67 48 0f b9 3a eb 37 e8 45 fa f2 fc 48 8d 3d 5e 84 8e 0b <67&gt; 48 0f b9=
 3a eb 24 e8 32 fa f2 fc 48 8d 3d 5b 84 8e 0b 67 48 0f
> RSP: 0018:ffffc90003bbf1d0 EFLAGS: 00010293
> RAX: ffffffff84d3ed9b RBX: 0000000000000003 RCX: ffff8881bdf58000
> RDX: 0000000000000000 RSI: ffffffff8f363380 RDI: ffffffff90627200
> RBP: 1ffffffff20ae968 R08: ffff8881bdf58000 R09: 0000000000000005
> R10: 0000000000000004 R11: 0000000000000000 R12: ffff8881026f8000
> R13: ffff88810a914100 R14: ffff88810a914134 R15: 1ffff110204df009
> FS:&nbsp; 00007fe2ee63d6c0(0000) GS:ffff88818d960000(0000) knlGS:00000000=
00000000
> CS:&nbsp; 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000056066247f0b8 CR3: 000000000e946000 CR4: 00000000000006f0
> Call Trace:
> &nbsp;<TASK&gt;
> &nbsp;mem_cgroup_take_from_private_id mm/memcontrol.c:4049 [inline]
> &nbsp;__mem_cgroup_uncharge_swap+0x204/0x2a0 mm/memcontrol.c:5707
> &nbsp;mem_cgroup_uncharge_swap include/linux/swap.h:520 [inline]
> &nbsp;__swap_cluster_free_entries+0x735/0xc50 mm/swapfile.c:1955
> &nbsp;swap_put_entries_cluster+0x3b1/0x4b0 mm/swapfile.c:1629
> &nbsp;swap_put_entries_direct+0x137/0x210 mm/swapfile.c:2139
> &nbsp;zap_nonpresent_ptes mm/memory.c:1838 [inline]
> &nbsp;do_zap_pte_range mm/memory.c:1905 [inline]
> &nbsp;zap_pte_range mm/memory.c:2003 [inline]
> &nbsp;zap_pmd_range mm/memory.c:2089 [inline]
> &nbsp;zap_pud_range mm/memory.c:2117 [inline]
> &nbsp;zap_p4d_range mm/memory.c:2138 [inline]
> &nbsp;__zap_vma_range+0x1d9d/0x4f10 mm/memory.c:2178
> &nbsp;unmap_vmas+0x390/0x550 mm/memory.c:2247
> &nbsp;exit_mmap+0x293/0x9f0 mm/mmap.c:1315
> &nbsp;__mmput+0x118/0x420 kernel/fork.c:1187
> &nbsp;exit_mm+0x221/0x2d0 kernel/exit.c:615
> &nbsp;do_exit+0x6cd/0x2360 kernel/exit.c:997
> &nbsp;do_group_exit+0x22d/0x2f0 kernel/exit.c:1152
> &nbsp;get_signal+0x121b/0x12c0 kernel/signal.c:3046
> &nbsp;arch_do_signal_or_restart+0xbb/0x860 arch/x86/kernel/signal.c:337
> &nbsp;__exit_to_user_mode_loop kernel/entry/common.c:66 [inline]
> &nbsp;exit_to_user_mode_loop+0x104/0x730 kernel/entry/common.c:101
> &nbsp;__exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [i=
nline]
> &nbsp;syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:=
230 [inline]
> &nbsp;syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
> &nbsp;do_syscall_64+0x353/0x580 arch/x86/entry/syscall_64.c:100
> &nbsp;entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe2ed79e0d9
> Code: Unable to access opcode bytes at 0x7fe2ed79e0af.
> RSP: 002b:00007fe2ee63d0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 00007fe2eda25fa8 RCX: 00007fe2ed79e0d9
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fe2eda25fa8
> RBP: 00007fe2eda25fa0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe2eda26038 R14: 00007fff0bed41b0 R15: 00007fff0bed4298
> &nbsp;</TASK&gt;
> ----------------
> Code disassembly (best guess):
> &nbsp;&nbsp; 0:	64 84 8e 0b 67 48 0f 	test&nbsp;&nbsp; %cl,%fs:0xf48670b(=
%rsi)
> &nbsp;&nbsp; 7:	b9 3a eb 4a e8&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 	mov&n=
bsp;&nbsp;&nbsp; $0xe84aeb3a,%ecx
> &nbsp;&nbsp; c:	58&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 	pop&nbsp;&nbsp;&nbsp=
; %rax
> &nbsp;&nbsp; d:	fa&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&=
nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 	cli
> &nbsp;&nbsp; e:	f2 fc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbs=
p;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 	repnz cld
> &nbsp; 10:	48 8d 3d 61 84 8e 0b 	lea&nbsp;&nbsp;&nbsp; 0xb8e8461(%rip),%r=
di&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; # 0xb8e8478
> &nbsp; 17:	67 48 0f b9 3a&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 	ud1&nbsp;&=
nbsp;&nbsp; (%edx),%rdi
> &nbsp; 1c:	eb 37&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 	jmp&nbsp;&nbsp;&nbsp; 0x55
> &nbsp; 1e:	e8 45 fa f2 fc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 	call&nbsp;=
&nbsp; 0xfcf2fa68
> &nbsp; 23:	48 8d 3d 5e 84 8e 0b 	lea&nbsp;&nbsp;&nbsp; 0xb8e845e(%rip),%r=
di&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; # 0xb8e8488
> * 2a:	67 48 0f b9 3a&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 	ud1&nbsp;&nbsp;=
&nbsp; (%edx),%rdi <-- trapping instruction
> &nbsp; 2f:	eb 24&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nb=
sp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 	jmp&nbsp;&nbsp;&nbsp; 0x55
> &nbsp; 31:	e8 32 fa f2 fc&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 	call&nbsp;=
&nbsp; 0xfcf2fa68
> &nbsp; 36:	48 8d 3d 5b 84 8e 0b 	lea&nbsp;&nbsp;&nbsp; 0xb8e845b(%rip),%r=
di&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; # 0xb8e8498
> &nbsp; 3d:	67&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 	addr32
> &nbsp; 3e:	48&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 	rex.W
> &nbsp; 3f:	0f&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;=
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp; 	.byte 0xf
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
> &nbsp; Tested-by: syzbot@syzkaller.appspotmail.com
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
> &nbsp; incremental fix).
> - To test a new version of the whole series, please send it directly
> &nbsp; to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
