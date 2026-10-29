Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.49
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793265421;
	b=JNqyz2Ump3/THBmbz5S6rVb0RBtZ7tQxJrcwV6YOrP6f8lIVqBCwMPdqNrpPP6wbVBht
	 7Z/7UMzr3ogrm9dHxT1HMp4QPWhzOvje+1xRYe2Du9GOJIxLLxE39RlXjgUES2udygUNp
	 /wIVCv2FcM9XOyiIVPkSPlokt7H13wDsedYkq0I/GKz3KxuxVOZcH6AH1S114CswymzKB
	 puiuCgwAslw4OhrcG/pxg0PaSsxlthSJ9U4rITIo7oPfEhYALhmkbwN0iwr+iRehw4W2X
	 P5IdV3jufJ3X0OrXP77LLqVJWZKkvod+mSvRPn08D2zZarng4rbW3ckHLzd8FwhtZjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793265421;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:Content-Transfer-Encoding:
	 In-Reply-To;
	bh=ge1EzgBoVMN9k1VDFc5Z2du+Odf41+v73pP02bIxQWY=;
	b=XRFaJVsZVtDJHTRqTHW/WDgOX37l19yg0krG85Dq8qRBKVttB39eTpiUisbFbV3sfwwb
	 LfiUFg2GMUMkLWdcvCX2nHxJWSRAccW0mraam0c+tMDboIIZHJcOQSMukhUDChuUTlbCk
	 Ks4GGMG3iHmab+aHIGZMG0FJ7HDkpncp8gvlWZLN/FNr4AalY4TK94F67Pl4Np2sNzZT9
	 +7PQW+DeIX8JJ9kNYD4s2HKP+aj18rVXO91m17EEgz6XysehaGTrKWUi0RTNfxX0JuBf0
	 elC02uvzvKEbBu7/vuuE+tGliFTfyNQxSu6DfG4EQceCRSYNK606qz1zt3VuxM8DRrA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JeHrlcZy;
	arc=none smtp.remote-ip=209.85.218.49
Received: from mail-ej1-f49.google.com (mail-ej1-f49.google.com [209.85.218.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C217C606A31A
	for <syzbot@lists.linux.dev>; Thu, 29 Oct 2026 09:17:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C217C606A31A
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=JeHrlcZy
Received: by mail-ej1-f49.google.com with SMTP id a640c23a62f3a-c4677aad67bso214288366b.0
        for <syzbot@lists.linux.dev>; Thu, 29 Oct 2026 02:17:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793265419; x=1793870219; darn=lists.linux.dev;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=ge1EzgBoVMN9k1VDFc5Z2du+Odf41+v73pP02bIxQWY=;
        b=JeHrlcZyh7qGzXFPvS+sVqA8jpju5PrEBmIqVTUeMnsbjAP7gMWLvlLRfH1Og4sggf
         09RD55aHH/B2WeSWxd2sCRP6Ovgm+1185S26O6JEBuXFoWNTX7FIr0Af6KnKcflI+Lp0
         hq7Bpz4II1BbCxAZr051s81Oxz5EvliSKjWbgQ8hqylo2jUMtwmc8iJTz/q16R/hCM+F
         krwJn0iXr7PVimVPVhw88A6EwD+xneiLlbmv05ueWyRnLmY6PTiwUM+t16YUVAg4PhuH
         R27grs1hLsjcUEk767jDXn10DshvzPoYZu6MNP62+bkhP19z8xg+kP0+uZBEokfU8FbD
         0piQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793265419; x=1793870219;
        h=in-reply-to:content-transfer-encoding:content-disposition
         :content-type:mime-version:references:message-id:subject:cc:to:from
         :date:x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=ge1EzgBoVMN9k1VDFc5Z2du+Odf41+v73pP02bIxQWY=;
        b=rjw2q4/hsB8qT9qBjFkRiAyZPqbSHSg6b/OuLLfvi4TU/V+sx3VXJrsFa6cog0ckRN
         8KfgEKUe0SewObhOHeoXMQH4xdU1/E4VyFVmzzTpvcx1Nh1Sb+KGqMjmgv7cT23xA6hY
         zk+xUcS7w9xc2cqmBqocrvV5nKRff/FCnX/u8arUtRSAmIuNztla9eNY2f62Dku/tinf
         osmTQ4ofpsnauZuuy10Hqzyr/Vz+WNv3H+uKnFPhjvufDA8t+TwQ/fgV3Xoj+tUpQN0B
         4eiVcvyzbc6r/w3sNIl2fmC9/8/9/aAOatRPSj8N86Y03TsaTUTUrzF5oOu2ElOFMwlz
         /urA==
X-Forwarded-Encrypted: i=1; AKwUvBzNBUbp9rSD8Vruxi5AU6nVeVqMqOCTakJSEO/0Z0zEaKpIVOr6OYtpe/raIcz/e4FcLJb5CjQ=@lists.linux.dev
X-Gm-Message-State: AFq9FYKsl5geYhY+rtCLqirQJ6bdxyo0t186lL80A4kc9y4+vbMqyR/y
	eoqEPG3iO9KVkvwkKhWRKSHdjN83Wl1pouirGNcSkYykqezHZT/MwGEb
X-Gm-Gg: AYBFou2HOhFtTFba3ZTBfYfcdn5ZTRHVPVAD7N71ReAkVCkpfNHhNlWtV+8fxXEucyJ
	TCZO9E9yRPFuB7dR1wzZeaYHlYJC+viOrIi1qTv7nm2tgCSs6wFrceOUR3n4L+0V6vpeNpQkBLY
	NJ+r74UYgRpQiKHK+nVeRC5xZlnOCLEAK1zvBOo2/WmsAl3uo/5oilkHadHWL0vXjILXqjd3tAh
	0pFQz9SjqysbiiN9Pk2MPpJkl+jV1nyVugk2wrU3QPsI1mhXjw0+aplz+8YF+AfCDmMVmsmKuje
	WJD8fQNfRG2KKn5MBvb3FC7v7xlmJwGe4C3TXNyAracD5Br3cY+cno6R8r2Jg33dBN4YIROS3B6
	21VTApfcq/YkwR3LFadhfKYs1FemATSsBaAeZyMlkDL5gyiD6q4O/xSKRTT6q6xanK9AyVpX6CW
	ZehYcXu4szCdYQHD7iwPkbbVu04hmCIov8WcRkwt+otNhkWlifpfisKTYqoRqw2Prq3NBsUbeRy
	qByVR1RQtnI8NgMrlqHMoY0hYOmckEl1WayzA/BKU1jU1KRkLEblJol9ssLmNc2NdIEcOzvfuI1
	Rr/NyEKCs+hKl8OXpD5Aym4vHCnXOMpv1nUcky9wWhxrHubl/ywN1A==
X-Received: by 2002:a17:907:1c0d:b0:c2e:4292:d27e with SMTP id a640c23a62f3a-c49bdf6cfa4mr422827266b.22.1793265418855;
        Thu, 29 Oct 2026 02:16:58 -0700 (PDT)
Received: from localhost ([37.30.46.15])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c46bd7bbdc6sm706594966b.87.2026.10.29.02.16.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Oct 2026 02:16:58 -0700 (PDT)
Date: Thu, 29 Oct 2026 10:16:56 +0100
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] media: mxl111sf: initialize state->d and fe_lock in
 probe
Message-ID: <hblb6wiokwrksxr4aakie4svfxvjnogjqdvujysv7d7wmngmbc@pszgf7xbqh54>
References: <b8b6fc2d-1c9a-4046-bba5-c9ef864bfae3@mail.kernel.org>
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
In-Reply-To: <b8b6fc2d-1c9a-4046-bba5-c9ef864bfae3@mail.kernel.org>

The v1 code change is sound in the tested scenario. The assembled patch sti=
ll
needs the submission corrections below; no code rewrite is requested.

Required changes:
- Correct the formatter-owned Fixes: metadata. Replace 8572211842af with
  4c66c9205c07, or provide source history supporting a narrower
  conversion-specific claim. The syzkaller-side metadata owner must make th=
is
  change; editing the generated description alone cannot change the trailer.
- Revise the description to distinguish its quoted x64/NOPTI trace from the
  selected 2026-10-02 PTI/compat report, or quote that selected report. Des=
cribe
  fe_lock as initialized before frontend registration; the selected I2C fau=
lt
  does not demonstrate a frontend lock race.

Testing:
In a matched 240-second run, the unpatched kernel hit the target fault in 3=
/4
guests and the patched kernel had no target crash in 4/4 guests. The C
reproducer was confirmed to start on both sides. This supports the code cha=
nge
for the tested scenario; it is not a claim of general regression safety.

Context:
mxl111sf_probe() assigns state->d and initializes fe_lock before the I2C
adapter is published; the later back-pointer stores are redundant. The MxL1=
11SF
introduction, 4c66c9205c07 ("[media] dvb-usb: add ATSC support for the
Hauppauge WinTV-Aero-M"), already registered I2C before frontend attachment
and assigned state->d only during frontend attachment. The later 8572211842=
af
DVB USB v2 conversion did not introduce that ordering defect. Syzkaller
appends Fixes: from patch metadata after the generated description.

The selected historical-kernel run had four setup attempts, all stopped bef=
ore
the reproducer started. It therefore supplies neither a repro nor a no-repro
result. Source-order checks did not exercise an I2C transfer concurrently w=
ith
disconnect. Resolve the historical setup failure and exercise that overlap
before claiming those cases are covered.

Impact assessment:=20
A userspace I2C transaction through the registered adapter
can reach the null back pointer and cause a kernel oops; panic-on-oops poli=
cy
can turn that into an outage. No confidentiality or integrity effect is pro=
ven.

Kind Regards / Mit freundlichen Gr=C3=BC=C3=9Fen
BART CHRONOWSKI

On Mon, Oct 19, 2026 at 03:45:05PM +0000, 'syzbot' via syzkaller-upstream-m=
oderation wrote:
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
> dvb_usbv2_generic_write() triggers a null-pointer dereference crash:
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
> uninitialized during frontend registration.
>=20
> Fix this by setting state->d =3D dev and initializing state->fe_lock in
> mxl111sf_probe(), which runs before dvb_usbv2_init() registers the I2C
> adapter or attaches frontends. Furthermore, remove the redundant
> mutex_init(&state->fe_lock) from mxl111sf_init() and the redundant
> assignments of state->d in the frontend attach functions.
>=20
> Fixes: 8572211842af ("[media] mxl111sf: convert to new DVB USB")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+f9f5333782a854509322@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3Df9f5333782a854509322
> Link: https://syzkaller.appspot.com/ai_job?id=3D0eff5308-2f93-4b3a-b8d1-0=
21ddc25aa49
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> To: "Michael Krufky" <mkrufky@linuxtv.org>
> To: "Antti Palosaari" <crope@iki.fi>
> Cc: <linux-kernel@vger.kernel.org>
>=20
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
>=20
> --=20
> You received this message because you are subscribed to the Google Groups=
 "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an=
 email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller=
-upstream-moderation/b8b6fc2d-1c9a-4046-bba5-c9ef864bfae3%40mail.kernel.org.
