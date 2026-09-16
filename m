Received: from mail-wm2-f12.google.com (mail-wm2-f12.google.com [74.125.225.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC70D313E0D
	for <syzbot@lists.linux.dev>; Wed, 16 Sep 2026 15:03:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.225.140
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789570982; cv=none; b=XvSh4AjOMEhjE1gDCE4ae06We/eARwIb+jMFnYN2QkckA00GbKls3gR7tayuLSIrzLLmxI7EIkNK7xAsSFubtNzp5uZlzc6xEe6/nhFxMjRRsszSIlHjIOgFrg0bQ/KYV+OsRYkD27yfWqV0hiT++OrHbh3vr8N8VknokRMyR94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789570982; c=relaxed/simple;
	bh=QEFwEGiGwvJqngCDLVwzGZHtpaBQbKFV6N+giUEFjIs=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Vf08+qku0zHBOzbuev/3vdYG8r9UFCEfiQtVounLFEtgJlmkzYF7OyQGalBUtkfkA991uEfaC3F9QHSKl6U06S3hrv4ejTieLSYo9M4EO0pF3TvrjAuvS/VSY8GrGVsYEG5hmpAdC/NoLwGRFEkxBRgVErX1Brab8Lg7DbkmDe8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=F/QT9rje; arc=none smtp.client-ip=74.125.225.140
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="F/QT9rje"
Received: by mail-wm2-f12.google.com with SMTP id 5b1f17b1804b1-49ccfd61ecaso9660405e9.3
        for <syzbot@lists.linux.dev>; Wed, 16 Sep 2026 08:03:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789570979; x=1790175779; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Mln4TqF/7+Pi47OzKQGRJbQK+tSglhI87SFwR/lH6uk=;
        b=F/QT9rjeNpr+qwiX6fxEJHplm69g259o0M7p+rNjoWJCiydXysxfoIVb5pxd+hNbcM
         E4+jVRdM508ShyyFyvu3UQvpv7c3CIXgUS6v4o1zZ3s4PqkWYSAlwwj3uthY+/GvJil+
         I2G6mh6zUcelQW5n+p6o/mGCrb9Hxt9fs7bX6LF0VN1n7NM9YVDICfaLtIlbH3akYCQC
         Yfto2i498wneUtEYYAm+bW1iqofMd8HiJkS+EOK7788y/DDNVWdcEX27gZXpruv0Vds4
         oTCPpsZwBnbxtIIgkhXRjEM/ySO4jAbw7KbCWSTxrAON+tQGCI832kOzZD7rpy++iqka
         n1nA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789570979; x=1790175779;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Mln4TqF/7+Pi47OzKQGRJbQK+tSglhI87SFwR/lH6uk=;
        b=0xc023U/Hf7E09Cjm/NmWE6a+IKHrNopQx3a8jPQOrVV/vhxM1XyptiTHYx0APXDht
         p7Qc9yjGM/NsRjwoVlarV/B1sKRkIxS15LLIHPGvuSQ+4p6HxgEu0xYVeowDaR09pPZL
         eo0SYqcVte/bmA9JLcqJaLs9P+bWzjHp7UYajxcKa+x3/MrOx1OPX1QOo15fUKzJPHuM
         633lejsssfXbWswzKnfO+p1phi9GNIvEicMLCIPeZszQ4oFf1g7oYQZxBI9AgjCbSCwq
         fxCec7s2HnHU7ka8+3xlLobrFDpuUhp8j1+/+PcWRQnvS1df/QvDt6GTfPROdROt8o8b
         RE/A==
X-Gm-Message-State: AFuF++m6LjqUaD/SEjwSl1ef7DrDMZVE2HplC9xHflqKtAJ6CaTCtI/+
	B6zFz4YH930xIGx7U8oMEPUFPVi8vnkZ8REOxPz1Qful4ilEUT8DTljr
X-Gm-Gg: AYBFou3liNja8RrfrIT+mAbwSdrBKFHUhSlGS11yptNeSX6OnpCiDAhN66UYplNvxkb
	jNjqVWLCPn0kXiQqcLQlK+DlU08ZXcHRwRDN69de5aGNVHb9rt0xdQjVCOE9XsDkF57gs7DsoMd
	uyw3zUVPvKyEtRRrdZmP21VE0dq5DaaXyDtYw72EgjzjIJD0BnesenR/x52zn4YWslqDud+MfRf
	wh653xq3S+vY3vmCM1jd0MDxCSd8/7FdPcIgPQCPjBsSovbOgkg8z1/da5eShmUtPKqsvVt/S1h
	TosVc6tqgDy+NCJ5kQpYudwHqgElIplc3dX4YqQsee9TyzlNryOvm2M6d/dDBW2/LdBxCxXbRLX
	Rx9un/kqZtzC2Or87LSUn2nNSxzsJwNyGpiKXFlPLCD9b4nHN6U01aYPa5VR3KE0SCOJ/l593Ln
	qtt7cnB9GC4a/xk13TvYj+29vijo2Az0ceWcQksyP/ngca7vv3QsnAGjleXs94f4Vj0r77Bg7wL
	mJ05fUaQx8u2B3UZgy608uLLD+TO7+rzKkKu8vArJHtfTg27JQdzmMyOH5S27+3O4IQMbH58zN9
	OAFeXKPWmCXuV+o7iqbPVQ65Vu+0r+42UmItEKIQPAON8WIC4iDa0YP0+hyuMzL5P7pYwyZZV0N
	YLAPWAbd8yHVleAkmsan+JorZTocWuyQKjbZhDHitb0z0xA==
X-Received: by 2002:a05:600c:8b61:b0:49e:6891:27a8 with SMTP id 5b1f17b1804b1-49eb732e411mr32405435e9.25.1789570978769;
        Wed, 16 Sep 2026 08:02:58 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-49e83fc3da0sm60617575e9.1.2026.09.16.08.02.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Sep 2026 08:02:58 -0700 (PDT)
Message-ID: <193c1157-3676-463b-bc3b-81143ca5c511@gmail.com>
Date: Wed, 16 Sep 2026 17:02:57 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] scsi: sg: Fix shift-out-of-bounds in
 sg_build_indirect()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <4c6c124f-f448-4854-b8dd-9bfc194fa944@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <4c6c124f-f448-4854-b8dd-9bfc194fa944@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Extend the signed lower-bound handling to init_sg(). scatter_elem_sz is 
an int, while PAGE_SIZE is unsigned long. A negative module parameter is 
therefore converted to unsigned in the current initialization-time 
comparison and bypasses the intended PAGE_SIZE clamp. Compare 
scatter_elem_sz against (int)PAGE_SIZE in init_sg(), while keeping the 
existing assignments that normalize scatter_elem_sz and 
scatter_elem_sz_prev. This should make negative initialization values 
follow the same minimum as zero and positive sub-page values.

Keep the current sg_build_indirect() repair unchanged. It must still 
compare the local num snapshot in the signed domain and assign PAGE_SIZE 
to num before get_order(). Preserve module_param_named(), successful 
parameter stores, runtime normalization, rounded-value publication, 
accepted high values, allocation retry, cleanup, and existing error 
precedence. Do not add a custom parameter callback, new -ERANGE policy, 
or a claim that this fixes the broader parameter race. Update the commit 
message to cover both the stale local snapshot and the 
initialization-time signed comparison, while preserving the existing 
tags and assistance provenance.

On 9/14/2026 10:29 AM, syzbot wrote:
> Writing an invalid value such as 0 or a negative number to
> /sys/module/sg/parameters/scatter_elem_sz causes a shift-out-of-bounds bug
> during subsequent device operations. When opening a device via sg_open(),
> the driver calls sg_build_indirect() to allocate scatter-gather buffers. In
> sg_build_indirect(), scatter_elem_sz is read into the local snapshot
> variable num. Because PAGE_SIZE is unsigned, comparing num against
> PAGE_SIZE results in an unsigned comparison that bypasses negative values.
> Furthermore, even if the condition is met, the code updates the global
> scatter_elem_sz and scatter_elem_sz_prev variables but leaves the local
> snapshot variable num unupdated before get_order(). As a result, an invalid
> value such as 0 remains in num and is passed to order = get_order(num).
> Calling get_order(0) is undefined and underflows to 52 on 64-bit systems,
> causing ret_sz = 1 << (PAGE_SHIFT + order) to compute 1 << 64. Shifting a
> 32-bit int by 64 bits triggers a UBSAN shift-out-of-bounds warning:
>
> UBSAN: shift-out-of-bounds in drivers/scsi/sg.c:1887:13
> shift exponent 64 is too large for 32-bit type 'int'
> Call Trace:
>   <TASK>
>   dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>   ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>   __ubsan_handle_shift_out_of_bounds+0x36d/0x400 lib/ubsan.c:494
>   sg_build_indirect+0x559/0x870 drivers/scsi/sg.c:1887
>   sg_build_reserve drivers/scsi/sg.c:1997 [inline]
>   sg_add_sfp drivers/scsi/sg.c:2177 [inline]
>   sg_open+0x1128/0x18a0 drivers/scsi/sg.c:349
>   chrdev_open+0x4d9/0x600 fs/char_dev.c:411
>   do_dentry_open+0x816/0x1380 fs/open.c:996
>   vfs_open+0x3b/0x340 fs/open.c:1101
>   </TASK>
>
> Fix this by casting PAGE_SIZE to int so that the comparison is signed and
> negative values do not bypass the check, and by updating the local snapshot
> variable num to PAGE_SIZE when num < (int)PAGE_SIZE before get_order() is
> called.
>
> Fixes: 10db10d144c0 ("sg: convert the indirect IO path to use the block layer")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
> Link: https://syzkaller.appspot.com/ai_job?id=e273ef4c-bec0-4d7e-af59-32e327619af1
> To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> To: "Doug Gilbert" <dgilbert@interlog.com>
> To: <linux-scsi@vger.kernel.org>
> To: "Martin K. Petersen" <mkp@kernel.org>
> To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Drop module_param_cb() setter callback and range validation at sysfs boundary.
> - Cast PAGE_SIZE to int in sg_build_indirect() to prevent negative values from bypassing the check.
> - Update local snapshot variable num to PAGE_SIZE when num is less than PAGE_SIZE.
> - Update commit description to explain the unsigned comparison and unupdated local variable, and remove claims regarding parameter data races.
>
> v1:
> https://lore.kernel.org/all/30c58052-61b7-4425-9fd7-c188a0bef4ea@mail.kernel.org/T/
> ---
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 5408f002e..39c8e52fa 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1875,9 +1875,10 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
>   
>   	num = scatter_elem_sz;
>   	if (unlikely(num != scatter_elem_sz_prev)) {
> -		if (num < PAGE_SIZE) {
> +		if (num < (int)PAGE_SIZE) {
>   			scatter_elem_sz = PAGE_SIZE;
>   			scatter_elem_sz_prev = PAGE_SIZE;
> +			num = PAGE_SIZE;
>   		} else
>   			scatter_elem_sz_prev = num;
>   	}
>
>
> base-commit: df2908090cda368b01ff43709f51890076c56157
