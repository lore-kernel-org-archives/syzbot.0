Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 027BA48989D
	for <syzbot@lists.linux.dev>; Sun,  2 Aug 2026 22:23:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785709422; cv=none; b=XPltt2mhTqVlhm2QFeRP9mT6BYqvt1tqUecBpT2rCX6ujVARMk7U+mdGGh62vfloYy6cad6N3S9PFauy7KX5uGWNz+p4bERBwmWjSpay6ELke8l9bz9gHIHbRNNgPc4gJztDNbMuWolKUziRIx9F+gOOhW3/s0Fe7hZM9k5/Va4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785709422; c=relaxed/simple;
	bh=5MYfSfZsjIG7Sa900xnwo/+gAiJGRAiJDM43z62nKRg=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Vxn4Z2KuigVYaVoGiyPtWsYdud9JhFs2I1MFrTxEBz0pBLe2sJ+MReshf/nNKrpDcUVxvSnK25k7yeokKH+rlZLXEcKE1mq9B3+Z3RcpCzUw8wkvPPGh6UCczSmMb1z8nJF9JzQ9I76ZsgsyA2UH5zXlrKODIk+WQ73fo7JBptY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hMmuXg0d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hMmuXg0d"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6BF1F1F000E9;
	Sun,  2 Aug 2026 22:23:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785709420;
	bh=bGsqEhf8YvZYXnTZHoS4zy9AMu0ZbGkh3X9c7gbv9Iw=;
	h=From:To:Cc:Subject:Date;
	b=hMmuXg0dOkN1M+4h6AhznOXzqCgFw1DpnCGs1T4Pwv0j2+19fPnOo39p8+LWx8I2V
	 i5I092ZRVoP8O/m+v3bhwaUZQmbibk6mE6Sg37EclKAh21+3Fc6P9Q8QuQevrmUIdM
	 4IQ2fX94EBXuENv2dhsRMY9mWWs2sKXRMBN1c8qinf17U3nlMNrJnYSnHHcAqPiZKu
	 eboloikp4xkfIPfBU1SAmE1f//qu6JgBczjVw5z3EymK5qnCUzcl65j5konEkLA+yc
	 lvGDj7orA2/BvWp5GZF1fZGuocyic1TTqoTgHWw5zLRSfUiJt6HbpcfmakG6Vb+6n7
	 MFbBYkFtJLbvw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] wifi: cfg80211: fix BSS RB tree collision during channel switch
Message-ID: <a8455fef-711a-4293-89ce-248c5f3428e7@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun,  2 Aug 2026 22:23:40 +0000 (UTC)

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

------------[ cut here ]------------
!cmp
WARNING: net/wireless/scan.c:1675 at rb_insert_bss net/wireless/scan.c:1675
[inline], CPU#0: kworker/u9:2/39
WARNING: net/wireless/scan.c:1675 at cfg80211_rehash_bss+0x1e6/0x540
net/wireless/scan.c:1732, CPU#0: kworker/u9:2/39
...
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
...

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
Link: https://syzkaller.appspot.com/ai_job?id=36735ba4-a810-4748-9be0-c030fc138df1
To: "Johannes Berg" <johannes@sipsolutions.net>
To: <linux-wireless@vger.kernel.org>
To: "Sergey Matyukevich" <sergey.matyukevich.os@quantenna.com>
Cc: <linux-kernel@vger.kernel.org>

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
