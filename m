Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792439406;
	b=wg6LfTIZm8+Dr6TfBLpgMqTm1dxUTjs+xd4D3afWDdPcXSGNPcPqYscteXOfw0YgR/5B
	 JdLlcgyN2Iul7lapH06PpRTl8zY1kQEHC6bzbqLrft70ssUgHTdln+bhWRXKpY+1SChEo
	 AhfjpOted9Jzt/RIHSg28VJA2vz+lxkUHOekpBxmMRTLpuLU5KNbf8qssSFBXcB1kk7XD
	 TnwwiLan222e9qChhR6eh4KzwmtjnSBAa3XqNI+s3jaqwAnDLfude9AUjSYKVGX8BUWBe
	 ZSIRxec77yH4yrIcejABTZateYR1J8OuxPm28PxbV5nkLKJMDWKeEqpG5y1pl6vUSXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792439406;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Message-ID:MIME-Version:
	 Content-Type:Content-Transfer-Encoding:Date;
	bh=SI9lXgT3Nbfazj6/OdVSE5aF1IYpqo7n/NNKKa5cAyk=;
	b=z7It8/B/3nU1P6aknDvgz+AcT8ES/FV0/QeRrcamCjbDfYjwAm/XbYFD07G0sMsKkTEh
	 S4RZGdbFfTPDx/3pw7O29sMqQip24YDYrRofnjrkn5x2XxSIssfwsFOm8C2lWVH02gc3x
	 EnFxDGVl66WA/DhvJghXxuAv4768G3K9NlG/xKFUhbzFHckZQoQD1HBD2LUDh9oYjANwk
	 okvvOBdPlnvbrEz0cuWaBEOnU5mgGZymYS6GOYb9+1ZKp4yhSFD7hLE10vc91NjJH0ZNM
	 1PtS4fMP6tJ80dl3LKT/7htuhIeYcx4RsS9m5nI02FZuFqvx9KQLOMkot9qo3AvcgfQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZgfERLIU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with UTF8SMTPS id 318BE606A31B
	for <syzbot@lists.linux.dev>; Mon, 19 Oct 2026 19:50:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=ZgfERLIU
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id 9E3DC1F000C5;
	Mon, 19 Oct 2026 19:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792439405;
	bh=SI9lXgT3Nbfazj6/OdVSE5aF1IYpqo7n/NNKKa5cAyk=;
	h=From:To:Cc:Subject:Date;
	b=ZgfERLIUNrzUpow2m8UXz94UlU1Au20pOhIWqzeWPb5pwDacOQene2YCp5RY/aVWd
	 uh7WbCHSKOyeAuN5DAbedEn/CBEKbwyry2FUEx6eY28Umm8OG5cyJ1bd5LQS6V1uwN
	 HgUqtbu94Eg/rYxsoLEgxJQlTY0IoOqnHWRc1KJI5P732AP0EXBGDuz/+iIV1nKR3t
	 ZsY/V/EBynh0V383XlG/jVu3MWhY4y6kJC3WU0zQbxv46CQ1d2nRP1XXQTS8K3zflL
	 GR/djlLiSPnOYFLeg7uclvNC66+FMnDgFa2JWBkvszR8jaMIJ0y+Ixl2auIYfa2GRB
	 Uk0YUen2XOfzg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] x86/mce: Synchronize sysfs attribute updates with CPU hotplug
Message-ID: <ec23439a-5aa8-41c1-93b9-d38495e43b4f@mail.kernel.org>
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Post: <mailto:syzbot@lists.linux.dev>
List-Help: <mailto:syzbot+help@lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
List-Owner: <mailto:syzbot+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Mon, 19 Oct 2026 19:50:05 +0000 (UTC)

During CPU hotplug teardown, when an AP reaches CPUHP_AP_ONLINE_DYN,
mce_cpu_pre_down() executes on the dying CPU, calling mce_disable_cpu() and
timer_delete_sync() to disarm its per-CPU pinned MCE timer. However, the
dying CPU remains in cpu_online_mask until the later CPUHP_TEARDOWN_CPU
state. Sysfs write handlers modifying MCE attributes (such as
check_interval, bank*, ignore_ce, or cmci_disabled) serialize among
themselves via mce_sysfs_mutex and reinitialize MCE state across all online
CPUs using on_each_cpu(mce_cpu_restart, ...) or on_each_cpu(mce_enable_ce,
...). Because these sysfs handlers have no synchronization with CPU
hotplug, an IPI can execute on the dying CPU between mce_cpu_pre_down() and
CPUHP_TEARDOWN_CPU, re-arming its per-CPU timer via
__mcheck_cpu_init_timer().

When the dying CPU later reaches CPUHP_TIMERS_PREPARE, timers_dead_cpu()
migrates any remaining pending timers from the dead CPU to an online CPU
(such as CPU 0). When the migrated timer fires on CPU 0, mce_timer_fn()
triggers a warning because the passed timer does not match CPU 0's per-CPU
timer pointer. Furthermore, mce_timer_fn() re-arms the timer on the current
CPU, permanently anchoring the offlined CPU's timer onto CPU 0's timer
wheel where it repeatedly fires:

WARNING: CPU: 0 PID: 0 at arch/x86/kernel/cpu/mce/core.c:1770
mce_timer_fn+0x23f/0x280
RIP: 0010:mce_timer_fn+0x23f/0x280 arch/x86/kernel/cpu/mce/core.c:1770
Call Trace:
 <IRQ>
 call_timer_fn+0x18d/0x5f0 kernel/time/timer.c:1748
 expire_timers kernel/time/timer.c:1799 [inline]
 __run_timers kernel/time/timer.c:2374 [inline]
 __run_timer_base+0x652/0x8b0 kernel/time/timer.c:2386
 run_timer_softirq+0x67/0x170 kernel/time/timer.c:2403
 handle_softirqs+0x226/0x860 kernel/softirq.c:645
 __do_softirq kernel/softirq.c:679 [inline]
 invoke_softirq kernel/softirq.c:519 [inline]
 __irq_exit_rcu+0xcb/0x220 kernel/softirq.c:758
 irq_exit_rcu+0x9/0x30 kernel/softirq.c:775
 sysvec_apic_timer_interrupt+0xa6/0xc0 arch/x86/kernel/apic/apic.c:1062
 </IRQ>

Acquiring cpus_read_lock() inside the sysfs write handlers is not viable
because it causes an ABBA deadlock against CPU hotplug teardown: CPU
hotplug holds cpu_hotplug_lock and waits for active kernfs references to
drain in device_remove_file(), while sysfs write callbacks are invoked with
an active kernfs reference held. Taking cpu_hotplug_lock inside the sysfs
callback would invert this locking order.

Fix this by synchronizing MCE CPU hotplug callbacks with mce_sysfs_mutex
and restricting sysfs broadcasts to the mce_device_initialized cpumask. In
mce_cpu_online() and mce_cpu_pre_down(), acquire mce_sysfs_mutex around the
MCE CPU state changes, timer setup/teardown, and mce_device_initialized
updates, while keeping sysfs device creation and removal outside the mutex
to preserve lock ordering. In mce_cpu_pre_down(), clearing the CPU from
mce_device_initialized and disarming its timer under mce_sysfs_mutex
ensures that concurrent sysfs handlers cannot re-arm the timer on the dying
CPU. In mce_restart(), set_ignore_ce(), and set_cmci_disabled(), replace
on_each_cpu() with on_each_cpu_mask(mce_device_initialized, ...), and
update mce_timer_delete_all() to iterate over mce_device_initialized
instead of cpu_online_mask. Finally, decouple mce_device_remove() from
mce_device_initialized by checking whether the per-CPU device exists, and
remove the redundant timer_setup() in __mcheck_cpu_init_timer().

Fixes: b3b7c4795cca ("x86/MCE: Serialize sysfs changes")
Assisted-by: Gemini:gemini-4-argon Gemini:gemini-3.8-flash syzbot
Reported-by: syzbot+9d17de59c48d71bd6824@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=9d17de59c48d71bd6824
Link: https://syzkaller.appspot.com/ai_job?id=15d1ceb9-80ec-4eda-9931-32ae20560024
To: "Borislav Petkov" <bp@alien8.de>
To: "Dave Hansen" <dave.hansen@linux.intel.com>
To: <linux-edac@vger.kernel.org>
To: "Ingo Molnar" <mingo@redhat.com>
To: "Thomas Gleixner" <tglx@kernel.org>
To: "Tony Luck" <tony.luck@intel.com>
To: <x86@kernel.org>
To: "Seunghun Han" <kkamagui@gmail.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: <linux-kernel@vger.kernel.org>

---
diff --git a/arch/x86/kernel/cpu/mce/core.c b/arch/x86/kernel/cpu/mce/core.c
index 39f238952..b9c5acd7d 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -63,6 +63,8 @@
 /* sysfs synchronization */
 static DEFINE_MUTEX(mce_sysfs_mutex);
 
+static cpumask_var_t mce_device_initialized;
+
 #define CREATE_TRACE_POINTS
 #include <trace/events/mce.h>
 
@@ -1813,7 +1815,7 @@ static void mce_timer_delete_all(void)
 {
 	int cpu;
 
-	for_each_online_cpu(cpu)
+	for_each_cpu(cpu, mce_device_initialized)
 		timer_delete_sync(&per_cpu(mce_timer, cpu));
 }
 
@@ -2091,7 +2093,6 @@ static void __mcheck_cpu_init_timer(void)
 {
 	struct timer_list *t = this_cpu_ptr(&mce_timer);
 
-	timer_setup(t, mce_timer_fn, TIMER_PINNED);
 	mce_start_timer(t);
 }
 
@@ -2462,7 +2463,7 @@ static void mce_cpu_restart(void *data)
 static void mce_restart(void)
 {
 	mce_timer_delete_all();
-	on_each_cpu(mce_cpu_restart, NULL, 1);
+	on_each_cpu_mask(mce_device_initialized, mce_cpu_restart, NULL, 1);
 	mce_schedule_work();
 }
 
@@ -2553,12 +2554,12 @@ static ssize_t set_ignore_ce(struct device *s,
 		if (new) {
 			/* disable ce features */
 			mce_timer_delete_all();
-			on_each_cpu(mce_disable_cmci, NULL, 1);
+			on_each_cpu_mask(mce_device_initialized, mce_disable_cmci, NULL, 1);
 			mca_cfg.ignore_ce = true;
 		} else {
 			/* enable ce features */
 			mca_cfg.ignore_ce = false;
-			on_each_cpu(mce_enable_ce, (void *)1, 1);
+			on_each_cpu_mask(mce_device_initialized, mce_enable_ce, (void *)1, 1);
 		}
 	}
 	mutex_unlock(&mce_sysfs_mutex);
@@ -2579,12 +2580,12 @@ static ssize_t set_cmci_disabled(struct device *s,
 	if (mca_cfg.cmci_disabled ^ !!new) {
 		if (new) {
 			/* disable cmci */
-			on_each_cpu(mce_disable_cmci, NULL, 1);
+			on_each_cpu_mask(mce_device_initialized, mce_disable_cmci, NULL, 1);
 			mca_cfg.cmci_disabled = true;
 		} else {
 			/* enable cmci */
 			mca_cfg.cmci_disabled = false;
-			on_each_cpu(mce_enable_ce, NULL, 1);
+			on_each_cpu_mask(mce_device_initialized, mce_enable_ce, NULL, 1);
 		}
 	}
 	mutex_unlock(&mce_sysfs_mutex);
@@ -2641,8 +2642,6 @@ static struct device_attribute *mce_device_attrs[] = {
 	NULL
 };
 
-static cpumask_var_t mce_device_initialized;
-
 static void mce_device_release(struct device *dev)
 {
 	kfree(dev);
@@ -2682,7 +2681,6 @@ static int mce_device_create(unsigned int cpu)
 		if (err)
 			goto error2;
 	}
-	cpumask_set_cpu(cpu, mce_device_initialized);
 	per_cpu(mce_device, cpu) = dev;
 
 	return 0;
@@ -2703,7 +2701,7 @@ static void mce_device_remove(unsigned int cpu)
 	struct device *dev = per_cpu(mce_device, cpu);
 	int i;
 
-	if (!cpumask_test_cpu(cpu, mce_device_initialized))
+	if (!dev)
 		return;
 
 	for (i = 0; mce_device_attrs[i]; i++)
@@ -2713,7 +2711,6 @@ static void mce_device_remove(unsigned int cpu)
 		device_remove_file(dev, &mce_bank_devs[i].attr);
 
 	device_unregister(dev);
-	cpumask_clear_cpu(cpu, mce_device_initialized);
 	per_cpu(mce_device, cpu) = NULL;
 }
 
@@ -2761,8 +2758,11 @@ static int mce_cpu_online(unsigned int cpu)
 
 	mce_device_create(cpu);
 	mce_threshold_create_device(cpu);
+	mutex_lock(&mce_sysfs_mutex);
+	cpumask_set_cpu(cpu, mce_device_initialized);
 	mce_reenable_cpu();
 	mce_start_timer(t);
+	mutex_unlock(&mce_sysfs_mutex);
 	return 0;
 }
 
@@ -2770,8 +2770,11 @@ static int mce_cpu_pre_down(unsigned int cpu)
 {
 	struct timer_list *t = this_cpu_ptr(&mce_timer);
 
+	mutex_lock(&mce_sysfs_mutex);
+	cpumask_clear_cpu(cpu, mce_device_initialized);
 	mce_disable_cpu();
 	timer_delete_sync(t);
+	mutex_unlock(&mce_sysfs_mutex);
 	mce_threshold_remove_device(cpu);
 	mce_device_remove(cpu);
 	return 0;


base-commit: c03c1a14507dfaf8b856c2608f9ac216021fc222
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
