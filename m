Received: from mail-oi2-f11.google.com (mail-oi2-f11.google.com [74.125.231.203])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69B062C11DE
	for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 15:04:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=74.125.231.203
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786979053; cv=none; b=euWHg5o2IM5pVUMJ0Z2LllA2VQsGijgguN98DBJjVZ+zuZDP/+lNbLOPzd5Q2Q3fCcgM0AOlLsVOPxtEcq0zLROdB4uQ8fDH7W9S+7IzaqQnm6nElsOmvt5duHxaqakPVTI+rTFO6cA/t7FsCAhkrJQku8olEi87RS4a2kN/EzI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786979053; c=relaxed/simple;
	bh=Ur+cKiVbAh3ZsrGizOKH+9+i3VfuiVrSQMhUYBEr/Ao=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=RfDeKNigH64RqT/9XVjA04pKdofCNem3Y90kilxPK842jfUzMy9wh4j3SfmlaNUYlCXqARSEH24NC6/JC4YFGgvIOlLPQsOFx8n3MG5I3ookyzHdDni8VRoxLZ1tYnycAiENxtPuWVtP7G5cHtNlfkxbIoQBrZHrR6CKfOnVFYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk; spf=pass smtp.mailfrom=kernel.dk; dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b=m/c0mAFr; arc=none smtp.client-ip=74.125.231.203
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=kernel.dk
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=kernel.dk
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel-dk.20251104.gappssmtp.com header.i=@kernel-dk.20251104.gappssmtp.com header.b="m/c0mAFr"
Received: by mail-oi2-f11.google.com with SMTP id 5614622812f47-4b25c60f07cso893124b6e.1
        for <syzbot@lists.linux.dev>; Mon, 17 Aug 2026 08:04:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kernel-dk.20251104.gappssmtp.com; s=20251104; t=1786979049; x=1787583849; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:from:to:cc:subject:date:message-id:reply-to:content-type;
        bh=hzh00wSs4akcYyh6M7Ta6jCsY96mvygh9fJXvzCpDIs=;
        b=m/c0mAFraLCxl1JUd2Hn8suEi++m9LUFTHoAA3WXfV/QDMxMqiJoOr59P8T0h6P6SB
         Us8DtgYHk6gVHSDvoHYEw2adT0C4Bjo5Uf+CIQmvZmW5NWWT2wudEYQqHceKdO72t5Fy
         oa9mtfUaWRVQAWtRH+LL+8GL9By1ESrPBjYpY3nRlixuC79c/GuPow0cbLK15GL0MwF7
         F3HQywJZ/R69eLXcwAweYROXighnu2lDbC7BrQqfIuurgETFO5KoSYknpRnm2PqQDk3O
         IEWvv6o3K1sWpv6Iitbhg9f8D10bnoNd0kNMrxpSrlwDbzUoo7frdmB0u9c7tysHK+iz
         lX/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786979049; x=1787583849;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:to:subject:user-agent:mime-version:date
         :message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=hzh00wSs4akcYyh6M7Ta6jCsY96mvygh9fJXvzCpDIs=;
        b=EqBMkjBRglBCfRyuZX0X+4D/HwHiOJb+jZOdxacdcsWtmFRG4eZhFoXly6q/98I3/z
         yHYsEL7rjlQQE8E/BWW9TYQZBFR5qqPw3B6EljsR0WVDAicJPCGhEyn51K6ju3+2j9Gs
         Ztp/HpONl6Lf8vBq8ARtatKO+LxVdh3u0biDswz/NriNjQwk/YZhoUQ5ityivIL9Pjav
         oA+318BK13Zq7+/mmHb1njEeNwUcnS0OLVG2qNh5eoLS/dkdkzIhkcJqat8useXK1/qZ
         ophhq1Cda57b3JiLIS6eDK/0ttn6uKzXuf1hDdq3IKZc/0EEt3rwyV/30PJCajNjjVPN
         787w==
X-Forwarded-Encrypted: i=1; AHgh+Ro36ErDfKwYWdYC6HdNt3ss69meQTFxaLmts5K/sAvCIa/zF6UF/REN25njhfVKmV7o0p93Yqo=@lists.linux.dev
X-Gm-Message-State: AOJu0Yy2FxdUUKFM7oAIwGvINzGTn/332ti4v2ukcz58wwsp2m4qvkER
	ajoofkT2XOr6UX8BzAsg8pt2lLXYP7tX8vtMhObHR010SbbRfdvJfxWSEIqWazLhiUg=
X-Gm-Gg: AR+sD12VcLsIEfZB6x/i7zE/8et+CdyATw9iW23EN96TpTJkAwyGCbBBTw6WiH8UgGK
	1xtroK4X4NhabF1KQ4LbmOEnPS+Hiqp+y6PyE4AxeebY8H683kIzqtwlc++B22xVHf7O7L0Ameq
	PGjD0LM/i+bYXyTrWzgFPD0n1OxyEWXjx4nQKFIAZXikIsvT1Yq9uetVU/woRgANaEK0PdNj+4v
	92v+MDvYAOKquFLjlbRocywHqRaYDpz7p+tc9sVFmP2GdKizUEvFkiMyTeNeaRbZ0yaXKR4Abju
	ZN8WCysMUdjD/f73xDxorVf85l5J/8NagE5udzLLBlNol5kkQ0EtY1G/0Yi+UQFnR9D4z/3fWN5
	EYHaOiMbK19/kMPB4mf30HGkcVGaeFru5EzOp1bpmYAyE6+Zb4fY00iPQcO4+Pan/KjplE6f6yE
	B1F0mTpcsWargLFYyfQihkGYRhsQFhu+7VWo7LeKHw4oJ06Fw7riCmItqJznJMqSuOMaA6wv28y
	ymV1YBR9RNHHbtHoHzCVteTSRsv+jeDgwTzAlWG73vCuQ4=
X-Received: by 2002:a05:6808:238b:b0:48b:1e49:24a8 with SMTP id 5614622812f47-4b241cbe2e6mr24394079b6e.11.1786979049030;
        Mon, 17 Aug 2026 08:04:09 -0700 (PDT)
Received: from [192.168.1.150] ([198.8.77.157])
        by smtp.gmail.com with ESMTPSA id 5614622812f47-4b290a3d048sm1165264b6e.1.2026.08.17.08.04.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 17 Aug 2026 08:04:08 -0700 (PDT)
Message-ID: <7c6ce54c-ec12-4754-a36e-d5550f8337b0@kernel.dk>
Date: Mon, 17 Aug 2026 09:04:06 -0600
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [syzbot] [usb?] KASAN: slab-use-after-free Read in ep_open
To: syzbot <syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com>,
 asml.silence@gmail.com, brauner@kernel.org, gregkh@linuxfoundation.org,
 io-uring@vger.kernel.org, jack@suse.cz, kartikey406@gmail.com,
 kees@kernel.org, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
 mjguzik@gmail.com, nogikh@google.com, stern@rowland.harvard.edu,
 syzbot@kernel.org, syzbot@lists.linux.dev, syzkaller-bugs@googlegroups.com,
 syzkaller-upstream-moderation@googlegroups.com, torvalds@ppc970.osdl.org,
 viro@zeniv.linux.org.uk
References: <6a830fab.dbb3a75c.20434b.005d.GAE@google.com>
Content-Language: en-US
From: Jens Axboe <axboe@kernel.dk>
In-Reply-To: <6a830fab.dbb3a75c.20434b.005d.GAE@google.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 8/17/26 7:42 AM, syzbot wrote:
> syzbot has bisected this issue to:
> 
> commit aa00f67adc2c0d6439f81b5a81ff181377c47a7e
> Author: Jens Axboe <axboe@kernel.dk>
> Date:   Tue Oct 22 19:47:00 2024 +0000
> 
>     io_uring: add support for fixed wait regions
> 
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=10e60679580000
> start commit:   9a143525f62b Merge tag 'ata-7.2-rc7' of git://git.kernel.o..
> git tree:       upstream
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=12e60679580000
> console output: https://syzkaller.appspot.com/x/log.txt?x=14e60679580000
> kernel config:  https://syzkaller.appspot.com/x/.config?x=c44651ea7dd2f307
> dashboard link: https://syzkaller.appspot.com/bug?extid=df9e891bf8ea586f846b
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=120defb9580000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=16323fb9580000
> 
> Reported-by: syzbot+df9e891bf8ea586f846b@syzkaller.appspotmail.com
> Fixes: aa00f67adc2c ("io_uring: add support for fixed wait regions")

That looks like nonsense, I strongly suspect it's a race and hence your
bisection ends up being mostly useless as it sends you in random directions.

-- 
Jens Axboe

