Received: from mail-oo2-f41.google.com (mail-oo2-f41.google.com [74.125.231.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58BF62D9EED
	for <syzbot@lists.linux.dev>; Sat, 19 Sep 2026 02:46:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.231.169
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789786013; cv=pass; b=XxV+03qQXFSENFR9RLx+Yr2d/3fam2oY/9IgUxH9m6sAJjAu+P94AqPEAwZbhGA9VhhFVCW8JGoSifqA6Wls6VLJN3W87n+WlSYCVmZaKdSUpoaBDd5vcbWkOWf+t0ne6hXBmI8Y3YYEUGBrWMQvERGMmd6OzkH5XioHxmVQ0Lc=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789786013; c=relaxed/simple;
	bh=gBVxtxXWs9ILngqQ7VwBJos0hKBG8NohVURypF4V7fc=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Mp9juP78KcCA3hRf/3IKY3+4R2eb4D64WrRwFab+3DTAMz22ZND+nqrYfjJgP1ZiVspRJqhZaiV3H5MCuB5elwk7E6NMz28PbV2J4mdFXAcFIQMw+pyvOMjKJRR/LPSN9NwxWrLeV2M51Iq4Hswt9A4dCKgebz06Ke+TwiPz6Jg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=Msof6BUK; arc=pass smtp.client-ip=74.125.231.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="Msof6BUK"
Received: by mail-oo2-f41.google.com with SMTP id 006d021491bc7-6b1ae6f5fc5so663930eaf.0
        for <syzbot@lists.linux.dev>; Fri, 18 Sep 2026 19:46:51 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1789786010; cv=none;
        d=google.com; s=arc-20260327;
        b=lNzf8iHsj7RaW2wA00H9lY+mRb7FP7uWjWto3My1DmTp6ZJF8i8QmpsmhKBPASLQsd
         UT+LQWm7zcA2W1vxuJAkUE40lnksB0PUjilvNkP1CB5j9ldJEyLvXHT55rWEBHUZcVvy
         JDuQ5REjumJ6SidPMyewxfefnHYnMjJNsi/2wpo4VEh/QaZQygfW23pZ9Go0wa2EdQKP
         eDhISFmMUYU5dAT/nboq+nmonVYavzEtk5HQXbqr88FxW1Eq/ygigPWMjbqCOlS55Owu
         /9bLsN6IC9dlLQ+HDnwbK9LEnUdyEQqa0vrXm0UXU19j6vOybkROfcbbxGPhP2NzTN7D
         +Ahg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=n9zmaLn+movL5vL283Ia50CUO4pHtaQB7pY0BAsw4Aw=;
        fh=+RYPBbhFvQnQkng9/0OMKfcEqMBCGzjhx2bLC2RB3ks=;
        b=Y0rO49/vHJzw0bPMkV8Vu2APvUtmx03SHsgGCT7eLBwv1goaSJW2ExLdhSBdkFYhVl
         FG/ZWVJ/Bp/H40Llg42a+eSFd3fbi/un6g/78pSUvyMjTt1G7utqRXGkPoY/rwvLcBDt
         AFL/8nOSTiT4PolWkVKAAbiQaECIpkAEvqpqo2TD3l2FqDkZX2zopprH1dgy8W4Lc1rt
         XIKVdM6svrKZ/NefJRr+gDl1N/0SUVfA742FAaIwMTWg5Ev52hljNncElV3ZkUUrYbA/
         adtCS2cgvJseXtCCB259k8rEF90v2LzOg10coLP6sHXyKI7KoxEV5fAhvMCDOxYT4PyK
         fmkA==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1789786010; x=1790390810; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=n9zmaLn+movL5vL283Ia50CUO4pHtaQB7pY0BAsw4Aw=;
        b=Msof6BUKP9eutdvJNqv+4ryUQ3+wcpluhcrGRpTpbCAKaXSXLdaJoBIewD8It3hQMa
         5QkIvkeZPnWLT7nNw2QcV4n5aoZANm225D/ylTsnT6SBkIB9q+qiVC+Bn9bCsfUTkgSm
         ferXh+dKULv7hwahukVjVrUY1JPPWTHl4rSpmik9XQJIrzi4+0fqDXHG0Ej2pVD+AILt
         53qirY3NcuviN9nxnG6llMOcA9uhvrBmcsX13HGlBApxrzFFrnsxvyMXP4+IsvzIIjir
         B3AyNDbSo12+lW9zV2mp349cyh53YUW/lS069KblkUNL5h+lP99mAi17eh1D7iMwLH8p
         Vq8w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789786010; x=1790390810;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=n9zmaLn+movL5vL283Ia50CUO4pHtaQB7pY0BAsw4Aw=;
        b=YkmBFOGGqzSzBpRtE3scIS2PWQoalc5hdH9dnog+6CYRYkvGCwkshn1N+3coYfLoFr
         scXJ1cgHrJtImxUnwkpWIzqd0jPk1nt/IYBDzObafE4fjCk1GECMSc19pejka2XBnFJ7
         0T9zrmS1LT/oq4J9I3ZMC6kcpJENRIJY+0qtTHq0OtqSu85sgFJNcVqWBCkFzAhyA0Do
         Q95iuKwP9yqj9gyvHAuJh7QB8qZBhUU8nqOpQgxHK7XbF0/2mfE7407kWXhFomLqUjEa
         lUlfN1uiHSSyRWVQUqp18OgeNhHzVMHP3KyVCzIIWiE/+mJuD1qUDoKwUwHUK6KueH6c
         vrpg==
X-Forwarded-Encrypted: i=1; AKwUvBy2Bl9iyD4SpRwYBA07RTRhqkvYywEosLi3kN825Aux3w6mvN7fsfcx48j1LeSQ8BNQg0uB5sY=@lists.linux.dev
X-Gm-Message-State: AFuF++nnjcteESbRb8OxaKyMPsHOySROJXnF9lSdSRmb+Y0lurZksYuf
	64K17vz5/nGODTMlKyMUSn0TLDnHb2GMZ+SEj0FDBIRtioEc9PwMyTDoDfBD39CRPXytALjmDX8
	VDJsl6h53DqAyqzClSdvU3NIjN0WmHAcpb6dmIv2E
X-Gm-Gg: AYBFou3tHld1LWcbXTX/NdVlVqbChjQJit2LDyhKmerL3A8+8L73C1vRpkulRWq7Nnc
	4OoU3myPPO4fWmY3T6PgPmKXic0mME8vyL396LVV0L33gXnZPEyOvWy6YdVptPLrfIMJUPF6Jdf
	5g5tXuUqAaKZ+8zRBs3BE/DfB6TAgOhKis1MflKiG6/t7StrftkrkuOsUXcR7hXzSXc65k76JKx
	pODUoXpwj9A/GI8WgwhMRoxf2r+X8Jsdkg2X7gRRlkjhWCvYouSXzzAoLnnkAFmj5sZNcjjWR9C
	BJFES9Rm/OEaAlPBZIKaAaJ2O9U4aiWoswPW2a34xVObRQoT1zxbxy9yFOdyfG8cWyWqC/qgCX0
	0OAxXGb4H1lfc3cPfG0HW37YOuKFYz70ZQyJQmi2FUUT3Pth3c6It1ks5hE6VIZQFIRPEpw==
X-Received: by 2002:a05:6820:61b:b0:6b1:a812:987b with SMTP id
 006d021491bc7-6ca9a02321amr4105631eaf.14.1789786009654; Fri, 18 Sep 2026
 19:46:49 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6aad86e8.b398a7c9.1f86be.003b.GAE@google.com>
In-Reply-To: <6aad86e8.b398a7c9.1f86be.003b.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sat, 19 Sep 2026 04:46:38 +0200
X-Gm-Features: AcwNN1UwL5lpp8QYmvPp-Zm-Jhxvfz6YvzZbANLEAqV80-3Xhn9uur2QFT7hPf8
Message-ID: <CANp29Y4RarhAprvzgFjRQruzc4uvDRzS9i+v5pFKZD66_MA9ig@mail.gmail.com>
Subject: Re: [moderation/CI] Re: loop: Fix teardown
To: syzbot ci <syzbot+cid93fbb9db8ac4291@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream


On Fri, Sep 18, 2026 at 8:46=E2=80=AFPM syzbot ci
<syzbot+cid93fbb9db8ac4291@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] loop: Fix teardown
> https://lore.kernel.org/all/cover.1789587960.git.bvanassche@acm.org
> * [PATCH 1/2] block: Add post_release() operation
> * [PATCH 2/2] loop: Perform __loop_clr_fd() after disk->open_mutex is dro=
pped
>
> and found the following issue:
> general protection fault in lo_post_release
>
> Full report is available here:
> https://ci.syzbot.org/series/81bfb244-11b0-4b8a-aa02-a212681ff0af
>
> ***
>
> general protection fault in lo_post_release
>
> tree:      axboe
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe=
/linux.git
> base:      2dd9768a37dbb99398c5e332485dbb107ac397c8
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/e21a78bb-e498-4518-8734-d31ae58a2=
538/config
> AI triage: https://ci.syzbot.org/findings/add69d7e-57e2-465d-8c07-9db3934=
582f9/triage_trajectory
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000000a: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
> CPU: 0 UID: 0 PID: 26297 Comm: udevd Not tainted syzkaller #0 PREEMPT(ful=
l)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:lo_post_release+0x498/0x7f0
> Code: 4c 89 ff e8 7a 73 f9 fb bf e0 01 00 00 49 03 3f be 02 00 00 00 e8 1=
8 05 9e 05 48 8b 44 24 10 4c 8d 60 50 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00=
 74 08 4c 89 e7 e8 49 73 f9 fb 41 bf e8 00 00 00 4d
> RSP: 0018:ffffc90003d6fb60 EFLAGS: 00010206
> RAX: 000000000000000a RBX: ffff8881699b3000 RCX: 0000000000000046
> RDX: 0000000000000006 RSI: ffffffff8e414976 RDI: ffffffff8c6da780
> RBP: ffffc90003d6fd08 R08: ffffffff907a477f R09: 1ffffffff20f48ef
> R10: dffffc0000000000 R11: fffffbfff20f48f0 R12: 0000000000000050
> R13: 1ffff920007adf74 R14: dffffc0000000000 R15: ffff888169a02080
> FS:  00007fa1afb46c80(0000) GS:ffff88818d6ce000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f0d423a8440 CR3: 00000001bee1a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  bdev_release+0x59a/0x6b0
>  blkdev_release+0x15/0x20
>  __fput+0x418/0xa50
>  fput_close_sync+0x11f/0x240
>  __x64_sys_close+0x7e/0x110
>  do_syscall_64+0x166/0x520
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa1af7170a8
> Code: 48 8b 05 83 9d 0d 00 64 c7 00 16 00 00 00 83 c8 ff 48 83 c4 20 5b c=
3 64 8b 04 25 18 00 00 00 85 c0 75 20 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 76 5b 48 8b 15 51 9d 0d 00 f7 d8 64 89 02 48 83
> RSP: 002b:00007ffeef68bbb8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: ffffffffffffffda RBX: 00007fa1afb46ae0 RCX: 00007fa1af7170a8
> RDX: 0000559097caaeb5 RSI: 00007ffeef68b3b8 RDI: 0000000000000008
> RBP: 00005595ce9a3e90 R08: 0000000000000006 R09: a8cc15e7d6acaf3b
> R10: 000000000000010f R11: 0000000000000246 R12: 0000000000000002
> R13: 00005595ce999920 R14: 0000000000000008 R15: 00005595ce964910
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:lo_post_release+0x498/0x7f0
> Code: 4c 89 ff e8 7a 73 f9 fb bf e0 01 00 00 49 03 3f be 02 00 00 00 e8 1=
8 05 9e 05 48 8b 44 24 10 4c 8d 60 50 4c 89 e0 48 c1 e8 03 <42> 80 3c 30 00=
 74 08 4c 89 e7 e8 49 73 f9 fb 41 bf e8 00 00 00 4d
> RSP: 0018:ffffc90003d6fb60 EFLAGS: 00010206
> RAX: 000000000000000a RBX: ffff8881699b3000 RCX: 0000000000000046
> RDX: 0000000000000006 RSI: ffffffff8e414976 RDI: ffffffff8c6da780
> RBP: ffffc90003d6fd08 R08: ffffffff907a477f R09: 1ffffffff20f48ef
> R10: dffffc0000000000 R11: fffffbfff20f48f0 R12: 0000000000000050
> R13: 1ffff920007adf74 R14: dffffc0000000000 R15: ffff888169a02080
> FS:  00007fa1afb46c80(0000) GS:ffff88818d6ce000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000055556cac6a68 CR3: 00000001bee1a000 CR4: 00000000000006f0
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
>
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
>
> The email will later be sent to:
> [a.hindborg@kernel.org axboe@kernel.dk bvanassche@acm.org gary@garyguo.ne=
t hch@lst.de linux-block@vger.kernel.org nilay@linux.ibm.com ojeda@kernel.o=
rg penguin-kernel@i-love.sakura.ne.jp royenheart@gmail.com sunke@kylinos.cn=
]
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
-upstream-moderation/6aad86e8.b398a7c9.1f86be.003b.GAE%40google.com.
