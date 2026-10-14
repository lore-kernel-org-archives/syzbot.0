Received: from mail-ej1-f48.google.com (mail-ej1-f48.google.com [209.85.218.48])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9B6433F0A9B
	for <syzbot@lists.linux.dev>; Wed, 14 Oct 2026 08:34:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.48
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791966850; cv=none; b=V/j49CSZE0Gc3Qfbbn1mD6C/8qYCgUlRwBF3VYiv/DKMVi7ZJas1JTDczOV/6F6UY4tcGuNgmRzGHo9Mo5Uw36gzZpUc3ccD0nniLMIQtKGZuFhmzxemuY+ltWZvtUAU2PPgiKRY1ZDz94mE4ErGTOUfWeh5wc5m2ev+n6gKGpY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791966850; c=relaxed/simple;
	bh=hTYZ+S/wRlCQyw08d/FjvClbe+3GMwGh/bWARHJiUJ4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Xrf2XpVkF8L1f6rdJGSZVidhqWMw8BAKG5ZBCC2/3WhIKX/F6G3ZiZ4iZsTzfJ5h+sU2vdC+eBv0M5UW0V8sPhLBJQgNU07dcQlHlP/RKMvE5xKBC1Epq/KZ9q6y+fDbfqNQisZ+4mTvNUEzhXqHuV7eiJeLyDL7IdORrkGIU3Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=OOQzv289; arc=none smtp.client-ip=209.85.218.48
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="OOQzv289"
Received: by mail-ej1-f48.google.com with SMTP id a640c23a62f3a-c315a445752so589497866b.3
        for <syzbot@lists.linux.dev>; Wed, 14 Oct 2026 01:34:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1791966847; x=1792571647; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=Lw6LMJdIaT1w9aKHzU6ui8+KLNOCR2IHdICLPpYIaIw=;
        b=OOQzv289LO+szQ6mcY9DQhiJnZAZiMJDMTrCdaGhMEw5gRz2FHsGrHzVm5I+5kKlRr
         zlZUekPXkG6v8Pe9LTi1+J4oKnJKW1I5dPZhB5UOwQFd9uQqVbMjDWiUzcP5+al6ewmD
         gPs2y2YkVWI8uyuc6NdsjcRUV/hVfy0/5YevbS8aFGLtUpOj36Kqfr2QZVea+HfJWa+T
         0+TTnVW9rDruFzhitnPUYjiUP03CDTDlhRNtIQtbLZdAm7yb8ejFU3LwRkxmMS+sI65T
         L1KnZfy0QD+qW5EEX0mIoSVqPcBRi7li7eGGwNUGYixfCQZmm+QYr1MTUy9kA4Mlx6l9
         iJkA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1791966847; x=1792571647;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=Lw6LMJdIaT1w9aKHzU6ui8+KLNOCR2IHdICLPpYIaIw=;
        b=u7nVQVq8S8Z0FMovw2A8uMSsUTzuN7jmybZBq5eHjbGFY+G8MZnvXPUz6sMu5WaKxR
         WV1Pt1AMRgEZGVCEMuW1oLN1IYx/1RzQ8qoavNjBQieO5M5otkFTPn4fFsqDlwiEEf7Z
         6/WxzUv7pRDvAWNkyvDLZGIq256hmqP8CRgyHyNj0m2RMyOfDYMTVmlmyYWkA2ESRqGM
         YfEwLxifi1ZHdn4tr0dQsfc6M0EgjRcQCiF6ESma6v87z6UkwmVxeePwHlVRR9xe4/2U
         3PCW+eaSQkSR0o5ayUCz5bg3dwpYnFz5r82Crr45JHddku21udr7meVWlPD2GgpcWEOm
         QWAg==
X-Gm-Message-State: AFq9FYKeTT2w6vsGXnEpttwdPzvoeLPH/ArsWBl5epdrejkh0JHrVSX/
	3N7U0ofhlPrlLJvyn6aeiNyEFt9poqE2Qedw8qdbgNqSzgrul3Gojfmn
X-Gm-Gg: AYBFou2cOLFpSk45zRROqpnlKPIMNAw2Y+SdwatTBvsateUICZqL24qGnEm2nbPy5uj
	REjXhBwfFEY+gVlU02GW/dMqfPgGolIgZEJmKZ+ylw0W6fozmmbFolsGysliquRj6SI4B1hZ3oa
	huIbq1JCKazcIaxSsj/V52zGjUF0uDOhxipdMbZyJFoAGmkSoIeDgoaPm0pyYR99GfDYzwhById
	g+GrddPZ4L5ZZMfITCz0EJMLqERU/pk6BLyyqUwcwazkTUaoJ9Pl3Vz8xFyvaRgDXEZ9wEJ/SFq
	8cjYlJSKt8NPDNxkhyCFJEFDrgEVHk4eXBVzKsKADEOUgQJuXVyMyyYCqyyQsTLXtxwenCKBgp/
	/kGrzE5iQr/+IE5yo7Z5JidyiskkCmllmwu9O6Ebx3DCoixGfcT5j+CaaNhznUoXZHNogzAzk3a
	FjssANnvPFNH2eWglTHqmuJpM0ewvWSUrZYQYPeTCg+tM9+6x3Y2G2mgK4CSDpDkgLGwd9LAKNt
	le2cTqb7yJ5r1+nKAqkLuZ0TYwy6UPO4a06PTc91hZi9X63gQG4RSJ3gp4NaMTWO1KIdX9nnzYr
	OyC2bCRyJScytuNBsQdQOZ4Lm4f5nRD7YdbR6cllM/YBx4THqJ+eYSG14xiWAlFpQ4ndnwaQkkD
	OEfxVT7SUBWE3at5xc4Kb/3UAMeHDUX2v5lzq5Tzf6YTMU5cy
X-Received: by 2002:a17:907:9622:b0:c2e:893:7010 with SMTP id a640c23a62f3a-c31a9fa18cemr1278747266b.37.1791966846561;
        Wed, 14 Oct 2026 01:34:06 -0700 (PDT)
Received: from [192.168.100.192] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c32983e8c25sm553579366b.69.2026.10.14.01.34.04
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Oct 2026 01:34:05 -0700 (PDT)
Message-ID: <a75ca2cc-d8ed-4a86-a97a-a54183e954a0@gmail.com>
Date: Wed, 14 Oct 2026 10:34:04 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] media: ttusb-dec: fix buffer overflow in
 ttusb_dec_send_command()
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <6324a2b9-ac49-4fbd-a6e8-94dd51e93729@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <6324a2b9-ac49-4fbd-a6e8-94dd51e93729@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/2026 2:06 AM, syzbot wrote:
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
> To: <linux-media@vger.kernel.org>
> To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
> To: "Linus Torvalds" <torvalds@ppc970.osdl.org>
> Cc: "Kees Cook" <kees@kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v2:
> - Strictly reject malformed replies with -EIO instead of clamping the payload length
> - Update commit description to reflect strict reply validation and remove the full stack trace
> 
> v1:
> https://lore.kernel.org/all/84b5473b-2ef9-4a91-90fb-57fea553af7b@mail.kernel.org/T/
> ---
> diff --git a/drivers/media/usb/ttusb-dec/ttusb_dec.c b/drivers/media/usb/ttusb-dec/ttusb_dec.c
> index 825a38759..524be8f10 100644
> --- a/drivers/media/usb/ttusb-dec/ttusb_dec.c
> +++ b/drivers/media/usb/ttusb-dec/ttusb_dec.c
> @@ -314,13 +314,17 @@ static u16 crc16(u16 crc, const u8 *buf, size_t len)
>   
>   static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
>   				  int param_length, const u8 params[],
> -				  int *result_length, u8 cmd_result[])
> +				  int *result_length, u8 cmd_result[],
> +				  int cmd_result_len)
>   {
>   	int result, actual_len;
>   	u8 *b;
>   
>   	dprintk("%s\n", __func__);
>   
> +	if (param_length < 0 || param_length > COMMAND_PACKET_SIZE)
> +		return -EINVAL;
> +
>   	b = kzalloc(COMMAND_PACKET_SIZE + 4, GFP_KERNEL);
>   	if (!b)
>   		return -ENOMEM;
> @@ -366,6 +370,12 @@ static int ttusb_dec_send_command(struct ttusb_dec *dec, const u8 command,
>   			       __func__, actual_len, b);
>   		}
>   
> +		if (actual_len < 4 || b[3] > actual_len - 4 ||
> +		    (cmd_result && b[3] > cmd_result_len)) {
> +			result = -EIO;
> +			goto err_mutex_unlock;
> +		}
> +
>   		if (result_length)
>   			*result_length = b[3];
>   		if (cmd_result && b[3] > 0)
> @@ -389,7 +399,8 @@ static int ttusb_dec_get_stb_state (struct ttusb_dec *dec, unsigned int *mode,
>   
>   	dprintk("%s\n", __func__);
>   
> -	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c);
> +	result = ttusb_dec_send_command(dec, 0x08, 0, NULL, &c_length, c,
> +					sizeof(c));
>   	if (result)
>   		return result;
>   
> @@ -448,7 +459,7 @@ static void ttusb_dec_set_pids(struct ttusb_dec *dec)
>   	memcpy(&b[2], &audio, 2);
>   	memcpy(&b[4], &video, 2);
>   
> -	ttusb_dec_send_command(dec, 0x50, sizeof(b), b, NULL, NULL);
> +	ttusb_dec_send_command(dec, 0x50, sizeof(b), b, NULL, NULL, 0);
>   
>   	dvb_filter_pes2ts_init(&dec->a_pes2ts, dec->pid[DMX_PES_AUDIO],
>   			       ttusb_dec_audio_pes2ts_cb, dec);
> @@ -902,7 +913,7 @@ static int ttusb_dec_set_interface(struct ttusb_dec *dec,
>   			break;
>   		case TTUSB_DEC_INTERFACE_IN:
>   			result = ttusb_dec_send_command(dec, 0x80, sizeof(b),
> -							b, NULL, NULL);
> +							b, NULL, NULL, 0);
>   			if (result)
>   				return result;
>   			result = usb_set_interface(dec->udev, 0, 8);
> @@ -1021,7 +1032,7 @@ static int ttusb_dec_start_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
>   
>   	}
>   
> -	result = ttusb_dec_send_command(dec, 0x80, sizeof(b0), b0, NULL, NULL);
> +	result = ttusb_dec_send_command(dec, 0x80, sizeof(b0), b0, NULL, NULL, 0);
>   	if (result)
>   		return result;
>   
> @@ -1056,7 +1067,7 @@ static int ttusb_dec_start_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
>   	memcpy(&b0[5], &dvbdmxfeed->filter->filter.filter_value[0], 1);
>   
>   	result = ttusb_dec_send_command(dec, 0x60, sizeof(b0), b0,
> -					&c_length, c);
> +					&c_length, c, sizeof(c));
>   
>   	if (!result) {
>   		if (c_length == 2) {
> @@ -1114,7 +1125,7 @@ static int ttusb_dec_stop_ts_feed(struct dvb_demux_feed *dvbdmxfeed)
>   	struct ttusb_dec *dec = dvbdmxfeed->demux->priv;
>   	u8 b0[] = { 0x00 };
>   
> -	ttusb_dec_send_command(dec, 0x81, sizeof(b0), b0, NULL, NULL);
> +	ttusb_dec_send_command(dec, 0x81, sizeof(b0), b0, NULL, NULL, 0);
>   
>   	dec->pva_stream_count--;
>   
> @@ -1135,7 +1146,7 @@ static int ttusb_dec_stop_sec_feed(struct dvb_demux_feed *dvbdmxfeed)
>   	list_del(&finfo->filter_info_list);
>   	spin_unlock_irqrestore(&dec->filter_info_list_lock, flags);
>   	kfree(finfo);
> -	ttusb_dec_send_command(dec, 0x62, sizeof(b0), b0, NULL, NULL);
> +	ttusb_dec_send_command(dec, 0x62, sizeof(b0), b0, NULL, NULL, 0);
>   
>   	dec->filter_stream_count--;
>   
> @@ -1238,7 +1249,7 @@ static int ttusb_init_rc( struct ttusb_dec *dec)
>   	if (usb_submit_urb(dec->irq_urb, GFP_KERNEL))
>   		printk("%s: usb_submit_urb failed\n",__func__);
>   	/* enable irq pipe */
> -	ttusb_dec_send_command(dec,0xb0,sizeof(b),b,NULL,NULL);
> +	ttusb_dec_send_command(dec, 0xb0, sizeof(b), b, NULL, NULL, 0);
>   
>   	return 0;
>   }
> @@ -1354,7 +1365,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
>   	firmware_csum_ns = htons(firmware_csum);
>   	memcpy(&b0[6], &firmware_csum_ns, 2);
>   
> -	result = ttusb_dec_send_command(dec, 0x41, sizeof(b0), b0, NULL, NULL);
> +	result = ttusb_dec_send_command(dec, 0x41, sizeof(b0), b0, NULL, NULL, 0);
>   
>   	if (result) {
>   		release_firmware(fw_entry);
> @@ -1395,7 +1406,7 @@ static int ttusb_dec_boot_dsp(struct ttusb_dec *dec)
>   		}
>   	}
>   
> -	result = ttusb_dec_send_command(dec, 0x43, sizeof(b1), b1, NULL, NULL);
> +	result = ttusb_dec_send_command(dec, 0x43, sizeof(b1), b1, NULL, NULL, 0);
>   
>   	release_firmware(fw_entry);
>   	kfree(b);
> @@ -1621,10 +1632,12 @@ static void ttusb_dec_exit_filters(struct ttusb_dec *dec)
>   
>   static int fe_send_command(struct dvb_frontend* fe, const u8 command,
>   			   int param_length, const u8 params[],
> -			   int *result_length, u8 cmd_result[])
> +			   int *result_length, u8 cmd_result[],
> +			   int cmd_result_len)
>   {
>   	struct ttusb_dec* dec = fe->dvb->priv;
> -	return ttusb_dec_send_command(dec, command, param_length, params, result_length, cmd_result);
> +	return ttusb_dec_send_command(dec, command, param_length, params,
> +				      result_length, cmd_result, cmd_result_len);
>   }
>   
>   static const struct ttusbdecfe_config fe_config = {
> diff --git a/drivers/media/usb/ttusb-dec/ttusbdecfe.c b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
> index 215221370..1c2892a1e 100644
> --- a/drivers/media/usb/ttusb-dec/ttusbdecfe.c
> +++ b/drivers/media/usb/ttusb-dec/ttusbdecfe.c
> @@ -44,7 +44,8 @@ static int ttusbdecfe_dvbt_read_status(struct dvb_frontend *fe,
>   
>   	*status=0;
>   
> -	ret=state->config->send_command(fe, 0x73, sizeof(b), b, &len, result);
> +	ret = state->config->send_command(fe, 0x73, sizeof(b), b, &len,
> +					  result, sizeof(result));
>   	if(ret)
>   		return ret;
>   
> @@ -85,7 +86,7 @@ static int ttusbdecfe_dvbt_set_frontend(struct dvb_frontend *fe)
>   
>   	__be32 freq = htonl(p->frequency / 1000);
>   	memcpy(&b[4], &freq, sizeof (u32));
> -	state->config->send_command(fe, 0x71, sizeof(b), b, NULL, NULL);
> +	state->config->send_command(fe, 0x71, sizeof(b), b, NULL, NULL, 0);
>   
>   	return 0;
>   }
> @@ -130,7 +131,7 @@ static int ttusbdecfe_dvbs_set_frontend(struct dvb_frontend *fe)
>   	lnb_voltage = htonl(state->voltage);
>   	memcpy(&b[28], &lnb_voltage, sizeof(u32));
>   
> -	state->config->send_command(fe, 0x71, sizeof(b), b, NULL, NULL);
> +	state->config->send_command(fe, 0x71, sizeof(b), b, NULL, NULL, 0);
>   
>   	return 0;
>   }
> @@ -149,7 +150,7 @@ static int ttusbdecfe_dvbs_diseqc_send_master_cmd(struct dvb_frontend* fe, struc
>   
>   	state->config->send_command(fe, 0x72,
>   				    sizeof(b) - (6 - cmd->msg_len), b,
> -				    NULL, NULL);
> +				    NULL, NULL, 0);
>   
>   	return 0;
>   }
> diff --git a/drivers/media/usb/ttusb-dec/ttusbdecfe.h b/drivers/media/usb/ttusb-dec/ttusbdecfe.h
> index 73828bb22..96600ad4c 100644
> --- a/drivers/media/usb/ttusb-dec/ttusbdecfe.h
> +++ b/drivers/media/usb/ttusb-dec/ttusbdecfe.h
> @@ -14,7 +14,8 @@ struct ttusbdecfe_config
>   {
>   	int (*send_command)(struct dvb_frontend* fe, const u8 command,
>   			    int param_length, const u8 params[],
> -			    int *result_length, u8 cmd_result[]);
> +			    int *result_length, u8 cmd_result[],
> +			    int cmd_result_len);
>   };
>   
>   extern struct dvb_frontend* ttusbdecfe_dvbs_attach(const struct ttusbdecfe_config* config);
> 
> 
> base-commit: 93f51579e7df248780214094418f205253383cc5
#syz upstream
