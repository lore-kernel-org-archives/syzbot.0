Received: from mail-pf1-f178.google.com (mail-pf1-f178.google.com [209.85.210.178])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 005C141D106
	for <syzbot@lists.linux.dev>; Mon, 27 Jul 2026 17:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.178
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785173254; cv=none; b=m76qfmXtVFu/UceB7CBaVdln9imxBxgNUhuYvTezM9BBPZ4zJSj2Y2Zt/k9tgZP4hMQfZwuIqsBLrnCBvVbBWatPxeLqZHUfe+3STnvm3J3vMfwVRHDbLG92qPN0lW+m2aldNaJHHGJeCgzYXGBbHgJoPzL6o3W3R7aBUzC72WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785173254; c=relaxed/simple;
	bh=7e+Y8W2KXVG1Q/Vcf7ZOpr3LVshhj/ac1oS23LIBgHo=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FFaRtYXioYLHgcqxasGblQv88xgsmnI7ZWdiUb3CmHZHeiEkRFa+Euc660WUh0mKZkgnYOxUFRlIqdlt3JY7zi2osE8CeMcTIArM3yU39u+J6kRSDluZ2Erhezxu27ha42R2R6WL4t9R38biKmCzEpfZ3RkN/GePy7NDmJOAk2g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in; spf=none smtp.mailfrom=devineni.in; dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b=DE5NcTeF; arc=none smtp.client-ip=209.85.210.178
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=devineni.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b="DE5NcTeF"
Received: by mail-pf1-f178.google.com with SMTP id d2e1a72fcca58-8423f236418so2241105b3a.1
        for <syzbot@lists.linux.dev>; Mon, 27 Jul 2026 10:27:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devineni.in; s=google; t=1785173243; x=1785778043; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=DfaAmb06XyOMLrb4SDGdRgVQMWGJYoinMS+4zKRkyDQ=;
        b=DE5NcTeFaaqDc7fAIuxE6MjvUKZDBC8YPKYdN3KnjWf5yUwmaoTOcFEs/HaCLOo2X/
         L/cy1C8hgJn8CDB1SjmnCSRtV+XuBZ3vmJoN2d1az4Xsu+h1ncoU92gjFJm5Lxy6bEq6
         4S3pxTdHHeGtRbbHx58/CrwiwaoIJQnmO8URk3kWwVr1h0tfinY7Ekgi2Rd56Q3S89kF
         6DZCIMfCm6FchRQ9EBmOK/Er2zba0w/0v81Q/aeuzUZLu1gf5rSfmMN4sK7OSeH0JsVJ
         rD1Nc14Bjm7aoshlF5+vuadqa9UeGIiLvSkzZgZAypaYFEKwtgECUsorA/aFgQwLQmqi
         3WLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785173243; x=1785778043;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=DfaAmb06XyOMLrb4SDGdRgVQMWGJYoinMS+4zKRkyDQ=;
        b=pHpFFjWALTBPv3Wypob4rxQKQWjmQybFKCWjqljpz3XMYySC+b99FpAtXSYFW85PPY
         o9YWMOdYYRnNN3YsZZkN/TUt6bWdjbzEKAcQgYevfNfL+HuzBeBjvTmvK8ktq2onoNtS
         CceozPAjGjkT+L8uOjQeFiTCDnaN4q0njmyUGT8QOFE6gY3c0CPIZ3TI2zWVrVlgZbZF
         liOurTGhrCx/Kn60KjDKOOkBOf08hdPQOyfAC3+ddLKd6SHNjsWrziygVR+lMNjW3ITs
         bcbqkgnVz7tjQm2+dChugUPsaIP43Kz/uR/sxGmc9coyptGXJI83t8F5mViqw6bX+nGe
         1OZQ==
X-Gm-Message-State: AOJu0YxuA7rew3teuSYCi9P06ncDiy3XaJktarSsq41rtMjNPcWz73++
	h3F/e13IV2RJKTOyLKEKsQ0DO3nYNuTypLGMMMQb7uZZI7eQO0m4bduGXFNC151RAg==
X-Gm-Gg: AR+sD12azmc2nJphGPM1bV1DsthH3faSedJGLsgSMHuDIDY/0sQ7SImElq/FVWpmrS8
	jCHMyvH6fsYwNhXNoVc3d1PuFtJAHs/UCsg7y68A8pbn6gUc3pyoj7cXa9VKzS17+fgOgS20L8C
	WEZf8Ez/8vvyfwLxB4OZ5J9DQBeiRg+wTfNqln0HLwckQZ/VNBlv+pdH7GVadbdF8lDEL/F3ETH
	Rfn4QrS/He/zsI7mx5zmXL2NkfpvGiK22+qF0LYwwHNwCzlNMV3WNRBlp2et7mA3MwhXwl9H9Hb
	lYm23Am36qFgomgLWjKMlYx5zB/kgeFgRSzZ/DSOsGLrxSfvoOGqKO/eK45qx4XOncz/fZ4pRSr
	ynWod0IM2Chk8NK9n01y3L6xJT6oda5PbM9hbWL+YTY5cxdDqni7aW4KRhRYdA1/n5MBOQBHq3m
	cI/S4JWfx+dA0qeSEbffRmw+MIc+Fs5beGBgQSru6cT4hVZgFkf+bA77lbWQ+DFf6OzywoTLOm/
	83VXieAZw7ydugYtdMOC2UVK4AsF0IH2NHko6nQAUHkLnsPfuwIR9sqV0EoKepPc4VwT+IWCA==
X-Received: by 2002:a05:6a21:6f12:b0:3bf:a11c:176e with SMTP id adf61e73a8af0-3c67dfd3119mr8923256637.57.1785173243024;
        Mon, 27 Jul 2026 10:27:23 -0700 (PDT)
Received: from [192.168.0.120] ([49.205.101.182])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-314bc3e1285sm36440834eec.5.2026.07.27.10.27.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Jul 2026 10:27:22 -0700 (PDT)
Message-ID: <49713e72-babd-4001-bdf1-c7cd684d25b4@devineni.in>
Date: Mon, 27 Jul 2026 22:57:18 +0530
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v8] fuse: abort connection on /dev/fuse flush to
 prevent deadlock
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <ffbdc3cc-fdc0-417b-9b8c-ee418c4734bf@mail.kernel.org>
Content-Language: en-US
From: Kusaram Devineni <kusaram@devineni.in>
In-Reply-To: <ffbdc3cc-fdc0-417b-9b8c-ee418c4734bf@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 27-07-2026 06:57 pm, syzbot wrote:
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
> (file_count(file) == 1), the device is marked as closing. Since multiple
> cloned /dev/fuse devices can exist for the same connection, the closing
> state of each device is tracked under the channel lock. If all devices
> associated with the channel are closing, the FUSE connection is proactively
> aborted. By aborting the connection synchronously in .flush, any subsequent
> fuse_flush() calls on FUSE files will immediately fail with -ENOTCONN
> instead of blocking indefinitely, avoiding the deadlock.
> 
> To handle the race where a /dev/fuse file descriptor is closed before it is
> fully installed into a connection (i.e., fud->chan is still NULL),
> cmpxchg() is used to atomically transition fud->chan from NULL to
> FUSE_DEV_CHAN_DISCONNECTED. This prevents a concurrent fuse_dev_install()
> from succeeding on a device that is already being closed. Furthermore,
> because the VFS may invoke .fasync after .flush but before .release,
> fuse_get_dev() and __fuse_get_dev() must reject the
> FUSE_DEV_CHAN_DISCONNECTED sentinel to prevent .fasync from dereferencing
> it.
> 
> Note that CUSE (Character Device in User Space) also shares
> fuse_dev_operations and therefore inherits this new .flush callback, which
> is safe and consistent with its lifecycle.
> 
> Fixes: 4a9d4b024a31 ("switch fput to task_work_add")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Tested-by: syzbot <syzbot@syzkaller.appspotmail.com>
> Reported-by: syzbot+0dbb0d6fda088e78a4d8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0dbb0d6fda088e78a4d8
> Link: https://syzkaller.appspot.com/ai_job?id=fdcc0473-0605-4428-aad0-dd002b5f15aa
> To: <fuse-devel@lists.linux.dev>
> To: "Miklos Szeredi" <miklos@szeredi.hu>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v8:
> - Avoided first-person pronouns ('we') in the commit description to use impersonal wording.
> 
> v7:
> - Removed the unintended `---` separator and the abridged changelog from the commit message.
> https://lore.kernel.org/all/1a00ee11-60cc-4a12-9c47-e0de73aa20a5@mail.kernel.org/T/
> 
> v6:
> - Clarified fud->chan state transitions and lockless access rules in comments.
> https://lore.kernel.org/all/6d8fbedb-e0dc-4133-81be-dc44a2b066d9@mail.kernel.org/T/
> 
> v5:
> - Moved `closing` next to `sync_init` in `struct fuse_dev` to preserve compact placement of boolean members.
> - Restored formatting of `fuse_dev_operations`.
> - Updated commit message to explain why `fuse_get_dev()` and `__fuse_get_dev()` reject `FUSE_DEV_CHAN_DISCONNECTED` due to `.fasync` invocation.
> - Removed duplicate `Tested-by` tag.
> https://lore.kernel.org/all/13552139-cd2b-4ea9-994c-cfed6c07000b@mail.kernel.org/T/
> 
> v4:
> - Changed `(file_count(file) <= 1)` to `(file_count(file) == 1)` in the commit message.
> - Added `Tested-by: syzbot@syzkaller.appspotmail.com` tag.
> - Added lockdep assertion in `fuse_dev_all_closing()`.
> - Updated `fuse_get_dev()` and `__fuse_get_dev()` to reject `FUSE_DEV_CHAN_DISCONNECTED`.
> - Checked `fch->connected` before aborting in `fuse_dev_release()` and `fuse_dev_flush()`.
> https://lore.kernel.org/all/17ec009d-743f-4703-b56d-c78b2152ace2@mail.kernel.org/T/
> 
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
> index 668c8391d..2833a0350 100644
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
> @@ -330,17 +333,25 @@ struct fuse_copy_state {
>   	} ring;
>   };
>   
> -/* fud->chan gets assigned to this value when /dev/fuse is closed */
> -#define FUSE_DEV_CHAN_DISCONNECTED ((struct fuse_chan *) 1)
> -
>   /*
> - * Lockless access is OK, because fud->chan is set once during mount and is valid
> - * until the file is released.
> + * fud->chan has the following monotonic state transitions:
> + *
> + * NULL -> valid channel -> FUSE_DEV_CHAN_DISCONNECTED
> + * NULL -----------------> FUSE_DEV_CHAN_DISCONNECTED
>    *
> - * fud->chan is set to FUSE_DEV_CHAN_DISCONNECTED only after the containing file is
> - * released, so result is safe to dereference in most cases.  Exceptions are:
> - * fuse_dev_put() and fuse_fill_super_common().
> + * A valid channel pointer remains valid until the file is released. Final
> + * flush can install FUSE_DEV_CHAN_DISCONNECTED directly for an uninstalled
> + * device, preventing any later channel installation. The sentinel therefore
> + * means that the channel can no longer be installed or accessed through this
> + * file; it does not imply that release has already run and it must never be
> + * dereferenced.
> + *
> + * fuse_dev_chan_get() reads this state locklessly. Callers must distinguish
> + * NULL, a valid channel pointer, and FUSE_DEV_CHAN_DISCONNECTED before
> + * dereferencing the result.
>    */
> +#define FUSE_DEV_CHAN_DISCONNECTED ((struct fuse_chan *) 1)
> +
>   static inline struct fuse_chan *fuse_dev_chan_get(struct fuse_dev *fud)
>   {
>   	/* Pairs with xchg() in fuse_dev_install() */
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

#syz upstream

