Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91D224963A9
	for <syzbot@lists.linux.dev>; Wed, 29 Jul 2026 13:54:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785333300; cv=pass; b=ST8DF/EzIALQPFyx4tBobtiXuT06gl7Q9vVLQT298gfKEt6GiC1V5DSUmwui4N4bg4kxP/QnNG7HFjQ1WDeOnG2MQtk2HvBs8mfOjYSqwi8rQIFpzxQzT89U3iEwIhardaVka3H/RtauJvWL8QwM4Y0eUOlOmy5prLp5+EsGKlk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785333300; c=relaxed/simple;
	bh=Ha1mb5kFxDm9cD7pXy0bfXPQoZoNfTAyfFWhvydeIfQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=WxQQltHzR1Su1EkVFUeTOUKD90afqKKCcDHaFox5x3OOBjkABHhWV77rIFFFyZbaT5RC4C/2fDVYMlH9wkD0x7aw3+M8XVXIw9IKpZF1jmJXe2vC45cpsKzws1IMgOXpU3AkHWjWUaczR6J1kL8fW/zc7dqHW8xN64Fffwc5J8U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b=FDA9utqy; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.b="FDA9utqy"
Received: by smtp.kernel.org (Postfix)
	id 232A71F00A3D; Wed, 29 Jul 2026 13:54:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.222.177
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1785333295;
	b=1zH1a2cbhGgsh9JArGG4FbT/3P1p0qrAtYv7wby5G2Sf6+DWF4RWtiQfq/9/8rolBKor
	 9y4US5lYyGO5A7cuXk9o4/Fe13/9uQ+CfPENqKWTVVob05MTE+yY3km0r5uEubLiSM1iE
	 kH21p5OU6ZFKrAsJMy50RircamFy4ap4BLVA1xJDC21RUt+7s5Vd57falsGYYo0jDEA1z
	 2mvtfL9IBeCdHIw33CYYWe/pp69Je+1QULXlJkQ6C32tRwSOfn5MDArLKRm7s2oTa/N9i
	 8imeVvLTgngEItKmQAOd+ASPTTb6aP7dDPKPNslhgUz64zlDb4w9hXLHwwMIFTEQR4w==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1785333295;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Date:From:To:Cc:
	 Subject:Message-ID:References:MIME-Version:Content-Type:
	 Content-Disposition:In-Reply-To;
	bh=5LvZ0chz+TPJ0xzzKfMEgSAWIzM2O+ULwcgXsdKslGY=;
	b=h+ip2IybCRopylHh4ScXmce3McVnySwfjz6gRakaVpkf+fNnASUSirE23jJFqKXB3M1w
	 QLWIG0fCmSv9ZF4hKurf7ODyh7Rc77X75WW5bkSnyTJtitbaE8w3DJOt3EdjwOWsKsksg
	 1U41HFvg8mJO1teQpGOv1ihlF9t4UPQuZpkeyJ695xlOKEjy8le9C22ye3Fw1xA4JUI7h
	 lCS5NY/O7Nv1SczoBV6l2ZEdQKs6ANsW3joQNU4nQniql7oJZ8PjGymAZ6ByjGvTBdNX0
	 5CJmt1EBellxS1tQXb0vnLrO66NrHbJqoRmhX2rafwVap+p/s+3840Dn2PnD2uDzSUw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.a=rsa-sha256 header.s=google header.b=FDA9utqy;
	dmarc=fail header.from=rowland.harvard.edu;
	spf=fail smtp.mailfrom=g.harvard.edu;
	arc=none smtp.remote-ip=209.85.222.177
Received: from mail-qk1-f177.google.com (mail-qk1-f177.google.com [209.85.222.177])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 7142C1F00A3A
	for <syzbot@kernel.org>; Wed, 29 Jul 2026 13:54:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=rowland.harvard.edu header.i=@rowland.harvard.edu header.a=rsa-sha256 header.s=google header.b=FDA9utqy
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 7142C1F00A3A
Authentication-Results: smtp.kernel.org; dmarc=fail (p=none dis=none) header.from=rowland.harvard.edu
Authentication-Results: smtp.kernel.org; spf=fail smtp.mailfrom=g.harvard.edu
Received: by mail-qk1-f177.google.com with SMTP id af79cd13be357-92e622cc874so55004985a.0
        for <syzbot@kernel.org>; Wed, 29 Jul 2026 06:54:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=rowland.harvard.edu; s=google; t=1785333293; x=1785938093; darn=kernel.org;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=5LvZ0chz+TPJ0xzzKfMEgSAWIzM2O+ULwcgXsdKslGY=;
        b=FDA9utqyBruXGVpCpW1p7dMxP8NCOyJAnkUl3kTq8nCS5CrC0rQ6ityJff4aG1l9Sq
         e94DO2EIVvGhbN9gLF+PbyMgL0JgAyAKR8ejUsUBOEXOe+eHNAWuo/kXu1hQkfUGuyrN
         pXZ5aiLG63899iMMB+X/x9K7ysFN0P43wuDMG+LHqnMP7ndASPQ6l9qNjccIqc0Ew06X
         8pNM47wYvdi3hA7bd+jownwZXAGDB3cCZoAvCQYGpZHCVyLHC5FcTi6a2bjzobFdzz/t
         ESPDka1V3AbhDb3mONIvizasdvruSBuD5Zow55xnwv7XmNZKqjz6ow//hiN8wXAS69Ev
         XzWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785333293; x=1785938093;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=5LvZ0chz+TPJ0xzzKfMEgSAWIzM2O+ULwcgXsdKslGY=;
        b=KpFRzEdDFGJbOoqIwqzlZ6l0seIV8hYzZzUl1/sWr/08TgGJbqaYyqhF36/WNbeh+E
         iKJ2BXGo+bpDND/0Vhdxf3BwkDRgDE70Fvcl7s1JIxQDr3/KExzWoKPiTVPLNMcNNBV1
         NTI+AHmXjaO+6n8q+NBEVMptOK8mZpImcI0kofLnzf7bIB53AhX0yjDs9rNn4P59N3/1
         bjgFuI6GTIUFEtAFzyn7hTJLXhN+FmmEM2BJKHe45Pl3ylocaC3uHQQtmwX53fjvGt0p
         xARN1611h5if9Nkq5Rdmuta4zjMi+Afx+/s7pWzs4qdpltsPVXq7TT6KA26gass4CqB5
         biUg==
X-Gm-Message-State: AOJu0YzWObNiFmftpzI52ZmI6xLDDUQwI0gkY2cQ/4CmnsPRXgI5DxI0
	qFpesqWeOEQwx5dNAlmgiB7T7oWMHqCL+sIbx4/T5hB9RcDieCORymp+NhwIHM5C8sizkYywb0f
	JObwslA==
X-Gm-Gg: AR+sD11Z/5I/e1H3Y5sZkLs31A+gucPY7ZhyWAB1bNdFbhJY7N/58dTHTYCMDWAOWAh
	fP9b+LJ/WuDoDYaeTcSEWtahSwbi+g89qukutqaQKZGSbt2LsAe2SjloWbQJgj9/AFp4TgbaTSz
	na/ki8c2GaA37Yldg1ARL/vKN4nf4doduXmyRDdkNaiOy6IlKokIlny2G6doSepM8b5jea1RVLu
	e2iDu76UUDY18GI9dRQE2JJK0ErpZ1cSVuco/1s/LRBOA1/VSycqk0JO8/BGKvi4Z1cE/rguo2H
	4YbezNHrTxvmYO4M1VGk4AvR6ck87YxmDM1A5ZZdj9Aoqp6vVuPa3ZzoiWG5W5dsKpM3PAh32bl
	aHpkOwnWnp0bL3L07/U4GwKgM9MwzecSnGjiPp7ONCI+Z+eIXIzITU6uiRMJhSmkC1KRwFnh0ef
	meHDcraOzcBYKsflRynWjIOjetoilHNu9QRCMJcFB5V+t4m4ZPlC6rXsBoGULG4jq6R3KjTez1N
	1yeeMw=
X-Received: by 2002:a05:620a:284f:b0:930:9585:e0b2 with SMTP id af79cd13be357-93302621312mr623402585a.51.1785333293093;
        Wed, 29 Jul 2026 06:54:53 -0700 (PDT)
Received: from rowland.harvard.edu ([140.247.181.15])
        by smtp.gmail.com with ESMTPSA id af79cd13be357-933e7361dc2sm174271185a.43.2026.07.29.06.54.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 29 Jul 2026 06:54:52 -0700 (PDT)
Date: Wed, 29 Jul 2026 09:54:50 -0400
From: Alan Stern <stern@rowland.harvard.edu>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev, wangjinchao600@gmail.com
Subject: Re: [PATCH] usb: gadget: dummy_hcd: prevent unbind via sysfs
Message-ID: <fda1c515-8075-4da4-b60e-2ad1c779820b@rowland.harvard.edu>
References: <18ec3122-7566-49e5-9964-1028857405b1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <18ec3122-7566-49e5-9964-1028857405b1@mail.kernel.org>

On Wed, Jul 29, 2026 at 12:25:27PM +0000, syzbot wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> The dummy_hcd (Host Controller) and dummy_udc (Device Controller) are
> implemented as two separate platform drivers that share the same underlying
> state (struct dummy). They are designed to be created and destroyed
> together during the module's init and exit phases.
> 
> If userspace forces the dummy_hcd driver to unbind from the device via
> sysfs, dummy_hcd_remove() cleans up the host controllers and sets the
> pointers to NULL (dum->hs_hcd = NULL). However, the dummy_udc driver is
> still bound to its device, meaning the USB gadget is still registered with
> the udc-core subsystem.
> 
> If a new gadget driver is subsequently registered, it binds to the
> still-registered dummy_udc gadget, invoking the dummy_udc_start() callback.
> This callback attempts to retrieve the HCD state using
> gadget_to_dummy_hcd(), which returns NULL because of the unbind. This
> results in a null-pointer dereference:
> 
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> ...
> RIP: 0010:dummy_udc_start+0xd0/0x1f0
> drivers/usb/gadget/udc/dummy_hcd.c:1022
> ...
> Call Trace:
>  <TASK>
>  usb_gadget_udc_start_locked drivers/usb/gadget/udc/core.c:1237 [inline]
>  gadget_bind_driver+0x3a8/0x9e0 drivers/usb/gadget/udc/core.c:1667
>  call_driver_probe drivers/base/dd.c:-1 [inline]
>  really_probe+0x254/0xae0 drivers/base/dd.c:706
>  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
>  driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
>  __driver_attach+0x339/0x600 drivers/base/dd.c:1292
>  bus_for_each_dev+0x23b/0x2c0 drivers/base/bus.c:383
>  bus_add_driver+0x345/0x670 drivers/base/bus.c:763
>  driver_register+0x23a/0x320 drivers/base/driver.c:174
>  usb_gadget_register_driver_owner+0xf9/0x270
>  drivers/usb/gadget/udc/core.c:1752
>  raw_ioctl_run drivers/usb/gadget/legacy/raw_gadget.c:596 [inline]
>  raw_ioctl+0x1541/0x41c0 drivers/usb/gadget/legacy/raw_gadget.c:1307
> 
> Adding NULL checks to the UDC callbacks is not a robust solution because
> there is no synchronization between dummy_hcd_remove() and the UDC
> callbacks, which would result in a use-after-free race condition if the HCD
> were unbound concurrently.
> 
> Fix this by setting .suppress_bind_attrs = true in both driver definitions.
> This prevents userspace from unbinding these drivers dynamically, ensuring
> their lifecycles remain strictly synchronized with the module's load/unload
> process.
> 
> Fixes: d9b762510c18 ("[PATCH] USB dummy_hcd: Use separate pdevs for HC and UDC")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+d270af829aca04e783fc@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d270af829aca04e783fc
> Link: https://syzkaller.appspot.com/ai_job?id=7a763ada-c07c-458f-9fea-f7e913dc1f2f
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> 
> ---

In theory the driver could be rewritten to allow independent unbinding 
and rebinding of the HCD and UDC.  But that would be a much more 
intrusive change, whereas as this is a small and reasonable fix for a 
real problem.

Acked-by: Alan Stern <stern@rowland.harvard.edu>

Alan Stern

> diff --git a/drivers/usb/gadget/udc/dummy_hcd.c b/drivers/usb/gadget/udc/dummy_hcd.c
> index c0e40fa6d..415096835 100644
> --- a/drivers/usb/gadget/udc/dummy_hcd.c
> +++ b/drivers/usb/gadget/udc/dummy_hcd.c
> @@ -1180,6 +1180,7 @@ static struct platform_driver dummy_udc_driver = {
>  	.resume		= dummy_udc_resume,
>  	.driver		= {
>  		.name	= gadget_name,
> +		.suppress_bind_attrs = true,
>  	},
>  };
>  
> @@ -2802,6 +2803,7 @@ static struct platform_driver dummy_hcd_driver = {
>  	.resume		= dummy_hcd_resume,
>  	.driver		= {
>  		.name	= driver_name,
> +		.suppress_bind_attrs = true,
>  	},
>  };
>  
> 
> 
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
> -- 
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
