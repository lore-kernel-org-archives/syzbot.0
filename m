Received: from sg-1-34.ptr.blmpb.com (sg-1-34.ptr.blmpb.com [118.26.132.34])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 460262FB0AD
	for <syzbot@lists.linux.dev>; Mon,  1 Dec 2025 08:42:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=118.26.132.34
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764578525; cv=none; b=Fb4iEY4KKV9hZGvlaHgfTKINYvfw8qmjBmatx5eMP+7b4fEPDuIXPV3tPdPtfmpZXxqze/e2u2aVJHOoRakTh+//2msyJVRidm11vChLXj2PvNwGWYHR6bn61aRHPXtdXnij+E46F5C1lDlvbrgEktUseeEtoqWx43sW+Pp12vM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764578525; c=relaxed/simple;
	bh=pFuI80qYTcO9CoA9/6FaqfL29f4KNAAwuQCOj+W4YWc=;
	h=In-Reply-To:References:Subject:To:From:Date:Message-Id:
	 Mime-Version:Content-Type:Cc; b=h/QgxSVn1+RK5VbC7hBddP0HUZZ5u5fSdXh+b/XVhtF9h0MqJwYNeQ5auECbe0QMMND+rY+V+KQTvrHXUdSkla+UPqnQk+8mGcmg1ToOHAl7qU5CBeGNFpMfp4+ixa20iY6oYqLeYe/KCqZff7ld1kvhJ97FbVP4EdBV/5cJM8o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com; spf=pass smtp.mailfrom=fnnas.com; dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b=rNRQkDcE; arc=none smtp.client-ip=118.26.132.34
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=fnnas.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=fnnas.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=fnnas-com.20200927.dkim.feishu.cn header.i=@fnnas-com.20200927.dkim.feishu.cn header.b="rNRQkDcE"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
 s=s1; d=fnnas-com.20200927.dkim.feishu.cn; t=1764578505;
  h=from:subject:mime-version:from:date:message-id:subject:to:cc:
 reply-to:content-type:mime-version:in-reply-to:message-id;
 bh=DTDMYOo4yMnoYkokc4VAnbjaO1mBQ8awNzs1BRWlmPs=;
 b=rNRQkDcEONSqgPVzKwpep4/ME4IcMK0wOW9I+TcFQoT8IZyjXUiyjIQ+9HeLgUX5nz/gBE
 F1bLMmNbqnPHb6fiN4y2okZaHPazkwemQ6umklB80mV/cq3XlU4vrrp89st/n25l22E6+w
 6vf0XEfQ2BDxTVJk4ydqoqRg8nJ002D0M84Gwp3fffJllbV8VCDZW34fWUPsQlowChfztE
 ANXzaAUI5BfdSF+dkB2Jbsjhr9hcRF0SI/alnwE8lFUaZrpziYUpeEBKv1vAjb93SrQ07y
 MpWa1lMq06UZLyuq01cWpm703kpdOaGNeGS892eIpVKLyLlMHD0FqDdD/NAQuQ==
In-Reply-To: <aS1T1e2ngoCNfiMG@fedora>
User-Agent: Mozilla Thunderbird
References: <692c17ca.a70a0220.d98e3.016c.GAE@google.com> <18d6c3dc-2a86-46cd-972d-0158d7c3c461@fnnas.com> <aSzgwai7vSElcjLo@fedora> <af82c6b9-e1da-499c-b01f-42f748787044@fnnas.com> <aS1T1e2ngoCNfiMG@fedora>
X-Original-From: Yu Kuai <yukuai@fnnas.com>
Subject: Re: [syzbot ci] Re: blk-mq: fix possible deadlocks
X-Lms-Return-Path: <lba+2692d54c7+d427d0+lists.linux.dev+yukuai@fnnas.com>
Received: from [192.168.1.104] ([39.182.0.153]) by smtp.feishu.cn with ESMTPS; Mon, 01 Dec 2025 16:41:42 +0800
Content-Language: en-US
Organization: fnnas
Content-Transfer-Encoding: quoted-printable
Reply-To: yukuai@fnnas.com
To: "Ming Lei" <ming.lei@redhat.com>
From: "Yu Kuai" <yukuai@fnnas.com>
Date: Mon, 1 Dec 2025 16:41:40 +0800
Message-Id: <ee8e7254-7526-44a2-a16c-c7dfb4eba092@fnnas.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: "syzbot ci" <syzbot+cifc73f799778e73e7@syzkaller.appspotmail.com>, 
	<axboe@kernel.dk>, <bvanassche@acm.org>, <linux-block@vger.kernel.org>, 
	<nilay@linux.ibm.com>, <tj@kernel.org>, <syzbot@lists.linux.dev>, 
	<syzkaller-bugs@googlegroups.com>, "Yu Kuai" <yukuai@fnnas.com>

Hi,

=E5=9C=A8 2025/12/1 16:37, Ming Lei =E5=86=99=E9=81=93:
> On Mon, Dec 01, 2025 at 12:43:03PM +0800, Yu Kuai wrote:
>> Hi,
>>
>> =E5=9C=A8 2025/12/1 8:26, Ming Lei =E5=86=99=E9=81=93:
>>> On Mon, Dec 01, 2025 at 03:50:22AM +0800, Yu Kuai wrote:
>>>> Hi,
>>>>
>>>> =E5=9C=A8 2025/11/30 18:09, syzbot ci =E5=86=99=E9=81=93:
>>>>> syzbot ci has tested the following series
>>>>>
>>>>> [v3] blk-mq: fix possible deadlocks
>>>>> https://lore.kernel.org/all/20251130024349.2302128-1-yukuai@fnnas.com
>>>>> * [PATCH v3 01/10] blk-mq-debugfs: factor out a helper to register de=
bugfs for all rq_qos
>>>>> * [PATCH v3 02/10] blk-rq-qos: fix possible debugfs_mutex deadlock
>>>>> * [PATCH v3 03/10] blk-mq-debugfs: make blk_mq_debugfs_register_rqos(=
) static
>>>>> * [PATCH v3 04/10] blk-mq-debugfs: warn about possible deadlock
>>>>> * [PATCH v3 05/10] block/blk-rq-qos: add a new helper rq_qos_add_froz=
en()
>>>>> * [PATCH v3 06/10] blk-wbt: fix incorrect lock order for rq_qos_mutex=
 and freeze queue
>>>>> * [PATCH v3 07/10] blk-iocost: fix incorrect lock order for rq_qos_mu=
tex and freeze queue
>>>>> * [PATCH v3 08/10] blk-iolatency: fix incorrect lock order for rq_qos=
_mutex and freeze queue
>>>>> * [PATCH v3 09/10] blk-throttle: remove useless queue frozen
>>>>> * [PATCH v3 10/10] block/blk-rq-qos: cleanup rq_qos_add()
>>>>>
>>>>> and found the following issue:
>>>>> possible deadlock in pcpu_alloc_noprof
>>>>>
>>>>> Full report is available here:
>>>>> https://ci.syzbot.org/series/1aec77f0-c53f-4b3b-93fb-b3853983b6bd
>>>>>
>>>>> ***
>>>>>
>>>>> possible deadlock in pcpu_alloc_noprof
>>>>>
>>>>> tree:      linux-next
>>>>> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/n=
ext/linux-next
>>>>> base:      7d31f578f3230f3b7b33b0930b08f9afd8429817
>>>>> arch:      amd64
>>>>> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976=
-1~exp1~20250708183702.136), Debian LLD 20.1.8
>>>>> config:    https://ci.syzbot.org/builds/70dca9e4-6667-4930-9024-150d6=
56e503e/config
>>>>>
>>>>> soft_limit_in_bytes is deprecated and will be removed. Please report =
your usecase to linux-mm@kvack.org if you depend on this functionality.
>>>>> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D
>>>>> WARNING: possible circular locking dependency detected
>>>>> syzkaller #0 Not tainted
>>>>> ------------------------------------------------------
>>>>> syz-executor/6047 is trying to acquire lock:
>>>>> ffffffff8e04f760 (fs_reclaim){+.+.}-{0:0}, at: prepare_alloc_pages+0x=
152/0x650
>>>>>
>>>>> but task is already holding lock:
>>>>> ffffffff8e02dde8 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_nopro=
f+0x25b/0x1750
>>>>>
>>>>> which lock already depends on the new lock.
>>>>>
>>>>>
>>>>> the existing dependency chain (in reverse order) is:
>>>>>
>>>>> -> #2 (pcpu_alloc_mutex){+.+.}-{4:4}:
>>>>>           __mutex_lock+0x187/0x1350
>>>>>           pcpu_alloc_noprof+0x25b/0x1750
>>>>>           blk_stat_alloc_callback+0xd5/0x220
>>>>>           wbt_init+0xa3/0x500
>>>>>           wbt_enable_default+0x25d/0x350
>>>>>           blk_register_queue+0x36a/0x3f0
>>>>>           __add_disk+0x677/0xd50
>>>>>           add_disk_fwnode+0xfc/0x480
>>>>>           loop_add+0x7f0/0xad0
>>>>>           loop_init+0xd9/0x170
>>>>>           do_one_initcall+0x1fb/0x820
>>>>>           do_initcall_level+0x104/0x190
>>>>>           do_initcalls+0x59/0xa0
>>>>>           kernel_init_freeable+0x334/0x4b0
>>>>>           kernel_init+0x1d/0x1d0
>>>>>           ret_from_fork+0x599/0xb30
>>>>>           ret_from_fork_asm+0x1a/0x30
>>>>>
>>>>> -> #1 (&q->q_usage_counter(io)#17){++++}-{0:0}:
>>>>>           blk_alloc_queue+0x538/0x620
>>>>>           __blk_mq_alloc_disk+0x15c/0x340
>>>>>           loop_add+0x411/0xad0
>>>>>           loop_init+0xd9/0x170
>>>>>           do_one_initcall+0x1fb/0x820
>>>>>           do_initcall_level+0x104/0x190
>>>>>           do_initcalls+0x59/0xa0
>>>>>           kernel_init_freeable+0x334/0x4b0
>>>>>           kernel_init+0x1d/0x1d0
>>>>>           ret_from_fork+0x599/0xb30
>>>>>           ret_from_fork_asm+0x1a/0x30
>>>>>
>>>>> -> #0 (fs_reclaim){+.+.}-{0:0}:
>>>>>           __lock_acquire+0x15a6/0x2cf0
>>>>>           lock_acquire+0x117/0x340
>>>>>           fs_reclaim_acquire+0x72/0x100
>>>>>           prepare_alloc_pages+0x152/0x650
>>>>>           __alloc_frozen_pages_noprof+0x123/0x370
>>>>>           __alloc_pages_noprof+0xa/0x30
>>>>>           pcpu_populate_chunk+0x182/0xb30
>>>>>           pcpu_alloc_noprof+0xcb6/0x1750
>>>>>           xt_percpu_counter_alloc+0x161/0x220
>>>>>           translate_table+0x1323/0x2040
>>>>>           ip6t_register_table+0x106/0x7d0
>>>>>           ip6table_nat_table_init+0x43/0x2e0
>>>>>           xt_find_table_lock+0x30c/0x3e0
>>>>>           xt_request_find_table_lock+0x26/0x100
>>>>>           do_ip6t_get_ctl+0x730/0x1180
>>>>>           nf_getsockopt+0x26e/0x290
>>>>>           ipv6_getsockopt+0x1ed/0x290
>>>>>           do_sock_getsockopt+0x2b4/0x3d0
>>>>>           __x64_sys_getsockopt+0x1a5/0x250
>>>>>           do_syscall_64+0xfa/0xf80
>>>>>           entry_SYSCALL_64_after_hwframe+0x77/0x7f
>>>>>
>>>>> other info that might help us debug this:
>>>>>
>>>>> Chain exists of:
>>>>>      fs_reclaim --> &q->q_usage_counter(io)#17 --> pcpu_alloc_mutex
>>>>>
>>>>>     Possible unsafe locking scenario:
>>>>>
>>>>>           CPU0                    CPU1
>>>>>           ----                    ----
>>>>>      lock(pcpu_alloc_mutex);
>>>>>                                   lock(&q->q_usage_counter(io)#17);
>>>>>                                   lock(pcpu_alloc_mutex);
>>>>>      lock(fs_reclaim);
>>>> This does not look like introduced by this set, wbt_init() will hold
>>>> pcpu_alloc_mutex, and it can be called with queue frozen without this
>>>> set.
>>> It is introduced by your patch 6 in which blk_mq_freeze_queue() is adde=
d
>>> before calling wb_init() from wbt_enable_default(), then the warning is
>>> triggered.
>> Yes, I know this, I mean it's the same before this set from queue_wb_lat=
_store(),
>> where freeze queue is already called before wbt_init(), and this is not =
a new
>> problem.
> The point is that wb_init() won't be called any more from sysfs if it is
> done in blk_register_queue(), which is the default setting.

That is the case if wbt is enabled by default, however, we have a config op=
tion,
see CONFIG_BLK_WBT_MQ, to disable wbt by default, and in this case wbt_init=
()
can be called by sysfs.

Anyway, I already sent a new version to fix this. :)

>
> Thanks,
> Ming
>
>
--=20
Thanks,
Kuai
