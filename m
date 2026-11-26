Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795701164;
	b=WjAkHY7pnobn3Bd9KC2HzjWU5dEbNqxzjSVA3PQOLa93B1VeujZdCodGAfdzz9DXCSzi
	 w3t4YunBZceQ4dPJFpjxL7fWwvvrJjacjETTXd31z458mAQeSTUf1HQQ7tvRNmg5KYapj
	 HHc5YAain12J2+9SuG0hTl3TsWxXvYcZlVo/kCIUG3/KSH7QYQCWDZ+U21aEXotRQ40h6
	 x3eCN2wDDCABpLkj9M6gHL01XmITCpDNxBG6jkhLB7fNJD6hF67c/1TndUpdRDJ3Om8L2
	 O6KLz+zdih+Va6Xhy1nHt+pxV+LMbCAEKDhD4f2/P9Fh7bQ0YQ8zLMLqo4U1fBVToVQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795701164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=rF1aNpF3QhwINOcIWEatT/v72hgvTLqrc2zJvaAzcuw=;
	b=3hvIGY+3WakOa/ZhqYTf2JCa2UUsdSk0zOfr+WGefRU6MAt9OLpBL7RXxrQ0lxNDZ1dz
	 dWQjYdzMvnK9zP7+9+IIAPUT0dSVDaSgAjUUU9LMKs65UZpSQMoAk5qWRKTmX0truWjgC
	 J/uRWMbpSpQa3HklpLiTZUTGJ5KSLzG1Huzk52lVj3ya26YHJMJk46dfoLPw2x/bvWvSg
	 oj/fX8BQaC+tG3L8/kNZtyNhuYwk66lFIf6vyiriXZXeU3W9/35QrpXpV/6JA7iUsZdDR
	 BfG1ctqTAv4+584rQmIPzGYFwPddDuu6Qn/LgWZKk8hKSPTcpWd6HofpOSbvDlw9Qtw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E9cPvFxM;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 7C169606A31C
	for <syzbot@lists.linux.dev>; Thu, 26 Nov 2026 13:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=E9cPvFxM
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id E11BE1F000C4;
	Thu, 26 Nov 2026 13:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1795701164;
	bh=rF1aNpF3QhwINOcIWEatT/v72hgvTLqrc2zJvaAzcuw=;
	h=From:To:Cc:Subject:Date;
	b=E9cPvFxMHoycdra1V5N/EwjlXhKpbVLYOFeWGFH1xE3QuA7OPNLPRHmJlwtmDdADF
	 vaHvtLbotb7tTj482L8ocvLX+gyeXPIps6u6fahcn9KnkfY/kJNHv4H0pPWs2hcsDe
	 DTN1iuXYenbXGhpLaskZTtodE1Hsf+syODkloqzw+0bkwAtWQEHyXOcIItJxEbgKg4
	 HP8wXmaZLeDxcXP1CsNjgxBZ9eZkS9F0i5Jntn9KWBw5/tbS95UfMushNPiTDqBAO6
	 oSnw/tb84qdIJJg/xrLJHdqF0hBo2LFvMdWbfjv+akLP+4KBg1tev2o56MemSdTbtp
	 uiiB5xvrqSxEA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: immersa.bartosz.chronowski@gmail.com, syzbot@lists.linux.dev
Subject: [PATCH RFC v3] media: dw2102: Fix null-ptr-deref in i2c transfer callbacks
Message-ID: <5c9e0753-cd9b-4a67-b31a-c84d01c701db@mail.kernel.org>
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
Date: Thu, 26 Nov 2026 13:52:43 +0000 (UTC)

When user space issues an I2C_RDWR ioctl on an exposed I2C device
(/dev/i2c-X) with a zero-length message (msg.len == 0), i2cdev_ioctl_rdwr()
allocates the message buffer using memdup_user(), which returns
ZERO_SIZE_PTR (0x10) for a length of 0. When su3000_i2c_transfer()
subsequently processes the request, it accesses the buffer without checking
its length, unconditionally dereferencing msg[j].buf[0] for
SU3000_STREAM_CTRL commands. Dereferencing ZERO_SIZE_PTR leads to a general
protection fault and KASAN null-ptr-deref report.

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

Commit d2ffc447cabb ("[media] dw2102: add SU3000 support") specifically
introduced the SU3000 support and the unvalidated buffer access in
su3000_i2c_transfer(). In addition, similar missing length checks exist
across the other transfer callbacks in drivers/media/usb/dvb-usb/dw2102.c
dating back to their original introductions, while dw2102_i2c_transfer()
was previously fixed in commit 5ae544d94abc ("media: dw2102: Fix
null-ptr-deref in dw2102_i2c_transfer()"). Specifically, SU3000_STREAM_CTRL
requires msg[j].len >= 1 to read msg[j].buf[0]; DW2102_RC_QUERY requires
msg[].len >= 2 to store the 2-byte query response across all callbacks;
DW2102_VOLTAGE_CTRL requires msg[].len >= 1 in dw2102_serit_i2c_transfer,
dw2102_earda_i2c_transfer, and dw2104_i2c_transfer to read msg[].buf[0],
but requires msg[j].len >= 2 in s6x0_i2c_transfer to read msg[j].buf[1];
DW2102_LED_CTRL requires msg[j].len >= 1 in s6x0_i2c_transfer to read
msg[j].buf[0]; and default firmware write paths in dw2104_i2c_transfer and
s6x0_i2c_transfer require msg[j].len >= 1 to inspect msg[j].buf[0].
Additionally, dw2102_earda_i2c_transfer() suffered from an out-of-bounds
read when num == 1 by reading msg[1].len outside the message array in
warning logs when validating the transfer buffer size.

Fix these issues by validating msg[].len against each command's minimum
required size before indexing into or copying to msg[].buf across all
dw2102 I2C transfer callbacks (returning -EOPNOTSUPP on failure, or
guarding the firmware write check with msg[j].len >= 1 in
dw2104_i2c_transfer and s6x0_i2c_transfer so zero-length writes fall
through to the generic write path), and correct the out-of-bounds read in
dw2102_earda_i2c_transfer() by referencing msg[0].len.

Fixes: d2ffc447cabb ("[media] dw2102: add support for Geniatech SU3000 USB DVB-S2 card")
Assisted-by: Gemini:gemini-4-hydrogen Gemini:gemini-4-carbon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+d99f3a288cc7d8ef60fb@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d99f3a288cc7d8ef60fb
Link: https://syzkaller.appspot.com/ai_job?id=562fa217-697d-40d1-9159-4daa0bcecc54
To: <linux-media@vger.kernel.org>
To: "Mauro Carvalho Chehab" <mchehab@kernel.org>
To: "Igor M. Liplianin" <liplianin@me.by>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Guarded firmware write checks in dw2104_i2c_transfer() and s6x0_i2c_transfer() with msg[j].len >= 1 instead of returning -EOPNOTSUPP so zero-length messages fall through to the generic write path.
- Removed the duplicate Fixes tag from the commit description body.

v2:
- Clarified that zero-length memdup_user() returns ZERO_SIZE_PTR and dropped the reference to kmalloc_track_caller().
- Documented the minimum required length for each guarded command across the transfer callbacks.
- Described the msg[1].len access in dw2102_earda_i2c_transfer() as an out-of-bounds read when num == 1.
- Clarified the history of the fixes, tying Fixes: d2ffc447cabb specifically to su3000_i2c_transfer().
https://lore.kernel.org/all/c05e1655-d5b4-445d-aebf-e06ba6b44ad2@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/9dda9080-8d80-4504-95dd-0faef04af12d@mail.kernel.org/T/
---
diff --git a/drivers/media/usb/dvb-usb/dw2102.c b/drivers/media/usb/dvb-usb/dw2102.c
index 4fecf2f96..9c94b94f7 100644
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
@@ -444,8 +468,9 @@ static int dw2104_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[], i
 					     DW210X_READ_MSG);
 				memcpy(msg[j].buf, ibuf + 2, msg[j].len);
 				mdelay(10);
-			} else if (((msg[j].buf[0] == 0xb0) && (msg[j].addr == 0x68)) ||
-				   ((msg[j].buf[0] == 0xf7) && (msg[j].addr == 0x55))) {
+			} else if (msg[j].len >= 1 &&
+				   (((msg[j].buf[0] == 0xb0) && (msg[j].addr == 0x68)) ||
+				    ((msg[j].buf[0] == 0xf7) && (msg[j].addr == 0x55)))) {
 				/* write firmware */
 				u8 obuf[19];
 
@@ -557,6 +582,10 @@ static int dw3101_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		case(DW2102_RC_QUERY): {
 			u8 ibuf[2];
 
+			if (msg[0].len < 2) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			dw210x_op_rw(d->udev, 0xb8, 0, 0,
 				     ibuf, 2, DW210X_READ_MSG);
 			memcpy(msg[0].buf, ibuf, 2);
@@ -597,6 +626,10 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		case (DW2102_RC_QUERY): {
 			u8 ibuf[5];
 
+			if (msg[j].len < 2) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			dw210x_op_rw(d->udev, 0xb8, 0, 0,
 				     ibuf, 5, DW210X_READ_MSG);
 			memcpy(msg[j].buf, ibuf + 3, 2);
@@ -605,6 +638,10 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		case (DW2102_VOLTAGE_CTRL): {
 			u8 obuf[2];
 
+			if (msg[j].len < 2) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			obuf[0] = 1;
 			obuf[1] = msg[j].buf[1];/* off-on */
 			dw210x_op_rw(d->udev, 0x8a, 0, 0,
@@ -618,6 +655,10 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 		case (DW2102_LED_CTRL): {
 			u8 obuf[2];
 
+			if (msg[j].len < 1) {
+				ret = -EOPNOTSUPP;
+				goto unlock;
+			}
 			obuf[0] = 5;
 			obuf[1] = msg[j].buf[0];
 			dw210x_op_rw(d->udev, 0x8a, 0, 0,
@@ -647,7 +688,8 @@ static int s6x0_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
 						DW210X_READ_MSG);
 				memcpy(msg[j].buf, ibuf, msg[j].len);
 				break;
-			} else if ((msg[j].buf[0] == 0xb0) && (msg[j].addr == 0x68)) {
+			} else if (msg[j].len >= 1 &&
+				   (msg[j].buf[0] == 0xb0) && (msg[j].addr == 0x68)) {
 				/* write firmware */
 				u8 obuf[19];
 
@@ -737,6 +779,10 @@ static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
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
@@ -745,6 +791,10 @@ static int su3000_i2c_transfer(struct i2c_adapter *adap, struct i2c_msg msg[],
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
