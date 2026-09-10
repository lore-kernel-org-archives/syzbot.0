Received: from mail-ed1-f44.google.com (mail-ed1-f44.google.com [209.85.208.44])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35E763C1D73
	for <syzbot@lists.linux.dev>; Thu, 10 Sep 2026 10:20:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.44
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035661; cv=none; b=upGEIzSdTPpU2mad4owZ/ekWLUOvqXG2mrPEIUWRZZPK9g8tYOV3q/eBtaQ/AzP0fungwxIYohJbZ+Hqzs+U/fRQZK1qM4qSNdTweUkI7qYrjTExRBf6SOkXI2vyHqr454z2gESR79lMqOORvWiNyjsWKV7GcafO3NpUJmpVgmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035661; c=relaxed/simple;
	bh=RNivwS8k2Laj4rC8Lf4NGRwEkvI2GsbruUKFh6Bsw3Q=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oPmvDZHRfe0TKRDuwNKzpQT8QWL22ZW5hqhsBdwJYUFCp9fJoq1iGUrTo4FkAhgFetWYEleTTOqIFj9rnPnAdRjQ++iZn9ds38ZyEcNw1xXfHxlPugwY7L18Okvu/+dHyPI5bNpq11M0fn2N7Cs4im8PBrq9pN9chuhZ+8r2TMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B4kShzH1; arc=none smtp.client-ip=209.85.208.44
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B4kShzH1"
Received: by mail-ed1-f44.google.com with SMTP id 4fb4d7f45d1cf-6a0de062db5so10412948a12.1
        for <syzbot@lists.linux.dev>; Thu, 10 Sep 2026 03:20:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789035657; x=1789640457; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=8ZmRYazU6drnQfU3oRi9kDsGUoB0ApeoDQw3/y2+6fg=;
        b=B4kShzH1oXBWXzNzGfNDcVM8hW7YmdBvb9lvSPeDNS8M7jVIWsYA2YiLfFkmFj7ETz
         L5G1WcoqyI13VDqhMI5FgdvGN7qsk7h/bfLx1lEoTVx6RHKwR8QjYSgwTrYeXyJzjwDg
         WG/cRHZBJm+T4oqpE3ZVpdRHtEocvXzf6EgUNTPwnN6qixgIBSk6uEhyTPALesOzuWAb
         rO+/sutDfi3ioVvFT7X2noC34RJdLRSZJdA1PVDw40V6pgI1Ezj/oW7VuB0gmQxSBqNx
         AXgHI/1gXmFyeM2v26+MOUMcySy2IAZZzkurCH4Zf2W5jjW1H0hNwtDxqUK7yUb4PbPU
         oOpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789035657; x=1789640457;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=8ZmRYazU6drnQfU3oRi9kDsGUoB0ApeoDQw3/y2+6fg=;
        b=aIJQHjVNHvei8yX52/xDOg0G+MDRTLDTSl8cN+HVZQFmqE6ek/OywWD5be1lwvbAt/
         tQz2mWvtzMlFb0ifIHQUZuGtd5/yQv8PeusKsa1rgoudlkK/k/UhMAN4IjiosEOJ/Aib
         EMVfCq0j+Pin5KZXbEH52fzNV6bo7VoJeHuEeb2MubmycKfVYgKfIl4+75QMjVvwitRW
         LDd4nL+37E/08Tlc/Wwkji0e7AiXcXWclzbUsF9JQ22n9+S8EuIdPvMrXto013/2k1nu
         KAb7FfHCxXTCj9xZZECep5HNDA/2b4d0F+UvXMcVJoqVQ7Qwwrk8Tk1F4Vu2ukmVTquC
         UhpA==
X-Gm-Message-State: AFuF++m00gtW6VCrDTg1i7UQsHRGC1eKyNNhj6kZ9psyJ/WB2B/5Hozg
	RyCTKtjDbam0f28+fIPeDtMigTSCjtdtVh8Y4+T5IC368rMC0aMhjTLG
X-Gm-Gg: AYBFou1duO8gd0X8nOdS568cXbn64aawabjZxmIMeLHhH6ugzIjpGQip1CB8y8oQZR/
	3KRCmecZk7kaJbLN48Ncsj16mscUzZwO/aYy9GRvjPsUMMPdozXxeX1BAva8WpWxyTyFveBE20f
	+PWLQqrFIoesH3T1arSCU/Lb3qAXiKgLfXXjuupy8mVpUn1xcst1sNFEubFZCYAtaw6AG4k1LDr
	UVY6wONRN3XagBm8t0y4o90D8jSgdd28RPjOf5fWW2sqa3IwAx+ysjNzux93ucKwuZ966T9pbUA
	e0PsYdkyrePZ41FNQr+SYEscfP7xZo/bnTVZkGprej7yeF4REYFuNSW8K0oinPm5uAvvHI1AMPP
	cqQGNYDPxGV/cYiJo3gDpJjPEvhOOGlZQQ5ESfpGEbWnN+509dV7GRFq0Vc7xUy7eigOHYyHJmm
	qxf2V0uvDTaky4edJOblqcTLXIAyHftPoI9d0/NTqVTkV8F38gV5a18+eaG2qjnCE8VhjtgwoWE
	YYH1vV74SgsIR3hXC6HQhjhaN2A/T5IK9egh4SkXR9ncCoCQ2pnZ2DoPzlMQcM2cQ8I953zfIF1
	M8BBiW/EHPbMp9XiQKolrEEm8agj31vgx+9TRlMdk7UDQieQYq8eAkBXsZZ0kuDnkM9bFes+Jau
	9hqRVy4KSYV2L5xy+vXpy9paRWI+7b8PvssA2Cykth28E
X-Received: by 2002:a05:6402:3882:b0:6a9:a5e7:f8be with SMTP id 4fb4d7f45d1cf-6a9a5e7fdd5mr1241040a12.5.1789035656627;
        Thu, 10 Sep 2026 03:20:56 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a9939349dcsm2190296a12.1.2026.09.10.03.20.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 03:20:56 -0700 (PDT)
Message-ID: <64df2b77-52a4-4c1e-a40f-2abebba5b080@gmail.com>
Date: Thu, 10 Sep 2026 12:20:55 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] usb: gadget: u_serial: Fix use-after-free in
 release_tty
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <acde99b9-2954-43ab-8403-6ca10699472d@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <acde99b9-2954-43ab-8403-6ca10699472d@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Keep the install-to-cleanup `tty_port` reference, the matching cleanup 
put, destructor-based final release, and the existing report, fix, 
discussion, and assistance tags. Apply all corrections below to complete 
the lifetime fix.

Bind one `tty_struct` for its installed lifetime to the exact `gs_port` 
selected during install. In `gs_install()`, hold the indexed `ports[]` 
mutex while selecting the public port, acquiring its `tty_port` 
reference, calling `tty_port_install()`, and assigning that port to 
`tty->driver_data`. Drop the acquired reference if installation fails. 
In `gs_open()`, use only `tty->driver_data`, reject a missing object 
with `-ENODEV`, and under the same indexed mutex reject the open unless 
the public slot still contains that exact object. Do not perform a fresh 
indexed lookup or overwrite `driver_data` during open.

Account explicitly for TTY core calling `.close` after a failed driver 
`.open`. Add a per-port failed-open counter protected by the TTY lock. 
Increment it for an open failure that did not increment the gadget 
serial open count. At the start of `gs_close()`, consume a pending 
failed-open entry and return without changing any successful open count. 
This must also handle a failed reopen while another file keeps the 
successful count positive. After that check, restore the original 
`port->port.count != 1` and `raced_with_open` handling for successful 
opens, including the zero-count warning. Do not retain the silent 
zero-count exits introduced by the current patch.

Prevent replacement registration from reusing a minor until old TTY 
cleanup is complete. Add reservation state beside each public `ports[]` 
pointer and protect both fields with the existing indexed mutex. Model 
the slot as free when no port is present and the minor is not reserved, 
published when both are set, and retiring when the public pointer is 
clear but the minor remains reserved. Make allocation test the 
reservation, set it when publishing a new port, and return `-EBUSY` 
while a prior generation is retiring.

Release that reservation only from the final `tty_port` destructor. 
Under the indexed mutex, warn and clear the slot if a public port 
unexpectedly remains, warn if the minor is not reserved, clear the 
reservation, then free the FIFO and the port. On device-registration 
failure, clear only the public pointer and drop the owner reference so 
the destructor releases the reservation. During normal line removal, 
clear public availability first, call `tty_unregister_device()` while 
retaining the owner reference, and drop that owner reference only after 
unregister completes. This ordering must prevent 
`tty_register_device_attr()` from freeing `tty_driver.termios[index]` 
while old release code is still writing it in `tty_save_termios()`.

Update the lifecycle comments to match the resulting implementation. 
State that `tty->driver_data` refers to `gs_port` from install through 
cleanup, while `gs_port->port.tty` exists only while open. Document the 
TTY-lock protection and purpose of the failed-open counter, the three 
valid public-slot and reservation states, the mutex ownership of both 
slot fields, the install-to-cleanup pin, and the reason the owner 
reference is retained through device unregister. Remove the stale 
wording that describes `driver_data` as `gserial` or says both TTY links 
exist only while open.

Use the subject `usb: gadget: u_serial: pin ports while TTYs are 
installed`. Update the commit message to explain both uncovered lifetime 
intervals, the installed-object identity requirement, failed-open close 
pairing, and delayed minor reuse protecting saved termios. Preserve 
ordinary open, I/O, close, and termios persistence behavior. Do not add 
a generic TTY-core locking change, do not use 
`TTY_DRIVER_RESET_TERMIOS`, and do not include unrelated refactoring.

On 9/8/2026 2:00 PM, syzbot wrote:
> A slab-use-after-free occurs in release_tty() when closing a USB serial
> port while the gadget is concurrently being unbound or destroyed. When a
> user closes /dev/ttyGS*, tty_release() invokes gs_close(), which decrements
> port->port.count to 0 and wakes up port->close_wait. Concurrently,
> gserial_free_port() (invoked during gadget unbind/rmdir) wakes up from
> wait_event(port->close_wait, gs_closed(port)) and frees the gs_port
> structure with tty_port_destroy() and kfree(). After gs_close() completes,
> tty_release() continues execution and calls release_tty(), which accesses
> the already freed gs_port through tty->port->itty = NULL.
>
> BUG: KASAN: slab-use-after-free in release_tty+0x371/0x570
> drivers/tty/tty_io.c:1557
> Write of size 8 at addr ffff8881903f2128 by task syz-executor600/5845
>
> Call Trace:
>   <TASK>
>   release_tty+0x371/0x570 drivers/tty/tty_io.c:1557
>   tty_release_struct+0xb8/0xd0 drivers/tty/tty_io.c:1665
>   tty_release+0xc62/0x1670 drivers/tty/tty_io.c:1825
>   __fput+0x418/0xa50 fs/file_table.c:512
>   fput_close_sync+0x11f/0x240 fs/file_table.c:617
>   __x64_sys_close+0x7e/0x110 fs/open.c:1545
>   do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   </TASK>
>
> Allocated by task 5843:
>   __kmalloc_cache_noprof+0x321/0x600 mm/slub.c:5563
>   gs_port_alloc drivers/usb/gadget/function/u_serial.c:1218 [inline]
>   gserial_alloc_line_no_console+0x232/0x6e0
>   drivers/usb/gadget/function/u_serial.c:1298
>   gserial_alloc_line+0x18/0x90 drivers/usb/gadget/function/u_serial.c:1332
>   acm_alloc_instance+0xc7/0x140 drivers/usb/gadget/function/f_acm.c:891
>   usb_get_function_instance+0xe3/0x2f0 drivers/usb/gadget/functions.c:44
>   function_make+0x127/0x360 drivers/usb/gadget/configfs.c:626
>   configfs_mkdir+0x4f6/0x9e0 fs/configfs/dir.c:1360
>   vfs_mkdir+0x40c/0x620 fs/namei.c:5410
>
> Freed by task 5843:
>   kfree+0x1c5/0x650 mm/slub.c:6792
>   gserial_free_port+0x248/0x2c0 drivers/usb/gadget/function/u_serial.c:1262
>   gserial_free_line+0xc0/0x1f0 drivers/usb/gadget/function/u_serial.c:1279
>   acm_free_instance+0x39/0x60 drivers/usb/gadget/function/f_acm.c:875
>   usb_put_function_instance+0x95/0xc0 drivers/usb/gadget/functions.c:77
>   config_item_release+0x13a/0x2d0 fs/configfs/item.c:137
>   configfs_rmdir+0x885/0x950 fs/configfs/dir.c:1571
>   vfs_rmdir+0x3e6/0x6a0 fs/namei.c:5515
>
> Fix this by managing the lifetime of struct gs_port through standard
> tty_port reference counting:
> - Implement .install (gs_install) to acquire a port reference with
> tty_port_get(), attach the port via tty_port_install(), and initialize
> tty->driver_data.
> - Implement .cleanup (gs_cleanup) to drop the tty_struct's reference with
> tty_port_put().
> - Implement the .destruct port operation (gs_port_destruct) to free the
> write FIFO buffer and kfree() the gs_port structure once all references
> have been dropped.
> - In gserial_free_port(), replace the direct tty_port_destroy() and kfree()
> calls with tty_port_put().
> - In gs_close(), check if port is NULL or if port->port.count is 0 (which
> may occur if open failed) to prevent NULL pointer dereferences or spurious
> warnings.
>
> Fixes: 19b10a8828a6 ("usb: gadget: allocate & giveback serial ports instead hard code them")
> Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+fe63e4d633540f230624@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=fe63e4d633540f230624
> Link: https://syzkaller.appspot.com/ai_job?id=b41b38ff-60c3-4626-adff-58b24c0a4cbc
> To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
> To: <linux-usb@vger.kernel.org>
> To: "Sebastian Andrzej Siewior" <bigeasy@linutronix.de>
> Cc: "Ai Chao" <aichao@kylinos.cn>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/drivers/usb/gadget/function/u_serial.c b/drivers/usb/gadget/function/u_serial.c
> index cdd1dfc66..592bb9504 100644
> --- a/drivers/usb/gadget/function/u_serial.c
> +++ b/drivers/usb/gadget/function/u_serial.c
> @@ -603,6 +603,41 @@ static int gserial_wakeup_host(struct gserial *gser)
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
> +	mutex_unlock(&ports[tty->index].lock);
> +
> +	if (!tport)
> +		return -ENODEV;
> +
> +	ret = tty_port_install(tport, driver, tty);
> +	if (ret) {
> +		tty_port_put(tport);
> +		return ret;
> +	}
> +
> +	tty->driver_data = port;
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
>    * gs_open sets up the link between a gs_port and its associated TTY.
>    * That link is broken *only* by TTY close(), and all driver methods
> @@ -695,14 +730,16 @@ static void gs_close(struct tty_struct *tty, struct file *file)
>   	struct gs_port *port = tty->driver_data;
>   	struct gserial	*gser;
>   
> +	if (!port)
> +		return;
> +
>   	spin_lock_irq(&port->port_lock);
>   
> -	if (port->port.count != 1) {
> -raced_with_open:
> -		if (port->port.count == 0)
> -			WARN_ON(1);
> -		else
> -			--port->port.count;
> +	if (port->port.count == 0)
> +		goto exit;
> +
> +	if (port->port.count > 1) {
> +		--port->port.count;
>   		goto exit;
>   	}
>   
> @@ -722,8 +759,11 @@ static void gs_close(struct tty_struct *tty, struct file *file)
>   					GS_CLOSE_TIMEOUT * HZ);
>   		spin_lock_irq(&port->port_lock);
>   
> -		if (port->port.count != 1)
> -			goto raced_with_open;
> +		if (port->port.count != 1) {
> +			if (port->port.count > 1)
> +				--port->port.count;
> +			goto exit;
> +		}
>   
>   		gser = port->port_usb;
>   	}
> @@ -909,8 +949,10 @@ static int gs_get_icount(struct tty_struct *tty,
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
> @@ -1203,6 +1245,18 @@ static void gs_console_exit(struct gs_port *port)
>   
>   #endif
>   
> +static void gs_port_destruct(struct tty_port *tport)
> +{
> +	struct gs_port *port = container_of(tport, struct gs_port, port);
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
> @@ -1222,6 +1276,7 @@ gs_port_alloc(unsigned port_num, struct usb_cdc_line_coding *coding)
>   	}
>   
>   	tty_port_init(&port->port);
> +	port->port.ops = &gs_port_ops;
>   	spin_lock_init(&port->port_lock);
>   	init_waitqueue_head(&port->drain_wait);
>   	init_waitqueue_head(&port->close_wait);
> @@ -1258,8 +1313,7 @@ static void gserial_free_port(struct gs_port *port)
>   	/* wait for old opens to finish */
>   	wait_event(port->close_wait, gs_closed(port));
>   	WARN_ON(port->port_usb != NULL);
> -	tty_port_destroy(&port->port);
> -	kfree(port);
> +	tty_port_put(&port->port);
>   }
>   
>   void gserial_free_line(unsigned char port_num)
>
>
> base-commit: df2908090cda368b01ff43709f51890076c56157
