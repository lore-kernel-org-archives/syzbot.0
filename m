Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AAE433803E3
	for <syzbot@lists.linux.dev>; Fri, 14 Aug 2026 09:42:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786700530; cv=none; b=uky06FXQKKlx2w4MRqvibDynfIUS/vNkqnwVhwOT34klmBjJXNPnKVIjH/UdKhte9n8QPfZ7NkVx7h7BuHKIxWQfQjTTxmSzxd7klhWnvoQAqiu6nj9WJoF585xjts9C0qznlLzL99AG03p4bhR0mG21aZa1i/7cAISD9Ek0QeA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786700530; c=relaxed/simple;
	bh=ayjqZdtIfG+SddWOfSBLLlcm/oLcUFcnV+cwQArJMgA=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=lo1RyuBnsWQ7ryb+Q7EpcxQOq6Yabp4wrxWalVj/oBl9NEXbRAn3j1aRRflXZalqHdl+x0BEoXGUSMt5vxqFPBHj29h8/SgxTzbVLS2ez6NgXv1zPJTSmShN84AackcfArmY9cGplmEGPNlzxewv9om5bgi0asisQoPEW8un6oo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=DxjyX97Y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="DxjyX97Y"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 0E7E61F000E9;
	Fri, 14 Aug 2026 09:42:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786700529;
	bh=kW7UI5HHYp9Ms8R6+ADLOqH6MRi1pvTXhWIwZ/L/+68=;
	h=From:To:Cc:Subject:Date;
	b=DxjyX97YtXL7bm6K/NkXET2RwhUxXqD92bEkHD2SLrdO7zI73AVZYjrNaVYYx/2Ux
	 jw9EBYHOiKYTbSD9LUwctfxdiFKVMCbRbPfOd75shc5epQArnSNempPuIa604wazlY
	 iS/9H0bfyM05fMTmBnk4UNWzAIAZyxjAtGBO11ccUty8FqZvwmpdT+8BXD8MAVAMsV
	 Qn0ukzcU2pLn3pbjzTluOURXrEKXBpae8KFeYC8FtaJF5qSH7LkCxUDcu2fZ2e1kKL
	 1qXKPv+xdYwEjALZo0dxkd9q19TCCr6ZIw5jaOPXqiIA3FXMv9arQJ51w9YdwikqHO
	 3XBndsUh+TqHg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] Input: serio - check if device is registered in serio_find_driver()
Message-ID: <94a2df4a-c0d2-4a29-a692-e7250a623057@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri, 14 Aug 2026 09:42:09 +0000 (UTC)

A general protection fault can occur in __device_attach() due to a race
condition between serio_add_port() and serio_interrupt() when device_add()
fails.

If device_add() fails (e.g., due to a memory allocation failure), it cleans
up and sets dev->p = NULL. However, there is a brief window during
device_add() where kobject_add() sets state_in_sysfs = 1, causing
device_is_registered() to return true. If an interrupt occurs during this
window, serio_interrupt() might queue a SERIO_RESCAN_PORT event.

When the workqueue processes this stale event, it eventually calls
serio_find_driver(), which directly invokes device_attach() without
verifying if the device was successfully registered. This leads to a NULL
pointer dereference when __device_attach() attempts to lock the device
using the freed dev->p.

Oops: general protection fault, probably for non-canonical address
0xdffffc0000000021: 0000 [#1] SMP KASAN NOPTI
KASAN: null-ptr-deref in range [0x0000000000000108-0x000000000000010f]
CPU: 1 UID: 0 PID: 5689 Comm: kworker/1:4 Not tainted
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events_long serio_handle_event
RIP: 0010:__device_attach+0xb3/0x450 drivers/base/dd.c:1074
Call Trace:
 <TASK>
 serio_find_driver drivers/input/serio/serio.c:112 [inline]
 serio_handle_event+0x581/0x860 drivers/input/serio/serio.c:206
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Fix this by checking if the device is registered in serio_find_driver()
before attempting to attach a driver, safely ignoring any stale events for
devices that failed registration.

Fixes: ddf1ffbd40c9 ("Input: serio - let device core tell us if device was registered")
Assisted-by: Gemini:gemini-3.6-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+de42beb9ccc760a210ab@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=de42beb9ccc760a210ab
Link: https://syzkaller.appspot.com/ai_job?id=4397f1ef-be0d-4e1b-897a-fcd37e50cc6b
To: "Dmitry Torokhov" <dmitry.torokhov@gmail.com>
To: <linux-input@vger.kernel.org>
Cc: "Kees Cook" <kees@kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/input/serio/serio.c b/drivers/input/serio/serio.c
index 54dd26249..c24e431af 100644
--- a/drivers/input/serio/serio.c
+++ b/drivers/input/serio/serio.c
@@ -109,6 +109,9 @@ static void serio_find_driver(struct serio *serio)
 {
 	int error;
 
+	if (!device_is_registered(&serio->dev))
+		return;
+
 	error = device_attach(&serio->dev);
 	if (error < 0 && error != -EPROBE_DEFER)
 		dev_warn(&serio->dev,


base-commit: db2ddb87143519e20a95aa36c60b36107b736a58
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
