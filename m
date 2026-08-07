Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1492E381C4
	for <syzbot@lists.linux.dev>; Fri,  7 Aug 2026 03:36:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786073802; cv=none; b=WEuJSKcl06GJmEyLoNbvUpHFS7h1h/67UCDvhtU9UnY/FvtRNryDa04jTu+zlaxJfy9mxIu4oH7oLHM18jhwr3U6D5p3UTjeYsy2/nKM1oekl9gMlbBuQURL5tHsjrGE/im3vH/5guVigezJTC62Bg90ogShj1kxOlKCcP3eG7I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786073802; c=relaxed/simple;
	bh=38LtmZxF07NT8Z1If6RyKodo8xVIY1vzOxcszMbxOr4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=Yv7Ppl5lZViTHgeUULuBme2m5cC90716y0dlwVplWThs/BftumltyGSkkbHd0KfyQvJzQCBmbp4gr30UXUsC+O4ZNpq1FN42w0Da6a26D5FuUD9zJZ80b2e0XUbvQrcIUMi3vJ2seIVwXtuDpdhVYEvjqkQzoyKqCfHkyn47ooM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=N9YhDcl8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="N9YhDcl8"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id C586B1F000E9;
	Fri,  7 Aug 2026 03:36:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1786073797;
	bh=UU4Ud+hblCcFB5Xs47ehOnF/OboPeU78IStnF/SuWjY=;
	h=From:To:Cc:Subject:Date;
	b=N9YhDcl8lvkt4psdAOX3JLnHoeHqJ/lwFr1R5h4FyAqsPlMDS48tO0l3A1DVuuOO7
	 SljYrdgRsImhXpM5O/p0QPBc2bdzvXQpsMgexKs5DqItbTaBGWfznMUs9iNYN+dvn6
	 iZBPMNHuOUykvZf2YywRl6o0s4un3wvHpWgCXg8CD1Vd+D56fZX84m/vXZE2TaNmgN
	 OyKZK9HKLRTl54VWLHPkW3/BlpRLTtKN+NNxFEynZddsZNDzgMGUJdKoaU8lvWl70g
	 E4+5kr5NGytdLYUew4nHtOqMJ+lfTsHwn6do5FhGI5KK8uWlxz4wFjvyLc/kuEDTm7
	 w8xbVvGMAnAvQ==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] mmc: vub300: fix sleeping function called from invalid context
Message-ID: <397da4bd-97e2-4367-b3f4-d69e0f58dd91@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Fri,  7 Aug 2026 03:36:37 +0000 (UTC)

The vub300 driver manages an inactivity timer that holds a reference to the
vub300 object. When the timer expires and the interface is disconnected
(!vub300->interface), the timer callback drops the reference. If this is
the last reference, it triggers vub300_delete(), which calls
mmc_free_host(). Since mmc_free_host() can sleep (e.g., calling
cancel_delayed_work_sync()), calling it from the timer's softirq context
causes a "sleeping function called from invalid context" BUG.

BUG: sleeping function called from invalid context at
kernel/workqueue.c:4487
in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 0, name: swapper/1
Preemption disabled at:
[<0000000000000000>] 0x0
CPU: 1 UID: 0 PID: 0 Comm: swapper/1 Not tainted
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
 handle_softirqs+0x225/0x840 kernel/softirq.c:622
 __do_softirq kernel/softirq.c:656 [inline]
 invoke_softirq kernel/softirq.c:496 [inline]
 __irq_exit_rcu+0xca/0x220 kernel/softirq.c:735
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:752
 instr_sysvec_apic_timer_interrupt arch/x86/kernel/apic/apic.c:1062
 [inline]
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>

To fix this, decouple the timer from the object's reference counting. The
timer does not need to hold a reference to the vub300 object if we ensure
it is synchronously stopped before the object is freed. Remove the
kref_get() and kref_put() associated with the inactivity_timer, and
explicitly call timer_delete_sync() in vub300_disconnect() and the probe
error path. Since vub300->interface is set to NULL before
timer_delete_sync(), any concurrently running timer will simply exit,
allowing the synchronous wait to complete safely.

Additionally, fix similar issues with sg_transfer_timer. In
__command_read_data() and __command_write_data(), replace timer_delete()
with timer_delete_sync() to prevent the timer callback from running
concurrently after the function returns. In __command_write_data(), ensure
the timer is unconditionally stopped even if an error occurs.

Fixes: 88095e7b473a ("mmc: Add new VUB300 USB-to-SD/SDIO/MMC driver")
Assisted-by: Gemini:gemini-3.5-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+0e06aa1bdc6495bac24b@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0e06aa1bdc6495bac24b
Link: https://syzkaller.appspot.com/ai_job?id=dcef6af0-9740-47ea-949c-72048301deb8
To: <linux-mmc@vger.kernel.org>
To: "Ulf Hansson" <ulfh@kernel.org>
To: "Tony Olech" <tony.olech@elandigitalsystems.com>
Cc: "Johan Hovold" <johan@kernel.org>
Cc: "Guangshuo Li" <lgs201920130244@gmail.com>
Cc: <linux-kernel@vger.kernel.org>
Cc: "Runyu Xiao" <runyu.xiao@seu.edu.cn>

---
diff --git a/drivers/mmc/host/vub300.c b/drivers/mmc/host/vub300.c
index 2dae474dc..9b08755cc 100644
--- a/drivers/mmc/host/vub300.c
+++ b/drivers/mmc/host/vub300.c
@@ -744,7 +744,7 @@ static void vub300_inactivity_timer_expired(struct timer_list *t)
 	struct vub300_mmc_host *vub300 = timer_container_of(vub300, t,
 							    inactivity_timer);
 	if (!vub300->interface) {
-		kref_put(&vub300->kref, vub300_delete);
+		/* timer_delete_sync() will wait for us */
 	} else if (vub300->cmd) {
 		mod_timer(&vub300->inactivity_timer, jiffies + HZ);
 	} else {
@@ -1453,7 +1453,7 @@ static int __command_read_data(struct vub300_mmc_host *vub300,
 						  (linear_length / 16384));
 			add_timer(&vub300->sg_transfer_timer);
 			usb_sg_wait(&vub300->sg_request);
-			timer_delete(&vub300->sg_transfer_timer);
+			timer_delete_sync(&vub300->sg_transfer_timer);
 			if (vub300->sg_request.status < 0) {
 				cmd->error = vub300->sg_request.status;
 				data->bytes_xfered = 0;
@@ -1570,10 +1570,10 @@ static int __command_write_data(struct vub300_mmc_host *vub300,
 							   linear_length / 16384);
 			add_timer(&vub300->sg_transfer_timer);
 			usb_sg_wait(&vub300->sg_request);
+			timer_delete_sync(&vub300->sg_transfer_timer);
 			if (cmd->error) {
 				data->bytes_xfered = 0;
 			} else {
-				timer_delete(&vub300->sg_transfer_timer);
 				if (vub300->sg_request.status < 0) {
 					cmd->error = vub300->sg_request.status;
 					data->bytes_xfered = 0;
@@ -2327,7 +2327,6 @@ static int vub300_probe(struct usb_interface *interface,
 	INIT_WORK(&vub300->deadwork, vub300_deadwork_thread);
 	kref_init(&vub300->kref);
 	timer_setup(&vub300->sg_transfer_timer, vub300_sg_timed_out, 0);
-	kref_get(&vub300->kref);
 	timer_setup(&vub300->inactivity_timer,
 		    vub300_inactivity_timer_expired, 0);
 	vub300->inactivity_timer.expires = jiffies + HZ;
@@ -2350,6 +2349,7 @@ static int vub300_probe(struct usb_interface *interface,
 
 err_stop_io:
 	vub300->interface = NULL;
+	timer_delete_sync(&vub300->inactivity_timer);
 	kref_put(&vub300->kref, vub300_delete);
 
 	return retval;
@@ -2385,6 +2385,7 @@ static void vub300_disconnect(struct usb_interface *interface)
 			/* prevent more I/O from starting */
 			vub300->interface = NULL;
 			mmc_remove_host(mmc);
+			timer_delete_sync(&vub300->inactivity_timer);
 			kref_put(&vub300->kref, vub300_delete);
 			pr_info("USB vub300 remote SDIO host controller[%d]"
 				" now disconnected", ifnum);


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
