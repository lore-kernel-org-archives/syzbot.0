Received: from mail-ed1-f54.google.com (mail-ed1-f54.google.com [209.85.208.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8BA0C471268
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 11:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.208.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786103704; cv=none; b=XVgRpqwiQol33YGSMIlQv9kX40uJH12csFQ6TRMN/uQC53BYZfgsmVR+JnwCZ4ip1/JndP/5CBn1cAWzGtgI9Bdn0sk3KyLCK20RblexgvwfQnKTfZ9jsVeISN46cPIT9puQBVTaSuBe7zQ4rN85BDA8PKAeyY2gN47K7fWzDkw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786103704; c=relaxed/simple;
	bh=W3KhDTimuwgisUptLxdE3P0lFgT70NS8NtJzHMxIpog=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=Cy810X+iE754KV+O9eL71j6oP71WDE04dKeOdbGJRteMsNBPbEuzOIOfE0LlH94iVOwzPLVGh0WhJDFuntcXFJ74x66bEYWZ/YxqIF+sCrYfSz1snv3MjZhx5Ujx8dsOlcuwriR5Cg7aACJ4T9jnWklLTgJoF391rAUxIsmXcY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=gfbcPlOx; arc=none smtp.client-ip=209.85.208.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="gfbcPlOx"
Received: by mail-ed1-f54.google.com with SMTP id 4fb4d7f45d1cf-6a1542cdb53so3186120a12.2
        for <syzbot@lists.linux.dev>; Fri, 07 Aug 2026 04:54:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786103695; x=1786708495; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=AjCLnnMYnIXAKd2QojkF632kR9nXx4FuPCfAi4Zg5FI=;
        b=gfbcPlOxTnrf5xmz9jfayWoyMFvm6fy0SrYiZbjXIIFRKz1THdnp1OVrUlN/8pBnkZ
         e7BNye128nWot+f5sAengqh1kdKRDgJXpyQSOyzJoAEQnTCB0pFqNwmWsUf7J5m0l7X5
         lk9VD366gp4NTVta74jbBgqH8yrO7tN+2+W2rGpky3qEiwfrfaVJJSdwHt+AiFoWwNqW
         fug8S3bTJL86WV9u0kkOJYcmHjNrff2wPvrCu2QoxS1TuB+3eajhoqYNv4Hc0sJXP9xP
         7OOUMWXAVIbWF5+DRh93+Ne+lZM9kHVeSWvovou61sDYT2eoWsjymPXvwS7dD5SvNf9d
         mI0A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786103695; x=1786708495;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=AjCLnnMYnIXAKd2QojkF632kR9nXx4FuPCfAi4Zg5FI=;
        b=mBy9d/ZwOFNnKwYojxhtPdXkOAzCaoflsi82ytxE/cGoIEJGxEctt+zyI/JR6ZHY1a
         myMU6QcmPSrUjVI1vh4Nfs5RFfFd1pKSMgbiIKu1kcR/o8FZAivsYN4Dp6rGVdgGEHVN
         Nk65ERqI67ZBPyJU29QiWQTp4mVEiXxJw1Imz6K4/FYMnZ7KRP5K98cuGMSOzK/35GXU
         ln73BvEw7Km9PWm5t8Tohf6iLYwIpM2dIgTEayfw+eP181kD1le927NXXJGpm5+ZaTaD
         IYMqsBfiEJSnJpFgsrVYcT40OBaFH0Qxkagy+xWwpNRGsSt7RFSlFnYzQDWvcG54Bq0X
         OGOg==
X-Forwarded-Encrypted: i=1; AHgh+Rr3YAgWTZaFb8+gweW+bs2EQWL4emEu6PRTPUA7944wCXml88RqujQIYIbJktYsiMmE8VM4H4o=@lists.linux.dev
X-Gm-Message-State: AOJu0YycXm3Aqz6IeeBZrWiZNfQTbFfHzwcP/lvXr2TOT+o8PMDKd/BD
	+5zODqjAU0oCzdHYY2IzwLFjIdJPCbn0jHzjt9QDks8RtjPegXCyLENW
X-Gm-Gg: AR+sD12cXKUeuFlEJGi7IXJGJTnqoiaRapaOwAX92LJM9d11+aoJd9ZD9vFQfQ5ulsj
	IvGcaQbIbp5kkjC2tCNqgHfMvGgISHC1UbeERwGRtgjFlqLwgzBXDCzrBBf5nAHA0QKVBNtIaI2
	/RkKJlUKLmJan55V5puCcPZ4FZ8nd6alS72paooftCkW01Hg2TzCJSKYlAweJmS0Zt1ZCA3yewj
	3ZP7KBLuyqJb7F0qoiq8gJ2IUSlsI+4y+2MoWRFZiIyM6gN45jTr8vFCyT+GdyRgHWxMPZUhfuE
	N6+fGpzeg4IilkywlDOQCA1V6Ss32CR+E8gHoRvpsldePSH4+5sy8PtEgoHIXKN9Rns7xrjD16V
	6wGhv8QXpR6OAxvqzZEDnJcVaFphItuhb8Gs9e1g4i4GuAUJvl1PWNeKAu1RuwPIUyAUd/R52q9
	P9awkGkn/7WMN8YtxWfD+wTpctAJvwxX78CrPRyS1rhUWMdEOq4pnvP3xB8dHyBkCmfOMKd00wg
	yH1Og+VAOUcRkrM8IU8tlEzXNbT2lr/aRIsFKcO9UIYUzJBsfj5xYfRIWNtr5aQ6dxR1OsH2RXp
	tNXh+hMMEEbvgdl6sCrRLFF7dHFDGUmLSYwknkOKiQwQuUbleB4nED0=
X-Received: by 2002:a05:6402:e93:b0:69a:928:9405 with SMTP id 4fb4d7f45d1cf-6a14f09ff2cmr11039309a12.1.1786103695297;
        Fri, 07 Aug 2026 04:54:55 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 4fb4d7f45d1cf-6a1e7cbaf69sm471408a12.13.2026.08.07.04.54.54
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 07 Aug 2026 04:54:54 -0700 (PDT)
Message-ID: <8df5c003-f28f-4fce-ad4d-9c6247d06892@gmail.com>
Date: Fri, 7 Aug 2026 13:54:53 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH net v2] ipvlan: keep lower device alive until private
 destruction
To: Jakub Kicinski <kuba@kernel.org>
Cc: netdev@vger.kernel.org, Andrew Lunn <andrew+netdev@lunn.ch>,
 "David S. Miller" <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>,
 Paolo Abeni <pabeni@redhat.com>, syzkaller-bugs@googlegroups.com,
 dskr99@gmail.com, Kees Cook <kees@kernel.org>, linux-kernel@vger.kernel.org,
 syzbot@lists.linux.dev, syzbot+5fe14f2ff4ccbace9a26@syzkaller.appspotmail.com
References: <20260803121140.261329-1-krystianmkaniewski@gmail.com>
 <20260806083834.28db4cde@kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <20260806083834.28db4cde@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

You're right. I treated the netdev reference as a guarantee that the
device was still usable, while it only keeps struct net_device
allocated. It does not guarantee that the device is still operational
after unregister has started.

Keeping the lower device referenced for longer in ipvlan is therefore
not the right solution. The caller that wants to operate on the device
needs to verify that it is still alive.

Thank you for the review and for clarifying this. I will prepare a v3
later with the fix on the caller side.

On 8/6/2026 5:38 PM, Jakub Kicinski wrote:
> On Mon,  3 Aug 2026 14:11:39 +0200 Krystian Kaniewski wrote:
>> Specifically, RXE acts as an asynchronous owner in this scenario. RXE
>> queues RDMA device removal on NETDEV_UNREGISTER, meaning it can retain a
>> reference to the ipvlan netdev after ndo_uninit has completed.
> The netdev reference only guarantees that struct net_device does not
> go away. Caller must check that the device is still alive if it is
> trying to operate on it without a guarantee that it's still live.
