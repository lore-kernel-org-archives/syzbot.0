Received: from mail-wr1-f41.google.com (mail-wr1-f41.google.com [209.85.221.41])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 93B8C3A16B8
	for <syzbot@lists.linux.dev>; Sat,  8 Aug 2026 19:43:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.221.41
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786218238; cv=none; b=dYfo4JvT+SmteFBpgMnudUxIzli+9X//59+TYxqObzZEvCXwCY8ySWrjjfEIdVFhfHa2iMIGB9k8I5zozcatSQRmuB4XFUyXk78BSJSZLzIo1CbMCIVxZHcmb7u7euenEq88V6k42jjBXfVPFSEqkDEPkT8GGDn7EI82yey+BWA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786218238; c=relaxed/simple;
	bh=xjuAQz7VSBrZUXr4Qim7eaCsxevzN5sk4XPZCmcgkCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=MJyAVu7QWnU1EhgWmvCJ45wwG0WP0DT3A1dZCprwa8yBI9qrqkRnkskJZlt58yT/99cY9CpVAzTRG5cQ6uUc7lwV6fOKMghSTWiJEE1X7D9WMxo8FmdPlfirNCSnoTRK9qKNeD93NGI/6BBnMKPgGnU5eF4wNRmPF8khlwUFSbE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvpn.net; spf=pass smtp.mailfrom=openvpn.com; dkim=pass (2048-bit key) header.d=openvpn.net header.i=@openvpn.net header.b=gRNDX3BJ; arc=none smtp.client-ip=209.85.221.41
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=openvpn.net
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=openvpn.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=openvpn.net header.i=@openvpn.net header.b="gRNDX3BJ"
Received: by mail-wr1-f41.google.com with SMTP id ffacd0b85a97d-47de0093c42so410442f8f.3
        for <syzbot@lists.linux.dev>; Sat, 08 Aug 2026 12:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=openvpn.net; s=google; t=1786218235; x=1786823035; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :autocrypt:from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:from:to:cc:subject:date:message-id
         :reply-to:content-type;
        bh=reh0WLx5n9bqEjEOwxCRA1XODyRksj/VupCL85M155A=;
        b=gRNDX3BJPLU4U1bDjwhHLIptTwQ3PuDbbKQ3o6G+EnPtKVGJ8qcquYwDfjFTTKjKA9
         5TfEG/0ztEz8wJyIKzOY1qJIo+dvggTTgwyXamSCmKC24L9om0bh+lHS1IlWYYoY9g0q
         7J423to24bJOgUfWay1fLJS56e/HR930F7kUC1fMbQBCJ/HB9Esao9X4MbEAftmb5hMM
         L1hfPKWWxem7xxjKvP1N1axmsykrqzx4wwM9EenedqNw3aBrgvAZyctBi506Lyz9TlHI
         q9wQhX4LD4d6vk29fepaAtLg+umPop/8mK+sZsmPwKj9vKCU6mSHb5oLfMF8FnrEHbX+
         vqXg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786218235; x=1786823035;
        h=content-transfer-encoding:content-type:in-reply-to:organization
         :autocrypt:from:content-language:references:cc:to:subject:user-agent
         :mime-version:date:message-id:x-gm-gg:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to:content-type;
        bh=reh0WLx5n9bqEjEOwxCRA1XODyRksj/VupCL85M155A=;
        b=myRRdGy/AlWBXnzqkhtzc5fDzXnasynqt0hONNJozq/4P3M1zrIOyWBl7avWlA0GkY
         2WD5k+inz9S0vfyIgdQ1yV5pNsPe5SRXqVhd4KVtWHsmltPJ8eHQZ3PtoWBA2Sm9C3zv
         lsm6lnreA9dzIsZsd3K583CSwflMLiZmA2a8xJrfovXy99ZyIqnkDqOhTWGh4oefmvgr
         JI/pP3lEmQkogJjxDCJCqxW+85AWBOx1BL72PiUlVyuVh9D2kaIGwR3uYHR4iTPH6NPm
         E2aJPsHoGc+iowLes0dyhntR200dwCIrABHnRrQrwnWYTfNcMQGbLY3Y9PIQ7Y+cMGgB
         nf7g==
X-Forwarded-Encrypted: i=1; AHgh+Rotc9SzbxIEUUbIGOoOjWTD7srf0nUMdYVKuKXYH0E3UlaWOMmIJWqysQjr9psrcbUkWFwAFwA=@lists.linux.dev
X-Gm-Message-State: AOJu0Yw6m+/axXGsYbbqkFctPKGfM13PZFCkEG2Yh8O8tLT4i4RE0nzY
	9UnXidBaMFgxDlqRBo7ZYMwQu4z+U0ipqcYuRELub15xozVV8J2E8c9U6PUn1zAZ7PMKfZLztiM
	cckzZfIS9q41932eXCH2WiglKXqtp0chW/l2Ifnltz41TMA+4M0s=
X-Gm-Gg: AR+sD139YyffDBoiOVltguO4OG63xngrToFj7RYRzJmMDzabe5ZMW908VXzgklje0Dy
	kkh5qoxKqWZcHVXQJKdhqXb+LNTs2EMkzPBfIRcYf68CJKPApj2A3VIJsUbdsAYR58BG4uh0L2f
	T2fjnax7ff8YEw5jySR2TQxadaXrsarfZVNbzPTNvY+9DJZg53q8fZ4cgDcyECPL7R9TNYEGz85
	9UMqYdEno/KH5fRAFMwbDJ35o9QNj34YoAXYKwZnhSSbBoPtCZltF1dzJbVfrLO9CNs7oixuU13
	ozEgqDaOns/Wlu7j+gdmv4uFRHhjoJ/f6jtIE+uflhvuzQDgB4P70SXO0SsCQFXt73WUM5PA5p7
	rZVsRZmT5XNyG6Nw6D5Z3471A1CmsxcZL+9pcayXUpJ8GLNWFoND676Xan9Z5UEP+nX84Q++wh/
	G6uMAjR8ShekGCquQlZcff/mnLEKiHgfZz2EOW6AQYdyPz4W5GbT6LyvzG7Cghm5g3ULlvxZvZL
	WfhW+xdVOWwix3vy+pzlztesBwfk/eAUAFNuA==
X-Received: by 2002:a05:6000:4021:b0:47f:9176:da23 with SMTP id ffacd0b85a97d-48130c04453mr12526791f8f.0.1786218234829;
        Sat, 08 Aug 2026 12:43:54 -0700 (PDT)
Received: from ?IPV6:2001:67c:2fbc:1:7b3e:3878:d9a3:4ff0? ([2001:67c:2fbc:1:7b3e:3878:d9a3:4ff0])
        by smtp.gmail.com with ESMTPSA id ffacd0b85a97d-48002145839sm16946528f8f.7.2026.08.08.12.43.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 Aug 2026 12:43:54 -0700 (PDT)
Message-ID: <30dff1e5-cf28-4a42-9cbe-ffb7319c33d1@openvpn.net>
Date: Sat, 8 Aug 2026 21:43:52 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot ci] Re: pull request: fixes for ovpn 2026-08-07
To: Jakub Kicinski <kuba@kernel.org>
Cc: syzbot ci <syzbot+cifb58fcbd8413e765@syzkaller.appspotmail.com>,
 andrew@lunn.ch, davem@davemloft.net, edumazet@google.com,
 netdev@vger.kernel.org, pabeni@redhat.com, ralf@mandelbit.com,
 sd@queasysnail.net, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com
References: <6a756ce9.01d0871a.3a0d52.003b.GAE@google.com>
 <937f09b2-cd5f-4352-90dc-dad67ef8ddf2@openvpn.net>
 <20260807153529.79fdd152@kernel.org>
Content-Language: en-US
From: Antonio Quartulli <antonio@openvpn.net>
Autocrypt: addr=antonio@openvpn.net; keydata=
 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
 ifS0+hzvnPVD9wXa9kdjO+0H
Organization: OpenVPN Inc.
In-Reply-To: <20260807153529.79fdd152@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 08/08/2026 00:35, Jakub Kicinski wrote:
> On Fri, 7 Aug 2026 08:37:39 +0200 Antonio Quartulli wrote:
>> Will get this addressed and respin the series.
> 
> This gets triggered in your own selftests.
> You should probably take a hard look at your CI setup?

Yeah, sorry - I must have mixed it up with some other unrelated warning 
that shows up during my VM test.

Will make sure to double check them all next time.

Regards,

-- 
Antonio Quartulli
OpenVPN Inc.

