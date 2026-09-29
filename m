Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4CA5380FDD
	for <syzbot@lists.linux.dev>; Tue, 29 Sep 2026 07:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790668252; cv=none; b=nzfQT34O1voQpn/f0cinojYMAY3c/TTADw67a6O3G7kA+XxcPnk8U3w2zw8IEYC8f4elq65C4Ksk7o5r8x/K7+UEK/FkXnebJjIrUsl1wP01FCG6zvRHI4FG5xfsSf8KaEdmymyNvA+CnFgnCL7lQ3BKW7Pa4s37hbZ2wNqrpU0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790668252; c=relaxed/simple;
	bh=kTIpIRvVpG/ZH+dDOCbGK3ebkHklaW0cnOg4LiStbQY=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=TIMwf9FIgHnmYpVMTE40VjwCE0XD8lVuE61uK0WbUo7fDixJZ2amTZmctueo+4E75LEZLIQC20AGMSVbFoAz7uNXe1Jhqkx6qiDVGIQxIcbXtXaqrquG2AuOoIwWuhXwV6q95mb17e+GfieImnJvAVfOdC25nW7lZBG9nNb/4SM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XeC/qn1A; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XeC/qn1A"
Received: by smtp.kernel.org (Postfix)
	id 76CEE1F00893; Tue, 29 Sep 2026 07:50:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 346BB1F000FF;
	Tue, 29 Sep 2026 07:50:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1790668250;
	bh=Fb7npZ6qCmfLC75/Yf8Ra6tarlTGGGiRX3kapLiFUDs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XeC/qn1AnP5zb1jYfQiJFcvMxgoaWrNrYKJE+wnBAGxzhAa7oUP7+YMseHeuy0x+n
	 adRB8CAwaQuCdh4+8Rbnp7LXi3xfBSp5RybQExeuf2yTl0Ox2yLTxAdJOSAJRxba/v
	 VwfhshxbF176Tw7IXXh4v7MfXg5VAfcoJ9hAREfACsam2aJPCEznVxIvCBM2JdvCI/
	 fVrW0laI47WYdrbmcHAk8smTr4zdqek1sanwnpK184+lEpZkmdk6z35zTSAXajOkE4
	 ko441qua3cWKGhiNVl2X+era25SKhMtGMBQJ+OALLAYCwkqjLS09rC9Ibfy50frM05
	 m3fL0jXJio+cQ==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH] Input: yealink - abort URB submission on fatal errors
Reply-To: sashiko-reviews@lists.linux.dev
To: syzbot <syzbot@kernel.org>
Cc: linux-input@vger.kernel.org, dmitry.torokhov@gmail.com
In-Reply-To: <fcf3ed99-54ce-4049-9f7d-611827e7adad@mail.kernel.org>
References: <fcf3ed99-54ce-4049-9f7d-611827e7adad@mail.kernel.org>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 29 Sep 2026 07:50:49 +0000
Message-Id: <20260929075050.346BB1F000FF@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] input: yealink: infinite loop on non-fatal URB errors causing RCU =
stall
--

commit 61760b94680b93c5045c5b8ad2cc263df49cc507
Author: Slawomir Stepien <sst@poczta.fm>

Input: yealink - abort URB submission on fatal errors

This commit modifies URB error handling in the yealink driver to abort
submission on fatal errors like -ECONNRESET. For non-fatal errors, it skips
processing and attempts to rate-limit console messages while resubmitting.

Link: https://syzkaller.appspot.com/ai_job?id=3D89a6c0c7-a0c4-4f05-b1b1-e36=
a92e373e0

> diff --git a/drivers/input/misc/yealink.c b/drivers/input/misc/yealink.c
> index 560f895a00cda..f0ec4c5ea94c2 100644
> --- a/drivers/input/misc/yealink.c
> +++ b/drivers/input/misc/yealink.c
> @@ -405,9 +405,19 @@ static void urb_irq_callback(struct urb *urb)
>  	struct yealink_dev *yld =3D urb->context;
>  	int ret, status =3D urb->status;
> =20
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
> =20
>  	switch (yld->irq_data->cmd) {
>  	case CMD_KEYPRESS:

[ ... ]

>  	yealink_do_idle_tasks(yld);
> =20
> +resubmit:

[Severity: High]
Does this goto cause an unbreakable infinite loop when a non-fatal error
occurs?

Because this skips yealink_do_idle_tasks(), the state machine no longer
advances. Since this directly resubmits the control URB without yielding or
advancing state, and because control URBs are not rate-limited by the host
controller's polling interval, will a persistently failing USB device trap
the CPU in a tight softirq spin?=20

Could this trigger the exact RCU stall this patch intended to fix?

>  	if (!yld->shutdown) {
>  		ret =3D usb_submit_urb(yld->urb_ctl, GFP_ATOMIC);
>  		if (ret && ret !=3D -EPERM)
> -			dev_err(&yld->intf->dev,
> -				"%s - usb_submit_urb failed %d\n",
> -				__func__, ret);
> +			dev_err_ratelimited(&yld->intf->dev,
> +					    "%s - usb_submit_urb failed %d\n",
> +					    __func__, ret);
>  	}
>  }
> =20
> @@ -443,9 +454,21 @@ static void urb_ctl_callback(struct urb *urb)
>  	struct yealink_dev *yld =3D urb->context;
>  	int ret =3D 0, status =3D urb->status;
> =20
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
> +			ret =3D usb_submit_urb(yld->urb_ctl, GFP_ATOMIC);
> +		goto out;

[Severity: High]
Does this introduce a similar infinite loop in the control URB callback?

Previously, if a non-fatal error occurred, the switch statement below could
evaluate to CMD_KEYPRESS or CMD_SCANCODE, which would submit the rate-limit=
ed
interrupt URB (urb_irq).=20

By unconditionally resubmitting urb_ctl here and jumping to out, we bypass
the normal state machine progression and continuously submit the
non-rate-limited control URB. Can this lead to an un-throttled CPU spin if
the device repeatedly returns a non-fatal hardware error?

> +	}
> =20
>  	switch (yld->ctl_data->cmd) {
>  	case CMD_KEYPRESS:

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/fcf3ed99-54ce-4049-=
9f7d-611827e7adad@mail.kernel.org?part=3D1
