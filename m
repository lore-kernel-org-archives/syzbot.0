Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72E951917FB
	for <syzbot@lists.linux.dev>; Fri, 31 Jul 2026 09:50:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785491452; cv=none; b=lN2FXPUg7l857agGg2+HZ46VF/KtdlHybDYQTZ09YhfXxnyhr0jSSXwVjwsvU48mvSKTMKSYbPEw5FVELZN/mYGFeZfde2Cxi7xoHz9+aA5qiHHkukSEYK7NRkvnoAH180vq8kCYVjLUXkSeDR+BSb46IPbAaTSfRk4Q8gHYGyU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785491452; c=relaxed/simple;
	bh=CHc+wCr9gxcPne4TuTzNkOO6oLbFIqOkceGJjhlrMPo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=cMZD9M5fHU3FPBBpdSgfFn9Khh72LeYk1+1M9hk2CTIZFumq1vTEZ2B4cWJHCsHgjyl1UUmKNx9NuFBFj9jGEvCijF+JxRnT8a/R/vKLiTMuhv6kwgep3T8n+BpzsUiBA5pnntSGq4HCqAU6Wjf0CU/DIJBFjRJJ3OTS03uyVd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=maSqDwJz; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="maSqDwJz"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Fri, 31 Jul 2026 11:50:36 +0200 (CEST)
Date: Fri, 31 Jul 2026 11:50:34 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] netdevsim: fix deadlock in
 nsim_bus_dev_max_vfs_write()
Message-ID: <amxv6obePgfHNDsA@nr200>
References: <61024160-6fe7-45d6-baa0-0ddcba466bbe@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <61024160-6fe7-45d6-baa0-0ddcba466bbe@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785491438; bh=SwV0TqTuX7uXIt03mWGjQfoGTj/5CjXy9IsI8zxllPI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=maSqDwJzglMJ9rtyNC6nzU72JmxhtSijB4pW/GTJwaGw6EvFqK9BeGWJIUuVo3rr9
	 n7st66Tj+bPJct98H6QrYkgHj6WCsFSpb03XFl51aTQZAq77DxlXUuY1gknJEl9s3t
	 KkqSxMUrYav3ky8dFpkw5KwSxMQA5RGEbsQ4zJU0=

#syz upstream

On lip 31, 2026 09:41, 'syzbot' via syzkaller-upstream-moderation wrote:
> There is an ABBA deadlock between the devlink instance lock and the debugfs
> active file reference mechanism.
> 
> When a device is being removed (e.g., via nsim_drv_remove()), the driver
> acquires the devlink instance lock and then calls
> debugfs_remove_recursive(). This function blocks waiting for all active
> file operations on the debugfs files to complete.
> 
> Concurrently, if a user writes to the "max_vfs" debugfs file, the VFS layer
> acquires an active reference to the file. The write handler,
> nsim_bus_dev_max_vfs_write(), then attempts to acquire the devlink instance
> lock, which is already held by the removal task.
> 
> This creates a circular dependency resulting in a deadlock:
> 
> INFO: task blocked for more than 143 seconds.
> Call Trace:
>  wait_for_completion+0x2ca/0x5e0 kernel/sched/completion.c:153
>  __debugfs_file_removed fs/debugfs/inode.c:751 [inline]
>  remove_one+0x2df/0x3b0 fs/debugfs/inode.c:758
>  __simple_recursive_removal+0x215/0x520 fs/libfs.c:623
>  debugfs_remove+0x5b/0x70 fs/debugfs/inode.c:781
>  nsim_dev_debugfs_exit drivers/net/netdevsim/dev.c:372 [inline]
>  nsim_drv_remove+0xc0/0x170 drivers/net/netdevsim/dev.c:1803
> 
> INFO: task blocked for more than 143 seconds.
> Call Trace:
>  __mutex_lock+0x7bf/0x1550 kernel/locking/mutex.c:821
>  nsim_bus_dev_max_vfs_write+0x229/0x3d0 drivers/net/netdevsim/dev.c:276
>  full_proxy_write+0x127/0x1f0 fs/debugfs/file.c:388
>  vfs_write+0x296/0xba0 fs/read_write.c:685
> 
> To fix this, use devl_trylock() in nsim_bus_dev_max_vfs_write() instead of
> devl_lock(). If the lock cannot be acquired, return -EBUSY. This aborts the
> write operation, releases the debugfs active file reference, and allows the
> pending debugfs_remove_recursive() to proceed.
> 
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+3147c5de186107ffc7a1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3147c5de186107ffc7a1
> Link: https://syzkaller.appspot.com/ai_job?id=fcdda182-bebf-49ab-ada0-d4d2e814ebf7
> To: "Andrew Lunn" <andrew+netdev@lunn.ch>
> To: "David S. Miller" <davem@davemloft.net>
> To: "Eric Dumazet" <edumazet@google.com>
> To: "Jakub Kicinski" <kuba@kernel.org>
> To: <netdev@vger.kernel.org>
> To: "Paolo Abeni" <pabeni@redhat.com>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v2:
> - No changes since v1.
> 
> v1:
> https://lore.kernel.org/all/a861f535-2bc3-46cd-ab28-a4190ae24248@mail.kernel.org/T/
> ---
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index aed9ad5f1..421cd7327 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -273,7 +273,11 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
>  		return -ENOMEM;
>  
>  	nsim_dev = file->private_data;
> -	devl_lock(priv_to_devlink(nsim_dev));
> +	if (!devl_trylock(priv_to_devlink(nsim_dev))) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
>  	/* Reject if VFs are configured */
>  	if (nsim_dev_get_vfs(nsim_dev)) {
>  		ret = -EBUSY;
> @@ -285,6 +289,7 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
>  	}
>  	devl_unlock(priv_to_devlink(nsim_dev));
>  
> +out:
>  	kfree(vfconfigs);
>  	return ret;
>  }
> 
> 
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482

-- 
Slawomir Stepien
