Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 26362395AD4
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 05:35:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786080939; cv=none; b=dOUUypaRzEQ5+TZKMIV7EhR+Y3x1dpdAi87Ova3/+3qmeYgQOEoEhP4Fdkw5b5Zh2YtxAWAVh94YiUz0Gl+K0TdRIRsozlMVENGWWv8itwG4V5eGvmzhFp9jAT4a0p3uPwCRVxmda3EsFP52iu5ZcT9uTLUzd1t5xgmqZVwkaQM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786080939; c=relaxed/simple;
	bh=bWDPBOjvgoWo34IIlJocAq5n1ddz/2u1TenQF44gm7Q=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=IziuB7mGYE2jSwWot34HqsrG6FK9S0HYQxmLs0hw2IVhSnsIsKkRtaOJdxZi8EjP9Xqkcu2DwfN11tZbp7f3Xynj9KcyKKH6fvbKEgFZ9E58sr5s7gfPzqQGCYZXaue6h/dK00AjF3YlD9VKoyKVj9dj5geOFXRqK6KVvb8UdYs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=JdWRin49; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="JdWRin49"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id ABD2C1F000E9;
	Fri,  7 Aug 2026 05:35:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786080937;
	bh=RZGBp7G1RpWR7WHVQwKYsuWBR4PiPe2lTGEyBMSBQhw=;
	h=From:To:Cc:Subject:Date;
	b=JdWRin49d1Bt8nMdNN5dKKtDJLzevklXtpzDP3OCu7bzpnNLSPAICdybJZTC2V/lU
	 D4Hp+mzFMCAKfXi0Hox/Bl+mULFy0emuZEKT9ABkoLayAx+XBCqnXA5PzfUwVB47Ag
	 M1H5nreKMfVnrqrIiRl7ab32OAqugo1G6B71c9lilmcOfYz3ay+8Pg5t/ilFS4tz6u
	 yU4HXAC6GTs9Bm3eDutSyrcr4DxGV2/u9xMfuqgEjBgVqEYIKj/MW591repaA3zqjd
	 8mJboEgBz2Cx4Tc3Kqpg6vFEe13c23YR/vjM9JA54pcxFg5bGsMrqFw+2b9NaGHKOF
	 mbdtsGBBBFOqQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] mmc: vub300: fix sleeping in softirq during host cleanup
Message-ID: <49982079-95f4-4e8c-bbbc-bcb127e2f378@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 05:35:37 +0000 (UTC)

The `vub300` driver uses a timer (`vub300->inactivity_timer`) to monitor
inactivity. When this timer expires, its callback
`vub300_inactivity_timer_expired()` is executed in softirq (atomic)
context. Inside the timer callback, if the device has been disconnected, it
drops its reference to the host by calling `kref_put(&vub300->kref,
vub300_delete)`. If this timer holds the last reference, `vub300_delete()`
is invoked synchronously in the same atomic context.

`vub300_delete()` calls `mmc_free_host()`. Since commit 1036f69e2513 ("mmc:
core: Cancel delayed work before releasing host"), `mmc_free_host()` calls
`cancel_delayed_work_sync()`, which can sleep. This triggers a "BUG:
sleeping function called from invalid context" when executed from the
softirq context:

BUG: sleeping function called from invalid context at
kernel/workqueue.c:4487
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/0
...
Call Trace:
 <IRQ>
 dump_stack_lvl+0xe8/0x150 lib/dump_stack.c:120
 __might_resched+0x378/0x4d0 kernel/sched/core.c:9197
 __cancel_work_sync+0x6d/0x110 kernel/workqueue.c:4487
 mmc_free_host+0x19/0x30 drivers/mmc/core/host.c:700
 call_timer_fn+0x192/0x5e0 kernel/time/timer.c:1748
 expire_timers kernel/time/timer.c:1799 [inline]
 __run_timers kernel/time/timer.c:2374 [inline]
 __run_timer_base+0x652/0x8b0 kernel/time/timer.c:2386
 run_timer_base kernel/time/timer.c:2395 [inline]
 run_timer_softirq+0xb7/0x170 kernel/time/timer.c:2405
 handle_softirqs+0x216/0x830 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xc0/0x210 kernel/softirq.c:735
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062
 [inline]
 sysvec_apic_timer_interrupt+0x92/0xb0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>

To fix this, defer the cleanup operations in `vub300_delete()` to a
workqueue. A dedicated `work_struct` is added to `struct vub300_mmc_host`
and queued on the driver's `deadworkqueue` when the `kref` reaches zero.
Using `deadworkqueue` ensures that the work is safely flushed during module
unload.

Additionally, the order of cleanup operations is adjusted to prevent a
use-after-free. `usb_put_dev()` is called after `mmc_free_host()` because
`mmc_free_host()` accesses the USB device structure via `host->parent`. The
`udev` pointer is saved in a local variable before `mmc_free_host()` frees
the `vub300` structure.

Fixes: 1036f69e2513 ("mmc: core: Cancel delayed work before releasing host")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+1ee4f3b9228e35f14677@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=1ee4f3b9228e35f14677
Link: https://syzkaller.appspot.com/ai_job?id=f105b557-f491-4cff-97a1-a15b027fdeec
To: <linux-mmc@vger.kernel.org>
To: "Ulf Hansson" <ulfh@kernel.org>
To: "Geert Uytterhoeven" <geert+renesas@glider.be>
Cc: "Johan Hovold" <johan@kernel.org>
Cc: "Guangshuo Li" <lgs201920130244@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Runyu Xiao" <runyu.xiao@seu.edu.cn>

---
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 2dae474dc..28d97024f 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -346,6 +346,7 @@ struct vub300_mmc_host {
 	struct timer_list inactivity_timer;
 	struct work_struct deadwork;
 	struct work_struct cmndwork;
+	struct work_struct free_work;
 	struct delayed_work pollwork;
 	struct host_controller_info hc_info;
 	struct sd_status_header system_port_status;
@@ -366,21 +367,25 @@ struct vub300_mmc_host {
 #define GET_HC_INF0			1
 #define GET_SYSTEM_PORT_STATUS		0
 
-static void vub300_delete(struct kref *kref)
-{				/* kref callback - softirq */
-	struct vub300_mmc_host *vub300 = kref_to_vub300_mmc_host(kref);
+static void vub300_free_work(struct work_struct *work)
+{
+	struct vub300_mmc_host *vub300 =
+		container_of(work, struct vub300_mmc_host, free_work);
 	struct mmc_host *mmc = vub300->mmc;
+	struct usb_device *udev = vub300->udev;
 
 	usb_free_urb(vub300->command_out_urb);
-	vub300->command_out_urb = NULL;
 	usb_free_urb(vub300->command_res_urb);
-	vub300->command_res_urb = NULL;
-	usb_put_dev(vub300->udev);
 	mmc_free_host(mmc);
-	/*
-	 * and hence also frees vub300
-	 * which is contained at the end of struct mmc
-	 */
+	usb_put_dev(udev);
+}
+
+static void vub300_delete(struct kref *kref)
+{
+	struct vub300_mmc_host *vub300 = kref_to_vub300_mmc_host(kref);
+
+	INIT_WORK(&vub300->free_work, vub300_free_work);
+	queue_work(deadworkqueue, &vub300->free_work);
 }
 
 static void vub300_queue_cmnd_work(struct vub300_mmc_host *vub300)


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
