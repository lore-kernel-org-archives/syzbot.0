Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7C0B3AFB06
	for <syzbot@lists.linux.dev>; Tue, 11 Aug 2026 22:39:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786487955; cv=pass; b=oXWBtC4fUhCC9jgA6brUhAiGmZbarcJhoujo6X+7sc616O9aE6HbAtqLRwzu1pw1If/nixtUAukfCGt5MMRXLHkC6SBzMUwW6NC+XXFpcILDEcuzHwgTMh968fKthUiVetk+DtVdCixVSBPvXFVmy3ibkOnHV5vSV+uSSqMuJj8=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786487955; c=relaxed/simple;
	bh=kQ+fdYLDhgGWWrJs09YPGMYtOEZLeknZ+epQWvrMl0w=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=QYJ7AxWWbljDr9NB/CqwZ++YwyIIazVDJ9k+Y7W6LS03ElT5vURXCZO1viv1nOGmJOLvPkclzi9YBeZTsu7A24dA61U2J3alcX+lsDNw7MfeSORNo/QRC81cdIxVFW8SYoy87JHtmKbHW6LdC3urk8qTD7E9XPlPOBz9/Zf23JA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fLUy3D2f; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fLUy3D2f"
Received: by smtp.kernel.org (Postfix)
	id 351DC1F00A3A; Tue, 11 Aug 2026 22:39:14 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.210.51
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1786487954;
	b=FJGqVygr3h9JU1WOhDRc9A0bNQdYwaM+taEE7HfJUKidPmWMI0/nQQQw6kqcy0R/EyJs
	 lwJZ2ahTCM0OIxu47FGzVYLiJBEPl4b6qdm9RrQ16zbNNT0w2vZmJ1lPBRYybDqVIbvgn
	 PTab97RkgNAq/gmGexZonp4U387fiyIpudhSr6ZK+JTotFbXW+AmjOAaqLb45BgV2Ysc2
	 2LUkW0Y3X8enUybI2ExuI3WuUxE9t6h8SMe9G9cOhKeYoVoyBb1Tjf1KAVv4+tmWSK3Ci
	 ToKlDmZqjuiycNVSC+L/6K2KA83TpYmRgIym5X7SmE6BaUGNrlFKrCSg+s5e9H6tOlw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1786487954;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=ZYA0I95z6d9/WlICxAA3jTqC1JPj7QxjoWJUfGcNVY4=;
	b=TJQK3TPFhFZj+BCGETxvUz2eSgu/1eKizmvIPufOuvKR9g7UK5h+3iHgpleGwcSxIvpD
	 jsoIp1R6/Z4NB7YLN8RVk3fHX3DKXAJJPdENh4tmxaUQwqKp3BB1sgFHDpkI8BVTvuUDc
	 NJFI94TbJVLDAwW24KtHGIrmeBQdRnzKJU7At/uE1njBUPQpCZJZXurjP07VuFJvKy+UO
	 cPsWHzORio3Rty7vjomGYjbKrFuHlcU8RCRy/rVXitPE1793MrlpnF5yj8CLY5J/qP5fg
	 dvGao9J8gek6XpB/ht1OcG7ocgQK4jURXcgyc+VP8/6aa2SaKZ7fmKmMLxLAmiLt3vA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=fLUy3D2f;
	dmarc=pass header.from=linuxfoundation.org;
	spf=pass smtp.mailfrom=linuxfoundation.org;
	arc=none smtp.remote-ip=209.85.210.51
Received: from mail-ot1-f51.google.com (mail-ot1-f51.google.com [209.85.210.51])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C0A561F000E9
	for <syzbot@kernel.org>; Tue, 11 Aug 2026 22:39:12 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=google header.b=fLUy3D2f
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org C0A561F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=linuxfoundation.org
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=linuxfoundation.org
Received: by mail-ot1-f51.google.com with SMTP id 46e09a7af769-7eb4d532e65so188669a34.0
        for <syzbot@kernel.org>; Tue, 11 Aug 2026 15:39:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google; t=1786487951; x=1787092751; darn=kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=ZYA0I95z6d9/WlICxAA3jTqC1JPj7QxjoWJUfGcNVY4=;
        b=fLUy3D2fOHqJmwR+Bj1bFRA/4EOzmdAl9VhxlSLQKF+CDKYAjIW0dNYdQdLXFOlc6f
         SeZ0I7b7EPGbDGJsVozFhrwHqx/zw0+uYIT198ysCTMYvytRormB3JVx5UCc/JY8418j
         xFHtY1kammKRLTac3GM+lrF1SFi18ctkByOYM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786487951; x=1787092751;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=ZYA0I95z6d9/WlICxAA3jTqC1JPj7QxjoWJUfGcNVY4=;
        b=Za6WI8lBzKNynPbWlCjU2uu9yVi+AbmhGEwBdSspQjuLJT92HLwTPe4/w1Utm/dJAP
         u4BKjbeGLem5I9Bli24jioudtIqWcbQYnGbXOhnJ+1li66gajaD3yczVasn+mx/qXnjr
         Mc9qnusbOeKztHt8PNnl4EpCxWW8zHqaxs4t3rC52B/K/MKXJPE/w7D6oweu/7iV+piV
         CJRzM30ZFGzSlnaj1AWwIOtxgz96lE2DoMKkVZXUyHb9S5dhvPJ6rQVjr0yEUGqmWkSv
         dbVzJ9n/YvbgAEjvaYajiDABwKh29r+oxN89uPsv0JRHAktbI90ZT8yFoZMwvU2hQ5Qy
         9HpQ==
X-Gm-Message-State: AOJu0Yweav7vy4GL44sKvgCTgdi5exdNGl2f0SuIxp1dQCECCrn78UL6
	N0Jumgyk1+5hSDiwnQy/IT5L/lpraUDrBSRQmqEVg/yGJRu8BFj7wwGbW7ZgqmvkUnrYWZG8wTW
	11k4SDZM=
X-Gm-Gg: AR+sD135XLp6pgfELDyZVcRS4e++2mFw1l/4nuFVYlCTz4Pb1WFUMYdS8ERBFP1IpQz
	uw3OQCDPmjhU3dZJcTIOWepzHmOdoShk9TYnGaYi9CurRG800U3mLpNhIGycSkGesWF7RCA9Xt9
	Sskn17wqusnkZxx1wyhIpUaHr/qkOo6P8atxWLh8KSy1uNDXpyV+3BB958CE24DrOtWxJ+fYvHy
	SDh1RUGNRgZNtSRqShmaRa6l/CdEKvN7awUPKSkpgnOAfususUlOSrBtFHQ8r/V3tkyVpiyBntd
	57HUOYLNhgJPV+AZ5ylzLuirV/+saNlhgSapC46FqPrqraQwkKdRmewqNMFTKVXfe9FR2hQTwW4
	yX3r3IQ/YXsQILitXHC56DPEWucSxWQBIRa4UQoOQ/JVhYzHiWtHRe0E6TBHWSnZ7dmA9yA1XMo
	nokikPyA+wvJKz3mSj3VHKgWrrBNYKbqCbHmLqzXcvIsAYY7qFKWWcGBllyFrfDE7HoubyBA==
X-Received: by 2002:a05:6830:82ad:b0:7e6:f083:130e with SMTP id 46e09a7af769-7f3b791b0f2mr587825a34.4.1786487951697;
        Tue, 11 Aug 2026 15:39:11 -0700 (PDT)
Received: from [192.168.1.128] ([38.15.57.99])
        by smtp.gmail.com with ESMTPSA id 46e09a7af769-7f3b3475bfesm1063173a34.27.2026.08.11.15.39.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 11 Aug 2026 15:39:11 -0700 (PDT)
Message-ID: <246f34a4-e564-4f0a-911c-1f9f0b4ae1e9@linuxfoundation.org>
Date: Tue, 11 Aug 2026 16:39:08 -0600
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
 <34d4ca1b-ce89-444f-bb02-245287edfad0@linuxfoundation.org>
 <CANp29Y4NLVebq6L7STgcFJYSJo81ZpO4hNvaJQT14OGDZqwzxQ@mail.gmail.com>
Content-Language: en-US
From: Shuah Khan <skhan@linuxfoundation.org>
In-Reply-To: <CANp29Y4NLVebq6L7STgcFJYSJo81ZpO4hNvaJQT14OGDZqwzxQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 8/11/26 07:07, Aleksandr Nogikh wrote:
> On Mon, Aug 10, 2026 at 9:33 PM Shuah Khan <skhan@linuxfoundation.org> wrote:
>>
> < ... >
>>>
>>> During unbinding, we must wait for the scheduled removal event to
>>> finish before we can safely free the device structures. From what I
>>> see in the code, once we have reached wait_event_interruptible(),
>>> there's no way to abort the process or somehow gracefully handle the
>>> error.
>>>
>>
>> Yes I agree with you on rewinding being hard.
>>
>> Care to explain the scope of this assist?
>>
>> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> 
> It was generated by the syzbot's AI patch generation agent:
> https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md
> 
> We manually review the patches it suggests and upstream those we
> believe are fully correct.
> 

As you are reviewing this generated code, did you look into scenarios
where the driver to hang in wait_event()?

thanks,
-- Shuah



