Received: from mail-pg1-f169.google.com (mail-pg1-f169.google.com [209.85.215.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F116044470F
	for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 17:05:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784567151; cv=none; b=rytdmmDkpQEvMJXNMPcsGFnd/ZfsbLmH4dJqqUc1ZnlIRR7dAErXs448/Wv3Ifg5BbwpNAI2qg4lkSzL9KT4+3HdGwTpsAAlxNCYp7MJXGbjs3mzZQwYOivcj/hkmy0NXQzfWBiB9h95IlHEKhg2NzICJLBuWuIr3I9jiJCkDO4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784567151; c=relaxed/simple;
	bh=+6EuphAstKZ/0xbPwiIV7NjnJykrOtjdXduE5KcXVJU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ciu2MsJ2gWXPuf3ASMuiT5gaxqaSWrtSDv+dEJjFDtICv+uF4U4r2Chv8ZkubI3fpbZtX6cQZms7xbnn/iU6F8x/CbJ8Hr9yZFLeV25njJTo73fgAZilM3c9hV/BdQO0pFQMyUP+NuP7hOJ1q4+4XTGzyvkcXxt8BFsW9LmEiV4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in; spf=none smtp.mailfrom=devineni.in; dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b=Jw4F2+bY; arc=none smtp.client-ip=209.85.215.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=devineni.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b="Jw4F2+bY"
Received: by mail-pg1-f169.google.com with SMTP id 41be03b00d2f7-ca97d139d5fso7251286a12.0
        for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 10:05:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devineni.in; s=google; t=1784567143; x=1785171943; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O5yl0y5CFPi7yxDHkdiMMCLhjIMywr485T4gjTFf6M8=;
        b=Jw4F2+bY6z6+eFJHdNeayQz1TcMcyvHQqNRZq4l+WNCpaR03ypj105e+xVpr34cEYj
         T7X5FoVMJBNaMzB7Rm6RB9Ddrlezm/KOdqBJP99N50IJO2DmCy9ioFLhCi4CbJIEVtU9
         xmsfe/a/R26wwG6wv2m+LUqNpFeE4+IaVmNtZxLbkszNu7TgIas49Bz5/n4qOx7TxRRz
         /eNtm+SDEiT94foQRyyahdwqv8C/XkjjIqlJ/4YDl87XNlKdDM7LnsYijTPAz2hB9XcP
         hJz7oIHfrYR5zBEDhicsGcODNQL4LteI8xgdoYkqMqFb7pUL9yBDE18hV+gSGZAydFXg
         ajyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784567143; x=1785171943;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O5yl0y5CFPi7yxDHkdiMMCLhjIMywr485T4gjTFf6M8=;
        b=NhXT0tD0TA3GS53ih519E0FmJiLvhvaYI/9YtK4eVZXjyC3sCcDcnTk9Et8gWV0YLv
         keusetLmgtPym1p5XVloCU9jGLqiPIKMLHegKiJsRrGYzM4tmhcYVvI9Lq2hqo97FJSK
         OR0AeQVh5+c6QQNk0BoVBr3xfIIRhAyo0d58QN48Xf5aFuI+1OwD8abDT7vJQX7OdU4A
         RCWhi37WebK8JOH1jOdp6cvFx3u3EMg1dfDeAC2juWsRYStESbcvJlFqYp+vsT6sSoZI
         zQFL9lC7BWebjxHqGucn/5ES1i3RZtuHP5jzWa1zs/IqShh+mO+ZRNveFBesGxsfACbO
         h0Ag==
X-Gm-Message-State: AOJu0Yxh0Mdl0foxO51SF4hWq97Bb4ExZAHNXI9/pCYShjYcLDesW+TN
	hEy1CXby8UFXX0/BfHvTwpk5MDfCvcajnzL/iK7csQxZ58q06Yfv0Eb2Idx3GrdIPA==
X-Gm-Gg: AfdE7cmwQv9OWt9xCaL6aSfcQ9zeaeGJIxt7t2Ndz/q9cebVRpiG9WtZDc8AOvG3fiG
	VlemlmUhVbpnM2NsA/j0eY96AKs144IzRWksOJIBA3nG7ICWrW5PTDH/JnVpZoz/rlKt4XEKLOX
	bKBrAS/K+O6w1wONcVU7Oy3q8f0ZSPx5lA7KjAb0fcA0nXnTWEV3ajxljgckN5Kkk4UWO1nFGHo
	yuM0lyfmexdwDqf8+4eWVgmio/Jjk/o33Gh4JZPBztKUe7Q6IHMvjR+sEJXyaYB9eaqohwkQ01c
	awyxOQHT0qmiwq+PF7aGBMUtZpQ3BFGYIwGmM5Gsy+r+Ala8ePYmkccUY4ePntwP4Q91j5/NtFW
	Lp4lmcdd0uucIlSOD3fmkPCoqfmtSnUpxBNl9WQhOnV+qRyCh0tGAb+kbY2hdRmqtYbDCs9+Y7B
	vIvXcJOiJfYpOwMG3mFA4DYeLliXgKViq/FycI3gw+6/h3jiwgbrOdrCqcWdxXIRLJvx2RgSXmn
	Cr8dOtPsyYl8w==
X-Received: by 2002:a05:6300:95:b0:3c3:7ac4:dac7 with SMTP id adf61e73a8af0-3c3ad8ecd82mr16182786637.45.1784567142791;
        Mon, 20 Jul 2026 10:05:42 -0700 (PDT)
Received: from [192.168.0.100] ([49.205.99.55])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3142a1e348bsm40110013eec.25.2026.07.20.10.05.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 10:05:42 -0700 (PDT)
Message-ID: <cb5980f6-d860-40c1-b25a-670b6316c73b@devineni.in>
Date: Mon, 20 Jul 2026 22:35:28 +0530
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] fuse: abort connection on /dev/fuse flush to
 prevent deadlock
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <3e4a3361-9e1b-4f46-8033-f85ada100a79@mail.kernel.org>
Content-Language: en-US
From: Kusaram Devineni <kusaram@devineni.in>
In-Reply-To: <3e4a3361-9e1b-4f46-8033-f85ada100a79@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 20-07-2026 04:48 pm, syzbot wrote:
> A single-threaded FUSE daemon can deadlock if it mounts a filesystem and
> opens a file on it. When the process exits or calls close_range(), the
> kernel closes file descriptors in ascending numerical order.
> 
> If the /dev/fuse file descriptor (e.g., fd 5) is closed first, filp_close()
> decrements the file reference count but defers the actual release (fput) to
> task work. As a result, the FUSE connection remains active.
> 
> Next, when the FUSE file descriptor (e.g., fd 6) is closed, filp_close()
> calls fuse_flush(), which sends a synchronous FUSE_FLUSH request to the
> daemon. Since the daemon is the same thread that is currently blocked in
> the close() syscall, it cannot process the request. The FUSE_FLUSH request
> uses args.force = true, making the wait uninterruptible. The thread hangs
> forever, eventually triggering a hung task panic:
> 
> Call Trace:
>   <TASK>
>   __schedule+0x17d9/0x56c0 kernel/sched/core.c:7234
>   schedule+0x164/0x2b0 kernel/sched/core.c:7326
>   request_wait_answer fs/fuse/dev.c:743 [inline]
>   __fuse_request_send fs/fuse/dev.c:757 [inline]
>   fuse_chan_send+0x1065/0x1ab0 fs/fuse/dev.c:833
>   fuse_simple_request fs/fuse/fuse_i.h:1012 [inline]
>   fuse_flush+0x66e/0x8b0 fs/fuse/file.c:504
>   filp_flush+0xbd/0x190 fs/open.c:1471
>   filp_close+0x1d/0x40 fs/open.c:1484
>   __range_close fs/file.c:793 [inline]
>   __do_sys_close_range fs/file.c:854 [inline]
>   __se_sys_close_range+0x3d3/0x900 fs/file.c:818
>   do_syscall_64+0x15f/0x560 arch/x86/entry/syscall_64.c:94
> 
> To fix this, implement a .flush method for /dev/fuse (fuse_dev_operations).
> The .flush method is called synchronously by filp_close() during the
> close() syscall, bypassing the fput delay.
> 
> In fuse_dev_flush(), if this is the final close of the file descriptor
> (file_count(file) <= 1), we mark the device as closing. Since multiple
> cloned /dev/fuse devices can exist for the same connection, we track the
> closing state of each device under the channel lock. If all devices
> associated with the channel are closing, we proactively abort the FUSE
> connection. By aborting the connection synchronously in .flush, any
> subsequent fuse_flush() calls on FUSE files will immediately fail with
> -ENOTCONN instead of blocking indefinitely, avoiding the deadlock.
> 
> To handle the race where a /dev/fuse file descriptor is closed before it is
> fully installed into a connection (i.e., fud->chan is still NULL), we use
> cmpxchg() to atomically transition fud->chan from NULL to
> FUSE_DEV_CHAN_DISCONNECTED. This prevents a concurrent fuse_dev_install()
> from succeeding on a device that is already being closed.
> 

this correctly fixes the multiple-clone problem from v1, but the 
predicate must also be maintained by fuse_dev_release(). a device that 
was not marked closing can be removed by release, leaving only devices 
already marked closing. since release currently aborts only when the 
list becomes empty, neither path is then guaranteed to abort before 
deferred release. please use the same all-closing predicate after 
removal in fuse_dev_release().

> Note that CUSE (Character Device in User Space) also shares
> fuse_dev_operations and therefore inherits this new .flush callback, which
> is safe and consistent with its lifecycle.
> 
> Fixes: 4a9d4b024a31 ("switch fput to task_work_add")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+0dbb0d6fda088e78a4d8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0dbb0d6fda088e78a4d8
> Link: https://syzkaller.appspot.com/ai_job?id=84ef0273-9fd7-4475-b099-dd6b7424c049
> To: <fuse-devel@lists.linux.dev>
> To: "Miklos Szeredi" <miklos@szeredi.hu>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v2:
> - Added `closing` flag to `struct fuse_dev` to track the closing state of each device.
> - Updated `fuse_dev_flush()` to check if all associated devices are closing, properly handling cloned devices.
> - Used `cmpxchg()` in `fuse_dev_flush()` to handle the race where a device is closed before being fully installed.
> - Updated `fuse_dev_release()` to handle `FUSE_DEV_CHAN_DISCONNECTED` safely.
> 
> v1:
> https://lore.kernel.org/all/bedbc009-8806-4913-9a03-1b25b6d33729@mail.kernel.org/T/
> ---
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 5763a7cd3..2179d182e 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -2217,7 +2217,7 @@ int fuse_dev_release(struct inode *inode, struct file *file)
>   	/* Pairs with cmpxchg() in fuse_dev_install() */
>   	struct fuse_chan *fch = xchg(&fud->chan, FUSE_DEV_CHAN_DISCONNECTED);
>   
> -	if (fch) {
> +	if (fch && fch != FUSE_DEV_CHAN_DISCONNECTED) {

the sentinel guard is correct. in the installed-channel branch, please 
also update the post-list_del() decision: abort when the list is empty 
or every remaining device is marked closing. compute that state under 
fch->lock, but continue calling fuse_chan_abort() after unlocking. keep 
WARN_ON(fch->iq.fasync != NULL) limited to the genuinely empty-list case.

>   		struct fuse_pqueue *fpq = &fud->pq;
>   		LIST_HEAD(to_end);
>   		unsigned int i;
> @@ -2375,23 +2375,58 @@ static void fuse_dev_show_fdinfo(struct seq_file *seq, struct file *file)
>   }
>   #endif
>   
> +static int fuse_dev_flush(struct file *file, fl_owner_t id)
> +{
> +	struct fuse_dev *fud = fuse_file_to_fud(file);
> +	struct fuse_chan *fch;
> +	struct fuse_dev *tmp;
> +	bool last = true;
> +

please rename tmp to pos and last to all_closing. the condition means 
that all listed devices are closing, not necessarily that this is the 
last list entry

> +	if (file_count(file) > 1)
> +		return 0;
> +

prefer file_count(file) != 1. the callback is intended to act only on 
the exact final-close state; expressing that invariant directly avoids 
treating an impossible zero count as final.

> +	/*
> +	 * Atomically transition fud->chan from NULL to FUSE_DEV_CHAN_DISCONNECTED
> +	 * on final close to prevent a later fuse_dev_install() from succeeding.
> +	 */
> +	fch = cmpxchg(&fud->chan, NULL, FUSE_DEV_CHAN_DISCONNECTED);
> +	if (!fch || fch == FUSE_DEV_CHAN_DISCONNECTED)
> +		return 0;
> +
> +	spin_lock(&fch->lock);
> +	fud->closing = true;
> +	list_for_each_entry(tmp, &fch->devices, entry) {
> +		if (!tmp->closing) {
> +			last = false;
> +			break;
> +		}
> +	}
> +	spin_unlock(&fch->lock);
> +
> +	if (last)
> +		fuse_chan_abort(fch, false);
> +

please factor the locked list scan into a helper such as 
fuse_dev_all_closing(), with a comment that fch->lock must be held. use 
it both here and after device removal in fuse_dev_release() so the flush 
and release definitions cannot diverge. continue invoking 
fuse_chan_abort() outside the lock.

> +	return 0;
> +}
> +
>   const struct file_operations fuse_dev_operations = {
> -	.owner		= THIS_MODULE,
> -	.open		= fuse_dev_open,
> -	.read_iter	= fuse_dev_read,
> -	.splice_read	= fuse_dev_splice_read,
> -	.write_iter	= fuse_dev_write,
> -	.splice_write	= fuse_dev_splice_write,
> -	.poll		= fuse_dev_poll,
> -	.release	= fuse_dev_release,
> -	.fasync		= fuse_dev_fasync,
> +	.owner = THIS_MODULE,
> +	.open = fuse_dev_open,
> +	.read_iter = fuse_dev_read,
> +	.splice_read = fuse_dev_splice_read,
> +	.write_iter = fuse_dev_write,
> +	.splice_write = fuse_dev_splice_write,
> +	.poll = fuse_dev_poll,
> +	.flush = fuse_dev_flush,
> +	.release = fuse_dev_release,
> +	.fasync = fuse_dev_fasync,
>   	.unlocked_ioctl = fuse_dev_ioctl,
> -	.compat_ioctl   = compat_ptr_ioctl,
> +	.compat_ioctl = compat_ptr_ioctl,
>   #ifdef CONFIG_FUSE_IO_URING
> -	.uring_cmd	= fuse_uring_cmd,
> +	.uring_cmd = fuse_uring_cmd,
>   #endif
>   #ifdef CONFIG_PROC_FS
> -	.show_fdinfo	= fuse_dev_show_fdinfo,
> +	.show_fdinfo = fuse_dev_show_fdinfo,
>   #endif

please retain the existing aligned initializer formatting and add only 
the new .flush entry. reformatting every existing member is unrelated 
churn and conceals the functional change.

>   };
>   EXPORT_SYMBOL_GPL(fuse_dev_operations);
> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> index 668c8391d..29e79d646 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -310,6 +310,9 @@ struct fuse_dev {
>   
>   	/** @entry: list entry on fch->devices */
>   	struct list_head entry;
> +
> +	/** @closing: is this device closing? */
> +	bool closing;
>   };
>   
>   struct fuse_copy_state {
> @@ -337,8 +340,8 @@ struct fuse_copy_state {
>    * Lockless access is OK, because fud->chan is set once during mount and is valid
>    * until the file is released.
>    *
> - * fud->chan is set to FUSE_DEV_CHAN_DISCONNECTED only after the containing file is
> - * released, so result is safe to dereference in most cases.  Exceptions are:
> + * fud->chan is set to FUSE_DEV_CHAN_DISCONNECTED on final close or release,
> + * so result is safe to dereference in most cases.  Exceptions are:
>    * fuse_dev_put() and fuse_fill_super_common().
>    */

"fud->chan is set to FUSE_DEV_CHAN_DISCONNECTED on final close or 
release"...this comment overstates the transition. final flush replaces 
NULL with the disconnected sentinel only for an uninstalled device. for 
an installed device, flush leaves the channel pointer intact, records 
closing, and release later installs the sentinel. please document those 
two cases separately.

>   static inline struct fuse_chan *fuse_dev_chan_get(struct fuse_dev *fud)
> 
> 
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda

-kusaram

