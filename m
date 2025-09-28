Received: from mail-oa1-f50.google.com (mail-oa1-f50.google.com [209.85.160.50])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AF981FE45A
	for <syzbot@lists.linux.dev>; Sun, 28 Sep 2025 18:40:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.50
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1759084822; cv=none; b=ft37MEjHNEtREPesNdPPlVfkSAJI8RDkH39mu1Ik+gurr3Ew1YRU0WxBou0akQ8xQYv73sBI7sz17kPQmbd4Mke0RMMYM+epIGwobcHMV8spBmLwWNrEp25ncAoYolV5RgViuYQPY89x3BXYQtc6vTzF00PAKseRFp+sVkaLIvA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1759084822; c=relaxed/simple;
	bh=NOlLjdbQNAYYQM6LCujPrW95kpJeNfoAscesnWXpDDI=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ERfZkOGpcq4v2sBz0ev9Trs5iG0xX3Lp8Z/xwz6NTbzCQyzeVKU8MRwqdjr9vCeTtMSL70d3rgz0jqKz/AoliFCCAg2v0xNrb13DVwolzv478D52vM9f6l+NiE67C2bEy7T48yMVdRhohCiKwXUvn8VA9WWh2RIJFrc6Y9Ze4R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=A/IMbhz7; arc=none smtp.client-ip=209.85.160.50
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="A/IMbhz7"
Received: by mail-oa1-f50.google.com with SMTP id 586e51a60fabf-36f13d00674so1916384fac.1
        for <syzbot@lists.linux.dev>; Sun, 28 Sep 2025 11:40:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1759084818; x=1759689618; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=YgOaOhmbVPsc2EICDs9d2jG+T7J4OZlwfJ+TNwXvB2k=;
        b=A/IMbhz7ai5xAiqKzmwjBD291aiKwn+KsqTiA2dJ1G4b4H2yD0MO+1mLwJYFF5f/7/
         DrF5hG2bQE9fvSOM8lww8hHxVVunANwvq3yfI45yqEYBRNBQA3B2sNn4LO9RvU7bwCn8
         eZzSmnzl2YjAptFQ3MQ2jzes2eA7bVHkNtG3npYr7zXo7cVbTBR+BWuF7lCaevVNKZtq
         /MPjcQGN1ETT7RO1U8hXzXxdCFHBCPSLoUuG3JS8gYkNBvgqJ8vJ4yLokinymAgbec20
         +u70rxdXhsYipElqiGKWwkB4kaeInJ7w+IL5WHM4ZGJDV0DC3BDwCFbM2q6tvjhaawGN
         Uu+A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1759084818; x=1759689618;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=YgOaOhmbVPsc2EICDs9d2jG+T7J4OZlwfJ+TNwXvB2k=;
        b=gHqZL+YRvkh4FngE7kiKlL2nDkZbPp6Wfje7EdzdQRqSp6lzDp5tUQ4+TXMVnHNBIM
         G9db7XmtZdABGy0za9HMql69y4ehfU6g05N49TFUfHLgwQqkn5bS56de6B7+Ajz+7Ppe
         fmATlVXA0HD5D/vXFSG0UYhHFzPF9KM2khCxdUk+1AlI5giTfw753jiQOQe8IlB0gW7x
         i62SeBSt9Qoz6zITQmL7MAAvBXbnX3nIUxNQsNlm0ix7DGAiN0kccyeXNyMx4TAuuQIH
         q//P/8JPoxM6XD49v2k71R2h/f92L93LBj5e4xUzpxYv+8HQgt/cvktYeZKnBERcnQn+
         qJPQ==
X-Forwarded-Encrypted: i=1; AJvYcCXUMEib2kdv1xkS36ypzgJdvgXF6Ie62ylGaCfMDZTlkEkWkzToC0XY8372+L+fu5FtCBwYvOg=@lists.linux.dev
X-Gm-Message-State: AOJu0YzdQZ/R/NjsKk+DEg3aRZpavXKHEN2MOrbEAoHO0uM7AXctdeaq
	f5q83B1QKlShVpQSERcfIbnEVP+GTAnB8ADEQ2Dc+emclJNLyxww7WwLmabUHfzEnGv6ccRGNqD
	zJWE6/Zkq5aE095NifP/bIJzKOBXF14yqQ0pMk3Xn
X-Gm-Gg: ASbGncu1lRm4x0Gnoslug5kygaGZ4XI3kswp1hDLIwiGnsE+z7+rQEjgpQiOKy6G1Vy
	xqTt7Wckm6p+YOgm771Ah3A6ehBu5DqmV8EGe1OsOfphfNkjp4ee9Cltwdm930BVg6C91M7wX2l
	XVuhBgzkGrypS7if9zQp3SUT19cqOeXHJYEn8EwG+KPTUIRaVyYCS5/5vn/2IislneMssZxLJm6
	K0Cic8=
X-Google-Smtp-Source: AGHT+IELSWEDiURC71HEBWOE0BfcDlG1DaleT0euZXw2E/U7Gyyr9KgEKp/jLg6FPS9lG6lP6jUwluRpAMuOYGIor1U=
X-Received: by 2002:a05:6870:d110:b0:387:3c81:ee9 with SMTP id
 586e51a60fabf-3873c812845mr44311fac.51.1759084818056; Sun, 28 Sep 2025
 11:40:18 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <68d96ce9.a70a0220.10c4b.0023.GAE@google.com>
In-Reply-To: <68d96ce9.a70a0220.10c4b.0023.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 28 Sep 2025 20:40:06 +0200
X-Gm-Features: AS18NWAhrxILlhQ5m3Gl7-VnuvNSuKpo7qbK28Mg3HyUjtjJ8ez6aAnpeKCus2s
Message-ID: <CANp29Y6J5dFQo+zLFvH6rj5QrLMDrDkg2_rdpK-1KLTa9y_fdQ@mail.gmail.com>
Subject: Re: [moderation/CI] Re: loop: improve loop aio perf by IOCB_NOWAIT
To: syzbot ci <syzbot+cia1c4ba95cce7b302@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Sep 28, 2025 at 7:14=E2=80=AFPM syzbot ci
<syzbot+cia1c4ba95cce7b302@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] loop: improve loop aio perf by IOCB_NOWAIT
> https://lore.kernel.org/all/20250928132927.3672537-1-ming.lei@redhat.com
> * [PATCH V4 1/6] loop: add helper lo_cmd_nr_bvec()
> * [PATCH V4 2/6] loop: add helper lo_rw_aio_prep()
> * [PATCH V4 3/6] loop: add lo_submit_rw_aio()
> * [PATCH V4 4/6] loop: move command blkcg/memcg initialization into loop_=
queue_work
> * [PATCH V4 5/6] loop: try to handle loop aio command via NOWAIT IO first
> * [PATCH V4 6/6] loop: add hint for handling aio via IOCB_NOWAIT
>
> and found the following issue:
> WARNING in lo_submit_rw_aio
>
> Full report is available here:
> https://ci.syzbot.org/series/0ffdb6b4-a5fe-48da-9473-d2a926e780bd
>
> ***
>
> WARNING in lo_submit_rw_aio
>
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torva=
lds/linux
> base:      07e27ad16399afcd693be20211b0dfae63e0615f
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/3aba003b-2400-4e88-9a31-c09ab4e41=
a84/config
> C repro:   https://ci.syzbot.org/findings/dc97454c-d87b-41f5-a44a-7182e66=
6cfd5/c_repro
> syz repro: https://ci.syzbot.org/findings/dc97454c-d87b-41f5-a44a-7182e66=
6cfd5/syz_repro
>
> ------------[ cut here ]------------
> WARNING: CPU: 0 PID: 5958 at drivers/block/loop.c:907 loop_inc_blocking_w=
rites drivers/block/loop.c:907 [inline]
> WARNING: CPU: 0 PID: 5958 at drivers/block/loop.c:907 loop_queue_work+0xb=
3b/0xc30 drivers/block/loop.c:1005
> Modules linked in:
> CPU: 0 UID: 0 PID: 5958 Comm: udevd Not tainted syzkaller #0 PREEMPT(full=
)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:loop_inc_blocking_writes drivers/block/loop.c:907 [inline]
> RIP: 0010:loop_queue_work+0xb3b/0xc30 drivers/block/loop.c:1005
> Code: 33 bf 08 00 00 00 4c 89 ea e8 c1 89 7e fb 4c 89 f7 48 83 c4 30 5b 4=
1 5c 41 5d 41 5e 41 5f 5d e9 cb 87 71 05 e8 26 36 b4 fb 90 <0f> 0b 90 e9 4e=
 fe ff ff e8 18 36 b4 fb 48 83 c5 18 48 89 e8 48 c1
> RSP: 0018:ffffc9000340ef38 EFLAGS: 00010093
> RAX: ffffffff860b776a RBX: ffff88802187c000 RCX: ffff88810cee3980
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: 0000000000000003 R09: 0000000000000004
> R10: dffffc0000000000 R11: fffff52000681dc4 R12: ffff88802187c158
> R13: ffff88802187c110 R14: ffff888021989460 R15: ffff888021989418
> FS:  00007f649c5a4c80(0000) GS:ffff8880b8612000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 000056520d53f000 CR3: 0000000109e48000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  lo_submit_rw_aio+0x493/0x620 drivers/block/loop.c:441
>  lo_rw_aio_nowait drivers/block/loop.c:508 [inline]
>  loop_queue_rq+0x64d/0x840 drivers/block/loop.c:2026
>  __blk_mq_issue_directly block/blk-mq.c:2695 [inline]
>  blk_mq_request_issue_directly+0x3c1/0x710 block/blk-mq.c:2782
>  blk_mq_issue_direct+0x2a0/0x660 block/blk-mq.c:2803
>  blk_mq_dispatch_queue_requests+0x621/0x800 block/blk-mq.c:2878
>  blk_mq_flush_plug_list+0x432/0x550 block/blk-mq.c:2961
>  __blk_flush_plug+0x3d3/0x4b0 block/blk-core.c:1220
>  blk_finish_plug+0x5e/0x90 block/blk-core.c:1247
>  read_pages+0x3b2/0x580 mm/readahead.c:173
>  page_cache_ra_unbounded+0x6b0/0x7b0 mm/readahead.c:297
>  do_page_cache_ra mm/readahead.c:327 [inline]
>  force_page_cache_ra mm/readahead.c:356 [inline]
>  page_cache_sync_ra+0x3b9/0xb10 mm/readahead.c:572
>  filemap_get_pages+0x43c/0x1ea0 mm/filemap.c:2603
>  filemap_read+0x3f6/0x11a0 mm/filemap.c:2712
>  blkdev_read_iter+0x30a/0x440 block/fops.c:852
>  new_sync_read fs/read_write.c:491 [inline]
>  vfs_read+0x55a/0xa30 fs/read_write.c:572
>  ksys_read+0x145/0x250 fs/read_write.c:715
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0xfa/0x3b0 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f649c116b6a
> Code: 00 3d 00 00 41 00 75 0d 50 48 8d 3d 2d 08 0a 00 e8 ea 7d 01 00 31 c=
0 e9 07 ff ff ff 64 8b 04 25 18 00 00 00 85 c0 75 1b 0f 05 <48> 3d 00 f0 ff=
 ff 76 6c 48 8b 15 8f a2 0d 00 f7 d8 64 89 02 48 83
> RSP: 002b:00007ffd6597a888 EFLAGS: 00000246 ORIG_RAX: 0000000000000000
> RAX: ffffffffffffffda RBX: 0000000000040000 RCX: 00007f649c116b6a
> RDX: 0000000000040000 RSI: 000056520d500438 RDI: 0000000000000009
> RBP: 0000000000040000 R08: 000056520d500410 R09: 0000000000000010
> R10: 0000000000004011 R11: 0000000000000246 R12: 000056520d500410
> R13: 000056520d500428 R14: 000056520d3cf9c8 R15: 000056520d3cf970
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
> [axboe@kernel.dk dchinner@redhat.com hch@lst.de linux-block@vger.kernel.o=
rg linux-fsdevel@vger.kernel.org ming.lei@redhat.com mpatocka@redhat.com zh=
aoyang.huang@unisoc.com]
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
-upstream-moderation/68d96ce9.a70a0220.10c4b.0023.GAE%40google.com.
