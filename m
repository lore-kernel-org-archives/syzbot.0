Received: from mail-lf2-f12.google.com (mail-lf2-f12.google.com [74.125.229.204])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CCBAB47FAF3
	for <syzbot@lists.linux.dev>; Mon,  5 Oct 2026 12:35:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.229.204
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791203730; cv=none; b=L6UvGprMfGozLBTrTv9xm0nV+wIUMzVyfIwd7H2IOFUIKaaoT5fr7fKivTStnLOyTSsj+M7LFrS4K3rHnPizyV2/K8EYJ//6fTctP4vP3vNmNkkeX6H1L9yBJVfKwfPHVovbb1ZhBCVSuC560ckWFpbQIFkZGl7gA0hzn9S4MQw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791203730; c=relaxed/simple;
	bh=CRaG3WrLhEqy2m0v1TolfuR+1VwBC5m6BiE3Ht/Lmnk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=tFt/L/3ttYlX6BvFRRrwBvMVBRNim/JDL/0TN4q44v9UGA+A6IvmaIgmzplTISjeqyuo5PD0mQELEMMnvX0AtNwWuPEvcWY79A0vEXiFrslVTUIs5xNwJ5050VSM8JC4t0KsjkVK5wFHgzbcXO9RZfqgf7eRH9IpZAWILSceSEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=dGGwncHl; arc=none smtp.client-ip=74.125.229.204
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="dGGwncHl"
Received: by mail-lf2-f12.google.com with SMTP id 2adb3069b0e04-5ba3d90ac37so1547135e87.3
        for <syzbot@lists.linux.dev>; Mon, 05 Oct 2026 05:35:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791203727; x=1791808527; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=d6Vq03qL4lb02qf7JLv1bzAphaRrhfD6bkT2NR0f4vI=;
        b=dGGwncHlZWj0gEaeORWsujnGy8BXv6oNKV3Dgx6DLzG2Xh0DiGnukzZ9YdtaDrHMob
         LWB/p2necvnyvX6ZBTXrRWug9WUkVhS4CbbXRZQdFzYimNcPrr6JTw9o+tZWoAJOTiKT
         vvaw0AE3hRJuxSqdOeRrh4AYKToXC/qeBG9gxxFsp3R/ynp5YzS3xM5aer4iNiIxUooL
         sIhToBKx+Huv8rsmEL8SUJh8GbbMUWWiYg46S79BKiyE+bqWMu8fyDRS0CgOM71iZPsi
         yGpEUFljpcnovCSRyAIo2izZS8PqPZ6Sh6UWuCo8UgxDK4sJM4sGjkI3HAgMl3lS40L/
         EBNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791203727; x=1791808527;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=d6Vq03qL4lb02qf7JLv1bzAphaRrhfD6bkT2NR0f4vI=;
        b=JhXwHMY/QvDjJACQV3w4QyGG/LwqWoodOMRfNfOiCvxn6Ou0MnzJMR82p7GO9kL1A3
         GzZtLM7yo/v8q7ouEsuNEW3kckSiyrPonkgaNqWH0g2GgOPTMZ19SR2Qy1d5fbE8pK/L
         PpTEL98GiMuH7XeZKz0BsMUPF/dA94T5Tni+z7ccDNnPeYGkHcZBeoqHp/WULDv9+2A/
         0kHVeWVZ+w4ZbnBjTyJmtSOq6M4edNgSdwnfNkmuRLx7xVD2lVUTLgiQ8fQBWuaoIPbe
         GvsWkNO+aHIfyym1FIude909K7Kn2K0HFcCoDOwTcwR+jQAbpevJabcYXwSC42d76lqk
         EqDQ==
X-Gm-Message-State: AFq9FYJIXjB0gvtq4P0hDNhd10UjVhf1l4Pt0Ijw0vbEOEnafIASYTX0
	GA8VJTw0aHRukOMwSK6vYvIbrWNMMa0DPlM+ejBsbVZBUoTIBCwjN99D
X-Gm-Gg: AYBFou1vOvAdbqL+BjoXnzAhwjHgj3YyIlP6rB9V9HouNQhy4qUVnermBNuyn4BurkM
	YQqxq1ij17b9q3PY44eoJ55kfG7JohbZCnHxzKNWphTFiIrnuGEQ70uIeMyhqBXpm0QQyhkPUF3
	U+97zXODt1XDFipsQF0urbqWtB/xO5a1GgHAqN8lhCsR+dWfaokQ9NcOgpiDzhckj68fE81onUP
	osNEy+HZsmvwMcZ3ygmspE7Ia4FuZG4prcXJPqqHOohfUvOAq7iBv78ZspeOyQ5f9Apa1DWclRK
	rWVdFukNXJsTK6jMgWkMfO9MeOJFtIosfPuyLMu5Iurgi9HTG8l14JkTHqWYenp1Bp9+nRo821C
	2Stbk8BKfEOiAEhnnK+BYPLi71g/HZbhxzn3CMLZmKRa50+4lU/gp4d56JhPiPwFiUneqXUNoIu
	mjoLLq0JH0p3YvLdNbi65/+y+4KS6wwNp5uyQL5u0Zrp+BXIKWW0eXMoB5ZwsP3iZLvXVSBdap/
	kSe69OgNQ3mexdVKoGQgYC7ZPUuWhDIAh4l/zcVAR6rC+faBwRMonjsyi7DhwzuNX0k6JDh75+G
	6gYQATf/x72HvhdpianNarRn4rYx5W1qI99QcNyDvNAWd1kuJp2q5xuS/tr+184gj3wMlsEdpBy
	KA6YfXYJdbJMii0D89rjDCQ7hfJvaC4+qfQ==
X-Received: by 2002:a05:6512:66cc:10b0:5b7:6672:69d5 with SMTP id 2adb3069b0e04-5bb9be51247mr3013756e87.65.1791203726327;
        Mon, 05 Oct 2026 05:35:26 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 2adb3069b0e04-5bb7c795b0csm3136298e87.33.2026.10.05.05.35.25
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 05 Oct 2026 05:35:25 -0700 (PDT)
Message-ID: <acf2d8e7-4bec-4002-9015-dfd88cbe2c5d@gmail.com>
Date: Mon, 5 Oct 2026 14:35:24 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] media: ttusb-dec: fix buffer overflow in
 ttusb_dec_send_command()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <84b5473b-2ef9-4a91-90fb-57fea553af7b@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <84b5473b-2ef9-4a91-90fb-57fea553af7b@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 9/24/26 21:43, syzbot wrote:
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
> a response with a payload length b[3] greater than COMMAND_PACKET_SIZE
> (e.g. 75), memcpy() reads past the end of the source buffer and overflows
> the caller's 60-byte destination buffer on the stack, triggering a
> FORTIFY_SOURCE buffer overflow panic:
> 
> memcpy: detected buffer overflow: 75 byte read of buffer size 60
> Call trace:
>  __fortify_report+0xa0/0xb8 lib/string_helpers.c:1036
>  __fortify_panic+0x10/0x14 lib/string_helpers.c:1043
>  fortify_memcpy_chk include/linux/fortify-string.h:549 [inline]
>  ttusb_dec_start_feed+0x0/0x10ac
>  drivers/media/usb/ttusb-dec/ttusb_dec.c:372
>  ttusb_dec_get_stb_state drivers/media/usb/ttusb-dec/ttusb_dec.c:392
>  [inline]
>  ttusb_dec_init_stb drivers/media/usb/ttusb-dec/ttusb_dec.c:1413 [inline]
>  ttusb_dec_probe+0x724/0x1aa0 drivers/media/usb/ttusb-dec/ttusb_dec.c:1671
> 
> Moreover, other callers such as ttusbdecfe_dvbt_read_status() supply
> destination buffers as small as 4 bytes, which can lead to a stack buffer
> overflow even if the device returns fewer than 60 bytes. Additionally,
> param_length is copied into &b[4] without checking whether it exceeds
> COMMAND_PACKET_SIZE.
> 
> Fix this by first verifying that param_length is non-negative and does not
> exceed COMMAND_PACKET_SIZE. Next, ensure actual_len is at least 4 bytes
> before reading b[3], and clamp the payload length to both
> COMMAND_PACKET_SIZE and actual_len - 4. Finally, add a cmd_result_len
> parameter to ttusb_dec_send_command(), fe_send_command(), and struct
> ttusbdecfe_config.send_command to pass the destination buffer capacity,
> bound the memcpy() to min_t(int, payload_len, cmd_result_len), and update
> all callers accordingly.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+e1dbaae5eefaa2dfbc35@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e1dbaae5eefaa2dfbc35
> Link: https://syzkaller.appspot.com/ai_job?id=b90a55d4-d957-43fa-9fac-3b06b57d7537
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
> index 825a38759..8bc9c16f3 100644
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
> @@ -361,15 +365,24 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
>  		       __func__, result);
>  		goto err_mutex_unlock;
>  	} else {
> +		int payload_len = 0;
> +
>  		if (debug) {
>  			printk(KERN_DEBUG "%s: result: %*ph\n",
>  			       __func__, actual_len, b);
>  		}
>  
> +		if (actual_len >= 4) {
> +			payload_len = min_t(int, b[3], COMMAND_PACKET_SIZE);
> +			payload_len = min_t(int, payload_len, actual_len - 4);
> +		}
> +
>  		if (result_length)
> -			*result_length = b[3];
> -		if (cmd_result && b[3] > 0)
> -			memcpy(cmd_result, &b[4], b[3]);
> +			*result_length = payload_len;
> +
> +		if (cmd_result && payload_len > 0 && cmd_result_len > 0)
> +			memcpy(cmd_result, &b[4],
> +			       min_t(int, payload_len, cmd_result_len));
>  	}
>  
>  err_mutex_unlock:
> @@ -389,7 +402,8 @@ static int ttusb_dec_get_stb_state (struct ttusb_dec *dec, unsigned int *mode,
>  
>  	dprintk("%s\n", __func__);
>  
> -	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c);
> +	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c,
> +					sizeof(c));
>  	if (result)
>  		return result;
>  
> @@ -448,7 +462,7 @@ static void ttusb_dec_set_pids(struct ttusb_dec *dec)
>  	memcpy(&b[2], &audio, 2);
>  	memcpy(&b[4], &video, 2);
>  
> -	ttusb_dec_send_command(dec, 0x50, sizeof(b), b, NULL, NULL);
> +	ttusb_dec_send_command(dec, 0x50, sizeof(b), b, NULL, NULL, 0);
>  
>  	dvb_filter_pes2ts_init(&dec->a_pes2ts, dec->pid[DMX_PES_AUDIO],
>  			       ttusb_dec_audio_pes2ts_cb, dec);
> @@ -902,7 +916,7 @@ static int ttusb_dec_set_interface(struct ttusb_dec *dec,
>  			break;
>  		case TTUSB_DEC_INTERFACE_IN:
>  			result = ttusb_dec_send_command(dec, 0x80, sizeof(b),
> -							b, NULL, NULL);
> +							b, NULL, NULL, 0);
>  			if (result)
>  				return result;
>  			result = usb_set_interface(dec->udev, 0, 8);
> @@ -1021,7 +1035,7 @@ static int ttusb_dec_start_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
>  
>  	}
>  
> -	result = ttusb_dec_send_command(dec, 0x80, sizeof(b0), b0, NULL, NULL);
> +	result = ttusb_dec_send_command(dec, 0x80, sizeof(b0), b0, NULL, NULL, 0);
>  	if (result)
>  		return result;
>  
> @@ -1056,7 +1070,7 @@ static int ttusb_dec_start_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
>  	memcpy(&b0[5], &dvbdmxfeed->filter->filter.filter_value[0], 1);
>  
>  	result = ttusb_dec_send_command(dec, 0x60, sizeof(b0), b0,
> -					&c_length, c);
> +					&c_length, c, sizeof(c));
>  
>  	if (!result) {
>  		if (c_length == 2) {
> @@ -1114,7 +1128,7 @@ static int ttusb_dec_stop_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
>  	struct ttusb_dec *dec = dvbdmxfeed->demux->priv;
>  	u8 b0[] = { 0x00 };
>  
> -	ttusb_dec_send_command(dec, 0x81, sizeof(b0), b0, NULL, NULL);
> +	ttusb_dec_send_command(dec, 0x81, sizeof(b0), b0, NULL, NULL, 0);
>  
>  	dec->pva_stream_count--;
>  
> @@ -1135,7 +1149,7 @@ static int ttusb_dec_stop_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
>  	list_del(&finfo->filter_info_list);
>  	spin_unlock_irqrestore(&dec->filter_info_list_lock, flags);
>  	kfree(finfo);
> -	ttusb_dec_send_command(dec, 0x62, sizeof(b0), b0, NULL, NULL);
> +	ttusb_dec_send_command(dec, 0x62, sizeof(b0), b0, NULL, NULL, 0);
>  
>  	dec->filter_stream_count--;
>  
> @@ -1238,7 +1252,7 @@ static int ttusb_init_rc( struct ttusb_dec *dec)
>  	if (usb_submit_urb(dec->irq_urb, GFP_KERNEL))
>  		printk("%s: usb_submit_urb failed\n",__func__);
>  	/* enable irq pipe */
> -	ttusb_dec_send_command(dec,0xb0,sizeof(b),b,NULL,NULL);
> +	ttusb_dec_send_command(dec, 0xb0, sizeof(b), b, NULL, NULL, 0);
>  
>  	return 0;
>  }
> @@ -1354,7 +1368,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
>  	firmware_csum_ns = htons(firmware_csum);
>  	memcpy(&b0[6], &firmware_csum_ns, 2);
>  
> -	result = ttusb_dec_send_command(dec, 0x41, sizeof(b0), b0, NULL, NULL);
> +	result = ttusb_dec_send_command(dec, 0x41, sizeof(b0), b0, NULL, NULL, 0);
>  
>  	if (result) {
>  		release_firmware(fw_entry);
> @@ -1395,7 +1409,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
>  		}
>  	}
>  
> -	result = ttusb_dec_send_command(dec, 0x43, sizeof(b1), b1, NULL, NULL);
> +	result = ttusb_dec_send_command(dec, 0x43, sizeof(b1), b1, NULL, NULL, 0);
>  
>  	release_firmware(fw_entry);
>  	kfree(b);
> @@ -1621,10 +1635,12 @@ static void ttusb_dec_exit_filters(struct ttusb_dec *dec)
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
Reject malformed replies instead of clamping their declared payload length. In `ttusb_dec_send_command()`, after a successful result transfer and before changing `result_length` or copying payload data, return `-EIO` when `actual_len` is less than four, when `b[3]` exceeds `actual_len - 4`, or when the declared payload exceeds a supplied result-buffer capacity. Clamping removes the original protocol error and can turn a frame that declares 75 payload bytes into an accepted 12-byte state reply or four-byte frontend reply.

Preserve the outgoing `param_length` bounds check, the destination-capacity argument through the frontend callback, all updated call sites, and existing behavior for valid replies and USB transport errors.

Rewrite the commit message to match strict rejection. Remove the full stack trace and keep only a concise description of the observed FORTIFY failure, the untrusted reply length, and why the new checks fix it. Remove the unsupported statement that the current code ensures `actual_len` is at least four. Keep the existing `Fixes`, `Reported-by`, `Closes`, job, and provenance tags.

-- 
Krystian Kaniewski
