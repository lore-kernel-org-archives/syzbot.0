Received: from mail-ed1-f43.google.com (mail-ed1-f43.google.com [209.85.208.43])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64F2431DDBF
	for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 08:46:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.43
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782290816; cv=none; b=XJ44Zovg6GS7NYe6Vy/+DXgQr6/zmt82QVsyw9r7qkbsW/o4ig6DeaWCDMK75jIOTdXqSBilFXyCLNTEbJUSrODIrnigzoDoKxuv+3Biy/RdZQwVJA1GrjfL2PmdCvP+Svx38nAd/YOiqhpR02dfF0zB5/4oDV6KSznrfht4UKY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782290816; c=relaxed/simple;
	bh=JYmu2+JdkqGyZTP1oLieVZekIxSdPrIlArUvGyIdG1o=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MZlCu2KXy3KFMt8aNg3GbLO8KUR333MU5zy2ybGYRGPanKrsQLrMeUGkHRobsOK202/AHIAGXY4H/UQugyLR5lo/LZ+SpHvIx2rICtQz/AAC5G5x8O9kUXV0i5JPsXS4cqTU+SzP9EA19OXGeQ72bQWvvAdlm405yTSxgRwJ7xA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io; spf=pass smtp.mailfrom=bynar.io; dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b=LxGR/JNd; arc=none smtp.client-ip=209.85.208.43
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=bynar.io
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=bynar.io
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=bynar.io header.i=@bynar.io header.b="LxGR/JNd"
Received: by mail-ed1-f43.google.com with SMTP id 4fb4d7f45d1cf-693c51a8a19so1328151a12.3
        for <syzbot@lists.linux.dev>; Wed, 24 Jun 2026 01:46:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=bynar.io; s=google; t=1782290814; x=1782895614; darn=lists.linux.dev;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=EVe3tCAxlFJeaGN50Dp+OHqy135nya+hifIMDSlUhLs=;
        b=LxGR/JNdO4CmyVpdt9vcA9+LZkGVPw1XdhkySLPr1jHznLf25mneJLjrQ2slvrd+cj
         5XJTaPJ72GiBiOS+DqE+QvaBLEjIUEpxJfa9vP3GOveQGS06TF/1ptCP6/Wkwv3iecDy
         +LYDBC5iFTpW2QSrrsGtWdNzYycl0wK3p9hvpbSdr7t4eLQmLIonsLd427L0rUaJlu39
         bCLD5udZkSqa2AlromLimihst1vhvhercoWQLeHyZIvRgi6o85WwmwRBfDFd53pxLX+R
         jd+vBZg2t4Lvt8EEDRCo2myqL5tBlHLgSaTOrGWnq5Eid02aguqHTfb1cEjMs73ri+3M
         1A/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1782290814; x=1782895614;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-gg:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=EVe3tCAxlFJeaGN50Dp+OHqy135nya+hifIMDSlUhLs=;
        b=LuwULCQJUg1icLsCdDsmEB4wbPc/eoKZGmqrtPV9t+8t2dp7aSoXH5QVQvvWofNpCr
         bianp8x6iQyeWw5l86Ft2WZ5Df/PThcxgdTwHLPhyUP8CkD18F1dsxZNA7CTEiREUgBu
         b3EkAFAmJBPHP6GjuL8PsIkPG5y5jbIxWaqjBwQswVqEMOMZx4Vpr6jxi5QgflPTMGG6
         tepjJYTc6wqHsnY2F+ywii2Ts/1M7lon5BMeZNWeeHhh0uM1AjW5oyJ+KKW+MTPbOD41
         5DEpf+WoZKoJYWdF2fWMhZyRxUCvRzBq2JlGsTuvfPkzz3eBcrzGRoo1WdOXxOIdtLYs
         OBsg==
X-Gm-Message-State: AOJu0Yzjbxp5ldjPQ7QLWE37vYRnC+LSQF1szXzUYSM5cfucN0n9QUdr
	5TEdMVYthMENihA9P2xsVnuHls4rqBaf+jT0clog9iu7IDSEWTmH+AyKK/EDC7p4sM7T
X-Gm-Gg: AfdE7cnCWnXvXw9DzJlMGW1iejt4TN73dPQi7WmUYmSymWLLBqksL+Iaa+oRt8yo8q7
	zt7kRr0Zo1dlpy13oa3I3ovUrL1XM7QIh0TJ83VTacSt+mM1UPwDsVylqKQhWc5RVPhVKJi7zPX
	1MjqIgmCtfO/7nLoq+lnOOUl1eHuM5UkO9Mgxd3G4JRblIe47Q+66URV8ntGRijDaDBlbR6Nw+F
	TM5zjIRW3AWVvYFzFt+a0g/aXzvt/dgWJUy+7NUfKDzqh0fk+z8vLKP3m/fPmKpT+bTDosHVz1d
	hNxSLdCOB5mnqGJw08/BVb4ZrI1RtCWVLCELMj+YeUIqyiAMH/gGD8c6qqjPaulsj5+e9BoeCqv
	nB5D1IyOcKBICDoH+ymn0oZxsrZ8rpvQWBSMI2kakPSUU+0z3D496Ytth1NXaSDO5rNA7ZrQpWp
	vz0TKvlYcr9xRUACGPDJCGZNg3C/1R+dCmUeLXHIMU4zn+5g==
X-Received: by 2002:a17:907:a392:b0:c08:417e:3696 with SMTP id a640c23a62f3a-c107d7137b7mr319688366b.20.1782290812994;
        Wed, 24 Jun 2026 01:46:52 -0700 (PDT)
Received: from ?IPV6:2a06:61c2:d427:0:b321:1c7a:b072:326e? ([2a06:61c2:d427:0:b321:1c7a:b072:326e])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c0c61610b2esm640641866b.57.2026.06.24.01.46.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 24 Jun 2026 01:46:52 -0700 (PDT)
Message-ID: <c9abc633-239c-4562-b1df-5c9d687e70d4@bynar.io>
Date: Wed, 24 Jun 2026 09:46:51 +0100
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: nfc: nci: fix uninit-value in
 nci_core_init_rsp_packet()
To: syzbot ci <syzbot+cie92d4e0088e1c4d0@syzkaller.appspotmail.com>,
 davem@davemloft.net, david@ixit.cz, edumazet@google.com, horms@kernel.org,
 kuba@kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
 oe-linux-nfc@lists.linux.dev, pabeni@redhat.com, stable@vger.kernel.org
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <6a3b838b.c358b6d0.89040.0007.GAE@google.com>
Content-Language: en-GB
From: Sam P <sam@bynar.io>
In-Reply-To: <6a3b838b.c358b6d0.89040.0007.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 24/06/2026 09:13, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] nfc: nci: fix uninit-value in nci_core_init_rsp_packet()
> https://lore.kernel.org/all/20260623222402.175798-1-sam@bynar.io
> * [PATCH net] nfc: nci: fix uninit-value in nci_core_init_rsp_packet()
> 
> and found the following issue:
> UBSAN: array-index-out-of-bounds in nci_init_complete_req
> 
> Full report is available here:
> https://ci.syzbot.org/series/2a9a8657-37a3-4dce-8cb5-2035027791dd

Oops, looks like this patch did indeed introduce a regression due to bad
check ordering. I have a v2 prepared, tested against the syzbot repro and
NCI selftest which I will submit after the ~24h patch resend period is up.

Thanks,
Sam

