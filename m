Received: from mail-oo1-f44.google.com (mail-oo1-f44.google.com [209.85.161.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012FE2DFA2B
	for <syzbot@lists.linux.dev>; Wed,  3 Sep 2025 21:54:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.161.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756936464; cv=none; b=iSdONUZ+8g7f6WIGBptyBoWfhsNGJHBklYnVPkwMPUpXEhtkCaObfWnslqSzL5RTJxjyhUS6krVqpxyLU6FU6409hkhgkcS1cvSuxRXpf1p++BjZp8ULvFE704Z8XyBlyfh5trf8wVWDgMJzQR1mr8kaZMe8Zyu7xPycyGj/o+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756936464; c=relaxed/simple;
	bh=NBLnENhsmmQK/S5Th8UNqWISAdtCBp29nE/QAbcGOZo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=pBDpr12ofwXc888VeTiQ4rB+ur76UaKlf3uCxKTzasnNBCxVd72UcXdmfo3dp0eb63bYwQH5zDwp1O6D/NGzpug2NsxCT+I+ckhQc+kfVexoaSQlJPeXYZCOpxQaJnQGa7zW7ZOeNe5hIsyhn319j5EcxMmTNfFSWLxVABkXm14=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=IYk1lfsT; arc=none smtp.client-ip=209.85.161.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="IYk1lfsT"
Received: by mail-oo1-f44.google.com with SMTP id 006d021491bc7-61e1f772403so94144eaf.3
        for <syzbot@lists.linux.dev>; Wed, 03 Sep 2025 14:54:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1756936459; x=1757541259; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=oCXDBzTwIEZiznNvsj1oIcV1R750dObXYBFEQaVTYlQ=;
        b=IYk1lfsTubSJwUWSu1rCBJ8iC3ocoVcX9mwGu61L9zpql7+2+eD8n2/EaL0Zn79VHl
         h6kr2HA3n+WmjcWVqgD/UfoKDzWgjgOpV+x3L9L59ZMboOsFoSwTOGi/O1QQ0PqsHP9h
         EAeVaE7iIXYvCBE5tgHPVH32Pwn2AbCjFBPLGbf/YP2BJzJaiE9MWiO1SQzlWgYP9Se4
         gKx9QxRjNIxNL4d2S+gLXpMpAdr4WhdA1vtpUlkFIVg5vBMtaQKBez6AgUt6Rodc/vuk
         Fbhw4NYrPpPtt33wbfUYbeVF0RihdoqJ4uiZWVFuUQuGDAM2A0Jl5F1yIAO79nqXC2+l
         0U8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756936459; x=1757541259;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=oCXDBzTwIEZiznNvsj1oIcV1R750dObXYBFEQaVTYlQ=;
        b=shDJBjmQkijNNu1hTRTTaxaG7VBf1qqDvKT0j48jPLyYBxb/O0ZnbQFXiSJMW4z4CX
         NyVgpsh9Y12uiWwkqSB0NnEdF40gjiQoDaCs+GLT+HPZhLutfE0QdhXpOJ1N/bVDqiIG
         cUgjpasT9PdhTEH3A4Dk6EThU7uoJdBu+JquwfqS/hyAmWBY5J4SPLf/vBXUkIfPIKU1
         Xi1l8dwT18wg4Ei6HhusdzW4kAy8Mud6WfYy9HFJ65aruXfLqJxUA4yi3sZusp2AR0Db
         rggxdmkrKIgNgVWg+gheKgkW/rxeDSUSyKgRvp1822szABErO01+QYvZyonIrCZCilUZ
         hjjQ==
X-Forwarded-Encrypted: i=1; AJvYcCX+F2mnZDlkE7i420h17sokmkPq4UUG5oZEJBwsfJSBNuUOOKIfY3ipZ5vubGAiDJkdYzWz4gs=@lists.linux.dev
X-Gm-Message-State: AOJu0YzT7lb8nXqdNSwXchgfSUaMf5/hV+ZUckSbeONsAwrowVcLv4Zt
	m3ldR7ezskj1H5tL8vwfs381ee6l5mHyaOwO6qAQNC8e2NJO2ihCVA9qhpk5sKps3exdeBH6QDd
	cN3UW7XBJRwXHI1DhREoph+ifYVNvbhlGwLVpr0zU
X-Gm-Gg: ASbGncvuApfTJXJqn3tbWWNNcVRgbmWtEPr8SsfAomw3uA8Ne29ypxOdooLt3DyK2dE
	Tif1Jx/DdJkyt8W+RGOUQPhH39fgru+d4XQmyK+hJvF1zdlXAKlwXLBaCy1Tlr1bHL2fbW7vnyZ
	1CDND4HF6KOPzOJxYb5vbX/M0+WTuOwGyvpk0A/r7UiFg4pfXY+83dn8mr4LRSTHDsa1zH2k/yp
	0nFbpt+Kj/Clg9NfSR02aGw7bRfQCobVqsyIeP2TQQne+wlTttyW9c6pg==
X-Google-Smtp-Source: AGHT+IGGCE0JK5kegn3qCQKcUc4tSvYgHBq+JNBoZyYBR1ShIBNp5hxGLEolrFja6DkhPHPGkQaAt0MkAEjKjkR9lQw=
X-Received: by 2002:a05:6820:603:b0:61e:e12:976 with SMTP id
 006d021491bc7-61e3375d5dfmr7919445eaf.6.1756936458679; Wed, 03 Sep 2025
 14:54:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68b8a0dc.050a0220.3db4df.01ff.GAE@google.com>
In-Reply-To: <68b8a0dc.050a0220.3db4df.01ff.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Wed, 3 Sep 2025 23:54:07 +0200
X-Gm-Features: Ac12FXzBV4NP_EUBK1GArb5QLV3ztQTE5PUF1H2Q6rPpbk-1XYqJ6kISvogccK0
Message-ID: <CANp29Y5V3mPtpJ2_MAatOY=f_5RYD=WpAKobUWCbMxcoCnP4YQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: syzbot ci <syzbot+ci46ad6c40cc3229d9@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Wed, Sep 3, 2025 at 10:11=E2=80=AFPM syzbot ci
<syzbot+ci46ad6c40cc3229d9@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> https://lore.kernel.org/all/20250903032656.2012337-1-csander@purestorage.=
com
> * [PATCH 1/4] io_uring: don't include filetable.h in io_uring.h
> * [PATCH 2/4] io_uring/rsrc: respect submitter_task in io_register_clone_=
buffers()
> * [PATCH 3/4] io_uring: factor out uring_lock helpers
> * [PATCH 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
>
> and found the following issue:
> WARNING in io_handle_tw_list
>
> Full report is available here:
> https://ci.syzbot.org/series/54ae0eae-5e47-4cfe-9ae7-9eaaf959b5ae
>
> ***
>
> WARNING in io_handle_tw_list
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      5d50cf9f7cf20a17ac469c20a2e07c29c1f6aab7
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/1de646dd-4ee2-418d-9c62-617d88ed4=
fd2/config
> syz repro: https://ci.syzbot.org/findings/e229a878-375f-4286-89fe-b6724c2=
3addd/syz_repro
>
> ------------[ cut here ]------------
> WARNING: io_uring/io_uring.h:127 at io_ring_ctx_lock io_uring/io_uring.h:=
127 [inline], CPU#1: iou-sqp-6294/6297
> WARNING: io_uring/io_uring.h:127 at io_handle_tw_list+0x234/0x2e0 io_urin=
g/io_uring.c:1155, CPU#1: iou-sqp-6294/6297
> Modules linked in:
> CPU: 1 UID: 0 PID: 6297 Comm: iou-sqp-6294 Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:127 [inline]
> RIP: 0010:io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155
> Code: 00 00 48 c7 c7 e0 90 02 8c be 8e 04 00 00 31 d2 e8 01 e5 d2 fc 2e 2=
e 2e 31 c0 45 31 e4 4d 85 ff 75 89 eb 7c e8 ad fb 00 fd 90 <0f> 0b 90 e9 cf=
 fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 22 ff
> RSP: 0018:ffffc900032cf938 EFLAGS: 00010293
> RAX: ffffffff84bfcba3 RBX: dffffc0000000000 RCX: ffff888107f61cc0
> RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
> RBP: ffff8881119a8008 R08: ffff888110bb69c7 R09: 1ffff11022176d38
> R10: dffffc0000000000 R11: ffffed1022176d39 R12: ffff8881119a8000
> R13: ffff888108441e90 R14: ffff888107f61cc0 R15: 0000000000000000
> FS:  00007f81f25716c0(0000) GS:ffff8881a39f5000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b31b63fff CR3: 000000010f24c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  tctx_task_work_run+0x99/0x370 io_uring/io_uring.c:1223
>  io_sq_tw io_uring/sqpoll.c:244 [inline]
>  io_sq_thread+0xed1/0x1e50 io_uring/sqpoll.c:327
>  ret_from_fork+0x47f/0x820 arch/x86/kernel/process.c:148
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
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
> [axboe@kernel.dk csander@purestorage.com io-uring@vger.kernel.org linux-k=
ernel@vger.kernel.org]
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
-upstream-moderation/68b8a0dc.050a0220.3db4df.01ff.GAE%40google.com.
