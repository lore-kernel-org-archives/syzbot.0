Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.223.130])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7507366800
	for <syzbot@lists.linux.dev>; Tue, 24 Mar 2026 08:19:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=195.135.223.130
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774340358; cv=none; b=XRoqMaP9C0+G2ChhupTk4oQL7cSTuJtWD14kSiITOnzuPj/fy2epUxOqDCAzzuE/E5si+zNgE/xSJwkEdstwh/mFquOf2kAmA+OCskQIdjTwK5+0iIBy/hR95jfc0bMgMKWp/2YnsHC/jgxBtRgOm8bjeFh0SrwwSAt48yDqm/I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774340358; c=relaxed/simple;
	bh=8s9dOtxfp6EiTXdvxNydeIvZVuevvXdCvYtr9QsirY0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=uQRaaf0UnRyebLZy5TGr+47gljJHbRyh+1VsmBF9KOWptThPhe8UNP1tYq+hxiiXcciVpo0Wlu0oQVDV7iGlR4Ttcy5M4Lt5x02pYAM2taLPNAJMNLs1kIYsOEyvMdoYYxxIqHAzu//9LLFG8FrEj5/IKPpstwCPuW4Uf/sRUGU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz; spf=pass smtp.mailfrom=suse.cz; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=FYPfKRmV; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=BUqUOoHO; dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b=0alcf4kc; dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b=c6c7u0Gf; arc=none smtp.client-ip=195.135.223.130
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=suse.cz
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=suse.cz
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="FYPfKRmV";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="BUqUOoHO";
	dkim=pass (1024-bit key) header.d=suse.cz header.i=@suse.cz header.b="0alcf4kc";
	dkim=permerror (0-bit key) header.d=suse.cz header.i=@suse.cz header.b="c6c7u0Gf"
Received: from imap1.dmz-prg2.suse.org (imap1.dmz-prg2.suse.org [IPv6:2a07:de40:b281:104:10:150:64:97])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by smtp-out1.suse.de (Postfix) with ESMTPS id 3CF6C4D1C4;
	Tue, 24 Mar 2026 08:19:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774340349; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0v24mcFE85qpxQPbThZCDF5Q7VhydgOrbXZl2rGPaF0=;
	b=FYPfKRmVskJAoE3WXj2gQJhX7mfeQt4h0vLq5cExVIPaggZWrzsSxeLdrISOjgNBGvPsgk
	W8a6Avp2ZFT5BpNlf+/k8Xc201HU+kG205ZWZ42JWaC+Lbi/N5kp4rKfQ4tY3ac52ch93y
	SO5uaG/5pdOGnSRXn5RVk0smOSNPjSs=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774340349;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0v24mcFE85qpxQPbThZCDF5Q7VhydgOrbXZl2rGPaF0=;
	b=BUqUOoHO3TrGxAalTQJlIg7fczQ2pO7JcXd1SVmygbsTpvgmxm4jLTsag7eGytWebm2YsU
	gpbjhqBvDWst4KAA==
Authentication-Results: smtp-out1.suse.de;
	dkim=pass header.d=suse.cz header.s=susede2_rsa header.b=0alcf4kc;
	dkim=pass header.d=suse.cz header.s=susede2_ed25519 header.b=c6c7u0Gf
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
	t=1774340348; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0v24mcFE85qpxQPbThZCDF5Q7VhydgOrbXZl2rGPaF0=;
	b=0alcf4kcauIMGNMtht5o3fHbVbQ8dtGsaXRSYqOylRdRRnBBTuhMhImrHsG7pErQeO7/8j
	F0nToIjKFHcpDFFUPdXQBuCyIMspMVWc0hfmChHGqAT5FcIscbysPb2qo5wceAwnFlVjOs
	uUl3Fcg1zsQGw7N1vlggkeEAnk2q540=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
	s=susede2_ed25519; t=1774340348;
	h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
	 mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=0v24mcFE85qpxQPbThZCDF5Q7VhydgOrbXZl2rGPaF0=;
	b=c6c7u0GfZwkqj3ph1XDJYtNgdXmf8/bBrR+vsVN2AwVFG0l93oG+sfI7BsOySO4df+a9bs
	yQOJ/BJRssGFi/AQ==
Received: from imap1.dmz-prg2.suse.org (localhost [127.0.0.1])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (4096 bits) server-digest SHA256)
	(No client certificate requested)
	by imap1.dmz-prg2.suse.org (Postfix) with ESMTPS id 2693E43D38;
	Tue, 24 Mar 2026 08:19:08 +0000 (UTC)
Received: from dovecot-director2.suse.de ([2a07:de40:b281:106:10:150:64:167])
	by imap1.dmz-prg2.suse.org with ESMTPSA
	id lKBkCfxIwmk4WAAAD6G6ig
	(envelope-from <jack@suse.cz>); Tue, 24 Mar 2026 08:19:08 +0000
Received: by quack3.suse.cz (Postfix, from userid 1000)
	id CEF78A0B32; Tue, 24 Mar 2026 09:18:59 +0100 (CET)
Date: Tue, 24 Mar 2026 09:18:59 +0100
From: Jan Kara <jack@suse.cz>
To: syzbot ci <syzbot+cie6df483244df2ff5@syzkaller.appspotmail.com>
Cc: jack@suse.cz, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, 
	luckd0g@163.com, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
Subject: Re: [syzbot ci] Re: udf: Fix race between file type conversion and
 writeback
Message-ID: <vurapuxxb2hn3j2ic4giupyktbo43xb6e6kbfekegxw7fxulxr@7ffmoq22lk5e>
References: <20260323162617.2421-1-jack@suse.cz>
 <69c1c09b.a70a0220.59f55.0001.GAE@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <69c1c09b.a70a0220.59f55.0001.GAE@google.com>
X-Rspamd-Action: no action
X-Rspamd-Server: rspamd2.dmz-prg2.suse.org
X-Spamd-Result: default: False [-2.51 / 50.00];
	BAYES_HAM(-3.00)[100.00%];
	SUSPICIOUS_RECIPS(1.50)[];
	NEURAL_HAM_LONG(-1.00)[-1.000];
	MID_RHS_NOT_FQDN(0.50)[];
	R_DKIM_ALLOW(-0.20)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	NEURAL_HAM_SHORT(-0.20)[-1.000];
	MIME_GOOD(-0.10)[text/plain];
	MX_GOOD(-0.01)[];
	DKIM_SIGNED(0.00)[suse.cz:s=susede2_rsa,suse.cz:s=susede2_ed25519];
	RCVD_COUNT_THREE(0.00)[3];
	URIBL_BLOCKED(0.00)[suse.cz:dkim,appspotmail.com:email,suse.com:email,imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,googlegroups.com:email];
	RBL_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	TO_DN_SOME(0.00)[];
	FUZZY_RATELIMITED(0.00)[rspamd.com];
	MIME_TRACE(0.00)[0:+];
	ARC_NA(0.00)[];
	RCVD_TLS_LAST(0.00)[];
	FREEMAIL_ENVRCPT(0.00)[163.com];
	SPAMHAUS_XBL(0.00)[2a07:de40:b281:104:10:150:64:97:from];
	RCPT_COUNT_SEVEN(0.00)[7];
	RECEIVED_SPAMHAUS_BLOCKED_OPENRESOLVER(0.00)[2a07:de40:b281:106:10:150:64:167:received];
	FROM_EQ_ENVFROM(0.00)[];
	FROM_HAS_DN(0.00)[];
	TO_MATCH_ENVRCPT_ALL(0.00)[];
	TAGGED_RCPT(0.00)[cie6df483244df2ff5];
	MISSING_XM_UA(0.00)[];
	RCVD_VIA_SMTP_AUTH(0.00)[];
	FREEMAIL_CC(0.00)[suse.cz,vger.kernel.org,kvack.org,163.com,lists.linux.dev,googlegroups.com];
	DKIM_TRACE(0.00)[suse.cz:+];
	DBL_BLOCKED_OPENRESOLVER(0.00)[imap1.dmz-prg2.suse.org:helo,imap1.dmz-prg2.suse.org:rdns,suse.com:email,suse.cz:dkim,appspotmail.com:email]
X-Rspamd-Queue-Id: 3CF6C4D1C4
X-Spam-Flag: NO
X-Spam-Score: -2.51
X-Spam-Level: 

On Mon 23-03-26 15:37:15, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] udf: Fix race between file type conversion and writeback
> https://lore.kernel.org/all/20260323162617.2421-1-jack@suse.cz
> * [PATCH 1/2] writeback: Export folio_prepare_writeback()
> * [PATCH 2/2] udf: Fix race between file type conversion and writeback
> 
> and found the following issue:
> general protection fault in folio_prepare_writeback
> 
> Full report is available here:
> https://ci.syzbot.org/series/03e405d8-f247-471a-8469-f544c8393300

Bah, stupid me. The result of filemap_lock_folio() must be checked with
IS_ERR(), not against NULL. Will send v2.

								Honza

> 
> ***
> 
> general protection fault in folio_prepare_writeback
> 
> tree:      mm-new
> URL:       https://kernel.googlesource.com/pub/scm/linux/kernel/git/akpm/mm.git
> base:      af5802cff33fe3c557dff87cd3897d14241a7c6d
> arch:      amd64
> compiler:  Debian clang version 21.1.8 (++20251221033036+2078da43e25a-1~exp1~20251221153213.50), Debian LLD 21.1.8
> config:    https://ci.syzbot.org/builds/d1944db2-4f63-4e26-b642-d71f55382c9d/config
> C repro:   https://ci.syzbot.org/findings/87b82667-f800-480e-b52a-38decce9e6c4/c_repro
> syz repro: https://ci.syzbot.org/findings/87b82667-f800-480e-b52a-38decce9e6c4/syz_repro
> 
> Oops: general protection fault, probably for non-canonical address 0xdffffc0000000002: 0000 [#1] SMP KASAN PTI
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> CPU: 0 UID: 0 PID: 1860 Comm: kworker/u9:3 Not tainted syzkaller #0 PREEMPT(full) 
> Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS 1.16.2-debian-1.16.2-1 04/01/2014
> Workqueue: writeback wb_workfn (flush-7:0)
> RIP: 0010:folio_prepare_writeback+0x32/0x280 mm/page-writeback.c:2371
> Code: 56 41 55 41 54 53 50 48 89 d3 48 89 f5 49 89 fe 49 bd 00 00 00 00 00 fc ff df e8 f9 22 c2 ff 4c 8d 63 18 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 ef 6a 2c 00 4d 39 34 24 0f 85 bf
> RSP: 0018:ffffc9000901f1e8 EFLAGS: 00010203
> RAX: 0000000000000002 RBX: fffffffffffffffe RCX: ffff88810981ba80
> RDX: 0000000000000000 RSI: ffffc9000901f4e0 RDI: ffff8881a659bc48
> RBP: ffffc9000901f4e0 R08: ffff88810981ba80 R09: 0000000000000003
> R10: 0000000000000406 R11: 0000000000000000 R12: 0000000000000016
> R13: dffffc0000000000 R14: ffff8881a659bc48 R15: ffffc9000901f4e0
> FS:  0000000000000000(0000) GS:ffff88818de5e000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00001b4fda9cd4b8 CR3: 0000000110906000 CR4: 00000000000006f0
> Call Trace:
>  <TASK>
>  udf_writepages+0xce/0x3b0 fs/udf/inode.c:205
>  do_writepages+0x32e/0x550 mm/page-writeback.c:2554
>  __writeback_single_inode+0x133/0x11a0 fs/fs-writeback.c:1750
>  writeback_sb_inodes+0x992/0x1a20 fs/fs-writeback.c:2042
>  wb_writeback+0x456/0xb70 fs/fs-writeback.c:2227
>  wb_do_writeback fs/fs-writeback.c:2374 [inline]
>  wb_workfn+0x414/0xf50 fs/fs-writeback.c:2414
>  process_one_work kernel/workqueue.c:3276 [inline]
>  process_scheduled_works+0xb6e/0x18c0 kernel/workqueue.c:3359
>  worker_thread+0xa53/0xfc0 kernel/workqueue.c:3440
>  kthread+0x388/0x470 kernel/kthread.c:436
>  ret_from_fork+0x51e/0xb90 arch/x86/kernel/process.c:158
>  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>  </TASK>
> Modules linked in:
> ---[ end trace 0000000000000000 ]---
> RIP: 0010:folio_prepare_writeback+0x32/0x280 mm/page-writeback.c:2371
> Code: 56 41 55 41 54 53 50 48 89 d3 48 89 f5 49 89 fe 49 bd 00 00 00 00 00 fc ff df e8 f9 22 c2 ff 4c 8d 63 18 4c 89 e0 48 c1 e8 03 <42> 80 3c 28 00 74 08 4c 89 e7 e8 ef 6a 2c 00 4d 39 34 24 0f 85 bf
> RSP: 0018:ffffc9000901f1e8 EFLAGS: 00010203
> RAX: 0000000000000002 RBX: fffffffffffffffe RCX: ffff88810981ba80
> RDX: 0000000000000000 RSI: ffffc9000901f4e0 RDI: ffff8881a659bc48
> RBP: ffffc9000901f4e0 R08: ffff88810981ba80 R09: 0000000000000003
> R10: 0000000000000406 R11: 0000000000000000 R12: 0000000000000016
> R13: dffffc0000000000 R14: ffff8881a659bc48 R15: ffffc9000901f4e0
> FS:  0000000000000000(0000) GS:ffff8882a945e000(0000) knlGS:0000000000000000
> CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> CR2: 00001b4fda9c7570 CR3: 0000000173314000 CR4: 00000000000006f0
> ----------------
> Code disassembly (best guess):
>    0:	56                   	push   %rsi
>    1:	41 55                	push   %r13
>    3:	41 54                	push   %r12
>    5:	53                   	push   %rbx
>    6:	50                   	push   %rax
>    7:	48 89 d3             	mov    %rdx,%rbx
>    a:	48 89 f5             	mov    %rsi,%rbp
>    d:	49 89 fe             	mov    %rdi,%r14
>   10:	49 bd 00 00 00 00 00 	movabs $0xdffffc0000000000,%r13
>   17:	fc ff df
>   1a:	e8 f9 22 c2 ff       	call   0xffc22318
>   1f:	4c 8d 63 18          	lea    0x18(%rbx),%r12
>   23:	4c 89 e0             	mov    %r12,%rax
>   26:	48 c1 e8 03          	shr    $0x3,%rax
> * 2a:	42 80 3c 28 00       	cmpb   $0x0,(%rax,%r13,1) <-- trapping instruction
>   2f:	74 08                	je     0x39
>   31:	4c 89 e7             	mov    %r12,%rdi
>   34:	e8 ef 6a 2c 00       	call   0x2c6b28
>   39:	4d 39 34 24          	cmp    %r14,(%r12)
>   3d:	0f                   	.byte 0xf
>   3e:	85                   	.byte 0x85
>   3f:	bf                   	.byte 0xbf
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
-- 
Jan Kara <jack@suse.com>
SUSE Labs, CR
