Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793886887;
	b=bZrREil46kP7ZvS2Y3gZ/xlCkkzi5EgPIQDF07oU2Dm4O4/8vR75rYQVvJ623qScTjm/
	 trHIkXNw0KhdZhIQ7Bf3tDo6DMUIuM1Vxb6F43ELTOwBdumj5OZKFAjwbv89ey+StuTZY
	 TYjnzNQm5f1lj4sqNIikPUn8onDziDXzKe0U0CBJAyrbUoRGcjflxfWZHcbB1idX4skvW
	 DrgA2oQfuQ3AWlXBg3+HJgJHxofB0zixXTO6Kev2Txf12/IgN0gKSTRGRm4MH5ltTriuI
	 nzREP9ZlBtm9/69mi7TUUGIquBQXdUdhu6i7Aynk0bIj//s+JFcyYPZQEFOUqyLJmcw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793886887;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=wbjU5Q5NYsHIFG5a0tDHC7IBwLiwwg5mEeAwNfGe8tQ=;
	b=i7Qf37RguH+GKoYexFGHR35LaItD8ESXsjDPB8lsNDpTDVx4Bj/GZmZGWosB+R0JbJt0
	 8K0C6t27zYNHQN0VemTO8H+Hxi/apov4fpP+rDzKK6PyB//p6nQr0jZhZrtNRqV0a8dfX
	 s0ZIBpJ1ziESkYH4q15Xwksn50rTToepV+3eFe1rmqiAuZdjF5upj0er9q2Yh+GV8zfoZ
	 T6TUdyVoeU7DqtRz3KMr+orsP5tI6PzXKK0RDZxmHM7nnDN+7Pbm+fmaKFVz16lV9MxB3
	 tKejyxF7IpJ9aSOq0aU7wO2hbzIMUuKdHDQtEHwJ3JANYG/WUpVZcZMZUgvB7gE0XhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DnS6EVHw;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id C2EE6606A31B;
	Thu,  5 Nov 2026 13:54:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=DnS6EVHw
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1AD921F000C1;
	Thu,  5 Nov 2026 13:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1793886886;
	bh=wbjU5Q5NYsHIFG5a0tDHC7IBwLiwwg5mEeAwNfGe8tQ=;
	h=From:To:Cc:Subject:Date;
	b=DnS6EVHwQUkeqd/0GuG/Dn30deuFJ6/b234JECseZcoDE2LQN/RtlEkfLdhZqnnVo
	 eu2l7VEOcAOlSG9x4XB0rFxjj+4qsYmtzSdU9tx1HrQ4H0zFeYJhxcbE7jjeWgio/m
	 XsalT1nWoZy9EfkBWwm5sKwB6KdyKq8jNmA7f5hI8YW2w7c56eN0ZcLQ5XepaECvSq
	 suppwqx+29aC9jQ1BFu8JABISXFPlsZCoVbA4Lw0niDyivyUPUHnK3j9ea+4HX4OmT
	 pGFx4sYDyEy3kxGk888CeOITS9B72WJv+xHtsHJ+wnX6TrmTpucAHwr9LCafZmEWB5
	 pMJS4tVSMHkOA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>, <linux-media@vger.kernel.org>, "Mauro Carvalho Chehab" <mchehab@kernel.org>, "Michael Krufky" <mkrufky@linuxtv.org>, "Michael Krufky" <mkrufky@kernellabs.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] media: mxl111sf: initialize state->d and fe_lock in probe
Message-ID: <7cbccdb8-870c-46c4-bc61-2e40d8c4b4db@mail.kernel.org>
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
Date: Thu,  5 Nov 2026 13:54:46 +0000 (UTC)

From: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>

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
dvb_usbv2_generic_write() triggers a null-pointer dereference crash.
Although the crash report was captured in compat mode with PTI, the failure
is illustrated by the following x64/NOPTI trace:

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
uninitialized during frontend registration. Although the reported I2C fault
does not demonstrate a frontend lock race, fe_lock should also be
initialized before frontend registration.

Fix this by setting state->d = dev and initializing state->fe_lock in
mxl111sf_probe(), which runs before dvb_usbv2_init() registers the I2C
adapter or attaches frontends. Furthermore, remove the redundant
mutex_init(&state->fe_lock) from mxl111sf_init() and the redundant
assignments of state->d in the frontend attach functions.

Fixes: 4c66c9205c07 ("[media] dvb-usb: add ATSC support for the Hauppauge WinTV-Aero-M")
Assisted-by: Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+f9f5333782a854509322@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f9f5333782a854509322
Link: https://syzkaller.appspot.com/ai_job?id=c5284b5c-3f14-4e95-a4b7-6ee38f0d2e1f
Signed-off-by: Bartosz Chronowski <immersa.bartosz.chronowski@gmail.com>

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
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
