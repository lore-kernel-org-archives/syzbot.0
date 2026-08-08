Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13EC439CCFA
	for <syzbot@lists.linux.dev>; Sat,  8 Aug 2026 19:44:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786218243; cv=none; b=tuj86QaJLPMsuWFX5NjV9+1FAM2CALA5RVEdM2MZHPYWKnBzqmRdbR2RSs4Z+9wQ5cYaXdFrdcUsWfveRX3OJADG7EgOhyldTEzENR2Bjb5E+pZ3Ga9+NgnePKQ7lXf+z3ZGJ4idZpXcZN/wRY3nhKoIik26r/ZjIQQ1Ug6m8rM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786218243; c=relaxed/simple;
	bh=JfUQfr5oAVHpx2Uu0d1yO+KswzJrMJ9l8zz4vqjO7EU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=D2d1frLa7HOlXx7BjWPAwtBWjSzk+FW0zFlL6sVj9gs7i/MXcRPfIJjzvlL1IQeFodqmsgFr5Oxyd80xGWkUQdGEoHBAYVJbnmqdkkdaYCyxD4OG+ExdsmSLd+zAmXkx7hJdmJepvcCEXKKJ+xM/yMb0RbaPt6Q0GbCxiYqV3og=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Z32HqjtG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Z32HqjtG"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9773A1F000E9;
	Sat,  8 Aug 2026 19:44:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786218241;
	bh=Hy4rYur6pQlbHqlY7Wj2BD5UHrVyZc5mbgzpQSW3Ups=;
	h=From:To:Cc:Subject:Date;
	b=Z32HqjtGxueT1ngZu775IMqVELP4sQvSSA6qeaelsDCelImxCWx8uuEM4sk6kWIbt
	 zZf9jS8KkQC4egyiiuS2P9wcMDfaaCOLLNrKWVvaIjgL2Qf0AnGpP+JY/O/hnuY9TF
	 Ze4w+Ns6UqM00Dv8TRW4i/33GT4IYzAXIqiwIIG77ql60BThY7yyEFriZgjFHWSJW+
	 +TM/yn5sYIY8wN5tgd0IJsa8o2XV8RSTRn1CNB4ws/8R3XHp7kB/zOJ5m6URhAk1F0
	 1sRtGfaeHj67gOlepWNZb2WUW6sQV2FulI9ZjaHnS84rv1r/7rNmU5HA/uvYIN0raZ
	 7YhsdeNRjXGQA==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usbip: vhci_hcd: keep interrupts disabled during URB giveback
Message-ID: <89d738e1-8cb7-4baa-bf64-6f4ed27afbb9@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sat,  8 Aug 2026 19:44:01 +0000 (UTC)

The USB core API requires that usb_hcd_giveback_urb() is called with
interrupts disabled. When tx_complete() is invoked by
__usb_hcd_giveback_urb(), it uses this_cpu_ptr() (which relies on
smp_processor_id()), expecting to be executed in an atomic context where
preemption is disabled.

However, in vhci_recv_ret_submit() and several other places in the vhci
driver, interrupts are explicitly re-enabled using spin_unlock_irqrestore()
just before calling usb_hcd_giveback_urb(). Because interrupts (and thus
preemption) are enabled, the URB completion handler runs in a preemptible
kthread context, leading to the following crash:

BUG: using smp_processor_id() in preemptible [00000000] code: vhci_rx/5870
caller is tx_complete+0x15f/0x710 drivers/net/usb/usbnet.c:1301
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 check_preemption_disabled+0xd3/0xe0 lib/smp_processor_id.c:47
 tx_complete+0x15f/0x710 drivers/net/usb/usbnet.c:1301
 __usb_hcd_giveback_urb+0x374/0x530 drivers/usb/core/hcd.c:1657
 vhci_recv_ret_submit drivers/usb/usbip/vhci_rx.c:107 [inline]
 vhci_rx_pdu drivers/usb/usbip/vhci_rx.c:242 [inline]
 vhci_rx_loop+0x645/0xa80 drivers/usb/usbip/vhci_rx.c:265
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

To fix this, ensure that interrupts remain disabled while calling
usb_hcd_giveback_urb(). This is done by changing spin_unlock_irqrestore()
to spin_unlock() before the call, preserving the interrupt state
established by spin_lock_irqsave(). After the call, the lock is re-acquired
with spin_lock() and then spin_unlock_irqrestore() is called to exit the
critical section and restore the original interrupt state.

This approach also maintains compatibility with PREEMPT_RT kernels, where
spin_lock_irqsave() maps to a sleeping lock and does not actually disable
hardware interrupts. Relying on the lock's IRQ state preservation avoids
crashing PREEMPT_RT kernels that would occur if local_irq_disable() and
local_irq_restore() were used directly.

Fixes: 04679b3489e0 ("Staging: USB/IP: add client driver")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+04cd90bb99c6ef81a65d@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=04cd90bb99c6ef81a65d
Link: https://syzkaller.appspot.com/ai_job?id=53c3fa68-e0fd-43a3-8fe6-832fabf5b714
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
To: "Shuah Khan" <shuah@kernel.org>
To: "Valentina Manea" <valentina.manea.m@gmail.com>
To: "Takahiro Hirofuchi" <hirofuchi@users.sourceforge.net>
Cc: "Hongren Zheng" <i@zenithal.me>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/usbip/vhci_hcd.c b/drivers/usb/usbip/vhci_hcd.c
index 39e8faf4c..b416d8271 100644
--- a/drivers/usb/usbip/vhci_hcd.c
+++ b/drivers/usb/usbip/vhci_hcd.c
@@ -940,9 +940,9 @@ static int vhci_urb_dequeue(struct usb_hcd *hcd, struct urb *urb, int status)
 		 */
 		usb_hcd_unlink_urb_from_ep(hcd, urb);
 
-		spin_unlock_irqrestore(&vhci->lock, flags);
+		spin_unlock(&vhci->lock);
 		usb_hcd_giveback_urb(hcd, urb, urb->status);
-		spin_lock_irqsave(&vhci->lock, flags);
+		spin_lock(&vhci->lock);
 
 	} else {
 		/* tcp connection is alive */
@@ -1008,11 +1008,11 @@ static void vhci_cleanup_unlink_list(struct vhci_device *vdev,
 		list_del(&unlink->list);
 
 		spin_unlock(&vdev->priv_lock);
-		spin_unlock_irqrestore(&vhci->lock, flags);
+		spin_unlock(&vhci->lock);
 
 		usb_hcd_giveback_urb(hcd, urb, urb->status);
 
-		spin_lock_irqsave(&vhci->lock, flags);
+		spin_lock(&vhci->lock);
 		spin_lock(&vdev->priv_lock);
 
 		kfree(unlink);
diff --git a/drivers/usb/usbip/vhci_rx.c b/drivers/usb/usbip/vhci_rx.c
index a678e7c89..6db3a5a73 100644
--- a/drivers/usb/usbip/vhci_rx.c
+++ b/drivers/usb/usbip/vhci_rx.c
@@ -102,10 +102,13 @@ static void vhci_recv_ret_submit(struct vhci_device *vdev,
 
 	spin_lock_irqsave(&vhci->lock, flags);
 	usb_hcd_unlink_urb_from_ep(vhci_hcd_to_hcd(vhci_hcd), urb);
-	spin_unlock_irqrestore(&vhci->lock, flags);
+	spin_unlock(&vhci->lock);
 
 	usb_hcd_giveback_urb(vhci_hcd_to_hcd(vhci_hcd), urb, urb->status);
 
+	spin_lock(&vhci->lock);
+	spin_unlock_irqrestore(&vhci->lock, flags);
+
 	usbip_dbg_vhci_rx("Leave\n");
 }
 
@@ -173,9 +176,12 @@ static void vhci_recv_ret_unlink(struct vhci_device *vdev,
 
 		spin_lock_irqsave(&vhci->lock, flags);
 		usb_hcd_unlink_urb_from_ep(vhci_hcd_to_hcd(vhci_hcd), urb);
-		spin_unlock_irqrestore(&vhci->lock, flags);
+		spin_unlock(&vhci->lock);
 
 		usb_hcd_giveback_urb(vhci_hcd_to_hcd(vhci_hcd), urb, urb->status);
+
+		spin_lock(&vhci->lock);
+		spin_unlock_irqrestore(&vhci->lock, flags);
 	}
 
 	kfree(unlink);


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
