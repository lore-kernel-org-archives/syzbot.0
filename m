Received: from mail-ed1-f42.google.com (mail-ed1-f42.google.com [209.85.208.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64EC737204E
	for <syzbot@lists.linux.dev>; Mon, 14 Sep 2026 07:43:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789371841; cv=none; b=ljYQ+cr1wcMPqFXeqyLdBsQTmkZUvXL7o3opzaA/M5JCQqpiUmRml99irbzye1518/4Emg1Ya817kgRs64v1hVhBIMiD0jBkCQMf+DHI/ZwCClIFLrb43a8aqy0wX+FudF9KvguClCOSJmDngOkDd0Q+IiG3XVr7FV8ipZ1BgOo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789371841; c=relaxed/simple;
	bh=xMkJIUid/aYBYSKu/Oa+X7VRsoxFOb7pPvRnpN8Pt9Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=nQDMlLGO4mtHtOLNmdPUK7Q9t3cZZ9pvVIwj9KtWza9p2CuCW/ki5VZcSKqSsqYRxBwLOVccpVxSiuJzlZzrnRQ8Au43YayqgodSB/XhW5CaXUKP61bAlv+kBoySG0NZqC0mzYfoTOJ0EqL/ojUwj5LASqtdP/ZTmdQ/Al1ICz8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=XZ1oc7gI; arc=none smtp.client-ip=209.85.208.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="XZ1oc7gI"
Received: by mail-ed1-f42.google.com with SMTP id 4fb4d7f45d1cf-6a5e971c970so4626396a12.0
        for <syzbot@lists.linux.dev>; Mon, 14 Sep 2026 00:43:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789371837; x=1789976637; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=gqf3fBjiaovx8jfcx8se0BIzq1Sbwum6S7BXYBSx2Hk=;
        b=XZ1oc7gIP7wFd8niCeKp4MhIY5OGn/JAjwKB5veKAlWgpwiLrTeFTusrX3jVQ377jX
         hYHXiA7Irtg1fJXo+uluKSEt2sS8G4al7rTZSZm5C7r5F1IQ1HGnAtPjwa5LHI9cB6hq
         UmC5xlbVt0qodjtqejMtmfCUBsjIVfyUNZvExloX7WOHHc+1nf6Poa0LpQPwUb/SHx01
         FD7zNc4in990t5+WybH6KzcvrpUN+iXf7mz6ICusooS0YAbC9ITNuh79fXNsdx1yUpav
         3U6bsmsFYUbSpHEsptoMy/2M6Jsh2DY6PN/bfmrj8UjTzdCumqe67UDFKFf7H0uTU/Vm
         Uu3A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789371837; x=1789976637;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=gqf3fBjiaovx8jfcx8se0BIzq1Sbwum6S7BXYBSx2Hk=;
        b=CsRhHCd/Ezxus2CCkxm2ks64GJT93DHoqQaOch+QeCCOagkSKqu78lb+P5JEZVPL/3
         qypdkGkzBPDvTfOKjpmDoFIAC/V8i8TjS0L6ZlG1/nR0AHubaeNfQwv2OZtxqecITVVy
         BpJdERb2b2/ASGk50TPDfGToI8Epp8f2sbwSG/cX1P7ikYnGYk22HsZriUXpGW8oF7xk
         CjIaUrT96yd4KWreZM4yD5J78lC3JD2buTDpMo6FlytaUtODS1t9f+ncT/UoEYQXqcm3
         xhu+3JKdV0vsH3kIESjsmmJnA2SRZZf0GbT9RIwCRKn4ekxRCawOg2uQDoFTi5TPx+O8
         944A==
X-Gm-Message-State: AFuF++kW3rTmcy0TC68EdMW8IQmu5R3j0v5mBtbV7w+yph1Rj1f7VuLN
	GShHgFOPT6fNVEuLQe2sFic/Wp5pdvqJiM+IKjKgVaDwzlejrhSEu5TTvuXA3YUW
X-Gm-Gg: AYBFou24IMvUCSWkH0Vp7d2wYKIN1K3xqEjnNWS47s3mBzXVbfGekSRROQJZiMt7yw2
	VRTkNxzIG3ZsDFgbN7OpyTnwblL8q0dWxN5OOpkyPZhkuLsOZNX+NAIPXs94Kux8TtCkyTyG76B
	x6/JwRckSaME/7bTzOsQS9Vioa2BfUwQZehz6yn5vuffkH/ynKYfJStxjjq69ACaT/jE8U4Jih1
	EMLKTJOBT+vm5FI6YuXuZIzwgeA3+cyAFW0TU4uG1Ojbxgk15w6H3Oi/otcNTOQOp+Ma5DtHDR0
	TkfwH9+KKYJ9Ybd0/TmXDT3/83g9JDjYm3YuOCc0jGrs1jbAiyLK1Fa6qNAoFB4+yBbbL/z2naw
	Z9Aerat0Qv2xtJIY3HyFRPsPnyOM2eRfvdYZIO1duqR1SgC6gLmN46RlS99+0/0x0V+dbvBdl2k
	5d5KvW+hAhEoHyBKA46xWS2lNoNkKWvVViSVk7yaP7973Vwvpht9J1AfA5dV3bkcgxJcUAUDZrN
	epu1/2oYGG1KG6nu/NvTQV8p1AArCbVyCAAc8A1Et7Cs7OU/5TDwPjHxx1TRos/55xa/iO45V4b
	lj5vNH3XixbWAkR7U3HcSyZnvSoXj+QPM8wsxKceHdcwO44fvbi8ApV7CIs4a9k7RXxDdB4Cwvn
	xQehQMaJb1fTD1eyH0Tp5Jmy0/CcYqCycxA6tRco8LEgnbg==
X-Received: by 2002:a17:906:6a18:b0:c25:5e10:1ca9 with SMTP id a640c23a62f3a-c29a4296882mr276509666b.5.1789371837168;
        Mon, 14 Sep 2026 00:43:57 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c296608dc91sm377551766b.39.2026.09.14.00.43.56
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 14 Sep 2026 00:43:56 -0700 (PDT)
Message-ID: <1bff4d99-fc19-45ea-9557-7de2629252ed@gmail.com>
Date: Mon, 14 Sep 2026 09:43:55 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] scsi: sg: Validate scatter_elem_sz module parameter
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <30c58052-61b7-4425-9fd7-c188a0bef4ea@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <30c58052-61b7-4425-9fd7-c188a0bef4ea@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Preserve the existing accepted-and-normalized behavior of 
scatter_elem_sz. The reported failure occurs because sg_build_indirect() 
repairs the shared parameter values for a sub-page snapshot but leaves 
local num unchanged before get_order(). Zero then reaches undefined 
get_order(0). A negative int can also bypass the old lower-bound 
comparison because PAGE_SIZE makes it unsigned.

Keep the standard integer module parameter and the existing 
normalization at the allocation boundary. Make the comparison explicitly 
signed, and assign PAGE_SIZE to the local snapshot in the same branch 
that updates scatter_elem_sz and scatter_elem_sz_prev. This must cover 
negative, zero, and positive sub-page values while preserving successful 
sysfs stores and module arguments.

Do not remove scatter_elem_sz_prev or the existing publication of a 
rounded allocation size for valid non-power-of-two values. Preserve 
allocation retry, partial-allocation cleanup, common-path behavior, and 
existing device, recovery, parsing, and allocation error precedence.

Do not add a rejecting upper-bound policy unless that interface 
compatibility change is independently justified. The kernel signed-wrap 
contract and existing allocation retry do not establish a separate 
high-value shift defect here. Preserve the current Fixes, Reported-by, 
Closes, and assistance provenance information. Update the description so 
it explains the stale local snapshot and signed comparison without 
claiming that this patch repairs all parameter races.

On 9/9/2026 9:40 PM, syzbot wrote:
> Writing an invalid value such as 0 to
> /sys/module/sg/parameters/scatter_elem_sz causes a shift-out-of-bounds bug
> during subsequent device operations. When opening a device via sg_open(),
> the driver calls sg_build_indirect() to allocate scatter-gather buffers. In
> sg_build_indirect(), the code checks if the local variable num is less than
> PAGE_SIZE and updates the global scatter_elem_sz and scatter_elem_sz_prev
> variables, but fails to update num. As a result, num remains 0 and is
> passed to order = get_order(num). Calling get_order(0) is undefined and
> underflows to 52 on 64-bit systems, causing ret_sz = 1 << (PAGE_SHIFT +
> order) to compute 1 << 64. Shifting a 32-bit int by 64 bits triggers a
> UBSAN shift-out-of-bounds warning:
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
> Additionally, excessively large values written to scatter_elem_sz can cause
> order to exceed MAX_PAGE_ORDER, which can overflow signed 32-bit arithmetic
> and trigger warnings in the page allocator. Mutating global variables
> scatter_elem_sz and scatter_elem_sz_prev inside the I/O path without
> locking also introduces data races between concurrent device accesses.
>
> Fix this by replacing module_param_named() with module_param_cb() for
> scatter_elem_sz, similar to def_reserved_size. The setter callback
> scatter_elem_sz_set() validates that the input value is within [PAGE_SIZE,
> PAGE_SIZE << MAX_PAGE_ORDER], rejecting invalid values with -ERANGE or
> -EINVAL at the sysfs boundary. Remove scatter_elem_sz_prev and the runtime
> parameter modification from sg_build_indirect(), compute the allocation
> order directly from scatter_elem_sz, and simplify the per-element size
> calculation using min(rem_sz, ret_sz).
>
> Fixes: 10db10d144c0 ("sg: convert the indirect IO path to use the block layer")
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
> Link: https://syzkaller.appspot.com/ai_job?id=4512b081-e607-45b8-8a53-4eefe3737482
> To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> To: "Doug Gilbert" <dgilbert@interlog.com>
> To: <linux-scsi@vger.kernel.org>
> To: "Martin K. Petersen" <mkp@kernel.org>
> To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 5408f002e..4c82fc00d 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -92,7 +92,6 @@ static int def_reserved_size = SG_DEF_RESERVED_SIZE;
>   static int sg_allow_dio = SG_ALLOW_DIO_DEF;
>   
>   static int scatter_elem_sz = SG_SCATTER_SZ;
> -static int scatter_elem_sz_prev = SG_SCATTER_SZ;
>   
>   #define SG_SECTOR_SZ 512
>   
> @@ -1621,9 +1620,33 @@ sg_remove_device(struct device *cl_dev)
>   	kref_put(&sdp->d_ref, sg_device_destroy);
>   }
>   
> -module_param_named(scatter_elem_sz, scatter_elem_sz, int, S_IRUGO | S_IWUSR);
>   module_param_named(allow_dio, sg_allow_dio, int, S_IRUGO | S_IWUSR);
>   
> +static int scatter_elem_sz_set(const char *val, const struct kernel_param *kp)
> +{
> +	int size, ret;
> +
> +	if (!val)
> +		return -EINVAL;
> +
> +	ret = kstrtoint(val, 0, &size);
> +	if (ret)
> +		return ret;
> +
> +	if (size < PAGE_SIZE || size > (PAGE_SIZE << MAX_PAGE_ORDER))
> +		return -ERANGE;
> +
> +	scatter_elem_sz = size;
> +	return 0;
> +}
> +
> +static const struct kernel_param_ops scatter_elem_sz_ops = {
> +	.set	= scatter_elem_sz_set,
> +	.get	= param_get_int,
> +};
> +
> +module_param_cb(scatter_elem_sz, &scatter_elem_sz_ops, &scatter_elem_sz, 0644);
> +
>   static int def_reserved_size_set(const char *val, const struct kernel_param *kp)
>   {
>   	int size, ret;
> @@ -1667,10 +1690,8 @@ init_sg(void)
>   {
>   	int rc;
>   
> -	if (scatter_elem_sz < PAGE_SIZE) {
> +	if (scatter_elem_sz < PAGE_SIZE)
>   		scatter_elem_sz = PAGE_SIZE;
> -		scatter_elem_sz_prev = scatter_elem_sz;
> -	}
>   
>   	rc = register_chrdev_region(MKDEV(SCSI_GENERIC_MAJOR, 0),
>   				    SG_MAX_DEVS, "sg");
> @@ -1873,36 +1894,19 @@ sg_build_indirect(Sg_scatter_hold * schp, Sg_fd * sfp, int buff_size)
>   	if (mx_sc_elems < 0)
>   		return mx_sc_elems;	/* most likely -ENOMEM */
>   
> -	num = scatter_elem_sz;
> -	if (unlikely(num != scatter_elem_sz_prev)) {
> -		if (num < PAGE_SIZE) {
> -			scatter_elem_sz = PAGE_SIZE;
> -			scatter_elem_sz_prev = PAGE_SIZE;
> -		} else
> -			scatter_elem_sz_prev = num;
> -	}
> -
> -	order = get_order(num);
> +	order = get_order(scatter_elem_sz);
>   retry:
>   	ret_sz = 1 << (PAGE_SHIFT + order);
>   
>   	for (k = 0, rem_sz = blk_size; rem_sz > 0 && k < mx_sc_elems;
>   	     k++, rem_sz -= ret_sz) {
>   
> -		num = (rem_sz > scatter_elem_sz_prev) ?
> -			scatter_elem_sz_prev : rem_sz;
> +		num = min(rem_sz, ret_sz);
>   
>   		schp->pages[k] = alloc_pages(gfp_mask, order);
>   		if (!schp->pages[k])
>   			goto out;
>   
> -		if (num == scatter_elem_sz_prev) {
> -			if (unlikely(ret_sz > scatter_elem_sz_prev)) {
> -				scatter_elem_sz = ret_sz;
> -				scatter_elem_sz_prev = ret_sz;
> -			}
> -		}
> -
>   		SCSI_LOG_TIMEOUT(5, sg_printk(KERN_INFO, sfp->parentdp,
>   				 "sg_build_indirect: k=%d, num=%d, ret_sz=%d\n",
>   				 k, num, ret_sz));
>
>
> base-commit: df2908090cda368b01ff43709f51890076c56157
