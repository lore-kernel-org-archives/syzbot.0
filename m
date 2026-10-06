Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A24C7376A01
	for <syzbot@lists.linux.dev>; Tue,  6 Oct 2026 18:01:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791309703; cv=none; b=LHOtH/UTCWtghTAh/tAnKSFcs/ik+Lu2mZX5KqjNhC8POlT9r/BRDuyTuzOvuKymgfrVFuWPDAsSh9TFvAd5FZ5YwgC4bodcEKULW7112FQGGRvhB6SpLzOXJJaLs6RwOjWm6AIyhYxl+0rAfjbvBBfp4ebLYy3eCHr4X+Sq6aI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791309703; c=relaxed/simple;
	bh=7cAvbWatm3VFHzw7Qca6shqDi7VmMi+oeojtQbfHFG4=;
	h=From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:Date; b=bincbnO+bfZCg+bY0DjU3tDOFZo+jMSum1T2N83YPQ1gNTl0SlQotgEwdEhaQg4Ca8jPcRLe5bBwoiwLgu6yAxzmIaGLNjwQvtKtypLteTddvhuYR061hwYGzm3bQaLZGe1E2Y89TEWd1E2Baoy9eIkaaphQLMQ4hKpNjbijPF4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=hSABmIfD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="hSABmIfD"
Received: by smtp.kernel.org (Postfix) with UTF8SMTPSA id CE7F01F0089D;
	Tue,  6 Oct 2026 18:01:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1791309700;
	bh=EaU+LBLkcNEVFo83ScPOXu9rOqmF8dnh+b9yjr0W1l8=;
	h=From:To:Cc:Subject:Date;
	b=hSABmIfD1jxlV1r7YCVVAja3YWgdQy7vZp6ABYJ0sR7vUlhjwWvAaQO6E7PIyzfFX
	 u5WI5I01VzKhkV760s1ahmA08buHApKn9zJrnHtWWS9wC5FiyZsKe3e/f6WsnKPMvG
	 JgLRQStBppBoi3SLyvclsZsukno2SxfcrePceU+92itR+3kpaILjKc+77N+QocOtyN
	 lE5vWbl26a6CZ6OxW1M8u9I9PTD8P7tWF8AV04y5sGA4sPijyHpTgoLzbRgEiMcUHs
	 KzEAj+fG16N9qhBRLNa2J+Xpzn1ohDtlnYb5T2aGOk42eg7ltTkx64WK8/BVGA6mU6
	 et1E+by1BdTQg==
From: "syzbot" <syzbot@kernel.org>
To: syzkaller-upstream-moderation@googlegroups.com
Cc: syzbot@lists.linux.dev
Subject: [PATCH RFC] x86/mce: Synchronize sysfs reconfiguration against CPU hotplug
Message-ID: <eca86078-6360-4453-9893-a384d3df0065@mail.kernel.org>
Precedence: bulk
X-Mailing-List: syzbot@lists.linux.dev
List-Id: <syzbot.lists.linux.dev>
List-Subscribe: <mailto:syzbot+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:syzbot+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Date: Tue,  6 Oct 2026 18:01:40 +0000 (UTC)

When offlining a CPU, the CPU hotplug teardown callback mce_cpu_pre_down()
is invoked at CPUHP_AP_ONLINE_DYN to disable MCE reporting and delete the
per-CPU timer via timer_delete_sync(). However, the CPU remains marked in
cpu_online_mask until the later CPUHP_TEARDOWN_CPU state. If a user
concurrently updates MCE configuration settings via sysfs (such as
ignore_ce, cmci_disabled, check_interval, or bank controls), the sysfs
handlers broadcast configuration changes across all online CPUs using
on_each_cpu(). Because cpus_read_lock() is not held by the sysfs store
handlers, an offlining CPU that is still present in cpu_online_mask can
receive the IPI after its timer has already been deactivated. The IPI
handler (such as mce_enable_ce() or mce_cpu_restart()) calls
__mcheck_cpu_init_timer(), which re-arms the timer on the dying CPU. The
CPU then finishes the offline teardown and halts with an active timer left
in the timer wheel.

When the CPU is subsequently brought back online, identify_secondary_cpu()
calls mcheck_cpu_init() -> __mcheck_cpu_setup_timer(), which invokes
timer_setup() on the already active timer, triggering a debugobjects
warning:

ODEBUG: init active (active state 0) object: ffff88827be234a0 object type:
timer_list hint: mce_timer_fn+0x0/0x280
WARNING: lib/debugobjects.c:632 at debug_print_object+0xec/0x230
lib/debugobjects.c:629
Call Trace:
 <TASK>
 __debug_object_init+0x224/0x350 lib/debugobjects.c:818
 timer_init_key+0x41/0x2c0 kernel/time/timer.c:880
 __mcheck_cpu_setup_timer arch/x86/kernel/cpu/mce/core.c:2087 [inline]
 mcheck_cpu_init+0x3dc/0x600 arch/x86/kernel/cpu/mce/core.c:2262
 identify_cpu+0x1f2c/0x3940 arch/x86/kernel/cpu/common.c:2126
 identify_secondary_cpu+0xaa/0x160 arch/x86/kernel/cpu/common.c:2187
 ap_starting+0x9c/0x150 arch/x86/kernel/smpboot.c:190
 start_secondary+0x66/0x110 arch/x86/kernel/smpboot.c:280
 common_startup_64+0x13e/0x157
 </TASK>

Fix this by acquiring cpus_read_lock() around mce_sysfs_mutex in the sysfs
store handlers (set_bank(), set_ignore_ce(), set_cmci_disabled(), and
store_int_with_restart()). Holding cpus_read_lock() serializes sysfs
reconfigurations against CPU hotplug, ensuring that CPUs undergoing
teardown do not receive broadcast IPIs to re-enable or re-arm MCE timers
after mce_cpu_pre_down() has cleaned them up.

Fixes: b3b7c4795cca ("x86/MCE: Serialize sysfs changes")
Assisted-by: Gemini:gemini-3.8-flash Gemini:gemini-3.1-pro-preview syzbot
Reported-by: syzbot+edc6b57cbed1fb72d0f9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=edc6b57cbed1fb72d0f9
Link: https://syzkaller.appspot.com/ai_job?id=c8580209-1c6b-40d9-834d-2e3ce14f6111
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
index 39f238952..6ba802a5c 100644
--- a/arch/x86/kernel/cpu/mce/core.c
+++ b/arch/x86/kernel/cpu/mce/core.c
@@ -2532,9 +2532,11 @@ static ssize_t set_bank(struct device *s, struct device_attribute *attr,
 
 	b->ctl = new;
 
+	cpus_read_lock();
 	mutex_lock(&mce_sysfs_mutex);
 	mce_restart();
 	mutex_unlock(&mce_sysfs_mutex);
+	cpus_read_unlock();
 
 	return size;
 }
@@ -2548,6 +2550,7 @@ static ssize_t set_ignore_ce(struct device *s,
 	if (kstrtou64(buf, 0, &new) < 0)
 		return -EINVAL;
 
+	cpus_read_lock();
 	mutex_lock(&mce_sysfs_mutex);
 	if (mca_cfg.ignore_ce ^ !!new) {
 		if (new) {
@@ -2562,6 +2565,7 @@ static ssize_t set_ignore_ce(struct device *s,
 		}
 	}
 	mutex_unlock(&mce_sysfs_mutex);
+	cpus_read_unlock();
 
 	return size;
 }
@@ -2575,6 +2579,7 @@ static ssize_t set_cmci_disabled(struct device *s,
 	if (kstrtou64(buf, 0, &new) < 0)
 		return -EINVAL;
 
+	cpus_read_lock();
 	mutex_lock(&mce_sysfs_mutex);
 	if (mca_cfg.cmci_disabled ^ !!new) {
 		if (new) {
@@ -2588,6 +2593,7 @@ static ssize_t set_cmci_disabled(struct device *s,
 		}
 	}
 	mutex_unlock(&mce_sysfs_mutex);
+	cpus_read_unlock();
 
 	return size;
 }
@@ -2602,9 +2608,11 @@ static ssize_t store_int_with_restart(struct device *s,
 	if (check_interval == old_check_interval)
 		return ret;
 
+	cpus_read_lock();
 	mutex_lock(&mce_sysfs_mutex);
 	mce_restart();
 	mutex_unlock(&mce_sysfs_mutex);
+	cpus_read_unlock();
 
 	return ret;
 }


base-commit: a90ee4305c4a5df72c11b31dacfdc76e00fcf78a
-- 
This is an AI-generated patch subject to moderation.
Reply with '#syz upstream' to Sign-off the patch as a human author
and send it to the upstream kernel mailing lists.
Reply with '#syz reject' to reject it ('#syz unreject' to undo).

See https://goo.gle/syzbot-ai-patches for information about AI-generated patches.
You can comment on the patch as usual, syzbot will try to address
the comments and send a new version of the patch if necessary.
syzbot engineers can be reached at syzkaller@googlegroups.com.
