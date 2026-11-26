Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.44
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795695254;
	b=1DbrbRxR2Srt2qWVe4we01zfkwOQdqR1JDNyMlN20mke7xLyTE+1uwMKiBLF1QMMhduQ
	 aRCsFReNPfd6p3LBWw/b2G38k3ER3uSZuEdRXxwmk0yiLhS77qiZDPrNonr8C3OXzJm5R
	 rhVwBEoP3j2YEn1RYP9Qn6ZlRmHBOgNS0aACtywQsNGKmL+Xk90Azrrslqba8bn0IPz4I
	 Sv3r8zYyJe6KVzKihPwUs4pzJdNJ1l6ALEtT27CxmHvhTURJeVvypQAMzwoj6sCorrcrA
	 ZgEEx+JqZlipbaQZEo+e8KULMs7KGOW9fjjZf7Ba5cuhI/x1PGk9W7qhQtZyzqZm2Ew==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795695254;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To;
	bh=iyrSn7xnZudht5kzfg1ucLVcEBXH3idFpoB9/LIt5os=;
	b=qpW7yl3ssk5KuL6xKEoKayjmF9Af+UnGZrssHZOxN9FkMHaGmgY/8xJ5lQMFQSKwbv4Y
	 UY77vb6Maun98G4BXNT2wS1jZpsEWMzlDJx3FOm6x7BGeJfftgf93UntvB2eEui0ynOdO
	 Ijq34aM90LOvDicGJeU07CsOWAFaoMgk1hd3dN9XXwZxKGWGWgNKB2E7KV86PxaVgCu5G
	 hdHJmJVzSmRhqISZRbJ86r4toa0AW/0UvI5cBA2D+hQc5Vn23T/G2ia6qhid/0e5dE9Xg
	 7V2aycaaL5UxvroHQ+lZdtQaYtN3P1tNGu89EVC0/w3Dp+kwQgSqVXzd0pqQmnBXrtQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=np8ZBzDM;
	arc=none smtp.remote-ip=209.85.218.44
Received: from mail-ej1-f44.google.com (mail-ej1-f44.google.com [209.85.218.44])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C5A66606A31C
	for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 12:14:13 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org C5A66606A31C
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=np8ZBzDM
Received: by mail-ej1-f44.google.com with SMTP id a640c23a62f3a-c505b2e1cb9so1266041266b.2
        for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 04:14:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1795695252; x=1796300052; darn=lists.linux.dev;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:from:to:cc:subject
         :date:message-id:reply-to:content-type;
        bh=iyrSn7xnZudht5kzfg1ucLVcEBXH3idFpoB9/LIt5os=;
        b=np8ZBzDMK44sOblNO7fkEWv89pwu44y5Oro7lFM+GpntCrGFYMOEQrJ2tRwmiTqai2
         vqZc4V0sZt2e0CfPdyghIRMwbycKT0P6QrQmBVgZFzlUHKc6sz4UHBue/PJ7fgrsGFYO
         PdyJdDeoLpKSku+RTbWerJpo3MchFPpKHkAHC/9scraetkcWP5n5HzqAg+8puMBzoDer
         7SnoNsP1GMHtXLg1QSXJsWj/hKP9UIG9K89wXp9ZNOdrBwScGwvKcSW59TYlygTB0wo8
         7Tc9l7gigzhC6thJlBB4AMFIrjMHq1uIq//IWCbZ8GRuD1ltVRejtHBXdO7OEWj7rYOn
         WXJQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1795695252; x=1796300052;
        h=in-reply-to:content-disposition:content-type:mime-version
         :references:message-id:subject:cc:to:from:date:x-gm-gg
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=iyrSn7xnZudht5kzfg1ucLVcEBXH3idFpoB9/LIt5os=;
        b=XJvLJQjhH/ANqwUdnh4O8Ex6nZ3p+mtM5czvU88J15QpQeqtoW1zK5ixqD6nictBkG
         bE2r04a5IwPI5YO/zaADbYI8lh9COxs0RMxWVEGUd5AxCwD9De0aw5aVej8SjSrY9tjS
         lATn6ir7h4x45tiaLnWKZIcJy+JBJoto61CAvNBCC6AmuosDopo+CHqnDL3xU6do4Rj7
         Zb/9T2JzVlPoJfD68kXLv8bxuFwsbIxN4WObcePhz2/NctGZJ+MQHJ9He9HQkBbqMbnk
         7R86rz1D3hLqaYguONRh6p29hqqDBkJZqemviPOxa13JMy0vnpbIA3uIUHmkx7HB9ZZK
         ohrg==
X-Forwarded-Encrypted: i=1; AL+hErEgJ8Bhd6f1LrZ7aaYPT4/FlNLDNkIq5WmiFLZvUWELlW3/P3CLuZp182J/BkiOYAmfv9SSsO4=@lists.linux.dev
X-Gm-Message-State: APuU4Z8YDbr8eQSePwzor4l+R3lCh9Roecy9nPWATOwUj+u5bRTqL5bC
	XlTrbl9lrd934ZEM5WWyoOvlB7LDiW+SJcnLMR+grjk3wnDaBKUJgaDHj2CcmQDI
X-Gm-Gg: AZFdTZeBo694eHFWU13JW3z99sbEwB3HHt30BxItRjAQ269Ao4vbT/puVLP1cm/ncx/
	pEObUqiUWfevvEqJS3qN92KoY6u7FT+edqEueIS5Z+LCErLZZADJFxAqHxkEm0qeZcJX4wq1XaV
	LslD+yy2cKi7nDR8Pzt9FiQVX/3slMsCydon0hadE412dwkQDLXOG1n6IE118Fm/LxxxigKGo2x
	f8KW2LojWLIPvkS/Si2A7PwFHsyFCzmsFusjs5a8dId/5IDMurWaXUGbMim24iffHzLbG0dY1Td
	0r8t7fRVQCcjR7y7qgR2zns+5LpeZANsMOvW9ceGpPN0AyGtCRbNymakwH2RIO7iiSqZ8WjjSc9
	GE5IFZxtd/PNgbrcGzvU/PWVqoUQidb9qU1gb07pf1MTkbNPxPLhTAiHkKnX00Ke8dAtVm7z5fi
	F75BrpmJuXhKqT+UaFaGbt3VoMlT4k6mrNzSmyVMI7DE38BPYQoug1rOxzLKth8vqlOwIlyNR/m
	eu6gkoYGs/mkwxqoGig97S1hLYJ31bvdkopgs3zDTbq6hTdnGqc9K1XKNnlkHVLsCBGmw4Gc5o1
	R6stNOYGecOqKYzwRJukgT9Zj6GcMgcLtWTilCOY4OzEajZieg==
X-Received: by 2002:a17:906:1553:b0:c50:576f:b39e with SMTP id a640c23a62f3a-c513ab0cf13mr1155892166b.26.1795695251968;
        Thu, 26 Nov 2026 04:14:11 -0800 (PST)
Received: from localhost ([188.146.172.182])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c513ae8db37sm745158566b.35.2026.11.26.04.14.11
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 26 Nov 2026 04:14:11 -0800 (PST)
Date: Thu, 26 Nov 2026 13:14:10 +0100
From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] media: dw2102: Fix null-ptr-deref in i2c transfer
 callbacks
Message-ID: <l4sn37skbfbdcnyozxk6sxoixtpf64l6uzs6cyqj5z2k6fvgmg@ypbqhwhmjqlt>
References: <c05e1655-d5b4-445d-aebf-e06ba6b44ad2@mail.kernel.org>
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
In-Reply-To: <c05e1655-d5b4-445d-aebf-e06ba6b44ad2@mail.kernel.org>

The v2 SU3000 guards cover the reported stream-control and RC-query faults.
The patch also rejects ordinary zero-length writes in dw2104_i2c_transfer() and
s6x0_i2c_transfer(), which those callbacks previously passed to USB. The
patch needs that code regression fixed and its duplicate Fixes: line removed.

Required changes:
- Commit message: Remove the description-embedded Fixes: d2ffc447cabb
  ("[media] dw2102: add SU3000 support") line. The rest of the corrected
  allocator, command-length, and Earda explanation can stay.
- Code: In the default write branches of dw2104_i2c_transfer() and
  s6x0_i2c_transfer(), check the length before inspecting buf[0] for a
  firmware command without rejecting every zero-length ordinary write. Let
  those writes follow their existing register-write path.

Kind Regards
BART CHRONOWSKI

On Fri, Nov 13, 2026 at 01:46:36PM +0000, syzbot wrote:
> When user space issues an I2C_RDWR ioctl on an exposed I2C device
> (/dev/i2c-X) with a zero-length message (msg.len == 0), i2cdev_ioctl_rdwr()
> allocates the message buffer using memdup_user(), which returns
> ZERO_SIZE_PTR (0x10) for a length of 0. When su3000_i2c_transfer()
> subsequently processes the request, it accesses the buffer without checking
> its length, unconditionally dereferencing msg[j].buf[0] for
> SU3000_STREAM_CTRL commands. Dereferencing ZERO_SIZE_PTR leads to a general
> protection fault and KASAN null-ptr-deref report.
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
> Commit d2ffc447cabb ("[media] dw2102: add SU3000 support") specifically
> introduced the SU3000 support and the unvalidated buffer access in
> su3000_i2c_transfer(). In addition, similar missing length checks exist
> across the other transfer callbacks in drivers/media/usb/dvb-usb/dw2102.c
> dating back to their original introductions, while dw2102_i2c_transfer()
> was previously fixed in commit 5ae544d94abc ("media: dw2102: Fix
> null-ptr-deref in dw2102_i2c_transfer()"). Specifically, SU3000_STREAM_CTRL
> requires msg[j].len >= 1 to read msg[j].buf[0]; DW2102_RC_QUERY requires
> msg[].len >= 2 to store the 2-byte query response across all callbacks;
> DW2102_VOLTAGE_CTRL requires msg[].len >= 1 in dw2102_serit_i2c_transfer,
> dw2102_earda_i2c_transfer, and dw2104_i2c_transfer to read msg[].buf[0],
> but requires msg[j].len >= 2 in s6x0_i2c_transfer to read msg[j].buf[1];
> DW2102_LED_CTRL requires msg[j].len >= 1 in s6x0_i2c_transfer to read
> msg[j].buf[0]; and default firmware write paths in dw2104_i2c_transfer and
> s6x0_i2c_transfer require msg[j].len >= 1 to inspect msg[j].buf[0].
> Additionally, dw2102_earda_i2c_transfer() suffered from an out-of-bounds
> read when num == 1 by reading msg[1].len outside the message array in
> warning logs when validating the transfer buffer size.
> 
> Fix these issues by validating msg[].len against each command's minimum
> required size before indexing into or copying to msg[].buf across all
> dw2102 I2C transfer callbacks, returning -EOPNOTSUPP on failure, and
> correct the out-of-bounds read in dw2102_earda_i2c_transfer() by
> referencing msg[0].len.
> 
> Fixes: d2ffc447cabb ("[media] dw2102: add SU3000 support")
> 
> Fixes: d2ffc447cabb ("[media] dw2102: add support for Geniatech SU3000 USB DVB-S2 card")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+d99f3a288cc7d8ef60fb@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=d99f3a288cc7d8ef60fb
> Link: https://syzkaller.appspot.com/ai_job?id=6254b526-6207-4b74-8e04-87bfa788d3aa
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> To: "Igor M. Liplianin" <liplianin@me.by>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v2:
> - Clarified that zero-length memdup_user() returns ZERO_SIZE_PTR and dropped the reference to kmalloc_track_caller().
> - Documented the minimum required length for each guarded command across the transfer callbacks.
> - Described the msg[1].len access in dw2102_earda_i2c_transfer() as an out-of-bounds read when num == 1.
> - Clarified the history of the fixes, tying Fixes: d2ffc447cabb specifically to su3000_i2c_transfer().
> 
> v1:
> https://lore.kernel.org/all/9dda9080-8d80-4504-95dd-0faef04af12d@mail.kernel.org/T/
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
