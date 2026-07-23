Received: from smtpo63.interia.pl (smtpo63.interia.pl [217.74.67.63])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 736C83CF210
	for <syzbot@lists.linux.dev>; Thu, 23 Jul 2026 08:08:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.63
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784794112; cv=none; b=AWnuY4cMnT530lLFj1NIWGQ+weqMb+CkAr6ELEootypZH0T9Wixu3s2/Ue5lURzZTCrBq8rA4RY2tbnCkR7d7rXjnJDFPBFT+CGQPmsPDrmaQ70pcd0gLc3AM/jwn15xqSrSjJdOJ4E+Ae/lgunl8y93ruSeNkQefuO92nSrS5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784794112; c=relaxed/simple;
	bh=DMJbNR3/5Lw199EbGNTZ3hILebpFvOUrAUlLyhfC5Lc=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=hv4kB2mAGnCZq9jARQVop+Cwkr7NyrMk0JJpzNUOVbyDpvCghpH1QUAKB9lDT+UPTE9YZFzk0G6mUhzQ+IAFRcGYqlt8zdsi/kowZPgxEEj0uQgZ3SMrXuz2DWT1tUYyxVpKypTk4SuMtnN1gb4NNjSaRKqFutT/XUTScM49nBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=vZ5gyPWs; arc=none smtp.client-ip=217.74.67.63
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="vZ5gyPWs"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Thu, 23 Jul 2026 10:08:18 +0200 (CEST)
Date: Thu, 23 Jul 2026 10:08:15 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v4] wifi: mac80211: reject station association if AP
 is not started
Message-ID: <amHL7x_jnMMgJ2zA@nr200>
References: <fc12db53-baa2-4eb0-ae53-9f0469eafdc9@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fc12db53-baa2-4eb0-ae53-9f0469eafdc9@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1784794099; bh=+lxSqcrKjG8QdtqiujlOQtkS/nI14Cx7uBnQue0HNV8=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=vZ5gyPWsK7xafKfHF6KXEK0X7/me1qjOaoIBCAdZ64Jqcrh6SLDDxz4qI9UpvPu9w
	 GmmwN11dd9BiHgpHEcv1yvbqX6fTx7QNhh7hvkvZMPLRsjzxcHPlMNmWWG3SJfBr8Z
	 SQEA0koQfPIznrTEweyYl/l7Oza9mHyHyJ+1rEWA=

#syz upstream

On lip 22, 2026 16:32, syzbot wrote:
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
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9bdc0c5998ab45b05030
> Link: https://syzkaller.appspot.com/ai_job?id=64f3e3ae-e43e-4917-b403-f9b7799fe1bc
> To: "Johannes Berg" <johannes@sipsolutions.net>
> To: <linux-wireless@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v4:
> - Avoid unnecessary line wrapping in the chanctx_conf check.
> 
> v3:
> - Added an empty line after the newly added code block for better readability.
> https://lore.kernel.org/all/9524f34c-7766-4543-a49c-a9fe48fd9d1e@mail.kernel.org/T/
> 
> v2:
> - Moved the chanctx_conf check inside the WLAN_STA_RATE_CONTROL check block.
> - Removed a phrase from the commit description as requested by reviewers.
> https://lore.kernel.org/all/79cbf145-6652-4e15-be67-f7974ebc29cb@mail.kernel.org/T/
> 
> v1:
> https://lore.kernel.org/all/8e8a5122-a09e-43b2-b42f-4c73b021b173@mail.kernel.org/T/
> ---
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 3b58af59f..830c9fc95 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2148,8 +2148,13 @@ static int sta_apply_auth_flags(struct ieee80211_local *local,
>  		 * well. Some drivers require rate control initialized
>  		 * before drv_sta_state() is called.
>  		 */
> -		if (!test_sta_flag(sta, WLAN_STA_RATE_CONTROL))
> +		if (!test_sta_flag(sta, WLAN_STA_RATE_CONTROL)) {
> +			if (!ieee80211_vif_is_mld(&sta->sdata->vif) &&
> +			    !rcu_access_pointer(sta->sdata->vif.bss_conf.chanctx_conf))
> +				return -EINVAL;
> +
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
