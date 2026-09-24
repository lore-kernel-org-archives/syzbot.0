Received: from mail-lf1-f48.google.com (mail-lf1-f48.google.com [209.85.167.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35A5B2673AA
	for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 14:00:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.167.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790258402; cv=none; b=rOQfeN6Fg1iss766n9Lfl2T3jhHbyESLUvfXUvntpSvV/URQgNqHMMTS1fh3XSIBi+PbOR8E5uUNCdF5BFzb4FWNYyFD7/ESB9VoXHM3xJ3wavOGvumBpput3O5sp9nL+AkyCnDVtLvaksBpAZaNereOYE7JaerCOBXOQE3+HCw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790258402; c=relaxed/simple;
	bh=pEwGVev/ihnU+GyVkhAZ6TstUk/ylrqsIXMKRmww/FI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=OPWouPp7plCTvDbPqUbxpahhNYJPtcC7Zd0/5xWIEJcI2tss3Af4XYZMot3QJWzoux7RJGE3RGzTkjpLoYaNfqLtz7NEpLM5766T9wgYvYHUjEEdwMbUVVUhuXOkckoPz1j9u/XN9nmEINqNjpSRc3Pdsz7DRH62AO6S+99vC/E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=nxz36pJn; arc=none smtp.client-ip=209.85.167.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="nxz36pJn"
Received: by mail-lf1-f48.google.com with SMTP id 2adb3069b0e04-5b76694fb7aso1094297e87.0
        for <syzbot@lists.linux.dev>; Thu, 24 Sep 2026 06:59:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790258398; x=1790863198; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=RFICnFn82EQZJWy8+/UPCsZMJMATAJUe2Jzx6Q1O5Nw=;
        b=nxz36pJnGjaZFYUaS6fyc8hihdw6D8GG8dug/ZOg9jHTp9RG70jOYsG+CGCLMh+xu1
         qwqO4lAWcB6b0R9sOng8YSK01aEt3U2Nl/9R1M5tGITSrfecpRqB6fsFu0Jav+EkPBHs
         YjKhPbRhVl4tFrUuTh6oZqKi8eTtqCVUiI1uaDLKaqYInHfAomDs2BnxUUGTGBZBxERw
         IPtnORFnkNAwtpyB/KA7IRE1O+6rPlpEIL0ZILTirkyb+px+jYFyylLAKk1BVo/x4E/I
         kLW20WueWTqwqx3xvydD9F9z4/Los8qH7lgvh1Y2A7y1Vh19VXbdRL8Ffa2wk0iJiEsJ
         nHjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790258398; x=1790863198;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=RFICnFn82EQZJWy8+/UPCsZMJMATAJUe2Jzx6Q1O5Nw=;
        b=bxIqqej/jujBNBf/CKBf2YXnPqAA0+tIiJatXVT+Eo71OFR1OA1SPdwOBvotKBzOt+
         nfcf0fZMsyvMCDwuwS/kJsFFBTqC7z96uagXgYpmxdxa3Akx4JLt9QiT+SmNbUy/+At2
         DfoE1/1e8vueH0mUMycDl6661Ym2zNM12kubkqWZH2RstRshCdhYw91cKSh2ug9meBu8
         +78jK9E3Ni5x4JkUOS8gGdaYP6GF6OGfTVC/hm3wTnxoXAWr4YDY6yVkEAV+L/OyTtjd
         a3qQvqHomUiQ1MuY0NgajunoBwj5QGls7GP4ZtcKqWR3aocrKql50mT0PGkCR+4f7pOX
         Zknw==
X-Gm-Message-State: AFuF++lx92f9qq79z7ypzq/BQq1mlPBDboveYWi65txVjyi2E8Yoc8FI
	INeFwAJ3d2b0B3hGgj2zyIjymyygH5bGdq3SVgoGvucNT6tjg7llIpTE
X-Gm-Gg: AYBFou2+JPFYrX7/YmJ+xYzg2ouRZQOsypLQtIP+Nqibd8dAFdW+jIxCI3gr07Wrpog
	M3yz0nLtY2aDwvweZOdZg64srwndykUwIVwi/WyJAxC9J8lCB1i4bb0GwBMx0itiwrjk3ls/hUZ
	t7EGwzt6zCwONtS53gd90zsS/p+3biCN+rq+XbylgZ3SDJmdDDmZCCNXOLT9joqQawYEdl0ztzh
	clEtKC6nwlj9c6rx9VIoVAwK07BtWaNFbMSgS03SuQTrZpcGPKlm7gIEJ58skO8KEuX49IS809H
	wyR0x2pZ0XLRysIewwX9FHEtwLce4iYdTGqH0dFNMjEnIrWF0vzECrnMXRWA2/gVtyZQQw24Rjy
	Yhs0zz4zN+9jjHWgy2UMoxYmzFVJVOKFsfkFxDwvrL6zB8uuopkb8YpEBMMAM/fa5XT/X+4CA5T
	kutDcAJfxHA4UjB/mb9FSMnEDLpS8MTtW3zMp5ptPFQdphIg5VjRtYLCqlIW/lxW8ZSkDN5itbx
	i4XxQn1L9hwPuJJu+Ocm/U6RAXZzOyoIvoAhiV3q1f8FjggyJr8qEccKFTbGS7bDv3ogihSNbKQ
	5/4x4CoiRdTIiMgEgfR1eouymHGwS/Q0H1AJ4Ycj1wo/6N+hY4OMXNqWCgmpZt7pQD7h06UTHkD
	Rjof6wePGCaG0Vi5sl+ndgU7pQJCLzMNGMJICAqiv/3W4A1hDmMPzYoi7
X-Received: by 2002:a05:6512:3d28:b0:5b3:13eb:ef5f with SMTP id 2adb3069b0e04-5b8df0d3ebdmr856155e87.15.1790258397893;
        Thu, 24 Sep 2026 06:59:57 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5b8d858085bsm1496924e87.40.2026.09.24.06.59.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 24 Sep 2026 06:59:57 -0700 (PDT)
Message-ID: <185f9c15-803d-4e57-8f2e-350d985849a1@gmail.com>
Date: Thu, 24 Sep 2026 15:59:56 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] fat: validate VFAT dotdot buffers before dirtying
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <56341edb-4dc2-4683-9776-641253569bb3@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <56341edb-4dc2-4683-9776-641253569bb3@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/24/2026 12:05 PM, syzbot wrote:
> During directory rename operations with synchronous directory updates
> enabled, vfat_update_dotdot_de() writes the ".." directory entry via
> sync_dirty_buffer(). If this write fails due to an I/O error, the block
> layer clears the BH_Uptodate flag. When rename enters its error rollback
> path, it calls vfat_update_dotdot_de() again with the same buffer head,
> which calls mmb_mark_buffer_dirty() and triggers a "!buffer_uptodate(bh)"
> warning in mark_buffer_dirty().
> 
> Fix this by locking the buffer head in vfat_update_dotdot_de() and checking
> buffer_uptodate() before modifying the entry. If the buffer is not
> uptodate, unlock it and return -EIO, preventing mmb_mark_buffer_dirty()
> from being called on a non-uptodate buffer.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+b0aebd03565f5774f7f8@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=b0aebd03565f5774f7f8
> Link: https://syzkaller.appspot.com/ai_job?id=27914cea-b3da-4f37-a39a-cc2d26c706b7
> To: "OGAWA Hirofumi" <hirofumi@mail.parknet.co.jp>
> To: <linux-kernel@vger.kernel.org>
> To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
> 
> ---
> v2:
> - Lock the buffer head and return -EIO if it is not uptodate instead of calling set_buffer_uptodate().
> - Update the patch subject to reflect buffer validation.
> - Shorten the commit description and remove the stack trace.
> 
> v1:
> https://lore.kernel.org/all/012d4ac1-83f3-48af-8781-00fbbc4adc93@mail.kernel.org/T/
> ---
> diff --git a/fs/fat/namei_vfat.c b/fs/fat/namei_vfat.c
> index da3e89c0b..1e7fd4003 100644
> --- a/fs/fat/namei_vfat.c
> +++ b/fs/fat/namei_vfat.c
> @@ -913,8 +913,14 @@ static int vfat_update_dotdot_de(struct inode *dir, struct inode *inode,
>   				 struct buffer_head *dotdot_bh,
>   				 struct msdos_dir_entry *dotdot_de)
>   {
> +	lock_buffer(dotdot_bh);
> +	if (!buffer_uptodate(dotdot_bh)) {
> +		unlock_buffer(dotdot_bh);
> +		return -EIO;
> +	}
>   	fat_set_start(dotdot_de, MSDOS_I(dir)->i_logstart);
>   	mmb_mark_buffer_dirty(dotdot_bh, &MSDOS_I(inode)->i_metadata_bhs);
> +	unlock_buffer(dotdot_bh);
>   	if (IS_DIRSYNC(dir))
>   		return sync_dirty_buffer(dotdot_bh);
>   	return 0;
> 
> 
> base-commit: 93f51579e7df248780214094418f205253383cc5

Please extend the `BH_Uptodate` guard to MSDOS cross-directory rename 
and its rollback. A failed synchronous write of the `..` entry clears 
`BH_Uptodate`. `do_msdos_rename()` then changes and dirties the same 
retained buffer during rollback, so `mark_buffer_dirty()` can still 
warn. The current VFAT-only change leaves that sibling path exposed.

Put the locked state check, parent-cluster update, and dirty mark in one 
shared FAT `..` update operation used by VFAT and MSDOS. Return `-EIO` 
before modifying a non-uptodate buffer. Keep the buffer lock through the 
dirty mark and release it before `sync_dirty_buffer()`. Preserve the 
current VFAT check, each caller's existing synchronous-write choice, 
rename cleanup, original error precedence, and filesystem-corruption 
reporting.

Update the subject and short commit description to cover both VFAT and 
MSDOS. Keep the supported `Fixes:` tag and existing syzbot provenance 
and report tags. No other behavior change is requested.

