Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com [209.85.210.42])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B9BA344D9B
	for <syzbot@lists.linux.dev>; Tue,  4 Aug 2026 17:31:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.210.42
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785864687; cv=none; b=r5dpA7Y29qtimitDgKArwNm8DEHKtiiuXz8Qr/E4aIXgAaRFetchjHF+yOA6Oguj7r2d+I1mlfNblRU1Z7KE7Gp0vK8FtuhZpnilMPpC5cGUfoe3dEiSMmP2pV+ViKRenMIsUJZ6tFvnxUD8DezrCCDrsuzTbiOqEM6cBCefieE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785864687; c=relaxed/simple;
	bh=PEIo+F6nSB/oPmXub2a1WcIGBd3T5QhN0xPjELeCzQA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=oqlHoy7WPDC3qPYNHep0xOQiA6JL8GHOXim7MZRlXA9UAbpq5uHVPoTM4bihZyGDzQm3Ym4Wm0Mt22npiUCZ7lfhcUHmdeVXf2ItbCTtEHHMmi7zLy3idpZJ0+mAGI3HbhOMI+ej6XS4Y2tDAAO3pWIdNtWffReNZRzZvytwBwo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org; spf=pass smtp.mailfrom=linuxfoundation.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GhjgvZ90; arc=none smtp.client-ip=209.85.210.42
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GhjgvZ90"
Received: by mail-ot1-f42.google.com with SMTP id 46e09a7af769-7ec3b429a3aso116505a34.1
        for <syzbot@lists.linux.dev>; Tue, 04 Aug 2026 10:31:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1785864684; x=1786469484; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=nShkqNi6OVr5kcjYAHosuW4Py7XxiJXhmTYRr0hY3Fc=;
        b=GhjgvZ90fxqPTBKE+ykW/AnWj4d3iGp6k/HkLsNTvpT56puBYYt76psR8CzZJv71gx
         rCNKk1u19RKYvkPJCkx11v3Jfah8jN785HOKZTNfOSfzQkAIVhwxvHc2AdcX3sw5q9St
         k8f/zULwY7iwjxnJCL2yaD3DxKKRBJUsNNyG8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785864684; x=1786469484;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=nShkqNi6OVr5kcjYAHosuW4Py7XxiJXhmTYRr0hY3Fc=;
        b=ca/YgyGBn+dXusrJsfvWP5K5hsU9HD/QK/n1hvjO4YgTnwIoKcgXHoLBBPi+u7dJTA
         uJn7998rD1BRkV7n0Hiop6cQmkMClPjXNSxPv00lGC8ESdFYv/F4hF0UnaRH7LsGD+Dj
         B5uvdmvUnxdSJ9W+Quqgf4uplRCBkh+UqksQ304x0/D8MeDTZ3Y5VF7R31nwgbkW4DOX
         5iuMWzpY/jxEQSvMd9hd5hijFhEDOZVIt7OkBJ40JNF/xyYJFGs8RI6vxXbsKmZhvnyg
         PZQV949S9vcRZSh+RDtJ+422r4DJaCrVg6RdPlyoxGBsRl0JiHRaYB2j7aLOll4Um/1Y
         i8jg==
X-Forwarded-Encrypted: i=1; AHgh+RofN+zqTRgLqsQ5oCM5eUqM58zZgbL7k5l5OyZp1qWavXWG2gJbJ0xoqX3RFsycGyiCZKwBvwE=@lists.linux.dev
X-Gm-Message-State: AOJu0Yz6MDIXKcrb4LsWehtkRQjy7UHL4i8ZhP6wPQzYwnfWKh3vK7uV
	roDNcwa52oFnEfVS2J8uCVuIWriaOofTEsL0ks65zUoAPaQNULp5I2fWNYEBFP59IdU=
X-Gm-Gg: AR+sD10vLpm2DEa+5R6k8KPLdBScM/luVwBqacn5yDQFB8pvA8F1kRC1s2QarU7ms5u
	pKZ5bCYB7lbRuFBuuBmfCXohvqSW995GQUBn/IEV+cDjqSPVdtMKR7Hk0Ca7mIVZAfwhSdXM7Al
	aY5N/2zWuVFGtZeXgEEXPGvvRVphz38IxKvOCwwKWyGJTlzRFlG/xDMBkrXyQi63uq5bL9W0JGO
	bYERV6uYIRi2JYbdfIBA0D+2xiIQldJkiq+LtPhy4liBYWz9YRtONYOZ9J1/4jSXuJWIIzFoBty
	mi+xLvufvJLXMC8LtWcp2Mh/d0LxKbAYSBgF5WcD0Soaf0HseixnfErdROl7tnPQkY2OQhrxY4Q
	YFqF4Ficfe/5Q0nI2n6QruJD79IRGmnyaG/NKitp2h6Tg/GWKsFQ+7v2tVQUhbqz4aQGsxxU0St
	zwQ1xZj4JlDBifbR1zYpHClE7W5Un0CL9U6FKWtF18VGjR/MsYH9l4L003EjBh4mc8OTKvHw==
X-Received: by 2002:a05:6830:83b7:b0:7e6:ef2e:28a5 with SMTP id 46e09a7af769-7f1e5f5ed24mr508079a34.15.1785864684292;
        Tue, 04 Aug 2026 10:31:24 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f1df5e21d0sm1396175a34.27.2026.08.04.10.31.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Aug 2026 10:31:23 -0700 (PDT)
Message-ID: <b47d2b37-0aba-46cc-afaf-cf824d99524e@linuxfoundation.org>
Date: Tue, 4 Aug 2026 11:31:21 -0600
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] usbip: fix use-after-free in event_handler()
To: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
 Aleksandr Nogikh <nogikh@google.com>,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Shuah Khan <shuah@kernel.org>, Valentina Manea
 <valentina.manea.m@gmail.com>, Nobuo Iwata <nobuo.iwata@fujixerox.co.jp>
Cc: i@zenithal.me, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
 Shuah Khan <skhan@linuxfoundation.org>
References: <ee9bc932-2fbf-4e8f-90e2-6cf604be9ff1@mail.kernel.org>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <ee9bc932-2fbf-4e8f-90e2-6cf604be9ff1@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 8/3/26 09:05, syzbot wrote:
> From: Aleksandr Nogikh <nogikh@google.com>
> 
> The event_handler function in drivers/usb/usbip/usbip_event.c is a
> workqueue item responsible for processing events for a struct usbip_device.
> During device teardown, usbip_stop_eh() is called to wait for the event
> handler to finish processing. However, usbip_stop_eh() uses
> wait_event_interruptible() and ignores its return value. If the process
> unbinding the driver receives a signal, wait_event_interruptible() returns
> immediately, causing the teardown process to falsely assume the event
> handler has finished. 

Does this mean unbinding didn't happen?

The teardown process then proceeds to free the
> usbip_device memory. Meanwhile, the event_handler workqueue is still
> running and attempts to access the freed usbip_device, resulting in a KASAN
> slab-use-after-free crash.
> 
> BUG: KASAN: slab-use-after-free in __mutex_lock_common
> kernel/locking/rtmutex_api.c:559 [inline]
> BUG: KASAN: slab-use-after-free in mutex_lock_nested+0x5a/0x1d0
> kernel/locking/rtmutex_api.c:578
> Read of size 1 at addr ffff8881145245b0 by task kworker/u8:5/6177
> 
> Call Trace:
>   <TASK>
>   lock_acquire+0x84/0x350 kernel/locking/lockdep.c:5842
>   __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
>   mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
>   event_handler+0x1e3/0x4a0 drivers/usb/usbip/usbip_event.c:73
>   process_one_work kernel/workqueue.c:3322 [inline]
>   process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>   worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>   kthread+0x388/0x470 kernel/kthread.c:436
>   ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>   </TASK>
> 
> To fix this, change wait_event_interruptible() to wait_event() in
> usbip_stop_eh(). This ensures that the teardown process strictly waits for
> the event handler to finish its execution and drop all references to the
> usbip_device before the memory is freed, preventing the use-after-free.
> This change is safe from deadlocks because usbip_stop_eh() is never called
> with locks held that the event_handler would need to acquire.

Correct - usbip_stop_eh() is called without lock hold after updating
the shutdown_busid status to true. However I am curious what happens
to the unbinding? Should usbip_stop_eh() check the return value of
wait_event_interruptible() and handle the error instead?

thanks,
-- Shuah
