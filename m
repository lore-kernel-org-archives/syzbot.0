Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257AB2D94AF
	for <syzbot@lists.linux.dev>; Thu, 16 Jul 2026 06:46:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784184416; cv=pass; b=Ewsc/51f0+tHLod5IGIA7BM96lqqMNy8TO5xRPiiZtrQZzjo0L5PMoM8e8tXiDYJace86N75AkE3yY1amzxrkhONJbF8BKT66eJvEdv0dUytgb77WSNxol59CPfZG9t7DXnPsT2PL2ZzupV5kMfO4hjEI8rFIQIeo2CRS8th+3Y=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784184416; c=relaxed/simple;
	bh=lCVjUsQZ6hyEuUZy94S1LYBijQutIk5zw/iN9vKOX3I=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=Xn/YFvbKZ7NBtyoCSioVSArCt/Rm5xTBs+Px5XLu2MMSlx2uBdcSiG4YtNG5rPMop1IENE605ad7jNaJ/r8fvIj3V/ywLvSujpvz2AaZONICjg8x+1xRFgxRnu+zNsY8kG1utatRHU6Ku85xjNLJi9OxPxE7RqdeBRrJLheNpqA=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=U/yGsEiB; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="U/yGsEiB"
Received: by smtp.kernel.org (Postfix)
	id C00931F00A3A; Thu, 16 Jul 2026 06:46:53 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.49
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1784184413;
	b=kiUJWGtgyG42pmsMP+p9Yo+UcumWxUcQgGaEVaRXOFA/wUHBlccq4XiEN9GPyMZjEtKD
	 drkvMMazjmxgSgI+EGCq6o2ipNVVhwGzw5M9ghCZLzxwgGKQ0u8Eip7sNEAaABhZGUAqH
	 DSXtURZAMVeWYO9OjVZxTqbJ57gYcmEyRF6PwRYy06cPB42eiB3osEGT+V8n9+gZrXbEO
	 3yiWRJtpfs9P+f/T1PZt9QoTSPz1AVtaUosL+r+zFi3OJ5SmXdSnn7SeHIy2JkSo2+RKu
	 11GRkJwoi6KBAAH0UPexXS/cHtugFtF5IhT9n11MktZYQw1dzSj4bt62aYNV3+ILlnQ==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1784184413;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=0PRFX55YmfS74cB/UZCL1bQjRbboU2mh8081fKesDlw=;
	b=EPXQndpyS4Cev9h8Xt8+wlOtxcuObTomV3sQZnQTP2HU/HSOBsAgLKTDA1HNrybiq+NU
	 /3mlVcxbJzgPnLb8GbviZZtbmIV8bUZmoaHPE1PZAHhu5FD7khNmcSAIxlCG3OPhXki+T
	 82QCM1CjieyPcKap54L6HiISoFeNYVxP2HTeILnqARSc1JchbR+b6eUuiKiLtfXtMvvPA
	 CquMU7ruE93dEt6JnP+Y6v+paLG7MbmDthXhmVPf2eosl8TV4hg28Twni+Dm+adN9ukvl
	 5ae73M+/8FPbHv4Oi1eigDmUvkIRcCFsyQ6qw1CqwPLfvPFtonDCtYIPgaEEMNTbfrw==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b="U/yGsEiB";
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.49
Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id C84A51F000E9
	for <syzbot@kernel.org>; Thu, 16 Jul 2026 06:46:51 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=U/yGsEiB
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org C84A51F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu, 16 Jul 2026 08:46:48 +0200 (CEST)
Date: Thu, 16 Jul 2026 08:46:46 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] wifi: mac80211: reject station association if AP
 is not started
Message-ID: <alh-VknYSmSMXeKw@nr200>
References: <79cbf145-6652-4e15-be67-f7974ebc29cb@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <79cbf145-6652-4e15-be67-f7974ebc29cb@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1784184409; bh=0PRFX55YmfS74cB/UZCL1bQjRbboU2mh8081fKesDlw=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=U/yGsEiBFpL/uOiD3Ex1N24gln5/K7fMpsWNskWBqT+GucpMTy13qWNBmUepQ2agM
	 RofzQNbOh4lfShTfQK9rNWcrBIDcizYDKOjsMn3ruMEr1RzPvf/6GKhr5fvGvNTU8T
	 +70cStdViVSx61Ccl9fXFisb0m/XePiik9MbbNEk=

On lip 15, 2026 16:56, 'syzbot' via syzkaller-upstream-moderation wrote:
> If an interface is changed to AP mode but not started, its channel context
> configuration (chanctx_conf) remains NULL. If a station is then added to
> this interface, the kernel may automatically set the
> NL80211_STA_FLAG_ASSOCIATED flag for compatibility with older userspace
> applications.
> 
> When this flag is set, sta_apply_auth_flags() attempts to initialize rate
> control for the station by calling rate_control_rate_init_all_links(). This
> eventually leads to rate_control_rate_init(), which dereferences the NULL
> chanctx_conf, triggering a WARN_ON:
> 
> WARNING: net/mac80211/rate.c:51 at rate_control_rate_init+0x5a6/0x630
> ...
> Call Trace:
>  <TASK>
>  rate_control_rate_init_all_links+0xf4/0x190 net/mac80211/rate.c:84
>  sta_apply_auth_flags+0x1bc/0x430 net/mac80211/cfg.c:2152
>  sta_apply_parameters+0x126d/0x1b10 net/mac80211/cfg.c:2618
>  ieee80211_add_station+0x3de/0x700 net/mac80211/cfg.c:2684
>  rdev_add_station+0xfc/0x290 net/wireless/rdev-ops.h:201
>  nl80211_new_station+0x1b4e/0x1fd0 net/wireless/nl80211.c:9505
> 
> Fix this by rejecting the addition or modification of a station to the
> associated state if the AP has not been started (chanctx_conf is NULL).
> Exempt Multi-Link Operation (MLO) interfaces from this check, as they
> handle chanctx_conf per-link rather than globally on the VIF.
> 
> Fixes: 55de908ab292 ("mac80211: use channel contexts")
> Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview syzbot
> Reported-by: syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9bdc0c5998ab45b05030
> Link: https://syzkaller.appspot.com/ai_job?id=6a1e0fff-0cb4-4d35-acf2-c84eee3af15c
> To: "Johannes Berg" <johannes@sipsolutions.net>
> To: <linux-wireless@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v2:
> - Moved the chanctx_conf check inside the WLAN_STA_RATE_CONTROL check block.
> - Removed a phrase from the commit description as requested by reviewers.
> 
> v1:
> https://lore.kernel.org/all/8e8a5122-a09e-43b2-b42f-4c73b021b173@mail.kernel.org/T/
> ---
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 3b58af59f..ae29f799b 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2148,8 +2148,13 @@ static int sta_apply_auth_flags(struct ieee80211_local *local,
>  		 * well. Some drivers require rate control initialized
>  		 * before drv_sta_state() is called.
>  		 */
> -		if (!test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
> +		if (!test_sta_flag(sta, WLAN_STA_RATE_CONTROL)) {
> +			if (!ieee80211_vif_is_mld(&sta->sdata->vif) &&
> +			    !rcu_access_pointer(
> +				    sta->sdata->vif.bss_conf.chanctx_conf))

Don't worry about 80 column limit (it is 100 for some time now in scripts/checkpatch.pl). Make this
a one line please: !rcu_access_pointer(sta->sdata->vif.bss_conf.chanctx_conf)).

> +				return -EINVAL;

Add empty line here, so the early return block is separated from the call to
rate_control_rate_init_all_links(sta). I think this will make it more readable.

>  			rate_control_rate_init_all_links(sta);
> +		}
>  
>  		ret = sta_info_move_state(sta, IEEE80211_STA_ASSOC);
>  		if (ret)
> 
> 
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482

-- 
Slawomir Stepien
