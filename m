Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792422635;
	b=k6hIVqaxN8uAPcRHRIh8lIO9wqS7MW1RfIy6ICLZ3uabxoeK0El7B0PbRRpy2ZsPmA4I
	 0AhRwQjIvLfC6KTkbs2w7asIePsHKwqKhPm+hbom77aBQR1N5Ujbxb/HQaZptSvoxeGGb
	 wlP+XtLz1NFQmonh3VYtSWKDhFLgItyec2wXEo84XWwktO4UdJnPu2jOAl3QmpRi0z1tK
	 SlAdJO17FnWlB5G93q2+TFmjqqPWkz5CbXx7968zQWtSt2SUM9WQS3+defTwFwJHEirN1
	 g/W+nWdj09CmR4xx8vkACQT47EVT0i7hDT1m7Wu+FZVFKxvPKnG1jyPO3dLiYpRtWSQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792422635;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=1aVD9cohcurtO2a9S+3cpWkuI6sq9RR+ZGmd6DFoC1U=;
	b=BMi3oJ7c68Jgu8z2ZMt+p7CHyLjZFGk8odJpGrY2AMS6Uq8dcOPPTNJtG5DvLmXnKD5t
	 Qx4ehk02oVR1Fg2oSp730hbFN4HctSANURohGwptTugca+1piPHjuQ7WkiatgrONbuRu0
	 n2D4ROx0qvAzKbf+tp9jDzMcYTA3rr6iJ1C+7z2YK9q2pIPYTZUJduuOqoXdk8sBSTyJ3
	 WwqmdZar5gFp6S1zD6dfyQZrFoxliawohPvWyzvmiHQLGKRMKat2f3Q/LHdl/lOl+gtDD
	 JCjB+Xh6xAt7b0ThJM6wvwLdea5BeoxjzreD0CT9p2kCY9B0vrsGhMGZ8eREsQ+4rQw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RHbnFKCl;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 39C6D60882B4
	for <syzbot@lists.linux.dev>; Mon, 19 Oct 2026 15:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=RHbnFKCl
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0046A1F000C4;
	Mon, 19 Oct 2026 15:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792422635;
	bh=1aVD9cohcurtO2a9S+3cpWkuI6sq9RR+ZGmd6DFoC1U=;
	h=From:To:Cc:Subject:Date;
	b=RHbnFKClrooUDIz9DoogtEXizGJ89bARLBWPZRmDwk9ljO7CERqp3pLB4QJKX55H3
	 EogKbNfkx+wRyG8pjtsiBpDf+YsNNDE8RX684/kQ3XXzBObQoUBVAiP4EhiMTRj4DY
	 HQejZby7fhyUgU98uUY4t/2NvPk8TlpSVcbqT7R1gZ7uMK/3JA5nyMG7C8fu/QSi/Z
	 7OxXPh/3msEzS16vFN0zLzdhAknDWg3sEIuAIZh3m7RtX5bp44Dibkbp4zB/lLLv04
	 noarsGvae45ETn6vPqn9mVoPa5ZcbcOKNMfxmsqXkkt8dG6OgGDPW6tU6mfpPdG7PM
	 Xs53qlhejk/WA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: dw2102: Fix null-ptr-deref in i2c transfer callbacks
Message-ID: <9dda9080-8d80-4504-95dd-0faef04af12d@mail.kernel.org>
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
Date: Mon, 19 Oct 2026 15:10:34 +0000 (UTC)

When user space issues an I2C_RDWR ioctl on an exposed I2C device
(/dev/i2c-X) with a zero-length message (msg.len == 0), i2cdev_ioctl_rdwr()
allocates the message buffer using memdup_user(..., 0). This causes
kmalloc_track_caller() to return ZERO_SIZE_PTR (0x10). When
su3000_i2c_transfer() subsequently processes the request, commands such as
SU3000_STREAM_CTRL unconditionally dereference msg[j].buf[0] without
verifying that msg[j].len is at least 1. Dereferencing ZERO_SIZE_PTR leads
to a general protection fault and KASAN null-ptr-deref report.

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000002: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000010-0x0000000000000017]
RIP: 0010:su3000_i2c_transfer+0x1aa/0xfc0
drivers/media/usb/dvb-usb/dw2102.c:740
Call Trace:
 <TASK>
 __i2c_transfer+0x7bf/0x1fe0 drivers/i2c/i2c-core-base.c:-1
 i2c_transfer+0x1cb/0x2d0 drivers/i2c/i2c-core-base.c:2350
 i2cdev_ioctl_rdwr+0x460/0x740 drivers/i2c/i2c-dev.c:306
 i2cdev_ioctl+0x6a5/0x880 drivers/i2c/i2c-dev.c:467
 vfs_ioctl fs/ioctl.c:51 [inline]
 __do_sys_ioctl fs/ioctl.c:597 [inline]
 __se_sys_ioctl+0xfc/0x170 fs/ioctl.c:583
 do_syscall_x64 arch/x86/entry/syscall_64.c:61 [inline]
 do_syscall_64+0x155/0x510 arch/x86/entry/syscall_64.c:84
 entry_SYSCALL_64_after_hwframe+0x77/0x7f
 </TASK>

Although dw2102_i2c_transfer() was previously fixed for this issue in
commit 5ae544d94abc ("media: dw2102: Fix null-ptr-deref in
dw2102_i2c_transfer()"), other transfer callbacks in
drivers/media/usb/dvb-usb/dw2102.c (su3000_i2c_transfer,
dw2102_serit_i2c_transfer, dw2102_earda_i2c_transfer, dw2104_i2c_transfer,
dw3101_i2c_transfer, and s6x0_i2c_transfer) also accessed msg[].buf without
checking msg[].len during operations such as DW2102_RC_QUERY,
DW2102_VOLTAGE_CTRL, DW2102_LED_CTRL, and default write commands.
Additionally, dw2102_earda_i2c_transfer() incorrectly logged msg[1].len
instead of msg[0].len in warning messages for single-message transfers.

Fix these issues by validating msg[].len against the minimum required size
before indexing into or copying to msg[].buf in all dw2102 I2C transfer
callbacks, returning -EOPNOTSUPP on failure, and correct the message index
in dw2102_earda_i2c_transfer() warning logs.

Fixes: d2ffc447cabb ("[media] dw2102: add support for Geniatech SU3000 USB DVB-S2 card")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+d99f3a288cc7d8ef60fb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d99f3a288cc7d8ef60fb
Link: https://syzkaller.appspot.com/ai_job?id=d863a1b0-1ca0-4436-b7e6-658d0c1cc4be
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 4fecf2f96..a76bc2887 100644
--- a/drivers/media/usb/dvb-usb/dw2102.c
+++ b/drivers/media/usb/dvb-usb/dw2102.c
@@ -265,12 +265,20 @@ static int dw2102_serit_i2c_transfer(struct i2c_adapter *adap,
 				     msg[0].len + 2, DW210X_WRITE_MSG);
 			break;
 		case(DW2102_RC_QUERY):
+			if (msg[0].len < 2) {
+				num = -EOPNOTSUPP;
+				break;
+			}
 			dw210x_op_rw(d->udev, 0xb8, 0, 0,
 				     buf6, 2, DW210X_READ_MSG);
 			msg[0].buf[0] = buf6[0];
 			msg[0].buf[1] = buf6[1];
 			break;
 		case(DW2102_VOLTAGE_CTRL):
+			if (msg[0].len < 1) {
+				num = -EOPNOTSUPP;
+				break;
+			}
 			buf6[0] = 0x30;
 			buf6[1] = msg[0].buf[0];
 			dw210x_op_rw(d->udev, 0xb2, 0, 0,
@@ -334,7 +342,7 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 
 			if (2 + msg[0].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
-				     msg[1].len);
+				     msg[0].len);
 				ret = -EOPNOTSUPP;
 				goto unlock;
 			}
@@ -352,7 +360,7 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 
 			if (2 + msg[0].len > sizeof(obuf)) {
 				warn("i2c wr: len=%d is too big!\n",
-				     msg[1].len);
+				     msg[0].len);
 				ret = -EOPNOTSUPP;
 				goto unlock;
 			}
@@ -367,6 +375,10 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 		case(DW2102_RC_QUERY): {
 			u8 ibuf[2];
 
+			if (msg[0].len < 2) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			dw210x_op_rw(d->udev, 0xb8, 0, 0,
 				     ibuf, 2, DW210X_READ_MSG);
 			memcpy(msg[0].buf, ibuf, 2);
@@ -375,6 +387,10 @@ static int dw2102_earda_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg ms
 		case(DW2102_VOLTAGE_CTRL): {
 			u8 obuf[2];
 
+			if (msg[0].len < 1) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			obuf[0] = 0x30;
 			obuf[1] = msg[0].buf[0];
 			dw210x_op_rw(d->udev, 0xb2, 0, 0,
@@ -407,6 +423,10 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 		case(DW2102_RC_QUERY): {
 			u8 ibuf[2];
 
+			if (msg[j].len < 2) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			dw210x_op_rw(d->udev, 0xb8, 0, 0,
 				     ibuf, 2, DW210X_READ_MSG);
 			memcpy(msg[j].buf, ibuf, 2);
@@ -415,6 +435,10 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 		case(DW2102_VOLTAGE_CTRL): {
 			u8 obuf[2];
 
+			if (msg[j].len < 1) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			obuf[0] = 0x30;
 			obuf[1] = msg[j].buf[0];
 			dw210x_op_rw(d->udev, 0xb2, 0, 0,
@@ -444,6 +468,9 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 					     DW210X_READ_MSG);
 				memcpy(msg[j].buf, ibuf + 2, msg[j].len);
 				mdelay(10);
+			} else if (msg[j].len < 1) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			} else if (((msg[j].buf[0] == 0xb0) && (msg[j].addr == 0x68)) ||
 				   ((msg[j].buf[0] == 0xf7) && (msg[j].addr == 0x55))) {
 				/* write firmware */
@@ -557,6 +584,10 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		case(DW2102_RC_QUERY): {
 			u8 ibuf[2];
 
+			if (msg[0].len < 2) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			dw210x_op_rw(d->udev, 0xb8, 0, 0,
 				     ibuf, 2, DW210X_READ_MSG);
 			memcpy(msg[0].buf, ibuf, 2);
@@ -597,6 +628,10 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		case (DW2102_RC_QUERY): {
 			u8 ibuf[5];
 
+			if (msg[j].len < 2) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			dw210x_op_rw(d->udev, 0xb8, 0, 0,
 				     ibuf, 5, DW210X_READ_MSG);
 			memcpy(msg[j].buf, ibuf + 3, 2);
@@ -605,6 +640,10 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		case (DW2102_VOLTAGE_CTRL): {
 			u8 obuf[2];
 
+			if (msg[j].len < 2) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			obuf[0] = 1;
 			obuf[1] = msg[j].buf[1];/* off-on */
 			dw210x_op_rw(d->udev, 0x8a, 0, 0,
@@ -618,6 +657,10 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		case (DW2102_LED_CTRL): {
 			u8 obuf[2];
 
+			if (msg[j].len < 1) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			obuf[0] = 5;
 			obuf[1] = msg[j].buf[0];
 			dw210x_op_rw(d->udev, 0x8a, 0, 0,
@@ -647,6 +690,9 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 						DW210X_READ_MSG);
 				memcpy(msg[j].buf, ibuf, msg[j].len);
 				break;
+			} else if (msg[j].len < 1) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
 			} else if ((msg[j].buf[0] == 0xb0) && (msg[j].addr == 0x68)) {
 				/* write firmware */
 				u8 obuf[19];
@@ -737,6 +783,10 @@ static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 	while (j < num) {
 		switch (msg[j].addr) {
 		case SU3000_STREAM_CTRL:
+			if (msg[j].len < 1) {
+				num = -EOPNOTSUPP;
+				break;
+			}
 			state->data[0] = msg[j].buf[0] + 0x36;
 			state->data[1] = 3;
 			state->data[2] = 0;
@@ -745,6 +795,10 @@ static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 				err("i2c transfer failed.");
 			break;
 		case DW2102_RC_QUERY:
+			if (msg[j].len < 2) {
+				num = -EOPNOTSUPP;
+				break;
+			}
 			state->data[0] = 0x10;
 			if (dvb_usb_generic_rw(d, state->data, 1,
 					       state->data, 2, 0) < 0)


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
