Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E472E3D891B
	for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 09:32:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.216.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784539972; cv=none; b=VS81oCJiyNtqxKKR7mnYj0PgHXAlDfPyupv4f/49NCDskDlovIeHJvUnuKmY0Pcf27n3UvyFDrQb6RGhR7EtkhhSdH1C+EDulAY/1/A53U5A/VzM8mullPqt3uHImNXCYj5QItarbD71T7noUS9tYdnP5g6QBjYINO/QLbPZ3LY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784539972; c=relaxed/simple;
	bh=ueR/mC9lzRyLtMstvffYgOyUAn4hBg5sGk6Qp6B8nr8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nwejJEKkpse2aavI5dchZTNJ8Dd0/OpYgmxJV7YHD0BXyh9WR9H7mn3D9o5DMrKYZeywYFgJxBNGr7wp0rV1uyLKiBnMCTun450LjKjF7jJSiEIcgQEO+BAHncU6cF04PeLnGxfBJIUK4PC6dNeSlCmZm8ErEv+0LqXq4RdyraM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in; spf=none smtp.mailfrom=devineni.in; dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b=T0QolwDz; arc=none smtp.client-ip=209.85.216.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=devineni.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=devineni.in header.i=@devineni.in header.b="T0QolwDz"
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-38e88b60121so238671a91.3
        for <syzbot@lists.linux.dev>; Mon, 20 Jul 2026 02:32:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devineni.in; s=google; t=1784539969; x=1785144769; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=WhDoihhrNv4326ISIc0ZAl1JSr1iIX67Qw0O1FxtX90=;
        b=T0QolwDztKCIgg5dlx/2dAtB1myX6eNP9SeCJhkfk3iojMlywUm8S0noGZ6oPl3n9/
         hXfQ26vMOECLVdjicEUJbcumsGAMh110Zp7AajIIcltHjjbchuc1zP7RqgGoXDa4+qeM
         sssoolvdHMBtOM9DMHLUSeoAJSenEDlFH3b2ZVbE86MRPwUczj/+85+plouRyMCrB8GJ
         fUMOG3tMsZjPDWbptR9TytsATA7KIJySLq974g850Q4V8qdVrTboyzTCR6YUGG39Y/K6
         Wx8peGPFwrojwfzrxvRduBUUDoGy43C9n4JQ0iFi/GjQtp6mQbvMUdyyp6LKCDnWF6O1
         ztSg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784539969; x=1785144769;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=WhDoihhrNv4326ISIc0ZAl1JSr1iIX67Qw0O1FxtX90=;
        b=GshT+5MDLiv0sOBrN8oc9hb5TP4ut7IK/jPA5HzfTaLuUHiHAxJ6vvrguoBtp7RuaO
         EDS8iElsE8/zD6DbR0Jq6EPZGFG9vLikkbeZ32K4mmC5/iF/fkpmF86Gf5wdZwZKX0GI
         ktcgPD4wR/pRKh+nVQpzBYuqu9US+3U3WDBjaFtsyvUdeBUj19xV86AKcaRCyz0pHdv7
         KwCnsD1ydlkkRN0vRlZTqNLNG6rp8Cmgn0R2cjmnS2WmxtRDEbwOwgbV8J7R/hwZUtAX
         xRW2uKlRawkhsIpIOhnjSrhyTrBb//tgsFLZ3CSgUP28f3LYGic3EFf92omnf5usPJBo
         tGDg==
X-Gm-Message-State: AOJu0YxZ6uoFS/xJW5MlKE0jPiK9YeTL8n4xSp/2IkbqxUwuV1ReyXMW
	IiIGjXALjqYLmEc8i+O8Tr1VNZyVHJa39+RZEw+K68LrVv3FKuvX5XS4tkwLTTFDrA==
X-Gm-Gg: AfdE7cmgkzChNYxmFjVQodadUSF/GQSP4M5kH5zgRewD8pSz0EcNPY7SEdIvyMkx0VF
	i1OCT22hzrEDulTG7WmKVwR8jAYQPXiOImK7b9zkN4cFQECwZAX00cL98Mc9l9sJ1kxm+yRSeDN
	va15nQevcUBt/CXGDTOjCmdpyuB8zfDqhKs/5cwJmoVrjxgGvwdXPq7ENvrAE9u3zDGaT+uWrXz
	Q8wbqgvPHYf4pADkHAftqbvx9h48Z/jzZAJGnFg3QldYXeVEawVyg5rKsF2QJjad/XhZRncVWO3
	UhtxgdRg1NW01XsbZ9nc2Kz5rntU84Vux2723g5RVtFapSkewNefNKIfBmjejB/Vwf4lXuIiAnE
	0VMLowpa8D515bUofl06fLHGPGMeP9VkoxDeFITRUVmH1MYQhM8TiPRWDkxzfqBQQOZy+ou/j3d
	ibUYsAcELvtCITLvZgXASUZvAnC00EmilQBeugFkAxREi7qEIJugu4RYJT1G2Pvdj81zm5OxKoT
	81Ka0iWbOpwRA==
X-Received: by 2002:a17:90b:5588:b0:37f:9ce1:cdb1 with SMTP id 98e67ed59e1d1-38e4b55a662mr13478822a91.31.1784539969005;
        Mon, 20 Jul 2026 02:32:49 -0700 (PDT)
Received: from [192.168.0.100] ([49.205.99.55])
        by smtp.gmail.com with ESMTPSA id 98e67ed59e1d1-38e656e5686sm3528111a91.14.2026.07.20.02.32.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 20 Jul 2026 02:32:48 -0700 (PDT)
Message-ID: <0e95ceb3-40ee-41dc-b06a-7f7acbe703c2@devineni.in>
Date: Mon, 20 Jul 2026 15:02:46 +0530
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] fuse: abort connection on /dev/fuse flush to prevent
 deadlock
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <bedbc009-8806-4913-9a03-1b25b6d33729@mail.kernel.org>
Content-Language: en-US
From: Kusaram Devineni <kusaram@devineni.in>
In-Reply-To: <bedbc009-8806-4913-9a03-1b25b6d33729@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09-07-2026 08:00 pm, syzbot wrote:
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
> INFO: task syz.0.17:6117 blocked for more than 143 seconds.
> ...
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
> In fuse_dev_flush(), if this is the last reference to the file descriptor
> (file_count(file) == 1) and it is the last device for the FUSE connection,
> we proactively abort the FUSE connection. By aborting the connection
> synchronously in .flush, any subsequent fuse_flush() calls on FUSE files
> will immediately fail with -ENOTCONN instead of blocking indefinitely,
> avoiding the deadlock.
> 

the `list_is_singular()` test is incomplete. with two cloned `/dev/fuse` 
devices, both final `.flush` calls can run before deferred release 
removes either device; both see a non-singular list and neither aborts. 
track a per-`fuse_dev` `closing` state under `fch->lock`, and abort when 
all devices on the channel are closing, while preserving a still-open clone.

update the commit message to describe cloned-device handling, the 
fs-context install race, and that CUSE inherits the new `.flush` 
callback. avoid claiming that `file_count(file) == 1` plus a singular 
list universally identifies the last endpoint.

> Fixes: 4a9d4b024a31 ("switch fput to task_work_add")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> Reported-by: syzbot+0dbb0d6fda088e78a4d8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=0dbb0d6fda088e78a4d8
> Link: https://syzkaller.appspot.com/ai_job?id=2b6a3623-6dc9-49c8-ada9-03747a9847d2
> To: <fuse-devel@lists.linux.dev>
> To: "Miklos Szeredi" <miklos@szeredi.hu>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> diff --git a/fs/fuse/dev.c b/fs/fuse/dev.c
> index 5763a7cd3..89e2dea87 100644
> --- a/fs/fuse/dev.c
> +++ b/fs/fuse/dev.c
> @@ -2375,23 +2375,43 @@ static void fuse_dev_show_fdinfo(struct seq_file *seq, struct file *file)
>   }
>   #endif
>   
> +static int fuse_dev_flush(struct file *file, fl_owner_t id)
> +{
> +	struct fuse_dev *fud = fuse_file_to_fud(file);
> +	struct fuse_chan *fch = READ_ONCE(fud->chan);
> +

`READ_ONCE(fud->chan)` leaves a close/install race. an fs context holds 
a `fuse_dev` reference without holding the `struct file`, so final close 
can observe `chan == NULL` and a later `fuse_dev_install()` can still 
succeed. atomically transition `NULL` to `FUSE_DEV_CHAN_DISCONNECTED` on 
final close, or provide an equivalent state transition that makes later 
install fail. update `fuse_dev_release()` to handle that early sentinel 
safely and update the `fud->chan` state documentation.

> +	if (fch && fch != FUSE_DEV_CHAN_DISCONNECTED && file_count(file) == 1) {
> +		bool last;
> +
> +		spin_lock(&fch->lock);
> +		last = list_is_singular(&fch->devices);
> +		spin_unlock(&fch->lock);
> +
> +		if (last)
> +			fuse_chan_abort(fch, false);
> +	}
> +

keep queue removal, fasync cleanup, `fuse_conn_put()`, and normal 
resource destruction in `.release`; `.flush` should only publish closing 
state and abort the channel when every endpoint is closing. call 
`fuse_chan_abort()` after dropping `fch->lock`.

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

preserve the existing aligned `fuse_dev_operations` formatting and add 
only `.flush = fuse_dev_flush,`. the initializer reformat is unrelated 
churn.

>   };
>   EXPORT_SYMBOL_GPL(fuse_dev_operations);
> 
> 
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda

try validate at least: one device; duplicated fds; one open clone; two 
clones closed in one `close_range()`; close racing mount/install; CUSE 
close; fasync; and FUSE-over-io_uring abort. do not replace this with a 
fatal-signal check in `request_wait_answer()`; a client signal does not 
prove daemon loss, and request code must never set `FR_FINISHED` outside 
`fuse_request_end()`.

-kusaram

