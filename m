Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.208.43
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792594220;
	b=BLJVdxyD4qEIu+qfCXXzwAtQ2nS2yXl5AkGqYCoJZ3m2Ra72wMRhSCIn7DxzPpWzfRd3
	 bh/+wQpW7MrefdFTwBzqvKtjIb6xsiRXSeqT9nbt6s9Y1On5wiV1Uhc2E934CNEs18nJs
	 Ww+9JI4y9UNnHTA1rmV6vD0K2mELoaI75xVQc37mvfRI6VI6chtNvG1yGp2Y25tKDEmHB
	 lErB85STBxGhss9wHpQetRgg7B1IXIvgwId8cHh6zKqbgEtFFHwMPolblPQdZe1iqbWJH
	 kUhgJIwZ5d5u0M/XReEtQXcDcLVby99vBN2/fhV7epGDDLBKmOjH4d8FjZoAbTDBBWQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792594220;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:References:Content-Language:From:
	 In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=eN+BsTSZunKoVUDUNy2rO1fJxwQ/UVy22lL1+EC7Rbs=;
	b=S3k4gEscLMXddoFcN2gTaMrtAEUVdDgrcZeiCxm+aKGaXXTBjpwTbblSrpeThlyQ3hkO
	 +CqDQiGb8YpWzqdho1pqHD2O5wDfKdw1aW15qPOu89YnybEj/KNcI619TC1esXUeryVfr
	 N25N49s3LUedVgIiX+M1VCKQ4YMDusrEFdVPfcQcvyzbSqpxIXgYVjs033843fLQUD697
	 0ILC5rRce0MCX4Jtkeg+w62BtLuh0wTBr5xaogWdQxSfYOkaCC2vPmu3ttjclF5Tr7OWZ
	 uhNyuTqx6T7vKTaK3FnpBj8z6BbkJm5LwLMvU2ertnIccm22waLMP8g1k4d5Lg6UYuw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qqkxpBvT;
	arc=none smtp.remote-ip=209.85.208.43
Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9DE81606A31B
	for <syzbot@lists.linux.dev>; Wed, 21 Oct 2026 14:50:19 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 9DE81606A31B
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=qqkxpBvT
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-6b1ec41d8e9so856122a12.0
        for <syzbot@lists.linux.dev>; Wed, 21 Oct 2026 07:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792594218; x=1793199018; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=eN+BsTSZunKoVUDUNy2rO1fJxwQ/UVy22lL1+EC7Rbs=;
        b=qqkxpBvTQMzogzwbPDU1Zj9n6W8eybuWhTUE/A+GLQlo359nAwfG+3SMVafUG237H6
         cMdi5ifqrdzIQGZpuIwx+Bx56FYwvlzbN+6bgSjT5dfgH/t+8P6vZ2Xpkvzbax1m4vSx
         KbQ6m2ZOpoLa4NzCrobaIwKvOF4ORhvSqupdz9amSjqC3R7eSSOP0AXHDkBBEMa5Px2J
         YOjX4Gad3PoBRnS/Btyp8/YCmB9ovguaIzbxylK8MroD8KFfRB/0lHKfSQJK+QZnJglZ
         82x6ztRIatWZNdCRRysMKdeDbJjOU+T6QTOYapXZV22lATPuqQrKxwp3yK9jkPp0TwU6
         njIw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792594218; x=1793199018;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=eN+BsTSZunKoVUDUNy2rO1fJxwQ/UVy22lL1+EC7Rbs=;
        b=p6mRIGv1m66HuEwvRKvCZRXTXz7fvOfPDCH5cjS71exsNpvDsuLu3yqJPS5fScOyYi
         bOXpNhWBuPIcvvEMeumc6iwrwZuDupADn6Htq7p7I6xVyf4I7XAdTYZpUBdkdnyUAtny
         7kT6I2sDIvY85aNXU3ZCX0NdSnt3uWaW2LXHVvbvd2N9S0kGz+zI8qYrX+feUDqa3LNx
         +JQ2PPfX4corb+bTV8S7cvpSOm5mpe6Oi1lZ20LJ1EDHkqK1a8KOKxfvhv9+QVStmdwL
         rlq7/YMMkcs/aNQvPxle5PDtuqpHcXu5Mu/2ztDPPr2ibVtycR7lBn7XUguzCAjmkN2e
         mAzw==
X-Gm-Message-State: AFq9FYLjo9I6GlcLum5+PKUi5828M8Y9lARLovIO2udE/y9raL6eIomK
	dTNHJYu2MUPZPq7WX9XSHlW3X+Ckqf3dpwdY6W+SoTqQd9CC2p8bdVLLRppNxSaIVtGI36we
X-Gm-Gg: AYBFou02yvjpilJMbQei+pimMJhAsDVg0ux+gem5q8FFSoa08QnxB3RWiK/ABJjJS3F
	5ch3Fqf6FVR3AbgpYNdvBQpxnyG3lLCEEoS4ODvYQRoXrO6jGIXPTFRjnTw4CS7hr6tyTTHl+NZ
	TohgDYQz2vkBP/yHdrW9qSbXV/keAqIuCzyFJbxJYIac4eWRnTHsX38LU+zb+2RexHoDJAyMOrT
	l7cdJlTQWTI2XwNBArJ2g7+utbhEbWPdoj6di1cseAtuGKfjGzxBWIGtC3IK/CMiiv9x/4xMlNE
	8Qk4jrDY9zsU1+08Ad8pu04SaK9AJxCgo8kItkWHIAa8T5bEuaFXopAv42KCSDUANJoDhkEhbgn
	8M3Gz04cAwriFa7QNS44+wK/D3U+FrpbvKGrbdhRCXSwlIHBJm7zPm3vajgwNraUCwwUNz45v3U
	Lxe4WUdRmx2neQUQk64HLZKkPHqsOjVQsBCv7UNNEryGpm5W+PPoX1f94fWLQyjDSU47eNuRLka
	zfpfjwjhFeV4F2NvSxHUOCF6bbb56jAEJR12SBThmYBXSzAnB+p58Z1ImOAcJ9JRtgp23E+GHqQ
	sdMOb2rZDYvcQK1R0jnULPhLBwYw6QWXXqRuVSG+qGTbmbX6264IEXx1NIjvjp21fFdoVosxSGK
	eZvKjv9/dhW/AHrQUZDhGx1I4uR1pOtnJB2IS7G/kX+/8AqzCOrd3UOy9QECvczItCs6Smfnhy4
	iwQgbBiw0dV03Ofxc=
X-Received: by 2002:a17:907:608d:b0:c2e:46d0:b802 with SMTP id a640c23a62f3a-c46797af00bmr211632966b.40.1792594217749;
        Wed, 21 Oct 2026 07:50:17 -0700 (PDT)
Received: from [192.168.100.100] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c468a61b2aasm10614666b.86.2026.10.21.07.50.17
        for <syzbot@lists.linux.dev>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 21 Oct 2026 07:50:17 -0700 (PDT)
Message-ID: <74076197-8f03-4f7e-a691-442b7d544cdb@gmail.com>
Date: Wed, 21 Oct 2026 16:50:16 +0200
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
To: syzbot@lists.linux.dev
References: <20261021061734.3972101-1-mehmet.fide@gmail.com>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <20261021061734.3972101-1-mehmet.fide@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 10/21/26 08:17, Mehmet Fide wrote:
> Hi Krystian,
> 
> I sent a narrower fix for the same problem [1]. This patch also covers
> the two holes Sashiko found in mine, so I will withdraw it.
> 
> Tested in QEMU with dummy_hcd on usb-next with KASAN and lockdep, and on
> a Colibri VF50 on 7.2-rc1, with delays injected into gs_open() and
> gs_close(). Without the patch, freeing the line during a close gives a
> use-after-free, and a close after a failed open a NULL deref. With it
> there are no reports, also over 40 add/remove cycles against
> concurrent opens.
> 
> Tested-by: Mehmet Fide <mehmet.fide@screeningeagle.com>
> 
> Two notes:
> 
> 1. Since Johan's 8df07fe93573 ("tty: fix saved termios reset race"),
>    registration no longer frees the saved termios for u_serial, so that
>    reason in the commit message is out of date. Publishing the port
>    after registration is still right.
> 
> 2. The NULL checks in gs_open() and gs_close() cannot trigger, since
>    gs_install() fails first. The gs_close() one is what Brian Ellis' v4
>    [2] adds, and this patch makes that one unnecessary.
> 
> [1] https://lore.kernel.org/linux-usb/20261019085855.3259716-1-mehmet.fide@gmail.com/
> [2] https://lore.kernel.org/linux-usb/20261013-u_serial-gs-close-null-v4-1-9ea038501994@gotenna.com/
> 
> Thanks,
> Mehmet
Hi Mehmet,

Thanks for reviewing and testing the patch.

I agree with both of your points. Since commit 8df07fe93573 ("tty: fix saved termios reset race"), u_serial registration no longer resets saved termios, so I'll remove that outdated explanation. I'll also remove the two unreachable driver_data NULL checks from gs_open() and gs_close().

I also noticed another potential issue flagged by Sashiko:

https://sashiko.dev/#/patchset/84170

In v1, the TTY device could become visible before ports[port_num].port was published. This means that an open triggered by the add uevent could temporarily fail with -ENODEV. I'll address this by publishing the port before registering the TTY device and rolling back that publication if registration fails.

Since this changes part of the code you tested, I won't carry over your Tested-by tag to v2 for now. If you still have access to the setup, would you be willing to test v2 once it's available? Repeating the dummy_hcd test would already be helpful, though a VF50 test would also be appreciated if you have the time.

Thanks again for your help.

-- 
Krystian Kaniewski
