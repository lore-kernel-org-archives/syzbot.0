Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03229411FAC
	for <syzbot@lists.linux.dev>; Mon,  3 Aug 2026 15:15:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785770103; cv=none; b=njrNbxCMWFR2AMwzPvFwcyRNYOAscwWVRxHuVNkFDo8wAB56oDLNrWcHo3xpHugP1Ggeenuw+JzKTB6uExEMXkzlH0CB3bfk2cxwSNqwbg8Hk/PAJKkmkhi/FL0l+CpIFqMHhttT92yUSe0c5NtRufWFEW4OhRIc4mlFr5WmCNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785770103; c=relaxed/simple;
	bh=q5h9H3UJq5XoXR81iKDU0Fe2CgCdAu1qEA/1PRHciaQ=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=UocIYWqmVeGtOqVrTwsIuXXLMAkptRFA3PMHnzp4rMFnTTcQxUuX8YUU2K7KGHEFKLcMQMbJGV217HRc3O4wqLGVYu1GVL6LK+5ozrWQSD9FtGd1asPhN9PpnhIUkoOwpJXlAgZDqd+zjJE/HcDNHXwH3nsU46AzcxkaAqSp4w8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xri45bLY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xri45bLY"
Received: by smtp.kernel.org (Postfix)
	id 9FE381F00A3A; Mon,  3 Aug 2026 15:15:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0861A1F000E9;
	Mon,  3 Aug 2026 15:15:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785770101;
	bh=T5L1AhzXF+nHNam2GnZMxRlre24VRp+GOW6YPT97OWw=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=xri45bLYLWvn0lKfB/DhXCe5AhL3zBopx7PQQGi824yZJhii6a8QVs3dYc9FtgtIF
	 medeYxlNRJtlwtrz9Bd8rTGh8vadJy8I6c5PRSjXPp1wo8jenUIb0N/2u+yeGpSYCc
	 VUltQ2oultqfP34MaJVtI6/wEFHH4M9grWRyYyC0=
Date: Mon, 3 Aug 2026 17:14:45 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>,
	linux-usb@vger.kernel.org, Greg Kroah-Hartman <gregkh@suse.de>,
	kees@kernel.org, linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev
Subject: Re: [PATCH] usb: usbtest: fix NULL pointer dereference in
 usbtest_probe
Message-ID: <2026080322-obsessed-daringly-e6df@gregkh>
References: <2650cf0f-26f9-48b5-b198-e4cb67c59cf0@mail.kernel.org>
 <2026080336-covenant-limpness-55cc@gregkh>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2026080336-covenant-limpness-55cc@gregkh>

On Mon, Aug 03, 2026 at 05:13:00PM +0200, Greg Kroah-Hartman wrote:
> On Wed, Jul 29, 2026 at 09:19:54AM +0000, syzbot wrote:
> > From: Aleksandr Nogikh <nogikh@google.com>
> > 
> > The usbtest driver relies on the driver_info field of the usb_device_id
> > structure to hold a pointer to a struct usbtest_info, which contains
> > necessary configuration for the device. When a new device ID is dynamically
> > added via the sysfs new_id interface without specifying a reference device,
> > the driver_info field defaults to 0. When the USB core binds the device
> > using this dynamic ID, usbtest_probe() unconditionally casts the 0 to a
> > pointer, resulting in a NULL pointer dereference when attempting to access
> > the autoconf bitfield (at offset 0xa) of the struct usbtest_info.
> > 
> > This leads to the following crash:
> > 
> > Oops: general protection fault, probably for non-canonical address
> > 0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
> > KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> > RIP: 0010:usbtest_probe+0x522/0xcc0 drivers/usb/misc/usbtest.c:2822
> > Call Trace:
> >  <TASK>
> >  usb_probe_interface+0x653/0xc60 drivers/usb/core/driver.c:396
> >  call_driver_probe drivers/base/dd.c:-1 [inline]
> >  really_probe+0x254/0xae0 drivers/base/dd.c:706
> >  __driver_probe_device+0x1e8/0x360 drivers/base/dd.c:868
> >  driver_probe_device+0x4f/0x240 drivers/base/dd.c:898
> >  __device_attach_driver+0x270/0x410 drivers/base/dd.c:1026
> >  bus_for_each_drv+0x258/0x2f0 drivers/base/bus.c:500
> >  __device_attach+0x2c4/0x450 drivers/base/dd.c:1098
> >  device_initial_probe+0xa1/0xd0 drivers/base/dd.c:1153
> >  bus_probe_device+0x12a/0x220 drivers/base/bus.c:620
> >  device_add+0x7d7/0xb80 drivers/base/core.c:3772
> >  usb_set_configuration+0x1ad8/0x2180 drivers/usb/core/message.c:2268
> >  usb_generic_driver_probe+0x8d/0x150 drivers/usb/core/generic.c:250
> >  usb_probe_device+0x1c3/0x3b0 drivers/usb/core/driver.c:291
> > 
> > To fix this, validate that id->driver_info is not NULL before proceeding
> > with the probe. If it is NULL, gracefully return -ENODEV. The check is
> > placed before any memory allocation to avoid unnecessary work and simplify
> > error handling.
> > 
> > Fixes: 733260ff9c45 ("[PATCH] USB: add dynamic id functionality to USB core")

Not really, but I can see why the LLM thinks this.  It's "just how this
driver works" instead, right?

> > Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> > Reported-by: syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
> > Closes: https://syzkaller.appspot.com/bug?extid=7e1e5911f9eac50bedc7
> > Link: https://syzkaller.appspot.com/ai_job?id=9e476ca5-99d1-47d2-b9d1-f3b501897179
> > Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> > 
> > ---
> > diff --git a/drivers/usb/misc/usbtest.c b/drivers/usb/misc/usbtest.c
> > index 98071b25a..6410b3e26 100644
> > --- a/drivers/usb/misc/usbtest.c
> > +++ b/drivers/usb/misc/usbtest.c
> > @@ -2786,10 +2786,13 @@ usbtest_probe(struct usb_interface *intf, const struct usb_device_id *id)
> >  	}
> >  #endif
> >  
> > +	info = (struct usbtest_info *) id->driver_info;
> 
> Extra space there, right?  Didn't checkpatch catch that?
> 
> And this really isn't the proper solution, just don't allow dynamic
> binding for this driver.  That should resolve it, right?

If you don't want to do that, you need a BIG comment here as to what you
are trying to prevent, as a NULL check just looks like any other normal
check, while you are trying to prevent a specific use case from being
possible, and it WILL have user-visable affect.

thanks,

greg k-h
