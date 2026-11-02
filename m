Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.48
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793617336;
	b=ca75+JBYAZB32IWwey8VeeM6ek7qfbQo3OrQ2Dp/OF+/FTLXauTjhG/QJbzeFsCtFx9t
	 yrJ5/S4h1BWj5FN2zJts0nVjfeXkpcKrarDiEVt45zo3/VvnI79g4M3Jeoaxq6IAiUyIr
	 izaBpyu4DHV/fJ+Zk7ZRiCTjYjX63a4UcDWIhFX8CrBb5wGehkX/uQHDYI8bOglQF0bY0
	 tMeydyS38XdqKoPaQOSENOT+tekSrfA7EsXVF99DcSEqA8ZWR8l1O/76ofzy3OCF+Ah4S
	 ADrY0JU4G6XVA7s3Zns9qLX3UFpoegBy2/LMHZifWfRExL3PBMM96LXW7+pd38Mit7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793617336;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:To:Cc:References:
	 Content-Language:From:In-Reply-To:Content-Type:
	 Content-Transfer-Encoding;
	bh=6fL5HXlCMqtrx9wPHH2Q2Q+TImI3SLzlCub09F9ZsWg=;
	b=x/WxSXxmRjD2KX81CO/pjKsfVODtF4w0gsEKUITmSgUD/eYoYLnZtPQ2Y6M7DPegc4U7
	 kfPWJzzFyzj+SR02XlReHgHW2CFGzbBGOF0YMC6o3FmVBpEtNfW4f7u13yVa868ODJagR
	 YW2u9salDQnUVp9oc5uH4UcbWRraKlJ68ca/ckysSccet8IQLry+uQfFVLM+xNk6aZg6z
	 GWb/0LwZBoNSns3/OCppugv6Rt9zEyELy7fZWbqEN5ppB0IlMMugEvBs+kV4qDVO8cqmn
	 tzBJR+jSqyNkuR+I+hVwAoI9CldQarYFZ+5Ao5Sx1ozMJ2Uf2FlwHpup7LwoEOnK3/A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0rXko2hF;
	arc=none smtp.remote-ip=209.85.218.48
Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92823606A330
	for <syzbot@lists.linux.dev>; Mon,  2 Nov 2026 11:02:15 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 92823606A330
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=0rXko2hF
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c414e5d282eso334902366b.1
        for <syzbot@lists.linux.dev>; Mon, 02 Nov 2026 03:02:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793617334; x=1794222134; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=6fL5HXlCMqtrx9wPHH2Q2Q+TImI3SLzlCub09F9ZsWg=;
        b=0rXko2hFt3LacM0tOlvQ5qH48PHgQXd0rOss68RXHyQ4+pPtfHuxcMKShKR2vA8eo7
         wJG21UUvp4qGurePPYRYesxUVxNoyLoD1Nquoug7IwPbJvF7vMduN1ppoxhTR/bAxzq3
         kWEKOBQm4f1BLkH3i9N+tOrwwfSPLem7X+b9JBo5dZ2/8GuMmwePKVzfXYePlHTPFbG3
         EQpCnufy5LWzSTzSJ7os3HzsGMiGD+l4oxNxE73cIGGf0zUg6wqzr0nDrJnyIMYy/tOB
         DwAVqI19/gJnv1Y4nkg1/I8SUNYA4i9amuVPXceHfbRk17xBtssomi19oNrLFxfCG6hx
         /3hQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793617334; x=1794222134;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=6fL5HXlCMqtrx9wPHH2Q2Q+TImI3SLzlCub09F9ZsWg=;
        b=j42fh5ceTyEOOX5Ytoh5scHCbDkTrZm1N8GrsKBFn2JHphmA71Mm3LeTxySOVSQro+
         UfPLKCqjMhF7SWgJQDtoL8LtlwigjVVg3ygxf140OhKKcSs6WGv2ndg9/ZThEac2seKO
         s/G9fJmIvSRjRqbe8tjDD7ST58Mzs0qWbz3Fm/rjsqnmncXELgQuPNJAMJGQwNoTBbUA
         O/3YRjTMcyrgsHbgNe9bHw873cnJ3uyF0o411QTbViBYY+EJh0iz9wwigJUM3E7cmPwd
         8rovuzv0nEm8i4dlIJ2IpwUK1Gbfg512kPsle0WL1+N6g7vrZI/yAOq7/FFF2X6beS5p
         yd9A==
X-Forwarded-Encrypted: i=1; AKwUvBxel5bBcuTdZMnHr75Dt6QnL77mIRhKREG6IlwDDsqYOtDaYrbWc5Ynh8BQNwIlWu8Opym0hqk=@lists.linux.dev
X-Gm-Message-State: AFq9FYJBs39PslaHOLqBYWVjVRUUFTkBD/AhDLw2G7HATFw4pgj90B5b
	JvcX5s5emkuwDj18QagcRD0aWzHGtIrAJBFTLk2LQe5ROiaxCwrVk5c7
X-Gm-Gg: AYBFou1kF4mn6Zz3+iwJ0LDT4eQlyjwKJY9KfuxHnCASvM1X16Tjt2TPGQ7Q+ZKp4Qr
	+dLjHD0hUcPirnQiwKZQVwngfXU8LZAzV7GwPRU0f80JRTmb9RSsxPGnq8MEZ+nhcPO6st7yTQe
	PD+JKTgH+aFEWWvS6C80VgP0/jxpMVW51HXH/P4MNzDoAzIxkTkpE66+7lYw2gInSqwf2ELpZFd
	VCKI+6mutUtzvlUB/8yRWKakXtsudRQEMnaKUeHxN7WPywkEUCNxJj/kJzvzpvbwaLcbAE+TlZ0
	ANdjyneDgVKJnJw2juwplGJo9AeGxwVtpiGqnmOaY/5PiizogDf/xU3qhe7hlIET5M6cbRnKtGa
	iZHVCxJygNARIxjNuO6h3c0xzqxatytzFD24eZDrQABvS9lF8dxwFM6ogugVDhN8HhP2Hg+EcTZ
	vjJigCvs97V9P6RgFi1JB2Vo/NtGWGUCdOCIorzeop8LoFNjHqYTcbFyh/Q0vEMoI4AeIBCfMVe
	zenq0ZyoQuAlzjdXdQoFbek+vfSYxIvkQPqlURZsTh1CtE6P9ceAee9wUcXKdb/C5VbJNBrcm3m
	7ptP9cSgEFICar1daPPL5yorgpp/IuZwuNW+rauS+scQf6erWdX+iyNUQZ0OYAiEw5h472T+9Xp
	eMUoRubf3zusCF8/RgNs1iAuH+3TcWPCs9/Jk6Tt5gWCvsIkdUfiuocqNvU5Exqmsi/w6olXx2U
	oKJIeVp5SEQ6BiyGD/FlVBLtIcXYo7LyujIPiADe1lueFs7SZQ2JpObGzEDgyPT0FoJqXr+raBp
	yvho3K5AAO/
X-Received: by 2002:a17:906:f595:b0:c2e:8eb7:53e8 with SMTP id a640c23a62f3a-c4ca7b432fbmr802092666b.30.1793617333613;
        Mon, 02 Nov 2026 03:02:13 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabe0f504sm370572466b.36.2026.11.02.03.02.08
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 03:02:10 -0800 (PST)
Message-ID: <90b7320d-0735-471e-a370-a007004da6f6@gmail.com>
Date: Mon, 2 Nov 2026 12:02:07 +0100
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] media: ttusb-dec: fix buffer overflow in
 ttusb_dec_send_command()
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
 linux-media@vger.kernel.org, Mauro Carvalho Chehab <mchehab@kernel.org>
Cc: kees@kernel.org, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
References: <66cb7980-f474-41c8-bf2f-529ebfbdc62a@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <66cb7980-f474-41c8-bf2f-529ebfbdc62a@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/14/26 10:40, syzbot wrote:
> From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> 
> In ttusb_dec_send_command(), a 64-byte buffer is allocated
> (COMMAND_PACKET_SIZE + 4, where COMMAND_PACKET_SIZE is 60) for sending a
> command to the USB device and receiving the response via usb_bulk_msg().
> After receiving the response, the fourth byte b[3] is treated as the
> payload length and used directly in memcpy(cmd_result, &b[4], b[3]) without
> validating it against the actual number of received bytes (actual_len), the
> allocated source buffer bounds, or the capacity of the destination buffer
> cmd_result.
> 
> During device probe in ttusb_dec_probe(), ttusb_dec_init_stb() calls
> ttusb_dec_get_stb_state() to query the device state. If the device returns
> a response with an untrusted payload length b[3] greater than
> COMMAND_PACKET_SIZE (e.g. 75), memcpy() reads past the end of the source
> buffer and overflows the caller's 60-byte destination buffer on the stack,
> triggering a FORTIFY_SOURCE buffer overflow failure ("memcpy: detected
> buffer overflow: 75 byte read of buffer size 60").
> 
> Moreover, other callers such as ttusbdecfe_dvbt_read_status() supply
> destination buffers as small as 4 bytes, which can lead to a stack buffer
> overflow even if the device returns fewer than 60 bytes. Additionally,
> param_length is copied into &b[4] without checking whether it exceeds
> COMMAND_PACKET_SIZE.
> 
> Fix this by first verifying that param_length is non-negative and does not
> exceed COMMAND_PACKET_SIZE. Next, add a cmd_result_len parameter to
> ttusb_dec_send_command(), fe_send_command(), and struct
> ttusbdecfe_config.send_command to pass the destination buffer capacity, and
> update all callers accordingly. Finally, strictly reject malformed replies
> with -EIO if actual_len is less than 4 bytes, if the untrusted payload
> length b[3] exceeds the remaining received bytes (actual_len - 4), or if
> cmd_result is provided and b[3] exceeds cmd_result_len. This ensures that
> invalid replies fail safely and memcpy() never performs an out-of-bounds
> read or write.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.8-flash syzbot
> Reported-by: syzbot+e1dbaae5eefaa2dfbc35@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e1dbaae5eefaa2dfbc35
> Link: https://syzkaller.appspot.com/ai_job?id=5d2e7c8a-5cf6-49fe-a6e9-124e4d1e051d
> Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> 
> ---
> diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
> index 825a38759..524be8f10 100644
> --- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
> +++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
> @@ -314,13 +314,17 @@ static u16 crc16(u16 crc, const u8 *buf, size_t len)
>  
>  static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
>  				  int param_length, const u8 params[],
> -				  int *result_length, u8 cmd_result[])
> +				  int *result_length, u8 cmd_result[],
> +				  int cmd_result_len)
>  {
>  	int result, actual_len;
>  	u8 *b;
>  
>  	dprintk("%s\n", __func__);
>  
> +	if (param_length < 0 || param_length > COMMAND_PACKET_SIZE)
> +		return -EINVAL;
> +
>  	b = kzalloc(COMMAND_PACKET_SIZE + 4, GFP_KERNEL);
>  	if (!b)
>  		return -ENOMEM;
> @@ -366,6 +370,12 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
>  			       __func__, actual_len, b);
>  		}
>  
> +		if (actual_len < 4 || b[3] > actual_len - 4 ||
> +		    (cmd_result && b[3] > cmd_result_len)) {
> +			result = -EIO;
> +			goto err_mutex_unlock;
> +		}
> +
>  		if (result_length)
>  			*result_length = b[3];
>  		if (cmd_result && b[3] > 0)
> @@ -389,7 +399,8 @@ static int ttusb_dec_get_stb_state (struct ttusb_dec *dec, unsigned int *mode,
>  
>  	dprintk("%s\n", __func__);
>  
> -	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c);
> +	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c,
> +					sizeof(c));
>  	if (result)
>  		return result;
>  
> @@ -448,7 +459,7 @@ static void ttusb_dec_set_pids(struct ttusb_dec *dec)
>  	memcpy(&b[2], &audio, 2);
>  	memcpy(&b[4], &video, 2);
>  
> -	ttusb_dec_send_command(dec, 0x50, sizeof(b), b, NULL, NULL);
> +	ttusb_dec_send_command(dec, 0x50, sizeof(b), b, NULL, NULL, 0);
>  
>  	dvb_filter_pes2ts_init(&dec->a_pes2ts, dec->pid[DMX_PES_AUDIO],
>  			       ttusb_dec_audio_pes2ts_cb, dec);
> @@ -902,7 +913,7 @@ static int ttusb_dec_set_interface(struct ttusb_dec *dec,
>  			break;
>  		case TTUSB_DEC_INTERFACE_IN:
>  			result = ttusb_dec_send_command(dec, 0x80, sizeof(b),
> -							b, NULL, NULL);
> +							b, NULL, NULL, 0);
>  			if (result)
>  				return result;
>  			result = usb_set_interface(dec->udev, 0, 8);
> @@ -1021,7 +1032,7 @@ static int ttusb_dec_start_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
>  
>  	}
>  
> -	result = ttusb_dec_send_command(dec, 0x80, sizeof(b0), b0, NULL, NULL);
> +	result = ttusb_dec_send_command(dec, 0x80, sizeof(b0), b0, NULL, NULL, 0);
>  	if (result)
>  		return result;
>  
> @@ -1056,7 +1067,7 @@ static int ttusb_dec_start_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
>  	memcpy(&b0[5], &dvbdmxfeed->filter->filter.filter_value[0], 1);
>  
>  	result = ttusb_dec_send_command(dec, 0x60, sizeof(b0), b0,
> -					&c_length, c);
> +					&c_length, c, sizeof(c));
>  
>  	if (!result) {
>  		if (c_length == 2) {
> @@ -1114,7 +1125,7 @@ static int ttusb_dec_stop_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
>  	struct ttusb_dec *dec = dvbdmxfeed->demux->priv;
>  	u8 b0[] = { 0x00 };
>  
> -	ttusb_dec_send_command(dec, 0x81, sizeof(b0), b0, NULL, NULL);
> +	ttusb_dec_send_command(dec, 0x81, sizeof(b0), b0, NULL, NULL, 0);
>  
>  	dec->pva_stream_count--;
>  
> @@ -1135,7 +1146,7 @@ static int ttusb_dec_stop_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
>  	list_del(&finfo->filter_info_list);
>  	spin_unlock_irqrestore(&dec->filter_info_list_lock, flags);
>  	kfree(finfo);
> -	ttusb_dec_send_command(dec, 0x62, sizeof(b0), b0, NULL, NULL);
> +	ttusb_dec_send_command(dec, 0x62, sizeof(b0), b0, NULL, NULL, 0);
>  
>  	dec->filter_stream_count--;
>  
> @@ -1238,7 +1249,7 @@ static int ttusb_init_rc( struct ttusb_dec *dec)
>  	if (usb_submit_urb(dec->irq_urb, GFP_KERNEL))
>  		printk("%s: usb_submit_urb failed\n",__func__);
>  	/* enable irq pipe */
> -	ttusb_dec_send_command(dec,0xb0,sizeof(b),b,NULL,NULL);
> +	ttusb_dec_send_command(dec, 0xb0, sizeof(b), b, NULL, NULL, 0);
>  
>  	return 0;
>  }
> @@ -1354,7 +1365,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
>  	firmware_csum_ns = htons(firmware_csum);
>  	memcpy(&b0[6], &firmware_csum_ns, 2);
>  
> -	result = ttusb_dec_send_command(dec, 0x41, sizeof(b0), b0, NULL, NULL);
> +	result = ttusb_dec_send_command(dec, 0x41, sizeof(b0), b0, NULL, NULL, 0);
>  
>  	if (result) {
>  		release_firmware(fw_entry);
> @@ -1395,7 +1406,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
>  		}
>  	}
>  
> -	result = ttusb_dec_send_command(dec, 0x43, sizeof(b1), b1, NULL, NULL);
> +	result = ttusb_dec_send_command(dec, 0x43, sizeof(b1), b1, NULL, NULL, 0);
>  
>  	release_firmware(fw_entry);
>  	kfree(b);
> @@ -1621,10 +1632,12 @@ static void ttusb_dec_exit_filters(struct ttusb_dec *dec)
>  
>  static int fe_send_command(struct dvb_frontend* fe, const u8 command,
>  			   int param_length, const u8 params[],
> -			   int *result_length, u8 cmd_result[])
> +			   int *result_length, u8 cmd_result[],
> +			   int cmd_result_len)
>  {
>  	struct ttusb_dec* dec = fe->dvb->priv;
> -	return ttusb_dec_send_command(dec, command, param_length, params, result_length, cmd_result);
> +	return ttusb_dec_send_command(dec, command, param_length, params,
> +				      result_length, cmd_result, cmd_result_len);
>  }
>  
>  static const struct ttusbdecfe_config fe_config = {
> diff --git a/drivers/media/usb/ttusb-dec/ttusbdecfe.c b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
> index 215221370..1c2892a1e 100644
> --- a/drivers/media/usb/ttusb-dec/ttusbdecfe.c
> +++ b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
> @@ -44,7 +44,8 @@ static int ttusbdecfe_dvbt_read_status(struct dvb_frontend *fe,
>  
>  	*status=0;
>  
> -	ret=state->config->send_command(fe, 0x73, sizeof(b), b, &len, result);
> +	ret = state->config->send_command(fe, 0x73, sizeof(b), b, &len,
> +					  result, sizeof(result));
>  	if(ret)
>  		return ret;
>  
> @@ -85,7 +86,7 @@ static int ttusbdecfe_dvbt_set_frontend(struct dvb_frontend *fe)
>  
>  	__be32 freq = htonl(p->frequency / 1000);
>  	memcpy(&b[4], &freq, sizeof (u32));
> -	state->config->send_command(fe, 0x71, sizeof(b), b, NULL, NULL);
> +	state->config->send_command(fe, 0x71, sizeof(b), b, NULL, NULL, 0);
>  
>  	return 0;
>  }
> @@ -130,7 +131,7 @@ static int ttusbdecfe_dvbs_set_frontend(struct dvb_frontend *fe)
>  	lnb_voltage = htonl(state->voltage);
>  	memcpy(&b[28], &lnb_voltage, sizeof(u32));
>  
> -	state->config->send_command(fe, 0x71, sizeof(b), b, NULL, NULL);
> +	state->config->send_command(fe, 0x71, sizeof(b), b, NULL, NULL, 0);
>  
>  	return 0;
>  }
> @@ -149,7 +150,7 @@ static int ttusbdecfe_dvbs_diseqc_send_master_cmd(struct dvb_frontend* fe, struc
>  
>  	state->config->send_command(fe, 0x72,
>  				    sizeof(b) - (6 - cmd->msg_len), b,
> -				    NULL, NULL);
> +				    NULL, NULL, 0);
>  
>  	return 0;
>  }
> diff --git a/drivers/media/usb/ttusb-dec/ttusbdecfe.h b/drivers/media/usb/ttusb-dec/ttusbdecfe.h
> index 73828bb22..96600ad4c 100644
> --- a/drivers/media/usb/ttusb-dec/ttusbdecfe.h
> +++ b/drivers/media/usb/ttusb-dec/ttusbdecfe.h
> @@ -14,7 +14,8 @@ struct ttusbdecfe_config
>  {
>  	int (*send_command)(struct dvb_frontend* fe, const u8 command,
>  			    int param_length, const u8 params[],
> -			    int *result_length, u8 cmd_result[]);
> +			    int *result_length, u8 cmd_result[],
> +			    int cmd_result_len);
>  };
>  
>  extern struct dvb_frontend* ttusbdecfe_dvbs_attach(const struct ttusbdecfe_config* config);
> 
> 
> base-commit: 93f51579e7df248780214094418f205253383cc5
Hi Mauro,

A gentle ping on this fix. All media-ci checks have passed.

I also noticed several older patches in Patchwork addressing the same
ttusb-dec path. Could you let me know whether this version should be
considered, or whether one of the earlier fixes is preferred?

Thanks,
-- 
Krystian Kaniewski
