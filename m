Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03BEE335081
	for <syzbot@lists.linux.dev>; Sun,  2 Aug 2026 20:29:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785702582; cv=none; b=meJAL/ZCrYboSq+TLKLcI+WGa+SBh6QmhX2ag48u3+ydsdI0be5ruGEl5Xx0ceyDgMvgF5mDrjP2D/nzBDfFKv/jb3A+0dO8W8G+zTUvky7s9955d+ptGcecZaHPrAktKkIMZNWqJFeuBUv+cVEW68NJlZk/eYnRSniTS1p5e80=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785702582; c=relaxed/simple;
	bh=Ldt2z3o8feRMLzFURVKm1draKXlGAcWm8rlMRq6aVaE=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=ZEHLJ1ixss9zH+O4491KdYynl9lTRSKvx2+WRG4vv7Z09OvxVsSYNsoX+voUH9kRU9gUTbfadXDiyc4l9DXkwjLM0B5ct4eTCCFCTuNRTgNr7ZibQJ82YaSAxZFSQlvZ0j8LLOnxkrkROXVZPALXczQMnLKoXcRzTgLHkdpGZk8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=jRdyJNlF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="jRdyJNlF"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 7F1681F00A3A;
	Sun,  2 Aug 2026 20:29:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1785702580;
	bh=bYDSUeaqrgh3UaDColqJCu7Iy2ZhpVWjHTU72d3FpBc=;
	h=From:To:Cc:Subject:Date;
	b=jRdyJNlFTVR3CMmxYkYKsnsrYNKUlZ6n+cRAHrIt5ZQWRjBnvJ3kLEHR/mZBRFyVX
	 a94V8CaGVnXSd72f0inlIZ0a8CUi3HomU+HknesoYFTIsHZszbL1TOB76HHLCwx5zM
	 dCqGtHBDbndvXTdxJwoXdkL488lnqWzOF/L2QK1bVGpxICC8wxm23B+CCW846LPkwm
	 bZ5Q36zB99HtFNWRR/NaAGnzUbMLrEv5Ma2RawBaE5YT+BCPb0T8+58RiyQ5YoVvCX
	 33pu+u+SywW9kW7o7Y9V7t+yP+GocD0WeAIznmwguLQpTxNQmBaiwb5kOV44yyuYfp
	 XURhw1Z2BPKMg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] usb: atm: cxacru: fix use-after-free in cxacru_poll_status()
Message-ID: <77ea3b90-4c30-432f-ab20-768878233d48@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Sun,  2 Aug 2026 20:29:40 +0000 (UTC)

A KASAN use-after-free was detected in __mutex_lock_common triggered by the
cxacru_poll_status work item attempting to lock
instance->poll_state_serialize after the instance (struct cxacru_data) has
been freed by cxacru_unbind.

The root cause is a race condition in cxacru_unbind where it conditionally
skips canceling the delayed work instance->poll_work if
instance->poll_state == CXPOLL_STOPPED. However, the state CXPOLL_STOPPED
only means that the work should not reschedule itself; it does not mean
that the work is not currently executing.

If the work is executing while cxacru_unbind skips the cancellation and
frees the instance memory, the work item will eventually attempt to access
the freed memory, leading to the use-after-free.

To fix this, remove the is_polling variable and the conditional check in
cxacru_unbind. The driver now unconditionally calls
cancel_delayed_work_sync(&instance->poll_work). This safely guarantees that
the work item has completely finished executing before the instance memory
is freed.

Additionally, update cxacru_poll_status to check if instance->poll_state ==
CXPOLL_SHUTDOWN before deciding to reschedule itself. This ensures that if
the work item is currently executing while cxacru_unbind sets the state to
CXPOLL_SHUTDOWN, it will cleanly exit and not attempt to reschedule itself.

BUG: KASAN: slab-use-after-free in __mutex_lock_common
kernel/locking/mutex.c:625 [inline]
BUG: KASAN: slab-use-after-free in __mutex_lock+0x154/0x1550
kernel/locking/mutex.c:821
Read of size 8 at addr ffff8881fbf3e218 by task kworker/1:1/32

Workqueue: events cxacru_poll_status
Call Trace:
 <TASK>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 print_address_description+0x55/0x1e0 mm/kasan/report.c:378
 print_report+0x58/0x70 mm/kasan/report.c:482
 kasan_report+0x117/0x150 mm/kasan/report.c:595
 __mutex_lock_common kernel/locking/mutex.c:625 [inline]
 __mutex_lock+0x154/0x1550 kernel/locking/mutex.c:821
 cxacru_poll_status+0x73a/0x1110 drivers/usb/atm/cxacru.c:920
 process_one_work kernel/workqueue.c:3322 [inline]
 process_scheduled_works+0xa8e/0x14e0 kernel/workqueue.c:3405
 worker_thread+0xa47/0xfb0 kernel/workqueue.c:3486
 kthread+0x388/0x470 kernel/kthread.c:436
 ret_from_fork+0x514/0xb70 arch/x86/kernel/process.c:158
 ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:245
 </TASK>

Freed by task 5720:
 kasan_save_stack mm/kasan/common.c:57 [inline]
 kasan_save_track+0x3e/0x80 mm/kasan/common.c:78
 kasan_save_free_info+0x40/0x50 mm/kasan/generic.c:584
 poison_slab_object mm/kasan/common.c:253 [inline]
 __kasan_slab_free+0x5c/0x80 mm/kasan/common.c:285
 kasan_slab_free include/linux/kasan.h:235 [inline]
 slab_free_hook mm/slub.c:2677 [inline]
 slab_free mm/slub.c:6377 [inline]
 kfree+0x1c5/0x640 mm/slub.c:6692
 cxacru_unbind+0x1c8/0x340 drivers/usb/atm/cxacru.c:1266
 usbatm_usb_disconnect+0x42b/0x620 drivers/usb/atm/usbatm.c:1255
 usb_unbind_interface+0x295/0x9f0 drivers/usb/core/driver.c:458
 device_remove drivers/base/dd.c:618 [inline]
 __device_release_driver drivers/base/dd.c:1349 [inline]
 device_release_driver_internal+0x4f5/0x880 drivers/base/dd.c:1372
 bus_remove_device+0x444/0x560 drivers/base/bus.c:664
 device_del+0x524/0x8f0 drivers/base/core.c:3961
 usb_disable_device+0x3d4/0x8d0 drivers/usb/core/message.c:1478
 usb_disconnect+0x346/0x9a0 drivers/usb/core/hub.c:2345

Fixes: 6a02c996bce2 ("USB: cxacru: ADSL state management")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+24eb38c789655fc43663@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=24eb38c789655fc43663
Link: https://syzkaller.appspot.com/ai_job?id=79150e78-3441-40ad-8389-e897b217e2a0
To: "Chas Williams" <3chas3@gmail.com>
To: <accessrunner-general@lists.sourceforge.net>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
To: <linux-atm-general@lists.sourceforge.net>
To: <linux-usb@vger.kernel.org>
To: <netdev@vger.kernel.org>
To: "Simon Arlott" <simon@fire.lp0.eu>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/drivers/usb/atm/cxacru.c b/drivers/usb/atm/cxacru.c
index f1900c567..4a2206d3b 100644
--- a/drivers/usb/atm/cxacru.c
+++ b/drivers/usb/atm/cxacru.c
@@ -923,7 +923,8 @@ static void cxacru_poll_status(struct work_struct *work)
 				instance->line_status == 0) /* down */
 		instance->poll_state = CXPOLL_STOPPED;
 
-	if (instance->poll_state == CXPOLL_STOPPED)
+	if (instance->poll_state == CXPOLL_STOPPED ||
+	    instance->poll_state == CXPOLL_SHUTDOWN)
 		keep_polling = 0;
 	mutex_unlock(&instance->poll_state_serialize);
 
@@ -1231,7 +1232,6 @@ static void cxacru_unbind(struct usbatm_data *usbatm_instance,
 		struct usb_interface *intf)
 {
 	struct cxacru_data *instance = usbatm_instance->driver_data;
-	int is_polling = 1;
 
 	usb_dbg(usbatm_instance, "cxacru_unbind entered\n");
 
@@ -1243,17 +1243,11 @@ static void cxacru_unbind(struct usbatm_data *usbatm_instance,
 	mutex_lock(&instance->poll_state_serialize);
 	BUG_ON(instance->poll_state == CXPOLL_SHUTDOWN);
 
-	/* ensure that status polling continues unless
-	 * it has already stopped */
-	if (instance->poll_state == CXPOLL_STOPPED)
-		is_polling = 0;
-
 	/* stop polling from being stopped or started */
 	instance->poll_state = CXPOLL_SHUTDOWN;
 	mutex_unlock(&instance->poll_state_serialize);
 
-	if (is_polling)
-		cancel_delayed_work_sync(&instance->poll_work);
+	cancel_delayed_work_sync(&instance->poll_work);
 
 	usb_kill_urb(instance->snd_urb);
 	usb_kill_urb(instance->rcv_urb);


base-commit: f5098b6bae761e346ebcd9da7f95622c04733cff
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
