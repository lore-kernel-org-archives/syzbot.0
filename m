Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E4F3AFB0C
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 08:26:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786091199; cv=none; b=eHJBzWYCNgdatOVQaeOL5F2LTK6rFG00pTmpL/KvytqdpolzUGnW7oDipG6tufdSqT0+GbMMJFPZUtBURAq4jXHxkFN8WTmT9Kh9SfUt/wOdLBWiTxmxGgPpHxXLKuJtezAjbdHqNyF8ROCVmuu43AB5EKr+kjFa31tFSFVnH6M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786091199; c=relaxed/simple;
	bh=5F0Te0Wjvk9lChbsKDKA6yRknTUZvdTpGQSNybZbkjI=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ph9pmu4HHUq5pQGUq5S6FZF/09wNMhXzdM5MSpk530oDFUr3wPLoxmF9N/J34VasjpUXvovPGK3uJLem/TAPevSmVIPxW5eNtaRvyxhAcy0c9TpiYOlYp0TmKrKQ1VnWrmsiK2xVwwWFxfV8Cn5UEJ4o3xFM3f1GiPPKgaf2DaM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ANXh0Sjj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ANXh0Sjj"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id BD24E1F000E9;
	Fri,  7 Aug 2026 08:26:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786091197;
	bh=KZUkwIY8RAjgr+tjHh3sXl4o4ylV+nFut/kXoxMjhsQ=;
	h=From:To:Cc:Subject:Date;
	b=ANXh0SjjRc0R1wNo3Zm1fz6VdYsmsKhsqSqZtTtmoWaI1EsmkH5JJebE2U11Qpv5K
	 crtplZYifO17g5M3uLQr7qN4rWhZNq2/Khos4snp7rW7cOs0oRpvhbm+AMtsYveqdN
	 DYLinsQz8IDvnsDsQTqS66AvQAbHl5/z3AzU6VrV4FLxDz8t8qgn4XCfRQGzjYccX6
	 Am+RRl9tsq/RVUHgTNZGUsnK8bXzivsd5lQP3xArHMKKxM8uoU1H/ba6jMrTmgh8Ku
	 842cQi8uptAmKLXW9Gw7i/2NcWEaxQPepgl9XXdEIxsilL6ABSWc2vLlhtsIWZFdPL
	 ZU19AJ/0m0DCw==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usbip: vhci_hcd: add timeout for URB unlink requests
Message-ID: <1d6db53d-07ab-46ad-adc4-d09c95b2c83f@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 08:26:37 +0000 (UTC)

When a device is attached to a vhci_hcd port, the USB hub worker thread
calls hub_port_connect() and acquires the address0_mutex. It then sends a
synchronous USB control message to the device. If the user-space server
does not reply, the control message times out, and usb_kill_urb() is called
to cancel the URB. usb_kill_urb() invokes the HCD's dequeue function,
vhci_urb_dequeue(), which queues a CMD_UNLINK request to the socket and
expects a RET_UNLINK reply from user-space. usb_kill_urb() then waits
indefinitely for the URB's use_count to drop to 0.

If the user-space server never replies with RET_UNLINK, the URB is never
given back, and the worker thread blocks forever in usb_kill_urb(), holding
the address0_mutex. Since address0_mutex is shared between the primary (USB
2.0) and shared (USB 3.0) HCDs, any subsequent device attach on the other
HCD will block forever attempting to acquire the same mutex, leading to a
system-wide hung task:

INFO: task kworker/1:2:798 blocked for more than 15 seconds.
task:kworker/1:2     state:D stack:23848 pid:798   tgid:798   ppid:2
task_flags:0x4208060 flags:0x00080000
Workqueue: usb_hub_wq hub_event
Call Trace:
 <TASK>
 __schedule+0x17e7/0x5630 kernel/sched/core.c:7234
 schedule+0x164/0x2b0 kernel/sched/core.c:7326
 schedule_preempt_disabled+0x13/0x30 kernel/sched/core.c:7383
 __mutex_lock_common kernel/locking/mutex.c:726 [inline]
 __mutex_lock+0x7bf/0x1550 kernel/locking/mutex.c:821
 hub_port_connect drivers/usb/core/hub.c:5465 [inline]
 hub_port_connect_change drivers/usb/core/hub.c:5707 [inline]
 port_event drivers/usb/core/hub.c:5871 [inline]
 hub_event+0x20c9/0x4d30 drivers/usb/core/hub.c:5953
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0x92d/0xe10 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

To fix this, introduce a timeout mechanism for unlink requests in vhci_hcd.
When vhci_urb_dequeue() queues a CMD_UNLINK, it now starts a timer with a
4-second timeout. If the timer expires before a RET_UNLINK is received, the
timer callback assumes the server is unresponsive and triggers a connection
teardown via usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_TCP). When the
connection is shut down, vhci_device_unlink_cleanup() iterates over the
pending unlink requests and manually gives back the URBs, unblocking
usb_kill_urb() and releasing the address0_mutex.

Fixes: 04679b3489e0 ("Staging: USB/IP: add client driver")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+a7edecbf389d11a369d4@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=a7edecbf389d11a369d4
Link: https://syzkaller.appspot.com/ai_job?id=1b7c6a35-c4a5-4834-9631-46f7e83cbd57
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Shuah Khan" <shuah@kernel.org>
To: "Valentina Manea" <valentina.manea.m@gmail.com>
To: "Takahiro Hirofuchi" <hirofuchi@users.sourceforge.net>
Cc: "Hongren Zheng" <i@zenithal.me>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/usbip/vhci.h b/drivers/usb/usbip/vhci.h
index 5659dce15..98e3bfb29 100644
--- a/drivers/usb/usbip/vhci.h
+++ b/drivers/usb/usbip/vhci.h
@@ -11,6 +11,7 @@
 #include <linux/list.h>
 #include <linux/spinlock.h>
 #include <linux/sysfs.h>
+#include <linux/timer.h>
 #include <linux/types.h>
 #include <linux/usb.h>
 #include <linux/usb/hcd.h>
@@ -65,6 +66,9 @@ struct vhci_unlink {
 
 	/* seqnum of the unlink target */
 	unsigned long unlink_seqnum;
+
+	struct timer_list unlink_timer;
+	struct vhci_device *vdev;
 };
 
 enum hub_speed {
diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index 39e8faf4c..5cc276f46 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -892,6 +892,14 @@ static int vhci_urb_enqueue(struct usb_hcd *hcd, struct urb *urb, gfp_t mem_flag
  *		=> send RET_UNLINK
  *
  */
+static void vhci_unlink_timeout(struct timer_list *t)
+{
+	struct vhci_unlink *unlink = timer_container_of(unlink, t, unlink_timer);
+	struct vhci_device *vdev = unlink->vdev;
+
+	usbip_event_add(&vdev->ud, VDEV_EVENT_ERROR_TCP);
+}
+
 static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 {
 	struct vhci_hcd *vhci_hcd = hcd_to_vhci_hcd(hcd);
@@ -964,6 +972,10 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 			dev_info(hcd_dev(hcd), "seqnum max\n");
 
 		unlink->unlink_seqnum = priv->seqnum;
+		unlink->vdev = vdev;
+
+		timer_setup(&unlink->unlink_timer, vhci_unlink_timeout, 0);
+		mod_timer(&unlink->unlink_timer, jiffies + msecs_to_jiffies(4000));
 
 		/* send cmd_unlink and try to cancel the pending URB in the
 		 * peer */
@@ -997,7 +1009,12 @@ static void vhci_cleanup_unlink_list(struct vhci_device *vdev,
 		urb = pickup_urb_and_free_priv(vdev, unlink->unlink_seqnum);
 		if (!urb) {
 			list_del(&unlink->list);
+			spin_unlock(&vdev->priv_lock);
+			spin_unlock_irqrestore(&vhci->lock, flags);
+			timer_delete_sync(&unlink->unlink_timer);
 			kfree(unlink);
+			spin_lock_irqsave(&vhci->lock, flags);
+			spin_lock(&vdev->priv_lock);
 			continue;
 		}
 
@@ -1010,6 +1027,7 @@ static void vhci_cleanup_unlink_list(struct vhci_device *vdev,
 		spin_unlock(&vdev->priv_lock);
 		spin_unlock_irqrestore(&vhci->lock, flags);
 
+		timer_delete_sync(&unlink->unlink_timer);
 		usb_hcd_giveback_urb(hcd, urb, urb->status);
 
 		spin_lock_irqsave(&vhci->lock, flags);
diff --git a/drivers/usb/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
index a678e7c89..658a464a1 100644
--- a/drivers/usb/usbip/vhci_rx.c
+++ b/drivers/usb/usbip/vhci_rx.c
@@ -178,6 +178,7 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 		usb_hcd_giveback_urb(vhci_hcd_to_hcd(vhci_hcd), urb, urb->status);
 	}
 
+	timer_delete_sync(&unlink->unlink_timer);
 	kfree(unlink);
 }
 


base-commit: 075b74841bd0065a3bda3440873c747938e69b68
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
The person who has signed off on the patch is responsible for
addressing comments.
syzbot engineers can be reached at syzkaller@googlegroups.com.
