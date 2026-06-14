Received: from mail-oo1-f51.google.com (mail-oo1-f51.google.com [209.85.161.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AEC773770B
	for <syzbot@lists.linux.dev>; Sun, 14 Jun 2026 06:33:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.161.51
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781418787; cv=pass; b=NtBEWZdGjhdvl7mDoPV82/ZW6WipDkdTnL/shqQallpGuG6CYe0kCDSs9KLjckf3e77kElmjVqpLGbRKHAFmcx4avT94l643fIY/tRhIztOIqVDWrKeGhebncvNeD0qAn2kT3rBwZk1Z6bZz2M3Kq8mfL8GTh92nLV7xuLuix9I=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781418787; c=relaxed/simple;
	bh=M+XhqpW4XhpYZptvc0ity/SsjJTdwj6XnaoXU4LNznM=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Nfp3C1wnLggZLKeEoG1PtQyBq5Af7ox1JFb14eopNbBl5RwgEP6+SZvvePSVc3DXvUh1azQvABsPtu893VCWqehANqQnCRgkJneBkgA7wPf4eE6y1+nfdxrX4lxowHpKcF56hN4Xc3ZwGwXCU/UkTGvtCdFLUxnzF7gkYKdzH0k=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=J+ymtT57; arc=pass smtp.client-ip=209.85.161.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="J+ymtT57"
Received: by mail-oo1-f51.google.com with SMTP id 006d021491bc7-69e43b02308so1012869eaf.1
        for <syzbot@lists.linux.dev>; Sat, 13 Jun 2026 23:33:05 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781418784; cv=none;
        d=google.com; s=arc-20240605;
        b=H4sdGXaITukBEwWWZdKHbbHk8723Anr7U52xTcENJu3xccDn4MgoYzUeDf7VG89+7l
         KwY4mdrr4wVfonoDXyY69EENFZ4xZUB/MfibiTC+3V7jMz/HKydQI75dkNej6Itp5Cjn
         EJZ0iJnVDvpaQzRWIZrn2Cc4tN6pdlot3L/HHM+v+jOZAIL6p4167dxTlklCNijUI8m/
         62rzLtL3ScgIKeQDDguxZsc0Y9QOoIwKDg7uOokCl25gtFO0c7rOsjDDUtpvcflCcUkr
         bXZojQW+VdxVMQycyneDr1+TxGGU7w7nIHkBMN3sav+jlmIkYIOjAawn5ePxKrcDR6xo
         sBlQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=SG67pZb0qzoy7Ih9os7Tz2JlTiweapFYjZA5fB0TAIU=;
        fh=gd5ANIrCP8u1z7D4cSnEQQrY63+pQg6nV26SnOG8oZE=;
        b=PbGBDgWMnEKYR/ap7sMEW02xeQpzrHPorJOZ84ppxstkX4kO398nTxs6MEFYnpVrwf
         ASzDnGrgdSRCkerNChIStpuZIfr2mmhG7PMSZoWdnEAVMNToOGcAGyvEd+OcV4Mhvr19
         AZUyxDNWEN4Kn8Vha3+ZYqwe9IKU+nju66H0rg8RsfsAvmuZULJmyVtcRRSwlh2Q7tgb
         pSRwubSjN3k+tyxSHaVbljiAP4dNCJ6U1iU6Cg8KRBzLuePfiDPrPU+io/Br5ounESQ6
         zwmJjnlj7WoUrR/71fIAjtFa3f+wvZJFykhSh10Bjl+QIt7xZwoFxxIirgugUoc/xRh9
         qzgA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781418784; x=1782023584; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=SG67pZb0qzoy7Ih9os7Tz2JlTiweapFYjZA5fB0TAIU=;
        b=J+ymtT57K8Z1S7Ein822KDKjJCpxpIAEvdqp+JoKSUgJrvuweLJsgKTOXHoBsZ4juL
         wddUJKl4o6/xSJAbKBxwdNniYEWnX5W3s4Zn4eu2mr87wEG1kuU+zSfijVuktIXb53dk
         cy9H3GIojD+KqVr9N0ZbxsTG+o7kSlZpWBK8OJOg62Z4t9QL0HvRzGvGJVNziHhjekkY
         gAFDlxhWnBLbat17F9Jc33a64RwBR3ZduqIgOq7YyD9YKPlIBrK59qaNsZ0u2jo8DnPS
         HaHqvdDpLYTTebdlZGmAvsiude9AoVEGuL6PUXPrNXoW8y6cnClgPUt4Iw8PaesAfyEh
         h7JA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781418784; x=1782023584;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=SG67pZb0qzoy7Ih9os7Tz2JlTiweapFYjZA5fB0TAIU=;
        b=Th+TEm2txxQRp+hOpCb1lIlAOl6hszzhdfuHa61BHfnR08TXUhHsjE3T6PxGyVCxiN
         F4lWJgMvPdsSXlpiox3zHSM9VNmQhzIz/fn9Vlc/3eabRLOSXKTnmWHPEmNaJ5SOARPl
         tY2+H8kKNioHOjifIjxwyZl7QwijTEN0B2TIjYm1Y3lHOPJwDfRnW8KCWDJcyVuQOyO6
         Opy6RWTUKwM/mgnuuRIx93+yFJ+mljFXSTkTewjRO7EcLE6h4Vy7DK+rwaeVyFcJecbB
         RKB8F31DhU89i8MBLeskw6WhOBnFQjfYgRFFIyEF+jcBlng6fhDgaSMyr7pj8Y2MYcrw
         v4UQ==
X-Forwarded-Encrypted: i=1; AFNElJ9W0HXh0L+0F6fKdiuwQMMGBCoSQjcLqOG9SX0/jiu3oMgmu5OjNX2C+gfT6+L3R2Li4FhIRR8=@lists.linux.dev
X-Gm-Message-State: AOJu0YxTtz8gMuV65OsBuc13sqN9PZBgdScNW4Hjl4ek5eFVjiWPgd99
	IxMaApSv4u/hPsGfsto7Vu09ObkwQ10hqq4HyBWfGqaBSlnWgkckpAhaGM9OOT+Kgm+jUOuJQPh
	X6jSs/xzTNt7T1msnhnS7T84n0cgS2ptFFIhC8ydUhAzpKiQaE/t4vxw6
X-Gm-Gg: Acq92OE785M5sKQoFcpu8uavd/RU+iu29UwohlPTOOJiHBJIVdtPqHYDQ2LCT7l6sFE
	GXwzej3JNozKsiO6ZNnPFvmETEMQ0TOovEqMMnuaZJFljD3Jrr18yqzz5LhcBbEUJeCupiVc6nX
	QW1YJ9MwWasEG2eOfmHbQZ/OcPNsmmumayuu6u9UYjr1L16wjiyF7LhYbvy5vVMdEKIHzMU2U47
	jqIn5V2uk291WDH0nct2rVa/9EJoOL+PTAkX11tDNMkREN4CN1U7j0yCJ/FBeGDfY/KnuNgzfnI
	yjSSvFAuFSUl3EOcVai6mxWVP5Gdka2YIWWabO7WQgUWYAj4N/s33l4ieFymaOpjuwGvrHfqYXZ
	ESPMhNEt+gl6u4fYotp1hUMs/ZqMLzn98+3VH9//kfu64gf9xfdxeUbjjtfs8Hs+/
X-Received: by 2002:a05:6820:1c8c:b0:69e:14a:f315 with SMTP id
 006d021491bc7-69eecaa5c9emr3343131eaf.52.1781418784034; Sat, 13 Jun 2026
 23:33:04 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a2e2eb0.428ffe26.258b27.0168.GAE@google.com>
In-Reply-To: <6a2e2eb0.428ffe26.258b27.0168.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 14 Jun 2026 08:32:51 +0200
X-Gm-Features: AVVi8Cd0xyrVQzIdApKiF8-He611bZyH-UXjzh5AtUHawAMi8Swv3dk-gU4bfiM
Message-ID: <CANp29Y63eV1K60tC=M2FzMEgDjWVLun=Hf+dmHO-TApOqY26LA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/vmalloc: migrate vmap_area indexing from
 rb-tree to maple-tree
To: syzbot ci <syzbot+ci34c7b37b40b7f21d@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Jun 14, 2026 at 6:31=E2=80=AFAM syzbot ci
<syzbot+ci34c7b37b40b7f21d@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] mm/vmalloc: migrate vmap_area indexing from rb-tree to maple-tree
> https://lore.kernel.org/all/20260613-vmalloc_maple-v1-0-0aa740bb944b@oss.=
qualcomm.com
> * [PATCH RFC 01/12] mm/vmalloc: introduce maple_tree-based indexing for v=
map_area
> * [PATCH RFC 02/12] mm/vmalloc: convert allocation-side gap finding and i=
nsertion to maple_tree
> * [PATCH RFC 03/12] mm/vmalloc: convert free, purge, and pcpu paths to ma=
ple_tree
> * [PATCH RFC 04/12] mm/vmalloc: finalize maple-only indexing and shrink s=
truct vmap_area
> * [PATCH RFC 05/12] mm/vmalloc: tighten failure handling under memory pre=
ssure
> * [PATCH RFC 06/12] mm/vmalloc: tighten alloc/free hot paths
> * [PATCH RFC 07/12] mm/vmalloc: consolidate occupied tree as authoritativ=
e index on hot path
> * [PATCH RFC 08/12] mm/vmalloc: track lazy-purge queue as a list_head
> * [PATCH RFC 09/12] mm/vmalloc: collapse busy-tree find-then-unlink into =
a single mas_erase
> * [PATCH RFC 10/12] mm/vmalloc: per-CPU caching of free ranges from the m=
aple_tree allocator
> * [PATCH RFC 11/12] mm/vmalloc: O(1) lookup of cached vmap_areas with bou=
nded fast-reject
> * [PATCH RFC 12/12] mm/vmalloc: harden bump-allocator alloc/free against =
UBSAN array bounds
>
> and found the following issue:
> WARNING in alloc_vmap_area
>
> Full report is available here:
> https://ci.syzbot.org/series/45e14120-bbb8-4a0c-b5c6-0aaf3b421101
>
> ***
>
> WARNING in alloc_vmap_area
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      c425609d6ac4012c8bbf01ec2e10e801b1923a7b
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/481f4f4b-8d55-4e3c-b96c-1de7b7636=
86d/config
> syz repro: https://ci.syzbot.org/findings/ae02a227-b4c3-476a-826b-3bbf18b=
dbfe4/syz_repro
>
> ------------[ cut here ]------------
> (*left)->va_end > start
> WARNING: mm/vmalloc.c:1371 at find_vmap_area_insert_neighbors_mt_locked m=
m/vmalloc.c:1371 [inline], CPU#0: syz.0.17/5834
> WARNING: mm/vmalloc.c:1371 at validate_vmap_area_range_insert_mt_locked m=
m/vmalloc.c:1388 [inline], CPU#0: syz.0.17/5834
> WARNING: mm/vmalloc.c:1371 at insert_vmap_area_busy_locked mm/vmalloc.c:1=
480 [inline], CPU#0: syz.0.17/5834
> WARNING: mm/vmalloc.c:1371 at alloc_vmap_area+0x5458/0x87f0 mm/vmalloc.c:=
2917, CPU#0: syz.0.17/5834
> Modules linked in:
> CPU: 0 UID: 0 PID: 5834 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT_{=
RT,(full)}
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:find_vmap_area_insert_neighbors_mt_locked mm/vmalloc.c:1371 [in=
line]
> RIP: 0010:validate_vmap_area_range_insert_mt_locked mm/vmalloc.c:1388 [in=
line]
> RIP: 0010:insert_vmap_area_busy_locked mm/vmalloc.c:1480 [inline]
> RIP: 0010:alloc_vmap_area+0x5458/0x87f0 mm/vmalloc.c:2917
> Code: a5 ff e9 fc 0f 00 00 e8 e6 80 a5 ff 4c 8b 74 24 18 e9 ed 17 00 00 e=
8 d7 80 a5 ff 90 0f 0b 90 e9 34 e5 ff ff e8 c9 80 a5 ff 90 <0f> 0b 90 4c 8b=
 74 24 18 eb 09 e8 b9 80 a5 ff 90 0f 0b 90 49 bf 00
> RSP: 0018:ffffc90031ade360 EFLAGS: 00010293
> RAX: ffffffff82200aa7 RBX: ffffffffa0000000 RCX: ffff888109e2bb80
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc90031adf4f8 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000100 R11: 0000000000000003 R12: ffff88810007d888
> R13: ffffffffa0002000 R14: ffffffffa0401000 R15: ffffc90031adeb80
> FS:  00007f97268b66c0(0000) GS:ffff88818e8af000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f9727132780 CR3: 000000010cd9e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __get_vm_area_node+0x1f8/0x300 mm/vmalloc.c:4214
>  __vmalloc_node_range_noprof+0x36a/0x1750 mm/vmalloc.c:5030
>  execmem_vmalloc+0xa7/0x1d0 mm/execmem.c:41
>  bpf_dispatcher_change_prog+0x25d/0xd70 kernel/bpf/dispatcher.c:151
>  bpf_prog_test_run_xdp+0x794/0x1160 net/bpf/test_run.c:1464
>  bpf_prog_test_run+0x2cd/0x340 kernel/bpf/syscall.c:4859
>  __sys_bpf+0xa20/0xd90 kernel/bpf/syscall.c:6436
>  __do_sys_bpf kernel/bpf/syscall.c:6537 [inline]
>  __se_sys_bpf kernel/bpf/syscall.c:6534 [inline]
>  __x64_sys_bpf+0xba/0xd0 kernel/bpf/syscall.c:6534
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x174/0x580 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f972725ce59
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f97268b6028 EFLAGS: 00000246 ORIG_RAX: 0000000000000141
> RAX: ffffffffffffffda RBX: 00007f97274d5fa0 RCX: 00007f972725ce59
> RDX: 0000000000000050 RSI: 0000200000000b80 RDI: 000000000000000a
> RBP: 00007f97272f2d6f R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f97274d6038 R14: 00007f97274d5fa0 R15: 00007ffd7848c2a8
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
> [akpm@linux-foundation.org aliceryhl@google.com andrewjballance@gmail.com=
 balbirs@nvidia.com dev.jain@arm.com dvyukov@google.com elver@google.com gl=
ider@google.com jackmanb@google.com liam@infradead.org linux-arm-msm@vger.k=
ernel.org linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org ma=
ple-tree@lists.infradead.org neil.armstrong@linaro.org praan@google.com pra=
njal.arya@oss.qualcomm.com puranjay@kernel.org santosh.shukla@amd.com shuah=
@kernel.org smostafa@google.com sudeep.holla@kernel.org surenb@google.com s=
uzuki.poulose@arm.com urezki@gmail.com will@kernel.org wkarny@gmail.com]
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
-upstream-moderation/6a2e2eb0.428ffe26.258b27.0168.GAE%40google.com.
