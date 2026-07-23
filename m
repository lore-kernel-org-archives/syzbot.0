Received: from mail-wr1-f51.google.com (mail-wr1-f51.google.com [209.85.221.51])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD80F417BCF
	for <syzbot@lists.linux.dev>; Thu, 23 Jul 2026 09:50:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.51
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784800235; cv=none; b=FYw90TYBBQmocrgHAVpY2mt4ooWyGyK5f9+PtU3/7GUI19A8lJTGBCVtj1SyY3upa5sQ9eEEyR9bpE1S9OoYgpNaTdj1EJIAcptdzigyn4k/ykyjn6GotKeTG/bZYOmmjAH4aBB0eqtz++kg8HRgxQfVatXP4kkHS+p1qhQ+dc4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784800235; c=relaxed/simple;
	bh=aQhC9rFjwm4+93boehWapi1YBv6VsCirObljWw8s1AA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=BdLBY8dC/Ew1L2bj6s6mBJs4DY9oLNGe1+gn0chJhlvfYNvA1ici84RZd+tJU/HYTA3H1Z9P2jK8mUZU+kp0VJUKjLDXtSow0f+1X+mYWcWZdXmFWq4bW8jSyq+wx1Esmbfakx7UJp9FNwWDaKy4PJNJ4m+rW37BIipp+k991MA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=YEaBX/WV; arc=none smtp.client-ip=209.85.221.51
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="YEaBX/WV"
Received: by mail-wr1-f51.google.com with SMTP id ffacd0b85a97d-47640541585so250320f8f.1
        for <syzbot@lists.linux.dev>; Thu, 23 Jul 2026 02:50:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1784800232; x=1785405032; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QAVgiTw8E6v3FtHcSpUffy5pGKvZPaJpaxuT+xgsABw=;
        b=YEaBX/WVThbITcmc1a4u6s+VDKVER7uf+wsszmpH977/kcmM/2D/tH4fzeh9gsxFLX
         h/4kLtQ5co/O7jQaIal10wK3ztZYl+Qpkq//XIBoGIk6pKGv5KafLCNK/3y4XR163DmU
         I8G5AiO0cUA7JLR0PVB19dCFpC8QaEV1hrmbjqeST5NQHIiEOaXAgHMhQNxe/a4iiA1E
         9OWKo2E5rT4PxYS7k/b9BlMzQBkWUrrM7hC1fj0zDUlKG8lO3Sr1fQkACGuw9/AsfxX5
         fDh/mrxtFBd7lNvDiQog2FnUQ/MUarkOH55Tj7wYzmyHShgAZO6dkVDuO5S1NMWA5rgl
         hdSw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1784800232; x=1785405032;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QAVgiTw8E6v3FtHcSpUffy5pGKvZPaJpaxuT+xgsABw=;
        b=rR4UvZcZY2sWElaeOajn8C/G3Grb05uOySWyom1dCD3ucAScOfrR3R0QoQikhdykDk
         5ZLtI5DCtHEthwSAIrWv8Q1bQOLSV/YgW4hE6mYFnoO+9gImTFrO6ipppDr/EZsLv35A
         e+W52mspzNhMvKOo1dncOdRu9N4zG/xEK8sdE0i2mJToS9mdVaYc3N1aAkhgYiaG4wNr
         +6z8grdL6nTsrFyPiL6frqIi/7+XO1LZPqyypWQh/+Q9nSdDJ9FAz6XrcM8+/n6flqKD
         sgXFNksEwB6cf2lOkvjA3hfL+HSdt5Z5uNpHbvDwf6cbRqeyQrVtUrs9Qc3L4TOXpnaH
         diYQ==
X-Gm-Message-State: AOJu0Yw1zZLn+Hao+ycDukK/g24mj42hBtvZ7AwLMflD+mebq/GdF2Du
	BdeAw4anQDPtdN1kM3hJSncKtnN3fq61jpV4ChgLWP7KwWQ6QD6F65Na
X-Gm-Gg: AR+sD10N1vtfJIuTrYQo9dZ60LCO1JZpNO4AUFfvkwKKT2YOmaINPK/GQH5RLAcQn2k
	qIZSuKijhGbJxa0znwoPfr3LMS4neLz2FOLcdvKT6tK0Ko3CKynJheOwiQWSYHucIWBJOeseEar
	JburpkvPf96o4dk5wIoPdPb4HoG1JnoeIhbZQcim82u/DPBBFkr4EulRoTKCTssM1Q9T/QpArd0
	Dx47fLSJoyVTY8fvKE+zrF+kpGMJQqhRUCj/NN6foGE7WwjVCoS/ZXIzfBGmLWJQS/87x/FYM0U
	f/c0K2lFwtCyB5XcA767Ivwj9GnivnL4MB9kBHl2Xp6CkZvLIeFCzqKzffiL8uZjCeCGQ518s+R
	5QJ7NvOWUeK2acg11RBqUjRSZoBzrAqe7GZN6E9lTrBEiASy8nN8uiWn//M+DBtgaGQ1LwLrlO0
	DhL3p46nSsWcbbkvAtiYZ7devOPOPikw/VBzLXqLGrKxSfzMVLAmX0C7HbeU1XX/pIfUfDeMQ4c
	Jfc1iXT/bFASWbtCF+GkIhIcfn1LAzXsoQ9sGIpZb0ki78YYMsNQ2MY2+w0A5KB7crXEK3YL/wf
	50tJm80=
X-Received: by 2002:a05:6000:2904:b0:46e:624e:3c2f with SMTP id ffacd0b85a97d-47f8dc8565cmr2741245f8f.47.1784800231815;
        Thu, 23 Jul 2026 02:50:31 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-47f85b9a5a2sm15081924f8f.7.2026.07.23.02.50.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 23 Jul 2026 02:50:31 -0700 (PDT)
Message-ID: <f35db60a-9a4b-434d-89eb-9a19d84919d7@gmail.com>
Date: Thu, 23 Jul 2026 11:50:30 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v3] nbd: skip queue limits update for size-only
 reconfigure
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <130f544a-70fd-4ca0-91e8-08824170c91b@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <130f544a-70fd-4ca0-91e8-08824170c91b@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Keep the code diff unchanged and correct the commit message in the 
replacement patch.

Make these required changes:

1. Replace:

Fixes: 2dc691cc4ac2 ("nbd: refactor size updates")

with:

Fixes: 242a49e5c878 ("nbd: freeze the queue for queue limits updates")

Commit 2dc691cc4ac2 merged the NBD size helpers, but it did not freeze 
the request queue. Commit 242a49e5c878 added queue freezing around live 
nbd_set_size() calls and is the first commit which made the reported 
capacity-only hang possible. Commit f3dec61d7544 later changed the 
implementation to queue_limits_commit_update_frozen(), but retained the 
wait.

2. Remove the two shortened stack traces from the commit message. They 
use the task names nbd-client:6285 and generic-netlink:6030, while the 
report identifies syz.0.17:6086 and syz.3.27:6088. Several function 
offsets are also different. Do not present reconstructed text as report 
output. The prose explanation already describes the relevant call path.

3. Replace "system-wide deadlock" with "global generic netlink stall". 
The blocked genl_mutex prevents unrelated generic netlink operations 
from progressing, but the report does not show that the whole system is 
deadlocked.

Preserve the subject and the current implementation. In particular, keep 
the no-freeze path limited to generic netlink capacity-only updates with 
an unchanged effective block size. Keep zero block-size normalization 
and validation, initial startup, real block-size changes, and all legacy 
size ioctls on their current paths. Do not reintroduce the 
nbd_total_devices counter change or any generic netlink parallelism.

Produce a complete replacement patch with the corrected commit message 
and the unchanged code diff.

On 7/22/2026 8:40 PM, syzbot wrote:
> Commit 242a49e5c878 ("nbd: freeze the queue for queue limits updates")
> correctly added queue freezing for live updates of real queue limits.
> However, nbd_set_size() is also used for capacity-only generic netlink
> updates, so the freeze is unnecessarily broad for the reported request.
>
> When an NBD server becomes unresponsive, it leaves I/O in flight. An
> unnecessary queue freeze during a size-only reconfigure will wait forever
> for these in-flight I/Os to complete while the global genl_mutex is held,
> leading to a system-wide deadlock.
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
> INFO: task nbd-client:6285 blocked for more than 143 seconds.
> Call Trace:
>   <TASK>
>   blk_mq_freeze_queue_wait+0x101/0x180 block/blk-mq.c:191
>   queue_limits_commit_update_frozen+0x55/0xd0 block/blk-settings.c:590
>   nbd_set_size+0x454/0x680 drivers/block/nbd.c:374
>   nbd_genl_reconfigure+0x7e9/0x1e80 drivers/block/nbd.c:2373
>   genl_rcv_msg+0x614/0x7a0 net/netlink/genetlink.c:1209
>   </TASK>
>
> INFO: task generic-netlink:6030 blocked for more than 143 seconds.
> Call Trace:
>   <TASK>
>   __mutex_lock+0x7c5/0x1590 kernel/locking/mutex.c:820
>   genl_rcv_msg+0x10b/0x7a0 net/netlink/genetlink.c:1208
>   </TASK>
>
> Fixes: 2dc691cc4ac2 ("nbd: refactor size updates")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot <syzbot+f272bbfbf8498ddadea5@syzkaller.appspotmail.com>
> Closes: https://syzkaller.appspot.com/bug?extid=f272bbfbf8498ddadea5
> Link: https://syzkaller.appspot.com/ai_job?id=c8611da4-ddd9-47e3-bbe2-8e178beb3f96
> To: "Jens Axboe" <axboe@kernel.dk>
> To: "Josef Bacik" <josef@toxicpanda.com>
> To: <linux-block@vger.kernel.org>
> To: <nbd@other.debian.org>
> To: "Christoph Hellwig" <hch@lst.de>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v3:
> - Removed the unrelated decrement of nbd_total_devices in nbd_dev_remove().
> - Corrected the referenced commit title of 242a49e5c878 in the description.
> - Clarified that capacity-only generic netlink reconfiguration no longer freezes the queue, while startup and real block-size changes continue to do so.
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
