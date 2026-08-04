Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 428473C9454
	for <syzbot@lists.linux.dev>; Tue,  4 Aug 2026 14:33:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785854028; cv=pass; b=kvjwiH6V9RM/e0i3BfcGAOGtJi0CHThHxtegdOCTawY/g3QChtnmwFyWK9kp3i+nk2WVTaHuZVOMkiViYUvxPmby/LsVKcRq8fwcXWgUkUhZ5pG/iZJDxfoKUZFP0QlqfgtnHwesCUJSZLxJI7aII7z9+a5psxVvuODi49inLjs=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785854028; c=relaxed/simple;
	bh=q6nFZ1R6gzXut+K/+tnOlHI88I/nj/Df9nXi6+JJ8e4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=AvLv/B+m3eEuIa/ESLavqzymGfh89DZQGzDSnKJFE6W1ueg5/MIffSQn41nnDYJ5YYQt7UgNA1FoACeRMmuuIbLNFokmA9P4vZ7Zv75jE//yJJzkBkE0vGx8RbeJ8bbD22aGZHB1UkSOSUe18zLskX9YL0100akple3jE7T43Mg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=LTqiiiUT; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LTqiiiUT"
Received: by smtp.kernel.org (Postfix)
	id 6310D1F00A3D; Tue,  4 Aug 2026 14:33:43 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=170.10.129.124
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1785854023;
	b=GfbSvFn8caneVUJN10zg9Qe/1BKTSw3kw70ingFSPFgu1GwS0DOTjjTi8ofFOxIGtqHt
	 AmicGcpMqzzdHcLMQ6pMGP9dKtjdJ/Lwgf8MwWQdOwlmwulssXVPyqr/votyUK5k1oBmp
	 FVIt2y1SrhQRcTWbckXic3pdUxvwvKpChymfZbEKGrV34qWCvL7JsWXc+TAo5L5U0Emyw
	 EzIZuk01R4tQZMxTitO/ynHU/g/wwEeGH43KNCgTE3L9BdEvH4/WuACViWNj+tWuWPQy7
	 riJ9EY++9lSntGvxWPIHgUriOvYRGKkJjShiP5TJRACRH/xJlQB42cyHnwzKTW3iC2Q==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1785854023;
	h=DMARC-Filter:DKIM-Signature:Received:X-MC-Unique:
	 X-Mimecast-MFC-AGG-ID:Received:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:X-Received:Received:Message-ID:
	 Date:MIME-Version:User-Agent:Subject:To:Cc:References:From:
	 In-Reply-To:X-Mimecast-Spam-Score:X-Mimecast-MFC-PROC-ID:
	 X-Mimecast-Originator:Content-Language:Content-Type:
	 Content-Transfer-Encoding;
	bh=sMR8kYlXa1CTxfv23QQO2kULReZbJe35SSbkC/BppCQ=;
	b=I2nMun5/J//FS1vd9KpzDCayhOelOeMTAOkV2HriyclDSNAwOUhByZDYwbViav0LGmFt
	 nIEI8/vCgHDthz9Lff2OAEmovoMb7D645vXQ2bZjM4BMkqz+VBB9DSSerSgi0fTjGo5rS
	 tFRNvjpv7rd8t7FiE/kjl7IPjvOh+ZwuJB8Rbc+zx83SzEAgJsu6AnsLND+UlwuU7QJm6
	 3fwwHzmGeMcBujf0giaFUDf1YXjQN7BUwFJRH7ZVq2RCi/Gr2l/L2cRarrYIFwcraICyv
	 drJUhMLKWDcfIsDbDtLauSOkgIXpH86PqZzHVEw8RD13KdT9iJ5pNSFpRLSfb5tksfA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LTqiiiUT;
	dmarc=pass header.from=redhat.com;
	spf=pass smtp.mailfrom=redhat.com;
	arc=none smtp.remote-ip=170.10.129.124
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id AE6AE1F00A3A
	for <syzbot@kernel.org>; Tue,  4 Aug 2026 14:33:42 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=redhat.com header.i=@redhat.com header.a=rsa-sha256 header.s=mimecast20190719 header.b=LTqiiiUT
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org AE6AE1F00A3A
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=redhat.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785854021;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=sMR8kYlXa1CTxfv23QQO2kULReZbJe35SSbkC/BppCQ=;
	b=LTqiiiUTXrOT+xnnCJ15NbQtIrJYj8H9IlQ25iOKAlqCZuSqMjzj7W3mF5IDbSbrvnHdUD
	rA6dFU3lMh65oSDYA+m90AvkcpvbMhw2g0J4KQYwQ2hF3/gZxCu0vkQm47qGhbAUa/FHYv
	etOdLgmgveSuzw8fAr45zrW/KTEONw4=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-107-Otj4iRqROF2ixR9OLNVIJA-1; Tue, 04 Aug 2026 10:33:38 -0400
X-MC-Unique: Otj4iRqROF2ixR9OLNVIJA-1
X-Mimecast-MFC-AGG-ID: Otj4iRqROF2ixR9OLNVIJA_1785854017
Received: by mail-wm1-f70.google.com with SMTP id 5b1f17b1804b1-49560dddaa4so15989105e9.3
        for <syzbot@kernel.org>; Tue, 04 Aug 2026 07:33:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785854017; x=1786458817;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :from:references:cc:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sMR8kYlXa1CTxfv23QQO2kULReZbJe35SSbkC/BppCQ=;
        b=ZdJQuPrUtGjgWnPZx3+QI6tCNQluz1wu9YWJuph7dTDHz3xY3GWy8Q2jHWnEuPTFWX
         a2GWR6/465EhUEjI/6i5pHSWFbgew1OH2xzmLaZFKGBmK8H1/m2Xo1V6H8leCAmCHSqs
         IE2tYioOlT8MwEDpR29TnVjkjwrggKnQ1kgtVLXw9P3s/H1eg1aGriBHq7o7Kf4SXZbF
         pCzCH2cHr0d8l40fjhQNroOD5IMoe9DbLk6Bp2eMOXMBQOxcF4Ia8Do2U6PYs6NKwnYQ
         d09Song8C9FlJgFmJX5fo+lOok22nrmSt+pllrWfulsgm1EAJAtISk5hP7AuagOmZjJh
         SvIA==
X-Gm-Message-State: AOJu0YzM5paL7aTfXCxcGvmfxT2Y15sGknhA2m9tjcd4lrHHIBg09sOS
	CYHh8UojzefRh0IajgNDtwKkHpHZWjP9jiJra2aoNBr1s9YRKnDMOdZdbp3aVE9uOBmp5JsLW/X
	p3kUrWES10OFLVAr9txUbK7p3zfuDsI3xSeRC0G5B3gvimDg7f/NV+8cZpC0KNy7t4SA9uVmfwc
	hnq954OYupLdT+NSEsEulfhMwb1yW4+gjH
X-Gm-Gg: AR+sD139kyiheVG9KqFPF5pdWULkONXKQAnWVvqA58gJ67shwNMtLrXb+QfmGKXIlaM
	HwfA1XmtgZfQGdX+n6+dtF0hCkfgTqOGn2Wk9Dvy+pI8f2Zf8evqIUra/IOVc3Qt9Nij1YWm3cF
	EBsF8XC7Rn1QVukbTu/eZ4WyyN3OySqhTXjhSbZNxGO6cs+T5ZiJiDet1ISOIDP20+PeSpkRTIi
	hgl9Byr/fN8DAkqGZAY7E/uu8RHcuOluFr9s4jtjw7t9P7hTw2Bsl6wbBKs9WbKKBMFuqLV5b6H
	wFagpV/YsaJnd3sp7ydcHdSl+ds6U7d6vfrBdiRD7ZEks8fXw2RJtw1CnEe726e3KNmDlv/92Ny
	apz+nApd0xt1LuW2ve8rGu9Tw8e1B9iE/FxvFCn6UjPUqfp7iny9puzxVW5BHI/v2g9Q9/T+0Ky
	k=
X-Received: by 2002:a05:600c:5395:b0:493:faf3:3ea5 with SMTP id 5b1f17b1804b1-4980c66c751mr434203235e9.4.1785854016854;
        Tue, 04 Aug 2026 07:33:36 -0700 (PDT)
X-Received: by 2002:a05:600c:5395:b0:493:faf3:3ea5 with SMTP id 5b1f17b1804b1-4980c66c751mr434201535e9.4.1785854016281;
        Tue, 04 Aug 2026 07:33:36 -0700 (PDT)
Received: from [192.168.188.103] (ip239-44-231-195.pool-bba.aruba.it. [195.231.44.239])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4994a100e14sm91151965e9.14.2026.08.04.07.33.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 07:33:35 -0700 (PDT)
Message-ID: <c74a0579-dc37-4f3b-8dba-8380223b361c@redhat.com>
Date: Tue, 4 Aug 2026 16:33:34 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netdevsim: fix deadlock in nsim_bus_dev_max_vfs_write()
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
 Slawomir Stepien <sst@poczta.fm>, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
References: <b7bf56ea-7522-4163-acd5-aaa69ad03b3a@mail.kernel.org>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <b7bf56ea-7522-4163-acd5-aaa69ad03b3a@mail.kernel.org>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: rkNzgBk1a-RI44u8zIHCAM1gTbnbQPK45fkC4a4PyXE_1785854017
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 7/31/26 11:55 AM, syzbot wrote:
> From: Slawomir Stepien <sst@poczta.fm>
> 
> There is an ABBA deadlock between the devlink instance lock and the debugfs
> active file reference mechanism.
> 
> When a device is being removed (e.g., via nsim_drv_remove()), the driver
> acquires the devlink instance lock and then calls
> debugfs_remove_recursive(). This function blocks waiting for all active
> file operations on the debugfs files to complete.
> 
> Concurrently, if a user writes to the "max_vfs" debugfs file, the VFS layer
> acquires an active reference to the file. The write handler,
> nsim_bus_dev_max_vfs_write(), then attempts to acquire the devlink instance
> lock, which is already held by the removal task.
> 
> This creates a circular dependency resulting in a deadlock:
> 
> INFO: task blocked for more than 143 seconds.
> Call Trace:
>  wait_for_completion+0x2ca/0x5e0 kernel/sched/completion.c:153
>  __debugfs_file_removed fs/debugfs/inode.c:751 [inline]
>  remove_one+0x2df/0x3b0 fs/debugfs/inode.c:758
>  __simple_recursive_removal+0x215/0x520 fs/libfs.c:623
>  debugfs_remove+0x5b/0x70 fs/debugfs/inode.c:781
>  nsim_dev_debugfs_exit drivers/net/netdevsim/dev.c:372 [inline]
>  nsim_drv_remove+0xc0/0x170 drivers/net/netdevsim/dev.c:1803
> 
> INFO: task blocked for more than 143 seconds.
> Call Trace:
>  __mutex_lock+0x7bf/0x1550 kernel/locking/mutex.c:821
>  nsim_bus_dev_max_vfs_write+0x229/0x3d0 drivers/net/netdevsim/dev.c:276
>  full_proxy_write+0x127/0x1f0 fs/debugfs/file.c:388
>  vfs_write+0x296/0xba0 fs/read_write.c:685
> 
> To fix this, use devl_trylock() in nsim_bus_dev_max_vfs_write() instead of
> devl_lock(). If the lock cannot be acquired, return -EBUSY. This aborts the
> write operation, releases the debugfs active file reference, and allows the
> pending debugfs_remove_recursive() to proceed.
> 
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+3147c5de186107ffc7a1@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=3147c5de186107ffc7a1
> Link: https://syzkaller.appspot.com/ai_job?id=fcdda182-bebf-49ab-ada0-d4d2e814ebf7
> Signed-off-by: Slawomir Stepien <sst@poczta.fm>
> 
> ---
> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
> index aed9ad5f1..421cd7327 100644
> --- a/drivers/net/netdevsim/dev.c
> +++ b/drivers/net/netdevsim/dev.c
> @@ -273,7 +273,11 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
>  		return -ENOMEM;
>  
>  	nsim_dev = file->private_data;
> -	devl_lock(priv_to_devlink(nsim_dev));
> +	if (!devl_trylock(priv_to_devlink(nsim_dev))) {
> +		ret = -EBUSY;

I think this should return restart_syscall(). This kind of schema is
calling for trouble, but for netdevsim should be okish.

/P

