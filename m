Received: from mail-ej2-f41.google.com (mail-ej2-f41.google.com [74.125.228.169])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B51B54C7558
	for <syzbot@lists.linux.dev>; Fri,  2 Oct 2026 15:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.169
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790956386; cv=none; b=mt+sxC9l95Q1qFBlBqfh7LvNB0S6qUwg2gm8KET1RpiYGo98LecLXrhx8VMIon0VY3iQPAMQab7+5HngzjHC6kSfUybiZGXa+ZyW6OPqxl21EcOCn8iePx2yK0NJH8boNBJAFcjXzxMszco4CU4Wdjkj/Jy0k5T6SSwDFb7jOjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790956386; c=relaxed/simple;
	bh=miy3tugzChbLo5Icpjyz3q++E6GcSXxg7IZNSAQeA/Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=lZ5ueKA+6Jb/SwlM5noUkT5gFsILIuWj843+7SbPG1UahnDxatc6ozKTi/JfW7GcPA88/MGTtrBbsTzsgGH2V1wIxECsC8Uyu2pjygBaXxyDbPHoJpfTHc5qaRTkDHHqY45h0L10xcytkqR2f51q8PmgFMTWe1bqVY3HUqtSIeE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=UrAhLyAw; arc=none smtp.client-ip=74.125.228.169
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="UrAhLyAw"
Received: by mail-ej2-f41.google.com with SMTP id a640c23a62f3a-c2e3dcfe205so7599066b.0
        for <syzbot@lists.linux.dev>; Fri, 02 Oct 2026 08:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790956379; x=1791561179; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=df9azaHSTcJUspkogm+Mkz1XtKYJmJBA5uToSeWx6cw=;
        b=UrAhLyAwWXU/e9O/O+/LKpT2nB3kaziGMMfNsZmZFbFePfBV8a7QCwVce0UbCRJJZ+
         qgoSvdyj0N15/kMMVqEQFZr/Fm+Hp7uKNROUVKsdzdnlVcZhC4U+EujUkd0cdLSOhIN2
         N3Y13P7Ay93IgHg1ly26B2IBcp8VouqGBuB8kGIdrD0i5PDnY0E49CVOqLPy8BjqiPIT
         T54ha+N7gGSA2uiwmKcFkytDbLsZeb4+hZZMPWRJrNsH8WM7wFAYXBEhuGrb+5xUoEpm
         jZnUuwWkloxI91P3UyISXeWerq5N6woZJR09xDsEfEmbqg/dyfe1waMz11G3iB1KMPDT
         6SQQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790956379; x=1791561179;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=df9azaHSTcJUspkogm+Mkz1XtKYJmJBA5uToSeWx6cw=;
        b=SgW6emoDu96VNTjw9rygivBVhqyNNENarzt1voIWfYAmVo9IQKdZUauSJvu0V873aR
         8b3E+uvy+WlYvNQeh92GrfacMXFh7L+VijgWFybf2ha6nw+uYB6TyxiCDRVZRzsD8K+U
         ZT9kZ3EmtXn5t1+lQ/bzXAGGKe3i7h9LKiyX5AqbpstxI+9uepnIWfUnBA4uXdAaLt/A
         JhRN94aSTLCBdaDVGZQ4P9H8+2tZLNlw9sbrglQHmzEAHEVsAbnYJ6N8AFVctPM3WvHc
         QXzV/R/58MSBcsXgQC1SoEBZk24GqgsOIjgrWG5D2Dtq6WJwzn5kZ8XS9D0wZCle6A37
         fyxw==
X-Gm-Message-State: AFuF++lgwwWPF1wze3x+iSnLJlwg5U618+XUMhsFh8e5xGdGrKukPbL1
	yGHuwdNu7F6pbANqjDSAzdCJrpFlrNuWLaXmDyPcQJtLLbUy7lf9NoPe
X-Gm-Gg: AYBFou0bNgZ7ryTwVrWPxsptm+mM3Gd8rIOtAjZuRogjFyBwxYLiZM6o8wsti/cj4Ai
	JQjI7vccFJa7X/AmhZKoK2zohSZg1nyH3aq/nkkc4Q0Y7HwC4UtZvrIX90T7jUA7dY9urC0WfcR
	6M7eKOHYxrf2lI12lwjZVZmop3syCW4jlzEBrIRk5gqbe2LDClE2VS5oT6TzLyn5ohmfFQeLRtg
	9niVrT707c2BWDrj/R6BpEVsZcy4guY4uUyUZyG0i4AWdXUMriEauX2yTMe7hw90zUgVG4tvVyy
	o50Csy96wSqmsJ+/nF9yvx0PC8UnmILrS+S7lVXYfKPp1aiGLd7pMidWrjKat1gqsyVVynpGbV/
	Kx0UMXkAK4vqW35pPRstHuf/mj07yzrPScwsgmPWgEZDNtoKO9L5qYc1sLkHiPlzHJsSmXdAuXL
	W0K8q42ugORrTktDWJguNe50iKg8G9pG/uuU7eql04m0zRzjYD4fXeNTQl4fD6tFQxCikYFreoD
	6Iz0vSZO5zoa9Zao2BQ7dVlC2YSQ/G3EihOhNSy1DQGtvIb2ynptbr9tXTDywNpW52pFvvHRW4P
	9TEKXKejdJc3ylG9GqrOLtgJ3Xa6VJ2wWRB93GfBaKqMmjx92sorC60SG2EV+TGNEHrovIA47wE
	lSFi5qqSFtPHYnb5ptm+gAdeRkMkBxmeFsw==
X-Received: by 2002:a17:906:ef0b:b0:c21:450d:cd7e with SMTP id a640c23a62f3a-c2e4ad141b7mr265179766b.9.1790956379022;
        Fri, 02 Oct 2026 08:52:59 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2e4cd057b2sm103784566b.16.2026.10.02.08.52.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 02 Oct 2026 08:52:58 -0700 (PDT)
Message-ID: <368cdd11-6b43-4336-8e7a-f8adb982d5f6@gmail.com>
Date: Fri, 2 Oct 2026 17:52:58 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v6] usb: gadget: u_serial: pin ports while TTYs are
 installed
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <da5731cf-bd41-40ea-a78c-7191f8421cd6@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <da5731cf-bd41-40ea-a78c-7191f8421cd6@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/2/26 17:26, syzbot wrote:
> A slab-use-after-free can occur when gserial_free_line() frees struct
> gs_port while it is still reachable by the TTY core. In the reported trace,
> the write in tty_init_dev() occurs while the TTY is installed because the
> port is freed while its TTY device is still registered and the driver table
> still points to it.
> 
> BUG: KASAN: slab-use-after-free in tty_init_dev+0x244/0x4d0
> drivers/tty/tty_io.c:1397
> Call Trace:
>  <TASK>
>  tty_init_dev+0x244/0x4d0 drivers/tty/tty_io.c:1397
>  tty_open_by_driver drivers/tty/tty_io.c:2046 [inline]
>  tty_open+0x7d9/0xcc0 drivers/tty/tty_io.c:2093
>  chrdev_open+0x4d9/0x600 fs/char_dev.c:411
>  do_dentry_open+0x816/0x1380 fs/open.c:996
>  vfs_open+0x3b/0x340 fs/open.c:1101
>  </TASK>
> 
> Fix this by managing the lifetime of struct gs_port with tty_port reference
> counting. Pin the port during gs_install() and release it in gs_cleanup(),
> deferring freeing to gs_port_destruct() once all references are dropped. In
> gserial_free_line(), unregister the device before waiting for existing
> closes and dropping the initial reference. Record failed gs_open() calls so
> gs_close() invoked by the TTY core on open failure exits without
> decrementing port->port.count. Check in gs_open() that the port was not
> removed between install and open; checking for a removed rather than
> replaced port suffices because the slot remains reserved while a TTY holds
> a reference to the old port. Finally, keep line numbers reserved until port
> destruction and defer publishing the port pointer in ports[] until after
> tty_port_register_device() succeeds, which protects saved termios because
> tty_register_device_attr() frees the saved termios of the index on every
> registration without holding tty_mutex.
> 
> Fixes: 19b10a8828a6 ("usb: gadget: allocate & giveback serial ports instead hard code them")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+fe63e4d633540f230624@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=fe63e4d633540f230624
> Link: https://syzkaller.appspot.com/ai_job?id=ec789387-2e7b-4a8f-a7a1-a47bf7fa57f5
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
> Cc: "Ai Chao" <aichao@kylinos.cn>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v6:
> - Clarified comment on ports[] states to note that !port && reserved covers in-progress device registration.
> - Rewrote commit description for brevity and technical accuracy per reviewer feedback.
> 
> v5:
> - Defer publishing ports[port_num].port until after tty_port_register_device() succeeds to avoid racing with gs_install().
> - Return struct gs_port * from gs_port_alloc() instead of assigning ports[port_num].port early.
> - Simplify error handling in gserial_alloc_line_no_console() on registration failure.
> - Update commit message to explain deferred port publication ordering and its protection of saved termios.
> - Correct commit message to refer to the portmaster mutex (ports[port_num].lock) rather than the port lock.
> - Clarify in commit message that port freeing is triggered by configfs rmdir reaching acm_free_instance() and gserial_free_line().
> - Include relevant KASAN report traces in commit message.
> https://lore.kernel.org/all/4226681d-e7e2-4ef8-92a8-4374c06132db@mail.kernel.org/T/
> 
> v4:
> - Clarified in the commit message and comments that open_close_failures accounting is aggregate across the port rather than paired with individual files
> - Cleared gs_tty_driver->ports[port_num] in gs_port_destruct()
> https://lore.kernel.org/all/e53f1fc8-ddd7-4dbf-be17-696c5c36b68a@mail.kernel.org/T/
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
> index cdd1dfc66..aaad06fa5 100644
> --- a/drivers/usb/gadget/function/u_serial.c
> +++ b/drivers/usb/gadget/function/u_serial.c
> @@ -70,10 +70,28 @@
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
> + *   - Retiring or device registration in progress: !port &&  reserved
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
> @@ -128,6 +146,7 @@ struct gs_port {
>  	wait_queue_head_t	close_wait;
>  	bool			suspended;	/* port suspended */
>  	bool			start_delayed;	/* delay start when suspended */
> +	unsigned int		open_close_failures; /* protected by tty_lock */
>  	struct async_icount	icount;
>  
>  	/* REVISIT this state ... */
> @@ -135,8 +154,9 @@ struct gs_port {
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
> @@ -603,22 +623,63 @@ static int gserial_wakeup_host(struct gserial *gser)
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
> @@ -638,7 +699,7 @@ static int gs_open(struct tty_struct *tty, struct file *file)
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
> @@ -1203,14 +1277,41 @@ static void gs_console_exit(struct gs_port *port)
>  
>  #endif
>  
> -static int
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
> +static struct gs_port *
>  gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
>  {
>  	struct gs_port	*port;
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
> @@ -1235,10 +1337,13 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
>  	port->port_num = port_num;
>  	port->port_line_coding = *coding;
>  
> -	ports[port_num].port = port;
> +	ports[port_num].reserved = true;
> +	mutex_unlock(&ports[port_num].lock);
> +	return port;
> +
>  out:
>  	mutex_unlock(&ports[port_num].lock);
> -	return ret;
> +	return ERR_PTR(ret);
>  }
>  
>  static int gs_closed(struct gs_port *port)
> @@ -1258,8 +1363,7 @@ static void gserial_free_port(struct gs_port *port)
>  	/* wait for old opens to finish */
>  	wait_event(port->close_wait, gs_closed(port));
>  	WARN_ON(port->port_usb != NULL);
> -	tty_port_destroy(&port->port);
> -	kfree(port);
> +	tty_port_put(&port->port);
>  }
>  
>  void gserial_free_line(unsigned char port_num)
> @@ -1276,15 +1380,15 @@ void gserial_free_line(unsigned char port_num)
>  	ports[port_num].port = NULL;
>  	mutex_unlock(&ports[port_num].lock);
>  
> -	gserial_free_port(port);
>  	tty_unregister_device(gs_tty_driver, port_num);
> +	gserial_free_port(port);
>  }
>  EXPORT_SYMBOL_GPL(gserial_free_line);
>  
>  int gserial_alloc_line_no_console(unsigned char *line_num)
>  {
>  	struct usb_cdc_line_coding	coding;
> -	struct gs_port			*port;
> +	struct gs_port			*port = ERR_PTR(-EBUSY);
>  	struct device			*tty_dev;
>  	int				ret;
>  	int				port_num;
> @@ -1295,19 +1399,20 @@ int gserial_alloc_line_no_console(unsigned char *line_num)
>  	coding.bDataBits = USB_CDC_1_STOP_BITS;
>  
>  	for (port_num = 0; port_num < MAX_U_SERIAL_PORTS; port_num++) {
> -		ret = gs_port_alloc(port_num, &coding);
> -		if (ret == -EBUSY)
> -			continue;
> -		if (ret)
> +		port = gs_port_alloc(port_num, &coding);
> +		if (IS_ERR(port)) {
> +			ret = PTR_ERR(port);
> +			if (ret == -EBUSY)
> +				continue;
>  			return ret;
> +		}
>  		break;
>  	}
> -	if (ret)
> -		return ret;
> +	if (IS_ERR(port))
> +		return PTR_ERR(port);
>  
>  	/* ... and sysfs class devices, so mdev/udev make /dev/ttyGS* */
>  
> -	port = ports[port_num].port;
>  	tty_dev = tty_port_register_device(&port->port,
>  			gs_tty_driver, port_num, NULL);
>  	if (IS_ERR(tty_dev)) {
> @@ -1315,15 +1420,16 @@ int gserial_alloc_line_no_console(unsigned char *line_num)
>  				__func__, port_num, PTR_ERR(tty_dev));
>  
>  		ret = PTR_ERR(tty_dev);
> -		mutex_lock(&ports[port_num].lock);
> -		ports[port_num].port = NULL;
> -		mutex_unlock(&ports[port_num].lock);
> -		gserial_free_port(port);
> -		goto err;
> +		tty_port_put(&port->port);
> +		return ret;
>  	}
> +
> +	mutex_lock(&ports[port_num].lock);
> +	ports[port_num].port = port;
> +	mutex_unlock(&ports[port_num].lock);
> +
>  	*line_num = port_num;
> -err:
> -	return ret;
> +	return 0;
>  }
>  EXPORT_SYMBOL_GPL(gserial_alloc_line_no_console);
>  
> 
> 
> base-commit: df2908090cda368b01ff43709f51890076c56157
#syz upstream

-- 
Krystian Kaniewski
