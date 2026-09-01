Received: from mail-ot1-f41.google.com (mail-ot1-f41.google.com [209.85.210.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D8AD4CCDF8
	for <syzbot@lists.linux.dev>; Tue,  1 Sep 2026 06:57:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=209.85.210.41
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788245822; cv=pass; b=S18jq3GAJt73AJ9RPOLV8RWeMTR/1+YwWUnxyqCJ9ReVsz4IyTR1c18RGrwRvN5NUZOFnTT3PaKE9rTtlBTKOCpyvfFImm+80/C5/1tFqunfK56zYj3Q7L4BKk7/Mkkeoh+nPeM2zK40QaHLfdjVn1qnwXfCYPUII93SNefar0g=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788245822; c=relaxed/simple;
	bh=52ywFdWNIcUTN/t2f/hAtZstseDwdC7pDfSots0aQcU=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=RUwV8kcahFxiuwFlxsrAZKhNKmgDnfja6bhPRD+oZkiAepw81kP7YR0NFd5nxQtzZOmNU2qcDmlovWeOGILFSy1QKs8fQDIukCREWKV8g9VtFwCCmYEPpPwWEuc7+Y6fq5E4sL9UXawyOVIqDwE3adIRxOa+nzF6pktSnf3ZnBU=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=thDMxlI4; arc=pass smtp.client-ip=209.85.210.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="thDMxlI4"
Received: by mail-ot1-f41.google.com with SMTP id 46e09a7af769-7f4df360cc9so905001a34.1
        for <syzbot@lists.linux.dev>; Mon, 31 Aug 2026 23:57:00 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; t=1788245819; cv=none;
        d=google.com; s=arc-20260327;
        b=lo3daEpzEfJ/xZP+0niwgwMShTcwQliKK7AFrBjPmEczOlrzy/ykf/hXqVDAmJZoqc
         4f6fl3K8JUSTOqn0GC+01Bfz2RMj/cYdRmOaNHGYP2chZqrsT/fOAF+YscwPEmSIl9T3
         3rJu3BvWYix3O+zQnBEk9ShunuIv3RicLPS15GJWNMbu5o0PGS4tyvXgK06Kejj9qeEi
         uhsBvpa7wkiRwxceR7dYy6aMB7BNS9D+i6vg9AoIcO3+a/DCliPhvT59RSltbY9vUo+F
         BnX1bHEpccURQZHPegMcKf22J66/qf9LqD2Ds9tBZE4r7MlHATGugHoloR99Z6quJWma
         2T1A==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20260327;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=sXsNk/f1rVsA34mzpEGmIr2GbnkvZdue0NcYxYelokA=;
        fh=Gc/2iielvPT7gDkvYmhvbQLJlzuMV8gIPEjNLnq6G6I=;
        b=aNvAUoX0h9nP9+aa7sAO34mWKk6TlN5QZxTPyca7KGDjzFS9kqdsPjUhpp7AeApmL0
         0TiaC6Ck95PJTXUmO/StnjxKLoTEBCCrNs5fzQwdvaXrb9tz9255ZAgKKO+JtDa4WFam
         Iw5D2Zdf8A7eLBKGhZBAm0fpes3xQRMSTSQyTRfwecYduve2W/+f2u4FTGhtbL0fMJYv
         5mF4XEKRRpArqt5iGR8R6G8CRMbOPeO/9SxUsQao1NglR7j1HyxvYoEhn3IWQrI2bRSg
         NyvwEHO0JxknAMAeHXn/BwoNULsgc0gOGnQ4apSxppi/1IGk8CncrX4no2pdIK+HW6pm
         o1og==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20251104; t=1788245819; x=1788850619; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=sXsNk/f1rVsA34mzpEGmIr2GbnkvZdue0NcYxYelokA=;
        b=thDMxlI4Fy46UocGeTyGQwRYV0sDqLwxNwTnBggQ7B67ETSLZfPN8kflTxZPP+7YdU
         uv789MLWLrBS8IL1QXVaHGWyECzGPvrdK+ROdowxWl9dH+jV0YYLd7eAy4upc0896rpm
         HdwE8pqSFKMR0eNwXiQTiS38LYW+aw2OoHmkg3+4q79zSYbd0LI1O9o5G03Abj+Cd+tv
         KZ9IslwrIu3Up29c38GlCT1rnGUx3rHINBpdM2I0hB+NWoOmJd3JlH1WjWSJqlvX3BKQ
         0QOLh9vxlJZ0Lg3MGk3jpvCNBU/nspXX1r3Fw8Y86NCdrRJU4nOgyNL45hxyDdgQK5Ol
         +nLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1788245819; x=1788850619;
        h=content-transfer-encoding:content-type:cc:to:subject:message-id
         :date:from:in-reply-to:references:mime-version:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sXsNk/f1rVsA34mzpEGmIr2GbnkvZdue0NcYxYelokA=;
        b=XjgXw5qy6y3AoTXY5rAE6OMK2BtXKXNtwny9ivK1OhopLT32kjT8UmHskjo6lIhzlv
         9P5guSiWMlnYMahgmdG8RBU8hO7uJKnqDjCP6fCaq8IoTfiCUV0PEc2HJC3mbk7pDDz0
         GsCrAeas7svAM3zUQpRnoHOWxITwWDxVEYspfItcOMVtppnIVr6yznuZ/eXLcL1MQ5pw
         hgHc2ZRtA+cFLAKtOveTg9WbusbmIPMUT/cOMq34MDGHYyfF0iA4QKJ1JUYCB48ODssm
         Gy2Vpo7tbdCKpsWWnofZIrwtGmufoYCVPGfEJw8h8crkZRkvzwS/l4JG5aF0xnTmADEq
         y0+A==
X-Forwarded-Encrypted: i=1; AHgh+Rr99bMuF9XsR8QlZVqWxVeaJS2SsxSd5wTqMV4YWlyRqUB9C6sZjpTCtzmXWVqIRwDhCyIHQaQ=@lists.linux.dev
X-Gm-Message-State: AFuF++n6YPCbQDXbjalneITWs0oa3C0POduW9YjpC5EItSmaoBgvs7Ch
	xGJ5Tu9rz4jq0DhKxDTBbFg11ypIZQZKz6SMMZSnDx2tDAgEAJQtN79LBjDwLC1QnUPlzu20xkf
	ctdkoFB+sJ7jgog9kl+gOeOlBLgLxOIDU+nQ2FqLx
X-Gm-Gg: AR+sD10F5Rrc6AgnHww5Anv/tZSRD/x5xCRCOPan3XZf75bTvsknlNavxekv7HX4XK3
	WDsGStHl3TnkeE92rLFrjPSO55SU3QDcxSiTtrBJIvsbX1rayuzbegz3p7OhpR9r8rID2e/6njX
	6K3bi2b4hzU2EYTSbZ12KSXHWfDEssJ3p3nbW5WrE/b7Xah0CBqpoQt3EWZr+oWfL5gVvROEvQm
	891py6JMs0IKHgm8h8+/9i1V6blTQUaSMulH6s71Teewt6Mdy6RKtNM0YbTEPfgPhqq37WB7V8d
	ntsQGDa5CXDZru+EY7wCQiTSEXXGwzjhKXvEnGw5RSbAv7g4WY1Zd56nTKkVX1SRSCrZ7H8j31C
	cNUbO3+xhyWOpoZeyxiaTtwZyno/dtlN7R82w9KgFfG0WrBlsFZ4J7eJZ2Hv1EtesqTm3S9xbTJ
	axPbA40/SL6izCgWwQag7UQp6ILA==
X-Received: by 2002:a05:6830:8286:b0:7f4:3902:3a26 with SMTP id
 46e09a7af769-7f68f5791f3mr3666468a34.1.1788245818534; Mon, 31 Aug 2026
 23:56:58 -0700 (PDT)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <6a963a41.764875ec.b345.0005.GAE@google.com>
In-Reply-To: <6a963a41.764875ec.b345.0005.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Tue, 1 Sep 2026 08:56:46 +0200
X-Gm-Features: AcwNN1X7DysKx4vWj2H9XDe5XamjD_oWFti2LD1E6fBeZsKrCcL7SvC-KdPYaDA
Message-ID: <CANp29Y6yKWwkZELyL8fOzDYrrjD6nY5OoCddPvv9bcvyUrqRew@mail.gmail.com>
Subject: Re: [moderation/CI] Re: block: brd/loop error-path cleanup
To: syzbot ci <syzbot+cidfd2c43a08ae75d8@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Tue, Sep 1, 2026 at 4:36=E2=80=AFAM syzbot ci
<syzbot+cidfd2c43a08ae75d8@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] block: brd/loop error-path cleanup
> https://lore.kernel.org/all/20260831152044.166353-1-ivanrwcm25@gmail.com
> * [PATCH v1 1/2] block: brd: destroy xa on allocation failure
> * [PATCH v1 2/2] block: loop: restore state on loop_configure() error
>
> and found the following issues:
> * general protection fault in lo_release
> * general protection fault in lo_rw_aio
>
> Full report is available here:
> https://ci.syzbot.org/series/9ab490fc-567e-414a-9754-890ca131012d
>
> ***
>
> general protection fault in lo_release
>
> tree:      axboe
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe=
/linux.git
> base:      44e96e364b04163ddddc8a24289cef4982b7e36e
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/f5d23472-69ec-45bc-b33a-b59f7c0e7=
493/config
> syz repro: https://ci.syzbot.org/findings/a48673c0-89de-4ffc-b71c-3aa9e53=
13ec8/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc000000000a: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000050-0x0000000000000057]
> CPU: 0 UID: 0 PID: 5946 Comm: syz.0.87 Not tainted syzkaller #0 PREEMPT(f=
ull)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> RIP: 0010:__loop_clr_fd drivers/block/loop.c:1177 [inline]
> RIP: 0010:lo_release+0x47c/0x7e0 drivers/block/loop.c:1780
> Code: 89 e7 e8 77 60 fc fb bf e0 01 00 00 49 03 3c 24 be 02 00 00 00 e8 8=
4 c6 9c 05 48 8b 44 24 30 4c 8d 70 50 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 f7 e8 45 60 fc fb 41 bc e8 00 00 00 4d
> RSP: 0018:ffffc90003787b60 EFLAGS: 00010206
> RAX: 000000000000000a RBX: ffff8881063f93c8 RCX: 0000000000000046
> RDX: 0000000000000006 RSI: ffffffff8e46de57 RDI: ffffffff8c6d5780
> RBP: ffffc90003787d08 R08: ffffffff9079c73f R09: 1ffffffff20f38e7
> R10: dffffc0000000000 R11: fffffbfff20f38e8 R12: ffff8881063f8080
> R13: dffffc0000000000 R14: 0000000000000050 R15: 1ffff920006f0f74
> FS:  00007fae103d46c0(0000) GS:ffff88818d6f1000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fae0f5eb840 CR3: 000000010c31a000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  bdev_release+0x571/0x690 block/bdev.c:-1
>  blkdev_release+0x15/0x20 block/fops.c:682
>  __fput+0x418/0xa50 fs/file_table.c:512
>  fput_close_sync+0x11f/0x240 fs/file_table.c:617
>  __do_sys_close fs/open.c:1560 [inline]
>  __se_sys_close fs/open.c:1545 [inline]
>  __x64_sys_close+0x7e/0x110 fs/open.c:1545
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fae0f55e98e
> Code: 08 0f 85 a5 a8 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4=
d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f=
 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
> RSP: 002b:00007fae103d3da8 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: ffffffffffffffda RBX: 00007fae103d46c0 RCX: 00007fae0f55e98e
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000004
> RBP: 0000000000000010 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000003
> R13: 00007fae103d3ee0 R14: 00007fae103d46a8 R15: 00007fae06600000
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:__loop_clr_fd drivers/block/loop.c:1177 [inline]
> RIP: 0010:lo_release+0x47c/0x7e0 drivers/block/loop.c:1780
> Code: 89 e7 e8 77 60 fc fb bf e0 01 00 00 49 03 3c 24 be 02 00 00 00 e8 8=
4 c6 9c 05 48 8b 44 24 30 4c 8d 70 50 4c 89 f0 48 c1 e8 03 <42> 80 3c 28 00=
 74 08 4c 89 f7 e8 45 60 fc fb 41 bc e8 00 00 00 4d
> RSP: 0018:ffffc90003787b60 EFLAGS: 00010206
> RAX: 000000000000000a RBX: ffff8881063f93c8 RCX: 0000000000000046
> RDX: 0000000000000006 RSI: ffffffff8e46de57 RDI: ffffffff8c6d5780
> RBP: ffffc90003787d08 R08: ffffffff9079c73f R09: 1ffffffff20f38e7
> R10: dffffc0000000000 R11: fffffbfff20f38e8 R12: ffff8881063f8080
> R13: dffffc0000000000 R14: 0000000000000050 R15: 1ffff920006f0f74
> FS:  00007fae103d46c0(0000) GS:ffff8882a8cf1000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007ffd52a75ff8 CR3: 000000010c31a000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   89 e7                   mov    %esp,%edi
>    2:   e8 77 60 fc fb          call   0xfbfc607e
>    7:   bf e0 01 00 00          mov    $0x1e0,%edi
>    c:   49 03 3c 24             add    (%r12),%rdi
>   10:   be 02 00 00 00          mov    $0x2,%esi
>   15:   e8 84 c6 9c 05          call   0x59cc69e
>   1a:   48 8b 44 24 30          mov    0x30(%rsp),%rax
>   1f:   4c 8d 70 50             lea    0x50(%rax),%r14
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 28 00          cmpb   $0x0,(%rax,%r13,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 f7                mov    %r14,%rdi
>   34:   e8 45 60 fc fb          call   0xfbfc607e
>   39:   41 bc e8 00 00 00       mov    $0xe8,%r12d
>   3f:   4d                      rex.WRB
>
>
> ***
>
> general protection fault in lo_rw_aio
>
> tree:      axboe
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/axboe=
/linux.git
> base:      44e96e364b04163ddddc8a24289cef4982b7e36e
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (++20260613092233+e80beda6e255-1~e=
xp1~20260613092250.77), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/f5d23472-69ec-45bc-b33a-b59f7c0e7=
493/config
> syz repro: https://ci.syzbot.org/findings/556532c0-64a7-4471-9558-ea3a7a2=
13af7/syz_repro
>
> Oops: general protection fault, probably for non-canonical address 0xdfff=
fc0000000009: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000048-0x000000000000004f]
> CPU: 0 UID: 0 PID: 83 Comm: kworker/u9:3 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: loop0 loop_rootcg_workfn
> RIP: 0010:lo_rw_aio+0xc36/0xf20 include/linux/percpu-rwsem.h:-1
> Code: fb 48 8d 35 00 00 00 00 bf 60 04 00 00 48 03 3b e8 9f 51 68 fb bb 3=
0 00 00 00 4c 8b 74 24 58 49 83 c6 48 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00=
 74 08 4c 89 f7 e8 8b 6c fc fb 49 03 1e 48 89 d8 48
> RSP: 0018:ffffc9000277f620 EFLAGS: 00010206
> RAX: 0000000000000009 RBX: 0000000000000028 RCX: ffff888102725a00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc9000277f790 R08: ffff88810aa529a7 R09: 1ffff1102154a534
> R10: dffffc0000000000 R11: ffffed102154a535 R12: dffffc0000000000
> R13: 0000000000000000 R14: 0000000000000048 R15: ffff88810aa529b0
> FS:  0000000000000000(0000) GS:ffff88818d6f1000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000558fd5b46210 CR3: 00000001bb152000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  do_req_filebacked drivers/block/loop.c:432 [inline]
>  loop_handle_cmd drivers/block/loop.c:1954 [inline]
>  loop_process_work+0x960/0x11c0 drivers/block/loop.c:1989
>  process_one_work kernel/workqueue.c:3387 [inline]
>  process_scheduled_works+0xc3d/0x1630 kernel/workqueue.c:3470
>  worker_thread+0xa47/0xfb0 kernel/workqueue.c:3551
>  kthread+0x38b/0x480 kernel/kthread.c:436
>  ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:lo_rw_aio+0xc36/0xf20 include/linux/percpu-rwsem.h:-1
> Code: fb 48 8d 35 00 00 00 00 bf 60 04 00 00 48 03 3b e8 9f 51 68 fb bb 3=
0 00 00 00 4c 8b 74 24 58 49 83 c6 48 4c 89 f0 48 c1 e8 03 <42> 80 3c 20 00=
 74 08 4c 89 f7 e8 8b 6c fc fb 49 03 1e 48 89 d8 48
> RSP: 0018:ffffc9000277f620 EFLAGS: 00010206
> RAX: 0000000000000009 RBX: 0000000000000028 RCX: ffff888102725a00
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: ffffc9000277f790 R08: ffff88810aa529a7 R09: 1ffff1102154a534
> R10: dffffc0000000000 R11: ffffed102154a535 R12: dffffc0000000000
> R13: 0000000000000000 R14: 0000000000000048 R15: ffff88810aa529b0
> FS:  0000000000000000(0000) GS:ffff88818d6f1000(0000) knlGS:0000000000000=
000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000558fd5b46210 CR3: 0000000169ee2000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:   fb                      sti
>    1:   48 8d 35 00 00 00 00    lea    0x0(%rip),%rsi        # 0x8
>    8:   bf 60 04 00 00          mov    $0x460,%edi
>    d:   48 03 3b                add    (%rbx),%rdi
>   10:   e8 9f 51 68 fb          call   0xfb6851b4
>   15:   bb 30 00 00 00          mov    $0x30,%ebx
>   1a:   4c 8b 74 24 58          mov    0x58(%rsp),%r14
>   1f:   49 83 c6 48             add    $0x48,%r14
>   23:   4c 89 f0                mov    %r14,%rax
>   26:   48 c1 e8 03             shr    $0x3,%rax
> * 2a:   42 80 3c 20 00          cmpb   $0x0,(%rax,%r12,1) <-- trapping in=
struction
>   2f:   74 08                   je     0x39
>   31:   4c 89 f7                mov    %r14,%rdi
>   34:   e8 8b 6c fc fb          call   0xfbfc6cc4
>   39:   49 03 1e                add    (%r14),%rbx
>   3c:   48 89 d8                mov    %rbx,%rax
>   3f:   48                      rex.W
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
> [axboe@kernel.dk ivanrwcm25@gmail.com linux-block@vger.kernel.org linux-k=
ernel@vger.kernel.org]
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
-upstream-moderation/6a963a41.764875ec.b345.0005.GAE%40google.com.
