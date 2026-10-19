Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792424706;
	b=tdaHJDtA67YcjnJXACexiq5sC3KKwT3mZRxkMQ+7HQpLne25ZGGGkV1D4SkN04ZZ/5/A
	 hWgGn1C+GgPnb4iZ4qIOJ6NQQYzRQcVT7S6x3NA5PxmOZ3Iy+DmpVY+E/NYU7OKS/EhMH
	 y1Ox86YCdtXOI0ziyb0Ko3z6X3eQ0nPx+LubLvSLNbd0eKHqLtTOm+z4e2XMK9HSwjyPM
	 15/AkumusBuYTeQ2gcKowVsEPDAzhstnPVcEXgf9iVXiXHppGLXHT8Cswe2b21Qe5DhP3
	 dKZLMk2L8Izdi6a6dlkTWJcGSNPudSQaz4CXXxDaYjDSRKKaP8MHzCEpBTnzviABObw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792424706;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=YChTk36msbEq+mMlqPRFsKar6hurLwfpVpmLf1Nmyh8=;
	b=gJ2BXDbN4/QOeeymow4AxWTIq0gd5LTLl8kGXro4imV3VF/gPIsyJ0GwEsaeqJ2ViYFC
	 KnMMv0KZO6qjpQSXWkdmN404Pp4KTsD4GnGp+xsY4M1LIeN7UzHuaw2zIdDPBdDGVMeMH
	 yl+wpt6gm6n1LUbhZhUvHhnXg5UHNF47KVYXe8XbA9/aSZatAYNt58x9CglPRYPBHuF0f
	 QgVZ88BvlpEadtFLDpOOHMf0x3VNHnPM2yWdpkajG1C5bv099D1lzh6Z5gG5xQ9EZsQs8
	 dXs0MZZVyvB3j70S6RLqZchtiWtDylrxXv+KAVbIFqqCvBcLyH+6Ue2ej4xdziq3gdw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WxDbBbRC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 4A5896078860
	for <syzbot@lists.linux.dev>; Mon, 19 Oct 2026 15:45:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=WxDbBbRC
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1E6EE1F000CE;
	Mon, 19 Oct 2026 15:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792424705;
	bh=YChTk36msbEq+mMlqPRFsKar6hurLwfpVpmLf1Nmyh8=;
	h=From:To:Cc:Subject:Date;
	b=WxDbBbRC4KAMWYCMDVvfmuNku4YjKfvMDgf+YxLxysxRYRN+Xls5Q5pNRiNqFCjgj
	 HKPft8Ps+tjJ6A5M+bEhRtwmBfidYDKyaBzWnqB+tKOnxx1skbUwHgsx1aKHhSJBLH
	 jINJRMw9qU17Oo8WNPmFBxVZZGomohyvjN4zfAESB25ZUMJ3lHlziBMNCVYezxj0zk
	 dMNoLw6m4yzDGaaw0gDyFTGwNqfMGcN65TVonmbszNQAPcXNn03z8xEaaPuj7sRiOt
	 4n5OrAmFEsbdEx5oBYurpL3LRuEkJlgLfUPi6fZgvpukJ9aV1EStoY6qE2HmIO0utm
	 uaDadNl4Q0mjw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: mxl111sf: initialize state->d and fe_lock in probe
Message-ID: <b8b6fc2d-1c9a-4046-bba5-c9ef864bfae3@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 19 Oct 2026 15:45:05 +0000 (UTC)

During device initialization in dvb_usbv2_probe(), the dvb-usb-v2 core
allocates the dvb_usb_device structure and its private state (struct
mxl111sf_state) via kzalloc(), then invokes dvb_usbv2_init(). Within
dvb_usbv2_init(), dvb_usbv2_i2c_init() registers the I2C adapter with
i2c_add_adapter(), which immediately exposes the I2C adapter to userspace
via the /dev/i2c-X character device.

However, state->d was only assigned later during frontend attachment inside
dvb_usbv2_adapter_frontend_init() via d->props->frontend_attach(). If
userspace performs an I2C transaction before frontend_attach() completes,
mxl111sf_i2c_xfer() delegates to mxl111sf_ctrl_msg(), which reads state->d
and passes it to dvb_usbv2_generic_write() or dvb_usbv2_generic_rw(). Since
state->d is still NULL, dereferencing &d->usb_mutex inside
dvb_usbv2_generic_write() triggers a null-pointer dereference crash:

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000018: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x00000000000000c0-0x00000000000000c7]
RIP: 0010:__mutex_lock_common kernel/locking/mutex.c:625 [inline]
RIP: 0010:__mutex_lock+0x149/0x1550 kernel/locking/mutex.c:821
Call Trace:
 <TASK>
 dvb_usbv2_generic_write+0x26/0x60
 drivers/media/usb/dvb-usb-v2/dvb_usb_urb.c:77
 mxl111sf_ctrl_msg+0x160/0x2f0 drivers/media/usb/dvb-usb-v2/mxl111sf.c:73
 mxl111sf_write_reg+0xa9/0x1b0 drivers/media/usb/dvb-usb-v2/mxl111sf.c:123
 mxl111sf_i2c_start drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c:130
 [inline]
 mxl111sf_i2c_sw_xfer_msg drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c:-1
 [inline]
 mxl111sf_i2c_xfer+0x463/0x5060
 drivers/media/usb/dvb-usb-v2/mxl111sf-i2c.c:813
 __i2c_transfer+0x7bf/0x1fe0 drivers/i2c/i2c-core-base.c:-1
 i2c_transfer+0x1cb/0x2d0 drivers/i2c/i2c-core-base.c:2350
 i2cdev_ioctl_rdwr+0x460/0x740 drivers/i2c/i2c-dev.c:306
 i2cdev_ioctl+0x6a5/0x880 drivers/i2c/i2c-dev.c:467
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x166/0x520 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Additionally, state->fe_lock was initialized in mxl111sf_init() (called via
d->props->init()), which runs after frontend attachment, leaving the mutex
uninitialized during frontend registration.

Fix this by setting state->d = dev and initializing state->fe_lock in
mxl111sf_probe(), which runs before dvb_usbv2_init() registers the I2C
adapter or attaches frontends. Furthermore, remove the redundant
mutex_init(&state->fe_lock) from mxl111sf_init() and the redundant
assignments of state->d in the frontend attach functions.

Fixes: 8572211842af ("[media] mxl111sf: convert to new DVB USB")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+f9f5333782a854509322@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f9f5333782a854509322
Link: https://syzkaller.appspot.com/ai_job?id=0eff5308-2f93-4b3a-b8d1-021ddc25aa49
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Michael Krufky" <mkrufky@linuxtv.org>
To: "Antti Palosaari" <crope@iki.fi>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/usb/dvb-usb-v2/mxl111sf.c b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
index 6404eb74d..fc4010b6e 100644
--- a/drivers/media/usb/dvb-usb-v2/mxl111sf.c
+++ b/drivers/media/usb/dvb-usb-v2/mxl111sf.c
@@ -431,8 +431,6 @@ static int mxl111sf_lgdt3305_frontend_attach(struct dvb_usb_adapter *adap, u8 fe
 
 	pr_debug("%s()\n", __func__);
 
-	/* save a pointer to the dvb_usb_device in device state */
-	state->d = d;
 	adap_state->alt_mode = (dvb_usb_mxl111sf_isoc) ? 2 : 1;
 	state->alt_mode = adap_state->alt_mode;
 
@@ -502,8 +500,6 @@ static int mxl111sf_lg2160_frontend_attach(struct dvb_usb_adapter *adap, u8 fe_i
 
 	pr_debug("%s()\n", __func__);
 
-	/* save a pointer to the dvb_usb_device in device state */
-	state->d = d;
 	adap_state->alt_mode = (dvb_usb_mxl111sf_isoc) ? 2 : 1;
 	state->alt_mode = adap_state->alt_mode;
 
@@ -587,8 +583,6 @@ static int mxl111sf_lg2161_frontend_attach(struct dvb_usb_adapter *adap, u8 fe_i
 
 	pr_debug("%s()\n", __func__);
 
-	/* save a pointer to the dvb_usb_device in device state */
-	state->d = d;
 	adap_state->alt_mode = (dvb_usb_mxl111sf_isoc) ? 2 : 1;
 	state->alt_mode = adap_state->alt_mode;
 
@@ -674,8 +668,6 @@ static int mxl111sf_lg2161_ep6_frontend_attach(struct dvb_usb_adapter *adap, u8
 
 	pr_debug("%s()\n", __func__);
 
-	/* save a pointer to the dvb_usb_device in device state */
-	state->d = d;
 	adap_state->alt_mode = (dvb_usb_mxl111sf_isoc) ? 2 : 1;
 	state->alt_mode = adap_state->alt_mode;
 
@@ -749,8 +741,6 @@ static int mxl111sf_attach_demod(struct dvb_usb_adapter *adap, u8 fe_id)
 
 	pr_debug("%s()\n", __func__);
 
-	/* save a pointer to the dvb_usb_device in device state */
-	state->d = d;
 	adap_state->alt_mode = (dvb_usb_mxl111sf_isoc) ? 1 : 2;
 	state->alt_mode = adap_state->alt_mode;
 
@@ -935,8 +925,6 @@ static int mxl111sf_init(struct dvb_usb_device *d)
 	if (mxl_fail(ret))
 		pr_err("failed to get chip info during probe");
 
-	mutex_init(&state->fe_lock);
-
 	if (state->chip_rev > MXL111SF_V6)
 		mxl111sf_config_pin_mux_modes(state, PIN_MUX_TS_SPI_IN_MODE_1);
 
@@ -1068,7 +1056,9 @@ static int mxl111sf_probe(struct dvb_usb_device *dev)
 {
 	struct mxl111sf_state *state = d_to_priv(dev);
 
+	state->d = dev;
 	mutex_init(&state->msg_lock);
+	mutex_init(&state->fe_lock);
 	return 0;
 }
 


base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
