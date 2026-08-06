Received: from mail-ej1-f46.google.com (mail-ej1-f46.google.com [209.85.218.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E094B33E360
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 14:13:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786025624; cv=none; b=NesvtJenLhKjDW8E1K/O8X+m+8LguRdne/fzA8j/v+L0Gy2v/EsawjonA/ajJPIiGmG07oKWGu1Crra18USmzg6qFHFWzsrBxeNeN+JhrYK3+FIRtmVo76z72zrxdd2INAgkOWZWQ7zolxtxMaWT21/1CnxCUlDsYo3xc1Nz7rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786025624; c=relaxed/simple;
	bh=YHlcFLILUGmAsJgb7w1WTd3sw6zHAPxBDFM0Tws2G1s=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Op0zOFxkFhozjSlZ+pIdAKYIRgzzzvJ0WVxU4pdobi2pBb+YVi9Wm00R+eMugkqfqXDsRQZhiPTXNMQp31nCTNlvnur4WoOgciYUQMgZkp+IFdRForcrT5LUgB62om83//AejCOBcbdlDVEU/G/pcSTJd4OSvOsl2eWKozaD7D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VstptyAq; arc=none smtp.client-ip=209.85.218.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VstptyAq"
Received: by mail-ej1-f46.google.com with SMTP id a640c23a62f3a-c160420289bso327451866b.0
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 07:13:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786025617; x=1786630417; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=C8if9re9mgFEN3kJKi2AbRKPR4XsTsHdGSRiXLSWeC8=;
        b=VstptyAqg5GZLTRhAC0b9boz2azxCK3+L9CDq4I4Kvz6RLB3fpiN2Kuw00n0sfdi8a
         OInaHAKRHpgpUnoUVyD3zLgeDb8wqEYFoi3pzbQJnxjopSVo5N6iLgNXAsPwISvPAWpz
         7dxWsFn7592TW71iocnRl53KX9uP9GHfFAYoj42wBsZPPGzD/84HtpQGawA5vJK7ynRq
         uK2VHlXj5l353eDZ9bQFjKJoF4aWgBYP15qHCejK004x6bQi18r/Y0u0EHkAKBylNlNH
         OOipp5w7LvxCzUrmdjZXKdzDsxjgdGOpMjAtb2tAGVRvSjwTAD7W8dC27E6ZlrI2t2iN
         yi6w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786025617; x=1786630417;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=C8if9re9mgFEN3kJKi2AbRKPR4XsTsHdGSRiXLSWeC8=;
        b=nJLkRqWuFPXhk4I8AtW4S+MPbMXH+ejrXhNO38dwGABqOVrSjraYR+kpOOKzMdYLv4
         FLaG5hfqL4eZuVJXD5eb0Y+fNPCQJwYJw/mWmLKEi0qPI01o8rxnt6bEkgMb7wRUd/2K
         pPRFyxaFt/AsFMr+H71PklvMPqnRZbr0ZPeOrV4ef2fZg9kJ6lp+nvej1Br2zikt7Az2
         U3ImxNN+7D/YoxdO1E17W0LIsGxkCJvaeiVoA4YHCbxFcO1aU3+lWX/x55JZsNz9Yzjy
         LjKVq7u490QWOYTky/pZ6wFrAKSn8GHIAtfPhhYNgfx6GVq3LjanX+RvhIwaQfOAlWYn
         8P0Q==
X-Gm-Message-State: AOJu0YywrZ+4KhCYuV2CrPNWZa3eZzD5q0vmz2VVVurj5BBuZ3oQDGHD
	BEFt4EYL6IPo3gigCehbPZ1KYEeiIkPmAQOPuWuAgaElmnEboTWUoXdJQ4Gvesj6
X-Gm-Gg: AR+sD11KVwm8/aXQGs7U3k12MAmetP2Pqo7hE/4wBcQVe+tr2XmonH4l0Br3Hd8WrTj
	JavqbMf7aJMXQGycuoxNPMb0JULU3UbA/KyNFpmO3E6YJWJzFmImgTO8x0g3/k/mIOS/eTMz0WS
	4s+/KIBJayLYSY4HyTYXFzsAor6PVfjGG42cWHJeF+wjA5yf0ebAlJ1UyQEk1t4fADDkcNfEk0R
	6Uhur9SuiiSPDIRi918I3oMIXss6DWupI8JgEss9ZA1SP4dwnzYjff+PfmJYG2u7B/r0MZTmvn/
	aXKQ2Ye5UmPPNlviViKdtRlplEf1CIhavcXxbEAWevFmoYkKnpFUh7g/r3aVHZVnZelS4wJKGgP
	ufL6qmjCK53zmIM+u4y09c9LIkrqF8UUnLsvt69yVYWDTyThko/KtK6BtwETmrPVb+RJL12CBEt
	n8738mYnvrCoGMX9EaYt+4Npr64Jx8/edv43I0bJyQHv6WdkGM9cGfj8pDcwhdMaVVSBW7mghnq
	2F0Tz+Cu/NhACCgwjw66vOT1qnQBlEbR0AppQskVA==
X-Received: by 2002:a17:907:8e98:b0:c19:5a94:4121 with SMTP id a640c23a62f3a-c2039b37b6cmr853138466b.6.1786025617075;
        Thu, 06 Aug 2026 07:13:37 -0700 (PDT)
Received: from [192.168.0.50] (93-159-20-152.cgnat.inetia.pl. [93.159.20.152])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c203645c087sm251648366b.58.2026.08.06.07.13.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 07:13:36 -0700 (PDT)
Message-ID: <d18d3ef1-83ba-48f4-b90f-66ff752ca50f@gmail.com>
Date: Thu, 6 Aug 2026 16:13:35 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] exfat: avoid setting SB_RDONLY directly on error
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <8a80967c-5201-4c6a-a2b2-521c49cd5e93@mail.kernel.org>
Content-Language: en-US
From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
In-Reply-To: <8a80967c-5201-4c6a-a2b2-521c49cd5e93@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

Two small things before it goes upstream:

1) Fixes tag. The rcu_sync_dtor() warning only becomes reachable once the
    filesystem can be frozen/thawed against a concurrent error; the syzbot
    cause bisection points at the shutdown ioctl. Please use:
      Fixes: f761fcdd289d ("exfat: Implement sops->shutdown and ioctl")
    instead of 772b29cca528.

2) Commit message. Please note why a *separate* flag is used instead of
    reusing EXFAT_FLAGS_SHUTDOWN: reads, fsync and writeback of 
already-dirty
    data must keep working (as they did with SB_RDONLY), so only modifying
    operations are rejected with -EROFS. This avoids a later 
"simplification"
    back to the shutdown flag, which would break reads with -EIO under the
    default errors=remount-ro.

Otherwise this looks correct; gating exfat_rename() at the entry and 
hoisting
the page_mkwrite() check are both fine.

On 06/08/2026 14:11, syzbot wrote:
> In exfat, an I/O error during sync_blockdev() triggers the error handler
> (__exfat_fs_error()), which directly sets SB_RDONLY without holding the
> s_umount semaphore. If thaw_super() is called after this, it sees the
> filesystem as read-only and skips releasing the freeze semaphores. When the
> filesystem is later unmounted and destroyed, the s_writers.rw_sem per-CPU
> rw-semaphores are freed while still held for write, triggering a warning in
> rcu_sync_dtor():
>
> WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0xcd/0x180
> Call Trace:
>   <TASK>
>   percpu_free_rwsem+0x43/0x80 kernel/locking/percpu-rwsem.c:42
>   destroy_super_work+0x217/0x310 fs/super.c:284
>   process_one_work kernel/workqueue.c:3322 [inline]
>   process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>   worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>   kthread+0x388/0x470 kernel/kthread.c:436
>   ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>   </TASK>
>
> Fix this by introducing an internal EXFAT_FLAGS_ERROR_RO flag instead of
> directly setting SB_RDONLY on error. This prevents confusing the VFS freeze
> logic and allows thaw_super() to correctly release the semaphores. We also
> add the exfat_check_writable() helper to check both EXFAT_FLAGS_SHUTDOWN
> and EXFAT_FLAGS_ERROR_RO, and use it to reject write operations when the
> filesystem is in an error-induced read-only state.
>
> Fixes: 772b29cca528 ("exfat: add misc operations")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+823cd0d24881f21ab9f1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=823cd0d24881f21ab9f1
> Link: https://syzkaller.appspot.com/ai_job?id=7b3f57df-f2f0-4b0d-a492-627c4efe465b
> To: "Namjae Jeon" <linkinjeon@kernel.org>
> To: <linux-fsdevel@vger.kernel.org>
> To: "Sungjong Seo" <sj1557.seo@samsung.com>
> To: "Namjae Jeon" <namjae.jeon@samsung.com>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Yuezhang Mo" <yuezhang.mo@sony.com>
>
> ---
> v2:
> - Dropped the fs/super.c changes to handle rollback of freeze on sync_blockdev failure.
> - Fixed the issue entirely inside exfat by introducing an internal EXFAT_FLAGS_ERROR_RO flag instead of directly setting SB_RDONLY.
> - Added exfat_check_writable() helper to check both EXFAT_FLAGS_SHUTDOWN and EXFAT_FLAGS_ERROR_RO.
> - Updated write paths in exfat to use exfat_check_writable().
> - Cleared EXFAT_FLAGS_ERROR_RO in exfat_reconfigure() when remounting read-write.
>
> v1:
> https://lore.kernel.org/all/fcc77fd9-e38f-49f9-8268-e86683444f29@mail.kernel.org/T/
> ---
> diff --git a/fs/exfat/exfat_fs.h b/fs/exfat/exfat_fs.h
> index 9be50949c..50846630e 100644
> --- a/fs/exfat/exfat_fs.h
> +++ b/fs/exfat/exfat_fs.h
> @@ -122,6 +122,7 @@ enum {
>   
>   /* Superblock flags */
>   #define EXFAT_FLAGS_SHUTDOWN	1
> +#define EXFAT_FLAGS_ERROR_RO	2
>   
>   struct exfat_dentry_namebuf {
>   	char *lfn;
> @@ -320,6 +321,15 @@ static inline int exfat_forced_shutdown(struct super_block *sb)
>   	return test_bit(EXFAT_FLAGS_SHUTDOWN, &EXFAT_SB(sb)->s_exfat_flags);
>   }
>   
> +static inline int exfat_check_writable(struct super_block *sb)
> +{
> +	if (unlikely(exfat_forced_shutdown(sb)))
> +		return -EIO;
> +	if (unlikely(test_bit(EXFAT_FLAGS_ERROR_RO, &EXFAT_SB(sb)->s_exfat_flags)))
> +		return -EROFS;
> +	return 0;
> +}
> +
>   /*
>    * If ->i_mode can't hold 0222 (i.e. ATTR_RO), we use ->i_attrs to
>    * save ATTR_RO instead of ->i_mode.
> diff --git a/fs/exfat/file.c b/fs/exfat/file.c
> index 5fc13378d..b6afeede2 100644
> --- a/fs/exfat/file.c
> +++ b/fs/exfat/file.c
> @@ -125,8 +125,9 @@ static long exfat_fallocate(struct file *file, int mode,
>   	if (!S_ISREG(inode->i_mode))
>   		return -EOPNOTSUPP;
>   
> -	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
> -		return -EIO;
> +	err = exfat_check_writable(inode->i_sb);
> +	if (err)
> +		return err;
>   
>   	inode_lock(inode);
>   
> @@ -354,8 +355,9 @@ int exfat_setattr(struct mnt_idmap *idmap, struct dentry *dentry,
>   	unsigned int ia_valid;
>   	int error;
>   
> -	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
> -		return -EIO;
> +	error = exfat_check_writable(inode->i_sb);
> +	if (error)
> +		return error;
>   
>   	if ((attr->ia_valid & ATTR_SIZE) &&
>   	    attr->ia_size > i_size_read(inode)) {
> @@ -738,8 +740,9 @@ static ssize_t exfat_file_write_iter(struct kiocb *iocb, struct iov_iter *iter)
>   	loff_t valid_size;
>   	int err;
>   
> -	if (unlikely(exfat_forced_shutdown(inode->i_sb)))
> -		return -EIO;
> +	ret = exfat_check_writable(inode->i_sb);
> +	if (ret < 0)
> +		return ret;
>   
>   	inode_lock(inode);
>   
> @@ -826,6 +829,11 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
>   	struct exfat_inode_info *ei = EXFAT_I(inode);
>   	vm_fault_t ret;
>   	loff_t new_valid_size, mmap_valid_size;
> +	int err;
> +
> +	err = exfat_check_writable(inode->i_sb);
> +	if (err)
> +		return vmf_fs_error(err);
>   
>   	if (!inode_trylock(inode))
>   		return VM_FAULT_RETRY;
> @@ -835,8 +843,6 @@ static vm_fault_t exfat_page_mkwrite(struct vm_fault *vmf)
>   
>   	if (ei->valid_size < new_valid_size) {
>   		if (ei->zeroed_size < mmap_valid_size) {
> -			int err;
> -
>   			/*
>   			 * Only zero the range that hasn't been zeroed yet for
>   			 * this mmap write path. zeroed_size tracks the largest
> diff --git a/fs/exfat/misc.c b/fs/exfat/misc.c
> index 6f11a96a4..ab875473f 100644
> --- a/fs/exfat/misc.c
> +++ b/fs/exfat/misc.c
> @@ -41,8 +41,8 @@ void __exfat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
>   		panic("exFAT-fs (%s): fs panic from previous error\n",
>   			sb->s_id);
>   	} else if (opts->errors == EXFAT_ERRORS_RO && !sb_rdonly(sb)) {
> -		sb->s_flags |= SB_RDONLY;
> -		exfat_err(sb, "Filesystem has been set read-only");
> +		if (!test_and_set_bit(EXFAT_FLAGS_ERROR_RO, &EXFAT_SB(sb)->s_exfat_flags))
> +			exfat_err(sb, "Filesystem has been set read-only");
>   	}
>   }
>   
> diff --git a/fs/exfat/namei.c b/fs/exfat/namei.c
> index b7d5e44ad..f08170de6 100644
> --- a/fs/exfat/namei.c
> +++ b/fs/exfat/namei.c
> @@ -547,8 +547,9 @@ static int exfat_create(struct mnt_idmap *idmap, struct inode *dir,
>   	int err;
>   	loff_t size = i_size_read(dir);
>   
> -	if (unlikely(exfat_forced_shutdown(sb)))
> -		return -EIO;
> +	err = exfat_check_writable(sb);
> +	if (err)
> +		return err;
>   
>   	mutex_lock(&EXFAT_SB(sb)->s_lock);
>   	exfat_set_volume_dirty(sb);
> @@ -765,10 +766,11 @@ static int exfat_unlink(struct inode *dir, struct dentry *dentry)
>   	struct inode *inode = dentry->d_inode;
>   	struct exfat_inode_info *ei = EXFAT_I(inode);
>   	struct exfat_entry_set_cache es;
> -	int err = 0;
> +	int err;
>   
> -	if (unlikely(exfat_forced_shutdown(sb)))
> -		return -EIO;
> +	err = exfat_check_writable(sb);
> +	if (err)
> +		return err;
>   
>   	mutex_lock(&EXFAT_SB(sb)->s_lock);
>   	if (ei->dir.dir == DIR_DELETED) {
> @@ -820,8 +822,9 @@ static struct dentry *exfat_mkdir(struct mnt_idmap *idmap, struct inode *dir,
>   	int err;
>   	loff_t size = i_size_read(dir);
>   
> -	if (unlikely(exfat_forced_shutdown(sb)))
> -		return ERR_PTR(-EIO);
> +	err = exfat_check_writable(sb);
> +	if (err)
> +		return ERR_PTR(err);
>   
>   	mutex_lock(&EXFAT_SB(sb)->s_lock);
>   	exfat_set_volume_dirty(sb);
> @@ -911,8 +914,9 @@ static int exfat_rmdir(struct inode *dir, struct dentry *dentry)
>   	struct exfat_entry_set_cache es;
>   	int err;
>   
> -	if (unlikely(exfat_forced_shutdown(sb)))
> -		return -EIO;
> +	err = exfat_check_writable(sb);
> +	if (err)
> +		return err;
>   
>   	mutex_lock(&EXFAT_SB(inode->i_sb)->s_lock);
>   
> @@ -995,9 +999,6 @@ static int exfat_rename_file(struct inode *parent_inode,
>   	int sync = IS_DIRSYNC(parent_inode);
>   	unsigned int num_extra_entries, num_total_entries;
>   
> -	if (unlikely(exfat_forced_shutdown(sb)))
> -		return -EIO;
> -
>   	num_new_entries = exfat_calc_num_entries(p_uniname);
>   	if (num_new_entries < 0)
>   		return num_new_entries;
> @@ -1267,6 +1268,10 @@ static int exfat_rename(struct mnt_idmap *idmap,
>   	if (flags & ~RENAME_NOREPLACE)
>   		return -EINVAL;
>   
> +	err = exfat_check_writable(sb);
> +	if (err)
> +		return err;
> +
>   	mutex_lock(&EXFAT_SB(sb)->s_lock);
>   	old_inode = old_dentry->d_inode;
>   	new_inode = new_dentry->d_inode;
> diff --git a/fs/exfat/super.c b/fs/exfat/super.c
> index 388db271c..dcb6e15e4 100644
> --- a/fs/exfat/super.c
> +++ b/fs/exfat/super.c
> @@ -807,6 +807,9 @@ static int exfat_reconfigure(struct fs_context *fc)
>   
>   	swap(*cur_opts, *new_opts);
>   
> +	if (!(fc->sb_flags & SB_RDONLY))
> +		clear_bit(EXFAT_FLAGS_ERROR_RO, &sbi->s_exfat_flags);
> +
>   	return 0;
>   }
>   
>
>
> base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
