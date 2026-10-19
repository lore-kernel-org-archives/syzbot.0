Received: from mail-wr1-f53.google.com (mail-wr1-f53.google.com [209.85.221.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE133F54A7
	for <syzbot@lists.linux.dev>; Mon, 19 Oct 2026 11:54:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792410898; cv=none; b=BYFG93psFy44YHL4UIcpDAA6AU5zZcGFs8w3jh5+FfvtYx1HPgMxXR31J7aGHJXz48mdnCkkJSG1eq92ImXrV4P5qGhPM/OsPqFFaI/J/u3grHep6Sk684dWdbqpg0h6ToH9IFU4ozFLIKMQttC8F6WmQQm9F5vQeoPAseW2254=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792410898; c=relaxed/simple;
	bh=DHObDFlPF3P+A5qVjdHKnDzidVXTBXdUyHFR3psXo8s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FrPcLs23ZYhOftJQhiGZ9eJttkbkK2E+cjkex0rtDwin2JfUVBRZmsfxqW9bijN+6gPRy04EEv7LFS6uJaf4bApyMEkld8NMZ0iCl8vSTcv+uo+ddYopOv669AMkdmed3PERrJwRkMjxiP/2Q3+OvgYgJDwn9z26QausEHze1eA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=oPwosBYQ; arc=none smtp.client-ip=209.85.221.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="oPwosBYQ"
Received: by mail-wr1-f53.google.com with SMTP id ffacd0b85a97d-48c4d870d54so1251267f8f.2
        for <syzbot@lists.linux.dev>; Mon, 19 Oct 2026 04:54:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792410894; x=1793015694; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QjO1sZ/wzlN+ZxddJ3z2zOgGAXvScgCcT9kQSfzXNnI=;
        b=oPwosBYQvnTaY8s/6G0Kk1AxbyK2SNtV2jHcdUMMwB+dlTqq8Q4Yc7ME6NooaI/HH7
         ZouqTD803sJwq8hdUk5UU6jtWANslH//75UN0LGdX8nFrRH9sm4u8Ape238Aw3lszzHP
         1kR9KPzw160fKzdF5ZixNghEnJ7ndg8ZGfptcKQllr/IGR6sKOPLFphP+vk78LoiNGAJ
         Smv8co8S+/zyIyEjSbjxeOpM5tTwgtLtHyXpaXQM/9Oipa+1v+DIvUDqQWsYdNbZRXGC
         Dd4zdIhCjNXUoiJX0ni4zwFxef9PhPCEjBiX6ownKvXTcbycXNIuDn4tAXrKz+saaZVm
         Mieg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792410894; x=1793015694;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QjO1sZ/wzlN+ZxddJ3z2zOgGAXvScgCcT9kQSfzXNnI=;
        b=Tt23h3CyJoL90ftmmyYvLA0MX0gwTZ1OnP22Nu45h+2RbMK1XWV5h6VX4QoB9r50uL
         NGKnm2bTom7llG2l7f2JzNDKn5vtL43A0do7Q73u3QHKQ8mnq2yI4lygcpmWR7vdFPY4
         tyUhNCbxR+T9rwAenG9+FCew4y+FrGPG5mGepOihda7TPhJ9y3Ss6zg/+K9F1dfAIVEx
         DjRyad2oGeT5iE3GorKoBRLA5cSRmS1SmbVZogn00fWTiZb8XQz0ibyQsjzhRxb5iiVE
         kephBa/JYhzaW2VYn/5+JoOBzRmlBS2b5pR3KxIpuwKrpBuC4ns7giYgut2KdRRrIIBK
         7oWw==
X-Gm-Message-State: AFq9FYJ730NAESlvwTyM/MY6LHAAL82zZq4gyYbR9PzTnp3fDhT/VzW5
	UaA0NFdVxgEp2P6uuYnrxzeRZPWANvUgsd39MxU5bUQ+rFT1rCztnXLV
X-Gm-Gg: AYBFou18BMi9X4ZGmD+5/4DnE1yMAB0Mnyo34I3JddDXKF6q/ehMmJTvwgtUL60daBA
	oK+kvtINPj06RjFA6HoTdWHoH4OiMPVdZMWfLJ6xeptaDuf/MfZ9SoqTiIp8/EQhBOaYthiv8FS
	ehgrZ+rEtHDSJLWacQmma0ep/CznEEkfAsHjkIYNhiZuGgGejs+Aee2bdIKJvgk1O40gMZelT28
	q37ZZTY4Xfek/5QXS7COTvVtri0Ktk1rmGdIgDvZPy0NuoVgiyrIcaPiF1bsFRCjVATKSnsMApm
	/ANsFQGtAY0QXl7RLPl8gvUK4gOMuHOL4xr6tz3s3OAztcoJDthiVus9QmqINkxiv7GuuXpct2e
	zOOSq2Bn0ynZT9yA5hpSZtdnlup6wyumA+iVZuYbAcHoL5Uzimm3M4Eh0N2C9G2NRdJSXyTJf33
	gMAr7CFM2Zl9TrmtHoeO2hXEUFvvWu+byzW9bR3gxO7wW7px/NZIwO0WRnV2lWAygwlkOyZvpN5
	y3RhPghL3m4xJHd4V3YXRm58ln/yQIMOlQRROYvLcmpXO+lZZgSY/1MCBuaYm7L4zfZg8bBHqr1
	fQ2ohEJYeLVR8rej9dC+A/PLYXralRhy8gdjqSKcp/h0Tka4VpOhkis7QYLgmgfKTWcxx6M+XQr
	cu4IV+y9OOz/1ajcCOPkBYCyygNrAMVdFvg==
X-Received: by 2002:a05:6000:29ca:b0:488:823d:5086 with SMTP id ffacd0b85a97d-48e07912b1cmr10090004f8f.0.1792410893733;
        Mon, 19 Oct 2026 04:54:53 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48dfd4ec8dfsm23719452f8f.26.2026.10.19.04.54.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 19 Oct 2026 04:54:53 -0700 (PDT)
Message-ID: <bfb04bc0-bf01-4d57-bb82-090b5bbcf2fd@gmail.com>
Date: Mon, 19 Oct 2026 13:54:52 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4] kernfs: do not hold of->mutex across sysfs
 ->store()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <77436f50-0ad3-42b6-a16b-4338e781e935@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <77436f50-0ad3-42b6-a16b-4338e781e935@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/16/26 18:36, syzbot wrote:
> A circular locking dependency was detected between &pipe->mutex,
> &of->mutex, and &sbi->pipe_mutex:
> 
>   &pipe->mutex --> &of->mutex --> &sbi->pipe_mutex
> 
> The cycle arises from two conflicting execution paths: splicing data from
> or to a pipe holds &pipe->mutex while invoking ->write_iter() or
> ->read_iter() on the kernfs file, acquiring of->mutex. Conversely, a write
> to a sysfs file such as /sys/power/resume acquires of->mutex and calls
> resume_store(), which resolves paths via lookup_bdev() and kern_path().
> Traversing an autofs mount during lookup invokes autofs_notify_daemon(),
> which acquires sbi->pipe_mutex and writes to the daemon pipe via
> __kernel_write(), acquiring pipe->mutex.
> 
> To address this, do not hold of->mutex across sysfs ->store() callbacks by
> introducing a write_unlocked flag in struct kernfs_ops and caching it in
> struct kernfs_open_file. Running ->store() without of->mutex is safe
> because sysfs ->store() maintains no per-open-file state, and concurrent
> opens of the same file already execute ->store() concurrently without
> serialization. Other kernfs users retain per-open-file serialization under
> of->mutex, and preallocated sysfs attributes still serialize buffer access
> via of->prealloc_mutex.
> 
> Note that not every cycle is eliminated: a pipe spliced into such an
> attribute stays locked while ->store() resolves paths, and callbacks
> holding their own locks across lookup and ->show() retain dependencies.
> 
> Fixes: f2d6c2708bd8 ("kernfs: wire up ->splice_read and ->splice_write")
> 
> Fixes: 1e8c813b083c ("PM: hibernate: don't use early_lookup_bdev in resume_store")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=002fb7b2d0bc53bf7e75
> Link: https://syzkaller.appspot.com/ai_job?id=7fc33c05-1e14-4d49-9698-08204af84c70
> To: "Danilo Krummrich" <dakr@kernel.org>
> To: <driver-core@lists.linux.dev>
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: "Rafael J. Wysocki" <rafael@kernel.org>
> To: "Tejun Heo" <tj@kernel.org>
> To: "Christoph Hellwig" <hch@lst.de>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v4:
> - Factor out active reference handling and write callback invocation into kernfs_write_active().
> - Update commit description to quote the lockdep chain once without redundant sub-chains or struct names.
> 
> v3:
> - Changed write_unlocked in struct kernfs_open_file from a bitfield to a bool
> - Expanded comments in kernfs.h and sysfs/file.c to clarify concurrency expectations and locking scope
> https://lore.kernel.org/all/c55e68c8-d895-4b6d-ad52-eedc0417562b@mail.kernel.org/T/
> 
> v2:
> - Avoid dropping splice_write support in kernfs_file_fops.
> - Introduce write_unlocked flag in struct kernfs_ops and struct kernfs_open_file to run sysfs ->store() without of->mutex.
> - Update commit subject and description to reflect the new locking approach.
> https://lore.kernel.org/all/bc6a8f1d-d7bf-43bf-80e2-c3489ded269a@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/af4efe2d-7856-46ff-9088-28400130dbce@mail.kernel.org/T/
> ---
> diff --git a/fs/kernfs/file.c b/fs/kernfs/file.c
> index 8e0e90c93..38ac34dae 100644
> --- a/fs/kernfs/file.c
> +++ b/fs/kernfs/file.c
> @@ -291,6 +291,25 @@ static ssize_t kernfs_fop_read_iter(struct kiocb *iocb, struct iov_iter *iter)
>  	return kernfs_file_read_iter(iocb, iter);
>  }
>  
> +static ssize_t kernfs_write_active(struct kernfs_open_file *of, char *buf,
> +				   size_t len, loff_t pos)
> +{
> +	const struct kernfs_ops *ops;
> +	ssize_t ret;
> +
> +	if (!kernfs_get_active_of(of))
> +		return -ENODEV;
> +
> +	ops = kernfs_ops(of->kn);
> +	if (ops->write)
> +		ret = ops->write(of, buf, len, pos);
> +	else
> +		ret = -EINVAL;
> +
> +	kernfs_put_active_of(of);
> +	return ret;
> +}
> +
>  /*
>   * Copy data in from userland and pass it to the matching kernfs write
>   * operation.
> @@ -305,7 +324,6 @@ static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>  {
>  	struct kernfs_open_file *of = kernfs_of(iocb->ki_filp);
>  	ssize_t len = iov_iter_count(iter);
> -	const struct kernfs_ops *ops;
>  	char *buf;
>  
>  	if (of->atomic_write_len) {
> @@ -331,24 +349,18 @@ static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>  
>  	/*
>  	 * @of->mutex nests outside active ref and is used both to ensure that
> -	 * the ops aren't called concurrently for the same open file.
> +	 * the ops aren't called concurrently for the same open file.  It is
> +	 * only acquired when @of->write_unlocked is clear, and ->write() of
> +	 * such a file can run concurrently for the same open file.
>  	 */
> -	mutex_lock(&of->mutex);
> -	if (!kernfs_get_active_of(of)) {
> +	if (of->write_unlocked) {
> +		len = kernfs_write_active(of, buf, len, iocb->ki_pos);
> +	} else {
> +		mutex_lock(&of->mutex);
> +		len = kernfs_write_active(of, buf, len, iocb->ki_pos);
>  		mutex_unlock(&of->mutex);
> -		len = -ENODEV;
> -		goto out_free;
>  	}
>  
> -	ops = kernfs_ops(of->kn);
> -	if (ops->write)
> -		len = ops->write(of, buf, len, iocb->ki_pos);
> -	else
> -		len = -EINVAL;
> -
> -	kernfs_put_active_of(of);
> -	mutex_unlock(&of->mutex);
> -
>  	if (len > 0)
>  		iocb->ki_pos += len;
>  
> @@ -651,6 +663,8 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
>  	 * lockdep key, because the writable file /sys/power/resume may call vfs
>  	 * lookup helpers for arbitrary paths and readonly files can be read by
>  	 * overlayfs from vfs helpers when sysfs is a lower layer of overalyfs.
> +	 * (Note that regular sysfs attributes no longer run ->store() under
> +	 * @of->mutex, but other kernfs users still do.)
>  	 *
>  	 * All three cases look the same.  They're supposed to
>  	 * look that way and give @of->mutex different static lockdep keys.
> @@ -666,10 +680,12 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
>  	of->file = file;
>  
>  	/*
> -	 * Write path needs to atomic_write_len outside active reference.
> -	 * Cache it in open_file.  See kernfs_fop_write_iter() for details.
> +	 * Write path needs atomic_write_len and write_unlocked outside
> +	 * active reference.  Cache them in open_file.  See
> +	 * kernfs_fop_write_iter() for details.
>  	 */
>  	of->atomic_write_len = ops->atomic_write_len;
> +	of->write_unlocked = ops->write_unlocked;
>  
>  	error = -EINVAL;
>  	/*
> diff --git a/fs/sysfs/file.c b/fs/sysfs/file.c
> index cd5bb0f9f..71a7faf43 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -132,7 +132,19 @@ static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
>  	return min_t(ssize_t, count, len);
>  }
>  
> -/* kernfs write callback for regular sysfs files */
> +/*
> + * kernfs write callback for regular sysfs files.
> + *
> + * Regular sysfs files set .write_unlocked = true and are called without
> + * holding of->mutex. Sysfs ->store() maintains no per-open-file state, and
> + * concurrent opens already execute ->store() concurrently without
> + * serialization. Calling ->store() without of->mutex avoids circular
> + * locking dependencies when ->store() performs operations like path
> + * lookups or automounts while a generic VFS lock is held (such as a pipe
> + * lock during splice). Preallocated attributes still serialize buffer
> + * access via of->prealloc_mutex. Existing autofs and callback-owned lock
> + * dependencies remain outside this narrow change.
> + */
>  static ssize_t sysfs_kf_write(struct kernfs_open_file *of, char *buf,
>  			      size_t count, loff_t pos)
>  {
> @@ -229,11 +241,13 @@ static const struct kernfs_ops sysfs_file_kfops_ro = {
>  
>  static const struct kernfs_ops sysfs_file_kfops_wo = {
>  	.write		= sysfs_kf_write,
> +	.write_unlocked	= true,
>  };
>  
>  static const struct kernfs_ops sysfs_file_kfops_rw = {
>  	.seq_show	= sysfs_kf_seq_show,
>  	.write		= sysfs_kf_write,
> +	.write_unlocked	= true,
>  };
>  
>  static const struct kernfs_ops sysfs_prealloc_kfops_ro = {
> @@ -244,12 +258,14 @@ static const struct kernfs_ops sysfs_prealloc_kfops_ro = {
>  static const struct kernfs_ops sysfs_prealloc_kfops_wo = {
>  	.write		= sysfs_kf_write,
>  	.prealloc	= true,
> +	.write_unlocked	= true,
>  };
>  
>  static const struct kernfs_ops sysfs_prealloc_kfops_rw = {
>  	.read		= sysfs_kf_read,
>  	.write		= sysfs_kf_write,
>  	.prealloc	= true,
> +	.write_unlocked	= true,
>  };
>  
>  static const struct kernfs_ops sysfs_bin_kfops_ro = {
> diff --git a/include/linux/kernfs.h b/include/linux/kernfs.h
> index 351a5101c..cbb09f953 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -272,6 +272,7 @@ struct kernfs_open_file {
>  	char			*prealloc_buf;
>  
>  	size_t			atomic_write_len;
> +	bool			write_unlocked;
>  	bool			mmapped:1;
>  	bool			released:1;
>  	const struct vm_operations_struct *vm_ops;
> @@ -320,6 +321,16 @@ struct kernfs_ops {
>  	 * ->prealloc.  Provide ->read and ->write with ->prealloc.
>  	 */
>  	bool prealloc;
> +	/*
> +	 * "write_unlocked" indicates that ->write() does not require
> +	 * per-open-file serialization with of->mutex and can be called
> +	 * concurrently for the same open file. Callbacks must handle
> +	 * concurrent execution. Buffer access for preallocated attributes
> +	 * is still protected by of->prealloc_mutex. Lock dependencies from
> +	 * callers (such as pipe locks during splice) or within callbacks
> +	 * remain outside this scope.
> +	 */
> +	bool write_unlocked;
>  	ssize_t (*write)(struct kernfs_open_file *of, char *buf, size_t bytes,
>  			 loff_t off);
>  
> 
> 
> base-commit: 93f51579e7df248780214094418f205253383cc5
Please delete the line Fixes: f2d6c2708bd8 ("kernfs: wire up ->splice_read and ->splice_write") from the end of the commit description. This is a change to the description text, not to the Fixes tag. The v4 description still ends with that line, and the correct tag Fixes: 1e8c813b083c ("PM: hibernate: don't use early_lookup_bdev in resume_store") is added below the description separately, so the mail now carries two Fixes lines with a blank line between them. f2d6c2708bd8 only restored splice on kernfs files, which gives the &pipe->mutex --> &of->mutex half of the chain. The cycle needs the path lookup under of->mutex that 1e8c813b083c added to resume_store(), so 1e8c813b083c is the only correct target. The description should end with the paragraph about the known limits and contain no Fixes line.

Apart from the two comments below, keep the code of v4 unchanged, including kernfs_write_active(), the write path in kernfs_fop_write_iter(), the write_unlocked flag in struct kernfs_ops and its cached copy in struct kernfs_open_file, the four sysfs tables that set it and the comments in include/linux/kernfs.h and fs/sysfs/file.c. Keep the subject and keep the patch limited to kernfs and sysfs. The dependency that remains when a pipe is spliced straight into a sysfs attribute will be addressed by a separate autofs patch, so please do not add autofs, splice or task_struct changes.

In the same revision, please also replace the comment above the lock in kernfs_fop_write_iter() with the text below. The v4 comment still begins with the old statement that of->mutex keeps the ops of one open file apart, and in the added sentence "such a file" refers back to a file with write_unlocked clear, which is the case where the mutex is taken, so the sentence can be read the wrong way round.

	/*
	 * @of->mutex nests outside active ref and keeps the ops of one open
	 * file from running concurrently.  ->write() of files with
	 * ->write_unlocked set does not need that and runs without it.
	 */

Please also add this comment directly above kernfs_write_active():

/* Call the ->write() operation of @of under an active reference. */

Finally, please use the body below for the commit message. It quotes the lock chain once instead of also naming the three locks in the sentence before it, and it describes the known limit as a ->store() that takes its own lock around a lookup. ->show() is not part of that limit.

Lockdep reports a circular dependency &pipe->mutex --> &of->mutex -->
&sbi->pipe_mutex. A splice between a pipe and a kernfs file calls
->write_iter() or ->read_iter() of the file with the pipe locked, and
kernfs takes of->mutex there. A write to /sys/power/resume runs
resume_store() under of->mutex, and its lookup_bdev() can trigger an
autofs mount request, whose autofs_write() takes sbi->pipe_mutex and then
the mutex of the daemon pipe.

of->mutex only has to keep the callbacks of one open file apart.
sysfs_kf_write() does not pass the open file to ->store(), and two opens
of the same attribute already run ->store() concurrently. Add a
write_unlocked flag to struct kernfs_ops, cache it in struct
kernfs_open_file next to atomic_write_len, and take of->mutex around
->write() only when the flag is clear. Set it for the regular sysfs
attributes. The preallocated buffer stays protected by
of->prealloc_mutex, and the other kernfs users keep of->mutex.

This does not remove every report through the autofs daemon pipe. A pipe
spliced straight into such an attribute stays locked while ->store()
looks up the path, and a ->store() that takes its own lock around a
lookup keeps that dependency.


-- 
Krystian Kaniewski
