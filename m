Received: from mail-lj1-f173.google.com (mail-lj1-f173.google.com [209.85.208.173])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D993340DB44
	for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 13:25:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.208.173
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786627549; cv=pass; b=MRCN95TuVCfByEzsAYDL/274BGbf+5ASwD/MEfVWQVdemXDYUYpzXQhReAh3mO1dlFHhkAz0CenlbyqlCIx5oq61PetpscByYBkrdyV1WilEl4mT8sOmrl9P1c3p/vBPLxzcS5TELlRpqhMN0MvaQC6g6r3oUGNvQKnfT+1JLCc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786627549; c=relaxed/simple;
	bh=WYy+2PlQJ5JjSCDRVQB9aDxok8AdlUti/R1iAb4sqzE=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=XWVWBugsipDESe0q217CojkwtcBMAimYE1u78ecMPvpwmOhEgJjpxZyLuMDv8Q5N4qajCSPhouD/IPsbrvLl2BoOkmccf1nJPV+ou32tYXh/wVk/Ex5l12Pl1MsrHnDhL1TxmCwf3zLwt6howGtMnY8bF2iaZ/tI7454lEcgtBg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=XepWI9Y4; arc=pass smtp.client-ip=209.85.208.173
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="XepWI9Y4"
Received: by mail-lj1-f173.google.com with SMTP id 38308e7fff4ca-39faaf1efd3so15499231fa.0
        for <syzbot@lists.linux.dev>; Thu, 13 Aug 2026 06:25:46 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1786627545; cv=none;
        d=google.com; s=arc-20260327;
        b=aPqIHvCboFzkWMyrZREPETpcxNCWIW8Q3WcTy4GG7tFN9U1BnrqtM2Bk4+QmKaN2wM
         QDlJG/olCAcMAW8XmarBXyBOD4O4CESIBQbHRekiKJA4n/RJw2/6/kwVFH20Zw+BhDh6
         kzjHYchCHTMoPQeQbpZDRiGbJMLKqfnny3LZJnWjs8+PLWEePeZGt8qvoSoWp5Agl7uM
         NSD6YEAv76GAnq8zb0k5fdcwkAsPar6Y+QPbOTFEIT5Mw8Gqq9hGus/YwKg3cG4zn5N/
         FfCV4qSX85HRazLZjsV1ZGxNdw0hucC/zOgi+X5mWcQZm/8mHVFKQA3HKQpamNtnp+PQ
         5QaQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=eaEvPQPwNPb5KizvhskDqUtcopP+4eL49oLvbLDSTDM=;
        fh=gHby+VGpV8HcSH9H2YJ30qS84lme8j+IkC3fbg3Ikug=;
        b=ZuNfIkkZt8MgqUdGUctRcBS6qG9pPxHJ3mRrtIidzoypp/iUZOZRWRxluP+Vwt8LeH
         gygs3mNxei+ue5okKtQ46MdBeLCoKFomQrc+MphJq/rUj0g1CsEyyO4D8heFDzUibkLl
         ap+oGhtbcfvqkwiybhmFLfRqe1JOg77/IcxXazmamMJM09OdA2d/tHNL579ySLftzQ0L
         TgeG+FW5aJIf4XayBX8jU2U21nkYsXf402H/laPgp02yDrzWF25/2pG6QTnhoNmaPEm6
         Mzj5x8VMnPs1nbkVr9n8OQxH2XKFClMreTOmfwuKSzFb7uIPaETIlsDj8ni4kU0UWMNQ
         Gv8Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1786627545; x=1787232345; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=eaEvPQPwNPb5KizvhskDqUtcopP+4eL49oLvbLDSTDM=;
        b=XepWI9Y4+Wmnj1RbQzegqnnQVtVXV5FlBzsr45oveWWCr5RK83ATr23wy2q7zvTsDJ
         beXiyalC2hGQPfTWAyQO1MCQfXPRnam76cH6nYBdgOwZ6LRxEfdsGWgFgsZUZrst5fw6
         MqOf/5o/AuTho3rxH7GiO7NVU4ZW3l8tGjqckIg2IGPGHFsaYYZxLAu4MIdpwAy6jqZa
         Lo4plOSdxqEEBLkbMTeoWvyEewqsFgMB8uj4fBBnABosoUjlcPMFyr3BVhSEluwgGXYl
         +I9Ba6yeStiaWhPn8/x9kvkUNcD5a2HQxZc++si+p9I+/cRf7q/6ENO6Jn/2feDAJKVk
         5ugA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786627545; x=1787232345;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=eaEvPQPwNPb5KizvhskDqUtcopP+4eL49oLvbLDSTDM=;
        b=KKD9mvUADkUFM0GXqBL15Hu0OcKuuzHjuISdAdWUK9gmpjbpv4rNbgXQ/dWCcIbObb
         1sKjQC23UZiPqNbRQVcGgMYnSrBMzM3MT8BejroRbUfBQiVwuNKLqFaqTsIbGE42t1yv
         fIvWogkp4SBPMUyP9LUlxaPfU/z0O/MDp4QIAHQ8O2kEi17Dd6zRRkTUSbpmGnschx0y
         TCJlgdipOnxdHcgh6S+RXzEhcawBcQfjpPs/MyO8oW/u4+WU4Jf0aQwUoOWycIQrK8yV
         WcQ7qtPO+XmdpEkDCQeZx3EvTWlSY0vfEvXKoFXRT9SDojNmi1NHL2clkKkW+ni6H/hV
         +sCQ==
X-Forwarded-Encrypted: i=1; AHgh+RorZ4B1M9mm5/wCimF0pczXB23SN8IVXtIeo4SxSVfCkHyDRzse+F2f2kviLWVIexBHDCnhPpo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw8GD2PECdNOVl3oCbARPVN/k5WEFAx9oeNaf9a5pGVVu7mj/u0
	5RfMTxqjVRX/pjJOsdH64LPR3N0CtOROfpc+j0SEHtX7pEoPhAIgLZWsNw+kLUPoEu9wymOg+yw
	BiIBELkxukb0Qb+3wX2wH7qhnV1vPgsbsYWkjwMZU
X-Gm-Gg: AR+sD12Sh8XMZuEMk2Zn/HZ1IzpbRTthb1Wjo1oLQL+lRZD6hDhnaQxLU2cojVLJIwv
	hDLPEfBJyymo0DiPl02DDw5qI2nZS881tvIDzKHth+PB94GDNDUVvY7MiPW0POJy6E8aoRD8Q+Z
	jDfQZskKctqdk7G2SQCNSUvXAYFEZnHN39ubqH60IX87qo9KiCfb9vbV+2CjFv+sHJ8m4BVI905
	1ErXtOfR47oyZImhvNS1ayBchhGpEdT5LUQCZySNEOylzy6QH6HkKfx4Asq3l5Y2Th+oqalndNT
	9MrfTbwJPAvvzzzArKfjeA+sfz26VD9PtazJn8nb4Fc3X4QtyUB5gkj0p/8milHkJkkQTNGaLBP
	rWl5lH0WXTvXkcCCT1TB6lBKgvl33qr0=
X-Received: by 2002:a05:651c:b1e:b0:39b:d04:b783 with SMTP id
 38308e7fff4ca-3a11a791353mr7828721fa.20.1786627544062; Thu, 13 Aug 2026
 06:25:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a7dc5a2.0d56fcf3.329e18.023c.GAE@google.com>
In-Reply-To: <6a7dc5a2.0d56fcf3.329e18.023c.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Thu, 13 Aug 2026 15:25:30 +0200
X-Gm-Features: AUfX_myxpPkAvQ8h2vOgHc9P1_-yjMENFFv6DWoHpihweJtBZXI4XnoPpYphlt8
Message-ID: <CAJWNTGxVb10Cb1d+Bjvt0Gup23WVGX-EfyKXVQHOxbU1Oh9mng@mail.gmail.com>
Subject: Re: [moderation/CI] Re: memcg: fix dying memcg pinned by swapped out
 shmem pages
To: syzbot ci <syzbot+ci495064e28a773da2@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Thu, Aug 13, 2026 at 3:24=E2=80=AFPM syzbot ci
<syzbot+ci495064e28a773da2@syzkaller.appspotmail.com> wrote:
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
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      288058d8db5d35623228d84f48d9bea3707d5c85
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/35dac6f6-b44a-4ea8-9adf-2cdda5584=
e45/config
> syz repro: https://ci.syzbot.org/findings/6e117c0b-d6e2-44a6-8e35-161cb33=
f2aff/syz_repro
>
> ------------[ cut here ]------------
> refcount_t: underflow; use-after-free.
> WARNING: lib/refcount.c:28 at refcount_warn_saturate+0xb2/0x110 lib/refco=
unt.c:28, CPU#0: syz.2.19/5863
> Modules linked in:
> CPU: 0 UID: 0 PID: 5863 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:refcount_warn_saturate+0xb2/0x110 lib/refcount.c:28
> Code: 64 84 8e 0b 67 48 0f b9 3a eb 4a e8 58 fa f2 fc 48 8d 3d 61 84 8e 0=
b 67 48 0f b9 3a eb 37 e8 45 fa f2 fc 48 8d 3d 5e 84 8e 0b <67> 48 0f b9 3a=
 eb 24 e8 32 fa f2 fc 48 8d 3d 5b 84 8e 0b 67 48 0f
> RSP: 0018:ffffc90003bbf1d0 EFLAGS: 00010293
> RAX: ffffffff84d3ed9b RBX: 0000000000000003 RCX: ffff8881bdf58000
> RDX: 0000000000000000 RSI: ffffffff8f363380 RDI: ffffffff90627200
> RBP: 1ffffffff20ae968 R08: ffff8881bdf58000 R09: 0000000000000005
> R10: 0000000000000004 R11: 0000000000000000 R12: ffff8881026f8000
> R13: ffff88810a914100 R14: ffff88810a914134 R15: 1ffff110204df009
> FS:  00007fe2ee63d6c0(0000) GS:ffff88818d960000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000056066247f0b8 CR3: 000000000e946000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  mem_cgroup_take_from_private_id mm/memcontrol.c:4049 [inline]
>  __mem_cgroup_uncharge_swap+0x204/0x2a0 mm/memcontrol.c:5707
>  mem_cgroup_uncharge_swap include/linux/swap.h:520 [inline]
>  __swap_cluster_free_entries+0x735/0xc50 mm/swapfile.c:1955
>  swap_put_entries_cluster+0x3b1/0x4b0 mm/swapfile.c:1629
>  swap_put_entries_direct+0x137/0x210 mm/swapfile.c:2139
>  zap_nonpresent_ptes mm/memory.c:1838 [inline]
>  do_zap_pte_range mm/memory.c:1905 [inline]
>  zap_pte_range mm/memory.c:2003 [inline]
>  zap_pmd_range mm/memory.c:2089 [inline]
>  zap_pud_range mm/memory.c:2117 [inline]
>  zap_p4d_range mm/memory.c:2138 [inline]
>  __zap_vma_range+0x1d9d/0x4f10 mm/memory.c:2178
>  unmap_vmas+0x390/0x550 mm/memory.c:2247
>  exit_mmap+0x293/0x9f0 mm/mmap.c:1315
>  __mmput+0x118/0x420 kernel/fork.c:1187
>  exit_mm+0x221/0x2d0 kernel/exit.c:615
>  do_exit+0x6cd/0x2360 kernel/exit.c:997
>  do_group_exit+0x22d/0x2f0 kernel/exit.c:1152
>  get_signal+0x121b/0x12c0 kernel/signal.c:3046
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
> RIP: 0033:0x7fe2ed79e0d9
> Code: Unable to access opcode bytes at 0x7fe2ed79e0af.
> RSP: 002b:00007fe2ee63d0e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> RAX: fffffffffffffe00 RBX: 00007fe2eda25fa8 RCX: 00007fe2ed79e0d9
> RDX: 0000000000000000 RSI: 0000000000000080 RDI: 00007fe2eda25fa8
> RBP: 00007fe2eda25fa0 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe2eda26038 R14: 00007fff0bed41b0 R15: 00007fff0bed4298
>  </TASK>
> ----------------
> Code disassembly (best guess):
>    0:   64 84 8e 0b 67 48 0f    test   %cl,%fs:0xf48670b(%rsi)
>    7:   b9 3a eb 4a e8          mov    $0xe84aeb3a,%ecx
>    c:   58                      pop    %rax
>    d:   fa                      cli
>    e:   f2 fc                   repnz cld
>   10:   48 8d 3d 61 84 8e 0b    lea    0xb8e8461(%rip),%rdi        # 0xb8=
e8478
>   17:   67 48 0f b9 3a          ud1    (%edx),%rdi
>   1c:   eb 37                   jmp    0x55
>   1e:   e8 45 fa f2 fc          call   0xfcf2fa68
>   23:   48 8d 3d 5e 84 8e 0b    lea    0xb8e845e(%rip),%rdi        # 0xb8=
e8488
> * 2a:   67 48 0f b9 3a          ud1    (%edx),%rdi <-- trapping instructi=
on
>   2f:   eb 24                   jmp    0x55
>   31:   e8 32 fa f2 fc          call   0xfcf2fa68
>   36:   48 8d 3d 5b 84 8e 0b    lea    0xb8e845b(%rip),%rdi        # 0xb8=
e8498
>   3d:   67                      addr32
>   3e:   48                      rex.W
>   3f:   0f                      .byte 0xf
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [akpm@linux-foundation.org axelrasmussen@google.com baohua@kernel.org bfg=
uo@icloud.com bingfangguo@tencent.com cgroups@vger.kernel.org david@fromorb=
it.com david@kernel.org devnull@kernel.org hannes@cmpxchg.org kasong@tencen=
t.com linux-kernel@vger.kernel.org linux-mm@kvack.org ljs@kernel.org mhocko=
@kernel.org muchun.song@linux.dev qi.zheng@linux.dev roman.gushchin@linux.d=
ev shakeel.butt@linux.dev weixugc@google.com yuanchu@google.com]
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
-upstream-moderation/6a7dc5a2.0d56fcf3.329e18.023c.GAE%40google.com.



--=20
=E2=B2=A0=E2=B2=9F=E2=B2=93=E2=B2=99=E2=B2=8F=E2=B2=9B =E2=B2=84=E2=B2=89=
=E2=B2=B1=E2=B2=A3=E2=B2=85=E2=B2=93=E2=B2=9F=E2=B2=A5 - Pimyn Girgis
Software Engineer
Kernel Dynamic Analysis
pimyn@google.com
