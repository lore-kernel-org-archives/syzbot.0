Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 30F203B637A
	for <syzbot@lists.linux.dev>; Wed, 20 May 2026 22:34:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779316492; cv=none; b=CuSHKGM5opOR/L1cMSN/iEI7t7tcK09I/njQl2Sy1pk7tOkwIqhhlQzqEV/ABRr1b8Jqr5YJFG0pxcG6hX6WpmL0pjIry4EdNeiAJq+BOOHPeTQYfxtFM13q+cK8hT0jSVCO3plYogFwOleHmDQg9BHCieyqUok9QOK4v89Q3PI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779316492; c=relaxed/simple;
	bh=+msAqIPmT1/lxno+BaFI6VMfDIB1r7sHV+0rdZRONiY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=CvGbiXu4Rtn97oc8oEn86ff0BwaQ/S9A6txnF0BaI5J5p1Lf5k3C5rZ2FZcOEEpjBteZCA06HHBP3o1gnmjOEjW0u+btoUNcgFsvgY7Q2NnWY8FlH29Tj7KITHJm0AJrhkEoJcybM+G68jNMB5ybmtXNR1vB0iSKTOC5nUq+PBc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Crl8zIa9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Crl8zIa9"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9D0D31F000E9;
	Wed, 20 May 2026 22:34:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779316490;
	bh=LfUVatsOvcUKrG/fGtSIVYITPSSFt9kiGdUlxFfkSzA=;
	h=From:To:Cc:Subject:Date;
	b=Crl8zIa9dk1KzCi0xNYajeX1a3ktFPlcCDVs/qjc+hR5ERSs1bP020iMm/yh06tqG
	 a27j+S3vt6c0LnPkVJ+RUtGpL0uH0qdUFGZcMX3YYKMYvLT82R+0cECiyPsMO4RZsj
	 1RVxlubb7bogm2YrYo4Q0/LCjhBKlcboY73XnDIJ0+MrdJ+V4a7AGxXoQAbJXNrY3S
	 IzqF+4RjIC8s13MSk9bomnvLwedG4Wms79Mz1rAqQJrnGZoOKzAtaBZxTnn0uFEGOw
	 l6L04EXzVtMt3pUWGkLa7PpsAYIMuan4khOV5WKJylW0zZBiE6TPg2yU0rzeeyumxq
	 pOp7gSaFw5cuw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] Input: cm109 - fix URB submitted while active and DMA race
Message-ID: <e5967266-0a89-43bd-b1d1-663236028cf8@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 20 May 2026 22:34:50 +0000 (UTC)

The cm109 driver uses two URBs to communicate with the device: an
interrupt IN URB (`urb_irq`) to read the key matrix state, and a control
OUT URB (`urb_ctl`) to send commands like toggling the buzzer and
selecting the next key matrix column to scan. Normally, these two URBs
strictly alternate in a ping-pong fashion.

However, `cm109_toggle_buzzer_async()` can be called at any time (e.g.,
from an input event). If it is called while `urb_irq` is active, it sees
that `urb_ctl` is not pending, sets the flag to 1, and submits
`urb_ctl`. At this point, both URBs are active. When `urb_irq`
subsequently completes, `cm109_urb_irq_callback()` calls
`cm109_submit_ctl()`, which unconditionally submits `urb_ctl` without
checking if it is already active. This causes `usb_submit_urb()` to fail
with a "URB submitted while active" warning. Additionally, because
`cm109_submit_ctl()` modifies the transfer buffer (`dev->ctl_data`)
without checking if `urb_ctl` is active, it causes a DMA race condition.

Fix this by updating `cm109_submit_ctl()` to check
`dev->ctl_urb_pending`. If the control URB is already active, defer the
submission by setting `dev->buzzer_pending = 1` and returning
immediately. To handle the deferred submission properly, rename
`cm109_submit_buzz_toggle()` to `cm109_issue_ctl_urb()` and modify it to
update both the buzzer state and the key matrix column before submitting
the URB. This ensures we never submit an active URB and completely
eliminates the DMA race condition by moving the buffer modification into
`cm109_issue_ctl_urb()`, which is only called when the URB is idle.

Fixes: c04148f915e5 ("Input: add driver for USB VoIP phones with CM109 chipset")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+c708736c2ec142a386fd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=c708736c2ec142a386fd
Link: https://syzkaller.appspot.com/ai_job?id=425b65ed-4a41-42c4-8f95-8672ffd691e0
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: <linux-input@vger.kernel.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index 353d3c1d3..547aa1448 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
@@ -339,7 +339,7 @@ static void cm109_report_special(struct cm109_dev *dev)
  * CM109 usb communication interface
  *****************************************************************************/
 
-static void cm109_submit_buzz_toggle(struct cm109_dev *dev)
+static void cm109_issue_ctl_urb(struct cm109_dev *dev)
 {
 	int error;
 
@@ -348,6 +348,9 @@ static void cm109_submit_buzz_toggle(struct cm109_dev *dev)
 	else
 		dev->ctl_data->byte[HID_OR0] &= ~BUZZER_ON;
 
+	dev->ctl_data->byte[HID_OR1] = dev->keybit;
+	dev->ctl_data->byte[HID_OR2] = dev->keybit;
+
 	error = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
 	if (error)
 		dev_err(&dev->intf->dev,
@@ -357,8 +360,6 @@ static void cm109_submit_buzz_toggle(struct cm109_dev *dev)
 
 static void cm109_submit_ctl(struct cm109_dev *dev)
 {
-	int error;
-
 	guard(spinlock_irqsave)(&dev->ctl_submit_lock);
 
 	dev->irq_urb_pending = 0;
@@ -366,22 +367,14 @@ static void cm109_submit_ctl(struct cm109_dev *dev)
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
-
-	error = usb_submit_urb(dev->urb_ctl, GFP_ATOMIC);
-	if (error)
-		dev_err(&dev->intf->dev,
-			"%s: usb_submit_urb (urb_ctl) failed %d\n",
-			__func__, error);
+	cm109_issue_ctl_urb(dev);
 }
 
 /*
@@ -460,7 +453,7 @@ static void cm109_urb_ctl_callback(struct urb *urb)
 	if (dev->buzzer_pending || status) {
 		dev->buzzer_pending = 0;
 		dev->ctl_urb_pending = 1;
-		cm109_submit_buzz_toggle(dev);
+		cm109_issue_ctl_urb(dev);
 	} else if (likely(!dev->irq_urb_pending)) {
 		/* ask for key data */
 		dev->irq_urb_pending = 1;
@@ -481,7 +474,7 @@ static void cm109_toggle_buzzer_async(struct cm109_dev *dev)
 		dev->buzzer_pending = 1;
 	} else {
 		dev->ctl_urb_pending = 1;
-		cm109_submit_buzz_toggle(dev);
+		cm109_issue_ctl_urb(dev);
 	}
 }
 


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
