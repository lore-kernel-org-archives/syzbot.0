Received: from mail-wm1-f49.google.com (mail-wm1-f49.google.com [209.85.128.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D3DE234750A
	for <syzbot@lists.linux.dev>; Mon, 20 Apr 2026 18:07:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.49
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776708422; cv=pass; b=TzuiJbA1QPJy8++PbLyTljzCGeje7bMy55N9QeAmLuBeJNdqaG8w7eSg3v92mt4OZtpK8q2BFcGfqhuzy0gi+L3Jdq9lS3qluBynMcq6wHwhljXh0vHYRC7AlVcVSl1e7c1rWyX1BPjeuQoglklUHkiiYM82LaVI4PvPrRIoWbE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776708422; c=relaxed/simple;
	bh=imiG7EmeDsKoC7S5RyDLWgNhO9dUUHChrxTg4sg66pg=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=UlqXSqSIIqCqXFXn5vAXP2ddcpJzJeGlgpGP8otfzNNNBEOpS1R2fsfl/Qr4pTTfSFu+zlJTruM+HHHSW8IwF+exI1mU4iKDNbRTh2QcdcNxZDzgA1jeUb8NBja9wsDIZ1j6iTMSrTgszf5VEZFWlQOXz6i+9X+OHNdui1FrAxU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=L11Kl2tt; arc=pass smtp.client-ip=209.85.128.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="L11Kl2tt"
Received: by mail-wm1-f49.google.com with SMTP id 5b1f17b1804b1-4891cd41959so13435085e9.3
        for <syzbot@lists.linux.dev>; Mon, 20 Apr 2026 11:07:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1776708419; cv=none;
        d=google.com; s=arc-20240605;
        b=htH28Yy6AtsijUb2owzSv/s/bAcmp1BpS1anQ/dgDQC1Jsz278Wnr6w3lkRqGqGCuA
         xTIahb/DhwlQkX+ncPp8oq9/ZF1ppT7c45DeSMQ8fkDFz6rI6dljSr5g2F2kdqaNGZ6y
         rc+KecR65gIlOiNuSx+Jfo9+0/nUtkAWdyeF4CAZMhyoVBt7HA/FYIiRAWzthwhW3+8x
         DcUSM14/U4+aRl0gtbA21a7ngxR+Dm4OenMsZAnuUd+5jp4J6NZY1U4D4sFPt2IT8pyA
         8RDSgKKG7vWwwsN65trU32VU44E8HrincHbfEk42fwUhHl0aPdWLe2SmADovq/UJMGU/
         Va/w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=Zpkldx8niJ7CMC04uLX4giTSMVoRQNUM3kH1mJl4DpY=;
        fh=+5CCkJRj9o9SZ+gFp/RMWtXCjuGVIXdMIef2D6/Wo5Y=;
        b=QzKXIp61cHWRRHWFGYBwhK+LO5cub/jk+JBSMvQ9k56sYSb3vwWcLJVJMnSF2E8wX9
         h4vvU/4uNcDp3V2wMmg7w7Pptg7LRnocj1wktk2RfrIy4HGEfp6mivqypvOm2zw7N2Dh
         f5ivz9J5bf4bL3yHgZ6YpWf3mM+8+ZrnJADjzaWeMYPRrAJkcFcClvvzYoBcTXbiG84m
         Bc5Grc2uaAL3VVmHMegsE2kT9FDO6LqrQqqjaUeCQSlDTueHzeE6TbjISkSu7dqcziRi
         aO3DAV/hY/iSUrKsP4wp5KhkFHj+d9GQVDhn4zHB4CFiu0AzaOOip58omG0Vsl1l970I
         xnLw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1776708419; x=1777313219; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Zpkldx8niJ7CMC04uLX4giTSMVoRQNUM3kH1mJl4DpY=;
        b=L11Kl2ttEBI66gCVUTDWnjQR7W+LLQqUMQawlwc7mLikuaGIUp3j2UYUDtxUVtL7M0
         sgdjPMwB6mVxVJadkU2Mm5wjvMlieghJ/F0NqlRlQ4AwYi2sXNTzRb/tweIWsOabcL8/
         4XEfAVoFgiciKGAg5Wgeq7RJMNrpkPpLZSET8i7mK6WlCcmHPWaIfmNmwL+BQ3krUn3Y
         vqpvGaNpMOZrd1vafP60tmLagSxhj+UWEpXyG+Oqsgrfaj8jJFc3K3yrirwRfeHzFJnj
         SD1S8lQl9XX2W2jJwFsPf0Sv7Qqevd/1JqheNfXfcwm6g6tkxA+hgVqK4V8YaeT9kVUn
         ZhOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1776708419; x=1777313219;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=Zpkldx8niJ7CMC04uLX4giTSMVoRQNUM3kH1mJl4DpY=;
        b=G1B8CVp9FmWK67BlYzJ6gh7XMoI3TwGI9MYeWiwdg6hiWWRA48hUrVsGm/XAzhMLwG
         JBgU86zyOaiKhpXUz3pi6fCWUdNZHCpvsH+gnTJCHbxxHMPSOmDLo9OR9U+Sqx3jRCw8
         YzVxsI5uUM8UPYtEdJVDcXSWBSDhZmOGQuXlWy/bFRN2di/eWKXhAIC5aPPXt95xuZ0Y
         ZMqtJycnIBnzkLP6MYmvP4rkPk6eS+TtKhKJClQ5KLyO8i4lH+ImEBDeD7CoKI0QWwE9
         z8uEwZmMjWLJ/aNQgRqdHFTF9N8BYLMSMa6yPeDVTpEfxUhe7mSwSHhQnVmnx4FzhqOH
         w7Jw==
X-Forwarded-Encrypted: i=1; AFNElJ9lUcZBspaiokDe7dfdmRWWtO7us5Di1PHlQPgFvFCgnTxTT77jPgcCx53d+4Zhe/MOm9d+Vuw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzqTGg2QdQO1R2rzIavbaIM++RTnxhz92AoNz+DKfqd1sZPi31Q
	+N1M5/9ehOzbLTFvIh2C3gotj8jyqSnV+/lP285I8iiwd/Oqdw8D9tPwfjLnRVVUoqFvF6blL+E
	3jLFMGZUQk88kQT8o4FfA4xfcENtHPYNFWO2SpfoRTp8Or21A64ZJ6oV6
X-Gm-Gg: AeBDietf0Yq7a5hLjrCX+5Ole97ou/gP4loAmdwWXpPqSSg/mxDh9dTkkGbl2n/iQYr
	LNvDMvbCD+rsKnXe7e3BlJCv4HuwvmttHhaZ6g57m7cmLgaizCQtvbT1H4bfwkOjHbIVrp8PLUC
	ytUiHjLfvsnnyyPcJZ3q17Kj9vC4m77AFvHK4UqsnYSIlP0BPfql0yjaGel+3cXVJBjI27CYQX+
	ho5wMzUQ8UQof81/EV8GBOQ1C0dJmDSS6uG2HgG7MSIkS7YLuUcWWIJKAdPRsjTUYFp7GdYCKfK
	o/tmI2xGYvMIOq9BK++GsKzkrw9Owj18Rolz4oKgQVinxj4tWDOztEV6+a67yCGKPx2grQTOzIA
	YVt+M+jf3txs9sXEWi4A=
X-Received: by 2002:a05:600c:899:b0:489:1a63:509c with SMTP id
 5b1f17b1804b1-4891a635125mr53205645e9.0.1776708418803; Mon, 20 Apr 2026
 11:06:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69e6692e.a00a0220.9259.0006.GAE@google.com>
In-Reply-To: <69e6692e.a00a0220.9259.0006.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Mon, 20 Apr 2026 20:06:47 +0200
X-Gm-Features: AQROBzAlRFE3L1PxAoj3Kqns2qB-FLUDglysXa8kG6YuQGJxwThsmLWcwFlaTmw
Message-ID: <CAJWNTGwyKmt_R-89NgicCeYRKs46yQ+wLkhf0_rLZsJ8GDCsHw@mail.gmail.com>
Subject: Re: [moderation/CI] Re: mm/virtio: skip redundant zeroing of
 host-zeroed reported pages
To: syzbot ci <syzbot+cidb1c74b9c61e30bf@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Apr 20, 2026 at 7:58=E2=80=AFPM syzbot ci
<syzbot+cidb1c74b9c61e30bf@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] mm/virtio: skip redundant zeroing of host-zeroed reported pages
> https://lore.kernel.org/all/cover.1776689093.git.mst@redhat.com
> * [PATCH RFC v2 01/18] mm: page_alloc: propagate PageReported flag across=
 buddy splits
> * [PATCH RFC v2 02/18] mm: add pghint_t type and vma_alloc_folio_hints AP=
I
> * [PATCH RFC v2 03/18] mm: add PG_zeroed page flag for known-zero pages
> * [PATCH RFC v2 04/18] mm: page_alloc: track PG_zeroed across buddy merge=
s
> * [PATCH RFC v2 05/18] mm: page_alloc: preserve PG_zeroed in try_to_claim=
_block
> * [PATCH RFC v2 06/18] mm: page_alloc: thread pghint_t through get_page_f=
rom_freelist
> * [PATCH RFC v2 07/18] mm: post_alloc_hook: use PG_zeroed to skip zeroing=
, return pghint_t
> * [PATCH RFC v2 08/18] mm: hugetlb: thread pghint_t through buddy allocat=
ion chain
> * [PATCH RFC v2 09/18] mm: hugetlb: use PG_zeroed for pool pages, skip re=
dundant zeroing
> * [PATCH RFC v2 10/18] mm: page_reporting: support host-zeroed reported p=
ages
> * [PATCH RFC v2 11/18] mm: skip zeroing in vma_alloc_zeroed_movable_folio=
 for pre-zeroed pages
> * [PATCH RFC v2 12/18] mm: skip zeroing in alloc_anon_folio for pre-zeroe=
d pages
> * [PATCH RFC v2 13/18] mm: skip zeroing in vma_alloc_anon_folio_pmd for p=
re-zeroed pages
> * [PATCH RFC v2 14/18] mm: memfd: skip zeroing for pre-zeroed hugetlb pag=
es
> * [PATCH RFC v2 15/18] virtio_balloon: add host_zeroes_pages module param=
eter
> * [PATCH RFC v2 16/18] mm: page_reporting: add flush parameter with page =
budget
> * [PATCH RFC v2 17/18] mm: add free_frozen_pages_hint and put_page_hint A=
PIs
> * [PATCH RFC v2 18/18] virtio_balloon: mark deflated pages as pre-zeroed
>
> and found the following issue:
> kernel BUG in free_huge_folio
>
> Full report is available here:
> https://ci.syzbot.org/series/329d9cff-a0ad-46d2-8ff4-d9f4341a611f
>
> ***
>
> kernel BUG in free_huge_folio
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      b8a5774cd49996e8ef83b1637a9b547158f18de9
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/60e99a0e-08bf-474f-b034-a8bfd2eb9=
0b0/config
> syz repro: https://ci.syzbot.org/findings/2868ce13-1752-4f9f-9aa9-c5ce89f=
01fc7/syz_repro
>
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> page_owner free stack trace missing
> ------------[ cut here ]------------
> kernel BUG at ./include/linux/page-flags.h:698!
> Oops: invalid opcode: 0000 [#1] SMP KASAN PTI
> CPU: 1 UID: 0 PID: 6015 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__ClearPageZeroed include/linux/page-flags.h:698 [inline]
> RIP: 0010:free_huge_folio+0xf93/0x12e0 mm/hugetlb.c:1749
> Code: c7 c6 a0 64 db 8b e8 5c 9b fe fe 90 0f 0b e8 74 40 9c ff eb 05 e8 6=
d 40 9c ff 48 89 df 48 c7 c6 e0 63 db 8b e8 3e 9b fe fe 90 <0f> 0b e8 56 40=
 9c ff 48 89 df 48 c7 c6 40 64 db 8b e8 27 9b fe fe
> RSP: 0018:ffffc90003a675b8 EFLAGS: 00010246
> RAX: c71fb9abd148e700 RBX: ffffea0005808000 RCX: 0000000000000000
> RDX: 0000000000000007 RSI: ffffffff8defcd3f RDI: 00000000ffffffff
> RBP: 1ffffd4000b0101a R08: ffffffff9011ddb7 R09: 1ffffffff2023bb6
> R10: dffffc0000000000 R11: fffffbfff2023bb7 R12: ffffea0005808008
> R13: ffffea00058080d0 R14: ffffffff9a2e27c0 R15: 0000000000000040
> FS:  00007fe11abed6c0(0000) GS:ffff8882a9453000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe119de9f00 CR3: 00000001ba914000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __folio_put+0xfc/0x4f0 mm/swap.c:105
>  hugetlb_mfill_atomic_pte+0x130a/0x1730 mm/hugetlb.c:6294
>  mfill_atomic_hugetlb mm/userfaultfd.c:601 [inline]
>  mfill_atomic mm/userfaultfd.c:773 [inline]
>  mfill_atomic_copy+0xe28/0x1420 mm/userfaultfd.c:872
>  userfaultfd_copy fs/userfaultfd.c:1642 [inline]
>  userfaultfd_ioctl+0x2c17/0x5130 fs/userfaultfd.c:2059
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x14d/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fe119d9c819
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fe11abed028 EFLAGS: 00000246 ORIG_RAX: 0000000000000010
> RAX: ffffffffffffffda RBX: 00007fe11a015fa0 RCX: 00007fe119d9c819
> RDX: 00002000000000c0 RSI: 00000000c028aa03 RDI: 0000000000000003
> RBP: 00007fe119e32c91 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fe11a016038 R14: 00007fe11a015fa0 R15: 00007ffe7cd6ce28
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__ClearPageZeroed include/linux/page-flags.h:698 [inline]
> RIP: 0010:free_huge_folio+0xf93/0x12e0 mm/hugetlb.c:1749
> Code: c7 c6 a0 64 db 8b e8 5c 9b fe fe 90 0f 0b e8 74 40 9c ff eb 05 e8 6=
d 40 9c ff 48 89 df 48 c7 c6 e0 63 db 8b e8 3e 9b fe fe 90 <0f> 0b e8 56 40=
 9c ff 48 89 df 48 c7 c6 40 64 db 8b e8 27 9b fe fe
> RSP: 0018:ffffc90003a675b8 EFLAGS: 00010246
> RAX: c71fb9abd148e700 RBX: ffffea0005808000 RCX: 0000000000000000
> RDX: 0000000000000007 RSI: ffffffff8defcd3f RDI: 00000000ffffffff
> RBP: 1ffffd4000b0101a R08: ffffffff9011ddb7 R09: 1ffffffff2023bb6
> R10: dffffc0000000000 R11: fffffbfff2023bb7 R12: ffffea0005808008
> R13: ffffea00058080d0 R14: ffffffff9a2e27c0 R15: 0000000000000040
> FS:  00007fe11abed6c0(0000) GS:ffff8882a9453000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fe119de9f00 CR3: 00000001ba914000 CR4: 00000000000006f0
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
> [aarcange@redhat.com akpm@linux-foundation.org apopple@nvidia.com axelras=
mussen@google.com baohua@kernel.org baolin.wang@linux.alibaba.com bhe@redha=
t.com byungchul@sk.com chrisl@kernel.org david@kernel.org dev.jain@arm.com =
eperezma@redhat.com gourry@gourry.net hannes@cmpxchg.org hughd@google.com j=
ackmanb@google.com jasowang@redhat.com joshua.hahnjy@gmail.com kasong@tence=
nt.com lance.yang@linux.dev liam.howlett@oracle.com linux-kernel@vger.kerne=
l.org linux-mm@kvack.org ljs@kernel.org matthew.brost@intel.com mhocko@suse=
.com mst@redhat.com muchun.song@linux.dev npache@redhat.com nphamcs@gmail.c=
om osalvador@suse.de rakie.kim@sk.com rppt@kernel.org ryan.roberts@arm.com =
shikemeng@huaweicloud.com surenb@google.com vbabka@kernel.org virtualizatio=
n@lists.linux.dev weixugc@google.com xuanzhuo@linux.alibaba.com ying.huang@=
linux.alibaba.com yuanchu@google.com ziy@nvidia.com]
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
-upstream-moderation/69e6692e.a00a0220.9259.0006.GAE%40google.com.
