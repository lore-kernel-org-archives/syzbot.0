Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=195.135.223.130
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793103067;
	b=4RKZAa9eM+Ta/KMDljEqQcyiGTx727r1jJVimwMn7ix8R7qMepNHNc7APgi5D47Tbuc/
	 +92NTnUYjKrGeHzb1+vH6m/tTxdm9M2BRepG6mvbwstONVm1Z/6MSmmASwGADS7PfhxDL
	 p8+2ObYREcYkDDKwdyhYAOBoMpjTep9QoTws9QyxzdwDNSEWZfRdaDpEtV6M7R4T3A1G6
	 m0mBgKSenr3r4RzBGKV+4cuTXLqr4bJNpVomUUFRy8PFRXpliSDOnrfEcAHtM9v5FpnEg
	 z0dx2S9xCMiD2oSp2EMvsaGTU7WEbL2rgMVB9KEcBn9j0+SRIRV7mcoRGYH5wOH2iow==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793103067;
	h=DMARC-Filter:Received:DKIM-Signature:DKIM-Signature:DKIM-Signature:
	 DKIM-Signature:Received:Received:Received:Date:From:To:Cc:Subject:
	 Message-ID:References:MIME-Version:Content-Type:Content-Disposition:
	 In-Reply-To:X-Spamd-Result:X-Rspamd-Server:X-Rspamd-Action:
	 X-Spam-Flag:X-Spam-Score:X-Spam-Level:X-Rspamd-Queue-Id;
	bh=XznsgLDjFSR6eAolWkSTsLnOGYm9+TyIBe9D9fq63DM=;
	b=AwHwVKBkoSkpPtF1uoy9/hnQEIu1WNNxeQJGOdLxA897SbNz/wZX8Ih3wtR1uNuP4bgy
	 E/35DoUe96oJZtMfsWr+g3T68UeMfw/uoSlUZ17QHO5HnferPQTj3YwwR5IrGox82O+m5
	 h4PYIep/i0rIag7tXbCKC2MZ2KYYZKHdDvlJQo8K8ubAakhTzUu/x4J3RMPUIg/P6KCQj
	 yW7QUDAS027kFpLvceuqU5mwVhjZDZAiF+Z5DYSAgUi326I2qErURyfdQHA4JCdVZppMv
	 wzcQGLuV5dSlnvfddmRp8WOWIFv+8NhJWZC7VTATDxH0h0BTg32amRDc7wrfV7l2fvA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=none header.from=suse.cz;
	spf=pass smtp.mailfrom=suse.cz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=W6zLWMoA;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MuoTuAcz;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Lt+v6ic4;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=FbTQ9dH5;
	arc=none smtp.remote-ip=195.135.223.130
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039DE606A31B
	for <syzbot@lists.linux.dev>; Tue, 27 Oct 2026 12:11:05 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 039DE606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=W6zLWMoA;
	dkim=pass header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=MuoTuAcz;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.a=rsa-sha256 header.s=susede2_rsa header.b=Lt+v6ic4;
	dkim=neutral header.d=suse.cz header.i=@suse.cz header.a=ed25519-sha256 header.s=susede2_ed25519 header.b=FbTQ9dH5
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id D8AB721F2C;
	Tue, 27 Oct 2026 12:11:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793103064; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XznsgLDjFSR6eAolWkSTsLnOGYm9+TyIBe9D9fq63DM=;
	b=W6zLWMoAEplR4Acu74hUvXja+KmI2LEknv6SpA69wQijymtcJKYfHwran7ZrEOd+Ts7Ey/
	0YXZgoRhrhkGRrnfZruineuIleyzAkS6Z4Xov6jV2fQYC+FEZLdpOZh+e40OT8ON5dNl6x
	BbLn1rqmFesNIcov1vyVK7dV0bxh1/0=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793103064;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XznsgLDjFSR6eAolWkSTsLnOGYm9+TyIBe9D9fq63DM=;
	b=MuoTuAczo3oI9iikklsH6O9/r+c1MtAxnyYZh7UUETAhImg8NYAmwsx6BInIN4+BrnUcU+
	tHZJQQEKjc0kwsCA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=Lt+v6ic4;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=FbTQ9dH5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1793103063; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XznsgLDjFSR6eAolWkSTsLnOGYm9+TyIBe9D9fq63DM=;
	b=Lt+v6ic4uLpd2ZNjj8+8EftNk2WQzOOlMcl4zb6vD4O8Nimz4OVT3xhMlP6mHqKFCRzSo5
	t1pu+TUzuZU8zYm0IrThqN5zpuOosugiVrUA6HfHSvuyBEIGzAmG6NpIU13lFc0WQ1Rvbn
	zbbSLKFULLnN7UDB4WIA/gMIzA0jO1o=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1793103063;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=XznsgLDjFSR6eAolWkSTsLnOGYm9+TyIBe9D9fq63DM=;
	b=FbTQ9dH5z6buh3kxUyhfUb67xfk++ERPJ41pNYtLIxgyQnJg5tCzNSNkSWmsKbTWmaTDDq
	01XVXY1HY5Gp39CQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id AC1BF1321C;
	Tue, 27 Oct 2026 12:11:03 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lpJ/IdeU4Gq7eAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 27 Oct 2026 12:11:03 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id 280CBA133E; Tue, 27 Oct 2026 13:10:55 +0100 (CET)
Date: Tue, 27 Oct 2026 13:10:55 +0100
From: Jan Kara <jack@suse.cz>
To: syzbot ci <syzbot+ci5d1c09e093f34f60@syzkaller.appspotmail.com>
Cc: aurelien.desbrieres@gmail.com, aurelien@hackers.camp, 
	brauner@kernel.org, jack@suse.cz, linux-fsdevel@vger.kernel.org, 
	linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk, willy@infradead.org, 
	syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: buffer: warn when a buffer is attached to a
 second mmb
Message-ID: <a7h6k7ecnmnj426ss45fqdk2kjodrjurjpwhcwao2bjkw7tqtl@qghx3vrx5ber>
References: <20261026213626.301480-1-aurelien@hackers.camp>
 <6ae064e5.768774f5.3237ab.0015.GAE@google.com>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6ae064e5.768774f5.3237ab.0015.GAE@google.com>
X-Spamd-Result: default: False [-11.51 / 50.00];
	SUSE_INTERNAL_BYPASS(-9.00)[];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[gmail.com];
	RCVD_COUNT_THREE(0.00)[3];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	FREEMAIL_CC(0.00)[gmail.com,hackers.camp,kernel.org,suse.cz,vger.kernel.org,zeniv.linux.org.uk,infradead.org,lists.linux.dev,googlegroups.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DNSWL_BLOCKED(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[11];
	TAGGED_RCPT(0.00)[ci5d1c09e093f34f60];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	DBL_BLOCKED_OPENRESOLVER(0.00)[linux.dev:email,suse.com:email,appspotmail.com:email,imap1.dmz-prg2.suse.org:rdns,imap1.dmz-prg2.suse.org:helo,suse.cz:dkim,googlegroups.com:email]
X-Rspamd-Server: rspamd1.dmz-prg2.suse.org
X-Rspamd-Action: no action
X-Spam-Flag: NO
X-Spam-Score: -11.51
X-Spam-Level: 
X-Rspamd-Queue-Id: D8AB721F2C

On Tue 27-10-26 01:46:29, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] buffer: warn when a buffer is attached to a second mmb
> https://lore.kernel.org/all/20261026213626.301480-1-aurelien@hackers.camp
> * [PATCH] buffer: warn when a buffer is attached to a second mmb
> 
> and found the following issues:
> * WARNING in __ext4_handle_dirty_metadata
> * WARNING in fat_add_entries
> * WARNING in fat_alloc_new_dir
> * WARNING in fat_remove_entries

Woohoo, great that we have added this. So now we have some filesystem bugs
to analyze ;). At least in ext4 case this is a real bug as xattr blocks can
be indeed shared among inodes. The right fix there is to just not track
xattr blocks with mmb and instead handle the flushing in
ext4_sync_inode_metadata().

I'm not sure about the FAT cases because directory blocks where this
triggers should better belong to a single directory. So it could be some
race with freeing & reallocating blocks. Needs more digging.

								Honza

> 
> Full report is available here:
> https://ci.syzbot.org/series/2d872051-106e-44e2-912e-9f5ffc88fe5f
> 
> ***
> 
> WARNING in __ext4_handle_dirty_metadata
> 
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> base:      2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/0103f224-dbc7-46e0-b595-6b58abedf2a1/config
> syz repro: https://ci.syzbot.org/findings/e505c7df-1483-4020-9400-461d434eaf84/syz_repro
> 
> ------------[ cut here ]------------
> cur && cur != mmb
> WARNING: fs/buffer.c:639 at mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639, CPU#1: syz.2.20/5867
> Modules linked in:
> CPU: 1 UID: 0 PID: 5867 Comm: syz.2.20 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639
> Code: af d7 ff 4d 89 65 00 eb 05 e8 42 c7 66 ff 4c 89 ff 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 0c d6 8a 09 e8 27 c7 66 ff 90 <0f> 0b 90 e9 39 fe ff ff 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
> RSP: 0018:ffffc900030bf238 EFLAGS: 00010293
> RAX: ffffffff82615d19 RBX: ffff8881bd1af460 RCX: ffff88816f9a9e00
> RDX: 0000000000000000 RSI: ffff888165b29280 RDI: ffff8881bd1af460
> RBP: dffffc0000000000 R08: ffff8881bd1af467 R09: 1ffff11037a35e8c
> R10: dffffc0000000000 R11: ffffed1037a35e8d R12: ffff8881bd1af4b0
> R13: ffff8881bd347348 R14: ffff888165b29280 R15: 1ffff11037a35e96
> FS:  00007fa2891f26c0(0000) GS:ffff8882a7cbb000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007f2e2cbf40e8 CR3: 000000016e66c000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  __ext4_handle_dirty_metadata+0x2f5/0xa00 fs/ext4/ext4_jbd2.c:418
>  ext4_xattr_block_set+0x24dd/0x29a0 fs/ext4/xattr.c:2107
>  ext4_xattr_set_handle+0xed9/0x15f0 fs/ext4/xattr.c:2461
>  ext4_xattr_set+0x257/0x340 fs/ext4/xattr.c:2563
>  __vfs_setxattr+0x442/0x480 fs/xattr.c:223
>  __vfs_setxattr_noperm+0x12a/0x660 fs/xattr.c:257
>  vfs_setxattr+0x163/0x360 fs/xattr.c:344
>  ovl_do_setxattr fs/overlayfs/overlayfs.h:328 [inline]
>  ovl_setxattr fs/overlayfs/overlayfs.h:340 [inline]
>  ovl_check_setxattr+0x15a/0x320 fs/overlayfs/util.c:898
>  ovl_set_opaque_xerr fs/overlayfs/dir.c:276 [inline]
>  ovl_set_opaque fs/overlayfs/dir.c:290 [inline]
>  ovl_create_upper fs/overlayfs/dir.c:383 [inline]
>  ovl_create_handle_whiteouts+0xb9c/0x13d0 fs/overlayfs/dir.c:643
>  ovl_create_or_link+0x14d/0x270 fs/overlayfs/dir.c:685
>  ovl_create_object+0x29d/0x3b0 fs/overlayfs/dir.c:722
>  ovl_mkdir+0x34/0x50 fs/overlayfs/dir.c:742
>  vfs_mkdir+0x40c/0x620 fs/namei.c:5420
>  filename_mkdirat+0x285/0x510 fs/namei.c:5453
>  __do_sys_mkdirat fs/namei.c:5474 [inline]
>  __se_sys_mkdirat+0x35/0x150 fs/namei.c:5471
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fa28839f559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fa2891f2028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
> RAX: ffffffffffffffda RBX: 00007fa288626090 RCX: 00007fa28839f559
> RDX: 00000000000001c0 RSI: 0000200000000400 RDI: ffffffffffffff9c
> RBP: 00007fa288436b20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fa288626128 R14: 00007fa288626090 R15: 00007ffd68374848
>  </TASK>
> 
> 
> ***
> 
> WARNING in fat_add_entries
> 
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> base:      2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/0103f224-dbc7-46e0-b595-6b58abedf2a1/config
> syz repro: https://ci.syzbot.org/findings/39f0a1b2-b9af-4d73-a1fc-ce1cd04779b5/syz_repro
> 
> FAT-fs (loop2): Invalid FSINFO signature: 0x41615252, 0x80417272 (sector = 1)
> ------------[ cut here ]------------
> cur && cur != mmb
> WARNING: fs/buffer.c:639 at mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639, CPU#0: syz.2.19/5813
> Modules linked in:
> CPU: 0 UID: 0 PID: 5813 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639
> Code: af d7 ff 4d 89 65 00 eb 05 e8 42 c7 66 ff 4c 89 ff 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 0c d6 8a 09 e8 27 c7 66 ff 90 <0f> 0b 90 e9 39 fe ff ff 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
> RSP: 0018:ffffc9000404f660 EFLAGS: 00010293
> RAX: ffffffff82615d19 RBX: ffff88811c3c0a80 RCX: ffff888113c71e00
> RDX: 0000000000000000 RSI: ffff88811bd3b3b8 RDI: ffff88811c3c0a80
> RBP: dffffc0000000000 R08: ffffffff0000ffff R09: ffffffffffffffff
> R10: 0000fc000f003000 R11: 65006c0069006641 R12: ffff88811c3c0ad0
> R13: dffffc0000000000 R14: ffff88811bd3b3b8 R15: 1ffff1102387815a
> FS:  00007f0b764146c0(0000) GS:ffff88818c4bb000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 000000010ebc0000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  fat_add_entries+0xc9a/0x2320 fs/fat/dir.c:1410
>  vfat_add_entry+0x2dd3/0x3570 fs/fat/namei_vfat.c:675
>  vfat_mkdir+0x16c/0x300 fs/fat/namei_vfat.c:866
>  vfs_mkdir+0x40c/0x620 fs/namei.c:5420
>  filename_mkdirat+0x285/0x510 fs/namei.c:5453
>  __do_sys_mkdirat fs/namei.c:5474 [inline]
>  __se_sys_mkdirat+0x35/0x150 fs/namei.c:5471
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7f0b7559e3c7
> Code: 00 66 90 48 89 f2 b9 00 01 00 00 48 89 fe bf 9c ff ff ff e9 db f7 ff ff 66 2e 0f 1f 84 00 00 00 00 00 90 b8 02 01 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007f0b76413e58 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
> RAX: ffffffffffffffda RBX: 00007f0b76413ee0 RCX: 00007f0b7559e3c7
> RDX: 00000000000001ff RSI: 00002000000000c0 RDI: 00000000ffffff9c
> RBP: 0000000000000000 R08: 0000200000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 00002000000000c0
> R13: 00007f0b76413ea0 R14: 0000000000000000 R15: 0000000000000000
>  </TASK>
> 
> 
> ***
> 
> WARNING in fat_alloc_new_dir
> 
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> base:      2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/0103f224-dbc7-46e0-b595-6b58abedf2a1/config
> syz repro: https://ci.syzbot.org/findings/ac218fc3-8274-46ed-ad15-c9645108042b/syz_repro
> 
> FAT-fs (loop2): utf8 is not a recommended IO charset for FAT filesystems, filesystem will be case sensitive!
> FAT-fs (loop2): Invalid FSINFO signature: 0x41615252, 0x80417272 (sector = 1)
> ------------[ cut here ]------------
> cur && cur != mmb
> WARNING: fs/buffer.c:639 at mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639, CPU#0: syz.2.19/5804
> Modules linked in:
> CPU: 0 UID: 0 PID: 5804 Comm: syz.2.19 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639
> Code: af d7 ff 4d 89 65 00 eb 05 e8 42 c7 66 ff 4c 89 ff 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 0c d6 8a 09 e8 27 c7 66 ff 90 <0f> 0b 90 e9 39 fe ff ff 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
> RSP: 0018:ffffc900037bfac0 EFLAGS: 00010293
> RAX: ffffffff82615d19 RBX: ffff888022008000 RCX: ffff888113ad3c00
> RDX: 0000000000000000 RSI: ffff8880222733b8 RDI: ffff888022008000
> RBP: dffffc0000000000 R08: ffff888022008007 R09: 1ffff11004401000
> R10: dffffc0000000000 R11: ffffed1004401001 R12: ffff888022008050
> R13: f8f8f8f8f1f1f1f1 R14: ffff8880222733b8 R15: 1ffff1100440100a
> FS:  00007fde7c2926c0(0000) GS:ffff88818c4bb000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 0000000000000000 CR3: 0000000022c3e000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  fat_alloc_new_dir+0x7c5/0xb90 fs/fat/dir.c:1223
>  vfat_mkdir+0x13a/0x300 fs/fat/namei_vfat.c:861
>  vfs_mkdir+0x40c/0x620 fs/namei.c:5420
>  filename_mkdirat+0x285/0x510 fs/namei.c:5453
>  __do_sys_mkdirat fs/namei.c:5474 [inline]
>  __se_sys_mkdirat+0x35/0x150 fs/namei.c:5471
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fde7b39f559
> Code: ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48
> RSP: 002b:00007fde7c292028 EFLAGS: 00000246 ORIG_RAX: 0000000000000102
> RAX: ffffffffffffffda RBX: 00007fde7b625fa0 RCX: 00007fde7b39f559
> RDX: 0000000000000040 RSI: 0000200000000100 RDI: ffffffffffffff9c
> RBP: 00007fde7b436b20 R08: 0000000000000000 R09: 0000000000000000
> R10: 0000000000000000 R11: 0000000000000246 R12: 0000000000000000
> R13: 00007fde7b626038 R14: 00007fde7b625fa0 R15: 00007ffee0058de8
>  </TASK>
> 
> 
> ***
> 
> WARNING in fat_remove_entries
> 
> tree:      linux-next
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/next/linux-next
> base:      2c3ba1f1cb416b81d617b92a24a4bcaa48d574e3
> arch:      amd64
> compiler:  Debian clang version 22.1.8 (1~deb13u4), Debian LLD 22.1.8
> config:    https://ci.syzbot.org/builds/0103f224-dbc7-46e0-b595-6b58abedf2a1/config
> syz repro: https://ci.syzbot.org/findings/09b74141-73df-447f-b681-310eb6bbab31/syz_repro
> 
> ------------[ cut here ]------------
> cur && cur != mmb
> WARNING: fs/buffer.c:639 at mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639, CPU#0: syz-executor/5735
> Modules linked in:
> CPU: 0 UID: 0 PID: 5735 Comm: syz-executor Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> RIP: 0010:mmb_mark_buffer_dirty+0x21a/0x230 fs/buffer.c:639
> Code: af d7 ff 4d 89 65 00 eb 05 e8 42 c7 66 ff 4c 89 ff 48 83 c4 08 5b 41 5c 41 5d 41 5e 41 5f 5d e9 0c d6 8a 09 e8 27 c7 66 ff 90 <0f> 0b 90 e9 39 fe ff ff 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00
> RSP: 0018:ffffc9000385fb98 EFLAGS: 00010293
> RAX: ffffffff82615d19 RBX: ffff8881130f0ee0 RCX: ffff888177e8bc00
> RDX: 0000000000000000 RSI: ffff8881188ead68 RDI: ffff8881130f0ee0
> RBP: dffffc0000000000 R08: ffffffff917a837f R09: 1ffffffff22f506f
> R10: dffffc0000000000 R11: fffffbfff22f5070 R12: ffff8881130f0f30
> R13: ffff8881188ead01 R14: ffff8881188ead68 R15: 1ffff1102261e1e6
> FS:  0000555564cc8500(0000) GS:ffff88818c4bb000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00007fff31a07d40 CR3: 00000001768a8000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  fat_remove_entries+0x196/0x470 fs/fat/dir.c:1090
>  vfat_unlink+0x283/0x330 fs/fat/namei_vfat.c:836
>  vfs_unlink+0x27b/0x6d0 fs/namei.c:5659
>  filename_unlinkat+0x3cd/0x610 fs/namei.c:5729
>  __do_sys_unlink fs/namei.c:5764 [inline]
>  __se_sys_unlink+0x2e/0x140 fs/namei.c:5761
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
> RIP: 0033:0x7fb725d9e647
> Code: 73 01 c3 48 c7 c1 e8 ff ff ff f7 d8 64 89 01 48 83 c8 ff c3 66 2e 0f 1f 84 00 00 00 00 00 0f 1f 44 00 00 b8 57 00 00 00 0f 05 <48> 3d 00 f0 ff ff 77 01 c3 48 c7 c2 e8 ff ff ff f7 d8 64 89 02 b8
> RSP: 002b:00007fff31a08398 EFLAGS: 00000206 ORIG_RAX: 0000000000000057
> RAX: ffffffffffffffda RBX: 0000000000000000 RCX: 00007fb725d9e647
> RDX: 00007fff31a083c0 RSI: 00007fff31a08450 RDI: 00007fff31a08450
> RBP: 00007fff31a08450 R08: 00007fff31a09450 R09: 00000000ffffffff
> R10: 0000000000000100 R11: 0000000000000206 R12: 00007fff31a09540
> R13: 00007fb725e35f63 R14: 00000000000114de R15: 00007fff31a0b700
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
> To test a fix for this bug, please reply with `#syz test`
> (on a separate line) and attach the patch to the email.
> 
> Notes:
> - The patch will be applied on top of the tested series (as an
>   incremental fix).
> - To test a new version of the whole series, please send it directly
>   to syzbot@lists.linux.dev.
> - Arguments like custom git repos and branches are not supported.
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
