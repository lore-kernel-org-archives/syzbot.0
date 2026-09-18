Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0FBB34B1295
	for <syzbot@lists.linux.dev>; Fri, 18 Sep 2026 08:49:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789721365; cv=pass; b=NIsjVt5dDQJDojZ6yTK9XXVuuHsW4IaJaKz4PjpiWScNKljUIeMRHuuqWrJQyg0f2Bx73UO8IlqYOK3S09NkNjWr4grY2q7QEAFCOs6LcQyhLwdRU/z1Kluhg5DEpRL/0HlJTM+7BOCM89tgiA5Ml6ZSjFQaRocrGV6OMvY9n0A=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789721365; c=relaxed/simple;
	bh=PHC5GzWNOD12NDOPGsJ2An2ZCiWDhOIMrHiLI0N7BhM=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=lA36mp4OQAElEZ/ZbPeDAlBnX09qrpOnmEOFQvyuxRACZSG1B1g5fI63a0Q64tNiOOZXlFIpq8yN1zTAg2eEw/T7Vg42AdLsCkekUJwndJV4kRG0ZC3ZDB5oOz5uTqjHki/3KRtdoUPE5/p6MKHxmzN7HEhpm9n1UjiEHo5RYT0=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=XUic3hej; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="XUic3hej"
Received: by smtp.kernel.org (Postfix)
	id DA62C1F00893; Fri, 18 Sep 2026 08:49:19 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.49
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1789721359;
	b=3h7deufn+7yL9RTnFooKoXmDSBIkvaeggX1KXJ2n6geVv5DivswXR9go4sUwkQwiE3Rb
	 bGU7LCluiHxBUna7bENXZG6wJsRi0N9Y0SYSFL94uecHYFiDxNttOFqhz7mbkLfjBwwYe
	 B3A2AhrC5STzfj5vGzQI9rpfl3pz3cMSZCZThSNRXXyNSYQwShLyR6s1iofhHJ9uP6hfj
	 F3XnfJ2KdhnOsoTS7NevT67ddneMh/bDqgjvr7tizeuvI2Ljp8AnJemqYPBlf7bL3Xe9Q
	 1tXpFKoFlEcirIwfYuCTid96hlTEU5A3gjdjr1yuXFPGqScTGlpPM8iMPiAhrEum/Sw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1789721359;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=+0zqksL8GxEdSo+Sy2Ss2zkUxTQA19xxT2nvsftLHes=;
	b=obLX1sye5HAQFWTqDbIH0dC9XUltBgvVlLITFME+FeDtGEXlLx1bMw4RwJKFNVN+UPNF
	 667RcQZDkhazY9LSZw3TgdyYQxxhFuySPWYOmrvvs7iz2wvdPPueV83uE1/fMwVz4qDE0
	 BOv2iiQH971C7RsOTMZC60WO4OB75LPhIesWTcM9IFDFDz/QI6Q85ubK4q1UfQwkqCpWK
	 tSEaxeU73ONcKkxKX4sHdDq/iVvZBq1T/ktwT9yjcYGa5/PM+MXPUQFAgzE5d+C5rpJvZ
	 DiPKKes+PaYvDM/gpfqMt8YJ4izY3F4P18WVEXIwnfxI+T4Bz6qK+AGpoWnODRDE63A==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=XUic3hej;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.49
Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 9BAC51F000FF
	for <syzbot@kernel.org>; Fri, 18 Sep 2026 08:49:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=XUic3hej
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 9BAC51F000FF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Fri, 18 Sep 2026 10:49:08 +0200 (CEST)
Date: Fri, 18 Sep 2026 10:49:06 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] Input: yealink - abort URB submission on fatal
 errors
Message-ID: <aqz7AsLU2R13JNQc@nr200>
References: <2a0b5e96-dd8a-4ce9-ba3f-dd9efa26275d@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a0b5e96-dd8a-4ce9-ba3f-dd9efa26275d@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1789721349; bh=+0zqksL8GxEdSo+Sy2Ss2zkUxTQA19xxT2nvsftLHes=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=XUic3hejuahXyQoSVskpn49lTZCLE/UHcKozVixE2ysUbBQGZnZK+AyVa3nrg6SSp
	 oyw3mR6mcDLFfFEbWdgWhkmzd43pE41SNL4rG4dDSt4vz9Iy9JQnVJNubbNJxJpk7T
	 Ob8dh9LE8/OUkjbLvA5B16nzqXRSO4YQ2tfFSF+M=

On wrz 14, 2026 09:09, syzbot wrote:
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
> Fix this by explicitly checking the URB status for fatal errors (-ENOENT,
> -ECONNRESET, -ESHUTDOWN, -EPROTO, -EPIPE, -EILSEQ) in both
> urb_irq_callback() and urb_ctl_callback(). If a fatal error is detected,
> the callback now returns early, breaking the infinite resubmission loop and
> preventing the RCU stall.
> 
> Fixes: aca951a22a1d ("[PATCH] input-driver-yealink-P1K-usb-phone")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+78e2288f58b881ed3c45@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=78e2288f58b881ed3c45
> Link: https://syzkaller.appspot.com/ai_job?id=479730c2-f271-451c-a31b-837d89cb018e
> To: "Henk Vergonet" <Henk.Vergonet@gmail.com>
> To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
> To: <linux-input@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v2:
> - Factored out fatal error checks into is_fatal_error() helper
> 
> v1:
> https://lore.kernel.org/all/57cf484d-3235-473f-a61d-570585626176@mail.kernel.org/T/
> ---
> diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
> index 560f895a0..bf91f40cd 100644
> --- a/drivers/input/misc/yealink.c
> +++ b/drivers/input/misc/yealink.c
> @@ -400,14 +400,32 @@ static int yealink_do_idle_tasks(struct yealink_dev *yld)
>   * error,start
>   *
>   */
> +static bool is_fatal_error(int status)
> +{
> +	switch (status) {
> +	case -ENOENT:
> +	case -ECONNRESET:
> +	case -ESHUTDOWN:
> +	case -EPROTO:
> +	case -EPIPE:
> +	case -EILSEQ:
> +		return true;
> +	default:
> +		return false;
> +	}
> +}
> +
>  static void urb_irq_callback(struct urb *urb)
>  {
>  	struct yealink_dev *yld = urb->context;
>  	int ret, status = urb->status;
>  
> -	if (status)
> +	if (status) {
>  		dev_err(&yld->intf->dev, "%s - urb status %d\n",
>  			__func__, status);
> +		if (is_fatal_error(status))
> +			return;

Lets change the approach here. Drop the is_fatal_error() and:
1. switch on status: if the status is 0 just break of out the switch.
2. If there status is one of -ECONNRESET, -ENOENT, -ESHUTDOWN or -ENODEV return quick since we
cannot recover from these.
3. For other cases, try to resubmit the urb if !yld->shutdown.

Do the same also for urb_ctl_callback.

In addition to that, change dev_err to rate limiting version in both callbacks.

> +	}
>  
>  	switch (yld->irq_data->cmd) {
>  	case CMD_KEYPRESS:
> @@ -443,9 +461,12 @@ static void urb_ctl_callback(struct urb *urb)
>  	struct yealink_dev *yld = urb->context;
>  	int ret = 0, status = urb->status;
>  
> -	if (status)
> +	if (status) {
>  		dev_err(&yld->intf->dev, "%s - urb status %d\n",
>  			__func__, status);
> +		if (is_fatal_error(status))
> +			return;
> +	}
>  
>  	switch (yld->ctl_data->cmd) {
>  	case CMD_KEYPRESS:
> 
> 
> base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f

-- 
Slawomir Stepien
