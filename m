Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E87B22AD35
	for <syzbot@lists.linux.dev>; Mon,  5 Oct 2026 10:02:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791194562; cv=pass; b=BlEjFqpmdp13BpQWIJPtovfbvLvuHyazNUXF5m0e7261QV3+0Z1EzM9e0xAJQ+YQuNN5V/6gAWC9jmT39koSwN1Tg+nFNQ49VUauvWjnYy208d6fJxJXWpaXZMxUzEM/ZC7ATpXBVFSMO9e59aKFYh6VGJm4LcPyQKGsTvQ4qWg=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791194562; c=relaxed/simple;
	bh=Q1o4IR9k+4YlBlGo2smC1NACkSHUJ5eTZq+rsrQ7vG8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=J+X1waAxUqylLhgHD7QpxO4FO9cyMgkBPhW6oUcGoNcq2PKKSaHQC98RsDvLfNxIIWYXPxZL9FbVhTsy4pF9LBO7ZBZsh0WduRXYqsx0Yum6i5DmiQCCf/qMmh8gxs5GXD+G13CyMOaCv5kjRCGWkYiTMe6qzU9R++Kv1WPHqAE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=D17Xe8OU; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="D17Xe8OU"
Received: by smtp.kernel.org (Postfix)
	id E2DF41F00893; Mon,  5 Oct 2026 10:02:39 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.75
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1791194559;
	b=Q3Ziixfv4D8RwDH2pIJ1XYOqUhrcOvdlcJNeX8rTQuBlWKPA/9cZs0R8kBGxubBiCfX6
	 ElIb2LlWDA/rX8kKokLKZEjZs8xeIE3gtqay2c8GcTpcnO4RkG3CM3+lmkbWEjSj6oJVO
	 bMhIAvsWvowfXj7U3CpriE9ebgdZu8kGWjm0ut4BtKE7FlBU/QMXUihFIpN9Bg9qUi2D1
	 brVQeNDoA7bn/AW8JbOaOZWVOWNoL4Z/B+5eAnx1SoL6tgoqXGCLZlDIa5ghlGDS7rWYy
	 Zvgz5yzTzB0bMoPtSvGXDfHCBebikRFupn3+U5gF2pbf3enAzar0H4GbegZ42AskbQA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1791194559;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=15TOeObXhLY0jpw6/YNN69SS1kCX78z5bIemSqGAC+k=;
	b=WXyZsHm+f42LAMp/axrVTMoHpXAHsLM2l1ud6yRPfmUPShtHJrbcHLNbLzG7kWAIj3KK
	 ZyQOwWUMkTWcvU1OPQ1KfBBC61/DuainmE+0DI+VYUN+fymgKt2ojOK0RZR3AaxNRdohv
	 qYUvf6UeJw3QASyVR+he+hrO1UX47Xqd4SYxu2FICw38MJR2SuGSINCdn5K+LedC1tndC
	 NjWEHEuDFKECPwM3IIYRsZ/OJ7Rh9slSBlhxtoDsYiTC0/+V6TopN0YKZ+q13Vs1CJkkb
	 11Tzpa06CWo1aTa8QLY2cEIb9nNda6jxkEwzD1/VkBMywaLQQN+qbUgMf3fliklLdBw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=D17Xe8OU;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.75
Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 608AE1F000FF
	for <syzbot@kernel.org>; Mon,  5 Oct 2026 10:02:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=D17Xe8OU
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 608AE1F000FF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Mon,  5 Oct 2026 12:02:27 +0200 (CEST)
Date: Mon, 5 Oct 2026 12:02:25 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] media: dvb_frontend: fix OOB read in
 dtv_property_process_get()
Message-ID: <asN1sdDJVeOQgtYQ@nr200>
References: <2a5ea27d-445e-4ffe-9447-9d7bfccd4a36@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2a5ea27d-445e-4ffe-9447-9d7bfccd4a36@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1791194548; bh=15TOeObXhLY0jpw6/YNN69SS1kCX78z5bIemSqGAC+k=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=D17Xe8OUQUqjiKOv2Xw+0a2gMLPPtiX+DR6YWPehVNFR1IDlL1f8LTuR5FY7vkKbm
	 h4vX2h7gK86vcs/bfbPk3WNDFPu4gxsup/JNt/33UbFQjOtlXXSBEhzqDRPTLZRCXy
	 c4SOEv3nYzgEMsNwwrRjduMC/seXq93V7EB1lLs0=

On wrz 29, 2026 17:00, 'syzbot' via syzkaller-upstream-moderation wrote:
> In dtv_property_process_get(), properties requested via the FE_GET_PROPERTY
> ioctl are processed and copied back to userspace. In struct dtv_property,
> member u is a union containing __u32 data, struct dtv_fe_stats st, and
> struct buffer (which has __u8 data[32] followed by __u32 len at offset 32).
> Commit 60f0618d157b ("media: dvb-core: frontend: make GET/SET safer")
> introduced an out-of-bounds read and a data corruption issue due to
> mishandling this union.
> 
> For commands that only set tvp->u.data (such as DTV_FREQUENCY),
> tvp->u.buffer.len is never initialized by the kernel and retains whatever
> value userspace passed into the ioctl. At the end of
> dtv_property_process_get(), dev_dbg() unconditionally formatted the
> property using "%*ph", passing tvp->u.buffer.len as the field width and
> tvp->u.buffer.data as the buffer pointer. When dynamic debug is enabled and
> userspace supplies a large length value, vsprintf() emits a field width out
> of range warning, and hex_string() clamps the length to 64 bytes. Since
> struct dtv_property is 76 bytes long and u.buffer.data starts at offset 16,
> reading 64 bytes reaches offset 80 (4 bytes past the end of the slab
> object), triggering a KASAN slab-out-of-bounds read:
> 
> field width 1163001896 out of range
> WARNING: lib/vsprintf.c:2654 at vsnprintf+0xb9c/0xd10 lib/vsprintf.c:2918
> Call trace:
>  set_field_width lib/vsprintf.c:2654 [inline]
>  vsnprintf+0xb9c/0xd10 lib/vsprintf.c:2918
>  pointer+0x5e8/0x6b4 lib/vsprintf.c:2577
>  vsnprintf+0x618/0xd10 lib/vsprintf.c:2953
>  dev_vprintk_emit+0x2ec/0x3b4 drivers/base/core.c:5000
>  dev_printk_emit+0xe0/0x130 drivers/base/core.c:5011
>  __dynamic_dev_dbg+0x1b4/0x254 lib/dynamic_debug.c:904
>  dtv_property_process_get+0x26bc/0x2838
>  drivers/media/dvb-core/dvb_frontend.c:1595
>  dvb_get_property drivers/media/dvb-core/dvb_frontend.c:2397 [inline]
>  dvb_frontend_handle_ioctl+0x1644/0x2424
>  drivers/media/dvb-core/dvb_frontend.c:2478
>  dvb_frontend_do_ioctl+0x124/0x278
>  drivers/media/dvb-core/dvb_frontend.c:2101
>  dvb_usercopy+0x2a4/0x4d4 drivers/media/dvb-core/dvbdev.c:996
>  dvb_frontend_ioctl+0x68/0x8c drivers/media/dvb-core/dvb_frontend.c:2115
> BUG: KASAN: slab-out-of-bounds in hex_string+0x274/0x364
> lib/vsprintf.c:1209
> Read of size 1 at addr ffff0000c240314c
> 
> Additionally, commit 60f0618d157b added bounds checks that clamped
> tvp->u.buffer.len in all eight DTV_STAT_* cases. However, DTV_STAT_*
> commands populate tvp->u.st (struct dtv_fe_stats). In union u, u.buffer.len
> is located at offset 32, which directly overlaps bytes 3 to 6 of
> tvp->u.st.stat[3].uvalue (layer C statistics). Clamping and overwriting
> tvp->u.buffer.len therefore silently corrupted the statistics returned to
> userspace.
> 
> Fix this by only formatting with "%*ph" using tvp->u.buffer.len and
> tvp->u.buffer.data when tvp->cmd == DTV_ENUM_DELSYS, which is the only
> property command that populates the buffer union member. For all other
> commands, format tvp->u.data as "= 0x%08x". Furthermore, remove the bogus
> bounds clamping of tvp->u.buffer.len and the unused len variable from all
> DTV_STAT_* cases to prevent corruption of frontend statistics.
> 
> Fixes: 60f0618d157b ("media: dvb-core: frontend: make GET/SET safer")
> 
> Fixes: 60f0618d157b ("media: dvb-core: frontend: make GET/SET safer")
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+6102f1c3a0ea8073fd64@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=6102f1c3a0ea8073fd64
> Link: https://syzkaller.appspot.com/ai_job?id=8f3957bb-b063-4d03-9e7e-dca8802ba8a9
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> Cc: "Hans Verkuil" <hverkuil+cisco@kernel.org>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> Cc: "Ricardo Ribalda" <ribalda@chromium.org>
> 
> ---
> diff --git a/drivers/media/dvb-core/dvb_frontend.c b/drivers/media/dvb-core/dvb_frontend.c
> index 0286da57f..e57f1935c 100644
> --- a/drivers/media/dvb-core/dvb_frontend.c
> +++ b/drivers/media/dvb-core/dvb_frontend.c
> @@ -1348,7 +1348,6 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
>  				    struct file *file)
>  {
>  	int ncaps;
> -	unsigned int len = 1;
>  
>  	switch (tvp->cmd) {
>  	case DTV_ENUM_DELSYS:
> @@ -1358,7 +1357,6 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
>  			ncaps++;
>  		}
>  		tvp->u.buffer.len = ncaps;
> -		len = ncaps;
>  		break;
>  	case DTV_FREQUENCY:
>  		tvp->u.data = c->frequency;
> @@ -1536,51 +1534,27 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
>  	/* Fill quality measures */
>  	case DTV_STAT_SIGNAL_STRENGTH:
>  		tvp->u.st = c->strength;
> -		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
> -			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
> -		len = tvp->u.buffer.len;
>  		break;
>  	case DTV_STAT_CNR:
>  		tvp->u.st = c->cnr;
> -		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
> -			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
> -		len = tvp->u.buffer.len;
>  		break;
>  	case DTV_STAT_PRE_ERROR_BIT_COUNT:
>  		tvp->u.st = c->pre_bit_error;
> -		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
> -			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
> -		len = tvp->u.buffer.len;
>  		break;
>  	case DTV_STAT_PRE_TOTAL_BIT_COUNT:
>  		tvp->u.st = c->pre_bit_count;
> -		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
> -			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
> -		len = tvp->u.buffer.len;
>  		break;
>  	case DTV_STAT_POST_ERROR_BIT_COUNT:
>  		tvp->u.st = c->post_bit_error;
> -		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
> -			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
> -		len = tvp->u.buffer.len;
>  		break;
>  	case DTV_STAT_POST_TOTAL_BIT_COUNT:
>  		tvp->u.st = c->post_bit_count;
> -		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
> -			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
> -		len = tvp->u.buffer.len;
>  		break;
>  	case DTV_STAT_ERROR_BLOCK_COUNT:
>  		tvp->u.st = c->block_error;
> -		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
> -			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
> -		len = tvp->u.buffer.len;
>  		break;
>  	case DTV_STAT_TOTAL_BLOCK_COUNT:
>  		tvp->u.st = c->block_count;
> -		if (tvp->u.buffer.len > MAX_DTV_STATS * sizeof(u32))
> -			tvp->u.buffer.len = MAX_DTV_STATS * sizeof(u32);
> -		len = tvp->u.buffer.len;
>  		break;
>  	default:
>  		dev_dbg(fe->dvb->device,
> @@ -1589,13 +1563,18 @@ static int dtv_property_process_get(struct dvb_frontend *fe,
>  		return -EINVAL;
>  	}
>  
> -	if (len < 1)
> -		len = 1;
> -
> -	dev_dbg(fe->dvb->device,
> -		"%s: GET cmd 0x%08x (%s) len %d: %*ph\n",
> -		__func__, tvp->cmd, dtv_cmd_name(tvp->cmd),
> -		tvp->u.buffer.len, tvp->u.buffer.len, tvp->u.buffer.data);
> +	if (tvp->cmd == DTV_ENUM_DELSYS) {
> +		dev_dbg(fe->dvb->device,
> +			"%s: GET cmd 0x%08x (%s) len %d: %*ph\n",
> +			__func__, tvp->cmd, dtv_cmd_name(tvp->cmd),
> +			tvp->u.buffer.len, tvp->u.buffer.len,
> +			tvp->u.buffer.data);
> +	} else {
> +		dev_dbg(fe->dvb->device,
> +			"%s: GET cmd 0x%08x (%s) = 0x%08x\n",
> +			__func__, tvp->cmd, dtv_cmd_name(tvp->cmd),
> +			tvp->u.data);

But now, this dev_dbg will be used for DTV_STAT_* and the amount of tvp->u.data will not represent
the whole tvp->u.st. So here, not all bytes would be printed from stats struct. I think this is a
regression. Could you do better for DTV_STAT_*?

> +	}
>  
>  	return 0;
>  }
> 
> 
> base-commit: 72d3fcf802c45d00b300f25b848a93c3a2bd7c7e

-- 
Slawomir Stepien
