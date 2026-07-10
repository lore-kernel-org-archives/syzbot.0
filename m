Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 880973D5235
	for <syzbot@lists.linux.dev>; Fri, 10 Jul 2026 08:45:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783673138; cv=pass; b=Xh+rdp4ob6yufprh8WU5lw0IlTxJK8Tc3X3tXEeCACN3s5rpL7+jWN/iq3XHhfVFDR0F/lK5hdRSjsfh4dxROjX1dyKzxZG0OOhMEhkBx0PMjv31J+wgScI2j0hm5oJ1oaAdxZd2MH0kHynM5axgK0w63VbjQqCTKWelroDaFyw=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783673138; c=relaxed/simple;
	bh=9KEb4UQUB+2pvmjb+7tyL3Wz6ehHzrdDenzhICPIKGs=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=M00RjM59HIbUMIyM0WldcoCeYyHAacgtdKTyREe5ie9SurH8otZcRoFGhn4Q4jHo3iMA5jWVFO0rS2zl5bAhCY5moeXm33Do96LDquVpjT9NEdh4rmp/iQ7hIwnbBEbSquHdzpmkpNaFnMgXlk+Gfnsodk136e3r8NIyx+AKIgg=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=xuQFTKz9; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="xuQFTKz9"
Received: by smtp.kernel.org (Postfix)
	id 534DB1F00A3A; Fri, 10 Jul 2026 08:45:36 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.49
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1783673136;
	b=y+vFlN4odYlDLrTIa0rK53dVpPGbdNJT+tV49EWTI9/xjU1Pj9So6/qIRPncx9DihVAv
	 Dfbp/OP+9w+xq7xyqmGz+hlM5oTEsZjRzspWfnZjOfbk+FKp0Lf139Vxw5eEtAhw+LLXE
	 IuFbIv/p+7tsUzJgrL+6j4wVDGd/uhPYktWjFhQSTcLofmz0TiuIR2RDaebnZwlcFwxUa
	 ZWVBLEoqijbzt7Ys7xuUiluj9aSwU5eocvw/2XUmLiW+nrDy2XWgD5BGIMvDug51DFeiA
	 0/8qdluXqAu+tg2SW+6SrfxP0UWILrop2Iqu5obIsblR4kVIOuh2FhT2RObLgZRMI8g==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1783673136;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=Los3LQiJD5010/HC5UZN87PkHI2Lwx+x7SnMz753drM=;
	b=geeVUh5fMl6vdWD3TyocShjfjhrmpdYWEGH5N5eAZLsUaKeG4V9waFv7fKoslXGafLDv
	 dS/b1+0/FCTPDfEZO0x32M2VeU8c2b4VRlQMTv7fGP1z25T8eDJHHn4EzcUXWfArG+mI/
	 d/Hq3IlMZkoXufUtA3DsBVIZPclQ10ht4OCNzX9el3D92FvZfKB2nwPMAAkiPqp74Mb6C
	 En4iVBNVyRGk8fZCuR+gURVxsBa3kCX7w/AJGNYtUPJSLbyh50GarRASbmrOno8mPXFNq
	 lCDFWPlhylXiGDNCge1yqkXZ8Tkaf3AF9FtNStW+Se38JkLOQwO8Tcn0DgW6bZKg6TA==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=xuQFTKz9;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.49
Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 302771F000E9
	for <syzbot@kernel.org>; Fri, 10 Jul 2026 08:45:33 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=xuQFTKz9
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 302771F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Fri, 10 Jul 2026 10:45:23 +0200 (CEST)
Date: Fri, 10 Jul 2026 10:45:17 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] wifi: mac80211: reject station association if AP is
 not started
Message-ID: <alCxHUOOepQOJk8-@nr200>
References: <8e8a5122-a09e-43b2-b42f-4c73b021b173@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8e8a5122-a09e-43b2-b42f-4c73b021b173@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1783673125; bh=Los3LQiJD5010/HC5UZN87PkHI2Lwx+x7SnMz753drM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=xuQFTKz9buAjUKoBaPI1lS7ZwC1jhatuyLIZB1ieHA4QyuPtwoiK8Hy+WbadrkxJW
	 Mgbt9lafKEpEAWHbFDL3LKdsKjKh7hkfqQwSTBsefKjww79y5MmHuE+qgIvf9CpLLe
	 tprEJR7M7tXvCcjT4U5PoKupMgVZXLZvRkV9RJXo=

On lip 01, 2026 09:52, syzbot wrote:
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
> handle chanctx_conf per-link rather than globally on the VIF, and
> rate_control_rate_init() already handles them correctly.

Well, the rate_control_rate_init() isn't really handling the MLO devices yet:

	/* SW rate control isn't supported with MLO right now */
	if (WARN_ON(ieee80211_vif_is_mld(&sta->sdata->vif)))
		return;

I think we can tackle this some other time, but maybe at the moment it is wise to remove the "and
rate_control_rate_init() already handles them correctly" from commit message?

> Fixes: 55de908ab292 ("mac80211: use channel contexts")
> Assisted-by: Gemini:gemini-3.1-pro-preview best-expensive syzbot
> Reported-by: syzbot+9bdc0c5998ab45b05030@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=9bdc0c5998ab45b05030
> Link: https://syzkaller.appspot.com/ai_job?id=86851195-2aa0-410f-9fc9-952d95ae035d
> To: "Johannes Berg" <johannes@sipsolutions.net>
> To: <linux-wireless@vger.kernel.org>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> diff --git a/net/mac80211/cfg.c b/net/mac80211/cfg.c
> index 3b58af59f..b45d7923c 100644
> --- a/net/mac80211/cfg.c
> +++ b/net/mac80211/cfg.c
> @@ -2143,6 +2143,10 @@ static int sta_apply_auth_flags(struct ieee80211_local *local,
>  	if (mask & BIT(NL80211_STA_FLAG_ASSOCIATED) &&
>  	    set & BIT(NL80211_STA_FLAG_ASSOCIATED) &&
>  	    !test_sta_flag(sta, WLAN_STA_ASSOC)) {
> +		if (!ieee80211_vif_is_mld(&sta->sdata->vif) &&
> +		    !rcu_access_pointer(sta->sdata->vif.bss_conf.chanctx_conf))
> +			return -EINVAL;
> +

Could you move this check to the if body below (after the comment) where the WLAN_STA_RATE_CONTROL
flag is checked for? I think having it there, right before calling the
rate_control_rate_init_all_links(sta); is more readable and done only when the WLAN_STA_RATE_CONTROL
is not set.

>  		/*
>  		 * When peer becomes associated, init rate control as
>  		 * well. Some drivers require rate control initialized
> 
> 
> base-commit: dc59e4fea9d83f03bad6bddf3fa2e52491777482

-- 
Slawomir Stepien
