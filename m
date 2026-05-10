Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CB9425A642
	for <syzbot@lists.linux.dev>; Sun, 10 May 2026 20:39:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778445578; cv=none; b=rP9JBabycGYzYZakEQaX5sUdrys/y8/u8lqQlwJIzSoJItWVSL7Ng96wofb2Cw+Qlzg2sUYG8zZ7eQme8WeH8+Jcbvto1mHL6115RxYehCji6xH/J1pKmVT6a/nEkzYyeEqXTMdai/7p6oEwHEqf25xuKw+G8zfsJvS9JaosGgM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778445578; c=relaxed/simple;
	bh=duvjasXOg09ntwFVHXd4PKzpRh6RvcZLP+rB0vmmcGI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=XPK+L2CyC6+dvoqjFn9jN9uMfpPkUMZ2iY+QvrBPkp0r1GMESoMj1G5vRFKnVyIJXk0PEDZ0kwArp9Tna4SdTjjCRjbaTqV3/z6gj2op8RZ6RWNPmfWpLRdE1T6jVTgVqRA1Z+IucoZestzFOAbuL6g1uGGh3pxS32PFEqLEdtE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnW+Xmri; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnW+Xmri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1031C2BCB8;
	Sun, 10 May 2026 20:39:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778445577;
	bh=duvjasXOg09ntwFVHXd4PKzpRh6RvcZLP+rB0vmmcGI=;
	h=From:To:Cc:Subject:Date:From;
	b=SnW+XmrigZxk1F13gXifR+fmPvsBlnT2hUpu29yeUHWcrB9/Fir3kDgVrQSXYviS4
	 QxuT7Da0onmA3swFy6n46LXPbXiAwgzVXh7mg2HvpITKSpjAj/I47tjWpUDRXy0ZK2
	 SyMcOgvRftnG+OVImAGcOKIe+6vuOblCF4hry4BY4Ijh9cZDr9cWj1eegk+yQimWbi
	 8Lo2DI9e61oGvp1Cy58qTz4HTFTXGAdkcHE70aKHGssqhvsWOqUmQ9Dc/mWLBh3PS/
	 Dgf8YTxZUBZImilybYpWe8bHctlMz8qR3W9mzIvMYoSVzWdeQQXXLaaLbIcyRe0WfE
	 2bGm9OHnBAXGw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] Input: cm109 - prevent concurrent control URB submissions
Message-ID: <cac82e3e-7e75-4dc6-b83b-5b54a3e692e7@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun, 10 May 2026 20:39:37 +0000 (UTC)

Input: cm109 - prevent concurrent control URB submissions

The cm109 driver uses two URBs to communicate with the device: urb_ctl
(Control OUT) and urb_irq (Interrupt IN). These URBs are designed to run
in a continuous, strictly alternating loop.

However, the driver also supports sound events to toggle the buzzer.
When a sound event is received, cm109_toggle_buzzer_async() is called.
If urb_ctl is not currently pending, it immediately submits urb_ctl
out-of-band to update the buzzer state. This breaks the strict
alternation and causes both urb_irq and urb_ctl to be active
concurrently.

When urb_irq subsequently completes, cm109_urb_irq_callback() calls
cm109_submit_ctl(). cm109_submit_ctl() blindly assumes urb_ctl is idle,
updates the DMA buffer, and calls usb_submit_urb(dev->urb_ctl). Since
urb_ctl is already active, the USB core catches it and triggers the
"URB submitted while active" warning.

To fix this, check if dev->ctl_urb_pending is already set in
cm109_submit_ctl(). If it is, defer the submission by setting
dev->buzzer_pending = 1 and return immediately.

Additionally, update cm109_submit_buzz_toggle() to also copy the latest
dev->keybit to HID_OR1 and HID_OR2, ensuring that the deferred key
matrix column update is not lost. Since cm109_submit_ctl() and
cm109_submit_buzz_toggle() now prepare the exact same data for urb_ctl,
refactor cm109_submit_ctl() to simply call cm109_submit_buzz_toggle()
after checking and updating the pending flags.

Assisted-by: Gemini:gemini-3.1-pro-preview
To: <linux-kernel@vger.kernel.org>
Cc: <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>

---
diff --git a/drivers/input/misc/cm109.c b/drivers/input/misc/cm109.c
index 353d3c1d3..0114d7293 100644
--- a/drivers/input/misc/cm109.c
+++ b/drivers/input/misc/cm109.c
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
@@ -366,22 +367,15 @@ static void cm109_submit_ctl(struct cm109_dev *dev)
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
Reply with '#syz reject' to reject it.

See  for more information.
