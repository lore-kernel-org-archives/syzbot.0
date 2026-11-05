Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.50
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793878510;
	b=ifb1h1mTEdN1MIkDB/3g1R8KL7zfE8jtQz5UUJoREF3Z9/kgWco1yACpEDCDeZatMC+q
	 LQCLlXM/kAIpBjVX1vyzbU9xN6b5arpsdqAU8+zwFGY++4CnuhMVZgR7k9eKZGH6Ru3Fr
	 Ld0l5thj1uU2cT2x8ejOjcJ+yYSJpSIk+Kk64iC5Utl6gv5rGaTgm5GO5qQ9ZmXjtAydn
	 dBT4ptSL+40f6OYdwZAtac606TM+6JeRhd5NO4wf+GfERSbC4Rju71DjlEXIgKZKB5BN6
	 xn4xVHuhC1bgkIsbXWOSPt5xsuSKZIj3SSf8+uIbbRWtBTd8NJb72+IhMEUaHv/dwzw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793878510;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=lhHP2z6w0aRmGG/Qi8cryvc4FIhNe+RiRGhgYb3H/6E=;
	b=Qvrog/geNzrK0ofGUP6upFH//Z+9Rm3e/1XCAlxL+j4iFq4iA/4A1OhOd9Aqbz8h9IUM
	 Yya6h7NS8xFmHH6N65jX9YsnV1FXZ8jrQvx0EqJO1kNim1Zi1youdcuYmnEIX34opNTQY
	 SH0mJj8uFuFnwjMaWlB64zLtdPrt+GnOOGCnS74kUIIeKE/pMK77i3QoRJQKgQQukeWkd
	 4CzB1ew6rxxo/jpj97Tgi1V2DCxHh9vzaOW4/bLHVw+rbg50TX9hAVhMtbRLy/qOHnPCu
	 pOP+3rhOp39OLGc4rsSkWrzevmAJoN+C7jEqhg6uFKbponsF3GcOE5D6U52qpTMSO6g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hu6UpBpM;
	arc=none smtp.remote-ip=209.85.208.50
Received: from mail-ed1-f50.google.com (mail-ed1-f50.google.com [209.85.208.50])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4780E606A328
	for <syzbot@lists.linux.dev>; Thu,  5 Nov 2026 11:35:10 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 4780E606A328
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=hu6UpBpM
Received: by mail-ed1-f50.google.com with SMTP id 4fb4d7f45d1cf-6b571979178so1467806a12.2
        for <syzbot@lists.linux.dev>; Thu, 05 Nov 2026 03:35:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793878509; x=1794483309; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=lhHP2z6w0aRmGG/Qi8cryvc4FIhNe+RiRGhgYb3H/6E=;
        b=hu6UpBpMEeO/ahBlPMr+ixm5GTx0nLEViFrLP2gvzviKSu9o3DBwMhdaiilFZkX/U7
         UXujNjiC68fgjE1XHLK10CqPUzEciowXwfN34pOyHzcjPFGd/yWWBtHJ0RqsXgCvctxu
         PJBqRw8d0YfmjQIQGUusOQqgji3Hvwv192Awi7exqmdE+UNoawkAtAZJw8O00OZ/W1Uz
         MVPyZkJmESgQANxKlKRMJq/LKlwrHIXtwNeoYt5i4gd0f1Ef3NoWQpOliO2T2+H5EzFO
         n7b8XBX7uohD1hhFIMJgXhq9QvkLi4ZVuL6e5k3tyRfpUWZpmKl3NKjH17x6LNLrsPu5
         9OCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793878509; x=1794483309;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=lhHP2z6w0aRmGG/Qi8cryvc4FIhNe+RiRGhgYb3H/6E=;
        b=eNSsJLzmNSaobMfgs5+zwlKoGxgC+bPeMJJUpNUjn0wlZtN96UMg7PJVpuqdgaxyYu
         xzSNcCe3CxoBCO1pzR6LzbleKWbWPJ1yX5RImCZbnC7mCwcxulp+SsRHVntGUSRq1q00
         e3IGqTFmHm/gneUMxnostE3kGkfOyQShjBVXYZipSyg+lmrZzg34rpfedOn4FaKcxUEg
         4zsgbi35SJfs6/5mFjFQp950NuIiUHOqTqBA0ub48YCwb5xWvrwUXWO6+O0VxJWddr17
         b5iVF4Q3kwiyq3jfZOy50l3zc6yfqKif6Q8CjU/B+4co5WbJ+fqcsZrgch3ixGeEAFGn
         voQQ==
X-Forwarded-Encrypted: i=1; AKwUvByID4wlaZNs//3GiWI3hu7Lkj2O7UqOtC0snzkt1qWP1+tzZGLejBlx3tOacBkA+tyysf9IxnY=@lists.linux.dev
X-Gm-Message-State: APuU4Z8MK51pMuMhg5NOVM55Z/zeN3PcHLqTO7AEddmvyBetHw32u22m
	3c1Q69g54ZWDpSKb3KyRWewP1JKSDSixo3hEtzfxHLi4iDkSWjieEMe7
X-Gm-Gg: AYBFou1aJzYCpnjbqCZ0ECty3ngWnG1AqzKZQD98evyUVyG2H50QUkTbUIQF6CvmdxD
	Bg9xi4KGZSFpdt3rMb6VUZYk0u/kg+SGCXmXZCbFVtSCY6LDZLiIbeuw6M0c1khCNRE5Hh82XRe
	Gun1OZWUd33OM9TbdXXIlCwVMFeftvsPVdWTzUxxQLtl3tGq9vfywvY1sIadbHJ1yJVv0KmD7m1
	J/5CYFBWhm/ZakDWL2jMJYSIRh81NsvJgqTfrC9Gx8eSkJQLJd2N8V4yRYJOlx0b0M2Hm4bCP/a
	lKwPV+ESw9KlXjIdo75Wkbws8qback5yV+XIOjbs6YXkSSnEoLYX/kj9Yo3Km5cNj3XtVHsXFOw
	xNj/a5YAzGiAoMhJFDpDqjLeIX6VoEEiIaZkxlQWBZBELzeRngXVqgQcqMKRbj2w+iUIeNcUK5s
	DD1ggPQHqvuIr+C99GI4jDcSIR7bcEt/q3u9LO9h8CasV+hl+AzZeXoQ7JEcVeVbFOWKItnmsFC
	C+K1KpJkHTIMJS66rTjA7Bgesr/YRpr8+E8yQxFoIaZgMisAuA6VhZp22fASMc3pHtquQxeCN1u
	ZCiKoLRTQhkhieAZVG310AeHpJDYTLdjG3JRkZQXMj0aMEg=
X-Received: by 2002:a05:6402:681:b0:6b1:eeca:87c1 with SMTP id 4fb4d7f45d1cf-6b4d46789a8mr11186173a12.21.1793878508408;
        Thu, 05 Nov 2026 03:35:08 -0800 (PST)
Received: from localhost ([188.146.174.10])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6b55ac57b9csm1689355a12.15.2026.11.05.03.35.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Nov 2026 03:35:08 -0800 (PST)
Date: Thu, 5 Nov 2026 12:35:05 +0100
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] media: mxl111sf: initialize state->d and fe_lock
 in probe
Message-ID: <d6keyrqkornqpctdn73u3chgtavoawzoeylkbznb5w5y2blu3m@twymljr6iv7y>
References: <0d33de80-3e10-403b-a843-04ac26a97f61@mail.kernel.org>
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
In-Reply-To: <0d33de80-3e10-403b-a843-04ac26a97f61@mail.kernel.org>

For the
"Although the selected 2026-10-02 report was captured in compat mode with
PTI, the failure is illustrated by the following x64/NOPTI trace:"
Replace the "the selected 2026-10-02 report" in commit description
with a generic issue descriptive equivalent.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Thu, Oct 29, 2026 at 10:25:59AM +0000, syzbot wrote:
> During device initialization in dvb_usbv2_probe(), the dvb-usb-v2 core
> allocates the dvb_usb_device structure and its private state (struct
> mxl111sf_state) via kzalloc(), then invokes dvb_usbv2_init(). Within
> dvb_usbv2_init(), dvb_usbv2_i2c_init() registers the I2C adapter with
> i2c_add_adapter(), which immediately exposes the I2C adapter to userspace
> via the /dev/i2c-X character device.
>=20
> However, state->d was only assigned later during frontend attachment insi=
de
> dvb_usbv2_adapter_frontend_init() via d->props->frontend_attach(). If
> userspace performs an I2C transaction before frontend_attach() completes,
> mxl111sf_i2c_xfer() delegates to mxl111sf_ctrl_msg(), which reads state->d
> and passes it to dvb_usbv2_generic_write() or dvb_usbv2_generic_rw(). Sin=
ce
> state->d is still NULL, dereferencing &d->usb_mutex inside
> dvb_usbv2_generic_write() triggers a null-pointer dereference crash.
> Although the selected 2026-10-02 report was captured in compat mode with
> PTI, the failure is illustrated by the following x64/NOPTI trace:
>=20
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000018: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x00000000000000c0-0x00000000000000c7]
> RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:625 [inline]
> RIP: 0010:__mutex_lock+0x149/0x1550 kernel/locking/mutex.c:821
> Call Trace:
>  <TASK>
>  dvb_usbv2_generic_write+0x26/0x60
>  drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c:77
>  mxl111sf_ctrl_msg+0x160/0x2f0 drivers/media/usb/dvb-usb-v2/mxl111sf.c:73
>  mxl111sf_write_reg+0xa9/0x1b0 drivers/media/usb/dvb-usb-v2/mxl111sf.c:123
>  mxl111sf_i2c_start drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c:130
>  [inline]
>  mxl111sf_i2c_sw_xfer_msg drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c:-1
>  [inline]
>  mxl111sf_i2c_xfer+0x463/0x5060
>  drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c:813
>  __i2c_transfer+0x7bf/0x1fe0 drivers/i2c/i2c-core-base.c:-1
>  i2c_transfer+0x1cb/0x2d0 drivers/i2c/i2c-core-base.c:2350
>  i2cdev_ioctl_rdwr+0x460/0x740 drivers/i2c/i2c-dev.c:306
>  i2cdev_ioctl+0x6a5/0x880 drivers/i2c/i2c-dev.c:467
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
>=20
> Additionally, state->fe_lock was initialized in mxl111sf_init() (called v=
ia
> d->props->init()), which runs after frontend attachment, leaving the mutex
> uninitialized during frontend registration. Although the selected I2C fau=
lt
> does not demonstrate a frontend lock race, fe_lock should also be
> initialized before frontend registration.
>=20
> Fix this by setting state->d =3D dev and initializing state->fe_lock in
> mxl111sf_probe(), which runs before dvb_usbv2_init() registers the I2C
> adapter or attaches frontends. Furthermore, remove the redundant
> mutex_init(&state->fe_lock) from mxl111sf_init() and the redundant
> assignments of state->d in the frontend attach functions.
>=20
> Fixes: 4c66c9205c07 ("[media] dvb-usb: add ATSC support for the Hauppauge=
 WinTV-Aero-M")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+f9f5333782a854509322@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Df9f5333782a854509322
> Link: https://syzkaller.appspot.com/ai_job?id=3D60bc5497-9c9b-4886-b53d-3=
2db7cd4696e
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> To: "Michael Krufky" <mkrufky@linuxtv.org>
> To: "Michael Krufky" <mkrufky@kernellabs.com>
> Cc: <linux-kernel@vger.kernel.org>
>=20
> ---
> v2:
> - Clarified in commit description that the quoted x64/NOPTI trace is dist=
inguished from the 2026-10-02 PTI/compat report
> - Noted in commit description that fe_lock is initialized before frontend=
 registration, and that the I2C fault does not demonstrate a frontend lock =
race
>=20
> v1:
> https://lore.kernel.org/all/b8b6fc2d-1c9a-4046-bba5-c9ef864bfae3@mail.ker=
nel.org/T/
> ---
> diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/=
dvb-usb-v2/mxl111sf.c
> index 6404eb74d..fc4010b6e 100644
> --- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> +++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
> @@ -431,8 +431,6 @@ static int mxl111sf_lgdt3305_frontend_attach(struct d=
vb_usb_adapter *adap, u8 fe
> =20
>  	pr_debug("%s()\n", __func__);
> =20
> -	/* save a pointer to the dvb_usb_device in device state */
> -	state->d =3D d;
>  	adap_state->alt_mode =3D (dvb_usb_mxl111sf_isoc) ? 2 : 1;
>  	state->alt_mode =3D adap_state->alt_mode;
> =20
> @@ -502,8 +500,6 @@ static int mxl111sf_lg2160_frontend_attach(struct dvb=
_usb_adapter *adap, u8 fe_i
> =20
>  	pr_debug("%s()\n", __func__);
> =20
> -	/* save a pointer to the dvb_usb_device in device state */
> -	state->d =3D d;
>  	adap_state->alt_mode =3D (dvb_usb_mxl111sf_isoc) ? 2 : 1;
>  	state->alt_mode =3D adap_state->alt_mode;
> =20
> @@ -587,8 +583,6 @@ static int mxl111sf_lg2161_frontend_attach(struct dvb=
_usb_adapter *adap, u8 fe_i
> =20
>  	pr_debug("%s()\n", __func__);
> =20
> -	/* save a pointer to the dvb_usb_device in device state */
> -	state->d =3D d;
>  	adap_state->alt_mode =3D (dvb_usb_mxl111sf_isoc) ? 2 : 1;
>  	state->alt_mode =3D adap_state->alt_mode;
> =20
> @@ -674,8 +668,6 @@ static int mxl111sf_lg2161_ep6_frontend_attach(struct=
 dvb_usb_adapter *adap, u8
> =20
>  	pr_debug("%s()\n", __func__);
> =20
> -	/* save a pointer to the dvb_usb_device in device state */
> -	state->d =3D d;
>  	adap_state->alt_mode =3D (dvb_usb_mxl111sf_isoc) ? 2 : 1;
>  	state->alt_mode =3D adap_state->alt_mode;
> =20
> @@ -749,8 +741,6 @@ static int mxl111sf_attach_demod(struct dvb_usb_adapt=
er *adap, u8 fe_id)
> =20
>  	pr_debug("%s()\n", __func__);
> =20
> -	/* save a pointer to the dvb_usb_device in device state */
> -	state->d =3D d;
>  	adap_state->alt_mode =3D (dvb_usb_mxl111sf_isoc) ? 1 : 2;
>  	state->alt_mode =3D adap_state->alt_mode;
> =20
> @@ -935,8 +925,6 @@ static int mxl111sf_init(struct dvb_usb_device *d)
>  	if (mxl_fail(ret))
>  		pr_err("failed to get chip info during probe");
> =20
> -	mutex_init(&state->fe_lock);
> -
>  	if (state->chip_rev > MXL111SF_V6)
>  		mxl111sf_config_pin_mux_modes(state, PIN_MUX_TS_SPI_IN_MODE_1);
> =20
> @@ -1068,7 +1056,9 @@ static int mxl111sf_probe(struct dvb_usb_device *de=
v)
>  {
>  	struct mxl111sf_state *state =3D d_to_priv(dev);
> =20
> +	state->d =3D dev;
>  	mutex_init(&state->msg_lock);
> +	mutex_init(&state->fe_lock);
>  	return 0;
>  }
> =20
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
