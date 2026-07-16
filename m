Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D7AD13AA9D8
	for <syzbot@lists.linux.dev>; Thu, 16 Jul 2026 09:37:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784194639; cv=pass; b=oViKP/SlwbtY8UzycxNuGpg0jeHlLni+D3RRhOUzFL6wmnFSoiDBjqDJfJCvPBjyS8bHXZ1zAJ4mwQM+5AMls5Mhq++n9AQQ/SGckOEWY6OX2J20RGAudXqPuHoucxOxu9BWsxkAauna9Gx1GeKFq+B+Z15bXvTTp711R8g8+s0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784194639; c=relaxed/simple;
	bh=2PaCigCHQZs4w+Oy04TiLuuKqzuHnRdcV5JBGZ0KPoc=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=D8kTjrX9l50dsFXNKO5qku2axfd3YSbP9RcTVqLZL921e19Oi+OivBUwR25JIs8J/FAlPuAik6Mkc88CrMahwycj8Y+sBuZFYHHzmIYnxhAyjcrB5f8jHrHDN7fEtwohY65HYdPuExJPycJ5ygh71ei1vQo/AGEzi0EU4H/W6kA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.b=I1lQ46QH; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.b="I1lQ46QH"
Received: by smtp.kernel.org (Postfix)
	id D2FDB1F00A3E; Thu, 16 Jul 2026 09:37:17 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.216.49
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1784194637;
	b=m9GLFsrYqNXwS3quBHb1aF28mgvKrPcLak9ciCYUXb+4UbhaHtC7HKr6utIVcZgQIkyu
	 5XrtCBFOL2h53ETORFOSgyKFUMWyCs3qy2aRSCoI3e2VFYzizuyGDkHs4fQ+v3+IbcOMV
	 swiChkPhpZWx6lnNfzSRSTj8NUbC6MiBj0MhGRutzQ49qj3YRE//STcOqecCWoUIxZmCr
	 lekYp2cvGvIAp5n0YfptCVr5WcrmfdiWobvClWOf+z/Y+NG2n5Y01/NO5/BJ1XVseiw/H
	 OMlMxUGoGnRBH8mH6YAT1E2hGRoC/KLIZl7eDK4CvHCq66yXo4C1d8nrOo7pTmG40nw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1784194637;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=SNQnr/qR/inMN8+w+aN1kWYRb+e+EAfxfr6aQ3fRMOw=;
	b=baednWF5rWCkMsAoW5gd2XLEOp2Y9GhLQV6omfM7BAbTqCafEcyrBZ4bMXJ+oDDmarQm
	 x6/qbFenHeu76wmJdSK8mws+EnWTmQ3lapTDlxkbxW6W2UiB5CVzjDcsaoMUAJC2kqemQ
	 YpssqQAr1tjZwXekHQwS4XiJ8g20eBrHE416dE8EptyB4jQSbyH23MKypJwBI0tRf7erq
	 Cokw/aqOyd/BgfhWHDmj0mF4jgG2AuPtCwB0EImtu/GwKhQdUc5YtMhvI91CPVlhR2k8H
	 YO4KpLki47ZWG7X4FwGEQcWatgHCXd1UwHIBHXgA41KlIqCRuMUjMzZxJy6q2wvRbog==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=I1lQ46QH;
	dmarc=none header.from=devineni.in;
	spf=none smtp.mailfrom=devineni.in;
	arc=none smtp.remote-ip=209.85.216.49
Received: from mail-pj1-f49.google.com (mail-pj1-f49.google.com [209.85.216.49])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id ACFE71F000E9
	for <syzbot@kernel.org>; Thu, 16 Jul 2026 09:37:16 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=devineni-in.20251104.gappssmtp.com header.i=@devineni-in.20251104.gappssmtp.com header.a=rsa-sha256 header.s=20251104 header.b=I1lQ46QH
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org ACFE71F000E9
Authentication-Results: smtp.kernel.org; dmarc=none (p=none dis=none) header.from=devineni.in
Authentication-Results: smtp.kernel.org; spf=none smtp.mailfrom=devineni.in
Received: by mail-pj1-f49.google.com with SMTP id 98e67ed59e1d1-3856d6fbcb3so2872211a91.2
        for <syzbot@kernel.org>; Thu, 16 Jul 2026 02:37:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=devineni-in.20251104.gappssmtp.com; s=20251104; t=1784194636; x=1784799436; darn=kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=SNQnr/qR/inMN8+w+aN1kWYRb+e+EAfxfr6aQ3fRMOw=;
        b=I1lQ46QHityb8UDyQJPd/34oMKy9lcO/6rBFAf3Uwb9BzQaA6dyp8HEQ5SAwkZ9/yV
         uSodC58FhyJa+/MBTvsYFM4EzLD97RmPDHpqaav8rVDdo/vFbhtBkPI/n2braVLbpHO+
         Grxdro+bNSYsHajzsfx2SwAwH/ls2Azig3kTYgpPf5Emq3fUkALpNH0h/u5RE4UsdrPO
         iyvJGjE2LXFcdPp2T7Bkpfjrh+2Ojzm6kr80PtUUg2deyOBMZTs/hLx2LydJAJS3zydl
         fPuuZVqIIzP8UNLbve4Gcaf7H8LXqJLqdjvFudFixFw2Mo8jEjhfDrCBI0zsR1x7efcd
         mDRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784194636; x=1784799436;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=SNQnr/qR/inMN8+w+aN1kWYRb+e+EAfxfr6aQ3fRMOw=;
        b=GM6nYoSG5J+jc2y2eB1dsTjFYopDZCdXW9RnTstkjmqgBn21GoaLVGCPqXSTm+wtTZ
         0gY7WIBhB6yFFM2pI3/YwoW54vJTqStCSHk2/jeIv27wTt+ohDxKFQEQsALxbfKQBRVd
         s2kupmmxxMZ7KSikIeNnenCsEJ6T5A/QazTpb/aQWey4wTR/12MymMS5218Og5885AKj
         zQiBMztAljWB5KCgXb0bYDCXZ32S0WUFkOamYDa0/AKraESfuqwLVG2e8murI6sUn1bI
         tF3w53aMxcyVCx8Oj5s/+JitOnjxd2aWvAS2QKSB2uUrvBEhMzYQ8tNoryS3ld5kHNdW
         1iMw==
X-Gm-Message-State: AOJu0YxLLESV5bP0PYzoxpaHL0BvOUIOf61fe9MyeDw02Dnf+p/8e/Cf
	btz4ZHnROK69ixZKbx5dGk72Pe37X2J72gbR3t/lPYeXrli6Q264fKk12SnJG47w5zKrd4548M7
	rHWE=
X-Gm-Gg: AfdE7cnnigwAVwlGvCJIWMJLXRGCaLdmkANVN8epCfq8u9EgPVcbGqNTU4UOBp7RPGu
	CiYtOuGNbvzJG1+0Q5fIVKHQSqkTOOoBr5hmJW8PwpILuKN2+z7vmqe26SZ2dKdh0gruc12MKxQ
	mJ8OsS3juk5oFKg8S+d4pIwA5aTVAVoUFF2uLgszfOWW79bkypOnstEUcExaRBaKVETDyGASuki
	hjo/xb8vHzAExBvsI2mWg3olbNv2amk2pmJKQp3cGe9skXXElU0RqGlpD16RcNlsi4Pz/MzDUej
	1I66wNZ7i7I5JaWOvAEHKn//D1mjgNJL7FAVT3ObEAjxSp3d0tXX50PA1ucTLYfF/XgVHf2KcbK
	I6LcWWk6OBfOTFPWW0PH0VhI6oPqDhco35RPZrCzJ41UvBqjMwC5pTBpy3lkIvDEBs5NOESP/VJ
	LhkukzX19CNUYXxoCnzi+ag80TUhTfMFi1j5n4w/eT8Q6NallV4jex49SzgkSg7MfxHqM25L469
	e8p
X-Received: by 2002:a17:90b:1dcf:b0:38e:673:5d18 with SMTP id 98e67ed59e1d1-38e06735ef7mr12352198a91.36.1784194635807;
        Thu, 16 Jul 2026 02:37:15 -0700 (PDT)
Received: from [192.168.0.120] ([49.205.96.190])
        by smtp.gmail.com with ESMTPSA id 5a478bee46e88-3140e4fcd26sm9332363eec.5.2026.07.16.02.37.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 16 Jul 2026 02:37:15 -0700 (PDT)
Message-ID: <5e17cf14-b8a4-4a50-a10a-8a40d4256e28@devineni.in>
Date: Thu, 16 Jul 2026 15:07:01 +0530
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

#syz upstream

-kusaram

