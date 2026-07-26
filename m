Received: from mail-ot1-f46.google.com (mail-ot1-f46.google.com [209.85.210.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D84FF5477E
	for <syzbot@lists.linux.dev>; Sun, 26 Jul 2026 07:05:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.46
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785049522; cv=pass; b=ogiWLbP7U13YUh1CH9wKjFaGGFZhIB0L344w4HnyNILue0USHRPzolSar5zvFkbGk+NFGoau53e5NxJILXY/OlvqEf1Kk4C6rpFZ0+MvWqZIxUyWKXnungYiLFnuC7EGUgasqQ9DRCPhYJ6hels9Z4CCpo7v7enwj0eq33/IFcU=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785049522; c=relaxed/simple;
	bh=Tfu93rEuK+mXl/03AoBxitBS9Op52u5/nCrmyB33KUk=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=ojbCaumeD5sD3MqXEwrMFc8m6xS1zwgTKtP9THDnAzaiA1j+cXwmbZjJnGGHixECw7s8dY8K9L1bM9f7oGvHUrWsMHj/MSbT1iIJTW0q3lVDeu99n/j/LQ+LUckzZ81rX5Zt0Katrd85tmWRS7CMYbHOkdmvVwkEzrs+NHxBsjE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=MmjqWfyy; arc=pass smtp.client-ip=209.85.210.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="MmjqWfyy"
Received: by mail-ot1-f46.google.com with SMTP id 46e09a7af769-7eb42a2f5feso700630a34.1
        for <syzbot@lists.linux.dev>; Sun, 26 Jul 2026 00:05:20 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1785049520; cv=none;
        d=google.com; s=arc-20260327;
        b=nsmpBGvO3xXXxISeU7ienN/XJ2WHB5NBmRw1h1JCK1ykZBeX1Qpp7xw76MAv3MiG75
         21DNwItbwX3VoPnaITsya7jrV8QSTRQciO+mTxW0FMts+PpefyHqyGIHf9hssXDF8fAj
         icPlgnIsSBfMQgQte410T2dek+RIa3xxx8j9MLETUdYQu6+VKXBbWFQJakHd084L4+RA
         QMTTtyvyb/MbgGdQSYmtEB+NEAgqgNTaPCFDsT8Hd4A2iZfuwPE4745aMrOh468WWWtu
         DmYLXER3jHqGjmRy+PLuD3yDB1MzkPp9rVFryXfpR4RdYR4aCRKeQq6H51hx4LZKfyAi
         ureg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=zlElK+uhPlDOhLMbO9Ebnvjpwi3KFp710UNwCkBd7CI=;
        fh=J2sIvZj83JPDtifv5WRszY9kZxeYeMPVaGlgyY6hUvc=;
        b=hPiqB38bxay7suMcQ9T/Z1TKy4mSF7NsoQdBWf51rWlHb0d5QnXufN6orDKK9PbYbt
         QvD4jb4DWPBcvi4tCPr1qVbqeRFokvOgSPj8Bo8j3JgAR9TygZozvaRFfBkxN3g58Io4
         1/PsksO4dTSAI/kAwRhRzJEv3XCvqLJevFux/o4Drg4BtxXs7Hsf3Y2TDhzt1LT50J1Z
         uxVg4d9+RUWC1ufJ4T4vm2CJ5AJlGt2UKj7r81iqAq61RE7gmHUkXv5oQKhMvcu7cTcg
         NF5bZMGf9Bfv76WtPXlhMaozvs9IjajHrMxnN15Iqi+YLz9RSeqjlaWnDb2c+2diB1Vm
         4msQ==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1785049520; x=1785654320; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=zlElK+uhPlDOhLMbO9Ebnvjpwi3KFp710UNwCkBd7CI=;
        b=MmjqWfyyQqBxCcPJ2cUbHYhKCH3PfQ21sW79iJVYX+FNjgHt+gLep0VsDXME+YK1YT
         xTEvxxp4RC+pYSpOF+NIgpKhVQmRF7hgNOz2oo61asOFWO6X0+ebs4WmAnxd1m4i61RS
         2LlDO854GTAT7fwZCHw7XVUuGYq24OckZ0+dcMvkAmlkKTJE03fTCBUQOoXx9oagKN7f
         vu9nHDLobSgJ9akbCRct63A7O99ILTpGSgDOmE6v2u47kQpGrY3V7L97KR4NIar0SNA4
         8Lk+WyB6e7hIivuFfaWrGgJ6dbZubKPyesfE1GD9uRbeMPUITH4i+cgHA4vuSSub5io6
         JBuw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785049520; x=1785654320;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=zlElK+uhPlDOhLMbO9Ebnvjpwi3KFp710UNwCkBd7CI=;
        b=WdVyhWWPbGtI1qKwkp8o7UJbw2F4xXrl36gGUK1P1FG6IRZp4HfSE1L/QN1xeqPtBh
         5ddc5WJYN7HzST5Yat/1t4R8qVM+wZuL0DZPZU4I+Eoyf/0c7BJkKdYE/NSPL89soBtk
         qqTEEOKyNIBDwoor0+C7ihFmv1Vb57eEX3WnfLhGSlwp32xJ0QiGwHzldyYtiYjbpBBx
         3pPHRPJ/w+lNR2zKHxGX5cwpA9QHK0qfc5ao+8AlMabJFViqohtpYDOegvH2xmu2fTqG
         ATZsSa9+LC5LfGUoqVlElUt8SzM+YMaB1Hk17dRiyp7CGAeUhq62fFsnLhFbTjQf2uAa
         0pmQ==
X-Forwarded-Encrypted: i=1; AHgh+Rotr0ZdU/OVtNH+6uCGogg1/67Ym8FKY6E5XHEuDEtC57z5YBOjgbldpuESmLi/yeOnLiEzgBo=@lists.linux.dev
X-Gm-Message-State: AOJu0YzkzBiBGMOuIH5CbZTgVqk5l/1YMT/PE44bvte6hUJXOmfxYI8+
	sNAiFH3zfY1OafPPT0bjhcPmfodRhHwGIu0aisbnZGMy9vhsLkZnwn+wpcSznmmtPPhzgOXltV7
	iWL9RxETUXvZ7r9OIsb+q/69zmTWKJ527RqlLor89
X-Gm-Gg: AR+sD13IMolWzykNSffw/aBfKdKq5yu7Vz6jB0TNMAPXYXd2qgRdZo37vO52bdpS0vo
	ES8/hrMtDBaCtC+Q50zOAv6L1JZ4MPWf+icNP/ckYVn7neVdWquPsNvpHLRbFOoYvdoleeeNzJv
	WKVvrQzaNSUSokQKUeq0IRgID/p75LI0Ubki/qzsEj3NmNAN1wxs7ibthqgQVO5J9pCYb57oxZt
	H7UaPkGoffXSX5cIxz/hcm+5gwJCRZ80OQHR3+3h1WrKBffrHE4VpFiH1YSlD+RHXVH11mxcLv6
	BbiT8GO6N9C9zdlt7ATp3zG79fxGcQdH2r55QXkmn9lWdHxIRIMtsNJoIW7ckUujotbRtYwG81Q
	/MtxwyF1kjIH99rFObYJqXojjXMd9lyUs
X-Received: by 2002:a05:6830:4c0c:b0:7e6:c9eb:535a with SMTP id
 46e09a7af769-7ee78a521e0mr3693110a34.6.1785049519084; Sun, 26 Jul 2026
 00:05:19 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a6546fa.a2ea2cc8.fbad6.0021.GAE@google.com>
In-Reply-To: <6a6546fa.a2ea2cc8.fbad6.0021.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Sun, 26 Jul 2026 09:05:07 +0200
X-Gm-Features: AUfX_mweLOn_JYTprIcGV6BAY7vKuPKYqLinrMSJjzlzXLhwanlXxjEWZwFT_J8
Message-ID: <CANp29Y4ddsDNW407PGyz+oOdOjb9LnAbbqs-25SzcwLWD=JiDA@mail.gmail.com>
Subject: Re: [moderation/CI] Re: blk-cgroup: protect blkgs with blkcg_mutex
To: syzbot ci <syzbot+ci771ccbeba8613948@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Sun, Jul 26, 2026 at 1:30=E2=80=AFAM syzbot ci
<syzbot+ci771ccbeba8613948@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v2] blk-cgroup: protect blkgs with blkcg_mutex
> https://lore.kernel.org/all/20260724123037.3004560-1-yukuai@kernel.org
> * [RFC PATCH v2 1/8] block: associate blkg in submit_bio instead of bio_s=
et_dev
> * [RFC PATCH v2 2/8] blk-throttle: protect throttle state with td lock
> * [RFC PATCH v2 3/8] blk-cgroup: protect blkgs with blkcg_mutex
> * [RFC PATCH v2 4/8] blk-cgroup: remove blkg radix tree preloading
> * [RFC PATCH v2 5/8] blk-cgroup: allocate blkgs in blkg_create
> * [RFC PATCH v2 6/8] blk-cgroup: share blkg creation between lookup and c=
onfig prep
> * [RFC PATCH v2 7/8] bfq: avoid blkg lookup from locked cgroup update
> * [RFC PATCH v2 8/8] block: fail nowait bio submit if blkg allocation can=
't sleep
>
> and found the following issue:
> general protection fault in blkcg_punt_bio_submit
>
> Full report is available here:
> https://ci.syzbot.org/series/eece31b0-1f5d-4840-8a12-407d9a4d1c57
>
> ***
>
> general protection fault in blkcg_punt_bio_submit
>
> tree:      axboe
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe=
/linux.git
> base:      093fbffe03f5c1bb9c10a9e5aa65b23250844403
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/2cc06765-4cf6-4329-9c0a-9fe326a53=
38e/config
> syz repro: https://ci.syzbot.org/findings/38efdd1d-4179-4903-8ade-04afbce=
263b2/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000006: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000030-0x0000000000000037]
> CPU: 0 UID: 0 PID: 26 Comm: kworker/u9:0 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: btrfs-worker btrfs_work_helper
> RIP: 0010:blkcg_punt_bio_submit+0x47/0x130 block/blk-cgroup.c:243
> Code: ae 13 fd 4c 8d 73 50 4c 89 f0 48 c1 e8 03 80 3c 28 00 74 08 4c 89 f=
7 e8 07 06 7f fd 4d 8b 36 4d 8d 7e 30 4c 89 f8 48 c1 e8 03 <80> 3c 28 00 74=
 08 4c 89 ff e8 eb 05 7f fd 49 83 3f 00 0f 84 ab 00
> RSP: 0000:ffffc90000a17a28 EFLAGS: 00010206
> RAX: 0000000000000006 RBX: ffff888117071348 RCX: ffff8881032f5940
> RDX: 0000000000000000 RSI: 0000000004000000 RDI: ffff888117071348
> RBP: dffffc0000000000 R08: ffff8881bb74406f R09: 1ffff110376e880d
> R10: dffffc0000000000 R11: ffffed10376e880e R12: ffff88816c5e6f08
> R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000030
> FS:  0000000000000000(0000) GS:ffff88818d9cb000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f05d5660000 CR3: 0000000172eb2000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  run_ordered_work fs/btrfs/async-thread.c:243 [inline]
>  btrfs_work_helper+0x577/0xc50 fs/btrfs/async-thread.c:322
>  process_one_work kernel/workqueue.c:3314 [inline]
>  process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3397
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3478
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:blkcg_punt_bio_submit+0x47/0x130 block/blk-cgroup.c:243
> Code: ae 13 fd 4c 8d 73 50 4c 89 f0 48 c1 e8 03 80 3c 28 00 74 08 4c 89 f=
7 e8 07 06 7f fd 4d 8b 36 4d 8d 7e 30 4c 89 f8 48 c1 e8 03 <80> 3c 28 00 74=
 08 4c 89 ff e8 eb 05 7f fd 49 83 3f 00 0f 84 ab 00
> RSP: 0000:ffffc90000a17a28 EFLAGS: 00010206
> RAX: 0000000000000006 RBX: ffff888117071348 RCX: ffff8881032f5940
> RDX: 0000000000000000 RSI: 0000000004000000 RDI: ffff888117071348
> RBP: dffffc0000000000 R08: ffff8881bb74406f R09: 1ffff110376e880d
> R10: dffffc0000000000 R11: ffffed10376e880e R12: ffff88816c5e6f08
> R13: dffffc0000000000 R14: 0000000000000000 R15: 0000000000000030
> FS:  0000000000000000(0000) GS:ffff8882a8fcb000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007efceadf26a8 CR3: 0000000115190000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   ae                      scas   %es:(%rdi),%al
>    1:   13 fd                   adc    %ebp,%edi
>    3:   4c 8d 73 50             lea    0x50(%rbx),%r14
>    7:   4c 89 f0                mov    %r14,%rax
>    a:   48 c1 e8 03             shr    $0x3,%rax
>    e:   80 3c 28 00             cmpb   $0x0,(%rax,%rbp,1)
>   12:   74 08                   je     0x1c
>   14:   4c 89 f7                mov    %r14,%rdi
>   17:   e8 07 06 7f fd          call   0xfd7f0623
>   1c:   4d 8b 36                mov    (%r14),%r14
>   1f:   4d 8d 7e 30             lea    0x30(%r14),%r15
>   23:   4c 89 f8                mov    %r15,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   80 3c 28 00             cmpb   $0x0,(%rax,%rbp,1) <-- trapping in=
struction
>   2e:   74 08                   je     0x38
>   30:   4c 89 ff                mov    %r15,%rdi
>   33:   e8 eb 05 7f fd          call   0xfd7f0623
>   38:   49 83 3f 00             cmpq   $0x0,(%r15)
>   3c:   0f                      .byte 0xf
>   3d:   84                      .byte 0x84
>   3e:   ab                      stos   %eax,%es:(%rdi)
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
> [axboe@kernel.dk cengku@gmail.com cgroups@vger.kernel.org dongsheng.yang@=
linux.dev hch@lst.de josef@toxicpanda.com linux-block@vger.kernel.org ming.=
lei@redhat.com nilay@linux.ibm.com tj@kernel.org yukuai@fygo.io yukuai@kern=
el.org]
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
-upstream-moderation/6a6546fa.a2ea2cc8.fbad6.0021.GAE%40google.com.
