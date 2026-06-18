Received: from mail-oi1-f170.google.com (mail-oi1-f170.google.com [209.85.167.170])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AB5D42A82
	for <syzbot@lists.linux.dev>; Thu, 18 Jun 2026 06:38:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.167.170
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781764730; cv=pass; b=cMRs3Tk6aRQ2WvChzNwRtiqdnVbj7nKBwoXKOqn8shEHb/zGiuZxb65yymGuH7Ir2LkAQL67G8g0RzMmUXaOYvT5KF0Y1f8zirRciaUmtbF+7qfM3eklBzHs8VaAEzKgnbHS0+wFT7L0GxwVYPI8SdQX/yEp+Oj1TTtm58si9p4=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781764730; c=relaxed/simple;
	bh=G1DFGr6grK0aOKDc8nt+1uMbcjfyfcvKgcZGfv7DU8o=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gg9DY4FOuyJCpyJatuMaPuF0yVf9F21bgNg1AX70Joz+zkoMPcyHNl/IIz9gmiq1/bTf1XoaWbW4wGimFYFjuaI+6dZakSs+1kMz+fIy4KqWB/fVGc4a98Fh0jtzByPQYnXkx2l8+TWxmupClfk48KA57kJL1eSnNT3G6PJTYfo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=CDHctlDk; arc=pass smtp.client-ip=209.85.167.170
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="CDHctlDk"
Received: by mail-oi1-f170.google.com with SMTP id 5614622812f47-487135fd4f9so228477b6e.0
        for <syzbot@lists.linux.dev>; Wed, 17 Jun 2026 23:38:48 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1781764727; cv=none;
        d=google.com; s=arc-20240605;
        b=ecqGRdkJv+hOcMQ9fZqSPfVZjiMYs2cAqNiE+q4v/8Mz45lzMCkmU6H6OSkvLcCmFN
         O9dn+1Nu2fR9JCAPErUktFybzM5xryY/IXIAD+lfqQSTS8GlflSDkYIA/3q5wl3qnRTv
         NCexj+5t3gQirTmktzwlOSpuddb8A7jGIuT7a7uCOWYfw9oMbHYlpQfgqXJdXQnAljuh
         TXpoTxusNyuBQkMg6izyv7NbpcXeoNB/y3AVJBxsMpp2U1M8z0fNuFguULU+y/8h9OON
         GrxnCgP/wYZ6GARBMac+XI1yndgmEInJbBkaBtjqv1dF197WXI/sCAc0yW/mMVS/VL29
         XLxA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=xDizpAsTBSmvcot2AlAz39XH9w61h7LC7Q0J6mKWcjM=;
        fh=MY+yp8Bsa/D8StJK5R8tu9SZ/f/4h04eRK3knRfuPo0=;
        b=SijJ1ltQtDq3VVvspsq5kigYzS563jzn2lqS/nZWV8sy9iXZy4+JYsDkBdhb5nXTKI
         8SkUpOn+XEVHHsGSZJbIc4lw34hYDYx3mD8SfX9G5puV4PAlwYrn9DCKFX26DIhwF8Fj
         SB0a7xx8fKIdDXbJ5LNBgHHPOdPyMyH7pZLVvGw8nJzoyIdzZRU6GSDXVfmb0YQUGTiU
         3JirKWhhpKLlrgAWUZQ+GiMuSHgFTraxud+GhEas81n3CHaSanEsj5JvZL3SmNYEQio/
         zU79AfHv4pa2dNk0sK12+qWy0lXFlSEJ9xCc8tmI7wVxYES49420m1tnlo7/Ym+Y30jP
         JZVQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1781764727; x=1782369527; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=xDizpAsTBSmvcot2AlAz39XH9w61h7LC7Q0J6mKWcjM=;
        b=CDHctlDkopH0ThsRgzQbQ/j5c6uo30IOzncldzMoEWuLO85YelWiU5rHQS33rajtJ0
         VG71W7kgu0vDz7NYpxK/vPhq/GAW1TUxkIea5ucTRxQzow+0Zu6FZBTgXVpRDKJebcdG
         7y6iU66DAlaedtrJMPKKtDyVgt8/3EWF8Prmg/t+aWaP2yW9t9Am4kM0CrOxP9HmNOwd
         9mUgorZl4Gkbi1mBAu3/q8kqDqDPUvgntTcpkVlzSMfyb84++l3wz+oSR34L6pk080Qj
         9/Ufy32U4c4/1gQhnSo1uaaZOeGZu+HEVeF4/3Cn1GWuWdzOjoETSuruRs9x7REi1oUB
         YkPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1781764727; x=1782369527;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=xDizpAsTBSmvcot2AlAz39XH9w61h7LC7Q0J6mKWcjM=;
        b=aLqv/JLzbQgrXPjsekOURtuBJorJ8K43xJJV0xdYqnkiVheOWnAyMdY+CKGpRdi1gj
         mfnPcK+mI4SWMgfwucTI3lDqiQu3NGXH6e2tvWlbYZRK1WdRQopTDCBv7IQM0/qixaBO
         Jm8apYZpJ10i2s6GLD9eLaBYVvk90hpgpRftVwA2hJ1WuPK3WTv2p6mnPIVAHOqP4Htq
         YJIxWTdhLMrxOLBjV2TUtRu7OZnhJFTvF9ARnkdWHeDH5rVruGnfE7CA9EE3n740YhHt
         qufeID8M0G2BCja1UIZUvJp9xIOqdm+Yt3iq4bNAnK5bWWc27maCitRxLiCBEIXhdttC
         M6NQ==
X-Forwarded-Encrypted: i=1; AFNElJ8HDzscaHuG2gKm4vdEl6p2EY4TaH66PzAWoMB4wU19LwfhCstw8GKFYG2n0x1pYVHoAazayXw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdGemV0ihoUv7iVkDLitVk4uA21PwAqXA6Dm8cEZzoqvipicsM
	FopZCQ0vBwTggCW0V0N22u+XC1GJCODwlUZdqPMzZc7W75suJy/Kyr17c9r126NM7grdhtg8tJA
	fFMm+tmCbceDAcjFH1pASI5O2ntTmpHwDXFAm6udn
X-Gm-Gg: Acq92OHCbWdtMKvcKuA7muR0IakNn9bBBIWHtC3/K4nb+i8/U7rC2ZVLLLLxpPHz7lp
	tsZSRBMFVejVanl8DErgoyeVGPyPL36q9o0KZmmmwMss6RZOod3mh+4ud4vbjZBtvzjYyvyZs7+
	GsVtwz0m2VOCdeni++c5oYv2e8G5K1q74kD1ntXJ9dI3HHfZkEvzmjqvHzLxzaUmx6cvZthX8AW
	soWqu5QM4H91JSbGsyteBVpJCcosSokWFKkISbNEeheWysF5oGyrloAKr2Jp4gf537E9DkyHKHh
	F95dr+A2K/dK+pR/XQZe0z6EFEB+FTraPbjxtToi1yrAaMI0b3zdPnfWf62v1SzGk8ANWn6NJUC
	8+n900UfEVw==
X-Received: by 2002:a05:6808:1999:b0:482:c2dd:d192 with SMTP id
 5614622812f47-489572425bfmr2122763b6e.26.1781764726805; Wed, 17 Jun 2026
 23:38:46 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a337424.6d5abbec.a50f.0024.GAE@google.com>
In-Reply-To: <6a337424.6d5abbec.a50f.0024.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Thu, 18 Jun 2026 08:38:35 +0200
X-Gm-Features: AVVi8CebBXM60JIyW9JVK7727D1NSPzEdtZBjNp_brWKGrRQqsCQdHj1stigzxw
Message-ID: <CANp29Y4MFSi62wjUHOqmyDNfwLDmUgmZ8HdyQHf1NfTDBHdEtQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: coredump/fcntl: Add FD_CLOBCOR flag to close
 fd before dumping core
To: syzbot ci <syzbot+ci5e0a64dea7cd43ee@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Thu, Jun 18, 2026 at 6:29=E2=80=AFAM syzbot ci
<syzbot+ci5e0a64dea7cd43ee@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] coredump/fcntl: Add FD_CLOBCOR flag to close fd before dumping core
> https://lore.kernel.org/all/20260618030700.2511668-1-jackzxcui1989@163.co=
m
> * [PATCH] coredump/fcntl: Add FD_CLOBCOR flag to close fd before dumping =
core
>
> and found the following issue:
> WARNING: suspicious RCU usage in exit_files_before_core
>
> Full report is available here:
> https://ci.syzbot.org/series/bda032a0-64d8-4226-8ad1-6a4c99514d61
>
> ***
>
> WARNING: suspicious RCU usage in exit_files_before_core
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      2a706d98d50a28dd635b3d028531d839c1f5f19a
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/e0dd4cce-02a0-415c-9720-8816ca173=
46d/config
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: suspicious RCU usage
> syzkaller #0 Not tainted
> -----------------------------
> ./include/linux/fdtable.h:104 suspicious rcu_dereference_check() usage!
>
> other info that might help us debug this:
>
>
> rcu_scheduler_active =3D 2, debug_locks =3D 1
> no locks held by syz.2.65/5687.
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 5687 Comm: syz.2.65 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150
>  lockdep_rcu_suspicious+0x13f/0x1d0
>  exit_files_before_core+0x35a/0x410
>  vfs_coredump+0xa52/0x4550
>  get_signal+0x1107/0x1330
>  arch_do_signal_or_restart+0xbc/0x830
>  irqentry_exit+0x2a4/0x860
>  asm_exc_page_fault+0x26/0x30
> RIP: 0033:0x0
> Code: Unable to access opcode bytes at 0xffffffffffffffd6.
> RSP: 002b:0000200000000008 EFLAGS: 00010217
> RAX: 0000000000000000 RBX: 00007f3125415fa0 RCX: 00007f312519ce59
> RDX: 0000200000000000 RSI: 0000200000000000 RDI: 0000000000000000
> RBP: 00007f3125232d6f R08: 0000200000000000 R09: 0000000000000000
> R10: 0000200000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f3125415fac R14: 00007f3125415fa0 R15: 00007f3125415fa0
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
> [alex.aring@gmail.com allen.lkml@gmail.com arnd@arndb.de brauner@kernel.o=
rg chuck.lever@oracle.com ebiederm@xmission.com j.granados@samsung.com jack=
@suse.cz jackzxcui1989@163.com jlayton@kernel.org keescook@chromium.org lin=
ux-arch@vger.kernel.org linux-fsdevel@vger.kernel.org linux-kernel@vger.ker=
nel.org mcgrof@kernel.org viro@zeniv.linux.org.uk]
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
-upstream-moderation/6a337424.6d5abbec.a50f.0024.GAE%40google.com.
