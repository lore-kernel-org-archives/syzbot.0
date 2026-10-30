Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793362350;
	b=vRgnvQ/ojuLuoUspDHxI6K62Kh6AVtCmc8nP3c+0czO3A6U5urdNjy1vzbTJGiqpoO+y
	 J6jwTWU2hWhzDheNgxBfa1IjDXkC176OHcCAPDzAxYNqfeNMIzvK5FSa8AOuQOaCLISwa
	 npNhQq9F2m7z+USF9f6YFe7Q4gZapanyyMN5xld6QTfyUVqd3U+u4vK6KuvhcNvPnNvlc
	 b7ygA5Lk/UshaeonEiz/dFDU/fejYUH5vD+uB6cE7VkvfO6/6HWQ2KkvIPvJidh/zDZ/j
	 fxQOxPQfcHS5DObC+hQgNhad9ppAsGL3go6P1Ch33UdCfocYUc6g6g29uH5kwT0WUsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793362350;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=KfQp2hhaw1pAsQ2kPVRn7TF8YnLvMQlKvQQ+4mNCKD0=;
	b=SwFxfy0sFWxzHnK+oDMH0dovEdp6Lpx0EE6f5ZBrJ8OJmREtsFggncL0ghZwhK/vRQxi
	 JIIFl6MOC/JbLjXXxAhc/B2nzI4vpK8WwO+xCCujL7QLDlvIvBoum7l/XIBXBE2u3jL2j
	 0vzRvz2RcKxdMJV+Dr7ZhVBwH2tkRMwc88fWot8UbXNUOMDgwR66Hz6THdIPUdJTWm26l
	 tVsUDW0lnxPZWb0CKXgKG+q5IXxwDwXhxD59asolbij0W/SF0DVlELbaG/wdEl7nRjfIX
	 H1qfvGDhMrDWc4E9FSBMkt+4RhIN0Vxlvfh6lcjP3N7jo404uV2rJr5triSUhSd08PQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mf1hl4KY;
	arc=none smtp.remote-ip=209.85.218.45
Received: from mail-ej1-f45.google.com (mail-ej1-f45.google.com [209.85.218.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2A30606A31A
	for <syzbot@lists.linux.dev>; Fri, 30 Oct 2026 12:12:29 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org D2A30606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=mf1hl4KY
Received: by mail-ej1-f45.google.com with SMTP id a640c23a62f3a-c4326803b54so37142366b.0
        for <syzbot@lists.linux.dev>; Fri, 30 Oct 2026 05:12:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793362348; x=1793967148; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=KfQp2hhaw1pAsQ2kPVRn7TF8YnLvMQlKvQQ+4mNCKD0=;
        b=mf1hl4KYr6eOUavLwTrIE7JW+wGzoqZVfrGCrMWlOVifwPXkjdK2cBxCeP6oEiVjPT
         3MZcyyS2X5DXsJqK/0/I0RqwCft/4cj15dEp6iM2zaZPaLQdDq3CGqCO5sOlYU5SYEVM
         qHFivzhxP8ssBUB4D4eCZhMMOLb7xj1p/vsTjQy+eVdy/4elodyZq9vnPv1475PnAnBs
         3NbtvQoHZuNd2t0PrsIXxKc/3yaL2HSGx9/gbvq6gkIk3N81co7dAYdXx4nUq80s5mnB
         Ox7jvXRo939Je3C0cvOMnx+qoIHaDs6qKnJcW/piTQZRJ5jp9wryIcuupwPf9B+MErIp
         i71g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793362348; x=1793967148;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=KfQp2hhaw1pAsQ2kPVRn7TF8YnLvMQlKvQQ+4mNCKD0=;
        b=d5iwWB/fKbCRJIikot/tKnyOAW1g2RKr1CJFtXT2YF/gWYSEcJ1jtqu0IIhc+F73cB
         V4bFUD5oIOmV+z0qh3FYgdVfTAsXXh1FO2vTd3LAidiWU59/EApw347SRhLmYeTGtQ5Z
         lugIw2j2/Mxrghc4xHBuKRg1ME05MGzWoj+JpRr3/AY71gIYu+qYISIYlxjodFXBzdwp
         qk1BnQhllgnLvW6qe9hNFi34Ssrm78DWC8O4CGFM3kpewrkmOGpI9I2mz/9eiHoGReQg
         AHgfwn/WQ+x/w2juVlc4qS1TAObpMUVR6hr+DNj4TqF9uEr4peD5DkkBv44audtZv0PY
         2Q1A==
X-Forwarded-Encrypted: i=1; AKwUvBzpU1S7mnnm80piK/hvWtDIObpxe5etd/eaIEs36GR4ZuIJeHbWVqgBlftV009Hx9emfYLE15w=@lists.linux.dev
X-Gm-Message-State: AFq9FYIxvxuSeymn6ULR70gjSsNPghBSVVujgNGAdEDAy3eIp1Eg5xek
	CsAuYYVmhjb3q4s6TsLtNwrJjyexlSgujLScEX1wSxyTJWSGRg9jQS6u
X-Gm-Gg: AYBFou34fgjnfpIg2ofXHi76hmHMUIFEte9zcBQKYtWEAbcHn83joN/LE4Y1ogs3dGV
	hh8UObIDtT3c9J9POorL85tns/CdFtwTOJWzTLiw66lZ2gP+aGVSWxFIOQSTLNhUVL5cpKpYixX
	sRtXckKM3Xtf6kci67XzV/Sg/MqMoF7ifatQ8sE1itUAIIkSaShE6O5OeHPE5loIWIx0QCCXTf2
	OChFtd2eOsZ5W2bFhuYSAjN49sVTUGIw8MSu04b2UqQU5NdbfrdzV0hrpvBLYDeN6gX8Sj6Did5
	Q+odGLf4G14NRXQLdP/ESZx/1NYFLRFJ2PTx+dqlTqKKx+bjUtqlz2TxdcRisQJ/fFdc9LqHTyT
	PXac1ctqPC5eLD81xyNmJWILysXeXU3qK/4Gz6HxqgmIzUcjkynZgbKsRGZv5V0vm7RMZSPoBcX
	BRh5ni65H2/GMJqYpu8Q49v2rPBTbVO0eVvu/q7AUKvGV6UI3GiRxmxgQHXdstrSmaPY+CGZIR1
	5RB2btdwWRmFZIBOBiRoK47fwmrxuWg1pEO+5opYJe1YgEFW0dut4EoVrHD5o3dFw6NOvtvetvW
	t1UUKw7d6pggn1rsFnhYLnJWqrFvyN+J6KNkyjtDXGncFAgk7g==
X-Received: by 2002:a17:907:1c94:b0:c3e:d0ca:d2fd with SMTP id a640c23a62f3a-c4ca7a161b7mr200752266b.12.1793362347902;
        Fri, 30 Oct 2026 05:12:27 -0700 (PDT)
Received: from localhost ([188.146.172.135])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabe0f504sm59073166b.36.2026.10.30.05.12.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 30 Oct 2026 05:12:27 -0700 (PDT)
Date: Fri, 30 Oct 2026 13:12:26 +0100
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] media: az6007: Fix out-of-bounds access and mutex
 reinitialization
Message-ID: <tph6tbxhgxh7hgroxk7r2vduzf2f2zstjrgskyce7sljbtjz5o@ei4didndhbaj>
References: <98467e25-6e27-41d8-94d9-5367714ce9b0@mail.kernel.org>
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
In-Reply-To: <98467e25-6e27-41d8-94d9-5367714ce9b0@mail.kernel.org>

The v1 patch puts the buffer bounds in the right place and initializes the =
mutex once in probe. Both read paths can still accept a short USB reply and
copy stale bytes.

Required changes:
- In both read paths, check that the USB reply contains the five skipped by=
tes
  plus all bytes copied to the I2C message. Return -EIO if it is too short,
  or document and enforce a different exact reply length required by the
  device. The current ret >=3D len check can report success and copy old da=
ta.
- Reject write payloads above the 64-byte USB limit in az6007_i2c_xfer()
  before copying them to st->data. Keep the __az6007_write() limit before i=
ts
  debug dump. Keep the six-byte read bounds and probe initialization for bo=
th
  device variants.
- Correct the description. The selected report shows damage to the mutex wa=
it
  list before the I2C transfer starts. Other testing showed a separate read
  past the buffer. A failed-power mutex reset was observed on the patch's b=
ase
  commit, but the selected report does not show that exact sequence.
- Fix the final commit metadata: keep the Fixes: tag for b19280cf2bee, which
  introduced the buffer bug. Also cover a2c35d346d9e, which introduced the
  mutex; use a second Fixes: tag if appropriate, or explain why one is enou=
gh.
  Remove the old duplicate mchehab@redhat.com address, and keep the current
  media maintainer and lists. Update the generated tags and recipients at
  submission.

Syzbot flow request:
Rerun the original reproducer on the historical kernel. Compare unpatched a=
nd
patched kernels built from the same base commit. Check short USB replies, I=
2C
transfer sizes, a failed-power command with an I2C waiter, and both device
variants. State any hardware testing limit.

Context:
On the unpatched kernel at the patch's base commit, two guests showed the
driver initializing the mutex again after a failed power command while an I=
2C
transfer waited on it. Initializing the mutex once in probe removes that re=
set
path. The first write context details that damaged the historical list are =
not confirmed.

Impact assessment:
The oversized read can go past the buffer; v1 blocks it. The short-reply bug
can still return stale bytes from the state buffer to an I2C reader.. The s=
elected warning shows a damaged mutex wait list, but its exact trigger is s=
till unproven.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Mon, Oct 19, 2026 at 05:22:35PM +0000, 'syzbot' via syzkaller-upstream-m=
oderation wrote:
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
> into st->data without verifying that the payload fit within st->data.
> Additionally, in __az6007_write(), the blen > 64 check was performed after
> dumping the payload to the kernel log under az6007_xfer_debug.
>=20
> Separately, mutex_init(&state->mutex) was called inside az6007_power_ctrl=
()
> when !state->warm. If the initial power-on command failed, state->warm
> remained false, causing subsequent invocations of az6007_power_ctrl() to
> reinitialize state->mutex while the device was active. If another thread
> held the mutex during az6007_i2c_xfer(), reinitializing the mutex cleared
> the lock owner and triggered a DEBUG_LOCKS_WARN_ON warning on unlock.
>=20
> Fix these issues by:
> - Moving mutex initialization out of az6007_power_ctrl() into a newly
> introduced probe callback (az6007_probe) that initializes state->mutex on=
ce
> upon device probing.
> - Adding upper-bound checks against sizeof(st->data) in the single read,
> single write, and combined write+read paths of az6007_i2c_xfer(), as well
> as verifying msgs[i + 1].len >=3D 1 in the combined path.
> - Checking that __az6007_read() succeeded before copying data from st->da=
ta
> to msgs[i].buf in the single read path.
> - Moving the blen > 64 check in __az6007_write() before the debug hex dum=
p.
>=20
> Fixes: b19280cf2bee ("[media] az6007: code cleanups and fixes")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+0192952caa411a3be209@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3D0192952caa411a3be209
> Link: https://syzkaller.appspot.com/ai_job?id=3D8ca38357-fe34-43e4-bc49-e=
73c595eb9a2
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
> Cc: <linux-kernel@vger.kernel.org>
>=20
> ---
> diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dv=
b-usb-v2/az6007.c
> index 65ef045b7..20b2bd944 100644
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
> @@ -770,11 +768,19 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap=
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
>  			if (ret >=3D len) {
> @@ -797,6 +803,10 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap,=
 struct i2c_msg msgs[],
>  			value =3D addr | (1 << 8);
>  			length =3D msgs[i].len - 1;
>  			len =3D msgs[i].len - 1;
> +			if (length > sizeof(st->data)) {
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
> +			if (ret >=3D len) {
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
>=20
> --=20
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/98467e25-6e27-41d8-94d9-5367714ce9b0%40mail.kernel.org.
