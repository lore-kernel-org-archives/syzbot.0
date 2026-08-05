Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4957E3F1AD7
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 09:05:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785920757; cv=none; b=pg+y472FHkVh8wUtMcgD4S3+n9QH8JnoMSvO4d1cVGmSuTlpYI0a983hpkOKlWcU0dCW8EYyqy8/OETGAj/CDTQLo+uOWZK+nr4eQ7XlubpWpxQyG9OsfIeksyHu8ie04GJe2OcYMQx5WAclMf36md85cDIHYvUI40bEZvkSfg4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785920757; c=relaxed/simple;
	bh=SXldiWeSBHh/RUC+pz/Z3pn8xriVxkGMlcAH6wkwwtQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kyW29TK+yoBQCuDsOYCL5nsMaPyEktMQD2UgYbnLpp1NJACqM2rv3gw0vzdFechMHD7H5XhoI5V8fvfikUc1TIJlAWNjIrDJXc3TwnZpeDfUc+aZ+O5nQ2Y2DEFzSdTU0mEhrNlao2N8qmN0FhwU5kXtpjZNCj7WeGpnCvg/M78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=FVDb8ACi; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="FVDb8ACi"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1785920750;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=AJv5koF079AhpRKjQRIs6WVbtzHWEnWNzOeKXg3GqUM=;
	b=FVDb8ACi6tKK/a3SG0YAtKt8OlC0PFwrBIMz4t4OGbAr8MgS+gt3Fl5TLFkSG1ymVGMbx3
	xYTAz5+qFzEU8iLjO4V27bsGVkeL38mM3hWAjG5/7J8bnmhRSY5qI1TEtqaxB/fYRoaIuf
	BSf4VHlyNG8XLwuK+OulUNchArekeUs=
Received: from mail-wr1-f72.google.com (mail-wr1-f72.google.com
 [209.85.221.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-22-sKjPUr6kNG-LK-IzyhJ8Tg-1; Wed, 05 Aug 2026 05:05:49 -0400
X-MC-Unique: sKjPUr6kNG-LK-IzyhJ8Tg-1
X-Mimecast-MFC-AGG-ID: sKjPUr6kNG-LK-IzyhJ8Tg_1785920748
Received: by mail-wr1-f72.google.com with SMTP id ffacd0b85a97d-47f83416551so601840f8f.3
        for <syzbot@lists.linux.dev>; Wed, 05 Aug 2026 02:05:48 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785920748; x=1786525548;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AJv5koF079AhpRKjQRIs6WVbtzHWEnWNzOeKXg3GqUM=;
        b=TTput/9Tfi7VVuxL1XHd4kySM+SV8zERJHBZN/3/hwHMrkmMKnrJ5MYGkxtMOsdxYi
         eeu6wfHdnN/lsmFxIC8hx7WorQMBR5ABc91Cl3WgzzKpZN7zSJWQjjjP45a0B+8cyusv
         BZCeNT/6GPAr+/GwCUUESiGXT2nJZY7GOOspjIyTeqqcebe558gq1Hms+hxfrfwts0l8
         8OymMGp82GB2V6JhPiKvsA8zDooehPxEWr9Cx18ho87OZ+hvF9T0o3ZC3FY4HkMLAvtd
         CCEMHkPBYl9aPT1N0Er34hcp3bsKu9pdyreR37GSGxitULVwlxtchKGDyyf9L1lvpZt/
         H5LQ==
X-Forwarded-Encrypted: i=1; AHgh+RokgYFWCLFyt35mBsx8wI16dVdBc1KyWj24KQPiFleFFMml42ksXRRpGL20hvHCSESN+IuHPlw=@lists.linux.dev
X-Gm-Message-State: AOJu0YzfXcHHLFDOUl3FJDBiyZcGOsYEJbMHLC4xLMHgkeQ5fUSbYKBw
	k5MoZ08/309RjKA/+9cg6nZCpTZ1BQdFlxtIgBce+l9eDymSN1YsXsQ1TXE0A1VQCeBR93OhtyQ
	KiniVO5KUdrxuqsPgM9lUXpZ+mb3z58xGmm4qqT2fSwTIwG/8geHrmr9xQQ==
X-Gm-Gg: AR+sD13jLQ70NZfSs0VhWI6iu/f43hqS23Bp9QHnG4sN+OryIXlDdBIZbnk/4p3q2Cz
	anu6DzH5cznvQDls/wlXAgyNuZS9AHPSRiZK9HJdumc/B9SQOorPdN+IlZioMei8XkuNCYySSsj
	3h2QYyUPNCuKz/e2kuz/Sujuc5IbeC093Gpj/i45Z/oXB4Z4zLdJc2CBLthh0Mj4d8fyBvnEy74
	+LR5dnMr/8o4Jr0OZgEr+MHM+lQjg2/IBng2+Kasxcy1YsJR3/951eM3N3se55YRsB35wHdae9V
	HPcECppwodOQ+643CZXGYGTo1RNEAt8SPsSqVweN11ddiRc5WNGx4Kj3KPYRV9jwQs7vr3UepiK
	Y3UqU1o8uMSVQecspgFudDntTo2x00xgRAJWKeoA27Bwst8jBVo2OP3exh0HTLXB4vOF7EXjTAV
	A=
X-Received: by 2002:a05:600c:c490:b0:493:c337:db0e with SMTP id 5b1f17b1804b1-4994e7ece20mr57702825e9.18.1785920747605;
        Wed, 05 Aug 2026 02:05:47 -0700 (PDT)
X-Received: by 2002:a05:600c:c490:b0:493:c337:db0e with SMTP id 5b1f17b1804b1-4994e7ece20mr57701825e9.18.1785920747044;
        Wed, 05 Aug 2026 02:05:47 -0700 (PDT)
Received: from [192.168.188.103] (ip239-44-231-195.pool-bba.aruba.it. [195.231.44.239])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4994e04db3asm84916885e9.15.2026.08.05.02.05.45
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 05 Aug 2026 02:05:46 -0700 (PDT)
Message-ID: <14b8701a-44a6-40dc-b46a-46096ea5bca2@redhat.com>
Date: Wed, 5 Aug 2026 11:05:45 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] netdevsim: fix deadlock in nsim_bus_dev_max_vfs_write()
To: Slawomir Stepien <sst@poczta.fm>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
 Andrew Lunn <andrew+netdev@lunn.ch>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
References: <b7bf56ea-7522-4163-acd5-aaa69ad03b3a@mail.kernel.org>
 <c74a0579-dc37-4f3b-8dba-8380223b361c@redhat.com> <anL6nNIJDqWOynzw@nr200>
From: Paolo Abeni <pabeni@redhat.com>
In-Reply-To: <anL6nNIJDqWOynzw@nr200>
X-Mimecast-Spam-Score: 0
X-Mimecast-MFC-PROC-ID: 7qalEHafbdKE0bNJ0pchzGAGl9UPFmNGN3QQNccQVW0_1785920748
X-Mimecast-Originator: redhat.com
Content-Language: en-US
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/5/26 10:55 AM, Slawomir Stepien wrote:
> On sie 04, 2026 16:33, Paolo Abeni wrote:
>> On 7/31/26 11:55 AM, syzbot wrote:
>>> From: Slawomir Stepien <sst@poczta.fm>
>>>
>>> There is an ABBA deadlock between the devlink instance lock and the debugfs
>>> active file reference mechanism.
>>>
>>> When a device is being removed (e.g., via nsim_drv_remove()), the driver
>>> acquires the devlink instance lock and then calls
>>> debugfs_remove_recursive(). This function blocks waiting for all active
>>> file operations on the debugfs files to complete.
>>>
>>> Concurrently, if a user writes to the "max_vfs" debugfs file, the VFS layer
>>> acquires an active reference to the file. The write handler,
>>> nsim_bus_dev_max_vfs_write(), then attempts to acquire the devlink instance
>>> lock, which is already held by the removal task.
>>>
>>> This creates a circular dependency resulting in a deadlock:
>>>
>>> INFO: task blocked for more than 143 seconds.
>>> Call Trace:
>>>  wait_for_completion+0x2ca/0x5e0 kernel/sched/completion.c:153
>>>  __debugfs_file_removed fs/debugfs/inode.c:751 [inline]
>>>  remove_one+0x2df/0x3b0 fs/debugfs/inode.c:758
>>>  __simple_recursive_removal+0x215/0x520 fs/libfs.c:623
>>>  debugfs_remove+0x5b/0x70 fs/debugfs/inode.c:781
>>>  nsim_dev_debugfs_exit drivers/net/netdevsim/dev.c:372 [inline]
>>>  nsim_drv_remove+0xc0/0x170 drivers/net/netdevsim/dev.c:1803
>>>
>>> INFO: task blocked for more than 143 seconds.
>>> Call Trace:
>>>  __mutex_lock+0x7bf/0x1550 kernel/locking/mutex.c:821
>>>  nsim_bus_dev_max_vfs_write+0x229/0x3d0 drivers/net/netdevsim/dev.c:276
>>>  full_proxy_write+0x127/0x1f0 fs/debugfs/file.c:388
>>>  vfs_write+0x296/0xba0 fs/read_write.c:685
>>>
>>> To fix this, use devl_trylock() in nsim_bus_dev_max_vfs_write() instead of
>>> devl_lock(). If the lock cannot be acquired, return -EBUSY. This aborts the
>>> write operation, releases the debugfs active file reference, and allows the
>>> pending debugfs_remove_recursive() to proceed.
>>>
>>> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
>>> Reported-by: syzbot+3147c5de186107ffc7a1@syzkaller.appspotmail.com
>>> Closes: https://syzkaller.appspot.com/bug?extid=3147c5de186107ffc7a1
>>> Link: https://syzkaller.appspot.com/ai_job?id=fcdda182-bebf-49ab-ada0-d4d2e814ebf7
>>> Signed-off-by: Slawomir Stepien <sst@poczta.fm>
>>>
>>> ---
>>> diff --git a/drivers/net/netdevsim/dev.c b/drivers/net/netdevsim/dev.c
>>> index aed9ad5f1..421cd7327 100644
>>> --- a/drivers/net/netdevsim/dev.c
>>> +++ b/drivers/net/netdevsim/dev.c
>>> @@ -273,7 +273,11 @@ static ssize_t nsim_bus_dev_max_vfs_write(struct file *file,
>>>  		return -ENOMEM;
>>>  
>>>  	nsim_dev = file->private_data;
>>> -	devl_lock(priv_to_devlink(nsim_dev));
>>> +	if (!devl_trylock(priv_to_devlink(nsim_dev))) {
>>> +		ret = -EBUSY;
>>
>> I think this should return restart_syscall(). This kind of schema is
>> calling for trouble, but for netdevsim should be okish.
> 
> Thanks Paolo for your comment!
> 
> Can you explain a bit more? What is your reasoning here? Is it, that we expect that we could have
> the lock in e.g. 1ns, so it is worth restarting without bothering userspace[1]?
> 
> I see a lot of:
> 
> if (!rtnl_trylock())
> 	return restart_syscall();
> 
> Why this pattern is so popular? Is it for the same reason as above?
> 
> [1] https://kernel-internals.org/syscalls/restart-block/
If you don't restart, the write will randomly fail when the lock is
contended, as reported by sashiko gemini:

https://sashiko.dev/#/patchset/b7bf56ea-7522-4163-acd5-aaa69ad03b3a%40mail.kernel.org

the user-experience will be terrible at best.

Also, I missed this other report initially:

https://netdev-ai.bots.linux.dev/sashiko/#/patchset/b7bf56ea-7522-4163-acd5-aaa69ad03b3a%40mail.kernel.org

it looks like the above is not a complete fix.

/P

