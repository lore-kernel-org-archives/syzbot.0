Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFFE3BE647
	for <syzbot@lists.linux.dev>; Mon, 21 Sep 2026 08:01:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789977683; cv=pass; b=QvAbe6GLCnIU/fbiLvJnR5xreFBCuMlKXUHGtpLVaWSP4rO0+vHFgiibePUdckEZ8Ac/onNg/YAK93oFKDP6nHQ0708jzWeClgMSVbNvDI46Z6Yp5jiKYFDwFxDs/4ECbDwggWQPLUEp+XIE7ymVFeriE1qOnjZIUGvKxvQwuKg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789977683; c=relaxed/simple;
	bh=RN/D42EWk9WFhL+pB3XQYeVjVf7hzSytYfW3oUqKqlo=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lVN6xYuTPplaIkK4wwvKrgHVUZmMbW8dKeRr4GN6CfDfWNlW3ph3a7u1gYDxwGIqntKPG4UNMrSeUzr29YiMIQ/iKNYMPLh1drdcf+t8Z7uQuLRM1kHhPEw6166xr+JFIlaNUu9wZt1ODddOQWBJpqL6ARjb/rvaw8AyHNmDB6w=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=YcyKKuVw; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="YcyKKuVw"
Received: by smtp.kernel.org (Postfix)
	id E1E551F00893; Mon, 21 Sep 2026 08:01:20 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.63
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1789977680;
	b=dzgjQu0Rg4SO/SiH1qZFJiXfPNTahYXLgRrrAhkmuLn4ltKAfU8M9ZoDvJHDkZvJAMpf
	 ZJiMTsRW87bu8P1r+lTN0HHpk2Gs/ii9KbpqJNB0S6gVpv3iGbcfSo2Q8BLDCRonrFGzS
	 tz6Oi3fjFqD4ZGszfEGzT/mzb9L/47BmoSjRnkuGuJYdWNPjy+VivI/b5BNc4Z6ucYfDH
	 MQ542eXRwRJYjras2PcFD4wQAy9uPaPfq+p4AVaxcfC9F972gG9dG5XzXKB5B+35k/dMG
	 aop6XEiRRz0WWjc4kxiaDJnb6AFqkZwp0CsCE3NSp0le/fQqfDvmTweHS9YgpWF3/fg==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1789977680;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=HrgTW7FHmQo3G5WSFB+5FOCpaTdYtlORvOx7OaZv8x8=;
	b=pJvRqwyjgtdxpjhrUNvTxBRWuFUDV5fXToHsJU2M0Pizb08MGi1l7JYDnH9XfdWXMZWL
	 g3tx+6fZ/fPOP8Bulitsr1aMjkmdTNBJlfdbCzzmrK2zi4+BZqm0oIvDTKkm5vwcgHPxv
	 RT6RjIPbQ2za8VqkKt7JR6g76hL2k1H2RszSCyeJNIZMlBMNS6UkeI3mqudCngyghnWyC
	 NiPdChsCxik7AaVlYA8bZPDWyRDNwBHPbT+FhmusYM9OdrbWv6imdmhtxCuukk3tC+kBv
	 el9kPhp+S/ubgGUr7TL8Eocc+CAXDzP1u9X1Ck+IyELZvm4yXaXwAZi/nHJHEU7XRiw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=YcyKKuVw;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.63
Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id A16791F000FF
	for <syzbot@kernel.org>; Mon, 21 Sep 2026 08:01:18 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=YcyKKuVw
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org A16791F000FF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon, 21 Sep 2026 10:01:09 +0200 (CEST)
Date: Mon, 21 Sep 2026 10:01:07 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v3] Input: yealink - abort URB submission on fatal
 errors
Message-ID: <arDkQzftGxevJ02n@nr200>
References: <2b0508e9-fe78-40dd-a290-7156817e394c@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b0508e9-fe78-40dd-a290-7156817e394c@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1789977670; bh=HrgTW7FHmQo3G5WSFB+5FOCpaTdYtlORvOx7OaZv8x8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=YcyKKuVwQMuei7o5zh9WyNXkCzRgCiX8ml+cHZd8Iml0eXckAAeu/eSTXy5MAAi9c
	 Bh7+LbM7gKsb4MRCx0yb1lO/ZOeYMP+UXuVJFc/2cIFYrA61q6R94d7nte52iu5VXw
	 Rc0ifT7CJuydMQahudOwpyDR8SfdkwnbtXIT7LD4=

On wrz 18, 2026 16:55, syzbot wrote:
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
> Link: https://syzkaller.appspot.com/ai_job?id=24a48a3f-a005-45ce-9020-4a27b38d9683
> To: "Henk Vergonet" <Henk.Vergonet@gmail.com>
> To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
> To: <linux-input@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v3:
> - Only abort URB submission on fatal errors (-ECONNRESET, -ENOENT, -ESHUTDOWN, -ENODEV).
> - Skip processing packet data and jump directly to resubmission on non-fatal errors.
> - Use dev_err_ratelimited() instead of dev_err() to prevent console flooding.
> - Drop is_fatal_error() helper in favor of switch statements.
> 
> v2:
> - Factored out fatal error checks into is_fatal_error() helper
> https://lore.kernel.org/all/2a0b5e96-dd8a-4ce9-ba3f-dd9efa26275d@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/57cf484d-3235-473f-a61d-570585626176@mail.kernel.org/T/
> ---
> diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
> index 560f895a0..c67c619db 100644
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
> @@ -443,9 +454,19 @@ static void urb_ctl_callback(struct urb *urb)
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
> +		goto resubmit;

I do not like this jump to inside a default case. Maybe just check for yld->shutdown and do
usb_submit_urb here and then do goto to lines below to check ret value?

> +	}
>  
>  	switch (yld->ctl_data->cmd) {
>  	case CMD_KEYPRESS:
> @@ -457,14 +478,16 @@ static void urb_ctl_callback(struct urb *urb)
>  	default:
>  		/* send new command */
>  		yealink_do_idle_tasks(yld);
> +resubmit:
>  		if (!yld->shutdown)
>  			ret = usb_submit_urb(yld->urb_ctl, GFP_ATOMIC);
>  		break;
>  	}
>  
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
