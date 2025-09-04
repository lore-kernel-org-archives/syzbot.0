Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9016923D7C7
	for <syzbot@lists.linux.dev>; Thu,  4 Sep 2025 16:46:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1757004384; cv=none; b=li7SH4ubc4Sfk+/jRd1F/rENSAhhY+2+bKMRDnQV7rAAHHMSkowKbgi3XJ7XziT0Fzk752uJLKfNSkB0eExuzvnceF2JXfu8hd6Ul6bOlT6yUBRGrrNywszBzIJIVNd2VyqnvN6zWp/vui8EJ5i5bA57X8EfMlalnYHmEH0ajFA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1757004384; c=relaxed/simple;
	bh=yeig2/h6+JzCj8J11pJs7VODI2hn7tsgFbunC4RZtuw=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=MAq63vbf2JrB0esm9pt6JBCXdOkLO0eA2bSp01j8xRYijHKk3JjGsXeduDIH8cBQrGUsdlAP1B64I3VqQBQfvugmvvI412BIzIPFQTP7MSK44aJxLej+VtEvEQUEXITcuoy+NErSVT0sARugAHfEMf7wvCXTpeNsiJGl78FxIdE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=fK3v1Z79; arc=none smtp.client-ip=209.85.214.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="fK3v1Z79"
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-24b1331cb98so1603525ad.2
        for <syzbot@lists.linux.dev>; Thu, 04 Sep 2025 09:46:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1757004382; x=1757609182; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=esdQfPQXbS6WrJkjrbmIf4YcFmqNl+DroIr0Wz/5KiE=;
        b=fK3v1Z790KWqNWD2sbhavSVz9bCgcAg9zt0ENTthFuRHeZAYt/4FO8lrP+V8R0e2xK
         2r4jqjNwbKHxbor+RCFKIqt8DJEWxHRgReqqkKC0rqA4xyxVALVt5nqXiSIKCjLzQlyX
         9ABmEvlkWgjgSgFrlLS33Rsqhj3kVmzzPlcyNK0UYarkd42VGWYrbB2CRWCTcElPHD/t
         kwuaJSn/OdL8SEE5IqhsJeJEYO1mTzIhTEKtIjsy2AdjKC0ymb0CFyFfS6kCxyyhglN/
         Fw/NXzjxOEYSHUTj9AClfBoL/AvuKN4RAg5HrZVoeobaiBeBs+85uzIs9SXL4Qk2wl/n
         JxWw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1757004382; x=1757609182;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=esdQfPQXbS6WrJkjrbmIf4YcFmqNl+DroIr0Wz/5KiE=;
        b=vMvjWRYoWSkoeDAakn/EkZWJVg7t+eSbpee4M42JC6pfFyeQ8o1gZGyjHkoZCdu/ek
         oxcqmeKuEgF7c6nHK99bpHpyMB5Yxh0wFnaRztpGSU+NbmZhiA6PCs0B+SB1ao/CmOZF
         AUCsGsE0zFWXHvm41++4UU3auqiXc79aV8T2ITUk0VjAbyJUk8cKasW5i6fPTXnbauBM
         o6KqCxvyatCSENmJryilvk0LiInv9XZXdwIIn78vLBS7ut2FvThHom9lWH1jm6+jZzqF
         gwRmYIlnHs9FYJA/eDsZUvlv7Fzd+7rD0mvEObEFUnhmzVer4VlZkKfLk6gT74jEBfum
         2WfA==
X-Forwarded-Encrypted: i=1; AJvYcCX2b4iRNuZzTWPD0ihMbSz07gyC9xyRqh6vzr9Uk94Dp/8j1k8ygYs0MsrYSZMzMG8s5nwusnk=@lists.linux.dev
X-Gm-Message-State: AOJu0YyXIZuyc4auUX3XBoAyFsOlj/wjRsc4qYN7FwgXd8ujn99GDLfJ
	qPQX6aYydux3hPlp5Wj9EBQa1ppVGPSgPtmArhVj0QBmTG5LsJll/xdHaWvVbvOeWq5+nYOW0pY
	w3hhtvZBBWqLisUobK4r8M02iALxctj9/a/c9GvSlmQ==
X-Gm-Gg: ASbGncvf7/EfqQTx8i2VtAgdRGQSxtWAMUqnvaqrNsqcSX3BUu6OLJfgjnIfuzOkP4V
	kApJUuxv5eKDSBFbBjVnpEi2TQmvPLUdvLFB9l6RawQfCewsoerCDezhCgLoqsZR31X/PPN0JCi
	yfdf8fE3+OvGXOrPoRBAa07PDKzt0Z2WeCVHdVwSjXg0zY8aceXnOzQRivr25dND5WiOsQ/oOSp
	FYWzLqiCMBV
X-Google-Smtp-Source: AGHT+IGrZNSK0knOxEHf6PsWEDnTsqGXLr9ZT4FDcu0e0+A+rMw9hJbAM6Q+b2AWs6Aec9Wiln+LuYk7mvryiLvgOqg=
X-Received: by 2002:a17:902:ce8c:b0:24c:7bc8:a51c with SMTP id
 d9443c01a7336-24c7bc8a879mr52655195ad.9.1757004381611; Thu, 04 Sep 2025
 09:46:21 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68b8b95f.050a0220.3db4df.0206.GAE@google.com> <26aa509e-3070-4f6b-8150-7c730e05951d@kernel.dk>
 <CADUfDZpTtLjyQjURhTOND5XbdJOSEduDLdSuyUJVk_OKG9HVGA@mail.gmail.com>
In-Reply-To: <CADUfDZpTtLjyQjURhTOND5XbdJOSEduDLdSuyUJVk_OKG9HVGA@mail.gmail.com>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Thu, 4 Sep 2025 09:46:08 -0700
X-Gm-Features: Ac12FXxn_8Ji6Q7m7oxenDDgFiIonvxO9qeRpHFqvVppbyILUhbyHtFsJ57ZCzw
Message-ID: <CADUfDZot=DxWjERupMofRuyvK3jKx79yQUOSniqT4uhMac2dbw@mail.gmail.com>
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot ci <syzbot+cibd93ea08a14d0e1c@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, linux-kernel@vger.kernel.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Thu, Sep 4, 2025 at 7:52=E2=80=AFAM Caleb Sander Mateos
<csander@purestorage.com> wrote:
>
> On Wed, Sep 3, 2025 at 4:30=E2=80=AFPM Jens Axboe <axboe@kernel.dk> wrote=
:
> >
> > On 9/3/25 3:55 PM, syzbot ci wrote:
> > > syzbot ci has tested the following series
> > >
> > > [v1] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> > > https://lore.kernel.org/all/20250903032656.2012337-1-csander@purestor=
age.com
> > > * [PATCH 1/4] io_uring: don't include filetable.h in io_uring.h
> > > * [PATCH 2/4] io_uring/rsrc: respect submitter_task in io_register_cl=
one_buffers()
> > > * [PATCH 3/4] io_uring: factor out uring_lock helpers
> > > * [PATCH 4/4] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSU=
ER
> > >
> > > and found the following issue:
> > > WARNING in io_handle_tw_list
> > >
> > > Full report is available here:
> > > https://ci.syzbot.org/series/54ae0eae-5e47-4cfe-9ae7-9eaaf959b5ae
> > >
> > > ***
> > >
> > > WARNING in io_handle_tw_list
> > >
> > > tree:      linux-next
> > > URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/n=
ext/linux-next
> > > base:      5d50cf9f7cf20a17ac469c20a2e07c29c1f6aab7
> > > arch:      amd64
> > > compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976=
-1~exp1~20250708183702.136), Debian LLD 20.1.8
> > > config:    https://ci.syzbot.org/builds/1de646dd-4ee2-418d-9c62-617d8=
8ed4fd2/config
> > > syz repro: https://ci.syzbot.org/findings/e229a878-375f-4286-89fe-b67=
24c23addd/syz_repro
> > >
> > > ------------[ cut here ]------------
> > > WARNING: io_uring/io_uring.h:127 at io_ring_ctx_lock io_uring/io_urin=
g.h:127 [inline], CPU#1: iou-sqp-6294/6297
> > > WARNING: io_uring/io_uring.h:127 at io_handle_tw_list+0x234/0x2e0 io_=
uring/io_uring.c:1155, CPU#1: iou-sqp-6294/6297
> > > Modules linked in:
> > > CPU: 1 UID: 0 PID: 6297 Comm: iou-sqp-6294 Not tainted syzkaller #0 P=
REEMPT(full)
> > > Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debia=
n-1.16.2-1 04/01/2014
> > > RIP: 0010:io_ring_ctx_lock io_uring/io_uring.h:127 [inline]
> > > RIP: 0010:io_handle_tw_list+0x234/0x2e0 io_uring/io_uring.c:1155
> > > Code: 00 00 48 c7 c7 e0 90 02 8c be 8e 04 00 00 31 d2 e8 01 e5 d2 fc =
2e 2e 2e 31 c0 45 31 e4 4d 85 ff 75 89 eb 7c e8 ad fb 00 fd 90 <0f> 0b 90 e=
9 cf fe ff ff 89 e9 80 e1 07 80 c1 03 38 c1 0f 8c 22 ff
> > > RSP: 0018:ffffc900032cf938 EFLAGS: 00010293
> > > RAX: ffffffff84bfcba3 RBX: dffffc0000000000 RCX: ffff888107f61cc0
> > > RDX: 0000000000000000 RSI: 0000000000001000 RDI: 0000000000000000
> > > RBP: ffff8881119a8008 R08: ffff888110bb69c7 R09: 1ffff11022176d38
> > > R10: dffffc0000000000 R11: ffffed1022176d39 R12: ffff8881119a8000
> > > R13: ffff888108441e90 R14: ffff888107f61cc0 R15: 0000000000000000
> > > FS:  00007f81f25716c0(0000) GS:ffff8881a39f5000(0000) knlGS:000000000=
0000000
> > > CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > CR2: 0000001b31b63fff CR3: 000000010f24c000 CR4: 00000000000006f0
> > > Call Trace:
> > >  <TASK>
> > >  tctx_task_work_run+0x99/0x370 io_uring/io_uring.c:1223
> > >  io_sq_tw io_uring/sqpoll.c:244 [inline]
> > >  io_sq_thread+0xed1/0x1e50 io_uring/sqpoll.c:327
> > >  ret_from_fork+0x47f/0x820 arch/x86/kernel/process.c:148
> > >  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
> > >  </TASK>
> >
> > Probably the sanest thing to do here is to clear
> > IORING_SETUP_SINGLE_ISSUER if it's set with IORING_SETUP_SQPOLL. If we
> > allow it, it'll be impossible to uphold the locking criteria on both th=
e
> > issue and register side.
>
> Yup, I was thinking the same thing. Thanks for taking a look.

On further thought, IORING_SETUP_SQPOLL actually does guarantee a
single issuer. io_uring_enter() already avoids taking the uring_lock
in the IORING_SETUP_SQPOLL case because it doesn't issue any SQEs
itself. Only the SQ thread does that, so it *is* the single issuer.
The assertions I added in io_ring_ctx_lock()/io_ring_ctx_unlock() is
just unnecessarily strict. It should expect current =3D=3D
ctx->sq_data->thread in the IORING_SETUP_SQPOLL case.

Best,
Caleb
