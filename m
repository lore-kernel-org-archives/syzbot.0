Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DABD7477281
	for <syzbot@lists.linux.dev>; Wed,  5 Aug 2026 15:45:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785944723; cv=none; b=CyVkYiviBqA9oPpqef2knxusZikIDd3zasKGdx8MpOGvzg3mN9DuP8M6mmZrNrs+2Yk6a7jIXbXcaEtZL2P/MTuKE45o4o6VfWfwhgdb/wN/j2wH4yJbT/HKr3HuZaGRWe2iI+rJ2PYYcJTKqTRiHxgMPW5GMKxVTYdSr1n9ZEc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785944723; c=relaxed/simple;
	bh=JH8IyLV2DftRqEbzsgO6f4cGfrCxOlN/SWyWsrBMFaU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=lLr70XG7pWYtwoa3ERX6v/KvHyr7fHGCT1fAh+Ho8fvGkYLHfIakYEU86y0zXxpt7uUQJWxDlJUMn6jB9ouI4I2sK5c3poOckEDnQyc7UUa79CYA/wLZB+cs5sYhPXBXdzEmOGUPmwvSByfCkW6K0RFuEQRPVgBoAAvAzX+gFCI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=iLrvmNf0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="iLrvmNf0"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 6C67F1F000E9;
	Wed,  5 Aug 2026 15:45:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785944718;
	bh=Q3BghsquyUBIQCdnWnKfa7kTkkomipj7momkTTJifuM=;
	h=From:To:Cc:Subject:Date;
	b=iLrvmNf06u5VhGu+ZjP/suxKcpBUa1bmfbzSaE2zVm/dBs0PcVC7FTN/Ysa9Q2ttx
	 vsqQxz96zC98/SVTcJZH/sSZnttmdJ09F0y+3pcoCBKadl/4KMQZtz4FSKXHF8BquJ
	 Y5pMjgzCFNHRTn8Yf5wlnSkJwCjvZ7LTDPzcLF6RTfl0uRAMqtQ+BuQ6s1xRT3VmHN
	 O36/uaEEdrKHNQWv0p7mTafflYemXVA7XpUE8oycEtQ+YphYpwxZpSCUygKLL6OFxi
	 YQK4GETIk3QMtNjqxPv47au7dTCXiieC9Gy92lyLEEQf3KeGIfiIdafT4X+HEn+LIs
	 UnX2/YKXSeZtA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usbip: fix use-after-free in event handler during device teardown
Message-ID: <d8bac699-d54d-4ad0-acc4-a095464e2172@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Wed,  5 Aug 2026 15:45:18 +0000 (UTC)

During device teardown (e.g., when unbinding a device), `vhci_stop()` calls
`usbip_stop_eh()` to wait for the `event_handler` workqueue to finish
processing shutdown events. `usbip_stop_eh()` uses
`wait_event_interruptible()`. If the user-space process triggering the
teardown receives a signal, the wait is aborted immediately. Since the
return value is ignored, the teardown path proceeds to free the `vhci_hcd`
(and the embedded `usbip_device`) while the `event_handler` is still
actively using it, resulting in a use-after-free.

Even if `wait_event_interruptible()` is changed to `wait_event()`, a
secondary race exists. The `event_handler` pops events from a global
`event_list` before processing them. If `usbip_event_add()` is called
concurrently, it might allocate and add a second event to the list because
the first one was already popped. When `event_handler` finishes processing
the first event, it clears the event flags and wakes up `usbip_stop_eh()`.
`usbip_stop_eh()` sees the flags are cleared, returns, and the device is
freed. However, the `event_handler` then loops back, pops the second event
from the list, and attempts to access the now-freed device structure.

Fix this by changing `wait_event_interruptible()` to `wait_event()` so that
the teardown path waits uninterruptibly, guaranteeing that background tasks
have logically finished before memory is freed. Additionally, add a
`flush_workqueue(usbip_queue)` call immediately after `wait_event()` to act
as a strict synchronization barrier, ensuring that the worker thread has
completely drained the `event_list` and exited the function before
`usbip_stop_eh()` returns and the device is freed. The declarations of
`usbip_queue` and `usbip_work` are moved above `usbip_stop_eh()` to allow
calling `flush_workqueue()`.

BUG: KASAN: slab-use-after-free in __raw_spin_lock_irqsave
include/linux/spinlock_api_smp.h:132 [inline]
BUG: KASAN: slab-use-after-free in _raw_spin_lock_irqsave+0x40/0x60
kernel/locking/spinlock.c:166
Read of size 1 at addr ffff88811cecc478 by task kworker/u8:5/6058

Call Trace:
 <TASK>
 lock_acquire+0x84/0x350 kernel/locking/lockdep.c:5842
 __raw_spin_lock_irqsave include/linux/spinlock_api_smp.h:132 [inline]
 _raw_spin_lock_irqsave+0x40/0x60 kernel/locking/spinlock.c:166
 unset_event drivers/usb/usbip/usbip_event.c:35 [inline]
 event_handler+0x2b0/0x4b0 drivers/usb/usbip/usbip_event.c:80
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Fixes: bb7871ad99ea ("usbip: event handler as one thread")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+31117fde582fe6a0cd62@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=31117fde582fe6a0cd62
Link: https://syzkaller.appspot.com/ai_job?id=48067f76-5bee-4b9c-a4d6-69685bd6f80d
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Shuah Khan" <shuah@kernel.org>
To: "Valentina Manea" <valentina.manea.m@gmail.com>
To: "Nobuo Iwata" <nobuo.iwata@fujixerox.co.jp>
Cc: "Hongren Zheng" <i@zenithal.me>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/usbip/usbip_event.c b/drivers/usb/usbip/usbip_event.c
index 0e00c2d00..e498102e8 100644
--- a/drivers/usb/usbip/usbip_event.c
+++ b/drivers/usb/usbip/usbip_event.c
@@ -105,6 +105,11 @@ int usbip_start_eh(struct usbip_device *ud)
 }
 EXPORT_SYMBOL_GPL(usbip_start_eh);
 
+#define WORK_QUEUE_NAME "usbip_event"
+
+static struct workqueue_struct *usbip_queue;
+static DECLARE_WORK(usbip_work, event_handler);
+
 void usbip_stop_eh(struct usbip_device *ud)
 {
 	unsigned long pending = ud->event & ~USBIP_EH_BYE;
@@ -115,16 +120,12 @@ void usbip_stop_eh(struct usbip_device *ud)
 	if (pending)
 		usbip_dbg_eh("usbip_eh waiting completion %lx\n", pending);
 
-	wait_event_interruptible(ud->eh_waitq, !(ud->event & ~USBIP_EH_BYE));
+	wait_event(ud->eh_waitq, !(ud->event & ~USBIP_EH_BYE));
+	flush_workqueue(usbip_queue);
 	usbip_dbg_eh("usbip_eh has stopped\n");
 }
 EXPORT_SYMBOL_GPL(usbip_stop_eh);
 
-#define WORK_QUEUE_NAME "usbip_event"
-
-static struct workqueue_struct *usbip_queue;
-static DECLARE_WORK(usbip_work, event_handler);
-
 int usbip_init_eh(void)
 {
 	usbip_queue = create_singlethread_workqueue(WORK_QUEUE_NAME);


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
