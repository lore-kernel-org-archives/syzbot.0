Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ED4484968EA
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 11:39:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779190781; cv=none; b=VlR8hfOWKJldVX+X79ZNaVkY5AQfZb9CySlB1OnxngSjh6ONfkIp9E9FwKsA/Vccq6aaOfzTw/7OJsQ+6akmTcB8nvj4zfmBTWYzMeWJL7Sl27Zyph3e62x2Tob6NXCTOUtiWhebMs0JAQT9RfSaXuemW8jqm8D8JPcSs/w02rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779190781; c=relaxed/simple;
	bh=f/PlICnvfFSG3rFiHVRZ72gxcKjsoPXlzBeu3awrwMQ=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=BYKTRzwZbWeXZJqEx1e3Uz1JIL6XmWoeFemnWOQNZIevak5CX8Xg3z8RyFKP4P5Y7HKMStmdDcfnteOhb8Sv7RkgE0EgReO9rly/JoUNuKOJPU/vOJmryXAECSgFYAXX4m6GaKR15DSZ4y+BCklu6SVl4pwMAvTCGWsgFkYAc3w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eQ3ClXOs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eQ3ClXOs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 65FB1C2BCC7;
	Tue, 19 May 2026 11:39:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779190779;
	bh=f/PlICnvfFSG3rFiHVRZ72gxcKjsoPXlzBeu3awrwMQ=;
	h=From:To:Cc:Subject:Date:From;
	b=eQ3ClXOso24kUF2aUcSO8sFW4TbM/P9h+roT7WFKuE95NKvV8adiTpGD76GguZ26/
	 umwaQumiOp3/NteBq1oUY5W0XX/x8Uazm5XQfCeOpCOhBhEwsQOjCoeZ3UoRlWDaqJ
	 aI9eqODGPtbFKhfPWOjVumtREthc6LBRsHb1aIib/wYba75gLfP+ywh7BhDSPb3Ula
	 C1dfLFuBFNJ12CfnIb0x497SjabpD0DOz/P6SZJG7kJxJVakXRvbkLXvQ5ONzJ5CqY
	 aRRDgLYgd4H6tOIroShioXmFZ0Qp33d9qVoiTAEgkBBZOtan3NJcnLLWORuzcN/BI1
	 gXK0QpWQKnE9w==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] HID: mcp2221: fix OOB read in mcp2221_raw_event()
Message-ID: <ea8bba94-ca4f-4a7b-9181-a858d92b6ca9@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 19 May 2026 11:39:38 +0000 (UTC)

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

To fix this, ensure that the report size is at least 64 bytes (the
expected report size for MCP2221). Also, verify that the incoming report
matches the currently pending command by checking data[0] !=
mcp->txbuf[0]. Since mcp->txbuf[0] and mcp->gp_idx are always set
together when sending GPIO commands, this check inherently guarantees
that mcp->gp_idx is valid and correctly initialized for the specific
command being processed, preventing the out-of-bounds access.

Fixes: 328de1c519c5 ("HID: mcp2221: add GPIO functionality support")
Assisted-by: Gemini:gemini-3.1-pro-preview
Reported-by: syzbot+1018672fe70298606e5f@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=1018672fe70298606e5f
Link: https://syzkaller.appspot.com/ai_job?id=770c0407-c1fc-4070-a4e7-4ccade9bc122
To: <bentiss@kernel.org>
To: <gupt21@gmail.com>
To: <jikos@kernel.org>
To: <linux-i2c@vger.kernel.org>
To: <linux-input@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/hid/hid-mcp2221.c b/drivers/hid/hid-mcp2221.c
index e4ddd8e92..7f4f2110b 100644
--- a/drivers/hid/hid-mcp2221.c
+++ b/drivers/hid/hid-mcp2221.c
@@ -861,6 +861,12 @@ static int mcp2221_raw_event(struct hid_device *hdev,
 	u8 *buf;
 	struct mcp2221 *mcp = hid_get_drvdata(hdev);
 
+	if (unlikely(size < 64))
+		return 1;
+
+	if (data[0] != mcp->txbuf[0])
+		return 1;
+
 	switch (data[0]) {
 
 	case MCP2221_I2C_WR_DATA:


base-commit: 5200f5f493f79f14bbdc349e402a40dfb32f23c8
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
