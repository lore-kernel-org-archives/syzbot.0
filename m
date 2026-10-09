Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1E4B4D4896
	for <syzbot@lists.linux.dev>; Fri,  9 Oct 2026 12:52:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791550341; cv=pass; b=jF9owbDmgxSG61tg5tPuha2IBIwld0lmJYQh684hEaxh7SD2b7EDy+bXblIPN4rn1lTf7UEyAHDqWy190USIWqb0sR1ae+GiYZ/cb+EOJOIPEKLwvahSLZdWRAJ4cU3DTB12TSAJZ8cBveZrJ/UeVSOOWW355Vx+lnGBHgNjt54=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791550341; c=relaxed/simple;
	bh=U3mWVifhXmsedMAOuTNx0745DltQevrneWcCfBkFrk4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=mC1ECvlKhpEv+k2wIiQ1ImJbHn9CRdi/42Der4W8/q572IMOCMFOfEfllQkULc3Lmoah0O3Szlfjz1miG1ZB0Yd6xxlol4eg70Q9X+7bqp6gWQ05f6RCoCtVYzk3WnB5H5ce5nBNnSaDNw0jVZ/5HvlaCWRBh2Jtee+84DU8Dq8=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=fBGwED9o; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="fBGwED9o"
Received: by smtp.kernel.org (Postfix)
	id 22BDF1F00893; Fri,  9 Oct 2026 12:52:15 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.208.47
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1791550335;
	b=vdWbMaIvJFn7MOAPWnPzPvnfGZr5cFezT0FcmhrXs+2o6+DQ1kvSTlfPuw+I++UyND8U
	 2SGg1mhXxsz0PhCPNQaXsuU9RWRR+Sl3oUUgABbC1VkroKLV9tcsvUYcO1Rt5vnxALmSN
	 FralMIHsBOSf0u+IIfuSFzj4r5zgUgAg1k4NgC7r8Gfn/QmlDRBL7VlVI14CeFNM/gHG2
	 ZKPYPVMVsN1v6/xbKjEqW3YGaiyHm2MRW7XaYDLTvWR+Pxy1Np8cQ2tRMZ9KL6qoQsmkD
	 7llFFA4PqVUuiZco37vPOSOeNMdISXScTgg4HBcRPOeBUgwJ+A/4DR/pJAVROA1E+Zg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1791550335;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=AUsDGIO1ObMbqNmYlSxQRYtalG9ut+Z+xVGAxbmjTZc=;
	b=MI6/DkX77Bhl5eXaz2uXCxQZXmZAvC2aozkU+mNHCu7ahkPNmId42jXHKEwHU1aQEDBn
	 4Qsdgo6HsgFuqq1sMxaLltfPF8pzD4gpN7NO/cOQJ0Mm3RgF4sPTN4iZHnYX7xstV4JAU
	 FPwC3IkQob4h/6CGwBLY862d4WUPWNRsWwNlK37OKdBJZiDpD5mIojhLe4PdFmJ6tVBOC
	 3Ov6Pu7CEYu2gICZtdwrfMals2dvmfIu/a/0+ShWeTSHMdlF9ALgGfUvMQ0g3GHOd7z4r
	 TgiPXXdX9GqzkX5h8HT4pazgZx1NMud2r+fTZIi/UcXdZ/ww9eEnVMtdBPaSasb+mHA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fBGwED9o;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.208.47
Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 5E1E31F000FF
	for <syzbot@kernel.org>; Fri,  9 Oct 2026 12:52:14 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=fBGwED9o
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 5E1E31F000FF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6acb57c2b88so8949694a12.2
        for <syzbot@kernel.org>; Fri, 09 Oct 2026 05:52:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791550332; x=1792155132; darn=kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AUsDGIO1ObMbqNmYlSxQRYtalG9ut+Z+xVGAxbmjTZc=;
        b=fBGwED9o9r9ldnGtW4SX/wENqQMLEqLrgmLucacDohvHA2MXUIPVt5COM4zvvNiSQl
         2h0bB2NjxPbNaoYzI6QIEVHVvYxNHK2Oat4nn8ZBsRvxazgONmIpvXa8dVwGoIzU0nxe
         rWdHWORd0uBS4FI+FsTqNSlfkjXWpgTu1mUDR3ZGjZt4aTj3sOBl49UpHDAhppSZcnNd
         E7U6RYCqzKTQrdldqXXTF8SPrzQknyzMtnr9pJJRVqXvEkESOjSEN8XHQOeYCSenY6RT
         v1/b+ob2A8WjKHOI3U2L9SRd09D/0Y+E1KoTzCtspM+7f5yo5HXzngql45TG582OlWJ5
         kQpQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791550332; x=1792155132;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AUsDGIO1ObMbqNmYlSxQRYtalG9ut+Z+xVGAxbmjTZc=;
        b=RKGw0xBL2L9Fdr8rtf2S5+JRQCcsVOtkF19r/d6feTEJxb8VNZZi2aPT7lfkcqJrDq
         TRoGo/VLTqIfztihQ1/nMmKiKeJ7upF4icWp5Ua13RDJwpM5rQIcTIcgVQM5z+XmQ2MT
         r4n+B3dAZrFN4NMJdF1c96VioorVtUoIYDlN3yq/qb5VlSExTRclGuvf97ZOcRPY6u0/
         7Bcw2bYHGT7Db/UtZmldnG8ls+KrCX6y8AGs3DlrYsaDyV84SYsETJr4WQgaipPyWn8P
         j57L1rLPCHCa3ihjVu9+jTxP0+hv4+CHq2m4G9BkvxJerzGicRYF+6NtC9a4ihmXeEz5
         3nKA==
X-Gm-Message-State: AFq9FYIdWlS7S8yjzgs8q42Mf9SXO/Vw7+5YFQIXq6Y2U3BJiO5SrJ7c
	zTVxTHGr/ba65XDauPnZKArc2tr33TyHfue36a2FQ0KNz6DdU53M00MdtzIBdaHxGsaECQ==
X-Gm-Gg: AYBFou0CKIa5ceAzwwE00AhfhNSKlQvKZDp40TRzjx+iIg9S7sc2IVrdd6rUVjaVZSJ
	qN2yG7eUwn8yCuhPqbcV8MJ7nI7oTzx+E+sqCj8HMphlolkYp6d2W/E7qWoUxosTn3MzANqNDwT
	k2QNyws7lM6YEyfdoyiqseNfgr/dutahxJbKS5G5ed05dfpjZ/QWtI4uHAsDpZ6OremGwv54e0y
	xGYjrIKsl6yWrOpepv7xOTZ+ZAvbEPbJT7xdyHklvsfEeemn2i0dRW/sqVtptJ+MArKjPGEcM9v
	q8NVx7gUrT6sbY2qkXFqQlVJbwWRCvkBVylIlcWCJcyLAMLKLtND98iC+TWfKS/d45EkXpwhhlF
	QUKxOOw3VgTgQGuprjVgGB0Y9//zjAgwomXmT010yhSmUCLTqzsodaN9/2JmilNmB8RwBNPRSz6
	PpZgEcY8IYTiIjccAoqLdngp5D1rQvb0GuDnDaNWyvYrZgzvNaw9rSvon5razc1aMI0Gf+AnkVU
	OQ1MsNk5CepxVisPfhkgP6Uqb9AJm9z8u89IYVgap0wis+bnuCt11iNPAcFihGs8WcBxb0xxB4p
	8yzbtlgHTP5yLcaYPCChxqB3EaaCT/ViRrNnt5dl1iWhDjVUEJdG04hAZlvNeoiyA8Qq8umZUrN
	2zNtbF65lOCyJAffm+6muHrD0oeQ2ihEK3vOTcKi0W+EJ
X-Received: by 2002:a17:906:f592:b0:c26:19de:912c with SMTP id a640c23a62f3a-c31aa07ba07mr221714666b.31.1791550332231;
        Fri, 09 Oct 2026 05:52:12 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c31a9ae59f9sm86392466b.80.2026.10.09.05.52.11
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 09 Oct 2026 05:52:11 -0700 (PDT)
Message-ID: <63544210-d9ba-4f77-97d0-f4f1cd39d4d2@gmail.com>
Date: Fri, 9 Oct 2026 14:52:11 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] kernfs: do not hold of->mutex across sysfs
 ->store()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <bc6a8f1d-d7bf-43bf-80e2-c3489ded269a@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <bc6a8f1d-d7bf-43bf-80e2-c3489ded269a@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/8/26 19:15, syzbot wrote:
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
> Link: https://syzkaller.appspot.com/ai_job?id=8a561103-0443-4299-83d7-bc101cef8482
> To: "Danilo Krummrich" <dakr@kernel.org>
> To: <driver-core@lists.linux.dev>
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: "Rafael J. Wysocki" <rafael@kernel.org>
> To: "Tejun Heo" <tj@kernel.org>
> To: "Christoph Hellwig" <hch@lst.de>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v2:
> - Avoid dropping splice_write support in kernfs_file_fops.
> - Introduce write_unlocked flag in struct kernfs_ops and struct kernfs_open_file to run sysfs ->store() without of->mutex.
> - Update commit subject and description to reflect the new locking approach.
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
> index cd5bb0f9f..1a097e171 100644
> --- a/fs/sysfs/file.c
> +++ b/fs/sysfs/file.c
> @@ -132,7 +132,17 @@ static ssize_t sysfs_kf_read(struct kernfs_open_file *of, char *buf,
>  	return min_t(ssize_t, count, len);
>  }
>  
> -/* kernfs write callback for regular sysfs files */
> +/*
> + * kernfs write callback for regular sysfs files.
> + *
> + * Regular sysfs files set .write_unlocked = true and are called without
> + * holding of->mutex. Sysfs attributes do not rely on per-open-file
> + * serialization for writes, and calling ->store() without of->mutex avoids
> + * circular locking dependencies (such as &pipe->mutex -> &of->mutex ->
> + * &sbi->pipe_mutex -> &pipe->mutex) when ->store() performs operations like
> + * path lookups or automounts while a generic VFS lock is held. Preallocated
> + * attributes are still serialized by of->prealloc_mutex.
> + */
>  static ssize_t sysfs_kf_write(struct kernfs_open_file *of, char *buf,
>  			      size_t count, loff_t pos)
>  {
> @@ -229,11 +239,13 @@ static const struct kernfs_ops sysfs_file_kfops_ro = {
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
> @@ -244,12 +256,14 @@ static const struct kernfs_ops sysfs_prealloc_kfops_ro = {
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
> index 351a5101c..7cb7c248b 100644
> --- a/include/linux/kernfs.h
> +++ b/include/linux/kernfs.h
> @@ -274,6 +274,7 @@ struct kernfs_open_file {
>  	size_t			atomic_write_len;
>  	bool			mmapped:1;
>  	bool			released:1;
> +	bool			write_unlocked:1;
>  	const struct vm_operations_struct *vm_ops;
>  };
>  
> @@ -320,6 +321,11 @@ struct kernfs_ops {
>  	 * ->prealloc.  Provide ->read and ->write with ->prealloc.
>  	 */
>  	bool prealloc;
> +	/*
> +	 * "write_unlocked" indicates that ->write() does not require
> +	 * per-open-file serialization with of->mutex.
> +	 */
> +	bool write_unlocked;
>  	ssize_t (*write)(struct kernfs_open_file *of, char *buf, size_t bytes,
>  			 loff_t off);
>  
> 
> 
> base-commit: 93f51579e7df248780214094418f205253383cc5
Change the cached write_unlocked field in struct kernfs_open_file to a standalone bool, placed after atomic_write_len and before mmapped and released. The write path reads it before taking of->mutex or an active reference, including for files where the flag is false. The neighboring bitfields are updated at run time under of->mutex or the node mutex and share one C memory location with the added bitfield. A standalone bool keeps the cached flag separate from those mutable fields.

Keep the current write_unlocked approach and the same four regular sysfs write tables that opt out of of->mutex. Preserve both splice methods, active-reference handling, prealloc_mutex and the existing serialization for reads, binary sysfs attributes, cgroup and resctrl. Keep the explicit statement that existing autofs and callback-owned lock dependencies remain outside this narrow change. Preserve the Reported-by, Closes, Link and Assisted-by tags.

Also use only Fixes: 1e8c813b083c ("PM: hibernate: don't use early_lookup_bdev in resume_store"), removing the additional f2d6c2708bd8 tag. Update the write-path comment and the flag documentation to describe the concurrent-callback contract. Shorten the repeated lock-chain explanation while retaining the buffer protection and known limits. Keep the current balanced error-path unlock.

-- 
Krystian Kaniewski
