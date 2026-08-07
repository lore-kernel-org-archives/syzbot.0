Received: from mail-wr1-f47.google.com (mail-wr1-f47.google.com [209.85.221.47])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A21F4361965
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 06:37:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.47
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786084666; cv=none; b=QdT6hY0BUeqYtGBTZgf5WRfuNkQa4cOXTwlLdsxcnYRUq4LP4C0EP+v99Hacz/vmDzl3fKh25pxmHx9a5h0fIALcaCOBi/+HkUroTnGoXflhkZrrB+wYRB6c7UBzq8L4x3XyPzeGi/EWjABiLODBmVyGcDM60WSwPVm7LZJ7vek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786084666; c=relaxed/simple;
	bh=rmUPAXESJoVau+kq7/1HNT3Mj/EpolDaXBtlDwuaEsE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=YCpFxiCAwV2wLYOvXYyAVsZ0Bu5KHCL4MBq1VRUA7njmF2jqmQJYBoR+N+3a+exnOQtEYqcnVSpVJaYNx7o0kQMfd8TysdGQgcNqnWKqFbC4jy3mKSEJkSICbt07wrciIDXtExelFNj861dvUzcc0AxdC/353pnV881CzkWCfm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvpn.net; spf=pass smtp.mailfrom=openvpn.com; dkim=pass (2048-bit key) header.d=openvpn.net header.i=@openvpn.net header.b=frUiS11D; arc=none smtp.client-ip=209.85.221.47
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvpn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvpn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvpn.net header.i=@openvpn.net header.b="frUiS11D"
Received: by mail-wr1-f47.google.com with SMTP id ffacd0b85a97d-47f84023916so2739575f8f.3
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 23:37:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvpn.net; s=google; t=1786084663; x=1786689463; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :autocrypt:from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=L86XMQZx1Pr+hc/ioaLvvk/7Hsm6pyPOxYwS82SfiwU=;
        b=frUiS11DBX2dgDdr2exUQnFGhS7uMRFBhVupXXM/lVgpBi6iJ0nmKFlVy3TB4tiJu5
         NTTtpyAty7ubDrgiXmdr1MivYw35umUGMEHNfJ9PBR2xIEhqcseuzu+Gz9muH5+62KXQ
         drH6lweDRwVnmzTOyiMUsEJJRubyLQqVCN//KkcD4PM5X+Lo2DoFl5S2Evh+FZp+pWPN
         P9jBTE8H3kzTAROYFrv92j9mR+Bhiu03e4vjYR8nL8ZNJeOo3OCyeJ6a4K9pHbAIvFRf
         3cPPoe39xtUka+2FzxYQTPO2+JxtqHQvMSOlFRPEen1nqfA52UAxLzDmD0tZYepvU+Na
         dxDQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786084663; x=1786689463;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :autocrypt:from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=L86XMQZx1Pr+hc/ioaLvvk/7Hsm6pyPOxYwS82SfiwU=;
        b=Fdb0czGtUlzj1bxRSnp4HHp94DYZEuAhybrq2r1OLPwry4S0jAFuSCxPtxSgTG78Vu
         UujKUfkZPrz9Y4bC5Fx569/9lUHIZAKz9RGmC3kV0gs99ilfaEiv8H0TRKeEVqVE/DHL
         j2YCBn1z5ZMzCF+OYDqOVxQRVoA6m3yfq/qQbYWESPL/TK7BqGHawttjyxQ51yzYcPgS
         SO9bdd6b9ci9lcgpFoEVfKo1BJZDrgXHwpVjQxFedXuptELZsA8sQ0krlvfKvZGy0Okv
         qGlScJrAgEpXCNcwOkw8fHekh/6qdr3VLYqXABYyIFovbfy1uOyccC4WOOHIdZqOYC15
         etoA==
X-Gm-Message-State: AOJu0Yzo/QUofMOqPmz3JIGTzUGEof4XhQAixHvqyLlqZKwtBgikRzWn
	HqC8POwIIcF8qN0ARNObC3NcV6iwzfbXuVocec4/Dm6TI39+ZIVJPolb0vUpQYOFv8/n8StgM4m
	JKmRU39UTxi3OHTaW/hfJKuJhVuaTYAZ+mfpUZVDEgmCvw7xwqwc=
X-Gm-Gg: AR+sD13LOkKtKWxGx1N5L8R5ja9cINuB2hvHt03lVL7rAW3QAY5576FIap1QLX/vUXG
	1K8gRaXTc9rDMsu92bJZ+d9CF7UzQnp4eVn427dRO8k8irYYDLSqYmhbvVtuAQlOZlGTMPPdBX3
	zdiE+k90OmGHuIwn64gEm6gGEc8CHdNvDz5yEWyqRtmabw8BKpLGMJILDrJy8MWirZ0lHMaJVZ3
	SDHCs1VZYCLV7zZWffE4L5Yack3kv7FbN5GCvFLf6pJFhdeSP3CFEDuUyMX6JoUJt4g4NM33sAy
	risPayjNiJEPlu88hTHmefWYQKQQFz9xmdUdzElivPlrkP+i6T1C7wjZ+q68FTvkqGK4uXyfrR4
	uyk23yE0UImSdRAnkilKdEKwDrvGbqlFhyDaIhumgtzK0q97RC4/nnGV9+H+gdsLlho/OSQmVfQ
	N48VX7hL7YByczi/NUy7AiZOxTFdeL5Rw1CqqGD1ER9y/BoVEevJyPgPfB2XHusGVbjsrf/aZA/
	Rd6rlgyUWzJDHkeyEOY+9e6tXJQMU+GNRRY534=
X-Received: by 2002:a5d:588c:0:b0:47f:eca7:ad1a with SMTP id ffacd0b85a97d-47feca7ad3fmr32925617f8f.1.1786084662881;
        Thu, 06 Aug 2026 23:37:42 -0700 (PDT)
Received: from ?IPV6:2001:67c:2fbc:1:5ff3:d0c3:bbb9:1151? ([2001:67c:2fbc:1:5ff3:d0c3:bbb9:1151])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-480021e8d50sm2630859f8f.24.2026.08.06.23.37.41
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 23:37:42 -0700 (PDT)
Message-ID: <937f09b2-cd5f-4352-90dc-dad67ef8ddf2@openvpn.net>
Date: Fri, 7 Aug 2026 08:37:39 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: pull request: fixes for ovpn 2026-08-07
To: syzbot ci <syzbot+cifb58fcbd8413e765@syzkaller.appspotmail.com>,
 andrew@lunn.ch, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 netdev@vger.kernel.org, pabeni@redhat.com, ralf@mandelbit.com,
 sd@queasysnail.net
Cc: syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <6a756ce9.01d0871a.3a0d52.003b.GAE@google.com>
Content-Language: en-US
From: Antonio Quartulli <antonio@openvpn.net>
Autocrypt: addr=antonio@openvpn.net; keydata=
 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
 ifS0+hzvnPVD9wXa9kdjO+0H
Organization: OpenVPN Inc.
In-Reply-To: <6a756ce9.01d0871a.3a0d52.003b.GAE@google.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 07/08/2026 07:28, syzbot ci wrote:
> syzbot ci has tested the following series
> 
> [v1] pull request: fixes for ovpn 2026-08-07
> https://lore.kernel.org/all/20260807002250.1817498-1-antonio@openvpn.net
> * [PATCH net 1/4] ovpn: fix NULL dereference when killing missing key
> * [PATCH net 2/4] ovpn: finish crypto callback cleanup before peer release
> * [PATCH net 3/4] ovpn: run deferred work on a module-owned workqueue
> * [PATCH net 4/4] ovpn: defer key slot crypto freeing to workqueue
> 
> and found the following issue:
> WARNING in __alloc_workqueue
> 
> Full report is available here:
> https://ci.syzbot.org/series/a46f06c7-f8d8-4053-a746-91498a46c290
> 
> ***
> 
> WARNING in __alloc_workqueue

This is indeed triggered by 3/4.

Will get this addressed and respin the series.

Thanks.
Regards,


-- 
Antonio Quartulli
OpenVPN Inc.

