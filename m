Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 542ED3C8C43
	for <syzbot@lists.linux.dev>; Tue, 12 May 2026 21:05:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778619953; cv=none; b=EAlRtzu9G3oN0cVNhpxIBevXA6BFwq2ECSi5/wZ7TuGNhPioThzfeCWhvgWTTDJ6/wW9SstIN4iAN9bFgaF5CSYLXfRUPvu+W6y+hj2aNCe0VQQNNmy34FKn9Ke5GWKmg45tGczYLD4D39UUYuD/S2rXkdWE0Ds5sh5zioyarTM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778619953; c=relaxed/simple;
	bh=DtZjuIT/poDlvULZ0+GI4mvm61TtF9mobGm0LwkqPOc=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=rK+xIc8OjRTXgZXkxZUorJtY4eN0/nSDfMV28reCCxaDpB2DPC7nS+yPLccw88ofwa4h+GZMWNgggrPVbNgT8U3rZhH2tBHaGW4T5GJ9fwpBa07uTXITbrPmjN/PLPIgF555VKl29lwR9lDfjm51czuqYbZc8j9592qnkxle60U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XOiphtF4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XOiphtF4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D728DC2BCFA;
	Tue, 12 May 2026 21:05:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778619953;
	bh=DtZjuIT/poDlvULZ0+GI4mvm61TtF9mobGm0LwkqPOc=;
	h=From:To:Cc:Subject:Date:From;
	b=XOiphtF4wfLUEmj94FMcXiHF4DzQDod9MGhBE5iy0GguCnZ2sdMOR5ASFJOxZTZy2
	 8mqW8iBX8zlWaUFbl6HECkE9eRyyTWR4q1PsHEMA4p62hQx5crszsdGbijaJFrvz+1
	 sy9jJDEVqBatFn/GSamSjDEmQrutR6xnFY8d2AgxRkU4Eczx+xzyKzS93Fkz0jusaK
	 lS37Jv2nDIlRabp+An4jx/KIWQEzYqW8hTnvn7UpqFGAH9kXPsycpdyyoZSYf33o/L
	 quOPbEDW4HgWBoibTAlrzPzimonREz/V89aJQOxnvvUkhIvaWG2f3uv/9vWaVOQA1i
	 q6WuXSxP7E9Yw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] wifi: zd1211rw: restrict binding to a single interface
Message-ID: <affecee3-b60c-498b-ae12-99ade5e65f05@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 12 May 2026 21:05:52 +0000 (UTC)

A malicious USB device with multiple interfaces can trigger a lockdep
warning about a possible recursive locking deadlock in the zd1211rw
driver.

The driver lacks a check for the interface number in its probe function,
allowing it to bind to all interfaces of a matching USB device. During
probe, the driver calls usb_reset_device(). If the device has multiple
interfaces, usb_reset_device() invokes the pre_reset callback for all
currently bound interfaces. Because pre_reset acquires and holds
&chip->mutex, calling it for multiple interfaces sequentially causes the
task to acquire multiple mutexes of the same lock class, triggering the
lockdep warning.

Real ZD1211 Wi-Fi dongles only have a single interface (interface 0).
Binding to multiple interfaces is a bug that not only causes this
lockdep warning but would also lead to functional issues if the
interfaces share endpoints.

Fix this by rejecting any interface other than 0 at the beginning of the
probe function. This ensures that at most one interface is ever bound to
this driver per device, preventing the recursive locking scenario and
underlying functional bugs.

Fixes: e85d0918b54fbd9b38003752f7d665416b06edd8 ("[PATCH] ZyDAS ZD1211 USB-WLAN driver")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+0ec3d1a6cf1fbe79c153@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=0ec3d1a6cf1fbe79c153
Link: https://syzkaller.appspot.com/ai_job?id=81d3d19a-926e-45c1-a50d-098739716a84
To: <linux-wireless@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
index 966d8ccb0..968fa338f 100644
--- a/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
+++ b/drivers/net/wireless/zydas/zd1211rw/zd_usb.c
@@ -1353,6 +1353,10 @@ static int probe(struct usb_interface *intf, const struct usb_device_id *id)
 	struct zd_usb *usb;
 	struct ieee80211_hw *hw = NULL;
 
+	/* ZD1211 devices only have a single interface */
+	if (intf->cur_altsetting->desc.bInterfaceNumber != 0)
+		return -ENODEV;
+
 	print_id(udev);
 
 	if (id->driver_info & DEVICE_INSTALLER)


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
