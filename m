Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA273E8C77
	for <syzbot@lists.linux.dev>; Wed, 26 Aug 2026 12:32:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787747544; cv=none; b=QeQcwz7/Hywua20CrWWAFA6/tDa3oM9MPD4sj6LhobxijDXzau5VzJKkKt0lciaj1rQAlWBkgN63yR0nFILXwitJoSDQzuSVQX/CFYdDkdWrn03ELBCASRO9DNH28B/tH08KdNG+5e7WGpaaDtb5A/u1lj4S9YtXqliSaoBtUNA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787747544; c=relaxed/simple;
	bh=vQsnqX5COhU2rXLp51qBlsbv5mKlh1tDhIMyHnI3mCA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=KRB9cQ7VTIE3ANb9Om41469W4s03PWkhZWTdU+BekBWEXBfJxPEQ3U46Z4ahHz8z746apD31lKSa3XslmvBjrEM4ZclKdhgVztqi0FEq9+I8WsVZBXnWvKD8JjkM069uJMLkIs96PSH3fCRo8fR6bPJb8o+Pw1AgSaGz9lAzK9w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iVNHWAz4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iVNHWAz4"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 5D9E21F000E9;
	Wed, 26 Aug 2026 12:32:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787747542;
	bh=ipZ4Gnt0HXtoARhtDo5imHzjWS6EzDfgEpKWXndYdRw=;
	h=From:To:Cc:Subject:Date;
	b=iVNHWAz4rIFlLzq/mwv9pWtf75ufRUtG5CpOZhYLr5Fztx7U9Yzjsb5WlCu6EuZbl
	 +CVBLKdBC4cG7BcJzghgPgi5oP2CUgcpebG3xUQPbvATrcwwmifmCaNqD9tcFZCwqf
	 EHDaEi6SRyNyzXOSz987x424niopbxipt+8Wo51nzYTqGVZNaWt8FC5GUAIF6NeKB9
	 +AjA31bfk8MwHIqi6V8Pqp9LPDcaSDy1iz0moQ75Kh3ECkgW7C8QxYlKtjZ8qDxnSl
	 Js9ObVYHslDI2asgOUVCBPeXVqiom5hahyg7C/bnNBm4D6STp5ZcF54wf+9moLiFwf
	 lt139aCHkoNaQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb-storage: alauda: Track media_initialized per port
Message-ID: <6a872422-fe69-4f50-8fa1-20fe34af5da2@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed, 26 Aug 2026 12:32:22 +0000 (UTC)

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
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Alan Stern" <stern@rowland.harvard.edu>
To: <usb-storage@lists.one-eyed-alien.net>
To: "Shichao Lai" <shichaorai@gmail.com>
Cc: <linux-kernel@vger.kernel.org>

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
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
