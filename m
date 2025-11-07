Received: from mail-oi1-f175.google.com (mail-oi1-f175.google.com [209.85.167.175])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38DC831D75E
	for <syzbot@lists.linux.dev>; Fri,  7 Nov 2025 11:03:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.175
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762513437; cv=none; b=r+NAiaWJUHh1ib1yCK0oZJNdt4zdReFP9k6aCcnWmRglXjSIMyTkOqxMHFS+LUjoZkjnBNfxiLbUuYx+lWba2acGtdB8UdQqTuNz+7NWr66gUh/2Rawe1xuVeAIUOzFO55uEdaXzsN3PmXqPd1ICX6kYjspXxR1/CY/UQQ2GTGY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762513437; c=relaxed/simple;
	bh=+SXxhKN+6v/NBSUtRskNqNkMBr+OodwnNcwTjRWI9mo=;
	h=MIME-Version:References:In-Reply-To:From:Date:Message-ID:Subject:
	 To:Cc:Content-Type; b=TxXoR+kMHSR0G+LCUbJjo0MoHeSTccX86vttY3x6Fvh59rh33gFo0EMVmiwbKWYq7JOEgjDDLGfe7VPp9PfUBNiN5AYolCV3szz+Pq3rLal/S84s5txEQF22vFIJ/mNqqK33X6wBZQ+ueAwcoH57CV946K+h2juy81z48ZQRAJc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com; spf=pass smtp.mailfrom=google.com; dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b=B/uRDZms; arc=none smtp.client-ip=209.85.167.175
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=google.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=google.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=google.com header.i=@google.com header.b="B/uRDZms"
Received: by mail-oi1-f175.google.com with SMTP id 5614622812f47-44fba97bc4aso224035b6e.0
        for <syzbot@lists.linux.dev>; Fri, 07 Nov 2025 03:03:54 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20230601; t=1762513434; x=1763118234; darn=lists.linux.dev;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=81fq+WUMgARdT32vflrkdZwhJw42DhXjNPCLhg3OyCc=;
        b=B/uRDZmstAyXUgqbbzFkt1GKhmVhmi9Q4bD8cRTngLNn/qnLrxcG3DfzAHBSYkhbq+
         76qyFUGIm8uW5aaK5qNxTfpucy2MQiscEJI99TezeIFKXB6iADqpzHBTLetFp7dHbAWn
         eiZrL8+z8yNgOtpk7P69/xijSTugmmz1qmwELQSmIKJhgTvFrMihdw49izZtyAR8nY0G
         KrI2ThpuQi72qT0cXDHE9soR+x4RxI83wa6KPtSMmpRpgAPjGgtyY16Wqv6NLL9pqmZm
         yy2+K2hFIKWNtH7CUOReHfm1MZIej+W9iGo/wL3ME8p2yLNEtgmZLwSrytx3FS9QSw16
         Pw0Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1762513434; x=1763118234;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to;
        bh=81fq+WUMgARdT32vflrkdZwhJw42DhXjNPCLhg3OyCc=;
        b=tZyZG/GF0+im7rc1SR0giG5UXZV6XWsgzGcO3GcRTfrYXuqxML5jU553ble5j/4Yo8
         HpbglaYMcLoWdbkV4wzRDfe+EAJW6f/759plaFNw4E2jyDpMOOQwBUmf2rp3rhPPaCSE
         +Vv1iOQb+3+MO/hLfgrh4os8YKHy3252+GzTdZ4eKEDGktPu/61PnvnjxLyI4gzIP2v4
         1W/kQf65qqfbfDXh+rY8Jg5/o11BhJGGIpOaY5NrPmpoypUFB2E+tkKzDyiqfox66NFw
         lTPQyRdAMqPeLGw8i0397jfb3DodQ9dwjSg1RzSn3tGM4L8eEWS+C2XOu6FyBG7K0kge
         0UtQ==
X-Forwarded-Encrypted: i=1; AJvYcCWKyfN9HNJhS6ywy4AshyYA/ZPgGS+fNu9QWNzEBOL5st2foC6IZcahzzJw/0pj9HkRziJjAjg=@lists.linux.dev
X-Gm-Message-State: AOJu0Yxlo7deMvJrxokQt2rr0Vk8RC8Dj3pZuM74JUBIVT23sVVyiTPZ
	sYbNwEOADrumZyb8oxLg2ILDZxR6VBipR4ExRD41eCplq/PhpvoL0kwIDTjhAL2bZRcjj/gIRQQ
	X5pVXV6d+gudDLhOjAwMfnUrv8QZTACjLHndUvbiW
X-Gm-Gg: ASbGncsfg4e89TUSyTh4U1L5J3g8jvnCE7bO1meHC0rTaNdwENwAOWrmZ9U7N8rY8aw
	Bmy1lwgZvmN4bB19BZygQHPQE+KTnsUfS/UbYW1iGvPI5wa6g5H5eOrXcTGyeEUpJBUTmAS8rP/
	HOlpxq2NxKVfX/CZNwGm3f6G/DOiaLL9Qx0g92FVwwhtOoT+uEPZi66+Nc1PEC/lQ0YeWBWnFjA
	4QTze3z4l1uR3NcyWxf/9g6zQ+dqvgZiuQCKOBc4oRcOd8MC+6qEcewiF/skbSOR+2CzCT0bIYs
	5f9WqQ2H+9ehk3VI38zksUew2ww1ZkkUva7a/OgnaC4/pw==
X-Google-Smtp-Source: AGHT+IHqr3/x/mRBFvWYQ0ZU8bdxW+fKh700IT65QKPNPEGofZnS6O+J0nVqsRDkf5NHgJF+4NKyLY2fXkMYKuOrcS0=
X-Received: by 2002:a05:6808:3090:b0:44d:c08a:e039 with SMTP id
 5614622812f47-45015ca2a21mr1619845b6e.10.1762513433991; Fri, 07 Nov 2025
 03:03:53 -0800 (PST)
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
References: <690db396.a70a0220.22f260.002c.GAE@google.com>
In-Reply-To: <690db396.a70a0220.22f260.002c.GAE@google.com>
From: Aleksandr Nogikh <nogikh@google.com>
Date: Fri, 7 Nov 2025 12:03:42 +0100
X-Gm-Features: AWmQ_bkGwpniW-kN_sCAe0-cM8-UB2_Ye01DnIOu9Twrhcnw1Jd7WB8-n-__F6k
Message-ID: <CANp29Y7fc2gM++5Ov7jcD0KxchETHx-jz2HGKZBdo=eOfA755w@mail.gmail.com>
Subject: Re: [moderation/CI] Re: net: Fix error handling in netdev_register_kobject
To: syzbot ci <syzbot+ci8fda996c96ed440d@syzkaller.appspotmail.com>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable

#syz upstream

On Fri, Nov 7, 2025 at 9:53=E2=80=AFAM syzbot ci
<syzbot+ci8fda996c96ed440d@syzkaller.appspotmail.com> wrote:
>
> syzbot ci has tested the following series
>
> [v1] net: Fix error handling in netdev_register_kobject
> https://lore.kernel.org/all/20251107080117.15099-1-make24@iscas.ac.cn
> * [PATCH] net: Fix error handling in netdev_register_kobject
>
> and found the following issue:
> KASAN: slab-use-after-free Read in netdev_run_todo
>
> Full report is available here:
> https://ci.syzbot.org/series/29bd058e-ea85-48e2-9bb9-ff9c0214f12e
>
> ***
>
> KASAN: slab-use-after-free Read in netdev_run_todo
>
> tree:      net-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/netde=
v/net-next.git
> base:      8a25a2e34157d882032112e4194ccdfb29c499e8
> arch:      amd64
> compiler:  Debian clang version 20.1.8 (++20250708063551+0c9f909b7976-1~e=
xp1~20250708183702.136), Debian LLD 20.1.8
> config:    https://ci.syzbot.org/builds/2f985280-f9ef-47c8-b4ec-80d449682=
22b/config
>
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> BUG: KASAN: slab-use-after-free in kobject_put+0x2ab/0x480
> Read of size 1 at addr ffff888113992714 by task kworker/u8:0/12
>
> CPU: 0 UID: 0 PID: 12 Comm: kworker/u8:0 Not tainted syzkaller #0 PREEMPT=
(full)
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.=
16.2-1 04/01/2014
> Workqueue: netns cleanup_net
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0x189/0x250
>  print_report+0xca/0x240
>  kasan_report+0x118/0x150
>  kobject_put+0x2ab/0x480
>  netdev_run_todo+0xd2e/0xea0
>  ops_undo_list+0x3e1/0x990
>  cleanup_net+0x4d8/0x820
>  process_scheduled_works+0xae1/0x17b0
>  worker_thread+0x8a0/0xda0
>  kthread+0x711/0x8a0
>  ret_from_fork+0x4bc/0x870
>  ret_from_fork_asm+0x1a/0x30
>  </TASK>
>
> Allocated by task 5810:
>  kasan_save_track+0x3e/0x80
>  __kasan_kmalloc+0x93/0xb0
>  __kvmalloc_node_noprof+0x5cd/0x910
>  alloc_netdev_mqs+0xa6/0x11b0
>  ip6gre_init_net+0xb5/0x3c0
>  ops_init+0x35c/0x5c0
>  setup_net+0xfe/0x320
>  copy_net_ns+0x34e/0x4e0
>  create_new_namespaces+0x3f3/0x720
>  unshare_nsproxy_namespaces+0x11c/0x170
>  ksys_unshare+0x4c8/0x8c0
>  __x64_sys_unshare+0x38/0x50
>  do_syscall_64+0xfa/0xfa0
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>
> Freed by task 12:
>  kasan_save_track+0x3e/0x80
>  __kasan_save_free_info+0x46/0x50
>  __kasan_slab_free+0x5c/0x80
>  kfree+0x19a/0x6d0
>  device_release+0x9c/0x1c0
>  kobject_put+0x22b/0x480
>  netdev_run_todo+0xd0c/0xea0
>  ops_undo_list+0x3e1/0x990
>  cleanup_net+0x4d8/0x820
>  process_scheduled_works+0xae1/0x17b0
>  worker_thread+0x8a0/0xda0
>  kthread+0x711/0x8a0
>  ret_from_fork+0x4bc/0x870
>  ret_from_fork_asm+0x1a/0x30
>
> The buggy address belongs to the object at ffff888113992000
>  which belongs to the cache kmalloc-cg-4k of size 4096
> The buggy address is located 1812 bytes inside of
>  freed 4096-byte region [ffff888113992000, ffff888113993000)
>
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x1139=
90
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> flags: 0x17ff00000000040(head|node=3D0|zone=3D2|lastcpupid=3D0x7ff)
> page_type: f5(slab)
> raw: 017ff00000000040 ffff88810004b500 dead000000000122 0000000000000000
> raw: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
> head: 017ff00000000040 ffff88810004b500 dead000000000122 0000000000000000
> head: 0000000000000000 0000000000040004 00000000f5000000 0000000000000000
> head: 017ff00000000003 ffffea00044e6401 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Unmovable, gfp_mask 0xd20c0(=
__GFP_IO|__GFP_FS|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), =
pid 5810, tgid 5810 (syz-executor), ts 65154411256, free_ts 60842795356
>  post_alloc_hook+0x240/0x2a0
>  get_page_from_freelist+0x2365/0x2440
>  __alloc_frozen_pages_noprof+0x181/0x370
>  alloc_pages_mpol+0x232/0x4a0
>  allocate_slab+0x96/0x350
>  ___slab_alloc+0xe94/0x18a0
>  __slab_alloc+0x65/0x100
>  __kmalloc_noprof+0x471/0x7f0
>  __register_sysctl_table+0x72/0x1340
>  __addrconf_sysctl_register+0x328/0x4c0
>  addrconf_sysctl_register+0x168/0x1c0
>  ipv6_add_dev+0xd46/0x1370
>  addrconf_notify+0x794/0x1010
>  notifier_call_chain+0x1b6/0x3e0
>  register_netdevice+0x1608/0x1ae0
>  register_netdev+0x40/0x60
> page last free pid 15 tgid 15 stack trace:
>  __free_frozen_pages+0xbc4/0xd30
>  __folio_put+0x21b/0x2c0
>  skb_release_data+0x49a/0x7c0
>  napi_consume_skb+0x158/0x1e0
>  skb_defer_free_flush+0x18f/0x250
>  net_rx_action+0x804/0xe50
>  handle_softirqs+0x286/0x870
>  run_ksoftirqd+0x9b/0x100
>  smpboot_thread_fn+0x542/0xa60
>  kthread+0x711/0x8a0
>  ret_from_fork+0x4bc/0x870
>  ret_from_fork_asm+0x1a/0x30
>
> Memory state around the buggy address:
>  ffff888113992600: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888113992680: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff888113992700: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                          ^
>  ffff888113992780: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff888113992800: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
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
> [akpm@linux-foundation.org atenart@kernel.org davem@davemloft.net ebieder=
m@xmission.com edumazet@google.com gregkh@suse.de horms@kernel.org kuba@ker=
nel.org kuniyu@google.com linux-kernel@vger.kernel.org make24@iscas.ac.cn n=
etdev@vger.kernel.org pabeni@redhat.com sdf@fomichev.me stable@vger.kernel.=
org yajun.deng@linux.dev]
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
-upstream-moderation/690db396.a70a0220.22f260.002c.GAE%40google.com.
