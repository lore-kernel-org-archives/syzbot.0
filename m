Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793981131;
	b=hlB8OVDmQ+VmSKTEjZGUdAOtYE8sX3KbP7BCYaliABjYs3T+wr1sY0WRSOEu+sCHUFnL
	 Bb+UAOSWJZWCIPsbAAmJ4va9AaM+swR4nNSYIKMKQpSF8a5V4VVyuHprY+cL7QjI8vmTV
	 ESE6Mrr3YlQ1+TDq93OBVQnf/lYs4NjtrkmmOuP68MhgJisvRAVKGVUCQ6Dy9x4p5n/5k
	 OztWT0drSXdkHKNgJFV67rVqp9sgFllhZJuD6lKszcx3SnVLaUJFSuYKpruo5P5ZPhVEX
	 MsM4wE15oLdmls/XTg9Nyiy65mBPUHjFxMnaEC7ymB7vh23HUY8s+pg6vsNLU71uVGA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793981131;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=+b+Oe0RXnjcemPe8VF9o8HAO/wIsyh8f2ovE/6/bmBA=;
	b=gKBrH8pavGynBEqOrBD6ZeJinblTW/F/krLZceXZAZc1k9ZQmb2+6o5/OR2bu2VO080X
	 0txeCRqB9x7msE7SD6tyyJJ2irO2HpKE2eiF3hvr172kaHtvmqKSfTTjgQiIwCVY3Qjzj
	 W3ikWsiUWxvmZHL+DJ2gcXagUp+UjkDUfUaLQo61Hf+0wf7rSuao0dZo51ED8z23MpbUo
	 7wJm1rVNrfly9nY0EVVB59NwOqR9KQge4iWiFvzB0FRcNMNigESYOIu1iDeLe2tYMLrOG
	 Ydh4+ENtJ88wIqUUQHqPi1PdJHqLu2PbZu1fDcXGqUWLcaPoWhY2grr2XRIVTSNQTVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kowWsOB1;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EA31606A326
	for <syzbot@lists.linux.dev>; Fri,  6 Nov 2026 16:05:31 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 3EA31606A326
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=kowWsOB1
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c4682977f9aso96475466b.1
        for <syzbot@lists.linux.dev>; Fri, 06 Nov 2026 08:05:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793981129; x=1794585929; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=+b+Oe0RXnjcemPe8VF9o8HAO/wIsyh8f2ovE/6/bmBA=;
        b=kowWsOB1OkzPFnCySYyq6Qr1deDjALcLdoTvFONGE2WkKiQ9BguwpJnu8nvj3XAQNj
         s1p+hxkkZVjQ6nQb+qhBVRFDodqf5GyKgSjNeqQYglceGoj8Domj3ScRiTA/kByc2oGo
         3ThFTqUq4+3in/F8aiiM5NcbJycxCB4i87Fe9doYhjaFfSKuNWoYmAJ28Ry5zIQoc+hT
         4PzuJx8aZUeYKHHOI95MxjjGayzO4sTMe4jprcIJlMx6o01tfNwYeO4vfqpFPMgL+lT8
         GQjLLL3VEkLUMG7up9omaI1+17SNaFRUqCYwyU3gSRFhpDxtrmI7GSXYiAjWEcsOZU7l
         PEGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793981129; x=1794585929;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=+b+Oe0RXnjcemPe8VF9o8HAO/wIsyh8f2ovE/6/bmBA=;
        b=cYWKiUCHVpi/qszRPNj9T065NlDGEHyDbKo5K3C+F7VrVIsNePlKqS+YnCHZrS4fkS
         3oRofF14ijWQcgoirDdqIv5zV5X+ujiIeYdgZAcu/ACBd6OMkbX2YwGuQNAvS9cGdApl
         5iHYRj+X1zlXlkcSdzdRKtv2LmCZ4J9LiPmEwr6FyZ+TlTXzS2HsSBfQrbLFkoSC2q5E
         L33LS03vRh+4jfn3u840h+qau021+MCpIo/W5QFoC0rZVVKFm/BNhyn9XqkXQ7rhj242
         Aji3tyuGqrSHf4gmneWBphZmUfqLqii5i6LE5JUlAZtI3grxM++WHzws4cFM8kepaszm
         rM5Q==
X-Forwarded-Encrypted: i=1; AKwUvByiwDAjw8NprttbLcJBCYdSAyGmxF/7a/HY+pcUsyfGdHFT6eXF/i29jq9xpwNSrLDacts7qtY=@lists.linux.dev
X-Gm-Message-State: APuU4Z9Z8ZOm6c5TFkRX3rBsLdd6VtlyZ/gvuhtzcPJ+nCIR2JgIYsGU
	wjoJVyLXNt4xV+8uftv7zySSe+qGVq2EoKdTqBTt2nUpaHf0wOhMf6UY
X-Gm-Gg: AYBFou1yC9iKA29XuaGI3G9jZ0PSbSpZA+PUpGTLKwZuLf4u446OsL5uOZoOfdD+soD
	KP+NV0oAbUFtCeZ+NoBgbuQGWfUXaUQDQ3IyaFVPGMmJ5pFlWJ6jy47LWi13F5BSJZr6iJy5PSn
	/JqsQjOHnwH4NM4JvgVb5VEwh7dS7UP2H4b3kwxJTwuQQhgOkurBSDcxoikWoya0MY2GKX/PFyE
	fiwK9mDzVJhm8SxOSSKMR7ayo0wxVPTNAd30cluYPbW1WhFpoqxViRbRKlh1DerApyCXXmlKNJw
	yh/G66o+DgJM8g+cDFRrKWa4ccRtdWZsf5mnut3MrYpyt9EsfYBbjBjvmzmsFP56eFpvJBceheW
	9W3lPRZr+JVRMiMZdE6tGs10iTzQkR+Cf2AoWtGOazdvUXa6G3tM4NsJnu2fiIStLLgDNp+I3nl
	SL41jTlDfVJBR4pt1MnKPtPEc02kp2Vosn8uks5DgaVHQT0/TC+NEK/8Vopj/BjdByHpOWHhMWD
	CtzDX4PJUsSESHzb9u1aXbBzRL3/3KQFxkMp8WbdIStwReUsdnc7HxW32G7xQIOZUdnb5M9GpFq
	tffON4JJDCcHbrtAtYncoLZQVVQXLWOK3dKx0kwj2Rdare8=
X-Received: by 2002:a17:906:9f89:b0:c46:a72:e0c3 with SMTP id a640c23a62f3a-c4d3546b3e5mr241281266b.16.1793981129265;
        Fri, 06 Nov 2026 08:05:29 -0800 (PST)
Received: from localhost ([188.146.174.10])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4d356c2a08sm90617266b.65.2026.11.06.08.05.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2026 08:05:28 -0800 (PST)
Date: Fri, 6 Nov 2026 17:05:27 +0100
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] media: az6007: Fix out-of-bounds access and mutex
 reinitialization
Message-ID: <r7xnglgo7i2qjsbr6twwkptxmqo4qvvavzq7zvjpzndvp7l5us@s36wx7xs7aan>
References: <baa09ccd-e29d-4434-bfd6-cebf6a9b8413@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <baa09ccd-e29d-4434-bfd6-cebf6a9b8413@mail.kernel.org>

Version 2 corrects the short USB reply check and the write-size guard raised
in the v1 review and keeps mutex initialization in probe, with no further
change requested to those code paths. The commit message and generated
metadata need correction, and repeated short replies need a kernel log-rate
check that may call for a change to the existing pr_info() message.

Required changes:
- Commit message: Lead with the selected mutex wait-list warning. Keep the
  separately found oversized read distinct. Describe the failed-power reset
  with a queued I2C waiter as observed on the base, without claiming that t=
he
  selected report proves that exact sequence. State that short USB replies
  now return -EIO and writes over 64 bytes fail before the state-buffer cop=
y.
- Metadata: Keep the mutex-history Fixes: tag for a2c35d346d9e and add the
  buffer-history tag for b19280cf2bee, or split the two fixes. Use an
  Assisted-by: line naming one LLM and only specialized tools actually used;
  omit it if that cannot be stated accurately. Drop the obsolete
  mchehab@redhat.com recipient while keeping the current media maintainer a=
nd
  linux-media and linux-kernel lists.
- Code, if needed, after test artifact check: Repeated short replies now re=
ach the existing pr_info()
  error message. If a kernel run shows a material log flood, rate-limit or
  aggregate that message in az6007_i2c_xfer().

Testing:
The original C reproducer triggered the selected list warning on the
historical kernel in 2 of 4 test VMs. A source-based sanitizer test passed
36 checks for v2's transfer boundaries, short replies, and failed-power
waiter path.

Syzbot flow request:
For the selected list warning, compare the original C reproducer on the
historical kernel before and after moving mutex initialization to probe,
using the same config. Measure kernel log volume and CPU cost when short USB
replies repeat, and check USB reply framing on physical or emulated hardware
as appropriate. State which setup was used.

Context:
The selected warning concerns the mutex waiter list, before the I2C transfer
body. A failed power command can leave warm false, and a later power call c=
an
reset the mutex while an I2C transfer waits. Initializing the mutex once in
probe removes that reset path. The oversized read is a separate fault.

Impact assessment:
The selected report shows corruption of the mutex waiter list. An oversized
read can access beyond st->data, and a short USB reply can copy old st->data
bytes into an I2C read. Version 2 guards the read paths and rejects oversiz=
ed
writes before the copy; probe-time initialization removes the observed
retry-time mutex reset.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Fri, Oct 30, 2026 at 02:01:50PM +0000, syzbot wrote:
> In az6007_i2c_xfer(), user-controlled I2C messages transferred via
> /dev/i2c-* (through i2c-dev) can specify lengths up to 8192 bytes. The
> driver uses a fixed 4096-byte bounce buffer, st->data, defined in struct
> az6007_device_state. The driver does not validate message lengths against
> sizeof(st->data) before copying data or issuing USB control transfers,
> leading to out-of-bounds buffer accesses.
>=20
> When userspace reads from an I2C device (such as via preadv() on
> /dev/i2c-*), i2cdev_read() calls i2c_master_recv() -> i2c_transfer() ->
> __i2c_transfer() -> az6007_i2c_xfer() with msgs[0].len matching the
> requested read size. In the single read branch, length is computed as
> msgs[i].len + 6. If msgs[i].len exceeds 4090 bytes, length exceeds
> sizeof(st->data). Furthermore, the return value of __az6007_read() was not
> validated before copying bytes from st->data[j + 5] into msgs[i].buf[j].
> When a large read request fails at the USB level, the copy loop still
> executes unconditionally. When j reaches 4091, j + 5 equals 4096, reading
> past the end of st->data and triggering a UBSAN array-index-out-of-bounds
> warning:
>=20
> UBSAN: array-index-out-of-bounds in
> drivers/media/usb/dvb-usb-v2/az6007.c:821:22
> index 4096 is out of range for type 'unsigned char[4096]'
> Call Trace:
>  <TASK>
>  dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
>  ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
>  __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
>  az6007_i2c_xfer+0x419/0xaa0 drivers/media/usb/dvb-usb-v2/az6007.c:821
>  __i2c_transfer+0x7bf/0x1fe0 drivers/i2c/i2c-core-base.c:-1
>  i2c_transfer+0x1cb/0x2d0 drivers/i2c/i2c-core-base.c:2350
>  i2c_transfer_buffer_flags+0x10d/0x1a0 drivers/i2c/i2c-core-base.c:2378
>  i2c_master_recv include/linux/i2c.h:79 [inline]
>  i2cdev_read+0x10d/0x250 drivers/i2c/i2c-dev.c:155
>  vfs_readv+0x57c/0x850 fs/read_write.c:1021
>  do_preadv fs/read_write.c:1133 [inline]
>  </TASK>
>=20
> Similar buffer overflow issues exist in the other transfer paths: the
> combined write+read branch lacked checks on msgs[i + 1].len < 1 and length
> > sizeof(st->data), while the write branch copied msgs[i].len - 1 bytes
> into st->data without verifying that the payload fit within the 64-byte
> maximum supported by __az6007_write(). In addition, the read loops access=
ed
> st->data[j + 5] without verifying that __az6007_read() returned at least 5
> + len bytes. Additionally, in __az6007_write(), the blen > 64 check was
> performed after dumping the payload to the kernel log under
> az6007_xfer_debug.
>=20
> Separately, the crash report indicates corruption of the mutex wait list
> before the I2C transfer starts, which is distinct from the out-of-bounds
> read buffer issue found during testing. On the base commit, it was observ=
ed
> that mutex_init(&state->mutex) was called inside az6007_power_ctrl() when
> !state->warm. If the initial power-on command failed, state->warm remained
> false, causing subsequent invocations of az6007_power_ctrl() to
> reinitialize state->mutex while the device was active. If another thread
> held or waited on the mutex during az6007_i2c_xfer(), reinitializing the
> mutex cleared the lock owner and wait list, triggering a
> DEBUG_LOCKS_WARN_ON warning on unlock. Note that this failed-power mutex
> reset was observed on the base commit rather than being confirmed as the
> exact reproduction sequence in the crash report.
>=20
> Fix these issues by:
> - Moving mutex initialization out of az6007_power_ctrl() into a newly
> introduced probe callback (az6007_probe) that initializes state->mutex on=
ce
> upon device probing.
> - Adding upper-bound checks against sizeof(st->data) in the single read a=
nd
> combined write+read paths of az6007_i2c_xfer(), checking length <=3D 64 in
> the write path, and verifying msgs[i + 1].len >=3D 1 in the combined path.
> - Checking that __az6007_read() returned at least 5 + len bytes before
> copying data from st->data to msgs[i].buf in the single read and combined
> paths.
> - Moving the blen > 64 check in __az6007_write() before the debug hex dum=
p.
>=20
> Fixes: a2c35d346d9e ("[media] az6007: Protect read/write calls with a mut=
ex")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+0192952caa411a3be209@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D0192952caa411a3be209
> Link: https://syzkaller.appspot.com/ai_job?id=3D33295084-b1e3-4d4b-b832-b=
8fd4f72f6ac
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
> Cc: <linux-kernel@vger.kernel.org>
>=20
> ---
> v2:
> - Require ret >=3D 5 + len instead of ret >=3D len in read paths before c=
opying from st->data.
> - Limit write transfers to 64 bytes instead of sizeof(st->data).
> - Clarify in commit description that the crash report indicates mutex wai=
t list corruption, distinct from the out-of-bounds read buffer issue, and t=
hat the failed-power mutex reset was observed on the base commit.
>=20
> v1:
> https://lore.kernel.org/all/98467e25-6e27-41d8-94d9-5367714ce9b0@mail.ker=
nel.org/T/
> ---
> diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dv=
b-usb-v2/az6007.c
> index 65ef045b7..783ec628f 100644
> --- a/drivers/media/usb/dvb-usb-v2/az6007.c
> +++ b/drivers/media/usb/dvb-usb-v2/az6007.c
> @@ -143,6 +143,12 @@ static int __az6007_write(struct usb_device *udev, u=
8 req, u16 value,
>  {
>  	int ret;
> =20
> +	if (blen > 64) {
> +		pr_err("az6007: tried to write %d bytes, but I2C max size is 64 bytes\=
n",
> +		       blen);
> +		return -EOPNOTSUPP;
> +	}
> +
>  	if (az6007_xfer_debug) {
>  		printk(KERN_DEBUG "az6007: OUT req: %02x, value: %04x, index: %04x\n",
>  		       req, value, index);
> @@ -150,12 +156,6 @@ static int __az6007_write(struct usb_device *udev, u=
8 req, u16 value,
>  				     DUMP_PREFIX_NONE, b, blen);
>  	}
> =20
> -	if (blen > 64) {
> -		pr_err("az6007: tried to write %d bytes, but I2C max size is 64 bytes\=
n",
> -		       blen);
> -		return -EOPNOTSUPP;
> -	}
> -
>  	ret =3D usb_control_msg(udev,
>  			      usb_sndctrlpipe(udev, 0),
>  			      req,
> @@ -694,8 +694,6 @@ static int az6007_power_ctrl(struct dvb_usb_device *d=
, int onoff)
>  	pr_debug("%s()\n", __func__);
> =20
>  	if (!state->warm) {
> -		mutex_init(&state->mutex);
> -
>  		ret =3D az6007_write(d, AZ6007_POWER, 0, 2, NULL, 0);
>  		if (ret < 0)
>  			return ret;
> @@ -770,14 +768,22 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap=
, struct i2c_msg msgs[],
>  			if (az6007_xfer_debug)
>  				printk(KERN_DEBUG "az6007: I2C W/R addr=3D0x%x len=3D%d/%d\n",
>  				       addr, msgs[i].len, msgs[i + 1].len);
> +			if (msgs[i + 1].len < 1) {
> +				ret =3D -EIO;
> +				goto err;
> +			}
>  			req =3D AZ6007_I2C_RD;
>  			index =3D msgs[i].buf[0];
>  			value =3D addr | (1 << 8);
>  			length =3D 6 + msgs[i + 1].len;
>  			len =3D msgs[i + 1].len;
> +			if (length > sizeof(st->data)) {
> +				ret =3D -EOPNOTSUPP;
> +				goto err;
> +			}
>  			ret =3D __az6007_read(d->udev, req, value, index,
>  					    st->data, length);
> -			if (ret >=3D len) {
> +			if (ret >=3D 5 + len) {
>  				for (j =3D 0; j < len; j++)
>  					msgs[i + 1].buf[j] =3D st->data[j + 5];
>  			} else
> @@ -797,6 +803,10 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap,=
 struct i2c_msg msgs[],
>  			value =3D addr | (1 << 8);
>  			length =3D msgs[i].len - 1;
>  			len =3D msgs[i].len - 1;
> +			if (length > 64) {
> +				ret =3D -EOPNOTSUPP;
> +				goto err;
> +			}
>  			for (j =3D 0; j < len; j++)
>  				st->data[j] =3D msgs[i].buf[j + 1];
>  			ret =3D  __az6007_write(d->udev, req, value, index,
> @@ -815,10 +825,18 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap=
, struct i2c_msg msgs[],
>  			value =3D addr;
>  			length =3D msgs[i].len + 6;
>  			len =3D msgs[i].len;
> +			if (length > sizeof(st->data)) {
> +				ret =3D -EOPNOTSUPP;
> +				goto err;
> +			}
>  			ret =3D __az6007_read(d->udev, req, value, index,
>  					    st->data, length);
> -			for (j =3D 0; j < len; j++)
> -				msgs[i].buf[j] =3D st->data[j + 5];
> +			if (ret >=3D 5 + len) {
> +				for (j =3D 0; j < len; j++)
> +					msgs[i].buf[j] =3D st->data[j + 5];
> +			} else {
> +				ret =3D -EIO;
> +			}
>  		}
>  		if (ret < 0)
>  			goto err;
> @@ -889,6 +907,15 @@ static int az6007_download_firmware(struct dvb_usb_d=
evice *d,
>  	return cypress_load_firmware(d->udev, fw, CYPRESS_FX2);
>  }
> =20
> +static int az6007_probe(struct dvb_usb_device *d)
> +{
> +	struct az6007_device_state *state =3D d_to_priv(d);
> +
> +	mutex_init(&state->mutex);
> +
> +	return 0;
> +}
> +
>  /* DVB USB Driver stuff */
>  static struct dvb_usb_device_properties az6007_props =3D {
>  	.driver_name         =3D KBUILD_MODNAME,
> @@ -897,6 +924,7 @@ static struct dvb_usb_device_properties az6007_props =
=3D {
> =20
>  	.adapter_nr          =3D adapter_nr,
>  	.size_of_priv        =3D sizeof(struct az6007_device_state),
> +	.probe               =3D az6007_probe,
>  	.i2c_algo            =3D &az6007_i2c_algo,
>  	.tuner_attach        =3D az6007_tuner_attach,
>  	.frontend_attach     =3D az6007_frontend_attach,
> @@ -919,11 +947,12 @@ static struct dvb_usb_device_properties az6007_cabl=
estar_hdci_props =3D {
> =20
>  	.adapter_nr          =3D adapter_nr,
>  	.size_of_priv        =3D sizeof(struct az6007_device_state),
> +	.probe               =3D az6007_probe,
>  	.i2c_algo            =3D &az6007_i2c_algo,
>  	.tuner_attach        =3D az6007_tuner_attach,
>  	.frontend_attach     =3D az6007_cablestar_hdci_frontend_attach,
>  	.streaming_ctrl      =3D az6007_streaming_ctrl,
> -/* ditch get_rc_config as it can't work (TS35 remote, I believe it's rc5=
) */
> +	/* ditch get_rc_config as it can't work (TS35 remote, I believe it's rc=
5) */
>  	.get_rc_config       =3D NULL,
>  	.read_mac_address    =3D az6007_read_mac_addr,
>  	.download_firmware   =3D az6007_download_firmware,
>=20
>=20
> base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
> --=20
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
>=20
> See https://goo.gle/syzbot-ai-patches for information about AI-generated =
patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
