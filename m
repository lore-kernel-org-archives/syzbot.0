Received: from smtpo75.interia.pl (smtpo75.interia.pl [217.74.67.75])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85B9E34A3AB
	for <syzbot@lists.linux.dev>; Tue,  4 Aug 2026 12:38:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=217.74.67.75
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785847128; cv=none; b=HrV+E1TkIM5qdiYQW35NaJQJu3fiEoBmEFd5chjf/91rlM6q2ayyB4EjrSt9BCCqcnW0DAToLITFyOD98KVZQlMg6VfE50BnqesnyxIC/cZh1hWlEilt43m6PnXYJPI86OmiWWVMzGXaf2H4Vlwz1PPlVGknPoZUhD5HaBAOGSU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785847128; c=relaxed/simple;
	bh=npyuzQLETb5HYyqvoTXWk3vK3qMx5DQYtoyCVOM7308=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=nuNRmRo+/OPlhqDNrb8o6ZqDF7wrwPk+8E42F6Mgklkyqcsn7SFwXMtOt/pFhLUBnHyY36kgjeKlJCiAWUolTmYzMPHPNY/dsOU6W/3FZ+Hv5H6lJAOZ4aX5Ma0uo/WJId9IvmON9CosiIGmbD3NUiZ6yhoB4D/it+/37K+eSFs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm; spf=pass smtp.mailfrom=poczta.fm; dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b=s9PloEg4; arc=none smtp.client-ip=217.74.67.75
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=poczta.fm
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=poczta.fm
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=poczta.fm header.i=@poczta.fm header.b="s9PloEg4"
Received: from nr200 (unknown [80.68.231.31])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (P-256) server-digest SHA256)
	(No client certificate requested)
	by poczta.interia.pl (INTERIA.PL) with ESMTPSA;
	Tue,  4 Aug 2026 14:38:40 +0200 (CEST)
Date: Tue, 4 Aug 2026 14:38:37 +0200
From: Slawomir Stepien <sst@poczta.fm>
To: syzbot <syzbot@kernel.org>
Cc: syzkaller-upstream-moderation@googlegroups.com, syzbot@lists.linux.dev
Subject: Re: [PATCH RFC] wifi: cfg80211: fix BSS RB tree collision during
 channel switch
Message-ID: <anHdTQ5SOsY8FOIR@nr200>
References: <a8455fef-711a-4293-89ce-248c5f3428e7@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <a8455fef-711a-4293-89ce-248c5f3428e7@mail.kernel.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=poczta.fm; s=dk;
	t=1785847121; bh=rxHkQLwHKELasOcsivaqvuHxxpsg8YyIxhgqhWBNQHM=;
	h=Date:From:To:Subject:Message-ID:MIME-Version:Content-Type;
	b=s9PloEg4BcPZWSSG1NARp2gQywa42pg+bLTS44XcW7R51l/LrrnChFz9IOurHWIZD
	 ky01JmERa5paxb5+TRP1EBLyQms3uznOtborh9RR8a/f5q4va1IA8DYSKKx6BshbRk
	 DwSvo6y3dFtSTTn2M8LN5aRcJMT9kOnVFFTqEvfs=

On sie 02, 2026 22:23, syzbot wrote:
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
> ------------[ cut here ]------------

Remove this line; checkpatch.pl doesn't like it since it might be taken as commit separator (---).

> !cmp
> WARNING: net/wireless/scan.c:1675 at rb_insert_bss net/wireless/scan.c:1675
> [inline], CPU#0: kworker/u9:2/39
> WARNING: net/wireless/scan.c:1675 at cfg80211_rehash_bss+0x1e6/0x540
> net/wireless/scan.c:1732, CPU#0: kworker/u9:2/39
> ...
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
> ...
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
> Link: https://syzkaller.appspot.com/ai_job?id=36735ba4-a810-4748-9be0-c030fc138df1
> To: "Johannes Berg" <johannes@sipsolutions.net>
> To: <linux-wireless@vger.kernel.org>
> To: "Sergey Matyukevich" <sergey.matyukevich.os@quantenna.com>
> Cc: <linux-kernel@vger.kernel.org>
> 
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
