Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.218.41
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792660568;
	b=HHmX0ToeD+rdvXdK7SxHpXxYeZSynlxcnxL2LhjQ7RR17Oo0NK+bp7BXCRumSKLIjMxC
	 RPFOTOzm0C3DT5VJ/uEc/o1G4nZQa8CNB+cvJl2czCnXSWHlx/uKXC+8AotAaT8zESOKp
	 2yWTjF23Nqs3UiXVOR8zgYtDNs+qxlJRfMo9TlJvDYHKsGlrwfK4YQyHAYIweJyx0n3Ha
	 qTCMH3yhawuZox7d1HQBZjsLpEcGEd3sKjRD2lEcGlmwd+TXd2dNTyPq3CkJRb0X5ROFF
	 1SNfvP+f5YAyB4ID2f1fGe/CM6cD86NwfFNtygi2f3nHDnei0NB70af9xh9VG/fk+9w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792660568;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:From:To:References:Content-Language:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=BEdEm/UOd9RYDumPhDcQfJiPaxke+uQSE7gUuX6TRYU=;
	b=sJo2TdL/Ril9RgDvx8p9uWa/ys3ltThfNOM6BuH2PtQSjpI0l7anWkvewJXJ43WRjErT
	 R2TefikfMeEHeaoKcP9GHyVlxQVM9F0yDqD5VA3XgeoWAAn+XhQBo4TQDDIioSbRlMrys
	 7K8x3FpdNcIX3w25H1xsohUCVmGnjPBCGN8QgqYT5bhzxGtO61uDxo6VQ8PwBPTP1D6bN
	 QLAj+Plc6DhPQx/nQu+E7JFjZAW2ihjBNpMUSXUhCmjw971kgnvy9sqOk95lng0driBNs
	 xLxjCnz5RqVxtPbtUSJXQyfPhfMJaF754IBhH9e9bcZS5qQfHotNOVAZbM3YBJ1hIEA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aW80jDR9;
	arc=none smtp.remote-ip=209.85.218.41
Received: from mail-ej1-f41.google.com (mail-ej1-f41.google.com [209.85.218.41])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2DC24606A319
	for <syzbot@lists.linux.dev>; Thu, 22 Oct 2026 09:16:08 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2DC24606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=aW80jDR9
Received: by mail-ej1-f41.google.com with SMTP id a640c23a62f3a-c4322d310e7so223307366b.0
        for <syzbot@lists.linux.dev>; Thu, 22 Oct 2026 02:16:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792660566; x=1793265366; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=BEdEm/UOd9RYDumPhDcQfJiPaxke+uQSE7gUuX6TRYU=;
        b=aW80jDR9OdVz6+3vJz+b7OfQ5r9IlVWNbTCKY3TI5DlP4qjGaeUTIm8GjtSxaM5CQE
         8nHoviqnKNEI5V8QM/BWexO7zLr66c8/X9DM1AaIXct8w7kDQJLRPBG2eXdj13a4/LRo
         CdCdDn3zmXppvFG8yyjynqO8ikDTE6F9ArzaWOR1vFJ6TTJ1kWREnQ4wXIxTz1CdaMjr
         +GeRU081G2C6V97iV9pJKyhR7q64KKQiqVBhcbDSyGZAqRwtkj++iVsmqSeD6rOqtxV3
         DVkcRnAdDH5ypwaWSLf26mS13fqAw34EV7BFXF6JWRzZrKR+rieOQ0cYx0VeApIfYE0u
         IOmg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792660566; x=1793265366;
        h=content-transfer-encoding:content-type:in-reply-to:content-language
         :references:to:from:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=BEdEm/UOd9RYDumPhDcQfJiPaxke+uQSE7gUuX6TRYU=;
        b=WYQjId8OpyQJeZozq9Sn+Bk2ScsotRHpzE/+v/gDwV87UZrUmS+tdZpPqAA/pPtJC6
         pK4f8UJbkzg32ccUmonUEbaYb7L4QORZzvJEb/WNtkGunI+BPSLhKVYvmwd+lBmrgyPH
         NWeaC0IOdA7cqjKU8Y0avqehQlCsZBToVPlD6NHPIJkDC5esj4To22DjBx/AAzTCDk2B
         0AN9uxRSSyBSTc0eL1vKaWy/7G1ygdxGShMOe0zCQhYanZRgvyrRLYE7ZuyhuJOqbbnq
         S4FTwlaSiXQTYJNMJEHmrLnNcLu8fdW+pr8k2MnUJwSv16/hvbqDk51iE9SlGNpGI9we
         5V/g==
X-Gm-Message-State: AFq9FYJr7ZhGVbuaxM+iL4tsvoOqgwYIB0zBCTAM48iZXcc4fXaVvgcO
	eZjNVr+gZ6sjd+hPO+0Bgn/A7So/NCaCs3I16s7IA1/7YS/S/QqZXKyCoKONSbD3hA5IqXqI
X-Gm-Gg: AYBFou3CfxG+kRDXFDeL0ty5sTGyDRiZ8U+QX5R8f8PMJE5h9Cmhn+TpRRdJlyLJXvy
	6V+lkMAEzBoYW8CkydxSG4Ukl5Yj0NPnXSLCHIm+bUnvV4YOOSGzs0dIYFirKfITl80AuvdDMcB
	BZHE0msy1D/hdD4KuS/cgzKiADpOfPKyEwUfUOSB+gEno58q44p350bcfbcIcmQ4z7/2hNEVmFj
	Nk4pLxXZyItT9WAkqLnes9PcO04Nthi7rduaYldnv3uYaSSawWiRmC4ppn7ihnf4MHuOoAhzQei
	0k7lzPwlQrd3Q9DxqQfURTG2oYbqCjb0xb12XdbL1STRsHx+LGBOOB7iFe8GWXjciBMtcAnCYq4
	wgLCVqMYnz2tIU7jiUXAiSoBTPuESHTJAWx3wSu0ONRzEBcBfAwSkGuJyrSZUDEujpelgPXHplo
	ON7wscqUyQhOxhXsmsaSMm5RDYNsIecofEgQAhxy6TlFUQnfp2a+i7ayY0I+OJIkgdA2l3sQRYY
	dQQAOJaRke/w5dltZCzz3RwB2e6ZM4Dr9pXuQPPHU9pHV1q5xiJIGZsC2TFv/4+BN0co8u6UcDl
	FWv3xzGgqAtCeCJP09B44LtznMNaHVKsHFQxI7VlHM8zIUMhK6phZXlarAEgnJbEg6x5pZBQivt
	P8EucFAtEd46RSyysBMlYbupayaWImOXtkiqUGRGX1Ffwq3a/i680OFB+o5QXUMgxpE98lSjNDO
	+qKiBdJsZoS4M9Qbk8
X-Received: by 2002:a17:906:dc8e:b0:c29:22cf:b0f5 with SMTP id a640c23a62f3a-c46797932eemr412966166b.33.1792660566393;
        Thu, 22 Oct 2026 02:16:06 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a59d61esm85735866b.56.2026.10.22.02.16.05
        for <syzbot@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 22 Oct 2026 02:16:06 -0700 (PDT)
Message-ID: <0275e6f8-16bf-4755-bb5e-f704825b0b8c@gmail.com>
Date: Thu, 22 Oct 2026 11:16:05 +0200
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
Subject: Re: [PATCH] usb: gadget: u_serial: pin ports while TTYs are installed
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
To: syzbot@lists.linux.dev
References: <20261021061734.3972101-1-mehmet.fide@gmail.com>
 <74076197-8f03-4f7e-a691-442b7d544cdb@gmail.com>
Content-Language: en-US
In-Reply-To: <74076197-8f03-4f7e-a691-442b7d544cdb@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/26 16:50, Krystian Kaniewski wrote:
> On 10/21/26 08:17, Mehmet Fide wrote:
>> Hi Krystian,
>>
>> I sent a narrower fix for the same problem [1]. This patch also covers
>> the two holes Sashiko found in mine, so I will withdraw it.
>>
>> Tested in QEMU with dummy_hcd on usb-next with KASAN and lockdep, and on
>> a Colibri VF50 on 7.2-rc1, with delays injected into gs_open() and
>> gs_close(). Without the patch, freeing the line during a close gives a
>> use-after-free, and a close after a failed open a NULL deref. With it
>> there are no reports, also over 40 add/remove cycles against
>> concurrent opens.
>>
>> Tested-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
>>
>> Two notes:
>>
>> 1. Since Johan's 8df07fe93573 ("tty: fix saved termios reset race"),
>>    registration no longer frees the saved termios for u_serial, so that
>>    reason in the commit message is out of date. Publishing the port
>>    after registration is still right.
>>
>> 2. The NULL checks in gs_open() and gs_close() cannot trigger, since
>>    gs_install() fails first. The gs_close() one is what Brian Ellis' v4
>>    [2] adds, and this patch makes that one unnecessary.
>>
>> [1] https://lore.kernel.org/linux-usb/20261019085855.3259716-1-mehmet.fide@gmail.com/
>> [2] https://lore.kernel.org/linux-usb/20261013-u_serial-gs-close-null-v4-1-9ea038501994@gotenna.com/
>>
>> Thanks,
>> Mehmet
> Hi Mehmet,
> 
> Thanks for reviewing and testing the patch.
> 
> I agree with both of your points. Since commit 8df07fe93573 ("tty: fix saved termios reset race"), u_serial registration no longer resets saved termios, so I'll remove that outdated explanation. I'll also remove the two unreachable driver_data NULL checks from gs_open() and gs_close().
> 
> I also noticed another potential issue flagged by Sashiko:
> 
> https://sashiko.dev/#/patchset/84170
> 
> In v1, the TTY device could become visible before ports[port_num].port was published. This means that an open triggered by the add uevent could temporarily fail with -ENODEV. I'll address this by publishing the port before registering the TTY device and rolling back that publication if registration fails.
> 
> Since this changes part of the code you tested, I won't carry over your Tested-by tag to v2 for now. If you still have access to the setup, would you be willing to test v2 once it's available? Repeating the dummy_hcd test would already be helpful, though a VF50 test would also be appreciated if you have the time.
> 
> Thanks again for your help.
> 
Hi Mehmet,

v2 is now out in this thread, in case you find the time to test it.

A correction to my previous mail. I wrote that I agree with both of your
points, but I did not follow the last sentence of the first one. You are
right that the termios reason is out of date, but v2 does not keep the
publication after registration. Like the unpatched driver, it publishes
the port before registering the TTY device, because of the -ENODEV window
from the Sashiko review. A test that opens /dev/ttyGS0 in a loop while an
ACM function is being created hits that window with v1 and not with v2.
If you had another reason in mind for publishing after registration,
please let me know.

I also checked that your flush_buffer patch (2/2) applies on top of v2,
and v2 on top of it, so they can be applied in either order.

Best regards,
-- 
Krystian Kaniewski
