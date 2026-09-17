Received: from mail-ed2-f12.google.com (mail-ed2-f12.google.com [74.125.228.76])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EF65393DEB
	for <syzbot@lists.linux.dev>; Thu, 17 Sep 2026 08:01:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.76
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789632115; cv=none; b=pheq+FgeDfPWi1Gyl6D2RznVvMV0t/hBHEBuxhPgK8vDiK7D99gJ0MdnLv9cmqdM+8oVEY+kO53qasH20NFGxn2tJrbNgO66+DrW2bhoKWn3uOBptldpF8nct8iEoxStaGYl2L69EVFMdzSljZMsNKF2BA4NUOOWLKu6M8YOkBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789632115; c=relaxed/simple;
	bh=ONzpXq6SzhsxaLbujMtcadSZM0/gIovsiB+len29c4g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=EYI20OfHgJpvgYSMd8CjcWSCVgx6LF9mcE9homDkyeXQW4F65eWOJkKTBdo5/m5xJbcdAOAWHDUW6arXq0H5luneG1cj24Kwv3v8KOE5KJ7GeSO/ph7LXuraMv30HLEJRk5Eu4eiMQvpDFBWRld2sj92j1Fgo3oT3fuP4sM+i5A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=TLHLsIg4; arc=none smtp.client-ip=74.125.228.76
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="TLHLsIg4"
Received: by mail-ed2-f12.google.com with SMTP id 4fb4d7f45d1cf-6a6063d7dc4so790353a12.3
        for <syzbot@lists.linux.dev>; Thu, 17 Sep 2026 01:01:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789632111; x=1790236911; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=f2mhdkVfqEYmiH38fRCQnCWiXcrP84Xd8z7jb+J9neY=;
        b=TLHLsIg4VRZRBjmz7FU4zeTGrtoLiJmxtiLfTD6x6/54/4KD/nOE2QAGb3Em2NcBV/
         4YLsYc2tVf8CrB3Rl0AqeJePzUO3UdwepTzvzxtlYaAPrG+LiH6IEs1qh8yyMkc4PBBE
         0WIvzYF7IV7dCSrh13Uyc3l0/nM/y4nO3H0t3t58Il4ElwdgfFBPjOR/OfgPI2PftcOX
         NEIT8ucum2mgYIekJ3lKq9Ht1MTjqXsAD4UUJk915DmA0cbY/57Mxste0E/aHC1FkfGx
         /u2zbGxLGw6Os+k+JUQpqkW7R+qrNEvhyuXQT/NJqEjmvvEb9vEGHjOAjHMa+UqCxf8T
         zd1Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1789632111; x=1790236911;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=f2mhdkVfqEYmiH38fRCQnCWiXcrP84Xd8z7jb+J9neY=;
        b=KxUtJVFFaSbgL91nMB7Ulm/frlNl9E1Y1f6W80AanNzRyX4hZVSk8YyOD+Dgt+3PPj
         AECrdQjyQfMYELE8DvyZXC6Hvp2wSxTRCnmhyNbwf5+72VX/mTMec2/tYRjDFXz5ewu8
         nEiIu7BAxMcXUgwcza6KaZnHxo6ORkbDdDumoT5TM9Quw0Wg7QEwBs/QCS7Mg2pr2D3Y
         DM6iIQ5gGBIM2TjsDh2Sncfj5+BXbH+ZcSlDfdqjwjVeeikI+FmE9ULMgpi5+j8EnSFF
         eF9CJgRJ435S3yJSnQroWbyFhLRiTze07qRNyoZnGW+dZ/6vrkynpsUQXrqgefhK1xaS
         dfeQ==
X-Gm-Message-State: AFuF++mLGCnKnJXvo/6u96c7vKITy6q5oNuKEHSGecShmnthwmI7KyQv
	PTQYu3J2urXfDQGuDb1LL2xsg+rZwfL27O/cY+nY9hQUsmCh1oQAzD68
X-Gm-Gg: AYBFou2ntwQV3eE9d+n3n8E001ALpW1VuwNzlNYvQhRK0Lxfqth0abZYvqoKU8El3Eh
	u+kD29eockQR6dkBb8l/8kqv9LviKcLbtdH5g+phT8L8VKRCcWck0HzTNYM7slfOx3bgpxIMd2/
	oeu63CxXt0ByCCAnNaI37W1LxN7wpw2G5kuvEN/JESad+KyIc0yIXQ5eG92bok/uLPgIlnbZYlP
	EYDqP4REby/ZDlK2/HqJLSL0zV6N/+s2+2mNrppqF6dUxyopJBxskxxgKyQPV1HmR8ft1H/0kec
	nwzD207KoAQ3T0wa39pPCKpgTBuRp1/GYD7Y/8b85pp+DW5IJajGK1DhC+ETQVjEB1MEKBDntey
	x9oEOq98PA3t5/r3r5bjb0CgyVvymH1ZUgymuNfoSrGG3mo0x8raUjnwaP/f3AjnVL9o34ftpcA
	P57AU+yEhgFKtte3qtt/bnHYWV1txloDkMvRqen6IQUUAYkBUcYW28g/o183397omtpYpAN7Esl
	ARusba3q1vAbOhpBDAMPLtKxWlCx3TWM+ALYQvQvEwFlEijbN14ipxWV5kCi47XmWYLnIcjuIOP
	xU0bJ4k4MN2BjHN+TkPUwYkYkR4sCnr5Ds+w4J77/oI64JjCwb3AejGMv5sWyjz3Z2LAby6dacL
	DfemgxTXBVbVCh2vXFAy4vkBxn6l+2/EvArnhNMpNAo1UTn7dY2Ai4xj8
X-Received: by 2002:a05:6402:234a:b0:6a9:d0f0:69a0 with SMTP id 4fb4d7f45d1cf-6aa2240345cmr8307583a12.11.1789632111129;
        Thu, 17 Sep 2026 01:01:51 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6aa1cfe07e4sm3196427a12.2.2026.09.17.01.01.50
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Sep 2026 01:01:50 -0700 (PDT)
Message-ID: <4b7f68dd-5da8-404f-b777-f77588972aff@gmail.com>
Date: Thu, 17 Sep 2026 10:01:48 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] scsi: sg: Fix shift-out-of-bounds in
 sg_build_indirect()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <baa2027a-8525-436d-b1b5-0abfa0ebd01a@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <baa2027a-8525-436d-b1b5-0abfa0ebd01a@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz upstream

On 9/16/2026 6:08 PM, syzbot wrote:
> Writing an invalid value such as 0 or a negative number to
> /sys/module/sg/parameters/scatter_elem_sz, or setting it at module load
> time, causes a shift-out-of-bounds bug during subsequent device operations.
> In init_sg(), scatter_elem_sz is checked against PAGE_SIZE, but because
> PAGE_SIZE is unsigned, the comparison is unsigned and bypasses negative
> values. When opening a device via sg_open(), the driver calls
> sg_build_indirect() to allocate scatter-gather buffers. In
> sg_build_indirect(), scatter_elem_sz is read into the local snapshot
> variable num. Because PAGE_SIZE is unsigned, comparing num against
> PAGE_SIZE also results in an unsigned comparison that bypasses negative
> values. Furthermore, even if the condition is met, the code updates the
> global scatter_elem_sz and scatter_elem_sz_prev variables but leaves the
> local snapshot variable num unupdated before get_order(). As a result, an
> invalid value such as 0 remains in num and is passed to order =
> get_order(num). Calling get_order(0) is undefined and underflows to 52 on
> 64-bit systems, causing ret_sz = 1 << (PAGE_SHIFT + order) to compute 1 <<
> 64. Shifting a 32-bit int by 64 bits triggers a UBSAN shift-out-of-bounds
> warning:
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
> Fix this by casting PAGE_SIZE to int in both init_sg() and
> sg_build_indirect() so that the comparisons are signed and negative values
> do not bypass the check, and by updating the local snapshot variable num to
> PAGE_SIZE when num < (int)PAGE_SIZE in sg_build_indirect() before
> get_order() is called.
>
> Fixes: 10db10d144c0 ("sg: convert the indirect IO path to use the block layer")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+270f1c719ee7baab9941@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=270f1c719ee7baab9941
> Link: https://syzkaller.appspot.com/ai_job?id=1d412b83-5bbc-4d73-b690-4c798d45cee4
> To: "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>
> To: "Doug Gilbert" <dgilbert@interlog.com>
> To: <linux-scsi@vger.kernel.org>
> To: "Martin K. Petersen" <mkp@kernel.org>
> To: "FUJITA Tomonori" <fujita.tomonori@lab.ntt.co.jp>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v3:
> - Cast PAGE_SIZE to int in init_sg() to handle negative scatter_elem_sz values at module initialization.
> - Update commit description to cover the initialization-time check in init_sg() alongside the stale local snapshot in sg_build_indirect().
>
> v2:
> - Drop module_param_cb() setter callback and range validation at sysfs boundary.
> - Cast PAGE_SIZE to int in sg_build_indirect() to prevent negative values from bypassing the check.
> - Update local snapshot variable num to PAGE_SIZE when num is less than PAGE_SIZE.
> - Update commit description to explain the unsigned comparison and unupdated local variable, and remove claims regarding parameter data races.
> https://lore.kernel.org/all/4c6c124f-f448-4854-b8dd-9bfc194fa944@mail.kernel.org/T/
>
> v1:
> https://lore.kernel.org/all/30c58052-61b7-4425-9fd7-c188a0bef4ea@mail.kernel.org/T/
> ---
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 5408f002e..46117d1a1 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -1667,7 +1667,7 @@ init_sg(void)
>   {
>   	int rc;
>   
> -	if (scatter_elem_sz < PAGE_SIZE) {
> +	if (scatter_elem_sz < (int)PAGE_SIZE) {
>   		scatter_elem_sz = PAGE_SIZE;
>   		scatter_elem_sz_prev = scatter_elem_sz;
>   	}
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
