Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=209.85.221.45
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792563459;
	b=Acsv/SRfh/NCNrt0YamNhg4Jey7lZWvfvUPFaTPSq6jazGrR35kH250dmZJQDRtij5uP
	 eLLK2vjAQmRUHDYulX70cV0pol6t6eVjRvzkt04edv3HNnnO2wArB/F0aIO83+1AqFrRg
	 pvOKjsVjO1fty5dPu8masnKeFzT4b/0V7yQZ8RCrV1HtYs/nlixa7CRNExtDjvcVmqAGP
	 nCVs+2xMk0NL1uuYKWa3b0h8vRQcrRxvLUJkykQRPh0sM3AaIOWm6PV5JyrgpPCpnbNLX
	 erngkBnCwxTDi4wjd3+4DS1gFeEkZIhHieJB6kBf/ApEbTnEGe5zlM9CdQjYbp7Pxpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792563459;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Forwarded-Encrypted:X-Gm-Message-State:X-Gm-Gg:X-Received:Received:
	 From:To:Cc:Subject:Date:Message-ID:X-Mailer:In-Reply-To:References:
	 MIME-Version:Content-Transfer-Encoding;
	bh=D6XUWb0GjEEWdU6R5sZ+fFb8cLsQeyN87HkVdMPgxsA=;
	b=Yh8zsn4QgyTM4XHCm0FNq/vZWwImafh+DAO5bTV9N7MqBWThdpMcR7aUk+ccqGNnTi2M
	 s3WdHGWoVVIza4q9qTg4nWw1RFAMFNoYicO8TDskMGlpo/QXFuyF+OV9x+Q01XH8zo0jN
	 RftveDS0hdg6Yq3bzawZ6spckki80/Ez+FvuOvSH5qO5jttXuRmw81EGle1Wo/JJzlxux
	 Yw2cAfgAGfmSteBRESV5J888OISAmHbiksUpL/TacVJxcQj0SP9mZJFeJkM7//f1fT0Ub
	 vzTcxJZiWRg6FIevd+d+dLAknvHaGSJC1LLjj84VG1MLuf/AtmI20h6wdJT41SQYpGg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QNDZ7Moo;
	arc=none smtp.remote-ip=209.85.221.45
Received: from mail-wr1-f45.google.com (mail-wr1-f45.google.com [209.85.221.45])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32C7C606A319
	for <syzbot@lists.linux.dev>; Wed, 21 Oct 2026 06:17:38 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 32C7C606A319
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=QNDZ7Moo
Received: by mail-wr1-f45.google.com with SMTP id ffacd0b85a97d-48e20edd106so223675f8f.1
        for <syzbot@lists.linux.dev>; Tue, 20 Oct 2026 23:17:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1792563456; x=1793168256; darn=lists.linux.dev;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=D6XUWb0GjEEWdU6R5sZ+fFb8cLsQeyN87HkVdMPgxsA=;
        b=QNDZ7Mooawsj+clal/WU79NFlqnKlR1L9QGdLEc28m44xBitce0KimJX6PzJBIh6z7
         RfsRHJU76gkdi65oWaGrYVDxCCmM3DpFNsrPyhev0/udEzxLg1xZBdxyXZcY2SLcjckj
         dAmQGCOasZJH9gHpkWuU9URJxH7vRQDj1BnOCjSwW8AraclGpfcEqEg7rifWxWFlaq00
         fOWrhrpcSnPyYm4U0ha5SlQJOBcStfiwHNE6ZRLiL7Te/Z/oEKAhPfwGl/Wbnzq0HIRS
         cFN4uXB270Pcg6BdkGitOdwEbMJrd1dF4PqqnY8RFwv4pyMpE/uQ6kDvC3Qqjvj0XRDg
         vsGw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20260707; t=1792563456; x=1793168256;
        h=content-transfer-encoding:mime-version:references:in-reply-to
         :message-id:date:subject:cc:to:from:x-gm-gg:x-gm-message-state:from
         :to:cc:subject:date:message-id:reply-to:content-type;
        bh=D6XUWb0GjEEWdU6R5sZ+fFb8cLsQeyN87HkVdMPgxsA=;
        b=jRzmEtRKH0ReZGjSv9BUlNI9PbUK0XYBj0GS8mzKQXitNlGylaX5mcpd0LWYsIzIGy
         OJFti10QrL+MNrGjKWgqNpmgKatOc2LRcYi3kR2st/XLlE7SekqH0xosqfBXoxkxhiwT
         7dJQbnyXgka4TWG328wvHw6vUl41UmwcXPL1IllskzZInWBzY6pR+27ENQ0DIxLj2LWK
         r09MU0GqFYEdW5AQ/KeyZjPF5euo7s2RoizInwbhWie1T99/mPAtOBYTG91y3utUXRjn
         QSgI3C9YLTvX+F9KLvGaCIdQqMTs9sQVg045xPBDljD+t5or4dTuQMXbvaA9HRIwQNsX
         I/oA==
X-Forwarded-Encrypted: i=1; AKwUvByCGKx1AwUxOIlW+fohOjfNH/kaHBBqKBEB4pkdj/79H1ZTf9gQ8JVvcOYoMgElT8NyvFhlBo8=@lists.linux.dev
X-Gm-Message-State: AFq9FYJs/N+oG9iV+iWSh+WaV51CZKLUjJWvbssBxjnEIH1C6UB0jjJZ
	XG9Y0GbPtHZy/j9TJMZCdORY1OlYrggylu/LlEWLH4NXz6+pxQaurGuXdrfE1vUSxBs=
X-Gm-Gg: AYBFou0mSU9CqhaAlaemh3bVe/kD7tcAWZ3L5nusXYiZZNhxsUk0ZfrG4XWMxUxJSyW
	NpyclUEdLSfl211pTBLSN9OdKDKCcL2yiTUCO9nWGandM81OUs+QQwidXwlNV+nGsluSsFPepLD
	G6CO5S4vn7l26smUw4KpdCff946vmNiXpBcLXZtS1iDf3AoafT1bz8Bu+UO3CouK2DshG21vBhX
	aL4gdwJsnW5Q9EPRwFji4FP5JOOyOSODJEWLCQ0/f/uFoG8H0LY1NOcnP9OBmrHvSZQrKGfT8Nw
	IltMdhtrWSgzpuA44DSGBtaaEgYh46EvSoqrvWL7WvOmfMfhzAM2aSe7I7ZtZEIBX5ut27x2uAu
	7rA0uw4dZQhyj5wlablpTiWMAg4uvBvd6XBnM3opGDzRNAyNGq7O/kzaU1O0mm2i17OmTUVx68J
	7EAeaHGovkW8W35zUUgNfQH1kiZO9EwG0RJiW0eWUQwlpvlRc2+2WGYqUSsrc+IkhxbIPofVBni
	75wNcFQTH9GZl4yg+U5ddC0P9Ymm64ebOhGa1N/K4xxJQxiZCvVuqVkHBUf1A==
X-Received: by 2002:a05:6000:2086:b0:48e:b62:d133 with SMTP id ffacd0b85a97d-48e2642cf54mr1849014f8f.5.1792563456309;
        Tue, 20 Oct 2026 23:17:36 -0700 (PDT)
Received: from deb05.proceq.com ([213.160.61.66])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48e25835404sm3663876f8f.42.2026.10.20.23.17.35
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 20 Oct 2026 23:17:35 -0700 (PDT)
From: Mehmet Fide <mehmet.fide@gmail.com>
To: Krystian Kaniewski <krystianmkaniewski@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	linux-usb@vger.kernel.org,
	syzkaller-bugs@googlegroups.com,
	aichao@kylinos.cn,
	kees@kernel.org,
	linux-kernel@vger.kernel.org,
	syzbot@lists.linux.dev,
	Neill Kapron <nkapron@google.com>,
	mehmet.fide@screeningeagle.com
Subject: Re: [PATCH] usb: gadget: u_serial: pin ports while TTYs are installed
Date: Wed, 21 Oct 2026 08:17:34 +0200
Message-ID: <20261021061734.3972101-1-mehmet.fide@gmail.com>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <6941beb7-8cae-4cc5-ba07-e1c8a8753fe1@mail.kernel.org>
References: 
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Hi Krystian,

I sent a narrower fix for the same problem [1]. This patch also covers
the two holes Sashiko found in mine, so I will withdraw it.

Tested in QEMU with dummy_hcd on usb-next with KASAN and lockdep, and on
a Colibri VF50 on 7.2-rc1, with delays injected into gs_open() and
gs_close(). Without the patch, freeing the line during a close gives a
use-after-free, and a close after a failed open a NULL deref. With it
there are no reports, also over 40 add/remove cycles against
concurrent opens.

Tested-by: Mehmet Fide <mehmet.fide@screeningeagle.com>

Two notes:

1. Since Johan's 8df07fe93573 ("tty: fix saved termios reset race"),
   registration no longer frees the saved termios for u_serial, so that
   reason in the commit message is out of date. Publishing the port
   after registration is still right.

2. The NULL checks in gs_open() and gs_close() cannot trigger, since
   gs_install() fails first. The gs_close() one is what Brian Ellis' v4
   [2] adds, and this patch makes that one unnecessary.

[1] https://lore.kernel.org/linux-usb/20261019085855.3259716-1-mehmet.fide@gmail.com/
[2] https://lore.kernel.org/linux-usb/20261013-u_serial-gs-close-null-v4-1-9ea038501994@gotenna.com/

Thanks,
Mehmet
