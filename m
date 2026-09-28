Received: from mail-ej2-f43.google.com (mail-ej2-f43.google.com [74.125.228.171])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FA394E9C35
	for <syzbot@lists.linux.dev>; Mon, 28 Sep 2026 16:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.228.171
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790611960; cv=none; b=P6DBoJR2ihBnxdoyJoWtZi54GX9HeBdlnvgsVMkCZZYmfRT1lAptb3u8uqawieDZESvJaRph0t8TZuTAPe6Az0SKS7KTEGgTSCtTqOQpEL9qAQZP3cexlBdnTclmwOY1tDfkCoLTTRQa8CVv/KNsvy5AiHiD9w4sJr1uGvioEgs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790611960; c=relaxed/simple;
	bh=BtG8IRG6JjsYpVby1E6EMoKHQsD3p4D93ieUDpHIIyg=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=RTvc7HFIsNGFLjHMgv6ib8A+wtt/dK3H9wCs7Y9Szm1c+2q/0SRuWaLyOTmiM67n6jlOr2AakzvS826pVWhIBd0LlAaoD4T6t4azThxyWHxrtrmr8cCQAO8mUzG9hz1MPISw8OS+bvVdCtqXbTdLdv9WT2vrqqyceXHKMRLutVc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=iMyiIu5a; arc=none smtp.client-ip=74.125.228.171
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="iMyiIu5a"
Received: by mail-ej2-f43.google.com with SMTP id a640c23a62f3a-c2af9270c53so295213166b.1
        for <syzbot@lists.linux.dev>; Mon, 28 Sep 2026 09:12:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1790611957; x=1791216757; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6u3v7oJPJkTqK6VDuIwDnKQjYQ1m49LqoM8yTJQ4Nr0=;
        b=iMyiIu5aH2PdcmS9sR/aCspP/KfGffNZhHTaAGBoQIAmRKKbUyexz4nE5QuFpo/om3
         HgFSSr88f75DmeiBPLDNt+7zDdHl7kMBVNwRN8l3H8+L+mPcdOsARnbZKVmGAQCFVo8v
         GIp8JNBUcl7sHwwcqvtU0D+QdAN31ad1aqx2teNtb6AsYoQ09ERATJmcfhqDSZEiyInK
         CB1/rWN3K7xY17mvqqZxlbu693P4B9C8EXGDOBNST0xt9TJMpFDjxU9rGCUerXkDOrV+
         jzkrapaRGbV/8DlmL5aUsgH5fHJnOP9uqWBB9q4+jwDNN/OtOO34I6w+YVj7354Gxzqd
         NFcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1790611957; x=1791216757;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6u3v7oJPJkTqK6VDuIwDnKQjYQ1m49LqoM8yTJQ4Nr0=;
        b=nhIoWuuY0mPJP6jGKLAYAxPgOqbRldF5uvVAkb/gzBw76tw+LvWpDxk4jx6s0vbfef
         wEmMDKX9F06MyQQc1d0uHVv5k8MV++9XIx7GEgPOc+95W8oiXtQsFidlwlW9/PkUjWmd
         vgAPt+t1mMNgxe04PIlvGfYpCEoKGoqG2o215I0pqJzKNxUn/ofSFYYVDWlfaYCkB4D9
         8VIP4aiqZATrR28yDFCYdd5g+A1m2psODbrDyBhoBOWtwD/brS7xACUj89U7dTUh/E/u
         FHN3wrecihQahecjHZNhSPlHcUVreh1uJHjGmGUxHU8nRNzW/BM+I7SgOptul9WYfpi6
         CdEA==
X-Gm-Message-State: AFuF++kQGtAGK9e7EAJKkraCJwv5kQmytPuShzdq23qF/scFwoMFKsYu
	GJTykn0aexpR6FMa9VoH1JMsMfSD04KdgEJTfeP1+gDg/x1FhbJF1XS0A+ag/XqB
X-Gm-Gg: AYBFou3dKJvEteMqy2Q5WiwawL09nKSM2d0nMUDi5CTGid/2h55rD6jeDWpSTiCKV8z
	ViZZ5o9FkyRKYcYTpv5GUgANgOUicnwoUB3jfeeoKdfeZ8TLDJOFSEOa2eCNts8gObxANS0e4A+
	vOIp8EpOoZi5yTiiV4suqnoKdPwR2HKTG+6P0+s9gB95wjHPzSp8SWw/uSYIry+ebaOvfEuYTes
	U0yOM9o65BAWZWqTTnf94rtTp7gFOrfmzdpdpgf2tLVBcdLw09+OK4sGei0R+Iy55BxYgf7j/6S
	dwItooKHDMWVFaM4Je0iGuM2P1HkSuQ8L2Fapg3yHKvTve8PNjNz/4drYfM99MuEft5I137r55T
	SHrdWxQ1dL2pd7cYEvFrpEn+MSsixQ1XLllH7fTwKMJk+GNfb5crPeZmHui+UkNxHvJwi9bi+jp
	NJX09aTPyEUyJA0Z5h7XReOJ0YQdob2XYRlZGbnElgLTYTqHByxqmXy6/OCNDjJ7bJYzkroWO0p
	eYpYL7YsLVx5Lso4FM2YnwDEHrPXkXT/XTS4jckvguJjwVIopn1sBENXyzsAEWcNRwLqek5pT0+
	1aS31zwOTs8XSecpXc22yQG9bfmUiyzCD0DnQ/mgc6AlV08nmWrQ9QQljX9E8JlweV7NHfgAl7S
	8eFhmGy8euWTPKs4Qd7BnEpR61Z7WRHS/Gg==
X-Received: by 2002:a17:907:94c7:b0:c2d:c17f:2053 with SMTP id a640c23a62f3a-c2dc17f4c94mr471379966b.24.1790611956426;
        Mon, 28 Sep 2026 09:12:36 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c2ae7587edesm497609666b.34.2026.09.28.09.12.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 28 Sep 2026 09:12:32 -0700 (PDT)
Message-ID: <9488306f-8b71-481a-966e-4da5bfbb25fa@gmail.com>
Date: Mon, 28 Sep 2026 18:12:25 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] usb: gadget: u_serial: pin ports while TTYs are
 installed
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <1e5c22f0-19bc-4c1f-9638-6ae619179e29@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <1e5c22f0-19bc-4c1f-9638-6ae619179e29@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/10/26 18:27, syzbot wrote:
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
> failed opens so the matching close called by the TTY core on failure exits
> cleanly without altering open counts. Finally, delay minor reuse to protect
> saved termios by keeping the slot reserved until port destruction completes
> and unregistering the device before dropping the driver's port reference.
> 
> Fixes: 19b10a8828a6 ("usb: gadget: allocate & giveback serial ports instead hard code them")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+fe63e4d633540f230624@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=fe63e4d633540f230624
> Link: https://syzkaller.appspot.com/ai_job?id=957ebad8-eaaa-4b1f-923f-1a8b49536793
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
> Cc: "Ai Chao" <aichao@kylinos.cn>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v3:
> - Clarify the lifecycle comment and slot invariant.
> - Shorten the commit message by removing the full call trace and condensing implementation details.
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
> index cdd1dfc66..305292f61 100644
> --- a/drivers/usb/gadget/function/u_serial.c
> +++ b/drivers/usb/gadget/function/u_serial.c
> @@ -60,20 +60,37 @@
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
> + * was not incremented, so the matching gs_close() called by the TTY core on
> + * open failure can consume it and exit without altering successful open counts.
> + * It is protected by tty_lock.
>   */
>  
>  /* RX and TX queues can buffer QUEUE_SIZE packets before they hit the
> @@ -128,6 +145,7 @@ struct gs_port {
>  	wait_queue_head_t	close_wait;
>  	bool			suspended;	/* port suspended */
>  	bool			start_delayed;	/* delay start when suspended */
> +	unsigned int		open_close_failures; /* protected by tty_lock */
>  	struct async_icount	icount;
>  
>  	/* REVISIT this state ... */
> @@ -135,8 +153,9 @@ struct gs_port {
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
> @@ -603,42 +622,81 @@ static int gserial_wakeup_host(struct gserial *gser)
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
> @@ -648,7 +706,6 @@ static int gs_open(struct tty_struct *tty, struct file *file)
>  	if (port->port.count++)
>  		goto exit_unlock_port;
>  
> -	tty->driver_data = port;
>  	port->port.tty = tty;
>  
>  	/* if connected, start the I/O stream */
> @@ -672,7 +729,11 @@ static int gs_open(struct tty_struct *tty, struct file *file)
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
> @@ -695,6 +756,14 @@ static void gs_close(struct tty_struct *tty, struct file *file)
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
> @@ -909,8 +978,10 @@ static int gs_get_icount(struct tty_struct *tty,
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
> @@ -1203,6 +1274,26 @@ static void gs_console_exit(struct gs_port *port)
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
> @@ -1210,7 +1301,12 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
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
> @@ -1222,6 +1318,7 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
>  	}
>  
>  	tty_port_init(&port->port);
> +	port->port.ops = &gs_port_ops;
>  	spin_lock_init(&port->port_lock);
>  	init_waitqueue_head(&port->drain_wait);
>  	init_waitqueue_head(&port->close_wait);
> @@ -1235,6 +1332,7 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
>  	port->port_num = port_num;
>  	port->port_line_coding = *coding;
>  
> +	ports[port_num].reserved = true;
>  	ports[port_num].port = port;
>  out:
>  	mutex_unlock(&ports[port_num].lock);
> @@ -1258,8 +1356,7 @@ static void gserial_free_port(struct gs_port *port)
>  	/* wait for old opens to finish */
>  	wait_event(port->close_wait, gs_closed(port));
>  	WARN_ON(port->port_usb != NULL);
> -	tty_port_destroy(&port->port);
> -	kfree(port);
> +	tty_port_put(&port->port);
>  }
>  
>  void gserial_free_line(unsigned char port_num)
> @@ -1276,8 +1373,8 @@ void gserial_free_line(unsigned char port_num)
>  	ports[port_num].port = NULL;
>  	mutex_unlock(&ports[port_num].lock);
>  
> -	gserial_free_port(port);
>  	tty_unregister_device(gs_tty_driver, port_num);
> +	gserial_free_port(port);
>  }
>  EXPORT_SYMBOL_GPL(gserial_free_line);
>  
> @@ -1318,7 +1415,7 @@ int gserial_alloc_line_no_console(unsigned char *line_num)
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
Please address only these two non-blocking details in the current patch.
Keep the existing port-lifetime design and ordinary open and close behavior.

Clear the raw `gs_tty_driver->ports[index]` entry before the old `gs_port`
is freed in `gs_port_destruct()`. The entry otherwise remains a dangling
pointer. No reachable post-free read was established in the reviewed TTY
paths, but clearing the slot would protect future readers. Keep the minor
reservation and device-unregister ordering unchanged.

Please also clarify the commit body and lifecycle comment around
`open_close_failures`. Credits are aggregate, not paired with individual
files. Another `gs_close()` can consume a failed open's credit before that
file's own close runs. Replace wording that implies a guaranteed
"matching close" with an accurate description of aggregate accounting.
Do not change the accounting code solely to make the wording per-file.


-- 
Krystian Kaniewski
