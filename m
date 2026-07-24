Received: from mail-pl1-f169.google.com (mail-pl1-f169.google.com [209.85.214.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4605233D6F9
	for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 11:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.214.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784892225; cv=none; b=Fx1Za4EPGc2XiRRtTOKlHFE8hwmJ09QdEtAvONoxEYtyTw4eHNLURIQ0Lhsxrsl8AZEYNOnPBmZ7R1b0+hqPjZ7KsUQ6PTw/7C72ra5SI6bJrM94XoMPSWIEfjME24P+iyykkyDmCMegHrsyJKZTrjlE6MDOMHGfv4CeYKmOtUs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784892225; c=relaxed/simple;
	bh=UtEGq+wvQh+JidfZGZq6N6phUPPUwyvX+FAn/2QVHLc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=JQ/uyEyz0gYiYaMVLQrIFnROk05L4mQFxsK2Tva2da2OhezKOnYbyer4VKiT5jlQZB9KwZyz+dLAtVqDWFd+tKjbzkx/f/054w6TCNkq4CR+EC48Emy+MgZ/JXA3WAFHZXaXtDFUPrc46OPZFi5u8qVCo7wGquNBZ0tn6akPl3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in; spf=none smtp.mailfrom=devineni.in; dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b=kEfnBNCP; arc=none smtp.client-ip=209.85.214.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=devineni.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b="kEfnBNCP"
Received: by mail-pl1-f169.google.com with SMTP id d9443c01a7336-2cc61541f8cso15344775ad.0
        for <syzbot@lists.linux.dev>; Fri, 24 Jul 2026 04:23:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devineni.in; s=google; t=1784892222; x=1785497022; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=0C+BfojsnNlptzps1so9Vn1Hn2vj1JKXFeHNaNhrU9s=;
        b=kEfnBNCPSTlBs3XjQa4AcCc1SQLAGTQIMOPRu5UvW5/tGXrB887yflrscqxtHqrOcL
         LQRX42R5mKTvxlHGug6KnRT0Eg+SgfcmPsGvwYnI0KoEKCJicJPQ8qvrDIJOCAJSgwWw
         8GbwowqDSftjYfTswyyfrOXRhPGeqDL4l0HwMAUJuM0/3kajZ8LCNogy4Y9UEE36/44Y
         SpTJ6mAxgvtQ8Hz73CeDRykYr9fsIrTPA5fjKGtvsqnevJqcKEylLsDsc0jVKQs5AiHU
         NfCqlekYfzaE7fW/2nE6wmQNXu9k0c6jUNuNJ3YpIJJeowSefgATd6gTqhe16S0/8qUL
         TonA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784892222; x=1785497022;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=0C+BfojsnNlptzps1so9Vn1Hn2vj1JKXFeHNaNhrU9s=;
        b=QaZjGoc6ManW9aBjUBhppHyjUPaEvh/dhJruXsaNR0Uz/2O57zS9PnSg0Cjo2mRl+Q
         F5Y0BXnoSl65IZgpQu7csvHiXNeEOfAs97y2/aCM1e+E/IMlkTUUK5CH851Pndxs+d7J
         G2ly6egCCj/7wKFXhgRwln4tIQVzmfNlOtiDmj7cb/5Za3Zq9vDENRZXIxBZvcAd7rzk
         Z6J/3Au7m9IkRPyHgPKXkOPpVMCgJ1pbjSjJbOjGCfYdqT/vrlOnZ4bgPGhxd461i5+Z
         BWqASfMaO1V+hd/PDk0vxNaBM+UoOkjVMz9FUPMiBP3h5pJ0NEVlc3pfKYO0UJpwlN70
         Lncg==
X-Gm-Message-State: AOJu0YxafSZiUI5Xe1GtCoxHgOzTsnpXPT1L7+zXIrMrYrNoqzlKfsxq
	whLwreArhi49YXBNqqCu3WmVixZEPGKotveexc3w765ujrRGQwB0TJhEhWZ+NyTQ+07EXtGSA3I
	H9lgKGA==
X-Gm-Gg: AR+sD10ZZCO01+aSnd6+Vyat41gacbA34k9PKbUlz1fdQkm4fr6mVnOZ9amPJtybV7E
	SHO66EAwcRIv3ikOqjC6mVx+cAJqaW88KVMZWLNL3MbEj+Lg1yutCS572+sqP3w67djeoEHcew9
	OpDoSmjCM9qrYeb9Xai1uVeVCnJOsuCrfuD5mCg/gv+eTe0UpvMdFEXUXk43VrGY3H5+lXAwFzK
	rlPrETm8wRfq57srjcNPgA0mJPxa7NOGc4MYAcDw9BDddt61DTV7Gqz/LXW4MvsNuBrWnTetaU+
	U2ppUGn/aYrIKxqELRQqyRoKtopLlMnL1xejDbsmD7GFRuhj9mhcNk/igTygNzfhRft5QntLc9h
	JbJzPKnNx2oTU6yDSqg5lmB2OK0IYY0DAOXFgXCwPFbmp5XNuANM11RoJwYoPx/+BCP+tcmsWoi
	neYm+1kQEkCkbe66glIupkUc4oCLAgwq3/TApOW7/mNfUtzkHr229hTM1mJ2W29umDAB+g+FLSV
	ng5u1JIyA+mjMwclFwaGbaEhuZ1yGAxxrftq6rZcg9KrdV1eZOM0RbzJl7GSYA=
X-Received: by 2002:a17:903:384d:b0:2cc:bdb9:3c04 with SMTP id d9443c01a7336-2cfd7179882mr1267285ad.17.1784892221913;
        Fri, 24 Jul 2026 04:23:41 -0700 (PDT)
Received: from [192.168.0.100] ([49.205.105.129])
        by smtp.gmail.com with ESMTPSA id d9443c01a7336-2cf8f38a893sm49515015ad.77.2026.07.24.04.23.39
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 24 Jul 2026 04:23:41 -0700 (PDT)
Message-ID: <6b22077b-ac31-4041-888e-a4deac37681f@devineni.in>
Date: Fri, 24 Jul 2026 16:53:27 +0530
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4] fuse: abort connection on /dev/fuse flush to
 prevent deadlock
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <17ec009d-743f-4703-b56d-c78b2152ace2@mail.kernel.org>
Content-Language: en-US
From: Kusaram Devineni <kusaram@devineni.in>
In-Reply-To: <17ec009d-743f-4703-b56d-c78b2152ace2@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 23-07-2026 03:29 pm, syzbot wrote:
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
> (file_count(file) == 1), we mark the device as closing. Since multiple
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
> from succeeding on a device that is already being closed. We also update
> fuse_get_dev() and __fuse_get_dev() to reject FUSE_DEV_CHAN_DISCONNECTED.
> 

VFS may invoke .fasync after .flush but before .release. therefore, once 
.flush publishes FUSE_DEV_CHAN_DISCONNECTED, both fuse_get_dev() and 
__fuse_get_dev() must reject the sentinel. otherwise .fasync can treat 
the sentinel as a valid channel pointer and dereference it, as observed 
in the v3 syzbot failure.

> Note that CUSE (Character Device in User Space) also shares
> fuse_dev_operations and therefore inherits this new .flush callback, which
> is safe and consistent with its lifecycle.
> 
> Tested-by: syzbot@syzkaller.appspotmail.com
> 

remove this duplicate 'Tested-by', retain the formatted tag at line 103.

> Fixes: 4a9d4b024a31 ("switch fput to task_work_add")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Tested-by: syzbot <syzbot@syzkaller.appspotmail.com>
> Reported-by: syzbot+0dbb0d6fda088e78a4d8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0dbb0d6fda088e78a4d8
> Link: https://syzkaller.appspot.com/ai_job?id=31f24081-e849-43c1-9085-23e4966c257f
> To: <fuse-devel@lists.linux.dev>
> To: "Miklos Szeredi" <miklos@szeredi.hu>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v4:
> - Changed `(file_count(file) <= 1)` to `(file_count(file) == 1)` in the commit message.
> - Added `Tested-by: syzbot@syzkaller.appspotmail.com` tag.
> - Added lockdep assertion in `fuse_dev_all_closing()`.
> - Updated `fuse_get_dev()` and `__fuse_get_dev()` to reject `FUSE_DEV_CHAN_DISCONNECTED`.
> - Checked `fch->connected` before aborting in `fuse_dev_release()` and `fuse_dev_flush()`.
> 

add the below two changes to the v4 changelog so that the revision 
history describes all differences from v3.

- moved closing next to sync_init to preserve compact placement of the 
boolean members.
- restored the existing fuse_dev_operations formatting to avoid 
unrelated formatting churn.

> v3:
> - Added fuse_dev_all_closing() helper to check if all devices on a channel are closing.
> - Updated fuse_dev_release() to abort the connection if all remaining devices are closing.
> - Fixed the file reference count check in fuse_dev_flush() to check for file_count(file) != 1 instead of file_count(file) > 1.
> - Updated the comment in fs/fuse/fuse_dev_i.h to clarify the lifecycle of fud->chan and when it is set to FUSE_DEV_CHAN_DISCONNECTED.
> https://lore.kernel.org/all/40d9021a-6a93-43a1-97b0-6ec2f9cbabc6@mail.kernel.org/T/
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
> index 5763a7cd3..8b14c7d57 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -1662,18 +1662,23 @@ static int fuse_dev_open(struct inode *inode, struct file *file)
>   struct fuse_dev *fuse_get_dev(struct file *file)
>   {
>   	struct fuse_dev *fud = fuse_file_to_fud(file);
> +	struct fuse_chan *fch = fuse_dev_chan_get(fud);
>   	int err;
>   
> -	if (unlikely(!fuse_dev_chan_get(fud))) {
> +	if (unlikely(!fch)) {
>   		/* only block waiting for mount if sync init was requested */
>   		if (!fud->sync_init)
>   			return ERR_PTR(-EPERM);
>   
> -		err = wait_event_interruptible(fuse_dev_waitq, fuse_dev_chan_get(fud) != NULL);
> +		err = wait_event_interruptible(fuse_dev_waitq,
> +					       (fch = fuse_dev_chan_get(fud)) != NULL);
>   		if (err)
>   			return ERR_PTR(err);
>   	}
>   
> +	if (unlikely(fch == FUSE_DEV_CHAN_DISCONNECTED))
> +		return ERR_PTR(-EPERM);
> +
>   	return fud;
>   }
>   
> @@ -2211,17 +2216,31 @@ void fuse_chan_wait_aborted(struct fuse_chan *fch)
>   	fuse_uring_wait_stopped_queues(fch);
>   }
>   
> +static bool fuse_dev_all_closing(struct fuse_chan *fch)
> +{
> +	struct fuse_dev *pos;
> +
> +	lockdep_assert_held(&fch->lock);
> +
> +	list_for_each_entry(pos, &fch->devices, entry) {
> +		if (!pos->closing)
> +			return false;
> +	}
> +	return true;
> +}
> +
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
> +		bool abort;
>   
>   		/* Make sure fuse_dev_install_with_pq() has finished */
>   		spin_lock(&fch->lock);
> @@ -2234,14 +2253,15 @@ int fuse_dev_release(struct inode *inode, struct file *file)
>   		list_del(&fud->entry);
>   		/* Are we the last open device? */
>   		last = list_empty(&fch->devices);
> +		abort = fch->connected && fuse_dev_all_closing(fch);
>   		spin_unlock(&fch->lock);
>   
>   		fuse_dev_end_requests(&to_end);
>   
> -		if (last) {
> +		if (last)
>   			WARN_ON(fch->iq.fasync != NULL);
> +		if (abort)
>   			fuse_chan_abort(fch, false);
> -		}
>   		fuse_conn_put(fch->conn);
>   	}
>   	fuse_dev_put(fud);
> @@ -2375,6 +2395,34 @@ static void fuse_dev_show_fdinfo(struct seq_file *seq, struct file *file)
>   }
>   #endif
>   
> +static int fuse_dev_flush(struct file *file, fl_owner_t id)
> +{
> +	struct fuse_dev *fud = fuse_file_to_fud(file);
> +	struct fuse_chan *fch;
> +	bool abort;
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
> +	spin_lock(&fch->lock);
> +	fud->closing = true;
> +	abort = fch->connected && fuse_dev_all_closing(fch);
> +	spin_unlock(&fch->lock);
> +
> +	if (abort)
> +		fuse_chan_abort(fch, false);
> +
> +	return 0;
> +}
> +
>   const struct file_operations fuse_dev_operations = {
>   	.owner		= THIS_MODULE,
>   	.open		= fuse_dev_open,
> @@ -2383,6 +2431,7 @@ const struct file_operations fuse_dev_operations = {
>   	.write_iter	= fuse_dev_write,
>   	.splice_write	= fuse_dev_splice_write,
>   	.poll		= fuse_dev_poll,
> +	.flush		= fuse_dev_flush,
>   	.release	= fuse_dev_release,
>   	.fasync		= fuse_dev_fasync,
>   	.unlocked_ioctl = fuse_dev_ioctl,
> diff --git a/fs/fuse/fuse_dev_i.h b/fs/fuse/fuse_dev_i.h
> index 668c8391d..e484be17d 100644
> --- a/fs/fuse/fuse_dev_i.h
> +++ b/fs/fuse/fuse_dev_i.h
> @@ -302,6 +302,9 @@ struct fuse_dev {
>   	/** @sync_init: Issue FUSE_INIT synchronously */
>   	bool sync_init;
>   
> +	/** @closing: Final close has started, protected by chan->lock */
> +	bool closing;
> +
>   	/** @chan: Fuse channel for this device */
>   	struct fuse_chan *chan;
>   
> @@ -337,9 +340,17 @@ struct fuse_copy_state {
>    * Lockless access is OK, because fud->chan is set once during mount and is valid
>    * until the file is released.
>    *
> - * fud->chan is set to FUSE_DEV_CHAN_DISCONNECTED only after the containing file is
> - * released, so result is safe to dereference in most cases.  Exceptions are:
> - * fuse_dev_put() and fuse_fill_super_common().
> + * fud->chan can have three states:
> + * - NULL: device is not installed yet
> + * - valid pointer: device is installed
> + * - FUSE_DEV_CHAN_DISCONNECTED: device is released
> + *

correct the statement above, the sentinel can be installed by the final 
.flush before .release when the device was never installed, so it does 
not exclusively mean that the device has already been released.

> + * Final flush replaces NULL with the disconnected sentinel only for an
> + * uninstalled device, while for an installed device, flush leaves the channel
> + * pointer intact and records closing, and release later installs the sentinel.
> + * Thus the result is safe to dereference in most cases.  Exceptions are:
> + * fuse_dev_put() and fuse_fill_super_common(). fuse_get_dev() and
> + * __fuse_get_dev() reject the sentinel.
>    */
>   static inline struct fuse_chan *fuse_dev_chan_get(struct fuse_dev *fud)
>   {
> @@ -355,8 +366,9 @@ static inline struct fuse_dev *fuse_file_to_fud(struct file *file)
>   static inline struct fuse_dev *__fuse_get_dev(struct file *file)
>   {
>   	struct fuse_dev *fud = fuse_file_to_fud(file);
> +	struct fuse_chan *fch = fuse_dev_chan_get(fud);
>   
> -	if (!fuse_dev_chan_get(fud))
> +	if (!fch || fch == FUSE_DEV_CHAN_DISCONNECTED)
>   		return NULL;
>   
>   	return fud;
> 
> 
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda

please test the new patch generated and confirm.

-kusaram


