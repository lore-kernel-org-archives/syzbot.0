Received: from mail-wm1-f46.google.com (mail-wm1-f46.google.com [209.85.128.46])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 997FE442B2E
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 10:23:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.46
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786011782; cv=none; b=KY7BlsKQwk3rIkBkMqUEHN55FIcB51VHIiqsxZAa4up+r6IjU5Q00mTRp6UaknWOiZYyXo+j6wIh/OArRpG8iY84o4yfjkr4GbzzDdEUuRdofOtQmsJGQB9F9+nGsuc9m76H9FZOfCvsBjcotKLorhA0y64cR/k3RyUYMrsYVOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786011782; c=relaxed/simple;
	bh=cz1rIax4HdK3Q+8zotkZeBpjnqRkwx9DfZaaPbE71O8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=ag+EX4NBpFDq2DAbec++RpFCF27eg+Mq5Op5LgKEH26GSSIjLWgfSlYxyhJDIlw7Dm1OipcABJ4Nn2FZEiMQFv2KWrZIxglnkux9LRhhSWu3JgHgtj6uuIWS6Gm4rywsJI2OmyMywd8RHxaVyWFNSjXQkmiXh5XUkafpxPxTZ5E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=WJlSvzoa; arc=none smtp.client-ip=209.85.128.46
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="WJlSvzoa"
Received: by mail-wm1-f46.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso5848895e9.0
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 03:23:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786011779; x=1786616579; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=qj0yPKzqGKmzNhugiOnYe4ZzunUc1YvJQIftk1BTkO4=;
        b=WJlSvzoaKaCI92GgURT7kNZ8OwDQ/sZ8h6gKKsLOXJtZOQ2Jfpl8IRgRYAeEDewtRg
         Qw5yRRTkL5WLi9In7tGI44hNEJya2Q77+zL5FNlJWmXB+0q/ZcO4+QDmlYoPtMRJ2tN7
         CAeh6AArWMaHsghb91O+K+jwOY0RztO10aHBKOwva4EIq6mOrBiDNaamsXR3Yz5PoZLI
         QAcoQTumu1xpqpoImPYLsGonNGqJre8ScU9zXnE7WRjcmNy3j7VCF7sBhgP07j7/23ZH
         9u54w1lj34HI0J5Ug8x6yPQOragVbh2LkzCm+LKtAYRdWTABXVso5MG4DzXqXBUzCBLs
         qHSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786011779; x=1786616579;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=qj0yPKzqGKmzNhugiOnYe4ZzunUc1YvJQIftk1BTkO4=;
        b=d/x03fvFfDfSIiW83AqABhL07iDtiLU5pqm8FejIsoWgTm4z+K2W3qd6wy1h64m7vu
         DrI0CaZnCnN6uxf4qb2TLPKT0J9amnUs/g6plyYVkrQEBbagyd9C/aKSQiq1jRonuUaH
         1JPtZQADphtWTClNlrMu0SV5I0JcU2pZkDPE9/8jHDdD0iE25aYJZA8TLGcW/pqNeeOS
         AwOgbEk8B7YSN+YvehwRWzu1Z+ycsKu05UwdAdKNtdfQ0CV9yqYNqfDwG1gk/oBZqOBK
         Dxvo0+zpogj6taknuZjAFfcn1O4HAIi2hX9sXIT/2G0L3DWVSPNOTpPBlJ2IPgwMHDo8
         lScw==
X-Gm-Message-State: AOJu0YzcHN0gk2ogCs2B+FJuFCGCL7WW93qCXvzw1c2AdDKIr8IHRNOt
	xbWQH0j7aJiypwfWUSUxR+u20sPXeTGkP0mEPkodsgM/uSW+ip+7YP3LVbonl083
X-Gm-Gg: AR+sD11kvGBRRqp4udOq97l5i8LXbox83CzKcnkMtuJT9CttgYNwDsYYwL/n+TDG+Bc
	aEPlaQnWymgbEKg2v4Trah7QF1Pe3JM1RdMy5euj9/8r5qDiAe9FrFqONfhB2C1UmE4QEvg/qwg
	PJdJkTpgFjWp8+ikT4j7dsZbWLConCvetRB8gA6fWhD/FmL5Lbj2PCGvQWG+smdynMOgPTy6hhG
	1CFwCSzpdFuHwNgNeEm15reHGi9b0bBzqqcxIbueLMgNTKKQdteAPYlrJQMQNYAqE92Y8PuLDkd
	XmfNm4Cum9pve533tG2nMRt0BGLWdq53SBoCRTib3nryR/RBjf6IKCiwwRJctEXLeNIQ8BuQYrO
	3MKBssZQXWVATIoi2WVJ+Hj0epTI8iylpCJAU+VDW6XUN0yX/V+cpTg3yzTrtHfTOc/FpIDgazN
	QlorNeUoC4/16ptuyyEcPPP4OYcHvP5UBnRWEdoW0jW0kVmwXK++Q63KV7XeY0YC2xreepyf1aW
	5W26X/OM5DllRAJAA4PJ5aC3dhHI9YO2po2dj5orA==
X-Received: by 2002:a05:600c:c173:b0:493:f783:c46a with SMTP id 5b1f17b1804b1-499553e1c83mr47669095e9.6.1786011778576;
        Thu, 06 Aug 2026 03:22:58 -0700 (PDT)
Received: from [192.168.0.50] (93-159-20-152.cgnat.inetia.pl. [93.159.20.152])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4994e98fdedsm121158235e9.4.2026.08.06.03.22.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 03:22:58 -0700 (PDT)
Message-ID: <0bf8d769-eeb5-4432-a807-4464df495e6b@gmail.com>
Date: Thu, 6 Aug 2026 12:22:57 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] fs: fix superblock freeze rollback on sync_blockdev
 failure
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <fcc77fd9-e38f-49f9-8268-e86683444f29@mail.kernel.org>
Content-Language: en-US
From: Uladzislau Zhauniarovich <uladzislau.zhauniarovich@gmail.com>
In-Reply-To: <fcc77fd9-e38f-49f9-8268-e86683444f29@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

The core idea is right — exFAT must not set SB_RDONLY on its own —
but this version has two problems and the fix should stay inside exfat.

1) Don't reuse EXFAT_FLAGS_SHUTDOWN.

Since commit 47e35366bc6f ("exfat: fix missing shutdown check"), the read
paths ->read_iter, ->splice_read, ->mmap and ->file_open all test
exfat_forced_shutdown() and return -EIO. Setting EXFAT_FLAGS_SHUTDOWN from
the error handler therefore breaks *reads* with -EIO and turns the default
errors=remount-ro into a full shutdown, which is a regression. It also
re-logs "Filesystem has been set read-only" on every subsequent error.

Please track the post-error read-only state in a *separate* superblock flag
(e.g. EXFAT_FLAGS_ERROR_RO) and fail only *modifying* operations with
-EROFS, exactly like ext4's EXT4_FLAGS_EMERGENCY_RO / ext4_emergency_state()
(commit d3476f3dad4a "ext4: don't set SB_RDONLY after filesystem errors")
and f2fs (commit 930c6ab93492). Concretely:

   - add a new flag EXFAT_FLAGS_ERROR_RO;
   - in __exfat_fs_error(), for EXFAT_ERRORS_RO, test_and_set that bit
     instead of "sb->s_flags |= SB_RDONLY" (log once);
   - add a small helper (returning -EIO on shutdown, -EROFS on error-RO) and
     call it at every modifying entry point only: ->write_iter,
     ->page_mkwrite, ->setattr, ->fallocate, and the namei ops create,
     unlink, mkdir, rmdir, rename;
   - leave ->read_iter, ->splice_read, ->mmap, ->file_open, ->fsync and
     writeback untouched, so reads and flushing of already-dirty data keep
     working just as they did with SB_RDONLY;
   - clear the flag on a read-write remount in exfat_reconfigure(), so the
     filesystem can be made writable again by remounting, as documented.

2) Drop the fs/super.c hunk.

It does not fix this warning. freeze_super() holds an s_active reference for
the freeze, so a superblock left frozen is never torn down — 
destroy_super_work()
does not run and the rcu_sync_dtor() splat cannot originate there. The 
actual
race is entirely inside exfat: __exfat_fs_error() flips SB_RDONLY without
sb->s_umount between freeze_super() (which took the s_writers 
semaphores) and
thaw_super_locked() (which re-reads sb_rdonly() and then skips
sb_freeze_unlock()). Fixing exfat alone is sufficient; please remove the
fs/super.c change and keep this exfat-only.

3) Fixes tag.

Use the cause-bisection commit:
   Fixes: f761fcdd289d ("exfat: Implement sops->shutdown and ioctl")
not 49ef8832fb1a.

On 20/07/2026 16:25, syzbot wrote:
> If sync_blockdev() fails during fs_bdev_freeze(), the superblock is left in
> a frozen state, but the block device is not. When the filesystem is later
> unmounted and destroyed, the s_writers.rw_sem per-CPU rw-semaphores are
> freed while still held for write, triggering a warning in rcu_sync_dtor():
>
> READ_ONCE(rsp->gp_state) == GP_PASSED
> WARNING: kernel/rcu/sync.c:177 at rcu_sync_dtor+0xcd/0x180
> kernel/rcu/sync.c:177, CPU#0: kworker/0:2/5024
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
> This happens because of two issues. First, in fs_bdev_freeze(), if
> freeze_super() succeeds but sync_blockdev() fails, thaw_super() is not
> called to roll back the freeze. Second, in exfat, an I/O error during
> sync_blockdev() triggers the error handler (__exfat_fs_error()), which
> directly sets SB_RDONLY without holding the s_umount semaphore. If
> thaw_super() is called after this, it sees the filesystem as read-only and
> skips releasing the freeze semaphores.
>
> Fix this by adding the missing thaw_super() rollback in fs_bdev_freeze()
> when sync_blockdev() fails. Additionally, modify the exfat error handler to
> set EXFAT_FLAGS_SHUTDOWN instead of directly setting SB_RDONLY, which
> prevents confusing the VFS freeze logic and allows thaw_super() to
> correctly release the semaphores.
>
> Fixes: 49ef8832fb1a ("bdev: implement freeze and thaw holder operations")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+823cd0d24881f21ab9f1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=823cd0d24881f21ab9f1
> Link: https://syzkaller.appspot.com/ai_job?id=431fcee8-0777-4619-a114-4a86af680864
> To: "Christian Brauner" <brauner@kernel.org>
> To: "Namjae Jeon" <linkinjeon@kernel.org>
> To: <linux-fsdevel@vger.kernel.org>
> To: "Sungjong Seo" <sj1557.seo@samsung.com>
> To: "Alexander Viro" <viro@zeniv.linux.org.uk>
> Cc: "Jan Kara" <jack@suse.cz>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Yuezhang Mo" <yuezhang.mo@sony.com>
>
> ---
> diff --git a/fs/exfat/misc.c b/fs/exfat/misc.c
> index 6f11a96a4..dbb3b2907 100644
> --- a/fs/exfat/misc.c
> +++ b/fs/exfat/misc.c
> @@ -41,7 +41,14 @@ void __exfat_fs_error(struct super_block *sb, int report, const char *fmt, ...)
>   		panic("exFAT-fs (%s): fs panic from previous error\n",
>   			sb->s_id);
>   	} else if (opts->errors == EXFAT_ERRORS_RO && !sb_rdonly(sb)) {
> -		sb->s_flags |= SB_RDONLY;
> +		set_bit(EXFAT_FLAGS_SHUTDOWN, &EXFAT_SB(sb)->s_exfat_flags);
> +		/*
> +		 * We have already set EXFAT_FLAGS_SHUTDOWN flag to stop all updates
> +		 * to filesystem, so it doesn't need to set SB_RDONLY flag here
> +		 * because the flag should be set covered w/ sb->s_umount semaphore
> +		 * via remount procedure, otherwise, it will confuse code like
> +		 * freeze_super() which will lead to deadlocks and other problems.
> +		 */
>   		exfat_err(sb, "Filesystem has been set read-only");
>   	}
>   }
> diff --git a/fs/super.c b/fs/super.c
> index a8fd61136..909d8b9ab 100644
> --- a/fs/super.c
> +++ b/fs/super.c
> @@ -1481,8 +1481,23 @@ static int fs_bdev_freeze(struct block_device *bdev)
>   	else
>   		error = freeze_super(sb,
>   				FREEZE_MAY_NEST | FREEZE_HOLDER_USERSPACE, NULL);
> -	if (!error)
> +	if (!error) {
>   		error = sync_blockdev(bdev);
> +		if (error) {
> +			if (sb->s_op->thaw_super)
> +				(void)sb->s_op->thaw_super(
> +					sb,
> +					FREEZE_MAY_NEST |
> +						FREEZE_HOLDER_USERSPACE,
> +					NULL);
> +			else
> +				(void)thaw_super(
> +					sb,
> +					FREEZE_MAY_NEST |
> +						FREEZE_HOLDER_USERSPACE,
> +					NULL);
> +		}
> +	}
>   	deactivate_super(sb);
>   	return error;
>   }
>
>
> base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f
