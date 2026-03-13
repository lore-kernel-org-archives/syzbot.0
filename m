Received: from mail-qv1-f47.google.com (mail-qv1-f47.google.com [209.85.219.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033A726A08A
	for <syzbot@lists.linux.dev>; Fri, 13 Mar 2026 23:08:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.219.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773443316; cv=none; b=CMIJGMk/24s3IM113iccpVvXMrmELk42LS4uRu4r6QwoBPaOvPy4oggPnTbdTlcWtKPcgK52HBebCWNxMlry8Vwtn6aRha0/esf73D3JmE7UrKWM1icFOzQn1YPWH9pqKMX8tsQ7gkCYnHTCfa9VnRm2xLO+dhs5y0xlxq+LyQ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773443316; c=relaxed/simple;
	bh=QnGqm4m7X7QiiuC8gNebDwYpWyIiIWZWKuMslVNLatY=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=aYZXF58R4A5jDcImyggK/X1BzJXeMS0yvTJPJDXrMfTtWvYly5vBQSEruvVzaT4hJu2r0mDEl3sKlXzlzf1QvrsFjFBdFY424dDz2nv2cs9TqFUqD/pxoKyZdQqSjFJkKxblpzP0CXFl40MRSLW9DAx6lpT0X9oUe0lYAj80SCs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org; spf=pass smtp.mailfrom=cmpxchg.org; dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b=Li5L0b1P; arc=none smtp.client-ip=209.85.219.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=cmpxchg.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=cmpxchg.org header.i=@cmpxchg.org header.b="Li5L0b1P"
Received: by mail-qv1-f47.google.com with SMTP id 6a1803df08f44-89a0d53f3d1so35304356d6.3
        for <syzbot@lists.linux.dev>; Fri, 13 Mar 2026 16:08:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cmpxchg.org; s=google; t=1773443313; x=1774048113; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=iQn6r17fR0ZCkH5iTyR5vE7sb4nJUi8kn661lqcNUlc=;
        b=Li5L0b1PnORd/RU2dkK/BGE+os7DZyhc5fh1YhDsFBvIcx0wW0RuqBSSee5E4rP5zq
         x+7IHRQwM/rV6KuJwvsfhIR2NT0t7XLfb99FtVjoja9FpS9cRA9ptMPlFPrUV2k5BzCq
         pVZiywUUAXZAl4NQmC68SjWjAMnBnrYNM7AYDgBJbdaP/o6QJXT1ALPtOZroKbLcqDRO
         lHP8rs0X3nDDJAr9NnqAewENIC0CPIQUc+WAaOUVwVF1mPy3BLN84p0zODhcUGVXYmbW
         QFiOsua4ZYjkEk2om/WnAZWPlXjo2je2wRFlkNg9BwY6zRQiS8TeXoTQRlt2AZbWKH4T
         I68A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1773443313; x=1774048113;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=iQn6r17fR0ZCkH5iTyR5vE7sb4nJUi8kn661lqcNUlc=;
        b=npn63B7HdHTQ9bCq9r6M0NWUXL7skWu3oiOEF+TfabZsXwFk0Qppkn2Ksr411t0lMw
         zkxNWfl2ihc/mAKoYeSprfWffUVHqt0/P/rJWnyb/JrJLzw+R82/juoZOS/a8ziWRD1d
         Egw7xlj6Alh0NYMZiRfjwciYn6jPL/M+9AlkEZEQNvxTbqZqqHP46ae1X3Vz/oj55YUN
         GXtmlD5hO3J6Rc+WitY3fgIm20A9FKugfARiNX6TSsuovTycMtbID2TyHY9UdryTuIKD
         03pWFQbB3wXfyCiW5f8PaSxhHpec7PnvU8q+nuI2qrR/I1Ui4Q5NjPn1DyqV5kgPBKgZ
         tPNw==
X-Forwarded-Encrypted: i=1; AJvYcCUUA3748pTbd9pNaEJya+rxlG9wKCwked8dADuo2w5CHc7Eml1QfH3SRo8ZPzA42acbVVuvAv4=@lists.linux.dev
X-Gm-Message-State: AOJu0YzZA8hZ9xLq50EqklzO2ISeW5KHEV3PYQeF4UEudsC3jDeHtxMJ
	FH6x6VPhWJ9TRo2368ycr878kjLBAexPh6mkRgtOjIlhYJ9MznsDvNUHIWk9VMxhhKA=
X-Gm-Gg: ATEYQzyr1kLSjD+2feaS8Uhvogre1hOJWs4dYwJ1QxkGrudX8PEu7CuttXYEais+CtV
	KAEXrfcqnzYsjIPhIyABd3xbjuZ2AIU0j+Klg12ggxl3T6+Md0OR6QXauVC9aJb2x5p7rvtvFQp
	v2qwk3XZBtaqOH6RyIYVtxrNOXx4Jo9f/UuO8Zxadhln2vm7pKBUgkcqPM0zzP2u608IomWpw6D
	ljESKtXh8l3kuOb22ITV67SV8Wm2nlbZVVMek/v7JgeWsHespNvqCGgFb6oORN7x83lLWwNlwpW
	/9jrLx8U92JfNW8NjIkTXy820ESYhjfK5KPrw4/R9ZENpWdPqCH6PABtNMUjWwrS28umwObVrIw
	MW+moGrvtRJCzQhtTkneh2zcidEitmR5SSGMV8bYOnm1kbnPSnNan3unNL2K6jc+Xsd1gULlr2G
	aBXkZ3X/5ro+PH+z19mk0GMg==
X-Received: by 2002:ad4:5766:0:b0:89a:c88:1fb6 with SMTP id 6a1803df08f44-89a820283abmr79354466d6.53.1773443312789;
        Fri, 13 Mar 2026 16:08:32 -0700 (PDT)
Received: from localhost ([2603:7000:c00:3a00:365a:60ff:fe62:ff29])
        by smtp.gmail.com with ESMTPSA id 6a1803df08f44-89a65cfc409sm67174226d6.35.2026.03.13.16.08.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Mar 2026 16:08:31 -0700 (PDT)
Date: Fri, 13 Mar 2026 19:08:27 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: syzbot ci <syzbot+cidbbb79a1260c5a35@syzkaller.appspotmail.com>
Cc: akpm@linux-foundation.org, david@fromorbit.com, david@kernel.org,
	kas@kernel.org, liam.howlett@oracle.com,
	linux-kernel@vger.kernel.org, linux-mm@kvack.org,
	roman.gushchin@linux.dev, shakeel.butt@linux.dev,
	usama.arif@linux.dev, yosry.ahmed@linux.dev, ziy@nvidia.com,
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: mm: switch THP shrinker to list_lru
Message-ID: <abSY63WnrSv69vw1@cmpxchg.org>
References: <20260312205321.638053-1-hannes@cmpxchg.org>
 <69b44bda.050a0220.36eb34.000d.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69b44bda.050a0220.36eb34.000d.GAE@google.com>

On Fri, Mar 13, 2026 at 10:39:38AM -0700, syzbot ci wrote:
> ------------[ cut here ]------------
> !css_is_dying(&memcg->css)
> WARNING: mm/list_lru.c:110 at lock_list_lru_of_memcg+0x33d/0x470 mm/list_lru.c:110, CPU#0: syz.0.17/5950
> Modules linked in:
> CPU: 0 UID: 0 PID: 5950 Comm: syz.0.17 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:lock_list_lru_of_memcg+0x33d/0x470 mm/list_lru.c:110
> Code: 3c 28 00 74 08 4c 89 e7 e8 b0 02 1d 00 4d 8b 24 24 48 8b 54 24 20 4d 85 e4 0f 85 00 fe ff ff e9 75 fe ff ff e8 d4 df b3 ff 90 <0f> 0b 90 eb c1 89 d9 80 e1 07 80 c1 03 38 c1 0f 8c 06 fe ff ff 48
> RSP: 0018:ffffc90004017110 EFLAGS: 00010093
> RAX: ffffffff8211b3ac RBX: 0000000000000000 RCX: ffff888104f057c0
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000000
> RBP: 0000000000000000 R08: ffff888104f057c0 R09: 0000000000000002
> R10: 0000000000000406 R11: 0000000000000000 R12: ffff8881026d0d00
> R13: dffffc0000000000 R14: ffffffff9a2de05c R15: 0000000000000002
> FS:  0000555572bfe500(0000) GS:ffff88818de66000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000200000001000 CR3: 0000000112554000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __folio_freeze_and_split_unmapped+0x2ab/0x34b0 mm/huge_memory.c:3767
>  __folio_split+0xae1/0x1570 mm/huge_memory.c:4033
>  try_folio_split_to_order include/linux/huge_mm.h:411 [inline]
>  try_folio_split_or_unmap+0x5b/0x1e0 mm/truncate.c:189
>  truncate_inode_partial_folio+0x4ab/0x8e0 mm/truncate.c:255

File pages aren't on the deferred_split_lru. We're calling
list_lru_lock() on a nid+memcg combination that doesn't have list_lru
heads allocated. This should either fail gracefully or needs page type
filtering in __folio_freeze_and_split_unmapped(). Needs more thought.

> possible deadlock in __folio_end_writeback
> 
> =====================================================
> WARNING: SOFTIRQ-safe -> SOFTIRQ-unsafe lock order detected
> syzkaller #0 Not tainted
> -----------------------------------------------------
> syz.0.17/5949 [HC0[0]:SC0[0]:HE0:SE1] is trying to acquire:
> ffff88810c90c240 (&l->lock){+.+.}-{3:3}, at: spin_lock include/linux/spinlock.h:341 [inline]
> ffff88810c90c240 (&l->lock){+.+.}-{3:3}, at: lock_list_lru mm/list_lru.c:26 [inline]
> ffff88810c90c240 (&l->lock){+.+.}-{3:3}, at: lock_list_lru_of_memcg+0x268/0x470 mm/list_lru.c:95
> 
> and this task is already holding:
> ffff8881107ad160 (&xa->xa_lock#9){..-.}-{3:3}, at: spin_lock include/linux/spinlock.h:341 [inline]
> ffff8881107ad160 (&xa->xa_lock#9){..-.}-{3:3}, at: __folio_split+0xa2e/0x1570 mm/huge_memory.c:4025
> which would create a new lock dependency:
>  (&xa->xa_lock#9){..-.}-{3:3} -> (&l->lock){+.+.}-{3:3}
> 
> but this new dependency connects a SOFTIRQ-irq-safe lock:
>  (&xa->xa_lock#9){..-.}-{3:3}
> 
> ... which became SOFTIRQ-irq-safe at:
>   lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
>   __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
>   _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:162
>   __folio_end_writeback+0x157/0x770 mm/page-writeback.c:2946
>
> to a SOFTIRQ-irq-unsafe lock:
>  (&l->lock){+.+.}-{3:3}
> 
> ... which became SOFTIRQ-irq-unsafe at:
> ...
>   lock_acquire+0xf0/0x2e0 kernel/locking/lockdep.c:5868
>   __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
>   _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:154
>   spin_lock include/linux/spinlock.h:341 [inline]
>   lock_list_lru mm/list_lru.c:26 [inline]
>   lock_list_lru_of_memcg+0x268/0x470 mm/list_lru.c:95
>   list_lru_lock mm/list_lru.c:154 [inline]
>   list_lru_add+0x46/0x260 mm/list_lru.c:208
>   list_lru_add_obj+0x191/0x270 mm/list_lru.c:221
>   d_lru_add+0xd6/0x160 fs/dcache.c:497

Different locks, deferred_split_lru needs its own lockdep key.
