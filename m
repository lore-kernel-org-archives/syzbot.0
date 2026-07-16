Received: from mail-pg1-f176.google.com (mail-pg1-f176.google.com [209.85.215.176])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9510F412C17
	for <syzbot@lists.linux.dev>; Thu, 16 Jul 2026 12:53:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.215.176
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784206440; cv=none; b=upL8lvKtY6MLTZkz/lOX2lOKIOFBl0Km6fcRNF4J8+UDbuxoijQBMOhpiy1CP08mMVVezGxC4z1XdoRsnoyRN1TwcMdiYyUk68S21RWDRmTPavKylS669ppbOq82FqIQHwGVjsNPDxBcy8o6IvZnP/vacwBKHC81ASYvSx0orAw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784206440; c=relaxed/simple;
	bh=A90BLBauvuVrDlYUKcCUbwvJyyl2qC7dI6AiSlvgrWk=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MjEQkUPKbnyhfRN5vfJc6AKFDmsgOTUG2cW4Qo07SQh0OWk1fXOrf1veCvWRHuR7ES18BgfJQ2NMLHPKlt6lHUhD0oTIiokcghZakhSmB2PNgsp1n8bf4yslZUel6Pn0kcrVY7kNJ07Lb0CMR++Rnrcj9OGhTLC59SQIaHfShZw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in; spf=none smtp.mailfrom=devineni.in; dkim=pass (2048-bit key) header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.b=gFTWU9zq; arc=none smtp.client-ip=209.85.215.176
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=devineni.in
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.b="gFTWU9zq"
Received: by mail-pg1-f176.google.com with SMTP id 41be03b00d2f7-c9d1fff21edso4292152a12.1
        for <syzbot@lists.linux.dev>; Thu, 16 Jul 2026 05:53:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devineni-in.20251104.gappssmtp.com; s=20251104; t=1784206438; x=1784811238; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=CbJzIMHhbvDAf2fpXb94fArV8VXjH0zFpF9ygLGGEBo=;
        b=gFTWU9zq3qLk7/ctgttyUDWakOmgOj4QZrmrUKbbs8QrER3FKo9smyd0WC5bGC/AXz
         7R9owkGBZEubsEBX2WIj0i6HN/zl03qDlh2BaspL6AfCb52hL4efucMgs/0gYQkqb0d7
         qlhPJKvYHqd9cwZfh1M3As5lEx19nmG7FqhJqpJZ/zpswmWpxYCKRQza+vcZuKon51Nb
         KY7YgY/0MMDeS2Aaj+9kLe7h0EmZOANEhRWftc84GstgetRh6TX3pbKmslK1auHmNf35
         0RNXOfuitjXO6SKMqzJ2d9X9hPQKAaqdvo8qHPl2IJ/7POWaablZ89lFC5bHKkDLXLsc
         bNqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784206438; x=1784811238;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=CbJzIMHhbvDAf2fpXb94fArV8VXjH0zFpF9ygLGGEBo=;
        b=V3//fyErtzr6h5nzU0l/srXQoLSSkgZWijkg0pkvKEwhT1L4cPmzcrpXhIzdO/etG7
         ijUdJmhthcqKpVCZHyIIeNDO9paBoaxvTXsiQUdnPTLPIb+HIY3zvY2kNT5uGwgC6f8w
         VXD0A7AcX8JWL23b2pGC29VKqvmwMVZO39lf4vCIXutp9qRcGutxa8GpnRej1dIul0oK
         4yvpYfknVhZGdLSyB4BfQOepSddAcprqX3jqItpi2TrRv3iH4Gy3Y1pD1ciITagG6wlL
         JMdXQyP79qfoWMabg7Jx6D5ooajEWOelpzTR4Us3tBXCYxRATQKzNKI5V2BAu+sSiTzl
         2Ytw==
X-Gm-Message-State: AOJu0YzMEAe19hfPWuqcexoKGQwvbu4F7X0d8CAPUHhiNixYxahYFDj7
	LL3yxe6Xl2AwqaPvYKEl44qf5l4kQlACOX8J86YTjNK1Z5PocLoI60Y6JP7zi7rN7jHoAg2k8nS
	dIv0=
X-Gm-Gg: AfdE7cndARdY5z+ySjy8tbHCCipVAyxH3fp8rujh8tfASi5UaIJjmtYKf9/nmX8VbPV
	SOe0+w2bbr6dswq+TWeWCRBYnuF7hGEvVlz+GazRx8OPza9YlfRRrv3kAy91iYmat7N+eyWJXHJ
	4P3QAaQewQ3cQeHR1PDJkDCiZgLaOaxBfS6laLI/Wemr1xgeDiDZ2ZNKUT7AydmCTFSeUY5WADS
	yIFD8AAWafmc6YErVWDIOMM83Gf6zEWXUv0pAJAtog2TxG38ekLXdbpcBv4/FlfdEPHMKsT6fIF
	Cfwo7F01G5ln3/MLWmWm5mXcr77qNswEQSZO4N+fSZLj3zr6KVb9YB67QgpQyvb0/4ZzPxFuGYE
	wA1B2MLnuh5FNpss+VRYXFYweWb4GqUE11JCy39WLMoRU58UUkBmiGoYuCxuGyc7oFqEQNqOb5Z
	Lr915uFcocM6cwhew6tPiq3DsEk8m4vwSG0/dRQCt59f8hnOSW7iweRLKqbbbPEyjWNO3FEpGML
	VyK
X-Received: by 2002:a05:6a20:2583:b0:3bf:6c05:ac with SMTP id adf61e73a8af0-3c34d893ac7mr13533777637.59.1784206437754;
        Thu, 16 Jul 2026 05:53:57 -0700 (PDT)
Received: from [192.168.0.120] ([49.205.97.208])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e530689sm11005537eec.10.2026.07.16.05.53.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 05:53:57 -0700 (PDT)
Message-ID: <1847c3d8-86db-4a68-b6d3-2ee49d3fb8aa@devineni.in>
Date: Thu, 16 Jul 2026 18:23:42 +0530
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] nbd: fix I/O hang on dead socket and rate-limit
 console error
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <48d739d0-05cd-4b5e-90e4-38ae20eb2da6@mail.kernel.org>
Content-Language: en-US
From: Kusaram Devineni <kusaram@devineni.in>
In-Reply-To: <48d739d0-05cd-4b5e-90e4-38ae20eb2da6@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz upstream

On 15-07-2026 08:30 pm, syzbot wrote:
> When an NBD device is configured with a timeout of 0, a closed socket can
> lead to a permanent I/O hang. The sequence is as follows: a request is sent
> and marked in-flight, but then the socket becomes dead (e.g., due to a
> connection failure). Since the socket is dead, no reply will ever arrive.
> In nbd_xmit_timeout(), if the configured timeout is 0, the code currently
> only checks if the socket has been replaced by comparing cookies. If the
> cookie still matches, the request timer is unconditionally reset and the
> request stays in-flight forever. This causes tasks to hang indefinitely in
> TASK_UNINTERRUPTIBLE, triggering the hung task detector:
> 
> INFO: task udevd:5915 blocked in I/O wait for more than 143 seconds.
> Call Trace:
>   <TASK>
>   schedule+0x164/0x2b0
>   io_schedule+0x7f/0xd0
>   folio_wait_bit_common+0x836/0xbc0
>   do_read_cache_folio+0x1ac/0x590
>   read_part_sector+0xb6/0x2b0
>   adfspart_check_POWERTEC+0x9a/0x7a0
>   bdev_disk_changed+0x851/0x17a0
>   blkdev_get_whole+0x372/0x510
>   bdev_open+0x324/0xd70
>   ...
>   </TASK>
> 
> Fix this by checking nsock->dead in addition to the cookie check in
> nbd_xmit_timeout(). If the socket is dead, the command is requeued.
> Requeuing returns the request to the existing fallback, reconnect, or
> failure policy. For the reported configuration where no reconnect is
> possible, this results in the request being properly failed, which
> terminates the hung operation.
> 
> A secondary issue was observed where repeated attempts to connect to an
> already-in-use NBD device cause console spam because the "nbd%d already in
> use" error message in nbd_genl_connect() is not rate-limited. This can
> delay console_unlock() and trigger NMI backtraces. This is fixed by
> changing the pr_err() to pr_err_ratelimited().
> 
> Fixes: 2c272542baee ("nbd: requeue command if the soecket is changed")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> Reported-by: syzbot+82de77d3f217960f087d@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=82de77d3f217960f087d
> Link: https://syzkaller.appspot.com/ai_job?id=40e56b38-627e-4b49-b7ac-d3a21e77dba2
> To: "Jens Axboe" <axboe@kernel.dk>
> To: "Josef Bacik" <josef@toxicpanda.com>
> To: <linux-block@vger.kernel.org>
> To: <nbd@other.debian.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v2:
> - Updated the commit description to precisely detail the sequence leading to the I/O hang.
> - Clarified that requeueing returns the request to the existing fallback/reconnect/failure policy.
> - Highlighted the console spam as a secondary issue.
> - Switched to pr_err_ratelimited() for the "already in use" error in nbd_genl_connect().
> 
> v1:
> https://lore.kernel.org/all/b5a8f0cc-71aa-4deb-8864-29d7f0c5509a@mail.kernel.org/T/
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

