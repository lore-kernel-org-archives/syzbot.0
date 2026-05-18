Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A6CC2882CD
	for <syzbot@lists.linux.dev>; Mon, 18 May 2026 22:50:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779144657; cv=none; b=FJ3lzaSstz87Q7j17i83PaELP9onQTTZSmFWYjVm8h9VE8knQWFqU8RJDdivsQICJWjoX7vCQbhJt576Z7huF1Hz5eliy8docngEJgGKCOTMZdtXZ761fw56snhr4m5C6Nwpv0j+3xndWfLbX1TdWpU49sNdmTCw0MGQ6+ntF5o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779144657; c=relaxed/simple;
	bh=EiQCvG4WcseavISCz6pgY+a2T3qP+ezzzXemgzdszKU=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=uAFGO50h508jxzrwmOBO01SXTBT9uBkqJGGDBztGx/HwbEFoSCGZqp89PAWAIaYU0IFXdTJczBa4dke485iM2lYD+WvbtikWbYUjUix9uYyiCVTC0S9ke6gtX4Z5bK6UlbYqg2fXLYE0/M7q3Wm//4wtTFvuQ7XKTTrg64kJXvs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=sp3sbWjn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="sp3sbWjn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 127D1C2BCB7;
	Mon, 18 May 2026 22:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779144657;
	bh=EiQCvG4WcseavISCz6pgY+a2T3qP+ezzzXemgzdszKU=;
	h=From:To:Cc:Subject:Date:From;
	b=sp3sbWjnhaiUa8fEor5oMmr1wcXmqEChlaUnR/PrN/bwhh4dnpY9BbYgUhd0xJVGQ
	 lZJ2mk32+Ld91N9nhXS9pj3/ZoNHeyFJgIfApQwViSj9+ahMU4AMUbgNEKvrNP2b0k
	 gLgfVARJca4MMnPhia2lQUZov8d/J3qA3I9SMl6Rnd1SY6r6YTGoXxbEZ1PIOzbKSH
	 XLxoXx6yUvNpn2IeOmrlrWL3COuZO0Wi7HoKulkdFzACbuy2FklbJd11ohaR3Akwnk
	 3RRcv+7HpfuQpjqy84DAi5j7rtOj0YX4SB1A0cYLAcnMVUVZhbBjYKF8+TSgBXzpp9
	 Ve5siHBFFgtlQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v2] usb: cdc-wdm: close race between workqueue and release
Message-ID: <3bb247d6-e412-46be-973c-5d2f9945ebe5@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 18 May 2026 22:50:57 +0000 (UTC)

The crash "URB submitted while active" occurs because the
`desc->response` URB is submitted by `wdm_rxwork` when it is already in
an active state. This happens because `wdm_release` fails to cancel
pending workqueue items (`desc->rxwork` and `desc->service_outs_intr`)
during its cleanup phase. When the character device is closed and there
are no other openers, `wdm_release` calls `poison_urbs()` to kill active
URBs, clears the `WDM_RESPONDING` flag, and calls `unpoison_urbs()`.
Because `wdm_release` does not call `cancel_work_sync()` for the work
items, they can run concurrently with the cleanup process. If a work
item executes after the URBs are unpoisoned, it can successfully submit
the URB. If another work item then runs, it will see the
`WDM_RESPONDING` flag as cleared, set it, and attempt to submit the URB
again, leading to the crash.

To fix this, cancel the pending workqueue items after poisoning the URBs
and before clearing the `WDM_RESPONDING` flag or unpoisoning the URBs.
This ensures that any running work item will either fail to submit the
URB (because it is poisoned) or finish executing before the cleanup
proceeds. The same omission is present in `wdm_wwan_port_stop`, so apply
the same fix there to prevent data leaks or crashes across WWAN
sessions.

------------[ cut here ]------------
URB ffff888052781d00 submitted while active
WARNING: drivers/usb/core/urb.c:379 at usb_submit_urb+0x7b/0x18b0
drivers/usb/core/urb.c:379, CPU#0: kworker/0:3/5726
Modules linked in:
CPU: 0 UID: 0 PID: 5726 Comm: kworker/0:3 Not tainted syzkaller #1
PREEMPT(full)
Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
1.16.3-debian-1.16.3-2 04/01/2014
Workqueue: events wdm_rxwork
RIP: 0010:usb_submit_urb+0x7e/0x18b0 drivers/usb/core/urb.c:379
Code: 89 f0 48 c1 e8 03 42 80 3c 38 00 74 08 4c 89 f7 e8 57 eb 0c fb 49
83 3e 00 74 40 e8 7c da a2 fa 48 8d 3d a5 09 d9 08 48 89 de <67> 48 0f
b9 3a b8 f0 ff ff ff eb 11 e8 61 da a2 fa eb 05 e8 5a da
RSP: 0018:ffffc90003427a10 EFLAGS: 00010293
RAX: ffffffff8720dc64 RBX: ffff888052781d00 RCX: ffff88801fe48000
RDX: 0000000000000000 RSI: ffff888052781d00 RDI: ffffffff8ff9e610
RBP: 0000000000000001 R08: ffffffff8fecf1f7 R09: 1ffffffff1fd9e3e
R10: dffffc0000000000 R11: fffffbfff1fd9e3f R12: 0000000000000cc0
R13: 1ffff1100a555e12 R14: ffff888052781d08 R15: dffffc0000000000
FS:  0000000000000000(0000) GS:ffff88809893a000(0000)
knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f08959ea540 CR3: 000000001e4b2000 CR4: 00000000000006f0
Call Trace:
 <TASK>
 wdm_rxwork+0x101/0x1e0 drivers/usb/class/cdc-wdm.c:997
 process_one_work kernel/workqueue.c:3302 [inline]
 process_scheduled_works+0xb5d/0x1860 kernel/workqueue.c:3385
 worker_thread+0x8a2/0xda0 kernel/workqueue.c:3466
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>
----------------

Tested-by: nogikh@google.com

Fixes: 01e01f5c89773c600a9f0b32c888de0146066c3a ("usb: cdc-wdm: fix reading stuck on device close")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Tested-by: Aleksandr Nogikh <nogikh@google.com>
Reported-by: syzbot+c6a1953c27ace6cc34e5@syzkaller.appspotmail.com
Reported-by: syzbot <syzbot+c6a1953c27ace6cc34e5@syzkaller.appspotmail.com>
Link: https://syzkaller.appspot.com/bug?extid=c6a1953c27ace6cc34e5
Link: https://syzkaller.appspot.com/ai_job?id=eb69973c-340c-4ffd-bfad-183f25211bed
To: <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v2:
- Added crash stacktrace to the commit description
- Added Tested-by tag from nogikh@google.com
- Cleared WDM_RESPONDING flag and resp_count under iuspin lock in wdm_wwan_port_stop, wdm_suspend, and wdm_pre_reset

v1:
https://lore.kernel.org/all/97986988-6374-4e40-aa96-662939fabe88@mail.kernel.org/T/
---
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 7556c0dac..ba5422d1d 100644
--- a/drivers/usb/class/cdc-wdm.c
+++ b/drivers/usb/class/cdc-wdm.c
@@ -769,6 +769,8 @@ static int wdm_release(struct inode *inode, struct file *file)
 		if (!test_bit(WDM_DISCONNECTING, &desc->flags)) {
 			dev_dbg(&desc->intf->dev, "wdm_release: cleanup\n");
 			poison_urbs(desc);
+			cancel_work_sync(&desc->rxwork);
+			cancel_work_sync(&desc->service_outs_intr);
 			spin_lock_irq(&desc->iuspin);
 			desc->resp_count = 0;
 			clear_bit(WDM_RESPONDING, &desc->flags);
@@ -863,6 +865,12 @@ static void wdm_wwan_port_stop(struct wwan_port *port)
 
 	/* Stop all transfers and disable WWAN mode */
 	poison_urbs(desc);
+	cancel_work_sync(&desc->rxwork);
+	cancel_work_sync(&desc->service_outs_intr);
+	spin_lock_irq(&desc->iuspin);
+	desc->resp_count = 0;
+	clear_bit(WDM_RESPONDING, &desc->flags);
+	spin_unlock_irq(&desc->iuspin);
 	desc->manage_power(desc->intf, 0);
 	clear_bit(WDM_READ, &desc->flags);
 	unpoison_urbs(desc);
@@ -1279,6 +1287,10 @@ static int wdm_suspend(struct usb_interface *intf, pm_message_t message)
 		poison_urbs(desc);
 		cancel_work_sync(&desc->rxwork);
 		cancel_work_sync(&desc->service_outs_intr);
+		spin_lock_irq(&desc->iuspin);
+		desc->resp_count = 0;
+		clear_bit(WDM_RESPONDING, &desc->flags);
+		spin_unlock_irq(&desc->iuspin);
 		unpoison_urbs(desc);
 	}
 	if (!PMSG_IS_AUTO(message)) {
@@ -1340,6 +1352,10 @@ static int wdm_pre_reset(struct usb_interface *intf)
 	poison_urbs(desc);
 	cancel_work_sync(&desc->rxwork);
 	cancel_work_sync(&desc->service_outs_intr);
+	spin_lock_irq(&desc->iuspin);
+	desc->resp_count = 0;
+	clear_bit(WDM_RESPONDING, &desc->flags);
+	spin_unlock_irq(&desc->iuspin);
 	return 0;
 }
 


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See  for more information.
