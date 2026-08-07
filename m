Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91ABF3DA5B4
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 04:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786078286; cv=none; b=XgRXyhlCd2hbyzSeeOWttJ13/AolQYqmbXvVvTryl/y5lb/fT2RH2bg8679il1MqSJ1vOV9ZhZrK6UrICAHrrNxYNWako++ewzqyFEHI//p3IOesQxhmLZrJAJDEkdtNw56VPTMGffTApssb/5lx0dNvWBXdIidlcO6VjIkUIGk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786078286; c=relaxed/simple;
	bh=+tA7Fxwis75c1n76Z1BokevVESaLbtMdpD6Q47sg6CQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=IWGQlTL3BCiqC9otV7Lmfg/JIVrvWnMmtPy5cROC6XZTodFp/19GVuE0SK/jQY7BXS2cTkBOTnRZngvgRaZBYVs3Ev+QvTC0e/9YrI99bUILpPIbjn+bb4SUZE4syJBA24QsfXjS6642H05K0f1x8KfngqNwFe72uqsQwHQbZ7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=STf5wikg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="STf5wikg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id D48E11F000E9;
	Fri,  7 Aug 2026 04:51:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786078268;
	bh=en2AlW7mmRmRkaGxud751sP1vUZ/JrVkAtGH4TnG2Fk=;
	h=From:To:Cc:Subject:Date;
	b=STf5wikgVdvgDS7AbWr9htp1xbTOc9YtI2tjRxhGgxku5f6mpnQUPrNSZlHnrD5G7
	 cYdmqKSnBMAdbUr31/sk8OCsAlvtDBXYtS7LCQqu2y2BllNnzg3YsdHbAl6XR0R+yW
	 VvUdSbZx/CpTUSfzcVNyKZHHiDBDkGvPAWT+1Zk1YaAUf+1yoH4g45zrUrqkyHSYvK
	 Kpwl4GEyGisNa1I0630HfOwLLNQ5pqOVjtln/v4FluO1jx/6svsezq4KeNO0sjedTT
	 ixz5i4HERoCN1zecfRC4nheZOLnmcPOlvCINyeYpI/TKLEaK2Am6SvNEPpTNdbN5ga
	 0sD3xxuyEzFPw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: dw2102: fix out-of-bounds read in dw2102_load_firmware
Message-ID: <af1420ef-107b-40f3-be7f-7720e4271a49@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 04:51:07 +0000 (UTC)

In dw2102_load_firmware(), the driver allocates a buffer for the firmware
and copies the firmware data into it. It then transfers the firmware to the
USB device in chunks of 64 bytes (0x40). However, if the firmware size is
not a multiple of 64, the last iteration of the loop will read past the end
of the allocated buffer, triggering a slab-out-of-bounds read.

Additionally, if the memory allocation for the firmware buffer fails, the
function skips the firmware loading block but still returns 0 (success)
instead of an error code.

Fix the out-of-bounds read by calculating the length of the current chunk
using min_t() to ensure that the transfer length never exceeds the
remaining bytes of the firmware. Also, handle the memory allocation failure
correctly by returning -ENOMEM, and use kmemdup() to simplify the
allocation and copying of the firmware data.

BUG: KASAN: slab-out-of-bounds in dw210x_op_rw+0xb6/0x180
drivers/media/usb/dvb-usb/dw2102.c:102
Read of size 64 at addr ffff8881913cfa20 by task kworker/1:4/5693

Call Trace:
 dw210x_op_rw+0xb6/0x180 drivers/media/usb/dvb-usb/dw2102.c:102
 dw2102_load_firmware+0x2b4/0x970 drivers/media/usb/dvb-usb/dw2102.c:1906
 dvb_usb_download_firmware+0x1c3/0x270
 drivers/media/usb/dvb-usb/dvb-usb-firmware.c:109
 dvb_usb_device_init+0xddf/0x2570
 drivers/media/usb/dvb-usb/dvb-usb-init.c:298
 dw2102_probe+0x8a/0x270 drivers/media/usb/dvb-usb/dw2102.c:2594
 usb_probe_interface+0x653/0xc60 drivers/usb/core/driver.c:396

Fixes: 7fd4828f6cc5 ("V4L/DVB (8421): Adds support for Dvbworld DVB-S 2102 USB card")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+f408eac9faa61d5a1927@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f408eac9faa61d5a1927
Link: https://syzkaller.appspot.com/ai_job?id=1984d3dc-3d19-4b09-98dd-b5151c7690f1
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Igor M Liplianin" <liplianin@me.by>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 4fecf2f96..50364a15d 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -1893,93 +1893,98 @@ static int dw2102_load_firmware(struct usb_device *dev,
 		break;
 	}
 	info("start downloading DW210X firmware");
-	p = kmalloc(fw->size, GFP_KERNEL);
+	p = kmemdup(fw->data, fw->size, GFP_KERNEL);
+	if (!p) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
 	reset = 1;
 	/*stop the CPU*/
 	dw210x_op_rw(dev, 0xa0, 0x7f92, 0, &reset, 1, DW210X_WRITE_MSG);
 	dw210x_op_rw(dev, 0xa0, 0xe600, 0, &reset, 1, DW210X_WRITE_MSG);
 
-	if (p) {
-		memcpy(p, fw->data, fw->size);
-		for (i = 0; i < fw->size; i += 0x40) {
-			b = (u8 *)p + i;
-			if (dw210x_op_rw(dev, 0xa0, i, 0, b, 0x40,
-					 DW210X_WRITE_MSG) != 0x40) {
-				err("error while transferring firmware");
-				ret = -EINVAL;
-				break;
-			}
-		}
-		/* restart the CPU */
-		reset = 0;
-		if (ret || dw210x_op_rw(dev, 0xa0, 0x7f92, 0, &reset, 1,
-					DW210X_WRITE_MSG) != 1) {
-			err("could not restart the USB controller CPU.");
-			ret = -EINVAL;
-		}
-		if (ret || dw210x_op_rw(dev, 0xa0, 0xe600, 0, &reset, 1,
-					DW210X_WRITE_MSG) != 1) {
-			err("could not restart the USB controller CPU.");
+	for (i = 0; i < fw->size; i += 0x40) {
+		int len = min_t(int, fw->size - i, 0x40);
+
+		b = (u8 *)p + i;
+		if (dw210x_op_rw(dev, 0xa0, i, 0, b, len,
+				 DW210X_WRITE_MSG) != len) {
+			err("error while transferring firmware");
 			ret = -EINVAL;
+			break;
 		}
-		/* init registers */
-		switch (le16_to_cpu(dev->descriptor.idProduct)) {
-		case USB_PID_TEVII_S650:
-			dw2104_properties.rc.core.rc_codes = RC_MAP_TEVII_NEC;
-			fallthrough;
-		case USB_PID_CYPRESS_DW2104:
-			reset = 1;
-			dw210x_op_rw(dev, 0xc4, 0x0000, 0, &reset, 1,
-				     DW210X_WRITE_MSG);
-			fallthrough;
-		case USB_PID_CYPRESS_DW3101:
-			reset = 0;
-			dw210x_op_rw(dev, 0xbf, 0x0040, 0, &reset, 0,
-				     DW210X_WRITE_MSG);
+	}
+	/* restart the CPU */
+	reset = 0;
+	if (ret || dw210x_op_rw(dev, 0xa0, 0x7f92, 0, &reset, 1,
+				DW210X_WRITE_MSG) != 1) {
+		err("could not restart the USB controller CPU.");
+		ret = -EINVAL;
+	}
+	if (ret || dw210x_op_rw(dev, 0xa0, 0xe600, 0, &reset, 1,
+				DW210X_WRITE_MSG) != 1) {
+		err("could not restart the USB controller CPU.");
+		ret = -EINVAL;
+	}
+	/* init registers */
+	switch (le16_to_cpu(dev->descriptor.idProduct)) {
+	case USB_PID_TEVII_S650:
+		dw2104_properties.rc.core.rc_codes = RC_MAP_TEVII_NEC;
+		fallthrough;
+	case USB_PID_CYPRESS_DW2104:
+		reset = 1;
+		dw210x_op_rw(dev, 0xc4, 0x0000, 0, &reset, 1,
+			     DW210X_WRITE_MSG);
+		fallthrough;
+	case USB_PID_CYPRESS_DW3101:
+		reset = 0;
+		dw210x_op_rw(dev, 0xbf, 0x0040, 0, &reset, 0,
+			     DW210X_WRITE_MSG);
+		break;
+	case USB_PID_TERRATEC_CINERGY_S:
+	case USB_PID_CYPRESS_DW2102:
+		dw210x_op_rw(dev, 0xbf, 0x0040, 0, &reset, 0,
+			     DW210X_WRITE_MSG);
+		dw210x_op_rw(dev, 0xb9, 0x0000, 0, &reset16[0], 2,
+			     DW210X_READ_MSG);
+		/* check STV0299 frontend  */
+		dw210x_op_rw(dev, 0xb5, 0, 0, &reset16[0], 2,
+			     DW210X_READ_MSG);
+		if ((reset16[0] == 0xa1) || (reset16[0] == 0x80)) {
+			dw2102_properties.i2c_algo = &dw2102_i2c_algo;
+			dw2102_properties.adapter->fe[0].tuner_attach = &dw2102_tuner_attach;
 			break;
-		case USB_PID_TERRATEC_CINERGY_S:
-		case USB_PID_CYPRESS_DW2102:
-			dw210x_op_rw(dev, 0xbf, 0x0040, 0, &reset, 0,
-				     DW210X_WRITE_MSG);
-			dw210x_op_rw(dev, 0xb9, 0x0000, 0, &reset16[0], 2,
-				     DW210X_READ_MSG);
-			/* check STV0299 frontend  */
-			dw210x_op_rw(dev, 0xb5, 0, 0, &reset16[0], 2,
-				     DW210X_READ_MSG);
-			if ((reset16[0] == 0xa1) || (reset16[0] == 0x80)) {
-				dw2102_properties.i2c_algo = &dw2102_i2c_algo;
-				dw2102_properties.adapter->fe[0].tuner_attach = &dw2102_tuner_attach;
-				break;
-			}
-			/* check STV0288 frontend  */
-			reset16[0] = 0xd0;
-			reset16[1] = 1;
-			reset16[2] = 0;
-			dw210x_op_rw(dev, 0xc2, 0, 0, &reset16[0], 3,
-				     DW210X_WRITE_MSG);
-			dw210x_op_rw(dev, 0xc3, 0xd1, 0, &reset16[0], 3,
-				     DW210X_READ_MSG);
-			if (reset16[2] == 0x11) {
-				dw2102_properties.i2c_algo = &dw2102_earda_i2c_algo;
-				break;
-			}
-			fallthrough;
-		case 0x2101:
-			dw210x_op_rw(dev, 0xbc, 0x0030, 0, &reset16[0], 2,
-				     DW210X_READ_MSG);
-			dw210x_op_rw(dev, 0xba, 0x0000, 0, &reset16[0], 7,
-				     DW210X_READ_MSG);
-			dw210x_op_rw(dev, 0xba, 0x0000, 0, &reset16[0], 7,
-				     DW210X_READ_MSG);
-			dw210x_op_rw(dev, 0xb9, 0x0000, 0, &reset16[0], 2,
-				     DW210X_READ_MSG);
+		}
+		/* check STV0288 frontend  */
+		reset16[0] = 0xd0;
+		reset16[1] = 1;
+		reset16[2] = 0;
+		dw210x_op_rw(dev, 0xc2, 0, 0, &reset16[0], 3,
+			     DW210X_WRITE_MSG);
+		dw210x_op_rw(dev, 0xc3, 0xd1, 0, &reset16[0], 3,
+			     DW210X_READ_MSG);
+		if (reset16[2] == 0x11) {
+			dw2102_properties.i2c_algo = &dw2102_earda_i2c_algo;
 			break;
 		}
-
-		msleep(100);
-		kfree(p);
+		fallthrough;
+	case 0x2101:
+		dw210x_op_rw(dev, 0xbc, 0x0030, 0, &reset16[0], 2,
+			     DW210X_READ_MSG);
+		dw210x_op_rw(dev, 0xba, 0x0000, 0, &reset16[0], 7,
+			     DW210X_READ_MSG);
+		dw210x_op_rw(dev, 0xba, 0x0000, 0, &reset16[0], 7,
+			     DW210X_READ_MSG);
+		dw210x_op_rw(dev, 0xb9, 0x0000, 0, &reset16[0], 2,
+			     DW210X_READ_MSG);
+		break;
 	}
 
+	msleep(100);
+	kfree(p);
+
+out:
 	if (le16_to_cpu(dev->descriptor.idProduct) == 0x2101)
 		release_firmware(fw);
 	return ret;


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
