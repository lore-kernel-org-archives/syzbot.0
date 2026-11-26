Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795708013;
	b=D0Zu5XEAQIeDFhfGmgipcoUPQSNZMCmxxBbCK46bqGZnTWD8wNhNoqd8j+AWLenDmiDW
	 M+DiybkuVdpeI5xm+ml/a3Wnv0i/MLoOVncXnNvYze2HIe+1M/TOPf7O38V3dO29F8FmP
	 5OcAM6SL8R1keqfqQVf30SXgE/7ZwoaPEFIStYsHPJyTmFg1KNsTdtwPRiEd027M7SNTL
	 q9jLadrz9ZEqQvic6eFkr5B7Kaecv2ov/HbcetishdqQaMfrw6nyTTl5Q9ZsVKDJwEahc
	 vM6iXgm2NJJWJfRQduPGO+zC2YrsAfaavf6pKbOhbAYnFNOcbUTdqCUsVxZOvDYLS+w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795708013;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ZGkHlXREF/iDFfCK5NbzriXqiftYYvHejjpN79nTDo4=;
	b=hOR7dsSdq0nC1goM10PyXGj7TX/teawOcplNxbU4+ZbGPr62daMTdLCW09igcxOhZnos
	 5+UQ5NJyp92da8LGMjXzOV8vL4jDWlqYBY8CWfbEXuzh7bn/R7KyYqytAcWg0BTk5qcXW
	 3DfwapPEhgSyzxzN+l/hS8WW5+bp/Noy+DyLQrC6Qg/D9DZVUdQ7Iz/x8DMciSzKqiZRf
	 a2hOzyD10UGlOSxhKbB/AyQXtLGL44BTZ91izAdqE6Tbc0s/VFV+dU8FGhiAOQm7TwCVz
	 cGutIW2WaNcPeQX9+9kQmQeRoYuIFh+M6AavFB2pPgLp+aW7gyvfXp2M9C7ovb3ojqA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SCfCJsYT;
	arc=none smtp.remote-ip=209.85.208.48
Received: from mail-ed1-f48.google.com (mail-ed1-f48.google.com [209.85.208.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38782606A31E
	for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 15:46:53 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 38782606A31E
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=SCfCJsYT
Received: by mail-ed1-f48.google.com with SMTP id 4fb4d7f45d1cf-6bab10844b5so8063274a12.1
        for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 07:46:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795708011; x=1796312811; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZGkHlXREF/iDFfCK5NbzriXqiftYYvHejjpN79nTDo4=;
        b=SCfCJsYTJhuH0luKkqrdWHGMfIxCNTA7HK16g7yARzgGeai3sR4kuFe6oDw9sO3fzy
         411NQ2a3skKxxQd0TddZ198wFcCwjZ8a2D1+bJYVGUcDLAG0teR/7w6kxVD7I6MSqWd3
         Bz6oFSnJm/F9I8IHV1BPCulcdbgbL3go2gu03MFpeK1vxMua7KfbwJc5TmhvvzdpzVtB
         dVOkwBPzwmgh24Xmezb1O7LqUcP1H0T47RX7aOqZr035r4KGFn6UbEeNcgKEY92coIWk
         UbW3Mn35DZRsrqjTM8ayFnK0z6uIjUJ2bNq1nYh80wyWF9wH5b+6tLemxabZAsUi/FcP
         mZ7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795708011; x=1796312811;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZGkHlXREF/iDFfCK5NbzriXqiftYYvHejjpN79nTDo4=;
        b=qK7ekxavV4hNEjQ8P9oV+d/hCgfchObXHuDvjwVX3Mxuzv9gt9bIT9Dg1ZKWyNh1yF
         hrVOQbZALTWI4Txe3clYtDv7/JKUJ/myotFPqHkdCmn9FxJzWGAXPYaUlPlm68JSDWlD
         ZFp3FYOjG1Ael4WPz6jxV2i4t0HM0CgiaA7qnVIWfTSG0pn/a162ir+KVtrBCBQhlKFj
         NsbSGrz2nLxRKdlWpUm+8hxkA7kM96LNwbFy1/2jRjocLSpqAJ8zPlEAb0xJ7PIcLscP
         CtRXGdxH+h6p43gEG0ue1HpPdpcHacs6b0hYeum+1mtzVnZDBfPzRRc6t9gWUZcDCWqd
         Klyg==
X-Gm-Message-State: APuU4Z+rau0dNlH0B3/2tqZ+1oFNaxAF2Q/tnezOyiWoPfO34tJzl/zg
	CBsjT8AOWDcvVx3wQJ5eBW0XQ55/I26TDep7jMNzAx9+Zz55w86EjX9pedksycfGJMI=
X-Gm-Gg: AZFdTZfxEQDk0kcPikRhWisIbqA+mYtP93kshH5dqbEMp4J6TX3a4ADZtXr25WErXXn
	cKsia4rrAaNc601q99XvHMh4d3d/sCraplgVbDEI9j9tMr2FeSgduPTVl3EIA0UFDJpEPN3o0vX
	UVf/ZA76vNmZtbDKC4zuBEoSjLrDgc3Ila3sOSPB8gm1yJ7YtV5H0ZLDNlH/dPFqQWr59IFJppq
	S5BlFo4M2HH6tSm3BMQGa12myxFK0wnrGWnxdePHDQ92NJtVKui8P/ebGnJM257U/FZq8fyJanY
	14gMkmBNtTqTGHgXi/5tVG/J08LZW860d6cXksZ8oH+yQhgg5XY8ze2uleLRQvizzrHAp7GZlfn
	TF/oU+jRjKuGFMO4y1YmNJlpWbosrpRDF9hosKMxwEHnPxE9XO+b74nLc32JfiZqSSMLZGmwfUn
	Gl2kjjjOXxgVmzyWdHS/6FGFY1E00YsR9XItr0AUyFtKXNibk4oj9DvW1sDxdWoCmJ7Gvqh/6Rz
	OOWZYaKUF7Czy5+RKHy4n75ArX6GDyOL624ZTVaF8PYrTXfd9mcstGCA6GZPH6Ct7oa3T+tkrir
	SzWOoTPdBiXXD4XtAeJ5KPTmvIizGdlht7DCaMc77Xcj9ve8J6P9ZDPfTknobTkW++iMTvUEI9Q
	NFnnV2blI43NvClv6JC4lAQjqDGY3PgpVn/IihNTZx8yRInX4gWYuUAxEPJ8gpM1gYiZMmqBxLO
	0d+XA7y095jQxlJKd5OSxMKEc7IrlYx/CDyClEstNFc5EmYTSt72TNrVg+NBhMuAUCLwREC+Zy2
	WK4t8WTYUwR
X-Received: by 2002:a17:907:1c8f:b0:c50:9412:93f0 with SMTP id a640c23a62f3a-c51317e3208mr1842502266b.8.1795708011347;
        Thu, 26 Nov 2026 07:46:51 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513ae67bd3sm760182866b.27.2026.11.26.07.46.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Nov 2026 07:46:51 -0800 (PST)
Message-ID: <699282ee-e579-4eae-8a32-77610fdf9fe0@gmail.com>
Date: Thu, 26 Nov 2026 16:46:50 +0100
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] ima: annotate iint->mutex per filesystem type and
 stacking depth
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <3579fbbf-56d8-4607-b372-3ef99fd7b51a@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <3579fbbf-56d8-4607-b372-3ef99fd7b51a@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 11/24/26 19:23, syzbot wrote:
> ima_iint_lockdep_annotate() currently assigns a global lockdep class
> (`ima_iint_mutex_key[depth]`) indexed solely by
> `inode->i_sb->s_stack_depth`. Because of this, all non-stacked filesystems
> (`s_stack_depth == 0`) share the exact same lockdep class
> `&ima_iint_mutex_key[0]` for `ima_iint_cache::mutex`, allowing lockdep to
> falsely bridge lock dependencies between unrelated filesystems such as ext4
> and sysfs.
> 
> Specifically, creating an entry in an overlayfs directory acquires the
> overlayfs directory `inode->i_rwsem` (`&ovl_i_mutex_dir_key[depth]#2`) and
> then `sb_writers#4` on the upper ext4 superblock in `ovl_create_object()`.
> Opening an existing regular file on ext4 with `O_TRUNC` acquires
> `sb_writers#4` via `mnt_want_write()` in `do_open()` before calling
> `security_file_post_open()` -> `ima_file_check()` ->
> `process_measurement()`, which locks `iint->mutex`
> (`&ima_iint_mutex_key[0]`). When a custom IMA policy allows measuring sysfs
> files, opening `/sys/power/resume` with `O_RDWR` causes
> `process_measurement()` to lock `iint->mutex` (also classified as
> `&ima_iint_mutex_key[0]`) and read the sysfs file via
> `integrity_kernel_read()` -> `seq_read_iter()` -> `kernfs_seq_start()`,
> establishing `&ima_iint_mutex_key[0]` -> `&p->lock` -> `&of->mutex` (using
> the writable `of->mutex` lockdep class due to `FMODE_WRITE`). Writing an
> uncached path on the overlayfs mount to `/sys/power/resume` then holds
> `&of->mutex` in `kernfs_fop_write_iter()` while `resume_store()` ->
> `lookup_bdev()` -> `kern_path()` -> `lookup_slow()` acquires
> `&ovl_i_mutex_dir_key[depth]#2`, completing the false lockdep cycle:
> 
> WARNING: possible circular locking dependency detected
> is trying to acquire lock:
> ffff888076a38c50 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}, at:
> lookup_slow+0x46/0x80 fs/namei.c:1941
> but task is already holding lock:
> ffff88807a4fa480 (&of->mutex){+.+.}-{4:4}, at:
> kernfs_fop_write_iter+0x1d8/0x540 fs/kernfs/file.c:336
> which lock already depends on the new lock.
> 
> the existing dependency chain (in reverse order) is:
> -> #4 (&of->mutex){+.+.}-{4:4}:
>        kernfs_seq_start+0x5d/0x420 fs/kernfs/file.c:165
>        seq_read_iter+0x37e/0xca0 fs/seq_file.c:226
>        __kernel_read+0x4ca/0x960 fs/read_write.c:512
>        integrity_kernel_read+0x89/0xd0 security/integrity/iint.c:28
>        ima_calc_file_hash+0x451/0x890
>        security/integrity/ima/ima_crypto.c:280
>        ima_collect_measurement+0x51b/0xa00
>        security/integrity/ima/ima_api.c:300
>        process_measurement+0x1272/0x1c10
>        security/integrity/ima/ima_main.c:425
>        ima_file_check+0xdc/0x130 security/integrity/ima/ima_main.c:686
>        security_file_post_open+0xb3/0x260 security/security.c:2777
> -> #3 (&p->lock){+.+.}-{4:4}:
>        seq_read_iter+0xa4/0xca0 fs/seq_file.c:183
>        ...
> -> #2 (&ima_iint_mutex_key[depth]){+.+.}-{4:4}:
>        process_measurement+0x7d0/0x1c10
>        security/integrity/ima/ima_main.c:319
>        ima_file_check+0xdc/0x130 security/integrity/ima/ima_main.c:686
>        security_file_post_open+0xb3/0x260 security/security.c:2777
> -> #1 (sb_writers#4){.+.+}-{0:0}:
>        sb_start_write+0x48/0x1c0 include/linux/fs/super.h:125
>        mnt_want_write+0x41/0x90 fs/namespace.c:531
>        ovl_create_object+0x10d/0x3b0 fs/overlayfs/dir.c:717
>        lookup_open+0x102d/0x1ae0 fs/namei.c:4575
> -> #0 (&ovl_i_mutex_dir_key[depth]#2){++++}-{4:4}:
>        down_read+0x45/0x320 kernel/locking/rwsem.c:1574
>        lookup_slow+0x46/0x80 fs/namei.c:1941
>        lookup_bdev+0xc8/0x2b0 block/bdev.c:1268
>        resume_store+0x181/0x500 kernel/power/hibernate.c:1286
>        kernfs_fop_write_iter+0x3a4/0x540 fs/kernfs/file.c:345
> 
> Fix this by adding a per-filesystem-type array
> `i_ima_iint_key[FILESYSTEM_MAX_STACK_DEPTH + 1]` (guarded by `CONFIG_IMA`)
> to `struct file_system_type`, similar to the existing per-filesystem-type
> inode lockdep keys, and updating `ima_iint_lockdep_annotate()` to set the
> class of `iint->mutex` to `&sb->s_type->i_ima_iint_key[depth]`. This
> isolates `iint->mutex` across unrelated filesystems while preserving
> distinct lockdep classes for each stacking layer (including nested
> overlayfs mounts) and avoiding collisions at `FILESYSTEM_MAX_STACK_DEPTH`
> with non-stacked pseudo-filesystems that set `s_stack_depth =
> FILESYSTEM_MAX_STACK_DEPTH`.
> 
> Fixes: e044374a8a0a ("ima: annotate iint mutex to avoid lockdep false positive warnings")
> Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+da1d15f707a556f6e48c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=da1d15f707a556f6e48c
> Link: https://syzkaller.appspot.com/ai_job?id=a9eee2d2-a95f-4524-a3f7-213929fe8238
> To: "Christian Brauner" <brauner@kernel.org>
> To: "Dmitry Kasatkin" <dmitry.kasatkin@gmail.com>
> To: "James Morris" <jmorris@namei.org>
> To: <linux-fsdevel@vger.kernel.org>
> To: <linux-integrity@vger.kernel.org>
> To: <linux-security-module@vger.kernel.org>
> To: "Paul Moore" <paul@paul-moore.com>
> To: "Roberto Sassu" <roberto.sassu@huawei.com>
> To: "Serge E. Hallyn" <serge@hallyn.com>
> To: "Alexander Viro" <viro@zeniv.linux.org.uk>
> To: "Mimi Zohar" <zohar@linux.ibm.com>
> To: "Amir Goldstein" <amir73il@gmail.com>
> Cc: "Eric Snowberg" <eric.snowberg@oracle.com>
> Cc: "Jan Kara" <jack@suse.cz>
> 
> ---
> diff --git a/include/linux/fs.h b/include/linux/fs.h
> index 5b3a100ab..8fd02c303 100644
> --- a/include/linux/fs.h
> +++ b/include/linux/fs.h
> @@ -2323,6 +2323,9 @@ struct file_system_type {
>  	struct lock_class_key i_mutex_key;
>  	struct lock_class_key invalidate_lock_key;
>  	struct lock_class_key i_mutex_dir_key;
> +#ifdef CONFIG_IMA
> +	struct lock_class_key i_ima_iint_key[FILESYSTEM_MAX_STACK_DEPTH + 1];
> +#endif
>  
>  	struct lock_class_key d_lookup_key;
>  };
> diff --git a/security/integrity/ima/ima_iint.c b/security/integrity/ima/ima_iint.c
> index 00b249101..9372a2eec 100644
> --- a/security/integrity/ima/ima_iint.c
> +++ b/security/integrity/ima/ima_iint.c
> @@ -32,26 +32,26 @@ struct ima_iint_cache *ima_iint_find(struct inode *inode)
>  	return ima_inode_get_iint(inode);
>  }
>  
> -#define IMA_MAX_NESTING (FILESYSTEM_MAX_STACK_DEPTH + 1)
> -
>  /*
> - * It is not clear that IMA should be nested at all, but as long is it measures
> - * files both on overlayfs and on underlying fs, we need to annotate the iint
> - * mutex to avoid lockdep false positives related to IMA + overlayfs.
> - * See ovl_lockdep_annotate_inode_mutex_key() for more details.
> + * Annotate the iint mutex per filesystem type and stacking depth to avoid
> + * lockdep false positives across unrelated filesystems as well as between
> + * stacked filesystems (e.g. overlayfs, including nested overlayfs) and their
> + * underlying filesystems.
> + * See lockdep_annotate_inode_mutex_key() and
> + * ovl_lockdep_annotate_inode_mutex_key() for more details.
>   */
>  static inline void ima_iint_lockdep_annotate(struct ima_iint_cache *iint,
>  					     struct inode *inode)
>  {
>  #ifdef CONFIG_LOCKDEP
> -	static struct lock_class_key ima_iint_mutex_key[IMA_MAX_NESTING];
> -
> -	int depth = inode->i_sb->s_stack_depth;
> +	struct super_block *sb = inode->i_sb;
> +	struct file_system_type *type = sb->s_type;
> +	int depth = sb->s_stack_depth;
>  
> -	if (WARN_ON_ONCE(depth < 0 || depth >= IMA_MAX_NESTING))
> +	if (WARN_ON_ONCE(depth < 0 || depth > FILESYSTEM_MAX_STACK_DEPTH))
>  		depth = 0;
>  
> -	lockdep_set_class(&iint->mutex, &ima_iint_mutex_key[depth]);
> +	lockdep_set_class(&iint->mutex, &type->i_ima_iint_key[depth]);
>  #endif
>  }
>  
> 
> 
> base-commit: b6a9fa34ce4187cb69d3c588a4bbffc31ce5db8f
Please shorten the commit message and drop the Fixes tag. Keep the code
diff exactly as it is, both hunks are fine.

The message walks through the whole lock chain and then quotes about
forty lines of a lockdep report with addresses and offsets. That report
closes the cycle in resume_store() through ovl_create_object(), while
the syzbot report closes it in ovl_copy_up_start(). Both come from the
same class merge, but a maintainer needs the cause and the reason why
the new keys remove the false cycle, not a full trace of either run.
Plain text without Markdown backticks also reads better in git log.

The Fixes tag names e044374a8a0a ("ima: annotate iint mutex to avoid
lockdep false positive warnings"). That commit did not introduce the
problem. Before it, every iint mutex was in one lockdep class, so ext4
and sysfs inodes were joined already. That commit also went to stable,
so the tag would ask for backports to trees that do not have
security/integrity/ima/ima_iint.c. No single commit introduced this
false cycle, so please leave the tag out.

A message along these lines would be enough:

    ima: annotate iint->mutex per filesystem type and stacking depth

    ima_iint_lockdep_annotate() gives iint->mutex one lockdep class per
    stacking depth only. All non-stacked filesystems share that class,
    so lockdep joins lock chains of unrelated filesystems through it.

    syzbot hit such a false cycle with a custom IMA policy that
    measures FILE_CHECK. An O_TRUNC open of an ext4 file takes
    iint->mutex under sb_writers of ext4. An O_RDWR open of
    /sys/power/resume takes the iint->mutex of the sysfs inode and
    reads the file, which takes the kernfs of->mutex. A write of an
    overlayfs path to /sys/power/resume looks the path up under
    of->mutex, and overlayfs with an ext4 upper layer takes sb_writers
    of ext4 under its own inode locks. Lockdep reports a possible
    deadlock, although the two iint mutexes belong to inodes of
    different filesystems.

    Add lockdep keys for the iint mutex to struct file_system_type,
    next to the per filesystem type keys of the inode locks, and select
    the key by filesystem type and stacking depth.
-- 
Krystian Kaniewski
