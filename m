Received: from mail-ot1-f54.google.com (mail-ot1-f54.google.com [209.85.210.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83820257851
	for <syzbot@lists.linux.dev>; Tue, 30 Dec 2025 07:13:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767078839; cv=none; b=QPK0cghkbtof7EZC2tJrDOyuXmWo4VrB8MtPeoqmDYMt3bzRdLTQoL878IQlucIG7Fe0YY693DyZA8y9Hz3J/zr4qsuckC8sot+7HLBV3GouGUCuwizEMt9wfy33sw4kyhiBLMPrtZhd/BDm9E9vmFcoS4UxGJFTIC0bRa5cxx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767078839; c=relaxed/simple;
	bh=WQJqGqDeK5RCatjb4xtJ29QvYoLGmdx9dgLGnQacC6k=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=gSXdEZOL4eSMHLMnxBqQdjt7iLuZc0yVfthGampAdDKVZaBGIJ1S+892NaA6P49lffeeGL6KZxopwCtLtzFOAQGY/WerXFofwphbBEQgNOzErMXcNqxzz1Dq/2tHy4MEJS4+Sv8ryNnvh59wwV5iTJafk7ZmBKoBtNIM6YyDvMs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=OJcJKXn4; arc=none smtp.client-ip=209.85.210.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="OJcJKXn4"
Received: by mail-ot1-f54.google.com with SMTP id 46e09a7af769-7c7503c73b4so5105975a34.3
        for <syzbot@lists.linux.dev>; Mon, 29 Dec 2025 23:13:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1767078836; x=1767683636; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=sdFSWN/GEqgV07B7bTHiGl4WdwfmUZIMwMU+hqp5u9Y=;
        b=OJcJKXn4kUxBAvXHCzSBO8Zzsq/ZoQkYHMTKfj3bCPJEELR7WtAUcaL2xxxsVo0Apm
         c5N+lr9tZdM5dVHYlIinI+xWN/RkT7lkekxBZinu9OGI5T9WR76s4VML/meyPcGMKehb
         /xjw2b8m5dpuEJh/pdwQD161gb55RlFYUkSoPn/tMAIDihsedaIIlINJwgZ0ufzMCdZ6
         zJZ5SsWcmVsk+V8SPTiHgOG00sHOOEdJXymZ400LqCl5b5QPsHPVXcYyz6MLVWAEyKdY
         YIkN/ad+wBdqmSQheqY//8lnj0o9jLn8WuYITF/vNgLKbPdlk9F/ypW0rzcjz6G+aO/n
         QCHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1767078836; x=1767683636;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=sdFSWN/GEqgV07B7bTHiGl4WdwfmUZIMwMU+hqp5u9Y=;
        b=PNw6Km8RWLYcFYqd0/c93La4CqiWUN9HcYE8tsXW6+3Ic6XUYnj9JAQs1V7mEbYT05
         k/alF5MIx1pjM0k5FfbZ8RP8xaYGmqG8hHyujwngq07U3Mcb2jn5cxz3dgTI/ORrX5KR
         91DhT2/vJD/iCZDKAI1aXsnsvgq9MievB2PoLTatRbx2OSuH1fYTjtOhUnSCJ3pDvGp0
         igaOV8L0m6kKOVapU0apSpYML92NmkPDi0wNfkZKXo30jrTu8rnpSDUZAjPOOQ93P409
         VsqKjFpThlprAU5mmf9ywTaafkCyGxhwKnAT+21rKP5LkjbGjG1mB4L3iSbhu3bkBx5J
         6SaA==
X-Forwarded-Encrypted: i=1; AJvYcCUdrlaZ2QEbTRPilxAevykVCANOqc5iWAtgZu9/Bu4btICZxvyz19f8daaAk9rMbekH8cPWNDU=@lists.linux.dev
X-Gm-Message-State: AOJu0YzWFlJ6zQdDRp+TX/K/Emee0XAsWkH9/em+eGAQijYKExsXaxi7
	pATGyqaOK7BNTE7sbY8WWskmvxLhD/ph1m0hLRQb5L7xiA1xm6zyT+Y33gKXjJy0VfRINwFOFay
	z52VH2GhNC927AQnyaod/GnpTdHPtXZQ0hZhtKqmi
X-Gm-Gg: AY/fxX6CHHuv+Sir8cxb180mKuJqQ9JNz0iSOnLLq3XQ3jugm0BOcukA3rDruvJNhd3
	f+JNYnCol5VyIAmi+W2j896st0Lnbew8+e9JOvU/v4X8eF1+QHKa2pURpwZ+dqGi2kzkxqLOmBf
	DZNM/hy+FES0eTC3OHRxWo+sCZm4beha9gKlN1xt+ai/YXQHM6DW1mrmV+hfGLi1iu7jnsSnueK
	7LNiEKoywCpDaKr3NVtD0XAuFturXSq6SpsX3dYhS/jwvNeeynbCtme7HeM6l2HGYGx4kTxaPKu
	smsZGWnuy4UOZYzEqLX/oo+S5K0GFkGZAC5CCoa8YKtMaPojMUcrLs4uh0/ih9BnbDwenA==
X-Google-Smtp-Source: AGHT+IGzMR9qZ0099piGqE7jwsx0QHhXzBP7m2MjHEsDdsTQlQp/DSNm4XQOzlxpPZSMzxADCcWcnXhXfgaxKBZpRdE=
X-Received: by 2002:a05:6830:4609:b0:7c7:5d01:a888 with SMTP id
 46e09a7af769-7cc66a17f34mr11229613a34.28.1767078836140; Mon, 29 Dec 2025
 23:13:56 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <69531adb.050a0220.329c0f.0425.GAE@google.com>
In-Reply-To: <69531adb.050a0220.329c0f.0425.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 30 Dec 2025 08:13:45 +0100
X-Gm-Features: AQt7F2pLKRMnNTqNBCn5P8ItLpPCli6EfHAWyo6Va6f9FFeVNXNU1I3cqyYKDAI
Message-ID: <CANp29Y6kpstNb-RZ_L4FD8gs+SjXQPqaNVKkVtQdFw=0pz9ktg@mail.gmail.com>
Subject: Re: [moderation/CI] Re: io_uring: make overflowing cqe subject to OOM
To: syzbot ci <syzbot+ci169c5783fd9cb9a6@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Dec 30, 2025 at 1:20=E2=80=AFAM syzbot ci
<syzbot+ci169c5783fd9cb9a6@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] io_uring: make overflowing cqe subject to OOM
> https://lore.kernel.org/all/20251229201933.515797-1-alexandre@negrel.dev
> * [PATCH] io_uring: make overflowing cqe subject to OOM
>
> and found the following issue:
> WARNING in io_get_cqe_overflow
>
> Full report is available here:
> https://ci.syzbot.org/series/d71ff874-04e1-4cc7-b7c0-e48eb77bc984
>
> ***
>
> WARNING in io_get_cqe_overflow
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      f8f9c1f4d0c7a64600e2ca312dec824a0bc2f1da
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251202083448+f68f64eb8130-1~e=
xp1~20251202083504.46), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/c13ff885-4e87-4df2-9d49-a52f3d040=
dd6/config
> C repro:   https://ci.syzbot.org/findings/e3c6e33b-4e4e-45de-b5b7-4ff5fc3=
63989/c_repro
> syz repro: https://ci.syzbot.org/findings/e3c6e33b-4e4e-45de-b5b7-4ff5fc3=
63989/syz_repro
>
> ------------[ cut here ]------------
> WARNING: io_uring/io_uring.h:211 at io_lockdep_assert_cq_locked io_uring/=
io_uring.h:211 [inline], CPU#0: syz.0.17/5984
> WARNING: io_uring/io_uring.h:211 at io_get_cqe_overflow+0x599/0x730 io_ur=
ing/io_uring.h:249, CPU#0: syz.0.17/5984
> Modules linked in:
> CPU: 0 UID: 0 PID: 5984 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:io_lockdep_assert_cq_locked io_uring/io_uring.h:211 [inline]
> RIP: 0010:io_get_cqe_overflow+0x599/0x730 io_uring/io_uring.h:249
> Code: 0f 0b 90 e9 0e fb ff ff e8 c4 29 35 fd 90 0f 0b 90 e9 91 fb ff ff e=
8 b6 29 35 fd 90 0f 0b 90 e9 6a fd ff ff e8 a8 29 35 fd 90 <0f> 0b 90 e9 5c=
 fd ff ff e8 9a 29 35 fd 90 0f 0b 90 e9 4a fd ff ff
> RSP: 0018:ffffc90003cf7958 EFLAGS: 00010293
> RAX: ffffffff848d4748 RBX: 0000000000000000 RCX: ffff888110c8ba80
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffff888110c8ba80 R09: 0000000000000002
> R10: 00000000fffffdef R11: 0000000000000000 R12: 0000000000000000
> R13: 1ffff11022544c00 R14: ffff888112a26000 R15: dffffc0000000000
> FS:  00005555940b9500(0000) GS:ffff88818e40f000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000001b30563fff CR3: 00000001731de000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  io_get_cqe io_uring/io_uring.h:271 [inline]
>  io_fill_cqe_req io_uring/io_uring.h:293 [inline]
>  __io_submit_flush_completions+0x11c/0xe50 io_uring/io_uring.c:1507
>  io_submit_flush_completions io_uring/io_uring.h:239 [inline]
>  io_submit_state_end io_uring/io_uring.c:2318 [inline]
>  io_submit_sqes+0x1c26/0x2130 io_uring/io_uring.c:2433
>  __do_sys_io_uring_enter io_uring/io_uring.c:3264 [inline]
>  __se_sys_io_uring_enter+0x2f7/0x2c30 io_uring/io_uring.c:3203
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xe2/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f00d579acb9
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f=
7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff=
 ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007ffc380f6178 EFLAGS: 00000246 ORIG_RAX: 00000000000001aa
> RAX: ffffffffffffffda RBX: 00007f00d5a05fa0 RCX: 00007f00d579acb9
> RDX: 0000000000000002 RSI: 0000000000004d10 RDI: 0000000000000003
> RBP: 00007f00d5808bf7 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000002 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007f00d5a05fac R14: 00007f00d5a05fa0 R15: 00007f00d5a05fa0
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
> [alexandre@negrel.dev axboe@kernel.dk io-uring@vger.kernel.org linux-kern=
el@vger.kernel.org]
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
-upstream-moderation/69531adb.050a0220.329c0f.0425.GAE%40google.com.
