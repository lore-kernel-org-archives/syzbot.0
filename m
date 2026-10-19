Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792430555;
	b=hykMJRhuCYLYmZ1xpvbKyb+Z/6ZoDhoVzRWhTNpaVPhiFY8h9j8eSfu8TO5fAL/zExlA
	 iFMnGTjTl3vDwP0l+6XEshBFUww0sLDpMutU7z9UH3RIIakbqBZypdJ08a7pV4ZV37kiP
	 JO10xCBZZ8qQaOA8LN8I4zw/QnQTV9ipec1X6s7JHG4i07JPzU7DYKpEBslY9PJpBPUNP
	 iPtrwsJsGQNFFG18RIUA5m6AWQkGzcpfTw1Jitvz8suKLseNDZbSvS23y+P2OOzEGB41P
	 oNMqYL4Qu1HO4MQnFAoAxFA+EFVf2eTAzFoaSdLWVQG12HQuSFRYMHo2BdeksVT0mmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792430555;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=0eWn2LiPe0RvTHwN9fR65kwTv81S56WqGHCmjnDcYI4=;
	b=yPpKoZ6ULcqbkSdspI2FGt3TErSOFwAhkUS+7pzA3LRjplohArWN/QqyMeEV9pwNI/Q0
	 IPUJB9xVflCZdsSW2gXRifECNPDtxlZtChHJdOx+Gc3p10WLD8wIb7sftcPOpq74G8dYQ
	 mMzgmnUsGDAOYmDjKws6lNSyYjh8n+5Hj0VKNz0QJVpXz/ekpduMrR8tLIkvEnxz5oChg
	 AGPFfke5zD2MBq6a+UWW6SkJg2S5eBVCBxfb7HkHRG1kjZgO/5f862+we0useqTFGkign
	 SQXmrkHGdZfJqdqhNigXRvpVEc9spOyfi1R2ecWKVZh3wMQ/vbgTc8id4oyoQED1/hQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzG1DPNY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7BD26606A31D
	for <syzbot@lists.linux.dev>; Mon, 19 Oct 2026 17:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=hzG1DPNY
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 089A21F000C4;
	Mon, 19 Oct 2026 17:22:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792430555;
	bh=0eWn2LiPe0RvTHwN9fR65kwTv81S56WqGHCmjnDcYI4=;
	h=From:To:Cc:Subject:Date;
	b=hzG1DPNYMIEtiMamwOHkd9E832LocOu3G81okaeg+F0sbkUW71MTrR1p3s9aWu7Ke
	 /cgz3DWQImcg3X9x3Mn4S9D9EQNxRCVt0i3VeVVbeFf7Bnfyl4FFaqeNcgY8Rbbvcp
	 ybNM6V2RaJfWLGu/MzT/RBE3Ornkn9IPxb4+y6phwK5G+mXFZ/vZf4xJArZAFYa3fc
	 mnZek/jnslFlyItBVAxZNsNx3aprIxnd3YNeoAXLjJnYT/uAj6x/PYTH9LsRCVZMug
	 Ggc7czUlO8pbLZbC1XMX0NLCYdDPvJoNaVSvNYxxC5zNzOH/vp+/+A0T0YeqDiMCbC
	 IyZ1MANU45QMA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] media: az6007: Fix out-of-bounds access and mutex reinitialization
Message-ID: <98467e25-6e27-41d8-94d9-5367714ce9b0@mail.kernel.org>
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
Date: Mon, 19 Oct 2026 17:22:35 +0000 (UTC)

In az6007_i2c_xfer(), user-controlled I2C messages transferred via
/dev/i2c-* (through i2c-dev) can specify lengths up to 8192 bytes. The
driver uses a fixed 4096-byte bounce buffer, st->data, defined in struct
az6007_device_state. The driver does not validate message lengths against
sizeof(st->data) before copying data or issuing USB control transfers,
leading to out-of-bounds buffer accesses.

When userspace reads from an I2C device (such as via preadv() on
/dev/i2c-*), i2cdev_read() calls i2c_master_recv() -> i2c_transfer() ->
__i2c_transfer() -> az6007_i2c_xfer() with msgs[0].len matching the
requested read size. In the single read branch, length is computed as
msgs[i].len + 6. If msgs[i].len exceeds 4090 bytes, length exceeds
sizeof(st->data). Furthermore, the return value of __az6007_read() was not
validated before copying bytes from st->data[j + 5] into msgs[i].buf[j].
When a large read request fails at the USB level, the copy loop still
executes unconditionally. When j reaches 4091, j + 5 equals 4096, reading
past the end of st->data and triggering a UBSAN array-index-out-of-bounds
warning:

UBSAN: array-index-out-of-bounds in
drivers/media/usb/dvb-usb-v2/az6007.c:821:22
index 4096 is out of range for type 'unsigned char[4096]'
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 ubsan_epilogue+0xa/0x30 lib/ubsan.c:233
 __ubsan_handle_out_of_bounds+0xe8/0xf0 lib/ubsan.c:455
 az6007_i2c_xfer+0x419/0xaa0 drivers/media/usb/dvb-usb-v2/az6007.c:821
 __i2c_transfer+0x7bf/0x1fe0 drivers/i2c/i2c-core-base.c:-1
 i2c_transfer+0x1cb/0x2d0 drivers/i2c/i2c-core-base.c:2350
 i2c_transfer_buffer_flags+0x10d/0x1a0 drivers/i2c/i2c-core-base.c:2378
 i2c_master_recv include/linux/i2c.h:79 [inline]
 i2cdev_read+0x10d/0x250 drivers/i2c/i2c-dev.c:155
 vfs_readv+0x57c/0x850 fs/read_write.c:1021
 do_preadv fs/read_write.c:1133 [inline]
 </TASK>

Similar buffer overflow issues exist in the other transfer paths: the
combined write+read branch lacked checks on msgs[i + 1].len < 1 and length
> sizeof(st->data), while the write branch copied msgs[i].len - 1 bytes
into st->data without verifying that the payload fit within st->data.
Additionally, in __az6007_write(), the blen > 64 check was performed after
dumping the payload to the kernel log under az6007_xfer_debug.

Separately, mutex_init(&state->mutex) was called inside az6007_power_ctrl()
when !state->warm. If the initial power-on command failed, state->warm
remained false, causing subsequent invocations of az6007_power_ctrl() to
reinitialize state->mutex while the device was active. If another thread
held the mutex during az6007_i2c_xfer(), reinitializing the mutex cleared
the lock owner and triggered a DEBUG_LOCKS_WARN_ON warning on unlock.

Fix these issues by:
- Moving mutex initialization out of az6007_power_ctrl() into a newly
introduced probe callback (az6007_probe) that initializes state->mutex once
upon device probing.
- Adding upper-bound checks against sizeof(st->data) in the single read,
single write, and combined write+read paths of az6007_i2c_xfer(), as well
as verifying msgs[i + 1].len >= 1 in the combined path.
- Checking that __az6007_read() succeeded before copying data from st->data
to msgs[i].buf in the single read path.
- Moving the blen > 64 check in __az6007_write() before the debug hex dump.

Fixes: b19280cf2bee ("[media] az6007: code cleanups and fixes")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+0192952caa411a3be209@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0192952caa411a3be209
Link: https://syzkaller.appspot.com/ai_job?id=8ca38357-fe34-43e4-bc49-e73c595eb9a2
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@redhat.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index 65ef045b7..20b2bd944 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -143,6 +143,12 @@ static int __az6007_write(struct usb_device *udev, u8 req, u16 value,
 {
 	int ret;
 
+	if (blen > 64) {
+		pr_err("az6007: tried to write %d bytes, but I2C max size is 64 bytes\n",
+		       blen);
+		return -EOPNOTSUPP;
+	}
+
 	if (az6007_xfer_debug) {
 		printk(KERN_DEBUG "az6007: OUT req: %02x, value: %04x, index: %04x\n",
 		       req, value, index);
@@ -150,12 +156,6 @@ static int __az6007_write(struct usb_device *udev, u8 req, u16 value,
 				     DUMP_PREFIX_NONE, b, blen);
 	}
 
-	if (blen > 64) {
-		pr_err("az6007: tried to write %d bytes, but I2C max size is 64 bytes\n",
-		       blen);
-		return -EOPNOTSUPP;
-	}
-
 	ret = usb_control_msg(udev,
 			      usb_sndctrlpipe(udev, 0),
 			      req,
@@ -694,8 +694,6 @@ static int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 	pr_debug("%s()\n", __func__);
 
 	if (!state->warm) {
-		mutex_init(&state->mutex);
-
 		ret = az6007_write(d, AZ6007_POWER, 0, 2, NULL, 0);
 		if (ret < 0)
 			return ret;
@@ -770,11 +768,19 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			if (az6007_xfer_debug)
 				printk(KERN_DEBUG "az6007: I2C W/R addr=0x%x len=%d/%d\n",
 				       addr, msgs[i].len, msgs[i + 1].len);
+			if (msgs[i + 1].len < 1) {
+				ret = -EIO;
+				goto err;
+			}
 			req = AZ6007_I2C_RD;
 			index = msgs[i].buf[0];
 			value = addr | (1 << 8);
 			length = 6 + msgs[i + 1].len;
 			len = msgs[i + 1].len;
+			if (length > sizeof(st->data)) {
+				ret = -EOPNOTSUPP;
+				goto err;
+			}
 			ret = __az6007_read(d->udev, req, value, index,
 					    st->data, length);
 			if (ret >= len) {
@@ -797,6 +803,10 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			value = addr | (1 << 8);
 			length = msgs[i].len - 1;
 			len = msgs[i].len - 1;
+			if (length > sizeof(st->data)) {
+				ret = -EOPNOTSUPP;
+				goto err;
+			}
 			for (j = 0; j < len; j++)
 				st->data[j] = msgs[i].buf[j + 1];
 			ret =  __az6007_write(d->udev, req, value, index,
@@ -815,10 +825,18 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			value = addr;
 			length = msgs[i].len + 6;
 			len = msgs[i].len;
+			if (length > sizeof(st->data)) {
+				ret = -EOPNOTSUPP;
+				goto err;
+			}
 			ret = __az6007_read(d->udev, req, value, index,
 					    st->data, length);
-			for (j = 0; j < len; j++)
-				msgs[i].buf[j] = st->data[j + 5];
+			if (ret >= len) {
+				for (j = 0; j < len; j++)
+					msgs[i].buf[j] = st->data[j + 5];
+			} else {
+				ret = -EIO;
+			}
 		}
 		if (ret < 0)
 			goto err;
@@ -889,6 +907,15 @@ static int az6007_download_firmware(struct dvb_usb_device *d,
 	return cypress_load_firmware(d->udev, fw, CYPRESS_FX2);
 }
 
+static int az6007_probe(struct dvb_usb_device *d)
+{
+	struct az6007_device_state *state = d_to_priv(d);
+
+	mutex_init(&state->mutex);
+
+	return 0;
+}
+
 /* DVB USB Driver stuff */
 static struct dvb_usb_device_properties az6007_props = {
 	.driver_name         = KBUILD_MODNAME,
@@ -897,6 +924,7 @@ static struct dvb_usb_device_properties az6007_props = {
 
 	.adapter_nr          = adapter_nr,
 	.size_of_priv        = sizeof(struct az6007_device_state),
+	.probe               = az6007_probe,
 	.i2c_algo            = &az6007_i2c_algo,
 	.tuner_attach        = az6007_tuner_attach,
 	.frontend_attach     = az6007_frontend_attach,
@@ -919,11 +947,12 @@ static struct dvb_usb_device_properties az6007_cablestar_hdci_props = {
 
 	.adapter_nr          = adapter_nr,
 	.size_of_priv        = sizeof(struct az6007_device_state),
+	.probe               = az6007_probe,
 	.i2c_algo            = &az6007_i2c_algo,
 	.tuner_attach        = az6007_tuner_attach,
 	.frontend_attach     = az6007_cablestar_hdci_frontend_attach,
 	.streaming_ctrl      = az6007_streaming_ctrl,
-/* ditch get_rc_config as it can't work (TS35 remote, I believe it's rc5) */
+	/* ditch get_rc_config as it can't work (TS35 remote, I believe it's rc5) */
 	.get_rc_config       = NULL,
 	.read_mac_address    = az6007_read_mac_addr,
 	.download_firmware   = az6007_download_firmware,


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
