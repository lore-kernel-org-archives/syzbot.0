Received: from mail-wm1-f45.google.com (mail-wm1-f45.google.com [209.85.128.45])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 270D532AAA0
	for <syzbot@lists.linux.dev>; Mon,  3 Aug 2026 11:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.45
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785757331; cv=none; b=PeFGB5QQ39d7hRTMtIEj7IKPdYbK+9b5e7NJZZnmjy0xqLwWfvbn6yDgpjTGWGFzO2ZfozbShk3gH81TB8V7znrUF8DFvDmEXG6+tIh2N9olpZ4r5DArz7p9sZ6VjRJcOtdqjscyVO2QrRJ4PHzQAU4AAgB8Bv5JQMDTUwbm0xs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785757331; c=relaxed/simple;
	bh=pJ/bggGJiY5BaVzUGnEIeCEju9b8/IsKonn/qUy4RYE=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Ga6uEpOKXXXqKFHz10JESzZ5mUQnFT9UDH/1aBtjBcB87VRTtofdTxrAGTobBn9kux7x+7dEqa3h9pPSp5zlSBA3XAutOcFZQqieB2mbiC+OMU1mwltCQDO6f6qxTxASBtrM00vVQ30FUzpUM7eBKf2O81ij2uuutYMj2t9Va7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=FXgTCRps; arc=none smtp.client-ip=209.85.128.45
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="FXgTCRps"
Received: by mail-wm1-f45.google.com with SMTP id 5b1f17b1804b1-4980fe6b3beso9129245e9.0
        for <syzbot@lists.linux.dev>; Mon, 03 Aug 2026 04:42:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785757328; x=1786362128; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=pJ/bggGJiY5BaVzUGnEIeCEju9b8/IsKonn/qUy4RYE=;
        b=FXgTCRpsXogVCRgluyydorh/GvvGs7c84ypAWmsvJ50aZFp9WRvX0XEq9Yj7xUQQN2
         YqjcA9b1wNpQzYb28kqjk7p9yT8wI63Crliw/rAyRldBde4xiYzktdHGD7+OrdOic/HZ
         TI0mHm0soLFnSGKF+CYKXutViEUqrgI3MbBiyryMLTBbatWYlcD/2OhDxATfJtzPJD/D
         LkGf6UhoEdF7xXLTZWxfC/AUWbLPHv2P8ccTkGSIwCDY55Cb74nMfurEuQFFAgmR4M2a
         eYgLIRmvnD6jkAK+d6vJdqKp67oTSALmS0EeaxyZB91gF1AEVfHqjGv3IHsuSpq/Zhiv
         Zb+w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785757328; x=1786362128;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=pJ/bggGJiY5BaVzUGnEIeCEju9b8/IsKonn/qUy4RYE=;
        b=VLjdaHG1QEUgwy9ArB2jI8cZaUOgjdphpR/KP5f/dHmWUpwcamh90WrxvlXPJQdJUG
         h3WR1aqFhxZg4xnEqWnAt0N92n5X7pnBQeWy30I9R8rz7KpI0+qy/rKZ+acuGG58BSAd
         621MWxyi0dZeUOhGK12iddWih6u2dUUG3ODEM26f/g8o23oO79aY+4awi1Yau4WeN8jn
         wXEdaZgK00ZUeuYyggMdErF0kEqcwN/etbhbniKtBaFHGOMgosawqZS7N8t342alYmbY
         +LDtKHBF9IembyXMnY6zz8N76kZRersm3/ARlW377nQu2lSxs5yHIyskNLL+BqvYG2Gq
         RNIA==
X-Forwarded-Encrypted: i=1; AHgh+RpDvdl/MCk4S+zUS9aJnIS686EaXgvFduOmTfvTa8HWHei8FAv7Oy31KmckG0UcwPefpMWOJ4k=@lists.linux.dev
X-Gm-Message-State: AOJu0YxzHBZ3FGwBCDD2C7pLeG3fFllpa0vUM3+AQK6WBP3WbPvDAqV8
	OlBEv0OwVs5GFjszTkxUW7pofOyvgiU7Ox6+QcKTaJ4Z5TBHgmngjqwY
X-Gm-Gg: AR+sD12gdv9HJCwruwScB8PTDCVbtI3MO7Vf12+xWAZZxjynpWE968Ua439GKWpCUdU
	SlAW9zqdmtgXviCoKXrMnLw6KShownp5C+QEUsbQzK1Q0BCRLR8Man+CSMZz0J+Obco1NE7r80a
	29vCX79ppYCYri0yDrk3KPBImiI97Z+qZ06jQnVMAgBm0KnrKiGyF7KDp2wjnFzbqbiJJFzQEl5
	gAIDsPK4X0Ha72QDH1z6CBBKhhiMkNEN7UnbnEUKcm4xY+B7Zbxr1V0k/XY4wX0wSJNpT3G7SqS
	1UulpPbXxbdPdZbuQlDfXKda0NNv0Nut4weXL2MLtU/o0W1YAoBwyU9rfpuvgWn44XSDVkJdn3k
	DQawPFI9Olx57Y1qgPewiRbE832V0sg5lndOEDdlrU2XrKGCuyu3mdsikCLcDLscmZdWZfND1Dl
	5XUrrYDiPFMicnD+YsE/wiwSNVrXwhZoiN1Z82TZiqNLgFn4AzMUM+1xX8Arq/fiPRoQDXzNHvc
	tKFYXfU40G3WsyUd8gEu8V25a5xk9SnY3ATfD31i8AH5WEZCkjPmjrUtW8bs+2QvVzDFPPY7Zun
	4mZaC9LxLM2afNgs7HkNNpG/kZP7qkiygNzWfu2FNNTL301qmpr1EYM=
X-Received: by 2002:a05:600c:46c3:b0:494:1f7:8057 with SMTP id 5b1f17b1804b1-4980eb8d081mr162373185e9.1.1785757328036;
        Mon, 03 Aug 2026 04:42:08 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 5b1f17b1804b1-4980819a030sm234157695e9.6.2026.08.03.04.42.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 04:42:07 -0700 (PDT)
Message-ID: <02660c18-ed71-42ae-ba28-f8887d2d885b@gmail.com>
Date: Mon, 3 Aug 2026 13:42:06 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] ipvlan: keep lower device alive until private destruction
To: Jakub Kicinski <kuba@kernel.org>, syzbot <syzbot@kernel.org>
Cc: syzkaller-bugs@googlegroups.com, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 netdev@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>, dskr99@gmail.com,
 kees@kernel.org, linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
References: <26b3176e-d9ed-4508-bde7-388deefd970d@mail.kernel.org>
 <20260730153247.2373cf7e@kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <20260730153247.2373cf7e@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Thanks, I'll rebase it onto net/main and repost it as [PATCH net v2].

On 7/31/2026 12:32 AM, Jakub Kicinski wrote:
> On Tue, 28 Jul 2026 08:40:37 +0000 (UTC) syzbot wrote:
>> Subject: [PATCH] ipvlan: keep lower device alive until private destruction
> please rebase on net/main, and repost with [PATCH net v2]
