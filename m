Received: from mail-dl1-f48.google.com (mail-dl1-f48.google.com [74.125.82.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A0A63A7E02
	for <syzbot@lists.linux.dev>; Tue, 20 Jan 2026 20:54:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=74.125.82.48
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768942458; cv=pass; b=AYWRhuDuytAIcnki4RIT57InJLHAma4gO39bI21Hs0uAhN4oLXUpjEcqtW2fCATdpcBW0EnFlI4aM88/5SiJfTBZfyTHJcSWID/6kL+56ksK3vz+PEzF8hacvqdTAIVhZEDbbBLRt323BQGe2EdFpqUSb9cnBXw+p7HhdxrUeCE=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768942458; c=relaxed/simple;
	bh=nM/cxUFyVwygDBtOfCstp5vWS8LJLsEadJpBn92lyw4=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=Y7Y5qqHAw8AZmd832PWbqu2bu6YH/mxFIvkjv35EJM+dQj0KHkSZxy1xp7u8SvN7KUwZlbjtLILIrO95/k6fk0XNqhQgFB/oLm0OiXrpSS/Vk9qRJAco3N620dUM2oIH9AQm1J+3dnhDdLqzRFxXce+bygBqIuVeq4RJ7CyuBYA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com; spf=fail smtp.mailfrom=purestorage.com; dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b=WQfS5f96; arc=pass smtp.client-ip=74.125.82.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=purestorage.com
Authentication-Results: smtp.subspace.kernel.org; spf=fail smtp.mailfrom=purestorage.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=purestorage.com header.i=@purestorage.com header.b="WQfS5f96"
Received: by mail-dl1-f48.google.com with SMTP id a92af1059eb24-1233bc11279so374162c88.1
        for <syzbot@lists.linux.dev>; Tue, 20 Jan 2026 12:54:16 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1768942455; cv=none;
        d=google.com; s=arc-20240605;
        b=Mwf1rwDzcDoTmAdepGikgLzs8F80kK9nTYZhnT1eSIDBJw+ZVv35XDTHRgiKLMIx95
         fZHW+9xXYmWR11kQS1UDF1ZUW5ZDukVAUmwg/B04iqIhWkEH4CpzDyVrJcs4PxdY7fPM
         BzUDzPuv/IoIoQQI/Z8+gvafqNTc50+DDXY/sKR5BO9Fb3prJ1MJRCJ9wM477cWwFfk8
         FVWnmkUk8yJgJe7T9mjWeSqp/sOkpUoVIUnfnNrW8r9zgCwpfMKfTOhMz4xndx+DjqSP
         T93/HZn9x5yV86tpvq2b0rBSBkT7H9q6Dx8ke7JYu9GB+pWICwnx1Kl7xRtfJt1ySUL0
         NgUA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=google.com; s=arc-20240605;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:dkim-signature;
        bh=DWPpQ5O7K/e2WYrYoCArv3AZO6TeXU3lY9Gs+T6Odss=;
        fh=5iqJcZqEV+GNPA4mtsMLhny5Kwtu0SjUCQkK4OLASpw=;
        b=DIzxb2lGBBQV0FKN4DQw01ChOaO+nfiWaEpEU5Hp3Ad9By8XGD72yLgB2uN2H+WDIh
         GAkimoJreW7QqtsXLvak/ErdiwsmNVGxr2BrpYQPgOt3RdFlsuAmleOEytNp8FxwniPC
         JmqByazgT9NnaM3A7eNPtHHfPt5THomLE/UzpzfLz4Cq9qIzM/W5Kczm7dQ17M6w3CNn
         7VL4Pd9v7k7MzsjFz3BzXQAFVRBcW1v43PW/XHs74Jrq0m867hVFHrjvihUVwS/mobiS
         PRRe0+x8z7ItiFJwxJ7pRFpTohrBEI//Q8uB5mG5Xuzeys9sg8Shx0u72dCe+Erdp7Mv
         MsFg==;
        darn=lists.linux.dev
ARC-Authentication-Results: i=1; mx.google.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=purestorage.com; s=google2022; t=1768942455; x=1769547255; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=DWPpQ5O7K/e2WYrYoCArv3AZO6TeXU3lY9Gs+T6Odss=;
        b=WQfS5f96tmkb6Bt78sLF0NMd3HbcW+WZwuuiNwMQM7zvQ9GXO8zyYgjRmv37TV7GeX
         XklbsZ/+bDL8+SntNHUUZ/ve9sNqIqmECFuj0GYeblCdiWoSEeozGfmac2oRMni1PV3B
         x2zxDDEf2K8P6e3GqcBBBcCQVvdzcTsnB27l2/fTIypZ1gNcw1CwFKHW9OMnw4fnnXg/
         Y/SIp9mFqTPUdxvQUWleDCCbZsONN3wDWIFHpEwsNw1jOcvGFHUp9WbaCmvTZv8TczXV
         O8o4+TSms8nylJFeObY74/eI6JfA+wYky+RoGHG14SYtyhjS6upr0d8QOzTOifnRtlZ5
         x1gA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1768942455; x=1769547255;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=DWPpQ5O7K/e2WYrYoCArv3AZO6TeXU3lY9Gs+T6Odss=;
        b=WDzwKgRLtHJMbme+kGBYmIaEOZW1hOE1O6PUh13l9lz4ojoHiv9tKxagjyA0MmeYos
         pW9Rcxu2sGlAWInsBQ73z2oAvpaUH6nuSUIflkk/4eCY0a58qrNxNVLIE+e+49BVHqXU
         Ga6MbHT5G2h83ls9EUeKlCLKjA9ZDBae41R3DR2Z5jGj6Pd1/evK1AE76qztIIJ3Nnxo
         NZ+WcIxHDnsAoki3DFEVlY7KE/tULGZ3SdKW5U2YMiBe/XYNQMyFmuEKbPxrrRcV/U00
         DyItM2MKEm05BzZA8c4baNUgSl4BzJ7vV/HcBCvuGkxCObhWxtYiZMgZEcx2xlO/IdEM
         +3JA==
X-Forwarded-Encrypted: i=1; AJvYcCVletLkz2BTkxXrlvDimthGIaNvtSQjhp2MzFPe6bzLyZ/moHRKqTKDi4OUmm6KiaDnDJIeePM=@lists.linux.dev
X-Gm-Message-State: AOJu0YwX2W5yzfsOSIoE2VtiQDg925wgTZIEeeFe/YUuzTZinmWz1DNf
	QiRPRJA3oFM8lvEYokkEuOFtaerPkmpS7ReqzHGyVajkEoFzo3VPYqBwKrSYVnVizcSteZbYuNP
	0l3lcQr2AaiHRwhjwxil+BlAfs5a9m4AEYLUAeg+BcQ==
X-Gm-Gg: AY/fxX5hEONkEjRTegaKvMYIIBcUjE/bKxnSdvklvF9OFOwF+7EiK6PzoazWPN0MHav
	7UdL5L985tMxouEznYiIcgFsve6UXZYMHoq9OvGf1lealq4pDMy3slm4BO++fPbZb5lNCQQ/NUA
	PrfUaq1Tqggr6u+mldKjF/xy4OT17Yi/JplqCLkDAPdC1WK3UsDBRtmkT7wcWrK77yISdHm9IvI
	eAoLml2QXUSEFM2p2atbZzzPyGr/oCn6CvQghJTGTV8Qs/6mDx00sx/Ulv3adhUoxDdLxBR
X-Received: by 2002:a05:7023:d02:b0:119:e56b:46ba with SMTP id
 a92af1059eb24-1244a7dd744mr5627145c88.4.1768942454919; Tue, 20 Jan 2026
 12:54:14 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <20251218024459.1083572-1-csander@purestorage.com>
 <6943b4db.a70a0220.25eec0.0028.GAE@google.com> <CADUfDZq7MK3r6c05CohT0hMowq-gqffGid-eC1cDGKy+4aaS=A@mail.gmail.com>
 <0bc36797-fe4e-46ba-933d-0b3d508ed0dd@kernel.dk>
In-Reply-To: <0bc36797-fe4e-46ba-933d-0b3d508ed0dd@kernel.dk>
From: Caleb Sander Mateos <csander@purestorage.com>
Date: Tue, 20 Jan 2026 12:54:03 -0800
X-Gm-Features: AZwV_Qg1dBnCmYWZDnpEl80cJUsAVJPEFwdlyyx8JVPfq5JP9gaxKy5GFdka7v4
Message-ID: <CADUfDZoSnzyK9KEid+njTyfK6M2VD5V1QTMdS8kMo1EWpTAx7A@mail.gmail.com>
Subject: Re: [syzbot ci] Re: io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
To: Jens Axboe <axboe@kernel.dk>
Cc: syzbot ci <syzbot+ci6d21afd0455de45a@syzkaller.appspotmail.com>, 
	io-uring@vger.kernel.org, joannelkoong@gmail.com, 
	linux-kernel@vger.kernel.org, oliver.sang@intel.com, 
	syzbot@syzkaller.appspotmail.com, syzbot@lists.linux.dev, 
	syzkaller-bugs@googlegroups.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

On Sun, Jan 18, 2026 at 10:34=E2=80=AFAM Jens Axboe <axboe@kernel.dk> wrote=
:
>
> On 12/22/25 1:19 PM, Caleb Sander Mateos wrote:
> > On Thu, Dec 18, 2025 at 3:01?AM syzbot ci
> > <syzbot+ci6d21afd0455de45a@syzkaller.appspotmail.com> wrote:
> >>
> >> syzbot ci has tested the following series
> >>
> >> [v6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_ISSUER
> >> https://lore.kernel.org/all/20251218024459.1083572-1-csander@purestora=
ge.com
> >> * [PATCH v6 1/6] io_uring: use release-acquire ordering for IORING_SET=
UP_R_DISABLED
> >> * [PATCH v6 2/6] io_uring: clear IORING_SETUP_SINGLE_ISSUER for IORING=
_SETUP_SQPOLL
> >> * [PATCH v6 3/6] io_uring: ensure submitter_task is valid for io_ring_=
ctx's lifetime
> >> * [PATCH v6 4/6] io_uring: use io_ring_submit_lock() in io_iopoll_req_=
issued()
> >> * [PATCH v6 5/6] io_uring: factor out uring_lock helpers
> >> * [PATCH v6 6/6] io_uring: avoid uring_lock for IORING_SETUP_SINGLE_IS=
SUER
> >>
> >> and found the following issue:
> >> INFO: task hung in io_wq_put_and_exit
> >>
> >> Full report is available here:
> >> https://ci.syzbot.org/series/21eac721-670b-4f34-9696-66f9b28233ac
> >>
> >> ***
> >>
> >> INFO: task hung in io_wq_put_and_exit
> >>
> >> tree:      torvalds
> >> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/to=
rvalds/linux
> >> base:      d358e5254674b70f34c847715ca509e46eb81e6f
> >> arch:      amd64
> >> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-=
1~exp1~20250708183702.136), Debian LLD 20.1.8
> >> config:    https://ci.syzbot.org/builds/1710cffe-7d78-4489-9aa1-823b8c=
2532ed/config
> >> syz repro: https://ci.syzbot.org/findings/74ae8703-9484-4d82-aa78-84cc=
37dcb1ef/syz_repro
> >>
> >> INFO: task syz.1.18:6046 blocked for more than 143 seconds.
> >>       Not tainted syzkaller #0
> >>       Blocked by coredump.
> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messa=
ge.
> >> task:syz.1.18        state:D stack:25672 pid:6046  tgid:6045  ppid:597=
1   task_flags:0x400548 flags:0x00080004
> >> Call Trace:
> >>  <TASK>
> >>  context_switch kernel/sched/core.c:5256 [inline]
> >>  __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
> >>  __schedule_loop kernel/sched/core.c:6945 [inline]
> >>  schedule+0x165/0x360 kernel/sched/core.c:6960
> >>  schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
> >>  do_wait_for_common kernel/sched/completion.c:100 [inline]
> >>  __wait_for_common kernel/sched/completion.c:121 [inline]
> >>  wait_for_common kernel/sched/completion.c:132 [inline]
> >>  wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
> >>  io_wq_exit_workers io_uring/io-wq.c:1328 [inline]
> >>  io_wq_put_and_exit+0x316/0x650 io_uring/io-wq.c:1356
> >>  io_uring_clean_tctx+0x11f/0x1a0 io_uring/tctx.c:207
> >>  io_uring_cancel_generic+0x6ca/0x7d0 io_uring/cancel.c:652
> >>  io_uring_files_cancel include/linux/io_uring.h:19 [inline]
> >>  do_exit+0x345/0x2310 kernel/exit.c:911
> >>  do_group_exit+0x21c/0x2d0 kernel/exit.c:1112
> >>  get_signal+0x1285/0x1340 kernel/signal.c:3034
> >>  arch_do_signal_or_restart+0x9a/0x7a0 arch/x86/kernel/signal.c:337
> >>  __exit_to_user_mode_loop kernel/entry/common.c:41 [inline]
> >>  exit_to_user_mode_loop+0x87/0x4f0 kernel/entry/common.c:75
> >>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inl=
ine]
> >>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:25=
6 [inline]
> >>  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inli=
ne]
> >>  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
> >>  do_syscall_64+0x2e3/0xf80 arch/x86/entry/syscall_64.c:100
> >>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >> RIP: 0033:0x7f6a8b58f7c9
> >> RSP: 002b:00007f6a8c4a00e8 EFLAGS: 00000246 ORIG_RAX: 00000000000000ca
> >> RAX: 0000000000000001 RBX: 00007f6a8b7e5fa8 RCX: 00007f6a8b58f7c9
> >> RDX: 00000000000f4240 RSI: 0000000000000081 RDI: 00007f6a8b7e5fac
> >> RBP: 00007f6a8b7e5fa0 R08: 3fffffffffffffff R09: 0000000000000000
> >> R10: 0000000000000800 R11: 0000000000000246 R12: 0000000000000000
> >> R13: 00007f6a8b7e6038 R14: 00007ffcac96d220 R15: 00007ffcac96d308
> >>  </TASK>
> >> INFO: task iou-wrk-6046:6047 blocked for more than 143 seconds.
> >>       Not tainted syzkaller #0
> >> "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this messa=
ge.
> >> task:iou-wrk-6046    state:D stack:27760 pid:6047  tgid:6045  ppid:597=
1   task_flags:0x404050 flags:0x00080002
> >> Call Trace:
> >>  <TASK>
> >>  context_switch kernel/sched/core.c:5256 [inline]
> >>  __schedule+0x14bc/0x5000 kernel/sched/core.c:6863
> >>  __schedule_loop kernel/sched/core.c:6945 [inline]
> >>  schedule+0x165/0x360 kernel/sched/core.c:6960
> >>  schedule_timeout+0x9a/0x270 kernel/time/sleep_timeout.c:75
> >>  do_wait_for_common kernel/sched/completion.c:100 [inline]
> >>  __wait_for_common kernel/sched/completion.c:121 [inline]
> >>  wait_for_common kernel/sched/completion.c:132 [inline]
> >>  wait_for_completion+0x2bf/0x5d0 kernel/sched/completion.c:153
> >>  io_ring_ctx_lock_nested+0x2b3/0x380 io_uring/io_uring.h:283
> >>  io_ring_ctx_lock io_uring/io_uring.h:290 [inline]
> >>  io_ring_submit_lock io_uring/io_uring.h:554 [inline]
> >>  io_files_update+0x677/0x7f0 io_uring/rsrc.c:504
> >>  __io_issue_sqe+0x181/0x4b0 io_uring/io_uring.c:1818
> >>  io_issue_sqe+0x1de/0x1190 io_uring/io_uring.c:1841
> >>  io_wq_submit_work+0x6e9/0xb90 io_uring/io_uring.c:1953
> >>  io_worker_handle_work+0x7cd/0x1180 io_uring/io-wq.c:650
> >>  io_wq_worker+0x42f/0xeb0 io_uring/io-wq.c:704
> >>  ret_from_fork+0x599/0xb30 arch/x86/kernel/process.c:158
> >>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246
> >>  </TASK>
> >
> > Interesting, a deadlock between io_wq_exit_workers() on submitter_task
> > (which is exiting) and io_ring_ctx_lock() on an io_uring worker
> > thread. io_ring_ctx_lock() is blocked until submitter_task runs task
> > work, but that will never happen because it's waiting on the
> > completion. Not sure what the best approach is here. Maybe have the
> > submitter_task alternate between running task work and waiting on the
> > completion? Or have some way for submitter_task to indicate that it's
> > exiting and disable the IORING_SETUP_SINGLE_ISSUER optimization in
> > io_ring_ctx_lock()?
>
> Finally got around to taking a look at this patchset today, and it does

Appreciate you taking a look!

> look sound to me. For cases that have zero expected io-wq activity, then
> it seems like a no-brainer. For cases that have a lot of expected io-wq
> activity, which are basically only things like fs/storage workloads on
> suboptimal configurations, the then the suspend/resume mechanism may be
> troublesome. But not quite sure what to do about that, or if it's evne
> noticable?

Yes, this is a good point. I was hoping io_uring worker threads
wouldn't need to acquire the ctx uring lock in most cases, as fixed
buffer and file lookup will likely have already happened during the
initial non-blocking submission. That clearly wouldn't be true for
IOSQE_ASYNC requests, though. And maybe other cases I haven't thought
of?
One possibility would be to introduce a new setup flag
("IORING_SETUP_TRULY_SINGLE_ISSUER" or something) to explicitly opt
into this behavior to avoid regressing any existing applications. Or
we could try to optimize IORING_SETUP_SINGLE_ISSUER + IOSQE_ASYNC to
import any fixed file, fixed buffer, or provided buffer on
submitter_task before punting the request to the worker thread.

>
> For the case in question, yes I think we'll need the completion wait
> cases to break for running task_work.

Thanks for taking a look. Are you thinking something like changing the
wait_for_completion() in io_wq_exit_workers() to
wait_for_completion_interruptible() and call io_run_task_work()
whenever the wait is interrupted?

Thanks,
Caleb
