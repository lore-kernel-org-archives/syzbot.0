Received: from mail-pl1-f172.google.com (mail-pl1-f172.google.com [209.85.214.172])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C0D323B618
	for <syzbot@lists.linux.dev>; Thu,  4 Sep 2025 16:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.172
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757004652; cv=none; b=HIDnTWdrVtUwPOxvFEmgq2Yg1vL7LXgfaT5BNx2QgZazeTZRrB9EnTYlMd+X3kB7S2+q6UQ0d0Xx6s22qMir0SoNK++tGii5YgeOagVZE5GFt0s8IpCL107pX0B6tS1MqHg9ZjHxb85nlXUt5xxilpIGvv/fPNFtAZiEGQ5oT28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757004652; c=relaxed/simple;
	bh=5h/ZGpjKd6Wy4f1Ani126vwB6is1nD5I4O62CrgXFQA=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=O0bMhNHM7njk9Lj4UYjkZy3hy8RtcFpiSjeMA3zXqO/XgoWtQsJ15VhqYk9YExCCkWSaFBChGRfzt+P6RDcWy0qwF+wjBLzrtS7OYDtS5En37J2JhrELXk7DjdYnMFbsjCg/lDACJZJf8u2Zoy1Mr2ai5tYxo/m9Fwe0v8SUfD0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=ap1+9/P4; arc=none smtp.client-ip=209.85.214.172
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="ap1+9/P4"
Received: by mail-pl1-f172.google.com with SMTP id d9443c01a7336-24aacdf40a2so2779345ad.1
        for <syzbot@lists.linux.dev>; Thu, 04 Sep 2025 09:50:50 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757004650; x=1757609450; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=lkyMJgz1QRlvZqoy8D2fzlI7UNHQh3WCmZ4lCaLR8Ro=;
        b=ap1+9/P4z7tsCfT3QPDdTQoTzb5xY8nRiwBGI4iWg9MwY0/YEYrJk2rDZHbTctwLOA
         YXU1UTIpTGCrWxi2C/ycbE7g1OhjpcfSEgQYX8O84Pn5CXO3SVYMnNwqKHKdVdJ9D35C
         ufOjIzU/9sd/ENigjyfyIjyhuGP4AW7vnI9lTCDjmoQhCpVys9YyGHZya3/Iz5k9jhJk
         BWaGHuTiduXYYQ2YKOnGzXqUMiQNb+IIYEk0SHX0AfOsXH3wRj4VO4UJ8grEi8c4b/6W
         HB41/9iq0Qno49kGT/LtomD35swppx0PFH9oxHPRGB9qET13RVGOGz05yvGyqhip0N3n
         IBwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757004650; x=1757609450;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=lkyMJgz1QRlvZqoy8D2fzlI7UNHQh3WCmZ4lCaLR8Ro=;
        b=KbnKUvxXg0vz5VfbsHW6PBTl1HDHLK0fmjfg+Lp7AqC3ZcZjT7e3JcL9PSeRSu4Wo7
         1Ssa5ucP2ew3HeM4aZopG3gk7wShV9Mm1aU7mByMJU6wTqV/dAerDjVcVlR8brUK5ufK
         ViFVHcfroW6/dXMNtCSAydpabeXOxShizVvn0SUj8UXbu2fdj+po2RGyQN5/8pzdS/s8
         OTYpLU8cK6+Z2g5l3UksgSY5AHlXFG1G0EdEqaDYivw1Lu/E14atOrJVc0pzNkmEdnMc
         nWP8jG2LS2F8wRBnzCidCXKfmng5AVC0EXI8UTIhxYswIFpYHMe8QgvrbOfnXoCASPp4
         n2Ag==
X-Forwarded-Encrypted: i=1; AJvYcCUcwUO1aT5wxsD7ZfNK85zIa2Sz7K5SbkOQT5yOAFp1zWFCl3ITrkz3N592GPcpGgsAdnBH8DQ=@lists.linux.dev
X-Gm-Message-State: AOJu0Yyh1BnWhsQtQffUwKzxq+4aCWlXFpCUV+OJOCCZs2HnUYY/fwE8
	b/J59KNKmAzyA032EOuUgIbaxIJFjrvTBxZ2KlQ3g+SpaJ0+XZcIT/JMpRN6e+oEvyEx0qfqWNo
	cBOeEcUuJ7nGjctRyq9Ozv6lsXaRL++N1XwapmeYoNA==
X-Gm-Gg: ASbGnct/T1zgx2zIcm93k8SbMbLSECGy7uQAyI+ulqjN+RE/T6oW6qdm0Wxi9UbOKqe
	O5b7yZ1o6U/o7P6C1UZuvMUJHn+FNfDgnNuiI9PtW5kdfS40viyLOdMZAVc8/xJ5Xg2/P7n2OsH
	rB/SMIkJJpqqVu8Wn1Mjp1yDAGANwCU+vJ0E09JnACKHerGZvrEM0KwnJtFE9zpzTlxkp8pcgOd
	WrpxyZHBwej8/6c3i/hAEY=
X-Google-Smtp-Source: AGHT+IHhLZ5Pt6ybFwzsRb1ivhRPYKWmIi5tmg5ySBS6hfiToaYcjrsazkgubk/h3qR5PHg/QR138M/rwLtvzKzVWx8=
X-Received: by 2002:a17:903:1ca:b0:24b:26d7:e28e with SMTP id
 d9443c01a7336-24b26d7e8f9mr67553555ad.5.1757004650236; Thu, 04 Sep 2025
 09:50:50 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68b8b95f.050a0220.3db4df.0206.GAE@google.com> <26aa509e-3070-4f6b-8150-7c730e05951d@kernel.dk>
 <CADUfDZpTtLjyQjURhTOND5XbdJOSEduDLdSuyUJVk_OKG9HVGA@mail.gmail.com> <CADUfDZot=DxWjERupMofRuyvK3jKx79yQUOSniqT4uhMac2dbw@mail.gmail.com>
In-Reply-To: <CADUfDZot=DxWjERupMofRuyvK3jKx79yQUOSniqT4uhMac2dbw@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 4 Sep 2025 09:50:37 -0700
X-Gm-Features: Ac12FXwoHKkNiIS_YmT-LqPC2X-wOUd9r5dSLA30Kf23BEtP_MbSO2h2v5ikruA
Message-ID: <CADUfDZq-x3t6gfzAg8kxe8oNezDwYKggkeZ4o1Jw-Q1smjh6aQ@mail.gmail.com>
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot ci <syzbot+cibd93ea08a14d0e1c@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 9:46=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Thu, Sep 4, 2025 at 7:52=E2=80=AFAM Caleb Sander Mateos
> <csander@purestorage.com> wrote:
> >
> > On Wed, Sep 3, 2025 at 4:30=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wro=
te:
> > >
> > > On 9/3/25 3:55 PM, syzbot ci wrote:
> > > > syzbot ci has tested the following series
> > > >
> > > > [v1] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> > > > https://lore.kernel.org/all/20250903032656.2012337-1-csander@purest=
orage.com
> > > > * [PATCH 1/4] io_uring: don't include filetable.h in io_uring.h
> > > > * [PATCH 2/4] io_uring/rsrc: respect submitter_task in io_register_=
clone_buffers()
> > > > * [PATCH 3/4] io_uring: factor out uring_lock helpers
> > > > * [PATCH 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_IS=
SUER
> > > >
> > > > and found the following issue:
> > > > WARNING in io_handle_tw_list
> > > >
> > > > Full report is available here:
> > > > https://ci.syzbot.org/series/54ae0eae-5e47-4cfe-9ae7-9eaaf959b5ae
> > > >
> > > > ***
> > > >
> > > > WARNING in io_handle_tw_list
> > > >
> > > > tree:      linux-next
> > > > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git=
/next/linux-next
> > > > base:      5d50cf9f7cf20a17ac469c20a2e07c29c1f6aab7
> > > > arch:      amd64
> > > > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b79=
76-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > > config:    https://ci.syzbot.org/builds/1de646dd-4ee2-418d-9c62-617=
d88ed4fd2/config
> > > > syz repro: https://ci.syzbot.org/findings/e229a878-375f-4286-89fe-b=
6724c23addd/syz_repro
> > > >
> > > > ------------[ cut here ]------------
> > > > WARNING: io_uring/io_uring.h:127 at io_ring_ctx_lock io_uring/io_ur=
ing.h:127 [inline], CPU#1: iou-sqp-6294/6297
> > > > WARNING: io_uring/io_uring.h:127 at io_handle_tw_list+0x234/0x2e0 i=
o_uring/io_uring.c:1155, CPU#1: iou-sqp-6294/6297
> > > > Modules linked in:
> > > > CPU: 1 UID: 0 PID: 6297 Comm: iou-sqp-6294 Not tainted syzkaller #0=
 PREEMPT(full)
> > > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-deb=
ian-1.16.2-1 04/01/2014
> > > > RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:127 [inline]
> > > > RIP: 0010:io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155
> > > > Code: 00 00 48 c7 c7 e0 90 02 8c be 8e 04 00 00 31 d2 e8 01 e5 d2 f=
c 2e 2e 2e 31 c0 45 31 e4 4d 85 ff 75 89 eb 7c e8 ad fb 00 fd 90 <0f> 0b 90=
 e9 cf fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 22 ff
> > > > RSP: 0018:ffffc900032cf938 EFLAGS: 00010293
> > > > RAX: ffffffff84bfcba3 RBX: dffffc0000000000 RCX: ffff888107f61cc0
> > > > RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
> > > > RBP: ffff8881119a8008 R08: ffff888110bb69c7 R09: 1ffff11022176d38
> > > > R10: dffffc0000000000 R11: ffffed1022176d39 R12: ffff8881119a8000
> > > > R13: ffff888108441e90 R14: ffff888107f61cc0 R15: 0000000000000000
> > > > FS:  00007f81f25716c0(0000) GS:ffff8881a39f5000(0000) knlGS:0000000=
000000000
> > > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > > CR2: 0000001b31b63fff CR3: 000000010f24c000 CR4: 00000000000006f0
> > > > Call Trace:
> > > >  <TASK>
> > > >  tctx_task_work_run+0x99/0x370 io_uring/io_uring.c:1223
> > > >  io_sq_tw io_uring/sqpoll.c:244 [inline]
> > > >  io_sq_thread+0xed1/0x1e50 io_uring/sqpoll.c:327
> > > >  ret_from_fork+0x47f/0x820 arch/x86/kernel/process.c:148
> > > >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> > > >  </TASK>
> > >
> > > Probably the sanest thing to do here is to clear
> > > IORING_SETUP_SINGLE_ISSUER if it's set with IORING_SETUP_SQPOLL. If w=
e
> > > allow it, it'll be impossible to uphold the locking criteria on both =
the
> > > issue and register side.
> >
> > Yup, I was thinking the same thing. Thanks for taking a look.
>
> On further thought, IORING_SETUP_SQPOLL actually does guarantee a
> single issuer. io_uring_enter() already avoids taking the uring_lock
> in the IORING_SETUP_SQPOLL case because it doesn't issue any SQEs
> itself. Only the SQ thread does that, so it *is* the single issuer.
> The assertions I added in io_ring_ctx_lock()/io_ring_ctx_unlock() is
> just unnecessarily strict. It should expect current =3D=3D
> ctx->sq_data->thread in the IORING_SETUP_SQPOLL case.

Oh, but you are totally correct about needing the mutex to synchronize
between issue on the SQ thread and io_uring_register() on other
threads. Yeah, I don't see an easy way to avoid taking the mutex on
the SQ thread unless we disallowed io_uring_register() completely.
Clearing IORING_SETUP_SINGLE_ISSUER seems like the best option for
now.

Best,
Caleb
