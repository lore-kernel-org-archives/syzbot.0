Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794583028;
	b=hpsMbsRvgoipcxXQPnG0RO6XnNxyzonJXwipchq1OvLRKjw9iD0thi3aLIdAKrA6VUpY
	 TJBoUIGZyC7WUX+ddI4vnffqbH16v/ojprTMIpu5tw2SI/NUQwg5Jq3AlTRFpih6PY79g
	 AlJakReQO/ay6GGGbhdaxiwCvXEmxQZxaNt7UmU1RikgAD5UguapoK3b/rPbFaEk7ORfv
	 VH45yzb0xbTDbUGaUcKgXMxh4FlrKUf6Y2464QzspEkbo/+fi/c4f6gTeU2DrC/jLAygB
	 ToCocE7ui89XpYub2IYDhZWan96Y6PULKAQD1FZMRK21g9MmTNX3/+jcixweiLMFlJg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794583028;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=KDZ9EprZwrYhLoPtlWC6SY/t5aT5kOnBO0OZdGs1DhE=;
	b=15Q4G7jcqd4Ll5KGkmQD30uB54vRC2TAP9kN8fw7LdtF4L2tx+DsljarQ6AMtZn21N/i
	 sX7vAdriQ61hBInFukFDpgMU6Nohe8YUUN5Pm+2MDCeYfGaN6SJ2U4Ie915y5yBr7CGlL
	 8VyDwK1RDcsZPiOIPTfeNoDfeV4eqqa1m5uqUlh4YTxUY4R6E1wOXvbFeSYtaLAB9rmuv
	 QkZgwdkVTowJewv51ZFbmlnnkLGT6YthEMRsXMSgNKu1DppJeGqqlGrSZOJ5KLk4LmI3O
	 vmIetnTop3OnR40mUZ5hFBGthkY0HF+gEHuyI6Jo1rndFb2/S8oPXb4rnkm96J5n9Og==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=feBKkbc7;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id E4A4660A2628
	for <syzbot@lists.linux.dev>; Fri, 13 Nov 2026 15:17:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=feBKkbc7
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5B6CC1F000C4;
	Fri, 13 Nov 2026 15:17:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1794583027;
	bh=KDZ9EprZwrYhLoPtlWC6SY/t5aT5kOnBO0OZdGs1DhE=;
	h=From:To:Cc:Subject:Date;
	b=feBKkbc7JtunRpPuIgr+fI/SPrmPZqKSU2qgiQ1PCzJlMqlNquBcVqAfaw6ldyOZV
	 Q1oExDgCrhjHvhv1CsWIEkUR9ZggW9cNtld2dcKhtBSJDpb210Uir6wZTnJHNtlA0/
	 5Gfb7NnS/psVrhEG7J539dx1r2H8BM9TxwDySteXT66+eUeFhWQYUQvfx7Ubw23b91
	 MREsSw0A2CB4WWS51crqMRXQn3YQiqvLTg1SHfLM1NebwpvDrP8Yy4SgGVxWbhBv1l
	 3qo6VhWqbbZumcD/1ljFFokIZQ55AH4bJBCOwLwDkn94oMJ5FMybn/0hu/W9n4fs36
	 QEzH9ozznQHdg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v4] media: az6007: Fix mutex reinitialization and buffer overflows
Message-ID: <3358bfbf-b3f2-4d79-ba21-7f6cc50adb62@mail.kernel.org>
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
Date: Fri, 13 Nov 2026 15:17:07 +0000 (UTC)

A DEBUG_LOCKS_WARN_ON() warning can occur on mutex unlock due to corruption
of the mutex wait list. Note that the crash report does not identify the
specific store that damaged the mutex wait list. As a separate targeted
observation, a failed-power mutex reset with a queued waiter can occur:
mutex_init(&state->mutex) was called inside az6007_power_ctrl() whenever
!state->warm. If the initial power-on command fails, state->warm remains
false, causing subsequent invocations of az6007_power_ctrl() to
reinitialize state->mutex while the device is active. If another thread
holds or is queued as a waiter on state->mutex during az6007_i2c_xfer(),
reinitializing the mutex clears the lock owner and wait list, triggering
the mutex wait-list corruption warning on unlock.

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
introduced probe callback (az6007_probe) that initializes state->mutex and
error ratelimit states once upon device probing.
- Adding upper-bound checks against sizeof(st->data) in the single read and
combined write+read paths of az6007_i2c_xfer(), and verifying msgs[i +
1].len >= 1 in the combined path.
- Making writes over 64 bytes fail with -EOPNOTSUPP before copying into the
state buffer st->data in the write path.
- Ensuring that short USB replies now return -EIO and that __az6007_read()
returned at least 5 + len bytes before copying data from st->data to
msgs[i].buf in the single read and combined paths.
- Moving the blen > 64 check in __az6007_write() before the debug hex dump.
- Rate-limiting error logging in az6007_i2c_xfer() per error code via
dev_info() with message suppression reporting.

Fixes: a2c35d346d9e ("[media] az6007: Protect read/write calls with a mutex")
Assisted-by: Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+0192952caa411a3be209@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0192952caa411a3be209
Link: https://syzkaller.appspot.com/ai_job?id=3c54b352-c6ae-479f-b6e6-d6d8ffa2edf6
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v4:
- Replaced pr_info_ratelimited() with per-error dev_info() ratelimiting and message suppression reporting in az6007_i2c_xfer().
- Initialized per-error ratelimit structures in az6007_probe().
- Updated description to state that the crash report does not identify the specific store that damaged the mutex wait list.
- Kept the mutex wait-list corruption warning clearly separate from the oversized-read UBSAN report, noting the failed-power mutex reset as a separate targeted observation.

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
index 65ef045b7..a443a64b7 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -13,6 +13,7 @@
  *	tons of bugs got fixed, and converted to use dvb-usb-v2.
  */
 
+#include <linux/ratelimit.h>
 #include "drxk.h"
 #include "mt2063.h"
 #include <media/dvb_ca_en50221.h>
@@ -38,13 +39,22 @@ DVB_DEFINE_MOD_OPT_ADAPTER_NR(adapter_nr);
 #define AZ6007_TS_THROUGH	0xc7
 #define AZ6007_READ_IR		0xb4
 
+#define AZ6007_I2C_ERR_SLOTS	8
+
+struct az6007_i2c_err_rl {
+	int			err;
+	struct ratelimit_state	rs;
+};
+
 struct az6007_device_state {
-	struct mutex		mutex;
-	struct mutex		ca_mutex;
-	struct dvb_ca_en50221	ca;
-	unsigned		warm:1;
-	int			(*gate_ctrl) (struct dvb_frontend *, int);
-	unsigned char		data[4096];
+	struct mutex			mutex;
+	struct mutex			ca_mutex;
+	struct dvb_ca_en50221		ca;
+	unsigned			warm:1;
+	int				(*gate_ctrl)(struct dvb_frontend *, int);
+	struct az6007_i2c_err_rl	i2c_err_rl[AZ6007_I2C_ERR_SLOTS];
+	struct ratelimit_state		i2c_err_fallback_rs;
+	unsigned char			data[4096];
 };
 
 static struct drxk_config terratec_h7_drxk = {
@@ -143,6 +153,12 @@ static int __az6007_write(struct usb_device *udev, u8 req, u16 value,
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
@@ -150,12 +166,6 @@ static int __az6007_write(struct usb_device *udev, u8 req, u16 value,
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
@@ -694,8 +704,6 @@ static int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 	pr_debug("%s()\n", __func__);
 
 	if (!state->warm) {
-		mutex_init(&state->mutex);
-
 		ret = az6007_write(d, AZ6007_POWER, 0, 2, NULL, 0);
 		if (ret < 0)
 			return ret;
@@ -740,11 +748,43 @@ static int az6007_power_ctrl(struct dvb_usb_device *d, int onoff)
 }
 
 /* I2C */
+static void az6007_ratelimit_init(struct ratelimit_state *rs)
+{
+	ratelimit_default_init(rs);
+	ratelimit_set_flags(rs, RATELIMIT_MSG_ON_RELEASE);
+}
+
+static struct ratelimit_state *
+az6007_i2c_err_rs(struct az6007_device_state *st, int err)
+{
+	struct ratelimit_state *rs = &st->i2c_err_fallback_rs;
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(st->i2c_err_rl); i++) {
+		if (st->i2c_err_rl[i].err == err) {
+			rs = &st->i2c_err_rl[i].rs;
+			break;
+		}
+		if (!st->i2c_err_rl[i].err) {
+			st->i2c_err_rl[i].err = err;
+			rs = &st->i2c_err_rl[i].rs;
+			break;
+		}
+	}
+
+	if (!rs->interval)
+		az6007_ratelimit_init(rs);
+
+	return rs;
+}
+
 static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			   int num)
 {
 	struct dvb_usb_device *d = i2c_get_adapdata(adap);
 	struct az6007_device_state *st = d_to_priv(d);
+	bool log_err = false;
+	int missed = 0;
 	int i, j, len;
 	int ret = 0;
 	u16 index;
@@ -770,14 +810,22 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
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
-			if (ret >= len) {
+			if (ret >= 5 + len) {
 				for (j = 0; j < len; j++)
 					msgs[i + 1].buf[j] = st->data[j + 5];
 			} else
@@ -797,6 +845,10 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
 			value = addr | (1 << 8);
 			length = msgs[i].len - 1;
 			len = msgs[i].len - 1;
+			if (length > 64) {
+				ret = -EOPNOTSUPP;
+				goto err;
+			}
 			for (j = 0; j < len; j++)
 				st->data[j] = msgs[i].buf[j + 1];
 			ret =  __az6007_write(d->udev, req, value, index,
@@ -815,19 +867,44 @@ static int az6007_i2c_xfer(struct i2c_adapter *adap, struct i2c_msg msgs[],
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
+	if (ret < 0) {
+		struct ratelimit_state *rs = az6007_i2c_err_rs(st, ret);
+
+		if (__ratelimit(rs)) {
+			log_err = true;
+			missed = ratelimit_state_reset_miss(rs);
+		}
+	}
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
@@ -889,6 +966,19 @@ static int az6007_download_firmware(struct dvb_usb_device *d,
 	return cypress_load_firmware(d->udev, fw, CYPRESS_FX2);
 }
 
+static int az6007_probe(struct dvb_usb_device *d)
+{
+	struct az6007_device_state *state = d_to_priv(d);
+	int i;
+
+	mutex_init(&state->mutex);
+	for (i = 0; i < ARRAY_SIZE(state->i2c_err_rl); i++)
+		az6007_ratelimit_init(&state->i2c_err_rl[i].rs);
+	az6007_ratelimit_init(&state->i2c_err_fallback_rs);
+
+	return 0;
+}
+
 /* DVB USB Driver stuff */
 static struct dvb_usb_device_properties az6007_props = {
 	.driver_name         = KBUILD_MODNAME,
@@ -897,6 +987,7 @@ static struct dvb_usb_device_properties az6007_props = {
 
 	.adapter_nr          = adapter_nr,
 	.size_of_priv        = sizeof(struct az6007_device_state),
+	.probe               = az6007_probe,
 	.i2c_algo            = &az6007_i2c_algo,
 	.tuner_attach        = az6007_tuner_attach,
 	.frontend_attach     = az6007_frontend_attach,
@@ -919,6 +1010,7 @@ static struct dvb_usb_device_properties az6007_cablestar_hdci_props = {
 
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
