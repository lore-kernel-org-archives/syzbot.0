Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 468073EB11C;
	Fri, 28 Aug 2026 08:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787906712; cv=none; b=a3XoMp8398lBvfZVtCJQga5Z6dVfu4mENU/kgWrZ5Bq+rYS4MpqIDFAtM/9h/4l2SmLZttouWTUFTWy1Bgj79oe4Wz3YPfY8pBMbfrFpgGdpmi5E10XCGnywX136XOGS31gpxZ1zmn74q018dgWUY0fq0ujohHuYZYQ3KtUkgo4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787906712; c=relaxed/simple;
	bh=AAxyp5gX71pB4dDjXWfErO4JILb3/9AF+dsB4mTitNY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Mppdd8bR9QNmCbuUd16wcsDL5hevnmyP4mMk2Lzvwgda4gA1efELSQYAWMhqkxV9xCLbTT2kBNdieFhvR7ppZA0lfrVCEbQGYbvxJGyj43nIPYwStI+WKiym0K992O6e6YqvWC0Ajz1U0JUwrwV+DTNDwkyhRxduRdmnsx9CvAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=D6I2CXuA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="D6I2CXuA"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 1313A1F000E9;
	Fri, 28 Aug 2026 08:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787906709;
	bh=6CtsLsRv78fXIZdE60pKI9RNtwYPJaFaX7sffE6oBmU=;
	h=From:To:Cc:Subject:Date;
	b=D6I2CXuAO++bNllg457qC06oA3hSKuPW2TNI+8oQDpXG5BXzNxET8W1vRgB8OAUtJ
	 fWuwP/frUCBLUEto1t1GEuStl0R+E5BJuCrIdIyRp+AmeLRS3MyyW2zc0uDd84MtXp
	 FyDsSyFoZMwcuwME5Igv/lYLxjAAJx4TQZlOLRgtPuFEmtAOgGtxuX5D5M7YZhx1SM
	 XwO8I8uMndOrCCkaooAPtk1tIIJhTw4EJfBqIptPRCNXl0UC+MYBAnNdEC3cMOuVS2
	 oetYcqAiZ0j2qsxabC+t4SfrZZRAJTe0IZLc/WP/h/QAdNOMm/bJNc20PRVRQQVMf7
	 K2u4awWihFJcw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-bugs@googlegroups.com, Aleksandr Nogikh <nogikh@google.com>, "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>, "Alan Stern" <stern@rowland.harvard.edu>, <usb-storage@lists.one-eyed-alien.net>, "Shichao Lai" <shichaorai@gmail.com>
Cc: linux-kernel@vger.kernel.org, syzbot@lists.linux.dev
Subject: [PATCH] usb-storage: alauda: Track media_initialized per port
Message-ID: <ea864031-b1e2-4b78-ab3a-58adf681efc6@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 28 Aug 2026 08:45:09 +0000 (UTC)

From: Aleksandr Nogikh <nogikh@google.com>

Commit 16637fea001a ("usb-storage: alauda: Check whether the media is
initialized") added a `media_initialized` boolean to `struct alauda_info`
to prevent `uzonesize` from remaining 0 on initialization failure. However,
`media_initialized` is shared between both LUNs (XD and SM media ports)
supported by the Alauda driver.

When the kernel probes LUN 0, it successfully initializes the media and
sets `media_initialized = true`. When it subsequently probes LUN 1,
`alauda_check_media()` sees that `media_initialized` is already true, skips
the initialization for LUN 1, and leaves its `uzonesize` as 0. Later, when
a read/write command is issued to LUN 1, the driver attempts to divide by
`uzonesize` in `alauda_read_data()`, resulting in a divide-by-zero
exception:

Oops: divide error: 0000 [#1] SMP KASAN NOPTI
CPU: 1 UID: 0 PID: 5849 Comm: usb-storage Not tainted
RIP: 0010:alauda_read_data drivers/usb/storage/alauda.c:954 [inline]
RIP: 0010:alauda_transport+0xbd6/0x43a0 drivers/usb/storage/alauda.c:1187
Call Trace:
 <TASK>
 usb_stor_invoke_transport+0x115/0x1a40 drivers/usb/storage/transport.c:611
 usb_stor_control_thread+0x44c/0x8f0 drivers/usb/storage/usb.c:462
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

To fix this, move the `media_initialized` boolean from `struct alauda_info`
to `struct alauda_media_info` so that each LUN tracks its initialization
state independently. Additionally, explicitly set `media_initialized =
false` when no media is present or before calling `alauda_init_media()`.
This ensures that if initialization fails halfway through, the driver won't
accidentally trust stale data from a previously inserted card.

Fixes: 16637fea001a ("usb-storage: alauda: Check whether the media is initialized")
Assisted-by: Gemini:gemini-3.7-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+dc208a8cf8d37cf3e5ac@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=dc208a8cf8d37cf3e5ac
Link: https://syzkaller.appspot.com/ai_job?id=87935d94-4387-493a-8061-bcb7752c517c
Signed-off-by: Aleksandr Nogikh <nogikh@google.com>

---
diff --git a/drivers/usb/storage/alauda.c b/drivers/usb/storage/alauda.c
index 691fe4700..807492f75 100644
--- a/drivers/usb/storage/alauda.c
+++ b/drivers/usb/storage/alauda.c
@@ -96,6 +96,8 @@ struct alauda_media_info {
 
 	u16 **lba_to_pba;		/* logical to physical block map */
 	u16 **pba_to_lba;		/* physical to logical block map */
+
+	bool media_initialized;
 };
 
 struct alauda_info {
@@ -105,8 +107,6 @@ struct alauda_info {
 	unsigned char sense_key;
 	unsigned long sense_asc;	/* additional sense code */
 	unsigned long sense_ascq;	/* additional sense code qualifier */
-
-	bool media_initialized;
 };
 
 #define short_pack(lsb,msb) ( ((u16)(lsb)) | ( ((u16)(msb))<<8 ) )
@@ -471,6 +471,7 @@ static int alauda_check_media(struct us_data *us)
 		|| ((status[1] & 0x01) == 0)) {
 		usb_stor_dbg(us, "No media, or door open\n");
 		alauda_free_maps(&MEDIA_INFO(us));
+		MEDIA_INFO(us).media_initialized = false;
 		info->sense_key = 0x02;
 		info->sense_asc = 0x3A;
 		info->sense_ascq = 0x00;
@@ -478,12 +479,13 @@ static int alauda_check_media(struct us_data *us)
 	}
 
 	/* Check for media change */
-	if (status[0] & 0x08 || !info->media_initialized) {
+	if (status[0] & 0x08 || !MEDIA_INFO(us).media_initialized) {
 		usb_stor_dbg(us, "Media change detected\n");
 		alauda_free_maps(&MEDIA_INFO(us));
+		MEDIA_INFO(us).media_initialized = false;
 		rc = alauda_init_media(us);
 		if (rc == USB_STOR_TRANSPORT_GOOD)
-			info->media_initialized = true;
+			MEDIA_INFO(us).media_initialized = true;
 		info->sense_key = UNIT_ATTENTION;
 		info->sense_asc = 0x28;
 		info->sense_ascq = 0x00;


base-commit: 8d3ae59288f1e7d58d76558a6ee96d533bc5019f
-- 
See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
