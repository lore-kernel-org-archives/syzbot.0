Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54F0B18CC13;
	Thu,  6 Aug 2026 14:32:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786026771; cv=none; b=DvTJaf2JrvRb6BA+21OAMbgPHWigyQ1SdSI6yNwvs1BNwN7R16E6FnWG2m5Qsqp7M1YxV3t8DwobM4ACBnlwf1IGo7OgS5m51FnBIRmAYDqkeojJMEz3PfiNYpZBF3qFgcQC36qqAXTfZPJuNdM8U8R5Um5DNk+M7/5Tan/kCbc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786026771; c=relaxed/simple;
	bh=3LEh92QhKd6DSDU8+jLmJ3tRMLCVFY78y0TexOTf5UU=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=BHPO//CNgb3uI87ni8pQO1XQYSBPo4UfuR73uUatW9oab1X/W0NYVcBLuzrHOV0EE9i+J18U9A7YWV4kBaWD5Y0ylhfgI5HspLqDCb7sVw3YaNeP2/z1eEWiuAdDrHdmlEHguf9rdrnAwGwYBzs1XeTEsy2JRfFdskebLf+0FAc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hFaMbW1c; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hFaMbW1c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD801F000E9;
	Thu,  6 Aug 2026 14:32:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786026767;
	bh=nsqYFD8+yVHYOOcR88KBdF2WU2FEIrloHtOUL17pu5Q=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=hFaMbW1cWoWBZjvs2pi5+68YRdROyxOn4CG93UL5oQtZR/XLoSaPlIUsyO6IjJ3RS
	 WZVsEgKpkFv4xQoJAzxL6DG8PG0p3dCrKTOpsrhsqReX4uxlikv2d9VRljogPWZ2eT
	 AYAuaD5CkWcDHswC61hXfbDO3RS7cRRNsbYuHdbQ=
Date: Thu, 6 Aug 2026 16:32:29 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kees Cook <kees@kernel.org>, syzbot@lists.linux.dev,
	syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] usb: usbtest: disable dynamic ID support
Message-ID: <2026080617-gave-widely-c5dc@gregkh>
References: <2026080322-obsessed-daringly-e6df@gregkh>
 <20260806142511.2337081-1-nogikh@google.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20260806142511.2337081-1-nogikh@google.com>

On Thu, Aug 06, 2026 at 02:25:11PM +0000, Aleksandr Nogikh wrote:
> The usbtest driver relies on the driver_info field of struct usb_device_id
> to point to a valid struct usbtest_info descriptor. This structure contains
> essential test configurations, such as endpoint addresses and test modes,
> which are required during probe.
> 
> When a user dynamically adds a new device ID via the sysfs new_id
> interface without specifying a reference device, the USB core initializes
> driver_info to 0 (NULL). When a matching device is subsequently probed,
> usbtest_probe() unconditionally casts driver_info to a struct usbtest_info
> pointer and dereferences it, leading to a NULL pointer dereference crash:
> 
>   Oops: general protection fault, probably for non-canonical address
>   0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
>   KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
>   RIP: 0010:usbtest_probe+0x3b9/0x1280 drivers/usb/misc/usbtest.c:2822
> 
> Because usbtest strictly requires pre-defined usbtest_info descriptors
> to function, dynamic ID binding via sysfs is fundamentally unsupported
> for this driver.
> 
> Fix this by setting .no_dynamic_id = 1 on usbtest_driver. This instructs
> the USB core to skip creating the new_id and remove_id sysfs interfaces
> for usbtest, preventing invalid dynamic ID entries from being created.
> 
> Reported-by: syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=7e1e5911f9eac50bedc7
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

Shouldn't this also get a cc: stable?

thanks,

greg k-h
