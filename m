Received: from mail-ed2-f34.google.com (mail-ed2-f34.google.com [74.125.228.98])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29F9125392A
	for <syzbot@lists.linux.dev>; Mon, 28 Sep 2026 12:43:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.98
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790599421; cv=none; b=oXoEuJsNg4uh0EWgdC5HYUtCP+bTThYRG3SaDC4aVTziITUoPfOrTrNnBfv8bYReBYSeCAqeRt/HjdzmhavTvqbW6NzezvZ8kRpPxA+OSYTwQyUjAS6GJWr7XqXGkLIuNizYvXZMlf1/Vw602Bvbp+osQkDhoZ3guUY1vZllhp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790599421; c=relaxed/simple;
	bh=+/laJIysVPXmvyvNQaEYNjyRjHIaLgwVpPnho7XT4aE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D8Zt+uirTkN7z3K+Yzcb+ONqnfj0sju+o12u9dwh1/34mscsOz1XJAYcAujh/2WJaeai93eXUcmWBmEUw73chsyd/j+iYuWGxnprhARkanViEAM6/Ca61zRI4s9QxQ/Hg7l+vNNJNMGW59RvC2LMkbMQiT98zNyW3pXzjYm1ecw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B7eql9OJ; arc=none smtp.client-ip=74.125.228.98
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B7eql9OJ"
Received: by mail-ed2-f34.google.com with SMTP id 4fb4d7f45d1cf-6aaf8415866so3453876a12.0
        for <syzbot@lists.linux.dev>; Mon, 28 Sep 2026 05:43:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790599417; x=1791204217; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=wKtIjZ2VBMl4niuKypRfbcyCwob/grWRm3cIcqXsjkI=;
        b=B7eql9OJJPgESvCY/jCQX9HGfwH8KRjYqNFlJr9mGu/cRRZJLTFLpNMNHxlaAXS/tN
         3YmC7Xq/7KPsLwSSFfqDAmCmoVaYEr/oRA99CjDPkrNy+iGXtdTEV0ZyD9objjKQw2r1
         GV7+Y4qWUcNtE9509ariTV2V5S1KsYmVByAi+XETkn9Go5JiTgrRW3xGwKUkOozhJb74
         UENbUYk8nck0U2VSghTXO81a27AOtQl3g2NfOm3y78Uq0qEPwk0aua/UtDHwQrFs2QzL
         i7Bipx3yKOvkMZ5nSQfKe1vTuBjECfO6x9LHChZkjcrcS/cnl35iUI2ldZnh37QfTwXl
         wntQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790599417; x=1791204217;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=wKtIjZ2VBMl4niuKypRfbcyCwob/grWRm3cIcqXsjkI=;
        b=wJaWLQFXOY+hyBPkhvRWnbu/FgTsRFIfMP0BYXI9j5GFORWWlxAD34DPcBdRgBwbwF
         8xGqxDTOKEY5UKwgjysk6twPZ0fl7Wf3h9LMdbPC2xl1JXokX9cr60WnG3VdllWyC8Jx
         7K09XH0Ry+6a70DcpvNrJSoT2CnO0BV43zsbYRneGCV+Ur1b76evTtfMK+dBduyB8a5X
         zIntOu7OLvPfZvIhT5fdO0K4PcbgdXREq4fWozVQxV05Ez0+zDwHqe1HKRqm9QxQl3Gn
         o6WyNhQwkUVsSRRREhiDnQmZwx+VQ+6OYx/HZon6YTANkcaWqcKv3XGzS4rKa/Rh8J/j
         myKw==
X-Gm-Message-State: AFq9FYL5UnJFzxjikPkkIYzCpBWjk+/l+RVnukevqu1V78qMhrby3zV6
	sIFgy7V4fS7JByndj7+JbVTh6fiFnUvpxtbteV3OPfbILitN8yQcaQv1
X-Gm-Gg: AYBFou3zMmhVaS++CHNgAN1L3O0wH7gpVAhE9iPBGRD6lnoSdWXS6+bhiq/y53/u+9A
	d+tlQpzTj4M5cBBy/fEdonemF6sHWprUAqsag6QrbQno+ghPEyAnAJn4NB821yh9KZ0mXp0z2aY
	VhJdTl0pQItHrdmZpc8S9OuudBSeN4naUHNCwmQqaLRsg0zllrs+z/uroUg+yRe/JxkPdDXCI4C
	2TI4tUP4pKORlPg7yfH3J88HaRvT2bQmAMmakuMYeCzXrblFZYvEbMPfpZ69IELvdm0cP7BwhP5
	/nwy5kUHFgNcyBh7JvwpNdXyVUNFixgXqI5GQJZ4weEUslzxs+BI/9X0Cm/WNxePZd/W1R48rjx
	ZS3ihIC+xESdebiAY5DGNkM6lAPgzrsR/gwqir5P22y6Y19hsHeFHqLVE/BfIQ1hxHZ2JX1JvHZ
	NdvhkoLjbv0ld06Y00WES4yw/CoZdJnb/JnXwI+ZRoC2tUbFmyW8Jw8le8zlAEvAGydf4qyjBk2
	fEY4U0MGhP4zgMtJO0bMy3kRJ1zHrn8g/1TY2LoCo53vEqSvIu54hstW5/Yrbah8thFVEk2jxyy
	bnorWwFKCHGVU/Jc8l3CkhEf7p+5l0bq2GyUoQT88MGA9NF91tt/10PQ/dYXsS6SJSHKqYpAGEU
	QeRjHYZm39tXtft7HWpYDvQ7eb1fHpOaOs6AaNL4LxPbM
X-Received: by 2002:a05:6402:21c2:b0:6aa:7ff:4ebf with SMTP id 4fb4d7f45d1cf-6aac8ef938fmr8792836a12.15.1790599416929;
        Mon, 28 Sep 2026 05:43:36 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aaee5496b3sm3776301a12.11.2026.09.28.05.43.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 05:43:36 -0700 (PDT)
Message-ID: <5e1cbe45-6686-4ffc-9f3c-428fbf750856@gmail.com>
Date: Mon, 28 Sep 2026 14:43:35 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v5] fat: validate dotdot buffers in VFAT and MSDOS
 rename and rollback
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <4372e7d7-6a96-414a-9247-48d869db66da@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <4372e7d7-6a96-414a-9247-48d869db66da@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/25/26 20:10, syzbot wrote:
> During cross-directory rename operations with synchronous directory updates
> enabled in VFAT and MSDOS, updating the ".." directory entry writes the
> buffer via sync_dirty_buffer(). If this write fails due to an I/O error,
> the block layer clears the BH_Uptodate flag. When rename enters its error
> rollback path, it attempts to update the ".." directory entry again with
> the same buffer head, which calls mmb_mark_buffer_dirty() and triggers a
> "!buffer_uptodate(bh)" warning in mark_buffer_dirty().
> 
> Fix this by introducing fat_update_dotdot_de() and
> fat_sync_update_dotdot_de() in fs/fat/dir.c, used by both VFAT and MSDOS
> cross-directory rename and rollback paths. The helpers lock the buffer head
> and check buffer_uptodate() before modifying the entry. If the buffer is
> not uptodate, unlock it and return -EIO, preventing mmb_mark_buffer_dirty()
> from being called on a non-uptodate buffer. fat_sync_update_dotdot_de()
> preserves the unconditional buffer sync in the MSDOS rename rollback path.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+b0aebd03565f5774f7f8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b0aebd03565f5774f7f8
> Link: https://syzkaller.appspot.com/ai_job?id=f915c371-eb83-48b9-af21-45cf1fd21ba0
> To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
> To: <linux-kernel@vger.kernel.org>
> To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
> 
> ---
> v5:
> - Removed Linus Torvalds from the recipient list
> 
> v4:
> - Introduce fat_sync_update_dotdot_de() to preserve unconditional buffer sync during MSDOS rename rollback.
> - Remove Linus Torvalds from the recipient list.
> https://lore.kernel.org/all/62b57eac-c2c6-4d5b-b5b6-c797b847c805@mail.kernel.org/T/
> 
> v3:
> - Move vfat_update_dotdot_de() to a shared fat_update_dotdot_de() helper in fs/fat/dir.c
> - Use fat_update_dotdot_de() in MSDOS cross-directory rename and rollback paths
> - Update commit subject and description to reflect both VFAT and MSDOS coverage
> https://lore.kernel.org/all/7ea246ae-9417-4507-920d-4afb771c59ac@mail.kernel.org/T/
> 
> v2:
> - Lock the buffer head and return -EIO if it is not uptodate instead of calling set_buffer_uptodate().
> - Update the patch subject to reflect buffer validation.
> - Shorten the commit description and remove the stack trace.
> https://lore.kernel.org/all/56341edb-4dc2-4683-9776-641253569bb3@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/012d4ac1-83f3-48af-8781-00fbbc4adc93@mail.kernel.org/T/
> ---
> diff --git a/fs/fat/dir.c b/fs/fat/dir.c
> index 35bdb6294..cee06e635 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -941,6 +941,40 @@ int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
>  }
>  EXPORT_SYMBOL_GPL(fat_get_dotdot_entry);
>  
> +static int __fat_update_dotdot_de(struct inode *dir, struct inode *inode,
> +				  struct buffer_head *dotdot_bh,
> +				  struct msdos_dir_entry *dotdot_de,
> +				  bool force_sync)
> +{
> +	lock_buffer(dotdot_bh);
> +	if (!buffer_uptodate(dotdot_bh)) {
> +		unlock_buffer(dotdot_bh);
> +		return -EIO;
> +	}
> +	fat_set_start(dotdot_de, MSDOS_I(dir)->i_logstart);
> +	mmb_mark_buffer_dirty(dotdot_bh, &MSDOS_I(inode)->i_metadata_bhs);
> +	unlock_buffer(dotdot_bh);
> +	if (force_sync || IS_DIRSYNC(dir))
> +		return sync_dirty_buffer(dotdot_bh);
> +	return 0;
> +}
> +
> +int fat_update_dotdot_de(struct inode *dir, struct inode *inode,
> +			 struct buffer_head *dotdot_bh,
> +			 struct msdos_dir_entry *dotdot_de)
> +{
> +	return __fat_update_dotdot_de(dir, inode, dotdot_bh, dotdot_de, false);
> +}
> +EXPORT_SYMBOL_GPL(fat_update_dotdot_de);
> +
> +int fat_sync_update_dotdot_de(struct inode *dir, struct inode *inode,
> +			      struct buffer_head *dotdot_bh,
> +			      struct msdos_dir_entry *dotdot_de)
> +{
> +	return __fat_update_dotdot_de(dir, inode, dotdot_bh, dotdot_de, true);
> +}
> +EXPORT_SYMBOL_GPL(fat_sync_update_dotdot_de);
> +
>  /* See if directory is empty */
>  int fat_dir_empty(struct inode *dir)
>  {
> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> index 61338413d..d51d3c11e 100644
> --- a/fs/fat/fat.h
> +++ b/fs/fat/fat.h
> @@ -339,6 +339,12 @@ extern int fat_scan_logstart(struct inode *dir, int i_logstart,
>  			     struct fat_slot_info *sinfo);
>  extern int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
>  				struct msdos_dir_entry **de);
> +extern int fat_update_dotdot_de(struct inode *dir, struct inode *inode,
> +				struct buffer_head *dotdot_bh,
> +				struct msdos_dir_entry *dotdot_de);
> +extern int fat_sync_update_dotdot_de(struct inode *dir, struct inode *inode,
> +				     struct buffer_head *dotdot_bh,
> +				     struct msdos_dir_entry *dotdot_de);
>  extern int fat_alloc_new_dir(struct inode *dir, struct timespec64 *ts);
>  extern int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
>  			   struct fat_slot_info *sinfo);
> diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
> index d46d1a385..31faaeae8 100644
> --- a/fs/fat/namei_msdos.c
> +++ b/fs/fat/namei_msdos.c
> @@ -527,14 +527,10 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
>  	}
>  
>  	if (update_dotdot) {
> -		fat_set_start(dotdot_de, MSDOS_I(new_dir)->i_logstart);
> -		mmb_mark_buffer_dirty(dotdot_bh,
> -				      &MSDOS_I(old_inode)->i_metadata_bhs);
> -		if (IS_DIRSYNC(new_dir)) {
> -			err = sync_dirty_buffer(dotdot_bh);
> -			if (err)
> -				goto error_dotdot;
> -		}
> +		err = fat_update_dotdot_de(new_dir, old_inode, dotdot_bh,
> +					   dotdot_de);
> +		if (err)
> +			goto error_dotdot;
>  		drop_nlink(old_dir);
>  		if (!new_inode)
>  			inc_nlink(new_dir);
> @@ -565,12 +561,9 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
>  	/* data cluster is shared, serious corruption */
>  	corrupt = 1;
>  
> -	if (update_dotdot) {
> -		fat_set_start(dotdot_de, MSDOS_I(old_dir)->i_logstart);
> -		mmb_mark_buffer_dirty(dotdot_bh,
> -				      &MSDOS_I(old_inode)->i_metadata_bhs);
> -		corrupt |= sync_dirty_buffer(dotdot_bh);
> -	}
> +	if (update_dotdot)
> +		corrupt |= fat_sync_update_dotdot_de(old_dir, old_inode,
> +						     dotdot_bh, dotdot_de);
>  error_inode:
>  	fat_detach(old_inode);
>  	fat_attach(old_inode, old_sinfo.i_pos);
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index da3e89c0b..56da78455 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -909,16 +909,6 @@ static int vfat_sync_ipos(struct inode *dir, struct inode *inode)
>  	return 0;
>  }
>  
> -static int vfat_update_dotdot_de(struct inode *dir, struct inode *inode,
> -				 struct buffer_head *dotdot_bh,
> -				 struct msdos_dir_entry *dotdot_de)
> -{
> -	fat_set_start(dotdot_de, MSDOS_I(dir)->i_logstart);
> -	mmb_mark_buffer_dirty(dotdot_bh, &MSDOS_I(inode)->i_metadata_bhs);
> -	if (IS_DIRSYNC(dir))
> -		return sync_dirty_buffer(dotdot_bh);
> -	return 0;
> -}
>  
>  static void vfat_update_dir_metadata(struct inode *dir, struct timespec64 *ts)
>  {
> @@ -981,8 +971,8 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
>  		goto error_inode;
>  
>  	if (dotdot_de) {
> -		err = vfat_update_dotdot_de(new_dir, old_inode, dotdot_bh,
> -					    dotdot_de);
> +		err = fat_update_dotdot_de(new_dir, old_inode, dotdot_bh,
> +					   dotdot_de);
>  		if (err)
>  			goto error_dotdot;
>  		drop_nlink(old_dir);
> @@ -1014,8 +1004,8 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
>  	corrupt = 1;
>  
>  	if (dotdot_de) {
> -		corrupt |= vfat_update_dotdot_de(old_dir, old_inode, dotdot_bh,
> -						 dotdot_de);
> +		corrupt |= fat_update_dotdot_de(old_dir, old_inode, dotdot_bh,
> +						dotdot_de);
>  	}
>  error_inode:
>  	fat_detach(old_inode);
> @@ -1103,14 +1093,14 @@ static int vfat_rename_exchange(struct inode *old_dir, struct dentry *old_dentry
>  
>  	/* update ".." directory entry info */
>  	if (old_dotdot_de) {
> -		err = vfat_update_dotdot_de(new_dir, old_inode, old_dotdot_bh,
> -					    old_dotdot_de);
> +		err = fat_update_dotdot_de(new_dir, old_inode, old_dotdot_bh,
> +					   old_dotdot_de);
>  		if (err)
>  			goto error_old_dotdot;
>  	}
>  	if (new_dotdot_de) {
> -		err = vfat_update_dotdot_de(old_dir, new_inode, new_dotdot_bh,
> -					    new_dotdot_de);
> +		err = fat_update_dotdot_de(old_dir, new_inode, new_dotdot_bh,
> +					   new_dotdot_de);
>  		if (err)
>  			goto error_new_dotdot;
>  	}
> @@ -1137,14 +1127,14 @@ static int vfat_rename_exchange(struct inode *old_dir, struct dentry *old_dentry
>  
>  error_new_dotdot:
>  	if (new_dotdot_de) {
> -		corrupt |= vfat_update_dotdot_de(new_dir, new_inode,
> -						 new_dotdot_bh, new_dotdot_de);
> +		corrupt |= fat_update_dotdot_de(new_dir, new_inode,
> +						new_dotdot_bh, new_dotdot_de);
>  	}
>  
>  error_old_dotdot:
>  	if (old_dotdot_de) {
> -		corrupt |= vfat_update_dotdot_de(old_dir, old_inode,
> -						 old_dotdot_bh, old_dotdot_de);
> +		corrupt |= fat_update_dotdot_de(old_dir, old_inode,
> +						old_dotdot_bh, old_dotdot_de);
>  	}
>  
>  error_exchange:
> 
> 
> base-commit: 93f51579e7df248780214094418f205253383cc5
Please correct the generated upstream recipient metadata. The changelog
says Linus Torvalds was removed, but the generated patch still contains
`To: "Linus Torvalds" <torvalds@ppc970.osdl.org>` and the job's Recipients
output still lists him. Remove that address from both. Keep
`To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>` and include
`Cc: linux-kernel@vger.kernel.org` and
`Cc: linux-fsdevel@vger.kernel.org` in the generated patch and recipient
output.

A failed synchronous write during cross-directory rename can clear
`BH_Uptodate` on the ".." buffer. Rollback must not dirty that buffer
while `BH_Uptodate` is clear. In this patch, the shared helper checks
`buffer_uptodate()` while holding the buffer lock, before changing or
dirtying the entry, for both VFAT and MSDOS. The MSDOS rollback path still
forces a synchronous write when the buffer is valid. Keep the code diff,
subject, technical commit message, `Fixes`, `Reported-by`, `Closes`,
`Link` and `Assisted-by` tags unchanged. Update the new revision's
changelog to describe the recipient correction.

-- 
Krystian Kaniewski
