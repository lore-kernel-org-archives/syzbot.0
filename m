Received: from mail-ej1-f53.google.com (mail-ej1-f53.google.com [209.85.218.53])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AAD2423EBE
	for <syzbot@lists.linux.dev>; Tue, 28 Jul 2026 10:22:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.53
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785234122; cv=none; b=On42IMAcMHfGrVANzE8SyZaic5MhsdK+1XdcW4NYuCdk+p9uklFzfh7dmTpIXlJrHR0ZU487tHyv+PpfIoOGKXo5yVBsmBULh3oa+/DAu/5ov6j/JD4/IpAehmDB5vzrGFPb3mE+o0J5FWGov724TA9jamls5/elhNoe45x6Efk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785234122; c=relaxed/simple;
	bh=XFTAUBeWQpANSCzp7NIt9lEkxaEzwwxcCB7qDgRFKcM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=u1BSiFqEQyE0VCZwnic/PRVjVbECXMPdfAPFDb/FIzVO/m12emyiq4NqoP1HZaGDydPh0sAoS+P8aSaWEVJii83J3x7RToP0t9jGgcTEr8T+a0FGICw8dmcfyC/zppddDRef6yeptL48YLqjSSgtHGzE8ZdqO7TSPLXnyT43ClU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=CsGEIFOO; arc=none smtp.client-ip=209.85.218.53
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="CsGEIFOO"
Received: by mail-ej1-f53.google.com with SMTP id a640c23a62f3a-c1600d040e4so122620966b.1
        for <syzbot@lists.linux.dev>; Tue, 28 Jul 2026 03:22:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785234118; x=1785838918; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=oke9AEf5rH4TDzQHQ+tHAY6Zgp4ct4ebgPo2pkDY9Oc=;
        b=CsGEIFOO9ro2RpJzLqU8P8HuVc3w+SjoD3urwR0NuPo3NxwFfoNlJZB+1rSFYvi/jR
         4D6+VK0S7B9mGd71x31o+HEhUqT5wTf6Pd0WWWbuTKR+Vkq6NvoY6uM7uc29YBwtLkrx
         ZruxoJIFFc+hBVZVVa0VFINxm4VDObGUdzIF0WTLHpKCvgdWZtEApVQIGgcOq1cgpYMO
         6lgODLDilTYYSt/8IWXkYSQRVeAWAUI4D5RqN/oMqbQeklVjwBwL/NyBKSqWeqW0tZHd
         Ge10U0YuJHlvePDW4KYp4griWq0oAuAmVLCsMVT0jqUUe0u5vjYn2W8kK2faf6H/F8gU
         JW/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785234118; x=1785838918;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=oke9AEf5rH4TDzQHQ+tHAY6Zgp4ct4ebgPo2pkDY9Oc=;
        b=FTYICJwyNQJNOdsWgzj3x2ikmjOijztaOorTx69YtKuxiQrBcM7FxiVtErWNAJ6ozd
         wdmymfi4QGcFQPftvv6PTwDQUTPCMVfGCOspfDp07kn0UNBiiOVMGOZJO240qfaMovzN
         h1qpbCZNf+j5y09CbIoa+FSo6Hbmuz0pKWWRFicbWR/9Tb2bKAnOjQhg1F0ayRr8pFCK
         iReHsb4A+YM0B4hsngdOxsoxQ0WepLsj0SF7tzXdBtXjjZzklCJrw495OI4XxeBXCdnW
         ObDtJD4AsmpjGXnah3OnelK+75FWHEA7aAmRJn5sxlixDOK1oy2DqDw9Ek7N5h8VQgg9
         hdPA==
X-Gm-Message-State: AOJu0Yxdp8IX1xE7sZ6zhOZYsfQ0CXQ1yusozskEMFydKgZfGXsCL9vy
	goOoV9idOStyn7HuVt2UhlwAW7W/Cz6G1dNIvtDC8IA82StCvuh99Wwq
X-Gm-Gg: AR+sD10GHMxuNhEeV06HS+ijHac3ILdBjsZjSIhSAARjGANM1+AsAfd+O+ATsSL1B/E
	oZWOnsclBNUPWv2KiMRPq/KzC9nOlBTi5P+my2RRa+evK/duO9cty5U8q2Liq5tttSGNFqCGmWZ
	FhXRRKHZrJ0k5BQbJdbfBiqydwB8QOuyOSiMo9TWj0wK+Q+30FkKUHoakuRIlKujKxvCQo+E+GB
	ulPJntdRxDWQnMWzj1IIsTrpeM1oa3KwK1w9aieyZ7xyEkQUhSgmHOvi+SoJb5wPgHvY2DAq5Li
	kegJQfRw3gwqai3U9yceZk3E4refK6h75b1cr3B5bA1ruBdumLIO4wWTYBG8zfyXw07wFYw/Eyk
	PUI1vKL8oYlrhh/MVCbb9XY4/9aJP6DZTnq//QoDZrC2bxPD/OFGttZq2e3QJcsggaHvW9/p68W
	fBo2SCGmrPZuXt/4eQSCtx+D8p57xPpS6maAHRlTiYQZ20Q0w0UDRHIni+6kSB4qH41NgO+R0YB
	7dSy+qsB+FEg5T2MiRy6O7WClYztVGezPzRWmMnGXshyc8DkyXT//Tqq1y4z71YVSbGK/XK
X-Received: by 2002:a17:907:9628:b0:c1f:65cd:4cb6 with SMTP id a640c23a62f3a-c1f71df046bmr81368166b.18.1785234118412;
        Tue, 28 Jul 2026 03:21:58 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c1c32a76fecsm738809966b.8.2026.07.28.03.21.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 28 Jul 2026 03:21:58 -0700 (PDT)
Message-ID: <12eb7cfa-43df-4a09-bc51-00aaadef7309@gmail.com>
Date: Tue, 28 Jul 2026 12:21:57 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v4] nbd: skip queue limits update for size-only
 reconfigure
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <91ae453b-d78d-443c-9f19-4588fa65447a@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <91ae453b-d78d-443c-9f19-4588fa65447a@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz upstream

On 7/23/2026 11:49 PM, syzbot wrote:
> Commit 242a49e5c878 ("nbd: freeze the queue for queue limits updates")
> correctly added queue freezing for live updates of real queue limits.
> However, nbd_set_size() is also used for capacity-only generic netlink
> updates, so the freeze is unnecessarily broad for the reported request.
>
> When an NBD server becomes unresponsive, it leaves I/O in flight. An
> unnecessary queue freeze during a size-only reconfigure will wait forever
> for these in-flight I/Os to complete while the global genl_mutex is held,
> leading to a global generic netlink stall.
>
> A size-only reconfigure can update config->bytesize and disk capacity
> directly because the effective block size and all other queue limits stay
> unchanged.
>
> This patch introduces nbd_size_set() to handle size-only updates directly
> without freezing the queue or committing queue limits. Capacity-only
> generic netlink reconfiguration no longer freezes the queue, while startup
> and real block-size changes continue to use the existing frozen limits
> update via nbd_set_size().
>
> Fixes: 242a49e5c878 ("nbd: freeze the queue for queue limits updates")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot <syzbot+f272bbfbf8498ddadea5@syzkaller.appspotmail.com>
> Closes: https://syzkaller.appspot.com/bug?extid=f272bbfbf8498ddadea5
> Link: https://syzkaller.appspot.com/ai_job?id=786b3bd0-fdad-4252-9e86-7a6a35c3b756
> To: "Jens Axboe" <axboe@kernel.dk>
> To: "Josef Bacik" <josef@toxicpanda.com>
> To: <linux-block@vger.kernel.org>
> To: <nbd@other.debian.org>
> To: "Christoph Hellwig" <hch@lst.de>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v4:
> - Removed stack traces from the commit message.
> - Replaced "system-wide deadlock" with "global generic netlink stall" in the commit message.
>
> v3:
> - Removed the unrelated decrement of nbd_total_devices in nbd_dev_remove().
> - Corrected the referenced commit title of 242a49e5c878 in the description.
> - Clarified that capacity-only generic netlink reconfiguration no longer freezes the queue, while startup and real block-size changes continue to do so.
> https://lore.kernel.org/all/130f544a-70fd-4ca0-91e8-08824170c91b@mail.kernel.org/T/
>
> v2:
> - Replaced the approach of using parallel netlink ops and custom timeouts with skipping queue limits updates for size-only reconfigurations.
> - Introduced nbd_size_set() and nbd_size_update() to update device capacity directly without freezing the queue when the block size does not change.
> - Retained queue freezing only for actual block-size changes.
> - Added decrement of nbd_total_devices in nbd_dev_remove().
> https://lore.kernel.org/all/514764a5-5acd-4e5d-a8eb-f40c403e7514@mail.kernel.org/T/
>
> v1:
> https://lore.kernel.org/all/69ff9a21-60be-4e97-bc8f-a59e739fd982@mail.kernel.org/T/
> ---
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index fe63f3c55..567b031ec 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -331,6 +331,27 @@ static void nbd_mark_nsock_dead(struct nbd_device *nbd, struct nbd_sock *nsock,
>   	nsock->sent = 0;
>   }
>   
> +static void nbd_size_update(struct nbd_device *nbd)
> +{
> +	struct nbd_config *config = nbd->config;
> +
> +	if (max_part)
> +		set_bit(GD_NEED_PART_SCAN, &nbd->disk->state);
> +	if (!set_capacity_and_notify(nbd->disk, config->bytesize >> 9))
> +		kobject_uevent(&nbd_to_dev(nbd)->kobj, KOBJ_CHANGE);
> +}
> +
> +static int nbd_size_set(struct nbd_device *nbd, loff_t bytesize)
> +{
> +	if (bytesize < 0)
> +		return -EINVAL;
> +
> +	nbd->config->bytesize = bytesize;
> +	if (nbd->pid)
> +		nbd_size_update(nbd);
> +	return 0;
> +}
> +
>   static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
>   {
>   	struct queue_limits lim;
> @@ -375,10 +396,7 @@ static int nbd_set_size(struct nbd_device *nbd, loff_t bytesize, loff_t blksize)
>   	if (error)
>   		return error;
>   
> -	if (max_part)
> -		set_bit(GD_NEED_PART_SCAN, &nbd->disk->state);
> -	if (!set_capacity_and_notify(nbd->disk, bytesize >> 9))
> -		kobject_uevent(&nbd_to_dev(nbd)->kobj, KOBJ_CHANGE);
> +	nbd_size_update(nbd);
>   	return 0;
>   }
>   
> @@ -2062,11 +2080,19 @@ static int nbd_genl_size_set(struct genl_info *info, struct nbd_device *nbd)
>   	if (info->attrs[NBD_ATTR_SIZE_BYTES])
>   		bytes = nla_get_u64(info->attrs[NBD_ATTR_SIZE_BYTES]);
>   
> -	if (info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES])
> +	if (info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES]) {
>   		bsize = nla_get_u64(info->attrs[NBD_ATTR_BLOCK_SIZE_BYTES]);
> +		if (!bsize)
> +			bsize = 1u << NBD_DEF_BLKSIZE_BITS;
> +		if (blk_validate_block_size(bsize))
> +			return -EINVAL;
> +	}
>   
> -	if (bytes != config->bytesize || bsize != nbd_blksize(config))
> -		return nbd_set_size(nbd, bytes, bsize);
> +	if (bytes != config->bytesize || bsize != nbd_blksize(config)) {
> +		if (bsize != nbd_blksize(config))
> +			return nbd_set_size(nbd, bytes, bsize);
> +		return nbd_size_set(nbd, bytes);
> +	}
>   	return 0;
>   }
>   
>
>
> base-commit: 8cd9520d35a6c38db6567e97dd93b1f11f185dc6
