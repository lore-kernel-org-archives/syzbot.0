Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1E82C178D
	for <syzbot@lists.linux.dev>; Mon,  1 Dec 2025 08:38:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764578284; cv=none; b=TmussiMOEQ1VusrP+kYDXg4ZVH/qflCWZERYWDTVL4k4SSRJHT2aSXNjXxsTK5hvHqPgEhBAkUsvKABKPpZtgjKZxXgUb3qREhf97UbWJdfudY4jC0aq7lI0uWxGE2RCCvXyrQArZgfnldimOIiLuIqIC8hR3shtVb4HHJi1XUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764578284; c=relaxed/simple;
	bh=f5BAZGPbcn5K0I30dMx6veZ1lCTh0TR5gTcpMImaVwE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=eRupc1DVavDCktRHq6DcLYUwhSSrz6rrPEiQtNQPikBa7c9aX1pRoLiOlXt5DLFR20rPyXq4syjW351damUScf/qQJANTgITZ52w9RiHoZLGPZYJ5x8KCyFrzVEhIM8pbAW9CeWWU0s80dRVZ3vJsBs/A6V0nI7gjxc5Q77BeH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=e6tX0cdE; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="e6tX0cdE"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1764578281;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=aBwJ2sSagyNLxNtmA3qx8z9oONT8jrX0YFrWESAdo4Q=;
	b=e6tX0cdEc2lXTC7JFRkL/PvyuXGh0J5EiF7vOSSPygMtA8QgSXd5mRaQCc9NUw3fExFb20
	PpqEb2mQXI3u4l/Ii8rblP2LmxTkhPrrrd6nXgebv/s4vKsAfmDLcXm0qIQrgNlrGC0SBc
	6B1FDk8kqkXEC4ACgIJ5uA4z3uFjGA0=
Received: from mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-211-PMr7c6tbNE-jxldKHoAWYQ-1; Mon,
 01 Dec 2025 03:37:57 -0500
X-MC-Unique: PMr7c6tbNE-jxldKHoAWYQ-1
X-Mimecast-MFC-AGG-ID: PMr7c6tbNE-jxldKHoAWYQ_1764578276
Received: from mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.93])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-05.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 07073195608A;
	Mon,  1 Dec 2025 08:37:56 +0000 (UTC)
Received: from fedora (unknown [10.72.116.20])
	by mx-prod-int-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id D42E21800451;
	Mon,  1 Dec 2025 08:37:49 +0000 (UTC)
Date: Mon, 1 Dec 2025 16:37:41 +0800
From: Ming Lei <ming.lei@redhat.com>
To: Yu Kuai <yukuai@fnnas.com>
Cc: syzbot ci <syzbot+cifc73f799778e73e7@syzkaller.appspotmail.com>,
	axboe@kernel.dk, bvanassche@acm.org, linux-block@vger.kernel.org,
	nilay@linux.ibm.com, tj@kernel.org, syzbot@lists.linux.dev,
	syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: blk-mq: fix possible deadlocks
Message-ID: <aS1T1e2ngoCNfiMG@fedora>
References: <692c17ca.a70a0220.d98e3.016c.GAE@google.com>
 <18d6c3dc-2a86-46cd-972d-0158d7c3c461@fnnas.com>
 <aSzgwai7vSElcjLo@fedora>
 <af82c6b9-e1da-499c-b01f-42f748787044@fnnas.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <af82c6b9-e1da-499c-b01f-42f748787044@fnnas.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.93

On Mon, Dec 01, 2025 at 12:43:03PM +0800, Yu Kuai wrote:
> Hi,
> 
> 在 2025/12/1 8:26, Ming Lei 写道:
> > On Mon, Dec 01, 2025 at 03:50:22AM +0800, Yu Kuai wrote:
> >> Hi,
> >>
> >> 在 2025/11/30 18:09, syzbot ci 写道:
> >>> syzbot ci has tested the following series
> >>>
> >>> [v3] blk-mq: fix possible deadlocks
> >>> https://lore.kernel.org/all/20251130024349.2302128-1-yukuai@fnnas.com
> >>> * [PATCH v3 01/10] blk-mq-debugfs: factor out a helper to register debugfs for all rq_qos
> >>> * [PATCH v3 02/10] blk-rq-qos: fix possible debugfs_mutex deadlock
> >>> * [PATCH v3 03/10] blk-mq-debugfs: make blk_mq_debugfs_register_rqos() static
> >>> * [PATCH v3 04/10] blk-mq-debugfs: warn about possible deadlock
> >>> * [PATCH v3 05/10] block/blk-rq-qos: add a new helper rq_qos_add_frozen()
> >>> * [PATCH v3 06/10] blk-wbt: fix incorrect lock order for rq_qos_mutex and freeze queue
> >>> * [PATCH v3 07/10] blk-iocost: fix incorrect lock order for rq_qos_mutex and freeze queue
> >>> * [PATCH v3 08/10] blk-iolatency: fix incorrect lock order for rq_qos_mutex and freeze queue
> >>> * [PATCH v3 09/10] blk-throttle: remove useless queue frozen
> >>> * [PATCH v3 10/10] block/blk-rq-qos: cleanup rq_qos_add()
> >>>
> >>> and found the following issue:
> >>> possible deadlock in pcpu_alloc_noprof
> >>>
> >>> Full report is available here:
> >>> https://ci.syzbot.org/series/1aec77f0-c53f-4b3b-93fb-b3853983b6bd
> >>>
> >>> ***
> >>>
> >>> possible deadlock in pcpu_alloc_noprof
> >>>
> >>> tree:      linux-next
> >>> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> >>> base:      7d31f578f3230f3b7b33b0930b08f9afd8429817
> >>> arch:      amd64
> >>> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~exp1~20250708183702.136), Debian LLD 20.1.8
> >>> config:    https://ci.syzbot.org/builds/70dca9e4-6667-4930-9024-150d656e503e/config
> >>>
> >>> soft_limit_in_bytes is deprecated and will be removed. Please report your usecase to linux-mm@kvack.org if you depend on this functionality.
> >>> ======================================================
> >>> WARNING: possible circular locking dependency detected
> >>> syzkaller #0 Not tainted
> >>> ------------------------------------------------------
> >>> syz-executor/6047 is trying to acquire lock:
> >>> ffffffff8e04f760 (fs_reclaim){+.+.}-{0:0}, at: prepare_alloc_pages+0x152/0x650
> >>>
> >>> but task is already holding lock:
> >>> ffffffff8e02dde8 (pcpu_alloc_mutex){+.+.}-{4:4}, at: pcpu_alloc_noprof+0x25b/0x1750
> >>>
> >>> which lock already depends on the new lock.
> >>>
> >>>
> >>> the existing dependency chain (in reverse order) is:
> >>>
> >>> -> #2 (pcpu_alloc_mutex){+.+.}-{4:4}:
> >>>          __mutex_lock+0x187/0x1350
> >>>          pcpu_alloc_noprof+0x25b/0x1750
> >>>          blk_stat_alloc_callback+0xd5/0x220
> >>>          wbt_init+0xa3/0x500
> >>>          wbt_enable_default+0x25d/0x350
> >>>          blk_register_queue+0x36a/0x3f0
> >>>          __add_disk+0x677/0xd50
> >>>          add_disk_fwnode+0xfc/0x480
> >>>          loop_add+0x7f0/0xad0
> >>>          loop_init+0xd9/0x170
> >>>          do_one_initcall+0x1fb/0x820
> >>>          do_initcall_level+0x104/0x190
> >>>          do_initcalls+0x59/0xa0
> >>>          kernel_init_freeable+0x334/0x4b0
> >>>          kernel_init+0x1d/0x1d0
> >>>          ret_from_fork+0x599/0xb30
> >>>          ret_from_fork_asm+0x1a/0x30
> >>>
> >>> -> #1 (&q->q_usage_counter(io)#17){++++}-{0:0}:
> >>>          blk_alloc_queue+0x538/0x620
> >>>          __blk_mq_alloc_disk+0x15c/0x340
> >>>          loop_add+0x411/0xad0
> >>>          loop_init+0xd9/0x170
> >>>          do_one_initcall+0x1fb/0x820
> >>>          do_initcall_level+0x104/0x190
> >>>          do_initcalls+0x59/0xa0
> >>>          kernel_init_freeable+0x334/0x4b0
> >>>          kernel_init+0x1d/0x1d0
> >>>          ret_from_fork+0x599/0xb30
> >>>          ret_from_fork_asm+0x1a/0x30
> >>>
> >>> -> #0 (fs_reclaim){+.+.}-{0:0}:
> >>>          __lock_acquire+0x15a6/0x2cf0
> >>>          lock_acquire+0x117/0x340
> >>>          fs_reclaim_acquire+0x72/0x100
> >>>          prepare_alloc_pages+0x152/0x650
> >>>          __alloc_frozen_pages_noprof+0x123/0x370
> >>>          __alloc_pages_noprof+0xa/0x30
> >>>          pcpu_populate_chunk+0x182/0xb30
> >>>          pcpu_alloc_noprof+0xcb6/0x1750
> >>>          xt_percpu_counter_alloc+0x161/0x220
> >>>          translate_table+0x1323/0x2040
> >>>          ip6t_register_table+0x106/0x7d0
> >>>          ip6table_nat_table_init+0x43/0x2e0
> >>>          xt_find_table_lock+0x30c/0x3e0
> >>>          xt_request_find_table_lock+0x26/0x100
> >>>          do_ip6t_get_ctl+0x730/0x1180
> >>>          nf_getsockopt+0x26e/0x290
> >>>          ipv6_getsockopt+0x1ed/0x290
> >>>          do_sock_getsockopt+0x2b4/0x3d0
> >>>          __x64_sys_getsockopt+0x1a5/0x250
> >>>          do_syscall_64+0xfa/0xf80
> >>>          entry_SYSCALL_64_after_hwframe+0x77/0x7f
> >>>
> >>> other info that might help us debug this:
> >>>
> >>> Chain exists of:
> >>>     fs_reclaim --> &q->q_usage_counter(io)#17 --> pcpu_alloc_mutex
> >>>
> >>>    Possible unsafe locking scenario:
> >>>
> >>>          CPU0                    CPU1
> >>>          ----                    ----
> >>>     lock(pcpu_alloc_mutex);
> >>>                                  lock(&q->q_usage_counter(io)#17);
> >>>                                  lock(pcpu_alloc_mutex);
> >>>     lock(fs_reclaim);
> >> This does not look like introduced by this set, wbt_init() will hold
> >> pcpu_alloc_mutex, and it can be called with queue frozen without this
> >> set.
> > It is introduced by your patch 6 in which blk_mq_freeze_queue() is added
> > before calling wb_init() from wbt_enable_default(), then the warning is
> > triggered.
> 
> Yes, I know this, I mean it's the same before this set from queue_wb_lat_store(),
> where freeze queue is already called before wbt_init(), and this is not a new
> problem.

The point is that wb_init() won't be called any more from sysfs if it is
done in blk_register_queue(), which is the default setting.


Thanks,
Ming

