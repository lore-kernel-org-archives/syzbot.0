Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794573267;
	b=qCzDgDRbSOSpn94D/hWYYvYjdzXWqgw0kzmCyErDesYj19CGjPqVr+68rkx5AaL8ifV3
	 VdxwKirh0pGxhzrXNyZOHj9GsqxSy5Yd8ZPkMsHHpgLv5Xn08GvyZ3mnhgVazGh8Gyz0y
	 YA5UkGz2ze3hBkROoBfvhk2Y3p3Xt4au4vBtfS6oaEH870AShdfR+NnOgJpdfJ/ENuD+C
	 9mUVAVexjzbqv5TMd6RGj00GReoAONIOw2p6quoHrGdaih7dTH/0r+CxvIOUfm72s1+zU
	 e/K5Gl6qx+C40HyzexT9ZbbKtS+ESXz/1qwt3WXTQO2lds2AXoDUaNJMesohFUyheyA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794573267;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=/z3z0myIxh1PdyMu4DpOzI5hO72oLXWmo6VNQyNO4Rg=;
	b=JrZa5uyiplM5E2TCI/TuWSdWAil+ookY65FgNfDfKiM/ch6roneaxl+4SM9lh7Jhs4ho
	 32S2pz3Zid4y9SzO6OV2hlVTCHm/WNeqNqrCp2zA6n4O+oeXUUHBrVvAQFW4vfKY4FzEe
	 6QUac8WwANiF0JLCkKYeSXGszYBKC66h/khuzbM79jW2pZLW0L2DQEJhq2HG21dSurmi0
	 CpHcvf1qJucdqD8xmoghbvlny/7TK0kW4qIQDV9weLlzvfzZcO2H/+EMynGXjHx7x1BTj
	 M44Kz06OST1BIcgrqANWnCWYmrj9EJu8GwQ0AmdhWulJoQLVQ09vjCjofa8C0bHpxHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GO0CfO8Z;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72267606A899
	for <syzbot@lists.linux.dev>; Fri, 13 Nov 2026 12:34:26 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 72267606A899
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=GO0CfO8Z
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c5075fa7ed0so202683366b.2
        for <syzbot@lists.linux.dev>; Fri, 13 Nov 2026 04:34:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1794573265; x=1795178065; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=/z3z0myIxh1PdyMu4DpOzI5hO72oLXWmo6VNQyNO4Rg=;
        b=GO0CfO8Zi8kVwQLxEBxZP3ngYTjb3Z5JwgeoUe5XVyqwgdHAq0sFS+R1Rotz85JG/x
         emZXvyD3umIzW55rgH2NAdxuR1+UM1CD9DKxtWs68ouFv/UFLfBF846q5R2wbfhBJElv
         jdXcY31D1F2+N8YOg/N+prgCiIsmh4b3L2iBP2WB5UQPx5qPoFw+YDNl38VTOu+/QYwe
         E5+laopRVCdtX35zoUQ//J2yYB1vrEDOyl3pX5749JlGbfQc5NYmKofNNrU1wIda/k+X
         kagwohfDI0jpkNUHemUmVdAQuZFy7aUVykvXX3paL2DTOSqwGPFV8WeDxmcp+s6hx572
         245w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1794573265; x=1795178065;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=/z3z0myIxh1PdyMu4DpOzI5hO72oLXWmo6VNQyNO4Rg=;
        b=yK7byOIWcQUcFT2XLb8IW/lptqQWKntiA4oRZ3OOw7OWn07h25KcmTARr/aq3+auy6
         zAqutTlTqoGqPlokXL22DXHg+2lyjojyOdQOov0papmg6/9Unc70aF4Gmr2q5nNxcSug
         p1oI5jsRZgzuUkeHmHDb2wWkKYf7okeFJGiaeeFgCCuKZYhKMf/7GsAaT/aFLCYLuFBh
         JOZGWSgOc6SLKCMfOYFZ7JeFNeqDzeUgwp+FSNvQPZWC4KCbEzhXQYGDkaS+T6njV5Ou
         Hf6qzQcfdu4oiLkXSEMTztJagYFLSpkjtDM5B8STnOyzXNVua6eFVC/fMs0p1ACCyASi
         sGBw==
X-Forwarded-Encrypted: i=1; AL+hErGi5awnHmgDxeAjJLrF7InJh6iOu+3PncvyFk5HOI4CBuBwrpeUxQ5ypDZpnPOXY4CFn6jTvLo=@lists.linux.dev
X-Gm-Message-State: APuU4Z9rBlqTWbPPjzdl6hQPFRaOkF58hCOn/usBOYY0ZbWl9qf2Iwe/
	3EsNLeMzYl11RZHJ3dMK41Rm5RozxKyFXNhiGA4aMcHHf9mtAKYi25Kl
X-Gm-Gg: AYBFou1puxjOnvKpz/E4umDGkjBpGqusdfOb1ebcEbILsZ3AmweQWYkvEakV02Ro2rX
	VwP82o3TnRavZyOCWCY7qcmjb/QKlG9mNsF913VLwzD46eiTXFgvYNs0kuNQCzTt1Xn4GnRWQpA
	Q7sW+uLoQBexiybYY9wNsBFGUNDVaCmnS90n2L5upC9zUeS7Tmv+LldoyP9LTD+rcKPuErgkeF9
	Q6dRBVY1Fsydf8h/d7qd0jCF5sfp56i2P87bLuC8HAdv01dCaar/aFa632qKA05nZpP0JXnVVfD
	6YqvG9FpsYN5616A+BMdQZKyNwJEjEB0De6X3F5UydF2GdS1DscK5OL1Af2bNYTBvPCZKRgrC6I
	WUqEvrdDr2S42XPs4AsZYuoF7BRRbgYsX9LGTwud0PWhuiD0Awekw7Pro3hDu5FL+ZCxNaJqK6K
	tr9p9TC5cJKFRtW23Guz5VoIUze74BJCxcPDk4zTgWbKaVwwEa41s++yDCdDDg0v3WkC9n3QJfD
	AzNTZCAk9HDmY3OiM1mr2MhEfUvogJum3ieHAjwpBtUqwos5PrfZ5TGpuSD3tO26f4DeUzcQuT1
	awdzb+AQfMkFTnxXQHog75UFzq2yO+YHS3DhMoUuFYNN7o1L
X-Received: by 2002:a17:907:9345:b0:c3f:8c92:3b51 with SMTP id a640c23a62f3a-c509611011cmr212382066b.4.1794573264610;
        Fri, 13 Nov 2026 04:34:24 -0800 (PST)
Received: from localhost ([188.146.170.61])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c5095b6091dsm86941166b.57.2026.11.13.04.34.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Nov 2026 04:34:24 -0800 (PST)
Date: Fri, 13 Nov 2026 13:34:23 +0100
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] media: dw2102: Fix null-ptr-deref in i2c transfer
 callbacks
Message-ID: <5rsvymmu6xd7amjhapko7yyu2imvo23xlqp7mjoog33uoyqe7f@3unpa5o6cy4u>
References: <9dda9080-8d80-4504-95dd-0faef04af12d@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9dda9080-8d80-4504-95dd-0faef04af12d@mail.kernel.org>

The two SU3000 length checks in v1 are correct; no code change is requested
in this review. The matched runs support the SU3000 fix; correct the commit
message and clarify the history of the additional fixes before submission.

Required changes:
- Commit message: Drop the kmalloc_track_caller() claim. Explain that a
  zero-length memdup_user() can return ZERO_SIZE_PTR and that the callback
  accesses the buffer without checking its length; the internal allocator
  helper's name is not needed.
- Commit message: The description already identifies missing length checks
  in the other five callbacks. State the minimum length for each guarded
  command, and distinguish the Earda message-index fix: with num == 1, the
  oversized-write warnings read msg[1].len outside the message array. Describe
  this as an out-of-bounds read, not just an incorrect diagnostic.
- Metadata: Keep Fixes: d2ffc447cabb tied to the original SU3000 access;
  do not imply that it identifies the introducing commit for the other
  callbacks. Have the eventual submitter verify tool attribution against the
  intended submission tree's documentation and checkpatch rules.

Testing:
On base commit c03c1a14507d, the direct x86-64 C reproducer at
https://syzkaller.appspot.com/text?tag=ReproC&x=1667ea31580000 hit the
su3000_i2c_transfer() first-byte fault in 4 of 4 unpatched test VMs. The
patched kernel had 0 target crashes in 4 test VMs with the same input and a
byte-identical effective config. The runs lasted about 55 and 45 seconds,
including boot.

Separately, the SU3000-only change was tested on base 05441d697f7f with
https://syzkaller.appspot.com/text?tag=ReproSyz&x=1130a1a5580000 in 32-bit
repeat/threaded mode. Its complete SU3000 callback is identical to v1's.
The unpatched kernel crashed in 4 of 4 test VMs; the patched kernel completed
300-second runs in 4 test VMs without a target crash. KCOV probes confirmed
callback entry and EOPNOTSUPP for the stream command and for zero- and
one-byte RC queries. These results cover the SU3000-only change on that base,
not the complete v1 patch. The original
standalone 32-bit C comparison remains inconclusive. The sanitizer-backed
callback tests use USB stubs and do not establish physical-device behavior.

Syzbot flow request:
For runtime claims about the other five callbacks, exercise their short and
valid command paths, alternate read flags and error unlock paths. The
SU3000 results do not establish those outcomes.

Context:
A zero-length stream-control message reaches su3000_i2c_transfer() without a
readable first byte. The one-byte guard now runs before buf[0] is read.
Separate 2025-08-18 reports place a zero-length remote-query fault at the
buf[1] write; the two-byte guard protects that access. Invalid calls take the
existing mutex unlock paths, while valid in-driver commands still pass.

Impact assessment:
A zero-length SU3000 stream command can oops the DVB USB driver when the
adapter and device node are accessible. The selected config can panic on that
oops.

Kind Regards,
BART CHRONOWSKI

On Mon, Oct 19, 2026 at 03:10:34PM +0000, 'syzbot' via syzkaller-upstream-moderation wrote:
> When user space issues an I2C_RDWR ioctl on an exposed I2C device
> (/dev/i2c-X) with a zero-length message (msg.len == 0), i2cdev_ioctl_rdwr()
> allocates the message buffer using memdup_user(..., 0). This causes
> kmalloc_track_caller() to return ZERO_SIZE_PTR (0x10). When
> su3000_i2c_transfer() subsequently processes the request, commands such as
> SU3000_STREAM_CTRL unconditionally dereference msg[j].buf[0] without
> verifying that msg[j].len is at least 1. Dereferencing ZERO_SIZE_PTR leads
> to a general protection fault and KASAN null-ptr-deref report.
> 
> Oops: general protection fault, probably for non-canonical address
> 0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
> KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
> RIP: 0010:su3000_i2c_transfer+0x1aa/0xfc0
> drivers/media/usb/dvb-usb/dw2102.c:740
> Call Trace:
>  <TASK>
>  __i2c_transfer+0x7bf/0x1fe0 drivers/i2c/i2c-core-base.c:-1
>  i2c_transfer+0x1cb/0x2d0 drivers/i2c/i2c-core-base.c:2350
>  i2cdev_ioctl_rdwr+0x460/0x740 drivers/i2c/i2c-dev.c:306
>  i2cdev_ioctl+0x6a5/0x880 drivers/i2c/i2c-dev.c:467
>  vfs_ioctl fs/ioctl.c:51 [inline]
>  __do_sys_ioctl fs/ioctl.c:597 [inline]
>  __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
>  do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
>  do_syscall_64+0x155/0x510 arch/x86/entry/syscall_64.c:84
>  entry_SYSCALL_64_after_hwframe+0x77/0x7f
>  </TASK>
> 
> Although dw2102_i2c_transfer() was previously fixed for this issue in
> commit 5ae544d94abc ("media: dw2102: Fix null-ptr-deref in
> dw2102_i2c_transfer()"), other transfer callbacks in
> drivers/media/usb/dvb-usb/dw2102.c (su3000_i2c_transfer,
> dw2102_serit_i2c_transfer, dw2102_earda_i2c_transfer, dw2104_i2c_transfer,
> dw3101_i2c_transfer, and s6x0_i2c_transfer) also accessed msg[].buf without
> checking msg[].len during operations such as DW2102_RC_QUERY,
> DW2102_VOLTAGE_CTRL, DW2102_LED_CTRL, and default write commands.
> Additionally, dw2102_earda_i2c_transfer() incorrectly logged msg[1].len
> instead of msg[0].len in warning messages for single-message transfers.
> 
> Fix these issues by validating msg[].len against the minimum required size
> before indexing into or copying to msg[].buf in all dw2102 I2C transfer
> callbacks, returning -EOPNOTSUPP on failure, and correct the message index
> in dw2102_earda_i2c_transfer() warning logs.
> 
> Fixes: d2ffc447cabb ("[media] dw2102: add support for Geniatech SU3000 USB DVB-S2 card")
> Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+d99f3a288cc7d8ef60fb@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d99f3a288cc7d8ef60fb
> Link: https://syzkaller.appspot.com/ai_job?id=d863a1b0-1ca0-4436-b7e6-658d0c1cc4be
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> To: "Igor M. Liplianin" <liplianin@me.by>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
> index 4fecf2f96..a76bc2887 100644
> --- a/drivers/media/usb/dvb-usb/dw2102.c
> +++ b/drivers/media/usb/dvb-usb/dw2102.c
> @@ -265,12 +265,20 @@ static int dw2102_serit_i2c_transfer(struct i2c_adapter *adap,
>  				     msg[0].len + 2, DW210X_WRITE_MSG);
>  			break;
>  		case(DW2102_RC_QUERY):
> +			if (msg[0].len < 2) {
> +				num = -EOPNOTSUPP;
> +				break;
> +			}
>  			dw210x_op_rw(d->udev, 0xb8, 0, 0,
>  				     buf6, 2, DW210X_READ_MSG);
>  			msg[0].buf[0] = buf6[0];
>  			msg[0].buf[1] = buf6[1];
>  			break;
>  		case(DW2102_VOLTAGE_CTRL):
> +			if (msg[0].len < 1) {
> +				num = -EOPNOTSUPP;
> +				break;
> +			}
>  			buf6[0] = 0x30;
>  			buf6[1] = msg[0].buf[0];
>  			dw210x_op_rw(d->udev, 0xb2, 0, 0,
> @@ -334,7 +342,7 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
>  
>  			if (2 + msg[0].len > sizeof(obuf)) {
>  				warn("i2c wr: len=%d is too big!\n",
> -				     msg[1].len);
> +				     msg[0].len);
>  				ret = -EOPNOTSUPP;
>  				goto unlock;
>  			}
> @@ -352,7 +360,7 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
>  
>  			if (2 + msg[0].len > sizeof(obuf)) {
>  				warn("i2c wr: len=%d is too big!\n",
> -				     msg[1].len);
> +				     msg[0].len);
>  				ret = -EOPNOTSUPP;
>  				goto unlock;
>  			}
> @@ -367,6 +375,10 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
>  		case(DW2102_RC_QUERY): {
>  			u8 ibuf[2];
>  
> +			if (msg[0].len < 2) {
> +				ret = -EOPNOTSUPP;
> +				goto unlock;
> +			}
>  			dw210x_op_rw(d->udev, 0xb8, 0, 0,
>  				     ibuf, 2, DW210X_READ_MSG);
>  			memcpy(msg[0].buf, ibuf, 2);
> @@ -375,6 +387,10 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
>  		case(DW2102_VOLTAGE_CTRL): {
>  			u8 obuf[2];
>  
> +			if (msg[0].len < 1) {
> +				ret = -EOPNOTSUPP;
> +				goto unlock;
> +			}
>  			obuf[0] = 0x30;
>  			obuf[1] = msg[0].buf[0];
>  			dw210x_op_rw(d->udev, 0xb2, 0, 0,
> @@ -407,6 +423,10 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
>  		case(DW2102_RC_QUERY): {
>  			u8 ibuf[2];
>  
> +			if (msg[j].len < 2) {
> +				ret = -EOPNOTSUPP;
> +				goto unlock;
> +			}
>  			dw210x_op_rw(d->udev, 0xb8, 0, 0,
>  				     ibuf, 2, DW210X_READ_MSG);
>  			memcpy(msg[j].buf, ibuf, 2);
> @@ -415,6 +435,10 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
>  		case(DW2102_VOLTAGE_CTRL): {
>  			u8 obuf[2];
>  
> +			if (msg[j].len < 1) {
> +				ret = -EOPNOTSUPP;
> +				goto unlock;
> +			}
>  			obuf[0] = 0x30;
>  			obuf[1] = msg[j].buf[0];
>  			dw210x_op_rw(d->udev, 0xb2, 0, 0,
> @@ -444,6 +468,9 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
>  					     DW210X_READ_MSG);
>  				memcpy(msg[j].buf, ibuf + 2, msg[j].len);
>  				mdelay(10);
> +			} else if (msg[j].len < 1) {
> +				ret = -EOPNOTSUPP;
> +				goto unlock;
>  			} else if (((msg[j].buf[0] == 0xb0) && (msg[j].addr == 0x68)) ||
>  				   ((msg[j].buf[0] == 0xf7) && (msg[j].addr == 0x55))) {
>  				/* write firmware */
> @@ -557,6 +584,10 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  		case(DW2102_RC_QUERY): {
>  			u8 ibuf[2];
>  
> +			if (msg[0].len < 2) {
> +				ret = -EOPNOTSUPP;
> +				goto unlock;
> +			}
>  			dw210x_op_rw(d->udev, 0xb8, 0, 0,
>  				     ibuf, 2, DW210X_READ_MSG);
>  			memcpy(msg[0].buf, ibuf, 2);
> @@ -597,6 +628,10 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  		case (DW2102_RC_QUERY): {
>  			u8 ibuf[5];
>  
> +			if (msg[j].len < 2) {
> +				ret = -EOPNOTSUPP;
> +				goto unlock;
> +			}
>  			dw210x_op_rw(d->udev, 0xb8, 0, 0,
>  				     ibuf, 5, DW210X_READ_MSG);
>  			memcpy(msg[j].buf, ibuf + 3, 2);
> @@ -605,6 +640,10 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  		case (DW2102_VOLTAGE_CTRL): {
>  			u8 obuf[2];
>  
> +			if (msg[j].len < 2) {
> +				ret = -EOPNOTSUPP;
> +				goto unlock;
> +			}
>  			obuf[0] = 1;
>  			obuf[1] = msg[j].buf[1];/* off-on */
>  			dw210x_op_rw(d->udev, 0x8a, 0, 0,
> @@ -618,6 +657,10 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  		case (DW2102_LED_CTRL): {
>  			u8 obuf[2];
>  
> +			if (msg[j].len < 1) {
> +				ret = -EOPNOTSUPP;
> +				goto unlock;
> +			}
>  			obuf[0] = 5;
>  			obuf[1] = msg[j].buf[0];
>  			dw210x_op_rw(d->udev, 0x8a, 0, 0,
> @@ -647,6 +690,9 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  						DW210X_READ_MSG);
>  				memcpy(msg[j].buf, ibuf, msg[j].len);
>  				break;
> +			} else if (msg[j].len < 1) {
> +				ret = -EOPNOTSUPP;
> +				goto unlock;
>  			} else if ((msg[j].buf[0] == 0xb0) && (msg[j].addr == 0x68)) {
>  				/* write firmware */
>  				u8 obuf[19];
> @@ -737,6 +783,10 @@ static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  	while (j < num) {
>  		switch (msg[j].addr) {
>  		case SU3000_STREAM_CTRL:
> +			if (msg[j].len < 1) {
> +				num = -EOPNOTSUPP;
> +				break;
> +			}
>  			state->data[0] = msg[j].buf[0] + 0x36;
>  			state->data[1] = 3;
>  			state->data[2] = 0;
> @@ -745,6 +795,10 @@ static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
>  				err("i2c transfer failed.");
>  			break;
>  		case DW2102_RC_QUERY:
> +			if (msg[j].len < 2) {
> +				num = -EOPNOTSUPP;
> +				break;
> +			}
>  			state->data[0] = 0x10;
>  			if (dvb_usb_generic_rw(d, state->data, 1,
>  					       state->data, 2, 0) < 0)
> 
> 
> base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
> -- 
> This is an AI-generated patch subject to moderation.
> Reply with '#syz upstream' to Sign-off the patch as a human author
> and send it to the upstream kernel mailing lists.
> Reply with '#syz reject' to reject it ('#syz unreject' to undo).
> 
> See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
> You can comment on the patch as usual, syzbot will try to address
> the comments and send a new version of the patch if necessary.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
> 
> -- 
> You received this message because you are subscribed to the Google Groups "syzkaller-upstream-moderation" group.
> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-upstream-moderation+unsubscribe@googlegroups.com.
> To view this discussion visit https://groups.google.com/d/msgid/syzkaller-upstream-moderation/9dda9080-8d80-4504-95dd-0faef04af12d%40mail.kernel.org.
