Received: from smtpo49.interia.pl (smtpo49.interia.pl [217.74.67.49])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A7B341F5DB
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 20:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.49
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785961883; cv=none; b=JZXJ1i8HgX4zxCnwuly/s5C0zVOEuVrE4THDzXKYnzq9xLpRMa1aYGWAXgVRdXuUz7rOHNL/Hd4xlRkNob8rpaaimFJa5eUonHnPqOflBGd8gN0zWSaUrKEndtAW0RVmRkCgUFlCymUJ9y/NVg34d3Yp0I8yf14kl04D87U6DOE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785961883; c=relaxed/simple;
	bh=PzRUqCO195S8/9VZnfKi50lD0uUq5zJcmBWhqiq5I34=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=O0YRs5RewpiEjS9vn9al7zbvRv4LG/7UHn9jqb8dgaqFxPItfF5G94gilb6pP2dnEaZQKEJFKI4pTjFSkDFv+2zYdEPBT5WtUNZGcJz0HfGQpBFACCC8aaNnAcLVNnwic1nL2r2A/4y+3ayTT6VGtDRJUqCAIj+fsSJJxceXpoY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=lVmyQ/AM; arc=none smtp.client-ip=217.74.67.49
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="lVmyQ/AM"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Wed,  5 Aug 2026 22:31:11 +0200 (CEST)
Date: Wed, 5 Aug 2026 22:31:09 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC v3] wifi: cfg80211: fix BSS RB tree collision during
 channel switch
Message-ID: <anOdjR9mr7DumC6y@nr200>
References: <986597e1-174a-4bd0-9de5-dde9cb474df9@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <986597e1-174a-4bd0-9de5-dde9cb474df9@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785961873; bh=Ox2GtVhat6/gVYXG+uanXHzHw/h27+stMeUpSNxVaKU=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=lVmyQ/AMRmDbC16V4+XnGfPUF1rUPpKyuoS3F5QGDUnhNqw8ftMeLy26x9fgXX5Pz
	 Q6x3EUPCuMmd0QC0q0Oo5X6+1NAmQhNgeT/biLk4YGi8XqHKlb3vhhmGvkQ2mMbLaO
	 D1C4z7/m6uyY5UXkHcqKwbH2XuAc10YFe7p8kxRM=

#syz upstream

On sie 05, 2026 09:26, syzbot wrote:
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
> WARNING: net/wireless/scan.c:1675 at cfg80211_rehash_bss+0x1e6/0x540
> net/wireless/scan.c:1732
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
> Link: https://syzkaller.appspot.com/ai_job?id=3e1a2f1d-82c9-492d-8063-7fb21356c013
> To: "Johannes Berg" <johannes@sipsolutions.net>
> To: <linux-wireless@vger.kernel.org>
> To: "Sergey Matyukevich" <sergey.matyukevich.os@quantenna.com>
> Cc: <linux-kernel@vger.kernel.org>
> 
> ---
> v3:
> - Do not wrap log lines in the commit message.
> 
> v2:
> - Removed the '------------[ cut here ]------------' line from the commit message to prevent checkpatch.pl from interpreting it as a commit separator.
> https://lore.kernel.org/all/4119b372-fffd-487d-b08f-f9cc0825ba05@mail.kernel.org/T/
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
