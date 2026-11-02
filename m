Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793617740;
	b=DKP5Q2yB/0C0oULNOFh4J4Abj6Tnt9pX9XN97qkrGZNZU6YdbxYeFJ40dUYRkeIi1NE7
	 XfIQv2+j2Rme+pwkkGaoSp5Ue5whl8HB6hzdYMmXbt3u4C9G71zO7pWWUXnzskf8BVyYr
	 2pSleZvOvX1hcI0OsKGGOOxnEDOr4iETN0NnzF/x7JcokmKuDe5wfbd39UyIsqndwTfg7
	 oiObpMOeC3M+n29OJOribIn0/dAiIl+7bY2QuaW21f3p8Nyst/3xX/kWM1ZKxJoCbaRVp
	 f6D56YGcd7GnCUYDAA2w25CuOeCVgaxTDcIlbfbK6oVKo0583Vszd2xyCp/UgOR9jJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793617740;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 Message-ID:Date:MIME-Version:User-Agent:Subject:From:To:Cc:References:
	 Content-Language:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=kogwx6wOFEx8wkc1OUmn08NcuZSkF+8EZ7OoR4vifO8=;
	b=fzaXo+oTYwZU2yEMeqbqfY6D9bBcOQdEBAOGuEhDrAQ3ksFntjRSXH0EnkNadNTqUc+/
	 LGjJiVYjN0otQGFfS/nzVIs67JtJinDYrWK1dvE7cg8m7Wz0BkL2OVedmTN3EEMAB6x/x
	 OO35OsOPSqKEwkL6H/GCkDmTjQjB7KuORLhN6a4baov7g/hfN+x5IoVhQCq+Ukim6HXyz
	 4bxN6e4Hg56EO7u4dHhtgA50EwAS24gLXa9SoF67MbTs7jXR4rKU7QGT7a2d6a5uMVd7z
	 d2yms1xYdujPlz2kmBpZB0oY6sNSaXvCcbjTdKaNA32bGj6rqrYWtJs+7tPhCVkm0TQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u5y6Xhzv;
	arc=none smtp.remote-ip=209.85.208.45
Received: from mail-ed1-f45.google.com (mail-ed1-f45.google.com [209.85.208.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2120F606A327
	for <syzbot@lists.linux.dev>; Mon,  2 Nov 2026 11:09:00 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2120F606A327
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20260707 header.b=u5y6Xhzv
Received: by mail-ed1-f45.google.com with SMTP id 4fb4d7f45d1cf-6b1aa4d71e7so2945886a12.0
        for <syzbot@lists.linux.dev>; Mon, 02 Nov 2026 03:08:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20260707; t=1793617738; x=1794222538; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=kogwx6wOFEx8wkc1OUmn08NcuZSkF+8EZ7OoR4vifO8=;
        b=u5y6Xhzvs4yB76v+rvZs2UCiT7IiUzzHwdmzc8Jvz261VdCO/XJYJPlcS/qLk+PqMq
         MKNsK9gJ7EOtXphpscfHdQNlQND34TazDi1tQm1okCcy5HFeqoN0TYqDUQVdQcNinj+N
         megqyvs9kQdLXrZUX5nyqsw+Ri+5sUnSFMqrRYP/nNVxcI61YCzsTgiJKDRmOjbY2/6K
         1uiLvURVnTQc9Pb+JaBSq80qC4vCcczXSkt66jtauX+Lim5Hx0yKkrklGr41tDW8HlY6
         nEb81hD5VPpNIxdSgd4z9ZAhn/zbykSJygt8mT9afsXjKPmQecdZDcbeAMd4bNnUixtF
         x8xw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1793617738; x=1794222538;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:cc:to:from:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=kogwx6wOFEx8wkc1OUmn08NcuZSkF+8EZ7OoR4vifO8=;
        b=YtoDyBvvPy5i1jh+QmyPzSwkQs5eZ6c4LhODBCQVdrzGFBh/jMX8K+wrMLpcI5m1bH
         T+Cq3a0gSc2tzOgvRBid2YOsXuRht6inbXjFj+v8hqwxNn+GdeN7j2ZjpGoQzh0c4Mix
         0Ca2s1W0hKDvqB1WRM1ZP3dwfr2o7jTI9VNn2c4xiPKKkfytOx3DPM1SvrNwVHP8KI9d
         nXms1pQJL2CJlRciIxEDq7WxWiII+bZ7ABDjGomJEdEKhxVdSnhfU3scZmXFZc8HjTdH
         YJcBFLwocwzQJuWh+1ztCetYsLKJJvRHstlQ9Pc2aAw3MXUD2vz6Klp0oAuwEHWrv67N
         BVeQ==
X-Forwarded-Encrypted: i=1; AKwUvBwS52YS0aROineWchI3iaWnqVaqqQRy2kmCc6nDIQk95eVemuhz9Kc3jjViuPKpp7f9KBtqwZY=@lists.linux.dev
X-Gm-Message-State: APuU4Z/cvCz/WUvLuWtlzAdsEVjp8t2KgTvKT+mlEDS8y2lj92PbHNEI
	U7ljmGNlWlcVijHTCcNoGuYs579edORpb0FS8/6lOs+WOhpMmL5+zTWg
X-Gm-Gg: AYBFou0ln54FdsYT1L/YhXi7t8UicwJIooMyT1F2lhM3ZGVBUX08Cl6OQy1jHpochu8
	RHdfun0rRWV80udVsb9TpuC2833t+lLUglyzcjRF77S2O/2gNpyezodp1fVt0RNgugtKRuGqDEe
	i/GBEVhiHEoVFVNp+ahf4CCB4hGqSpQ1Tlawrvs3BfrO5X/oKEjCb0HooUfBot7E/UJ3Vh3BBWt
	+43gJXkkMbcCHbEGRYXQjXWbAia+MlAXkosWbD3e9ahlzuwyv9X435NqCJ4e/aMBeDa6RmUmfvg
	q68BEo6ACrqGZH6ITdSv+47Iv0Gdekhdeij3IjXVAYd13xz809Y1OsqvAF/0iB8NB4yHlu74T7C
	0E9n6qv2CyYHp4qP00uQyCUIXNHtbe714QduDc0jKLbzSEn1ZI82iVF7yDl2RfUlg9kc7QrbAEi
	RP/Gqf+x4ExGWIOnV8dXCSO0/4lzqMI8EmoTY7vZND/dkDXvGbsnKQWGLJqONEK9QG2Kf4mkg2H
	6P33yZJRRfgEEaYJt6kV6lPbL8K857534KtR/YjesFrRUoWE7feUkQxpnLxUSlTe5/r/2W4B7Nn
	Q8iyv1WwRffCuffWHb+rOdwRSiTugKDy4peMvBusxPCQ9y+BrFW55jvLjgA3b1VvsF3lzb4xFzX
	UG4Wx5ycubRTFpwe+mCwAwe9CT5SPPs1zdU/1zbPRe7u8jHooQR0DkdmRh9pkw532Tak6f7CFY4
	eXqIhARgFwBPCgQu/z5zZZSByzWzThA3GGZ0uQ0wbf6wd3aN2LDQSTMaoLQBPbGXg=
X-Received: by 2002:a17:907:7fa5:b0:c40:eb1a:4c8b with SMTP id a640c23a62f3a-c4ca7a6d245mr730198166b.29.1793617738242;
        Mon, 02 Nov 2026 03:08:58 -0800 (PST)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c4cabe93db0sm364494766b.66.2026.11.02.03.08.57
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 02 Nov 2026 03:08:57 -0800 (PST)
Message-ID: <a8fb3606-017b-464e-a09f-1f1ddf3bc45e@gmail.com>
Date: Mon, 2 Nov 2026 12:08:57 +0100
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
Subject: Re: [PATCH v2] blk-mq: fix out-of-bounds read in blk_mq_free_rqs
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-block@vger.kernel.org
Cc: Nilay Shroff <nilay@linux.ibm.com>, Hannes Reinecke <hare@suse.de>,
 Ming Lei <ming.lei@redhat.com>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org, syzkaller-bugs@googlegroups.com,
 syzbot@lists.linux.dev, syzbot+e90526cab23b9efcd03c@syzkaller.appspotmail.com
References: <20261014170538.1089448-1-krystianmkaniewski@gmail.com>
Content-Language: en-US
In-Reply-To: <20261014170538.1089448-1-krystianmkaniewski@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/14/26 19:05, Krystian Kaniewski wrote:
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
>  blk_mq_free_rqs+0xde/0x680
>  blk_mq_free_map_and_rqs+0x40/0xf0
>  blk_mq_free_sched_tags
>  blk_mq_free_sched_res+0xeb/0x280
>  elevator_change_done+0x1d2/0x5c0
>  elevator_change+0x34f/0x480
>  elv_iosched_store+0x504/0x630
>  queue_attr_store+0x207/0x2b0
> 
> To fix this, explicitly check if hctx_idx < set->nr_hw_queues before
> accessing set->tags[hctx_idx]. If hctx_idx >= set->nr_hw_queues, the
> hardware queue doesn't exist in the tag set, meaning there are no driver
> tags to clear mappings from. In this case, safely set drv_tags to NULL. The
> subsequent call to blk_mq_clear_rq_mapping() already handles a NULL
> drv_tags pointer and will safely return.
> 
> Fixes: 04225d13aef1 ("block: fix potential deadlock while running nr_hw_queue update")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+e90526cab23b9efcd03c@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=e90526cab23b9efcd03c
> Link: https://syzkaller.appspot.com/ai_job?id=827b5760-86a0-4f44-9c69-430b572eac12
> Reviewed-by: Nilay Shorff <nilay@linux.ibm.com>
> Cc: stable@vger.kernel.org # 6.17+
> Signed-off-by: Krystian Kaniewski <krystianmkaniewski@gmail.com>
> ---
> Changes since v1:
> - Drop the additional blk_mq_alloc_rqs() claim, as that path is bounded by
>   set->nr_hw_queues.
> - Add Nilay's Reviewed-by tag.
> - Rebase onto current mainline and refresh the recipient list.
> 
> v1: https://lore.kernel.org/all/c92b0c7e-17fb-44c8-99d9-59d45004d05a@mail.kernel.org/
> 
>  block/blk-mq.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/block/blk-mq.c b/block/blk-mq.c
> index 025a799f35b92..259a5705efb79 100644
> --- a/block/blk-mq.c
> +++ b/block/blk-mq.c
> @@ -3484,8 +3484,10 @@ void blk_mq_free_rqs(struct blk_mq_tag_set *set, struct blk_mq_tags *tags,
>  
>  	if (blk_mq_is_shared_tags(set->flags))
>  		drv_tags = set->shared_tags;
> -	else
> +	else if (hctx_idx < set->nr_hw_queues)
>  		drv_tags = set->tags[hctx_idx];
> +	else
> +		drv_tags = NULL;
>  
>  	if (tags->static_rqs && set->ops->exit_request) {
>  		int i;
> 
> base-commit: 0fcb05b72344f40806cbe810de8872f1698bf053
Hi Jens,

A gentle ping on this fix. The patch has Nilay's Reviewed-by, and
syzbot CI tested v2 without finding any issues.

Please let me know if any changes are needed.

Thanks,
-- 
Krystian Kaniewski
