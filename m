Received: from mail-lf2-f13.google.com (mail-lf2-f13.google.com [74.125.229.205])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EFD973EC813
	for <syzbot@lists.linux.dev>; Fri, 25 Sep 2026 17:10:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.205
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790356246; cv=none; b=OO9s9Sz+8OjtLSJLu6QezD+OjTXpwO21CEpQaE5g0S3wqMfi1tN5vOIHd54PfBgW7+Fhg+5wxFYiFmNHidB7mRiaRbKg5O5RQm+xJbWggznBniSlonW3qEoHaDtQnSWVn07gdrib5utz28FAijqeXGPKah9w4KdDkYFkYwG/NBo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790356246; c=relaxed/simple;
	bh=ErnXaqzH+PbwR5FShEbUYsdojOoe6JDHQUQbGjTQAZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=b5T7iyX6JTHK24jHPYVFbOynmr71/ZCuIK2s1IFGHf0f/LkGrydIF0QV1Tt3Y0gFJGXUaUBd/6hWhZIA2jyMygYHsN0lQ9HBPoMqhxuc7L3w+xdwg4ToZ3sJzdjhZb8Met8XEoQjxLA/d0+5rliyUzt4y2RkVtLTvpubw7z5gYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=VBqQ3cHW; arc=none smtp.client-ip=74.125.229.205
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="VBqQ3cHW"
Received: by mail-lf2-f13.google.com with SMTP id 2adb3069b0e04-5b8ef09e288so49470e87.3
        for <syzbot@lists.linux.dev>; Fri, 25 Sep 2026 10:10:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790356234; x=1790961034; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=mFyaxtPItyeU6m7kUHaTOiWW4pFPnGS3OG6dA6ipDNU=;
        b=VBqQ3cHWO7Ig+/ESXqQuEMnErszHiokgpuwdXMR4mRITZGETmRcx2tKfjYie8GqoA3
         LQUeczWSi+7SAONB8ec3wjCnlDFH/ujj1KaNNA7bJip0hip9ntezVsz1Sxh7pPiYR86l
         gh3c8k+VUfQit3ptxk9yLIQttWSRVr+/MqgQ9vEM32iKIOVC+DJylEqVZRbHrRwr7NZ6
         ZRCl4BocaGzarB5UsqQZAfcgsqlIZ5RQoZIb4CN11tuX5dyk4A6hvv0EEY/Af5BNCxCO
         QzhmY/k1n+JTPFA4JIDo/QFkLB8cmJn9h0GGGhcc8L+dxcxs6cGJpxfudpZRjjpD9hIr
         6Z3w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790356234; x=1790961034;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=mFyaxtPItyeU6m7kUHaTOiWW4pFPnGS3OG6dA6ipDNU=;
        b=1ECoQ+sP1UgWHcRx0gH76WPvTzTB+0BbWCVvDU+SZI30Hhj3rSi9wluNasRCW3QfV6
         YOz8lxAQwX5dIJqpIQx82JsMPGC/e/RZeSLaF2Ur8OA6u7f1w7mOZ1Jd5R1KDi97yRLN
         0hIS0laUHO4wUhnz+dqIJ1C6clOCW3KjhOp13IvIBEKF2LUp+IIHUuDU1+A40qi+BLhJ
         r/d7uadxSPr8SG5QW3u1RUjdH2a3YNGJJkBWY1cLG23v4mxp3B4WhF75AlMd+XFxnZ8t
         0I35XFPfDp2bYhi73yw6CEFxChk4NwPJHPxfRVLszx4Ce0HEnDUR43XE72VYcfNkY/Eh
         yvfQ==
X-Gm-Message-State: AFuF++lwIhIOsvmFhMjQm72a+esWzO0Gw96yMBL82xcI3n4ralKyzlsR
	WJ6dDkHg6v6f0QLaCWD9sXOObx51eZfZpgAWMW78foysEK/qh3qv2QdGkpGNMcr4
X-Gm-Gg: AYBFou3wfMbjOKKB1+IEQMVvLEGheu/HmAw3G6/NFhSC/RQXYALt/2CinLauJPKiaU5
	l45JglLLwSYfI7jQSj+kifE6CdDpToeqhAH4UM8LUCI7yc6RAVfF+kRaLOQBOtcgtWp0xsJ22G0
	OfdvYTPmTrPxNZzdCbgfhta5tB1vvOTCP3VPhwdqpga+cp0pmn9WlJe64fue/AC721msZKAtfNb
	8Oywthz1FL+LyxOFGHjd4P8pOufkkhwfY96YeI46O8T4ODFSu8bpJcqxINm2s3jozKfeDd7KGGt
	Rfn/whAfywo5CzqKQyaWBtxtJxuJZdbrCEXb75W9VWj9RJa7ZH3oPOQMK+oVDzqcGZrqBCLSXXJ
	mbHomhek2DYyoP2xcDkkkycRUH8cIBgFOC+DtF+WTLlGQfCbBS0ZGQ1BQwJJdoSDj7rkfO/RZZ5
	JSscVugFoaO6G5oxrb4Nz5DtV3cWPvYkevouGppmIWahGH1Nrax2zd2GAvMq7qGHMIHZf+xQwRI
	V0tXZ6NyfCpBSMCjncJ5UUNg2aPTWRRFiG9QYeSJfUszCRMZt2r4j9vvgoh1TCq/MMdX1JnKOiT
	8b/L9h7R6lbT6VfaIg/ePMl253MmNm4U5tg3srl3RCGOqgpNMv3f159J7g7P0lyzuX8l4L2s3Oc
	2RCNTIJsZUsIusX1P1aaeuUFoXKd1a35ZMBJ3KIFUeZl20Q==
X-Received: by 2002:a05:6512:12d4:b0:5b8:d73d:e0d1 with SMTP id 2adb3069b0e04-5b8df040e4fmr2145594e87.6.1790356231920;
        Fri, 25 Sep 2026 10:10:31 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8e822851fsm636996e87.15.2026.09.25.10.10.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 10:10:31 -0700 (PDT)
Message-ID: <8666472c-59c2-44c0-9a64-0e3a432941d6@gmail.com>
Date: Fri, 25 Sep 2026 19:10:30 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4] fat: validate dotdot buffers in VFAT and MSDOS
 rename and rollback
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <62b57eac-c2c6-4d5b-b5b6-c797b847c805@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <62b57eac-c2c6-4d5b-b5b6-c797b847c805@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/2026 4:55 PM, syzbot wrote:
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
> Link: https://syzkaller.appspot.com/ai_job?id=634bf0ec-0ad6-471e-9708-11ee9b01c60b
> To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
> To: <linux-kernel@vger.kernel.org>
> To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
> 
> ---
> v4:
> - Introduce fat_sync_update_dotdot_de() to preserve unconditional buffer sync during MSDOS rename rollback.
> - Remove Linus Torvalds from the recipient list.
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
>   }
>   EXPORT_SYMBOL_GPL(fat_get_dotdot_entry);
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
>   /* See if directory is empty */
>   int fat_dir_empty(struct inode *dir)
>   {
> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> index 61338413d..d51d3c11e 100644
> --- a/fs/fat/fat.h
> +++ b/fs/fat/fat.h
> @@ -339,6 +339,12 @@ extern int fat_scan_logstart(struct inode *dir, int i_logstart,
>   			     struct fat_slot_info *sinfo);
>   extern int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
>   				struct msdos_dir_entry **de);
> +extern int fat_update_dotdot_de(struct inode *dir, struct inode *inode,
> +				struct buffer_head *dotdot_bh,
> +				struct msdos_dir_entry *dotdot_de);
> +extern int fat_sync_update_dotdot_de(struct inode *dir, struct inode *inode,
> +				     struct buffer_head *dotdot_bh,
> +				     struct msdos_dir_entry *dotdot_de);
>   extern int fat_alloc_new_dir(struct inode *dir, struct timespec64 *ts);
>   extern int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
>   			   struct fat_slot_info *sinfo);
> diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
> index d46d1a385..31faaeae8 100644
> --- a/fs/fat/namei_msdos.c
> +++ b/fs/fat/namei_msdos.c
> @@ -527,14 +527,10 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
>   	}
>   
>   	if (update_dotdot) {
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
>   		drop_nlink(old_dir);
>   		if (!new_inode)
>   			inc_nlink(new_dir);
> @@ -565,12 +561,9 @@ static int do_msdos_rename(struct inode *old_dir, unsigned char *old_name,
>   	/* data cluster is shared, serious corruption */
>   	corrupt = 1;
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
>   error_inode:
>   	fat_detach(old_inode);
>   	fat_attach(old_inode, old_sinfo.i_pos);
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index da3e89c0b..56da78455 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -909,16 +909,6 @@ static int vfat_sync_ipos(struct inode *dir, struct inode *inode)
>   	return 0;
>   }
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
>   static void vfat_update_dir_metadata(struct inode *dir, struct timespec64 *ts)
>   {
> @@ -981,8 +971,8 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
>   		goto error_inode;
>   
>   	if (dotdot_de) {
> -		err = vfat_update_dotdot_de(new_dir, old_inode, dotdot_bh,
> -					    dotdot_de);
> +		err = fat_update_dotdot_de(new_dir, old_inode, dotdot_bh,
> +					   dotdot_de);
>   		if (err)
>   			goto error_dotdot;
>   		drop_nlink(old_dir);
> @@ -1014,8 +1004,8 @@ static int vfat_rename(struct inode *old_dir, struct dentry *old_dentry,
>   	corrupt = 1;
>   
>   	if (dotdot_de) {
> -		corrupt |= vfat_update_dotdot_de(old_dir, old_inode, dotdot_bh,
> -						 dotdot_de);
> +		corrupt |= fat_update_dotdot_de(old_dir, old_inode, dotdot_bh,
> +						dotdot_de);
>   	}
>   error_inode:
>   	fat_detach(old_inode);
> @@ -1103,14 +1093,14 @@ static int vfat_rename_exchange(struct inode *old_dir, struct dentry *old_dentry
>   
>   	/* update ".." directory entry info */
>   	if (old_dotdot_de) {
> -		err = vfat_update_dotdot_de(new_dir, old_inode, old_dotdot_bh,
> -					    old_dotdot_de);
> +		err = fat_update_dotdot_de(new_dir, old_inode, old_dotdot_bh,
> +					   old_dotdot_de);
>   		if (err)
>   			goto error_old_dotdot;
>   	}
>   	if (new_dotdot_de) {
> -		err = vfat_update_dotdot_de(old_dir, new_inode, new_dotdot_bh,
> -					    new_dotdot_de);
> +		err = fat_update_dotdot_de(old_dir, new_inode, new_dotdot_bh,
> +					   new_dotdot_de);
>   		if (err)
>   			goto error_new_dotdot;
>   	}
> @@ -1137,14 +1127,14 @@ static int vfat_rename_exchange(struct inode *old_dir, struct dentry *old_dentry
>   
>   error_new_dotdot:
>   	if (new_dotdot_de) {
> -		corrupt |= vfat_update_dotdot_de(new_dir, new_inode,
> -						 new_dotdot_bh, new_dotdot_de);
> +		corrupt |= fat_update_dotdot_de(new_dir, new_inode,
> +						new_dotdot_bh, new_dotdot_de);
>   	}
>   
>   error_old_dotdot:
>   	if (old_dotdot_de) {
> -		corrupt |= vfat_update_dotdot_de(old_dir, old_inode,
> -						 old_dotdot_bh, old_dotdot_de);
> +		corrupt |= fat_update_dotdot_de(old_dir, old_inode,
> +						old_dotdot_bh, old_dotdot_de);
>   	}
>   
>   error_exchange:
> 
> 
> base-commit: 93f51579e7df248780214094418f205253383cc5

Please correct the recipient metadata in the next revision of this 
patch. The v4 change log says Linus Torvalds was removed, but the 
generated patch still contains `To: "Linus Torvalds" 
<torvalds@ppc970.osdl.org>`. Remove that `To` line from the generated 
patch email text and omit Linus Torvalds from its recipient list. Keep 
OGAWA Hirofumi and linux-kernel on the existing list.

A failed synchronous dotdot write can leave the buffer non-uptodate. The 
locked update check in this patch prevents that buffer from being 
dirtied again during rename rollback. Keep the reviewed code diff, 
subject, technical commit message, 
Fixes/Reported-by/Closes/Link/Assisted-by tags, and existing version 
history unchanged apart from any new revision note needed to describe 
this metadata correction. No code change or new test claim is requested.

