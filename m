Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61AC23EAB0
	for <syzbot@lists.linux.dev>; Thu, 23 Apr 2026 08:53:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776934425; cv=none; b=Luc0EBpkhehg+6IAA5fi0cQWuC1GhqeT85Alv8CFJ892/Nxk3exMFsE7DUucX/NZBRTvImmfxxbiV+CPKBCSZzEz2JQno+MnKqt9zMTLzo+YLTxtTKPUMih4RPVKGBX/89IoII/bkw7MqmHA1Cx/5RvGIFhofU8uoQEE27FR88s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776934425; c=relaxed/simple;
	bh=j6vrPiqAXfTTn4gFYto4WEEc7444kmqwzKxgdUGujPE=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=q8fcPE9TkrJxt+oz21EiFQIyG2dLy1O7FpPZnJ8BPrmXOsVuw25WhO4P7gOOI7Ea6pwyRfMi0BSrxjSGKxKIVYqIVyQxx0RLJ65jNjqmnjvXnshGSt/WgMeZbThFQ7yaU4lYOsF43m44yeY5wnOxwMMf7BgNrAaL1L+UkS2p6Fk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=XgVMttBc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=62LnqvYZ; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=H/tmvy77; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=1pBEGHSo; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="XgVMttBc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="62LnqvYZ";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="H/tmvy77";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="1pBEGHSo"
Received: from imap1.dmz-prg2.suse.org (unknown [10.150.64.97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3319A6A82E;
	Thu, 23 Apr 2026 08:53:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776934422; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TOJvejf1VcTwfe/3ldjVbBxEG0SKDaXuc1LMLBdhr+U=;
	b=XgVMttBcLe3979bcQTp90ODrRJOm51q0YbdQYR0v05uohLINzBBdaVD8to5pkNiur8veQ9
	Abzpf/2IePE2XxmloyMScypKu+KcH+8v+f8eQ+isJlLEjtkcWJt2bYeJWlkBt4HVKB9Ttd
	rQ+X1IlYO3cLM39CDzB3L/32XKtri8s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776934422;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TOJvejf1VcTwfe/3ldjVbBxEG0SKDaXuc1LMLBdhr+U=;
	b=62LnqvYZshxpDdrWdKnpNnE6l7C138bpC1lYxwHQWdm5D5OLY//QBFuQ3BclP/M9KStzsn
	qzUX2N6PGmM0ldBA==
Authentication-Results: smtp-out1.suse.de;
	none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1776934421; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TOJvejf1VcTwfe/3ldjVbBxEG0SKDaXuc1LMLBdhr+U=;
	b=H/tmvy775F7UaRB0zY2j6pnJvPbF3Wd23bJSJSiRatHzHqhNAST0TmFW3KMHw844l1EuBG
	atl3q0/Mh1nP2iqchyUR8jmVc5c7j60LnHEo8hHiHnHkUtSwT4mZvaJvaD2Ycq82Tlsw5s
	5eNJubV3a+1rme5XjSBNQ22dUjTILCA=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1776934421;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=TOJvejf1VcTwfe/3ldjVbBxEG0SKDaXuc1LMLBdhr+U=;
	b=1pBEGHSoVxSNxSGdJA8sA2NxRFV302WvvLprgv+vXf7Q/4pGx9Ke9b2zRjeFENy8fMZDX1
	vILNKvmJrZ7GGRAQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 27987593A3;
	Thu, 23 Apr 2026 08:53:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id mkKmCRXe6Wl9CwAAD6G6ig
	(envelope-from <jack@suse.cz>); Thu, 23 Apr 2026 08:53:41 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id D9E4BA0A2D; Thu, 23 Apr 2026 10:53:36 +0200 (CEST)
Date: Thu, 23 Apr 2026 10:53:36 +0200
From: Jan Kara <jack@suse.cz>
To: syzbot ci <syzbot+ci74b4011640d9eba3@syzkaller.appspotmail.com>
Cc: brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	ruikai@pwno.io, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: fs: Handle multiply claimed blocks more
 gracefully with mmb
Message-ID: <gsrvbspq4pbhyqxcgpxf2aeidgvaar3d7pp5w5uxqjv7hu2kvl@7n6nen42wvac>
References: <20260422144529.20279-2-jack@suse.cz>
 <69e9c6e5.a00a0220.17a17.0038.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69e9c6e5.a00a0220.17a17.0038.GAE@google.com>
X-Spamd-Result: default: False [-2.30 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	FROM_HAS_DN(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	ARC_NA(0.00)[];
	MISSING_XM_UA(0.00)[];
	MIME_TRACE(0.00)[0:+];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	TAGGED_RCPT(0.00)[ci74b4011640d9eba3];
	RCVD_COUNT_THREE(0.00)[3];
	TO_DN_SOME(0.00)[];
	FROM_EQ_ENVFROM(0.00)[];
	RCPT_COUNT_SEVEN(0.00)[7];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_TLS_LAST(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[suse.com:email,appspotmail.com:email,imap1.dmz-prg2.suse.org:helo]
X-Spam-Flag: NO
X-Spam-Score: -2.30
X-Spam-Level: 

On Thu 23-04-26 00:14:45, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] fs: Handle multiply claimed blocks more gracefully with mmb
> https://lore.kernel.org/all/20260422144529.20279-2-jack@suse.cz
> * [PATCH] fs: Handle multiply claimed blocks more gracefully with mmb
> 
> and found the following issue:
> KASAN: slab-use-after-free Read in remove_assoc_queue
> 
> Full report is available here:
> https://ci.syzbot.org/series/3ac1baf5-8cbb-4927-a4b1-c051f76ce076

Bah, indeed the patch is broken. I'll send v2.

								Honza

> 
> ***
> 
> KASAN: slab-use-after-free Read in remove_assoc_queue
> 
> tree:      torvalds
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/torvalds/linux
> base:      6596a02b207886e9e00bb0161c7fd59fea53c081
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/00926826-2798-4f8f-873a-dc81fc60996a/config
> syz repro: https://ci.syzbot.org/findings/581a8917-90d5-4038-b419-a939f694a8c4/syz_repro
> 
> ==================================================================
> BUG: KASAN: slab-use-after-free in __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
> BUG: KASAN: slab-use-after-free in _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
> Read of size 1 at addr ffff88802341b418 by task syz-executor/5940
> 
> CPU: 1 UID: 0 PID: 5940 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  print_address_description+0x55/0x1e0 mm/kasan/report.c:378
>  print_report+0x58/0x70 mm/kasan/report.c:482
>  kasan_report+0x117/0x150 mm/kasan/report.c:595
>  __kasan_check_byte+0x2a/0x40 mm/kasan/common.c:574
>  kasan_check_byte include/linux/kasan.h:402 [inline]
>  lock_acquire+0x84/0x350 kernel/locking/lockdep.c:5842
>  __raw_spin_lock include/linux/spinlock_api_smp.h:158 [inline]
>  _raw_spin_lock+0x2e/0x40 kernel/locking/spinlock.c:158
>  spin_lock include/linux/spinlock.h:342 [inline]
>  remove_assoc_queue+0x14b/0x450 fs/buffer.c:514
>  drop_buffers+0x115/0x320 fs/buffer.c:2819
>  try_to_free_buffers+0x17d/0x300 fs/buffer.c:2873
>  block_invalidate_folio+0x5f8/0x730 fs/buffer.c:1571
>  folio_invalidate mm/truncate.c:140 [inline]
>  truncate_cleanup_folio+0xcb/0x190 mm/truncate.c:160
>  truncate_inode_pages_range+0x2ce/0xe30 mm/truncate.c:404
>  kill_bdev block/bdev.c:91 [inline]
>  blkdev_flush_mapping+0x109/0x2f0 block/bdev.c:720
>  blkdev_put_whole block/bdev.c:727 [inline]
>  bdev_release+0x417/0x650 block/bdev.c:1152
>  blkdev_release+0x15/0x20 block/fops.c:705
>  __fput+0x44f/0xa60 fs/file_table.c:510
>  fput_close_sync+0x11f/0x240 fs/file_table.c:615
>  __do_sys_close fs/open.c:1507 [inline]
>  __se_sys_close fs/open.c:1492 [inline]
>  __x64_sys_close+0x7e/0x110 fs/open.c:1492
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f44beb5d04e
> Code: 08 0f 85 a5 a8 ff ff 49 89 fb 48 89 f0 48 89 d7 48 89 ce 4c 89 c2 4d 89 ca 4c 8b 44 24 08 4c 8b 4c 24 10 4c 89 5c 24 08 0f 05 <c3> 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 80 00 00 00 00 48 83 ec 08
> RSP: 002b:00007ffd5f8fd628 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: ffffffffffffffda RBX: 000055558c3e9500 RCX: 00007f44beb5d04e
> RDX: 0000000000000000 RSI: 0000000000000000 RDI: 0000000000000003
> RBP: 00007ffd5f8fd6cc R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000002
> R13: 00000000000927c0 R14: 00000000000126bd R15: 00007ffd5f8fd720
>  </TASK>
> 
> Allocated by task 6273:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  unpoison_slab_object mm/kasan/common.c:340 [inline]
>  __kasan_slab_alloc+0x6c/0x80 mm/kasan/common.c:366
>  kasan_slab_alloc include/linux/kasan.h:253 [inline]
>  slab_post_alloc_hook mm/slub.c:4569 [inline]
>  slab_alloc_node mm/slub.c:4898 [inline]
>  kmem_cache_alloc_lru_noprof+0x2b8/0x640 mm/slub.c:4917
>  fat_alloc_inode+0x30/0xf0 fs/fat/inode.c:753
>  alloc_inode+0x6a/0x1b0 fs/inode.c:345
>  new_inode+0x22/0x170 fs/inode.c:1179
>  fat_fill_super+0x1c7c/0x3530 fs/fat/inode.c:1819
>  get_tree_bdev_flags+0x431/0x4f0 fs/super.c:1694
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1754
>  fc_mount fs/namespace.c:1193 [inline]
>  do_new_mount_fc fs/namespace.c:3758 [inline]
>  do_new_mount+0x341/0xd30 fs/namespace.c:3834
>  do_mount fs/namespace.c:4167 [inline]
>  __do_sys_mount fs/namespace.c:4383 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4360
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Freed by task 5824:
>  kasan_save_stack mm/kasan/common.c:57 [inline]
>  kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
>  kasan_save_free_info+0x46/0x50 mm/kasan/generic.c:584
>  poison_slab_object mm/kasan/common.c:253 [inline]
>  __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
>  kasan_slab_free include/linux/kasan.h:235 [inline]
>  slab_free_hook mm/slub.c:2689 [inline]
>  slab_free mm/slub.c:6246 [inline]
>  kmem_cache_free+0x182/0x650 mm/slub.c:6373
>  rcu_do_batch kernel/rcu/tree.c:2617 [inline]
>  rcu_core+0x7cd/0x1070 kernel/rcu/tree.c:2869
>  handle_softirqs+0x22a/0x840 kernel/softirq.c:622
>  do_softirq+0x76/0xd0 kernel/softirq.c:523
>  __local_bh_enable_ip+0xf8/0x130 kernel/softirq.c:450
>  local_bh_enable include/linux/bottom_half.h:33 [inline]
>  __alloc_skb+0x1aa/0x7d0 net/core/skbuff.c:697
>  alloc_skb include/linux/skbuff.h:1383 [inline]
>  __tcp_send_ack+0xae/0x4f0 net/ipv4/tcp_output.c:4470
>  tcp_cleanup_rbuf net/ipv4/tcp.c:1615 [inline]
>  tcp_recvmsg_locked+0x2dfa/0x3720 net/ipv4/tcp.c:2919
>  tcp_recvmsg+0x205/0x7e0 net/ipv4/tcp.c:2948
>  sock_recvmsg_nosec net/socket.c:1137 [inline]
>  sock_recvmsg+0xfa/0x1b0 net/socket.c:1159
>  sock_read_iter+0x251/0x320 net/socket.c:1229
>  new_sync_read fs/read_write.c:493 [inline]
>  vfs_read+0x582/0xa70 fs/read_write.c:574
>  ksys_read+0x150/0x270 fs/read_write.c:717
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Last potentially related work creation:
>  kasan_save_stack+0x3e/0x60 mm/kasan/common.c:57
>  kasan_record_aux_stack+0xbd/0xd0 mm/kasan/generic.c:556
>  __call_rcu_common kernel/rcu/tree.c:3131 [inline]
>  call_rcu+0xee/0x890 kernel/rcu/tree.c:3251
>  destroy_inode fs/inode.c:399 [inline]
>  evict+0x95b/0xb10 fs/inode.c:865
>  dispose_list fs/inode.c:883 [inline]
>  evict_inodes+0x75a/0x7f0 fs/inode.c:937
>  generic_shutdown_super+0xaa/0x2d0 fs/super.c:632
>  kill_block_super+0x44/0x90 fs/super.c:1725
>  deactivate_locked_super+0xbc/0x130 fs/super.c:476
>  cleanup_mnt+0x437/0x4d0 fs/namespace.c:1312
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
>  __exit_to_user_mode_loop kernel/entry/common.c:67 [inline]
>  exit_to_user_mode_loop+0xed/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> The buggy address belongs to the object at ffff88802341b2c0
>  which belongs to the cache fat_inode_cache of size 1496
> The buggy address is located 344 bytes inside of
>  freed 1496-byte region [ffff88802341b2c0, ffff88802341b898)
> 
> The buggy address belongs to the physical page:
> page: refcount:0 mapcount:0 mapping:0000000000000000 index:0xffff888023419960 pfn:0x23418
> head: order:3 mapcount:0 entire_mapcount:0 nr_pages_mapped:0 pincount:0
> memcg:ffff88802341fee1
> flags: 0xfff00000000240(workingset|head|node=0|zone=1|lastcpupid=0x7ff)
> page_type: f5(slab)
> raw: 00fff00000000240 ffff8881036e9780 ffffea000483a410 ffff8881052864c8
> raw: ffff888023419960 0000000800140012 00000000f5000000 ffff88802341fee1
> head: 00fff00000000240 ffff8881036e9780 ffffea000483a410 ffff8881052864c8
> head: ffff888023419960 0000000800140012 00000000f5000000 ffff88802341fee1
> head: 00fff00000000003 fffffffffffffe01 00000000ffffffff 00000000ffffffff
> head: ffffffffffffffff 0000000000000000 00000000ffffffff 0000000000000008
> page dumped because: kasan: bad access detected
> page_owner tracks the page as allocated
> page last allocated via order 3, migratetype Reclaimable, gfp_mask 0xd2050(__GFP_RECLAIMABLE|__GFP_IO|__GFP_NOWARN|__GFP_NORETRY|__GFP_COMP|__GFP_NOMEMALLOC), pid 6047, tgid 6046 (syz.1.52), ts 71569692880, free_ts 67561500883
>  set_page_owner include/linux/page_owner.h:32 [inline]
>  post_alloc_hook+0x231/0x280 mm/page_alloc.c:1858
>  prep_new_page mm/page_alloc.c:1866 [inline]
>  get_page_from_freelist+0x24ba/0x2540 mm/page_alloc.c:3946
>  __alloc_frozen_pages_noprof+0x18d/0x380 mm/page_alloc.c:5226
>  alloc_slab_page mm/slub.c:3278 [inline]
>  allocate_slab+0x77/0x660 mm/slub.c:3467
>  new_slab mm/slub.c:3525 [inline]
>  refill_objects+0x339/0x3d0 mm/slub.c:7251
>  refill_sheaf mm/slub.c:2816 [inline]
>  __pcs_replace_empty_main+0x321/0x720 mm/slub.c:4651
>  alloc_from_pcs mm/slub.c:4749 [inline]
>  slab_alloc_node mm/slub.c:4883 [inline]
>  kmem_cache_alloc_lru_noprof+0x37c/0x640 mm/slub.c:4917
>  fat_alloc_inode+0x30/0xf0 fs/fat/inode.c:753
>  alloc_inode+0x6a/0x1b0 fs/inode.c:345
>  new_inode+0x22/0x170 fs/inode.c:1179
>  fat_fill_super+0x1bbc/0x3530 fs/fat/inode.c:1807
>  get_tree_bdev_flags+0x431/0x4f0 fs/super.c:1694
>  vfs_get_tree+0x92/0x2a0 fs/super.c:1754
>  fc_mount fs/namespace.c:1193 [inline]
>  do_new_mount_fc fs/namespace.c:3758 [inline]
>  do_new_mount+0x341/0xd30 fs/namespace.c:3834
>  do_mount fs/namespace.c:4167 [inline]
>  __do_sys_mount fs/namespace.c:4383 [inline]
>  __se_sys_mount+0x31d/0x420 fs/namespace.c:4360
>  do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
>  do_syscall_64+0x15f/0xf80 arch/x86/entry/syscall_64.c:94
> page last free pid 5878 tgid 5878 stack trace:
>  reset_page_owner include/linux/page_owner.h:25 [inline]
>  __free_pages_prepare mm/page_alloc.c:1402 [inline]
>  __free_frozen_pages+0xbc7/0xd30 mm/page_alloc.c:2943
>  vfree+0x1d1/0x2f0 mm/vmalloc.c:3472
>  kcov_put kernel/kcov.c:442 [inline]
>  kcov_close+0x28/0x50 kernel/kcov.c:543
>  __fput+0x44f/0xa60 fs/file_table.c:510
>  task_work_run+0x1d9/0x270 kernel/task_work.c:233
>  exit_task_work include/linux/task_work.h:40 [inline]
>  do_exit+0x70f/0x22c0 kernel/exit.c:975
>  do_group_exit+0x21b/0x2d0 kernel/exit.c:1117
>  get_signal+0x1284/0x1330 kernel/signal.c:3037
>  arch_do_signal_or_restart+0xbc/0x830 arch/x86/kernel/signal.c:337
>  __exit_to_user_mode_loop kernel/entry/common.c:64 [inline]
>  exit_to_user_mode_loop+0x86/0x480 kernel/entry/common.c:98
>  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:207 [inline]
>  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:238 [inline]
>  syscall_exit_to_user_mode include/linux/entry-common.h:318 [inline]
>  do_syscall_64+0x33e/0xf80 arch/x86/entry/syscall_64.c:100
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> 
> Memory state around the buggy address:
>  ffff88802341b300: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88802341b380: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> >ffff88802341b400: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>                             ^
>  ffff88802341b480: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
>  ffff88802341b500: fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb fb
> ==================================================================
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
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
