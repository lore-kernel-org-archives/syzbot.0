Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B67F39060C
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 08:20:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=pass smtp.client-ip=100.103.45.18
ARC-Seal:i=2; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785918007; cv=pass; b=SjvosX21hvGqYbtwXAlCx9pxVqmbEx7nD+UwirQFUjdtb0fER82sUln5vfQS/qZyF7QrJ0gdx+46sEKlCBPIJyjuTWkILCG4PaY+WPUb/IMGkUTyddpATObCwXBxRIe1X4osCUqkF6fCI2JcPmGICiWLAGw/oj5k8Zh+SWJO89U=
ARC-Message-Signature:i=2; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785918007; c=relaxed/simple;
	bh=/OWI8qBD1lqOVHMrWpyAHuEMpetqyf4e5+hFRLOSxz8=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rDUnJ2jxyHaZMrI9KfMpLq6PRoKKM3NuYwNh8zoa/rM62HEEyDZkU3UTGUc5vNVcSEvUbsbJ8SiazOqOUOIEwZQIFwWsFKVpuRKkum1rlRSZ8QgotBd5bcq2zeBz+kmDyI5HgA1y75gUTBIUHVWqsiwykcx6aG5rzpfMC6El/bM=
ARC-Authentication-Results:i=2; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=uSIuX0A+; arc=pass smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="uSIuX0A+"
Received: by smtp.kernel.org (Postfix)
	id 759DB1F00A3A; Wed,  5 Aug 2026 08:20:05 +0000 (UTC)
Authentication-Results: smtp.kernel.org; arc=none smtp.remote-ip=217.74.67.75
ARC-Seal: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256; cv=none;
	t=1785918005;
	b=V70CjilBye3Ur3aBkdLBcHc8X+SX4hOVRhKBQ3SuF3LsRLeh8H+lZxNdKg+prDa3z97u
	 imE3rzIe/kK10eggo619xyZhzymji+K4AiOjUqQgDXu1PjVy9c/UlsbbJXX97tyQNCyqj
	 YapHgJiGirHfvw5AZf6X4/Jhwpvb7VplD9C8PECAjOPx2phbzYhxBEUrU8hL7TjdJs6n3
	 PPHDfvcxUZ70V8WZ+UXrZmEySRF6H7l2xxPO0PtePcnlfTt/iU5fexQVS1rhzsn/AsixT
	 0EKCFAcCHGItkrMeOyQiZQrTpx/MF0muuBbATTuaGuzsyoT3vEgRXDBAZH5q431rgAw==
ARC-Message-Signature: i=1; d=kernel.org; s=arc20260519; a=rsa-sha256;
	c=relaxed/relaxed; t=1785918005;
	h=DMARC-Filter:Received:Date:From:To:Cc:Subject:Message-ID:References:
	 MIME-Version:Content-Type:Content-Disposition:In-Reply-To:
	 DKIM-Signature;
	bh=LtAk53VaP0Sb33aS43bux8CL5zlcbRKXAeJDWIfbgVM=;
	b=NwDNMRk7eKWdNPqil3/Y+/0SctEQ9Q5hun/iIJnWheL+J02sO6BoVuWIBMA56m1QplMe
	 eenu7hNMUiPhlVcs73eH34lbvaYttwtw2QUWWUSUbz4ucxd1t9okEeOR5G2kG31Yw6dBn
	 oMPD3N+83SlhvpZlSg6d4jB/QTec8mOU4s+47KjQMtUrB0xAlnB84PaGZtxByBSk+HYkx
	 OWm+9/fZ7EAzWD6+DPJaT9MhEf8l9Ud+g+nR+kQYkAagTlE3HS0VcaQGF51aXx3oeXuQ2
	 OuzcTJ2CB1mFrJUEOxRm1DQBdpNA6lJPnKlnxGpU1R+W0kUQikAE1piN6AF8sQeLXag==
ARC-Authentication-Results: i=1; smtp.kernel.org; dkim=pass header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=uSIuX0A+;
	dmarc=pass header.from=poczta.fm;
	spf=pass smtp.mailfrom=poczta.fm;
	arc=none smtp.remote-ip=217.74.67.75
Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-ECDSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.kernel.org (Postfix) with ESMTPS id 526631F000E9
	for <syzbot@kernel.org>; Wed,  5 Aug 2026 08:20:02 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=poczta.fm header.i=@poczta.fm header.a=rsa-sha256 header.s=dk header.b=uSIuX0A+
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.kernel.org 526631F000E9
Authentication-Results: smtp.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Wed,  5 Aug 2026 10:19:53 +0200 (CEST)
Date: Wed, 5 Aug 2026 10:19:51 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v2] wifi: cfg80211: fix BSS RB tree collision during
 channel switch
Message-ID: <anLyJzWTjl1_8S6G@nr200>
References: <4119b372-fffd-487d-b08f-f9cc0825ba05@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4119b372-fffd-487d-b08f-f9cc0825ba05@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785917995; bh=LtAk53VaP0Sb33aS43bux8CL5zlcbRKXAeJDWIfbgVM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=uSIuX0A+ZncaLsSTF8lk8zL+oILtk6EKJZT+n4Q3CH1qONM3G999xojOhA66Ld2rm
	 Yi3eyuyktLDQhMZjbMnIuOPfurxzBt3UK88Y+AH8exF0A2vkU6IgELhBNq4dQGIaAp
	 wPPWLGQqYxglJW9PDlCRrx/q67kO3kRdLgbQACW0=

On sie 04, 2026 13:45, syzbot wrote:
> When a station processes a Channel Switch Announcement (CSA),
> cfg80211_update_assoc_bss_entry() is called to update the channel of the
> associated BSS. Because the channel is part of the BSS Red-Black (RB) tree
> key, changing the channel requires removing the BSS from the tree and
> re-inserting it.
> 
> Before re-inserting, cfg80211_update_assoc_bss_entry() searches for any
> existing BSS on the new channel that matches the associated BSS so it can
> be unlinked to prevent an RB tree collision. However, the search loop
> incorrectly uses cfg80211_bss_type_match() to filter candidates based on
> their capabilities. If an existing BSS matches perfectly in cmp_bss() (same
> channel, BSSID, and SSID) but has different capabilities (e.g., due to a
> malicious or misconfigured beacon setting both ESS and IBSS bits),
> cfg80211_bss_type_match() skips it.
> 
> This leaves the colliding BSS in the tree. When cfg80211_rehash_bss()
> attempts to re-insert the associated BSS, rb_insert_bss() compares them
> using cmp_bss(), which ignores capabilities. It finds them identical,
> resulting in an RB tree collision and triggering a warning:
> 
> WARNING: net/wireless/scan.c:1675 at rb_insert_bss net/wireless/scan.c:1675
> [inline]

Don't wrap lines from logs. Keep it as it was for readability.

> WARNING: net/wireless/scan.c:1675 at cfg80211_rehash_bss+0x1e6/0x540
> net/wireless/scan.c:1732

ditto

> Call Trace:
>  <TASK>
>  cfg80211_update_assoc_bss_entry+0x3cd/0x660 net/wireless/scan.c:3478
>  cfg80211_ch_switch_notify+0x3b1/0x780 net/wireless/nl80211.c:22366
>  ieee80211_sta_process_chanswitch+0xbd1/0x29e0 net/mac80211/mlme.c:-1
>  ieee80211_rx_mgmt_beacon+0x1dc6/0x32a0 net/mac80211/mlme.c:8309
>  ieee80211_sta_rx_queued_frame+0x6ac/0x4e40 net/mac80211/mlme.c:11793
>  ieee80211_iface_process_skb net/mac80211/iface.c:1766 [inline]
>  ieee80211_iface_work+0x552/0x1010 net/mac80211/iface.c:1823
>  cfg80211_wiphy_work+0x29e/0x420 net/wireless/core.c:538
>  </TASK>
> 
> Fix this by removing the cfg80211_bss_type_match() check from the collision
> search loop. The RB tree uniqueness is defined solely by cmp_bss(), so any
> BSS that evaluates to cmp == 0 must be unlinked to prevent a collision,
> regardless of whether its capability matches the connection type. If the
> AP's capabilities legitimately changed, cfg80211_update_known_bss() will
> safely update the capability later.
> 
> Fixes: 0afd425b1b64 ("cfg80211: fix duplicated scan entries after channel switch")
> Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
> Reported-by: syzbot+dc6f4dce0d707900cdea@syzkaller.appspotmail.com
> Closes: https://syzkaller.appspot.com/bug?extid=dc6f4dce0d707900cdea
> Link: https://syzkaller.appspot.com/ai_job?id=075be109-44b2-42f2-89a0-050bc51d2a19
> To: "Johannes Berg" <johannes@sipsolutions.net>
> To: <linux-wireless@vger.kernel.org>
> To: "Sergey Matyukevich" <sergey.matyukevich.os@quantenna.com>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v2:
> - Removed the '------------[ cut here ]------------' line from the commit message to prevent checkpatch.pl from interpreting it as a commit separator.
> 
> v1:
> https://lore.kernel.org/all/a8455fef-711a-4293-89ce-248c5f3428e7@mail.kernel.org/T/
> ---
> diff --git a/net/wireless/scan.c b/net/wireless/scan.c
> index 071083cc3..97bf7ab8c 100644
> --- a/net/wireless/scan.c
> +++ b/net/wireless/scan.c
> @@ -3443,11 +3443,6 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
>  	cbss->pub.channel = chan;
>  
>  	list_for_each_entry(bss, &rdev->bss_list, list) {
> -		if (!cfg80211_bss_type_match(bss->pub.capability,
> -					     bss->pub.channel->band,
> -					     wdev->conn_bss_type))
> -			continue;
> -
>  		if (bss == cbss)
>  			continue;
>  
> 
> 
> base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff

-- 
Slawomir Stepien
