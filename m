Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 12114494A18
	for <syzbot@lists.linux.dev>; Tue, 19 May 2026 11:45:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779191110; cv=none; b=SGJ0bTHfPRU7Yb+7Ff0t7Zavy8bt4zdAygExH1EGIPyDILoxPQfSgesqqjJAxfeP9WLjSCJe04N+jQeneLyzHM4PmrNcd/VG5K9l+x8YKpoWotnBGCbroiVCj765gSTLgiBDm2QYv/Tz8lDDJA5P/x0BGImGOXLG+oJCwzw3vyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779191110; c=relaxed/simple;
	bh=25yiX8EketFSd0NsIDZg1ZCXwW+4dJFFh+sehSIi2XY=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=WjfnMgxSxXZEqCq42HNhu8fT3as+lw61PNt6FdimuSoa1z2rshy3bVDnFDO+cDusiHKQqxffTnXspo1KvrWMbd3PC+Y//Ckcta83MS6o8Tn7sySm5Y71n3XxwNK5Uy402ZNP5/mE6CByXJc0xllzERi3nlvW4nxb5yGUG1UI6Mk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=QbaRs0BK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="QbaRs0BK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7397EC2BCB3;
	Tue, 19 May 2026 11:45:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1779191109;
	bh=25yiX8EketFSd0NsIDZg1ZCXwW+4dJFFh+sehSIi2XY=;
	h=From:To:Cc:Subject:Date:From;
	b=QbaRs0BKAnccIfayS10+tXVZw4jxyOvnp0wqAwCKPVOK5lqBAQQRoJa+g7i/jmN7K
	 8lWt1xZk29SLb+BP6Hshm6pG1hWG+llFCpGov+a4dZywT2eUB6GJsZU/zECejCCeMN
	 pz3PAjdc2Gv5lheIhBwH6ABKsMQDC5xZq55ycn6XocoN7LocAMrH4Cyov6iQ7mujxW
	 o18NWp6psJW4EzcRA0zUKcPUghukFSWbp3ztQeAKFBuTekFzivR3aUM8rV9s/BQgZP
	 FreApIF0UBL5brJ5Te+cMxAYSNx5PzS8GRN5wTjNNs1GmlS2zw09g5rOTmTzx+1afu
	 n+h17uJrfC2sQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC v3] usb: cdc-wdm: close race between workqueue and release
Message-ID: <0dd0c191-5abe-4478-8da0-1c317be2ab06@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue, 19 May 2026 11:45:08 +0000 (UTC)

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

Fixes: 01e01f5c8977 ("usb: cdc-wdm: fix reading stuck on device close")
Assisted-by: Gemini:gemini-3.1-pro-preview Gemini:gemini-3-flash-preview
Reported-by: syzbot <syzbot+c6a1953c27ace6cc34e5@syzkaller.appspotmail.com>
Reported-by: syzbot+c6a1953c27ace6cc34e5@syzkaller.appspotmail.com
Link: https://syzkaller.appspot.com/bug?extid=c6a1953c27ace6cc34e5
Link: https://syzkaller.appspot.com/ai_job?id=6da3e468-5581-468e-a44e-8f11753e5e6a
To: <gregkh@linuxfoundation.org>
To: <linux-usb@vger.kernel.org>
Cc: <linux-kernel@vger.kernel.org>

---
v3:
- Dropped changes in wdm_suspend() and wdm_pre_reset()
- Removed Tested-by tag

v2:
- Added crash stacktrace to the commit description
- Added Tested-by tag from nogikh@google.com
- Cleared WDM_RESPONDING flag and resp_count under iuspin lock in wdm_wwan_port_stop, wdm_suspend, and wdm_pre_reset
https://lore.kernel.org/all/3bb247d6-e412-46be-973c-5d2f9945ebe5@mail.kernel.org/T/

v1:
https://lore.kernel.org/all/97986988-6374-4e40-aa96-662939fabe88@mail.kernel.org/T/
---
diff --git a/drivers/usb/class/cdc-wdm.c b/drivers/usb/class/cdc-wdm.c
index 7556c0dac..75ce371d1 100644
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


base-commit: 5d6919055dec134de3c40167a490f33c74c12581
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to send it to the mailing list.
Reply with '#syz reject' to reject it.

See https://github.com/google/syzkaller/blob/master/docs/syzbot_ai_patches.md for more information.
