Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795164015;
	b=SYe4MKIQQc+rnYfxiRyCuc2IL0hI+qT4ldT4co2xFTNU3261uohtGm90ngUCC1Wy+hK7
	 S5ip6QU7BD025IRiCY98oGXbFZjBackSnM0zg8Rf+limf2D9e39rr3MaImuvS7vlcZPwT
	 flTLanSELZx/SkPG54A4FqBrtyeuD4RFral4AiBGTOIrqhbcQ09/S8pnhSA8JZebs/G8G
	 c9EryWoHi0OTGmVtYUdrI+0/k4KxsZYNzheDtjuoAcTqL5RSuVmBGxfnYxNbG0mQySCz4
	 agiFqLq+D6UqsjYI9ApuJYWKeFl7TSow4tpYngJEP2xZxvy+PfIYo4Vo+0+jcjYZkig==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795164015;
	h=Received:DKIM-Signature:Date:From:To:Cc:Subject:Message-ID:
	 References:MIME-Version:Content-Type:Content-Disposition:In-Reply-To;
	bh=eW1JNjFM3eTKQOg6DQphrxNHZt2sHfAlDWTCDXa7uhE=;
	b=w6jPDDxBiPSwRJNnriN00HhcxxphEEJXZHeoLFZWDEY9wFOWIB73MnHtbCOVle33ynYf
	 yCSgyFPS4fsABSF6G0Aa09xl+/0+x7qZOVyZpjhJv/iGMK+GbNjwclOdMvOpME0hm+VkO
	 /bQZVoWC3bL5ncY2MO4kCe2cRwKUxFlJLCyCqaGsNY36wgthBtkqxwsXlSz4Yc34Pn8v2
	 /Z/69pmC+roryQCAmVm8TpeLWkiFzpvt5sl+vKb+jVKkemtBIkVS16G0Awr9ceEVn5A4Y
	 dFbIIGikdGKNwP7bzYEsfYcT0libK1pF8Tsr7KcRloswy2QzJQDtd6qVYbJaqjPinkQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5rWiymU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B71F606A326;
	Fri, 20 Nov 2026 08:40:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=L5rWiymU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2D7C01F000C4;
	Fri, 20 Nov 2026 08:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795164014;
	bh=eW1JNjFM3eTKQOg6DQphrxNHZt2sHfAlDWTCDXa7uhE=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To;
	b=L5rWiymUu26RBF7b32HRuTXeEwhNwn6g12gK4ouHtDeb6SXUkt1rcDW0I3HgTo/1Z
	 0W+sEUSkeVqJcOID3xe/HzMbKGPw6vzhAGfZ/ZLVFw4Os0dmWTaNsVxMNbS/k9ZyCU
	 m+y7aVn9b9WPfd+HKoyTbWEmrjGdHmegPN8p3g5o=
Date: Fri, 20 Nov 2026 09:40:11 +0100
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>,
	linux-usb@vger.kernel.org,
	Michael Grzeschik <m.grzeschik@pengutronix.de>, Frank.Li@nxp.com,
	hhhuuu@google.com, kees@kernel.org, linux-kernel@vger.kernel.org,
	meatuni001@gmail.com, panjunzhong@linux.spacemit.com,
	syzbot@lists.linux.dev, xu.yang_2@nxp.com
Subject: Re: [PATCH] usb: gadget: uvc: check endpoint enabled state in
 uvcg_video_enable()
Message-ID: <2026112056-smite-glowing-bed5@gregkh>
References: <8fff0312-bd04-44e4-8df3-b60d3bc849bf@mail.kernel.org>
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
In-Reply-To: <8fff0312-bd04-44e4-8df3-b60d3bc849bf@mail.kernel.org>

On Fri, Aug 14, 2026 at 12:00:44PM +0000, syzbot wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> A NULL pointer dereference can occur in uvc_video_prep_requests() if
> userspace issues a VIDIOC_STREAMON ioctl before the USB host has fully
> configured the streaming endpoint.
> 
> When userspace calls VIDIOC_STREAMON, the driver handles it in
> uvc_v4l2_streamon(), which in turn calls uvcg_video_enable(). Currently,
> uvcg_video_enable() only checks if the endpoint pointer is allocated
> (video->ep == NULL), but it fails to check if the endpoint is actually
> enabled (video->ep->enabled).
> 
> The endpoint descriptor (video->ep->desc) is only assigned when the USB
> host explicitly selects the streaming alternate setting via a SET_INTERFACE
> control request. If userspace prematurely calls VIDIOC_STREAMON before the
> host has selected the streaming alternate setting, video->ep->desc will
> still be NULL.
> 
> Because uvcg_video_enable() does not verify the endpoint's enabled state,
> it proceeds to call uvc_video_alloc_requests() and then
> uvc_video_prep_requests(). Inside uvc_video_prep_requests(), the code
> unconditionally dereferences video->ep->desc, resulting in a KASAN
> null-ptr-deref / general protection fault:
> 
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000000: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000000-0x0000000000000007]
> RIP: 0010:usb_endpoint_xfer_isoc include/uapi/linux/usb/ch9.h:571 [inline]
> RIP: 0010:uvc_video_prep_requests
> drivers/usb/gadget/function/uvc_video.c:508 [inline]
> RIP: 0010:uvc_video_alloc_requests
> drivers/usb/gadget/function/uvc_video.c:559 [inline]
> RIP: 0010:uvcg_video_enable+0x142/0xe70
> drivers/usb/gadget/function/uvc_video.c:784
> Call Trace:
>  <TASK>
>  uvc_v4l2_streamon+0x7e/0x110 drivers/usb/gadget/function/uvc_v4l2.c:531
>  __video_do_ioctl+0x8af/0xc70 drivers/media/v4l2-core/v4l2-ioctl.c:3133
>  video_usercopy+0x860/0x1430 drivers/media/v4l2-core/v4l2-ioctl.c:3475
>  v4l2_ioctl+0x18d/0x1e0 drivers/media/v4l2-core/v4l2-dev.c:366
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583

Please don't wrap oops messages.

> To fix this, update uvcg_video_enable() to also verify that the endpoint is
> enabled (!video->ep->enabled). This ensures that if userspace prematurely
> calls VIDIOC_STREAMON, the driver will safely reject the request with
> -ENODEV instead of crashing the kernel.
> 
> Fixes: 48dbe731171e ("usb: gadget: uvc: set req_size and n_requests based on the frame interval")
> Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+44835f0858f11e3e923c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=44835f0858f11e3e923c
> Link: https://syzkaller.appspot.com/ai_job?id=6bcd0cc3-0532-4cbc-81bd-e487719ff9a3
> Signed-off-by: Aleksandr Nogikh <nogikh@google.com>
> 
> ---
> diff --git a/drivers/usb/gadget/function/uvc_v4l2.c b/drivers/usb/gadget/function/uvc_v4l2.c
> index dfa0521a2..da857c2c5 100644
> --- a/drivers/usb/gadget/function/uvc_v4l2.c
> +++ b/drivers/usb/gadget/function/uvc_v4l2.c
> @@ -527,6 +527,12 @@ uvc_v4l2_streamon(struct file *file, void *fh, enum v4l2_buf_type type)
>  	if (type != video->queue.queue.type)
>  		return -EINVAL;
>  
> +	if (uvc->state == UVC_STATE_STREAMING)
> +		return 0;
> +
> +	if (uvc->state != UVC_STATE_CONNECTED)
> +		return -ENODEV;

What prevents the state from changing right after you check it?

> +
>  	/* Enable UVC video. */
>  	ret = uvcg_video_enable(video);
>  	if (ret < 0)
> diff --git a/drivers/usb/gadget/function/uvc_video.c b/drivers/usb/gadget/function/uvc_video.c
> index 2f9700b3f..d4aeedacc 100644
> --- a/drivers/usb/gadget/function/uvc_video.c
> +++ b/drivers/usb/gadget/function/uvc_video.c
> @@ -764,7 +764,7 @@ int uvcg_video_enable(struct uvc_video *video)
>  {
>  	int ret;
>  
> -	if (video->ep == NULL) {
> +	if (video->ep == NULL || !video->ep->enabled) {
>  		uvcg_info(&video->uvc->func,
>  			  "Video enable failed, device is uninitialized.\n");

So if it's already enabled, you return an error saying it is
uninitialized?  Are you sure that is correct?

thanks,

greg k-h
