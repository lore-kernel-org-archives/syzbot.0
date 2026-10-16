Received: from mail-ej1-f51.google.com (mail-ej1-f51.google.com [209.85.218.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 550AC418340
	for <syzbot@lists.linux.dev>; Fri, 16 Oct 2026 14:06:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792159593; cv=none; b=VIoWvNb4QdnKm1IVJuJlu2JVH09gI4DCXTZRsZ8e7Nei5EHJ0ypfoRaLwM3xKqh/VZckRjhNUM0p4iXHXbZdBzJQ6dW59wU4PH/T666VAf3vOSGTimGkDlYVsNGwae/bhQCj6j5MaNtin3awsp7p4qaX+ePv+Xjz+lEeL7BCDws=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792159593; c=relaxed/simple;
	bh=rgAvr5Edri+BVCuqUukG3JJFR9UW29lDs3l9R/QMh2M=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pDuROeFkmd2QI9/4pHnfZL4qBe1x6wwTAFw2tVewIzTd4FnlmKkts+oBFe7fQn7XwxSOiNLa0TbTnymj109F+bZplUvNoq653HxZRz0CdY0ut5x4RmAXbHECkEvTZ6FhdaFujJaRuOwTclLRNNA7zuYyTVpIMLSbT9CW7LAOFW8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B7sb+F+4; arc=none smtp.client-ip=209.85.218.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B7sb+F+4"
Received: by mail-ej1-f51.google.com with SMTP id a640c23a62f3a-c350db5a761so101422966b.1
        for <syzbot@lists.linux.dev>; Fri, 16 Oct 2026 07:06:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792159589; x=1792764389; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=vaBeYKiW+1GYts4IpJJpv18TIu0xYwW2oGWEbiTaeGE=;
        b=B7sb+F+4cjvJ2zj90QTKe1w32hbpAqmtpVRWebwn7cyc/wul7sQ2+EMGdPTuzVvCSr
         I/+NFxowvkIPgcws3T0eTTtRtfJ186LbT/JUZOWRc1BqxjmqzzvkucVDITbmYJHuJx8F
         baEUfEXg97v/djmIieCnZmtkyyBpGxRHxeJfKW+DkJaVXBQ7jbWfou0cXb7ZBiGg13Ps
         3+pth3w3oTsAiTiI+1Zl/GXvPeLuID2y0PFMHchFR0JdDIyq3qx5YqfJUl+alDcixbBM
         g09sX6cpnVZ2CwgUIKjU4Y+MzIjSpa2tbtR0h1vR1xEBl/2KjF5qe4vBWUwLmSvOduWE
         Qstg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792159589; x=1792764389;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=vaBeYKiW+1GYts4IpJJpv18TIu0xYwW2oGWEbiTaeGE=;
        b=vvjrwCrOCctQ7HuvP5LKq5RtlFMFfDypqqnw9iJhmWy3I+Sc8wJuhmHAEecZSPSecr
         kreFcYI8ppG4/JC3nWGk5vCXCMzOJ3U4+cwcZpd8LMzRrMs44Ld8I9RTw60YkHU+f5Q2
         I0ud0Tlwr12M+sSnXt7V2yGufff5Y9FdQAMv52bJZWo4S0zvfxrm8GsiuIBvAIZbIHHP
         u7/PpQsGt1YeHYZovO+qvZ44gUxPyz4lBgWjxIzLn9yzUceKz/JzJNWahj4AJcXrHemn
         nUM0Nje5B1NDhfQWYqbIHpSwvdDSYudfniiWTBwFkx+nWgDwKP8uN07QMZvQMKuM1fP+
         nzWg==
X-Gm-Message-State: AFq9FYKIqFnBAVHN1xLMA97E/qzthar3oZY5rTlEOuzYICR6/sw1ww0P
	WQAPZMirSnm/MYTfDJto1DkdSfaNA6lpMMm02iL2WgF7bAAyIa1/TyKqsRl563WJrQ8vLg==
X-Gm-Gg: AYBFou2oMju47c7XG8mUvegd/peNdLLAVHsYviZLUj1hbQOTI2qpTT7lcPRmEEfP3O2
	7pZfk2L3GPMWCbAF0nRVhlYfsQL/HYw+vCiXQj7baGtiOIw315bI4SXk7oMJK3W1qw6ZNZ/vhTi
	Dfzcuy9Jz1R6BhOuxhxvZmEnRnJ6jIsOkcSrEMrjfZ+xmC5LPQ3G72tOgUYInNce8hAPIUoJbMe
	vTF8FdypLhBxv8hnX3Dnk5HESTwI2j/rSpY/rvmv0QW94YjeuITA1Wdgcl81p1FjraIkatxxtpM
	bQWB05HmkJahyFB3iXEPne660MiEVqc1iTDW79itEhRBSaZ0M65CAFhuBOsnJD2Cp9tNu6LEcO7
	+WoAQerX+Yb/zJ2sfBXwc+BZ2inI1xDxAGyLnk/WTz24M1yj6pwqaqOBz7uTcf8EUq/EjdQM6zj
	+pas+pmCKXbWUaURRpqwgCmlryi27zYaM80maKDj+v/KLwHu3BK6k2Vztvy8VsfkudAwLon4gaP
	+0sBPvT4GAVXN/uY5eKb2DEqaJHyWjfWjORGprq/GXylhgmyod1wZ0TPbilZdz65BfUgPEbZP0g
	9CSqfoSkbNtEqWCzvNuac5PJYWwK69VE5sCeZhc+d+xcVzF7XdJdB2L+gjloxFfyTcYJSk7Cy3C
	sk5PAJzE6wcLXn7KFHRiNzIBUhSeu7RAqvQ==
X-Received: by 2002:a17:907:3e8d:b0:c26:36c4:858e with SMTP id a640c23a62f3a-c31aa018731mr2020263366b.25.1792159589294;
        Fri, 16 Oct 2026 07:06:29 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c40913c615esm72174866b.42.2026.10.16.07.06.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 16 Oct 2026 07:06:28 -0700 (PDT)
Message-ID: <ef248429-34f9-4819-9b1f-af07ef85b567@gmail.com>
Date: Fri, 16 Oct 2026 16:06:28 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] kernfs: do not hold of->mutex across sysfs
 ->store()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <c55e68c8-d895-4b6d-ad52-eedc0417562b@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <c55e68c8-d895-4b6d-ad52-eedc0417562b@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/9/26 20:08, syzbot wrote:
> A circular locking dependency was detected between &pipe->mutex (in struct
> pipe_inode_info), &of->mutex (in struct kernfs_open_file), and
> &sbi->pipe_mutex (in struct autofs_sb_info):
> &pipe->mutex --> &of->mutex --> &sbi->pipe_mutex
> 
> The cycle arises from two conflicting execution paths: splicing data from
> or to a pipe holds the pipe lock (&pipe->mutex) while invoking
> ->write_iter() or ->read_iter() on the kernfs file, acquiring of->mutex
> (&pipe->mutex -> &of->mutex). Conversely, a write to a sysfs file such as
> /sys/power/resume acquires of->mutex and calls resume_store(), which
> resolves paths via lookup_bdev() and kern_path(). Traversing an autofs
> mount during lookup invokes autofs_notify_daemon(), which acquires
> sbi->pipe_mutex and writes to the daemon pipe via __kernel_write(),
> acquiring pipe->mutex (&of->mutex -> &sbi->pipe_mutex -> &pipe->mutex).
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
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+002fb7b2d0bc53bf7e75@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=002fb7b2d0bc53bf7e75
> Link: https://syzkaller.appspot.com/ai_job?id=74fbf9ab-54e4-46c2-b9e9-7867573ff823
> To: "Danilo Krummrich" <dakr@kernel.org>
> To: <driver-core@lists.linux.dev>
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: "Rafael J. Wysocki" <rafael@kernel.org>
> To: "Tejun Heo" <tj@kernel.org>
> To: "Christoph Hellwig" <hch@lst.de>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v3:
> - Changed write_unlocked in struct kernfs_open_file from a bitfield to a bool
> - Expanded comments in kernfs.h and sysfs/file.c to clarify concurrency expectations and locking scope
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
> index 8e0e90c93..8084a858f 100644
> --- a/fs/kernfs/file.c
> +++ b/fs/kernfs/file.c
> @@ -333,9 +333,11 @@ static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>  	 * @of->mutex nests outside active ref and is used both to ensure that
>  	 * the ops aren't called concurrently for the same open file.
>  	 */
> -	mutex_lock(&of->mutex);
> +	if (!of->write_unlocked)
> +		mutex_lock(&of->mutex);
>  	if (!kernfs_get_active_of(of)) {
> -		mutex_unlock(&of->mutex);
> +		if (!of->write_unlocked)
> +			mutex_unlock(&of->mutex);
>  		len = -ENODEV;
>  		goto out_free;
>  	}
> @@ -347,7 +349,8 @@ static ssize_t kernfs_fop_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>  		len = -EINVAL;
>  
>  	kernfs_put_active_of(of);
> -	mutex_unlock(&of->mutex);
> +	if (!of->write_unlocked)
> +		mutex_unlock(&of->mutex);
>  
>  	if (len > 0)
>  		iocb->ki_pos += len;
> @@ -651,6 +654,8 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
>  	 * lockdep key, because the writable file /sys/power/resume may call vfs
>  	 * lookup helpers for arbitrary paths and readonly files can be read by
>  	 * overlayfs from vfs helpers when sysfs is a lower layer of overalyfs.
> +	 * (Note that regular sysfs attributes no longer run ->store() under
> +	 * @of->mutex, but other kernfs users still do.)
>  	 *
>  	 * All three cases look the same.  They're supposed to
>  	 * look that way and give @of->mutex different static lockdep keys.
> @@ -666,10 +671,12 @@ static int kernfs_fop_open(struct inode *inode, struct file *file)
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

Please restructure the write path in kernfs_fop_write_iter() so that of->mutex is not taken and released under repeated !of->write_unlocked checks. With this version, scripts/coccinelle/locks/mini_lock.cocci reports "fs/kernfs/file.c:363:1-7: preceding lock on line 337" for the conditional mutex_lock(&of->mutex). The locking is balanced, but the report is new compared to the base tree, and the coccinelle scripts are part of the usual kernel checks. One way to keep the behavior is to move the part between the lock and the unlock, that is kernfs_get_active_of(), the ->write() call or -EINVAL when there is none, and kernfs_put_active_of(), into a small helper that returns the result. kernfs_fop_write_iter() then calls the helper directly when of->write_unlocked is set and between mutex_lock(&of->mutex) and mutex_unlock(&of->mutex) otherwise, so the rule is written once instead of three times.

Keep the return values as they are (-ENODEV when the active reference cannot be taken, -EINVAL without ->write(), otherwise the value of ->write()), the update of iocb->ki_pos only for a positive result, of->prealloc_mutex around the preallocated buffer, the write_unlocked flag in struct kernfs_ops and its cached copy in struct kernfs_open_file, the four sysfs tables that set it and both splice methods. Keep the patch limited to kernfs and sysfs. The dependency that remains when a pipe is spliced straight into such an attribute, which the commit message names as a known limit, will be addressed by a separate autofs patch, so please do not add autofs, splice or task_struct changes to this one.

In the same revision, please also update the comment above the lock. It still says that of->mutex is used to make sure the ops are not called concurrently for the same open file, which is no longer true when the kernfs_ops of the file set write_unlocked. Say that of->mutex is only taken when write_unlocked is clear, and that ->write() of such a file can run concurrently for one open file.

In the commit message, keep only the trailer Fixes: 1e8c813b083c ("PM: hibernate: don't use early_lookup_bdev in resume_store") and remove the Fixes: f2d6c2708bd8 line. That line now ends the body and is separated from the tags by a blank line, so it is not in the trailer block either. Please also quote the lock chain once and explain its two halves once, without repeating parts of the chain in parentheses and without the struct names in the first sentence. Keep the reason why ->store() can run without of->mutex, the note about of->prealloc_mutex and the known limits. A possible body:

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
