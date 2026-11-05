Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793886543;
	b=S/KGQVLTaHaQHzB9SdLPTqyhZZFU9ExceoLoRVpO6pMi8R+82FJSOGEsW4bc4r+aUdb3
	 KPFVHMKPy7b+SLVU+Hw2Zyv35GI5iEOPuT0Jrr3ngC/oddtZhSIBrVCfw+o9mVg+cwdHt
	 RXIHqadkXy1kF/x3oDdhYpz3WqwihOPyt7gQTq4fgC70ReCy/f9/Y2ipkj/vrvAwiDfMd
	 eNxrCMYtOzw9epaxAXCDIgc+CYolQNKx7AckoKMLHuDfQiZnPWmxRFSiY9cqLz8LdMstc
	 b4gcAgktiMAGAdHsOVRmOUCzT1Bu4eTweJyiRiphpu8GFQDgPAQjOre4HW7WTT6MOmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793886543;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=E3tEucsF7N051VU6XTzIN8SUeD8c5M/D85uxkVAebaM=;
	b=zSoWnuX5oulkxPBBSb7Bnht0vjqQIIn+wPPT0lCB3bhSKc/wZh3pQY0SMj88GaFZhdHh
	 reur2u7vPTRwpjGMJ7S1OV5kJowe02YDZMbd2wG7TnR3+vxKliSImvoAph9A60zXzD4w9
	 DNZK5hGIFTU+nfmqEwpY+CPYoYfXqsrXq4fSBrSobfZ33T9Ytpb9jcxyk7BMaeI+7D6lj
	 3um6RWK9ndTi3fex9DnT5F+flXk7f6xg1rBNDi/8gyp4uca5GgmpXWJJS10n6V8nhg6xN
	 6ki7KpWFNdasR3x4+5gMaS4XN/oibP/HZg3mKsBQvQ3x/QC2OrSpB537x50FMbU+s9g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iBLvWPHR;
	arc=none smtp.remote-ip=209.85.208.49
Received: from mail-ed1-f49.google.com (mail-ed1-f49.google.com [209.85.208.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9D5BA606A31B
	for <syzbot@lists.linux.dev>; Thu,  5 Nov 2026 13:49:02 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9D5BA606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=iBLvWPHR
Received: by mail-ed1-f49.google.com with SMTP id 4fb4d7f45d1cf-6b581b6b0e9so723728a12.2
        for <syzbot@lists.linux.dev>; Thu, 05 Nov 2026 05:49:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793886541; x=1794491341; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=E3tEucsF7N051VU6XTzIN8SUeD8c5M/D85uxkVAebaM=;
        b=iBLvWPHRW4aytRpR2AZaHMVE18hfwsLkmIpt8q6/B4fpHn8pDOnVy6ob4opS8CCV/3
         yn9p8lzo81fZasVspgCcvEEvQVIrdxpz8cxi5AVQ3/fJP2za6Ot6NC7gEzYTznGqPct/
         8DM3z6KjHQQhhOIgTuBkGR+Za3/ZaEB08YQ0y6IoYINWOA2JYWJSfCHlUq9B2jojPZuw
         GkL8uXDyupNNso++jhY1yxWdyoYo6gGjkQvCQyGQ1PFF3xZOinFUu4YkwZyOcXFR/TA/
         iuEL0aoByQEqeyed+PVf1u3Qx0LC6pejBzhsYiQRAI8GvTO43yMBCB0fYomEgHUNaFVU
         5uaA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793886541; x=1794491341;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=E3tEucsF7N051VU6XTzIN8SUeD8c5M/D85uxkVAebaM=;
        b=IXmln+r9Mn30wytN1AwnyV3+0OmCmZeo0zXblbeG0FU43u8mN2yIt+KAofp1pGTEZ6
         APf/8m1qXE1kpyAAfOVJB6LbiAqH4YaKeo5zLyPPWXxKJsG1zxfmiPVIlLsBzA5Z0tbQ
         YbuXQj/6yqkDSnH2DvN09FFrylHKBngU2qG+zM62aTVWPwGkzMeHj2H07v5KE/rwEbzt
         /CHY6Gx1QDJthtYt0P6FskW4SEassQKAOKo9tHNaEW45C2llxIV7WRu/JKPqQigerLid
         iqDpz+57WKpKTGelyRmXHEkTQZv/l0VzI0YsBpkKq7U+ULIX+Q7rZ/VYdYpUzJSvXNQg
         +wCA==
X-Forwarded-Encrypted: i=1; AKwUvBwrYu+m9Zeauj15OzY8OwofsDiMYv5cEqADRSf/21OXRtxgIrU4vjSdHe3b83DSRTcp0j/fktY=@lists.linux.dev
X-Gm-Message-State: APuU4Z88Q0VbDo2ztqJqhuYO3OhfRibzZkEwxUvawNrnQ0c/86Mt+7Lr
	v6XI/b3QjXJ/6xHIJg+t6ahTdak/twgv2nVvXoyz/2w0mc0oav7N7TtujrDnKs7x
X-Gm-Gg: AYBFou0+gti1Hc5Tv8LiqyVXQ2750h93M+msGKM9j2JvVSz9HJn1ia6IMpPQSSe1CtQ
	Vg19oX+9fkX1AaDuthDFRb6XoqSX3A3lRDSO5wFF8d3PpOlUnDjmCQAecdblI/woiKIxq/vYWjD
	bAf6N5QmOs50j3/lnRnSUzeZ+03/IBZ9TBVhoC7oDy5rCfIEscLybJZiRR1F+r1pXuRcr9rMAxu
	YKp2cG78uieXrXR79Q+3ucg1n/XukBJlWryEi/uvDJvvvdoYsztRkZd6OlbX3QduIftvYNIyjwt
	3Oqjg79wXKO/B/NUBwRErJWsMNdbpctQn+bQ41hrwZYCNZJJKG3CjDKJwrWudNodGUW7cTqM6LA
	hnLKZGHwWT0pCH3g9xIQ/hBrJCEdZg6r6LGymu90MgeztA1vzGsXU9wpV7MoiNCKfEoUlFOt5tO
	Bb49C7I6ZTY/fPxe/yYUSM+wJ6ZqOVINOL4LEAiSj3r2sccbrSRSGa97dkq4cMIdgNrhyJUHAzI
	L61JgdEUL2MGX6FEqj/S4qk2AIJlpyqxLPCF5N4g2y3DHdpmUekCKN1BeRzJl3UsJ1pVtJr4Z9E
	P3VcCkNYoir1AUdeYL/BBbA54qHYzLZgCIvBygIA0gS98Vc=
X-Received: by 2002:a17:906:7314:b0:c40:5de7:33d3 with SMTP id a640c23a62f3a-c4ca7b450f4mr1613056266b.35.1793886540777;
        Thu, 05 Nov 2026 05:49:00 -0800 (PST)
Received: from localhost ([188.146.174.10])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d0e4657f6sm178356166b.50.2026.11.05.05.49.00
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 05:49:00 -0800 (PST)
Date: Thu, 5 Nov 2026 14:48:59 +0100
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v3] media: mxl111sf: initialize state->d and fe_lock
 in probe
Message-ID: <jwlmqsir4wt5a6i4rh7hfwjz6gp4wq3n6x3su5vbrcpfnuoi2c@dkpjx3a544pt>
References: <1254a17b-2364-4158-aac0-5baea0244507@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1254a17b-2364-4158-aac0-5baea0244507@mail.kernel.org>

#syz upstream

On Thu, Nov 05, 2026 at 01:42:17PM +0000, syzbot wrote:
> During device initialization in dvb_usbv2_probe(), the dvb-usb-v2 core
> allocates the dvb_usb_device structure and its private state (struct
> mxl111sf_state) via kzalloc(), then invokes dvb_usbv2_init(). Within
> dvb_usbv2_init(), dvb_usbv2_i2c_init() registers the I2C adapter with
> i2c_add_adapter(), which immediately exposes the I2C adapter to userspace
> via the /dev/i2c-X character device.
> 
> However, state->d was only assigned later during frontend attachment inside
> dvb_usbv2_adapter_frontend_init() via d->props->frontend_attach(). If
> userspace performs an I2C transaction before frontend_attach() completes,
> mxl111sf_i2c_xfer() delegates to mxl111sf_ctrl_msg(), which reads state->d
> and passes it to dvb_usbv2_generic_write() or dvb_usbv2_generic_rw(). Since
> state->d is still NULL, dereferencing &d->usb_mutex inside
> dvb_usbv2_generic_write() triggers a null-pointer dereference crash.
> Although the crash report was captured in compat mode with PTI, the failure
> is illustrated by the following x64/NOPTI trace:
> 
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000018: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x00000000000000c0-0x00000000000000c7]
> RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:625 [inline]
> RIP: 0010:__mutex_lock+0x149/0x1550 kernel/locking/mutex.c:821
> Call Trace:
>  <TASK>
>  dvb_usbv2_generic_write+0x26/0x60
>  drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c:77
>  mxl111sf_ctrl_msg+0x160/0x2f0 drivers/media/usb/dvb-usb-v2/mxl111sf.c:73
>  mxl111sf_write_reg+0xa9/0x1b0 drivers/media/usb/dvb-usb-v2/mxl111sf.c:123
>  mxl111sf_i2c_start drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c:130
>  [inline]
>  mxl111sf_i2c_sw_xfer_msg drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c:-1
>  [inline]
>  mxl111sf_i2c_xfer+0x463/0x5060
>  drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c:813
>  __i2c_transfer+0x7bf/0x1fe0 drivers/i2c/i2c-core-base.c:-1
>  i2c_transfer+0x1cb/0x2d0 drivers/i2c/i2c-core-base.c:2350
>  i2cdev_ioctl_rdwr+0x460/0x740 drivers/i2c/i2c-dev.c:306
>  i2cdev_ioctl+0x6a5/0x880 drivers/i2c/i2c-dev.c:467
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> Additionally, state->fe_lock was initialized in mxl111sf_init() (called via
> d->props->init()), which runs after frontend attachment, leaving the mutex
> uninitialized during frontend registration. Although the reported I2C fault
> does not demonstrate a frontend lock race, fe_lock should also be
> initialized before frontend registration.
> 
> Fix this by setting state->d = dev and initializing state->fe_lock in
> mxl111sf_probe(), which runs before dvb_usbv2_init() registers the I2C
> adapter or attaches frontends. Furthermore, remove the redundant
> mutex_init(&state->fe_lock) from mxl111sf_init() and the redundant
> assignments of state->d in the frontend attach functions.
> 
> Fixes: 4c66c9205c07 ("[media] dvb-usb: add ATSC support for the Hauppauge WinTV-Aero-M")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+f9f5333782a854509322@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=f9f5333782a854509322
> Link: https://syzkaller.appspot.com/ai_job?id=c5284b5c-3f14-4e95-a4b7-6ee38f0d2e1f
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> To: "Michael Krufky" <mkrufky@linuxtv.org>
> To: "Michael Krufky" <mkrufky@kernellabs.com>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v3:
> - Replace specific crash report date reference in commit description with generic wording.
> 
> v2:
> - Clarified in commit description that the quoted x64/NOPTI trace is distinguished from the 2026-10-02 PTI/compat report
> - Noted in commit description that fe_lock is initialized before frontend registration, and that the I2C fault does not demonstrate a frontend lock race
> https://lore.kernel.org/all/0d33de80-3e10-403b-a843-04ac26a97f61@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/b8b6fc2d-1c9a-4046-bba5-c9ef864bfae3@mail.kernel.org/T/
> ---
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> index 6404eb74d..fc4010b6e 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> @@ -431,8 +431,6 @@ static int mxl111sf_lgdt3305_frontend_attach(struct dvb_usb_adapter *adap, u8 fe
>  
>  	pr_debug("%s()\n", __func__);
>  
> -	/* save a pointer to the dvb_usb_device in device state */
> -	state->d = d;
>  	adap_state->alt_mode = (dvb_usb_mxl111sf_isoc) ? 2 : 1;
>  	state->alt_mode = adap_state->alt_mode;
>  
> @@ -502,8 +500,6 @@ static int mxl111sf_lg2160_frontend_attach(struct dvb_usb_adapter *adap, u8 fe_i
>  
>  	pr_debug("%s()\n", __func__);
>  
> -	/* save a pointer to the dvb_usb_device in device state */
> -	state->d = d;
>  	adap_state->alt_mode = (dvb_usb_mxl111sf_isoc) ? 2 : 1;
>  	state->alt_mode = adap_state->alt_mode;
>  
> @@ -587,8 +583,6 @@ static int mxl111sf_lg2161_frontend_attach(struct dvb_usb_adapter *adap, u8 fe_i
>  
>  	pr_debug("%s()\n", __func__);
>  
> -	/* save a pointer to the dvb_usb_device in device state */
> -	state->d = d;
>  	adap_state->alt_mode = (dvb_usb_mxl111sf_isoc) ? 2 : 1;
>  	state->alt_mode = adap_state->alt_mode;
>  
> @@ -674,8 +668,6 @@ static int mxl111sf_lg2161_ep6_frontend_attach(struct dvb_usb_adapter *adap, u8
>  
>  	pr_debug("%s()\n", __func__);
>  
> -	/* save a pointer to the dvb_usb_device in device state */
> -	state->d = d;
>  	adap_state->alt_mode = (dvb_usb_mxl111sf_isoc) ? 2 : 1;
>  	state->alt_mode = adap_state->alt_mode;
>  
> @@ -749,8 +741,6 @@ static int mxl111sf_attach_demod(struct dvb_usb_adapter *adap, u8 fe_id)
>  
>  	pr_debug("%s()\n", __func__);
>  
> -	/* save a pointer to the dvb_usb_device in device state */
> -	state->d = d;
>  	adap_state->alt_mode = (dvb_usb_mxl111sf_isoc) ? 1 : 2;
>  	state->alt_mode = adap_state->alt_mode;
>  
> @@ -935,8 +925,6 @@ static int mxl111sf_init(struct dvb_usb_device *d)
>  	if (mxl_fail(ret))
>  		pr_err("failed to get chip info during probe");
>  
> -	mutex_init(&state->fe_lock);
> -
>  	if (state->chip_rev > MXL111SF_V6)
>  		mxl111sf_config_pin_mux_modes(state, PIN_MUX_TS_SPI_IN_MODE_1);
>  
> @@ -1068,7 +1056,9 @@ static int mxl111sf_probe(struct dvb_usb_device *dev)
>  {
>  	struct mxl111sf_state *state = d_to_priv(dev);
>  
> +	state->d = dev;
>  	mutex_init(&state->msg_lock);
> +	mutex_init(&state->fe_lock);
>  	return 0;
>  }
>  
> 
> 
> base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
> -- 
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
> 
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
