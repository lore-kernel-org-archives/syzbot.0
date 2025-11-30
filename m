Received: from sg-1-40.ptr.blmpb.com (sg-1-40.ptr.blmpb.com [118.26.132.40])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C148A22759C
	for <syzbot@lists.linux.dev>; Sun, 30 Nov 2025 19:50:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.40
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764532246; cv=none; b=e/6E4Vz8QzMiqhuR//o1pGOiuMnn8ASMuvWwELb4vybFDPoApXfosIU8UtSN7E19sWiuoyAMpZEYXFtJt+DWTbVEfK1Kwy8a5/Ls2Aq0pNm8nUK4kpELQRfwYySEb24lyJVjZLxdYae9d7tcvqoYk6WzPa47GQTAevNV/UKURr0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764532246; c=relaxed/simple;
	bh=5dID+fu2DVu5gJNfTYt6aqQBh+QW0yS7b7bJFHQiNC4=;
	h=In-Reply-To:References:Cc:Mime-Version:To:Subject:Date:Message-Id:
	 Content-Type:From; b=jarDD2l5UVkvHVoIOajxTXdI0/PxsQ4qpGpR8rC72T2dW4iUYaKSkYj9lGfCcd9x/Em6UOgDf3UV6UXjPjkGgDEryEVZlJQZogtfZTC7lWuAuNDgFe10kSAHEsafam8NYSapRyjuj4LdoQH0PfSRVE6u0kkvE5p8Q4g4yAwpIyk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=eq2AoNXC; arc=none smtp.client-ip=118.26.132.40
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="eq2AoNXC"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1764532227;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=vWG5WSNLTXbHcNEgzGtab8VOWtJUGUC9iSUty6K+A10=;
 b=eq2AoNXCSpjbo4ZbPubxdcYyt+RZI2NAwSdECmW44JYI8BgGFYDVdFf1A/gZkgqobWcamP
 KH66ijjNWwDuEObf+kTpyBYT4h+OLeb0VEp6IIIhojQuI035ZAroVZS9W7FLHZVFX5MUMf
 Az+lDsY35QhZ8FGTZg597PQ/GMpCGCGlI4fCErxbzyPk2G6KBhGlNUWoDL2Jyc81rOqMuj
 xIABqm4XVLV/6OVlEXpGA+chSI9BMnPhFys9Oa5O44xblZqkiYQ1wufjAmgitQaH7O7ASk
 ZFZcl+zmTr2DibS+MVr2lU3rJRG71UfM+JoArNAMPG1hQ7V2sFqtPSMmiq2D3g==
Reply-To: yukuai@fnnas.com
X-Original-From: Yu Kuai <yukuai@fnnas.com>
In-Reply-To: <692c17ca.a70a0220.d98e3.016c.GAE@google.com>
References: <692c17ca.a70a0220.d98e3.016c.GAE@google.com>
Cc: <syzbot@lists.linux.dev>, <syzkaller-bugs@googlegroups.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
User-Agent: Mozilla Thunderbird
X-Lms-Return-Path: <lba+2692ca001+fe6cfc+lists.linux.dev+yukuai@fnnas.com>
Organization: fnnas
Content-Transfer-Encoding: quoted-printable
To: "syzbot ci" <syzbot+cifc73f799778e73e7@syzkaller.appspotmail.com>, 
	<axboe@kernel.dk>, <bvanassche@acm.org>, <linux-block@vger.kernel.org>, 
	<ming.lei@redhat.com>, <nilay@linux.ibm.com>, <tj@kernel.org>, 
	"Yu Kuai" <yukuai@fnnas.com>
Subject: Re: [syzbot ci] Re: blk-mq: fix possible deadlocks
Date: Mon, 1 Dec 2025 03:50:22 +0800
Message-Id: <18d6c3dc-2a86-46cd-972d-0158d7c3c461@fnnas.com>
Content-Type: text/plain; charset=UTF-8
From: "Yu Kuai" <yukuai@fnnas.com>
Content-Language: en-US
Received: from [192.168.1.104] ([39.182.0.153]) by smtp.feishu.cn with ESMTPS; Mon, 01 Dec 2025 03:50:24 +0800

Hi,

=E5=9C=A8 2025/11/30 18:09, syzbot ci =E5=86=99=E9=81=93:
> syzbot ci has tested the following series
>
> [v3] blk-mq: fix possible deadlocks
> https://lore.kernel.org/all/20251130024349.2302128-1-yukuai@fnnas.com
> * [PATCH v3 01/10] blk-mq-debugfs: factor out a helper to register debugf=
s for all rq_qos
> * [PATCH v3 02/10] blk-rq-qos: fix possible debugfs_mutex deadlock
> * [PATCH v3 03/10] blk-mq-debugfs: make blk_mq_debugfs_register_rqos() st=
atic
> * [PATCH v3 04/10] blk-mq-debugfs: warn about possible deadlock
> * [PATCH v3 05/10] block/blk-rq-qos: add a new helper rq_qos_add_frozen()
> * [PATCH v3 06/10] blk-wbt: fix incorrect lock order for rq_qos_mutex and=
 freeze queue
> * [PATCH v3 07/10] blk-iocost: fix incorrect lock order for rq_qos_mutex =
and freeze queue
> * [PATCH v3 08/10] blk-iolatency: fix incorrect lock order for rq_qos_mut=
ex and freeze queue
> * [PATCH v3 09/10] blk-throttle: remove useless queue frozen
> * [PATCH v3 10/10] block/blk-rq-qos: cleanup rq_qos_add()
>
> and found the following issue:
> possible deadlock in pcpu_alloc_noprof
>
> Full report is available here:
> https://ci.syzbot.org/series/1aec77f0-c53f-4b3b-93fb-b3853983b6bd
>
> ***
>
> possible deadlock in pcpu_alloc_noprof
>
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/=
linux-next
> base:      7d31f578f3230f3b7b33b0930b08f9afd8429817
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/70dca9e4-6667-4930-9024-150d656e5=
03e/config
>
> soft_limit_in_bytes is deprecated and will be removed. Please report your=
 usecase to linux-mm@kvack.org if you depend on this functionality.
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> syzkaller #0 Not tainted
> ------------------------------------------------------
> syz-executor/6047 is trying to acquire lock:
> ffffffff8e04f760 (fs_reclaim){+.+.}-{0:0}, at: prepare_alloc_pages+0x152/=
0x650
>
> but task is already holding lock:
> ffffffff8e02dde8 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_noprof+0x=
25b/0x1750
>
> which lock already depends on the new lock.
>
>
> the existing dependency chain (in reverse order) is:
>
> -> #2 (pcpu_alloc_mutex){+.+.}-{4:4}:
>         __mutex_lock+0x187/0x1350
>         pcpu_alloc_noprof+0x25b/0x1750
>         blk_stat_alloc_callback+0xd5/0x220
>         wbt_init+0xa3/0x500
>         wbt_enable_default+0x25d/0x350
>         blk_register_queue+0x36a/0x3f0
>         __add_disk+0x677/0xd50
>         add_disk_fwnode+0xfc/0x480
>         loop_add+0x7f0/0xad0
>         loop_init+0xd9/0x170
>         do_one_initcall+0x1fb/0x820
>         do_initcall_level+0x104/0x190
>         do_initcalls+0x59/0xa0
>         kernel_init_freeable+0x334/0x4b0
>         kernel_init+0x1d/0x1d0
>         ret_from_fork+0x599/0xb30
>         ret_from_fork_asm+0x1a/0x30
>
> -> #1 (&q->q_usage_counter(io)#17){++++}-{0:0}:
>         blk_alloc_queue+0x538/0x620
>         __blk_mq_alloc_disk+0x15c/0x340
>         loop_add+0x411/0xad0
>         loop_init+0xd9/0x170
>         do_one_initcall+0x1fb/0x820
>         do_initcall_level+0x104/0x190
>         do_initcalls+0x59/0xa0
>         kernel_init_freeable+0x334/0x4b0
>         kernel_init+0x1d/0x1d0
>         ret_from_fork+0x599/0xb30
>         ret_from_fork_asm+0x1a/0x30
>
> -> #0 (fs_reclaim){+.+.}-{0:0}:
>         __lock_acquire+0x15a6/0x2cf0
>         lock_acquire+0x117/0x340
>         fs_reclaim_acquire+0x72/0x100
>         prepare_alloc_pages+0x152/0x650
>         __alloc_frozen_pages_noprof+0x123/0x370
>         __alloc_pages_noprof+0xa/0x30
>         pcpu_populate_chunk+0x182/0xb30
>         pcpu_alloc_noprof+0xcb6/0x1750
>         xt_percpu_counter_alloc+0x161/0x220
>         translate_table+0x1323/0x2040
>         ip6t_register_table+0x106/0x7d0
>         ip6table_nat_table_init+0x43/0x2e0
>         xt_find_table_lock+0x30c/0x3e0
>         xt_request_find_table_lock+0x26/0x100
>         do_ip6t_get_ctl+0x730/0x1180
>         nf_getsockopt+0x26e/0x290
>         ipv6_getsockopt+0x1ed/0x290
>         do_sock_getsockopt+0x2b4/0x3d0
>         __x64_sys_getsockopt+0x1a5/0x250
>         do_syscall_64+0xfa/0xf80
>         entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> other info that might help us debug this:
>
> Chain exists of:
>    fs_reclaim --> &q->q_usage_counter(io)#17 --> pcpu_alloc_mutex
>
>   Possible unsafe locking scenario:
>
>         CPU0                    CPU1
>         ----                    ----
>    lock(pcpu_alloc_mutex);
>                                 lock(&q->q_usage_counter(io)#17);
>                                 lock(pcpu_alloc_mutex);
>    lock(fs_reclaim);

This does not look like introduced by this set, wbt_init() will hold
pcpu_alloc_mutex, and it can be called with queue frozen without this
set.

Looks like we should allocate rwb before freeze queue, like what we
did in other path.

>
>   *** DEADLOCK ***
>
> 1 lock held by syz-executor/6047:
>   #0: ffffffff8e02dde8 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_nop=
rof+0x25b/0x1750
>
> stack backtrace:
> CPU: 0 UID: 0 PID: 6047 Comm: syz-executor Not tainted syzkaller #0 PREEM=
PT(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0x189/0x250
>   print_circular_bug+0x2e2/0x300
>   check_noncircular+0x12e/0x150
>   __lock_acquire+0x15a6/0x2cf0
>   lock_acquire+0x117/0x340
>   fs_reclaim_acquire+0x72/0x100
>   prepare_alloc_pages+0x152/0x650
>   __alloc_frozen_pages_noprof+0x123/0x370
>   __alloc_pages_noprof+0xa/0x30
>   pcpu_populate_chunk+0x182/0xb30
>   pcpu_alloc_noprof+0xcb6/0x1750
>   xt_percpu_counter_alloc+0x161/0x220
>   translate_table+0x1323/0x2040
>   ip6t_register_table+0x106/0x7d0
>   ip6table_nat_table_init+0x43/0x2e0
>   xt_find_table_lock+0x30c/0x3e0
>   xt_request_find_table_lock+0x26/0x100
>   do_ip6t_get_ctl+0x730/0x1180
>   nf_getsockopt+0x26e/0x290
>   ipv6_getsockopt+0x1ed/0x290
>   do_sock_getsockopt+0x2b4/0x3d0
>   __x64_sys_getsockopt+0x1a5/0x250
>   do_syscall_64+0xfa/0xf80
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7feba799150a
> Code: ff c3 66 0f 1f 44 00 00 48 c7 c2 a8 ff ff ff f7 d8 64 89 02 b8 ff f=
f ff ff eb b8 0f 1f 44 00 00 49 89 ca b8 37 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 06 c3 0f 1f 44 00 00 48 c7 c2 a8 ff ff ff f7
> RSP: 002b:00007fff14c6a9e8 EFLAGS: 00000246 ORIG_RAX: 0000000000000037
> RAX: ffffffffffffffda RBX: 0000000000000003 RCX: 00007feba799150a
> RDX: 0000000000000040 RSI: 0000000000000029 RDI: 0000000000000003
> RBP: 0000000000000029 R08: 00007fff14c6aa0c R09: ffffffffff000000
> R10: 00007feba7bb6368 R11: 0000000000000246 R12: 00007feba7a30907
> R13: 00007feba7bb7e60 R14: 00007feba7bb6368 R15: 00007feba7bb6360
>   </TASK>
>
>
> ***
>
> If these findings have caused you to resend the series or submit a
> separate fix, please add the following tag to your commit message:
>    Tested-by: syzbot@syzkaller.appspotmail.com
>
> ---
> This report is generated by a bot. It may contain errors.
> syzbot ci engineers can be reached at syzkaller@googlegroups.com.
>
--=20
Thanks,
Kuai
