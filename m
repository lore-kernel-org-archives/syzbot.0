Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65B0E3D7A01
	for <syzbot@lists.linux.dev>; Mon,  3 Aug 2026 13:32:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785763981; cv=pass; b=vAgcDZMVrTE8MthzS3gcwXLNSw8wmObxOat3ZRtO2HVWQqwad+33ASFT0vweW9QWqBmVS1pRaApfQrln7vswFJ/M9hz+kNSTl3YFy/Dinq7/EJh1g37uU5LuJ2JKGchCYjyQZiM7oivvMxb6Amfr6pmurnhDRVNSg3drVP8G6h0=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785763981; c=relaxed/simple;
	bh=SgX59LJ9LcHKvcTeSEmKdxDvnMa2UDzeZq8PVABpe8E=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=FIMeI3gDYDCbjli2fvn5//DJ6zEu/SA8LiqNiHD6tOjkd1PpgULBh/RHQRWapLYrtnyjZq2Rx3gFtRKm7Bw3wUFjmFp61ZTnGzV+fYxzUelIZXqS1TAtu7b//MQvYjCbvhQxkE815pKUDDUzLmKtYoQwUJ+/RZ+QAoPMuV5Je0E=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=Pk/Nxssl; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="Pk/Nxssl"
Received: by smtp.kernel.org (Postfix)
	id 256D01F00A3E; Mon,  3 Aug 2026 13:32:55 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=209.85.208.181
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1785763975;
	b=uNVXQmkqldoA+UcWb1MqPHgl8IBnN6pwWdhiMH2D7cpX5Q6CZH/dlGSFrLKxSS98eLHX
	 jqTtdN2Oiz41zLFLugNEQxIAoah/9X6qhNDp4C5WTNuikDoWJIEUfx02rD+OISUdyPyXM
	 NlclY4dfAa7vlZzTQ2w+uRpp5INc6fskHZCwofY+DNWL3dKt0yeXWL5nBalvd5rKr7lZP
	 cbf+yTr+P31UZcwpjdM3qvdwSc83JP3bv6egGVOXY7+t+KYJr8BfgY3HSpF74WUoqhura
	 7Ac/9T1oWukHbTcxsYJQ9uNI4e01EezKUJm0PbL9ZRVwSfWuOO2cl4DuJJL7gmlCRqA==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1785763975;
	h=DMARC-Filter:Received:DKIM-Signature:X-Google-DKIM-Signature:
	 X-Gm-Message-State:X-Gm-Gg:X-Received:Received:Message-ID:Date:
	 MIME-Version:User-Agent:Subject:To:Cc:References:Content-Language:
	 From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
	bh=9/IuO40b9vi1qlIswA4BahkDQm7YQ34CTFPcK/6MNnM=;
	b=IqI/sh9Yt+R9EVPm6/70QIfRt96cWXjBseRIfeFDtUH29M24h42+knDGyvJxEHQWN3oM
	 h4L/gwMmnjkQKGJFIgY/eD6RbnAUFOR/0wygadFnAYzR60Vut1vD6YAeBxeVIboUUP5zM
	 qfeEuMKE6I8NTSQtBDXw5U438JXf4kgtG7fL6f29U1LkrOPZpL+qVsvplW2g53XYZcZJI
	 e01P2Mv5zzlU5yz8MBOe+KI2k0skoG1iZkg9Bk5xTaGFbLLkAR/9QHh5vzg8gLaJQw2Fm
	 Ip3okz0iwSS0L1TUObsWpShiPNZoEnHhT2SMJjOhvhGKtUXwjBa7y/W5ufl48uLpR4w==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b="Pk/Nxssl";
	dmarc=pass header.from=gmail.com;
	spf=pass smtp.mailfrom=gmail.com;
	arc=none smtp.remote-ip=209.85.208.181
Received: from mail-lj1-f181.google.com (mail-lj1-f181.google.com [209.85.208.181])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 8790C1F00A3A
	for <syzbot@kernel.org>; Mon,  3 Aug 2026 13:32:54 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=gmail.com header.i=@gmail.com header.a=rsa-sha256 header.s=20251104 header.b=Pk/Nxssl
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 8790C1F00A3A
Authentication-Results: smtp.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=gmail.com
Received: by mail-lj1-f181.google.com with SMTP id 38308e7fff4ca-39c8dbf4f38so30455581fa.3
        for <syzbot@kernel.org>; Mon, 03 Aug 2026 06:32:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1785763973; x=1786368773; darn=kernel.org;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=9/IuO40b9vi1qlIswA4BahkDQm7YQ34CTFPcK/6MNnM=;
        b=Pk/NxsslWEp5oS2Cemi44SyVZbzopRbez0EV4uycR5+ghWsOBoQ8srNf6VR+D8KoQc
         X4TbPjmFPje3jQPYIYewOxy+GMrKVis9KFUchXK5PJnUfWS6LOSN8zTA5anVzCq2RwiA
         cv7W8eKL1Yv45MyzaqzxNexcwYXg8xvUWRtxpaUVBc2e3XfBhC2s/JkSEoM/6xwO7v4P
         Hmg4EU0AbSoNsBl8UOquRmGqkjDY9qbQuq9PupCMCHO352GndwBKrKepitKkCpFDWJdT
         kCkcyd4fMihNPtmB3JNB4E+Cevu073UPgervKotaSybfwl51oKeFl/QvDbpajHdSIaga
         raCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1785763973; x=1786368773;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=9/IuO40b9vi1qlIswA4BahkDQm7YQ34CTFPcK/6MNnM=;
        b=WjeEYe0NYTqJwyB9oj+F2QX/bm7HIMCiDk0e3sbWoTXNgoYcG55GtEYsASrnXBL8Po
         Yj7lSatZLuSMW6BnhQWEMwVdcoLSRzP2wKWJvZ8LrAqDZKDIwXwMaYSZpozmAwg+Fpwq
         j0Qu4v1FhA9uoPaA+UZ1naV7OMQqHAF1sLYm4phFVGh2kOVlxB5M70sjfPb5e7jChsy0
         avRj+GETPmza6AXIowrsRlznEcDe8nnDEe8pJSr6SU4NXd2gMAtQoUE5EqqHXuFhEaWX
         SWhLT8Bscs8LndIOwpXMU4Z4OscXP0m/L4YJaHelHtGdhK8ZamzHrUJiA5drgTAi0kFw
         UZPw==
X-Gm-Message-State: AOJu0Yx33It3XU9cIe1w+u8UHHESroSiRLqbMja52W6ExrpwRdrM21Qe
	Kajmh9znnE9jWsZO3eAkwYBAOYqbflBWcCF0LUqWfxoVR4bq+Aaf6R27khJyDkwXNfg=
X-Gm-Gg: AR+sD10ANksKhfpuINPAYse0gKP+h9WIBogCWzp/lMG7+CmubA4u4Ryx0Ur5tOz1a1u
	8l/utaRpem2mWNH6M8K5Vr+sWsl++/OzogztxpT+K0tjOThi9tQaQIBpGtn+ohJ8hFOUbaOvOWZ
	lP94OXlo0jY8qCo1UkKZn6+xj9Yuk8R0URZwKxK+zSrRaLlZFniGjM0xZ9s+RGPbOIeuIxBUrAv
	aY71KOohch80CjIreMHQ21FrJ71dB0lkqYEKgHofnQc4frfvYUPlL3m9hkUvkQo8l1MdpNab4AG
	FTFZ3IBxwZleCPllLlvakzBoqQ42imUGAYNj5qamHnIBNA2iWj0zabjFZetHZtQVthZPghRm/yr
	gArXsRjT3yp+umglNDqqSmw+cH5AxkDo1FbAMReiaf6/oCCZt6O6BXftsGaP8mTmKsA/9bJfuDY
	QDRzeofh/UX9RYR1UEi2qTGmBNUa6IdZzzvC1ri9KKGS5SS1R1lcdTMFQYfPo4RrY0YJOUYGsLd
	Ey7zqnVOIxjGyilZXU3xHVayzfatSlKoRcd4+0w5lFYdo1wclqjufpNq3lHHtdybe5tfEyrJdS9
	iBKJSelaj1Mp4xYBMudVi6UW3TluaZDF+IT5K9oxtF7LS50BQ+30qAM=
X-Received: by 2002:a05:651c:1145:b0:39c:63bb:cbd6 with SMTP id 38308e7fff4ca-39f86150e25mr19634341fa.1.1785763972303;
        Mon, 03 Aug 2026 06:32:52 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id 38308e7fff4ca-39f810f87ebsm11701471fa.16.2026.08.03.06.32.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 03 Aug 2026 06:32:51 -0700 (PDT)
Message-ID: <e27a10e5-9718-47c2-b50e-26c35409b65f@gmail.com>
Date: Mon, 3 Aug 2026 15:32:51 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC] wifi: mac80211: prevent destroying non-TDLS stations
 in TDLS operations
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <7f0c8fa8-559d-4fdf-989f-c81259e4e719@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <7f0c8fa8-559d-4fdf-989f-c81259e4e719@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Preserve the TDLS-peer validation in both touched paths. The verified bug is
that NL80211_TDLS_DISABLE_LINK accepts the associated AP's address and 
blindly
destroys its non-TDLS station entry; later AP probing cannot find that 
station
and triggers the reported !sta warning. The delayed setup cleanup has 
the same
destructive risk because setup currently records any existing station 
address,
not necessarily a TDLS peer.

Correct the delayed-work hunk so it does not ignore the return value of
__sta_info_destroy(), which is declared __must_check and causes an
-Wunused-result compiler warning. The smallest correction is to retain the
new sta_info_get() plus sta->sta.tdls validation, but call the existing
sta_info_destroy_addr(sdata, sdata->u.mgd.tdls_peer) wrapper after that 
check.
Alternatively, explicitly consume and handle the internal helper's result.

Keep the early missing/non-TDLS rejection in NL80211_TDLS_DISABLE_LINK, the
queue flushing and recalculation order for valid TDLS peers, and the 
existing
commit message and tags. Do not add unrelated cleanup or broaden the change.

On 8/2/2026 11:52 PM, syzbot wrote:
> When userspace sends a NL80211_CMD_TDLS_OPER command with the
> NL80211_TDLS_DISABLE_LINK operation, the request is handled by
> ieee80211_tdls_oper(). The code for this operation directly calls
> sta_info_destroy_addr() to destroy the station entry associated with the
> provided MAC address. Unlike the NL80211_TDLS_ENABLE_LINK case, which
> correctly verifies that the target station exists and is actually a TDLS
> peer, the disable link path blindly destroys whatever station matches the
> MAC address.
>
> If the provided MAC address is the AP's MAC address, this causes the AP's
> station entry to be destroyed while the interface is still associated.
> Later, when the driver attempts to send a probe request to the AP, it looks
> up the AP's station entry, which returns NULL, triggering a warning in
> ieee80211_mgd_probe_ap_send():
>
> WARNING: net/mac80211/mlme.c:4898 at
> ieee80211_mgd_probe_ap_send+0x497/0x560 net/mac80211/mlme.c:4898
> RIP: 0010:ieee80211_mgd_probe_ap_send+0x497/0x560 net/mac80211/mlme.c:4898
> Call Trace:
>   <TASK>
>   cfg80211_wiphy_work+0x29e/0x420 net/wireless/core.c:538
>   process_one_work kernel/workqueue.c:3322 [inline]
>   process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
>   worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
>   kthread+0x388/0x470 kernel/kthread.c:436
>   ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
>   ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
>   </TASK>
>
> A similar issue exists in ieee80211_tdls_peer_del_work() which is queued by
> ieee80211_tdls_mgmt_setup(). If a TDLS setup request is sent with the AP's
> MAC address, the AP's station entry will be destroyed when the setup
> timeout expires.
>
> Fix this by explicitly verifying that the station exists and is a TDLS peer
> (sta->sta.tdls == true) before destroying it in both ieee80211_tdls_oper()
> and ieee80211_tdls_peer_del_work().
>
> Fixes: dfe018bf9953 ("mac80211: handle TDLS high-level commands and frames")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+a59b5291776979816910@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=a59b5291776979816910
> Link: https://syzkaller.appspot.com/ai_job?id=52e47481-fb24-46ec-8402-1f14cf87081f
> To: "Johannes Berg" <johannes@sipsolutions.net>
> To: <linux-wireless@vger.kernel.org>
> To: "Arik Nemtsov" <arik@wizery.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
> index ffd575a8d..24297552f 100644
> --- a/net/mac80211/tdls.c
> +++ b/net/mac80211/tdls.c
> @@ -33,8 +33,12 @@ void ieee80211_tdls_peer_del_work(struct wiphy *wiphy, struct wiphy_work *wk)
>   	lockdep_assert_wiphy(local->hw.wiphy);
>   
>   	if (!is_zero_ether_addr(sdata->u.mgd.tdls_peer)) {
> +		struct sta_info *sta;
> +
>   		tdls_dbg(sdata, "TDLS del peer %pM\n", sdata->u.mgd.tdls_peer);
> -		sta_info_destroy_addr(sdata, sdata->u.mgd.tdls_peer);
> +		sta = sta_info_get(sdata, sdata->u.mgd.tdls_peer);
> +		if (sta && sta->sta.tdls)
> +			__sta_info_destroy(sta);
>   		eth_zero_addr(sdata->u.mgd.tdls_peer);
>   	}
>   }
> @@ -1462,6 +1466,10 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
>   			     !ether_addr_equal(sdata->u.mgd.tdls_peer, peer));
>   		break;
>   	case NL80211_TDLS_DISABLE_LINK:
> +		sta = sta_info_get(sdata, peer);
> +		if (!sta || !sta->sta.tdls)
> +			return -ENOLINK;
> +
>   		/*
>   		 * The teardown message in ieee80211_tdls_mgmt_teardown() was
>   		 * created while the queues were stopped, so it might still be
> @@ -1476,7 +1484,7 @@ int ieee80211_tdls_oper(struct wiphy *wiphy, struct net_device *dev,
>   		/* flush a potentially queued teardown packet */
>   		ieee80211_flush_queues(local, sdata, false);
>   
> -		ret = sta_info_destroy_addr(sdata, peer);
> +		ret = __sta_info_destroy(sta);
>   
>   		iee80211_tdls_recalc_ht_protection(sdata, NULL);
>   
>
>
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
