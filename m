Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7B93B27D8
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 19:29:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779218980; cv=none; b=O7yPBqen0Np5/2eNSwI1KAor9zd79TxiNfb6rRjhaLEjjmdpNgQtuNKerB5Jp+DeKckxB/qBEZxRQ8yZ6BCjUyajxkr4bz6563JJ+/wEyh1T6bAl0BK1KrzXIIDe9N8gW3JJ0fkG3wx7HuiGMe5gKcjzeMPr7c26dLey817PmNQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779218980; c=relaxed/simple;
	bh=e6+w9a3RtJxWwmGi4V0BGQetDWmXeVYKhK7SrYz3et8=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=HKvvVzKywKr/IqcTR5aQF2QEZZUzQcpEUWV13bi+nmBSsnxjsDumJ4duKjDSWRM/xWKUnlCJ/vohWwIyQqU24GbWZO74JYtlfUYS+ZZUxMHRKvgDqEKwT7sXB8LaoXy2ngI9V6K0XSEQ1AR1Dy4lLg6K385ekdY7g618SAkEmOc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QQlEk7vg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QQlEk7vg"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id A19F31F000E9;
	Tue, 19 May 2026 19:29:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1779218978;
	bh=5ZNQ+B19UVIF7PvwidjDa4lDwnEVfWcxm17lx7WaF2g=;
	h=From:To:Cc:Subject:Date;
	b=QQlEk7vgP/sVfX1FjsjZrNynB87eCTUC2fcnK4UtoyPLulg+MAAThowN6k9ahEs19
	 PfPenEnmvXis1f2XvxPcLCItnB2yJsSVkok3nyF98PzJ7V7Utv9xPI+F4PLzJS32XF
	 AmOojh0TJynZPiXbJ6NeAt6sJU1CFQXBW5Rmimejik4IUOP5GJreZ67gVukeINqWxe
	 vcFVTcVGzxCvBVvqnZ6ZZ4X+MqwBN0mR6/MfiVijB5ce7ZJw1VJRzi2fS1adj+KJFu
	 CSg3HM8XtWe7fhj982VWqmkek2beuqipzorfoYpZT6GyH1SXYOnvDy4CQr4ZRJoI4C
	 wdS5VbxOVCl8g==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] HID: mcp2221: fix OOB read in mcp2221_raw_event()
Message-ID: <c9c1296e-ea36-4b0c-9b2e-5fe1ea6f4328@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 19 May 2026 19:29:38 +0000 (UTC)

syzbot reported a slab-out-of-bounds read in mcp2221_raw_event(). This
happens because the driver does not validate the size of the incoming
HID report and blindly processes it based on the command byte data[0],
without verifying if the report is actually a response to the command
the driver just sent.

If the device sends an MCP2221_GPIO_SET (0x50) input report before any
GPIO operations are performed (or if a malicious device injects one),
mcp->gp_idx is still 0. The expression mcp->gp_idx - 1 results in -1,
causing the code to access data[-1], which reads out of the bounds of
the URB transfer buffer.

To fix this, ensure that the report size is at least
MCP2221_IN_REPORT_LEN (64 bytes). Also, explicitly validate mcp->gp_idx
in the MCP2221_GPIO_GET and MCP2221_GPIO_SET handlers to ensure it is
within valid bounds before using it as an array index, preventing the
out-of-bounds access.

Fixes: 328de1c519c5 ("HID: mcp2221: add GPIO functionality support")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot+1018672fe70298606e5f@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=1018672fe70298606e5f
Link: https://syzkaller.appspot.com/ai_job?id=168a7ea8-8005-4cb7-971d-e14829cf3b9b
To: <bentiss@kernel.org>
To: <gupt21@gmail.com>
To: <jikos@kernel.org>
To: <linux-i2c@vger.kernel.org>
To: <linux-input@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Replaced the raw numeric value 64 with the MCP2221_IN_REPORT_LEN macro.
- Removed the data[0] != mcp->txbuf[0] check.
- Added explicit bounds checking for mcp->gp_idx in the MCP2221_GPIO_GET and MCP2221_GPIO_SET handlers.

v1:
https://lore.kernel.org/all/ea8bba94-ca4f-4a7b-9181-a858d92b6ca9@mail.kernel.org/T/
---
diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index e4ddd8e92..40d324990 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -80,6 +80,8 @@ enum {
 	MCP2221_SRAM_WR_GP3 = 11,
 };
 
+#define MCP2221_IN_REPORT_LEN 64
+
 #define MCP2221_SRAM_GP_DESIGN_MASK		0x07
 #define MCP2221_SRAM_GP_DIRECTION_MASK		0x08
 #define MCP2221_SRAM_GP_VALUE_MASK		0x10
@@ -861,6 +863,9 @@ static int mcp2221_raw_event(struct hid_device *hdev,
 	u8 *buf;
 	struct mcp2221 *mcp = hid_get_drvdata(hdev);
 
+	if (unlikely(size < MCP2221_IN_REPORT_LEN))
+		return 1;
+
 	switch (data[0]) {
 
 	case MCP2221_I2C_WR_DATA:
@@ -943,6 +948,10 @@ static int mcp2221_raw_event(struct hid_device *hdev,
 	case MCP2221_GPIO_GET:
 		switch (data[1]) {
 		case MCP2221_SUCCESS:
+			if (unlikely(mcp->gp_idx < 2)) {
+				mcp->status = -EIO;
+				break;
+			}
 			if ((data[mcp->gp_idx] == MCP2221_ALT_F_NOT_GPIOV) ||
 				(data[mcp->gp_idx + 1] == MCP2221_ALT_F_NOT_GPIOD)) {
 				mcp->status = -ENOENT;
@@ -960,6 +969,10 @@ static int mcp2221_raw_event(struct hid_device *hdev,
 	case MCP2221_GPIO_SET:
 		switch (data[1]) {
 		case MCP2221_SUCCESS:
+			if (unlikely(mcp->gp_idx < 1)) {
+				mcp->status = -EIO;
+				break;
+			}
 			if ((data[mcp->gp_idx] == MCP2221_ALT_F_NOT_GPIOV) ||
 				(data[mcp->gp_idx - 1] == MCP2221_ALT_F_NOT_GPIOV)) {
 				mcp->status = -ENOENT;


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
