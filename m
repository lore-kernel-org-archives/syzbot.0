Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 716A52F7F12;
	Thu,  6 Aug 2026 14:43:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786027397; cv=none; b=WlaEIASkWjp8ZovI4V9B6Chd6aMpMNi6/3z2UsfbRtD/oG3ZRF0jyUGVVa7M5184oq7At1Gn+Ekq1gQ7CuWT+f129OR6K3urooOQaehL4f/cld8wa0vBqrBJHlYsKFqd4vR2RTlacpWKjVb+w0NckWetet31Q8r/sjbGKiYKNUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786027397; c=relaxed/simple;
	bh=VgS1WDQXxUeg/akVFfFefVq6TPQGGSVvc+F5LThYrZI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rP4Y7ituTkfY/F/xF6/Cu1/Nb3ynPNnVHgw0xly23lCL147oB0o1Wa0IG9YH0gxjxaDl0XbPLUMKYQbSVYULDwGbCtcNEzeK3yct1AEDWoKYXqw3bRH+lCxK6DDW6ZovpKDqrBCkWHMimMzBd7uaWLLaIeqH3pJO0VPfTsWOZ+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pB6M1nJY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pB6M1nJY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7434F1F00A3D;
	Thu,  6 Aug 2026 14:43:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786027396;
	bh=UJ3jAi2sBzyd7dfaSmaHrafxl8rcwZjgKJV+w1CG/N4=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=pB6M1nJYS0T7GRb288Pz6G2Uk5mi5J6ftLKibqWQ5LCgZviGumjznArOO1gFmJl7n
	 /0McSXYS6P49t8jBhkswXlcefgoQzeyHq9JGALSBWQFKVL5+OJuYwNDCsQz//ASOgw
	 nohwJyenGLExyqHuw4fJrXChMVwJs+BpPKExfKsE=
Date: Thu, 6 Aug 2026 16:42:58 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Aleksandr Nogikh <nogikh@google.com>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
	Kees Cook <kees@kernel.org>, syzbot@lists.linux.dev,
	syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
Subject: Re: [PATCH v2] usb: usbtest: disable dynamic ID support
Message-ID: <2026080612-whomever-abide-ff93@gregkh>
References: <2026080322-obsessed-daringly-e6df@gregkh>
 <20260806142511.2337081-1-nogikh@google.com>
 <2026080617-gave-widely-c5dc@gregkh>
 <CANp29Y7R1OzK3mo_i6uBxLV6zCgFUVxMgrfozAT-QNivp+gHMg@mail.gmail.com>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CANp29Y7R1OzK3mo_i6uBxLV6zCgFUVxMgrfozAT-QNivp+gHMg@mail.gmail.com>

On Thu, Aug 06, 2026 at 04:35:12PM +0200, Aleksandr Nogikh wrote:
> On Thu, Aug 6, 2026 at 4:32 PM Greg Kroah-Hartman
> <gregkh@linuxfoundation.org> wrote:
> >
> > On Thu, Aug 06, 2026 at 02:25:11PM +0000, Aleksandr Nogikh wrote:
> > > The usbtest driver relies on the driver_info field of struct usb_device_id
> > > to point to a valid struct usbtest_info descriptor. This structure contains
> > > essential test configurations, such as endpoint addresses and test modes,
> > > which are required during probe.
> > >
> > > When a user dynamically adds a new device ID via the sysfs new_id
> > > interface without specifying a reference device, the USB core initializes
> > > driver_info to 0 (NULL). When a matching device is subsequently probed,
> > > usbtest_probe() unconditionally casts driver_info to a struct usbtest_info
> > > pointer and dereferences it, leading to a NULL pointer dereference crash:
> > >
> > >   Oops: general protection fault, probably for non-canonical address
> > >   0xdffffc0000000001: 0000 [#1] SMP KASAN NOPTI
> > >   KASAN: null-ptr-deref in range [0x0000000000000008-0x000000000000000f]
> > >   RIP: 0010:usbtest_probe+0x3b9/0x1280 drivers/usb/misc/usbtest.c:2822
> > >
> > > Because usbtest strictly requires pre-defined usbtest_info descriptors
> > > to function, dynamic ID binding via sysfs is fundamentally unsupported
> > > for this driver.
> > >
> > > Fix this by setting .no_dynamic_id = 1 on usbtest_driver. This instructs
> > > the USB core to skip creating the new_id and remove_id sysfs interfaces
> > > for usbtest, preventing invalid dynamic ID entries from being created.
> > >
> > > Reported-by: syzbot+7e1e5911f9eac50bedc7@syzkaller.appspotmail.com
> > > Closes: https://syzkaller.appspot.com/bug?extid=7e1e5911f9eac50bedc7
> > > Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> >
> > Shouldn't this also get a cc: stable?
> 
> Is there (in general) value in cc: stable without a Fixes: tag?

Very much so.  Don't you want this in stable trees so that your syzbot
runs on the older kernels don't fail horribly?  If not, then hey,
waiting for newer releases is fine with me, but I got the impression
this was a good thing to fix :)

thanks,

greg k-h
