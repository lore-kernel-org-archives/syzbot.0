Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D64A1DF980
	for <syzbot@lists.linux.dev>; Fri, 25 Sep 2026 12:34:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790339695; cv=none; b=cYgwRffSWj3phLRhpkhPOm9HhA4G3QNDOmPyluAOTcsydK+YQSCSKrf95QjqI5pCtnL6XyM7Oo7CJhz7NTnM12WZ9PfzOU0myrUkSCQNapelGw+Ephy7HguwxteH0c3K/MvX7KA3GKIPUg6U9VlJBvoCIP/Z7XbXjPPt0dEMXyY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790339695; c=relaxed/simple;
	bh=tuLjON/LeFKrbqNl2Tt46Q2diqNXs7hQtablZjbE1sU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=R6PX6WpJCgk68ZQpA+iQUXptm7+ufFmv8AJsHir83u0mytiQH0URLO1/bjZ9Ie2EB6lirXy6XKnr0jiaeK9KDA/4J/fk7JWmmyY7ONyJmUCdesOkXSB8gwIPrnRZ8GRDym+LPFaUXrRtJZeKfjdsylO3u7p7xrM2786cNRHZcps=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=PXyUoSs0; arc=none smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="PXyUoSs0"
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2af22f8e38so50198766b.3
        for <syzbot@lists.linux.dev>; Fri, 25 Sep 2026 05:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790339691; x=1790944491; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=UVidcYHK/d8UkmlWS+LdaX9V3F/ySepkNN6Bj5b0SKA=;
        b=PXyUoSs08MRIs8DurUN3cBaBmGVSgLCyuFk7UVwav269sKswdJLbbhnYw1p7SY621R
         leNZ5ejxsFqCqmDr+WmeTRl/LDOmh8mHJNdRr7fQp5XHfLm34/G5TtM9XnqgVs4t5B1P
         8Rs0MptIf01Dgs2lzSDM9g4DybDx0e2iChjg6qY3ov9s7W6oBrtPF9z7kw3B9DbVfMkU
         FNDXTqvn4i+4fyHm1ZMpyssxv6Qj0p8Ub/UfPwqWWttr7zOwDQrmm/bhsw4yqkTsBHsj
         iPGdkoWCv7Vr8NAeybGr/Xf1DsMOmb3u/v8dy91SpyV52oilxpY0HSSXJzxwj3QUcKLR
         kAJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790339691; x=1790944491;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=UVidcYHK/d8UkmlWS+LdaX9V3F/ySepkNN6Bj5b0SKA=;
        b=Rtp4+cJr0bOXgPtEYK6BKKmocQTKW9uiOQhQHU7NyC48oDQmclV/BKoy4agM11W8ia
         RrLLQA0MFEAI0Hy6nFZZp0q65XFv1MvRBO/FyD5h+beX8dty46vkXOddMaw/xlzai2Gh
         3dtTG8Jn9GM5f5Z1mUxpskq7Kwvd7wXheEn7n//FU9FayGst9IyIbnMLS4RVisgWqQXC
         M4/JfoVdtA3wMpL5t4/9P+g6AG2LwvzIJYGjonCj215/ghOQ7SbGWYayZ2YRQvQTF/Kp
         GLWcuTmWuPYTUw5ve2oF0z2djJMia/mHA1aFUvwn7MFdzgldYXJAv7NqOj7omj9LSfRR
         9fVg==
X-Gm-Message-State: AFuF++n2JA8Jz3//sfW7QCnTxAYYWYaw95KFVamP4zBPw4FU/ZZZw7CX
	lvRaW/12KamhJzNBxZIZEqTpqFeeqETqKUfCfKlPOIhR9ZyBp/qQPJZM
X-Gm-Gg: AYBFou2H4JLsIIIeNVYCSxTmHuMjk/wmStI8eXqUVzGIuX1K9QIZuX/bdftJ3oJTd+N
	43LIyjvG/YIPKEn9JrSLc2qIDYmubAke+icuWfSZ9DvC5YSBgV95jk2xLjd2b2xB4xGgVuMTOA3
	PCbGnxbkn+yo3SCCRVXirGNj7ts9oX9caAwUgw8gR+tfJdr/EXS0EwJK6w2uYZa4h7u0+sXsZm4
	EviaGvZOdD6OcDrJiBqB+tAuDCGWeM1yBwGmQuESmQe9MRVle7b2UMZ6spQVU3K4jAP5JMw2UxL
	nYTtvuTCWLdXFylCAmzJZ326Akf85l4pBF2zysWMbseHYEdKMbtkYjEbr8od9EF/4rw/ShjGdiH
	GoJ3fcV7x35gPvN3BK0AVvb98lbYPYVfwiM4kxkRIWWEwv4zRPsiXIlQJNmhv52g0LRy/3JADqG
	/Ad5pHfsCbS6qA/1hx+8i6qpBjBm1Uo+WcT7bJzE8gpBo3MSRmqdtYxLr6BkNARvSLwFhTEIHIR
	ZWrVbh03R+sD8QR1x/g1aOfqv1n6q+lsyvC2wFwrFdNL8bfNC8jMepHJzF67lY9ZSjTypASEUX7
	qlsMq6Ecix9/5isJrwDhZqO7MHX8Fu6NSF0warWGr/NSbayg9hwTbPOk0jK3FvVgDoQwqcyz4JW
	1/ZhU+yvZRdVaru51OlFelRxfqddf0y0hqCUdAaCc5uiplA==
X-Received: by 2002:a17:907:3e8c:b0:c2a:fcf5:c6bb with SMTP id a640c23a62f3a-c2afcf5f1e2mr12177866b.23.1790339691298;
        Fri, 25 Sep 2026 05:34:51 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2af8ac48ccsm22271566b.38.2026.09.25.05.34.49
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Sep 2026 05:34:50 -0700 (PDT)
Message-ID: <15d5037e-1cbf-4332-8d70-c3b425f8b632@gmail.com>
Date: Fri, 25 Sep 2026 14:34:49 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] fat: validate dotdot buffers in VFAT and MSDOS
 rename and rollback
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <7ea246ae-9417-4507-920d-4afb771c59ac@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <7ea246ae-9417-4507-920d-4afb771c59ac@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/2026 9:19 PM, syzbot wrote:
> During cross-directory rename operations with synchronous directory updates
> enabled in VFAT and MSDOS, updating the ".." directory entry writes the
> buffer via sync_dirty_buffer(). If this write fails due to an I/O error,
> the block layer clears the BH_Uptodate flag. When rename enters its error
> rollback path, it attempts to update the ".." directory entry again with
> the same buffer head, which calls mmb_mark_buffer_dirty() and triggers a
> "!buffer_uptodate(bh)" warning in mark_buffer_dirty().
> 
> Fix this by introducing a common helper fat_update_dotdot_de() in
> fs/fat/dir.c, used by both VFAT and MSDOS cross-directory rename and
> rollback paths. The helper locks the buffer head and checks
> buffer_uptodate() before modifying the entry. If the buffer is not
> uptodate, unlock it and return -EIO, preventing mmb_mark_buffer_dirty()
> from being called on a non-uptodate buffer.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+b0aebd03565f5774f7f8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b0aebd03565f5774f7f8
> Link: https://syzkaller.appspot.com/ai_job?id=a860bfca-0d0a-4ee1-ab62-38c1df430ba2
> To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
> To: <linux-kernel@vger.kernel.org>
> To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
> 
> ---
> v3:
> - Move vfat_update_dotdot_de() to a shared fat_update_dotdot_de() helper in fs/fat/dir.c
> - Use fat_update_dotdot_de() in MSDOS cross-directory rename and rollback paths
> - Update commit subject and description to reflect both VFAT and MSDOS coverage
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
> index 35bdb6294..daddae43e 100644
> --- a/fs/fat/dir.c
> +++ b/fs/fat/dir.c
> @@ -941,6 +941,24 @@ int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
>   }
>   EXPORT_SYMBOL_GPL(fat_get_dotdot_entry);
>   
> +int fat_update_dotdot_de(struct inode *dir, struct inode *inode,
> +			 struct buffer_head *dotdot_bh,
> +			 struct msdos_dir_entry *dotdot_de)
> +{
> +	lock_buffer(dotdot_bh);
> +	if (!buffer_uptodate(dotdot_bh)) {
> +		unlock_buffer(dotdot_bh);
> +		return -EIO;
> +	}
> +	fat_set_start(dotdot_de, MSDOS_I(dir)->i_logstart);
> +	mmb_mark_buffer_dirty(dotdot_bh, &MSDOS_I(inode)->i_metadata_bhs);
> +	unlock_buffer(dotdot_bh);
> +	if (IS_DIRSYNC(dir))
> +		return sync_dirty_buffer(dotdot_bh);
> +	return 0;
> +}
> +EXPORT_SYMBOL_GPL(fat_update_dotdot_de);
> +
>   /* See if directory is empty */
>   int fat_dir_empty(struct inode *dir)
>   {
> diff --git a/fs/fat/fat.h b/fs/fat/fat.h
> index 61338413d..07092e055 100644
> --- a/fs/fat/fat.h
> +++ b/fs/fat/fat.h
> @@ -339,6 +339,9 @@ extern int fat_scan_logstart(struct inode *dir, int i_logstart,
>   			     struct fat_slot_info *sinfo);
>   extern int fat_get_dotdot_entry(struct inode *dir, struct buffer_head **bh,
>   				struct msdos_dir_entry **de);
> +extern int fat_update_dotdot_de(struct inode *dir, struct inode *inode,
> +				struct buffer_head *dotdot_bh,
> +				struct msdos_dir_entry *dotdot_de);
>   extern int fat_alloc_new_dir(struct inode *dir, struct timespec64 *ts);
>   extern int fat_add_entries(struct inode *dir, void *slots, int nr_slots,
>   			   struct fat_slot_info *sinfo);
> diff --git a/fs/fat/namei_msdos.c b/fs/fat/namei_msdos.c
> index d46d1a385..ee0af94a1 100644
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
> +		corrupt |= fat_update_dotdot_de(old_dir, old_inode, dotdot_bh,
> +						dotdot_de);
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

Keep the shared FAT `..` update helper and its buffer lock around the 
`BH_Uptodate` check, parent-cluster update, and dirty mark. A failed 
synchronous `..` write clears `BH_Uptodate`, so rollback must return 
`-EIO` before changing or dirtying that buffer.

The MSDOS `error_dotdot` rollback previously called 
`sync_dirty_buffer()` after restoring the old parent even when 
`IS_DIRSYNC(old_dir)` was false. The new shared helper syncs only for 
DIRSYNC. If this rollback is entered with a valid non-DIRSYNC buffer, it 
now delays the recovery write and loses its immediate write-error 
result. Add a rollback-specific way to force the sync after the buffer 
has been checked and unlocked. Keep the ordinary VFAT and MSDOS updates 
conditional on DIRSYNC. Preserve the first rename error, cleanup, and 
corruption reporting.

Keep the existing `Fixes: 1da177e4c3f4` tag, which covers the original 
VFAT and MSDOS rollback pattern. Remove the obsolete Linus Torvalds 
recipient and retain the current FAT maintainer and list recipients.

