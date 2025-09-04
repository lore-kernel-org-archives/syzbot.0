Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BCD432FF17C
	for <syzbot@lists.linux.dev>; Thu,  4 Sep 2025 14:52:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756997540; cv=none; b=oQvPjzYXxA9+ArG2CIPZvYEXwWWUuIkIFwZw97KhAky4zWw4/QnjVvGyKTv5d1XMUclsjQYUl5hn0Bg7fIUg4e949q0eFnL1ETtBsw40yBKJ/9IS/XTgtYi8sYH1ryyU+GZ/PoY3Q9mNT0cFBU6gHnT4Jj/AdqZtRNi5LhxAvUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756997540; c=relaxed/simple;
	bh=M/qbKkwAMqX8y/mjZr7yB0B1J9DG1BwDuI+e+iriVCw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MOgBRzmQRW1qBiD459/Kqd5wXi3Tdr8F+Ceqej82SMoNQ97FVnek2SJRhZszzk8NPpBBTz4N8N6rIPcXRLSO2RI4b/WbrIjMr2205FmJZsNGM/CtA+ogEoyfCDXAaKZqRskA/25MrCj4YtL5nOtfl9HdratMo7JSrrBgo3YcCtg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=I6kDbEBm; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="I6kDbEBm"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24498e93b8fso2040345ad.3
        for <syzbot@lists.linux.dev>; Thu, 04 Sep 2025 07:52:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1756997538; x=1757602338; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=5L+1A0Qn6tDIJ/+5jrI0wrwIaFtPyK0t4LNaxoycC08=;
        b=I6kDbEBmz0HBQL2++FNYouRgeaOYCEjbFRu1SkB2GwfUf6ms0RGaq1Pk6YhEktIsuG
         95vmgiqOjE6FYYZsPhMu1lL85IGAb0M+siv0ir06pertBPy3PZWxaji74tVm6eRrHynH
         8GiOhk81DsZDsGEeT/mnPuyPIq+KOD8NEnk4QocSzlJvkbi7indbpEX3jgLhoKA2fiau
         +7v657URW4iFOpnr0keDeZwBf10bwKF/Qo++dlwxvjYstRvq6+L+bWbR4WCLx8JPNYh6
         Xq27atk1blJZ+aocGhrrKEKrsmT7IQBhyWvYNjIoHuMI/k3pmfDQ9m9g5P7BR+B8q0uw
         FSOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1756997538; x=1757602338;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=5L+1A0Qn6tDIJ/+5jrI0wrwIaFtPyK0t4LNaxoycC08=;
        b=V0WgCe4iEc8NBW+mPBapW4NytqJcEwDEtSmylh6wvxFbVKMAIQ50XvAGF3AX1UtoJ2
         QKzGbtuQidpk0HJExOToLFXVt4FhdVQV4+bYQvnuA61R4gYLe1UhMyQbgS0HEy3fsCqk
         o46Fdp2Du6sDeCXqj2DgA5MfPQpZvcAQc05ZEBbVOU1WRo68okUreAtx/g1AQQrpcOnb
         fXMepaIXxBTSddcd+P0zWWLjhsN5Rxuo/SIZbbTjNaCV/qpR4+ZB7tznHg3R3pxwAI1v
         MBOLr4m1H+NvNbf3k//fG0lfB9qR3xrxSlqEOqERmI6a2ZNx3he4+ABzVcZNodU891PG
         Li/Q==
X-Forwarded-Encrypted: i=1; AJvYcCV75NtQ+Sie8vUnCtyo4HZ0mmVXmsBZ4WZYujnwt8vribo4PRhyIXkEFkyo0BIQByWmAcIOvpg=@lists.linux.dev
X-Gm-Message-State: AOJu0YwwDRWq8zNslnhxjtLYl1e9L0Pabr2mALo3K/kM5Roai5p4RtCP
	ACKW5wkzZ4JudKsFSjObP9wDeg2hpEr0TBGTkKINo3pGodV6PzqMkommrfq+vKNt2r6E2Zv8P9d
	vVo+Crna41Nb8vaV7aSGcf1B7ojzhShB6eVbXQRMTkg==
X-Gm-Gg: ASbGncul8H5rYbVj5z8p9+KzoVarcf4ScHSHXH4ifCG19WFrY84poBzlemloWffSjYm
	FQUfnhegX8sMHFmnQO+LGWH1VZp9y4VStcsE16MhKGXYHezahXrFM7sATGUyqZLF7Wa7FCvBdCX
	U+5Lj7fKx/s958laYESnt6I9EKpIwGQLuBkwuG3jQmfbuqhADsPnZpizVnF3m3LDxgRy10fwbdT
	JT2I9xRe9T63Bn/dWugskU=
X-Google-Smtp-Source: AGHT+IHrDO7rct8h3wx3u6xR/65kPbs84Tas/VoeMqMGcATS+awVWwLXLpF+ldKApAdeg3Rl6ZADKjLD+EBaorvmYQY=
X-Received: by 2002:a17:903:244b:b0:24c:cc2c:9da5 with SMTP id
 d9443c01a7336-24ccc2cacb3mr21272355ad.6.1756997537840; Thu, 04 Sep 2025
 07:52:17 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68b8b95f.050a0220.3db4df.0206.GAE@google.com> <26aa509e-3070-4f6b-8150-7c730e05951d@kernel.dk>
In-Reply-To: <26aa509e-3070-4f6b-8150-7c730e05951d@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 4 Sep 2025 07:52:05 -0700
X-Gm-Features: Ac12FXzpBslhoYX3MBNzpJXMp8ILNPXUI_3B7i9RNClyL26lelIR3jOPX-IG6_o
Message-ID: <CADUfDZpTtLjyQjURhTOND5XbdJOSEduDLdSuyUJVk_OKG9HVGA@mail.gmail.com>
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot ci <syzbot+cibd93ea08a14d0e1c@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Wed, Sep 3, 2025 at 4:30=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote:
>
> On 9/3/25 3:55 PM, syzbot ci wrote:
> > syzbot ci has tested the following series
> >
> > [v1] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> > https://lore.kernel.org/all/20250903032656.2012337-1-csander@purestorag=
e.com
> > * [PATCH 1/4] io_uring: don't include filetable.h in io_uring.h
> > * [PATCH 2/4] io_uring/rsrc: respect submitter_task in io_register_clon=
e_buffers()
> > * [PATCH 3/4] io_uring: factor out uring_lock helpers
> > * [PATCH 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> >
> > and found the following issue:
> > WARNING in io_handle_tw_list
> >
> > Full report is available here:
> > https://ci.syzbot.org/series/54ae0eae-5e47-4cfe-9ae7-9eaaf959b5ae
> >
> > ***
> >
> > WARNING in io_handle_tw_list
> >
> > tree:      linux-next
> > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/nex=
t/linux-next
> > base:      5d50cf9f7cf20a17ac469c20a2e07c29c1f6aab7
> > arch:      amd64
> > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1=
~exp1~20250708183702.136), Debian LLD 20.1.8
> > config:    https://ci.syzbot.org/builds/1de646dd-4ee2-418d-9c62-617d88e=
d4fd2/config
> > syz repro: https://ci.syzbot.org/findings/e229a878-375f-4286-89fe-b6724=
c23addd/syz_repro
> >
> > ------------[ cut here ]------------
> > WARNING: io_uring/io_uring.h:127 at io_ring_ctx_lock io_uring/io_uring.=
h:127 [inline], CPU#1: iou-sqp-6294/6297
> > WARNING: io_uring/io_uring.h:127 at io_handle_tw_list+0x234/0x2e0 io_ur=
ing/io_uring.c:1155, CPU#1: iou-sqp-6294/6297
> > Modules linked in:
> > CPU: 1 UID: 0 PID: 6297 Comm: iou-sqp-6294 Not tainted syzkaller #0 PRE=
EMPT(full)
> > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-=
1.16.2-1 04/01/2014
> > RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:127 [inline]
> > RIP: 0010:io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155
> > Code: 00 00 48 c7 c7 e0 90 02 8c be 8e 04 00 00 31 d2 e8 01 e5 d2 fc 2e=
 2e 2e 31 c0 45 31 e4 4d 85 ff 75 89 eb 7c e8 ad fb 00 fd 90 <0f> 0b 90 e9 =
cf fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 22 ff
> > RSP: 0018:ffffc900032cf938 EFLAGS: 00010293
> > RAX: ffffffff84bfcba3 RBX: dffffc0000000000 RCX: ffff888107f61cc0
> > RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
> > RBP: ffff8881119a8008 R08: ffff888110bb69c7 R09: 1ffff11022176d38
> > R10: dffffc0000000000 R11: ffffed1022176d39 R12: ffff8881119a8000
> > R13: ffff888108441e90 R14: ffff888107f61cc0 R15: 0000000000000000
> > FS:  00007f81f25716c0(0000) GS:ffff8881a39f5000(0000) knlGS:00000000000=
00000
> > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > CR2: 0000001b31b63fff CR3: 000000010f24c000 CR4: 00000000000006f0
> > Call Trace:
> >  <TASK>
> >  tctx_task_work_run+0x99/0x370 io_uring/io_uring.c:1223
> >  io_sq_tw io_uring/sqpoll.c:244 [inline]
> >  io_sq_thread+0xed1/0x1e50 io_uring/sqpoll.c:327
> >  ret_from_fork+0x47f/0x820 arch/x86/kernel/process.c:148
> >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> >  </TASK>
>
> Probably the sanest thing to do here is to clear
> IORING_SETUP_SINGLE_ISSUER if it's set with IORING_SETUP_SQPOLL. If we
> allow it, it'll be impossible to uphold the locking criteria on both the
> issue and register side.

Yup, I was thinking the same thing. Thanks for taking a look.

Best,
Caleb
