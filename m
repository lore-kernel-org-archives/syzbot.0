Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39A773D7D6A;
	Wed,  5 Aug 2026 20:35:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785962150; cv=none; b=LhbyFYGu+3dpqQeZ8XhZj1onz/41DqTmkNuQSh8Vm8J4KBN9m/3LtffCLkSsvkqyBCMCM6wsOnyytIw/FvAOuGmeI8qt2tukrkXv4ztJbQgSLOsse3AL45u8ZA0jE0Te64lNVxrTj0HvPOlWZpQNJXvMgEnOX7MgbKJe21wWoMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785962150; c=relaxed/simple;
	bh=94OfipwqChMd3pKKB97CcGK/he6eIzoy9eeRZyraIu8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Fx6jjWetLFZesnPUQg88sdCqKgEFIuV/wdp5K6TX8qlS+470CmDCFv6Upn8qkin8yBYhyidohf6MEVMb1RCwxeYVyQG9EbScq69SH+YjeuT+OZ/6LfS7xX/hYCZFZHGTGRej9sqnj1v/YSejmLtexkkkpvjgd3RitFEqAAsKNN8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SaX7v9AN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SaX7v9AN"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6F7751F000E9;
	Wed,  5 Aug 2026 20:35:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785962148;
	bh=grB6GXqo3SRM/onPgxhODF0vMNWHGpGA2ehlG7HsPLo=;
	h=From:To:Cc:Subject:Date;
	b=SaX7v9ANHgonGDpdUSK2OScEqHcBF0acavdqphB6IL3hQe6vSMPcLVfqckQx9FY4u
	 4fOrFMlL3oRU+ndGZOmz8JtIrOCJhv9d2XjOIrhH42xubvPUpq+byliWOWrflMTe0M
	 DRfSbT+LSH0XiSwMzs5AprCV1icin/RKlNeI5cWKiW6Wb5/NtH+aej7Bf+MqW5/T/r
	 /0jOcmtMVwvdXB6SGNyVl4yPSZyGvcu+1nu2HnPrV19mY9fm1AHoR9hObUNu2lhvv5
	 gLVCMWD6zBmY1R6sLXETgABiBFHBnHz8LNSgqjzQ7r4vx53HHmrLWjH9VcR47ZshV2
	 CJ8LVQFTUsY5w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Slawomir Stepien <sst@poczta.fm>, "Johannes Berg" <johannes@sipsolutions.net>, <linux-wireless@vger.kernel.org>, "Sergey Matyukevich" <sergey.matyukevich.os@quantenna.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] wifi: cfg80211: fix BSS RB tree collision during channel switch
Message-ID: <1e64e12d-7785-45f0-8ece-b87724e7c9af@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  5 Aug 2026 20:35:48 +0000 (UTC)

From: Slawomir Stepien <sst@poczta.fm>

When a station processes a Channel Switch Announcement (CSA),
cfg80211_update_assoc_bss_entry() is called to update the channel of the
associated BSS. Because the channel is part of the BSS Red-Black (RB) tree
key, changing the channel requires removing the BSS from the tree and
re-inserting it.

Before re-inserting, cfg80211_update_assoc_bss_entry() searches for any
existing BSS on the new channel that matches the associated BSS so it can
be unlinked to prevent an RB tree collision. However, the search loop
incorrectly uses cfg80211_bss_type_match() to filter candidates based on
their capabilities. If an existing BSS matches perfectly in cmp_bss() (same
channel, BSSID, and SSID) but has different capabilities (e.g., due to a
malicious or misconfigured beacon setting both ESS and IBSS bits),
cfg80211_bss_type_match() skips it.

This leaves the colliding BSS in the tree. When cfg80211_rehash_bss()
attempts to re-insert the associated BSS, rb_insert_bss() compares them
using cmp_bss(), which ignores capabilities. It finds them identical,
resulting in an RB tree collision and triggering a warning:

WARNING: net/wireless/scan.c:1675 at rb_insert_bss net/wireless/scan.c:1675
[inline]
WARNING: net/wireless/scan.c:1675 at cfg80211_rehash_bss+0x1e6/0x540
net/wireless/scan.c:1732
Call Trace:
 <TASK>
 cfg80211_update_assoc_bss_entry+0x3cd/0x660 net/wireless/scan.c:3478
 cfg80211_ch_switch_notify+0x3b1/0x780 net/wireless/nl80211.c:22366
 ieee80211_sta_process_chanswitch+0xbd1/0x29e0 net/mac80211/mlme.c:-1
 ieee80211_rx_mgmt_beacon+0x1dc6/0x32a0 net/mac80211/mlme.c:8309
 ieee80211_sta_rx_queued_frame+0x6ac/0x4e40 net/mac80211/mlme.c:11793
 ieee80211_iface_process_skb net/mac80211/iface.c:1766 [inline]
 ieee80211_iface_work+0x552/0x1010 net/mac80211/iface.c:1823
 cfg80211_wiphy_work+0x29e/0x420 net/wireless/core.c:538
 </TASK>

Fix this by removing the cfg80211_bss_type_match() check from the collision
search loop. The RB tree uniqueness is defined solely by cmp_bss(), so any
BSS that evaluates to cmp == 0 must be unlinked to prevent a collision,
regardless of whether its capability matches the connection type. If the
AP's capabilities legitimately changed, cfg80211_update_known_bss() will
safely update the capability later.

Fixes: 0afd425b1b64 ("cfg80211: fix duplicated scan entries after channel switch")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+dc6f4dce0d707900cdea@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dc6f4dce0d707900cdea
Link: https://syzkaller.appspot.com/ai_job?id=3e1a2f1d-82c9-492d-8063-7fb21356c013
Signed-off-by: Slawomir Stepien <sst@poczta.fm>

---
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 071083cc3..97bf7ab8c 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3443,11 +3443,6 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
 	cbss->pub.channel = chan;
 
 	list_for_each_entry(bss, &rdev->bss_list, list) {
-		if (!cfg80211_bss_type_match(bss->pub.capability,
-					     bss->pub.channel->band,
-					     wdev->conn_bss_type))
-			continue;
-
 		if (bss == cbss)
 			continue;
 


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
