Received: from mail-ed2-f32.google.com (mail-ed2-f32.google.com [74.125.228.96])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBDFA3CB907
	for <syzbot@lists.linux.dev>; Thu,  1 Oct 2026 11:16:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.96
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790853367; cv=none; b=cXP2DL/Fl52NqEWRgfMdn08ETBLDd7kBxHoUPL6YFaubBT3kzxAb5z8Fd8zhmUFpoJY4V0glzTMcJ7ncOdMsp/DRFwkU3dCcUyph2xqztqzgRfcauDq5vLv9JAad6TgMoHQRaICVVnACHUaE2BIIPrtLesMqBzdKwypt5zOptzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790853367; c=relaxed/simple;
	bh=hm/8XO0+MZ0/DyXdj6/Dr+9zmOGg/v4EqAqxctXjGgk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=cdN2XkVcC0GFTj729gatQU8akQvaneRPb9qnjhxv/25ig6S7fAWPUOjHejKz7ClfbqhAxRyrpMJ2CJ1RHdz+dAIi76zGmny7PKglx6rxBmcxOnXO3Q4SZUB1APhrxAz/PKynINUE+uskbWFE8MbDOB8vbibWxK+mjYTF1QiY26k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=JOySCl9N; arc=none smtp.client-ip=74.125.228.96
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JOySCl9N"
Received: by mail-ed2-f32.google.com with SMTP id 4fb4d7f45d1cf-6acb91ecaccso4197636a12.2
        for <syzbot@lists.linux.dev>; Thu, 01 Oct 2026 04:16:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790853363; x=1791458163; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=HTPWMHzyWsbr77YWduEMsz4zVE54oq1+DCiXpx2Fo5g=;
        b=JOySCl9NKcGSKyfJYXM4D/dHsmwNQPh10vhVO7FoYq13yuoq3vk0owGUnuaBLUMQ3d
         mW2M8b/4tifSsOJ8U5hYDRaplRftvC69GN7Z4UIQYCJy4wUX5PD0+FMlAQihuYoXzavH
         BXpQOgforsPdfsgRY0K2AFJMHFX2b5PcuCKrXLhKT7ipx0UlwEd+BclQ5yEB8bMuJ1xG
         k8ak/FQ5W3l1iTjHlDMSq1ddsYJFrgotkhSMZJKAbnMPr0a/je7VCGaG5jZ8+jzAaEUX
         /ZIlvJJ8XOxDo+WAPwyoL7hoKZUImUNgMXsVdufY0LR8r9NxUvhfmRcgYNe4ONDnIoLM
         WJEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790853363; x=1791458163;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=HTPWMHzyWsbr77YWduEMsz4zVE54oq1+DCiXpx2Fo5g=;
        b=U5I5y/oZy0Rlo0OXVuGj1EFA09K5ejUf9EcSxFFRcY4CDGcTO417wjggSEvU2qTFwY
         UL6LDw/kMqplE8t+KP+97Q8PiN3s/b8J55/r64IezANax9Il8Op4Tj4RP/uFE97xtJ0L
         BtFVukjnrvCWNcCDZxsh8SHJWTZNqyTYLgCi2l9TdYWff8ebnIaxxnEufH2zs/1sGoBA
         pnmekNdbHrN1BFhwNIVsnBe1DYBgXK2woVtRtw64cwVFlouV02dls66F/KnG5jq4VmjV
         g3pQqN71/YjmJrUU9+Q4s58C6hhPUmxG+Oa1bxeaiBf7Dj69G1jvshUIhzaKUQ3O4KWp
         Iyxw==
X-Gm-Message-State: AFuF++lptMo4ClsvP8wlhL/vs026A6MFXdgEAp9jOgdqPM0hVvpyxbbT
	2EFcw/kmQzTkO+bDcz+rLP29CKIASofMwQXpmannsr+a+8gzfk4JVdfB
X-Gm-Gg: AYBFou1A0K/fsD87QlHIUk27h7JLxJ11l8r3jdnCydn2aXiReC7PYTtXkT2H5dvc2e3
	lF5+SY6oMPM0fpEgvgC2DDvJwltxw8DHGdDw84fV7Ox5ne0aNmgs77ecg9kJix1W6Ize939I2wE
	ka0S+/PJD+PCFh2QVlGiB3BoeZfMmGym58YthNOxhAn3KUKwfTz2BnbEBU9vPrGCK6PLFS22fW5
	E9ixq1UtdgxLdGb2r0Hih2r1B/3kR9QGKB/Z0HBBXkrVZbvyU128PBHjHHNsmFdkH8XRpU9N0/5
	YLZ31UsbwM/eSVW2Hnzd3VHj+Xb2PpSnUUvDGKqqr4YSFJHMQWiiOHBvW0XAccRfDjIyq1Hh5zb
	5QRQmON2ojCiAllPdaTbXLd2d1Toz0/gQjnGlGZcaqfdFAzpnoDEPNk2hqjO1TBBudHpykO0Gnh
	ujXSvw8Sx3JSvHaB1oEHRt0+5+iwrMugrxQ8+CLVmiOC1Wgwh0QIruDSqBxStcu0ijhP/GvgK4h
	kUNyTCuYmVaC07yCnFm33mz8pps53UUaiUorSCj52/C75aw8K8dSxrCiUFSyelJnFU2XdKkdBe8
	nhOcYW7Os+VVqfp0YpB72rHj8mtrB6qk4NX4uEPt2rSwQJqMKz2OcHKjtFFm2c6+lXZNrxtPLx+
	Sl/pQ5R7SyocyNo6iYVClDqqTAUsaN/V2Gw==
X-Received: by 2002:a17:907:728d:b0:c2d:fc0b:551c with SMTP id a640c23a62f3a-c2e23ca157fmr354425266b.16.1790853362541;
        Thu, 01 Oct 2026 04:16:02 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e31ce3219sm141606966b.26.2026.10.01.04.16.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 01 Oct 2026 04:16:01 -0700 (PDT)
Message-ID: <3dc9bf36-29da-48e8-a541-ee25cfe94e6f@gmail.com>
Date: Thu, 1 Oct 2026 13:16:00 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4] usb: gadget: u_serial: pin ports while TTYs are
 installed
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <e53f1fc8-ddd7-4dbf-be17-696c5c36b68a@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <e53f1fc8-ddd7-4dbf-be17-696c5c36b68a@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/28/26 22:19, syzbot wrote:
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
> Fix these issues by managing the lifetime of struct gs_port with standard
> tty_port reference counting. Pin the port during tty install and release it
> in tty cleanup, deferring buffer and struct freeing to the port destructor
> once all references are dropped.
> 
> Enforce port-generation validation in gs_open() under the port lock to
> verify that the installed port matches the registered port, ensuring the
> port was not unregistered or replaced between install and open. Track
> failed opens as aggregate credits across the port rather than paired with
> individual files (another gs_close() can consume a failed open's credit
> before that file's own close runs), allowing gs_close() called by the TTY
> core on failure to exit cleanly without altering open counts. Finally,
> delay minor reuse to protect saved termios by keeping the slot reserved
> until port destruction completes and unregistering the device before
> dropping the driver's port reference.
> 
> Fixes: 19b10a8828a6 ("usb: gadget: allocate & giveback serial ports instead hard code them")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+fe63e4d633540f230624@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=fe63e4d633540f230624
> Link: https://syzkaller.appspot.com/ai_job?id=47fc8e8b-9ef9-4e57-8471-e728e0d08b61
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
> Cc: "Ai Chao" <aichao@kylinos.cn>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v4:
> - Clarified in the commit message and comments that open_close_failures accounting is aggregate across the port rather than paired with individual files
> - Cleared gs_tty_driver->ports[port_num] in gs_port_destruct()
> 
> v3:
> - Clarify the lifecycle comment and slot invariant.
> - Shorten the commit message by removing the full call trace and condensing implementation details.
> https://lore.kernel.org/all/1e5c22f0-19bc-4c1f-9638-6ae619179e29@mail.kernel.org/T/
> 
> v2:
> - Added minor reservation tracking (`reserved` flag) released in `gs_port_destruct()` to delay minor reuse and protect saved termios.
> - Reordered `tty_unregister_device()` to run before `gserial_free_port()` in `gserial_free_line()`.
> - Added an `open_close_failures` counter to pair failed `gs_open()` calls with matching `gs_close()` invocations without corrupting `port->port.count`.
> - Added installed-port identity verification in `gs_open()` against the registered port slot.
> - Retained `ports[].lock` across `tty_port_install()` and `tty->driver_data` assignment in `gs_install()`.
> - Replaced `gserial_free_port()` with `tty_port_put()` on error path in `gserial_alloc_line_no_console()`.
> https://lore.kernel.org/all/5dc8c18b-cfac-4e42-a158-b5e92bab89ca@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/acde99b9-2954-43ab-8403-6ca10699472d@mail.kernel.org/T/
> ---
> diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
> index cdd1dfc66..89c4feb42 100644
> --- a/drivers/usb/gadget/function/u_serial.c
> +++ b/drivers/usb/gadget/function/u_serial.c
> @@ -60,20 +60,40 @@
>   * is managed in userspace ... OBEX, PTP, and MTP have been mentioned.
>   *
>   *
> - * gserial is the lifecycle interface, used by USB functions
> - * gs_port is the I/O nexus, used by the tty driver
> - * tty_struct links to the tty/filesystem framework
> + * Lifecycle and state management:
> + *
> + * gserial is the lifecycle interface, used by USB functions.
> + * gs_port is the I/O nexus, used by the tty driver.
> + * tty_struct links to the tty/filesystem framework.
>   *
>   * gserial <---> gs_port ... links will be null when the USB link is
> - * inactive; managed by gserial_{connect,disconnect}().  each gserial
> + * inactive; managed by gserial_{connect,disconnect}().  Each gserial
>   * instance can wrap its own USB control protocol.
>   *	gserial->ioport == usb_ep->driver_data ... gs_port
>   *	gs_port->port_usb ... gserial
>   *
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
> + * was not incremented. The TTY core calls gs_close() on open failure to tear
> + * down the tty; tracking failures as aggregate credits allows gs_close() to
> + * consume a credit and exit without decrementing port->port.count. Credits
> + * are aggregate rather than paired with individual files (another gs_close()
> + * can consume a failed open's credit before that file's own close runs).
> + * It is protected by tty_lock.
>   */
>  
>  /* RX and TX queues can buffer QUEUE_SIZE packets before they hit the
> @@ -128,6 +148,7 @@ struct gs_port {
>  	wait_queue_head_t	close_wait;
>  	bool			suspended;	/* port suspended */
>  	bool			start_delayed;	/* delay start when suspended */
> +	unsigned int		open_close_failures; /* protected by tty_lock */
>  	struct async_icount	icount;
>  
>  	/* REVISIT this state ... */
> @@ -135,8 +156,9 @@ struct gs_port {
>  };
>  
>  static struct portmaster {
> -	struct mutex	lock;			/* protect open/close */
> +	struct mutex	lock;			/* protect open/close and port slot */
>  	struct gs_port	*port;
> +	bool		reserved;
>  } ports[MAX_U_SERIAL_PORTS];
>  
>  #define GS_CLOSE_TIMEOUT		15		/* seconds */
> @@ -603,42 +625,81 @@ static int gserial_wakeup_host(struct gserial *gser)
>  
>  /* TTY Driver */
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
>  /*
> - * gs_open sets up the link between a gs_port and its associated TTY.
> - * That link is broken *only* by TTY close(), and all driver methods
> - * know that.
> + * gs_open associates an open TTY with its gs_port.
> + *
> + * There are two TTY-to-port relationships: port->port.tty exists from the
> + * first successful open until final close, while tty->driver_data is assigned
> + * during gs_install() and remains valid through gs_cleanup().
>   */
>  static int gs_open(struct tty_struct *tty, struct file *file)
>  {
>  	int		port_num = tty->index;
> -	struct gs_port	*port;
> +	struct gs_port	*port = tty->driver_data;
>  	int		status = 0;
>  
> +	if (!port)
> +		return -ENODEV;
> +
>  	mutex_lock(&ports[port_num].lock);
> -	port = ports[port_num].port;
> -	if (!port) {
> +	if (ports[port_num].port != port) {
>  		status = -ENODEV;
> -		goto out;
> +		goto fail_unlock;
>  	}
>  
>  	spin_lock_irq(&port->port_lock);
>  
>  	/* allocate circular buffer on first open */
>  	if (!kfifo_initialized(&port->port_write_buf)) {
> -
>  		spin_unlock_irq(&port->port_lock);
>  
>  		/*
>  		 * portmaster's mutex still protects from simultaneous open(),
>  		 * and close() can't happen, yet.
>  		 */
> -
>  		status = kfifo_alloc(&port->port_write_buf,
>  				     WRITE_BUF_SIZE, GFP_KERNEL);
>  		if (status) {
>  			pr_debug("gs_open: ttyGS%d (%p,%p) no buffer\n",
>  				 port_num, tty, file);
> -			goto out;
> +			goto fail_unlock;
>  		}
>  
>  		spin_lock_irq(&port->port_lock);
> @@ -648,7 +709,6 @@ static int gs_open(struct tty_struct *tty, struct file *file)
>  	if (port->port.count++)
>  		goto exit_unlock_port;
>  
> -	tty->driver_data = port;
>  	port->port.tty = tty;
>  
>  	/* if connected, start the I/O stream */
> @@ -672,7 +732,11 @@ static int gs_open(struct tty_struct *tty, struct file *file)
>  
>  exit_unlock_port:
>  	spin_unlock_irq(&port->port_lock);
> -out:
> +	mutex_unlock(&ports[port_num].lock);
> +	return status;
> +
> +fail_unlock:
> +	port->open_close_failures++;
>  	mutex_unlock(&ports[port_num].lock);
>  	return status;
>  }
> @@ -695,6 +759,14 @@ static void gs_close(struct tty_struct *tty, struct file *file)
>  	struct gs_port *port = tty->driver_data;
>  	struct gserial	*gser;
>  
> +	if (!port)
> +		return;
> +
> +	if (port->open_close_failures > 0) {
> +		port->open_close_failures--;
> +		return;
> +	}
> +
>  	spin_lock_irq(&port->port_lock);
>  
>  	if (port->port.count != 1) {
> @@ -909,8 +981,10 @@ static int gs_get_icount(struct tty_struct *tty,
>  }
>  
>  static const struct tty_operations gs_tty_ops = {
> +	.install =		gs_install,
>  	.open =			gs_open,
>  	.close =		gs_close,
> +	.cleanup =		gs_cleanup,
>  	.write =		gs_write,
>  	.put_char =		gs_put_char,
>  	.flush_chars =		gs_flush_chars,
> @@ -1203,6 +1277,28 @@ static void gs_console_exit(struct gs_port *port)
>  
>  #endif
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
> +	if (gs_tty_driver)
> +		gs_tty_driver->ports[port_num] = NULL;
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
>  static int
>  gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
>  {
> @@ -1210,7 +1306,12 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
>  	int		ret = 0;
>  
>  	mutex_lock(&ports[port_num].lock);
> -	if (ports[port_num].port) {
> +	if (WARN_ON_ONCE(ports[port_num].port && !ports[port_num].reserved)) {
> +		ret = -EBUSY;
> +		goto out;
> +	}
> +
> +	if (ports[port_num].reserved) {
>  		ret = -EBUSY;
>  		goto out;
>  	}
> @@ -1222,6 +1323,7 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
>  	}
>  
>  	tty_port_init(&port->port);
> +	port->port.ops = &gs_port_ops;
>  	spin_lock_init(&port->port_lock);
>  	init_waitqueue_head(&port->drain_wait);
>  	init_waitqueue_head(&port->close_wait);
> @@ -1235,6 +1337,7 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
>  	port->port_num = port_num;
>  	port->port_line_coding = *coding;
>  
> +	ports[port_num].reserved = true;
>  	ports[port_num].port = port;
>  out:
>  	mutex_unlock(&ports[port_num].lock);
> @@ -1258,8 +1361,7 @@ static void gserial_free_port(struct gs_port *port)
>  	/* wait for old opens to finish */
>  	wait_event(port->close_wait, gs_closed(port));
>  	WARN_ON(port->port_usb != NULL);
> -	tty_port_destroy(&port->port);
> -	kfree(port);
> +	tty_port_put(&port->port);
>  }
>  
>  void gserial_free_line(unsigned char port_num)
> @@ -1276,8 +1378,8 @@ void gserial_free_line(unsigned char port_num)
>  	ports[port_num].port = NULL;
>  	mutex_unlock(&ports[port_num].lock);
>  
> -	gserial_free_port(port);
>  	tty_unregister_device(gs_tty_driver, port_num);
> +	gserial_free_port(port);
>  }
>  EXPORT_SYMBOL_GPL(gserial_free_line);
>  
> @@ -1318,7 +1420,7 @@ int gserial_alloc_line_no_console(unsigned char *line_num)
>  		mutex_lock(&ports[port_num].lock);
>  		ports[port_num].port = NULL;
>  		mutex_unlock(&ports[port_num].lock);
> -		gserial_free_port(port);
> +		tty_port_put(&port->port);
>  		goto err;
>  	}
>  	*line_num = port_num;
> 
> 
> base-commit: df2908090cda368b01ff43709f51890076c56157
Reserve the replacement gadget serial minor without publishing its port until `tty_port_register_device()` has completed. The current patch publishes `ports[minor].port` before TTY registration clears saved termios for that minor. A concurrent `gs_install()` can then enter `tty_init_termios()` while `tty_register_device_attr()` frees the pointer, and the supplied race reproduced a KASAN use-after-free on the patched kernel.

Keep the TTY install-to-cleanup port reference, generation check on open, failed-open close credits, delayed old-minor reuse, destructor cleanup, and unregister-before-owner-put ordering. During new registration, an install should see no published port and return `-ENODEV`. Publish the new port under the slot mutex only after registration succeeds. On registration failure, release the unpublished owner reference and reservation. Update the commit message to explain this publication ordering and its saved-termios consequence.

After making that ordering correction, also fix two inaccurate statements in the commit message. Say that `gs_open()` compares the installed port with the slot under `ports[port_num].lock`, the portmaster mutex. Do not call this "the port lock", because `port->port_lock` is a different lock and is not held for that comparison. Describe the free trigger as removal of the serial function instance, which reaches `acm_free_instance()` and `gserial_free_line()` in the reported configfs `rmdir` path. Gadget unbind or `gserial_disconnect()` alone only disconnects the port and does not free `gs_port`.

Keep the new comments about `tty->driver_data`, the slot states, and `open_close_failures`, but drop unrelated formatting churn. Remove the added "Lifecycle and state management:" heading, restore the original punctuation and capitalization in the surrounding unchanged sentences, and restore the two blank lines around `kfifo_alloc()` in `gs_open()`. Do not make any other behavioral change.

-- 
Krystian Kaniewski
