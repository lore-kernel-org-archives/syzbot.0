Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA510427FA5
	for <syzbot@lists.linux.dev>; Wed, 15 Jul 2026 12:04:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784117095; cv=pass; b=JlwtzG9gyvW4KyR9K5U1D9C2fyF411G7wJ8vDjmeE82U8+jatc5POKRKXK2mujSiLYd47PhRe0fdaKXouch3lHYQAsjyCDR3vhB+teSpGKtqTAV0HGgsdnlM08pGejL32bMWVytVEBARNSGiuT85P1T7t5pjC9FC/KYVmamLfGw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784117095; c=relaxed/simple;
	bh=eOYJoaPIu0HpFW7AvryY1SzDclbNrLaewhnYo0Glepw=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=g/p/GXRf/sKfXR2gE8QHR+Wrh4Y3W5CRUYC97BK4usNNvdwynGa4xWSWZ5EAy2fTn9cBjdsrV6JHv4as4jN9o2uhJWM6TKqLlCe0+zVa+KzllQTfClOjUv+P+OrcjZHlVgdEON/jVjphvyyetSqxeCtNBzwD8Nj+2jUH3ArfoEo=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.b=Btpyrwv1; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.b="Btpyrwv1"
Received: by smtp.kernel.org (Postfix)
	id 3FE571F00A3A; Wed, 15 Jul 2026 12:04:50 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.216.41
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1784117090;
	b=qg+o/iD1ouoDdmGoou3x2JCi95JZ1Iov3ayYdeJKo/5xueh7NzOMdGNtFnVWfjfWvByg
	 8eROdMvvLgqi51Yh4I2ITyU9ckJ1mzTi0jHOjo11KlCFYMIqoSiFgMqEoFWxL9IaICXE8
	 EjEwFTrKRzk/wcujR1oKGQPgbjGAmOMlrt7qSEphQ2R9Dae78FK+j1mMSS4SKt4LFP0i0
	 IS0iRRQcKWDrZkXY+Weu+shg2BaWUZqDA0A9SgPyzwRMGUbLXiWrl8MR0qAm+FVITWdt4
	 eCqmTU4PYtYOWNEfe+XHSkthxxQLWTCX0v367pVVUvbtP/NhiSOaHgqIFc36bMuPfyw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1784117090;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=r3LhKCyIxXXA/RnwbAZEx6g1L13tEs9YwxgKsyGWmo4=;
	b=hp+x9Pot7TK5ynSnT8oH0IVik7/twUpx2NS+zhyAFkKv8Jn+rJ3XA/Sshrm1YDnM61j4
	 LWDCpTaWJuM+NvxP+ZlH6uasz3lYsfWLjJrg+HS042iShWHVswqusILZc/CltMMVxjNte
	 8qutSxHsHQ1PCEzdwwK0uIDakak2XRX4WwPX+GperGeyhgBtUR6GqnutCXesDwQO+RQXc
	 tZtGCBtf76n/BG9Fydp1hVonkawof3K8YVwf/x5X0cxX1jkYsXT9ziPR1zUzYA6Z8uRRm
	 Kl7+bzt5MnT1CgwJ7H0sXOHaXiyAK3Syjlf2CFDACCPlale7iLH47lBgRDXN9jTQFzw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Btpyrwv1;
	dmarc=none header.from=devineni.in;
	spf=none smtp.mailfrom=devineni.in;
	arc=none smtp.remote-ip=209.85.216.41
Received: from mail-pj1-f41.google.com (mail-pj1-f41.google.com [209.85.216.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 321A21F000E9
	for <syzbot@kernel.org>; Wed, 15 Jul 2026 12:04:48 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=Btpyrwv1
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 321A21F000E9
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in
Authentication-Results: smtp.kernel.org; spf=none smtp.mailfrom=devineni.in
Received: by mail-pj1-f41.google.com with SMTP id 98e67ed59e1d1-38deea72eebso3293857a91.1
        for <syzbot@kernel.org>; Wed, 15 Jul 2026 05:04:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devineni-in.20251104.gappssmtp.com; s=20251104; t=1784117088; x=1784721888; darn=kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=r3LhKCyIxXXA/RnwbAZEx6g1L13tEs9YwxgKsyGWmo4=;
        b=Btpyrwv1tuatPpCIcju0o/cPakHh/fZsPBRdVAgr897fLdhGPiRl1kClSbPGwJczkx
         k2TPpUjC2jOcyMqAN5g7nM7rRG/oTRaSYVTEJ93FDz3btA4Ex7fn4a2jQVx8lC/fu/gB
         0rSgOiguXTTghjlJ0GDaV7OtQzj1w+4LJUqvPK6+jRcsUWEIMpAH3ALqW4iIxScIKpAO
         IWn9A8Zy46jzfPa7VIrne3nDxmmnmMurvmhjGDhqg8Y0zGjxWAK9p2RRWz1IKh7MC3Sr
         rdCtNk/j6Heh8ecTKrnUcDVPyzHsOVue71tilNT1A04G0mHxdn5O6VS1EHqXiNLMXJFo
         JI0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784117088; x=1784721888;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=r3LhKCyIxXXA/RnwbAZEx6g1L13tEs9YwxgKsyGWmo4=;
        b=jrQasKKwk2LxHDtq3hw9xMD3gzZ/xTenK3l4qxkpJlMC2SVFZ6eoCrF7Du57KUPLDs
         sazq0wQobiJe84f/EzfJ2fKz2/Lc2AfDROW2tJLkBGwN0ya+IfjGTBKBwAZ+QoYt1l3P
         MbFJmBaHHB3UZQiM9ebm/GdggJtSrAK6ntXVLdmumYyLdTBALTbDPrptrK47YJNMfaHU
         gQkvkDFxJRkGCbts463s3XjH3iJUd5br6VjJmerAZobFV/YDAmNdlglNBIiPetIKzvyh
         +JwYbQkqlMcI9G3PEFrWohOTGnJRis7+XLV7EOkqSl/LScUta3ZA48BG4PFRSWJhTTST
         E5Ow==
X-Gm-Message-State: AOJu0YzIBu+rZzx4WZ6xAd9mmwpF2PZ7HpdRFT904CtqTThuZfy907Hm
	8Ew1EoFO8MTUHNRBCqrVAljmCd6jbSxazQ1xr9zCb39iOw+pb6vlgN1VSJYjom/7FnZM5ZBrHCR
	ZGHM=
X-Gm-Gg: AfdE7clhlfZNmaXMDG1jiKvtiQ9E+er0cDe44IHjZZ2bajP3qess0kx/pZY5dNYRyIJ
	YB579KLwsMnMuRvpLukghdYb6rUB6G6zczuQ+RJsS6w7A1unmA7+REldaUKZekBjGkXDi/4Mno6
	US9A2AXlBGPGDaV9sVS+hrxeWKr9osc3UGp75JFHynC7rUR/64Vg5R88AHYFR9nqAJCJyaZUtfa
	fMuTCihweDoaPDJvYXod6xrim1TFaMazLgoFclbeouGMgP+tMDr/x5skSciMbDIRbZz49PgZY3A
	/h1hgOs+Q1eq/8iB48tjw1c+SlzhGzcGMmek3GPOSrAzmczD4zIE5TNhcPBbuwSf79P4mAk+qnY
	c8GbA6EISFHKTKYvpS3N2gLGkddHbME52e+/cHHS6q3R1qL/xe+ROsiWgFpSZJHgJeNDTPLHqrs
	FvAe0fawvIyJOc+Y3/vdXDRW/HbhzV7JP01FALINIUG/QZ/89bAY0zBhNPigvDQgAlTCuY1yx+7
	mls/SntE/TkQEXk7enMm+Htww==
X-Received: by 2002:a17:90b:3cc6:b0:38d:f710:63f0 with SMTP id 98e67ed59e1d1-38e2a109136mr2058484a91.43.1784117088153;
        Wed, 15 Jul 2026 05:04:48 -0700 (PDT)
Received: from [192.168.0.120] ([49.205.96.190])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e4fc28dsm1066743eec.2.2026.07.15.05.04.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 15 Jul 2026 05:04:47 -0700 (PDT)
Message-ID: <1e65fb34-1a53-4e10-b4ee-8476933fc7cd@devineni.in>
Date: Wed, 15 Jul 2026 17:34:34 +0530
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] nbd: fix I/O hang on dead socket and console spam
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <b5a8f0cc-71aa-4deb-8864-29d7f0c5509a@mail.kernel.org>
Content-Language: en-US
From: Kusaram Devineni <kusaram@devineni.in>
In-Reply-To: <b5a8f0cc-71aa-4deb-8864-29d7f0c5509a@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 09-07-2026 06:11 pm, syzbot wrote:
> When an NBD device is configured without NBD_CFLAG_DISCONNECT_ON_CLOSE and
> with a timeout of 0, a closed socket can lead to a permanent I/O hang. If
> the connection is closed, the NBD recv_work thread marks the socket as
> dead. However, if an I/O request is sent, it will eventually time out. In
> nbd_xmit_timeout(), if the configured timeout is 0, the code currently only
> checks if the socket has been replaced. It fails to check if the socket is
> dead. As a result, the request timer is unconditionally reset and the
> request stays in-flight forever, causing tasks like udevd to hang
> indefinitely in TASK_UNINTERRUPTIBLE and triggering the hung task detector:
> 

the case here is an in-flight request sent while the socket was usable, 
followed by that same socket becoming dead before a reply arrives. state 
the sequence precisely to avoid ambiguity. i.e. request sent and marked 
in flight, socket becomes dead, no reply can arrive, and the 
zero-timeout handler keeps resetting the timer because the cookie still 
matches.

> INFO: task udevd:5877 blocked in I/O wait for more than 143 seconds.
> task:udevd           state:D
> Call Trace:
>   <TASK>
>   __schedule+0x17e7/0x5630
>   schedule+0x164/0x2b0
>   io_schedule+0x7f/0xd0
>   folio_wait_bit_common+0x836/0xbc0
>   do_read_cache_folio+0x1ac/0x590
>   read_part_sector+0xb6/0x2b0
>   adfspart_check_POWERTEC+0x9a/0x7a0
>   bdev_disk_changed+0x851/0x17a0
>   blkdev_get_whole+0x372/0x510
>   bdev_open+0x324/0xd70
>   blkdev_open+0x461/0x600
>   do_dentry_open+0x816/0x1380
>   vfs_open+0x3b/0x340
>   path_openat+0x2e44/0x3830
>   do_file_open+0x23e/0x4a0
>   do_sys_openat2+0x115/0x200
>   __x64_sys_openat+0x138/0x170
>   do_syscall_64+0x15f/0x560
>   entry_SYSCALL_64_after_hwframe+0x77/0x7f
>   </TASK>
> 
> Additionally, repeated attempts to connect to an already-in-use NBD device
> can cause console spam because the "nbd%d already in use" error message in
> nbd_genl_connect() is not rate-limited. This can delay console_unlock() and
> trigger NMI backtraces.

keep the logging hunk, but present/highlight it as a secondary issue 
observed.

> 
> Fix the I/O hang by checking nsock->dead in addition to the cookie check in
> nbd_xmit_timeout(). If the socket is dead, the command is requeued. When
> nbd_handle_cmd() subsequently processes it, it will evaluate the dead
> socket and properly fail the I/O request, gracefully terminating the hung
> read operation.

the phrase "properly fail the I/O request" implies that failure is the 
inevitable result of requeue and hides the other existing 
nbd_handle_cmd() outcomes: selecting a live fallback or waiting for 
reconnection. it also does not explain why failure is expected in this 
report. describe requeue as returning the request to the existing 
fallback/reconnect/failure policy. if immediate failure is mentioned, 
qualify it as the outcome for the reported configuration rather than a 
universal one.

> 
> Fix the console spam by changing the pr_err() in nbd_genl_connect() to
> pr_err_ratelimited().
> 
> Fixes: 2c272542baee ("nbd: requeue command if the soecket is changed")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> Reported-by: syzbot+82de77d3f217960f087d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=82de77d3f217960f087d
> Link: https://syzkaller.appspot.com/ai_job?id=13cee482-fa85-4a3d-bcc1-e2cc9ae8e909
> To: "Jens Axboe" <axboe@kernel.dk>
> To: "Josef Bacik" <josef@toxicpanda.com>
> To: <linux-block@vger.kernel.org>
> To: <nbd@other.debian.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> diff --git a/drivers/block/nbd.c b/drivers/block/nbd.c
> index 8f10762e9..eedb1c870 100644
> --- a/drivers/block/nbd.c
> +++ b/drivers/block/nbd.c
> @@ -523,7 +523,7 @@ static enum blk_eh_timer_return nbd_xmit_timeout(struct request *req)
>   			blk_rq_bytes(req), (req->timeout / HZ) * cmd->retries);
>   
>   		mutex_lock(&nsock->tx_lock);
> -		if (cmd->cookie != nsock->cookie) {
> +		if (cmd->cookie != nsock->cookie || nsock->dead) {
>   			nbd_requeue_cmd(cmd);
>   			mutex_unlock(&nsock->tx_lock);
>   			mutex_unlock(&cmd->lock);
> @@ -2172,7 +2172,7 @@ static int nbd_genl_connect(struct sk_buff *skb, struct genl_info *info)
>   		nbd_put(nbd);
>   		if (index == -1)
>   			goto again;
> -		pr_err("nbd%d already in use\n", index);
> +		pr_err_ratelimited("nbd%d already in use\n", index);
>   		return -EBUSY;
>   	}
>   
> 
> 
> base-commit: 8cdeaa50eae8dad34885515f62559ee83e7e8dda

-kusaram

