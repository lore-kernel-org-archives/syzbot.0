Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 359163B2FF7
	for <syzbot@lists.linux.dev>; Thu, 10 Sep 2026 10:17:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789035432; cv=pass; b=Xfw5e51vXLTIlEvdOyhYgAf5vOTJ+gUy4AYT1J0PAh+J9S67Q31u3L0HcXMuzWbSV8F3pYwFuKcub+zgOzPl4u2ZkEarUqq8gVtFCPy15/RNGer2A/8IkSvyo4EnYGUSyL9HqBRYEQW9HA6gDqaKmrE/BKd2duPl0yK5TvuyFlA=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789035432; c=relaxed/simple;
	bh=czXgxWT9nrItt62YRkju+argb5iYno3a4KSr7rT4V3w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=uvD+++6K/SMVZ8mjejeJMcVJ9GZVLFak+KXsEwdNDkJT+FOfU0ipyl8rWCgN0aBU2bzxu7U+N/TVQ7epU+8NwR2YL9e5nhCSDOg7FjeXqWFJJQeBJWSdnqybtbH/EYYVdMQDMX566FV0VSrTqLs2Fs0XnE3T5XOew5XgkaibD+U=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=qSGiORfo; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="qSGiORfo"
Received: by smtp.kernel.org (Postfix)
	id AB0E11F00898; Thu, 10 Sep 2026 10:17:10 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.208.43
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1789035430;
	b=EssJoxs1HQ6ydxPiugCHLcADbvaNZgpA3ZYVYyO+dHCJGElnjD0v/1x7Fr9g5qrRbMIv
	 rIll1mCvizohdhmQcsapGbWXhPhsk3Xze7Rw51a8KwRlvb7K2EqtGfEAqYaDYfhv3xJ/p
	 y6bgc61wZQoAS8KHP60++PG1u4juYgbVL9gR8rkO4hdA1hwRlY5fCpXtPJRoGynHiqdwV
	 Jp1qT8R1C/zvkZZK/4uGNbc+XyP3+3W7p86AHZwqZp+RAxRbR1zYgvA21gaTduADMiEEG
	 ps81IqdvzMWdzdJOTd5oJOglorDw1DLjYQZ5lv69VsqagJmuRgfuTY38SPLVtHXw4iw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1789035430;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=O5L0T9W5TP2nZxRfRb/1UauWx5PpikLZQtGYjpGigtU=;
	b=hWxb67g6DedyeLrpH7NWKGYYfuWJwz8MGzyvnIX2SkJwYQGBOCwl272uuOnkd90rxUAl
	 znJTwXMFopcKTHErcmV/H/oEvNkSUPynASdXwy4qCr3B60vsN2nn6vI5yY6oy89TE1vi4
	 oE2SElMuLjhkVQMnp59FFGLsR5JNxNQn8dqIxKPDdI7cLfAVKK6jtfTTvBbyg6XOXBLjg
	 jrx5tVzHsDRx2HyIPA6d8yhV+R+s2b4pnBmXDADpxBlayY4duNh/haHmIi7yrt4evWeZH
	 HRCXoYbqUKClL51dfLpV8ZSbk8nAgVC2II0nuqxW+pd9AHO6n47mW8ArTdgIbH+9u1w==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qSGiORfo;
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 1DD241F000FF
	for <syzbot@kernel.org>; Thu, 10 Sep 2026 10:17:09 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qSGiORfo
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 1DD241F000FF
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-69f7fa1c548so11791992a12.2
        for <syzbot@kernel.org>; Thu, 10 Sep 2026 03:17:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1789035428; x=1789640228; darn=kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=O5L0T9W5TP2nZxRfRb/1UauWx5PpikLZQtGYjpGigtU=;
        b=qSGiORfo2tIPCLOjfX9rQDTvj0Kp6sLff2/GeCYoh9Ra0WkqttDLPB7dFPYCUlpuFL
         jX9fruAJ6HzG26x25nvQN1YZUgsaTg2V0+MUL1CZuFLCVhDhbij3suz8FvqIRu0jcFLs
         oOsbwHl1SGOtrtykDl187LTp8w/fo2fwFeWPG4gwgNlmEAGsHxlAcZw15fXdhT33eLtV
         YCcMuFL7fU5J8UCfYaEjdLuGb8uD3ZwulkPm2fZOTqyGN3AnWKoMb+vRkqf0z/yj4eKk
         s5XIdSlXtj/Fv36snoPLXrlUzYI7jyGh8UAOcJRry4YqQF42uMlTmPzmVF6LJVOC9dJX
         hekg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1789035428; x=1789640228;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=O5L0T9W5TP2nZxRfRb/1UauWx5PpikLZQtGYjpGigtU=;
        b=dcLVDnBAxtN10bzmkXuqaNKYEUbMlOaTDUc2uMfk9EYisvpJYfTnpokP+0vo8Lo5hL
         +hcSlfkgIvlfRh1NrBoj2qkgFHtr+eIs2caLp+UOM1ECv3KIUjgeRBOwh9B1WZQMYlxj
         raB9D8dABNdOlFK/Cdc8QxOl0t3FfLgQPhR7Z7SLpjZ45ZSJH8zK0s6i7gNwnjRjBL9S
         7SakXXi6fzyyNkP+zzPjN2Cp7amabiccoBnYwU6BK4Dp0g5dyfiAbkp/OrJC0b21eIFx
         /AO7y4M9hcEn9JK5AqmlgrRyBdaWT5UilacVK076HTguak76KXKrKkh2TCzmtWE0qs7U
         oGhQ==
X-Gm-Message-State: AFuF++n6k0nPdEWbylt0yiGQXLCUUUUyUGTGD0twlPElsvCVKtjuEu3f
	EPXc+wzr+hkZoVTU37cj0SwZ3YwE7doKoIGYIb7Twwr4dIGUAN0MDEVyVBQsjix8
X-Gm-Gg: AYBFou2mP3NQfHNSm1WfxXU+csQeZWQ7TCjDgCEt3nQlqBe95SHweNq1/ltcZjflNXh
	izZZaLg3NiEu699M+u0A4Bn1EhCTlD412LNLzq57+Tnp12q/nUzxGZHGhdTE1vrRZ3GzopfoSmb
	Af8rTotFki53WuuxYtonpIw92pIkCJK0vVkxJVf9voSy6l9vb//JUcSY2nPmmcVX6oXphB0c9Dn
	Kh7HOMBcHZo1VVY+FNuVs+9O3+3uJ2aoV7E7OwBZRS48PxotxwAC/N9WlOE62Q67Fmmv2lXH8I1
	o2rXwtc/L/yx51GB6nXMdBt3XngqhEkWXohAh74Y4QN2xP7kDszT8viraEFBMgfrovCsEGsBflZ
	20s+dnXAOAW38YG4Re82eBujMZeDzop7dQSkV0zJy/f4hE4Rm4kdmRa3YGN86zVNS6k7D3SlAeg
	/IhM4L+nH3+JIbkIxpf2f4XAqIotkj53WwGJHug02XuXQFHvwkkgTjthK5grzyAvjCbb+vAc2Ee
	+8upKHQNo/BR/3qijJTKQoT1HhmDEw/a8hW+uffl3kCZ9e8hkkW9qLxeURn/H5zk5f9axJcNv0Y
	xYgRspWt0wG8FsuUWhDdnk5Y1rBXspvZjqhIhjSvALpikimnujVg+t+gCL1lZymIXnDzWBrTptr
	csaSFxZX5tXUlcMN0ZGwoCaZY2zQIjgPLjPc5S3H1peKZ
X-Received: by 2002:a05:6402:51cf:b0:6a9:9c65:f244 with SMTP id 4fb4d7f45d1cf-6a99c65f50fmr2655832a12.36.1789035428007;
        Thu, 10 Sep 2026 03:17:08 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a904649070sm3166381a12.22.2026.09.10.03.17.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Sep 2026 03:17:07 -0700 (PDT)
Message-ID: <6ed0fc4e-838c-42bc-a30f-c5fa1102af1e@gmail.com>
Date: Thu, 10 Sep 2026 12:17:06 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] blk-mq: fix out-of-bounds read in blk_mq_free_rqs
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <80f75813-8fe4-4698-8424-5faaa6bbf6da@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <80f75813-8fe4-4698-8424-5faaa6bbf6da@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz upstream

On 8/7/2026 9:40 AM, syzbot wrote:
> A KASAN slab-out-of-bounds read can occur in blk_mq_free_rqs() when there
> is a mismatch between the number of hardware queues allocated for the IO
> scheduler (et->nr_hw_queues) and the number of hardware queues in the block
> tag set (set->nr_hw_queues).
>
> This mismatch can happen if blk_mq_update_nr_hw_queues() fails halfway
> through (e.g., due to memory pressure during
> blk_mq_prealloc_tag_set_tags()). In this error path, the elevator is
> restored with a larger number of hardware queues than the block tag set
> actually has.
>
> When the elevator is later freed, blk_mq_free_sched_tags() iterates up to
> the new et->nr_hw_queues and calls blk_mq_free_rqs(). In blk_mq_free_rqs(),
> it attempts to access set->tags[hctx_idx] to get the driver tags. Because
> set->nr_hw_queues was not updated due to the earlier failure, set->tags
> still has the old (smaller) size, leading to an out-of-bounds read.
>
> BUG: KASAN: slab-out-of-bounds in blk_mq_free_rqs+0xde/0x680
> Read of size 8 at addr ffff88818d67fc28 by task syz-executor117/5839
> Call Trace:
>   blk_mq_free_rqs+0xde/0x680
>   blk_mq_free_map_and_rqs+0x40/0xf0
>   blk_mq_free_sched_tags
>   blk_mq_free_sched_res+0xeb/0x280
>   elevator_change_done+0x1d2/0x5c0
>   elevator_change+0x34f/0x480
>   elv_iosched_store+0x504/0x630
>   queue_attr_store+0x207/0x2b0
>
> To fix this, explicitly check if hctx_idx < set->nr_hw_queues before
> accessing set->tags[hctx_idx]. If hctx_idx >= set->nr_hw_queues, the
> hardware queue doesn't exist in the tag set, meaning there are no driver
> tags to clear mappings from. In this case, safely set drv_tags to NULL. The
> subsequent call to blk_mq_clear_rq_mapping() already handles a NULL
> drv_tags pointer and will safely return.
>
> This fix also prevents a similar out-of-bounds read in the failure path of
> blk_mq_alloc_rqs(), where a failure during new driver tag allocation could
> lead to blk_mq_free_rqs() being called with an hctx_idx greater than or
> equal to set->nr_hw_queues.
>
> Fixes: 04225d13aef1 ("block: fix potential deadlock while running nr_hw_queue update")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+e90526cab23b9efcd03c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e90526cab23b9efcd03c
> Link: https://syzkaller.appspot.com/ai_job?id=827b5760-86a0-4f44-9c69-430b572eac12
> To: "Jens Axboe" <axboe@kernel.dk>
> To: <linux-block@vger.kernel.org>
> To: "Nilay Shroff" <nilay@linux.ibm.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 2c850330a..8e6726b37 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3473,8 +3473,10 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>   
>   	if (blk_mq_is_shared_tags(set->flags))
>   		drv_tags = set->shared_tags;
> -	else
> +	else if (hctx_idx < set->nr_hw_queues)
>   		drv_tags = set->tags[hctx_idx];
> +	else
> +		drv_tags = NULL;
>   
>   	if (tags->static_rqs && set->ops->exit_request) {
>   		int i;
>
>
> base-commit: 075b74841bd0065a3bda3440873c747938e69b68
