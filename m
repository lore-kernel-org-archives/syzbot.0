Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91C8143CE59
	for <syzbot@lists.linux.dev>; Tue,  4 Aug 2026 13:45:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785851147; cv=none; b=m7ECDROBi6jeTmFVU76I5goYoa/k0ZN6YsS2u9NLhwOFqeNcBfVYCcXuVgmfx6Ny6Vdp28SnVJuefEJmoIYP5/VZ+c4T8JOGr0aaU1x69J3yi3ymaeuRHkdMlCTA9QH0NsufdjzC6enAOa9OlP0fbftqIttC/ljJCExYma8FiiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785851147; c=relaxed/simple;
	bh=lZTHy2ExWhofB7LmVJdi8Wsw2wQw+ssufY2Ze7BmUk0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=YiPtqdUuf9cze19Yg1XzL+HJnM4cTVBsPfM/U/LzXsXFqj12zSpGS2pjbOG9qS2eu1XB/lTbRq9BIaDl0gQiVdmkZ/LmN6WX+S00BuKD1Msz1bApyfpDlxAiDY37b+NOBoCPWaazvjLvlJY3LBJuOCrpZ8XGJvwd7N9QsGN0/78=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=VEh6O8Gz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="VEh6O8Gz"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5189D1F000E9;
	Tue,  4 Aug 2026 13:45:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785851146;
	bh=pEN/eqIGew7AhCa6Waw4rgSSbLMo64yraaJBzRw+ruY=;
	h=From:To:Cc:Subject:Date;
	b=VEh6O8GzIHTnddEQtwgDB80xnsMMET2emlWilwt2Rlnx7kurRcoriJMABaaMCjcnv
	 M989T/y55c2LItsk0cv/R2Skke1iY/1znEosX5/F0VWCx1WfCHmaX2/QIN8JWv1UQ3
	 aR3ZyGAvMnfFYTJqk0G+5/Cx2o8QCj4z7xD028jR+dnDSrkMpKaIqVTD3pZX0AN9tQ
	 Piijf0ojyfZUtHTW+N9djhG6ZhUfiOEOsAob6Gy3Jb2e6Y2GM4L7xt37epakfvjxAR
	 kjfFGOWv4SASSdsv2rNr0xjETX/fP0mhvBkUzJk9Q4wpXA0a6TwChmoKuXgVgIwPV4
	 9yK5YXDqHEV7g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: sst@poczta.fm, syzbot@lists.linux.dev
Subject: [PATCH RFC v2] wifi: cfg80211: fix BSS RB tree collision during channel switch
Message-ID: <4119b372-fffd-487d-b08f-f9cc0825ba05@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue,  4 Aug 2026 13:45:46 +0000 (UTC)

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
Link: https://syzkaller.appspot.com/ai_job?id=075be109-44b2-42f2-89a0-050bc51d2a19
To: "Johannes Berg" <johannes@sipsolutions.net>
To: <linux-wireless@vger.kernel.org>
To: "Sergey Matyukevich" <sergey.matyukevich.os@quantenna.com>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Removed the '------------[ cut here ]------------' line from the commit message to prevent checkpatch.pl from interpreting it as a commit separator.

v1:
https://lore.kernel.org/all/a8455fef-711a-4293-89ce-248c5f3428e7@mail.kernel.org/T/
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
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
