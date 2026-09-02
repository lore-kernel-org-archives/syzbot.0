Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 491B23EE1C5
	for <syzbot@lists.linux.dev>; Wed,  2 Sep 2026 08:42:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788338576; cv=none; b=OaoawD5j2g4X+KrrVhbhnSdEsZVSYZ5WX3lMIjbVGNec/gxRV51GlSoe6KrQu8dpfvYRuXlONzHkld5QfXJlGEE1Hl3zROfezM8W28MZzo2aHq0xmjnGA8PX1EY1W6aPXZp+hpFJ6djE2r8bYoEG3n2dtQuGqSBIG3c4pTtHpQ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788338576; c=relaxed/simple;
	bh=IjIKHMccm8GrBjALwt5MmYqDVrJ1pabKzJPTt35AWBY=;
	h=Subject:From:To:Cc:Date:Message-ID:In-Reply-To:References:
	 Content-Type:MIME-Version; b=S8/ReuUTRMc1jIjzexpPRS6Wtky0n+1Y7z9gQKKwXWL/TJXIV8Yew1o2edas7eiQJ/IxUXRnsWOxK75S2DIM6BM8v0bvrfAZTWWMEKDUP8Vf1mLRdZgrbvtyPLmzL+HKODFA+6kK+m4Zhe8KT63NTxZu7kzLgE2NbTc6ecvAgX4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WmHgYsen; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WmHgYsen"
Received: by smtp.kernel.org (Postfix)
	id 068C21F00A3D; Wed,  2 Sep 2026 08:42:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 450581F00A3A;
	Wed,  2 Sep 2026 08:42:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1788338572;
	bh=kuzZ14B+FDuCbocvfoHL0MpjXRZgZHpI8//4nffdUFs=;
	h=Subject:From:To:Cc:Date:In-Reply-To:References;
	b=WmHgYsenldr0VOyDiE1eOikyxudRKJbTMm58pAhs2D77krpMpZqdZiFoFXjk0/LX1
	 CT+x0tEGNQawPahcmFpn8RmqMZqSN5cgmBBuEcngQxCTNZJME3KTds5p0ZNqU9NFrW
	 xlOH566QnkRmDsRe5WEGF1ec4NRz/rMYzYVaMOvGMBFOqHFlhOPSjFldRAlit/Vjsc
	 JDU61f2q9lxdMwCjiWWBWbvy/XRkIdWiZXdQvAHCHrLxWPg21ZdNmSqRD8wsjgZFYr
	 zUU9En13dQXt8SFpU/jtzsO/5p30qbNRiZJ25FRXn/sanvsSYKp+k39kxq2BHx9t5+
	 tNsuJCYzxaZJA==
Subject:
 Re: usb: atm: cxacru: fix NULL pointer dereference on uninitialized atm_dev
From: netdev-bot+sashiko@kernel.org
To: syzbot@kernel.org
Cc: syzkaller-bugs@googlegroups.com, jie.wang@intel.com, 3chas3@gmail.com,
 accessrunner-general@lists.sourceforge.net, gregkh@linuxfoundation.org,
 linux-atm-general@lists.sourceforge.net, linux-usb@vger.kernel.org,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
 kuba@kernel.org
Date: Wed, 02 Sep 2026 08:42:51 +0000
Message-ID: <178833857175.3394541.4513055242648047225@kernel.org>
In-Reply-To: <f3ef0a67-79d7-47da-be6e-7e82d92e68fe@mail.kernel.org>
References: <f3ef0a67-79d7-47da-be6e-7e82d92e68fe@mail.kernel.org>
X-sashiko-severity: High
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0

Thank you for your contribution! Sashiko AI review found 1 potential
issue(s) to consider:

Critical: 0 · High: 1 · Medium: 0 · Low: 0

- [High] Incomplete fix: the new `instance->usbatm->atm_dev == NULL`
  guards in adsl_state_store() (drivers/usb/atm/cxacru.c:350) and…

--

usb: atm: cxacru: fix NULL pointer dereference on uninitialized atm_dev

The commit adds a NULL test on instance->usbatm->atm_dev at the entry of
adsl_state_store() and adsl_config_store() in drivers/usb/atm/cxacru.c, so
that a sysfs write arriving before usbatm_do_heavy_init() has registered the
ATM device returns -ENODEV instead of dereferencing atm_dev through
atm_err().

Closes: https://syzkaller.appspot.com/bug?extid=9b195c4f412ea5c4e56a
Link: https://syzkaller.appspot.com/ai_job?id=b6352d63-d03a-4e87-92a4-b334c3ebcf97

> diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
> index 429ac20a8999f..dee15f7b70bf6 100644
> --- a/drivers/usb/atm/cxacru.c
> +++ b/drivers/usb/atm/cxacru.c
> @@ -347,7 +347,7 @@ static ssize_t adsl_state_store(struct device *dev,
>  		return -EINVAL;
>  	ret = 0;
>  
> -	if (instance == NULL)
> +	if (instance == NULL || instance->usbatm->atm_dev == NULL)
>  		return -ENODEV;
>  
>  	if (mutex_lock_interruptible(&instance->adsl_state_serialize))

[Severity: High]
Is this check taken early enough to still be valid at the point where
atm_dev is actually dereferenced?

The test reads instance->usbatm->atm_dev once at handler entry, but the
dereference happens later in atm_err(), which expands through atm_printk()
in drivers/usb/atm/usbatm.h:

  #define atm_printk(level, instance, format, arg...)	\
	printk(level "ATM dev %d: " format ,		\
	(instance)->atm_dev->number , ## arg)

Between the check and that dereference the handler sleeps in
mutex_lock_interruptible(&instance->adsl_state_serialize), then in
cxacru_cm() (which takes cm_serialize and performs a USB control transfer),
and on the "restart" path also in msleep(1500).

Meanwhile usbatm_atm_init() in drivers/usb/atm/usbatm.c publishes atm_dev
before calling atm_start, and clears plus frees it if atm_start fails:

  instance->atm_dev = atm_dev;
  ...
  if (instance->driver->atm_start && ((ret = instance->driver->atm_start(instance, atm_dev)) < 0)) {
	atm_err(instance, "%s: atm_start failed: %d!\n", __func__, ret);
	goto fail;
  }
  ...
 fail:
	instance->atm_dev = NULL;
	atm_dev_deregister(atm_dev); /* usbatm_atm_dev_close will eventually be called */

So a non-NULL atm_dev does not mean initialization completed, and the only
failing leg of cxacru_atm_start() runs before it takes the mutex that
adsl_state_store() uses:

  ret = cxacru_cm(instance, CM_REQUEST_CARD_GET_MAC_ADDRESS, NULL, 0,
		  atm_dev->esi, sizeof(atm_dev->esi));
  if (ret < 0) {
	atm_err(usbatm_instance, "cxacru_atm_start: CARD_GET_MAC_ADDRESS returned %d\n", ret);
	return ret;
  }

  /* start ADSL */
  mutex_lock(&instance->adsl_state_serialize);

With that ordering, can the exact oops quoted in the commit message still
happen?  A writer passes the new check while atm_dev is published but
atm_start has not finished, sleeps in cxacru_cm(), the heavy-init kthread
takes the fail path above, and the writer then evaluates:

  atm_err(instance->usbatm, "change adsl state:"
	  " CHIP_ADSL_LINE_STOP returned %d\n", ret);

which is the reported crash site.  The CHIP_ADSL_LINE_START error leg is
identical.  If the compiler had already loaded the old pointer, is this a
use-after-free instead, given atm_dev_deregister() drops the last reference?

There is a second window of the same shape in usbatm_usb_disconnect():

  if (instance->atm_dev) {
	atm_dev_deregister(instance->atm_dev);
	instance->atm_dev = NULL;
  }

Would it be more robust to drop the atm_dev dereference from these paths
altogether, for example by using usb_err()/dev_err() on
instance->usb_intf->dev, which stays valid for the duration of the sysfs
write?  Alternatively, re-validating and latching atm_dev under a lock that
usbatm_atm_init()'s failure path also takes, holding a reference on the
atm_dev, or publishing instance->atm_dev only after initialization has fully
succeeded would close the window rather than narrow it.

Related to the same window: adsl_state_store() calls cxacru_poll_status()
after dropping adsl_state_serialize, and that function caches the pointer
with no check of its own:

  struct usbatm_data *usbatm = instance->usbatm;
  struct atm_dev *atm_dev = usbatm->atm_dev;

and then uses it via atm_warn(), atm_dev->link_rate and
atm_dev_signal_change().  Can that path fault too once atm_dev has been
cleared behind the writer's back?

> @@ -444,7 +444,7 @@ static ssize_t adsl_config_store(struct device *dev,
>  	if (!capable(CAP_NET_ADMIN))
>  		return -EACCES;
>  
> -	if (instance == NULL)
> +	if (instance == NULL || instance->usbatm->atm_dev == NULL)
>  		return -ENODEV;
>  
>  	pos = 0;

[Severity: High]
The same check-then-use concern applies here, and this handler holds no
mutex at all before the sleeping cxacru_cm() transfers inside the
while (pos < len) loop.  Both the failure and the success legs dereference
atm_dev after that sleep:

  ret = cxacru_cm(instance, CM_REQUEST_CARD_DATA_SET,
		  (u8 *) data, 4 + num * 8, NULL, 0);
  if (ret < 0) {
	atm_err(instance->usbatm,
		"set card data returned %d\n", ret);
	return -EIO;
  }
  ...
  atm_info(instance->usbatm, "config%s\n", log);

Since atm_info() expands to the same (instance)->atm_dev->number, does this
mean no command failure is even required to hit the dereference here once
usbatm_atm_init() or usbatm_usb_disconnect() has cleared atm_dev?

Would it make sense to also drop the atm_err()/atm_info() uses in this
function in favour of usb_err()/usb_info() on the USB interface?

-- 
Sashiko AI review · https://netdev-ai.bots.linux.dev/sashiko/#/patchset/f3ef0a67-79d7-47da-be6e-7e82d92e68fe%40mail.kernel.org
