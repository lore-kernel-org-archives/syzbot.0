Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1548335BB4
	for <syzbot@lists.linux.dev>; Mon, 10 Aug 2026 19:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786390407; cv=pass; b=CVegDh/4zPH/l9H/+PYZfYjSxVzW2g4w1G9kx+UNkROEvF2NazCkA0gogf4Mr3XifDbErwbOrKWNsv2viIIIggJp1jVP62exPK2LOHgVQsBGPP8HPhXqn86e2xAyFo5UMPZHtLxlnTQpuP07/5HYuYUBF7w0az4sf7Um5PabIrk=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786390407; c=relaxed/simple;
	bh=SW5/seaUl+tZNUVKwpdaQB5vHV2SqlBFmBBbRGHqLu0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=LCbzwDn8pmbAzHXcckV5O9xYtk3e2XBiWOpllwSUb/GQVnfCERUfZjH8je6ZGP+dYxoGih0tF6MbtKTKwptaioNV1tHr0OZ4NpE3TjL+g5AWmpHtridRS/sTvl7m1hDDk+07b01ZvTdTvanbFaAF8WAV3QuF8PaUaDTJF93YDIE=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TQsZjiI/; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TQsZjiI/"
Received: by smtp.kernel.org (Postfix)
	id D2B201F00A3D; Mon, 10 Aug 2026 19:33:24 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.161.53
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786390404;
	b=zcfphusWbFtSF799kDIet0vBfroWlgbZfi9lVt1+J8Eov0GrYbIsgT//1URk1zrT++gh
	 ssmTKlFqovffFTVOrIBTb+4OyQfME/K6sgpZxb4Ci3t/ZhoNh1LgGoW43ORuCekc66ArX
	 tZvVxdLXzSCW4yvmOub/5nVoIDxLsYBQzTHoThzNoVoGN7+9y6cqb1v1Virbkki9vnPHA
	 981WswprZ0EMRxnDZ4vwTEkio/asmRAwkf1VVqq2Bv0NBbnFuhIsD3ykGUY7XaLhutMz7
	 TUQ70CCtXHxvGth0nIVcQzmPniHscYCZPdWguK/i6B63X0tUteQAMK7BhbuEJVU60YA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786390404;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=QrRlsgcOgMJKftL8Bqe2As9MXqW/RKYfWKo2wJ61FY8=;
	b=OXVOjhIqG55Pu3136cYVXX3Vo08LjF1+0NJwVFdRm3MUOKABf7Ik19lk36FmK08BXDZF
	 hydj7Hlmuo6zU/QW7k3UPhN/Pn4bCt/m3PYiXO4ORJY254OIHlv1RfK9JUmi7P0UwYm5f
	 Yz3rM53aJrUvl71HxElXkkqdmyocf7H1YFmg3/Z1jgxlB+M8md0d/42G8TDDLQhRh8C9m
	 FnecAhgRlnrzP5d6eGRWBd1NwjrlFsEp99nVcUg4Sqt8XvvyyNbSfstokpAt6PeMIYHX0
	 jdDQA5QlNveC4TM3KkO3xAjGzgZr0ST9wKIiWJUBAbHbCFdwDrJV62pX2arAeKKRtdw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b="TQsZjiI/";
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	arc=none smtp.remote-ip=209.85.161.53
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id BA9CB1F00A3A
	for <syzbot@kernel.org>; Mon, 10 Aug 2026 19:33:23 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=TQsZjiI/
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org BA9CB1F00A3A
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-oo1-f53.google.com with SMTP id 006d021491bc7-6ac83a09781so151096eaf.1
        for <syzbot@kernel.org>; Mon, 10 Aug 2026 12:33:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1786390402; x=1786995202; darn=kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=QrRlsgcOgMJKftL8Bqe2As9MXqW/RKYfWKo2wJ61FY8=;
        b=TQsZjiI/HrgSPIGJjhEF9S06ESKvFaFkyiUtlsK3LAbgB9GGopsBnvGP+nktR6FPBN
         Dr6oxIzWcO7Lo2UOJu05PHz/J4N17VCeZ+7rj3430b7KkKiOWg8EQF/mq5dTHeMkZY+Z
         KfkTQ36LwLpL7fL0bhYtaDK8IFv3pYD3db+j8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786390402; x=1786995202;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=QrRlsgcOgMJKftL8Bqe2As9MXqW/RKYfWKo2wJ61FY8=;
        b=o1tcAZg5KknBSND+4Rpf2yEl47tQOZ0NTtUDfyfeyf2Gcv+JnQXiUllDyk9tB/R0+E
         sWjzD+wfKMN1KHwuK8YLluXvfUZrR0OzDSWg0QocOhTHR/KZhGdnGByLVTewMPw3XfBJ
         re7GLTPZHrcRZ+aTIcg15sQxIX0Awc4/EMafxi2VHwSOYOFdlbtvwt9zyAYY30AFfZwG
         bcbJWnYql+Rld5hfeVRvJPbwEzF4NiRK2dNGrr0J3d71QOXjB5e5kVtuFAVw7QxDQ0en
         fxYlxFB9KA02uTk+43uAW9EUljQdYaehDNqmrGtaSzO9XWge+D5gVxNoewbFMjdx6ryF
         cQbA==
X-Gm-Message-State: AOJu0YwxszUFyyQaMmO+Bn+JXBvLKyx0TLCn1/Y5IVMrsFuWlikdYKb2
	WGMwIrfqn2XujW6uOVBPphsttVZ1OK7Wv2OkbbhZukDzvAc+F5NtSruUNsCCm8+yES4=
X-Gm-Gg: AR+sD121moFWt86lyMjEK5YEp2cknnEsmmA7XCwhIub+oAdxgY6UgAgOvC5C12Vp4A4
	In6WJu+F5ZI6nECKgJ+34+1TzCke5wSQuu0/S9ZE0RQO3BkKbqyUlJjZ1+Dh0rRuPOk1ulhaUk7
	oRtP5qVAts8UJsbakFtaDr4DCRZl3fXKbMxlnQbFa67us7L9syhRt0+fzOeiKVThVLOAwH+qHL4
	FdNtKgLpacO6XnhT9B3qrCcUyY2AQ/iPBcyT+e/5vxtlVBVId5fsAcEtg9EQLT1/hSyIbgxG/B5
	E8rwoUgtFlpjWsZ4B36BxkracE+pC150JsdMJl9Azv0I9JcZeKtVTw27VQMkZo3HLUxtT5yi94x
	bPixU5i40IU4U8dz8ZTsMoUwv64cN1N6WN4gjKBonoN7OgNlqss3AT7gBSDzt8GXGR54OZ+JICG
	z4TsToO62BBSmKQS8SDFBdYcTdQyfXatvIyTS+8R7+ffbE4NKx5hc//v3gvEZLClUjXL+TTQ==
X-Received: by 2002:a05:6820:178a:b0:6b0:40d9:8691 with SMTP id 006d021491bc7-6b099ae1beemr490758eaf.8.1786390402359;
        Mon, 10 Aug 2026 12:33:22 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 586e51a60fabf-459f1a9e431sm8909201fac.6.2026.08.10.12.33.19
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 10 Aug 2026 12:33:21 -0700 (PDT)
Message-ID: <34d4ca1b-ce89-444f-bb02-245287edfad0@linuxfoundation.org>
Date: Mon, 10 Aug 2026 13:33:18 -0600
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] usbip: fix use-after-free in event_handler()
To: Aleksandr Nogikh <nogikh@google.com>
Cc: syzbot <syzbot@kernel.org>, syzkaller-bugs@googlegroups.com,
 Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
 Shuah Khan <shuah@kernel.org>, Valentina Manea
 <valentina.manea.m@gmail.com>, Nobuo Iwata <nobuo.iwata@fujixerox.co.jp>,
 i@zenithal.me, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev,
 Shuah Khan <skhan@linuxfoundation.org>
References: <ee9bc932-2fbf-4e8f-90e2-6cf604be9ff1@mail.kernel.org>
 <b47d2b37-0aba-46cc-afaf-cf824d99524e@linuxfoundation.org>
 <CANp29Y51K1Y0Z77oUEQmDpVPjJuz3fQhvvZp2=fw3GWSPiCg3w@mail.gmail.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <CANp29Y51K1Y0Z77oUEQmDpVPjJuz3fQhvvZp2=fw3GWSPiCg3w@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/7/26 08:18, Aleksandr Nogikh wrote:
> Hi Shuah,
> 
> Thanks for reviewing the patch!
> 
> On Tue, Aug 4, 2026 at 7:31 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>
>> On 8/3/26 09:05, syzbot wrote:
>>> From: Aleksandr Nogikh <nogikh@google.com>
>>>
>>> The event_handler function in drivers/usb/usbip/usbip_event.c is a
>>> workqueue item responsible for processing events for a struct usbip_device.
>>> During device teardown, usbip_stop_eh() is called to wait for the event
>>> handler to finish processing. However, usbip_stop_eh() uses
>>> wait_event_interruptible() and ignores its return value. If the process
>>> unbinding the driver receives a signal, wait_event_interruptible() returns
>>> immediately, causing the teardown process to falsely assume the event
>>> handler has finished.
>>
>> Does this mean unbinding didn't happen?
> 
> The unbinding did happen (and finished freeing the memory), but
> without actually waiting for event_handler() in
> drivers/usb/usbip/usbip_event.c to finish processing the removal
> event. As the device memory was prematurely freed, we got the
> use-after-free crash in event_handler().
> 
> For reference, here's a C reproducer for the original bug:
> https://syzkaller.appspot.com/text?tag=ReproC&x=16ffb7b9580000
> It sets up a timer to deliver a signal and wakes up the
> wait_event_interruptible() call.

Thanks.

> 
>>
>> The teardown process then proceeds to free the
>>> usbip_device memory. Meanwhile, the event_handler workqueue is still
>>> running and attempts to access the freed usbip_device, resulting in a KASAN
>>> slab-use-after-free crash.
>>>
>>> BUG: KASAN: slab-use-after-free in __mutex_lock_common
>>> kernel/locking/rtmutex_api.c:559 [inline]
>>> BUG: KASAN: slab-use-after-free in mutex_lock_nested+0x5a/0x1d0
>>> kernel/locking/rtmutex_api.c:578
>>> Read of size 1 at addr ffff8881145245b0 by task kworker/u8:5/6177
>>>
>>> Call Trace:
>>>    <TASK>
>>>    lock_acquire+0x84/0x350 kernel/locking/lockdep.c:5842
>>>    __mutex_lock_common kernel/locking/rtmutex_api.c:559 [inline]
>>>    mutex_lock_nested+0x5a/0x1d0 kernel/locking/rtmutex_api.c:578
>>>    event_handler+0x1e3/0x4a0 drivers/usb/usbip/usbip_event.c:73
>>>    process_one_work kernel/workqueue.c:3322 [inline]
>>>    process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>>>    worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>>>    kthread+0x388/0x470 kernel/kthread.c:436
>>>    ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>>>    ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>>>    </TASK>
>>>
>>> To fix this, change wait_event_interruptible() to wait_event() in
>>> usbip_stop_eh(). This ensures that the teardown process strictly waits for
>>> the event handler to finish its execution and drop all references to the
>>> usbip_device before the memory is freed, preventing the use-after-free.
>>> This change is safe from deadlocks because usbip_stop_eh() is never called
>>> with locks held that the event_handler would need to acquire.
>>
>> Correct - usbip_stop_eh() is called without lock hold after updating
>> the shutdown_busid status to true. However I am curious what happens
>> to the unbinding? Should usbip_stop_eh() check the return value of
>> wait_event_interruptible() and handle the error instead?
> 
> During unbinding, we must wait for the scheduled removal event to
> finish before we can safely free the device structures. From what I
> see in the code, once we have reached wait_event_interruptible(),
> there's no way to abort the process or somehow gracefully handle the
> error.
> 

Yes I agree with you on rewinding being hard.

Care to explain the scope of this assist?

Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot

thanks,
-- Shuah



