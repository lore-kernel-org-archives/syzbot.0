Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F6C037D122
	for <syzbot@lists.linux.dev>; Mon, 23 Mar 2026 22:36:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.182
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774305407; cv=pass; b=X0y0ysOrCLA7Pa2oN6L+66pXXRcs2ryBJRWZJ4EZWjgOlhZ0Q52Z7w8SQA3xC1AJrsMXB1KGHuF3LDITduxFVJwrakWAZHEAS9Hyul3qE1DyqV2hAl/zFdwhtVUz8A0ytvFdNK5rJLfGeuly+fGWaVB5+jr5FGuptZ77O/E0YUg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774305407; c=relaxed/simple;
	bh=/7GOz/SQ3Ai4KSfJoXhdJNXXqyDrb9MpcMHNY4GpUjc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=imhKZTa0TpFfhQutkrY9QIzCa1mTQslp053sYmySn0b4GCojCtu5YmUW8SeoJa5aD+KLjpIBOILXBED/wjO6ITXzAgNKyGgx+soUvrdKpJ3ZZaeCkBVXGYLCCqUAXj/HR7iQCY2Ec9mgG4bumyxEOUcmFKKvJuW7R+kpp41JyZc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MCkxzBgJ; arc=pass smtp.client-ip=209.85.167.182
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MCkxzBgJ"
Received: by mail-oi1-f182.google.com with SMTP id 5614622812f47-4670676ba03so1603735b6e.1
        for <syzbot@lists.linux.dev>; Mon, 23 Mar 2026 15:36:45 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1774305405; cv=none;
        d=google.com; s=arc-20240605;
        b=cF52qTOtGDiKBnO6V0qehQPZyI8uzhOosdiikFtYgpwuj3U/UCf64TCW7uHn4SPWI7
         Xz/VkYV6HoKLp9zqVcItj7Dt+RP8LaPHEiNel6dmdu73h9hfzDV4Cy3aULUECvQ/uGX/
         efch9szNzHiExVyaK+MpFXySKLooNGQ011SYu8iD9lQso9oRpSrWpE/6jihsspRWGlb/
         u/civ24lIj3S2gOK1ra/oOWUXpYZTeyMtvp3QH5oMQ1fvUxVg3Bq1MXp9PFGb2TocznW
         5P3z4rQ41FGHEJPiiiZio7kvJLHiUiPnvr6yubxug7RVG4FA4OTc94XPbPwUihHwOOX4
         mDHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=ZzKvz3Ck/Ad21yJ2qHPD+PE/94VIpt6yLkuulICxZJQ=;
        fh=BMtKBOtzZOfZowP8QKtX3I8zYx2wfpvmikNllCV7CLA=;
        b=ODVyIIgmi33h6Y6EX9h1xQiWe7Ix0bIMzDB5b/MQPKoG9uRSIfhfaLax8WovFLzO2X
         Wo/LEgY5X/yVBQ0smRSVqwAEmVe6ndWI7actYv94o6I0N+OWjDxh9Pla0E8EMvYrRwug
         sYrJ0USsF8I7ctsBVXeYaLm853att7LLq6DTaIhsmAXm6uYf3iO+20w2sP46SBUIu7gA
         awbWY2CjsUF/ILevHxIEfsEVCzUYHgP7qqEO1XwESZy7qr8fyijxReT/HwnU4BMOrpZ8
         m8mZt8NNPhBRWKsmixj+qb7CusqrSL38nVVxQn4OUTPMEhfVT1vsKxswhtpSnsqcl341
         QN7Q==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1774305405; x=1774910205; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=ZzKvz3Ck/Ad21yJ2qHPD+PE/94VIpt6yLkuulICxZJQ=;
        b=MCkxzBgJE8VVE33j1XaGJ6dRPOtf/bnMVUvC0Z6hoQD6Dyv9FewdNR5CaLXKEAlzpR
         7vIdkQiNZExfr3hhGO+K8H22lCCkXYJMIm2fVuFrf+8dSd4vSm7cMDIV7vFd8UJBYgMa
         Ic+Q9Jhaa85d72xVOJl5wul1z2i2d8tl7JBSpMyscNQNMkJIjyQ8i9MaVtcNecsQ9jJq
         9e77/ZJ4yyVDZaF/0+Yul3A+p/7xPQaXwaFVUnvJ/6uGN2RK9IsMaLJQAvMMPsaarSwu
         HiGYSe2hodT4DFXNnE93YSLPR3z5IScsKl7/+OYjic+3PL92dG5HvYMozTqS84DNty0G
         pjmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1774305405; x=1774910205;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=ZzKvz3Ck/Ad21yJ2qHPD+PE/94VIpt6yLkuulICxZJQ=;
        b=ACLxMalbpmR+iwQQk2Kdhiab+QVuvQ5aVGedD1TDxgUJAJnWRWzTA4uVZ2YaO1blVe
         5jezeE5/43xUn+dxUceBQ9Vf1/YoOpQhu0UD+j7suQADVamRRIR3jzw2AdDx7aNj+KNL
         25qJqJuCGMTVcT23Pqa2w3CdU+h+t0jWKU4cpMOBJHMQ6vJ8CMT25Z1NFxWMbfWptUHF
         n18UuYGa2I26XbgnTq6nNgl1wyKfq96E7sCb2zHwqi5a5g8htbijijMBci+FR5Kv41UH
         T6py7ZfDyJWfycLd4D5na/UR2V2rrXfFNV8Jd2uI9GaXaADJrUS46/4taA8jOB4EMk9d
         YCFA==
X-Forwarded-Encrypted: i=1; AJvYcCUmp6WjbQxy/sT5+kwFR5GczOgcVUdCghWzVCeWvHcNd8Ki48ENB3DPSg3G5YJxnuAPrvu+hBQ=@lists.linux.dev
X-Gm-Message-State: AOJu0YwUrOxdxIyBTzJf7Sp2cxDF0VUGqti8Rs7aBPRydczo4C3rhn1F
	qh9cH9JIRGPepNEXFb9Mfu+0WAKe5wlE1tTH6gDRxCtWP5EFsG0S/BFZPIpjXQl+zTplp5zNqSp
	MVoPJNINeKdSHq9BufCtHibuNpwb3vwqHVBlOW8BBtcI6MTNGy3FWjJNW
X-Gm-Gg: ATEYQzzgCV+DfL3kStz8z7xFNpwF/lQu/oxzcDmuH3buHJuqS3q3WVL7jCiUMPlSLKu
	SAET/ztK6mbrMLeBfLIwI6h1EwYZA22oFDv/+TR0GL+6CEtBn0XD5WswPagtMhmIw3liKm0JgAy
	SZPUBSjtiy7hndn6VnlEiOnITIWIoy6rhg/fzj42JCYJlCNPbT0sgTPPBjy0jFbhJp56rbH0mYX
	EVvL0Brtknjnvi18KUWRuALYuae6YFfkxsO/C1eALpw439GI20SfUaz7Z66UnBc5iyCH78+h+gC
	nODVUcnMSYDOOCh35K3D/XYkAwdOR0/+0YU7xt/F/pEPrNH6PPXPQ2+6/Vw+hwn9Nv5BSpYX
X-Received: by 2002:a05:6808:8297:b0:466:f3a2:dc39 with SMTP id
 5614622812f47-467e5f09952mr6407707b6e.37.1774305404680; Mon, 23 Mar 2026
 15:36:44 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69c1b7cf.a70a0220.59f55.0000.GAE@google.com>
In-Reply-To: <69c1b7cf.a70a0220.59f55.0000.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 23 Mar 2026 23:36:33 +0100
X-Gm-Features: AaiRm530CzH-quLFtvH-GQkT0fo2K4vqpZFcfVOcSBwv-aCWivlbdmsqY8OIc7I
Message-ID: <CANp29Y4+0YmXs0W4jjFCGw7=2y4cENOUHFRdZic15z_SA1SDRg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: udf: Fix race between file type conversion
 and writeback
To: syzbot ci <syzbot+ci12b9eb010cb59f32@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Mar 23, 2026 at 10:59=E2=80=AFPM syzbot ci
<syzbot+ci12b9eb010cb59f32@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] udf: Fix race between file type conversion and writeback
> https://lore.kernel.org/all/20260323162617.2421-1-jack@suse.cz
> * [PATCH 1/2] writeback: Export folio_prepare_writeback()
> * [PATCH 2/2] udf: Fix race between file type conversion and writeback
>
> and found the following issue:
> general protection fault in folio_prepare_writeback
>
> Full report is available here:
> https://ci.syzbot.org/series/03e405d8-f247-471a-8469-f544c8393300
>
> ***
>
> general protection fault in folio_prepare_writeback
>
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/=
mm.git
> base:      af5802cff33fe3c557dff87cd3897d14241a7c6d
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/d1944db2-4f63-4e26-b642-d71f55382=
c9d/config
> C repro:   https://ci.syzbot.org/findings/87b82667-f800-480e-b52a-38decce=
9e6c4/c_repro
> syz repro: https://ci.syzbot.org/findings/87b82667-f800-480e-b52a-38decce=
9e6c4/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000002: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> CPU: 0 UID: 0 PID: 1860 Comm: kworker/u9:3 Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: writeback wb_workfn (flush-7:0)
> RIP: 0010:folio_prepare_writeback+0x32/0x280 mm/page-writeback.c:2371
> Code: 56 41 55 41 54 53 50 48 89 d3 48 89 f5 49 89 fe 49 bd 00 00 00 00 0=
0 fc ff df e8 f9 22 c2 ff 4c 8d 63 18 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 e7 e8 ef 6a 2c 00 4d 39 34 24 0f 85 bf
> RSP: 0018:ffffc9000901f1e8 EFLAGS: 00010203
> RAX: 0000000000000002 RBX: fffffffffffffffe RCX: ffff88810981ba80
> RDX: 0000000000000000 RSI: ffffc9000901f4e0 RDI: ffff8881a659bc48
> RBP: ffffc9000901f4e0 R08: ffff88810981ba80 R09: 0000000000000003
> R10: 0000000000000406 R11: 0000000000000000 R12: 0000000000000016
> R13: dffffc0000000000 R14: ffff8881a659bc48 R15: ffffc9000901f4e0
> FS:  0000000000000000(0000) GS:ffff88818de5e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00001b4fda9cd4b8 CR3: 0000000110906000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  udf_writepages+0xce/0x3b0 fs/udf/inode.c:205
>  do_writepages+0x32e/0x550 mm/page-writeback.c:2554
>  __writeback_single_inode+0x133/0x11a0 fs/fs-writeback.c:1750
>  writeback_sb_inodes+0x992/0x1a20 fs/fs-writeback.c:2042
>  wb_writeback+0x456/0xb70 fs/fs-writeback.c:2227
>  wb_do_writeback fs/fs-writeback.c:2374 [inline]
>  wb_workfn+0x414/0xf50 fs/fs-writeback.c:2414
>  process_one_work kernel/workqueue.c:3276 [inline]
>  process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:folio_prepare_writeback+0x32/0x280 mm/page-writeback.c:2371
> Code: 56 41 55 41 54 53 50 48 89 d3 48 89 f5 49 89 fe 49 bd 00 00 00 00 0=
0 fc ff df e8 f9 22 c2 ff 4c 8d 63 18 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 e7 e8 ef 6a 2c 00 4d 39 34 24 0f 85 bf
> RSP: 0018:ffffc9000901f1e8 EFLAGS: 00010203
> RAX: 0000000000000002 RBX: fffffffffffffffe RCX: ffff88810981ba80
> RDX: 0000000000000000 RSI: ffffc9000901f4e0 RDI: ffff8881a659bc48
> RBP: ffffc9000901f4e0 R08: ffff88810981ba80 R09: 0000000000000003
> R10: 0000000000000406 R11: 0000000000000000 R12: 0000000000000016
> R13: dffffc0000000000 R14: ffff8881a659bc48 R15: ffffc9000901f4e0
> FS:  0000000000000000(0000) GS:ffff8882a945e000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00001b4fda9c7570 CR3: 0000000173314000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   56                      push   %rsi
>    1:   41 55                   push   %r13
>    3:   41 54                   push   %r12
>    5:   53                      push   %rbx
>    6:   50                      push   %rax
>    7:   48 89 d3                mov    %rdx,%rbx
>    a:   48 89 f5                mov    %rsi,%rbp
>    d:   49 89 fe                mov    %rdi,%r14
>   10:   49 bd 00 00 00 00 00    movabs $0xdffffc0000000000,%r13
>   17:   fc ff df
>   1a:   e8 f9 22 c2 ff          call   0xffc22318
>   1f:   4c 8d 63 18             lea    0x18(%rbx),%r12
>   23:   4c 89 e0                mov    %r12,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 e7                mov    %r12,%rdi
>   34:   e8 ef 6a 2c 00          call   0x2c6b28
>   39:   4d 39 34 24             cmp    %r14,(%r12)
>   3d:   0f                      .byte 0xf
>   3e:   85                      .byte 0x85
>   3f:   bf                      .byte 0xbf
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
> [jack@suse.cz linux-fsdevel@vger.kernel.org linux-mm@kvack.org luckd0g@16=
3.com]
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
-upstream-moderation/69c1b7cf.a70a0220.59f55.0000.GAE%40google.com.
