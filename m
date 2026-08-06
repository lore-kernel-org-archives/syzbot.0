Received: from mail-ej1-f54.google.com (mail-ej1-f54.google.com [209.85.218.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E3AF13DC850
	for <syzbot@lists.linux.dev>; Thu,  6 Aug 2026 07:44:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.218.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786002254; cv=none; b=qtZqKS9eRwosOxmnq2Ze88TVRDNT5VIl3LweuJ3bFRv5Df2bqohVlq7aFXZwshheG6XtfURQisATWo9S18nLRvMk1P6ZowGwnNoQE3D/meKygj2IGzkRlwCfh7+z4L99V1lC36meYF+EfD2WjN9s/obGelU6Kx4zh+ZWaOR/dg8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786002254; c=relaxed/simple;
	bh=X4mOdQPIkrMFDz54/raY75j05sT6gAXTm2/cpCmiCMM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=XvcIR1+efrYcCMd1NNz5m5uVUpTXHFlwVd38vmUoSNAC9RBA8ov8jFfOY1l8I31cxESYBACemQe8sjvxiVVx8ZIZs7kwQELCRRlGQ12dbV8ex04QvIe/H9MSSfr6CPQh6NLcf1JLxGfImR9zluNC7PIwAiI4YX0FH0VCNz7zHQM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com; spf=pass smtp.mailfrom=gmail.com; dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b=B+Zuq3iN; arc=none smtp.client-ip=209.85.218.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=gmail.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=gmail.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="B+Zuq3iN"
Received: by mail-ej1-f54.google.com with SMTP id a640c23a62f3a-c15e2dab83eso300296566b.1
        for <syzbot@lists.linux.dev>; Thu, 06 Aug 2026 00:44:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20251104; t=1786002251; x=1786607051; darn=lists.linux.dev;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:from:to:cc:subject:date:message-id:reply-to
         :content-type;
        bh=sUNtDAwGhDbK3PPEafOD24J2J4eRQT7RT5oqh1vqg8U=;
        b=B+Zuq3iNzP3rNyqhJAPd1nr1XCJYPMeVYsG9QdsViw6en9HmdjKtM6+SQNfiHHMmxr
         DB05hnbQOHyg/bLA4WkSWFHg1J1jXdWlxRYBJZt9vNXYe/kYmsvd747GWPynLBO4saH7
         UMbiQcZuDL5lTjlsT2cfjCJJhPJEN8/H0o5eewwRsHBgILDEaiQpOaMhXgE9QEmUEFZO
         9dZQSxBn9EXIQ9CLJ4xXuyurqGO1fBg/rZ1IFqQwQeJCBLjpxlPx1Fcfe20fT+Z9PO4z
         p3HyovGFvEmqdWYB/x60+aK3q5/SdeFyW43qnN1MWGCZZFlP6hcEUVN+4idP7fswJV/J
         rmqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20251104; t=1786002251; x=1786607051;
        h=content-transfer-encoding:content-type:in-reply-to:from
         :content-language:references:cc:to:subject:user-agent:mime-version
         :date:message-id:x-gm-gg:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to:content-type;
        bh=sUNtDAwGhDbK3PPEafOD24J2J4eRQT7RT5oqh1vqg8U=;
        b=SfpxjdMgMeqK7qZMXuEOIPL4zjaRV4Yv4+EWzQAlva4TllLKAyPZXko7KSc+arQIqC
         IadyMCcl/hHCkzdSjyGRd9vE1gRb209vg4omVmkZ/zhVWNM07kyz+VXypFhIJkW90ExZ
         q65XOLN0INaOAtEq/sZjurIIDHjFauaMo+n5aIZ0FgaENdVETZMVPARXAQb0efIT8Qxp
         0jPbcV0Q8giOjzviKqLBtQdapOnRLoOtbK/9ZFYcbazNbHCQlG6qFZx7xlvy5CMM2KH5
         j2NBs5FL97XmzXFBLJAqy117fW5DkutrqDCF6K+bJhpwGuL6cfd80+CTlcgNNcaCOZbD
         obeA==
X-Gm-Message-State: AOJu0YxwQp82l76o35AJ9C1kf2mP4hKym9a1oc5huD5rJMs9d6Eq7MtL
	9SfKrtldfGSs75ewn9DXEAEP5A5ehygm+to2yY/iFXfCwWqi2zP2bpuo
X-Gm-Gg: AR+sD11O2266nVr/kYAneDRYB6GcdEk7z2ELdA9I+QrVMh9ttv7f8jzndOZWTq6SwWd
	8e4srv/j3eLwerBFMUWUBZM91hRZ68f3cWCKSb7iSfwc5ZueQXCr0pmE5w5AQk3pW20F7uhcX11
	qMkYJmcxiT1LlG5GTWk5f8N35rwG7h/db0KtxEgXeghDydSrr9w1Xd6CR6x2WOfbeNqiyg3QTGq
	EubBJxVx6XvsfS3lcB9dHfedh0JPuR+nLuZ90rWG5KUv3qXy/jKa7XsV7e/R9mFh0vwlyysTXgp
	NlFhSETJqTOlRz9IJGQHlve4eU/FmcjJZtERVWi0zxnU7CVOJDBaeLQnE1kxwBymmmFM0ix9tnZ
	H3ijaT9Q2t2fHheLaOtQF5gcwSL3TY5AQV6SzinPlR4EUw0OVCqXXekLQMNuG/OcDScSY2mUqRN
	cjL6IWHwZywHcW/tqJ9aOYA7UHY4ZpiPsiriM+O7CLeo07hFmqSsekT/kZEIMAcn54tiWPVLPHE
	I3cld7EwsVN6hdCOTb1Nk1wTzDNr3McCHvLCTAJy6f3QFXHW+wKHgl/8rm1uf4l+WbjPTtygA7H
	A9NTtnZIFKr7lGS3m67MuFPCBeGwNMotf4T/3ulnWE0hdZCXxu0ZNE0=
X-Received: by 2002:a17:907:c04:b0:c16:75cc:33a9 with SMTP id a640c23a62f3a-c2039c38f30mr598206066b.20.1786002250600;
        Thu, 06 Aug 2026 00:44:10 -0700 (PDT)
Received: from [192.168.100.51] (87-205-15-91.static.ip.netia.com.pl. [87.205.15.91])
        by smtp.gmail.com with ESMTPSA id a640c23a62f3a-c204dbeb751sm139765666b.9.2026.08.06.00.44.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 06 Aug 2026 00:44:10 -0700 (PDT)
Message-ID: <8d67cbe4-aae9-470c-9df5-5ff84171d87a@gmail.com>
Date: Thu, 6 Aug 2026 09:44:09 +0200
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH RFC v2] wifi: mac80211: prevent destroying non-TDLS
 stations in TDLS operations
To: syzbot <syzbot@kernel.org>, syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
References: <1b40a6ad-58b6-4111-b352-c82aaaa7d02c@mail.kernel.org>
Content-Language: en-US
From: Krystian Kaniewski <krystianmkaniewski@gmail.com>
In-Reply-To: <1b40a6ad-58b6-4111-b352-c82aaaa7d02c@mail.kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

#syz upstream

On 8/3/2026 5:36 PM, syzbot wrote:
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
> Link: https://syzkaller.appspot.com/ai_job?id=986e342d-a720-47ab-84bf-e8be0e8b70e5
> To: "Johannes Berg" <johannes@sipsolutions.net>
> To: <linux-wireless@vger.kernel.org>
> To: "Arik Nemtsov" <arik@wizery.com>
> Cc: <linux-kernel@vger.kernel.org>
>
> ---
> v2:
> - In ieee80211_tdls_peer_del_work(), use sta_info_destroy_addr() instead of __sta_info_destroy() to destroy the station.
>
> v1:
> https://lore.kernel.org/all/7f0c8fa8-559d-4fdf-989f-c81259e4e719@mail.kernel.org/T/
> ---
> diff --git a/net/mac80211/tdls.c b/net/mac80211/tdls.c
> index ffd575a8d..eef1dde1c 100644
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
> +			sta_info_destroy_addr(sdata, sdata->u.mgd.tdls_peer);
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
