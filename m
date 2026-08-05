Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A11C3EC685
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 08:56:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785920168; cv=pass; b=k1wMxa04r1nqXmBX24OsNHKwNIn1baUdlo6Jo47bUM+ImnF/ev/7KYhJpt3oqTgmrisGxoCCjjljN+lH2V7ocbKF6hOr8F31pOh3UP+80ndAUKq5zommiBFAX0M+SwEljAfojejbpGbE5C2RCKNkPoAQ00vQ5qh8qd4uqcBvQIo=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785920168; c=relaxed/simple;
	bh=c1YjyoeK/qFMR6sBt7V9ccs+ulqofSkUAe5ARGX/Bj0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=DFsM6bNbHaclDuvQuyj0bk/JnnMjU1LLdXDoL6y7+OZQvpYTCbVNouzwO4wVYU/T9AxhJjW1Vit5tjNJoEGUyd48F14uKzWFr/N1PeFeQzpYhO36A4fmrR96KS28FbG2q/8s4Jn8Dqf61FFickq7LuuyL4yvhgQ2qnBIQMf+kKc=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=YDafMYZl; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="YDafMYZl"
Received: by smtp.kernel.org (Postfix)
	id B7A801F00A3A; Wed,  5 Aug 2026 08:56:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.49
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1785920165;
	b=Zx++YL/HfxJr4ELbzn3vfYOAjkzIhynXmlMgDm4NVzxVrzLzWIJOS15Vipbut5gNb18l
	 Jk7JR0G54MUxz4PHB08/PZ1rTWXp610KYqJEIXkkK3mau6pmvUFi9zLflxSVTO9r+8LpV
	 DONt89DYphJCw0C2+FmIKuo2glHaDSnSw6G+dH4/uybhFpo4auviZ7GZ3pN+wax048DCs
	 dtfyZHrglOHCVNQLJdyMl/SjzE+/OqjreLrwoXUjXouAGzy9x7xHCB3n7+B4UsDQHCO75
	 km1EL8Zj+pblphUjZJEGC/heQBFItniGob+Lsd/zOwU2BUlPMevL8+PkSAlXiNWGQiw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1785920165;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=LhlHuk8MCeIb9JOjrstGCs9CqnMd4hE1KqF/ZjhqpVw=;
	b=TNz+wivVG/VABKbkMP7NiEwE+XqPFTkpQOCDHJ7Td8CG2YbfrwXDJz/aa3V+WQDtu4BM
	 5MrKg24urBclpd7hc+2MauG03+XVQHt/7cWh5Vz38E3oT5DEcUPJfB1ir9w53bBIpNLAe
	 ltsecFSbKZPmvNe5faij7oQSeu3wChga8ZiM0uYTzLcA7dlFQIf8WmZPNLksZxQ7bEPop
	 ISC9nsDQ6xTpO5/jqd4dAYu2YQO+B8Sv3/4+o2GUpMdPTw3lkCa0LJ8NxNIUIa93dlkIv
	 aIQIR2Zr6HLSuKlDkAeH7v52mQnKOoRXNJLrNONmMnCKTcZR0JViQisxOI9lTIlL+gQ==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=YDafMYZl;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.49
Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 4E0721F000E9
	for <syzbot@kernel.org>; Wed,  5 Aug 2026 08:56:03 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=YDafMYZl
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 4E0721F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Wed,  5 Aug 2026 10:55:59 +0200 (CEST)
Date: Wed, 5 Aug 2026 10:55:56 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: Paolo Abeni <pabeni@redhat.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
	Andrew Lunn <andrew+netdev@lunn.ch>,
	"David S. Miller" <davem@davemloft.net>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: Re: [PATCH] netdevsim: fix deadlock in nsim_bus_dev_max_vfs_write()
Message-ID: <anL6nNIJDqWOynzw@nr200>
References: <b7bf56ea-7522-4163-acd5-aaa69ad03b3a@mail.kernel.org>
 <c74a0579-dc37-4f3b-8dba-8380223b361c@redhat.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c74a0579-dc37-4f3b-8dba-8380223b361c@redhat.com>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785920161; bh=LhlHuk8MCeIb9JOjrstGCs9CqnMd4hE1KqF/ZjhqpVw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=YDafMYZlZUZJ1Vnm75juh132XReDi6FTj/aH6TPcYx+9R8Snm6PlN35MIPmrBqwwI
	 vkizl5XDoDbh3RSAVkHVAXLdS9Opllg+2jufeqxMHhz5WhKdHSP720ALSwT288QP+v
	 V8HsVQ0DiIIfUWY2uwCydv5BqBxta7z06wrSGLQ8=

On sie 04, 2026 16:33, Paolo Abeni wrote:
> On 7/31/26 11:55 AM, syzbot wrote:
> > From: Slawomir Stepien <sst@poczta.fm>
> > 
> > There is an ABBA deadlock between the devlink instance lock and the debugfs
> > active file reference mechanism.
> > 
> > When a device is being removed (e.g., via nsim_drv_remove()), the driver
> > acquires the devlink instance lock and then calls
> > debugfs_remove_recursive(). This function blocks waiting for all active
> > file operations on the debugfs files to complete.
> > 
> > Concurrently, if a user writes to the "max_vfs" debugfs file, the VFS layer
> > acquires an active reference to the file. The write handler,
> > nsim_bus_dev_max_vfs_write(), then attempts to acquire the devlink instance
> > lock, which is already held by the removal task.
> > 
> > This creates a circular dependency resulting in a deadlock:
> > 
> > INFO: task blocked for more than 143 seconds.
> > Call Trace:
> >  wait_for_completion+0x2ca/0x5e0 kernel/sched/completion.c:153
> >  __debugfs_file_removed fs/debugfs/inode.c:751 [inline]
> >  remove_one+0x2df/0x3b0 fs/debugfs/inode.c:758
> >  __simple_recursive_removal+0x215/0x520 fs/libfs.c:623
> >  debugfs_remove+0x5b/0x70 fs/debugfs/inode.c:781
> >  nsim_dev_debugfs_exit drivers/net/netdevsim/dev.c:372 [inline]
> >  nsim_drv_remove+0xc0/0x170 drivers/net/netdevsim/dev.c:1803
> > 
> > INFO: task blocked for more than 143 seconds.
> > Call Trace:
> >  __mutex_lock+0x7bf/0x1550 kernel/locking/mutex.c:821
> >  nsim_bus_dev_max_vfs_write+0x229/0x3d0 drivers/net/netdevsim/dev.c:276
> >  full_proxy_write+0x127/0x1f0 fs/debugfs/file.c:388
> >  vfs_write+0x296/0xba0 fs/read_write.c:685
> > 
> > To fix this, use devl_trylock() in nsim_bus_dev_max_vfs_write() instead of
> > devl_lock(). If the lock cannot be acquired, return -EBUSY. This aborts the
> > write operation, releases the debugfs active file reference, and allows the
> > pending debugfs_remove_recursive() to proceed.
> > 
> > Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> > Reported-by: syzbot+3147c5de186107ffc7a1@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=3147c5de186107ffc7a1
> > Link: https://syzkaller.appspot.com/ai_job?id=fcdda182-bebf-49ab-ada0-d4d2e814ebf7
> > Signed-off-by: Slawomir Stepien <sst@poczta.fm>
> > 
> > ---
> > diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> > index aed9ad5f1..421cd7327 100644
> > --- a/drivers/net/netdevsim/dev.c
> > +++ b/drivers/net/netdevsim/dev.c
> > @@ -273,7 +273,11 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
> >  		return -ENOMEM;
> >  
> >  	nsim_dev = file->private_data;
> > -	devl_lock(priv_to_devlink(nsim_dev));
> > +	if (!devl_trylock(priv_to_devlink(nsim_dev))) {
> > +		ret = -EBUSY;
> 
> I think this should return restart_syscall(). This kind of schema is
> calling for trouble, but for netdevsim should be okish.

Thanks Paolo for your comment!

Can you explain a bit more? What is your reasoning here? Is it, that we expect that we could have
the lock in e.g. 1ns, so it is worth restarting without bothering userspace[1]?

I see a lot of:

if (!rtnl_trylock())
	return restart_syscall();

Why this pattern is so popular? Is it for the same reason as above?

[1] https://kernel-internals.org/syscalls/restart-block/

-- 
Slawomir Stepien
