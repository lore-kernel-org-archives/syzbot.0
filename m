Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15AF03793B5
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 16:05:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779120359; cv=none; b=p8CM3Wo3DOXyNducHLr8n0qB9YnYtmuJlY/CuGYlf1YBzhR6MCFSu0wQpOWGTs4AoQmn4PjXAwiAVaStBmqwimQcDv+Xz553DFKNOnCnHS8D+ixnIbbB90XzmPOgzn6+LgzDqD4KM4XSRqjaobxL/Cq54AXhsUz1W/mwiGEdn+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779120359; c=relaxed/simple;
	bh=Ia1+Phl5nm+tQZbtCm1p2KY5hIBFRXBUhd+ZP0LV3u0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=uZxaWl8POP4miVYyF41RxWgur5rRzUIfsz+uiUa+ZiE8G9cC+Xnei8x8l2ghf7cH46lDZY0g1V1ydUukoeN9RSJpiKyd3qkSlif1I6PXhUrV6e58k46mnzLaqWzHRRRhFF/5yxW+K1LIEkRq8iFiM5hxUmVxJdvh1Dh6AzIs+qc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=LjsO3q0K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="LjsO3q0K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8D05FC2BCB7;
	Mon, 18 May 2026 16:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779120357;
	bh=Ia1+Phl5nm+tQZbtCm1p2KY5hIBFRXBUhd+ZP0LV3u0=;
	h=From:To:Cc:Subject:Date:From;
	b=LjsO3q0KgS5wIva9d2FBCOJf5T8wb4O5/n7sjc79gfVIDCVtZDZYBULzXoiAqIIH1
	 RF1773wtFq6Imx2GQEAChV/kYcVDK6VREbXrH49hdFknBahOvORJoGMX6NolwTiBk4
	 nJdsM+ahpZqg5bPzuxKLhPTopS2tIj9YuJgPT2aBTBsWcPLNQmKQ0posPNMY2sXztI
	 fcPFKEsZdHiKGeu02AKZeD1/9CPErGyjXA5lUBsbBQxN4+Km8KCS6t1N24+Mjti5f6
	 RlN5k/IMlRrmj//bVObYldD6jqwa3RQgfazIj9jH/XWyt5D9zutsdITkF86FW3I60Z
	 hkYAPLy9VkgqA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] wifi: cfg80211/mac80211: fix mesh CSA parsing and BSS tree collision
Message-ID: <40385470-2796-48b2-97bd-9489b8775fe1@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 18 May 2026 16:05:57 +0000 (UTC)

The syzkaller reproducer triggers two distinct bugs related to Channel
Switch Announcement (CSA) processing and BSS list management.

First, a NULL pointer dereference and integer underflow can occur in the
Mesh CSA processing. If a crafted SPECTRUM_MGMT/CHL_SWITCH action frame
is received with a matching Mesh ID and Configuration but without the
Mesh Channel Switch Parameters IE, `ieee802_11_parse_elems()` leaves
`elems->mesh_chansw_params_ie` as NULL. This pointer is then
unconditionally dereferenced in `mesh_rx_csa_frame()`, causing a crash.
Furthermore, if the IE is present but its `mesh_ttl` is 0, decrementing
it causes an integer underflow to 255, bypassing safety checks and
potentially causing a broadcast storm of invalid CSA frames. This is
fixed by adding NULL and `mesh_ttl` checks in `net/mac80211/mesh.c`, and
by restricting the parsing of the Mesh Channel Switch Parameters IE in
`net/mac80211/spectmgmt.c` to apply only when the interface is actually
a mesh interface.

Second, an RB tree collision (`WARN_ON(!cmp)`) can occur in
`cfg80211_update_assoc_bss_entry()`. If a Mesh BSS is injected into the
scan list on channel X, and the station associates to an ESS BSS with
the same BSSID and SSID on channel Y, a subsequent CSA to switch the ESS
BSS to channel X will cause a collision. When
`cfg80211_update_assoc_bss_entry()` searches the RB tree for collisions
to remove before rehashing, it uses `cfg80211_bss_type_match()` to
filter the search. This skips the colliding Mesh BSS. When
`cfg80211_rehash_bss()` attempts to insert the ESS BSS into the RB tree,
it collides with the skipped Mesh BSS (since `cmp_bss()` considers them
identical), triggering the warning. This is fixed by removing the
`cfg80211_bss_type_match()` check from
`cfg80211_update_assoc_bss_entry()`, ensuring all colliding BSSes are
removed regardless of their type, which also aligns with the behavior in
`__cfg80211_bss_update()`.

Fixes: 8f2535b92d685c68db4bc699dd78462a646f6ef9 ("mac80211: process the CSA frame for mesh accordingly")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+dc6f4dce0d707900cdea@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=dc6f4dce0d707900cdea
Link: https://syzkaller.appspot.com/ai_job?id=e5a87dde-cabd-43cb-9698-500d937ec9f6
To: <johannes@sipsolutions.net>
To: <linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/net/mac80211/mesh.c b/net/mac80211/mesh.c
index 04578447d..e57b005d7 100644
--- a/net/mac80211/mesh.c
+++ b/net/mac80211/mesh.c
@@ -1376,6 +1376,8 @@ ieee80211_mesh_process_chnswitch(struct ieee80211_sub_if_data *sdata,
 
 	params.block_tx = csa_ie.mode & WLAN_EID_CHAN_SWITCH_PARAM_TX_RESTRICT;
 	if (beacon) {
+		if (!csa_ie.ttl)
+			return false;
 		ifmsh->chsw_ttl = csa_ie.ttl - 1;
 		if (ifmsh->pre_value >= csa_ie.pre_value)
 			return false;
@@ -1636,7 +1638,8 @@ static void mesh_rx_csa_frame(struct ieee80211_sub_if_data *sdata,
 	if (!mesh_matches_local(sdata, elems))
 		goto free;
 
-	if (!elems->mesh_chansw_params_ie)
+	if (!elems->mesh_chansw_params_ie ||
+	    !elems->mesh_chansw_params_ie->mesh_ttl)
 		goto free;
 
 	ifmsh->chsw_ttl = elems->mesh_chansw_params_ie->mesh_ttl;
diff --git a/net/mac80211/spectmgmt.c b/net/mac80211/spectmgmt.c
index e2eaf8d8d..5bf5be36d 100644
--- a/net/mac80211/spectmgmt.c
+++ b/net/mac80211/spectmgmt.c
@@ -279,7 +279,8 @@ int ieee80211_parse_ch_switch_ie(struct ieee80211_sub_if_data *sdata,
 		return 1;
 
 	/* Mesh Channel Switch Parameters Element */
-	if (elems->mesh_chansw_params_ie) {
+	if (sdata->vif.type == NL80211_IFTYPE_MESH_POINT &&
+	    elems->mesh_chansw_params_ie) {
 		csa_ie->ttl = elems->mesh_chansw_params_ie->mesh_ttl;
 		csa_ie->mode = elems->mesh_chansw_params_ie->mesh_flags;
 		csa_ie->pre_value = le16_to_cpu(
diff --git a/net/wireless/scan.c b/net/wireless/scan.c
index 328af43ef..568c17e88 100644
--- a/net/wireless/scan.c
+++ b/net/wireless/scan.c
@@ -3427,11 +3427,6 @@ void cfg80211_update_assoc_bss_entry(struct wireless_dev *wdev,
 	cbss->pub.channel = chan;
 
 	list_for_each_entry(bss, &rdev->bss_list, list) {
-		if (!cfg80211_bss_type_match(bss->pub.capability,
-					     bss->pub.channel->band,
-					     wdev->conn_bss_type))
-			continue;
-
 		if (bss == cbss)
 			continue;
 


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
