Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA98D23ABBF
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 15:03:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778943811; cv=none; b=TrRZ+zvlWjExttt+xkAlY2KN1czB0uBOsr3sfsBxa4PrJlK8hOJLzeoDiUCqggR0IyBFF9o0D/rAJQXTDcfIgSdZaYwA84UtL4Os03dIywp3DGIZncuXTj55Mn9lHQ946MBLWSDkpgdCfHHGfCgers+d2HmHcsNBj7MPyL3bFlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778943811; c=relaxed/simple;
	bh=yY/XvdeJJNrL6DwOynXeU6uzz8pvQ6MMn6ieQNbeqb0=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ZpIj7E3NmflspZDV0KJyYnUA+Frv4ffUammW5wwgKp2Ps4FW6k3ZGn73fS+r2YUg0LknIa4ipyAhTjW0wXTpcB1bk/KYay5Ory6lpzgiVm8sWUWno99SXmkrMz4PUIUjoSkLSizj2lCdMIbWX7PfKIKYFKnezybn+kA2jyHDmLI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=fsI31tkW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="fsI31tkW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 39A69C19425;
	Sat, 16 May 2026 15:03:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778943811;
	bh=yY/XvdeJJNrL6DwOynXeU6uzz8pvQ6MMn6ieQNbeqb0=;
	h=From:To:Cc:Subject:Date:From;
	b=fsI31tkWBf33C4bBgfN7EXtzuiyY2H9KV0y4TgYXlRdsMcLmo6ES0/wxDgsZsi51Y
	 64RrID1mHQ40YT7GbGa5gGbJVbxXfpu6n5y4sEpmJRmhWibOQV2j1PDhHcJANtJFUP
	 VxeBjoulN/yjsxe7adh+wqYJq7xDTIJQzYWijxHveDDSD39SjN2XKDJ8nqXnwFLhhI
	 5MvPBu4Bs6WE3dzslyFy+pVhAV4c/7pQ7o489BhVYgkOzm9MIKsY9KLfx444+TLBZ4
	 W2IYd71Ikz2Sxxyy//4MA3B9EpkoHi5L6teebTOsRXOMpXuFdUhPpl35DYn5G4Jxkd
	 OQ7J7SgDnB78A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] Input: cm109 - fix double URB submission race conditions
Message-ID: <d5bb60c3-5026-495c-9b21-0e40cd3cc1a7@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 16 May 2026 15:03:31 +0000 (UTC)

An analysis of a kernel crash reveals a race condition in the cm109
input driver that leads to a double-add bug in the USB core's URB
enqueueing mechanism. The crash `list_add double add` occurs in
`usb_hcd_link_urb_to_ep()` when an URB is submitted while it is already
on the endpoint's queue.

In `drivers/input/misc/cm109.c`, the control URB (`dev->urb_ctl`) is
submitted in several places: `cm109_input_open()`,
`cm109_toggle_buzzer_async()`, and `cm109_submit_ctl()`.

There are two distinct race conditions that can lead to a double submit.
First, a race between `cm109_input_open()` and
`cm109_toggle_buzzer_async()`: because `cm109_input_ev()` does not check
if the device is actually open (`dev->open`), and `cm109_input_open()`
does not hold the `dev->ctl_submit_lock` when submitting the URB, these
two functions can race and call `usb_submit_urb(dev->urb_ctl)`
concurrently. Second, a race between `cm109_submit_ctl()` and
`cm109_toggle_buzzer_async()`: if `cm109_toggle_buzzer_async()` is
called while `dev->urb_irq` is in flight, it sees `dev->ctl_urb_pending
== 0`, sets it to 1, and submits `dev->urb_ctl`. When `dev->urb_irq`
completes, it calls `cm109_submit_ctl()`. However, `cm109_submit_ctl()`
does not check `dev->ctl_urb_pending` before submitting `dev->urb_ctl`,
leading to a double submit if the URB is already in flight.

To fix these bugs, we properly serialize URB submissions and state
changes using `dev->ctl_submit_lock`. We serialize URB submission in
`cm109_input_open()` by acquiring `dev->ctl_submit_lock` before
submitting the URB, and changing the memory allocation flag for
`usb_submit_urb()` from `GFP_KERNEL` to `GFP_ATOMIC`. We check
`dev->open` in `cm109_toggle_buzzer_async()` to prevent the event
handler from submitting URBs and restarting the polling loop when the
device is closed. We safely update the `dev->open` flag under the
`dev->ctl_submit_lock` in both `cm109_input_open()` and
`cm109_input_close()` to ensure perfect synchronization with the event
handler. Finally, we check `dev->ctl_urb_pending` in
`cm109_submit_ctl()` so that if `dev->ctl_urb_pending` is already 1,
`cm109_submit_ctl()` returns immediately to prevent a double submit and
to avoid modifying the transfer buffer (`dev->ctl_data`) while the URB
is in flight.

Fixes: c04148f915e5ba7947752e6348e0da4cdab1329e ("Input: add driver for USB VoIP phones with CM109 chipset")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+ac0f9c4cc1e034160492@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=ac0f9c4cc1e034160492
Link: https://syzkaller.appspot.com/ai_job?id=503e373b-527a-46df-8186-d6e665f95ffa
To: <linux-kernel@vger.kernel.org>
Cc: <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>

---
diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index 353d3c1d3..4479233d0 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -366,6 +366,9 @@ static void cm109_submit_ctl(struct cm109_dev *dev)
 	if (unlikely(dev->shutdown))
 		return;
 
+	if (dev->ctl_urb_pending)
+		return;
+
 	if (dev->buzzer_state)
 		dev->ctl_data->byte[HID_OR0] |= BUZZER_ON;
 	else
@@ -476,6 +479,9 @@ static void cm109_toggle_buzzer_async(struct cm109_dev *dev)
 {
 	guard(spinlock_irqsave)(&dev->ctl_submit_lock);
 
+	if (!dev->open)
+		return;
+
 	if (dev->ctl_urb_pending) {
 		/* URB completion will resubmit */
 		dev->buzzer_pending = 1;
@@ -562,15 +568,19 @@ static int cm109_input_open(struct input_dev *idev)
 		dev->ctl_data->byte[HID_OR2] = dev->keybit;
 		dev->ctl_data->byte[HID_OR3] = 0x00;
 
+		spin_lock_irq(&dev->ctl_submit_lock);
+		dev->open = 1;
 		dev->ctl_urb_pending = 1;
-		error = usb_submit_urb(dev->urb_ctl, GFP_KERNEL);
-		if (!error) {
-			dev->open = 1;
-			return 0;
+		error = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
+		if (error) {
+			dev->ctl_urb_pending = 0;
+			dev->open = 0;
 		}
-	}
+		spin_unlock_irq(&dev->ctl_submit_lock);
 
-	dev->ctl_urb_pending = 0;
+		if (!error)
+			return 0;
+	}
 	usb_autopm_put_interface(dev->intf);
 
 	dev_err(&dev->intf->dev, "%s: usb_submit_urb (urb_ctl) failed %d\n",
@@ -584,13 +594,16 @@ static void cm109_input_close(struct input_dev *idev)
 	struct cm109_dev *dev = input_get_drvdata(idev);
 
 	scoped_guard(mutex, &dev->pm_mutex) {
+		spin_lock_irq(&dev->ctl_submit_lock);
+		dev->open = 0;
+		spin_unlock_irq(&dev->ctl_submit_lock);
+
 		/*
 		 * Once we are here event delivery is stopped so we
 		 * don't need to worry about someone starting buzzer
 		 * again
 		 */
 		cm109_stop_traffic(dev);
-		dev->open = 0;
 	}
 
 	usb_autopm_put_interface(dev->intf);


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
