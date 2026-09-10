Received: from mail-ed1-f47.google.com (mail-ed1-f47.google.com [209.85.208.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28D874AA572
	for <syzbot@lists.linux.dev>; Thu, 10 Sep 2026 15:51:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789055483; cv=none; b=PJOgypeqzBPFi1HN3PmceJM4XP3aNNOJ9C+aW8R6MO4w9KariBT34qtO0YwjnRaBGfkzs3CG7YID6sWI+x5vs2V23VEoXG8yjYGjXshvPMH+yNTXdymoMQTfLgv3T5PeMNg2aXqOhzjt8+9WmFbMbIZS2RThKRZ3KBOf9nYbVmQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789055483; c=relaxed/simple;
	bh=QO/oHoGdgNPQ5CuoUcRwT+X+DOfYrdmS3U7MgfDFeh8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=C6ACwprWpRHPhLPcYUoWn87sojKIZePCdppW8bol+s8y9oCLBkeH2GLGfLc04dGX3+j4GvBXb6iutTbzCGUxtWSKGuhPEEk8YXlAQPaNyDGnXJpwMWwFGA/XnmvA8ZuXjHIeuv94TgFjDo8grXIgH9nMXKkNhdDCMVd2SV6VwpY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=jOArkeC/; arc=none smtp.client-ip=209.85.208.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="jOArkeC/"
Received: by mail-ed1-f47.google.com with SMTP id 4fb4d7f45d1cf-6a9ac6aa620so650256a12.1
        for <syzbot@lists.linux.dev>; Thu, 10 Sep 2026 08:51:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789055479; x=1789660279; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pzc6Zwjn7FD0DvnIlS28+xTpLsZj+QqwkRSn51tFBX0=;
        b=jOArkeC/kd16pIEs5aDy7Y7j+JAYZHNohrEbgyoRYgjIGOtA4AmOiaRk/Okp/onWFS
         fWM12qmcQeu/GRlLCfeJCJ43owgwnusEKGXm0gwbEfDKG8IQe/cs02iJkZMzmsVED48o
         J68yxY04zqWIBavdgzGTMTm3+WHFRojGPtqpatwrjuLm6sf5R/1v5vaQj5TPNajRyVFl
         KX268yP+7/05SSOsAFDAhjQvyX7KNYSPLf/TBHeOKmuuCo4m0sjgkGOl4fO2hDemNwfT
         hT1LOk70CZOIK6AexVmoUogUvI77vrPSuzPrUZmuHdwUq9O4VgV6+3K0VVR7eHDdtxJH
         Udww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789055479; x=1789660279;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pzc6Zwjn7FD0DvnIlS28+xTpLsZj+QqwkRSn51tFBX0=;
        b=rqcDFGgDZaHtiWkNgVyWawqgLcwKetinw1LwcbBcMdb/z9zIUHXXD4jCd2ANgI/HBD
         EGGBz6ayPmdVTM3ShkXgprGbi+HnZgcw+UdaHmPXJ8x0+W7+kU3x1CQ6AToI4GM6haYG
         crTF5gLaUzIW3MvEjR8IH+zZD8+YKjfpr7rbZLaV9CReFv+2esAKfSJpnjABXIVh+jiP
         H5l+BQjRD5fGNUHSF6AVkMnjLQ3JrcZO2zU6cJCxZEoGOLw73BXTREdzZ+B+q2ZLezty
         VYIvjJ6ZIs55SlHN+4HjK3YWOtf4GZ0Q/ZjeG/jjkKdVv/9DYn13cAGwsgLVOXp5vwE5
         jZGQ==
X-Gm-Message-State: AFuF++kG1tYNzx7xFtcLgnvKa+jExaU3TwYqFmY1z6fTZLI/VQ9egDNX
	DQIJHkS4s56S7f78jmCVHLkSWuKMDKbrKrst7cWjYbf24fDQYj5tCDdH
X-Gm-Gg: AYBFou2vN6051sfUJZI5SIN7nyz4mfa7KYitaf72rWZb4Rbl0Cwf2+tP7Ynx0hjj4Yu
	jIQSrIKRGdxYODwXGu9w5svGbChGY0sf++pTkWCYgiqmwT+jfkllViJpTm+j92rpVU0HHgT2Mf+
	NnVCgq4riPAMwyovJbYYQF2aClaNTIE5HQCgXtB554sQYXZxRLXSuA0uuFafYAG4vASDm8pwZBV
	4d+bFbGYYmQcPC763cATraQwNb0NjDN9vvzRgwfbDqtW5nBmPZ4zgw5b91vEy9fSP7RWlYrpTGy
	62CQKQAY3Lc9BMxAlLT9onP/wVdzee11qYCinnOmRQTemrwlEy13Ss76G59zZQWEhdJhG1GanJ1
	10vadzdql6z3N2p+YCg1Ccy4b4VkwDvJT4B5F8l80FSDuCaELTcnj1w8aofAckHoLcHuM3xtdFD
	PLgGrEdQt3gTeNvLK5dvAKWwkF/oQYXEAiV9f3i+bZVnR9DPkKF9ZKgBVenale62zfwNDnoEqkc
	B4e7jIgQfDQGnm0Rpnb/L+jL1gx/FwFmoNTORN5r0PMD4xQsnE5+pak1TTVRwzOf4y/M/dqdZlF
	Xdql4dqp1/ptCfkcQuTa9rChG5tjV6QZku4TYEZ99wazpE82XSci7UO47S64zPP+AgYMbTSIu0Q
	GbhD6OFY7CGp5LomcfjEsPKo+oSpToDyjGRAeqdVl8ko8EbN57NRtWVc=
X-Received: by 2002:a17:907:3e0f:b0:c25:5159:6a25 with SMTP id a640c23a62f3a-c2945db2ce7mr257879266b.6.1789055478695;
        Thu, 10 Sep 2026 08:51:18 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c293b6246c4sm242180666b.20.2026.09.10.08.51.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 08:51:18 -0700 (PDT)
Message-ID: <a7394300-db99-463b-9ac2-8a4448856cde@gmail.com>
Date: Thu, 10 Sep 2026 17:51:16 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] usb: gadget: u_serial: pin ports while TTYs are
 installed
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <5dc8c18b-cfac-4e42-a158-b5e92bab89ca@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <5dc8c18b-cfac-4e42-a158-b5e92bab89ca@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Keep the lifetime fix, installed-object identity, failed-open 
accounting, minor reservation, and unregister-before-owner-put ordering 
unchanged. Apply only the following clarity and presentation corrections.

Update the local comment above `gs_open()` to distinguish the two 
TTY-to-port relationships. `port->port.tty` exists from the first 
successful open until final close, while `tty->driver_data` is assigned 
during `gs_install()` and remains valid through `gs_cleanup()`. Do not 
state generally that the TTY-to-port link is broken by close.

Make `reserved` the authoritative allocation-state predicate in 
`gs_port_alloc()`. The valid states are free when both fields are clear, 
published when both are set, and retiring when only `reserved` remains 
set. Check the invalid `port && !reserved` state explicitly with 
`WARN_ON_ONCE()` and treat it as busy, then use `reserved` to reject 
both published and retiring slots. Do not permit an inconsistent 
non-NULL port to be overwritten.

Condense the commit message without removing the lifetime rationale. 
Keep the explanation of the install-to-open and close-to-cleanup gaps, 
the installed `tty_port` reference, port-generation validation, 
failed-open close pairing, and delayed minor reuse protecting saved 
termios. Remove the full call trace and repeated descriptions of 
implementation details.

Preserve the current subject, functional implementation, error behavior, 
locking, provenance, recipient, `Fixes`, `Reported-by`, `Closes`, and 
`Link` tags. Add a v3 changelog explaining that the revision clarifies 
the lifecycle comment and slot invariant and shortens the commit 
message. Do not include unrelated refactoring.

On 9/10/2026 1:27 PM, syzbot wrote:
> A slab-use-after-free can occur when opening or closing a USB serial port
> while the gadget is concurrently being unbound or destroyed. The lifetime
> of struct gs_port was previously tracked only by port->port.count, with
> teardown waiting on wait_event(port->close_wait, gs_closed(port)) where
> gs_closed() checks whether count is zero. This leaves two intervals where
> gs_port is actively referenced by the TTY core but port->port.count is
> zero:
>
> 1. The install-to-open interval: when opening /dev/ttyGS*, the TTY layer
> installs the port before invoking gs_open(). In this interval,
> port->port.count is zero, so gs_closed() evaluates to true. If the gadget
> is concurrently unbound or destroyed, gserial_free_port() does not wait and
> frees gs_port, resulting in a slab-use-after-free write in tty_init_dev()
> or tty_open().
>
> 2. The close-to-cleanup/release interval: when closing /dev/ttyGS*,
> gs_close() decrements port->port.count to zero and wakes up close_wait.
> Concurrently, gserial_free_port() wakes up and frees gs_port before
> tty_release() finishes, causing a slab-use-after-free in release_tty() when
> it accesses tty->port.
>
> BUG: KASAN: slab-use-after-free in tty_init_dev+0x244/0x4d0
> drivers/tty/tty_io.c:1397
> Write of size 8 at addr ffff88818c23b128
>
> Call Trace:
>   <TASK>
>   tty_init_dev+0x244/0x4d0 drivers/tty/tty_io.c:1397
>   tty_open_by_driver drivers/tty/tty_io.c:2046 [inline]
>   tty_open+0x7d9/0xcc0 drivers/tty/tty_io.c:2093
>   chrdev_open+0x4d9/0x600 fs/char_dev.c:411
>   do_dentry_open+0x816/0x1380 fs/open.c:996
>   vfs_open+0x3b/0x340 fs/open.c:1101
>   path_openat+0x1443/0x1d60 fs/namei.c:5000
>   do_file_open+0x23e/0x4a0 fs/namei.c:5029
>   do_sys_openat2+0x115/0x200 fs/open.c:1417
>   do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   </TASK>
>
> Allocated by task 5844:
>   gs_port_alloc drivers/usb/gadget/function/u_serial.c:1218 [inline]
>   gserial_alloc_line_no_console+0x232/0x6e0
>   drivers/usb/gadget/function/u_serial.c:1298
>   gserial_alloc_line+0x18/0x90 drivers/usb/gadget/function/u_serial.c:1332
>   acm_alloc_instance+0xc7/0x140 drivers/usb/gadget/function/f_acm.c:891
>   usb_get_function_instance+0xe3/0x2f0 drivers/usb/gadget/functions.c:44
>   configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1360
>
> Freed by task 5844:
>   kfree+0x1c5/0x650 mm/slub.c:6792
>   gserial_free_port+0x248/0x2c0 drivers/usb/gadget/function/u_serial.c:1262
>   gserial_free_line+0xc0/0x1f0 drivers/usb/gadget/function/u_serial.c:1279
>   acm_free_instance+0x39/0x60 drivers/usb/gadget/function/f_acm.c:875
>   usb_put_function_instance+0x95/0xc0 drivers/usb/gadget/functions.c:77
>   configfs_rmdir+0x885/0x950 fs/configfs/dir.c:1571
>
> Fix these issues by managing the lifetime of struct gs_port with standard
> tty_port reference counting:
>
> - Implement .install (gs_install) to take a reference with tty_port_get(),
> attach the port via tty_port_install(), and initialize tty->driver_data
> while holding the port mutex.
> - Implement .cleanup (gs_cleanup) to drop the tty_struct's port reference
> with tty_port_put().
> - Implement the .destruct port operation (gs_port_destruct) to free the
> write FIFO buffer and kfree() the gs_port structure once all references
> have been dropped.
> - In gserial_free_port(), replace direct destruction and freeing with
> tty_port_put().
> - Enforce installed-object identity during open: in gs_open(), verify under
> ports[port_num].lock that tty->driver_data matches ports[port_num].port to
> ensure the port was not unregistered or replaced between install and open.
> - Handle failed-open close pairing: track failed gs_open() attempts with an
> open_close_failures counter so the corresponding gs_close() called by the
> TTY core on open failure consumes the counter and exits without altering
> port->port.count or triggering spurious warnings.
> - Delay minor reuse to protect saved termios: keep a reserved flag in
> ports[] set until gs_port_destruct() completes, and call
> tty_unregister_device() before dropping the owner port reference in
> gserial_free_line(). This prevents minor reuse while device cleanup,
> release, or termios saving is still underway.
>
> Fixes: 19b10a8828a6 ("usb: gadget: allocate & giveback serial ports instead hard code them")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+fe63e4d633540f230624@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=fe63e4d633540f230624
> Link: https://syzkaller.appspot.com/ai_job?id=0076f60b-d76e-4eb9-b805-b385e7452af0
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
> Cc: "Ai Chao" <aichao@kylinos.cn>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - Added minor reservation tracking (`reserved` flag) released in `gs_port_destruct()` to delay minor reuse and protect saved termios.
> - Reordered `tty_unregister_device()` to run before `gserial_free_port()` in `gserial_free_line()`.
> - Added an `open_close_failures` counter to pair failed `gs_open()` calls with matching `gs_close()` invocations without corrupting `port->port.count`.
> - Added installed-port identity verification in `gs_open()` against the registered port slot.
> - Retained `ports[].lock` across `tty_port_install()` and `tty->driver_data` assignment in `gs_install()`.
> - Replaced `gserial_free_port()` with `tty_port_put()` on error path in `gserial_alloc_line_no_console()`.
>
> v1:
> https://lore.kernel.org/all/acde99b9-2954-43ab-8403-6ca10699472d@mail.kernel.org/T/
> ---
> diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
> index cdd1dfc66..ed258c9a8 100644
> --- a/drivers/usb/gadget/function/u_serial.c
> +++ b/drivers/usb/gadget/function/u_serial.c
> @@ -60,20 +60,37 @@
>    * is managed in userspace ... OBEX, PTP, and MTP have been mentioned.
>    *
>    *
> - * gserial is the lifecycle interface, used by USB functions
> - * gs_port is the I/O nexus, used by the tty driver
> - * tty_struct links to the tty/filesystem framework
> + * Lifecycle and state management:
> + *
> + * gserial is the lifecycle interface, used by USB functions.
> + * gs_port is the I/O nexus, used by the tty driver.
> + * tty_struct links to the tty/filesystem framework.
>    *
>    * gserial <---> gs_port ... links will be null when the USB link is
> - * inactive; managed by gserial_{connect,disconnect}().  each gserial
> + * inactive; managed by gserial_{connect,disconnect}().  Each gserial
>    * instance can wrap its own USB control protocol.
>    *	gserial->ioport == usb_ep->driver_data ... gs_port
>    *	gs_port->port_usb ... gserial
>    *
> - * gs_port <---> tty_struct ... links will be null when the TTY file
> - * isn't opened; managed by gs_open()/gs_close()
> - *	gserial->port_tty ... tty_struct
> - *	tty_struct->driver_data ... gserial
> + * gs_port <---> tty_struct:
> + *	tty->driver_data refers to gs_port from install through cleanup,
> + *	pinning the port via tty_port reference counting.
> + *	gs_port->port.tty exists only while the port is open.
> + *
> + * Each entry in ports[] is guarded by ports[i].lock and models three states:
> + *   - Free:      !port && !reserved
> + *   - Published:  port &&  reserved
> + *   - Retiring:  !port &&  reserved
> + *
> + * A minor remains reserved until gs_port_destruct() runs upon final tty_port
> + * release, preventing minor reuse while cleanup or termios saving is still
> + * underway. The owner reference is retained through device unregister so the
> + * destructor releases the reservation only after device teardown is complete.
> + *
> + * open_close_failures tracks failed gs_open() calls where port->port.count
> + * was not incremented, so the matching gs_close() called by the TTY core on
> + * open failure can consume it and exit without altering successful open counts.
> + * It is protected by tty_lock.
>    */
>   
>   /* RX and TX queues can buffer QUEUE_SIZE packets before they hit the
> @@ -128,6 +145,7 @@ struct gs_port {
>   	wait_queue_head_t	close_wait;
>   	bool			suspended;	/* port suspended */
>   	bool			start_delayed;	/* delay start when suspended */
> +	unsigned int		open_close_failures; /* protected by tty_lock */
>   	struct async_icount	icount;
>   
>   	/* REVISIT this state ... */
> @@ -135,8 +153,9 @@ struct gs_port {
>   };
>   
>   static struct portmaster {
> -	struct mutex	lock;			/* protect open/close */
> +	struct mutex	lock;			/* protect open/close and port slot */
>   	struct gs_port	*port;
> +	bool		reserved;
>   } ports[MAX_U_SERIAL_PORTS];
>   
>   #define GS_CLOSE_TIMEOUT		15		/* seconds */
> @@ -603,42 +622,78 @@ static int gserial_wakeup_host(struct gserial *gser)
>   
>   /* TTY Driver */
>   
> +static int gs_install(struct tty_driver *driver, struct tty_struct *tty)
> +{
> +	struct gs_port *port;
> +	struct tty_port *tport;
> +	int ret;
> +
> +	mutex_lock(&ports[tty->index].lock);
> +	port = ports[tty->index].port;
> +	if (!port) {
> +		mutex_unlock(&ports[tty->index].lock);
> +		return -ENODEV;
> +	}
> +
> +	tport = tty_port_get(&port->port);
> +	if (!tport) {
> +		mutex_unlock(&ports[tty->index].lock);
> +		return -ENODEV;
> +	}
> +
> +	ret = tty_port_install(tport, driver, tty);
> +	if (ret) {
> +		mutex_unlock(&ports[tty->index].lock);
> +		tty_port_put(tport);
> +		return ret;
> +	}
> +
> +	tty->driver_data = port;
> +	mutex_unlock(&ports[tty->index].lock);
> +
> +	return 0;
> +}
> +
> +static void gs_cleanup(struct tty_struct *tty)
> +{
> +	tty_port_put(tty->port);
> +}
> +
>   /*
> - * gs_open sets up the link between a gs_port and its associated TTY.
> - * That link is broken *only* by TTY close(), and all driver methods
> - * know that.
> + * gs_open associates an open TTY with its gs_port.
> + * That link is broken by TTY close(), and all driver methods know that.
>    */
>   static int gs_open(struct tty_struct *tty, struct file *file)
>   {
>   	int		port_num = tty->index;
> -	struct gs_port	*port;
> +	struct gs_port	*port = tty->driver_data;
>   	int		status = 0;
>   
> +	if (!port)
> +		return -ENODEV;
> +
>   	mutex_lock(&ports[port_num].lock);
> -	port = ports[port_num].port;
> -	if (!port) {
> +	if (ports[port_num].port != port) {
>   		status = -ENODEV;
> -		goto out;
> +		goto fail_unlock;
>   	}
>   
>   	spin_lock_irq(&port->port_lock);
>   
>   	/* allocate circular buffer on first open */
>   	if (!kfifo_initialized(&port->port_write_buf)) {
> -
>   		spin_unlock_irq(&port->port_lock);
>   
>   		/*
>   		 * portmaster's mutex still protects from simultaneous open(),
>   		 * and close() can't happen, yet.
>   		 */
> -
>   		status = kfifo_alloc(&port->port_write_buf,
>   				     WRITE_BUF_SIZE, GFP_KERNEL);
>   		if (status) {
>   			pr_debug("gs_open: ttyGS%d (%p,%p) no buffer\n",
>   				 port_num, tty, file);
> -			goto out;
> +			goto fail_unlock;
>   		}
>   
>   		spin_lock_irq(&port->port_lock);
> @@ -648,7 +703,6 @@ static int gs_open(struct tty_struct *tty, struct file *file)
>   	if (port->port.count++)
>   		goto exit_unlock_port;
>   
> -	tty->driver_data = port;
>   	port->port.tty = tty;
>   
>   	/* if connected, start the I/O stream */
> @@ -672,7 +726,11 @@ static int gs_open(struct tty_struct *tty, struct file *file)
>   
>   exit_unlock_port:
>   	spin_unlock_irq(&port->port_lock);
> -out:
> +	mutex_unlock(&ports[port_num].lock);
> +	return status;
> +
> +fail_unlock:
> +	port->open_close_failures++;
>   	mutex_unlock(&ports[port_num].lock);
>   	return status;
>   }
> @@ -695,6 +753,14 @@ static void gs_close(struct tty_struct *tty, struct file *file)
>   	struct gs_port *port = tty->driver_data;
>   	struct gserial	*gser;
>   
> +	if (!port)
> +		return;
> +
> +	if (port->open_close_failures > 0) {
> +		port->open_close_failures--;
> +		return;
> +	}
> +
>   	spin_lock_irq(&port->port_lock);
>   
>   	if (port->port.count != 1) {
> @@ -909,8 +975,10 @@ static int gs_get_icount(struct tty_struct *tty,
>   }
>   
>   static const struct tty_operations gs_tty_ops = {
> +	.install =		gs_install,
>   	.open =			gs_open,
>   	.close =		gs_close,
> +	.cleanup =		gs_cleanup,
>   	.write =		gs_write,
>   	.put_char =		gs_put_char,
>   	.flush_chars =		gs_flush_chars,
> @@ -1203,6 +1271,26 @@ static void gs_console_exit(struct gs_port *port)
>   
>   #endif
>   
> +static void gs_port_destruct(struct tty_port *tport)
> +{
> +	struct gs_port *port = container_of(tport, struct gs_port, port);
> +	unsigned int port_num = port->port_num;
> +
> +	mutex_lock(&ports[port_num].lock);
> +	if (WARN_ON(ports[port_num].port))
> +		ports[port_num].port = NULL;
> +	WARN_ON(!ports[port_num].reserved);
> +	ports[port_num].reserved = false;
> +	mutex_unlock(&ports[port_num].lock);
> +
> +	kfifo_free(&port->port_write_buf);
> +	kfree(port);
> +}
> +
> +static const struct tty_port_operations gs_port_ops = {
> +	.destruct = gs_port_destruct,
> +};
> +
>   static int
>   gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
>   {
> @@ -1210,7 +1298,7 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
>   	int		ret = 0;
>   
>   	mutex_lock(&ports[port_num].lock);
> -	if (ports[port_num].port) {
> +	if (ports[port_num].port || ports[port_num].reserved) {
>   		ret = -EBUSY;
>   		goto out;
>   	}
> @@ -1222,6 +1310,7 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
>   	}
>   
>   	tty_port_init(&port->port);
> +	port->port.ops = &gs_port_ops;
>   	spin_lock_init(&port->port_lock);
>   	init_waitqueue_head(&port->drain_wait);
>   	init_waitqueue_head(&port->close_wait);
> @@ -1235,6 +1324,7 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
>   	port->port_num = port_num;
>   	port->port_line_coding = *coding;
>   
> +	ports[port_num].reserved = true;
>   	ports[port_num].port = port;
>   out:
>   	mutex_unlock(&ports[port_num].lock);
> @@ -1258,8 +1348,7 @@ static void gserial_free_port(struct gs_port *port)
>   	/* wait for old opens to finish */
>   	wait_event(port->close_wait, gs_closed(port));
>   	WARN_ON(port->port_usb != NULL);
> -	tty_port_destroy(&port->port);
> -	kfree(port);
> +	tty_port_put(&port->port);
>   }
>   
>   void gserial_free_line(unsigned char port_num)
> @@ -1276,8 +1365,8 @@ void gserial_free_line(unsigned char port_num)
>   	ports[port_num].port = NULL;
>   	mutex_unlock(&ports[port_num].lock);
>   
> -	gserial_free_port(port);
>   	tty_unregister_device(gs_tty_driver, port_num);
> +	gserial_free_port(port);
>   }
>   EXPORT_SYMBOL_GPL(gserial_free_line);
>   
> @@ -1318,7 +1407,7 @@ int gserial_alloc_line_no_console(unsigned char *line_num)
>   		mutex_lock(&ports[port_num].lock);
>   		ports[port_num].port = NULL;
>   		mutex_unlock(&ports[port_num].lock);
> -		gserial_free_port(port);
> +		tty_port_put(&port->port);
>   		goto err;
>   	}
>   	*line_num = port_num;
>
>
> base-commit: df2908090cda368b01ff43709f51890076c56157
