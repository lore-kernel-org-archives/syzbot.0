Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 67B9C30E821
	for <syzbot@lists.linux.dev>; Thu, 21 May 2026 16:04:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779379485; cv=none; b=jTcLGJzFHRQaWGaQv0rMzeboGURzGD+ZZDXXmL7xonJVp3vGHHtmCVeKlPg4B3lAGng1Tmc6wmRzPTfDdhFugEOnA3hMNOxPDu0vte/0aHHK9FGXs+C1CheJXQGL3YqRYtafmKVAqKWA1Rwrolonro7kcJLsmx8IyUh/h9mRoys=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779379485; c=relaxed/simple;
	bh=WUdBJlMLANZRXCJwmpaT15G4cwJK5V09+U2l0obl79I=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=SVKAZm9HB3DmhUHSobeH7RDtMLApdTorp7ZO9eq5Htlyu/AL8j8fQrrc7Yr8uSx6ZUJC/Gk4uV+JXSytyJhJP4F75OOz4FPeBmTVZF6bSK49JPc1vz2y+gNwOfj79crv2Cvs6ofPBW3shTHdVVpHI/W+w8D6P4kMsh/bzuTFcCA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZDW7GgnM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZDW7GgnM"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 327A71F000E9;
	Thu, 21 May 2026 16:04:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779379484;
	bh=thXmwKnGJPohbzV6eGTOXN+s2qyYI2jVEcmCNOdmzYs=;
	h=From:To:Cc:Subject:Date;
	b=ZDW7GgnMr1v85tjEAv2o0RMBisAHYYQrI7A9ifZ01ad2pM4t1jMTY7qkPkh6w/yVN
	 Il8FldbqQMQ0Q+eHLIvwVbrV0spxWjiqurIo+Sx0ZZ6KqdZvcCGgu0UkK6e9Rh8K8b
	 U/rfNy0JOWAyFxhafMie5Rhbp8qw1A+3RnjM6j4I5veNzLeUWVBYviFFkEaVk4uMId
	 ktZe+4kxrBOIpRv8ik3orUWaq6Y8HIroAzMvidexXt7lM7x9mwkiOpleEJWzjkZHaV
	 sR7Gn/DhG4RnD7dUrBLqdETy/KO7PN4D3I2Obwq2FCOY0lWA5Bc8PbFGxtq1dmhYGW
	 kKwNVk+cvvvmg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v3] Input: cm109 - prevent concurrent control URB submissions
Message-ID: <87447094-7113-47af-8b64-e30497fd5ba7@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Thu, 21 May 2026 16:04:44 +0000 (UTC)

The cm109 driver uses two URBs to communicate with the device: urb_ctl
(Control OUT) and urb_irq (Interrupt IN). These URBs are designed to run
in a continuous, strictly alternating loop. However, the driver also
supports sound events to toggle the buzzer via
cm109_toggle_buzzer_async(), which can submit urb_ctl out-of-band. If
this occurs while urb_irq is completing and triggering
cm109_submit_ctl(), the USB core issues a warning because urb_ctl is
already active.

To fix this, check if dev->ctl_urb_pending is already set in
cm109_submit_ctl(). If it is, defer the submission by setting
dev->buzzer_pending = 1 and return immediately.

The cm109_submit_buzz_toggle() function is updated to also copy the
latest dev->keybit to HID_OR1 and HID_OR2. This is correct for all
callers because these bytes select the key matrix column; maintaining
the current keybit ensures that key scanning is not interrupted or
corrupted during a buzzer toggle. Since cm109_submit_ctl() and
cm109_submit_buzz_toggle() now prepare the same data, cm109_submit_ctl()
is refactored to call cm109_submit_buzz_toggle().

If usb_submit_urb() fails in cm109_submit_buzz_toggle(),
dev->ctl_urb_pending is now reset to 0. This is necessary because a
failed submission means the URB is not active; failing to reset the flag
would prevent any future control URB submissions, effectively
deadlocking the control path.

A simple check of dev->ctl_urb_pending in cm109_submit_ctl() would be
insufficient on its own because it does not handle the synchronization
of the buzzer state and key scanning matrix across different submission
paths. Refactoring the data preparation ensures that the latest state is
always used regardless of which path triggers the submission.

Fixes: d8a43a83633a ("Input: cm109 - use guard notation when acquiring mutex and spinlock")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+2d6d691af5ab4b7e66df@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=2d6d691af5ab4b7e66df
Link: https://syzkaller.appspot.com/ai_job?id=f1927a5a-2a76-4023-a76f-6461ce28d254
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: <linux-input@vger.kernel.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Prevent concurrent control URB submissions by checking ctl_urb_pending in cm109_submit_ctl().
- Defer buzzer updates if a control URB is already in flight.
- Update cm109_submit_buzz_toggle() to include key matrix state (keybit) to ensure consistent key scanning.
- Reset ctl_urb_pending on URB submission failure to avoid deadlocking the control path.
- Refactor cm109_submit_ctl() to use the updated cm109_submit_buzz_toggle() for unified data preparation.

v2:
- Reset `dev->ctl_urb_pending` to 0 if `usb_submit_urb()` fails in `cm109_submit_buzz_toggle()`.
https://lore.kernel.org/all/e6a66888-9f57-4c38-9732-2563acc3ed73@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/cac82e3e-7e75-4dc6-b83b-5b54a3e692e7@mail.kernel.org/T/
---
diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index 353d3c1d3..8e51ad58f 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -348,17 +348,20 @@ static void cm109_submit_buzz_toggle(struct cm109_dev *dev)
 	else
 		dev->ctl_data->byte[HID_OR0] &= ~BUZZER_ON;
 
+	dev->ctl_data->byte[HID_OR1] = dev->keybit;
+	dev->ctl_data->byte[HID_OR2] = dev->keybit;
+
 	error = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
-	if (error)
+	if (error) {
 		dev_err(&dev->intf->dev,
 			"%s: usb_submit_urb (urb_ctl) failed %d\n",
 			__func__, error);
+		dev->ctl_urb_pending = 0;
+	}
 }
 
 static void cm109_submit_ctl(struct cm109_dev *dev)
 {
-	int error;
-
 	guard(spinlock_irqsave)(&dev->ctl_submit_lock);
 
 	dev->irq_urb_pending = 0;
@@ -366,22 +369,15 @@ static void cm109_submit_ctl(struct cm109_dev *dev)
 	if (unlikely(dev->shutdown))
 		return;
 
-	if (dev->buzzer_state)
-		dev->ctl_data->byte[HID_OR0] |= BUZZER_ON;
-	else
-		dev->ctl_data->byte[HID_OR0] &= ~BUZZER_ON;
-
-	dev->ctl_data->byte[HID_OR1] = dev->keybit;
-	dev->ctl_data->byte[HID_OR2] = dev->keybit;
+	if (dev->ctl_urb_pending) {
+		dev->buzzer_pending = 1;
+		return;
+	}
 
 	dev->buzzer_pending = 0;
 	dev->ctl_urb_pending = 1;
 
-	error = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
-	if (error)
-		dev_err(&dev->intf->dev,
-			"%s: usb_submit_urb (urb_ctl) failed %d\n",
-			__func__, error);
+	cm109_submit_buzz_toggle(dev);
 }
 
 /*


base-commit: 7fd2df204f342fc17d1a0bfcd474b24232fb0f32
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it (or '#syz unreject' to undo).

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
