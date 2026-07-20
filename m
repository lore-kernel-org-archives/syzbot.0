Received: from mail-oi1-f169.google.com (mail-oi1-f169.google.com [209.85.167.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8D733AFD09
	for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 07:23:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784532203; cv=pass; b=Wb3e5+r31zonztTNKy0HXOH2eJSJLoIPs9P5vdjoHEV8Cp06oe4JRt+wmHryMf6Ry+DxhJ3IB1hXZe5zTCVG3FUUqq4dYeIIywlNIwBHo95Fn99v0iOJfXtBhuQOCUvAxCKXkZAIM0/igDtHwThmMvGx5BrF97FP/V6EQ52s5lI=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784532203; c=relaxed/simple;
	bh=H2P/6ZNZoaKkC4zEUP748hapamu40wJO2r3LJZJUMyA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MVuQLge3EOvJuMNvg+EEo6me/nFSlcnsGnflVIrvcm8KoYWKL8oL3SUtDtXMr8Q6ssxgUxrAitlr+9bl1qlbHMfDGJgc/KQr60lc8XZM9ye3tYYpKBnhFZsasfXyOa7zoQUD9ulHdIivTipsL3JKETncoQdddZwH1DFibXm7Mgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=V24PqBjC; arc=pass smtp.client-ip=209.85.167.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="V24PqBjC"
Received: by mail-oi1-f169.google.com with SMTP id 5614622812f47-497d3e4460aso3448551b6e.1
        for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 00:23:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1784532199; cv=none;
        d=google.com; s=arc-20260327;
        b=gZYYu54k4xb7y79pqr0xSXatyY7jdq0/2DzBf9alP7DNDU/TkohAonzsYepHP/ooNp
         8uIpoqbKdB8Se/zQ+kPxkbP8KjGI/xCoCz0YuzuddxLaqCOrZO16PjoHbietmiT5LS7q
         AeJaOtdBeskawx4QnfRgMii58Jywl/lvSVpNTWkQ4PhS1+4G3MgONJ66xHMf/CpR93KI
         WqNew/LS6Ky6BClr2M6Fmt6z2rmCRgXj++jvJ34ooNRox0KAC6bv/dYa4/D1Ny6ky1TK
         SvqXQG5eck1s4kHsD4rjiK11Pcezd5EwbpMevyvwk5TA3AzRvCg5KjXmdEz/LPE4h47g
         c2/g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=7CsHJHFu9sAIiRoEgDlizG2/HHF0YC6pN1nTCPZ5MRA=;
        fh=ua8RKVEtgwYYMyXl8YPLgcbVOJTJ3eaGEKk8sdEkYhs=;
        b=OwSi5Nq/T7RqqBp2Hy6yS+y+AGB6Uc41K14GY2W3xNUf7pU+NUMSJ+PACrNKumYy4J
         ukxDNVW9x0RZlMaqW3MbdOX7O+SPZQ9mFqVqbrmAE+Fv/UzrgmtfVETK0coeMpLQA09z
         nypH2rlOm54t3GLdt/wq/jfmm+hT8ONidrJlGtdYvsrU7iv/xKrl6IsZCMiRtHluo3FD
         N6mA6x/BDUU8CdHzlCkc68bcECXMN25VWcZ+YuSxKOHK74oBwXfqEGByaD3BaRNKZqdm
         738w4m1K/2qIdZfEYM14u0kHfPKJapBsQtFKpc+EZZHx2jJzeTMLPYzwVso62J023DTc
         Crmw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1784532199; x=1785136999; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=7CsHJHFu9sAIiRoEgDlizG2/HHF0YC6pN1nTCPZ5MRA=;
        b=V24PqBjCqnGfCyieU13RJjFWYJMwH5HZogxzfy6tRgsfHpng8e/T6qEg1VZHM8MwWW
         uXcl8Vj5LEmJVovYEPteS0XkLFKfBPl/ZUfwEnbf24ub0Euw+ygYLR76cQL0qlsVoA0v
         7mcMv3PjWNxNNst4Ww5sWNdZTjZHnOM4qsyHVSpHaiZeXTh+RPzFXsuBnCYKaKGKwKaK
         tPw/hFmjs+wc4uYW8ElzBHczQXJgYvOHaxHtD5rOqymzUZkURI1jM2cEK6VasWWR0mlC
         NLje4qAZWgIFAZb7r1Kdstngnchs2m+WJ0rZeuOrhGvVTtgbVUL1pKRHcVQf6LmsRnx1
         VIYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784532199; x=1785136999;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=7CsHJHFu9sAIiRoEgDlizG2/HHF0YC6pN1nTCPZ5MRA=;
        b=YJNemNmenswAuDwZM4UnlpsKCgHcUit/1lk1p0cgcRErG7YMa+AsNrv3FOeHrNoPGf
         LxYb7PndNRe7yb1MZYDAYoHw/sXqqaBbPlzp0tyhUE6EPtUg4psHbfx7SnV/EOmXcn0J
         pS027K9Q1bQNPCGl+8TN/6dUWNwnkOPkUvK90MTiRlEw94Wouc0apPOcFRDZUWc0ExC2
         xps5o+FJzpVLdog+ttTmw3UDftUeU35ZSospC7NYsCZXGJRUOV6NdTAgV9BwVujjImKf
         oidPYPBYnBsrVERm2Xlr9YYavUHzu6jA+6W8gcQ7jjQKoXnhI5fct0DORTLODkQdGdcG
         AVAA==
X-Forwarded-Encrypted: i=1; AHgh+RotLvEb7rWFy3zLU7atCmBunDIxH8eWLtxlNPz5C6xzdmqz3Bhgg2Z6Z4mUBvas8U0D2z6l08w=@lists.linux.dev
X-Gm-Message-State: AOJu0YyVDXvtR35OebeCidxTsXbuOuIBKtP+qC4hAR5qkPiyWE2nq2Pq
	AfjOKqZ/t6ZIXzxe5XJXbp91GMn42OEwPjm5I2nmtLiU3CHmdFKmaUkcPFGVHyc8bJx5oDqYdoG
	IDgAuwH9To3o5Hv51BjzAfdDma09JQPMRFX5sMO/E
X-Gm-Gg: AfdE7clDi+2iiasJi2tfOhUt/TRGtxHihuadlsNoWFMj1JSmX/Qla8+4rysqTaCKDoV
	aX/cMapC1nisj9Ipt0Z6wRxhwAme4mtidw9cRwR58wCmpM8BqBugX79NSULFjdwe87Jgc4f7hcv
	Y2JPhPW/SAo62MNkOh6XHxYkIsQlX1jh/KgbBLRB2zgsOJWEY3bRMqze6WsnbwegdVcpGF4T9Pb
	Z/qzvnBH+P4Dc09MSmzvQzR/MB3sLUnKllVVkPJpQKz5Xsby12TcpJROKlEULcBhqqr1QU5b+R2
	MmyhPWqgAMmrFYCUntIMRF4daLBG8leX1Z4c+1RexA6Cu1jMC9hFjRXiUxP1rOHwq9ZoL0M+efb
	uEEO2EP6uqWW1PHibsvhvBCiO9+caRoVmZs9f9bvT
X-Received: by 2002:a05:6808:150b:b0:495:f8a5:8797 with SMTP id
 5614622812f47-4a4b1d2db98mr10155747b6e.0.1784532198139; Mon, 20 Jul 2026
 00:23:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a5db5b3.5028b7d0.1f0bb.02ba.GAE@google.com>
In-Reply-To: <6a5db5b3.5028b7d0.1f0bb.02ba.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Mon, 20 Jul 2026 09:23:06 +0200
X-Gm-Features: AUfX_mzOgNaWb21TvZ6RNSfKsRcvgo9TE_hP0zCxHj1LG0Nw_d9YjKao2cn2hs4
Message-ID: <CANp29Y4y79eqeXQ=taqc+dfh5CgKCUrbMjwC=iZ6wffrWg8tzQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: ext4: convert pa_count from atomic_t to refcount_t
To: syzbot ci <syzbot+ci90c3f9db18465f21@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Mon, Jul 20, 2026 at 7:44=E2=80=AFAM syzbot ci
<syzbot+ci90c3f9db18465f21@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] ext4: convert pa_count from atomic_t to refcount_t
> https://lore.kernel.org/all/20260720034441.3900050-1-rafad900@gmail.com
> * [PATCH] ext4: convert pa_count from atomic_t to refcount_t
>
> and found the following issue:
> WARNING: refcount bug in ext4_mb_use_preallocated
>
> Full report is available here:
> https://ci.syzbot.org/series/34fda797-e979-409c-bc2d-7af3e163df14
>
> ***
>
> WARNING: refcount bug in ext4_mb_use_preallocated
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      1590cf0329716306e948a8fc29f1d3ee87d3989f
> arch:      amd64
> compiler:  Debian clang version 22.1.6 (++20260514074242+fc4aad7b5db3-1~e=
xp1~20260514074407.73), Debian LLD 22.1.6
> config:    https://ci.syzbot.org/builds/05fa6c1d-a594-4691-ace3-ded3fc2ca=
4dc/config
>
> ------------[ cut here ]------------
> refcount_t: addition on 0; use-after-free.
> WARNING: lib/refcount.c:25 at refcount_warn_saturate+0x9f/0x110, CPU#0: k=
worker/u9:2/51
> Modules linked in:
> CPU: 0 UID: 0 PID: 51 Comm: kworker/u9:2 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: writeback wb_workfn (flush-8:0)
> RIP: 0010:refcount_warn_saturate+0x9f/0x110
> Code: eb 66 85 db 74 3e 83 fb 01 75 4c e8 8b 73 0c fd 48 8d 3d 34 58 84 0=
b 67 48 0f b9 3a eb 4a e8 78 73 0c fd 48 8d 3d 31 58 84 0b <67> 48 0f b9 3a=
 eb 37 e8 65 73 0c fd 48 8d 3d 2e 58 84 0b 67 48 0f
> RSP: 0018:ffffc90000bb6590 EFLAGS: 00010293
> RAX: ffffffff84b9ee08 RBX: 0000000000000002 RCX: ffff8881072a8000
> RDX: 0000000000000000 RSI: ffffffff8f126800 RDI: ffffffff903e4640
> RBP: ffff888112257dd0 R08: ffff8881072a8000 R09: 0000000000000005
> R10: 0000000000000004 R11: 0000000000000000 R12: dffffc0000000000
> R13: ffff888112257d98 R14: ffff888112257e10 R15: 0000000000000008
> FS:  0000000000000000(0000) GS:ffff88818dc15000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fc831b2c080 CR3: 0000000112724000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  ext4_mb_use_preallocated+0xaa0/0x14e0
>  ext4_mb_new_blocks+0x5a0/0x4560
>  ext4_ext_map_blocks+0x1534/0x5850
>  ext4_map_create_blocks+0x116/0x530
>  ext4_map_blocks+0x7e4/0x1240
>  ext4_do_writepages+0x23d3/0x47a0
>  ext4_writepages+0x241/0x3b0
>  do_writepages+0x338/0x560
>  __writeback_single_inode+0x12e/0xf90
>  writeback_sb_inodes+0x9de/0x1b00
>  __writeback_inodes_wb+0x114/0x240
>  wb_writeback+0x42f/0xad0
>  wb_workfn+0x980/0x10f0
>  process_scheduled_works+0xa8e/0x14e0
>  worker_thread+0xa47/0xfb0
>  kthread+0x388/0x470
>  ret_from_fork+0x514/0xb70
>  ret_from_fork_asm+0x1a/0x30
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
> [adilger.kernel@dilger.ca jack@suse.cz libaokun@linux.alibaba.com linux-e=
xt4@vger.kernel.org linux-kernel@vger.kernel.org rafad900@gmail.com tytso@m=
it.edu]
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
-upstream-moderation/6a5db5b3.5028b7d0.1f0bb.02ba.GAE%40google.com.
