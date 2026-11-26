Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795704974;
	b=HdOv0oBzNRTb4P6RfzwiN4ZzUFiJwQNQlby1EsSu0ETlJ/mLpubwLu/0ajbets8XCaGN
	 9z+hLUbRdap5TYR7leUgC7W7IKITRvnpX3H6JoP/2JrntuRdtQZurlNg4HS3QeqSVYF7w
	 w/NdhdY1j56feAKhe0NjnrzYGNx7UK3GkQd3b3vQcyXGOopRD3rKBsRlNrWbP450aZCW+
	 ueBlGCmneHPxacO/bf+kHSihDj2CdO+uFl83+j1SW4s2F9g9vsrKNOOtbcMN2uSpTXKW6
	 PK39iHdLolR574zi2905vmuADB+WxH8avH1edEiw3ZQO6ADFt7Rrli8sI+V0lwm8YeA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795704974;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=LxgVKXAsRJiwvZ6vXh4YIGnmuIxWBDhAzWR/U072YCg=;
	b=Ak95WIzpeOpxDJYMTxFhwmG9zLOXoQ1FnDHaUy2UwPfIoSfiLzNbPQDLOztqIUa229ic
	 BaD5DUKpECL89CnkANAaiYexvMr1QhyIzDgKTbWnwJtgNcfxcvOcO/Z1Neg5EnH6uK5y7
	 LSKGg4Y6EV+6l0lsCWfjwnEDK7xQNelb/C8YH2YbfD5ogDQmiAV2gFuFzurwglQwYKSXw
	 HcXWJ+yL0Tu/XT3P9ssBAOpZ8y/FdLSBEVO63mcmoolVD2S3dgE4H01GJ9Kb/OgjGWsjY
	 ixOPvbtWVcZxGWSerzmegsytTjh+i3ozdkLeviv2P7Bv20iNgYPXhgvg2dCD37QmN3A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Is2S3Mk7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 92DD2606A31E
	for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 14:56:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=Is2S3Mk7
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CA1DE1F000D2;
	Thu, 26 Nov 2026 14:56:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795704974;
	bh=LxgVKXAsRJiwvZ6vXh4YIGnmuIxWBDhAzWR/U072YCg=;
	h=From:To:Cc:Subject:Date;
	b=Is2S3Mk7FeBi4u98EIsLfGVJswWtPsP5MAWRfRSmttbUExuES3Z/nKpHGN0tHXODT
	 lCYq3gAViRAo+7f8Ru/vuiswecZkAvYKTatPEISFSnT/jQTUSoBB2WhvPmhwB5I6ZT
	 xHH4WqlH4O5S3QXjYnxZo/1ohC6J4QDsZjog7ai7ZmwJ1qkv+ZFeFmHxxP0iWlfazU
	 k9OfDt4aPmmgHi/hcqyLf0fwXQXd0YPuk2Ipxhch2bY1N4oh87RJvzdwruL61ahEYN
	 iyKzdF/z+uNpRWF1Yuuo+7/x0Bx/p8rBszzuIIE5KDrHdlYtbZ8mLx9bKo64XXxm+8
	 6+dDlTJhJKk5A==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v5] media: az6007: Fix mutex reinitialization and buffer overflows
Message-ID: <64766062-48c3-4eef-b90b-1f507657bea4@mail.kernel.org>
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
Date: Thu, 26 Nov 2026 14:56:13 +0000 (UTC)

A DEBUG_LOCKS_WARN_ON() warning can occur in the mutex lock acquisition
path (__mutex_lock() / __mutex_lock_common() / __mutex_remove_waiter()) due
to corruption of the mutex wait list. Note that the crash report does not
identify the specific store that damaged the mutex wait list. As a separate
targeted observation, a failed-power mutex reset with a queued waiter can
occur: mutex_init(&state->mutex) was called inside az6007_power_ctrl()
whenever !state->warm. If the initial power-on command fails, state->warm
remains false, leaving state->mutex subject to reinitialization on
subsequent invocations of az6007_power_ctrl() while the device is active.
If another thread holds state->mutex during az6007_i2c_xfer() and one or
more I2C threads are queued on its wait list, a concurrent
az6007_power_ctrl() call executes mutex_init(&state->mutex), replacing the
live I2C waiter list with an empty list and clearing the lock owner. When a
queued waiter subsequently tries to remove itself in
__mutex_remove_waiter() on the __mutex_lock() / __mutex_lock_common() path,
its list pointers no longer match the reinitialized mutex wait list,
triggering the wait-list corruption warning in the mutex lock path.

Distinct from the mutex wait-list corruption warning, an out-of-bounds
buffer access was separately reported by UBSAN in az6007_i2c_xfer().
User-controlled I2C messages transferred via /dev/i2c-* (through i2c-dev)
can specify lengths up to 8192 bytes. The driver uses a fixed 4096-byte
bounce buffer, st->data, defined in struct az6007_device_state. The driver
does not validate message lengths against sizeof(st->data) before copying
data or issuing USB control transfers, leading to out-of-bounds buffer
accesses.

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
into st->data without verifying that the payload fit within the 64-byte
maximum supported by __az6007_write(). In addition, the read loops accessed
st->data[j + 5] without verifying that __az6007_read() returned at least 5
+ len bytes. Additionally, in __az6007_write(), the blen > 64 check was
performed after dumping the payload to the kernel log under
az6007_xfer_debug.

Fix these issues by:
- Moving mutex initialization out of az6007_power_ctrl() into a newly
introduced probe callback (az6007_probe) that initializes state->mutex,
state->err_rl_lock, and the error ratelimit states once upon device
probing.
- Adding upper-bound checks against sizeof(st->data) in the single read and
combined write+read paths of az6007_i2c_xfer(), and verifying msgs[i +
1].len >= 1 in the combined path.
- Making writes over 64 bytes fail with -EOPNOTSUPP before copying into the
state buffer st->data in the write path.
- Ensuring that short USB replies now return -EIO and that __az6007_read()
returned at least 5 + len bytes before copying data from st->data to
msgs[i].buf in the single read and combined paths.
- Moving the blen > 64 check in __az6007_write() before the debug hex dump.
- Rate-limiting error logging in __az6007_read(), __az6007_write(), and
az6007_i2c_xfer() per error code via dev_warn(), dev_err(), and dev_info()
with message suppression reporting. Note that the suppressed error count
appears only if another error arrives after the rate-limit window; a quiet
burst has no final suppressed count.

Fixes: a2c35d346d9e ("[media] az6007: Protect read/write calls with a mutex")
Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+0192952caa411a3be209@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0192952caa411a3be209
Link: https://syzkaller.appspot.com/ai_job?id=549dc6b7-a77b-4d90-91a4-9ccb36192192
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v5:
- Extended per-error rate-limiting to __az6007_read() and __az6007_write() using dev_warn()/dev_err(), passing struct dvb_usb_device * instead of struct usb_device *.
- Generalized the rate-limiter into struct az6007_err_rl (16 slots with explicit used tracking and fallback state) protected by state->err_rl_lock, initialized in az6007_probe().
- Updated commit description to place the mutex wait-list corruption in the lock acquisition path and note when suppressed error counts are printed.

v4:
- Replaced pr_info_ratelimited() with per-error dev_info() ratelimiting and message suppression reporting in az6007_i2c_xfer().
- Initialized per-error ratelimit structures in az6007_probe().
- Updated description to state that the crash report does not identify the specific store that damaged the mutex wait list.
- Kept the mutex wait-list corruption warning clearly separate from the oversized-read UBSAN report, noting the failed-power mutex reset as a separate targeted observation.
https://lore.kernel.org/all/3358bfbf-b3f2-4d79-ba21-7f6cc50adb62@mail.kernel.org/T/

v3:
- Use pr_info_ratelimited() instead of pr_info() for transfer error logging in az6007_i2c_xfer().
- Reorder the commit description to lead with the mutex wait-list corruption warning and keep the oversized buffer access issue distinct.
- Describe the failed-power reset with a queued I2C waiter as observed on the base commit.
- Clarify in the description that short USB replies now return -EIO and writes over 64 bytes fail before copying into the bounce buffer.
https://lore.kernel.org/all/391e1e11-54c8-4c10-ad15-7ea3659ec388@mail.kernel.org/T/

v2:
- Require ret >= 5 + len instead of ret >= len in read paths before copying from st->data.
- Limit write transfers to 64 bytes instead of sizeof(st->data).
- Clarify in commit description that the crash report indicates mutex wait list corruption, distinct from the out-of-bounds read buffer issue, and that the failed-power mutex reset was observed on the base commit.
https://lore.kernel.org/all/baa09ccd-e29d-4434-bfd6-cebf6a9b8413@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/98467e25-6e27-41d8-94d9-5367714ce9b0@mail.kernel.org/T/
---
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index 65ef045b7..048f95f9b 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -13,6 +13,7 @@
  *	tons of bugs got fixed, and converted to use dvb-usb-v2.
  */
 
+#include <linux/ratelimit.h>
 #include "drxk.h"
 #include "mt2063.h"
 #include <media/dvb_ca_en50221.h>
@@ -38,12 +39,30 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 #define AZ6007_TS_THROUGH	0xc7
 #define AZ6007_READ_IR		0xb4
 
+#define AZ6007_ERR_SLOTS	16
+
+struct az6007_err_rl_slot {
+	bool			used;
+	int			err;
+	struct ratelimit_state	rs;
+};
+
+struct az6007_err_rl {
+	struct az6007_err_rl_slot	slots[AZ6007_ERR_SLOTS];
+	struct ratelimit_state		fallback_rs;
+};
+
 struct az6007_device_state {
 	struct mutex		mutex;
 	struct mutex		ca_mutex;
+	spinlock_t		err_rl_lock;
 	struct dvb_ca_en50221	ca;
 	unsigned		warm:1;
 	int			(*gate_ctrl) (struct dvb_frontend *, int);
+	struct az6007_err_rl	read_err_rl;
+	struct az6007_err_rl	write_err_rl;
+	struct ratelimit_state	write_len_rs;
+	struct az6007_err_rl	i2c_err_rl;
 	unsigned char		data[4096];
 };
 
@@ -97,18 +116,87 @@ static struct mt2063_config az6007_mt2063_config = {
 	.refclock = 36125000,
 };
 
-static int __az6007_read(struct usb_device *udev, u8 req, u16 value,
-			    u16 index, u8 *b, int blen)
+static void az6007_ratelimit_init(struct ratelimit_state *rs)
+{
+	ratelimit_default_init(rs);
+	ratelimit_set_flags(rs, RATELIMIT_MSG_ON_RELEASE);
+}
+
+static void az6007_err_rl_init(struct az6007_err_rl *rl)
 {
+	unsigned int i;
+
+	for (i = 0; i < ARRAY_SIZE(rl->slots); i++)
+		az6007_ratelimit_init(&rl->slots[i].rs);
+	az6007_ratelimit_init(&rl->fallback_rs);
+}
+
+static struct ratelimit_state *
+az6007_err_rs(struct az6007_device_state *st, struct az6007_err_rl *rl, int err)
+{
+	struct ratelimit_state *rs = &rl->fallback_rs;
+	unsigned long flags;
+	unsigned int i;
+
+	spin_lock_irqsave(&st->err_rl_lock, flags);
+	for (i = 0; i < ARRAY_SIZE(rl->slots); i++) {
+		if (rl->slots[i].used && rl->slots[i].err == err) {
+			rs = &rl->slots[i].rs;
+			break;
+		}
+		if (!rl->slots[i].used) {
+			rl->slots[i].used = true;
+			rl->slots[i].err = err;
+			rs = &rl->slots[i].rs;
+			break;
+		}
+	}
+
+	if (!rs->interval)
+		az6007_ratelimit_init(rs);
+	spin_unlock_irqrestore(&st->err_rl_lock, flags);
+
+	return rs;
+}
+
+static bool az6007_err_ratelimit(struct az6007_device_state *st,
+				 struct az6007_err_rl *rl, int err,
+				 int *missed)
+{
+	struct ratelimit_state *rs = az6007_err_rs(st, rl, err);
+
+	if (__ratelimit(rs)) {
+		*missed = ratelimit_state_reset_miss(rs);
+		return true;
+	}
+
+	*missed = 0;
+	return false;
+}
+
+static int __az6007_read(struct dvb_usb_device *d, u8 req, u16 value,
+			 u16 index, u8 *b, int blen)
+{
+	struct az6007_device_state *st = d_to_priv(d);
+	int missed;
 	int ret;
 
-	ret = usb_control_msg(udev,
-			      usb_rcvctrlpipe(udev, 0),
+	ret = usb_control_msg(d->udev,
+			      usb_rcvctrlpipe(d->udev, 0),
 			      req,
 			      USB_TYPE_VENDOR | USB_DIR_IN,
 			      value, index, b, blen, 5000);
 	if (ret < 0) {
-		pr_warn("usb read operation failed. (%d)\n", ret);
+		if (az6007_err_ratelimit(st, &st->read_err_rl, ret, &missed)) {
+			if (missed)
+				dev_warn(&d->intf->dev,
+					 "usb read operation failed. (%d) (%d suppressed)\n",
+					 ret, missed);
+			else
+				dev_warn(&d->intf->dev,
+					 "usb read operation failed. (%d)\n",
+					 ret);
+		}
 		return -EIO;
 	}
 
@@ -131,18 +219,35 @@ static int az6007_read(struct dvb_usb_device *d, u8 req, u16 value,
 	if (mutex_lock_interruptible(&st->mutex) < 0)
 		return -EAGAIN;
 
-	ret = __az6007_read(d->udev, req, value, index, b, blen);
+	ret = __az6007_read(d, req, value, index, b, blen);
 
 	mutex_unlock(&st->mutex);
 
 	return ret;
 }
 
-static int __az6007_write(struct usb_device *udev, u8 req, u16 value,
-			     u16 index, u8 *b, int blen)
+static int __az6007_write(struct dvb_usb_device *d, u8 req, u16 value,
+			  u16 index, u8 *b, int blen)
 {
+	struct az6007_device_state *st = d_to_priv(d);
+	int missed;
 	int ret;
 
+	if (blen > 64) {
+		if (__ratelimit(&st->write_len_rs)) {
+			missed = ratelimit_state_reset_miss(&st->write_len_rs);
+			if (missed)
+				dev_err(&d->intf->dev,
+					"tried to write %d bytes, but I2C max size is 64 bytes (%d suppressed)\n",
+					blen, missed);
+			else
+				dev_err(&d->intf->dev,
+					"tried to write %d bytes, but I2C max size is 64 bytes\n",
+					blen);
+		}
+		return -EOPNOTSUPP;
+	}
+
 	if (az6007_xfer_debug) {
 		printk(KERN_DEBUG "az6007: OUT req: %02x, value: %04x, index: %04x\n",
 		       req, value, index);
@@ -150,19 +255,24 @@ static int __az6007_write(struct usb_device *udev, u8 req, u16 value,
 				     DUMP_PREFIX_NONE, b, blen);
 	}
 
-	if (blen > 64) {
-		pr_err("az6007: tried to write %d bytes, but I2C max size is 64 bytes\n",
-		       blen);
-		return -EOPNOTSUPP;
-	}
-
-	ret = usb_control_msg(udev,
-			      usb_sndctrlpipe(udev, 0),
+	ret = usb_control_msg(d->udev,
+			      usb_sndctrlpipe(d->udev, 0),
 			      req,
 			      USB_TYPE_VENDOR | USB_DIR_OUT,
 			      value, index, b, blen, 5000);
 	if (ret != blen) {
-		pr_err("usb write operation failed. (%d)\n", ret);
+		int err = ret < 0 ? ret : 0;
+
+		if (az6007_err_ratelimit(st, &st->write_err_rl, err, &missed)) {
+			if (missed)
+				dev_err(&d->intf->dev,
+					"usb write operation failed. (%d) (%d suppressed)\n",
+					ret, missed);
+			else
+				dev_err(&d->intf->dev,
+					"usb write operation failed. (%d)\n",
+					ret);
+		}
 		return -EIO;
 	}
 
@@ -178,7 +288,7 @@ static int az6007_write(struct dvb_usb_device *d, u8 req, u16 value,
 	if (mutex_lock_interruptible(&st->mutex) < 0)
 		return -EAGAIN;
 
-	ret = __az6007_write(d->udev, req, value, index, b, blen);
+	ret = __az6007_write(d, req, value, index, b, blen);
 
 	mutex_unlock(&st->mutex);
 
@@ -694,8 +804,6 @@ static int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 	pr_debug("%s()\n", __func__);
 
 	if (!state->warm) {
-		mutex_init(&state->mutex);
-
 		ret = az6007_write(d, AZ6007_POWER, 0, 2, NULL, 0);
 		if (ret < 0)
 			return ret;
@@ -745,6 +853,8 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	struct az6007_device_state *st = d_to_priv(d);
+	bool log_err = false;
+	int missed = 0;
 	int i, j, len;
 	int ret = 0;
 	u16 index;
@@ -770,14 +880,22 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
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
-			ret = __az6007_read(d->udev, req, value, index,
+			if (length > sizeof(st->data)) {
+				ret = -EOPNOTSUPP;
+				goto err;
+			}
+			ret = __az6007_read(d, req, value, index,
 					    st->data, length);
-			if (ret >= len) {
+			if (ret >= 5 + len) {
 				for (j = 0; j < len; j++)
 					msgs[i + 1].buf[j] = st->data[j + 5];
 			} else
@@ -797,10 +915,14 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			value = addr | (1 << 8);
 			length = msgs[i].len - 1;
 			len = msgs[i].len - 1;
+			if (length > 64) {
+				ret = -EOPNOTSUPP;
+				goto err;
+			}
 			for (j = 0; j < len; j++)
 				st->data[j] = msgs[i].buf[j + 1];
-			ret =  __az6007_write(d->udev, req, value, index,
-					      st->data, length);
+			ret = __az6007_write(d, req, value, index,
+					     st->data, length);
 		} else {
 			/* read bytes */
 			if (az6007_xfer_debug)
@@ -815,19 +937,39 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			value = addr;
 			length = msgs[i].len + 6;
 			len = msgs[i].len;
-			ret = __az6007_read(d->udev, req, value, index,
+			if (length > sizeof(st->data)) {
+				ret = -EOPNOTSUPP;
+				goto err;
+			}
+			ret = __az6007_read(d, req, value, index,
 					    st->data, length);
-			for (j = 0; j < len; j++)
-				msgs[i].buf[j] = st->data[j + 5];
+			if (ret >= 5 + len) {
+				for (j = 0; j < len; j++)
+					msgs[i].buf[j] = st->data[j + 5];
+			} else {
+				ret = -EIO;
+			}
 		}
 		if (ret < 0)
 			goto err;
 	}
 err:
+	if (ret < 0)
+		log_err = az6007_err_ratelimit(st, &st->i2c_err_rl, ret,
+					       &missed);
 	mutex_unlock(&st->mutex);
 
 	if (ret < 0) {
-		pr_info("%s ERROR: %i\n", __func__, ret);
+		if (log_err) {
+			if (missed) {
+				dev_info(&adap->dev,
+					 "%s ERROR: %d (%d suppressed)\n",
+					 __func__, ret, missed);
+			} else {
+				dev_info(&adap->dev, "%s ERROR: %d\n",
+					 __func__, ret);
+			}
+		}
 		return ret;
 	}
 	return num;
@@ -855,7 +997,7 @@ static int az6007_identify_state(struct dvb_usb_device *d, const char **name)
 		return -ENOMEM;
 
 	/* Try to read the mac address */
-	ret = __az6007_read(d->udev, AZ6007_READ_DATA, 6, 0, mac, 6);
+	ret = __az6007_read(d, AZ6007_READ_DATA, 6, 0, mac, 6);
 	if (ret == 6)
 		ret = WARM;
 	else
@@ -864,9 +1006,9 @@ static int az6007_identify_state(struct dvb_usb_device *d, const char **name)
 	kfree(mac);
 
 	if (ret == COLD) {
-		__az6007_write(d->udev, 0x09, 1, 0, NULL, 0);
-		__az6007_write(d->udev, 0x00, 0, 0, NULL, 0);
-		__az6007_write(d->udev, 0x00, 0, 0, NULL, 0);
+		__az6007_write(d, 0x09, 1, 0, NULL, 0);
+		__az6007_write(d, 0x00, 0, 0, NULL, 0);
+		__az6007_write(d, 0x00, 0, 0, NULL, 0);
 	}
 
 	pr_debug("Device is on %s state\n",
@@ -889,6 +1031,20 @@ static int az6007_download_firmware(struct dvb_usb_device *d,
 	return cypress_load_firmware(d->udev, fw, CYPRESS_FX2);
 }
 
+static int az6007_probe(struct dvb_usb_device *d)
+{
+	struct az6007_device_state *state = d_to_priv(d);
+
+	mutex_init(&state->mutex);
+	spin_lock_init(&state->err_rl_lock);
+	az6007_err_rl_init(&state->read_err_rl);
+	az6007_err_rl_init(&state->write_err_rl);
+	az6007_ratelimit_init(&state->write_len_rs);
+	az6007_err_rl_init(&state->i2c_err_rl);
+
+	return 0;
+}
+
 /* DVB USB Driver stuff */
 static struct dvb_usb_device_properties az6007_props = {
 	.driver_name         = KBUILD_MODNAME,
@@ -897,6 +1053,7 @@ static struct dvb_usb_device_properties az6007_props = {
 
 	.adapter_nr          = adapter_nr,
 	.size_of_priv        = sizeof(struct az6007_device_state),
+	.probe               = az6007_probe,
 	.i2c_algo            = &az6007_i2c_algo,
 	.tuner_attach        = az6007_tuner_attach,
 	.frontend_attach     = az6007_frontend_attach,
@@ -919,6 +1076,7 @@ static struct dvb_usb_device_properties az6007_cablestar_hdci_props = {
 
 	.adapter_nr          = adapter_nr,
 	.size_of_priv        = sizeof(struct az6007_device_state),
+	.probe               = az6007_probe,
 	.i2c_algo            = &az6007_i2c_algo,
 	.tuner_attach        = az6007_tuner_attach,
 	.frontend_attach     = az6007_cablestar_hdci_frontend_attach,


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
