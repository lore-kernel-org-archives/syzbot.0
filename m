Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E997236606A
	for <syzbot@lists.linux.dev>; Mon, 14 Sep 2026 08:08:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789373296; cv=none; b=n0BI5W2zBKOp8ulVYgLNST862flKOVndqF3HnDxgsxvSi5gkPekSpfqRw9VlLGkmnb+nTWM2kMf0kGzq34NileBNPggsXkn40RyFFAzTDlvv4E6/NfhqzwBzYbKihb6OQ+0P7Y6RbIac3tdK+2/nr7wNqmtjgs+HLdZwWQ6xXZs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789373296; c=relaxed/simple;
	bh=rw4QtB1quOB2SF14WCCULD2ghoyeo0Hhu4MA8U+XODQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=YFP2tZkOEvPKCJAtvX+muXOjJL2sUG2O/3sN/mwrPRVB3GJzFmCaXNAP/dr2Pa4sunKmkQ2xETt/V4Awo+yhWq7U46TPxddSqHvlhUjcXozrt4AqXbvEU2pBzPrfBTA/iqgndU/wGoR+RxSxC0rzRy6U2NY9DVPRxRcxDpk8vSg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=cwxQ/oVT; arc=none smtp.client-ip=217.74.67.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="cwxQ/oVT"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon, 14 Sep 2026 10:08:08 +0200 (CEST)
Date: Mon, 14 Sep 2026 10:08:06 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] Input: yealink - abort URB submission on fatal errors
Message-ID: <aqerZhAv7Wyd3DoO@nr200>
References: <57cf484d-3235-473f-a61d-570585626176@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <57cf484d-3235-473f-a61d-570585626176@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1789373290; bh=6Q44hS6cWjepzFYPi0oJgn3QmmsbU1x2HHZWAMTLdKI=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=cwxQ/oVTW4+NefymiY4ebR/hBYvh4jWhzgqYk/W/riUXodla8VPG8hWmSNKf12RYg
	 LMjH4zr60JWqSaSvNZmT2Xeax7RXoF0ccHmIWCYy31nRYWH21TQACQ9/kZ/rk4UN0Z
	 SJXXrw+F/czkhjT0deRT4k+j32izSFpbOc40GTGQ=

On lip 22, 2026 17:46, 'syzbot' via syzkaller-upstream-moderation wrote:
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
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+78e2288f58b881ed3c45@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=78e2288f58b881ed3c45
> Link: https://syzkaller.appspot.com/ai_job?id=6ef5721d-1286-4deb-85e1-d7201e028127
> To: "Henk Vergonet" <Henk.Vergonet@gmail.com>
> To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
> To: <linux-input@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
> index 560f895a0..232d8e71b 100644
> --- a/drivers/input/misc/yealink.c
> +++ b/drivers/input/misc/yealink.c
> @@ -405,9 +405,21 @@ static void urb_irq_callback(struct urb *urb)
>  	struct yealink_dev *yld = urb->context;
>  	int ret, status = urb->status;
>  
> -	if (status)
> +	if (status) {
>  		dev_err(&yld->intf->dev, "%s - urb status %d\n",
>  			__func__, status);
> +		switch (status) {
> +		case -ENOENT:
> +		case -ECONNRESET:
> +		case -ESHUTDOWN:
> +		case -EPROTO:
> +		case -EPIPE:
> +		case -EILSEQ:
> +			return;
> +		default:
> +			break;
> +		}
> +	}
>  
>  	switch (yld->irq_data->cmd) {
>  	case CMD_KEYPRESS:
> @@ -443,9 +455,21 @@ static void urb_ctl_callback(struct urb *urb)
>  	struct yealink_dev *yld = urb->context;
>  	int ret = 0, status = urb->status;
>  
> -	if (status)
> +	if (status) {
>  		dev_err(&yld->intf->dev, "%s - urb status %d\n",
>  			__func__, status);
> +		switch (status) {
> +		case -ENOENT:
> +		case -ECONNRESET:
> +		case -ESHUTDOWN:
> +		case -EPROTO:
> +		case -EPIPE:
> +		case -EILSEQ:
> +			return;
> +		default:
> +			break;
> +		}
> +	}

How about putting the switch statement in a separate function, so we can use it in both callbacks? I
would be easier that way to update the list of fatal errors.

>  	switch (yld->ctl_data->cmd) {
>  	case CMD_KEYPRESS:
> 
> 
> base-commit: 1590cf0329716306e948a8fc29f1d3ee87d3989f

-- 
Slawomir Stepien
