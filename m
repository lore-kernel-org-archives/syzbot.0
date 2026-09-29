Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE4C231E831
	for <syzbot@lists.linux.dev>; Tue, 29 Sep 2026 07:37:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790667478; cv=pass; b=GLsSRlv2QjV6Sgk9iZ+wA3RckqGQUq+NE4Pn5nlihPOGRn8XR3/dOIUSKSrK6n9MNCYG/LjL7CvUBTLNZLODCtuJJenBLVaX7BmT+3IUzNWCmTN7YgMigGzb9b5RK1kiiGz0zF+AXHAlVxn405hLfIbt7XHE7B6nQV5TItZAi2w=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790667478; c=relaxed/simple;
	bh=nWg7RveA25O12Gckd+8sVaw0+l/vDP2LFLj9ljLGHwo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=XkaS0/HCgv8doJjXXchC5dcwQpBSQe5TUzf2oepfu56RfwJ1LVNIDqihckMiw9tLGTPdcgDBt/lEcEwpq1vfSCBv1XTXW+1JUkjFMNPlvNmEp+mMtekSb70XdqAt05kqgzlb1dSpwdR2zgVt34xiYAGVXsLT4TvM0LSsSv8n/lA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=KWpSK/Ns; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="KWpSK/Ns"
Received: by smtp.kernel.org (Postfix)
	id 972A71F00893; Tue, 29 Sep 2026 07:37:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.63
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1790667475;
	b=gczRDFG4mjhLWxnq2OK4R1Lc3XwPIKdAfNuzL9/UY3pfQSHkcaBnHX76msJeOZvjc8l9
	 KxQDfTDX+Sl8F80n9+UGPQMPDjx1RuTqHiBctfe0ykZo+1FbZROI5mpp+1+3K/CdGASNw
	 G8GDlOmy0XGdZBY5bo4j2EQoQRizgRRlN+X40kVdsSCQ7hJ8wp1lmHC02cCuDT12QyLI8
	 Hg1lnzuZp/Jt1MOGe3n3QquGNmZhlqnLprIMaQJud/gAXDhZA3E6fohgHzbSFgXsLwha/
	 00AcEtjR3S90wx4swMFNDpcwBGgT/4sHi0kPmLhfXRqqyEomrhiw3jsKUyqLL0Rzdvg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1790667475;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=2YXvCDsBxJIG1/1TzlcCDGWOoIB5ki37oEWeGVgw1vY=;
	b=kiZKQh0KmLiFkGS7Ye9x38zx5MVDIDOkNZ+1QSbanpXZAmOmNS2cML+r9kVsx7jzuIoj
	 b/QN3eeFg2retpuKcSe1nNMcCjdaEJIRkWiMCitFK4DmJdRVHTRslmbAo6vKE/exjAIv0
	 4uBFGR9U6yzN/HvmKm01paRT3nwEhDlGMQrhnmot+cVkYX7pD4J8aLZ8zSAv5mdBDc1ET
	 aFFcsy+NH/HRmDk1hDQVoe+9OvuoDY4snBKg3mIu+ZTQ2+aug0aF8yA6eqJU6fpwt6Adh
	 clZBKw6cB+u2ATVLhxw4Ao1KtPl/HXLiOJ3HtOnd50PmRd25IX8233X6SmWYzKU2Ong==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b="KWpSK/Ns";
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.63
Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8A1291F000FF
	for <syzbot@kernel.org>; Tue, 29 Sep 2026 07:37:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=KWpSK/Ns
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 8A1291F000FF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Tue, 29 Sep 2026 09:37:43 +0200 (CEST)
Date: Tue, 29 Sep 2026 09:37:41 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v4] Input: yealink - abort URB submission on fatal
 errors
Message-ID: <artqxUMtbKPkAVzY@nr200>
References: <ec4cb3d1-f22e-4bd4-94d8-1563a62cfeb5@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ec4cb3d1-f22e-4bd4-94d8-1563a62cfeb5@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1790667465; bh=2YXvCDsBxJIG1/1TzlcCDGWOoIB5ki37oEWeGVgw1vY=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=KWpSK/NsxZRo/Wu9djpiEFYsi5Vu4NM9Dwex170UE7qrNYWy2OnpUrYNBjfPpYZkF
	 SyWkoa9sR+Itbv1invGEYeyMdUC/pTgDYZ+770aHYIhIIHBR73VLF0wnROIzOBCcIM
	 zPn+y70dz44xilqtFTX7KTspeGE4WOfASeP00TBY=

#syz upstream

On wrz 21, 2026 08:46, syzbot wrote:
> The yealink driver uses two URBs (interrupt and control) to communicate
> with the device. When an URB completes with an error status (such as
> -EPROTO), the completion handlers (urb_irq_callback and urb_ctl_callback)
> log the error but do not abort. Instead, they proceed to process the
> potentially invalid data and unconditionally resubmit the URB.
> 
> Because control URBs are not rate-limited by the USB core, resubmitting a
> failing control URB in a tight loop floods the console with error messages
> and keeps the CPU completely busy in the softirq context. This eventually
> triggers an RCU preempt stall:
> 
> yealink 3-1:36.0: unexpected response 0
> yealink 3-1:36.0: urb_ctl_callback - urb status -71
> rcu: INFO: rcu_preempt self-detected stall on CPU
> Call Trace:
>  __console_flush_and_unlock kernel/printk/printk.c:3373 [inline]
>  console_unlock+0xd1/0x1c0 kernel/printk/printk.c:3413
>  dev_vprintk_emit+0x338/0x400 drivers/base/core.c:4996
>  dev_printk_emit+0xee/0x140 drivers/base/core.c:5007
>  usb_generic_driver_probe+0x10b/0x150 drivers/usb/core/generic.c:252
>  ...
>  hub_event+0x28e8/0x4d30 drivers/usb/core/hub.c:5953
>  worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
>  kthread+0x388/0x470 kernel/kthread.c:436
> 
> Fix this by checking the URB status for fatal errors (-ECONNRESET, -ENOENT,
> -ESHUTDOWN, -ENODEV) in both urb_irq_callback() and urb_ctl_callback(). If
> a fatal error is detected, the callback now returns early, breaking the
> resubmission loop. For other non-zero statuses, skip processing the
> response data and jump directly to resubmission. Additionally, use
> dev_err_ratelimited() instead of dev_err() to prevent flooding the console
> and triggering an RCU stall.
> 
> Fixes: aca951a22a1d ("[PATCH] input-driver-yealink-P1K-usb-phone")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+78e2288f58b881ed3c45@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=78e2288f58b881ed3c45
> Link: https://syzkaller.appspot.com/ai_job?id=89a6c0c7-a0c4-4f05-b1b1-e36a92e373e0
> To: "Henk Vergonet" <Henk.Vergonet@gmail.com>
> To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
> To: <linux-input@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v4:
> - In urb_ctl_callback(), resubmit urb_ctl directly instead of jumping into the switch statement.
> 
> v3:
> - Only abort URB submission on fatal errors (-ECONNRESET, -ENOENT, -ESHUTDOWN, -ENODEV).
> - Skip processing packet data and jump directly to resubmission on non-fatal errors.
> - Use dev_err_ratelimited() instead of dev_err() to prevent console flooding.
> - Drop is_fatal_error() helper in favor of switch statements.
> https://lore.kernel.org/all/2b0508e9-fe78-40dd-a290-7156817e394c@mail.kernel.org/T/
> 
> v2:
> - Factored out fatal error checks into is_fatal_error() helper
> https://lore.kernel.org/all/2a0b5e96-dd8a-4ce9-ba3f-dd9efa26275d@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/57cf484d-3235-473f-a61d-570585626176@mail.kernel.org/T/
> ---
> diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
> index 560f895a0..f0ec4c5ea 100644
> --- a/drivers/input/misc/yealink.c
> +++ b/drivers/input/misc/yealink.c
> @@ -405,9 +405,19 @@ static void urb_irq_callback(struct urb *urb)
>  	struct yealink_dev *yld = urb->context;
>  	int ret, status = urb->status;
>  
> -	if (status)
> -		dev_err(&yld->intf->dev, "%s - urb status %d\n",
> -			__func__, status);
> +	switch (status) {
> +	case 0:
> +		break;
> +	case -ECONNRESET:
> +	case -ENOENT:
> +	case -ESHUTDOWN:
> +	case -ENODEV:
> +		return;
> +	default:
> +		dev_err_ratelimited(&yld->intf->dev, "%s - urb status %d\n",
> +				    __func__, status);
> +		goto resubmit;
> +	}
>  
>  	switch (yld->irq_data->cmd) {
>  	case CMD_KEYPRESS:
> @@ -429,12 +439,13 @@ static void urb_irq_callback(struct urb *urb)
>  
>  	yealink_do_idle_tasks(yld);
>  
> +resubmit:
>  	if (!yld->shutdown) {
>  		ret = usb_submit_urb(yld->urb_ctl, GFP_ATOMIC);
>  		if (ret && ret != -EPERM)
> -			dev_err(&yld->intf->dev,
> -				"%s - usb_submit_urb failed %d\n",
> -				__func__, ret);
> +			dev_err_ratelimited(&yld->intf->dev,
> +					    "%s - usb_submit_urb failed %d\n",
> +					    __func__, ret);
>  	}
>  }
>  
> @@ -443,9 +454,21 @@ static void urb_ctl_callback(struct urb *urb)
>  	struct yealink_dev *yld = urb->context;
>  	int ret = 0, status = urb->status;
>  
> -	if (status)
> -		dev_err(&yld->intf->dev, "%s - urb status %d\n",
> -			__func__, status);
> +	switch (status) {
> +	case 0:
> +		break;
> +	case -ECONNRESET:
> +	case -ENOENT:
> +	case -ESHUTDOWN:
> +	case -ENODEV:
> +		return;
> +	default:
> +		dev_err_ratelimited(&yld->intf->dev, "%s - urb status %d\n",
> +				    __func__, status);
> +		if (!yld->shutdown)
> +			ret = usb_submit_urb(yld->urb_ctl, GFP_ATOMIC);
> +		goto out;
> +	}
>  
>  	switch (yld->ctl_data->cmd) {
>  	case CMD_KEYPRESS:
> @@ -462,9 +485,11 @@ static void urb_ctl_callback(struct urb *urb)
>  		break;
>  	}
>  
> +out:
>  	if (ret && ret != -EPERM)
> -		dev_err(&yld->intf->dev, "%s - usb_submit_urb failed %d\n",
> -			__func__, ret);
> +		dev_err_ratelimited(&yld->intf->dev,
> +				    "%s - usb_submit_urb failed %d\n",
> +				    __func__, ret);
>  }
>  
>  /*******************************************************************************
> 
> 
> base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f

-- 
Slawomir Stepien
