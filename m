Received: from mail-oa1-f70.google.com (mail-oa1-f70.google.com [209.85.160.70])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 886D5362133
	for <syzbot@lists.linux.dev>; Wed, 12 Aug 2026 06:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.160.70
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786516533; cv=none; b=hZhIylLJOjfzcPEzvk8zqxdEbuv6w5ao04T2BXxLvKfmuW9btTWmsPAHEgP4Fw7t7e3kgESh5HkTtHmVOp3ZWbCKfd4aM9KN8YlHtgm7uxvJelO1OahX2gdFMjtoaAm5XREuVYfvvL5pyOSxfN7ohaq/Ts11wRgkTNtDwJPOg5U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786516533; c=relaxed/simple;
	bh=HGBa1zkRSPS3NuNt39ewH3hXD71snxgA5jS2kn/C8L4=;
	h=MIME-Version:Date:In-Reply-To:Message-ID:Subject:From:To:Cc:
	 Content-Type; b=rYB9xg+HUrVGvfHPu89fB9OJUAnyjafz9N5gBRrVLZih+CCm4oa7jgTNbupFlEfl+GFOILPkld+TQpE8C47W43y1jEUF5FuOz48GhrU88HXEzdFE6iUbWEcc5usdrWPihLGamuP0XBTkmoncSxGxY+iKrBrsThTC+xWLAKNS3ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com; arc=none smtp.client-ip=209.85.160.70
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=none dis=none) header.from=syzkaller.appspotmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=M3KW2WVRGUFZ5GODRSRYTGD7.apphosting.bounces.google.com
Received: by mail-oa1-f70.google.com with SMTP id 586e51a60fabf-455ad408573so788491fac.3
        for <syzbot@lists.linux.dev>; Tue, 11 Aug 2026 23:35:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786516530; x=1787121330;
        h=content-type:cc:to:from:subject:message-id:in-reply-to:date
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=HGBa1zkRSPS3NuNt39ewH3hXD71snxgA5jS2kn/C8L4=;
        b=ZcnCeEHl+X+BqCa9DajrB1DWtM4ArWHOBaEKInpdvaWhRXxbmcQPLPJDwz6W/7solA
         RFtVGUVfnls/VgJcXIA142CqdAJeW2hLcIumKvfsR0a8S3BwLuQit7LKMBA9SddNXyaa
         cCsZQD0WnKxQPmY81EkX2LerrjOld336vRN7mPJ4RgNxcxQcL6OgRGwLLUThqm55lObj
         kFxhV9QVfFNyd2QzXMdtMCwGMU9GqrbTw59/j39M5/7jN2101LGPDA3YE8MgiMkQ1xyl
         07saH4qC4vtOzQDhrZLwOe7Hb8m/DkDagq1htE0mharX9rxhQvy2KikEYA8/e29GNnFv
         YFPQ==
X-Gm-Message-State: AOJu0Yy2/AFkD6UlzNNsxAEXiSeEbgqoc4QCMYUwwXWeaC+Urw9RGHpv
	XOWGuz31FxnM7x2y5ylM9VCOp02tAAAuTqHRTYtJCEcEdNQKn5/GI21fuu5hKnGhRKIL2T4kkvU
	K/yfeflg7uQDeo1kbkuDBsq2UOh+byki09RAyXarauzSjaXVoyINAwOD2kw8=
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-Received: by 2002:a05:6820:150c:b0:6ac:9729:6710 with SMTP id
 006d021491bc7-6b0b282a624mr2137431eaf.18.1786516530179; Tue, 11 Aug 2026
 23:35:30 -0700 (PDT)
Date: Tue, 11 Aug 2026 23:35:30 -0700
In-Reply-To: <81003c25-0d13-4fe7-b7b2-2c676f043899@linux.ibm.com>
X-Google-Appengine-App-Id: s~syzkaller
X-Google-Appengine-App-Id-Alias: syzkaller
Message-ID: <6a7c1432.a2bb2777.31c27d.000f.GAE@google.com>
Subject: Forwarded: Re: [syzbot ci] Re: net/smc: fix clcsock and lgr/lnk races
 in smc_diag dump path
From: syzbot <syzbot@syzkaller.appspotmail.com>
To: syzbot@lists.linux.dev
Cc: syzbot <syzbot+cia7ddf4f17dfab266@syzkaller.appspotmail.com>, 
	mjambigi@linux.ibm.com
Content-Type: text/plain; charset="UTF-8"

For archival purposes, forwarding an incoming command email to
syzbot@lists.linux.dev.

***

Subject: Re: [syzbot ci] Re: net/smc: fix clcsock and lgr/lnk races in smc_diag dump path
Author: mjambigi@linux.ibm.com

#syz test

v4: Moves mutex_init(&clcsock_release_lock) before sk->sk_prot->hash(sk)
in smc_sk_init() to fix the uninitialized mutex warning you reported.
