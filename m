Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74AFC31E85E
	for <syzbot@lists.linux.dev>; Sat, 16 May 2026 18:24:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778955845; cv=none; b=s7iEnavfWJf4pO8c6GVN90ZMWl5dCSaxd1h2/8Z2ceDWj5bFFtnq4XeLLt2ZIaSf1RMx3M3eqNRhJiecezfGCIv8zWpRIAC/hO/A5YLQuU0HWUF3s8G+Hd0Xu/1d4LlQSnm6KM10Yum5sWXI485/kP1LNRXB3+PRQCVSh7CgTAk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778955845; c=relaxed/simple;
	bh=sUQmf6xn+kTDm5xk3mGpd/wU6wvNqmx1PM9oTt0/P28=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=St/mQCjEzg8aq2RsFzj5oSOGelw1yEVwq4+axKmR7oV8rIYspX6y/xlXKDXtNJgSXy01Q6YMRQnv51bvrEDL8N0z3eo7dhNhS5tGZ1ZUxXd/O1PkJiJpzZdfqNGr5KGw8PagfBdix4TCzMOLLyICeo+VvRWhe/BAcJBTJpYcRiQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SHjZIMeE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SHjZIMeE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 10A13C19425;
	Sat, 16 May 2026 18:24:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1778955845;
	bh=sUQmf6xn+kTDm5xk3mGpd/wU6wvNqmx1PM9oTt0/P28=;
	h=From:To:Cc:Subject:Date:From;
	b=SHjZIMeEZYRNrjYrK3uTpEIrx0m6S3zwypfuJ6omLow0x9jGliBFAFmSvFYaoc4vD
	 0aKYVAbAZ4ty2zArYiet58GalawLLJ1QBDUSRnuw1FcEqKAK7muDJoG6+uLWYszzEJ
	 LMRzEOC3ytK0FnmpRgzc0UaKnic8avnJ+GNo2I2dUfjUPIFYyXzErDoXrdlMTWkM7v
	 DDZaoCE0TJ99NmeSoQ9sEZBArWwIf+1JWaWNWGS3gfDFnpj9s3FgetLYJYCZEJVSR0
	 M+xHvYYjmajqbFshLgNYwrGnbrf5QuGwIIpiC9Z4yXl4GdyrLXwaicufNCD/n8bIxK
	 LnUYvCtfyHwVg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] Input: cm109 - prevent concurrent control URB submissions
Message-ID: <e6a66888-9f57-4c38-9732-2563acc3ed73@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat, 16 May 2026 18:24:05 +0000 (UTC)

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

Fixes: d8a43a83633a4770f00ee77079fbb7a2218cea2a ("Input: cm109 - use guard notation when acquiring mutex and spinlock")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+2d6d691af5ab4b7e66df@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=2d6d691af5ab4b7e66df
Link: https://syzkaller.appspot.com/ai_job?id=ca80d200-7e54-4431-b367-300f0488c403
To: <linux-kernel@vger.kernel.org>
Cc: <dmitry.torokhov@gmail.com>
Cc: <linux-input@vger.kernel.org>

---
v2:
- Reset `dev->ctl_urb_pending` to 0 if `usb_submit_urb()` fails in `cm109_submit_buzz_toggle()`.

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
Reply with '#syz reject' to reject it.

See  for more information.
