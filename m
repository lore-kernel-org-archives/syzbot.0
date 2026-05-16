Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF0E0322B6D
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 18:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778955724; cv=none; b=fmSwLP0NecoPoJlK34w1gZjoI16LMq45Z2ZpOTq/DhTHVhTAY2cwxcTa6Vkd3FrrI82vysJhOD2Mt82i/FMlpcjTk2z9tQWh9sopLFdpxzAaifqmx6qy1HdOZLxnw/DrZh2TNG52seIoLZLHavhYV52hzyI+sMaReMxrVqAjR/w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778955724; c=relaxed/simple;
	bh=gQWd0buwIll3Pa8oqHRv7nXJwUfwbyfy/aiQYARqCZs=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=W4BazrBw0gNanRokiFKmV2abf+/wyf+BEWpZFUpZDS5y9147J7MHB7ZraInWJ4hycaXBgu/dpDkpwX5/Me1lMTrLEly+DnRCNW4ujPVC+CjczIOyUUNeBOuMWzpGiI59IfumS8/ddwyOo7/wsy2vrgO6Oh511CP4TS/dQ0BqWVE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=H9bAo/Ec; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="H9bAo/Ec"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EE73C19425;
	Sat, 16 May 2026 18:22:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778955724;
	bh=gQWd0buwIll3Pa8oqHRv7nXJwUfwbyfy/aiQYARqCZs=;
	h=From:To:Cc:Subject:Date:From;
	b=H9bAo/EckOSfUkgizyaDWgNyFYQESqlC65OlXcele4eLFpOgk1NLOFnMFth5fND/x
	 /oQw/BoV5WLMftr8JCnva1JpHP/LcEQ+fzyQC+ty4B2idKhcb3xJa+5uc/55n4UoUU
	 WQ7F+xi2xlMbaSIqDrz0haK7hJpR0n8RJamEQeYQFKBo2xi4rq9TLKdXFSCiboK+sg
	 a4Y4Sxtpd/+Abj/sr/cUj8Pr0l/MXvkyUU/0v7JBZhFyV15Ywh6570NbVWMZmelLls
	 krQFf+FcVkPq7w/ilvwWb6EfI3XgwKNE1uKHGZxRjQTBfxtaxy8nHNa0aBCRXanXAS
	 KDsXHi3GI70dg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] wifi: rt2x00usb: fix NULL pointer dereference in rt2x00usb_disconnect()
Message-ID: <f98a17ac-9a06-46f2-af52-ba19ff0ead38@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 16 May 2026 18:22:04 +0000 (UTC)

In `rt2x00usb_probe()`, `usb_reset_device()` is called early. If this
reset fails or detects an unexpected device state (which is common with
malicious or rapidly disconnecting simulated USB devices), the USB core
schedules an asynchronous logical disconnect for the device. If the
probe function subsequently fails (e.g., due to hardware allocation or
registration failure), it cleans up by freeing the hardware struct and
setting the interface data to NULL via `usb_set_intfdata(usb_intf,
NULL)`.

Due to a race condition with the asynchronous disconnect scheduled by
the early reset, the `rt2x00usb_disconnect()` callback can be invoked
even after the probe has failed and cleared the interface data. When
`rt2x00usb_disconnect()` is called, it fetches the interface data using
`usb_get_intfdata()` and unconditionally dereferences it to access
`hw->priv`, leading to a kernel panic since `hw` is NULL.

Fix this by adding a NULL check for `hw` at the beginning of
`rt2x00usb_disconnect()`. If `hw` is NULL, it means the probe failed and
the cleanup has already been performed, so the function can safely
return early.

Fixes: bf4c02d5e772903be5bf8952bac730a2956d0619 ("rt2x00: reset usb devices at probe")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+e84ecca6d1fa09a9b3d9@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=e84ecca6d1fa09a9b3d9
Link: https://syzkaller.appspot.com/ai_job?id=63946763-bd49-4c8e-b059-d7248e547b72
To: <linux-wireless@vger.kernel.org>
To: <stf_xl@wp.pl>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
index 174d89b0b..ea6ceb3a1 100644
--- a/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
+++ b/drivers/net/wireless/ralink/rt2x00/rt2x00usb.c
@@ -858,7 +858,12 @@ EXPORT_SYMBOL_GPL(rt2x00usb_probe);
 void rt2x00usb_disconnect(struct usb_interface *usb_intf)
 {
 	struct ieee80211_hw *hw = usb_get_intfdata(usb_intf);
-	struct rt2x00_dev *rt2x00dev = hw->priv;
+	struct rt2x00_dev *rt2x00dev;
+
+	if (!hw)
+		return;
+
+	rt2x00dev = hw->priv;
 
 	/*
 	 * Free all allocated data.


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
