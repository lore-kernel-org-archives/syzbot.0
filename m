Received: from mail-pj1-f48.google.com (mail-pj1-f48.google.com [209.85.216.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9DF23DAAD3
	for <syzbot@lists.linux.dev>; Thu, 23 Jul 2026 07:43:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784792641; cv=none; b=NEYqorOuQxVlxOHOZbyRKORPcE9OvluzdW6jzZHmdRgzgmhyOVt1sQ3pwKO9dv6J/XtbJrzNAwhjwWMyx8jk7rU/xMVggEXJUOe2C/0y37vNw5HAgdRFTRkAtjWvuxyc+T+HqiB24C6ImiVHbhDcTKvvzOjyAWpIQEloofoKR7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784792641; c=relaxed/simple;
	bh=Jvbdn9fzjXVDavFgpkEIT1Wgr5XfalPHy2j0fSLHrH0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fmVPMNeEeov1JrMskp8Md93O8JPt961AIejWujc6xxkdwb1fy/7kbPNE3ZxEzcjxZrRHvpCeTwWyP3dFK1tB+JB6rH1HNGe/R2VLdrsojRcVuBXsrmp22mVwxpt2B8zX7iwAlY5TWeEbCsaghuhdK2qZGTh8ydv7bAtR4R/prmQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in; spf=none smtp.mailfrom=devineni.in; dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b=MrYJXGRz; arc=none smtp.client-ip=209.85.216.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=devineni.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b="MrYJXGRz"
Received: by mail-pj1-f48.google.com with SMTP id 98e67ed59e1d1-38ec1402b05so245390a91.2
        for <syzbot@lists.linux.dev>; Thu, 23 Jul 2026 00:43:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devineni.in; s=google; t=1784792638; x=1785397438; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=2EV8/HISnwMi01T40MnnhRNZneTjiLEvbn8VUFVv47c=;
        b=MrYJXGRzwfk7fBh7eFpwR0M5KMC6ADIJeN2gG63tbwr/DvUj63b6HPlpwwVC/nMQ3r
         d36xxgmchxg0TdpcCOg/Fj96YuuooXFHbGye44vCaBoJmMmkTkyY33+2mp1eGoSjm0Dd
         mjABHwMyhFe1PBwEObRuE+w2AUms8lYVgz9eNM8qy2ZS9MvtHXtuTeSV/Rqn+Q+MO/SX
         NSe0+/CnSzfvqQs5VPB0ytu3A3yrGP1uXOgnrj/bSWV/9XBkewSCQYNBcnw4CCDDuRQq
         uyDmjIpzI/AIu5lKPmaHpwVkcgdFih/9/l66mFFA2w8vPPVKBUuLFUdCI7qbmhcqzEvD
         mOGg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784792638; x=1785397438;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=2EV8/HISnwMi01T40MnnhRNZneTjiLEvbn8VUFVv47c=;
        b=RkmkOa1lmpeRIzgjGzgJHWwmZxnVV4oj9Ng7ysfIO+QR2qHmxtFgEfA/g5eBQQs4Sp
         kSENETlz5zID1SrZi8byp2TGgdM1h90cNP8pYMiPW6Jx0amq7MqBIPlyfatTJaPftPGV
         1E6Z6tWa+ePF1ZzWogfoqGVzzcWzREke75dJA9svsv9iO/zEvVSzDh7oCvlt5lw7hs8M
         CnNMo6Q5BiUmezFb3hPkhKF4+5EavyhCVyJyoQfofo1Drbdmzb5z6BTQ+8IHc5Gqm/wM
         uleznCzi79UYa/qHC11tmQLH0jXH3y8UF1u591bY4ntKBrPxIUeE2WsT32eQV0dmBQAJ
         MCXg==
X-Gm-Message-State: AOJu0Yy7NkPjyG3sOHP+/yQJYKCh1qyM74phxrUCnSIXSAwZ5sgR75br
	PgrZw07Ph4nPT9kir6i+GQ/Galg9/Xv6oKswgMkuxo55DTRmqj2Y/DLrGCDKdAjvpA==
X-Gm-Gg: AR+sD13YzKMJ0D5gdm6TrwRVM+9VlR9QW7fgOCirvQsYn8D0yhdInvtgJFrS19o7Y5S
	HerZd264incsYbieVqCjkV7J9Hca6JaMg5+ZBJBQG3eWGbGoQHg3IAZma6FPFupcYNZMQdeR8CL
	k8e/QLoHjukDCTTHVH8LaY8AwVSHCaSqKI21dgnu8o5sHeetwCqLGEMDntjzuTEQcemXKXrS6e7
	G/eJY9P+Z1RkDdSVFy2JoFjocmlkPAGGMX/Q/9kkC9CmGrYh18tNLeePIb93LSg87AGxsl5sOVv
	hujmDQW0G+N2bzi9GKXb/l5a1EJ9cs4xAnMeT86IgNZbuhqIP87ul82N81FGDppGObsrS+J5Qh7
	3YIxJ6pVNjX0af/ngCrQ4Zh60q8y14rITb4Ue8xaFgRVMRDaMdnMGvEf9V9xabIovJdEk9rCE1P
	i1cfrECvtjaFwENZpIUs8nvXkmyOf3Z0NmUFDHsVTULdHqmWsd5+gVnRWje5oz4cYsj9ZEPd029
	2g=
X-Received: by 2002:a17:90b:1350:b0:37f:a915:1c29 with SMTP id 98e67ed59e1d1-38ec64c1ab0mr2090700a91.19.1784792638032;
        Thu, 23 Jul 2026 00:43:58 -0700 (PDT)
Received: from [192.168.0.100] ([49.205.99.55])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38eca8f02e5sm547866a91.1.2026.07.23.00.43.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 00:43:57 -0700 (PDT)
Message-ID: <aa585fae-c817-4695-b7a1-d188dac49e74@devineni.in>
Date: Thu, 23 Jul 2026 13:13:54 +0530
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] fuse: abort connection on /dev/fuse flush to
 prevent deadlock
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <40d9021a-6a93-43a1-97b0-6ec2f9cbabc6@mail.kernel.org>
Content-Language: en-US
From: Kusaram Devineni <kusaram@devineni.in>
In-Reply-To: <40d9021a-6a93-43a1-97b0-6ec2f9cbabc6@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 20-07-2026 11:42 pm, syzbot wrote:
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

change this to file_count(file) == 1, matching the implementation and 
the exact final-reference invariant.

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
> Note that CUSE (Character Device in User Space) also shares
> fuse_dev_operations and therefore inherits this new .flush callback, which
> is safe and consistent with its lifecycle.
> 
> Fixes: 4a9d4b024a31 ("switch fput to task_work_add")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+0dbb0d6fda088e78a4d8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0dbb0d6fda088e78a4d8
> Link: https://syzkaller.appspot.com/ai_job?id=ea95192d-3fa6-40f6-a70f-f147aaa37d22
> To: <fuse-devel@lists.linux.dev>
> To: "Miklos Szeredi" <miklos@szeredi.hu>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v3:
> - Added fuse_dev_all_closing() helper to check if all devices on a channel are closing.
> - Updated fuse_dev_release() to abort the connection if all remaining devices are closing.
> - Fixed the file reference count check in fuse_dev_flush() to check for file_count(file) != 1 instead of file_count(file) > 1.
> - Updated the comment in fs/fuse/fuse_dev_i.h to clarify the lifecycle of fud->chan and when it is set to FUSE_DEV_CHAN_DISCONNECTED.
> 
> v2:
> - Added `closing` flag to `struct fuse_dev` to track the closing state of each device.
> - Updated `fuse_dev_flush()` to check if all associated devices are closing, properly handling cloned devices.
> - Used `cmpxchg()` in `fuse_dev_flush()` to handle the race where a device is closed before being fully installed.
> - Updated `fuse_dev_release()` to handle `FUSE_DEV_CHAN_DISCONNECTED` safely.
> https://lore.kernel.org/all/3e4a3361-9e1b-4f46-8033-f85ada100a79@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/bedbc009-8806-4913-9a03-1b25b6d33729@mail.kernel.org/T/
> ---
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 5763a7cd3..7cf541873 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -2211,17 +2211,30 @@ void fuse_chan_wait_aborted(struct fuse_chan *fch)
>   	fuse_uring_wait_stopped_queues(fch);
>   }
>   
> +/* fch->lock must be held */
> +static bool fuse_dev_all_closing(struct fuse_chan *fch)
> +{
> +	struct fuse_dev *pos;
> +
> +	list_for_each_entry(pos, &fch->devices, entry) {
> +		if (!pos->closing)
> +			return false;
> +	}
> +	return true;
> +}
> +

replace the free-form “lock must be held” comment with 
lockdep_assert_held(&fch->lock) inside fuse_dev_all_closing(). this 
matches existing FUSE helper practice and verifies the contract in 
lockdep builds.

suggested form...
static bool fuse_dev_all_closing(struct fuse_chan *fch)
{
	struct fuse_dev *pos;

	lockdep_assert_held(&fch->lock);
	...
}

>   int fuse_dev_release(struct inode *inode, struct file *file)
>   {
>   	struct fuse_dev *fud = fuse_file_to_fud(file);
>   	/* Pairs with cmpxchg() in fuse_dev_install() */
>   	struct fuse_chan *fch = xchg(&fud->chan, FUSE_DEV_CHAN_DISCONNECTED);
>   
> -	if (fch) {
> +	if (fch && fch != FUSE_DEV_CHAN_DISCONNECTED) {
>   		struct fuse_pqueue *fpq = &fud->pq;
>   		LIST_HEAD(to_end);
>   		unsigned int i;
>   		bool last;
> +		bool all_closing;
>   
gate the scan with fch->connected. once the channel is aborted, every 
deferred clone release currently rescans all remaining closing devices, 
producing O(N²) work under fch->lock.

keep last separately for the fasync assertion and store an abort decision:

last = list_empty(&fch->devices);
abort = fch->connected && fuse_dev_all_closing(fch);

then:
if (last)
	WARN_ON(fch->iq.fasync != NULL);
if (abort)
	fuse_chan_abort(fch, false);

>   		/* Make sure fuse_dev_install_with_pq() has finished */
>   		spin_lock(&fch->lock);
> @@ -2234,12 +2247,14 @@ int fuse_dev_release(struct inode *inode, struct file *file)
>   		list_del(&fud->entry);
>   		/* Are we the last open device? */
>   		last = list_empty(&fch->devices);
> +		all_closing = last || fuse_dev_all_closing(fch);
>   		spin_unlock(&fch->lock);
>   
>   		fuse_dev_end_requests(&to_end);
>   
> -		if (last) {
> -			WARN_ON(fch->iq.fasync != NULL);
> +		if (all_closing) {
> +			if (last)
> +				WARN_ON(fch->iq.fasync != NULL);
>   			fuse_chan_abort(fch, false);
>   		}

keep fuse_chan_abort() outside fch->lock. do not clear VFS-owned FASYNC 
state in .flush, move release teardown into .flush, or modify generic 
VFS fasync handling. queue removal, reference release, and object 
destruction must remain in .release.

>   		fuse_conn_put(fch->conn);
> @@ -2375,23 +2390,52 @@ static void fuse_dev_show_fdinfo(struct seq_file *seq, struct file *file)
>   }
>   #endif
>   
> +static int fuse_dev_flush(struct file *file, fl_owner_t id)
> +{
> +	struct fuse_dev *fud = fuse_file_to_fud(file);
> +	struct fuse_chan *fch;
> +	bool all_closing;
> +
> +	if (file_count(file) != 1)
> +		return 0;
> +
> +	/*
> +	 * Atomically transition fud->chan from NULL to FUSE_DEV_CHAN_DISCONNECTED
> +	 * on final close to prevent a later fuse_dev_install() from succeeding.
> +	 */
> +	fch = cmpxchg(&fud->chan, NULL, FUSE_DEV_CHAN_DISCONNECTED);
> +	if (!fch || fch == FUSE_DEV_CHAN_DISCONNECTED)
> +		return 0;
> +

this early transition causes the syzbot-CI fasync_remove_entry() crash. 
during deferred __fput(), VFS invokes .fasync(..., 0) before .release. 
fuse_get_dev() rejects only NULL, so it mistakes 
FUSE_DEV_CHAN_DISCONNECTED for an installed channel. fuse_dev_fasync() 
then constructs &fud->chan->iq.fasync from the sentinel; the reported 
invalid address is 0x131.

keep this compare-exchange because it prevents installation after final 
close. add a new hunk updating fuse_get_dev(): preserve its sync-init 
wait only for NULL, reload fch after the wait, and return 
ERR_PTR(-EPERM) if it equals FUSE_DEV_CHAN_DISCONNECTED.

also update __fuse_get_dev() to return NULL when fch is either NULL or 
FUSE_DEV_CHAN_DISCONNECTED. fixing both accessors prevents every normal 
device operation—not only fasync—from dereferencing the sentinel.

> +	spin_lock(&fch->lock);
> +	fud->closing = true;
> +	all_closing = fuse_dev_all_closing(fch);
> +	spin_unlock(&fch->lock);
> +
> +	if (all_closing)
> +		fuse_chan_abort(fch, false);
> +
apply the same connected-state gating in flush, while holding fch->lock:

fud->closing = true;
abort = fch->connected && fuse_dev_all_closing(fch);

continue calling fuse_chan_abort() only after dropping the lock.

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
preserve the existing aligned fuse_dev_operations initializer. 
reformatting every entry is unrelated churn.
add only:

.poll		= fuse_dev_poll,
.flush		= fuse_dev_flush,
.release	= fuse_dev_release,

>   };
>   EXPORT_SYMBOL_GPL(fuse_dev_operations);
> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> index 668c8391d..ec6334414 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -310,6 +310,9 @@ struct fuse_dev {
>   
>   	/** @entry: list entry on fch->devices */
>   	struct list_head entry;
> +
> +	/** @closing: is this device closing? */
> +	bool closing;

move 'bool closing' beside the existing bool sync_init. appending it 
after struct list_head entry introduces tail padding and enlarges every 
struct fuse_dev; placing the two booleans together consumes existing 
padding.

please also document its lock:

/** @closing: Final close has started, protected by chan->lock */
bool closing;

>   };
>   
>   struct fuse_copy_state {
> @@ -337,8 +340,10 @@ struct fuse_copy_state {
>    * Lockless access is OK, because fud->chan is set once during mount and is valid
>    * until the file is released.
>    *
> - * fud->chan is set to FUSE_DEV_CHAN_DISCONNECTED only after the containing file is
> - * released, so result is safe to dereference in most cases.  Exceptions are:
> + * Final flush replaces NULL with the disconnected sentinel only for an
> + * uninstalled device, while for an installed device, flush leaves the channel
> + * pointer intact and records closing, and release later installs the sentinel.
> + * Thus the result is safe to dereference in most cases.  Exceptions are:
>    * fuse_dev_put() and fuse_fill_super_common().

document all three fud->chan states explicitly:
1. NULL: uninstalled and still installable;
2. valid pointer: installed;
3. FUSE_DEV_CHAN_DISCONNECTED: disconnected, non-installable, and never 
dereferenceable by normal accessors.

the accessor documentation must state that fuse_get_dev() and 
__fuse_get_dev() reject the sentinel. raw lifecycle paths such as 
install, fill-super, flush, release, and fuse_dev_put() handle it 
explicitly.

>    */
>   static inline struct fuse_chan *fuse_dev_chan_get(struct fuse_dev *fud)
> 
> 
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda\

add the below to commit message:
Tested-by: syzbot@syzkaller.appspotmail.com

initiate another syzbot test after the patch is generated.

-kusaram
