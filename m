Received: from mail-wm1-f47.google.com (mail-wm1-f47.google.com [209.85.128.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F9A547885F
	for <syzbot@lists.linux.dev>; Tue,  5 May 2026 13:07:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.128.47
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777986447; cv=pass; b=ZYPzPr0TMKl4BAH4WAgSdrYAxwr4UCkVbKMFu/DvHPy0NTUqRXo6rf/aapM9TTPKayJ+FrYrt6ZXnylMXFdEh/W4qiKtfBMSM85IA6qA8flh1z6Wj9goUh8iZOGHAWYUvdGuC1MyH0xCvoszfrABYOl9lUZQRnRcWP83B9O5oVw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777986447; c=relaxed/simple;
	bh=sHvyoSuKwKt3gg7PsBNKT9erDqNOXA5GX+09LpzKihA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RM7jbHiMKjzXf5IY9RkCZXZ9DbGVkYs7SSVUwxyTIthazfd4alKoIPwtWuj4t75xXnXsvRAYUuxsELuk0sgre/xi0Wyw+139quHgYSHPi9baDJEGUd0WqGWniMnlE8jevdIZ4sVIXI26BI0iicQIV9DgQ2VXKUiJywSdeGEFpmE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=lVLWC02q; arc=pass smtp.client-ip=209.85.128.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="lVLWC02q"
Received: by mail-wm1-f47.google.com with SMTP id 5b1f17b1804b1-488ff90d6c7so50266615e9.2
        for <syzbot@lists.linux.dev>; Tue, 05 May 2026 06:07:25 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1777986444; cv=none;
        d=google.com; s=arc-20240605;
        b=Isfm3mt3wnAsSFtZU+NS9hORszuEczNCFelSmKvkLcDlC/I6j/4nqvyP3fRbvjpXM+
         lnlgeAlvMVfRD3BoLsEVaYj2xJIqQd9ABpuHJe8TueBQPFAIlHGbOO7WYuW6NDyxui/C
         VrJJeQCaw1nwRPeTzS5yY/vrvV3GgmAgNfTRrvFP0XjnXsdndFuZr6tOFbFAwrFH2qMY
         D+o3gfx372clHaHLYmD6O7h3IZIXM215xpBJujcFmru/29LEwB6nU1iNNDD+IkwAieVj
         5Sm/tCE+D1EpeuvvHV9Y9eQhEZqfhKyPZpSU2aIvpjtcAQOYm0woY/REuImc1gh6Ta4j
         BcNw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sIdPon9vjd4jAOtSxsLRQ7QoRj6rMC5z1vPFFOUwcYk=;
        fh=yfIrmszxi465A5OBAbAatmMul877XtaYWVWvaEhRNrU=;
        b=WDMwbTsVhmCi+j9otKp2xfiY39tu0z1id7hkaS9FfzROXXGbts0ZTcXbyZCOKD+VWt
         l0syaGsoCyTGYIOdmEBnkm2U03xE/OzqE9kNsjC+/Ref5+/2563hIouMgjs+60eo1+8/
         CXF+cIo6DrfEJ0bFbWXzHTXjhu1Q7awRtjCfakylYfLV19PRaN9cUyeNdyBMmGF/m2Vt
         5CtsUM6SjzJYWtZ0zgGHPWI87w4TJWQb0ZCy8bdCWpCPNOY2TKg3G7+R3YXtpjA6c/7Z
         hPkn1EIZ1qj0UqEaMXDx/Co8PBtQYNzBqKpD9N4yLsjbpfXiMJ1/fa2D7L4pE9NworvE
         8Gsw==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1777986444; x=1778591244; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sIdPon9vjd4jAOtSxsLRQ7QoRj6rMC5z1vPFFOUwcYk=;
        b=lVLWC02qs+uJJgQQufZwm+r+AxxJNR3l7by3XtxnRF9tAbB+9x7GQ33WiKJvARAgql
         FhqxFAqci4WP5zkM7hP2UcVByoTxbpoZcVHpSz3YCjNckBL+P2Ej8xZ8XJ68EypOgAcQ
         MMtweLFnrAZ8NvdlLOWXSrTBKKsFLCLTys0arHwq0MdohdEvUQNET3In/4BH7cTiTz0y
         MbXzbqBYK8yP+G1UXAHrsgxmHE4zHMg8g8owIDxiPBUridSZnaRGAQvibP4T/RJbB5+7
         vT+Vv1acnnasTnwfHG714TQetLyhW9Qjv2XhibMNUDjSAMyNP4/AIjxTrNRMRsAgD3CD
         kJhQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1777986444; x=1778591244;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sIdPon9vjd4jAOtSxsLRQ7QoRj6rMC5z1vPFFOUwcYk=;
        b=V8WqA/r47lmQ4BZvQuP1Sz7LcTs0gUq5M/x/A6ugt9781eUoRNd3bdvc1vfh9/GXpX
         JHpFYY22kCv3KvCDX0b1Rkwr2bQzGpj5vCzbdgp9vVUIGDlZCpw89HzJpT6xgC6sa+wN
         vfVJ3O/ApqKQbiHfdA7L2EIf7mxLyo2iIkiR8q+wcKpYEAOzn6uh1wnV/MLbtDtx0ZQY
         KpRS/fvkXvYDGHBAXE+LGjSTaO+oP4yGRfezkSTeB1pBuN3ULKp7G7PgN9B7CG2ZckyR
         bDbDnvJfrvLWJWf6b8lofFn4NbCzE9tPyB1w9+9mJ00CgX3tRzbwklolXElzRJPKrepD
         QXpg==
X-Forwarded-Encrypted: i=1; AFNElJ8F+3JSCD2MWr+OV0lP8HYRafszqxyLIo7f/fYEtOyRddShSCk8ym4Ai40GRIM23vkXe/qpowM=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxop/5tQKnEz6CPGWjK4OXKxH4kVod5C2vE22GZC77KB5kH7Kfa
	YISNwEsMoqDUYgyi4G8VyFOgTyo+dQBzIHwTlb6Rq6kPfQBv2XsGWCP0QQSjQrO6TE4HlMpWoUB
	pZscEZukN4lowy/VG2NCZh3XQR5dCoFJnTOofZEYypJyiG+4RFpVNs1si
X-Gm-Gg: AeBDietdyEB2vhh0hEu7H3F/mQvsQF8SUoLawk+4OTUAVmeGdcFOLr+4HHXnej+PCPQ
	1c2GMpq0yfQBdDnG08hoKJzQTZHZK2P+HzWFuGN1T+9Xl5s0XxMyuJBULiEpJDinoi7WnGFRNIS
	rEXtNQ5h1EyNtv3xAAW6xHIxQ8vj9yU+wGgnDNRvBZJc4759/AbBUg6AehkjBkOVniEiKgQKVoy
	DdaQQfA0GlkvHwpQA2u+3d3rSH3o69RiYmsOPvu7wtXQy0qS8KWqPFrajfqVW8fkhJtaB+WYsJz
	p3qbfLh4sckFouIIPlEeY2D35Mf9njnf7Zlux+aFAJSO+xaPoriy+mTBIXYlboe5Jg7RwvtutGa
	9SsYUbG5OgN3YcgY=
X-Received: by 2002:a05:600c:1386:b0:488:ac01:72de with SMTP id
 5b1f17b1804b1-48a988716c5mr223412885e9.5.1777986443099; Tue, 05 May 2026
 06:07:23 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69f9e014.170a0220.59368.000f.GAE@google.com>
In-Reply-To: <69f9e014.170a0220.59368.000f.GAE@google.com>
From: Pimyn Girgis <pimyn@google.com>
Date: Tue, 5 May 2026 15:07:10 +0200
X-Gm-Features: AVHnY4KLbPfKsIW0ayF_DTdog-4LjF7YhHMA_eCBQmFEOF0lIB9x9rwoF_mTPb8
Message-ID: <CAJWNTGz7iORgz0bumbfpjuMFxDCUXhP=-3=4S2tK6jHtD5MuTQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: io_uring/rsrc: remove registered buffer 1GB limit
To: syzbot ci <syzbot+ciac921838cf7775c4@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, May 5, 2026 at 2:18=E2=80=AFPM syzbot ci
<syzbot+ciac921838cf7775c4@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] io_uring/rsrc: remove registered buffer 1GB limit
> https://lore.kernel.org/all/6de5d329-9162-4992-85cb-f946f2d5c0b1@kernel.d=
k
> * [PATCH] io_uring/rsrc: remove registered buffer 1GB limit
>
> and found the following issue:
> WARNING in io_pin_pages
>
> Full report is available here:
> https://ci.syzbot.org/series/576c7f20-d7fb-471a-a534-f8f67489e049
>
> ***
>
> WARNING in io_pin_pages
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      c7e4e4d5f7dc2daa439303d1b5bf6bdfaa249f49
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~e=
xp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/287c9ce7-c085-4a41-9f94-756762f8d=
acf/config
> syz repro: https://ci.syzbot.org/findings/63ff94b0-aced-41c6-83fc-a917c57=
ad624/syz_repro
>
> ------------[ cut here ]------------
> !(flags & __GFP_NOWARN)
> WARNING: mm/slub.c:6840 at __kvmalloc_node_noprof+0x7be/0x8a0 mm/slub.c:6=
840, CPU#1: syz.1.18/5830
> Modules linked in:
> CPU: 1 UID: 0 PID: 5830 Comm: syz.1.18 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__kvmalloc_node_noprof+0x7be/0x8a0 mm/slub.c:6840
> Code: ff 48 c7 c7 d0 bd a8 8e 48 89 de e8 dc 48 c9 02 e9 49 fc ff ff 48 c=
7 c7 10 be a8 8e 48 89 de e8 c8 48 c9 02 e9 7e fc ff ff 90 <0f> 0b 90 45 31=
 e4 e9 f8 fd ff ff 90 0f 0b 90 e9 52 ff ff ff 49 83
> RSP: 0018:ffffc90003a37928 EFLAGS: 00010246
> RAX: 0000000000000004 RBX: 0000000201000008 RCX: 0000000080000001
> RDX: 0000000201000008 RSI: ffffffff8c28ac40 RDI: ffffffff8c28ac00
> RBP: ffffc90003a37b70 R08: 00000000004028c0 R09: 00000000ffffffff
> R10: 0000000000000006 R11: 0000000000000000 R12: 0000000000000000
> R13: 00000000004028c0 R14: 0000000000000016 R15: 00000000ffffffff
> FS:  00007fb3823ec6c0(0000) GS:ffff8882a9290000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffcca0efe68 CR3: 000000017064e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  io_pin_pages+0xac/0x1a0 io_uring/memmap.c:59
>  io_sqe_buffer_register+0x228/0x1860 io_uring/rsrc.c:801
>  io_sqe_buffers_register+0x2f9/0x7e0 io_uring/rsrc.c:913
>  io_register_rsrc+0x24d/0x280 io_uring/rsrc.c:414
>  __io_uring_register io_uring/register.c:843 [inline]
>  __do_sys_io_uring_register io_uring/register.c:1029 [inline]
>  __se_sys_io_uring_register+0xc5d/0x1ac0 io_uring/register.c:1006
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb38159cdd9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fb3823ec028 EFLAGS: 00000246 ORIG_RAX: 00000000000001ab
> RAX: ffffffffffffffda RBX: 00007fb381815fa0 RCX: 00007fb38159cdd9
> RDX: 0000200000002700 RSI: 000000000000000f RDI: 0000000000000003
> RBP: 00007fb381632d69 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000020 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fb381816038 R14: 00007fb381815fa0 R15: 00007fffdb4e7d78
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
> [andres@anarazel.de axboe@kernel.dk io-uring@vger.kernel.org]
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
-upstream-moderation/69f9e014.170a0220.59368.000f.GAE%40google.com.
